Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52E9E39B0EF
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 05:31:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229886AbhFDDdG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 23:33:06 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:4300 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229704AbhFDDdG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Jun 2021 23:33:06 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4Fx7Tj4jhcz19S4c;
        Fri,  4 Jun 2021 11:26:33 +0800 (CST)
Received: from dggpemm100003.china.huawei.com (7.185.36.68) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 4 Jun 2021 11:31:17 +0800
Received: from dggpemm500008.china.huawei.com (7.185.36.136) by
 dggpemm100003.china.huawei.com (7.185.36.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 4 Jun 2021 11:31:17 +0800
Received: from dggpemm500008.china.huawei.com ([7.185.36.136]) by
 dggpemm500008.china.huawei.com ([7.185.36.136]) with mapi id 15.01.2176.012;
 Fri, 4 Jun 2021 11:31:17 +0800
From:   wangyunjian <wangyunjian@huawei.com>
To:     Maxim Mikityanskiy <maximmi@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "kuba@kernel.org" <kuba@kernel.org>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "jhs@mojatatu.com" <jhs@mojatatu.com>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        chenchanghu <chenchanghu@huawei.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: RE: [PATCH net] sch_htb: fix null pointer dereference on a null new_q
Thread-Topic: [PATCH net] sch_htb: fix null pointer dereference on a null
 new_q
Thread-Index: AQHXJXDoTLAQd+fJ3keOIJvh2ekHCqsB62EAgAGtR9A=
Date:   Fri, 4 Jun 2021 03:31:17 +0000
Message-ID: <2f50d73f5c7f487992531cdc557588fd@huawei.com>
References: <1617114468-2928-1-git-send-email-wangyunjian@huawei.com>
 <7a0ea3a1-0d31-83f4-0ba1-80154c37d048@nvidia.com>
In-Reply-To: <7a0ea3a1-0d31-83f4-0ba1-80154c37d048@nvidia.com>
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

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBNYXhpbSBNaWtpdHlhbnNraXkg
W21haWx0bzptYXhpbW1pQG52aWRpYS5jb21dDQo+IFNlbnQ6IFRodXJzZGF5LCBKdW5lIDMsIDIw
MjEgNTo1MyBQTQ0KPiBUbzogd2FuZ3l1bmppYW4gPHdhbmd5dW5qaWFuQGh1YXdlaS5jb20+OyBu
ZXRkZXZAdmdlci5rZXJuZWwub3JnDQo+IENjOiBrdWJhQGtlcm5lbC5vcmc7IHhpeW91Lndhbmdj
b25nQGdtYWlsLmNvbTsgamhzQG1vamF0YXR1LmNvbTsNCj4gamlyaUByZXNudWxsaS51czsgY2hl
bmNoYW5naHUgPGNoZW5jaGFuZ2h1QGh1YXdlaS5jb20+OyBEYXZpZCBTLiBNaWxsZXINCj4gPGRh
dmVtQGRhdmVtbG9mdC5uZXQ+DQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggbmV0XSBzY2hfaHRiOiBm
aXggbnVsbCBwb2ludGVyIGRlcmVmZXJlbmNlIG9uIGEgbnVsbCBuZXdfcQ0KPiANCj4gT24gMjAy
MS0wMy0zMCAxNzoyNywgd2FuZ3l1bmppYW4gd3JvdGU6DQo+ID4gRnJvbTogWXVuamlhbiBXYW5n
IDx3YW5neXVuamlhbkBodWF3ZWkuY29tPg0KPiA+DQo+ID4gc2NoX2h0YjogZml4IG51bGwgcG9p
bnRlciBkZXJlZmVyZW5jZSBvbiBhIG51bGwgbmV3X3ENCj4gPg0KPiA+IEN1cnJlbnRseSBpZiBu
ZXdfcSBpcyBudWxsLCB0aGUgbnVsbCBuZXdfcSBwb2ludGVyIHdpbGwgYmUgZGVyZWZlcmVuY2UN
Cj4gPiB3aGVuICdxLT5vZmZsb2FkJyBpcyB0cnVlLiBGaXggdGhpcyBieSBhZGRpbmcgYSBicmFj
ZXMgYXJvdW5kDQo+ID4gaHRiX3BhcmVudF90b19sZWFmX29mZmxvYWQoKSB0byBhdm9pZCBpdC4N
Cj4gDQo+IEkgYWRtaXQgdGhlcmUgaXMgYSBOVUxMIHBvaW50ZXIgZGVyZWZlcmVuY2UgYnVnLCBi
dXQgSSBiZWxpZXZlIHRoaXMgZml4IGlzIG5vdA0KPiBjb3JyZWN0Lg0KPiANCj4gPg0KPiA+IEFk
ZHJlc3Nlcy1Db3Zlcml0eTogKCJEZXJlZmVyZW5jZSBhZnRlciBudWxsIGNoZWNrIikNCj4gPiBG
aXhlczogZDAzYjE5NWI1YWEwICgic2NoX2h0YjogSGllcmFyY2hpY2FsIFFvUyBoYXJkd2FyZSBv
ZmZsb2FkIikNCj4gDQo+IFBsZWFzZSBDYyB0aGUgYXV0aG9ycyBvZiB0aGUgcGF0Y2hlcyB5b3Ug
Zml4LCBJIGZvdW5kIHlvdXIgY29tbWl0IGFjY2lkZW50YWxseS4NCj4gDQo+ID4NCj4gPiBTaWdu
ZWQtb2ZmLWJ5OiBZdW5qaWFuIFdhbmcgPHdhbmd5dW5qaWFuQGh1YXdlaS5jb20+DQo+ID4gLS0t
DQo+ID4gICBuZXQvc2NoZWQvc2NoX2h0Yi5jIHwgNSArKystLQ0KPiA+ICAgMSBmaWxlIGNoYW5n
ZWQsIDMgaW5zZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMoLSkNCj4gPg0KPiA+IGRpZmYgLS1naXQg
YS9uZXQvc2NoZWQvc2NoX2h0Yi5jIGIvbmV0L3NjaGVkL3NjaF9odGIuYyBpbmRleA0KPiA+IDYy
ZTEyY2I0MWEzZS4uMDgxYzExZDU3MTdjIDEwMDY0NA0KPiA+IC0tLSBhL25ldC9zY2hlZC9zY2hf
aHRiLmMNCj4gPiArKysgYi9uZXQvc2NoZWQvc2NoX2h0Yi5jDQo+ID4gQEAgLTE2NzUsOSArMTY3
NSwxMCBAQCBzdGF0aWMgaW50IGh0Yl9kZWxldGUoc3RydWN0IFFkaXNjICpzY2gsIHVuc2lnbmVk
DQo+IGxvbmcgYXJnLA0KPiA+ICAgCQkJCQkgIGNsLT5wYXJlbnQtPmNvbW1vbi5jbGFzc2lkLA0K
PiA+ICAgCQkJCQkgIE5VTEwpOw0KPiA+ICAgCQlpZiAocS0+b2ZmbG9hZCkgew0KPiA+IC0JCQlp
ZiAobmV3X3EpDQo+ID4gKwkJCWlmIChuZXdfcSkgew0KPiA+ICAgCQkJCWh0Yl9zZXRfbG9ja2Rl
cF9jbGFzc19jaGlsZChuZXdfcSk7DQo+ID4gLQkJCWh0Yl9wYXJlbnRfdG9fbGVhZl9vZmZsb2Fk
KHNjaCwgZGV2X3F1ZXVlLCBuZXdfcSk7DQo+ID4gKwkJCQlodGJfcGFyZW50X3RvX2xlYWZfb2Zm
bG9hZChzY2gsIGRldl9xdWV1ZSwgbmV3X3EpOw0KPiANCj4gWWVzLCBuZXdfcSBjYW4gYmUgTlVM
TCBhdCB0aGlzIHBvaW50LCB3aGljaCB3aWxsIGNyYXNoIGluIHFkaXNjX3JlZmNvdW50X2luYywN
Cj4gaG93ZXZlciwgZHJvcHBpbmcgdGhlIHJlc3Qgb2YgdGhlIGNvZGUgb2YgaHRiX3BhcmVudF90
b19sZWFmX29mZmxvYWQgY3JlYXRlcw0KPiBhbm90aGVyIGJ1Zy4gRm9yIGV4YW1wbGUsIGh0Yl9n
cmFmdF9oZWxwZXIgcHJvcGVybHkgaGFuZGxlcyB0aGUgY2FzZSB3aGVuDQo+IG5ld19xIGlzIE5V
TEwsIGFuZCBieSBza2lwcGluZyB0aGlzIGNhbGwgeW91IGNyZWF0ZSBhbiBpbmNvbnNpc3RlbmN5
Og0KPiBkZXZfcXVldWUtPnFkaXNjIHdpbGwgc3RpbGwgcG9pbnQgdG8gdGhlIG9sZCBxZGlzYywg
YnV0IGNsLT5wYXJlbnQtPmxlYWYucSB3aWxsDQo+IHBvaW50IHRvIHRoZSBuZXcgb25lICh3aGlj
aCB3aWxsIGJlIG5vb3BfcWRpc2MsIGJlY2F1c2UgbmV3X3Egd2FzIE5VTEwpLiBUaGUNCj4gY29k
ZSBpcyBiYXNlZCBvbiBhbiBhc3N1bXB0aW9uIHRoYXQgdGhlc2UgdHdvIHBvaW50ZXJzIGFyZSB0
aGUgc2FtZSwgc28gaXQgY2FuDQo+IGxlYWQgdG8gcmVmY291bnQgbGVha3MuDQo+IA0KPiBUaGUg
Y29ycmVjdCBmaXggd291bGQgYmUgdG8gYWRkIGEgTlVMTCBwb2ludGVyIGNoZWNrIHRvIHByb3Rl
Y3QNCj4gcWRpc2NfcmVmY291bnRfaW5jIGluc2lkZSBodGJfcGFyZW50X3RvX2xlYWZfb2ZmbG9h
ZC4NCg0KT0ssIEkgd2lsbCBzZW5kIGEgcGF0Y2ggdG8gZml4IGl0Lg0KDQpUaGFua3MNCg0KPiAN
Cj4gKEFsc28sIHdoaWxlIHJldmlld2luZyB0aGlzIGNvZGUsIEkgZm91bmQgb3V0IHRoYXQgbGVh
Zi5xIGJlaW5nIG5vb3BfcWRpc2MgaXNuJ3QNCj4gaGFuZGxlZCB3ZWxsIGluIG90aGVyIHBsYWNl
cyB0aGF0IHJlYWQgbGVhZi5xLT5kZXZfcXVldWUgLSBJJ2xsIGhhdmUgdG8gYWRkcmVzcyBpdA0K
PiBteXNlbGYuKQ0KPiANCj4gVGhhbmtzLA0KPiBNYXgNCj4gDQo+ID4gKwkJCX0NCj4gPiAgIAkJ
fQ0KPiA+ICAgCX0NCj4gPg0KPiA+DQoNCg==
