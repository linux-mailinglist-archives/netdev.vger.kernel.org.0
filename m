Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA98610CCC9
	for <lists+netdev@lfdr.de>; Thu, 28 Nov 2019 17:25:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726734AbfK1QZE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Nov 2019 11:25:04 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:38422 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726446AbfK1QZE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Nov 2019 11:25:04 -0500
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-234-9BIOC5miNL-BUa2iQ7QnXA-1; Thu, 28 Nov 2019 16:25:01 +0000
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Thu, 28 Nov 2019 16:25:00 +0000
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Thu, 28 Nov 2019 16:25:00 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Willem de Bruijn' <willemdebruijn.kernel@gmail.com>
CC:     Jesper Dangaard Brouer <brouer@redhat.com>,
        Marek Majkowski <marek@cloudflare.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "network dev" <netdev@vger.kernel.org>,
        kernel-team <kernel-team@cloudflare.com>,
        Paolo Abeni <pabeni@redhat.com>
Subject: RE: epoll_wait() performance
Thread-Topic: epoll_wait() performance
Thread-Index: AdWgk3jgEIFNwcnRS6+4A+/jFPxTuQEdLCCAAAAn2qAADFPagAAAV68AAAgIvgAAHmS7QA==
Date:   Thu, 28 Nov 2019 16:25:00 +0000
Message-ID: <a52b09fdfbbc44c8b398d7fbadfc5a9c@AcuMS.aculab.com>
References: <bc84e68c0980466096b0d2f6aec95747@AcuMS.aculab.com>
 <CAJPywTJYDxGQtDWLferh8ObjGp3JsvOn1om1dCiTOtY6S3qyVg@mail.gmail.com>
 <5f4028c48a1a4673bd3b38728e8ade07@AcuMS.aculab.com>
 <20191127164821.1c41deff@carbon>
 <5eecf41c7e124d7dbc0ab363d94b7d13@AcuMS.aculab.com>
 <CA+FuTSe8vfEME7EO6xru=i1++OWCNRJGePLNCzta+BVv_TY3Zw@mail.gmail.com>
In-Reply-To: <CA+FuTSe8vfEME7EO6xru=i1++OWCNRJGePLNCzta+BVv_TY3Zw@mail.gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-MC-Unique: 9BIOC5miNL-BUa2iQ7QnXA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogV2lsbGVtIGRlIEJydWlqbg0KPiBTZW50OiAyNyBOb3ZlbWJlciAyMDE5IDE5OjQ4DQou
Li4NCj4gQXJlIHRoZSBsYXRlc3QgbnVtYmVycyB3aXRoIENPTkZJR19IQVJERU5FRF9VU0VSQ09Q
WT8NCg0KQWNjb3JkaW5nIHRvIC9ib290L2NvbmZpZy1gdW5hbWUgLXJgIGl0IGlzIGVuYWJsZWQg
b24gbXkgc3lzdGVtLg0KSSBzdXNwZWN0IGl0IGhhcyBhIG1lYXN1cmFibGUgZWZmZWN0IG9uIHRo
ZXNlIHRlc3RzLg0KDQo+IEkgYXNzdW1lIHRoYXQgdGhlIHBvbGwoKSBhZnRlciByZWN2KCkgaXMg
bm9uLWJsb2NraW5nLiBJZiB1c2luZw0KPiByZWN2bXNnLCB0aGF0IGV4dHJhIHN5c2NhbGwgY291
bGQgYmUgYXZvaWRlZCBieSBpbXBsZW1lbnRpbmcgYSBjbXNnDQo+IGlucSBoaW50IGZvciB1ZHAg
c29ja2V0cyBhbmFsb2dvdXMgdG8gVENQX0NNX0lOUS90Y3BfaW5xX2hpbnQuDQoNCkFsbCB0aGUg
cG9sbCgpIGNhbGxzIGFyZSBub24tYmxvY2tpbmcuDQpUaGUgZmlyc3QgcG9sbCgpIGhhcyBhbGwg
dGhlIHNvY2tldHMgaW4gaXQuDQpUaGUgc2Vjb25kIHBvbGwoKSBvbmx5IHRob3NlIHRoYXQgcmV0
dXJuZWQgZGF0YSB0aGUgZmlyc3QgdGltZSBhcm91bmQuDQpUaGUgY29kZSB0aGVuIHNsZWVwcyBl
bHNld2hlcmUgZm9yIHRoZSByZXN0IG9mIHRoZSAxMG1zIGludGVydmFsLg0KKEFjdHVhbGx5IHRo
ZSBwb2xscyBhcmUgZG9uZSBpbiBibG9ja3Mgb2YgNjQsIGZpbGxpbmcgdXAgdGhlIHBmZFtdIGVh
Y2ggdGltZS4pDQoNClRoaXMgYXZvaWRzIHRoZSBwcm9ibGVtIG9mIHJlcGVhdGVkbHkgc2V0dGlu
ZyB1cCBhbmQgdGVhcmluZyBkb3duIHRoZQ0KcGVyLWZkIGRhdGEgZm9yIHBvbGwoKS4NCg0KPiBN
b3JlIG91dGxhbmRpc2ggd291bGQgYmUgdG8gYWJ1c2UgdGhlIG1tc2doZHItPm1zZ19sZW4gZmll
bGQgdG8gcGFzcw0KPiBmaWxlIGRlc2NyaXB0b3JzIGFuZCBhbW9ydGl6ZSB0aGUga2VybmVsIHBh
Z2UtdGFibGUgaXNvbGF0aW9uIGNvc3QNCj4gYWNyb3NzIHNvY2tldHMuIEJsb2NraW5nIHNlbWFu
dGljcyB3b3VsZCBiZSB3ZWlyZCwgZm9yIHN0YXJ0ZXJzLg0KDQpJdCB3b3VsZCBiZSBiZXR0ZXIg
dG8gYWxsb3cgYSBzaW5nbGUgVURQIHNvY2tldCBiZSBib3VuZCB0byBtdWx0aXBsZSBwb3J0cy4N
CkFuZCB0aGVuIHVzZSB0aGUgY21zZyBkYXRhIHRvIHNvcnQgb3V0IHRoZSBhY3R1YWwgZGVzdGlu
YXRpb24gcG9ydC4NCg0KCURhdmlkDQoNCi0NClJlZ2lzdGVyZWQgQWRkcmVzcyBMYWtlc2lkZSwg
QnJhbWxleSBSb2FkLCBNb3VudCBGYXJtLCBNaWx0b24gS2V5bmVzLCBNSzEgMVBULCBVSw0KUmVn
aXN0cmF0aW9uIE5vOiAxMzk3Mzg2IChXYWxlcykNCg==

