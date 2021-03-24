Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57CCD347655
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 11:40:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235451AbhCXKkE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 06:40:04 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.86.151]:23913 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233878AbhCXKkB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Mar 2021 06:40:01 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-129-cK_RaveBM8aprN2x6jOm4g-1; Wed, 24 Mar 2021 10:39:58 +0000
X-MC-Unique: cK_RaveBM8aprN2x6jOm4g-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.2; Wed, 24 Mar 2021 10:39:57 +0000
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.012; Wed, 24 Mar 2021 10:39:57 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     David Laight <David.Laight@ACULAB.COM>,
        'Martin Sebor' <msebor@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Arnd Bergmann <arnd@kernel.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Martin Sebor" <msebor@gcc.gnu.org>, Ning Sun <ning.sun@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "x86@kernel.org" <x86@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Simon Kelley <simon@thekelleys.org.uk>,
        James Smart <james.smart@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Anders Larsen <al@alarsen.net>, Tejun Heo <tj@kernel.org>,
        Serge Hallyn <serge@hallyn.com>,
        Imre Deak <imre.deak@intel.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "tboot-devel@lists.sourceforge.net" 
        <tboot-devel@lists.sourceforge.net>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "ath11k@lists.infradead.org" <ath11k@lists.infradead.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>,
        "linux-security-module@vger.kernel.org" 
        <linux-security-module@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Will Deacon <will@kernel.org>
Subject: RE: [PATCH 02/11] x86: tboot: avoid Wstringop-overread-warning
Thread-Topic: [PATCH 02/11] x86: tboot: avoid Wstringop-overread-warning
Thread-Index: AQHXH2fn7jNrPkUb50e9k3rL2a+D9qqS2/oQgAAX0+A=
Date:   Wed, 24 Mar 2021 10:39:57 +0000
Message-ID: <7e05de6cbb554b09ac532c073fab7386@AcuMS.aculab.com>
References: <20210322160253.4032422-1-arnd@kernel.org>
 <20210322160253.4032422-3-arnd@kernel.org>
 <20210322202958.GA1955909@gmail.com>
 <b944a853-0e4b-b767-0175-cc2c1edba759@gmail.com>
 <0aa198a1dd904231bcc29454bf19a812@AcuMS.aculab.com>
In-Reply-To: <0aa198a1dd904231bcc29454bf19a812@AcuMS.aculab.com>
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

RnJvbTogRGF2aWQgTGFpZ2h0DQo+IFNlbnQ6IDI0IE1hcmNoIDIwMjEgMDk6MTINCj4gDQo+IEZy
b206IE1hcnRpbiBTZWJvcg0KPiA+IFNlbnQ6IDIyIE1hcmNoIDIwMjEgMjI6MDgNCj4gLi4uDQo+
ID4gSW4gR0NDIDExLCBhbGwgYWNjZXNzIHdhcm5pbmdzIGV4cGVjdCBvYmplY3RzIHRvIGJlIGVp
dGhlciBkZWNsYXJlZA0KPiA+IG9yIGFsbG9jYXRlZC4gIFBvaW50ZXJzIHdpdGggY29uc3RhbnQg
dmFsdWVzIGFyZSB0YWtlbiB0byBwb2ludCB0bw0KPiA+IG5vdGhpbmcgdmFsaWQgKGFzIEFybmQg
bWVudGlvbmVkIGFib3ZlLCB0aGlzIGlzIHRvIGRldGVjdCBpbnZhbGlkDQo+ID4gYWNjZXNzZXMg
dG8gbWVtYmVycyBvZiBzdHJ1Y3RzIGF0IGFkZHJlc3MgemVybykuDQo+ID4NCj4gPiBPbmUgcG9z
c2libGUgc29sdXRpb24gdG8gdGhlIGtub3duIGFkZHJlc3MgcHJvYmxlbSBpcyB0byBleHRlbmQg
R0NDDQo+ID4gYXR0cmlidXRlcyBhZGRyZXNzIGFuZCBpbyB0aGF0IHBpbiBhbiBvYmplY3QgdG8g
YSBoYXJkd2lyZWQgYWRkcmVzcw0KPiA+IHRvIGFsbCB0YXJnZXRzIChhdCB0aGUgbW9tZW50IHRo
ZXkncmUgc3VwcG9ydGVkIG9uIGp1c3Qgb25lIG9yIHR3bw0KPiA+IHRhcmdldHMpLiAgSSdtIG5v
dCBzdXJlIHRoaXMgY2FuIHN0aWxsIGhhcHBlbiBiZWZvcmUgR0NDIDExIHJlbGVhc2VzDQo+ID4g
c29tZXRpbWUgaW4gQXByaWwgb3IgTWF5Lg0KPiANCj4gQSBkaWZmZXJlbnQgc29sdXRpb24gaXMg
dG8gZGVmaW5lIGEgbm9ybWFsIEMgZXh0ZXJuYWwgZGF0YSBpdGVtDQo+IGFuZCB0aGVuIGFzc2ln
biBhIGZpeGVkIGFkZHJlc3Mgd2l0aCBhbiBhc20gc3RhdGVtZW50IG9yIGluDQo+IHRoZSBsaW5r
ZXIgc2NyaXB0Lg0KDQpPciBzdG9wIGdjYyB0cmFja2luZyB0aGUgdmFsdWUgYnkgdXNpbmc6DQoJ
c3RydWN0IGZvbyAqZm9vID0gKHZvaWQgKil4eHh4eDsNCglhc20gKCIiLCAiK3IiIChmb28pKTsN
Cg0KSWYgdGhlIGFkZHJlc3MgaXMgdXNlZCBtb3JlIHRoYW4gb25jZSBmb3JjaW5nIGl0IGludG8N
CmEgcmVnaXN0ZXIgaXMgYWxzbyBsaWtlbHkgdG8gZ2VuZXJhdGUgYmV0dGVyIGNvZGUuDQoNCglE
YXZpZA0KDQotDQpSZWdpc3RlcmVkIEFkZHJlc3MgTGFrZXNpZGUsIEJyYW1sZXkgUm9hZCwgTW91
bnQgRmFybSwgTWlsdG9uIEtleW5lcywgTUsxIDFQVCwgVUsNClJlZ2lzdHJhdGlvbiBObzogMTM5
NzM4NiAoV2FsZXMpDQo=

