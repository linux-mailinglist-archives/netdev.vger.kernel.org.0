Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BF0448CDC4
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 22:28:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231287AbiALV1q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 16:27:46 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.85.151]:53447 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229873AbiALV1n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 16:27:43 -0500
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-56-YKI_HUCbPtWK5PQHYtyc5g-1; Wed, 12 Jan 2022 21:27:40 +0000
X-MC-Unique: YKI_HUCbPtWK5PQHYtyc5g-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.26; Wed, 12 Jan 2022 21:27:40 +0000
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.026; Wed, 12 Jan 2022 21:27:40 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     "'Jason A. Donenfeld'" <Jason@zx2c4.com>,
        Eric Biggers <ebiggers@kernel.org>
CC:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        WireGuard mailing list <wireguard@lists.zx2c4.com>,
        LKML <linux-kernel@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "Geert Uytterhoeven" <geert@linux-m68k.org>,
        Theodore Ts'o <tytso@mit.edu>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        "Herbert Xu" <herbert@gondor.apana.org.au>
Subject: RE: [PATCH crypto 1/2] lib/crypto: blake2s-generic: reduce code size
 on small systems
Thread-Topic: [PATCH crypto 1/2] lib/crypto: blake2s-generic: reduce code size
 on small systems
Thread-Index: AQHYB+VtFSMgWrVqxkafOfrj0ELoyKxf5LLQ
Date:   Wed, 12 Jan 2022 21:27:40 +0000
Message-ID: <d7e206a5a03d46a69c0be3b8ed651518@AcuMS.aculab.com>
References: <CAHmME9qbnYmhvsuarButi6s=58=FPiti0Z-QnGMJ=OsMzy1eOg@mail.gmail.com>
 <20220111134934.324663-1-Jason@zx2c4.com>
 <20220111134934.324663-2-Jason@zx2c4.com> <Yd8enQTocuCSQVkT@gmail.com>
 <CAHmME9qGs8yfYy0GVcV8XaUt9cjCqQF2D79RvrsQE+CNLCeojA@mail.gmail.com>
In-Reply-To: <CAHmME9qGs8yfYy0GVcV8XaUt9cjCqQF2D79RvrsQE+CNLCeojA@mail.gmail.com>
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

RnJvbTogSmFzb24gQS4gRG9uZW5mZWxkDQo+IFNlbnQ6IDEyIEphbnVhcnkgMjAyMiAxODo1MQ0K
PiANCj4gT24gV2VkLCBKYW4gMTIsIDIwMjIgYXQgNzozMiBQTSBFcmljIEJpZ2dlcnMgPGViaWdn
ZXJzQGtlcm5lbC5vcmc+IHdyb3RlOg0KPiA+IEhvdyBhYm91dCB1bnJvbGxpbmcgdGhlIGlubmVy
IGxvb3AgYnV0IG5vdCB0aGUgb3V0ZXIgb25lPyAgV291bGRuJ3QgdGhhdCBnaXZlDQo+ID4gbW9z
dCBvZiB0aGUgYmVuZWZpdCwgd2l0aG91dCBodXJ0aW5nIHBlcmZvcm1hbmNlIGFzIG11Y2g/DQo+
ID4NCj4gPiBJZiB5b3Ugc3RheSB3aXRoIHRoaXMgYXBwcm9hY2ggYW5kIGRvbid0IHVucm9sbCBl
aXRoZXIgbG9vcCwgY2FuIHlvdSB1c2UgJ3InIGFuZA0KPiA+ICdpJyBpbnN0ZWFkIG9mICdpJyBh
bmQgJ2onLCB0byBtYXRjaCB0aGUgbmFtaW5nIGluIEcoKT8NCj4gDQo+IEFsbCB0aGlzIG1pZ2h0
IHdvcmssIHN1cmUuIEJ1dCBhcyBtZW50aW9uZWQgZWFybGllciwgSSd2ZSBhYmFuZG9uZWQNCj4g
dGhpcyBlbnRpcmVseSwgYXMgSSBkb24ndCB0aGluayB0aGlzIHBhdGNoIGlzIG5lY2Vzc2FyeS4g
U2VlIHRoZSB2Mw0KPiBwYXRjaHNldCBpbnN0ZWFkOg0KPiANCj4gaHR0cHM6Ly9sb3JlLmtlcm5l
bC5vcmcvbGludXgtY3J5cHRvLzIwMjIwMTExMjIwNTA2Ljc0MjA2Ny0xLUphc29uQHp4MmM0LmNv
bS8NCg0KSSB0aGluayB5b3UgbWVudGlvbmVkIGluIGFub3RoZXIgdGhyZWFkIHRoYXQgdGhlIGJ1
ZmZlcnMgKGVnIGZvciBJUHY2DQphZGRyZXNzZXMpIGFyZSBhY3R1YWxseSBvZnRlbiBxdWl0ZSBz
aG9ydC4NCg0KRm9yIHNob3J0IGJ1ZmZlcnMgdGhlICdyb2xsZWQtdXAnIGxvb3AgbWF5IGJlIG9m
IHNpbWlsYXIgcGVyZm9ybWFuY2UNCnRvIHRoZSB1bnJvbGxlZCBvbmUgYmVjYXVzZSBvZiB0aGUg
dGltZSB0YWtlbiB0byByZWFkIGFsbCB0aGUgaW5zdHJ1Y3Rpb25zDQppbnRvIHRoZSBJLWNhY2hl
IGFuZCBkZWNvZGUgdGhlbS4NCklmIHRoZSBsb29wIGVuZHMgdXAgc21hbGwgZW5vdWdoIGl0IHdp
bGwgZml0IGludG8gdGhlICdkZWNvZGVkIGxvb3ANCmJ1ZmZlcicgb2YgbW9kZXJuIEludGVsIHg4
NiBjcHUgYW5kIHdvbid0IGV2ZW4gbmVlZCBkZWNvZGluZyBvbg0KZWFjaCBpdGVyYXRpb24uDQoN
CkkgcmVhbGx5IHN1c3BlY3QgdGhhdCB0aGUgaGVhdmlseSB1bnJvbGxlZCBsb29wIGlzIG9ubHkg
cmVhbGx5IGZhc3QNCmZvciBiaWcgYnVmZmVycyBhbmQvb3Igd2hlbiBpdCBpcyBhbHJlYWR5IGlu
IHRoZSBJLWNhY2hlLg0KSW4gcmVhbCBsaWZlIEkgd29uZGVyIGhvdyBvZnRlbiB0aGF0IGFjdHVh
bGx5IGhhcHBlbnM/DQpFc3BlY2lhbGx5IGZvciB0aGUgdXNlcyB0aGUga2VybmVsIGlzIG1ha2lu
ZyBvZiB0aGUgY29kZS4NCg0KWW91IG5lZWQgdG8gYmVuY2htYXJrIHNpbmdsZSBleGVjdXRpb25z
IG9mIHRoZSBmdW5jdGlvbg0KKGRvYWJsZSBvbiB4ODYgd2l0aCB0aGUgcGVyZm9ybWFuY2UgbW9u
aXRvciBjeWNsZSBjb3VudGVyKQ0KdG8gZ2V0IHR5cGljYWwvYmVzdCBjbG9ja3MvYnl0ZSBmaWd1
cmVzIHJhdGhlciB0aGFuIGENCmJpZyBhdmVyYWdlIGZvciByZXBlYXRlZCBvcGVyYXRpb24gb24g
YSBsb25nIGJ1ZmZlci4NCg0KCURhdmlkDQoNCi0NClJlZ2lzdGVyZWQgQWRkcmVzcyBMYWtlc2lk
ZSwgQnJhbWxleSBSb2FkLCBNb3VudCBGYXJtLCBNaWx0b24gS2V5bmVzLCBNSzEgMVBULCBVSw0K
UmVnaXN0cmF0aW9uIE5vOiAxMzk3Mzg2IChXYWxlcykNCg==

