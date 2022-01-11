Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73FCE48B3BD
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 18:25:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343989AbiAKRZj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 12:25:39 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.85.151]:49403 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238268AbiAKRZi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jan 2022 12:25:38 -0500
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-242-dlMRcRXWOTyXkk0FIAdRLA-1; Tue, 11 Jan 2022 17:25:36 +0000
X-MC-Unique: dlMRcRXWOTyXkk0FIAdRLA-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.26; Tue, 11 Jan 2022 17:25:36 +0000
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.026; Tue, 11 Jan 2022 17:25:36 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Pavel Begunkov' <asml.silence@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>
CC:     Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 13/14] net: inline part of skb_csum_hwoffload_help
Thread-Topic: [PATCH 13/14] net: inline part of skb_csum_hwoffload_help
Thread-Index: AQHYBooc+zd0TLCwI0SMx+giCPDt3axdi3LQgACAiACAAARzEA==
Date:   Tue, 11 Jan 2022 17:25:35 +0000
Message-ID: <f2e3693ec8d1498aa376f72ebd49e058@AcuMS.aculab.com>
References: <cover.1641863490.git.asml.silence@gmail.com>
 <0bc041d2d38a08064a642c05ca8cceb0ca165f88.1641863490.git.asml.silence@gmail.com>
 <918a937f6cef44e282353001a7fbba7a@AcuMS.aculab.com>
 <25f5ba09-a54c-c386-e142-7b7454f1d8d4@gmail.com>
In-Reply-To: <25f5ba09-a54c-c386-e142-7b7454f1d8d4@gmail.com>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=C51A453 smtp.mailfrom=david.laight@aculab.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogUGF2ZWwgQmVndW5rb3YNCj4gU2VudDogMTEgSmFudWFyeSAyMDIyIDE2OjU5DQo+IA0K
PiBPbiAxLzExLzIyIDA5OjI0LCBEYXZpZCBMYWlnaHQgd3JvdGU6DQo+ID4gRnJvbTogUGF2ZWwg
QmVndW5rb3YNCj4gPj4gU2VudDogMTEgSmFudWFyeSAyMDIyIDAxOjIyDQo+ID4+DQo+ID4+IElu
bGluZSBhIEhXIGNzdW0nZWQgcGFydCBvZiBza2JfY3N1bV9od29mZmxvYWRfaGVscCgpLg0KPiA+
Pg0KPiA+PiBTaWduZWQtb2ZmLWJ5OiBQYXZlbCBCZWd1bmtvdiA8YXNtbC5zaWxlbmNlQGdtYWls
LmNvbT4NCj4gPj4gLS0tDQo+ID4+ICAgaW5jbHVkZS9saW51eC9uZXRkZXZpY2UuaCB8IDE2ICsr
KysrKysrKysrKysrLS0NCj4gPj4gICBuZXQvY29yZS9kZXYuYyAgICAgICAgICAgIHwgMTMgKysr
LS0tLS0tLS0tLQ0KPiA+PiAgIDIgZmlsZXMgY2hhbmdlZCwgMTcgaW5zZXJ0aW9ucygrKSwgMTIg
ZGVsZXRpb25zKC0pDQo+ID4+DQo+ID4+IGRpZmYgLS1naXQgYS9pbmNsdWRlL2xpbnV4L25ldGRl
dmljZS5oIGIvaW5jbHVkZS9saW51eC9uZXRkZXZpY2UuaA0KPiA+PiBpbmRleCAzMjEzYzcyMjdi
NTkuLmZiZTZjNzY0Y2U1NyAxMDA2NDQNCj4gPj4gLS0tIGEvaW5jbHVkZS9saW51eC9uZXRkZXZp
Y2UuaA0KPiA+PiArKysgYi9pbmNsdWRlL2xpbnV4L25ldGRldmljZS5oDQo+ID4+IEBAIC00NTk2
LDggKzQ1OTYsMjAgQEAgdm9pZCBuZXRkZXZfcnNzX2tleV9maWxsKHZvaWQgKmJ1ZmZlciwgc2l6
ZV90IGxlbik7DQo+ID4+DQo+ID4+ICAgaW50IHNrYl9jaGVja3N1bV9oZWxwKHN0cnVjdCBza19i
dWZmICpza2IpOw0KPiA+PiAgIGludCBza2JfY3JjMzJjX2NzdW1faGVscChzdHJ1Y3Qgc2tfYnVm
ZiAqc2tiKTsNCj4gPj4gLWludCBza2JfY3N1bV9od29mZmxvYWRfaGVscChzdHJ1Y3Qgc2tfYnVm
ZiAqc2tiLA0KPiA+PiAtCQkJICAgIGNvbnN0IG5ldGRldl9mZWF0dXJlc190IGZlYXR1cmVzKTsN
Cj4gPj4gK2ludCBfX3NrYl9jc3VtX2h3b2ZmbG9hZF9oZWxwKHN0cnVjdCBza19idWZmICpza2Is
DQo+ID4+ICsJCQkgICAgICBjb25zdCBuZXRkZXZfZmVhdHVyZXNfdCBmZWF0dXJlcyk7DQo+ID4+
ICsNCj4gPj4gK3N0YXRpYyBpbmxpbmUgaW50IHNrYl9jc3VtX2h3b2ZmbG9hZF9oZWxwKHN0cnVj
dCBza19idWZmICpza2IsDQo+ID4+ICsJCQkJCSAgY29uc3QgbmV0ZGV2X2ZlYXR1cmVzX3QgZmVh
dHVyZXMpDQo+ID4+ICt7DQo+ID4+ICsJaWYgKHVubGlrZWx5KHNrYl9jc3VtX2lzX3NjdHAoc2ti
KSkpDQo+ID4+ICsJCXJldHVybiAhIShmZWF0dXJlcyAmIE5FVElGX0ZfU0NUUF9DUkMpID8gMCA6
DQo+ID4NCj4gPiBJZiB0aGF0ICEhIGRvaW5nIGFueXRoaW5nPyAtIGRvZXNuJ3QgbG9vayBsaWtl
IGl0Lg0KPiANCj4gSXQgZG9lc24ndCwgYnV0IGxlZnQgdGhlIG9yaWdpbmFsIHN0eWxlDQoNCkl0
IGp1c3QgbWFrZXMgeW91IHRoaW5rIGl0IGlzIG5lZWRlZC4uLg0KDQo+ID4+ICsJCQlza2JfY3Jj
MzJjX2NzdW1faGVscChza2IpOw0KPiA+PiArDQo+ID4+ICsJaWYgKGZlYXR1cmVzICYgTkVUSUZf
Rl9IV19DU1VNKQ0KPiA+PiArCQlyZXR1cm4gMDsNCj4gPj4gKwlyZXR1cm4gX19za2JfY3N1bV9o
d29mZmxvYWRfaGVscChza2IsIGZlYXR1cmVzKTsNCj4gPj4gK30NCj4gPg0KPiA+IE1heWJlIHlv
dSBzaG91bGQgcmVtb3ZlIHNvbWUgYmxvYXQgYnkgbW92aW5nIHRoZSBzY3RwIGNvZGUNCj4gPiBp
bnRvIHRoZSBjYWxsZWQgZnVuY3Rpb24uDQo+ID4gVGhpcyBwcm9iYWJseSBuZWVkcyBzb21ldGhp
bmcgbGlrZT8NCj4gPg0KPiA+IHsNCj4gPiAJaWYgKGZlYXR1cmVzICYgTkVUSUZfRl9IV19DU1VN
ICYmICFza2JfY3N1bV9pc19zY3RwKHNrYikpDQo+ID4gCQlyZXR1cm4gMDsNCj4gPiAJcmV0dXJu
IF9fc2tiX2NzdW1faHdfb2ZmbG9hZChza2IsIGZlYXR1cmVzKTsNCj4gPiB9DQo+IA0KPiBJIGRv
bid0IGxpa2UgaW5saW5pbmcgdGhhdCBzY3RwIGNodW5rIG15c2VsZi4gSXQgc2VlbXMgeW91ciB3
YXkgd291bGQNCj4gbmVlZCBhbm90aGVyIHNrYl9jc3VtX2lzX3NjdHAoKSBpbiBfX3NrYl9jc3Vt
X2h3X29mZmxvYWQoKSwgaWYgc28gSQ0KPiBkb24ndCB0aGluayBpdCdzIHdvcnRoIGl0LiBXb3Vs
ZCd2ZSBiZWVuIGdyZWF0IHRvIHB1dCB0aGUNCj4gTkVUSUZfRl9IV19DU1VNIGNoZWNrIGZpcnN0
IGFuZCBoaWRlIHNjdHAsIGJ1dCBkb24ndCB0aGluayBpdCdzDQo+IGNvcnJlY3QuIFdvdWxkIGJl
IGdyZWF0IHRvIGhlYXIgc29tZSBpZGVhcy4NCg0KR2l2ZW4gdGhlIGRlZmluaXRpb246DQoNCnN0
YXRpYyBpbmxpbmUgYm9vbCBza2JfY3N1bV9pc19zY3RwKHN0cnVjdCBza19idWZmICpza2IpDQp7
DQoJcmV0dXJuIHNrYi0+Y3N1bV9ub3RfaW5ldDsNCn0NCg0KSSB3b3VsZG4ndCB3b3JyeSBhYm91
dCBkb2luZyBpdCB0d2ljZS4NCg0KQWxzbyBza2JfY3JjMzJfY3N1bV9oZWxwKCkgaXMgb25seSBj
YWxsZWQgb25lLg0KTWFrZSBpdCBzdGF0aWMgKHNvIGlubGluZWQpIGFuZCBwYXNzICdmZWF0dXJl
cycgaW50byBpdC4NCg0KSW4gcmVhbGl0eSBzY3RwIGlzIHN1Y2ggYSBzbG93IGNyYXBweSBwcm90
b2NvbCB0aGF0IGEgZmV3IGV4dHJhDQpmdW5jdGlvbiBjYWxscyB3aWxsIG1ha2UgZGlkZGx5LXNx
dWl0IGRpZmZlcmVuY2UuDQooQW5kIHllcywgd2UgZG8gYWN0dWFsbHkgdXNlIHRoZSBzY3RwIHN0
YWNrLikNCg0KCURhdmlkDQoNCi0NClJlZ2lzdGVyZWQgQWRkcmVzcyBMYWtlc2lkZSwgQnJhbWxl
eSBSb2FkLCBNb3VudCBGYXJtLCBNaWx0b24gS2V5bmVzLCBNSzEgMVBULCBVSw0KUmVnaXN0cmF0
aW9uIE5vOiAxMzk3Mzg2IChXYWxlcykNCg==

