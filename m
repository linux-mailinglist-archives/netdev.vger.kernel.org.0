Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0236C362FE1
	for <lists+netdev@lfdr.de>; Sat, 17 Apr 2021 15:06:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236187AbhDQMeV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Apr 2021 08:34:21 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:3947 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236058AbhDQMeV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Apr 2021 08:34:21 -0400
Received: from DGGEML401-HUB.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4FMsrj11vPz5qtb;
        Sat, 17 Apr 2021 20:31:33 +0800 (CST)
Received: from dggpemm100006.china.huawei.com (7.185.36.196) by
 DGGEML401-HUB.china.huawei.com (10.3.17.32) with Microsoft SMTP Server (TLS)
 id 14.3.498.0; Sat, 17 Apr 2021 20:33:52 +0800
Received: from dggpemm500021.china.huawei.com (7.185.36.109) by
 dggpemm100006.china.huawei.com (7.185.36.196) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Sat, 17 Apr 2021 20:33:52 +0800
Received: from dggpemm500021.china.huawei.com ([7.185.36.109]) by
 dggpemm500021.china.huawei.com ([7.185.36.109]) with mapi id 15.01.2106.013;
 Sat, 17 Apr 2021 20:33:52 +0800
From:   "zhudi (J)" <zhudi21@huawei.com>
To:     linyunsheng <linyunsheng@huawei.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Chenxiang (EulerOS)" <rose.chen@huawei.com>
Subject: Re: [PATCH] net: fix a data race when get vlan device
Thread-Topic: [PATCH] net: fix a data race when get vlan device
Thread-Index: AdczKo0XLZypNyTMTESPQwZzqKxfqQ==
Date:   Sat, 17 Apr 2021 12:33:51 +0000
Message-ID: <0ba3274f12e24e519bc61f30f0b90444@huawei.com>
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

PiBPbiAyMDIxLzQvMTYgMTE6MjcsIHpodWRpIChKKSB3cm90ZToNCj4gPj4gZGVwZW5kZW5jeU9u
IDIwMjEvNC8xNSAxMTozNSwgemh1ZGkgd3JvdGU6DQo+ID4+PiBGcm9tOiBEaSBaaHUgPHpodWRp
MjFAaHVhd2VpLmNvbT4NCj4gPj4+DQo+ID4+PiBXZSBlbmNvdW50ZXJlZCBhIGNyYXNoOiBpbiB0
aGUgcGFja2V0IHJlY2VpdmluZyBwcm9jZXNzLCB3ZSBnb3QgYW4NCj4gPj4+IGlsbGVnYWwgVkxB
TiBkZXZpY2UgYWRkcmVzcywgYnV0IHRoZSBWTEFOIGRldmljZSBhZGRyZXNzIHNhdmVkIGluDQo+
ID4+PiB2bWNvcmUgaXMgY29ycmVjdC4gQWZ0ZXIgY2hlY2tpbmcgdGhlIGNvZGUsIHdlIGZvdW5k
IGEgcG9zc2libGUgZGF0YQ0KPiA+Pj4gY29tcGV0aXRpb246DQo+ID4+PiBDUFUgMDogICAgICAg
ICAgICAgICAgICAgICAgICAgICAgIENQVSAxOg0KPiA+Pj4gICAgIChSQ1UgcmVhZCBsb2NrKSAg
ICAgICAgICAgICAgICAgIChSVE5MIGxvY2spDQo+ID4+PiAgICAgdmxhbl9kb19yZWNlaXZlKCkJ
CSAgICAgICByZWdpc3Rlcl92bGFuX2RldigpDQo+ID4+PiAgICAgICB2bGFuX2ZpbmRfZGV2KCkN
Cj4gPj4+DQo+ID4+PiAgICAgICAgIC0+X192bGFuX2dyb3VwX2dldF9kZXZpY2UoKQkgLT52bGFu
X2dyb3VwX3ByZWFsbG9jX3ZpZCgpDQo+ID4+Pg0KPiA+Pj4gSW4gdmxhbl9ncm91cF9wcmVhbGxv
Y192aWQoKSwgV2UgbmVlZCB0byBtYWtlIHN1cmUgdGhhdCBremFsbG9jIGlzDQo+ID4+PiBleGVj
dXRlZCBiZWZvcmUgYXNzaWduaW5nIGEgdmFsdWUgdG8gdmxhbiBkZXZpY2VzIGFycmF5LCBvdGhl
cndpc2Ugd2UNCj4gPj4NCj4gPj4gQXMgbXkgdW5kZXJzdGFuZGluZywgdGhlcmUgaXMgYSBkZXBl
bmRlbmN5IGJldHdlZW4gY2FsbGluZyBremFsbG9jKCkgYW5kDQo+ID4+IGFzc2lnbmluZyB0aGUg
YWRkcmVzcyhyZXR1cm5lZCBmcm9tIGt6YWxsb2MoKSkgdG8gdmctPnZsYW5fZGV2aWNlc19hcnJh
eXMsDQo+ID4+IENQVSBhbmQgY29tcGlsZXIgY2FuIHNlZSB0aGUgZGVwZW5kZW5jeSwgd2h5IGNh
bid0IGl0IGhhbmRsaW5nIHRoZQ0KPiA+PiBkZXBlbmRlbmN5IGJlZm9yZSBhZGRpbmcgdGhlIHNt
cF93bWIoKT8NCj4gPj4NCj4gPj4gU2VlIENPTlRST0wgREVQRU5ERU5DSUVTIHNlY3Rpb24gaW4g
RG9jdW1lbnRhdGlvbi9tZW1vcnktDQo+ID4+IGJhcnJpZXJzLnR4dDoNCj4gPj4NCj4gPj4gSG93
ZXZlciwgc3RvcmVzIGFyZSBub3Qgc3BlY3VsYXRlZC4gIFRoaXMgbWVhbnMgdGhhdCBvcmRlcmlu
ZyAtaXMtDQo+IHByb3ZpZGVkDQo+ID4+IGZvciBsb2FkLXN0b3JlIGNvbnRyb2wgZGVwZW5kZW5j
aWVzLCBhcyBpbiB0aGUgZm9sbG93aW5nIGV4YW1wbGU6DQo+ID4+DQo+ID4+ICAgICAgICAgcSA9
IFJFQURfT05DRShhKTsNCj4gPj4gICAgICAgICBpZiAocSkgew0KPiA+PiAgICAgICAgICAgICAg
ICAgV1JJVEVfT05DRShiLCAxKTsNCj4gPj4gICAgICAgICB9DQo+ID4+DQo+ID4NCj4gPiAgTWF5
YmUgSSBkaWRuJ3QgbWFrZSBpdCBjbGVhci4gIFRoaXMgbWVtb3J5IGlzb2xhdGlvbiBpcyB0byBl
bnN1cmUgdGhlIG9yZGVyDQo+IG9mDQo+ID4gIG1lbXNldChvYmplY3QsIDAsIHNpemUpIGluIGt6
YWxsb2MoKSBvcGVyYXRpb25zIGFuZCB0aGUgc3Vic2VxdWVudCBhcnJheQ0KPiBhc3NpZ25tZW50
IHN0YXRlbWVudHMuDQo+ID4NCj4gPiBremFsbG9jKCkNCj4gPiAgICAgLT5tZW1zZXQob2JqZWN0
LCAwLCBzaXplKQ0KPiA+DQo+ID4gc21wX3dtYigpDQo+ID4NCj4gPiB2Zy0+dmxhbl9kZXZpY2Vz
X2FycmF5c1twaWR4XVt2aWR4XSA9IGFycmF5Ow0KPiA+DQo+ID4gQmVjYXVzZSBfX3ZsYW5fZ3Jv
dXBfZ2V0X2RldmljZSgpIGZ1bmN0aW9uIGRlcGVuZHMgb24gdGhpcyBvcmRlcg0KPiANCg0KPiBU
aGFua3MgZm9yIGNsYXJpZnksIGl0IHdvdWxkIGJlIGdvb2QgdG8gbWVudGlvbiB0aGlzIGluIHRo
ZQ0KPiBjb21taXQgbG9nIHRvby4NCg0KT0ssICBJJ2xsIGNoYW5nZSBpdC4gIFRoYW5rIHlvdSBm
b3IgeW91ciBhZHZpY2UuDQoNCj4gDQo+IEFsc28sIF9fdmxhbl9ncm91cF9nZXRfZGV2aWNlKCkg
aXMgdXNlZCBpbiB0aGUgZGF0YSBwYXRoLCBpdCB3b3VsZA0KPiBiZSB0byBhdm9pZCB0aGUgYmFy
cmllciBvcCB0b28uIE1heWJlIHVzaW5nIHJjdSB0byBhdm9pZCB0aGUgYmFycmllcg0KPiBpZiB0
aGUgX192bGFuX2dyb3VwX2dldF9kZXZpY2UoKSBpcyBhbHJlYWR5IHByb3RlY3RlZCBieSByY3Vf
bG9jay4NCg0KVXNpbmcgdGhlIG5ldHBlcmYgY29tbWFuZCBmb3IgdGVzdGluZyBvbiB4ODYsIHRo
ZXJlIGlzIG5vIGRpZmZlcmVuY2UgaW4gcGVyZm9ybWFuY2U6DQoNCiMgbmV0cGVyZiAtSCAxMTIu
MTEzLjAuMTIgLWwgMjAgLXQgVENQX1NUUkVBTQ0KTUlHUkFURUQgVENQIFNUUkVBTSBURVNUIGZy
b20gMC4wLjAuMCAoMC4wLjAuMCkgcG9ydCAwIEFGX0lORVQgdG8gMTEyLjExMy4wLjEyICgpIHBv
cnQgMCBBRl9JTkVUDQpSZWN2ICAgU2VuZCAgICBTZW5kDQpTb2NrZXQgU29ja2V0ICBNZXNzYWdl
ICBFbGFwc2VkDQpTaXplICAgU2l6ZSAgICBTaXplICAgICBUaW1lICAgICBUaHJvdWdocHV0DQpi
eXRlcyAgYnl0ZXMgICBieXRlcyAgICBzZWNzLiAgICAxMF42Yml0cy9zZWMNCg0KMTMxMDcyICAx
NjM4NCAgMTYzODQgICAgMjAuMDAgICAgOTM4Ni4wMw0KDQpBZnRlciBwYXRjaDoNCg0KICMgbmV0
cGVyZiAtSCAxMTIuMTEzLjAuMTIgLWwgMjAgLXQgVENQX1NUUkVBTQ0KTUlHUkFURUQgVENQIFNU
UkVBTSBURVNUIGZyb20gMC4wLjAuMCAoMC4wLjAuMCkgcG9ydCAwIEFGX0lORVQgdG8gMTEyLjEx
My4wLjEyICgpIHBvcnQgMCBBRl9JTkVUDQpSZWN2ICAgU2VuZCAgICBTZW5kDQpTb2NrZXQgU29j
a2V0ICBNZXNzYWdlICBFbGFwc2VkDQpTaXplICAgU2l6ZSAgICBTaXplICAgICBUaW1lICAgICBU
aHJvdWdocHV0DQpieXRlcyAgYnl0ZXMgICBieXRlcyAgICBzZWNzLiAgICAxMF42Yml0cy9zZWMN
Cg0KMTMxMDcyICAxNjM4NCAgMTYzODQgICAgMjAuMDAgICAgOTM4Ni40MQ0KDQpUaGUgc2FtZSBp
cyB0cnVlIGZvciBVRFAgc3RyZWFtIHRlc3QNCg0KPiANCj4gPg0KPiA+Pg0KPiA+Pg0KPiA+Pj4g
bWF5IGdldCBhIHdyb25nIGFkZHJlc3MgZnJvbSB0aGUgaGFyZHdhcmUgY2FjaGUgb24gYW5vdGhl
ciBjcHUuDQo+ID4+Pg0KPiA+Pj4gU28gZml4IGl0IGJ5IGFkZGluZyBtZW1vcnkgYmFycmllciBp
bnN0cnVjdGlvbiB0byBlbnN1cmUgdGhlIG9yZGVyIG9mDQo+ID4+PiBtZW1vcnkgb3BlcmF0aW9u
cy4NCj4gPj4+DQo+ID4+PiBTaWduZWQtb2ZmLWJ5OiBEaSBaaHUgPHpodWRpMjFAaHVhd2VpLmNv
bT4NCj4gPj4+IC0tLQ0KPiA+Pj4gIG5ldC84MDIxcS92bGFuLmMgfCAyICsrDQo+ID4+PiAgbmV0
LzgwMjFxL3ZsYW4uaCB8IDMgKysrDQo+ID4+PiAgMiBmaWxlcyBjaGFuZ2VkLCA1IGluc2VydGlv
bnMoKykNCj4gPj4+DQo+ID4+PiBkaWZmIC0tZ2l0IGEvbmV0LzgwMjFxL3ZsYW4uYyBiL25ldC84
MDIxcS92bGFuLmMgaW5kZXgNCj4gPj4+IDhiNjQ0MTEzNzE1ZS4uNGY1NDFlMDVjZDNmIDEwMDY0
NA0KPiA+Pj4gLS0tIGEvbmV0LzgwMjFxL3ZsYW4uYw0KPiA+Pj4gKysrIGIvbmV0LzgwMjFxL3Zs
YW4uYw0KPiA+Pj4gQEAgLTcxLDYgKzcxLDggQEAgc3RhdGljIGludCB2bGFuX2dyb3VwX3ByZWFs
bG9jX3ZpZChzdHJ1Y3QNCj4gdmxhbl9ncm91cA0KPiA+PiAqdmcsDQo+ID4+PiAgCWlmIChhcnJh
eSA9PSBOVUxMKQ0KPiA+Pj4gIAkJcmV0dXJuIC1FTk9CVUZTOw0KPiA+Pj4NCj4gPj4+ICsJc21w
X3dtYigpOw0KPiA+Pj4gKw0KPiA+Pj4gIAl2Zy0+dmxhbl9kZXZpY2VzX2FycmF5c1twaWR4XVt2
aWR4XSA9IGFycmF5Ow0KPiA+Pj4gIAlyZXR1cm4gMDsNCj4gPj4+ICB9DQo+ID4+PiBkaWZmIC0t
Z2l0IGEvbmV0LzgwMjFxL3ZsYW4uaCBiL25ldC84MDIxcS92bGFuLmggaW5kZXgNCj4gPj4+IDk1
MzQwNTM2Mjc5NS4uNzQwOGZkYTA4NGQzIDEwMDY0NA0KPiA+Pj4gLS0tIGEvbmV0LzgwMjFxL3Zs
YW4uaA0KPiA+Pj4gKysrIGIvbmV0LzgwMjFxL3ZsYW4uaA0KPiA+Pj4gQEAgLTU3LDYgKzU3LDkg
QEAgc3RhdGljIGlubGluZSBzdHJ1Y3QgbmV0X2RldmljZQ0KPiA+Pj4gKl9fdmxhbl9ncm91cF9n
ZXRfZGV2aWNlKHN0cnVjdCB2bGFuX2dyb3VwICp2ZywNCj4gPj4+DQo+ID4+PiAgCWFycmF5ID0g
dmctPnZsYW5fZGV2aWNlc19hcnJheXNbcGlkeF0NCj4gPj4+ICAJCQkJICAgICAgIFt2bGFuX2lk
IC8NCj4gPj4gVkxBTl9HUk9VUF9BUlJBWV9QQVJUX0xFTl07DQo+ID4+PiArDQo+ID4+PiArCXNt
cF9ybWIoKTsNCj4gPj4+ICsNCj4gPj4+ICAJcmV0dXJuIGFycmF5ID8gYXJyYXlbdmxhbl9pZCAl
IFZMQU5fR1JPVVBfQVJSQVlfUEFSVF9MRU5dIDoNCj4gPj4gTlVMTDsgIH0NCj4gPj4+DQo+ID4+
Pg0KPiA+DQoNCg==
