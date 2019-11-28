Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 86EFB10C683
	for <lists+netdev@lfdr.de>; Thu, 28 Nov 2019 11:17:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726565AbfK1KRi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Nov 2019 05:17:38 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([146.101.78.151]:57780 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726191AbfK1KRi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Nov 2019 05:17:38 -0500
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-31-hUuKyJzuN2qaJR0SWDF11g-1; Thu, 28 Nov 2019 10:17:35 +0000
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Thu, 28 Nov 2019 10:17:34 +0000
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Thu, 28 Nov 2019 10:17:34 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Eric Dumazet' <eric.dumazet@gmail.com>,
        'Paolo Abeni' <pabeni@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>
CC:     'Marek Majkowski' <marek@cloudflare.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        network dev <netdev@vger.kernel.org>,
        kernel-team <kernel-team@cloudflare.com>
Subject: RE: epoll_wait() performance
Thread-Topic: epoll_wait() performance
Thread-Index: AdWgk3jgEIFNwcnRS6+4A+/jFPxTuQEdLCCAAAAn2qAADa2dEAAA53BgAAHhYYAAIluz0A==
Date:   Thu, 28 Nov 2019 10:17:34 +0000
Message-ID: <1265e30d04484d08b86ba2abef5f5822@AcuMS.aculab.com>
References: <bc84e68c0980466096b0d2f6aec95747@AcuMS.aculab.com>
 <CAJPywTJYDxGQtDWLferh8ObjGp3JsvOn1om1dCiTOtY6S3qyVg@mail.gmail.com>
 <5f4028c48a1a4673bd3b38728e8ade07@AcuMS.aculab.com>
 <20191127164821.1c41deff@carbon>
 <0b8d7447e129539aec559fa797c07047f5a6a1b2.camel@redhat.com>
 <2f1635d9300a4bec8a0422e9e9518751@AcuMS.aculab.com>
 <313204cf-69fd-ec28-a22c-61526f1dea8b@gmail.com>
In-Reply-To: <313204cf-69fd-ec28-a22c-61526f1dea8b@gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-MC-Unique: hUuKyJzuN2qaJR0SWDF11g-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogRXJpYyBEdW1hemV0DQo+IFNlbnQ6IDI3IE5vdmVtYmVyIDIwMTkgMTc6NDcNCi4uLg0K
PiBBIFFVSUMgc2VydmVyIGhhbmRsZXMgaHVuZHJlZCBvZiB0aG91c2FuZHMgb2YgJyBVRFAgZmxv
d3MnIGFsbCB1c2luZyBvbmx5IG9uZSBVRFAgc29ja2V0DQo+IHBlciBjcHUuDQo+IA0KPiBUaGlz
IGlzIHJlYWxseSB0aGUgb25seSB3YXkgdG8gc2NhbGUsIGFuZCBkb2VzIG5vdCBuZWVkIGtlcm5l
bCBjaGFuZ2VzIHRvIGVmZmljaWVudGx5DQo+IG9yZ2FuaXplIG1pbGxpb25zIG9mIFVEUCBzb2Nr
ZXRzIChodWdlIG1lbW9yeSBmb290cHJpbnQgZXZlbiBpZiB3ZSBnZXQgcmlnaHQgaG93DQo+IHdl
IG1hbmFnZSB0aGVtKQ0KPiANCj4gR2l2ZW4gdGhhdCBVRFAgaGFzIG5vIHN0YXRlLCB0aGVyZSBp
cyByZWFsbHkgbm8gcG9pbnQgdHJ5aW5nIHRvIGhhdmUgb25lIFVEUA0KPiBzb2NrZXQgcGVyIGZs
b3csIGFuZCBoYXZpbmcgdG8gZGVhbCB3aXRoIGVwb2xsKCkvcG9sbCgpIG92ZXJoZWFkLg0KDQpI
b3cgY2FuIHlvdSBkbyB0aGF0IHdoZW4gYWxsIHRoZSBVRFAgZmxvd3MgaGF2ZSBkaWZmZXJlbnQg
ZGVzdGluYXRpb24gcG9ydCBudW1iZXJzPw0KVGhlc2UgYXJlIG1lc3NhZ2UgZmxvd3Mgbm90IGlk
ZW1wb3RlbnQgcmVxdWVzdHMuDQpJIGRvbid0IHJlYWxseSB3YW50IHRvIGNvbGxlY3QgdGhlIHBh
Y2tldHMgYmVmb3JlIHRoZXkndmUgYmVlbiBwcm9jZXNzZWQgYnkgSVAuDQoNCkkgY291bGQgd3Jp
dGUgYSBkcml2ZXIgdGhhdCB1c2VzIGtlcm5lbCB1ZHAgc29ja2V0cyB0byBnZW5lcmF0ZSBhIHNp
bmdsZSBtZXNzYWdlIHF1ZXVlDQp0aGFuIGNhbiBiZSBlZmZpY2llbnRseSBwcm9jZXNzZWQgZnJv
bSB1c2Vyc3BhY2UgLSBidXQgaXQgaXMgYSBmYWZmIGNvbXBpbGluZyBpdCBmb3INCnRoZSBzeXN0
ZW1zIGtlcm5lbCB2ZXJzaW9uLg0KDQoJRGF2aWQNCg0KLQ0KUmVnaXN0ZXJlZCBBZGRyZXNzIExh
a2VzaWRlLCBCcmFtbGV5IFJvYWQsIE1vdW50IEZhcm0sIE1pbHRvbiBLZXluZXMsIE1LMSAxUFQs
IFVLDQpSZWdpc3RyYXRpb24gTm86IDEzOTczODYgKFdhbGVzKQ0K

