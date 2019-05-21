Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1C612458F
	for <lists+netdev@lfdr.de>; Tue, 21 May 2019 03:20:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727257AbfEUBUf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 May 2019 21:20:35 -0400
Received: from mga02.intel.com ([134.134.136.20]:10495 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726677AbfEUBUf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 May 2019 21:20:35 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 May 2019 18:20:34 -0700
X-ExtLoop1: 1
Received: from orsmsx103.amr.corp.intel.com ([10.22.225.130])
  by orsmga006.jf.intel.com with ESMTP; 20 May 2019 18:20:34 -0700
Received: from orsmsx114.amr.corp.intel.com (10.22.240.10) by
 ORSMSX103.amr.corp.intel.com (10.22.225.130) with Microsoft SMTP Server (TLS)
 id 14.3.408.0; Mon, 20 May 2019 18:20:34 -0700
Received: from orsmsx112.amr.corp.intel.com ([169.254.3.79]) by
 ORSMSX114.amr.corp.intel.com ([169.254.8.116]) with mapi id 14.03.0415.000;
 Mon, 20 May 2019 18:20:34 -0700
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
Thread-Index: AQHVD0ezpbXySuUS5EinefGl750kkaZ0/uwAgAALkwCAAAiygIAAGYEAgAADqwCAAA0vgA==
Date:   Tue, 21 May 2019 01:20:33 +0000
Message-ID: <a43f9224e6b245ade4b587a018c8a21815091f0f.camel@intel.com>
References: <c6020a01e81d08342e1a2b3ae7e03d55858480ba.camel@intel.com>
         <20190520.154855.2207738976381931092.davem@davemloft.net>
         <3e7e674c1fe094cd8dbe0c8933db18be1a37d76d.camel@intel.com>
         <20190520.203320.621504228022195532.davem@davemloft.net>
In-Reply-To: <20190520.203320.621504228022195532.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.30.1 (3.30.1-1.fc29) 
x-originating-ip: [10.254.114.95]
Content-Type: text/plain; charset="utf-8"
Content-ID: <D49A9B049E5A1C4885E25064E440A746@intel.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCAyMDE5LTA1LTIwIGF0IDIwOjMzIC0wNDAwLCBEYXZpZCBNaWxsZXIgd3JvdGU6DQo+
IEZyb206ICJFZGdlY29tYmUsIFJpY2sgUCIgPHJpY2sucC5lZGdlY29tYmVAaW50ZWwuY29tPg0K
PiBEYXRlOiBUdWUsIDIxIE1heSAyMDE5IDAwOjIwOjEzICswMDAwDQo+IA0KPiA+IFRoaXMgYmVo
YXZpb3Igc2hvdWxkbid0IGhhcHBlbiB1bnRpbCBtb2R1bGVzIG9yIEJQRiBhcmUgYmVpbmcNCj4g
PiBmcmVlZC4NCj4gDQo+IFRoZW4gdGhhdCB3b3VsZCBydWxlIG91dCBteSB0aGVvcnkuDQo+IA0K
PiBUaGUgb25seSB0aGluZyBsZWZ0IGlzIHdoZXRoZXIgdGhlIHBlcm1pc3Npb25zIGFyZSBhY3R1
YWxseSBzZXQNCj4gcHJvcGVybHkuICBJZiB0aGV5IGFyZW4ndCB3ZSdsbCB0YWtlIGFuIGV4Y2Vw
dGlvbiB3aGVuIHRoZSBCUEYNCj4gcHJvZ3JhbQ0KPiBpcyBydW4gYW5kIEknbSBub3QgJTEwMCBz
dXJlIHRoYXQga2VybmVsIGV4ZWN1dGUgcGVybWlzc2lvbg0KPiB2aW9sYXRpb25zDQo+IGFyZSB0
b3RhbGx5IGhhbmRsZWQgY2xlYW5seS4NClBlcm1pc3Npb25zIHNob3VsZG4ndCBiZSBhZmZlY3Rl
ZCB3aXRoIHRoaXMgZXhjZXB0IG9uIGZyZWUuIEJ1dCByZWFkaW5nDQp0aGUgY29kZSBpdCBsb29r
ZWQgbGlrZSBzcGFyYyBoYWQgYWxsIFBBR0VfS0VSTkVMIGFzIGV4ZWN1dGFibGUgYW5kIG5vDQpz
ZXRfbWVtb3J5XygpIGltcGxlbWVudGF0aW9ucy4gSXMgdGhlcmUgc29tZSBwbGFjZXMgd2hlcmUg
cGVybWlzc2lvbnMNCmFyZSBiZWluZyBzZXQ/DQoNClNob3VsZCBpdCBoYW5kbGUgZXhlY3V0aW5n
IGFuIHVubWFwcGVkIHBhZ2UgZ3JhY2VmdWxseT8gQmVjYXVzZSB0aGlzDQpjaGFuZ2UgaXMgY2F1
c2luZyB0aGF0IHRvIGhhcHBlbiBtdWNoIGVhcmxpZXIuIElmIHNvbWV0aGluZyB3YXMgcmVseWlu
Zw0Kb24gYSBjYWNoZWQgdHJhbnNsYXRpb24gdG8gZXhlY3V0ZSBzb21ldGhpbmcgaXQgY291bGQg
ZmluZCB0aGUgbWFwcGluZw0KZGlzYXBwZWFyLg0KDQoNCg0KDQoNCg0KDQoNCg0K
