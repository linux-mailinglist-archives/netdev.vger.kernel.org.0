Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55B9F10B476
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 18:30:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727128AbfK0RaI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Nov 2019 12:30:08 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([146.101.78.151]:58969 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726603AbfK0RaH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Nov 2019 12:30:07 -0500
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-47-A5DwBc6ONnWiCrmrs4twXQ-1; Wed, 27 Nov 2019 17:30:01 +0000
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Wed, 27 Nov 2019 17:30:00 +0000
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Wed, 27 Nov 2019 17:30:00 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Paolo Abeni' <pabeni@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>
CC:     'Marek Majkowski' <marek@cloudflare.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        network dev <netdev@vger.kernel.org>,
        kernel-team <kernel-team@cloudflare.com>
Subject: RE: epoll_wait() performance
Thread-Topic: epoll_wait() performance
Thread-Index: AdWgk3jgEIFNwcnRS6+4A+/jFPxTuQEdLCCAAAAn2qAADa2dEAAA53Bg
Date:   Wed, 27 Nov 2019 17:30:00 +0000
Message-ID: <2f1635d9300a4bec8a0422e9e9518751@AcuMS.aculab.com>
References: <bc84e68c0980466096b0d2f6aec95747@AcuMS.aculab.com>
         <CAJPywTJYDxGQtDWLferh8ObjGp3JsvOn1om1dCiTOtY6S3qyVg@mail.gmail.com>
         <5f4028c48a1a4673bd3b38728e8ade07@AcuMS.aculab.com>
         <20191127164821.1c41deff@carbon>
 <0b8d7447e129539aec559fa797c07047f5a6a1b2.camel@redhat.com>
In-Reply-To: <0b8d7447e129539aec559fa797c07047f5a6a1b2.camel@redhat.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-MC-Unique: A5DwBc6ONnWiCrmrs4twXQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogUGFvbG8gQWJlbmkNCj4gU2VudDogMjcgTm92ZW1iZXIgMjAxOSAxNjoyNw0KLi4uDQo+
IEBEYXZpZDogSWYgSSByZWFkIHlvdXIgbWVzc2FnZSBjb3JyZWN0bHksIHRoZSBwa3QgcmF0ZSB5
b3UgYXJlIGRlYWxpbmcNCj4gd2l0aCBpcyBxdWl0ZSBsb3cuLi4gYXJlIHdlIHRhbGtpbmcgYWJv
dXQgdHB1dCBvciBsYXRlbmN5PyBJIGd1ZXNzDQo+IGxhdGVuY3kgY291bGQgYmUgbWVhc3VyYWJs
eSBoaWdoZXIgd2l0aCByZWN2bW1zZygpIGluIHJlc3BlY3QgdG8gb3RoZXINCj4gc3lzY2FsbC4g
SG93IGRvIHlvdSBtZWFzdXJlIHRoZSByZWxlYXRpdmUgcGVyZm9ybWFuY2VzIG9mIHJlY3ZtbXNn
KCkNCj4gYW5kIHJlY3YoKSA/IHdpdGggbWljcm8tYmVuY2htYXJrL3JkdHNjKCk/IEFtIEkgcmln
aHQgdGhhdCB5b3UgYXJlDQo+IHVzdWFsbHkgZ2V0dGluZyBhIHNpbmdsZSBwYWNrZXQgcGVyIHJl
Y3ZtbXNnKCkgY2FsbD8NCg0KVGhlIHBhY2tldCByYXRlIHBlciBzb2NrZXQgaXMgbG93LCB0eXBp
Y2FsbHkgb25lIHBhY2tldCBldmVyeSAyMG1zLg0KVGhpcyBpcyBSVFAsIHNvIHRlbGVwaG9ueSBh
dWRpby4NCkhvd2V2ZXIgd2UgaGF2ZSBhIGxvdCBvZiBhdWRpbyBjaGFubmVscyBhbmQgaGVuY2Ug
YSBsb3Qgb2Ygc29ja2V0cy4NClNvIHRoZXJlIGFyZSBjYW4gYmUgMTAwMHMgb2Ygc29ja2V0cyB3
ZSBuZWVkIHRvIHJlY2VpdmUgdGhlIGRhdGEgZnJvbS4NClRoZSB0ZXN0IHN5c3RlbSBJJ20gdXNp
bmcgaGFzIDE2IEUxIFRETSBsaW5rcyBlYWNoIG9mIHdoaWNoIGNhbiBoYW5kbGUNCjMxIGF1ZGlv
IGNoYW5uZWxzLg0KRm9yd2FyZGluZyBhbGwgdGhlc2UgdG8vZnJvbSBSVFAgKG9uZSBvZiB0aGUg
dGhpbmdzIGl0IG1pZ2h0IGRvKSBpcyA0OTYNCmF1ZGlvIGNoYW5uZWxzIC0gc28gNDk2IFJUUCBz
b2NrZXRzIGFuZCA0OTYgUlRDUCBvbmVzLg0KQWx0aG91Z2ggdGhlIHRlc3QgSSdtIGRvaW5nIGlz
IHB1cmUgUlRQIGFuZCBkb2Vzbid0IHVzZSBURE0uDQoNCldoYXQgSSdtIG1lYXN1cmluZyBpcyB0
aGUgdG90YWwgdGltZSB0YWtlbiB0byByZWNlaXZlIGFsbCB0aGUgcGFja2V0cw0KKG9uIGFsbCB0
aGUgc29ja2V0cykgdGhhdCBhcmUgYXZhaWxhYmxlIHRvIGJlIHJlYWQgZXZlcnkgMTBtcy4NClNv
IHBvbGwgKyByZWN2ICsgYWRkX3RvX3F1ZXVlLg0KKFRoZSBkYXRhIHByb2Nlc3NpbmcgaXMgZG9u
ZSBieSBvdGhlciB0aHJlYWRzLikNCkkgdXNlIHRoZSB0aW1lIGRpZmZlcmVuY2UgKGFjdHVhbGx5
IENMT0NLX01PTk9UT05JQyAtIGZyb20gcmR0c2MpDQp0byBnZW5lcmF0ZSBhIDY0IGVudHJ5IChz
ZWxmIHNjYWxpbmcpIGhpc3RvZ3JhbSBvZiB0aGUgZWxhcHNlZCB0aW1lcy4NClRoZW4gbG9vayBm
b3IgdGhlIGhpc3RvZ3JhbXMgcGVhayB2YWx1ZS4NCihJIG5lZWQgdG8gd29yayBvbiB0aGUgbWF4
IHZhbHVlLCBidXQgdGhhdCBpcyBhIGRpZmZlcmVudCAobW9yZSBpbXBvcnRhbnQhKSBwcm9ibGVt
LikNCkRlcGVuZGluZyBvbiB0aGUgcG9sbC9yZWN2IG1ldGhvZCB1c2VkIHRoaXMgdGFrZXMgMS41
IHRvIDJtcw0KaW4gZWFjaCAxMG1zIHBlcmlvZC4NCihJdCBpcyBmYXN0ZXIgaWYgSSBydW4gdGhl
IGNwdSBhdCBmdWxsIHNwZWVkLCBidXQgaXQgdXN1YWxseSBpZGxlcyBhbG9uZw0KYXQgODAwTUh6
LikNCg0KSWYgSSB1c2UgcmVjdm1tc2coKSBJIG9ubHkgZXhwZWN0IHRvIHNlZSBvbmUgcGFja2V0
IGJlY2F1c2UgdGhlcmUNCmlzIChhbG1vc3QgYWx3YXlzKSBvbmx5IG9uZSBwYWNrZXQgb24gZWFj
aCBzb2NrZXQgZXZlcnkgMjBtcy4NCkhvd2V2ZXIgdGhlcmUgbWlnaHQgYmUgbW9yZSB0aGFuIG9u
ZSwgYW5kIGlmIHRoZXJlIGlzIHRoZXkNCmFsbCBuZWVkIHRvIGJlIHJlYWQgKHdlbGwgYXQgbGVh
c3QgMiBvZiB0aGVtKSBpbiB0aGF0IGJsb2NrIG9mIHJlY2VpdmVzLg0KDQpUaGUgb3V0Ym91bmQg
dHJhZmZpYyBnb2VzIG91dCB0aHJvdWdoIGEgc21hbGwgbnVtYmVyIG9mIHJhdyBzb2NrZXRzLg0K
QW5ub3lpbmdseSB3ZSBoYXZlIHRvIHdvcmsgb3V0IHRoZSBsb2NhbCBJUHY0IGFkZHJlc3MgdGhh
dCB3aWxsIGJlIHVzZWQNCmZvciBlYWNoIGRlc3RpbmF0aW9uIGluIG9yZGVyIHRvIGNhbGN1bGF0
ZSB0aGUgVURQIGNoZWNrc3VtLg0KKEkndmUgYSBwZW5kaW5nIHBhdGNoIHRvIHNwZWVkIHVwIHRo
ZSB4ODYgY2hlY2tzdW0gY29kZSBvbiBhIGxvdCBvZg0KY3B1cy4pDQoNCglEYXZpZA0KDQotDQpS
ZWdpc3RlcmVkIEFkZHJlc3MgTGFrZXNpZGUsIEJyYW1sZXkgUm9hZCwgTW91bnQgRmFybSwgTWls
dG9uIEtleW5lcywgTUsxIDFQVCwgVUsNClJlZ2lzdHJhdGlvbiBObzogMTM5NzM4NiAoV2FsZXMp
DQo=

