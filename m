Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 435F6607EA
	for <lists+netdev@lfdr.de>; Fri,  5 Jul 2019 16:31:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726921AbfGEObf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jul 2019 10:31:35 -0400
Received: from mail-eopbgr140044.outbound.protection.outlook.com ([40.107.14.44]:1283
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726824AbfGEObf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Jul 2019 10:31:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ae2a+rciKDQ4hkH7ly5RU/AaMaQlv7qsCN81b0jzCck=;
 b=R0i59gb8XEhlUtpCEG32UNUmOfqlb+AXahnFdA+g2YH2Kg9AWaD+Fv+hpm50f5ScBzTjiA9vGHdkf7Q/8RiO0VhiUisnk9fwYpKn6O+uJQ5oAx9Ii4sthrs2momBuap5ueFNvTvSYb31U+raCO1OaIpGB8X5DKDhBa4K+/VR888=
Received: from DBBPR05MB6283.eurprd05.prod.outlook.com (20.179.40.84) by
 DBBPR05MB6412.eurprd05.prod.outlook.com (20.179.42.20) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2052.18; Fri, 5 Jul 2019 14:31:30 +0000
Received: from DBBPR05MB6283.eurprd05.prod.outlook.com
 ([fe80::2833:939d:2b5c:4a2d]) by DBBPR05MB6283.eurprd05.prod.outlook.com
 ([fe80::2833:939d:2b5c:4a2d%6]) with mapi id 15.20.2052.010; Fri, 5 Jul 2019
 14:31:30 +0000
From:   Tariq Toukan <tariqt@mellanox.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Saeed Mahameed <saeedm@mellanox.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        Boris Pismenny <borisp@mellanox.com>
Subject: Re: [net-next 14/14] net/mlx5e: Add kTLS TX HW offload support
Thread-Topic: [net-next 14/14] net/mlx5e: Add kTLS TX HW offload support
Thread-Index: AQHVMpSS/BacRvv0oEmovh1tsNIPwKa65HyAgAEzAQA=
Date:   Fri, 5 Jul 2019 14:31:29 +0000
Message-ID: <079d4170-d591-18c6-572e-dbec428f169e@mellanox.com>
References: <20190704181235.8966-1-saeedm@mellanox.com>
 <20190704181235.8966-15-saeedm@mellanox.com>
 <20190704131237.239bfa56@cakuba.netronome.com>
In-Reply-To: <20190704131237.239bfa56@cakuba.netronome.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM6P195CA0103.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:209:86::44) To DBBPR05MB6283.eurprd05.prod.outlook.com
 (2603:10a6:10:c1::20)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=tariqt@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [77.124.92.184]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cc5ffaa9-509a-41d1-de40-08d701557830
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DBBPR05MB6412;
x-ms-traffictypediagnostic: DBBPR05MB6412:
x-microsoft-antispam-prvs: <DBBPR05MB6412187A6924E9C1821943BEAEF50@DBBPR05MB6412.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 008960E8EC
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(366004)(346002)(136003)(39860400002)(376002)(189003)(199004)(11346002)(5660300002)(476003)(25786009)(2616005)(446003)(66946007)(73956011)(3846002)(486006)(4326008)(64756008)(66556008)(6246003)(31686004)(52116002)(6116002)(107886003)(36756003)(66476007)(66446008)(81156014)(6512007)(99286004)(186003)(86362001)(26005)(386003)(6506007)(53546011)(102836004)(71200400001)(71190400001)(478600001)(6486002)(54906003)(2906002)(6636002)(229853002)(316002)(110136005)(6436002)(8936002)(8676002)(68736007)(14444005)(14454004)(7736002)(305945005)(66066001)(256004)(81166006)(31696002)(53936002)(76176011);DIR:OUT;SFP:1101;SCL:1;SRVR:DBBPR05MB6412;H:DBBPR05MB6283.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: vut0iZWvqqnmt9teMAShVHJmtqMGaQdEmXcNfrhcvpS7ydy5qJ6v2XdYe1/I33tBXUqvF+bmBRAwgUwPizcglxAOu+489i4bVqdtX90wc4Whm8GsXYvjl6dWDQQ9Pkf4xBptotJFG/j7KeQCm9kh4+JeX3gOkeUDX9Qwadgulx2BnP1Wc9PR5uGepRz4ya/TsdD/W8vjY624bYh0UFWwULJ9+Aw3bg1asMrwtXzMBclO+kIDgeLAm791BoaoK7wAgeU08vhhR3eJxV6WdOkWquUdcS5RO5wyt7JK6vFe1z7ObJ+0wR1FpNChy7oiUBxAdEmE54cT4wqx03Ercce3i/LG3IuiJIjoEYJIVJiFmm08Mw2rJZnjfFp6CQrCq3ioVUxCS9o2FeUqSwx+d4YPLx0sRHBRmTqShJPYa1xBdig=
Content-Type: text/plain; charset="utf-8"
Content-ID: <BF0A82A8B3FD1249ADB08C583BC8D63D@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cc5ffaa9-509a-41d1-de40-08d701557830
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jul 2019 14:31:29.9089
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tariqt@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR05MB6412
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDcvNC8yMDE5IDExOjEyIFBNLCBKYWt1YiBLaWNpbnNraSB3cm90ZToNCj4gT24gVGh1
LCA0IEp1bCAyMDE5IDE4OjE2OjE1ICswMDAwLCBTYWVlZCBNYWhhbWVlZCB3cm90ZToNCj4+IGRp
ZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW5fc3Rh
dHMuYyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lbl9zdGF0cy5j
DQo+PiBpbmRleCA0ODNkMzIxZDIxNTEuLjY4NTRmMTMyZDUwNSAxMDA2NDQNCj4+IC0tLSBhL2Ry
aXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lbl9zdGF0cy5jDQo+PiArKysg
Yi9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW5fc3RhdHMuYw0KPj4g
QEAgLTUwLDYgKzUwLDE1IEBAIHN0YXRpYyBjb25zdCBzdHJ1Y3QgY291bnRlcl9kZXNjIHN3X3N0
YXRzX2Rlc2NbXSA9IHsNCj4+ICAgI2lmZGVmIENPTkZJR19NTFg1X0VOX1RMUw0KPj4gICAJeyBN
TFg1RV9ERUNMQVJFX1NUQVQoc3RydWN0IG1seDVlX3N3X3N0YXRzLCB0eF90bHNfb29vKSB9LA0K
Pj4gICAJeyBNTFg1RV9ERUNMQVJFX1NUQVQoc3RydWN0IG1seDVlX3N3X3N0YXRzLCB0eF90bHNf
cmVzeW5jX2J5dGVzKSB9LA0KPj4gKw0KPj4gKwl7IE1MWDVFX0RFQ0xBUkVfU1RBVChzdHJ1Y3Qg
bWx4NWVfc3dfc3RhdHMsIHR4X2t0bHNfb29vKSB9LA0KPiANCj4gV2h5IGRvIHlvdSBjYWxsIHRo
aXMgc3RhdCB0eF9rdGxzX29vbywgYW5kIG5vdCB0eF90bHNfb29vIChleHRyYSAnaycpPw0KPiAN
Cj4gRm9yIG5mcCBJIHVzZWQgdGhlIHN0YXRzJyBuYW1lcyBmcm9tIG1seDUgRlBHQSB0byBtYWtl
IHN1cmUgd2UgYXJlIGFsbA0KPiBjb25zaXN0ZW50LiAgSSd2ZSBhZGRlZCB0aGVtIHRvIHRoZSB0
bHMtb2ZmbG9hZC5yc3QgZG9jIGFuZCBCb3JpcyBoYXMNCj4gcmV2aWV3ZWQgaXQuDQo+IA0KPiAg
ICogYGByeF90bHNfZGVjcnlwdGVkYGAgLSBudW1iZXIgb2Ygc3VjY2Vzc2Z1bGx5IGRlY3J5cHRl
ZCBUTFMgc2VnbWVudHMNCj4gICAqIGBgdHhfdGxzX2VuY3J5cHRlZGBgIC0gbnVtYmVyIG9mIGlu
LW9yZGVyIFRMUyBzZWdtZW50cyBwYXNzZWQgdG8gZGV2aWNlDQo+ICAgICBmb3IgZW5jcnlwdGlv
bg0KPiAgICogYGB0eF90bHNfb29vYGAgLSBudW1iZXIgb2YgVFggcGFja2V0cyB3aGljaCB3ZXJl
IHBhcnQgb2YgYSBUTFMgc3RyZWFtDQo+ICAgICBidXQgZGlkIG5vdCBhcnJpdmUgaW4gdGhlIGV4
cGVjdGVkIG9yZGVyDQo+ICAgKiBgYHR4X3Rsc19kcm9wX25vX3N5bmNfZGF0YWBgIC0gbnVtYmVy
IG9mIFRYIHBhY2tldHMgZHJvcHBlZCBiZWNhdXNlDQo+ICAgICB0aGV5IGFycml2ZWQgb3V0IG9m
IG9yZGVyIGFuZCBhc3NvY2lhdGVkIHJlY29yZCBjb3VsZCBub3QgYmUgZm91bmQNCj4gDQo+IFdo
eSBjYW4ndCB5b3UgdXNlIHRoZSBzYW1lIG5hbWVzIGZvciB0aGUgc3RhdHMgYXMgeW91IHVzZWQg
Zm9yIHlvdXIgbWx4NQ0KPiBGUEdBPw0KPiANCg0KQWdyZWUuIEZpeGluZy4NCg0KV2hhdCBhYm91
dCBoYXZpbmcgc3RhdHMgYm90aCBmb3IgcGFja2V0cyBhbmQgYnl0ZXM/DQp0eF90bHNfZW5jcnlw
dGVkX3BhY2tldHMNCnR4X3Rsc19lbmNyeXB0ZWRfYnl0ZXMNCg0KPj4gKwl7IE1MWDVFX0RFQ0xB
UkVfU1RBVChzdHJ1Y3QgbWx4NWVfc3dfc3RhdHMsIHR4X2t0bHNfb29vX2Ryb3Bfbm9fc3luY19k
YXRhKSB9LA0KPj4gKwl7IE1MWDVFX0RFQ0xBUkVfU1RBVChzdHJ1Y3QgbWx4NWVfc3dfc3RhdHMs
IHR4X2t0bHNfb29vX2Ryb3BfYnlwYXNzX3JlcSkgfSwNCj4+ICsJeyBNTFg1RV9ERUNMQVJFX1NU
QVQoc3RydWN0IG1seDVlX3N3X3N0YXRzLCB0eF9rdGxzX29vb19kdW1wX2J5dGVzKSB9LA0KPj4g
Kwl7IE1MWDVFX0RFQ0xBUkVfU1RBVChzdHJ1Y3QgbWx4NWVfc3dfc3RhdHMsIHR4X2t0bHNfb29v
X2R1bXBfcGFja2V0cykgfSwNCj4+ICsJeyBNTFg1RV9ERUNMQVJFX1NUQVQoc3RydWN0IG1seDVl
X3N3X3N0YXRzLCB0eF9rdGxzX2VuY19wYWNrZXRzKSB9LA0KPj4gKwl7IE1MWDVFX0RFQ0xBUkVf
U1RBVChzdHJ1Y3QgbWx4NWVfc3dfc3RhdHMsIHR4X2t0bHNfZW5jX2J5dGVzKSB9LA0KPj4gKwl7
IE1MWDVFX0RFQ0xBUkVfU1RBVChzdHJ1Y3QgbWx4NWVfc3dfc3RhdHMsIHR4X2t0bHNfY3R4KSB9
LA0KPj4gICAjZW5kaWYNCj4+ICAgDQo+PiAgIAl7IE1MWDVFX0RFQ0xBUkVfU1RBVChzdHJ1Y3Qg
bWx4NWVfc3dfc3RhdHMsIHJ4X2xyb19wYWNrZXRzKSB9LA0KPiANCj4gRGF2ZSwgcGxlYXNlIGRv
bid0IGFwcGx5IHRoaXMsIEkgd2lsbCByZXZpZXcgaW4gZGVwdGggb25jZSBJIGdldA0KPiB0aHJv
dWdoIHRoZSBlYXJsaWVyIDIwMCBlbWFpbHMgOykNCj4gDQo=
