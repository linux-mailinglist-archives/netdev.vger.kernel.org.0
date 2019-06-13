Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9302743864
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 17:06:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732822AbfFMPFe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 11:05:34 -0400
Received: from mail-eopbgr60075.outbound.protection.outlook.com ([40.107.6.75]:12931
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732437AbfFMOOG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Jun 2019 10:14:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0aXWBayf4R3+IXtqwrz2O1nLMH8KtHAyDCo3TTGfesE=;
 b=sk6kYf6a9rNpcT790YymkudNcd0e5vcKZxY3yFZWDqTPOGg3dObxmf9sTbjItmbE6D2vlm0oCAithQS7hRJ/QMYrtM26wRawLaWZgibM2qSlwF/ZnSzWJbtTzCeTexTecn5G82EOE6hXxlJA6AiW3mi5xmBEDI30C0m34jIs16g=
Received: from AM6PR05MB5879.eurprd05.prod.outlook.com (20.179.0.76) by
 AM6PR05MB6263.eurprd05.prod.outlook.com (20.177.36.33) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1965.15; Thu, 13 Jun 2019 14:13:22 +0000
Received: from AM6PR05MB5879.eurprd05.prod.outlook.com
 ([fe80::9527:fe9d:2a02:41d5]) by AM6PR05MB5879.eurprd05.prod.outlook.com
 ([fe80::9527:fe9d:2a02:41d5%5]) with mapi id 15.20.1987.010; Thu, 13 Jun 2019
 14:13:22 +0000
From:   Maxim Mikityanskiy <maximmi@mellanox.com>
To:     Jonas Bonn <jonas@norrbonn.se>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Subject: Re: [PATCH 1/1] Address regression in inet6_validate_link_af
Thread-Topic: [PATCH 1/1] Address regression in inet6_validate_link_af
Thread-Index: AQHVIDzu/Smg4fm3OEOQVEC2DfH3j6aX1piAgAFP+QCAAH04gA==
Date:   Thu, 13 Jun 2019 14:13:22 +0000
Message-ID: <323df302-aa17-df40-846d-3354d4bb126a@mellanox.com>
References: <20190611100327.16551-1-jonas@norrbonn.se>
 <58ac6ec1-9255-0e51-981a-195c2b1ac380@mellanox.com>
 <833019dc-476f-f604-04a6-d77f9f86a5f4@norrbonn.se>
In-Reply-To: <833019dc-476f-f604-04a6-d77f9f86a5f4@norrbonn.se>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BYAPR08CA0050.namprd08.prod.outlook.com
 (2603:10b6:a03:117::27) To AM6PR05MB5879.eurprd05.prod.outlook.com
 (2603:10a6:20b:a2::12)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=maximmi@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [159.224.90.213]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2cda1858-4e54-4c5f-4d68-08d6f0094afc
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM6PR05MB6263;
x-ms-traffictypediagnostic: AM6PR05MB6263:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <AM6PR05MB6263121466EA3DC62E3A317ED1EF0@AM6PR05MB6263.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:256;
x-forefront-prvs: 0067A8BA2A
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(396003)(366004)(346002)(136003)(376002)(189003)(199004)(52314003)(478600001)(66946007)(110136005)(36756003)(76176011)(64756008)(5660300002)(53936002)(102836004)(386003)(4326008)(55236004)(14454004)(53546011)(6246003)(6506007)(66066001)(66476007)(966005)(2501003)(316002)(73956011)(66556008)(66446008)(305945005)(7736002)(14444005)(3846002)(2906002)(71200400001)(6512007)(8936002)(26005)(2201001)(6436002)(54906003)(6306002)(486006)(25786009)(81166006)(11346002)(31686004)(68736007)(446003)(256004)(99286004)(6486002)(229853002)(186003)(52116002)(6116002)(81156014)(476003)(2616005)(31696002)(8676002)(71190400001)(86362001);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR05MB6263;H:AM6PR05MB5879.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: sIqJ2bU1ebEBxWEcJeTQMScfE5WQ/PFwJB1CygQRNLYW1sp4KV/VU9+ExcobHFgEQm2abc9G12HbX6UN33SvQaya13QZEZkk/4BJfjmrrerOaFKIMIEO4cPutUXu0yLSF8t2fncdqJcAjwZ6xq7b7mvF+9R3zo0I3jfLYXCe8jYTxkcaO2hyXd7ZAsyqvK4j+58385hK1JaBziqAB2HHqZhuEUJd10NwYNe7/S76LKaSDiKuielo68k65OPBDIRwvxe7FhzQpZCrqoEXe4Oody8utFxkde4hiyyP1U+GQGxN9rY5/Xmtz5LugQQwe440RukoSCkRem2scK9ipkJwHpDbE3h97dQJQEoHn0CFIDo0gJiR4UlTe/Tx9E5l+S9XZLknZlnoLCKjYmFkrdC6ghS2ydlG5PCvaT8LXJU19cY=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D8E71783A23337408CC4EAC93B292F08@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2cda1858-4e54-4c5f-4d68-08d6f0094afc
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jun 2019 14:13:22.6322
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: maximmi@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB6263
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMjAxOS0wNi0xMyAwOTo0NSwgSm9uYXMgQm9ubiB3cm90ZToNCj4gSGkgTWF4LA0KPiANCj4g
T24gMTIvMDYvMjAxOSAxMjo0MiwgTWF4aW0gTWlraXR5YW5za2l5IHdyb3RlOg0KPj4gT24gMjAx
OS0wNi0xMSAxMzowMywgSm9uYXMgQm9ubiB3cm90ZToNCj4+PiBQYXRjaCA3ZGMyYmNjYWIwZWUz
N2FjMjgwOTZiOGZjZGMzOTBhNjc5YTE1ODQxIGludHJvZHVjZXMgYSByZWdyZXNzaW9uDQo+Pj4g
d2l0aCBzeXN0ZW1kIDI0MS7CoCBJbiB0aGF0IHJldmlzaW9uLCBzeXN0ZW1kLW5ldHdvcmtkIGZh
aWxzIHRvIHBhc3MgdGhlDQo+Pj4gcmVxdWlyZWQgZmxhZ3MgZWFybHkgZW5vdWdoLsKgIFRoaXMg
YXBwZWFycyB0byBiZSBhZGRyZXNzZWQgaW4gbGF0ZXINCj4+PiB2ZXJzaW9ucyBvZiBzeXN0ZW1k
LCBidXQgZm9yIHVzZXJzIG9mIHZlcnNpb24gMjQxIHdoZXJlIHN5c3RlbWQtbmV0d29ya2QNCj4+
PiBub25ldGhlbGVzcyB3b3JrZWQgd2l0aCBlYXJsaWVyIGtlcm5lbHMsIHRoZSBzdHJpY3QgY2hl
Y2sgaW50cm9kdWNlZCBieQ0KPj4+IHRoZSBwYXRjaCBjYXVzZXMgYSByZWdyZXNzaW9uIGluIGJl
aGF2aW91ci4NCj4+Pg0KPj4+IFRoaXMgcGF0Y2ggY29udmVydHMgdGhlIGZhaWx1cmUgdG8gc3Vw
cGx5IHRoZSByZXF1aXJlZCBmbGFncyBmcm9tIGFuDQo+Pj4gZXJyb3IgaW50byBhIHdhcm5pbmcu
DQo+PiBUaGUgcHVycG9zZSBvZiBteSBwYXRjaCB3YXMgdG8gcHJldmVudCBhIHBhcnRpYWwgY29u
ZmlndXJhdGlvbiB1cGRhdGUgb24NCj4+IGludmFsaWQgaW5wdXQuIC1FSU5WQUwgd2FzIHJldHVy
bmVkIGJvdGggYmVmb3JlIGFuZCBhZnRlciBteSBwYXRjaCwgdGhlDQo+PiBkaWZmZXJlbmNlIGlz
IHRoYXQgYmVmb3JlIG15IHBhdGNoIHRoZXJlIHdhcyBhIHBhcnRpYWwgdXBkYXRlIGFuZCBhIA0K
Pj4gd2FybmluZy4NCj4+DQo+PiBZb3VyIHBhdGNoIGJhc2ljYWxseSBtYWtlcyBtaW5lIHBvaW50
bGVzcywgYmVjYXVzZSB5b3UgcmV2ZXJ0IHRoZSBmaXgsDQo+PiBhbmQgbm93IHdlJ2xsIGhhdmUg
dGhlIHNhbWUgcGFydGlhbCB1cGRhdGUgYW5kIHR3byB3YXJuaW5ncy4NCj4gDQo+IFVuZm9ydHVu
YXRlbHksIHllcy4uLg0KDQpTbyB3aGF0IHlvdSBwcm9wb3NlIGlzIGEgZGVncmFkYXRpb24uDQoN
Cj4+DQo+PiBPbmUgbW9yZSB0aGluZyBpcyB0aGF0IGFmdGVyIGFwcGx5aW5nIHlvdXIgcGF0Y2gg
b24gdG9wIG9mIG1pbmUsIHRoZQ0KPj4ga2VybmVsIHdvbid0IHJldHVybiAtRUlOVkFMIGFueW1v
cmUgb24gaW52YWxpZCBpbnB1dC4gUmV0dXJuaW5nIC1FSU5WQUwNCj4+IGlzIHdoYXQgaGFwcGVu
ZWQgYmVmb3JlIG15IHBhdGNoLCBhbmQgYWxzbyBhZnRlciBteSBwYXRjaC4NCj4gDQo+IFllcywg
eW91J3JlIHJpZ2h0LCBpdCB3b3VsZCBwcm9iYWJseSBiZSBiZXR0ZXIgcmV2ZXJ0IHRoZSBlbnRp
cmUgcGF0Y2ggDQo+IGJlY2F1c2UgdGhlIGNoZWNrcyBpbiBzZXRfbGlua19hZiBoYXZlIGJlZW4g
ZHJvcHBlZCBvbiB0aGUgYXNzdW1wdGlvbiANCj4gdGhhdCB2YWxpZGF0ZV9saW5rX2FmIGNhdGNo
ZXMgdGhlIGJhZG5lc3MuDQoNCldlIHNob3VsZG4ndCBpbnRyb2R1Y2Ugd29ya2Fyb3VuZHMgaW4g
dGhlIGtlcm5lbCBmb3Igc29tZSB0ZW1wb3JhcnkgYnVncyANCmluIG9sZCB1c2Vyc3BhY2UuIEEg
cmVncmVzc2lvbiB3YXMgaW50cm9kdWNlZCBpbiBzeXN0ZW1kOiBpdCBzdGFydGVkIA0Kc2VuZGlu
ZyBpbnZhbGlkIG1lc3NhZ2VzLCBkaWRuJ3QgY2hlY2sgdGhlIHJldHVybiBjb2RlIHByb3Blcmx5
IGFuZCANCnJlbGllZCBvbiBhbiB1bmRlZmluZWQgYmVoYXZpb3IuIEl0IHdhcyB0aGVuIGZpeGVk
IGluIHN5c3RlbWQuIElmIHRoZSANCmtlcm5lbCBoYWQgYWxsIGtpbmRzIG9mIHdvcmthcm91bmRz
IGZvciBhbGwgYnVnZ3kgc29mdHdhcmUgZXZlciBleGlzdGVkLCANCml0IHdvdWxkIGJlIGEgY29t
cGxldGUgbWVzcy4gVGhlIHNvZnR3YXJlIHVzZWQgdGhlIEFQSSBpbiBhIHdyb25nIHdheSwgDQp0
aGUgZXhwZWN0ZWQgYmVoYXZpb3IgaXMgZmFpbHVyZSwgc28gaXQgc2hvdWxkbid0IGV4cGVjdCBh
bnl0aGluZyBlbHNlLiANCkZvciBtZSwgdGhlIHRyYWRlLW9mZiBiZXR3ZWVuIGZpeGluZyB0aGUg
a2VybmVsIGJlaGF2aW9yIGFuZCBzdXBwb3J0aW5nIA0Kc29tZSBvbGQgYnVnZ3kgc29mdHdhcmUg
d2hpbGUga2VlcGluZyBhIFVCIGluIHRoZSBrZXJuZWwgZm9yZXZlciBoYXMgYW4gDQpvYnZpb3Vz
IHJlc29sdXRpb24uDQoNCj4+DQo+PiBSZWdhcmRpbmcgdGhlIHN5c3RlbWQgaXNzdWUsIEkgZG9u
J3QgdGhpbmsgd2Ugc2hvdWxkIGNoYW5nZSB0aGUga2VybmVsDQo+PiB0byBhZGFwdCB0byBidWdz
IGluIHN5c3RlbWQuIHN5c3RlbWQgZGlkbid0IGhhdmUgdGhpcyBidWcgZnJvbSBkYXkgb25lLA0K
Pj4gaXQgd2FzIGEgcmVncmVzc2lvbiBpbnRyb2R1Y2VkIGluIFsxXS4gVGhlIGtlcm5lbCBoYXMg
YWx3YXlzIHJldHVybmVkDQo+PiAtRUlOVkFMIGhlcmUsIGJ1dCB0aGUgYmVoYXZpb3IgYmVmb3Jl
IG15IHBhdGNoIHdhcyBiYXNpY2FsbHkgYSBVQiwgYW5kDQo+PiBhZnRlciB0aGUgcGF0Y2ggaXQn
cyB3ZWxsLWRlZmluZWQuIElmIHN5c3RlbWQgc2F3IEVJTlZBTCBhbmQgcmVsaWVkIG9uDQo+PiB0
aGUgVUIgdGhhdCBjYW1lIHdpdGggaXQsIGl0IGNhbid0IGJlIGEgcmVhc29uIGVub3VnaCB0byBi
cmVhayB0aGUgDQo+PiBrZXJuZWwuDQo+Pg0KPj4gTW9yZW92ZXIsIHRoZSBidWcgbG9va3MgZml4
ZWQgaW4gc3lzdGVtZCdzIG1hc3Rlciwgc28gd2hhdCB5b3Ugc3VnZ2VzdA0KPj4gaXMgdG8gaW5z
ZXJ0IGEga2VybmVsLXNpZGUgd29ya2Fyb3VuZCBmb3IgYW4gb2xkIHZlcnNpb24gb2Ygc29mdHdh
cmUNCj4+IHdoZW4gdGhlcmUgaXMgYSBmaXhlZCBvbmUuDQo+IA0KPiBJIGFncmVlLCBzeXN0ZW1k
IGlzIGJ1Z2d5IGhlcmUuwqAgUHJvYmFibHkgd2hhdCBoYXBwZW5zIGlzOg0KPiANCj4gaSnCoCBz
eXN0ZW1kIHRyaWVzIHRvIHNldCB0aGUgbGluayB1cA0KPiBpaSnCoCBpdCBlbmRzIHVwIGRvaW5n
IGEgInBhcnRpYWwiIG1vZGlmaWNhdGlvbiBvZiB0aGUgbGluayBzdGF0ZTsgDQo+IGNyaXRpY2Fs
bHksIHRob3VnaCwgZW5vdWdoIHRvIGFjdHVhbGx5IGVmZmVjdCB0aGUgbGluayBzdGF0ZSBjaGFu
Z2luZyB0byBVUA0KPiBpaWkpwqAgc3lzdGVtZCBzZWVzIHRoZSAtRUlOVkFMIGVycm9yIGFuZCBk
ZWNpZGVzIGl0IHByb2JhYmx5IGZhaWxlZCB0byANCj4gYnJpbmcgdXAgdGhlIGxpbmsNCj4gaXYp
wqAgc3lzdGVtZCB0aGVuIGdldHMgYSBub3RpZmljYXRpb24gdGhhdCB0aGUgbGluayBpcyB1cCBh
bmQgcnVucyBhIA0KPiBESENQIGNsaWVudCBvbiBpdA0KPiANCj4gSSBoYXZlbid0IG5vdGljZWQg
YW55ICJwYXJ0aWFsIG1vZGlmaWNhdGlvbiIgd2FybmluZ3MgaW4gdGhlIGtlcm5lbCBsb2cgDQo+
IGJ1dCBJIHdhc24ndCBsb29raW5nIGZvciB0aGVtLCBlaXRoZXIuLi4NCj4gDQo+IFdpdGggdGhl
IG5ldyBiZWhhdmlvdXIgaW4gNS4yLCBzdGVwIGlpKSBhYm92ZSByZXN1bHRzIGluIG5vICJwYXJ0
aWFsIA0KPiBtb2RpZmljYXRpb24iIHNvIHRoZSBsaW5rIHJlbWFpbnMgZG93biBhbmQgc3lzdGVt
ZCBpcyBmb3JldmVyIHVuYWJsZSB0byANCj4gYnJpbmcgaXQgdXAuDQo+IA0KPiBBbnl3YXksIGZv
ciB0aGUgcmVjb3JkLCB0aGUgZXJyb3IgaXM6DQo+IA0KPiBzeXN0ZW1kOsKgIENvdWxkIG5vdCBi
cmluZyB1cCBpbnRlcmZhY2UuLi4gKGludmFsaWQgcGFyYW1ldGVyKQ0KPiANCj4gQW5kIHRoZSBz
b2x1dGlvbiBpczrCoCBMaW51eCA+PSA1LjIgcmVxdWlyZXMgc3lzdGVtZCAhPSB2MjQxLg0KPiAN
Cj4gSWYgbm9ib2R5IGVsc2Ugbm90aWNlcywgdGhhdCdzIGdvb2QgZW5vdWdoIGZvciBtZS4NCj4g
DQo+Pg0KPj4gUGxlYXNlIGNvcnJlY3QgbWUgaWYgYW55dGhpbmcgSSBzYXkgaXMgd3JvbmcuDQo+
IA0KPiBOb3RoaW5nIHdyb25nLCBidXQgaXQncyBzdGlsbCBhIHJlZ3Jlc3Npb24uDQo+IA0KPiAv
Sm9uYXMNCj4gDQo+Pg0KPj4gVGhhbmtzLA0KPj4gTWF4DQo+Pg0KPj4gWzFdOg0KPj4gaHR0cHM6
Ly9naXRodWIuY29tL3N5c3RlbWQvc3lzdGVtZC9jb21taXQvMGUyZmRiODNiYjVlMjIwNDdlMGM3
Y2MwNThiNDE1ZDBlOTNmMDJjZiANCj4+DQo+Pg0KPj4+IFdpdGggdGhpcywgc3lzdGVtZC1uZXR3
b3JrZCB2ZXJzaW9uIDI0MSBvbmNlDQo+Pj4gYWdhaW4gaXMgYWJsZSB0byBicmluZyB1cCB0aGUg
bGluaywgYWxiZWl0IG5vdCBxdWl0ZSBhcyBpbnRlbmRlZCBhbmQNCj4+PiB0aGVyZWJ5IHdpdGgg
YSB3YXJuaW5nIGluIHRoZSBrZXJuZWwgbG9nLg0KPj4+DQo+Pj4gQ0M6IE1heGltIE1pa2l0eWFu
c2tpeSA8bWF4aW1taUBtZWxsYW5veC5jb20+DQo+Pj4gQ0M6IERhdmlkIFMuIE1pbGxlciA8ZGF2
ZW1AZGF2ZW1sb2Z0Lm5ldD4NCj4+PiBDQzogQWxleGV5IEt1em5ldHNvdiA8a3V6bmV0QG1zMi5p
bnIuYWMucnU+DQo+Pj4gQ0M6IEhpZGVha2kgWU9TSElGVUpJIDx5b3NoZnVqaUBsaW51eC1pcHY2
Lm9yZz4NCj4+PiBTaWduZWQtb2ZmLWJ5OiBKb25hcyBCb25uIDxqb25hc0Bub3JyYm9ubi5zZT4N
Cj4+PiAtLS0NCj4+PiDCoMKgIG5ldC9pcHY2L2FkZHJjb25mLmMgfCAzICsrLQ0KPj4+IMKgwqAg
MSBmaWxlIGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQ0KPj4+DQo+Pj4g
ZGlmZiAtLWdpdCBhL25ldC9pcHY2L2FkZHJjb25mLmMgYi9uZXQvaXB2Ni9hZGRyY29uZi5jDQo+
Pj4gaW5kZXggMDgxYmI1MTdlNDBkLi5lMjQ3N2JmOTJlMTIgMTAwNjQ0DQo+Pj4gLS0tIGEvbmV0
L2lwdjYvYWRkcmNvbmYuYw0KPj4+ICsrKyBiL25ldC9pcHY2L2FkZHJjb25mLmMNCj4+PiBAQCAt
NTY5Niw3ICs1Njk2LDggQEAgc3RhdGljIGludCBpbmV0Nl92YWxpZGF0ZV9saW5rX2FmKGNvbnN0
IHN0cnVjdCANCj4+PiBuZXRfZGV2aWNlICpkZXYsDQo+Pj4gwqDCoMKgwqDCoMKgwqDCoMKgwqAg
cmV0dXJuIGVycjsNCj4+PiDCoMKgwqDCoMKgwqAgaWYgKCF0YltJRkxBX0lORVQ2X1RPS0VOXSAm
JiAhdGJbSUZMQV9JTkVUNl9BRERSX0dFTl9NT0RFXSkNCj4+PiAtwqDCoMKgwqDCoMKgwqAgcmV0
dXJuIC1FSU5WQUw7DQo+Pj4gK8KgwqDCoMKgwqDCoMKgIG5ldF93YXJuX3JhdGVsaW1pdGVkKA0K
Pj4+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgICJyZXF1aXJlZCBsaW5rIGZsYWcgb21pdHRlZDog
VE9LRU4vQUREUl9HRU5fTU9ERVxuIik7DQo+Pj4gwqDCoMKgwqDCoMKgIGlmICh0YltJRkxBX0lO
RVQ2X0FERFJfR0VOX01PREVdKSB7DQo+Pj4gwqDCoMKgwqDCoMKgwqDCoMKgwqAgdTggbW9kZSA9
IG5sYV9nZXRfdTgodGJbSUZMQV9JTkVUNl9BRERSX0dFTl9NT0RFXSk7DQo+Pj4NCj4+DQoNCg==
