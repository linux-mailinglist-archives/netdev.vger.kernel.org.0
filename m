Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6F0462176
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 17:16:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732585AbfGHPQc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 11:16:32 -0400
Received: from mail-eopbgr70075.outbound.protection.outlook.com ([40.107.7.75]:43911
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732518AbfGHPQa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Jul 2019 11:16:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=szryYw/ssBwin6LDL6+dPN58gyoZ1qWOAyBDfomEVD0=;
 b=j3UMPqQDxppkN86ThovUKWWKwvO5te4Vhpqydi5/TMQKnYGVBR77ZryM2a1FKeDKQw1yqFE5ZJ8QJszmByoCEZXCXqmu9p21xToh/Yb4jm3T9encV0GSj3f0qvkq787b9zPMkm/UHdJ2wxThvb9Z9ozXGD54lRh8J/cuWvaMnPA=
Received: from AM6PR05MB5879.eurprd05.prod.outlook.com (20.179.0.76) by
 AM6PR05MB6325.eurprd05.prod.outlook.com (20.179.5.76) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2052.17; Mon, 8 Jul 2019 15:16:26 +0000
Received: from AM6PR05MB5879.eurprd05.prod.outlook.com
 ([fe80::4923:8635:3371:e4f0]) by AM6PR05MB5879.eurprd05.prod.outlook.com
 ([fe80::4923:8635:3371:e4f0%3]) with mapi id 15.20.2052.020; Mon, 8 Jul 2019
 15:16:26 +0000
From:   Maxim Mikityanskiy <maximmi@mellanox.com>
To:     Arnd Bergmann <arnd@arndb.de>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Tariq Toukan <tariqt@mellanox.com>
CC:     Leon Romanovsky <leon@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xdp-newbies@vger.kernel.org" <xdp-newbies@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Subject: Re: [PATCH] [net-next] net/mlx5e: xsk: dynamically allocate
 mlx5e_channel_param
Thread-Topic: [PATCH] [net-next] net/mlx5e: xsk: dynamically allocate
 mlx5e_channel_param
Thread-Index: AQHVNYx/Ypx2Y7+f3k6VGsR33x4yYqbA1RmA
Date:   Mon, 8 Jul 2019 15:16:26 +0000
Message-ID: <543fa599-8ea1-dbc8-d94a-f90af2069edd@mellanox.com>
References: <20190708125554.3863901-1-arnd@arndb.de>
In-Reply-To: <20190708125554.3863901-1-arnd@arndb.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: HE1PR07CA0026.eurprd07.prod.outlook.com
 (2603:10a6:7:66::12) To AM6PR05MB5879.eurprd05.prod.outlook.com
 (2603:10a6:20b:a2::12)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=maximmi@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [95.67.35.250]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6ffa479e-41b6-4b9b-6991-08d703b73e7e
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM6PR05MB6325;
x-ms-traffictypediagnostic: AM6PR05MB6325:
x-microsoft-antispam-prvs: <AM6PR05MB63250E61C772D07AB61812DED1F60@AM6PR05MB6325.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 00922518D8
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(39860400002)(396003)(136003)(366004)(376002)(52314003)(199004)(189003)(316002)(3846002)(54906003)(110136005)(66066001)(6486002)(86362001)(305945005)(4326008)(6436002)(478600001)(6116002)(7736002)(31696002)(229853002)(486006)(25786009)(2616005)(11346002)(476003)(6512007)(2906002)(446003)(64756008)(256004)(73956011)(66556008)(66476007)(66946007)(66446008)(102836004)(68736007)(31686004)(14444005)(6246003)(5660300002)(71190400001)(8676002)(53936002)(81156014)(71200400001)(81166006)(8936002)(6636002)(52116002)(186003)(26005)(36756003)(7416002)(76176011)(14454004)(386003)(6506007)(53546011)(99286004);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR05MB6325;H:AM6PR05MB5879.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: L0jn5JMpDcbM+WJO2PmbDYudQcZtIEXeMpDWrc96peri8CxrYGXhkZtFl6RwVuzsQknISDpXp40ex4RQuW9w5o+b8jYBB4jttPsTXe0oWkHJurkOq+k2M790gqqPrViaabcNwayJTGDb11E25MLmt+hkbTPTYkr1LSma1CgPfMmMa31dCuBA4FRFnrLDG03nvZ5VK/8IQCVGw+OB+wQjnQG+XPn87OkERiwUSglsNwXug2PwUjE7IXnWjH0/1WFlay1Q5qceaaYz8o6k0h9v2Vl01ydyWgqcoBzBbTeBW7ezOq+2fizzG24W+DOHMaaEM3TQxiZoTcm43rH4WCJyGKGOl837wcUmLC5CT/Ocgyp6/3pWwHg6TEX8ELEJSmh9DUcxbxCUneNHFucJQ1QGC+IVk6u70tmmpBXOOe7BD1Q=
Content-Type: text/plain; charset="utf-8"
Content-ID: <EDBEA50B673B32448D8087847B960C7E@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ffa479e-41b6-4b9b-6991-08d703b73e7e
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jul 2019 15:16:26.0333
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: maximmi@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB6325
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMjAxOS0wNy0wOCAxNTo1NSwgQXJuZCBCZXJnbWFubiB3cm90ZToNCj4gVGhlIHN0cnVjdHVy
ZSBpcyB0b28gbGFyZ2UgdG8gcHV0IG9uIHRoZSBzdGFjaywgcmVzdWx0aW5nIGluIGENCj4gd2Fy
bmluZyBvbiAzMi1iaXQgQVJNOg0KPiANCj4gZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gv
bWx4NS9jb3JlL2VuL3hzay9zZXR1cC5jOjU5OjU6IGVycm9yOiBzdGFjayBmcmFtZSBzaXplIG9m
IDEzNDQgYnl0ZXMgaW4gZnVuY3Rpb24NCj4gICAgICAgICdtbHg1ZV9vcGVuX3hzaycgWy1XZXJy
b3IsLVdmcmFtZS1sYXJnZXItdGhhbj1dDQo+IA0KPiBVc2Uga3phbGxvYygpIGluc3RlYWQuDQo+
IA0KPiBGaXhlczogYTAzOGU5Nzk0NTQxICgibmV0L21seDVlOiBBZGQgWFNLIHplcm8tY29weSBz
dXBwb3J0IikNCj4gU2lnbmVkLW9mZi1ieTogQXJuZCBCZXJnbWFubiA8YXJuZEBhcm5kYi5kZT4N
Cj4gLS0tDQo+ICAgLi4uL21lbGxhbm94L21seDUvY29yZS9lbi94c2svc2V0dXAuYyAgICAgICAg
IHwgMjUgKysrKysrKysrKysrLS0tLS0tLQ0KPiAgIDEgZmlsZSBjaGFuZ2VkLCAxNiBpbnNlcnRp
b25zKCspLCA5IGRlbGV0aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0
aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lbi94c2svc2V0dXAuYyBiL2RyaXZlcnMvbmV0L2V0
aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lbi94c2svc2V0dXAuYw0KPiBpbmRleCBhYWZmYTZm
NjhkYzAuLmRiOWJiZWM2OGRiZiAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQv
bWVsbGFub3gvbWx4NS9jb3JlL2VuL3hzay9zZXR1cC5jDQo+ICsrKyBiL2RyaXZlcnMvbmV0L2V0
aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lbi94c2svc2V0dXAuYw0KPiBAQCAtNjAsMjQgKzYw
LDI4IEBAIGludCBtbHg1ZV9vcGVuX3hzayhzdHJ1Y3QgbWx4NWVfcHJpdiAqcHJpdiwgc3RydWN0
IG1seDVlX3BhcmFtcyAqcGFyYW1zLA0KPiAgIAkJICAgc3RydWN0IG1seDVlX3hza19wYXJhbSAq
eHNrLCBzdHJ1Y3QgeGRwX3VtZW0gKnVtZW0sDQo+ICAgCQkgICBzdHJ1Y3QgbWx4NWVfY2hhbm5l
bCAqYykNCj4gICB7DQo+IC0Jc3RydWN0IG1seDVlX2NoYW5uZWxfcGFyYW0gY3BhcmFtID0ge307
DQo+ICsJc3RydWN0IG1seDVlX2NoYW5uZWxfcGFyYW0gKmNwYXJhbTsNCj4gICAJc3RydWN0IGRp
bV9jcV9tb2RlciBpY29jcV9tb2RlciA9IHt9Ow0KPiAgIAlpbnQgZXJyOw0KPiAgIA0KPiAgIAlp
ZiAoIW1seDVlX3ZhbGlkYXRlX3hza19wYXJhbShwYXJhbXMsIHhzaywgcHJpdi0+bWRldikpDQo+
ICAgCQlyZXR1cm4gLUVJTlZBTDsNCj4gICANCj4gLQltbHg1ZV9idWlsZF94c2tfY3BhcmFtKHBy
aXYsIHBhcmFtcywgeHNrLCAmY3BhcmFtKTsNCj4gKwljcGFyYW0gPSBremFsbG9jKHNpemVvZigq
Y3BhcmFtKSwgR0ZQX0tFUk5FTCk7DQoNClNpbWlsYXIgY29kZSBpbiBtbHg1ZV9vcGVuX2NoYW5u
ZWxzIChlbl9tYWluLmMpIHVzZXMga3Z6YWxsb2MuIEFsdGhvdWdoIA0KdGhlIHN0cnVjdCBpcyBj
dXJyZW50bHkgc21hbGxlciB0aGFuIGEgcGFnZSBhbnl3YXksIGFuZCB0aGVyZSBzaG91bGQgYmUg
DQpubyBkaWZmZXJlbmNlIGluIGJlaGF2aW9yIG5vdywgSSBzdWdnZXN0IHVzaW5nIHRoZSBzYW1l
IGFsbG9jIGZ1bmN0aW9uIA0KdG8ga2VlcCBjb2RlIHVuaWZvcm0uDQoNCj4gKwlpZiAoIWNwYXJh
bSkNCj4gKwkJcmV0dXJuIC1FTk9NRU07DQo+ICAgDQo+IC0JZXJyID0gbWx4NWVfb3Blbl9jcShj
LCBwYXJhbXMtPnJ4X2NxX21vZGVyYXRpb24sICZjcGFyYW0ucnhfY3EsICZjLT54c2tycS5jcSk7
DQo+ICsJbWx4NWVfYnVpbGRfeHNrX2NwYXJhbShwcml2LCBwYXJhbXMsIHhzaywgY3BhcmFtKTsN
Cj4gKw0KPiArCWVyciA9IG1seDVlX29wZW5fY3EoYywgcGFyYW1zLT5yeF9jcV9tb2RlcmF0aW9u
LCAmY3BhcmFtLT5yeF9jcSwgJmMtPnhza3JxLmNxKTsNCj4gICAJaWYgKHVubGlrZWx5KGVycikp
DQo+IC0JCXJldHVybiBlcnI7DQo+ICsJCWdvdG8gZXJyX2tmcmVlX2NwYXJhbTsNCj4gICANCj4g
LQllcnIgPSBtbHg1ZV9vcGVuX3JxKGMsIHBhcmFtcywgJmNwYXJhbS5ycSwgeHNrLCB1bWVtLCAm
Yy0+eHNrcnEpOw0KPiArCWVyciA9IG1seDVlX29wZW5fcnEoYywgcGFyYW1zLCAmY3BhcmFtLT5y
cSwgeHNrLCB1bWVtLCAmYy0+eHNrcnEpOw0KPiAgIAlpZiAodW5saWtlbHkoZXJyKSkNCj4gICAJ
CWdvdG8gZXJyX2Nsb3NlX3J4X2NxOw0KPiAgIA0KPiAtCWVyciA9IG1seDVlX29wZW5fY3EoYywg
cGFyYW1zLT50eF9jcV9tb2RlcmF0aW9uLCAmY3BhcmFtLnR4X2NxLCAmYy0+eHNrc3EuY3EpOw0K
PiArCWVyciA9IG1seDVlX29wZW5fY3EoYywgcGFyYW1zLT50eF9jcV9tb2RlcmF0aW9uLCAmY3Bh
cmFtLT50eF9jcSwgJmMtPnhza3NxLmNxKTsNCj4gICAJaWYgKHVubGlrZWx5KGVycikpDQo+ICAg
CQlnb3RvIGVycl9jbG9zZV9ycTsNCj4gICANCj4gQEAgLTg3LDE4ICs5MSwxOCBAQCBpbnQgbWx4
NWVfb3Blbl94c2soc3RydWN0IG1seDVlX3ByaXYgKnByaXYsIHN0cnVjdCBtbHg1ZV9wYXJhbXMg
KnBhcmFtcywNCj4gICAJICogaXMgZGlzYWJsZWQgYW5kIHRoZW4gcmVlbmFibGVkLCBidXQgdGhl
IFNRIGNvbnRpbnVlcyByZWNlaXZpbmcgQ1FFcw0KPiAgIAkgKiBmcm9tIHRoZSBvbGQgVU1FTS4N
Cj4gICAJICovDQo+IC0JZXJyID0gbWx4NWVfb3Blbl94ZHBzcShjLCBwYXJhbXMsICZjcGFyYW0u
eGRwX3NxLCB1bWVtLCAmYy0+eHNrc3EsIHRydWUpOw0KPiArCWVyciA9IG1seDVlX29wZW5feGRw
c3EoYywgcGFyYW1zLCAmY3BhcmFtLT54ZHBfc3EsIHVtZW0sICZjLT54c2tzcSwgdHJ1ZSk7DQo+
ICAgCWlmICh1bmxpa2VseShlcnIpKQ0KPiAgIAkJZ290byBlcnJfY2xvc2VfdHhfY3E7DQo+ICAg
DQo+IC0JZXJyID0gbWx4NWVfb3Blbl9jcShjLCBpY29jcV9tb2RlciwgJmNwYXJhbS5pY29zcV9j
cSwgJmMtPnhza2ljb3NxLmNxKTsNCj4gKwllcnIgPSBtbHg1ZV9vcGVuX2NxKGMsIGljb2NxX21v
ZGVyLCAmY3BhcmFtLT5pY29zcV9jcSwgJmMtPnhza2ljb3NxLmNxKTsNCj4gICAJaWYgKHVubGlr
ZWx5KGVycikpDQo+ICAgCQlnb3RvIGVycl9jbG9zZV9zcTsNCj4gICANCj4gICAJLyogQ3JlYXRl
IGEgZGVkaWNhdGVkIFNRIGZvciBwb3N0aW5nIE5PUHMgd2hlbmV2ZXIgd2UgbmVlZCBhbiBJUlEg
dG8gYmUNCj4gICAJICogdHJpZ2dlcmVkIGFuZCBOQVBJIHRvIGJlIGNhbGxlZCBvbiB0aGUgY29y
cmVjdCBDUFUuDQo+ICAgCSAqLw0KPiAtCWVyciA9IG1seDVlX29wZW5faWNvc3EoYywgcGFyYW1z
LCAmY3BhcmFtLmljb3NxLCAmYy0+eHNraWNvc3EpOw0KPiArCWVyciA9IG1seDVlX29wZW5faWNv
c3EoYywgcGFyYW1zLCAmY3BhcmFtLT5pY29zcSwgJmMtPnhza2ljb3NxKTsNCj4gICAJaWYgKHVu
bGlrZWx5KGVycikpDQo+ICAgCQlnb3RvIGVycl9jbG9zZV9pY29jcTsNCj4gICANCg0KSGVyZSBp
cyBrZnJlZSBtaXNzaW5nLiBJdCdzIGEgbWVtb3J5IGxlYWsgaW4gdGhlIGdvb2QgcGF0aC4NCg0K
VGhhbmtzIQ0KDQo+IEBAIC0xMjMsNiArMTI3LDkgQEAgaW50IG1seDVlX29wZW5feHNrKHN0cnVj
dCBtbHg1ZV9wcml2ICpwcml2LCBzdHJ1Y3QgbWx4NWVfcGFyYW1zICpwYXJhbXMsDQo+ICAgZXJy
X2Nsb3NlX3J4X2NxOg0KPiAgIAltbHg1ZV9jbG9zZV9jcSgmYy0+eHNrcnEuY3EpOw0KPiAgIA0K
PiArZXJyX2tmcmVlX2NwYXJhbToNCj4gKwlrZnJlZShjcGFyYW0pOw0KPiArDQo+ICAgCXJldHVy
biBlcnI7DQo+ICAgfQ0KPiAgIA0KPiANCg0K
