Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 737C1749D7
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 11:27:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390476AbfGYJ1M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 05:27:12 -0400
Received: from mail-eopbgr30063.outbound.protection.outlook.com ([40.107.3.63]:35150
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2389918AbfGYJ1L (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Jul 2019 05:27:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SilBkdzf0V/rK87jk6apEsoiqROZplAF726e1DW1KhnpIvYU/YJWM12+7qgq69m4f8E4pvtn26l6nV2a1ZJ8atPkazK5qdKA0c5BMUPdVE/Evs1W0jYZj3Hw8H4EdxTWmHOo3SMx8gWny/eNE05lihFjKqAilS2QMc+9tHsQDQCNjp8FY1Zd6pkkPfx0vd4jYj69U/6jLwywRJsqhkr4pFecH6kA1rZJdw+kCvKftCyO0d4MO+sIsQGBelJuTqFJ+Eok+zB2v2MmpMZtXyV1LMV3NeMOd+lrzLEToP8X/cUKlA+OS3QxD5cQvJ38nrzcqNta7Oi/WTUN/BuTBjoC5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oa4BL+pcH746unMKbd8VaveHRzvluUZVech+tPJYXCw=;
 b=CNl7uGwvEmioRe6AzSJUV0dJ70Pd29DvLAzLLCzle5Z63Nte2B0eGCfGPlBD90VvSZYtOSMaKxeYWiXUuIcN2Hn/6S9hjA6+nEfT07g+/VXixiuYy6Ls1xw+w3a87xgT7UnYN9cE/tRGOQQbsYg19Zu9C3KFhmHDMoIwqmILpy56KD3YrGpFRZhfBKjq9Q6FJHeK+h5w9eaC3WMnnv2KB+Y7KHyZ7g+OPxsPwYD2xiRy0pPT0Hon6yIPtj8bw9zg6vdCtiXf6bUpLWNEr+nqjNSYFN5Pq/CxmdkcHOZpTVGp7zgKMPzJuKKsQ5QdTkxtb6G32YBg+CWj8w89aNci+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=mellanox.com;dmarc=pass action=none
 header.from=mellanox.com;dkim=pass header.d=mellanox.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oa4BL+pcH746unMKbd8VaveHRzvluUZVech+tPJYXCw=;
 b=qwY2ZKM1UGxRjEdVDWrg/GgvwqQEaGSyjOSL3h8bGVENdN4aFDOpy2nXu7DN4QwO6dx5on4EMeS3F1taiamq23OWCcYps2EznFhiTOiTh5fBhFHhHBC0X71QIpKx1e/ScufNgkWxRqffvuIzafTcGONr4dSmUmt+Q66w3hifSsU=
Received: from AM6PR05MB5879.eurprd05.prod.outlook.com (20.179.0.76) by
 AM6PR05MB6485.eurprd05.prod.outlook.com (20.179.7.84) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.10; Thu, 25 Jul 2019 09:27:05 +0000
Received: from AM6PR05MB5879.eurprd05.prod.outlook.com
 ([fe80::f9d8:38bc:4a18:f7a7]) by AM6PR05MB5879.eurprd05.prod.outlook.com
 ([fe80::f9d8:38bc:4a18:f7a7%5]) with mapi id 15.20.2115.005; Thu, 25 Jul 2019
 09:27:04 +0000
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
Thread-Index: AQHVQiNkTVSHyKuk+0Kz8FHigNGopqbbEeCA
Date:   Thu, 25 Jul 2019 09:27:04 +0000
Message-ID: <3af74e26-8899-cf1e-6fd4-5ea0bd349fc3@mellanox.com>
References: <20190716030637.5634-1-kevin.laatz@intel.com>
 <20190724051043.14348-1-kevin.laatz@intel.com>
 <20190724051043.14348-4-kevin.laatz@intel.com>
In-Reply-To: <20190724051043.14348-4-kevin.laatz@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR02CA0046.namprd02.prod.outlook.com
 (2603:10b6:301:60::35) To AM6PR05MB5879.eurprd05.prod.outlook.com
 (2603:10a6:20b:a2::12)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=maximmi@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [159.224.90.213]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5936d91e-7ae0-438a-856f-08d710e241b9
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM6PR05MB6485;
x-ms-traffictypediagnostic: AM6PR05MB6485:
x-microsoft-antispam-prvs: <AM6PR05MB64852181B6C4872E85F89838D1C10@AM6PR05MB6485.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 0109D382B0
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(346002)(39860400002)(396003)(376002)(136003)(199004)(189003)(86362001)(81166006)(31696002)(8936002)(81156014)(31686004)(53546011)(476003)(8676002)(5660300002)(71200400001)(71190400001)(305945005)(7736002)(25786009)(186003)(6506007)(6512007)(102836004)(26005)(6486002)(6436002)(446003)(486006)(7416002)(11346002)(2616005)(36756003)(68736007)(229853002)(6916009)(386003)(14454004)(316002)(54906003)(64756008)(66946007)(66446008)(478600001)(4326008)(76176011)(52116002)(53936002)(66556008)(66476007)(3846002)(2906002)(66066001)(6246003)(256004)(6116002)(14444005)(99286004)(55236004);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR05MB6485;H:AM6PR05MB5879.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: trrKJJwlLZ6u7pnk6a1f+OWk48aUOhYX3MA1L+6bPMKHCXrgJzuU238I0VKuqN4B8y3VelNfRYBtK0aR0fb0NWQAYkCZqJ6CQIrpERkOYwb5O4qBR1HoRENvKLpOyQPhMiqfV7l/JVG/WrgNw5fzZoPh7O9yzp4UFvaYOH3NuSlznbulup3vDgPHqrx1HO1DeJNDLSwYD//zwMG5RfwiqNN/67zafJ7GU0Ilm5+BcCzB+9knBOl5vqzFsJ08lKoQEecl5XqDA2JaPmGvGJRTrjQxQQK23DI3AABdeOSQaop+XFMLNUmp6udt04iSDv1GnlraN4IkjfrpdT2cbGgdwP95zw2oDn+dT0+TgeTFoPsx9o9ui0yOhk8xaliS3vvzGEOC+cLpeqGnabhbfgVPkKxqrIHYayM30PA79st8H34=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B955B27B48288945A8CFA897782DE75C@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5936d91e-7ae0-438a-856f-08d710e241b9
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jul 2019 09:27:04.8544
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: maximmi@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB6485
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
IDE3MCBpbnNlcnRpb25zKCspLCAzMCBkZWxldGlvbnMoLSkNCj4gDQoNCjwuLi4+DQoNCj4gKy8q
IElmIGEgYnVmZmVyIGNyb3NzZXMgYSBwYWdlIGJvdW5kYXJ5LCB3ZSBuZWVkIHRvIGRvIDIgbWVt
Y3B5J3MsIG9uZSBmb3INCj4gKyAqIGVhY2ggcGFnZS4gVGhpcyBpcyBvbmx5IHJlcXVpcmVkIGlu
IGNvcHkgbW9kZS4NCj4gKyAqLw0KPiArc3RhdGljIHZvaWQgX194c2tfcmN2X21lbWNweShzdHJ1
Y3QgeGRwX3VtZW0gKnVtZW0sIHU2NCBhZGRyLCB2b2lkICpmcm9tX2J1ZiwNCj4gKwkJCSAgICAg
dTMyIGxlbiwgdTMyIG1ldGFsZW4pDQo+ICt7DQo+ICsJdm9pZCAqdG9fYnVmID0geGRwX3VtZW1f
Z2V0X2RhdGEodW1lbSwgYWRkcik7DQo+ICsNCj4gKwlpZiAoeHNrcV9jcm9zc2VzX25vbl9jb250
aWdfcGcodW1lbSwgYWRkciwgbGVuICsgbWV0YWxlbikpIHsNCj4gKwkJdm9pZCAqbmV4dF9wZ19h
ZGRyID0gdW1lbS0+cGFnZXNbKGFkZHIgPj4gUEFHRV9TSElGVCkgKyAxXS5hZGRyOw0KPiArCQl1
NjQgcGFnZV9zdGFydCA9IGFkZHIgJiAoUEFHRV9TSVpFIC0gMSk7DQo+ICsJCXU2NCBmaXJzdF9s
ZW4gPSBQQUdFX1NJWkUgLSAoYWRkciAtIHBhZ2Vfc3RhcnQpOw0KDQpMZXQgYWRkciA9IDB4MTIz
NDUsIFBBR0VfU0laRSA9IDB4MTAwMCwgbGVuID0gMHgxMDAwLiBZb3VyIGNhbGN1bGF0aW9ucyAN
CmxlYWQgdG8gcGFnZV9zdGFydCA9IDB4MzQ1LCBmaXJzdF9sZW4gPSAweDEwMDAgLSAweDEyMDAw
LCB3aGljaCBpcyANCm5lZ2F0aXZlLiBJIHRoaW5rIHBhZ2Vfc3RhcnQgaXMgY2FsY3VsYXRlZCBp
bmNvcnJlY3RseSAoaXMgfiBtaXNzaW5nPykuDQoNCj4gKw0KPiArCQltZW1jcHkodG9fYnVmLCBm
cm9tX2J1ZiwgZmlyc3RfbGVuICsgbWV0YWxlbik7DQo+ICsJCW1lbWNweShuZXh0X3BnX2FkZHIs
IGZyb21fYnVmICsgZmlyc3RfbGVuLCBsZW4gLSBmaXJzdF9sZW4pOw0KPiArDQo+ICsJCXJldHVy
bjsNCj4gKwl9DQo+ICsNCj4gKwltZW1jcHkodG9fYnVmLCBmcm9tX2J1ZiwgbGVuICsgbWV0YWxl
bik7DQo+ICt9DQo+ICsNCg0KPC4uLj4NCg0KPiArc3RhdGljIGlubGluZSBib29sIHhza3FfaXNf
dmFsaWRfYWRkcl91bmFsaWduZWQoc3RydWN0IHhza19xdWV1ZSAqcSwgdTY0IGFkZHIsDQo+ICsJ
CQkJCQl1NjQgbGVuZ3RoLA0KPiArCQkJCQkJc3RydWN0IHhkcF91bWVtICp1bWVtKQ0KPiArew0K
PiArCWFkZHIgKz0gYWRkciA+PiBYU0tfVU5BTElHTkVEX0JVRl9PRkZTRVRfU0hJRlQ7DQo+ICsJ
YWRkciAmPSBYU0tfVU5BTElHTkVEX0JVRl9BRERSX01BU0s7DQo+ICsJaWYgKGFkZHIgPj0gcS0+
c2l6ZSB8fA0KDQpBZGRyZXNzZXMgbGlrZSAweDAwYWFmZmZmZmZmZmZmZmYgd2lsbCBwYXNzIHRo
ZSB2YWxpZGF0aW9uICgweGFhICsgDQoweGZmZmZmZmZmZmZmZiB3aWxsIG92ZXJmbG93IG1vZCAy
XjQ4IGFuZCBiZWNvbWUgYSBzbWFsbCBudW1iZXIpLCANCndoZXJlYXMgc3VjaCBhZGRyZXNzZXMg
ZG9uJ3QgbG9vayB2YWxpZCBmb3IgbWUuDQoNCj4gKwkgICAgeHNrcV9jcm9zc2VzX25vbl9jb250
aWdfcGcodW1lbSwgYWRkciwgbGVuZ3RoKSkgew0KDQpJZiB0aGUgcmVnaW9uIGlzIG5vdCBjb250
aWd1b3VzLCB3ZSBjYW50IFJYIGludG8gaXQgLSB0aGF0J3MgY2xlYXIuIA0KSG93ZXZlciwgaG93
IGNhbiB0aGUgdXNlcnNwYWNlIGRldGVybWluZSB3aGV0aGVyIHRoZXNlIHR3byBwYWdlcyBvZiBV
TUVNIA0KYXJlIG1hcHBlZCBjb250aWd1b3VzbHkgaW4gdGhlIERNQSBzcGFjZT8gQXJlIHdlIGdv
aW5nIHRvIHNpbGVudGx5IGRyb3AgDQpkZXNjcmlwdG9ycyB0byBub24tY29udGlndW91cyBmcmFt
ZXMgYW5kIGxlYWsgdGhlbT8gUGxlYXNlIGV4cGxhaW4gaG93IA0KdG8gdXNlIGl0IGNvcnJlY3Rs
eSBmcm9tIHRoZSBhcHBsaWNhdGlvbiBzaWRlLg0KDQo+ICsJCXEtPmludmFsaWRfZGVzY3MrKzsN
Cj4gKwkJcmV0dXJuIGZhbHNlOw0KPiArCX0NCj4gKw0KPiArCXJldHVybiB0cnVlOw0KPiArfQ0K
DQo8Li4uPg0KDQo=
