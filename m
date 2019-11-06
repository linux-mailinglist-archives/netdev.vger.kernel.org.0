Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 291C0F0ED4
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 07:24:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730005AbfKFGY3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 01:24:29 -0500
Received: from mail-eopbgr00056.outbound.protection.outlook.com ([40.107.0.56]:24961
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727568AbfKFGY3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Nov 2019 01:24:29 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fdtk0HJ4FRO0XVLdCgDyFCEddIwDLK6/snl1IxZtGwHD3DWbhWbEIiSdP8I5YKGoaV0vhEUKcuoZSwsRFCyn+qhQ7EvrmUWVgat8vDsyP1P5dl51S/QZGoc8RZmi1fHm7d0l6ye/zeyBlg7Br2BwB2CpoO/pvZTuDbaOP3wkkeupF4n9Lyxz5tcwzilo54yLO4kJdbLk6K78yLTvY1urfTiNqtXZVegf/xlIMdtdqDDxoajOSZYVqLuEZ9Unn0fxf4AqBYf06rKWXPww9o4Ngf4I3XpE7H3h4+MUj8+6pM2qHLGtJLaHHMtHG7ys3JECmYOI0lzKEVjajTcpzJ4o6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QRtqHBscXHuue4va/8wphdLUqXcLP0HSJ0seEAcmliI=;
 b=Ih8yZoZiCPB+cjPAYfCmZGkUUm0a3YqjYIV5NWuKHxhLSpj6ok7g6aBSDq5WITi6xSdcDAiKXbtLRVHlj9FUdSLhgAj+kh141ik/VSsBaE4sXSyfg7TuWupiLdMFI33tmZswUGGaQudHHL2WGhg0aQRe/iNZm+7rAzgtMTWzTKu6pwRUhnXSPi5bsyYi245hgDVlbKYepPyNxtNKDzJQYB1eTFFwEEUH/sODWdMWMkzjZRLXRUVEAb0cm6r5JUrXGTmWR2Umeq7ckq3OcvS1eIg0lqy9TnmVUmPzN7eGo46kz3WCaiYln96qDEtSqSClRz3qM931dtu2qqmghQ4MtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QRtqHBscXHuue4va/8wphdLUqXcLP0HSJ0seEAcmliI=;
 b=YhmgYsIJUlVRI4NUgnwuWIBt6SVtJgMvXwnbXMeGB+l5MRhdh4xoIzgoJE1CbcEp+m86x2RkF6qHYVRJLyqNcZ/adlZEk/+UQx2no7Qqnoo2G2qNrPUiuu0QmBECYnEvDwpTefbplGi1tjC921RWLjOfI/5n1rpeADNDH90tgfk=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB6446.eurprd05.prod.outlook.com (20.179.28.84) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.20; Wed, 6 Nov 2019 06:24:25 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e%5]) with mapi id 15.20.2408.024; Wed, 6 Nov 2019
 06:24:25 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Parav Pandit <parav@mellanox.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "colin.king@canonical.com" <colin.king@canonical.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "leon@kernel.org" <leon@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][next] net/mlx5: fix kvfree of uninitialized pointer spec
Thread-Topic: [PATCH][next] net/mlx5: fix kvfree of uninitialized pointer spec
Thread-Index: AQHVlAa2MrKk1PZdlEqSKXtQGIB+aad9rZoA
Date:   Wed, 6 Nov 2019 06:24:25 +0000
Message-ID: <d6854c959a2ff5d8493e97982cd3bb8ee5ec7789.camel@mellanox.com>
References: <20191105182740.87146-1-colin.king@canonical.com>
In-Reply-To: <20191105182740.87146-1-colin.king@canonical.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.4 (3.32.4-1.fc30) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [73.15.39.150]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 8e1a4310-4f38-4ae3-48c7-08d76281f858
x-ms-traffictypediagnostic: VI1PR05MB6446:|VI1PR05MB6446:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB6446B5D58E4D456961C64087BE790@VI1PR05MB6446.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2582;
x-forefront-prvs: 02135EB356
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(136003)(376002)(366004)(346002)(39860400002)(189003)(199004)(71190400001)(71200400001)(14444005)(256004)(8936002)(2501003)(8676002)(54906003)(6512007)(6246003)(446003)(229853002)(11346002)(4326008)(118296001)(2616005)(476003)(6436002)(25786009)(486006)(6486002)(26005)(66066001)(2906002)(102836004)(305945005)(66446008)(64756008)(66476007)(66556008)(66946007)(99286004)(316002)(91956017)(5660300002)(76116006)(86362001)(36756003)(186003)(2201001)(81166006)(81156014)(110136005)(478600001)(58126008)(14454004)(3846002)(76176011)(7736002)(6506007)(6116002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB6446;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9yAplFByDjeuvZ5QT3+xi65w4tXPYWb30om1HDSrz11+JLCHzGwiMFpnlAlyi/u1Ovq2rY6nmHHvhzAf36psxySaIsIv+Ny81UOa6GubylB/qPA1jC/0gxyvIHMS/3H6LMawl0VYBNCx8cZKfFYnj6gUiJVsSvPFf0LJqqceEu3v+xqSCKULv5y/aluYzdnimkzae6cC8sW7xImh5qKJHo8weaj/FYFbVf6tCFUT3oNVRnQvSaMqfBRLurTgSkId0GXdhtljK77zt5ojbeZ5lNjp1SQTI5+emWPh7aUQZFh86nOBikmmeGm96IIr7kz8rkewfHe4dbnZQnCdL62o/m4Eg7GUs2dCaQD3nmnTSpZuldHsVdkldiM0oRWD8pj7uEVtaBusZNzEtNUJ5y+s6hahh0TFZs44Vu/EJoJ54coyDUdlueRDhc3E6mgdcdM9
Content-Type: text/plain; charset="utf-8"
Content-ID: <47833ABE6718214DB3E9F08BEE40FD8C@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e1a4310-4f38-4ae3-48c7-08d76281f858
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Nov 2019 06:24:25.1863
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: utXZqRkMsX0ulzjV5GZrybwLR9WOkcc22AXJ4MfWw8u3elX4lapXEaioGOLLcmaAZuawn1SHtOB08L8CEtZc3Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6446
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDE5LTExLTA1IGF0IDE4OjI3ICswMDAwLCBDb2xpbiBLaW5nIHdyb3RlOg0KPiBG
cm9tOiBDb2xpbiBJYW4gS2luZyA8Y29saW4ua2luZ0BjYW5vbmljYWwuY29tPg0KPiANCj4gQ3Vy
cmVudGx5IHdoZW4gYSBjYWxsIHRvICBlc3dfdnBvcnRfY3JlYXRlX2xlZ2FjeV9pbmdyZXNzX2Fj
bF9ncm91cA0KPiBmYWlscyB0aGUgZXJyb3IgZXhpdCBwYXRoIHRvIGxhYmVsICdvdXQnIHdpbGwg
Y2F1c2UgYSBrdmZyZWUgb24gdGhlDQo+IHVuaW5pdGlhbGl6ZWQgcG9pbnRlciBzcGVjLiAgRml4
IHRoaXMgYnkgZW5zdXJpbmcgcG9pbnRlciBzcGVjIGlzDQo+IGluaXRpYWxpemVkIHRvIE5VTEwg
dG8gYXZvaWQgdGhpcyBpc3N1ZS4NCj4gDQo+IEFkZHJlc3Nlcy1Db3Zlcml0eTogKCJVbmluaXRp
YWxpemVkIHBvaW50ZXIgcmVhZCIpDQo+IEZpeGVzOiAxMDY1MmYzOTk0M2UgKCJuZXQvbWx4NTog
UmVmYWN0b3IgaW5ncmVzcyBhY2wgY29uZmlndXJhdGlvbiIpDQo+IFNpZ25lZC1vZmYtYnk6IENv
bGluIElhbiBLaW5nIDxjb2xpbi5raW5nQGNhbm9uaWNhbC5jb20+DQo+IC0tLQ0KPiAgZHJpdmVy
cy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2Vzd2l0Y2guYyB8IDIgKy0NCj4gIDEg
ZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwgMSBkZWxldGlvbigtKQ0KPiANCj4gZGlmZiAt
LWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lc3dpdGNoLmMN
Cj4gYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZXN3aXRjaC5jDQo+
IGluZGV4IDdiYWFkZTllNjJiNy4uZjJlNDAwYTIzYTU5IDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJz
L25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZXN3aXRjaC5jDQo+ICsrKyBiL2RyaXZl
cnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lc3dpdGNoLmMNCj4gQEAgLTEyNTMs
NyArMTI1Myw3IEBAIHN0YXRpYyBpbnQgZXN3X3Zwb3J0X2luZ3Jlc3NfY29uZmlnKHN0cnVjdA0K
PiBtbHg1X2Vzd2l0Y2ggKmVzdywNCj4gIAlzdHJ1Y3QgbWx4NV9mbG93X2Rlc3RpbmF0aW9uIGRy
b3BfY3RyX2RzdCA9IHswfTsNCj4gIAlzdHJ1Y3QgbWx4NV9mbG93X2Rlc3RpbmF0aW9uICpkc3Qg
PSBOVUxMOw0KPiAgCXN0cnVjdCBtbHg1X2Zsb3dfYWN0IGZsb3dfYWN0ID0gezB9Ow0KPiAtCXN0
cnVjdCBtbHg1X2Zsb3dfc3BlYyAqc3BlYzsNCj4gKwlzdHJ1Y3QgbWx4NV9mbG93X3NwZWMgKnNw
ZWMgPSBOVUxMOw0KPiAgCWludCBkZXN0X251bSA9IDA7DQo+ICAJaW50IGVyciA9IDA7DQo+ICAJ
dTggKnNtYWNfdjsNCg0KDQpBcHBsaWVkIHRvIG1seDUtbmV4dC4NClRoYW5rcyENCg==
