Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 520223053D5
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 08:02:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232590AbhA0HBE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 02:01:04 -0500
Received: from mga03.intel.com ([134.134.136.65]:42301 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S317519AbhA0BD5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Jan 2021 20:03:57 -0500
IronPort-SDR: nTi2NmcCzT0i8Os4C8ef91SY9wpym9pioO8aHemDTZiKcQz/gOQpGmR9qv/IPbQJewX6GGSN9N
 7CQ00Zcr+x3A==
X-IronPort-AV: E=McAfee;i="6000,8403,9876"; a="180077833"
X-IronPort-AV: E=Sophos;i="5.79,378,1602572400"; 
   d="scan'208";a="180077833"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2021 17:02:41 -0800
IronPort-SDR: I0s0ja+baUE0/ob0ycWCYOqJfejbeR1Tiw1JEYRMTuwcjdB7ZVYF1XGwc6wZlZn6A3qi55+5kQ
 iXb1XIexbNsg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,378,1602572400"; 
   d="scan'208";a="356895306"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by orsmga006.jf.intel.com with ESMTP; 26 Jan 2021 17:02:41 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Tue, 26 Jan 2021 17:02:40 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 26 Jan 2021 17:02:39 -0800
Received: from fmsmsx612.amr.corp.intel.com ([10.18.126.92]) by
 fmsmsx612.amr.corp.intel.com ([10.18.126.92]) with mapi id 15.01.1713.004;
 Tue, 26 Jan 2021 17:02:39 -0800
From:   "Saleem, Shiraz" <shiraz.saleem@intel.com>
To:     "Keller, Jacob E" <jacob.e.keller@intel.com>,
        Leon Romanovsky <leon@kernel.org>
CC:     Jason Gunthorpe <jgg@nvidia.com>,
        "dledford@redhat.com" <dledford@redhat.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Ertman, David M" <david.m.ertman@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "Ismail, Mustafa" <mustafa.ismail@intel.com>,
        "jiri@nvidia.com" <jiri@nvidia.com>,
        "Samudrala, Sridhar" <sridhar.samudrala@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: RE: [PATCH 07/22] RDMA/irdma: Register an auxiliary driver and
 implement private channel OPs
Thread-Topic: [PATCH 07/22] RDMA/irdma: Register an auxiliary driver and
 implement private channel OPs
Thread-Index: AQHW8RlTrNE3qjtLukSnj7NcX24DDao3Ul6AgAGNgQD//8rX0IAA9s8AgABKwgCAARb1AP//qNEw
Date:   Wed, 27 Jan 2021 01:02:39 +0000
Message-ID: <2fffd43a6c0b4d949628f2c0478505f9@intel.com>
References: <20210122234827.1353-1-shiraz.saleem@intel.com>
 <20210122234827.1353-8-shiraz.saleem@intel.com>
 <20210124134551.GB5038@unreal> <20210125132834.GK4147@nvidia.com>
 <2072c76154cd4232b78392c650b2b2bf@intel.com>
 <5b3f609d-034a-826f-1e50-0a5f8ad8406e@intel.com>
 <20210126052914.GN579511@unreal>
 <236bd48f-ad16-1502-3194-b3e48ca2de97@intel.com>
In-Reply-To: <236bd48f-ad16-1502-3194-b3e48ca2de97@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.5.1.3
x-originating-ip: [10.22.254.132]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiBTdWJqZWN0OiBSZTogW1BBVENIIDA3LzIyXSBSRE1BL2lyZG1hOiBSZWdpc3RlciBhbiBhdXhp
bGlhcnkgZHJpdmVyIGFuZA0KPiBpbXBsZW1lbnQgcHJpdmF0ZSBjaGFubmVsIE9Qcw0KPiANCj4g
DQo+IA0KPiBPbiAxLzI1LzIwMjEgOToyOSBQTSwgTGVvbiBSb21hbm92c2t5IHdyb3RlOg0KPiA+
IE9uIE1vbiwgSmFuIDI1LCAyMDIxIGF0IDA1OjAxOjQwUE0gLTA4MDAsIEphY29iIEtlbGxlciB3
cm90ZToNCj4gPj4NCj4gPj4NCj4gPj4gT24gMS8yNS8yMDIxIDQ6MzkgUE0sIFNhbGVlbSwgU2hp
cmF6IHdyb3RlOg0KPiA+Pj4+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggMDcvMjJdIFJETUEvaXJkbWE6
IFJlZ2lzdGVyIGFuIGF1eGlsaWFyeSBkcml2ZXINCj4gPj4+PiBhbmQgaW1wbGVtZW50IHByaXZh
dGUgY2hhbm5lbCBPUHMNCj4gPj4+Pg0KPiA+Pj4+IE9uIFN1biwgSmFuIDI0LCAyMDIxIGF0IDAz
OjQ1OjUxUE0gKzAyMDAsIExlb24gUm9tYW5vdnNreSB3cm90ZToNCj4gPj4+Pj4gT24gRnJpLCBK
YW4gMjIsIDIwMjEgYXQgMDU6NDg6MTJQTSAtMDYwMCwgU2hpcmF6IFNhbGVlbSB3cm90ZToNCj4g
Pj4+Pj4+IEZyb206IE11c3RhZmEgSXNtYWlsIDxtdXN0YWZhLmlzbWFpbEBpbnRlbC5jb20+DQo+
ID4+Pj4+Pg0KPiA+Pj4+Pj4gUmVnaXN0ZXIgaXJkbWEgYXMgYW4gYXV4aWxpYXJ5IGRyaXZlciB3
aGljaCBjYW4gYXR0YWNoIHRvDQo+ID4+Pj4+PiBhdXhpbGlhcnkgUkRNQSBkZXZpY2VzIGZyb20g
SW50ZWwgUENJIG5ldGRldiBkcml2ZXJzIGk0MGUgYW5kDQo+ID4+Pj4+PiBpY2UuIEltcGxlbWVu
dCB0aGUgcHJpdmF0ZSBjaGFubmVsIG9wcywgYWRkIGJhc2ljIGRldmxpbmsgc3VwcG9ydA0KPiA+
Pj4+Pj4gaW4gdGhlIGRyaXZlciBhbmQgcmVnaXN0ZXIgbmV0IG5vdGlmaWVycy4NCj4gPj4+Pj4N
Cj4gPj4+Pj4gRGV2bGluayBwYXJ0IGluICJ0aGUgUkRNQSBjbGllbnQiIGlzIGludGVyZXN0aW5n
IHRoaW5nLg0KPiA+Pj4+Pg0KPiA+Pj4+PiBUaGUgaWRlYSBiZWhpbmQgYXV4aWxpYXJ5IGJ1cyB3
YXMgdGhhdCBQQ0kgbG9naWMgd2lsbCBzdGF5IGF0IG9uZQ0KPiA+Pj4+PiBwbGFjZSBhbmQgZGV2
bGluayBjb25zaWRlcmVkIGFzIHRoZSB0b29sIHRvIG1hbmFnZSB0aGF0Lg0KPiA+Pj4+DQo+ID4+
Pj4gWWVzLCB0aGlzIGRvZXNuJ3Qgc2VlbSByaWdodCwgSSBkb24ndCB0aGluayB0aGVzZSBhdXhp
bGlhcnkgYnVzDQo+ID4+Pj4gb2JqZWN0cyBzaG91bGQgaGF2ZSBkZXZsaW5rIGluc3RhbmNlcywg
b3IgYXQgbGVhc3Qgc29tZW9uZSBmcm9tDQo+ID4+Pj4gZGV2bGluayBsYW5kIHNob3VsZCBhcHBy
b3ZlIG9mIHRoZSBpZGVhLg0KPiA+Pj4+DQo+ID4+Pg0KPiA+Pj4gSW4gb3VyIG1vZGVsLCB3ZSBo
YXZlIG9uZSBhdXhkZXYgKGZvciBSRE1BKSBwZXIgUENJIGRldmljZSBmdW5jdGlvbg0KPiA+Pj4g
b3duZWQgYnkgbmV0ZGV2IGRyaXZlciBhbmQgb25lIGRldmxpbmsgaW5zdGFuY2UgcGVyIGF1eGRl
di4gUGx1cyB0aGVyZSBpcyBhbg0KPiBJbnRlbCBuZXRkZXYgZHJpdmVyIGZvciBlYWNoIEhXIGdl
bmVyYXRpb24uDQo+ID4+PiBNb3ZpbmcgdGhlIGRldmxpbmsgbG9naWMgdG8gdGhlIFBDSSBuZXRk
ZXYgZHJpdmVyIHdvdWxkIG1lYW4NCj4gPj4+IGR1cGxpY2F0aW5nIHRoZSBzYW1lIHNldCBvZiBS
RE1BIHBhcmFtcyBpbiBlYWNoIEludGVsIG5ldGRldiBkcml2ZXIuDQo+ID4+PiBBZGRpdGlvbmFs
bHksIHBsdW1iaW5nIFJETUEgc3BlY2lmaWMgcGFyYW1zIGluIHRoZSBuZXRkZXYgZHJpdmVyIHNv
cnQgb2YNCj4gc2VlbXMgbWlzcGxhY2VkIHRvIG1lLg0KPiA+Pj4NCj4gPj4NCj4gPj4gSSBhZ3Jl
ZSB0aGF0IHBsdW1iaW5nIHRoZXNlIHBhcmFtZXRlcnMgYXQgdGhlIFBDSSBzaWRlIGluIHRoZSBk
ZXZsaW5rDQo+ID4+IG9mIHRoZSBwYXJlbnQgZGV2aWNlIGlzIHdlaXJkLiBUaGV5IGRvbid0IHNl
ZW0gdG8gYmUgcGFyYW1ldGVycyB0aGF0DQo+ID4+IHRoZSBwYXJlbnQgZHJpdmVyIGNhcmVzIGFi
b3V0Lg0KPiA+Pg0KPiA+PiBNYXliZSB0aGVyZSBpcyBhbm90aGVyIG1lY2hhbmlzbSB0aGF0IG1h
a2VzIG1vcmUgc2Vuc2U/IFRvIG1lIGl0IGlzIGENCj4gPj4gYml0IGxpa2UgaWYgd2Ugd2VyZSBw
bHVtYmluZyBuZXRkZXYgc3BlY2lmaWMgcGFyYW10ZXJzIGludG8gZGV2bGluaw0KPiA+PiBpbnN0
ZWFkIG9mIHRyeWluZyB0byBleHBvc2UgdGhlbSB0aHJvdWdoIG5ldGRldmljZSBzcGVjaWZpYw0K
PiA+PiBpbnRlcmZhY2VzIGxpa2UgaXByb3V0ZTIgb3IgZXRodG9vbC4NCj4gPg0KPiA+IEknbSBm
YXIgZnJvbSBiZWluZyBleHBlcnQgaW4gZGV2bGluaywgYnV0IGZvciBtZSBzZXBhcmF0aW9uIGlz
IGZvbGxvd2luZzoNCj4gPiAxLiBkZXZsaW5rIC0gb3BlcmF0ZXMgb24gcGh5c2ljYWwgZGV2aWNl
IGxldmVsLCB3aGVuIFBDSSBkZXZpY2UgYWxyZWFkeQ0KPiBpbml0aWFsaXplZC4NCj4gPiAyLiBl
dGh0b29sIC0gY2hhbmdlcyBuZWVkZWQgdG8gYmUgZG9uZSBvbiBuZXRkZXYgbGF5ZXIuDQo+ID4g
My4gaXAgLSB1cHBlciBsYXllciBvZiB0aGUgbmV0ZGV2DQo+ID4gNC4gcmRtYXRvb2wgLSBSRE1B
IHNwZWNpZmljIHdoZW4gSUIgZGV2aWNlIGFscmVhZHkgZXhpc3RzLg0KPiA+DQo+ID4gQW5kIHRo
ZSBFTkFCTEVfUk9DRS9FTkFCTEVfUkRNQSB0aGluZyBzaG91bGRuJ3QgYmUgaW4gdGhlIFJETUEg
ZHJpdmVyDQo+ID4gYXQgYWxsLCBiZWNhdXNlIGl0IGlzIHBoeXNpY2FsIGRldmljZSBwcm9wZXJ0
eSB3aGljaCBvbmNlIHRvZ2dsZWQgd2lsbA0KPiA+IHByb2hpYml0IGNyZWF0aW9uIG9mIHJlc3Bl
Y3RpdmUgYXV4IGRldmljZS4NCj4gPg0KPiANCj4gT2suIEkgZ3Vlc3MgSSBoYWRuJ3QgbG9va2Vk
IHF1aXRlIGFzIGNsb3NlIGF0IHRoZSBzcGVjaWZpY3MgaGVyZS4gSSBhZ3JlZSB0aGF0DQo+IEVO
QUJMRV9SRE1BIHNob3VsZCBnbyBpbiB0aGUgUEYgZGV2bGluay4NCj4gDQo+IElmIHRoZXJlJ3Mg
YW55IG90aGVyIHNvcnQgb2YgUkRNQS1zcGVjaWZpYyBjb25maWd1cmF0aW9uIHRoYXQgdGllcyB0
byB0aGUgSUIgZGV2aWNlLA0KPiB0aGF0IHNob3VsZCBnbyBzb21laG93IGludG8gcmRtYXRvb2ws
IHJhdGhlciB0aGFuIGRldmxpbmsuIEFuZCB0aHVzOiBJIHRoaW5rIEkNCj4gYWdyZWUsIHdlIGRv
bid0IHdhbnQgdGhlIElCIGRldmljZSBvciB0aGUgYXV4IGRldmljZSB0byBjcmVhdGUgYSBkZXZs
aW5rIGluc3RhbmNlLg0KPiANCg0KSSB0aGluayByZG1hLXRvb2wgbWlnaHQgYmUgdG9vIGxhdGUg
Zm9yIHRoaXMgdHlwZSBvZiBwYXJhbS4gV2UgbmVlZCB0aGUgcHJvdG9jb2wgaW5mbyAoaVdBUlAg
dnMgUm9DRSkNCmVhcmx5IG9uIGRyaXZlciBwcm9iZS4NCg==
