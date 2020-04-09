Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D8781A2D14
	for <lists+netdev@lfdr.de>; Thu,  9 Apr 2020 02:48:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726594AbgDIAsg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Apr 2020 20:48:36 -0400
Received: from mail-eopbgr60059.outbound.protection.outlook.com ([40.107.6.59]:25922
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726536AbgDIAsf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Apr 2020 20:48:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I0biihRoJfh4KiOLlSV+AHtePjjTN0H0M/apNu5svIKJlX+w2naW6WwTlFr2OksZdbd04VK4YuElBURNATQMFUkf6UY6ipRakCWQEzdoXzA9F2D2TNlOAj4Eo+QISP1JzywHolo2w83BQbNqbkAENsONRACYSasGBNmX3jcbAk7dAPfEwlnXelw0+yGhiLiz+cu8cxaBKmm0gZs6fFlqFjEEGqzBxNkqw5eegG+IKHJfjTUVavDr1C9GEuXDwx4VPhGokbEpoFJeNkDcNefopOvPlYCIQ4VJosjl63YF5/iFm6z0qvLKRhpDNtiMXQVNFXqyvco29LSI3UNuAlsHrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6r2W4JUk1ac7IQzpXz5J0W03iuc6i4Z2OpNOSWBxhng=;
 b=GQLzWOvSo6BahiFwCp/q0ChzqShEMUVoGqTv5wVpb5CDNh43W4vYqmDIIVV5NfdSgdbJccID+rNLBm7B3ZmNSu6i3yIHg9IvXTJBGYBq8sBBaUfK1tYrVvsSCsQ/jsGzz+bZGKLTFLCi7HYsMZLI6NjT5GaJxJjfvsXXWPezBiy7rfPj8yslc6Q3UzCOpwtYAwxBcVhztkQn/0F8XjE+ORv2h1oNvreUOab2bKEOl8c3IRuvxyYmA+Fg5Rpj13T40UY5d+YiB8gH3Am/zImkECaGQGMpSaqsxtFS+f8td3h/Wj3jpD+adf3rU52H7UhApZ0puH1+G7hivNC4vjzAOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6r2W4JUk1ac7IQzpXz5J0W03iuc6i4Z2OpNOSWBxhng=;
 b=F2bOb2xYSk66WUQ0Nk6HmDLA3SkDHVODUPgvipT/J31vSl0OZlgvZnPFIK7x+PCAOENHg6YJ5ufQKO22ViZjkLyyJ2CfExDwpXAHNbO9mo6XQNvJg37/pyke1VKB2Dbdf0fjYdLIWGv18A8SQB/2zDR6tisLc4eM+j/bOXb0j3k=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB6799.eurprd05.prod.outlook.com (2603:10a6:800:13e::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2878.20; Thu, 9 Apr
 2020 00:48:30 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19%7]) with mapi id 15.20.2878.021; Thu, 9 Apr 2020
 00:48:30 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "kuba@kernel.org" <kuba@kernel.org>,
        "brouer@redhat.com" <brouer@redhat.com>
CC:     "akiyano@amazon.com" <akiyano@amazon.com>,
        "willemdebruijn.kernel@gmail.com" <willemdebruijn.kernel@gmail.com>,
        "borkmann@iogearbox.net" <borkmann@iogearbox.net>,
        "jeffrey.t.kirsher@intel.com" <jeffrey.t.kirsher@intel.com>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "toke@redhat.com" <toke@redhat.com>,
        "alexei.starovoitov@gmail.com" <alexei.starovoitov@gmail.com>,
        "gtzalik@amazon.com" <gtzalik@amazon.com>,
        "dsahern@gmail.com" <dsahern@gmail.com>,
        "sameehj@amazon.com" <sameehj@amazon.com>,
        "alexander.duyck@gmail.com" <alexander.duyck@gmail.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "ilias.apalodimas@linaro.org" <ilias.apalodimas@linaro.org>,
        "zorik@amazon.com" <zorik@amazon.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "lorenzo@kernel.org" <lorenzo@kernel.org>
Subject: Re: [PATCH RFC v2 01/33] xdp: add frame size to xdp_buff
Thread-Topic: [PATCH RFC v2 01/33] xdp: add frame size to xdp_buff
Thread-Index: AQHWDZv32mnm8kot3EKhksvfBkWZN6hvggyAgABz5gA=
Date:   Thu, 9 Apr 2020 00:48:30 +0000
Message-ID: <a101ea0284504b65edcd8f83bd7a05747c6f8014.camel@mellanox.com>
References: <158634658714.707275.7903484085370879864.stgit@firesoul>
         <158634663936.707275.3156718045905620430.stgit@firesoul>
         <20200408105339.7d8d4e59@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20200408105339.7d8d4e59@kicinski-fedora-PC1C0HJN>
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
x-ms-office365-filtering-correlation-id: 54a95346-7e1a-4242-00e3-08d7dc1fb96e
x-ms-traffictypediagnostic: VI1PR05MB6799:
x-microsoft-antispam-prvs: <VI1PR05MB67991268D26F05DBB2846AF0BEC10@VI1PR05MB6799.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0368E78B5B
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(366004)(396003)(376002)(39850400004)(136003)(346002)(66446008)(110136005)(91956017)(4326008)(66556008)(71200400001)(6506007)(6512007)(478600001)(2616005)(6486002)(81166007)(186003)(7416002)(86362001)(54906003)(36756003)(66946007)(5660300002)(76116006)(2906002)(26005)(8676002)(8936002)(316002)(81156014)(66476007)(64756008)(21314003);DIR:OUT;SFP:1101;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: lnFbs0AiIY1qSg06rC6MmiLjySPC9cgX5qisn7pHAB6lZcwm9zGqdmhMsJB00K7ljEoWBdCfS1xIFB4w874UW0NavALvGxwxDENbXBdYGaVgp7KwdKfPdlFBerpXczCixqwWSBDQJ+DDxBg/XYJTkvKbvAM5U+pwNhqOeTC9/djQUpCxjIGKgOuXKiD5Fwc40fF0iczk43GFgPAKJJohUkaXa/jnchyImZsGyCzc2ARJUzTYVNfU6wYQnlgqg39F4zN4TbgiFzp3dWolR/AL+hS3BrsPZkJoavsI43zjpg+5Ht0wUZ7gmlalrR6UOEcwEmq2L9DssfuWSc0Gqt/n2wwxe147/fkyf0a/2vjxDhBTQ597Jn/LOIbPbDAcwFUo4FnoeBg9/hhjqkKWLkENDKWoOO9aeFgL8YvWdtt70hL8w0L8IAba/UkrbXM5EutrLGgzYfIc/ZPzmDVT+NNdBXijN6rEMr5+rXnMycc7JAw/sxAMHZUSIcEbLWVoWC6A
x-ms-exchange-antispam-messagedata: KuETFEBBPdGFisdgbfVfHYk6EB6ltgo9/bWDb8QHsc4DRTff0NBMzvqTRkcmL65C+A7C0hEjN9vrA0vDWlEmBQtQUOh1lLCng3dq7D/7DxAElP47a3IUGz4DjZcpTNy4uzZi4PZg3526G6/iy7N0dw==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <57907427BC432B409B96BB0D2FBDD7D2@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 54a95346-7e1a-4242-00e3-08d7dc1fb96e
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Apr 2020 00:48:30.8735
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xoWzeQJfC115mTbIR5Y+dasNG7i/rkg9DAKqvPuuETjeeO0Nz1TEXu22VkSgCbDUR9DDQatR/gCO8LsUrOijpw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6799
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCAyMDIwLTA0LTA4IGF0IDEwOjUzIC0wNzAwLCBKYWt1YiBLaWNpbnNraSB3cm90ZToN
Cj4gT24gV2VkLCAwOCBBcHIgMjAyMCAxMzo1MDozOSArMDIwMCBKZXNwZXIgRGFuZ2FhcmQgQnJv
dWVyIHdyb3RlOg0KPiA+IFhEUCBoYXZlIGV2b2x2ZWQgdG8gc3VwcG9ydCBzZXZlcmFsIGZyYW1l
IHNpemVzLCBidXQgeGRwX2J1ZmYgd2FzDQo+ID4gbm90DQo+ID4gdXBkYXRlZCB3aXRoIHRoaXMg
aW5mb3JtYXRpb24uIFRoZSBmcmFtZSBzaXplIChmcmFtZV9zeikgbWVtYmVyIG9mDQo+ID4geGRw
X2J1ZmYgaXMgaW50cm9kdWNlZCB0byBrbm93IHRoZSByZWFsIHNpemUgb2YgdGhlIG1lbW9yeSB0
aGUNCj4gPiBmcmFtZSBpcw0KPiA+IGRlbGl2ZXJlZCBpbi4NCj4gPiANCj4gPiBXaGVuIGludHJv
ZHVjaW5nIHRoaXMgYWxzbyBtYWtlIGl0IGNsZWFyIHRoYXQgc29tZSB0YWlscm9vbSBpcw0KPiA+
IHJlc2VydmVkL3JlcXVpcmVkIHdoZW4gY3JlYXRpbmcgU0tCcyB1c2luZyBidWlsZF9za2IoKS4N
Cj4gPiANCj4gPiBJdCB3b3VsZCBhbHNvIGhhdmUgYmVlbiBhbiBvcHRpb24gdG8gaW50cm9kdWNl
IGEgcG9pbnRlciB0bw0KPiA+IGRhdGFfaGFyZF9lbmQgKHdpdGggcmVzZXJ2ZWQgb2Zmc2V0KS4g
VGhlIGFkdmFudGFnZSB3aXRoIGZyYW1lX3N6DQo+ID4gaXMNCj4gPiB0aGF0IChsaWtlIHJ4cSkg
ZHJpdmVycyBvbmx5IG5lZWQgdG8gc2V0dXAvYXNzaWduIHRoaXMgdmFsdWUgb25jZQ0KPiA+IHBl
cg0KPiA+IE5BUEkgY3ljbGUuIER1ZSB0byBYRFAtZ2VuZXJpYyAoYW5kIHNvbWUgZHJpdmVycykg
aXQncyBub3QgcG9zc2libGUNCj4gPiB0bw0KPiA+IHN0b3JlIGZyYW1lX3N6IGluc2lkZSB4ZHBf
cnhxX2luZm8sIGJlY2F1c2UgaXQncyB2YXJpZXMgcGVyIHBhY2tldA0KPiA+IGFzIGl0DQo+ID4g
Y2FuIGJlIGJhc2VkL2RlcGVuZCBvbiBwYWNrZXQgbGVuZ3RoLg0KPiA+IA0KPiA+IFNpZ25lZC1v
ZmYtYnk6IEplc3BlciBEYW5nYWFyZCBCcm91ZXIgPGJyb3VlckByZWRoYXQuY29tPg0KPiA+IC0t
LQ0KPiA+ICBpbmNsdWRlL25ldC94ZHAuaCB8ICAgMTcgKysrKysrKysrKysrKysrKysNCj4gPiAg
MSBmaWxlIGNoYW5nZWQsIDE3IGluc2VydGlvbnMoKykNCj4gPiANCj4gPiBkaWZmIC0tZ2l0IGEv
aW5jbHVkZS9uZXQveGRwLmggYi9pbmNsdWRlL25ldC94ZHAuaA0KPiA+IGluZGV4IDQwYzZkMzM5
ODQ1OC4uOTlmNDM3NGY2MjE0IDEwMDY0NA0KPiA+IC0tLSBhL2luY2x1ZGUvbmV0L3hkcC5oDQo+
ID4gKysrIGIvaW5jbHVkZS9uZXQveGRwLmgNCj4gPiBAQCAtNiw2ICs2LDggQEANCj4gPiAgI2lm
bmRlZiBfX0xJTlVYX05FVF9YRFBfSF9fDQo+ID4gICNkZWZpbmUgX19MSU5VWF9ORVRfWERQX0hf
Xw0KPiA+ICANCj4gPiArI2luY2x1ZGUgPGxpbnV4L3NrYnVmZi5oPiAvKiBza2Jfc2hhcmVkX2lu
Zm8gKi8NCj4gPiArDQo+ID4gIC8qKg0KPiA+ICAgKiBET0M6IFhEUCBSWC1xdWV1ZSBpbmZvcm1h
dGlvbg0KPiA+ICAgKg0KPiA+IEBAIC03MCw4ICs3MiwyMyBAQCBzdHJ1Y3QgeGRwX2J1ZmYgew0K
PiA+ICAJdm9pZCAqZGF0YV9oYXJkX3N0YXJ0Ow0KPiA+ICAJdW5zaWduZWQgbG9uZyBoYW5kbGU7
DQo+ID4gIAlzdHJ1Y3QgeGRwX3J4cV9pbmZvICpyeHE7DQo+ID4gKwl1MzIgZnJhbWVfc3o7IC8q
IGZyYW1lIHNpemUgdG8gZGVkdWN0IGRhdGFfaGFyZF9lbmQvcmVzZXJ2ZWQNCj4gPiB0YWlscm9v
bSovDQo+IA0KPiBQZXJoYXBzDQo+IA0KPiAvKiBsZW5ndGggb2YgcGFja2V0IGJ1ZmZlciwgc3Rh
cnRpbmcgYXQgZGF0YV9oYXJkX3N0YXJ0ICovDQo+IA0KPiA/DQo+IA0KPiA+ICB9Ow0KPiA+ICAN
Cj4gPiArLyogUmVzZXJ2ZSBtZW1vcnkgYXJlYSBhdCBlbmQtb2YgZGF0YSBhcmVhLg0KPiANCj4g
SSB3b3VsZG4ndCBzYXkgdGhpcyByZXNlcnZlcyBhbnl0aGluZy4gSXQganVzdCBjb21wdXRlcyB0
aGUgZW5kDQo+IHBvaW50ZXIsIG5vPw0KPiANCj4gPiArICoNCj4gPiArICogVGhpcyBtYWNybyBy
ZXNlcnZlcyB0YWlscm9vbSBpbiB0aGUgWERQIGJ1ZmZlciBieSBsaW1pdGluZyB0aGUNCj4gPiAr
ICogWERQL0JQRiBkYXRhIGFjY2VzcyB0byBkYXRhX2hhcmRfZW5kLiAgTm90aWNlIHNhbWUgYXJl
YSAoYW5kDQo+ID4gc2l6ZSkNCj4gPiArICogaXMgdXNlZCBmb3IgWERQX1BBU1MsIHdoZW4gY29u
c3RydWN0aW5nIHRoZSBTS0IgdmlhDQo+ID4gYnVpbGRfc2tiKCkuDQo+ID4gKyAqLw0KPiA+ICsj
ZGVmaW5lIHhkcF9kYXRhX2hhcmRfZW5kKHhkcCkJCQkJXA0KPiA+ICsJKCh4ZHApLT5kYXRhX2hh
cmRfc3RhcnQgKyAoeGRwKS0+ZnJhbWVfc3ogLQlcDQo+ID4gKwkgU0tCX0RBVEFfQUxJR04oc2l6
ZW9mKHN0cnVjdCBza2Jfc2hhcmVkX2luZm8pKSkNCj4gDQo+IEkgdGhpbmsgaXQgc2hvdWxkIGJl
IHNhaWQgc29tZXdoZXJlIHRoYXQgdGhlIGRyaXZlcnMgYXJlIGV4cGVjdGVkIHRvDQo+IERNQSBt
YXAgbWVtb3J5IHVwIHRvIHhkcF9kYXRhX2hhcmRfZW5kKHhkcCkuDQo+IA0KDQpidXQgdGhpcyB3
b3JrcyBvbiBhIHNwZWNpZmljIHhkcCBidWZmLCBkcml2ZXJzIHdvcmsgd2l0aCBtdHUNCg0KYW5k
IHdoYXQgaWYgdGhlIGRyaXZlciB3YW50IHRvIGhhdmUgdGhpcyBhcyBhbiBvcHRpb24gcGVyIHBh
Y2tldCAuLiANCmkuZS46IGlmIHRoZXJlIGlzIGVub3VnaCB0YWlsIHJvb20sIHRoZW4gYnVpbGRf
c2tiLCBvdGhlcndpc2UNCmFsbG9jIG5ldyBza2IsIGNvcHkgaGVhZGVycywgc2V0dXAgZGF0YSBm
cmFncy4uIGV0Yw0KDQpoYXZpbmcgc3VjaCBsaW1pdGF0aW9ucyBvbiBkcml2ZXIgY2FuIGJlIHZl
cnkgc3RyaWN0LCBpIHRoaW5rIHRoZQ0KZGVjaXNpb24gbXVzdCByZW1haW4gZHluYW1pYyBwZXIg
ZnJhbWUuLg0KDQpvZi1jb3Vyc2UgZHJpdmVycyBzaG91bGQgb3B0aW1pemUgdG8gcHJlc2VydmUg
ZW5vdWdoIHRhaWwgcm9vbSBmb3IgYWxsDQpyeCBwYWNrZXRzLi4gDQoNCj4gPiArDQo+ID4gKy8q
IExpa2Ugc2tiX3NoaW5mbyAqLw0KPiA+ICsjZGVmaW5lIHhkcF9zaGluZm8oeGRwKQkoKHN0cnVj
dCBza2Jfc2hhcmVkX2luZm8NCj4gPiAqKSh4ZHBfZGF0YV9oYXJkX2VuZCh4ZHApKSkNCj4gPiAr
Ly8gWFhYOiBBYm92ZSBsaWtlbHkgYmVsb25ncyBpbiBsYXRlciBwYXRjaA0KPiA+ICsNCj4gPiAg
c3RydWN0IHhkcF9mcmFtZSB7DQo+ID4gIAl2b2lkICpkYXRhOw0KPiA+ICAJdTE2IGxlbjsNCj4g
PiANCj4gPiANCg==
