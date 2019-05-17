Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F68421243
	for <lists+netdev@lfdr.de>; Fri, 17 May 2019 04:47:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727540AbfEQCra (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 May 2019 22:47:30 -0400
Received: from mail-eopbgr50084.outbound.protection.outlook.com ([40.107.5.84]:11397
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727195AbfEQCr3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 May 2019 22:47:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CD6MChlbZekd1equpKfzVu8H8N10MkSGemB6SGyuDYs=;
 b=SO7RnzZ+PihBH/OVWh2IzGQC7nbo6mkcg6lGEBsrShpLj4x08Q8LW+qXc4OWIJSgrc5S0mi/sIJ7FDtfl/Ho1nU3RGeybi0IJkg9FSvZedMEUdHZcp+4K7mzLvtRkli2nEdZB09CvjqCxv8LcayEwgMtbZqkx/bmqJDVqtfMF6s=
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com (52.135.138.152) by
 DB7PR04MB5484.eurprd04.prod.outlook.com (20.178.105.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1900.16; Fri, 17 May 2019 02:47:24 +0000
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::bd02:a611:1f0:daac]) by DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::bd02:a611:1f0:daac%6]) with mapi id 15.20.1900.010; Fri, 17 May 2019
 02:47:24 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     "mkl@pengutronix.de" <mkl@pengutronix.de>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>
CC:     dl-linux-imx <linux-imx@nxp.com>,
        "wg@grandegger.com" <wg@grandegger.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH] can: flexcan: fix deadlock when using self wakeup
Thread-Topic: [PATCH] can: flexcan: fix deadlock when using self wakeup
Thread-Index: AQHVDFm06ozNDmulK0GLXWOup5sGAaZumuVg
Date:   Fri, 17 May 2019 02:47:24 +0000
Message-ID: <DB7PR04MB46182799A768197CC7CEA9D0E60B0@DB7PR04MB4618.eurprd04.prod.outlook.com>
References: <20190517023652.19285-1-qiangqing.zhang@nxp.com>
In-Reply-To: <20190517023652.19285-1-qiangqing.zhang@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=qiangqing.zhang@nxp.com; 
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 30231ab2-c9ff-4c35-ca81-08d6da71fdc5
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:DB7PR04MB5484;
x-ms-traffictypediagnostic: DB7PR04MB5484:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <DB7PR04MB5484E8562FE06D13EC11A07FE60B0@DB7PR04MB5484.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0040126723
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(376002)(366004)(396003)(136003)(39860400002)(13464003)(189003)(199004)(71200400001)(6436002)(6116002)(71190400001)(76116006)(5024004)(4326008)(53936002)(102836004)(14444005)(81156014)(5660300002)(3846002)(81166006)(256004)(6306002)(25786009)(86362001)(33656002)(8936002)(66066001)(229853002)(476003)(110136005)(486006)(68736007)(478600001)(446003)(52536014)(74316002)(2906002)(11346002)(316002)(8676002)(966005)(305945005)(7696005)(54906003)(2501003)(99286004)(73956011)(66476007)(66446008)(64756008)(66556008)(9686003)(55016002)(66946007)(7736002)(186003)(26005)(6246003)(53546011)(14454004)(76176011)(6506007);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7PR04MB5484;H:DB7PR04MB4618.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: RmWk8iBdajp1Ohe2REN+rbop3XoCBdrNabRnYHuxnMcfey6u7ahJwek03pzDdKMVz3hHPb5vbFbTgwkJpN/QatNzKWPhEfILjOx15Ib8NhrNU8idsc0cwqkBlLbm+7qbn8rHptbzJvsWVs2uruUAO5UJA/iPYmdmnKuskzAxBWNMOGSov5S9+BsJx0LROj5tzdIkmFhydIIt4FodFvKtn6apjEv0UrnrXRco98ChfEixUOY5srzKrdqLySK2Ov0fcO5J4facZaE/KxxHfcUAHpQtALGHwkCFA0g987IQLFbvTrZIiH3UO9AYNduOhTSVW1uUemuXFvOdrFKZ09HGI9l6huiPZljiZiGxpE0WOhjZlQ9UANh6aUNmHWeUPQPYunMx7vmQ4tr3I88XWu0I1qxpWD5Dbhouxpcb3D4Amak=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 30231ab2-c9ff-4c35-ca81-08d6da71fdc5
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 May 2019 02:47:24.2471
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB5484
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpIaSBNYXJjLA0KDQpTZWFuIE55ZWtqYWVyIHJlcG9ydGVkIHRoZSBpc3N1ZSwgYnV0IHRoZSBm
aXggaXMgaW5jb3JyZWN0Lg0KaHR0cHM6Ly93d3cuc3Bpbmljcy5uZXQvbGlzdHMvbGludXgtY2Fu
L21zZzAxNDQ3Lmh0bWwNCg0KQ291bGQgeW91IGhlbHAgdG8gYWRkIFNlYW4gTnlla2phZXIgdG8g
dGhpcyB0aHJlYWQgYXMgSSBjYW4ndCBnZXQgdGhlIGVtYWlsIGFkZHJlc3MuDQpZb3UgY2FuIGFk
ZCB0aGUgIlJlcG9ydGVkLWJ5IiB0YWcgaWYgeW91IHBpY2sgdXAgdGhlIHBhdGNoLg0KDQpUaGFu
a3MgYSBsb3QhDQoNCkJlc3QgUmVnYXJkcywNCkpvYWtpbSBaaGFuZw0KDQo+IC0tLS0tT3JpZ2lu
YWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IEpvYWtpbSBaaGFuZw0KPiBTZW50OiAyMDE55bm0Neac
iDE35pelIDEwOjM5DQo+IFRvOiBta2xAcGVuZ3V0cm9uaXguZGU7IGxpbnV4LWNhbkB2Z2VyLmtl
cm5lbC5vcmcNCj4gQ2M6IGRsLWxpbnV4LWlteCA8bGludXgtaW14QG54cC5jb20+OyB3Z0BncmFu
ZGVnZ2VyLmNvbTsNCj4gbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsgSm9ha2ltIFpoYW5nIDxxaWFu
Z3FpbmcuemhhbmdAbnhwLmNvbT4NCj4gU3ViamVjdDogW1BBVENIXSBjYW46IGZsZXhjYW46IGZp
eCBkZWFkbG9jayB3aGVuIHVzaW5nIHNlbGYgd2FrZXVwDQo+IA0KPiBBcyByZXByb3RlZCBieSBT
ZWFuIE55ZWtqYWVyIGJlbGxvdzoNCj4gV2hlbiBzdXNwZW5kaW5nLCB3aGVuIHRoZXJlIGlzIHN0
aWxsIGNhbiB0cmFmZmljIG9uIHRoZSBpbnRlcmZhY2VzIHRoZSBmbGV4Y2FuDQo+IGltbWVkaWF0
ZWx5IHdha2VzIHRoZSBwbGF0Zm9ybSBhZ2Fpbi4NCj4gQXMgaXQgc2hvdWxkIDotKQ0KPiBCdXQg
aXQgdGhyb3dzIHRoaXMgZXJyb3IgbXNnOg0KPiBbIDMxNjkuMzc4NjYxXSBQTTogbm9pcnEgc3Vz
cGVuZCBvZiBkZXZpY2VzIGZhaWxlZA0KPiANCj4gT24gdGhlIHdheSBkb3duIHRvIHN1c3BlbmQg
dGhlIGludGVyZmFjZSB0aGF0IHRocm93cyB0aGUgZXJyb3IgbWVzc2FnZSBkb2VzDQo+IGNhbGwg
ZmxleGNhbl9zdXNwZW5kIGJ1dCBmYWlscyB0byBjYWxsIGZsZXhjYW5fbm9pcnFfc3VzcGVuZC4N
Cj4gVGhhdCBtZWFucyB0aGUgZmxleGNhbl9lbnRlcl9zdG9wX21vZGUgaXMgY2FsbGVkLCBidXQg
b24gdGhlIHdheSBvdXQgb2YNCj4gc3VzcGVuZCB0aGUgZHJpdmVyIG9ubHkgY2FsbHMgZmxleGNh
bl9yZXN1bWUgYW5kIHNraXBzIGZsZXhjYW5fbm9pcnFfcmVzdW1lLA0KPiB0aHVzIGl0IGRvZXNu
J3QgY2FsbCBmbGV4Y2FuX2V4aXRfc3RvcF9tb2RlLg0KPiBUaGlzIGxlYXZlcyB0aGUgZmxleGNh
biBpbiBzdG9wIG1vZGUsIGFuZCB3aXRoIHRoZSBjdXJyZW50IGRyaXZlciBpdCBjYW4ndA0KPiBy
ZWNvdmVyIGZyb20gdGhpcyBldmVuIHdpdGggYSBzb2Z0IHJlYm9vdCwgaXQgcmVxdWlyZXMgYSBo
YXJkIHJlYm9vdC4NCj4gDQo+IEZpeGVzOiBkZTM1NzhjMTk4YzYgKCJjYW46IGZsZXhjYW46IGFk
ZCBzZWxmIHdha2V1cCBzdXBwb3J0IikNCj4gDQo+IFRoaXMgcGF0Y2ggaW50ZW5kcyB0byBmaXgg
dGhlIGlzc3VlLCBhbmQgYWxzbyBhZGQgY29tbWVudCB0byBleHBsYWluIHRoZQ0KPiB3YWtldXAg
Zmxvdy4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IEpvYWtpbSBaaGFuZyA8cWlhbmdxaW5nLnpoYW5n
QG54cC5jb20+DQo+IC0tLQ0KPiAgZHJpdmVycy9uZXQvY2FuL2ZsZXhjYW4uYyB8IDE3ICsrKysr
KysrKysrKysrKysrDQo+ICAxIGZpbGUgY2hhbmdlZCwgMTcgaW5zZXJ0aW9ucygrKQ0KPiANCj4g
ZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2Nhbi9mbGV4Y2FuLmMgYi9kcml2ZXJzL25ldC9jYW4v
ZmxleGNhbi5jIGluZGV4DQo+IGUzNTA4M2ZmMzFlZS4uNmZiY2U0NzNhOGM3IDEwMDY0NA0KPiAt
LS0gYS9kcml2ZXJzL25ldC9jYW4vZmxleGNhbi5jDQo+ICsrKyBiL2RyaXZlcnMvbmV0L2Nhbi9m
bGV4Y2FuLmMNCj4gQEAgLTI4Niw2ICsyODYsNyBAQCBzdHJ1Y3QgZmxleGNhbl9wcml2IHsNCj4g
IAljb25zdCBzdHJ1Y3QgZmxleGNhbl9kZXZ0eXBlX2RhdGEgKmRldnR5cGVfZGF0YTsNCj4gIAlz
dHJ1Y3QgcmVndWxhdG9yICpyZWdfeGNlaXZlcjsNCj4gIAlzdHJ1Y3QgZmxleGNhbl9zdG9wX21v
ZGUgc3RtOw0KPiArCWJvb2wgaW5fc3RvcF9tb2RlOw0KPiANCj4gIAkvKiBSZWFkIGFuZCBXcml0
ZSBBUElzICovDQo+ICAJdTMyICgqcmVhZCkodm9pZCBfX2lvbWVtICphZGRyKTsNCj4gQEAgLTE2
NTMsNiArMTY1NCw3IEBAIHN0YXRpYyBpbnQgX19tYXliZV91bnVzZWQgZmxleGNhbl9zdXNwZW5k
KHN0cnVjdA0KPiBkZXZpY2UgKmRldmljZSkNCj4gIAkJaWYgKGRldmljZV9tYXlfd2FrZXVwKGRl
dmljZSkpIHsNCj4gIAkJCWVuYWJsZV9pcnFfd2FrZShkZXYtPmlycSk7DQo+ICAJCQlmbGV4Y2Fu
X2VudGVyX3N0b3BfbW9kZShwcml2KTsNCj4gKwkJCXByaXYtPmluX3N0b3BfbW9kZSA9IHRydWU7
DQo+ICAJCX0gZWxzZSB7DQo+ICAJCQllcnIgPSBmbGV4Y2FuX2NoaXBfZGlzYWJsZShwcml2KTsN
Cj4gIAkJCWlmIChlcnIpDQo+IEBAIC0xNjc5LDYgKzE2ODEsMTEgQEAgc3RhdGljIGludCBfX21h
eWJlX3VudXNlZCBmbGV4Y2FuX3Jlc3VtZShzdHJ1Y3QNCj4gZGV2aWNlICpkZXZpY2UpDQo+ICAJ
CW5ldGlmX2RldmljZV9hdHRhY2goZGV2KTsNCj4gIAkJbmV0aWZfc3RhcnRfcXVldWUoZGV2KTsN
Cj4gIAkJaWYgKGRldmljZV9tYXlfd2FrZXVwKGRldmljZSkpIHsNCj4gKwkJCWlmIChwcml2LT5p
bl9zdG9wX21vZGUpIHsNCj4gKwkJCQlmbGV4Y2FuX2VuYWJsZV93YWtldXBfaXJxKHByaXYsIGZh
bHNlKTsNCj4gKwkJCQlmbGV4Y2FuX2V4aXRfc3RvcF9tb2RlKHByaXYpOw0KPiArCQkJCXByaXYt
PmluX3N0b3BfbW9kZSA9IGZhbHNlOw0KPiArCQkJfQ0KPiAgCQkJZGlzYWJsZV9pcnFfd2FrZShk
ZXYtPmlycSk7DQo+ICAJCX0gZWxzZSB7DQo+ICAJCQllcnIgPSBwbV9ydW50aW1lX2ZvcmNlX3Jl
c3VtZShkZXZpY2UpOyBAQCAtMTcxNSw2DQo+ICsxNzIyLDExIEBAIHN0YXRpYyBpbnQgX19tYXli
ZV91bnVzZWQgZmxleGNhbl9ub2lycV9zdXNwZW5kKHN0cnVjdCBkZXZpY2UNCj4gKmRldmljZSkN
Cj4gIAlzdHJ1Y3QgbmV0X2RldmljZSAqZGV2ID0gZGV2X2dldF9kcnZkYXRhKGRldmljZSk7DQo+
ICAJc3RydWN0IGZsZXhjYW5fcHJpdiAqcHJpdiA9IG5ldGRldl9wcml2KGRldik7DQo+IA0KPiAr
CS8qIE5lZWQgZW5hYmxlIHdha2V1cCBpbnRlcnJ1cHQgaW4gbm9pcnEgc3VzcGVuZCBzdGFnZS4g
T3RoZXJ3aXNlLA0KPiArCSAqIGl0IHdpbGwgdHJpZ2dlciBjb250aW51b3VzbHkgd2FrZXVwIGlu
dGVycnVwdCBpZiB0aGUgd2FrZXVwIGV2ZW50DQo+ICsJICogY29tZXMgYmVmb3JlIG5vaXJxIHN1
c3BlbmQgc3RhZ2UsIGFuZCBzaW11bHRhbmVvdXNseSBpbiBoYXMgZW50ZXINCj4gKwkgKiB0aGUg
c3RvcCBtb2RlLg0KPiArCSAqLw0KPiAgCWlmIChuZXRpZl9ydW5uaW5nKGRldikgJiYgZGV2aWNl
X21heV93YWtldXAoZGV2aWNlKSkNCj4gIAkJZmxleGNhbl9lbmFibGVfd2FrZXVwX2lycShwcml2
LCB0cnVlKTsNCj4gDQo+IEBAIC0xNzI2LDkgKzE3MzgsMTQgQEAgc3RhdGljIGludCBfX21heWJl
X3VudXNlZA0KPiBmbGV4Y2FuX25vaXJxX3Jlc3VtZShzdHJ1Y3QgZGV2aWNlICpkZXZpY2UpDQo+
ICAJc3RydWN0IG5ldF9kZXZpY2UgKmRldiA9IGRldl9nZXRfZHJ2ZGF0YShkZXZpY2UpOw0KPiAg
CXN0cnVjdCBmbGV4Y2FuX3ByaXYgKnByaXYgPSBuZXRkZXZfcHJpdihkZXYpOw0KPiANCj4gKwkv
KiBOZWVkIGV4aXQgc3RvcCBtb2RlIGluIG5vaXJxIHJlc3VtZSBzdGFnZS4gT3RoZXJ3aXNlLCBp
dCB3aWxsDQo+ICsJICogdHJpZ2dlciBjb250aW51b3VzbHkgd2FrZXVwIGludGVycnVwdCBpZiB0
aGUgd2FrZXVwIGV2ZW50IGNvbWVzLA0KPiArCSAqIGFuZCBzaW11bHRhbmVvdXNseSBpdCBoYXMg
c3RpbGwgaW4gc3RvcCBtb2RlLg0KPiArCSAqLw0KPiAgCWlmIChuZXRpZl9ydW5uaW5nKGRldikg
JiYgZGV2aWNlX21heV93YWtldXAoZGV2aWNlKSkgew0KPiAgCQlmbGV4Y2FuX2VuYWJsZV93YWtl
dXBfaXJxKHByaXYsIGZhbHNlKTsNCj4gIAkJZmxleGNhbl9leGl0X3N0b3BfbW9kZShwcml2KTsN
Cj4gKwkJcHJpdi0+aW5fc3RvcF9tb2RlID0gZmFsc2U7DQo+ICAJfQ0KPiANCj4gIAlyZXR1cm4g
MDsNCj4gLS0NCj4gMi4xNy4xDQoNCg==
