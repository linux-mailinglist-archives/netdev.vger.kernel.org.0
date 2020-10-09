Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF0A928855E
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 10:34:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732404AbgJIIeU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 04:34:20 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.86.151]:33525 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732438AbgJIIeT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Oct 2020 04:34:19 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-45-6ee0yc2ZNTSKAf5vApMkGg-1; Fri, 09 Oct 2020 09:34:16 +0100
X-MC-Unique: 6ee0yc2ZNTSKAf5vApMkGg-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Fri, 9 Oct 2020 09:34:14 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Fri, 9 Oct 2020 09:34:14 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Johannes Berg' <johannes@sipsolutions.net>,
        Greg KH <gregkh@linuxfoundation.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "nstange@suse.de" <nstange@suse.de>,
        "ap420073@gmail.com" <ap420073@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "rafael@kernel.org" <rafael@kernel.org>
Subject: RE: [CRAZY-RFF] debugfs: track open files and release on remove
Thread-Topic: [CRAZY-RFF] debugfs: track open files and release on remove
Thread-Index: AQHWnhTYAkCadt4V/kCnonv0tSsTz6mO7mnQ
Date:   Fri, 9 Oct 2020 08:34:14 +0000
Message-ID: <03c42bb5f57a4c3d9c782a023add28cd@AcuMS.aculab.com>
References: <87v9fkgf4i.fsf@suse.de>
         <20201009095306.0d87c3aa13db.Ib3a7019bff15bb6308f6d259473a1648312a4680@changeid>
         <20201009080355.GA398994@kroah.com>
         <be61c6a38d0f6ca1aa0bc3f0cb45bbb216a12982.camel@sipsolutions.net>
         <20201009081624.GA401030@kroah.com>
 <1ec056cf3ec0953d2d1abaa05e37e89b29c7cc63.camel@sipsolutions.net>
In-Reply-To: <1ec056cf3ec0953d2d1abaa05e37e89b29c7cc63.camel@sipsolutions.net>
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

RnJvbTogSm9oYW5uZXMgQmVyZw0KPiBTZW50OiAwOSBPY3RvYmVyIDIwMjAgMDk6MTkNCj4gDQo+
IE9uIEZyaSwgMjAyMC0xMC0wOSBhdCAxMDoxNiArMDIwMCwgR3JlZyBLSCB3cm90ZToNCj4gPiBP
biBGcmksIE9jdCAwOSwgMjAyMCBhdCAxMDowNjoxNEFNICswMjAwLCBKb2hhbm5lcyBCZXJnIHdy
b3RlOg0KPiA+ID4gV2UgdXNlZCB0byBzYXkgdGhlIHByb3h5X2ZvcHMgd2VyZW4ndCBuZWVkZWQg
YW5kIGl0IHdhc24ndCBhbiBpc3N1ZSwgYW5kDQo+ID4gPiB0aGVuIHN0aWxsIGltcGxlbWVudGVk
IGl0LiBEdW5uby4gSSdtIG5vdCByZWFsbHkgdG9vIGNvbmNlcm5lZCBhYm91dCBpdA0KPiA+ID4g
bXlzZWxmLCBvbmx5IHJvb3QgY2FuIGhvbGQgdGhlIGZpbGVzIG9wZW4gYW5kIHJlbW92ZSBtb2R1
bGVzIC4uLg0KPiA+DQo+ID4gcHJveHlfZm9wcyB3ZXJlIG5lZWRlZCBiZWNhdXNlIGRldmljZXMg
Y2FuIGJlIHJlbW92ZWQgZnJvbSB0aGUgc3lzdGVtIGF0DQo+ID4gYW55IHRpbWUsIGNhdXNpbmcg
dGhlaXIgZGVidWdmcyBmaWxlcyB0byB3YW50IHRvIGFsc28gYmUgcmVtb3ZlZC4gIEl0DQo+ID4g
d2Fzbid0IGJlY2F1c2Ugb2YgdW5sb2FkaW5nIGtlcm5lbCBjb2RlLg0KPiANCj4gSW5kZWVkLCB0
aGF0J3MgdHJ1ZS4gU3RpbGwsIHdlIGxpdmVkIHdpdGggaXQgZm9yIHllYXJzLg0KPiANCj4gQW55
d2F5LCBsaWtlIEkgc2FpZCwgSSByZWFsbHkganVzdCBkaWQgdGhpcyBtb3JlIHRvIHNlZSB0aGF0
IGl0IF9jb3VsZF8NCj4gYmUgZG9uZSwgbm90IHRvIHN1Z2dlc3QgdGhhdCBpdCBfc2hvdWxkXyA6
LSkNCj4gDQo+IEkgdGhpbmsgYWRkaW5nIHRoZSAub3duZXIgZXZlcnl3aGVyZSB3b3VsZCBiZSBn
b29kLCBhbmQgcGVyaGFwcyB3ZSBjYW4NCj4gc29tZWhvdyBwdXQgYSBjaGVjayBzb21ld2hlcmUg
bGlrZQ0KPiANCj4gCVdBUk5fT04oaXNfbW9kdWxlX2FkZHJlc3MoKHVuc2lnbmVkIGxvbmcpZm9w
cykgJiYgIWZvcHMtPm93bmVyKTsNCj4gDQo+IHRvIHByZXZlbnQgdGhlIGlzc3VlIGluIHRoZSBm
dXR1cmU/DQoNCkRvZXMgaXQgZXZlciBtYWtlIGFueSBzZW5zZSB0byBzZXQgLm93bmVyIHRvIGFu
eXRoaW5nIG90aGVyIHRoYW4NClRISVNfTU9EVUxFPw0KDQpJZiBub3QgdGhlIGNvZGUgdGhhdCBz
YXZlcyB0aGUgJ3N0cnVjdCBmaWxlX29wZXJhdGlvbnMnIGFkZHJlc3MNCm91Z2h0IHRvIGJlIGFi
bGUgdG8gc2F2ZSB0aGUgYXNzb2NpYXRlZCBtb2R1bGUuDQoNCkkgd2FzIGFsc28gd29uZGVyaW5n
IGlmIHRoaXMgYWZmZWN0cyBub3JtYWwgb3BlbnM/DQpUaGV5IHNob3VsZCBob2xkIGEgcmVmZXJl
bmNlIG9uIHRoZSBtb2R1bGUgdG8gc3RvcCBpdCBiZWluZyB1bmxvYWRlZC4NCkRvZXMgdGhhdCBy
ZWx5IG9uIC5vd25lciBiZWluZyBzZXQ/DQoNCkZvciBkZWJ1Z2ZzIHN1cmVseSBpdCBpcyBwb3Nz
aWJsZSB0byBkZXRlcm1pbmUgYW5kIHNhdmUgVEhJU19NT0RVTEUNCndoZW4gaGUgbm9kZXMgYXJl
IHJlZ2lzdGVycyBhbmQgZG8gYSB0cnlfbW9kdWxlX2dldCgpIGluIHRoZSBvcGVuPw0KDQoJRGF2
aWQNCg0KLQ0KUmVnaXN0ZXJlZCBBZGRyZXNzIExha2VzaWRlLCBCcmFtbGV5IFJvYWQsIE1vdW50
IEZhcm0sIE1pbHRvbiBLZXluZXMsIE1LMSAxUFQsIFVLDQpSZWdpc3RyYXRpb24gTm86IDEzOTcz
ODYgKFdhbGVzKQ0K

