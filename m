Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C09614B0EC
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 06:44:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725928AbfFSEob (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 00:44:31 -0400
Received: from mail-eopbgr60089.outbound.protection.outlook.com ([40.107.6.89]:23460
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725854AbfFSEob (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Jun 2019 00:44:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=67DPACtE+iGsvGOLoLpGxTjx96UhjrQhn+21NKOCLLQ=;
 b=JH6/MSucKN+13DiOPfb7EebDPjv4PJUenDLlzTDLqlRGcTbXA4uRlIw6QmFq6TOU1AAY1mHBd6Pw0STIjPFVpGb1cYuOjYGAhynsikREJLl5R3fDHnd9Yq10xYR0hJ22n4ghm27XcgyHf+GmxplT7o4Wokn0dq7OXbN7VA39gHU=
Received: from VI1PR05MB6255.eurprd05.prod.outlook.com (20.178.205.93) by
 VI1PR05MB6078.eurprd05.prod.outlook.com (20.178.204.92) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.13; Wed, 19 Jun 2019 04:44:27 +0000
Received: from VI1PR05MB6255.eurprd05.prod.outlook.com
 ([fe80::1c71:b7b7:cf55:48bb]) by VI1PR05MB6255.eurprd05.prod.outlook.com
 ([fe80::1c71:b7b7:cf55:48bb%7]) with mapi id 15.20.1987.014; Wed, 19 Jun 2019
 04:44:27 +0000
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
Thread-Index: AQHVJUIm5ZIZRgtBuE2Y5DQGvmXpk6ahNB6AgAE0sQA=
Date:   Wed, 19 Jun 2019 04:44:26 +0000
Message-ID: <20190619044420.GA30694@mellanox.com>
References: <20190617192247.25107-1-saeedm@mellanox.com>
 <20190617192247.25107-12-saeedm@mellanox.com>
 <20190618101928.GE4690@mtr-leonro.mtl.com>
In-Reply-To: <20190618101928.GE4690@mtr-leonro.mtl.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: LO2P265CA0262.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:8a::34) To VI1PR05MB6255.eurprd05.prod.outlook.com
 (2603:10a6:803:ed::29)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=jianbol@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [37.142.13.130]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d26e3ebe-5aa8-460c-b3ac-08d6f470ceee
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR05MB6078;
x-ms-traffictypediagnostic: VI1PR05MB6078:
x-microsoft-antispam-prvs: <VI1PR05MB60785F97D40D03DD0E20E449C8E50@VI1PR05MB6078.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0073BFEF03
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(346002)(39860400002)(366004)(136003)(396003)(199004)(189003)(446003)(37006003)(26005)(3846002)(107886003)(186003)(52116002)(53936002)(68736007)(76176011)(6512007)(478600001)(4326008)(86362001)(6636002)(99286004)(450100002)(6246003)(14454004)(8676002)(66946007)(486006)(316002)(7736002)(64756008)(25786009)(66066001)(476003)(6116002)(229853002)(386003)(71200400001)(102836004)(6506007)(305945005)(2616005)(6486002)(256004)(66556008)(66476007)(73956011)(54906003)(5660300002)(6436002)(6862004)(2906002)(81166006)(81156014)(1076003)(8936002)(66446008)(11346002)(36756003)(71190400001)(33656002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB6078;H:VI1PR05MB6255.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: gETECxyYOthryShLeoyWxFfC+jColc0a5SRHmeJaWIE6jadX3jYtH+9ukhLTd2HXMustqBQzrzyb5kdGZUhUg4E2Q7s6pnCqTtEGdflmGR7CBF7xcC8jl8WYiqewoJKd9zu5ckzxbvywXA/tZpbHT/5PhYfbep3FX/RA1Ig6Zvrj1nckrK6tQGLm0CU2r2+iiz2gr+r2fc7xfphwiX55PVWXPMngTzVVJnYFzRH9vZx4GOgCd1a/syje4cvMVP1vVvBMkj3lT5SSElhlaIg7VetqNwhJeFiJWSSN/lwZYUGlyFbrb3pcKbStaJGQkBC2DPKemYUyWtsCVgIdstQPRLkqXnVF8R+URKPahmx2ciogGU9/s9A/iHAi60TbNHuUd7ZYFlXOaWN8iIhs1TejDstotvk/94GAdmJmY2S6/Zo=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5D53FAC4AD07764E8A73AD58D18FAD24@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d26e3ebe-5aa8-460c-b3ac-08d6f470ceee
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jun 2019 04:44:27.1134
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jianbol@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6078
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VGhlIDA2LzE4LzIwMTkgMTg6MTksIExlb24gUm9tYW5vdnNreSB3cm90ZToNCj4gT24gTW9uLCBK
dW4gMTcsIDIwMTkgYXQgMDc6MjM6MzBQTSArMDAwMCwgU2FlZWQgTWFoYW1lZWQgd3JvdGU6DQo+
ID4gRnJvbTogSmlhbmJvIExpdSA8amlhbmJvbEBtZWxsYW5veC5jb20+DQo+ID4NCj4gPiBJZiB2
cG9ydCBtZXRhZGF0YSBtYXRjaGluZyBpcyBlbmFibGVkIGluIGVzd2l0Y2gsIHRoZSBydWxlIGNy
ZWF0ZWQNCj4gPiBtdXN0IGJlIGNoYW5nZWQgdG8gbWF0Y2ggb24gdGhlIG1ldGFkYXRhLCBpbnN0
ZWFkIG9mIHNvdXJjZSBwb3J0Lg0KPiA+DQo+ID4gU2lnbmVkLW9mZi1ieTogSmlhbmJvIExpdSA8
amlhbmJvbEBtZWxsYW5veC5jb20+DQo+ID4gUmV2aWV3ZWQtYnk6IFJvaSBEYXlhbiA8cm9pZEBt
ZWxsYW5veC5jb20+DQo+ID4gUmV2aWV3ZWQtYnk6IE1hcmsgQmxvY2ggPG1hcmtiQG1lbGxhbm94
LmNvbT4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBTYWVlZCBNYWhhbWVlZCA8c2FlZWRtQG1lbGxhbm94
LmNvbT4NCj4gPiAtLS0NCj4gPiAgZHJpdmVycy9pbmZpbmliYW5kL2h3L21seDUvaWJfcmVwLmMg
fCAxMSArKysrKysrDQo+ID4gIGRyaXZlcnMvaW5maW5pYmFuZC9ody9tbHg1L2liX3JlcC5oIHwg
MTYgKysrKysrKysrKw0KPiA+ICBkcml2ZXJzL2luZmluaWJhbmQvaHcvbWx4NS9tYWluLmMgICB8
IDQ1ICsrKysrKysrKysrKysrKysrKysrKysrLS0tLS0tDQo+ID4gIDMgZmlsZXMgY2hhbmdlZCwg
NjMgaW5zZXJ0aW9ucygrKSwgOSBkZWxldGlvbnMoLSkNCj4gPg0KPiA+IGRpZmYgLS1naXQgYS9k
cml2ZXJzL2luZmluaWJhbmQvaHcvbWx4NS9pYl9yZXAuYyBiL2RyaXZlcnMvaW5maW5pYmFuZC9o
dy9tbHg1L2liX3JlcC5jDQo+ID4gaW5kZXggMjJlNjUxY2I1NTM0Li5kNGVkNjExZGUzNWQgMTAw
NjQ0DQo+ID4gLS0tIGEvZHJpdmVycy9pbmZpbmliYW5kL2h3L21seDUvaWJfcmVwLmMNCj4gPiAr
KysgYi9kcml2ZXJzL2luZmluaWJhbmQvaHcvbWx4NS9pYl9yZXAuYw0KPiA+IEBAIC0xMzEsNiAr
MTMxLDE3IEBAIHN0cnVjdCBtbHg1X2Vzd2l0Y2hfcmVwICptbHg1X2liX3Zwb3J0X3JlcChzdHJ1
Y3QgbWx4NV9lc3dpdGNoICplc3csIGludCB2cG9ydCkNCj4gPiAgCXJldHVybiBtbHg1X2Vzd2l0
Y2hfdnBvcnRfcmVwKGVzdywgdnBvcnQpOw0KPiA+ICB9DQo+ID4NCj4gPiArdTMyIG1seDVfaWJf
ZXN3aXRjaF92cG9ydF9tYXRjaF9tZXRhZGF0YV9lbmFibGVkKHN0cnVjdCBtbHg1X2Vzd2l0Y2gg
KmVzdykNCj4gPiArew0KPiA+ICsJcmV0dXJuIG1seDVfZXN3aXRjaF92cG9ydF9tYXRjaF9tZXRh
ZGF0YV9lbmFibGVkKGVzdyk7DQo+ID4gK30NCj4gPiArDQo+ID4gK3UzMiBtbHg1X2liX2Vzd2l0
Y2hfZ2V0X3Zwb3J0X21ldGFkYXRhX2Zvcl9tYXRjaChzdHJ1Y3QgbWx4NV9lc3dpdGNoICplc3cs
DQo+ID4gKwkJCQkJCSB1MTYgdnBvcnQpDQo+ID4gK3sNCj4gPiArCXJldHVybiBtbHg1X2Vzd2l0
Y2hfZ2V0X3Zwb3J0X21ldGFkYXRhX2Zvcl9tYXRjaChlc3csIHZwb3J0KTsNCj4gPiArfQ0KPiAN
Cj4gMS4gVGhlcmUgaXMgbm8gbmVlZCB0byBpbnRyb2R1Y2Ugb25lIGxpbmUgZnVuY3Rpb25zLCBj
YWxsIHRvIHRoYXQgY29kZSBkaXJlY3RseS4NCg0KTm8uIFRoZXkgYXJlIGluIElCLCBhbmQgd2Ug
ZG9uJ3Qgd2FudCB0aGVtIGJlIG1peGVkIHVwIGJ5IHRoZSBvcmlnaW5hbA0KZnVuY3Rpb25zIGlu
IGVzd2l0Y2guIFBsZWFzZSBhc2sgTWFyayBtb3JlIGFib3V0IGl0Lg0KDQo+IDIuIEl0IHNob3Vs
ZCBiZSBib29sIGFuZCBub3QgdTMyLg0KPiANCj4gVGhhbmtzDQoNCi0tIA0K
