Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 548073718C
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 12:23:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728385AbfFFKXs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 06:23:48 -0400
Received: from smtp-fw-9101.amazon.com ([207.171.184.25]:2140 "EHLO
        smtp-fw-9101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727857AbfFFKXs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 06:23:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1559816626; x=1591352626;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=jX8sr8BVhaqErfivvBO/hkaXCCZzAylGGazjRMs+b3s=;
  b=WB1bZXiNfecICHdN5N50yxfQn4PUGyOeCwh9loN07LSV/fiembJ41et8
   zHznxGl/0+owq+bhEsMKdRPM0DTJOvHe0NObU0Q3I91VPJ0DUEU4qdxPV
   dGR8BeFbix/rnaLYi7Fd0JfNlVFHM3VEGK0R3mUs91VV+OxMuZVKRwN7e
   Q=;
X-IronPort-AV: E=Sophos;i="5.60,559,1549929600"; 
   d="scan'208";a="808927253"
Received: from sea3-co-svc-lb6-vlan3.sea.amazon.com (HELO email-inbound-relay-1e-57e1d233.us-east-1.amazon.com) ([10.47.22.38])
  by smtp-border-fw-out-9101.sea19.amazon.com with ESMTP; 06 Jun 2019 10:23:44 +0000
Received: from EX13MTAUEA001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1e-57e1d233.us-east-1.amazon.com (Postfix) with ESMTPS id B117D14186F;
        Thu,  6 Jun 2019 10:23:42 +0000 (UTC)
Received: from EX13D10EUB004.ant.amazon.com (10.43.166.155) by
 EX13MTAUEA001.ant.amazon.com (10.43.61.243) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Thu, 6 Jun 2019 10:23:42 +0000
Received: from EX13D11EUB003.ant.amazon.com (10.43.166.58) by
 EX13D10EUB004.ant.amazon.com (10.43.166.155) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Thu, 6 Jun 2019 10:23:40 +0000
Received: from EX13D11EUB003.ant.amazon.com ([10.43.166.58]) by
 EX13D11EUB003.ant.amazon.com ([10.43.166.58]) with mapi id 15.00.1367.000;
 Thu, 6 Jun 2019 10:23:40 +0000
From:   "Jubran, Samih" <sameehj@amazon.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        David Woodhouse <dwmw2@infradead.org>
CC:     "Bshara, Nafea" <nafea@amazon.com>, Andrew Lunn <andrew@lunn.ch>,
        "Kiyanovski, Arthur" <akiyano@amazon.com>,
        "Bshara, Saeed" <saeedb@amazon.com>,
        "Tzalik, Guy" <gtzalik@amazon.com>,
        "Matushevsky, Alexander" <matua@amazon.com>,
        "Liguori, Anthony" <aliguori@amazon.com>,
        "Saidi, Ali" <alisaidi@amazon.com>,
        "Machulsky, Zorik" <zorik@amazon.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Wilson, Matt" <msw@amazon.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Belgazal, Netanel" <netanel@amazon.com>,
        "Herrenschmidt, Benjamin" <benh@amazon.com>
Subject: RE: [PATCH V2 net 00/11] Extending the ena driver to support new
 features and enhance performance
Thread-Topic: [PATCH V2 net 00/11] Extending the ena driver to support new
 features and enhance performance
Thread-Index: AQHVGhq6vtIp7IlvREyUyiOVSXjESqaKc16AgAAPeQCAAAorgIAALp+AgAAG4wCAAE7pAIAArv0AgAKuvoA=
Date:   Thu, 6 Jun 2019 10:23:40 +0000
Message-ID: <7f697af8f31f4bc7ba30ef643e7b3921@EX13D11EUB003.ant.amazon.com>
References: <20190603144329.16366-1-sameehj@amazon.com>
        <20190603143205.1d95818e@cakuba.netronome.com>
        <9da931e72debc868efaac144082f40d379c50f3c.camel@amazon.co.uk>
        <20190603160351.085daa91@cakuba.netronome.com>
        <20190604015043.GG17267@lunn.ch>
        <D26B5448-1E74-44E8-83DA-FC93E5520325@amazon.com>
        <af79f238465ebe069bc41924a2ae2efbcdbd6e38.camel@infradead.org>
 <20190604102406.1f426339@cakuba.netronome.com>
In-Reply-To: <20190604102406.1f426339@cakuba.netronome.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.165.250]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

QXMgb2YgdG9kYXkgdGhlcmUgYXJlIG5vIGZsYWdzIGV4cG9zZWQgYnkgRU5BIE5JQyBkZXZpY2Us
IGhvd2V2ZXIsIHdlIGFyZSBwbGFubmluZyB0byB1c2UgdGhlbSBpbiB0aGUgbmVhciBmdXR1cmUu
DQpXZSB3YW50IHRvIHByb3ZpZGUgY3VzdG9tZXJzIHdpdGggZXh0cmEgbWV0aG9kcyB0byBpZGVu
dGlmeSAoYW5kIGRpZmZlcmVudGlhdGUpIG11bHRpcGxlIG5ldHdvcmsgaW50ZXJmYWNlcyB0aGF0
IGNhbiBiZSBhdHRhY2hlZCB0byBhIHNpbmdsZSBWTS4gDQpDdXJyZW50bHksIGN1c3RvbWVycyBj
YW4gaWRlbnRpZnkgYSBzcGVjaWZpYyBuZXR3b3JrIGludGVyZmFjZSAoRU5JKSBvbmx5IGJ5IE1B
QyBhZGRyZXNzLCBhbmQgbGF0ZXIgbG9vayB1cCB0aGlzIE1BQyBhbW9uZyBvdGhlciBtdWx0aXBs
ZSBFTklzIHRoYXQgdGhleSBoYXZlLg0KSW4gc29tZSBjYXNlcyBpdCBtaWdodCBub3QgYmUgY29u
dmVuaWVudC4gVXNpbmcgdGhlc2UgZmxhZ3Mgd2lsbCBsZXQgdXMgaW5mb3JtIHRoZSBjdXN0b21l
ciBhYm91dCBFTklgcyBzcGVjaWZpYyBwcm9wZXJ0aWVzLiBJdCdzIG5vdCBmaW5hbGl6ZWQsDQpi
dXQgdGVudGF0aXZlbHkgaXQgY2FuIGxvb2sgbGlrZSB0aGlzOg0KcHJpbWFyeS1lbmk6IG9uIC8q
IERpZmZlcmVudGlhdGUgYmV0d2VlbiBwcmltYXJ5IGFuZCBzZWNvbmRhcnkgRU5JcyAqLw0KaGFz
LWFzc29jaWF0ZWQtZWZhOiBvbiAvKiBXaWxsIHNwZWNpZnkgRU5BIGRldmljZSBoYXMgYW5vdGhl
ciBhc3NvY2lhdGVkIEVGQSBkZXZpY2UgKi8NCg0KPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0t
LQ0KPiBGcm9tOiBKYWt1YiBLaWNpbnNraSA8amFrdWIua2ljaW5za2lAbmV0cm9ub21lLmNvbT4N
Cj4gU2VudDogVHVlc2RheSwgSnVuZSA0LCAyMDE5IDg6MjQgUE0NCj4gVG86IERhdmlkIFdvb2Ro
b3VzZSA8ZHdtdzJAaW5mcmFkZWFkLm9yZz4NCj4gQ2M6IEJzaGFyYSwgTmFmZWEgPG5hZmVhQGFt
YXpvbi5jb20+OyBBbmRyZXcgTHVubiA8YW5kcmV3QGx1bm4uY2g+Ow0KPiBKdWJyYW4sIFNhbWlo
IDxzYW1lZWhqQGFtYXpvbi5jb20+OyBLaXlhbm92c2tpLCBBcnRodXINCj4gPGFraXlhbm9AYW1h
em9uLmNvbT47IEJzaGFyYSwgU2FlZWQgPHNhZWVkYkBhbWF6b24uY29tPjsgVHphbGlrLA0KPiBH
dXkgPGd0emFsaWtAYW1hem9uLmNvbT47IE1hdHVzaGV2c2t5LCBBbGV4YW5kZXINCj4gPG1hdHVh
QGFtYXpvbi5jb20+OyBMaWd1b3JpLCBBbnRob255IDxhbGlndW9yaUBhbWF6b24uY29tPjsgU2Fp
ZGksIEFsaQ0KPiA8YWxpc2FpZGlAYW1hem9uLmNvbT47IE1hY2h1bHNreSwgWm9yaWsgPHpvcmlr
QGFtYXpvbi5jb20+Ow0KPiBuZXRkZXZAdmdlci5rZXJuZWwub3JnOyBXaWxzb24sIE1hdHQgPG1z
d0BhbWF6b24uY29tPjsNCj4gZGF2ZW1AZGF2ZW1sb2Z0Lm5ldDsgQmVsZ2F6YWwsIE5ldGFuZWwg
PG5ldGFuZWxAYW1hem9uLmNvbT47DQo+IEhlcnJlbnNjaG1pZHQsIEJlbmphbWluIDxiZW5oQGFt
YXpvbi5jb20+DQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggVjIgbmV0IDAwLzExXSBFeHRlbmRpbmcg
dGhlIGVuYSBkcml2ZXIgdG8gc3VwcG9ydCBuZXcNCj4gZmVhdHVyZXMgYW5kIGVuaGFuY2UgcGVy
Zm9ybWFuY2UNCj4gDQo+IE9uIFR1ZSwgMDQgSnVuIDIwMTkgMDc6NTc6NDggKzAxMDAsIERhdmlk
IFdvb2Rob3VzZSB3cm90ZToNCj4gPiBPbiBUdWUsIDIwMTktMDYtMDQgYXQgMDI6MTUgKzAwMDAs
IEJzaGFyYSwgTmFmZWEgd3JvdGU6DQo+ID4gPiBPbiBKdW4gMywgMjAxOSwgYXQgNjo1MiBQTSwg
QW5kcmV3IEx1bm4gPGFuZHJld0BsdW5uLmNoPiB3cm90ZToNCj4gPiA+ID4gPiBBbnkgIlNtYXJ0
TklDIiB2ZW5kb3IgaGFzIHRlbXB0YXRpb24gb2YgdUFQSS1sZXZlbCBoYW5kIG9mZiB0bw0KPiA+
ID4gPiA+IHRoZSBmaXJtd2FyZSAoaW5jbHVkaW5nIG15IGVtcGxveWVyKSwgd2UgYWxsIHJ1biBw
cmV0dHkgYmVlZnkNCj4gPiA+ID4gPiBwcm9jZXNzb3JzIGluc2lkZSAidGhlIE5JQyIgYWZ0ZXIg
YWxsLiAgVGhlIGRldmljZSBjZW50cmljDQo+ID4gPiA+ID4gZXRodG9vbCBjb25maWd1cmF0aW9u
IGNhbiBiZSBpbXBsZW1lbnRlZCBieSBqdXN0IGZvcndhcmRpbmcgdGhlDQo+ID4gPiA+ID4gdUFQ
SSBzdHJ1Y3R1cmVzIGFzIHRoZXkgYXJlIHRvIHRoZSBGVy4gIEknbSBzdXJlIEFuZHJldyBhbmQN
Cj4gPiA+ID4gPiBvdGhlcnMgd2hvIHdvdWxkIGxpa2UgdG8gc2VlIExpbnV4IHRha2VzIG1vcmUg
Y29udHJvbCBvdmVyIFBIWXMgZXRjLg0KPiB3b3VsZCBub3QgbGlrZSB0aGlzIHNjZW5hcmlvLCBl
aXRoZXIuDQo+ID4gPiA+DQo+ID4gPiA+IE5vLCBpIHdvdWxkIG5vdC4gVGhlcmUgYXJlIGEgZmV3
IGdvb2QgZXhhbXBsZXMgb2YgYm90aCBmaXJtd2FyZQ0KPiA+ID4gPiBhbmQgb3BlbiBkcml2ZXJz
IGJlaW5nIHVzZWQgdG8gY29udHJvbCB0aGUgc2FtZSBQSFksIG9uIGRpZmZlcmVudA0KPiA+ID4g
PiBib2FyZHMuIFRoZSBQSFkgZHJpdmVyIHdhcyBkZXZlbG9wZWQgYnkgdGhlIGNvbW11bml0eSwg
YW5kIGhhcw0KPiA+ID4gPiBtb3JlIGZlYXR1cmVzIHRoYW4gdGhlIGZpcm13YXJlIGRyaXZlci4g
QW5kIGl0IGtlZXBzIGdhaW5pbmcNCj4gPiA+ID4gZmVhdHVyZXMuIFRoZSBmaXJtd2FyZSBpIHN0
dWNrLCBubyB1cGRhdGVzLiBUaGUgY29tbXVuaXR5IGRyaXZlcg0KPiA+ID4gPiBjYW4gYmUgZGVi
dWdnZWQsIHRoZSBmaXJtd2FyZSBpcyBhIGJsYWNrIGJveCwgbm8gY2hhbmNlIG9mIHRoZQ0KPiA+
ID4gPiBjb21tdW5pdHkgZml4aW5nIGFueSBidWdzIGluIGl0Lg0KPiA+ID4gPg0KPiA+ID4gPiBB
bmQgUEhZcyBhcmUgY29tbW9kaXR5IGRldmljZXMuIEkgZG91YnQgdGhlcmUgaXMgYW55IHZhbHVl
IGFkZCBpbg0KPiA+ID4gPiB0aGUgZmlybXdhcmUgZm9yIGEgUEhZLCBhbnkgcmVhbCBJUFIgd2hp
Y2ggbWFrZXMgdGhlIHByb2R1Y3QNCj4gPiA+ID4gYmV0dGVyLCBtYWdpYyBzYXVjZSByZWxhdGVk
IHRvIHRoZSBQSFkuIFNvIGp1c3Qgc2F2ZSB0aGUgY29zdCBvZg0KPiA+ID4gPiB3cml0aW5nIGFu
ZCBtYWludGFpbmluZyBmaXJtd2FyZSwgZXhwb3J0IHRoZSBNRElPIGJ1cywgYW5kIGxldCBMaW51
eA0KPiBjb250cm9sIGl0Lg0KPiA+ID4gPiBDb25jZW50cmF0ZSB0aGUgZW5naW5lZXJzIG9uIHRo
ZSBpbnRlcmVzdGluZyBwYXJ0cyBvZiB0aGUgTklDLCB0aGUNCj4gPiA+ID4gU21hcnQgcGFydHMs
IHdoZXJlIHRoZXJlIGNhbiBiZSByZWFsIElQUi4NCj4gPiA+ID4NCj4gPiA+ID4gQW5kIGkgd291
bGQgc2F5IHRoaXMgaXMgdHJ1ZSBmb3IgYW55IE5JQy4gTGV0IExpbnV4IGNvbnRyb2wgdGhlIFBI
WS4NCj4gPiA+DQo+ID4gPiBJdCBtYXkgYmUgdHJ1ZSBmb3Igb2xkIEdiRSBQSFlzIHdoZXJlIGl0
4oCZcyBhIGRpc2NyZXRlIGNoaXAgZnJvbSB0aGUNCj4gPiA+IGxpa2VzIG9mIE1hcnZlbGwgb3Ig
YnJvYWRjb20NCj4gPiA+DQo+ID4gPiBCdXQgYXQgMjUvNTAvMTAwRywgdGhlIFBIeSBpcyBhY3R1
YWxseSBwYXJ0IG9mIHRoZSBuaWMuIEl04oCZcyBhIHZlcnkNCj4gPiA+IGNvbXBsZXggU0VSREVT
LiAgQ2xvdWQgcHJvdmlkZXJzIGxpa2UgdXMgc3BlbmQgZW5vcm1vdXMgYW1vdW50IG9mDQo+ID4g
PiB0aW1lIHRlc3RpbmcgdGhlIFBIWSBhY3Jvc3MgcHJvY2VzcyBhbmQgdm9sdGFnZSB2YXJpYXRp
b25zLCBhbGwNCj4gPiA+IGNhYmxlIHR5cGVzLCBsZW5ndGggYW5kIG1hbnVmYWN0dXJpbmcgdmFy
aWF0aW9ucywgYW5kIGFnYWluc3QgYWxsDQo+ID4gPiBzd2l0Y2hlcyB3ZSB1c2UuICBDb21tdW5p
dHkgZHJpdmVycyB3b27igJl0IGJlIGFibGUgdG8gdmFsaWRhdGUgYW5kDQo+ID4gPiB0dW5lIGFs
bCB0aGlzLg0KPiA+ID4NCj4gPiA+IFBsdXMgd2Ugd291bGQgbmVlZCBleGFjdCBzYW1lIHNldHRp
bmcgZm9yIExpbnV4LCBpbmNsdWRpbmcgYWxsDQo+ID4gPiBkaXN0cmlidXRpb25zIGV2ZW4gMTB5
ZWFyIG9sZCBsaWtlIFJIRUw2LCBmb3IgYWxsIFdpbmRvd3MsIEVTWCwNCj4gPiA+IERQREssIEZy
ZWVCU0QsICBhbmQgc3VwcG9ydCBtaWxsaW9ucyBvZiBkaWZmZXJlbnQgY3VzdG9tZXJzIHdpdGgN
Cj4gPiA+IGRpZmZlcmVudCBzZXRzIG9mIE1hY2hpbmUgaW1hZ2VzLg0KPiA+ID4NCj4gPiA+IElu
IHRoaXMgY2FzZSwgdGhlcmUgaXMgbm8gcHJhY3RpY2FsIGNob2ljZSBieSBoYXZlIHRoZSBmaXJt
d2FyZSB0bw0KPiA+ID4gbWFuYWdlIHRoZSBQSFkNCj4gPg0KPiA+IEkgZG9uJ3QgcXVpdGUga25v
dyB3aHkgd2UncmUgdGFsa2luZyBhYm91dCBQSFlzIGluIHRoaXMgY29udGV4dC4NCj4gPiBFTkEg
aXMgYmFzaWNhbGx5IGEgdmlydGlvIE5JQy4gSXQgaGFzIG5vIFBIWS4NCj4gDQo+IEkgYnJvdWdo
dCBpdCB1cCBhcyBhbiBleGFtcGxlLCB0byBpbGx1c3RyYXRlIHRoYXQgd2UnZCByYXRoZXIgc2Vl
IGxlc3MgdHJ1c3QgYW5kDQo+IGNvbnRyb2wgYmVpbmcgYmxpbmRseSBoYW5kZWQgb3ZlciB0byB0
aGUgZmlybXdhcmUuDQo+IA0KPiBXb3VsZCB5b3UgbWluZCBhbnN3ZXJpbmcgd2hhdCBhcmUgdGhl
IGV4YW1wbGVzIG9mIHZlcnkgaW1wb3J0YW50IGZsYWdzDQo+IHlvdSBuZWVkIHRvIGV4cG9zZSB0
byB1c2VycyB3aXRoIDEweW8ga2VybmVscz8gIE9yIGFueSBleGFtcGxlcyBmb3IgdGhhdA0KPiBt
YXR0ZXIuLg0K
