Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4830830C391
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 16:24:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235220AbhBBPWo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 10:22:44 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.86.151]:51059 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235416AbhBBPVI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 10:21:08 -0500
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-185-Gu_RDKmbMaKWldRhyZC_cQ-1; Tue, 02 Feb 2021 15:19:20 +0000
X-MC-Unique: Gu_RDKmbMaKWldRhyZC_cQ-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Tue, 2 Feb 2021 15:19:21 +0000
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Tue, 2 Feb 2021 15:19:21 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Paolo Abeni' <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Menglong Dong <menglong8.dong@gmail.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
CC:     netdev <netdev@vger.kernel.org>
Subject: RE: make sendmsg/recvmsg process multiple messages at once
Thread-Topic: make sendmsg/recvmsg process multiple messages at once
Thread-Index: AQHW+U0LTmhlXCbr9EiCQm7LoPnH7qpE+APA
Date:   Tue, 2 Feb 2021 15:19:21 +0000
Message-ID: <977e9d41cb8d4285a3f75195ccb9e3b2@AcuMS.aculab.com>
References: <CADxym3ba8R6fN3O5zLAw-e7q0gjFxBd_WUKjq0hTP+JpAbJEKg@mail.gmail.com>
         <20210201200733.4309ef71@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <a24db624cb6b2df98e95b18bbcd55eca53c116ae.camel@redhat.com>
In-Reply-To: <a24db624cb6b2df98e95b18bbcd55eca53c116ae.camel@redhat.com>
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

RnJvbTogUGFvbG8gQWJlbmkNCj4gU2VudDogMDIgRmVicnVhcnkgMjAyMSAxMDoxOQ0KLi4uDQo+
IE5vdGUgdGhhdCB5b3UgY2FuIGFscmVhZHkgcHJvY2VzcyBzZXZlcmFsIHBhY2tldHMgd2l0aCBh
IHNpbmdsZSBzeXNjYWxsDQo+IHVzaW5nIHNlbmRtbXNnL3JlY3ZtbXNnLiBCb3RoIGhhdmUgaXNz
dWVzIHdpdGggZXJyb3IgcmVwb3J0aW5nIGFuZA0KPiB0aW1lb3V0IGFuZCBJSVJDIHN0aWxsIGRv
bid0IGFtb3J0aXplIHRoZSBvdmVyaGVhZCBpbnRyb2R1Y2VkIGUuZy4gYnkNCj4gQ09ORklHX0hB
UkRFTkVEX1VTRVJDT1BZLg0KDQpCb3RoIENPTkZJR19IQVJERU5FRF9VU0VSQ09QWSBhbmQgdGhl
IGV4dHJhIHVzZXIgY29waWVzIG5lZWRlZA0KZXZlbiBmb3Igc2VuZG1zZygpIG92ZXIgc2VuZCgp
IGFyZSBkZWZpbml0ZWx5IG1lYXN1cmFibGUuDQpJJ3ZlIHJ1biB0ZXN0cyB1c2luZyBfY29weV9m
cm9tX3VzZXIoKSBmb3IgbWFueSBvZiB0aGUgY29waWVzLg0KRXZlbiB0aGUgY29zdCBvZiByZWFk
aW5nIGluIGEgc2luZ2xlIGlvdltdIGZvciB0aGUgYnVmZmVyDQphZmZlY3RzIHRoaW5ncy4NCg0K
TXkgbGFzdCBhdHRlbXB0IGF0IHNwZWVkaW5nIHVwIHdyaXRldigiL2Rldi9udWxsIiwgaW92LCAx
MCkNCmZlbGwgaW50byB0aGUgcmFiYml0IGhvbGUgb2YgaW9fdXJpbmcgKGFnYWluKS4NCkJ1dCB0
aGUgcGFydGlhbCBjaGFuZ2VzIGdhdmUgYSBmZXcgJSBpbXByb3ZlbWVudC4NCg0KCURhdmlkDQoN
Ci0NClJlZ2lzdGVyZWQgQWRkcmVzcyBMYWtlc2lkZSwgQnJhbWxleSBSb2FkLCBNb3VudCBGYXJt
LCBNaWx0b24gS2V5bmVzLCBNSzEgMVBULCBVSw0KUmVnaXN0cmF0aW9uIE5vOiAxMzk3Mzg2IChX
YWxlcykNCg==

