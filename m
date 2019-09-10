Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 925C8AF1BF
	for <lists+netdev@lfdr.de>; Tue, 10 Sep 2019 21:13:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727849AbfIJTNM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Sep 2019 15:13:12 -0400
Received: from mail-eopbgr60050.outbound.protection.outlook.com ([40.107.6.50]:28206
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725263AbfIJTNM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Sep 2019 15:13:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BgLbLG/biZMrQi49L3UwGKG63AxJI9/qpd9yV6ZcLqqdJbBmkoO1yjgG/Z94c8Qov1dTjJlANm5+7rlPe6/wTOtwdh07+PzyQIrN7/6Wb0ceP7r0+WAiWyXwyJR5rBJQXoHv85RKcqgHDpg9xyNgWuVfH1gligriw87/qU7cn0e4nFxh4/0HJaCQTv2oGRqm/97dg9ShjJSvteQqefvYNwDJ/Q6VBihLKlHAKOC+n9CX5K/2Mg2VUb0LPd/0mQwsO9BboRmzs7ngHTDfQYXm7xV2EP+pVebVKjNPiUpNVkzAiWcQ72YmFN1pAcSJMX8XjDTXYRn8bgxvZBwvzAiHYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PHQjhAjp6Kdlr7PVyYJ9stL5uspQDuoAYEXTs1fY8lw=;
 b=SY3BqTBvFek0IQsMNE6vHVuYe3Z0Xnj8V6HU6jdQUfMKxscpXPORBmDIZTJ5l4utpCUEWwKJtWEq5+4LgXG+ysTy8p/8ho+BQSHEgW7f0cQXW/xzdWnXqwJM6ThPRBPoBYHDCx33MMReihPznzf+x39PuLYBJ6b45xOxLshbhtdBfeamzjRqh6Xb4QAds6cfioZhWkTHaefgGb55eM2d79sxg3MtNgz/StIx0zxohJ1tQw9TiPBuSxryE/dJ16Ei6rKtNfgCNpKCvFQc0cpFpCwpRkv+uUs7ciu/1V8PenHA3uaO+TNNCH530GxuaQZPXdaA32ozRybjQAKJu4ZbvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PHQjhAjp6Kdlr7PVyYJ9stL5uspQDuoAYEXTs1fY8lw=;
 b=T+NRfThNHti6QsOVVg9zPJu1h54iSBPtI3kj8CBko17XLyzrJDPSUoGf2rZyRm5riGXJY/ho1ld54/35CnY2QGFPTi0qEscfrxdLnnysIBXex/bslX1VVBWz816fl8MXvqgipP8frMoY07Rozr80y8egGxevDsLIDnBVOLQENqQ=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2472.eurprd05.prod.outlook.com (10.168.77.16) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2241.18; Tue, 10 Sep 2019 19:13:05 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::f839:378:4972:3e43]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::f839:378:4972:3e43%12]) with mapi id 15.20.2241.018; Tue, 10 Sep 2019
 19:13:04 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David.Laight@ACULAB.COM" <David.Laight@ACULAB.COM>,
        "arnd@arndb.de" <arnd@arndb.de>
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
Thread-Index: AQHVZMVcvjrXfAAg+0q1zHGyRVHFvqcjwxGAgAAK9wCAABpwgIAAraKAgAB774CAADv0AA==
Date:   Tue, 10 Sep 2019 19:13:04 +0000
Message-ID: <005fe3efd5ce73ed0179cec8d743362ef0fd4f85.camel@mellanox.com>
References: <20190906151123.1088455-1-arnd@arndb.de>
         <383db08b6001503ac45c2e12ac514208dc5a4bba.camel@mellanox.com>
         <CAK8P3a0_VhZ9hYmc6P3Qx+Z6WSHh3PVZ7JZh7Tr=R1CAKvqWmA@mail.gmail.com>
         <5abccf6452a9d4efa2a1593c0af6d41703d4f16f.camel@mellanox.com>
         <CAK8P3a3q4NqiU-OydMqU3J=gT-8eBmsiL5tPsyJb1PNgR+48hA@mail.gmail.com>
         <d50f78334e64476bad033862035c734c@AcuMS.aculab.com>
In-Reply-To: <d50f78334e64476bad033862035c734c@AcuMS.aculab.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.4 (3.32.4-1.fc30) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c878586a-67aa-4d63-4ad6-08d73622e844
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2472;
x-ms-traffictypediagnostic: DB6PR0501MB2472:|DB6PR0501MB2472:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB6PR0501MB247203337165C3F55E395378BEB60@DB6PR0501MB2472.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 01565FED4C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(136003)(366004)(346002)(376002)(39860400002)(199004)(189003)(26005)(8936002)(66066001)(11346002)(91956017)(36756003)(4326008)(7736002)(6436002)(2616005)(5660300002)(186003)(305945005)(86362001)(6486002)(99286004)(66446008)(25786009)(229853002)(6512007)(14454004)(118296001)(54906003)(110136005)(8676002)(53936002)(76116006)(81156014)(81166006)(446003)(2906002)(256004)(6246003)(102836004)(486006)(6506007)(476003)(107886003)(316002)(478600001)(58126008)(3846002)(64756008)(66556008)(66476007)(71200400001)(2501003)(6116002)(66946007)(71190400001)(14444005)(76176011);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2472;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Ml0CQ3bonegsMSxbiglGfSjBK8PZfzY2Idw1k7nT0EFJYX0OrtKQ8MlIojD64ZHNsNBL1sK5VhDOJudQYohy3Ri2521goLMc45cyUtL5sgsmyT6GhPfkiyBcmkIpSriVnMGkjY0fg13uLVw1R5ZhYdL0R4F5akG+dWZiIi8mMpY3rpCmX6qX8SYic/UVxkFsyDfWH4mF8+ADT2vhBXIa9jkTPf7IGq/Bo7t5Doo9K7lRwMcn8wNowTgY2LLMbHQxBECRYeXvY8BNmYThQvGLMIhynQyOhk5IoOCPz9kicbzEWjgpeC/J+DmZ8Nri0oK7slZuezA4+UgEGeqjHPu3k7bYmHznyFbFqUpNGfJBzrMHGac4y3sA3utLqgGzQFo59SxycMOhdg4bNiZAuNh0HfdAFhnoqhIL9DKOputZxbc=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D35C1BEC9A701C468C71D14E5CC80014@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c878586a-67aa-4d63-4ad6-08d73622e844
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Sep 2019 19:13:04.8452
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jl1fCmwuhP+ZtRfcwnlJmt2F59BcN51bNjbw5KjPp2iV7yk/jzbDIaw8z6fSucKNFncX3FpM0cUYCZUcBh0LGg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2472
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDE5LTA5LTEwIGF0IDE1OjM4ICswMDAwLCBEYXZpZCBMYWlnaHQgd3JvdGU6DQo+
IEZyb206IEFybmQgQmVyZ21hbm4NCj4gPiBTZW50OiAxMCBTZXB0ZW1iZXIgMjAxOSAwOToxNQ0K
PiAuLi4NCj4gPiA+IEkgYW0gbm90IHN1cmUgaG93IHRoaXMgd291bGQgd29yaywgc2luY2UgdGhl
IGZvcm1hdCBwYXJhbWV0ZXJzDQo+ID4gPiBjYW4NCj4gPiA+IGNoYW5nZXMgZGVwZW5kaW5nIG9u
IHRoZSBGVyBzdHJpbmcgYW5kIHRoZSBzcGVjaWZpYyB0cmFjZXMuDQo+ID4gDQo+ID4gQWgsIHNv
IHRoZSBmb3JtYXQgc3RyaW5nIGNvbWVzIGZyb20gdGhlIGZpcm13YXJlPyBJIGRpZG4ndCBsb29r
DQo+ID4gYXQgdGhlIGNvZGUgaW4gZW5vdWdoIGRldGFpbCB0byB1bmRlcnN0YW5kIHdoeSBpdCdz
IGRvbmUgbGlrZSB0aGlzLA0KPiA+IG9ubHkgZW5vdWdoIHRvIG5vdGljZSB0aGF0IGl0J3MgcmF0
aGVyIHVudXN1YWwuDQo+IA0KPiBJZiB0aGUgZm9ybWF0IHN0cmluZyBjb21lcyBmcm9tIHRoZSBm
aXJtd2FyZSB5b3UgcmVhbGx5IHNob3VsZG4ndA0KPiBwYXNzIGl0IHRvIGFueSBzdGFuZGFyZCBw
cmludGYgZnVuY3Rpb24uDQo+IFlvdSBtdXN0IGVuc3VyZSB0aGF0IGl0IGRvZXNuJ3QgY29udGFp
biBhbnkgZm9ybWF0IGVmZmVjdG9ycw0KPiB0aGF0IG1pZ2h0IGRlcmVmZXJlbmNlIHBhcmFtZXRl
cnMuDQo+IChUaGUgY29kZSBtaWdodCB0cnkgdG8gZG8gdGhhdC4pDQo+IA0KPiBHaXZlbiB0aGF0
ICdwb2ludGVyJyBmb3JtYXQgZWZmZWN0b3JzIGNhbid0IGJlIHVzZWQsIHRoZSBmaXJtd2FyZQ0K
PiBtdXN0IGFsc28gc3VwcGx5IHRoZSByZWxldmFudCBpbnRlZ2VyIG9uZXM/DQo+IFRoaXMgc2hv
dWxkIG1lYW4gdGhhdCBhbGwgdGhlIHByb2Nlc3NpbmcgaXMgZGVmZXJyYWJsZSB1bnRpbCB0aGUN
Cj4gdHJhY2UgcmVjb3JkIGlzIHJlYWQuDQo+IA0KDQpQb2ludCB0YWtlbiwgaSB3aWxsIGRpc2N1
c3MgdGhpcyB3aXRoIHRoZSB0ZWFtIG5leHQgd2Vlaywgc2luY2UgaSBhbQ0KdHJhdmVsaW5nIHRo
aXMgd2Vlay4gYW5kIHdlIHdpbGwgcHJvdmlkZSBhIHByb3BlciBzb2x1dGlvbi4gZm9yIG5vdywN
Cm9mZiB0aGUgdG9wIG9mIG15IGhlYWQsIEZXIHN0cmluZ3MgYW5kIHBhcmFtZXRlcnMgYXJlIHdl
bGwgZGVmaW5lZCBhbmQNCnZlcnkgc2ltcGxlLCBtYW55IG9mIHRoZSBwcm9ibGVtcyBoZXJlIGRv
IG5vdCBhcHBseSwgYnV0IHdpbGwgdmVyaWZ5Lg0KDQo+ICdub2lubGluZScganVzdCBwYXBlcnMg
b3ZlciB0aGUgY3JhY2tzLg0KPiBFc3BlY2lhbGx5IHNpbmNlIHZhc3ByaW50ZigpIGlzIGxpa2Vs
eSB0byB1c2UgYSBsb3Qgb2Ygc3RhY2suDQoNClJpZ2h0IGkgYWxzbyB0ZW5kIHRvIGFncmVlIHdp
dGggbm9pbmxpbmUgYXMgYSB0ZW1wb3Jhcnkgc29sdXRpb24gdW50aWwNCndlIGFkZHJlc3MgYWxs
IHRoZSBwb2ludHMgcHJvdmlkZWQgaGVyZS4NCg0KPiANCj4gCURhdmlkDQo+IA0KPiAtDQo+IFJl
Z2lzdGVyZWQgQWRkcmVzcyBMYWtlc2lkZSwgQnJhbWxleSBSb2FkLCBNb3VudCBGYXJtLCBNaWx0
b24gS2V5bmVzLA0KPiBNSzEgMVBULCBVSw0KPiBSZWdpc3RyYXRpb24gTm86IDEzOTczODYgKFdh
bGVzKQ0K
