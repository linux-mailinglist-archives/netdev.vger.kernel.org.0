Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AB35347F01
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 18:13:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237246AbhCXRM5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 13:12:57 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.86.151]:60330 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237136AbhCXRMl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Mar 2021 13:12:41 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-175-kENySIPJPJOErBFbNqf-iw-1; Wed, 24 Mar 2021 17:12:38 +0000
X-MC-Unique: kENySIPJPJOErBFbNqf-iw-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.2; Wed, 24 Mar 2021 17:12:38 +0000
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.012; Wed, 24 Mar 2021 17:12:38 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Alex Elder' <elder@ieee.org>, 'Alex Elder' <elder@linaro.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "rdunlap@infradead.org" <rdunlap@infradead.org>,
        "bjorn.andersson@linaro.org" <bjorn.andersson@linaro.org>,
        "evgreen@chromium.org" <evgreen@chromium.org>,
        "cpratapa@codeaurora.org" <cpratapa@codeaurora.org>,
        "subashab@codeaurora.org" <subashab@codeaurora.org>,
        "elder@kernel.org" <elder@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net-next] net: ipa: avoid 64-bit modulus
Thread-Topic: [PATCH net-next] net: ipa: avoid 64-bit modulus
Thread-Index: AQHXH4CsHuvM6SpiNkO+MERkTuT8kKqTVWfggAAL7ICAAABBYA==
Date:   Wed, 24 Mar 2021 17:12:38 +0000
Message-ID: <aa5a91defcca4a4cb8e2317e26385010@AcuMS.aculab.com>
References: <20210323010505.2149882-1-elder@linaro.org>
 <f77f12f117934e9d9e3b284ed37e87a7@AcuMS.aculab.com>
 <fea8c425-2af0-0526-4ad7-73c523253e08@ieee.org>
In-Reply-To: <fea8c425-2af0-0526-4ad7-73c523253e08@ieee.org>
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

RnJvbTogQWxleCBFbGRlcg0KPiBTZW50OiAyNCBNYXJjaCAyMDIxIDE3OjA3DQo+IA0KPiBPbiAz
LzI0LzIxIDExOjI3IEFNLCBEYXZpZCBMYWlnaHQgd3JvdGU6DQo+ID4gRnJvbTogQWxleCBFbGRl
cg0KPiA+PiBTZW50OiAyMyBNYXJjaCAyMDIxIDAxOjA1DQo+ID4+IEl0IGlzIHBvc3NpYmxlIGZv
ciBhIDMyIGJpdCB4ODYgYnVpbGQgdG8gdXNlIGEgNjQgYml0IERNQSBhZGRyZXNzLg0KPiA+Pg0K
PiA+PiBUaGVyZSBhcmUgdHdvIHJlbWFpbmluZyBzcG90cyB3aGVyZSB0aGUgSVBBIGRyaXZlciBk
b2VzIGEgbW9kdWxvDQo+ID4+IG9wZXJhdGlvbiB0byBjaGVjayBhbGlnbm1lbnQgb2YgYSBETUEg
YWRkcmVzcywgYW5kIHVuZGVyIGNlcnRhaW4NCj4gPj4gY29uZGl0aW9ucyB0aGlzIGNhbiBsZWFk
IHRvIGEgYnVpbGQgZXJyb3Igb24gaTM4NiAoYXQgbGVhc3QpLg0KPiA+Pg0KPiA+PiBUaGUgYWxp
Z25tZW50IGNoZWNrcyB3ZSdyZSBkb2luZyBhcmUgZm9yIHBvd2VyLW9mLTIgdmFsdWVzLCBhbmQg
dGhpcw0KPiA+PiBtZWFucyB0aGUgbG93ZXIgMzIgYml0cyBvZiB0aGUgRE1BIGFkZHJlc3MgY2Fu
IGJlIHVzZWQuICBUaGlzIGVuc3VyZXMNCj4gPj4gYm90aCBvcGVyYW5kcyB0byB0aGUgbW9kdWxv
IG9wZXJhdG9yIGFyZSAzMiBiaXRzIHdpZGUuDQo+ID4+DQo+ID4+IFJlcG9ydGVkLWJ5OiBSYW5k
eSBEdW5sYXAgPHJkdW5sYXBAaW5mcmFkZWFkLm9yZz4NCj4gPj4gU2lnbmVkLW9mZi1ieTogQWxl
eCBFbGRlciA8ZWxkZXJAbGluYXJvLm9yZz4NCj4gPj4gLS0tDQo+ID4+ICAgZHJpdmVycy9uZXQv
aXBhL2dzaS5jICAgICAgIHwgMTEgKysrKysrKy0tLS0NCj4gPj4gICBkcml2ZXJzL25ldC9pcGEv
aXBhX3RhYmxlLmMgfCAgOSArKysrKystLS0NCj4gPj4gICAyIGZpbGVzIGNoYW5nZWQsIDEzIGlu
c2VydGlvbnMoKyksIDcgZGVsZXRpb25zKC0pDQo+ID4+DQo+ID4+IGRpZmYgLS1naXQgYS9kcml2
ZXJzL25ldC9pcGEvZ3NpLmMgYi9kcml2ZXJzL25ldC9pcGEvZ3NpLmMNCj4gPj4gaW5kZXggN2Yz
ZTMzOGNhN2E3Mi4uYjYzNTU4MjdiZjkwMCAxMDA2NDQNCj4gPj4gLS0tIGEvZHJpdmVycy9uZXQv
aXBhL2dzaS5jDQo+ID4+ICsrKyBiL2RyaXZlcnMvbmV0L2lwYS9nc2kuYw0KPiA+PiBAQCAtMTQz
NiwxNSArMTQzNiwxOCBAQCBzdGF0aWMgdm9pZCBnc2lfZXZ0X3JpbmdfcnhfdXBkYXRlKHN0cnVj
dCBnc2lfZXZ0X3JpbmcgKmV2dF9yaW5nLCB1MzINCj4gaW5kZXgpDQo+ID4+ICAgLyogSW5pdGlh
bGl6ZSBhIHJpbmcsIGluY2x1ZGluZyBhbGxvY2F0aW5nIERNQSBtZW1vcnkgZm9yIGl0cyBlbnRy
aWVzICovDQo+ID4+ICAgc3RhdGljIGludCBnc2lfcmluZ19hbGxvYyhzdHJ1Y3QgZ3NpICpnc2ks
IHN0cnVjdCBnc2lfcmluZyAqcmluZywgdTMyIGNvdW50KQ0KPiA+PiAgIHsNCj4gPj4gLQlzaXpl
X3Qgc2l6ZSA9IGNvdW50ICogR1NJX1JJTkdfRUxFTUVOVF9TSVpFOw0KPiA+PiArCXUzMiBzaXpl
ID0gY291bnQgKiBHU0lfUklOR19FTEVNRU5UX1NJWkU7DQo+ID4+ICAgCXN0cnVjdCBkZXZpY2Ug
KmRldiA9IGdzaS0+ZGV2Ow0KPiA+PiAgIAlkbWFfYWRkcl90IGFkZHI7DQo+ID4+DQo+ID4+IC0J
LyogSGFyZHdhcmUgcmVxdWlyZXMgYSAyXm4gcmluZyBzaXplLCB3aXRoIGFsaWdubWVudCBlcXVh
bCB0byBzaXplICovDQo+ID4+ICsJLyogSGFyZHdhcmUgcmVxdWlyZXMgYSAyXm4gcmluZyBzaXpl
LCB3aXRoIGFsaWdubWVudCBlcXVhbCB0byBzaXplLg0KPiA+PiArCSAqIFRoZSBzaXplIGlzIGEg
cG93ZXIgb2YgMiwgc28gd2UgY2FuIGNoZWNrIGFsaWdubWVudCB1c2luZyBqdXN0DQo+ID4+ICsJ
ICogdGhlIGJvdHRvbSAzMiBiaXRzIGZvciBhIERNQSBhZGRyZXNzIG9mIGFueSBzaXplLg0KPiA+
PiArCSAqLw0KPiA+PiAgIAlyaW5nLT52aXJ0ID0gZG1hX2FsbG9jX2NvaGVyZW50KGRldiwgc2l6
ZSwgJmFkZHIsIEdGUF9LRVJORUwpOw0KPiA+DQo+ID4gRG9lc24ndCBkbWFfYWxsb2NfY29oZXJl
bnQoKSBndWFyYW50ZWUgdGhhdCBhbGlnbm1lbnQ/DQo+ID4gSSBkb3VidCBhbnl3aGVyZSBlbHNl
IGNoZWNrcz8NCj4gDQo+IEkgbm9ybWFsbHkgd291bGRuJ3QgY2hlY2sgc29tZXRoaW5nIGxpa2Ug
dGhpcyBpZiBpdA0KPiB3ZXJlbid0IGd1YXJhbnRlZWQuICBJJ20gbm90IHN1cmUgd2h5IEkgZGlk
IGl0IGhlcmUuDQo+IA0KPiBJIHNlZSBpdCdzICJndWFyYW50ZWVkIHRvIGJlIGFsaWduZWQgdG8g
dGhlIHNtYWxsZXN0DQo+IFBBR0VfU0laRSBvcmRlciB3aGljaCBpcyBncmVhdGVyIHRoYW4gb3Ig
ZXF1YWwgdG8NCj4gdGhlIHJlcXVlc3RlZCBzaXplLiIgIFNvIEkgdGhpbmsgdGhlIGFuc3dlciB0
byB5b3VyDQo+IHF1ZXN0aW9uIGlzICJ5ZXMsIGl0IGRvZXMgZ3VhcmFudGVlIHRoYXQuIg0KPiAN
Cj4gSSdsbCBtYWtlIGEgbm90ZSB0byByZW1vdmUgdGhpcyBjaGVjayBpbiBhIGZ1dHVyZQ0KPiBw
YXRjaCwgYW5kIHdpbGwgY3JlZGl0IHlvdSB3aXRoIHRoZSBzdWdnZXN0aW9uLg0KDQpJIHRoaW5r
ICdjb3VudCcgaXMgYWxzbyByZXF1aXJlZCB0byBiZSBhIHBvd2VyIG9mIDIuDQpzbyB5b3UgY291
bGQgaGF2ZSBjaGVja2VkICdhZGRyICYgKHNpemUgLSAxKScuDQoNCglEYXZpZA0KDQotDQpSZWdp
c3RlcmVkIEFkZHJlc3MgTGFrZXNpZGUsIEJyYW1sZXkgUm9hZCwgTW91bnQgRmFybSwgTWlsdG9u
IEtleW5lcywgTUsxIDFQVCwgVUsNClJlZ2lzdHJhdGlvbiBObzogMTM5NzM4NiAoV2FsZXMpDQo=

