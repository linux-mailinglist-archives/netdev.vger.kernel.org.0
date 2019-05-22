Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71D7626E6F
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 21:49:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732525AbfEVTtw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 15:49:52 -0400
Received: from mga05.intel.com ([192.55.52.43]:43391 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732116AbfEVT0t (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 May 2019 15:26:49 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 May 2019 12:26:46 -0700
X-ExtLoop1: 1
Received: from orsmsx102.amr.corp.intel.com ([10.22.225.129])
  by orsmga002.jf.intel.com with ESMTP; 22 May 2019 12:26:48 -0700
Received: from orsmsx112.amr.corp.intel.com ([169.254.3.79]) by
 ORSMSX102.amr.corp.intel.com ([169.254.3.72]) with mapi id 14.03.0415.000;
 Wed, 22 May 2019 12:26:47 -0700
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
Thread-Index: AQHVD0ezpbXySuUS5EinefGl750kkaZ0/uwAgAALkwCAAAiygIAAGYEAgAADqwCAAA0vgIAABnMAgAAEjYCAApkWgIAAHb0A
Date:   Wed, 22 May 2019 19:26:47 +0000
Message-ID: <01a23900329e605fcd41ad8962cfd8f2d9b1fa44.camel@intel.com>
References: <a43f9224e6b245ade4b587a018c8a21815091f0f.camel@intel.com>
         <20190520.184336.743103388474716249.davem@davemloft.net>
         <339ef85d984f329aa66f29fa80781624e6e4aecc.camel@intel.com>
         <20190522.104019.40493905027242516.davem@davemloft.net>
In-Reply-To: <20190522.104019.40493905027242516.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.30.1 (3.30.1-1.fc29) 
x-originating-ip: [10.254.91.116]
Content-Type: text/plain; charset="utf-8"
Content-ID: <8DA560705D778D4A9D23CAF3ED2AB2FC@intel.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCAyMDE5LTA1LTIyIGF0IDEwOjQwIC0wNzAwLCBEYXZpZCBNaWxsZXIgd3JvdGU6DQo+
IEZyb206ICJFZGdlY29tYmUsIFJpY2sgUCIgPHJpY2sucC5lZGdlY29tYmVAaW50ZWwuY29tPg0K
PiBEYXRlOiBUdWUsIDIxIE1heSAyMDE5IDAxOjU5OjU0ICswMDAwDQo+IA0KPiA+IE9uIE1vbiwg
MjAxOS0wNS0yMCBhdCAxODo0MyAtMDcwMCwgRGF2aWQgTWlsbGVyIHdyb3RlOg0KPiA+ID4gRnJv
bTogIkVkZ2Vjb21iZSwgUmljayBQIiA8cmljay5wLmVkZ2Vjb21iZUBpbnRlbC5jb20+DQo+ID4g
PiBEYXRlOiBUdWUsIDIxIE1heSAyMDE5IDAxOjIwOjMzICswMDAwDQo+ID4gPiANCj4gPiA+ID4g
U2hvdWxkIGl0IGhhbmRsZSBleGVjdXRpbmcgYW4gdW5tYXBwZWQgcGFnZSBncmFjZWZ1bGx5PyBC
ZWNhdXNlDQo+ID4gPiA+IHRoaXMNCj4gPiA+ID4gY2hhbmdlIGlzIGNhdXNpbmcgdGhhdCB0byBo
YXBwZW4gbXVjaCBlYXJsaWVyLiBJZiBzb21ldGhpbmcgd2FzDQo+ID4gPiA+IHJlbHlpbmcNCj4g
PiA+ID4gb24gYSBjYWNoZWQgdHJhbnNsYXRpb24gdG8gZXhlY3V0ZSBzb21ldGhpbmcgaXQgY291
bGQgZmluZCB0aGUNCj4gPiA+ID4gbWFwcGluZw0KPiA+ID4gPiBkaXNhcHBlYXIuDQo+ID4gPiAN
Cj4gPiA+IERvZXMgdGhpcyB3b3JrIGJ5IG5vdCBtYXBwaW5nIGFueSBrZXJuZWwgbWFwcGluZ3Mg
YXQgdGhlDQo+ID4gPiBiZWdpbm5pbmcsDQo+ID4gPiBhbmQgdGhlbiBmaWxsaW5nIGluIHRoZSBC
UEYgbWFwcGluZ3MgaW4gcmVzcG9uc2UgdG8gZmF1bHRzPw0KPiA+IE5vLCBub3RoaW5nIHRvbyBm
YW5jeS4gSXQganVzdCBmbHVzaGVzIHRoZSB2bSBtYXBwaW5nIGltbWVkaWF0bHkgaW4NCj4gPiB2
ZnJlZSBmb3IgZXhlY3V0ZSAoYW5kIFJPKSBtYXBwaW5ncy4gVGhlIG9ubHkgdGhpbmcgdGhhdCBo
YXBwZW5zDQo+ID4gYXJvdW5kDQo+ID4gYWxsb2NhdGlvbiB0aW1lIGlzIHNldHRpbmcgb2YgYSBu
ZXcgZmxhZyB0byB0ZWxsIHZtYWxsb2MgdG8gZG8gdGhlDQo+ID4gZmx1c2guDQo+ID4gDQo+ID4g
VGhlIHByb2JsZW0gYmVmb3JlIHdhcyB0aGF0IHRoZSBwYWdlcyB3b3VsZCBiZSBmcmVlZCBiZWZv
cmUgdGhlDQo+ID4gZXhlY3V0ZQ0KPiA+IG1hcHBpbmcgd2FzIGZsdXNoZWQuIFNvIHRoZW4gd2hl
biB0aGUgcGFnZXMgZ290IHJlY3ljbGVkLCByYW5kb20sDQo+ID4gc29tZXRpbWVzIGNvbWluZyBm
cm9tIHVzZXJzcGFjZSwgZGF0YSB3b3VsZCBiZSBtYXBwZWQgYXMgZXhlY3V0YWJsZQ0KPiA+IGlu
DQo+ID4gdGhlIGtlcm5lbCBieSB0aGUgdW4tZmx1c2hlZCB0bGIgZW50cmllcy4NCj4gDQo+IElm
IEkgYW0gdG8gdW5kZXJzdGFuZCB0aGluZ3MgY29ycmVjdGx5LCB0aGVyZSB3YXMgYSBjYXNlIHdo
ZXJlICdlbmQnDQo+IGNvdWxkIGJlIHNtYWxsZXIgdGhhbiAnc3RhcnQnIHdoZW4gZG9pbmcgYSBy
YW5nZSBmbHVzaC4gIFRoYXQgd291bGQNCj4gZGVmaW5pdGVseSBraWxsIHNvbWUgb2YgdGhlIHNw
YXJjNjQgVExCIGZsdXNoIHJvdXRpbmVzLg0KDQpPaywgdGhhbmtzLg0KDQpUaGUgcGF0Y2ggYXQg
dGhlIGJlZ2lubmluZyBvZiB0aGlzIHRocmVhZCBkb2Vzbid0IGhhdmUgdGhhdCBiZWhhdmlvcg0K
dGhvdWdoIGFuZCBpdCBhcHBhcmVudGx5IHN0aWxsIGh1bmcuIEkgYXNrZWQgaWYgTWVlbGlzIGNv
dWxkIHRlc3Qgd2l0aA0KdGhpcyBmZWF0dXJlIGRpc2FibGVkIGFuZCBERUJVR19QQUdFQUxMT0Mg
b24sIHNpbmNlIGl0IGZsdXNoZXMgb24gZXZlcnkNCnZmcmVlIGFuZCBpcyBub3QgbmV3IGxvZ2lj
LCBhbmQgYWxzbyB3aXRoIGEgcGF0Y2ggdGhhdCBsb2dzIGV4YWN0IFRMQg0KZmx1c2ggcmFuZ2Vz
IGFuZCBmYXVsdCBhZGRyZXNzZXMgb24gdG9wIG9mIHRoZSBrZXJuZWwgaGF2aW5nIHRoaXMNCmlz
c3VlLiBIb3BlZnVsbHkgdGhhdCB3aWxsIHNoZWQgc29tZSBsaWdodC4NCg0KU29ycnkgZm9yIGFs
bCB0aGUgbm9pc2UgYW5kIHNwZWN1bGF0aW9uIG9uIHRoaXMuIEl0IGhhcyBiZWVuIGRpZmZpY3Vs
dA0KdG8gZGVidWcgcmVtb3RlbHkgd2l0aCBhIHRlc3RlciBhbmQgZGV2ZWxvcGVyIGluIGRpZmZl
cmVudCB0aW1lIHpvbmVzLg0KDQoNCg==
