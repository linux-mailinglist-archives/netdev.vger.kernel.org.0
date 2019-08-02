Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFCF97F60A
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 13:32:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392394AbfHBLb5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Aug 2019 07:31:57 -0400
Received: from mail-eopbgr00087.outbound.protection.outlook.com ([40.107.0.87]:5189
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732758AbfHBLb4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Aug 2019 07:31:56 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iU+covpNouKR+k/XhtfsnItaOW5ja7mY12lHJ8/OxwlSS4bAWtjQYdt234YCGhX/ezrzy4rDVP9WVUUdKYLWOtEYekBAdQxfneIlfQZlQGANqvU6Ne33XoBh4AKoWzm7ag8VYDElAMp6rXIUx7LIjYIOKqibBINa5W/B6R2YXnGzBgIr7XsHk+o8k/S9CnMLkYpcYxwxDQn3GrKtlNlJZFlc7zdxPJqFGh//nLGKK7CGhdVrhhiyj9JniLKmWi87HKl/UN9XZTg4C0lPR3ONfj1VHXPRzi1hSdhFXQYLpmbq2I29tUEnk+xcvjAxNmo8JjjQ+djuq6c4XjaSJyfWOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BrN/DeHjQLc5xmr1KSkqqOgcxg0CArZAf49jdj+Z4mc=;
 b=lCsHTWzFH+bWXcPUo3Q9qgxFiDhQXS9qrN9R0kR1JGy0Q0rkJA5WllNYf6KeBXJQb472sv6A00mK+D60KYR+xI2xFOAqJLNe54+xx0UZGF4MlqybPjMVBxk8Sx04xjgk05lAFJtHjFTBtQwdhWWYW3Y612FSSJfEbeaoQZRtWOWcR/Co/IHM9F2KgKf3IdAXX1I3ABwX9P8oQSee0T3r/wpfj1yP9wHDLqrcamCRArKAgDIod34DWJDj9AfmCotYOcmXxB1AnxpgOQw5hqjXvNRHS0wzW9r7XxwzqSWKH+sILgLdwhbtgE+qVB81+pgN95nU/j4yRay759J6QJyafA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=mellanox.com;dmarc=pass action=none
 header.from=mellanox.com;dkim=pass header.d=mellanox.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BrN/DeHjQLc5xmr1KSkqqOgcxg0CArZAf49jdj+Z4mc=;
 b=okK7uwQaZYZuMOEhWFD5/V6KqhR9Lh/e5lgXc5b7vUgt+goSJvLGPJr7BCL7Slgj+3opmmeo9JvTdjkSNAi00imJ1RIXiwHGb4Dag2ognLAjzh+QpAMg1Afmtg1utl1TfHGSMhvCHmYYQ/OVNE5/AmSTvknrPvBj+wAtf5cAioA=
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (20.176.214.160) by
 AM0PR05MB6545.eurprd05.prod.outlook.com (20.179.35.209) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2136.14; Fri, 2 Aug 2019 11:31:52 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::216f:f548:1db0:41ea]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::216f:f548:1db0:41ea%6]) with mapi id 15.20.2136.010; Fri, 2 Aug 2019
 11:31:52 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     Colin King <colin.king@canonical.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
CC:     "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH][net-next] net/mlx5: remove self-assignment on esw->dev
Thread-Topic: [PATCH][net-next] net/mlx5: remove self-assignment on esw->dev
Thread-Index: AQHVSRwyNFCGdrf7w0KIDMSeKaaHvqbnuSVA
Date:   Fri, 2 Aug 2019 11:31:52 +0000
Message-ID: <AM0PR05MB4866E10E1182F122D6CC05AFD1D90@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20190802102223.26198-1-colin.king@canonical.com>
In-Reply-To: <20190802102223.26198-1-colin.king@canonical.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [49.207.55.248]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f9305805-a62b-4519-9325-08d7173d03fe
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM0PR05MB6545;
x-ms-traffictypediagnostic: AM0PR05MB6545:
x-microsoft-antispam-prvs: <AM0PR05MB65455F4A83236AB2EA00C2B2D1D90@AM0PR05MB6545.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2887;
x-forefront-prvs: 011787B9DD
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(39860400002)(366004)(376002)(396003)(136003)(199004)(189003)(13464003)(5660300002)(11346002)(476003)(446003)(68736007)(486006)(2501003)(7736002)(305945005)(102836004)(2906002)(26005)(6246003)(7696005)(33656002)(229853002)(6506007)(478600001)(2201001)(316002)(99286004)(81156014)(53936002)(4326008)(6436002)(186003)(25786009)(110136005)(54906003)(55016002)(53546011)(76176011)(55236004)(81166006)(9686003)(14454004)(71190400001)(71200400001)(8936002)(8676002)(66066001)(86362001)(66446008)(64756008)(66476007)(66946007)(76116006)(66556008)(256004)(14444005)(52536014)(74316002)(6116002)(3846002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB6545;H:AM0PR05MB4866.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 4uVXgfc+MNEoD6MqiiVgHE0wjNywSY1FFL6EJBRElRPjManNvjaQdQHAZ7so1SCud/B5Z+8yU1ir8AIYK74U2e1YZlV95og24lfnYykPQklIJM4usz2X0tE/luVfBFPWR1evC9uCkZeSrIe8V0Dd1OMbYv+35MY6VohodNAEnX+vhpURUOrxFOvLKEq5y0UYeHdob8MYNnk0FWTBeEGe4GV22S6C61ZeO4ImHNAilgmC7+P6wJW2RrJK4Tor07VZzsVFOT7eJzJV3Iw6QWHx+SucDLguD1IBQEn38O7K5hH6uugLmyzjcjcSkNqRMtw2cNheBlasUacDdqsOU8+CdfeMSGHugppM+qkznjBReVM5/4j5yuhi69coT6DUOKGnwg7ImGy5dLqhgkBAwXZn2Yg7MgkvNOmVdVt8K4usx00=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f9305805-a62b-4519-9325-08d7173d03fe
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Aug 2019 11:31:52.2704
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: parav@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB6545
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogbGludXgtcmRtYS1vd25l
ckB2Z2VyLmtlcm5lbC5vcmcgPGxpbnV4LXJkbWEtDQo+IG93bmVyQHZnZXIua2VybmVsLm9yZz4g
T24gQmVoYWxmIE9mIENvbGluIEtpbmcNCj4gU2VudDogRnJpZGF5LCBBdWd1c3QgMiwgMjAxOSAz
OjUyIFBNDQo+IFRvOiBTYWVlZCBNYWhhbWVlZCA8c2FlZWRtQG1lbGxhbm94LmNvbT47IExlb24g
Um9tYW5vdnNreQ0KPiA8bGVvbkBrZXJuZWwub3JnPjsgRGF2aWQgUyAuIE1pbGxlciA8ZGF2ZW1A
ZGF2ZW1sb2Z0Lm5ldD47DQo+IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LXJkbWFAdmdl
ci5rZXJuZWwub3JnDQo+IENjOiBrZXJuZWwtamFuaXRvcnNAdmdlci5rZXJuZWwub3JnOyBsaW51
eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnDQo+IFN1YmplY3Q6IFtQQVRDSF1bbmV0LW5leHRdIG5l
dC9tbHg1OiByZW1vdmUgc2VsZi1hc3NpZ25tZW50IG9uIGVzdy0+ZGV2DQo+IA0KPiBGcm9tOiBD
b2xpbiBJYW4gS2luZyA8Y29saW4ua2luZ0BjYW5vbmljYWwuY29tPg0KPiANCj4gVGhlcmUgaXMg
YSBzZWxmIGFzc2lnbm1lbnQgb2YgZXN3LT5kZXYgdG8gaXRzZWxmLCBjbGVhbiB0aGlzIHVwIGJ5
IHJlbW92aW5nIGl0Lg0KPiANCj4gQWRkcmVzc2VzLUNvdmVyaXR5OiAoIlNlbGYgYXNzaWdubWVu
dCIpDQo+IEZpeGVzOiA2Y2VkZGU0NTEzOTkgKCJuZXQvbWx4NTogRS1Td2l0Y2gsIFZlcmlmeSBz
dXBwb3J0IFFvUyBlbGVtZW50IHR5cGUiKQ0KPiBTaWduZWQtb2ZmLWJ5OiBDb2xpbiBJYW4gS2lu
ZyA8Y29saW4ua2luZ0BjYW5vbmljYWwuY29tPg0KPiAtLS0NCj4gIGRyaXZlcnMvbmV0L2V0aGVy
bmV0L21lbGxhbm94L21seDUvY29yZS9lc3dpdGNoLmMgfCAyICstDQo+ICAxIGZpbGUgY2hhbmdl
ZCwgMSBpbnNlcnRpb24oKyksIDEgZGVsZXRpb24oLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9kcml2
ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZXN3aXRjaC5jDQo+IGIvZHJpdmVy
cy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2Vzd2l0Y2guYw0KPiBpbmRleCBmNGFj
ZTVmOGU4ODQuLmRlMDg5NGI2OTVlMyAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJu
ZXQvbWVsbGFub3gvbWx4NS9jb3JlL2Vzd2l0Y2guYw0KPiArKysgYi9kcml2ZXJzL25ldC9ldGhl
cm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZXN3aXRjaC5jDQo+IEBAIC0xNDEzLDcgKzE0MTMsNyBA
QCBzdGF0aWMgaW50IGVzd192cG9ydF9lZ3Jlc3NfY29uZmlnKHN0cnVjdA0KPiBtbHg1X2Vzd2l0
Y2ggKmVzdywNCj4gDQo+ICBzdGF0aWMgYm9vbCBlbGVtZW50X3R5cGVfc3VwcG9ydGVkKHN0cnVj
dCBtbHg1X2Vzd2l0Y2ggKmVzdywgaW50IHR5cGUpICB7DQpNYWtpbmcgaXQgY29uc3Qgc3RydWN0
IG1seDVfZXN3aXRjaCAqZXN3IGJyaW5ncyBpbXByb3ZlcyBjb2RlIGh5Z2llbmUgZnVydGhlciBp
biBzdWNoIGZ1bmN0aW9ucy4NCg0KPiAtCXN0cnVjdCBtbHg1X2NvcmVfZGV2ICpkZXYgPSBlc3ct
PmRldiA9IGVzdy0+ZGV2Ow0KPiArCXN0cnVjdCBtbHg1X2NvcmVfZGV2ICpkZXYgPSBlc3ctPmRl
djsNCj4gDQo+ICAJc3dpdGNoICh0eXBlKSB7DQo+ICAJY2FzZSBTQ0hFRFVMSU5HX0NPTlRFWFRf
RUxFTUVOVF9UWVBFX1RTQVI6DQo+IC0tDQo+IDIuMjAuMQ0KDQo=
