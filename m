Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A51661BCF0F
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 23:45:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726893AbgD1Vot (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 17:44:49 -0400
Received: from mail-am6eur05on2077.outbound.protection.outlook.com ([40.107.22.77]:6084
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726467AbgD1Vos (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Apr 2020 17:44:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OUasmZ0IRetKl0hnH8oJv16IcvODDE0MTqqAap/J9nED5iU+aNjmYyfrpY5s8L3h53QvZuwHw+0qlQi3BnpsxjWteHJDwV0nc9ZohabsN7ZcnwkbQAsb2sVkNIuU0qBfYqyUtWzcIwBqnL8yH+Oh0bl60TKY3//g44v8Ql0VSK7JSDAPDZ+gnfgKvx/4zCbo3PlcjGomoAWJu51z7fUdsZVDkn/qk890ngQiX6HSQsYCOvcS8tuFin/EMTSO9z9xTrVo7yd5jL/E7k4/qzLOqvtRByS16LJAJLHkDv9LW5OS2UJcI8d6KS2+mvA0tq64KvIlOIaqZQg8hMGWKuvvOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MAbYNohyo9UF6oJtBwpPVFJYMHJmMnc/3bUfswkWXCs=;
 b=aSsg7Y1zBbziHEwoICRfUo6/nroysc0b7l8+gcRzYHYH2+lj30UdO8ne6MqIbJcxn6bpXYbxX5NH/hUOJdK0llehHB9EyjSyvawn2zh7fQKem4Uggap380igtH4d1k23g3YFDPluWyCkvcmjzf7GBjnI+2wCbhkUHjrQseU0mQDqhzEGrdFL4PqXJAYFpeUwmI0lp6IZCL4wxESdK1hmggjGpcaQXKYzgKXvyGV2tWwws1DjRGP2LmFeRa/5wb4mj21avhATmZ+8OG+he/lOjd2kkHGM0lFg5viT+Ffnzlvk+prxHixOy+N4H8mdY+hxr2Mc+ktCzK+V9nUH0hUBRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MAbYNohyo9UF6oJtBwpPVFJYMHJmMnc/3bUfswkWXCs=;
 b=oXbHLb52hu8WS3dSUuKBUpogqttrUyhn8HLNlrHA95Qa90JR17jn2govqC3ACLKnsqIHpweKFSg3RkoBCp1qw6iZggOazLTOiUlDyBvLfP3Ess0qUcGZ1Q8TA9+WHoRSjwPm7iDURqfCrpj/iNlGncf3YEuzo/TK11KGsnCVwWk=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB3311.eurprd05.prod.outlook.com (2603:10a6:802:1d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13; Tue, 28 Apr
 2020 21:44:44 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19%7]) with mapi id 15.20.2937.023; Tue, 28 Apr 2020
 21:44:44 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "davem@davemloft.net" <davem@davemloft.net>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "leon@kernel.org" <leon@kernel.org>
CC:     "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Leon Romanovsky <leonro@mellanox.com>,
        Moshe Shemesh <moshe@mellanox.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net/mlx5: reduce stack usage in qp_read_field
Thread-Topic: [PATCH] net/mlx5: reduce stack usage in qp_read_field
Thread-Index: AQHWHaNcHr8yhW55vEe8qclRFjsPPaiPESwA
Date:   Tue, 28 Apr 2020 21:44:44 +0000
Message-ID: <c75a430dcdf4ca2eec177cacb9d425279ce43d27.camel@mellanox.com>
References: <20200428212357.2708786-1-arnd@arndb.de>
In-Reply-To: <20200428212357.2708786-1-arnd@arndb.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.34.4 (3.34.4-1.fc31) 
authentication-results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
x-originating-ip: [73.15.39.150]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: d072951c-d5e0-424a-cbd1-08d7ebbd5d54
x-ms-traffictypediagnostic: VI1PR05MB3311:|VI1PR05MB3311:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB33110AB548EDC17E248050FDBEAC0@VI1PR05MB3311.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 0387D64A71
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(5660300002)(498600001)(64756008)(66476007)(110136005)(4326008)(186003)(66446008)(6506007)(54906003)(8936002)(66946007)(91956017)(76116006)(66556008)(86362001)(2616005)(6486002)(8676002)(36756003)(6512007)(2906002)(26005)(71200400001);DIR:OUT;SFP:1101;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HTZftcCNOado63nqgHPWAo7iSww4B9UmMJmv81IUpEAEfmE5mWzOClidXObkvtyfYGCLcU+I5nSVtkT4aB1v0MbI0v5eBXWzof2MID5vKli5Ti02e13T74wRjjetBQB5DGQ59k7t/HWtvApFq1f8+1myrzMI7Nr6uWF3gQ1pho8hPA0rAgVzULUPHsck3UsBRgaMP168f5qb+lfKjQ6n0bh9cMgNSnv61jx2/P90AKBSCGa1sASllZVjdMah2avjFWCLV+LChkPEibmiMTThOuabn+K6sRiYrU2LzagLKXzLf8/z+zuYN7q1VW5Fz3/A/sJhhdE/m5WtiNcQS2yj4ba9ZcFjGMqf6fZ1uZ7YyxlI5aoxLDVXggZB5bya891qAnXVkyNMdoyik+1Kdb5AinOSWqsxBCOE8TQE4wK06afj0etOYzb1EkPwziNqE2WB
x-ms-exchange-antispam-messagedata: C//XapDzhnkoYN0GfN9UkCNWM5rMZnEXRbgUwrbnRoDDcwTPlxoc+vkimg/lv5FAbzU+18P+2pBmOleqLhvUsTnLEBg3gI15O74+Glw01TdFjJbr+4unujvhUIiduj50UZPGKEeOwW45mn8G8eSGnXwdWMh4rygan6A47t2/S5VbLRJIruOcPL/4gumnQKmY/+0PvzrLL5XS6gsfQ8C8fgOJyIcTYrcCLRR+rSTYEesGr9S0HVZb7213RRUaBazYzOEsNisJaEB7P3O3U6mjXMqiZ40R3dRJGb+hxtI3tll1x1dHnTQbuooQnBr4tk/wuEiB73mKhTtdQWibom74WapC65w2Xeb/WpZGlt6HoTOI58ivW5Yb/7ZEqSe9nMlP4HsliGI6Y6hWfUNwZoKCtyPbzhDEeDrQDV5h2mYXlULbI1sNVwQwrbhsRcB10s5HcAZXuEgpu/Ne1rP4gRcRwAUckcbbym+DnKk9u3lYazlujP2KAlHwpuviWGgZekRJ0Naw1Riym7OgwcYUjtiN4R35jU4gaP+Z9Oi67y7sV2I9f9baRBGAOO35dm3QIH8TEJ9KXHHOEfEZSiYP0yWLP7rftnqcHBXBpd9WLO3fbEhbf7/6tDmCsj3XhO2I0jDWZSi898rPcEIbBJwydhkWF1woYuujeLeoP4cfFXxx7+yaRNO5lGAf7A4QlSqhohro7IoC2TKe5CsFkIXltJnm7JiPzxVFuvGisSOoR3Cjq3uQ+/XmpEWGtwPCetm6bNTPl9liJ5fr9PHyRf3qlYj5RfHneHfvgV833CaNA3Y1iwU=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1E14F40A9633644B83335975E4E7D8EA@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d072951c-d5e0-424a-cbd1-08d7ebbd5d54
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Apr 2020 21:44:44.2089
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: B5Jek6gwjiatqtVPOF2WjWslT/mbDhFGVUpv80ouBtcibfMR2Tsi9hPbMv8IwVvO6y0Oz8CH89xmd5ggs9B1kQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB3311
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDIwLTA0LTI4IGF0IDIzOjIzICswMjAwLCBBcm5kIEJlcmdtYW5uIHdyb3RlOg0K
PiBNb3ZpbmcgdGhlIG1seDVfaWZjX3F1ZXJ5X3FwX291dF9iaXRzIHN0cnVjdHVyZSBvbiB0aGUg
c3RhY2sgd2FzIGENCj4gYml0DQo+IGV4Y2Vzc2l2ZSBhbmQgbm93IGNhdXNlcyB0aGUgY29tcGls
ZXIgdG8gY29tcGxhaW4gb24gMzItYml0DQo+IGFyY2hpdGVjdHVyZXM6DQo+IA0KPiBkcml2ZXJz
L25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZGVidWdmcy5jOiBJbiBmdW5jdGlvbg0K
PiAncXBfcmVhZF9maWVsZCc6DQo+IGRyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUv
Y29yZS9kZWJ1Z2ZzLmM6Mjc0OjE6IGVycm9yOiB0aGUNCj4gZnJhbWUgc2l6ZSBvZiAxMTA0IGJ5
dGVzIGlzIGxhcmdlciB0aGFuIDEwMjQgYnl0ZXMgWy1XZXJyb3I9ZnJhbWUtDQo+IGxhcmdlci10
aGFuPV0NCj4gDQo+IFJldmVydCB0aGUgcHJldmlvdXMgcGF0Y2ggcGFydGlhbGx5IHRvIHVzZSBk
eW5hbWljYWxseSBhbGxvY2F0aW9uIGFzDQo+IHRoZSBjb2RlIGRpZCBiZWZvcmUuIFVuZm9ydHVu
YXRlbHkgdGhlcmUgaXMgbm8gZ29vZCBlcnJvciBoYW5kbGluZw0KPiBpbiBjYXNlIHRoZSBhbGxv
Y2F0aW9uIGZhaWxzLg0KPiANCg0KSSBkb24ndCByZWFsbHkgbWluZCB0aGlzLCBzaW5jZSB0aGlz
IGlzIG9ubHkgZm9yIGRlYnVnZnMgYW5kIDAgaXMgbm90IGENCnZhbGlkIHZhbHVlIGFueXdheS4N
Cg0KQWNrZWQtYnk6IFNhZWVkIE1haGFtZWVkIDxzYWVlZG1AbWVsbGFub3guY29tPiANCg0KdGhp
cyBzaG91bGQgZ28gdG8gbWx4NS1uZXh0LCBpIHdpbGwgbGV0IExlb24gZGVjaWRlIGFuZCBwaWNr
IHRoaXMgdXAuDQoNCj4gRml4ZXM6IDU3YTZjNWU5OTJmNSAoIm5ldC9tbHg1OiBSZXBsYWNlIGhh
bmQgd3JpdHRlbiBRUCBjb250ZXh0DQo+IHN0cnVjdCB3aXRoIGF1dG9tYXRpYyBnZXR0ZXJzIikN
Cj4gU2lnbmVkLW9mZi1ieTogQXJuZCBCZXJnbWFubiA8YXJuZEBhcm5kYi5kZT4NCj4gLS0tDQo+
ICBkcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZGVidWdmcy5jIHwgMTIg
KysrKysrKysrLS0tDQo+ICAxIGZpbGUgY2hhbmdlZCwgOSBpbnNlcnRpb25zKCspLCAzIGRlbGV0
aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94
L21seDUvY29yZS9kZWJ1Z2ZzLmMNCj4gYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9t
bHg1L2NvcmUvZGVidWdmcy5jDQo+IGluZGV4IDY0MDkwOTBiM2VjNS4uZDJkNTcyMTM1MTFiIDEw
MDY0NA0KPiAtLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZGVi
dWdmcy5jDQo+ICsrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9k
ZWJ1Z2ZzLmMNCj4gQEAgLTIwMiwxOCArMjAyLDIzIEBAIHZvaWQgbWx4NV9jcV9kZWJ1Z2ZzX2Ns
ZWFudXAoc3RydWN0DQo+IG1seDVfY29yZV9kZXYgKmRldikNCj4gIHN0YXRpYyB1NjQgcXBfcmVh
ZF9maWVsZChzdHJ1Y3QgbWx4NV9jb3JlX2RldiAqZGV2LCBzdHJ1Y3QNCj4gbWx4NV9jb3JlX3Fw
ICpxcCwNCj4gIAkJCSBpbnQgaW5kZXgsIGludCAqaXNfc3RyKQ0KPiAgew0KPiAtCXUzMiBvdXRb
TUxYNV9TVF9TWl9CWVRFUyhxdWVyeV9xcF9vdXQpXSA9IHt9Ow0KPiArCWludCBvdXRsZW4gPSBN
TFg1X1NUX1NaX0JZVEVTKHF1ZXJ5X3FwX291dCk7DQo+ICAJdTMyIGluW01MWDVfU1RfU1pfRFco
cXVlcnlfcXBfaW4pXSA9IHt9Ow0KPiAgCXU2NCBwYXJhbSA9IDA7DQo+ICsJdTMyICpvdXQ7DQo+
ICAJaW50IHN0YXRlOw0KPiAgCXUzMiAqcXBjOw0KPiAgCWludCBlcnI7DQo+ICANCj4gKwlvdXQg
PSBremFsbG9jKG91dGxlbiwgR0ZQX0tFUk5FTCk7DQo+ICsJaWYgKCFvdXQpDQo+ICsJCXJldHVy
biAwOw0KPiArDQo+ICAJTUxYNV9TRVQocXVlcnlfcXBfaW4sIGluLCBvcGNvZGUsIE1MWDVfQ01E
X09QX1FVRVJZX1FQKTsNCj4gIAlNTFg1X1NFVChxdWVyeV9xcF9pbiwgaW4sIHFwbiwgcXAtPnFw
bik7DQo+ICAJZXJyID0gbWx4NV9jbWRfZXhlY19pbm91dChkZXYsIHF1ZXJ5X3FwLCBpbiwgb3V0
KTsNCj4gIAlpZiAoZXJyKQ0KPiAtCQlyZXR1cm4gMDsNCj4gKwkJZ290byBvdXQ7DQo+ICANCj4g
IAkqaXNfc3RyID0gMDsNCj4gIA0KPiBAQCAtMjY5LDcgKzI3NCw4IEBAIHN0YXRpYyB1NjQgcXBf
cmVhZF9maWVsZChzdHJ1Y3QgbWx4NV9jb3JlX2Rldg0KPiAqZGV2LCBzdHJ1Y3QgbWx4NV9jb3Jl
X3FwICpxcCwNCj4gIAkJcGFyYW0gPSBNTFg1X0dFVChxcGMsIHFwYywgcmVtb3RlX3Fwbik7DQo+
ICAJCWJyZWFrOw0KPiAgCX0NCj4gLQ0KPiArb3V0Og0KPiArCWtmcmVlKG91dCk7DQo+ICAJcmV0
dXJuIHBhcmFtOw0KPiAgfQ0KPiAgDQo=
