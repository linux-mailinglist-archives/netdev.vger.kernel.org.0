Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7976C22A8F
	for <lists+netdev@lfdr.de>; Mon, 20 May 2019 05:57:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728675AbfETDyn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 May 2019 23:54:43 -0400
Received: from mga06.intel.com ([134.134.136.31]:57644 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727057AbfETDyn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 19 May 2019 23:54:43 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 May 2019 20:54:41 -0700
X-ExtLoop1: 1
Received: from orsmsx105.amr.corp.intel.com ([10.22.225.132])
  by FMSMGA003.fm.intel.com with ESMTP; 19 May 2019 20:54:41 -0700
Received: from orsmsx157.amr.corp.intel.com (10.22.240.23) by
 ORSMSX105.amr.corp.intel.com (10.22.225.132) with Microsoft SMTP Server (TLS)
 id 14.3.408.0; Sun, 19 May 2019 20:54:40 -0700
Received: from orsmsx112.amr.corp.intel.com ([169.254.3.79]) by
 ORSMSX157.amr.corp.intel.com ([169.254.9.37]) with mapi id 14.03.0415.000;
 Sun, 19 May 2019 20:54:40 -0700
From:   "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "sparclinux@vger.kernel.org" <sparclinux@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
CC:     "bp@alien8.de" <bp@alien8.de>, "mroos@linux.ee" <mroos@linux.ee>,
        "luto@kernel.org" <luto@kernel.org>,
        "namit@vmware.com" <namit@vmware.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "mingo@redhat.com" <mingo@redhat.com>
Subject: Re: [PATCH 1/1] vmalloc: Fix issues with flush flag
Thread-Topic: [PATCH 1/1] vmalloc: Fix issues with flush flag
Thread-Index: AQHVDPQ89Mk/2ntUo0SzbjfhLaw0JaZz2GuA
Date:   Mon, 20 May 2019 03:54:40 +0000
Message-ID: <371f4eab57d4fa919b33cf4c3b6e5e0eb9eabc20.camel@intel.com>
References: <20190517210123.5702-1-rick.p.edgecombe@intel.com>
         <20190517210123.5702-2-rick.p.edgecombe@intel.com>
In-Reply-To: <20190517210123.5702-2-rick.p.edgecombe@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.30.1 (3.30.1-1.fc29) 
x-originating-ip: [10.254.94.129]
Content-Type: text/plain; charset="utf-8"
Content-ID: <91FB6DBB8B06D942BDD652676B3D5840@intel.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGksDQoNCkFmdGVyIGludmVzdGlnYXRpbmcgdGhpcyBtb3JlLCBJIGFtIG5vdCBwb3NpdGl2ZSB3
aHkgdGhpcyBmaXhlcyB0aGUNCmlzc3VlIG9uIHNwYXJjLiBJIHdpbGwgY29udGludWUgdG8gaW52
ZXN0aWdhdGUgYXMgYmVzdCBJIGNhbiwgYnV0IHdvdWxkDQpsaWtlIHRvIHJlcXVlc3QgaGVscCBm
cm9tIHNvbWUgc3BhcmMgZXhwZXJ0cyBvbiBldmFsdWF0aW5nIG15IGxpbmUgb2YNCnRoaW5raW5n
LiBJIHRoaW5rIHRoZSBjaGFuZ2VzIGluIHRoaXMgcGF0Y2ggYXJlIHN0aWxsIHZlcnkgd29ydGh3
aGlsZQ0KZ2VuZXJhbGx5IHRob3VnaC4NCg0KDQpCZXNpZGVzIGZpeGluZyB0aGUgc3BhcmMgaXNz
dWU6DQoNCjEuIFRoZSBmaXhlcyBmb3IgdGhlIGNhbGN1bGF0aW9uIG9mIHRoZSBkaXJlY3QgbWFw
IGFkZHJlc3MgcmFuZ2UgYXJlDQppbXBvcnRhbnQgb24geDg2IGluIGNhc2UgYSBSTyBkaXJlY3Qg
bWFwIGFsaWFzIGV2ZXIgZ2V0cyBsb2FkZWQgaW50bw0KdGhlIFRMQi4gVGhpcyBzaG91bGRuJ3Qg
bm9ybWFsbHkgaGFwcGVuLCBidXQgaXQgY291bGQgY2F1c2UgdGhlDQpwZXJtaXNzaW9ucyB0byBu
b3QgZ2V0IHJlc2V0IG9uIHRoZSBkaXJlY3QgbWFwIGFsaWFzLCBhbmQgdGhlbiB0aGUgcGFnZQ0K
d291bGQgcmV0dXJuIGZyb20gdGhlIHBhZ2UgYWxsb2NhdG9yIHRvIHNvbWUgb3RoZXIgY29tcG9u
ZW50IGFzIFJPIGFuZA0KY2F1c2UgYSBjcmFzaC4gVGhpcyB3YXMgbW9zdGx5IGJyb2tlbiBpbXBs
ZW1lbnRpbmcgYSBzdHlsZSBzdWdnZXN0aW9uDQpsYXRlIGluIHRoZSBkZXZlbG9wbWVudC4gQXMg
YmVzdCBJIGNhbiB0ZWxsLCBpdCBzaG91bGRuJ3QgaGF2ZSBhbnkNCmVmZmVjdCBvbiBzcGFyYy4N
Cg0KMi4gU2ltcGx5IGZsdXNoaW5nIHRoZSBUTEIgaW5zdGVhZCBvZiB0aGUgd2hvbGUgdm1fdW5t
YXBfYWxpYXMoKQ0Kb3BlcmF0aW9uIG1ha2VzIHRoZSBmcmVlcyBmYXN0ZXIgYW5kIHB1c2hlcyB0
aGUgaGVhdnkgd29yayB0byBoYXBwZW4gb24NCmFsbG9jYXRpb24gd2hlcmUgaXQgd291bGQgYmUg
bW9yZSBleHBlY3RlZC4gdm1fdW5tYXBfYWxpYXMoKSB0YWtlcyBzb21lDQpsb2NrcyBpbmNsdWRp
bmcgYSBsb25nIGhvbGQgb2Ygdm1hcF9wdXJnZV9sb2NrLCB3aGljaCB3aWxsIG1ha2UgYWxsDQpv
dGhlciBWTV9GTFVTSF9SRVNFVF9QRVJNUyB2ZnJlZXMgd2FpdCB3aGlsZSB0aGUgcHVyZ2Ugb3Bl
cmF0aW9uDQpoYXBwZW5zLg0KDQoNClRoZSBpc3N1ZSBvYnNlcnZlZCBvbiBhbiBVbHRyYVNwYXJj
IElJSSBzeXN0ZW0gd2FzIGEgaGFuZyBvbiBib290LiBUaGUNCm9ubHkgc2lnbmlmaWNhbnQgZGlm
ZmVyZW5jZSBJIGNhbiBmaW5kIGluIGhvdyBTcGFyYyB3b3JrcyBpbiB0aGlzIGFyZWENCmlzIHRo
YXQgdGhlcmUgaXMgYWN0dWFsbHkgc3BlY2lhbCBvcHRpbWl6YXRpb24gaW4gdGhlIFRMQiBmbHVz
aCBmb3INCmhhbmRsaW5nIHZtYWxsb2MgbGF6eSBwdXJnZSBvcGVyYXRpb25zLg0KDQpTb21lIGZp
cm13YXJlIG1hcHBpbmdzIGxpdmUgYmV0d2VlbiB0aGUgbW9kdWxlcyBhbmQgdm1hbGxvYyByYW5n
ZXMsIGFuZA0KaWYgdGhlaXIgdHJhbnNsYXRpb25zIGFyZSBmbHVzaGVkIGNhbiBjYXVzZSAiaGFy
ZCBoYW5ncyBhbmQgY3Jhc2hlcw0KWzFdLiBBZGRpdGlvbmFsbHkgaW4gdGhlIG1peCwgInNwYXJj
NjQga2VybmVsIGxlYXJucyBhYm91dA0Kb3BlbmZpcm13YXJlJ3MgZHluYW1pYyBtYXBwaW5ncyBp
biB0aGlzIHJlZ2lvbiBlYXJseSBpbiB0aGUgYm9vdCwgYW5kDQp0aGVuIHNlcnZpY2VzIFRMQiBt
aXNzZXMgaW4gdGhpcyBhcmVhIi5bMV0gVGhlIGZpcm13YXJlIHByb3RlY3Rpb24NCmxvZ2ljIHNl
ZW1zIHRvIGJlIGluIHBsYWNlLCBob3dldmVyIGxhdGVyIGFub3RoZXIgY2hhbmdlIHdhcyBtYWRl
IGluDQp0aGUgbG93ZXIgYXNtIHRvIGRvIGEgImZsdXNoIGFsbCIgaWYgdGhlIHJhbmdlIHdhcyBi
aWcgZW5vdWdoIG9uIHRoaXMNCmNwdSBbMl0uIFdpdGggdGhlIGFkdmVudCBvZiB0aGUgY2hhbmdl
IHRoaXMgcGF0Y2ggYWRkcmVzc2VzLCB0aGUgcHVyZ2UNCm9wZXJhdGlvbnMgd291bGQgYmUgaGFw
cGVuaW5nIG11Y2ggZWFybGllciB0aGFuIGJlZm9yZSwgd2l0aCB0aGUgZmlyc3QNCnNwZWNpYWwg
cGVybWlzc2lvbmVkIHZmcmVlLCBpbnN0ZWFkIG9mIGFmdGVyIHRoZSBtYWNoaW5lIGhhcyBiZWVu
DQpydW5uaW5nIGZvciBzb21lIHRpbWUgYW5kIHRoZSB2bWFsbG9jIHNwYWNlcyBoYWQgYmVjb21l
IGZyYWdtZW50ZWQuDQoNClNvIG15IGJlc3QgdGhlb3J5IGlzIHRoYXQgdGhlIGhpc3Rvcnkgb2Yg
dm1hbGxvYyBsYXp5IHB1cmdlcyBjYXVzaW5nDQpoYW5ncyBvbiB0aGUgc3BhcmMgaGFzIGNvbWUg
aW50byBwbGF5IGhlcmUgc29tZWhvdywgdHJpZ2dlcmVkIGJ5IHRoYXQNCndlIHdlcmUgZG9pbmcg
dGhlIHB1cmdlcyBtdWNoIGVhcmxpZXIuIElmIGl0IHdhcyBzb21ldGhpbmcgbGlrZSB0aGlzLA0K
dGhlIGZhY3QgdGhhdCB3ZSBpbnN0ZWFkIG9ubHkgZmx1c2ggdGhlIHNtYWxsIGFsbG9jYXRpb24g
aXRzZWxmIG9uDQpzcGFyYyBhZnRlciB0aGlzIHBhdGNoIHdvdWxkIGJlIHRoZSByZWFzb24gd2h5
IGl0IGZpeGVzIGl0Lg0KDQpBZG1pdHRlZGx5LCB0aGVyZSBhcmUgc29tZSBtaXNzaW5nIHBpZWNl
cyBpbiB0aGUgdGhlb3J5LiBJZiB0aGVyZSBhcmUNCmFueSBzcGFyYyBhcmNoaXRlY3R1cmUgZXhw
ZXJ0cyB0aGF0IGNhbiBoZWxwIGVubGlnaHRlbiBtZSBpZiB0aGlzDQpzb3VuZHMgcmVhc29uYWJs
ZSBhdCBhbGwgSSB3b3VsZCByZWFsbHkgYXBwcmVjaWF0ZSBpdC4NCg0KVGhhbmtzLA0KDQpSaWNr
DQoNClsxXSBodHRwczovL3BhdGNod29yay5vemxhYnMub3JnL3BhdGNoLzM3NjUyMy8NClsyXSBo
dHRwczovL3BhdGNod29yay5vemxhYnMub3JnL3BhdGNoLzY4Nzc4MC8gDQoNCg==
