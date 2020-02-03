Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9EDFC1509EB
	for <lists+netdev@lfdr.de>; Mon,  3 Feb 2020 16:40:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728147AbgBCPkJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Feb 2020 10:40:09 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([146.101.78.151]:60769 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726272AbgBCPkJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Feb 2020 10:40:09 -0500
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-183-INfOXLASNUmZXlA7243NPA-1; Mon, 03 Feb 2020 15:40:05 +0000
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Mon, 3 Feb 2020 15:40:04 +0000
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Mon, 3 Feb 2020 15:40:04 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Eric Dumazet' <eric.dumazet@gmail.com>,
        Neal Cardwell <ncardwell@google.com>
CC:     "sjpark@amazon.com" <sjpark@amazon.com>,
        Eric Dumazet <edumazet@google.com>,
        David Miller <davem@davemloft.net>,
        "shuah@kernel.org" <shuah@kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "sj38.park@gmail.com" <sj38.park@gmail.com>,
        "aams@amazon.com" <aams@amazon.com>,
        SeongJae Park <sjpark@amazon.de>,
        Yuchung Cheng <ycheng@google.com>
Subject: RE: [PATCH 2/3] tcp: Reduce SYN resend delay if a suspicous ACK is
 received
Thread-Topic: [PATCH 2/3] tcp: Reduce SYN resend delay if a suspicous ACK is
 received
Thread-Index: AQHV2IlPJWOIosB7x0WML/igObqFf6gJnv4A
Date:   Mon, 3 Feb 2020 15:40:04 +0000
Message-ID: <5a8c1658de8f49b2994d19d371c13c79@AcuMS.aculab.com>
References: <20200131122421.23286-1-sjpark@amazon.com>
 <20200131122421.23286-3-sjpark@amazon.com>
 <CADVnQyk9xevY0kA9Sm9S9MOBNvcuiY+7YGBtGuoue+r+eizyOA@mail.gmail.com>
 <dd146bac-4e8a-4119-2d2b-ce6bf2daf7ce@gmail.com>
 <CADVnQy=Z0YRPY_0bxBpsZvECgamigESNKx6_-meNW5-6_N4kww@mail.gmail.com>
 <7d36a817-5519-8496-17cf-00eda5ed4ec7@gmail.com>
In-Reply-To: <7d36a817-5519-8496-17cf-00eda5ed4ec7@gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-MC-Unique: INfOXLASNUmZXlA7243NPA-1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogRXJpYyBEdW1hemV0DQo+IFNlbnQ6IDMxIEphbnVhcnkgMjAyMCAyMjo1NA0KPiBPbiAx
LzMxLzIwIDI6MTEgUE0sIE5lYWwgQ2FyZHdlbGwgd3JvdGU6DQo+IA0KPiA+IEkgbG9va2VkIGlu
dG8gZml4aW5nIHRoaXMsIGJ1dCBteSBxdWljayByZWFkaW5nIG9mIHRoZSBMaW51eA0KPiA+IHRj
cF9yY3Zfc3RhdGVfcHJvY2VzcygpIGNvZGUgaXMgdGhhdCBpdCBzaG91bGQgYmVoYXZlIGNvcnJl
Y3RseSBhbmQNCj4gPiB0aGF0IGEgY29ubmVjdGlvbiBpbiBGSU5fV0FJVF8xIHRoYXQgcmVjZWl2
ZXMgYSBGSU4vQUNLIHNob3VsZCBtb3ZlIHRvDQo+ID4gVElNRV9XQUlULg0KPiA+DQo+ID4gU2Vv
bmdKYWUsIGRvIHlvdSBoYXBwZW4gdG8gaGF2ZSBhIHRjcGR1bXAgdHJhY2Ugb2YgdGhlIHByb2Js
ZW1hdGljDQo+ID4gc2VxdWVuY2Ugd2hlcmUgdGhlICJwcm9jZXNzIEEiIGVuZHMgdXAgaW4gRklO
X1dBSVRfMiB3aGVuIGl0IHNob3VsZCBiZQ0KPiA+IGluIFRJTUVfV0FJVD8NCj4gPg0KPiA+IElm
IEkgaGF2ZSB0aW1lIEkgd2lsbCB0cnkgdG8gY29uc3RydWN0IGEgcGFja2V0ZHJpbGwgY2FzZSB0
byB2ZXJpZnkNCj4gPiB0aGUgYmVoYXZpb3IgaW4gdGhpcyBjYXNlLg0KPiANCj4gVW5mb3J0dW5h
dGVseSB5b3Ugd29udCBiZSBhYmxlIHRvIHJlcHJvZHVjZSB0aGUgaXNzdWUgd2l0aCBwYWNrZXRk
cmlsbCwNCj4gc2luY2UgaXQgaW52b2x2ZWQgcGFja2V0cyBiZWluZyBwcm9jZXNzZWQgYXQgdGhl
IHNhbWUgdGltZSAocmFjZSB3aW5kb3cpDQoNCllvdSBtaWdodCBiZSBhYmxlIHRvIGZvcmNlIHRo
ZSB0aW1pbmcgcmFjZSBieSBhZGRpbmcgYSBzbGVlcA0KaW4gb25lIG9mIHRoZSBjb2RlIHBhdGhz
Lg0KDQpObyBnb29kIGZvciBhIHJlZ3Jlc3Npb24gdGVzdCwgYnV0IG9rIGZvciBjb2RlIHRlc3Rp
bmcuDQoNCglEYXZpZA0KDQotDQpSZWdpc3RlcmVkIEFkZHJlc3MgTGFrZXNpZGUsIEJyYW1sZXkg
Um9hZCwgTW91bnQgRmFybSwgTWlsdG9uIEtleW5lcywgTUsxIDFQVCwgVUsNClJlZ2lzdHJhdGlv
biBObzogMTM5NzM4NiAoV2FsZXMpDQo=

