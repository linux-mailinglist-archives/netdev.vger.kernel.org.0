Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 888073958C7
	for <lists+netdev@lfdr.de>; Mon, 31 May 2021 12:13:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231177AbhEaKOy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 May 2021 06:14:54 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.85.151]:30046 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230521AbhEaKOx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 May 2021 06:14:53 -0400
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-146-fliy-LFpOQ6W43NwjWtg3w-1; Mon, 31 May 2021 11:13:09 +0100
X-MC-Unique: fliy-LFpOQ6W43NwjWtg3w-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.2; Mon, 31 May 2021 11:13:07 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.015; Mon, 31 May 2021 11:13:07 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'David Ahern' <dsahern@gmail.com>, Xin Long <lucien.xin@gmail.com>,
        "Jakub Kicinski" <kuba@kernel.org>
CC:     network dev <netdev@vger.kernel.org>, davem <davem@davemloft.net>,
        "Eric Dumazet" <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>
Subject: RE: [PATCH net] udp: fix the len check in udp_lib_getsockopt
Thread-Topic: [PATCH net] udp: fix the len check in udp_lib_getsockopt
Thread-Index: AQHXVC4NfGcrFbjRIUWrfZBtSgA3Rar9YS+Q
Date:   Mon, 31 May 2021 10:13:07 +0000
Message-ID: <dc7d16bce9114bce8292ad07835fc083@AcuMS.aculab.com>
References: <04cb0c7f6884224c99fbf656579250896af82d5b.1622142759.git.lucien.xin@gmail.com>
 <CADvbK_e0PkKBYAUyg6iYyUwUp+owpv1r9_cnS7pbkLSjwX+VWg@mail.gmail.com>
 <20210528153911.4f67a691@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <CADvbK_dvj2ywH5nQGcsjAWOKb5hdLfoVnjKNmLsstk3R1j7MyA@mail.gmail.com>
 <54cb4e46-28f9-b6db-85ec-f67df1e6bacf@gmail.com>
In-Reply-To: <54cb4e46-28f9-b6db-85ec-f67df1e6bacf@gmail.com>
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

RnJvbTogRGF2aWQgQWhlcm4NCj4gU2VudDogMjkgTWF5IDIwMjEgMDI6NTgNCj4gDQo+IE9uIDUv
MjgvMjEgNzo0NyBQTSwgWGluIExvbmcgd3JvdGU6DQo+ID4gVGhlIHBhcnRpYWwgYnl0ZShvciBl
dmVuIDApIG9mIHRoZSB2YWx1ZSByZXR1cm5lZCBkdWUgdG8gcGFzc2luZyBhIHdyb25nDQo+ID4g
b3B0bGVuIHNob3VsZCBiZSBjb25zaWRlcmVkIGFzIGFuIGVycm9yLiAiT24gZXJyb3IsIC0xIGlz
IHJldHVybmVkLCBhbmQNCj4gPiBlcnJubyBpcyBzZXQgYXBwcm9wcmlhdGVseS4iLiBTdWNjZXNz
IHJldHVybmVkIGluIHRoYXQgY2FzZSBvbmx5IGNvbmZ1c2VzDQo+ID4gdGhlIHVzZXIuDQo+IA0K
PiBJdCBpcyBmZWFzaWJsZSB0aGF0IHNvbWUgYXBwIGNvdWxkIHVzZSBib29sIG9yIHU4IGZvciBv
cHRpb25zIHRoYXQgaGF2ZQ0KPiAwIG9yIDEgdmFsdWVzIGFuZCB0aGF0IGNvZGUgaGFzIHNvIGZh
ciB3b3JrZWQuIFRoaXMgY2hhbmdlIHdvdWxkIGJyZWFrIHRoYXQuDQoNCkVzcGVjaWFsbHkgc2lu
Y2UgdGhlIGNvZGUgaXMgYWxzbyBsaWtlbHkgdG8gaWdub3JlIHRoZSByZXR1cm4NCnZhbHVlIHNp
bmNlIHRoZSBjYWxsIGlzbid0IGV4Y2VwdGVkIHRvIGFjdHVhbGx5IGZhaWwhDQoNCk1vc3QgKGJ1
dCBub3QgYWxsKSBBQkkgaGF2ZSAnYm9vbCcgZGVmaW5lZCB0aGUgc2FtZSBhcyAndTMyJy4NCkhv
d2V2ZXIgdGhlcmUgd2lsbCBiZSBjb2RlIHRoYXQgdXNlcyAnY2hhcicgKGVzcGVjaWFsbHkgZm9y
DQpzZXRzb2Nrb3B0KSBhbmQgZXhwZWN0cyBpdCB0byB3b3JrLg0KKEFuZCBpdCBwcm9iYWJseSBh
bHdheXMgaGFzIGRvbmUgb24gTEUgc3lzdGVtcy4pDQoNCkEgY2VydGFpbiBvdGhlciBjb21tb24g
T1MgZGVmaW5lcyB0aGUgYXJndW1lbnQgYXMgZWl0aGVyIEJPT0wNCm9yIERXT1JEIC0gYm90aCBv
ZiB3aGljaCBhcmUgMzJiaXQuDQpCdXQgSSBiZWxpZXZlIGl0IHdvcmtzIGZpbmUgaWYgJ2NoYXIn
IGlzIHVzZWQuDQoNCglEYXZpZA0KDQotDQpSZWdpc3RlcmVkIEFkZHJlc3MgTGFrZXNpZGUsIEJy
YW1sZXkgUm9hZCwgTW91bnQgRmFybSwgTWlsdG9uIEtleW5lcywgTUsxIDFQVCwgVUsNClJlZ2lz
dHJhdGlvbiBObzogMTM5NzM4NiAoV2FsZXMpDQo=

