Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5782F7D8FE
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 12:05:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727455AbfHAKFc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 06:05:32 -0400
Received: from mail-eopbgr60042.outbound.protection.outlook.com ([40.107.6.42]:14405
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725379AbfHAKFc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Aug 2019 06:05:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mYs7SuWbPxB21lO9VCtpilMsOk1qKUh9jbtdzh3tNXpwGy0g9kHUBeoFZUzKiEVKLtOUy9f8CSzDKEpnKSI7uzhD5o73bb32Lh/VcC3uln1FMBXBJymcEA86mU5vDq3HUufQ0NtAdGWNgeI0oNVJY8A56tDX4f9Anu+UiLht5WN/Ef4hMqKH6lMf1MWfrcuXMNOKmcteV4E6fVGOxJK7lpQQKTP+wHMWBBHoMft0FMTnNdOY/7wWC9/+dbc8F58jHXwur041KKleU6sYdoXsdve5VdaSkkXT0xzAN06Qd5xJK49iZISkFditAuvPuSj/E5U/1ITym5YSXLRXDcp5zA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xTNawMYGdQ6CSMwymQP4AgWJwhL/JwH8bPNo7dL+Q3E=;
 b=HxOzdo2qEJYGIedJCoG4Y9dWM3N1M138msAerRdL3P9Gtzf3UHv7OSCEjWBOM4zpK4YT+7Y8vkAh42JZVsSDueFjU5UrGkGMTcB8hSOWLDAk34RUwrJwnk5w5rF57Tv58jbPNh6yApoxlIzyA8wx3RwUVthOwAEhhJuLSdvd0tEOlT+i4IOUNd4P/yKcteWmaebOMIYDtCx72fGhzNJ/+XYncta13rBR7cMUi9IGqgBmvRfbi+VNBgkovHctipdynbHWqnZDo0PLGK8ditc+co0M9+UiPr7xtokBpC6k9Xb+LY3Us3Vy0f26OCdjxoquweYWMDMlXHpr+HsFUxWmyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=mellanox.com;dmarc=pass action=none
 header.from=mellanox.com;dkim=pass header.d=mellanox.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xTNawMYGdQ6CSMwymQP4AgWJwhL/JwH8bPNo7dL+Q3E=;
 b=eSb/elf1krvqHY1zZ4689bzSJxJErmSEftUVisuQaQ0FeXeGzXoxauFsPkO4XT8W0oKDc7h7239xskiTzoWQSjA6MfJaktVpYH7/A7hywELiMF745yQzpV04FN73BGMSnQgU1P8+aJCM7XkVfHJBKOsk0ASjhdPAP3ktmE3F/kY=
Received: from AM6PR05MB5879.eurprd05.prod.outlook.com (20.179.0.76) by
 AM6PR05MB4359.eurprd05.prod.outlook.com (52.135.162.24) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2136.14; Thu, 1 Aug 2019 10:05:27 +0000
Received: from AM6PR05MB5879.eurprd05.prod.outlook.com
 ([fe80::f9d8:38bc:4a18:f7a7]) by AM6PR05MB5879.eurprd05.prod.outlook.com
 ([fe80::f9d8:38bc:4a18:f7a7%5]) with mapi id 15.20.2136.010; Thu, 1 Aug 2019
 10:05:27 +0000
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
Subject: Re: [PATCH bpf-next v4 07/11] mlx5e: modify driver for handling
 offsets
Thread-Topic: [PATCH bpf-next v4 07/11] mlx5e: modify driver for handling
 offsets
Thread-Index: AQHVRvmgKn88Wbidmk6f2JCe6+KPYqbmE0MA
Date:   Thu, 1 Aug 2019 10:05:26 +0000
Message-ID: <bc0c966f-4cda-4d48-566f-f5bff376210a@mellanox.com>
References: <20190724051043.14348-1-kevin.laatz@intel.com>
 <20190730085400.10376-1-kevin.laatz@intel.com>
 <20190730085400.10376-8-kevin.laatz@intel.com>
In-Reply-To: <20190730085400.10376-8-kevin.laatz@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BYAPR07CA0072.namprd07.prod.outlook.com
 (2603:10b6:a03:60::49) To AM6PR05MB5879.eurprd05.prod.outlook.com
 (2603:10a6:20b:a2::12)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=maximmi@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [159.224.90.213]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e056a4aa-b56f-4f21-d59d-08d71667c6aa
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM6PR05MB4359;
x-ms-traffictypediagnostic: AM6PR05MB4359:
x-microsoft-antispam-prvs: <AM6PR05MB4359B8D2AB3F436896950BBED1DE0@AM6PR05MB4359.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 01165471DB
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(39860400002)(366004)(136003)(396003)(346002)(199004)(189003)(14444005)(2616005)(14454004)(256004)(66066001)(3846002)(71190400001)(71200400001)(6116002)(7416002)(2906002)(478600001)(26005)(66446008)(54906003)(31686004)(5660300002)(102836004)(99286004)(76176011)(4326008)(55236004)(6916009)(53546011)(6506007)(386003)(486006)(31696002)(66556008)(11346002)(446003)(68736007)(52116002)(36756003)(66946007)(316002)(64756008)(66476007)(186003)(305945005)(81156014)(81166006)(8676002)(53936002)(6436002)(6512007)(6246003)(229853002)(25786009)(6486002)(8936002)(7736002)(476003)(86362001)(32563001);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR05MB4359;H:AM6PR05MB5879.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: R9y657i46MdluXDMjqVfvKa2iTwKyWFaqpT7UaK3X0kY0ecPltpVECGvbGvayv1CGIkwhx0Fq1RuDWJGlz9bJn06Yauw2mVVKSAEbwuZ15CI0AxRKZ8GMh2i8b2VM/qcJhiM6Sw3+gszwI69lXoy67fqMFgJUZ33Egg9dpiBpUcKoQc2+M7ZlGk8L0zCIDjcaKBTKxVqDRrUqdAPPjao2TOwUuKbCacahT9hHfeWZ3bPerNKAgxlhAIAgJLhnl5JRhTPfA0rflu5pKHwQqhLYs/rT1na/xFnfspj8lcPE4VV1qdW861JFUkq5oVIA+qcQKjtRSsLvBcSQpjhL5X2qAjpGnyQoaok4fFczRJ5J+xptgbR8nTKI3FaMCuNkD1tH1ikbTHYP6oOGN8ytSIWH9eDL2m7EaiDwfb3fz9OoqE=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1441168375696F4A960D0E2344B17815@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e056a4aa-b56f-4f21-d59d-08d71667c6aa
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Aug 2019 10:05:26.8740
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: maximmi@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB4359
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMjAxOS0wNy0zMCAxMTo1MywgS2V2aW4gTGFhdHogd3JvdGU6DQo+IFdpdGggdGhlIGFkZGl0
aW9uIG9mIHRoZSB1bmFsaWduZWQgY2h1bmtzIG9wdGlvbiwgd2UgbmVlZCB0byBtYWtlIHN1cmUg
d2UNCj4gaGFuZGxlIHRoZSBvZmZzZXRzIGFjY29yZGluZ2x5IGJhc2VkIG9uIHRoZSBtb2RlIHdl
IGFyZSBjdXJyZW50bHkgcnVubmluZw0KPiBpbi4gVGhpcyBwYXRjaCBtb2RpZmllcyB0aGUgZHJp
dmVyIHRvIGFwcHJvcHJpYXRlbHkgbWFzayB0aGUgYWRkcmVzcyBmb3INCj4gZWFjaCBjYXNlLg0K
PiANCj4gU2lnbmVkLW9mZi1ieTogS2V2aW4gTGFhdHogPGtldmluLmxhYXR6QGludGVsLmNvbT4N
Cg0KUGxlYXNlIG5vdGUgdGhhdCB0aGlzIHBhdGNoIGRvZXNuJ3QgYWN0dWFsbHkgYWRkIHRoZSBz
dXBwb3J0IGZvciB0aGUgbmV3IA0KZmVhdHVyZSwgYmVjYXVzZSB0aGUgdmFsaWRhdGlvbiBjaGVj
a3MgaW4gbWx4NWVfcnhfZ2V0X2xpbmVhcl9mcmFnX3N6IA0KYW5kIG1seDVlX3ZhbGlkYXRlX3hz
a19wYXJhbSBuZWVkIHRvIGJlIHJlbGF4ZWQuIEN1cnJlbnRseSB0aGUgZnJhbWUgDQpzaXplIG9m
IFBBR0VfU0laRSBpcyBmb3JjZWQsIGFuZCB0aGUgZnJhZ21lbnQgc2l6ZSBpcyBpbmNyZWFzZWQg
dG8gDQpQQUdFX1NJWkUgaW4gY2FzZSBvZiBYRFAgKGluY2x1ZGluZyBYU0spLg0KDQpBZnRlciBt
YWtpbmcgdGhlIGNoYW5nZXMgcmVxdWlyZWQgdG8gcGVybWl0IGZyYW1lIHNpemVzIHNtYWxsZXIg
dGhhbiANClBBR0VfU0laRSwgb3VyIFN0cmlkaW5nIFJRIGZlYXR1cmUgd2lsbCBiZSB1c2VkIGlu
IGEgd2F5IHdlIGhhdmVuJ3QgdXNlZCANCml0IGJlZm9yZSwgc28gd2UgbmVlZCB0byB2ZXJpZnkg
d2l0aCB0aGUgaGFyZHdhcmUgdGVhbSB0aGF0IHRoaXMgdXNhZ2UgDQppcyBsZWdpdGltYXRlLg0K
DQo+IC0tLQ0KPiB2MzoNCj4gICAgLSBVc2UgbmV3IGhlbHBlciBmdW5jdGlvbiB0byBoYW5kbGUg
b2Zmc2V0DQo+IA0KPiB2NDoNCj4gICAgLSBmaXhlZCBoZWFkcm9vbSBhZGRpdGlvbiB0byBoYW5k
bGUuIFVzaW5nIHhza191bWVtX2FkanVzdF9oZWFkcm9vbSgpDQo+ICAgICAgbm93Lg0KPiAtLS0N
Cj4gICBkcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW4veGRwLmMgICAg
fCA4ICsrKysrKy0tDQo+ICAgZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3Jl
L2VuL3hzay9yeC5jIHwgMyArKy0NCj4gICAyIGZpbGVzIGNoYW5nZWQsIDggaW5zZXJ0aW9ucygr
KSwgMyBkZWxldGlvbnMoLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5l
dC9tZWxsYW5veC9tbHg1L2NvcmUvZW4veGRwLmMgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxs
YW5veC9tbHg1L2NvcmUvZW4veGRwLmMNCj4gaW5kZXggYjBiOTgyY2Y2OWJiLi5kNTI0NTg5M2Qy
YzggMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29y
ZS9lbi94ZHAuYw0KPiArKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2Nv
cmUvZW4veGRwLmMNCj4gQEAgLTEyMiw2ICsxMjIsNyBAQCBib29sIG1seDVlX3hkcF9oYW5kbGUo
c3RydWN0IG1seDVlX3JxICpycSwgc3RydWN0IG1seDVlX2RtYV9pbmZvICpkaSwNCj4gICAJCSAg
ICAgIHZvaWQgKnZhLCB1MTYgKnJ4X2hlYWRyb29tLCB1MzIgKmxlbiwgYm9vbCB4c2spDQo+ICAg
ew0KPiAgIAlzdHJ1Y3QgYnBmX3Byb2cgKnByb2cgPSBSRUFEX09OQ0UocnEtPnhkcF9wcm9nKTsN
Cj4gKwlzdHJ1Y3QgeGRwX3VtZW0gKnVtZW0gPSBycS0+dW1lbTsNCj4gICAJc3RydWN0IHhkcF9i
dWZmIHhkcDsNCj4gICAJdTMyIGFjdDsNCj4gICAJaW50IGVycjsNCj4gQEAgLTEzOCw4ICsxMzks
MTEgQEAgYm9vbCBtbHg1ZV94ZHBfaGFuZGxlKHN0cnVjdCBtbHg1ZV9ycSAqcnEsIHN0cnVjdCBt
bHg1ZV9kbWFfaW5mbyAqZGksDQo+ICAgCXhkcC5yeHEgPSAmcnEtPnhkcF9yeHE7DQo+ICAgDQo+
ICAgCWFjdCA9IGJwZl9wcm9nX3J1bl94ZHAocHJvZywgJnhkcCk7DQo+IC0JaWYgKHhzaykNCj4g
LQkJeGRwLmhhbmRsZSArPSB4ZHAuZGF0YSAtIHhkcC5kYXRhX2hhcmRfc3RhcnQ7DQo+ICsJaWYg
KHhzaykgew0KPiArCQl1NjQgb2ZmID0geGRwLmRhdGEgLSB4ZHAuZGF0YV9oYXJkX3N0YXJ0Ow0K
PiArDQo+ICsJCXhkcC5oYW5kbGUgPSB4c2tfdW1lbV9oYW5kbGVfb2Zmc2V0KHVtZW0sIHhkcC5o
YW5kbGUsIG9mZik7DQo+ICsJfQ0KPiAgIAlzd2l0Y2ggKGFjdCkgew0KPiAgIAljYXNlIFhEUF9Q
QVNTOg0KPiAgIAkJKnJ4X2hlYWRyb29tID0geGRwLmRhdGEgLSB4ZHAuZGF0YV9oYXJkX3N0YXJ0
Ow0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3Jl
L2VuL3hzay9yeC5jIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2Vu
L3hzay9yeC5jDQo+IGluZGV4IDZhNTU1NzNlYzhmMi4uN2M0OWE2NmQyOGM5IDEwMDY0NA0KPiAt
LS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW4veHNrL3J4LmMN
Cj4gKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VuL3hzay9y
eC5jDQo+IEBAIC0yNCw3ICsyNCw4IEBAIGludCBtbHg1ZV94c2tfcGFnZV9hbGxvY191bWVtKHN0
cnVjdCBtbHg1ZV9ycSAqcnEsDQo+ICAgCWlmICgheHNrX3VtZW1fcGVla19hZGRyX3JxKHVtZW0s
ICZoYW5kbGUpKQ0KPiAgIAkJcmV0dXJuIC1FTk9NRU07DQo+ICAgDQo+IC0JZG1hX2luZm8tPnhz
ay5oYW5kbGUgPSBoYW5kbGUgKyBycS0+YnVmZi51bWVtX2hlYWRyb29tOw0KPiArCWRtYV9pbmZv
LT54c2suaGFuZGxlID0geHNrX3VtZW1fYWRqdXN0X29mZnNldCh1bWVtLCBoYW5kbGUsDQo+ICsJ
CQkJCQkgICAgICBycS0+YnVmZi51bWVtX2hlYWRyb29tKTsNCj4gICAJZG1hX2luZm8tPnhzay5k
YXRhID0geGRwX3VtZW1fZ2V0X2RhdGEodW1lbSwgZG1hX2luZm8tPnhzay5oYW5kbGUpOw0KPiAg
IA0KPiAgIAkvKiBObyBuZWVkIHRvIGFkZCBoZWFkcm9vbSB0byB0aGUgRE1BIGFkZHJlc3MuIElu
IHN0cmlkaW5nIFJRIGNhc2UsIHdlDQo+IA0KDQo=
