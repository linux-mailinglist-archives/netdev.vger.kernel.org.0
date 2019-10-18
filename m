Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1FC6FDD0C5
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 23:01:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439394AbfJRVBG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 17:01:06 -0400
Received: from mail-eopbgr40049.outbound.protection.outlook.com ([40.107.4.49]:31584
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731817AbfJRVBG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Oct 2019 17:01:06 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=csISWD1rIHjULl+n3r3kR508XBrhQPl12I12OYNZL8zJc1sSoU06j/OAKjrGsm5CSzU5Vj/7k03mK647lYXfurBI4ubjzvu6ylYSrEAjurbV4YU66+WRsafcs4oo87d2CtUD9kFUIWDM837Koe2ByYAZrrFcCbbVcL/eYVK7UXOQVKW6puXAgk7vnZkc21FofduGvZ85sXk4tbnN5Fqos5GmL8RjDNQ4kGWABnl9kG3qwUr/W/rKLW/v6kx04ZCBQrIH6EClVRkYej25/p0HeqfP/MH3DSTGL4vTiofizkduxJgUSLU805wL6OntMQwAG4o/XfVs+O40Nu2ZXzDKKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NEqrwnc898et2PiCAR88gCK3yuMmSbWIoNUGuMe+wI8=;
 b=mnXFm76WtwrBMzilgX7NzDfcDYRGhpK38mFNuclHS9g+cZFqLjOtX+0VPvLejaWLmRGc80qHI/k2ZYkjOHjbjw1p9At8UwA+a4W9W4inJThIBtzxQmYuHGyYVljeurM+2ECZd11CYL8Sh3FII1Ig47z/oUaO1Wcw9GXLGDP6rgHfnIxmTdhHhqIaPtooeRstVpYDXfFKp42N3wvvJ9YXCajUyXb6vOJavRMOEKj9hTDoNcj/9lL5mFn2dSX1c7/Ahk4Ay8pP7vhr7hNpnSvuKgaA4+FGM5XDRDVEHjc7lGqj/AXGmrQYfdxylmyenGgxz8laXS7CUSwh32Jr910DYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NEqrwnc898et2PiCAR88gCK3yuMmSbWIoNUGuMe+wI8=;
 b=dCUUZVDcOpceQ4PROUn0jka3wYRCGMt/5Viw/BLQl5fwnFHOb71THdAB/dLS/MlC38RebSqZ9JnKs/9D83jIFA0GJ13afugRAS3hOov5dv4d7+Ot1M8EeUZSCWGOvAAVSyY9iyBStMTWNKaBwclEawmdL99qXnryZ3i4LoEqtP4=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB4765.eurprd05.prod.outlook.com (20.176.4.26) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.16; Fri, 18 Oct 2019 21:01:00 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::f42d:b87a:e6b2:f841]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::f42d:b87a:e6b2:f841%7]) with mapi id 15.20.2347.024; Fri, 18 Oct 2019
 21:01:00 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "jonathan.lemon@gmail.com" <jonathan.lemon@gmail.com>,
        "ilias.apalodimas@linaro.org" <ilias.apalodimas@linaro.org>,
        Tariq Toukan <tariqt@mellanox.com>,
        "brouer@redhat.com" <brouer@redhat.com>
CC:     "kernel-team@fb.com" <kernel-team@fb.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH 03/10 net-next] net/mlx5e: RX, Internal DMA mapping in
 page_pool
Thread-Topic: [PATCH 03/10 net-next] net/mlx5e: RX, Internal DMA mapping in
 page_pool
Thread-Index: AQHVhHQsvSNwlaR8CEGcTN1U/v1986dg5V8A
Date:   Fri, 18 Oct 2019 21:01:00 +0000
Message-ID: <4ef93ef6e0ee3ad80b75a3dfa9f930d313c6a963.camel@mellanox.com>
References: <20191016225028.2100206-1-jonathan.lemon@gmail.com>
         <20191016225028.2100206-4-jonathan.lemon@gmail.com>
In-Reply-To: <20191016225028.2100206-4-jonathan.lemon@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.4 (3.32.4-1.fc30) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 462f9a45-3a90-4166-3d79-08d7540e47ec
x-ms-office365-filtering-ht: Tenant
x-ms-traffictypediagnostic: VI1PR05MB4765:|VI1PR05MB4765:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB4765BCE345C1046CF72A525CBE6C0@VI1PR05MB4765.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 01949FE337
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(346002)(376002)(136003)(396003)(366004)(199004)(189003)(110136005)(8676002)(316002)(4001150100001)(36756003)(6506007)(71190400001)(81166006)(8936002)(71200400001)(81156014)(186003)(26005)(86362001)(99286004)(102836004)(76176011)(25786009)(54906003)(14444005)(58126008)(478600001)(256004)(2501003)(14454004)(118296001)(6512007)(5660300002)(6116002)(3846002)(6246003)(6486002)(4326008)(91956017)(76116006)(66946007)(66476007)(66556008)(64756008)(66446008)(6436002)(7736002)(11346002)(446003)(476003)(2616005)(486006)(305945005)(2906002)(66066001)(229853002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4765;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Tszw+5fP5CPiA0ghFwoTXHsCVQxZl4adDoLsFIZG1bCWNgyZ1EvGGeks8na0PhpvPn8u7YtOvdFyQi3INqI4ZccLvmDM7mHLFAASX1UhWwR7tF85sMzKw9T+YDj0m2TU9d81w3KGsYVNPQVp5+FRUZWKI0gu5kHOo6+/mOknhXfoFYKC57xUIQu+WQzP2F7SMdRZqBV9Syu2DZPVQ6mgKl9HkVRtUCZnHmumEfASwk280puinsJGv2d21bY+LHn2G1gfvoiWerA3gBfz7QPkKTKn6R0kDOoyO21fP/ObwN9pqGsGNQF2oGr2wBCHnOl74/rhjS17dZaOIVwzzuSTdc9pFA4GTRB/lGIk51K2u4U8G7GO4aiszEVdbCz9xJx/r0EMbx9y7yrF3DHpSHhwE7lZJcf/oGgq4+brR42Ha+Y=
Content-Type: text/plain; charset="utf-8"
Content-ID: <22010F1FA1C1574985F5DC3DB3DA2279@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 462f9a45-3a90-4166-3d79-08d7540e47ec
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Oct 2019 21:01:00.8454
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HeADa1RsNxLvqryo4sfO2uJUKf/PTE0ouDo1gUWyd/ysp5EX8zsxDyGlfnicyGp80S65LopHuO30xtksbmX8iA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4765
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCAyMDE5LTEwLTE2IGF0IDE1OjUwIC0wNzAwLCBKb25hdGhhbiBMZW1vbiB3cm90ZToN
Cj4gRnJvbTogVGFyaXEgVG91a2FuIDx0YXJpcXRAbWVsbGFub3guY29tPg0KPiANCj4gQWZ0ZXIg
UlggcGFnZS1jYWNoZSBpcyByZW1vdmVkIGluIHByZXZpb3VzIHBhdGNoLCBsZXQgdGhlDQo+IHBh
Z2VfcG9vbCBiZSByZXNwb25zaWJsZSBmb3IgdGhlIERNQSBtYXBwaW5nLg0KPiANCj4gSXNzdWU6
IDE0ODc2MzENCj4gU2lnbmVkLW9mZi1ieTogVGFyaXEgVG91a2FuIDx0YXJpcXRAbWVsbGFub3gu
Y29tPg0KPiANCj4gU2lnbmVkLW9mZi1ieTogSm9uYXRoYW4gTGVtb24gPGpvbmF0aGFuLmxlbW9u
QGdtYWlsLmNvbT4NCj4gLS0tDQo+ICBkcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1
L2NvcmUvZW4uaCAgICAgfCAgMiAtLQ0KPiAgZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gv
bWx4NS9jb3JlL2VuL3hkcC5jIHwgIDMgKy0tDQo+ICAuLi4vbmV0L2V0aGVybmV0L21lbGxhbm94
L21seDUvY29yZS9lbl9tYWluLmMgICAgfCAgMiArLQ0KPiAgZHJpdmVycy9uZXQvZXRoZXJuZXQv
bWVsbGFub3gvbWx4NS9jb3JlL2VuX3J4LmMgIHwgMTYgKy0tLS0tLS0tLS0tLS0NCj4gLS0NCj4g
IDQgZmlsZXMgY2hhbmdlZCwgMyBpbnNlcnRpb25zKCspLCAyMCBkZWxldGlvbnMoLSkNCj4gDQo+
IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW4u
aA0KPiBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lbi5oDQo+IGlu
ZGV4IGExYWI1Yzc2MTc3ZC4uMmUyODFjNzU1YjY1IDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL25l
dC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW4uaA0KPiArKysgYi9kcml2ZXJzL25ldC9l
dGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW4uaA0KPiBAQCAtOTI2LDEwICs5MjYsOCBAQCBi
b29sDQo+IG1seDVlX2NoZWNrX2ZyYWdtZW50ZWRfc3RyaWRpbmdfcnFfY2FwKHN0cnVjdCBtbHg1
X2NvcmVfZGV2ICptZGV2KTsNCj4gIGJvb2wgbWx4NWVfc3RyaWRpbmdfcnFfcG9zc2libGUoc3Ry
dWN0IG1seDVfY29yZV9kZXYgKm1kZXYsDQo+ICAJCQkJc3RydWN0IG1seDVlX3BhcmFtcyAqcGFy
YW1zKTsNCj4gIA0KPiAtdm9pZCBtbHg1ZV9wYWdlX2RtYV91bm1hcChzdHJ1Y3QgbWx4NWVfcnEg
KnJxLCBzdHJ1Y3QgbWx4NWVfZG1hX2luZm8NCj4gKmRtYV9pbmZvKTsNCj4gIHZvaWQgbWx4NWVf
cGFnZV9yZWxlYXNlX2R5bmFtaWMoc3RydWN0IG1seDVlX3JxICpycSwNCj4gIAkJCQlzdHJ1Y3Qg
bWx4NWVfZG1hX2luZm8gKmRtYV9pbmZvKTsNCj4gLXZvaWQgbWx4NWVfcGFnZV9yZWxlYXNlKHN0
cnVjdCBtbHg1ZV9ycSAqcnEsIHN0cnVjdCBtbHg1ZV9kbWFfaW5mbw0KPiAqZG1hX2luZm8pOw0K
PiAgdm9pZCBtbHg1ZV9oYW5kbGVfcnhfY3FlKHN0cnVjdCBtbHg1ZV9ycSAqcnEsIHN0cnVjdCBt
bHg1X2NxZTY0DQo+ICpjcWUpOw0KPiAgdm9pZCBtbHg1ZV9oYW5kbGVfcnhfY3FlX21wd3JxKHN0
cnVjdCBtbHg1ZV9ycSAqcnEsIHN0cnVjdA0KPiBtbHg1X2NxZTY0ICpjcWUpOw0KPiAgYm9vbCBt
bHg1ZV9wb3N0X3J4X3dxZXMoc3RydWN0IG1seDVlX3JxICpycSk7DQo+IGRpZmYgLS1naXQgYS9k
cml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW4veGRwLmMNCj4gYi9kcml2
ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW4veGRwLmMNCj4gaW5kZXggMWIy
NjA2MWNiOTU5Li44Mzc2YjI3ODk1NzUgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvbmV0L2V0aGVy
bmV0L21lbGxhbm94L21seDUvY29yZS9lbi94ZHAuYw0KPiArKysgYi9kcml2ZXJzL25ldC9ldGhl
cm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW4veGRwLmMNCj4gQEAgLTE2MSw4ICsxNjEsNyBAQCBi
b29sIG1seDVlX3hkcF9oYW5kbGUoc3RydWN0IG1seDVlX3JxICpycSwgc3RydWN0DQo+IG1seDVl
X2RtYV9pbmZvICpkaSwNCj4gIAkJCWdvdG8geGRwX2Fib3J0Ow0KPiAgCQlfX3NldF9iaXQoTUxY
NUVfUlFfRkxBR19YRFBfWE1JVCwgcnEtPmZsYWdzKTsNCj4gIAkJX19zZXRfYml0KE1MWDVFX1JR
X0ZMQUdfWERQX1JFRElSRUNULCBycS0+ZmxhZ3MpOw0KPiAtCQlpZiAoIXhzaykNCj4gLQkJCW1s
eDVlX3BhZ2VfZG1hX3VubWFwKHJxLCBkaSk7DQo+ICsJCS8qIHhkcCBtYXBzIGNhbGwgeGRwX3Jl
bGVhc2VfZnJhbWUoKSBpZiBuZWVkZWQgKi8NCj4gIAkJcnEtPnN0YXRzLT54ZHBfcmVkaXJlY3Qr
KzsNCj4gIAkJcmV0dXJuIHRydWU7DQo+ICAJZGVmYXVsdDoNCj4gZGlmZiAtLWdpdCBhL2RyaXZl
cnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lbl9tYWluLmMNCj4gYi9kcml2ZXJz
L25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW5fbWFpbi5jDQo+IGluZGV4IDE2OGJl
MWY4MDBhMy4uMmI4MjhkZTFhZGYwIDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5l
dC9tZWxsYW5veC9tbHg1L2NvcmUvZW5fbWFpbi5jDQo+ICsrKyBiL2RyaXZlcnMvbmV0L2V0aGVy
bmV0L21lbGxhbm94L21seDUvY29yZS9lbl9tYWluLmMNCj4gQEAgLTU0Niw3ICs1NDYsNyBAQCBz
dGF0aWMgaW50IG1seDVlX2FsbG9jX3JxKHN0cnVjdCBtbHg1ZV9jaGFubmVsDQo+ICpjLA0KPiAg
CX0gZWxzZSB7DQo+ICAJCS8qIENyZWF0ZSBhIHBhZ2VfcG9vbCBhbmQgcmVnaXN0ZXIgaXQgd2l0
aCByeHEgKi8NCj4gIAkJcHBfcGFyYW1zLm9yZGVyICAgICA9IDA7DQo+IC0JCXBwX3BhcmFtcy5m
bGFncyAgICAgPSAwOyAvKiBOby1pbnRlcm5hbCBETUEgbWFwcGluZyBpbg0KPiBwYWdlX3Bvb2wg
Ki8NCj4gKwkJcHBfcGFyYW1zLmZsYWdzICAgICA9IFBQX0ZMQUdfRE1BX01BUDsNCj4gIAkJcHBf
cGFyYW1zLnBvb2xfc2l6ZSA9IHBvb2xfc2l6ZTsNCj4gIAkJcHBfcGFyYW1zLm5pZCAgICAgICA9
IGNwdV90b19ub2RlKGMtPmNwdSk7DQo+ICAJCXBwX3BhcmFtcy5kZXYgICAgICAgPSBjLT5wZGV2
Ow0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3Jl
L2VuX3J4LmMNCj4gYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW5f
cnguYw0KPiBpbmRleCAwMzNiODI2NGE0ZTQuLjFiNzRkMDNmZGYwNiAxMDA2NDQNCj4gLS0tIGEv
ZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VuX3J4LmMNCj4gKysrIGIv
ZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VuX3J4LmMNCj4gQEAgLTE5
MCwxNCArMTkwLDcgQEAgc3RhdGljIGlubGluZSBpbnQgbWx4NWVfcGFnZV9hbGxvY19wb29sKHN0
cnVjdA0KPiBtbHg1ZV9ycSAqcnEsDQo+ICAJZG1hX2luZm8tPnBhZ2UgPSBwYWdlX3Bvb2xfZGV2
X2FsbG9jX3BhZ2VzKHJxLT5wYWdlX3Bvb2wpOw0KPiAgCWlmICh1bmxpa2VseSghZG1hX2luZm8t
PnBhZ2UpKQ0KPiAgCQlyZXR1cm4gLUVOT01FTTsNCg0KSmFrdWIgaXMgcmlnaHQsIHlvdSBuZWVk
IHRvIGRtYV9zeW5jIGZvciBkZXZpY2UgYWZ0ZXIgYWxsb2NhdGluZyAuLg0KcGFnZXMgcmVjeWNs
ZWQgZnJvbSBjYWNoZSBjYW4gYmUgc3luY2VkIGZvciBDUFUgLi4geW91IG5lZWQgdG8gc3luYw0K
dGhlbSBmb3IgZGV2aWNlIGhlcmUuDQoNCj4gLQ0KPiAtCWRtYV9pbmZvLT5hZGRyID0gZG1hX21h
cF9wYWdlKHJxLT5wZGV2LCBkbWFfaW5mby0+cGFnZSwgMCwNCj4gLQkJCQkgICAgICBQQUdFX1NJ
WkUsIHJxLT5idWZmLm1hcF9kaXIpOw0KPiAtCWlmICh1bmxpa2VseShkbWFfbWFwcGluZ19lcnJv
cihycS0+cGRldiwgZG1hX2luZm8tPmFkZHIpKSkgew0KPiAtCQlwYWdlX3Bvb2xfcmVjeWNsZV9k
aXJlY3QocnEtPnBhZ2VfcG9vbCwgZG1hX2luZm8tDQo+ID5wYWdlKTsNCj4gLQkJZG1hX2luZm8t
PnBhZ2UgPSBOVUxMOw0KPiAtCQlyZXR1cm4gLUVOT01FTTsNCj4gLQl9DQo+ICsJZG1hX2luZm8t
PmFkZHIgPSBwYWdlX3Bvb2xfZ2V0X2RtYV9hZGRyKGRtYV9pbmZvLT5wYWdlKTsNCj4gIA0KPiAg
CXJldHVybiAwOw0KPiAgfQ0KPiBAQCAtMjExLDE2ICsyMDQsOSBAQCBzdGF0aWMgaW5saW5lIGlu
dCBtbHg1ZV9wYWdlX2FsbG9jKHN0cnVjdA0KPiBtbHg1ZV9ycSAqcnEsDQo+ICAJCXJldHVybiBt
bHg1ZV9wYWdlX2FsbG9jX3Bvb2wocnEsIGRtYV9pbmZvKTsNCj4gIH0NCj4gIA0KPiAtdm9pZCBt
bHg1ZV9wYWdlX2RtYV91bm1hcChzdHJ1Y3QgbWx4NWVfcnEgKnJxLCBzdHJ1Y3QgbWx4NWVfZG1h
X2luZm8NCj4gKmRtYV9pbmZvKQ0KPiAtew0KPiAtCWRtYV91bm1hcF9wYWdlKHJxLT5wZGV2LCBk
bWFfaW5mby0+YWRkciwgUEFHRV9TSVpFLCBycS0NCj4gPmJ1ZmYubWFwX2Rpcik7DQo+IC19DQo+
IC0NCj4gIHZvaWQgbWx4NWVfcGFnZV9yZWxlYXNlX2R5bmFtaWMoc3RydWN0IG1seDVlX3JxICpy
cSwNCj4gIAkJCQlzdHJ1Y3QgbWx4NWVfZG1hX2luZm8gKmRtYV9pbmZvKQ0KPiAgew0KPiAtCW1s
eDVlX3BhZ2VfZG1hX3VubWFwKHJxLCBkbWFfaW5mbyk7DQo+IC0NCj4gIAlwYWdlX3Bvb2xfcmVj
eWNsZV9kaXJlY3QocnEtPnBhZ2VfcG9vbCwgZG1hX2luZm8tPnBhZ2UpOw0KPiAgfQ0KPiAgDQo=
