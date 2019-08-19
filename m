Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0DDA991CF8
	for <lists+netdev@lfdr.de>; Mon, 19 Aug 2019 08:21:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726541AbfHSGUo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 02:20:44 -0400
Received: from mail-eopbgr80080.outbound.protection.outlook.com ([40.107.8.80]:30531
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726390AbfHSGUo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Aug 2019 02:20:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EqcyTwMvL9bpfXhgSn369r2IPqUkQKWOQOurZTBlf2kAgxuAu2dCzxsBqyxXoDrS2Oqjo0PA3PQdceQV6ABve3Fpo1zF/OTHIgNHUTEqIILo2ZG3ang7hnwoP3hVg5bhZOgN+b841seKb49BLFoVQZHtoJv4wqVXo+a5eHqfBHOGKDnQsaYR4Y/nmOxGgDtGGE8lR+Uce1zNhYR502ijf+49uQqQla1APEm7wfg880pqhYc6Z88w2Bwld5KE34ox5MtpG4C+g1HK44ZHNZuEPYPzc7sqcWxrRNWcRDHn8NwI+bw17m1GYJuX1QTZFWCQ4ZsoZVFCSKR27atb6m3T3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vzdXg1GJfogyXN5KNtQ+i4UazbHcCqY9PPNr1UALYyc=;
 b=WFErqG2P0CizAd7ezUo6MniAh2tCwx8btQllj7Aqlfs0wM5M85Ed635AQrPMk3KO3QR0XQBDc9xhKTdxB3x++zj2MQdY4Ula8RfMYbPksHF8siFLHGeSBVrhgm72YuSqsEfWY70HSsTZT4qUXsAQeRMNqnRDpV0Ge4Y4yvtrIRW0eYU5HryJB8AQBCZ+IPTbIrBAx/17ok3hcEQFd922qjE+0LTDrgh7j1mJkAgAdBWNLRvkgyY6FhmGf9mutlSnZnR2U3CxkaXcGG9QG4NVmE6u0dzYXNoms2BvKfb1tLRUSHykY74+FS8fRhteK/D3ueG5iah6EmcSfceU2t3sgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vzdXg1GJfogyXN5KNtQ+i4UazbHcCqY9PPNr1UALYyc=;
 b=IcY+JddSRymGUEd36V7HXZiuKsYclNcXRKMGPuvvkFru28ScEY1B8XY9XRlkO4UjbIeLbdLm6iu8UXyxLQIBFxqv/8v8RKqb3/8HL0mLyrbjSets8iklE0Ns87WtsrT17jETNMw6M5jQdVAyGNRL9PqlPWry0R1sRJDVOKSIsuc=
Received: from AM4PR05MB3411.eurprd05.prod.outlook.com (10.171.190.30) by
 AM4PR05MB3204.eurprd05.prod.outlook.com (10.171.186.33) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.18; Mon, 19 Aug 2019 06:20:26 +0000
Received: from AM4PR05MB3411.eurprd05.prod.outlook.com
 ([fe80::d027:14a2:95db:6f1f]) by AM4PR05MB3411.eurprd05.prod.outlook.com
 ([fe80::d027:14a2:95db:6f1f%7]) with mapi id 15.20.2178.018; Mon, 19 Aug 2019
 06:20:26 +0000
From:   Paul Blakey <paulb@mellanox.com>
To:     Pravin B Shelar <pshelar@ovn.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Justin Pettit <jpettit@nicira.com>,
        Simon Horman <simon.horman@netronome.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Vlad Buslov <vladbu@mellanox.com>
CC:     Jiri Pirko <jiri@mellanox.com>, Roi Dayan <roid@mellanox.com>,
        Yossi Kuperman <yossiku@mellanox.com>,
        Rony Efraim <ronye@mellanox.com>, Oz Shlomo <ozsh@mellanox.com>
Subject: Re: [PATCH net-next] net: openvswitch: Set OvS recirc_id from tc
 chain
Thread-Topic: [PATCH net-next] net: openvswitch: Set OvS recirc_id from tc
 chain
Thread-Index: AQHVVd4vntP1emxsQEi9o1hhY1fsp6cCAKAA
Date:   Mon, 19 Aug 2019 06:20:26 +0000
Message-ID: <5465b87e-9365-54d2-8b2f-f2107e33ad79@mellanox.com>
References: <1566144059-8247-1-git-send-email-paulb@mellanox.com>
In-Reply-To: <1566144059-8247-1-git-send-email-paulb@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MR2P264CA0001.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:500:1::13) To AM4PR05MB3411.eurprd05.prod.outlook.com
 (2603:10a6:205:b::30)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=paulb@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [193.47.165.251]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 85bea3f8-11a9-4408-5558-08d7246d5331
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:AM4PR05MB3204;
x-ms-traffictypediagnostic: AM4PR05MB3204:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM4PR05MB3204FB3B66BBBFCE8CB1E507CFA80@AM4PR05MB3204.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-forefront-prvs: 0134AD334F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(39860400002)(346002)(366004)(136003)(396003)(199004)(189003)(31696002)(81166006)(81156014)(66066001)(8676002)(36756003)(52116002)(86362001)(8936002)(6116002)(4326008)(5660300002)(3846002)(478600001)(25786009)(256004)(14444005)(6246003)(53936002)(31686004)(14454004)(7736002)(71200400001)(71190400001)(107886003)(305945005)(2906002)(6506007)(486006)(102836004)(476003)(66946007)(53546011)(2616005)(386003)(6436002)(64756008)(66556008)(66446008)(66476007)(99286004)(11346002)(2501003)(110136005)(54906003)(446003)(26005)(186003)(6512007)(316002)(6486002)(76176011)(229853002)(6636002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR05MB3204;H:AM4PR05MB3411.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Gz4S008rlQWXXetjzHbJU5LAS8V+6qxK7u1Y7uCxh9ROMmSbFWhuNsYIO7qXAoJVOFUTMScZ7vgGSfrpfpBwhUMFIy/WYe9UE/DaTW6zd6NGV39DOVQD9gUwrOXqAChBWYClP0akAyCAJYDODSkTd+n2XNR4RsjzcqiuTX0Tt9s4EsUrFzkOAs5bpQ3xhwOdR2NxylpqPhK1cEEhh69Jubb3IhlREAZs1VE3D7zyL/P1HZNlt7duFHXRVp5oXprPwoqSXh4fDfVYoXW28c1d5HSa99mLBz/uX5m6KuffifykuBAgEHNYtw9RqC3n//jO0Nr+lVPCzDYTeYN7g21+uQkYfHu9jSIzY9T85aJvftdzczxShUs8+wO5hXUtSnqrMwTgjNDKT/SEA8cWiR6J8fWUeyiTOvqahTZd+IhXZpA=
Content-Type: text/plain; charset="utf-8"
Content-ID: <90BD0FC74014284BB1404A837D1A37ED@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 85bea3f8-11a9-4408-5558-08d7246d5331
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Aug 2019 06:20:26.4780
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +aNsqZ1ICNreRUjdsoxlFc1QHhdE3xejDAN/bQpohtWH7eFVjQBZEx6u1BG/lZz9+sUWH96//0AHaZXDI4Wpsg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR05MB3204
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpPbiA4LzE4LzIwMTkgNzowMCBQTSwgUGF1bCBCbGFrZXkgd3JvdGU6DQo+IFdoYXQgZG8geW91
IGd1eXMgc2F5IGFib3V0IHRoZSBmb2xsb3dpbmcgZGlmZiBvbiB0b3Agb2YgdGhlIGxhc3Qgb25l
Pw0KPiBVc2Ugc3RhdGljIGtleSwgYW5kIGFsc28gaGF2ZSBPVlNfRFBfQ01EX1NFVCBjb21tYW5k
IHByb2JlL2VuYWJsZSB0aGUgZmVhdHVyZS4NCj4NCj4gVGhpcyB3aWxsIGFsbG93IHVzZXJzcGFj
ZSB0byBwcm9iZSB0aGUgZmVhdHVyZSwgYW5kIHNlbGVjdGl2bHkgZW5hYmxlIGl0IHZpYSB0aGUN
Cj4gT1ZTX0RQX0NNRF9TRVQgY29tbWFuZC4NCj4NCj4gVGhhbnNrLA0KPiBQYXVsLg0KPg0KPg0K
PiAtLS0NCj4gICBpbmNsdWRlL3VhcGkvbGludXgvb3BlbnZzd2l0Y2guaCB8ICAzICsrKw0KPiAg
IG5ldC9vcGVudnN3aXRjaC9kYXRhcGF0aC5jICAgICAgIHwgMjkgKysrKysrKysrKysrKysrKysr
KysrKysrKy0tLS0NCj4gICBuZXQvb3BlbnZzd2l0Y2gvZGF0YXBhdGguaCAgICAgICB8ICAyICsr
DQo+ICAgbmV0L29wZW52c3dpdGNoL2Zsb3cuYyAgICAgICAgICAgfCAgNiArKysrLS0NCj4gICA0
IGZpbGVzIGNoYW5nZWQsIDM0IGluc2VydGlvbnMoKyksIDYgZGVsZXRpb25zKC0pDQo+DQo+IGRp
ZmYgLS1naXQgYS9pbmNsdWRlL3VhcGkvbGludXgvb3BlbnZzd2l0Y2guaCBiL2luY2x1ZGUvdWFw
aS9saW51eC9vcGVudnN3aXRjaC5oDQo+IGluZGV4IGYyNzFmMWUuLjE4ODdhNDUgMTAwNjQ0DQo+
IC0tLSBhL2luY2x1ZGUvdWFwaS9saW51eC9vcGVudnN3aXRjaC5oDQo+ICsrKyBiL2luY2x1ZGUv
dWFwaS9saW51eC9vcGVudnN3aXRjaC5oDQo+IEBAIC0xMjMsNiArMTIzLDkgQEAgc3RydWN0IG92
c192cG9ydF9zdGF0cyB7DQo+ICAgLyogQWxsb3cgZGF0YXBhdGggdG8gYXNzb2NpYXRlIG11bHRp
cGxlIE5ldGxpbmsgUElEcyB0byBlYWNoIHZwb3J0ICovDQo+ICAgI2RlZmluZSBPVlNfRFBfRl9W
UE9SVF9QSURTCSgxIDw8IDEpDQo+ICAgDQo+ICsvKiBBbGxvdyB0YyBvZmZsb2FkIHJlY2lyYyBz
aGFyaW5nICovDQo+ICsjZGVmaW5lIE9WU19EUF9GX1RDX1JFQ0lSQ19TSEFSSU5HCSgxIDw8IDIp
DQo+ICsNCj4gICAvKiBGaXhlZCBsb2dpY2FsIHBvcnRzLiAqLw0KPiAgICNkZWZpbmUgT1ZTUF9M
T0NBTCAgICAgICgoX191MzIpMCkNCj4gICANCj4gZGlmZiAtLWdpdCBhL25ldC9vcGVudnN3aXRj
aC9kYXRhcGF0aC5jIGIvbmV0L29wZW52c3dpdGNoL2RhdGFwYXRoLmMNCj4gaW5kZXggODkyMjg3
ZC4uNTg5YjRmMSAxMDA2NDQNCj4gLS0tIGEvbmV0L29wZW52c3dpdGNoL2RhdGFwYXRoLmMNCj4g
KysrIGIvbmV0L29wZW52c3dpdGNoL2RhdGFwYXRoLmMNCj4gQEAgLTE1NDEsMTAgKzE1NDEsMjcg
QEAgc3RhdGljIHZvaWQgb3ZzX2RwX3Jlc2V0X3VzZXJfZmVhdHVyZXMoc3RydWN0IHNrX2J1ZmYg
KnNrYiwgc3RydWN0IGdlbmxfaW5mbyAqaW4NCj4gICAJZHAtPnVzZXJfZmVhdHVyZXMgPSAwOw0K
PiAgIH0NCj4gICANCj4gLXN0YXRpYyB2b2lkIG92c19kcF9jaGFuZ2Uoc3RydWN0IGRhdGFwYXRo
ICpkcCwgc3RydWN0IG5sYXR0ciAqYVtdKQ0KPiArREVGSU5FX1NUQVRJQ19LRVlfRkFMU0UodGNf
cmVjaXJjX3NoYXJpbmdfc3VwcG9ydCk7DQo+ICsNCj4gK3N0YXRpYyBpbnQgb3ZzX2RwX2NoYW5n
ZShzdHJ1Y3QgZGF0YXBhdGggKmRwLCBzdHJ1Y3QgbmxhdHRyICphW10pDQo+ICAgew0KPiArCXUz
MiB1c2VyX2ZlYXR1cmVzOw0KPiArDQo+ICAgCWlmIChhW09WU19EUF9BVFRSX1VTRVJfRkVBVFVS
RVNdKQ0KPiAtCQlkcC0+dXNlcl9mZWF0dXJlcyA9IG5sYV9nZXRfdTMyKGFbT1ZTX0RQX0FUVFJf
VVNFUl9GRUFUVVJFU10pOw0KPiArCQl1c2VyX2ZlYXR1cmVzID0gbmxhX2dldF91MzIoYVtPVlNf
RFBfQVRUUl9VU0VSX0ZFQVRVUkVTXSk7DQo+ICsNCj4gKyNpZiAhSVNfRU5BQkxFRChDT05GSUdf
TkVUX1RDX1NLQl9FWFQpDQo+ICsJaWYgKHVzZXJfZmVhdHVyZXMgJiBPVlNfRFBfRl9UQ19SRUNJ
UkNfU0hBUklORykNCj4gKwkJcmV0dXJuIC1FT1BOT1RTVVBQOw0KPiArI2VuZGlmDQo+ICsJZHAt
PnVzZXJfZmVhdHVyZXMgPSB1c2VyX2ZlYXR1cmVzOw0KPiArDQo+ICsJaWYgKGRwLT51c2VyX2Zl
YXR1cmVzICYgT1ZTX0RQX0ZfVENfUkVDSVJDX1NIQVJJTkcpDQo+ICsJCXN0YXRpY19icmFuY2hf
ZW5hYmxlKCZ0Y19yZWNpcmNfc2hhcmluZ19zdXBwb3J0KTsNCj4gKwllbHNlDQo+ICsJCXN0YXRp
Y19icmFuY2hfZGlzYWJsZSgmdGNfcmVjaXJjX3NoYXJpbmdfc3VwcG9ydCk7DQo+ICsNCj4gKwly
ZXR1cm4gMDsNCj4gICB9DQo+ICAgDQo+ICAgc3RhdGljIGludCBvdnNfZHBfY21kX25ldyhzdHJ1
Y3Qgc2tfYnVmZiAqc2tiLCBzdHJ1Y3QgZ2VubF9pbmZvICppbmZvKQ0KPiBAQCAtMTYwNiw3ICsx
NjIzLDkgQEAgc3RhdGljIGludCBvdnNfZHBfY21kX25ldyhzdHJ1Y3Qgc2tfYnVmZiAqc2tiLCBz
dHJ1Y3QgZ2VubF9pbmZvICppbmZvKQ0KPiAgIAlwYXJtcy5wb3J0X25vID0gT1ZTUF9MT0NBTDsN
Cj4gICAJcGFybXMudXBjYWxsX3BvcnRpZHMgPSBhW09WU19EUF9BVFRSX1VQQ0FMTF9QSURdOw0K
PiAgIA0KPiAtCW92c19kcF9jaGFuZ2UoZHAsIGEpOw0KPiArCWVyciA9IG92c19kcF9jaGFuZ2Uo
ZHAsIGEpOw0KPiArCWlmIChlcnIpDQo+ICsJCWdvdG8gZXJyX2Rlc3Ryb3lfbWV0ZXJzOw0KPiAg
IA0KPiAgIAkvKiBTbyBmYXIgb25seSBsb2NhbCBjaGFuZ2VzIGhhdmUgYmVlbiBtYWRlLCBub3cg
bmVlZCB0aGUgbG9jay4gKi8NCj4gICAJb3ZzX2xvY2soKTsNCj4gQEAgLTE3MzIsNyArMTc1MSw5
IEBAIHN0YXRpYyBpbnQgb3ZzX2RwX2NtZF9zZXQoc3RydWN0IHNrX2J1ZmYgKnNrYiwgc3RydWN0
IGdlbmxfaW5mbyAqaW5mbykNCj4gICAJaWYgKElTX0VSUihkcCkpDQo+ICAgCQlnb3RvIGVycl91
bmxvY2tfZnJlZTsNCj4gICANCj4gLQlvdnNfZHBfY2hhbmdlKGRwLCBpbmZvLT5hdHRycyk7DQo+
ICsJZXJyID0gb3ZzX2RwX2NoYW5nZShkcCwgaW5mby0+YXR0cnMpOw0KPiArCWlmIChlcnIpDQo+
ICsJCWdvdG8gZXJyX3VubG9ja19mcmVlOw0KPiAgIA0KPiAgIAllcnIgPSBvdnNfZHBfY21kX2Zp
bGxfaW5mbyhkcCwgcmVwbHksIGluZm8tPnNuZF9wb3J0aWQsDQo+ICAgCQkJCSAgIGluZm8tPnNu
ZF9zZXEsIDAsIE9WU19EUF9DTURfU0VUKTsNCj4gZGlmZiAtLWdpdCBhL25ldC9vcGVudnN3aXRj
aC9kYXRhcGF0aC5oIGIvbmV0L29wZW52c3dpdGNoL2RhdGFwYXRoLmgNCj4gaW5kZXggNzUxZDM0
YS4uODFlODVkZCAxMDA2NDQNCj4gLS0tIGEvbmV0L29wZW52c3dpdGNoL2RhdGFwYXRoLmgNCj4g
KysrIGIvbmV0L29wZW52c3dpdGNoL2RhdGFwYXRoLmgNCj4gQEAgLTIxOCw2ICsyMTgsOCBAQCBz
dGF0aWMgaW5saW5lIHN0cnVjdCBkYXRhcGF0aCAqZ2V0X2RwKHN0cnVjdCBuZXQgKm5ldCwgaW50
IGRwX2lmaW5kZXgpDQo+ICAgZXh0ZXJuIHN0cnVjdCBub3RpZmllcl9ibG9jayBvdnNfZHBfZGV2
aWNlX25vdGlmaWVyOw0KPiAgIGV4dGVybiBzdHJ1Y3QgZ2VubF9mYW1pbHkgZHBfdnBvcnRfZ2Vu
bF9mYW1pbHk7DQo+ICAgDQo+ICtERUNMQVJFX1NUQVRJQ19LRVlfRkFMU0UodGNfcmVjaXJjX3No
YXJpbmdfc3VwcG9ydCk7DQo+ICsNCj4gICB2b2lkIG92c19kcF9wcm9jZXNzX3BhY2tldChzdHJ1
Y3Qgc2tfYnVmZiAqc2tiLCBzdHJ1Y3Qgc3dfZmxvd19rZXkgKmtleSk7DQo+ICAgdm9pZCBvdnNf
ZHBfZGV0YWNoX3BvcnQoc3RydWN0IHZwb3J0ICopOw0KPiAgIGludCBvdnNfZHBfdXBjYWxsKHN0
cnVjdCBkYXRhcGF0aCAqLCBzdHJ1Y3Qgc2tfYnVmZiAqLA0KPiBkaWZmIC0tZ2l0IGEvbmV0L29w
ZW52c3dpdGNoL2Zsb3cuYyBiL25ldC9vcGVudnN3aXRjaC9mbG93LmMNCj4gaW5kZXggMDI4N2Vh
ZC4uYzBhYzdjOSAxMDA2NDQNCj4gLS0tIGEvbmV0L29wZW52c3dpdGNoL2Zsb3cuYw0KPiArKysg
Yi9uZXQvb3BlbnZzd2l0Y2gvZmxvdy5jDQo+IEBAIC04NTMsOCArODUzLDEwIEBAIGludCBvdnNf
Zmxvd19rZXlfZXh0cmFjdChjb25zdCBzdHJ1Y3QgaXBfdHVubmVsX2luZm8gKnR1bl9pbmZvLA0K
PiAgIAlrZXktPm1hY19wcm90byA9IHJlczsNCj4gICANCj4gICAjaWYgSVNfRU5BQkxFRChDT05G
SUdfTkVUX1RDX1NLQl9FWFQpDQo+IC0JdGNfZXh0ID0gc2tiX2V4dF9maW5kKHNrYiwgVENfU0tC
X0VYVCk7DQo+IC0Ja2V5LT5yZWNpcmNfaWQgPSB0Y19leHQgPyB0Y19leHQtPmNoYWluIDogMDsN
Cj4gKwlpZiAoc3RhdGljX2JyYW5jaF91bmxpa2VseSgmdGNfcmVjaXJjX3NoYXJpbmdfc3VwcG9y
dCkpIHsNCj4gKwkJdGNfZXh0ID0gc2tiX2V4dF9maW5kKHNrYiwgVENfU0tCX0VYVCk7DQo+ICsJ
CWtleS0+cmVjaXJjX2lkID0gdGNfZXh0ID8gdGNfZXh0LT5jaGFpbiA6IDA7DQo+ICsJfQ0KDQpI
ZXJlIHNob3VsZCBiZQ0KDQplbHNlDQoNCiDCoMKgwqDCoMKgIGtleS0+cmVjaXJjX2lkID0gMA0K
DQo+ICAgI2Vsc2UNCj4gICAJa2V5LT5yZWNpcmNfaWQgPSAwOw0KPiAgICNlbmRpZg0K
