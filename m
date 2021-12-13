Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B19B34730AB
	for <lists+netdev@lfdr.de>; Mon, 13 Dec 2021 16:37:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234872AbhLMPhT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 10:37:19 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.85.151]:26250 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232572AbhLMPhS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Dec 2021 10:37:18 -0500
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-58-a24iemFmMfm37i7mZ3Uxgw-1; Mon, 13 Dec 2021 15:37:16 +0000
X-MC-Unique: a24iemFmMfm37i7mZ3Uxgw-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.26; Mon, 13 Dec 2021 15:37:15 +0000
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.026; Mon, 13 Dec 2021 15:37:15 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Dave Hansen' <dave.hansen@intel.com>,
        'Noah Goldstein' <goldstein.w.n@gmail.com>,
        Eric Dumazet <edumazet@google.com>
CC:     "tglx@linutronix.de" <tglx@linutronix.de>,
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
Thread-Index: AdfwL8CqMU0zbyVyQYmiKOZRxmZfsgAAq7MAAADny8A=
Date:   Mon, 13 Dec 2021 15:37:15 +0000
Message-ID: <96b6a476c4154da3bd04996139cd8a6d@AcuMS.aculab.com>
References: <45d12aa0c95049a392d52ff239d42d83@AcuMS.aculab.com>
 <52edd5fd-daa0-729b-4646-43450552d2ab@intel.com>
In-Reply-To: <52edd5fd-daa0-729b-4646-43450552d2ab@intel.com>
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

RnJvbTogRGF2ZSBIYW5zZW4NCj4gU2VudDogMTMgRGVjZW1iZXIgMjAyMSAxNTowMg0KLmMNCj4g
DQo+IE9uIDEyLzEzLzIxIDY6NDMgQU0sIERhdmlkIExhaWdodCB3cm90ZToNCj4gPiBUaGVyZSBp
cyBubyBuZWVkIHRvIHNwZWNpYWwgY2FzZSB0aGUgdmVyeSB1bnVzdWFsIG9kZC1hbGlnbmVkIGJ1
ZmZlcnMuDQo+ID4gVGhleSBhcmUgbm8gd29yc2UgdGhhbiA0bisyIGFsaWduZWQgYnVmZmVycy4N
Cj4gPg0KPiA+IFNpZ25lZC1vZmYtYnk6IERhdmlkIExhaWdodCA8ZGF2aWQubGFpZ2h0QGFjdWxh
Yi5jb20+DQo+ID4gLS0tDQo+ID4NCj4gPiBPbiBhbiBpNy03NzAwIG1pc2FsaWduZWQgYnVmZmVy
cyBhZGQgMiBvciAzIGNsb2NrcyAoaW4gMTE1KSB0byBhIDUxMiBieXRlDQo+ID4gICBjaGVja3N1
bS4NCj4gPiBUaGF0IGlzIGp1c3QgbWVhc3VyaW5nIHRoZSBtYWluIGxvb3Agd2l0aCBhbiBsZmVu
Y2UgcHJpb3IgdG8gcmRwbWMgdG8NCj4gPiByZWFkIFBFUkZfQ09VTlRfSFdfQ1BVX0NZQ0xFUy4N
Cj4gDQo+IEknbSBhIGJpdCBjb25mdXNlZCBieSB0aGlzIGNoYW5nZWxvZy4NCj4gDQo+IEFyZSB5
b3Ugc2F5aW5nIHRoYXQgdGhlIHBhdGNoIGNhdXNlcyBhIChzbWFsbCkgcGVyZm9ybWFuY2UgcmVn
cmVzc2lvbj8NCj4gDQo+IEFyZSB5b3UgYWxzbyBzYXlpbmcgdGhhdCB0aGUgb3B0aW1pemF0aW9u
IGhlcmUgaXMgbm90IHdvcnRoIGl0IGJlY2F1c2UNCj4gaXQgc2F2ZXMgMTUgbGluZXMgb2YgY29k
ZT8gIE9yIHRoYXQgdGhlIG1pc2FsaWdubWVudCBjaGVja3MgdGhlbXNlbHZlcw0KPiBhZGQgMiBv
ciAzIGN5Y2xlcywgYW5kIHRoaXMgaXMgYW4gKm9wdGltaXphdGlvbio/DQoNCkknbSBzYXlpbmcg
dGhhdCBpdCBjYW4ndCBiZSB3b3J0aCBvcHRpbWlzaW5nIGZvciBhIG1pc2FsaWduZWQNCmJ1ZmZl
ciBiZWNhdXNlIHRoZSBjb3N0IG9mIHRoZSBidWZmZXIgYmVpbmcgbWlzYWxpZ25lZCBpcyBzbyBz
bWFsbC4NClNvIHRoZSB0ZXN0IGZvciBhIG1pc2FsaWduZWQgYnVmZmVyIGFyZSBnb2luZyB0byBj
b3N0IG1vcmUgdGhhbg0KYW5kIHBsYXVzaWJsZSBnYWluLg0KDQpOb3Qgb25seSB0aGF0IHRoZSBi
dWZmZXIgd2lsbCBuZXZlciBiZSBvZGQgYWxpZ25lZCBhdCBhbGwuDQoNClRoZSBjb2RlIGlzIGxl
ZnQgaW4gZnJvbSBhIHByZXZpb3VzIHZlcnNpb24gdGhhdCBkaWQgZG8gYWxpZ25lZA0Kd29yZCBy
ZWFkcyAtIHNvIGhhZCB0byBkbyBleHRyYSBmb3Igb2RkIGFsaWdubWVudC4NCg0KTm90ZSB0aGF0
IGNvZGUgaXMgZG9pbmcgbWlzYWxpZ25lZCByZWFkcyBmb3IgdGhlIG1vcmUgbGlrZWx5IDRuKzIN
CmFsaWduZWQgZXRoZXJuZXQgcmVjZWl2ZSBidWZmZXJzLg0KSSBkb3VidCB0aGF0IGV2ZW4gYSB0
ZXN0IGZvciB0aGF0IHdvdWxkIGJlIHdvcnRod2hpbGUgZXZlbiBpZiB5b3UNCndlcmUgY2hlY2tz
dW1taW5nIGZ1bGwgc2l6ZWQgZXRoZXJuZXQgcGFja2V0cy4NCg0KU28gdGhlIGNoYW5nZSBpcyBk
ZWxldGluZyBjb2RlIHRoYXQgaXMgbmV2ZXIgYWN0dWFsbHkgZXhlY3V0ZWQNCmZyb20gdGhlIGhv
dCBwYXRoLg0KDQoJRGF2aWQNCg0KLQ0KUmVnaXN0ZXJlZCBBZGRyZXNzIExha2VzaWRlLCBCcmFt
bGV5IFJvYWQsIE1vdW50IEZhcm0sIE1pbHRvbiBLZXluZXMsIE1LMSAxUFQsIFVLDQpSZWdpc3Ry
YXRpb24gTm86IDEzOTczODYgKFdhbGVzKQ0K

