Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49B129DC9C
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 06:29:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729159AbfH0E3V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 00:29:21 -0400
Received: from mail-eopbgr130042.outbound.protection.outlook.com ([40.107.13.42]:54244
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725795AbfH0E3V (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Aug 2019 00:29:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bhvo4N4tOZc6PyQMfO6YylClKiRbhA7MJP4HEYUaegB8uLBETVgmr8fzoNtT4IleFs9hckoAx2imPStANanvsmNUoCEUHqX41YKJTFS5fnd6aTEUeC59IpHozRpkpwP2hRg10+N3/JFrvYKlXRTk3tAdI9L0IkhSLPRvwAIg0ZV8pjhN8Sdcgu7funtDw1+BGIwMc7UZNF7k4PVE7+Urr6oPYDuqEnyExQA2+e/uDoKLjPH6WoKaV89yfEidvI+rfBAIvoNdsHBV7rgOS5T/RqSnGrKcm0/pWUoZLYALO6SYiuD9TPK//n2LJgArrl683hUE8drR3LnEBNLPiMnMhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MS84kg56Twko/45NYKHmSkzwKtzS4sLY3QbrRYvyEcE=;
 b=N86aSJ7cpzEa/c1jGXPcSYuLz+xlhoJNrZZG3GjXscXpGSJuSqEtUwqq+2PvxKR/MxnzyRS/1xzHcndyElWpY4yVJgtAifpQFKsEK3ggFEuP+26hF+akUYDsG+J5tn5NPqCs0O72rhoO279wXZGo6cFs3E8elXjzcry+KbgJDb8tWy/cpmIfsTR07/jkDfe8dI2igXmN8RwZDmKxtie4KiW1MOjc7Jvd4GhL/TTjmFE13HXUq317JSrniOX6ThiVg5do9eXuO9/fySlA/UzgmoeXflPP9t/xDZ53CFRfQSAzdPz9gDZTsxIA1V8AH1nIgyRl54hEkL0BFXFTj+xjMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MS84kg56Twko/45NYKHmSkzwKtzS4sLY3QbrRYvyEcE=;
 b=amo0MmimZqbr37cGbG8Giy5WXvZ14vQ15KCnni+Px0VU1/X/q+Q6pvw1CIQoMPYJMG3jNnp83Yif2Mj8Iqy9PlJHgH13JcUTzuI/b5XaSIjQAhzFL7Qhus/XHM0BfkAuaFpN/vr5AYPYEAs49wEc7BbjeNVQCvUljM3HKR6fB1s=
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (20.176.214.160) by
 AM0PR05MB4532.eurprd05.prod.outlook.com (52.133.55.143) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2199.21; Tue, 27 Aug 2019 04:28:37 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::216f:f548:1db0:41ea]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::216f:f548:1db0:41ea%6]) with mapi id 15.20.2199.020; Tue, 27 Aug 2019
 04:28:37 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     Mark Bloch <markb@mellanox.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH 2/4] mdev: Make mdev alias unique among all mdevs
Thread-Topic: [PATCH 2/4] mdev: Make mdev alias unique among all mdevs
Thread-Index: AQHVXE627FcLaFBgXUa8jSc95m92WKcOC/2AgABaVPA=
Date:   Tue, 27 Aug 2019 04:28:37 +0000
Message-ID: <AM0PR05MB4866BB4736D265EF28280014D1A00@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20190826204119.54386-1-parav@mellanox.com>
 <20190826204119.54386-3-parav@mellanox.com>
 <6601940a-4832-08d2-e0f6-f9ac24758cdc@mellanox.com>
In-Reply-To: <6601940a-4832-08d2-e0f6-f9ac24758cdc@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [106.51.18.188]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2c05664b-8617-4563-af45-08d72aa707ce
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM0PR05MB4532;
x-ms-traffictypediagnostic: AM0PR05MB4532:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR05MB45321B351CD98EF782C8811DD1A00@AM0PR05MB4532.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 0142F22657
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(376002)(39860400002)(136003)(346002)(396003)(199004)(189003)(13464003)(6506007)(71190400001)(71200400001)(6436002)(66066001)(55016002)(86362001)(81156014)(81166006)(9686003)(186003)(8676002)(9456002)(5660300002)(66556008)(66946007)(6116002)(76116006)(66446008)(8936002)(33656002)(3846002)(64756008)(7696005)(2501003)(2906002)(76176011)(66476007)(486006)(6246003)(2201001)(26005)(476003)(25786009)(110136005)(446003)(102836004)(14454004)(229853002)(11346002)(99286004)(4326008)(305945005)(52536014)(55236004)(54906003)(74316002)(14444005)(256004)(7736002)(316002)(478600001)(53546011)(53936002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB4532;H:AM0PR05MB4866.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 5dctfSBB0qt0of8FCBZV+v/D8qfgcEHYFV7aCBcnv3PUAA3JDtGjMlQDNai5XA3mfb+KX1E1ujPOpUjpvBrUFCiZ92xSTt9tJS/Mtj/nNuPDEDIfTn8/jrhQ37j+Rn+JHeFxLjeYt4uaivn+WqvxRCCIXfle2Woxge20bpNSguffrficbJzn/0fycyQT6uU1/wfH/q+U1DiYV1dmhkGBgWj6X1fVCDVBqANnTmfRRkpuk6LEZxw8zkd59e9CPWL9OligZQ97V4uyiieqaECqDfv4PBYhfcAC6hVn6syqozVhWgjIhkWm26iGv85X3tecVLVCFuD/ZVdY8Zope+YmOIMEffFfk0NwMppOjMGpYj4KsECWL5pfRiPZmuLXYlVmev5ouibqH4/LHY8zQzHYGo6JOsqpbum/mjTuFv+d4jY=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c05664b-8617-4563-af45-08d72aa707ce
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Aug 2019 04:28:37.3696
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1fcKZbygwuwMZQ60KYzFwNigiaCXKuvQAQHbPxub7mcGCjMeUpb6V9U/Ezyqgp6mbGGF/rVmF/4hn1sEh3Fzig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB4532
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgTWFyaywNCg0KPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBNYXJrIEJs
b2NoIDxtYXJrYkBtZWxsYW5veC5jb20+DQo+IFNlbnQ6IFR1ZXNkYXksIEF1Z3VzdCAyNywgMjAx
OSA0OjMyIEFNDQo+IFRvOiBQYXJhdiBQYW5kaXQgPHBhcmF2QG1lbGxhbm94LmNvbT47IGFsZXgu
d2lsbGlhbXNvbkByZWRoYXQuY29tOyBKaXJpDQo+IFBpcmtvIDxqaXJpQG1lbGxhbm94LmNvbT47
IGt3YW5raGVkZUBudmlkaWEuY29tOyBjb2h1Y2tAcmVkaGF0LmNvbTsNCj4gZGF2ZW1AZGF2ZW1s
b2Z0Lm5ldA0KPiBDYzoga3ZtQHZnZXIua2VybmVsLm9yZzsgbGludXgta2VybmVsQHZnZXIua2Vy
bmVsLm9yZzsNCj4gbmV0ZGV2QHZnZXIua2VybmVsLm9yZw0KPiBTdWJqZWN0OiBSZTogW1BBVENI
IDIvNF0gbWRldjogTWFrZSBtZGV2IGFsaWFzIHVuaXF1ZSBhbW9uZyBhbGwgbWRldnMNCj4gDQo+
IA0KPiANCj4gT24gOC8yNi8xOSAxOjQxIFBNLCBQYXJhdiBQYW5kaXQgd3JvdGU6DQo+ID4gTWRl
diBhbGlhcyBzaG91bGQgYmUgdW5pcXVlIGFtb25nIGFsbCB0aGUgbWRldnMsIHNvIHRoYXQgd2hl
biBzdWNoDQo+ID4gYWxpYXMgaXMgdXNlZCBieSB0aGUgbWRldiB1c2VycyB0byBkZXJpdmUgb3Ro
ZXIgb2JqZWN0cywgdGhlcmUgaXMgbm8NCj4gPiBjb2xsaXNpb24gaW4gYSBnaXZlbiBzeXN0ZW0u
DQo+ID4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBQYXJhdiBQYW5kaXQgPHBhcmF2QG1lbGxhbm94LmNv
bT4NCj4gPiAtLS0NCj4gPiAgZHJpdmVycy92ZmlvL21kZXYvbWRldl9jb3JlLmMgfCA1ICsrKysr
DQo+ID4gIDEgZmlsZSBjaGFuZ2VkLCA1IGluc2VydGlvbnMoKykNCj4gPg0KPiA+IGRpZmYgLS1n
aXQgYS9kcml2ZXJzL3ZmaW8vbWRldi9tZGV2X2NvcmUuYw0KPiA+IGIvZHJpdmVycy92ZmlvL21k
ZXYvbWRldl9jb3JlLmMgaW5kZXggZTgyNWZmMzhiMDM3Li42ZWIzN2YwYzYzNjkNCj4gPiAxMDA2
NDQNCj4gPiAtLS0gYS9kcml2ZXJzL3ZmaW8vbWRldi9tZGV2X2NvcmUuYw0KPiA+ICsrKyBiL2Ry
aXZlcnMvdmZpby9tZGV2L21kZXZfY29yZS5jDQo+ID4gQEAgLTM3NSw2ICszNzUsMTEgQEAgaW50
IG1kZXZfZGV2aWNlX2NyZWF0ZShzdHJ1Y3Qga29iamVjdCAqa29iaiwNCj4gc3RydWN0IGRldmlj
ZSAqZGV2LA0KPiA+ICAJCQlyZXQgPSAtRUVYSVNUOw0KPiA+ICAJCQlnb3RvIG1kZXZfZmFpbDsN
Cj4gPiAgCQl9DQo+ID4gKwkJaWYgKHRtcC0+YWxpYXMgJiYgc3RyY21wKHRtcC0+YWxpYXMsIGFs
aWFzKSA9PSAwKSB7DQo+IA0KPiBhbGlhcyBjYW4gYmUgTlVMTCBoZXJlIG5vPw0KPiANCklmIGFs
aWFzIGlzIE5VTEwsIHRtcC0+YWxpYXMgd291bGQgYWxzbyBiZSBudWxsIGJlY2F1c2UgZm9yIGdp
dmVuIHBhcmVudCBlaXRoZXIgd2UgaGF2ZSBhbGlhcyBvciB3ZSBkb27igJl0Lg0KU28gaXRzIG5v
dCBwb3NzaWJsZSB0byBoYXZlIHRtcC0+YWxpYXMgYXMgbnVsbCBhbmQgYWxpYXMgYXMgbm9uIG51
bGwuDQpCdXQgaXQgbWF5IGJlIGdvb2QvZGVmZW5zaXZlIHRvIGFkZCBjaGVjayBmb3IgYm90aC4N
Cg0KPiA+ICsJCQltdXRleF91bmxvY2soJm1kZXZfbGlzdF9sb2NrKTsNCj4gPiArCQkJcmV0ID0g
LUVFWElTVDsNCj4gPiArCQkJZ290byBtZGV2X2ZhaWw7DQo+ID4gKwkJfQ0KPiA+ICAJfQ0KPiA+
DQo+ID4gIAltZGV2ID0ga3phbGxvYyhzaXplb2YoKm1kZXYpLCBHRlBfS0VSTkVMKTsNCj4gPg0K
PiANCj4gTWFyaw0K
