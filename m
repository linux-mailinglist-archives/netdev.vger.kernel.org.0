Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99B8F48695
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 17:08:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728362AbfFQPHG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 11:07:06 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([146.101.78.151]:50604 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727121AbfFQPHG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 11:07:06 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-73-7E6ddmnkOVuQR4rZ3FkrjQ-1; Mon, 17 Jun 2019 16:07:03 +0100
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b::d117) by AcuMS.aculab.com
 (fd9f:af1c:a25b::d117) with Microsoft SMTP Server (TLS) id 15.0.1347.2; Mon,
 17 Jun 2019 16:07:03 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Mon, 17 Jun 2019 16:07:03 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Josh Poimboeuf' <jpoimboe@redhat.com>
CC:     'Alexei Starovoitov' <alexei.starovoitov@gmail.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "Peter Zijlstra" <peterz@infradead.org>,
        Song Liu <songliubraving@fb.com>,
        "Kairui Song" <kasong@redhat.com>
Subject: RE: [PATCH 6/9] x86/bpf: Fix JIT frame pointer usage
Thread-Topic: [PATCH 6/9] x86/bpf: Fix JIT frame pointer usage
Thread-Index: AQHVIjMat8Fq1dO6sUKm4aXwvliIEKaa+NdggAAgcYCAABJOQIAAJoAAgASjjuA=
Date:   Mon, 17 Jun 2019 15:07:03 +0000
Message-ID: <a1942e57ed0844fab62b6bdf0f465578@AcuMS.aculab.com>
References: <cover.1560431531.git.jpoimboe@redhat.com>
 <03ddea21a533b7b0e471c1d73ebff19dacdcf7e3.1560431531.git.jpoimboe@redhat.com>
 <20190613215807.wjcop6eaadirz5xm@ast-mbp.dhcp.thefacebook.com>
 <57f6e69da6b3461a9c39d71aa1b58662@AcuMS.aculab.com>
 <20190614134401.q2wbh6mvo4nzmw2o@treble>
 <9b8aa912df694d25b581786100d3e2e2@AcuMS.aculab.com>
 <20190614170720.57yxtxvd4qee337l@treble>
In-Reply-To: <20190614170720.57yxtxvd4qee337l@treble>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-MC-Unique: 7E6ddmnkOVuQR4rZ3FkrjQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSm9zaCBQb2ltYm9ldWYNCj4gU2VudDogMTQgSnVuZSAyMDE5IDE4OjA3DQouLi4NCj4g
PiBJIGRvIHJlbWVtYmVyIGEgc3RhY2sgdHJhY2UgcHJpbnRlciBmb3IgeDg2IHRoaXMgZGlkbid0
IG5lZWQNCj4gPiBhbnkgYW5ub3RhdGlvbiBvZiB0aGUgb2JqZWN0IGNvZGUgYW5kIGRpZG4ndCBu
ZWVkIGZyYW1lIHBvaW50ZXJzLg0KPiA+IFRoZSBvbmx5IGRvd25zaWRlIHdhcyB0aGF0IGl0IGhh
ZCB0byAnZ3Vlc3MnIChpZSBzY2FuIHRoZSBzdGFjaykNCj4gPiB0byBnZXQgb3V0IG9mIGZ1bmN0
aW9ucyB0aGF0IGNvdWxkbid0IHJldHVybi4NCj4gPiBCYXNpY2FsbHkgaXQgZm9sbG93ZWQgdGhl
IGNvbnRyb2wgZmxvdyBmb3J3YXJkcyB0cmFja2luZyB0aGUNCj4gPiB2YWx1ZXMgb2YgJXNwIGFu
ZCAlYnAgdW50aWwgaXQgZm91bmQgYSByZXR1cm4gaW5zdHVjdGlvbi4NCj4gPiBBbGwgaXQgaGFz
IHRvIGRvIGlzIGRldGVjdCBsb29wcyBhbmQgcmV0cnkgZnJvbSB0aGUgb3RoZXINCj4gPiB0YXJn
ZXQgb2YgY29uZGl0aW9uYWwgYnJhbmNoZXMuDQo+IA0KPiBUaGF0IGFjdHVhbGx5IHNvdW5kcyBr
aW5kIG9mIGNvb2wsIHRob3VnaCBJIGRvbid0IHRoaW5rIHdlIG5lZWQgdGhhdCBmb3INCj4gdGhl
IGtlcm5lbC4NCg0KTm8gcmVhc29uIHdoeSBub3QuDQpJdCB3b3VsZCBzYXZlIG1vc3Qgb2YgdGhl
IGluc3RydW1lbnRhdGlvbiB0aGUgb3JjIHVud2luZGVyIG5lZWRzLg0KSXQgaXNuJ3QgYXMgdGhv
dWdoIHRoZSBwZXJmb3JtYW5jZSBvZiBrZXJuZWwgdHJhY2ViYWNrcyBpcyB0aGF0DQppbXBvcnRh
bnQgKHByaW50ZiBhbmQgc3ltYm9sIGxvb2t1cCBwcm9iYWJseSBhbHdheXMgZG9taW5hdGVzKS4N
ClRoZSBvbmx5IGRpZmZpY3VsdHkgZm9yIHg4NiBpcyBxdWlja2x5IGRldGVybWluaW5nIHRoZSBz
aXplIG9mDQppbnN0cnVjdGlvbnMuDQoNCglEYXZpZA0KDQotDQpSZWdpc3RlcmVkIEFkZHJlc3Mg
TGFrZXNpZGUsIEJyYW1sZXkgUm9hZCwgTW91bnQgRmFybSwgTWlsdG9uIEtleW5lcywgTUsxIDFQ
VCwgVUsNClJlZ2lzdHJhdGlvbiBObzogMTM5NzM4NiAoV2FsZXMpDQo=

