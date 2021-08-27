Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5CE03F9631
	for <lists+netdev@lfdr.de>; Fri, 27 Aug 2021 10:34:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244617AbhH0IfE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Aug 2021 04:35:04 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.85.151]:47185 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244492AbhH0Ie5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Aug 2021 04:34:57 -0400
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-282-cY9NIgxAN6addO80KQbTFA-1; Fri, 27 Aug 2021 09:34:06 +0100
X-MC-Unique: cY9NIgxAN6addO80KQbTFA-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.23; Fri, 27 Aug 2021 09:34:04 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.023; Fri, 27 Aug 2021 09:34:04 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Peter Collingbourne' <pcc@google.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Colin Ian King <colin.king@canonical.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH] net: don't unconditionally copy_from_user a struct ifreq
 for socket ioctls
Thread-Topic: [PATCH] net: don't unconditionally copy_from_user a struct ifreq
 for socket ioctls
Thread-Index: AQHXmhmeusqat7DUPUKEZ8XxUHnOHquFbtgQgACyTQCAAOW6wA==
Date:   Fri, 27 Aug 2021 08:34:04 +0000
Message-ID: <dfe40435294b43b6860153b9200a39fc@AcuMS.aculab.com>
References: <20210826012722.3210359-1-pcc@google.com>
 <11f72b27c12f46eb8bef1d1773980c54@AcuMS.aculab.com>
 <CAMn1gO5eT=S-BcbhDDM9=s5r1zspO==nbJjYV-p9JFq-U5U+eA@mail.gmail.com>
In-Reply-To: <CAMn1gO5eT=S-BcbhDDM9=s5r1zspO==nbJjYV-p9JFq-U5U+eA@mail.gmail.com>
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

RnJvbTogUGV0ZXIgQ29sbGluZ2JvdXJuZQ0KPiBTZW50OiAyNiBBdWd1c3QgMjAyMSAyMDo0Ng0K
Li4uDQo+ID4gVGhlIG90aGVyIHNhbmUgdGhpbmcgaXMgdG8gY2hlY2sgX0lPQ19TSVpFKCkuDQo+
ID4gU2luY2UgYWxsIHRoZSBTSU9DeHh4eCBoYXZlIGEgY29ycmVjdCBfSU9DX1NJWkUoKSB0aGF0
IGNhbiBiZQ0KPiA+IHVzZWQgdG8gY2hlY2sgdGhlIHVzZXIgY29weSBsZW5ndGguDQo+ID4gKFVu
bGlrZSBzb2NrZXQgb3B0aW9ucyB0aGUgY29ycmVjdCBsZW5ndGggaXMgYWx3YXlzIHN1cHBsaWVk
Lg0KPiANCj4gRldJVywgaXQgZG9lc24ndCBsb29rIGxpa2UgYW55IG9mIHRoZW0gaGF2ZSB0aGUg
X0lPQ19TSVpFKCkgYml0cyBzZXQsDQo+IHNvIHRoYXQgd29uJ3Qgd29yay4gX0lPQ19UWVBFKCkg
c2VlbXMgYmV0dGVyIGFueXdheS4NCg0KTGludXMgbXVzdCBoYXZlIHN0b2xlbiB0aG9zZSBkZWZp
bml0aW9ucyBmcm9tIFNWU1Ygbm90IG9uZSBvZiB0aGUgQlNEcy4NClRoZSBCU0QncyBzdGFydGVk
IHVzaW5nIHRoZSBoaWdoIDE2IGJpdHMgd2hlbiB0aGV5IG1vdmVkIHRvIDMyYml0Lg0KDQpTb21l
dGhpbmcgSSd2ZSB3cml0dGVuIGtlcm5lbCBjb2RlIGZvciByZXF1aXJlZCB0aG9zZSBiaXRzIGJl
IHNldA0KYW5kIHdvdWxkIHRoZW4gZG8gdGhlIHVzZXIgY29waWVzIGluIHRoZSBzeXNjYWxsIGVu
dHJ5IHBhdGhzLg0KSXQgd29uJ3QgYmUgU1lTViBiZWNhdXNlIEkgdXNlZCAzIGNoYXJhY3RlciAn
dHlwZScgZmllbGRzIG9uIHRoYXQuDQpXaW5kb3dzIGRvZXMgZG8gdGhlIGNvcGllcyAtIGJ1dCBp
cyBlbnRpcmVseSAnbm90IHF1aXRlJyBkaWZmZXJlbnQuDQpTbyBpdCBtdXN0IGhhdmUgYmVlbiBO
ZXRCRFNELg0KDQoJRGF2aWQNCg0KLQ0KUmVnaXN0ZXJlZCBBZGRyZXNzIExha2VzaWRlLCBCcmFt
bGV5IFJvYWQsIE1vdW50IEZhcm0sIE1pbHRvbiBLZXluZXMsIE1LMSAxUFQsIFVLDQpSZWdpc3Ry
YXRpb24gTm86IDEzOTczODYgKFdhbGVzKQ0K

