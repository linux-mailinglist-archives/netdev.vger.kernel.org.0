Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34F0A316EE
	for <lists+netdev@lfdr.de>; Sat,  1 Jun 2019 00:08:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726711AbfEaWII (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 18:08:08 -0400
Received: from mail-eopbgr20048.outbound.protection.outlook.com ([40.107.2.48]:18629
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725913AbfEaWII (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 May 2019 18:08:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h5V+TA2g1B8eh+38pPceqToeMVIeshpl4Jz6CyfAw/w=;
 b=m3xUf+F8JB+8Sq1j9UX1ufTZMN0N4wlwcgJp2BiCVhpm8aGIAl+uncLU7W6ITAL07P0HD6f9ekbDRIVV6QjydLhRD7Un5RK4XxwaubhNzcnRNbLnfr5TV1L7/MZvoJByIDghPv5NcvTmywePZ2F3AtWHes1fGrYfUmCiesllyIs=
Received: from DB8PR05MB5898.eurprd05.prod.outlook.com (20.179.9.32) by
 DB8PR05MB6091.eurprd05.prod.outlook.com (20.179.9.15) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.19; Fri, 31 May 2019 22:08:03 +0000
Received: from DB8PR05MB5898.eurprd05.prod.outlook.com
 ([fe80::4008:6417:32d4:6031]) by DB8PR05MB5898.eurprd05.prod.outlook.com
 ([fe80::4008:6417:32d4:6031%5]) with mapi id 15.20.1943.018; Fri, 31 May 2019
 22:08:03 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "ivan.khoronzhuk@linaro.org" <ivan.khoronzhuk@linaro.org>,
        "brouer@redhat.com" <brouer@redhat.com>
CC:     "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "xdp-newbies@vger.kernel.org" <xdp-newbies@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "ilias.apalodimas@linaro.org" <ilias.apalodimas@linaro.org>,
        "grygorii.strashko@ti.com" <grygorii.strashko@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "hawk@kernel.org" <hawk@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>
Subject: Re: [PATCH v2 net-next 7/7] net: ethernet: ti: cpsw: add XDP support
Thread-Topic: [PATCH v2 net-next 7/7] net: ethernet: ti: cpsw: add XDP support
Thread-Index: AQHVFxR3RzUKWjjKSU24ene/DovDe6aFYe2AgAAKzwCAAAIJgIAACKCAgABVEYA=
Date:   Fri, 31 May 2019 22:08:03 +0000
Message-ID: <a65de3a257ab5ebec83e817c092f074b58b9ae47.camel@mellanox.com>
References: <20190530182039.4945-1-ivan.khoronzhuk@linaro.org>
         <20190530182039.4945-8-ivan.khoronzhuk@linaro.org>
         <20190531174643.4be8b27f@carbon> <20190531162523.GA3694@khorivan>
         <20190531183241.255293bc@carbon> <20190531170332.GB3694@khorivan>
In-Reply-To: <20190531170332.GB3694@khorivan>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.2 (3.32.2-1.fc30) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2ab187e3-8158-4e18-8462-08d6e61473e5
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB8PR05MB6091;
x-ms-traffictypediagnostic: DB8PR05MB6091:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <DB8PR05MB6091A12C78605D692EC48407BE190@DB8PR05MB6091.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 00540983E2
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(39860400002)(136003)(346002)(396003)(376002)(189003)(199004)(7736002)(14444005)(305945005)(6486002)(81156014)(7416002)(256004)(118296001)(26005)(66066001)(99286004)(6246003)(6512007)(14454004)(2501003)(8936002)(36756003)(6306002)(6436002)(8676002)(229853002)(66556008)(4326008)(66446008)(66476007)(446003)(478600001)(71190400001)(76116006)(486006)(11346002)(2616005)(71200400001)(25786009)(316002)(66946007)(68736007)(966005)(476003)(5660300002)(64756008)(6116002)(58126008)(110136005)(53936002)(3846002)(186003)(2906002)(73956011)(6506007)(86362001)(91956017)(76176011)(102836004)(54906003)(45080400002)(81166006);DIR:OUT;SFP:1101;SCL:1;SRVR:DB8PR05MB6091;H:DB8PR05MB5898.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Z94977NzkD48HS/yRVlq/s8b856kHPOheVVux6a13MTZMzq1ueGuWZTqcosg68D/W/ap8KQOsBWekXotTIMYUKAHxCUR4SDBtTM3kRshzNlsYSfO6ANNUjHkL0AInLZjMfpjLfRjOtTcUsDL39901daiCJSxDUEXNlUdtbSNaNqrNCX5qDfsPgqbNcgQFkf347iGFWruVWXQT2nVXqkECfaYe+RYCtbTUJWRPhX1WC+ITOIZ5S8vN7ByMOiJWOfZVpfGN92NwgZbDJLnlRk9R/Q3L8gp9JXr0FIx80ZMmkYXz+TWzrFNo4qO+34U6DdhVd66e7+fSTidpk9oJnIfujrOW9ek5T4DMJny+vEOv6jKfBQWVnH4NGj8Fi3nwlgpr7JmYICEXV6mZk66QFULxqOF0VxHMMj8c6cRoQeN4rk=
Content-Type: text/plain; charset="utf-8"
Content-ID: <53B36BEEBA016349819171CA9F2B689F@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ab187e3-8158-4e18-8462-08d6e61473e5
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 May 2019 22:08:03.7000
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR05MB6091
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAyMDE5LTA1LTMxIGF0IDIwOjAzICswMzAwLCBJdmFuIEtob3JvbnpodWsgd3JvdGU6
DQo+IE9uIEZyaSwgTWF5IDMxLCAyMDE5IGF0IDA2OjMyOjQxUE0gKzAyMDAsIEplc3BlciBEYW5n
YWFyZCBCcm91ZXINCj4gd3JvdGU6DQo+ID4gT24gRnJpLCAzMSBNYXkgMjAxOSAxOToyNToyNCAr
MDMwMCBJdmFuIEtob3JvbnpodWsgPA0KPiA+IGl2YW4ua2hvcm9uemh1a0BsaW5hcm8ub3JnPiB3
cm90ZToNCj4gPiANCj4gPiA+IE9uIEZyaSwgTWF5IDMxLCAyMDE5IGF0IDA1OjQ2OjQzUE0gKzAy
MDAsIEplc3BlciBEYW5nYWFyZCBCcm91ZXINCj4gPiA+IHdyb3RlOg0KPiA+ID4gPiBGcm9tIGJl
bG93IGNvZGUgc25pcHBldHMsIGl0IGxvb2tzIGxpa2UgeW91IG9ubHkgYWxsb2NhdGVkIDENCj4g
PiA+ID4gcGFnZV9wb29sDQo+ID4gPiA+IGFuZCBzaGFyaW5nIGl0IHdpdGggc2V2ZXJhbCBSWC1x
dWV1ZXMsIGFzIEkgZG9uJ3QgaGF2ZSB0aGUgZnVsbA0KPiA+ID4gPiBjb250ZXh0DQo+ID4gPiA+
IGFuZCBkb24ndCBrbm93IHRoaXMgZHJpdmVyLCBJIG1pZ2h0IGJlIHdyb25nPw0KPiA+ID4gPiAN
Cj4gPiA+ID4gVG8gYmUgY2xlYXIsIGEgcGFnZV9wb29sIG9iamVjdCBpcyBuZWVkZWQgcGVyIFJY
LXF1ZXVlLCBhcyBpdA0KPiA+ID4gPiBpcw0KPiA+ID4gPiBhY2Nlc3NpbmcgYSBzbWFsbCBSWCBw
YWdlIGNhY2hlICh3aGljaCBwcm90ZWN0ZWQgYnkNCj4gPiA+ID4gTkFQSS9zb2Z0aXJxKS4NCj4g
PiA+IA0KPiA+ID4gVGhlcmUgaXMgb25lIFJYIGludGVycnVwdCBhbmQgb25lIFJYIE5BUEkgZm9y
IGFsbCByeCBjaGFubmVscy4NCj4gPiANCj4gPiBTbywgd2hhdCBhcmUgeW91IHNheWluZz8NCj4g
PiANCj4gPiBZb3UgX2FyZV8gc2hhcmluZyB0aGUgcGFnZV9wb29sIGJldHdlZW4gc2V2ZXJhbCBS
WC1jaGFubmVscywgYnV0IGl0DQo+ID4gaXMNCj4gPiBzYWZlIGJlY2F1c2UgdGhpcyBoYXJkd2Fy
ZSBvbmx5IGhhdmUgb25lIFJYIGludGVycnVwdCArIE5BUEkNCj4gPiBpbnN0YW5jZT8/DQo+IA0K
PiBJIGNhbiBtaXNzIHNtdGggYnV0IGluIGNhc2Ugb2YgY3BzdyB0ZWNobmljYWxseSBpdCBtZWFu
czoNCj4gMSkgUlggaW50ZXJydXB0cyBhcmUgZGlzYWJsZWQgd2hpbGUgTkFQSSBpcyBzY2hlZHVs
ZWQsDQo+ICAgIG5vdCBmb3IgcGFydGljdWxhciBDUFUgb3IgY2hhbm5lbCwgYnV0IGF0IGFsbCwg
Zm9yIHdob2xlIGNwc3cNCj4gbW9kdWxlLg0KPiAyKSBSWCBjaGFubmVscyBhcmUgaGFuZGxlZCBv
bmUgYnkgb25lIGJ5IHByaW9yaXR5Lg0KDQpIaSBJdmFuLCBJIGdvdCBhIHNpbGx5IHF1ZXN0aW9u
Li4gDQoNCldoYXQgaXMgdGhlIHJlYXNvbiBiZWhpbmQgaGF2aW5nIG11bHRpcGxlIFJYIHJpbmdz
IGFuZCBvbmUgQ1BVL05BUEkNCmhhbmRsaW5nIGFsbCBvZiB0aGVtID8gcHJpb3JpdHkgPyBob3cg
ZG8geW91IHByaW9yaXRpZXMgPw0KDQo+IDMpIEFmdGVyIGFsbCBvZiB0aGVtIGhhbmRsZWQgYW5k
IG5vIG1vcmUgaW4gYnVkZ2V0IC0gaW50ZXJydXB0cyBhcmUNCj4gZW5hYmxlZC4NCj4gNCkgSWYg
cGFnZSBpcyByZXR1cm5lZCB0byB0aGUgcG9vbCwgYW5kIGl0J3Mgd2l0aGluIE5BUEksIG5vIHJh
Y2VzIGFzDQo+IGl0J3MNCj4gICAgcmV0dXJuZWQgcHJvdGVjdGVkIGJ5IHNvZnRpcnEuIElmIGl0
J3MgcmV0dXJuZWQgbm90IGluIHNvZnRpcnENCj4gaXQncyBwcm90ZWN0ZWQgDQo+ICAgIGJ5IHBy
b2R1Y2VyIGxvY2sgb2YgdGhlIHJpbmcuDQo+IA0KPiBQcm9iYWJseSBpdCdzIG5vdCBnb29kIGV4
YW1wbGUgZm9yIG90aGVycyBob3cgaXQgc2hvdWxkIGJlIHVzZWQsIG5vdA0KPiBhIGJpZw0KPiBw
cm9ibGVtIHRvIG1vdmUgaXQgdG8gc2VwYXJhdGUgcG9vbHMuLiwgZXZlbiBkb24ndCByZW1lbWJl
ciB3aHkgSQ0KPiBkZWNpZGVkIHRvDQo+IHVzZSBzaGFyZWQgcG9vbCwgdGhlcmUgd2FzIHNvbWUg
bW9yZSByZWFzb25zLi4uIG5lZWQgc2VhcmNoIGluDQo+IGhpc3RvcnkuDQo+IA0KPiA+IC0tIA0K
PiA+IEJlc3QgcmVnYXJkcywNCj4gPiAgSmVzcGVyIERhbmdhYXJkIEJyb3Vlcg0KPiA+ICBNU2Mu
Q1MsIFByaW5jaXBhbCBLZXJuZWwgRW5naW5lZXIgYXQgUmVkIEhhdA0KPiA+ICBMaW5rZWRJbjog
aHR0cDovL3d3dy5saW5rZWRpbi5jb20vaW4vYnJvdWVyDQo=
