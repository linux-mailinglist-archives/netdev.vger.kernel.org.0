Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4103473166
	for <lists+netdev@lfdr.de>; Mon, 13 Dec 2021 17:16:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239741AbhLMQQp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 11:16:45 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.86.151]:49780 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235831AbhLMQQo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Dec 2021 11:16:44 -0500
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-163-nUUY3YRSPUWzZvTEm3zptA-1; Mon, 13 Dec 2021 16:16:42 +0000
X-MC-Unique: nUUY3YRSPUWzZvTEm3zptA-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.26; Mon, 13 Dec 2021 16:16:41 +0000
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.026; Mon, 13 Dec 2021 16:16:41 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Eric Dumazet' <edumazet@google.com>
CC:     Dave Hansen <dave.hansen@intel.com>,
        Noah Goldstein <goldstein.w.n@gmail.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        X86 ML <x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "alexanderduyck@fb.com" <alexanderduyck@fb.com>,
        open list <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Subject: RE: [PATCH] x86/lib: Remove the special case for odd-aligned buffers
 in csum_partial.c
Thread-Topic: [PATCH] x86/lib: Remove the special case for odd-aligned buffers
 in csum_partial.c
Thread-Index: AdfwL8CqMU0zbyVyQYmiKOZRxmZfsgAAq7MAAADny8AAAPppAAAAro+Q
Date:   Mon, 13 Dec 2021 16:16:41 +0000
Message-ID: <7c0685cf9148439997eb2bd6edbfdf27@AcuMS.aculab.com>
References: <45d12aa0c95049a392d52ff239d42d83@AcuMS.aculab.com>
 <52edd5fd-daa0-729b-4646-43450552d2ab@intel.com>
 <96b6a476c4154da3bd04996139cd8a6d@AcuMS.aculab.com>
 <CANn89i+4acJp8ohBMWU4sketLfitKCzmS8FQTvduxumYYketvw@mail.gmail.com>
In-Reply-To: <CANn89i+4acJp8ohBMWU4sketLfitKCzmS8FQTvduxumYYketvw@mail.gmail.com>
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

RnJvbTogRXJpYyBEdW1hemV0DQo+IFNlbnQ6IDEzIERlY2VtYmVyIDIwMjEgMTU6NTYNCj4gDQo+
IE9uIE1vbiwgRGVjIDEzLCAyMDIxIGF0IDc6MzcgQU0gRGF2aWQgTGFpZ2h0IDxEYXZpZC5MYWln
aHRAYWN1bGFiLmNvbT4gd3JvdGU6DQo+ID4NCj4gPiBGcm9tOiBEYXZlIEhhbnNlbg0KPiA+ID4g
U2VudDogMTMgRGVjZW1iZXIgMjAyMSAxNTowMg0KPiA+IC5jDQo+ID4gPg0KPiA+ID4gT24gMTIv
MTMvMjEgNjo0MyBBTSwgRGF2aWQgTGFpZ2h0IHdyb3RlOg0KPiA+ID4gPiBUaGVyZSBpcyBubyBu
ZWVkIHRvIHNwZWNpYWwgY2FzZSB0aGUgdmVyeSB1bnVzdWFsIG9kZC1hbGlnbmVkIGJ1ZmZlcnMu
DQo+ID4gPiA+IFRoZXkgYXJlIG5vIHdvcnNlIHRoYW4gNG4rMiBhbGlnbmVkIGJ1ZmZlcnMuDQo+
ID4gPiA+DQo+ID4gPiA+IFNpZ25lZC1vZmYtYnk6IERhdmlkIExhaWdodCA8ZGF2aWQubGFpZ2h0
QGFjdWxhYi5jb20+DQo+ID4gPiA+IC0tLQ0KPiA+ID4gPg0KPiA+ID4gPiBPbiBhbiBpNy03NzAw
IG1pc2FsaWduZWQgYnVmZmVycyBhZGQgMiBvciAzIGNsb2NrcyAoaW4gMTE1KSB0byBhIDUxMiBi
eXRlDQo+ID4gPiA+ICAgY2hlY2tzdW0uDQo+ID4gPiA+IFRoYXQgaXMganVzdCBtZWFzdXJpbmcg
dGhlIG1haW4gbG9vcCB3aXRoIGFuIGxmZW5jZSBwcmlvciB0byByZHBtYyB0bw0KPiA+ID4gPiBy
ZWFkIFBFUkZfQ09VTlRfSFdfQ1BVX0NZQ0xFUy4NCj4gPiA+DQo+ID4gPiBJJ20gYSBiaXQgY29u
ZnVzZWQgYnkgdGhpcyBjaGFuZ2Vsb2cuDQo+ID4gPg0KPiA+ID4gQXJlIHlvdSBzYXlpbmcgdGhh
dCB0aGUgcGF0Y2ggY2F1c2VzIGEgKHNtYWxsKSBwZXJmb3JtYW5jZSByZWdyZXNzaW9uPw0KPiA+
ID4NCj4gPiA+IEFyZSB5b3UgYWxzbyBzYXlpbmcgdGhhdCB0aGUgb3B0aW1pemF0aW9uIGhlcmUg
aXMgbm90IHdvcnRoIGl0IGJlY2F1c2UNCj4gPiA+IGl0IHNhdmVzIDE1IGxpbmVzIG9mIGNvZGU/
ICBPciB0aGF0IHRoZSBtaXNhbGlnbm1lbnQgY2hlY2tzIHRoZW1zZWx2ZXMNCj4gPiA+IGFkZCAy
IG9yIDMgY3ljbGVzLCBhbmQgdGhpcyBpcyBhbiAqb3B0aW1pemF0aW9uKj8NCj4gPg0KPiA+IEkn
bSBzYXlpbmcgdGhhdCBpdCBjYW4ndCBiZSB3b3J0aCBvcHRpbWlzaW5nIGZvciBhIG1pc2FsaWdu
ZWQNCj4gPiBidWZmZXIgYmVjYXVzZSB0aGUgY29zdCBvZiB0aGUgYnVmZmVyIGJlaW5nIG1pc2Fs
aWduZWQgaXMgc28gc21hbGwuDQo+ID4gU28gdGhlIHRlc3QgZm9yIGEgbWlzYWxpZ25lZCBidWZm
ZXIgYXJlIGdvaW5nIHRvIGNvc3QgbW9yZSB0aGFuDQo+ID4gYW5kIHBsYXVzaWJsZSBnYWluLg0K
PiA+DQo+ID4gTm90IG9ubHkgdGhhdCB0aGUgYnVmZmVyIHdpbGwgbmV2ZXIgYmUgb2RkIGFsaWdu
ZWQgYXQgYWxsLg0KPiA+DQo+ID4gVGhlIGNvZGUgaXMgbGVmdCBpbiBmcm9tIGEgcHJldmlvdXMg
dmVyc2lvbiB0aGF0IGRpZCBkbyBhbGlnbmVkDQo+ID4gd29yZCByZWFkcyAtIHNvIGhhZCB0byBk
byBleHRyYSBmb3Igb2RkIGFsaWdubWVudC4NCj4gPg0KPiA+IE5vdGUgdGhhdCBjb2RlIGlzIGRv
aW5nIG1pc2FsaWduZWQgcmVhZHMgZm9yIHRoZSBtb3JlIGxpa2VseSA0bisyDQo+ID4gYWxpZ25l
ZCBldGhlcm5ldCByZWNlaXZlIGJ1ZmZlcnMuDQo+ID4gSSBkb3VidCB0aGF0IGV2ZW4gYSB0ZXN0
IGZvciB0aGF0IHdvdWxkIGJlIHdvcnRod2hpbGUgZXZlbiBpZiB5b3UNCj4gPiB3ZXJlIGNoZWNr
c3VtbWluZyBmdWxsIHNpemVkIGV0aGVybmV0IHBhY2tldHMuDQo+ID4NCj4gPiBTbyB0aGUgY2hh
bmdlIGlzIGRlbGV0aW5nIGNvZGUgdGhhdCBpcyBuZXZlciBhY3R1YWxseSBleGVjdXRlZA0KPiA+
IGZyb20gdGhlIGhvdCBwYXRoLg0KPiA+DQo+IA0KPiBJIHRoaW5rIEkgbGVmdCB0aGlzIGNvZGUg
YmVjYXVzZSBJIGdvdCBjb25mdXNlZCB3aXRoIG9kZC9ldmVuIGNhc2UsDQo+IGJ1dCB0aGlzIGlz
IGhhbmRsZWQgYnkgdXBwZXIgZnVuY3Rpb25zIGxpa2UgY3N1bV9ibG9ja19hZGQoKQ0KPiANCj4g
V2hhdCBtYXR0ZXJzIGlzIG5vdCBpZiB0aGUgc3RhcnQgb2YgYSBmcmFnIGlzIG9kZC9ldmVuLCBi
dXQgd2hhdA0KPiBvZmZzZXQgaXQgaXMgaW4gdGhlIG92ZXJhbGwgJyBmcmFtZScsIGlmIGEgZnJh
bWUgaXMgc3BsaXQgaW50byBtdWx0aXBsZQ0KPiBhcmVhcyAoc2NhdHRlci9nYXRoZXIpDQoNClll
cyBvZGQgbGVuZ3RoIGZyYWdtZW50cyBhcmUgYSBkaWZmZXJlbnQgcHJvYmxlbS4NCg0KCURhdmlk
DQoNCi0NClJlZ2lzdGVyZWQgQWRkcmVzcyBMYWtlc2lkZSwgQnJhbWxleSBSb2FkLCBNb3VudCBG
YXJtLCBNaWx0b24gS2V5bmVzLCBNSzEgMVBULCBVSw0KUmVnaXN0cmF0aW9uIE5vOiAxMzk3Mzg2
IChXYWxlcykNCg==

