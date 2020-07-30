Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96F952335C0
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 17:43:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729745AbgG3PnB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 11:43:01 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.86.151]:26587 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726275AbgG3PnB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jul 2020 11:43:01 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-247-twbbvnymOjCGJ4ynCSlL6A-1; Thu, 30 Jul 2020 16:42:49 +0100
X-MC-Unique: twbbvnymOjCGJ4ynCSlL6A-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Thu, 30 Jul 2020 16:42:49 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Thu, 30 Jul 2020 16:42:49 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Sebastian Gottschall' <s.gottschall@dd-wrt.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Felix Fietkau <nbd@nbd.name>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Hillf Danton <hdanton@sina.com>
Subject: RE: [PATCH] net: add support for threaded NAPI polling
Thread-Topic: [PATCH] net: add support for threaded NAPI polling
Thread-Index: AQHWZn3/cOW3dLYIQUeXoP7PwfLTPakgQZ9Q
Date:   Thu, 30 Jul 2020 15:42:49 +0000
Message-ID: <1743bcaa2dfb4b6393b4d228cf079fe3@AcuMS.aculab.com>
References: <20200729165058.83984-1-nbd@nbd.name>
 <866c7d83-868d-120e-f535-926c4cc9e615@gmail.com>
 <5aa0c26f-d3f1-b33f-a598-e4727d6f10f0@dd-wrt.com>
In-Reply-To: <5aa0c26f-d3f1-b33f-a598-e4727d6f10f0@dd-wrt.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=C51A453 smtp.mailfrom=david.laight@aculab.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogU2ViYXN0aWFuIEdvdHRzY2hhbGwNCj4gU2VudDogMzAgSnVseSAyMDIwIDE1OjMwDQou
Li4NCj4gPiBRdWl0ZSBmcmFua2x5LCBJIGRvIGJlbGlldmUgdGhpcyBTVEFURV9USFJFQURFRCBz
dGF0dXMgc2hvdWxkIGJlIGEgZ2VuZXJpYyBOQVBJIGF0dHJpYnV0ZQ0KPiA+IHRoYXQgY2FuIGJl
IGNoYW5nZWQgZHluYW1pY2FsbHksIGF0IGFkbWluIHJlcXVlc3QsIGluc3RlYWQgb2YgaGF2aW5n
IHRvIGNoYW5nZS9yZWNvbXBpbGUNCj4gPiBhIGRyaXZlci4NCg0KPiB0aGF0cyBub3QgdGhhdCBl
YXN5LiB3aWZpIGRldmljZXMgZG8gdXNlIGR1bW15IG5ldGRldiBkZXZpY2VzLiB0aGV5IGFyZQ0K
PiBub3QgdmlzaWJsZSB0byBzeXNmcyBhbmQgb3RoZXIgYWRtaW5pc3RyYXRpdmUgb3B0aW9ucy4N
Cj4gc28gY2hhbmdpbmcgaXQgd291bGQganVzdCBiZSBwb3NzaWJsZSBpZiBhIHNwZWNpYWwgbWFj
ODAyMTEgYmFzZWQNCj4gY29udHJvbCB3b3VsZCBiZSBpbXBsZW1lbnRlZCBmb3IgdGhlc2UgZHJp
dmVycy4NCj4gZm9yIHN0YW5kYXJkIG5ldGRldiBkZXZpY2VzIGl0IGlzbnQgYSBiaWcgdGhpbmcg
dG8gaW1wbGVtZW50IGENCj4gYWRtaW5pc3RyYXRpdmUgY29udHJvbCBieSBzeXNmcyAoaWYgeW91
IGFyZSB0YWxraW5nIGFib3V0IHN1Y2ggYSBmZWF0dXJlKQ0KDQpJU1RNIHRoYXQgYSBnbG9iYWwg
ZmxhZyB0aGF0IG1hZGUgYWxsIE5BUEkgY2FsbGJhY2tzIGJlIG1hZGUNCmZyb20gYSB3b3JrZXIg
dGhyZWFkIHJhdGhlciB0aGFuIHNvZnRpbnQgd291bGQgYmUgbW9yZSBhcHByb3JpYXRlLg0KT3Ig
ZXZlbiBzb21ldGhpbmcgdGhhdCBtYWRlIHRoZSBzb2Z0aW50IGNhbGxiYWNrcyB0aGVtc2VsdmVz
DQpvbmx5IHJ1biBhbiBhIHNwZWNpZmljIGhpZ2goaXNoKSBwcmlvcml0eSBrZXJuZWwgdGhyZWFk
Lg0KDQpXaGlsZSBpdCBtaWdodCBzbG93IGRvd24gc2V0dXBzIHRoYXQgbmVlZCB2ZXJ5IGxvdyBl
dGhlcm5ldA0KbGF0ZW5jeSBpdCB3aWxsIGhlbHAgdGhvc2UgdGhhdCBkb24ndCB3YW50IGFwcGxp
Y2F0aW9uIFJUIHRocmVhZHMNCnRvIGJlICdzdG9sZW4nIGJ5IHRoZSBzb2Z0aW50IGNvZGUgd2hp
bGUgdGhleSBob2xkIGFwcGxpY2F0aW9uDQptdXRleCBvciBhcmUgd2FpdGluZyB0byBiZSB3b2tl
biBieSBhIGN2Lg0KDQoJRGF2aWQNCg0KLQ0KUmVnaXN0ZXJlZCBBZGRyZXNzIExha2VzaWRlLCBC
cmFtbGV5IFJvYWQsIE1vdW50IEZhcm0sIE1pbHRvbiBLZXluZXMsIE1LMSAxUFQsIFVLDQpSZWdp
c3RyYXRpb24gTm86IDEzOTczODYgKFdhbGVzKQ0K

