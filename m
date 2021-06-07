Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E5BA39DC7C
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 14:33:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230365AbhFGMe3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 08:34:29 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.86.151]:32415 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230381AbhFGMe1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Jun 2021 08:34:27 -0400
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-161-gnp5d3f9OISlRjvMgh2U7A-1; Mon, 07 Jun 2021 13:32:30 +0100
X-MC-Unique: gnp5d3f9OISlRjvMgh2U7A-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.18; Mon, 7 Jun 2021 13:32:29 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.018; Mon, 7 Jun 2021 13:32:29 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Koba Ko' <koba.ko@canonical.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] r8169: introduce polling method for link change
Thread-Topic: [PATCH] r8169: introduce polling method for link change
Thread-Index: AQHXW1Z1J4XkbqR7K0q4sy48RuQacKsIelDA
Date:   Mon, 7 Jun 2021 12:32:29 +0000
Message-ID: <16f24c21776a4772ac41e6d3e0a9150c@AcuMS.aculab.com>
References: <20210603025414.226526-1-koba.ko@canonical.com>
 <3d2e7a11-92ad-db06-177b-c6602ef1acd4@gmail.com>
 <CAJB-X+V4vpLoNt2C_i=3mS4UtFnDdro5+hgaFXHWxcvobO=pzg@mail.gmail.com>
 <f969a075-25a1-84ba-daad-b4ed0e7f75f5@gmail.com>
 <CAJB-X+U5VEeSNS4sF0DBxc-p0nxA6QLVVrORHsscZuY37rGJ7w@mail.gmail.com>
 <bfc68450-422d-1968-1316-64f7eaa7cbe9@gmail.com>
 <CAJB-X+UDRK5-fKEGc+PS+_02HePmb34Pw_+tMyNr_iGGeE+jbQ@mail.gmail.com>
In-Reply-To: <CAJB-X+UDRK5-fKEGc+PS+_02HePmb34Pw_+tMyNr_iGGeE+jbQ@mail.gmail.com>
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

RnJvbTogS29iYSBLbw0KPiBTZW50OiAwNyBKdW5lIDIwMjEgMDU6MzUNCi4uLg0KPiBBZnRlciBj
b25zdWx0aW5nIHdpdGggUkVBTFRFSywgSSBjYW4gaWRlbnRpZnkgUlRMODEwNmUgYnkgUENJX1ZF
TkRPUg0KPiBSRUFMVEVLLCBERVZJQ0UgMHg4MTM2LCBSZXZpc2lvbiAweDcuDQo+IEkgd291bGQg
bGlrZSB0byBtYWtlIFBIWV9QT0xMIGFzIGRlZmF1bHQgZm9yIFJUTDgxMDZFIG9uIFYyLg0KPiBi
ZWNhdXNlIHRoZXJlJ3Mgbm8gc2lkZSBlZmZlY3RzIGJlc2lkZXMgdGhlIGNwdSB1c2FnZSByYXRl
IHdvdWxkIGJlIGENCj4gbGl0dGxlIGhpZ2hlciwNCj4gSG93IGRvIHlvdSB0aGluaz8NCg0KSWYg
cmVhZGluZyB0aGUgUEhZIHJlZ2lzdGVycyBpbnZvbHZlcyBhIHNvZnR3YXJlIGJpdC1iYW5nDQpv
ZiBhbiBNSUkgcmVnaXN0ZXIgKHJhdGhlciB0aGFuLCBzYXksIGEgc2xlZXAgZm9yIGludGVycnVw
dA0Kd2hpbGUgdGhlIE1BQyB1bml0IGRvZXMgdGhlIGJpdC1iYW5nKSB0aGVuIHlvdSBjYW4gY2xv
YmJlcg0KaW50ZXJydXB0IGxhdGVuY3kgYmVjYXVzZSBvZiBhbGwgdGhlIHRpbWUgc3BlbnQgc3Bp
bm5pbmcuDQoNCldoaWxlIHRoaXMgaXMgbGVzcyBvZiBhIHByb2JsZW0gb24gbXVsdGktY3B1IHN5
c3RlbXMgSSBoYXZlDQpzZWVuIGl0IHJlc3VsdCBpbiBldGhlcm5ldCBwYWNrZXQgbG9zcyBvbiBv
bGQgc3lzdGVtcy4NCg0KCURhdmlkDQoNCi0NClJlZ2lzdGVyZWQgQWRkcmVzcyBMYWtlc2lkZSwg
QnJhbWxleSBSb2FkLCBNb3VudCBGYXJtLCBNaWx0b24gS2V5bmVzLCBNSzEgMVBULCBVSw0KUmVn
aXN0cmF0aW9uIE5vOiAxMzk3Mzg2IChXYWxlcykNCg==

