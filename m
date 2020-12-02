Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F8FE2CB5EC
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 08:52:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728828AbgLBHvE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 02:51:04 -0500
Received: from mail6.tencent.com ([220.249.245.26]:52834 "EHLO
        mail6.tencent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726148AbgLBHvD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 02:51:03 -0500
X-Greylist: delayed 381 seconds by postgrey-1.27 at vger.kernel.org; Wed, 02 Dec 2020 02:51:01 EST
Received: from EX-SZ019.tencent.com (unknown [10.28.6.74])
        by mail6.tencent.com (Postfix) with ESMTP id C8FFACC09F;
        Wed,  2 Dec 2020 15:45:34 +0800 (CST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=tencent.com;
        s=s202002; t=1606895134;
        bh=Z70+RP6pppkhHfN5BMvGoKQ19LZCgpxp9n4fcThRLkY=;
        h=From:To:CC:Subject:Date:References:In-Reply-To;
        b=CLXghOTISS+z+eyzMYXx2gG6FKuxE7y3Zd73x6Tq9qDXvmYFhY7sLF0Z8ilfeNHJE
         Avw8FgOoBuijIbv9qkCMhhQifSG+HGTD9wehcOzy9eTd+02Ww8vRItilYSWl/4k6XR
         jSmD9uKQOZqh/gkAAJUDqwnGxtddm0CcRnF/tqjw=
Received: from EX-SZ044.tencent.com (10.28.6.95) by EX-SZ019.tencent.com
 (10.28.6.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2; Wed, 2 Dec 2020
 15:43:52 +0800
Received: from EX-SZ008.tencent.com (10.28.6.32) by EX-SZ044.tencent.com
 (10.28.6.95) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2; Wed, 2 Dec 2020
 15:43:51 +0800
Received: from EX-SZ008.tencent.com ([fe80::f450:1a7a:4c3:f801]) by
 EX-SZ008.tencent.com ([fe80::f450:1a7a:4c3:f801%10]) with mapi id
 15.01.2106.002; Wed, 2 Dec 2020 15:43:51 +0800
From:   =?utf-8?B?a2l5aW4o5bC55LquKQ==?= <kiyin@tencent.com>
To:     Dan Carpenter <dan.carpenter@oracle.com>,
        Martin Schiller <ms@dev.tdt.de>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "linux-x25@vger.kernel.org" <linux-x25@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Andrew Hendry <andrew.hendry@gmail.com>,
        "security@kernel.org" <security@kernel.org>,
        "linux-distros@vs.openwall.org" <linux-distros@vs.openwall.org>,
        =?utf-8?B?aHVudGNoZW4o6ZmI6ZizKQ==?= <huntchen@tencent.com>,
        =?utf-8?B?ZGFubnl3YW5nKOeOi+Wuhyk=?= <dannywang@tencent.com>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Subject: RE: [PATCH net v2] net/x25: prevent a couple of overflows(Internet
 mail)
Thread-Topic: [PATCH net v2] net/x25: prevent a couple of overflows(Internet
 mail)
Thread-Index: AQHWx/Wvy4+bt2pQ90eFSfW7SZJxJ6njaicg
Date:   Wed, 2 Dec 2020 07:43:51 +0000
Message-ID: <1a30d292e2b74a3ba226ace1eefb2084@tencent.com>
References: <ecf3321f20cc4f6dcf02b5b73105da58@dev.tdt.de>
 <X8ZeAKm8FnFpN//B@mwanda>
In-Reply-To: <X8ZeAKm8FnFpN//B@mwanda>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.99.16.12]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgRGFuLA0KICAgIEkgdGhpbmsgdGhlIHN0cm5sZW4gaXMgYmV0dGVyLiB0aGUga2VybmVsIGRv
ZXNuJ3QgbmVlZCB0byBhZGp1c3QgdXNlciBsYW5kIG1pc3Rha2UgYnkgcHV0dGluZyBhIE5VTEwg
dGVybWluYXRvci4ganVzdCByZXR1cm4gYW4gZXJyb3IgdG8gbGV0IHRoZSB1c2VyIGxhbmQgcHJv
Z3JhbSBmaXggdGhlIHdyb25nIGFkZHJlc3MuDQoNClJlZ2FyZHMsDQpraXlpbg0KDQo+IC0tLS0t
T3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IERhbiBDYXJwZW50ZXIgW21haWx0bzpkYW4u
Y2FycGVudGVyQG9yYWNsZS5jb21dDQo+IFNlbnQ6IFR1ZXNkYXksIERlY2VtYmVyIDEsIDIwMjAg
MTE6MTUgUE0NCj4gVG86IE1hcnRpbiBTY2hpbGxlciA8bXNAZGV2LnRkdC5kZT4NCj4gQ2M6IERh
dmlkIFMuIE1pbGxlciA8ZGF2ZW1AZGF2ZW1sb2Z0Lm5ldD47IEpha3ViIEtpY2luc2tpIDxrdWJh
QGtlcm5lbC5vcmc+Ow0KPiBsaW51eC14MjVAdmdlci5rZXJuZWwub3JnOyBuZXRkZXZAdmdlci5r
ZXJuZWwub3JnOyBBbmRyZXcgSGVuZHJ5DQo+IDxhbmRyZXcuaGVuZHJ5QGdtYWlsLmNvbT47IGtp
eWluKOWwueS6rikgPGtpeWluQHRlbmNlbnQuY29tPjsNCj4gc2VjdXJpdHlAa2VybmVsLm9yZzsg
bGludXgtZGlzdHJvc0B2cy5vcGVud2FsbC5vcmc7IGh1bnRjaGVuKOmZiOmYsykNCj4gPGh1bnRj
aGVuQHRlbmNlbnQuY29tPjsgZGFubnl3YW5nKOeOi+WuhykgPGRhbm55d2FuZ0B0ZW5jZW50LmNv
bT47DQo+IGtlcm5lbC1qYW5pdG9yc0B2Z2VyLmtlcm5lbC5vcmcNCj4gU3ViamVjdDogW1BBVENI
IG5ldCB2Ml0gbmV0L3gyNTogcHJldmVudCBhIGNvdXBsZSBvZiBvdmVyZmxvd3MoSW50ZXJuZXQg
bWFpbCkNCj4gDQo+IFRoZSAueDI1X2FkZHJbXSBhZGRyZXNzIGNvbWVzIGZyb20gdGhlIHVzZXIg
YW5kIGlzIG5vdCBuZWNlc3NhcmlseSBOVUwNCj4gdGVybWluYXRlZC4gIFRoaXMgbGVhZHMgdG8g
YSBjb3VwbGUgcHJvYmxlbXMuICBUaGUgZmlyc3QgcHJvYmxlbSBpcyB0aGF0IHRoZQ0KPiBzdHJs
ZW4oKSBpbiB4MjVfYmluZCgpIGNhbiByZWFkIGJleW9uZCB0aGUgZW5kIG9mIHRoZSBidWZmZXIu
DQo+IA0KPiBUaGUgc2Vjb25kIHByb2JsZW0gaXMgbW9yZSBzdWJ0bGUgYW5kIGNvdWxkIHJlc3Vs
dCBpbiBtZW1vcnkgY29ycnVwdGlvbi4NCj4gVGhlIGNhbGwgdHJlZSBpczoNCj4gICB4MjVfY29u
bmVjdCgpDQo+ICAgLS0+IHgyNV93cml0ZV9pbnRlcm5hbCgpDQo+ICAgICAgIC0tPiB4MjVfYWRk
cl9hdG9uKCkNCj4gDQo+IFRoZSAueDI1X2FkZHJbXSBidWZmZXJzIGFyZSBjb3BpZWQgdG8gdGhl
ICJhZGRyZXNzZXMiIGJ1ZmZlciBmcm9tDQo+IHgyNV93cml0ZV9pbnRlcm5hbCgpIHNvIGl0IHdp
bGwgbGVhZCB0byBzdGFjayBjb3JydXB0aW9uLg0KPiANCj4gVmVyaWZ5IHRoYXQgdGhlIHN0cmlu
Z3MgYXJlIE5VTCB0ZXJtaW5hdGVkIGFuZCByZXR1cm4gLUVJTlZBTCBpZiB0aGV5IGFyZSBub3Qu
DQo+IA0KPiBSZXBvcnRlZC1ieTogImtpeWluKOWwueS6rikiIDxraXlpbkB0ZW5jZW50LmNvbT4N
Cj4gU2lnbmVkLW9mZi1ieTogRGFuIENhcnBlbnRlciA8ZGFuLmNhcnBlbnRlckBvcmFjbGUuY29t
Pg0KPiAtLS0NCj4gVGhlIGZpcnN0IHBhdGNoIHB1dCBhIE5VTCB0ZXJtaW5hdG9yIG9uIHRoZSBl
bmQgb2YgdGhlIHN0cmluZyBhbmQgdGhpcyBwYXRjaA0KPiByZXR1cm5zIGFuIGVycm9yIGluc3Rl
YWQuICBJIGRvbid0IGhhdmUgYSBzdHJvbmcgcHJlZmVyZW5jZSwgd2hpY2ggcGF0Y2ggdG8gZ28N
Cj4gd2l0aC4NCj4gDQo+ICBuZXQveDI1L2FmX3gyNS5jIHwgNiArKysrLS0NCj4gIDEgZmlsZSBj
aGFuZ2VkLCA0IGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0pDQo+IA0KPiBkaWZmIC0tZ2l0
IGEvbmV0L3gyNS9hZl94MjUuYyBiL25ldC94MjUvYWZfeDI1LmMgaW5kZXgNCj4gOTIzMmNkYjQy
YWQ5Li5kNDFmZmZiMjUwN2IgMTAwNjQ0DQo+IC0tLSBhL25ldC94MjUvYWZfeDI1LmMNCj4gKysr
IGIvbmV0L3gyNS9hZl94MjUuYw0KPiBAQCAtNjc1LDcgKzY3NSw4IEBAIHN0YXRpYyBpbnQgeDI1
X2JpbmQoc3RydWN0IHNvY2tldCAqc29jaywgc3RydWN0DQo+IHNvY2thZGRyICp1YWRkciwgaW50
IGFkZHJfbGVuKQ0KPiAgCWludCBsZW4sIGksIHJjID0gMDsNCj4gDQo+ICAJaWYgKGFkZHJfbGVu
ICE9IHNpemVvZihzdHJ1Y3Qgc29ja2FkZHJfeDI1KSB8fA0KPiAtCSAgICBhZGRyLT5zeDI1X2Zh
bWlseSAhPSBBRl9YMjUpIHsNCj4gKwkgICAgYWRkci0+c3gyNV9mYW1pbHkgIT0gQUZfWDI1IHx8
DQo+ICsJICAgIHN0cm5sZW4oYWRkci0+c3gyNV9hZGRyLngyNV9hZGRyLCBYMjVfQUREUl9MRU4p
ID09DQo+IFgyNV9BRERSX0xFTikgew0KPiAgCQlyYyA9IC1FSU5WQUw7DQo+ICAJCWdvdG8gb3V0
Ow0KPiAgCX0NCj4gQEAgLTc2OSw3ICs3NzAsOCBAQCBzdGF0aWMgaW50IHgyNV9jb25uZWN0KHN0
cnVjdCBzb2NrZXQgKnNvY2ssIHN0cnVjdA0KPiBzb2NrYWRkciAqdWFkZHIsDQo+IA0KPiAgCXJj
ID0gLUVJTlZBTDsNCj4gIAlpZiAoYWRkcl9sZW4gIT0gc2l6ZW9mKHN0cnVjdCBzb2NrYWRkcl94
MjUpIHx8DQo+IC0JICAgIGFkZHItPnN4MjVfZmFtaWx5ICE9IEFGX1gyNSkNCj4gKwkgICAgYWRk
ci0+c3gyNV9mYW1pbHkgIT0gQUZfWDI1IHx8DQo+ICsJICAgIHN0cm5sZW4oYWRkci0+c3gyNV9h
ZGRyLngyNV9hZGRyLCBYMjVfQUREUl9MRU4pID09DQo+IFgyNV9BRERSX0xFTikNCj4gIAkJZ290
byBvdXQ7DQo+IA0KPiAgCXJjID0gLUVORVRVTlJFQUNIOw0KPiAtLQ0KPiAyLjI5LjINCg0K
