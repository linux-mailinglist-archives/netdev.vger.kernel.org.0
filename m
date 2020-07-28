Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0BD32305D3
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 10:53:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728346AbgG1IxI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 04:53:08 -0400
Received: from mail-db8eur05on2063.outbound.protection.outlook.com ([40.107.20.63]:12897
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728198AbgG1IxH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 04:53:07 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JZi9WhAULGcy7aiH2MlipvE3hU2wziy7PowMANghxYXFhkesmg/WXzs25IFbzGnAxCXB+vQwN1i8rMfXxkZXEn1b3Yamum5mahnuJ6WAIZbDWWA835P4AnmR2KHGuVUX0tDs+FsSrGZ5qIW58CYl4s/C1Rs5Ay78CeMBFsYSuYaPTd73rOW5CL/E/K0igkjx3CedChObp4DufnqpdiOscay4aVp54Mi3MCZekQ3QcP62EIWpJql/R6SITNK7fBMYRSjNu0S9YXvvDP34no4LmInpupTcXKgbZKjt1207ypxchirWvWwhRkFAtfxbxrObWFxiXpb5zNJXdNaQcrxB9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SGFWRWJui9ueRyxsL+OFKEwpI8M9vXrKZjZ8lNs9YnM=;
 b=DWXj/nnGieBy13LmGJZEK4lUbQ7IW5Dp0IqdKGtVMCc2h75/PG/IKh3BqcmukRNlKBS9Qbw6m8g5tzlf1dM68wUztaIKPJzRiczdCwEzZqnzF+M0Tb/8zZpltJCdadrC3FzMGg1Zo0R3cwessA9CHOngQ3aun8qDhgIVFglcPnXwhzNLLgfOZ0qG87+JcKl/hC5NCEYNNPDgBeQ5ux7fYL36lJGkooSGuLpwq5nvTKvESqEL8DMW2mYGyzkOq58E2ZI/0rikEc6eZsNKgk2nn3ETPhz+KdicSdGfp0b9YbUsBsXUhvg91chG7qubWn7BqAgsYeQTvA8mk0ULD0w/+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SGFWRWJui9ueRyxsL+OFKEwpI8M9vXrKZjZ8lNs9YnM=;
 b=g0gD8zUX2LmgN+ndesDLUsRYhO9/sT4Ll4vI2BMeageCpeZXDuclItlY3zLcSFwZjF15Q1VPIdTzU7sXEPR2a3PqujVGxxQt/f3rAejLA4lrf2OWWKDHXQss59Z0VdCZv1/q3YJmOm2N2HRmnu1T+sBjNc3tp8RnI6Whe023hdE=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB7120.eurprd05.prod.outlook.com (2603:10a6:800:185::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.20; Tue, 28 Jul
 2020 08:53:03 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::508a:d074:ad3a:3529]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::508a:d074:ad3a:3529%5]) with mapi id 15.20.3216.034; Tue, 28 Jul 2020
 08:53:03 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "kernel-team@fb.com" <kernel-team@fb.com>,
        "lawja@fb.com" <lawja@fb.com>, Yishai Hadas <yishaih@mellanox.com>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@mellanox.com>
Subject: Re: [PATCH net] mlx4: disable device on shutdown
Thread-Topic: [PATCH net] mlx4: disable device on shutdown
Thread-Index: AQHWYhBpLsAcUo58ikiMss6iYuWh9akctNEA
Date:   Tue, 28 Jul 2020 08:53:03 +0000
Message-ID: <d764c7795d05a8d502d9b936eac014ccd95690d0.camel@mellanox.com>
References: <20200724231543.3295117-1-kuba@kernel.org>
In-Reply-To: <20200724231543.3295117-1-kuba@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.3 (3.36.3-1.fc32) 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=mellanox.com;
x-originating-ip: [73.15.39.150]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 64eb8207-3013-45de-edb7-08d832d3a39d
x-ms-traffictypediagnostic: VI1PR05MB7120:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB7120A1F09F7360F8CB442EEFBE730@VI1PR05MB7120.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:376;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: r6H7wZtlJZ6a5+GJiuSBnYPt6T7m7XAeVXRYz3/fE8ITJTTfuGGoXhqQ7MpJneHB5C38JFvTE5USA6rqFQKoZiAIEDDjgKR/10dvhz3b7pYJMx7l3ayFzalz4T0wAlob8AdLwpDytYSGXvyDsv1xly9kj4MlKo45l1GWYEfEK4sC28RY0EeJ3PEy02IZwfAQXh2Nhtrevf4VhLrW2srkMibk1xr3kCf28na8CN70vEgOvcfg+Xj4aY7KZd3RrtkWmxnlJaQT4cffpbTDF9rcF2JP0uCgI+y5iX3aGCNLW/yERgfKIJVlZp8/GzXXv9Ig/dpsdtce1NdVG0m0SEWc9VO5ybeNx+JkFhH4UpJkJyLyb7rKUjlOs6B8z9E0ROoaJuY8qiVbd1e9BYKNQci2Ig==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(366004)(376002)(136003)(39860400002)(346002)(186003)(6486002)(8676002)(83380400001)(6506007)(54906003)(110136005)(478600001)(86362001)(966005)(36756003)(107886003)(316002)(26005)(71200400001)(64756008)(66476007)(8936002)(91956017)(4326008)(76116006)(66946007)(66556008)(66446008)(2616005)(2906002)(5660300002)(6512007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: ORIShmZJwsL+ic5OCaDBvBgN0nV0NoH1oULFA0L1Bv61cmMSheYQ0JjlD0Zx+W7FOI7ZRRGVXU07frXB2LbTyb1/EGrlCRbC1CWQRc6emcwkvfjYbk1c6uxRc8yIYpmHV2NbWn3kZH5pO76yEWa7DCLFfJDDKGdDBJRDEBHIab9z+JNnQW1+bxXMJr+9zadGKri/i/9eXRFu6GyEBRZ1mIkxYYe6H4XOxHXAIOG/cR1HO+DLrcnm8UI15GUX3ttqux9fqQ8R+dtPQXcSCEbXtoO1FGF4Kf0LC/ZGDrCPwEWKJn4AYaTqWYODi1WtaXfxgSiVuUwA2c3Ka2RbvonlYkOr5Nw8s0/fViG4b/U5jvAWhkcq8/31kcAT0B0AlF3vrh5kMADH/pm1atEy34rHGjdVRfUxgeCibRsv9CQ7Xg+wlk+m35v0Bz4xTWzYbM8bu2wkhRQOK1I5okAcE9lQjgwhPEpdMAG75tJfGe9hDsM=
Content-Type: text/plain; charset="utf-8"
Content-ID: <40CAA4B3E04AA349816EA01C43E5C0C3@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB5102.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 64eb8207-3013-45de-edb7-08d832d3a39d
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jul 2020 08:53:03.4789
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8zmvqxLVlDGCTBmBbziDlAhDIhnr71ejCSkN0CuLiIWwGCz/UJwD3P3LM0f4gh8bxklkcQbZTVVpeU0MlAvgaQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB7120
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAyMDIwLTA3LTI0IGF0IDE2OjE1IC0wNzAwLCBKYWt1YiBLaWNpbnNraSB3cm90ZToN
Cj4gSXQgYXBwZWFycyB0aGF0IG5vdCBkaXNhYmxpbmcgYSBQQ0kgZGV2aWNlIG9uIC5zaHV0ZG93
biBtYXkgbGVhZCB0bw0KPiBhIEhhcmR3YXJlIEVycm9yIHdpdGggcGFydGljdWxhciAocGVyaGFw
cyBidWdneSkgQklPUyB2ZXJzaW9uczoNCj4gDQo+ICAgICBtbHg0X2VuOiBldGgwOiBDbG9zZSBw
b3J0IGNhbGxlZA0KPiAgICAgbWx4NF9lbiAwMDAwOjA0OjAwLjA6IHJlbW92ZWQgUEhDDQo+ICAg
ICByZWJvb3Q6IFJlc3RhcnRpbmcgc3lzdGVtDQo+ICAgICB7MX1bSGFyZHdhcmUgRXJyb3JdOiBI
YXJkd2FyZSBlcnJvciBmcm9tIEFQRUkgR2VuZXJpYyBIYXJkd2FyZQ0KPiBFcnJvciBTb3VyY2U6
IDENCj4gICAgIHsxfVtIYXJkd2FyZSBFcnJvcl06IGV2ZW50IHNldmVyaXR5OiBmYXRhbA0KPiAg
ICAgezF9W0hhcmR3YXJlIEVycm9yXTogIEVycm9yIDAsIHR5cGU6IGZhdGFsDQo+ICAgICB7MX1b
SGFyZHdhcmUgRXJyb3JdOiAgIHNlY3Rpb25fdHlwZTogUENJZSBlcnJvcg0KPiAgICAgezF9W0hh
cmR3YXJlIEVycm9yXTogICBwb3J0X3R5cGU6IDQsIHJvb3QgcG9ydA0KPiAgICAgezF9W0hhcmR3
YXJlIEVycm9yXTogICB2ZXJzaW9uOiAxLjE2DQo+ICAgICB7MX1bSGFyZHdhcmUgRXJyb3JdOiAg
IGNvbW1hbmQ6IDB4NDAxMCwgc3RhdHVzOiAweDAxNDMNCj4gICAgIHsxfVtIYXJkd2FyZSBFcnJv
cl06ICAgZGV2aWNlX2lkOiAwMDAwOjAwOjAyLjINCj4gICAgIHsxfVtIYXJkd2FyZSBFcnJvcl06
ICAgc2xvdDogMA0KPiAgICAgezF9W0hhcmR3YXJlIEVycm9yXTogICBzZWNvbmRhcnlfYnVzOiAw
eDA0DQo+ICAgICB7MX1bSGFyZHdhcmUgRXJyb3JdOiAgIHZlbmRvcl9pZDogMHg4MDg2LCBkZXZp
Y2VfaWQ6IDB4MmYwNg0KPiAgICAgezF9W0hhcmR3YXJlIEVycm9yXTogICBjbGFzc19jb2RlOiAw
MDA2MDQNCj4gICAgIHsxfVtIYXJkd2FyZSBFcnJvcl06ICAgYnJpZGdlOiBzZWNvbmRhcnlfc3Rh
dHVzOiAweDIwMDAsIGNvbnRyb2w6DQo+IDB4MDAwMw0KPiAgICAgezF9W0hhcmR3YXJlIEVycm9y
XTogICBhZXJfdW5jb3Jfc3RhdHVzOiAweDAwMTAwMDAwLA0KPiBhZXJfdW5jb3JfbWFzazogMHgw
MDAwMDAwMA0KPiAgICAgezF9W0hhcmR3YXJlIEVycm9yXTogICBhZXJfdW5jb3Jfc2V2ZXJpdHk6
IDB4MDAwNjIwMzANCj4gICAgIHsxfVtIYXJkd2FyZSBFcnJvcl06ICAgVExQIEhlYWRlcjogNDAw
MDAwMTggMDQwMDAwZmYgNzkxZjQwODANCj4gMDAwMDAwMDANCj4gW2h3IGVycm9yIHJlcGVhdHNd
DQo+ICAgICBLZXJuZWwgcGFuaWMgLSBub3Qgc3luY2luZzogRmF0YWwgaGFyZHdhcmUgZXJyb3Ih
DQo+ICAgICBDUFU6IDAgUElEOiAyMTg5IENvbW06IHJlYm9vdCBLZHVtcDogbG9hZGVkIE5vdCB0
YWludGVkIDUuNi54LQ0KPiBibGFibGEgIzENCj4gICAgIEhhcmR3YXJlIG5hbWU6IEhQIFByb0xp
YW50IERMMzgwIEdlbjkvUHJvTGlhbnQgREwzODAgR2VuOSwgQklPUw0KPiBQODkgMDUvMDUvMjAx
Nw0KPiANCj4gRml4IHRoZSBtbHg0IGRyaXZlci4NCj4gDQo+IFRoaXMgaXMgYSB2ZXJ5IHNpbWls
YXIgcHJvYmxlbSB0byB3aGF0IGhhZCBiZWVuIGZpeGVkIGluOg0KPiBjb21taXQgMGQ5OGJhOGQ3
MGIwICgic2NzaTogaHBzYTogZGlzYWJsZSBkZXZpY2UgZHVyaW5nIHNodXRkb3duIikNCj4gdG8g
YWRkcmVzcyBodHRwczovL2J1Z3ppbGxhLmtlcm5lbC5vcmcvc2hvd19idWcuY2dpP2lkPTE5OTc3
OS4NCj4gDQo+IEZpeGVzOiAyYmE1ZmJkNjJiMjUgKCJuZXQvbWx4NF9jb3JlOiBIYW5kbGUgQUVS
IGZsb3cgcHJvcGVybHkiKQ0KPiBSZXBvcnRlZC1ieTogSmFrZSBMYXdyZW5jZSA8bGF3amFAZmIu
Y29tPg0KPiBTaWduZWQtb2ZmLWJ5OiBKYWt1YiBLaWNpbnNraSA8a3ViYUBrZXJuZWwub3JnPg0K
DQpSZXZpZXdlZC1ieTogU2FlZWQgTWFoYW1lZWQgPHNhZWVkbUBtZWxsYW5veC5jb20+DQoNCj4g
LS0tDQo+ICBkcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg0L21haW4uYyB8IDIgKysN
Cj4gIDEgZmlsZSBjaGFuZ2VkLCAyIGluc2VydGlvbnMoKykNCj4gDQo+IGRpZmYgLS1naXQgYS9k
cml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg0L21haW4uYw0KPiBiL2RyaXZlcnMvbmV0
L2V0aGVybmV0L21lbGxhbm94L21seDQvbWFpbi5jDQo+IGluZGV4IDNkOWFhN2RhOTVlOS4uMmQz
ZTQ1NzgwNzE5IDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9t
bHg0L21haW4uYw0KPiArKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg0L21h
aW4uYw0KPiBAQCAtNDM1NiwxMiArNDM1NiwxNCBAQCBzdGF0aWMgdm9pZCBtbHg0X3BjaV9yZXN1
bWUoc3RydWN0IHBjaV9kZXYNCj4gKnBkZXYpDQo+ICBzdGF0aWMgdm9pZCBtbHg0X3NodXRkb3du
KHN0cnVjdCBwY2lfZGV2ICpwZGV2KQ0KPiAgew0KPiAgCXN0cnVjdCBtbHg0X2Rldl9wZXJzaXN0
ZW50ICpwZXJzaXN0ID0gcGNpX2dldF9kcnZkYXRhKHBkZXYpOw0KPiArCXN0cnVjdCBtbHg0X2Rl
diAqZGV2ID0gcGVyc2lzdC0+ZGV2Ow0KPiAgDQo+ICAJbWx4NF9pbmZvKHBlcnNpc3QtPmRldiwg
Im1seDRfc2h1dGRvd24gd2FzIGNhbGxlZFxuIik7DQo+ICAJbXV0ZXhfbG9jaygmcGVyc2lzdC0+
aW50ZXJmYWNlX3N0YXRlX211dGV4KTsNCj4gIAlpZiAocGVyc2lzdC0+aW50ZXJmYWNlX3N0YXRl
ICYgTUxYNF9JTlRFUkZBQ0VfU1RBVEVfVVApDQo+ICAJCW1seDRfdW5sb2FkX29uZShwZGV2KTsN
Cj4gIAltdXRleF91bmxvY2soJnBlcnNpc3QtPmludGVyZmFjZV9zdGF0ZV9tdXRleCk7DQo+ICsJ
bWx4NF9wY2lfZGlzYWJsZV9kZXZpY2UoZGV2KTsNCj4gIH0NCj4gIA0KPiAgc3RhdGljIGNvbnN0
IHN0cnVjdCBwY2lfZXJyb3JfaGFuZGxlcnMgbWx4NF9lcnJfaGFuZGxlciA9IHsNCg==
