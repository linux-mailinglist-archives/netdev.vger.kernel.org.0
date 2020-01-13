Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6EB113904A
	for <lists+netdev@lfdr.de>; Mon, 13 Jan 2020 12:43:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728695AbgAMLna (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 06:43:30 -0500
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:35125 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728516AbgAMLna (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jan 2020 06:43:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1578915809; x=1610451809;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=6XSa5GpL3gh4h8YvwELtoJ+sfZcbWRXkFc5y4pfehoc=;
  b=H7UzrQnHQV07GhWJ+7S7zpRigS14pbS0EBNq/WvUy+nCwkE+jWJkHg/k
   6yUUkvZ+9sq5At9GMk0twnajn2w+dZm9TX68EFrsUSoTkeoW63aFLnhm3
   0TUQ/5y9Asnj0DsDxWMADyC9taaFQlYBJHCH6/M6TPd07M0x7ooXN62Ky
   M=;
IronPort-SDR: R+BlWp6nTHVVhaIhMU2TJ0LB4YSRTLQsATI0sOMiyFM4iSh27yUGPwc+8iW49sp1OvtUIhwKnD
 k40Idn6O/1kA==
X-IronPort-AV: E=Sophos;i="5.69,428,1571702400"; 
   d="scan'208";a="12102670"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1a-821c648d.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP; 13 Jan 2020 11:43:27 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1a-821c648d.us-east-1.amazon.com (Postfix) with ESMTPS id 9A4CDA1D45;
        Mon, 13 Jan 2020 11:43:19 +0000 (UTC)
Received: from EX13D05UWB003.ant.amazon.com (10.43.161.26) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Mon, 13 Jan 2020 11:43:18 +0000
Received: from EX13D01UWB002.ant.amazon.com (10.43.161.136) by
 EX13D05UWB003.ant.amazon.com (10.43.161.26) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Mon, 13 Jan 2020 11:43:18 +0000
Received: from EX13D01UWB002.ant.amazon.com ([10.43.161.136]) by
 EX13d01UWB002.ant.amazon.com ([10.43.161.136]) with mapi id 15.00.1367.000;
 Mon, 13 Jan 2020 11:43:18 +0000
From:   "Singh, Balbir" <sblbir@amazon.com>
To:     "peterz@infradead.org" <peterz@infradead.org>,
        "Valentin, Eduardo" <eduval@amazon.com>
CC:     "boris.ostrovsky@oracle.com" <boris.ostrovsky@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Agarwal, Anchal" <anchalag@amazon.com>,
        "Woodhouse, David" <dwmw@amazon.co.uk>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "sstabellini@kernel.org" <sstabellini@kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "Woodhouse@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com" 
        <Woodhouse@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "jgross@suse.com" <jgross@suse.com>, "pavel@ucw.cz" <pavel@ucw.cz>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "x86@kernel.org" <x86@kernel.org>,
        "roger.pau@citrix.com" <roger.pau@citrix.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "Kamata, Munehisa" <kamatam@amazon.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "konrad.wilk@oracle.co" <konrad.wilk@oracle.co>,
        "len.brown@intel.com" <len.brown@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "fllinden@amaozn.com" <fllinden@amaozn.com>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>
Subject: Re: [RFC PATCH V2 11/11] x86: tsc: avoid system instability in
 hibernation
Thread-Topic: [RFC PATCH V2 11/11] x86: tsc: avoid system instability in
 hibernation
Thread-Index: AQHVxbSKwN2FtiBCp0yRN06uTqctz6fgl2OAgAN0VQCABF3RgIAAGFiA
Date:   Mon, 13 Jan 2020 11:43:18 +0000
Message-ID: <857b42b2e86b2ae09a23f488daada3b1b2836116.camel@amazon.com>
References: <20200107234526.GA19034@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
         <20200108105011.GY2827@hirez.programming.kicks-ass.net>
         <20200110153520.GC8214@u40b0340c692b58f6553c.ant.amazon.com>
         <20200113101609.GT2844@hirez.programming.kicks-ass.net>
In-Reply-To: <20200113101609.GT2844@hirez.programming.kicks-ass.net>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.162.119]
Content-Type: text/plain; charset="utf-8"
Content-ID: <842199D22376DB4B847E04A9819A1D72@amazon.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCAyMDIwLTAxLTEzIGF0IDExOjE2ICswMTAwLCBQZXRlciBaaWpsc3RyYSB3cm90ZToN
Cj4gT24gRnJpLCBKYW4gMTAsIDIwMjAgYXQgMDc6MzU6MjBBTSAtMDgwMCwgRWR1YXJkbyBWYWxl
bnRpbiB3cm90ZToNCj4gPiBIZXkgUGV0ZXIsDQo+ID4gDQo+ID4gT24gV2VkLCBKYW4gMDgsIDIw
MjAgYXQgMTE6NTA6MTFBTSArMDEwMCwgUGV0ZXIgWmlqbHN0cmEgd3JvdGU6DQo+ID4gPiBPbiBU
dWUsIEphbiAwNywgMjAyMCBhdCAxMTo0NToyNlBNICswMDAwLCBBbmNoYWwgQWdhcndhbCB3cm90
ZToNCj4gPiA+ID4gRnJvbTogRWR1YXJkbyBWYWxlbnRpbiA8ZWR1dmFsQGFtYXpvbi5jb20+DQo+
ID4gPiA+IA0KPiA+ID4gPiBTeXN0ZW0gaW5zdGFiaWxpdHkgYXJlIHNlZW4gZHVyaW5nIHJlc3Vt
ZSBmcm9tIGhpYmVybmF0aW9uIHdoZW4gc3lzdGVtDQo+ID4gPiA+IGlzIHVuZGVyIGhlYXZ5IENQ
VSBsb2FkLiBUaGlzIGlzIGR1ZSB0byB0aGUgbGFjayBvZiB1cGRhdGUgb2Ygc2NoZWQNCj4gPiA+
ID4gY2xvY2sgZGF0YSwgYW5kIHRoZSBzY2hlZHVsZXIgd291bGQgdGhlbiB0aGluayB0aGF0IGhl
YXZ5IENQVSBob2cNCj4gPiA+ID4gdGFza3MgbmVlZCBtb3JlIHRpbWUgaW4gQ1BVLCBjYXVzaW5n
IHRoZSBzeXN0ZW0gdG8gZnJlZXplDQo+ID4gPiA+IGR1cmluZyB0aGUgdW5mcmVlemluZyBvZiB0
YXNrcy4gRm9yIGV4YW1wbGUsIHRocmVhZGVkIGlycXMsDQo+ID4gPiA+IGFuZCBrZXJuZWwgcHJv
Y2Vzc2VzIHNlcnZpY2luZyBuZXR3b3JrIGludGVyZmFjZSBtYXkgYmUgZGVsYXllZA0KPiA+ID4g
PiBmb3Igc2V2ZXJhbCB0ZW5zIG9mIHNlY29uZHMsIGNhdXNpbmcgdGhlIHN5c3RlbSB0byBiZSB1
bnJlYWNoYWJsZS4NCj4gPiA+ID4gVGhlIGZpeCBmb3IgdGhpcyBzaXR1YXRpb24gaXMgdG8gbWFy
ayB0aGUgc2NoZWQgY2xvY2sgYXMgdW5zdGFibGUNCj4gPiA+ID4gYXMgZWFybHkgYXMgcG9zc2li
bGUgaW4gdGhlIHJlc3VtZSBwYXRoLCBsZWF2aW5nIGl0IHVuc3RhYmxlDQo+ID4gPiA+IGZvciB0
aGUgZHVyYXRpb24gb2YgdGhlIHJlc3VtZSBwcm9jZXNzLiBUaGlzIHdpbGwgZm9yY2UgdGhlDQo+
ID4gPiA+IHNjaGVkdWxlciB0byBhdHRlbXB0IHRvIGFsaWduIHRoZSBzY2hlZCBjbG9jayBhY3Jv
c3MgQ1BVcyB1c2luZw0KPiA+ID4gPiB0aGUgZGVsdGEgd2l0aCB0aW1lIG9mIGRheSwgdXBkYXRp
bmcgc2NoZWQgY2xvY2sgZGF0YS4gSW4gYSBwb3N0DQo+ID4gPiA+IGhpYmVybmF0aW9uIGV2ZW50
LCB3ZSBjYW4gdGhlbiBtYXJrIHRoZSBzY2hlZCBjbG9jayBhcyBzdGFibGUNCj4gPiA+ID4gYWdh
aW4sIGF2b2lkaW5nIHVubmVjZXNzYXJ5IHN5bmNzIHdpdGggdGltZSBvZiBkYXkgb24gc3lzdGVt
cw0KPiA+ID4gPiBpbiB3aGljaCBUU0MgaXMgcmVsaWFibGUuDQo+ID4gPiANCj4gPiA+IFRoaXMg
bWFrZXMgbm8gZnJpZ2dpbmcgc2Vuc2Ugd2hhdCBzbyBibG9vZHkgZXZlci4gSWYgdGhlIGNsb2Nr
IGlzDQo+ID4gPiBzdGFibGUsIHdlIGRvbid0IGNhcmUgYWJvdXQgc2NoZWRfY2xvY2tfZGF0YS4g
V2hlbiBpdCBpcyBzdGFibGUgeW91IGdldA0KPiA+ID4gYSBsaW5lYXIgZnVuY3Rpb24gb2YgdGhl
IFRTQyB3aXRob3V0IGNvbXBsaWNhdGVkIGJpdHMgb24uDQo+ID4gPiANCj4gPiA+IFdoZW4gaXQg
aXMgdW5zdGFibGUsIG9ubHkgdGhlbiBkbyB3ZSBjYXJlIGFib3V0IHRoZSBzY2hlZF9jbG9ja19k
YXRhLg0KPiA+ID4gDQo+ID4gDQo+ID4gWWVhaCwgbWF5YmUgd2hhdCBpcyBub3QgY2xlYXIgaGVy
ZSBpcyB0aGF0IHdlIGNvdmVyaW5nIGZvciBzaXR1YXRpb24NCj4gPiB3aGVyZSBjbG9jayBzdGFi
aWxpdHkgY2hhbmdlcyBvdmVyIHRpbWUsIGUuZy4gYXQgcmVndWxhciBib290IGNsb2NrIGlzDQo+
ID4gc3RhYmxlLCBoaWJlcm5hdGlvbiBoYXBwZW5zLCB0aGVuIHJlc3RvcmUgaGFwcGVucyBpbiBh
IG5vbi1zdGFibGUgY2xvY2suDQo+IA0KPiBTdGlsbCBjb25mdXNlZCwgd2hvIG1hcmtzIHRoZSB0
aGluZyB1bnN0YWJsZT8gVGhlIHBhdGNoIHNlZW1zIHRvIHN1Z2dlc3QNCj4geW91IGRvIHlvdXJz
ZWxmLCBidXQgaXQgaXMgbm90IGF0IGFsbCBjbGVhciB3aHkuDQo+IA0KPiBJZiBUU0MgcmVhbGx5
IGlzIHVuc3RhYmxlLCB0aGVuIGl0IG5lZWRzIHRvIHJlbWFpbiB1bnN0YWJsZS4gSWYgdGhlIFRT
Qw0KPiByZWFsbHkgaXMgc3RhYmxlIHRoZW4gdGhlcmUgaXMgbm8gcG9pbnQgaW4gbWFya2luZyBp
cyB1bnN0YWJsZS4NCj4gDQo+IEVpdGhlciB3YXkgc29tZXRoaW5nIGlzIG9mZiwgYW5kIHlvdSdy
ZSBub3QgdGVsbGluZyBtZSB3aGF0Lg0KPiANCg0KSGksIFBldGVyDQoNCkZvciB5b3VyIG9yaWdp
bmFsIGNvbW1lbnQsIGp1c3Qgd2FudGVkIHRvIGNsYXJpZnkgdGhlIGZvbGxvd2luZzoNCg0KMS4g
QWZ0ZXIgaGliZXJuYXRpb24sIHRoZSBtYWNoaW5lIGNhbiBiZSByZXN1bWVkIG9uIGEgZGlmZmVy
ZW50IGJ1dCBjb21wYXRpYmxlDQpob3N0ICh0aGVzZSBhcmUgVk0gaW1hZ2VzIGhpYmVybmF0ZWQp
DQoyLiBUaGlzIG1lYW5zIHRoZSBjbG9jayBiZXR3ZWVuIGhvc3QxIGFuZCBob3N0MiBjYW4vd2ls
bCBiZSBkaWZmZXJlbnQNCg0KSW4geW91ciBjb21tZW50cyBhcmUgeW91IG1ha2luZyB0aGUgYXNz
dW1wdGlvbiB0aGF0IHRoZSBob3N0KHMpIGlzL2FyZSB0aGUNCnNhbWU/IEp1c3QgY2hlY2tpbmcg
dGhlIGFzc3VtcHRpb25zIGJlaW5nIG1hZGUgYW5kIGJlaW5nIG9uIHRoZSBzYW1lIHBhZ2Ugd2l0
aA0KdGhlbS4NCg0KQmFsYmlyIFNpbmdoLg0KDQo+ID4gPiA+IFJldmlld2VkLWJ5OiBFcmlrIFF1
YW5zdHJvbSA8cXVhbnN0cm9AYW1hem9uLmNvbT4NCj4gPiA+ID4gUmV2aWV3ZWQtYnk6IEZyYW5r
IHZhbiBkZXIgTGluZGVuIDxmbGxpbmRlbkBhbWF6b24uY29tPg0KPiA+ID4gPiBSZXZpZXdlZC1i
eTogQmFsYmlyIFNpbmdoIDxzYmxiaXJAYW1hem9uLmNvbT4NCj4gPiA+ID4gUmV2aWV3ZWQtYnk6
IE11bmVoaXNhIEthbWF0YSA8a2FtYXRhbUBhbWF6b24uY29tPg0KPiA+ID4gPiBUZXN0ZWQtYnk6
IEFuY2hhbCBBZ2Fyd2FsIDxhbmNoYWxhZ0BhbWF6b24uY29tPg0KPiA+ID4gPiBTaWduZWQtb2Zm
LWJ5OiBFZHVhcmRvIFZhbGVudGluIDxlZHV2YWxAYW1hem9uLmNvbT4NCj4gPiA+ID4gLS0tDQo+
ID4gPiANCj4gPiA+IE5BSywgdGhlIGNvZGUgdmVyeSBtdWNoIHJlbGllcyBvbiBuZXZlciBnZXR0
aW5nIG1hcmtlZCBzdGFibGUgYWdhaW4NCj4gPiA+IGFmdGVyIGl0IGdldHMgc2V0IHRvIHVuc3Rh
YmxlLg0KPiA+ID4gDQo+ID4gDQo+ID4gV2VsbCBhY3R1YWxseSwgYXQgdGhlIFBNX1BPU1RfSElC
RVJOQVRJT04sIHdlIGRvIHRoZSBjaGVjayBhbmQgc2V0IHN0YWJsZQ0KPiA+IGlmDQo+ID4ga25v
d24gdG8gYmUgc3RhYmxlLg0KPiA+IA0KPiA+IFRoZSBpc3N1ZSBvbmx5IHJlYWxseSBoYXBwZW5z
IGR1cmluZyB0aGUgcmVzdG9yYXRpb24gcGF0aCB1bmRlciBzY2hlZHVsaW5nDQo+ID4gcHJlc3N1
cmUsDQo+ID4gd2hpY2ggdGFrZXMgZm9yZXZlciB0byBmaW5pc2gsIGFzIGRlc2NyaWJlZCBpbiB0
aGUgY29tbWl0Lg0KPiA+IA0KPiA+IERvIHlvdSBzZWUgYSBiZXR0ZXIgc29sdXRpb24gZm9yIHRo
aXMgaXNzdWU/DQo+IA0KPiBJIHN0aWxsIGhhdmUgbm8gY2x1ZSB3aGF0IHlvdXIgYWN0dWFsIHBy
b2JsZW0gaXMuIFlvdSBzYXkgc2NoZWR1bGluZw0KPiBnb2VzIHdvYmJseSBiZWNhdXNlIHNjaGVk
X2Nsb2NrX2RhdGEgaXMgc3RhbGUsIGJ1dCB3aGVuIHN0YWJsZSB0aGF0DQo+IGRvZXNuJ3QgbWF0
dGVyLg0KPiANCj4gU28gd2hhdCBpcyB0aGUgYWN0dWFsIHByb2JsZW0/DQo=
