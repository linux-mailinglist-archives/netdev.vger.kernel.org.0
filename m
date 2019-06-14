Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27FD445FC8
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 16:00:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728687AbfFNN6Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 09:58:25 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:35754 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728298AbfFNN6Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 09:58:25 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-222-0dLfJHaUN2mjadwXspBVlg-1; Fri, 14 Jun 2019 14:58:22 +0100
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b::d117) by AcuMS.aculab.com
 (fd9f:af1c:a25b::d117) with Microsoft SMTP Server (TLS) id 15.0.1347.2; Fri,
 14 Jun 2019 14:58:21 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Fri, 14 Jun 2019 14:58:21 +0100
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
Thread-Index: AQHVIjMat8Fq1dO6sUKm4aXwvliIEKaa+NdggAAgcYCAABJOQA==
Date:   Fri, 14 Jun 2019 13:58:21 +0000
Message-ID: <9b8aa912df694d25b581786100d3e2e2@AcuMS.aculab.com>
References: <cover.1560431531.git.jpoimboe@redhat.com>
 <03ddea21a533b7b0e471c1d73ebff19dacdcf7e3.1560431531.git.jpoimboe@redhat.com>
 <20190613215807.wjcop6eaadirz5xm@ast-mbp.dhcp.thefacebook.com>
 <57f6e69da6b3461a9c39d71aa1b58662@AcuMS.aculab.com>
 <20190614134401.q2wbh6mvo4nzmw2o@treble>
In-Reply-To: <20190614134401.q2wbh6mvo4nzmw2o@treble>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-MC-Unique: 0dLfJHaUN2mjadwXspBVlg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSm9zaCBQb2ltYm9ldWYNCj4gU2VudDogMTQgSnVuZSAyMDE5IDE0OjQ0DQo+IA0KPiBP
biBGcmksIEp1biAxNCwgMjAxOSBhdCAxMDo1MDoyM0FNICswMDAwLCBEYXZpZCBMYWlnaHQgd3Jv
dGU6DQo+ID4gT24gVGh1LCBKdW4gMTMsIDIwMTkgYXQgMDg6MjE6MDNBTSAtMDUwMCwgSm9zaCBQ
b2ltYm9ldWYgd3JvdGU6DQo+ID4gPiBUaGUgQlBGIEpJVCBjb2RlIGNsb2JiZXJzIFJCUC4gIFRo
aXMgYnJlYWtzIGZyYW1lIHBvaW50ZXIgY29udmVudGlvbiBhbmQNCj4gPiA+IHRodXMgcHJldmVu
dHMgdGhlIEZQIHVud2luZGVyIGZyb20gdW53aW5kaW5nIHRocm91Z2ggSklUIGdlbmVyYXRlZCBj
b2RlLg0KPiA+ID4NCj4gPiA+IFJCUCBpcyBjdXJyZW50bHkgdXNlZCBhcyB0aGUgQlBGIHN0YWNr
IGZyYW1lIHBvaW50ZXIgcmVnaXN0ZXIuICBUaGUNCj4gPiA+IGFjdHVhbCByZWdpc3RlciB1c2Vk
IGlzIG9wYXF1ZSB0byB0aGUgdXNlciwgYXMgbG9uZyBhcyBpdCdzIGENCj4gPiA+IGNhbGxlZS1z
YXZlZCByZWdpc3Rlci4gIENoYW5nZSBpdCB0byB1c2UgUjEyIGluc3RlYWQuDQo+ID4NCj4gPiBD
b3VsZCB5b3UgbWFpbnRhaW4gdGhlIHN5c3RlbSAlcmJwIGNoYWluIHRocm91Z2ggdGhlIEJQRiBz
dGFjaz8NCj4gDQo+IERvIHlvdSBtZWFuIHRvIHNhdmUgUkJQIGFnYWluIGJlZm9yZSBjaGFuZ2lu
ZyBpdCBhZ2Fpbiwgc28gdGhhdCB3ZQ0KPiBjcmVhdGUgYW5vdGhlciBzdGFjayBmcmFtZSBpbnNp
ZGUgdGhlIEJQRiBzdGFjaz8gIFRoYXQgbWlnaHQgd29yay4NCg0KVGhlIHVud2luZGVyIHdpbGwg
KElJUkMpIGV4cGVjdCAqJXJicCB0byBiZSB0aGUgcHJldmlvdXMgJXJicCB2YWx1ZS4NCklmIHlv
dSBtYWludGFpbiB0aGF0IGl0IHdpbGwgcHJvYmFibHkgYWxsIHdvcmsuDQoNCj4gPiBJdCBtaWdo
dCBldmVuIGJlIHBvc3NpYmxlIHRvIHB1dCBzb21ldGhpbmcgcmVsZXZhbnQgaW4gdGhlICVyaXAN
Cj4gPiBsb2NhdGlvbi4NCj4gDQo+IEknbSBub3Qgc3VyZSB3aGF0IHlvdSBtZWFuIGhlcmUuDQoN
ClRoZSByZXR1cm4gYWRkcmVzcyBpcyAoYWdhaW4gSUlSQykgJXJicFstOF0gc28gdGhlIHVud2lu
ZGVyIHdpbGwNCmV4cGVjdCB0aGF0IGFkZHJlc3MgdG8gYmUgYSBzeW1ib2wuDQoNCkkgZG8gcmVt
ZW1iZXIgYSBzdGFjayB0cmFjZSBwcmludGVyIGZvciB4ODYgdGhpcyBkaWRuJ3QgbmVlZA0KYW55
IGFubm90YXRpb24gb2YgdGhlIG9iamVjdCBjb2RlIGFuZCBkaWRuJ3QgbmVlZCBmcmFtZSBwb2lu
dGVycy4NClRoZSBvbmx5IGRvd25zaWRlIHdhcyB0aGF0IGl0IGhhZCB0byAnZ3Vlc3MnIChpZSBz
Y2FuIHRoZSBzdGFjaykNCnRvIGdldCBvdXQgb2YgZnVuY3Rpb25zIHRoYXQgY291bGRuJ3QgcmV0
dXJuLg0KQmFzaWNhbGx5IGl0IGZvbGxvd2VkIHRoZSBjb250cm9sIGZsb3cgZm9yd2FyZHMgdHJh
Y2tpbmcgdGhlDQp2YWx1ZXMgb2YgJXNwIGFuZCAlYnAgdW50aWwgaXQgZm91bmQgYSByZXR1cm4g
aW5zdHVjdGlvbi4NCkFsbCBpdCBoYXMgdG8gZG8gaXMgZGV0ZWN0IGxvb3BzIGFuZCByZXRyeSBm
cm9tIHRoZSBvdGhlcg0KdGFyZ2V0IG9mIGNvbmRpdGlvbmFsIGJyYW5jaGVzLg0KDQoJRGF2aWQN
Cg0KLQ0KUmVnaXN0ZXJlZCBBZGRyZXNzIExha2VzaWRlLCBCcmFtbGV5IFJvYWQsIE1vdW50IEZh
cm0sIE1pbHRvbiBLZXluZXMsIE1LMSAxUFQsIFVLDQpSZWdpc3RyYXRpb24gTm86IDEzOTczODYg
KFdhbGVzKQ0K

