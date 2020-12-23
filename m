Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC2F72E1505
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 03:48:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730440AbgLWCrM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 21:47:12 -0500
Received: from szxga03-in.huawei.com ([45.249.212.189]:2408 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731009AbgLWCrK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Dec 2020 21:47:10 -0500
Received: from DGGEMM401-HUB.china.huawei.com (unknown [172.30.72.54])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4D0yHb6TpYz56nY;
        Wed, 23 Dec 2020 10:45:31 +0800 (CST)
Received: from DGGEMM533-MBX.china.huawei.com ([169.254.5.214]) by
 DGGEMM401-HUB.china.huawei.com ([10.3.20.209]) with mapi id 14.03.0509.000;
 Wed, 23 Dec 2020 10:46:20 +0800
From:   wangyunjian <wangyunjian@huawei.com>
To:     Jason Wang <jasowang@redhat.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
CC:     Network Development <netdev@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "Lilijun (Jerry)" <jerry.lilijun@huawei.com>,
        chenchanghu <chenchanghu@huawei.com>,
        xudingke <xudingke@huawei.com>,
        "huangbin (J)" <brian.huangbin@huawei.com>
Subject: RE: [PATCH net v2 2/2] vhost_net: fix high cpu load when sendmsg
 fails
Thread-Topic: [PATCH net v2 2/2] vhost_net: fix high cpu load when sendmsg
 fails
Thread-Index: AQHW04Rfp56K/196YUuYX4LzCnUku6oBrxQAgABdIgCAAfe+0A==
Date:   Wed, 23 Dec 2020 02:46:20 +0000
Message-ID: <34EFBCA9F01B0748BEB6B629CE643AE60DB8D985@DGGEMM533-MBX.china.huawei.com>
References: <cover.1608065644.git.wangyunjian@huawei.com>
 <6b4c5fff8705dc4b5b6a25a45c50f36349350c73.1608065644.git.wangyunjian@huawei.com>
 <CAF=yD-K6EM3zfZtEh=305P4Z6ehO6TzfQC4cxp5+gHYrxEtXSg@mail.gmail.com>
 <acebdc23-7627-e170-cdfb-b7656c05e5c5@redhat.com>
In-Reply-To: <acebdc23-7627-e170-cdfb-b7656c05e5c5@redhat.com>
Accept-Language: en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.174.243.127]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogSmFzb24gV2FuZyBbbWFp
bHRvOmphc293YW5nQHJlZGhhdC5jb21dDQo+IFNlbnQ6IFR1ZXNkYXksIERlY2VtYmVyIDIyLCAy
MDIwIDEyOjQxIFBNDQo+IFRvOiBXaWxsZW0gZGUgQnJ1aWpuIDx3aWxsZW1kZWJydWlqbi5rZXJu
ZWxAZ21haWwuY29tPjsgd2FuZ3l1bmppYW4NCj4gPHdhbmd5dW5qaWFuQGh1YXdlaS5jb20+DQo+
IENjOiBOZXR3b3JrIERldmVsb3BtZW50IDxuZXRkZXZAdmdlci5rZXJuZWwub3JnPjsgTWljaGFl
bCBTLiBUc2lya2luDQo+IDxtc3RAcmVkaGF0LmNvbT47IHZpcnR1YWxpemF0aW9uQGxpc3RzLmxp
bnV4LWZvdW5kYXRpb24ub3JnOyBMaWxpanVuIChKZXJyeSkNCj4gPGplcnJ5LmxpbGlqdW5AaHVh
d2VpLmNvbT47IGNoZW5jaGFuZ2h1IDxjaGVuY2hhbmdodUBodWF3ZWkuY29tPjsNCj4geHVkaW5n
a2UgPHh1ZGluZ2tlQGh1YXdlaS5jb20+OyBodWFuZ2JpbiAoSikNCj4gPGJyaWFuLmh1YW5nYmlu
QGh1YXdlaS5jb20+DQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggbmV0IHYyIDIvMl0gdmhvc3RfbmV0
OiBmaXggaGlnaCBjcHUgbG9hZCB3aGVuIHNlbmRtc2cgZmFpbHMNCj4gDQo+IA0KPiBPbiAyMDIw
LzEyLzIyIOS4iuWNiDc6MDcsIFdpbGxlbSBkZSBCcnVpam4gd3JvdGU6DQo+ID4gT24gV2VkLCBE
ZWMgMTYsIDIwMjAgYXQgMzoyMCBBTSB3YW5neXVuamlhbjx3YW5neXVuamlhbkBodWF3ZWkuY29t
Pg0KPiB3cm90ZToNCj4gPj4gRnJvbTogWXVuamlhbiBXYW5nPHdhbmd5dW5qaWFuQGh1YXdlaS5j
b20+DQo+ID4+DQo+ID4+IEN1cnJlbnRseSB3ZSBicmVhayB0aGUgbG9vcCBhbmQgd2FrZSB1cCB0
aGUgdmhvc3Rfd29ya2VyIHdoZW4gc2VuZG1zZw0KPiA+PiBmYWlscy4gV2hlbiB0aGUgd29ya2Vy
IHdha2VzIHVwIGFnYWluLCB3ZSdsbCBtZWV0IHRoZSBzYW1lIGVycm9yLg0KPiA+IFRoZSBwYXRj
aCBpcyBiYXNlZCBvbiB0aGUgYXNzdW1wdGlvbiB0aGF0IHN1Y2ggZXJyb3IgY2FzZXMgYWx3YXlz
DQo+ID4gcmV0dXJuIEVBR0FJTi4gQ2FuIGl0IG5vdCBhbHNvIGJlIEVOT01FTSwgc3VjaCBhcyBm
cm9tIHR1bl9idWlsZF9za2I/DQo+ID4NCj4gPj4gVGhpcyB3aWxsIGNhdXNlIGhpZ2ggQ1BVIGxv
YWQuIFRvIGZpeCB0aGlzIGlzc3VlLCB3ZSBjYW4gc2tpcCB0aGlzDQo+ID4+IGRlc2NyaXB0aW9u
IGJ5IGlnbm9yaW5nIHRoZSBlcnJvci4gV2hlbiB3ZSBleGNlZWRzIHNuZGJ1ZiwgdGhlIHJldHVy
bg0KPiA+PiB2YWx1ZSBvZiBzZW5kbXNnIGlzIC1FQUdBSU4uIEluIHRoZSBjYXNlIHdlIGRvbid0
IHNraXAgdGhlDQo+ID4+IGRlc2NyaXB0aW9uIGFuZCBkb24ndCBkcm9wIHBhY2tldC4NCj4gPiB0
aGUgLT4gdGhhdA0KPiA+DQo+ID4gaGVyZSBhbmQgYWJvdmU6IGRlc2NyaXB0aW9uIC0+IGRlc2Ny
aXB0b3INCj4gPg0KPiA+IFBlcmhhcHMgc2xpZ2h0bHkgcmV2aXNlIHRvIG1vcmUgZXhwbGljaXRs
eSBzdGF0ZSB0aGF0DQo+ID4NCj4gPiAxLiBpbiB0aGUgY2FzZSBvZiBwZXJzaXN0ZW50IGZhaWx1
cmUgKGkuZS4sIGJhZCBwYWNrZXQpLCB0aGUgZHJpdmVyDQo+ID4gZHJvcHMgdGhlIHBhY2tldCAy
LiBpbiB0aGUgY2FzZSBvZiB0cmFuc2llbnQgZmFpbHVyZSAoZS5nLC4gbWVtb3J5DQo+ID4gcHJl
c3N1cmUpIHRoZSBkcml2ZXIgc2NoZWR1bGVzIHRoZSB3b3JrZXIgdG8gdHJ5IGFnYWluIGxhdGVy
DQo+IA0KPiANCj4gSWYgd2Ugd2FudCB0byBnbyB3aXRoIHRoaXMgd2F5LCB3ZSBuZWVkIGEgYmV0
dGVyIHRpbWUgdG8gd2FrZXVwIHRoZSB3b3JrZXIuDQo+IE90aGVyd2lzZSBpdCBqdXN0IHByb2R1
Y2VzIG1vcmUgc3RyZXNzIG9uIHRoZSBjcHUgdGhhdCBpcyB3aGF0IHRoaXMgcGF0Y2ggdHJpZXMN
Cj4gdG8gYXZvaWQuDQoNClRoZSBwcm9ibGVtIHdhcyBpbml0aWFsbHkgZGlzY292ZXJlZCB3aGVu
IGEgVk0gc2VudCBhbiBhYm5vcm1hbCBwYWNrZXQsDQp3aGljaCBjYXVzaW5nIHRoZSBWTSBjYW4n
dCBzZW5kIHBhY2tldHMgYW55bW9yZS4gQWZ0ZXIgdGhpcyBwYXRjaA0KImZlYjg4OTJjYjQ0MWM3
IHZob3N0X25ldDogY29uZGl0aW9uYWxseSBlbmFibGUgdHggcG9sbGluZyIsIHRoZXJlIGhhdmUN
CmFsc28gYmVlbiBoaWdoIENQVSBjb25zdW1wdGlvbiBpc3N1ZXMuIA0KDQpJdCBpcyB0aGUgZmly
c3QgcHJvYmxlbSB0aGF0IEkgYW0gYWN0dWFsbHkgbW9yZSBjb25jZXJuZWQgd2l0aCBhbmQgd2Fu
dA0KdG8gc29sdmUuDQoNClRoYW5rcw0KDQo+IA0KPiBUaGFua3MNCj4gDQo+IA0KPiA+DQo+ID4N
Cg0K
