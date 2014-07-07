
boolean white = false;
int cnt = 1;
int _strokeWeight = 1;
int pressedX = 0;
int pressedY = 0;
float red;
float green;

AudioPlayer player1;
boolean player1Started = false;

AudioPlayer[] player;
float[] playerVolume = {1.0, 1.0, 1.0, 1.0, 1.0};
int playerSize = 5;
int playerCount = 0;

void setup()
{
  println("setup");
  size(700, 700);
  background(255);
  frameRate(60);
  strokeWeight(_strokeWeight);
  red = random(0, 100) < 50 ? 0 : 255;
  green = random(0, 100) < 50 ? 0 : 255;

  Maxim  maxim = new Maxim(this);
  player1 = maxim.loadFile("1.wav");
  player1.setLooping(true);

  player = new AudioPlayer[playerSize];
  maxim = new Maxim(this);
  for (int i=0; i< playerSize; i++) {
    String name = "s" + i + ".wav";
    println("loading " + name);
    player[i] = maxim.loadFile(name);
    player[i].setLooping(false);
    player[i].volume(playerVolume[i]);
  }
}

void draw() {
  drawRecu(0, 0, width, height);
}

void drawRecu(float offX, float offY, float _width, float _height) {
  if (_width > 30) {
    drawRect(offX, offY, _width, _height);
    float fact = 0.75;
    float offX1 = offX + (_width * ((1.0 - fact) / 2.0));
    float offY1 = offY + (_height * ((1.0 - fact) / 2.0));
    drawRecu(offX1, offY1, _width * fact, _height * fact);
  }
}

void drawRect(float offX, float offY, float _width, float _height) 
{
  for (int i=0; i < 80; i++) {
    //if (cnt % 20000 == 0) white = !white;
    int alpha = int(random(5, 100));
    if (white) {
      stroke(255, 255, 255, alpha);
      if (random(100) > 50) {
        float x = offX + (random(100) > 50 ? 0 : _width);
        float y = offY + random(_height);
        line(offX + _width/2, offY + _height/2, x, y);
      } else {
        float x = offX + random(_width);
        float y = offY + (random(100) > 50 ? 0 : _height);
        line(offX + _width/2, offY + _height/2, x, y);
      }
    } else {
      float blue = random(0, 255);
      stroke(int(red), int(green), int(blue), alpha);
      if (random(100) > 50) {
        float x = offX + (random(100) > 50 ? 0 : _width);
        float y = offY + random(_height);
        line(offX + _width/2, offY + _height/2, x, y);
      } else {
        float x = offX + random(_width);
        float y = offY + (random(100) > 50 ? 0 : _height);
        line(offX + _width/2, offY + _height/2, x, y);
      }
    }  
    cnt++;
  }
}

public void mousePressed() {
  println("pressed");
  pressedX = mouseX;
  pressedY = mouseY;
}

public void mouseReleased() {
  //if (white) white = !white;
  float dx = float(pressedX) - mouseX;
  float dy = float(pressedY) - mouseY;
  if (abs(dx) > 0.8 * width) {
    println("released w");
    white = true;
  } else {
    println("released other");
    white = false;
    float r= max(-127, min(127, 500.0 * dx / width)) + 127;
    float g = max(-127, min(127, 500.0 * dy / height)) + 127;
    float m = abs(r - g);
    println("m" + m);
    println("r" + r);
    println("g" + g);
//    if (m < 50) {
    if (false) {
      red = random(0, 100) < 50 ? 0 : 255;
      green = random(0, 100) < 50 ? 0 : 255;
    } else {
      red = r;
      green = g;
    }
  }
  if (!player1Started) {
    player1.play();
    player1Started = false;
  }
  if (player[playerCount % playerSize].isPlaying()) {
    player[playerCount % playerSize].stop();
    player[playerCount % playerSize].cue(0);
  }
  player[playerCount % playerSize].play();
  playerCount++;
}

