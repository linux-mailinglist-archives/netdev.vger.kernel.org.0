Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7EF82FF71
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 20:11:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726731AbfD3SL5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Apr 2019 14:11:57 -0400
Received: from mail-eopbgr30052.outbound.protection.outlook.com ([40.107.3.52]:62038
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725950AbfD3SL5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Apr 2019 14:11:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xyN8s1F6Ri5zme3WwO9zsxmXqf3PtzsBCmqadl7geVw=;
 b=G+fTHAp7AP7BBT5BVLhuPIaw70lXV06ffy2Q5B04L2IL7nLmlCSFF8BGbamB8F7THupkztQordK4INfQ+mSkuF/ykhZSmIsqzhWDZKfIGsZR1q12I2W2h+ztgTglD47Ij8rPtMvctlUmc+V8/DiX174FiVLzWzbs49ZpJmLGg24=
Received: from AM6PR05MB5879.eurprd05.prod.outlook.com (20.179.0.76) by
 AM6PR05MB5553.eurprd05.prod.outlook.com (20.177.119.202) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1835.15; Tue, 30 Apr 2019 18:11:52 +0000
Received: from AM6PR05MB5879.eurprd05.prod.outlook.com
 ([fe80::cc18:150a:7740:1e2f]) by AM6PR05MB5879.eurprd05.prod.outlook.com
 ([fe80::cc18:150a:7740:1e2f%2]) with mapi id 15.20.1856.008; Tue, 30 Apr 2019
 18:11:52 +0000
From:   Maxim Mikityanskiy <maximmi@mellanox.com>
To:     =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Magnus Karlsson <magnus.karlsson@intel.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Jonathan Lemon <bsd@fb.com>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: Re: [PATCH net-next 4/6] xsk: Extend channels to support combined
 XSK/non-XSK traffic
Thread-Topic: [PATCH net-next 4/6] xsk: Extend channels to support combined
 XSK/non-XSK traffic
Thread-Index: AQHU/CUldh5izAMluEaPJixgdWw0JqZO5HcAgAYjmwA=
Date:   Tue, 30 Apr 2019 18:11:52 +0000
Message-ID: <4e830da4-086b-4157-e0d6-bd1adcf49788@mellanox.com>
References: <20190426114156.8297-1-maximmi@mellanox.com>
 <20190426114156.8297-5-maximmi@mellanox.com>
 <e4c2a6ee-5aa4-eabf-444f-b5f6df17fe38@intel.com>
In-Reply-To: <e4c2a6ee-5aa4-eabf-444f-b5f6df17fe38@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM4PR08CA0075.eurprd08.prod.outlook.com
 (2603:10a6:205:2::46) To AM6PR05MB5879.eurprd05.prod.outlook.com
 (2603:10a6:20b:a2::12)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=maximmi@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [95.67.35.250]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6f750400-d5c2-42e4-52ba-08d6cd975230
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:AM6PR05MB5553;
x-ms-traffictypediagnostic: AM6PR05MB5553:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <AM6PR05MB55538D3CB70BBA9B0F41D208D13A0@AM6PR05MB5553.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 00235A1EEF
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(396003)(136003)(346002)(376002)(39860400002)(43544003)(189003)(199004)(6506007)(3846002)(26005)(478600001)(316002)(97736004)(6116002)(446003)(76176011)(4326008)(476003)(486006)(8676002)(110136005)(52116002)(81166006)(6436002)(54906003)(8936002)(99286004)(11346002)(81156014)(2616005)(31686004)(66946007)(66556008)(256004)(66476007)(64756008)(66446008)(73956011)(36756003)(66574012)(305945005)(71200400001)(6306002)(5024004)(71190400001)(14444005)(102836004)(53546011)(68736007)(86362001)(966005)(7736002)(229853002)(186003)(66066001)(6486002)(386003)(5660300002)(53936002)(31696002)(25786009)(6512007)(14454004)(2906002)(6246003);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR05MB5553;H:AM6PR05MB5879.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: ZTTagHXH/i9PLcUh4h/aWAPA6eVQSZKAxAotzDXOjUh3IDFv5NOGTNqAV5iGjFr8Xj1XupdFXJGe2viokQRkUzsmlc8C2yOfP5PxbrkKZdxnmwHU+V79PDpvizgu1R1/HNeeK68JdgiK1jmO0KOan+V/gIEV8hChG4RqP8JUgi2bdWwyQW65cZc6yBnO4Sf9PFYj+aVi1X+MVg5wtCsALz+QT7H9Q/qlHOhikE5uynvZJTpPIJyyLBFdh549Er9h+fmATJJPuy1vdJdDu+H2whsEdXm9bQPcbPglY+6HgYtL9n4gvScZKS05Ky7L3ZfaGJJOH3/F55QM0dxpW3KJAAZZgaqZrGNwCYV/cB5XTYrfnEjg8DYh+ljzd+HlvCZTOe5Q3+vMnNyomEF9yZsretjstwYlKJ9KonIVwPE5tGs=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A95B930B42F111469C6917FA73BB8630@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f750400-d5c2-42e4-52ba-08d6cd975230
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Apr 2019 18:11:52.4780
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB5553
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMjAxOS0wNC0yNiAyMzoyNiwgQmrDtnJuIFTDtnBlbCB3cm90ZToNCj4gT24gMjAxOS0wNC0y
NiAxMzo0MiwgTWF4aW0gTWlraXR5YW5za2l5IHdyb3RlOg0KPj4gQ3VycmVudGx5LCB0aGUgZHJp
dmVycyB0aGF0IGltcGxlbWVudCBBRl9YRFAgemVyby1jb3B5IHN1cHBvcnQgKGUuZy4sDQo+PiBp
NDBlKSBzd2l0Y2ggdGhlIGNoYW5uZWwgaW50byBhIGRpZmZlcmVudCBtb2RlIHdoZW4gYW4gWFNL
IGlzIG9wZW5lZC4gSXQNCj4+IGNhdXNlcyBzb21lIGlzc3VlcyB0aGF0IGhhdmUgdG8gYmUgdGFr
ZW4gaW50byBhY2NvdW50LiBGb3IgZXhhbXBsZSwgUlNTDQo+PiBuZWVkcyB0byBiZSByZWNvbmZp
Z3VyZWQgdG8gc2tpcCB0aGUgWFNLLWVuYWJsZWQgY2hhbm5lbHMsIG9yIHRoZSBYRFANCj4+IHBy
b2dyYW0gc2hvdWxkIGZpbHRlciBvdXQgdHJhZmZpYyBub3QgaW50ZW5kZWQgZm9yIHRoYXQgc29j
a2V0IGFuZA0KPj4gWERQX1BBU1MgaXQgd2l0aCBhbiBhZGRpdGlvbmFsIGNvcHkuIEFzIG5vdGhp
bmcgdmFsaWRhdGVzIG9yIGZvcmNlcyB0aGUNCj4+IHByb3BlciBjb25maWd1cmF0aW9uLCBpdCdz
IGVhc3kgdG8gaGF2ZSBwYWNrZXRzIGRyb3BzLCB3aGVuIHRoZXkgZ2V0DQo+PiBpbnRvIGFuIFhT
SyBieSBtaXN0YWtlLCBhbmQsIGluIGZhY3QsIGl0J3MgdGhlIGRlZmF1bHQgY29uZmlndXJhdGlv
bi4NCj4+IFRoZXJlIGhhcyB0byBiZSBzb21lIHRvb2wgdG8gaGF2ZSBSU1MgcmVjb25maWd1cmVk
IG9uIGVhY2ggc29ja2V0IG9wZW4NCj4+IGFuZCBjbG9zZSBldmVudCwgYnV0IHN1Y2ggYSB0b29s
IGlzIHByb2JsZW1hdGljIHRvIGltcGxlbWVudCwgYmVjYXVzZSBubw0KPj4gb25lIHJlcG9ydHMg
dGhlc2UgZXZlbnRzLCBhbmQgaXQncyByYWNlLXByb25lLg0KPj4NCj4+IFRoaXMgY29tbWl0IGV4
dGVuZHMgWFNLIHRvIHN1cHBvcnQgYm90aCBraW5kcyBvZiB0cmFmZmljIChYU0sgYW5kDQo+PiBu
b24tWFNLKSBpbiB0aGUgc2FtZSBjaGFubmVsLiBJdCBpbXBsaWVzIGhhdmluZyB0d28gUlggcXVl
dWVzIGluDQo+PiBYU0stZW5hYmxlZCBjaGFubmVsczogb25lIGZvciB0aGUgcmVndWxhciB0cmFm
ZmljLCBhbmQgdGhlIG90aGVyIGZvcg0KPj4gWFNLLiBJdCBzb2x2ZXMgdGhlIHByb2JsZW0gd2l0
aCBSU1M6IHRoZSBkZWZhdWx0IGNvbmZpZ3VyYXRpb24ganVzdA0KPj4gd29ya3Mgd2l0aG91dCB0
aGUgbmVlZCB0byBtYW51YWxseSByZWNvbmZpZ3VyZSBSU1Mgb3IgdG8gcGVyZm9ybSBzb21lDQo+
PiBwb3NzaWJseSBjb21wbGljYXRlZCBmaWx0ZXJpbmcgaW4gdGhlIFhEUCBsYXllci4gSXQgbWFr
ZXMgaXQgZWFzeSB0byBydW4NCj4+IGJvdGggQUZfWERQIGFuZCByZWd1bGFyIHNvY2tldHMgb24g
dGhlIHNhbWUgbWFjaGluZS4gSW4gdGhlIFhEUCBwcm9ncmFtLA0KPj4gdGhlIFFJRCdzIG1vc3Qg
c2lnbmlmaWNhbnQgYml0IHdpbGwgc2VydmUgYXMgYSBmbGFnIHRvIGluZGljYXRlIHdoZXRoZXIN
Cj4+IGl0J3MgdGhlIFhTSyBxdWV1ZSBvciBub3QuIFRoZSBleHRlbnNpb24gaXMgY29tcGF0aWJs
ZSB3aXRoIHRoZSBsZWdhY3kNCj4+IGNvbmZpZ3VyYXRpb24sIHNvIGlmIG9uZSB3YW50cyB0byBy
dW4gdGhlIGxlZ2FjeSBtb2RlLCB0aGV5IGNhbg0KPj4gcmVjb25maWd1cmUgUlNTIGFuZCBpZ25v
cmUgdGhlIGZsYWcgaW4gdGhlIFhEUCBwcm9ncmFtIChpbXBsZW1lbnRlZCBpbg0KPj4gdGhlIHJl
ZmVyZW5jZSBYRFAgcHJvZ3JhbSBpbiBsaWJicGYpLiBtbHg1ZSB3aWxsIHN1cHBvcnQgdGhpcyBl
eHRlbnNpb24uDQo+Pg0KPj4gQSBzaW5nbGUgWERQIHByb2dyYW0gY2FuIHJ1biBib3RoIHdpdGgg
ZHJpdmVycyBzdXBwb3J0aW5nIG9yIG5vdA0KPj4gc3VwcG9ydGluZyB0aGlzIGV4dGVuc2lvbi4g
VGhlIHhkcHNvY2sgc2FtcGxlIGFuZCBsaWJicGYgYXJlIHVwZGF0ZWQNCj4+IGFjY29yZGluZ2x5
Lg0KPj4NCj4+IFNpZ25lZC1vZmYtYnk6IE1heGltIE1pa2l0eWFuc2tpeTxtYXhpbW1pQG1lbGxh
bm94LmNvbT4NCj4gDQo+IA0KPiBJIGFja25vd2xlZGdlIHRoZSBwcm9ibGVtIHlvdSdyZSBhZGRy
ZXNzaW5nLCBidXQgSSdtIG5vdCBhIGZhbiBvZiB0aGlzDQo+IGRlc2lnbi4NCj4gDQo+IE5ldGRl
dnMsIHF1ZXVlcyBhbmQgbm93IGNoYW5uZWxzLiBUaGlzIGlzIHRvbyBjb21wbGljYXRlZC4gVGhl
IHNldHVwIGlzDQo+IGNvbXBsZXggYXMgaXQgaXMuIEFkZGluZyBtb3JlIGNvZ25pdGl2ZSBsb2Fk
IGlzIG5vdCBnb29kLg0KDQpJTU8sIHVzaW5nICJxdWV1ZXMiIGZvciBBRl9YRFAgaXMgYSBtaXNu
b21lci4gWW91IGRvbid0IHJlYWxseSBhdHRhY2ggYW4gDQpBRl9YRFAgc29ja2V0IHRvIFJYIHF1
ZXVlIG51bWJlciBYIGFuZCBUWCBxdWV1ZSBudW1iZXIgWS4gSW5zdGVhZCwgeW91IA0KaGF2ZSBh
IHNpbmdsZSBudW1iZXIsIGFuZCB0aGF0IG51bWJlciBhY3R1YWxseSBzZWxlY3RzIGEgY2hhbm5l
bCAoYSByaW5nIA0KaW4gaTQwZSkgbnVtYmVyIFgsIHdoaWNoIGhhcyBhbiBSWCBxdWV1ZSBhbmQg
VFggcXVldWUuIEV2ZW4gbGliYnBmIA0KcXVlcmllcyB0aGUgbnVtYmVyIG9mIGNoYW5uZWxzIHRv
IGRldGVybWluZSB0aGUgbWF4aW11bSBYIGFsbG93ZWQuDQoNClNvLCBJJ20gbm90IGFkZGluZyBh
bnl0aGluZyBwYXJ0aWN1bGFybHkgbmV3IGhlcmUuIEV2ZXJ5dGhpbmcgdGhhdCB1c2VkIA0KdG8g
d29yayBzdGlsbCB3b3Jrcy4gSSdtIG5vdCB1c2luZyBuZXRkZXZzK3F1ZXVlcytjaGFubmVscywg
SSdtIHN0aWxsIA0KdXNpbmcgbmV0ZGV2cytjaGFubmVscywganVzdCBhcyBpdCB3YXMgYmVmb3Jl
LiBUaGVyZSBpcyBubyBpbmNvbXBhdGlibGUgDQpjaGFuZ2UgaGVyZSwgb25seSBhbiBpbXByb3Zl
bWVudCBmb3IgdGhlIGRyaXZlcnMgdGhhdCBzdXBwb3J0IGl0Lg0KDQpJJ20gZ29pbmcgdG8gcmVz
cGluIHRoaXMgc2VyaWVzLCBhZGRpbmcgdGhlIG1seDUgcGF0Y2hlcyBhbmQgYWRkcmVzc2luZyAN
CnRoZSBvdGhlciBjb21tZW50cy4gSWYgeW91IGZlZWwgbGlrZSB0aGVyZSBhcmUgbW9yZSB0aGlu
Z3MgdG8gZGlzY3VzcyANCnJlZ2FyZGluZyB0aGlzIHBhdGNoLCBwbGVhc2UgbW92ZSBvbiB0byB0
aGUgdjIuDQoNClRoYW5rcyBmb3IgbG9va2luZyBpbnRvIGl0IQ0KDQo+IFRoZXJlJ3MgYWxyZWFk
eSBhbiBhc3N1bXB0aW9uIHRoYXQgYSB1c2VyIGF0dGFjaGluZyB0byBhIGNlcnRhaW4gbmV0ZGV2
DQo+IHF1ZXVlIGhhcyB0byB0YWtlIGNhcmUgb2YgdGhlIGZsb3cgc3RlZXJpbmcuDQo+IA0KPiBX
aGF0IGFib3V0IGFkZGluZyBhIG1vZGUgd2hlcmUgdGhlIEFGX1hEUCB1c2VyIGp1c3QgZ2V0IGEg
Km5ldyogcXVldWUsDQo+IGJ5IGJpbmRpbmcgdG8gKHNheSkgbmV0ZGV2O3FpZD09LTE/IFRoaXMg
bmV3IHF1ZXVlIHdvdWxkbid0IGJlIGluY2x1ZGVkDQo+IGluIHRoZSBleGlzdGluZyBxdWV1ZSBz
ZXQuIENyZWF0ZSBhIGJ1bmNoIG9mIEFGX1hEUCBzb2NrZXRzIGFuZCBzdGVlcg0KPiB0cmFmZmlj
IHRvIHRoYXQgc2V0LiBBbmQgeWVzLCB3ZSBuZWVkIGEgbWVjaGFuaXNtIHRvIHN0ZWVyIHRvIHRo
YXQNCj4gcXVldWUsIGluLWFwcC9zb2NrZXQgb3Igb3V0LW9mLWJhbmQuIFBsZWFzZSBzZWUgdGhp
cyBbMV0gZGlzY3Vzc2lvbi4NCj4gDQo+IEkgZG9uJ3QgbGlrZSB0aGlzICJsZXQncyBzcGxpdCBh
IHF1ZXVlIGludG8gY2hhbm5lbHMiLg0KPiANCj4gDQo+IEJqw7Zybg0KPiANCj4gDQo+IFsxXSBo
dHRwczovL2xvcmUua2VybmVsLm9yZy9uZXRkZXYvMjAxOTA0MTUxODMyNTguMzZkY2VlOWFAY2Fy
Ym9uLw0KDQo=
