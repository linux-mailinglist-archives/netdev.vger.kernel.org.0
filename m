Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B1CC48BD61
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 03:41:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348896AbiALClp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 21:41:45 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.85.151]:20806 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236970AbiALClo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jan 2022 21:41:44 -0500
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-60-Q8z4g-x6NUOq4lI9Gl_fKg-1; Wed, 12 Jan 2022 02:41:42 +0000
X-MC-Unique: Q8z4g-x6NUOq4lI9Gl_fKg-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.26; Wed, 12 Jan 2022 02:41:42 +0000
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.026; Wed, 12 Jan 2022 02:41:42 +0000
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
Thread-Index: AQHYBooc+zd0TLCwI0SMx+giCPDt3axdi3LQgACAiACAAARzEIAAO5cAgABiJsA=
Date:   Wed, 12 Jan 2022 02:41:42 +0000
Message-ID: <941373b680b648e3be1175b23595be4a@AcuMS.aculab.com>
References: <cover.1641863490.git.asml.silence@gmail.com>
 <0bc041d2d38a08064a642c05ca8cceb0ca165f88.1641863490.git.asml.silence@gmail.com>
 <918a937f6cef44e282353001a7fbba7a@AcuMS.aculab.com>
 <25f5ba09-a54c-c386-e142-7b7454f1d8d4@gmail.com>
 <f2e3693ec8d1498aa376f72ebd49e058@AcuMS.aculab.com>
 <d9714712-075f-17af-b4f0-67f82178abae@gmail.com>
In-Reply-To: <d9714712-075f-17af-b4f0-67f82178abae@gmail.com>
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

RnJvbTogUGF2ZWwgQmVndW5rb3YNCj4gU2VudDogMTEgSmFudWFyeSAyMDIyIDIwOjQ4DQo+IE9u
IDEvMTEvMjIgMTc6MjUsIERhdmlkIExhaWdodCB3cm90ZToNCj4gPiBGcm9tOiBQYXZlbCBCZWd1
bmtvdg0KPiA+PiBTZW50OiAxMSBKYW51YXJ5IDIwMjIgMTY6NTkNCj4gPj4NCj4gPj4gT24gMS8x
MS8yMiAwOToyNCwgRGF2aWQgTGFpZ2h0IHdyb3RlOg0KPiA+Pj4gRnJvbTogUGF2ZWwgQmVndW5r
b3YNCj4gPj4+PiBTZW50OiAxMSBKYW51YXJ5IDIwMjIgMDE6MjINCj4gPj4+Pg0KPiA+Pj4+IElu
bGluZSBhIEhXIGNzdW0nZWQgcGFydCBvZiBza2JfY3N1bV9od29mZmxvYWRfaGVscCgpLg0KPiA+
Pj4+DQo+ID4+Pj4gU2lnbmVkLW9mZi1ieTogUGF2ZWwgQmVndW5rb3YgPGFzbWwuc2lsZW5jZUBn
bWFpbC5jb20+DQo+ID4+Pj4gLS0tDQo+ID4+Pj4gICAgaW5jbHVkZS9saW51eC9uZXRkZXZpY2Uu
aCB8IDE2ICsrKysrKysrKysrKysrLS0NCj4gPj4+PiAgICBuZXQvY29yZS9kZXYuYyAgICAgICAg
ICAgIHwgMTMgKysrLS0tLS0tLS0tLQ0KPiA+Pj4+ICAgIDIgZmlsZXMgY2hhbmdlZCwgMTcgaW5z
ZXJ0aW9ucygrKSwgMTIgZGVsZXRpb25zKC0pDQo+ID4+Pj4NCj4gPj4+PiBkaWZmIC0tZ2l0IGEv
aW5jbHVkZS9saW51eC9uZXRkZXZpY2UuaCBiL2luY2x1ZGUvbGludXgvbmV0ZGV2aWNlLmgNCj4g
Pj4+PiBpbmRleCAzMjEzYzcyMjdiNTkuLmZiZTZjNzY0Y2U1NyAxMDA2NDQNCj4gPj4+PiAtLS0g
YS9pbmNsdWRlL2xpbnV4L25ldGRldmljZS5oDQo+ID4+Pj4gKysrIGIvaW5jbHVkZS9saW51eC9u
ZXRkZXZpY2UuaA0KPiA+Pj4+IEBAIC00NTk2LDggKzQ1OTYsMjAgQEAgdm9pZCBuZXRkZXZfcnNz
X2tleV9maWxsKHZvaWQgKmJ1ZmZlciwgc2l6ZV90IGxlbik7DQo+ID4+Pj4NCj4gPj4+PiAgICBp
bnQgc2tiX2NoZWNrc3VtX2hlbHAoc3RydWN0IHNrX2J1ZmYgKnNrYik7DQo+ID4+Pj4gICAgaW50
IHNrYl9jcmMzMmNfY3N1bV9oZWxwKHN0cnVjdCBza19idWZmICpza2IpOw0KPiA+Pj4+IC1pbnQg
c2tiX2NzdW1faHdvZmZsb2FkX2hlbHAoc3RydWN0IHNrX2J1ZmYgKnNrYiwNCj4gPj4+PiAtCQkJ
ICAgIGNvbnN0IG5ldGRldl9mZWF0dXJlc190IGZlYXR1cmVzKTsNCj4gPj4+PiAraW50IF9fc2ti
X2NzdW1faHdvZmZsb2FkX2hlbHAoc3RydWN0IHNrX2J1ZmYgKnNrYiwNCj4gPj4+PiArCQkJICAg
ICAgY29uc3QgbmV0ZGV2X2ZlYXR1cmVzX3QgZmVhdHVyZXMpOw0KPiA+Pj4+ICsNCj4gPj4+PiAr
c3RhdGljIGlubGluZSBpbnQgc2tiX2NzdW1faHdvZmZsb2FkX2hlbHAoc3RydWN0IHNrX2J1ZmYg
KnNrYiwNCj4gPj4+PiArCQkJCQkgIGNvbnN0IG5ldGRldl9mZWF0dXJlc190IGZlYXR1cmVzKQ0K
PiA+Pj4+ICt7DQo+ID4+Pj4gKwlpZiAodW5saWtlbHkoc2tiX2NzdW1faXNfc2N0cChza2IpKSkN
Cj4gPj4+PiArCQlyZXR1cm4gISEoZmVhdHVyZXMgJiBORVRJRl9GX1NDVFBfQ1JDKSA/IDAgOg0K
PiA+Pj4NCj4gPj4+IElmIHRoYXQgISEgZG9pbmcgYW55dGhpbmc/IC0gZG9lc24ndCBsb29rIGxp
a2UgaXQuDQo+ID4+DQo+ID4+IEl0IGRvZXNuJ3QsIGJ1dCBsZWZ0IHRoZSBvcmlnaW5hbCBzdHls
ZQ0KPiA+DQo+ID4gSXQganVzdCBtYWtlcyB5b3UgdGhpbmsgaXQgaXMgbmVlZGVkLi4uDQo+ID4N
Cj4gPj4+PiArCQkJc2tiX2NyYzMyY19jc3VtX2hlbHAoc2tiKTsNCj4gPj4+PiArDQo+ID4+Pj4g
KwlpZiAoZmVhdHVyZXMgJiBORVRJRl9GX0hXX0NTVU0pDQo+ID4+Pj4gKwkJcmV0dXJuIDA7DQo+
ID4+Pj4gKwlyZXR1cm4gX19za2JfY3N1bV9od29mZmxvYWRfaGVscChza2IsIGZlYXR1cmVzKTsN
Cj4gPj4+PiArfQ0KPiA+Pj4NCj4gPj4+IE1heWJlIHlvdSBzaG91bGQgcmVtb3ZlIHNvbWUgYmxv
YXQgYnkgbW92aW5nIHRoZSBzY3RwIGNvZGUNCj4gPj4+IGludG8gdGhlIGNhbGxlZCBmdW5jdGlv
bi4NCj4gPj4+IFRoaXMgcHJvYmFibHkgbmVlZHMgc29tZXRoaW5nIGxpa2U/DQo+ID4+Pg0KPiA+
Pj4gew0KPiA+Pj4gCWlmIChmZWF0dXJlcyAmIE5FVElGX0ZfSFdfQ1NVTSAmJiAhc2tiX2NzdW1f
aXNfc2N0cChza2IpKQ0KPiA+Pj4gCQlyZXR1cm4gMDsNCj4gPj4+IAlyZXR1cm4gX19za2JfY3N1
bV9od19vZmZsb2FkKHNrYiwgZmVhdHVyZXMpOw0KPiA+Pj4gfQ0KPiA+Pg0KPiA+PiBJIGRvbid0
IGxpa2UgaW5saW5pbmcgdGhhdCBzY3RwIGNodW5rIG15c2VsZi4gSXQgc2VlbXMgeW91ciB3YXkg
d291bGQNCj4gPj4gbmVlZCBhbm90aGVyIHNrYl9jc3VtX2lzX3NjdHAoKSBpbiBfX3NrYl9jc3Vt
X2h3X29mZmxvYWQoKSwgaWYgc28gSQ0KPiA+PiBkb24ndCB0aGluayBpdCdzIHdvcnRoIGl0LiBX
b3VsZCd2ZSBiZWVuIGdyZWF0IHRvIHB1dCB0aGUNCj4gPj4gTkVUSUZfRl9IV19DU1VNIGNoZWNr
IGZpcnN0IGFuZCBoaWRlIHNjdHAsIGJ1dCBkb24ndCB0aGluayBpdCdzDQo+ID4+IGNvcnJlY3Qu
IFdvdWxkIGJlIGdyZWF0IHRvIGhlYXIgc29tZSBpZGVhcy4NCj4gPg0KPiA+IEdpdmVuIHRoZSBk
ZWZpbml0aW9uOg0KPiA+DQo+ID4gc3RhdGljIGlubGluZSBib29sIHNrYl9jc3VtX2lzX3NjdHAo
c3RydWN0IHNrX2J1ZmYgKnNrYikNCj4gPiB7DQo+ID4gCXJldHVybiBza2ItPmNzdW1fbm90X2lu
ZXQ7DQo+ID4gfQ0KPiA+DQo+ID4gSSB3b3VsZG4ndCB3b3JyeSBhYm91dCBkb2luZyBpdCB0d2lj
ZS4NCj4gPg0KPiA+IEFsc28gc2tiX2NyYzMyX2NzdW1faGVscCgpIGlzIG9ubHkgY2FsbGVkIG9u
ZS4NCj4gPiBNYWtlIGl0IHN0YXRpYyAoc28gaW5saW5lZCkgYW5kIHBhc3MgJ2ZlYXR1cmVzJyBp
bnRvIGl0Lg0KPiA+DQo+ID4gSW4gcmVhbGl0eSBzY3RwIGlzIHN1Y2ggYSBzbG93IGNyYXBweSBw
cm90b2NvbCB0aGF0IGEgZmV3IGV4dHJhDQo+ID4gZnVuY3Rpb24gY2FsbHMgd2lsbCBtYWtlIGRp
ZGRseS1zcXVpdCBkaWZmZXJlbmNlLg0KPiA+IChBbmQgeWVzLCB3ZSBkbyBhY3R1YWxseSB1c2Ug
dGhlIHNjdHAgc3RhY2suKQ0KPiANCj4gSSB3YXMgbW9yZSB0aGlua2luZyBhYm91dCBub24tc2N0
cCBwYXRoIHdpdGhvdXQgTkVUSUZfRl9IV19DU1VNDQoNCkluIHdoaWNoIGNhc2UgeW91IG5lZWQg
dGhlIGJvZHkgb2YgX19za2JfY3N1bV9od19vZmZsb2FkKCkNCmFuZCBlbmQgdXAgZG9pbmcgdGhl
ICdzY3RwJyBjaGVjayBvbmNlIGluc2lkZSBpdC4NClRoZSAnc2N0cCcgY2hlY2sgaXMgb25seSBk
b25lIHR3aWNlIGZvciBzY3RwLg0KDQoJRGF2aWQNCg0KLQ0KUmVnaXN0ZXJlZCBBZGRyZXNzIExh
a2VzaWRlLCBCcmFtbGV5IFJvYWQsIE1vdW50IEZhcm0sIE1pbHRvbiBLZXluZXMsIE1LMSAxUFQs
IFVLDQpSZWdpc3RyYXRpb24gTm86IDEzOTczODYgKFdhbGVzKQ0K

