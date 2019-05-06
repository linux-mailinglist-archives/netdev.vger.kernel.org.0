Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40A9414B1B
	for <lists+netdev@lfdr.de>; Mon,  6 May 2019 15:45:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726095AbfEFNps (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 May 2019 09:45:48 -0400
Received: from mail-eopbgr20053.outbound.protection.outlook.com ([40.107.2.53]:3813
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725853AbfEFNps (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 May 2019 09:45:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F7WSOS8+POP1rDb6A/p4VBkZAX7Fj3taiNQe47/7g7w=;
 b=rQ0TKBJXq+cfDsrXNGa9wG7JWXTODwLw7TX/momQeHJCimmhP5Z+L12WHVMRxXO5EB3UAjKzRPDubawypUW8IGmX3C8GQnjj8Loz0eMlQYIvSZAooEcIMvz5ppTotlnborIxM0Rfaot/svHFkGwT/jSqGgRhQOVeZvr3XNoEBko=
Received: from AM6PR05MB5879.eurprd05.prod.outlook.com (20.179.0.76) by
 AM6PR05MB6183.eurprd05.prod.outlook.com (20.178.86.205) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1856.10; Mon, 6 May 2019 13:45:40 +0000
Received: from AM6PR05MB5879.eurprd05.prod.outlook.com
 ([fe80::cc18:150a:7740:1e2f]) by AM6PR05MB5879.eurprd05.prod.outlook.com
 ([fe80::cc18:150a:7740:1e2f%2]) with mapi id 15.20.1856.012; Mon, 6 May 2019
 13:45:40 +0000
From:   Maxim Mikityanskiy <maximmi@mellanox.com>
To:     =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>
CC:     Daniel Borkmann <daniel@iogearbox.net>,
        =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Jonathan Lemon <bsd@fb.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Maciej Fijalkowski <maciejromanfijalkowski@gmail.com>
Subject: Re: [PATCH bpf-next v2 02/16] xsk: Add getsockopt XDP_OPTIONS
Thread-Topic: [PATCH bpf-next v2 02/16] xsk: Add getsockopt XDP_OPTIONS
Thread-Index: AQHU/4BKnZIGLije30iWBScoq61BJqZbPdUAgALnJAA=
Date:   Mon, 6 May 2019 13:45:40 +0000
Message-ID: <f00130ea-86a8-355c-76fb-bd0bea389e62@mellanox.com>
References: <20190430181215.15305-1-maximmi@mellanox.com>
 <20190430181215.15305-3-maximmi@mellanox.com>
 <CAJ+HfNid2hFN6ECetptT+pRQhvPpbdm39zQT9O9xVthadeqQWg@mail.gmail.com>
In-Reply-To: <CAJ+HfNid2hFN6ECetptT+pRQhvPpbdm39zQT9O9xVthadeqQWg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM0PR01CA0048.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:e6::25) To AM6PR05MB5879.eurprd05.prod.outlook.com
 (2603:10a6:20b:a2::12)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=maximmi@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [95.67.35.250]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9c933388-c923-4be2-da1b-08d6d2292052
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:AM6PR05MB6183;
x-ms-traffictypediagnostic: AM6PR05MB6183:
x-microsoft-antispam-prvs: <AM6PR05MB6183F55D685E36C6B9F26BA8D1300@AM6PR05MB6183.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0029F17A3F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(376002)(136003)(346002)(396003)(39860400002)(189003)(199004)(316002)(110136005)(8936002)(7736002)(54906003)(71190400001)(6246003)(71200400001)(25786009)(102836004)(7416002)(76176011)(26005)(6506007)(386003)(53546011)(14454004)(31686004)(2906002)(186003)(305945005)(66574012)(36756003)(99286004)(4326008)(6436002)(6486002)(256004)(14444005)(53936002)(31696002)(229853002)(66556008)(5660300002)(66066001)(73956011)(66476007)(66946007)(52116002)(478600001)(64756008)(2616005)(66446008)(68736007)(476003)(6512007)(81166006)(81156014)(8676002)(11346002)(446003)(86362001)(486006)(6116002)(3846002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR05MB6183;H:AM6PR05MB5879.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: wItRIBchIyMWor4LZ/5uCVx45lgT4F3VACuuhJy7aCuL8diuMol751XLG1E0Un++bgg02HxWIxpIMaE2SKfr+rB1oOL3iuzHrf6iOSAzHrh7Gjn9EXpHkf1QMvOdaoOlc3bPpHCXtoLVPJHZN1Cdx2RTB+qpfz5S+AgIbqrSWNwujdzyuD6Qs06C6QDK17+DvAFyvTrQFA1mOSdI7BJq+JjJJdOUox88urJ/4QcSyDKlakB94anPWEMY1059QsTj/SSCNDN6qLUePhWudiE6fWqderEYoARvblwpYYUxSCcMfVaM1XDu0i6BhDeZVjdVHMqXk1nNF6JVUbwhpQjZj7vPpz1fawfybxEuv2UczBQex81/0bHBLtZQl8kNHVky8UPMe+OQ6oNhvfL3wZByoU2nBiMtA/+963AWF7nhh1c=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1A21E3991AACB1408A0C39E345BC47D9@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c933388-c923-4be2-da1b-08d6d2292052
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 May 2019 13:45:40.0228
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB6183
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMjAxOS0wNS0wNCAyMDoyNSwgQmrDtnJuIFTDtnBlbCB3cm90ZToNCj4gT24gVHVlLCAzMCBB
cHIgMjAxOSBhdCAyMDoxMiwgTWF4aW0gTWlraXR5YW5za2l5IDxtYXhpbW1pQG1lbGxhbm94LmNv
bT4gd3JvdGU6DQo+Pg0KPj4gTWFrZSBpdCBwb3NzaWJsZSBmb3IgdGhlIGFwcGxpY2F0aW9uIHRv
IGRldGVybWluZSB3aGV0aGVyIHRoZSBBRl9YRFANCj4+IHNvY2tldCBpcyBydW5uaW5nIGluIHpl
cm8tY29weSBtb2RlLiBUbyBhY2hpZXZlIHRoaXMsIGFkZCBhIG5ldw0KPj4gZ2V0c29ja29wdCBv
cHRpb24gWERQX09QVElPTlMgdGhhdCByZXR1cm5zIGZsYWdzLiBUaGUgb25seSBmbGFnDQo+PiBz
dXBwb3J0ZWQgZm9yIG5vdyBpcyB0aGUgemVyby1jb3B5IG1vZGUgaW5kaWNhdG9yLg0KPj4NCj4+
IFNpZ25lZC1vZmYtYnk6IE1heGltIE1pa2l0eWFuc2tpeSA8bWF4aW1taUBtZWxsYW5veC5jb20+
DQo+PiBSZXZpZXdlZC1ieTogVGFyaXEgVG91a2FuIDx0YXJpcXRAbWVsbGFub3guY29tPg0KPj4g
QWNrZWQtYnk6IFNhZWVkIE1haGFtZWVkIDxzYWVlZG1AbWVsbGFub3guY29tPg0KPj4gLS0tDQo+
PiAgIGluY2x1ZGUvdWFwaS9saW51eC9pZl94ZHAuaCAgICAgICB8ICA3ICsrKysrKysNCj4+ICAg
bmV0L3hkcC94c2suYyAgICAgICAgICAgICAgICAgICAgIHwgMjIgKysrKysrKysrKysrKysrKysr
KysrKw0KPj4gICB0b29scy9pbmNsdWRlL3VhcGkvbGludXgvaWZfeGRwLmggfCAgNyArKysrKysr
DQo+PiAgIDMgZmlsZXMgY2hhbmdlZCwgMzYgaW5zZXJ0aW9ucygrKQ0KPj4NCj4+IGRpZmYgLS1n
aXQgYS9pbmNsdWRlL3VhcGkvbGludXgvaWZfeGRwLmggYi9pbmNsdWRlL3VhcGkvbGludXgvaWZf
eGRwLmgNCj4+IGluZGV4IGNhZWQ4YjE2MTRmZi4uOWFlNGI0ZTA4YjY4IDEwMDY0NA0KPj4gLS0t
IGEvaW5jbHVkZS91YXBpL2xpbnV4L2lmX3hkcC5oDQo+PiArKysgYi9pbmNsdWRlL3VhcGkvbGlu
dXgvaWZfeGRwLmgNCj4+IEBAIC00Niw2ICs0Niw3IEBAIHN0cnVjdCB4ZHBfbW1hcF9vZmZzZXRz
IHsNCj4+ICAgI2RlZmluZSBYRFBfVU1FTV9GSUxMX1JJTkcgICAgICAgICAgICAgNQ0KPj4gICAj
ZGVmaW5lIFhEUF9VTUVNX0NPTVBMRVRJT05fUklORyAgICAgICA2DQo+PiAgICNkZWZpbmUgWERQ
X1NUQVRJU1RJQ1MgICAgICAgICAgICAgICAgIDcNCj4+ICsjZGVmaW5lIFhEUF9PUFRJT05TICAg
ICAgICAgICAgICAgICAgICA4DQo+Pg0KPj4gICBzdHJ1Y3QgeGRwX3VtZW1fcmVnIHsNCj4+ICAg
ICAgICAgIF9fdTY0IGFkZHI7IC8qIFN0YXJ0IG9mIHBhY2tldCBkYXRhIGFyZWEgKi8NCj4+IEBA
IC02MCw2ICs2MSwxMiBAQCBzdHJ1Y3QgeGRwX3N0YXRpc3RpY3Mgew0KPj4gICAgICAgICAgX191
NjQgdHhfaW52YWxpZF9kZXNjczsgLyogRHJvcHBlZCBkdWUgdG8gaW52YWxpZCBkZXNjcmlwdG9y
ICovDQo+PiAgIH07DQo+Pg0KPj4gK3N0cnVjdCB4ZHBfb3B0aW9ucyB7DQo+PiArICAgICAgIF9f
dTMyIGZsYWdzOw0KPj4gK307DQo+PiArDQo+PiArI2RlZmluZSBYRFBfT1BUSU9OU19GTEFHX1pF
Uk9DT1BZICgxIDw8IDApDQo+IA0KPiBOaXQ6IFRoZSBvdGhlciBmbGFncyBkb2Vzbid0IHVzZSAi
RkxBRyIgaW4gaXRzIG5hbWUsIGJ1dCB0aGF0IGRvZXNuJ3QNCj4gcmVhbGx5IG1hdHRlci4NCj4g
DQo+PiArDQo+PiAgIC8qIFBnb2ZmIGZvciBtbWFwaW5nIHRoZSByaW5ncyAqLw0KPj4gICAjZGVm
aW5lIFhEUF9QR09GRl9SWF9SSU5HICAgICAgICAgICAgICAgICAgICAgICAgMA0KPj4gICAjZGVm
aW5lIFhEUF9QR09GRl9UWF9SSU5HICAgICAgICAgICAgICAgMHg4MDAwMDAwMA0KPj4gZGlmZiAt
LWdpdCBhL25ldC94ZHAveHNrLmMgYi9uZXQveGRwL3hzay5jDQo+PiBpbmRleCBiNjhhMzgwZjUw
YjMuLjk5ODE5OTEwOWQ1YyAxMDA2NDQNCj4+IC0tLSBhL25ldC94ZHAveHNrLmMNCj4+ICsrKyBi
L25ldC94ZHAveHNrLmMNCj4+IEBAIC02NTAsNiArNjUwLDI4IEBAIHN0YXRpYyBpbnQgeHNrX2dl
dHNvY2tvcHQoc3RydWN0IHNvY2tldCAqc29jaywgaW50IGxldmVsLCBpbnQgb3B0bmFtZSwNCj4+
DQo+PiAgICAgICAgICAgICAgICAgIHJldHVybiAwOw0KPj4gICAgICAgICAgfQ0KPj4gKyAgICAg
ICBjYXNlIFhEUF9PUFRJT05TOg0KPj4gKyAgICAgICB7DQo+PiArICAgICAgICAgICAgICAgc3Ry
dWN0IHhkcF9vcHRpb25zIG9wdHM7DQo+PiArDQo+PiArICAgICAgICAgICAgICAgaWYgKGxlbiA8
IHNpemVvZihvcHRzKSkNCj4+ICsgICAgICAgICAgICAgICAgICAgICAgIHJldHVybiAtRUlOVkFM
Ow0KPj4gKw0KPj4gKyAgICAgICAgICAgICAgIG9wdHMuZmxhZ3MgPSAwOw0KPiANCj4gTWF5YmUg
Z2V0IHJpZCBvZiB0aGlzLCBpbiBmYXZvciBvZiAib3B0cyA9IHt9IiBpZiB0aGUgc3RydWN0dXJl
IGdyb3dzPw0KDQpJJ20gT0sgd2l0aCBhbnkgb2YgdGhlc2Ugb3B0aW9ucy4gU2hvdWxkIEkgcmVz
cGluIHRoZSBzZXJpZXMsIG9yIGNhbiBJIA0KZm9sbG93IHVwIHdpdGggdGhlIGNoYW5nZSBpbiBS
Q3MgaWYgdGhlIHNlcmllcyBnZXRzIHRvIDUuMj8NCg0KQWxleGVpLCBpcyBpdCBldmVuIHBvc3Np
YmxlIHRvIHN0aWxsIG1ha2UgY2hhbmdlcyB0byB0aGlzIHNlcmllcz8gVGhlIA0Kd2luZG93IGFw
cGVhcnMgY2xvc2VkLg0KDQo+IA0KPj4gKw0KPj4gKyAgICAgICAgICAgICAgIG11dGV4X2xvY2so
JnhzLT5tdXRleCk7DQo+PiArICAgICAgICAgICAgICAgaWYgKHhzLT56YykNCj4+ICsgICAgICAg
ICAgICAgICAgICAgICAgIG9wdHMuZmxhZ3MgfD0gWERQX09QVElPTlNfRkxBR19aRVJPQ09QWTsN
Cj4+ICsgICAgICAgICAgICAgICBtdXRleF91bmxvY2soJnhzLT5tdXRleCk7DQo+PiArDQo+PiAr
ICAgICAgICAgICAgICAgbGVuID0gc2l6ZW9mKG9wdHMpOw0KPj4gKyAgICAgICAgICAgICAgIGlm
IChjb3B5X3RvX3VzZXIob3B0dmFsLCAmb3B0cywgbGVuKSkNCj4+ICsgICAgICAgICAgICAgICAg
ICAgICAgIHJldHVybiAtRUZBVUxUOw0KPj4gKyAgICAgICAgICAgICAgIGlmIChwdXRfdXNlcihs
ZW4sIG9wdGxlbikpDQo+PiArICAgICAgICAgICAgICAgICAgICAgICByZXR1cm4gLUVGQVVMVDsN
Cj4+ICsNCj4+ICsgICAgICAgICAgICAgICByZXR1cm4gMDsNCj4+ICsgICAgICAgfQ0KPj4gICAg
ICAgICAgZGVmYXVsdDoNCj4+ICAgICAgICAgICAgICAgICAgYnJlYWs7DQo+PiAgICAgICAgICB9
DQo+PiBkaWZmIC0tZ2l0IGEvdG9vbHMvaW5jbHVkZS91YXBpL2xpbnV4L2lmX3hkcC5oIGIvdG9v
bHMvaW5jbHVkZS91YXBpL2xpbnV4L2lmX3hkcC5oDQo+PiBpbmRleCBjYWVkOGIxNjE0ZmYuLjlh
ZTRiNGUwOGI2OCAxMDA2NDQNCj4+IC0tLSBhL3Rvb2xzL2luY2x1ZGUvdWFwaS9saW51eC9pZl94
ZHAuaA0KPj4gKysrIGIvdG9vbHMvaW5jbHVkZS91YXBpL2xpbnV4L2lmX3hkcC5oDQo+PiBAQCAt
NDYsNiArNDYsNyBAQCBzdHJ1Y3QgeGRwX21tYXBfb2Zmc2V0cyB7DQo+PiAgICNkZWZpbmUgWERQ
X1VNRU1fRklMTF9SSU5HICAgICAgICAgICAgIDUNCj4+ICAgI2RlZmluZSBYRFBfVU1FTV9DT01Q
TEVUSU9OX1JJTkcgICAgICAgNg0KPj4gICAjZGVmaW5lIFhEUF9TVEFUSVNUSUNTICAgICAgICAg
ICAgICAgICA3DQo+PiArI2RlZmluZSBYRFBfT1BUSU9OUyAgICAgICAgICAgICAgICAgICAgOA0K
Pj4NCj4+ICAgc3RydWN0IHhkcF91bWVtX3JlZyB7DQo+PiAgICAgICAgICBfX3U2NCBhZGRyOyAv
KiBTdGFydCBvZiBwYWNrZXQgZGF0YSBhcmVhICovDQo+PiBAQCAtNjAsNiArNjEsMTIgQEAgc3Ry
dWN0IHhkcF9zdGF0aXN0aWNzIHsNCj4+ICAgICAgICAgIF9fdTY0IHR4X2ludmFsaWRfZGVzY3M7
IC8qIERyb3BwZWQgZHVlIHRvIGludmFsaWQgZGVzY3JpcHRvciAqLw0KPj4gICB9Ow0KPj4NCj4+
ICtzdHJ1Y3QgeGRwX29wdGlvbnMgew0KPj4gKyAgICAgICBfX3UzMiBmbGFnczsNCj4+ICt9Ow0K
Pj4gKw0KPj4gKyNkZWZpbmUgWERQX09QVElPTlNfRkxBR19aRVJPQ09QWSAoMSA8PCAwKQ0KPj4g
Kw0KPj4gICAvKiBQZ29mZiBmb3IgbW1hcGluZyB0aGUgcmluZ3MgKi8NCj4+ICAgI2RlZmluZSBY
RFBfUEdPRkZfUlhfUklORyAgICAgICAgICAgICAgICAgICAgICAgIDANCj4+ICAgI2RlZmluZSBY
RFBfUEdPRkZfVFhfUklORyAgICAgICAgICAgICAgIDB4ODAwMDAwMDANCj4+IC0tDQo+PiAyLjE5
LjENCj4+DQoNCg==
