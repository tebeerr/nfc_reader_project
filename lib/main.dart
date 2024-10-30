import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';

void main() => runApp(NfcReaderApp());

class NfcReaderApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: NfcReaderScreen(),
    );
  }
}

class NfcReaderScreen extends StatefulWidget {
  @override
  _NfcReaderScreenState createState() => _NfcReaderScreenState();
}

class _NfcReaderScreenState extends State<NfcReaderScreen> {
  String _receivedData = 'Waiting for NFC data...';

  @override
  void initState() {
    super.initState();
    _startNfcReadingSession();
  }

  void _startNfcReadingSession() {
    NfcManager.instance.startSession(
      onDiscovered: (NfcTag tag) async {
        final ndef = Ndef.from(tag);
        if (ndef != null) {
          NdefMessage message = await ndef.read();
          setState(() {
            _receivedData = message.records
                .map((record) => String.fromCharCodes(record.payload))
                .join();
          });
          NfcManager.instance.stopSession();
        } else {
          setState(() {
            _receivedData = 'NDEF not supported on this device.';
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('NFC Reader')),
      body: Center(
        child: Text(_receivedData, style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
