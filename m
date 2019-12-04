Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E517112546
	for <lists+netdev@lfdr.de>; Wed,  4 Dec 2019 09:35:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727733AbfLDIfW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Dec 2019 03:35:22 -0500
Received: from mail-eopbgr10060.outbound.protection.outlook.com ([40.107.1.60]:27926
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726679AbfLDIfV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Dec 2019 03:35:21 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C6zzn6SwrThM2/7U0YXSkS9HtllvqpEFAUPvJe27XJECqKIq0FeJjavsNTJwzSJOh8oFnmKPZ5oNEFFQAiLMIrdPueYwLN7JyqMKRR78DYY5O0r7u8EuFwo1rGgVU9GYW/vOGXypO/sWlx2I6RNivS/c34YnA1PP0SA6CppM46UzD+4lYNMHCXtOxtXX5+zu8LVns7/cPbdTGKFTdE41WU6cM/xi+LGEONxU9JkDlewt4LickiLAQs0P6Qx/Il7pZPG2CTUB4S8sZmlZhI7qG37hFjjveH2qqe5PtU2yDsCenq8oJ8yqt7ryKsJnZ3/r4cFfhuhXCyu+21NittdPRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ru9H5nnxjq4/nPuhKp9czDP0QI4Fzc1FNh3OSTRo5Xs=;
 b=L6XiiTe3w5ttvtfjIVCowgDBRD+JzF48ZaQF14JoEJ7Oi3A8kd76MWDhsm6LGpJ183JcXl5UH0rEPBmNIYWDn3Dg/L53Vt98GP0c9P5OMFaeDOApCbQmuVKTDoGosmcBVZjPWNxGR3oDf2wIYH3L6W6MHGo35W5NubwrxR1o0wF9YsLnk8QehxkzKxl1F8gYqEv3GHbvPmFAMXh6E1EngzZLCQVdAlkxsY68NENgs0I3hjGkI4zjU/gU3ScJ2vSugnmVTtHIWlQbH4Od2SQjwNa/4Spw/q1FWPkK13X6O9Jl9zbs4qg6Qf0FbgA5wfjsCeuMQdfRzndIxCSVQCRhHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ru9H5nnxjq4/nPuhKp9czDP0QI4Fzc1FNh3OSTRo5Xs=;
 b=cRuFtN5MGEVhHlA1rfV35OmgF7wSH5ZtXbe9LDHWPVtwRa/MsTHwb9bESQ7jY6xZW+hVt4SDms+j7VGX51iOTLKUvYKZvfLa3EmjFvVVhFIp/WmTLzCBZ4YER0+xx5Zm0KVbq+m6Q9M2OjQv8OYrtHCZHcOIQmta0gyux/vSfcw=
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com (52.135.139.151) by
 DB7PR04MB4714.eurprd04.prod.outlook.com (20.176.233.31) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2516.12; Wed, 4 Dec 2019 08:35:13 +0000
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::1c96:c591:7d51:64e6]) by DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::1c96:c591:7d51:64e6%4]) with mapi id 15.20.2516.003; Wed, 4 Dec 2019
 08:35:13 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     Marc Kleine-Budde <mkl@pengutronix.de>,
        "sean@geanix.com" <sean@geanix.com>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>
CC:     dl-linux-imx <linux-imx@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH V2 1/4] can: flexcan: fix deadlock when using self wakeup
Thread-Topic: [PATCH V2 1/4] can: flexcan: fix deadlock when using self wakeup
Thread-Index: AQHVpOdz4P6zsP3HCk29mcugpy847aeos2gAgACJGRCAAHQGgIAAAObQ
Date:   Wed, 4 Dec 2019 08:35:13 +0000
Message-ID: <DB7PR04MB46188F5455DD63DF05191F27E65D0@DB7PR04MB4618.eurprd04.prod.outlook.com>
References: <20191127055334.1476-1-qiangqing.zhang@nxp.com>
 <20191127055334.1476-2-qiangqing.zhang@nxp.com>
 <b77829d5-9eda-a244-3ee8-2ccdbdfb6524@pengutronix.de>
 <DB7PR04MB46183730127339DAC15ABF33E65D0@DB7PR04MB4618.eurprd04.prod.outlook.com>
 <b4ce5a7a-7fc0-edb2-608e-4030ce6428a2@pengutronix.de>
In-Reply-To: <b4ce5a7a-7fc0-edb2-608e-4030ce6428a2@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=qiangqing.zhang@nxp.com; 
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: ff3fc208-3b72-4195-ad70-08d77894e1ce
x-ms-traffictypediagnostic: DB7PR04MB4714:|DB7PR04MB4714:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB7PR04MB4714CF3F7907904B702BEC1BE65D0@DB7PR04MB4714.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 0241D5F98C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(366004)(136003)(396003)(376002)(346002)(189003)(199004)(13464003)(5660300002)(99286004)(7736002)(6506007)(102836004)(2906002)(305945005)(86362001)(66476007)(256004)(2201001)(53546011)(7696005)(8676002)(81166006)(74316002)(81156014)(76176011)(186003)(26005)(8936002)(11346002)(446003)(71190400001)(71200400001)(229853002)(3846002)(6116002)(478600001)(14454004)(2501003)(966005)(6246003)(4326008)(66946007)(64756008)(66446008)(52536014)(25786009)(66556008)(110136005)(54906003)(316002)(55016002)(9686003)(6306002)(76116006)(33656002)(6436002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7PR04MB4714;H:DB7PR04MB4618.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 12BFwBLllstvRIJtiGZeoClcvJyE9lQxipOSGav81h77b4t3EM8I5KIscfpZ/eaWhdv8iF5h6YU808p8D41NXxD4OZfXVS8fAzy2oIf6LifeTDavm5+VcFNgjwYXmi58tApqewb7SYS1lj1vA7uvIO2MUx/VYxTObvYzKJz/jso5iwLw93kBLnV6RjM9xAjZmtpARAmzoDaYORYyVYXnVnRWsX7EZ0hb7GRrNcSFSOfTniOTCoPaL9euMGY1oySfcY8K0QJtxyxDW6x+EJPs13h+3mOHUIfWJmWsJ9pz2tQjXiDqEVGD759zvzo86mmppndhhjPO3jOsiCo4M9rwN0ENgfnlZLq8Xg6Ti4yk5i4PIYr1G/42opIVcQCqEGIzwtrXKdmHLopuubrNpdkJgvrBvJZALq5Ftw+xrzoJr735RggAVLH4DQ4fnoF7GGGJyZbYrg+/el/y0SLyWpsamK9m4u4HFEtZOmt5m6c9Rtkk1mvozGJZhgmGJ2Z5IH1nwZdjHm9qZ3ELAuA0Qx/blzEO0MW7pJGKJp9FcZpoxdI=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ff3fc208-3b72-4195-ad70-08d77894e1ce
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Dec 2019 08:35:13.4836
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MOe6WCk2nr5lWH4fiK/tRWn+X13ElMf+KhI3pMdeM+VEwiewyYzvcKFfhMOAMNY3y7agH/WX9PUPDH7KsgP0IQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4714
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IE1hcmMgS2xlaW5lLUJ1ZGRl
IDxta2xAcGVuZ3V0cm9uaXguZGU+DQo+IFNlbnQ6IDIwMTnlubQxMuaciDTml6UgMTY6MzENCj4g
VG86IEpvYWtpbSBaaGFuZyA8cWlhbmdxaW5nLnpoYW5nQG54cC5jb20+OyBzZWFuQGdlYW5peC5j
b207DQo+IGxpbnV4LWNhbkB2Z2VyLmtlcm5lbC5vcmcNCj4gQ2M6IGRsLWxpbnV4LWlteCA8bGlu
dXgtaW14QG54cC5jb20+OyBuZXRkZXZAdmdlci5rZXJuZWwub3JnDQo+IFN1YmplY3Q6IFJlOiBb
UEFUQ0ggVjIgMS80XSBjYW46IGZsZXhjYW46IGZpeCBkZWFkbG9jayB3aGVuIHVzaW5nIHNlbGYg
d2FrZXVwDQo+IA0KPiBPbiAxMi80LzE5IDI6NTggQU0sIEpvYWtpbSBaaGFuZyB3cm90ZToNCj4g
PiBbLi4uXQ0KPiA+Pj4gIGRyaXZlcnMvbmV0L2Nhbi9mbGV4Y2FuLmMgfCAxOSArKysrKysrKysr
Ky0tLS0tLS0tDQo+ID4+PiAgMSBmaWxlIGNoYW5nZWQsIDExIGluc2VydGlvbnMoKyksIDggZGVs
ZXRpb25zKC0pDQo+ID4+Pg0KPiA+Pj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2Nhbi9mbGV4
Y2FuLmMgYi9kcml2ZXJzL25ldC9jYW4vZmxleGNhbi5jDQo+ID4+PiBpbmRleCAyZWZhMDYxMTlm
NjguLjIyOTc2NjNjYWNiMiAxMDA2NDQNCj4gPj4+IC0tLSBhL2RyaXZlcnMvbmV0L2Nhbi9mbGV4
Y2FuLmMNCj4gPj4+ICsrKyBiL2RyaXZlcnMvbmV0L2Nhbi9mbGV4Y2FuLmMNCj4gPj4+IEBAIC0x
MzQsOCArMTM0LDcgQEANCj4gPj4+ICAJKEZMRVhDQU5fRVNSX0VSUl9CVVMgfCBGTEVYQ0FOX0VT
Ul9FUlJfU1RBVEUpICAjZGVmaW5lDQo+ID4+PiBGTEVYQ0FOX0VTUl9BTExfSU5UIFwNCj4gPj4+
ICAJKEZMRVhDQU5fRVNSX1RXUk5fSU5UIHwgRkxFWENBTl9FU1JfUldSTl9JTlQgfCBcDQo+ID4+
PiAtCSBGTEVYQ0FOX0VTUl9CT0ZGX0lOVCB8IEZMRVhDQU5fRVNSX0VSUl9JTlQgfCBcDQo+ID4+
PiAtCSBGTEVYQ0FOX0VTUl9XQUtfSU5UKQ0KPiA+Pj4gKwkgRkxFWENBTl9FU1JfQk9GRl9JTlQg
fCBGTEVYQ0FOX0VTUl9FUlJfSU5UKQ0KPiA+Pg0KPiA+PiBXaHkgZG8geW91IHJlbW92ZSB0aGUg
RkxFWENBTl9FU1JfV0FLX0lOVCBmcm9tIHRoZQ0KPiA+PiBGTEVYQ0FOX0VTUl9BTExfSU5UPw0K
PiA+Pg0KPiA+Pj4NCj4gPj4+ICAvKiBGTEVYQ0FOIGludGVycnVwdCBmbGFnIHJlZ2lzdGVyIChJ
RkxBRykgYml0cyAqLw0KPiA+Pj4gIC8qIEVycmF0YSBFUlIwMDU4Mjkgc3RlcDc6IFJlc2VydmUg
Zmlyc3QgdmFsaWQgTUIgKi8gQEAgLTk2MCw2DQo+ID4+PiArOTU5LDEyIEBAIHN0YXRpYyBpcnFy
ZXR1cm5fdCBmbGV4Y2FuX2lycShpbnQgaXJxLCB2b2lkICpkZXZfaWQpDQo+ID4+Pg0KPiA+Pj4g
IAlyZWdfZXNyID0gcHJpdi0+cmVhZCgmcmVncy0+ZXNyKTsNCj4gPj4+DQo+ID4+PiArCS8qIEFD
SyB3YWtldXAgaW50ZXJydXB0ICovDQo+ID4+PiArCWlmIChyZWdfZXNyICYgRkxFWENBTl9FU1Jf
V0FLX0lOVCkgew0KPiA+Pj4gKwkJaGFuZGxlZCA9IElSUV9IQU5ETEVEOw0KPiA+Pj4gKwkJcHJp
di0+d3JpdGUocmVnX2VzciAmIEZMRVhDQU5fRVNSX1dBS19JTlQsICZyZWdzLT5lc3IpOw0KPiA+
Pj4gKwl9DQo+ID4+PiArDQo+ID4+DQo+ID4+IElmIEZMRVhDQU5fRVNSX1dBS19JTlQgc3RheXMg
aW4gRkxFWENBTl9FU1JfQUxMX0lOVCwgeW91IGRvbid0IG5lZWQNCj4gPj4gdGhhdCBleHBsaWNp
dCBBQ0sgaGVyZS4NCj4gPg0KPiA+IEhpIE1hcmMsDQo+ID4NCj4gPiBJIHJlbW92ZSB0aGUgRkxF
WENBTl9FU1JfV0FLX0lOVCBmcm9tIHRoZSBGTEVYQ0FOX0VTUl9BTExfSU5UIHNpbmNlDQo+ID4g
RkxFWENBTl9FU1JfQUxMX0lOVCBpcyBmb3IgYWxsIGJ1cyBlcnJvciBhbmQgc3RhdGUgY2hhbmdl
IElSUSBzb3VyY2VzLA0KPiA+IHdha2V1cCBpbnRlcnJ1cHQgZG9lcyBub3QgYmVsb25nIHRvIHRo
ZXNlLiBJZiB5b3UgdGhpbmsgdGhpcyBkb2VzIG5vdA0KPiA+IG5lZWQsIEkgY2FuIHJlbW92ZSB0
aGlzIGNoYW5nZS4NCj4gDQo+IEkgc2VlLCBtYWtlcyBzZW5zZS4NCj4gDQo+IE1ha2UgdGhpcyBh
IHNlcGFyYXRlIHBhdGNoLiBNb3ZlIHRoZSBGTEVYQ0FOX0VTUl9XQUtfSU5UIGZyb20gdGhlDQo+
IEZMRVhDQU5fRVNSX0FMTF9JTlQsIGJ1dCBhZGQgaXQgdG8gdGhlIGV4aXN0aW5nIGFjayBvZiB0
aGUgaW50ZXJydXB0cy4NCj4gTGlrZSB0aGlzOg0KPiANCj4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVy
cy9uZXQvY2FuL2ZsZXhjYW4uYyBiL2RyaXZlcnMvbmV0L2Nhbi9mbGV4Y2FuLmMNCj4gPiBpbmRl
eCBiNmY2NzVhNWUyZDkuLjc0ZjYyMmI0MGI2MSAxMDA2NDQNCj4gPiAtLS0gYS9kcml2ZXJzL25l
dC9jYW4vZmxleGNhbi5jDQo+ID4gKysrIGIvZHJpdmVycy9uZXQvY2FuL2ZsZXhjYW4uYw0KPiA+
IEBAIC05NjAsMTAgKzk2MCwxMCBAQCBzdGF0aWMgaXJxcmV0dXJuX3QgZmxleGNhbl9pcnEoaW50
IGlycSwgdm9pZA0KPiA+ICpkZXZfaWQpDQo+ID4NCj4gPiAgICAgICAgIHJlZ19lc3IgPSBwcml2
LT5yZWFkKCZyZWdzLT5lc3IpOw0KPiA+DQo+ID4gLSAgICAgICAvKiBBQ0sgYWxsIGJ1cyBlcnJv
ciBhbmQgc3RhdGUgY2hhbmdlIElSUSBzb3VyY2VzICovDQo+ID4gLSAgICAgICBpZiAocmVnX2Vz
ciAmIEZMRVhDQU5fRVNSX0FMTF9JTlQpIHsNCj4gPiArICAgICAgIC8qIEFDSyBhbGwgYnVzIGVy
cm9yLCBzdGF0ZSBjaGFuZ2UgYW5kIHdha2UgSVJRIHNvdXJjZXMgKi8NCj4gPiArICAgICAgIGlm
IChyZWdfZXNyICYgKEZMRVhDQU5fRVNSX0FMTF9JTlQgfCBGTEVYQ0FOX0VTUl9XQUtfSU5UKSkg
ew0KPiA+ICAgICAgICAgICAgICAgICBoYW5kbGVkID0gSVJRX0hBTkRMRUQ7DQo+ID4gLSAgICAg
ICAgICAgICAgIHByaXYtPndyaXRlKHJlZ19lc3IgJiBGTEVYQ0FOX0VTUl9BTExfSU5ULA0KPiAm
cmVncy0+ZXNyKTsNCj4gPiArICAgICAgICAgICAgICAgcHJpdi0+d3JpdGUocmVnX2VzciAmIChG
TEVYQ0FOX0VTUl9BTExfSU5UIHwNCj4gPiArIEZMRVhDQU5fRVNSX1dBS19JTlQpLCAmcmVncy0+
ZXNyKTsNCj4gPiAgICAgICAgIH0NCj4gPg0KPiA+ICAgICAgICAgLyogc3RhdGUgY2hhbmdlIGlu
dGVycnVwdCBvciBicm9rZW4gZXJyb3Igc3RhdGUgcXVpcmsgZml4IGlzDQo+ID4gZW5hYmxlZCAq
Lw0KDQpHb3QgaXQhIFRoYW5rcy4NCg0KQmVzdCBSZWdhcmRzLA0KSm9ha2ltIFpoYW5nDQo+IE1h
cmMNCj4gDQo+IC0tDQo+IFBlbmd1dHJvbml4IGUuSy4gICAgICAgICAgICAgICAgIHwgTWFyYyBL
bGVpbmUtQnVkZGUgICAgICAgICAgIHwNCj4gRW1iZWRkZWQgTGludXggICAgICAgICAgICAgICAg
ICAgfCBodHRwczovL3d3dy5wZW5ndXRyb25peC5kZSAgfA0KPiBWZXJ0cmV0dW5nIFdlc3QvRG9y
dG11bmQgICAgICAgICB8IFBob25lOiArNDktMjMxLTI4MjYtOTI0ICAgICB8DQo+IEFtdHNnZXJp
Y2h0IEhpbGRlc2hlaW0sIEhSQSAyNjg2IHwgRmF4OiAgICs0OS01MTIxLTIwNjkxNy01NTU1IHwN
Cg0K
