Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59D09139439
	for <lists+netdev@lfdr.de>; Mon, 13 Jan 2020 16:02:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728986AbgAMPC3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 10:02:29 -0500
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:41566 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726567AbgAMPC3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jan 2020 10:02:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1578927748; x=1610463748;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=00UHMfzPeMYvDihnCksaHgrF7drmY1MfJ5JQC5sgbpQ=;
  b=UNsl+1rIHJYDqXPDRoSDy/mKv9Bw1skfTR6bxcq4933Wobr/cfWhIp/v
   nOK2AsxXf+EW1s8XItpzefQ611bo6t47rYHMJZksnqu5Jeg9kBDdK862A
   gHLKB1m6gDMNZ0syf5IPv4GzM3fdSJfqGgzyoMRcBkT+hlqTImSjyEJos
   0=;
IronPort-SDR: FzL3tFfE8yxBII0BXAQs6wfW7bZNURvXScpp0QJqTzAlVRUbDm7vwoKF8EcLo9brCRfSd+HfIU
 JWdJu1alPqPQ==
X-IronPort-AV: E=Sophos;i="5.69,429,1571702400"; 
   d="scan'208";a="11285542"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1e-27fb8269.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-6002.iad6.amazon.com with ESMTP; 13 Jan 2020 15:02:27 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1e-27fb8269.us-east-1.amazon.com (Postfix) with ESMTPS id E52D9A05E4;
        Mon, 13 Jan 2020 15:02:18 +0000 (UTC)
Received: from EX13D05UWB003.ant.amazon.com (10.43.161.26) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Mon, 13 Jan 2020 15:02:18 +0000
Received: from EX13D01UWB002.ant.amazon.com (10.43.161.136) by
 EX13D05UWB003.ant.amazon.com (10.43.161.26) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Mon, 13 Jan 2020 15:02:17 +0000
Received: from EX13D01UWB002.ant.amazon.com ([10.43.161.136]) by
 EX13d01UWB002.ant.amazon.com ([10.43.161.136]) with mapi id 15.00.1367.000;
 Mon, 13 Jan 2020 15:02:18 +0000
From:   "Singh, Balbir" <sblbir@amazon.com>
To:     "peterz@infradead.org" <peterz@infradead.org>,
        "Valentin, Eduardo" <eduval@amazon.com>,
        "andrew.cooper3@citrix.com" <andrew.cooper3@citrix.com>
CC:     "boris.ostrovsky@oracle.com" <boris.ostrovsky@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Agarwal, Anchal" <anchalag@amazon.com>,
        "Woodhouse, David" <dwmw@amazon.co.uk>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "sstabellini@kernel.org" <sstabellini@kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "Woodhouse@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com" 
        <Woodhouse@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "pavel@ucw.cz" <pavel@ucw.cz>, "jgross@suse.com" <jgross@suse.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "x86@kernel.org" <x86@kernel.org>,
        "roger.pau@citrix.com" <roger.pau@citrix.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "fllinden@amaozn.com" <fllinden@amaozn.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "Kamata, Munehisa" <kamatam@amazon.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "konrad.wilk@oracle.co" <konrad.wilk@oracle.co>,
        "len.brown@intel.com" <len.brown@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>
Subject: Re: [Xen-devel] [RFC PATCH V2 11/11] x86: tsc: avoid system
 instability in hibernation
Thread-Topic: [Xen-devel] [RFC PATCH V2 11/11] x86: tsc: avoid system
 instability in hibernation
Thread-Index: AQHVxbSKwN2FtiBCp0yRN06uTqctz6fgl2OAgAN0VQCABF3RgIAAGFiAgAAVuQCAACHcgA==
Date:   Mon, 13 Jan 2020 15:02:17 +0000
Message-ID: <34c5d10f1df00345ff7ab2ba91d38a32967b3bce.camel@amazon.com>
References: <20200107234526.GA19034@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
         <20200108105011.GY2827@hirez.programming.kicks-ass.net>
         <20200110153520.GC8214@u40b0340c692b58f6553c.ant.amazon.com>
         <20200113101609.GT2844@hirez.programming.kicks-ass.net>
         <857b42b2e86b2ae09a23f488daada3b1b2836116.camel@amazon.com>
         <7bb967ca-2a91-6397-9c0a-6eafd43c83ed@citrix.com>
In-Reply-To: <7bb967ca-2a91-6397-9c0a-6eafd43c83ed@citrix.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.162.7]
Content-Type: text/plain; charset="utf-8"
Content-ID: <BECA72B668B89347805549D9C3D15597@amazon.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCAyMDIwLTAxLTEzIGF0IDEzOjAxICswMDAwLCBBbmRyZXcgQ29vcGVyIHdyb3RlOg0K
PiBPbiAxMy8wMS8yMDIwIDExOjQzLCBTaW5naCwgQmFsYmlyIHdyb3RlOg0KPiA+IE9uIE1vbiwg
MjAyMC0wMS0xMyBhdCAxMToxNiArMDEwMCwgUGV0ZXIgWmlqbHN0cmEgd3JvdGU6DQo+ID4gPiBP
biBGcmksIEphbiAxMCwgMjAyMCBhdCAwNzozNToyMEFNIC0wODAwLCBFZHVhcmRvIFZhbGVudGlu
IHdyb3RlOg0KPiA+ID4gPiBIZXkgUGV0ZXIsDQo+ID4gPiA+IA0KPiA+ID4gPiBPbiBXZWQsIEph
biAwOCwgMjAyMCBhdCAxMTo1MDoxMUFNICswMTAwLCBQZXRlciBaaWpsc3RyYSB3cm90ZToNCj4g
PiA+ID4gPiBPbiBUdWUsIEphbiAwNywgMjAyMCBhdCAxMTo0NToyNlBNICswMDAwLCBBbmNoYWwg
QWdhcndhbCB3cm90ZToNCj4gPiA+ID4gPiA+IEZyb206IEVkdWFyZG8gVmFsZW50aW4gPGVkdXZh
bEBhbWF6b24uY29tPg0KPiA+ID4gPiA+ID4gDQo+ID4gPiA+ID4gPiBTeXN0ZW0gaW5zdGFiaWxp
dHkgYXJlIHNlZW4gZHVyaW5nIHJlc3VtZSBmcm9tIGhpYmVybmF0aW9uIHdoZW4NCj4gPiA+ID4g
PiA+IHN5c3RlbQ0KPiA+ID4gPiA+ID4gaXMgdW5kZXIgaGVhdnkgQ1BVIGxvYWQuIFRoaXMgaXMg
ZHVlIHRvIHRoZSBsYWNrIG9mIHVwZGF0ZSBvZg0KPiA+ID4gPiA+ID4gc2NoZWQNCj4gPiA+ID4g
PiA+IGNsb2NrIGRhdGEsIGFuZCB0aGUgc2NoZWR1bGVyIHdvdWxkIHRoZW4gdGhpbmsgdGhhdCBo
ZWF2eSBDUFUgaG9nDQo+ID4gPiA+ID4gPiB0YXNrcyBuZWVkIG1vcmUgdGltZSBpbiBDUFUsIGNh
dXNpbmcgdGhlIHN5c3RlbSB0byBmcmVlemUNCj4gPiA+ID4gPiA+IGR1cmluZyB0aGUgdW5mcmVl
emluZyBvZiB0YXNrcy4gRm9yIGV4YW1wbGUsIHRocmVhZGVkIGlycXMsDQo+ID4gPiA+ID4gPiBh
bmQga2VybmVsIHByb2Nlc3NlcyBzZXJ2aWNpbmcgbmV0d29yayBpbnRlcmZhY2UgbWF5IGJlIGRl
bGF5ZWQNCj4gPiA+ID4gPiA+IGZvciBzZXZlcmFsIHRlbnMgb2Ygc2Vjb25kcywgY2F1c2luZyB0
aGUgc3lzdGVtIHRvIGJlIHVucmVhY2hhYmxlLg0KPiA+ID4gPiA+ID4gVGhlIGZpeCBmb3IgdGhp
cyBzaXR1YXRpb24gaXMgdG8gbWFyayB0aGUgc2NoZWQgY2xvY2sgYXMgdW5zdGFibGUNCj4gPiA+
ID4gPiA+IGFzIGVhcmx5IGFzIHBvc3NpYmxlIGluIHRoZSByZXN1bWUgcGF0aCwgbGVhdmluZyBp
dCB1bnN0YWJsZQ0KPiA+ID4gPiA+ID4gZm9yIHRoZSBkdXJhdGlvbiBvZiB0aGUgcmVzdW1lIHBy
b2Nlc3MuIFRoaXMgd2lsbCBmb3JjZSB0aGUNCj4gPiA+ID4gPiA+IHNjaGVkdWxlciB0byBhdHRl
bXB0IHRvIGFsaWduIHRoZSBzY2hlZCBjbG9jayBhY3Jvc3MgQ1BVcyB1c2luZw0KPiA+ID4gPiA+
ID4gdGhlIGRlbHRhIHdpdGggdGltZSBvZiBkYXksIHVwZGF0aW5nIHNjaGVkIGNsb2NrIGRhdGEu
IEluIGEgcG9zdA0KPiA+ID4gPiA+ID4gaGliZXJuYXRpb24gZXZlbnQsIHdlIGNhbiB0aGVuIG1h
cmsgdGhlIHNjaGVkIGNsb2NrIGFzIHN0YWJsZQ0KPiA+ID4gPiA+ID4gYWdhaW4sIGF2b2lkaW5n
IHVubmVjZXNzYXJ5IHN5bmNzIHdpdGggdGltZSBvZiBkYXkgb24gc3lzdGVtcw0KPiA+ID4gPiA+
ID4gaW4gd2hpY2ggVFNDIGlzIHJlbGlhYmxlLg0KPiA+ID4gPiA+IA0KPiA+ID4gPiA+IFRoaXMg
bWFrZXMgbm8gZnJpZ2dpbmcgc2Vuc2Ugd2hhdCBzbyBibG9vZHkgZXZlci4gSWYgdGhlIGNsb2Nr
IGlzDQo+ID4gPiA+ID4gc3RhYmxlLCB3ZSBkb24ndCBjYXJlIGFib3V0IHNjaGVkX2Nsb2NrX2Rh
dGEuIFdoZW4gaXQgaXMgc3RhYmxlIHlvdQ0KPiA+ID4gPiA+IGdldA0KPiA+ID4gPiA+IGEgbGlu
ZWFyIGZ1bmN0aW9uIG9mIHRoZSBUU0Mgd2l0aG91dCBjb21wbGljYXRlZCBiaXRzIG9uLg0KPiA+
ID4gPiA+IA0KPiA+ID4gPiA+IFdoZW4gaXQgaXMgdW5zdGFibGUsIG9ubHkgdGhlbiBkbyB3ZSBj
YXJlIGFib3V0IHRoZQ0KPiA+ID4gPiA+IHNjaGVkX2Nsb2NrX2RhdGEuDQo+ID4gPiA+ID4gDQo+
ID4gPiA+IA0KPiA+ID4gPiBZZWFoLCBtYXliZSB3aGF0IGlzIG5vdCBjbGVhciBoZXJlIGlzIHRo
YXQgd2UgY292ZXJpbmcgZm9yIHNpdHVhdGlvbg0KPiA+ID4gPiB3aGVyZSBjbG9jayBzdGFiaWxp
dHkgY2hhbmdlcyBvdmVyIHRpbWUsIGUuZy4gYXQgcmVndWxhciBib290IGNsb2NrIGlzDQo+ID4g
PiA+IHN0YWJsZSwgaGliZXJuYXRpb24gaGFwcGVucywgdGhlbiByZXN0b3JlIGhhcHBlbnMgaW4g
YSBub24tc3RhYmxlDQo+ID4gPiA+IGNsb2NrLg0KPiA+ID4gDQo+ID4gPiBTdGlsbCBjb25mdXNl
ZCwgd2hvIG1hcmtzIHRoZSB0aGluZyB1bnN0YWJsZT8gVGhlIHBhdGNoIHNlZW1zIHRvIHN1Z2dl
c3QNCj4gPiA+IHlvdSBkbyB5b3Vyc2VsZiwgYnV0IGl0IGlzIG5vdCBhdCBhbGwgY2xlYXIgd2h5
Lg0KPiA+ID4gDQo+ID4gPiBJZiBUU0MgcmVhbGx5IGlzIHVuc3RhYmxlLCB0aGVuIGl0IG5lZWRz
IHRvIHJlbWFpbiB1bnN0YWJsZS4gSWYgdGhlIFRTQw0KPiA+ID4gcmVhbGx5IGlzIHN0YWJsZSB0
aGVuIHRoZXJlIGlzIG5vIHBvaW50IGluIG1hcmtpbmcgaXMgdW5zdGFibGUuDQo+ID4gPiANCj4g
PiA+IEVpdGhlciB3YXkgc29tZXRoaW5nIGlzIG9mZiwgYW5kIHlvdSdyZSBub3QgdGVsbGluZyBt
ZSB3aGF0Lg0KPiA+ID4gDQo+ID4gDQo+ID4gSGksIFBldGVyDQo+ID4gDQo+ID4gRm9yIHlvdXIg
b3JpZ2luYWwgY29tbWVudCwganVzdCB3YW50ZWQgdG8gY2xhcmlmeSB0aGUgZm9sbG93aW5nOg0K
PiA+IA0KPiA+IDEuIEFmdGVyIGhpYmVybmF0aW9uLCB0aGUgbWFjaGluZSBjYW4gYmUgcmVzdW1l
ZCBvbiBhIGRpZmZlcmVudCBidXQNCj4gPiBjb21wYXRpYmxlDQo+ID4gaG9zdCAodGhlc2UgYXJl
IFZNIGltYWdlcyBoaWJlcm5hdGVkKQ0KPiA+IDIuIFRoaXMgbWVhbnMgdGhlIGNsb2NrIGJldHdl
ZW4gaG9zdDEgYW5kIGhvc3QyIGNhbi93aWxsIGJlIGRpZmZlcmVudA0KPiANCj4gVGhlIGd1ZXN0
cyBUU0MgdmFsdWUgaXMgcGFydCBvZiBhbGwgc2F2ZS9taWdyYXRlL3Jlc3VtZSBzdGF0ZS4gIEdp
dmVuDQo+IHRoaXMgYnVnLCBJIHByZXN1bWUgeW91J3ZlIGFjdHVhbGx5IGRpc2NhcmRlZCBhbGwg
cmVnaXN0ZXIgc3RhdGUgb24NCj4gaGliZXJuYXRlLCBhbmQgdGhlIFRTQyBpcyBzdGFydGluZyBh
Z2FpbiBmcm9tIDA/DQo+IA0KPiBUaGUgZnJlcXVlbmN5IG9mIHRoZSBuZXcgVFNDIG1pZ2h0IHZl
cnkgbGlrZWx5IGJlIGRpZmZlcmVudCwgYnV0IHRoZQ0KPiBzY2FsZS9vZmZzZXQgaW4gdGhlIHBh
cmF2aXJ0dWFsIGNsb2NrIGluZm9ybWF0aW9uIHNob3VsZCBsZXQgTGludXgncw0KPiB2aWV3IG9m
IHRpbWUgc3RheSBjb25zaXN0ZW50Lg0KPiANCg0KSSBhbSBsb29raW5nIGF0IG15IG9sZCBkbWVz
ZyBsb2dzLCB3aGljaCBJIHNlZW0gdG8gaGF2ZSBsb3N0IHRvIHJldmFsaWRhdGUsDQpidXQgSSB0
aGluayBFZHVhcmRvIGhhZCBhIGRpZmZlcmVudCBwb2ludC4gSSBzaG91bGQgcG9pbnQgb3V0IHRo
YXQgSSB3YXMNCmFkZGluZyB0byB0aGUgbGlzdCBvZiBwb3RlbnRpYWxseSBtaXNzZWQgYXNzdW1w
dGlvbnMNCg0KDQo+ID4gSW4geW91ciBjb21tZW50cyBhcmUgeW91IG1ha2luZyB0aGUgYXNzdW1w
dGlvbiB0aGF0IHRoZSBob3N0KHMpIGlzL2FyZSB0aGUNCj4gPiBzYW1lPyBKdXN0IGNoZWNraW5n
IHRoZSBhc3N1bXB0aW9ucyBiZWluZyBtYWRlIGFuZCBiZWluZyBvbiB0aGUgc2FtZSBwYWdlDQo+
ID4gd2l0aA0KPiA+IHRoZW0uDQo+IA0KPiBUU0NzIGFyZSBhIG1hc3NpdmUgc291cmNlIG9mICJm
dW4iLiAgSSdtIG5vdCBzdXJwcmlzZWQgdGhhdCB0aGVyZSBhcmUNCj4geWV0IG1vcmUgYnVncyBh
cm91bmQuDQo+IA0KPiBEb2VzIGFueW9uZSBhY3R1YWxseSBrbm93IHdoYXQgZG9lcy9zaG91bGQg
aGFwcGVuIHRvIHRoZSByZWFsIFRTQyBvbg0KPiBuYXRpdmUgUzQ/ICBUaGUgZGVmYXVsdCBjb3Vy
c2Ugb2YgYWN0aW9uIHNob3VsZCBiZSBmb3IgdmlydHVhbGlzYXRpb24gdG8NCj4gZm9sbG93IHN1
aXQuDQo+IA0KPiB+QW5kcmV3DQoNCkJhbGJpcg0K
