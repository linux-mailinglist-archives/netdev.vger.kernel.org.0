Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5AFB7166258
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 17:23:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728592AbgBTQXk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 11:23:40 -0500
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:19113 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728021AbgBTQXj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Feb 2020 11:23:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazon201209; t=1582215819; x=1613751819;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=q7XRRi3HKMMMG+6K6lvFjL22C6/9vW3zoXBjY/d4S5Q=;
  b=sd0gbYvmiLOKiQQ8/REt2BsCvuo/tbiXASkHAEteYtBSeDH6Jb3pYhWY
   myiQUfPSgKOiaAvR9O0rwWjXfbAspCyeQBVQY0Swm7PuilHOky4X4bOsz
   91lsJ3LbqZbL10Hcdz9pf+GoBvew0chlm+Sh72QmVEpKRP6FaEdoMFt+P
   s=;
IronPort-SDR: IyvgS/TeCH6kqLsEABTaw88mn4Uro6/KXeBktaHDxl9InT9/NxevNO/zoJ3EZRpN1HxYqBaWay
 UNbP9tBOVZVw==
X-IronPort-AV: E=Sophos;i="5.70,464,1574121600"; 
   d="scan'208";a="17344091"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1e-17c49630.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-6002.iad6.amazon.com with ESMTP; 20 Feb 2020 16:23:24 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1e-17c49630.us-east-1.amazon.com (Postfix) with ESMTPS id E566CA27FC;
        Thu, 20 Feb 2020 16:23:16 +0000 (UTC)
Received: from EX13D07UWB003.ant.amazon.com (10.43.161.66) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Thu, 20 Feb 2020 16:23:16 +0000
Received: from EX13D32EUC003.ant.amazon.com (10.43.164.24) by
 EX13D07UWB003.ant.amazon.com (10.43.161.66) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 20 Feb 2020 16:23:15 +0000
Received: from EX13D32EUC003.ant.amazon.com ([10.43.164.24]) by
 EX13D32EUC003.ant.amazon.com ([10.43.164.24]) with mapi id 15.00.1367.000;
 Thu, 20 Feb 2020 16:23:14 +0000
From:   "Durrant, Paul" <pdurrant@amazon.co.uk>
To:     =?utf-8?B?Um9nZXIgUGF1IE1vbm7DqQ==?= <roger.pau@citrix.com>
CC:     "Agarwal, Anchal" <anchalag@amazon.com>,
        "Valentin, Eduardo" <eduval@amazon.com>,
        "len.brown@intel.com" <len.brown@intel.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "pavel@ucw.cz" <pavel@ucw.cz>, "hpa@zytor.com" <hpa@zytor.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "sstabellini@kernel.org" <sstabellini@kernel.org>,
        "fllinden@amaozn.com" <fllinden@amaozn.com>,
        "Kamata, Munehisa" <kamatam@amazon.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        "Singh, Balbir" <sblbir@amazon.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "boris.ostrovsky@oracle.com" <boris.ostrovsky@oracle.com>,
        "jgross@suse.com" <jgross@suse.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Woodhouse, David" <dwmw@amazon.co.uk>
Subject: RE: [Xen-devel] [RFC PATCH v3 06/12] xen-blkfront: add callbacks for
 PM suspend and hibernation
Thread-Topic: [Xen-devel] [RFC PATCH v3 06/12] xen-blkfront: add callbacks for
 PM suspend and hibernation
Thread-Index: AQHV446AUecZloiSDUiowKQxKdi9t6gfLFuAgADaIoCAAKqFgIACJekAgAD0YQCAAAHOgIAAdTyAgAAHU1A=
Date:   Thu, 20 Feb 2020 16:23:13 +0000
Message-ID: <c9662397256a4568a5cc7d70a84940e5@EX13D32EUC003.ant.amazon.com>
References: <cover.1581721799.git.anchalag@amazon.com>
 <890c404c585d7790514527f0c021056a7be6e748.1581721799.git.anchalag@amazon.com>
 <20200217100509.GE4679@Air-de-Roger>
 <20200217230553.GA8100@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
 <20200218091611.GN4679@Air-de-Roger>
 <20200219180424.GA17584@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
 <20200220083904.GI4679@Air-de-Roger>
 <f986b845491b47cc8469d88e2e65e2a7@EX13D32EUC003.ant.amazon.com>
 <20200220154507.GO4679@Air-de-Roger>
In-Reply-To: <20200220154507.GO4679@Air-de-Roger>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.165.155]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBSb2dlciBQYXUgTW9ubsOpIDxy
b2dlci5wYXVAY2l0cml4LmNvbT4NCj4gU2VudDogMjAgRmVicnVhcnkgMjAyMCAxNTo0NQ0KPiBU
bzogRHVycmFudCwgUGF1bCA8cGR1cnJhbnRAYW1hem9uLmNvLnVrPg0KPiBDYzogQWdhcndhbCwg
QW5jaGFsIDxhbmNoYWxhZ0BhbWF6b24uY29tPjsgVmFsZW50aW4sIEVkdWFyZG8NCj4gPGVkdXZh
bEBhbWF6b24uY29tPjsgbGVuLmJyb3duQGludGVsLmNvbTsgcGV0ZXJ6QGluZnJhZGVhZC5vcmc7
DQo+IGJlbmhAa2VybmVsLmNyYXNoaW5nLm9yZzsgeDg2QGtlcm5lbC5vcmc7IGxpbnV4LW1tQGt2
YWNrLm9yZzsNCj4gcGF2ZWxAdWN3LmN6OyBocGFAenl0b3IuY29tOyB0Z2x4QGxpbnV0cm9uaXgu
ZGU7IHNzdGFiZWxsaW5pQGtlcm5lbC5vcmc7DQo+IGZsbGluZGVuQGFtYW96bi5jb207IEthbWF0
YSwgTXVuZWhpc2EgPGthbWF0YW1AYW1hem9uLmNvbT47DQo+IG1pbmdvQHJlZGhhdC5jb207IHhl
bi1kZXZlbEBsaXN0cy54ZW5wcm9qZWN0Lm9yZzsgU2luZ2gsIEJhbGJpcg0KPiA8c2JsYmlyQGFt
YXpvbi5jb20+OyBheGJvZUBrZXJuZWwuZGs7IGtvbnJhZC53aWxrQG9yYWNsZS5jb207DQo+IGJw
QGFsaWVuOC5kZTsgYm9yaXMub3N0cm92c2t5QG9yYWNsZS5jb207IGpncm9zc0BzdXNlLmNvbTsN
Cj4gbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsgbGludXgtcG1Admdlci5rZXJuZWwub3JnOyByandA
cmp3eXNvY2tpLm5ldDsNCj4gbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZzsgdmt1em5ldHNA
cmVkaGF0LmNvbTsgZGF2ZW1AZGF2ZW1sb2Z0Lm5ldDsNCj4gV29vZGhvdXNlLCBEYXZpZCA8ZHdt
d0BhbWF6b24uY28udWs+DQo+IFN1YmplY3Q6IFJlOiBbWGVuLWRldmVsXSBbUkZDIFBBVENIIHYz
IDA2LzEyXSB4ZW4tYmxrZnJvbnQ6IGFkZCBjYWxsYmFja3MNCj4gZm9yIFBNIHN1c3BlbmQgYW5k
IGhpYmVybmF0aW9uDQo+IA0KPiBPbiBUaHUsIEZlYiAyMCwgMjAyMCBhdCAwODo1NDozNkFNICsw
MDAwLCBEdXJyYW50LCBQYXVsIHdyb3RlOg0KPiA+ID4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0t
LS0NCj4gPiA+IEZyb206IFhlbi1kZXZlbCA8eGVuLWRldmVsLWJvdW5jZXNAbGlzdHMueGVucHJv
amVjdC5vcmc+IE9uIEJlaGFsZiBPZg0KPiA+ID4gUm9nZXIgUGF1IE1vbm7DqQ0KPiA+ID4gU2Vu
dDogMjAgRmVicnVhcnkgMjAyMCAwODozOQ0KPiA+ID4gVG86IEFnYXJ3YWwsIEFuY2hhbCA8YW5j
aGFsYWdAYW1hem9uLmNvbT4NCj4gPiA+IENjOiBWYWxlbnRpbiwgRWR1YXJkbyA8ZWR1dmFsQGFt
YXpvbi5jb20+OyBsZW4uYnJvd25AaW50ZWwuY29tOw0KPiA+ID4gcGV0ZXJ6QGluZnJhZGVhZC5v
cmc7IGJlbmhAa2VybmVsLmNyYXNoaW5nLm9yZzsgeDg2QGtlcm5lbC5vcmc7IGxpbnV4LQ0KPiA+
ID4gbW1Aa3ZhY2sub3JnOyBwYXZlbEB1Y3cuY3o7IGhwYUB6eXRvci5jb207IHRnbHhAbGludXRy
b25peC5kZTsNCj4gPiA+IHNzdGFiZWxsaW5pQGtlcm5lbC5vcmc7IGZsbGluZGVuQGFtYW96bi5j
b207IEthbWF0YSwgTXVuZWhpc2ENCj4gPiA+IDxrYW1hdGFtQGFtYXpvbi5jb20+OyBtaW5nb0By
ZWRoYXQuY29tOyB4ZW4tDQo+IGRldmVsQGxpc3RzLnhlbnByb2plY3Qub3JnOw0KPiA+ID4gU2lu
Z2gsIEJhbGJpciA8c2JsYmlyQGFtYXpvbi5jb20+OyBheGJvZUBrZXJuZWwuZGs7DQo+ID4gPiBr
b25yYWQud2lsa0BvcmFjbGUuY29tOyBicEBhbGllbjguZGU7IGJvcmlzLm9zdHJvdnNreUBvcmFj
bGUuY29tOw0KPiA+ID4gamdyb3NzQHN1c2UuY29tOyBuZXRkZXZAdmdlci5rZXJuZWwub3JnOyBs
aW51eC1wbUB2Z2VyLmtlcm5lbC5vcmc7DQo+ID4gPiByandAcmp3eXNvY2tpLm5ldDsgbGludXgt
a2VybmVsQHZnZXIua2VybmVsLm9yZzsgdmt1em5ldHNAcmVkaGF0LmNvbTsNCj4gPiA+IGRhdmVt
QGRhdmVtbG9mdC5uZXQ7IFdvb2Rob3VzZSwgRGF2aWQgPGR3bXdAYW1hem9uLmNvLnVrPg0KPiA+
ID4gU3ViamVjdDogUmU6IFtYZW4tZGV2ZWxdIFtSRkMgUEFUQ0ggdjMgMDYvMTJdIHhlbi1ibGtm
cm9udDogYWRkDQo+IGNhbGxiYWNrcw0KPiA+ID4gZm9yIFBNIHN1c3BlbmQgYW5kIGhpYmVybmF0
aW9uDQo+ID4gPg0KPiA+ID4gVGhhbmtzIGZvciB0aGlzIHdvcmssIHBsZWFzZSBzZWUgYmVsb3cu
DQo+ID4gPg0KPiA+ID4gT24gV2VkLCBGZWIgMTksIDIwMjAgYXQgMDY6MDQ6MjRQTSArMDAwMCwg
QW5jaGFsIEFnYXJ3YWwgd3JvdGU6DQo+ID4gPiA+IE9uIFR1ZSwgRmViIDE4LCAyMDIwIGF0IDEw
OjE2OjExQU0gKzAxMDAsIFJvZ2VyIFBhdSBNb25uw6kgd3JvdGU6DQo+ID4gPiA+ID4gT24gTW9u
LCBGZWIgMTcsIDIwMjAgYXQgMTE6MDU6NTNQTSArMDAwMCwgQW5jaGFsIEFnYXJ3YWwgd3JvdGU6
DQo+ID4gPiA+ID4gPiBPbiBNb24sIEZlYiAxNywgMjAyMCBhdCAxMTowNTowOUFNICswMTAwLCBS
b2dlciBQYXUgTW9ubsOpIHdyb3RlOg0KPiA+ID4gPiA+ID4gPiBPbiBGcmksIEZlYiAxNCwgMjAy
MCBhdCAxMToyNTozNFBNICswMDAwLCBBbmNoYWwgQWdhcndhbA0KPiB3cm90ZToNCj4gPiA+ID4g
PiA+IFF1aWVzY2luZyB0aGUgcXVldWUgc2VlbWVkIGEgYmV0dGVyIG9wdGlvbiBoZXJlIGFzIHdl
IHdhbnQgdG8NCj4gbWFrZQ0KPiA+ID4gc3VyZSBvbmdvaW5nDQo+ID4gPiA+ID4gPiByZXF1ZXN0
cyBkaXNwYXRjaGVzIGFyZSB0b3RhbGx5IGRyYWluZWQuDQo+ID4gPiA+ID4gPiBJIHNob3VsZCBh
Y2NlcHQgdGhhdCBzb21lIG9mIHRoZXNlIG5vdGlvbiBpcyBib3Jyb3dlZCBmcm9tIGhvdw0KPiBu
dm1lDQo+ID4gPiBmcmVlemUvdW5mcmVlemUNCj4gPiA+ID4gPiA+IGlzIGRvbmUgYWx0aG91Z2gg
aXRzIG5vdCBhcHBsZSB0byBhcHBsZSBjb21wYXJpc29uLg0KPiA+ID4gPiA+DQo+ID4gPiA+ID4g
VGhhdCdzIGZpbmUsIGJ1dCBJIHdvdWxkIHN0aWxsIGxpa2UgdG8gcmVxdWVzdHMgdGhhdCB5b3Ug
dXNlIHRoZQ0KPiBzYW1lDQo+ID4gPiA+ID4gbG9naWMgKGFzIG11Y2ggYXMgcG9zc2libGUpIGZv
ciBib3RoIHRoZSBYZW4gYW5kIHRoZSBQTSBpbml0aWF0ZWQNCj4gPiA+ID4gPiBzdXNwZW5zaW9u
Lg0KPiA+ID4gPiA+DQo+ID4gPiA+ID4gU28geW91IGVpdGhlciBhcHBseSB0aGlzIGZyZWV6ZS91
bmZyZWV6ZSB0byB0aGUgWGVuIHN1c3BlbnNpb24NCj4gKGFuZA0KPiA+ID4gPiA+IGRyb3AgdGhl
IHJlLWlzc3Vpbmcgb2YgcmVxdWVzdHMgb24gcmVzdW1lKSBvciBhZGFwdCB0aGUgc2FtZQ0KPiBh
cHByb2FjaA0KPiA+ID4gPiA+IGFzIHRoZSBYZW4gaW5pdGlhdGVkIHN1c3BlbnNpb24uIEtlZXBp
bmcgdHdvIGNvbXBsZXRlbHkgZGlmZmVyZW50DQo+ID4gPiA+ID4gYXBwcm9hY2hlcyB0byBzdXNw
ZW5zaW9uIC8gcmVzdW1lIG9uIGJsa2Zyb250IGlzIG5vdCBzdWl0YWJsZSBsb25nDQo+ID4gPiA+
ID4gdGVybS4NCj4gPiA+ID4gPg0KPiA+ID4gPiBJIGFncmVlIHdpdGggeW91IG9uIG92ZXJoYXVs
IG9mIHhlbiBzdXNwZW5kL3Jlc3VtZSB3cnQgYmxrZnJvbnQgaXMgYQ0KPiA+ID4gZ29vZA0KPiA+
ID4gPiBpZGVhIGhvd2V2ZXIsIElNTyB0aGF0IGlzIGEgd29yayBmb3IgZnV0dXJlIGFuZCB0aGlz
IHBhdGNoIHNlcmllcw0KPiBzaG91bGQNCj4gPiA+ID4gbm90IGJlIGJsb2NrZWQgZm9yIGl0LiBX
aGF0IGRvIHlvdSB0aGluaz8NCj4gPiA+DQo+ID4gPiBJdCdzIG5vdCBzbyBtdWNoIHRoYXQgSSB0
aGluayBhbiBvdmVyaGF1bCBvZiBzdXNwZW5kL3Jlc3VtZSBpbg0KPiA+ID4gYmxrZnJvbnQgaXMg
bmVlZGVkLCBpdCdzIGp1c3QgdGhhdCBJIGRvbid0IHdhbnQgdG8gaGF2ZSB0d28gY29tcGxldGVs
eQ0KPiA+ID4gZGlmZmVyZW50IHN1c3BlbmQvcmVzdW1lIHBhdGhzIGluc2lkZSBibGtmcm9udC4N
Cj4gPiA+DQo+ID4gPiBTbyBmcm9tIG15IFBvViBJIHRoaW5rIHRoZSByaWdodCBzb2x1dGlvbiBp
cyB0byBlaXRoZXIgdXNlIHRoZSBzYW1lDQo+ID4gPiBjb2RlIChhcyBtdWNoIGFzIHBvc3NpYmxl
KSBhcyBpdCdzIGN1cnJlbnRseSB1c2VkIGJ5IFhlbiBpbml0aWF0ZWQNCj4gPiA+IHN1c3BlbmQv
cmVzdW1lLCBvciB0byBhbHNvIHN3aXRjaCBYZW4gaW5pdGlhdGVkIHN1c3BlbnNpb24gdG8gdXNl
IHRoZQ0KPiA+ID4gbmV3bHkgaW50cm9kdWNlZCBjb2RlLg0KPiA+ID4NCj4gPiA+IEhhdmluZyB0
d28gZGlmZmVyZW50IGFwcHJvYWNoZXMgdG8gc3VzcGVuZC9yZXN1bWUgaW4gdGhlIHNhbWUgZHJp
dmVyDQo+ID4gPiBpcyBhIHJlY2lwZSBmb3IgZGlzYXN0ZXIgSU1POiBpdCBhZGRzIGNvbXBsZXhp
dHkgYnkgZm9yY2luZyBkZXZlbG9wZXJzDQo+ID4gPiB0byB0YWtlIGludG8gYWNjb3VudCB0d28g
ZGlmZmVyZW50IHN1c3BlbmQvcmVzdW1lIGFwcHJvYWNoZXMgd2hlbg0KPiA+ID4gdGhlcmUncyBu
byBuZWVkIGZvciBpdC4NCj4gPg0KPiA+IEkgZGlzYWdyZWUuIFMzIG9yIFM0IHN1c3BlbmQvcmVz
dW1lIChvciBwZXJoYXBzIHdlIHNob3VsZCBjYWxsIHRoZW0NCj4gcG93ZXIgc3RhdGUgdHJhbnNp
dGlvbnMgdG8gYXZvaWQgY29uZnVzaW9uKSBhcmUgcXVpdGUgZGlmZmVyZW50IGZyb20gWGVuDQo+
IHN1c3BlbmQvcmVzdW1lLg0KPiA+IFBvd2VyIHN0YXRlIHRyYW5zaXRpb25zIG91Z2h0IHRvIGJl
LCBhbmQgaW5kZWVkIGFyZSwgdmlzaWJsZSB0byB0aGUNCj4gc29mdHdhcmUgcnVubmluZyBpbnNp
ZGUgdGhlIGd1ZXN0LiBBcHBsaWNhdGlvbnMsIGFzIHdlbGwgYXMgZHJpdmVycywgY2FuDQo+IHJl
Y2VpdmUgbm90aWZpY2F0aW9uIGFuZCB0YWtlIHdoYXRldmVyIGFjdGlvbiB0aGV5IGRlZW0gYXBw
cm9wcmlhdGUuDQo+ID4gWGVuIHN1c3BlbmQvcmVzdW1lIE9UT0ggaXMgdXNlZCB3aGVuIGEgZ3Vl
c3QgaXMgbWlncmF0ZWQgYW5kIHRoZSBjb2RlDQo+IHNob3VsZCBnbyB0byBhbGwgbGVuZ3RocyBw
b3NzaWJsZSB0byBtYWtlIGFueSBzb2Z0d2FyZSBydW5uaW5nIGluc2lkZSB0aGUNCj4gZ3Vlc3Qg
KG90aGVyIHRoYW4gWGVuIHNwZWNpZmljIGVubGlnaHRlbmVkIGNvZGUsIHN1Y2ggYXMgUFYgZHJp
dmVycykNCj4gY29tcGxldGVseSB1bmF3YXJlIHRoYXQgYW55dGhpbmcgaGFzIGFjdHVhbGx5IGhh
cHBlbmVkLg0KPiANCj4gU28gZnJvbSB3aGF0IHlvdSBzYXkgYWJvdmUgUE0gc3RhdGUgdHJhbnNp
dGlvbnMgYXJlIG5vdGlmaWVkIHRvIGFsbA0KPiBkcml2ZXJzLCBhbmQgWGVuIHN1c3BlbmQvcmVz
dW1lIGlzIG9ubHkgbm90aWZpZWQgdG8gUFYgZHJpdmVycywgYW5kDQo+IGhlcmUgd2UgYXJlIHNw
ZWFraW5nIGFib3V0IGJsa2Zyb250IHdoaWNoIGlzIGEgUFYgZHJpdmVyLCBhbmQgc2hvdWxkDQo+
IGdldCBub3RpZmllZCBpbiBib3RoIGNhc2VzLiBTbyBJJ20gdW5zdXJlIHdoeSB0aGUgc2FtZSAo
b3IgYXQgbGVhc3QNCj4gdmVyeSBzaW1pbGFyKSBhcHByb2FjaCBjYW4ndCBiZSB1c2VkIGluIGJv
dGggY2FzZXMuDQo+IA0KPiBUaGUgc3VzcGVuZC9yZXN1bWUgYXBwcm9hY2ggcHJvcG9zZWQgYnkg
dGhpcyBwYXRjaCBpcyBjb21wbGV0ZWx5DQo+IGRpZmZlcmVudCB0aGFuIHRoZSBvbmUgdXNlZCBi
eSBhIHhlbmJ1cyBpbml0aWF0ZWQgc3VzcGVuZC9yZXN1bWUsIGFuZA0KPiBJIGRvbid0IHNlZSBh
IHRlY2huaWNhbCByZWFzb24gdGhhdCB3YXJyYW50cyB0aGlzIGRpZmZlcmVuY2UuDQo+DQoNCldp
dGhpbiBhbiBpbmRpdmlkdWFsIFBWIGRyaXZlciBpdCBtYXkgd2VsbCBiZSBvayB0byB1c2UgY29t
bW9uIG1lY2hhbmlzbXMgZm9yIGNvbm5lY3RpbmcgdG8gdGhlIGJhY2tlbmQgYnV0IGlzc3VlcyB3
aWxsIGFyaXNlIGlmIGFueSBzdWJzZXF1ZW50IGFjdGlvbiBpcyB2aXNpYmxlIHRvIHRoZSBndWVz
dC4gRS5nLiBhIG5ldHdvcmsgZnJvbnRlbmQgbmVlZHMgdG8gaXNzdWUgZ3JhdHVpdG91cyBBUlBz
IHdpdGhvdXQgYW55dGhpbmcgZWxzZSBpbiB0aGUgbmV0d29yayBzdGFjayAob3IgbW9uaXRvcmlu
ZyB0aGUgbmV0d29yayBzdGFjaykga25vd2luZyB0aGF0IGl0IGhhcyBoYXBwZW5lZC4gDQogDQo+
IEknbSBub3Qgc2F5aW5nIHRoYXQgdGhlIGFwcHJvYWNoIHVzZWQgaGVyZSBpcyB3cm9uZywgaXQn
cyBqdXN0IHRoYXQgSQ0KPiBkb24ndCBzZWUgdGhlIHBvaW50IGluIGhhdmluZyB0d28gZGlmZmVy
ZW50IHdheXMgdG8gZG8gc3VzcGVuZC9yZXN1bWUNCj4gaW4gdGhlIHNhbWUgZHJpdmVyLCB1bmxl
c3MgdGhlcmUncyBhIHRlY2huaWNhbCByZWFzb24gZm9yIGl0LCB3aGljaCBJDQo+IGRvbid0IHRo
aW5rIGhhcyBiZWVuIHByb3ZpZGVkLg0KDQpUaGUgdGVjaG5pY2FsIGp1c3RpZmljYXRpb24gaXMg
dGhhdCB0aGUgZHJpdmVyIG5lZWRzIHRvIGtub3cgd2hhdCBraW5kIG9mIHN1c3BlbmQgb3IgcmVz
dW1lIGl0IGlzIGRvaW5nLCBzbyB0aGF0IGl0IGRvZXNuJ3QgZG8gdGhlIHdyb25nIHRoaW5nLiBU
aGVyZSBtYXkgYWxzbyBiZSBkaWZmZXJlbmNlcyBpbiB0aGUgc3RhdGUgb2YgdGhlIHN5c3RlbSBl
LmcuIGluIFdpbmRvd3MsIGF0IGxlYXN0IHNvbWUgb2YgdGhlIHJlc3VtZS1mcm9tLXhlbi1zdXNw
ZW5kIGNvZGUgcnVucyB3aXRoIGludGVycnVwdHMgZGlzYWJsZWQgKHdoaWNoIGlzIG5lY2Vzc2Fy
eSB0byBtYWtlIHN1cmUgZW5vdWdoIHN0YXRlIGlzIHJlc3RvcmVkIGJlZm9yZSB0aGluZ3MgYmVj
b21lIHZpc2libGUgdG8gb3RoZXIga2VybmVsIGNvZGUpLg0KDQo+IA0KPiBJIHdvdWxkIGJlIGZp
bmUgd2l0aCBzd2l0Y2hpbmcgeGVuYnVzIGluaXRpYXRlZCBzdXNwZW5kL3Jlc3VtZSB0byBhbHNv
DQo+IHVzZSB0aGUgYXBwcm9hY2ggcHJvcG9zZWQgaGVyZTogZnJlZXplIHRoZSBxdWV1ZXMgYW5k
IGRyYWluIHRoZSBzaGFyZWQNCj4gcmluZ3MgYmVmb3JlIHN1c3BlbmRpbmcuDQo+IA0KDQpJIHRo
aW5rIGFic3RyYWN0aW5nIGF3YXkgYXQgdGhlIHhlbmJ1cyBsZXZlbCB0byBzb21lIGRlZ3JlZSBp
cyBwcm9iYWJseSBmZWFzaWJsZSwgYnV0IHNvbWUgc29ydCBvZiBmbGFnIHNob3VsZCBiZSBwYXNz
ZWQgdG8gdGhlIGluZGl2aWR1YWwgZHJpdmVycyBzbyB0aGV5IGtub3cgd2hhdCBjaXJjdW1zdGFu
Y2VzIHRoZXkgYXJlIG9wZXJhdGluZyB1bmRlci4NCg0KPiA+IFNvLCB3aGlsc3QgaXQgbWF5IGJl
IHBvc3NpYmxlIHRvIHVzZSBjb21tb24gcm91dGluZXMgdG8sIGZvciBleGFtcGxlLA0KPiByZS1l
c3RhYmxpc2ggUFYgZnJvbnRlbmQvYmFja2VuZCBjb21tdW5pY2F0aW9uLCBQViBmcm9udGVuZCBj
b2RlIHNob3VsZCBiZQ0KPiBhY3V0ZWx5IGF3YXJlIG9mIHRoZSBjaXJjdW1zdGFuY2VzIHRoZXkg
YXJlIG9wZXJhdGluZyBpbi4gSSBjYW4gY2l0ZQ0KPiBleGFtcGxlIGNvZGUgaW4gdGhlIFdpbmRv
d3MgUFYgZHJpdmVyLCB3aGljaCBoYXZlIHN1cHBvcnRlZCBndWVzdCBTMy9TNA0KPiBwb3dlciBz
dGF0ZSB0cmFuc2l0aW9ucyBzaW5jZSBkYXkgMS4NCj4gDQo+IEhtLCBwbGVhc2UgYmVhciB3aXRo
IG1lLCBhcyBJJ20gbm90IHN1cmUgSSBmdWxseSB1bmRlcnN0YW5kLiBXaHkgaXNuJ3QNCj4gdGhl
IGN1cnJlbnQgc3VzcGVuZC9yZXN1bWUgbG9naWMgc3VpdGFibGUgZm9yIFBNIHRyYW5zaXRpb25z
Pw0KPiANCg0KSSBkb27igJl0IGtub3cgdGhlIGRldGFpbHMgZm9yIExpbnV4IGJ1dCBpdCBtYXkg
d2VsbCBiZSB0byBkbyB3aXRoIGFzc3VtcHRpb25zIG1hZGUgYWJvdXQgdGhlIHN5c3RlbSBlLmcu
IHRoZSBhYmlsaXR5IHRvIGJsb2NrIHdhaXRpbmcgZm9yIHNvbWV0aGluZyB0byBoYXBwZW4gb24g
YW5vdGhlciBDUFUgKHdoaWNoIG1heSBoYXZlIGFscmVhZHkgYmVlbiBxdWllc2NlZCBpbiBhIFBN
IGNvbnRleHQpLg0KDQo+IEFzIHNhaWQgYWJvdmUsIEknbSBoYXBweSB0byBzd2l0Y2ggeGVuYnVz
IGluaXRpYXRlZCBzdXNwZW5kL3Jlc3VtZSB0bw0KPiB1c2UgdGhlIGxvZ2ljIGluIHRoaXMgcGF0
Y2gsIGJ1dCB1bmxlc3MgdGhlcmUncyBhIHRlY2huaWNhbCByZWFzb24gZm9yDQo+IGl0IEkgZG9u
J3Qgc2VlIHdoeSBibGtmcm9udCBzaG91bGQgaGF2ZSB0d28gY29tcGxldGVseSBkaWZmZXJlbnQN
Cj4gYXBwcm9hY2hlcyB0byBzdXNwZW5kL3Jlc3VtZSBkZXBlbmRpbmcgb24gd2hldGhlciBpdCdz
IGEgUE0gb3IgYQ0KPiB4ZW5idXMgc3RhdGUgY2hhbmdlLg0KPiANCg0KSG9wZWZ1bGx5IHdoYXQg
SSBzYWlkIGFib3ZlIGlsbHVzdHJhdGVzIHdoeSBpdCBtYXkgbm90IGJlIDEwMCUgY29tbW9uLg0K
DQogIFBhdWwNCg0K
