Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD013422D4
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 12:43:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391805AbfFLKmv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 06:42:51 -0400
Received: from mail-eopbgr60060.outbound.protection.outlook.com ([40.107.6.60]:3413
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2389150AbfFLKmv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 Jun 2019 06:42:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XxjNZT99PoyVDblYkgfj2RavmbUPLPlzQmXpXT8gbu8=;
 b=MPoY2wDrrIzUx4JvgPeWDtR7jp92fYKUjYGED1clxt/WSVmL2mS5/qkfKff9rwx70dgkZGMi8fmGPuFn0Ga5pJrWP6MMyDJ0s5nNb8cl8d2qmEAAHGSpKjjVj/stt/4Mx+HOq+JRkFUEFMvcLK4iAcDF/VkxNibCtuOAfeyJIF8=
Received: from AM6PR05MB5879.eurprd05.prod.outlook.com (20.179.0.76) by
 AM6PR05MB4405.eurprd05.prod.outlook.com (52.135.163.23) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1965.14; Wed, 12 Jun 2019 10:42:34 +0000
Received: from AM6PR05MB5879.eurprd05.prod.outlook.com
 ([fe80::9527:fe9d:2a02:41d5]) by AM6PR05MB5879.eurprd05.prod.outlook.com
 ([fe80::9527:fe9d:2a02:41d5%5]) with mapi id 15.20.1987.010; Wed, 12 Jun 2019
 10:42:34 +0000
From:   Maxim Mikityanskiy <maximmi@mellanox.com>
To:     Jonas Bonn <jonas@norrbonn.se>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Subject: Re: [PATCH 1/1] Address regression in inet6_validate_link_af
Thread-Topic: [PATCH 1/1] Address regression in inet6_validate_link_af
Thread-Index: AQHVIDzu/Smg4fm3OEOQVEC2DfH3j6aX1piA
Date:   Wed, 12 Jun 2019 10:42:34 +0000
Message-ID: <58ac6ec1-9255-0e51-981a-195c2b1ac380@mellanox.com>
References: <20190611100327.16551-1-jonas@norrbonn.se>
In-Reply-To: <20190611100327.16551-1-jonas@norrbonn.se>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM0PR0102CA0008.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:14::21) To AM6PR05MB5879.eurprd05.prod.outlook.com
 (2603:10a6:20b:a2::12)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=maximmi@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [95.67.35.250]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4b212d13-394e-498e-c38b-08d6ef22ad7b
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM6PR05MB4405;
x-ms-traffictypediagnostic: AM6PR05MB4405:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <AM6PR05MB44053C9E86351FCE13BC8ED5D1EC0@AM6PR05MB4405.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:132;
x-forefront-prvs: 0066D63CE6
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(376002)(39860400002)(136003)(346002)(396003)(199004)(189003)(26005)(6512007)(110136005)(486006)(31686004)(11346002)(7736002)(446003)(6506007)(6486002)(2616005)(316002)(256004)(102836004)(54906003)(386003)(14444005)(478600001)(99286004)(6436002)(186003)(476003)(53546011)(8936002)(229853002)(76176011)(52116002)(5660300002)(25786009)(36756003)(6306002)(71190400001)(71200400001)(81156014)(8676002)(66066001)(81166006)(6246003)(2906002)(14454004)(2501003)(73956011)(966005)(66946007)(305945005)(4326008)(66446008)(66556008)(2201001)(64756008)(3846002)(53936002)(66476007)(86362001)(31696002)(68736007)(6116002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR05MB4405;H:AM6PR05MB5879.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: bXXvrzJIyUwU+hMnlfVi7sPrEiw95an3OxEyxO+vnhvE8xx7AzbUrtvAOOaQhn9M1VjgGUbiiL2EIw3eWeZe13QcSz4O5vPOKx0a15MD/yvYBrvTHhWtiml+Zyh0PSUpabb7EzwnEw7YA9N5GQ7+GcVyxAm/qoNkvBSvs/n8HOxmqs4RYZp0tn34rITFtWvf3WT36mjOXWmh383mggpTSq6Jo/yxJAC9xbxOh1DZf0qIjo8NFrAn3Cs/fxbrH4R6GCvXnmwux8gzgCT6125dS6bCpD7BytHTe+ODFC0PG7xM8Uu5DT+9c/zeodQ8CUsnfR7tCVsZXfxCeE8chJ9SjZg1v/DmEBfItKx0xiJoQIiMaUuJ0A3bjhaNWBgzGLbdDfI4qI2Frhpp1ojYwN8LNsyZDWFPgo7vdReJzRw5evc=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1E91B6206AB5E843A2DAE596681AEEDF@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b212d13-394e-498e-c38b-08d6ef22ad7b
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jun 2019 10:42:34.0978
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: maximmi@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB4405
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMjAxOS0wNi0xMSAxMzowMywgSm9uYXMgQm9ubiB3cm90ZToNCj4gUGF0Y2ggN2RjMmJjY2Fi
MGVlMzdhYzI4MDk2YjhmY2RjMzkwYTY3OWExNTg0MSBpbnRyb2R1Y2VzIGEgcmVncmVzc2lvbg0K
PiB3aXRoIHN5c3RlbWQgMjQxLiAgSW4gdGhhdCByZXZpc2lvbiwgc3lzdGVtZC1uZXR3b3JrZCBm
YWlscyB0byBwYXNzIHRoZQ0KPiByZXF1aXJlZCBmbGFncyBlYXJseSBlbm91Z2guICBUaGlzIGFw
cGVhcnMgdG8gYmUgYWRkcmVzc2VkIGluIGxhdGVyDQo+IHZlcnNpb25zIG9mIHN5c3RlbWQsIGJ1
dCBmb3IgdXNlcnMgb2YgdmVyc2lvbiAyNDEgd2hlcmUgc3lzdGVtZC1uZXR3b3JrZA0KPiBub25l
dGhlbGVzcyB3b3JrZWQgd2l0aCBlYXJsaWVyIGtlcm5lbHMsIHRoZSBzdHJpY3QgY2hlY2sgaW50
cm9kdWNlZCBieQ0KPiB0aGUgcGF0Y2ggY2F1c2VzIGEgcmVncmVzc2lvbiBpbiBiZWhhdmlvdXIu
DQo+IA0KPiBUaGlzIHBhdGNoIGNvbnZlcnRzIHRoZSBmYWlsdXJlIHRvIHN1cHBseSB0aGUgcmVx
dWlyZWQgZmxhZ3MgZnJvbSBhbg0KPiBlcnJvciBpbnRvIGEgd2FybmluZy4NClRoZSBwdXJwb3Nl
IG9mIG15IHBhdGNoIHdhcyB0byBwcmV2ZW50IGEgcGFydGlhbCBjb25maWd1cmF0aW9uIHVwZGF0
ZSBvbiANCmludmFsaWQgaW5wdXQuIC1FSU5WQUwgd2FzIHJldHVybmVkIGJvdGggYmVmb3JlIGFu
ZCBhZnRlciBteSBwYXRjaCwgdGhlIA0KZGlmZmVyZW5jZSBpcyB0aGF0IGJlZm9yZSBteSBwYXRj
aCB0aGVyZSB3YXMgYSBwYXJ0aWFsIHVwZGF0ZSBhbmQgYSB3YXJuaW5nLg0KDQpZb3VyIHBhdGNo
IGJhc2ljYWxseSBtYWtlcyBtaW5lIHBvaW50bGVzcywgYmVjYXVzZSB5b3UgcmV2ZXJ0IHRoZSBm
aXgsIA0KYW5kIG5vdyB3ZSdsbCBoYXZlIHRoZSBzYW1lIHBhcnRpYWwgdXBkYXRlIGFuZCB0d28g
d2FybmluZ3MuDQoNCk9uZSBtb3JlIHRoaW5nIGlzIHRoYXQgYWZ0ZXIgYXBwbHlpbmcgeW91ciBw
YXRjaCBvbiB0b3Agb2YgbWluZSwgdGhlIA0Ka2VybmVsIHdvbid0IHJldHVybiAtRUlOVkFMIGFu
eW1vcmUgb24gaW52YWxpZCBpbnB1dC4gUmV0dXJuaW5nIC1FSU5WQUwgDQppcyB3aGF0IGhhcHBl
bmVkIGJlZm9yZSBteSBwYXRjaCwgYW5kIGFsc28gYWZ0ZXIgbXkgcGF0Y2guDQoNClJlZ2FyZGlu
ZyB0aGUgc3lzdGVtZCBpc3N1ZSwgSSBkb24ndCB0aGluayB3ZSBzaG91bGQgY2hhbmdlIHRoZSBr
ZXJuZWwgDQp0byBhZGFwdCB0byBidWdzIGluIHN5c3RlbWQuIHN5c3RlbWQgZGlkbid0IGhhdmUg
dGhpcyBidWcgZnJvbSBkYXkgb25lLCANCml0IHdhcyBhIHJlZ3Jlc3Npb24gaW50cm9kdWNlZCBp
biBbMV0uIFRoZSBrZXJuZWwgaGFzIGFsd2F5cyByZXR1cm5lZCANCi1FSU5WQUwgaGVyZSwgYnV0
IHRoZSBiZWhhdmlvciBiZWZvcmUgbXkgcGF0Y2ggd2FzIGJhc2ljYWxseSBhIFVCLCBhbmQgDQph
ZnRlciB0aGUgcGF0Y2ggaXQncyB3ZWxsLWRlZmluZWQuIElmIHN5c3RlbWQgc2F3IEVJTlZBTCBh
bmQgcmVsaWVkIG9uIA0KdGhlIFVCIHRoYXQgY2FtZSB3aXRoIGl0LCBpdCBjYW4ndCBiZSBhIHJl
YXNvbiBlbm91Z2ggdG8gYnJlYWsgdGhlIGtlcm5lbC4NCg0KTW9yZW92ZXIsIHRoZSBidWcgbG9v
a3MgZml4ZWQgaW4gc3lzdGVtZCdzIG1hc3Rlciwgc28gd2hhdCB5b3Ugc3VnZ2VzdCANCmlzIHRv
IGluc2VydCBhIGtlcm5lbC1zaWRlIHdvcmthcm91bmQgZm9yIGFuIG9sZCB2ZXJzaW9uIG9mIHNv
ZnR3YXJlIA0Kd2hlbiB0aGVyZSBpcyBhIGZpeGVkIG9uZS4NCg0KUGxlYXNlIGNvcnJlY3QgbWUg
aWYgYW55dGhpbmcgSSBzYXkgaXMgd3JvbmcuDQoNClRoYW5rcywNCk1heA0KDQpbMV06IA0KaHR0
cHM6Ly9naXRodWIuY29tL3N5c3RlbWQvc3lzdGVtZC9jb21taXQvMGUyZmRiODNiYjVlMjIwNDdl
MGM3Y2MwNThiNDE1ZDBlOTNmMDJjZg0KDQo+IFdpdGggdGhpcywgc3lzdGVtZC1uZXR3b3JrZCB2
ZXJzaW9uIDI0MSBvbmNlDQo+IGFnYWluIGlzIGFibGUgdG8gYnJpbmcgdXAgdGhlIGxpbmssIGFs
YmVpdCBub3QgcXVpdGUgYXMgaW50ZW5kZWQgYW5kDQo+IHRoZXJlYnkgd2l0aCBhIHdhcm5pbmcg
aW4gdGhlIGtlcm5lbCBsb2cuDQo+IA0KPiBDQzogTWF4aW0gTWlraXR5YW5za2l5IDxtYXhpbW1p
QG1lbGxhbm94LmNvbT4NCj4gQ0M6IERhdmlkIFMuIE1pbGxlciA8ZGF2ZW1AZGF2ZW1sb2Z0Lm5l
dD4NCj4gQ0M6IEFsZXhleSBLdXpuZXRzb3YgPGt1em5ldEBtczIuaW5yLmFjLnJ1Pg0KPiBDQzog
SGlkZWFraSBZT1NISUZVSkkgPHlvc2hmdWppQGxpbnV4LWlwdjYub3JnPg0KPiBTaWduZWQtb2Zm
LWJ5OiBKb25hcyBCb25uIDxqb25hc0Bub3JyYm9ubi5zZT4NCj4gLS0tDQo+ICAgbmV0L2lwdjYv
YWRkcmNvbmYuYyB8IDMgKystDQo+ICAgMSBmaWxlIGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygrKSwg
MSBkZWxldGlvbigtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL25ldC9pcHY2L2FkZHJjb25mLmMgYi9u
ZXQvaXB2Ni9hZGRyY29uZi5jDQo+IGluZGV4IDA4MWJiNTE3ZTQwZC4uZTI0NzdiZjkyZTEyIDEw
MDY0NA0KPiAtLS0gYS9uZXQvaXB2Ni9hZGRyY29uZi5jDQo+ICsrKyBiL25ldC9pcHY2L2FkZHJj
b25mLmMNCj4gQEAgLTU2OTYsNyArNTY5Niw4IEBAIHN0YXRpYyBpbnQgaW5ldDZfdmFsaWRhdGVf
bGlua19hZihjb25zdCBzdHJ1Y3QgbmV0X2RldmljZSAqZGV2LA0KPiAgIAkJcmV0dXJuIGVycjsN
Cj4gICANCj4gICAJaWYgKCF0YltJRkxBX0lORVQ2X1RPS0VOXSAmJiAhdGJbSUZMQV9JTkVUNl9B
RERSX0dFTl9NT0RFXSkNCj4gLQkJcmV0dXJuIC1FSU5WQUw7DQo+ICsJCW5ldF93YXJuX3JhdGVs
aW1pdGVkKA0KPiArCQkJInJlcXVpcmVkIGxpbmsgZmxhZyBvbWl0dGVkOiBUT0tFTi9BRERSX0dF
Tl9NT0RFXG4iKTsNCj4gICANCj4gICAJaWYgKHRiW0lGTEFfSU5FVDZfQUREUl9HRU5fTU9ERV0p
IHsNCj4gICAJCXU4IG1vZGUgPSBubGFfZ2V0X3U4KHRiW0lGTEFfSU5FVDZfQUREUl9HRU5fTU9E
RV0pOw0KPiANCg0K
