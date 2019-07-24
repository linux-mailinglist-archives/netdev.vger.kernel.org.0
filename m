Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79D6774064
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 22:47:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387655AbfGXUrF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 16:47:05 -0400
Received: from mail-eopbgr80057.outbound.protection.outlook.com ([40.107.8.57]:56577
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726698AbfGXUrF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Jul 2019 16:47:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l1xtTvqSF4Ue+j4I/nZ1/I5JTl5UaJN3btB/J4Zp4pJPCu+bWfaHfTlP+8w+c2MLYA42pgF01zDuPw8jkW3cE062uDDmLcsiAxbH2rbByCLawAJw36tWfJcFpDI+VJYIj3zJxp4ivXqIOGuGFUE3BF/o/Y/7rrv8/nQxBmmmVrbYyV3raUjaa1YiFlfAoJYGhkJ1oleLghzcxkY0kACc4EOUqmBeblG5yV1zVvCznCxOIG8phFH4d7JlwLf7sZkBYQ/N4m450FHK/xlzv0yKsE1tx0muyT5DDAMs6Sjov9C7S+N5x+R0D1yOT26JppIuLBpMKhFeqaXVx3//8VL+Cg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V6wY+4SKK1aaGga36Kd3oViDRv4fV2wJUjmYM43lQ80=;
 b=YsnsaqVO94p3qTspoT+8YLrLVU4tJSiM9cxGhc3ecx+vCNzQMAUKmrCqzqvoNU8g+TQOmClMSHZSK8VuFiFrP36uUApL8EPRhSNsAgWa0dP3UOcTqhUGpyAhz2Xi11hUGxaiHk0Fy2LrUHE/l4/lAaehO4p/XpJ2aFbtuWIzCv/aLpeqS0HrwKT4YLKIF+t6QrTp2yK0jUrbbz8ecADQ27TglVk86UoQ0/+XiG2cmC0mk00ph0S+ZrI6L9bvkTfVrT94uJvB8O0yTYsi4LuDL5X8UXpFmEjA1CW+Dt//Zll52eATH5r5OBl/loeyyxwGDS3WrBKwNjWOg7gszYS0/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=mellanox.com;dmarc=pass action=none
 header.from=mellanox.com;dkim=pass header.d=mellanox.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V6wY+4SKK1aaGga36Kd3oViDRv4fV2wJUjmYM43lQ80=;
 b=F6KGeI1+bS/MQh2D4XiXojtnAKKWaJDlja+0OyD7XGd5zrHmdcEQh1tzd+Q7X3VaFvJHdAodVHUCugYWJvhrakiZx/Atx6pRRVfH34uQ/yzjhDZ9jOUWBuDGtaYJVIlkJpBeqcCcdprlYukewjW/wnvpZ7CEckEx3Omk9dNS7Ao=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2613.eurprd05.prod.outlook.com (10.172.225.141) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2094.16; Wed, 24 Jul 2019 20:47:01 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::7148:ecd4:3a7f:f3f]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::7148:ecd4:3a7f:f3f%11]) with mapi id 15.20.2094.011; Wed, 24 Jul 2019
 20:47:01 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "dcaratti@redhat.com" <dcaratti@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Tariq Toukan <tariqt@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 2/2] mlx4/en_netdev: call notifiers when
 hw_enc_features change
Thread-Topic: [PATCH net-next 2/2] mlx4/en_netdev: call notifiers when
 hw_enc_features change
Thread-Index: AQHVQiiqTJlSndEpEUiixXCmHX0hZabaPY6A
Date:   Wed, 24 Jul 2019 20:47:00 +0000
Message-ID: <e007bac4c951486294d4e69d20f7c9ed7040172d.camel@mellanox.com>
References: <cover.1563976690.git.dcaratti@redhat.com>
         <e157af6e79d9385df37444d817cf3c166878c8f6.1563976690.git.dcaratti@redhat.com>
In-Reply-To: <e157af6e79d9385df37444d817cf3c166878c8f6.1563976690.git.dcaratti@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.4 (3.32.4-1.fc30) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 03fa0a4f-b693-4419-8356-08d7107813cd
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2613;
x-ms-traffictypediagnostic: DB6PR0501MB2613:
x-microsoft-antispam-prvs: <DB6PR0501MB2613AC778F940F6CD5907A6ABEC60@DB6PR0501MB2613.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2399;
x-forefront-prvs: 0108A997B2
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(346002)(396003)(136003)(39860400002)(366004)(199004)(189003)(14454004)(99286004)(26005)(68736007)(2616005)(118296001)(305945005)(81166006)(81156014)(2906002)(6246003)(7736002)(446003)(6512007)(36756003)(5660300002)(53936002)(86362001)(3846002)(6116002)(8936002)(11346002)(76176011)(66556008)(66066001)(102836004)(14444005)(6436002)(256004)(110136005)(6486002)(71190400001)(71200400001)(66476007)(476003)(64756008)(25786009)(66946007)(91956017)(76116006)(186003)(486006)(2501003)(478600001)(316002)(8676002)(66446008)(229853002)(58126008)(6506007);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2613;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: UtxzhbWaPnDZipSV45t+OKYYMVoUMNyQ0z5EFAC+lG3axW1umcBGc7IWcP05FoAXyyXhg5ILTvS36rVIy6FdXYh5MQdEaB7l0F6lRIsokty0HF5gcK59ZtKw5eB4ZfovqOQGdPldxkpLczs2SJrIeWtJmMKCQKWHw5RTUkbaw2YPHyc1e0hfHjAkxdDQWkiTSwZmSb9XD2w8J8zOFM0MAogtyBvhBAlXW3vcwckMqKvu5KLQ4/aGyTX3B0xDY7dTjVeoPbQzocuV1wrG4PscqIRUPrBMxSHn9fvYFO/T32MahM+O8tOXw/m90x7IdoVvhimvhtqj6xaRte3V+wwPzYgE2TbEOtkcBJdQezG+06LOQvPTwdb7U71E1p6Igo7x37DVawtjlAB8+cwWvkEB9PCz2JWSkjOzz0qy6/L6U/A=
Content-Type: text/plain; charset="utf-8"
Content-ID: <664C108EB4FB0640AC5487D900A9883D@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 03fa0a4f-b693-4419-8356-08d7107813cd
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jul 2019 20:47:00.9600
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2613
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCAyMDE5LTA3LTI0IGF0IDE2OjAyICswMjAwLCBEYXZpZGUgQ2FyYXR0aSB3cm90ZToN
Cj4gZW5zdXJlIHRvIGNhbGwgbmV0ZGV2X2ZlYXR1cmVzX2NoYW5nZSgpIHdoZW4gdGhlIGRyaXZl
ciBmbGlwcyBpdHMNCj4gaHdfZW5jX2ZlYXR1cmVzIGJpdHMuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5
OiBEYXZpZGUgQ2FyYXR0aSA8ZGNhcmF0dGlAcmVkaGF0LmNvbT4NCg0KVGhlIHBhdGNoIGlzIGNv
cnJlY3QsIGJ1dCBjYW4geW91IGV4cGxhaW4gaG93IGRpZCB5b3UgY29tZSB0byB0aGlzID8gDQpk
aWQgeW91IGVuY291bnRlciBhbnkgaXNzdWUgd2l0aCB0aGUgY3VycmVudCBjb2RlID8NCg0KSSBh
bSBhc2tpbmcganVzdCBiZWNhdXNlIGkgdGhpbmsgdGhlIHdob2xlIGR5bmFtaWMgY2hhbmdpbmcg
b2YgZGV2LQ0KPmh3X2VuY19mZWF0dXJlcyBpcyByZWR1bmRhbnQgc2luY2UgbWx4NCBoYXMgdGhl
IGZlYXR1dHJlc19jaGVjaw0KY2FsbGJhY2suDQoNCj4gLS0tDQo+ICAuLi4vbmV0L2V0aGVybmV0
L21lbGxhbm94L21seDQvZW5fbmV0ZGV2LmMgICAgfCAzOSArKysrKysrKysrKystLS0tLQ0KPiAt
LQ0KPiAgMSBmaWxlIGNoYW5nZWQsIDI2IGluc2VydGlvbnMoKyksIDEzIGRlbGV0aW9ucygtKQ0K
PiANCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDQvZW5f
bmV0ZGV2LmMNCj4gYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg0L2VuX25ldGRl
di5jDQo+IGluZGV4IDUyNTAwZjc0NGEwZS4uMWI0ODRkYzZlMWMyIDEwMDY0NA0KPiAtLS0gYS9k
cml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg0L2VuX25ldGRldi5jDQo+ICsrKyBiL2Ry
aXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDQvZW5fbmV0ZGV2LmMNCj4gQEAgLTI2Mjgs
NiArMjYyOCwzMCBAQCBzdGF0aWMgaW50IG1seDRfZW5fZ2V0X3BoeXNfcG9ydF9pZChzdHJ1Y3QN
Cj4gbmV0X2RldmljZSAqZGV2LA0KPiAgCXJldHVybiAwOw0KPiAgfQ0KPiAgDQo+ICsjZGVmaW5l
IE1MWDRfR1NPX1BBUlRJQUxfRkVBVFVSRVMgKE5FVElGX0ZfSVBfQ1NVTSB8DQo+IE5FVElGX0Zf
SVBWNl9DU1VNIHwgXA0KPiArCQkJCSAgIE5FVElGX0ZfUlhDU1VNIHwgXA0KPiArCQkJCSAgIE5F
VElGX0ZfVFNPIHwgTkVUSUZfRl9UU082IHwgXA0KPiArCQkJCSAgIE5FVElGX0ZfR1NPX1VEUF9U
VU5ORUwgfCBcDQo+ICsJCQkJICAgTkVUSUZfRl9HU09fVURQX1RVTk5FTF9DU1VNIHwgXA0KPiAr
CQkJCSAgIE5FVElGX0ZfR1NPX1BBUlRJQUwpDQo+ICsNCj4gK3N0YXRpYyB2b2lkIG1seDRfc2V0
X3Z4bGFuX29mZmxvYWRzKHN0cnVjdCBuZXRfZGV2aWNlICpkZXYsIGJvb2wNCj4gZW5hYmxlKQ0K
PiArew0KPiArCW5ldGRldl9mZWF0dXJlc190IGh3X2VuY19mZWF0dXJlczsNCj4gKw0KPiArCXJ0
bmxfbG9jaygpOw0KPiArCWh3X2VuY19mZWF0dXJlcyA9IGRldi0+aHdfZW5jX2ZlYXR1cmVzOw0K
PiArCWlmIChlbmFibGUpDQo+ICsJCWRldi0+aHdfZW5jX2ZlYXR1cmVzIHw9IE1MWDRfR1NPX1BB
UlRJQUxfRkVBVFVSRVM7DQo+ICsJZWxzZQ0KPiArCQlkZXYtPmh3X2VuY19mZWF0dXJlcyAmPSB+
TUxYNF9HU09fUEFSVElBTF9GRUFUVVJFUzsNCj4gKw0KPiArCWlmIChod19lbmNfZmVhdHVyZXMg
XiBkZXYtPmh3X2VuY19mZWF0dXJlcykNCj4gKwkJbmV0ZGV2X2ZlYXR1cmVzX2NoYW5nZShkZXYp
Ow0KPiArDQo+ICsJcnRubF91bmxvY2soKTsNCj4gK30NCj4gKw0KPiAgc3RhdGljIHZvaWQgbWx4
NF9lbl9hZGRfdnhsYW5fb2ZmbG9hZHMoc3RydWN0IHdvcmtfc3RydWN0ICp3b3JrKQ0KPiAgew0K
PiAgCWludCByZXQ7DQo+IEBAIC0yNjQ3LDEyICsyNjcxLDcgQEAgc3RhdGljIHZvaWQgbWx4NF9l
bl9hZGRfdnhsYW5fb2ZmbG9hZHMoc3RydWN0DQo+IHdvcmtfc3RydWN0ICp3b3JrKQ0KPiAgCX0N
Cj4gIA0KPiAgCS8qIHNldCBvZmZsb2FkcyAqLw0KPiAtCXByaXYtPmRldi0+aHdfZW5jX2ZlYXR1
cmVzIHw9IE5FVElGX0ZfSVBfQ1NVTSB8DQo+IE5FVElGX0ZfSVBWNl9DU1VNIHwNCj4gLQkJCQkg
ICAgICBORVRJRl9GX1JYQ1NVTSB8DQo+IC0JCQkJICAgICAgTkVUSUZfRl9UU08gfCBORVRJRl9G
X1RTTzYgfA0KPiAtCQkJCSAgICAgIE5FVElGX0ZfR1NPX1VEUF9UVU5ORUwgfA0KPiAtCQkJCSAg
ICAgIE5FVElGX0ZfR1NPX1VEUF9UVU5ORUxfQ1NVTSB8DQo+IC0JCQkJICAgICAgTkVUSUZfRl9H
U09fUEFSVElBTDsNCj4gKwltbHg0X3NldF92eGxhbl9vZmZsb2Fkcyhwcml2LT5kZXYsIHRydWUp
Ow0KPiAgfQ0KPiAgDQo+ICBzdGF0aWMgdm9pZCBtbHg0X2VuX2RlbF92eGxhbl9vZmZsb2Fkcyhz
dHJ1Y3Qgd29ya19zdHJ1Y3QgKndvcmspDQo+IEBAIC0yNjYxLDEzICsyNjgwLDcgQEAgc3RhdGlj
IHZvaWQgbWx4NF9lbl9kZWxfdnhsYW5fb2ZmbG9hZHMoc3RydWN0DQo+IHdvcmtfc3RydWN0ICp3
b3JrKQ0KPiAgCXN0cnVjdCBtbHg0X2VuX3ByaXYgKnByaXYgPSBjb250YWluZXJfb2Yod29yaywg
c3RydWN0DQo+IG1seDRfZW5fcHJpdiwNCj4gIAkJCQkJCSB2eGxhbl9kZWxfdGFzayk7DQo+ICAJ
LyogdW5zZXQgb2ZmbG9hZHMgKi8NCj4gLQlwcml2LT5kZXYtPmh3X2VuY19mZWF0dXJlcyAmPSB+
KE5FVElGX0ZfSVBfQ1NVTSB8DQo+IE5FVElGX0ZfSVBWNl9DU1VNIHwNCj4gLQkJCQkJTkVUSUZf
Rl9SWENTVU0gfA0KPiAtCQkJCQlORVRJRl9GX1RTTyB8IE5FVElGX0ZfVFNPNiB8DQo+IC0JCQkJ
CU5FVElGX0ZfR1NPX1VEUF9UVU5ORUwgfA0KPiAtCQkJCQlORVRJRl9GX0dTT19VRFBfVFVOTkVM
X0NTVU0gfA0KPiAtCQkJCQlORVRJRl9GX0dTT19QQVJUSUFMKTsNCj4gLQ0KPiArCW1seDRfc2V0
X3Z4bGFuX29mZmxvYWRzKHByaXYtPmRldiwgZmFsc2UpOw0KPiAgCXJldCA9IG1seDRfU0VUX1BP
UlRfVlhMQU4ocHJpdi0+bWRldi0+ZGV2LCBwcml2LT5wb3J0LA0KPiAgCQkJCSAgVlhMQU5fU1RF
RVJfQllfT1VURVJfTUFDLCAwKTsNCj4gIAlpZiAocmV0KQ0K
