Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F9E1E2323
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 21:10:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731793AbfJWTKF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 15:10:05 -0400
Received: from mail-eopbgr10076.outbound.protection.outlook.com ([40.107.1.76]:32385
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726882AbfJWTKE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Oct 2019 15:10:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W/3MFvhS8IGLPtwj/4yzk8h5ujr3xbsbLYwR8E0JJAF6HsA3G00xAFmNWLSpvc52o7OLmRDnAT9+wZ2r7y6eFC/0m8v71i7xvzXF/OfU1pZsENpBsUpMshn7ain2hanNcJ9B2WoMtaL06DNWsjPdnWGv/QzX6o5bGQlsMbcxWIb8DWYv5sVisRTlPlGOFJed1v/H6VTt1wzTJcDaLoq/2V6FRQpCvYuTeMNWg9bxVKu7CgasTVJ/xh54J+3AJCmMBL/lHAjJLOC3IrSQ27/46DAlAxHocRiU7PF8qVFRL9pJWdcvV6q3eC3OTL/viaTw3T1U1AUprPuDnpdfu9xTjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T/evdQd976CeF9+HVQS5XrKg9Ez66Ao+Z3h4IeCbVto=;
 b=LT50iirxwJN0ly0GFul/6rQ/5VmwSQ1pFQeNObixy3Qo6xkUWsKAYuY0yVEsfQ6apF+23ovOKgJg9oBQ5iMt4Sa/vs3ywqJu6Z/Q7AGMJ/vVQVwpZC8rN5khs2R+SVxyl3GfO8Zt/QY8vv86r6AlKXsCh5xCjI/xVeOaM7++77TXCO32VlqN9ZLVBlnAxu9i7CiKcD9WIbRfreKvOb3VBOEo7LVsZLlbxlZYXHCA9DoMAMiGBAW0oNuGkGFKrvnxiH39LqPWR/WqezVoDN6FgViURx76KvuNqShkpbQJTRyi6zpi4pixFUpJGZTyHHfFOmxg96sHMUidKXk4vQJ7iA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T/evdQd976CeF9+HVQS5XrKg9Ez66Ao+Z3h4IeCbVto=;
 b=s16dyKezTHXxtBZGvkTVB74+SXVDsGvVk7KhMw83/+6YhQ54Pr1Ob4WkLJ2v69EnKPt+TMgEvc1ZT4gWDmODhZs8gaTq3hZmcbnY5NF/dtZ5FUyf6KHyhT5X5pf/R6YRmY/kjOFuYx6QNMpSdjBoJSXHIbpvOXBKJ7B1dnQl8zs=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB4541.eurprd05.prod.outlook.com (20.176.2.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2387.20; Wed, 23 Oct 2019 19:09:59 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::f42d:b87a:e6b2:f841]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::f42d:b87a:e6b2:f841%7]) with mapi id 15.20.2347.029; Wed, 23 Oct 2019
 19:09:59 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "ilias.apalodimas@linaro.org" <ilias.apalodimas@linaro.org>,
        "brouer@redhat.com" <brouer@redhat.com>
CC:     "jonathan.lemon@gmail.com" <jonathan.lemon@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 3/4] page_pool: Restructure
 __page_pool_put_page()
Thread-Topic: [PATCH net-next 3/4] page_pool: Restructure
 __page_pool_put_page()
Thread-Index: AQHViJNgKuuKGDOcK06kNreIia0L56dn6zqAgACj4oCAAAqogA==
Date:   Wed, 23 Oct 2019 19:09:59 +0000
Message-ID: <7b6eb498082145d8a4bd5ecd741081355f52d523.camel@mellanox.com>
References: <20191022044343.6901-1-saeedm@mellanox.com>
         <20191022044343.6901-4-saeedm@mellanox.com>
         <20191023084515.GA3726@apalos.home> <20191023203149.6b9f6d50@carbon>
In-Reply-To: <20191023203149.6b9f6d50@carbon>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.4 (3.32.4-1.fc30) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 446cb1f6-acf1-4111-6843-08d757ec9944
x-ms-traffictypediagnostic: VI1PR05MB4541:
x-microsoft-antispam-prvs: <VI1PR05MB4541808DF325DCE63848BACDBE6B0@VI1PR05MB4541.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 019919A9E4
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(346002)(376002)(39860400002)(396003)(136003)(199004)(189003)(102836004)(14454004)(76116006)(7736002)(86362001)(91956017)(446003)(486006)(8676002)(118296001)(2906002)(66946007)(26005)(36756003)(99286004)(66066001)(81156014)(186003)(81166006)(64756008)(66556008)(66446008)(8936002)(305945005)(2616005)(4001150100001)(66476007)(476003)(6116002)(3846002)(54906003)(6436002)(25786009)(58126008)(14444005)(11346002)(110136005)(316002)(256004)(6512007)(6486002)(2501003)(71190400001)(5660300002)(478600001)(71200400001)(76176011)(229853002)(4326008)(6246003)(6506007);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4541;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fQ7/w4EQTqFmkyeOKkREbSD1767Ic275F5ovpLoUZiW4894m/8IvDvxVZQzFrufhSrKFvQzdW3Ht5bIuySvF1cfJOnraxF/cwPpLZqyIBzKhlA20nK7GNtPER+WP7pv52quKz2OgmXp3YGx1wgB3rvHBM2KsOrK3X+VQQuCeXMmpwaKNxkMnk3hebdzDywyWbAT5KWbXZQeeOVmX7mwcOGj9kur2IaOnty2lZtQo2BUVrPlTDkvPzqkqhE7kj6oUBt0l8rYv1yiidjRyVBpiUu8EcJo8Ucsl8iyquamk+cs55JL24IftindzXky5afSTQ9bIogAWHx494+VZeU1jiuzLq05blpIEANc2H4qK4TL0a9Q/2R17Xjw02gq76ZUwomdKzR7O0Mxk9vNYI48yPXDVPbSOtSyBnykMDltdt6R7Mtd+UXBfc+y73piSrv2V
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <56CE67978E8E844A9BC2C8B7F781B3E9@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 446cb1f6-acf1-4111-6843-08d757ec9944
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Oct 2019 19:09:59.0380
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +6jSChFGXeyKX9kdL1qZjYph9a9Wmk6EP2Slf0F9w3Iij2TnDnLLgvF0Row/9iyqljUh3H+i+e8kjLoUwnqmPA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4541
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCAyMDE5LTEwLTIzIGF0IDIwOjMxICswMjAwLCBKZXNwZXIgRGFuZ2FhcmQgQnJvdWVy
IHdyb3RlOg0KPiBPbiBXZWQsIDIzIE9jdCAyMDE5IDExOjQ1OjE1ICswMzAwDQo+IElsaWFzIEFw
YWxvZGltYXMgPGlsaWFzLmFwYWxvZGltYXNAbGluYXJvLm9yZz4gd3JvdGU6DQo+IA0KPiA+IE9u
IFR1ZSwgT2N0IDIyLCAyMDE5IGF0IDA0OjQ0OjI0QU0gKzAwMDAsIFNhZWVkIE1haGFtZWVkIHdy
b3RlOg0KPiA+ID4gRnJvbTogSm9uYXRoYW4gTGVtb24gPGpvbmF0aGFuLmxlbW9uQGdtYWlsLmNv
bT4NCj4gPiA+IA0KPiA+ID4gMSkgUmVuYW1lIGZ1bmN0aW9ucyB0byByZWZsZWN0IHdoYXQgdGhl
eSBhcmUgYWN0dWFsbHkgZG9pbmcuDQo+ID4gPiANCj4gPiA+IDIpIFVuaWZ5IHRoZSBjb25kaXRp
b24gdG8ga2VlcCBhIHBhZ2UuDQo+ID4gPiANCj4gPiA+IDMpIFdoZW4gcGFnZSBjYW4ndCBiZSBr
ZXB0IGluIGNhY2hlLCBmYWxsYmFjayB0byByZWxlYXNpbmcgcGFnZQ0KPiA+ID4gdG8gcGFnZQ0K
PiA+ID4gYWxsb2NhdG9yIGluIG9uZSBwbGFjZSwgaW5zdGVhZCBvZiBjYWxsaW5nIGl0IGZyb20g
bXVsdGlwbGUNCj4gPiA+IGNvbmRpdGlvbnMsDQo+ID4gPiBhbmQgcmV1c2UgX19wYWdlX3Bvb2xf
cmV0dXJuX3BhZ2UoKS4NCj4gPiA+IA0KPiA+ID4gU2lnbmVkLW9mZi1ieTogSm9uYXRoYW4gTGVt
b24gPGpvbmF0aGFuLmxlbW9uQGdtYWlsLmNvbT4NCj4gPiA+IFNpZ25lZC1vZmYtYnk6IFNhZWVk
IE1haGFtZWVkIDxzYWVlZG1AbWVsbGFub3guY29tPg0KPiA+ID4gLS0tDQo+ID4gPiAgbmV0L2Nv
cmUvcGFnZV9wb29sLmMgfCAzOCArKysrKysrKysrKysrKysrKysrLS0tLS0tLS0tLS0tLS0tLS0t
LQ0KPiA+ID4gIDEgZmlsZSBjaGFuZ2VkLCAxOSBpbnNlcnRpb25zKCspLCAxOSBkZWxldGlvbnMo
LSkNCj4gPiA+IA0KPiA+ID4gZGlmZiAtLWdpdCBhL25ldC9jb3JlL3BhZ2VfcG9vbC5jIGIvbmV0
L2NvcmUvcGFnZV9wb29sLmMNCj4gPiA+IGluZGV4IDgxMjBhZWM5OTljZS4uNjU2ODBhYWEwODE4
IDEwMDY0NA0KPiA+ID4gLS0tIGEvbmV0L2NvcmUvcGFnZV9wb29sLmMNCj4gPiA+ICsrKyBiL25l
dC9jb3JlL3BhZ2VfcG9vbC5jDQo+ID4gPiBAQCAtMjU4LDYgKzI1OCw3IEBAIHN0YXRpYyBib29s
DQo+ID4gPiBfX3BhZ2VfcG9vbF9yZWN5Y2xlX2ludG9fcmluZyhzdHJ1Y3QgcGFnZV9wb29sICpw
b29sLA0KPiA+ID4gIAkJCQkgICBzdHJ1Y3QgcGFnZSAqcGFnZSkNCj4gPiA+ICB7DQo+ID4gPiAg
CWludCByZXQ7DQo+ID4gPiArDQo+ID4gPiAgCS8qIEJIIHByb3RlY3Rpb24gbm90IG5lZWRlZCBp
ZiBjdXJyZW50IGlzIHNlcnZpbmcgc29mdGlycSAqLw0KPiA+ID4gIAlpZiAoaW5fc2VydmluZ19z
b2Z0aXJxKCkpDQo+ID4gPiAgCQlyZXQgPSBwdHJfcmluZ19wcm9kdWNlKCZwb29sLT5yaW5nLCBw
YWdlKTsNCj4gPiA+IEBAIC0yNzIsOCArMjczLDggQEAgc3RhdGljIGJvb2wNCj4gPiA+IF9fcGFn
ZV9wb29sX3JlY3ljbGVfaW50b19yaW5nKHN0cnVjdCBwYWdlX3Bvb2wgKnBvb2wsDQo+ID4gPiAg
ICoNCj4gPiA+ICAgKiBDYWxsZXIgbXVzdCBwcm92aWRlIGFwcHJvcHJpYXRlIHNhZmUgY29udGV4
dC4NCj4gPiA+ICAgKi8NCj4gPiA+IC1zdGF0aWMgYm9vbCBfX3BhZ2VfcG9vbF9yZWN5Y2xlX2Rp
cmVjdChzdHJ1Y3QgcGFnZSAqcGFnZSwNCj4gPiA+IC0JCQkJICAgICAgIHN0cnVjdCBwYWdlX3Bv
b2wgKnBvb2wpDQo+ID4gPiArc3RhdGljIGJvb2wgX19wYWdlX3Bvb2xfcmVjeWNsZV9pbnRvX2Nh
Y2hlKHN0cnVjdCBwYWdlICpwYWdlLA0KPiA+ID4gKwkJCQkJICAgc3RydWN0IHBhZ2VfcG9vbCAq
cG9vbCkNCj4gPiA+ICB7DQo+ID4gPiAgCWlmICh1bmxpa2VseShwb29sLT5hbGxvYy5jb3VudCA9
PSBQUF9BTExPQ19DQUNIRV9TSVpFKSkNCj4gPiA+ICAJCXJldHVybiBmYWxzZTsNCj4gPiA+IEBA
IC0yODMsMTUgKzI4NCwxOCBAQCBzdGF0aWMgYm9vbA0KPiA+ID4gX19wYWdlX3Bvb2xfcmVjeWNs
ZV9kaXJlY3Qoc3RydWN0IHBhZ2UgKnBhZ2UsDQo+ID4gPiAgCXJldHVybiB0cnVlOw0KPiA+ID4g
IH0NCj4gPiA+ICANCj4gPiA+IC0vKiBwYWdlIGlzIE5PVCByZXVzYWJsZSB3aGVuOg0KPiA+ID4g
LSAqIDEpIGFsbG9jYXRlZCB3aGVuIHN5c3RlbSBpcyB1bmRlciBzb21lIHByZXNzdXJlLg0KPiA+
ID4gKHBhZ2VfaXNfcGZtZW1hbGxvYykNCj4gPiA+IC0gKiAyKSBiZWxvbmdzIHRvIGEgZGlmZmVy
ZW50IE5VTUEgbm9kZSB0aGFuIHBvb2wtPnAubmlkLg0KPiA+ID4gKy8qIEtlZXAgcGFnZSBpbiBj
YWNoZXMgb25seSBpZiBwYWdlOg0KPiA+ID4gKyAqIDEpIHdhc24ndCBhbGxvY2F0ZWQgd2hlbiBz
eXN0ZW0gaXMgdW5kZXIgc29tZSBwcmVzc3VyZQ0KPiA+ID4gKHBhZ2VfaXNfcGZtZW1hbGxvYyku
DQo+ID4gPiArICogMikgYmVsb25ncyB0byBwb29sJ3MgbnVtYSBub2RlIChwb29sLT5wLm5pZCku
DQo+ID4gPiArICogMykgcmVmY291bnQgaXMgMSAob3duZWQgYnkgcGFnZSBwb29sKS4NCj4gPiA+
ICAgKg0KPiA+ID4gICAqIFRvIHVwZGF0ZSBwb29sLT5wLm5pZCB1c2VycyBtdXN0IGNhbGwgcGFn
ZV9wb29sX3VwZGF0ZV9uaWQuDQo+ID4gPiAgICovDQo+ID4gPiAtc3RhdGljIGJvb2wgcG9vbF9w
YWdlX3JldXNhYmxlKHN0cnVjdCBwYWdlX3Bvb2wgKnBvb2wsIHN0cnVjdA0KPiA+ID4gcGFnZSAq
cGFnZSkNCj4gPiA+ICtzdGF0aWMgYm9vbCBwYWdlX3Bvb2xfa2VlcF9wYWdlKHN0cnVjdCBwYWdl
X3Bvb2wgKnBvb2wsIHN0cnVjdA0KPiA+ID4gcGFnZSAqcGFnZSkNCj4gPiA+ICB7DQo+ID4gPiAt
CXJldHVybiAhcGFnZV9pc19wZm1lbWFsbG9jKHBhZ2UpICYmIHBhZ2VfdG9fbmlkKHBhZ2UpID09
IHBvb2wtDQo+ID4gPiA+cC5uaWQ7DQo+ID4gPiArCXJldHVybiAhcGFnZV9pc19wZm1lbWFsbG9j
KHBhZ2UpICYmDQo+ID4gPiArCSAgICAgICBwYWdlX3RvX25pZChwYWdlKSA9PSBwb29sLT5wLm5p
ZCAmJg0KPiA+ID4gKwkgICAgICAgcGFnZV9yZWZfY291bnQocGFnZSkgPT0gMTsNCj4gPiA+ICB9
DQo+ID4gPiAgDQo+ID4gPiAgdm9pZCBfX3BhZ2VfcG9vbF9wdXRfcGFnZShzdHJ1Y3QgcGFnZV9w
b29sICpwb29sLA0KPiA+ID4gQEAgLTMwMCwyMiArMzA0LDE5IEBAIHZvaWQgX19wYWdlX3Bvb2xf
cHV0X3BhZ2Uoc3RydWN0IHBhZ2VfcG9vbA0KPiA+ID4gKnBvb2wsDQo+ID4gPiAgCS8qIFRoaXMg
YWxsb2NhdG9yIGlzIG9wdGltaXplZCBmb3IgdGhlIFhEUCBtb2RlIHRoYXQgdXNlcw0KPiA+ID4g
IAkgKiBvbmUtZnJhbWUtcGVyLXBhZ2UsIGJ1dCBoYXZlIGZhbGxiYWNrcyB0aGF0IGFjdCBsaWtl
IHRoZQ0KPiA+ID4gIAkgKiByZWd1bGFyIHBhZ2UgYWxsb2NhdG9yIEFQSXMuDQo+ID4gPiAtCSAq
DQo+ID4gPiAtCSAqIHJlZmNudCA9PSAxIG1lYW5zIHBhZ2VfcG9vbCBvd25zIHBhZ2UsIGFuZCBj
YW4gcmVjeWNsZSBpdC4NCj4gPiA+ICAJICovDQo+ID4gPiAtCWlmIChsaWtlbHkocGFnZV9yZWZf
Y291bnQocGFnZSkgPT0gMSAmJg0KPiA+ID4gLQkJICAgcG9vbF9wYWdlX3JldXNhYmxlKHBvb2ws
IHBhZ2UpKSkgew0KPiA+ID4gKw0KPiA+ID4gKwlpZiAobGlrZWx5KHBhZ2VfcG9vbF9rZWVwX3Bh
Z2UocG9vbCwgcGFnZSkpKSB7DQo+ID4gPiAgCQkvKiBSZWFkIGJhcnJpZXIgZG9uZSBpbiBwYWdl
X3JlZl9jb3VudCAvIFJFQURfT05DRSAqLw0KPiA+ID4gIA0KPiA+ID4gIAkJaWYgKGFsbG93X2Rp
cmVjdCAmJiBpbl9zZXJ2aW5nX3NvZnRpcnEoKSkNCj4gPiA+IC0JCQlpZiAoX19wYWdlX3Bvb2xf
cmVjeWNsZV9kaXJlY3QocGFnZSwgcG9vbCkpDQo+ID4gPiArCQkJaWYgKF9fcGFnZV9wb29sX3Jl
Y3ljbGVfaW50b19jYWNoZShwYWdlLCBwb29sKSkNCj4gPiA+ICAJCQkJcmV0dXJuOw0KPiA+ID4g
IA0KPiA+ID4gLQkJaWYgKCFfX3BhZ2VfcG9vbF9yZWN5Y2xlX2ludG9fcmluZyhwb29sLCBwYWdl
KSkgew0KPiA+ID4gLQkJCS8qIENhY2hlIGZ1bGwsIGZhbGxiYWNrIHRvIGZyZWUgcGFnZXMgKi8N
Cj4gPiA+IC0JCQlfX3BhZ2VfcG9vbF9yZXR1cm5fcGFnZShwb29sLCBwYWdlKTsNCj4gPiA+IC0J
CX0NCj4gPiA+IC0JCXJldHVybjsNCj4gPiA+ICsJCWlmIChfX3BhZ2VfcG9vbF9yZWN5Y2xlX2lu
dG9fcmluZyhwb29sLCBwYWdlKSkNCj4gPiA+ICsJCQlyZXR1cm47DQo+ID4gPiArDQo+ID4gPiAr
CQkvKiBDYWNoZSBmdWxsLCBmYWxsYmFjayB0byByZXR1cm4gcGFnZXMgKi8NCj4gPiA+ICAJfQ0K
PiA+ID4gIAkvKiBGYWxsYmFjay9ub24tWERQIG1vZGU6IEFQSSB1c2VyIGhhdmUgZWxldmF0ZWQg
cmVmY250Lg0KPiA+ID4gIAkgKg0KPiA+ID4gQEAgLTMzMCw4ICszMzEsNyBAQCB2b2lkIF9fcGFn
ZV9wb29sX3B1dF9wYWdlKHN0cnVjdCBwYWdlX3Bvb2wNCj4gPiA+ICpwb29sLA0KPiA+ID4gIAkg
KiBkb2luZyByZWZjbnQgYmFzZWQgcmVjeWNsZSB0cmlja3MsIG1lYW5pbmcgYW5vdGhlciBwcm9j
ZXNzDQo+ID4gPiAgCSAqIHdpbGwgYmUgaW52b2tpbmcgcHV0X3BhZ2UuDQo+ID4gPiAgCSAqLw0K
PiA+ID4gLQlfX3BhZ2VfcG9vbF9jbGVhbl9wYWdlKHBvb2wsIHBhZ2UpOw0KPiA+ID4gLQlwdXRf
cGFnZShwYWdlKTsNCj4gPiA+ICsJX19wYWdlX3Bvb2xfcmV0dXJuX3BhZ2UocG9vbCwgcGFnZSk7
ICANCj4gPiANCj4gPiBJIHRoaW5rIEplc3BlciBoYWQgYSByZWFzb24gZm9yIGNhbGxpbmcgdGhl
bSBzZXBhcmF0ZWx5IGluc3RlYWQgb2YgDQo+ID4gX19wYWdlX3Bvb2xfcmV0dXJuX3BhZ2UgKyBw
dXRfcGFnZSgpICh3aGljaCBpbiBmYWN0IGRvZXMgdGhlIHNhbWUNCj4gPiB0aGluZykuIA0KPiA+
IA0KPiA+IEluIHRoZSBmdXR1cmUgaGUgd2FzIHBsYW5uaW5nIG9uIHJlbW92aW5nIHRoZQ0KPiA+
IF9fcGFnZV9wb29sX2NsZWFuX3BhZ2UgY2FsbCBmcm9tDQo+ID4gdGhlcmUsIHNpbmNlIHNvbWVv
bmUgbWlnaHQgY2FsbCBfX3BhZ2VfcG9vbF9wdXRfcGFnZSgpIGFmdGVyDQo+ID4gc29tZW9uZSBo
YXMgY2FsbGVkDQo+ID4gX19wYWdlX3Bvb2xfY2xlYW5fcGFnZSgpDQo+IA0KPiBZZXMuICBXZSBu
ZWVkIHRvIHdvcmsgb24gcmVtb3ZpbmcgdGhpcyAgX19wYWdlX3Bvb2xfY2xlYW5fcGFnZSgpDQo+
IGNhbGwsDQo+IHRvIGZ1bGZpbGwgdGhlIHBsYW5zIG9mIFNLQiByZXR1cm5pbmcvcmVjeWNsaW5n
IHBhZ2VfcG9vbCBwYWdlcy4NCj4gDQo+ID4gQ2FuIHdlIGxlYXZlIHRoZSBjYWxscyB0aGVyZSBh
cy1pcz8NCj4gDQo+IFllcywgcGxlYXNlLg0KPiANCg0KU3VyZSwgaSB3aWxsIGRyb3AgdGhpcyBw
YXRjaCBmb3Igbm93Lg0K
