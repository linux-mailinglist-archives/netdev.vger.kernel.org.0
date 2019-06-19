Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D3754B922
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 14:52:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731809AbfFSMwc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 08:52:32 -0400
Received: from mail-eopbgr20047.outbound.protection.outlook.com ([40.107.2.47]:15236
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727002AbfFSMwc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Jun 2019 08:52:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W7Om8YSM986taU+Qt2taJ6w5cCNP5WaQ5vGLTPkymQo=;
 b=ZdxlavRYyPfJuliROVBYBY/qvTvLBw0T/QTJ/u72Bj5LJoUs4WPwAs/gTqNwQHXjGL1J7a3nWKR6c1Bsjpz3mqYD9bL0j/oHQeJPpyPxbADnc916on39KJkHpPJ80mHf8LJkvT6BeE+tpiz6u6XLs6cmjWYZwJhf4NVoRSg2gPI=
Received: from VI1PR05MB6255.eurprd05.prod.outlook.com (20.178.205.93) by
 VI1PR05MB6575.eurprd05.prod.outlook.com (20.179.25.213) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.13; Wed, 19 Jun 2019 12:52:27 +0000
Received: from VI1PR05MB6255.eurprd05.prod.outlook.com
 ([fe80::1c71:b7b7:cf55:48bb]) by VI1PR05MB6255.eurprd05.prod.outlook.com
 ([fe80::1c71:b7b7:cf55:48bb%7]) with mapi id 15.20.1987.014; Wed, 19 Jun 2019
 12:52:27 +0000
From:   Jianbo Liu <jianbol@mellanox.com>
To:     Parav Pandit <parav@mellanox.com>
CC:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Eli Britstein <elibr@mellanox.com>,
        Roi Dayan <roid@mellanox.com>, Mark Bloch <markb@mellanox.com>
Subject: Re: [PATCH mlx5-next 05/15] net/mlx5: E-Switch, Tag packet with vport
 number in VF vports and uplink ingress ACLs
Thread-Topic: [PATCH mlx5-next 05/15] net/mlx5: E-Switch, Tag packet with
 vport number in VF vports and uplink ingress ACLs
Thread-Index: AQHVJUIe4CH/LI+8A02ewuMUSS8rDqahN3UAgAG5awA=
Date:   Wed, 19 Jun 2019 12:52:27 +0000
Message-ID: <20190619125122.GA14681@mellanox.com>
References: <20190617192247.25107-1-saeedm@mellanox.com>
 <20190617192247.25107-6-saeedm@mellanox.com>
 <AM0PR05MB48664868E0B89E582807830BD1EA0@AM0PR05MB4866.eurprd05.prod.outlook.com>
In-Reply-To: <AM0PR05MB48664868E0B89E582807830BD1EA0@AM0PR05MB4866.eurprd05.prod.outlook.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: LO2P265CA0310.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a5::34) To VI1PR05MB6255.eurprd05.prod.outlook.com
 (2603:10a6:803:ed::29)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=jianbol@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [37.142.13.130]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 16711847-9570-401e-bab2-08d6f4b4fb74
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR05MB6575;
x-ms-traffictypediagnostic: VI1PR05MB6575:
x-microsoft-antispam-prvs: <VI1PR05MB65758B0D4A7D22A5636D7EC3C8E50@VI1PR05MB6575.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3513;
x-forefront-prvs: 0073BFEF03
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(39860400002)(366004)(376002)(346002)(396003)(189003)(199004)(13464003)(476003)(2906002)(6486002)(3846002)(25786009)(86362001)(6116002)(1076003)(66066001)(8676002)(4326008)(6862004)(14444005)(6436002)(6246003)(6636002)(68736007)(256004)(26005)(6512007)(53936002)(33656002)(478600001)(446003)(102836004)(66476007)(316002)(37006003)(8936002)(71200400001)(305945005)(73956011)(107886003)(76176011)(7736002)(64756008)(5660300002)(52116002)(450100002)(66446008)(186003)(229853002)(66556008)(386003)(81156014)(14454004)(11346002)(54906003)(2616005)(53546011)(99286004)(66946007)(6506007)(71190400001)(81166006)(36756003)(486006);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB6575;H:VI1PR05MB6255.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: YA1pDN3p4stN6wm6WvRzelkwn3k0TvSbVd74wWgNdSaoQyGvYD2XqJudoAyodtj3tilj403Py8TRxYiPVhtiYR6xMPGpIze81ZvKfoVVJSPQ60hUSo/gZr9yiNLUA87zyAYW0DGjyHhAXXzd8HZ5Kfqd7HbeSGGjYYwMZdleiTAVdN14sezPSWVW/LmmO3o21jOQrUVCg2Ao4kibXIbfF/dKXGy8i0Q8S0NU8JJSPed+/BYe9PP8cwXOlCrMqHvVLG0FegoBzGZ+SPHbfARAcpW45/wsjTh18fxyV2+f2wN7MEHekEQTjHfH63EYBt74TavARLEmaleJcfDEu6V7D5uD0N2vi/l7yezT7yUJEbYJRympl+eYj9ivIcIH07Mps+UKTErhoThUBlgE6VU3KhhqoQYGN1ww8R+T8Q8gp8E=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C0C334EBD81F5C48B0C7DBBD260E1FC3@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 16711847-9570-401e-bab2-08d6f4b4fb74
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jun 2019 12:52:27.2583
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jianbol@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6575
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VGhlIDA2LzE4LzIwMTkgMTg6MzEsIFBhcmF2IFBhbmRpdCB3cm90ZToNCj4gDQo+IA0KPiA+IC0t
LS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+ID4gRnJvbTogbmV0ZGV2LW93bmVyQHZnZXIua2Vy
bmVsLm9yZyA8bmV0ZGV2LW93bmVyQHZnZXIua2VybmVsLm9yZz4gT24NCj4gPiBCZWhhbGYgT2Yg
U2FlZWQgTWFoYW1lZWQNCj4gPiBTZW50OiBUdWVzZGF5LCBKdW5lIDE4LCAyMDE5IDEyOjUzIEFN
DQo+ID4gVG86IFNhZWVkIE1haGFtZWVkIDxzYWVlZG1AbWVsbGFub3guY29tPjsgTGVvbiBSb21h
bm92c2t5DQo+ID4gPGxlb25yb0BtZWxsYW5veC5jb20+DQo+ID4gQ2M6IG5ldGRldkB2Z2VyLmtl
cm5lbC5vcmc7IGxpbnV4LXJkbWFAdmdlci5rZXJuZWwub3JnOyBKaWFuYm8gTGl1DQo+ID4gPGpp
YW5ib2xAbWVsbGFub3guY29tPjsgRWxpIEJyaXRzdGVpbiA8ZWxpYnJAbWVsbGFub3guY29tPjsg
Um9pIERheWFuDQo+ID4gPHJvaWRAbWVsbGFub3guY29tPjsgTWFyayBCbG9jaCA8bWFya2JAbWVs
bGFub3guY29tPg0KPiA+IFN1YmplY3Q6IFtQQVRDSCBtbHg1LW5leHQgMDUvMTVdIG5ldC9tbHg1
OiBFLVN3aXRjaCwgVGFnIHBhY2tldCB3aXRoIHZwb3J0DQo+ID4gbnVtYmVyIGluIFZGIHZwb3J0
cyBhbmQgdXBsaW5rIGluZ3Jlc3MgQUNMcw0KPiA+IA0KPiA+IEZyb206IEppYW5ibyBMaXUgPGpp
YW5ib2xAbWVsbGFub3guY29tPg0KPiA+IA0KPiA+IFdoZW4gYSBkdWFsLXBvcnQgVkhDQSBzZW5k
cyBhIFJvQ0UgcGFja2V0IG9uIGl0cyBub24tbmF0aXZlIHBvcnQsIGFuZCB0aGUNCj4gPiBwYWNr
ZXQgYXJyaXZlcyB0byBpdHMgYWZmaWxpYXRlZCB2cG9ydCBGREIsIGEgbWlzbWF0Y2ggbWlnaHQg
b2NjdXIgb24gdGhlIHJ1bGVzDQo+ID4gdGhhdCBtYXRjaCB0aGUgcGFja2V0IHNvdXJjZSB2cG9y
dCBhcyBpdCBpcyBub3QgcmVwcmVzZW50ZWQgYnkgc2luZ2xlIFZIQ0Egb25seQ0KPiA+IGluIHRo
aXMgY2FzZS4gU28gd2UgY2hhbmdlIHRvIG1hdGNoIG9uIG1ldGFkYXRhIGluc3RlYWQgb2Ygc291
cmNlIHZwb3J0Lg0KPiA+IFRvIGRvIHRoYXQsIGEgcnVsZSBpcyBjcmVhdGVkIGluIGFsbCB2cG9y
dHMgYW5kIHVwbGluayBpbmdyZXNzIEFDTHMsIHRvIHNhdmUgdGhlDQo+ID4gc291cmNlIHZwb3J0
IG51bWJlciBhbmQgdmhjYSBpZCBpbiB0aGUgcGFja2V0J3MgbWV0YWRhdGEgaW4gb3JkZXIgdG8g
bWF0Y2ggb24NCj4gPiBpdCBsYXRlci4NCj4gPiBUaGUgbWV0YWRhdGEgcmVnaXN0ZXIgdXNlZCBp
cyB0aGUgZmlyc3Qgb2YgdGhlIDMyLWJpdCB0eXBlIEMgcmVnaXN0ZXJzLiBJdCBjYW4gYmUNCj4g
PiB1c2VkIGZvciBtYXRjaGluZyBhbmQgaGVhZGVyIG1vZGlmeSBvcGVyYXRpb25zLiBUaGUgaGln
aGVyIDE2IGJpdHMgb2YgdGhpcw0KPiA+IHJlZ2lzdGVyIGFyZSBmb3IgdmhjYSBpZCwgYW5kIHRo
ZSBsb3dlciAxNiBvbmVzIGlzIGZvciB2cG9ydCBudW1iZXIuDQo+ID4gVGhpcyBjaGFuZ2UgaXMg
bm90IGZvciBkdWFsLXBvcnQgUm9DRSBvbmx5LiBJZiBIVyBhbmQgRlcgYWxsb3csIHRoZSB2cG9y
dA0KPiA+IG1ldGFkYXRhIG1hdGNoaW5nIGlzIGVuYWJsZWQgYnkgZGVmYXVsdC4NCj4gPiANCj4g
PiBTaWduZWQtb2ZmLWJ5OiBKaWFuYm8gTGl1IDxqaWFuYm9sQG1lbGxhbm94LmNvbT4NCj4gPiBS
ZXZpZXdlZC1ieTogRWxpIEJyaXRzdGVpbiA8ZWxpYnJAbWVsbGFub3guY29tPg0KPiA+IFJldmll
d2VkLWJ5OiBSb2kgRGF5YW4gPHJvaWRAbWVsbGFub3guY29tPg0KPiA+IFJldmlld2VkLWJ5OiBN
YXJrIEJsb2NoIDxtYXJrYkBtZWxsYW5veC5jb20+DQo+ID4gU2lnbmVkLW9mZi1ieTogU2FlZWQg
TWFoYW1lZWQgPHNhZWVkbUBtZWxsYW5veC5jb20+DQo+ID4gLS0tDQo+ID4gIC4uLi9uZXQvZXRo
ZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2Vzd2l0Y2guYyB8ICAgMiArDQo+ID4gIC4uLi9uZXQv
ZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2Vzd2l0Y2guaCB8ICAgOSArDQo+ID4gIC4uLi9t
ZWxsYW5veC9tbHg1L2NvcmUvZXN3aXRjaF9vZmZsb2Fkcy5jICAgICB8IDE4MyArKysrKysrKysr
KysrKy0tLS0NCj4gPiAgaW5jbHVkZS9saW51eC9tbHg1L2Vzd2l0Y2guaCAgICAgICAgICAgICAg
ICAgIHwgICAzICsNCj4gPiAgNCBmaWxlcyBjaGFuZ2VkLCAxNjEgaW5zZXJ0aW9ucygrKSwgMzYg
ZGVsZXRpb25zKC0pDQo+ID4gDQo+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0
L21lbGxhbm94L21seDUvY29yZS9lc3dpdGNoLmMNCj4gPiBiL2RyaXZlcnMvbmV0L2V0aGVybmV0
L21lbGxhbm94L21seDUvY29yZS9lc3dpdGNoLmMNCj4gPiBpbmRleCBhNDJhMjNlNTA1ZGYuLjEy
MzVmZDg0YWUzYSAxMDA2NDQNCj4gPiAtLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5v
eC9tbHg1L2NvcmUvZXN3aXRjaC5jDQo+ID4gKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVs
bGFub3gvbWx4NS9jb3JlL2Vzd2l0Y2guYw0KDQouLi4NCg0KPiA+ICsJCQllcnIgPSBlc3dfdnBv
cnRfZWdyZXNzX3ByaW9fdGFnX2NvbmZpZyhlc3csIHZwb3J0KTsNCj4gPiArCQkJaWYgKGVycikN
Cj4gPiArCQkJCWdvdG8gZXJyX2VncmVzczsNCj4gPiArCQl9DQo+ID4gIAl9DQo+ID4gDQo+ID4g
KwlpZiAobWx4NV9lc3dpdGNoX3Zwb3J0X21hdGNoX21ldGFkYXRhX2VuYWJsZWQoZXN3KSkNCj4g
PiArCQllc3dfaW5mbyhlc3ctPmRldiwgIlVzZSBtZXRhZGF0YSByZWdfYyBhcyBzb3VyY2UgdnBv
cnQgdG8NCj4gPiBtYXRjaFxuIik7DQo+ID4gKw0KPiA+ICAJcmV0dXJuIDA7DQo+ID4gDQo+ID4g
IGVycl9lZ3Jlc3M6DQo+ID4gIAllc3dfdnBvcnRfZGlzYWJsZV9pbmdyZXNzX2FjbChlc3csIHZw
b3J0KTsNCj4gPiAgZXJyX2luZ3Jlc3M6DQo+ID4gLQltbHg1X2Vzd19mb3JfZWFjaF92Zl92cG9y
dF9yZXZlcnNlKGVzdywgaiwgdnBvcnQsIGkgLSAxKSB7DQo+ID4gKwlmb3IgKGogPSBNTFg1X1ZQ
T1JUX1BGOyBqIDwgaTsgaisrKSB7DQo+IEtlZXAgdGhlIHJldmVyc2Ugb3JkZXIgYXMgYmVmb3Jl
Lg0KDQpUaGUgdnBvcnRzIGFyZSBpbmRlcGVuZGVudCBmcm9tIGVhY2ggb3RoZXIuIEl0IGRvZXNu
J3QgbWF0dGVyIGRpc2FibGluZw0KdGhlbSBpbiBvciBvdXQgb2Ygb3JkZXIuIEkgZG9uJ3QgdW5k
ZXJzdGFuZCB3aGF0J3MgdGhlIGJlbmlmaXQuDQoNCj4gDQo+ID4gKwkJdnBvcnQgPSAmZXN3LT52
cG9ydHNbal07DQo+ID4gIAkJZXN3X3Zwb3J0X2Rpc2FibGVfZWdyZXNzX2FjbChlc3csIHZwb3J0
KTsNCj4gPiAgCQllc3dfdnBvcnRfZGlzYWJsZV9pbmdyZXNzX2FjbChlc3csIHZwb3J0KTsNCj4g
PiAgCX0NCj4gPiBAQCAtMTcwNCwxNSArMTgwMCwxNyBAQCBzdGF0aWMgaW50IGVzd19wcmlvX3Rh
Z19hY2xzX2NvbmZpZyhzdHJ1Y3QNCj4gPiBtbHg1X2Vzd2l0Y2ggKmVzdywgaW50IG52cG9ydHMp
DQo+ID4gIAlyZXR1cm4gZXJyOw0KPiA+ICB9DQo+ID4gDQo+ID4gLXN0YXRpYyB2b2lkIGVzd19w
cmlvX3RhZ19hY2xzX2NsZWFudXAoc3RydWN0IG1seDVfZXN3aXRjaCAqZXN3KQ0KPiA+ICtzdGF0
aWMgdm9pZCBlc3dfZGVzdHJveV9vZmZsb2Fkc19hY2xfdGFibGVzKHN0cnVjdCBtbHg1X2Vzd2l0
Y2ggKmVzdykNCj4gPiAgew0KPiA+ICAJc3RydWN0IG1seDVfdnBvcnQgKnZwb3J0Ow0KPiA+ICAJ
aW50IGk7DQo+ID4gDQo+ID4gLQltbHg1X2Vzd19mb3JfZWFjaF92Zl92cG9ydChlc3csIGksIHZw
b3J0LCBlc3ctPm52cG9ydHMpIHsNCj4gPiArCW1seDVfZXN3X2Zvcl9hbGxfdnBvcnRzKGVzdywg
aSwgdnBvcnQpIHsNCj4gSWYgeW91IGFyZSBjaGFuZ2luZyB0aGlzLCBwbGVhc2UgZG8gaW4gcmV2
ZXJzZSBvcmRlciB0byBrZWVwIGl0IGV4YWN0IG1pcnJvciBvZiBjcmVhdGUvZW5hYmxlIHNlcXVl
bmNlLg0KDQpTYW1lLi4uDQoNCj4gDQo+ID4gIAkJZXN3X3Zwb3J0X2Rpc2FibGVfZWdyZXNzX2Fj
bChlc3csIHZwb3J0KTsNCj4gPiAgCQllc3dfdnBvcnRfZGlzYWJsZV9pbmdyZXNzX2FjbChlc3cs
IHZwb3J0KTsNCj4gPiAgCX0NCj4gPiArDQo+ID4gKwllc3ctPmZsYWdzICY9IH5NTFg1X0VTV0lU
Q0hfVlBPUlRfTUFUQ0hfTUVUQURBVEE7DQo+ID4gIH0NCj4gPiANCj4gPiAgc3RhdGljIGludCBl
c3dfb2ZmbG9hZHNfc3RlZXJpbmdfaW5pdChzdHJ1Y3QgbWx4NV9lc3dpdGNoICplc3csIGludCBu
dnBvcnRzKQ0K
