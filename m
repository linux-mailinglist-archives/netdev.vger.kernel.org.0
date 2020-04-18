Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 764851AE9A9
	for <lists+netdev@lfdr.de>; Sat, 18 Apr 2020 05:33:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725849AbgDRDd2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Apr 2020 23:33:28 -0400
Received: from mail-eopbgr30088.outbound.protection.outlook.com ([40.107.3.88]:47308
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725320AbgDRDd1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Apr 2020 23:33:27 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NdO4PT/WMyPPcZdHjq2+aBl7yw6bZP9ophwxvLcodLYDPpRRfT1jLB8oRTvPcABf6cTZn1AhwrYFTyw72bh+Ex+HGtDMGkzCyDQrp14J0SXfLNrQFmZaNOeqkxWHQPkg3POPGLT98staKpPBkFxksh7ViK0O7ZxosXGbKh5ZdNzxNl+hW71yVqkbXcySDFpHT0qFGULrp5Wtht+ZoFden+Z5JhTet7mkrZqqiWGlS+PUdhG8VcbtllparGGeW4+HBhULtyjFAaS7KIXLRWS8EocMbM1ytlkwESkJxFybpTSpPU5Dcvpw+Pkv1Ig9AaAS5a+94hu5l2F8qfREma80Jg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eLs1geDBELqMf2xnIlCqzHM/zCQA8TUqCeTX/o6hP6g=;
 b=iVgFbYQB1lCPShG6UV4VH1qb8EmxSBiG9jHb9L681xZtAxHfLLWTQ6x/3NUgAO92KhWOyp88ZlKMg/64G43TSonG3nG4UWL0zpU4XVIIRRomSn++JBCDWrw7+uTUat0taG8TuSQfTGDRpCzZ3zl0jqW9lVdXsja9Q95sdgaO4smOVVTv9WARwhPgE/5Ih0zxjfUkLjSuZLYvDz0v7NQqh3MPEt1ZDPg0huKdxeHqCXjBMqSVc2Qf8jElHV0zvS13GUgbjt1HenZ1AjND/N4X+frtAuyLbx4VOMDZFB8p2bl+2VwqziPezlSSBNLvtsmNh56I/ZZVLCeXvXSYFhXJBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eLs1geDBELqMf2xnIlCqzHM/zCQA8TUqCeTX/o6hP6g=;
 b=B5dkWMAyYi1+Fek0cM89CkmrUct2+kVoY/uMP3zwK9pZT816Y0Wv8Ih50rK4oG0d8b63sfzKscBUGjNWiEzh9TeFMryeM5jEc0phbiARjj9k+zN3TJGLZQufQU3nFQwzOJHiwsTmlop2Sk3potlL+/8j0mPYm2CqP29OgDyJmtA=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB5376.eurprd05.prod.outlook.com (2603:10a6:803:a4::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.29; Sat, 18 Apr
 2020 03:33:08 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19%7]) with mapi id 15.20.2900.030; Sat, 18 Apr 2020
 03:33:08 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "brouer@redhat.com" <brouer@redhat.com>
CC:     "akiyano@amazon.com" <akiyano@amazon.com>,
        "willemdebruijn.kernel@gmail.com" <willemdebruijn.kernel@gmail.com>,
        "borkmann@iogearbox.net" <borkmann@iogearbox.net>,
        "jeffrey.t.kirsher@intel.com" <jeffrey.t.kirsher@intel.com>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "toke@redhat.com" <toke@redhat.com>,
        "alexei.starovoitov@gmail.com" <alexei.starovoitov@gmail.com>,
        "gtzalik@amazon.com" <gtzalik@amazon.com>,
        "dsahern@gmail.com" <dsahern@gmail.com>,
        "alexander.duyck@gmail.com" <alexander.duyck@gmail.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "ilias.apalodimas@linaro.org" <ilias.apalodimas@linaro.org>,
        "zorik@amazon.com" <zorik@amazon.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "steffen.klassert@secunet.com" <steffen.klassert@secunet.com>,
        "lorenzo@kernel.org" <lorenzo@kernel.org>, "w@1wt.eu" <w@1wt.eu>
Subject: Re: [PATCH RFC v2 29/33] xdp: allow bpf_xdp_adjust_tail() to grow
 packet size
Thread-Topic: [PATCH RFC v2 29/33] xdp: allow bpf_xdp_adjust_tail() to grow
 packet size
Thread-Index: AQHWDZxJfZ/xt+YpZkKzQLVfnT6456hwI2iAgAh22ICABa6rgA==
Date:   Sat, 18 Apr 2020 03:33:08 +0000
Message-ID: <3e3f2bb2f38d23b9253b7219ae846ad3809e36c3.camel@mellanox.com>
References: <158634658714.707275.7903484085370879864.stgit@firesoul>
         <158634678170.707275.10720666808605360076.stgit@firesoul>
         <ed0ce4d76e77b23aa3edcd821d5a4867e8bb27b1.camel@mellanox.com>
         <20200414144637.0dafdda5@carbon>
In-Reply-To: <20200414144637.0dafdda5@carbon>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.34.4 (3.34.4-1.fc31) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [73.15.39.150]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: ac9029c8-529d-4c4b-1f2a-08d7e34936bb
x-ms-traffictypediagnostic: VI1PR05MB5376:
x-microsoft-antispam-prvs: <VI1PR05MB53764D205045B02D0F79B28ABED60@VI1PR05MB5376.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0377802854
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(136003)(376002)(346002)(396003)(39860400002)(366004)(2616005)(6506007)(6916009)(26005)(8676002)(81156014)(86362001)(186003)(8936002)(7416002)(478600001)(36756003)(316002)(4326008)(2906002)(6512007)(54906003)(6486002)(91956017)(5660300002)(66446008)(66946007)(76116006)(66476007)(64756008)(966005)(71200400001)(66556008);DIR:OUT;SFP:1101;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4SyJHo4wlXHw7ZPbp4mIFOuLoDk2g+CEEtPAGudMAcUBjmS4TTgSsU6sC6kOOqdRw1Z0tt8UD6ZrN424n8tTlsCNOwMDsUdZQ5FMZDRxBbn9J7YzgF0KoNokGGMzzoQgx5zdLFnRLt44I09OmyKjNiFztC3cQjWJTRxSeMaYl7W5we/6dVvjNrvGHCsNCXi/zYq9IzLo9kDmtD/vWnzb6W9aeNDciRK4QOEudPQ0WWSQSjSuZ2+h/yxf3PVqfUHiSsltrzxKTAm6J9VqlPOZEagw6rHfwI8dhA0haJ+NmVqSbYMgZlzVH/DGj+EviWmpfMlZ7atSsIBsCaaAagBg2owIY3kXL/JcZTbAJXP2R4lSKpuE3546l3X0lw4LnE8z2bRkJzBQOxi0LYNnbeaUPVFnbO/ydRaYc5CRe2u6ZfG2fALHBjmz3w5eRyI3P+X4adyTKwb6ckZWsfKUCABiSoFWrfwhTENpeg6hkHPTQ4ORMnFOyQDFBDh8OUqFmhHg6vIhrbYbrT8nDeVkR3H7TQ==
x-ms-exchange-antispam-messagedata: YJdkd3RYRhh09T1tpc2PuxwlkxD3hnbisWZpKs5qvkfUWwq5/biKjSfbWEo5Bks76i//CTNL0O9UsVawLr/5lrEDgvAfAUXPbywk7ZWhaoc4Dcpxmym3l8RAbH+/0pi6wlCfhN5BlYgV54sESDUiNQ==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <747AA71BEFC0694C97784E1F1F8C37F3@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ac9029c8-529d-4c4b-1f2a-08d7e34936bb
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Apr 2020 03:33:08.3756
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wOavpiCDR60yjuOarIi82hqoC8VDC1/Kx38dcfykTJzthwaH7anasaNtKzGZbmpVBr1HF4p/UgLZt/Y5gXbFSg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5376
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDIwLTA0LTE0IGF0IDE0OjQ2ICswMjAwLCBKZXNwZXIgRGFuZ2FhcmQgQnJvdWVy
IHdyb3RlOg0KPiBPbiBUaHUsIDkgQXByIDIwMjAgMDM6MzE6MTQgKzAwMDANCj4gU2FlZWQgTWFo
YW1lZWQgPHNhZWVkbUBtZWxsYW5veC5jb20+IHdyb3RlOg0KPiANCj4gPiBPbiBXZWQsIDIwMjAt
MDQtMDggYXQgMTM6NTMgKzAyMDAsIEplc3BlciBEYW5nYWFyZCBCcm91ZXIgd3JvdGU6DQo+ID4g
PiBGaW5hbGx5LCBhZnRlciBhbGwgZHJpdmVycyBoYXZlIGEgZnJhbWUgc2l6ZSwgYWxsb3cgQlBG
LWhlbHBlcg0KPiA+ID4gYnBmX3hkcF9hZGp1c3RfdGFpbCgpIHRvIGdyb3cgb3IgZXh0ZW5kIHBh
Y2tldCBzaXplIGF0IGZyYW1lDQo+ID4gPiB0YWlsLg0KPiA+ID4gICANCj4gPiANCj4gPiBjYW4g
eW91IHByb3ZpZGUgYSBsaXN0IG9mIHVzZWNhc2VzIGZvciB3aHkgdGFpbCBleHRlbnNpb24gaXMN
Cj4gPiBuZWNlc3NhcnkNCj4gPiA/DQo+IA0KPiBVc2UtY2FzZXM6DQo+ICgxKSBJUHNlYyAvIFhG
Uk0gbmVlZHMgYSB0YWlsIGV4dGVuZFsxXVsyXS4NCj4gKDIpIEROUy1jYWNoZSByZXBsaWVzIGlu
IFhEUC4NCj4gKDMpIEhBLXByb3h5IEFMT0hBIHdvdWxkIG5lZWQgaXQgdG8gY29udmVydCB0byBY
RFAuDQo+ICANCj4gPiBhbmQgd2hhdCBkbyB5b3UgaGF2ZSBpbiBtaW5kIGFzIGltbWVkaWF0ZSB1
c2Ugb2YNCj4gPiBicGZfeGRwX2FkanVzdF90YWlsKCkNCj4gPiA/IA0KPiANCj4gSSBndWVzcyBT
dGVmZmVuIEtsYXNzZXJ0J3MgaXBzZWMgdXNlLWNhc2UoMSkgaXQgdGhlIG1vc3QgaW1tZWRpYXRl
Lg0KPiANCj4gWzFdIGh0dHA6Ly92Z2VyLmtlcm5lbC5vcmcvbmV0Y29uZjIwMTlfZmlsZXMveGZy
bV94ZHAucGRmDQo+IFsyXSBodHRwOi8vdmdlci5rZXJuZWwub3JnL25ldGNvbmYyMDE5Lmh0bWwN
Cj4gDQoNClRoYW5rcyAhDQoNCj4gPiBib3RoIGNvdmVyIGxldHRlciBhbmQgY29tbWl0IG1lc3Nh
Z2VzIGRpZG4ndCBsaXN0IGFueSBhY3R1YWwgdXNlDQo+ID4gY2FzZS4uDQo+IA0KPiBTb3JyeSBh
Ym91dCB0aGF0Lg0KPiANCj4gPiA+IFJlbWVtYmVyIHRoYXQgaGVscGVyL21hY3JvIHhkcF9kYXRh
X2hhcmRfZW5kIGhhdmUgcmVzZXJ2ZWQgc29tZQ0KPiA+ID4gdGFpbHJvb20uICBUaHVzLCB0aGlz
IGhlbHBlciBtYWtlcyBzdXJlIHRoYXQgdGhlIEJQRi1wcm9nIGRvbid0DQo+ID4gPiBoYXZlDQo+
ID4gPiBhY2Nlc3MgdG8gdGhpcyB0YWlscm9vbSBhcmVhLg0KPiA+ID4gDQo+ID4gPiBTaWduZWQt
b2ZmLWJ5OiBKZXNwZXIgRGFuZ2FhcmQgQnJvdWVyIDxicm91ZXJAcmVkaGF0LmNvbT4NCj4gPiA+
IC0tLQ0KPiA+ID4gIGluY2x1ZGUvdWFwaS9saW51eC9icGYuaCB8ICAgIDQgKystLQ0KPiA+ID4g
IG5ldC9jb3JlL2ZpbHRlci5jICAgICAgICB8ICAgMTggKysrKysrKysrKysrKysrKy0tDQo+ID4g
PiAgMiBmaWxlcyBjaGFuZ2VkLCAxOCBpbnNlcnRpb25zKCspLCA0IGRlbGV0aW9ucygtKQ0KPiA+
ID4gDQo+IFsuLi4gY3V0IC4uLl0NCj4gPiA+IGRpZmYgLS1naXQgYS9uZXQvY29yZS9maWx0ZXIu
YyBiL25ldC9jb3JlL2ZpbHRlci5jDQo+ID4gPiBpbmRleCA3NjI4Yjk0N2RiYzMuLjRkNThhMTQ3
ZWVkMCAxMDA2NDQNCj4gPiA+IC0tLSBhL25ldC9jb3JlL2ZpbHRlci5jDQo+ID4gPiArKysgYi9u
ZXQvY29yZS9maWx0ZXIuYw0KPiA+ID4gQEAgLTM0MjIsMTIgKzM0MjIsMjYgQEAgc3RhdGljIGNv
bnN0IHN0cnVjdCBicGZfZnVuY19wcm90bw0KPiA+ID4gYnBmX3hkcF9hZGp1c3RfaGVhZF9wcm90
byA9IHsNCj4gPiA+ICANCj4gPiA+ICBCUEZfQ0FMTF8yKGJwZl94ZHBfYWRqdXN0X3RhaWwsIHN0
cnVjdCB4ZHBfYnVmZiAqLCB4ZHAsIGludCwNCj4gPiA+IG9mZnNldCkNCj4gPiA+ICB7DQo+ID4g
PiArCXZvaWQgKmRhdGFfaGFyZF9lbmQgPSB4ZHBfZGF0YV9oYXJkX2VuZCh4ZHApOw0KPiA+ID4g
IAl2b2lkICpkYXRhX2VuZCA9IHhkcC0+ZGF0YV9lbmQgKyBvZmZzZXQ7DQo+ID4gPiAgDQo+ID4g
PiAtCS8qIG9ubHkgc2hyaW5raW5nIGlzIGFsbG93ZWQgZm9yIG5vdy4gKi8NCj4gPiA+IC0JaWYg
KHVubGlrZWx5KG9mZnNldCA+PSAwKSkNCj4gPiA+ICsJLyogTm90aWNlIHRoYXQgeGRwX2RhdGFf
aGFyZF9lbmQgaGF2ZSByZXNlcnZlZCBzb21lIHRhaWxyb29tICovDQo+ID4gPiArCWlmICh1bmxp
a2VseShkYXRhX2VuZCA+IGRhdGFfaGFyZF9lbmQpKQ0KPiA+ID4gIAkJcmV0dXJuIC1FSU5WQUw7
DQo+ID4gPiAgICANCj4gPiANCj4gPiBpIGRvbid0IGtub3cgaWYgaSBsaWtlIHRoaXMgYXBwcm9h
Y2ggZm9yIGNvdXBsZSBvZiByZWFzb25zLg0KPiA+IA0KPiA+IDEuIGRyaXZlcnMgd2lsbCBwcm92
aWRlIGFyYml0cmFyeSBmcmFtZXNfc3osIHdoaWNoIGlzIG5vcm1hbGx5DQo+ID4gbGFyZ2VyDQo+
ID4gdGhhbiBtdHUsIGFuZCBjb3VsZCBiZSBhIGZ1bGwgcGFnZSBzaXplLCBmb3IgWERQX1RYIGFj
dGlvbiB0aGlzIGNhbg0KPiA+IGJlDQo+ID4gcHJvYmxlbWF0aWMgaWYgeGRwIHByb2dzIHdpbGwg
YWxsb3cgb3ZlcnNpemVkIHBhY2tldHMgdG8gZ2V0IGNhdWdodA0KPiA+IGF0DQo+ID4gdGhlIGRy
aXZlciBsZXZlbC4uDQo+IA0KPiBXZSBhbHJlYWR5IGNoZWNrIGlmIE1UVSBpcyBleGNlZWRlZCBm
b3IgYSBzcGVjaWZpYyBkZXZpY2Ugd2hlbiB3ZQ0KPiByZWRpcmVjdCBpbnRvIHRoaXMsIHNlZSBo
ZWxwZXIgeGRwX29rX2Z3ZF9kZXYoKS4gIEZvciB0aGUgWERQX1RYDQo+IGNhc2UsDQo+IEkgZ3Vl
c3Mgc29tZSBkcml2ZXJzIGJ5cGFzcyB0aGF0IGNoZWNrLCB3aGljaCBzaG91bGQgYmUgZml4ZWQu
IFRoZQ0KPiBYRFBfVFggY2FzZSBpcyBJTUhPIGEgcGxhY2Ugd2hlcmUgd2UgYWxsb3cgZHJpdmVy
cyBkbyBzcGVjaWFsDQo+IG9wdGltaXphdGlvbnMsIHRodXMgZHJpdmVycyBjYW4gY2hvb3NlIHRv
IGRvIHNvbWV0aGluZyBmYXN0ZXIgdGhhbg0KPiBjYWxsaW5nIGdlbmVyaWMgaGVscGVyIHhkcF9v
a19md2RfZGV2KCkuICANCj4gICANCj4gPiAyLiB4ZHBfZGF0YV9oYXJkX2VuZCh4ZHApIGhhcyBh
IGhhcmRjb2RlZCBhc3N1bXB0aW9uIG9mIHRoZSBza2INCj4gPiBzaGluZm8NCj4gPiBhbmQgaXQg
aW50cm9kdWNlcyBhIHJldmVyc2UgZGVwZW5kZW5jeSBiZXR3ZWVuIHhkcCBidWZmIGFuZCBza2J1
ZmYgDQo+ID4gDQo+IChJJ2xsIGFkZHJlc3MgdGhpcyBpbiBhbm90aGVyIG1haWwpDQo+IA0KPiA+
IGJvdGggb2YgdGhlIGFib3ZlIGNhbiBiZSBzb2x2ZWQgaWYgdGhlIGRyaXZlcnMgcHJvdmlkZWQg
dGhlIG1heA0KPiA+IGFsbG93ZWQgZnJhbWUgc2l6ZSwgYWxyZWFkeSBhY2NvdW50aW5nIGZvciBt
dHUgYW5kIHNoaW5mbyB3aGVuDQo+ID4gc2V0dGluZw0KPiA+IHhkcF9idWZmLmZyYW1lX3N6IGF0
IHRoZSBkcml2ZXIgbGV2ZWwuDQo+IA0KPiBJdCBzZWVtcyB3ZSBsb29rIGF0IHRoZSBwcm9ibGVt
IGZyb20gdHdvIGRpZmZlcmVudCBhbmdsZXMuICBZb3UgaGF2ZQ0KPiB0aGUgZHJpdmVycyBwZXJz
cGVjdGl2ZSwgd2hpbGUgSSBoYXZlIHRoZSBuZXR3b3JrIHN0YWNrcyBwZXJzcGVjdGl2ZQ0KPiAo
dGhlIFhEUF9QQVNTIGNhc2UpLiAgVGhlIG1seDUgZHJpdmVyIHRyZWF0cyBYRFAgYXMgYSBzcGVj
aWFsIGNhc2UsDQo+IGJ5DQo+IGhpZGluZyBvciBjb25maW5pbmcgeGRwX2J1ZmYgdG8gZnVuY3Rp
b25zIGZhaXJseSBkZWVwIGluIHRoZQ0KPiBjYWxsLXN0YWNrLiAgTXkgZ29hbCBpcyBkaWZmZXJl
bnQgKG1vdmluZyBTS0Igb3V0IG9mIGRyaXZlcnMpLCBJIHNlZQ0KPiB0aGUgeGRwX2J1ZmYveGRw
X2ZyYW1lIGFzIHRoZSBtYWluIHBhY2tldCBvYmplY3QgaW4gdGhlIGRyaXZlcnMsIHRoYXQNCj4g
Z2V0cyBzZW5kIHVwIHRoZSBuZXR3b3JrIHN0YWNrIChhZnRlciBjb252ZXJ0aW5nIHRvIHhkcF9m
cmFtZSkgYW5kDQo+IGNvbnZlcnRlZCBpbnRvIFNLQiBpbiBjb3JlLWNvZGUgKHllcywgdGhlcmUg
aXMgYSBsb25nIHJvYWQtYWhlYWQpLg0KPiBUaGUNCj4gbGFyZ2VyIHRhaWxyb29tIGNhbiBiZSB1
c2VkIGJ5IG5ldHN0YWNrIGluIFNLQi1jb2FsZXNjZS4NCj4gDQoNCkJ1dCB0byBhY2hpZXZlIGEg
cHJvcGVyIG1vZGVsLCB0aGUgZHJpdmVycyBtdXN0IGJlIG5vdGlmaWVkIGFib3V0IHRoZQ0Kc2l6
ZSBvZiB0aGUgdGFpbHJvb20gdGhleSBtdXN0IHByZXNlcnZlLCBub3cgd2UgYXJlIGp1c3QgaGFy
ZGNvZGluZyBpdCwNCndoZXJlIGl0IGV2ZW4gZG9lc24ndCBiZWxvbmcuIEkgZG9uJ3Qga25vdyB3
aGF0IHRoZSByaWdodCBzb2x1dGlvbiB5ZXQuDQpidXQgd2UgYXJlIHN0aWxsIG5vdCB0aGVyZSAu
LiBvbmNlIHdlIHRvdGFsbHkgbW92ZSBtZW1vcnkgbWFuYWdlbWVudA0Kb3V0IG9mIHRoZSBkcml2
ZXIsIHRoZW4gd2UgbWlnaHQgaGF2ZSBhIGJldHRlciB3YXkgdG8gcHJlc2VydmUgaGVhZCBhbmQN
CnRhaWwtcm9vbSAuLiANCg0KPiBUaGUgbmV4dCBzdGVwIGlzIG1ha2luZyB4ZHBfYnVmZiAoYW5k
IHhkcF9mcmFtZSkgbXVsdGktYnVmZmVyIGF3YXJlLg0KPiBUaGlzIGlzIHdoeSBJIHJlc2VydmUg
cm9vbSBmb3Igc2tiX3NoYXJlZF9pbmZvLiAgSSBoYXZlIGNvbnNpZGVyZWQNCg0KdGhpcyBuZWVk
cyB0byBiZSBjYXJlZnVsbHkgY3JhZnRlZC4uIGFzIHdlIGRvbid0IHdhbnQgdG8gZW5kdXAgd2l0
aCBvbmUNCm1vcmUgU0tCIHR5cGUgdGhpbmcgdG8gZGVhbCB3aXRoLi4gDQoNCg0KPiByZWR1Y2lu
ZyB0aGUgc2l6ZSBvZiB4ZHBfYnVmZi5mcmFtZV9zeiwgd2l0aCBzaXplb2Yoc2tiX3NoYXJlZF9p
bmZvKSwNCj4gYnV0IGl0IGdvdCBraW5kIG9mIHVnbHkgaGF2aW5nIHRoaXMgaW4gZWFjaCBkcml2
ZXJzLg0KPiANCg0KY2FuIGJlIGRvbmUgdmlhIG1lbW9yeSBtb2RlbCByZWdpc3RyYXRpb24gPw0K
DQo+IEkgYWxzbyBjb25zaWRlcmVkIGhhdmluZyBkcml2ZXJzIHNldHVwIGEgZGlyZWN0IHBvaW50
ZXIgdG8NCj4ge3NrYix4ZHB9X3NoYXJlZF9pbmZvIHNlY3Rpb24gaW4geGRwX2J1ZmYsIGJlY2F1
c2Ugd2lsbCBtYWtlIGl0IG1vcmUNCj4gZmxleGlibGUgKGZvciB3aGF0IEkgaW1hZ2luZWQgQWxl
eGFuZGVyIER1eWNrIHdhbnQpLiAgKEJ1dCB3ZSBjYW4NCj4gc3RpbGwNCj4gZG8vY2hhbmdlIHRo
YXQgbGF0ZXIsIG9uY2Ugd2Ugc3RhcnQgd29yayBpbiBtdWx0aS1idWZmZXIgY29kZSkNCj4gDQoN
CnlvdSBtZWFuIHNvbWV0aGluZyBsaWtlIHhkcC0+ZGF0YV90YWlsIG9yIHhkcC0+ZGF0YV9oYXJk
X2VuZCA/DQo=
