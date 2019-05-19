Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CFD0C227A7
	for <lists+netdev@lfdr.de>; Sun, 19 May 2019 19:22:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727050AbfESRWa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 May 2019 13:22:30 -0400
Received: from mail-eopbgr40048.outbound.protection.outlook.com ([40.107.4.48]:56197
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726436AbfESRW3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 19 May 2019 13:22:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O8tthBnc0BUeW3TVtuUXa0uFcgwDZbbg70vXksXSE1Q=;
 b=VcFKvxsOStalHuZDAis5H/oFYlizLhmCk5CeG9rS6K6Xxu78sxVc4hMP77Mdo/CmfeGMWrvqfhTztxmsBpab5QXYzMxiOQwW+VgTjRpFQvXut7I62hRmAcWLxdEdPLHQO+I20SWHMJy+hqkprLBD+ea1rV6TX9Z0/6ByKV9IjW4=
Received: from AM6PR05MB4198.eurprd05.prod.outlook.com (52.135.161.31) by
 AM6PR05MB5460.eurprd05.prod.outlook.com (20.177.118.158) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1900.18; Sun, 19 May 2019 06:49:17 +0000
Received: from AM6PR05MB4198.eurprd05.prod.outlook.com
 ([fe80::dc15:edfa:a91f:8f09]) by AM6PR05MB4198.eurprd05.prod.outlook.com
 ([fe80::dc15:edfa:a91f:8f09%3]) with mapi id 15.20.1900.019; Sun, 19 May 2019
 06:49:17 +0000
From:   Roi Dayan <roid@mellanox.com>
To:     wenxu <wenxu@ucloud.cn>, Saeed Mahameed <saeedm@mellanox.com>,
        Gavi Teitz <gavi@mellanox.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        Jianbo Liu <jianbol@mellanox.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH] net/mlx5e: restrict the real_dev of vlan device is the
 same as uplink device
Thread-Topic: [PATCH] net/mlx5e: restrict the real_dev of vlan device is the
 same as uplink device
Thread-Index: AQHVCwH+A8Bjwu/VL0yCCf1uK8SI0KZvyNuAgABvl4CAAc91gA==
Date:   Sun, 19 May 2019 06:49:17 +0000
Message-ID: <a5ee3798-1cd8-198d-ec85-da11444770f8@mellanox.com>
References: <1557912345-14649-1-git-send-email-wenxu@ucloud.cn>
 <32affe9e97f26ff1c7b5993255a6783533fe6bff.camel@mellanox.com>
 <e22c5097-028e-2e23-b1e9-0d7098802d1f@ucloud.cn>
In-Reply-To: <e22c5097-028e-2e23-b1e9-0d7098802d1f@ucloud.cn>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [193.47.165.251]
user-agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
x-clientproxiedby: AM0PR02CA0062.eurprd02.prod.outlook.com
 (2603:10a6:208:d2::39) To AM6PR05MB4198.eurprd05.prod.outlook.com
 (2603:10a6:209:40::31)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=roid@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1b8d31a3-4d26-4933-f1c5-08d6dc261d2c
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:AM6PR05MB5460;
x-ms-traffictypediagnostic: AM6PR05MB5460:
x-microsoft-antispam-prvs: <AM6PR05MB5460F7AD2B2C42DCB551E84EB5050@AM6PR05MB5460.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 00429279BA
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(136003)(39850400004)(346002)(396003)(366004)(189003)(199004)(6636002)(99286004)(486006)(76176011)(8936002)(52116002)(229853002)(6512007)(65826007)(5660300002)(26005)(53936002)(186003)(6486002)(446003)(11346002)(476003)(6436002)(2616005)(316002)(14454004)(478600001)(4326008)(31686004)(2906002)(86362001)(64756008)(66556008)(66446008)(68736007)(66476007)(6116002)(8676002)(14444005)(386003)(6506007)(53546011)(81166006)(65806001)(71190400001)(71200400001)(25786009)(256004)(66066001)(65956001)(73956011)(31696002)(6246003)(66946007)(64126003)(3846002)(36756003)(110136005)(58126008)(7736002)(81156014)(102836004)(305945005);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR05MB5460;H:AM6PR05MB4198.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: SM8DNBPY0o7Lepitm7XC+CZ2isoHEXnwaVc4udyppjVfzSsQWzDrB3rsxrYED3duXVuqW+m8Tx8+9Gtflwv/bHGp2/bLLjZIiafYg6LRq0Tq1uS7hvUHNwJ5/FDi1mUHyafZGBM3hsOMFdrnDwMq2YdRbkGK6UFqYXHQUTrROFs8p0mBWb8hkBRn0E4RxMdZsed2O5M6rn0hnotTXNYHH0AWS0BE9K8bTi8zyjo2zdJaBPAIemYmb/lQDv+olcCZcNHV+gLpGG4N7euFp00eaQphvBc4/DFN/zSyCRX9DVuhYYsjjDVJPchhvFQJ4neB7MvACrU6w4iKelF4S1zeah9IZ/SK1BSpwFcjk2WxdEs6laLAqbAyRaQJ5rLYUSrY+PBKRbG4fsRSqcu7q9RawAS3PBKVrMYsKx4tToU6oQ4=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9254C55168C16443A74815D52166900A@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b8d31a3-4d26-4933-f1c5-08d6dc261d2c
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 May 2019 06:49:17.8395
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB5460
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDE4LzA1LzIwMTkgMDY6MTAsIHdlbnh1IHdyb3RlOg0KPiBUaGVyZSB3aWxsIGJlIG11
bHRpcGxlIHZsYW4gZGV2aWNlIHdoaWNoIG1heWJlIG5vdCBiZWxvbmcgdG8gdGhlIHVwbGluayBy
ZXAgZGV2aWNlLCBzbyB3ZW4gY2FuIGxpbWl0IGl0DQo+IA0KPiDlnKggMjAxOS81LzE4IDQ6MzAs
IFNhZWVkIE1haGFtZWVkIOWGmemBkzoNCj4+IE9uIFdlZCwgMjAxOS0wNS0xNSBhdCAxNzoyNSAr
MDgwMCwgd2VueHVAdWNsb3VkLmNuIHdyb3RlOg0KPj4+IEZyb206IHdlbnh1IDx3ZW54dUB1Y2xv
dWQuY24+DQo+Pj4NCj4+PiBXaGVuIHJlZ2lzdGVyIGluZHIgYmxvY2sgZm9yIHZsYW4gZGV2aWNl
LCBpdCBzaG91bGQgY2hlY2sgdGhlDQo+Pj4gcmVhbF9kZXYNCj4+PiBvZiB2bGFuIGRldmljZSBp
cyBzYW1lIGFzIHVwbGluayBkZXZpY2UuIE9yIGl0IHdpbGwgc2V0IG9mZmxvYWQgcnVsZQ0KPj4+
IHRvIG1seDVlIHdoaWNoIHdpbGwgbmV2ZXIgaGl0Lg0KPj4+DQo+PiBJIHdvdWxkIGltcHJvdmUg
dGhlIGNvbW1pdCBtZXNzYWdlLCBpdCBpcyBub3QgcmVhbGx5IGNsZWFyIHRvIG1lIHdoYXQNCj4+
IGlzIGdvaW5nIG9uIGhlcmUuDQo+Pg0KPj4gQW55d2F5IFJvaSBhbmQgdGVhbSwgY2FuIHlvdSBw
bGVhc2UgcHJvdmlkZSBmZWVkYmFjayAuLg0KPj4NCj4+PiBTaWduZWQtb2ZmLWJ5OiB3ZW54dSA8
d2VueHVAdWNsb3VkLmNuPg0KPj4+IC0tLQ0KPj4+ICBkcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxs
YW5veC9tbHg1L2NvcmUvZW5fcmVwLmMgfCAyICstDQo+Pj4gIDEgZmlsZSBjaGFuZ2VkLCAxIGlu
c2VydGlvbigrKSwgMSBkZWxldGlvbigtKQ0KPj4+DQo+Pj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMv
bmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lbl9yZXAuYw0KPj4+IGIvZHJpdmVycy9u
ZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VuX3JlcC5jDQo+Pj4gaW5kZXggOTFlMjRm
MS4uYTM5ZmRhYyAxMDA2NDQNCj4+PiAtLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5v
eC9tbHg1L2NvcmUvZW5fcmVwLmMNCj4+PiArKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxs
YW5veC9tbHg1L2NvcmUvZW5fcmVwLmMNCj4+PiBAQCAtNzk2LDcgKzc5Niw3IEBAIHN0YXRpYyBp
bnQgbWx4NWVfbmljX3JlcF9uZXRkZXZpY2VfZXZlbnQoc3RydWN0DQo+Pj4gbm90aWZpZXJfYmxv
Y2sgKm5iLA0KPj4+ICAJc3RydWN0IG5ldF9kZXZpY2UgKm5ldGRldiA9IG5ldGRldl9ub3RpZmll
cl9pbmZvX3RvX2RldihwdHIpOw0KPj4+ICANCj4+PiAgCWlmICghbWx4NWVfdGNfdHVuX2Rldmlj
ZV90b19vZmZsb2FkKHByaXYsIG5ldGRldikgJiYNCj4+PiAtCSAgICAhaXNfdmxhbl9kZXYobmV0
ZGV2KSkNCj4+PiArCSAgICAhKGlzX3ZsYW5fZGV2KG5ldGRldikgJiYgdmxhbl9kZXZfcmVhbF9k
ZXYobmV0ZGV2KSA9PQ0KPj4+IHJwcml2LT5uZXRkZXYpKQ0KPj4+ICAJCXJldHVybiBOT1RJRllf
T0s7DQo+Pj4gIA0KPj4+ICAJc3dpdGNoIChldmVudCkgew0KDQp0aGFua3MhDQoNCnlvdSBzaG91
bGQgYWRkIGEgZml4ZXMgbGluZQ0KRml4ZXM6IDM1YTYwNWRiMTY4YyAoIm5ldC9tbHg1ZTogT2Zm
bG9hZCBUQyBlLXN3aXRjaCBydWxlcyB3aXRoIGluZ3Jlc3MgVkxBTiBkZXZpY2UiKQ0KDQpiZXNp
ZGUgdGhhdCBhbGwgZ29vZC4NClJldmlld2VkLWJ5OiBSb2kgRGF5YW4gPHJvaWRAbWVsbGFub3gu
Y29tPg0KDQoNCg==
