Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0A4434743A
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 10:13:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231566AbhCXJMd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 05:12:33 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.85.151]:33559 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234540AbhCXJMA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Mar 2021 05:12:00 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-70-F_iQyAaGNv6_r3BEezM2zQ-1; Wed, 24 Mar 2021 09:11:56 +0000
X-MC-Unique: F_iQyAaGNv6_r3BEezM2zQ-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.2; Wed, 24 Mar 2021 09:11:55 +0000
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.012; Wed, 24 Mar 2021 09:11:55 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Martin Sebor' <msebor@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        "Arnd Bergmann" <arnd@kernel.org>
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
Thread-Index: AQHXH2fn7jNrPkUb50e9k3rL2a+D9qqS2/oQ
Date:   Wed, 24 Mar 2021 09:11:55 +0000
Message-ID: <0aa198a1dd904231bcc29454bf19a812@AcuMS.aculab.com>
References: <20210322160253.4032422-1-arnd@kernel.org>
 <20210322160253.4032422-3-arnd@kernel.org>
 <20210322202958.GA1955909@gmail.com>
 <b944a853-0e4b-b767-0175-cc2c1edba759@gmail.com>
In-Reply-To: <b944a853-0e4b-b767-0175-cc2c1edba759@gmail.com>
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

RnJvbTogTWFydGluIFNlYm9yDQo+IFNlbnQ6IDIyIE1hcmNoIDIwMjEgMjI6MDgNCi4uLg0KPiBJ
biBHQ0MgMTEsIGFsbCBhY2Nlc3Mgd2FybmluZ3MgZXhwZWN0IG9iamVjdHMgdG8gYmUgZWl0aGVy
IGRlY2xhcmVkDQo+IG9yIGFsbG9jYXRlZC4gIFBvaW50ZXJzIHdpdGggY29uc3RhbnQgdmFsdWVz
IGFyZSB0YWtlbiB0byBwb2ludCB0bw0KPiBub3RoaW5nIHZhbGlkIChhcyBBcm5kIG1lbnRpb25l
ZCBhYm92ZSwgdGhpcyBpcyB0byBkZXRlY3QgaW52YWxpZA0KPiBhY2Nlc3NlcyB0byBtZW1iZXJz
IG9mIHN0cnVjdHMgYXQgYWRkcmVzcyB6ZXJvKS4NCj4gDQo+IE9uZSBwb3NzaWJsZSBzb2x1dGlv
biB0byB0aGUga25vd24gYWRkcmVzcyBwcm9ibGVtIGlzIHRvIGV4dGVuZCBHQ0MNCj4gYXR0cmli
dXRlcyBhZGRyZXNzIGFuZCBpbyB0aGF0IHBpbiBhbiBvYmplY3QgdG8gYSBoYXJkd2lyZWQgYWRk
cmVzcw0KPiB0byBhbGwgdGFyZ2V0cyAoYXQgdGhlIG1vbWVudCB0aGV5J3JlIHN1cHBvcnRlZCBv
biBqdXN0IG9uZSBvciB0d28NCj4gdGFyZ2V0cykuICBJJ20gbm90IHN1cmUgdGhpcyBjYW4gc3Rp
bGwgaGFwcGVuIGJlZm9yZSBHQ0MgMTEgcmVsZWFzZXMNCj4gc29tZXRpbWUgaW4gQXByaWwgb3Ig
TWF5Lg0KDQpBIGRpZmZlcmVudCBzb2x1dGlvbiBpcyB0byBkZWZpbmUgYSBub3JtYWwgQyBleHRl
cm5hbCBkYXRhIGl0ZW0NCmFuZCB0aGVuIGFzc2lnbiBhIGZpeGVkIGFkZHJlc3Mgd2l0aCBhbiBh
c20gc3RhdGVtZW50IG9yIGluDQp0aGUgbGlua2VyIHNjcmlwdC4NCg0KCURhdmlkDQoNCi0NClJl
Z2lzdGVyZWQgQWRkcmVzcyBMYWtlc2lkZSwgQnJhbWxleSBSb2FkLCBNb3VudCBGYXJtLCBNaWx0
b24gS2V5bmVzLCBNSzEgMVBULCBVSw0KUmVnaXN0cmF0aW9uIE5vOiAxMzk3Mzg2IChXYWxlcykN
Cg==

