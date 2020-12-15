Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEDE32DA8DB
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 09:05:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726548AbgLOIEk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 03:04:40 -0500
Received: from szxga08-in.huawei.com ([45.249.212.255]:2335 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726249AbgLOIEk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Dec 2020 03:04:40 -0500
Received: from DGGEMM403-HUB.china.huawei.com (unknown [172.30.72.54])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4Cw9jV6b1yz13Ts1;
        Tue, 15 Dec 2020 16:02:54 +0800 (CST)
Received: from DGGEMM424-HUB.china.huawei.com (10.1.198.41) by
 DGGEMM403-HUB.china.huawei.com (10.3.20.211) with Microsoft SMTP Server (TLS)
 id 14.3.498.0; Tue, 15 Dec 2020 16:03:56 +0800
Received: from DGGEMM533-MBX.china.huawei.com ([169.254.5.214]) by
 dggemm424-hub.china.huawei.com ([10.1.198.41]) with mapi id 14.03.0509.000;
 Tue, 15 Dec 2020 16:03:46 +0800
From:   wangyunjian <wangyunjian@huawei.com>
To:     Jason Wang <jasowang@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "mst@redhat.com" <mst@redhat.com>,
        "willemdebruijn.kernel@gmail.com" <willemdebruijn.kernel@gmail.com>
CC:     "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "Lilijun (Jerry)" <jerry.lilijun@huawei.com>,
        chenchanghu <chenchanghu@huawei.com>,
        xudingke <xudingke@huawei.com>,
        "huangbin (J)" <brian.huangbin@huawei.com>
Subject: RE: [PATCH net 2/2] vhost_net: fix high cpu load when sendmsg fails
Thread-Topic: [PATCH net 2/2] vhost_net: fix high cpu load when sendmsg fails
Thread-Index: AQHW0oRuvV7yNtzm006vlEv0Vf1dkan3BR2AgADGt5A=
Date:   Tue, 15 Dec 2020 08:03:45 +0000
Message-ID: <34EFBCA9F01B0748BEB6B629CE643AE60DB82A73@DGGEMM533-MBX.china.huawei.com>
References: <cover.1608024547.git.wangyunjian@huawei.com>
 <4be47d3a325983f1bfc39f11f0e015767dd2aa3c.1608024547.git.wangyunjian@huawei.com>
 <e853a47e-b581-18d9-f13c-b449b176a308@redhat.com>
In-Reply-To: <e853a47e-b581-18d9-f13c-b449b176a308@redhat.com>
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
bHRvOmphc293YW5nQHJlZGhhdC5jb21dDQo+IFNlbnQ6IFR1ZXNkYXksIERlY2VtYmVyIDE1LCAy
MDIwIDEyOjEwIFBNDQo+IFRvOiB3YW5neXVuamlhbiA8d2FuZ3l1bmppYW5AaHVhd2VpLmNvbT47
IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7DQo+IG1zdEByZWRoYXQuY29tOyB3aWxsZW1kZWJydWlq
bi5rZXJuZWxAZ21haWwuY29tDQo+IENjOiB2aXJ0dWFsaXphdGlvbkBsaXN0cy5saW51eC1mb3Vu
ZGF0aW9uLm9yZzsgTGlsaWp1biAoSmVycnkpDQo+IDxqZXJyeS5saWxpanVuQGh1YXdlaS5jb20+
OyBjaGVuY2hhbmdodSA8Y2hlbmNoYW5naHVAaHVhd2VpLmNvbT47DQo+IHh1ZGluZ2tlIDx4dWRp
bmdrZUBodWF3ZWkuY29tPjsgaHVhbmdiaW4gKEopDQo+IDxicmlhbi5odWFuZ2JpbkBodWF3ZWku
Y29tPg0KPiBTdWJqZWN0OiBSZTogW1BBVENIIG5ldCAyLzJdIHZob3N0X25ldDogZml4IGhpZ2gg
Y3B1IGxvYWQgd2hlbiBzZW5kbXNnIGZhaWxzDQo+IA0KPiANCj4gT24gMjAyMC8xMi8xNSDkuIrl
jYg5OjQ4LCB3YW5neXVuamlhbiB3cm90ZToNCj4gPiBGcm9tOiBZdW5qaWFuIFdhbmcgPHdhbmd5
dW5qaWFuQGh1YXdlaS5jb20+DQo+ID4NCj4gPiBDdXJyZW50bHkgd2UgYnJlYWsgdGhlIGxvb3Ag
YW5kIHdha2UgdXAgdGhlIHZob3N0X3dvcmtlciB3aGVuIHNlbmRtc2cNCj4gPiBmYWlscy4gV2hl
biB0aGUgd29ya2VyIHdha2VzIHVwIGFnYWluLCB3ZSdsbCBtZWV0IHRoZSBzYW1lIGVycm9yLiBU
aGlzDQo+ID4gd2lsbCBjYXVzZSBoaWdoIENQVSBsb2FkLiBUbyBmaXggdGhpcyBpc3N1ZSwgd2Ug
Y2FuIHNraXAgdGhpcw0KPiA+IGRlc2NyaXB0aW9uIGJ5IGlnbm9yaW5nIHRoZSBlcnJvci4gV2hl
biB3ZSBleGNlZWRzIHNuZGJ1ZiwgdGhlIHJldHVybg0KPiA+IHZhbHVlIG9mIHNlbmRtc2cgaXMg
LUVBR0FJTi4gSW4gdGhlIGNhc2Ugd2UgZG9uJ3Qgc2tpcCB0aGUgZGVzY3JpcHRpb24NCj4gPiBh
bmQgZG9uJ3QgZHJvcCBwYWNrZXQuDQo+ID4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBZdW5qaWFuIFdh
bmcgPHdhbmd5dW5qaWFuQGh1YXdlaS5jb20+DQo+ID4gLS0tDQo+ID4gICBkcml2ZXJzL3Zob3N0
L25ldC5jIHwgMjEgKysrKysrKysrLS0tLS0tLS0tLS0tDQo+ID4gICAxIGZpbGUgY2hhbmdlZCwg
OSBpbnNlcnRpb25zKCspLCAxMiBkZWxldGlvbnMoLSkNCj4gPg0KPiA+IGRpZmYgLS1naXQgYS9k
cml2ZXJzL3Zob3N0L25ldC5jIGIvZHJpdmVycy92aG9zdC9uZXQuYyBpbmRleA0KPiA+IGM4Nzg0
ZGZhZmRkNy4uZjk2NjU5MmQ4OTAwIDEwMDY0NA0KPiA+IC0tLSBhL2RyaXZlcnMvdmhvc3QvbmV0
LmMNCj4gPiArKysgYi9kcml2ZXJzL3Zob3N0L25ldC5jDQo+ID4gQEAgLTgyNywxNiArODI3LDEz
IEBAIHN0YXRpYyB2b2lkIGhhbmRsZV90eF9jb3B5KHN0cnVjdCB2aG9zdF9uZXQgKm5ldCwNCj4g
c3RydWN0IHNvY2tldCAqc29jaykNCj4gPiAgIAkJCQltc2cubXNnX2ZsYWdzICY9IH5NU0dfTU9S
RTsNCj4gPiAgIAkJfQ0KPiA+DQo+ID4gLQkJLyogVE9ETzogQ2hlY2sgc3BlY2lmaWMgZXJyb3Ig
YW5kIGJvbWIgb3V0IHVubGVzcyBFTk9CVUZTPyAqLw0KPiA+ICAgCQllcnIgPSBzb2NrLT5vcHMt
PnNlbmRtc2coc29jaywgJm1zZywgbGVuKTsNCj4gPiAtCQlpZiAodW5saWtlbHkoZXJyIDwgMCkp
IHsNCj4gPiArCQlpZiAodW5saWtlbHkoZXJyID09IC1FQUdBSU4pKSB7DQo+ID4gICAJCQl2aG9z
dF9kaXNjYXJkX3ZxX2Rlc2ModnEsIDEpOw0KPiA+ICAgCQkJdmhvc3RfbmV0X2VuYWJsZV92cShu
ZXQsIHZxKTsNCj4gPiAgIAkJCWJyZWFrOw0KPiA+IC0JCX0NCj4gDQo+IA0KPiBBcyBJJ3ZlIHBv
aW50ZWQgb3V0IGluIGxhc3QgdmVyc2lvbi4gSWYgeW91IGRvbid0IGRpc2NhcmQgZGVzY3JpcHRv
ciwgeW91IHByb2JhYmx5DQo+IG5lZWQgdG8gYWRkIHRoZSBoZWFkIHRvIHVzZWQgcmluZy4gT3Ro
ZXJ3aXNlIHRoaXMgZGVzY3JpcHRvciB3aWxsIGJlIGFsd2F5cw0KPiBpbmZsaWdodCB0aGF0IG1h
eSBjb25mdXNlIGRyaXZlcnMuDQoNClNvcnJ5IGZvciBtaXNzaW5nIHRoZSBjb21tZW50Lg0KDQpB
ZnRlciBkZWxldGluZyBkaXNjYXJkIGRlc2NyaXB0b3IgYW5kIGJyZWFrLCB0aGUgbmV4dCBwcm9j
ZXNzaW5nIHdpbGwgYmUgdGhlIHNhbWUNCmFzIHRoZSBub3JtYWwgc3VjY2VzcyBvZiBzZW5kbXNn
KCksIGFuZCB2aG9zdF96ZXJvY29weV9zaWduYWxfdXNlZCgpIG9yDQp2aG9zdF9hZGRfdXNlZF9h
bmRfc2lnbmFsKCkgbWV0aG9kIHdpbGwgYmUgY2FsbGVkIHRvIGFkZCB0aGUgaGVhZCB0byB1c2Vk
IHJpbmcuDQoNClRoYW5rcw0KPiANCj4gDQo+ID4gLQkJaWYgKGVyciAhPSBsZW4pDQo+ID4gLQkJ
CXByX2RlYnVnKCJUcnVuY2F0ZWQgVFggcGFja2V0OiBsZW4gJWQgIT0gJXpkXG4iLA0KPiA+IC0J
CQkJIGVyciwgbGVuKTsNCj4gPiArCQl9IGVsc2UgaWYgKHVubGlrZWx5KGVyciA8IDAgfHwgZXJy
ICE9IGxlbikpDQo+IA0KPiANCj4gSXQgbG9va3MgdG8gbWUgZXJyICE9IGxlbiBjb3ZlcnMgZXJy
IDwgMC4NCg0KT0sNCg0KPiANCj4gVGhhbmtzDQo+IA0KPiANCj4gPiArCQkJdnFfZXJyKHZxLCAi
RmFpbCB0byBzZW5kaW5nIHBhY2tldHMgZXJyIDogJWQsIGxlbiA6ICV6ZFxuIiwgZXJyLA0KPiA+
ICtsZW4pOw0KPiA+ICAgZG9uZToNCj4gPiAgIAkJdnEtPmhlYWRzW252cS0+ZG9uZV9pZHhdLmlk
ID0gY3B1X3RvX3Zob3N0MzIodnEsIGhlYWQpOw0KPiA+ICAgCQl2cS0+aGVhZHNbbnZxLT5kb25l
X2lkeF0ubGVuID0gMDsNCj4gPiBAQCAtOTIyLDcgKzkxOSw2IEBAIHN0YXRpYyB2b2lkIGhhbmRs
ZV90eF96ZXJvY29weShzdHJ1Y3Qgdmhvc3RfbmV0DQo+ICpuZXQsIHN0cnVjdCBzb2NrZXQgKnNv
Y2spDQo+ID4gICAJCQltc2cubXNnX2ZsYWdzICY9IH5NU0dfTU9SRTsNCj4gPiAgIAkJfQ0KPiA+
DQo+ID4gLQkJLyogVE9ETzogQ2hlY2sgc3BlY2lmaWMgZXJyb3IgYW5kIGJvbWIgb3V0IHVubGVz
cyBFTk9CVUZTPyAqLw0KPiA+ICAgCQllcnIgPSBzb2NrLT5vcHMtPnNlbmRtc2coc29jaywgJm1z
ZywgbGVuKTsNCj4gPiAgIAkJaWYgKHVubGlrZWx5KGVyciA8IDApKSB7DQo+ID4gICAJCQlpZiAo
emNvcHlfdXNlZCkgew0KPiA+IEBAIC05MzEsMTMgKzkyNywxNCBAQCBzdGF0aWMgdm9pZCBoYW5k
bGVfdHhfemVyb2NvcHkoc3RydWN0IHZob3N0X25ldA0KPiAqbmV0LCBzdHJ1Y3Qgc29ja2V0ICpz
b2NrKQ0KPiA+ICAgCQkJCW52cS0+dXBlbmRfaWR4ID0gKCh1bnNpZ25lZCludnEtPnVwZW5kX2lk
eCAtIDEpDQo+ID4gICAJCQkJCSUgVUlPX01BWElPVjsNCj4gPiAgIAkJCX0NCj4gPiAtCQkJdmhv
c3RfZGlzY2FyZF92cV9kZXNjKHZxLCAxKTsNCj4gPiAtCQkJdmhvc3RfbmV0X2VuYWJsZV92cShu
ZXQsIHZxKTsNCj4gPiAtCQkJYnJlYWs7DQo+ID4gKwkJCWlmIChlcnIgPT0gLUVBR0FJTikgew0K
PiA+ICsJCQkJdmhvc3RfZGlzY2FyZF92cV9kZXNjKHZxLCAxKTsNCj4gPiArCQkJCXZob3N0X25l
dF9lbmFibGVfdnEobmV0LCB2cSk7DQo+ID4gKwkJCQlicmVhazsNCj4gPiArCQkJfQ0KPiA+ICAg
CQl9DQo+ID4gICAJCWlmIChlcnIgIT0gbGVuKQ0KPiA+IC0JCQlwcl9kZWJ1ZygiVHJ1bmNhdGVk
IFRYIHBhY2tldDogIg0KPiA+IC0JCQkJICIgbGVuICVkICE9ICV6ZFxuIiwgZXJyLCBsZW4pOw0K
PiA+ICsJCQl2cV9lcnIodnEsICJGYWlsIHRvIHNlbmRpbmcgcGFja2V0cyBlcnIgOiAlZCwgbGVu
IDogJXpkXG4iLCBlcnIsDQo+ID4gK2xlbik7DQo+ID4gICAJCWlmICghemNvcHlfdXNlZCkNCj4g
PiAgIAkJCXZob3N0X2FkZF91c2VkX2FuZF9zaWduYWwoJm5ldC0+ZGV2LCB2cSwgaGVhZCwgMCk7
DQo+ID4gICAJCWVsc2UNCg0K
