Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3448B6525A
	for <lists+netdev@lfdr.de>; Thu, 11 Jul 2019 09:21:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727972AbfGKHV4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jul 2019 03:21:56 -0400
Received: from mail-eopbgr150040.outbound.protection.outlook.com ([40.107.15.40]:22404
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726088AbfGKHV4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Jul 2019 03:21:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zHALjUXwRzfHIlSHO6XomrtxcjOv2zaLGLcQ269sAy8=;
 b=h8INerduCwLbxvzfg7cTWMqz15Wl8QKC1iOaGYV1VBDpBz5h/L41Be9CsasVoej9CIe34iK6fdyAZwD7qjr6D6MaPDSHpBCcmMQKYbIfzhLgqbtCExtUJsfZiHYm0+t8GsQSfykuV0WTGsInUdlh82LtJ//e465XjA9sacqBLJ8=
Received: from AM4PR05MB3411.eurprd05.prod.outlook.com (10.171.190.30) by
 AM4PR05MB3187.eurprd05.prod.outlook.com (10.171.189.12) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2052.20; Thu, 11 Jul 2019 07:21:51 +0000
Received: from AM4PR05MB3411.eurprd05.prod.outlook.com
 ([fe80::9434:99ea:e230:aba7]) by AM4PR05MB3411.eurprd05.prod.outlook.com
 ([fe80::9434:99ea:e230:aba7%4]) with mapi id 15.20.2052.020; Thu, 11 Jul 2019
 07:21:51 +0000
From:   Paul Blakey <paulb@mellanox.com>
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
CC:     Jiri Pirko <jiri@mellanox.com>, Roi Dayan <roid@mellanox.com>,
        Yossi Kuperman <yossiku@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Aaron Conole <aconole@redhat.com>,
        Zhike Wang <wangzhike@jd.com>, Justin Pettit <jpettit@ovn.org>,
        John Hurley <john.hurley@netronome.com>,
        Rony Efraim <ronye@mellanox.com>,
        "nst-kernel@redhat.com" <nst-kernel@redhat.com>,
        Simon Horman <simon.horman@netronome.com>
Subject: Re: [PATCH net-next iproute2 2/3] tc: Introduce tc ct action
Thread-Topic: [PATCH net-next iproute2 2/3] tc: Introduce tc ct action
Thread-Index: AQHVNKHtV/7FmlwqTUa4YKqKnTYQf6bBAzEAgADa/ICAAJDXgIACmlIA
Date:   Thu, 11 Jul 2019 07:21:51 +0000
Message-ID: <5ded2e5b-958e-eca3-76ad-909ebf79234e@mellanox.com>
References: <1562489628-5925-1-git-send-email-paulb@mellanox.com>
 <1562489628-5925-3-git-send-email-paulb@mellanox.com>
 <20190708175446.GL3449@localhost.localdomain>
 <d4f2f3ce-f14d-6026-a271-d627de6d8cea@mellanox.com>
 <20190709153657.GF3390@localhost.localdomain>
In-Reply-To: <20190709153657.GF3390@localhost.localdomain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM6PR08CA0013.eurprd08.prod.outlook.com
 (2603:10a6:20b:b2::25) To AM4PR05MB3411.eurprd05.prod.outlook.com
 (2603:10a6:205:b::30)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=paulb@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [193.47.165.251]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9c52e547-b28c-4512-015c-08d705d0716a
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM4PR05MB3187;
x-ms-traffictypediagnostic: AM4PR05MB3187:
x-microsoft-antispam-prvs: <AM4PR05MB31872D0341C79B864665C8B0CFF30@AM4PR05MB3187.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2512;
x-forefront-prvs: 0095BCF226
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(346002)(39860400002)(136003)(396003)(376002)(199004)(189003)(52116002)(186003)(26005)(66476007)(102836004)(86362001)(316002)(53546011)(5660300002)(81156014)(386003)(81166006)(8676002)(6506007)(66556008)(6486002)(66446008)(76176011)(68736007)(66946007)(99286004)(71190400001)(71200400001)(6916009)(54906003)(64756008)(6512007)(305945005)(6436002)(478600001)(229853002)(7736002)(446003)(11346002)(25786009)(2616005)(476003)(486006)(2906002)(66066001)(14444005)(3846002)(6116002)(256004)(31696002)(53936002)(31686004)(8936002)(14454004)(6246003)(4326008)(36756003);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR05MB3187;H:AM4PR05MB3411.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 7CNr9AsvnM9f4IVptPEAZfq740w7jDddB5qWit7YItrDb2a63yy34anTPKke3dUQnvdlULph4NSLZI8k7d608KAXkuZ+2ZOEWuESn0eFB20RSU3PF3COlEHYrUVdjSYfFaaou0mCI8OSUT+nDZTAcyAAAFOGdrPGxJzoZxc/nZGan/WcvFaXbIXpzL1poOf7HYZ3yd5sgbUWSDQu+VCOA6jkV81dFRjEqlyBSOYhcnlMTEjT4cS6qVsjw90c1CvjlUz9Ik0zdCB7fjGYeS+SFuIvTDztA30tcII9bx8UaMhEoZZvQW/BIZQQDRTSYXR364TbKdM+zmFFPf/YsjIk3wrWwfInAhQJNF3O0Wz0mP2+Hmv/m0eDFEzUBVt0yGbtmkSQh5ByL8dEs547CSyAkmW2EhWPFCV99FnlKP7Wbe8=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9496AC461ED99249959232822B8BDE19@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c52e547-b28c-4512-015c-08d705d0716a
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jul 2019 07:21:51.2142
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: paulb@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR05MB3187
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpPbiA3LzkvMjAxOSA2OjM2IFBNLCBNYXJjZWxvIFJpY2FyZG8gTGVpdG5lciB3cm90ZToNCj4g
T24gVHVlLCBKdWwgMDksIDIwMTkgYXQgMDY6NTg6MzZBTSArMDAwMCwgUGF1bCBCbGFrZXkgd3Jv
dGU6DQo+PiBPbiA3LzgvMjAxOSA4OjU0IFBNLCBNYXJjZWxvIFJpY2FyZG8gTGVpdG5lciB3cm90
ZToNCj4+PiBPbiBTdW4sIEp1bCAwNywgMjAxOSBhdCAxMTo1Mzo0N0FNICswMzAwLCBQYXVsIEJs
YWtleSB3cm90ZToNCj4+Pj4gTmV3IHRjIGFjdGlvbiB0byBzZW5kIHBhY2tldHMgdG8gY29ubnRy
YWNrIG1vZHVsZSwgY29tbWl0DQo+Pj4+IHRoZW0sIGFuZCBzZXQgYSB6b25lLCBsYWJlbHMsIG1h
cmssIGFuZCBuYXQgb24gdGhlIGNvbm5lY3Rpb24uDQo+Pj4+DQo+Pj4+IEl0IGNhbiBhbHNvIGNs
ZWFyIHRoZSBwYWNrZXQncyBjb25udHJhY2sgc3RhdGUgYnkgdXNpbmcgY2xlYXIuDQo+Pj4+DQo+
Pj4+IFVzYWdlOg0KPj4+PiAgICAgIGN0IGNsZWFyDQo+Pj4+ICAgICAgY3QgY29tbWl0IFtmb3Jj
ZV0gW3pvbmVdIFttYXJrXSBbbGFiZWxdIFtuYXRdDQo+Pj4gSXNuJ3QgdGhlICdjb21taXQnIGFs
c28gb3B0aW9uYWw/IE1vcmUgbGlrZQ0KPj4+ICAgICAgIGN0IFtjb21taXQgW2ZvcmNlXV0gW3pv
bmVdIFttYXJrXSBbbGFiZWxdIFtuYXRdDQo+Pj4NCj4+Pj4gICAgICBjdCBbbmF0XSBbem9uZV0N
Cj4+Pj4NCj4+Pj4gU2lnbmVkLW9mZi1ieTogUGF1bCBCbGFrZXkgPHBhdWxiQG1lbGxhbm94LmNv
bT4NCj4+Pj4gU2lnbmVkLW9mZi1ieTogTWFyY2VsbyBSaWNhcmRvIExlaXRuZXIgPG1hcmNlbG8u
bGVpdG5lckBnbWFpbC5jb20+DQo+Pj4+IFNpZ25lZC1vZmYtYnk6IFlvc3NpIEt1cGVybWFuIDx5
b3NzaWt1QG1lbGxhbm94LmNvbT4NCj4+Pj4gQWNrZWQtYnk6IEppcmkgUGlya28gPGppcmlAbWVs
bGFub3guY29tPg0KPj4+PiBBY2tlZC1ieTogUm9pIERheWFuIDxyb2lkQG1lbGxhbm94LmNvbT4N
Cj4+Pj4gLS0tDQo+Pj4gLi4uDQo+Pj4+ICtzdGF0aWMgdm9pZA0KPj4+PiArdXNhZ2Uodm9pZCkN
Cj4+Pj4gK3sNCj4+Pj4gKwlmcHJpbnRmKHN0ZGVyciwNCj4+Pj4gKwkJIlVzYWdlOiBjdCBjbGVh
clxuIg0KPj4+PiArCQkiCWN0IGNvbW1pdCBbZm9yY2VdIFt6b25lIFpPTkVdIFttYXJrIE1BU0tF
RF9NQVJLXSBbbGFiZWwgTUFTS0VEX0xBQkVMXSBbbmF0IE5BVF9TUEVDXVxuIg0KPj4+IERpdHRv
IGhlcmUgdGhlbi4NCj4+DQo+PiBJbiBjb21taXQgbXNnIGFuZCBoZXJlLCBpdCBtZWFucyB0aGVy
ZSBpcyBtdWx0aXBsZSBtb2RlcyBvZiBvcGVyYXRpb24uIEkNCj4+IHRoaW5rIGl0J3MgZWFzaWVy
IHRvIHNwbGl0IHRob3NlLg0KPiBZZXAsIHRoYXQgaXMgZ29vZC4NCj4gTW9yZSBiZWxvdy4NCj4N
Cj4+ICJjdCBjbGVhciIgdG8gY2xlYXIgaXQgLCBub3Qgb3RoZXIgb3B0aW9ucyBjYW4gYmUgYWRk
ZWQgaGVyZS4NCj4+DQo+PiAiY3QgY29tbWl0wqAgW2ZvcmNlXS4uLi4gIiBzZW5kcyB0byBjb25u
dHJhY2sgYW5kIGNvbW1pdCBhIGNvbm5lY3Rpb24sDQo+PiBhbmQgb25seSBmb3IgY29tbWl0IGNh
biB5b3Ugc3BlY2lmeSBmb3JjZSBtYXJrwqAgbGFiZWwsIGFuZCBuYXQgd2l0aA0KPj4gbmF0X3Nw
ZWMuLi4uDQo+Pg0KPj4gYW5kIHRoZSBsYXN0IG9uZSwgImN0IFtuYXRdIFt6b25lIFpPTkVdIiBp
cyB0byBqdXN0IHNlbmQgdGhlIHBhY2tldCB0bw0KPj4gY29ubnRyYWNrIG9uIHNvbWUgem9uZSBb
b3B0aW9uYWxdLCByZXN0b3JlIG5hdCBbb3B0aW9uYWxdLg0KPj4NCj4+DQo+Pj4+ICsJCSIJY3Qg
W25hdF0gW3pvbmUgWk9ORV1cbiINCj4+Pj4gKwkJIldoZXJlOiBaT05FIGlzIHRoZSBjb25udHJh
Y2sgem9uZSB0YWJsZSBudW1iZXJcbiINCj4+Pj4gKwkJIglOQVRfU1BFQyBpcyB7c3JjfGRzdH0g
YWRkciBhZGRyMVstYWRkcjJdIFtwb3J0IHBvcnQxWy1wb3J0Ml1dXG4iDQo+Pj4+ICsJCSJcbiIp
Ow0KPj4+PiArCWV4aXQoLTEpOw0KPj4+PiArfQ0KPj4+IC4uLg0KPj4+DQo+Pj4gVGhlIHZhbGlk
YXRpb24gYmVsb3cgZG9lc24ndCBlbmZvcmNlIHRoYXQgY29tbWl0IG11c3QgYmUgdGhlcmUgZm9y
DQo+Pj4gc3VjaCBjYXNlLg0KPj4gd2hpY2ggY2FzZT8gY29tbWl0IGlzIG9wdGlvbmFsLiB0aGUg
YWJvdmUgYXJlIHRoZSB0aHJlZSB2YWxpZCBwYXR0ZXJucy4NCj4gVGhhdCdzIHRoZSBwb2ludC4g
QnV0IHRoZSAybmQgZXhhbXBsZSBpcyBzYXlpbmcgJ2NvbW1pdCcgd29yZCBpcw0KPiBtYW5kYXRv
cnkgaW4gdGhhdCBtb2RlLiBJdCBpcyB3cml0dGVuIGFzIGl0IGlzIGEgY29tbWFuZCB0aGF0IHdh
cw0KPiBzZWxlY3RlZC4NCj4NCj4gT25lIG1heSB1c2UganVzdDoNCj4gICAgICBjdCBbem9uZV0N
Cj4gQW5kIG5vdA0KPiAgICAgIGN0IGNvbW1pdCBbem9uZV0NCj4gUmlnaHQ/DQoNCkl0IGlzIG9w
dGlvbmFsIGluIHRoZSBvdmVyYWxsIHN5bnRheC4NCg0KDQpCdXQgSSBzcGxpdCBpdCBpbnRvIG1v
ZGVzOg0KDQpjbGVhciwgY29tbWl0LCBhbmQgInJlc3RvcmUiIChJIHVub2ZmaWNpYWwgY2FsbCBp
dCBsaWtlIHRoYXQsIGJlY2F1c2UgaXQgDQp1c3VhbGx5IHVzZWQgdG8gZ2V0IHRoZSArZXN0IHN0
YXRlIG9uIHRoZSBwYWNrZXQgYW5kIGNhbiByZXN0b3JlIG5hdCwgaXQgDQpkb2Vzbid0IGFjdHVh
bGx5IHJlc3RvcmUgYW55dGhpbmcgZm9yIHRoZSBmaXJzdCBwYWNrZXQgb24gdGhlIC10cmsgcnVs
ZSkNCg0KSXQgaXMgbWFuZGF0b3J5IGluIHRoZSBzZWNvbmQgbW9kZSAoY29tbWl0KSwgaWYgeW91
IGRvbid0IHNwZWNpZnkgY29tbWl0IA0Kb3IgY2xlYXIsIHlvdSBjYW4gb25seSB1c2UgdGhlIHRo
aXJkIGZvcm0gLSAicmVzdG9yZSIsIHdoaWNoIGlzIHRvIHNlbmQgDQp0byBjdCBvbiBzb21lIG9w
dGlvbmFsIHpvbmUsIGFuZCBvcHRpb25hbGx5IGFuZCByZXN0b3JlIG5hdCAoc28gd2UgZ2V0IA0K
Y3QgW3pvbmVdIFtuYXRdKS4NCg0KSSB0aGluayB0aGlzIHN5bnRheCBpcyBlYXN5LCBtYXliZSBJ
IGNhbiBsYWJlbCB0aGVtIGFzIHRoZSBtb2RlcyBvZiANCm9wZXJhdGlvbiBhYm92ZSAodGhlbiBJ
J2xsIG5lZWQgdG8gbmFtZSB0aGUgcmVzdG9yZSBvbmUgYmV0dGVyIDopKS4NCg0KSWYgdGhlcmUg
aXMgYSBkaWZmZXJlbnQgc3ludGF4IHlvdSB0aGluayBtaWdodCBiZSBlYXNpZXIgSSdsbCBjaGFu
Z2UgdG8gDQp0aGF0Lg0KDQoNClRoYW5rcywNCg0KUGF1bC4NCg0KDQoNCg0KDQoNCg==
