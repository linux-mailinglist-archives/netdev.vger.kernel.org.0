Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0B9925875
	for <lists+netdev@lfdr.de>; Tue, 21 May 2019 21:47:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727283AbfEUTre (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 May 2019 15:47:34 -0400
Received: from mga01.intel.com ([192.55.52.88]:38950 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726767AbfEUTrd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 May 2019 15:47:33 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 May 2019 12:47:33 -0700
X-ExtLoop1: 1
Received: from orsmsx108.amr.corp.intel.com ([10.22.240.6])
  by fmsmga005.fm.intel.com with ESMTP; 21 May 2019 12:47:32 -0700
Received: from orsmsx159.amr.corp.intel.com (10.22.240.24) by
 ORSMSX108.amr.corp.intel.com (10.22.240.6) with Microsoft SMTP Server (TLS)
 id 14.3.408.0; Tue, 21 May 2019 12:47:32 -0700
Received: from orsmsx112.amr.corp.intel.com ([169.254.3.79]) by
 ORSMSX159.amr.corp.intel.com ([169.254.11.57]) with mapi id 14.03.0415.000;
 Tue, 21 May 2019 12:47:31 -0700
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
Thread-Index: AQHVD2U3KZTtLX0Fp0SruELxCLk0rqZ2N/EAgAAJloCAAAJwAIAALqWA
Date:   Tue, 21 May 2019 19:47:31 +0000
Message-ID: <356bc82c5a34424ef1c34acfdc31f97900b9455b.camel@intel.com>
References: <20190520233841.17194-1-rick.p.edgecombe@intel.com>
         <20190520233841.17194-3-rick.p.edgecombe@intel.com>
         <CALCETrUdfBrTV3kMjdVHv2JDtEOGSkVvoV++96x4zjvue0GpZA@mail.gmail.com>
         <4e353614f017c7c13a21d168992852dae1762aba.camel@intel.com>
         <CALCETrXfnkLKv-jJzquj+547QWiwEBSxKtM3du3UqK80FNSSGg@mail.gmail.com>
In-Reply-To: <CALCETrXfnkLKv-jJzquj+547QWiwEBSxKtM3du3UqK80FNSSGg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.30.1 (3.30.1-1.fc29) 
x-originating-ip: [10.254.114.95]
Content-Type: text/plain; charset="utf-8"
Content-ID: <C2E899E8E511D1429AA1E89C4A43A70B@intel.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDE5LTA1LTIxIGF0IDEwOjAwIC0wNzAwLCBBbmR5IEx1dG9taXJza2kgd3JvdGU6
DQo+IE9uIFR1ZSwgTWF5IDIxLCAyMDE5IGF0IDk6NTEgQU0gRWRnZWNvbWJlLCBSaWNrIFANCj4g
PHJpY2sucC5lZGdlY29tYmVAaW50ZWwuY29tPiB3cm90ZToNCj4gPiBPbiBUdWUsIDIwMTktMDUt
MjEgYXQgMDk6MTcgLTA3MDAsIEFuZHkgTHV0b21pcnNraSB3cm90ZToNCj4gPiA+IE9uIE1vbiwg
TWF5IDIwLCAyMDE5IGF0IDQ6MzkgUE0gUmljayBFZGdlY29tYmUNCj4gPiA+IDxyaWNrLnAuZWRn
ZWNvbWJlQGludGVsLmNvbT4gd3JvdGU6DQo+ID4gPiA+IEZyb206IFJpY2sgRWRnZWNvbWJlIDxy
ZWRnZWNvbWJlLmxrbWxAZ21haWwuY29tPg0KPiA+ID4gPiANCj4gPiA+ID4gQ2FsbGluZyB2bV91
bm1hcF9hbGlhcygpIGluIHZtX3JlbW92ZV9tYXBwaW5ncygpIGNvdWxkDQo+ID4gPiA+IHBvdGVu
dGlhbGx5DQo+ID4gPiA+IGJlIGENCj4gPiA+ID4gbG90IG9mIHdvcmsgdG8gZG8gb24gYSBmcmVl
IG9wZXJhdGlvbi4gU2ltcGx5IGZsdXNoaW5nIHRoZSBUTEINCj4gPiA+ID4gaW5zdGVhZCBvZg0K
PiA+ID4gPiB0aGUgd2hvbGUgdm1fdW5tYXBfYWxpYXMoKSBvcGVyYXRpb24gbWFrZXMgdGhlIGZy
ZWVzIGZhc3RlciBhbmQNCj4gPiA+ID4gcHVzaGVzDQo+ID4gPiA+IHRoZSBoZWF2eSB3b3JrIHRv
IGhhcHBlbiBvbiBhbGxvY2F0aW9uIHdoZXJlIGl0IHdvdWxkIGJlIG1vcmUNCj4gPiA+ID4gZXhw
ZWN0ZWQuDQo+ID4gPiA+IEluIGFkZGl0aW9uIHRvIHRoZSBleHRyYSB3b3JrLCB2bV91bm1hcF9h
bGlhcygpIHRha2VzIHNvbWUNCj4gPiA+ID4gbG9ja3MNCj4gPiA+ID4gaW5jbHVkaW5nDQo+ID4g
PiA+IGEgbG9uZyBob2xkIG9mIHZtYXBfcHVyZ2VfbG9jaywgd2hpY2ggd2lsbCBtYWtlIGFsbCBv
dGhlcg0KPiA+ID4gPiBWTV9GTFVTSF9SRVNFVF9QRVJNUyB2ZnJlZXMgd2FpdCB3aGlsZSB0aGUg
cHVyZ2Ugb3BlcmF0aW9uDQo+ID4gPiA+IGhhcHBlbnMuDQo+ID4gPiA+IA0KPiA+ID4gPiBMYXN0
bHksIHBhZ2VfYWRkcmVzcygpIGNhbiBpbnZvbHZlIGxvY2tpbmcgYW5kIGxvb2t1cHMgb24gc29t
ZQ0KPiA+ID4gPiBjb25maWd1cmF0aW9ucywgc28gc2tpcCBjYWxsaW5nIHRoaXMgYnkgZXhpdGlu
ZyBvdXQgZWFybHkgd2hlbg0KPiA+ID4gPiAhQ09ORklHX0FSQ0hfSEFTX1NFVF9ESVJFQ1RfTUFQ
Lg0KPiA+ID4gDQo+ID4gPiBIbW0uICBJIHdvdWxkIGhhdmUgZXhwZWN0ZWQgdGhhdCB0aGUgbWFq
b3IgY29zdCBvZg0KPiA+ID4gdm1fdW5tYXBfYWxpYXNlcygpDQo+ID4gPiB3b3VsZCBiZSB0aGUg
Zmx1c2gsIGFuZCBhdCBsZWFzdCBpbmZvcm1pbmcgdGhlIGNvZGUgdGhhdCB0aGUNCj4gPiA+IGZs
dXNoDQo+ID4gPiBoYXBwZW5lZCBzZWVtcyB2YWx1YWJsZS4gIFNvIHdvdWxkIGd1ZXNzIHRoYXQg
dGhpcyBwYXRjaCBpcw0KPiA+ID4gYWN0dWFsbHkNCj4gPiA+IGENCj4gPiA+IGxvc3MgaW4gdGhy
b3VnaHB1dC4NCj4gPiA+IA0KPiA+IFlvdSBhcmUgcHJvYmFibHkgcmlnaHQgYWJvdXQgdGhlIGZs
dXNoIHRha2luZyB0aGUgbG9uZ2VzdC4gVGhlDQo+ID4gb3JpZ2luYWwNCj4gPiBpZGVhIG9mIHVz
aW5nIGl0IHdhcyBleGFjdGx5IHRvIGltcHJvdmUgdGhyb3VnaHB1dCBieSBzYXZpbmcgYQ0KPiA+
IGZsdXNoLg0KPiA+IEhvd2V2ZXIgd2l0aCB2bV91bm1hcF9hbGlhc2VzKCkgdGhlIGZsdXNoIHdp
bGwgYmUgb3ZlciBhIGxhcmdlcg0KPiA+IHJhbmdlDQo+ID4gdGhhbiBiZWZvcmUgZm9yIG1vc3Qg
YXJjaCdzIHNpbmNlIGl0IHdpbGwgbGlrbGV5IHNwYW4gZnJvbSB0aGUNCj4gPiBtb2R1bGUNCj4g
PiBzcGFjZSB0byB2bWFsbG9jLiBGcm9tIHBva2luZyBhcm91bmQgdGhlIHNwYXJjIHRsYiBmbHVz
aCBoaXN0b3J5LCBJDQo+ID4gZ3Vlc3MgdGhlIGxhenkgcHVyZ2VzIHVzZWQgdG8gYmUgKHN0aWxs
IGFyZT8pIGEgcHJvYmxlbSBmb3IgdGhlbQ0KPiA+IGJlY2F1c2UgaXQgd291bGQgdHJ5IHRvIGZs
dXNoIGVhY2ggcGFnZSBpbmRpdmlkdWFsbHkgZm9yIHNvbWUgQ1BVcy4NCj4gPiBOb3QNCj4gPiBz
dXJlIGFib3V0IGFsbCBvZiB0aGUgb3RoZXIgYXJjaGl0ZWN0dXJlcywgYnV0IGZvciBhbnkNCj4g
PiBpbXBsZW1lbnRhdGlvbg0KPiA+IGxpa2UgdGhhdCwgdXNpbmcgdm1fdW5tYXBfYWxpYXMoKSB3
b3VsZCB0dXJuIGFuIG9jY2FzaW9uYWwgbG9uZw0KPiA+IG9wZXJhdGlvbiBpbnRvIGEgbW9yZSBm
cmVxdWVudCBvbmUuDQo+ID4gDQo+ID4gT24geDg2LCBpdCBzaG91bGRuJ3QgYmUgYSBwcm9ibGVt
IHRvIHVzZSBpdC4gV2UgYWxyZWFkeSB1c2VkIHRvDQo+ID4gY2FsbA0KPiA+IHRoaXMgZnVuY3Rp
b24gc2V2ZXJhbCB0aW1lcyBhcm91bmQgYSBleGVjIHBlcm1pc3Npb24gdmZyZWUuDQo+ID4gDQo+
ID4gSSBndWVzcyBpdHMgYSB0cmFkZW9mZiB0aGF0IGRlcGVuZHMgb24gaG93IGZhc3QgbGFyZ2Ug
cmFuZ2UgVExCDQo+ID4gZmx1c2hlcw0KPiA+IHVzdWFsbHkgYXJlIGNvbXBhcmVkIHRvIHNtYWxs
IG9uZXMuIEkgYW0gb2sgZHJvcHBpbmcgaXQsIGlmIGl0DQo+ID4gZG9lc24ndA0KPiA+IHNlZW0g
d29ydGggaXQuDQo+IA0KPiBPbiB4ODYsIGEgZnVsbCBmbHVzaCBpcyBwcm9iYWJseSBub3QgbXVj
aCBzbG93ZXIgdGhhbiBqdXN0IGZsdXNoaW5nIGENCj4gcGFnZSBvciB0d28gLS0gdGhlIG1haW4g
Y29zdCBpcyBpbiB0aGUgVExCIHJlZmlsbC4gIEkgZG9uJ3Qga25vdw0KPiBhYm91dA0KPiBvdGhl
ciBhcmNoaXRlY3R1cmVzLiAgSSB3b3VsZCBkcm9wIHRoaXMgcGF0Y2ggdW5sZXNzIHlvdSBoYXZl
IG51bWJlcnMNCj4gc3VnZ2VzdGluZyB0aGF0IGl0J3MgYSB3aW4uDQoNCk9rLiBUaGlzIHBhdGNo
IGFsc28gaW5hZHZlcnRlbnRseSBpbXByb3ZlZCBzb21lIGNvcnJlY3RuZXNzIGluIGNhbGxzIHRv
DQpmbHVzaF90bGJfa2VybmVsX3JhbmdlKCkgZm9yIGEgcmFyZSBzaXR1YXRpb24uIEknbGwgd29y
ayB0aGF0IGludG8gYQ0KZGlmZmVyZW50IHBhdGNoLg0KDQpUaGFua3MsDQoNClJpY2sNCg==
