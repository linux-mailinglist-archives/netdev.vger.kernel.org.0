Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 181EC11FD68
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 05:02:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726676AbfLPECK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Dec 2019 23:02:10 -0500
Received: from mx21.baidu.com ([220.181.3.85]:35752 "EHLO baidu.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726437AbfLPECJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 15 Dec 2019 23:02:09 -0500
Received: from BC-Mail-Ex14.internal.baidu.com (unknown [172.31.51.54])
        by Forcepoint Email with ESMTPS id E2AAA99D2612B9F25FA0;
        Mon, 16 Dec 2019 12:02:04 +0800 (CST)
Received: from BJHW-Mail-Ex13.internal.baidu.com (10.127.64.36) by
 BC-Mail-Ex14.internal.baidu.com (172.31.51.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1531.3; Mon, 16 Dec 2019 12:02:04 +0800
Received: from BJHW-Mail-Ex13.internal.baidu.com ([100.100.100.36]) by
 BJHW-Mail-Ex13.internal.baidu.com ([100.100.100.36]) with mapi id
 15.01.1713.004; Mon, 16 Dec 2019 12:02:04 +0800
From:   "Li,Rongqing" <lirongqing@baidu.com>
To:     Yunsheng Lin <linyunsheng@huawei.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>
CC:     Saeed Mahameed <saeedm@mellanox.com>,
        "ilias.apalodimas@linaro.org" <ilias.apalodimas@linaro.org>,
        "jonathan.lemon@gmail.com" <jonathan.lemon@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "mhocko@kernel.org" <mhocko@kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Subject: =?utf-8?B?562U5aSNOiBbUEFUQ0hdW3YyXSBwYWdlX3Bvb2w6IGhhbmRsZSBwYWdlIHJl?=
 =?utf-8?B?Y3ljbGUgZm9yIE5VTUFfTk9fTk9ERSBjb25kaXRpb24=?=
Thread-Topic: [PATCH][v2] page_pool: handle page recycle for NUMA_NO_NODE
 condition
Thread-Index: AQHVsZIrr0J3dgd4XE+VTzKxYVWGCKe7fWqAgACmZRA=
Date:   Mon, 16 Dec 2019 04:02:04 +0000
Message-ID: <a5dea60221d84886991168781361b591@baidu.com>
References: <1575624767-3343-1-git-send-email-lirongqing@baidu.com>
 <9fecbff3518d311ec7c3aee9ae0315a73682a4af.camel@mellanox.com>
 <20191211194933.15b53c11@carbon>
 <831ed886842c894f7b2ffe83fe34705180a86b3b.camel@mellanox.com>
 <0a252066-fdc3-a81d-7a36-8f49d2babc01@huawei.com>
 <20191212111831.2a9f05d3@carbon>
 <7c555cb1-6beb-240d-08f8-7044b9087fe4@huawei.com>
 <1d4f10f4c0f1433bae658df8972a904f@baidu.com>
 <079a0315-efea-9221-8538-47decf263684@huawei.com>
 <20191213094845.56fb42a4@carbon>
 <15be326d-1811-329c-424c-6dd22b0604a8@huawei.com>
In-Reply-To: <15be326d-1811-329c-424c-6dd22b0604a8@huawei.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.22.198.6]
x-baidu-bdmsfe-datecheck: 1_BC-Mail-Ex14_2019-12-16 12:02:04:855
x-baidu-bdmsfe-viruscheck: BC-Mail-Ex14_GRAY_Inside_WithoutAtta_2019-12-16
 12:02:04:824
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS3pgq7ku7bljp/ku7YtLS0tLQ0KPiDlj5Hku7bkuro6IFl1bnNoZW5nIExpbiBb
bWFpbHRvOmxpbnl1bnNoZW5nQGh1YXdlaS5jb21dDQo+IOWPkemAgeaXtumXtDogMjAxOeW5tDEy
5pyIMTbml6UgOTo1MQ0KPiDmlLbku7bkuro6IEplc3BlciBEYW5nYWFyZCBCcm91ZXIgPGJyb3Vl
ckByZWRoYXQuY29tPg0KPiDmioTpgIE6IExpLFJvbmdxaW5nIDxsaXJvbmdxaW5nQGJhaWR1LmNv
bT47IFNhZWVkIE1haGFtZWVkDQo+IDxzYWVlZG1AbWVsbGFub3guY29tPjsgaWxpYXMuYXBhbG9k
aW1hc0BsaW5hcm8ub3JnOw0KPiBqb25hdGhhbi5sZW1vbkBnbWFpbC5jb207IG5ldGRldkB2Z2Vy
Lmtlcm5lbC5vcmc7IG1ob2Nrb0BrZXJuZWwub3JnOw0KPiBwZXRlcnpAaW5mcmFkZWFkLm9yZzsg
R3JlZyBLcm9haC1IYXJ0bWFuIDxncmVna2hAbGludXhmb3VuZGF0aW9uLm9yZz47DQo+IGJoZWxn
YWFzQGdvb2dsZS5jb207IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmc7IEJqw7ZybiBUw7Zw
ZWwNCj4gPGJqb3JuLnRvcGVsQGludGVsLmNvbT4NCj4g5Li76aKYOiBSZTogW1BBVENIXVt2Ml0g
cGFnZV9wb29sOiBoYW5kbGUgcGFnZSByZWN5Y2xlIGZvciBOVU1BX05PX05PREUNCj4gY29uZGl0
aW9uDQo+IA0KPiBPbiAyMDE5LzEyLzEzIDE2OjQ4LCBKZXNwZXIgRGFuZ2FhcmQgQnJvdWVyIHdy
b3RlOj4gWW91IGFyZSBiYXNpY2FsbHkgc2F5aW5nDQo+IHRoYXQgdGhlIE5VTUEgY2hlY2sgc2hv
dWxkIGJlIG1vdmVkIHRvDQo+ID4gYWxsb2NhdGlvbiB0aW1lLCBhcyBpdCBpcyBydW5uaW5nIHRo
ZSBSWC1DUFUgKE5BUEkpLiAgQW5kIGV2ZW50dWFsbHkNCj4gPiBhZnRlciBzb21lIHRpbWUgdGhl
IHBhZ2VzIHdpbGwgY29tZSBmcm9tIGNvcnJlY3QgTlVNQSBub2RlLg0KPiA+DQo+ID4gSSB0aGlu
ayB3ZSBjYW4gZG8gdGhhdCwgYW5kIG9ubHkgYWZmZWN0IHRoZSBzZW1pLWZhc3QtcGF0aC4NCj4g
PiBXZSBqdXN0IG5lZWQgdG8gaGFuZGxlIHRoYXQgcGFnZXMgaW4gdGhlIHB0cl9yaW5nIHRoYXQg
YXJlIHJlY3ljbGVkDQo+ID4gY2FuIGJlIGZyb20gdGhlIHdyb25nIE5VTUEgbm9kZS4gIEluIF9f
cGFnZV9wb29sX2dldF9jYWNoZWQoKSB3aGVuDQo+ID4gY29uc3VtaW5nIHBhZ2VzIGZyb20gdGhl
IHB0cl9yaW5nIChfX3B0cl9yaW5nX2NvbnN1bWVfYmF0Y2hlZCksIHRoZW4NCj4gPiB3ZSBjYW4g
ZXZpY3QgcGFnZXMgZnJvbSB3cm9uZyBOVU1BIG5vZGUuDQo+IA0KPiBZZXMsIHRoYXQncyB3b3Jr
YWJsZS4NCj4gDQo+ID4NCj4gPiBGb3IgdGhlIHBvb2wtPmFsbG9jLmNhY2hlIHdlIGVpdGhlciBh
Y2NlcHQsIHRoYXQgaXQgd2lsbCBldmVudHVhbGx5DQo+ID4gYWZ0ZXIgc29tZSB0aW1lIGJlIGVt
cHRpZWQgKGl0IGlzIG9ubHkgaW4gYSAxMDAlIFhEUF9EUk9QIHdvcmtsb2FkIHRoYXQNCj4gPiBp
dCB3aWxsIGNvbnRpbnVlIHRvIHJldXNlIHNhbWUgcGFnZXMpLiAgIE9yIHdlIHNpbXBseSBjbGVh
ciB0aGUNCj4gPiBwb29sLT5hbGxvYy5jYWNoZSB3aGVuIGNhbGxpbmcgcGFnZV9wb29sX3VwZGF0
ZV9uaWQoKS4NCj4gDQo+IFNpbXBseSBjbGVhcmluZyB0aGUgcG9vbC0+YWxsb2MuY2FjaGUgd2hl
biBjYWxsaW5nIHBhZ2VfcG9vbF91cGRhdGVfbmlkKCkNCj4gc2VlbXMgYmV0dGVyLg0KPiANCg0K
SG93IGFib3V0IHRoZSBiZWxvdyBjb2RlcywgdGhlIGRyaXZlciBjYW4gY29uZmlndXJlIHAubmlk
IHRvIGFueSwgd2hpY2ggd2lsbCBiZSBhZGp1c3RlZCBpbiBOQVBJIHBvbGxpbmcsIGlycSBtaWdy
YXRpb24gd2lsbCBub3QgYmUgcHJvYmxlbSwgYnV0IGl0IHdpbGwgYWRkIGEgY2hlY2sgaW50byBo
b3QgcGF0aC4NCg0KZGlmZiAtLWdpdCBhL25ldC9jb3JlL3BhZ2VfcG9vbC5jIGIvbmV0L2NvcmUv
cGFnZV9wb29sLmMNCmluZGV4IGE2YWVmZTk4OTA0My4uNDM3NGE2MjM5ZDE3IDEwMDY0NA0KLS0t
IGEvbmV0L2NvcmUvcGFnZV9wb29sLmMNCisrKyBiL25ldC9jb3JlL3BhZ2VfcG9vbC5jDQpAQCAt
MTA4LDYgKzEwOCwxMCBAQCBzdGF0aWMgc3RydWN0IHBhZ2UgKl9fcGFnZV9wb29sX2dldF9jYWNo
ZWQoc3RydWN0IHBhZ2VfcG9vbCAqcG9vbCkNCiAgICAgICAgICAgICAgICBpZiAobGlrZWx5KHBv
b2wtPmFsbG9jLmNvdW50KSkgew0KICAgICAgICAgICAgICAgICAgICAgICAgLyogRmFzdC1wYXRo
ICovDQogICAgICAgICAgICAgICAgICAgICAgICBwYWdlID0gcG9vbC0+YWxsb2MuY2FjaGVbLS1w
b29sLT5hbGxvYy5jb3VudF07DQorDQorICAgICAgICAgICAgICAgICAgICAgICBpZiAodW5saWtl
bHkoUkVBRF9PTkNFKHBvb2wtPnAubmlkKSAhPSBudW1hX21lbV9pZCgpKSkNCisgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgV1JJVEVfT05DRShwb29sLT5wLm5pZCwgbnVtYV9tZW1faWQo
KSk7DQorDQogICAgICAgICAgICAgICAgICAgICAgICByZXR1cm4gcGFnZTsNCiAgICAgICAgICAg
ICAgICB9DQogICAgICAgICAgICAgICAgcmVmaWxsID0gdHJ1ZTsNCkBAIC0xNTUsNiArMTU5LDEw
IEBAIHN0YXRpYyBzdHJ1Y3QgcGFnZSAqX19wYWdlX3Bvb2xfYWxsb2NfcGFnZXNfc2xvdyhzdHJ1
Y3QgcGFnZV9wb29sICpwb29sLA0KICAgICAgICBpZiAocG9vbC0+cC5vcmRlcikNCiAgICAgICAg
ICAgICAgICBnZnAgfD0gX19HRlBfQ09NUDsNCiANCisNCisgICAgICAgaWYgKHVubGlrZWx5KFJF
QURfT05DRShwb29sLT5wLm5pZCkgIT0gbnVtYV9tZW1faWQoKSkpDQorICAgICAgICAgICAgICAg
V1JJVEVfT05DRShwb29sLT5wLm5pZCwgbnVtYV9tZW1faWQoKSk7DQorDQogICAgICAgIC8qIEZV
VFVSRSBkZXZlbG9wbWVudDoNCiAgICAgICAgICoNCiAgICAgICAgICogQ3VycmVudCBzbG93LXBh
dGggZXNzZW50aWFsbHkgZmFsbHMgYmFjayB0byBzaW5nbGUgcGFnZQ0KVGhhbmtzDQoNCi1MaQ0K
PiA+DQoNCg==
