Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54095393F8
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 20:09:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730336AbfFGSJN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 14:09:13 -0400
Received: from mail-eopbgr00086.outbound.protection.outlook.com ([40.107.0.86]:55430
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729815AbfFGSJM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 7 Jun 2019 14:09:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a9NqbXluQCTYNSCbia5BG9mwlV6oBZ/AZLt9lbMTVZI=;
 b=sMXA+xxm2T0L+jAzaWlZS2dcYYGoG5ZzS4+s94GtTyoZoBUrxZvlajUdrTZ/z2/ZtEqg+75uXELUt/TE4E3VnfpLxjWZ6OOyFJG1A/HLf6JpCcirDhgvWitXHH7WWjt0IGVEBT7uVcjvBPkUzTERnM+x5nNLe/bez/BBlDJ110U=
Received: from DB8PR05MB5898.eurprd05.prod.outlook.com (20.179.9.32) by
 DB8PR05MB6060.eurprd05.prod.outlook.com (20.179.10.79) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1965.14; Fri, 7 Jun 2019 18:09:07 +0000
Received: from DB8PR05MB5898.eurprd05.prod.outlook.com
 ([fe80::4008:6417:32d4:6031]) by DB8PR05MB5898.eurprd05.prod.outlook.com
 ([fe80::4008:6417:32d4:6031%5]) with mapi id 15.20.1965.011; Fri, 7 Jun 2019
 18:09:07 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "leon@kernel.org" <leon@kernel.org>
Subject: Re: [PATCH net-next v2 3/3] net/mlx5e: use indirect calls wrapper for
 the rx packet handler
Thread-Topic: [PATCH net-next v2 3/3] net/mlx5e: use indirect calls wrapper
 for the rx packet handler
Thread-Index: AQHVHLLUj1lczUcwlEuE/49mSxqZEaaQfsmA
Date:   Fri, 7 Jun 2019 18:09:06 +0000
Message-ID: <248c85579656054de478ea29154aa40c7542009e.camel@mellanox.com>
References: <cover.1559857734.git.pabeni@redhat.com>
         <fe1dffe13521e0b89969301f7b34fdb19964dbdb.1559857734.git.pabeni@redhat.com>
In-Reply-To: <fe1dffe13521e0b89969301f7b34fdb19964dbdb.1559857734.git.pabeni@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.2 (3.32.2-1.fc30) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3fd31cbc-269d-400a-47d2-08d6eb733b93
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB8PR05MB6060;
x-ms-traffictypediagnostic: DB8PR05MB6060:
x-microsoft-antispam-prvs: <DB8PR05MB6060CF0BB9C855911CA40464BE100@DB8PR05MB6060.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0061C35778
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(136003)(366004)(39860400002)(376002)(346002)(199004)(189003)(99286004)(25786009)(6512007)(2616005)(256004)(6116002)(3846002)(11346002)(476003)(81156014)(81166006)(14454004)(6486002)(2906002)(76176011)(229853002)(6246003)(8936002)(305945005)(4326008)(446003)(66556008)(2501003)(6436002)(53936002)(316002)(58126008)(66476007)(91956017)(86362001)(68736007)(66446008)(64756008)(76116006)(7736002)(54906003)(110136005)(66946007)(73956011)(71190400001)(71200400001)(36756003)(14444005)(478600001)(66066001)(5660300002)(118296001)(8676002)(186003)(26005)(102836004)(6506007)(486006);DIR:OUT;SFP:1101;SCL:1;SRVR:DB8PR05MB6060;H:DB8PR05MB5898.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: S3zmvvJiQYdI5+ZOu8Pmbirl2X59l4iFJLuO5ybpfXUpOPwrkkwXCitD6YQ3x6MPxOx+K+5S+WkBdUg1A8qqqt7FxgCT+RkuFy96vQ/PY09A4wkOuIZDQLwo+LpKhtpzPBV09uB2Sh4injxhUyZvkvHB1P3NwHUv37Wr24HYvz3ljYJ358imV5bs0fqcqyWZPPZGOGMpO902CIdKl3nsLFpotkWLm4Oy/CFAXRDipMeyuHtgr52ETesW4XY7ZoCs4SyCTsQunOSohx7L+T0LfzE2WFNKzPe8s+XmtGLr97OjdUlIHPPXGhete1pf5ThKExdfk49xCye9VNndEeUg3r+sb1ue7rjCZmSVt0Vhp/s1RdNJQA1uyqgPK1NnTXHCv13df2bZ/EJRCZOmf7Qbxc5+b6StN/7XsXbDeAQDTQs=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A529F4093E855C45A7FE7754A56C2058@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3fd31cbc-269d-400a-47d2-08d6eb733b93
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jun 2019 18:09:06.9969
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR05MB6060
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCAyMDE5LTA2LTA2IGF0IDIzOjU2ICswMjAwLCBQYW9sbyBBYmVuaSB3cm90ZToNCj4g
V2UgY2FuIGF2b2lkIGFub3RoZXIgaW5kaXJlY3QgY2FsbCBwZXIgcGFja2V0IHdyYXBwaW5nIHRo
ZSByeA0KPiBoYW5kbGVyIGNhbGwgd2l0aCB0aGUgcHJvcGVyIGhlbHBlci4NCj4gDQo+IFRvIGVu
c3VyZSB0aGF0IGV2ZW4gdGhlIGxhc3QgbGlzdGVkIGRpcmVjdCBjYWxsIGV4cGVyaWVuY2UNCj4g
bWVhc3VyYWJsZSBnYWluLCBkZXNwaXRlIHRoZSBhZGRpdGlvbmFsIGNvbmRpdGlvbmFscyB3ZSBt
dXN0DQo+IHRyYXZlcnNlIGJlZm9yZSByZWFjaGluZyBpdCwgSSB0ZXN0ZWQgcmV2ZXJzaW5nIHRo
ZSBvcmRlciBvZiB0aGUNCj4gbGlzdGVkIG9wdGlvbnMsIHdpdGggcGVyZm9ybWFuY2UgZGlmZmVy
ZW5jZXMgYmVsb3cgbm9pc2UgbGV2ZWwuDQo+IA0KPiBUb2dldGhlciB3aXRoIHRoZSBwcmV2aW91
cyBpbmRpcmVjdCBjYWxsIHBhdGNoLCB0aGlzIGdpdmVzDQo+IH42JSBwZXJmb3JtYW5jZSBpbXBy
b3ZlbWVudCBpbiByYXcgVURQIHRwdXQuDQo+IA0KPiB2MSAtPiB2MjoNCj4gIC0gdXBkYXRlIHRo
ZSBkaXJlY3QgY2FsbCBsaXN0IGFuZCB1c2UgYSBtYWNybyB0byBkZWZpbmUgaXQsDQo+ICAgIGFz
IHBlciBTYWVlZCBzdWdnZXN0aW9uLiBBbiBpbnRlcm1lZGlhdGVkIGFkZGl0aW9uYWwNCj4gICAg
bWFjcm8gaXMgbmVlZGVkIHRvIGFsbG93IGFyZyBsaXN0IGV4cGFuc2lvbg0KPiANCj4gU2lnbmVk
LW9mZi1ieTogUGFvbG8gQWJlbmkgPHBhYmVuaUByZWRoYXQuY29tPg0KPiAtLS0NCj4gIGRyaXZl
cnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lbi5oICAgIHwgNCArKysrDQo+ICBk
cml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW5fcnguYyB8IDUgKysrKy0N
Cj4gIDIgZmlsZXMgY2hhbmdlZCwgOCBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0pDQo+IA0K
PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2Vu
LmgNCj4gYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW4uaA0KPiBp
bmRleCAzYTE4M2Q2OTBlMjMuLjUyYmNkYzg3Y2JlMiAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9u
ZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VuLmgNCj4gKysrIGIvZHJpdmVycy9uZXQv
ZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VuLmgNCj4gQEAgLTE0OCw2ICsxNDgsMTAgQEAg
c3RydWN0IHBhZ2VfcG9vbDsNCj4gIA0KPiAgI2RlZmluZSBNTFg1RV9NU0dfTEVWRUwJCQlORVRJ
Rl9NU0dfTElOSw0KPiAgDQo+ICsjZGVmaW5lIE1MWDVfUlhfSU5ESVJFQ1RfQ0FMTF9MSVNUIFwN
Cj4gKwltbHg1ZV9oYW5kbGVfcnhfY3FlX21wd3JxLCBtbHg1ZV9oYW5kbGVfcnhfY3FlLA0KPiBt
bHg1aV9oYW5kbGVfcnhfY3FlLCBcDQo+ICsJbWx4NWVfaXBzZWNfaGFuZGxlX3J4X2NxZQ0KPiAr
DQo+ICAjZGVmaW5lIG1seDVlX2RiZyhtbGV2ZWwsIHByaXYsIGZvcm1hdCwgLi4uKSAgICAgICAg
ICAgICAgICAgICAgXA0KPiAgZG8geyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgIFwNCj4gIAlpZiAoTkVUSUZfTVNHXyMjbWxldmVsICYg
KHByaXYpLT5tc2dsZXZlbCkgICAgICAgICAgICAgIFwNCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMv
bmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lbl9yeC5jDQo+IGIvZHJpdmVycy9uZXQv
ZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VuX3J4LmMNCj4gaW5kZXggMGZlNWYxM2QwN2Nj
Li43ZmFmNjQzZWIxYjkgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxh
bm94L21seDUvY29yZS9lbl9yeC5jDQo+ICsrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxh
bm94L21seDUvY29yZS9lbl9yeC5jDQo+IEBAIC0xMzAzLDYgKzEzMDMsOCBAQCB2b2lkIG1seDVl
X2hhbmRsZV9yeF9jcWVfbXB3cnEoc3RydWN0IG1seDVlX3JxDQo+ICpycSwgc3RydWN0IG1seDVf
Y3FlNjQgKmNxZSkNCj4gIAltbHg1X3dxX2xsX3BvcCh3cSwgY3FlLT53cWVfaWQsICZ3cWUtPm5l
eHQubmV4dF93cWVfaW5kZXgpOw0KPiAgfQ0KPiAgDQo+ICsjZGVmaW5lIElORElSRUNUX0NBTExf
TElTVChmLCBsaXN0LCAuLi4pIElORElSRUNUX0NBTExfNChmLCBsaXN0LA0KPiBfX1ZBX0FSR1Nf
XykNCj4gKw0KDQpIaSBQYW9sbywgDQoNClRoaXMgcGF0Y2ggcHJvZHVjZXMgc29tZSBjb21waWxl
ciBlcnJvcnM6DQoNClBsZWFzZSBub3RlIHRoYXQgbWx4NWVfaXBzZWNfaGFuZGxlX3J4X2NxZSBp
cyBvbmx5IGRlZmluZWQgd2hlbg0KQ09ORklHX01MWDVfRU5fSVBTRUMgaXMgZW5hYmxlZC4NCg0K
MDI6MjY6NTMgZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VuX3J4LmM6
IEluIGZ1bmN0aW9uDQonbWx4NWVfcG9sbF9yeF9jcSc6DQowMjoyNjo1MyBkcml2ZXJzL25ldC9l
dGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW5fcnguYzoxMzAwOjQyOg0KZXJyb3I6IGltcGxp
Y2l0IGRlY2xhcmF0aW9uIG9mIGZ1bmN0aW9uICdJTkRJUkVDVF9DQUxMXzQnOyBkaWQgeW91IG1l
YW4NCidJTkRJUkVDVF9DQUxMX0xJU1QnPyBbLVdlcnJvcj1pbXBsaWNpdC1mdW5jdGlvbi1kZWNs
YXJhdGlvbl0NCjAyOjI2OjUzICAjZGVmaW5lIElORElSRUNUX0NBTExfTElTVChmLCBsaXN0LCAu
Li4pIElORElSRUNUX0NBTExfNChmLA0KbGlzdCwgX19WQV9BUkdTX18pDQowMjoyNjo1MyAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBeDQowMjoyNjo1MyBkcml2ZXJz
L25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW5fcnguYzoxMzMyOjM6IG5vdGU6DQpp
biBleHBhbnNpb24gb2YgbWFjcm8gJ0lORElSRUNUX0NBTExfTElTVCcNCjAyOjI2OjUzICAgIElO
RElSRUNUX0NBTExfTElTVChycS0+aGFuZGxlX3J4X2NxZSwNCjAyOjI2OjUzICAgIF5+fn5+fn5+
fn5+fn5+fn5+fg0KMDI6MjY6NTMgZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9j
b3JlL2VuLmg6MTUzOjI6IGVycm9yOg0KJ21seDVlX2lwc2VjX2hhbmRsZV9yeF9jcWUnIHVuZGVj
bGFyZWQgKGZpcnN0IHVzZSBpbiB0aGlzIGZ1bmN0aW9uKTsNCmRpZCB5b3UgbWVhbiAnbWx4NWVf
ZnBfaGFuZGxlX3J4X2NxZSc/DQowMjoyNjo1MyAgIG1seDVlX2lwc2VjX2hhbmRsZV9yeF9jcWUN
CjAyOjI2OjUzICAgXg0KMDI6MjY6NTMgZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4
NS9jb3JlL2VuX3J4LmM6MTMwMDo2MTogbm90ZToNCmluIGRlZmluaXRpb24gb2YgbWFjcm8gJ0lO
RElSRUNUX0NBTExfTElTVCcNCjAyOjI2OjUzICAjZGVmaW5lIElORElSRUNUX0NBTExfTElTVChm
LCBsaXN0LCAuLi4pIElORElSRUNUX0NBTExfNChmLA0KbGlzdCwgX19WQV9BUkdTX18pDQowMjoy
Njo1MyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgXg0Kfn5+DQowMjoyNjo1MyBkcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9t
bHg1L2NvcmUvZW5fcnguYzoxMzMzOjg6IG5vdGU6DQppbiBleHBhbnNpb24gb2YgbWFjcm8gJ01M
WDVfUlhfSU5ESVJFQ1RfQ0FMTF9MSVNUJw0KMDI6MjY6NTMgICAgICAgICBNTFg1X1JYX0lORElS
RUNUX0NBTExfTElTVCwgcnEsIGNxZSk7DQowMjoyNjo1MyAgICAgICAgIF5+fn5+fn5+fn5+fn5+
fn5+fn5+fn5+fn5+DQowMjoyNjo1MyBkcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1
L2NvcmUvZW4uaDoxNTM6Mjogbm90ZTogZWFjaA0KdW5kZWNsYXJlZCBpZGVudGlmaWVyIGlzIHJl
cG9ydGVkIG9ubHkgb25jZSBmb3IgZWFjaCBmdW5jdGlvbiBpdA0KYXBwZWFycyBpbg0KMDI6MjY6
NTMgICBtbHg1ZV9pcHNlY19oYW5kbGVfcnhfY3FlDQowMjoyNjo1MyAgIF4NCjAyOjI2OjUzIGRy
aXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lbl9yeC5jOjEzMDA6NjE6IG5v
dGU6DQppbiBkZWZpbml0aW9uIG9mIG1hY3JvICdJTkRJUkVDVF9DQUxMX0xJU1QnDQowMjoyNjo1
MyAgI2RlZmluZSBJTkRJUkVDVF9DQUxMX0xJU1QoZiwgbGlzdCwgLi4uKSBJTkRJUkVDVF9DQUxM
XzQoZiwNCmxpc3QsIF9fVkFfQVJHU19fKQ0KMDI6MjY6NTMgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIF4NCn5+fg0KMDI6MjY6NTMg
ZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VuX3J4LmM6MTMzMzo4OiBu
b3RlOg0KaW4gZXhwYW5zaW9uIG9mIG1hY3JvICdNTFg1X1JYX0lORElSRUNUX0NBTExfTElTVCcN
CjAyOjI2OjUzICAgICAgICAgTUxYNV9SWF9JTkRJUkVDVF9DQUxMX0xJU1QsIHJxLCBjcWUpOw0K
MDI6MjY6NTMgICAgICAgICBefn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fg0KDQoNCj4gIGludCBt
bHg1ZV9wb2xsX3J4X2NxKHN0cnVjdCBtbHg1ZV9jcSAqY3EsIGludCBidWRnZXQpDQo+ICB7DQo+
ICAJc3RydWN0IG1seDVlX3JxICpycSA9IGNvbnRhaW5lcl9vZihjcSwgc3RydWN0IG1seDVlX3Jx
LCBjcSk7DQo+IEBAIC0xMzMzLDcgKzEzMzUsOCBAQCBpbnQgbWx4NWVfcG9sbF9yeF9jcShzdHJ1
Y3QgbWx4NWVfY3EgKmNxLCBpbnQNCj4gYnVkZ2V0KQ0KPiAgDQo+ICAJCW1seDVfY3F3cV9wb3Ao
Y3F3cSk7DQo+ICANCj4gLQkJcnEtPmhhbmRsZV9yeF9jcWUocnEsIGNxZSk7DQo+ICsJCUlORElS
RUNUX0NBTExfTElTVChycS0+aGFuZGxlX3J4X2NxZSwNCj4gKwkJCQkgICBNTFg1X1JYX0lORElS
RUNUX0NBTExfTElTVCwgcnEsDQo+IGNxZSk7DQo+ICAJfSB3aGlsZSAoKCsrd29ya19kb25lIDwg
YnVkZ2V0KSAmJiAoY3FlID0NCj4gbWx4NV9jcXdxX2dldF9jcWUoY3F3cSkpKTsNCj4gIA0KPiAg
b3V0Og0K
