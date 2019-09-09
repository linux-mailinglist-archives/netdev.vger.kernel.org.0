Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD820AE069
	for <lists+netdev@lfdr.de>; Mon,  9 Sep 2019 23:53:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406103AbfIIVxd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Sep 2019 17:53:33 -0400
Received: from mail-eopbgr50057.outbound.protection.outlook.com ([40.107.5.57]:34181
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727104AbfIIVxd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Sep 2019 17:53:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T6TMnQqIrjK5berJLMNekho6ZQLDetqgsKsdVNeIGjPKxqskgPkJF4sEmf6VJuR49Bvw5xMPcJ2FJOibgNv7XVXTB3hsGMubbDiRNhIcpkOxEDXb4DS4C6W1GP8tE8jkUltJoJFLgIhtZgRuokLWxqhspboBFAVI4SYumfuOd1rQenleeMdQFcKeb4Uhloq1wRPW3Rwg3yOHe+T5YTIXOPyGuVUg0fOWq1Vyz52ZaGSvqoufUjE+S4SdBkHRUGQT92IG5b+/ORDkNA1TolS6M/T5umVEgpWCTLjLMz2nly9gwYyUCMy+5S10S2DQ5KhHQdfemPvR+Y4LsHlq5v1qDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SUbxGIGiCHq1jgvI5bH2HxkOs1v6iB6JgV+RtnaIziE=;
 b=a0gwsIdXyoVQSH0JURGLNSWlcI1ceqOvS6/UoAeE/X/mKvx7FXTiR0njhdm0xK8LOm04CYClgydhZeYDQlPi/BXOTaAmz4OGSRsITWkhuSgvgx0oJWtsKvjzGnB1wKh/9o5ocM7sCdcj2WSrZYVw0wuhKeZ3Y8kq/JrnGJDBCFYBAzXeQwn5rmyYIHbl/w7vPICtFLfKAV4kKr6kryAuWJ1caAVI3hRLsMJBypPrL27RJOyqIppp3Hou2YFn1URIdWGN7GUDyu2BGQCFwTQBMxJpSRVBDSN/Bek+t6tH92epRob5os8XqV0n8n5YO8yiYP/YjWmEuyxTycCND8G/xg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SUbxGIGiCHq1jgvI5bH2HxkOs1v6iB6JgV+RtnaIziE=;
 b=pNl6fZr7WgQMm1NxbmJMRUyWCCsuQB2il18HALyIGQBzQDprl/06nUxiB+d+o9TF/orXVRfFxh7WeBy04e9qB4kjkkY5CSHslyVvxl7DEdcGSv1NDW280HJnb5TzdMKoHPWErC408i5xyC0rdaMkrB6yVp8TlVzvmFpWOKQ5wfA=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2357.eurprd05.prod.outlook.com (10.168.56.24) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2241.18; Mon, 9 Sep 2019 21:53:27 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::f839:378:4972:3e43]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::f839:378:4972:3e43%12]) with mapi id 15.20.2241.018; Mon, 9 Sep 2019
 21:53:27 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "arnd@arndb.de" <arnd@arndb.de>
CC:     "cai@lca.pw" <cai@lca.pw>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Moshe Shemesh <moshe@mellanox.com>,
        Feras Daoud <ferasda@mellanox.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "leon@kernel.org" <leon@kernel.org>,
        Erez Shitrit <erezsh@mellanox.com>
Subject: Re: [PATCH] net/mlx5: reduce stack usage in FW tracer
Thread-Topic: [PATCH] net/mlx5: reduce stack usage in FW tracer
Thread-Index: AQHVZMVcvjrXfAAg+0q1zHGyRVHFvqcjwxGAgAAK9wCAABpwgA==
Date:   Mon, 9 Sep 2019 21:53:27 +0000
Message-ID: <5abccf6452a9d4efa2a1593c0af6d41703d4f16f.camel@mellanox.com>
References: <20190906151123.1088455-1-arnd@arndb.de>
         <383db08b6001503ac45c2e12ac514208dc5a4bba.camel@mellanox.com>
         <CAK8P3a0_VhZ9hYmc6P3Qx+Z6WSHh3PVZ7JZh7Tr=R1CAKvqWmA@mail.gmail.com>
In-Reply-To: <CAK8P3a0_VhZ9hYmc6P3Qx+Z6WSHh3PVZ7JZh7Tr=R1CAKvqWmA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.4 (3.32.4-1.fc30) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b1e7f4e1-8594-4b11-f676-08d73570252a
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2357;
x-ms-traffictypediagnostic: DB6PR0501MB2357:|DB6PR0501MB2357:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB6PR0501MB2357E2629D7B1EE39784FBD6BEB70@DB6PR0501MB2357.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 01559F388D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(39860400002)(396003)(376002)(366004)(136003)(189003)(199004)(51914003)(36756003)(8936002)(476003)(6506007)(2616005)(186003)(229853002)(54906003)(3846002)(2501003)(91956017)(2906002)(6436002)(58126008)(76176011)(316002)(11346002)(26005)(53546011)(76116006)(99286004)(118296001)(2351001)(102836004)(486006)(14454004)(86362001)(256004)(66556008)(6916009)(66946007)(14444005)(66476007)(64756008)(66446008)(478600001)(6116002)(446003)(5660300002)(8676002)(81156014)(81166006)(1730700003)(6246003)(107886003)(4326008)(6486002)(53936002)(25786009)(71200400001)(71190400001)(66066001)(305945005)(6512007)(7736002)(5640700003);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2357;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Q9lOPOd3ir+wwFozuHe9nV/0WpgCxy+SN8RWvGlGKAAcPExQ8103SMB/M9d3j+eGiva7zb+xl++33EFes/OKqqvqoMm6YhbEWWDA6kxoA+LAoPZSwTLSZMgqIb7QRAe8SERxFTcL7gq3DqzYib4QvkW4MIpfH9D7rkwxES0Adam/CU1cDwhKotvvaquzlJ2PubhYSiCy/26cM8P27TlRe1LH1BEolXWnVrNMaiZNUD+CmLpNRH4Q6O9uL1E+Jarhom/NtjGA8Jiff7zTWYz84C3MyiSqRAnK9w27Ldi8pAzsrwIzX/4FnoFx7+Pfg6Jea3AfatabEf3nxlfud7zJdMHjYcXg1267NX0oC51NvzkxzHsCffW7ZisLuvtyh1Czsbn/mtpJNKZK+qWawDO43Vclo3htiyrtHvY6p2TQQcU=
Content-Type: text/plain; charset="utf-8"
Content-ID: <EE8BE32F32CE6A4397534D20DA5C2D6C@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b1e7f4e1-8594-4b11-f676-08d73570252a
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Sep 2019 21:53:27.1176
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RBLvMqTOjaD8YAZyjQbL4UvOQJIU79K03go2TOwGJT7y7CaK2ZnbBQG2YMFOxBMQWZdhqy8c+3zyuQXdBfjOEw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2357
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCAyMDE5LTA5LTA5IGF0IDIyOjE4ICswMjAwLCBBcm5kIEJlcmdtYW5uIHdyb3RlOg0K
PiBPbiBNb24sIFNlcCA5LCAyMDE5IGF0IDk6MzkgUE0gU2FlZWQgTWFoYW1lZWQgPHNhZWVkbUBt
ZWxsYW5veC5jb20+DQo+IHdyb3RlOg0KPiA+IE9uIEZyaSwgMjAxOS0wOS0wNiBhdCAxNzoxMSAr
MDIwMCwgQXJuZCBCZXJnbWFubiB3cm90ZToNCj4gPiA+IC0tLSBhL2RyaXZlcnMvbmV0L2V0aGVy
bmV0L21lbGxhbm94L21seDUvY29yZS9kaWFnL2Z3X3RyYWNlci5jDQo+ID4gPiArKysgYi9kcml2
ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZGlhZy9md190cmFjZXIuYw0KPiA+
ID4gQEAgLTU1NywxNiArNTU3LDE2IEBAIHN0YXRpYyB2b2lkIG1seDVfdHJhY2VyX3ByaW50X3Ry
YWNlKHN0cnVjdA0KPiA+ID4gdHJhY2VyX3N0cmluZ19mb3JtYXQgKnN0cl9mcm10LA0KPiA+ID4g
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHN0cnVjdCBtbHg1X2NvcmVfZGV2ICpk
ZXYsDQo+ID4gPiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgdTY0IHRyYWNlX3Rp
bWVzdGFtcCkNCj4gPiA+ICB7DQo+ID4gPiAtICAgICBjaGFyICAgIHRtcFs1MTJdOw0KPiA+ID4g
LQ0KPiA+IA0KPiA+IEhpIEFybmQsIHRoYW5rcyBmb3IgdGhlIHBhdGNoLA0KPiA+IHRoaXMgZnVu
Y3Rpb24gaXMgdmVyeSBwZXJmb21hbmNlIGNyaXRpY2FsIHdoZW4gZncgdHJhY2VzIGFyZQ0KPiA+
IGFjdGl2YXRlZA0KPiA+IHRvIHB1bGwgc29tZSBmdyBjb250ZW50IG9uIGVycm9yIHNpdHVhdGlv
bnMsIHVzaW5nIGttYWxsb2MgaGVyZQ0KPiA+IG1pZ2h0DQo+ID4gYmVjb21lIGEgcHJvYmxlbSBh
bmQgc3RhbGwgdGhlIHN5c3RlbSBmdXJ0aGVyIG1vcmUgaWYgdGhlIHByb2JsZW0NCj4gPiB3YXMN
Cj4gPiBpbml0aWFsbHkgZHVlIHRvIGxhY2sgb2YgbWVtb3J5Lg0KPiA+IA0KPiA+IHNpbmNlIHRo
aXMgZnVuY3Rpb24gb25seSBuZWVkcyA1MTIgYnl0ZXMgbWF5YmUgd2Ugc2hvdWxkIG1hcmsgaXQg
YXMNCj4gPiBub2lubGluZSB0byBhdm9pZCBhbnkgZXh0cmEgc3RhY2sgdXNhZ2VzIG9uIHRoZSBj
YWxsZXIgZnVuY3Rpb24NCj4gPiBtbHg1X2Z3X3RyYWNlcl9oYW5kbGVfdHJhY2VzID8NCj4gDQo+
IFRoYXQgd291bGQgc2h1dCB1cCB0aGUgd2FybmluZywgYnV0IGRvZXNuJ3Qgc291bmQgcmlnaHQg
ZWl0aGVyLg0KPiANCj4gSWYgaXQncyBwZXJmb3JtYW5jZSBjcml0aWNhbCBpbmRlZWQsIG1heWJl
IHRoZSBiZXN0IHNvbHV0aW9uIHdvdWxkDQo+IGJlIHRvIGFsc28gYXZvaWQgdGhlIHNucHJpbnRm
KCksIGFzIHRoYXQgaXMgYWxzbyBhIHJhdGhlciBoZWF2eXdlaWdodA0KPiBmdW5jdGlvbj8NCj4g
DQo+IEkgY291bGQgbm90IGZpbmQgYW4gZWFzeSBzb2x1dGlvbiBmb3IgdGhpcywgYnV0IEkgZGlk
IG5vdGljZSB0aGUNCj4gdW51c3VhbCB3YXkNCj4gdGhpcyBkZWFscyB3aXRoIGEgdmFyaWFibGUg
Zm9ybWF0IHN0cmluZyBwYXNzZWQgaW50bw0KPiBtbHg1X3RyYWNlcl9wcmludF90cmFjZQ0KPiBh
bG9uZyB3aXRoIGEgc2V0IG9mIHBhcmFtZXRlcnMsIHdoaWNoIG9wZW5zIHVwIGEgc2V0IG9mIHBv
c3NpYmxlDQo+IGZvcm1hdCBzdHJpbmcgdnVsbmVyYWJpbGl0aWVzIGFzIHdlbGwgYXMgbWFraW5n
DQo+IG1seDVfdHJhY2VyX3ByaW50X3RyYWNlKCkNCj4gYSBiaXQgZXhwZW5zaXZlLiBZb3UgYWxz
byB0YWtlIGEgbXV0ZXggYW5kIGZyZWUgbWVtb3J5IGluIHRoZXJlLA0KPiB3aGljaCBvYnZpb3Vz
bHkgdGhlbiBhbHNvIGdvdCBhbGxvY2F0ZWQgaW4gdGhlIGZhc3QgcGF0aC4NCj4gDQo+IFRvIGRv
IHRoaXMgcmlnaHQsIGEgYmV0dGVyIGFwcHJvYWNoIG1heSBiZSB0byBqdXN0IHJlbHkgb24gZnRy
YWNlLA0KPiBzdG9yaW5nDQo+IHRoZSAocG9pbnRlciB0byB0aGUpIGZvcm1hdCBzdHJpbmcgYW5k
IHRoZSBhcmd1bWVudHMgaW4gdGhlIGJ1ZmZlcg0KPiB3aXRob3V0DQo+IGNyZWF0aW5nIGEgc3Ry
aW5nLiBXb3VsZCB0aGF0IGJlIGFuIG9wdGlvbiBoZXJlPw0KDQpJIGFtIG5vdCBzdXJlIGhvdyB0
aGlzIHdvdWxkIHdvcmssIHNpbmNlIHRoZSBmb3JtYXQgcGFyYW1ldGVycyBjYW4NCmNoYW5nZXMg
ZGVwZW5kaW5nIG9uIHRoZSBGVyBzdHJpbmcgYW5kIHRoZSBzcGVjaWZpYyB0cmFjZXMuDQoNCj4g
DQo+IEEgbW9yZSBtaW5pbWFsIGFwcHJvYWNoIG1pZ2h0IGJlIHRvIG1vdmUgd2hhdCBpcyBub3cg
dGhlIG9uLXN0YWNrDQo+IGJ1ZmZlciBpbnRvIHRoZSBtbHg1X2Z3X3RyYWNlciBmdW5jdGlvbi4g
SSBzZWUgdGhhdCB5b3UgYWxyZWFkeSBzdG9yZQ0KPiBhIGNvcHkgb2YgdGhlIHN0cmluZyBpbiB0
aGVyZSBmcm9tIG1seDVfZndfdHJhY2VyX3NhdmVfdHJhY2UoKSwNCj4gd2hpY2ggY29udmVuaWVu
dGx5IGFsc28gaG9sZHMgYSBtdXRleCBhbHJlYWR5IHRoYXQgcHJvdGVjdHMNCj4gaXQgZnJvbSBj
b25jdXJyZW50IGFjY2Vzcy4NCj4gDQoNClRoaXMgc291bmRzIHBsYXVzaWJsZS4NCg0KU28gZm9y
IG5vdyBsZXQncyBkbyB0aGlzIG9yIHRoZSBub2lubGluZSBhcHByb2FjaCwgUGxlYXNlIGxldCBt
ZSBrbm93DQp3aGljaCBvbmUgZG8geW91IHByZWZlciwgaWYgaXQgaXMgdGhlIG11dGV4IHByb3Rl
Y3RlZCBidWZmZXIsIGkgY2FuIGRvDQppdCBteXNlbGYuDQoNCkkgd2lsbCBvcGVuIGFuIGludGVy
bmFsIHRhc2sgYW5kIGRpc2N1c3Npb24gdGhlbiBhZGRyZXNzIHlvdXIgdmFsdWFibGUNCnBvaW50
cyBpbiBhIGZ1dHVyZSBzdWJtaXNzaW9uLCBzaW5jZSB3ZSBhbHJlYWR5IGluIHJjOCBJIGRvbid0
IHdhbnQgdG8NCnRha2UgdGhlIHJpc2sgbm93Lg0KDQpUaGFua3MgZm9yIHlvdXIgZmVlZGJhY2sg
IQ0KU2FlZWQuDQoNCj4gICAgICAgIEFybmQNCg==
