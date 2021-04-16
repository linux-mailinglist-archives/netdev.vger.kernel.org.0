Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1DE1361836
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 05:27:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236774AbhDPD2E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 23:28:04 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:3338 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234886AbhDPD2E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Apr 2021 23:28:04 -0400
Received: from DGGEML404-HUB.china.huawei.com (unknown [172.30.72.54])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4FM1lJ4Vytz14G2p;
        Fri, 16 Apr 2021 11:23:56 +0800 (CST)
Received: from dggpemm500008.china.huawei.com (7.185.36.136) by
 DGGEML404-HUB.china.huawei.com (10.3.17.39) with Microsoft SMTP Server (TLS)
 id 14.3.498.0; Fri, 16 Apr 2021 11:27:36 +0800
Received: from dggpemm500021.china.huawei.com (7.185.36.109) by
 dggpemm500008.china.huawei.com (7.185.36.136) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Fri, 16 Apr 2021 11:27:36 +0800
Received: from dggpemm500021.china.huawei.com ([7.185.36.109]) by
 dggpemm500021.china.huawei.com ([7.185.36.109]) with mapi id 15.01.2106.013;
 Fri, 16 Apr 2021 11:27:36 +0800
From:   "zhudi (J)" <zhudi21@huawei.com>
To:     linyunsheng <linyunsheng@huawei.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Chenxiang (EulerOS)" <rose.chen@huawei.com>
Subject: Re: [PATCH] net: fix a data race when get vlan device
Thread-Topic: [PATCH] net: fix a data race when get vlan device
Thread-Index: AdcycE64geMzb77xZE+VRIGaf0XN1g==
Date:   Fri, 16 Apr 2021 03:27:36 +0000
Message-ID: <b03d1c13bc0147ad87e06b3dfe602213@huawei.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.136.114.155]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiBkZXBlbmRlbmN5T24gMjAyMS80LzE1IDExOjM1LCB6aHVkaSB3cm90ZToNCj4gPiBGcm9tOiBE
aSBaaHUgPHpodWRpMjFAaHVhd2VpLmNvbT4NCj4gPg0KPiA+IFdlIGVuY291bnRlcmVkIGEgY3Jh
c2g6IGluIHRoZSBwYWNrZXQgcmVjZWl2aW5nIHByb2Nlc3MsIHdlIGdvdCBhbg0KPiA+IGlsbGVn
YWwgVkxBTiBkZXZpY2UgYWRkcmVzcywgYnV0IHRoZSBWTEFOIGRldmljZSBhZGRyZXNzIHNhdmVk
IGluDQo+ID4gdm1jb3JlIGlzIGNvcnJlY3QuIEFmdGVyIGNoZWNraW5nIHRoZSBjb2RlLCB3ZSBm
b3VuZCBhIHBvc3NpYmxlIGRhdGENCj4gPiBjb21wZXRpdGlvbjoNCj4gPiBDUFUgMDogICAgICAg
ICAgICAgICAgICAgICAgICAgICAgIENQVSAxOg0KPiA+ICAgICAoUkNVIHJlYWQgbG9jaykgICAg
ICAgICAgICAgICAgICAoUlROTCBsb2NrKQ0KPiA+ICAgICB2bGFuX2RvX3JlY2VpdmUoKQkJICAg
ICAgIHJlZ2lzdGVyX3ZsYW5fZGV2KCkNCj4gPiAgICAgICB2bGFuX2ZpbmRfZGV2KCkNCj4gPg0K
PiA+ICAgICAgICAgLT5fX3ZsYW5fZ3JvdXBfZ2V0X2RldmljZSgpCSAtPnZsYW5fZ3JvdXBfcHJl
YWxsb2NfdmlkKCkNCj4gPg0KPiA+IEluIHZsYW5fZ3JvdXBfcHJlYWxsb2NfdmlkKCksIFdlIG5l
ZWQgdG8gbWFrZSBzdXJlIHRoYXQga3phbGxvYyBpcw0KPiA+IGV4ZWN1dGVkIGJlZm9yZSBhc3Np
Z25pbmcgYSB2YWx1ZSB0byB2bGFuIGRldmljZXMgYXJyYXksIG90aGVyd2lzZSB3ZQ0KPiANCj4g
QXMgbXkgdW5kZXJzdGFuZGluZywgdGhlcmUgaXMgYSBkZXBlbmRlbmN5IGJldHdlZW4gY2FsbGlu
ZyBremFsbG9jKCkgYW5kDQo+IGFzc2lnbmluZyB0aGUgYWRkcmVzcyhyZXR1cm5lZCBmcm9tIGt6
YWxsb2MoKSkgdG8gdmctPnZsYW5fZGV2aWNlc19hcnJheXMsDQo+IENQVSBhbmQgY29tcGlsZXIg
Y2FuIHNlZSB0aGUgZGVwZW5kZW5jeSwgd2h5IGNhbid0IGl0IGhhbmRsaW5nIHRoZQ0KPiBkZXBl
bmRlbmN5IGJlZm9yZSBhZGRpbmcgdGhlIHNtcF93bWIoKT8NCj4gDQo+IFNlZSBDT05UUk9MIERF
UEVOREVOQ0lFUyBzZWN0aW9uIGluIERvY3VtZW50YXRpb24vbWVtb3J5LQ0KPiBiYXJyaWVycy50
eHQ6DQo+IA0KPiBIb3dldmVyLCBzdG9yZXMgYXJlIG5vdCBzcGVjdWxhdGVkLiAgVGhpcyBtZWFu
cyB0aGF0IG9yZGVyaW5nIC1pcy0gcHJvdmlkZWQNCj4gZm9yIGxvYWQtc3RvcmUgY29udHJvbCBk
ZXBlbmRlbmNpZXMsIGFzIGluIHRoZSBmb2xsb3dpbmcgZXhhbXBsZToNCj4gDQo+ICAgICAgICAg
cSA9IFJFQURfT05DRShhKTsNCj4gICAgICAgICBpZiAocSkgew0KPiAgICAgICAgICAgICAgICAg
V1JJVEVfT05DRShiLCAxKTsNCj4gICAgICAgICB9DQo+IA0KDQogTWF5YmUgSSBkaWRuJ3QgbWFr
ZSBpdCBjbGVhci4gIFRoaXMgbWVtb3J5IGlzb2xhdGlvbiBpcyB0byBlbnN1cmUgdGhlIG9yZGVy
IG9mDQogbWVtc2V0KG9iamVjdCwgMCwgc2l6ZSkgaW4ga3phbGxvYygpIG9wZXJhdGlvbnMgYW5k
IHRoZSBzdWJzZXF1ZW50IGFycmF5IGFzc2lnbm1lbnQgc3RhdGVtZW50cy4NCg0Ka3phbGxvYygp
DQogICAgLT5tZW1zZXQob2JqZWN0LCAwLCBzaXplKQ0KDQpzbXBfd21iKCkNCg0KdmctPnZsYW5f
ZGV2aWNlc19hcnJheXNbcGlkeF1bdmlkeF0gPSBhcnJheTsNCg0KQmVjYXVzZSBfX3ZsYW5fZ3Jv
dXBfZ2V0X2RldmljZSgpIGZ1bmN0aW9uIGRlcGVuZHMgb24gdGhpcyBvcmRlcg0KDQo+IA0KPiAN
Cj4gPiBtYXkgZ2V0IGEgd3JvbmcgYWRkcmVzcyBmcm9tIHRoZSBoYXJkd2FyZSBjYWNoZSBvbiBh
bm90aGVyIGNwdS4NCj4gPg0KPiA+IFNvIGZpeCBpdCBieSBhZGRpbmcgbWVtb3J5IGJhcnJpZXIg
aW5zdHJ1Y3Rpb24gdG8gZW5zdXJlIHRoZSBvcmRlciBvZg0KPiA+IG1lbW9yeSBvcGVyYXRpb25z
Lg0KPiA+DQo+ID4gU2lnbmVkLW9mZi1ieTogRGkgWmh1IDx6aHVkaTIxQGh1YXdlaS5jb20+DQo+
ID4gLS0tDQo+ID4gIG5ldC84MDIxcS92bGFuLmMgfCAyICsrDQo+ID4gIG5ldC84MDIxcS92bGFu
LmggfCAzICsrKw0KPiA+ICAyIGZpbGVzIGNoYW5nZWQsIDUgaW5zZXJ0aW9ucygrKQ0KPiA+DQo+
ID4gZGlmZiAtLWdpdCBhL25ldC84MDIxcS92bGFuLmMgYi9uZXQvODAyMXEvdmxhbi5jIGluZGV4
DQo+ID4gOGI2NDQxMTM3MTVlLi40ZjU0MWUwNWNkM2YgMTAwNjQ0DQo+ID4gLS0tIGEvbmV0Lzgw
MjFxL3ZsYW4uYw0KPiA+ICsrKyBiL25ldC84MDIxcS92bGFuLmMNCj4gPiBAQCAtNzEsNiArNzEs
OCBAQCBzdGF0aWMgaW50IHZsYW5fZ3JvdXBfcHJlYWxsb2NfdmlkKHN0cnVjdCB2bGFuX2dyb3Vw
DQo+ICp2ZywNCj4gPiAgCWlmIChhcnJheSA9PSBOVUxMKQ0KPiA+ICAJCXJldHVybiAtRU5PQlVG
UzsNCj4gPg0KPiA+ICsJc21wX3dtYigpOw0KPiA+ICsNCj4gPiAgCXZnLT52bGFuX2RldmljZXNf
YXJyYXlzW3BpZHhdW3ZpZHhdID0gYXJyYXk7DQo+ID4gIAlyZXR1cm4gMDsNCj4gPiAgfQ0KPiA+
IGRpZmYgLS1naXQgYS9uZXQvODAyMXEvdmxhbi5oIGIvbmV0LzgwMjFxL3ZsYW4uaCBpbmRleA0K
PiA+IDk1MzQwNTM2Mjc5NS4uNzQwOGZkYTA4NGQzIDEwMDY0NA0KPiA+IC0tLSBhL25ldC84MDIx
cS92bGFuLmgNCj4gPiArKysgYi9uZXQvODAyMXEvdmxhbi5oDQo+ID4gQEAgLTU3LDYgKzU3LDkg
QEAgc3RhdGljIGlubGluZSBzdHJ1Y3QgbmV0X2RldmljZQ0KPiA+ICpfX3ZsYW5fZ3JvdXBfZ2V0
X2RldmljZShzdHJ1Y3Qgdmxhbl9ncm91cCAqdmcsDQo+ID4NCj4gPiAgCWFycmF5ID0gdmctPnZs
YW5fZGV2aWNlc19hcnJheXNbcGlkeF0NCj4gPiAgCQkJCSAgICAgICBbdmxhbl9pZCAvDQo+IFZM
QU5fR1JPVVBfQVJSQVlfUEFSVF9MRU5dOw0KPiA+ICsNCj4gPiArCXNtcF9ybWIoKTsNCj4gPiAr
DQo+ID4gIAlyZXR1cm4gYXJyYXkgPyBhcnJheVt2bGFuX2lkICUgVkxBTl9HUk9VUF9BUlJBWV9Q
QVJUX0xFTl0gOg0KPiBOVUxMOyAgfQ0KPiA+DQo+ID4NCg0K
