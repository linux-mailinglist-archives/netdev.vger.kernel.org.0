Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 735C3124A8C
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 16:00:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727313AbfLRPAr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 10:00:47 -0500
Received: from mail-eopbgr140087.outbound.protection.outlook.com ([40.107.14.87]:4309
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727053AbfLRPAr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Dec 2019 10:00:47 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NTrb4EDKegDr+CCb2pAF0DrFOx9DwJfLqFBeiwxtaxxbr9qu9MBEun8289PRVE/gvsM31LQmSqC27a8Ecq0BGCCeD7UinuK1S0636QryyBjATcnS9oZCCj96EhAQrg/6GGOVtdZv4XmeF/b2BfVUsfosxn1pDrtcrBWPcXifr/ioMZHm3LMkRjnr1mkTip1adFdxpbJspmEkdXxmHdltgiKb1GlSJFh2kpOzvpXqIGyFyJdcG1iHyBn78y3bRtAleeEd1iOo/n3je7N0Yx7C8QUTUCqQXWVIA2ok+ChKN6thsukkl2rySxn9luE1SpJpqQ+ZZtYXOv+fthbhMTBycg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ivyAxh4yAaGgt+KfF3+nMBh3QBzNj8NxNQPW8ybBsOs=;
 b=fsoeBg0JedIYqLTVwAYNKfbaDEv8sMvS550Psl4D2U7pftaqykJrWCxpqMwoFR5dAEjVO+nBgwTyzf1GWE4qOJahii7LM6+WzjlZeyBYXhTcK0nFaNj/KUgAjSbBD9DJs5BaJFYX2wdzLCQuhbmwzTwwXMo3lmzRufd7zJQmAMM0MBx3XxG0J0MHc4b4MpxRmtk1osi1cbepQlWn2QUWImDyPS5+ACGVOVQE0bHzKmrkeHZ/wuXXPIDCZ/vcT/y1USm5rZljuRoU0Ekfux0+ut4bOg/kasK72eB3AGW/5+5nG/WpTWKtBOvnDvCV51yl6pU/cP80BQWXCbpHx2ZJow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ivyAxh4yAaGgt+KfF3+nMBh3QBzNj8NxNQPW8ybBsOs=;
 b=M4JjwYXN4CybkYmG2mCvrwFaenPZSBZDiT+PLmfVkapLOHA14CF9KTVB1JBtGoiitwRHXyTiQze34ymYhaRu/G7jXrlH9h82XLJ3ocy5uzMHDfF8ZCR5qc4ltOg3O7KrUcs9TlqlQ01fqP7CA1lpLoWwZ4m9oVtMpZhqecfPL1Q=
Received: from VI1PR04MB5567.eurprd04.prod.outlook.com (20.178.123.83) by
 VI1PR04MB6975.eurprd04.prod.outlook.com (52.133.246.211) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.17; Wed, 18 Dec 2019 15:00:42 +0000
Received: from VI1PR04MB5567.eurprd04.prod.outlook.com
 ([fe80::f099:4735:430c:ef1d]) by VI1PR04MB5567.eurprd04.prod.outlook.com
 ([fe80::f099:4735:430c:ef1d%2]) with mapi id 15.20.2559.012; Wed, 18 Dec 2019
 15:00:41 +0000
From:   Alexandru Marginean <alexandru.marginean@nxp.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Vladimir Oltean <olteanv@gmail.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        "Y.b. Lu" <yangbo.lu@nxp.com>, netdev <netdev@vger.kernel.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [RFC PATCH v2 0/8] Convert Felix DSA switch to PHYLINK
Thread-Topic: [RFC PATCH v2 0/8] Convert Felix DSA switch to PHYLINK
Thread-Index: AQHVtSgTRi8iIbz3OE2hW9M9gxOOf6e/tLgAgAAs9ACAAAJsAIAAGWsA
Date:   Wed, 18 Dec 2019 15:00:41 +0000
Message-ID: <e199162b-9b90-0a90-e74e-3b19e542f710@nxp.com>
References: <20191217221831.10923-1-olteanv@gmail.com>
 <20191218104008.GT25745@shell.armlinux.org.uk>
 <CA+h21hrbqggYxzd6SGhBmy3fUbmG2EFqbOHAnkDu8xPYRP7ewg@mail.gmail.com>
 <20191218132942.GU25745@shell.armlinux.org.uk>
In-Reply-To: <20191218132942.GU25745@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=alexandru.marginean@nxp.com; 
x-originating-ip: [178.199.189.248]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 290f135a-c91b-4eee-1037-08d783cb0d24
x-ms-traffictypediagnostic: VI1PR04MB6975:|VI1PR04MB6975:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB697544D63DEC3F6FA3859329F5530@VI1PR04MB6975.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0255DF69B9
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(376002)(366004)(39860400002)(396003)(136003)(199004)(189003)(55674003)(6486002)(2616005)(66946007)(66476007)(5660300002)(36756003)(6512007)(31686004)(44832011)(8676002)(66446008)(81166006)(91956017)(186003)(26005)(53546011)(6506007)(31696002)(2906002)(7416002)(76116006)(478600001)(4326008)(8936002)(81156014)(71200400001)(86362001)(66556008)(110136005)(54906003)(64756008)(316002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR04MB6975;H:VI1PR04MB5567.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: int2gv1ZCNnXoUPnHoVN5ndowrgjC72iLiEJ+q8y7iFj/7J9xcXj3g6EjcwlXKp2Jz2arNSkh7L7n9IUPDVYthJlNEMu0LuNLWUyjEsXogeZ0WEU8/ULmsxXpQw4HSRaAB3H9ywX5yi2/i7/yAiSquXIVB/VlHdvm2ARlIj/l/t8L2kj9cZmgDELJIv4wkvt8SyF8obdLRwVg1GYT9PGxxwZCjDdiHoAiW1Fmpup5538z+ikJDKr213pbMTysBTMhFD8wthcsGyW6HuGECBkNw/7U47K9YdKvhAIMyvqA1sa46XfPwhh8Efr9RAzlftHFPGTW3vnejDFOlLVUdGiuZoBM0FhuS0fxNGqGf7zzI47nP2Fs3NHMme0fRS1fB1Tqfp6reg1bRkm5H8L2Ma4luhsHRYfbt1KBD594uf1+Jl9fTM1A5zQ4CtHiBOT/tIAoW+yW24/HOdoXNGXT+zTyMma0eKE5j0ql0DbXmYkT83XjbwVW5s0PklirD/lZKXB
Content-Type: text/plain; charset="utf-8"
Content-ID: <10D8150951AB5049A33168516BFEBD4D@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 290f135a-c91b-4eee-1037-08d783cb0d24
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Dec 2019 15:00:41.7531
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LXwcrFaC2T2fGEMa5skgT2ZEKKnIKRDRvEGHQzzDxzMHs40MGoDFQt7ojgVEBFbqxz244ot8XAXgIX1hYuh51y7WDTgy1hTDa8mRA14JVWw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6975
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMTIvMTgvMjAxOSAyOjI5IFBNLCBSdXNzZWxsIEtpbmcgLSBBUk0gTGludXggYWRtaW4gd3Jv
dGU6DQo+IE9uIFdlZCwgRGVjIDE4LCAyMDE5IGF0IDAzOjIxOjAyUE0gKzAyMDAsIFZsYWRpbWly
IE9sdGVhbiB3cm90ZToNCj4+IC0gVGhlIGF0ODAzeC5jIGRyaXZlciBleHBsaWNpdGx5IGNoZWNr
cyBmb3IgdGhlIEFDSyBmcm9tIHRoZSBNQUMgUENTLA0KPj4gYW5kIHByaW50cyAiU0dNSUkgbGlu
ayBpcyBub3Qgb2siIG90aGVyd2lzZSwgYW5kIHJlZnVzZXMgdG8gYnJpbmcgdGhlDQo+PiBsaW5r
IHVwLiBUaGlzIGh1cnRzIHVzIGluIDQuMTkgYmVjYXVzZSBJIHRoaW5rIHRoZSBjaGVjayBpcyBh
IGJpdA0KPj4gbWlzcGxhY2VkIGluIHRoZSAuYW5lZ19kb25lIGNhbGxiYWNrLiBUbyBiZSBwcmVj
aXNlLCB3aGF0IHdlIG9ic2VydmUNCj4+IGlzIHRoYXQgdGhpcyBmdW5jdGlvbiBpcyBub3QgY2Fs
bGVkIGJ5IHRoZSBzdGF0ZSBtYWNoaW5lIGEgc2Vjb25kLA0KPj4gdGhpcmQgdGltZSBldGMgdG8g
cmVjaGVjayBpZiB0aGUgQU4gaGFzIGNvbXBsZXRlZCBpbiB0aGUgbWVhbnRpbWUuIEluDQo+PiBj
dXJyZW50IG5ldC1uZXh0LCBhcyBmYXIgYXMgSSBjb3VsZCBmaWd1cmUgb3V0LCBhdDgwM3hfYW5l
Z19kb25lIGlzDQo+PiBkZWFkIGNvZGUuIFdoYXQgaXMgaXJvbmljIGFib3V0IHRoZSBjb21taXQg
ZjYyMjY1YjUzZWYzICgiYXQ4MDN4Og0KPj4gZG91YmxlIGNoZWNrIFNHTUlJIHNpZGUgYXV0b25l
ZyIpIHRoYXQgaW50cm9kdWNlZCB0aGlzIGZ1bmN0aW9uIGlzDQo+PiB0aGF0IGl0J3MgZm9yIHRo
ZSBnaWFuZmFyIGRyaXZlciAoRnJlZXNjYWxlIGVUU0VDKSwgYSBNQUMgdGhhdCBoYXMNCj4+IG5l
dmVyIHN1cHBvcnRlZCByZXByb2dyYW1taW5nIGl0c2VsZiBiYXNlZCBvbiB0aGUgaW4tYmFuZCBj
b25maWcgd29yZC4NCj4+IEluIGZhY3QsIGlmIHlvdSBsb29rIGF0IGdmYXJfY29uZmlndXJlX3Nl
cmRlcywgaXQgZXZlbiBjb25maWd1cmVzIGl0cw0KPj4gcmVnaXN0ZXIgMHg0IHdpdGggYW4gYWR2
ZXJ0aXNlbWVudCBmb3IgMTAwMEJhc2UtWCwgbm90IFNHTUlJICgweDQwMDEpLg0KPj4gU28gSSBy
ZWFsbHkgd29uZGVyIGlmIHRoZXJlIGlzIGFueSByZWFsIHB1cnBvc2UgdG8gdGhpcyBjaGVjayBp
bg0KPj4gYXQ4MDN4X2FuZWdfZG9uZSwgYW5kIGlmIG5vdCwgSSB3b3VsZCByZXNwZWN0ZnVsbHkg
cmVtb3ZlIGl0Lg0KPiANCj4gUGxlYXNlIGNoZWNrIHdoZXRoZXIgYXQ4MDN4IHdpbGwgcGFzcyBk
YXRhIGlmIHRoZSBTR01JSSBjb25maWcgZXhjaGFuZ2UNCj4gaGFzIG5vdCBjb21wbGV0ZWQgLSBJ
J20gYXdhcmUgb2Ygc29tZSBQSFlzIHRoYXQsIGFsdGhvdWdoIGxpbmsgY29tZXMgdXANCj4gb24g
dGhlIGNvcHBlciBzaWRlLCBpZiBBTiBkb2VzIG5vdCBjb21wbGV0ZSBvbiB0aGUgU0dNSUkgc2lk
ZSwgdGhleQ0KPiB3aWxsIG5vdCBwYXNzIGRhdGEsIGV2ZW4gaWYgdGhlIE1BQyBzaWRlIGlzIGZv
cmNlZCB1cC4NCj4gDQo+IEkgZG9uJ3Qgc2VlIGFueSBjb25maWd1cmF0aW9uIGJpdHMgaW4gdGhl
IDgwMzEgdGhhdCBzdWdnZXN0IHRoZSBTR01JSQ0KPiBjb25maWcgZXhjaGFuZ2UgY2FuIGJlIGJ5
cGFzc2VkLg0KPiANCj4+IC0gVGhlIHZzYzg1MTQgUEhZIGRyaXZlciBjb25maWd1cmVzIFNlckRl
cyBBTiBpbiBVLUJvb3QsIGJ1dCBub3QgaW4NCj4+IExpbnV4LiBTbyB3ZSBvYnNlcnZlIHRoYXQg
aWYgd2UgZGlzYWJsZSBQSFkgY29uZmlndXJhdGlvbiBpbiBVLUJvb3QsDQo+PiBpbi1iYW5kIEFO
IGJyZWFrcyBpbiBMaW51eC4gV2UgYXJlIGFjdHVhbGx5IHdvbmRlcmluZyBob3cgd2Ugc2hvdWxk
DQo+PiBmaXggdGhpczogZnJvbSB3aGF0IHlvdSB3cm90ZSBhYm92ZSwgaXQgc2VlbXMgb2sgdG8g
aGFyZGNvZGUgU0dNSUkgQU4NCj4+IGluIHRoZSBQSFkgZHJpdmVyLCBhbmQganVzdCBpZ25vcmUg
aXQgaW4gdGhlIFBDUyBpZiBtYW5hZ2VkID0NCj4+ICJpbi1iYW5kLXN0YXR1cyIgaXMgbm90IHNl
dCB3aXRoIFBIWUxJTksuIEJ1dCBhcyB5b3Ugc2FpZCwgaW4gdGhlDQo+PiBnZW5lcmFsIGNhc2Ug
bWF5YmUgbm90IGFsbCBQSFlzIHdvcmsgdW50aWwgdGhleSBoYXZlbid0IHJlY2VpdmVkIHRoZQ0K
Pj4gQUNLIGZyb20gdGhlIE1BQyBQQ1MsIHdoaWNoIG1ha2VzIHRoaXMgaW5zdWZmaWNpZW50IGFz
IGEgZ2VuZXJhbA0KPj4gc29sdXRpb24uDQo+Pg0KPj4gQnV0IHRoZSAyIGNhc2VzIGFib3ZlIGls
bHVzdHJhdGUgdGhlIGxhY2sgb2YgY29uc2lzdGVuY3kgYW1vbmcgUEhZDQo+PiBkcml2ZXJzIHcu
ci50LiBpbi1iYW5kIGFuZWcuDQo+IA0KPiBJbmRlZWQgLSBpdCdzIHNvbWV0aGluZyBvZiBhIG1p
bmUgZmllbGQgYXQgdGhlIG1vbWVudCwgYmVjYXVzZSB3ZSBhcmVuJ3QNCj4gcXVpdGUgc3VyZSB3
aGV0aGVyICJTR01JSSIgbWVhbnMgdGhhdCB0aGUgUEhZIHJlcXVpcmVzIGluLWJhbmQgQU4gb3IN
Cj4gZG9lc24ndCBwcm92aWRlIGl0LiBGb3IgdGhlIEJyb2FkY29tIGNhc2UgSSBtZW50aW9uZWQs
IHdoZW4gaXQncyB1c2VkIG9uDQo+IGEgU0ZQLCBJJ3ZlIGhhZCB0byBhZGQgYSBxdWlyayB0byBw
aHlsaW5rIHRvIHdvcmsgYXJvdW5kIGl0Lg0KPiANCj4gVGhlIHByb2JsZW0gaXMsIGl0J3Mgbm90
IGEgY2FzZSB0aGF0IHRoZSBNQUMgY2FuIGRlbWFuZCB0aGF0IHRoZSBQSFkNCj4gcHJvdmlkZXMg
aW4tYmFuZCBjb25maWcgLSBzb21lIFBIWXMgYXJlIGluY2FwYWJsZSBvZiBkb2luZyBzby4gV2hh
dGV2ZXINCj4gc29sdXRpb24gd2UgY29tZSB1cCB3aXRoIG5lZWRzIHRvIGJlIGEgIm5lZ290aWF0
aW9uIiBiZXR3ZWVuIHRoZSBQSFkNCj4gZHJpdmVyIGFuZCB0aGUgTUFDIGRyaXZlciBmb3IgaXQg
dG8gd29yayB3ZWxsIGluIHRoZSBrbm93biBzY2VuYXJpb3MgLQ0KPiBsaWtlIHRoZSBjYXNlIHdp
dGggdGhlIEJyb2FkY29tIFBIWSBvbiBhIFNGUCB0aGF0IGNhbiBiZSBwbHVnZ2VkIGludG8NCj4g
YW55IFNGUCBzdXBwb3J0aW5nIG5ldHdvcmsgaW50ZXJmYWNlLi4uDQoNClNvbWUgc29ydCBvZiBj
YXBhYmlsaXR5IG5lZ290aWF0aW9uIGRvZXMgc2VlbSB0byBiZSB0aGUgcHJvcGVyIHNvbHV0aW9u
Lg0KV2UgY2FuIGhhdmUgYSBuZXcgY2FwYWJpbGl0aWVzIGZpZWxkIGluIHBoeWRldiBmb3Igc3lz
dGVtIGludGVyZmFjZSANCmNhcGFiaWxpdGllcyBhbmQgbWF0Y2ggdGhhdCB3aXRoIE1BQyBjYXBh
YmlsaXRpZXMsIGNvbmZpZ3VyYXRpb24sIGZhY3RvciANCmluIHRoZSBxdWlya3MuICBUaGUgcmVz
dWx0IHdvdWxkIHRlbGwgaWYgYSBzb2x1dGlvbiBpcyBwb3NzaWJsZSwgDQplc3BlY2lhbGx5IHdp
dGggcXVpcmt5IFBIWXMsIGFuZCBpZiBQSFkgZHJpdmVycyBuZWVkIHRvIGVuYWJsZSBBTi4NCg0K
VW50aWwgd2UgaGF2ZSB0aGF0IGluIHBsYWNlLCBhbnkgcmVjb21tZW5kZWQgYXBwcm9hY2ggZm9y
IFBIWSBkcml2ZXJzLCANCmlzIGl0IGFjY2VwdGFibGUgdG8gaGFyZGNvZGUgc3lzdGVtIHNpZGUg
QU4gb24gYXMgYSBzaG9ydCB0ZXJtIGZpeD8NCkkndmUganVzdCB0ZXN0ZWQgVlNDODUxNCBhbmQg
aXQgZG9lc24ndCBhbGxvdyB0cmFmZmljIHRocm91Z2ggaWYgU0kgQU4gDQppcyBlbmFibGVkIGJ1
dCBkb2VzIG5vdCBjb21wbGV0ZS4gIFdlIGRvIHVzZSBpdCB3aXRoIEFOIG9uIG9uIE5YUCANCnN5
c3RlbXMsIGFuZCBpdCBvbmx5IHdvcmtzIGJlY2F1c2UgVS1Cb290IHNldHMgdGhpbmdzIHVwIHRo
YXQgd2F5LCBidXQgDQpyZWx5aW5nIG9uIFUtQm9vdCBpc24ndCBncmVhdC4NCkFxdWFudGlhIFBI
WXMgd2UgdXNlIGFsc28gcmVxdWlyZSBBTiB0byBjb21wbGV0ZSBpZiBlbmFibGVkLiAgRm9yIHRo
ZW0gDQpMaW51eCBkZXBlbmRzIG9uIFUtQm9vdCBvciBvbiBQSFkgZmlybXdhcmUgdG8gZW5hYmxl
IEFOLiAgSSBkb24ndCBrbm93IA0KaWYgYW55b25lIG91dCB0aGVyZSB1c2VzIHRoZXNlIFBIWXMg
d2l0aCBBTiBvZmYuICBXb3VsZCBhIHBhdGNoIHRoYXQgDQpoYXJkY29kZXMgQU4gb24gZm9yIGFu
eSBvZiB0aGVzZSBQSFlzIGJlIGFjY2VwdGFibGU/DQoNClRoYW5rcyENCkFsZXg=
