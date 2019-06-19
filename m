Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8BA044B23B
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 08:41:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730979AbfFSGkU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 02:40:20 -0400
Received: from mail-eopbgr140082.outbound.protection.outlook.com ([40.107.14.82]:29031
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725881AbfFSGkU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Jun 2019 02:40:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GEupcFKg1aKx3rrpXCk2ZTKTm3sn3td0euFQodNvz4w=;
 b=ZI9P441ZKKWhMF6+hkNEBuFSP1yxa6rHhxaVrPy4vclPlzYHOEZpJR32nCHTF8a8G9n/21tDZLIZgyzf9PTvGSpnEns7C1vqzmaULmhkwi/+L1iWsib9c4+ye2mD9YSSemhq4RQjmOUoec0HJV7LxiWcHax2TLrHT3GEEJRlqAk=
Received: from VI1PR05MB6255.eurprd05.prod.outlook.com (20.178.205.93) by
 VI1PR05MB6429.eurprd05.prod.outlook.com (20.179.27.208) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.12; Wed, 19 Jun 2019 06:40:16 +0000
Received: from VI1PR05MB6255.eurprd05.prod.outlook.com
 ([fe80::1c71:b7b7:cf55:48bb]) by VI1PR05MB6255.eurprd05.prod.outlook.com
 ([fe80::1c71:b7b7:cf55:48bb%7]) with mapi id 15.20.1987.014; Wed, 19 Jun 2019
 06:40:16 +0000
From:   Jianbo Liu <jianbol@mellanox.com>
To:     Leon Romanovsky <leonro@mellanox.com>
CC:     Saeed Mahameed <saeedm@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Roi Dayan <roid@mellanox.com>, Mark Bloch <markb@mellanox.com>
Subject: Re: [PATCH mlx5-next 11/15] RDMA/mlx5: Add vport metadata matching
 for IB representors
Thread-Topic: [PATCH mlx5-next 11/15] RDMA/mlx5: Add vport metadata matching
 for IB representors
Thread-Index: AQHVJUIm5ZIZRgtBuE2Y5DQGvmXpk6ahNB6AgAG6ywD//390gIAAGqsA
Date:   Wed, 19 Jun 2019 06:40:16 +0000
Message-ID: <20190619063941.GA5176@mellanox.com>
References: <20190617192247.25107-1-saeedm@mellanox.com>
 <20190617192247.25107-12-saeedm@mellanox.com>
 <20190618101928.GE4690@mtr-leonro.mtl.com>
 <20190619044420.GA30694@mellanox.com>
 <20190619050412.GC11611@mtr-leonro.mtl.com>
In-Reply-To: <20190619050412.GC11611@mtr-leonro.mtl.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: LO2P265CA0094.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:8::34) To VI1PR05MB6255.eurprd05.prod.outlook.com
 (2603:10a6:803:ed::29)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=jianbol@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [37.142.13.130]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ae58de2d-4e3d-49af-cecf-08d6f480fd6e
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR05MB6429;
x-ms-traffictypediagnostic: VI1PR05MB6429:
x-microsoft-antispam-prvs: <VI1PR05MB642940E60C5D03DD35C0DE9AC8E50@VI1PR05MB6429.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0073BFEF03
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(396003)(346002)(136003)(39860400002)(366004)(199004)(189003)(2616005)(73956011)(8676002)(6486002)(8936002)(53936002)(86362001)(476003)(54906003)(81166006)(81156014)(37006003)(186003)(6862004)(486006)(6116002)(316002)(2906002)(25786009)(3846002)(446003)(6246003)(450100002)(6436002)(256004)(7736002)(11346002)(99286004)(68736007)(6512007)(6636002)(71190400001)(66066001)(26005)(71200400001)(33656002)(6506007)(107886003)(4326008)(64756008)(386003)(66476007)(66556008)(305945005)(14454004)(1076003)(76176011)(66446008)(52116002)(36756003)(66946007)(5660300002)(478600001)(229853002)(102836004);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB6429;H:VI1PR05MB6255.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: VAsVjVCJeYGfcfzwTwdr3xgCzaPPNUbwuQ5CizIfpQaUwkgYB6rcbfv89u7GJhWlpI4S/BpSK1/2jIPwHKZNLeEnSumxb9qgRHzv+sak9XCU1qUGO4fUM4Ic7Q948p633J/S+N7h5BigrG8pt7RunhsT2Xb+g4SEyY7rcB4LYA8j0O6DtuVD2DwMNjI8K3AaG7jbxL1HpGUUqZU2We21NqxvIEyiegBj6e9gljq+WKZJYHIkRFlZd6KbOLtwL3S+1DCbzaCHtEvmXVazLHHCMCBd/bGFXol7mIMETMmM+Th/dng4v1nQn1g2FKEhXLDtwPhQ5nt/VEoqsRbXAZ2IPmAUvEFLUufc2hl4dh2J3R1BjN4CAUXOWxZn4fHc6KlvQWZE/CgtLT8aMfswFyMZr1MVuaWicVmpKelC8CmyYAE=
Content-Type: text/plain; charset="utf-8"
Content-ID: <97ACA4B207EA524CB323260E7D966353@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ae58de2d-4e3d-49af-cecf-08d6f480fd6e
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jun 2019 06:40:16.7720
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jianbol@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6429
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VGhlIDA2LzE5LzIwMTkgMTM6MDQsIExlb24gUm9tYW5vdnNreSB3cm90ZToNCj4gT24gV2VkLCBK
dW4gMTksIDIwMTkgYXQgMDQ6NDQ6MjZBTSArMDAwMCwgSmlhbmJvIExpdSB3cm90ZToNCj4gPiBU
aGUgMDYvMTgvMjAxOSAxODoxOSwgTGVvbiBSb21hbm92c2t5IHdyb3RlOg0KPiA+ID4gT24gTW9u
LCBKdW4gMTcsIDIwMTkgYXQgMDc6MjM6MzBQTSArMDAwMCwgU2FlZWQgTWFoYW1lZWQgd3JvdGU6
DQo+ID4gPiA+IEZyb206IEppYW5ibyBMaXUgPGppYW5ib2xAbWVsbGFub3guY29tPg0KPiA+ID4g
Pg0KPiA+ID4gPiBJZiB2cG9ydCBtZXRhZGF0YSBtYXRjaGluZyBpcyBlbmFibGVkIGluIGVzd2l0
Y2gsIHRoZSBydWxlIGNyZWF0ZWQNCj4gPiA+ID4gbXVzdCBiZSBjaGFuZ2VkIHRvIG1hdGNoIG9u
IHRoZSBtZXRhZGF0YSwgaW5zdGVhZCBvZiBzb3VyY2UgcG9ydC4NCj4gPiA+ID4NCj4gPiA+ID4g
U2lnbmVkLW9mZi1ieTogSmlhbmJvIExpdSA8amlhbmJvbEBtZWxsYW5veC5jb20+DQo+ID4gPiA+
IFJldmlld2VkLWJ5OiBSb2kgRGF5YW4gPHJvaWRAbWVsbGFub3guY29tPg0KPiA+ID4gPiBSZXZp
ZXdlZC1ieTogTWFyayBCbG9jaCA8bWFya2JAbWVsbGFub3guY29tPg0KPiA+ID4gPiBTaWduZWQt
b2ZmLWJ5OiBTYWVlZCBNYWhhbWVlZCA8c2FlZWRtQG1lbGxhbm94LmNvbT4NCj4gPiA+ID4gLS0t
DQo+ID4gPiA+ICBkcml2ZXJzL2luZmluaWJhbmQvaHcvbWx4NS9pYl9yZXAuYyB8IDExICsrKysr
KysNCj4gPiA+ID4gIGRyaXZlcnMvaW5maW5pYmFuZC9ody9tbHg1L2liX3JlcC5oIHwgMTYgKysr
KysrKysrKw0KPiA+ID4gPiAgZHJpdmVycy9pbmZpbmliYW5kL2h3L21seDUvbWFpbi5jICAgfCA0
NSArKysrKysrKysrKysrKysrKysrKysrKy0tLS0tLQ0KPiA+ID4gPiAgMyBmaWxlcyBjaGFuZ2Vk
LCA2MyBpbnNlcnRpb25zKCspLCA5IGRlbGV0aW9ucygtKQ0KPiA+ID4gPg0KPiA+ID4gPiBkaWZm
IC0tZ2l0IGEvZHJpdmVycy9pbmZpbmliYW5kL2h3L21seDUvaWJfcmVwLmMgYi9kcml2ZXJzL2lu
ZmluaWJhbmQvaHcvbWx4NS9pYl9yZXAuYw0KPiA+ID4gPiBpbmRleCAyMmU2NTFjYjU1MzQuLmQ0
ZWQ2MTFkZTM1ZCAxMDA2NDQNCj4gPiA+ID4gLS0tIGEvZHJpdmVycy9pbmZpbmliYW5kL2h3L21s
eDUvaWJfcmVwLmMNCj4gPiA+ID4gKysrIGIvZHJpdmVycy9pbmZpbmliYW5kL2h3L21seDUvaWJf
cmVwLmMNCj4gPiA+ID4gQEAgLTEzMSw2ICsxMzEsMTcgQEAgc3RydWN0IG1seDVfZXN3aXRjaF9y
ZXAgKm1seDVfaWJfdnBvcnRfcmVwKHN0cnVjdCBtbHg1X2Vzd2l0Y2ggKmVzdywgaW50IHZwb3J0
KQ0KPiA+ID4gPiAgCXJldHVybiBtbHg1X2Vzd2l0Y2hfdnBvcnRfcmVwKGVzdywgdnBvcnQpOw0K
PiA+ID4gPiAgfQ0KPiA+ID4gPg0KPiA+ID4gPiArdTMyIG1seDVfaWJfZXN3aXRjaF92cG9ydF9t
YXRjaF9tZXRhZGF0YV9lbmFibGVkKHN0cnVjdCBtbHg1X2Vzd2l0Y2ggKmVzdykNCj4gPiA+ID4g
K3sNCj4gPiA+ID4gKwlyZXR1cm4gbWx4NV9lc3dpdGNoX3Zwb3J0X21hdGNoX21ldGFkYXRhX2Vu
YWJsZWQoZXN3KTsNCj4gPiA+ID4gK30NCj4gPiA+ID4gKw0KPiA+ID4gPiArdTMyIG1seDVfaWJf
ZXN3aXRjaF9nZXRfdnBvcnRfbWV0YWRhdGFfZm9yX21hdGNoKHN0cnVjdCBtbHg1X2Vzd2l0Y2gg
KmVzdywNCj4gPiA+ID4gKwkJCQkJCSB1MTYgdnBvcnQpDQo+ID4gPiA+ICt7DQo+ID4gPiA+ICsJ
cmV0dXJuIG1seDVfZXN3aXRjaF9nZXRfdnBvcnRfbWV0YWRhdGFfZm9yX21hdGNoKGVzdywgdnBv
cnQpOw0KPiA+ID4gPiArfQ0KPiA+ID4NCj4gPiA+IDEuIFRoZXJlIGlzIG5vIG5lZWQgdG8gaW50
cm9kdWNlIG9uZSBsaW5lIGZ1bmN0aW9ucywgY2FsbCB0byB0aGF0IGNvZGUgZGlyZWN0bHkuDQo+
ID4NCj4gPiBOby4gVGhleSBhcmUgaW4gSUIsIGFuZCB3ZSBkb24ndCB3YW50IHRoZW0gYmUgbWl4
ZWQgdXAgYnkgdGhlIG9yaWdpbmFsDQo+ID4gZnVuY3Rpb25zIGluIGVzd2l0Y2guIFBsZWFzZSBh
c2sgTWFyayBtb3JlIGFib3V0IGl0Lg0KPiANCj4gUGxlYXNlIGVubGlnaHRlbiBtZS4NCg0KSXQg
d2FzIHN1Z2dlc3RlZCBieSBNYXJrIGluIHByZXZvdWlzIHJldmlldy4NCkkgdGhpbmsgaXQncyBi
ZWNhdXNlIHRoZXJlIGFyZSBpbiBkaWZmZXJlbnQgbW9kdWxlcywgYW5kIGJldHRlciB0byB3aXRo
DQpkaWZmZXJlbnQgbmFtZXMsIHNvIGludHJvZHVjZSB0aGVyZSBleHRyYSBvbmUgbGluZSBmdW5j
dGlvbnMuDQpQbGVhc2UgY29ycmVjdCBtZSBpZiBJJ20gd3JvbmcsIE1hcmsuLi4NCg0KPiANCj4g
Pg0KPiA+ID4gMi4gSXQgc2hvdWxkIGJlIGJvb2wgYW5kIG5vdCB1MzIuDQo+ID4gPg0KPiA+ID4g
VGhhbmtzDQo+ID4NCj4gPiAtLQ0KDQotLSANCg==
