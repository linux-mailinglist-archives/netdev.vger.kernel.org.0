Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 209258AC96
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 04:12:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726810AbfHMCMw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 22:12:52 -0400
Received: from mail-eopbgr00056.outbound.protection.outlook.com ([40.107.0.56]:49602
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726488AbfHMCMw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Aug 2019 22:12:52 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ORdc95IR0bSpH6S98x3YFf2Ki5lQhLQCnpik85y9oYuQmQjPP/pTOLj/Tw2dizh5KZf+tTf92d6lR46fR1aCZpifIph/mTFBOLpujCoZTXYWO79e43ofHSNJEXKzlMTQUck8x4gXNRDtpUOO844P4V/9qBntzdeEQ8mUzFooAsI5gr36Aoy+QGopyDoGsepVMxnpIcxL0twtPWxWa0VAtuSqqab/6V9veAvvvFr4010Jr0aT4mN5p/66p6EZp680eQZZUko28I59UW90UatT/3bAIVxP6TWtm0r1kRirTI/Oa3Zgc3++le5UC+jrpTQroykvY4WPxCvl3bv0lvvJhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Dtxv6TlfopZNKJUl2kLG/3CkzTi8bbc9441bujjSaHI=;
 b=juf3tEdSSSiR35ZTtYClX4uQdXgQKNwVgel4NjYF7/ZcxBjApJ6U1+20SydN/0YWAPHfJWnS3whUtHBTKhJuMCRxWGzYPRc1Dyus23UFagIGzh6DaJ1Hy9vapvPJ/M/nm/dLvEUcEYtf/7seYT4A0k/zc6TMljj0zp6/GlksC504P1/Zyq4tvIY0g6J4l/gjUeFwIrFKA/lYk8icIoPur9eo//y+Y1Y+2VkOXuS4WhDFBBvuXwc5K+NX9ut2EzFWjmdBrZbaR9QPej0PEiHfZKgf4t2Gy1XQbFSko8vMhbd7uaJi9f91aDO3TNB1Tvw6oXTlqiZr/DFTAYIp8VEb4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Dtxv6TlfopZNKJUl2kLG/3CkzTi8bbc9441bujjSaHI=;
 b=mxAwpImh3jYU6RHLH0cwv1pJ8sZiboe9Wyf4dwpDRxtTJu+t+VyAlSfSULLHQUVGDHSHvNxF3l6ou25BsvA9L5nMRko7wjqiplHtE5QxeJ4OBOU3wzZobd938OZdazo/hKIhN/d22+ZtsIueh9AldAPSLhPnUpY4m636g18C7nk=
Received: from VI1PR0401MB2237.eurprd04.prod.outlook.com (10.169.132.138) by
 VI1PR0401MB2349.eurprd04.prod.outlook.com (10.169.132.149) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.16; Tue, 13 Aug 2019 02:12:47 +0000
Received: from VI1PR0401MB2237.eurprd04.prod.outlook.com
 ([fe80::2072:e49f:a84a:8f37]) by VI1PR0401MB2237.eurprd04.prod.outlook.com
 ([fe80::2072:e49f:a84a:8f37%11]) with mapi id 15.20.2157.022; Tue, 13 Aug
 2019 02:12:47 +0000
From:   "Y.b. Lu" <yangbo.lu@nxp.com>
To:     "Allan W. Nielsen" <allan.nielsen@microchip.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>
Subject: RE: [PATCH 3/3] ocelot_ace: fix action of trap
Thread-Topic: [PATCH 3/3] ocelot_ace: fix action of trap
Thread-Index: AQHVUPsbgCvvMJE2AE2KMlSf5gLebab3cdsAgADjDBA=
Date:   Tue, 13 Aug 2019 02:12:47 +0000
Message-ID: <VI1PR0401MB223773EB5884D65890BD68C0F8D20@VI1PR0401MB2237.eurprd04.prod.outlook.com>
References: <20190812104827.5935-1-yangbo.lu@nxp.com>
 <20190812104827.5935-4-yangbo.lu@nxp.com>
 <20190812123147.6jjd3kocityxbvcg@lx-anielsen.microsemi.net>
In-Reply-To: <20190812123147.6jjd3kocityxbvcg@lx-anielsen.microsemi.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=yangbo.lu@nxp.com; 
x-originating-ip: [92.121.36.197]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 22276057-77dc-421d-1308-08d71f93bc6e
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR0401MB2349;
x-ms-traffictypediagnostic: VI1PR0401MB2349:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <VI1PR0401MB2349DA4E3EC0966F8804BB07F8D20@VI1PR0401MB2349.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 01283822F8
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(366004)(136003)(39860400002)(376002)(346002)(199004)(189003)(13464003)(53754006)(8936002)(53546011)(6506007)(55016002)(86362001)(81166006)(81156014)(76176011)(6436002)(2906002)(53936002)(54906003)(102836004)(4326008)(33656002)(256004)(66476007)(64756008)(66556008)(486006)(7696005)(14454004)(76116006)(66946007)(476003)(66446008)(11346002)(446003)(478600001)(186003)(8676002)(3846002)(25786009)(74316002)(26005)(966005)(5660300002)(7736002)(6116002)(305945005)(229853002)(316002)(52536014)(9686003)(66066001)(71200400001)(71190400001)(6246003)(99286004)(6306002)(6916009);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0401MB2349;H:VI1PR0401MB2237.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: S3j6cfFVCk6TmRZ1RG2TQqyr2canWT84RL7VufSkvUQ8zQShqjjMRGCqJx/ANn/AThPymBEtudbfxpkpbBh6W/bw26rB4k+zNi1RWdzQHdaWxM1mP6IMVKyNOTGRWFNfKgpCUVigWQaM6oK7+qMA3Kk5RIziYByuQxv+rpKQkHZRRI+1YO/J9w5t8AavFU6L5bIBlvWq3iw/dJQsdGixJoYo+nzb1V22QVaEN+Nd3mg2a8c75IiE8inDiV+v/JCdYJF86zXs50UtfdLSznxcZky5pkN5F9/BFTf+hZjDigV/+2bqVGghx5OuGNTIxZgnntQ7utPal13FD+GP5Lf3XlMIyao76Ji4YVZ2/O2sPfnra67h+VBhwZARLiRehBnu2p/GV7xYqNQTOrdIe/esKtCCIzTi1RepyNKsG6t/y6c=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 22276057-77dc-421d-1308-08d71f93bc6e
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Aug 2019 02:12:47.5809
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DJCZ8MfaVC3I6ArVnctOi6hlXztnOZcDE41uIuu4QHu5UHFyXZjBfm3ThNkbK5wGkO7P8443BF6eDpM5KwaZ+A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2349
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgQWxsYW4sDQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogQWxsYW4g
Vy4gTmllbHNlbiA8YWxsYW4ubmllbHNlbkBtaWNyb2NoaXAuY29tPg0KPiBTZW50OiBNb25kYXks
IEF1Z3VzdCAxMiwgMjAxOSA4OjMyIFBNDQo+IFRvOiBZLmIuIEx1IDx5YW5nYm8ubHVAbnhwLmNv
bT4NCj4gQ2M6IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7IERhdmlkIFMgLiBNaWxsZXIgPGRhdmVt
QGRhdmVtbG9mdC5uZXQ+Ow0KPiBBbGV4YW5kcmUgQmVsbG9uaSA8YWxleGFuZHJlLmJlbGxvbmlA
Ym9vdGxpbi5jb20+OyBNaWNyb2NoaXAgTGludXggRHJpdmVyDQo+IFN1cHBvcnQgPFVOR0xpbnV4
RHJpdmVyQG1pY3JvY2hpcC5jb20+DQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggMy8zXSBvY2Vsb3Rf
YWNlOiBmaXggYWN0aW9uIG9mIHRyYXANCj4gDQo+IFRoZSAwOC8xMi8yMDE5IDE4OjQ4LCBZYW5n
Ym8gTHUgd3JvdGU6DQo+ID4gVGhlIHRyYXAgYWN0aW9uIHNob3VsZCBiZSBjb3B5aW5nIHRoZSBm
cmFtZSB0byBDUFUgYW5kIGRyb3BwaW5nIGl0IGZvcg0KPiA+IGZvcndhcmRpbmcsIGJ1dCBjdXJy
ZW50IHNldHRpbmcgd2FzIGp1c3QgY29weWluZyBmcmFtZSB0byBDUFUuDQo+IA0KPiBBcmUgdGhl
cmUgYW55IGFjdGlvbnMgd2hpY2ggZG8gYSAiY29weS10by1jcHUiIGFuZCBzdGlsbCBmb3J3YXJk
IHRoZSBmcmFtZSBpbg0KPiBIVz8NCg0KW1kuYi4gTHVdIFdlJ3JlIHVzaW5nIEZlbGl4IHN3aXRj
aCB3aG9zZSBjb2RlIGhhZG4ndCBiZWVuIGFjY2VwdGVkIGJ5IHVwc3RyZWFtLg0KaHR0cHM6Ly9w
YXRjaHdvcmsub3psYWJzLm9yZy9wcm9qZWN0L25ldGRldi9saXN0Lz9zZXJpZXM9MTE1Mzk5JnN0
YXRlPSoNCg0KSSdkIGxpa2UgdG8gdHJhcCBhbGwgSUVFRSAxNTg4IFBUUCBFdGhlcm5ldCBmcmFt
ZXMgdG8gQ1BVIHRocm91Z2ggZXR5cGUgMHg4OGY3Lg0KV2hlbiBJIHVzZWQgY3VycmVudCBUUkFQ
IG9wdGlvbiwgSSBmb3VuZCB0aGUgZnJhbWVzIHdlcmUgbm90IG9ubHkgY29waWVkIHRvIENQVSwg
YnV0IGFsc28gZm9yd2FyZGVkIHRvIG90aGVyIHBvcnRzLg0KU28gSSBqdXN0IG1hZGUgdGhlIFRS
QVAgb3B0aW9uIHNhbWUgd2l0aCBEUk9QIG9wdGlvbiBleGNlcHQgZW5hYmxpbmcgQ1BVX0NPUFlf
RU5BIGluIHRoZSBwYXRjaC4NCg0KVGhhbmtzLg0KDQo+IA0KPiA+IFNpZ25lZC1vZmYtYnk6IFlh
bmdibyBMdSA8eWFuZ2JvLmx1QG54cC5jb20+DQo+ID4gLS0tDQo+ID4gIGRyaXZlcnMvbmV0L2V0
aGVybmV0L21zY2Mvb2NlbG90X2FjZS5jIHwgNiArKystLS0NCj4gPiAgMSBmaWxlIGNoYW5nZWQs
IDMgaW5zZXJ0aW9ucygrKSwgMyBkZWxldGlvbnMoLSkNCj4gPg0KPiA+IGRpZmYgLS1naXQgYS9k
cml2ZXJzL25ldC9ldGhlcm5ldC9tc2NjL29jZWxvdF9hY2UuYw0KPiA+IGIvZHJpdmVycy9uZXQv
ZXRoZXJuZXQvbXNjYy9vY2Vsb3RfYWNlLmMNCj4gPiBpbmRleCA5MTI1MGYzLi41OWFkNTkwIDEw
MDY0NA0KPiA+IC0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L21zY2Mvb2NlbG90X2FjZS5jDQo+
ID4gKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvbXNjYy9vY2Vsb3RfYWNlLmMNCj4gPiBAQCAt
MzE3LDkgKzMxNyw5IEBAIHN0YXRpYyB2b2lkIGlzMl9hY3Rpb25fc2V0KHN0cnVjdCB2Y2FwX2Rh
dGEgKmRhdGEsDQo+ID4gIAkJYnJlYWs7DQo+ID4gIAljYXNlIE9DRUxPVF9BQ0xfQUNUSU9OX1RS
QVA6DQo+ID4gIAkJVkNBUF9BQ1RfU0VUKFBPUlRfTUFTSywgMHgwKTsNCj4gPiAtCQlWQ0FQX0FD
VF9TRVQoTUFTS19NT0RFLCAweDApOw0KPiA+IC0JCVZDQVBfQUNUX1NFVChQT0xJQ0VfRU5BLCAw
eDApOw0KPiA+IC0JCVZDQVBfQUNUX1NFVChQT0xJQ0VfSURYLCAweDApOw0KPiA+ICsJCVZDQVBf
QUNUX1NFVChNQVNLX01PREUsIDB4MSk7DQo+ID4gKwkJVkNBUF9BQ1RfU0VUKFBPTElDRV9FTkEs
IDB4MSk7DQo+ID4gKwkJVkNBUF9BQ1RfU0VUKFBPTElDRV9JRFgsIE9DRUxPVF9QT0xJQ0VSX0RJ
U0NBUkQpOw0KPiBUaGlzIHNlZW1zIHdyb25nLiBUaGUgcG9saWNlciBpcyB1c2VkIHRvIGVuc3Vy
ZSB0aGF0IHRyYWZmaWMgYXJlIGRpc2NhcmRlZCwgZXZlbg0KPiBpbiB0aGUgY2FzZSB3aGVyZSBv
dGhlciB1c2VycyBvZiB0aGUgY29kZSBoYXMgcmVxdWVzdGVkIGl0IHRvIGdvIHRvIHRoZSBDUFUu
DQo+IA0KPiBBcmUgeW91IHN1cmUgdGhpcyBpcyB3b3JraW5nPyBJZiBpdCBpcyB3b3JraW5nLCB0
aGVuIEkgZmVhciB3ZSBoYXZlIGFuIGlzc3VlIHdpdGgNCj4gdGhlIERST1AgYWN0aW9uIHdoaWNo
IHVzZXMgdGhpcyB0byBkaXNjYXJkIGZyYW1lcy4NCj4gDQo+ID4gIAkJVkNBUF9BQ1RfU0VUKENQ
VV9RVV9OVU0sIDB4MCk7DQo+ID4gIAkJVkNBUF9BQ1RfU0VUKENQVV9DT1BZX0VOQSwgMHgxKTsN
Cj4gPiAgCQlicmVhazsNCj4gPiAtLQ0KPiA+IDIuNy40DQo+IA0KPiAtLQ0KPiAvQWxsYW4NCg==
