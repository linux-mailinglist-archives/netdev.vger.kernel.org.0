Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F7932EF65
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 05:55:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387916AbfE3DzP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 23:55:15 -0400
Received: from mga18.intel.com ([134.134.136.126]:49752 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387913AbfE3DzN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 May 2019 23:55:13 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 May 2019 20:55:12 -0700
X-ExtLoop1: 1
Received: from orsmsx104.amr.corp.intel.com ([10.22.225.131])
  by orsmga008.jf.intel.com with ESMTP; 29 May 2019 20:55:12 -0700
Received: from orsmsx112.amr.corp.intel.com ([169.254.3.79]) by
 ORSMSX104.amr.corp.intel.com ([169.254.4.200]) with mapi id 14.03.0415.000;
 Wed, 29 May 2019 20:55:12 -0700
From:   "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "sparclinux@vger.kernel.org" <sparclinux@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "jeyu@kernel.org" <jeyu@kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "ard.biesheuvel@arm.com" <ard.biesheuvel@arm.com>,
        "mroos@linux.ee" <mroos@linux.ee>,
        "will.deacon@arm.com" <will.deacon@arm.com>,
        "namit@vmware.com" <namit@vmware.com>,
        "luto@kernel.org" <luto@kernel.org>,
        "Hansen, Dave" <dave.hansen@intel.com>
Subject: Re: [PATCH] vmalloc: Don't use flush flag when no exec perm
Thread-Topic: [PATCH] vmalloc: Don't use flush flag when no exec perm
Thread-Index: AQHVFeKXsxy+QkOKqU23zfNpAWli4aaDgIiA
Date:   Thu, 30 May 2019 03:55:11 +0000
Message-ID: <89d6dee949e4418f0cca4cc6c4c9b526c1a5c497.camel@intel.com>
References: <20190529055104.6822-1-rick.p.edgecombe@intel.com>
In-Reply-To: <20190529055104.6822-1-rick.p.edgecombe@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.30.1 (3.30.1-1.fc29) 
x-originating-ip: [10.252.134.167]
Content-Type: text/plain; charset="utf-8"
Content-ID: <79E9AE6E691D6044A8CEADDFF380D81D@intel.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDE5LTA1LTI4IGF0IDIyOjUxIC0wNzAwLCBSaWNrIEVkZ2Vjb21iZSB3cm90ZToN
Cj4gVGhlIGFkZGl0aW9uIG9mIFZNX0ZMVVNIX1JFU0VUX1BFUk1TIGZvciBCUEYgSklUIGFsbG9j
YXRpb25zIHdhcw0KPiBiaXNlY3RlZCB0byBwcmV2ZW50IGJvb3Qgb24gYW4gVWx0cmFTcGFyYyBJ
SUkgbWFjaGluZS4gSXQgd2FzIGZvdW5kDQo+IHRoYXQNCj4gc29tZXRpbWUgc2hvcnRseSBhZnRl
ciB0aGUgVExCIGZsdXNoIHRoaXMgZmxhZyBkb2VzIG9uIHZmcmVlIG9mIHRoZQ0KPiBCUEYNCj4g
cHJvZ3JhbSwgdGhlIG1hY2hpbmUgaHVuZy4gRnVydGhlciBpbnZlc3RpZ2F0aW9uIHNob3dlZCB0
aGF0IGJlZm9yZQ0KPiBhbnkgb2YNCj4gdGhlIGNoYW5nZXMgZm9yIHRoaXMgZmxhZyB3ZXJlIGlu
dHJvZHVjZWQsIHdpdGgNCj4gQ09ORklHX0RFQlVHX1BBR0VBTExPQw0KPiBjb25maWd1cmVkICh3
aGljaCBkb2VzIGEgc2ltaWxhciBUTEIgZmx1c2ggb2YgdGhlIHZtYWxsb2MgcmFuZ2Ugb24NCj4g
ZXZlcnkgdmZyZWUpLCB0aGlzIG1hY2hpbmUgYWxzbyBodW5nIHNob3J0bHkgYWZ0ZXIgdGhlIGZp
cnN0IHZtYWxsb2MNCj4gdW5tYXAvZnJlZS4NCj4gDQo+IFNvIHRoZSBldmlkZW5jZSBwb2ludHMg
dG8gdGhlcmUgYmVpbmcgc29tZSBleGlzdGluZyBpc3N1ZSB3aXRoIHRoZQ0KPiB2bWFsbG9jIFRM
QiBmbHVzaGVzLCBidXQgaXQncyBzdGlsbCB1bmtub3duIGV4YWN0bHkgd2h5IHRoZXNlIGhhbmdz
DQo+IGFyZQ0KPiBoYXBwZW5pbmcgb24gc3BhcmMuIEl0IGlzIGFsc28gdW5rbm93biB3aGVuIHNv
bWVvbmUgd2l0aCB0aGlzDQo+IGhhcmR3YXJlDQo+IGNvdWxkIHJlc29sdmUgdGhpcywgYW5kIGlu
IHRoZSBtZWFudGltZSB1c2luZyB0aGlzIGZsYWcgb24gaXQgdHVybnMgYQ0KPiBsdXJraW5nIGJl
aGF2aW9yIGludG8gc29tZXRoaW5nIHRoYXQgcHJldmVudHMgYm9vdC4NCg0KVGhlIHNwYXJjIFRM
QiBmbHVzaCBpc3N1ZSBoYXMgYmVlbiBiaXNlY3RlZCBhbmQgaXMgYmVpbmcgd29ya2VkIG9uIG5v
dywNCnNvIGhvcGVmdWxseSB3ZSB3b24ndCBuZWVkIHRoaXMgcGF0Y2g6DQpodHRwczovL21hcmMu
aW5mby8/bD1saW51eC1zcGFyYyZtPTE1NTkxNTY5NDMwNDExOCZ3PTINCg==
