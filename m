Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3510E3EB5E5
	for <lists+netdev@lfdr.de>; Fri, 13 Aug 2021 15:00:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240514AbhHMNAo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Aug 2021 09:00:44 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.86.151]:52077 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240078AbhHMNAn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Aug 2021 09:00:43 -0400
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-13-UP7cVO8XN0iuisRl0gXJrA-1; Fri, 13 Aug 2021 14:00:14 +0100
X-MC-Unique: UP7cVO8XN0iuisRl0gXJrA-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.23; Fri, 13 Aug 2021 14:00:12 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.023; Fri, 13 Aug 2021 14:00:12 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Bui Quang Minh' <minhquangbui99@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "yoshfuji@linux-ipv6.org" <yoshfuji@linux-ipv6.org>,
        "dsahern@kernel.org" <dsahern@kernel.org>,
        "willemb@google.com" <willemb@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "avagin@gmail.com" <avagin@gmail.com>,
        "alexander@mihalicyn.com" <alexander@mihalicyn.com>,
        "lesedorucalin01@gmail.com" <lesedorucalin01@gmail.com>
Subject: RE: [PATCH v2 1/2] udp: UDP socket send queue repair
Thread-Topic: [PATCH v2 1/2] udp: UDP socket send queue repair
Thread-Index: AQHXkDOQyvhyTnb6/kiYjIjj7jj0n6txZU8g
Date:   Fri, 13 Aug 2021 13:00:12 +0000
Message-ID: <29dc7ac9781344f1a57e16c14900a7da@AcuMS.aculab.com>
References: <20210811154557.6935-1-minhquangbui99@gmail.com>
 <721a2e32-c930-ad6b-5055-631b502ed11b@gmail.com>
 <7f3ecbaf-7759-88ae-53d3-2cc5b1623aff@gmail.com>
 <489f0200-b030-97de-cf3a-2d715b07dfa4@gmail.com>
 <3f861c1d-bd33-f074-8ef3-eede9bff73c1@gmail.com>
In-Reply-To: <3f861c1d-bd33-f074-8ef3-eede9bff73c1@gmail.com>
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

RnJvbTogQnVpIFF1YW5nIE1pbmgNCj4gU2VudDogMTMgQXVndXN0IDIwMjEgMTI6MDgNCi4uLg0K
PiBUaGUgcmVhc29uIHdlIHdhbnQgdG8gZHVtcCB0aGUgcGFja2V0IGluIHNlbmQgcXVldWUgaXMg
dG8gbWFrZSB0byBzdGF0ZSBvZiB0aGUNCj4gYXBwbGljYXRpb24gY29uc2lzdGVudC4gVGhlIHNj
ZW5hcmlvIGlzIHRoYXQgd2hlbiBhbiBhcHBsaWNhdGlvbiBzZW5kcyBVRFANCj4gcGFja2V0cyB2
aWEgVURQX0NPUksgc29ja2V0IG9yIHdpdGggTVNHX01PUkUsIENSSVUgY29tZXMgYW5kIGNoZWNr
cG9pbnRzIHRoZQ0KPiBhcHBsaWNhdGlvbi4gSWYgd2UgZHJvcCB0aGUgZGF0YSBpbiBzZW5kIHF1
ZXVlLCB3aGVuIGFwcGxpY2F0aW9uIHJlc3RvcmVzLCBpdA0KPiBzZW5kcyBzb21lIG1vcmUgZGF0
YSB0aGVuIHR1cm5zIG9mZiB0aGUgY29yayBhbmQgYWN0dWFsbHkgc2VuZHMgYSBwYWNrZXQuIFRo
ZQ0KPiByZWNlaXZpbmcgc2lkZSBtYXkgZ2V0IHRoYXQgcGFja2V0IGJ1dCBpdCdzIHVudXN1YWwg
dGhhdCB0aGUgZmlyc3QgcGFydCBvZiB0aGF0DQo+IHBhY2tldCBpcyBtaXNzaW5nIGJlY2F1c2Ug
d2UgZHJvcCBpdC4gU28gd2UgdHJ5IHRvIHNvbHZlIHRoaXMgcHJvYmxlbSB3aXRoIHNvbWUNCj4g
aGVscCBmcm9tIHRoZSBMaW51eCBrZXJuZWwuDQoNClBhdGllbnQ6IEl0IGh1cnRzIGlmIEkgZG8g
eHh4Lg0KRG9jdG9yOiBEb24ndCBkbyB4eHggdGhlbi4NCg0KSXQgaGFzIHRvIGJlIG1vcmUgZWZm
aWNpZW50IHRvIGJ1ZmZlciBwYXJ0aWFsIFVEUCBwYWNrZXRzDQppbiB1c2Vyc3BhY2UgYW5kIG9u
bHkgc2VuZCB3aGVuIGFsbCB0aGUgcGFja2V0IGlzIGF2YWlsYWJsZS4NCg0KCURhdmlkDQoNCi0N
ClJlZ2lzdGVyZWQgQWRkcmVzcyBMYWtlc2lkZSwgQnJhbWxleSBSb2FkLCBNb3VudCBGYXJtLCBN
aWx0b24gS2V5bmVzLCBNSzEgMVBULCBVSw0KUmVnaXN0cmF0aW9uIE5vOiAxMzk3Mzg2IChXYWxl
cykNCg==

