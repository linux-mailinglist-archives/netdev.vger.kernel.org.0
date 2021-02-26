Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1159326439
	for <lists+netdev@lfdr.de>; Fri, 26 Feb 2021 15:42:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229864AbhBZOlT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Feb 2021 09:41:19 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.86.151]:24027 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229566AbhBZOlS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Feb 2021 09:41:18 -0500
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-279-6sUSVgtyNdiCFv7gHV1jqA-1; Fri, 26 Feb 2021 14:39:38 +0000
X-MC-Unique: 6sUSVgtyNdiCFv7gHV1jqA-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Fri, 26 Feb 2021 14:39:36 +0000
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Fri, 26 Feb 2021 14:39:36 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Neal Cardwell' <ncardwell@google.com>,
        Gil Pedersen <kanongil@gmail.com>
CC:     David Miller <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        "dsahern@kernel.org" <dsahern@kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Yuchung Cheng <ycheng@google.com>,
        Eric Dumazet <edumazet@google.com>
Subject: RE: TCP stall issue
Thread-Topic: TCP stall issue
Thread-Index: AQHXC4gOpWzl1nMmJU+SqvkFX667eKpqgEEg
Date:   Fri, 26 Feb 2021 14:39:36 +0000
Message-ID: <d5b6a39496db4a4aa5ceb770485dd47c@AcuMS.aculab.com>
References: <35A4DDAA-7E8D-43CB-A1F5-D1E46A4ED42E@gmail.com>
 <CADVnQy=G=GU1USyEcGA_faJg5L-wLO6jS4EUocrVsjqkaGbvYw@mail.gmail.com>
 <C5332AE4-DFAF-4127-91D1-A9108877507A@gmail.com>
 <CADVnQynP40vvvTV3VY0fvYwEcSGQ=Y=F53FU8sEc-Bc=mzij5g@mail.gmail.com>
 <93A31D2F-1CDE-4042-9D00-A7E1E49A99A9@gmail.com>
 <CADVnQyn5jrkPC7HJAkMOFN-FBZjwtCw8ns-3Yx7q=-S57PdC6w@mail.gmail.com>
In-Reply-To: <CADVnQyn5jrkPC7HJAkMOFN-FBZjwtCw8ns-3Yx7q=-S57PdC6w@mail.gmail.com>
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

U29tZSB0aG91Z2h0cy4uLg0KDQpEb2VzIGEgbm9uLWFuZHJvaWQgbGludXggc3lzdGVtIGJlaGF2
ZSBjb3JyZWN0bHkgdGhyb3VnaCB0aGUgc2FtZSBOQVQgZ2F0ZXdheXM/DQpQYXJ0aWN1bGFybHkg
d2l0aCBhIHNpbWlsYXIga2VybmVsIHZlcnNpb24uDQoNCklmIHlvdSBoYXZlIGEgVVNCIE9URyBj
YWJsZSBhbmQgVVNCIGV0aGVybmV0IGRvbmdsZSB5b3UgbWF5IGJlIGFibGUgdG8gZ2V0DQphbmRy
b2lkIHRvIHVzZSBhIHdpcmVkIGV0aGVybmV0IGNvbm5lY3Rpb24gLSBleGNsdWRpbmcgYW55IFdp
RmkgaXNzdWVzLg0KKE9URyB1c3VhbGx5IHdvcmtzIGZvciBrZXlib2FyZCBhbmQgbW91c2UsIGR1
bm5vIGlmIGV0aGVybmV0IHN1cHBvcnQgaXMgdGhlcmUuKQ0KDQpEb2VzIHlvdSBhbmRyb2lkIGRl
dmljZSB3b3JrIG9uIGFueSBvdGhlciBuZXR3b3Jrcz8NCg0KCURhdmlkDQoNCi0NClJlZ2lzdGVy
ZWQgQWRkcmVzcyBMYWtlc2lkZSwgQnJhbWxleSBSb2FkLCBNb3VudCBGYXJtLCBNaWx0b24gS2V5
bmVzLCBNSzEgMVBULCBVSw0KUmVnaXN0cmF0aW9uIE5vOiAxMzk3Mzg2IChXYWxlcykNCg==

