Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F3D9210196
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 03:37:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726171AbgGABhk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 21:37:40 -0400
Received: from mga03.intel.com ([134.134.136.65]:16759 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725763AbgGABhk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Jun 2020 21:37:40 -0400
IronPort-SDR: sPe5BzAq1rJ5hMC7z/1QmZwZgCIbqZUhkUiCtF2+1dRO6D4JT5XP0CZjlezPQAP9417AlPXmVZ
 iR3TGT6ABSbA==
X-IronPort-AV: E=McAfee;i="6000,8403,9668"; a="146421455"
X-IronPort-AV: E=Sophos;i="5.75,298,1589266800"; 
   d="scan'208";a="146421455"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2020 18:37:39 -0700
IronPort-SDR: FOJdSSvScAe75If4MbAG6v6N7rHXGbSuz6DnceNDVl62rpQjZfMjteVk5kpb/KhnRSZzSVdD8G
 fHpFOeUPX5fg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,298,1589266800"; 
   d="scan'208";a="454819319"
Received: from orsmsx109.amr.corp.intel.com ([10.22.240.7])
  by orsmga005.jf.intel.com with ESMTP; 30 Jun 2020 18:37:39 -0700
Received: from orsmsx112.amr.corp.intel.com ([169.254.3.199]) by
 ORSMSX109.amr.corp.intel.com ([169.254.11.7]) with mapi id 14.03.0439.000;
 Tue, 30 Jun 2020 18:37:39 -0700
From:   "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>
To:     Francesco Ruggeri <fruggeri@arista.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>
CC:     open list <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
Subject: RE: [PATCH] igb: reinit_locked() should be called with rtnl_lock
Thread-Topic: [PATCH] igb: reinit_locked() should be called with rtnl_lock
Thread-Index: AQHWTlrL81g79hVuZ0aaoDgUuhrbt6jwv/UAgABMxoCAAOZwIA==
Date:   Wed, 1 Jul 2020 01:37:39 +0000
Message-ID: <61CC2BC414934749BD9F5BF3D5D940449874358A@ORSMSX112.amr.corp.intel.com>
References: <20200629211801.C3D7095C0900@us180.sjc.aristanetworks.com>
 <20200629171612.49efbdaa@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CA+HUmGjHQPUh1frfy5E28Om9WTVr0W+UQVDsm99beC_mbTeMog@mail.gmail.com>
In-Reply-To: <CA+HUmGjHQPUh1frfy5E28Om9WTVr0W+UQVDsm99beC_mbTeMog@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [10.22.254.139]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBGcmFuY2VzY28gUnVnZ2VyaSA8
ZnJ1Z2dlcmlAYXJpc3RhLmNvbT4NCj4gU2VudDogTW9uZGF5LCBKdW5lIDI5LCAyMDIwIDIxOjUx
DQo+IFRvOiBKYWt1YiBLaWNpbnNraSA8a3ViYUBrZXJuZWwub3JnPg0KPiBDYzogb3BlbiBsaXN0
IDxsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnPjsgbmV0ZGV2DQo+IDxuZXRkZXZAdmdlci5r
ZXJuZWwub3JnPjsgaW50ZWwtd2lyZWQtbGFuQGxpc3RzLm9zdW9zbC5vcmc7IERhdmlkIE1pbGxl
cg0KPiA8ZGF2ZW1AZGF2ZW1sb2Z0Lm5ldD47IEtpcnNoZXIsIEplZmZyZXkgVCA8amVmZnJleS50
LmtpcnNoZXJAaW50ZWwuY29tPg0KPiBTdWJqZWN0OiBSZTogW1BBVENIXSBpZ2I6IHJlaW5pdF9s
b2NrZWQoKSBzaG91bGQgYmUgY2FsbGVkIHdpdGggcnRubF9sb2NrDQo+IA0KPiA+IFdvdWxkIHlv
dSBtaW5kIGFkZGluZyBhIGZpeGVzIHRhZyBoZXJlPyBQcm9iYWJseToNCj4gPg0KPiA+IEZpeGVz
OiA5ZDVjODI0Mzk5ZGUgKCJpZ2I6IFBDSS1FeHByZXNzIDgyNTc1IEdpZ2FiaXQgRXRoZXJuZXQg
ZHJpdmVyIikNCj4gDQo+IFRoYXQgc2VlbXMgdG8gYmUgdGhlIGNvbW1pdCB0aGF0IGludHJvZHVj
ZWQgdGhlIGRyaXZlciBpbiAyLjYuMjUuDQo+IEkgYW0gbm90IGZhbWlsaWFyIHdpdGggdGhlIGhp
c3Rvcnkgb2YgdGhlIGRyaXZlciB0byB0ZWxsIGlmIHRoaXMgd2FzIGEgZGF5IDENCj4gcHJvYmxl
bSBvciBpZiBpdCBiZWNhbWUgYW4gaXNzdWUgbGF0ZXIuDQo+IA0KPiA+DQo+ID4gQW5kIGFzIGEg
bWF0dGVyIG9mIGZhY3QgaXQgbG9va3MgbGlrZSBlMTAwMGUgYW5kIGUxMDAwIGhhdmUgdGhlIHNh
bWUNCj4gPiBidWcgOi8gV291bGQgeW91IG1pbmQgY2hlY2tpbmcgYWxsIEludGVsIGRyaXZlciBw
cm9kdWNpbmcgbWF0Y2hlcyBmb3INCj4gPiBhbGwgdGhlIGFmZmVjdGVkIG9uZXM/DQo+IA0KPiBE
byB5b3UgbWVhbiBpZGVudGlmeSBhbGwgSW50ZWwgZHJpdmVycyB0aGF0IG1heSBoYXZlIHRoZSBz
YW1lIGlzc3VlPw0KPiANCg0KRG8gbm90IHdvcnJ5IGFib3V0IHRoZSBvdGhlciBJbnRlbCBkcml2
ZXJzLCBJIGhhdmUgb3VyIGRldmVsb3BlcnMgbG9va2luZyBhdCBlYWNoIG9mIG91ciBkcml2ZXJz
IGZvciB0aGUgbG9ja2luZyBpc3N1ZS4NCg0KQERhdmlkIE1pbGxlciAtIEkgYW0gcGlja2luZyB1
cCB0aGlzIHBhdGNoDQo=
