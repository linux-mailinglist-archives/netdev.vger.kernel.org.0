Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B44EB17AB11
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 18:00:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725993AbgCERAO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 12:00:14 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([146.101.78.151]:31077 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725963AbgCERAN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Mar 2020 12:00:13 -0500
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-211-1jXJio57OsalL-63kT383Q-1; Thu, 05 Mar 2020 17:00:10 +0000
X-MC-Unique: 1jXJio57OsalL-63kT383Q-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Thu, 5 Mar 2020 17:00:09 +0000
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Thu, 5 Mar 2020 17:00:09 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Willem de Bruijn' <willemdebruijn.kernel@gmail.com>,
        Yadu Kishore <kyk.segfault@gmail.com>
CC:     David Miller <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>
Subject: RE: [PATCH v2] net: Make skb_segment not to compute checksum if
 network controller supports checksumming
Thread-Topic: [PATCH v2] net: Make skb_segment not to compute checksum if
 network controller supports checksumming
Thread-Index: AQHV8G6boeAUqLyQLkCRyXn9e/JzBKg1V/WQgAE/qgCAAAaz0IADkSRugAAGsUA=
Date:   Thu, 5 Mar 2020 17:00:09 +0000
Message-ID: <817a6418ac8742e6bb872992711beb47@AcuMS.aculab.com>
References: <20200228.120150.302053489768447737.davem@davemloft.net>
 <1583131910-29260-1-git-send-email-kyk.segfault@gmail.com>
 <CABGOaVRdsw=4nqBMR0h8JPEiunOEpHR+02H=HRbgt_TxhVviiA@mail.gmail.com>
 <945f6cafc86b4f1bb18fa40e60d5c113@AcuMS.aculab.com>
 <CABGOaVQMq-AxwQOJ5DdDY6yLBOXqBg6G7qC_MdOYj_z4y-QQiw@mail.gmail.com>
 <de1012794ec54314b6fe790c01dee60b@AcuMS.aculab.com>
 <CABGOaVSddVL-T-Sz_GPuRoZbKM_HsZND84rJUm2G9RRw6cUwCQ@mail.gmail.com>
 <CA+FuTSc5QVF_kv8FNs03obXGbf6axrG5umCipE=LXvqQ_-hDAA@mail.gmail.com>
In-Reply-To: <CA+FuTSc5QVF_kv8FNs03obXGbf6axrG5umCipE=LXvqQ_-hDAA@mail.gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogV2lsbGVtIGRlIEJydWlqbg0KPiBTZW50OiAwNSBNYXJjaCAyMDIwIDE2OjA3DQouLg0K
PiBJdCBzZWVtcyBkb19jc3VtIGlzIGNhbGxlZCBiZWNhdXNlIGNzdW1fcGFydGlhbF9jb3B5IGV4
ZWN1dGVzIHRoZQ0KPiB0d28gb3BlcmF0aW9ucyBpbmRlcGVuZGVudGx5Og0KPiANCj4gX193c3Vt
DQo+IGNzdW1fcGFydGlhbF9jb3B5KGNvbnN0IHZvaWQgKnNyYywgdm9pZCAqZHN0LCBpbnQgbGVu
LCBfX3dzdW0gc3VtKQ0KPiB7DQo+ICAgICAgICAgbWVtY3B5KGRzdCwgc3JjLCBsZW4pOw0KPiAg
ICAgICAgIHJldHVybiBjc3VtX3BhcnRpYWwoZHN0LCBsZW4sIHN1bSk7DQo+IH0NCg0KQW5kIGRv
X2NzdW0oKSBpcyBzdXBlcmJseSBob3JyaWQuDQpOb3QgdGhlIGxlYXN0IGJlY2F1c2UgaXQgaXMg
MzJiaXQgb24gNjRiaXQgc3lzdGVtcy4NCg0KQSBiZXR0ZXIgaW5uZXIgbG9vcCAoZXZlbiBvbiAz
MmJpdCkgd291bGQgYmU6DQoJdTY0IHJlc3VsdCA9IDA7IC8vIGJldHRlciBvbGQgJ3N1bScgdGhl
IGNhbGxlciB3YW50cyB0byBhZGQgaW4uDQoJLi4uDQoJZG8gew0KCQlyZXN1bHQgKz0gKih1MzIg
KilidWZmOw0KCQlidWZmICs9IDQ7DQoJfSB3aGlsZSAoYnVmZiA8IGVuZCk7DQoNCihUaGF0IGlz
IGFzIGZhc3QgYXMgdGhlIHg4NiAnYWRjJyBsb29wIG9uIGludGVsIHg4NiBjcHVzDQpwcmlvciB0
byBIYXN3ZWxsISkNClR3ZWFraW5nIHRoZSBhYm92ZSBtaWdodCBjYXVzZSBnY2MgdG8gZ2VuZXJh
dGUgY29kZSB0aGF0DQpleGVjdXRlcyBvbmUgaXRlcmF0aW9uIHBlciBjbG9jayBvbiBzb21lIHN1
cGVyc2NhbGVyIGNwdXMuDQpBZGRpbmcgYWx0ZXJuYXRlIHdvcmRzIHRvIGRpZmZlcmVudCByZWdp
c3RlcnMgbWF5IGJlDQpiZW5lZmljaWFsIG9uIGNwdXMgdGhhdCBjYW4gZG8gdHdvIG1lbW9yeSBy
ZWFkcyBpbiAxIGNsb2NrLg0KDQpUaGVuIHJlZHVjZSBmcm9tIDY0Yml0cyBkb3duIHRvIDE2LiBN
YXliZSB3aXRoOg0KCWlmIChvZGQpDQoJCXJlc3VsdCA8PD0gODsNCglyZXN1bHQgPSAodTMyKXJl
c3VsdCArIChyZXN1bHQgPj4gMzIpOw0KCXJlc3VsdDMyID0gKHUxNilyZXN1bHQgKyAocmVzdWx0
ID4+IDE2KTsNCglyZXN1bHQzMiA9ICh1MTYpcmVzdWx0MzIgKyAocmVzdWx0MzIgPj4gMTYpOw0K
CXJlc3VsdDMyID0gKHUxNilyZXN1bHQzMiArIChyZXN1bHQzMiA+PiAxNik7DQpJIHRoaW5rIHlv
dSBuZWVkIDQgcmVkdWNlcy4NCk1vZHVsbyAweGZmZmYgbWlnaHQgZ2VuZXJhdGUgZmFzdGVyIGNv
ZGUsIGJ1dCB0aGUgcmVzdWx0IGRvbWFpbg0KaXMgdGhlbiAwLi4weGZmZmUgbm90IDEuLjB4ZmZm
Zi4NCldoaWNoIGlzIGFjdHVhbGx5IGJldHRlciBiZWNhdXNlIGl0IGlzIGNvcnJlY3Qgd2hlbiBp
bnZlcnRlZC4NCg0KSWYgcmVkdWNpbmcgd2l0aCBhZGRzLCBpdCBpcyBiZXN0IHRvIGluaXRpYWxp
c2UgdGhlIGNzdW0gdG8gMS4NClRoZW4gYWRkIDEgYWZ0ZXIgaW52ZXJ0aW5nLg0KDQoJRGF2aWQN
Cg0KLQ0KUmVnaXN0ZXJlZCBBZGRyZXNzIExha2VzaWRlLCBCcmFtbGV5IFJvYWQsIE1vdW50IEZh
cm0sIE1pbHRvbiBLZXluZXMsIE1LMSAxUFQsIFVLDQpSZWdpc3RyYXRpb24gTm86IDEzOTczODYg
KFdhbGVzKQ0K

