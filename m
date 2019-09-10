Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A3B4AEEA4
	for <lists+netdev@lfdr.de>; Tue, 10 Sep 2019 17:38:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393966AbfIJPib (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Sep 2019 11:38:31 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([146.101.78.151]:26923 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730875AbfIJPia (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Sep 2019 11:38:30 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-165-ivUePp4GPIuX29LloUIPJQ-1; Tue, 10 Sep 2019 16:38:28 +0100
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Tue, 10 Sep 2019 16:38:27 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Tue, 10 Sep 2019 16:38:27 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Arnd Bergmann' <arnd@arndb.de>,
        Saeed Mahameed <saeedm@mellanox.com>
CC:     "cai@lca.pw" <cai@lca.pw>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Moshe Shemesh <moshe@mellanox.com>,
        Feras Daoud <ferasda@mellanox.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Eran Ben Elisha" <eranbe@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "leon@kernel.org" <leon@kernel.org>,
        Erez Shitrit <erezsh@mellanox.com>
Subject: RE: [PATCH] net/mlx5: reduce stack usage in FW tracer
Thread-Topic: [PATCH] net/mlx5: reduce stack usage in FW tracer
Thread-Index: AQHVZ6/gotndlflYLEiLmwBbeCyLo6clCo3w
Date:   Tue, 10 Sep 2019 15:38:27 +0000
Message-ID: <d50f78334e64476bad033862035c734c@AcuMS.aculab.com>
References: <20190906151123.1088455-1-arnd@arndb.de>
 <383db08b6001503ac45c2e12ac514208dc5a4bba.camel@mellanox.com>
 <CAK8P3a0_VhZ9hYmc6P3Qx+Z6WSHh3PVZ7JZh7Tr=R1CAKvqWmA@mail.gmail.com>
 <5abccf6452a9d4efa2a1593c0af6d41703d4f16f.camel@mellanox.com>
 <CAK8P3a3q4NqiU-OydMqU3J=gT-8eBmsiL5tPsyJb1PNgR+48hA@mail.gmail.com>
In-Reply-To: <CAK8P3a3q4NqiU-OydMqU3J=gT-8eBmsiL5tPsyJb1PNgR+48hA@mail.gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-MC-Unique: ivUePp4GPIuX29LloUIPJQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogQXJuZCBCZXJnbWFubg0KPiBTZW50OiAxMCBTZXB0ZW1iZXIgMjAxOSAwOToxNQ0KLi4u
DQo+ID4gSSBhbSBub3Qgc3VyZSBob3cgdGhpcyB3b3VsZCB3b3JrLCBzaW5jZSB0aGUgZm9ybWF0
IHBhcmFtZXRlcnMgY2FuDQo+ID4gY2hhbmdlcyBkZXBlbmRpbmcgb24gdGhlIEZXIHN0cmluZyBh
bmQgdGhlIHNwZWNpZmljIHRyYWNlcy4NCj4gDQo+IEFoLCBzbyB0aGUgZm9ybWF0IHN0cmluZyBj
b21lcyBmcm9tIHRoZSBmaXJtd2FyZT8gSSBkaWRuJ3QgbG9vaw0KPiBhdCB0aGUgY29kZSBpbiBl
bm91Z2ggZGV0YWlsIHRvIHVuZGVyc3RhbmQgd2h5IGl0J3MgZG9uZSBsaWtlIHRoaXMsDQo+IG9u
bHkgZW5vdWdoIHRvIG5vdGljZSB0aGF0IGl0J3MgcmF0aGVyIHVudXN1YWwuDQoNCklmIHRoZSBm
b3JtYXQgc3RyaW5nIGNvbWVzIGZyb20gdGhlIGZpcm13YXJlIHlvdSByZWFsbHkgc2hvdWxkbid0
DQpwYXNzIGl0IHRvIGFueSBzdGFuZGFyZCBwcmludGYgZnVuY3Rpb24uDQpZb3UgbXVzdCBlbnN1
cmUgdGhhdCBpdCBkb2Vzbid0IGNvbnRhaW4gYW55IGZvcm1hdCBlZmZlY3RvcnMNCnRoYXQgbWln
aHQgZGVyZWZlcmVuY2UgcGFyYW1ldGVycy4NCihUaGUgY29kZSBtaWdodCB0cnkgdG8gZG8gdGhh
dC4pDQoNCkdpdmVuIHRoYXQgJ3BvaW50ZXInIGZvcm1hdCBlZmZlY3RvcnMgY2FuJ3QgYmUgdXNl
ZCwgdGhlIGZpcm13YXJlDQptdXN0IGFsc28gc3VwcGx5IHRoZSByZWxldmFudCBpbnRlZ2VyIG9u
ZXM/DQpUaGlzIHNob3VsZCBtZWFuIHRoYXQgYWxsIHRoZSBwcm9jZXNzaW5nIGlzIGRlZmVycmFi
bGUgdW50aWwgdGhlDQp0cmFjZSByZWNvcmQgaXMgcmVhZC4NCg0KJ25vaW5saW5lJyBqdXN0IHBh
cGVycyBvdmVyIHRoZSBjcmFja3MuDQpFc3BlY2lhbGx5IHNpbmNlIHZhc3ByaW50ZigpIGlzIGxp
a2VseSB0byB1c2UgYSBsb3Qgb2Ygc3RhY2suDQoNCglEYXZpZA0KDQotDQpSZWdpc3RlcmVkIEFk
ZHJlc3MgTGFrZXNpZGUsIEJyYW1sZXkgUm9hZCwgTW91bnQgRmFybSwgTWlsdG9uIEtleW5lcywg
TUsxIDFQVCwgVUsNClJlZ2lzdHJhdGlvbiBObzogMTM5NzM4NiAoV2FsZXMpDQo=

