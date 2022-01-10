Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 244BD48A297
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 23:17:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345306AbiAJWRA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 17:17:00 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.86.151]:45229 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241425AbiAJWRA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jan 2022 17:17:00 -0500
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-15-1x9FGhdsPCquWqlIhiJdqw-1; Mon, 10 Jan 2022 22:16:58 +0000
X-MC-Unique: 1x9FGhdsPCquWqlIhiJdqw-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.26; Mon, 10 Jan 2022 22:16:51 +0000
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.026; Mon, 10 Jan 2022 22:16:51 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Ben Greear' <greearb@candelatech.com>,
        Neal Cardwell <ncardwell@google.com>
CC:     netdev <netdev@vger.kernel.org>
Subject: RE: Debugging stuck tcp connection across localhost
Thread-Topic: Debugging stuck tcp connection across localhost
Thread-Index: AQHYBk1RL1C882pa6EyVUBRa3+FHQKxc0aYw
Date:   Mon, 10 Jan 2022 22:16:50 +0000
Message-ID: <e8e6693695c04bd6a679ddd43733703b@AcuMS.aculab.com>
References: <38e55776-857d-1b51-3558-d788cf3c1524@candelatech.com>
 <CADVnQyn97m5ybVZ3FdWAw85gOMLAvPSHiR8_NC_nGFyBdRySqQ@mail.gmail.com>
 <b3e53863-e80e-704f-81a2-905f80f3171d@candelatech.com>
 <CADVnQymJaF3HoxoWhTb=D2wuVTpe_fp45tL8g7kaA2jgDe+xcQ@mail.gmail.com>
 <a6ec30f5-9978-f55f-f34f-34485a09db97@candelatech.com>
 <CADVnQym9LTupiVCTWh95qLQWYTkiFAEESv9Htzrgij8UVqSHBQ@mail.gmail.com>
 <b60aab98-a95f-d392-4391-c0d5e2afb2cd@candelatech.com>
 <9330e1c7-f7a2-0f1e-0ede-c9e5353060e3@candelatech.com>
In-Reply-To: <9330e1c7-f7a2-0f1e-0ede-c9e5353060e3@candelatech.com>
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

RnJvbTogQmVuIEdyZWVhciA8Z3JlZWFyYkBjYW5kZWxhdGVjaC5jb20+DQo+IFNlbnQ6IDEwIEph
bnVhcnkgMjAyMiAxODoxMA0KLi4uDQo+ICBGcm9tIG15IG93biBsb29raW5nIGF0IHRoaW5ncywg
aXQgc2VlbXMgdGhhdCB0aGUgc25pZmZlciBmYWlscyB0byBnZXQgZnJhbWVzIG5lYXIgd2hlbiB0
aGUgcHJvYmxlbQ0KPiBzdGFydHMgaGFwcGVuaW5nLiAgSSBhbSBiYWZmbGVkIGFzIHRvIGhvdyB0
aGF0IGNhbiBoYXBwZW4sIGVzcGVjaWFsbHkgc2luY2UgaXQgc2VlbXMgdG8gc3RvcCBnZXR0aW5n
DQo+IHBhY2tldHMgZnJvbSBtdWx0aXBsZSBkaWZmZXJlbnQgVENQIGNvbm5lY3Rpb25zICh0aGUg
c25pZmZlciBmaWx0ZXIgd291bGQgcGljayB1cCBzb21lIG90aGVyIGxvb3AtYmFjaw0KPiByZWxh
dGVkIGNvbm5lY3Rpb25zIHRvIHRoZSBzYW1lIElQIHBvcnQpLg0KPiANCj4gQW5kLCBpZiBJIGlu
dGVycHJldCB0aGUgc3Mgb3V0cHV0IHByb3Blcmx5LCBhZnRlciB0aGUgcHJvYmxlbSBoYXBwZW5z
LCB0aGUgc29ja2V0cyBzdGlsbCB0aGluayB0aGV5DQo+IGFyZQ0KPiBzZW5kaW5nIGRhdGEuICBJ
IGRpZG4ndCBjaGVjayBjbG9zZWx5IGVub3VnaCB0byBzZWUgaWYgdGhlIHBlZXIgc2lkZSB0aG91
Z2h0IGl0IHJlY2VpdmVkIGl0Lg0KPiANCj4gV2UgYXJlIGdvaW5nIHRvIHRyeSB0byByZXByb2R1
Y2Ugdy9vdXQgd2lmaSwgYnV0IG5vdCBzdXJlIHdlJ2xsIGhhdmUgYW55IGx1Y2sgd2l0aCB0aGF0
Lg0KPiBXZSBkaWQgdGVzdCB3L291dCBWUkYgKHVzaW5nIGxvdHMgb2YgaXAgcnVsZXMgaW5zdGVh
ZCksIGFuZCBzaW1pbGFyIHByb2JsZW0gd2FzIHNlZW4gYWNjb3JkaW5nIHRvIG15DQo+IHRlc3Qg
dGVhbSAoSSBkaWQgbm90IGRlYnVnIGl0IGluIGRldGFpbCkuDQo+IA0KPiBEbyB5b3UgaGF2ZSBh
bnkgc3VnZ2VzdGlvbnMgZm9yIGhvdyB0byBkZWJ1ZyB0aGlzIGZ1cnRoZXI/ICBJIGFtIGhhcHB5
IHRvIGhhY2sgc3R1ZmYgaW50byB0aGUNCj4ga2VybmVsIGlmIHlvdSBoYXZlIHNvbWUgc3VnZ2Vz
dGVkIHBsYWNlcyB0byBhZGQgZGVidWdnaW5nLi4uDQoNClNvdW5kcyBsaWtlIGFsbCB0cmFuc21p
dCB0cmFmZmljIG9uIHRoZSBsb29wYmFjayBpbnRlcmZhY2UgaXMgYmVpbmcgZGlzY2FyZGVkDQpi
ZWZvcmUgdGhlIHBvaW50IHdoZXJlIHRoZSBmcmFtZXMgZ2V0IGZlZCB0byB0c21kdW1wLg0KDQpQ
b3NzaWJseSB5b3UgY291bGQgdXNlIGZ0cmFjZSB0byB0cmFjZSBmdW5jdGlvbiBlbnRyeStleGl0
IG9mIGEgZmV3DQpmdW5jdGlvbnMgdGhhdCBoYXBwZW4gaW4gdGhlIHRyYW5zbWl0IHBhdGggYW5k
IHRoZW4gaXNvbGF0ZSB0aGUgcG9pbnQNCndoZXJlIHRoZSBkaXNjYXJkIGlzIGhhcHBlbmluZy4N
CllvdSBjYW4ndCBhZmZvcmQgdG8gdHJhY2UgZXZlcnl0aGluZyAtIHNsb3dzIHRoaW5ncyBkb3du
IHRvbyBtdWNoLg0KQnV0IGEgZmV3IHRyYWNlcyBvbiBlYWNoIHNlbmQgcGF0aCBzaG91bGQgYmUg
b2suDQoNCglEYXZpZA0KDQotDQpSZWdpc3RlcmVkIEFkZHJlc3MgTGFrZXNpZGUsIEJyYW1sZXkg
Um9hZCwgTW91bnQgRmFybSwgTWlsdG9uIEtleW5lcywgTUsxIDFQVCwgVUsNClJlZ2lzdHJhdGlv
biBObzogMTM5NzM4NiAoV2FsZXMpDQo=

