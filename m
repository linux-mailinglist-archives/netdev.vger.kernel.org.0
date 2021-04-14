Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C12EE35FE4A
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 01:14:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233621AbhDNXO3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 19:14:29 -0400
Received: from mga02.intel.com ([134.134.136.20]:31327 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232201AbhDNXO2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Apr 2021 19:14:28 -0400
IronPort-SDR: IJK09KXMtycO8/+GlWQ8powTu3uoT2TZtRODCMr8drkFsXgk2pEL7v4+TEYHBRJBwARmZS026K
 cafT8KHWyXMA==
X-IronPort-AV: E=McAfee;i="6200,9189,9954"; a="181879527"
X-IronPort-AV: E=Sophos;i="5.82,223,1613462400"; 
   d="scan'208";a="181879527"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2021 16:14:05 -0700
IronPort-SDR: OS3pI5hhUt4ZoQp1RgX8/i0MUZe9p2DpVp8iwasD4AmhHvJWiBhsq7h/iFGe5HUubCLGERXifU
 X6oRWzHP1ggw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,223,1613462400"; 
   d="scan'208";a="532943614"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga004.jf.intel.com with ESMTP; 14 Apr 2021 16:14:05 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Wed, 14 Apr 2021 16:14:05 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Wed, 14 Apr 2021 16:14:04 -0700
Received: from orsmsx610.amr.corp.intel.com ([10.22.229.23]) by
 ORSMSX610.amr.corp.intel.com ([10.22.229.23]) with mapi id 15.01.2106.013;
 Wed, 14 Apr 2021 16:14:04 -0700
From:   "Joseph, Jithu" <jithu.joseph@intel.com>
To:     "kuba@kernel.org" <kuba@kernel.org>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
CC:     "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Gomes, Vinicius" <vinicius.gomes@intel.com>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "Lifshits, Vitaly" <vitaly.lifshits@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Neftin, Sasha" <sasha.neftin@intel.com>,
        "Desouza, Ederson" <ederson.desouza@intel.com>,
        "bjorn.topel@intel.com" <bjorn.topel@intel.com>,
        "dvorax.fuxbrumer@linux.intel.com" <dvorax.fuxbrumer@linux.intel.com>
Subject: Re: [PATCH net-next 8/9] igc: Enable RX via AF_XDP zero-copy
Thread-Topic: [PATCH net-next 8/9] igc: Enable RX via AF_XDP zero-copy
Thread-Index: AQHXLV9MqdOlpCSiGk+7GOoxfqoO8qqtXZQAgAfEvYA=
Date:   Wed, 14 Apr 2021 23:14:04 +0000
Message-ID: <fcd46fb09a08af36b7c34693f4e687d2c9ca2422.camel@intel.com>
References: <20210409164351.188953-1-anthony.l.nguyen@intel.com>
         <20210409164351.188953-9-anthony.l.nguyen@intel.com>
         <20210409173604.217406b6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210409173604.217406b6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.4-0ubuntu1 
x-originating-ip: [10.22.254.132]
Content-Type: text/plain; charset="utf-8"
Content-ID: <DD24DEFB12F92D4CA1E424A33A8EB3DC@intel.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgSmFrdWIsIA0KIA0KQXBvbG9naWVzIGZvciB0aGUgZGVsYXksIEkgYW0gbG9va2luZyBpbnRv
IHRoaXMgYXMgdGhlIG9yaWdpbmFsDQpkZXZlbG9wZXIgQW5kcmUgaXMgbm8tbG9uZ2VyIHdpdGgg
SW50ZWwuIEkgcmVhbGx5IGFwcHJlY2lhdGUgeW91cg0KcmV2aWV3IGZlZWRiYWNrLg0KDQooSSBy
ZW1vdmVkIEFuZHJlJ3MgYW5kIFZlZGFuZydzIGVtYWlsIGZyb20gdGhlIGNjIGxpc3QgYXMgdGhl
eSBhcmUNCmJvdW5jaW5nIGFuZCBoYXZlIGFkZGVkIGEgY291cGxlIG9mIEludGVsIGZvbGtzKSAN
Cg0KUGFyZG9uIG1lIGlmICBJIGhhdmUgbm90ICB1bmRlcnN0b29kIHlvdXIgcXVlc3Rpb25zIHBy
ZWNpc2VseSBvciBpZg0Kc29tZSBvZiB0aGUgcmVwbGllcyBhcmUgbm90IGNvbmNpc2UgKEkgYW0g
c3RpbGwgdW5kZXJzdGFuZGluZyBYRFAgZmxvdw0KcGF0dGVybnMuKSANCg0KSSAgc2VlIHRoYXQg
bG90IG9mIHRoZSBkZXNpZ24gcGF0dGVybnMgZm9sbG93ZWQgYnkgdGhpcyBwYXRjaCBzZXJpZXMs
DQpmb2xsb3cgdGhlIGFwcHJvYWNoZXMgZnJvbSBvdGhlciBJbnRlbCBkcml2ZXJzIGxpa2UgKGlj
ZSwgaXhnYmUsIGkxNDBlKQ0KDQpPbiBGcmksIDIwMjEtMDQtMDkgYXQgMTc6MzYgLTA3MDAsIEph
a3ViIEtpY2luc2tpIHdyb3RlOg0KPiBPbiBGcmksICA5IEFwciAyMDIxIDA5OjQzOjUwIC0wNzAw
IFRvbnkgTmd1eWVuIHdyb3RlOg0KPiA+IEZyb206IEFuZHJlIEd1ZWRlcyA8YW5kcmUuZ3VlZGVz
QGludGVsLmNvbT4NCj4gPiANCj4gPiBBZGQgc3VwcG9ydCBmb3IgcmVjZWl2aW5nIHBhY2tldHMg
dmlhIEFGX1hEUCB6ZXJvLWNvcHkgbWVjaGFuaXNtLg0KPiA+IA0KPiA+IEFkZCBhIG5ldyBmbGFn
IHRvICdlbnVtIGlnY19yaW5nX2ZsYWdzX3QnIHRvIGluZGljYXRlIHRoZSByaW5nIGhhcw0KPiA+
IEFGX1hEUCB6ZXJvLWNvcHkgZW5hYmxlZCBzbyBwcm9wZXIgcmluZyBzZXR1cCBpcyBjYXJyaWVk
IG91dCBkdXJpbmcNCj4gPiByaW5nDQo+ID4gY29uZmlndXJhdGlvbiBpbiBpZ2NfY29uZmlndXJl
X3J4X3JpbmcoKS4NCj4gPiANCj4gPiBSWCBidWZmZXJzIGNhbiBub3cgYmUgYWxsb2NhdGVkIHZp
YSB0aGUgc2hhcmVkIHBhZ2VzIG1lY2hhbmlzbQ0KPiA+IChkZWZhdWx0DQo+ID4gYmVoYXZpb3Ig
b2YgdGhlIGRyaXZlcikgb3IgdmlhIHhzayBwb29sICh3aGVuIEFGX1hEUCB6ZXJvLWNvcHkgaXMN
Cj4gPiBlbmFibGVkKSBzbyBhIHVuaW9uIGlzIGFkZGVkIHRvIHRoZSAnc3RydWN0IGlnY19yeF9i
dWZmZXInIHRvIGNvdmVyDQo+ID4gYm90aA0KPiA+IGNhc2VzLg0KPiA+IA0KPiA+IFdoZW4gQUZf
WERQIHplcm8tY29weSBpcyBlbmFibGVkLCByeCBidWZmZXJzIGFyZSBhbGxvY2F0ZWQgZnJvbSB0
aGUNCj4gPiB4c2sNCj4gPiBwb29sIHVzaW5nIHRoZSBuZXcgaGVscGVyIGlnY19hbGxvY19yeF9i
dWZmZXJzX3pjKCkgd2hpY2ggaXMgdGhlDQo+ID4gY291bnRlcnBhcnQgb2YgaWdjX2FsbG9jX3J4
X2J1ZmZlcnMoKS4NCj4gPiANCj4gPiBMaWtld2lzZSBvdGhlciBJbnRlbCBkcml2ZXJzIHRoYXQg
c3VwcG9ydCBBRl9YRFAgemVyby1jb3B5LCBpbiBpZ2MNCj4gPiB3ZQ0KPiA+IGhhdmUgYSBkZWRp
Y2F0ZWQgcGF0aCBmb3IgY2xlYW5pbmcgdXAgcnggaXJxcyB3aGVuIHplcm8tY29weSBpcw0KPiA+
IGVuYWJsZWQuDQo+ID4gVGhpcyBhdm9pZHMgYWRkaW5nIHRvbyBtYW55IGNoZWNrcyB3aXRoaW4g
aWdjX2NsZWFuX3J4X2lycSgpLA0KPiA+IHJlc3VsdGluZw0KPiA+IGluIGEgbW9yZSByZWFkYWJs
ZSBhbmQgZWZmaWNpZW50IGNvZGUgc2luY2UgdGhpcyBmdW5jdGlvbiBpcyBjYWxsZWQNCj4gPiBm
cm9tDQo+ID4gdGhlIGhvdC1wYXRoIG9mIHRoZSBkcml2ZXIuDQo+ID4gK3N0YXRpYyBzdHJ1Y3Qg
c2tfYnVmZiAqaWdjX2NvbnN0cnVjdF9za2JfemMoc3RydWN0IGlnY19yaW5nICpyaW5nLA0KPiA+
ICsJCQkJCSAgICBzdHJ1Y3QgeGRwX2J1ZmYgKnhkcCkNCj4gPiArew0KPiA+ICsJdW5zaWduZWQg
aW50IG1ldGFzaXplID0geGRwLT5kYXRhIC0geGRwLT5kYXRhX21ldGE7DQo+ID4gKwl1bnNpZ25l
ZCBpbnQgZGF0YXNpemUgPSB4ZHAtPmRhdGFfZW5kIC0geGRwLT5kYXRhOw0KPiA+ICsJc3RydWN0
IHNrX2J1ZmYgKnNrYjsNCj4gPiArDQo+ID4gKwlza2IgPSBfX25hcGlfYWxsb2Nfc2tiKCZyaW5n
LT5xX3ZlY3Rvci0+bmFwaSwNCj4gPiArCQkJICAgICAgIHhkcC0+ZGF0YV9lbmQgLSB4ZHAtPmRh
dGFfaGFyZF9zdGFydCwNCj4gPiArCQkJICAgICAgIEdGUF9BVE9NSUMgfCBfX0dGUF9OT1dBUk4p
Ow0KPiA+ICsJaWYgKHVubGlrZWx5KCFza2IpKQ0KPiA+ICsJCXJldHVybiBOVUxMOw0KPiA+ICsN
Cj4gPiArCXNrYl9yZXNlcnZlKHNrYiwgeGRwLT5kYXRhIC0geGRwLT5kYXRhX2hhcmRfc3RhcnQp
Ow0KPiA+ICsJbWVtY3B5KF9fc2tiX3B1dChza2IsIGRhdGFzaXplKSwgeGRwLT5kYXRhLCBkYXRh
c2l6ZSk7DQo+ID4gKwlpZiAobWV0YXNpemUpDQo+ID4gKwkJc2tiX21ldGFkYXRhX3NldChza2Is
IG1ldGFzaXplKTsNCj4gDQo+IEJ1dCB5b3UgaGF2ZW4ndCBhY3R1YWxseSBjb3BpZWQgdGhlIG1h
dGFkYXRhIGludG8gdGhlIHNrYiwNCj4gdGhlIG1ldGFkYXRhIGlzIGJlZm9yZSB4ZHAtPmRhdGEs
IHJpZ2h0Pw0KDQpUb2RheSB0aGUgaWdjIGRyaXZlciBkb2VzbuKAmXQgYWRkIGFueSBtZXRhZGF0
YSAoZXhjZXB0IGZvciBodyB0aW1lDQpzdGFtcHMgZXhwbGFpbmVkIGxhdGVyKSAuIFNvIGZvciBt
b3N0IHBhcnQsIHhkcC0+ZGF0YSBhbmQgeGRwLQ0KPmRhdGFfbWV0YSBwb2ludCB0byB0aGUgc2Ft
ZSBhZGRyZXNzIC4gVGhhdCBjb3VsZCBiZSB3aHkgaW4gdGhpcw0KaW5pdGlhbCBpbXBsZW1lbnRh
dGlvbiB3ZSBhcmUgbm90IGNvcHlpbmcgIHRoZSBtZXRhZGF0YSBpbnRvIHNrYiAoYXMNCnRoZSBk
cml2ZXIgZG9lc27igJl0IGFkZCBhbnkpLiAgDQoNCklmIHRoZSBYRFAgcHJvZ3JhbSBhZGRzIHNv
bWUgbWV0YWRhdGEgYmVmb3JlIHhkcC0+ZGF0YSAoYW5kICB4ZHAtDQo+ZGF0YV9tZXRhIHJlZmxl
Y3RzIHRoaXMpLCB0aGF0IGlzIE5PVCBjb3BpZWQgaW50byB0aGUgU0tCIGFzIHlvdQ0KbWVudGlv
bmVkIC4gICBJcyB0aGUgZXhwZWN0YXRpb24gdGhhdCBtZXRhX2RhdGEgKGlmIGFueSBhZGRlZCBi
eSB0aGUNCmJwZiBwcm9ncmFtKSAsIHNob3VsZCBhbHNvIGJlIGNvcGllZCB0byB0aGUgc2tiICBp
biB0aGlzIFhEUF9QQVNTIGZsb3cNCj8gSWYgc28gSSBjYW4gcmV2aXNlIHRoaXMgcGF0Y2ggdG8g
ZG8gdGhhdC4gDQoNCklmIGgvdyB0aW1lLXN0YW1wIGlzIGFkZGVkIGJ5IHRoZSBOSUMsIHRoZW4g
bWV0YXNpemUgd2lsbCBiZSBub24gemVybw0KKGFzICB4ZHAtPmRhdGEgaXMgYWR2YW5jZWQgYnkg
dGhlIGRyaXZlciApIC4gIGgvdyB0cyAgaXMgc3RpbGwgY29waWVkDQppbnRvICJza2JfaHd0c3Rh
bXBzKHNrYiktPmh3dHN0YW1wIiBieSAgdGhlIGNhbGxlciBvZiB0aGlzIGZ1bmN0aW9uDQppZ2Nf
ZGlzcGF0Y2hfc2tiX3pjKCkgIC4gRG8geW91IHN0aWxsIHdhbnQgaXQgdG8gYmUgY29waWVkIGlu
dG8NCl9fc2tiX3B1dChza2IsICkgYXJlYSB0b28gPyANCg0KPiANCj4gPiArCXJldHVybiBza2I7
DQo+ID4gK30NCj4gPiArc3RhdGljIGludCBpZ2NfeGRwX2VuYWJsZV9wb29sKHN0cnVjdCBpZ2Nf
YWRhcHRlciAqYWRhcHRlciwNCj4gPiArCQkJICAgICAgIHN0cnVjdCB4c2tfYnVmZl9wb29sICpw
b29sLCB1MTYNCj4gPiBxdWV1ZV9pZCkNCj4gPiArew0KPiA+ICsJc3RydWN0IG5ldF9kZXZpY2Ug
Km5kZXYgPSBhZGFwdGVyLT5uZXRkZXY7DQo+ID4gKwlzdHJ1Y3QgZGV2aWNlICpkZXYgPSAmYWRh
cHRlci0+cGRldi0+ZGV2Ow0KPiA+ICsJc3RydWN0IGlnY19yaW5nICpyeF9yaW5nOw0KPiA+ICsJ
c3RydWN0IG5hcGlfc3RydWN0ICpuYXBpOw0KPiA+ICsJYm9vbCBuZWVkc19yZXNldDsNCj4gPiAr
CXUzMiBmcmFtZV9zaXplOw0KPiA+ICsJaW50IGVycjsNCj4gPiArDQo+ID4gKwlpZiAocXVldWVf
aWQgPj0gYWRhcHRlci0+bnVtX3J4X3F1ZXVlcykNCj4gPiArCQlyZXR1cm4gLUVJTlZBTDsNCj4g
PiArDQo+ID4gKwlmcmFtZV9zaXplID0geHNrX3Bvb2xfZ2V0X3J4X2ZyYW1lX3NpemUocG9vbCk7
DQo+ID4gKwlpZiAoZnJhbWVfc2l6ZSA8IEVUSF9GUkFNRV9MRU4gKyBWTEFOX0hMRU4gKiAyKSB7
DQo+ID4gKwkJLyogV2hlbiBYRFAgaXMgZW5hYmxlZCwgdGhlIGRyaXZlciBkb2Vzbid0IHN1cHBv
cnQNCj4gPiBmcmFtZXMgdGhhdA0KPiA+ICsJCSAqIHNwYW4gb3ZlciBtdWx0aXBsZSBidWZmZXJz
LiBUbyBhdm9pZCB0aGF0LCB3ZSBjaGVjaw0KPiA+IGlmIHhzaw0KPiA+ICsJCSAqIGZyYW1lIHNp
emUgaXMgYmlnIGVub3VnaCB0byBmaXQgdGhlIG1heCBldGhlcm5ldA0KPiA+IGZyYW1lIHNpemUN
Cj4gPiArCQkgKiArIHZsYW4gZG91YmxlIHRhZ2dpbmcuDQo+ID4gKwkJICovDQo+ID4gKwkJcmV0
dXJuIC1FT1BOT1RTVVBQOw0KPiA+ICsJfQ0KPiA+ICsNCj4gPiArCWVyciA9IHhza19wb29sX2Rt
YV9tYXAocG9vbCwgZGV2LCBJR0NfUlhfRE1BX0FUVFIpOw0KPiA+ICsJaWYgKGVycikgew0KPiA+
ICsJCW5ldGRldl9lcnIobmRldiwgIkZhaWxlZCB0byBtYXAgeHNrIHBvb2xcbiIpOw0KPiA+ICsJ
CXJldHVybiBlcnI7DQo+ID4gKwl9DQo+ID4gKw0KPiA+ICsJbmVlZHNfcmVzZXQgPSBuZXRpZl9y
dW5uaW5nKGFkYXB0ZXItPm5ldGRldikgJiYNCj4gPiBpZ2NfeGRwX2lzX2VuYWJsZWQoYWRhcHRl
cik7DQo+ID4gKw0KPiA+ICsJcnhfcmluZyA9IGFkYXB0ZXItPnJ4X3JpbmdbcXVldWVfaWRdOw0K
PiA+ICsJbmFwaSA9ICZyeF9yaW5nLT5xX3ZlY3Rvci0+bmFwaTsNCj4gPiArDQo+ID4gKwlpZiAo
bmVlZHNfcmVzZXQpIHsNCj4gPiArCQlpZ2NfZGlzYWJsZV9yeF9yaW5nKHJ4X3JpbmcpOw0KPiA+
ICsJCW5hcGlfZGlzYWJsZShuYXBpKTsNCj4gPiArCX0NCj4gPiArDQo+ID4gKwlzZXRfYml0KElH
Q19SSU5HX0ZMQUdfQUZfWERQX1pDLCAmcnhfcmluZy0+ZmxhZ3MpOw0KPiA+ICsNCj4gPiArCWlm
IChuZWVkc19yZXNldCkgew0KPiA+ICsJCW5hcGlfZW5hYmxlKG5hcGkpOw0KPiA+ICsJCWlnY19l
bmFibGVfcnhfcmluZyhyeF9yaW5nKTsNCj4gPiArDQo+ID4gKwkJZXJyID0gaWdjX3hza193YWtl
dXAobmRldiwgcXVldWVfaWQsIFhEUF9XQUtFVVBfUlgpOw0KPiA+ICsJCWlmIChlcnIpDQo+ID4g
KwkJCXJldHVybiBlcnI7DQo+IA0KPiBObyBuZWVkIGZvciBhbiB1bndpbmQgcGF0aCBoZXJlPw0K
PiBEb2VzIHNvbWV0aGluZyBjYWxsIFhEUF9TRVRVUF9YU0tfUE9PTChOVUxMKSBvbiBmYWlsdXJl
DQo+IGF1dG9tYWdpY2FsbHk/DQoNCkkgdGhpbmsgd2Ugc2hvdWxkIGFkZCBhIHhza19wb29sX2Rt
YV91bm1hcCgpIGluIHRoaXMgZmFpbHVyZSBwYXRoDQo/ICBEaWQgSSB1bmRlcnN0YW5kIHlvdSBj
b3JyZWN0bHkgPw0KDQo+IA0KPiA+ICsJfQ0KPiA+ICsNCj4gPiArCXJldHVybiAwOw0KPiA+ICt9
DQoNClRoYW5rcw0KSml0aHUNCg==
