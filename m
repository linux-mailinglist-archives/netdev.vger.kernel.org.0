Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8D2349369
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 23:30:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730438AbfFQVao (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 17:30:44 -0400
Received: from mail-eopbgr80075.outbound.protection.outlook.com ([40.107.8.75]:49580
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728934AbfFQVaj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 Jun 2019 17:30:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ClbX7gI+g19ootHc77urvl4dDcTDkQH5RQvmAIDomRA=;
 b=JCyRDbViwTTI4HqS4P2XpiCJah5GAQ3HPnMdPebjMpsj758RTtgkBBiIPVmoNx1N2IJDlGrHwjOtcd5PVTgfHMPPhjz5BNM1r+rJuvCZN0zT3LSj0ZwexmPAymhaWUZ3WaADIXlPjVdjo/pQ9H5N26mNBqvqoDbareoQCJgi+lQ=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2230.eurprd05.prod.outlook.com (10.168.55.151) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.13; Mon, 17 Jun 2019 21:30:35 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::a901:6951:59de:3278]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::a901:6951:59de:3278%2]) with mapi id 15.20.1987.014; Mon, 17 Jun 2019
 21:30:34 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "davem@davemloft.net" <davem@davemloft.net>,
        "arnd@arndb.de" <arnd@arndb.de>
CC:     "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        Paul Blakey <paulb@mellanox.com>,
        Mark Bloch <markb@mellanox.com>,
        Maor Gottlieb <maorg@mellanox.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Eli Britstein <elibr@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "leon@kernel.org" <leon@kernel.org>
Subject: Re: [PATCH] net/mlx5e: reduce stack usage in
 mlx5_eswitch_termtbl_create
Thread-Topic: [PATCH] net/mlx5e: reduce stack usage in
 mlx5_eswitch_termtbl_create
Thread-Index: AQHVJP0SzELjx0H8KE2MySy85rN5zKagVfkAgAAH1QA=
Date:   Mon, 17 Jun 2019 21:30:34 +0000
Message-ID: <69c6a9cfe132a4437bc7d481fb9aeddbe57f7114.camel@mellanox.com>
References: <20190617110855.2085326-1-arnd@arndb.de>
         <20190617.140230.537297372523260104.davem@davemloft.net>
In-Reply-To: <20190617.140230.537297372523260104.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.2 (3.32.2-1.fc30) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d6b8f39f-9a8e-4f42-0e30-08d6f36b0889
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2230;
x-ms-traffictypediagnostic: DB6PR0501MB2230:
x-microsoft-antispam-prvs: <DB6PR0501MB2230BF27810B974D54FCA7BCBEEB0@DB6PR0501MB2230.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0071BFA85B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(346002)(366004)(136003)(396003)(39860400002)(189003)(199004)(256004)(8936002)(14444005)(476003)(486006)(2501003)(102836004)(7736002)(305945005)(6512007)(76176011)(6506007)(99286004)(2616005)(186003)(26005)(316002)(58126008)(2906002)(68736007)(110136005)(54906003)(446003)(14454004)(478600001)(91956017)(5660300002)(86362001)(71190400001)(6246003)(25786009)(36756003)(53936002)(11346002)(76116006)(3846002)(6116002)(73956011)(4326008)(229853002)(64756008)(118296001)(66556008)(66476007)(6436002)(66066001)(8676002)(66446008)(6486002)(81166006)(81156014)(71200400001)(66946007);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2230;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: IFRitn3LhFvbSEF2+YZu8zMVTYiiS4fH/l1uBz7vK3RzhImAe+YgRKf/kM0nwgPCUALkWE1GX52pnMLhAIWXpeno7BR9CqBc8JgnC93iWafA//ijm8Hp+ZnOdw8Fo6tnCrNyPOd0rvfKtISJY8mRYcL9oHB6VbkUZZgnPSkK+iStjyxBDHbjVcgzSX/Eqy4qVZMjAmna3ui2TDhQ+ywqa0RWF2cyxpyBojUEDtqoABYnsXlgSTLwWCWnhJPaBs428zwsZlNmwUpboWtF0D3tLg6RlfKo/i+cuvCXVfSUuC3y1pLfnyz5YG/M3Ey+UywYPT+b+w2PhhXgJY1cuSWiunKwOy4rAZAvzIHrWd7/vAbtQpm0ElShX6EJ6IX0Q7uFOR55iuR4KgBA1MdSPgqMcE8gWFkCKnM/Jykjd/aab2M=
Content-Type: text/plain; charset="utf-8"
Content-ID: <23411EEE6753F64894B885E3F75CECE2@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d6b8f39f-9a8e-4f42-0e30-08d6f36b0889
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jun 2019 21:30:34.8833
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2230
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCAyMDE5LTA2LTE3IGF0IDE0OjAyIC0wNzAwLCBEYXZpZCBNaWxsZXIgd3JvdGU6DQo+
IEZyb206IEFybmQgQmVyZ21hbm4gPGFybmRAYXJuZGIuZGU+DQo+IERhdGU6IE1vbiwgMTcgSnVu
IDIwMTkgMTM6MDg6MjIgKzAyMDANCj4gDQo+ID4gUHV0dGluZyBhbiBlbXB0eSAnbWx4NV9mbG93
X3NwZWMnIHN0cnVjdHVyZSBvbiB0aGUgc3RhY2sgaXMgYSBiaXQNCj4gPiB3YXN0ZWZ1bCBhbmQg
Y2F1c2VzIGEgd2FybmluZyBvbiAzMi1iaXQgYXJjaGl0ZWN0dXJlcyB3aGVuIGJ1aWxkaW5nDQo+
ID4gd2l0aCBjbGFuZyAtZnNhbml0aXplLWNvdmVyYWdlOg0KPiA+IA0KPiA+IGRyaXZlcnMvbmV0
L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lc3dpdGNoX29mZmxvYWRzX3Rlcm10YmwuYzoN
Cj4gPiBJbiBmdW5jdGlvbiAnbWx4NV9lc3dpdGNoX3Rlcm10YmxfY3JlYXRlJzoNCj4gPiBkcml2
ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZXN3aXRjaF9vZmZsb2Fkc190ZXJt
dGJsLmM6DQo+ID4gOTA6MTogZXJyb3I6IHRoZSBmcmFtZSBzaXplIG9mIDEwMzIgYnl0ZXMgaXMg
bGFyZ2VyIHRoYW4gMTAyNCBieXRlcw0KPiA+IFstV2Vycm9yPWZyYW1lLWxhcmdlci10aGFuPV0N
Cj4gPiANCj4gPiBTaW5jZSB0aGUgc3RydWN0dXJlIGlzIG5ldmVyIHdyaXR0ZW4gdG8sIHdlIGNh
biBzdGF0aWNhbGx5IGFsbG9jYXRlDQo+ID4gaXQgdG8gYXZvaWQgdGhlIHN0YWNrIHVzYWdlLiBU
byBiZSBvbiB0aGUgc2FmZSBzaWRlLCBtYXJrIGFsbA0KPiA+IHN1YnNlcXVlbnQgZnVuY3Rpb24g
YXJndW1lbnRzIHRoYXQgd2UgcGFzcyBpdCBpbnRvIGFzICdjb25zdCcNCj4gPiBhcyB3ZWxsLg0K
PiA+IA0KPiA+IEZpeGVzOiAxMGNhYWJkYWFkNWEgKCJuZXQvbWx4NWU6IFVzZSB0ZXJtaW5hdGlv
biB0YWJsZSBmb3IgVkxBTg0KPiA+IHB1c2ggYWN0aW9ucyIpDQo+ID4gU2lnbmVkLW9mZi1ieTog
QXJuZCBCZXJnbWFubiA8YXJuZEBhcm5kYi5kZT4NCj4gDQo+IFNhZWVkLCBvbmNlIEFybmQgZml4
ZXMgdGhlIHJldmVyc2UgY2hyaXN0bWFzIHRyZWUgaXNzdWUsIEkgYXNzdW1lIHlvdQ0KPiB3aWxs
IHRha2UNCj4gdGhpcyBpbiB2aWEgeW91ciB0cmVlPw0KDQpZZXMsIHRoaXMgaXMgYSBjb3JlIGNo
YW5nZSB0aGF0IG1pZ2h0IGNvbmZsaWN0IHdpdGggc29tZSBvbmdvaW5nIHN0dWZmLg0KDQpUaGFu
ayB5b3UgRGF2ZSAhDQpTYWVlZC4NCg==
