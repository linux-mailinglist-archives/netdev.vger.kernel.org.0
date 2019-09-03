Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8BDFA7445
	for <lists+netdev@lfdr.de>; Tue,  3 Sep 2019 22:09:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726649AbfICUJD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Sep 2019 16:09:03 -0400
Received: from mail-eopbgr00062.outbound.protection.outlook.com ([40.107.0.62]:24230
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725882AbfICUJD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Sep 2019 16:09:03 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SwrIHNbbuth5/1E+hUZOjirgRgfdMEuJppl8zuVgR7P4S/iFpH3rFp6aOOiCp21jwHtdqE2N6XqemZzzoDoybG1tWEZvyOBpl7LIgO9D1hD22hoSdLyliSc/QRokCNpaBqqYK8+QOca7BINDznS+dKbYoIaQIUndEH2PpKyBz21Vq/CO9drEQDcswzYNlMyXn4wgYPyUydLILInaK7GtqnrGHKjWBzPcDtHRbWlwwizHcsNBW+33/V7gLy2sMLpPZaHCATGYWHMbefXwzRQOkgxMeqHlozArkNtqWOqF+AK/JS1naxdtAvee+yuiyj2AkAOgkMwkKBpbArIw4KiERQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D0hZSsQiW1yu8OrrxMN8IQcEgWGhXbAtyC2JfdWtzHg=;
 b=KgBoX1B5ZkSEgH47SX0vnN4SiObm9ZrtP3U1LZ4o6G4oEJmwMD2ERtm16C+iCs6xZmBj8WwlUa1FkAl8gVvIsJe9QGmY9tZBGVG7z2jjt2rj88caGY+0FBsu0Avum37hrl8rykKEpX4oEkwzvlrSqaQfgNbzIpEykuhAwRuzPBfY59vtDKCNv/JcgTh0dCtzr8wMVEAcZnCaxEUF2zPybXSA0HlPtZGvCTFfvKxWWyit5AZon2h+aJ0fV/6euGCWm9sWAiagDDn9I6Huym2bNSWNiHshaU9PrVd3jMvfDgSoUAYtP2pwxdUrhsyew1TVtii8M8X0aaqxRv5yiHzrJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D0hZSsQiW1yu8OrrxMN8IQcEgWGhXbAtyC2JfdWtzHg=;
 b=Tqn5KwIs+pAqM8YbS1LdL56zaJFPZcAxVUF5TSOFhOWbIFkwMvb4grPTwmklgqb2MyAuR0vCi02xqb1qyGim5wzqU4cJKWYMYP7Ca2CrHqiLCxpUa8lsQpQc7nE4rJwpis5OZ9uOIEBFn3haA4IvSPVKIFTQ8TgWME1Rg1MGWvY=
Received: from AM4PR0501MB2756.eurprd05.prod.outlook.com (10.172.216.138) by
 AM4PR0501MB2612.eurprd05.prod.outlook.com (10.172.221.139) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2199.21; Tue, 3 Sep 2019 20:08:57 +0000
Received: from AM4PR0501MB2756.eurprd05.prod.outlook.com
 ([fe80::58d1:d1d6:dbda:3576]) by AM4PR0501MB2756.eurprd05.prod.outlook.com
 ([fe80::58d1:d1d6:dbda:3576%4]) with mapi id 15.20.2220.021; Tue, 3 Sep 2019
 20:08:56 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "zhongjiang@huawei.com" <zhongjiang@huawei.com>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "leon@kernel.org" <leon@kernel.org>
Subject: Re: [PATCH] net/mlx5: Use PTR_ERR_OR_ZERO rather than its
 implementation
Thread-Topic: [PATCH] net/mlx5: Use PTR_ERR_OR_ZERO rather than its
 implementation
Thread-Index: AQHVYiUbtHW+f4OkM0m4fuPqj7OPRKcaYomA
Date:   Tue, 3 Sep 2019 20:08:56 +0000
Message-ID: <797f3807c00a52ea923301b4859f24145f0a291a.camel@mellanox.com>
References: <1567493770-20074-1-git-send-email-zhongjiang@huawei.com>
In-Reply-To: <1567493770-20074-1-git-send-email-zhongjiang@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.4 (3.32.4-1.fc30) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fec1a3ca-5f34-48b6-b2fe-08d730aa8d52
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM4PR0501MB2612;
x-ms-traffictypediagnostic: AM4PR0501MB2612:
x-microsoft-antispam-prvs: <AM4PR0501MB26126691991FE7002909E016BEB90@AM4PR0501MB2612.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:635;
x-forefront-prvs: 01494FA7F7
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(39860400002)(136003)(366004)(346002)(376002)(189003)(199004)(8676002)(14454004)(6246003)(91956017)(76116006)(8936002)(6436002)(81166006)(81156014)(99286004)(66946007)(446003)(11346002)(186003)(2616005)(6512007)(6486002)(6116002)(76176011)(478600001)(86362001)(102836004)(486006)(3846002)(5660300002)(26005)(305945005)(53936002)(7736002)(316002)(6506007)(476003)(14444005)(229853002)(2501003)(71200400001)(36756003)(71190400001)(66066001)(2906002)(58126008)(25786009)(4326008)(54906003)(110136005)(4744005)(66476007)(118296001)(66556008)(66446008)(64756008)(256004);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR0501MB2612;H:AM4PR0501MB2756.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: a2BE/bbCmj8upemUAYy0jb2265oEgZ47WOZoXbr4xv6zzSgVqSBSmzzIyp7BL75/IlN9grfVs/entHh5JWzk4Py56YZZtumH7z9TrzQvFIMQh/aQ59YYy3n4tzEnDxxtg7K0J5R3Uo2tH7iybnyjeLyGY9MOq1lILBrKrZz0EpMlpoBBghJpg2xYypRjst6HckMM5q6M+h2LMkdQdnLR97ra9lo9F+wZw3JWuu+XzP1KqQgs/iqiXG3aI8+PfOTkJb+JiJfOXix3ulYi4IQ20juP9avrORExvOs2SGZ4aW6VnRhaGK5cm/veGagMdxsNAyY2K0HC1WGnoWG8Rg9LjzyanWN/3FEWc3BljPo0d1cjk1iDhdaH5WJeJ8/8eSTWY5G64RKZjBFE+i1QhgwCqahzBkegnBrkakKuqLRpUQU=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <0EF271330B8D22479621DF09EEEA0807@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fec1a3ca-5f34-48b6-b2fe-08d730aa8d52
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Sep 2019 20:08:56.8146
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4hcbjNL1wRtR8RO+KSDOpLliwdEfpjnfkAMD51/EU/b+ekMrPqtzXfirSEiLAJZ6dwejDJdMqPgblBMq7JMJ7A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR0501MB2612
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDE5LTA5LTAzIGF0IDE0OjU2ICswODAwLCB6aG9uZyBqaWFuZyB3cm90ZToNCj4g
UFRSX0VSUl9PUl9aRVJPIGNvbnRhaW5zIGlmKElTX0VSUiguLi4pKSArIFBUUl9FUlIuIEl0IGlz
IGJldHRlcg0KPiB0byB1c2UgaXQgZGlyZWN0bHkuIGhlbmNlIGp1c3QgcmVwbGFjZSBpdC4NCj4g
DQo+IFNpZ25lZC1vZmYtYnk6IHpob25nIGppYW5nIDx6aG9uZ2ppYW5nQGh1YXdlaS5jb20+DQo+
IC0tLQ0KPiAgZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VuX3RjLmMg
fCA1ICstLS0tDQo+ICAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKyksIDQgZGVsZXRpb25z
KC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4
NS9jb3JlL2VuX3RjLmMNCj4gYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2Nv
cmUvZW5fdGMuYw0KPiBpbmRleCA1NTgxYTgwLi4yZTBiNDY3IDEwMDY0NA0KPiAtLS0gYS9kcml2
ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW5fdGMuYw0KPiArKysgYi9kcml2
ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW5fdGMuYw0KPiBAQCAtOTg5LDEw
ICs5ODksNyBAQCBzdGF0aWMgdm9pZCBtbHg1ZV9oYWlycGluX2Zsb3dfZGVsKHN0cnVjdA0KPiBt
bHg1ZV9wcml2ICpwcml2LA0KPiAgCQkJCQkgICAgJmZsb3dfYWN0LCBkZXN0LCBkZXN0X2l4KTsN
Cj4gIAltdXRleF91bmxvY2soJnByaXYtPmZzLnRjLnRfbG9jayk7DQo+ICANCj4gLQlpZiAoSVNf
RVJSKGZsb3ctPnJ1bGVbMF0pKQ0KPiAtCQlyZXR1cm4gUFRSX0VSUihmbG93LT5ydWxlWzBdKTsN
Cj4gLQ0KPiAtCXJldHVybiAwOw0KPiArCXJldHVybiBQVFJfRVJSX09SX1pFUk8oZmxvdy0+cnVs
ZVswXSk7DQo+ICB9DQo+ICANCj4gIHN0YXRpYyB2b2lkIG1seDVlX3RjX2RlbF9uaWNfZmxvdyhz
dHJ1Y3QgbWx4NWVfcHJpdiAqcHJpdiwNCg0KQWNrZWQtYnk6IFNhZWVkIE1haGFtZWVkIDxzYWVl
ZG1AbWVsbGFub3guY29tPg0K
