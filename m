Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C9F7839C4
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 21:42:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726136AbfHFTmE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 15:42:04 -0400
Received: from mail-eopbgr150082.outbound.protection.outlook.com ([40.107.15.82]:3150
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725798AbfHFTmD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Aug 2019 15:42:03 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UmVZLZolpDmHAdQfUA+VlFJup0q9EtF8KETBAjnaJA9+5AUybygZ++ecMaFc3U40b2rQbjsPFBzapTzVxXC6z1MBpmFYpbzKPpOPK9iaGJ6457oLWxyj/YsKA1Il/xI9SPjtBKzR1NrhQBL6UI/blwQLy/GXtNTwD54Jv0+z3TZaQFwM4TeFy8Iyx3v6oZy8Tozj7UfyapGgLtbtc/4+QXvBMJuxeSZujCv6CNcYq3X5MY6wScS2QTViYUTaMI86hNW026q5GZhiDApE0bpMaDNrLZ5qojyu39w80ofCbg8vno8v7Thy7tDUmnyjEhJwNcpY7U3s8sXxIkonMXsxDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NT9bVVMx1PjUa7IUDia+LC5SKntpXrV0sgtvugbmjes=;
 b=Guca1BYjHpCJM3m9SG8fLoSaECNEhGJnQLyYX6YPnDkLeRrEiVh3giw53wF839Gpy04MPuyAIjC6+AvjuSJD7YrdmZtHZ09bicQ8wkdbojoIUi++pHQmu2nb9XDrk9dFhEadTEhdQK7Svm2UoFjJNMZFL1/sT7Y6bPonKZyRy7lXycC7NvrhO76h8448XOlij8SsuPUlrftBZQnGksIZvhnrgpJQQ0iVn1wCyH2sSUBN/nEIfhHvxmOgbitHk5Xwd8mxmj7FPIHo9RDh6MYUN1+VblpHdnhFEZtT0/5DxQ4YQrH8F6lshzZlDZDWBbqPP5SvXp3he3e2MLkssi1w9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NT9bVVMx1PjUa7IUDia+LC5SKntpXrV0sgtvugbmjes=;
 b=PAN6FOJJozwP2QLBBAb4QQQXapoW9Sbc+UEDHhg4zqNknh+1mo5EQIbHcs83ValQjninBtasShyrCGP5BDB5DI5s5M3QuDv+fz6BCnk1oA4rDZsgJp0/bdqRzLydYrgmdu7Aja8AmEHkwI/uo7C3Tay10pXLWzBUOyc0Cq0AVTk=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2501.eurprd05.prod.outlook.com (10.168.75.135) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.14; Tue, 6 Aug 2019 19:41:57 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2%5]) with mapi id 15.20.2136.018; Tue, 6 Aug 2019
 19:41:57 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "leon@kernel.org" <leon@kernel.org>
Subject: Re: [PATCH 03/17] mlx5: no need to check return value of
 debugfs_create functions
Thread-Topic: [PATCH 03/17] mlx5: no need to check return value of
 debugfs_create functions
Thread-Index: AQHVTHGxAql7Mh9Nt0CFTl4RatXQv6buhR2A
Date:   Tue, 6 Aug 2019 19:41:57 +0000
Message-ID: <d681be03ea2c1997004c8144c3a6062f895817a4.camel@mellanox.com>
References: <20190806161128.31232-1-gregkh@linuxfoundation.org>
         <20190806161128.31232-4-gregkh@linuxfoundation.org>
In-Reply-To: <20190806161128.31232-4-gregkh@linuxfoundation.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.4 (3.32.4-1.fc30) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c0525676-bc39-41a3-4ba1-08d71aa624ad
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:DB6PR0501MB2501;
x-ms-traffictypediagnostic: DB6PR0501MB2501:
x-microsoft-antispam-prvs: <DB6PR0501MB25013A88764BFC9D284DD2C2BED50@DB6PR0501MB2501.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0121F24F22
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(346002)(376002)(366004)(136003)(39860400002)(199004)(189003)(476003)(6436002)(68736007)(58126008)(110136005)(26005)(2616005)(11346002)(316002)(66066001)(486006)(6512007)(256004)(446003)(6486002)(66556008)(76116006)(229853002)(91956017)(66946007)(64756008)(66446008)(66476007)(86362001)(8936002)(71200400001)(71190400001)(36756003)(5660300002)(6116002)(4326008)(6506007)(2906002)(99286004)(8676002)(3846002)(76176011)(6246003)(118296001)(102836004)(81166006)(53936002)(25786009)(81156014)(2501003)(14454004)(186003)(7736002)(305945005)(478600001);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2501;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: t1MtPJCVXXAxUmFTRVA7T7x8OezDxUCj87cJ/p0oPJIosa3axe6XJwAafALEdPfqznRRCiLDUJ6WavUTjYGJxOU75nQHYfRA2uQPJJBY9phlgWy1h6y3R+sGsDHUHKqJ0gccQclWaWb2vr2HCHxWZHUAlF2xOidv54qyZFDcqdmv7mjfzV8P5bLtvUDp5shs6lZfaCy8QiQcy9LGJLPZZMy6SFx/bZX+kdFh48xRxUdVAPqmVmxf8rn9eB1YN59L2FMf2myNVSTKfjVFX5ClVYeauYzIjvCJKaKsHK3O9WWO7MKSfKzdRHsDa/07qy4Fp34qUGQSP2Gx3JakETaM51MTRB/an0V/nORN2fItUEfTbPg5+ZJ0WA773U9J//egHWr0spyMKaCtLmFUBKHui8PJf3pl5FX15MWwL/FsfJ4=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <9C2FCE7D5831A64585EA6189FE1433E7@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c0525676-bc39-41a3-4ba1-08d71aa624ad
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Aug 2019 19:41:57.6745
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2501
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDE5LTA4LTA2IGF0IDE4OjExICswMjAwLCBHcmVnIEtyb2FoLUhhcnRtYW4gd3Jv
dGU6DQo+IFdoZW4gY2FsbGluZyBkZWJ1Z2ZzIGZ1bmN0aW9ucywgdGhlcmUgaXMgbm8gbmVlZCB0
byBldmVyIGNoZWNrIHRoZQ0KPiByZXR1cm4gdmFsdWUuICBUaGUgZnVuY3Rpb24gY2FuIHdvcmsg
b3Igbm90LCBidXQgdGhlIGNvZGUgbG9naWMNCj4gc2hvdWxkDQo+IG5ldmVyIGRvIHNvbWV0aGlu
ZyBkaWZmZXJlbnQgYmFzZWQgb24gdGhpcy4NCj4gDQo+IFRoaXMgY2xlYW5zIHVwIGEgbG90IG9m
IHVubmVlZGVkIGNvZGUgYW5kIGxvZ2ljIGFyb3VuZCB0aGUgZGVidWdmcw0KPiBmaWxlcywgbWFr
aW5nIGFsbCBvZiB0aGlzIG11Y2ggc2ltcGxlciBhbmQgZWFzaWVyIHRvIHVuZGVyc3RhbmQgYXMg
d2UNCj4gZG9uJ3QgbmVlZCB0byBrZWVwIHRoZSBkZW50cmllcyBzYXZlZCBhbnltb3JlLg0KPiAN
Cg0KSGkgR3JlZywgDQoNCkJhc2ljYWxseSBpIGFtIG9rIHdpdGggdGhpcyBwYXRjaCBhbmQgaSBs
aWtlIGl0IHZlcnkgbXVjaC4uLCBidXQgaSBhbQ0KY29uY2VybmVkIGFib3V0IHNvbWUgb2YgdGhl
IGRyaXZlciBpbnRlcm5hbCBmbG93cyB0aGF0IGFyZSBkZXBlbmRlbnQgb24NCnRoZXNlIGRlYnVn
IGZzIGVudHJpZXMgYmVpbmcgdmFsaWQuDQoNCmZvciBleGFtcGxlIG1seDVfZGVidWdfZXFfYWRk
IGlmIGZhaWxlZCwgaXQgd2lsbCBmYWlsIHRoZSB3aG9sZSBmbG93LiBJDQprbm93IGl0IGlzIHdy
b25nIGV2ZW4gYmVmb3JlIHlvdXIgcGF0Y2guLiBidXQgbWF5YmUgd2Ugc2hvdWxkIGRlYWwgd2l0
aA0KaXQgbm93ID8gb3IgbGV0IG1lIGtub3cgaWYgeW91IHdhbnQgbWUgdG8gZm9sbG93IHVwIHdp
dGggbXkgb3duIHBhdGNoLiANCg0KQWxsIHdlIG5lZWQgdG8gaW1wcm92ZSBpbiB0aGlzIHBhdGNo
IGlzIHRvIHZvaWQgb3V0IGFkZF9yZXNfdHJlZSgpDQppbXBsZW1lbnRlZCBpbiANCmRyaXZlcnMv
bmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9kZWJ1Z2ZzLmMgDQphcyBpIHdpbGwgY29t
bWVudCBiZWxvdy4NCg0KDQo+IENjOiBTYWVlZCBNYWhhbWVlZCA8c2FlZWRtQG1lbGxhbm94LmNv
bT4NCj4gQ2M6IExlb24gUm9tYW5vdnNreSA8bGVvbkBrZXJuZWwub3JnPg0KPiBDYzogbmV0ZGV2
QHZnZXIua2VybmVsLm9yZw0KPiBTaWduZWQtb2ZmLWJ5OiBHcmVnIEtyb2FoLUhhcnRtYW4gPGdy
ZWdraEBsaW51eGZvdW5kYXRpb24ub3JnPg0KPiAtLS0NCj4gIGRyaXZlcnMvbmV0L2V0aGVybmV0
L21lbGxhbm94L21seDUvY29yZS9jbWQuYyB8ICA1MSArKy0tLS0tLS0NCj4gIC4uLi9uZXQvZXRo
ZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2RlYnVnZnMuYyB8IDEwMiArKy0tLS0tLS0tLS0tLQ0K
PiAtLS0tDQo+ICBkcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZXEuYyAg
fCAgMTEgKy0NCj4gIC4uLi9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2xpYi9lcS5o
ICB8ICAgMiArLQ0KPiAgLi4uL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvbWFpbi5j
ICAgIHwgICA3ICstDQo+ICAuLi4vZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL21seDVfY29y
ZS5oICAgfCAgIDIgKy0NCj4gIGluY2x1ZGUvbGludXgvbWx4NS9kcml2ZXIuaCAgICAgICAgICAg
ICAgICAgICB8ICAxMiArLS0NCj4gIDcgZmlsZXMgY2hhbmdlZCwgMjQgaW5zZXJ0aW9ucygrKSwg
MTYzIGRlbGV0aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0
L21lbGxhbm94L21seDUvY29yZS9jbWQuYw0KPiBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxh
bm94L21seDUvY29yZS9jbWQuYw0KPiBpbmRleCA4Y2RkN2U2NmY4ZGYuLjk3M2Y5MDg4OGIxZiAx
MDA2NDQNCj4gLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2Nt
ZC5jDQo+ICsrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9jbWQu
Yw0KPiBAQCAtMTM2OCw0OSArMTM2OCwxOSBAQCBzdGF0aWMgdm9pZCBjbGVhbl9kZWJ1Z19maWxl
cyhzdHJ1Y3QNCj4gbWx4NV9jb3JlX2RldiAqZGV2KQ0KPiAgCWRlYnVnZnNfcmVtb3ZlX3JlY3Vy
c2l2ZShkYmctPmRiZ19yb290KTsNCj4gIH0NCj4gIA0KDQpbLi4uXQ0KDQo+ICB2b2lkIG1seDVf
Y3FfZGVidWdmc19jbGVhbnVwKHN0cnVjdCBtbHg1X2NvcmVfZGV2ICpkZXYpDQo+ICB7DQo+IC0J
aWYgKCFtbHg1X2RlYnVnZnNfcm9vdCkNCj4gLQkJcmV0dXJuOw0KPiAtDQo+ICAJZGVidWdmc19y
ZW1vdmVfcmVjdXJzaXZlKGRldi0+cHJpdi5jcV9kZWJ1Z2ZzKTsNCj4gIH0NCj4gIA0KPiBAQCAt
NDg0LDcgKzQxOCw2IEBAIHN0YXRpYyBpbnQgYWRkX3Jlc190cmVlKHN0cnVjdCBtbHg1X2NvcmVf
ZGV2IA0KDQpCYXNpY2FsbHkgdGhpcyBmdW5jdGlvbiBpcyBhIGRlYnVnZnMgd3JhcHBlciB0aGF0
IHNob3VsZCBiZWhhdmUgdGhlDQpzYW1lIGFzIGRlYnVnX2ZzXyosIHdlIHNob3VsZCBmaXggaXQg
dG8gcmV0dXJuIHZvaWQgYXMgd2VsbCwgYW5kDQppbXByb3ZlIGFsbCB0aGUgaXRzIGNhbGxlcnMg
dG8gaWdub3JlIHRoZSByZXR1cm4gdmFsdWUuDQoNCmNhbGxlcnMgYXJlOg0KbWx4NV9kZWJ1Z19x
cF9hZGQoKQ0KbWx4NV9kZWJ1Z19lcV9hZGQoKQ0KbWx4NV9kZWJ1Z19jcV9hZGQoKQ0KDQo+ICpk
ZXYsIGVudW0gZGJnX3JzY190eXBlIHR5cGUsDQo+ICB7DQo+ICAJc3RydWN0IG1seDVfcnNjX2Rl
YnVnICpkOw0KPiAgCWNoYXIgcmVzblszMl07DQo+IC0JaW50IGVycjsNCj4gIAlpbnQgaTsNCj4g
IA0KPiAgCWQgPSBremFsbG9jKHN0cnVjdF9zaXplKGQsIGZpZWxkcywgbmZpbGUpLCBHRlBfS0VS
TkVMKTsNCj4gQEAgLTQ5NiwzMCArNDI5LDE1IEBAIHN0YXRpYyBpbnQgYWRkX3Jlc190cmVlKHN0
cnVjdCBtbHg1X2NvcmVfZGV2DQo+ICpkZXYsIGVudW0gZGJnX3JzY190eXBlIHR5cGUsDQo+ICAJ
ZC0+dHlwZSA9IHR5cGU7DQo+ICAJc3ByaW50ZihyZXNuLCAiMHgleCIsIHJzbik7DQo+ICAJZC0+
cm9vdCA9IGRlYnVnZnNfY3JlYXRlX2RpcihyZXNuLCAgcm9vdCk7DQo+IC0JaWYgKCFkLT5yb290
KSB7DQo+IC0JCWVyciA9IC1FTk9NRU07DQo+IC0JCWdvdG8gb3V0X2ZyZWU7DQo+IC0JfQ0KPiAg
DQo+ICAJZm9yIChpID0gMDsgaSA8IG5maWxlOyBpKyspIHsNCj4gIAkJZC0+ZmllbGRzW2ldLmkg
PSBpOw0KPiAtCQlkLT5maWVsZHNbaV0uZGVudCA9IGRlYnVnZnNfY3JlYXRlX2ZpbGUoZmllbGRb
aV0sIDA0MDAsDQo+IC0JCQkJCQkJZC0+cm9vdCwgJmQtDQo+ID5maWVsZHNbaV0sDQo+IC0JCQkJ
CQkJJmZvcHMpOw0KPiAtCQlpZiAoIWQtPmZpZWxkc1tpXS5kZW50KSB7DQo+IC0JCQllcnIgPSAt
RU5PTUVNOw0KPiAtCQkJZ290byBvdXRfcmVtOw0KPiAtCQl9DQo+ICsJCWRlYnVnZnNfY3JlYXRl
X2ZpbGUoZmllbGRbaV0sIDA0MDAsIGQtPnJvb3QsICZkLQ0KPiA+ZmllbGRzW2ldLA0KPiArCQkJ
CSAgICAmZm9wcyk7DQo+ICAJfQ0KPiAgCSpkYmcgPSBkOw0KPiAgDQo+ICAJcmV0dXJuIDA7DQo+
IC1vdXRfcmVtOg0KPiAtCWRlYnVnZnNfcmVtb3ZlX3JlY3Vyc2l2ZShkLT5yb290KTsNCj4gLQ0K
PiAtb3V0X2ZyZWU6DQo+IC0Ja2ZyZWUoZCk7DQo+IC0JcmV0dXJuIGVycjsNCj4gIH0NCg==
