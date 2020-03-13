Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D3731848BF
	for <lists+netdev@lfdr.de>; Fri, 13 Mar 2020 15:04:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726838AbgCMOEh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 10:04:37 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:30216 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726715AbgCMOEh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Mar 2020 10:04:37 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-134-_2vTalQWPdiJaX_d4cyfRg-1; Fri, 13 Mar 2020 14:04:33 +0000
X-MC-Unique: _2vTalQWPdiJaX_d4cyfRg-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Fri, 13 Mar 2020 14:04:32 +0000
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Fri, 13 Mar 2020 14:04:32 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Willem de Bruijn' <willemdebruijn.kernel@gmail.com>,
        Yadu Kishore <kyk.segfault@gmail.com>
CC:     David Miller <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Network Development <netdev@vger.kernel.org>
Subject: RE: [PATCH v2] net: Make skb_segment not to compute checksum if
 network controller supports checksumming
Thread-Topic: [PATCH v2] net: Make skb_segment not to compute checksum if
 network controller supports checksumming
Thread-Index: AQHV8G6boeAUqLyQLkCRyXn9e/JzBKg1V/WQgAE/qgCAAAaz0IADkSRugAAGsUCAAA2BgIAABmFwgAxUGeSAAAFR8A==
Date:   Fri, 13 Mar 2020 14:04:32 +0000
Message-ID: <9c1768ab119241168ecac9879b24d022@AcuMS.aculab.com>
References: <20200228.120150.302053489768447737.davem@davemloft.net>
 <1583131910-29260-1-git-send-email-kyk.segfault@gmail.com>
 <CABGOaVRdsw=4nqBMR0h8JPEiunOEpHR+02H=HRbgt_TxhVviiA@mail.gmail.com>
 <945f6cafc86b4f1bb18fa40e60d5c113@AcuMS.aculab.com>
 <CABGOaVQMq-AxwQOJ5DdDY6yLBOXqBg6G7qC_MdOYj_z4y-QQiw@mail.gmail.com>
 <de1012794ec54314b6fe790c01dee60b@AcuMS.aculab.com>
 <CABGOaVSddVL-T-Sz_GPuRoZbKM_HsZND84rJUm2G9RRw6cUwCQ@mail.gmail.com>
 <CA+FuTSc5QVF_kv8FNs03obXGbf6axrG5umCipE=LXvqQ_-hDAA@mail.gmail.com>
 <817a6418ac8742e6bb872992711beb47@AcuMS.aculab.com>
 <91fafe40-7856-8b22-c279-55df5d06ca39@gmail.com>
 <e8b84bcaee634b53bee797aa041824a4@AcuMS.aculab.com>
 <CABGOaVTzjJengG0e8AWFZE9ZG1245keuQHfRJ0zpoAMQrNmJ6g@mail.gmail.com>
 <CA+FuTSfO-kNWd0qzuUsCyDjad0dVJEdLh9x4bfRzMYs9wdqQ=g@mail.gmail.com>
In-Reply-To: <CA+FuTSfO-kNWd0qzuUsCyDjad0dVJEdLh9x4bfRzMYs9wdqQ=g@mail.gmail.com>
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

PiBPbiBGcmksIE1hciAxMywgMjAyMCBhdCAyOjM2IEFNIFlhZHUgS2lzaG9yZSA8a3lrLnNlZ2Zh
dWx0QGdtYWlsLmNvbT4gd3JvdGU6DQo+ID4NCj4gPiA+IFllcywgZ2l2ZW4gdGhlIGRpc2N1c3Np
b24gSSBoYXZlIG5vIG9iamVjdGlvbnMuIFRoZSBjaGFuZ2UgdG8NCj4gPiA+IHNrYl9zZWdtZW50
IGluIHYyIGxvb2sgZmluZS4NCj4gPg0KPiA+IEknbSBhc3N1bWluZyB0aGF0IHRoZSBjaGFuZ2Vz
IGluIHBhdGNoIFYyIGFyZSBvayB0byBiZSBhY2NlcHRlZCBhbmQgbWVyZ2VkDQo+ID4gdG8gdGhl
IGtlcm5lbC4gUGxlYXNlIGxldCBtZSBrbm93IGlmIHRoZXJlIGlzIGFueXRoaW5nIGVsc2UgdGhh
dCBpcyBwZW5kaW5nDQo+ID4gZnJvbSBteSBzaWRlIHdpdGggcmVzcGVjdCB0byB0aGUgcGF0Y2gu
DQo+IA0KPiBJIHRoaW5rIHlvdSBjYW4gcmViYXNlIGFuZCBzdWJtaXQgYWdhaW5zdCBuZXQtbmV4
dC4NCg0KSXQncyBhbHNvIHdvcnRoIG1lbnRpb25pbmcgKHByb2JhYmx5IGluIDAvbikgdGhhdA0K
dGhpcyBpcyBsaWtlbHkgdG8gYmUgYSBnYWluIGV2ZW4gb24geDg2IHdoZXJlIHRoZQ0KY2hlY2tz
dW0gaXMgY2FsY3VsYXRlZCBkdXJpbmcgdGhlIGNvcHkgbG9vcC4NCg0KCURhdmlkDQoNCi0NClJl
Z2lzdGVyZWQgQWRkcmVzcyBMYWtlc2lkZSwgQnJhbWxleSBSb2FkLCBNb3VudCBGYXJtLCBNaWx0
b24gS2V5bmVzLCBNSzEgMVBULCBVSw0KUmVnaXN0cmF0aW9uIE5vOiAxMzk3Mzg2IChXYWxlcykN
Cg==

