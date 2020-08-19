Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF2EF24A1EE
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 16:41:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727932AbgHSOk5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 10:40:57 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.86.151]:45341 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727018AbgHSOk5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 10:40:57 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-125-HuSPjOQMPXi6MMV9atWoQQ-1; Wed, 19 Aug 2020 15:40:53 +0100
X-MC-Unique: HuSPjOQMPXi6MMV9atWoQQ-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Wed, 19 Aug 2020 15:40:52 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Wed, 19 Aug 2020 15:40:52 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     David Laight <David.Laight@ACULAB.COM>,
        "'netdev@vger.kernel.org'" <netdev@vger.kernel.org>,
        "'linux-sctp@vger.kernel.org'" <linux-sctp@vger.kernel.org>
CC:     'Marcelo Ricardo Leitner' <marcelo.leitner@gmail.com>
Subject: [PATCH v2] net: sctp: Fix negotiation of the number of data streams.
Thread-Topic: [PATCH v2] net: sctp: Fix negotiation of the number of data
 streams.
Thread-Index: AdZ2Jpt5uFDQ+GlJS8asoZmPH8fG2QAD/p2w
Date:   Wed, 19 Aug 2020 14:40:52 +0000
Message-ID: <1f2ffcb1180e4080aab114683b06efab@AcuMS.aculab.com>
References: <3aef12f2fdbb4ee6b885719f5561a997@AcuMS.aculab.com>
In-Reply-To: <3aef12f2fdbb4ee6b885719f5561a997@AcuMS.aculab.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=C51A453 smtp.mailfrom=david.laight@aculab.com
X-Mimecast-Spam-Score: 0.002
X-Mimecast-Originator: aculab.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpUaGUgbnVtYmVyIG9mIG91dHB1dCBhbmQgaW5wdXQgc3RyZWFtcyB3YXMgbmV2ZXIgYmVpbmcg
cmVkdWNlZCwgZWcgd2hlbg0KcHJvY2Vzc2luZyByZWNlaXZlZCBJTklUIG9yIElOSVRfQUNLIGNo
dW5rcy4NClRoZSBlZmZlY3QgaXMgdGhhdCBEQVRBIGNodW5rcyBjYW4gYmUgc2VudCB3aXRoIGlu
dmFsaWQgc3RyZWFtIGlkcw0KYW5kIHRoZW4gZGlzY2FyZGVkIGJ5IHRoZSByZW1vdGUgc3lzdGVt
Lg0KDQpGaXhlczogMjA3NWU1MGNhZjVlYSAoInNjdHA6IGNvbnZlcnQgdG8gZ2VucmFkaXgiKQ0K
U2lnbmVkLW9mZi1ieTogRGF2aWQgTGFpZ2h0IDxkYXZpZC5sYWlnaHRAYWN1bGFiLmNvbT4NCi0t
LQ0KIG5ldC9zY3RwL3N0cmVhbS5jIHwgNiArKysrLS0NCiAxIGZpbGUgY2hhbmdlZCwgNCBpbnNl
cnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQ0KDQpUaGlzIG5lZWRzIGJhY2twb3J0aW5nIHRvIDUu
MSBhbmQgYWxsIGxhdGVyIGtlcm5lbHMuDQoNCihSZXNlbmQgd2l0aG91dCB0aGUgUkU6KQ0KDQpD
aGFuZ2VzIHNpbmNlIHYxOg0KLSBGaXggJ0ZpeGVzJyB0YWcuDQotIEltcHJvdmUgZGVzY3JpcHRp
b24uDQoNCmRpZmYgLS1naXQgYS9uZXQvc2N0cC9zdHJlYW0uYyBiL25ldC9zY3RwL3N0cmVhbS5j
DQppbmRleCBiZGEyNTM2ZGQ3NDAuLjZkYzk1ZGNjMGZmNCAxMDA2NDQNCi0tLSBhL25ldC9zY3Rw
L3N0cmVhbS5jDQorKysgYi9uZXQvc2N0cC9zdHJlYW0uYw0KQEAgLTg4LDEyICs4OCwxMyBAQCBz
dGF0aWMgaW50IHNjdHBfc3RyZWFtX2FsbG9jX291dChzdHJ1Y3Qgc2N0cF9zdHJlYW0gKnN0cmVh
bSwgX191MTYgb3V0Y250LA0KIAlpbnQgcmV0Ow0KIA0KIAlpZiAob3V0Y250IDw9IHN0cmVhbS0+
b3V0Y250KQ0KLQkJcmV0dXJuIDA7DQorCQlnb3RvIG91dDsNCiANCiAJcmV0ID0gZ2VucmFkaXhf
cHJlYWxsb2MoJnN0cmVhbS0+b3V0LCBvdXRjbnQsIGdmcCk7DQogCWlmIChyZXQpDQogCQlyZXR1
cm4gcmV0Ow0KIA0KK291dDoNCiAJc3RyZWFtLT5vdXRjbnQgPSBvdXRjbnQ7DQogCXJldHVybiAw
Ow0KIH0NCkBAIC0xMDQsMTIgKzEwNSwxMyBAQCBzdGF0aWMgaW50IHNjdHBfc3RyZWFtX2FsbG9j
X2luKHN0cnVjdCBzY3RwX3N0cmVhbSAqc3RyZWFtLCBfX3UxNiBpbmNudCwNCiAJaW50IHJldDsN
CiANCiAJaWYgKGluY250IDw9IHN0cmVhbS0+aW5jbnQpDQotCQlyZXR1cm4gMDsNCisJCWdvdG8g
b3V0Ow0KIA0KIAlyZXQgPSBnZW5yYWRpeF9wcmVhbGxvYygmc3RyZWFtLT5pbiwgaW5jbnQsIGdm
cCk7DQogCWlmIChyZXQpDQogCQlyZXR1cm4gcmV0Ow0KIA0KK291dDoNCiAJc3RyZWFtLT5pbmNu
dCA9IGluY250Ow0KIAlyZXR1cm4gMDsNCiB9DQotLSANCjIuMjUuMQ0KDQotDQpSZWdpc3RlcmVk
IEFkZHJlc3MgTGFrZXNpZGUsIEJyYW1sZXkgUm9hZCwgTW91bnQgRmFybSwgTWlsdG9uIEtleW5l
cywgTUsxIDFQVCwgVUsNClJlZ2lzdHJhdGlvbiBObzogMTM5NzM4NiAoV2FsZXMpDQo=

