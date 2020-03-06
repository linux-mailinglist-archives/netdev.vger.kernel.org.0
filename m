Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA6B517C3EF
	for <lists+netdev@lfdr.de>; Fri,  6 Mar 2020 18:12:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726178AbgCFRML (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Mar 2020 12:12:11 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([146.101.78.151]:22254 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725873AbgCFRMK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Mar 2020 12:12:10 -0500
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mtapsc-5-c3Bavw6COZ-8ovkLX687wA-1; Fri, 06 Mar 2020 17:12:06 +0000
X-MC-Unique: c3Bavw6COZ-8ovkLX687wA-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Fri, 6 Mar 2020 17:12:06 +0000
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Fri, 6 Mar 2020 17:12:06 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Eric Dumazet' <eric.dumazet@gmail.com>,
        'Willem de Bruijn' <willemdebruijn.kernel@gmail.com>,
        Yadu Kishore <kyk.segfault@gmail.com>
CC:     David Miller <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>
Subject: RE: [PATCH v2] net: Make skb_segment not to compute checksum if
 network controller supports checksumming
Thread-Topic: [PATCH v2] net: Make skb_segment not to compute checksum if
 network controller supports checksumming
Thread-Index: AQHV8G6boeAUqLyQLkCRyXn9e/JzBKg1V/WQgAE/qgCAAAaz0IADkSRugAAGsUCAAA2BgIAABmFw
Date:   Fri, 6 Mar 2020 17:12:05 +0000
Message-ID: <e8b84bcaee634b53bee797aa041824a4@AcuMS.aculab.com>
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
In-Reply-To: <91fafe40-7856-8b22-c279-55df5d06ca39@gmail.com>
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

RnJvbTogRXJpYyBEdW1hemV0DQo+IFNlbnQ6IDA1IE1hcmNoIDIwMjAgMTc6MjANCj4gDQo+IE9u
IDMvNS8yMCA5OjAwIEFNLCBEYXZpZCBMYWlnaHQgd3JvdGU6DQo+ID4gRnJvbTogV2lsbGVtIGRl
IEJydWlqbg0KPiA+PiBTZW50OiAwNSBNYXJjaCAyMDIwIDE2OjA3DQo+ID4gLi4NCj4gPj4gSXQg
c2VlbXMgZG9fY3N1bSBpcyBjYWxsZWQgYmVjYXVzZSBjc3VtX3BhcnRpYWxfY29weSBleGVjdXRl
cyB0aGUNCj4gPj4gdHdvIG9wZXJhdGlvbnMgaW5kZXBlbmRlbnRseToNCj4gPj4NCj4gPj4gX193
c3VtDQo+ID4+IGNzdW1fcGFydGlhbF9jb3B5KGNvbnN0IHZvaWQgKnNyYywgdm9pZCAqZHN0LCBp
bnQgbGVuLCBfX3dzdW0gc3VtKQ0KPiA+PiB7DQo+ID4+ICAgICAgICAgbWVtY3B5KGRzdCwgc3Jj
LCBsZW4pOw0KPiA+PiAgICAgICAgIHJldHVybiBjc3VtX3BhcnRpYWwoZHN0LCBsZW4sIHN1bSk7
DQo+ID4+IH0NCj4gPg0KPiA+IEFuZCBkb19jc3VtKCkgaXMgc3VwZXJibHkgaG9ycmlkLg0KPiA+
IE5vdCB0aGUgbGVhc3QgYmVjYXVzZSBpdCBpcyAzMmJpdCBvbiA2NGJpdCBzeXN0ZW1zLg0KPiAN
Cj4gVGhlcmUgYXJlIG1hbnkgdmVyc2lvbnMsIHdoaWNoIG9uZSBpcyBkaXNjdXNzZWQgaGVyZSA/
DQo+IA0KPiBBdCBsZWFzdCB0aGUgY3VycmVudCBvbmUgc2VlbXMgdG8gYmUgNjRiaXQgb3B0aW1p
emVkLg0KPiANCj4gaHR0cHM6Ly9naXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9n
aXQvdG9ydmFsZHMvbGludXguZ2l0L2NvbW1pdC8/aWQ9NTc3N2VhZWQ1NjZhMWQ2M2UzNDRkM2Rk
DQo+IDhmMmI1ZTMzYmUyMDY0M2UNCg0KSSB3YXMgbG9va2luZyBhdCB0aGUgZ2VuZXJpYyBvbmUg
aW4gJChTUkMpL2xpYi9jaGVja3N1bS5jLg0KDQpGV0lXIEkgc3VzcGVjdCB0aGUgZmFzdGVzdCBj
b2RlIG9uIHByZSBzYW5keSBicmlkZ2UgNjRiaXQgaW50ZWwgY3B1cw0KKHdoZXJlIGFkYyBpcyAy
IGNsb2NrcykgaXMgdG8gZG8gYSBub3JtYWwgJ2FkZCcsIHNoaWZ0IHRoZSBjYXJyaWVzDQppbnRv
IGEgNjRiaXQgcmVnaXN0ZXIgYW5kIGRvIGEgc29mdHdhcmUgJ3BvcGNudCcgZXZlcnkgNTEyIGJ5
dGVzLg0KVGhhdCBtYXkgcnVuIGF0IDggYnl0ZXMvY2xvY2sgKyB0aGUgcG9wY250Lg0KDQoJRGF2
aWQNCg0KLQ0KUmVnaXN0ZXJlZCBBZGRyZXNzIExha2VzaWRlLCBCcmFtbGV5IFJvYWQsIE1vdW50
IEZhcm0sIE1pbHRvbiBLZXluZXMsIE1LMSAxUFQsIFVLDQpSZWdpc3RyYXRpb24gTm86IDEzOTcz
ODYgKFdhbGVzKQ0K

