Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA9F638F765
	for <lists+netdev@lfdr.de>; Tue, 25 May 2021 03:11:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229551AbhEYBNP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 21:13:15 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:5765 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229540AbhEYBNP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 May 2021 21:13:15 -0400
Received: from dggems706-chm.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4Fpwtc5m54zlY5t;
        Tue, 25 May 2021 09:08:08 +0800 (CST)
Received: from nkgeml708-chm.china.huawei.com (10.98.57.160) by
 dggems706-chm.china.huawei.com (10.3.19.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 25 May 2021 09:11:44 +0800
Received: from nkgeml708-chm.china.huawei.com (10.98.57.160) by
 nkgeml708-chm.china.huawei.com (10.98.57.160) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 25 May 2021 09:11:43 +0800
Received: from nkgeml708-chm.china.huawei.com ([10.98.57.160]) by
 nkgeml708-chm.china.huawei.com ([10.98.57.160]) with mapi id 15.01.2176.012;
 Tue, 25 May 2021 09:11:43 +0800
From:   "Guodeqing (A)" <geffrey.guo@huawei.com>
To:     Jason Wang <jasowang@redhat.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        "mst@redhat.com" <mst@redhat.com>
Subject: RE: [PATCH] virtio-net: fix the kzalloc/kfree mismatch problem
Thread-Topic: [PATCH] virtio-net: fix the kzalloc/kfree mismatch problem
Thread-Index: AQHXUEW/bATxnnR10EK/YGW72hUTH6rzYZAg
Date:   Tue, 25 May 2021 01:11:43 +0000
Message-ID: <36e8999c9a5d443990384183265b25ee@huawei.com>
References: <1621821978.04102-1-xuanzhuo@linux.alibaba.com>
 <36d1b92c-7dc5-f84e-ef86-980b15c39965@redhat.com>
In-Reply-To: <36d1b92c-7dc5-f84e-ef86-980b15c39965@redhat.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.136.115.169]
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogSmFzb24gV2FuZyBbbWFp
bHRvOmphc293YW5nQHJlZGhhdC5jb21dDQo+IFNlbnQ6IE1vbmRheSwgTWF5IDI0LCAyMDIxIDEw
OjM3DQo+IFRvOiBYdWFuIFpodW8gPHh1YW56aHVvQGxpbnV4LmFsaWJhYmEuY29tPjsgR3VvZGVx
aW5nIChBKQ0KPiA8Z2VmZnJleS5ndW9AaHVhd2VpLmNvbT4NCj4gQ2M6IGRhdmVtQGRhdmVtbG9m
dC5uZXQ7IGt1YmFAa2VybmVsLm9yZzsgdmlydHVhbGl6YXRpb25AbGlzdHMubGludXgtDQo+IGZv
dW5kYXRpb24ub3JnOyBuZXRkZXZAdmdlci5rZXJuZWwub3JnOyBNYXggR3VydG92b3kNCj4gPG1n
dXJ0b3ZveUBudmlkaWEuY29tPjsgbXN0QHJlZGhhdC5jb20NCj4gU3ViamVjdDogUmU6IFtQQVRD
SF0gdmlydGlvLW5ldDogZml4IHRoZSBremFsbG9jL2tmcmVlIG1pc21hdGNoIHByb2JsZW0NCj4g
DQo+IA0KPiDU2iAyMDIxLzUvMjQgyc/O5zEwOjA2LCBYdWFuIFpodW8g0LS1wDoNCj4gPiBPbiBN
b24sIDI0IE1heSAyMDIxIDAxOjQ4OjUzICswMDAwLCBHdW9kZXFpbmcgKEEpDQo+IDxnZWZmcmV5
Lmd1b0BodWF3ZWkuY29tPiB3cm90ZToNCj4gPj4NCj4gPj4+IC0tLS0tT3JpZ2luYWwgTWVzc2Fn
ZS0tLS0tDQo+ID4+PiBGcm9tOiBNYXggR3VydG92b3kgW21haWx0bzptZ3VydG92b3lAbnZpZGlh
LmNvbV0NCj4gPj4+IFNlbnQ6IFN1bmRheSwgTWF5IDIzLCAyMDIxIDE1OjI1DQo+ID4+PiBUbzog
R3VvZGVxaW5nIChBKSA8Z2VmZnJleS5ndW9AaHVhd2VpLmNvbT47IG1zdEByZWRoYXQuY29tDQo+
ID4+PiBDYzogamFzb3dhbmdAcmVkaGF0LmNvbTsgZGF2ZW1AZGF2ZW1sb2Z0Lm5ldDsga3ViYUBr
ZXJuZWwub3JnOw0KPiA+Pj4gdmlydHVhbGl6YXRpb25AbGlzdHMubGludXgtZm91bmRhdGlvbi5v
cmc7IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmcNCj4gPj4+IFN1YmplY3Q6IFJlOiBbUEFUQ0hdIHZp
cnRpby1uZXQ6IGZpeCB0aGUga3phbGxvYy9rZnJlZSBtaXNtYXRjaCBwcm9ibGVtDQo+ID4+Pg0K
PiA+Pj4NCj4gPj4+IE9uIDUvMjIvMjAyMSAxMTowMiBBTSwgZ3VvZGVxaW5nIHdyb3RlOg0KPiA+
Pj4+IElmIHRoZSB2aXJ0aW9fbmV0IGRldmljZSBkb2VzIG5vdCBzdXBwdXJ0IHRoZSBjdHJsIHF1
ZXVlIGZlYXR1cmUsIHRoZQ0KPiA+Pj4+IHZpLT5jdHJsIHdhcyBub3QgYWxsb2NhdGVkLCBzbyB0
aGVyZSBpcyBubyBuZWVkIHRvIGZyZWUgaXQuDQo+ID4+PiB5b3UgZG9uJ3QgbmVlZCB0aGlzIGNo
ZWNrLg0KPiA+Pj4NCj4gPj4+IGZyb20ga2ZyZWUgZG9jOg0KPiA+Pj4NCj4gPj4+ICJJZiBAb2Jq
cCBpcyBOVUxMLCBubyBvcGVyYXRpb24gaXMgcGVyZm9ybWVkLiINCj4gPj4+DQo+ID4+PiBUaGlz
IGlzIG5vdCBhIGJ1Zy4gSSd2ZSBzZXQgdmktPmN0cmwgdG8gYmUgTlVMTCBpbiBjYXNlICF2aS0+
aGFzX2N2cS4NCj4gPj4+DQo+ID4+Pg0KPiA+PiAgICB5ZXMsICB0aGlzIGlzIG5vdCBhIGJ1Zywg
dGhlIHBhdGNoIGlzIGp1c3QgYSBvcHRpbWl6YXRpb24sIGJlY2F1c2UgdGhlIHZpLQ0KPiA+Y3Ry
bCBtYXliZQ0KPiA+PiAgICBiZSBmcmVlZCB3aGljaCAgd2FzIG5vdCBhbGxvY2F0ZWQsIHRoaXMg
bWF5IGdpdmUgcGVvcGxlIGENCj4gbWlzdW5kZXJzdGFuZGluZy4NCj4gPj4gICAgVGhhbmtzLg0K
PiA+DQo+ID4gSSB0aGluayBpdCBtYXkgYmUgZW5vdWdoIHRvIGFkZCBhIGNvbW1lbnQsIGFuZCB0
aGUgY29kZSBkb2VzIG5vdCBuZWVkIHRvDQo+IGJlDQo+ID4gbW9kaWZpZWQuDQo+ID4NCj4gPiBU
aGFua3MuDQo+IA0KPiANCj4gT3IgZXZlbiBqdXN0IGxlYXZlIHRoZSBjdXJyZW50IGNvZGUgYXMg
aXMuIEEgbG90IG9mIGtlcm5lbCBjb2RlcyB3YXMNCj4gd3JvdGUgdW5kZXIgdGhlIGFzc3VtcHRp
b24gdGhhdCBrZnJlZSgpIHNob3VsZCBkZWFsIHdpdGggTlVMTC4NCj4gDQo+IFRoYW5rcw0KPiAN
Cj4gDQoNCm9rLCBJIHNlZS4gSXMgaXQgbmVjZXNzYXJ5IHRvIHNldCB0aGUgdmktPmN0cmwgdmFs
dWUgdG8gbnVsbCxiZWNhdXNlIHRoZSB2aS0+Y3RybCB2YWx1ZSBpcyBzZXQNCnRvIHplcm8gaW4g
dGhlIGFsbG9jX2V0aGVyZGV2X21xIGZ1bmN0aW9uIGJ5IGt6YWxsb2MuDQoNClRoYW5rcy4NCj4g
Pg0KPiA+Pj4+IEhlcmUgSSBhZGp1c3QgdGhlIGluaXRpYWxpemF0aW9uIHNlcXVlbmNlIGFuZCB0
aGUgY2hlY2sgb2YgdmktPmhhc19jdnENCj4gPj4+PiB0byBzbG92ZSB0aGlzIHByb2JsZW0uDQo+
ID4+Pj4NCj4gPj4+PiBGaXhlczogCTEyMmI4NGExMjY3YSAoInZpcnRpby1uZXQ6IGRvbid0IGFs
bG9jYXRlIGNvbnRyb2xfYnVmIGlmIG5vdA0KPiA+Pj4gc3VwcG9ydGVkIikNCj4gPj4+PiBTaWdu
ZWQtb2ZmLWJ5OiBndW9kZXFpbmcgPGdlZmZyZXkuZ3VvQGh1YXdlaS5jb20+DQo+ID4+Pj4gLS0t
DQo+ID4+Pj4gICAgZHJpdmVycy9uZXQvdmlydGlvX25ldC5jIHwgMjAgKysrKysrKysrKy0tLS0t
LS0tLS0NCj4gPj4+PiAgICAxIGZpbGUgY2hhbmdlZCwgMTAgaW5zZXJ0aW9ucygrKSwgMTAgZGVs
ZXRpb25zKC0pDQo+ID4+Pj4NCj4gPj4+PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvdmlydGlv
X25ldC5jIGIvZHJpdmVycy9uZXQvdmlydGlvX25ldC5jIGluZGV4DQo+ID4+Pj4gOWI2YTRhODc1
YzU1Li44OTRmODk0ZDNhMjkgMTAwNjQ0DQo+ID4+Pj4gLS0tIGEvZHJpdmVycy9uZXQvdmlydGlv
X25ldC5jDQo+ID4+Pj4gKysrIGIvZHJpdmVycy9uZXQvdmlydGlvX25ldC5jDQo+ID4+Pj4gQEAg
LTI2OTEsNyArMjY5MSw4IEBAIHN0YXRpYyB2b2lkIHZpcnRuZXRfZnJlZV9xdWV1ZXMoc3RydWN0
DQo+ID4+Pj4gdmlydG5ldF9pbmZvICp2aSkNCj4gPj4+Pg0KPiA+Pj4+ICAgIAlrZnJlZSh2aS0+
cnEpOw0KPiA+Pj4+ICAgIAlrZnJlZSh2aS0+c3EpOw0KPiA+Pj4+IC0Ja2ZyZWUodmktPmN0cmwp
Ow0KPiA+Pj4+ICsJaWYgKHZpLT5oYXNfY3ZxKQ0KPiA+Pj4+ICsJCWtmcmVlKHZpLT5jdHJsKTsN
Cj4gPj4+PiAgICB9DQo+ID4+Pj4NCj4gPj4+PiAgICBzdGF0aWMgdm9pZCBfZnJlZV9yZWNlaXZl
X2J1ZnMoc3RydWN0IHZpcnRuZXRfaW5mbyAqdmkpIEBAIC0yODcwLDEzDQo+ID4+Pj4gKzI4NzEs
NiBAQCBzdGF0aWMgaW50IHZpcnRuZXRfYWxsb2NfcXVldWVzKHN0cnVjdCB2aXJ0bmV0X2luZm8g
KnZpKQ0KPiA+Pj4+ICAgIHsNCj4gPj4+PiAgICAJaW50IGk7DQo+ID4+Pj4NCj4gPj4+PiAtCWlm
ICh2aS0+aGFzX2N2cSkgew0KPiA+Pj4+IC0JCXZpLT5jdHJsID0ga3phbGxvYyhzaXplb2YoKnZp
LT5jdHJsKSwgR0ZQX0tFUk5FTCk7DQo+ID4+Pj4gLQkJaWYgKCF2aS0+Y3RybCkNCj4gPj4+PiAt
CQkJZ290byBlcnJfY3RybDsNCj4gPj4+PiAtCX0gZWxzZSB7DQo+ID4+Pj4gLQkJdmktPmN0cmwg
PSBOVUxMOw0KPiA+Pj4+IC0JfQ0KPiA+Pj4+ICAgIAl2aS0+c3EgPSBrY2FsbG9jKHZpLT5tYXhf
cXVldWVfcGFpcnMsIHNpemVvZigqdmktPnNxKSwgR0ZQX0tFUk5FTCk7DQo+ID4+Pj4gICAgCWlm
ICghdmktPnNxKQ0KPiA+Pj4+ICAgIAkJZ290byBlcnJfc3E7DQo+ID4+Pj4gQEAgLTI4ODQsNiAr
Mjg3OCwxMiBAQCBzdGF0aWMgaW50IHZpcnRuZXRfYWxsb2NfcXVldWVzKHN0cnVjdA0KPiA+Pj4g
dmlydG5ldF9pbmZvICp2aSkNCj4gPj4+PiAgICAJaWYgKCF2aS0+cnEpDQo+ID4+Pj4gICAgCQln
b3RvIGVycl9ycTsNCj4gPj4+Pg0KPiA+Pj4+ICsJaWYgKHZpLT5oYXNfY3ZxKSB7DQo+ID4+Pj4g
KwkJdmktPmN0cmwgPSBremFsbG9jKHNpemVvZigqdmktPmN0cmwpLCBHRlBfS0VSTkVMKTsNCj4g
Pj4+PiArCQlpZiAoIXZpLT5jdHJsKQ0KPiA+Pj4+ICsJCQlnb3RvIGVycl9jdHJsOw0KPiA+Pj4+
ICsJfQ0KPiA+Pj4+ICsNCj4gPj4+PiAgICAJSU5JVF9ERUxBWUVEX1dPUksoJnZpLT5yZWZpbGws
IHJlZmlsbF93b3JrKTsNCj4gPj4+PiAgICAJZm9yIChpID0gMDsgaSA8IHZpLT5tYXhfcXVldWVf
cGFpcnM7IGkrKykgew0KPiA+Pj4+ICAgIAkJdmktPnJxW2ldLnBhZ2VzID0gTlVMTDsNCj4gPj4+
PiBAQCAtMjkwMiwxMSArMjkwMiwxMSBAQCBzdGF0aWMgaW50IHZpcnRuZXRfYWxsb2NfcXVldWVz
KHN0cnVjdA0KPiA+Pj4+IHZpcnRuZXRfaW5mbyAqdmkpDQo+ID4+Pj4NCj4gPj4+PiAgICAJcmV0
dXJuIDA7DQo+ID4+Pj4NCj4gPj4+PiArZXJyX2N0cmw6DQo+ID4+Pj4gKwlrZnJlZSh2aS0+cnEp
Ow0KPiA+Pj4+ICAgIGVycl9ycToNCj4gPj4+PiAgICAJa2ZyZWUodmktPnNxKTsNCj4gPj4+PiAg
ICBlcnJfc3E6DQo+ID4+Pj4gLQlrZnJlZSh2aS0+Y3RybCk7DQo+ID4+Pj4gLWVycl9jdHJsOg0K
PiA+Pj4+ICAgIAlyZXR1cm4gLUVOT01FTTsNCj4gPj4+PiAgICB9DQo+ID4+Pj4NCg0K
