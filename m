Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76A303C71A0
	for <lists+netdev@lfdr.de>; Tue, 13 Jul 2021 15:58:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236750AbhGMOBW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Jul 2021 10:01:22 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.86.151]:41890 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236682AbhGMOBV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Jul 2021 10:01:21 -0400
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-285-sJWatQGHMAyOI0dV9jVZtg-1; Tue, 13 Jul 2021 14:58:28 +0100
X-MC-Unique: sJWatQGHMAyOI0dV9jVZtg-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.18; Tue, 13 Jul 2021 14:58:26 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.018; Tue, 13 Jul 2021 14:58:26 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Andy Shevchenko' <andy.shevchenko@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Brendan Higgins <brendanhiggins@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "Alexey Dobriyan" <adobriyan@gmail.com>,
        Miguel Ojeda <ojeda@kernel.org>,
        "Mauro Carvalho Chehab" <mchehab+huawei@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        KUnit Development <kunit-dev@googlegroups.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
        Waiman Long <longman@redhat.com>,
        Boqun Feng <boqun.feng@gmail.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Alexei Starovoitov" <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "Andrii Nakryiko" <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Thomas Graf <tgraf@suug.ch>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jonathan Cameron <jic23@kernel.org>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: RE: [PATCH v1 3/3] kernel.h: Split out container_of() and
 typeof_memeber() macros
Thread-Topic: [PATCH v1 3/3] kernel.h: Split out container_of() and
 typeof_memeber() macros
Thread-Index: AQHXd+UckMMEGGzpqkiHoJNy6jDReatA637g
Date:   Tue, 13 Jul 2021 13:58:25 +0000
Message-ID: <8a81e53ed3fb4f92878cd7f0d2552861@AcuMS.aculab.com>
References: <20210713084541.7958-1-andriy.shevchenko@linux.intel.com>
 <20210713084541.7958-3-andriy.shevchenko@linux.intel.com>
 <YO1s+rHEqC9RjMva@kroah.com> <YO12ARa3i1TprGnJ@smile.fi.intel.com>
 <YO13lSUdPfNGOnC3@kroah.com> <20210713121944.GA24157@gondor.apana.org.au>
 <CAHp75VfGd6VYyCjbqxO91B4RyyYuNQd_XKJA=yLMWJpa7-Yi9Q@mail.gmail.com>
In-Reply-To: <CAHp75VfGd6VYyCjbqxO91B4RyyYuNQd_XKJA=yLMWJpa7-Yi9Q@mail.gmail.com>
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

PiBUaGUgd2hvbGUgaWRlYSBjYW1lIHdoZW4gZGlzY3Vzc2luZyBkcml2ZXJzLCBlc3AuIElJTyBv
bmVzLiBUaGV5IG9mdGVuDQo+IGFyZSB1c2luZyBBUlJBWV9TSVpFKCkgKyBjb250YWluZXJfb2Yo
KS4ga2VybmVsLmggaXMgYSBiaWcgb3ZlcmtpbGwNCj4gdGhlcmUuDQoNCkl0IHByb2JhYmx5IG1h
a2VzIG5vIGRpZmZlcmVuY2UuDQpFdmVuIGFwcGFyZW50bHkgdHJpdmlhbCBpbmNsdWRlcyBwdWxs
IGluIG1vc3Qgb2YgdGhlIHdvcmxkLg0KDQpJIG1hbmFnZWQgdG8gZ2V0IGEgY29tcGlsZSBlcnJv
ciBmcm9tIG9uZSBvZiB0aGUgZGVmaW5lcw0KaW4gc3lzL2lvY3RsLmggLSB0aGUgaW5jbHVkZSBz
ZXF1ZW5jZSB0aGUgY29tcGlsZXIgZ2F2ZQ0KbWUgd2FzIGFib3V0IDIwIGRlZXAuDQpJJ3ZlIGZv
cmdvdHRlbiB3aGVyZSBpdCBzdGFydGVkLCBidXQgaXQgbWVhbmRlcmVkIHRocm91Z2gNCnNvbWUg
YXJjaC94ODYgZGlyZWN0b3JpZXMuDQoNCkkgc3VzcGVjdCB0aGF0IHNvbWUgZmlsZXMgaGF2ZSBh
ICNpbmNsdWRlIHdoZXJlIGp1c3QgYQ0KJ3N0cnVjdCBmb28nIHdvdWxkIHN1ZmZpY2UuDQoNClRo
ZXJlIHdpbGwgYWxzbyBiZSAuaCBmaWxlcyB3aGljaCBpbmNsdWRlIGJvdGggdGhlICdwdWJsaWMn
DQppbnRlcmZhY2UgYW5kICdwcml2YXRlJyBkZWZpbml0aW9ucy4NClNvbWV0aW1lcyBzcGxpdHRp
bmcgdGhvc2UgY2FuIHJlZHVjZSB0aGUgbnVtYmVyIG9mIGluY2x1ZGVzLg0KVGhpcyBpcyBtb3N0
IG5vdGljZWFibGUgY29tcGlsaW5nIHRyaXZpYWwgZHJpdmVycy4NCg0KVGhlIG90aGVyIHdheSB0
byBzcGVlZCB1cCBjb21waWxhdGlvbnMgaXMgdG8gcmVkdWNlIHRoZSAtSQ0KcGF0aCBsaXN0IHRv
IHRoZSBjb21waWxlci4NClRoaXMgaXMgcGFydGljdWxhcmx5IHNpZ25pZmljYW50IGlmIGNvbXBp
bGluZyBvdmVyIE5GUy4NCihXZWxsIE5GUyBtaWdodCBoYXZlIGNoYW5nZWQsIGJ1dC4uLikNCg0K
CURhdmlkDQoNCi0NClJlZ2lzdGVyZWQgQWRkcmVzcyBMYWtlc2lkZSwgQnJhbWxleSBSb2FkLCBN
b3VudCBGYXJtLCBNaWx0b24gS2V5bmVzLCBNSzEgMVBULCBVSw0KUmVnaXN0cmF0aW9uIE5vOiAx
Mzk3Mzg2IChXYWxlcykNCg==

