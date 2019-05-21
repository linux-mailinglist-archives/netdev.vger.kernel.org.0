Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0F9A25612
	for <lists+netdev@lfdr.de>; Tue, 21 May 2019 18:51:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729055AbfEUQvz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 May 2019 12:51:55 -0400
Received: from mga09.intel.com ([134.134.136.24]:31932 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728961AbfEUQvz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 May 2019 12:51:55 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 May 2019 09:51:54 -0700
X-ExtLoop1: 1
Received: from orsmsx103.amr.corp.intel.com ([10.22.225.130])
  by fmsmga004.fm.intel.com with ESMTP; 21 May 2019 09:51:53 -0700
Received: from orsmsx151.amr.corp.intel.com (10.22.226.38) by
 ORSMSX103.amr.corp.intel.com (10.22.225.130) with Microsoft SMTP Server (TLS)
 id 14.3.408.0; Tue, 21 May 2019 09:51:53 -0700
Received: from orsmsx112.amr.corp.intel.com ([169.254.3.79]) by
 ORSMSX151.amr.corp.intel.com ([169.254.7.185]) with mapi id 14.03.0415.000;
 Tue, 21 May 2019 09:51:53 -0700
From:   "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To:     "luto@kernel.org" <luto@kernel.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "mroos@linux.ee" <mroos@linux.ee>,
        "redgecombe.lkml@gmail.com" <redgecombe.lkml@gmail.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "namit@vmware.com" <namit@vmware.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "sparclinux@vger.kernel.org" <sparclinux@vger.kernel.org>
Subject: Re: [PATCH v2 2/2] vmalloc: Remove work as from vfree path
Thread-Topic: [PATCH v2 2/2] vmalloc: Remove work as from vfree path
Thread-Index: AQHVD2U3KZTtLX0Fp0SruELxCLk0rqZ2N/EAgAAJloA=
Date:   Tue, 21 May 2019 16:51:52 +0000
Message-ID: <4e353614f017c7c13a21d168992852dae1762aba.camel@intel.com>
References: <20190520233841.17194-1-rick.p.edgecombe@intel.com>
         <20190520233841.17194-3-rick.p.edgecombe@intel.com>
         <CALCETrUdfBrTV3kMjdVHv2JDtEOGSkVvoV++96x4zjvue0GpZA@mail.gmail.com>
In-Reply-To: <CALCETrUdfBrTV3kMjdVHv2JDtEOGSkVvoV++96x4zjvue0GpZA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.30.1 (3.30.1-1.fc29) 
x-originating-ip: [10.254.114.95]
Content-Type: text/plain; charset="utf-8"
Content-ID: <DACEB64281EDB048B2BD8C11B17A6282@intel.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDE5LTA1LTIxIGF0IDA5OjE3IC0wNzAwLCBBbmR5IEx1dG9taXJza2kgd3JvdGU6
DQo+IE9uIE1vbiwgTWF5IDIwLCAyMDE5IGF0IDQ6MzkgUE0gUmljayBFZGdlY29tYmUNCj4gPHJp
Y2sucC5lZGdlY29tYmVAaW50ZWwuY29tPiB3cm90ZToNCj4gPiBGcm9tOiBSaWNrIEVkZ2Vjb21i
ZSA8cmVkZ2Vjb21iZS5sa21sQGdtYWlsLmNvbT4NCj4gPiANCj4gPiBDYWxsaW5nIHZtX3VubWFw
X2FsaWFzKCkgaW4gdm1fcmVtb3ZlX21hcHBpbmdzKCkgY291bGQgcG90ZW50aWFsbHkNCj4gPiBi
ZSBhDQo+ID4gbG90IG9mIHdvcmsgdG8gZG8gb24gYSBmcmVlIG9wZXJhdGlvbi4gU2ltcGx5IGZs
dXNoaW5nIHRoZSBUTEINCj4gPiBpbnN0ZWFkIG9mDQo+ID4gdGhlIHdob2xlIHZtX3VubWFwX2Fs
aWFzKCkgb3BlcmF0aW9uIG1ha2VzIHRoZSBmcmVlcyBmYXN0ZXIgYW5kDQo+ID4gcHVzaGVzDQo+
ID4gdGhlIGhlYXZ5IHdvcmsgdG8gaGFwcGVuIG9uIGFsbG9jYXRpb24gd2hlcmUgaXQgd291bGQg
YmUgbW9yZQ0KPiA+IGV4cGVjdGVkLg0KPiA+IEluIGFkZGl0aW9uIHRvIHRoZSBleHRyYSB3b3Jr
LCB2bV91bm1hcF9hbGlhcygpIHRha2VzIHNvbWUgbG9ja3MNCj4gPiBpbmNsdWRpbmcNCj4gPiBh
IGxvbmcgaG9sZCBvZiB2bWFwX3B1cmdlX2xvY2ssIHdoaWNoIHdpbGwgbWFrZSBhbGwgb3RoZXIN
Cj4gPiBWTV9GTFVTSF9SRVNFVF9QRVJNUyB2ZnJlZXMgd2FpdCB3aGlsZSB0aGUgcHVyZ2Ugb3Bl
cmF0aW9uIGhhcHBlbnMuDQo+ID4gDQo+ID4gTGFzdGx5LCBwYWdlX2FkZHJlc3MoKSBjYW4gaW52
b2x2ZSBsb2NraW5nIGFuZCBsb29rdXBzIG9uIHNvbWUNCj4gPiBjb25maWd1cmF0aW9ucywgc28g
c2tpcCBjYWxsaW5nIHRoaXMgYnkgZXhpdGluZyBvdXQgZWFybHkgd2hlbg0KPiA+ICFDT05GSUdf
QVJDSF9IQVNfU0VUX0RJUkVDVF9NQVAuDQo+IA0KPiBIbW0uICBJIHdvdWxkIGhhdmUgZXhwZWN0
ZWQgdGhhdCB0aGUgbWFqb3IgY29zdCBvZiB2bV91bm1hcF9hbGlhc2VzKCkNCj4gd291bGQgYmUg
dGhlIGZsdXNoLCBhbmQgYXQgbGVhc3QgaW5mb3JtaW5nIHRoZSBjb2RlIHRoYXQgdGhlIGZsdXNo
DQo+IGhhcHBlbmVkIHNlZW1zIHZhbHVhYmxlLiAgU28gd291bGQgZ3Vlc3MgdGhhdCB0aGlzIHBh
dGNoIGlzIGFjdHVhbGx5DQo+IGENCj4gbG9zcyBpbiB0aHJvdWdocHV0Lg0KPiANCllvdSBhcmUg
cHJvYmFibHkgcmlnaHQgYWJvdXQgdGhlIGZsdXNoIHRha2luZyB0aGUgbG9uZ2VzdC4gVGhlIG9y
aWdpbmFsDQppZGVhIG9mIHVzaW5nIGl0IHdhcyBleGFjdGx5IHRvIGltcHJvdmUgdGhyb3VnaHB1
dCBieSBzYXZpbmcgYSBmbHVzaC4NCkhvd2V2ZXIgd2l0aCB2bV91bm1hcF9hbGlhc2VzKCkgdGhl
IGZsdXNoIHdpbGwgYmUgb3ZlciBhIGxhcmdlciByYW5nZQ0KdGhhbiBiZWZvcmUgZm9yIG1vc3Qg
YXJjaCdzIHNpbmNlIGl0IHdpbGwgbGlrbGV5IHNwYW4gZnJvbSB0aGUgbW9kdWxlDQpzcGFjZSB0
byB2bWFsbG9jLiBGcm9tIHBva2luZyBhcm91bmQgdGhlIHNwYXJjIHRsYiBmbHVzaCBoaXN0b3J5
LCBJDQpndWVzcyB0aGUgbGF6eSBwdXJnZXMgdXNlZCB0byBiZSAoc3RpbGwgYXJlPykgYSBwcm9i
bGVtIGZvciB0aGVtDQpiZWNhdXNlIGl0IHdvdWxkIHRyeSB0byBmbHVzaCBlYWNoIHBhZ2UgaW5k
aXZpZHVhbGx5IGZvciBzb21lIENQVXMuIE5vdA0Kc3VyZSBhYm91dCBhbGwgb2YgdGhlIG90aGVy
IGFyY2hpdGVjdHVyZXMsIGJ1dCBmb3IgYW55IGltcGxlbWVudGF0aW9uDQpsaWtlIHRoYXQsIHVz
aW5nIHZtX3VubWFwX2FsaWFzKCkgd291bGQgdHVybiBhbiBvY2Nhc2lvbmFsIGxvbmcNCm9wZXJh
dGlvbiBpbnRvIGEgbW9yZSBmcmVxdWVudCBvbmUuDQoNCk9uIHg4NiwgaXQgc2hvdWxkbid0IGJl
IGEgcHJvYmxlbSB0byB1c2UgaXQuIFdlIGFscmVhZHkgdXNlZCB0byBjYWxsDQp0aGlzIGZ1bmN0
aW9uIHNldmVyYWwgdGltZXMgYXJvdW5kIGEgZXhlYyBwZXJtaXNzaW9uIHZmcmVlLiANCg0KSSBn
dWVzcyBpdHMgYSB0cmFkZW9mZiB0aGF0IGRlcGVuZHMgb24gaG93IGZhc3QgbGFyZ2UgcmFuZ2Ug
VExCIGZsdXNoZXMNCnVzdWFsbHkgYXJlIGNvbXBhcmVkIHRvIHNtYWxsIG9uZXMuIEkgYW0gb2sg
ZHJvcHBpbmcgaXQsIGlmIGl0IGRvZXNuJ3QNCnNlZW0gd29ydGggaXQuDQo=
