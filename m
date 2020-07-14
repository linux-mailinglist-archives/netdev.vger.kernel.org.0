Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D46621FC40
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 21:08:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730919AbgGNTHz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 15:07:55 -0400
Received: from mga03.intel.com ([134.134.136.65]:12691 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730381AbgGNSvS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Jul 2020 14:51:18 -0400
IronPort-SDR: rfDM6+8uBZ4VStLleYKZEtIB/iyKTbiPZRBn4kHGL+BfJ9FdV5UOncMwEUlogmwLzCBrKz+ibo
 Ku9nBnlegiOA==
X-IronPort-AV: E=McAfee;i="6000,8403,9682"; a="149001808"
X-IronPort-AV: E=Sophos;i="5.75,352,1589266800"; 
   d="scan'208";a="149001808"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2020 11:51:17 -0700
IronPort-SDR: PAmW40IXNOFDI0SzrMJQyCoOkYduLwOheKRzBWM69Kmeyc7suuYYYlpUqI8QTN/Oq3nBsiGVeq
 Ny7wS0n8ccXg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,352,1589266800"; 
   d="scan'208";a="316469154"
Received: from fmsmsx106.amr.corp.intel.com ([10.18.124.204])
  by orsmga008.jf.intel.com with ESMTP; 14 Jul 2020 11:51:17 -0700
Received: from fmsmsx117.amr.corp.intel.com (10.18.116.17) by
 FMSMSX106.amr.corp.intel.com (10.18.124.204) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 14 Jul 2020 11:51:16 -0700
Received: from fmsmsx121.amr.corp.intel.com ([169.254.6.72]) by
 fmsmsx117.amr.corp.intel.com ([169.254.3.171]) with mapi id 14.03.0439.000;
 Tue, 14 Jul 2020 11:51:16 -0700
From:   "Westergreen, Dalon" <dalon.westergreen@intel.com>
To:     "kuba@kernel.org" <kuba@kernel.org>
CC:     "mkubecek@suse.cz" <mkubecek@suse.cz>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Tan, Ley Foon" <ley.foon.tan@intel.com>,
        "See, Chin Liang" <chin.liang.see@intel.com>,
        "Nguyen, Dinh" <dinh.nguyen@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Ooi, Joyce" <joyce.ooi@intel.com>,
        "thor.thayer@linux.intel.com" <thor.thayer@linux.intel.com>
Subject: Re: [PATCH v4 09/10] net: eth: altera: add msgdma prefetcher
Thread-Topic: [PATCH v4 09/10] net: eth: altera: add msgdma prefetcher
Thread-Index: AQHWWg/ATrKacZadXkOX5GJssHxx6Q==
Date:   Tue, 14 Jul 2020 18:51:15 +0000
Message-ID: <9a8ba2616f72fb44cdc3b45fabfb4d7bdf961fd0.camel@intel.com>
References: <20200708072401.169150-1-joyce.ooi@intel.com>
         <20200708072401.169150-10-joyce.ooi@intel.com>
         <20200708144900.058a8b25@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <CY4PR11MB12537DA07C73574B82A239BDF2610@CY4PR11MB1253.namprd11.prod.outlook.com>
         <20200714085526.2bb89dc6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <3bcb9020f0a3836f41036ddc3c8034b96e183197.camel@intel.com>
         <20200714092903.38581b74@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200714092903.38581b74@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.3 (3.36.3-1.fc32) 
x-originating-ip: [10.212.241.105]
Content-Type: text/plain; charset="utf-8"
Content-ID: <493006FABC10FF4796149D49B4DE8DE0@intel.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIFR1ZSwgMjAyMC0wNy0xNCBhdCAwOToyOSAtMDcwMCwgSmFrdWIgS2ljaW5za2kgd3Jv
dGU6DQo+IE9uIFR1ZSwgMTQgSnVsIDIwMjAgMTU6NTg6NTMgKzAwMDAgV2VzdGVyZ3JlZW4sIERh
bG9uIHdyb3RlOg0KPiA+IE9uIFR1ZSwgMjAyMC0wNy0xNCBhdCAwODo1NSAtMDcwMCwgSmFrdWIg
S2ljaW5za2kgd3JvdGU6DQo+ID4gPiBPbiBUdWUsIDE0IEp1bCAyMDIwIDE0OjM1OjE2ICswMDAw
IE9vaSwgSm95Y2Ugd3JvdGU6ICANCj4gPiA+ID4gPiBJJ20gbm8gZGV2aWNlIHRyZWUgZXhwZXJ0
IGJ1dCB0aGVzZSBsb29rIGxpa2UgY29uZmlnIG9wdGlvbnMgcmF0aGVyDQo+ID4gPiA+ID4gdGhh
bg0KPiA+ID4gPiA+IEhXDQo+ID4gPiA+ID4gZGVzY3JpcHRpb24uIFRoZXkgYWxzbyBkb24ndCBh
cHBlYXIgdG8gYmUgZG9jdW1lbnRlZCBpbiB0aGUgbmV4dA0KPiA+ID4gPiA+IHBhdGNoLiAgICAN
Cj4gPiA+ID4gDQo+ID4gPiA+IFRoZSBwb2xsX2ZyZXEgYXJlIHBhcnQgb2YgdGhlIG1zZ2RtYSBw
cmVmZXRjaGVyIElQLCB3aGVyZWJ5IGl0DQo+ID4gPiA+IHNwZWNpZmllcyB0aGUgZnJlcXVlbmN5
IG9mIGRlc2NyaXB0b3IgcG9sbGluZyBvcGVyYXRpb24uIEkgY2FuIGFkZA0KPiA+ID4gPiB0aGUg
cG9sbF9mcmVxIGRlc2NyaXB0aW9uIGluIHRoZSBuZXh0IHBhdGNoLiAgDQo+ID4gPiANCj4gPiA+
IElzIHRoZSB2YWx1ZSBkZWNpZGVkIGF0IHRoZSB0aW1lIG9mIHN5bnRoZXNpcyBvciBjYW4gdGhl
IGRyaXZlciBjaG9vc2UgDQo+ID4gPiB0aGUgdmFsdWUgaXQgd2FudHM/ICANCj4gPiANCj4gPiBJ
dCBpcyBub3QgY29udHJvbGxlZCBhdCBzeW50aGVzaXMsIHRoaXMgcGFyYW1ldGVyIHNob3VsZCBs
aWtlbHkgbm90IGJlIGENCj4gPiBkZXZpY2V0cmVlIHBhcmFtZXRlciwgcGVyaGFwcyBqdXN0IG1h
a2UgaXQgYSBtb2R1bGUgcGFyYW1ldGVyIHdpdGggYSBkZWZhdWx0DQo+ID4gdmFsdWUuDQo+IA0K
PiBMZXQncyBzZWUgaWYgSSB1bmRlcnN0YW5kIHRoZSBmZWF0dXJlIC0gaW5zdGVhZCBvZiB1c2lu
ZyBhIGRvb3JiZWxsIHRoZQ0KPiBIVyBwZXJpb2RpY2FsbHkgY2hlY2tzIHRoZSBjb250ZW50cyBv
ZiB0aGUgbmV4dC10by11c2UgZGVzY3JpcHRvciB0bw0KPiBzZWUgaWYgaXQgY29udGFpbnMgYSB2
YWxpZCB0eCBmcmFtZSBvciByeCBidWZmZXI/DQo+IA0KDQpZZXMsIGl0IGNoZWNrcyB0aGUgbmV4
dC10by11c2UgZGVzY3JpcHRvciB0byBzZWUgaWYgdGhlIGRlc2NyaXB0b3IgaXMgdmFsaWQuDQoN
CnRoZSB2YWx1ZSBzcGVjaWZpZXMgdGhlIG51bWJlciBvZiBjeWNsZXMgdG8gd2FpdCBiZWZvcmUg
Y2hlY2tpbmcgYWdhaW4NCg0KPiBJJ3ZlIHNlZW4gdmVuZG9ycyBhYnVzZSBmaWVsZHMgb2YgZXRo
dG9vbCAtLWNvYWxlc2NlIHRvIGNvbmZpZ3VyZQ0KPiBzaW1pbGFyIHNldHRpbmdzLiB0eC11c2Vj
cy1pcnEgYW5kIHJ4LXVzZWNzLWlycSwgSSB0aGluay4gU2luY2UgdGhpcw0KPiBwYXJ0IG9mIGV0
aHRvb2wgQVBJIGhhcyBiZWVuIHBvcnRlZCB0byBuZXRsaW5rLCBjb3VsZCB3ZSBwZXJoYXBzIGFk
ZCANCj4gYSBuZXcgZmllbGQgdG8gZXRodG9vbCAtLWNvYWxlc2NlPw0KDQpJIGRvbid0IHRoaW5r
IHRoaXMgaXMgbmVjZXNzYXJ5LCBpIHRoaW5rIGp1c3QgaGF2aW5nIGEgbW9kdWxlIHBhcmFtZXRl
cg0KbWVldHMgb3VyIG5lZWRzLiAgSSBkb24ndCBzZWUgYSBuZWVkIGZvciB0aGUgdmFsdWUgdG8g
Y2hhbmdlIG9uIGEgcGVyDQppbnRlcmZhY2UgYmFzaXMuICBUaGlzIHdhcyBwcmltYXJpbHkgdXNl
ZCBkdXJpbmcgdGVzdGluZyAvIGJyaW5ndXAuDQoNCi1kYWxvbg0K
