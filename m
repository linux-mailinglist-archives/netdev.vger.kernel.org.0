Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64FB71659AA
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 09:55:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726885AbgBTIy5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 03:54:57 -0500
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:37066 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726501AbgBTIy4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Feb 2020 03:54:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazon201209; t=1582188895; x=1613724895;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=TbPHYgjrX7jeDenG/E1NAKBICGtXEFQr9dLkpS/cNUQ=;
  b=AFWK8uww61AafY4FZdLvpg/XVgaEYtCRxwRbBcGsXslqmatiOpiW9fbE
   uDqjeHaiHTe3dJ9DYLE0ExeYN5C4n1V4AVqHvZp+Y/6SGvsf7UrOWodZg
   qfdQoQr+nlyflXCZ4RjIF2Jhn/rddZXrb1RoLY3rwcg13hDa2twdZ9sGp
   M=;
IronPort-SDR: TYPyi/WWls5s6KFaie7zovGNTftMsKMWMgdDlSeraZ3ESH6JUmJwitlpunMV/UedBirHSEQEfP
 xxFh3e86fQLw==
X-IronPort-AV: E=Sophos;i="5.70,463,1574121600"; 
   d="scan'208";a="17748532"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2b-c7131dcf.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP; 20 Feb 2020 08:54:40 +0000
Received: from EX13MTAUWA001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2b-c7131dcf.us-west-2.amazon.com (Postfix) with ESMTPS id EB81DA27AD;
        Thu, 20 Feb 2020 08:54:38 +0000 (UTC)
Received: from EX13D07UWA002.ant.amazon.com (10.43.160.77) by
 EX13MTAUWA001.ant.amazon.com (10.43.160.58) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Thu, 20 Feb 2020 08:54:38 +0000
Received: from EX13D32EUC003.ant.amazon.com (10.43.164.24) by
 EX13D07UWA002.ant.amazon.com (10.43.160.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 20 Feb 2020 08:54:37 +0000
Received: from EX13D32EUC003.ant.amazon.com ([10.43.164.24]) by
 EX13D32EUC003.ant.amazon.com ([10.43.164.24]) with mapi id 15.00.1367.000;
 Thu, 20 Feb 2020 08:54:36 +0000
From:   "Durrant, Paul" <pdurrant@amazon.co.uk>
To:     =?utf-8?B?Um9nZXIgUGF1IE1vbm7DqQ==?= <roger.pau@citrix.com>,
        "Agarwal, Anchal" <anchalag@amazon.com>
CC:     "Valentin, Eduardo" <eduval@amazon.com>,
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
Thread-Index: AQHV446AUecZloiSDUiowKQxKdi9t6gfLFuAgADaIoCAAKqFgIACJekAgAD0YQCAAAHOgA==
Date:   Thu, 20 Feb 2020 08:54:36 +0000
Message-ID: <f986b845491b47cc8469d88e2e65e2a7@EX13D32EUC003.ant.amazon.com>
References: <cover.1581721799.git.anchalag@amazon.com>
 <890c404c585d7790514527f0c021056a7be6e748.1581721799.git.anchalag@amazon.com>
 <20200217100509.GE4679@Air-de-Roger>
 <20200217230553.GA8100@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
 <20200218091611.GN4679@Air-de-Roger>
 <20200219180424.GA17584@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
 <20200220083904.GI4679@Air-de-Roger>
In-Reply-To: <20200220083904.GI4679@Air-de-Roger>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.165.98]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBYZW4tZGV2ZWwgPHhlbi1kZXZl
bC1ib3VuY2VzQGxpc3RzLnhlbnByb2plY3Qub3JnPiBPbiBCZWhhbGYgT2YNCj4gUm9nZXIgUGF1
IE1vbm7DqQ0KPiBTZW50OiAyMCBGZWJydWFyeSAyMDIwIDA4OjM5DQo+IFRvOiBBZ2Fyd2FsLCBB
bmNoYWwgPGFuY2hhbGFnQGFtYXpvbi5jb20+DQo+IENjOiBWYWxlbnRpbiwgRWR1YXJkbyA8ZWR1
dmFsQGFtYXpvbi5jb20+OyBsZW4uYnJvd25AaW50ZWwuY29tOw0KPiBwZXRlcnpAaW5mcmFkZWFk
Lm9yZzsgYmVuaEBrZXJuZWwuY3Jhc2hpbmcub3JnOyB4ODZAa2VybmVsLm9yZzsgbGludXgtDQo+
IG1tQGt2YWNrLm9yZzsgcGF2ZWxAdWN3LmN6OyBocGFAenl0b3IuY29tOyB0Z2x4QGxpbnV0cm9u
aXguZGU7DQo+IHNzdGFiZWxsaW5pQGtlcm5lbC5vcmc7IGZsbGluZGVuQGFtYW96bi5jb207IEth
bWF0YSwgTXVuZWhpc2ENCj4gPGthbWF0YW1AYW1hem9uLmNvbT47IG1pbmdvQHJlZGhhdC5jb207
IHhlbi1kZXZlbEBsaXN0cy54ZW5wcm9qZWN0Lm9yZzsNCj4gU2luZ2gsIEJhbGJpciA8c2JsYmly
QGFtYXpvbi5jb20+OyBheGJvZUBrZXJuZWwuZGs7DQo+IGtvbnJhZC53aWxrQG9yYWNsZS5jb207
IGJwQGFsaWVuOC5kZTsgYm9yaXMub3N0cm92c2t5QG9yYWNsZS5jb207DQo+IGpncm9zc0BzdXNl
LmNvbTsgbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsgbGludXgtcG1Admdlci5rZXJuZWwub3JnOw0K
PiByandAcmp3eXNvY2tpLm5ldDsgbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZzsgdmt1em5l
dHNAcmVkaGF0LmNvbTsNCj4gZGF2ZW1AZGF2ZW1sb2Z0Lm5ldDsgV29vZGhvdXNlLCBEYXZpZCA8
ZHdtd0BhbWF6b24uY28udWs+DQo+IFN1YmplY3Q6IFJlOiBbWGVuLWRldmVsXSBbUkZDIFBBVENI
IHYzIDA2LzEyXSB4ZW4tYmxrZnJvbnQ6IGFkZCBjYWxsYmFja3MNCj4gZm9yIFBNIHN1c3BlbmQg
YW5kIGhpYmVybmF0aW9uDQo+IA0KPiBUaGFua3MgZm9yIHRoaXMgd29yaywgcGxlYXNlIHNlZSBi
ZWxvdy4NCj4gDQo+IE9uIFdlZCwgRmViIDE5LCAyMDIwIGF0IDA2OjA0OjI0UE0gKzAwMDAsIEFu
Y2hhbCBBZ2Fyd2FsIHdyb3RlOg0KPiA+IE9uIFR1ZSwgRmViIDE4LCAyMDIwIGF0IDEwOjE2OjEx
QU0gKzAxMDAsIFJvZ2VyIFBhdSBNb25uw6kgd3JvdGU6DQo+ID4gPiBPbiBNb24sIEZlYiAxNywg
MjAyMCBhdCAxMTowNTo1M1BNICswMDAwLCBBbmNoYWwgQWdhcndhbCB3cm90ZToNCj4gPiA+ID4g
T24gTW9uLCBGZWIgMTcsIDIwMjAgYXQgMTE6MDU6MDlBTSArMDEwMCwgUm9nZXIgUGF1IE1vbm7D
qSB3cm90ZToNCj4gPiA+ID4gPiBPbiBGcmksIEZlYiAxNCwgMjAyMCBhdCAxMToyNTozNFBNICsw
MDAwLCBBbmNoYWwgQWdhcndhbCB3cm90ZToNCj4gPiA+ID4gPiA+IEZyb206IE11bmVoaXNhIEth
bWF0YSA8a2FtYXRhbUBhbWF6b24uY29tDQo+ID4gPiA+ID4gPg0KPiA+ID4gPiA+ID4gQWRkIGZy
ZWV6ZSwgdGhhdyBhbmQgcmVzdG9yZSBjYWxsYmFja3MgZm9yIFBNIHN1c3BlbmQgYW5kDQo+IGhp
YmVybmF0aW9uDQo+ID4gPiA+ID4gPiBzdXBwb3J0LiBBbGwgZnJvbnRlbmQgZHJpdmVycyB0aGF0
IG5lZWRzIHRvIHVzZQ0KPiBQTV9ISUJFUk5BVElPTi9QTV9TVVNQRU5EDQo+ID4gPiA+ID4gPiBl
dmVudHMsIG5lZWQgdG8gaW1wbGVtZW50IHRoZXNlIHhlbmJ1c19kcml2ZXIgY2FsbGJhY2tzLg0K
PiA+ID4gPiA+ID4gVGhlIGZyZWV6ZSBoYW5kbGVyIHN0b3BzIGEgYmxvY2stbGF5ZXIgcXVldWUg
YW5kIGRpc2Nvbm5lY3QgdGhlDQo+ID4gPiA+ID4gPiBmcm9udGVuZCBmcm9tIHRoZSBiYWNrZW5k
IHdoaWxlIGZyZWVpbmcgcmluZ19pbmZvIGFuZCBhc3NvY2lhdGVkDQo+IHJlc291cmNlcy4NCj4g
PiA+ID4gPiA+IFRoZSByZXN0b3JlIGhhbmRsZXIgcmUtYWxsb2NhdGVzIHJpbmdfaW5mbyBhbmQg
cmUtY29ubmVjdCB0byB0aGUNCj4gPiA+ID4gPiA+IGJhY2tlbmQsIHNvIHRoZSByZXN0IG9mIHRo
ZSBrZXJuZWwgY2FuIGNvbnRpbnVlIHRvIHVzZSB0aGUgYmxvY2sNCj4gZGV2aWNlDQo+ID4gPiA+
ID4gPiB0cmFuc3BhcmVudGx5LiBBbHNvLCB0aGUgaGFuZGxlcnMgYXJlIHVzZWQgZm9yIGJvdGgg
UE0gc3VzcGVuZA0KPiBhbmQNCj4gPiA+ID4gPiA+IGhpYmVybmF0aW9uIHNvIHRoYXQgd2UgY2Fu
IGtlZXAgdGhlIGV4aXN0aW5nIHN1c3BlbmQvcmVzdW1lDQo+IGNhbGxiYWNrcyBmb3INCj4gPiA+
ID4gPiA+IFhlbiBzdXNwZW5kIHdpdGhvdXQgbW9kaWZpY2F0aW9uLiBCZWZvcmUgZGlzY29ubmVj
dGluZyBmcm9tDQo+IGJhY2tlbmQsDQo+ID4gPiA+ID4gPiB3ZSBuZWVkIHRvIHByZXZlbnQgYW55
IG5ldyBJTyBmcm9tIGJlaW5nIHF1ZXVlZCBhbmQgd2FpdCBmb3INCj4gZXhpc3RpbmcNCj4gPiA+
ID4gPiA+IElPIHRvIGNvbXBsZXRlLg0KPiA+ID4gPiA+DQo+ID4gPiA+ID4gVGhpcyBpcyBkaWZm
ZXJlbnQgZnJvbSBYZW4gKHhlbnN0b3JlKSBpbml0aWF0ZWQgc3VzcGVuc2lvbiwgYXMgaW4NCj4g
dGhhdA0KPiA+ID4gPiA+IGNhc2UgTGludXggZG9lc24ndCBmbHVzaCB0aGUgcmluZ3Mgb3IgZGlz
Y29ubmVjdHMgZnJvbSB0aGUNCj4gYmFja2VuZC4NCj4gPiA+ID4gWWVzLCBBRkFJSyBpbiB4ZW4g
aW5pdGlhdGVkIHN1c3BlbnNpb24gYmFja2VuZCB0YWtlcyBjYXJlIG9mIGl0Lg0KPiA+ID4NCj4g
PiA+IE5vLCBpbiBYZW4gaW5pdGlhdGVkIHN1c3BlbnNpb24gYmFja2VuZCBkb2Vzbid0IHRha2Ug
Y2FyZSBvZiBmbHVzaGluZw0KPiA+ID4gdGhlIHJpbmdzLCB0aGUgZnJvbnRlbmQgaGFzIGEgc2hh
ZG93IGNvcHkgb2YgdGhlIHJpbmcgY29udGVudHMgYW5kIGl0DQo+ID4gPiByZS1pc3N1ZXMgdGhl
IHJlcXVlc3RzIG9uIHJlc3VtZS4NCj4gPiA+DQo+ID4gWWVzLCBJIG1lYW50IHN1c3BlbnNpb24g
aW4gZ2VuZXJhbCB3aGVyZSBib3RoIHhlbnN0b3JlIGFuZCBiYWNrZW5kIGtub3dzDQo+ID4gc3lz
dGVtIGlzIGdvaW5nIHVuZGVyIHN1c3BlbnNpb24gYW5kIG5vdCBmbHVzaGluZyBvZiByaW5ncy4N
Cj4gDQo+IGJhY2tlbmQgaGFzIG5vIGlkZWEgdGhlIGd1ZXN0IGlzIGdvaW5nIHRvIGJlIHN1c3Bl
bmRlZC4gQmFja2VuZCBjb2RlDQo+IGlzIGNvbXBsZXRlbHkgYWdub3N0aWMgdG8gc3VzcGVuc2lv
bi9yZXN1bWUuDQo+IA0KPiA+IFRoYXQgaGFwcGVucw0KPiA+IGluIGZyb250ZW5kIHdoZW4gYmFj
a2VuZCBpbmRpY2F0ZXMgdGhhdCBzdGF0ZSBpcyBjbG9zaW5nIGFuZCBzbyBvbi4NCj4gPiBJIG1h
eSBoYXZlIHdyaXR0ZW4gaXQgaW4gd3JvbmcgY29udGV4dC4NCj4gDQo+IEknbSBhZnJhaWQgSSdt
IG5vdCBzdXJlIEkgZnVsbHkgdW5kZXJzdGFuZCB0aGlzIGxhc3Qgc2VudGVuY2UuDQo+IA0KPiA+
ID4gPiA+ID4gK3N0YXRpYyBpbnQgYmxrZnJvbnRfZnJlZXplKHN0cnVjdCB4ZW5idXNfZGV2aWNl
ICpkZXYpDQo+ID4gPiA+ID4gPiArew0KPiA+ID4gPiA+ID4gKwl1bnNpZ25lZCBpbnQgaTsNCj4g
PiA+ID4gPiA+ICsJc3RydWN0IGJsa2Zyb250X2luZm8gKmluZm8gPSBkZXZfZ2V0X2RydmRhdGEo
JmRldi0+ZGV2KTsNCj4gPiA+ID4gPiA+ICsJc3RydWN0IGJsa2Zyb250X3JpbmdfaW5mbyAqcmlu
Zm87DQo+ID4gPiA+ID4gPiArCS8qIFRoaXMgd291bGQgYmUgcmVhc29uYWJsZSB0aW1lb3V0IGFz
IHVzZWQgaW4NCj4geGVuYnVzX2Rldl9zaHV0ZG93bigpICovDQo+ID4gPiA+ID4gPiArCXVuc2ln
bmVkIGludCB0aW1lb3V0ID0gNSAqIEhaOw0KPiA+ID4gPiA+ID4gKwlpbnQgZXJyID0gMDsNCj4g
PiA+ID4gPiA+ICsNCj4gPiA+ID4gPiA+ICsJaW5mby0+Y29ubmVjdGVkID0gQkxLSUZfU1RBVEVf
RlJFRVpJTkc7DQo+ID4gPiA+ID4gPiArDQo+ID4gPiA+ID4gPiArCWJsa19tcV9mcmVlemVfcXVl
dWUoaW5mby0+cnEpOw0KPiA+ID4gPiA+ID4gKwlibGtfbXFfcXVpZXNjZV9xdWV1ZShpbmZvLT5y
cSk7DQo+ID4gPiA+ID4gPiArDQo+ID4gPiA+ID4gPiArCWZvciAoaSA9IDA7IGkgPCBpbmZvLT5u
cl9yaW5nczsgaSsrKSB7DQo+ID4gPiA+ID4gPiArCQlyaW5mbyA9ICZpbmZvLT5yaW5mb1tpXTsN
Cj4gPiA+ID4gPiA+ICsNCj4gPiA+ID4gPiA+ICsJCWdudHRhYl9jYW5jZWxfZnJlZV9jYWxsYmFj
aygmcmluZm8tPmNhbGxiYWNrKTsNCj4gPiA+ID4gPiA+ICsJCWZsdXNoX3dvcmsoJnJpbmZvLT53
b3JrKTsNCj4gPiA+ID4gPiA+ICsJfQ0KPiA+ID4gPiA+ID4gKw0KPiA+ID4gPiA+ID4gKwkvKiBL
aWNrIHRoZSBiYWNrZW5kIHRvIGRpc2Nvbm5lY3QgKi8NCj4gPiA+ID4gPiA+ICsJeGVuYnVzX3N3
aXRjaF9zdGF0ZShkZXYsIFhlbmJ1c1N0YXRlQ2xvc2luZyk7DQo+ID4gPiA+ID4NCj4gPiA+ID4g
PiBBcmUgeW91IHN1cmUgdGhpcyBpcyBzYWZlPw0KPiA+ID4gPiA+DQo+ID4gPiA+IEluIG15IHRl
c3RpbmcgcnVubmluZyBtdWx0aXBsZSBmaW8gam9icywgb3RoZXIgdGVzdCBzY2VuYXJpb3MNCj4g
cnVubmluZw0KPiA+ID4gPiBhIG1lbW9yeSBsb2FkZXIgd29ya3MgZmluZS4gSSBkaWQgbm90IGNh
bWUgYWNyb3NzIGEgc2NlbmFyaW8gdGhhdA0KPiB3b3VsZA0KPiA+ID4gPiBoYXZlIGZhaWxlZCBy
ZXN1bWUgZHVlIHRvIGJsa2Zyb250IGlzc3VlcyB1bmxlc3MgeW91IGNhbiBzdWdlc3QNCj4gc29t
ZT8NCj4gPiA+DQo+ID4gPiBBRkFJQ1QgeW91IGRvbid0IHdhaXQgZm9yIHRoZSBpbi1mbGlnaHQg
cmVxdWVzdHMgdG8gYmUgZmluaXNoZWQsIGFuZA0KPiA+ID4ganVzdCByZWx5IG9uIGJsa2JhY2sg
dG8gZmluaXNoIHByb2Nlc3NpbmcgdGhvc2UuIEknbSBub3Qgc3VyZSBhbGwNCj4gPiA+IGJsa2Jh
Y2sgaW1wbGVtZW50YXRpb25zIG91dCB0aGVyZSBjYW4gZ3VhcmFudGVlIHRoYXQuDQo+ID4gPg0K
PiA+ID4gVGhlIGFwcHJvYWNoIHVzZWQgYnkgWGVuIGluaXRpYXRlZCBzdXNwZW5zaW9uIGlzIHRv
IHJlLWlzc3VlIHRoZQ0KPiA+ID4gaW4tZmxpZ2h0IHJlcXVlc3RzIHdoZW4gcmVzdW1pbmcuIEkg
aGF2ZSB0byBhZG1pdCBJIGRvbid0IHRoaW5rIHRoaXMNCj4gPiA+IGlzIHRoZSBiZXN0IGFwcHJv
YWNoLCBidXQgSSB3b3VsZCBsaWtlIHRvIGtlZXAgYm90aCB0aGUgWGVuIGFuZCB0aGUgUE0NCj4g
PiA+IGluaXRpYXRlZCBzdXNwZW5zaW9uIHVzaW5nIHRoZSBzYW1lIGxvZ2ljLCBhbmQgaGVuY2Ug
SSB3b3VsZCByZXF1ZXN0DQo+ID4gPiB0aGF0IHlvdSB0cnkgdG8gcmUtdXNlIHRoZSBleGlzdGlu
ZyByZXN1bWUgbG9naWMgKGJsa2Zyb250X3Jlc3VtZSkuDQo+ID4gPg0KPiA+ID4gPiA+IEkgZG9u
J3QgdGhpbmsgeW91IHdhaXQgZm9yIGFsbCByZXF1ZXN0cyBwZW5kaW5nIG9uIHRoZSByaW5nIHRv
IGJlDQo+ID4gPiA+ID4gZmluaXNoZWQgYnkgdGhlIGJhY2tlbmQsIGFuZCBoZW5jZSB5b3UgbWln
aHQgbG9vc2UgcmVxdWVzdHMgYXMgdGhlDQo+ID4gPiA+ID4gb25lcyBvbiB0aGUgcmluZyB3b3Vs
ZCBub3QgYmUgcmUtaXNzdWVkIGJ5IGJsa2Zyb250X3Jlc3RvcmUNCj4gQUZBSUNULg0KPiA+ID4g
PiA+DQo+ID4gPiA+IEFGQUlVLCBibGtfbXFfZnJlZXplX3F1ZXVlL2Jsa19tcV9xdWllc2NlX3F1
ZXVlIHNob3VsZCB0YWtlIGNhcmUgb2YNCj4gbm8gdXNlZA0KPiA+ID4gPiByZXF1ZXN0IG9uIHRo
ZSBzaGFyZWQgcmluZy4gQWxzbywgd2UgSSB3YW50IHRvIHBhdXNlIHRoZSBxdWV1ZSBhbmQNCj4g
Zmx1c2ggYWxsDQo+ID4gPiA+IHRoZSBwZW5kaW5nIHJlcXVlc3RzIGluIHRoZSBzaGFyZWQgcmlu
ZyBiZWZvcmUgZGlzY29ubmVjdGluZyBmcm9tDQo+IGJhY2tlbmQuDQo+ID4gPg0KPiA+ID4gT2gs
IHNvIGJsa19tcV9mcmVlemVfcXVldWUgZG9lcyB3YWl0IGZvciBpbi1mbGlnaHQgcmVxdWVzdHMg
dG8gYmUNCj4gPiA+IGZpbmlzaGVkLiBJIGd1ZXNzIGl0J3MgZmluZSB0aGVuLg0KPiA+ID4NCj4g
PiBPay4NCj4gPiA+ID4gUXVpZXNjaW5nIHRoZSBxdWV1ZSBzZWVtZWQgYSBiZXR0ZXIgb3B0aW9u
IGhlcmUgYXMgd2Ugd2FudCB0byBtYWtlDQo+IHN1cmUgb25nb2luZw0KPiA+ID4gPiByZXF1ZXN0
cyBkaXNwYXRjaGVzIGFyZSB0b3RhbGx5IGRyYWluZWQuDQo+ID4gPiA+IEkgc2hvdWxkIGFjY2Vw
dCB0aGF0IHNvbWUgb2YgdGhlc2Ugbm90aW9uIGlzIGJvcnJvd2VkIGZyb20gaG93IG52bWUNCj4g
ZnJlZXplL3VuZnJlZXplDQo+ID4gPiA+IGlzIGRvbmUgYWx0aG91Z2ggaXRzIG5vdCBhcHBsZSB0
byBhcHBsZSBjb21wYXJpc29uLg0KPiA+ID4NCj4gPiA+IFRoYXQncyBmaW5lLCBidXQgSSB3b3Vs
ZCBzdGlsbCBsaWtlIHRvIHJlcXVlc3RzIHRoYXQgeW91IHVzZSB0aGUgc2FtZQ0KPiA+ID4gbG9n
aWMgKGFzIG11Y2ggYXMgcG9zc2libGUpIGZvciBib3RoIHRoZSBYZW4gYW5kIHRoZSBQTSBpbml0
aWF0ZWQNCj4gPiA+IHN1c3BlbnNpb24uDQo+ID4gPg0KPiA+ID4gU28geW91IGVpdGhlciBhcHBs
eSB0aGlzIGZyZWV6ZS91bmZyZWV6ZSB0byB0aGUgWGVuIHN1c3BlbnNpb24gKGFuZA0KPiA+ID4g
ZHJvcCB0aGUgcmUtaXNzdWluZyBvZiByZXF1ZXN0cyBvbiByZXN1bWUpIG9yIGFkYXB0IHRoZSBz
YW1lIGFwcHJvYWNoDQo+ID4gPiBhcyB0aGUgWGVuIGluaXRpYXRlZCBzdXNwZW5zaW9uLiBLZWVw
aW5nIHR3byBjb21wbGV0ZWx5IGRpZmZlcmVudA0KPiA+ID4gYXBwcm9hY2hlcyB0byBzdXNwZW5z
aW9uIC8gcmVzdW1lIG9uIGJsa2Zyb250IGlzIG5vdCBzdWl0YWJsZSBsb25nDQo+ID4gPiB0ZXJt
Lg0KPiA+ID4NCj4gPiBJIGFncmVlIHdpdGggeW91IG9uIG92ZXJoYXVsIG9mIHhlbiBzdXNwZW5k
L3Jlc3VtZSB3cnQgYmxrZnJvbnQgaXMgYQ0KPiBnb29kDQo+ID4gaWRlYSBob3dldmVyLCBJTU8g
dGhhdCBpcyBhIHdvcmsgZm9yIGZ1dHVyZSBhbmQgdGhpcyBwYXRjaCBzZXJpZXMgc2hvdWxkDQo+
ID4gbm90IGJlIGJsb2NrZWQgZm9yIGl0LiBXaGF0IGRvIHlvdSB0aGluaz8NCj4gDQo+IEl0J3Mg
bm90IHNvIG11Y2ggdGhhdCBJIHRoaW5rIGFuIG92ZXJoYXVsIG9mIHN1c3BlbmQvcmVzdW1lIGlu
DQo+IGJsa2Zyb250IGlzIG5lZWRlZCwgaXQncyBqdXN0IHRoYXQgSSBkb24ndCB3YW50IHRvIGhh
dmUgdHdvIGNvbXBsZXRlbHkNCj4gZGlmZmVyZW50IHN1c3BlbmQvcmVzdW1lIHBhdGhzIGluc2lk
ZSBibGtmcm9udC4NCj4gDQo+IFNvIGZyb20gbXkgUG9WIEkgdGhpbmsgdGhlIHJpZ2h0IHNvbHV0
aW9uIGlzIHRvIGVpdGhlciB1c2UgdGhlIHNhbWUNCj4gY29kZSAoYXMgbXVjaCBhcyBwb3NzaWJs
ZSkgYXMgaXQncyBjdXJyZW50bHkgdXNlZCBieSBYZW4gaW5pdGlhdGVkDQo+IHN1c3BlbmQvcmVz
dW1lLCBvciB0byBhbHNvIHN3aXRjaCBYZW4gaW5pdGlhdGVkIHN1c3BlbnNpb24gdG8gdXNlIHRo
ZQ0KPiBuZXdseSBpbnRyb2R1Y2VkIGNvZGUuDQo+IA0KPiBIYXZpbmcgdHdvIGRpZmZlcmVudCBh
cHByb2FjaGVzIHRvIHN1c3BlbmQvcmVzdW1lIGluIHRoZSBzYW1lIGRyaXZlcg0KPiBpcyBhIHJl
Y2lwZSBmb3IgZGlzYXN0ZXIgSU1POiBpdCBhZGRzIGNvbXBsZXhpdHkgYnkgZm9yY2luZyBkZXZl
bG9wZXJzDQo+IHRvIHRha2UgaW50byBhY2NvdW50IHR3byBkaWZmZXJlbnQgc3VzcGVuZC9yZXN1
bWUgYXBwcm9hY2hlcyB3aGVuDQo+IHRoZXJlJ3Mgbm8gbmVlZCBmb3IgaXQuDQoNCkkgZGlzYWdy
ZWUuIFMzIG9yIFM0IHN1c3BlbmQvcmVzdW1lIChvciBwZXJoYXBzIHdlIHNob3VsZCBjYWxsIHRo
ZW0gcG93ZXIgc3RhdGUgdHJhbnNpdGlvbnMgdG8gYXZvaWQgY29uZnVzaW9uKSBhcmUgcXVpdGUg
ZGlmZmVyZW50IGZyb20gWGVuIHN1c3BlbmQvcmVzdW1lLg0KUG93ZXIgc3RhdGUgdHJhbnNpdGlv
bnMgb3VnaHQgdG8gYmUsIGFuZCBpbmRlZWQgYXJlLCB2aXNpYmxlIHRvIHRoZSBzb2Z0d2FyZSBy
dW5uaW5nIGluc2lkZSB0aGUgZ3Vlc3QuIEFwcGxpY2F0aW9ucywgYXMgd2VsbCBhcyBkcml2ZXJz
LCBjYW4gcmVjZWl2ZSBub3RpZmljYXRpb24gYW5kIHRha2Ugd2hhdGV2ZXIgYWN0aW9uIHRoZXkg
ZGVlbSBhcHByb3ByaWF0ZS4NClhlbiBzdXNwZW5kL3Jlc3VtZSBPVE9IIGlzIHVzZWQgd2hlbiBh
IGd1ZXN0IGlzIG1pZ3JhdGVkIGFuZCB0aGUgY29kZSBzaG91bGQgZ28gdG8gYWxsIGxlbmd0aHMg
cG9zc2libGUgdG8gbWFrZSBhbnkgc29mdHdhcmUgcnVubmluZyBpbnNpZGUgdGhlIGd1ZXN0IChv
dGhlciB0aGFuIFhlbiBzcGVjaWZpYyBlbmxpZ2h0ZW5lZCBjb2RlLCBzdWNoIGFzIFBWIGRyaXZl
cnMpIGNvbXBsZXRlbHkgdW5hd2FyZSB0aGF0IGFueXRoaW5nIGhhcyBhY3R1YWxseSBoYXBwZW5l
ZC4NClNvLCB3aGlsc3QgaXQgbWF5IGJlIHBvc3NpYmxlIHRvIHVzZSBjb21tb24gcm91dGluZXMg
dG8sIGZvciBleGFtcGxlLCByZS1lc3RhYmxpc2ggUFYgZnJvbnRlbmQvYmFja2VuZCBjb21tdW5p
Y2F0aW9uLCBQViBmcm9udGVuZCBjb2RlIHNob3VsZCBiZSBhY3V0ZWx5IGF3YXJlIG9mIHRoZSBj
aXJjdW1zdGFuY2VzIHRoZXkgYXJlIG9wZXJhdGluZyBpbi4gSSBjYW4gY2l0ZSBleGFtcGxlIGNv
ZGUgaW4gdGhlIFdpbmRvd3MgUFYgZHJpdmVyLCB3aGljaCBoYXZlIHN1cHBvcnRlZCBndWVzdCBT
My9TNCBwb3dlciBzdGF0ZSB0cmFuc2l0aW9ucyBzaW5jZSBkYXkgMS4NCg0KICBQYXVsDQoNCj4g
DQo+IFRoYW5rcywgUm9nZXIuDQo+IA0KPiBfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fXw0KPiBYZW4tZGV2ZWwgbWFpbGluZyBsaXN0DQo+IFhlbi1kZXZlbEBs
aXN0cy54ZW5wcm9qZWN0Lm9yZw0KPiBodHRwczovL2xpc3RzLnhlbnByb2plY3Qub3JnL21haWxt
YW4vbGlzdGluZm8veGVuLWRldmVsDQo=
