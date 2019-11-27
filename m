Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5632510AB4A
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 08:47:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726576AbfK0Hrp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Nov 2019 02:47:45 -0500
Received: from mail-eopbgr150089.outbound.protection.outlook.com ([40.107.15.89]:7585
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726546AbfK0Hro (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Nov 2019 02:47:44 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Koj1a3SfTvrlHNEP2VYDWz89MY45L2jvarmm1AdDcdc9LqPBy1blDr4m6Fdou986YphOCxevXX+bCu8rjNHmNkgaTBXpcp4IJ3Q2lsCRyRgVZSpHe0MiznO5xdnReAJMGm2SRwuustdLNZs7ryh8XmxUoFVYcL8FWfsa0d4RIJt+/mXRGnaEcrMLMN8PtPbYpN+teqBCu5F+IdhdznznSiscJt7QfK1Mp13USsgwDnSTAchXEg+VVGcR3laVNk5rZ04dgieQtNVt4+TS28qg4OCbVH/vUiGDuM/lgdAvpwNvrkU3JM2qfqQrfp9ZXASQBj4FQ0bY75TOlIZwYRSgWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=12LY8+8X8DKrBzh9EdTqenKGPCieb0AE4KVhD4RbqF0=;
 b=aaIJsd7/epls4i813+mJEB2M9FtGzLNJMqpM3Hza/0XMqXAI49uMl2Z3f2N8SKw99Qk2iNFBVHAU1VvJ9TvWvzS7CXX2mQs8jiWnaeHbakFBADdvFHz6knjFonQclLclSiDGeRKZbrosEdshNpRSGRK6U/RcTiBW/kw2gJ7dW+iD/HZvjZmwGxWUD7u4w+meUJXRWGBa2pheK4iP6Yk2i/QH8G7BEhrJh/9pfKdiG3l7UpeFS6Ap7fJ/3VsIILytRM1nRyEBVxEe16uY/5emsSTRNZmy1PKWizAIFAmr9k92vMtK/sJWB/Of65F2UmnAgcSNAxA2NZivF8nPW7FiMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=12LY8+8X8DKrBzh9EdTqenKGPCieb0AE4KVhD4RbqF0=;
 b=ZiZPP3A/shaO1I17yJvQDKc9E4qmUma95XAqO+LYfw3RwvJW9TF21hgRR/yL9bZTEJ7yui3tCZjnuvo5igpXiQqmD0VhWipnom6BWPQsu0lxueBKPFHCWpsP7Gr2BJPYtX7AiRTn0TIxZy9XvkCxnrofqLuZmKezkZz03H7TSU0=
Received: from AM4PR05MB3411.eurprd05.prod.outlook.com (10.171.190.30) by
 AM4PR05MB3122.eurprd05.prod.outlook.com (10.170.125.148) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2474.22; Wed, 27 Nov 2019 07:47:40 +0000
Received: from AM4PR05MB3411.eurprd05.prod.outlook.com
 ([fe80::2cc0:1303:718d:2e9c]) by AM4PR05MB3411.eurprd05.prod.outlook.com
 ([fe80::2cc0:1303:718d:2e9c%7]) with mapi id 15.20.2474.023; Wed, 27 Nov 2019
 07:47:40 +0000
From:   Paul Blakey <paulb@mellanox.com>
To:     Brian Vazquez <brianvv@google.com>,
        Brian Vazquez <brianvv.kernel@gmail.com>,
        David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>
CC:     Mahesh Bandewar <maheshb@google.com>,
        Maciej Zenczykowski <maze@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH iproute2] tc: fix warning in tc/m_ct.c
Thread-Topic: [PATCH iproute2] tc: fix warning in tc/m_ct.c
Thread-Index: AQHVpOJRx2LHpWDeGkG6u1LY4y51K6eepBkA
Date:   Wed, 27 Nov 2019 07:47:40 +0000
Message-ID: <fea0a7a2-7eaf-4f96-6668-e7d16ab747cf@mellanox.com>
References: <20191127051934.158900-1-brianvv@google.com>
In-Reply-To: <20191127051934.158900-1-brianvv@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM0PR05CA0028.eurprd05.prod.outlook.com
 (2603:10a6:208:55::41) To AM4PR05MB3411.eurprd05.prod.outlook.com
 (2603:10a6:205:b::30)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=paulb@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [193.47.165.251]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 0a229de6-a897-467c-5718-08d7730e1407
x-ms-traffictypediagnostic: AM4PR05MB3122:
x-microsoft-antispam-prvs: <AM4PR05MB3122D5B54DAA5707F64992D6CF440@AM4PR05MB3122.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:311;
x-forefront-prvs: 023495660C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(346002)(366004)(136003)(396003)(39860400002)(199004)(189003)(2616005)(66066001)(386003)(53546011)(14444005)(256004)(11346002)(99286004)(446003)(6486002)(6506007)(2906002)(76176011)(110136005)(52116002)(478600001)(6116002)(31686004)(305945005)(7736002)(4744005)(5660300002)(14454004)(8936002)(6246003)(6436002)(71190400001)(3846002)(8676002)(66446008)(71200400001)(31696002)(4326008)(316002)(229853002)(6512007)(186003)(54906003)(36756003)(25786009)(66556008)(66946007)(81156014)(66476007)(64756008)(102836004)(86362001)(81166006)(26005);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR05MB3122;H:AM4PR05MB3411.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: AclMLn4YKV5AEAeSNhQ/LVpkxX8MDI1PJugEOwLm/xxBooLyr27X4sF0G5N5AjWa21KO4hXfBh+FWgiRSH3S98P6RfsPiL7drzakeMfiWxH6TSzPt/0Dah5rixwGj4Zg3ffnwnP3Ha41XIrwffhvQ8UuhTZZsFQPuqpA9FtK6NaPKJDSNFvqdFf3zyNpR12re2vTxtggM5l9PKEfwWQhopybDuwq6dgSOd3rRe3cF6wRobBoIxOS38XxfhdBiMclhIXX/lPlfke2hQa8pkhkmG1+7YiLgTuwoFlO4hTXOxuJ7/A1s3uQ66kdoY3uywQu8H9jfX/lL8Ad8BE9EwZIXRtvXJtcqibHh/Ey/pljZ+b7SWJHdMV1Zz/uFoEierJS+z3SqRZ3sM+gjAmZw00HZamnLGGWwXRUbcp7MoIFsvZ/X39XcnOcWdWFrp1tUN/e
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <7CA9C9E850A15240BB015E27C5AB5C95@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a229de6-a897-467c-5718-08d7730e1407
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Nov 2019 07:47:40.1384
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RpbSmr8fGWMLFLqK1UGhTnqbTu2lsBhEywqbI1GsSCiTyHPl7fbKY8KMvegjdzOCOsYmirNdjtEdR/Y0XhVCTA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR05MB3122
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMTEvMjcvMjAxOSA3OjE5IEFNLCBCcmlhbiBWYXpxdWV6IHdyb3RlOg0KDQo+IFdhcm5pbmcg
d2FzOg0KPiBtX2N0LmM6MzcwOjEzOiB3YXJuaW5nOiB2YXJpYWJsZSAnbmF0JyBpcyB1c2VkIHVu
aW5pdGlhbGl6ZWQgd2hlbmV2ZXINCj4gJ2lmJyBjb25kaXRpb24gaXMgZmFsc2UNCj4NCj4gQ2M6
IFBhdWwgQmxha2V5IDxwYXVsYkBtZWxsYW5veC5jb20+DQo+IEZpeGVzOiBjOGE0OTQzMTRjNDAg
KCJ0YzogSW50cm9kdWNlIHRjIGN0IGFjdGlvbiIpDQo+IFNpZ25lZC1vZmYtYnk6IEJyaWFuIFZh
enF1ZXogPGJyaWFudnZAZ29vZ2xlLmNvbT4NCj4gLS0tDQo+ICAgdGMvbV9jdC5jIHwgMiArLQ0K
PiAgIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwgMSBkZWxldGlvbigtKQ0KPg0KPiBk
aWZmIC0tZ2l0IGEvdGMvbV9jdC5jIGIvdGMvbV9jdC5jDQo+IGluZGV4IDhkZjJmNjEwLi40NWZh
NGE4YyAxMDA2NDQNCj4gLS0tIGEvdGMvbV9jdC5jDQo+ICsrKyBiL3RjL21fY3QuYw0KPiBAQCAt
MzU5LDcgKzM1OSw3IEBAIHN0YXRpYyB2b2lkIGN0X3ByaW50X25hdChpbnQgY3RfYWN0aW9uLCBz
dHJ1Y3QgcnRhdHRyICoqdGIpDQo+ICAgew0KPiAgIAlzaXplX3QgZG9uZSA9IDA7DQo+ICAgCWNo
YXIgb3V0WzI1Nl0gPSAiIjsNCj4gLQlib29sIG5hdDsNCj4gKwlib29sIG5hdCA9IGZhbHNlOw0K
PiAgIA0KPiAgIAlpZiAoIShjdF9hY3Rpb24gJiBUQ0FfQ1RfQUNUX05BVCkpDQo+ICAgCQlyZXR1
cm47DQoNClllcyBuYXQgc2hvdWxkIGJlIGZhbHNlIGhlcmUuDQoNCkxvb2tzIGdvb2QgdG8gbWUu
DQoNClRoYW5rcy4NCg0K
