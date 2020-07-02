Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15D66212D98
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 22:05:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726140AbgGBUFd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 16:05:33 -0400
Received: from mga11.intel.com ([192.55.52.93]:18071 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725915AbgGBUFc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Jul 2020 16:05:32 -0400
IronPort-SDR: 9ft6KvDZ9dwfN7yLSj+PNN7F503I/9OxQ7B3w4m9A9tkpx5B6a6LmelR2C095sUpZtSMIHl7Cj
 nunWeObn/fMQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9670"; a="145162150"
X-IronPort-AV: E=Sophos;i="5.75,305,1589266800"; 
   d="scan'208";a="145162150"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2020 13:05:32 -0700
IronPort-SDR: Q/gMPJiB6RjmXVuXgFEPbhUuLmyUUtjMCNwUQ7XfBya73W9GOueOE2SPvpa4bXF+cDwKsCTH60
 7srsWZ0HJW3Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,305,1589266800"; 
   d="scan'208";a="455640157"
Received: from orsmsx109.amr.corp.intel.com ([10.22.240.7])
  by orsmga005.jf.intel.com with ESMTP; 02 Jul 2020 13:05:32 -0700
Received: from orsmsx112.amr.corp.intel.com ([169.254.3.199]) by
 ORSMSX109.amr.corp.intel.com ([169.254.11.7]) with mapi id 14.03.0439.000;
 Thu, 2 Jul 2020 13:05:32 -0700
From:   "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>
To:     Francesco Ruggeri <fruggeri@arista.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
CC:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        "open list" <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
Subject: RE: [PATCH] igb: reinit_locked() should be called with rtnl_lock
Thread-Topic: [PATCH] igb: reinit_locked() should be called with rtnl_lock
Thread-Index: AQHWTlrL81g79hVuZ0aaoDgUuhrbt6jwv/UAgABMxoCAAOZwIIADNT2A//+SuOA=
Date:   Thu, 2 Jul 2020 20:05:31 +0000
Message-ID: <61CC2BC414934749BD9F5BF3D5D9404498748B57@ORSMSX112.amr.corp.intel.com>
References: <20200629211801.C3D7095C0900@us180.sjc.aristanetworks.com>
 <20200629171612.49efbdaa@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CA+HUmGjHQPUh1frfy5E28Om9WTVr0W+UQVDsm99beC_mbTeMog@mail.gmail.com>
 <61CC2BC414934749BD9F5BF3D5D940449874358A@ORSMSX112.amr.corp.intel.com>
 <CA+HUmGhfxYY5QiwF8_UYbp0TY-k3u+cTYZDSqV1s=SUFnGCn8g@mail.gmail.com>
In-Reply-To: <CA+HUmGhfxYY5QiwF8_UYbp0TY-k3u+cTYZDSqV1s=SUFnGCn8g@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [10.22.254.138]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBGcmFuY2VzY28gUnVnZ2VyaSA8
ZnJ1Z2dlcmlAYXJpc3RhLmNvbT4NCj4gU2VudDogVGh1cnNkYXksIEp1bHkgMiwgMjAyMCAxMjoz
NQ0KPiBUbzogS2lyc2hlciwgSmVmZnJleSBUIDxqZWZmcmV5LnQua2lyc2hlckBpbnRlbC5jb20+
DQo+IENjOiBKYWt1YiBLaWNpbnNraSA8a3ViYUBrZXJuZWwub3JnPjsgRGF2aWQgTWlsbGVyIDxk
YXZlbUBkYXZlbWxvZnQubmV0PjsNCj4gb3BlbiBsaXN0IDxsaW51eC1rZXJuZWxAdmdlci5rZXJu
ZWwub3JnPjsgbmV0ZGV2IDxuZXRkZXZAdmdlci5rZXJuZWwub3JnPjsNCj4gaW50ZWwtd2lyZWQt
bGFuQGxpc3RzLm9zdW9zbC5vcmcNCj4gU3ViamVjdDogUmU6IFtQQVRDSF0gaWdiOiByZWluaXRf
bG9ja2VkKCkgc2hvdWxkIGJlIGNhbGxlZCB3aXRoIHJ0bmxfbG9jaw0KPiANCj4gPiBEbyBub3Qg
d29ycnkgYWJvdXQgdGhlIG90aGVyIEludGVsIGRyaXZlcnMsIEkgaGF2ZSBvdXIgZGV2ZWxvcGVy
cyBsb29raW5nIGF0DQo+IGVhY2ggb2Ygb3VyIGRyaXZlcnMgZm9yIHRoZSBsb2NraW5nIGlzc3Vl
Lg0KPiA+DQo+ID4gQERhdmlkIE1pbGxlciAtIEkgYW0gcGlja2luZyB1cCB0aGlzIHBhdGNoDQo+
IA0KPiBUaGVyZSBzZWVtcyB0byBiZSBhIHNlY29uZCByYWNlLCBpbmRlcGVuZGVudCBmcm9tIHRo
ZSBvcmlnaW5hbCBvbmUsIHRoYXQNCj4gcmVzdWx0cyBpbiBhIGRpdmlkZSBlcnJvcjoNCj4gDQo+
IGt3b3JrZXIgICAgICAgICByZWJvb3QgLWYgICAgICAgdHggcGFja2V0DQo+IA0KPiBpZ2JfcmVz
ZXRfdGFzaw0KPiAgICAgICAgICAgICAgICAgX19pZ2Jfc2h1dGRvd24NCj4gICAgICAgICAgICAg
ICAgIHJ0bmxfbG9jaygpDQo+ICAgICAgICAgICAgICAgICAuLi4NCj4gICAgICAgICAgICAgICAg
IGlnYl9jbGVhcl9pbnRlcnJ1cHRfc2NoZW1lDQo+ICAgICAgICAgICAgICAgICBpZ2JfZnJlZV9x
X3ZlY3RvcnMNCj4gICAgICAgICAgICAgICAgIGFkYXB0ZXItPm51bV90eF9xdWV1ZXMgPSAwDQo+
ICAgICAgICAgICAgICAgICAuLi4NCj4gICAgICAgICAgICAgICAgIHJ0bmxfdW5sb2NrKCkNCj4g
cnRubF9sb2NrKCkNCj4gaWdiX3JlaW5pdF9sb2NrZWQNCj4gaWdiX2Rvd24NCj4gaWdiX3VwDQo+
IG5ldGlmX3R4X3N0YXJ0X2FsbF9xdWV1ZXMNCj4gICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICBkZXZfaGFyZF9zdGFydF94bWl0DQo+ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgaWdiX3htaXRfZnJhbWUNCj4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBpZ2Jf
dHhfcXVldWVfbWFwcGluZw0KPiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIFBhbmlj
cyBvbg0KPiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHJfaWR4ICUgYWRhcHRlci0+
bnVtX3R4X3F1ZXVlcw0KPiANCj4gVXNpbmcgaW4gaWdiX3Jlc2V0X3Rhc2sgYSBsb2dpYyBzaW1p
bGFyIHRvIHRoZSBvbmUgaW4gaXhnYmVfcmVzZXRfc3VidGFzayAoYmFpbGluZw0KPiBpZiBfX0lH
Ql9ET1dOIG9yIF9fSUdCX1JFU0VUVElORyBpcyBzZXQpIHNlZW1zIHRvIGF2b2lkIHRoZSBwYW5p
Yy4NCj4gVGhhdCBsb2dpYyB3YXMgZmlyc3QgaW50cm9kdWNlZCBpbiBpeGdiZSBhcyBwYXJ0IG9m
IGNvbW1pdCAyZjkwYjg2NTdlYyAoJ2l4Z2JlOg0KPiB0aGlzIHBhdGNoIGFkZHMgc3VwcG9ydCBm
b3IgRENCIHRvIHRoZSBrZXJuZWwgYW5kIGl4Z2JlIGRyaXZlcicpLg0KPiBCb3RoIGZpeGVzIHNl
ZW0gdG8gYmUgbmVlZGVkLg0KDQpTbyB3aWxsIHlvdSBiZSBzZW5kaW5nIGEgdjIgb2YgeW91ciBw
YXRjaCB0byBpbmNsdWRlIHRoZSBzZWNvbmQgZml4Pw0K
