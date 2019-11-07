Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ACC29F313C
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 15:21:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389272AbfKGOVL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 09:21:11 -0500
Received: from szxga02-in.huawei.com ([45.249.212.188]:2504 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726924AbfKGOVI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Nov 2019 09:21:08 -0500
Received: from DGGEMM402-HUB.china.huawei.com (unknown [172.30.72.57])
        by Forcepoint Email with ESMTP id 16F2A35A5CA297AD0A5C;
        Thu,  7 Nov 2019 22:21:02 +0800 (CST)
Received: from dggeme707-chm.china.huawei.com (10.1.199.103) by
 DGGEMM402-HUB.china.huawei.com (10.3.20.210) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 7 Nov 2019 22:21:01 +0800
Received: from lhreml703-chm.china.huawei.com (10.201.108.52) by
 dggeme707-chm.china.huawei.com (10.1.199.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1713.5; Thu, 7 Nov 2019 22:20:59 +0800
Received: from lhreml703-chm.china.huawei.com ([10.201.68.198]) by
 lhreml703-chm.china.huawei.com ([10.201.68.198]) with mapi id 15.01.1713.004;
 Thu, 7 Nov 2019 14:20:57 +0000
From:   Salil Mehta <salil.mehta@huawei.com>
To:     Marc Zyngier <maz@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "Zhuangyuzeng (Yisen)" <yisen.zhuang@huawei.com>,
        "lipeng (Y)" <lipeng321@huawei.com>,
        "mehta.salil@opnsrc.net" <mehta.salil@opnsrc.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linuxarm <linuxarm@huawei.com>
Subject: RE: [PATCH net] net: hns: Fix the stray netpoll locks causing
  deadlock in NAPI path
Thread-Topic: [PATCH net] net: hns: Fix the stray netpoll locks causing
  deadlock in NAPI path
Thread-Index: AQHVlXV9oPVhm3923UeaSbHNAy05jqd/v/1g
Date:   Thu, 7 Nov 2019 14:20:57 +0000
Message-ID: <9c15e61f739045ee876ae3fbb1e49446@huawei.com>
References: <20191106185405.23112-1-salil.mehta@huawei.com>
 <a6f06cfc7ef91685746dfe5ab6c56401@www.loen.fr>
In-Reply-To: <a6f06cfc7ef91685746dfe5ab6c56401@www.loen.fr>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.202.226.45]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgTWFyYywNCg0KPiBGcm9tOiBNYXJjIFp5bmdpZXIgW21haWx0bzptYXpAa2VybmVsLm9yZ10N
Cj4gU2VudDogVGh1cnNkYXksIE5vdmVtYmVyIDcsIDIwMTkgMjoxMyBQTQ0KPiBUbzogU2FsaWwg
TWVodGEgPHNhbGlsLm1laHRhQGh1YXdlaS5jb20+DQo+IA0KPiBIaSBTYWxpbCwNCj4gDQo+IE9u
IDIwMTktMTEtMDYgMjA6MDMsIFNhbGlsIE1laHRhIHdyb3RlOg0KPiA+IFRoaXMgcGF0Y2ggZml4
ZXMgdGhlIHByb2JsZW0gb2YgdGhlIHNwaW4gbG9ja3MsIG9yaWdpbmFsbHkNCj4gPiBtZWFudCBm
b3IgdGhlIG5ldHBvbGwgcGF0aCBvZiBobnMgZHJpdmVyLCBjYXVzaW5nIGRlYWRsb2NrIGluDQo+
ID4gdGhlIG5vcm1hbCBOQVBJIHBvbGwgcGF0aC4gVGhlIGlzc3VlIGhhcHBlbmVkIGR1ZSBwcmVz
ZW5jZSBvZg0KPiA+IHRoZSBzdHJheSBsZWZ0b3ZlciBzcGluIGxvY2sgY29kZSByZWxhdGVkIHRv
IHRoZSBuZXRwb2xsLA0KPiA+IHdob3NlIHN1cHBvcnQgd2FzIGVhcmxpZXIgcmVtb3ZlZCBmcm9t
IHRoZSBITlNbMV0sIGdvdCBhY3RpdmF0ZWQNCj4gPiBkdWUgdG8gZW5hYmxpbmcgb2YgTkVUX1BP
TExfQ09OVFJPTExFUiBzd2l0Y2guDQo+ID4NCj4gPiBFYXJsaWVyIGJhY2tncm91bmQ6DQo+ID4g
VGhlIG5ldHBvbGwgaGFuZGxpbmcgY29kZSBvcmlnaW5hbGx5IGhhZCB0aGlzIGJ1ZyhhcyBpZGVu
dGlmaWVkDQo+ID4gYnkgTWFyYyBaeW5naWVyWzJdKSBvZiB3cm9uZyBzcGluIGxvY2sgQVBJIGJl
aW5nIHVzZWQgd2hpY2ggZGlkDQo+ID4gbm90IGRpc2FibGUgdGhlIGludGVycnVwdHMgYW5kIGhl
bmNlIGNvdWxkIGNhdXNlIGxvY2tpbmcgaXNzdWVzLg0KPiA+IGkuZS4gaWYgdGhlIGxvY2sgd2Vy
ZSBmaXJzdCBhY3F1aXJlZCBpbiBjb250ZXh0IHRvIHRocmVhZCBsaWtlDQo+ID4gJ2lwJyB1dGls
IGFuZCB0aGlzIGxvY2sgaWYgZXZlciBnb3QgbGF0ZXIgYWNxdWlyZWQgYWdhaW4gaW4NCj4gPiBj
b250ZXh0IHRvIHRoZSBpbnRlcnJ1cHQgY29udGV4dCBsaWtlIFRYL1JYIChJbnRlcnJ1cHRzIGNv
dWxkDQo+ID4gYWx3YXlzIHByZS1lbXB0IHRoZSBsb2NrIGhvbGRpbmcgdGFzayBhbmQgYWNxdWly
ZSB0aGUgbG9jayBhZ2FpbikNCj4gPiBhbmQgaGVuY2UgY291bGQgY2F1c2UgZGVhZGxvY2suDQo+
ID4NCj4gPiBQcm9wb3NlZCBTb2x1dGlvbjoNCj4gPiAxLiBJZiB0aGUgbmV0cG9sbCB3YXMgZW5h
YmxlZCBpbiB0aGUgSE5TIGRyaXZlciwgd2hpY2ggaXMgbm90DQo+ID4gICAgcmlnaHQgbm93LCB3
ZSBjb3VsZCBoYXZlIHNpbXBseSB1c2VkIHNwaW5fW3VuXWxvY2tfaXJxc2F2ZSgpDQo+ID4gMi4g
QnV0IGFzIG5ldHBvbGwgaXMgZGlzYWJsZWQsIHRoZXJlZm9yZSwgaXQgaXMgYmVzdCB0byBnZXQg
cmlkDQo+ID4gICAgb2YgdGhlIGV4aXN0aW5nIGxvY2tzIGFuZCBzdHJheSBjb2RlIGZvciBub3cu
IFRoaXMgc2hvdWxkDQo+ID4gICAgc29sdmUgdGhlIHByb2JsZW0gcmVwb3J0ZWQgYnkgTWFyYy4N
Cj4gPg0KPiA+IEBNYXJjLA0KPiA+IENvdWxkIHlvdSBwbGVhc2UgdGVzdCB0aGlzIHBhdGNoIGFu
ZCBjb25maXJtIGlmIHRoZSBwcm9ibGVtIGlzDQo+ID4gZml4ZWQgYXQgeW91ciBlbmQ/DQo+IA0K
PiBZZXMsIHRoaXMgZml4ZXMgaXQsIGFsdGhvdWdoIHlvdSBtYXkgd2FudCB0byBmdWxseSBnZXQg
cmlkIG9mDQo+IHRoZSBub3cgdXNlbGVzcyBsb2NrOg0KDQoNCk9vcHMuLm1pc3NlZCB0aGVtLiBJ
IHdpbGwgZml4IHRoZXNlIGFzIHdlbGwgYW5kIGZsb2F0IFYyIHZlcnNpb24NCm9mIHRoaXMgcGF0
Y2guDQoNCg0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvaGlzaWxpY29uL2hu
cy9obmFlLmMNCj4gYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9oaXNpbGljb24vaG5zL2huYWUuYw0K
PiBpbmRleCA2ZDA0NTdlYjRmYWEuLjA4MzM5Mjc4YzcyMiAxMDA2NDQNCj4gLS0tIGEvZHJpdmVy
cy9uZXQvZXRoZXJuZXQvaGlzaWxpY29uL2hucy9obmFlLmMNCj4gKysrIGIvZHJpdmVycy9uZXQv
ZXRoZXJuZXQvaGlzaWxpY29uL2hucy9obmFlLmMNCj4gQEAgLTE5OSw3ICsxOTksNiBAQCBobmFl
X2luaXRfcmluZyhzdHJ1Y3QgaG5hZV9xdWV1ZSAqcSwgc3RydWN0DQo+IGhuYWVfcmluZyAqcmlu
ZywgaW50IGZsYWdzKQ0KPiANCj4gICAJcmluZy0+cSA9IHE7DQo+ICAgCXJpbmctPmZsYWdzID0g
ZmxhZ3M7DQo+IC0Jc3Bpbl9sb2NrX2luaXQoJnJpbmctPmxvY2spOw0KPiAgIAlyaW5nLT5jb2Fs
X3BhcmFtID0gcS0+aGFuZGxlLT5jb2FsX3BhcmFtOw0KPiAgIAlhc3NlcnQoIXJpbmctPmRlc2Mg
JiYgIXJpbmctPmRlc2NfY2IgJiYgIXJpbmctPmRlc2NfZG1hX2FkZHIpOw0KPiANCj4gZGlmZiAt
LWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L2hpc2lsaWNvbi9obnMvaG5hZS5oDQo+IGIvZHJp
dmVycy9uZXQvZXRoZXJuZXQvaGlzaWxpY29uL2hucy9obmFlLmgNCj4gaW5kZXggZTljNjdjMDZi
ZmQyLi42YWI5NDU4MzAyZTEgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L2hp
c2lsaWNvbi9obnMvaG5hZS5oDQo+ICsrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2hpc2lsaWNv
bi9obnMvaG5hZS5oDQo+IEBAIC0yNzQsOSArMjc0LDYgQEAgc3RydWN0IGhuYWVfcmluZyB7DQo+
ICAgCS8qIHN0YXRpc3RpYyAqLw0KPiAgIAlzdHJ1Y3QgcmluZ19zdGF0cyBzdGF0czsNCj4gDQo+
IC0JLyogcmluZyBsb2NrIGZvciBwb2xsIG9uZSAqLw0KPiAtCXNwaW5sb2NrX3QgbG9jazsNCj4g
LQ0KPiAgIAlkbWFfYWRkcl90IGRlc2NfZG1hX2FkZHI7DQo+ICAgCXUzMiBidWZfc2l6ZTsgICAg
ICAgLyogc2l6ZSBmb3IgaG5hZV9kZXNjLT5hZGRyLCBwcmVzZXQgYnkgQUUgKi8NCj4gICAJdTE2
IGRlc2NfbnVtOyAgICAgICAvKiB0b3RhbCBudW1iZXIgb2YgZGVzYyAqLw0KPiANCj4gV2l0aCB0
aGF0Og0KPiANCj4gQWNrZWQtYnk6IE1hcmMgWnluZ2llciA8bWF6QGtlcm5lbC5vcmc+DQo+IFRl
c3RlZC1ieTogTWFyYyBaeW5naWVyIDxtYXpAa2VybmVsLm9yZz4NCg0KDQpNYW55IHRoYW5rcyBm
b3IgeW91ciByZXZpZXcgYW5kIHRlc3RpbmcuDQoNCg0KQmVzdCBSZWdhcmRzDQpTYWxpbC4NCg==
