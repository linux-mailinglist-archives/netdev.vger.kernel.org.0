Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E992D230583
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 10:35:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728232AbgG1If6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 04:35:58 -0400
Received: from mail-eopbgr70059.outbound.protection.outlook.com ([40.107.7.59]:1671
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728009AbgG1If5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 04:35:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UBQHUfFkFcCUSNEzuo8B4i1578cYt46vAb8GlT1Aza4WzDmL+h0e6DG+3iH9fB4VX11J2PthcE7dHHtx+sGcVjxVr4oepUnrtz9vn4b+pdcrDHoCSR++TLDDFO62lxrWLRKfZBoC8F81D+Uytbz+7vl7QDNkUtrY3vcUK5SilbRyLC4cXl20FJAYp5+HqQrUsXuADDtyr8NHuyJt8Ux6PotpKHaY5374bzCCEbQZqBdO/r1i1wLep0/dcVbky/KSKbgHfyMlOXIdNS2gNU+3UZeZHh85v7ntk+DXBv23rny1TGXyc7ZwpRvUxITdDVJsI1tw/biUUtri+bMWO0b3Hw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7icvSadheEUo/mvDAft+Fh1DYEZEl3DAmevipLh5R74=;
 b=HsUubZZT99UDYhLfwIMF2RLjYDyU42VFa8b4ZAg9qYJG3J7kA3kGQF25PuYb1dLGv+Vu2eeTpSZfMa9Hulw6WhzN8osqhSPXM2Uv77fcHc/X2GqhrtLHjoLDCguMcb2vht1ILSIs8W3pZjziPhNfM07W4sQRnJyBF7ZJlLvnA70Rkc9IUZNGi67iOMLFRKggq36Ah9gZS1DVgYrVBmxrXkcnqprEupJbawtJDNF8naydYHDYBtt66X5BTpRwoRNo787IjpmlB8R24wmLUZsAMdmWsNveVs2wZI2lk8IdSb+gpivKYptRGfB2FOwy3TU5wQvzxFpzXp7vBKUmFR6p2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7icvSadheEUo/mvDAft+Fh1DYEZEl3DAmevipLh5R74=;
 b=n7rYOdWeo4n015enbxh9x9R90fCgAKGEa2iND+sVX2t6S6Iq77kZD9V2AnkF8JTte76mXqyKZxsOlg5v8XUfKWSEziI3WBWsTLTImJkcd9+vTeqaT1YbHMQCheu/gNAXyn3Eq1ENsWSTJoXNzKPM2u1qtz7HXelO9XBFuNw5iN8=
Received: from AM6PR05MB5094.eurprd05.prod.outlook.com (2603:10a6:20b:9::29)
 by AM6PR05MB4391.eurprd05.prod.outlook.com (2603:10a6:209:42::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.24; Tue, 28 Jul
 2020 08:35:53 +0000
Received: from AM6PR05MB5094.eurprd05.prod.outlook.com
 ([fe80::d803:a59d:9a85:975f]) by AM6PR05MB5094.eurprd05.prod.outlook.com
 ([fe80::d803:a59d:9a85:975f%7]) with mapi id 15.20.3216.033; Tue, 28 Jul 2020
 08:35:53 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "kuba@kernel.org" <kuba@kernel.org>
CC:     "mkubecek@suse.cz" <mkubecek@suse.cz>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [PATCH net-next 2/2] mlx5: convert to new udp_tunnel
 infrastructure
Thread-Topic: [PATCH net-next 2/2] mlx5: convert to new udp_tunnel
 infrastructure
Thread-Index: AQHWYi6lN9YwiFhLKECIA8e3FalFIqkcr9WA
Date:   Tue, 28 Jul 2020 08:35:53 +0000
Message-ID: <b9e4f45f6478b4447d5fa34bc7e02716d0f77d89.camel@mellanox.com>
References: <20200725025146.3770263-1-kuba@kernel.org>
         <20200725025146.3770263-3-kuba@kernel.org>
In-Reply-To: <20200725025146.3770263-3-kuba@kernel.org>
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
x-ms-office365-filtering-correlation-id: cd4bdd23-8ff4-4097-7a96-08d832d13dc6
x-ms-traffictypediagnostic: AM6PR05MB4391:
x-microsoft-antispam-prvs: <AM6PR05MB43917F0C0353F1A4EF3D700FBE730@AM6PR05MB4391.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: f6FSCJEgUkfudRmqigUUwQaRJhdsXhN9r5N+94WANPXJ4ZhWkwsDzaAStpmclFT8Adv7HaPQjmx0iLMx7H/VkEXIw93ZNpWjfs4twASTxa3kwuP83MwVKthq8LVLcwtDVpQbED3VIKftW0ggj5ZV+fcUsn4gMT6yvw2otbyYMn52JG6j/1u8K5HlwUlOs+w9XRBPMOlkfmcnumpDwOiyqbdWR+wFH4uM7d/HpIY3lSbawgyrrdpXhYvP46v8PawR0tZlb0genB7DoJLNU+Lba5BCChz6Go84wK4tSYbY0LvdF6L4QPGS7g+Tv8I4FwE6Le9vigb1MtajN9g6zC4CYg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR05MB5094.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(396003)(366004)(376002)(39860400002)(346002)(6486002)(316002)(71200400001)(54906003)(66556008)(2906002)(6916009)(66476007)(4326008)(66446008)(64756008)(8676002)(66946007)(186003)(91956017)(76116006)(8936002)(2616005)(86362001)(26005)(36756003)(5660300002)(478600001)(6506007)(83380400001)(6512007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: HAD0Jf+nKqQn9e+z77YBrmJtUUMTQ4FEkoMFqEdHEfEZogsKZ46BjHbHQfTqwRU9u+UF4aBqRIbl+XcI/tCQJRVW+I98m6MGt79bll6gmwTwacal0eywbqdG8XxD2c8oMuIzMkTMw8ljLkNAcVOXRmqVAKtVP9wj0Nwb9+iUV8va5AsEqfdF+vvQeUfq3Vivynlhqb8RNVt9XOMt+Ds3/pyBjF413YWlx53S/yPbggHMP0l22nx6Ead7Iggs41p1pIy8kh3q7Mk0xxsgO6xebQcUf2dImXiFEXACrZynptJkqoILNwltBkaGrz0xaBjr1JZMXrHv+UrEyHXGMrhCdOmvl9ug6QE34psT1j+Se7DekgN+wiITEgObaDFSqK059lp1IDoR3YaTJDFlVownJGDCpg/60q7hZjfoTRVY/U7681Qqfn1s+71j/XSLu/1N75d2TZu6TC0IvFUI5q29Jx0QlpYYwUS1OX3nt7bbh38=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <C0E6713933B77B48B176195CBF6A2B00@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR05MB5094.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cd4bdd23-8ff4-4097-7a96-08d832d13dc6
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jul 2020 08:35:53.8087
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: alIx+WzVhaVmlFc04G/kcO5AIBZREOqFFBbSgufaTfOpzqAxAjlygTqq42VWFiefi76fjatnmcacQA2MG5gTRQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB4391
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAyMDIwLTA3LTI0IGF0IDE5OjUxIC0wNzAwLCBKYWt1YiBLaWNpbnNraSB3cm90ZToN
Cj4gQWxsb2NhdGUgbmljX2luZm8gZHluYW1pY2FsbHkgLSBuX2VudHJpZXMgaXMgbm90IGNvbnN0
YW50Lg0KPiANCj4gRHJvcCB0aGUgbmRvIGNhbGxiYWNrcyBmcm9tIHRoZSByZXBycywgdGhvc2Ug
c2hvdWxkIGJlIGxvY2FsIHRvDQo+IHRoZSBzYW1lIG5ldG5zIGFzIHRoZSBtYWluIG5ldGRldiwg
bm8gbmVlZCB0byBnZXQgdGhlIHNhbWUgY2FsbGJhY2tzDQo+IG11bHRpcGxlIHRpbWVzLg0KPiAN
Cg0KSXNuJ3QgdGhpcyBhIHByb2JsZW0gPyBzbyBpdCBzZWVtcyB0aGlzIGlzIHRoZSByb290IGNh
dXNlIG9mIHRoZQ0KcmVncmVzc2lvbiBmYWlsdXJlIHdlIHNhdyB3aXRoIHRoaXMgcGF0Y2guDQoN
CmluIGEgc3dpdGNoZGV2IG1vZGUgdGhlICJtYWluIiBuZXRkZXYgaXMgdW5yZWdpc3RlcmVkIGFu
ZCB3ZSByZWdpc3Rlcg0KYW5vdGhlciBuZXRkZXYgd2l0aCBuZG9zOiAibWx4NWVfbmV0ZGV2X29w
c191cGxpbmtfcmVwIiBhcyB0aGUgbmV3IG1haW4NCm5ldGRldiAodGhlIHVwbGluayByZXByZXNl
bnRvcikgd2hlcmUgeW91IHJlbW92ZWQgdGhlIHZ4bGFuIG5kb3MsIA0Kc2VlIGJlbG93Li4gDQoN
ClsuLi5dDQo+IA0KPiAgc3RhdGljIG5ldGRldl9mZWF0dXJlc190IG1seDVlX3R1bm5lbF9mZWF0
dXJlc19jaGVjayhzdHJ1Y3QNCj4gbWx4NWVfcHJpdiAqcHJpdiwNCj4gIAkJCQkJCSAgICAgc3Ry
dWN0IHNrX2J1ZmYNCj4gKnNrYiwNCj4gIAkJCQkJCSAgICAgbmV0ZGV2X2ZlYXR1cmVzX3QNCj4g
ZmVhdHVyZXMpDQo+IEBAIC00NjIwLDggKzQ1NDMsOCBAQCBjb25zdCBzdHJ1Y3QgbmV0X2Rldmlj
ZV9vcHMgbWx4NWVfbmV0ZGV2X29wcyA9DQo+IHsNCj4gIAkubmRvX2NoYW5nZV9tdHUgICAgICAg
ICAgPSBtbHg1ZV9jaGFuZ2VfbmljX210dSwNCj4gIAkubmRvX2RvX2lvY3RsICAgICAgICAgICAg
PSBtbHg1ZV9pb2N0bCwNCj4gIAkubmRvX3NldF90eF9tYXhyYXRlICAgICAgPSBtbHg1ZV9zZXRf
dHhfbWF4cmF0ZSwNCj4gLQkubmRvX3VkcF90dW5uZWxfYWRkICAgICAgPSBtbHg1ZV9hZGRfdnhs
YW5fcG9ydCwNCj4gLQkubmRvX3VkcF90dW5uZWxfZGVsICAgICAgPSBtbHg1ZV9kZWxfdnhsYW5f
cG9ydCwNCj4gKwkubmRvX3VkcF90dW5uZWxfYWRkICAgICAgPSB1ZHBfdHVubmVsX25pY19hZGRf
cG9ydCwNCj4gKwkubmRvX3VkcF90dW5uZWxfZGVsICAgICAgPSB1ZHBfdHVubmVsX25pY19kZWxf
cG9ydCwNCj4gIAkubmRvX2ZlYXR1cmVzX2NoZWNrICAgICAgPSBtbHg1ZV9mZWF0dXJlc19jaGVj
aywNCj4gIAkubmRvX3R4X3RpbWVvdXQgICAgICAgICAgPSBtbHg1ZV90eF90aW1lb3V0LA0KPiAg
CS5uZG9fYnBmCQkgPSBtbHg1ZV94ZHAsDQo+IEBAIC00OTM1LDYgKzQ4NTgsOCBAQCBzdGF0aWMg
dm9pZCBtbHg1ZV9idWlsZF9uaWNfbmV0ZGV2KHN0cnVjdA0KPiBuZXRfZGV2aWNlICpuZXRkZXYp
DQo+ICAJbmV0ZGV2LT5od19mZWF0dXJlcyAgICAgIHw9IE5FVElGX0ZfSFdfVkxBTl9DVEFHX0ZJ
TFRFUjsNCj4gIAluZXRkZXYtPmh3X2ZlYXR1cmVzICAgICAgfD0gTkVUSUZfRl9IV19WTEFOX1NU
QUdfVFg7DQo+ICANCj4gKwltbHg1X3Z4bGFuX3NldF9uZXRkZXZfaW5mbyhtZGV2LT52eGxhbiwg
bmV0ZGV2KTsNCj4gKw0KPiAgCWlmIChtbHg1X3Z4bGFuX2FsbG93ZWQobWRldi0+dnhsYW4pIHx8
DQo+IG1seDVfZ2VuZXZlX3R4X2FsbG93ZWQobWRldikgfHwNCj4gIAkgICAgbWx4NWVfYW55X3R1
bm5lbF9wcm90b19zdXBwb3J0ZWQobWRldikpIHsNCj4gIAkJbmV0ZGV2LT5od19lbmNfZmVhdHVy
ZXMgfD0gTkVUSUZfRl9IV19DU1VNOw0KPiBAQCAtNTI0MCw4ICs1MTY1LDcgQEAgc3RhdGljIHZv
aWQgbWx4NWVfbmljX2VuYWJsZShzdHJ1Y3QgbWx4NWVfcHJpdg0KPiAqcHJpdikNCj4gIAlydG5s
X2xvY2soKTsNCj4gIAlpZiAobmV0aWZfcnVubmluZyhuZXRkZXYpKQ0KPiAgCQltbHg1ZV9vcGVu
KG5ldGRldik7DQo+IC0JaWYgKG1seDVfdnhsYW5fYWxsb3dlZChwcml2LT5tZGV2LT52eGxhbikp
DQo+IC0JCXVkcF90dW5uZWxfZ2V0X3J4X2luZm8obmV0ZGV2KTsNCj4gKwl1ZHBfdHVubmVsX25p
Y19yZXNldF9udGYocHJpdi0+bmV0ZGV2KTsNCj4gIAluZXRpZl9kZXZpY2VfYXR0YWNoKG5ldGRl
dik7DQo+ICAJcnRubF91bmxvY2soKTsNCj4gIH0NCj4gQEAgLTUyNTYsOCArNTE4MCw2IEBAIHN0
YXRpYyB2b2lkIG1seDVlX25pY19kaXNhYmxlKHN0cnVjdCBtbHg1ZV9wcml2DQo+ICpwcml2KQ0K
PiAgCXJ0bmxfbG9jaygpOw0KPiAgCWlmIChuZXRpZl9ydW5uaW5nKHByaXYtPm5ldGRldikpDQo+
ICAJCW1seDVlX2Nsb3NlKHByaXYtPm5ldGRldik7DQo+IC0JaWYgKG1seDVfdnhsYW5fYWxsb3dl
ZChwcml2LT5tZGV2LT52eGxhbikpDQo+IC0JCXVkcF90dW5uZWxfZHJvcF9yeF9pbmZvKHByaXYt
Pm5ldGRldik7DQo+ICAJbmV0aWZfZGV2aWNlX2RldGFjaChwcml2LT5uZXRkZXYpOw0KPiAgCXJ0
bmxfdW5sb2NrKCk7DQo+ICANCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L21l
bGxhbm94L21seDUvY29yZS9lbl9yZXAuYw0KPiBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxh
bm94L21seDUvY29yZS9lbl9yZXAuYw0KPiBpbmRleCBjMzAwNzI5ZmI0OTguLjAwMGE3ZjI2NGZk
YSAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3Jl
L2VuX3JlcC5jDQo+ICsrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29y
ZS9lbl9yZXAuYw0KPiBAQCAtNjMzLDggKzYzMyw2IEBAIHN0YXRpYyBjb25zdCBzdHJ1Y3QgbmV0
X2RldmljZV9vcHMNCj4gbWx4NWVfbmV0ZGV2X29wc191cGxpbmtfcmVwID0gew0KPiAgCS5uZG9f
aGFzX29mZmxvYWRfc3RhdHMJID0gbWx4NWVfcmVwX2hhc19vZmZsb2FkX3N0YXRzLA0KPiAgCS5u
ZG9fZ2V0X29mZmxvYWRfc3RhdHMJID0gbWx4NWVfcmVwX2dldF9vZmZsb2FkX3N0YXRzLA0KPiAg
CS5uZG9fY2hhbmdlX210dSAgICAgICAgICA9IG1seDVlX3VwbGlua19yZXBfY2hhbmdlX210dSwN
Cj4gLQkubmRvX3VkcF90dW5uZWxfYWRkICAgICAgPSBtbHg1ZV9hZGRfdnhsYW5fcG9ydCwNCj4g
LQkubmRvX3VkcF90dW5uZWxfZGVsICAgICAgPSBtbHg1ZV9kZWxfdnhsYW5fcG9ydCwNCg0KSGVy
ZSwgdGhpcyBpcyB1cGxpbmsgcmVwcmVzZW50b3IgKGkuZSBtYWluIG5ldGRldikuDQp3ZSBuZWVk
IHRoZSB1ZHBfdHVubmVsX25kb3MuDQoNCmFsc28gd2UgbmVlZCB0byBhZGQ6DQptbHg1X3Z4bGFu
X3NldF9uZXRkZXZfaW5mbyhtZGV2LT52eGxhbiwgbmV0ZGV2KTsNCg0KaW4gbWx4NWVfYnVpbGRf
cmVwX25ldGRldigpIHVuZGVyIA0KaWYgKHJlcC0+dnBvcnQgPT0gTUxYNV9WUE9SVF9VUExJTksp
IHN0YXRlbWVudC4NCg0KWy4uLl0NCg==
