Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C48663CE5
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 22:55:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729803AbfGIUzF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jul 2019 16:55:05 -0400
Received: from mail-eopbgr20071.outbound.protection.outlook.com ([40.107.2.71]:58501
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726401AbfGIUzF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Jul 2019 16:55:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TmZF/ZOPFDU8goRcla575jbyli2VJnSGh2mDJ4Q/L50=;
 b=VnNo+yQhxiMPNzh70Xi3g6PI/59fNWscma9lBpihh7GhwmD+qwzvLEp8ezY2d3vcpzL4pLHayCp66RrDy/NVw+Rp1pbB5uRuOojddAxE9mCzECsQO7uC7LGyls0X07azhhEfUhb9BCqrR077bFAeA25Cyc++JsFEAAPqrjdaXMU=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2200.eurprd05.prod.outlook.com (10.168.55.8) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2032.20; Tue, 9 Jul 2019 20:54:58 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::649e:902c:98f2:258f]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::649e:902c:98f2:258f%5]) with mapi id 15.20.2052.020; Tue, 9 Jul 2019
 20:54:58 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "saeedm@dev.mellanox.co.il" <saeedm@dev.mellanox.co.il>,
        "leon@kernel.org" <leon@kernel.org>
CC:     Eran Ben Elisha <eranbe@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Tariq Toukan <tariqt@mellanox.com>
Subject: Re: [PATCH mlx5-next 4/5] net/mlx5: Introduce TLS TX offload hardware
 bits and structures
Thread-Topic: [PATCH mlx5-next 4/5] net/mlx5: Introduce TLS TX offload
 hardware bits and structures
Thread-Index: AQHVMXJ0R4Qy/8TrKUie2vzu8va3aaa4oDOAgAISrgCAAAJWgIAAAZsAgAAQzoCACAabAA==
Date:   Tue, 9 Jul 2019 20:54:58 +0000
Message-ID: <c5cc4604e5759e5b8a056a3baefb8a3d3caf4f74.camel@mellanox.com>
References: <20190703073909.14965-1-saeedm@mellanox.com>
         <20190703073909.14965-5-saeedm@mellanox.com>
         <20190703092735.GZ4727@mtr-leonro.mtl.com>
         <CALzJLG-em1w+Lgf2UutbG2Lzq8bx3zUqoLGx26H2_EXOuuk+jg@mail.gmail.com>
         <20190704171519.GE7212@mtr-leonro.mtl.com>
         <CALzJLG--k3z2HuV09tivJuOtU-BFAyCEV1vJbPqYX+OyskggmQ@mail.gmail.com>
         <20190704182113.GG7212@mtr-leonro.mtl.com>
In-Reply-To: <20190704182113.GG7212@mtr-leonro.mtl.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.3 (3.32.3-1.fc30) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 83cf0981-83f5-409c-1aad-08d704afb439
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2200;
x-ms-traffictypediagnostic: DB6PR0501MB2200:
x-microsoft-antispam-prvs: <DB6PR0501MB22002953D88C6DB2C1A176E8BEF10@DB6PR0501MB2200.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1443;
x-forefront-prvs: 0093C80C01
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(39860400002)(346002)(396003)(376002)(366004)(199004)(189003)(36756003)(107886003)(6512007)(4326008)(6436002)(6486002)(76116006)(91956017)(256004)(118296001)(8936002)(486006)(66066001)(7736002)(58126008)(25786009)(8676002)(86362001)(66946007)(54906003)(3846002)(66446008)(14454004)(2906002)(446003)(6246003)(6116002)(71200400001)(229853002)(76176011)(5660300002)(11346002)(68736007)(476003)(305945005)(6506007)(478600001)(81166006)(2616005)(53546011)(316002)(110136005)(99286004)(2501003)(66476007)(186003)(66556008)(102836004)(53936002)(26005)(81156014)(71190400001)(64756008);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2200;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: dTYYACBoenUrNgntjZRnF4vHy1KuDmgen/OO5aBtviLbHJSR8KRzU9x8mG4L3shiTOgIYWdlocNtkQZtt2aYk7YRrdLBt0gkg8v2U+qp9Kr+Uo0HsNA2Skm0aAffOF1xYcU4QhxNvqEIFS+3MWmXr9y7I/d2z08Ql4bU4c1im2tfegdRWlk8wQuUyaymenOB76KxfTwViJbhaTbQHTw+GN4MYztbNa1CMWBAV+Mw7szlClrrK1PWwII4PQc/Y6sX8yAojiUeqbw/ho4JC4fAZrIxQe/jLOpychgrIKnbNBi9Pk9etliMw0rwqHIvqKhPcc3a7tww2l2qh0w/f6G6dfDaq9paR80NKIR7JtSaMQOkyAFmccucXcQfCkDOU52U+yEZz9U2tlNbtNoxKoMpXWvx42gS7AZ1EAehtd+u4/o=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0A75ADA5DF35764190B442EDA6962C7E@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 83cf0981-83f5-409c-1aad-08d704afb439
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jul 2019 20:54:58.3561
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2200
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCAyMDE5LTA3LTA0IGF0IDIxOjIxICswMzAwLCBMZW9uIFJvbWFub3Zza3kgd3JvdGU6
DQo+IE9uIFRodSwgSnVsIDA0LCAyMDE5IGF0IDAxOjIxOjA0UE0gLTA0MDAsIFNhZWVkIE1haGFt
ZWVkIHdyb3RlOg0KPiA+IE9uIFRodSwgSnVsIDQsIDIwMTkgYXQgMToxNSBQTSBMZW9uIFJvbWFu
b3Zza3kgPGxlb25Aa2VybmVsLm9yZz4NCj4gPiB3cm90ZToNCj4gPiA+IE9uIFRodSwgSnVsIDA0
LCAyMDE5IGF0IDAxOjA2OjU4UE0gLTA0MDAsIFNhZWVkIE1haGFtZWVkIHdyb3RlOg0KPiA+ID4g
PiBPbiBXZWQsIEp1bCAzLCAyMDE5IGF0IDU6MjcgQU0gPGxlb25Aa2VybmVsLm9yZz4gd3JvdGU6
DQo+ID4gPiA+ID4gT24gV2VkLCBKdWwgMDMsIDIwMTkgYXQgMDc6Mzk6MzJBTSArMDAwMCwgU2Fl
ZWQgTWFoYW1lZWQNCj4gPiA+ID4gPiB3cm90ZToNCj4gPiA+ID4gPiA+IEZyb206IEVyYW4gQmVu
IEVsaXNoYSA8ZXJhbmJlQG1lbGxhbm94LmNvbT4NCj4gPiA+ID4gPiA+IA0KPiA+ID4gPiA+ID4g
QWRkIFRMUyBvZmZsb2FkIHJlbGF0ZWQgSUZDIHN0cnVjdHMsIGxheW91dHMgYW5kDQo+ID4gPiA+
ID4gPiBlbnVtZXJhdGlvbnMuDQo+ID4gPiA+ID4gPiANCj4gPiA+ID4gPiA+IFNpZ25lZC1vZmYt
Ynk6IEVyYW4gQmVuIEVsaXNoYSA8ZXJhbmJlQG1lbGxhbm94LmNvbT4NCj4gPiA+ID4gPiA+IFNp
Z25lZC1vZmYtYnk6IFRhcmlxIFRvdWthbiA8dGFyaXF0QG1lbGxhbm94LmNvbT4NCj4gPiA+ID4g
PiA+IFNpZ25lZC1vZmYtYnk6IFNhZWVkIE1haGFtZWVkIDxzYWVlZG1AbWVsbGFub3guY29tPg0K
PiA+ID4gPiA+ID4gLS0tDQo+ID4gPiA+ID4gPiAgaW5jbHVkZS9saW51eC9tbHg1L2RldmljZS5o
ICAgfCAgMTQgKysrKysNCj4gPiA+ID4gPiA+ICBpbmNsdWRlL2xpbnV4L21seDUvbWx4NV9pZmMu
aCB8IDEwNA0KPiA+ID4gPiA+ID4gKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKystLQ0K
PiA+ID4gPiA+ID4gIDIgZmlsZXMgY2hhbmdlZCwgMTE0IGluc2VydGlvbnMoKyksIDQgZGVsZXRp
b25zKC0pDQo+ID4gPiA+ID4gDQo+ID4gPiA+ID4gPC4uLj4NCj4gPiA+ID4gPiANCj4gPiA+ID4g
PiA+IEBAIC0yNzI1LDcgKzI3MzksOCBAQCBzdHJ1Y3QgbWx4NV9pZmNfdHJhZmZpY19jb3VudGVy
X2JpdHMNCj4gPiA+ID4gPiA+IHsNCj4gPiA+ID4gPiA+IA0KPiA+ID4gPiA+ID4gIHN0cnVjdCBt
bHg1X2lmY190aXNjX2JpdHMgew0KPiA+ID4gPiA+ID4gICAgICAgdTggICAgICAgICBzdHJpY3Rf
bGFnX3R4X3BvcnRfYWZmaW5pdHlbMHgxXTsNCj4gPiA+ID4gPiA+IC0gICAgIHU4ICAgICAgICAg
cmVzZXJ2ZWRfYXRfMVsweDNdOw0KPiA+ID4gPiA+ID4gKyAgICAgdTggICAgICAgICB0bHNfZW5b
MHgxXTsNCj4gPiA+ID4gPiA+ICsgICAgIHU4ICAgICAgICAgcmVzZXJ2ZWRfYXRfMVsweDJdOw0K
PiA+ID4gPiA+IA0KPiA+ID4gPiA+IEl0IHNob3VsZCBiZSByZXNlcnZlZF9hdF8yLg0KPiA+ID4g
PiA+IA0KPiA+ID4gPiANCj4gPiA+ID4gaXQgc2hvdWxkIGJlIGF0XzEuDQo+ID4gPiANCj4gPiA+
IFdoeT8gU2VlIG1seDVfaWZjX2Zsb3dfdGFibGVfcHJvcF9sYXlvdXRfYml0cywNCj4gPiA+IG1s
eDVfaWZjX3JvY2VfY2FwX2JpdHMsIGUudC5jLg0KPiA+ID4gDQo+ID4gDQo+ID4gdGhleSBhcmUg
YWxsIGF0XzEgLi4gc28gaSBkb24ndCByZWFsbHkgdW5kZXJzdGFuZCB3aGF0IHlvdSB3YW50DQo+
ID4gZnJvbSBtZSwNCj4gPiBMZW9uIHRoZSBjb2RlIGlzIGdvb2QsIHBsZWFzZSBkb3VibGUgY2hl
Y2sgeW91IGNvbW1lbnRzLi4NCj4gDQo+IFNhZWVkLA0KPiANCj4gcmVzZXJ2ZWRfYXRfMSBzaG91
bGQgYmUgcmVuYW1lZCB0byBiZSByZXNlcnZlZF9hdF8yLg0KPiANCj4gc3RyaWN0X2xhZ190eF9w
b3J0X2FmZmluaXR5WzB4MV0gKyB0bHNfZW5bMHgxXSA9IDB4Mg0KPiANCg0KT2sgbm93IGl0IGlz
IGNsZWFyLCBpIHRydXN0ZWQgdGhlIGRldmVsb3BlciBvbiB0aGlzIG9uZSA6KQ0KYW55d2F5IHlv
dSBoYXZlIHRvIGFkbWl0IHRoYXQgeW91IG1pc2xlYWQgbWUgd2l0aCB5b3VyIGV4YW1wbGVzOg0K
bXg1X2lmY19mbG93X3RhYmxlX3Byb3BfbGF5b3V0X2JpdHMgYW5kIG1seDVfaWZjX3JvY2VfY2Fw
X2JpdHMsIHRoZXkNCmJvdGggYXJlIGZpbmUgc28gaSB0aG91Z2ggdGhpcyB3YXMgZmluZSB0b28u
DQoNCkkgd2lsbCBmaXggaXQgdXAuDQoNClRoYW5rcywNClNhZWVkLg0KDQo+ID4gPiBUaGFua3MN
Cj4gPiA+IA0KPiA+ID4gPiA+IFRoYW5rcw0K
