Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA954399FDF
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 13:34:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229791AbhFCLgf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 07:36:35 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:7092 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229786AbhFCLge (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Jun 2021 07:36:34 -0400
Received: from dggeme759-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4FwkJL6l3vzYqQ7;
        Thu,  3 Jun 2021 19:32:02 +0800 (CST)
Received: from dggpemm500008.china.huawei.com (7.185.36.136) by
 dggeme759-chm.china.huawei.com (10.3.19.105) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Thu, 3 Jun 2021 19:34:47 +0800
Received: from dggpemm500008.china.huawei.com ([7.185.36.136]) by
 dggpemm500008.china.huawei.com ([7.185.36.136]) with mapi id 15.01.2176.012;
 Thu, 3 Jun 2021 19:34:47 +0800
From:   wangyunjian <wangyunjian@huawei.com>
To:     Jason Wang <jasowang@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "mst@redhat.com" <mst@redhat.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        dingxiaoxiong <dingxiaoxiong@huawei.com>
Subject: RE: [PATCH net-next] virtio_net: set link state down when virtqueue
 is broken
Thread-Topic: [PATCH net-next] virtio_net: set link state down when virtqueue
 is broken
Thread-Index: AQHXUiPuxqZ0kftZNUuaGRJYw289Yar2NWAAgAJoQrCAA9IngIAFwL5w
Date:   Thu, 3 Jun 2021 11:34:47 +0000
Message-ID: <20a5f1bd8a5a49fa8c0f90875a49631b@huawei.com>
References: <79907bf6c835572b4af92f16d9a3ff2822b1c7ea.1622028946.git.wangyunjian@huawei.com>
 <03c68dd1-a636-9d3b-1dec-5e11c8025ccc@redhat.com>
 <d18383f7e675452d9392321506db6fa0@huawei.com>
 <0fcc1413-cb20-7a17-bdcd-6f9994990432@redhat.com>
In-Reply-To: <0fcc1413-cb20-7a17-bdcd-6f9994990432@redhat.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.174.243.60]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBKYXNvbiBXYW5nIFttYWlsdG86
amFzb3dhbmdAcmVkaGF0LmNvbV0NCj4gU2VudDogTW9uZGF5LCBNYXkgMzEsIDIwMjEgMTE6Mjkg
QU0NCj4gVG86IHdhbmd5dW5qaWFuIDx3YW5neXVuamlhbkBodWF3ZWkuY29tPjsgbmV0ZGV2QHZn
ZXIua2VybmVsLm9yZw0KPiBDYzoga3ViYUBrZXJuZWwub3JnOyBkYXZlbUBkYXZlbWxvZnQubmV0
OyBtc3RAcmVkaGF0LmNvbTsNCj4gdmlydHVhbGl6YXRpb25AbGlzdHMubGludXgtZm91bmRhdGlv
bi5vcmc7IGRpbmd4aWFveGlvbmcNCj4gPGRpbmd4aWFveGlvbmdAaHVhd2VpLmNvbT4NCj4gU3Vi
amVjdDogUmU6IFtQQVRDSCBuZXQtbmV4dF0gdmlydGlvX25ldDogc2V0IGxpbmsgc3RhdGUgZG93
biB3aGVuIHZpcnRxdWV1ZSBpcw0KPiBicm9rZW4NCj4gDQo+IA0KPiDlnKggMjAyMS81LzI4IOS4
i+WNiDY6NTgsIHdhbmd5dW5qaWFuIOWGmemBkzoNCj4gPj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdl
LS0tLS0NCj4gPj4+IEZyb206IFl1bmppYW4gV2FuZyA8d2FuZ3l1bmppYW5AaHVhd2VpLmNvbT4N
Cj4gPj4+DQo+ID4+PiBUaGUgTklDIGNhbid0IHJlY2VpdmUvc2VuZCBwYWNrZXRzIGlmIGEgcngv
dHggdmlydHF1ZXVlIGlzIGJyb2tlbi4NCj4gPj4+IEhvd2V2ZXIsIHRoZSBsaW5rIHN0YXRlIG9m
IHRoZSBOSUMgaXMgc3RpbGwgbm9ybWFsLiBBcyBhIHJlc3VsdCwgdGhlDQo+ID4+PiB1c2VyIGNh
bm5vdCBkZXRlY3QgdGhlIE5JQyBleGNlcHRpb24uDQo+ID4+DQo+ID4+IERvZXNuJ3Qgd2UgaGF2
ZToNCj4gPj4NCj4gPj4gICDCoMKgwqDCoMKgwqAgLyogVGhpcyBzaG91bGQgbm90IGhhcHBlbiEg
Ki8NCj4gPj4gICDCoMKgwqDCoMKgwqDCoCBpZiAodW5saWtlbHkoZXJyKSkgew0KPiA+PiAgIMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBkZXYtPnN0YXRzLnR4X2ZpZm9fZXJyb3JzKys7
DQo+ID4+ICAgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGlmIChuZXRfcmF0ZWxpbWl0
KCkpDQo+ID4+ICAgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oCBkZXZfd2FybigmZGV2LT5kZXYsDQo+ID4+ICAgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAiVW5leHBlY3RlZCBUWFEgKCVk
KQ0KPiBxdWV1ZQ0KPiA+PiBmYWlsdXJlOiAlZFxuIiwNCj4gPj4gICDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHFudW0sIGVy
cik7DQo+ID4+ICAgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGRldi0+c3RhdHMudHhf
ZHJvcHBlZCsrOw0KPiA+PiAgIMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBkZXZfa2Zy
ZWVfc2tiX2FueShza2IpOw0KPiA+PiAgIMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBy
ZXR1cm4gTkVUREVWX1RYX09LOw0KPiA+PiAgIMKgwqDCoMKgwqDCoMKgIH0NCj4gPj4NCj4gPj4g
V2hpY2ggc2hvdWxkIGJlIHN1ZmZpY2llbnQ/DQo+ID4gVGhlcmUgbWF5IGJlIG90aGVyIHJlYXNv
bnMgZm9yIHRoaXMgZXJyb3IsIGUuZyAtRU5PU1BDKG5vIGZyZWUgZGVzYykuDQo+IA0KPiANCj4g
VGhpcyBzaG91bGQgbm90IGhhcHBlbiB1bmxlc3MgdGhlIGRldmljZSBvciBkcml2ZXIgaXMgYnVn
Z3kuIFdlIGFsd2F5cyByZXNlcnZlZA0KPiBzdWZmaWNpZW50IHNsb3RzOg0KPiANCj4gIMKgwqDC
oMKgwqDCoMKgIGlmIChzcS0+dnEtPm51bV9mcmVlIDwgMitNQVhfU0tCX0ZSQUdTKSB7DQo+ICDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgbmV0aWZfc3RvcF9zdWJxdWV1ZShkZXYsIHFu
dW0pOyAuLi4NCj4gDQo+IA0KPiA+IEFuZCBpZiByeCB2aXJ0cXVldWUgaXMgYnJva2VuLCB0aGVy
ZSBpcyBubyBlcnJvciBzdGF0aXN0aWNzLg0KPiANCj4gDQo+IEZlZWwgZnJlZSB0byBhZGQgb25l
IGlmIGl0J3MgbmVjZXNzYXJ5Lg0KDQpDdXJyZW50bHkgcmVjZWl2aW5nIHNjZW5hcmlvLCBpdCBp
cyBpbXBvc3NpYmxlIHRvIGRpc3Rpbmd1aXNoIHdoZXRoZXIgdGhlIHJlYXNvbiBmb3INCm5vdCBy
ZWNlaXZpbmcgcGFja2V0IGlzIHZpcnRxdWV1ZSdzIGJyb2tlbiBvciBubyBwYWNrZXQuDQoNCj4g
DQo+IExldCdzIGxlYXZlIHRoZSBwb2xpY3kgZGVjaXNpb24gKGxpbmsgZG93bikgdG8gdXNlcnNw
YWNlLg0KPiANCj4gDQo+ID4NCj4gPj4NCj4gPj4+IFRoZSBkcml2ZXIgY2FuIHNldCB0aGUgbGlu
ayBzdGF0ZSBkb3duIHdoZW4gdGhlIHZpcnRxdWV1ZSBpcyBicm9rZW4uDQo+ID4+PiBJZiB0aGUg
c3RhdGUgaXMgZG93biwgdGhlIHVzZXIgY2FuIHN3aXRjaCBvdmVyIHRvIGFub3RoZXIgTklDLg0K
PiA+Pg0KPiA+PiBOb3RlIHRoYXQsIHdlIHByb2JhYmx5IG5lZWQgdGhlIHdhdGNoZG9nIGZvciB2
aXJ0aW8tbmV0IGluIG9yZGVyIHRvDQo+ID4+IGJlIGEgY29tcGxldGUgc29sdXRpb24uDQo+ID4g
WWVzLCBJIGNhbiB0aGluayBvZiBpcyB0aGF0IHRoZSB2aXJ0cXVldWUncyBicm9rZW4gZXhjZXB0
aW9uIGlzIGRldGVjdGVkIG9uDQo+IHdhdGNoZG9nLg0KPiA+IElzIHRoZXJlIGFueXRoaW5nIGVs
c2UgdGhhdCBuZWVkcyB0byBiZSBkb25lPw0KPiANCj4gDQo+IEJhc2ljYWxseSwgaXQncyBhbGwg
YWJvdXQgVFggc3RhbGwgd2hpY2ggd2F0Y2hkb2cgdHJpZXMgdG8gY2F0Y2guIEJyb2tlbiB2cSBp
cyBvbmx5DQo+IG9uZSBvZiB0aGUgcG9zc2libGUgcmVhc29uLg0KDQpBcmUgdGhlcmUgYW55IHBs
YW5zIGZvciB0aGUgd2F0Y2hkb2c/DQoNClRoYW5rcw0KDQo+IA0KPiBUaGFua3MNCj4gDQo+IA0K
PiA+DQo+ID4gVGhhbmtzDQo+ID4NCj4gPj4gVGhhbmtzDQo+ID4+DQo+ID4+DQoNCg==
