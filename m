Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0C798ACBE
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 04:36:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726498AbfHMCgo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 22:36:44 -0400
Received: from mail-eopbgr60054.outbound.protection.outlook.com ([40.107.6.54]:55429
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726236AbfHMCgn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Aug 2019 22:36:43 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iJe/LI9uDlmqCfbkvN4zTx/LGacJRV9apZCI+EeEEfRw+VG4FsjE3dNlCJqpJkxpNS+2Y/Qi1bDd6GxrniS9VU/NMPkk7FLUxdPhl4dKuUdFgytsDRaXbPTWNcsBOxBcj4v0XKt1fK12W27RERlYtlnh1OEsZUVkRbtOawLfK9xXBevkbtLZacPr3m5X0wjQ11OQVDAWfN8MJmjgvZVRjtAb2dXQWKLfZLC2FFRrN6HSjpHcNMKzUoTJR1gdYFHGQIFJiWZfoH7CqJjn5ElM9MVl+7X+i5cKqM6XAbnZpUM4icXHthXf6gzb3PmuxtBPWM/V4FSH0Gwhxsrva3hfOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PUcxA6nJxYu8KiQkh5l87JnGqxnizREdoJqrnV8rDpA=;
 b=gDK0x33DUalhKAoWr60VlALR/Q5k/L1kVMPGFw6aFSiqOHEbaKTaZd3OV4B3CdnaTIuKmIXQ56ctW9A2qg+IEeavOzc3rs35znkKAp30FLwes+2D2HsDw5mJSM7kmuDpfAJy0+cq/FmVIiJtEPYbn3StRA/+BA0sStNcPBJxIZX5xJrbjuD8ZwHfw4JWguefsHmg7Gb886K1jZx2Lg2iITETcTjEyAeudpmezynZReaCGyFOt4Pd1XBMbBLta//JGXouAr6y0JrFi9arzkYeedQp6Nv7fGMBogMAauHXT/M5ywYRwKM8kq37NW87qrHD1MHnTLFYqY5hV8TyLAuHOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PUcxA6nJxYu8KiQkh5l87JnGqxnizREdoJqrnV8rDpA=;
 b=hnC/6nnvdiXolx3YqBj1ZO9XGi2e7MCzBGlMnyhZDqJ14ugOHivSnKA/6fsKWY11KhRJp44MUwoniOGL1Rzty3rw+y/wQIky7OINROX0qWcXqyY817ndthw4E7cfe3IEiB/eRxRPMUbZ0bJ/9GqaO+8gWOqKbahIcq1QNMCfOpg=
Received: from VI1PR0401MB2237.eurprd04.prod.outlook.com (10.169.132.138) by
 VI1PR0401MB2639.eurprd04.prod.outlook.com (10.168.66.11) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.15; Tue, 13 Aug 2019 02:36:38 +0000
Received: from VI1PR0401MB2237.eurprd04.prod.outlook.com
 ([fe80::2072:e49f:a84a:8f37]) by VI1PR0401MB2237.eurprd04.prod.outlook.com
 ([fe80::2072:e49f:a84a:8f37%11]) with mapi id 15.20.2157.022; Tue, 13 Aug
 2019 02:36:38 +0000
From:   "Y.b. Lu" <yangbo.lu@nxp.com>
To:     "Allan W. Nielsen" <allan.nielsen@microchip.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>
Subject: RE: [PATCH 2/3] ocelot_ace: fix ingress ports setting for rule
Thread-Topic: [PATCH 2/3] ocelot_ace: fix ingress ports setting for rule
Thread-Index: AQHVUPsbL+NfI2eZKkyNF9uBx3208qb3c6+AgADnD5A=
Date:   Tue, 13 Aug 2019 02:36:38 +0000
Message-ID: <VI1PR0401MB2237D0E4A3664DC9A9106457F8D20@VI1PR0401MB2237.eurprd04.prod.outlook.com>
References: <20190812104827.5935-1-yangbo.lu@nxp.com>
 <20190812104827.5935-3-yangbo.lu@nxp.com>
 <20190812123820.qjaclomo6bhpz5pg@lx-anielsen.microsemi.net>
In-Reply-To: <20190812123820.qjaclomo6bhpz5pg@lx-anielsen.microsemi.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=yangbo.lu@nxp.com; 
x-originating-ip: [92.121.36.197]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2d3ddf0a-f492-4d88-ad6c-08d71f971107
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR0401MB2639;
x-ms-traffictypediagnostic: VI1PR0401MB2639:
x-microsoft-antispam-prvs: <VI1PR0401MB2639B7C68809093F8C148E1CF8D20@VI1PR0401MB2639.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 01283822F8
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(366004)(346002)(396003)(39860400002)(136003)(53754006)(13464003)(199004)(189003)(229853002)(486006)(476003)(256004)(66556008)(66476007)(6436002)(66066001)(6916009)(5660300002)(14454004)(8936002)(54906003)(446003)(64756008)(11346002)(66446008)(478600001)(71190400001)(71200400001)(53546011)(76116006)(316002)(81166006)(8676002)(7696005)(3846002)(2906002)(6246003)(66946007)(4326008)(53936002)(76176011)(55016002)(6506007)(86362001)(33656002)(81156014)(9686003)(102836004)(52536014)(25786009)(305945005)(186003)(26005)(7736002)(6116002)(99286004)(74316002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0401MB2639;H:VI1PR0401MB2237.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: yVnRaCNqzHxqkVniQgZGP85KDayk8f9KmzP/ocQfnR6n8o0G+2yc0HaCyhfCtyNdD87grMCNxdfDy37V+MHEm/BJod9rbcIsSJw3Zr2/w8mIy/ig7ZRv6r6xqV9BGBePK1TTLLYinmCDrQR1RxNajFeHMHWsQyTrrdullCLKbusCN/oRuyi32KGzzZ0A203YOVtLL3ThxH3GTDxqJDu5Mwdw7gGdG3j/vTBpeLGIEyvhDAj0gTba2ttc6BHX4SkkNtF2my3/Q/P3wjtTae5NE2YUbi0evbelnudDefcn1Cwhr4pDwrroAGChOj2AsVelVHDlSjiLWVgkLNPgZDn6PRf5mCIXIDqlga/lckFHqf4cHquf/rVP89dXuEn+7xMVtxYR+UdhPJWeqrlr5FfzlOUJa8dK41Q+Xv9irA9JV20=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d3ddf0a-f492-4d88-ad6c-08d71f971107
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Aug 2019 02:36:38.1143
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XCUQ6yZJxIseQlsdHpO1ZugImNBVqlxhckPkgEPeOHzJycyzMJwugIYG0/g+5k1QagYoRcPFCIv06QmqLULTEA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2639
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgQWxsYW4sDQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogQWxsYW4g
Vy4gTmllbHNlbiA8YWxsYW4ubmllbHNlbkBtaWNyb2NoaXAuY29tPg0KPiBTZW50OiBNb25kYXks
IEF1Z3VzdCAxMiwgMjAxOSA4OjM4IFBNDQo+IFRvOiBZLmIuIEx1IDx5YW5nYm8ubHVAbnhwLmNv
bT4NCj4gQ2M6IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7IERhdmlkIFMgLiBNaWxsZXIgPGRhdmVt
QGRhdmVtbG9mdC5uZXQ+Ow0KPiBBbGV4YW5kcmUgQmVsbG9uaSA8YWxleGFuZHJlLmJlbGxvbmlA
Ym9vdGxpbi5jb20+OyBNaWNyb2NoaXAgTGludXggRHJpdmVyDQo+IFN1cHBvcnQgPFVOR0xpbnV4
RHJpdmVyQG1pY3JvY2hpcC5jb20+DQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggMi8zXSBvY2Vsb3Rf
YWNlOiBmaXggaW5ncmVzcyBwb3J0cyBzZXR0aW5nIGZvciBydWxlDQo+IA0KPiBUaGUgMDgvMTIv
MjAxOSAxODo0OCwgWWFuZ2JvIEx1IHdyb3RlOg0KPiA+IFRoZSBpbmdyZXNzIHBvcnRzIHNldHRp
bmcgb2YgcnVsZSBzaG91bGQgc3VwcG9ydCBjb3ZlcmluZyBhbGwgcG9ydHMuDQo+ID4gVGhpcyBw
YXRjaCBpcyB0byB1c2UgdTE2IGluZ3Jlc3NfcG9ydCBmb3IgaW5ncmVzcyBwb3J0IG1hc2sgc2V0
dGluZw0KPiA+IGZvciBhY2UgcnVsZS4gT25lIGJpdCBjb3JyZXNwb25kcyBvbmUgcG9ydC4NCj4g
VGhhdCBpcyBob3cgdGhlIEhXIGlzIHdvcmtpbmcsIGFuZCBpdCB3b3VsZCBiZSBuaWNlIGlmIHdl
IGNvdWxkIG9wZXJhdGUgb24gYQ0KPiBwb3J0IG1hc2tzL2xpc3RzIGluc3RlYWQuIEJ1dCBob3cg
Y2FuIHRoaXMgYmUgdXNlZD8NCg0KW1kuYi4gTHVdIFdpbGwgdGhlIGNoYW5nZXMgYWZmZWN0IGFu
eXRoaW5nPyBDdXJyZW50IHVzYWdlIGluIG9jZWxvdF9mbG93ZXIuYyB3aWxsIGJlIGNvbnZlcnRl
ZCBhcyBiZWxvdy4NCg0KLSAgICAgICBydWxlLT5jaGlwX3BvcnQgPSBibG9jay0+cG9ydC0+Y2hp
cF9wb3J0Ow0KKyAgICAgICBydWxlLT5pbmdyZXNzX3BvcnQgPSBCSVQoYmxvY2stPnBvcnQtPmNo
aXBfcG9ydCk7DQoNCg0KPiANCj4gQ2FuIHlvdSBwbGVhc2UgZXhwbGFpbiBob3cvd2hlbiB0aGlz
IHdpbGwgbWFrZSBhIGRpZmZlcmVuY2U/DQoNCltZLmIuIEx1XSBBY3R1YWxseSBJIGhhdmUgYW5v
dGhlciBpbnRlcm5hbCBwYXRjaCBiYXNlZCBvbiB0aGlzIHBhdGNoLXNldCBmb3Igc2V0dGluZyBy
dWxlIG9mIHRyYXBwaW5nIElFRUUgMTU4OCBQVFAgRXRoZXJuZXQgZnJhbWVzLg0KRm9yIHN1Y2gg
cnVsZSB3aGljaCBzaG91bGQgYmUgYXBwbGllZCBvbiBzZXZlcmFsIGluZ3Jlc3MgcG9ydHMsIHdl
IGNhbiBzZXQgaXQgb25jZSB3aGVuIG9jZWxvdCBpbml0aWFsaXphdGlvbiBJIHRoaW5rLg0KDQpU
aGUgaW50ZXJuYWwgcGF0Y2ggSSBtZW50aW9uZWQgaXMgZm9yIGZlbGl4IHdoaWNoIGhhZCBkaWZm
ZXJlbnQgcG9ydHMgbnVtYmVyIChWQ0FQX1BPUlRfQ05UKS4gU28gSSBoYWRuJ3Qgc2VudCBpdCBv
dXQuDQpMZXQgbWUganVzdCBzZW5kIHYyIHBhdGNoLXNldCB3aXRoIHRoZSBwYXRjaCBkcm9wcGlu
ZyBWQ0FQX1BPUlRfQ05UIGNoYW5nZXMgZm9yIHlvdXIgcmV2aWV3aW5nLg0KUGxlYXNlIGZlZWwg
ZnJlZSB0byBwcm92aWRlIHN1Z2dlc3Rpb24uDQoNClRoYW5rcyBhIGxvdDopDQo+IA0KPiA+IFNp
Z25lZC1vZmYtYnk6IFlhbmdibyBMdSA8eWFuZ2JvLmx1QG54cC5jb20+DQo+ID4gLS0tDQo+ID4g
IGRyaXZlcnMvbmV0L2V0aGVybmV0L21zY2Mvb2NlbG90X2FjZS5jICAgIHwgMiArLQ0KPiA+ICBk
cml2ZXJzL25ldC9ldGhlcm5ldC9tc2NjL29jZWxvdF9hY2UuaCAgICB8IDIgKy0NCj4gPiAgZHJp
dmVycy9uZXQvZXRoZXJuZXQvbXNjYy9vY2Vsb3RfZmxvd2VyLmMgfCAyICstDQo+ID4gIDMgZmls
ZXMgY2hhbmdlZCwgMyBpbnNlcnRpb25zKCspLCAzIGRlbGV0aW9ucygtKQ0KPiA+DQo+ID4gZGlm
ZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L21zY2Mvb2NlbG90X2FjZS5jDQo+ID4gYi9k
cml2ZXJzL25ldC9ldGhlcm5ldC9tc2NjL29jZWxvdF9hY2UuYw0KPiA+IGluZGV4IDU1ODBhNTgu
LjkxMjUwZjMgMTAwNjQ0DQo+ID4gLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvbXNjYy9vY2Vs
b3RfYWNlLmMNCj4gPiArKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9tc2NjL29jZWxvdF9hY2Uu
Yw0KPiA+IEBAIC0zNTIsNyArMzUyLDcgQEAgc3RhdGljIHZvaWQgaXMyX2VudHJ5X3NldChzdHJ1
Y3Qgb2NlbG90ICpvY2Vsb3QsIGludCBpeCwNCj4gPiAgCWRhdGEudHlwZSA9IElTMl9BQ1RJT05f
VFlQRV9OT1JNQUw7DQo+ID4NCj4gPiAgCVZDQVBfS0VZX0FOWV9TRVQoUEFHKTsNCj4gPiAtCVZD
QVBfS0VZX1NFVChJR1JfUE9SVF9NQVNLLCAwLCB+QklUKGFjZS0+Y2hpcF9wb3J0KSk7DQo+ID4g
KwlWQ0FQX0tFWV9TRVQoSUdSX1BPUlRfTUFTSywgMCwgfmFjZS0+aW5ncmVzc19wb3J0KTsNCj4g
PiAgCVZDQVBfS0VZX0JJVF9TRVQoRklSU1QsIE9DRUxPVF9WQ0FQX0JJVF8xKTsNCj4gPiAgCVZD
QVBfS0VZX0JJVF9TRVQoSE9TVF9NQVRDSCwgT0NFTE9UX1ZDQVBfQklUX0FOWSk7DQo+ID4gIAlW
Q0FQX0tFWV9CSVRfU0VUKEwyX01DLCBhY2UtPmRtYWNfbWMpOyBkaWZmIC0tZ2l0DQo+ID4gYS9k
cml2ZXJzL25ldC9ldGhlcm5ldC9tc2NjL29jZWxvdF9hY2UuaA0KPiA+IGIvZHJpdmVycy9uZXQv
ZXRoZXJuZXQvbXNjYy9vY2Vsb3RfYWNlLmgNCj4gPiBpbmRleCBjZTcyZjAyLi4wZmUyM2UwIDEw
MDY0NA0KPiA+IC0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L21zY2Mvb2NlbG90X2FjZS5oDQo+
ID4gKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvbXNjYy9vY2Vsb3RfYWNlLmgNCj4gPiBAQCAt
MTkzLDcgKzE5Myw3IEBAIHN0cnVjdCBvY2Vsb3RfYWNlX3J1bGUgew0KPiA+DQo+ID4gIAllbnVt
IG9jZWxvdF9hY2VfYWN0aW9uIGFjdGlvbjsNCj4gPiAgCXN0cnVjdCBvY2Vsb3RfYWNlX3N0YXRz
IHN0YXRzOw0KPiA+IC0JaW50IGNoaXBfcG9ydDsNCj4gPiArCXUxNiBpbmdyZXNzX3BvcnQ7DQo+
ID4NCj4gPiAgCWVudW0gb2NlbG90X3ZjYXBfYml0IGRtYWNfbWM7DQo+ID4gIAllbnVtIG9jZWxv
dF92Y2FwX2JpdCBkbWFjX2JjOw0KPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5l
dC9tc2NjL29jZWxvdF9mbG93ZXIuYw0KPiA+IGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvbXNjYy9v
Y2Vsb3RfZmxvd2VyLmMNCj4gPiBpbmRleCA3YzYwZThjLi5iZmRkYzUwIDEwMDY0NA0KPiA+IC0t
LSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L21zY2Mvb2NlbG90X2Zsb3dlci5jDQo+ID4gKysrIGIv
ZHJpdmVycy9uZXQvZXRoZXJuZXQvbXNjYy9vY2Vsb3RfZmxvd2VyLmMNCj4gPiBAQCAtMTg0LDcg
KzE4NCw3IEBAIHN0cnVjdCBvY2Vsb3RfYWNlX3J1bGUNCj4gKm9jZWxvdF9hY2VfcnVsZV9jcmVh
dGUoc3RydWN0IGZsb3dfY2xzX29mZmxvYWQgKmYsDQo+ID4gIAkJcmV0dXJuIE5VTEw7DQo+ID4N
Cj4gPiAgCXJ1bGUtPm9jZWxvdCA9IGJsb2NrLT5wb3J0LT5vY2Vsb3Q7DQo+ID4gLQlydWxlLT5j
aGlwX3BvcnQgPSBibG9jay0+cG9ydC0+Y2hpcF9wb3J0Ow0KPiA+ICsJcnVsZS0+aW5ncmVzc19w
b3J0ID0gQklUKGJsb2NrLT5wb3J0LT5jaGlwX3BvcnQpOw0KPiA+ICAJcmV0dXJuIHJ1bGU7DQo+
ID4gIH0NCj4gDQo+IC0tIEFsbGFuDQo=
