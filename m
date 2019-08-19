Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7736192700
	for <lists+netdev@lfdr.de>; Mon, 19 Aug 2019 16:36:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727570AbfHSOgH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 10:36:07 -0400
Received: from mail-eopbgr70042.outbound.protection.outlook.com ([40.107.7.42]:55872
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726654AbfHSOgG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Aug 2019 10:36:06 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JKYVCHq9PTe2XGxBMlEaFB3PM3hckhZxlRqDishbcx/b7WXyqXhWLLaJJaM6pWJFhO5sz4jjq2m8AhC1gaBsUcQFCFR01ORqxtGbOCiOLqxxvnv73QP/+4BP56q61Nl9RfqGhFjsaesRMagHUelvbDVdiGXlWBvuipXHIAuN7b14GlLEOwgoeaPqrKX5B3jjC7ytSK1CYEYG6261ali5qt+qRlaDBo7dKZ0l/nECVehDluVgyc5EZgq/HxD6b58XjzRgdErVEP+VgKWr/7HeJUzHdbLyoWtIYNSq4HkQcpnqW5OlDcZGz7A/xWGMclWuuuhuBSq9n0LKzFzKd5KrOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tRXeoOvvdqMqSV+VE+TNYvVZqbuIdtkzODa+ixeW4K0=;
 b=PlTsUUO0aaoMK3hLToP9uRRnBkOpWxJWpTEzZ3ufTJ32TUMU0tJ9F2mpKfyLzP2eR4h1QgmAftJP6DZeUUbEUP5mKjVz03YZO7AIkNU2gUgN0HcLAFTfg/oDd3yexviozdjBafykmItVqvFJB+1A+WpXO5shbdyT6eP/iIgwKmoTFPMcFTiqlEQGWoGN2b+Dgd0TBEb+oFYD2XrHvajRQ0Cai5GC8xeT3HOfjfohaNmIIjDfxI5e0VEaStLZIFmhoAKGk5biSL/SjVjtPd2OFGlamBuTypO2ypGtDm3bhceI1UbKr6LDT5kkGKMTrPr1IzbyiB3BHCP4G25J0w5LWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tRXeoOvvdqMqSV+VE+TNYvVZqbuIdtkzODa+ixeW4K0=;
 b=BCUG3zodDC6qmlMrpeuiF3QbCQwnWa6U8OS5az0XwGQygzUtw4yFpBnATfcu68wXZV0ZfKlEQYCUc/kISv4k9Vpztau7nzm7gDFUNr1RLCUD9ssJMCCXqocN2Fem2H7mvcji/YbOJtgRZQKtqhnffgxwO2p8YqoYHl0roQuSe/o=
Received: from AM6PR05MB5879.eurprd05.prod.outlook.com (20.179.0.76) by
 AM6PR05MB5989.eurprd05.prod.outlook.com (20.179.1.159) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.16; Mon, 19 Aug 2019 14:36:01 +0000
Received: from AM6PR05MB5879.eurprd05.prod.outlook.com
 ([fe80::f9d8:38bc:4a18:f7a7]) by AM6PR05MB5879.eurprd05.prod.outlook.com
 ([fe80::f9d8:38bc:4a18:f7a7%5]) with mapi id 15.20.2178.018; Mon, 19 Aug 2019
 14:36:01 +0000
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
Thread-Index: AQHVRvmgKn88Wbidmk6f2JCe6+KPYqbmE0MAgByVnYA=
Date:   Mon, 19 Aug 2019 14:36:01 +0000
Message-ID: <390f80fc-3f8a-a9ed-6ac7-8a1a41621559@mellanox.com>
References: <20190724051043.14348-1-kevin.laatz@intel.com>
 <20190730085400.10376-1-kevin.laatz@intel.com>
 <20190730085400.10376-8-kevin.laatz@intel.com>
 <bc0c966f-4cda-4d48-566f-f5bff376210a@mellanox.com>
In-Reply-To: <bc0c966f-4cda-4d48-566f-f5bff376210a@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: HE1P191CA0001.EURP191.PROD.OUTLOOK.COM (2603:10a6:3:cf::11)
 To AM6PR05MB5879.eurprd05.prod.outlook.com (2603:10a6:20b:a2::12)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=maximmi@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [95.67.35.250]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d8e916f7-1ef2-4532-e177-08d724b28eb0
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM6PR05MB5989;
x-ms-traffictypediagnostic: AM6PR05MB5989:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM6PR05MB5989ECA9E214B2F2CE3798B9D1A80@AM6PR05MB5989.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 0134AD334F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(979002)(4636009)(376002)(39860400002)(396003)(366004)(136003)(346002)(189003)(199004)(2906002)(6436002)(6246003)(446003)(476003)(6512007)(2616005)(229853002)(26005)(11346002)(4326008)(31686004)(6486002)(305945005)(7736002)(66946007)(186003)(5660300002)(66556008)(66476007)(64756008)(66446008)(25786009)(71200400001)(54906003)(99286004)(52116002)(36756003)(31696002)(71190400001)(14454004)(6916009)(316002)(256004)(7416002)(66066001)(386003)(81156014)(102836004)(8676002)(53546011)(6506007)(3846002)(486006)(6116002)(86362001)(76176011)(478600001)(14444005)(53936002)(81166006)(8936002)(32563001)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR05MB5989;H:AM6PR05MB5879.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: soM5JF58KoUJD/AYrEweKagq21VeZ3hD9QhLTZFe9kRSu3HEQqSfr+QcruhykXSl1FWRoU37V9rzecrGtu4FKz1TcTHTjmGMdTbQ6yljqKl9PUt+wtYjxtQznrK5iLGk8scea3dxp8jVuJv7IYhXABnTgkzrRn2WEaIAyr7BV0Yl2PojRZQ/S392WzNbzEUjwEw9F4+e/OvnNYZ6kjeEOdY5TyLJIiseFAj6ExsH8dglP0DBu06bCD1Jbkj94LGjXsy7ableGsPuTCMZWkvFkPzXCBpx5QALpP1H9JbZzE4qTuPeeq/WxMpsK4sTTp+59yfTyYIy+8FJAtUQV9cHjlarfFSfOf3UoOtwuPbs+dm2oseF8JSvOQQ0Gu4J38uRtmi3C3EliNOjCvGroYG+9gIRRjpGVMPZc5NDhnGyryI=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A225E4C7519A6D4BA8205AFD7AD97BD2@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d8e916f7-1ef2-4532-e177-08d724b28eb0
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Aug 2019 14:36:01.4299
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ijVUeVXeED/mqTUtt2JM7mWHDK7aORpxFj3KSrarHLJsnMBti1pTp65WyDKB9hW6d2Dz37lUXkN14uizzIa7jQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB5989
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMjAxOS0wOC0wMSAxMzowNSwgTWF4aW0gTWlraXR5YW5za2l5IHdyb3RlOg0KPiBPbiAyMDE5
LTA3LTMwIDExOjUzLCBLZXZpbiBMYWF0eiB3cm90ZToNCj4+IFdpdGggdGhlIGFkZGl0aW9uIG9m
IHRoZSB1bmFsaWduZWQgY2h1bmtzIG9wdGlvbiwgd2UgbmVlZCB0byBtYWtlIHN1cmUgd2UNCj4+
IGhhbmRsZSB0aGUgb2Zmc2V0cyBhY2NvcmRpbmdseSBiYXNlZCBvbiB0aGUgbW9kZSB3ZSBhcmUg
Y3VycmVudGx5IHJ1bm5pbmcNCj4+IGluLiBUaGlzIHBhdGNoIG1vZGlmaWVzIHRoZSBkcml2ZXIg
dG8gYXBwcm9wcmlhdGVseSBtYXNrIHRoZSBhZGRyZXNzIGZvcg0KPj4gZWFjaCBjYXNlLg0KPj4N
Cj4+IFNpZ25lZC1vZmYtYnk6IEtldmluIExhYXR6IDxrZXZpbi5sYWF0ekBpbnRlbC5jb20+DQo+
IA0KPiBQbGVhc2Ugbm90ZSB0aGF0IHRoaXMgcGF0Y2ggZG9lc24ndCBhY3R1YWxseSBhZGQgdGhl
IHN1cHBvcnQgZm9yIHRoZSBuZXcgDQo+IGZlYXR1cmUsIGJlY2F1c2UgdGhlIHZhbGlkYXRpb24g
Y2hlY2tzIGluIG1seDVlX3J4X2dldF9saW5lYXJfZnJhZ19zeiANCj4gYW5kIG1seDVlX3ZhbGlk
YXRlX3hza19wYXJhbSBuZWVkIHRvIGJlIHJlbGF4ZWQuIEN1cnJlbnRseSB0aGUgZnJhbWUgDQo+
IHNpemUgb2YgUEFHRV9TSVpFIGlzIGZvcmNlZCwgYW5kIHRoZSBmcmFnbWVudCBzaXplIGlzIGlu
Y3JlYXNlZCB0byANCj4gUEFHRV9TSVpFIGluIGNhc2Ugb2YgWERQIChpbmNsdWRpbmcgWFNLKS4N
Cj4gDQo+IEFmdGVyIG1ha2luZyB0aGUgY2hhbmdlcyByZXF1aXJlZCB0byBwZXJtaXQgZnJhbWUg
c2l6ZXMgc21hbGxlciB0aGFuIA0KPiBQQUdFX1NJWkUsIG91ciBTdHJpZGluZyBSUSBmZWF0dXJl
IHdpbGwgYmUgdXNlZCBpbiBhIHdheSB3ZSBoYXZlbid0IHVzZWQgDQo+IGl0IGJlZm9yZSwgc28g
d2UgbmVlZCB0byB2ZXJpZnkgd2l0aCB0aGUgaGFyZHdhcmUgdGVhbSB0aGF0IHRoaXMgdXNhZ2Ug
DQo+IGlzIGxlZ2l0aW1hdGUuDQoNCkFmdGVyIGRpc2N1c3NpbmcgaXQgaW50ZXJuYWxseSwgd2Ug
Zm91bmQgYSB3YXkgdG8gc3VwcG9ydCB1bmFsaWduZWQgWFNLIA0Kd2l0aCBTdHJpZGluZyBSUSwg
YW5kIHRoZSBoYXJkd2FyZSBpcyBjb21wYXRpYmxlIHdpdGggdGhpcyB3YXkuIEkgaGF2ZSANCnBl
cmZvcm1lZCBzb21lIHRlc3RpbmcsIGFuZCBpdCBsb29rcyB3b3JraW5nLg0KDQpZb3VyIHBhdGNo
IG9ubHkgYWRkcyBzdXBwb3J0IGZvciB0aGUgbmV3IGhhbmRsZSBmb3JtYXQgdG8gb3VyIGRyaXZl
ciwgDQphbmQgSSd2ZSBtYWRlIGFub3RoZXIgcGF0Y2ggdGhhdCBhY3R1YWxseSBlbmFibGVzIHRo
ZSBuZXcgZmVhdHVyZSAobWFrZXMgDQptbHg1ZSBhY2NlcHQgZnJhbWUgc2l6ZXMgZGlmZmVyZW50
IGZyb20gUEFHRV9TSVpFKS4gSXQncyBjdXJyZW50bHkgb24gDQppbnRlcm5hbCByZXZpZXcuDQoN
ClBsZWFzZSBhbHNvIGRvbid0IGZvcmdldCB0byBmaXggdGhlIHMvX2hhbmRsZV8vX2FkanVzdF8v
IHR5cG8uDQoNCj4+IC0tLQ0KPj4gdjM6DQo+PiDCoMKgIC0gVXNlIG5ldyBoZWxwZXIgZnVuY3Rp
b24gdG8gaGFuZGxlIG9mZnNldA0KPj4NCj4+IHY0Og0KPj4gwqDCoCAtIGZpeGVkIGhlYWRyb29t
IGFkZGl0aW9uIHRvIGhhbmRsZS4gVXNpbmcgeHNrX3VtZW1fYWRqdXN0X2hlYWRyb29tKCkNCj4+
IMKgwqDCoMKgIG5vdy4NCj4+IC0tLQ0KPj4gwqAgZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFu
b3gvbWx4NS9jb3JlL2VuL3hkcC5jwqDCoMKgIHwgOCArKysrKystLQ0KPj4gwqAgZHJpdmVycy9u
ZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VuL3hzay9yeC5jIHwgMyArKy0NCj4+IMKg
IDIgZmlsZXMgY2hhbmdlZCwgOCBpbnNlcnRpb25zKCspLCAzIGRlbGV0aW9ucygtKQ0KPj4NCj4+
IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW4v
eGRwLmMgDQo+PiBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lbi94
ZHAuYw0KPj4gaW5kZXggYjBiOTgyY2Y2OWJiLi5kNTI0NTg5M2QyYzggMTAwNjQ0DQo+PiAtLS0g
YS9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW4veGRwLmMNCj4+ICsr
KyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lbi94ZHAuYw0KPj4g
QEAgLTEyMiw2ICsxMjIsNyBAQCBib29sIG1seDVlX3hkcF9oYW5kbGUoc3RydWN0IG1seDVlX3Jx
ICpycSwgc3RydWN0IA0KPj4gbWx4NWVfZG1hX2luZm8gKmRpLA0KPj4gwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgIHZvaWQgKnZhLCB1MTYgKnJ4X2hlYWRyb29tLCB1MzIgKmxlbiwgYm9v
bCB4c2spDQo+PiDCoCB7DQo+PiDCoMKgwqDCoMKgIHN0cnVjdCBicGZfcHJvZyAqcHJvZyA9IFJF
QURfT05DRShycS0+eGRwX3Byb2cpOw0KPj4gK8KgwqDCoCBzdHJ1Y3QgeGRwX3VtZW0gKnVtZW0g
PSBycS0+dW1lbTsNCj4+IMKgwqDCoMKgwqAgc3RydWN0IHhkcF9idWZmIHhkcDsNCj4+IMKgwqDC
oMKgwqAgdTMyIGFjdDsNCj4+IMKgwqDCoMKgwqAgaW50IGVycjsNCj4+IEBAIC0xMzgsOCArMTM5
LDExIEBAIGJvb2wgbWx4NWVfeGRwX2hhbmRsZShzdHJ1Y3QgbWx4NWVfcnEgKnJxLCBzdHJ1Y3Qg
DQo+PiBtbHg1ZV9kbWFfaW5mbyAqZGksDQo+PiDCoMKgwqDCoMKgIHhkcC5yeHEgPSAmcnEtPnhk
cF9yeHE7DQo+PiDCoMKgwqDCoMKgIGFjdCA9IGJwZl9wcm9nX3J1bl94ZHAocHJvZywgJnhkcCk7
DQo+PiAtwqDCoMKgIGlmICh4c2spDQo+PiAtwqDCoMKgwqDCoMKgwqAgeGRwLmhhbmRsZSArPSB4
ZHAuZGF0YSAtIHhkcC5kYXRhX2hhcmRfc3RhcnQ7DQo+PiArwqDCoMKgIGlmICh4c2spIHsNCj4+
ICvCoMKgwqDCoMKgwqDCoCB1NjQgb2ZmID0geGRwLmRhdGEgLSB4ZHAuZGF0YV9oYXJkX3N0YXJ0
Ow0KPj4gKw0KPj4gK8KgwqDCoMKgwqDCoMKgIHhkcC5oYW5kbGUgPSB4c2tfdW1lbV9oYW5kbGVf
b2Zmc2V0KHVtZW0sIHhkcC5oYW5kbGUsIG9mZik7DQo+PiArwqDCoMKgIH0NCj4+IMKgwqDCoMKg
wqAgc3dpdGNoIChhY3QpIHsNCj4+IMKgwqDCoMKgwqAgY2FzZSBYRFBfUEFTUzoNCj4+IMKgwqDC
oMKgwqDCoMKgwqDCoCAqcnhfaGVhZHJvb20gPSB4ZHAuZGF0YSAtIHhkcC5kYXRhX2hhcmRfc3Rh
cnQ7DQo+PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9j
b3JlL2VuL3hzay9yeC5jIA0KPj4gYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1
L2NvcmUvZW4veHNrL3J4LmMNCj4+IGluZGV4IDZhNTU1NzNlYzhmMi4uN2M0OWE2NmQyOGM5IDEw
MDY0NA0KPj4gLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2Vu
L3hzay9yeC5jDQo+PiArKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2Nv
cmUvZW4veHNrL3J4LmMNCj4+IEBAIC0yNCw3ICsyNCw4IEBAIGludCBtbHg1ZV94c2tfcGFnZV9h
bGxvY191bWVtKHN0cnVjdCBtbHg1ZV9ycSAqcnEsDQo+PiDCoMKgwqDCoMKgIGlmICgheHNrX3Vt
ZW1fcGVla19hZGRyX3JxKHVtZW0sICZoYW5kbGUpKQ0KPj4gwqDCoMKgwqDCoMKgwqDCoMKgIHJl
dHVybiAtRU5PTUVNOw0KPj4gLcKgwqDCoCBkbWFfaW5mby0+eHNrLmhhbmRsZSA9IGhhbmRsZSAr
IHJxLT5idWZmLnVtZW1faGVhZHJvb207DQo+PiArwqDCoMKgIGRtYV9pbmZvLT54c2suaGFuZGxl
ID0geHNrX3VtZW1fYWRqdXN0X29mZnNldCh1bWVtLCBoYW5kbGUsDQo+PiArwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBycS0+YnVmZi51
bWVtX2hlYWRyb29tKTsNCj4+IMKgwqDCoMKgwqAgZG1hX2luZm8tPnhzay5kYXRhID0geGRwX3Vt
ZW1fZ2V0X2RhdGEodW1lbSwgZG1hX2luZm8tPnhzay5oYW5kbGUpOw0KPj4gwqDCoMKgwqDCoCAv
KiBObyBuZWVkIHRvIGFkZCBoZWFkcm9vbSB0byB0aGUgRE1BIGFkZHJlc3MuIEluIHN0cmlkaW5n
IFJRIA0KPj4gY2FzZSwgd2UNCj4+DQo+IA0KDQo=
