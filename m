Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99F462726C
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 00:40:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728677AbfEVWkE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 18:40:04 -0400
Received: from mga12.intel.com ([192.55.52.136]:12447 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726218AbfEVWkE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 May 2019 18:40:04 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 May 2019 15:40:03 -0700
X-ExtLoop1: 1
Received: from orsmsx110.amr.corp.intel.com ([10.22.240.8])
  by fmsmga006.fm.intel.com with ESMTP; 22 May 2019 15:40:03 -0700
Received: from orsmsx112.amr.corp.intel.com ([169.254.3.79]) by
 ORSMSX110.amr.corp.intel.com ([169.254.10.7]) with mapi id 14.03.0415.000;
 Wed, 22 May 2019 15:40:02 -0700
From:   "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To:     "davem@davemloft.net" <davem@davemloft.net>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "mroos@linux.ee" <mroos@linux.ee>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "namit@vmware.com" <namit@vmware.com>,
        "luto@kernel.org" <luto@kernel.org>, "bp@alien8.de" <bp@alien8.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "sparclinux@vger.kernel.org" <sparclinux@vger.kernel.org>
Subject: Re: [PATCH v2] vmalloc: Fix issues with flush flag
Thread-Topic: [PATCH v2] vmalloc: Fix issues with flush flag
Thread-Index: AQHVD0ezpbXySuUS5EinefGl750kkaZ0/uwAgAALkwCAAAiygIAAGYEAgAADqwCAAA0vgIAABnMAgAAEjYCAApkWgIAAHb0AgAA1/4A=
Date:   Wed, 22 May 2019 22:40:02 +0000
Message-ID: <2d8c59be7e591a0d0ff17627ea34ea1eaa110a09.camel@intel.com>
References: <a43f9224e6b245ade4b587a018c8a21815091f0f.camel@intel.com>
         <20190520.184336.743103388474716249.davem@davemloft.net>
         <339ef85d984f329aa66f29fa80781624e6e4aecc.camel@intel.com>
         <20190522.104019.40493905027242516.davem@davemloft.net>
         <01a23900329e605fcd41ad8962cfd8f2d9b1fa44.camel@intel.com>
In-Reply-To: <01a23900329e605fcd41ad8962cfd8f2d9b1fa44.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.30.1 (3.30.1-1.fc29) 
x-originating-ip: [10.254.91.116]
Content-Type: text/plain; charset="utf-8"
Content-ID: <92CE99CE339FFD40BC573E4C2B685475@intel.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCAyMDE5LTA1LTIyIGF0IDEyOjI2IC0wNzAwLCBSaWNrIEVkZ2Vjb21iZSB3cm90ZToN
Cj4gT24gV2VkLCAyMDE5LTA1LTIyIGF0IDEwOjQwIC0wNzAwLCBEYXZpZCBNaWxsZXIgd3JvdGU6
DQo+ID4gRnJvbTogIkVkZ2Vjb21iZSwgUmljayBQIiA8cmljay5wLmVkZ2Vjb21iZUBpbnRlbC5j
b20+DQo+ID4gRGF0ZTogVHVlLCAyMSBNYXkgMjAxOSAwMTo1OTo1NCArMDAwMA0KPiA+IA0KPiA+
ID4gT24gTW9uLCAyMDE5LTA1LTIwIGF0IDE4OjQzIC0wNzAwLCBEYXZpZCBNaWxsZXIgd3JvdGU6
DQo+ID4gPiA+IEZyb206ICJFZGdlY29tYmUsIFJpY2sgUCIgPHJpY2sucC5lZGdlY29tYmVAaW50
ZWwuY29tPg0KPiA+ID4gPiBEYXRlOiBUdWUsIDIxIE1heSAyMDE5IDAxOjIwOjMzICswMDAwDQo+
ID4gPiA+IA0KPiA+ID4gPiA+IFNob3VsZCBpdCBoYW5kbGUgZXhlY3V0aW5nIGFuIHVubWFwcGVk
IHBhZ2UgZ3JhY2VmdWxseT8NCj4gPiA+ID4gPiBCZWNhdXNlDQo+ID4gPiA+ID4gdGhpcw0KPiA+
ID4gPiA+IGNoYW5nZSBpcyBjYXVzaW5nIHRoYXQgdG8gaGFwcGVuIG11Y2ggZWFybGllci4gSWYg
c29tZXRoaW5nDQo+ID4gPiA+ID4gd2FzDQo+ID4gPiA+ID4gcmVseWluZw0KPiA+ID4gPiA+IG9u
IGEgY2FjaGVkIHRyYW5zbGF0aW9uIHRvIGV4ZWN1dGUgc29tZXRoaW5nIGl0IGNvdWxkIGZpbmQN
Cj4gPiA+ID4gPiB0aGUNCj4gPiA+ID4gPiBtYXBwaW5nDQo+ID4gPiA+ID4gZGlzYXBwZWFyLg0K
PiA+ID4gPiANCj4gPiA+ID4gRG9lcyB0aGlzIHdvcmsgYnkgbm90IG1hcHBpbmcgYW55IGtlcm5l
bCBtYXBwaW5ncyBhdCB0aGUNCj4gPiA+ID4gYmVnaW5uaW5nLA0KPiA+ID4gPiBhbmQgdGhlbiBm
aWxsaW5nIGluIHRoZSBCUEYgbWFwcGluZ3MgaW4gcmVzcG9uc2UgdG8gZmF1bHRzPw0KPiA+ID4g
Tm8sIG5vdGhpbmcgdG9vIGZhbmN5LiBJdCBqdXN0IGZsdXNoZXMgdGhlIHZtIG1hcHBpbmcgaW1t
ZWRpYXRseQ0KPiA+ID4gaW4NCj4gPiA+IHZmcmVlIGZvciBleGVjdXRlIChhbmQgUk8pIG1hcHBp
bmdzLiBUaGUgb25seSB0aGluZyB0aGF0IGhhcHBlbnMNCj4gPiA+IGFyb3VuZA0KPiA+ID4gYWxs
b2NhdGlvbiB0aW1lIGlzIHNldHRpbmcgb2YgYSBuZXcgZmxhZyB0byB0ZWxsIHZtYWxsb2MgdG8g
ZG8NCj4gPiA+IHRoZQ0KPiA+ID4gZmx1c2guDQo+ID4gPiANCj4gPiA+IFRoZSBwcm9ibGVtIGJl
Zm9yZSB3YXMgdGhhdCB0aGUgcGFnZXMgd291bGQgYmUgZnJlZWQgYmVmb3JlIHRoZQ0KPiA+ID4g
ZXhlY3V0ZQ0KPiA+ID4gbWFwcGluZyB3YXMgZmx1c2hlZC4gU28gdGhlbiB3aGVuIHRoZSBwYWdl
cyBnb3QgcmVjeWNsZWQsIHJhbmRvbSwNCj4gPiA+IHNvbWV0aW1lcyBjb21pbmcgZnJvbSB1c2Vy
c3BhY2UsIGRhdGEgd291bGQgYmUgbWFwcGVkIGFzDQo+ID4gPiBleGVjdXRhYmxlDQo+ID4gPiBp
bg0KPiA+ID4gdGhlIGtlcm5lbCBieSB0aGUgdW4tZmx1c2hlZCB0bGIgZW50cmllcy4NCj4gPiAN
Cj4gPiBJZiBJIGFtIHRvIHVuZGVyc3RhbmQgdGhpbmdzIGNvcnJlY3RseSwgdGhlcmUgd2FzIGEg
Y2FzZSB3aGVyZQ0KPiA+ICdlbmQnDQo+ID4gY291bGQgYmUgc21hbGxlciB0aGFuICdzdGFydCcg
d2hlbiBkb2luZyBhIHJhbmdlIGZsdXNoLiAgVGhhdCB3b3VsZA0KPiA+IGRlZmluaXRlbHkga2ls
bCBzb21lIG9mIHRoZSBzcGFyYzY0IFRMQiBmbHVzaCByb3V0aW5lcy4NCj4gDQo+IE9rLCB0aGFu
a3MuDQo+IA0KPiBUaGUgcGF0Y2ggYXQgdGhlIGJlZ2lubmluZyBvZiB0aGlzIHRocmVhZCBkb2Vz
bid0IGhhdmUgdGhhdCBiZWhhdmlvcg0KPiB0aG91Z2ggYW5kIGl0IGFwcGFyZW50bHkgc3RpbGwg
aHVuZy4gSSBhc2tlZCBpZiBNZWVsaXMgY291bGQgdGVzdA0KPiB3aXRoDQo+IHRoaXMgZmVhdHVy
ZSBkaXNhYmxlZCBhbmQgREVCVUdfUEFHRUFMTE9DIG9uLCBzaW5jZSBpdCBmbHVzaGVzIG9uDQo+
IGV2ZXJ5DQo+IHZmcmVlIGFuZCBpcyBub3QgbmV3IGxvZ2ljLCBhbmQgYWxzbyB3aXRoIGEgcGF0
Y2ggdGhhdCBsb2dzIGV4YWN0IFRMQg0KPiBmbHVzaCByYW5nZXMgYW5kIGZhdWx0IGFkZHJlc3Nl
cyBvbiB0b3Agb2YgdGhlIGtlcm5lbCBoYXZpbmcgdGhpcw0KPiBpc3N1ZS4gSG9wZWZ1bGx5IHRo
YXQgd2lsbCBzaGVkIHNvbWUgbGlnaHQuDQo+IA0KPiBTb3JyeSBmb3IgYWxsIHRoZSBub2lzZSBh
bmQgc3BlY3VsYXRpb24gb24gdGhpcy4gSXQgaGFzIGJlZW4NCj4gZGlmZmljdWx0DQo+IHRvIGRl
YnVnIHJlbW90ZWx5IHdpdGggYSB0ZXN0ZXIgYW5kIGRldmVsb3BlciBpbiBkaWZmZXJlbnQgdGlt
ZQ0KPiB6b25lcy4NCj4gDQo+IA0KT2ssIHNvIHdpdGggYSBwYXRjaCB0byBkaXNhYmxlIHNldHRp
bmcgdGhlIG5ldyB2bWFsbG9jIGZsdXNoIGZsYWcgb24NCmFyY2hpdGVjdHVyZXMgdGhhdCBoYXZl
IG5vcm1hbCBtZW1vcnkgYXMgZXhlY3V0YWJsZSAoaW5jbHVkZXMgc3BhcmMpLA0KYm9vdCBzdWNj
ZWVkcy4NCg0KV2l0aCB0aGlzIGRpc2FibGUgcGF0Y2ggYW5kIERFQlVHX1BBR0VBTExPQyBvbiwg
aXQgaGFuZ3MgZWFybGllciB0aGFuDQpiZWZvcmUuIEdvaW5nIGZyb20gY2x1ZXMgaW4gb3RoZXIg
bG9ncywgaXQgbG9va3MgbGlrZSBpdCBoYW5ncyByaWdodCBhdA0KdGhlIGZpcnN0IG5vcm1hbCB2
ZnJlZS4NCg0KVGhhbmtzIGZvciBhbGwgdGhlIHRlc3RpbmcgTWVlbGlzIQ0KDQpTbyBpdCBzZWVt
cyBsaWtlIG90aGVyLCBub3QgbmV3LCBUTEIgZmx1c2hlcyBhbHNvIHRyaWdnZXIgdGhlIGhhbmcu
DQoNCkZyb20gZWFybGllciBsb2dzIHByb3ZpZGVkLCB0aGlzIHZmcmVlIHdvdWxkIGJlIHRoZSBm
aXJzdCBjYWxsIHRvDQpmbHVzaF90bGJfa2VybmVsX3JhbmdlKCksIGFuZCBiZWZvcmUgYW55IEJQ
RiBhbGxvY2F0aW9ucyBhcHBlYXIgaW4gdGhlDQpsb2dzLiBTbyBJIGFtIHN1c3BlY3Rpbmcgc29t
ZSBvdGhlciBjYXVzZSB0aGFuIHRoZSBiaXNlY3RlZCBwYXRjaCBhdA0KdGhpcyBwb2ludCwgYnV0
IEkgZ3Vlc3MgaXQncyBub3QgZnVsbHkgY29uY2x1c2l2ZS4NCg0KSXQgY291bGQgYmUgaW5mb3Jt
YXRpdmUgdG8gYmlzZWN0IHVwc3RyZWFtIGFnYWluIHdpdGggdGhlDQpERUJVR19QQUdFQUxMT0Mg
Y29uZmlncyBvbiwgdG8gc2VlIGlmIGl0IGluZGVlZCBwb2ludHMgdG8gYW4gZWFybGllcg0KY29t
bWl0Lg0K
