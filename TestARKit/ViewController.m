//
//  ViewController.m
//  TestARKit
//
//  Created by suwei on 2017/6/13.
//  Copyright © 2017年 ARKit. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <ARSCNViewDelegate,ARSessionDelegate>

@property (nonatomic, strong) IBOutlet ARSCNView *sceneView;

@property (nonatomic, strong) ARSession *arSession;

@property (nonatomic, strong) ARWorldTrackingSessionConfiguration *arSessionConfiguration;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Set the view's delegate
    self.sceneView.delegate = self;
    
    // Show statistics such as fps and timing information
    self.sceneView.showsStatistics = YES;
    
    // Create a new scene
//    SCNScene *scene = [SCNScene sceneNamed:@"art.scnassets/ship.scn"];
    
    // Set the scene to the view
//    self.sceneView.scene = scene;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.sceneView.session = self.arSession;
    
    [self.sceneView.session runWithConfiguration:self.arSessionConfiguration];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    // Pause the view's session
    [self.sceneView.session pause];
}

- (ARSession *)arSession {
    if (!_arSession) {
        _arSession = [[ARSession alloc] init];
        _arSession.delegate = self;
    }
    return _arSession;
}

- (ARWorldTrackingSessionConfiguration *)arSessionConfiguration {
    if (!_arSessionConfiguration) {
        _arSessionConfiguration = [[ARWorldTrackingSessionConfiguration alloc] init];
        _arSessionConfiguration.lightEstimationEnabled = YES;
        _arSessionConfiguration.planeDetection = ARPlaneDetectionHorizontal;
    }
    return _arSessionConfiguration;
}

#pragma mark - ARSCNViewDelegate

/*
// Override to create and configure nodes for anchors added to the view's session.
- (SCNNode *)renderer:(id<SCNSceneRenderer>)renderer nodeForAnchor:(ARAnchor *)anchor {
    SCNNode *node = [SCNNode new];
 
    // Add geometry to the node...
 
    return node;
}
*/

- (void)renderer:(id <SCNSceneRenderer>)renderer
      didAddNode:(SCNNode *)node
       forAnchor:(ARAnchor *)anchor {
    if ([anchor isMemberOfClass:[ARPlaneAnchor class]]) {
        NSLog(@"捕捉到");
        
        ARPlaneAnchor *planeAnchor = (ARPlaneAnchor *)anchor;
        
        SCNBox *planeBox = [SCNBox boxWithWidth:planeAnchor.extent.x*0.2
                                         height:0
                                         length:planeAnchor.extent.x*0.2
                                  chamferRadius:0];
        
        SCNNode *planeNode = [SCNNode nodeWithGeometry:planeBox];
        planeNode.position = SCNVector3Make(planeAnchor.center.x, 0, planeAnchor.center.z);
        [node addChildNode:planeNode];
        
        //添加场景
        SCNScene *scene = [SCNScene sceneNamed:@"air.scnassets/cup/cup.scn"];
        
        SCNNode *cupNode = scene.rootNode.childNodes[0];
        cupNode.position = SCNVector3Make(planeAnchor.center.x, 0, planeAnchor.center.z);
        [node addChildNode:cupNode];
    }
}

- (void)session:(ARSession *)session didFailWithError:(NSError *)error {
    // Present an error message to the user
    
}

- (void)sessionWasInterrupted:(ARSession *)session {
    // Inform the user that the session has been interrupted, for example, by presenting an overlay
    
}

- (void)sessionInterruptionEnded:(ARSession *)session {
    // Reset tracking and/or remove existing anchors if consistent tracking is required
    
}

#pragma mark - ARSessionDelegate
- (void)session:(ARSession *)session didUpdateFrame:(ARFrame *)frame {
//    NSLog(@"相机移动");
}

- (void)session:(ARSession *)session didAddAnchors:(NSArray<ARAnchor*>*)anchors {
    NSLog(@"添加锚点");
}

- (void)session:(ARSession *)session didUpdateAnchors:(NSArray<ARAnchor*>*)anchors {
    NSLog(@"更新锚点");
}

- (void)session:(ARSession *)session didRemoveAnchors:(NSArray<ARAnchor*>*)anchors {
    NSLog(@"移除锚点");
}

@end
