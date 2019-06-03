Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D50ED33B37
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 00:28:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726555AbfFCW2E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 18:28:04 -0400
Received: from mail-eopbgr20070.outbound.protection.outlook.com ([40.107.2.70]:36068
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726025AbfFCW2D (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Jun 2019 18:28:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N+mzUWRc+i8FqplYutJ9O145PbjKhiSn3fypZ0DLIvY=;
 b=LoWVBGwRx5M/78vxTYzqF8SPbVsHUjrKYKtBe3RLxbjTf850tG7d+jGoRtp1THPqAkjyAGTPngXqX+dHSbTJzNmPafK0oUxmCKJ+uG3hYv84KnAELJiPNZpWUEsNFsgVHZdJTVro2bKRTgPLIIQY39dxPpCypNlsFA6RNZBHBeM=
Received: from DB8PR05MB5898.eurprd05.prod.outlook.com (20.179.9.32) by
 DB8PR05MB6602.eurprd05.prod.outlook.com (20.179.12.143) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1943.22; Mon, 3 Jun 2019 22:27:59 +0000
Received: from DB8PR05MB5898.eurprd05.prod.outlook.com
 ([fe80::4008:6417:32d4:6031]) by DB8PR05MB5898.eurprd05.prod.outlook.com
 ([fe80::4008:6417:32d4:6031%5]) with mapi id 15.20.1943.018; Mon, 3 Jun 2019
 22:27:59 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "edumazet@google.com" <edumazet@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "leon@kernel.org" <leon@kernel.org>
Subject: Re: [PATCH net-next 2/3] indirect call wrappers: add helpers for 3
 and 4 ways switch
Thread-Topic: [PATCH net-next 2/3] indirect call wrappers: add helpers for 3
 and 4 ways switch
Thread-Index: AQHVF6/5O5vnoPxts0iY1Smg4vFIaaaFjoSAgAQl1oCAANN0AA==
Date:   Mon, 3 Jun 2019 22:27:59 +0000
Message-ID: <10e134ce6b8c0e2060cecf57527cc52a99d4d6a5.camel@mellanox.com>
References: <cover.1559304330.git.pabeni@redhat.com>
         <7dc56c32624fd102473fc66ffdda6ebfcdfe6ad0.1559304330.git.pabeni@redhat.com>
         <1133f7e92cffb7ade5249e6d6ac0dd430549bf14.camel@mellanox.com>
         <141f34bb8d1505783b4f939faac5223200deeb13.camel@redhat.com>
In-Reply-To: <141f34bb8d1505783b4f939faac5223200deeb13.camel@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.2 (3.32.2-1.fc30) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 320cacba-e76a-4670-3305-08d6e872bbb1
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB8PR05MB6602;
x-ms-traffictypediagnostic: DB8PR05MB6602:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <DB8PR05MB660282A89F97843D64CE16DABE140@DB8PR05MB6602.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0057EE387C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(376002)(136003)(396003)(39860400002)(346002)(199004)(189003)(6506007)(6246003)(966005)(76176011)(6306002)(110136005)(6512007)(2906002)(508600001)(229853002)(64756008)(66556008)(66476007)(71190400001)(99286004)(54906003)(71200400001)(316002)(91956017)(6436002)(8936002)(66446008)(3846002)(6116002)(58126008)(66946007)(68736007)(11346002)(4326008)(25786009)(446003)(14454004)(118296001)(73956011)(76116006)(36756003)(2201001)(305945005)(7736002)(6486002)(86362001)(102836004)(66066001)(2616005)(486006)(476003)(81156014)(5660300002)(186003)(2501003)(8676002)(256004)(53936002)(14444005)(5024004)(81166006)(26005);DIR:OUT;SFP:1101;SCL:1;SRVR:DB8PR05MB6602;H:DB8PR05MB5898.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: vYx6BL1mPaK16+lfknrwcUZNFztnYtd5YJDPN4lA7S+GjskIkBv4spEM41sTwfgpA931Jjo6IN1CWTwKOs5leKdEWnRMaxJGrwt0IM1d5ntpMJrpU6f72LadXkAOdWob7r4YwOarIagFKfdqwvxOO8VV3zLgvH8Y0yvL3TZwva5PK0nrBulscVqONzGlrfh/LWwxaFHIJ0oGJDwEyIBq/nd8VGY0OAg8rna10AvEeREfZRg6CekEEQyAoiWyBefndFDkXvaBkRTEAq12Qb9iH2cg5RJgsH9j9kRrfe7gAMJKGLMjM7Jx3fIUGTqasWYF1dZXX1XU7H5PcBEbQDQYNycxRZrwIJClFtpXdFhO/yBRvy4k2yX0I50gnLGbxmtrcfq9uNgippYcG2h7Wxe3Xiea0XeiutLpQUHe5izja5w=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0885052C78ACB545B78880A3DC8C5D84@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 320cacba-e76a-4670-3305-08d6e872bbb1
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jun 2019 22:27:59.1082
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR05MB6602
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCAyMDE5LTA2LTAzIGF0IDExOjUxICswMjAwLCBQYW9sbyBBYmVuaSB3cm90ZToNCj4g
T24gRnJpLCAyMDE5LTA1LTMxIGF0IDE4OjMwICswMDAwLCBTYWVlZCBNYWhhbWVlZCB3cm90ZToN
Cj4gPiBPbiBGcmksIDIwMTktMDUtMzEgYXQgMTQ6NTMgKzAyMDAsIFBhb2xvIEFiZW5pIHdyb3Rl
Og0KPiA+ID4gRXhwZXJpbWVudGFsIHJlc3VsdHNbMV0gaGFzIHNob3duIHRoYXQgcmVzb3J0aW5n
IHRvIHNldmVyYWwNCj4gPiA+IGJyYW5jaGVzDQo+ID4gPiBhbmQgYSBkaXJlY3QtY2FsbCBpcyBm
YXN0ZXIgdGhhbiBpbmRpcmVjdCBjYWxsIHZpYSByZXRwb2xpbmUsDQo+ID4gPiBldmVuDQo+ID4g
PiB3aGVuIHRoZSBudW1iZXIgb2YgYWRkZWQgYnJhbmNoZXMgZ28gdXAgNS4NCj4gPiA+IA0KPiA+
ID4gVGhpcyBjaGFuZ2UgYWRkcyB0d28gYWRkaXRpb25hbCBoZWxwZXJzLCB0byBjb3BlIHdpdGgg
aW5kaXJlY3QNCj4gPiA+IGNhbGxzDQo+ID4gPiB3aXRoIHVwIHRvIDQgYXZhaWxhYmxlIGRpcmVj
dCBjYWxsIG9wdGlvbi4gV2Ugd2lsbCB1c2UgdGhlbQ0KPiA+ID4gaW4gdGhlIG5leHQgcGF0Y2gu
DQo+ID4gPiANCj4gPiA+IFsxXSANCj4gPiA+IGh0dHBzOi8vbGludXhwbHVtYmVyc2NvbmYub3Jn
L2V2ZW50LzIvY29udHJpYnV0aW9ucy85OS9hdHRhY2htZW50cy85OC8xMTcvbHBjMThfcGFwZXJf
YWZfeGRwX3BlcmYtdjIucGRmDQo+ID4gPiANCj4gPiA+IFNpZ25lZC1vZmYtYnk6IFBhb2xvIEFi
ZW5pIDxwYWJlbmlAcmVkaGF0LmNvbT4NCj4gPiA+IC0tLQ0KPiA+ID4gIGluY2x1ZGUvbGludXgv
aW5kaXJlY3RfY2FsbF93cmFwcGVyLmggfCAxMiArKysrKysrKysrKysNCj4gPiA+ICAxIGZpbGUg
Y2hhbmdlZCwgMTIgaW5zZXJ0aW9ucygrKQ0KPiA+ID4gDQo+ID4gPiBkaWZmIC0tZ2l0IGEvaW5j
bHVkZS9saW51eC9pbmRpcmVjdF9jYWxsX3dyYXBwZXIuaA0KPiA+ID4gYi9pbmNsdWRlL2xpbnV4
L2luZGlyZWN0X2NhbGxfd3JhcHBlci5oDQo+ID4gPiBpbmRleCAwMGQ3ZThlOTE5YzYuLjdjNGNh
Yzg3ZWFmNyAxMDA2NDQNCj4gPiA+IC0tLSBhL2luY2x1ZGUvbGludXgvaW5kaXJlY3RfY2FsbF93
cmFwcGVyLmgNCj4gPiA+ICsrKyBiL2luY2x1ZGUvbGludXgvaW5kaXJlY3RfY2FsbF93cmFwcGVy
LmgNCj4gPiA+IEBAIC0yMyw2ICsyMywxNiBAQA0KPiA+ID4gIAkJbGlrZWx5KGYgPT0gZjIpID8g
ZjIoX19WQV9BUkdTX18pIDoJCQkNCj4gPiA+IFwNCj4gPiA+ICAJCQkJICBJTkRJUkVDVF9DQUxM
XzEoZiwgZjEsIF9fVkFfQVJHU19fKTsJDQo+ID4gPiBcDQo+ID4gPiAgCX0pDQo+ID4gPiArI2Rl
ZmluZSBJTkRJUkVDVF9DQUxMXzMoZiwgZjMsIGYyLCBmMSwgLi4uKQkJCQ0KPiA+ID4gCQ0KPiA+
ID4gXA0KPiA+ID4gKwkoewkJCQkJCQkJDQo+ID4gPiBcDQo+ID4gPiArCQlsaWtlbHkoZiA9PSBm
MykgPyBmMyhfX1ZBX0FSR1NfXykgOgkJCQ0KPiA+ID4gXA0KPiA+ID4gKwkJCQkgIElORElSRUNU
X0NBTExfMihmLCBmMiwgZjEsDQo+ID4gPiBfX1ZBX0FSR1NfXyk7IFwNCj4gPiA+ICsJfSkNCj4g
PiA+ICsjZGVmaW5lIElORElSRUNUX0NBTExfNChmLCBmNCwgZjMsIGYyLCBmMSwgLi4uKQkJCQ0K
PiA+ID4gCVwNCj4gPiA+ICsJKHsJCQkJCQkJCQ0KPiA+ID4gXA0KPiA+ID4gKwkJbGlrZWx5KGYg
PT0gZjQpID8gZjQoX19WQV9BUkdTX18pIDoJCQ0KPiA+IA0KPiA+IGRvIHdlIHJlYWxseSB3YW50
ICJsaWtlbHkiIGhlcmUgPyBpbiBvdXIgY2FzZXMgdGhlcmUgaXMgbm8NCj4gPiBwcmVmZXJlbmNl
DQo+ID4gb24gd2h1Y2ggZk4gaXMgZ29pbmcgdG8gaGF2ZSB0aGUgdG9wIHByaW9yaXR5LCBhbGwg
b2YgdGhlbSBhcmUNCj4gPiBlcXVhbGx5DQo+ID4gaW1wb3J0YW50IGFuZCBzdGF0aWNhbGx5IGNv
bmZpZ3VyZWQgYW5kIGd1cmFudGVlZCB0byBub3QgY2hhbmdlIG9uDQo+ID4gZGF0YQ0KPiA+IHBh
dGggLi4gDQo+IA0KPiBJIHdhcyBhIGxpdHRsZSB1bmRlY2lkZWQgYWJvdXQgdGhhdCwgdG9vLiAn
bGlrZWx5KCknIGlzIHRoZXJlIG1haW5seQ0KPiBmb3Igc2ltbWV0cnkgd2l0aCB0aGUgYWxyZWFk
eSBleGlzdGluZyBfMSBhbmQgXzIgdmFyaWFudHMuIEluIHN1Y2gNCj4gbWFjcm9zIHRoZSBicmFu
Y2ggcHJlZGljdGlvbiBoaW50IHJlcHJlc2VudCBhIHJlYWwgcHJpb3JpdHkgb2YgdGhlDQo+IGF2
YWlsYWJsZSBjaG9pY2VzLg0KPiANCg0KRm9yIG1hY3JvIF8xIGl0IG1ha2Ugc2Vuc2UgdG8gaGF2
ZSB0aGUgbGlrZWx5IGtleXdvcmQgYnV0IGZvciBfMiBpdA0KZG9lc24ndCwgYnkgbG9va2luZyBh
dCBtb3N0IG9mIHRoZSB1c2VjYXNlcyBvZiBJTkRJUkVDVF9DQUxMXzIsIHRoZXkNCnNlZW0gdG8g
YmUgYWxsIGFyb3VuZCBpbXByb3ZpbmcgdGNwL3VkcCByZWxhdGVkIGluZGlyZWN0aW9uIGNhbGxz
IGluDQp0aGUgcHJvdG9jb2wgc3RhY2ssIGFuZCB0aGV5IHNlZW0gdG8gcHJlZmVyIHRjcCBvdmVy
IHVkcC4gQnV0IElNSE8gYXQNCmxlYXN0IGZvciB0aGUgYWJvdmUgdXNlY2FzZSBJIHRoaW5rIHRo
ZSBsaWtlbHkga2V5d29yZCBpcyBiZWluZyBtaXN1c2VkDQpoZXJlIGFuZCBzaG91bGQgYmUgcmVt
b3ZlIGZyb20gYWxsIElORElSRUNUX0NBTExfTiB3aGVyZSBOID4gMTsNCg0KRXJpYywgd2hhdCBk
byB5b3UgdGhpbmsgPw0KDQo+IFRvIGF2b2lkIHRoZSBicmFuY2ggcHJlZGljdGlvbiwgYSBuZXcg
c2V0IG9mIG1hY3JvcyBzaG91bGQgYmUNCj4gZGVmaW5lZCwNCj4gYnV0IHRoYXQgYWxzbyBzb3Vu
ZHMgcmVkdW5kYW50Lg0KPiANCj4gSWYgeW91IGhhdmUgc3Ryb25nIG9waW5pb24gYWdhaW5zdCB0
aGUgYnJlYW5jaCBwcmVkaWN0aW9uIGhpbnQsIEkNCj4gY291bGQNCj4gZWl0aGVyIGRyb3AgdGhp
cyBwYXRjaCBhbmQgdGhlIG5leHQgb25lIG9yIHJlc29ydCB0byBjdXN0b20gbWFjcm9zIGluDQo+
IHRoZSBtbHggY29kZS4NCj4gDQo+IEFueSBbYWx0ZXJuYXRpdmVdIHN1Z2dlc3Rpb25zIG1vcmUg
dGhhbiB3ZWxjb21lIQ0KPiAJXA0KDQpjdXN0b20gbWFjcm9zIGNhbiB3b3JrLCBidXQgaW4gY2Fz
ZSB5b3UgZG9uJ3Qgd2FudCB0byBpbnRyb2R1Y2Ugc3VjaA0KbWFjcm9zIGluIGEgdmVuZG9yIHNw
ZWNpZmljIGRyaXZlciwgdGhlbiBpIHRoaW5rIHlvdXIgcGF0Y2hlcyBhcmUgc3RpbGwNCmFuIGlt
cHJvdmVtZW50IGFmdGVyIGFsbC4uDQoNCkluIGFueSBjYXNlLCBqdXN0IG1ha2Ugc3VyZSB0byB1
c2UgdGhlIG9yZGVyIGkgc3VnZ2VzdGVkIGluIG5leHQgcGF0Y2gNCndpdGg6IE1MWDVfUlhfSU5E
SVJFQ1RfQ0FMTF9MSVNUDQoNCj4gPiA+ICsJCQkJICBJTkRJUkVDVF9DQUxMXzMoZiwgZjMsIGYy
LCBmMSwNCj4gPiA+IF9fVkFfQVJHU19fKTsgXA0KPiA+ID4gKwl9KQ0KPiA+ID4gIA0KPiA+IA0K
PiA+IE9oIHRoZSBSRVRQT0xJTkUhDQo+ID4gDQo+ID4gT24gd2hpY2ggKE4pIHdoZXJlIElORElS
RUNUX0NBTExfTihmLCBmTiwgZk4tMSwgLi4uLCBmMSwuLi4pICwNCj4gPiBjYWxsaW5nDQo+ID4g
dGhlIGluZGlyZWN0aW9uIGZ1bmN0aW9uIHBvaW50ZXIgZGlyZWN0bHkgaXMgZ29pbmcgdG8gYmUg
YWN0dWFsbHkNCj4gPiBiZXR0ZXIgdGhhbiB0aGlzIHdob2xlIElORElSRUNUX0NBTExfTiB3cmFw
cGVyICJpZiBlbHNlIiBkYW5jZSA/DQo+IA0KPiBJbiBjb21taXQgY2UwMmVmMDZmY2Y3YTM5OWE2
Mjc2YWRiODNmMzczNzNkMTBjYmJlMSwgaXQncyBtZWFzdXJlZCBhDQo+IHJlbGV2YW50IGdhaW4g
ZXZlbiB3aXRoIG1vcmUgdGhhbiA1IG9wdGlvbnMuIEkgcGVyc29uYWxseSB3b3VsZCBhdm9pZA0K
PiBhZGRpbmcgbXVjaCBtb3JlIG9wdGlvbnMgdGhhbiB0aGUgYWJvdmUuDQo+IA0KPiBUaGFua3Ms
DQo+IA0KPiBQYW9sbw0KPiANCj4gDQo=
