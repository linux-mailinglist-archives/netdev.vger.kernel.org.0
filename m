Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EEB92D7106
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 08:40:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389785AbgLKHjO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Dec 2020 02:39:14 -0500
Received: from szxga01-in.huawei.com ([45.249.212.187]:4113 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389909AbgLKHid (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Dec 2020 02:38:33 -0500
Received: from DGGEMM403-HUB.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4CsjKq2qqgzXllW;
        Fri, 11 Dec 2020 15:37:19 +0800 (CST)
Received: from DGGEMM533-MBX.china.huawei.com ([169.254.5.12]) by
 DGGEMM403-HUB.china.huawei.com ([10.3.20.211]) with mapi id 14.03.0487.000;
 Fri, 11 Dec 2020 15:37:43 +0800
From:   wangyunjian <wangyunjian@huawei.com>
To:     Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
CC:     "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Lilijun (Jerry)" <jerry.lilijun@huawei.com>,
        chenchanghu <chenchanghu@huawei.com>,
        xudingke <xudingke@huawei.com>,
        "huangbin (J)" <brian.huangbin@huawei.com>
Subject: RE: [PATCH net] vhost_net: fix high cpu load when sendmsg fails
Thread-Topic: [PATCH net] vhost_net: fix high cpu load when sendmsg fails
Thread-Index: AQHWziE8nJQGdy3dYky5c7D9irxA4anuMTMAgACNl9CAAfBBAIAAw4xg
Date:   Fri, 11 Dec 2020 07:37:42 +0000
Message-ID: <34EFBCA9F01B0748BEB6B629CE643AE60DB65468@DGGEMM533-MBX.china.huawei.com>
References: <1607514504-20956-1-git-send-email-wangyunjian@huawei.com>
 <20201209074832-mutt-send-email-mst@kernel.org>
 <34EFBCA9F01B0748BEB6B629CE643AE60DB61ADF@DGGEMM533-MBX.china.huawei.com>
 <f95f061c-dcac-9d56-94a0-50ef683946cd@redhat.com>
In-Reply-To: <f95f061c-dcac-9d56-94a0-50ef683946cd@redhat.com>
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

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBKYXNvbiBXYW5nIFttYWlsdG86
amFzb3dhbmdAcmVkaGF0LmNvbV0NCj4gU2VudDogRnJpZGF5LCBEZWNlbWJlciAxMSwgMjAyMCAx
MDo1MyBBTQ0KPiBUbzogd2FuZ3l1bmppYW4gPHdhbmd5dW5qaWFuQGh1YXdlaS5jb20+OyBNaWNo
YWVsIFMuIFRzaXJraW4NCj4gPG1zdEByZWRoYXQuY29tPg0KPiBDYzogdmlydHVhbGl6YXRpb25A
bGlzdHMubGludXgtZm91bmRhdGlvbi5vcmc7IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7IExpbGlq
dW4NCj4gKEplcnJ5KSA8amVycnkubGlsaWp1bkBodWF3ZWkuY29tPjsgY2hlbmNoYW5naHUgPGNo
ZW5jaGFuZ2h1QGh1YXdlaS5jb20+Ow0KPiB4dWRpbmdrZSA8eHVkaW5na2VAaHVhd2VpLmNvbT4N
Cj4gU3ViamVjdDogUmU6IFtQQVRDSCBuZXRdIHZob3N0X25ldDogZml4IGhpZ2ggY3B1IGxvYWQg
d2hlbiBzZW5kbXNnIGZhaWxzDQo+IA0KPiANCj4gT24gMjAyMC8xMi85IOS4i+WNiDk6MjcsIHdh
bmd5dW5qaWFuIHdyb3RlOg0KPiA+PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiA+PiBG
cm9tOiBNaWNoYWVsIFMuIFRzaXJraW4gW21haWx0bzptc3RAcmVkaGF0LmNvbV0NCj4gPj4gU2Vu
dDogV2VkbmVzZGF5LCBEZWNlbWJlciA5LCAyMDIwIDg6NTAgUE0NCj4gPj4gVG86IHdhbmd5dW5q
aWFuIDx3YW5neXVuamlhbkBodWF3ZWkuY29tPg0KPiA+PiBDYzogamFzb3dhbmdAcmVkaGF0LmNv
bTsgdmlydHVhbGl6YXRpb25AbGlzdHMubGludXgtZm91bmRhdGlvbi5vcmc7DQo+ID4+IG5ldGRl
dkB2Z2VyLmtlcm5lbC5vcmc7IExpbGlqdW4gKEplcnJ5KSA8amVycnkubGlsaWp1bkBodWF3ZWku
Y29tPjsNCj4gPj4gY2hlbmNoYW5naHUgPGNoZW5jaGFuZ2h1QGh1YXdlaS5jb20+OyB4dWRpbmdr
ZQ0KPiA8eHVkaW5na2VAaHVhd2VpLmNvbT4NCj4gPj4gU3ViamVjdDogUmU6IFtQQVRDSCBuZXRd
IHZob3N0X25ldDogZml4IGhpZ2ggY3B1IGxvYWQgd2hlbiBzZW5kbXNnDQo+ID4+IGZhaWxzDQo+
ID4+DQo+ID4+IE9uIFdlZCwgRGVjIDA5LCAyMDIwIGF0IDA3OjQ4OjI0UE0gKzA4MDAsIHdhbmd5
dW5qaWFuIHdyb3RlOg0KPiA+Pj4gRnJvbTogWXVuamlhbiBXYW5nIDx3YW5neXVuamlhbkBodWF3
ZWkuY29tPg0KPiA+Pj4NCj4gPj4+IEN1cnJlbnRseSB3ZSBicmVhayB0aGUgbG9vcCBhbmQgd2Fr
ZSB1cCB0aGUgdmhvc3Rfd29ya2VyIHdoZW4NCj4gPj4+IHNlbmRtc2cgZmFpbHMuIFdoZW4gdGhl
IHdvcmtlciB3YWtlcyB1cCBhZ2Fpbiwgd2UnbGwgbWVldCB0aGUgc2FtZQ0KPiA+Pj4gZXJyb3Iu
IFRoaXMgd2lsbCBjYXVzZSBoaWdoIENQVSBsb2FkLiBUbyBmaXggdGhpcyBpc3N1ZSwgd2UgY2Fu
IHNraXANCj4gPj4+IHRoaXMgZGVzY3JpcHRpb24gYnkgaWdub3JpbmcgdGhlIGVycm9yLg0KPiA+
Pj4NCj4gPj4+IFNpZ25lZC1vZmYtYnk6IFl1bmppYW4gV2FuZyA8d2FuZ3l1bmppYW5AaHVhd2Vp
LmNvbT4NCj4gPj4+IC0tLQ0KPiA+Pj4gICBkcml2ZXJzL3Zob3N0L25ldC5jIHwgMjQgKysrKyst
LS0tLS0tLS0tLS0tLS0tLS0tDQo+ID4+PiAgIDEgZmlsZSBjaGFuZ2VkLCA1IGluc2VydGlvbnMo
KyksIDE5IGRlbGV0aW9ucygtKQ0KPiA+Pj4NCj4gPj4+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3Zo
b3N0L25ldC5jIGIvZHJpdmVycy92aG9zdC9uZXQuYyBpbmRleA0KPiA+Pj4gNTMxYTAwZDcwM2Nk
Li5hYzk1MGIxMTIwZjUgMTAwNjQ0DQo+ID4+PiAtLS0gYS9kcml2ZXJzL3Zob3N0L25ldC5jDQo+
ID4+PiArKysgYi9kcml2ZXJzL3Zob3N0L25ldC5jDQo+ID4+PiBAQCAtODI5LDE0ICs4MjksOCBA
QCBzdGF0aWMgdm9pZCBoYW5kbGVfdHhfY29weShzdHJ1Y3Qgdmhvc3RfbmV0DQo+ID4+PiAqbmV0
LCBzdHJ1Y3Qgc29ja2V0ICpzb2NrKQ0KPiA+Pj4NCj4gPj4+ICAgCQkvKiBUT0RPOiBDaGVjayBz
cGVjaWZpYyBlcnJvciBhbmQgYm9tYiBvdXQgdW5sZXNzIEVOT0JVRlM/DQo+ICovDQo+ID4+PiAg
IAkJZXJyID0gc29jay0+b3BzLT5zZW5kbXNnKHNvY2ssICZtc2csIGxlbik7DQo+ID4+PiAtCQlp
ZiAodW5saWtlbHkoZXJyIDwgMCkpIHsNCj4gPj4+IC0JCQl2aG9zdF9kaXNjYXJkX3ZxX2Rlc2Mo
dnEsIDEpOw0KPiA+Pj4gLQkJCXZob3N0X25ldF9lbmFibGVfdnEobmV0LCB2cSk7DQo+ID4+PiAt
CQkJYnJlYWs7DQo+ID4+PiAtCQl9DQo+ID4+PiAtCQlpZiAoZXJyICE9IGxlbikNCj4gPj4+IC0J
CQlwcl9kZWJ1ZygiVHJ1bmNhdGVkIFRYIHBhY2tldDogbGVuICVkICE9ICV6ZFxuIiwNCj4gPj4+
IC0JCQkJIGVyciwgbGVuKTsNCj4gPj4+ICsJCWlmICh1bmxpa2VseShlcnIgPCAwIHx8IGVyciAh
PSBsZW4pKQ0KPiA+Pj4gKwkJCXZxX2Vycih2cSwgIkZhaWwgdG8gc2VuZGluZyBwYWNrZXRzIGVy
ciA6ICVkLCBsZW4gOiAlemRcbiIsDQo+IGVyciwNCj4gPj4+ICtsZW4pOw0KPiA+Pj4gICBkb25l
Og0KPiA+Pj4gICAJCXZxLT5oZWFkc1tudnEtPmRvbmVfaWR4XS5pZCA9IGNwdV90b192aG9zdDMy
KHZxLCBoZWFkKTsNCj4gPj4+ICAgCQl2cS0+aGVhZHNbbnZxLT5kb25lX2lkeF0ubGVuID0gMDsN
Cj4gPj4gT25lIG9mIHRoZSByZWFzb25zIGZvciBzZW5kbXNnIHRvIGZhaWwgaXMgRU5PQlVGUy4N
Cj4gPj4gSW4gdGhhdCBjYXNlIGZvciBzdXJlIHdlIGRvbid0IHdhbnQgdG8gZHJvcCBwYWNrZXQu
DQo+ID4gTm93IHRoZSBmdW5jdGlvbiB0YXBfc2VuZG1zZygpL3R1bl9zZW5kbXNnKCkgZG9uJ3Qg
cmV0dXJuIEVOT0JVRlMuDQo+IA0KPiANCj4gSSB0aGluayBub3QsIGl0IGNhbiBoYXBwZW4gaWYg
d2UgZXhjZWVkcyBzbmRidWYuIEUuZyBzZWUgdHVuX2FsbG9jX3NrYigpLg0KDQpUaGlzIHBhdGNo
ICduZXQ6IGFkZCBhbGxvY19za2Jfd2l0aF9mcmFncygpIGhlbHBlcicgbW9kaWZ5cyB0aGUgcmV0
dXJuIHZhbHVlDQpvZiBzb2NrX2FsbG9jX3NlbmRfcHNrYigpIGZyb20gLUVOT0JVRlMgdG8gLUVB
R0FJTiB3aGVuIHdlIGV4Y2VlZHMgc25kYnVmLg0KU28gdGhlIHJldHVybiB2YWx1ZSBvZiB0dW5f
YWxsb2Nfc2tiIGhhcyBiZWVuIGNoYW5nZWQuDQoNCldlIGRvbid0IGRyb3AgcGFja2V0IGlmIHRo
ZSByZWFzb25zIGZvciBzZW5kbXNnIHRvIGZhaWwgaXMgRUFHQUlOLg0KSG93IGFib3V0IHRoaXM/
DQoNClRoYW5rcw0KDQo+IA0KPiBUaGFua3MNCj4gDQo+IA0KPiA+DQo+ID4+IFRoZXJlIGNvdWxk
IGJlIG90aGVyIHRyYW5zaWVudCBlcnJvcnMuDQo+ID4+IFdoaWNoIGVycm9yIGRpZCB5b3UgZW5j
b3VudGVyLCBzcGVjaWZpY2FsbHk/DQo+ID4gQ3VycmVudGx5IGEgZ3Vlc3Qgdm0gc2VuZCBhIHNr
YiB3aGljaCBsZW5ndGggaXMgbW9yZSB0aGFuIDY0ay4NCj4gPiBJZiB2aXJ0aW8gaGRyIGlzIHdy
b25nLCB0aGUgcHJvYmxlbSB3aWxsIGFsc28gYmUgdHJpZ2dlcmVkLg0KPiA+DQo+ID4gVGhhbmtz
DQo+ID4NCj4gPj4+IEBAIC05MjUsMTkgKzkxOSwxMSBAQCBzdGF0aWMgdm9pZCBoYW5kbGVfdHhf
emVyb2NvcHkoc3RydWN0DQo+ID4+PiB2aG9zdF9uZXQgKm5ldCwgc3RydWN0IHNvY2tldCAqc29j
aykNCj4gPj4+DQo+ID4+PiAgIAkJLyogVE9ETzogQ2hlY2sgc3BlY2lmaWMgZXJyb3IgYW5kIGJv
bWIgb3V0IHVubGVzcyBFTk9CVUZTPw0KPiAqLw0KPiA+Pj4gICAJCWVyciA9IHNvY2stPm9wcy0+
c2VuZG1zZyhzb2NrLCAmbXNnLCBsZW4pOw0KPiA+Pj4gLQkJaWYgKHVubGlrZWx5KGVyciA8IDAp
KSB7DQo+ID4+PiAtCQkJaWYgKHpjb3B5X3VzZWQpIHsNCj4gPj4+ICsJCWlmICh1bmxpa2VseShl
cnIgPCAwIHx8IGVyciAhPSBsZW4pKSB7DQo+ID4+PiArCQkJaWYgKHpjb3B5X3VzZWQgJiYgZXJy
IDwgMCkNCj4gPj4+ICAgCQkJCXZob3N0X25ldF91YnVmX3B1dCh1YnVmcyk7DQo+ID4+PiAtCQkJ
CW52cS0+dXBlbmRfaWR4ID0gKCh1bnNpZ25lZCludnEtPnVwZW5kX2lkeCAtIDEpDQo+ID4+PiAt
CQkJCQklIFVJT19NQVhJT1Y7DQo+ID4+PiAtCQkJfQ0KPiA+Pj4gLQkJCXZob3N0X2Rpc2NhcmRf
dnFfZGVzYyh2cSwgMSk7DQo+ID4+PiAtCQkJdmhvc3RfbmV0X2VuYWJsZV92cShuZXQsIHZxKTsN
Cj4gPj4+IC0JCQlicmVhazsNCj4gPj4+ICsJCQl2cV9lcnIodnEsICJGYWlsIHRvIHNlbmRpbmcg
cGFja2V0cyBlcnIgOiAlZCwgbGVuIDogJXpkXG4iLA0KPiBlcnIsDQo+ID4+PiArbGVuKTsNCj4g
Pj4+ICAgCQl9DQo+ID4+PiAtCQlpZiAoZXJyICE9IGxlbikNCj4gPj4+IC0JCQlwcl9kZWJ1Zygi
VHJ1bmNhdGVkIFRYIHBhY2tldDogIg0KPiA+Pj4gLQkJCQkgIiBsZW4gJWQgIT0gJXpkXG4iLCBl
cnIsIGxlbik7DQo+ID4+PiAgIAkJaWYgKCF6Y29weV91c2VkKQ0KPiA+Pj4gICAJCQl2aG9zdF9h
ZGRfdXNlZF9hbmRfc2lnbmFsKCZuZXQtPmRldiwgdnEsIGhlYWQsIDApOw0KPiA+Pj4gICAJCWVs
c2UNCj4gPj4+IC0tDQo+ID4+PiAyLjIzLjANCg0K
