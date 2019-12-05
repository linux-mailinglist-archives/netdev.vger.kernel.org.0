Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39DE3113D4B
	for <lists+netdev@lfdr.de>; Thu,  5 Dec 2019 09:47:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728629AbfLEIrD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Dec 2019 03:47:03 -0500
Received: from mail-eopbgr60048.outbound.protection.outlook.com ([40.107.6.48]:53273
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726059AbfLEIrD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Dec 2019 03:47:03 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nj0yxdRE3Z2hHxoeqTCgHkjj1Y6RU01Ss6pJd7onKQtHemCiJ8sRI1N224qROuNp0+fi3Aa7O6R7BsGpXSOd8fv0uNW5wdplzX/5RlTPFe7HTxeErER9ebjNwaTUGBodopVb0MrQ0vJNEdjV3JQw3HvJxg/pOurMmVwImqgIwg5wZ2nlZymRhjN13YdSotEJGE1QGoVJXLDkJFvMp3LH5YAkT8E7zhZ4Pg7cdhjMDXCEijtvFIon2p7/QsTkryddYHHojZOblgsl8C7jkoFrywybXsBl/P60qLG8ojGnej2jvngXo17xvZoxV+2OG7RV2d8lKslspOz+iq8QcMMe8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VTGZWgE6fbntVtOaymUritIElm9AEydQSg1SzN8Fhgw=;
 b=Liwsi+940s6Ya5FVPBNNlMNBdDzdXvATcDizheOHJ0HDwk89QJ/bhRCsskUJxT2N6jfke47ScSU9tj0yyY//pCjPpuvZxN1EvSjwcSE560LZgOmwElSwOJUEymAAy9jyUy4PehrOZ2atQfeUDn16oS8O312uPqrAjftQCqJmJjOyhbHlylxGSND1wL64zcdnw4vQBPN3XsD6vjY3Re4dlUPumBLsGyauWL+lHrMvoX5SbnRJocvwfAuivJu4Y4U6nieAoZpvtGFtMYMbNeYXQ0JrWbRo6Qye+GbM/5MpIt8soxJvFQ+4jjkzF4Xe1CElFgOuSi3Ut9x4f8e3Jvp4zQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VTGZWgE6fbntVtOaymUritIElm9AEydQSg1SzN8Fhgw=;
 b=YCIHnwWvnpqvS+LG1z3RE5FnACPXS8iXEEhWTiBH8y8iEtpLlcbCibkc62X2baEmQb10RGlFPyOMKh810soKEryPIO3bCXwiGdpiXge2fOXu6Lv7582ivtX7rzhWIvXbozZPhOnKhnHfuSY6aeVuY3b5btrJyyR1BCecjmgMu2s=
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com (52.135.139.151) by
 DB7PR04MB5484.eurprd04.prod.outlook.com (20.178.106.147) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2516.14; Thu, 5 Dec 2019 08:46:58 +0000
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::1c96:c591:7d51:64e6]) by DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::1c96:c591:7d51:64e6%4]) with mapi id 15.20.2516.014; Thu, 5 Dec 2019
 08:46:58 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     Marc Kleine-Budde <mkl@pengutronix.de>,
        "sean@geanix.com" <sean@geanix.com>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>
CC:     dl-linux-imx <linux-imx@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH V2 2/4] can: flexcan: try to exit stop mode during probe
 stage
Thread-Topic: [PATCH V2 2/4] can: flexcan: try to exit stop mode during probe
 stage
Thread-Index: AQHVpOd0/zAyRBOEIkuRK6cuc/m3PqeowUOAgACCKzCAAHEBAIABkcMw
Date:   Thu, 5 Dec 2019 08:46:58 +0000
Message-ID: <DB7PR04MB46186FB41B5873FED5ABEC06E65C0@DB7PR04MB4618.eurprd04.prod.outlook.com>
References: <20191127055334.1476-1-qiangqing.zhang@nxp.com>
 <20191127055334.1476-3-qiangqing.zhang@nxp.com>
 <ad7e7b15-26f3-daa1-02d2-782ff548756d@pengutronix.de>
 <DB7PR04MB46180C5F1EAC7C4A69A45E0CE65D0@DB7PR04MB4618.eurprd04.prod.outlook.com>
 <d68b2b79-34ec-eb4c-cf4b-047b5157d5e3@pengutronix.de>
In-Reply-To: <d68b2b79-34ec-eb4c-cf4b-047b5157d5e3@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=qiangqing.zhang@nxp.com; 
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 6c03faae-0339-495f-03ac-08d7795fb05b
x-ms-traffictypediagnostic: DB7PR04MB5484:|DB7PR04MB5484:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB7PR04MB5484266375D06398216DED3AE65C0@DB7PR04MB5484.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 02426D11FE
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(376002)(39860400002)(396003)(366004)(346002)(199004)(189003)(13464003)(2906002)(14454004)(11346002)(186003)(5660300002)(8676002)(25786009)(3846002)(2501003)(6116002)(26005)(53546011)(6506007)(81166006)(81156014)(8936002)(102836004)(6246003)(4326008)(76116006)(9686003)(86362001)(66476007)(66556008)(64756008)(66446008)(71190400001)(71200400001)(52536014)(6306002)(229853002)(6436002)(2201001)(55016002)(66946007)(33656002)(7696005)(316002)(76176011)(54906003)(305945005)(7736002)(99286004)(74316002)(966005)(14444005)(110136005)(478600001);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7PR04MB5484;H:DB7PR04MB4618.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vGgoCvUtA1PuhZv2mDOBjWTectqWnO9MNKa66sOuW8vBsPXshAnQMqxrQmiImKOt+OV93DZuJLStV4RPaFJkGGfi5ASLPRnAx0a5HMe+MkVXXjanupe6KOEZDn92I2+zBIPZxKRjuoaN00j5s2JFEPXGIB5C7tL/EschHowzyxwO6sTjUcH1322kmQFPY+yadFr9GjEmK54O+styuZsEndiioF6vlL5zkMQfDXD0ZUzMJf/50/P+brUoJH6TNpwSc+3ke7v/zDPeMGtlZvbFWdsuOArFia9yfCAIQcEGup5D4px76DqAoQuS/HEgV+H/o+o6Su+DkPFaLPpJ5W1tLE2u0sB2web89KKt9Otc/p+5O9ZKYNSe4hUn7C2Mx+GclhI19LgsJtqz1ZjRaUZV7MbtC+pSlRKV+ljuEOgvAvCgM1b0sUMQidS9/fjrwDzLDJJRnSS2Xgtip3ZcgsMXx2nLNSSYgIWgTLpLHlp8ePkIzgNIORC02AURb49sPU9i918pocRaCpQHPIdrZfAV29l9JneyhQlQxF+u99tBLJk=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c03faae-0339-495f-03ac-08d7795fb05b
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Dec 2019 08:46:58.2873
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lTSAAepZguV9Svn4gkWhSk1iV4xcLXzjhEoQggITp38pyg0L0/i8Rd/hGlkrlYI+LvzB6tR+3KgQ8cDoRi3/vg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB5484
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpIaSBTZWFuLA0KDQpDb3VsZCB5b3UgcGxlYXNlIGFuc3dlciBNYXJjJ3MgY29uY2VybiBpbiBk
ZXRhaWxzIHdoZW4geW91IGFyZSBmcmVlPyBUaGVuIHdlIGNhbiBkaXNjdXNzIGhvdyB0byBmaXgg
aXQgbW9yZSByZWFzb25hYmxlLiBUaGFua3MuDQogDQpCZXN0IFJlZ2FyZHMsDQpKb2FraW0gWmhh
bmcNCg0KPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBNYXJjIEtsZWluZS1C
dWRkZSA8bWtsQHBlbmd1dHJvbml4LmRlPg0KPiBTZW50OiAyMDE55bm0MTLmnIg05pelIDE2OjQ1
DQo+IFRvOiBKb2FraW0gWmhhbmcgPHFpYW5ncWluZy56aGFuZ0BueHAuY29tPjsgc2VhbkBnZWFu
aXguY29tOw0KPiBsaW51eC1jYW5Admdlci5rZXJuZWwub3JnDQo+IENjOiBkbC1saW51eC1pbXgg
PGxpbnV4LWlteEBueHAuY29tPjsgbmV0ZGV2QHZnZXIua2VybmVsLm9yZw0KPiBTdWJqZWN0OiBS
ZTogW1BBVENIIFYyIDIvNF0gY2FuOiBmbGV4Y2FuOiB0cnkgdG8gZXhpdCBzdG9wIG1vZGUgZHVy
aW5nIHByb2JlDQo+IHN0YWdlDQo+IA0KPiBPbiAxMi80LzE5IDM6MjIgQU0sIEpvYWtpbSBaaGFu
ZyB3cm90ZToNCj4gPg0KPiA+PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiA+PiBGcm9t
OiBNYXJjIEtsZWluZS1CdWRkZSA8bWtsQHBlbmd1dHJvbml4LmRlPg0KPiA+PiBTZW50OiAyMDE5
5bm0MTLmnIg05pelIDI6MTUNCj4gPj4gVG86IEpvYWtpbSBaaGFuZyA8cWlhbmdxaW5nLnpoYW5n
QG54cC5jb20+OyBzZWFuQGdlYW5peC5jb207DQo+ID4+IGxpbnV4LWNhbkB2Z2VyLmtlcm5lbC5v
cmcNCj4gPj4gQ2M6IGRsLWxpbnV4LWlteCA8bGludXgtaW14QG54cC5jb20+OyBuZXRkZXZAdmdl
ci5rZXJuZWwub3JnDQo+ID4+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggVjIgMi80XSBjYW46IGZsZXhj
YW46IHRyeSB0byBleGl0IHN0b3AgbW9kZQ0KPiA+PiBkdXJpbmcgcHJvYmUgc3RhZ2UNCj4gPj4N
Cj4gPj4gT24gMTEvMjcvMTkgNjo1NiBBTSwgSm9ha2ltIFpoYW5nIHdyb3RlOg0KPiA+Pj4gQ0FO
IGNvbnRyb2xsZXIgY291bGQgYmUgc3R1Y2tlZCBpbiBzdG9wIG1vZGUgb25jZSBpdCBlbnRlcnMg
c3RvcA0KPiA+Pj4gbW9kZQ0KPiA+PiAgICAgICAgICAgICAgICAgICAgICAgICAgIF5eXl5eXl4g
c3R1Y2sNCj4gPj4+IHdoZW4gc3VzcGVuZCwgYW5kIHRoZW4gaXQgZmFpbHMgdG8gZXhpdCBzdG9w
IG1vZGUgd2hlbiByZXN1bWUuDQo+ID4+DQo+ID4+IEhvdyBjYW4gdGhpcyBoYXBwZW4/DQo+ID4N
Cj4gPiBJIGFtIGFsc28gY29uZnVzZWQgaG93IGNhbiB0aGlzIGhhcHBlbiwgYXMgSSBhc2tlZCBT
ZWFuLCBvbmx5IENBTg0KPiA+IGVudGVyIHN0b3AgbW9kZSB3aGVuIHN1c3BlbmQsIHRoZW4gc3lz
dGVtIGhhbmcsDQo+IEhvdyBkbyB5b3UgcmVjb3ZlciB0aGUgc3lzdGVtIHdoZW4gc3VzcGVuZGVk
Pw0KPiANCj4gPiBpdCBjb3VsZCBsZXQgQ0FODQo+ID4gc3R1Y2sgaW4gc3RvcCBtb2RlLiBIb3dl
dmVyLCBTZWFuIHNhaWQgdGhpcyBpbmRlZWQgaGFwcGVuIGF0IGhpcyBzaWRlLA0KPiA+IEBzZWFu
QGdlYW5peC5jb20sIGNvdWxkIHlvdSBleHBsYWluIGhvdyB0aGlzIGhhcHBlbiBpbiBkZXRhaWxz
Pw0KPiBUaGF0IHdvdWxkIGJlIGdvb2QuDQo+IA0KPiA+Pj4gT25seSBjb2RlIHJlc2V0IGNhbiBn
ZXQgQ0FOIG91dCBvZiBzdG9wIG1vZGUsDQo+ID4+DQo+ID4+IFdoYXQgaXMgImNvZGUgcmVzZXQi
Pw0KPiA+DQo+ID4gQXMgSSBrbm93LCAiY29kZSByZXNldCIgaXMgdG8gcHJlc3MgdGhlIFBPV0VS
IEtFWSBmcm9tIHRoZSBib2FyZC4gQXQNCj4gPiBteSBzaWRlLCByZWJvb3QgY29tbWFuZCBmcm9t
IE9TIGFsc28gY2FuIGdldCBDQU4gb3V0IG9mIHN0b3AgbW9kZS4NCj4gRG8geW91IG1lYW4gImNv
bGQgcmVzZXQiLCBhbHNvIGtub3duIGFzIFBvd2VyLU9uLVJlc2V0LCBQT1Igb3IgcG93ZXINCj4g
Y3ljbGU/DQo+IA0KPiBXaGF0IGRvZXMgcHJlc3NpbmcgdGhlIFBPV0VSIEtFWSBkbz8gQSBwb3dl
ciBjeWNsZSBvZiB0aGUgc3lzdGVtIG9yDQo+IHRvZ2dsaW5nIHRoZSByZXNldCBsaW5lIG9mIHRo
ZSBpbXg/DQo+IA0KPiBXZSBuZWVkIHRvIGRlc2NyaWJlIGluIGRldGFpbCwgYXMgbm90IGV2ZXJ5
b25lIGhhcyB0aGUgc2FtZSBib2FyZCBhcyB5b3UsIGFuZA0KPiB0aGVzZSBib2FyZHMgbWlnaHQg
bm90IGV2ZW4gaGF2ZSBhIHBvd2VyIGtleSA6KQ0KPiANCj4gPiBCZWxvdyBpcyBleHBlcmltZW50
IEkgZGlkOg0KPiA+IAlGaXJzdGx5LCBkbyBhIGhhY2tpbmcgdG8gbGV0IENBTiBzdHVjayBpbnRv
IHN0b3AgbW9kZSwgdGhlbjoNCj4gDQo+IFlvdSBtZWFuIHlvdSBwdXQgdGhlIENBTiBpbnRvIHN0
b3AgbW9kZSB3aXRob3V0IGtlZXBpbmcgdHJhY2sgaW4gdGhlIENBTg0KPiBkcml2ZXIgdGhhdCB0
aGUgQ0FOLUlQIGlzIGluIHN0b3AgbW9kZSwgZS5nLiBieSBoYWNraW5nIHRoZSBkcml2ZXIuDQo+
IA0KPiBUaGVuIHlvdSB0cnkgc2V2ZXJhbCBtZXRob2RzIHRvIHJlY292ZXI6DQo+IA0KPiA+IAko
MSkgcHJlc3MgcG93ZXIgb24vb2ZmIGtleSwgZ2V0IENBTiBvdXQgb2Ygc3RvcCBtb2RlOw0KPiA+
IAkoMikgcmVib290IGNvbW1hbmQgZnJvbSBjb25zb2xlLCBnZXQgQ0FOIG91dCBvZiBzdG9wIG1v
ZGU7DQo+ID4gCSgzKSB1bmJpbmQvYmluZCBkcml2ZXIsIGNhbm5vdCBnZXQgQ0FOIG91dCBvZiBz
dG9wIG1vZGU7DQo+ID4gCSg0KSByZW1vZC9pbnNtb2QgbW9kdWxlLCBjYW5ub3QgZ2V0IENBTiBv
dXQgb2Ygc3RvcCBtb2RlOw0KPiANCj4gKDIpIHJlc2V0cyB0aGUgY29tcGxldGUgaW14LCBpbmNs
dWRpbmcgdGhlIENBTi1JUCBjb3JlLCAoMSkgcHJvYmFibHksIHRvby4NCj4gDQo+ICgzKSBhbmQg
KDQpIGZhaWwgdG8gcmVjb3ZlciB0aGUgQ0FOIGNvcmUsIGFzIHRoZSBJUCBjb3JlIGlzIHN0aWxs
IHBvd2VyZWQgb2ZmIGJ5DQo+IHNvbWUgdXBzdHJlYW0gY29tcG9uZW50LiBTbyB0aGUgcXVlc3Rp
b24gd2h5IHRoaXMgaGFwcGVucyBpbiB0aGUgZmlyc3QgcGxhY2UNCj4gaXMgSU1ITyBhcyBpbXBv
cnRhbnQgYXMgdHJ5aW5nIHRvIHdha2UgdXAgdGhlIGNvcmUuIEkgdGhpbmsgaWYgd2UgZGlzY292
ZXIgdGhpcw0KPiBzaXR1YXRpb24gKENBTiBDb3JlIGlzIGluIHN0b3AtbW9kZSBpbiBwcm9iZSkg
d2Ugc2hvdWxkIHByaW50IGEgd2FybmluZw0KPiBtZXNzYWdlLCBidXQgdHJ5IHRvIHJlY292ZXIu
DQo+IA0KPiA+Pj4gc28gYWRkIHN0b3AgbW9kZSByZW1vdmUgcmVxdWVzdCBkdXJpbmcgcHJvYmUg
c3RhZ2UgZm9yIG90aGVyDQo+ID4+PiBtZXRob2RzKHNvZnQgcmVzZXQgZnJvbSBjaGlwIGxldmVs
LCB1bmJpbmQvYmluZCBkcml2ZXIsIGV0YykgdG8gbGV0DQo+ID4+ICAgICAgICAgXl5eIHBsZWFz
ZSBhZGQgYSBzcGFjZQ0KPiA+Pj4gQ0FOIGFjdGl2ZSBhZ2Fpbi4NCj4gPj4NCj4gPj4gQ2FuIHlv
dSByZXBocmFzZSB0aGUgc2VudGVuY2UgYWZ0ZXIgInNvIGFkZCBzdG9wIG1vZGUgcmVtb3ZlIHJl
cXVlc3QNCj4gPj4gZHVyaW5nIHByb2JlIHN0YWdlIi4gSSdtIG5vdCBjb21wbGV0ZWx5IHN1cmUg
d2hhdCB5b3Ugd2FudCB0byB0ZWxsLg0KPiA+DQo+ID4gU3VyZS4NCj4gDQo+IHRueCwNCj4gTWFy
Yw0KPiANCj4gLS0NCj4gUGVuZ3V0cm9uaXggZS5LLiAgICAgICAgICAgICAgICAgfCBNYXJjIEts
ZWluZS1CdWRkZSAgICAgICAgICAgfA0KPiBFbWJlZGRlZCBMaW51eCAgICAgICAgICAgICAgICAg
ICB8IGh0dHBzOi8vd3d3LnBlbmd1dHJvbml4LmRlICB8DQo+IFZlcnRyZXR1bmcgV2VzdC9Eb3J0
bXVuZCAgICAgICAgIHwgUGhvbmU6ICs0OS0yMzEtMjgyNi05MjQgICAgIHwNCj4gQW10c2dlcmlj
aHQgSGlsZGVzaGVpbSwgSFJBIDI2ODYgfCBGYXg6ICAgKzQ5LTUxMjEtMjA2OTE3LTU1NTUgfA0K
DQo=
