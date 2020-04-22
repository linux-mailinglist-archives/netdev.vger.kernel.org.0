Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8B2C1B3A3A
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 10:35:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726482AbgDVIf3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 04:35:29 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([146.101.78.151]:34186 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726154AbgDVIf2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 04:35:28 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-215-Rc3bmRY2MJO0palgJOyylw-1; Wed, 22 Apr 2020 09:35:24 +0100
X-MC-Unique: Rc3bmRY2MJO0palgJOyylw-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Wed, 22 Apr 2020 09:35:23 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Wed, 22 Apr 2020 09:35:23 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Eric Dumazet' <eric.dumazet@gmail.com>,
        Nate Karstens <nate.karstens@garmin.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "Jeff Layton" <jlayton@kernel.org>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        "Arnd Bergmann" <arnd@arndb.de>,
        Richard Henderson <rth@twiddle.net>,
        "Ivan Kokshaysky" <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Helge Deller <deller@gmx.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-alpha@vger.kernel.org" <linux-alpha@vger.kernel.org>,
        "linux-parisc@vger.kernel.org" <linux-parisc@vger.kernel.org>,
        "sparclinux@vger.kernel.org" <sparclinux@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     Changli Gao <xiaosuo@gmail.com>
Subject: RE: [PATCH 1/4] fs: Implement close-on-fork
Thread-Topic: [PATCH 1/4] fs: Implement close-on-fork
Thread-Index: AQHWFv4Vssv9Cm82zkePzv5DmgsrOaiE0vEQ
Date:   Wed, 22 Apr 2020 08:35:23 +0000
Message-ID: <39a872f23b16405fb4e4683bf049beef@AcuMS.aculab.com>
References: <20200420071548.62112-1-nate.karstens@garmin.com>
 <20200420071548.62112-2-nate.karstens@garmin.com>
 <36dce9b4-a0bf-0015-f6bc-1006938545b1@gmail.com>
In-Reply-To: <36dce9b4-a0bf-0015-f6bc-1006938545b1@gmail.com>
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

RnJvbTogRXJpYyBEdW1hemV0DQo+IFNlbnQ6IDIwIEFwcmlsIDIwMjAgMTE6MjYNCj4gT24gNC8y
MC8yMCAxMjoxNSBBTSwgTmF0ZSBLYXJzdGVucyB3cm90ZToNCj4gPiBUaGUgY2xvc2Utb24tZm9y
ayBmbGFnIGNhdXNlcyB0aGUgZmlsZSBkZXNjcmlwdG9yIHRvIGJlIGNsb3NlZA0KPiA+IGF0b21p
Y2FsbHkgaW4gdGhlIGNoaWxkIHByb2Nlc3MgYmVmb3JlIHRoZSBjaGlsZCBwcm9jZXNzIHJldHVy
bnMNCj4gPiBmcm9tIGZvcmsoKS4gSW1wbGVtZW50IHRoaXMgZmVhdHVyZSBhbmQgcHJvdmlkZSBh
IG1ldGhvZCB0bw0KPiA+IGdldC9zZXQgdGhlIGNsb3NlLW9uLWZvcmsgZmxhZyB1c2luZyBmY250
bCgyKS4NCj4gPg0KPiA+IFRoaXMgZnVuY3Rpb25hbGl0eSB3YXMgYXBwcm92ZWQgYnkgdGhlIEF1
c3RpbiBDb21tb24gU3RhbmRhcmRzDQo+ID4gUmV2aXNpb24gR3JvdXAgZm9yIGluY2x1c2lvbiBp
biB0aGUgbmV4dCByZXZpc2lvbiBvZiB0aGUgUE9TSVgNCj4gPiBzdGFuZGFyZCAoc2VlIGlzc3Vl
IDEzMTggaW4gdGhlIEF1c3RpbiBHcm91cCBEZWZlY3QgVHJhY2tlcikuDQo+IA0KPiBPaCB3ZWxs
Li4uIHlldCBhbm90aGVyIGZlYXR1cmUgc2xvd2luZyBkb3duIGEgY3JpdGljYWwgcGF0aC4NCi4u
Lg0KPiBJIHN1Z2dlc3Qgd2UgZ3JvdXAgdGhlIHR3byBiaXRzIG9mIGEgZmlsZSAoY2xvc2Vfb25f
ZXhlYywgY2xvc2Vfb25fZm9yaykgdG9nZXRoZXIsDQo+IHNvIHRoYXQgd2UgZG8gbm90IGhhdmUg
dG8gZGlydHkgdHdvIHNlcGFyYXRlIGNhY2hlIGxpbmVzLg0KPiANCj4gT3RoZXJ3aXNlIHdlIHdp
bGwgYWRkIHlldCBhbm90aGVyIGNhY2hlIGxpbmUgbWlzcyBhdCBldmVyeSBmaWxlIG9wZW5pbmcv
Y2xvc2luZyBmb3IgcHJvY2Vzc2VzDQo+IHdpdGggYmlnIGZpbGUgdGFibGVzLg0KDQpIb3cgYWJv
dXQgb25seSBhbGxvY2F0aW5nIHRoZSAnY2xvc2Ugb24gZm9yaycgYml0bWFwIHRoZSBmaXJzdCB0
aW1lDQphIHByb2Nlc3Mgc2V0cyBhIGJpdCBpbiBpdD8NCg0KT2ZmIGhhbmQgSSBjYW4ndCBpbWFn
aW5lIHRoZSB1c2UgY2FzZS4NCkkgdGhvdWdodCBwb3NpeCBhbHdheXMgc2hhcmVkIGZkIHRhYmxl
cyBhY3Jvc3MgZm9yaygpLg0KDQoJRGF2aWQNCg0KLQ0KUmVnaXN0ZXJlZCBBZGRyZXNzIExha2Vz
aWRlLCBCcmFtbGV5IFJvYWQsIE1vdW50IEZhcm0sIE1pbHRvbiBLZXluZXMsIE1LMSAxUFQsIFVL
DQpSZWdpc3RyYXRpb24gTm86IDEzOTczODYgKFdhbGVzKQ0K

