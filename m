Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9FF59F33A
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 21:22:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730347AbfH0TWq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 15:22:46 -0400
Received: from mail-eopbgr130079.outbound.protection.outlook.com ([40.107.13.79]:12254
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726871AbfH0TWp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Aug 2019 15:22:45 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KLitb/6wqikAaZ/s6hWuvdFku7QfVGx8S9XRPBcvcXVJqLQyB0T86HuKwNTr4d5CayCgIyx+H8o+BN0VVBGIcxdOzrVQxOmHbIQH+XNbOchpj7R0DnEN+G27XDZgCyfe7+A9C7PJ1N4CLifC2f24TtmOHth2qKkGvzcidvK5v4vw+f0n1p+Qdb+eEH7LNu7dyA6T3koBvmX9dvfLo2N8noyKOIT6DzsRTt+D7ugcAmTzelfaSlyhr3wwm6nStoz1RXCxGsvqoLX8a3SnwPbla6M0CBwpU7nAiohSoynvbehEIxwg6AP3XpZ7BhieBl71DbZjuhDzQfqEKtoJ9IL6TQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aGtOJ+4UhwokFXHa+chr2pqU1CF+shDeZ0ZRCc3o3zU=;
 b=c5NApA2LuPL5UathaTnJ9h8mWPmea9EwX8v4w+PFzZf6+SBKh2EKmweyrbrBPSe85mU4pUTdmXKbI77oIuCDW7j9zAYGT+CaKjPRSwGLO7oSWsW7DqsPROvrELnSz8ooXvaZ7RhOXCdw2b/Om+XBtf44q+bn+O4gg0bdpybxCDRUYKrDJT6ugeGr+/DIIe1kObkWtzmpK9iu8CMRoFjoJ9IuEkizt1+tU0xB5Nx8Ggr0UH569fpobVOTaIb64SJ0mCy4aYPLebWXvs633zUjKlbbL1cbJtYNjyTuyevSdEB12w7nhNnnD3jyVHq3ysk76pPDxGPbkHhpQbuqKtL2sA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aGtOJ+4UhwokFXHa+chr2pqU1CF+shDeZ0ZRCc3o3zU=;
 b=GkOof9I/4ldEw6yA6drU0+6nvnXjMCWUMi912s/oLbYqOoPyDnXYCxuNObPdlQfikvzQm9WftWowEMyzRUhTRlfhm5bCOiqXT5BrMn4L7oHby0DpHwlrC7Vr6EwEwKnswMV9x4vMLX2oNi6JiYapH/hnNX2y1IgKLoNonTwIRGk=
Received: from VI1PR0501MB2765.eurprd05.prod.outlook.com (10.172.11.140) by
 VI1PR0501MB2397.eurprd05.prod.outlook.com (10.168.138.11) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2199.21; Tue, 27 Aug 2019 19:22:39 +0000
Received: from VI1PR0501MB2765.eurprd05.prod.outlook.com
 ([fe80::5cab:4f5c:d7ed:5e27]) by VI1PR0501MB2765.eurprd05.prod.outlook.com
 ([fe80::5cab:4f5c:d7ed:5e27%6]) with mapi id 15.20.2199.021; Tue, 27 Aug 2019
 19:22:39 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "willy@infradead.org" <willy@infradead.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH 04/38] mlx5: Convert cq_table to XArray
Thread-Topic: [PATCH 04/38] mlx5: Convert cq_table to XArray
Thread-Index: AQHVV6djTGfFAmGn4EqSpJKQmxsbXacPakOA
Date:   Tue, 27 Aug 2019 19:22:39 +0000
Message-ID: <25e92b3a139f4fcca5886df28e0931da6c0dd3b4.camel@mellanox.com>
References: <20190820223259.22348-1-willy@infradead.org>
         <20190820223259.22348-5-willy@infradead.org>
In-Reply-To: <20190820223259.22348-5-willy@infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.4 (3.32.4-1.fc30) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 80af70e6-bd19-4b0b-a32a-08d72b23ecec
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR0501MB2397;
x-ms-traffictypediagnostic: VI1PR0501MB2397:
x-microsoft-antispam-prvs: <VI1PR0501MB2397E47D15BD9972FAFAAF56BEA00@VI1PR0501MB2397.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0142F22657
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(366004)(396003)(346002)(376002)(136003)(189003)(199004)(86362001)(71190400001)(76116006)(66476007)(66556008)(64756008)(66446008)(26005)(102836004)(478600001)(186003)(91956017)(66066001)(229853002)(81166006)(110136005)(81156014)(58126008)(8676002)(8936002)(66946007)(118296001)(71200400001)(3846002)(6116002)(305945005)(14454004)(7736002)(6436002)(36756003)(446003)(5660300002)(6246003)(11346002)(2616005)(76176011)(256004)(14444005)(2501003)(6512007)(53936002)(476003)(2906002)(6486002)(99286004)(6506007)(316002)(25786009)(486006);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0501MB2397;H:VI1PR0501MB2765.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 4VMjGfpuFNuzDhVSdzfZz9vUL0HSvgh9k8Z8otn2Yi4cuxbXXAHfRuvF2gMzOORyP4j2NG9ZAh3/uNXa/b+qfL0bwNLmv7hMA2shYvYgKo8jGiCcDjibbknkQqTHi3ulZKaeUdXPxuYGLnMh0lnYoCJngGcjpDAHNED/IywsSLmyy9y7llLaWyHCLiZZMWHoohN6RrS4VSCJAWEO7vMD0eSx5wqIW+ruIDb1h6FUW43lmH6kSiHvVwUgb0chsQS1r47RWiJNCWke/VdP4vUc5BokexDY5prqEqXYO/rrmapYkmMj7bx5iw58NBCerYayuASvR1aTfiJZ+75wZwDDnkndjmW4AnOVVNgSldLclnVq3/p5KQUkpLC5rKyxGB/F85AaDwklvTwL1w1ea4q/SRTrjq/qxckgTzgF1XCzzaU=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <1BBA34BDD099F441909D0D7899479960@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 80af70e6-bd19-4b0b-a32a-08d72b23ecec
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Aug 2019 19:22:39.3736
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: A5BXLYuc6/7UQqcK1H/d3UvElcxO2MKdsC2El3blW3359fiCYJNL1/PvLYpKUJbo8X6ybrj/jQyAlTJn6zndpw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0501MB2397
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDE5LTA4LTIwIGF0IDE1OjMyIC0wNzAwLCBNYXR0aGV3IFdpbGNveCB3cm90ZToN
Cj4gRnJvbTogIk1hdHRoZXcgV2lsY294IChPcmFjbGUpIiA8d2lsbHlAaW5mcmFkZWFkLm9yZz4N
Cj4gDQo+IFNpbmNlIG1seDVfY3FfdGFibGUgd291bGQgaGF2ZSBzaHJ1bmsgZG93biB0byBqdXN0
IHRoZSB4YXJyYXksDQo+IGVsaW1pbmF0ZQ0KPiBpdCBhbmQgZW1iZWQgdGhlIHhhcnJheSBkaXJl
Y3RseSBpbnRvIG1seDVfZXEuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBNYXR0aGV3IFdpbGNveCAo
T3JhY2xlKSA8d2lsbHlAaW5mcmFkZWFkLm9yZz4NCj4gLS0tDQo+ICBkcml2ZXJzL25ldC9ldGhl
cm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZXEuYyAgfCAyNyArKysrLS0tLS0tLS0tLS0tLQ0KPiAt
LQ0KPiAgLi4uL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvbGliL2VxLmggIHwgIDcg
Ky0tLS0NCj4gIDIgZmlsZXMgY2hhbmdlZCwgNiBpbnNlcnRpb25zKCspLCAyOCBkZWxldGlvbnMo
LSkNCj4gDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1
L2NvcmUvZXEuYw0KPiBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9l
cS5jDQo+IGluZGV4IDA5ZDRjNjRiNmU3My4uYzU5NTNmNmUwYTY5IDEwMDY0NA0KPiAtLS0gYS9k
cml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZXEuYw0KPiArKysgYi9kcml2
ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZXEuYw0KPiBAQCAtMTEzLDExICsx
MTMsMTAgQEAgc3RhdGljIGludCBtbHg1X2NtZF9kZXN0cm95X2VxKHN0cnVjdA0KPiBtbHg1X2Nv
cmVfZGV2ICpkZXYsIHU4IGVxbikNCj4gIC8qIGNhbGxlciBtdXN0IGV2ZW50dWFsbHkgY2FsbCBt
bHg1X2NxX3B1dCBvbiB0aGUgcmV0dXJuZWQgY3EgKi8NCj4gIHN0YXRpYyBzdHJ1Y3QgbWx4NV9j
b3JlX2NxICptbHg1X2VxX2NxX2dldChzdHJ1Y3QgbWx4NV9lcSAqZXEsIHUzMg0KPiBjcW4pDQo+
ICB7DQo+IC0Jc3RydWN0IG1seDVfY3FfdGFibGUgKnRhYmxlID0gJmVxLT5jcV90YWJsZTsNCj4g
LQlzdHJ1Y3QgbWx4NV9jb3JlX2NxICpjcSA9IE5VTEw7DQo+ICsJc3RydWN0IG1seDVfY29yZV9j
cSAqY3E7DQo+ICANCj4gIAlyY3VfcmVhZF9sb2NrKCk7DQo+IC0JY3EgPSByYWRpeF90cmVlX2xv
b2t1cCgmdGFibGUtPnRyZWUsIGNxbik7DQo+ICsJY3EgPSB4YV9sb2FkKCZlcS0+Y3FfdGFibGUs
IGNxbik7DQo+ICAJaWYgKGxpa2VseShjcSkpDQo+ICAJCW1seDVfY3FfaG9sZChjcSk7DQo+ICAJ
cmN1X3JlYWRfdW5sb2NrKCk7DQo+IEBAIC0yNDMsNyArMjQyLDYgQEAgc3RhdGljIGludA0KPiAg
Y3JlYXRlX21hcF9lcShzdHJ1Y3QgbWx4NV9jb3JlX2RldiAqZGV2LCBzdHJ1Y3QgbWx4NV9lcSAq
ZXEsDQo+ICAJICAgICAgc3RydWN0IG1seDVfZXFfcGFyYW0gKnBhcmFtKQ0KPiAgew0KPiAtCXN0
cnVjdCBtbHg1X2NxX3RhYmxlICpjcV90YWJsZSA9ICZlcS0+Y3FfdGFibGU7DQo+ICAJdTMyIG91
dFtNTFg1X1NUX1NaX0RXKGNyZWF0ZV9lcV9vdXQpXSA9IHswfTsNCj4gIAlzdHJ1Y3QgbWx4NV9w
cml2ICpwcml2ID0gJmRldi0+cHJpdjsNCj4gIAl1OCB2ZWNpZHggPSBwYXJhbS0+aXJxX2luZGV4
Ow0KPiBAQCAtMjU0LDExICsyNTIsNyBAQCBjcmVhdGVfbWFwX2VxKHN0cnVjdCBtbHg1X2NvcmVf
ZGV2ICpkZXYsIHN0cnVjdA0KPiBtbHg1X2VxICplcSwNCj4gIAlpbnQgZXJyOw0KPiAgCWludCBp
Ow0KPiAgDQo+IC0JLyogSW5pdCBDUSB0YWJsZSAqLw0KPiAtCW1lbXNldChjcV90YWJsZSwgMCwg
c2l6ZW9mKCpjcV90YWJsZSkpOw0KPiAtCXNwaW5fbG9ja19pbml0KCZjcV90YWJsZS0+bG9jayk7
DQo+IC0JSU5JVF9SQURJWF9UUkVFKCZjcV90YWJsZS0+dHJlZSwgR0ZQX0FUT01JQyk7DQo+IC0N
Cj4gKwl4YV9pbml0X2ZsYWdzKCZlcS0+Y3FfdGFibGUsIFhBX0ZMQUdTX0xPQ0tfSVJRKTsNCg0K
V2h5IHRoZSBJUlEgZmxhZyA/IHdlIGFyZSBub3QgZ29pbmcgdG8gbW9kaWZ5IHRoZSB4YXJyYXkg
aW4gaXJxIGNvbnRleHQNCmFsbCB3ZSBkbyBpcyBob2xkIGEgcmVmIGNvdW50IG9uIHRoZSBlbnRy
eSB3ZSBsb29rZWQgdXANCm1seDVfY3FfaG9sZChjcSk7IGFuZCB0aGlzIGlzIHByb3RlY3RlZCBi
eSByY3VfbG9jay4gDQoNCj4gIAllcS0+bmVudCA9IHJvdW5kdXBfcG93X29mX3R3byhwYXJhbS0+
bmVudCArDQo+IE1MWDVfTlVNX1NQQVJFX0VRRSk7DQo+ICAJZXEtPmNvbnNfaW5kZXggPSAwOw0K
PiAgCWVyciA9IG1seDVfYnVmX2FsbG9jKGRldiwgZXEtPm5lbnQgKiBNTFg1X0VRRV9TSVpFLCAm
ZXEtPmJ1Zik7DQo+IEBAIC0zNzgsMjUgKzM3MiwxNCBAQCBzdGF0aWMgaW50IGRlc3Ryb3lfdW5t
YXBfZXEoc3RydWN0DQo+IG1seDVfY29yZV9kZXYgKmRldiwgc3RydWN0IG1seDVfZXEgKmVxKQ0K
PiAgDQo+ICBpbnQgbWx4NV9lcV9hZGRfY3Eoc3RydWN0IG1seDVfZXEgKmVxLCBzdHJ1Y3QgbWx4
NV9jb3JlX2NxICpjcSkNCj4gIHsNCj4gLQlzdHJ1Y3QgbWx4NV9jcV90YWJsZSAqdGFibGUgPSAm
ZXEtPmNxX3RhYmxlOw0KPiAtCWludCBlcnI7DQo+IC0NCj4gLQlzcGluX2xvY2soJnRhYmxlLT5s
b2NrKTsNCj4gLQllcnIgPSByYWRpeF90cmVlX2luc2VydCgmdGFibGUtPnRyZWUsIGNxLT5jcW4s
IGNxKTsNCj4gLQlzcGluX3VubG9jaygmdGFibGUtPmxvY2spOw0KPiAtDQo+IC0JcmV0dXJuIGVy
cjsNCj4gKwlyZXR1cm4geGFfZXJyKHhhX3N0b3JlKCZlcS0+Y3FfdGFibGUsIGNxLT5jcW4sIGNx
LA0KPiBHRlBfS0VSTkVMKSk7DQo+ICB9DQo+ICANCj4gIHZvaWQgbWx4NV9lcV9kZWxfY3Eoc3Ry
dWN0IG1seDVfZXEgKmVxLCBzdHJ1Y3QgbWx4NV9jb3JlX2NxICpjcSkNCj4gIHsNCj4gLQlzdHJ1
Y3QgbWx4NV9jcV90YWJsZSAqdGFibGUgPSAmZXEtPmNxX3RhYmxlOw0KPiAgCXN0cnVjdCBtbHg1
X2NvcmVfY3EgKnRtcDsNCj4gIA0KPiAtCXNwaW5fbG9jaygmdGFibGUtPmxvY2spOw0KPiAtCXRt
cCA9IHJhZGl4X3RyZWVfZGVsZXRlKCZ0YWJsZS0+dHJlZSwgY3EtPmNxbik7DQo+IC0Jc3Bpbl91
bmxvY2soJnRhYmxlLT5sb2NrKTsNCj4gLQ0KPiArCXRtcCA9IHhhX2VyYXNlKCZlcS0+Y3FfdGFi
bGUsIGNxLT5jcW4pOw0KPiAgCWlmICghdG1wKSB7DQo+ICAJCW1seDVfY29yZV9kYmcoZXEtPmRl
diwgImNxIDB4JXggbm90IGZvdW5kIGluIGVxIDB4JXgNCj4gdHJlZVxuIiwNCj4gIAkJCSAgICAg
IGVxLT5lcW4sIGNxLT5jcW4pOw0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQv
bWVsbGFub3gvbWx4NS9jb3JlL2xpYi9lcS5oDQo+IGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVs
bGFub3gvbWx4NS9jb3JlL2xpYi9lcS5oDQo+IGluZGV4IDRiZTRkMmQzNjIxOC4uYTM0MmNmNzgx
MjBlIDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2Nv
cmUvbGliL2VxLmgNCj4gKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9j
b3JlL2xpYi9lcS5oDQo+IEBAIC0xNiwxNCArMTYsOSBAQCBzdHJ1Y3QgbWx4NV9lcV90YXNrbGV0
IHsNCj4gIAlzcGlubG9ja190ICAgICAgICAgICAgbG9jazsgLyogbG9jayBjb21wbGV0aW9uIHRh
c2tsZXQgbGlzdCAqLw0KPiAgfTsNCj4gIA0KPiAtc3RydWN0IG1seDVfY3FfdGFibGUgew0KPiAt
CXNwaW5sb2NrX3QgICAgICAgICAgICAgIGxvY2s7CS8qIHByb3RlY3QgcmFkaXggdHJlZSAqLw0K
PiAtCXN0cnVjdCByYWRpeF90cmVlX3Jvb3QgIHRyZWU7DQo+IC19Ow0KPiAtDQo+ICBzdHJ1Y3Qg
bWx4NV9lcSB7DQo+ICAJc3RydWN0IG1seDVfY29yZV9kZXYgICAgKmRldjsNCj4gLQlzdHJ1Y3Qg
bWx4NV9jcV90YWJsZSAgICBjcV90YWJsZTsNCj4gKwlzdHJ1Y3QgeGFycmF5CQljcV90YWJsZTsN
Cj4gIAlfX2JlMzIgX19pb21lbQkgICAgICAgICpkb29yYmVsbDsNCj4gIAl1MzIgICAgICAgICAg
ICAgICAgICAgICBjb25zX2luZGV4Ow0KPiAgCXN0cnVjdCBtbHg1X2ZyYWdfYnVmICAgIGJ1ZjsN
Cg==
