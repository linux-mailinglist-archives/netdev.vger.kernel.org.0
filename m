Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E21054D2401
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 23:12:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236873AbiCHWNJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 17:13:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229902AbiCHWNI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 17:13:08 -0500
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.85.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AB9C347AEA
        for <netdev@vger.kernel.org>; Tue,  8 Mar 2022 14:12:10 -0800 (PST)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-168-2C-yBT7jNpqrOW2MLTuR3w-1; Tue, 08 Mar 2022 22:12:07 +0000
X-MC-Unique: 2C-yBT7jNpqrOW2MLTuR3w-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.28; Tue, 8 Mar 2022 22:12:06 +0000
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.028; Tue, 8 Mar 2022 22:12:06 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Eric Dumazet' <edumazet@google.com>
CC:     Jakub Kicinski <kuba@kernel.org>, netdev <netdev@vger.kernel.org>,
        "Willem de Bruijn" <willemb@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        "Yuchung Cheng" <ycheng@google.com>
Subject: RE: [RFC net-next] tcp: allow larger TSO to be built under overload
Thread-Topic: [RFC net-next] tcp: allow larger TSO to be built under overload
Thread-Index: AQHYMp+lvVxMhB3eHk2yhoJYjvGf7ay1MbUwgAC1cwCAAB4g0A==
Date:   Tue, 8 Mar 2022 22:12:06 +0000
Message-ID: <218fd4946208411b90ac77cfcf7aa643@AcuMS.aculab.com>
References: <20220308030348.258934-1-kuba@kernel.org>
 <CANn89iLoWOdLQWB0PeTtbOtzkAT=cWgzy5_RXqqLchZu1GziZw@mail.gmail.com>
 <652afb8e99a34afc86bd4d850c1338e5@AcuMS.aculab.com>
 <CANn89iL0XWF8aavPFnTrRazV9T5fZtn3xJXrEb07HTdrM=rykw@mail.gmail.com>
In-Reply-To: <CANn89iL0XWF8aavPFnTrRazV9T5fZtn3xJXrEb07HTdrM=rykw@mail.gmail.com>
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
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogRXJpYyBEdW1hemV0DQo+IFNlbnQ6IDA4IE1hcmNoIDIwMjIgMTk6NTQNCi4uDQo+ID4g
V2hpY2ggaXMgdGhlIGNvbW1vbiBzaWRlIG9mIHRoYXQgbWF4X3QoKSA/DQo+ID4gSWYgaXQgaXMg
bW9uX3Rzb19zZWdzIGl0IG1pZ2h0IGJlIHdvcnRoIGF2b2lkaW5nIHRoZQ0KPiA+IGRpdmlkZSBi
eSBjb2RpbmcgYXM6DQo+ID4NCj4gPiAgICAgICAgIHJldHVybiBieXRlcyA+IG1zc19ub3cgKiBt
aW5fdHNvX3NlZ3MgPyBieXRlcyAvIG1zc19ub3cgOiBtaW5fdHNvX3NlZ3M7DQo+ID4NCj4gDQo+
IEkgdGhpbmsgdGhlIGNvbW1vbiBjYXNlIGlzIHdoZW4gdGhlIGRpdmlkZSBtdXN0IGhhcHBlbi4N
Cj4gTm90IHN1cmUgaWYgdGhpcyByZWFsbHkgbWF0dGVycyB3aXRoIGN1cnJlbnQgY3B1cy4NCg0K
TGFzdCBkb2N1bWVudCBJIGxvb2tlZCBhdCBzdGlsbCBxdW90ZWQgY29uc2lkZXJhYmxlIGxhdGVu
Y3kNCmZvciBpbnRlZ2VyIGRpdmlkZSBvbiB4ODYtNjQuDQpJZiB5b3UgZ2V0IGEgY21vdiB0aGVu
IGFsbCB0aGUgaW5zdHJ1Y3Rpb25zIHdpbGwganVzdCBnZXQNCnF1ZXVlZCB3YWl0aW5nIGZvciB0
aGUgZGl2aWRlIHRvIGNvbXBsZXRlLg0KQnV0IGEgYnJhbmNoIGNvdWxkIGVhc2lseSBnZXQgbWlz
cHJlZGljdGVkLg0KVGhhdCBpcyBsaWtlbHkgdG8gaGl0IHBwYyAtIHdoaWNoIEkgZG9uJ3QgdGhp
bmsgaGFzIGEgY21vdj8NCg0KT1RPSCBpZiB0aGUgZGl2aWRlIGlzIGluIHRoZSA/OiBiaXQgbm90
aGluZyBwcm9iYWJseSBkZXBlbmRzDQpvbiBpdCBmb3IgYSB3aGlsZSAtIHNvIHRoZSBsYXRlbmN5
IHdvbid0IG1hdHRlci4NCg0KTGF0ZXN0IGZpZ3VyZXMgSSBoYXZlIGFyZSBmb3Igc2t5bGFrZVgN
CiAgICAgICAgIHUtb3BzICAgICAgICAgICAgbGF0ZW5jeSAxL3Rocm91Z2hwdXQNCkRJViAgIHI4
IDEwIDEwIHAwIHAxIHA1IHA2ICAyMyAgICAgICAgNg0KRElWICByMTYgMTAgMTAgcDAgcDEgcDUg
cDYgIDIzICAgICAgICA2DQpESVYgIHIzMiAxMCAxMCBwMCBwMSBwNSBwNiAgMjYgICAgICAgIDYN
CkRJViAgcjY0IDM2IDM2IHAwIHAxIHA1IHA2IDM1LTg4ICAgIDIxLTgzDQpJRElWICByOCAxMSAx
MSBwMCBwMSBwNSBwNiAgMjQgICAgICAgIDYNCklESVYgcjE2IDEwIDEwIHAwIHAxIHA1IHA2ICAy
MyAgICAgICAgNg0KSURJViByMzIgMTAgMTAgcDAgcDEgcDUgcDYgIDI2ICAgICAgICA2DQpJRElW
IHI2NCA1NyA1NyBwMCBwMSBwNSBwNiA0Mi05NSAgICAyNC05MA0KDQpCcm9hZHdlbGwgaXMgYSBi
aXQgc2xvd2VyLg0KTm90ZSB0aGF0IDY0Yml0IGRpdmlkZSBpcyByZWFsbHkgaG9ycmlkLg0KDQpJ
IHRoaW5rIHRoYXQgb25lIHdpbGwgYmUgMzJiaXQgLSBzbyAnb25seScgMjYgY2xvY2tzDQpsYXRl
bmN5Lg0KDQpBTUQgUnl6ZW4gaXMgYSBsb3QgYmV0dGVyIGZvciA2NGJpdCBkaXZpZGVzOg0KICAg
ICAgICAgICAgICAgbHRuY3kgIDEvdGhwdA0KRElWICAgcjgvbTggIDEgMTMtMTYgMTMtMTYNCkRJ
ViAgcjE2L20xNiAyIDE0LTIxIDE0LTIxDQpESVYgIHIzMi9tMzIgMiAxNC0zMCAxNC0zMA0KRElW
ICByNjQvbTY0IDIgMTQtNDYgMTQtNDUNCklESVYgIHI4L204ICAxIDEzLTE2IDEzLTE2DQpJRElW
IHIxNi9tMTYgMiAxMy0yMSAxNC0yMg0KSURJViByMzIvbTMyIDIgMTQtMzAgMTQtMzANCklESVYg
cjY0L202NCAyIDE0LTQ3IDE0LTQ1DQpCdXQgbGVzcyBwaXBlbGluaW5nIGZvciAzMmJpdCBvbmVz
Lg0KDQpRdWl0ZSBob3cgdGhvc2UgdGFibGVzIGFjdHVhbGx5IGFmZmVjdCByZWFsIGNvZGUNCmlz
IGFub3RoZXIgbWF0dGVyIC0gYnV0IHRoZXkgYXJlIGd1aWRlbGluZXMgYWJvdXQNCndoYXQgaXMg
cG9zc2libGUgKGlmIHlvdSBjYW4gZ2V0IHRoZSB1LW9wcyBleGVjdXRlZA0Kb24gdGhlIHJpZ2h0
IHBvcnRzKS4NCg0KCURhdmlkDQoNCi0NClJlZ2lzdGVyZWQgQWRkcmVzcyBMYWtlc2lkZSwgQnJh
bWxleSBSb2FkLCBNb3VudCBGYXJtLCBNaWx0b24gS2V5bmVzLCBNSzEgMVBULCBVSw0KUmVnaXN0
cmF0aW9uIE5vOiAxMzk3Mzg2IChXYWxlcykNCg==

