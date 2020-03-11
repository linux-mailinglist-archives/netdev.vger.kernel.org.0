Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE3C71813B3
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 09:53:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728514AbgCKIvA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 04:51:00 -0400
Received: from mail-eopbgr80049.outbound.protection.outlook.com ([40.107.8.49]:16366
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726160AbgCKIvA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Mar 2020 04:51:00 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=auNrqoE3Lrflp3sT2AiN6+INMEilEANO9J8x+omzQjNUiJsNYMwz2ecbp8B7/q4IJKiDcx2I/3iDSgDEaI+EuI2ojyRyY6xLP7VFu6pHGceWLYOjGVaz/WgTWTxMtE8hNWEfGWf3fbpslHJyV1D10uHuUkqwJ8kd7U0nOCWVR2vTOuFE2Enm6eAd25rv2hl4l04EjzEFAUGBFChMeVoLMPd9zFBpxLaRQ4g6f7OYfKwbgHGFored7zqn2CPk2fKXqQ2PR7ZN2DzitX908Lk0+drnCXiYbvks7bxV6tDAyWWZmTavxLvXYv+F2uTWDQOOgfYx6CPw6mD6VVUjgADqZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YaqSMg29iqJWTPhNqNcWm7gEzB7bKuPq5OmkrHpT0Lc=;
 b=HCPCJtF2wR+UNsxyoRjxslKBFpMnguUdFZSMX9sU2ES//os3pMnWnkV1cQjKAtrwRZI9JZARzGbzlxlIXOU9MTgyVh0v4eUYZzJxbrh0umifCAf4qr/pAbw8jhTIka5yYLLL6jE54HMKTcRzYeTAyGnwc6fMovRzUI0Uim8td15+5uzVF0xBFoUOw+KUt6Q/bKe7SJw2sOWUpkNsnuUpVnhFKwqRPG0uZ1bbuu8iyyR9AshT+I7GUIyAzN0v+HX4dvxJdIDLVirCa4ghoZW4ed6xSAYUFi4TFLr7Wlox0N/ZthbTBojw0GmiKZ/GC96gsislxvR8TaMZxxB2xV+9jQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YaqSMg29iqJWTPhNqNcWm7gEzB7bKuPq5OmkrHpT0Lc=;
 b=VPAPlk88goKkd8V7mxRa/4UQ9XYglYfgDzUK6Q8HrwdHLH10GW/fPLerUOmUvLR47v/6qtFwjSbRPDsSJKwjcx98CLS9QikQZ++KPWcarnPv1y/ucBCZDDarjlrLDEJDAEnWVGN8/erFVO3UsXkJZhe8REmrBhiF4UOiq0eqTCE=
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com (52.135.139.151) by
 DB7PR04MB4250.eurprd04.prod.outlook.com (52.135.131.24) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2814.14; Wed, 11 Mar 2020 08:50:55 +0000
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::e449:ea49:c382:9788]) by DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::e449:ea49:c382:9788%5]) with mapi id 15.20.2793.018; Wed, 11 Mar 2020
 08:50:55 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     "mkl@pengutronix.de" <mkl@pengutronix.de>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>
CC:     dl-linux-imx <linux-imx@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH linux-can-next] can: flexcan: add correctable errors
 correction when HW supports ECC
Thread-Topic: [PATCH linux-can-next] can: flexcan: add correctable errors
 correction when HW supports ECC
Thread-Index: AQHV4ZpuD9M/oBOk00ewwUwiapKE1qhDQO+w
Date:   Wed, 11 Mar 2020 08:50:55 +0000
Message-ID: <DB7PR04MB4618848506D2B1B4ECF00D0CE6FC0@DB7PR04MB4618.eurprd04.prod.outlook.com>
References: <20200212114620.15416-1-qiangqing.zhang@nxp.com>
In-Reply-To: <20200212114620.15416-1-qiangqing.zhang@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=qiangqing.zhang@nxp.com; 
x-originating-ip: [222.93.243.135]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 201a9ef0-716e-4b21-627e-08d7c5994ff0
x-ms-traffictypediagnostic: DB7PR04MB4250:|DB7PR04MB4250:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB7PR04MB425003F6F625F0C8ABB7B9A4E6FC0@DB7PR04MB4250.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:923;
x-forefront-prvs: 0339F89554
x-forefront-antispam-report: SFV:NSPM;SFS:(10019001)(6009001)(428001)(51704005)(13464003)(199002)(189002)(20776003)(69226001)(63696002)(74876001)(74706001)(54606006)(33656001)(77096001)(76786001)(76796001)(81542001)(54356001)(93136001)(92566001)(46102001)(64706001)(76576001)(81342001)(92726001)(77982001)(59766001)(56816005)(80022001)(66066001)(76482001)(74316001)(90146001)(65816001)(87936001)(56776001)(54316002)(74366001)(44376005)(87266001)(54206007)(2656002)(4396001)(47976001)(50986001)(95666003)(49866001)(47736001)(51856001)(569044001)(85306002)(79102001)(85852003)(83072002)(21056001)(97336001)(94946001)(93516002)(95416001)(94316002)(86362001)(97186001)(80976001)(81686001)(83322001)(19580405001)(81816001)(31966008)(74662001)(19580395003)(53806001)(74502001)(47446002);DIR:OUT;SFP:1102;SCL:1;SRVR:DB7PR04MB4250;H:DB7PR04MB4618.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: RsAGeglU8hUKkAi4VZilN9KwSUuCb89AFTP8xiS4MJHxj/AptZg0tvDbjNyIiF6yoMM5+0WoEX9RZifSexcj9xopWowQ9mSlMn6uJrJ6/EYH1lR7GRmBQduZKdw1cMDwvTXvHzNKzU2YMeL1ECtftMRCV2afKJiX0Wr2Z3UNUqjLGPch1A4e1UaGGbH361iFtgOZ+8u5iYW239NzeqmmEnb8FkxRYJ4uFK5sPbS/IS1jx4UxR9Wkv1Fm+3EV4On/HdaS+qSObKZppgfBrTBbNNWvJNiCc5oD0WGRfVmMvPb07gj5tRkqsgxk0snNYkuh1sgSt6eNOBzjdvVd82NCL/6qr+opGGCh1ZRSH5bkw/3/Bh5s8wbZxbxSBBuhIbfv9dbP+iPRS4Deyaddh+KhjS06kOVx8hQ2eYKdy7EJPUTLbbMoqI4WxhSH+48BdoHOZ+5QZ1NrXujl5lcay8JT0hqqTTDHLTbF57gFRTF0iDDLBnWdMmWbHnBavEE+SC7MgLETWpbLJDLV9FZlurZnGA==
x-ms-exchange-antispam-messagedata: vS0sT6hijdwFFoiZu3hP3X5ifCD1e1aHhesXK/2Uv204nu+0wAfmUWFQGspU5LuwlYfJIXse5LqID/mC/ZHO33u3DGkypXnrKnHstEhv1zDWx7sfI+po6gUtZvhPpIpo+r5XGjYPlR5CxtrfYyAz2g==
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 201a9ef0-716e-4b21-627e-08d7c5994ff0
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Mar 2020 08:50:55.7536
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bqFudYXxOOaXXo9hBiEoQp+9Dqjbr93owrFfVRwEX0kH02CCzMH2AJmKWVfBv5zIMbN6bD/A+VW1eYVSkTPJAg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4250
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpLaW5kbHkgUGluZy4uLg0KDQpCZXN0IFJlZ2FyZHMsDQpKb2FraW0gWmhhbmcNCg0KPiAtLS0t
LU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBKb2FraW0gWmhhbmcgPHFpYW5ncWluZy56
aGFuZ0BueHAuY29tPg0KPiBTZW50OiAyMDIwxOoy1MIxMsjVIDE5OjQ2DQo+IFRvOiBta2xAcGVu
Z3V0cm9uaXguZGU7IGxpbnV4LWNhbkB2Z2VyLmtlcm5lbC5vcmcNCj4gQ2M6IGRsLWxpbnV4LWlt
eCA8bGludXgtaW14QG54cC5jb20+OyBuZXRkZXZAdmdlci5rZXJuZWwub3JnDQo+IFN1YmplY3Q6
IFtQQVRDSCBsaW51eC1jYW4tbmV4dF0gY2FuOiBmbGV4Y2FuOiBhZGQgY29ycmVjdGFibGUgZXJy
b3JzIGNvcnJlY3Rpb24NCj4gd2hlbiBIVyBzdXBwb3J0cyBFQ0MNCj4gDQo+IGNvbW1pdCBjZGNl
ODQ0ODY1YmUgKCJjYW46IGZsZXhjYW46IGFkZCB2ZjYxMCBzdXBwb3J0IGZvciBGbGV4Q0FOIikg
RnJvbQ0KPiBhYm92ZSBjb21taXQgYnkgU3RlZmFuIEFnbmVyLCB0aGUgcGF0Y2gganVzdCBkaXNh
YmxlcyBub24tY29ycmVjdGFibGUgZXJyb3JzDQo+IGludGVycnVwdCBhbmQgZnJlZXplIG1vZGUu
IEl0IHN0aWxsIGNhbiBjb3JyZWN0IHRoZSBjb3JyZWN0YWJsZSBlcnJvcnMgc2luY2UgRUNDDQo+
IGVuYWJsZWQgYnkgZGVmYXVsdCBhZnRlciByZXNldCAoTUVDUltFQ0NESVNdPTAsIGVuYWJsZSBt
ZW1vcnkgZXJyb3IgY29ycmVjdCkNCj4gaWYgSFcgc3VwcG9ydHMgRUNDLg0KPiANCj4gY29tbWl0
IDVlMjY5MzI0ZGI1YSAoImNhbjogZmxleGNhbjogZGlzYWJsZSBjb21wbGV0ZWx5IHRoZSBFQ0Mg
bWVjaGFuaXNtIikNCj4gRnJvbSBhYm92ZSBjb21taXQgYnkgSm9ha2ltIFpoYW5nLCB0aGUgcGF0
Y2ggZGlzYWJsZXMgRUNDIGNvbXBsZXRlbHkNCj4gKGFzc2VydA0KPiBNRUNSW0VDQ0RJU10pIGFj
Y29yZGluZyB0byB0aGUgZXhwbGFuYXRpb24gb2YNCj4gRkxFWENBTl9RVUlSS19ESVNBQkxFX01F
Q1IgdGhhdCBkaXNhYmxlIG1lbW9yeSBlcnJvciBkZXRlY3Rpb24uIFRoaXMNCj4gY2F1c2UgY29y
cmVjdGFibGUgZXJyb3JzIGNhbm5vdCBiZSBjb3JyZWN0ZWQgZXZlbiBIVyBzdXBwb3J0cyBFQ0Mu
DQo+IA0KPiBUaGUgZXJyb3IgY29ycmVjdGlvbiBtZWNoYW5pc20gZW5zdXJlcyB0aGF0IGluIHRo
aXMgMTMtYml0IHdvcmQsIGVycm9ycyBpbiBvbmUNCj4gYml0IGNhbiBiZSBjb3JyZWN0ZWQgKGNv
cnJlY3RhYmxlIGVycm9ycykgYW5kIGVycm9ycyBpbiB0d28gYml0cyBjYW4gYmUgZGV0ZWN0ZWQN
Cj4gYnV0IG5vdCBjb3JyZWN0ZWQgKG5vbi1jb3JyZWN0YWJsZSBlcnJvcnMpLiBFcnJvcnMgaW4g
bW9yZSB0aGFuIHR3byBiaXRzIG1heQ0KPiBub3QgYmUgZGV0ZWN0ZWQuDQo+IA0KPiBJZiBIVyBz
dXBwb3J0cyBFQ0MsIHdlIGNhbiB1c2UgdGhpcyB0byBjb3JyZWN0IHRoZSBjb3JyZWN0YWJsZSBl
cnJvcnMgZGV0ZWN0ZWQNCj4gZnJvbSBGbGV4Q0FOIG1lbW9yeS4gVGhlbiBkaXNhYmxlIG5vbi1j
b3JyZWN0YWJsZSBlcnJvcnMgaW50ZXJydXB0IGFuZA0KPiBmcmVlemUgbW9kZSB0byBhdm9pZCB0
aGF0IHB1dCBGbGV4Q0FOIGluIGZyZWV6ZSBtb2RlLg0KPiANCj4gVGhpcyBwYXRjaCBhZGRzIGNv
cnJlY3RhYmxlIGVycm9ycyBjb3JyZWN0aW9uIHdoZW4gSFcgc3VwcG9ydHMgRUNDLCBhbmQNCj4g
bW9kaWZ5IGV4cGxhbmF0aW9uIGZvciBGTEVYQ0FOX1FVSVJLX0RJU0FCTEVfTUVDUi4NCj4gDQo+
IFNpZ25lZC1vZmYtYnk6IEpvYWtpbSBaaGFuZyA8cWlhbmdxaW5nLnpoYW5nQG54cC5jb20+DQo+
IC0tLQ0KPiAgZHJpdmVycy9uZXQvY2FuL2ZsZXhjYW4uYyB8IDIzICsrKysrKysrKysrKysrKysr
Ky0tLS0tDQo+ICAxIGZpbGUgY2hhbmdlZCwgMTggaW5zZXJ0aW9ucygrKSwgNSBkZWxldGlvbnMo
LSkNCj4gDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9jYW4vZmxleGNhbi5jIGIvZHJpdmVy
cy9uZXQvY2FuL2ZsZXhjYW4uYyBpbmRleA0KPiAzYTc1NDM1NWViZTYuLmFhODcxOTUzMDAzYSAx
MDA2NDQNCj4gLS0tIGEvZHJpdmVycy9uZXQvY2FuL2ZsZXhjYW4uYw0KPiArKysgYi9kcml2ZXJz
L25ldC9jYW4vZmxleGNhbi5jDQo+IEBAIC0xODcsNyArMTg3LDcgQEANCj4gICNkZWZpbmUgRkxF
WENBTl9RVUlSS19CUk9LRU5fV0VSUl9TVEFURQlCSVQoMSkgLyogW1RSXVdSTl9JTlQNCj4gbm90
IGNvbm5lY3RlZCAqLw0KPiAgI2RlZmluZSBGTEVYQ0FOX1FVSVJLX0RJU0FCTEVfUlhGRwlCSVQo
MikgLyogRGlzYWJsZSBSWCBGSUZPIEdsb2JhbA0KPiBtYXNrICovDQo+ICAjZGVmaW5lIEZMRVhD
QU5fUVVJUktfRU5BQkxFX0VBQ0VOX1JSUwlCSVQoMykgLyogRW5hYmxlIEVBQ0VOIGFuZA0KPiBS
UlMgYml0IGluIGN0cmwyICovDQo+IC0jZGVmaW5lIEZMRVhDQU5fUVVJUktfRElTQUJMRV9NRUNS
CUJJVCg0KSAvKiBEaXNhYmxlIE1lbW9yeSBlcnJvcg0KPiBkZXRlY3Rpb24gKi8NCj4gKyNkZWZp
bmUgRkxFWENBTl9RVUlSS19ESVNBQkxFX01FQ1IJQklUKDQpIC8qIERpc2FibGUgbm9uLWNvcnJl
Y3RhYmxlDQo+IGVycm9ycyBpbnRlcnJ1cHQgYW5kIGZyZWV6ZSBtb2RlICovDQo+ICAjZGVmaW5l
IEZMRVhDQU5fUVVJUktfVVNFX09GRl9USU1FU1RBTVAJQklUKDUpIC8qIFVzZSB0aW1lc3RhbXAN
Cj4gYmFzZWQgb2ZmbG9hZGluZyAqLw0KPiAgI2RlZmluZSBGTEVYQ0FOX1FVSVJLX0JST0tFTl9Q
RVJSX1NUQVRFCUJJVCg2KSAvKiBObyBpbnRlcnJ1cHQgZm9yDQo+IGVycm9yIHBhc3NpdmUgKi8N
Cj4gICNkZWZpbmUgRkxFWENBTl9RVUlSS19ERUZBVUxUX0JJR19FTkRJQU4JQklUKDcpIC8qIGRl
ZmF1bHQgdG8gQkUNCj4gcmVnaXN0ZXIgYWNjZXNzICovDQo+IEBAIC0xMjAzLDggKzEyMDMsOCBA
QCBzdGF0aWMgaW50IGZsZXhjYW5fY2hpcF9zdGFydChzdHJ1Y3QgbmV0X2RldmljZSAqZGV2KQ0K
PiAgCWZvciAoaSA9IDA7IGkgPCBwcml2LT5tYl9jb3VudDsgaSsrKQ0KPiAgCQlwcml2LT53cml0
ZSgwLCAmcmVncy0+cnhpbXJbaV0pOw0KPiANCj4gLQkvKiBPbiBWeWJyaWQsIGRpc2FibGUgbWVt
b3J5IGVycm9yIGRldGVjdGlvbiBpbnRlcnJ1cHRzDQo+IC0JICogYW5kIGZyZWV6ZSBtb2RlLg0K
PiArCS8qIE9uIFZ5YnJpZCwgZGlzYWJsZSBub24tY29ycmVjdGFibGUgZXJyb3JzIGludGVycnVw
dCBhbmQgZnJlZXplDQo+ICsJICogbW9kZS4gSXQgc3RpbGwgY2FuIGNvcnJlY3QgdGhlIGNvcnJl
Y3RhYmxlIGVycm9ycyB3aGVuIEhXIHN1cHBvcnRzDQo+IEVDQy4NCj4gIAkgKiBUaGlzIGFsc28g
d29ya3MgYXJvdW5kIGVycmF0YSBlNTI5NSB3aGljaCBnZW5lcmF0ZXMNCj4gIAkgKiBmYWxzZSBw
b3NpdGl2ZSBtZW1vcnkgZXJyb3JzIGFuZCBwdXQgdGhlIGRldmljZSBpbg0KPiAgCSAqIGZyZWV6
ZSBtb2RlLg0KPiBAQCAtMTIxMiwxOSArMTIxMiwzMiBAQCBzdGF0aWMgaW50IGZsZXhjYW5fY2hp
cF9zdGFydChzdHJ1Y3QgbmV0X2RldmljZQ0KPiAqZGV2KQ0KPiAgCWlmIChwcml2LT5kZXZ0eXBl
X2RhdGEtPnF1aXJrcyAmIEZMRVhDQU5fUVVJUktfRElTQUJMRV9NRUNSKSB7DQo+ICAJCS8qIEZv
bGxvdyB0aGUgcHJvdG9jb2wgYXMgZGVzY3JpYmVkIGluICJEZXRlY3Rpb24NCj4gIAkJICogYW5k
IENvcnJlY3Rpb24gb2YgTWVtb3J5IEVycm9ycyIgdG8gd3JpdGUgdG8NCj4gLQkJICogTUVDUiBy
ZWdpc3Rlcg0KPiArCQkgKiBNRUNSIHJlZ2lzdGVyIChzdGVwIDEgLSA1KQ0KPiArCQkgKiAxLiBC
eSBkZWZhdWx0LCBDVFJMMltFQ1JXUkVdID0gMCwgTUVDUltFQ1JXUkRJU10gPSAxDQo+ICsJCSAq
IDIuIHNldCBDVFJMMltFQ1JXUkVdDQo+ICAJCSAqLw0KPiAgCQlyZWdfY3RybDIgPSBwcml2LT5y
ZWFkKCZyZWdzLT5jdHJsMik7DQo+ICAJCXJlZ19jdHJsMiB8PSBGTEVYQ0FOX0NUUkwyX0VDUldS
RTsNCj4gIAkJcHJpdi0+d3JpdGUocmVnX2N0cmwyLCAmcmVncy0+Y3RybDIpOw0KPiANCj4gKwkJ
LyogMy4gY2xlYXIgTUVDUltFQ1JXUkRJU10gKi8NCj4gIAkJcmVnX21lY3IgPSBwcml2LT5yZWFk
KCZyZWdzLT5tZWNyKTsNCj4gIAkJcmVnX21lY3IgJj0gfkZMRVhDQU5fTUVDUl9FQ1JXUkRJUzsN
Cj4gIAkJcHJpdi0+d3JpdGUocmVnX21lY3IsICZyZWdzLT5tZWNyKTsNCj4gLQkJcmVnX21lY3Ig
fD0gRkxFWENBTl9NRUNSX0VDQ0RJUzsNCj4gKw0KPiArCQkvKiA0LiBhbGwgd3JpdGVzIHRvIE1F
Q1IgbXVzdCBrZWVwIE1FQ1JbRUNSV1JESVNdIGNsZWFyZWQgKi8NCj4gIAkJcmVnX21lY3IgJj0g
fihGTEVYQ0FOX01FQ1JfTkNFRkFGUlogfA0KPiBGTEVYQ0FOX01FQ1JfSEFOQ0VJX01TSyB8DQo+
ICAJCQkgICAgICBGTEVYQ0FOX01FQ1JfRkFOQ0VJX01TSyk7DQo+ICAJCXByaXYtPndyaXRlKHJl
Z19tZWNyLCAmcmVncy0+bWVjcik7DQo+ICsNCj4gKwkJLyogNS4gYWZ0ZXIgY29uZmlndXJhdGlv
biBkb25lLCBsb2NrIE1FQ1IgYnkgZWl0aGVyIHNldHRpbmcNCj4gKwkJICogTUVDUltFQ1JXUkRJ
U10gb3IgY2xlYXJpbmcgQ1RSTDJbRUNSV1JFXQ0KPiArCQkgKi8NCj4gKwkJcmVnX21lY3IgfD0g
RkxFWENBTl9NRUNSX0VDUldSRElTOw0KPiArCQlwcml2LT53cml0ZShyZWdfbWVjciwgJnJlZ3Mt
Pm1lY3IpOw0KPiArCQlyZWdfY3RybDIgJj0gfkZMRVhDQU5fQ1RSTDJfRUNSV1JFOw0KPiArCQlw
cml2LT53cml0ZShyZWdfY3RybDIsICZyZWdzLT5jdHJsMik7DQo+ICsNCj4gIAl9DQo+IA0KPiAg
CWVyciA9IGZsZXhjYW5fdHJhbnNjZWl2ZXJfZW5hYmxlKHByaXYpOw0KPiAtLQ0KPiAyLjE3LjEN
Cg0K
