Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BD6135FEAC
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 01:59:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230300AbhDNX7r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 19:59:47 -0400
Received: from mga02.intel.com ([134.134.136.20]:34444 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229950AbhDNX7p (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Apr 2021 19:59:45 -0400
IronPort-SDR: bdDVVIgRAzQUYJZxMIpoLAISrO2q23ayZ0Wy7maTtLaVlCaixdRlMlPPA3yBNWzw967UBXDY7E
 3V+JctbnYG3w==
X-IronPort-AV: E=McAfee;i="6200,9189,9954"; a="181885054"
X-IronPort-AV: E=Sophos;i="5.82,223,1613462400"; 
   d="scan'208";a="181885054"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2021 16:59:23 -0700
IronPort-SDR: InwZlV3slnxYdaU1Dmn7jBXlUDgDRRGioskgYp9rBwKfF1aB6/O/f6haY5lguUDINTCLcN0kGv
 0a20GZPhNjLA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,223,1613462400"; 
   d="scan'208";a="532956137"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga004.jf.intel.com with ESMTP; 14 Apr 2021 16:59:23 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Wed, 14 Apr 2021 16:59:22 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Wed, 14 Apr 2021 16:59:22 -0700
Received: from orsmsx610.amr.corp.intel.com ([10.22.229.23]) by
 ORSMSX610.amr.corp.intel.com ([10.22.229.23]) with mapi id 15.01.2106.013;
 Wed, 14 Apr 2021 16:59:22 -0700
From:   "Joseph, Jithu" <jithu.joseph@intel.com>
To:     "kuba@kernel.org" <kuba@kernel.org>
CC:     "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "dvorax.fuxbrumer@linux.intel.com" <dvorax.fuxbrumer@linux.intel.com>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "Gomes, Vinicius" <vinicius.gomes@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Neftin, Sasha" <sasha.neftin@intel.com>,
        "Lifshits, Vitaly" <vitaly.lifshits@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "Desouza, Ederson" <ederson.desouza@intel.com>,
        "bjorn.topel@intel.com" <bjorn.topel@intel.com>
Subject: Re: [PATCH net-next 8/9] igc: Enable RX via AF_XDP zero-copy
Thread-Topic: [PATCH net-next 8/9] igc: Enable RX via AF_XDP zero-copy
Thread-Index: AQHXLV9MqdOlpCSiGk+7GOoxfqoO8qqtXZQAgAfEvYCAAAMQAIAACZiA
Date:   Wed, 14 Apr 2021 23:59:22 +0000
Message-ID: <3ca4bc81f52a50d91c2ec55906c934244ee397c9.camel@intel.com>
References: <20210409164351.188953-1-anthony.l.nguyen@intel.com>
         <20210409164351.188953-9-anthony.l.nguyen@intel.com>
         <20210409173604.217406b6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <fcd46fb09a08af36b7c34693f4e687d2c9ca2422.camel@intel.com>
         <20210414162500.397ddb7f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210414162500.397ddb7f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.4-0ubuntu1 
x-originating-ip: [10.22.254.132]
Content-Type: text/plain; charset="utf-8"
Content-ID: <BAC049B11B8E424ABCC0584519876644@intel.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCAyMDIxLTA0LTE0IGF0IDE2OjI1IC0wNzAwLCBKYWt1YiBLaWNpbnNraSB3cm90ZToN
Cj4gT24gV2VkLCAxNCBBcHIgMjAyMSAyMzoxNDowNCArMDAwMCBKb3NlcGgsIEppdGh1IHdyb3Rl
Og0KPiA+ID4gPiArc3RhdGljIHN0cnVjdCBza19idWZmICppZ2NfY29uc3RydWN0X3NrYl96Yyhz
dHJ1Y3QgaWdjX3JpbmcNCj4gPiA+ID4gKnJpbmcsDQo+ID4gPiA+ICsJCQkJCSAgICBzdHJ1Y3Qg
eGRwX2J1ZmYNCj4gPiA+ID4gKnhkcCkNCj4gPiA+ID4gK3sNCj4gPiA+ID4gKwl1bnNpZ25lZCBp
bnQgbWV0YXNpemUgPSB4ZHAtPmRhdGEgLSB4ZHAtPmRhdGFfbWV0YTsNCj4gPiA+ID4gKwl1bnNp
Z25lZCBpbnQgZGF0YXNpemUgPSB4ZHAtPmRhdGFfZW5kIC0geGRwLT5kYXRhOw0KPiA+ID4gPiAr
CXN0cnVjdCBza19idWZmICpza2I7DQo+ID4gPiA+ICsNCj4gPiA+ID4gKwlza2IgPSBfX25hcGlf
YWxsb2Nfc2tiKCZyaW5nLT5xX3ZlY3Rvci0+bmFwaSwNCj4gPiA+ID4gKwkJCSAgICAgICB4ZHAt
PmRhdGFfZW5kIC0geGRwLQ0KPiA+ID4gPiA+ZGF0YV9oYXJkX3N0YXJ0LA0KPiA+ID4gPiArCQkJ
ICAgICAgIEdGUF9BVE9NSUMgfCBfX0dGUF9OT1dBUk4pOw0KPiA+ID4gPiArCWlmICh1bmxpa2Vs
eSghc2tiKSkNCj4gPiA+ID4gKwkJcmV0dXJuIE5VTEw7DQo+ID4gPiA+ICsNCj4gPiA+ID4gKwlz
a2JfcmVzZXJ2ZShza2IsIHhkcC0+ZGF0YSAtIHhkcC0+ZGF0YV9oYXJkX3N0YXJ0KTsNCj4gPiA+
ID4gKwltZW1jcHkoX19za2JfcHV0KHNrYiwgZGF0YXNpemUpLCB4ZHAtPmRhdGEsIGRhdGFzaXpl
KTsNCj4gPiA+ID4gKwlpZiAobWV0YXNpemUpDQo+ID4gPiA+ICsJCXNrYl9tZXRhZGF0YV9zZXQo
c2tiLCBtZXRhc2l6ZSk7ICANCj4gPiA+IA0KPiA+ID4gQnV0IHlvdSBoYXZlbid0IGFjdHVhbGx5
IGNvcGllZCB0aGUgbWF0YWRhdGEgaW50byB0aGUgc2tiLA0KPiA+ID4gdGhlIG1ldGFkYXRhIGlz
IGJlZm9yZSB4ZHAtPmRhdGEsIHJpZ2h0PyAgDQo+ID4gDQo+ID4gVG9kYXkgdGhlIGlnYyBkcml2
ZXIgZG9lc27igJl0IGFkZCBhbnkgbWV0YWRhdGEgKGV4Y2VwdCBmb3IgaHcgdGltZQ0KPiA+IHN0
YW1wcyBleHBsYWluZWQgbGF0ZXIpIC4gU28gZm9yIG1vc3QgcGFydCwgeGRwLT5kYXRhIGFuZCB4
ZHAtDQo+ID4gPiBkYXRhX21ldGEgcG9pbnQgdG8gdGhlIHNhbWUgYWRkcmVzcyAuIFRoYXQgY291
bGQgYmUgd2h5IGluIHRoaXMgIA0KPiA+IGluaXRpYWwgaW1wbGVtZW50YXRpb24gd2UgYXJlIG5v
dCBjb3B5aW5nICB0aGUgbWV0YWRhdGEgaW50byBza2INCj4gPiAoYXMNCj4gPiB0aGUgZHJpdmVy
IGRvZXNu4oCZdCBhZGQgYW55KS4gIA0KPiANCj4gSSBkb24ndCB0aGluayB0aGUgdGltZXN0YW1w
IGlzIHN1cHBvc2VkIHRvIGJlIHBhcnQgb2YgdGhlIG1ldGFkYXRhLg0KPiBXZSdyZSB0YWxraW5n
IGFib3V0IEJQRiBtZXRhZGF0YSBoZXJlIChhZGRlZCBieSB0aGUgWERQIHByb2cpLg0KPiANCj4g
PiBJZiB0aGUgWERQIHByb2dyYW0gYWRkcyBzb21lIG1ldGFkYXRhIGJlZm9yZSB4ZHAtPmRhdGEg
KGFuZCAgeGRwLQ0KPiA+ID4gZGF0YV9tZXRhIHJlZmxlY3RzIHRoaXMpLCB0aGF0IGlzIE5PVCBj
b3BpZWQgaW50byB0aGUgU0tCIGFzDQo+ID4gPiB5b3UgIA0KPiA+IG1lbnRpb25lZCAuICAgSXMg
dGhlIGV4cGVjdGF0aW9uIHRoYXQgbWV0YV9kYXRhIChpZiBhbnkgYWRkZWQgYnkNCj4gPiB0aGUN
Cj4gPiBicGYgcHJvZ3JhbSkgLCBzaG91bGQgYWxzbyBiZSBjb3BpZWQgdG8gdGhlIHNrYiAgaW4g
dGhpcyBYRFBfUEFTUw0KPiA+IGZsb3cNCj4gPiA/IElmIHNvIEkgY2FuIHJldmlzZSB0aGlzIHBh
dGNoIHRvIGRvIHRoYXQuIA0KPiANCj4gWWVzLCBJIGJlbGlldmUgc28uDQo+IA0KPiA+IElmIGgv
dyB0aW1lLXN0YW1wIGlzIGFkZGVkIGJ5IHRoZSBOSUMsIHRoZW4gbWV0YXNpemUgd2lsbCBiZSBu
b24NCj4gPiB6ZXJvDQo+ID4gKGFzICB4ZHAtPmRhdGEgaXMgYWR2YW5jZWQgYnkgdGhlIGRyaXZl
ciApIC4gIGgvdyB0cyAgaXMgc3RpbGwNCj4gPiBjb3BpZWQNCj4gPiBpbnRvICJza2JfaHd0c3Rh
bXBzKHNrYiktPmh3dHN0YW1wIiBieSAgdGhlIGNhbGxlciBvZiB0aGlzIGZ1bmN0aW9uDQo+ID4g
aWdjX2Rpc3BhdGNoX3NrYl96YygpICAuIERvIHlvdSBzdGlsbCB3YW50IGl0IHRvIGJlIGNvcGll
ZCBpbnRvDQo+ID4gX19za2JfcHV0KHNrYiwgKSBhcmVhIHRvbyA/IA0KPiANCj4gSWYgVFMgaXMg
cHJlcGVuZGVkIHRvIHRoZSBmcmFtZSBpdCBzaG91bGQgYmUgc2F2ZWQgKGUuZy4gb24gdGhlDQo+
IHN0YWNrKQ0KPiBiZWZvcmUgWERQIHByb2dyYW0gaXMgY2FsbGVkIGFuZCBnZXRzIHRoZSBjaGFu
Y2UgdG8gb3ZlcndyaXRlIGl0LiBUaGUNCj4gbWV0YWRhdGEgbGVuZ3RoIHdoZW4gWERQIHByb2dy
YW0gaXMgY2FsbGVkIHNob3VsZCBiZSAwLg0KDQpXaGVuIHlvdSBzYXkgbWV0YWRhdGEgbGVuZ3Ro
IHNob3VsZCBiZSAwIGFib3ZlLCBEbyB5b3UgbWVhbiB0aGF0IHdoZW4NCmJwZl9wcm9nX3J1bl94
ZHAocHJvZywgeGRwKSBpcyBpbnZva2VkLCB4ZHAtPmRhdGEgYW5kIHhkcC0+ZGF0YV9tZXRhDQpz
aG91bGQgcG9pbnQgdG8gdGhlIHNhbWUgYWRkcmVzcyA/DQoNCg==
