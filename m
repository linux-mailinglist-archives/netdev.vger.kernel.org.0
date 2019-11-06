Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35AC9F1E38
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 20:07:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727741AbfKFTGs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 14:06:48 -0500
Received: from szxga01-in.huawei.com ([45.249.212.187]:2448 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727319AbfKFTFl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Nov 2019 14:05:41 -0500
Received: from DGGEMM404-HUB.china.huawei.com (unknown [172.30.72.55])
        by Forcepoint Email with ESMTP id DEB04C6F6382095DDFF6;
        Thu,  7 Nov 2019 03:05:37 +0800 (CST)
Received: from dggeme756-chm.china.huawei.com (10.3.19.102) by
 DGGEMM404-HUB.china.huawei.com (10.3.20.212) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 7 Nov 2019 03:05:37 +0800
Received: from lhreml703-chm.china.huawei.com (10.201.108.52) by
 dggeme756-chm.china.huawei.com (10.3.19.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1713.5; Thu, 7 Nov 2019 03:05:35 +0800
Received: from lhreml703-chm.china.huawei.com ([10.201.68.198]) by
 lhreml703-chm.china.huawei.com ([10.201.68.198]) with mapi id 15.01.1713.004;
 Wed, 6 Nov 2019 19:05:33 +0000
From:   Salil Mehta <salil.mehta@huawei.com>
To:     Marc Zyngier <maz@kernel.org>
CC:     "edumazet@google.com" <edumazet@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "lipeng (Y)" <lipeng321@huawei.com>,
        "Zhuangyuzeng (Yisen)" <yisen.zhuang@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Linuxarm <linuxarm@huawei.com>
Subject: RE: [PATCH] net: hns: Ensure that interface teardown cannot race
  with TX interrupt
Thread-Topic: [PATCH] net: hns: Ensure that interface teardown cannot race
  with TX interrupt
Thread-Index: AQHVlJwvpRHjiMWhn0S+U43jeXM4Fad+f+QA
Date:   Wed, 6 Nov 2019 19:05:33 +0000
Message-ID: <b60a6cd0c3934d52aec14b47b2218edf@huawei.com>
References: <20191104195604.17109-1-maz@kernel.org>
 <aa7d625e74c74e4b9810b8ea3e437ca4@huawei.com> <20191106081748.0e21554c@why>
 <2311b5965adb4ccea83b6072115efc6c@huawei.com>
 <21493d3d08936d7ed67f7153cdaa418e@www.loen.fr>
In-Reply-To: <21493d3d08936d7ed67f7153cdaa418e@www.loen.fr>
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

PiBGcm9tOiBNYXJjIFp5bmdpZXIgW21haWx0bzptYXpAa2VybmVsLm9yZ10NCj4gU2VudDogV2Vk
bmVzZGF5LCBOb3ZlbWJlciA2LCAyMDE5IDEyOjE3IFBNDQo+IFRvOiBTYWxpbCBNZWh0YSA8c2Fs
aWwubWVodGFAaHVhd2VpLmNvbT4NCj4gDQo+IE9uIDIwMTktMTEtMDYgMTI6MjgsIFNhbGlsIE1l
aHRhIHdyb3RlOg0KPiA+IEhpIE1hcmMsDQo+ID4NCj4gPj4gT24gVHVlLCA1IE5vdiAyMDE5IDE4
OjQxOjExICswMDAwDQo+ID4+IFNhbGlsIE1laHRhIDxzYWxpbC5tZWh0YUBodWF3ZWkuY29tPiB3
cm90ZToNCj4gPj4NCj4gPj4gSGkgU2FsaWwsDQo+ID4+DQo+ID4+ID4gSGkgTWFyYywNCj4gPj4g
PiBJIHRlc3RlZCB3aXRoIHRoZSBwYXRjaCBvbiBEMDUgd2l0aCB0aGUgbG9ja2RlcCBlbmFibGVk
IGtlcm5lbA0KPiA+PiB3aXRoIGJlbG93IG9wdGlvbnMNCj4gPj4gPiBhbmQgSSBjb3VsZCBub3Qg
cmVwcm9kdWNlIHRoZSBkZWFkbG9jay4gSSBkbyBub3QgYXJndWUgdGhlIGlzc3VlDQo+ID4+IGJl
aW5nIG1lbnRpb25lZA0KPiA+PiA+IGFzIHRoaXMgbG9va3MgdG8gYmUgYSBjbGVhciBidWcgd2hp
Y2ggc2hvdWxkIGhpdCB3aGlsZSBUWA0KPiA+PiBkYXRhLXBhdGggaXMgcnVubmluZw0KPiA+PiA+
IGFuZCB3ZSB0cnkgdG8gZGlzYWJsZSB0aGUgaW50ZXJmYWNlLg0KPiA+Pg0KPiA+PiBMb2NrZGVw
IHNjcmVhbWluZyBhdCB5b3UgZG9lc24ndCBtZWFuIHRoZSBkZWFkbHkgc2NlbmFyaW8gaGFwcGVu
cyBpbg0KPiA+PiBwcmFjdGljZSwgYW5kIEkndmUgbmV2ZXIgc2VlbiB0aGUgbWFjaGluZSBoYW5n
aW5nIGluIHRoZXNlDQo+ID4+IGNvbmRpdGlvbnMuDQo+ID4+IEJ1dCBJJ3ZlIGFsc28gbmV2ZXIg
dHJpZWQgdG8gdHJpZ2dlciBpdCBpbiBhbmdlci4NCj4gPj4NCj4gPj4gPiBDb3VsZCB5b3UgcGxl
YXNlIGhlbHAgbWUga25vdyB0aGUgZXhhY3Qgc2V0IG9mIHN0ZXBzIHlvdSB1c2VkIHRvDQo+ID4+
IGdldCBpbnRvIHRoaXMNCj4gPj4gPiBwcm9ibGVtLiBBbHNvLCBhcmUgeW91IGFibGUgdG8gcmUt
Y3JlYXRlIGl0IGVhc2lseS9mcmVxdWVudGx5Pw0KPiA+Pg0KPiA+PiBJIGp1c3QgbmVlZCB0byBp
c3N1ZSAicmVib290IiAod2hpY2ggY2FsbHMgImlwIGxpbmsgLi4uIGRvd24iKSBmb3INCj4gPj4g
dGhpcw0KPiA+PiB0byB0cmlnZ2VyLiBIZXJlJ3MgYSBmdWxsIHNwbGF0WzFdLCBhcyB3ZWxsIGFz
IG15IGZ1bGwgY29uZmlnWzJdLiBJdA0KPiA+PiBpcw0KPiA+PiAxMDAlIHJlcGVhdGFibGUuDQo+
ID4+DQo+ID4+ID4gIyBLZXJuZWwgQ29uZmlnIG9wdGlvbnM6DQo+ID4+ID4gQ09ORklHX0xPQ0tE
RVBfU1VQUE9SVD15DQo+ID4+ID4gQ09ORklHX0xPQ0tERVA9eQ0KPiA+Pg0KPiA+PiBZb3UnbGwg
bmVlZCBhdCBsZWFzdA0KPiA+Pg0KPiA+PiBDT05GSUdfUFJPVkVfTE9DS0lORz15DQo+ID4+IENP
TkZJR19ORVRfUE9MTF9DT05UUk9MTEVSPXkNCj4gPg0KPiA+DQo+ID4gRmV3IHBvaW50czoNCj4g
PiAxLiBUbyBtZSBuZXRwb2xsIGNhdXNpbmcgc3BpbmxvY2sgZGVhZGxvY2sgd2l0aCBJUlEgbGVn
IG9mIFRYIGFuZCBpcA0KPiA+IHV0aWwgaXMNCj4gPiAgICAgaGlnaGx5IHVubGlrZWx5IHNpbmNl
IG5ldHBvbGwgcnVucyB3aXRoIGJvdGggUlgvVFggaW50ZXJydXB0cw0KPiA+IGRpc2FibGVkLg0K
PiA+ICAgICBJdCBydW5zIGluIHBvbGxpbmcgbW9kZSB0byBmYWNpbGl0YXRlIHBhcmFsbGVsIHBh
dGggdG8gZmVhdHVyZXMNCj4gPiBsaWtlDQo+ID4gICAgIE5ldGNvbnNvbGUsIG5ldGR1bXAgZXRj
LiBoZW5jZSwgZGVhZGxvY2sgYmVjYXVzZSBvZiB0aGUgbmV0cG9sbA0KPiA+IHNob3VsZA0KPiA+
ICAgICBiZSBoaWdobHkgdW5saWtlbHkuIFRoZXJlZm9yZSwgc21lbGxzIG9mIHNvbWUgb3RoZXIg
cHJvYmxlbQ0KPiA+IGhlcmUuLi4NCj4gPiAyLiBBbHNvLCBJIHJlbWVtYmVyIHBhdGNoW3MxXVtz
Ml0gZnJvbSBFcmljIER1bWF6ZXQgdG8gZGlzYWJsZQ0KPiA+IG5ldHBvbGwgb24gbWFueQ0KPiA+
ICAgICBOSUNzIHdheSBiYWNrIGluIDQuMTkga2VybmVsIG9uIHRoZSBiYXNpcyBvZiBTb25nIExp
dSdzIGZpbmRpbmdzLg0KPiA+DQo+ID4gUHJvYmxlbToNCj4gPiBBYWgsIEkgc2VlIHRoZSBwcm9i
bGVtIG5vdywgaXQgaXMgYmVjYXVzZSBvZiB0aGUgc3RyYXkgY29kZSByZWxhdGVkDQo+ID4gdG8g
dGhlDQo+ID4gTkVUX1BPTExfQ09OVFJPTExFUiBpbiBobnMgZHJpdmVyIHdoaWNoIGFjdHVhbGx5
IHNob3VsZCBoYXZlIGdvdA0KPiA+IHJlbW92ZSB3aXRoaW4NCj4gPiB0aGUgcGF0Y2hbczFdLCBh
bmQgdGhhdCBhbHNvIGV4cGxhaW5zIHdoeSBpdCBkb2VzIG5vdCBnZXQgaGl0IHdoaWxlDQo+ID4g
TkVUIFBPTEwNCj4gPiBpcyBkaXNhYmxlZC4NCj4gPg0KPiA+DQo+ID4gLyogbmV0aWZfdHhfbG9j
ayB3aWxsIHR1cm4gZG93biB0aGUgcGVyZm9ybWFuY2UsIHNldCBvbmx5IHdoZW4NCj4gPiBuZWNl
c3NhcnkgKi8NCj4gPiAjaWZkZWYgQ09ORklHX05FVF9QT0xMX0NPTlRST0xMRVINCj4gPiAjZGVm
aW5lIE5FVElGX1RYX0xPQ0socmluZykgc3Bpbl9sb2NrKCYocmluZyktPmxvY2spDQo+ID4gI2Rl
ZmluZSBORVRJRl9UWF9VTkxPQ0socmluZykgc3Bpbl91bmxvY2soJihyaW5nKS0+bG9jaykNCj4g
PiAjZWxzZQ0KPiA+ICNkZWZpbmUgTkVUSUZfVFhfTE9DSyhyaW5nKQ0KPiA+ICNkZWZpbmUgTkVU
SUZfVFhfVU5MT0NLKHJpbmcpDQo+ID4gI2VuZGlmDQo+ID4NCj4gPg0KPiA+IE9uY2UgeW91IGRl
ZmluZSBDT05GSUdfTkVUX1BPTExfQ09OVFJPTExFUiBpbiB0aGUgbGF0ZXN0IGNvZGUgdGhlc2UN
Cj4gPiBtYWNyb3MNCj4gPiBLaWNrLWluIGV2ZW4gZm9yIHRoZSBub3JtYWwgTkFQSSBwYXRoLiBX
aGljaCBjYW4gY2F1c2UgZGVhZGxvY2sgYW5kDQo+ID4gdGhhdCBwZXJoYXBzDQo+ID4gaXMgd2hh
dCB5b3UgYXJlIHNlZWluZz8NCj4gDQo+IFllcywgdGhhdCdzIHRoZSBwcm9ibGVtLg0KDQoNClN1
cmUsIHRoYW5rcy4NCg0KDQo+ID4gTm93LCB0aGUgcXVlc3Rpb24gaXMgZG8gd2UgcmVxdWlyZSB0
aGVzZSBsb2NrcyBpbiBub3JtYWwgTkFQSSBwb2xsPyBJDQo+ID4gZG8gbm90DQo+ID4gc2VlIHRo
YXQgd2UgbmVlZCB0aGVtIGFueW1vcmUgYXMgVGFza2xldHMgYXJlIHNlcmlhbGl6ZWQgdG8NCj4g
PiB0aGVtc2VsdmVzIGFuZA0KPiA+IGNvbmZpZ3VyYXRpb24gcGF0aCBsaWtlICJpcCA8aW50Zj4g
ZG93biIgY2Fubm90IGNvbmZsaWN0IHdpdGggTkFQSQ0KPiA+IHBvbGwgcGF0aA0KPiA+IGFzIHRo
ZSBsYXRlciBpcyBhbHdheXMgZGlzYWJsZWQgcHJpb3IgcGVyZm9ybWluZyBpbnRlcmZhY2UgZG93
bg0KPiA+IG9wZXJhdGlvbi4NCj4gPiBIZW5jZSwgbm8gY29uZmxpY3QgdGhlcmUuDQo+IA0KPiBN
eSBwcmVmZXJlbmNlIHdvdWxkIGluZGVlZCBiZSB0byBkcm9wIHRoZXNlIHBlci1xdWV1ZSBsb2Nr
cyBpZiB0aGV5DQo+IGFyZW4ndA0KPiByZXF1aXJlZC4gSSBjb3VsZG4ndCBmaWd1cmUgb3V0IGZy
b20gYSBjdXJzb3J5IGxvb2sgYXQgdGhlIGNvZGUgd2hldGhlcg0KPiB0d28gQ1BVcyBjb3VsZCBz
ZXJ2ZSB0aGUgc2FtZSBUWCBxdWV1ZS4gSWYgdGhhdCBjYW5ub3QgaGFwcGVuIGJ5DQo+IGNvbnN0
cnVjdGlvbiwNCj4gdGhlbiB0aGVzZSBsb2NrcyBhcmUgcGVyZmVjdGx5IHVzZWxlc3MgYW5kIHNo
b3VsZCBiZSByZW1vdmVkLg0KDQoNClN1cmUuDQoNCg0KPiA+IEFzICBhIHNpZGUgYW5hbHlzaXMs
IEkgY291bGQgZmlndXJlIG91dCBzb21lIGNvbnRlbnRpb25zIGluIHRoZQ0KPiA+IGNvbmZpZ3Vy
YXRpb24NCj4gPiBwYXRoIG5vdCByZWxhdGVkIHRvIHRoaXMgdGhvdWdoLiA6KQ0KPiA+DQo+ID4N
Cj4gPiBTdWdnZXN0ZWQgU29sdXRpb246DQo+ID4gU2luY2Ugd2UgZG8gbm90IGhhdmUgc3VwcG9y
dCBvZiBORVRfUE9MTF9DT05UUk9MTEVSIG1hY3Jvcw0KPiA+IE5FVElGX1RYX1tVTl1MT0NLDQo+
ID4gV2Ugc2hvdWxkIHJlbW92ZSB0aGVzZSBORVRfUE9MTF9DT05UUk9MTEVSIG1hY3JvcyBhbHRv
Z2V0aGVyIGZvciBub3cuDQo+ID4NCj4gPiBUaG91Z2gsIEkgc3RpbGwgaGF2ZSBub3QgbG9va2Vk
IGNvbXByZWhlbnNpdmVseSBob3cgb3RoZXIgYXJlIGFibGUgdG8NCj4gPiB1c2UNCj4gPiBEZWJ1
Z2dpbmcgdXRpbHMgbGlrZSBuZXRjb25zb2xlIGV0YyB3aXRob3V0IGhhdmluZw0KPiA+IE5FVF9Q
T0xMX0NPTlRST0xMRVIuDQo+ID4gTWF5YmUgQEVyaWMgRHVtYXpldCBtaWdodCBnaXZlIHVzIHNv
bWUgaW5zaWdodCBvbiB0aGlzPw0KPiA+DQo+ID4NCj4gPiBJZiB5b3UgYWdyZWUgd2l0aCB0aGlz
IHRoZW4gSSBjYW4gc2VuZCBhIHBhdGNoIHRvIHJlbW92ZSB0aGVzZSBmcm9tDQo+ID4gaG5zDQo+
ID4gZHJpdmVyLiBUaGlzIHNob3VsZCBzb2x2ZSB5b3VyIHByb2JsZW0gYXMgd2VsbD8NCj4gDQo+
IFN1cmUsIGFzIGxvbmcgYXMgeW91IGNhbiBndWFyYW50ZWUgdGhhdCB0aGVzZSBsb2NrcyBhcmUg
bmV2ZXIgdXNlZCBmb3INCj4gYW55dGhpbmcNCj4gdXNlZnVsLg0KDQoNCkhpIE1hcmMsDQpJIGhh
dmUgZmxvYXRlZCB0aGUgcGF0Y2guIENvdWxkIHlvdSBwbGVhc2UgY29uZmlybSBpZiB0aGlzIHNv
bHZlcyB5b3VyIGlzc3VlDQphbmQgaWYgcG9zc2libGUgcHJvdmlkZSB5b3VyIFRlc3RlZC1ieT8g
OikNCg0KW1BBVENIIG5ldF0gbmV0OiBobnM6IEZpeCB0aGUgc3RyYXkgbmV0cG9sbCBsb2NrcyBj
YXVzaW5nIGRlYWRsb2NrIGluIE5BUEkgcGF0aA0KDQpUaGFua3MNClNhbGlsDQo=
