Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BDE1F167A0C
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 10:57:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728591AbgBUJ5O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Feb 2020 04:57:14 -0500
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:29217 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728075AbgBUJ5N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Feb 2020 04:57:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazon201209; t=1582279033; x=1613815033;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=e4QQfY4+kh4/5c0M4CxyYRoWkV+vVtnx2zkOMh3EI50=;
  b=J0V7r8oR8DBAQaA/gEkA8Je/2uO2BUpmeSLGdbGRvBAATFl0w31DCNOh
   K86R2EMvh/qlZ8YmWz2zSjy1cH2WZvOI6YNfBLbm5fnwo3APE/Vfo+Ejx
   8WndnwCC0i27T8AWHMY8kmSe1bu5BfgW+5JS/yKwo/AVrCJV7KFxF3VAT
   Q=;
IronPort-SDR: HuQ9cSFHeNKk7dCI11cVnq1lonnC570Q+PYoUh6O5AdSOjhkfL8Kl6ED/gcJt/hqZdNNUI/R86
 RKhbBseMiGsg==
X-IronPort-AV: E=Sophos;i="5.70,467,1574121600"; 
   d="scan'208";a="19014899"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2c-87a10be6.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-6001.iad6.amazon.com with ESMTP; 21 Feb 2020 09:56:59 +0000
Received: from EX13MTAUWA001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2c-87a10be6.us-west-2.amazon.com (Postfix) with ESMTPS id 14380A21DF;
        Fri, 21 Feb 2020 09:56:57 +0000 (UTC)
Received: from EX13D07UWA004.ant.amazon.com (10.43.160.32) by
 EX13MTAUWA001.ant.amazon.com (10.43.160.118) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Fri, 21 Feb 2020 09:56:56 +0000
Received: from EX13D32EUC003.ant.amazon.com (10.43.164.24) by
 EX13D07UWA004.ant.amazon.com (10.43.160.32) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 21 Feb 2020 09:56:55 +0000
Received: from EX13D32EUC003.ant.amazon.com ([10.43.164.24]) by
 EX13D32EUC003.ant.amazon.com ([10.43.164.24]) with mapi id 15.00.1367.000;
 Fri, 21 Feb 2020 09:56:54 +0000
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
Thread-Index: AQHV446AUecZloiSDUiowKQxKdi9t6gfLFuAgADaIoCAAKqFgIACJekAgAD0YQCAAAHOgIAAdTyAgAAHU1CAAAptgIAAAgSwgAETnYCAAAiO8A==
Date:   Fri, 21 Feb 2020 09:56:54 +0000
Message-ID: <5ddf980a3fba4fb39571184e688cefc5@EX13D32EUC003.ant.amazon.com>
References: <20200217100509.GE4679@Air-de-Roger>
 <20200217230553.GA8100@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
 <20200218091611.GN4679@Air-de-Roger>
 <20200219180424.GA17584@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
 <20200220083904.GI4679@Air-de-Roger>
 <f986b845491b47cc8469d88e2e65e2a7@EX13D32EUC003.ant.amazon.com>
 <20200220154507.GO4679@Air-de-Roger>
 <c9662397256a4568a5cc7d70a84940e5@EX13D32EUC003.ant.amazon.com>
 <20200220164839.GR4679@Air-de-Roger>
 <e42fa35800f04b6f953e4af87f2c1a02@EX13D32EUC003.ant.amazon.com>
 <20200221092219.GU4679@Air-de-Roger>
In-Reply-To: <20200221092219.GU4679@Air-de-Roger>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.166.171]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBSb2dlciBQYXUgTW9ubsOpIDxy
b2dlci5wYXVAY2l0cml4LmNvbT4NCj4gU2VudDogMjEgRmVicnVhcnkgMjAyMCAwOToyMg0KPiBU
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
IGhpYmVybmF0aW9uDQo+IA0KPiBPbiBUaHUsIEZlYiAyMCwgMjAyMCBhdCAwNTowMTo1MlBNICsw
MDAwLCBEdXJyYW50LCBQYXVsIHdyb3RlOg0KPiA+ID4gPiBIb3BlZnVsbHkgd2hhdCBJIHNhaWQg
YWJvdmUgaWxsdXN0cmF0ZXMgd2h5IGl0IG1heSBub3QgYmUgMTAwJQ0KPiBjb21tb24uDQo+ID4g
Pg0KPiA+ID4gWWVzLCB0aGF0J3MgZmluZS4gSSBkb24ndCBleHBlY3QgaXQgdG8gYmUgMTAwJSBj
b21tb24gKGFzIEkgZ3Vlc3MNCj4gPiA+IHRoYXQgdGhlIGhvb2tzIHdpbGwgaGF2ZSBkaWZmZXJl
bnQgcHJvdG90eXBlcyksIGJ1dCBJIGV4cGVjdA0KPiA+ID4gdGhhdCByb3V0aW5lcyBjYW4gYmUg
c2hhcmVkLCBhbmQgdGhhdCB0aGUgYXBwcm9hY2ggdGFrZW4gY2FuIGJlIHRoZQ0KPiA+ID4gc2Ft
ZS4NCj4gPiA+DQo+ID4gPiBGb3IgZXhhbXBsZSBvbmUgbmVjZXNzYXJ5IGRpZmZlcmVuY2Ugd2ls
bCBiZSB0aGF0IHhlbmJ1cyBpbml0aWF0ZWQNCj4gPiA+IHN1c3BlbmQgd29uJ3QgY2xvc2UgdGhl
IFBWIGNvbm5lY3Rpb24sIGluIGNhc2Ugc3VzcGVuc2lvbiBmYWlscy4gT24gUE0NCj4gPiA+IHN1
c3BlbmQgeW91IHNlZW0gdG8gYWx3YXlzIGNsb3NlIHRoZSBjb25uZWN0aW9uIGJlZm9yZWhhbmQs
IHNvIHlvdQ0KPiA+ID4gd2lsbCBhbHdheXMgaGF2ZSB0byByZS1uZWdvdGlhdGUgb24gcmVzdW1l
IGV2ZW4gaWYgc3VzcGVuc2lvbiBmYWlsZWQuDQo+ID4gPg0KPiA+ID4gV2hhdCBJJ20gbW9zdGx5
IHdvcnJpZWQgYWJvdXQgaXMgdGhlIGRpZmZlcmVudCBhcHByb2FjaCB0byByaW5nDQo+ID4gPiBk
cmFpbmluZy4gSWU6IGVpdGhlciB4ZW5idXMgaXMgY2hhbmdlZCB0byBmcmVlemUgdGhlIHF1ZXVl
cyBhbmQgZHJhaW4NCj4gPiA+IHRoZSBzaGFyZWQgcmluZ3MsIG9yIFBNIHVzZXMgdGhlIGFscmVh
ZHkgZXhpc3RpbmcgbG9naWMgb2Ygbm90DQo+ID4gPiBmbHVzaGluZyB0aGUgcmluZ3MgYW4gcmUt
aXNzdWluZyBpbi1mbGlnaHQgcmVxdWVzdHMgb24gcmVzdW1lLg0KPiA+ID4NCj4gPg0KPiA+IFll
cywgdGhhdCdzIG5lZWRzIGNvbnNpZGVyYXRpb24uIEkgZG9u4oCZdCB0aGluayB0aGUgc2FtZSBz
ZW1hbnRpYyBjYW4gYmUNCj4gc3VpdGFibGUgZm9yIGJvdGguIEUuZy4gaW4gYSB4ZW4tc3VzcGVu
ZCB3ZSBuZWVkIHRvIGZyZWV6ZSB3aXRoIGFzIGxpdHRsZQ0KPiBwcm9jZXNzaW5nIGFzIHBvc3Np
YmxlIHRvIGF2b2lkIGRpcnR5aW5nIFJBTSBsYXRlIGluIHRoZSBtaWdyYXRpb24gY3ljbGUsDQo+
IGFuZCB3ZSBrbm93IHRoYXQgaW4tZmxpZ2h0IGRhdGEgY2FuIHdhaXQuIEJ1dCBpbiBhIHRyYW5z
aXRpb24gdG8gUzQgd2UNCj4gbmVlZCB0byBtYWtlIHN1cmUgdGhhdCBhdCBsZWFzdCBhbGwgdGhl
IGluLWZsaWdodCBibGtpZiByZXF1ZXN0cyBnZXQNCj4gY29tcGxldGVkLCBzaW5jZSB0aGV5IHBy
b2JhYmx5IGNvbnRhaW4gYml0cyBvZiB0aGUgZ3Vlc3QncyBtZW1vcnkgaW1hZ2UNCj4gYW5kIHRo
YXQncyBub3QgZ29pbmcgdG8gZ2V0IHNhdmVkIGFueSBvdGhlciB3YXkuDQo+IA0KPiBUaGFua3Ms
IHRoYXQgbWFrZXMgc2Vuc2UgYW5kIHNvbWV0aGluZyBhbG9uZyB0aGlzIGxpbmVzIHNob3VsZCBi
ZQ0KPiBhZGRlZCB0byB0aGUgY29tbWl0IG1lc3NhZ2UgSU1PLg0KPiANCj4gV29uZGVyaW5nIGFi
b3V0IFM0LCBzaG91bGRuJ3Qgd2UgZXhwZWN0IHRoZSBxdWV1ZXMgdG8gYWxyZWFkeSBiZQ0KPiBl
bXB0eT8gQXMgYW55IHN1YnN5c3RlbSB0aGF0IHdhbnRlZCB0byBzdG9yZSBzb21ldGhpbmcgdG8g
ZGlzayBzaG91bGQNCj4gbWFrZSBzdXJlIHJlcXVlc3RzIGhhdmUgYmVlbiBzdWNjZXNzZnVsbHkg
Y29tcGxldGVkIGJlZm9yZQ0KPiBzdXNwZW5kaW5nLg0KDQpXaGF0IGFib3V0IHdyaXRpbmcgdGhl
IHN1c3BlbmQgaW1hZ2UgaXRzZWxmPyBOb3JtYWwgZmlsZXN5c3RlbSBJL08gd2lsbCBoYXZlIGJl
ZW4gZmx1c2hlZCBvZiBjb3Vyc2UsIGJ1dCB3aGF0ZXZlciB2ZXN0aWdpYWwga2VybmVsIGFjdHVh
bGx5IHdyaXRlcyBvdXQgdGhlIGhpYmVybmF0aW9uIGZpbGUgbWF5IHdlbGwgZXhwZWN0IGEgZmlu
YWwgRDAtPkQzIG9uIHRoZSBzdG9yYWdlIGRldmljZSB0byBjYXVzZSBhIGZsdXNoLiBBZ2Fpbiwg
SSBkb24ndCBrbm93IHRoZSBzcGVjaWZpY3MgZm9yIExpbnV4IChhbmQgV2luZG93cyBhY3R1YWxs
eSB1c2VzIGFuIGluY2FybmF0aW9uIG9mIHRoZSBjcmFzaCBrZXJuZWwgdG8gZG8gdGhlIGpvYiwg
d2hpY2ggYnJpbmdzIHdpdGggaXQgYSB3aG9sZSBvdGhlciBzZXQgb2YgY29tcGxleGl0eSBhcyBm
YXIgYXMgUFYgZHJpdmVycyBnbykuDQoNCiAgUGF1bA0KDQo+IA0KPiBUaGFua3MsIFJvZ2VyLg0K
