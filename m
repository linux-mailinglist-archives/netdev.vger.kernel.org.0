Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4EC729B83
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 17:50:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389765AbfEXPuv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 11:50:51 -0400
Received: from mga17.intel.com ([192.55.52.151]:55161 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389496AbfEXPuu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 May 2019 11:50:50 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 24 May 2019 08:50:50 -0700
X-ExtLoop1: 1
Received: from orsmsx102.amr.corp.intel.com ([10.22.225.129])
  by fmsmga001.fm.intel.com with ESMTP; 24 May 2019 08:50:49 -0700
Received: from orsmsx126.amr.corp.intel.com (10.22.240.126) by
 ORSMSX102.amr.corp.intel.com (10.22.225.129) with Microsoft SMTP Server (TLS)
 id 14.3.408.0; Fri, 24 May 2019 08:50:49 -0700
Received: from orsmsx112.amr.corp.intel.com ([169.254.3.79]) by
 ORSMSX126.amr.corp.intel.com ([169.254.4.35]) with mapi id 14.03.0415.000;
 Fri, 24 May 2019 08:50:49 -0700
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
Thread-Index: AQHVD0ezpbXySuUS5EinefGl750kkaZ0/uwAgAALkwCAAAiygIAAGYEAgAADqwCAAA0vgIAABnMAgAAEjYCAApkWgIAAHb0AgAA1/4CAArJUAA==
Date:   Fri, 24 May 2019 15:50:48 +0000
Message-ID: <c9c96d83838beab6eb3a5309ad6b4b409fbce0f3.camel@intel.com>
References: <a43f9224e6b245ade4b587a018c8a21815091f0f.camel@intel.com>
         <20190520.184336.743103388474716249.davem@davemloft.net>
         <339ef85d984f329aa66f29fa80781624e6e4aecc.camel@intel.com>
         <20190522.104019.40493905027242516.davem@davemloft.net>
         <01a23900329e605fcd41ad8962cfd8f2d9b1fa44.camel@intel.com>
         <2d8c59be7e591a0d0ff17627ea34ea1eaa110a09.camel@intel.com>
In-Reply-To: <2d8c59be7e591a0d0ff17627ea34ea1eaa110a09.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.30.1 (3.30.1-1.fc29) 
x-originating-ip: [10.251.0.167]
Content-Type: text/plain; charset="utf-8"
Content-ID: <3FAE5003E9627F419617E9DC8A2441C1@intel.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCAyMDE5LTA1LTIyIGF0IDE1OjQwIC0wNzAwLCBSaWNrIEVkZ2Vjb21iZSB3cm90ZToN
Cj4gT24gV2VkLCAyMDE5LTA1LTIyIGF0IDEyOjI2IC0wNzAwLCBSaWNrIEVkZ2Vjb21iZSB3cm90
ZToNCj4gPiBPbiBXZWQsIDIwMTktMDUtMjIgYXQgMTA6NDAgLTA3MDAsIERhdmlkIE1pbGxlciB3
cm90ZToNCj4gPiA+IEZyb206ICJFZGdlY29tYmUsIFJpY2sgUCIgPHJpY2sucC5lZGdlY29tYmVA
aW50ZWwuY29tPg0KPiA+ID4gRGF0ZTogVHVlLCAyMSBNYXkgMjAxOSAwMTo1OTo1NCArMDAwMA0K
PiA+ID4gDQo+ID4gPiA+IE9uIE1vbiwgMjAxOS0wNS0yMCBhdCAxODo0MyAtMDcwMCwgRGF2aWQg
TWlsbGVyIHdyb3RlOg0KPiA+ID4gPiA+IEZyb206ICJFZGdlY29tYmUsIFJpY2sgUCIgPHJpY2su
cC5lZGdlY29tYmVAaW50ZWwuY29tPg0KPiA+ID4gPiA+IERhdGU6IFR1ZSwgMjEgTWF5IDIwMTkg
MDE6MjA6MzMgKzAwMDANCj4gPiA+ID4gPiANCj4gPiA+ID4gPiA+IFNob3VsZCBpdCBoYW5kbGUg
ZXhlY3V0aW5nIGFuIHVubWFwcGVkIHBhZ2UgZ3JhY2VmdWxseT8NCj4gPiA+ID4gPiA+IEJlY2F1
c2UNCj4gPiA+ID4gPiA+IHRoaXMNCj4gPiA+ID4gPiA+IGNoYW5nZSBpcyBjYXVzaW5nIHRoYXQg
dG8gaGFwcGVuIG11Y2ggZWFybGllci4gSWYgc29tZXRoaW5nDQo+ID4gPiA+ID4gPiB3YXMNCj4g
PiA+ID4gPiA+IHJlbHlpbmcNCj4gPiA+ID4gPiA+IG9uIGEgY2FjaGVkIHRyYW5zbGF0aW9uIHRv
IGV4ZWN1dGUgc29tZXRoaW5nIGl0IGNvdWxkIGZpbmQNCj4gPiA+ID4gPiA+IHRoZQ0KPiA+ID4g
PiA+ID4gbWFwcGluZw0KPiA+ID4gPiA+ID4gZGlzYXBwZWFyLg0KPiA+ID4gPiA+IA0KPiA+ID4g
PiA+IERvZXMgdGhpcyB3b3JrIGJ5IG5vdCBtYXBwaW5nIGFueSBrZXJuZWwgbWFwcGluZ3MgYXQg
dGhlDQo+ID4gPiA+ID4gYmVnaW5uaW5nLA0KPiA+ID4gPiA+IGFuZCB0aGVuIGZpbGxpbmcgaW4g
dGhlIEJQRiBtYXBwaW5ncyBpbiByZXNwb25zZSB0byBmYXVsdHM/DQo+ID4gPiA+IE5vLCBub3Ro
aW5nIHRvbyBmYW5jeS4gSXQganVzdCBmbHVzaGVzIHRoZSB2bSBtYXBwaW5nDQo+ID4gPiA+IGlt
bWVkaWF0bHkNCj4gPiA+ID4gaW4NCj4gPiA+ID4gdmZyZWUgZm9yIGV4ZWN1dGUgKGFuZCBSTykg
bWFwcGluZ3MuIFRoZSBvbmx5IHRoaW5nIHRoYXQNCj4gPiA+ID4gaGFwcGVucw0KPiA+ID4gPiBh
cm91bmQNCj4gPiA+ID4gYWxsb2NhdGlvbiB0aW1lIGlzIHNldHRpbmcgb2YgYSBuZXcgZmxhZyB0
byB0ZWxsIHZtYWxsb2MgdG8gZG8NCj4gPiA+ID4gdGhlDQo+ID4gPiA+IGZsdXNoLg0KPiA+ID4g
PiANCj4gPiA+ID4gVGhlIHByb2JsZW0gYmVmb3JlIHdhcyB0aGF0IHRoZSBwYWdlcyB3b3VsZCBi
ZSBmcmVlZCBiZWZvcmUgdGhlDQo+ID4gPiA+IGV4ZWN1dGUNCj4gPiA+ID4gbWFwcGluZyB3YXMg
Zmx1c2hlZC4gU28gdGhlbiB3aGVuIHRoZSBwYWdlcyBnb3QgcmVjeWNsZWQsDQo+ID4gPiA+IHJh
bmRvbSwNCj4gPiA+ID4gc29tZXRpbWVzIGNvbWluZyBmcm9tIHVzZXJzcGFjZSwgZGF0YSB3b3Vs
ZCBiZSBtYXBwZWQgYXMNCj4gPiA+ID4gZXhlY3V0YWJsZQ0KPiA+ID4gPiBpbg0KPiA+ID4gPiB0
aGUga2VybmVsIGJ5IHRoZSB1bi1mbHVzaGVkIHRsYiBlbnRyaWVzLg0KPiA+ID4gDQo+ID4gPiBJ
ZiBJIGFtIHRvIHVuZGVyc3RhbmQgdGhpbmdzIGNvcnJlY3RseSwgdGhlcmUgd2FzIGEgY2FzZSB3
aGVyZQ0KPiA+ID4gJ2VuZCcNCj4gPiA+IGNvdWxkIGJlIHNtYWxsZXIgdGhhbiAnc3RhcnQnIHdo
ZW4gZG9pbmcgYSByYW5nZSBmbHVzaC4gIFRoYXQNCj4gPiA+IHdvdWxkDQo+ID4gPiBkZWZpbml0
ZWx5IGtpbGwgc29tZSBvZiB0aGUgc3BhcmM2NCBUTEIgZmx1c2ggcm91dGluZXMuDQo+ID4gDQo+
ID4gT2ssIHRoYW5rcy4NCj4gPiANCj4gPiBUaGUgcGF0Y2ggYXQgdGhlIGJlZ2lubmluZyBvZiB0
aGlzIHRocmVhZCBkb2Vzbid0IGhhdmUgdGhhdA0KPiA+IGJlaGF2aW9yDQo+ID4gdGhvdWdoIGFu
ZCBpdCBhcHBhcmVudGx5IHN0aWxsIGh1bmcuIEkgYXNrZWQgaWYgTWVlbGlzIGNvdWxkIHRlc3QN
Cj4gPiB3aXRoDQo+ID4gdGhpcyBmZWF0dXJlIGRpc2FibGVkIGFuZCBERUJVR19QQUdFQUxMT0Mg
b24sIHNpbmNlIGl0IGZsdXNoZXMgb24NCj4gPiBldmVyeQ0KPiA+IHZmcmVlIGFuZCBpcyBub3Qg
bmV3IGxvZ2ljLCBhbmQgYWxzbyB3aXRoIGEgcGF0Y2ggdGhhdCBsb2dzIGV4YWN0DQo+ID4gVExC
DQo+ID4gZmx1c2ggcmFuZ2VzIGFuZCBmYXVsdCBhZGRyZXNzZXMgb24gdG9wIG9mIHRoZSBrZXJu
ZWwgaGF2aW5nIHRoaXMNCj4gPiBpc3N1ZS4gSG9wZWZ1bGx5IHRoYXQgd2lsbCBzaGVkIHNvbWUg
bGlnaHQuDQo+ID4gDQo+ID4gU29ycnkgZm9yIGFsbCB0aGUgbm9pc2UgYW5kIHNwZWN1bGF0aW9u
IG9uIHRoaXMuIEl0IGhhcyBiZWVuDQo+ID4gZGlmZmljdWx0DQo+ID4gdG8gZGVidWcgcmVtb3Rl
bHkgd2l0aCBhIHRlc3RlciBhbmQgZGV2ZWxvcGVyIGluIGRpZmZlcmVudCB0aW1lDQo+ID4gem9u
ZXMuDQo+ID4gDQo+ID4gDQo+IE9rLCBzbyB3aXRoIGEgcGF0Y2ggdG8gZGlzYWJsZSBzZXR0aW5n
IHRoZSBuZXcgdm1hbGxvYyBmbHVzaCBmbGFnIG9uDQo+IGFyY2hpdGVjdHVyZXMgdGhhdCBoYXZl
IG5vcm1hbCBtZW1vcnkgYXMgZXhlY3V0YWJsZSAoaW5jbHVkZXMgc3BhcmMpLA0KPiBib290IHN1
Y2NlZWRzLg0KPiANCj4gV2l0aCB0aGlzIGRpc2FibGUgcGF0Y2ggYW5kIERFQlVHX1BBR0VBTExP
QyBvbiwgaXQgaGFuZ3MgZWFybGllciB0aGFuDQo+IGJlZm9yZS4gR29pbmcgZnJvbSBjbHVlcyBp
biBvdGhlciBsb2dzLCBpdCBsb29rcyBsaWtlIGl0IGhhbmdzIHJpZ2h0DQo+IGF0DQo+IHRoZSBm
aXJzdCBub3JtYWwgdmZyZWUuDQo+IA0KPiBUaGFua3MgZm9yIGFsbCB0aGUgdGVzdGluZyBNZWVs
aXMhDQo+IA0KPiBTbyBpdCBzZWVtcyBsaWtlIG90aGVyLCBub3QgbmV3LCBUTEIgZmx1c2hlcyBh
bHNvIHRyaWdnZXIgdGhlIGhhbmcuDQo+IA0KPiBGcm9tIGVhcmxpZXIgbG9ncyBwcm92aWRlZCwg
dGhpcyB2ZnJlZSB3b3VsZCBiZSB0aGUgZmlyc3QgY2FsbCB0bw0KPiBmbHVzaF90bGJfa2VybmVs
X3JhbmdlKCksIGFuZCBiZWZvcmUgYW55IEJQRiBhbGxvY2F0aW9ucyBhcHBlYXIgaW4NCj4gdGhl
DQo+IGxvZ3MuIFNvIEkgYW0gc3VzcGVjdGluZyBzb21lIG90aGVyIGNhdXNlIHRoYW4gdGhlIGJp
c2VjdGVkIHBhdGNoIGF0DQo+IHRoaXMgcG9pbnQsIGJ1dCBJIGd1ZXNzIGl0J3Mgbm90IGZ1bGx5
IGNvbmNsdXNpdmUuDQo+IA0KPiBJdCBjb3VsZCBiZSBpbmZvcm1hdGl2ZSB0byBiaXNlY3QgdXBz
dHJlYW0gYWdhaW4gd2l0aCB0aGUNCj4gREVCVUdfUEFHRUFMTE9DIGNvbmZpZ3Mgb24sIHRvIHNl
ZSBpZiBpdCBpbmRlZWQgcG9pbnRzIHRvIGFuIGVhcmxpZXINCj4gY29tbWl0Lg0KDQpTbyBub3cg
TWVlbGlzIGhhcyBmb3VuZCB0aGF0IHRoZSBjb21taXQgYmVmb3JlIGFueSBvZiBteSB2bWFsbG9j
DQpjaGFuZ2VzIGFsc28gaGFuZ3MgZHVyaW5nIGJvb3Qgd2l0aCBERUJVR19QQUdFQUxMT0Mgb24u
IEl0IGRvZXMgdGhpcw0Kc2hvcnRseSBhZnRlciB0aGUgZmlyc3QgdmZyZWUsIHdoaWNoIERFQlVH
X1BBR0VBTExPQyB3b3VsZCBvZiBjb3Vyc2UNCm1ha2UgdHJpZ2dlciBhIGZsdXNoX3RsYl9rZXJu
ZWxfcmFuZ2UoKSBvbiB0aGUgYWxsb2NhdGlvbiBqdXN0IGxpa2UgbXkNCnZtYWxsb2MgY2hhbmdl
cyBkbyBvbiBjZXJ0YWluIHZtYWxsb2NzLiBUaGUgdXBzdHJlYW0gY29kZSBjYWxscw0Kdm1fdW5t
YXBfYWxpYXNlcygpIGluc3RlYWQgb2YgdGhlIGZsdXNoX3RsYl9rZXJuZWxfcmFuZ2UoKSBkaXJl
Y3RseSwNCmJ1dCB3ZSBhbHNvIHRlc3RlZCBhIHZlcnNpb24gdGhhdCBjYWxsZWQgdGhlIGZsdXNo
IGRpcmVjdGx5IG9uIGp1c3QgdGhlDQphbGxvY2F0aW9uIGFuZCBpdCBhbHNvIGh1bmcuIFNvIGl0
IHNlZW1zIGxpa2UgaXNzdWVzIGZsdXNoaW5nIHZtYWxsb2NzDQpvbiB0aGlzIHBsYXRmb3JtIGV4
aXN0IG91dHNpZGUgbXkgY29tbWl0cy4NCg0KSG93IGRvIHBlb3BsZSBmZWVsIGFib3V0IGNhbGxp
bmcgdGhpcyBhIHNwYXJjIHNwZWNpZmljIGlzc3VlIHVuY292ZXJlZA0KYnkgbXkgcGF0Y2ggaW5z
dGVhZCBvZiBjYXVzZWQgYnkgaXQgYXQgdGhpcyBwb2ludD8NCg0KSWYgcGVvcGxlIGFncmVlIHdp
dGggdGhpcyBhc3Nlc21lbnQsIGl0IG9mIGNvdXJzZSBzdGlsbCBzZWVtcyBsaWtlIHRoZQ0KbmV3
IGNoYW5nZXMgdHVybiB0aGUgcm9vdCBjYXVzZSBpbnRvIGEgbW9yZSBpbXBhY3RmdWwgaXNzdWUg
Zm9yIHRoaXMNCnNwZWNpZmljIGNvbWJpbmF0aW9uLiBPbiB0aGUgb3RoZXIgaGFuZCBJIGFtIG5v
dCB0aGUgcmlnaHQgcGVyc29uIHRvDQpmaXggdGhlIHJvb3QgY2F1c2UgZm9yIHNldmVyYWwgcmVh
c29ucyBpbmNsdWRpbmcgbm8gaGFyZHdhcmUgYWNjZXNzLiANCg0KT3RoZXJ3aXNlIEkgY291bGQg
c3VibWl0IGEgcGF0Y2ggdG8gZGlzYWJsZSB0aGlzIGZvciBzcGFyYyBzaW5jZSBpdA0KZG9lc24n
dCByZWFsbHkgZ2V0IGEgc2VjdXJpdHkgYmVuZWZpdCBmcm9tIGl0IGFueXdheS4gV2hhdCBkbyBw
ZW9wbGUNCnRoaW5rPw0K
