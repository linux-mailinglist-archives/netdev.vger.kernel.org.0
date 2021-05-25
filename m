Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1957F38F766
	for <lists+netdev@lfdr.de>; Tue, 25 May 2021 03:12:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229600AbhEYBOU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 21:14:20 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:5691 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229555AbhEYBOT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 May 2021 21:14:19 -0400
Received: from dggems701-chm.china.huawei.com (unknown [172.30.72.60])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4Fpwwk36lkz1BR9L;
        Tue, 25 May 2021 09:09:58 +0800 (CST)
Received: from nkgeml705-chm.china.huawei.com (10.98.57.154) by
 dggems701-chm.china.huawei.com (10.3.19.178) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 25 May 2021 09:12:47 +0800
Received: from nkgeml708-chm.china.huawei.com (10.98.57.160) by
 nkgeml705-chm.china.huawei.com (10.98.57.154) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 25 May 2021 09:12:47 +0800
Received: from nkgeml708-chm.china.huawei.com ([10.98.57.160]) by
 nkgeml708-chm.china.huawei.com ([10.98.57.160]) with mapi id 15.01.2176.012;
 Tue, 25 May 2021 09:12:47 +0800
From:   "Guodeqing (A)" <geffrey.guo@huawei.com>
To:     Max Gurtovoy <mgurtovoy@nvidia.com>,
        Jason Wang <jasowang@redhat.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "mst@redhat.com" <mst@redhat.com>
Subject: RE: [PATCH] virtio-net: fix the kzalloc/kfree mismatch problem
Thread-Topic: [PATCH] virtio-net: fix the kzalloc/kfree mismatch problem
Thread-Index: AQHXUEW/bATxnnR10EK/YGW72hUTH6rxyLEAgAGcq1A=
Date:   Tue, 25 May 2021 01:12:47 +0000
Message-ID: <372caa22030e4d5d90e2bada303d8f77@huawei.com>
References: <1621821978.04102-1-xuanzhuo@linux.alibaba.com>
 <36d1b92c-7dc5-f84e-ef86-980b15c39965@redhat.com>
 <1f23afa3-645e-81b6-76da-94c7806ef6ed@nvidia.com>
In-Reply-To: <1f23afa3-645e-81b6-76da-94c7806ef6ed@nvidia.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.136.115.169]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogTWF4IEd1cnRvdm95IFtt
YWlsdG86bWd1cnRvdm95QG52aWRpYS5jb21dDQo+IFNlbnQ6IE1vbmRheSwgTWF5IDI0LCAyMDIx
IDE2OjM1DQo+IFRvOiBKYXNvbiBXYW5nIDxqYXNvd2FuZ0ByZWRoYXQuY29tPjsgWHVhbiBaaHVv
DQo+IDx4dWFuemh1b0BsaW51eC5hbGliYWJhLmNvbT47IEd1b2RlcWluZyAoQSkgPGdlZmZyZXku
Z3VvQGh1YXdlaS5jb20+DQo+IENjOiBkYXZlbUBkYXZlbWxvZnQubmV0OyBrdWJhQGtlcm5lbC5v
cmc7IHZpcnR1YWxpemF0aW9uQGxpc3RzLmxpbnV4LQ0KPiBmb3VuZGF0aW9uLm9yZzsgbmV0ZGV2
QHZnZXIua2VybmVsLm9yZzsgbXN0QHJlZGhhdC5jb20NCj4gU3ViamVjdDogUmU6IFtQQVRDSF0g
dmlydGlvLW5ldDogZml4IHRoZSBremFsbG9jL2tmcmVlIG1pc21hdGNoIHByb2JsZW0NCj4gDQo+
IA0KPiBPbiA1LzI0LzIwMjEgNTozNyBBTSwgSmFzb24gV2FuZyB3cm90ZToNCj4gPg0KPiA+IOWc
qCAyMDIxLzUvMjQg5LiK5Y2IMTA6MDYsIFh1YW4gWmh1byDlhpnpgZM6DQo+ID4+IE9uIE1vbiwg
MjQgTWF5IDIwMjEgMDE6NDg6NTMgKzAwMDAsIEd1b2RlcWluZyAoQSkNCj4gPj4gPGdlZmZyZXku
Z3VvQGh1YXdlaS5jb20+IHdyb3RlOg0KPiA+Pj4NCj4gPj4+PiAtLS0tLU9yaWdpbmFsIE1lc3Nh
Z2UtLS0tLQ0KPiA+Pj4+IEZyb206IE1heCBHdXJ0b3ZveSBbbWFpbHRvOm1ndXJ0b3ZveUBudmlk
aWEuY29tXQ0KPiA+Pj4+IFNlbnQ6IFN1bmRheSwgTWF5IDIzLCAyMDIxIDE1OjI1DQo+ID4+Pj4g
VG86IEd1b2RlcWluZyAoQSkgPGdlZmZyZXkuZ3VvQGh1YXdlaS5jb20+OyBtc3RAcmVkaGF0LmNv
bQ0KPiA+Pj4+IENjOiBqYXNvd2FuZ0ByZWRoYXQuY29tOyBkYXZlbUBkYXZlbWxvZnQubmV0OyBr
dWJhQGtlcm5lbC5vcmc7DQo+ID4+Pj4gdmlydHVhbGl6YXRpb25AbGlzdHMubGludXgtZm91bmRh
dGlvbi5vcmc7IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmcNCj4gPj4+PiBTdWJqZWN0OiBSZTogW1BB
VENIXSB2aXJ0aW8tbmV0OiBmaXggdGhlIGt6YWxsb2Mva2ZyZWUgbWlzbWF0Y2gNCj4gPj4+PiBw
cm9ibGVtDQo+ID4+Pj4NCj4gPj4+Pg0KPiA+Pj4+IE9uIDUvMjIvMjAyMSAxMTowMiBBTSwgZ3Vv
ZGVxaW5nIHdyb3RlOg0KPiA+Pj4+PiBJZiB0aGUgdmlydGlvX25ldCBkZXZpY2UgZG9lcyBub3Qg
c3VwcHVydCB0aGUgY3RybCBxdWV1ZSBmZWF0dXJlLA0KPiA+Pj4+PiB0aGUNCj4gPj4+Pj4gdmkt
PmN0cmwgd2FzIG5vdCBhbGxvY2F0ZWQsIHNvIHRoZXJlIGlzIG5vIG5lZWQgdG8gZnJlZSBpdC4N
Cj4gPj4+PiB5b3UgZG9uJ3QgbmVlZCB0aGlzIGNoZWNrLg0KPiA+Pj4+DQo+ID4+Pj4gZnJvbSBr
ZnJlZSBkb2M6DQo+ID4+Pj4NCj4gPj4+PiAiSWYgQG9ianAgaXMgTlVMTCwgbm8gb3BlcmF0aW9u
IGlzIHBlcmZvcm1lZC4iDQo+ID4+Pj4NCj4gPj4+PiBUaGlzIGlzIG5vdCBhIGJ1Zy4gSSd2ZSBz
ZXQgdmktPmN0cmwgdG8gYmUgTlVMTCBpbiBjYXNlICF2aS0+aGFzX2N2cS4NCj4gPj4+Pg0KPiA+
Pj4+DQo+ID4+PiDCoMKgIHllcyzCoCB0aGlzIGlzIG5vdCBhIGJ1ZywgdGhlIHBhdGNoIGlzIGp1
c3QgYSBvcHRpbWl6YXRpb24sDQo+ID4+PiBiZWNhdXNlIHRoZSB2aS0+Y3RybCBtYXliZQ0KPiA+
Pj4gwqDCoCBiZSBmcmVlZCB3aGljaMKgIHdhcyBub3QgYWxsb2NhdGVkLCB0aGlzIG1heSBnaXZl
IHBlb3BsZSBhDQo+ID4+PiBtaXN1bmRlcnN0YW5kaW5nLg0KPiA+Pj4gwqDCoCBUaGFua3MuDQo+
ID4+DQo+ID4+IEkgdGhpbmsgaXQgbWF5IGJlIGVub3VnaCB0byBhZGQgYSBjb21tZW50LCBhbmQg
dGhlIGNvZGUgZG9lcyBub3QgbmVlZA0KPiA+PiB0byBiZSBtb2RpZmllZC4NCj4gPj4NCj4gPj4g
VGhhbmtzLg0KPiA+DQo+ID4NCj4gPiBPciBldmVuIGp1c3QgbGVhdmUgdGhlIGN1cnJlbnQgY29k
ZSBhcyBpcy4gQSBsb3Qgb2Yga2VybmVsIGNvZGVzIHdhcw0KPiA+IHdyb3RlIHVuZGVyIHRoZSBh
c3N1bXB0aW9uIHRoYXQga2ZyZWUoKSBzaG91bGQgZGVhbCB3aXRoIE5VTEwuDQo+ID4NCj4gPiBU
aGFua3MNCj4gPg0KPiA+DQo+IGV4YWN0bHkuDQo+IA0KPiANCj4gPj4NCj4gPj4+Pj4gSGVyZSBJ
IGFkanVzdCB0aGUgaW5pdGlhbGl6YXRpb24gc2VxdWVuY2UgYW5kIHRoZSBjaGVjayBvZg0KPiA+
Pj4+PiB2aS0+aGFzX2N2cQ0KPiA+Pj4+PiB0byBzbG92ZSB0aGlzIHByb2JsZW0uDQo+ID4+Pj4+
DQo+ID4+Pj4+IEZpeGVzOsKgwqDCoMKgIDEyMmI4NGExMjY3YSAoInZpcnRpby1uZXQ6IGRvbid0
IGFsbG9jYXRlIGNvbnRyb2xfYnVmDQo+ID4+Pj4+IGlmIG5vdA0KPiA+Pj4+IHN1cHBvcnRlZCIp
DQo+IA0KPiANCj4gIkZpeGVzIiBsaW5lIHNob3VsZCBiZSBhZGRlZCBvbmx5IGlmIHlvdSBmaXgg
c29tZSBidWcuDQo+IA0KICAgIE9rLCBJIHNlZS4NCiAgICBUaGFua3MuDQo+IA0KPiA+Pj4+PiBT
aWduZWQtb2ZmLWJ5OiBndW9kZXFpbmcgPGdlZmZyZXkuZ3VvQGh1YXdlaS5jb20+DQo+ID4+Pj4+
IC0tLQ0KPiA+Pj4+PiDCoMKgIGRyaXZlcnMvbmV0L3ZpcnRpb19uZXQuYyB8IDIwICsrKysrKysr
KystLS0tLS0tLS0tDQo+ID4+Pj4+IMKgwqAgMSBmaWxlIGNoYW5nZWQsIDEwIGluc2VydGlvbnMo
KyksIDEwIGRlbGV0aW9ucygtKQ0KPiA+Pj4+Pg0KPiA+Pj4+PiBkaWZmIC0tZ2l0IGEvZHJpdmVy
cy9uZXQvdmlydGlvX25ldC5jIGIvZHJpdmVycy9uZXQvdmlydGlvX25ldC5jDQo+ID4+Pj4+IGlu
ZGV4DQo+ID4+Pj4+IDliNmE0YTg3NWM1NS4uODk0Zjg5NGQzYTI5IDEwMDY0NA0KPiA+Pj4+PiAt
LS0gYS9kcml2ZXJzL25ldC92aXJ0aW9fbmV0LmMNCj4gPj4+Pj4gKysrIGIvZHJpdmVycy9uZXQv
dmlydGlvX25ldC5jDQo+ID4+Pj4+IEBAIC0yNjkxLDcgKzI2OTEsOCBAQCBzdGF0aWMgdm9pZCB2
aXJ0bmV0X2ZyZWVfcXVldWVzKHN0cnVjdA0KPiA+Pj4+PiB2aXJ0bmV0X2luZm8gKnZpKQ0KPiA+
Pj4+Pg0KPiA+Pj4+PiDCoMKgwqDCoMKgwqAga2ZyZWUodmktPnJxKTsNCj4gPj4+Pj4gwqDCoMKg
wqDCoMKgIGtmcmVlKHZpLT5zcSk7DQo+ID4+Pj4+IC3CoMKgwqAga2ZyZWUodmktPmN0cmwpOw0K
PiA+Pj4+PiArwqDCoMKgIGlmICh2aS0+aGFzX2N2cSkNCj4gPj4+Pj4gK8KgwqDCoMKgwqDCoMKg
IGtmcmVlKHZpLT5jdHJsKTsNCj4gPj4+Pj4gwqDCoCB9DQo+ID4+Pj4+DQo+ID4+Pj4+IMKgwqAg
c3RhdGljIHZvaWQgX2ZyZWVfcmVjZWl2ZV9idWZzKHN0cnVjdCB2aXJ0bmV0X2luZm8gKnZpKSBA
QA0KPiA+Pj4+PiAtMjg3MCwxMw0KPiA+Pj4+PiArMjg3MSw2IEBAIHN0YXRpYyBpbnQgdmlydG5l
dF9hbGxvY19xdWV1ZXMoc3RydWN0IHZpcnRuZXRfaW5mbw0KPiA+Pj4+PiArKnZpKQ0KPiA+Pj4+
PiDCoMKgIHsNCj4gPj4+Pj4gwqDCoMKgwqDCoMKgIGludCBpOw0KPiA+Pj4+Pg0KPiA+Pj4+PiAt
wqDCoMKgIGlmICh2aS0+aGFzX2N2cSkgew0KPiA+Pj4+PiAtwqDCoMKgwqDCoMKgwqAgdmktPmN0
cmwgPSBremFsbG9jKHNpemVvZigqdmktPmN0cmwpLCBHRlBfS0VSTkVMKTsNCj4gPj4+Pj4gLcKg
wqDCoMKgwqDCoMKgIGlmICghdmktPmN0cmwpDQo+ID4+Pj4+IC3CoMKgwqDCoMKgwqDCoMKgwqDC
oMKgIGdvdG8gZXJyX2N0cmw7DQo+ID4+Pj4+IC3CoMKgwqAgfSBlbHNlIHsNCj4gPj4+Pj4gLcKg
wqDCoMKgwqDCoMKgIHZpLT5jdHJsID0gTlVMTDsNCj4gPj4+Pj4gLcKgwqDCoCB9DQo+ID4+Pj4+
IMKgwqDCoMKgwqDCoCB2aS0+c3EgPSBrY2FsbG9jKHZpLT5tYXhfcXVldWVfcGFpcnMsIHNpemVv
ZigqdmktPnNxKSwNCj4gPj4+Pj4gR0ZQX0tFUk5FTCk7DQo+ID4+Pj4+IMKgwqDCoMKgwqDCoCBp
ZiAoIXZpLT5zcSkNCj4gPj4+Pj4gwqDCoMKgwqDCoMKgwqDCoMKgwqAgZ290byBlcnJfc3E7DQo+
ID4+Pj4+IEBAIC0yODg0LDYgKzI4NzgsMTIgQEAgc3RhdGljIGludCB2aXJ0bmV0X2FsbG9jX3F1
ZXVlcyhzdHJ1Y3QNCj4gPj4+PiB2aXJ0bmV0X2luZm8gKnZpKQ0KPiA+Pj4+PiDCoMKgwqDCoMKg
wqAgaWYgKCF2aS0+cnEpDQo+ID4+Pj4+IMKgwqDCoMKgwqDCoMKgwqDCoMKgIGdvdG8gZXJyX3Jx
Ow0KPiA+Pj4+Pg0KPiA+Pj4+PiArwqDCoMKgIGlmICh2aS0+aGFzX2N2cSkgew0KPiA+Pj4+PiAr
wqDCoMKgwqDCoMKgwqAgdmktPmN0cmwgPSBremFsbG9jKHNpemVvZigqdmktPmN0cmwpLCBHRlBf
S0VSTkVMKTsNCj4gPj4+Pj4gK8KgwqDCoMKgwqDCoMKgIGlmICghdmktPmN0cmwpDQo+ID4+Pj4+
ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGdvdG8gZXJyX2N0cmw7DQo+ID4+Pj4+ICvCoMKgwqAg
fQ0KPiA+Pj4+PiArDQo+ID4+Pj4+IMKgwqDCoMKgwqDCoCBJTklUX0RFTEFZRURfV09SSygmdmkt
PnJlZmlsbCwgcmVmaWxsX3dvcmspOw0KPiA+Pj4+PiDCoMKgwqDCoMKgwqAgZm9yIChpID0gMDsg
aSA8IHZpLT5tYXhfcXVldWVfcGFpcnM7IGkrKykgew0KPiA+Pj4+PiDCoMKgwqDCoMKgwqDCoMKg
wqDCoCB2aS0+cnFbaV0ucGFnZXMgPSBOVUxMOyBAQCAtMjkwMiwxMSArMjkwMiwxMSBAQCBzdGF0
aWMNCj4gPj4+Pj4gaW50IHZpcnRuZXRfYWxsb2NfcXVldWVzKHN0cnVjdCB2aXJ0bmV0X2luZm8g
KnZpKQ0KPiA+Pj4+Pg0KPiA+Pj4+PiDCoMKgwqDCoMKgwqAgcmV0dXJuIDA7DQo+ID4+Pj4+DQo+
ID4+Pj4+ICtlcnJfY3RybDoNCj4gPj4+Pj4gK8KgwqDCoCBrZnJlZSh2aS0+cnEpOw0KPiA+Pj4+
PiDCoMKgIGVycl9ycToNCj4gPj4+Pj4gwqDCoMKgwqDCoMKgIGtmcmVlKHZpLT5zcSk7DQo+ID4+
Pj4+IMKgwqAgZXJyX3NxOg0KPiA+Pj4+PiAtwqDCoMKgIGtmcmVlKHZpLT5jdHJsKTsNCj4gPj4+
Pj4gLWVycl9jdHJsOg0KPiA+Pj4+PiDCoMKgwqDCoMKgwqAgcmV0dXJuIC1FTk9NRU07DQo+ID4+
Pj4+IMKgwqAgfQ0KPiA+Pj4+Pg0KPiA+DQo=
