Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 609FC288109
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 06:12:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728125AbgJIEMt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 00:12:49 -0400
Received: from mail-eopbgr60112.outbound.protection.outlook.com ([40.107.6.112]:57262
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725900AbgJIEMs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Oct 2020 00:12:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZMz/MAUnE/y8KOx6Rft4mJz9VfNC4/VJdR/NaRg2tGwiJjOGvsDdHkrlRg1RfKkPXjE6U+jQbEcyxnu2kibE9TJRmG6wcGOPWp1xEamcRwSMxsp6Lq8kJ19tlQEMYp9Ti/vlp6E7/Faj9hJNmzOSzfVTOLHH3dryxBDeTgVB8ldbMAwwVavD02fSjhakgAnbxEa7+IcX2XZ/otLfcbJhyvc7DJXU+nQyi2amyZBaF79m2suYMfyHXLcQNGiDCg4fCvPrPncSZ48xVaRw4L0jhFtWCgCo47HpY8W+zFlQaxj2D/OdJ0J0OxynbWUqbbPAHGmp6NzoQWYLJkQ/e2Kl5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1YaSUDehbW6PKIhcuPbM1NIXb2+0pw66HB5VZSovBv8=;
 b=cBZVSN3U1QTUzcZ0zWaxmnWeOkSriAC+Z6WahuYkpvtBHQ1QPUjBd3XU1Da3WpaBti/f//4OXP/gwn51iTWHd2a4ZECsd17Zx3NBmeKHbQosQeIdW7gh1pO39qGxE8o2C5a/30u+W6M2bZ+fhh6LHFuudWlD30E//y5nbOEOu5vrgKdbeUptHfjb4E1dlyLqrVw2mzH/aDP3i/ZN3Vhdl8OXu07rCspi8jRq01Dvoz0yNNHHCa2vv3l1t7qVB0LKw3EmTrWYLDwIiX9Ply6t3Rn8HtOpOE+E2p/4K78PO9N2BTWQwPdwsLDIXlPxZZCkp+SU8dxJxnoNYfBpWICuRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=dektech.com.au; dmarc=pass action=none
 header.from=dektech.com.au; dkim=pass header.d=dektech.com.au; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dektech.com.au;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1YaSUDehbW6PKIhcuPbM1NIXb2+0pw66HB5VZSovBv8=;
 b=CW+DJR2hIpHU6J7toDPSt1YeA7gCwYztsPrib/3VcCcWu8wmkciFIPttQTc+aPK095NClcJnAxsBGNIxbruvebkQNqdgUsHGETZjvHj5K+bE1WIFTeCPI9Knek0n1W0yTZHOKn/8TwbqRtUlZUR9xfFowinsm5SEPCagVcoAbFU=
Received: from VI1PR05MB4605.eurprd05.prod.outlook.com (2603:10a6:802:61::21)
 by VI1PR05MB7085.eurprd05.prod.outlook.com (2603:10a6:800:18e::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.23; Fri, 9 Oct
 2020 04:12:43 +0000
Received: from VI1PR05MB4605.eurprd05.prod.outlook.com
 ([fe80::2459:8421:b4ec:dcb4]) by VI1PR05MB4605.eurprd05.prod.outlook.com
 ([fe80::2459:8421:b4ec:dcb4%6]) with mapi id 15.20.3433.045; Fri, 9 Oct 2020
 04:12:42 +0000
From:   Hoang Huu Le <hoang.h.le@dektech.com.au>
To:     Jon Maloy <jmaloy@redhat.com>, Jakub Kicinski <kuba@kernel.org>
CC:     "maloy@donjonn.com" <maloy@donjonn.com>,
        "ying.xue@windriver.com" <ying.xue@windriver.com>,
        "tipc-discussion@lists.sourceforge.net" 
        <tipc-discussion@lists.sourceforge.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [net] tipc: fix NULL pointer dereference in tipc_named_rcv
Thread-Topic: [net] tipc: fix NULL pointer dereference in tipc_named_rcv
Thread-Index: AQHWnUUhvciD4HDbCEW3m8IXW2vJuamN9WwAgAAJ5oCAAKeUcA==
Date:   Fri, 9 Oct 2020 04:12:42 +0000
Message-ID: <VI1PR05MB46058487F5FE43F6ED539355F1080@VI1PR05MB4605.eurprd05.prod.outlook.com>
References: <20201008073156.116136-1-hoang.h.le@dektech.com.au>
 <20201008102514.1184c315@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <54320213-5b9b-4648-fa6b-553d2acb298e@redhat.com>
In-Reply-To: <54320213-5b9b-4648-fa6b-553d2acb298e@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=dektech.com.au;
x-originating-ip: [14.161.14.188]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8765c2ff-9d4b-4301-98fd-08d86c0991d2
x-ms-traffictypediagnostic: VI1PR05MB7085:
x-microsoft-antispam-prvs: <VI1PR05MB7085099679825405DBFA9470F1080@VI1PR05MB7085.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2887;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PGhxsBTd4fcFF6eBKaiCk/0PiKQEv6eELoGYr4m73Xtxz5eW5L5FX7zoHwxqPXXKG5CwfyiIfD2qjFCW2g/ZOhTlik8aT6C7joKMmldHajAymUD23JVWjblSietRf3ONrE0VaZ3EkrvI/O+1hPFo1Djq48cXWpcqL2UVBuShifwoGDuMntUUQiRa4TeYcemVyvyzODCXgDQ0l/sQWoT4wgUKzdsb6oF8S9DJrn6klTYM9MNBziichXK+GgFbldIGTkdZ5Y8j19ygaeXjDhaflf4nV71QOeCEzCw4CQxWoNe5qCjwUOvSvdz5wZQms63E
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB4605.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(136003)(366004)(396003)(39840400004)(9686003)(4326008)(8676002)(83380400001)(76116006)(52536014)(2906002)(86362001)(5660300002)(66556008)(66476007)(66946007)(8936002)(71200400001)(66446008)(64756008)(54906003)(26005)(53546011)(6506007)(7696005)(478600001)(110136005)(33656002)(316002)(186003)(55016002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: /SiZ9Iy33I475psnvND8U+sCVzKdhrbAS0Pt4a1M1sbbVvZvj4my3ZRFWpSjVbRgaJQrk5dmdVSTsZYTpqKFyEUuvPCDZDS9lyVDxpLftvpKsu+1FCn6qXoP0wjgZwVCP/m3qax2ZU6Ni/rSNx6zQH2Z8rLwRYFMV8BVg8KK6N266cjxDqqMGGkQCQoTS9dTNDwNSnubxhqug2cDpEmRlFAmUPr6yYDu23ltV6PfwFF/QiJjYSQEHGsKb3roFjb7/enQZcAmvLep03DuYaUSray0PyVeI7K+TpQD1Rvxq4LhXWQoNylnyx/iOLYrdWsTngiMqXJArcHM19Ct2NjK+TPDIzNjyeKkKxVpq47U3qod3Z7wD2YNNEsh9dPb2ivK/78hiDjBPRSiDzzzqtuOVtfK7B5Hiif0+IWlbQPOeODiacNuENGxw0yhqg9XdQqiL1Vmqku6j2J53xUPjzi/1GWu1zfZmGcbhmJH1QzBHWktFdxT2/aXWLv56PBCXvaWiAekd/3nOXAmN0be8S69YY7imdWGXGZZdb/KamB7UD5gblz4bvGK0erawr5674Qzw25EWNmkHTHO6Q2gwrnFmxqOeEaG2qJKcvcwH1p2PPeafE/Yi70elm+eH+Jex7zZeOFzTSz12aBF4rjt4WLBFQ==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: dektech.com.au
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB4605.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8765c2ff-9d4b-4301-98fd-08d86c0991d2
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Oct 2020 04:12:42.8509
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 1957ea50-0dd8-4360-8db0-c9530df996b2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vcgBdWjblk7pLhfxVHCf4wqE7jzbHDNM2qNT8Pf6NBsd50liocGG4tQzT0TSpOYUftOx17Y0hqDV9JNTf9XlEU3oxEYFjlcONpaQllY5Hew=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB7085
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgSm9uLCAgSmFrdWIsDQoNCkkgdHJpZWQgd2l0aCB5b3VyIGNvbW1lbnQuIEJ1dCBsb29rcyBs
aWtlIHdlIGdvdCBpbnRvIGNpcmN1bGFyIGxvY2tpbmcgYW5kIGRlYWRsb2NrIGNvdWxkIGhhcHBl
biBsaWtlIHRoaXM6DQogICAgICAgIENQVTAgICAgICAgICAgICAgICAgICAgIENQVTENCiAgICAg
ICAgLS0tLSAgICAgICAgICAgICAgICAgICAgLS0tLQ0KICAgbG9jaygmbi0+bG9jayMyKTsNCiAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgbG9jaygmdG4tPm5hbWV0YmxfbG9jayk7DQog
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGxvY2soJm4tPmxvY2sjMik7DQogICBsb2Nr
KCZ0bi0+bmFtZXRibF9sb2NrKTsNCg0KICAqKiogREVBRExPQ0sgKioqDQoNClJlZ2FyZHMsDQpI
b2FuZw0KPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBKb24gTWFsb3kgPGpt
YWxveUByZWRoYXQuY29tPg0KPiBTZW50OiBGcmlkYXksIE9jdG9iZXIgOSwgMjAyMCAxOjAxIEFN
DQo+IFRvOiBKYWt1YiBLaWNpbnNraSA8a3ViYUBrZXJuZWwub3JnPjsgSG9hbmcgSHV1IExlIDxo
b2FuZy5oLmxlQGRla3RlY2guY29tLmF1Pg0KPiBDYzogbWFsb3lAZG9uam9ubi5jb207IHlpbmcu
eHVlQHdpbmRyaXZlci5jb207IHRpcGMtZGlzY3Vzc2lvbkBsaXN0cy5zb3VyY2Vmb3JnZS5uZXQ7
IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmcNCj4gU3ViamVjdDogUmU6IFtuZXRdIHRpcGM6IGZpeCBO
VUxMIHBvaW50ZXIgZGVyZWZlcmVuY2UgaW4gdGlwY19uYW1lZF9yY3YNCj4gDQo+IA0KPiANCj4g
T24gMTAvOC8yMCAxOjI1IFBNLCBKYWt1YiBLaWNpbnNraSB3cm90ZToNCj4gPiBPbiBUaHUsICA4
IE9jdCAyMDIwIDE0OjMxOjU2ICswNzAwIEhvYW5nIEh1dSBMZSB3cm90ZToNCj4gPj4gZGlmZiAt
LWdpdCBhL25ldC90aXBjL25hbWVfZGlzdHIuYyBiL25ldC90aXBjL25hbWVfZGlzdHIuYw0KPiA+
PiBpbmRleCAyZjljMTQ4ZjE3ZTIuLmZlNGVkY2U0NTlhZCAxMDA2NDQNCj4gPj4gLS0tIGEvbmV0
L3RpcGMvbmFtZV9kaXN0ci5jDQo+ID4+ICsrKyBiL25ldC90aXBjL25hbWVfZGlzdHIuYw0KPiA+
PiBAQCAtMzI3LDggKzMyNywxMyBAQCBzdGF0aWMgc3RydWN0IHNrX2J1ZmYgKnRpcGNfbmFtZWRf
ZGVxdWV1ZShzdHJ1Y3Qgc2tfYnVmZl9oZWFkICpuYW1lZHEsDQo+ID4+ICAgCXN0cnVjdCB0aXBj
X21zZyAqaGRyOw0KPiA+PiAgIAl1MTYgc2Vxbm87DQo+ID4+DQo+ID4+ICsJc3Bpbl9sb2NrX2Jo
KCZuYW1lZHEtPmxvY2spOw0KPiA+PiAgIAlza2JfcXVldWVfd2Fsa19zYWZlKG5hbWVkcSwgc2ti
LCB0bXApIHsNCj4gPj4gLQkJc2tiX2xpbmVhcml6ZShza2IpOw0KPiA+PiArCQlpZiAodW5saWtl
bHkoc2tiX2xpbmVhcml6ZShza2IpKSkgew0KPiA+PiArCQkJX19za2JfdW5saW5rKHNrYiwgbmFt
ZWRxKTsNCj4gPj4gKwkJCWtmcmVlX3NrYihza2IpOw0KPiA+PiArCQkJY29udGludWU7DQo+ID4+
ICsJCX0NCj4gPj4gICAJCWhkciA9IGJ1Zl9tc2coc2tiKTsNCj4gPj4gICAJCXNlcW5vID0gbXNn
X25hbWVkX3NlcW5vKGhkcik7DQo+ID4+ICAgCQlpZiAobXNnX2lzX2xhc3RfYnVsayhoZHIpKSB7
DQo+ID4+IEBAIC0zMzgsMTIgKzM0MywxNCBAQCBzdGF0aWMgc3RydWN0IHNrX2J1ZmYgKnRpcGNf
bmFtZWRfZGVxdWV1ZShzdHJ1Y3Qgc2tfYnVmZl9oZWFkICpuYW1lZHEsDQo+ID4+DQo+ID4+ICAg
CQlpZiAobXNnX2lzX2J1bGsoaGRyKSB8fCBtc2dfaXNfbGVnYWN5KGhkcikpIHsNCj4gPj4gICAJ
CQlfX3NrYl91bmxpbmsoc2tiLCBuYW1lZHEpOw0KPiA+PiArCQkJc3Bpbl91bmxvY2tfYmgoJm5h
bWVkcS0+bG9jayk7DQo+ID4+ICAgCQkJcmV0dXJuIHNrYjsNCj4gPj4gICAJCX0NCj4gPj4NCj4g
Pj4gICAJCWlmICgqb3BlbiAmJiAoKnJjdl9ueHQgPT0gc2Vxbm8pKSB7DQo+ID4+ICAgCQkJKCpy
Y3Zfbnh0KSsrOw0KPiA+PiAgIAkJCV9fc2tiX3VubGluayhza2IsIG5hbWVkcSk7DQo+ID4+ICsJ
CQlzcGluX3VubG9ja19iaCgmbmFtZWRxLT5sb2NrKTsNCj4gPj4gICAJCQlyZXR1cm4gc2tiOw0K
PiA+PiAgIAkJfQ0KPiA+Pg0KPiA+PiBAQCAtMzUzLDYgKzM2MCw3IEBAIHN0YXRpYyBzdHJ1Y3Qg
c2tfYnVmZiAqdGlwY19uYW1lZF9kZXF1ZXVlKHN0cnVjdCBza19idWZmX2hlYWQgKm5hbWVkcSwN
Cj4gPj4gICAJCQljb250aW51ZTsNCj4gPj4gICAJCX0NCj4gPj4gICAJfQ0KPiA+PiArCXNwaW5f
dW5sb2NrX2JoKCZuYW1lZHEtPmxvY2spOw0KPiA+PiAgIAlyZXR1cm4gTlVMTDsNCj4gPj4gICB9
DQo+ID4+DQo+ID4+IGRpZmYgLS1naXQgYS9uZXQvdGlwYy9ub2RlLmMgYi9uZXQvdGlwYy9ub2Rl
LmMNCj4gPj4gaW5kZXggY2Y0YjIzOWZjNTY5Li5kMjY5ZWJlMzgyZTEgMTAwNjQ0DQo+ID4+IC0t
LSBhL25ldC90aXBjL25vZGUuYw0KPiA+PiArKysgYi9uZXQvdGlwYy9ub2RlLmMNCj4gPj4gQEAg
LTE0OTYsNyArMTQ5Niw3IEBAIHN0YXRpYyB2b2lkIG5vZGVfbG9zdF9jb250YWN0KHN0cnVjdCB0
aXBjX25vZGUgKm4sDQo+ID4+DQo+ID4+ICAgCS8qIENsZWFuIHVwIGJyb2FkY2FzdCBzdGF0ZSAq
Lw0KPiA+PiAgIAl0aXBjX2JjYXN0X3JlbW92ZV9wZWVyKG4tPm5ldCwgbi0+YmNfZW50cnkubGlu
ayk7DQo+ID4+IC0JX19za2JfcXVldWVfcHVyZ2UoJm4tPmJjX2VudHJ5Lm5hbWVkcSk7DQo+ID4+
ICsJc2tiX3F1ZXVlX3B1cmdlKCZuLT5iY19lbnRyeS5uYW1lZHEpOw0KPiA+IFBhdGNoIGxvb2tz
IGZpbmUsIGJ1dCBJJ20gbm90IHN1cmUgd2h5IG5vdCBob2xkDQo+ID4gc3Bpbl91bmxvY2tfYmgo
JnRuLT5uYW1ldGJsX2xvY2spIGhlcmUgaW5zdGVhZD8NCj4gPg0KPiA+IFNlZW1zIGxpa2Ugbm9k
ZV9sb3N0X2NvbnRhY3QoKSBzaG91bGQgYmUgcmVsYXRpdmVseSByYXJlLA0KPiA+IHNvIGFkZGlu
ZyBhbm90aGVyIGxvY2sgdG8gdGlwY19uYW1lZF9kZXF1ZXVlKCkgaXMgbm90IHRoZQ0KPiA+IHJp
Z2h0IHRyYWRlIG9mZi4NCj4gQWN0dWFsbHksIEkgYWdyZWUgd2l0aCBwcmV2aW91cyBzcGVha2Vy
IGhlcmUuIFdlIGFscmVhZHkgaGF2ZSB0aGUNCj4gbmFtZXRibF9sb2NrIHdoZW4gdGlwY19uYW1l
ZF9kZXF1ZXVlKCkgaXMgY2FsbGVkLCBhbmQgdGhlIHNhbWUgbG9jayBpcw0KPiBhY2Nlc3NpYmxl
IGZyb20gbm8uYyB3aGVyZSBub2RlX2xvc3RfY29udGFjdCgpIGlzIGV4ZWN1dGVkLiBUaGUgcGF0
Y2gNCj4gYW5kIHRoZSBjb2RlIGJlY29tZXMgc2ltcGxlci4NCj4gSSBzdWdnZXN0IHlvdSBwb3N0
IGEgdjIgb2YgdGhpcyBvbmUuDQo+IA0KPiAvLy9qb24NCj4gDQo+ID4+ICAgCS8qIEFib3J0IGFu
eSBvbmdvaW5nIGxpbmsgZmFpbG92ZXIgKi8NCj4gPj4gICAJZm9yIChpID0gMDsgaSA8IE1BWF9C
RUFSRVJTOyBpKyspIHsNCg0K
