Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05D91321BB
	for <lists+netdev@lfdr.de>; Sun,  2 Jun 2019 06:23:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725937AbfFBEWi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Jun 2019 00:22:38 -0400
Received: from mail-eopbgr30067.outbound.protection.outlook.com ([40.107.3.67]:1157
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725857AbfFBEWi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 2 Jun 2019 00:22:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yVXpQNqinkG7/T89D61UYnEhZDxO2DU9MGjlt5jH3n4=;
 b=jSeQa312wdaPJSSwYwzfNg2PGAlRxbD+prrIbC3KSy4v0ehzKZQ4TJyPHFBQKIPVA7iXiuJZhFotTjBevgRXNGrvWYIz4/wvM7IyeT7FpzL6dH2nseQRqzHs/UPTbd6l3EyMfxKozx3gF/U3qxMAoJXwlf06bwppI7NgeYpswS8=
Received: from DB8PR05MB5897.eurprd05.prod.outlook.com (20.179.9.78) by
 DB8PR05MB6604.eurprd05.prod.outlook.com (20.179.11.161) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1943.22; Sun, 2 Jun 2019 04:22:33 +0000
Received: from DB8PR05MB5897.eurprd05.prod.outlook.com
 ([fe80::3d8e:cfe5:abc9:8166]) by DB8PR05MB5897.eurprd05.prod.outlook.com
 ([fe80::3d8e:cfe5:abc9:8166%5]) with mapi id 15.20.1943.018; Sun, 2 Jun 2019
 04:22:33 +0000
From:   Eli Britstein <elibr@mellanox.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>,
        Davide Caratti <dcaratti@redhat.com>
CC:     Eric Dumazet <eric.dumazet@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        "David S . Miller" <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Shuang Li <shuali@redhat.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: Re: [PATCH net v3 1/3] net/sched: act_csum: pull all VLAN headers
 before checksumming
Thread-Topic: [PATCH net v3 1/3] net/sched: act_csum: pull all VLAN headers
 before checksumming
Thread-Index: AQHVF9YCoxt6kd8zD0+WKN59vqbz06aFkHaAgAA4nwCAAA2sAIAB7yeA
Date:   Sun, 2 Jun 2019 04:22:33 +0000
Message-ID: <b1c6251c-16ab-57a8-222d-1f1f7021a0d5@mellanox.com>
References: <cover.1559322531.git.dcaratti@redhat.com>
 <a773fd1d70707d03861be674f7692a0148f6bb40.1559322531.git.dcaratti@redhat.com>
 <CAM_iQpW68XR3Y6gyb0zyd3qooCwPHBM1Fm+THcS=migSNsHMzA@mail.gmail.com>
 <e2e02404af5aea5663877db8f9d2e23501e818b8.camel@redhat.com>
 <CAM_iQpURD5Yvr1BwfbTBDbbJdATGSK5PWD7jfP4=NGdgTGnnJw@mail.gmail.com>
In-Reply-To: <CAM_iQpURD5Yvr1BwfbTBDbbJdATGSK5PWD7jfP4=NGdgTGnnJw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM6PR08CA0024.eurprd08.prod.outlook.com
 (2603:10a6:20b:b2::36) To DB8PR05MB5897.eurprd05.prod.outlook.com
 (2603:10a6:10:a5::14)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=elibr@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [46.120.174.225]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b115d2b7-c532-47ab-d74e-08d6e711eee2
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB8PR05MB6604;
x-ms-traffictypediagnostic: DB8PR05MB6604:
x-microsoft-antispam-prvs: <DB8PR05MB66046D081092CEA275DF3BC6D51B0@DB8PR05MB6604.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 005671E15D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(136003)(376002)(346002)(396003)(366004)(199004)(189003)(86362001)(53546011)(386003)(6506007)(31696002)(25786009)(316002)(53936002)(31686004)(229853002)(256004)(66066001)(66476007)(66446008)(64756008)(26005)(3846002)(66556008)(73956011)(14454004)(66946007)(478600001)(7736002)(99286004)(6116002)(186003)(305945005)(5660300002)(81156014)(486006)(81166006)(8936002)(11346002)(2616005)(446003)(476003)(68736007)(2906002)(54906003)(71190400001)(71200400001)(6436002)(102836004)(6246003)(76176011)(6486002)(6512007)(8676002)(4326008)(36756003)(110136005)(52116002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB8PR05MB6604;H:DB8PR05MB5897.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Pp3xSvaZJfu3EufwwBwMkqcPkhIZPAlExl61NprWg7Lu4yWWElBuN6KaC0QHQLs9mrvlcXmrocAGH/hSH4uNifMVkOv9FlCG+XQdhzYCANUVWWbiubGUo1GKDrLT71YAc7tEosY9QyP1fHoKlXnYfWlartBAV4ecQTWA735g6QJbG4KWJfSyDPgJOswrYHL68Kc2zTNPG3ByQAZW/EpQ0nLhQkxjIe6lr1Yp6Y7MS6D62ajE+Et3oSFuefdS8BZrZGhRJ3MWX9ooL4ld7yc6Ve9gULBkMhILjJBmkqqlhS+KYlKMlEpgnVWtEB02QsDL1JknhCckCJI1KKHm8EaehqKzPG409thsfiyusexfiRr9GRSgSnjY9i10y9LauVsrL8Zwq6nBofY44xx7ELB78+f5KsWmOeZoxj8hmGmPicc=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C9F9BCBB0DC96942A2E286E8A3206912@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b115d2b7-c532-47ab-d74e-08d6e711eee2
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Jun 2019 04:22:33.1445
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: elibr@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR05MB6604
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpPbiA2LzEvMjAxOSAxOjUwIEFNLCBDb25nIFdhbmcgd3JvdGU6DQo+IE9uIEZyaSwgTWF5IDMx
LCAyMDE5IGF0IDM6MDEgUE0gRGF2aWRlIENhcmF0dGkgPGRjYXJhdHRpQHJlZGhhdC5jb20+IHdy
b3RlOg0KPj4gUGxlYXNlIG5vdGU6IHRoaXMgbG9vcCB3YXMgaGVyZSBhbHNvIGJlZm9yZSB0aGlz
IHBhdGNoICh0aGUgJ2dvdG8gYWdhaW47Jw0KPj4gbGluZSBpcyBvbmx5IHBhdGNoIGNvbnRleHQp
LiBJdCBoYXMgYmVlbiBpbnRyb2R1Y2VkIHdpdGggY29tbWl0DQo+PiAyZWNiYTJkMWU0NWIgKCJu
ZXQ6IHNjaGVkOiBhY3RfY3N1bTogRml4IGNzdW0gY2FsYyBmb3IgdGFnZ2VkIHBhY2tldHMiKS4N
Cj4+DQo+IFRoaXMgaXMgZXhhY3RseSB3aHkgSSBhc2suLi4NCj4NCj4NCj4+PiBXaHkgZG8geW91
IHN0aWxsIG5lZWQgdG8gbG9vcCBoZXJlPyB0Y19za2JfcHVsbF92bGFucygpIGFscmVhZHkNCj4+
PiBjb250YWlucyBhIGxvb3AgdG8gcG9wIGFsbCB2bGFuIHRhZ3M/DQo+PiBUaGUgcmVhc29uIHdo
eSB0aGUgbG9vcCBpcyBoZXJlIGlzOg0KPj4gMSkgaW4gY2FzZSB0aGVyZSBpcyBhIHN0cmlwcGVk
IHZsYW4gdGFnLCBpdCByZXBsYWNlcyB0Y19za2JfcHJvdG9jb2woc2tiKQ0KPj4gd2l0aCB0aGUg
aW5uZXIgZXRoZXJ0eXBlIChpLmUuIHNrYi0+cHJvdG9jb2wpDQo+Pg0KPj4gMikgaW4gY2FzZSB0
aGVyZSBpcyBvbmUgb3IgbW9yZSB1bnN0cmlwcGVkIFZMQU4gdGFncywgaXQgcHVsbHMgdGhlbS4g
QXQNCj4+IHRoZSBsYXN0IGl0ZXJhdGlvbiwgd2hlbiBpdCBkb2VzOg0KPiBMZXQgbWUgYXNrIGl0
IGluIGFub3RoZXIgd2F5Og0KPg0KPiBUaGUgb3JpZ2luYWwgY29kZSwgd2l0aG91dCB5b3VyIHBh
dGNoLCBoYXMgYSBsb29wICh0aGUgImdvdG8gYWdhaW4iKSB0bw0KPiBwb3AgYWxsIHZsYW4gdGFn
cy4NCj4NCj4gVGhlIGNvZGUgd2l0aCB5b3VyIHBhdGNoIGFkZHMgeWV0IGFub3RoZXIgbG9vcCAo
dGhlIHdoaWxlIGxvb3AgaW5zaWRlIHlvdXINCj4gdGNfc2tiX3B1bGxfdmxhbnMoKSkgdG8gcG9w
IGFsbCB2bGFuIHRhZ3MuDQo+DQo+IFNvLCBhZnRlciB5b3VyIHBhdGNoLCB3ZSBoYXZlIGJvdGgg
bG9vcHMuIFNvLCBJIGFtIGNvbmZ1c2VkIHdoeSB3ZSBuZWVkDQo+IHRoZXNlIHR3byBuZXN0ZWQg
bG9vcHMgdG8ganVzdCBwb3AgYWxsIHZsYW4gdGFncz8gSSB0aGluayBvbmUgaXMgc3VmZmljaWVu
dC4NCkFmdGVyIERhdmlkZSdzIHBhdGNoLCB0aGUgImdvdG8gYWdhaW4iIGlzIG5lZWRlZCB0byBy
ZS1lbnRlciB0aGUgc3dpdGNoIA0KY2FzZSwgYW5kIGd1YXJhbnRlZWQgdG8gYmUgZG9uZSBvbmx5
IG9uY2UsIGFzIGFsbCB0aGUgVkxBTiB0YWdzIHdlcmUgDQphbHJlYWR5IHB1bGxlZC4gVGhlIGFs
dGVybmF0aXZlIGlzIGhhdmluZyBhIGRlZGljYXRlZCBpZiBiZWZvcmUgdGhlIHN3aXRjaC4NCj4N
Cj4NCj4+Pj4gICAgICAgICAgfQ0KPj4+Pg0KPj4+PiBkaWZmIC0tZ2l0IGEvbmV0L3NjaGVkL2Ns
c19hcGkuYyBiL25ldC9zY2hlZC9jbHNfYXBpLmMNCj4+Pj4gaW5kZXggZDQ2OTkxNTY5NzRhLi4z
ODJlZTY5ZmIxYTUgMTAwNjQ0DQo+Pj4+IC0tLSBhL25ldC9zY2hlZC9jbHNfYXBpLmMNCj4+Pj4g
KysrIGIvbmV0L3NjaGVkL2Nsc19hcGkuYw0KPj4+PiBAQCAtMzMwMCw2ICszMzAwLDI4IEBAIHVu
c2lnbmVkIGludCB0Y2ZfZXh0c19udW1fYWN0aW9ucyhzdHJ1Y3QgdGNmX2V4dHMgKmV4dHMpDQo+
Pj4+ICAgfQ0KPj4+PiAgIEVYUE9SVF9TWU1CT0wodGNmX2V4dHNfbnVtX2FjdGlvbnMpOw0KPj4+
Pg0KPj4+PiAraW50IHRjX3NrYl9wdWxsX3ZsYW5zKHN0cnVjdCBza19idWZmICpza2IsIHVuc2ln
bmVkIGludCAqaGRyX2NvdW50LA0KPj4+PiArICAgICAgICAgICAgICAgICAgICAgX19iZTE2ICpw
cm90bykNCj4+PiBJdCBsb29rcyBsaWtlIHRoaXMgZnVuY3Rpb24gZml0cyBiZXR0ZXIgaW4gbmV0
L2NvcmUvc2tidWZmLmMsIGJlY2F1c2UNCj4+PiBJIGRvbid0IHNlZSBhbnl0aGluZyBUQyBzcGVj
aWZpYy4NCj4+IE9rLCBJIGRvbid0IGtub3cgaWYgb3RoZXIgcGFydHMgb2YgdGhlIGtlcm5lbCBy
ZWFsbHkgbmVlZCBpdC4gSXRzIHVzZQ0KPj4gc2hvdWxkIGJlIGNvbWJpbmVkIHdpdGggdGNfc2ti
X3Byb3RvY29sKCksIHdoaWNoIGlzIGluIHBrdF9zY2hlZC5oLg0KPj4NCj4+IEJ1dCBpIGNhbiBt
b3ZlIGl0IHRvIHNrYnVmZiwgb3IgZWxzZXdod2VyZSwgdW5sZXNzIHNvbWVib2R5IGRpc2FncmVl
cy4NCj4+DQo+Pj4+ICt7DQo+Pj4+ICsgICAgICAgaWYgKHNrYl92bGFuX3RhZ19wcmVzZW50KHNr
YikpDQo+Pj4+ICsgICAgICAgICAgICAgICAqcHJvdG8gPSBza2ItPnByb3RvY29sOw0KPj4+PiAr
DQo+Pj4+ICsgICAgICAgd2hpbGUgKGV0aF90eXBlX3ZsYW4oKnByb3RvKSkgew0KPj4+PiArICAg
ICAgICAgICAgICAgc3RydWN0IHZsYW5faGRyICp2bGFuOw0KPj4+PiArDQo+Pj4+ICsgICAgICAg
ICAgICAgICBpZiAodW5saWtlbHkoIXBza2JfbWF5X3B1bGwoc2tiLCBWTEFOX0hMRU4pKSkNCj4+
Pj4gKyAgICAgICAgICAgICAgICAgICAgICAgcmV0dXJuIC1FTk9NRU07DQo+Pj4+ICsNCj4+Pj4g
KyAgICAgICAgICAgICAgIHZsYW4gPSAoc3RydWN0IHZsYW5faGRyICopc2tiLT5kYXRhOw0KPj4+
PiArICAgICAgICAgICAgICAgKnByb3RvID0gdmxhbi0+aF92bGFuX2VuY2Fwc3VsYXRlZF9wcm90
bzsNCj4+Pj4gKyAgICAgICAgICAgICAgIHNrYl9wdWxsKHNrYiwgVkxBTl9ITEVOKTsNCj4+Pj4g
KyAgICAgICAgICAgICAgIHNrYl9yZXNldF9uZXR3b3JrX2hlYWRlcihza2IpOw0KPj4gQWdhaW4s
IHRoaXMgY29kZSB3YXMgaW4gYWN0X2NzdW0uYyBhbHNvIGJlZm9yZS4gVGhlIG9ubHkgaW50ZW50
aW9uIG9mIHRoaXMNCj4+IHBhdGNoIGlzIHRvIGVuc3VyZSB0aGF0IHBza2JfbWF5X3B1bGwoKSBp
cyBjYWxsZWQgYmVmb3JlIHNrYl9wdWxsKCksIGFzDQo+PiBwZXIgRXJpYyBzdWdnZXN0aW9uLCBh
bmQgbW92ZSB0aGlzIGNvZGUgb3V0IG9mIGFjdF9jc3VtIHRvIHVzZSBpdCB3aXRoDQo+PiBvdGhl
ciBUQyBhY3Rpb25zLg0KPiBTdXJlLCBubyBvbmUgc2F5cyB0aGUgY29kZSBiZWZvcmUgeW91cnMg
aXMgbW9yZSBjb3JyZWN0LCByaWdodD8gOikNCj4NCj4+PiBBbnkgcmVhc29uIG5vdCB0byBjYWxs
IF9fc2tiX3ZsYW5fcG9wKCkgZGlyZWN0bHk/DQo+PiBJIHRoaW5rIHdlIGNhbid0IHVzZSBfX3Nr
Yl92bGFuX3BvcCgpLCBiZWNhdXNlICdhY3RfY3N1bScgbmVlZHMgdG8gcmVhZA0KPj4gdGhlIGlu
bmVybW9zdCBldGhlcnR5cGUgaW4gdGhlIHBhY2tldCB0byB1bmRlcnN0YW5kIGlmIGl0J3MgSVB2
NCwgSVB2NiBvcg0KPj4gZWxzZSAoQVJQLCBFQVBPTCwgLi4uKS4NCj4+DQo+PiBJZiBJIHdlbGwg
cmVhZCBfX3NrYl92bGFuX3BvcCgpLCBpdCByZXR1cm5zIHRoZSBWTEFOIElELCB3aGljaCBpcyB1
c2VsZXNzDQo+PiBoZXJlLg0KPj4NCj4gSSBhbSBjb25mdXNlZCwgdGhpcyBjb3VsZCBiZSBjaGVj
a2VkIGJ5IGV0aF90eXBlX3ZsYW4oc2tiLT5wcm90b2NvbCksDQo+IHJpZ2h0PyBTbyB3aHkgaXQg
c3RvcHMgeW91IGZyb20gY29uc2lkZXJpbmcgX19za2Jfdmxhbl9wb3AoKSBvcg0KPiBza2Jfdmxh
bl9wb3AoKT8gVGhleSBib3RoIHNob3VsZCByZXR1cm4gZXJyb3Igb3IgemVybywgbm90IHZsYW4g
SUQuDQo+DQo+IFRoYW5rcy4NCg==
