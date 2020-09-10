Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0747F2641AD
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 11:27:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730277AbgIJJ1a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 05:27:30 -0400
Received: from mga11.intel.com ([192.55.52.93]:33850 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729005AbgIJJZc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Sep 2020 05:25:32 -0400
IronPort-SDR: aM9dGmQSLwx43RrClft7x7Yz6tuRiNxSVOZKfS+bBrFhPlECIDHL22Cj8VLVgBmynMPlCiksWy
 FE+Sg/axZ0uQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9739"; a="155959305"
X-IronPort-AV: E=Sophos;i="5.76,412,1592895600"; 
   d="scan'208";a="155959305"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2020 02:24:53 -0700
IronPort-SDR: sPzzQTW+zCXHCnDWyIItGACI5PKsO8xVROYydDVE3K7qjLI3/37RsfJoX090uiUVr0A7ZCvtq0
 Nb7MlwO6207w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,412,1592895600"; 
   d="scan'208";a="505775687"
Received: from irsmsx605.ger.corp.intel.com ([163.33.146.138])
  by fmsmga005.fm.intel.com with ESMTP; 10 Sep 2020 02:24:52 -0700
Received: from irsmsx604.ger.corp.intel.com (163.33.146.137) by
 IRSMSX605.ger.corp.intel.com (163.33.146.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 10 Sep 2020 10:24:51 +0100
Received: from irsmsx604.ger.corp.intel.com ([163.33.146.137]) by
 IRSMSX604.ger.corp.intel.com ([163.33.146.137]) with mapi id 15.01.1713.004;
 Thu, 10 Sep 2020 10:24:51 +0100
From:   "Loftus, Ciara" <ciara.loftus@intel.com>
To:     =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>
CC:     "Topel, Bjorn" <bjorn.topel@intel.com>,
        "maximmi@nvidia.com" <maximmi@nvidia.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        "jonathan.lemon@gmail.com" <jonathan.lemon@gmail.com>
Subject: RE: [PATCH bpf] xsk: fix number of pinned pages/umem size discrepancy
Thread-Topic: [PATCH bpf] xsk: fix number of pinned pages/umem size
 discrepancy
Thread-Index: AQHWh0fv2JgIUnGE6kGbQm4dy+htC6lhmY6A
Date:   Thu, 10 Sep 2020 09:24:51 +0000
Message-ID: <f83087dfb41043648825c382ce6efa61@intel.com>
References: <20200910075609.7904-1-bjorn.topel@gmail.com>
In-Reply-To: <20200910075609.7904-1-bjorn.topel@gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.5.1.3
x-originating-ip: [163.33.253.164]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiANCj4gRnJvbTogQmrDtnJuIFTDtnBlbCA8Ympvcm4udG9wZWxAaW50ZWwuY29tPg0KPiANCj4g
Rm9yIEFGX1hEUCBzb2NrZXRzLCB0aGVyZSB3YXMgYSBkaXNjcmVwYW5jeSBiZXR3ZWVuIHRoZSBu
dW1iZXIgb2Ygb2YNCj4gcGlubmVkIHBhZ2VzIGFuZCB0aGUgc2l6ZSBvZiB0aGUgdW1lbSByZWdp
b24uDQo+IA0KPiBUaGUgc2l6ZSBvZiB0aGUgdW1lbSByZWdpb24gaXMgdXNlZCB0byB2YWxpZGF0
ZSB0aGUgQUZfWERQIGRlc2NyaXB0b3INCj4gYWRkcmVzc2VzLiBUaGUgbG9naWMgdGhhdCBwaW5u
ZWQgdGhlIHBhZ2VzIGNvdmVyZWQgYnkgdGhlIHJlZ2lvbiBvbmx5DQo+IHRvb2sgd2hvbGUgcGFn
ZXMgaW50byBjb25zaWRlcmF0aW9uLCBjcmVhdGluZyBhIG1pc21hdGNoIGJldHdlZW4gdGhlDQo+
IHNpemUgYW5kIHBpbm5lZCBwYWdlcy4gQSB1c2VyIGNvdWxkIHRoZW4gcGFzcyBBRl9YRFAgYWRk
cmVzc2VzIG91dHNpZGUNCj4gdGhlIHJhbmdlIG9mIHBpbm5lZCBwYWdlcywgYnV0IHN0aWxsIHdp
dGhpbiB0aGUgc2l6ZSBvZiB0aGUgcmVnaW9uLA0KPiBjcmFzaGluZyB0aGUga2VybmVsLg0KPiAN
Cj4gVGhpcyBjaGFuZ2UgY29ycmVjdGx5IGNhbGN1bGF0ZXMgdGhlIG51bWJlciBvZiBwYWdlcyB0
byBiZQ0KPiBwaW5uZWQuIEZ1cnRoZXIsIHRoZSBzaXplIGNoZWNrIGZvciB0aGUgYWxpZ25lZCBt
b2RlIGlzDQo+IHNpbXBsaWZpZWQuIE5vdyB0aGUgY29kZSBzaW1wbHkgY2hlY2tzIGlmIHRoZSBz
aXplIGlzIGRpdmlzaWJsZSBieSB0aGUNCj4gY2h1bmsgc2l6ZS4NCj4gDQo+IEZpeGVzOiBiYmZm
MmYzMjFhODYgKCJ4c2s6IG5ldyBkZXNjcmlwdG9yIGFkZHJlc3Npbmcgc2NoZW1lIikNCj4gUmVw
b3J0ZWQtYnk6IENpYXJhIExvZnR1cyA8Y2lhcmEubG9mdHVzQGludGVsLmNvbT4NCj4gU2lnbmVk
LW9mZi1ieTogQmrDtnJuIFTDtnBlbCA8Ympvcm4udG9wZWxAaW50ZWwuY29tPg0KDQpUaGFua3Mg
Zm9yIHRoZSBwYXRjaCBCasO2cm4uDQoNClRlc3RlZC1ieTogQ2lhcmEgTG9mdHVzIDxjaWFyYS5s
b2Z0dXNAaW50ZWwuY29tPg0KDQo+IC0tLQ0KPiAgbmV0L3hkcC94ZHBfdW1lbS5jIHwgMTcgKysr
KysrKystLS0tLS0tLS0NCj4gIDEgZmlsZSBjaGFuZ2VkLCA4IGluc2VydGlvbnMoKyksIDkgZGVs
ZXRpb25zKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvbmV0L3hkcC94ZHBfdW1lbS5jIGIvbmV0L3hk
cC94ZHBfdW1lbS5jDQo+IGluZGV4IGU5N2RiMzczNTRlNC4uYjAxMGJmZGUwMTQ5IDEwMDY0NA0K
PiAtLS0gYS9uZXQveGRwL3hkcF91bWVtLmMNCj4gKysrIGIvbmV0L3hkcC94ZHBfdW1lbS5jDQo+
IEBAIC0zMDMsMTAgKzMwMywxMCBAQCBzdGF0aWMgaW50IHhkcF91bWVtX2FjY291bnRfcGFnZXMo
c3RydWN0DQo+IHhkcF91bWVtICp1bWVtKQ0KPiANCj4gIHN0YXRpYyBpbnQgeGRwX3VtZW1fcmVn
KHN0cnVjdCB4ZHBfdW1lbSAqdW1lbSwgc3RydWN0IHhkcF91bWVtX3JlZw0KPiAqbXIpDQo+ICB7
DQo+ICsJdTMyIG5wZ3NfcmVtLCBjaHVua19zaXplID0gbXItPmNodW5rX3NpemUsIGhlYWRyb29t
ID0gbXItDQo+ID5oZWFkcm9vbTsNCj4gIAlib29sIHVuYWxpZ25lZF9jaHVua3MgPSBtci0+Zmxh
Z3MgJg0KPiBYRFBfVU1FTV9VTkFMSUdORURfQ0hVTktfRkxBRzsNCj4gLQl1MzIgY2h1bmtfc2l6
ZSA9IG1yLT5jaHVua19zaXplLCBoZWFkcm9vbSA9IG1yLT5oZWFkcm9vbTsNCj4gIAl1NjQgbnBn
cywgYWRkciA9IG1yLT5hZGRyLCBzaXplID0gbXItPmxlbjsNCj4gLQl1bnNpZ25lZCBpbnQgY2h1
bmtzLCBjaHVua3NfcGVyX3BhZ2U7DQo+ICsJdW5zaWduZWQgaW50IGNodW5rcywgY2h1bmtzX3Jl
bTsNCj4gIAlpbnQgZXJyOw0KPiANCj4gIAlpZiAoY2h1bmtfc2l6ZSA8IFhEUF9VTUVNX01JTl9D
SFVOS19TSVpFIHx8IGNodW5rX3NpemUgPg0KPiBQQUdFX1NJWkUpIHsNCj4gQEAgLTMzNiwxOSAr
MzM2LDE4IEBAIHN0YXRpYyBpbnQgeGRwX3VtZW1fcmVnKHN0cnVjdCB4ZHBfdW1lbQ0KPiAqdW1l
bSwgc3RydWN0IHhkcF91bWVtX3JlZyAqbXIpDQo+ICAJaWYgKChhZGRyICsgc2l6ZSkgPCBhZGRy
KQ0KPiAgCQlyZXR1cm4gLUVJTlZBTDsNCj4gDQo+IC0JbnBncyA9IHNpemUgPj4gUEFHRV9TSElG
VDsNCj4gKwlucGdzID0gZGl2X3U2NF9yZW0oc2l6ZSwgUEFHRV9TSVpFLCAmbnBnc19yZW0pOw0K
PiArCWlmIChucGdzX3JlbSkNCj4gKwkJbnBncysrOw0KPiAgCWlmIChucGdzID4gVTMyX01BWCkN
Cj4gIAkJcmV0dXJuIC1FSU5WQUw7DQo+IA0KPiAtCWNodW5rcyA9ICh1bnNpZ25lZCBpbnQpZGl2
X3U2NChzaXplLCBjaHVua19zaXplKTsNCj4gKwljaHVua3MgPSAodW5zaWduZWQgaW50KWRpdl91
NjRfcmVtKHNpemUsIGNodW5rX3NpemUsDQo+ICZjaHVua3NfcmVtKTsNCj4gIAlpZiAoY2h1bmtz
ID09IDApDQo+ICAJCXJldHVybiAtRUlOVkFMOw0KPiANCj4gLQlpZiAoIXVuYWxpZ25lZF9jaHVu
a3MpIHsNCj4gLQkJY2h1bmtzX3Blcl9wYWdlID0gUEFHRV9TSVpFIC8gY2h1bmtfc2l6ZTsNCj4g
LQkJaWYgKGNodW5rcyA8IGNodW5rc19wZXJfcGFnZSB8fCBjaHVua3MgJQ0KPiBjaHVua3NfcGVy
X3BhZ2UpDQo+IC0JCQlyZXR1cm4gLUVJTlZBTDsNCj4gLQl9DQo+ICsJaWYgKCF1bmFsaWduZWRf
Y2h1bmtzICYmIGNodW5rc19yZW0pDQo+ICsJCXJldHVybiAtRUlOVkFMOw0KPiANCj4gIAlpZiAo
aGVhZHJvb20gPj0gY2h1bmtfc2l6ZSAtIFhEUF9QQUNLRVRfSEVBRFJPT00pDQo+ICAJCXJldHVy
biAtRUlOVkFMOw0KPiANCj4gYmFzZS1jb21taXQ6IDc0NmY1MzRhNDgwOWUwN2Y0MjdmN2QxM2Qx
MGYzYTZhOTY0MWU1YzMNCj4gLS0NCj4gMi4yNS4xDQoNCg==
