Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 112671A2D1A
	for <lists+netdev@lfdr.de>; Thu,  9 Apr 2020 02:50:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726638AbgDIAuG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Apr 2020 20:50:06 -0400
Received: from mail-eopbgr60070.outbound.protection.outlook.com ([40.107.6.70]:48190
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726536AbgDIAuF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Apr 2020 20:50:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QNCiD6ae9tPCp7t/O64psjgNH1nzIjqq7WxHCkJ6e4G4xSnQIsDoDhXmWHHa9B+BP7zNWR44J66ItilDMHoJQ074QPSOGMpjdUGZbtg672a/Bbi4v+QBclm4XngDkL59TMnbCQ0w/JGy7Vqo/I7yeZCoNa0LIY5AdEbnON/Mg4bEsyHN+By91Xy63YgWz5D8V56tNfJaGv676mKIE622jTWQWFN6FEtOOVOsQqgWsS48MvVJxKPi7F3fWI+0LPshhPjpTbk0FL3wAgH8gac3292b+hwszsKMQ3VtM6vZE/GRTJqMMfR9NkXPSuGBPKPTO1RSnHWKx9yjDGMzTxfabA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iHQ0H/fuiMhrH4DKZsSL4TecdQCfhs0Ou6GvyktY2iU=;
 b=b8f9C4OGJuzcUplHrmgl0wH2Dx/xMx48z8syEh3v996eYgalWvbpfkqUtKMw7tQbftIOsJ0GnAUBLsxEe8BcCMS9jtarZC6AOaHyamCDr0sC3eDHr8sIDEFKE2MZkeF7pvG6+bZnk4Hs6wpkjz0yMTWCuBhyt7fpF39oN/Td7Gz/a15BMxZCPVOtuDW9GxMTsHHpweS7XudQ0Tnd3wUsno0yOljI1+xqqgzAXc9glLi585/c4pTidF3ZJ5lgpt8O+oq/A7E68UBn7FYtsmLTy23zXA8Kxd7yGLpk8Pn4UIY+KKhdGHsJGkLirwkD0d3cWPX2gJ1hmgs9UdKdqalbhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iHQ0H/fuiMhrH4DKZsSL4TecdQCfhs0Ou6GvyktY2iU=;
 b=Z5rOnyLyvNfbXjETj1gimuSnZxbW+wojO/vtBBo9HsYoWq26KXGRDlP8Rr6SXAdgNzUQp0fxbH/qvYYCbsth5fD4RnQpR7I4k7OkzAxmyJo5YQiFXTanQb8HTWvVr+0l/JxwsbBruEGrJ9rRFl10xFl/5g0vlLaklghxXi3XSC4=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB6799.eurprd05.prod.outlook.com (2603:10a6:800:13e::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2878.20; Thu, 9 Apr
 2020 00:50:02 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19%7]) with mapi id 15.20.2878.021; Thu, 9 Apr 2020
 00:50:02 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "brouer@redhat.com" <brouer@redhat.com>,
        "sameehj@amazon.com" <sameehj@amazon.com>
CC:     "toke@redhat.com" <toke@redhat.com>,
        "gtzalik@amazon.com" <gtzalik@amazon.com>,
        "ilias.apalodimas@linaro.org" <ilias.apalodimas@linaro.org>,
        "borkmann@iogearbox.net" <borkmann@iogearbox.net>,
        "alexander.duyck@gmail.com" <alexander.duyck@gmail.com>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "akiyano@amazon.com" <akiyano@amazon.com>,
        "zorik@amazon.com" <zorik@amazon.com>,
        "alexei.starovoitov@gmail.com" <alexei.starovoitov@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "jeffrey.t.kirsher@intel.com" <jeffrey.t.kirsher@intel.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "dsahern@gmail.com" <dsahern@gmail.com>,
        "lorenzo@kernel.org" <lorenzo@kernel.org>,
        "willemdebruijn.kernel@gmail.com" <willemdebruijn.kernel@gmail.com>
Subject: Re: [PATCH RFC v2 01/33] xdp: add frame size to xdp_buff
Thread-Topic: [PATCH RFC v2 01/33] xdp: add frame size to xdp_buff
Thread-Index: AQHWDZv32mnm8kot3EKhksvfBkWZN6hv9mAA
Date:   Thu, 9 Apr 2020 00:50:02 +0000
Message-ID: <7fb99df47a9eae1fd0fc8dc85336f7df2c120744.camel@mellanox.com>
References: <158634658714.707275.7903484085370879864.stgit@firesoul>
         <158634663936.707275.3156718045905620430.stgit@firesoul>
In-Reply-To: <158634663936.707275.3156718045905620430.stgit@firesoul>
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
x-ms-office365-filtering-correlation-id: be7a498c-8e12-4045-5483-08d7dc1fefdf
x-ms-traffictypediagnostic: VI1PR05MB6799:
x-microsoft-antispam-prvs: <VI1PR05MB67992F56BA9594A4FC6E8543BEC10@VI1PR05MB6799.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0368E78B5B
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(366004)(396003)(376002)(39850400004)(136003)(346002)(66446008)(110136005)(91956017)(4326008)(66556008)(71200400001)(6506007)(6512007)(478600001)(2616005)(6486002)(81166007)(186003)(7416002)(86362001)(54906003)(36756003)(66946007)(5660300002)(76116006)(2906002)(26005)(8676002)(8936002)(316002)(81156014)(66476007)(64756008)(21314003);DIR:OUT;SFP:1101;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7IcgItQLbWBdcNOVH6fLhbMSwf79LCVez4ZwXUDAcX8w5z0xrihAXagF9B7oYaz9DITFc7GhIx2VJNk/zo06l6lINv5nfac+YYxvVTvQOR/xQOig/h2WIrI43MBYNFHPvfhq/w4NMS9lyEiiBCueno00lWmOX4kbUCmLH0oLUO4d/7ZZvS29aebiiNCAJ7wW9a8S5eiM8iY2VwolW49POl6jCJh21VtfefdjMi3lwoqi0fF/fIdyEJCBC7eppIMvOFvePV5fUo0vlRAottkja+q67mZjMt+VFrFN2+2yW9t2BP4cRJ0krH5yCKBgtgtnU9knfDfAx2rXDYabGlXYv9/UcN/itohr0ncsMjoA5PoBljZgk3g2ucEmjy5UOgYqcCOkZsrKxRMfCQvOv/p8y/Fry0IDlawIZNKiEnoozHieNg2+ouKHx97g0ILGnczB2yGuLBTxyuntg5BfXmfKKwfuk5+Fy/ewI81hjLVdQlhKDUNufI3X1YJIfOnsXay2
x-ms-exchange-antispam-messagedata: PftMVrkBNuGXyj3G+u0oKqRl6Vj8EXY62sxKleuCC/2ZAqCt1AkBoNiPFbhrO+K3CeLlEycplgwTBQ8vfn/wzbvrCW+2akxmLugaaCfgYsVUlnbx5hRQp3tVwW73khjR/plyftkYeT+ewV03Cci39g==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <91B44C443F1FD24C8A95609998A5779D@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: be7a498c-8e12-4045-5483-08d7dc1fefdf
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Apr 2020 00:50:02.2022
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mKXePKVhZuEDyEZVQ8ZeisjMPXSVNuZKnlQsll61E229GlX1bXpFU+6sEMhNSr/ZBJsGvSbquf+qBSp9lwv4gw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6799
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCAyMDIwLTA0LTA4IGF0IDEzOjUwICswMjAwLCBKZXNwZXIgRGFuZ2FhcmQgQnJvdWVy
IHdyb3RlOg0KPiBYRFAgaGF2ZSBldm9sdmVkIHRvIHN1cHBvcnQgc2V2ZXJhbCBmcmFtZSBzaXpl
cywgYnV0IHhkcF9idWZmIHdhcyBub3QNCj4gdXBkYXRlZCB3aXRoIHRoaXMgaW5mb3JtYXRpb24u
IFRoZSBmcmFtZSBzaXplIChmcmFtZV9zeikgbWVtYmVyIG9mDQo+IHhkcF9idWZmIGlzIGludHJv
ZHVjZWQgdG8ga25vdyB0aGUgcmVhbCBzaXplIG9mIHRoZSBtZW1vcnkgdGhlIGZyYW1lDQo+IGlz
DQo+IGRlbGl2ZXJlZCBpbi4NCj4gDQo+IFdoZW4gaW50cm9kdWNpbmcgdGhpcyBhbHNvIG1ha2Ug
aXQgY2xlYXIgdGhhdCBzb21lIHRhaWxyb29tIGlzDQo+IHJlc2VydmVkL3JlcXVpcmVkIHdoZW4g
Y3JlYXRpbmcgU0tCcyB1c2luZyBidWlsZF9za2IoKS4NCj4gDQo+IEl0IHdvdWxkIGFsc28gaGF2
ZSBiZWVuIGFuIG9wdGlvbiB0byBpbnRyb2R1Y2UgYSBwb2ludGVyIHRvDQo+IGRhdGFfaGFyZF9l
bmQgKHdpdGggcmVzZXJ2ZWQgb2Zmc2V0KS4gVGhlIGFkdmFudGFnZSB3aXRoIGZyYW1lX3N6IGlz
DQo+IHRoYXQgKGxpa2UgcnhxKSBkcml2ZXJzIG9ubHkgbmVlZCB0byBzZXR1cC9hc3NpZ24gdGhp
cyB2YWx1ZSBvbmNlIHBlcg0KPiBOQVBJIGN5Y2xlLiBEdWUgdG8gWERQLWdlbmVyaWMgKGFuZCBz
b21lIGRyaXZlcnMpIGl0J3Mgbm90IHBvc3NpYmxlDQo+IHRvDQo+IHN0b3JlIGZyYW1lX3N6IGlu
c2lkZSB4ZHBfcnhxX2luZm8sIGJlY2F1c2UgaXQncyB2YXJpZXMgcGVyIHBhY2tldCBhcw0KPiBp
dA0KPiBjYW4gYmUgYmFzZWQvZGVwZW5kIG9uIHBhY2tldCBsZW5ndGguDQo+IA0KPiBTaWduZWQt
b2ZmLWJ5OiBKZXNwZXIgRGFuZ2FhcmQgQnJvdWVyIDxicm91ZXJAcmVkaGF0LmNvbT4NCj4gLS0t
DQo+ICBpbmNsdWRlL25ldC94ZHAuaCB8ICAgMTcgKysrKysrKysrKysrKysrKysNCj4gIDEgZmls
ZSBjaGFuZ2VkLCAxNyBpbnNlcnRpb25zKCspDQo+IA0KPiBkaWZmIC0tZ2l0IGEvaW5jbHVkZS9u
ZXQveGRwLmggYi9pbmNsdWRlL25ldC94ZHAuaA0KPiBpbmRleCA0MGM2ZDMzOTg0NTguLjk5ZjQz
NzRmNjIxNCAxMDA2NDQNCj4gLS0tIGEvaW5jbHVkZS9uZXQveGRwLmgNCj4gKysrIGIvaW5jbHVk
ZS9uZXQveGRwLmgNCj4gQEAgLTYsNiArNiw4IEBADQo+ICAjaWZuZGVmIF9fTElOVVhfTkVUX1hE
UF9IX18NCj4gICNkZWZpbmUgX19MSU5VWF9ORVRfWERQX0hfXw0KPiAgDQo+ICsjaW5jbHVkZSA8
bGludXgvc2tidWZmLmg+IC8qIHNrYl9zaGFyZWRfaW5mbyAqLw0KPiArDQoNCkkgdGhpbmsgaXQg
aXMgd3JvbmcgdG8gbWFrZSB4ZHAuaCBkZXBlbmQgb24gc2tidWZmLmgNCndlIG11c3Qga2VlcCB4
ZHAuaCBtaW5pbWFsIGFuZCBpbmRlcGVuZGVudCwNCnRoZSBuZXcgbWFjcm9zIHNob3VsZCBiZSBk
ZWZpbmVkIGluIHNrYnVmZi5oIA0KDQo+ICAvKioNCj4gICAqIERPQzogWERQIFJYLXF1ZXVlIGlu
Zm9ybWF0aW9uDQo+ICAgKg0KPiBAQCAtNzAsOCArNzIsMjMgQEAgc3RydWN0IHhkcF9idWZmIHsN
Cj4gIAl2b2lkICpkYXRhX2hhcmRfc3RhcnQ7DQo+ICAJdW5zaWduZWQgbG9uZyBoYW5kbGU7DQo+
ICAJc3RydWN0IHhkcF9yeHFfaW5mbyAqcnhxOw0KPiArCXUzMiBmcmFtZV9zejsgLyogZnJhbWUg
c2l6ZSB0byBkZWR1Y3QgZGF0YV9oYXJkX2VuZC9yZXNlcnZlZA0KPiB0YWlscm9vbSovDQoNCndo
eSB1MzIgPyB1MTYgc2hvdWxkIGJlIG1vcmUgdGhhbiBlbm91Z2guLiANCg0KPiAgfTsNCj4gIA0K
PiArLyogUmVzZXJ2ZSBtZW1vcnkgYXJlYSBhdCBlbmQtb2YgZGF0YSBhcmVhLg0KPiArICoNCj4g
KyAqIFRoaXMgbWFjcm8gcmVzZXJ2ZXMgdGFpbHJvb20gaW4gdGhlIFhEUCBidWZmZXIgYnkgbGlt
aXRpbmcgdGhlDQo+ICsgKiBYRFAvQlBGIGRhdGEgYWNjZXNzIHRvIGRhdGFfaGFyZF9lbmQuICBO
b3RpY2Ugc2FtZSBhcmVhIChhbmQNCj4gc2l6ZSkNCj4gKyAqIGlzIHVzZWQgZm9yIFhEUF9QQVNT
LCB3aGVuIGNvbnN0cnVjdGluZyB0aGUgU0tCIHZpYSBidWlsZF9za2IoKS4NCj4gKyAqLw0KPiAr
I2RlZmluZSB4ZHBfZGF0YV9oYXJkX2VuZCh4ZHApCQkJCVwNCj4gKwkoKHhkcCktPmRhdGFfaGFy
ZF9zdGFydCArICh4ZHApLT5mcmFtZV9zeiAtCVwNCj4gKwkgU0tCX0RBVEFfQUxJR04oc2l6ZW9m
KHN0cnVjdCBza2Jfc2hhcmVkX2luZm8pKSkNCj4gKw0KDQp0aGlzIG1hY3JvIGlzIG5vdCBzYWZl
IHdoZW4gdW5hcnkgb3BlcmF0b3JzIGFyZSBiZWluZyB1c2VkDQoNCj4gKy8qIExpa2Ugc2tiX3No
aW5mbyAqLw0KPiArI2RlZmluZSB4ZHBfc2hpbmZvKHhkcCkJKChzdHJ1Y3Qgc2tiX3NoYXJlZF9p
bmZvDQo+ICopKHhkcF9kYXRhX2hhcmRfZW5kKHhkcCkpKQ0KPiArLy8gWFhYOiBBYm92ZSBsaWtl
bHkgYmVsb25ncyBpbiBsYXRlciBwYXRjaA0KPiArDQo+ICBzdHJ1Y3QgeGRwX2ZyYW1lIHsNCj4g
IAl2b2lkICpkYXRhOw0KPiAgCXUxNiBsZW47DQo+IA0KPiANCg==
