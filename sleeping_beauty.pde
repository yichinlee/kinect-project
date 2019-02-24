// input_file contain the matrix and skeleton data.

//[For Computational Media Students] ***
//Replace your txt file name here
String input_file = "skeleton_2015_12_8_7_28_Yi Ling_4_1.txt";

// Show structures in draw_start_structure for the first start_time_position seconds.
double prepare_time = 4;
double start_1 = 7;
double start_2 = 12;
double start_3 = 16;
double start_4 = 20;
double withleg_structure = 33;

double tex_1 = 43.5;
double tex_2 = 52;
double soft_again = 60;
double oppo = 67;

double second_main_structure = 82;
double ending_1_structure = 100;   //start to fade
double ending_2_structure = 120;

float frame_rate = 60;

float easingx = 0.5; // Numbers 0.0 to 1.0
float easingy = 0.25; // Numbers 0.0 to 1.0
float easingz = 0.25; // Numbers 0.0 to 1.0

// input_matrix can also be rotated one
// e.g. "0.319196,0.0774024,0.376992,0,-0.279629,0.383165,0.158089,0,-0.264428,-0.311758,0.287897,0,0,0,-400,1,0.028"
String input_matrix = "1,0,0,0,0,1,0,0,0,0,1,0,0,0,0,5";

//Posture.
String input_skeleton = "";

BufferedReader reader;
float[] matrix = new float[16];

int frame_count = 0;
float sphere_size = 0;

// 0: head, 1: neck, 2: left_shoulder, 3: left_elbow, 4: left_hand
// 5: right_shoulder, 6: right_elbow, 7: right_hand, 8: torso, 9: left_hip
// 10: left_knee, 11: left_foot, 12: right_hip, 13: right_knee, 14: right_foot
// 15: spine_mid, 16: spine_shoulder
ArrayList<PVector> skeleton_points = new ArrayList<PVector>();
ArrayList<PVector> read_skeleton_points = new ArrayList<PVector>();

void setup() {
  background(200);
  fullScreen(P3D);
  reader = createReader(input_file);
  frameRate(frame_rate);
}

void draw() {
  background(200);
  //strokeWeight(3);
  try {
    // read box rotation marix and skeleton position from file.
    String input_line;
    if ((input_line = reader.readLine()) != null) {   
      if (input_line.charAt(0) == 'm') {
        input_matrix = input_line.substring(1);
        read_matrix();
      } else {
        input_skeleton = input_line.substring(0);
        read_skeleton_points.clear();    //clear up arraylist 
        read_skeleton();

        // Draw skeleton.
        pushMatrix();
        resetMatrix(); 
        translate(0, 0, -200);
        applyMatrix(1, 0, 0, matrix[12], 
          0, 1, 0, matrix[13], 
          0, 0, 1, matrix[14], 
          0, 0, 0, matrix[15]);
        draw_skeleton();

        double second = frame_count / frame_rate;
        frame_count++;
        if (second < prepare_time) {
        } else if (second >= prepare_time && second < start_1) {


          draw_start_1_structure();
        } else if (second >= start_1 && second < start_2) {

          draw_start_1_structure();
          draw_start_2_structure();
        } else if (second >= start_2 && second < start_3) {

          draw_start_1_structure();
          draw_start_2_structure();
          draw_start_3_structure();
        } else if (second >= start_3 && second < start_4) { 


          draw_start_1_structure();
          draw_start_2_structure();
          draw_start_3_structure();
          draw_start_4_structure();
        } else if (second >=  start_4 && second < withleg_structure) {  

          draw_start_1_structure();
          draw_start_2_structure();
          draw_start_3_structure();
          draw_start_4_structure();
          section2();
        } else if (second >= withleg_structure && second < tex_1) {   //strong music

          pushMatrix();

          scale(0.8);
          draw_start_1_structure();
          draw_start_2_structure();
          draw_start_3_structure();
          draw_start_4_structure();
          section2();
          popMatrix();

          pushMatrix();
          translate(0, -50, 0);
          draw_structure();
          popMatrix();
        } else if (second >= tex_1 && second < tex_2) {   //upper
          pushMatrix();
          scale(0.8);
          draw_start_1_structure();
          draw_start_2_structure();
          draw_start_3_structure();
          draw_start_4_structure();
          section2();
         
          popMatrix();

          pushMatrix();
          translate(0, -50, 0);
          draw_structure();
          popMatrix();
          
           tex_2();
        } else if (second >= tex_2 && second < soft_again) {   //upper

          draw_start_1_structure();
          draw_start_2_structure();
          draw_start_3_structure();
          draw_start_4_structure();
        } else if (second >= soft_again && second < oppo) {             //show graduatelly
          draw_start_1_structure();
          draw_start_2_structure();
          draw_start_3_structure();
          oppo_shape();
        } else if (second >= oppo && second < second_main_structure) {   //strong
          try_skeleton();
        } else if (second >= second_main_structure && second <  ending_1_structure) {    //ending_fading
          fill();
        } else if (second >= ending_1_structure && second < ending_2_structure) {    //ending_fading
          scale(0.8);
          fill();
        } else if (second >= ending_2_structure) {    //ending_fading
          scale(0.5);
          fill();
        } 
        popMatrix();

        // Draw box.
        pushMatrix();
        resetMatrix();
        translate(0, 0, -200);
        applyMatrix(matrix[0], matrix[4], matrix[8], matrix[12], 
          matrix[1], matrix[5], matrix[9], matrix[13], 
          matrix[2], matrix[6], matrix[10], matrix[14], 
          matrix[3], matrix[7], matrix[11], matrix[15]);
        //draw_box();
        popMatrix();
      }
    } else {
      noLoop();
    }
  } 
  catch(IOException e) {
  }    //Jave has exception

  //for Computational Media Students. Uncomment the following line when you are ready to record your video. ***
  //saveFrame("nameofyourstructure/frame-######.png");
}

void read_matrix() {
  String[] pieces = split(input_matrix, ",");
  for (int i = 0; i < 16; i++) {
    matrix[i] = Float.parseFloat(pieces[i]);
  }
}

void read_skeleton() {
  String[] pieces = split(input_skeleton, ",");
  for (int i = 0; i < 17*3; i+=3) {
    PVector point = new PVector(Float.parseFloat(pieces[i]), 
      -Float.parseFloat(pieces[i+1]), 
      Float.parseFloat(pieces[i+2]));
    read_skeleton_points.add(point);
    if (skeleton_points.size() < 17) {
      skeleton_points.add(point);
    }
  }
  for (int i = 0; i < 17; ++i) {
    skeleton_points.get(i).x += (read_skeleton_points.get(i).x - skeleton_points.get(i).x) * easingx;
    skeleton_points.get(i).y += (read_skeleton_points.get(i).y - skeleton_points.get(i).y) * easingy;
    skeleton_points.get(i).z += (read_skeleton_points.get(i).z - skeleton_points.get(i).z) * easingz;
  }
}

void draw_structure() { 
  noStroke();
  PImage img = loadImage("p2.jpg");
  float x1 = skeleton_points.get(2).x + (skeleton_points.get(6).x - skeleton_points.get(2).x)/4;
  float y1 = skeleton_points.get(3).y + (skeleton_points.get(9).y - skeleton_points.get(4).y)/3;
  float z1 = skeleton_points.get(3).z;

  float x2 = skeleton_points.get(15).x + (skeleton_points.get(6).y - skeleton_points.get(2).y)/2;
  float y2 = skeleton_points.get(15).y + (skeleton_points.get(10).y - skeleton_points.get(6).y)/5;
  float z2 = skeleton_points.get(15).z;

  float x3 = skeleton_points.get(2).x + (skeleton_points.get(7).x - skeleton_points.get(2).x)/2;
  float y3 = skeleton_points.get(12).y - (skeleton_points.get(13).y - skeleton_points.get(4).y)/2;
  float z3 = skeleton_points.get(6).z;

  float x4 = skeleton_points.get(13).x + 1.5*(skeleton_points.get(5).x - skeleton_points.get(2).x);
  float y4 = skeleton_points.get(5).y - (skeleton_points.get(7).y - skeleton_points.get(3).y)/10;
  float z4 = skeleton_points.get(12).z;
  //texture

  pushMatrix();
  beginShape();  //upper
  translate(0, 50, 0);
  scale(1.2);
  texture(img);
  vertex(skeleton_points.get(4).x, skeleton_points.get(4).y -30, skeleton_points.get(4).z);
  vertex(skeleton_points.get(0).x+50, skeleton_points.get(0).y-50, skeleton_points.get(0).z, 0);
  vertex(skeleton_points.get(7).x+50, skeleton_points.get(7).y-80, skeleton_points.get(7).z, width);
  vertex(x3, y3, z3, height);
  vertex(x1, y1, z1, 0);
  endShape(CLOSE);
  popMatrix();
}
void tex_2() {
  PImage img = loadImage("p2.jpg");
  beginShape();
  texture(img);
  vertex(skeleton_points.get(11).x, skeleton_points.get(11).y, skeleton_points.get(11).z, 0);
  //vertex(skeleton_points.get(8).x+30, skeleton_points.get(12).y, skeleton_points.get(12).z);
  vertex(skeleton_points.get(8).x+30, skeleton_points.get(12).y, skeleton_points.get(12).z+30, 200);
  vertex(skeleton_points.get(6).x, skeleton_points.get(12).y+50, skeleton_points.get(6).z, 300);
  //vertex(skeleton_points.get(6).x, skeleton_points.get(12).y+50, skeleton_points.get(6).z-20);
  endShape(CLOSE);

  beginShape();
  texture(img);

   vertex(skeleton_points.get(13).x, skeleton_points.get(13).y-30, skeleton_points.get(13).z, 300);
  vertex(skeleton_points.get(8).x+30, skeleton_points.get(12).y, skeleton_points.get(12).z+30, 0);
//vertex(skeleton_points.get(6).x, skeleton_points.get(12).y+50, skeleton_points.get(6).z);
   vertex(skeleton_points.get(6).x, skeleton_points.get(12).y+50, skeleton_points.get(6).z-20, 200);
  endShape(CLOSE);

  beginShape();
  texture(img);
  vertex(skeleton_points.get(14).x, skeleton_points.get(14).y, skeleton_points.get(14).z, 0);
   vertex(skeleton_points.get(13).x-10, skeleton_points.get(13).y-10, skeleton_points.get(13).z-20, 500);
  vertex(skeleton_points.get(13).x, skeleton_points.get(13).y-30, skeleton_points.get(13).z, 200);
vertex(skeleton_points.get(13).x+20, skeleton_points.get(13).y-10, skeleton_points.get(13).z-20, 200);
  endShape(CLOSE);
  
 
}


void section2() {  //link 2 part
  strokeWeight(0.5);
  float x1 = skeleton_points.get(2).x + (skeleton_points.get(6).x - skeleton_points.get(2).x)/4;
  float y1 = skeleton_points.get(3).y + (skeleton_points.get(9).y - skeleton_points.get(4).y)/3;
  float z1 = skeleton_points.get(3).z;

  float x2 = skeleton_points.get(15).x + (skeleton_points.get(6).y - skeleton_points.get(2).y)/2;
  float y2 = skeleton_points.get(15).y + (skeleton_points.get(10).y - skeleton_points.get(6).y)/5;
  float z2 = skeleton_points.get(15).z;

  float x3 = skeleton_points.get(2).x + (skeleton_points.get(7).x - skeleton_points.get(2).x)/2;
  float y3 = skeleton_points.get(12).y - (skeleton_points.get(13).y - skeleton_points.get(4).y)/2;
  float z3 = skeleton_points.get(6).z;

  float x4 = skeleton_points.get(13).x + 1.5*(skeleton_points.get(5).x - skeleton_points.get(2).x);
  float y4 = skeleton_points.get(5).y - (skeleton_points.get(7).y - skeleton_points.get(3).y)/10;
  float z4 = skeleton_points.get(12).z;

  float mx = skeleton_points.get(9).x;
  float my = skeleton_points.get(9).y;
  float mz = skeleton_points.get(9).z;
  strokeWeight(0.5);
  line(mx, my, mz, skeleton_points.get(4).x, skeleton_points.get(4).y, skeleton_points.get(4).z);
  line(mx, my, mz, skeleton_points.get(2).x, skeleton_points.get(2).y, skeleton_points.get(2).z);
  line(mx, my, mz, skeleton_points.get(2).x, skeleton_points.get(2).y, skeleton_points.get(5).z);
  line(mx, my, mz, x1, y1, skeleton_points.get(4).z);
  line(mx, my, mz, x1, y1, z1);
  line(mx, my, mz, x2, y2, z2);
  line(mx, my, mz, x3, y3, z3);
  line(mx, my, mz, x3, y3, skeleton_points.get(5).z);
  line(mx, my, mz, x4, y4, z4);
  line(mx, my, mz, x4, y4, skeleton_points.get(13).z);
  line(mx, my, mz, skeleton_points.get(7).x+50, skeleton_points.get(7).y, skeleton_points.get(7).z); 

  line(mx, my, mz, skeleton_points.get(11).x, skeleton_points.get(11).y, skeleton_points.get(11).z);
  line(mx, my, mz, skeleton_points.get(8).x+30, skeleton_points.get(12).y, skeleton_points.get(12).z);
  line(mx, my, mz, skeleton_points.get(8).x+30, skeleton_points.get(12).y, skeleton_points.get(12).z+30);
  line(mx, my, mz, skeleton_points.get(6).x, skeleton_points.get(12).y+50, skeleton_points.get(6).z);
  line(mx, my, mz, skeleton_points.get(6).x, skeleton_points.get(12).y+50, skeleton_points.get(6).z-20);
  line(mx, my, mz, skeleton_points.get(13).x, skeleton_points.get(13).y, skeleton_points.get(13).z+30);
  //leg part
  strokeWeight(2);
  beginShape();
  vertex(skeleton_points.get(11).x, skeleton_points.get(11).y, skeleton_points.get(11).z);
  vertex(skeleton_points.get(8).x+30, skeleton_points.get(12).y, skeleton_points.get(12).z);
  vertex(skeleton_points.get(8).x+30, skeleton_points.get(12).y, skeleton_points.get(12).z+30);

  vertex(skeleton_points.get(11).x, skeleton_points.get(11).y, skeleton_points.get(11).z);
  vertex(skeleton_points.get(8).x+30, skeleton_points.get(12).y, skeleton_points.get(12).z+30);
  vertex(skeleton_points.get(6).x, skeleton_points.get(12).y+50, skeleton_points.get(6).z);

  vertex(skeleton_points.get(11).x, skeleton_points.get(11).y, skeleton_points.get(11).z);
  vertex(skeleton_points.get(6).x, skeleton_points.get(12).y+50, skeleton_points.get(6).z);
  vertex(skeleton_points.get(6).x, skeleton_points.get(12).y+50, skeleton_points.get(6).z-20);

  vertex(skeleton_points.get(11).x, skeleton_points.get(11).y, skeleton_points.get(11).z);
  vertex(skeleton_points.get(6).x, skeleton_points.get(12).y+50, skeleton_points.get(6).z-20);
  vertex(skeleton_points.get(8).x+30, skeleton_points.get(12).y, skeleton_points.get(12).z);
  endShape();

  beginShape();
  vertex(skeleton_points.get(13).x, skeleton_points.get(13).y-30, skeleton_points.get(13).z);
  vertex(skeleton_points.get(8).x+30, skeleton_points.get(12).y, skeleton_points.get(12).z);
  vertex(skeleton_points.get(8).x+30, skeleton_points.get(12).y, skeleton_points.get(12).z+30);

  vertex(skeleton_points.get(13).x, skeleton_points.get(13).y-30, skeleton_points.get(13).z);
  vertex(skeleton_points.get(8).x+30, skeleton_points.get(12).y, skeleton_points.get(12).z+30);
  vertex(skeleton_points.get(6).x, skeleton_points.get(12).y+50, skeleton_points.get(6).z);

  vertex(skeleton_points.get(13).x, skeleton_points.get(13).y-30, skeleton_points.get(13).z);
  vertex(skeleton_points.get(6).x, skeleton_points.get(12).y+50, skeleton_points.get(6).z);
  vertex(skeleton_points.get(6).x, skeleton_points.get(12).y+50, skeleton_points.get(6).z-20);

  vertex(skeleton_points.get(13).x, skeleton_points.get(13).y-30, skeleton_points.get(13).z);
  vertex(skeleton_points.get(6).x, skeleton_points.get(12).y+50, skeleton_points.get(6).z-20);
  vertex(skeleton_points.get(8).x+30, skeleton_points.get(12).y, skeleton_points.get(12).z);
  endShape();

  beginShape();
  vertex(skeleton_points.get(14).x, skeleton_points.get(14).y, skeleton_points.get(14).z);
  vertex(skeleton_points.get(13).x, skeleton_points.get(13).y-30, skeleton_points.get(13).z);
  vertex(skeleton_points.get(13).x+20, skeleton_points.get(13).y-10, skeleton_points.get(13).z-20);

  vertex(skeleton_points.get(14).x, skeleton_points.get(14).y, skeleton_points.get(14).z); 
  vertex(skeleton_points.get(13).x+20, skeleton_points.get(13).y-10, skeleton_points.get(13).z-20);
  vertex(skeleton_points.get(13).x-10, skeleton_points.get(13).y-10, skeleton_points.get(13).z-20);

  vertex(skeleton_points.get(14).x, skeleton_points.get(14).y, skeleton_points.get(14).z);
  vertex(skeleton_points.get(13).x-10, skeleton_points.get(13).y-10, skeleton_points.get(13).z-20);
  vertex(skeleton_points.get(13).x, skeleton_points.get(13).y-30, skeleton_points.get(13).z);
  endShape();
  //line
  strokeWeight(0.5);
  line(skeleton_points.get(13).x+20, skeleton_points.get(13).y-10, skeleton_points.get(13).z-20, skeleton_points.get(6).x, skeleton_points.get(12).y+50, skeleton_points.get(6).z);
  line(skeleton_points.get(13).x+20, skeleton_points.get(13).y-10, skeleton_points.get(13).z-20, skeleton_points.get(6).x, skeleton_points.get(12).y+50, skeleton_points.get(6).z-20);
  line(skeleton_points.get(13).x-10, skeleton_points.get(13).y-10, skeleton_points.get(13).z-20, skeleton_points.get(8).x+30, skeleton_points.get(12).y, skeleton_points.get(12).z);
  line(skeleton_points.get(13).x-10, skeleton_points.get(13).y-10, skeleton_points.get(13).z-20, skeleton_points.get(8).x+30, skeleton_points.get(12).y, skeleton_points.get(12).z+30);
}

void draw_start_1_structure() {
  stroke(255);
  noFill();
  strokeWeight(2);
  float x1 = skeleton_points.get(2).x + (skeleton_points.get(6).x - skeleton_points.get(2).x)/4;
  float y1 = skeleton_points.get(3).y + (skeleton_points.get(9).y - skeleton_points.get(4).y)/3;
  float z1 = skeleton_points.get(3).z;
  beginShape();
  vertex(skeleton_points.get(4).x, skeleton_points.get(4).y, skeleton_points.get(4).z);
  vertex(skeleton_points.get(2).x, skeleton_points.get(2).y, skeleton_points.get(2).z);
  vertex(skeleton_points.get(2).x, skeleton_points.get(2).y, skeleton_points.get(5).z);

  vertex(skeleton_points.get(4).x, skeleton_points.get(4).y, skeleton_points.get(4).z);
  vertex(skeleton_points.get(2).x, skeleton_points.get(2).y, skeleton_points.get(5).z);
  vertex(x1, y1, z1);

  vertex(skeleton_points.get(4).x, skeleton_points.get(4).y, skeleton_points.get(4).z);
  vertex(x1, y1, z1);
  vertex(x1, y1, skeleton_points.get(4).z);

  vertex(skeleton_points.get(4).x, skeleton_points.get(4).y, skeleton_points.get(4).z);
  vertex(x1, y1, skeleton_points.get(4).z);
  vertex(skeleton_points.get(2).x, skeleton_points.get(2).y, skeleton_points.get(2).z);
  endShape();
}

void draw_start_2_structure() {
  strokeWeight(2);
  float x1 = skeleton_points.get(2).x + (skeleton_points.get(6).x - skeleton_points.get(2).x)/4;
  float y1 = skeleton_points.get(3).y + (skeleton_points.get(9).y - skeleton_points.get(4).y)/3;
  float z1 = skeleton_points.get(3).z;

  //middle_point
  float x2 = skeleton_points.get(15).x + (skeleton_points.get(6).y - skeleton_points.get(2).y)/2;
  float y2 = skeleton_points.get(15).y + (skeleton_points.get(10).y - skeleton_points.get(6).y)/5;
  float z2 = skeleton_points.get(15).z;

  beginShape();
  vertex(x2, y2, z2);
  vertex(skeleton_points.get(2).x, skeleton_points.get(2).y, skeleton_points.get(2).z);
  vertex(skeleton_points.get(2).x, skeleton_points.get(2).y, skeleton_points.get(5).z);

  vertex(x2, y2, z2);
  vertex(skeleton_points.get(2).x, skeleton_points.get(2).y, skeleton_points.get(5).z);
  vertex(x1, y1, z1);

  vertex(x2, y2, z2);
  vertex(x1, y1, z1);
  vertex(x1, y1, skeleton_points.get(4).z);

  vertex(x2, y2, z2);
  vertex(x1, y1, skeleton_points.get(4).z);
  vertex(skeleton_points.get(2).x, skeleton_points.get(2).y, skeleton_points.get(2).z);
  endShape();
}

void draw_start_3_structure() {
  strokeWeight(2);
  float x1 = skeleton_points.get(2).x + (skeleton_points.get(6).x - skeleton_points.get(2).x)/4;
  float y1 = skeleton_points.get(3).y + (skeleton_points.get(9).y - skeleton_points.get(4).y)/3;
  float z1 = skeleton_points.get(3).z;

  float x2 = skeleton_points.get(15).x + (skeleton_points.get(6).y - skeleton_points.get(2).y)/2;
  float y2 = skeleton_points.get(15).y + (skeleton_points.get(10).y - skeleton_points.get(6).y)/5;
  float z2 = skeleton_points.get(15).z;

  //layer_2
  float x3 = skeleton_points.get(2).x + (skeleton_points.get(7).x - skeleton_points.get(2).x)/2;
  float y3 = skeleton_points.get(12).y - (skeleton_points.get(13).y - skeleton_points.get(4).y)/2;
  float z3 = skeleton_points.get(6).z;

  float x4 = skeleton_points.get(13).x + 1.5*(skeleton_points.get(5).x - skeleton_points.get(2).x);
  float y4 = skeleton_points.get(5).y - (skeleton_points.get(7).y - skeleton_points.get(3).y)/10;
  float z4 = skeleton_points.get(12).z;

  beginShape();
  vertex(x2, y2, z2); 
  vertex(x3, y3, z3);
  vertex(x3, y3, skeleton_points.get(5).z);

  vertex(x2, y2, z2);
  vertex(x3, y3, skeleton_points.get(5).z);
  vertex(x4, y4, z4);

  vertex(x2, y2, z2); 
  vertex(x4, y4, z4);
  vertex(x4, y4, skeleton_points.get(13).z);

  vertex(x2, y2, z2);
  vertex(x4, y4, skeleton_points.get(13).z);
  vertex(x3, y3, z3);
  endShape();
}


void draw_start_4_structure() {
  strokeWeight(2);
  float x3 = skeleton_points.get(2).x + (skeleton_points.get(7).x - skeleton_points.get(2).x)/2;
  float y3 = skeleton_points.get(12).y - (skeleton_points.get(13).y - skeleton_points.get(4).y)/2;
  float z3 = skeleton_points.get(6).z;

  float x4 = skeleton_points.get(13).x + 1.5*(skeleton_points.get(5).x - skeleton_points.get(2).x);
  float y4 = skeleton_points.get(5).y - (skeleton_points.get(7).y - skeleton_points.get(3).y)/10;
  float z4 = skeleton_points.get(12).z;
  //connect to 7
  beginShape();
  vertex(skeleton_points.get(7).x+50, skeleton_points.get(7).y, skeleton_points.get(7).z); 
  vertex(x3, y3, z3);
  vertex(x3, y3, skeleton_points.get(5).z);

  vertex(skeleton_points.get(7).x+50, skeleton_points.get(7).y, skeleton_points.get(7).z); 
  vertex(x3, y3, skeleton_points.get(5).z);
  vertex(x4, y4, z4);

  vertex(skeleton_points.get(7).x+50, skeleton_points.get(7).y, skeleton_points.get(7).z); 
  vertex(x4, y4, z4);
  vertex(x4, y4, skeleton_points.get(13).z);

  vertex(skeleton_points.get(7).x+50, skeleton_points.get(7).y, skeleton_points.get(7).z); 
  vertex(x4, y4, skeleton_points.get(13).z);
  vertex(x3, y3, z3);
  endShape();
}

void fill() {
  //strokeWeight(2);
  PImage img = loadImage("p2.jpg");
  float x1, y1, z1;
  x1 = lerp(skeleton_points.get(3).x, skeleton_points.get(6).x, 0.8);
  y1 = lerp(skeleton_points.get(12).y, skeleton_points.get(1).y, 0.4);
  z1 = skeleton_points.get(6).x;


  float x2, y2, z2;
  x2 = lerp(skeleton_points.get(3).x, skeleton_points.get(6).x, 0.2);
  y2 = lerp(skeleton_points.get(9).y, skeleton_points.get(5).y, 0.7);
  z2 = skeleton_points.get(3).x;

  beginShape();
  texture(img);
  vertex(x1, y1, z1, 100);
  vertex(skeleton_points.get(5).x, skeleton_points.get(5).y, skeleton_points.get(5).z, 100);
  vertex(skeleton_points.get(2).x, skeleton_points.get(2).y, skeleton_points.get(2).z, 200);
  endShape(CLOSE);

  beginShape();
  texture(img);
  vertex(x1, y1, z1, 200);
  vertex(skeleton_points.get(6).x, skeleton_points.get(6).y, skeleton_points.get(6).z, 200);
  vertex(skeleton_points.get(5).x, skeleton_points.get(5).y, skeleton_points.get(5).z, 400);
  endShape(CLOSE);

  beginShape();
  texture(img);
  vertex(x1, y1, z1, 200);
  vertex(skeleton_points.get(2).x, skeleton_points.get(2).y, skeleton_points.get(2).z, 200);
  vertex(skeleton_points.get(9).x, skeleton_points.get(9).y, skeleton_points.get(9).z, 400);
  endShape(CLOSE);

  beginShape();
  texture(img);
  vertex(x1, y1, z1, 200);
  vertex(skeleton_points.get(9).x, skeleton_points.get(9).y, skeleton_points.get(9).z, 200);
  vertex(skeleton_points.get(12).x, skeleton_points.get(12).y, skeleton_points.get(12).z, 400);
  vertex(skeleton_points.get(6).x, skeleton_points.get(6).y, skeleton_points.get(6).z, 400);
  endShape(CLOSE);
  //net
  noFill();
  stroke(225);
  beginShape();
  vertex(skeleton_points.get(1).x, skeleton_points.get(1).y, skeleton_points.get(1).z);
  vertex(skeleton_points.get(2).x, skeleton_points.get(2).y, skeleton_points.get(2).z);
  vertex(skeleton_points.get(3).x, skeleton_points.get(3).y, skeleton_points.get(3).z);
  vertex(skeleton_points.get(9).x, skeleton_points.get(9).y, skeleton_points.get(9).z);
  vertex(skeleton_points.get(12).x, skeleton_points.get(12).y, skeleton_points.get(12).z);
  vertex(skeleton_points.get(6).x, skeleton_points.get(6).y, skeleton_points.get(6).z);
  vertex(skeleton_points.get(5).x, skeleton_points.get(5).y, skeleton_points.get(5).z);
  endShape(CLOSE);
  line(skeleton_points.get(1).x, skeleton_points.get(1).y, skeleton_points.get(1).z, skeleton_points.get(6).x, skeleton_points.get(6).y, skeleton_points.get(6).z);
  line(skeleton_points.get(1).x, skeleton_points.get(1).y, skeleton_points.get(1).z, skeleton_points.get(3).x, skeleton_points.get(3).y, skeleton_points.get(3).z);
  //point 1

  line(skeleton_points.get(6).x, skeleton_points.get(6).y, skeleton_points.get(6).z, x1, y1, z1);
  line(skeleton_points.get(9).x, skeleton_points.get(9).y, skeleton_points.get(9).z, x1, y1, z1);
  line(skeleton_points.get(5).x, skeleton_points.get(5).y, skeleton_points.get(5).z, x1, y1, z1);
  line(skeleton_points.get(2).x, skeleton_points.get(2).y, skeleton_points.get(2).z, x1, y1, z1);

  if (x1>skeleton_points.get(6).x||x1>skeleton_points.get(12).x) {
    line(skeleton_points.get(12).x, skeleton_points.get(12).y, skeleton_points.get(12).z, x1, y1, z1);
  }
  //point 2


  line(skeleton_points.get(3).x, skeleton_points.get(3).y, skeleton_points.get(3).z, x2, y2, z2);
  line(skeleton_points.get(12).x, skeleton_points.get(12).y, skeleton_points.get(12).z, x2, y2, z2);
  line(skeleton_points.get(5).x, skeleton_points.get(5).y, skeleton_points.get(5).z, x2, y2, z2);
  line(skeleton_points.get(1).x, skeleton_points.get(1).y, skeleton_points.get(1).z, x2, y2, z2);
  line(skeleton_points.get(9).x, skeleton_points.get(9).y, skeleton_points.get(9).z, x2, y2, z2);

  if (x1<skeleton_points.get(3).x||x1<skeleton_points.get(9).x) {
    line(skeleton_points.get(9).x, skeleton_points.get(9).y, skeleton_points.get(9).z, x2, y2, z2);
  }
}

void oppo_shape() {
  //draw opposite upper part
  float x1 = skeleton_points.get(2).x + (skeleton_points.get(6).x - skeleton_points.get(2).x)/4;
  float y1 = skeleton_points.get(3).y + (skeleton_points.get(9).y - skeleton_points.get(4).y)/3;
  float z1 = skeleton_points.get(3).z;

  //middle_point
  float x2 = skeleton_points.get(15).x + (skeleton_points.get(6).y - skeleton_points.get(2).y)/2;
  float y2 = skeleton_points.get(15).y + (skeleton_points.get(10).y - skeleton_points.get(6).y)/5;
  float z2 = skeleton_points.get(15).z;

  float x3 = skeleton_points.get(2).x + (skeleton_points.get(7).x - skeleton_points.get(2).x)/2;
  float y3 = skeleton_points.get(12).y - (skeleton_points.get(13).y - skeleton_points.get(4).y)/2;
  float z3 = skeleton_points.get(6).z;

  float x4 = skeleton_points.get(13).x + 1.5*(skeleton_points.get(5).x - skeleton_points.get(2).x);
  float y4 = skeleton_points.get(5).y - (skeleton_points.get(7).y - skeleton_points.get(3).y)/10;
  float z4 = skeleton_points.get(12).z;



  //third_part
  beginShape();
  vertex(-x2, -y2, z2); 
  vertex(-x3, -y3, z3);
  vertex(-x3, -y3, skeleton_points.get(5).z);

  vertex(-x2, -y2, z2);
  vertex(-x3, -y3, skeleton_points.get(5).z);
  vertex(-x4, -y4, z4);

  vertex(-x2, -y2, z2); 
  vertex(-x4, -y4, z4);
  vertex(-x4, -y4, skeleton_points.get(13).z);

  vertex(-x2, -y2, z2);
  vertex(-x4, -y4, skeleton_points.get(13).z);
  vertex(-x3, -y3, z3);
  endShape();

  //connect to 7
  beginShape();
  vertex(-skeleton_points.get(7).x+50, -skeleton_points.get(7).y, skeleton_points.get(7).z); 
  vertex(-x3, -y3, z3);
  vertex(-x3, -y3, skeleton_points.get(5).z);

  vertex(-skeleton_points.get(7).x+50, -skeleton_points.get(7).y, skeleton_points.get(7).z); 
  vertex(-x3, -y3, skeleton_points.get(5).z);
  vertex(-x4, -y4, z4);

  vertex(-skeleton_points.get(7).x+50, -skeleton_points.get(7).y, skeleton_points.get(7).z); 
  vertex(-x4, -y4, z4);
  vertex(-x4, -y4, skeleton_points.get(13).z);

  vertex(-skeleton_points.get(7).x+50, -skeleton_points.get(7).y, skeleton_points.get(7).z); 
  vertex(-x4, -y4, skeleton_points.get(13).z);
  vertex(-x3, -y3, z3);
  endShape();
}

void try_skeleton() {
  strokeWeight(1);
  stroke(255);
  PImage img = loadImage("p2.jpg");
  int count;
  count = frameCount%3000;
  if (count<600) {

    print("1");
  } else if (count>=600 && count<1200) {
    float x1 = skeleton_points.get(2).x + (skeleton_points.get(6).x - skeleton_points.get(2).x)/4;
    float y1 = skeleton_points.get(3).y + (skeleton_points.get(9).y - skeleton_points.get(4).y)/3;
    float z1 = skeleton_points.get(3).z;

    //middle_point
    float x2 = skeleton_points.get(15).x + (skeleton_points.get(6).y - skeleton_points.get(2).y)/2;
    float y2 = skeleton_points.get(15).y + (skeleton_points.get(10).y - skeleton_points.get(6).y)/5;
    float z2 = skeleton_points.get(15).z;

    float x3 = skeleton_points.get(2).x + (skeleton_points.get(7).x - skeleton_points.get(2).x)/2;
    float y3 = skeleton_points.get(12).y - (skeleton_points.get(13).y - skeleton_points.get(4).y)/2;
    float z3 = skeleton_points.get(6).z;

    float x4 = skeleton_points.get(13).x + 1.5*(skeleton_points.get(5).x - skeleton_points.get(2).x);
    float y4 = skeleton_points.get(5).y - (skeleton_points.get(7).y - skeleton_points.get(3).y)/10;
    float z4 = skeleton_points.get(12).z;
    pushMatrix();
    scale(1.2);
    //third_part
    beginShape();
    vertex(-x2, -y2, z2); 
    vertex(-x3, -y3, z3);
    vertex(-x3, -y3, skeleton_points.get(5).z);

    vertex(-x2, -y2, z2);
    vertex(-x3, -y3, skeleton_points.get(5).z);
    vertex(-x4, -y4, z4);

    vertex(-x2, -y2, z2); 
    vertex(-x4, -y4, z4);
    vertex(-x4, -y4, skeleton_points.get(13).z);

    vertex(-x2, -y2, z2);
    vertex(-x4, -y4, skeleton_points.get(13).z);
    vertex(-x3, -y3, z3);
    endShape();

    //connect to 7
    beginShape();
    vertex(-skeleton_points.get(7).x+50, -skeleton_points.get(7).y, skeleton_points.get(7).z); 
    vertex(-x3, -y3, z3);
    vertex(-x3, -y3, skeleton_points.get(5).z);

    vertex(-skeleton_points.get(7).x+50, -skeleton_points.get(7).y, skeleton_points.get(7).z); 
    vertex(-x3, -y3, skeleton_points.get(5).z);
    vertex(-x4, -y4, z4);

    vertex(-skeleton_points.get(7).x+50, -skeleton_points.get(7).y, skeleton_points.get(7).z); 
    vertex(-x4, -y4, z4);
    vertex(-x4, -y4, skeleton_points.get(13).z);

    vertex(-skeleton_points.get(7).x+50, -skeleton_points.get(7).y, skeleton_points.get(7).z); 
    vertex(-x4, -y4, skeleton_points.get(13).z);
    vertex(-x3, -y3, z3);
    endShape();
    popMatrix();


    beginShape(TRIANGLE_FAN);
    noStroke();
    texture(img);
    vertex(skeleton_points.get(7).x+50, skeleton_points.get(7).y, skeleton_points.get(7).z, 200); 
    vertex(x4, y4, z4, 200);
    vertex(x2, y2, z2, 400); 
    vertex(skeleton_points.get(9).x, skeleton_points.get(9).y, skeleton_points.get(9).z, 400);
    vertex(skeleton_points.get(10).x, skeleton_points.get(10).y, skeleton_points.get(10).z, 500);
    vertex(skeleton_points.get(12).x, skeleton_points.get(12).y, skeleton_points.get(12).z, 500);
    vertex(x3, y3, z3, 200);
    endShape(CLOSE);



    print("2");
  } else if (count>=1200 && count<1800) {

    beginShape(TRIANGLE);
    beginShape(TRIANGLE_FAN);
    vertex(skeleton_points.get(4).x, skeleton_points.get(4).y, skeleton_points.get(4).z);
    vertex(skeleton_points.get(2).x-(skeleton_points.get(16).x-skeleton_points.get(2).x), skeleton_points.get(15).y-50, skeleton_points.get(4).z);
    vertex(skeleton_points.get(2).x, skeleton_points.get(2).y, skeleton_points.get(2).z);
    vertex(skeleton_points.get(1).x, skeleton_points.get(1).y, skeleton_points.get(1).z);
    vertex(skeleton_points.get(5).x, skeleton_points.get(5).y, skeleton_points.get(5).z);
    vertex(skeleton_points.get(6).x, skeleton_points.get(6).y, skeleton_points.get(6).z);
    vertex(skeleton_points.get(4).x, skeleton_points.get(4).y, skeleton_points.get(4).z);
    endShape();

    beginShape();
    vertex(skeleton_points.get(7).x, skeleton_points.get(7).y, skeleton_points.get(7).z);
    vertex(skeleton_points.get(1).x, skeleton_points.get(1).y, skeleton_points.get(1).z);
    vertex(skeleton_points.get(5).x, skeleton_points.get(5).y, skeleton_points.get(5).z);

    vertex(skeleton_points.get(7).x, skeleton_points.get(7).y, skeleton_points.get(7).z);
    vertex(skeleton_points.get(5).x, skeleton_points.get(5).y, skeleton_points.get(5).z);
    vertex(skeleton_points.get(6).x, skeleton_points.get(6).y, skeleton_points.get(6).z);

    vertex(skeleton_points.get(7).x, skeleton_points.get(7).y, skeleton_points.get(7).z);
    vertex(skeleton_points.get(6).x, skeleton_points.get(6).y, skeleton_points.get(6).z);
    vertex(skeleton_points.get(1).x, skeleton_points.get(1).y, skeleton_points.get(1).z);
    endShape();

    pushMatrix();
    noStroke();
    scale(1.1);
    beginShape(TRIANGLE_FAN);
    texture(img);
    textureMode(IMAGE);
    vertex(-skeleton_points.get(4).x, -skeleton_points.get(4).y, skeleton_points.get(4).z, 400);
    vertex(-(skeleton_points.get(2).x-(skeleton_points.get(16).x-skeleton_points.get(2).x)), -(skeleton_points.get(15).y-50), skeleton_points.get(4).z, 200);
    vertex(-skeleton_points.get(2).x, -skeleton_points.get(2).y, skeleton_points.get(2).z, 200);
    vertex(-skeleton_points.get(1).x, -skeleton_points.get(1).y, skeleton_points.get(1).z, 300);
    vertex(-skeleton_points.get(7).x, -skeleton_points.get(7).y, skeleton_points.get(7).z);
    vertex(-skeleton_points.get(6).x, -skeleton_points.get(6).y, skeleton_points.get(6).z);
    vertex(-skeleton_points.get(5).x, -skeleton_points.get(5).y, skeleton_points.get(5).z, 400);

    endShape(CLOSE);
    popMatrix();



    print("3");
  } else if (count>=1800 && count<2400) {

    beginShape(TRIANGLE_FAN);
    vertex(skeleton_points.get(6).x+50, skeleton_points.get(6).y, skeleton_points.get(6).z);
    vertex(skeleton_points.get(5).x, skeleton_points.get(5).y, skeleton_points.get(5).z);
    vertex(skeleton_points.get(15).x, skeleton_points.get(15).y, skeleton_points.get(15).z);
    vertex(skeleton_points.get(4).x, skeleton_points.get(4).y, skeleton_points.get(4).z);
    vertex(skeleton_points.get(12).x, skeleton_points.get(12).y, skeleton_points.get(12).z);
    vertex(skeleton_points.get(10).x, skeleton_points.get(10).y, skeleton_points.get(10).z);
    vertex(skeleton_points.get(6).x+50, skeleton_points.get(6).y, skeleton_points.get(6).z);
    endShape();

    pushMatrix();
    noStroke();
    scale(1.3);
    beginShape(TRIANGLE_FAN);
    texture(img);
    vertex(-skeleton_points.get(4).x, skeleton_points.get(4).y, skeleton_points.get(4).z, 200);
    vertex(-skeleton_points.get(3).x, -skeleton_points.get(3).y, skeleton_points.get(3).z, 200);
    vertex(-skeleton_points.get(5).x, skeleton_points.get(5).y, skeleton_points.get(5).z, 500);
    vertex(-skeleton_points.get(6).x, skeleton_points.get(6).y, skeleton_points.get(6).z, 500);
    vertex(-skeleton_points.get(10).x, -skeleton_points.get(10).y, skeleton_points.get(10).z, 300);
    endShape(CLOSE);

    popMatrix();
    print("4");
  } else if (count>=2400 && count<3000) {

    print("5");
  }
}


void draw_skeleton() {
  scale(0.7);

  noStroke();
  //stroke(0);

  // Line 1: torso, spine_mid, spine_shoulder, neck, head
  line(skeleton_points.get(8).x, skeleton_points.get(8).y, skeleton_points.get(8).z, 
    skeleton_points.get(15).x, skeleton_points.get(15).y, skeleton_points.get(15).z);
  line(skeleton_points.get(15).x, skeleton_points.get(15).y, skeleton_points.get(15).z, 
    skeleton_points.get(16).x, skeleton_points.get(16).y, skeleton_points.get(16).z);
  line(skeleton_points.get(16).x, skeleton_points.get(16).y, skeleton_points.get(16).z, 
    skeleton_points.get(1).x, skeleton_points.get(1).y, skeleton_points.get(1).z);
  line(skeleton_points.get(1).x, skeleton_points.get(1).y, skeleton_points.get(1).z, 
    skeleton_points.get(0).x, skeleton_points.get(0).y, skeleton_points.get(0).z);

  // Line 2: spine_shoulder, right_shoulder, right_elbow, right_hand
  line(skeleton_points.get(16).x, skeleton_points.get(16).y, skeleton_points.get(16).z, 
    skeleton_points.get(5).x, skeleton_points.get(5).y, skeleton_points.get(5).z);
  line(skeleton_points.get(5).x, skeleton_points.get(5).y, skeleton_points.get(5).z, 
    skeleton_points.get(6).x, skeleton_points.get(6).y, skeleton_points.get(6).z);
  line(skeleton_points.get(6).x, skeleton_points.get(6).y, skeleton_points.get(6).z, 
    skeleton_points.get(7).x, skeleton_points.get(7).y, skeleton_points.get(7).z);

  // Line 3: torso, right_hip, right_knee, right_foot
  line(skeleton_points.get(8).x, skeleton_points.get(8).y, skeleton_points.get(8).z, 
    skeleton_points.get(12).x, skeleton_points.get(12).y, skeleton_points.get(12).z);
  line(skeleton_points.get(12).x, skeleton_points.get(12).y, skeleton_points.get(12).z, 
    skeleton_points.get(13).x, skeleton_points.get(13).y, skeleton_points.get(13).z);
  line(skeleton_points.get(13).x, skeleton_points.get(13).y, skeleton_points.get(13).z, 
    skeleton_points.get(14).x, skeleton_points.get(14).y, skeleton_points.get(14).z);

  // Line 4: spine_shoulder, left_shoulder, left_elbow, left_hand
  line(skeleton_points.get(16).x, skeleton_points.get(16).y, skeleton_points.get(16).z, 
    skeleton_points.get(2).x, skeleton_points.get(2).y, skeleton_points.get(2).z);
  line(skeleton_points.get(2).x, skeleton_points.get(2).y, skeleton_points.get(2).z, 
    skeleton_points.get(3).x, skeleton_points.get(3).y, skeleton_points.get(3).z);
  line(skeleton_points.get(3).x, skeleton_points.get(3).y, skeleton_points.get(3).z, 
    skeleton_points.get(4).x, skeleton_points.get(4).y, skeleton_points.get(4).z);

  // Line 5: torso, left_hip, left_knee, left_foot
  line(skeleton_points.get(8).x, skeleton_points.get(8).y, skeleton_points.get(8).z, 
    skeleton_points.get(9).x, skeleton_points.get(9).y, skeleton_points.get(9).z);
  line(skeleton_points.get(9).x, skeleton_points.get(9).y, skeleton_points.get(9).z, 
    skeleton_points.get(10).x, skeleton_points.get(10).y, skeleton_points.get(10).z);
  line(skeleton_points.get(10).x, skeleton_points.get(10).y, skeleton_points.get(10).z, 
    skeleton_points.get(11).x, skeleton_points.get(11).y, skeleton_points.get(11).z);
}
