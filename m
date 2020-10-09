Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C52228875D
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 12:56:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732100AbgJIK4V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 06:56:21 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:50432 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731990AbgJIK4V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Oct 2020 06:56:21 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-124-ERHMxqkFNqu-gjupEPL9Yw-1; Fri, 09 Oct 2020 11:56:17 +0100
X-MC-Unique: ERHMxqkFNqu-gjupEPL9Yw-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Fri, 9 Oct 2020 11:56:16 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Fri, 9 Oct 2020 11:56:16 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Johannes Berg' <johannes@sipsolutions.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "nstange@suse.de" <nstange@suse.de>,
        "ap420073@gmail.com" <ap420073@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "rafael@kernel.org" <rafael@kernel.org>
Subject: RE: [RFC] debugfs: protect against rmmod while files are open
Thread-Topic: [RFC] debugfs: protect against rmmod while files are open
Thread-Index: AQHWnimt6sgsjnbqOUy4QqWuAHTYD6mPGQ+Q
Date:   Fri, 9 Oct 2020 10:56:16 +0000
Message-ID: <8fe62082d9774a1fb21894c27e140318@AcuMS.aculab.com>
References: <4a58caee3b6b8975f4ff632bf6d2a6673788157d.camel@sipsolutions.net>
         <20201009124113.a723e46a677a.Ib6576679bb8db01eb34d3dce77c4c6899c28ce26@changeid>
         (sfid-20201009_124139_179083_C8D99C3A)
 <2a333c2a50c676c461c1e2da5847dd4024099909.camel@sipsolutions.net>
In-Reply-To: <2a333c2a50c676c461c1e2da5847dd4024099909.camel@sipsolutions.net>
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

RnJvbTogSm9oYW5uZXMgQmVyZw0KPiBTZW50OiAwOSBPY3RvYmVyIDIwMjAgMTE6NDgNCj4gDQo+
IE9uIEZyaSwgMjAyMC0xMC0wOSBhdCAxMjo0MSArMDIwMCwgSm9oYW5uZXMgQmVyZyB3cm90ZToN
Cj4gDQo+ID4gSWYgdGhlIGZvcHMgZG9lc24ndCBoYXZlIGEgcmVsZWFzZSBtZXRob2QsIHdlIGRv
bid0IGV2ZW4gbmVlZA0KPiA+IHRvIGtlZXAgYSByZWZlcmVuY2UgdG8gdGhlIHJlYWxfZm9wcywg
d2UgY2FuIGp1c3QgZm9wc19wdXQoKQ0KPiA+IHRoZW0gYWxyZWFkeSBpbiBkZWJ1Z2ZzIHJlbW92
ZSwgYW5kIGEgbGF0ZXIgZnVsbF9wcm94eV9yZWxlYXNlKCkNCj4gPiB3b24ndCBjYWxsIGFueXRo
aW5nIGFueXdheSAtIHRoaXMganVzdCBjcmFzaGVkL1VBRmVkIGJlY2F1c2UgaXQNCj4gPiB1c2Vk
IHJlYWxfZm9wcywgbm90IGJlY2F1c2UgdGhlcmUgd2FzIGFjdHVhbGx5IGEgKG5vdyBpbnZhbGlk
KQ0KPiA+IHJlbGVhc2UoKSBtZXRob2QuDQo+IA0KPiBJIGFjdHVhbGx5IGltcGxlbWVudGVkIHNv
bWV0aGluZyBhIGJpdCBiZXR0ZXIgdGhhbiB3aGF0IEkgZGVzY3JpYmVkIC0gd2UNCj4gbmV2ZXIg
bmVlZCBhIHJlZmVyZW5jZSB0byB0aGUgcmVhbF9mb3BzIGZvciB0aGUgcmVsZWFzZSBtZXRob2Qg
YWxvbmUsDQo+IGFuZCB0aGF0IG1lYW5zIGlmIHRoZSByZWxlYXNlIG1ldGhvZCBpcyBpbiB0aGUg
a2VybmVsIGltYWdlLCByYXRoZXIgdGhhbg0KPiBhIG1vZHVsZSwgaXQgY2FuIHN0aWxsIGJlIGNh
bGxlZC4NCj4gDQo+IFRoYXQgdG9nZXRoZXIgc2hvdWxkIHJlZHVjZSB0aGUgfjExNyBwbGFjZXMg
eW91IGNoYW5nZWQgaW4gdGhlIGxhcmdlDQo+IHBhdGNoc2V0IHRvIGFyb3VuZCBhIGhhbmRmdWwu
DQoNCklzIHRoZXJlIGFuIGVxdWl2YWxlbnQgcHJvYmxlbSBmb3Igbm9ybWFsIGNkZXYgb3BlbnMN
CmluIGFueSBtb2R1bGVzPw0KDQoJRGF2aWQNCg0KLQ0KUmVnaXN0ZXJlZCBBZGRyZXNzIExha2Vz
aWRlLCBCcmFtbGV5IFJvYWQsIE1vdW50IEZhcm0sIE1pbHRvbiBLZXluZXMsIE1LMSAxUFQsIFVL
DQpSZWdpc3RyYXRpb24gTm86IDEzOTczODYgKFdhbGVzKQ0K

