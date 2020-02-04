Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D848151660
	for <lists+netdev@lfdr.de>; Tue,  4 Feb 2020 08:19:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726371AbgBDHTL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Feb 2020 02:19:11 -0500
Received: from mail-eopbgr70071.outbound.protection.outlook.com ([40.107.7.71]:32482
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726000AbgBDHTL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 Feb 2020 02:19:11 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EfOB3sLuHLU/E00fACNBonLBZuScws8DGhwEs8fxE91Qnqe1qAE2aTLos818x0fpQWkKI3mZeUPAnvEa5HGWFuz4TdE4Q5GYi5ySCRV4n0QLs4Kwz4VcFtu0r0o1CRMszE1JJnMcIGgYf9aoe2tVS5H9B8n8uX9stROCRpyZ6KaQvSyNQSb2Xj/cByUnCUBoIEsOw7BkrttwOaKGpS0njdc5ip8S+YwxTqboUUm1xn6UxGCBIiHjfSqyJsZo+Uf5hRrPMPTg69ztyGHi1UnGs+V4t20xPxJOqPQD1Tl4O7HMS7kl2zmKf7oYimcsPArKSnSBeTLBSgJzw48UsxFXtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iVZq8Cl6gqOltcrWaO1u9uTnFz/cTicb+2VLag6UNLM=;
 b=e+N81U3fFYqG5p4Ey99iRW57VwHwKNc+1OqUI1Y8q5unv9cR4PmJviqB9JRscYQm+7pq3BApzNET/6g+vOwdFVDdMadhS22xVIgOk7hz5RgJMmRTCyWbLsqHAjUASg77SPtNUmrPBIRiATGw0l/eAxNC/XAGVazA5hmKcoPaLlqwNSmjycZgJU464a49PX9+CSxKWBodxmwP0twwWoKmYBYCGMkbZIpF0NRKgFWjVU+6KBUbLFuzI5wth/Qrm/0JnnHLtJb9JmDsoDq2dQxQCQ5H3aoMMcz1hCsjprH4p5msortxAB2nd8eh4oIqiTLNXkuwUlmTbMT9cWiODQ/PYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iVZq8Cl6gqOltcrWaO1u9uTnFz/cTicb+2VLag6UNLM=;
 b=XuwH1x29ST3D61W1l2zXuuZvXjPd2lY1ogbotLDhlAHmaiIqS/2C/0+rGf1Iu/Jxuoqh1+THJLTvR6rUIHY/yW8CRWY/FvvuQyaxbJJFFunHCy0NmZDqQzU4H5vUZ+B8QyxOzWCQ6394vTTkPGLRoSYCVK8Wd2oJ9gJhZFDclMk=
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (20.178.202.86) by
 AM0PR04MB4307.eurprd04.prod.outlook.com (52.134.92.138) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2707.21; Tue, 4 Feb 2020 07:18:24 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::1b4:31d2:1485:6e07]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::1b4:31d2:1485:6e07%7]) with mapi id 15.20.2686.028; Tue, 4 Feb 2020
 07:18:24 +0000
From:   "Calvin Johnson (OSS)" <calvin.johnson@oss.nxp.com>
To:     Andy Shevchenko <andy.shevchenko@gmail.com>
CC:     "linux.cj@gmail.com" <linux.cj@gmail.com>,
        Jon Nettleton <jon@solid-run.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Makarand Pawagi <makarand.pawagi@nxp.com>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Varun Sethi <V.Sethi@nxp.com>,
        Pankaj Bansal <pankaj.bansal@nxp.com>,
        "Rajesh V. Bikkina" <rajesh.bikkina@nxp.com>,
        "Calvin Johnson (OSS)" <calvin.johnson@oss.nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Subject: RE: [PATCH v1 3/7] net/fsl: add ACPI support for mdio bus
Thread-Topic: [PATCH v1 3/7] net/fsl: add ACPI support for mdio bus
Thread-Index: AQHV2ytJMxMO6/MkaUqbVaJhQJOy6A==
Date:   Tue, 4 Feb 2020 07:18:24 +0000
Message-ID: <AM0PR04MB5636EA716C9D029C97C5854293030@AM0PR04MB5636.eurprd04.prod.outlook.com>
References: <20200131153440.20870-1-calvin.johnson@nxp.com>
 <20200131153440.20870-4-calvin.johnson@nxp.com>
 <CAHp75VeRq8XT67LJOM+9R9xVpsfv7MxZpaCHYkfnCqAzgjXo9A@mail.gmail.com>
In-Reply-To: <CAHp75VeRq8XT67LJOM+9R9xVpsfv7MxZpaCHYkfnCqAzgjXo9A@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=calvin.johnson@oss.nxp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [103.206.107.82]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 7b2e385e-f950-4cc5-b084-08d7a9426c3f
x-ms-traffictypediagnostic: AM0PR04MB4307:|AM0PR04MB4307:
x-ms-exchange-sharedmailbox-routingagent-processed: True
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR04MB430702EB0E87BF21A6ECC7A6D2030@AM0PR04MB4307.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 03030B9493
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(396003)(346002)(366004)(376002)(136003)(189003)(199004)(64756008)(76116006)(66476007)(54906003)(66446008)(66556008)(66946007)(316002)(52536014)(5660300002)(71200400001)(86362001)(53546011)(6506007)(55016002)(478600001)(7696005)(9686003)(26005)(186003)(6916009)(8936002)(33656002)(2906002)(81166006)(81156014)(8676002)(4326008);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR04MB4307;H:AM0PR04MB5636.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:0;
received-spf: None (protection.outlook.com: oss.nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: rjaOko4bmi/uaAc5SrBiVIFEvC4WuydAGujz5Yklu3TdCez30vAY6hwLKBBnO4DUh0hJQNicQFA+WNeB07Y6IwD+FGx1dIo7rTvnsV1BYcEN4ANq4UwcAYEftqdnsmLkKP8qcyDpsoFasyO9nQmhQlX7x8a/N1AJndYK/MqCi6jviwYP8zL3zH3W4ogFxr01Yofi+hjJ+dGdGy4mX2zIt6YxtO/Nc36edD1hAI4D2aFua4AfLe7O0bzTUne10LUcF2UC32HzIKliyf+JOw0UEfe1gquQFEAnXlKGf8wDZMt5Y0bz8fpuk+xmhZtJnlUZRE7sIM6zM4Ul5QapT6v+jzYL7+qp4imdVJ5ZAbhZlFghF+Uxwtk93VKDvWH2OiSj2xjWuHHz17DHcCQYV4vmzx0DM30OBUxyszRB8GSyJO4RR4ojGs4gdS6DLxuJpzi+
x-ms-exchange-antispam-messagedata: vBAxlMac0V6Xc16xtqtv6ehDzAtkxLHFOKW/Mvd6neXxQ+cw5pKhKjYKWzUvzAyVWIu9eEe7oJNVX6eLw7eqWLdBnSV7ad3uYYyTQ+AfQb523v3eUOtHCX0ki/97w8vHvIlDXO+jC88P9e7EPLDbVw==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b2e385e-f950-4cc5-b084-08d7a9426c3f
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Feb 2020 07:18:24.3334
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: anUI7Eaq+Pb77EDXpecr39J7mCYFDEQ0DZkM8uchMQaQQE8R857HWx/D04HG78QnodJYha7PaioJb/bB6pTFeQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4307
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IEFuZHkgU2hldmNoZW5rbyA8
YW5keS5zaGV2Y2hlbmtvQGdtYWlsLmNvbT4NCj4gU3ViamVjdDogUmU6IFtQQVRDSCB2MSAzLzdd
IG5ldC9mc2w6IGFkZCBBQ1BJIHN1cHBvcnQgZm9yIG1kaW8gYnVzDQo+IA0KPiBPbiBGcmksIEph
biAzMSwgMjAyMCBhdCA1OjM3IFBNIENhbHZpbiBKb2huc29uIDxjYWx2aW4uam9obnNvbkBueHAu
Y29tPg0KPiB3cm90ZToNCj4gPg0KPiA+IEZyb206IENhbHZpbiBKb2huc29uIDxjYWx2aW4uam9o
bnNvbkBvc3MubnhwLmNvbT4NCj4gPg0KPiA+IEFkZCBBQ1BJIHN1cHBvcnQgZm9yIE1ESU8gYnVz
IHJlZ2lzdHJhdGlvbiB3aGlsZSBtYWludGFpbmluZyB0aGUNCj4gPiBleGlzdGluZyBEVCBzdXBw
b3J0Lg0KPiANCj4gLi4uDQo+IA0KPiA+IC0gICAgICAgcmV0ID0gb2ZfYWRkcmVzc190b19yZXNv
dXJjZShucCwgMCwgJnJlcyk7DQo+ID4gLSAgICAgICBpZiAocmV0KSB7DQo+ID4gKyAgICAgICBy
ZXMgPSBwbGF0Zm9ybV9nZXRfcmVzb3VyY2UocGRldiwgSU9SRVNPVVJDRV9NRU0sIDApOw0KPiA+
ICsgICAgICAgaWYgKCFyZXMpIHsNCj4gPiAgICAgICAgICAgICAgICAgZGV2X2VycigmcGRldi0+
ZGV2LCAiY291bGQgbm90IG9idGFpbiBhZGRyZXNzXG4iKTsNCj4gPiAtICAgICAgICAgICAgICAg
cmV0dXJuIHJldDsNCj4gPiArICAgICAgICAgICAgICAgcmV0dXJuIC1FTk9ERVY7DQo+ID4gICAg
ICAgICB9DQo+IA0KPiAuLi4NCj4gDQo+ID4gLSAgICAgICBzbnByaW50ZihidXMtPmlkLCBNSUlf
QlVTX0lEX1NJWkUsICIlbGx4IiwgKHVuc2lnbmVkIGxvbmcNCj4gbG9uZylyZXMuc3RhcnQpOw0K
PiA+ICsgICAgICAgc25wcmludGYoYnVzLT5pZCwgTUlJX0JVU19JRF9TSVpFLCAiJWxseCIsDQo+
ID4gKyAgICAgICAgICAgICAgICAodW5zaWduZWQgbG9uZyBsb25nKXJlcy0+c3RhcnQpOw0KPiAN
Cj4gV2h5IHRoaXMgaGFzIGJlZW4gdG91Y2hlZD8NCg0KV2l0aG91dCB0aGlzIGNoYW5nZSwgSSBn
ZXQ6DQotLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0NCmRyaXZlcnMvbmV0L2V0aGVybmV0L2ZyZWVzY2FsZS94Z21hY19tZGlvLmM6IEluIGZ1
bmN0aW9uICd4Z21hY19tZGlvX3Byb2JlJzoNCmRyaXZlcnMvbmV0L2V0aGVybmV0L2ZyZWVzY2Fs
ZS94Z21hY19tZGlvLmM6MjY5OjI3OiBlcnJvcjogcmVxdWVzdCBmb3IgbWVtYmVyICdzdGFydCcg
aW4gc29tZXRoaW5nIG5vdCBhIHN0cnVjdHVyZSBvciB1bmlvbg0KICAgICh1bnNpZ25lZCBsb25n
IGxvbmcpcmVzLnN0YXJ0KTsNCiAgICAgICAgICAgICAgICAgICAgICAgICAgIF4NCnNjcmlwdHMv
TWFrZWZpbGUuYnVpbGQ6MjY1OiByZWNpcGUgZm9yIHRhcmdldCAnZHJpdmVycy9uZXQvZXRoZXJu
ZXQvZnJlZXNjYWxlL3hnbWFjX21kaW8ubycgZmFpbGVkDQptYWtlWzRdOiAqKiogW2RyaXZlcnMv
bmV0L2V0aGVybmV0L2ZyZWVzY2FsZS94Z21hY19tZGlvLm9dIEVycm9yIDENCi0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQ0KDQpPbiBjaGVj
a2luZyBvdGhlciBmaWxlcyB0aGF0IGNhbGxzIHBsYXRmb3JtX2dldF9yZXNvdXJjZSwgSSBjYW4g
c2VlIHRoYXQgdGhpcyBpcyB0aGUgd2F5IHRoZXkgcmVmZXIgJ3N0YXJ0Jy4NCg0KPiANCj4gLi4u
DQo+IA0KPiA+IC0gICAgICAgcHJpdi0+bWRpb19iYXNlID0gb2ZfaW9tYXAobnAsIDApOw0KPiA+
ICsgICAgICAgcHJpdi0+bWRpb19iYXNlID0gZGV2bV9pb3JlbWFwX3Jlc291cmNlKCZwZGV2LT5k
ZXYsIHJlcyk7DQo+ID4gICAgICAgICBpZiAoIXByaXYtPm1kaW9fYmFzZSkgew0KPiANCj4gQXJl
IHlvdSBzdXJlIHRoZSBjaGVjayBpcyBjb3JyZWN0IG5vdz8NCmRldm1faW9yZW1hcF9yZXNvdXJj
ZSByZXR1cm5zIG5vbi1OVUxMIGVycm9yIHZhbHVlcy4gU28sIHRoaXMgZG9lc24ndCBsb29rIHJp
Z2h0LiANCkknbGwgd29yayBvbiBpdCBmb3IgdjIuDQoNCj4gPiAgICAgICAgICAgICAgICAgcmV0
ID0gLUVOT01FTTsNCj4gPiAgICAgICAgICAgICAgICAgZ290byBlcnJfaW9yZW1hcDsNCj4gPiAg
ICAgICAgIH0NCj4gDQo+IC4uLg0KPiANCj4gPg0KPiA+IC0gICAgICAgcHJpdi0+aXNfbGl0dGxl
X2VuZGlhbiA9IG9mX3Byb3BlcnR5X3JlYWRfYm9vbChwZGV2LT5kZXYub2Zfbm9kZSwNCj4gPiAt
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgImxp
dHRsZS1lbmRpYW4iKTsNCj4gPiAtDQo+ID4gLSAgICAgICBwcml2LT5oYXNfYTAxMTA0MyA9IG9m
X3Byb3BlcnR5X3JlYWRfYm9vbChwZGV2LT5kZXYub2Zfbm9kZSwNCj4gPiAtICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICJmc2wsZXJyYXR1bS1hMDExMDQz
Iik7DQo+ID4gLQ0KPiA+IC0gICAgICAgcmV0ID0gb2ZfbWRpb2J1c19yZWdpc3RlcihidXMsIG5w
KTsNCj4gPiAtICAgICAgIGlmIChyZXQpIHsNCj4gPiAtICAgICAgICAgICAgICAgZGV2X2Vycigm
cGRldi0+ZGV2LCAiY2Fubm90IHJlZ2lzdGVyIE1ESU8gYnVzXG4iKTsNCj4gDQo+ID4gKyAgICAg
ICBpZiAoaXNfb2Zfbm9kZShwZGV2LT5kZXYuZndub2RlKSkgew0KPiANCj4gPiArICAgICAgIH0g
ZWxzZSBpZiAoaXNfYWNwaV9ub2RlKHBkZXYtPmRldi5md25vZGUpKSB7DQo+IA0KPiBPaCwgbm8s
IHRoaXMgaXMgd3JvbmcuIFB1cmUgYXBwcm9hY2ggQUZBSUNTIGlzIHRvIHVzZSBmd25vZGUgQVBJ
IG9yIGRldmljZQ0KPiBwcm9wZXJ0eSBBUEkuDQo+IA0KPiBBbmQgYWN0dWFsbHkgd2hhdCB5b3Ug
bmVlZCB0byBpbmNsdWRlIGlzIHJhdGhlciA8bGludXgvcHJvcGVydHkuaD4sIGFuZCBub3QNCj4g
YWNwaS5oLg0KDQpVbmRlcnN0b29kLiBJIGhhZCBnb3Qgc29tZSBpc3N1ZXMgd2hpbGUgdXNpbmcg
Zndub2RlIEFQSSB0byBoYW5kbGUgRFQgY2FzZSBkdWUgdG8gd2hpY2gNCkRUL0FDUEkgY2hlY2tz
IHdlcmUgZG9uZSBhbmQgYm90aCBhcmUgaGFuZGxlZCBzZXBhcmF0ZWx5LiAgTGV0IG1lIHNlZSBp
ZiBJIGNhbiByb290IGNhdXNlIGl0Lg0KDQo+IA0KPiA+ICsgICAgICAgfSBlbHNlIHsNCj4gPiAr
ICAgICAgICAgICAgICAgZGV2X2VycigmcGRldi0+ZGV2LCAiQ2Fubm90IGdldCBjZmcgZGF0YSBm
cm9tIERUIG9yIEFDUElcbiIpOw0KPiA+ICsgICAgICAgICAgICAgICByZXQgPSAtRU5YSU87DQo+
ID4gICAgICAgICAgICAgICAgIGdvdG8gZXJyX3JlZ2lzdHJhdGlvbjsNCj4gPiAgICAgICAgIH0N
Cj4gDQo+ID4gK3N0YXRpYyBjb25zdCBzdHJ1Y3QgYWNwaV9kZXZpY2VfaWQgeGdtYWNfbWRpb19h
Y3BpX21hdGNoW10gPSB7DQo+ID4gKyAgICAgICB7Ik5YUDAwMDYiLCAwfQ0KPiANCj4gSG93IGRp
ZCB5b3UgdGVzdCB0aGlzIG9uIHBsYXRmb3JtcyB3aXRoIHRoZSBzYW1lIElQIGFuZCB3aXRob3V0
IGRldmljZSAgb2YNCj4gdGhpcyBBQ1BJIElEIHByZXNlbnQ/DQoNCkkgZGlkbid0IHRlc3QgaXQg
b24gYW55IG90aGVyIHBsYXRmb3JtcyBvdGhlciB0aGFuIExYMjE2MEFSREIuICBBRkFJVSwgd2l0
aG91dA0KZGV2aWNlIG9mIHRoaXMgQUNQSSBJRCBwcmVzZW50LCB0aGUgZHJpdmVyIHdvbid0IGdl
dCBwcm9iZWQuIA0KIA0KPiAoSGludDogbWlzc2VkIHRlcm1pbmF0b3IpDQpzdGF0aWMgY29uc3Qg
c3RydWN0IGFjcGlfZGV2aWNlX2lkIHhnbWFjX21kaW9fYWNwaV9tYXRjaFtdID0gew0KICAgICAg
ICB7ICJOWFAwMDA2IiwgMCB9LA0KICAgICAgICB7IH0NCn07DQpJcyB0aGlzIHdoYXQgeW91IG1l
YW50Pw0KDQo+IA0KPiA+ICt9Ow0KPiA+ICtNT0RVTEVfREVWSUNFX1RBQkxFKGFjcGksIHhnbWFj
X21kaW9fYWNwaV9tYXRjaCk7DQo+IA0KPiA+ICsgICAgICAgICAgICAgICAuYWNwaV9tYXRjaF90
YWJsZSA9IEFDUElfUFRSKHhnbWFjX21kaW9fYWNwaV9tYXRjaCksDQo+IA0KPiBBQ1BJX1BUUiBp
cyBub3QgbmVlZGVkIG90aGVyd2lzZSB5b3Ugd2lsbCBnZXQgYSBjb21waWxlciB3YXJuaW5nLg0K
DQpObyBjb21waWxlciB3YXJuaW5nIHdhcyBvYnNlcnZlZCBpbiBib3RoIGNhc2VzLg0KSSBjYW4g
c2VlIG90aGVyIGRyaXZlcnMgdXNpbmcgdGhpcyBtYWNyby4NCmRyaXZlcnMvbmV0L2V0aGVybmV0
L2FwbS94Z2VuZS12Mi9tYWluLmM6NzM0OiAgICAgICAgICAgICAgLmFjcGlfbWF0Y2hfdGFibGUg
PSBBQ1BJX1BUUih4Z2VfYWNwaV9tYXRjaCksDQpkcml2ZXJzL25ldC9ldGhlcm5ldC9hcG0veGdl
bmUveGdlbmVfZW5ldF9tYWluLmM6MjE3MjogICAgICAgICAgICAgLmFjcGlfbWF0Y2hfdGFibGUg
PSBBQ1BJX1BUUih4Z2VuZV9lbmV0X2FjcGlfbWF0Y2gpLA0KZHJpdmVycy9uZXQvZXRoZXJuZXQv
aGlzaWxpY29uL2hucy9obnNfZW5ldC5jOjI0NDU6ICAgICAgICAgICAgIC5hY3BpX21hdGNoX3Rh
YmxlID0gQUNQSV9QVFIoaG5zX2VuZXRfYWNwaV9tYXRjaCksDQpkcml2ZXJzL25ldC9ldGhlcm5l
dC9oaXNpbGljb24vaG5zX21kaW8uYzo1NjY6ICAgICAgICAgICAgIC5hY3BpX21hdGNoX3RhYmxl
ID0gQUNQSV9QVFIoaG5zX21kaW9fYWNwaV9tYXRjaCksDQpkcml2ZXJzL25ldC9ldGhlcm5ldC9t
YXJ2ZWxsL212cHAyL212cHAyX21haW4uYzo1OTk3OiAgICAgICAgICAgLmFjcGlfbWF0Y2hfdGFi
bGUgPSBBQ1BJX1BUUihtdnBwMl9hY3BpX21hdGNoKSwNCmRyaXZlcnMvbmV0L2V0aGVybmV0L3F1
YWxjb21tL2VtYWMvZW1hYy5jOjc2NjogICAgICAgICAgLmFjcGlfbWF0Y2hfdGFibGUgPSBBQ1BJ
X1BUUihlbWFjX2FjcGlfbWF0Y2gpLA0KZHJpdmVycy9uZXQvZXRoZXJuZXQvc21zYy9zbXNjOTEx
eC5jOjI2Njc6ICAgICAgICAgICAgICAuYWNwaV9tYXRjaF90YWJsZSA9IEFDUElfUFRSKHNtc2M5
MTF4X2FjcGlfbWF0Y2gpLA0KZHJpdmVycy9uZXQvZXRoZXJuZXQvc29jaW9uZXh0L25ldHNlYy5j
OjIxODc6ICAgICAgICAgICAuYWNwaV9tYXRjaF90YWJsZSA9IEFDUElfUFRSKG5ldHNlY19hY3Bp
X2lkcyksDQpkcml2ZXJzL25ldC9waHkvbWRpby14Z2VuZS5jOjQ1NjogICAgICAgICAgICAgICAu
YWNwaV9tYXRjaF90YWJsZSA9IEFDUElfUFRSKHhnZW5lX21kaW9fYWNwaV9tYXRjaCksIA0KDQoN
ClRoYW5rcw0KQ2FsdmluDQoNCg==
