Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CDFECA9719
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 01:29:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730273AbfIDX3W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 19:29:22 -0400
Received: from mail-eopbgr30087.outbound.protection.outlook.com ([40.107.3.87]:51718
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727156AbfIDX3V (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Sep 2019 19:29:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dS4KkApLpvLPGlJXqbITd5rPAy8CfrZIBvDUrk76oojygq/hzAxwI3WpnKCPgB2TG01SnEQ0bacr/nmRRNlguB3Izn1xCngJ1J8rUroU+iREldmLKIDGxsUnRVAtYx0idZhRpLtjfqPxgwZxyZFKZh1Difwn9I/XmhpLi9cpJogs0DQAXY7DHguZNQi+TzYBXx8r1z8+vkIuUDadH1cVeTUdPOaOpSwTbp8wXvBk9qSoLH4LvlyknSzMm/5q1tNbH3DkKW7rYtDt7PejWI2Bnq/jJPmWXYeSRA36Zxp02932So//SfFez8hXwrq8dOBsnUVD4CrOv5+01O2ly7ibkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Sa5AKKDV0Ae1NSuz7cow2MAEQLxzDuFpR+GNzalSPGo=;
 b=lrj0lL8RIed8pbmKjqksWLIuGdzRDYCo/TnKywjhoDxHn5eL7C+P5VqxywiARY2otEUXWokggurQaEn8anyeETQXZG7YwcBkF2sms9oaC6kXAKXfpA/4Eo4FBXRgxyvW9yBkmUGUu3NATtXZ+Vtbx+rTlcUNxvpu1LECTV9NCPrQTeK1QEZDfLVoaH9gMN/5371iV8KMdT8DEE7yby7Kc9BQTe+dYv0BT6tXXp1Bp8ce+6rOZ2TzFmUUG+sbedFvPxQsDP6cf7FXsPdKns0Tb3uSrATDdyZnHc/9RirUOoKcYmMP8qeNXiF5z3tLgl5Zrti+tCg66RxoxuKAc/GmNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Sa5AKKDV0Ae1NSuz7cow2MAEQLxzDuFpR+GNzalSPGo=;
 b=MZSp3BuLJ7aRkVm1yOYZdO5L4IbNQ9k8BR1covQ1SXi3mFYlG9MTdiTbSE/G+AqeEXtz/ANCsOzV+gyg9w0tKJ8Bq/Ym2y0R+4k/tkG7hpaeFRaoyZZuDRzd8LVqGMax0ESn43GysAsmcFqyyB3+IX2E7j/CfPKjXOymhVPg7RY=
Received: from VI1PR0501MB2765.eurprd05.prod.outlook.com (10.172.11.140) by
 VI1PR0501MB2174.eurprd05.prod.outlook.com (10.169.134.27) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2220.20; Wed, 4 Sep 2019 23:29:16 +0000
Received: from VI1PR0501MB2765.eurprd05.prod.outlook.com
 ([fe80::c4f0:4270:5311:f4b9]) by VI1PR0501MB2765.eurprd05.prod.outlook.com
 ([fe80::c4f0:4270:5311:f4b9%5]) with mapi id 15.20.2220.022; Wed, 4 Sep 2019
 23:29:16 +0000
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
Thread-Index: AQHVYiUbtHW+f4OkM0m4fuPqj7OPRKcaYomAgAHKTAA=
Date:   Wed, 4 Sep 2019 23:29:16 +0000
Message-ID: <0832b2b0c5b6ab21ef9a2f6f81c44b5985c9b20b.camel@mellanox.com>
References: <1567493770-20074-1-git-send-email-zhongjiang@huawei.com>
         <797f3807c00a52ea923301b4859f24145f0a291a.camel@mellanox.com>
In-Reply-To: <797f3807c00a52ea923301b4859f24145f0a291a.camel@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.4 (3.32.4-1.fc30) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9fe6e5bd-70a3-4219-5078-08d7318fb432
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR0501MB2174;
x-ms-traffictypediagnostic: VI1PR0501MB2174:
x-microsoft-antispam-prvs: <VI1PR0501MB21747E043109272367091253BEB80@VI1PR0501MB2174.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:820;
x-forefront-prvs: 0150F3F97D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(396003)(136003)(346002)(376002)(366004)(199004)(189003)(81156014)(8936002)(8676002)(54906003)(26005)(110136005)(66946007)(305945005)(66476007)(66556008)(66446008)(36756003)(91956017)(186003)(86362001)(4326008)(25786009)(316002)(6436002)(81166006)(6512007)(102836004)(6246003)(6506007)(64756008)(53936002)(476003)(11346002)(58126008)(446003)(2616005)(229853002)(14454004)(6486002)(76176011)(478600001)(486006)(5660300002)(99286004)(71190400001)(6116002)(2501003)(66066001)(3846002)(71200400001)(2906002)(118296001)(256004)(76116006)(14444005)(7736002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0501MB2174;H:VI1PR0501MB2765.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 3JZo30LWnV77baYuEo+fE4JaAUnfHLbjSYDHbsVhC3Kgf2wEy70dqq3aQ4ujP6e+dikxnSCQ6tgizbta6g1LI9sa+0Vm5OZ0bHgY0EiaVDqF/EbE2E+ESb3mr0oSYfJOe6GZ0w+mleZHD3pmayqUg8DAuk4MJWzZrNKRFzili/rwuImmj3eNEFAWHzyj1MV7zaEJqIpBjs+BBi9i2tcmcc+KTpCPbhYN4rh7sJFX3QanvxzwdTd1e2xVHi76Nc6Au5rFsaMRrY8tHdYhMijv9vNQqvh+zCCePhG/eChY5AsYwbo1yXRAb2NtzQEPcWQEnT6xZsMlL0KFku3NarwNp3HC+754R9G+uUY29zGc9hOhraBEsrr6i2ceAlsunJHEk2IG3NQYMkm8eT/0phVngwITtGZ41G6kj4bRw1zNsyU=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <7D72FC2A88F8CE4BACE3A72BB8F73446@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9fe6e5bd-70a3-4219-5078-08d7318fb432
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Sep 2019 23:29:16.7740
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vzg5E7CuWRZ2TrzcS8kRdUOftRjbZ9sM9suppin4SWfNq9VP/wyrWT86XWeuFBsbRJ3lC0B2LB5RfdOhgxgSiA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0501MB2174
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDE5LTA5LTAzIGF0IDIwOjA4ICswMDAwLCBTYWVlZCBNYWhhbWVlZCB3cm90ZToN
Cj4gT24gVHVlLCAyMDE5LTA5LTAzIGF0IDE0OjU2ICswODAwLCB6aG9uZyBqaWFuZyB3cm90ZToN
Cj4gPiBQVFJfRVJSX09SX1pFUk8gY29udGFpbnMgaWYoSVNfRVJSKC4uLikpICsgUFRSX0VSUi4g
SXQgaXMgYmV0dGVyDQo+ID4gdG8gdXNlIGl0IGRpcmVjdGx5LiBoZW5jZSBqdXN0IHJlcGxhY2Ug
aXQuDQo+ID4gDQo+ID4gU2lnbmVkLW9mZi1ieTogemhvbmcgamlhbmcgPHpob25namlhbmdAaHVh
d2VpLmNvbT4NCj4gPiAtLS0NCj4gPiAgZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4
NS9jb3JlL2VuX3RjLmMgfCA1ICstLS0tDQo+ID4gIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlv
bigrKSwgNCBkZWxldGlvbnMoLSkNCj4gPiANCj4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQv
ZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VuX3RjLmMNCj4gPiBiL2RyaXZlcnMvbmV0L2V0
aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lbl90Yy5jDQo+ID4gaW5kZXggNTU4MWE4MC4uMmUw
YjQ2NyAxMDA2NDQNCj4gPiAtLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1
L2NvcmUvZW5fdGMuYw0KPiA+ICsrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21s
eDUvY29yZS9lbl90Yy5jDQo+ID4gQEAgLTk4OSwxMCArOTg5LDcgQEAgc3RhdGljIHZvaWQgbWx4
NWVfaGFpcnBpbl9mbG93X2RlbChzdHJ1Y3QNCj4gPiBtbHg1ZV9wcml2ICpwcml2LA0KPiA+ICAJ
CQkJCSAgICAmZmxvd19hY3QsIGRlc3QsIGRlc3RfaXgpOw0KPiA+ICAJbXV0ZXhfdW5sb2NrKCZw
cml2LT5mcy50Yy50X2xvY2spOw0KPiA+ICANCj4gPiAtCWlmIChJU19FUlIoZmxvdy0+cnVsZVsw
XSkpDQo+ID4gLQkJcmV0dXJuIFBUUl9FUlIoZmxvdy0+cnVsZVswXSk7DQo+ID4gLQ0KPiA+IC0J
cmV0dXJuIDA7DQo+ID4gKwlyZXR1cm4gUFRSX0VSUl9PUl9aRVJPKGZsb3ctPnJ1bGVbMF0pOw0K
PiA+ICB9DQo+ID4gIA0KPiA+ICBzdGF0aWMgdm9pZCBtbHg1ZV90Y19kZWxfbmljX2Zsb3coc3Ry
dWN0IG1seDVlX3ByaXYgKnByaXYsDQo+IA0KPiBBY2tlZC1ieTogU2FlZWQgTWFoYW1lZWQgPHNh
ZWVkbUBtZWxsYW5veC5jb20+DQoNCkFwcGxpZWQgdG8gbmV0LW5leHQtbWx4NSBhcyBpIGhhdmUg
YSBjbGVhbnVwIHNlcmllcyBjb21pbmcgdXAgc29vbi4NCg0KVGhhbmtzLA0KU2FlZWQuDQo=
