Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 763C217732F
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 10:56:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728120AbgCCJ4b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 04:56:31 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:47124 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726694AbgCCJ4b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 04:56:31 -0500
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-124-r196nmnXMPS1lIwO7vRUpQ-1; Tue, 03 Mar 2020 09:56:28 +0000
X-MC-Unique: r196nmnXMPS1lIwO7vRUpQ-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Tue, 3 Mar 2020 09:56:27 +0000
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Tue, 3 Mar 2020 09:56:27 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Yadu Kishore' <kyk.segfault@gmail.com>
CC:     David Miller <davem@davemloft.net>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Network Development <netdev@vger.kernel.org>
Subject: RE: [PATCH v2] net: Make skb_segment not to compute checksum if
 network controller supports checksumming
Thread-Topic: [PATCH v2] net: Make skb_segment not to compute checksum if
 network controller supports checksumming
Thread-Index: AQHV8G6boeAUqLyQLkCRyXn9e/JzBKg1V/WQgAE/qgCAAAaz0A==
Date:   Tue, 3 Mar 2020 09:56:27 +0000
Message-ID: <de1012794ec54314b6fe790c01dee60b@AcuMS.aculab.com>
References: <20200228.120150.302053489768447737.davem@davemloft.net>
 <1583131910-29260-1-git-send-email-kyk.segfault@gmail.com>
 <CABGOaVRdsw=4nqBMR0h8JPEiunOEpHR+02H=HRbgt_TxhVviiA@mail.gmail.com>
 <945f6cafc86b4f1bb18fa40e60d5c113@AcuMS.aculab.com>
 <CABGOaVQMq-AxwQOJ5DdDY6yLBOXqBg6G7qC_MdOYj_z4y-QQiw@mail.gmail.com>
In-Reply-To: <CABGOaVQMq-AxwQOJ5DdDY6yLBOXqBg6G7qC_MdOYj_z4y-QQiw@mail.gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogWWFkdSBLaXNob3JlDQo+IFNlbnQ6IDAzIE1hcmNoIDIwMjAgMDk6MTUNCi4uLg0KPiBU
aGUgcGVyZiBkYXRhIEkgcHJlc2VudGVkIHdhcyBjb2xsZWN0ZWQgb24gYW4gYXJtNjQgcGxhdGZv
cm0gKGhpa2V5OTYwKSB3aGVyZQ0KPiB0aGUgZG9fY3N1bSBpbXBsZW1lbnRhdGlvbiB0aGF0IGlz
IGNhbGxlZCBpcyBub3QgaW4gYXNzZW1ibHkgYnV0IGluIEMNCj4gKGxpYi9jaGVja3N1bS5jKQ0K
DQpJdCBpcyBhIGxvbmcgdGltZSBzaW5jZSBJJ3ZlIHdyaXR0ZW4gYW55IGFybSBhc3NlbWJsZXIs
IGJ1dCBhbg0KYXNtIGNoZWNrc3VtIGxvb3Agb3VnaHQgdG8gYmUgZmFzdGVyIHRoYW4gYSBDIG9u
ZSBiZWNhdXNlIHVzaW5nDQonYWRkIHdpdGggY2FycnknIG91Z2h0IHRvIGJlIGEgZ2Fpbi4NCihV
bmxpa2UgbWlwcyBzdHlsZSBpbnN0cnVjdGlvbiBzZXRzIHdpdGhvdXQgYSBjYXJyeSBmbGFnLikN
Cg0KSG93ZXZlciB3aGF0IGl0IG1vcmUgaW50ZXJlc3RpbmcgaXMgdGhhdCBkb19jc3VtKCkgaXMg
YmVpbmcNCmNhbGxlZCBhdCBhbGwuDQpJdCBpbXBsaWVzIHRoYXQgYSBsYXJnZSBkYXRhIGJsb2Nr
IGlzIGJlaW5nIGNoZWNrc3VtbWVkICdpbiBzaXR1Jw0Kd2hlcmVhcyB0aGUgZXhwZWN0YXRpb24g
aXMgdGhhdCAnbGluZWFyaXNpbmcnIHRoZSBza2IgcmVxdWlyZXMNCmFsbCB0aGUgZGF0YSBiZSBj
b3BpZWQgLSBzbyB0aGUgY2hlY2tzdW0gd291bGQgYmUgZG9uZSBkdXJpbmcgdGhlDQpjb3B5Lg0K
DQpBZGRpdGlvbmFsbHkgdW5sZXNzIHRoZSBjb3B5IGxvb3AgaXMgJ2xvYWQgKyBzdG9yZScgYW5k
DQonbG9hZCArIHN0b3JlICsgYWRjJyBjYW4gYmUgZXhlY3V0ZWQgaW4gdGhlIHNhbWUgbnVtYmVy
IG9mDQpjbG9ja3MgKHdpdGhvdXQgZXhjZXNzaXZlIGxvb3AgdW5yb2xsaW5nKSB0aGVuIGRvaW5n
IHRoZQ0KY2hlY2tzdW0gaW4gdGhlIGNvcHkgbG9vcCBpc24ndCAnZnJlZScuDQoNCkZvciB4ODYg
KGluY2x1ZGluZyBvbGQgaW50ZWwgY3B1IHdoZXJlIGFkYyBpcyAyIGNsb2NrcykNCnRoZSAnY2hl
Y2tzdW0gaW4gY29weScgaXNuJ3QgZnJlZS4NCg0KQ2xlYXJseSwgaWYgeW91IGhhdmUgdG8gZG8g
YSBjb3B5IGFuZCBhIHNvZnR3YXJlIGNoZWNrc3VtDQppdCBpcyB2ZXJ5IGxpa2VseSB0aGF0IGRv
aW5nIHRoZW0gdG9nZXRoZXIgaXMgZmFzdGVyLg0KKEFsdGhvdWdoIGEgZmFzdCAncmVwIG1vdnMn
IGNvcHkgYW5kIGFuIGFkW2NvXXggKG9yIEFWWDI/KQ0KY2hlY2tzdW0gbWF5IGJlIGZhc3RlciBv
biB2ZXJ5IHJlY2VudCBJbnRlbCBjcHUgZm9yIGxhcmdlDQplbm91Z2ggYnVmZmVycy4pDQoNCglE
YXZpZA0KDQotDQpSZWdpc3RlcmVkIEFkZHJlc3MgTGFrZXNpZGUsIEJyYW1sZXkgUm9hZCwgTW91
bnQgRmFybSwgTWlsdG9uIEtleW5lcywgTUsxIDFQVCwgVUsNClJlZ2lzdHJhdGlvbiBObzogMTM5
NzM4NiAoV2FsZXMpDQo=

