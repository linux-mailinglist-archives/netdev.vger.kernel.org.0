Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5DEBF96AFF
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 23:00:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730638AbfHTVAc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 17:00:32 -0400
Received: from mail-eopbgr60051.outbound.protection.outlook.com ([40.107.6.51]:3456
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727358AbfHTVAc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Aug 2019 17:00:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ehwnOEtQ76+KTuEs2U3gIx04BViL4QPxdaM5hD1C5sEUQ1KrmWOL4nPDUMwmy7V+4rkT0JcB9zZB5U3mtAlc3B1PRJ136tVaWRsuB+hf/riclDltneRldpQ91Ngl+KmXaky9VbNF4enCiPj8f4qwv9pktr9opu8aHDEOUgMySiBlobrDggUDBeoQPrVY3MOHbS+N3QgMFP0ddpzP9FgsWZdRCVLgrJhmvQReCBPlbvPEXQDA0I3ACindl2oviWVC3QNsBlsOpZ4R+gO43bmU3MNRZT8q5bd+kFIG7OtX+hT3RVLUVyg1L5bpC8JJHHkwvugQnBlo3IxvC/CFfvvB3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hDV3lEnf+pexZVHCF+Jmb99y46GLshA2bxMYB6kj5Ks=;
 b=Em0NN+7+VKMZxU5HEdMLSApk4RC0hh4A4qSVGWo9bePNeteikzOAV9o6i7DjBPLzUFvyHSqgfjGuhjYZKqtEGoOGfKdqUDXn5rFTWUcsa0gMgIRMIrmJqmjliFdL5BuU3ylwjfUd/fdmx5jQi/dXcbO7BljO/lynxBglEJK9PI6lUumCx+MDoeXqjmu8Yaww/wb+lzOVoD8jN09TFFnwaSh+iXo1ODvvG1RpEjCLzLFxGqIezrluDe7rcROpAiteONxBa1Amu1CaSRGXvXYAbxkd7VmYMh98FYYEBqNzSjoZvp8N8AKVOPQbDIdhtwjOWhdCdcdi6JGuo1DHcs8IkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hDV3lEnf+pexZVHCF+Jmb99y46GLshA2bxMYB6kj5Ks=;
 b=kpjykYqyJrgY+Vz7vwWDYULx+fUlLvDACo/V3KqcXP1PLkpSM7OGhjh1BeN/upbehWOsFunlcbNNE1HovpAa2KLKlXZoac9Mra5PuanvBSPh+QHoyWG3/uQY1obA5nOVvSjNaflIsBPJO2izYpqilaNODCpcP+GK+4Yv4ZLkNkk=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2584.eurprd05.prod.outlook.com (10.168.74.135) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.18; Tue, 20 Aug 2019 21:00:28 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2%5]) with mapi id 15.20.2178.018; Tue, 20 Aug 2019
 21:00:28 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "wenwen@cs.uga.edu" <wenwen@cs.uga.edu>
CC:     "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "leon@kernel.org" <leon@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net/mlx5: Fix a memory leak bug
Thread-Topic: [PATCH] net/mlx5: Fix a memory leak bug
Thread-Index: AQHVUbAnGqyOtfCoyUqH08/AYyXp76cEkTQA
Date:   Tue, 20 Aug 2019 21:00:28 +0000
Message-ID: <5edd0874f40b5d720816dce34dd85b2c5e498f34.camel@mellanox.com>
References: <1565684495-2454-1-git-send-email-wenwen@cs.uga.edu>
In-Reply-To: <1565684495-2454-1-git-send-email-wenwen@cs.uga.edu>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.4 (3.32.4-1.fc30) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3fdbdb13-ae7b-448e-d066-08d725b16e45
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:DB6PR0501MB2584;
x-ms-traffictypediagnostic: DB6PR0501MB2584:
x-microsoft-antispam-prvs: <DB6PR0501MB2584944694A9396C2E231EC7BEAB0@DB6PR0501MB2584.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 013568035E
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(366004)(39860400002)(346002)(376002)(136003)(189003)(199004)(5640700003)(229853002)(6916009)(66476007)(64756008)(6246003)(66446008)(486006)(66556008)(76176011)(5660300002)(2501003)(25786009)(8936002)(86362001)(1730700003)(2616005)(66946007)(14444005)(4326008)(53936002)(76116006)(91956017)(256004)(71200400001)(71190400001)(2171002)(6486002)(81156014)(81166006)(8676002)(476003)(3846002)(6116002)(186003)(2906002)(296002)(316002)(6506007)(36756003)(66066001)(2351001)(446003)(11346002)(6436002)(6512007)(26005)(7736002)(305945005)(14454004)(54906003)(478600001)(58126008)(102836004)(99286004)(118296001);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2584;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: yAgwqaxRVIe8L+RLgjq7t+R3aR3Al+YrPzAHk2g+Qr6bzYK3gLANw+wfX6fW8e6N6iKCJibZvaMuUz7eijYKOYO15jM56wsI2sG/4dR4FKIleii6QwPCV5R4WEC9RvPIFkOSO8pNv4lHkN9S2VJGZkgNWPC+lqrP3TjOjTBBTrUVHjO2A+cnTPNP9Kj2tr+065cpGicbHTPOJsd3o+BmJCeNZP5f6qza7H2pc19lNJp7OS9PX0IoqOmWYjkxoxIfKWq4i5j1hXqOWa4QTxUHnpmz4cgJFTxRDhoM/xOCD33F62OnxDX4aQRrozggCOms6OFwM985LAFM2rKhU4RJGcq8IRf+DY8UprzHlBuvKdOcgPdA8YsVfz1YchkCUhyTLB/cVYoRBSe35jkAT0+DTE5cDBGeWSNKBSLnAEAcQ4k=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <9F2E773755379B42BF44D443B1620CB7@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3fdbdb13-ae7b-448e-d066-08d725b16e45
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Aug 2019 21:00:28.4153
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: W6Hzxb/Y0CFuafl2NsUp6KU89Lm0PFmkMejGJVaYn52dm1/es7+OT5IwVA+KCK3QvvYfSPet1HgdGPey815mXQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2584
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDE5LTA4LTEzIGF0IDAzOjIxIC0wNTAwLCBXZW53ZW4gV2FuZyB3cm90ZToNCj4g
SW4gbWx4NV9jbWRfaW52b2tlKCksICdlbnQnIGlzIGFsbG9jYXRlZCB0aHJvdWdoIGt6YWxsb2Mo
KSBpbg0KPiBhbGxvY19jbWQoKS4NCj4gQWZ0ZXIgdGhlIHdvcmsgaXMgcXVldWVkLCB3YWl0X2Z1
bmMoKSBpcyBpbnZva2VkIHRvIHdhaXQgdGhlDQo+IGNvbXBsZXRpb24gb2YNCj4gdGhlIHdvcmsu
IElmIHdhaXRfZnVuYygpIHJldHVybnMgLUVUSU1FRE9VVCwgdGhlIGZvbGxvd2luZyBleGVjdXRp
b24NCj4gd2lsbA0KPiBiZSB0ZXJtaW5hdGVkLiBIb3dldmVyLCB0aGUgYWxsb2NhdGVkICdlbnQn
IGlzIG5vdCBkZWFsbG9jYXRlZCBvbg0KPiB0aGlzDQo+IHByb2dyYW0gcGF0aCwgbGVhZGluZyB0
byBhIG1lbW9yeSBsZWFrIGJ1Zy4NCj4gDQo+IFRvIGZpeCB0aGUgYWJvdmUgaXNzdWUsIGZyZWUg
J2VudCcgYmVmb3JlIHJldHVybmluZyB0aGUgZXJyb3IuDQoNCkhpIFdlbmV3biwgc29ycnkgaSBo
YXZlIHRvIG5hY2sgdGhpcy4NCg0KQXMgTW9zaGUgYWxyZWFkeSBwb2ludGVkIG91dCwgd2UgaW50
ZW50aW9uYWxseSBkb24ndCBmcmVlIGVudCwgc2luY2UNCmV2ZW4gaWYgdGhlIGRyaXZlciBkZWNp
ZGVkIHRvIHRpbWVvdXQsIEZXIG1pZ2h0IHN0aWxsIHNlbmQgYQ0KY29tcGxldGlvbiwgdW50aWwg
dGhlIEZXIHNlbmRzIHRoZSBjb21wbGV0aW9uLCB0aGlzIGVudHJ5IHNob3VsZG4ndCBiZQ0KZnJl
ZWQgYW5kIGlzIG5vdCByZXVzYWJsZSBieSBkcml2ZXIuDQoNClNvIHRoaXMgaXMgbm90IGEgbWVt
b3J5IGxlYWssIGl0IGp1c3QgbWVhbnMgdGhhdCBvbmx5IEZXIGNvbXBsZXRpb24gaXMNCmFsbG93
ZWQgdG8gZnJlZSB0aGlzIGVudHJ5IG9yIGRyaXZlciBzaHV0ZG93bi4uIG90aGVyd2lzZSB0aGlz
IGNvbW1hbmQNCmVudHJ5IGlzIGp1c3QgZGVhZCB1bnRpbCBuZXh0IGZ3IGNvbXBsZXRpb24uDQoN
ClRoYW5rcywNClNhZWVkLg0KDQoNCj4gDQo+IFNpZ25lZC1vZmYtYnk6IFdlbndlbiBXYW5nIDx3
ZW53ZW5AY3MudWdhLmVkdT4NCj4gLS0tDQo+ICBkcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5v
eC9tbHg1L2NvcmUvY21kLmMgfCAyICstDQo+ICAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24o
KyksIDEgZGVsZXRpb24oLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5l
dC9tZWxsYW5veC9tbHg1L2NvcmUvY21kLmMNCj4gYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxs
YW5veC9tbHg1L2NvcmUvY21kLmMNCj4gaW5kZXggOGNkZDdlNi4uOTBjZGI5YSAxMDA2NDQNCj4g
LS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2NtZC5jDQo+ICsr
KyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9jbWQuYw0KPiBAQCAt
MTAzNiw3ICsxMDM2LDcgQEAgc3RhdGljIGludCBtbHg1X2NtZF9pbnZva2Uoc3RydWN0IG1seDVf
Y29yZV9kZXYNCj4gKmRldiwgc3RydWN0IG1seDVfY21kX21zZyAqaW4sDQo+ICANCj4gIAllcnIg
PSB3YWl0X2Z1bmMoZGV2LCBlbnQpOw0KPiAgCWlmIChlcnIgPT0gLUVUSU1FRE9VVCkNCj4gLQkJ
Z290byBvdXQ7DQo+ICsJCWdvdG8gb3V0X2ZyZWU7DQo+ICANCj4gIAlkcyA9IGVudC0+dHMyIC0g
ZW50LT50czE7DQo+ICAJb3AgPSBNTFg1X0dFVChtYm94X2luLCBpbi0+Zmlyc3QuZGF0YSwgb3Bj
b2RlKTsNCg==
