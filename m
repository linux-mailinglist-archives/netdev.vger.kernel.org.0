Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E698A20EB85
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 04:42:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728533AbgF3CmX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 22:42:23 -0400
Received: from mail-vi1eur05on2076.outbound.protection.outlook.com ([40.107.21.76]:6264
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726019AbgF3CmW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Jun 2020 22:42:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D6iU1NoWlnTGHcSX2TVES7+OlhlwHw5b1tda9SqnEvc3zNqLp2el/+qVkZh1ltI40JX5alWKf8wZNhX6MUth7TPymuLNEe8eg5OieoaEyVwncaaSXQ0AzFDjvTIzHIYD62pK2VDRbm13yoP3arcWCd8lg9caXie0OeHqKWW47qxRTG4EH5NYLX1M8sNxofIUwYpGJ3n7yIik3ZtowBYfuTkKR4mU7JZYxxGVEMQhRE5D1EiI5bddg4RKZqMxRNvnIi/zqkLpgGcpEVFnENaSTJzpsQcT3LbkCgtK/CvSmGFjMKPBlW+4YEOrsOxvp0WSAn4BEgl+d863hNENVaRFGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2SW4UZY7UzK8E+Rop448XZxhg3QEZt4SodkfC+AX5bQ=;
 b=Y7p6qU8myKLzu4jVFSn0imB99UEWufEf1imIBFm8t9PA6t5spOjF5nFVaEclf34UlmLtukx5vcyPCbcjgwmTMYYrgzEQd/MfrPyPhhQCZyiP3bhtwCb1BYLt5ARTbI6CCZeDt9oSnr6XrPH072tfNXEpVTkXe2w7dATA8EYz4HArzOJ13Sv0MSt7+J/Pc76QuZWGEsEgTeRLkN/AsTJGRhBpT9rXuuQvliDtJsDUCyxYSqnh7OWJz4YnLDN66lHvDtxoSd3P+bZH+8g0sRGriNJz7zMpdeWIzSQybZVFC7qohTJh/GCoCnC5O8cmdxygYnydxhIONPEFAS1U6LN33Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2SW4UZY7UzK8E+Rop448XZxhg3QEZt4SodkfC+AX5bQ=;
 b=iXPUEipX48QUkO5oAkZ0IX2rxF4XlEarU1Apzuvee7DEOURq6egyFEL3/qzPL3A/mB5L550dCmBdz0Pxsm7Qvqq7gvvIvDgaBEulputAXwj1DOqK0cTCXeh9kxsFowdFMuT71/PeUZgNHHV2Pvq8OP+/WkZgkfVB9ZyvtckrsAM=
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB6PR0402MB2727.eurprd04.prod.outlook.com (2603:10a6:4:98::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.21; Tue, 30 Jun
 2020 02:42:15 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::7564:54a2:a35e:1066]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::7564:54a2:a35e:1066%9]) with mapi id 15.20.3131.027; Tue, 30 Jun 2020
 02:42:15 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     Michael Walle <michael@walle.cc>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: RE: [PATCH 2/2] can: flexcan: add support for ISO CAN-FD
Thread-Topic: [PATCH 2/2] can: flexcan: add support for ISO CAN-FD
Thread-Index: AQHWTkGs1vwKnbUY20+X4jX3Z3Aj56jwb1Dw
Date:   Tue, 30 Jun 2020 02:42:15 +0000
Message-ID: <DB8PR04MB679504980A67DB8B1EEC8386E66F0@DB8PR04MB6795.eurprd04.prod.outlook.com>
References: <20200629181809.25338-1-michael@walle.cc>
 <20200629181809.25338-3-michael@walle.cc>
In-Reply-To: <20200629181809.25338-3-michael@walle.cc>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: walle.cc; dkim=none (message not signed)
 header.d=none;walle.cc; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: f599c7eb-7d1d-4898-e641-08d81c9f3327
x-ms-traffictypediagnostic: DB6PR0402MB2727:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB6PR0402MB27273262754A23BC82C019A6E66F0@DB6PR0402MB2727.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 0450A714CB
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mhVe4llMHJQJZO8Jur9i5G7v5lig8s9PnxXMAtAiMvzNSDpLwfwqXvjzL84X8lhDTK5CjvGIOfgmqf21s7/dZrNWH3pprX0OYRb5rDklm0Bu6lV29ClU6lSmpI8qVPp6N1flQt4s53Onu4Cqq2gFnfg7RVQfesqheP3yq+O/M8+gebSuyu2qfxKU8NoLhr+/A4tPWSY97IisLXOG/totlaLTJDML8//O3cAQ71MC4EV4CXKQ3Lvi+6H8DMnPys7TCfJzBlRwULy84hRRGQPsB7IirXvagLl+VrcI15mdwBGtbl1E+Hz57D/grsIRmZuQb/IrGXu/NyTi7xoxhz5kkA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(39860400002)(366004)(136003)(346002)(396003)(66476007)(8936002)(55016002)(66946007)(76116006)(5660300002)(2906002)(33656002)(52536014)(9686003)(186003)(4326008)(54906003)(7696005)(26005)(316002)(110136005)(86362001)(53546011)(6506007)(8676002)(66446008)(64756008)(66556008)(71200400001)(478600001)(83380400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: cixBiYcS697/XPqXPzeX45LIXVeuASWUEMjKfXGpTDHY3oti9sAQIDiChZbpVUF5Sie7aiiTUsv8/3L9qaNAfxLP44F/VcZuJYetUPg4T0n5u8JxdkVYPHGS7ke0M3f83XEJznGSsPt0L1kjm/QB9WZzbSa/4XyBhfHRdVGHR7OrZf7lOQzOEPpiSK0KYPCkwQYe4RXneDxyfyAiwYOWpG/22qH03g+WNaAC4mJtwGc8TzqOiNUqu81KO43uj2huts+fS63WTQkN9UYg/3lGUcwpC01b0JGW4A2vukGS+hIOzA3yIofPZBa64NbmjfJzPw+kheg7LPJI5938/1ug1zhFSW2ME/Bl1gvmCpRmEkgG0cFMMx+HcO9uO/5tZSDcyNxjarCQLmtZH0aOmSq91URo3Vqf12UNDwZuja8sfqUxtJN2jD3MEfdnjCV+H14KB/lcSk9eTPlVO3T3X/ZHFmbOOKSbdvRIJfCpa12CjYk=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f599c7eb-7d1d-4898-e641-08d81c9f3327
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jun 2020 02:42:15.5838
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EyQVadkGJb6XwBTi2mnkE/Ip9kVU1tbjea9VVOMPXVqwMea3Y75lU9g0zFsWe7YJ+JidXrR/pd33XOJ3YnCHSw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0402MB2727
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IE1pY2hhZWwgV2FsbGUgPG1p
Y2hhZWxAd2FsbGUuY2M+DQo+IFNlbnQ6IDIwMjDE6jbUwjMwyNUgMjoxOA0KPiBUbzogbGludXgt
Y2FuQHZnZXIua2VybmVsLm9yZzsgbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsNCj4gbGludXgta2Vy
bmVsQHZnZXIua2VybmVsLm9yZw0KPiBDYzogV29sZmdhbmcgR3JhbmRlZ2dlciA8d2dAZ3JhbmRl
Z2dlci5jb20+OyBNYXJjIEtsZWluZS1CdWRkZQ0KPiA8bWtsQHBlbmd1dHJvbml4LmRlPjsgRGF2
aWQgUyAuIE1pbGxlciA8ZGF2ZW1AZGF2ZW1sb2Z0Lm5ldD47IEpha3ViDQo+IEtpY2luc2tpIDxr
dWJhQGtlcm5lbC5vcmc+OyBKb2FraW0gWmhhbmcgPHFpYW5ncWluZy56aGFuZ0BueHAuY29tPjsN
Cj4gZGwtbGludXgtaW14IDxsaW51eC1pbXhAbnhwLmNvbT47IE1pY2hhZWwgV2FsbGUgPG1pY2hh
ZWxAd2FsbGUuY2M+DQo+IFN1YmplY3Q6IFtQQVRDSCAyLzJdIGNhbjogZmxleGNhbjogYWRkIHN1
cHBvcnQgZm9yIElTTyBDQU4tRkQNCj4gDQo+IFVwIHVudGlsIG5vdywgdGhlIGNvbnRyb2xsZXIg
dXNlZCBub24tSVNPIENBTi1GRCBtb2RlLCBhbHRob3VnaCBpdCBzdXBwb3J0cyBpdC4NCj4gQWRk
IHN1cHBvcnQgZm9yIElTTyBtb2RlLCB0b28uIEJ5IGRlZmF1bHQgdGhlIGhhcmR3YXJlIGlzIGlu
IG5vbi1JU08gbW9kZSBhbmQNCj4gYW4gZW5hYmxlIGJpdCBoYXMgdG8gYmUgZXhwbGljaXRseSBz
ZXQuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBNaWNoYWVsIFdhbGxlIDxtaWNoYWVsQHdhbGxlLmNj
Pg0KPiAtLS0NCj4gIGRyaXZlcnMvbmV0L2Nhbi9mbGV4Y2FuLmMgfCAxOSArKysrKysrKysrKysr
KysrLS0tDQo+ICAxIGZpbGUgY2hhbmdlZCwgMTYgaW5zZXJ0aW9ucygrKSwgMyBkZWxldGlvbnMo
LSkNCj4gDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9jYW4vZmxleGNhbi5jIGIvZHJpdmVy
cy9uZXQvY2FuL2ZsZXhjYW4uYyBpbmRleA0KPiAxODNlMDk0ZjhkNjYuLmE5MmQzY2RmNDE5NSAx
MDA2NDQNCj4gLS0tIGEvZHJpdmVycy9uZXQvY2FuL2ZsZXhjYW4uYw0KPiArKysgYi9kcml2ZXJz
L25ldC9jYW4vZmxleGNhbi5jDQo+IEBAIC05NCw2ICs5NCw3IEBADQo+ICAjZGVmaW5lIEZMRVhD
QU5fQ1RSTDJfTVJQCQlCSVQoMTgpDQo+ICAjZGVmaW5lIEZMRVhDQU5fQ1RSTDJfUlJTCQlCSVQo
MTcpDQo+ICAjZGVmaW5lIEZMRVhDQU5fQ1RSTDJfRUFDRU4JCUJJVCgxNikNCj4gKyNkZWZpbmUg
RkxFWENBTl9DVFJMMl9JU09DQU5GREVOCUJJVCgxMikNCj4gDQo+ICAvKiBGTEVYQ0FOIG1lbW9y
eSBlcnJvciBjb250cm9sIHJlZ2lzdGVyIChNRUNSKSBiaXRzICovDQo+ICAjZGVmaW5lIEZMRVhD
QU5fTUVDUl9FQ1JXUkRJUwkJQklUKDMxKQ0KPiBAQCAtMTM0NCwxNCArMTM0NSwyNSBAQCBzdGF0
aWMgaW50IGZsZXhjYW5fY2hpcF9zdGFydChzdHJ1Y3QgbmV0X2RldmljZQ0KPiAqZGV2KQ0KPiAg
CWVsc2UNCj4gIAkJcmVnX21jciB8PSBGTEVYQ0FOX01DUl9TUlhfRElTOw0KPiANCj4gLQkvKiBN
Q1IgLSBDQU4tRkQgKi8NCj4gLQlpZiAocHJpdi0+Y2FuLmN0cmxtb2RlICYgQ0FOX0NUUkxNT0RF
X0ZEKQ0KPiArCS8qIE1DUiwgQ1RSTDINCj4gKwkgKg0KPiArCSAqIENBTi1GRCBtb2RlDQo+ICsJ
ICogSVNPIENBTi1GRCBtb2RlDQo+ICsJICovDQo+ICsJcmVnX2N0cmwyID0gcHJpdi0+cmVhZCgm
cmVncy0+Y3RybDIpOw0KPiArCWlmIChwcml2LT5jYW4uY3RybG1vZGUgJiBDQU5fQ1RSTE1PREVf
RkQpIHsNCj4gIAkJcmVnX21jciB8PSBGTEVYQ0FOX01DUl9GREVOOw0KPiAtCWVsc2UNCj4gKwkJ
cmVnX2N0cmwyIHw9IEZMRVhDQU5fQ1RSTDJfSVNPQ0FORkRFTjsNCj4gKwl9IGVsc2Ugew0KPiAg
CQlyZWdfbWNyICY9IH5GTEVYQ0FOX01DUl9GREVOOw0KPiArCX0NCj4gKw0KPiArCWlmIChwcml2
LT5jYW4uY3RybG1vZGUgJiBDQU5fQ1RSTE1PREVfRkRfTk9OX0lTTykNCj4gKwkJcmVnX2N0cmwy
ICY9IH5GTEVYQ0FOX0NUUkwyX0lTT0NBTkZERU47DQoNCg0KSGkgTWljaGFlbCwNCg0KaXAgbGlu
ayBzZXQgY2FuMCB1cCB0eXBlIGNhbiBiaXRyYXRlIDEwMDAwMDAgZGJpdHJhdGUgNTAwMDAwMCBm
ZCBvbg0KQWJvdmUgY21kIGNhbiBjb25maWd1cmUgSVNPIENBTi1GRC4NCg0KSG93ZXZlciwgaWYg
dXNlcnMgd2FudCB0byBjb25maWd1cmUgTk9OLUlTTyBDQU4tRkQsIHNob3VsZCB1c2UgYmVsb3cg
Y21kLCB3aGF0IEkgZGlkIGJlZm9yZS4NCmlwIGxpbmsgc2V0IGNhbjAgdXAgdHlwZSBjYW4gYml0
cmF0ZSAxMDAwMDAwIGRiaXRyYXRlIDUwMDAwMDAgZmQgb24gZmQtbm9uLWlzbyBvbg0KDQpNYXJj
IG1heSBub3Qgc2F0aXNmeSB3aXRoIGl0LCB0byBiZSBob25lc3QsIHRoaXMgbG9va3Mgbm90IGdv
b2QsIGhhZCBiZXR0ZXIgY29uZmlndXJlIGxpa2UgYmVsb3cgdG8gZW5hYmxlIE5PTi1JU08gQ0FO
LUZELg0KaXAgbGluayBzZXQgY2FuMCB1cCB0eXBlIGNhbiBiaXRyYXRlIDEwMDAwMDAgZGJpdHJh
dGUgNTAwMDAwMCBmZC1ub24taXNvIG9uDQoNCkkgaGF2ZW4ndCBnb3QgYW55IGdvb2QgaWRlYXMg
eWV0Lg0KDQpCZXN0IFJlZ2FyZHMsDQpKb2FraW0gWmhhbmcNCj4gIAluZXRkZXZfZGJnKGRldiwg
IiVzOiB3cml0aW5nIG1jcj0weCUwOHgiLCBfX2Z1bmNfXywgcmVnX21jcik7DQo+ICAJcHJpdi0+
d3JpdGUocmVnX21jciwgJnJlZ3MtPm1jcik7DQo+ICsJcHJpdi0+d3JpdGUocmVnX2N0cmwyLCAm
cmVncy0+Y3RybDIpOw0KPiANCj4gIAkvKiBDVFJMDQo+ICAJICoNCj4gQEAgLTE5NTIsNiArMTk2
NCw3IEBAIHN0YXRpYyBpbnQgZmxleGNhbl9wcm9iZShzdHJ1Y3QgcGxhdGZvcm1fZGV2aWNlDQo+
ICpwZGV2KQ0KPiANCj4gIAlpZiAocHJpdi0+ZGV2dHlwZV9kYXRhLT5xdWlya3MgJiBGTEVYQ0FO
X1FVSVJLX1NVUFBPUlRfRkQpIHsNCj4gIAkJcHJpdi0+Y2FuLmN0cmxtb2RlX3N1cHBvcnRlZCB8
PSBDQU5fQ1RSTE1PREVfRkQ7DQo+ICsJCXByaXYtPmNhbi5jdHJsbW9kZV9zdXBwb3J0ZWQgfD0g
Q0FOX0NUUkxNT0RFX0ZEX05PTl9JU087DQo+ICAJCXByaXYtPmNhbi5iaXR0aW1pbmdfY29uc3Qg
PSAmZmxleGNhbl9mZF9iaXR0aW1pbmdfY29uc3Q7DQo+ICAJCXByaXYtPmNhbi5kYXRhX2JpdHRp
bWluZ19jb25zdCA9DQo+ICAJCQkmZmxleGNhbl9mZF9kYXRhX2JpdHRpbWluZ19jb25zdDsNCj4g
LS0NCj4gMi4yMC4xDQoNCg==
