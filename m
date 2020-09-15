Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 348FB26AA1C
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 18:54:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727794AbgIOQyS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 12:54:18 -0400
Received: from mga18.intel.com ([134.134.136.126]:22183 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727222AbgIOQvG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Sep 2020 12:51:06 -0400
IronPort-SDR: fQxcGOz42c58e5m4ruxanHqoH9yPUxqpxS8xR9gFa/6aqeVWj5ggkcThgtU4//UZS515y6hDcW
 DJw70NGD19yQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9745"; a="147054852"
X-IronPort-AV: E=Sophos;i="5.76,430,1592895600"; 
   d="scan'208";a="147054852"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2020 09:50:49 -0700
IronPort-SDR: JVPlP3S/zQrzDSBNziXg48bPpPWB/g8VWY2Yu6JnW1YME3J/XJnXno4gW4efHN9WuX4CnCZCZ1
 gUOx4m1Fd0Ew==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,430,1592895600"; 
   d="scan'208";a="507647644"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by fmsmga005.fm.intel.com with ESMTP; 15 Sep 2020 09:50:49 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 15 Sep 2020 09:50:49 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 15 Sep 2020 09:50:48 -0700
Received: from orsmsx610.amr.corp.intel.com ([10.22.229.23]) by
 ORSMSX610.amr.corp.intel.com ([10.22.229.23]) with mapi id 15.01.1713.004;
 Tue, 15 Sep 2020 09:50:48 -0700
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        Shannon Nelson <snelson@pensando.io>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: RE: [PATCH v3 net-next 2/2] ionic: add devlink firmware update
Thread-Topic: [PATCH v3 net-next 2/2] ionic: add devlink firmware update
Thread-Index: AQHWhjIy1XtTgA09OkC4iFBec0oM7alf38CAgAEUNQCAAAX0AIAAFKSAgAAXiYCAAGgMgIABEk6AgAY9zQCAAGpXgIAAAx2A//+c/ZCAAHtcAIAA9NyA//+ZbQA=
Date:   Tue, 15 Sep 2020 16:50:48 +0000
Message-ID: <4b5e3547f3854fd399b26a663405b1f8@intel.com>
References: <20200908224812.63434-1-snelson@pensando.io>
        <20200908224812.63434-3-snelson@pensando.io>
        <20200908165433.08afb9ba@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <9938e3cc-b955-11a1-d667-8e5893bb6367@pensando.io>
        <20200909094426.68c417fe@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <581f2161-1c55-31ae-370b-bbea5a677862@pensando.io>
        <20200909122233.45e4c65c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <3d75c4be-ae5d-43b0-407c-5df1e7645447@pensando.io>
        <20200910105643.2e2d07f8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <a04313f7-649e-a928-767c-b9d27f3a0c7c@intel.com>
        <20200914163605.750b0f23@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <3b18d92f-3a0a-c0b0-1b46-ecfd4408038c@pensando.io>
        <7e44037cedb946d4a72055dd0898ab1d@intel.com>
        <f4e4e9c3-b293-cef1-bb84-db7fe691882a@pensando.io>
 <20200915085045.446b854b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200915085045.446b854b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.5.1.3
x-originating-ip: [10.1.200.100]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogSmFrdWIgS2ljaW5za2kg
PGt1YmFAa2VybmVsLm9yZz4NCj4gU2VudDogVHVlc2RheSwgU2VwdGVtYmVyIDE1LCAyMDIwIDg6
NTEgQU0NCj4gVG86IFNoYW5ub24gTmVsc29uIDxzbmVsc29uQHBlbnNhbmRvLmlvPg0KPiBDYzog
S2VsbGVyLCBKYWNvYiBFIDxqYWNvYi5lLmtlbGxlckBpbnRlbC5jb20+OyBuZXRkZXZAdmdlci5r
ZXJuZWwub3JnOw0KPiBkYXZlbUBkYXZlbWxvZnQubmV0DQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0gg
djMgbmV0LW5leHQgMi8yXSBpb25pYzogYWRkIGRldmxpbmsgZmlybXdhcmUgdXBkYXRlDQo+IA0K
PiBPbiBNb24sIDE0IFNlcCAyMDIwIDE4OjE0OjIyIC0wNzAwIFNoYW5ub24gTmVsc29uIHdyb3Rl
Og0KPiA+IFNvIG5vdyB3ZSdyZSBiZWdpbm5pbmcgdG8gZGFuY2UgYXJvdW5kIHRpbWVvdXQgYm91
bmRhcmllcyAtIGhvdyBjYW4gd2UNCj4gPiBkZWZpbmUgdGhlIGJlZ2lubmluZyBhbmQgZW5kIG9m
IGEgdGltZW91dCBib3VuZGFyeSwgYW5kIGhvdyBkbyB0aGV5DQo+ID4gcmVsYXRlIHRvIHRoZSBj
b21wb25lbnQgYW5kIGxhYmVsP8KgIEN1cnJlbnRseSwgaWYgZWl0aGVyIHRoZSBjb21wb25lbnQN
Cj4gPiBvciBzdGF0dXNfbXNnIGNoYW5nZXMsIHRoZSBkZXZsaW5rIHVzZXIgcHJvZ3JhbSBkb2Vz
IGEgbmV3bGluZSB0byBzdGFydA0KPiA+IGEgbmV3IHN0YXR1cyBsaW5lLsKgIFRoZSBkb25lIGFu
ZCB0b3RhbCB2YWx1ZXMgYXJlIHVzZWQgZnJvbSBlYWNoIG5vdGlmeQ0KPiA+IG1lc3NhZ2UgdG8g
Y3JlYXRlIGEgJSB2YWx1ZSBkaXNwbGF5ZWQsIGJ1dCBhcmUgbm90IGRlcGVuZGVudCBvbiBhbnkN
Cj4gPiBwcmV2aW91cyBkb25lIG9yIHRvdGFsIHZhbHVlcywgc28gdGhlIHRvdGFsIGRvZXNuJ3Qg
bmVlZCB0byBiZSB0aGUgc2FtZQ0KPiA+IHZhbHVlIGZyb20gc3RhdHVzIG1lc3NhZ2UgdG8gc3Rh
dHVzIG1lc3NhZ2UsIGV2ZW4gaWYgdGhlIGNvbXBvbmVudCBhbmQNCj4gPiBsYWJlbCByZW1haW4g
dGhlIHNhbWUsIGRldmxpbmsgd2lsbCBqdXN0IHByaW50IHdoYXRldmVyICUgZ2V0cw0KPiA+IGNh
bGN1bGF0ZWQgdGhhdCB0aW1lLg0KPiANCj4gSSB0aGluayBzeXN0ZW1kIHJlbW92ZXMgdGhlIHRp
bWVvdXQgbWFya2luZyB3aGVuIGl0IG1vdmVzIG9uIHRvIHRoZQ0KPiBuZXh0IGpvYiwgYW5kIHNv
IHNob3VsZCBkZXZsaW5rIHdoZW4gaXQgbW92ZXMgb24gdG8gdGhlIG5leHQNCj4gY29tcG9uZW50
L3N0YXR1c19tc2cuDQo+IA0KPiA+IEknbSB0aGlua2luZyB0aGF0IHRoZSBiZWhhdmlvciBvZiB0
aGUgdGltZW91dCB2YWx1ZSBzaG91bGQgcmVtYWluDQo+ID4gc2VwYXJhdGUgZnJvbSB0aGUgY29t
cG9uZW50IGFuZCBzdGF0dXNfbXNnIHZhbHVlcywgc3VjaCB0aGF0IG9uY2UgZ2l2ZW4sDQo+ID4g
dGhlbiB0aGUgdXNlcmxhbmQgY291bnRkb3duIGNvbnRpbnVlcyBvbiB0aGF0IHRpbWVvdXQuwqAg
RWFjaCBzdWJzZXF1ZW50DQo+ID4gbm90aWZ5LCByZWdhcmRsZXNzIG9mIGNvbXBvbmVudCBvciBs
YWJlbCBjaGFuZ2VzLCBzaG91bGQgY29udGludWUNCj4gPiByZXBvcnRpbmcgdGhhdCBzYW1lIHRp
bWVvdXQgdmFsdWUgZm9yIGFzIGxvbmcgYXMgaXQgYXBwbGllcyB0byB0aGUNCj4gPiBhY3Rpb24u
wqAgSWYgYSBuZXcgdGltZW91dCB2YWx1ZSBpcyByZXBvcnRlZCwgdGhlIGNvdW50ZG93biBzdGFy
dHMgb3Zlci4NCj4gDQo+IFdoYXQgaWYgbm8gdGltZW91dCBleGlzdHMgZm9yIHRoZSBuZXh0IGFj
dGlvbj8gRHJpdmVyIHJlcG9ydHMgMCB0bw0KPiAiY2xlYXIiPw0KPiANCj4gPiBUaGlzIGNvbnRp
bnVlcyB1bnRpbCBlaXRoZXIgdGhlIGNvdW50ZG93biBmaW5pc2hlcyBvciB0aGUgZHJpdmVyIHJl
cG9ydHMNCj4gPiB0aGUgZmxhc2ggYXMgY29tcGxldGVkLsKgIEkgdGhpbmsgdGhpcyBhbGxvd3Mg
aXMgdGhlIGZsZXhpYmlsaXR5IGZvcg0KPiA+IG11bHRpcGxlIHN0ZXBzIHRoYXQgSmFrZSBhbGx1
ZGVzIHRvIGFib3ZlLsKgIERvZXMgdGhpcyBtYWtlIHNlbnNlPw0KPiANCj4gSSBkaXNhZ3JlZS4g
VGhpcyBkb2Vzbid0IG1hdGNoIHJlYWxpdHkvZHJpdmVyIGJlaGF2aW9yIGFuZCB3aWxsIGxlYWQg
dG8NCj4gdGltZW91dHMgY291bnRpbmcgdG8gc29tZSByYW5kb20gdmFsdWUsIHRoYXQncyB0byBz
YXkgdGhlIGRyaXZlcnMNCj4gdGltZW91dCBpbnN0YW50IHdpbGwgbm90IG1hdGNoIHdoZW4gdXNl
ciBzcGFjZSByZWFjaGVzIHRpbWVvdXQuDQo+IA0KPiBUaGUgdGltZW91dCBzaG91bGQgYmUgcGVy
IG5vdGlmaWNhdGlvbiwgYmVjYXVzZSBkcml2ZXJzIHNlbmQgYQ0KPiBub3RpZmljYXRpb24gcGVy
IGNvbW1hbmQsIGFuZCBjb21tYW5kcyBoYXZlIHRpbWVvdXQuDQo+IA0KDQpUaGlzIGlzIGhvdyBl
dmVyeXRoaW5nIG9wZXJhdGVzIHRvZGF5LiBKdXN0IHNlbmQgYSBuZXcgc3RhdHVzIGZvciBldmVy
eSBjb21tYW5kLg0KDQpJcyB0aGF0IG5vdCBob3cgeW91ciBjYXNlIHdvcmtzPw0KDQo+IFRoZSB0
aW1lb3V0IGlzIG9ubHkgbmVlZGVkIGlmIHRoZXJlIGlzIG5vIHByb2dyZXNzIHRvIHJlcG9ydCwg
aS5lLg0KPiBkcml2ZXIgaXMgd2FpdGluZyBmb3Igc29tZXRoaW5nIHRvIGhhcHBlbi4NCj4gDQoN
ClJpZ2h0Lg0KDQo+ID4gV2hhdCBzaG91bGQgdGhlIHVzZXJsYW5kIHByb2dyYW0gZG8gd2hlbiB0
aGUgdGltZW91dCBleHBpcmVzP8KgIFN0YXJ0DQo+ID4gY291bnRpbmcgYmFja3dhcmRzP8KgIFN0
b3Agd2FpdGluZz/CoCBEbyB3ZSBjYXJlIHRvIGRlZmluZSB0aGlzIGF0IHRoZSBtb21lbnQ/DQo+
IA0KPiBbY29tcG9uZW50XSBibGEgYmxhIFglICh0aW1lb3V0IHJlYWNoZWQpDQoNClllcC4gSSBk
b24ndCB0aGluayB1c2Vyc3BhY2Ugc2hvdWxkIGJhaWwgb3IgZG8gYW55dGhpbmcgYnV0IGRpc3Bs
YXkgaGVyZS4gQmFzaWNhbGx5OiB0aGUgZHJpdmVyIHdpbGwgdGltZW91dCBhbmQgdGhlbiBlbmQg
dGhlIHVwZGF0ZSBwcm9jZXNzIHdpdGggYW4gZXJyb3IuIFRoZSB0aW1lb3V0IHZhbHVlIGlzIGp1
c3QgYSB1c2VmdWwgZGlzcGxheSBzbyB0aGF0IHVzZXJzIGFyZW4ndCBjb25mdXNlZCB3aHkgdGhl
cmUgaXMgbm8gb3V0cHV0IGdvaW5nIG9uIHdoaWxlIHdhaXRpbmcuDQoNClRoYW5rcywNCkpha2UN
Cg==
