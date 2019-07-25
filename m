Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35A2874B33
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 12:08:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729800AbfGYKIb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 06:08:31 -0400
Received: from mail-eopbgr30062.outbound.protection.outlook.com ([40.107.3.62]:6798
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727519AbfGYKIb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Jul 2019 06:08:31 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VtXVItcQHfbVhL5Wi7hdtnHzA4zkn6PLVx5GKgix+YvWloCo1vAKsWvCOOMFGNqV6UjtjQ/yWq0DaM9dhMNSNJwixsxdS4iWyeJLP4wZZER8WuAgDP6OKyrK38hYtEYQbEelzfyIXzS3cjjKR4dtIZ5G9s3cxH7ehYTG5Bd6kf6ow615qSfD9Jm2H6GMlzcoHJFPxW/ucop+/74MbzbZc08ijszsvwrCUqWLH5IXs5gNfWWobeFMO/fxyLKORZBZ//Y7gpKr+r26XUEnLxJVb6oOvyvmjGTpZc9LA69erGyYXDTX7rJjodhLAnqUIB/NmxLldgAEXZx3iyUHE1J+2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PTNhFr9dJLIlK/cGncRUaE7IGVacxqUNqPuR8QQUIAs=;
 b=CADPglpcSYBjlL6hmjj+wXXlv1p/bujtlNu3eub9maYBHQ+B93EzfFDaMvsUo8ZvPRNS254gesFxNHYos0gCp9GKfnGPLJlEL/TlusJJJPAzefJOjJIWlTdIWglnIcyx4Et3XaN1/zWE+2a+jTnBVaGvGqdsuxNUmnz9V2EAY1Vijhao1VfS6S2uqa4aI6RGzgjCspXYeIvR12A5U3pVsDpYDLdurVPt0GgI2Wcp7dF0YPAVQ5S+NR0UXShdMPVTcsd2JqtDt4ucs3Y/qwdBkCmFoN+p5AgR/a6XHlATFrRgko5UFYZivXoRu5DlmGQ0RqXrpnRAq9TxqYCgq/EYIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=mellanox.com;dmarc=pass action=none
 header.from=mellanox.com;dkim=pass header.d=mellanox.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PTNhFr9dJLIlK/cGncRUaE7IGVacxqUNqPuR8QQUIAs=;
 b=j5FgmVVxBhKEXT/6aSdcrMh+gA3zs42vPBe+HWjSWS4rUzriXt2AMQt0zcLdVdvS6tFngq4oT/hulw1aGeF03fuzA0HKG+KQVkfEVI2jdGFA316nAN360O1Ra5agu0wyIESb+nuuM/m+EGrOVTACbZILvfK0Hkp4WxViHR40RJU=
Received: from AM6PR05MB5879.eurprd05.prod.outlook.com (20.179.0.76) by
 AM6PR05MB6006.eurprd05.prod.outlook.com (20.179.1.220) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2094.16; Thu, 25 Jul 2019 10:08:25 +0000
Received: from AM6PR05MB5879.eurprd05.prod.outlook.com
 ([fe80::f9d8:38bc:4a18:f7a7]) by AM6PR05MB5879.eurprd05.prod.outlook.com
 ([fe80::f9d8:38bc:4a18:f7a7%5]) with mapi id 15.20.2115.005; Thu, 25 Jul 2019
 10:08:25 +0000
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
Subject: Re: [PATCH bpf-next v3 03/11] xsk: add support to allow unaligned
 chunk placement
Thread-Topic: [PATCH bpf-next v3 03/11] xsk: add support to allow unaligned
 chunk placement
Thread-Index: AQHVQiNkTVSHyKuk+0Kz8FHigNGopqbbHX4A
Date:   Thu, 25 Jul 2019 10:08:25 +0000
Message-ID: <c3159739-2483-b2d8-541f-6f6611a782e1@mellanox.com>
References: <20190716030637.5634-1-kevin.laatz@intel.com>
 <20190724051043.14348-1-kevin.laatz@intel.com>
 <20190724051043.14348-4-kevin.laatz@intel.com>
In-Reply-To: <20190724051043.14348-4-kevin.laatz@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: HE1PR0902CA0005.eurprd09.prod.outlook.com
 (2603:10a6:3:e5::15) To AM6PR05MB5879.eurprd05.prod.outlook.com
 (2603:10a6:20b:a2::12)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=maximmi@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [159.224.90.213]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7cd98e16-b59d-475e-0ed9-08d710e8083f
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM6PR05MB6006;
x-ms-traffictypediagnostic: AM6PR05MB6006:
x-microsoft-antispam-prvs: <AM6PR05MB6006477F5FE4D67595A3AF61D1C10@AM6PR05MB6006.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0109D382B0
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(39860400002)(346002)(396003)(376002)(136003)(199004)(189003)(36756003)(7736002)(11346002)(81166006)(31686004)(6116002)(446003)(2616005)(71190400001)(476003)(53936002)(71200400001)(3846002)(25786009)(26005)(6436002)(478600001)(81156014)(8676002)(186003)(6916009)(305945005)(6512007)(66556008)(7416002)(102836004)(55236004)(53546011)(8936002)(76176011)(52116002)(386003)(66066001)(99286004)(6486002)(486006)(256004)(14444005)(2906002)(31696002)(14454004)(4326008)(66446008)(66476007)(64756008)(229853002)(6246003)(66946007)(5660300002)(68736007)(316002)(6506007)(54906003)(86362001);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR05MB6006;H:AM6PR05MB5879.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Uxv2PolQVAnSC1eU03jCxlJoT+bggboP6Gvpkz2JRhqmqpw6xaRgPrDB6EdEOrs7OSRjMwmzmmTI0ILc5Bb8O7NBjAwuR7Y5eVLlpQRLrI55qz7Zxt7opoLAGhE8AaljxLP4Bsb8RivX4K55xwD+cWNvLOfGEXKoOwRMa6SDwlV/QcUiQaCJGBuXG5vRMYl028DxkmRYaTlNGCCED66yOC4g6rvMAnPO+oZv94mBomu0RjlFPy+Dd2Ty8kGY4OPMAzDW93gbj0HezXaNG4fOZ2Ni9WWH1Pr3gYJ+3OG7GYhSyyKOGxIjvMbRbbfsOwP373PgLOOsOnC3vogx86GFuXnGuwoUIjfO4TQ0g19kyZGRL4Svhf1UlVvbwJyIcOJQOV9pJlIV4SRB03YDxLNPisVCOY3icLnX8gcYciQIWMo=
Content-Type: text/plain; charset="utf-8"
Content-ID: <91C4EAA889185746BE1F5CC56DC7F481@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7cd98e16-b59d-475e-0ed9-08d710e8083f
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jul 2019 10:08:25.3901
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: maximmi@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB6006
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMjAxOS0wNy0yNCAwODoxMCwgS2V2aW4gTGFhdHogd3JvdGU6DQo+IEN1cnJlbnRseSwgYWRk
cmVzc2VzIGFyZSBjaHVuayBzaXplIGFsaWduZWQuIFRoaXMgbWVhbnMsIHdlIGFyZSB2ZXJ5DQo+
IHJlc3RyaWN0ZWQgaW4gdGVybXMgb2Ygd2hlcmUgd2UgY2FuIHBsYWNlIGNodW5rIHdpdGhpbiB0
aGUgdW1lbS4gRm9yDQo+IGV4YW1wbGUsIGlmIHdlIGhhdmUgYSBjaHVuayBzaXplIG9mIDJrLCB0
aGVuIG91ciBjaHVua3MgY2FuIG9ubHkgYmUgcGxhY2VkDQo+IGF0IDAsMmssNGssNmssOGsuLi4g
YW5kIHNvIG9uIChpZS4gZXZlcnkgMmsgc3RhcnRpbmcgZnJvbSAwKS4NCj4gDQo+IFRoaXMgcGF0
Y2ggaW50cm9kdWNlcyB0aGUgYWJpbGl0eSB0byB1c2UgdW5hbGlnbmVkIGNodW5rcy4gV2l0aCB0
aGVzZQ0KPiBjaGFuZ2VzLCB3ZSBhcmUgbm8gbG9uZ2VyIGJvdW5kIHRvIGhhdmluZyB0byBwbGFj
ZSBjaHVua3MgYXQgYSAyayAob3INCj4gd2hhdGV2ZXIgeW91ciBjaHVuayBzaXplIGlzKSBpbnRl
cnZhbC4gU2luY2Ugd2UgYXJlIG5vIGxvbmdlciBkZWFsaW5nIHdpdGgNCj4gYWxpZ25lZCBjaHVu
a3MsIHRoZXkgY2FuIG5vdyBjcm9zcyBwYWdlIGJvdW5kYXJpZXMuIENoZWNrcyBmb3IgcGFnZQ0K
PiBjb250aWd1aXR5IGhhdmUgYmVlbiBhZGRlZCBpbiBvcmRlciB0byBrZWVwIHRyYWNrIG9mIHdo
aWNoIHBhZ2VzIGFyZQ0KPiBmb2xsb3dlZCBieSBhIHBoeXNpY2FsbHkgY29udGlndW91cyBwYWdl
Lg0KPiANCj4gU2lnbmVkLW9mZi1ieTogS2V2aW4gTGFhdHogPGtldmluLmxhYXR6QGludGVsLmNv
bT4NCj4gU2lnbmVkLW9mZi1ieTogQ2lhcmEgTG9mdHVzIDxjaWFyYS5sb2Z0dXNAaW50ZWwuY29t
Pg0KPiBTaWduZWQtb2ZmLWJ5OiBCcnVjZSBSaWNoYXJkc29uIDxicnVjZS5yaWNoYXJkc29uQGlu
dGVsLmNvbT4NCj4gDQo+IC0tLQ0KPiB2MjoNCj4gICAgLSBBZGQgY2hlY2tzIGZvciB0aGUgZmxh
Z3MgY29taW5nIGZyb20gdXNlcnNwYWNlDQo+ICAgIC0gRml4IGhvdyB3ZSBnZXQgY2h1bmtfc2l6
ZSBpbiB4c2tfZGlhZy5jDQo+ICAgIC0gQWRkIGRlZmluZXMgZm9yIG1hc2tpbmcgdGhlIG5ldyBk
ZXNjcmlwdG9yIGZvcm1hdA0KPiAgICAtIE1vZGlmaWVkIHRoZSByeCBmdW5jdGlvbnMgdG8gdXNl
IG5ldyBkZXNjcmlwdG9yIGZvcm1hdA0KPiAgICAtIE1vZGlmaWVkIHRoZSB0eCBmdW5jdGlvbnMg
dG8gdXNlIG5ldyBkZXNjcmlwdG9yIGZvcm1hdA0KPiANCj4gdjM6DQo+ICAgIC0gQWRkIGhlbHBl
ciBmdW5jdGlvbiB0byBkbyBhZGRyZXNzL29mZnNldCBtYXNraW5nL2FkZGl0aW9uDQo+IC0tLQ0K
PiAgIGluY2x1ZGUvbmV0L3hkcF9zb2NrLmggICAgICB8IDE3ICsrKysrKysrDQo+ICAgaW5jbHVk
ZS91YXBpL2xpbnV4L2lmX3hkcC5oIHwgIDkgKysrKw0KPiAgIG5ldC94ZHAveGRwX3VtZW0uYyAg
ICAgICAgICB8IDE4ICsrKysrLS0tDQo+ICAgbmV0L3hkcC94c2suYyAgICAgICAgICAgICAgIHwg
ODYgKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrLS0tLS0tLQ0KPiAgIG5ldC94ZHAveHNr
X2RpYWcuYyAgICAgICAgICB8ICAyICstDQo+ICAgbmV0L3hkcC94c2tfcXVldWUuaCAgICAgICAg
IHwgNjggKysrKysrKysrKysrKysrKysrKysrKysrKy0tLS0NCj4gICA2IGZpbGVzIGNoYW5nZWQs
IDE3MCBpbnNlcnRpb25zKCspLCAzMCBkZWxldGlvbnMoLSkNCg0KPC4uLj4NCg0KPiArDQo+ICtz
dGF0aWMgaW5saW5lIHU2NCB4c2tfdW1lbV9oYW5kbGVfb2Zmc2V0KHN0cnVjdCB4ZHBfdW1lbSAq
dW1lbSwgdTY0IGhhbmRsZSwNCj4gKwkJCQkJIHU2NCBvZmZzZXQpDQo+ICt7DQo+ICsJaWYgKHVt
ZW0tPmZsYWdzICYgWERQX1VNRU1fVU5BTElHTkVEX0NIVU5LUykNCj4gKwkJcmV0dXJuIGhhbmRs
ZSB8PSAob2Zmc2V0IDw8IFhTS19VTkFMSUdORURfQlVGX09GRlNFVF9TSElGVCk7DQo+ICsJZWxz
ZQ0KPiArCQlyZXR1cm4gaGFuZGxlICs9IG9mZnNldDsNCj4gK30NCg0KfD0gYW5kICs9IGFyZSBu
b3QgbmVjZXNzYXJ5IGhlcmUsIHwgYW5kICsgYXJlIGVub3VnaC4NCg0KSW4gdGhlIHVuYWxpZ25l
ZCBtb2RlLCBpdCdzIG5vdCBzdXBwb3J0ZWQgdG8gcnVuIHhza191bWVtX2hhbmRsZV9vZmZzZXQg
DQptdWx0aXBsZSB0aW1lcywgYW5kIGl0J3MgYXNzdW1lZCB0aGF0IG9mZnNldCBpcyB6ZXJvLiBJ
J2xsIGV4cGxhaW4gdGhlIA0KbmVlZCBpbiBteSBmb2xsb3dpbmcgY29tbWVudCB0byBwYXRjaCA2
Lg0KDQo8Li4uPg0K
