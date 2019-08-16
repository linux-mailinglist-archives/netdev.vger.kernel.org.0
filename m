Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5FB1A8FB59
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 08:48:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726924AbfHPGrS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Aug 2019 02:47:18 -0400
Received: from mail-eopbgr00058.outbound.protection.outlook.com ([40.107.0.58]:58326
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725945AbfHPGrS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Aug 2019 02:47:18 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O8SklFk24FWjZRo/ZwwLa/vprBdnOB0+oAYuye72AjLAxD7+VqBSTGDbzCEBp8COb5s93lWa3B5Y4ywWGjknQgX+TCgX+efgCAeP9TACzoUKisoIjYckBrQnHbtL1RykFJlP7xrOvQUNRp30ClP/x3IQuRtV6gC4Pf5byGsIdZQYunlH94u+JHZPVkCOVYRTojVzSgSY0BFjhxLjNRDzXrWzBMSuD6z1j3V9yZB4d9T2COoV76qrsgw1JxmJ0sLxETjr79iLthMygid+fY9oOD8nTXfewdyCI1fr47FI9qGyCIzRtyxuM3NpPht763rIZQayIqwqw9TUy2SmXWcqYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fg2UMvId9ttnCyTZAFOgM5g1NTEX/veGQYS1W0oF9VM=;
 b=DXdm/T9p4KWpIrTxq44fEG5YDIgfIsaeeZIgZXPSHntJv54J/rk4PQUmeVVIOWvJTu4HTN+XXH7LIihILBlOGjMWWGF/x95vM/yY5WBdbRnLMGz7CisMtrfjSAjtbB8U1Qwj6svOk0rZRYmsZ7GubiIUw5YFAtemj5VkRcdLEw4Z1OxPgw8z40Txtynsa0TISvR5hELoduvOiTCKtPUlpRqjJ8Db0z1XwKzsevKwF8Gv08K822gG+wuJI0xwCVuD15c38ZZSHmA/lLcMmuTf43MqR8gHaIXNkq4W77mLSe3468hgcvNUfrgX61a/8SYEhmf55NzalFRY4+M2Z4W6aQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fg2UMvId9ttnCyTZAFOgM5g1NTEX/veGQYS1W0oF9VM=;
 b=g73qe5S4l0XaGz1QHIoHt+sQSDHrbGVjagZb2I8yDwMcZK2Wsmg43wcuYNzCiva4aOJR+oaxOg/xAVIyugRwQmZiE/uB00ul72sIsrkZXrbbOW4STXmYeoQGc79m0FhuESMNzgXm8qcaZQWGtKjzU5WNGvt80RHqAO2bkGeB3Ng=
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com (52.135.139.151) by
 DB7PR04MB5353.eurprd04.prod.outlook.com (20.178.85.210) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.16; Fri, 16 Aug 2019 06:47:14 +0000
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::c8ca:1c9c:6c3:fb6f]) by DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::c8ca:1c9c:6c3:fb6f%4]) with mapi id 15.20.2157.022; Fri, 16 Aug 2019
 06:47:14 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     "mkl@pengutronix.de" <mkl@pengutronix.de>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "sean@geanix.com" <sean@geanix.com>
CC:     "wg@grandegger.com" <wg@grandegger.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: RE: [PATCH V2] can: flexcan: fix deadlock when using self wakeup
Thread-Topic: [PATCH V2] can: flexcan: fix deadlock when using self wakeup
Thread-Index: AQHVRoGwsLQOjsyzvkSdF4oGtikKDqb9b7Rw
Date:   Fri, 16 Aug 2019 06:47:13 +0000
Message-ID: <DB7PR04MB461880A3451F057E88FB5815E6AF0@DB7PR04MB4618.eurprd04.prod.outlook.com>
References: <20190730024834.31182-1-qiangqing.zhang@nxp.com>
In-Reply-To: <20190730024834.31182-1-qiangqing.zhang@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=qiangqing.zhang@nxp.com; 
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b7fbca3b-12fe-4beb-ffa1-08d72215924d
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:DB7PR04MB5353;
x-ms-traffictypediagnostic: DB7PR04MB5353:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB7PR04MB5353927C8022E04FE3CBF216E6AF0@DB7PR04MB5353.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0131D22242
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(376002)(136003)(346002)(366004)(396003)(13464003)(189003)(199004)(54534003)(9686003)(229853002)(6436002)(4326008)(446003)(26005)(55016002)(53936002)(8676002)(81166006)(81156014)(6506007)(476003)(478600001)(5660300002)(53546011)(110136005)(54906003)(71190400001)(71200400001)(66066001)(99286004)(11346002)(5024004)(14444005)(486006)(2906002)(25786009)(256004)(186003)(102836004)(76176011)(316002)(7696005)(3846002)(76116006)(6116002)(569044001)(66556008)(66446008)(66476007)(64756008)(66946007)(305945005)(2501003)(7736002)(74316002)(86362001)(33656002)(8936002)(6246003)(14454004)(52536014)(2201001);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7PR04MB5353;H:DB7PR04MB4618.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: /9kWYuCJnlPAcfiAx6XqictIXm2XAi1mGsrxkfiAHX5H8X8Sz4d/mcbFT2HM75qfLuwoCwsGkPu4Ba8GcslMlvSXhCPcuhf6zdd8TfJtw3y2wk6vFS27UN1rbPgolUm2Rjn+zdjOtxTelPmozbVHKzDyS6JjmnWbZboupxJ2JislshHs4rwF8aqaBqx8JhicCLAfQdQAkhFQrsY2LNeKLdPeaUu/Oe5utY4sDd3I9hwelR7gNM/QCfoPRmraJWk/qFYYRJCbG8hYNRTV/bjxTABe2nmCNOnnlvp2n8c3mEN6JL+aeWEAdzVPIbgmhVo5zGScNDGfdtCv+uBXCmfV92iUf8RYF+9AsclYENWDPOkFsOcCAd+vmSP13doLav70uCo+Qj2Z+Y3ArGMUkSK7+kR/Tj4jo+/vaAHfQZfQYMo=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b7fbca3b-12fe-4beb-ffa1-08d72215924d
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Aug 2019 06:47:13.9697
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nPj8u74grLOPoVHiYo6JR6DPxWnuQRBxqXur50CTLVhOlYPz4EzdG/4D+nM0xj+BAH+pDXJ/jWgSnSjdVgxTNQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB5353
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpLaW5kbHkgUGluZy4uLg0KDQpCZXN0IFJlZ2FyZHMsDQpKb2FraW0gWmhhbmcNCg0KPiAtLS0t
LU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBKb2FraW0gWmhhbmcNCj4gU2VudDogMjAx
OcTqN9TCMzDI1SAxMDo1Mg0KPiBUbzogbWtsQHBlbmd1dHJvbml4LmRlOyBsaW51eC1jYW5Admdl
ci5rZXJuZWwub3JnOyBzZWFuQGdlYW5peC5jb20NCj4gQ2M6IHdnQGdyYW5kZWdnZXIuY29tOyBu
ZXRkZXZAdmdlci5rZXJuZWwub3JnOyBkbC1saW51eC1pbXgNCj4gPGxpbnV4LWlteEBueHAuY29t
PjsgSm9ha2ltIFpoYW5nIDxxaWFuZ3FpbmcuemhhbmdAbnhwLmNvbT4NCj4gU3ViamVjdDogW1BB
VENIIFYyXSBjYW46IGZsZXhjYW46IGZpeCBkZWFkbG9jayB3aGVuIHVzaW5nIHNlbGYgd2FrZXVw
DQo+IA0KPiBBcyByZXByb3RlZCBieSBTZWFuIE55ZWtqYWVyIGJlbG93Og0KPiBXaGVuIHN1c3Bl
bmRpbmcsIHdoZW4gdGhlcmUgaXMgc3RpbGwgY2FuIHRyYWZmaWMgb24gdGhlIGludGVyZmFjZXMg
dGhlIGZsZXhjYW4NCj4gaW1tZWRpYXRlbHkgd2FrZXMgdGhlIHBsYXRmb3JtIGFnYWluLiBBcyBp
dCBzaG91bGQgOi0pLiBCdXQgaXQgdGhyb3dzIHRoaXMgZXJyb3INCj4gbXNnOg0KPiBbIDMxNjku
Mzc4NjYxXSBQTTogbm9pcnEgc3VzcGVuZCBvZiBkZXZpY2VzIGZhaWxlZA0KPiANCj4gT24gdGhl
IHdheSBkb3duIHRvIHN1c3BlbmQgdGhlIGludGVyZmFjZSB0aGF0IHRocm93cyB0aGUgZXJyb3Ig
bWVzc2FnZSBkb2VzDQo+IGNhbGwgZmxleGNhbl9zdXNwZW5kIGJ1dCBmYWlscyB0byBjYWxsIGZs
ZXhjYW5fbm9pcnFfc3VzcGVuZC4gVGhhdCBtZWFucyB0aGUNCj4gZmxleGNhbl9lbnRlcl9zdG9w
X21vZGUgaXMgY2FsbGVkLCBidXQgb24gdGhlIHdheSBvdXQgb2Ygc3VzcGVuZCB0aGUgZHJpdmVy
DQo+IG9ubHkgY2FsbHMgZmxleGNhbl9yZXN1bWUgYW5kIHNraXBzIGZsZXhjYW5fbm9pcnFfcmVz
dW1lLCB0aHVzIGl0IGRvZXNuJ3QgY2FsbA0KPiBmbGV4Y2FuX2V4aXRfc3RvcF9tb2RlLiBUaGlz
IGxlYXZlcyB0aGUgZmxleGNhbiBpbiBzdG9wIG1vZGUsIGFuZCB3aXRoIHRoZQ0KPiBjdXJyZW50
IGRyaXZlciBpdCBjYW4ndCByZWNvdmVyIGZyb20gdGhpcyBldmVuIHdpdGggYSBzb2Z0IHJlYm9v
dCwgaXQgcmVxdWlyZXMgYQ0KPiBoYXJkIHJlYm9vdC4NCj4gDQo+IFRoZSBiZXN0IHdheSB0byBl
eGl0IHN0b3AgbW9kZSBpcyBpbiBXYWtlIFVwIGludGVycnVwdCBjb250ZXh0LCBhbmQgdGhlbg0K
PiBzdXNwZW5kKCkgYW5kIHJlc3VtZSgpIGZ1bmN0aW9ucyBjYW4gYmUgc3ltbWV0cmljLiBIb3dl
dmVyLCBzdG9wIG1vZGUNCj4gcmVxdWVzdCBhbmQgYWNrIHdpbGwgYmUgY29udHJvbGxlZCBieSBT
Q1UoU3lzdGVtIENvbnRyb2wgVW5pdCkNCj4gZmlybXdhcmUobWFuYWdlIGNsb2NrLHBvd2VyLHN0
b3AgbW9kZSwgZXRjLiBieSBDb3J0ZXgtTTQgY29yZSkgaW4gY29taW5nDQo+IGkuTVg4KFFNL1FY
UCkuIEFuZCBTQ1UgZmlybXdhcmUgaW50ZXJmYWNlIGNhbid0IGJlIGF2YWlsYWJsZSBpbiBpbnRl
cnJ1cHQNCj4gY29udGV4dC4NCj4gDQo+IEZvciBjb21wYXRpYmlsbGl0eSwgdGhlIHdha2UgdXAg
bWVjaGFuaXNtIGNhbid0IGJlIHN5bW1ldHJpYywgc28gd2UgbmVlZA0KPiBpbl9zdG9wX21vZGUg
aGFjay4NCj4gDQo+IEZpeGVzOiBkZTM1NzhjMTk4YzYgKCJjYW46IGZsZXhjYW46IGFkZCBzZWxm
IHdha2V1cCBzdXBwb3J0IikNCj4gUmVwb3J0ZWQtYnk6IFNlYW4gTnlla2phZXIgPHNlYW5AZ2Vh
bml4LmNvbT4NCj4gU2lnbmVkLW9mZi1ieTogSm9ha2ltIFpoYW5nIDxxaWFuZ3FpbmcuemhhbmdA
bnhwLmNvbT4NCj4gDQo+IENoYW5nZWxvZzoNCj4gVjEtPlYyOg0KPiAJKiBhZGQgUmVwb3J0ZWQt
YnkgdGFnLg0KPiAJKiByZWJhc2Ugb24gcGF0Y2g6IGNhbjpmbGV4Y2FuOmZpeCBzdG9wIG1vZGUg
YWNrbm93bGVkZ21lbnQuDQo+IC0tLQ0KPiAgZHJpdmVycy9uZXQvY2FuL2ZsZXhjYW4uYyB8IDIz
ICsrKysrKysrKysrKysrKysrKysrKysrDQo+ICAxIGZpbGUgY2hhbmdlZCwgMjMgaW5zZXJ0aW9u
cygrKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2Nhbi9mbGV4Y2FuLmMgYi9kcml2
ZXJzL25ldC9jYW4vZmxleGNhbi5jIGluZGV4DQo+IGZjZWM4YmNiNTNkNi4uMWRiZWM4NjhkM2Vh
IDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL25ldC9jYW4vZmxleGNhbi5jDQo+ICsrKyBiL2RyaXZl
cnMvbmV0L2Nhbi9mbGV4Y2FuLmMNCj4gQEAgLTI4Miw2ICsyODIsNyBAQCBzdHJ1Y3QgZmxleGNh
bl9wcml2IHsNCj4gIAljb25zdCBzdHJ1Y3QgZmxleGNhbl9kZXZ0eXBlX2RhdGEgKmRldnR5cGVf
ZGF0YTsNCj4gIAlzdHJ1Y3QgcmVndWxhdG9yICpyZWdfeGNlaXZlcjsNCj4gIAlzdHJ1Y3QgZmxl
eGNhbl9zdG9wX21vZGUgc3RtOw0KPiArCWJvb2wgaW5fc3RvcF9tb2RlOw0KPiANCj4gIAkvKiBS
ZWFkIGFuZCBXcml0ZSBBUElzICovDQo+ICAJdTMyICgqcmVhZCkodm9pZCBfX2lvbWVtICphZGRy
KTsNCj4gQEAgLTE2MzUsNiArMTYzNiw4IEBAIHN0YXRpYyBpbnQgX19tYXliZV91bnVzZWQgZmxl
eGNhbl9zdXNwZW5kKHN0cnVjdA0KPiBkZXZpY2UgKmRldmljZSkNCj4gIAkJCWVyciA9IGZsZXhj
YW5fZW50ZXJfc3RvcF9tb2RlKHByaXYpOw0KPiAgCQkJaWYgKGVycikNCj4gIAkJCQlyZXR1cm4g
ZXJyOw0KPiArDQo+ICsJCQlwcml2LT5pbl9zdG9wX21vZGUgPSB0cnVlOw0KPiAgCQl9IGVsc2Ug
ew0KPiAgCQkJZXJyID0gZmxleGNhbl9jaGlwX2Rpc2FibGUocHJpdik7DQo+ICAJCQlpZiAoZXJy
KQ0KPiBAQCAtMTY1OSw2ICsxNjYyLDE1IEBAIHN0YXRpYyBpbnQgX19tYXliZV91bnVzZWQgZmxl
eGNhbl9yZXN1bWUoc3RydWN0DQo+IGRldmljZSAqZGV2aWNlKQ0KPiAgCQluZXRpZl9kZXZpY2Vf
YXR0YWNoKGRldik7DQo+ICAJCW5ldGlmX3N0YXJ0X3F1ZXVlKGRldik7DQo+ICAJCWlmIChkZXZp
Y2VfbWF5X3dha2V1cChkZXZpY2UpKSB7DQo+ICsJCQlpZiAocHJpdi0+aW5fc3RvcF9tb2RlKSB7
DQo+ICsJCQkJZmxleGNhbl9lbmFibGVfd2FrZXVwX2lycShwcml2LCBmYWxzZSk7DQo+ICsJCQkJ
ZXJyID0gZmxleGNhbl9leGl0X3N0b3BfbW9kZShwcml2KTsNCj4gKwkJCQlpZiAoZXJyKQ0KPiAr
CQkJCQlyZXR1cm4gIGVycjsNCj4gKw0KPiArCQkJCXByaXYtPmluX3N0b3BfbW9kZSA9IGZhbHNl
Ow0KPiArCQkJfQ0KPiArDQo+ICAJCQlkaXNhYmxlX2lycV93YWtlKGRldi0+aXJxKTsNCj4gIAkJ
fSBlbHNlIHsNCj4gIAkJCWVyciA9IGZsZXhjYW5fY2hpcF9lbmFibGUocHJpdik7DQo+IEBAIC0x
Njc0LDYgKzE2ODYsMTEgQEAgc3RhdGljIGludCBfX21heWJlX3VudXNlZA0KPiBmbGV4Y2FuX25v
aXJxX3N1c3BlbmQoc3RydWN0IGRldmljZSAqZGV2aWNlKQ0KPiAgCXN0cnVjdCBuZXRfZGV2aWNl
ICpkZXYgPSBkZXZfZ2V0X2RydmRhdGEoZGV2aWNlKTsNCj4gIAlzdHJ1Y3QgZmxleGNhbl9wcml2
ICpwcml2ID0gbmV0ZGV2X3ByaXYoZGV2KTsNCj4gDQo+ICsJLyogTmVlZCB0byBlbmFibGUgd2Fr
ZXVwIGludGVycnVwdCBpbiBub2lycSBzdXNwZW5kIHN0YWdlLiBPdGhlcndpc2UsDQo+ICsJICog
aXQgd2lsbCB0cmlnZ2VyIGNvbnRpbnVvdXNseSB3YWtldXAgaW50ZXJydXB0IGlmIHRoZSB3YWtl
dXAgZXZlbnQNCj4gKwkgKiBjb21lcyBiZWZvcmUgbm9pcnEgc3VzcGVuZCBzdGFnZSwgYW5kIHNp
bXVsdGFuZW91c2x5IGl0IGhhcyBlbnRlcg0KPiArCSAqIHRoZSBzdG9wIG1vZGUuDQo+ICsJICov
DQo+ICAJaWYgKG5ldGlmX3J1bm5pbmcoZGV2KSAmJiBkZXZpY2VfbWF5X3dha2V1cChkZXZpY2Up
KQ0KPiAgCQlmbGV4Y2FuX2VuYWJsZV93YWtldXBfaXJxKHByaXYsIHRydWUpOw0KPiANCj4gQEAg
LTE2ODYsMTEgKzE3MDMsMTcgQEAgc3RhdGljIGludCBfX21heWJlX3VudXNlZA0KPiBmbGV4Y2Fu
X25vaXJxX3Jlc3VtZShzdHJ1Y3QgZGV2aWNlICpkZXZpY2UpDQo+ICAJc3RydWN0IGZsZXhjYW5f
cHJpdiAqcHJpdiA9IG5ldGRldl9wcml2KGRldik7DQo+ICAJaW50IGVycjsNCj4gDQo+ICsJLyog
TmVlZCB0byBleGl0IHN0b3AgbW9kZSBpbiBub2lycSByZXN1bWUgc3RhZ2UuIE90aGVyd2lzZSwg
aXQgd2lsbA0KPiArCSAqIHRyaWdnZXIgY29udGludW91c2x5IHdha2V1cCBpbnRlcnJ1cHQgaWYg
dGhlIHdha2V1cCBldmVudCBjb21lcywNCj4gKwkgKiBhbmQgc2ltdWx0YW5lb3VzbHkgaXQgaGFz
IHN0aWxsIGluIHN0b3AgbW9kZS4NCj4gKwkgKi8NCj4gIAlpZiAobmV0aWZfcnVubmluZyhkZXYp
ICYmIGRldmljZV9tYXlfd2FrZXVwKGRldmljZSkpIHsNCj4gIAkJZmxleGNhbl9lbmFibGVfd2Fr
ZXVwX2lycShwcml2LCBmYWxzZSk7DQo+ICAJCWVyciA9IGZsZXhjYW5fZXhpdF9zdG9wX21vZGUo
cHJpdik7DQo+ICAJCWlmIChlcnIpDQo+ICAJCQlyZXR1cm4gZXJyOw0KPiArDQo+ICsJCXByaXYt
PmluX3N0b3BfbW9kZSA9IGZhbHNlOw0KPiAgCX0NCj4gDQo+ICAJcmV0dXJuIDA7DQo+IC0tDQo+
IDIuMTcuMQ0KDQo=
