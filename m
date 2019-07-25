Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3048074B57
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 12:16:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389876AbfGYKQC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 06:16:02 -0400
Received: from mail-eopbgr130050.outbound.protection.outlook.com ([40.107.13.50]:31337
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388270AbfGYKQC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Jul 2019 06:16:02 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CZp8e0fl3aKh+FjjndT5zetGUeCjstL/V1pitrga//27BSvaM+0r+RsqCmicMEEpYxSRi7eg/y5TMJ1CLaBjWFNHyKCYV1K4h8yyOmvlhUiYTIbmP0+cFr0zep8VSpPm5kqTrYtryETf6+rYG3/Z480LPEEHrbPkueWxjctv2XiIiQCDYggUzsqAcP4dcgTFGC1r4jvMTRBRd+cMHWsHH1gAnxCgWJuDZwa9LTttHnz07TI9l9ZFpX5QOk56H2vXmlV6KOU6je7DrG/Nk6ah1FoMtskVVVO9HEO5OyjT+wFE6TGghtD6yMqnWVpt7aPOS+OBlZxRMH7L76d+ksl7lA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N/brvssYKSJS40X2+pU1aG+EFGGTg5Vve8WdNVhkjc8=;
 b=BjNH82Fa3PSC+Li4So9kUiWAB9A88q4iLMTXHY/NaTXTBTvQORLZXxmqJVt+ewmuD5ZD60Uvk0GFSxXGT5IYyrvtb9SccBPvF/3Fe8+F5aXx+gMZV/qd8ME83o+irzSwPpvDCCSr4AJGLRInC43mUhyEti+PY1oMsySZuwIhOoYJRMqXcK0rBDIuJAPWJURZQTok7FIRqGTUZ7n+FHWvuipNwSYUV5wfkdycbg+r2HTvGqTqqSubvo86yRFrgsMY7Za4nigb49ynvDROYEWzQ0PwXuTqum3dzNaOQYZHt796/rxsUkZ0+iDymmwi7etGvkJR3hMTU6Rb7x2spd+yDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=mellanox.com;dmarc=pass action=none
 header.from=mellanox.com;dkim=pass header.d=mellanox.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N/brvssYKSJS40X2+pU1aG+EFGGTg5Vve8WdNVhkjc8=;
 b=OwYgjceELSTKs1WHQUuiZuE2AHVBEqLdJF/aazH+A9Kb7X5XSj3X0xbdqKHfZfwfCtCEHxhpcLNncKkWBQSQxn7vEDGRzg3AKUjY5z3e5QG99HyM8jtfxX26zk8uM2/IBx53RBCmNnsX/yuuS5bagnHUDJP+xnBq7hk1YR7mlr8=
Received: from AM6PR05MB5879.eurprd05.prod.outlook.com (20.179.0.76) by
 AM6PR05MB5191.eurprd05.prod.outlook.com (20.177.196.161) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2094.15; Thu, 25 Jul 2019 10:15:56 +0000
Received: from AM6PR05MB5879.eurprd05.prod.outlook.com
 ([fe80::f9d8:38bc:4a18:f7a7]) by AM6PR05MB5879.eurprd05.prod.outlook.com
 ([fe80::f9d8:38bc:4a18:f7a7%5]) with mapi id 15.20.2115.005; Thu, 25 Jul 2019
 10:15:55 +0000
From:   Maxim Mikityanskiy <maximmi@mellanox.com>
To:     Kevin Laatz <kevin.laatz@intel.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "bjorn.topel@intel.com" <bjorn.topel@intel.com>,
        "magnus.karlsson@intel.com" <magnus.karlsson@intel.com>,
        "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>,
        "jonathan.lemon@gmail.com" <jonathan.lemon@gmail.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "stephen@networkplumber.org" <stephen@networkplumber.org>,
        "bruce.richardson@intel.com" <bruce.richardson@intel.com>,
        "ciara.loftus@intel.com" <ciara.loftus@intel.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
Subject: Re: [PATCH bpf-next v3 06/11] mlx5e: modify driver for handling
 offsets
Thread-Topic: [PATCH bpf-next v3 06/11] mlx5e: modify driver for handling
 offsets
Thread-Index: AQHVQiNpB87vkdrGIUKaz1R1Zy1BQ6bbH5iA
Date:   Thu, 25 Jul 2019 10:15:55 +0000
Message-ID: <c5704b74-8efe-af2a-68e6-716fa89a5665@mellanox.com>
References: <20190716030637.5634-1-kevin.laatz@intel.com>
 <20190724051043.14348-1-kevin.laatz@intel.com>
 <20190724051043.14348-7-kevin.laatz@intel.com>
In-Reply-To: <20190724051043.14348-7-kevin.laatz@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: HE1P189CA0004.EURP189.PROD.OUTLOOK.COM (2603:10a6:7:53::17)
 To AM6PR05MB5879.eurprd05.prod.outlook.com (2603:10a6:20b:a2::12)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=maximmi@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [159.224.90.213]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ab5aaa9c-343d-406d-27da-08d710e914b7
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM6PR05MB5191;
x-ms-traffictypediagnostic: AM6PR05MB5191:
x-microsoft-antispam-prvs: <AM6PR05MB51913C1E0A62B849330914B2D1C10@AM6PR05MB5191.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0109D382B0
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(396003)(376002)(346002)(39860400002)(136003)(52314003)(199004)(189003)(7416002)(66946007)(256004)(86362001)(26005)(6436002)(53936002)(5660300002)(8676002)(305945005)(8936002)(316002)(31696002)(6486002)(36756003)(66556008)(81166006)(71200400001)(186003)(66446008)(81156014)(6506007)(54906003)(6246003)(64756008)(7736002)(6512007)(71190400001)(66476007)(446003)(2906002)(6116002)(99286004)(476003)(386003)(2616005)(11346002)(6916009)(25786009)(66066001)(3846002)(52116002)(486006)(31686004)(14454004)(76176011)(229853002)(53546011)(102836004)(478600001)(4326008)(68736007)(55236004)(32563001);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR05MB5191;H:AM6PR05MB5879.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: /psVHyfL59O9TjnudVRAj/WjsNqE0hzKOw7c44tgNHaKWN7c+TqMk3F0602MvW81JK0i4WRk6/A0dClkEq6kXor4FSxnaIANsipkHndSFOie0R9uUe9WJE7BV45qpx//Typ7n2Ut8T31RnNkRjfkTtblKW3qFNmP9Xh5gGYFhHoJq/WfR2F7udaPXjoSRt+UAJpT7yQMFDTDebcLB8xMKox2rtZdeaEF3y2r5NuKknCSZjJH695ZHKnquAKt8bnknI+tcnkGsTWc1t856CGpruF08BlKJg72IIdsbTfGjgBfYIIE4cJk/Px58df5cT0kYZFyeHCfbyeBy9btw79z/Ph6rJNKr0ZEE+nvCunzk40lUOvdbSpVJK7fJ+hra0YT0i31t6l1fw/+Jjlb1hgQaVk4Y04jkoKANihb6IXlmhk=
Content-Type: text/plain; charset="utf-8"
Content-ID: <018B6117E075A04BBABDA2A59FFD189B@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ab5aaa9c-343d-406d-27da-08d710e914b7
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jul 2019 10:15:55.8135
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: maximmi@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB5191
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMjAxOS0wNy0yNCAwODoxMCwgS2V2aW4gTGFhdHogd3JvdGU6DQo+IFdpdGggdGhlIGFkZGl0
aW9uIG9mIHRoZSB1bmFsaWduZWQgY2h1bmtzIG9wdGlvbiwgd2UgbmVlZCB0byBtYWtlIHN1cmUg
d2UNCj4gaGFuZGxlIHRoZSBvZmZzZXRzIGFjY29yZGluZ2x5IGJhc2VkIG9uIHRoZSBtb2RlIHdl
IGFyZSBjdXJyZW50bHkgcnVubmluZw0KPiBpbi4gVGhpcyBwYXRjaCBtb2RpZmllcyB0aGUgZHJp
dmVyIHRvIGFwcHJvcHJpYXRlbHkgbWFzayB0aGUgYWRkcmVzcyBmb3INCj4gZWFjaCBjYXNlLg0K
PiANCj4gU2lnbmVkLW9mZi1ieTogS2V2aW4gTGFhdHogPGtldmluLmxhYXR6QGludGVsLmNvbT4N
Cj4gDQo+IC0tLQ0KPiB2MzoNCj4gICAgLSBVc2UgbmV3IGhlbHBlciBmdW5jdGlvbiB0byBoYW5k
bGUgb2Zmc2V0DQo+IC0tLQ0KPiAgIGRyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUv
Y29yZS9lbi94ZHAuYyAgICB8IDggKysrKysrLS0NCj4gICBkcml2ZXJzL25ldC9ldGhlcm5ldC9t
ZWxsYW5veC9tbHg1L2NvcmUvZW4veHNrL3R4LmMgfCA5ICsrKysrKystLQ0KPiAgIDIgZmlsZXMg
Y2hhbmdlZCwgMTMgaW5zZXJ0aW9ucygrKSwgNCBkZWxldGlvbnMoLSkNCj4gDQo+IGRpZmYgLS1n
aXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW4veGRwLmMgYi9k
cml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW4veGRwLmMNCj4gaW5kZXgg
YjBiOTgyY2Y2OWJiLi5kNTI0NTg5M2QyYzggMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvbmV0L2V0
aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lbi94ZHAuYw0KPiArKysgYi9kcml2ZXJzL25ldC9l
dGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW4veGRwLmMNCj4gQEAgLTEyMiw2ICsxMjIsNyBA
QCBib29sIG1seDVlX3hkcF9oYW5kbGUoc3RydWN0IG1seDVlX3JxICpycSwgc3RydWN0IG1seDVl
X2RtYV9pbmZvICpkaSwNCj4gICAJCSAgICAgIHZvaWQgKnZhLCB1MTYgKnJ4X2hlYWRyb29tLCB1
MzIgKmxlbiwgYm9vbCB4c2spDQo+ICAgew0KPiAgIAlzdHJ1Y3QgYnBmX3Byb2cgKnByb2cgPSBS
RUFEX09OQ0UocnEtPnhkcF9wcm9nKTsNCj4gKwlzdHJ1Y3QgeGRwX3VtZW0gKnVtZW0gPSBycS0+
dW1lbTsNCj4gICAJc3RydWN0IHhkcF9idWZmIHhkcDsNCj4gICAJdTMyIGFjdDsNCj4gICAJaW50
IGVycjsNCj4gQEAgLTEzOCw4ICsxMzksMTEgQEAgYm9vbCBtbHg1ZV94ZHBfaGFuZGxlKHN0cnVj
dCBtbHg1ZV9ycSAqcnEsIHN0cnVjdCBtbHg1ZV9kbWFfaW5mbyAqZGksDQo+ICAgCXhkcC5yeHEg
PSAmcnEtPnhkcF9yeHE7DQo+ICAgDQo+ICAgCWFjdCA9IGJwZl9wcm9nX3J1bl94ZHAocHJvZywg
JnhkcCk7DQo+IC0JaWYgKHhzaykNCj4gLQkJeGRwLmhhbmRsZSArPSB4ZHAuZGF0YSAtIHhkcC5k
YXRhX2hhcmRfc3RhcnQ7DQo+ICsJaWYgKHhzaykgew0KPiArCQl1NjQgb2ZmID0geGRwLmRhdGEg
LSB4ZHAuZGF0YV9oYXJkX3N0YXJ0Ow0KPiArDQo+ICsJCXhkcC5oYW5kbGUgPSB4c2tfdW1lbV9o
YW5kbGVfb2Zmc2V0KHVtZW0sIHhkcC5oYW5kbGUsIG9mZik7DQo+ICsJfQ0KDQpXaGF0J3MgbWlz
c2VkIGlzIHRoYXQgdW1lbV9oZWFkcm9vbSBpcyBhZGRlZCB0byBoYW5kbGUgZGlyZWN0bHkgaW4g
DQptbHg1ZV94c2tfcGFnZV9hbGxvY191bWVtLiBJbiBteSB1bmRlcnN0YW5kaW5nIHVtZW1faGVh
ZHJvb20gc2hvdWxkIGdvIA0KdG8gdGhlIG9mZnNldCBwYXJ0IChoaWdoIDE2IGJpdHMpIG9mIHRo
ZSBoYW5kbGUsIHRvIA0KeHNrX3VtZW1faGFuZGxlX29mZnNldCBoYXMgdG8gc3VwcG9ydCBpbmNy
ZWFzaW5nIHRoZSBvZmZzZXQuDQoNCj4gICAJc3dpdGNoIChhY3QpIHsNCj4gICAJY2FzZSBYRFBf
UEFTUzoNCj4gICAJCSpyeF9oZWFkcm9vbSA9IHhkcC5kYXRhIC0geGRwLmRhdGFfaGFyZF9zdGFy
dDsNCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29y
ZS9lbi94c2svdHguYyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9l
bi94c2svdHguYw0KPiBpbmRleCAzNWUxODhjZjRlYTQuLmY1OTZlNjNjYmEwMCAxMDA2NDQNCj4g
LS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VuL3hzay90eC5j
DQo+ICsrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lbi94c2sv
dHguYw0KPiBAQCAtNjEsNiArNjEsNyBAQCBib29sIG1seDVlX3hza190eChzdHJ1Y3QgbWx4NWVf
eGRwc3EgKnNxLCB1bnNpZ25lZCBpbnQgYnVkZ2V0KQ0KPiAgIAlzdHJ1Y3QgbWx4NWVfeGRwX3ht
aXRfZGF0YSB4ZHB0eGQ7DQo+ICAgCWJvb2wgd29ya19kb25lID0gdHJ1ZTsNCj4gICAJYm9vbCBm
bHVzaCA9IGZhbHNlOw0KPiArCXU2NCBhZGRyLCBvZmZzZXQ7DQo+ICAgDQo+ICAgCXhkcGkubW9k
ZSA9IE1MWDVFX1hEUF9YTUlUX01PREVfWFNLOw0KPiAgIA0KPiBAQCAtODIsOCArODMsMTIgQEAg
Ym9vbCBtbHg1ZV94c2tfdHgoc3RydWN0IG1seDVlX3hkcHNxICpzcSwgdW5zaWduZWQgaW50IGJ1
ZGdldCkNCj4gICAJCQlicmVhazsNCj4gICAJCX0NCj4gICANCj4gLQkJeGRwdHhkLmRtYV9hZGRy
ID0geGRwX3VtZW1fZ2V0X2RtYSh1bWVtLCBkZXNjLmFkZHIpOw0KPiAtCQl4ZHB0eGQuZGF0YSA9
IHhkcF91bWVtX2dldF9kYXRhKHVtZW0sIGRlc2MuYWRkcik7DQo+ICsJCS8qIGZvciB1bmFsaWdu
ZWQgY2h1bmtzIG5lZWQgdG8gdGFrZSBvZmZzZXQgZnJvbSB1cHBlciBiaXRzICovDQo+ICsJCW9m
ZnNldCA9IChkZXNjLmFkZHIgPj4gWFNLX1VOQUxJR05FRF9CVUZfT0ZGU0VUX1NISUZUKTsNCj4g
KwkJYWRkciA9IChkZXNjLmFkZHIgJiBYU0tfVU5BTElHTkVEX0JVRl9BRERSX01BU0spOw0KPiAr
DQo+ICsJCXhkcHR4ZC5kbWFfYWRkciA9IHhkcF91bWVtX2dldF9kbWEodW1lbSwgYWRkciArIG9m
ZnNldCk7DQo+ICsJCXhkcHR4ZC5kYXRhID0geGRwX3VtZW1fZ2V0X2RhdGEodW1lbSwgYWRkciAr
IG9mZnNldCk7DQoNCldoeSBjYW4ndCB0aGVzZSBjYWxjdWxhdGlvbnMgYmUgZW5jYXBzdWxhdGVk
IGludG8gDQp4ZHBfdW1lbV9nZXRfe2RtYSxkYXRhfT8gSSB0aGluayB0aGV5IGFyZSBjb21tb24g
Zm9yIGFsbCBkcml2ZXJzLCBhcmVuJ3QgDQp0aGV5Pw0KDQpFdmVuIGlmIHRoZXJlIGlzIHNvbWUg
cmVhc29uIG5vdCB0byBwdXQgdGhpcyBiaXRzaGlmdGluZyBzdHVmZiBpbnRvIA0KeGRwX3VtZW1f
Z2V0XyogZnVuY3Rpb25zLCBJIHN1Z2dlc3QgdG8gZW5jYXBzdWxhdGUgaXQgaW50byBhIGZ1bmN0
aW9uIA0KYW55d2F5LCBiZWNhdXNlIGl0J3MgYSBnb29kIGlkZWEgdG8ga2VlcCB0aG9zZSBjYWxj
dWxhdGlvbnMgaW4gYSBzaW5nbGUgDQpwbGFjZS4NCg0KPiAgIAkJeGRwdHhkLmxlbiA9IGRlc2Mu
bGVuOw0KPiAgIA0KPiAgIAkJZG1hX3N5bmNfc2luZ2xlX2Zvcl9kZXZpY2Uoc3EtPnBkZXYsIHhk
cHR4ZC5kbWFfYWRkciwNCj4gDQoNCg==
