Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4560136CFA
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 09:07:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726535AbfFFHHk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 03:07:40 -0400
Received: from mail-eopbgr10063.outbound.protection.outlook.com ([40.107.1.63]:59717
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725782AbfFFHHk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Jun 2019 03:07:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cgaHminEpWPuN7BHVkBGIwWyJnqo0AkP24ao+keVN/M=;
 b=QFLqq5FzxHZErkfZXdyVC409eF90j6ex0HsUVbBk3xFQOohkqE1qdQZba1JlnpV904ezL0GDhLJfniv3UNmBHrPtPJn5/xfq3IUOQFTt1sDpsAodBiKgG7fDb49nlcZ91YOUDLC0CALMpmYVdBjcs4PE6AITsd9SWfT75/x4KJs=
Received: from AM6PR05MB5460.eurprd05.prod.outlook.com (20.177.118.158) by
 AM6PR05MB6440.eurprd05.prod.outlook.com (20.179.6.207) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1943.22; Thu, 6 Jun 2019 07:07:35 +0000
Received: from AM6PR05MB5460.eurprd05.prod.outlook.com
 ([fe80::1be:2d8b:a10:6032]) by AM6PR05MB5460.eurprd05.prod.outlook.com
 ([fe80::1be:2d8b:a10:6032%5]) with mapi id 15.20.1965.011; Thu, 6 Jun 2019
 07:07:35 +0000
From:   Boris Pismenny <borisp@mellanox.com>
To:     Davide Caratti <dcaratti@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dave Watson <davejwatson@fb.com>,
        Aviad Yehezkel <aviadye@mellanox.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [RFC PATCH net-next 2/2] net: tls: export protocol version and
 cipher to socket diag
Thread-Topic: [RFC PATCH net-next 2/2] net: tls: export protocol version and
 cipher to socket diag
Thread-Index: AQHVG7TzKYlWmzDfDkG2W7bLCUJu56aONZsA
Date:   Thu, 6 Jun 2019 07:07:35 +0000
Message-ID: <558af015-6cb0-5b6c-c6fd-c67b84ff06da@mellanox.com>
References: <cover.1559747691.git.dcaratti@redhat.com>
 <4262dd2617a24b66f24ec5ddc73f817e683e14e0.1559747691.git.dcaratti@redhat.com>
In-Reply-To: <4262dd2617a24b66f24ec5ddc73f817e683e14e0.1559747691.git.dcaratti@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM6P193CA0003.EURP193.PROD.OUTLOOK.COM
 (2603:10a6:209:3e::16) To AM6PR05MB5460.eurprd05.prod.outlook.com
 (2603:10a6:20b:5b::30)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=borisp@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [193.47.165.251]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ebe908b6-3801-49ac-4d19-08d6ea4da6d5
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM6PR05MB6440;
x-ms-traffictypediagnostic: AM6PR05MB6440:
x-microsoft-antispam-prvs: <AM6PR05MB64404D0F75B9301EED393237B0170@AM6PR05MB6440.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 00603B7EEF
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(39860400002)(396003)(346002)(366004)(376002)(199004)(189003)(25786009)(8676002)(186003)(53936002)(31686004)(6116002)(81166006)(81156014)(66066001)(486006)(31696002)(71200400001)(71190400001)(229853002)(14444005)(305945005)(256004)(7736002)(2906002)(11346002)(14454004)(2616005)(102836004)(476003)(53546011)(6246003)(86362001)(386003)(6506007)(3846002)(66476007)(6512007)(5660300002)(73956011)(66556008)(52116002)(66446008)(76176011)(64756008)(2501003)(8936002)(446003)(478600001)(68736007)(6436002)(36756003)(110136005)(316002)(99286004)(26005)(66946007)(6486002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR05MB6440;H:AM6PR05MB5460.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 71zqGuOL16Zg7Ly1oGDJ5z6xZeRm/JS8jhzFMBBooXGtt8lDVovHtmZx19P/YwdMKfXWv/lBzKyAANdonnn8P89okvfsl37NUKq2FSCB8h1VsUU1rP0E++NwVvz4jlm5mU3LJ3FKMjMdyRt8EwUZhhJk4wuwy4Y0bDdwW3fJy6+QQeiNyex3tYx7WdIj3VKhgL0KdGgliPkWH7xL4uT1DOqWyMGceAPxZDUZlf6elKzWOneQltotT3dlMEEZoqfpI/4CwR32oFI5X2ZcKHQj5youVtXJu20HflnW8CkHAmYWm5keRpBseNkHHB3V2ALd3UQgX0sfTr1UW8EGhRNJT07HUXddMUnM0GYp7bEj0A6SA4ItQ2W96m1DL45jpZ3Ii4kdObbO9BVmaF+PDQPE+iX7le6YAxBIuEZyD0sjjpQ=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F21D3A3FCCB76B4EA8A993AB89D2E96C@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ebe908b6-3801-49ac-4d19-08d6ea4da6d5
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jun 2019 07:07:35.4720
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: borisp@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB6440
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgRGF2aWRlLA0KDQpUTFMgc3RhdGlzdGljcyBhcmUgbG9uZyBvdmVyZHVlLiBJJ2QgbGlrZSB0
byBleHRlbmQgdGhpcyBsYXRlciBmb3IgdGhlIA0KdGxzX2RldmljZSBjb2RlLCBlLmcuIGRldmlj
ZV9kZWNyeXB0ZWQgdnMuIHNvZnR3YXJlX2RlY3J5cHRlZC4NCg0KT24gNi81LzIwMTkgNjozOSBQ
TSwgRGF2aWRlIENhcmF0dGkgd3JvdGU6DQoNCj4gICANCj4gK3N0YXRpYyBpbnQgdGxzX2dldF9p
bmZvKHN0cnVjdCBzb2NrICpzaywgc3RydWN0IHNrX2J1ZmYgKnNrYikNCj4gK3sNCj4gKwlzdHJ1
Y3QgdGxzX2NvbnRleHQgKmN0eCA9IHRsc19nZXRfY3R4KHNrKTsNCj4gKwlzdHJ1Y3QgbmxhdHRy
ICpzdGFydCA9IDA7DQo+ICsJaW50IGVyciA9IDA7DQo+ICsNCj4gKwlpZiAoc2stPnNrX3N0YXRl
ICE9IFRDUF9FU1RBQkxJU0hFRCkNCj4gKwkJZ290byBlbmQ7DQoNCk1heWJlIGl0IHdvdWxkIGJl
IGJlc3QgdG8gdmVyaWZ5IHRoYXQgdGhlIHZlcnNpb24gYW5kIGNpcGhlciBoYXZlIGJlZW4gDQpp
bml0aWFsaXplZC4gQXMgdGhlIFRMU19VTFAgbWlnaHQgYmUgZW5hYmxlZCBidXQgbm8gc29ja2V0
IG9wdGlvbiBoYXMgDQpiZWVuIGNhbGxlZCB0byBzZXQgaXRzIHZhbHVlcy4NCg0KQWxzbywgSSBz
dWdnZXN0IHRoaXMgY2hlY2sgaXMgcGxhY2VkIGluIHRoZSB0bHNfZ2V0X2luZm9fc2l6ZSB0byBt
YWtlIA0KdGhpcyBtb3JlIGV4cGxpY2l0IHRvIHRoZSB1c2VyLg0KDQo+ICsJc3RhcnQgPSBubGFf
bmVzdF9zdGFydF9ub2ZsYWcoc2tiLCBVTFBfSU5GT19UTFMpOw0KPiArCWlmICghc3RhcnQpIHsN
Cj4gKwkJZXJyID0gLUVNU0dTSVpFOw0KPiArCQlnb3RvIG5sYV9mYWlsdXJlOw0KPiArCX0NCj4g
KwllcnIgPSBubGFfcHV0X3UxNihza2IsIFRMU19JTkZPX1ZFUlNJT04sIGN0eC0+cHJvdF9pbmZv
LnZlcnNpb24pOw0KPiArCWlmIChlcnIgPCAwKQ0KPiArCQlnb3RvIG5sYV9mYWlsdXJlOw0KPiAr
CWVyciA9IG5sYV9wdXRfdTE2KHNrYiwgVExTX0lORk9fQ0lQSEVSLCBjdHgtPnByb3RfaW5mby5j
aXBoZXJfdHlwZSk7DQo+ICsJaWYgKGVyciA8IDApDQo+ICsJCWdvdG8gbmxhX2ZhaWx1cmU7DQo+
ICsJbmxhX25lc3RfZW5kKHNrYiwgc3RhcnQpOw0KPiArZW5kOg0KPiArCXJldHVybiBlcnI7DQo+
ICtubGFfZmFpbHVyZToNCj4gKwlubGFfbmVzdF9jYW5jZWwoc2tiLCBzdGFydCk7DQo+ICsJZ290
byBlbmQ7DQo+ICt9DQo+ICsNCj4gK3N0YXRpYyBzaXplX3QgdGxzX2dldF9pbmZvX3NpemUoc3Ry
dWN0IHNvY2sgKnNrKQ0KPiArew0KPiArCXNpemVfdCBzaXplID0gMDsNCj4gKw0KPiArCWlmIChz
ay0+c2tfc3RhdGUgIT0gVENQX0VTVEFCTElTSEVEKQ0KPiArCQlyZXR1cm4gc2l6ZTsNCj4gKw0K
PiArCXNpemUgKz0gICBubGFfdG90YWxfc2l6ZSgwKSAvKiBVTFBfSU5GT19UTFMgKi8NCj4gKwkJ
KyBubGFfdG90YWxfc2l6ZShzaXplb2YoX191MTYpKQkvKiBUTFNfSU5GT19WRVJTSU9OICovDQo+
ICsJCSsgbmxhX3RvdGFsX3NpemUoc2l6ZW9mKF9fdTE2KSk7IC8qIFRMU19JTkZPX0NJUEhFUiAq
Lw0KPiArCXJldHVybiBzaXplOw0KPiArfQ0KDQoNClRoYW5rcywNCkJvcmlzLg0K
