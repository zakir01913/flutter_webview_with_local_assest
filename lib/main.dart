import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappbrowser/flutter_inappbrowser.dart';
import 'package:webview_flutter/webview_flutter.dart';

InAppLocalhostServer localhostServer = new InAppLocalhostServer();

void main() async {
  await localhostServer.start();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: FutureBuilder<String>(
          future: loadLocal(),
          builder: (BuildContext context, snapshot) {
            if (snapshot.hasData) {
              return InAppWebView(
//                initialUrl: new Uri.dataFromString(
//                  snapshot.data,
//                  mimeType: 'text/html',
//                  encoding: Encoding.getByName("UTF-8"),
//                ).toString(),
                initialUrl: "http://localhost:8080/assets/dotmobile_teaser_screens/index.html",
                initialOptions: InAppWebViewWidgetOptions(
                    inAppWebViewOptions: InAppWebViewOptions(
                      debuggingEnabled: true,
                    )
                ),// maybe you Uri.dataFromString(snapshot.data, mimeType: 'text/html', encoding: Encoding.getByName("UTF-8")).toString()
              );
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            return CircularProgressIndicator();
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Future<String> loadLocal() async {
    return await rootBundle
        .loadString('assets/dotmobile_teaser_screens/index.html');
  }
}
