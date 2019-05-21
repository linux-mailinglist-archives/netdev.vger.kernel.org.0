Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC957245D0
	for <lists+netdev@lfdr.de>; Tue, 21 May 2019 04:00:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727059AbfEUB74 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 May 2019 21:59:56 -0400
Received: from mga09.intel.com ([134.134.136.24]:33841 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726412AbfEUB74 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 May 2019 21:59:56 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 May 2019 18:59:55 -0700
X-ExtLoop1: 1
Received: from orsmsx107.amr.corp.intel.com ([10.22.240.5])
  by fmsmga001.fm.intel.com with ESMTP; 20 May 2019 18:59:55 -0700
Received: from orsmsx122.amr.corp.intel.com (10.22.225.227) by
 ORSMSX107.amr.corp.intel.com (10.22.240.5) with Microsoft SMTP Server (TLS)
 id 14.3.408.0; Mon, 20 May 2019 18:59:54 -0700
Received: from orsmsx112.amr.corp.intel.com ([169.254.3.79]) by
 ORSMSX122.amr.corp.intel.com ([169.254.11.150]) with mapi id 14.03.0415.000;
 Mon, 20 May 2019 18:59:54 -0700
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
Thread-Index: AQHVD0ezpbXySuUS5EinefGl750kkaZ0/uwAgAALkwCAAAiygIAAGYEAgAADqwCAAA0vgIAABnMAgAAEjYA=
Date:   Tue, 21 May 2019 01:59:54 +0000
Message-ID: <339ef85d984f329aa66f29fa80781624e6e4aecc.camel@intel.com>
References: <3e7e674c1fe094cd8dbe0c8933db18be1a37d76d.camel@intel.com>
         <20190520.203320.621504228022195532.davem@davemloft.net>
         <a43f9224e6b245ade4b587a018c8a21815091f0f.camel@intel.com>
         <20190520.184336.743103388474716249.davem@davemloft.net>
In-Reply-To: <20190520.184336.743103388474716249.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.30.1 (3.30.1-1.fc29) 
x-originating-ip: [10.254.114.95]
Content-Type: text/plain; charset="utf-8"
Content-ID: <8EBD949950AB8941B07DC53183E4B2A9@intel.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCAyMDE5LTA1LTIwIGF0IDE4OjQzIC0wNzAwLCBEYXZpZCBNaWxsZXIgd3JvdGU6DQo+
IEZyb206ICJFZGdlY29tYmUsIFJpY2sgUCIgPHJpY2sucC5lZGdlY29tYmVAaW50ZWwuY29tPg0K
PiBEYXRlOiBUdWUsIDIxIE1heSAyMDE5IDAxOjIwOjMzICswMDAwDQo+IA0KPiA+IFNob3VsZCBp
dCBoYW5kbGUgZXhlY3V0aW5nIGFuIHVubWFwcGVkIHBhZ2UgZ3JhY2VmdWxseT8gQmVjYXVzZQ0K
PiA+IHRoaXMNCj4gPiBjaGFuZ2UgaXMgY2F1c2luZyB0aGF0IHRvIGhhcHBlbiBtdWNoIGVhcmxp
ZXIuIElmIHNvbWV0aGluZyB3YXMNCj4gPiByZWx5aW5nDQo+ID4gb24gYSBjYWNoZWQgdHJhbnNs
YXRpb24gdG8gZXhlY3V0ZSBzb21ldGhpbmcgaXQgY291bGQgZmluZCB0aGUNCj4gPiBtYXBwaW5n
DQo+ID4gZGlzYXBwZWFyLg0KPiANCj4gRG9lcyB0aGlzIHdvcmsgYnkgbm90IG1hcHBpbmcgYW55
IGtlcm5lbCBtYXBwaW5ncyBhdCB0aGUgYmVnaW5uaW5nLA0KPiBhbmQgdGhlbiBmaWxsaW5nIGlu
IHRoZSBCUEYgbWFwcGluZ3MgaW4gcmVzcG9uc2UgdG8gZmF1bHRzPw0KTm8sIG5vdGhpbmcgdG9v
IGZhbmN5LiBJdCBqdXN0IGZsdXNoZXMgdGhlIHZtIG1hcHBpbmcgaW1tZWRpYXRseSBpbg0KdmZy
ZWUgZm9yIGV4ZWN1dGUgKGFuZCBSTykgbWFwcGluZ3MuIFRoZSBvbmx5IHRoaW5nIHRoYXQgaGFw
cGVucyBhcm91bmQNCmFsbG9jYXRpb24gdGltZSBpcyBzZXR0aW5nIG9mIGEgbmV3IGZsYWcgdG8g
dGVsbCB2bWFsbG9jIHRvIGRvIHRoZQ0KZmx1c2guDQoNClRoZSBwcm9ibGVtIGJlZm9yZSB3YXMg
dGhhdCB0aGUgcGFnZXMgd291bGQgYmUgZnJlZWQgYmVmb3JlIHRoZSBleGVjdXRlDQptYXBwaW5n
IHdhcyBmbHVzaGVkLiBTbyB0aGVuIHdoZW4gdGhlIHBhZ2VzIGdvdCByZWN5Y2xlZCwgcmFuZG9t
LA0Kc29tZXRpbWVzIGNvbWluZyBmcm9tIHVzZXJzcGFjZSwgZGF0YSB3b3VsZCBiZSBtYXBwZWQg
YXMgZXhlY3V0YWJsZSBpbg0KdGhlIGtlcm5lbCBieSB0aGUgdW4tZmx1c2hlZCB0bGIgZW50cmll
cy4NCg0KDQo=
