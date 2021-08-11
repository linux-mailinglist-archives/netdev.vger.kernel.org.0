Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 856D93E8B86
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 10:09:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236120AbhHKIJd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 04:09:33 -0400
Received: from mail-eopbgr60084.outbound.protection.outlook.com ([40.107.6.84]:36482
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236006AbhHKIH7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Aug 2021 04:07:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hNlFRBohkvruJtY5MwIGx5KQa6Le/tYkqHeDBbOCyXHsDmoUtNvyD91FjBbXquADruVayoQNT/T/c0JLHa4A5mp+RhymGqaeQh1Q2CxNxs9NFWlLSiqA+WeDyvLUKEcYAfnN7C8SJPyMDTgsa6VFhhPrLSKwy9uIqzDcivebykdPTykGIGrHuJ6mxCi4qGhPKWsiy7TC2Qde7KtyKJnXFgmhLaLt6zwpQt0IgBlI7fRb/CZG4Rt1Y/ORs9uc1G6x1o+TZSrebXadpS5ZZVamm1Cd7N7tsqMy8CqSRmqWn1nLJEJMCkBbv3UexxGGx+WUVVUjnDZ9gmKtTE8xF3DXFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=24Ff7OB1EVcrbyvfvZYQUNdB9/rJ2VgV1dksNY82WEQ=;
 b=BON0Ai3qBdLvUR9tuffBhbVhqm7rNXsEZyYxlNRjcoVIB5Q8iDvcFpZ6IKPZI9vsmQja0fSbz8rHyHfshc5IqsbrMzOSHoVQWcl8o3wdiLxntyPSg1dPGZCL2b6abQZHDzcMb9UF6xh/kbsplOstg9vvgwyV+JbInL7ENRCXBlV+0mQqtrIJD9hkJXfs98MfMpwXrxLJGUgltkOzIpxL1YM4P1ZDjXV24m+OFaz72T421mVIyEniG6G2UyGRnUWynyrQCfTaTBliCjLh16c3cvsjD2FchbduEUD355m927mcei0TxJgwnDiDJkAftEd1G6uG9QKOqgDNucLE51jZyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=24Ff7OB1EVcrbyvfvZYQUNdB9/rJ2VgV1dksNY82WEQ=;
 b=Y/ux6LkI0SlPikRYTzo6MZ5Ts7MEYSTN+2+HPoT6FlBIv+JStO2WkFpxBJ+z/KA2zRqWx68Tgv5ORryeCxc1hmisQlIoEMjn/TK4ljce4PramfKw8+OjvQCvS1jtT9xBduU7yxFpfiiQzOCyU01BICIo+Qo/pWg01fAbOE84rxo=
Received: from VI1PR04MB6800.eurprd04.prod.outlook.com (2603:10a6:803:133::16)
 by VI1PR04MB5615.eurprd04.prod.outlook.com (2603:10a6:803:e9::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.13; Wed, 11 Aug
 2021 08:06:57 +0000
Received: from VI1PR04MB6800.eurprd04.prod.outlook.com
 ([fe80::498:421b:7d3:a0c3]) by VI1PR04MB6800.eurprd04.prod.outlook.com
 ([fe80::498:421b:7d3:a0c3%8]) with mapi id 15.20.4415.016; Wed, 11 Aug 2021
 08:06:57 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     Florian Fainelli <f.fainelli@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "shawnguo@kernel.org" <shawnguo@kernel.org>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "festevam@gmail.com" <festevam@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>
CC:     "kernel@pengutronix.de" <kernel@pengutronix.de>,
        dl-linux-imx <linux-imx@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
Subject: RE: [PATCH net-next 1/3] dt-bindings: net: fsl, fec: add "fsl,
 wakeup-irq" property
Thread-Topic: [PATCH net-next 1/3] dt-bindings: net: fsl, fec: add "fsl,
 wakeup-irq" property
Thread-Index: AQHXidrZaeAm3FGM8UWFBIfAWGHBc6tqnwvwgADpEgCAAHa+4IABDGQAgADAFFA=
Date:   Wed, 11 Aug 2021 08:06:57 +0000
Message-ID: <VI1PR04MB6800F8425473916A82F050F5E6F89@VI1PR04MB6800.eurprd04.prod.outlook.com>
References: <20210805074615.29096-1-qiangqing.zhang@nxp.com>
 <20210805074615.29096-2-qiangqing.zhang@nxp.com>
 <2e1a14bf-2fa8-ed39-d133-807c4e14859c@gmail.com>
 <DB8PR04MB67950F6863A8FEE6745CBC68E6F69@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <498f3cee-8f37-2ab1-93c4-5472572ecc37@gmail.com>
 <DB8PR04MB6795DC35D0387637052E64A1E6F79@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <90af8051-512d-1230-72a7-8bbcee984939@gmail.com>
In-Reply-To: <90af8051-512d-1230-72a7-8bbcee984939@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b1aec9b6-4274-4c26-c940-08d95c9efd6f
x-ms-traffictypediagnostic: VI1PR04MB5615:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB56154C9DD7B6564E7728B198E6F89@VI1PR04MB5615.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4502;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qxaMFETU3ukBjgmSR7Sys+BWHQVYOmlZrbuw6uMdn0lzDFdiUGo32a4TSykvX+7MCTuEZd6HUFkaDWUrtDmmdtN5YrC2ljqWIfgEsBHufrdcxEEzFk1NSu5NhtqLsI6b0jHqIC3icjrRReU1KJK6eaPreiWIMxI8l3VBLDvqezRNU0HGUNJEOVEoAME078Y6YdbcrezmI3lVi05o4/Udug9IyGgBJ+2l0SrJjLpdpNKLQwaP4421E0EPDZEHqduLPJnI2E+pipsSwj00ypjHt/h8bywmnx3lKDwFDEi9j5xExSyWgnY6rbB78t8LvIGP+J+N/v9XkGoupUBa9E+4LuGD3/GppCIR8Tb+BXS06/1fI3xAu4Vefgniq3eybcLKhlcGbgj0HmhhI2HUByXGXs4X74DjgDNTF/+rlnDo5JO5LJhhSOhwMsyEIZlmKwqDl7NyLUg5yvzwucYUS0VS7fmhCJSJUALl+bFuGvS/VZe/Ivnj3f69xCu9pf4rwPkw+CZdDDcY2/OF+su83gpXsH7nBe438B+F9do5NjySEwdKNYtkoHVJVo721dTrKM4pzPblyHKH70qroqVzcuPEyy4JD3IgLKB9kyoJIltF/UClbM/HkL0/Z9LL4GOuctlgn9rpXwsX0ve2I2dKo0I/st16yrhAjQHYGGB6IzFxxqXCHj+KiRgzT1ekpQDvZUwtmew1C1seGPuHWApf0FTAyA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB6800.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(366004)(136003)(396003)(346002)(376002)(66446008)(66476007)(71200400001)(66946007)(66556008)(64756008)(52536014)(9686003)(83380400001)(38100700002)(122000001)(7696005)(76116006)(6506007)(8676002)(478600001)(53546011)(26005)(8936002)(4326008)(110136005)(55016002)(186003)(2906002)(54906003)(7416002)(5660300002)(33656002)(86362001)(38070700005)(316002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?gb2312?B?a1ZlL0FoSmFseUxsNlQwbytjZU82UEdPODAzd2VjNHZiQlNscTUzQVRRRnlM?=
 =?gb2312?B?ZTlwUGExQWNvNmF2K1drNmVSZU5HcGRNblpIdXRCN2xzVGZlK3ZicVdQV0hE?=
 =?gb2312?B?Tkp1MU9kellZQmh3QlVXbGI0a3RwdHdYbDNVWmpDeUhWdE5raHB1NkdYRDhU?=
 =?gb2312?B?dzZBb2VqUmNPK2RYSFUwVXA0L09aNmErZFkyOVVhQTY0VTZLdHF4aW9jTGpG?=
 =?gb2312?B?U3p2UTBrYXQvbE1ydEJXT3RoTlZjS2VqTE1nTExaZzJXSHg1R0VVeDVNUW1U?=
 =?gb2312?B?b0RFRExVRi9LQVhCd2ZQRk9ZSzV5TlpIWXo0T09xL3FnNlAvK09XSUErNVB0?=
 =?gb2312?B?L2pObytYRlhsSThMZXErNHQ5OUVLNkl3OGpFOWQzTHorbXErNytJbHc2d2lQ?=
 =?gb2312?B?WkoxTUFKb0pVY2NDZDJFOHBpYm9DdEN0UkpldWhrOENKYXp6Wm82dUhQb3lY?=
 =?gb2312?B?d0VBaWMzQzFSY1dGSGVPdVQ5T2tDVTVFZkJ3VmY5bFJ5aVhlaUlEbnZQd1hM?=
 =?gb2312?B?UENJL25aU0RhdGZ5dWI4a29FRDdWdmJFOFZIRnFsdmVRV1ExZWxhTW56SEtL?=
 =?gb2312?B?aGhOQS9ZUk5yOVVRdWF6S0lGT2RxcmFNRC9ZR3h4eGw3OXo0bnordjVna1Zy?=
 =?gb2312?B?MitYMEE1NzkxYXVQM3NJYUl5OU9XOVlVRUtqSUZaK2JmN2Rma1k3NEY0TkVn?=
 =?gb2312?B?V3RGaTdkSElINnJYQnQ3eC93OUJ2SjIzQ2hjd1dqemMvRzU0TndnSjN4SGF0?=
 =?gb2312?B?N2UvY0RnR2ZCV0xVMHJjT2RJbVJ3b3JHRGljTlovU3U2OVlTNVVybENZZi94?=
 =?gb2312?B?bnQ0SGlLN3NtVzl2WUVHeGpUeERUVU10RWYyNmdLTGRWY0JwdjB0MnJNdlN0?=
 =?gb2312?B?dGJSQ1MwZk42ZWNRZFBQZmxJb1NjdGh3S1FGS1B2RWN3MVNNZk0rQWJ3RmhN?=
 =?gb2312?B?ZDIxYVBMZ3dXeDZ6TWtuMG1zNnVFNUM0eEx5NkY2UlRaZ1dKbFgreHZQdHpS?=
 =?gb2312?B?em1yNGFibTFvak5iYzhFN2xGcGxJQ2FOOTlBSFFWNFpMYkFpYTI4eUMzSTNZ?=
 =?gb2312?B?RHdKTUw2RHBGNjRwQ1hxYzJYcDk0Z1RybWFGcWxOUTc3Z3A3b2NsQTk1OWw5?=
 =?gb2312?B?ZU44RmdsR1NWN1pMbEhzbVE4OE1SaU1jVWZ0RVFMYVArR0hLa1hOcXJNRVpO?=
 =?gb2312?B?WW9jZnh0VnRwNjNkS1FmeW5vSkJobHhrRDNNWlZQV0hoWUxtaGxHWHRoMlhV?=
 =?gb2312?B?UTUvL1FOY1ZlM3hOTEtkOEUxNFcwbjgrZGFDNXB0eit0K0Y1ZUQ4NzNBTzJa?=
 =?gb2312?B?WFpmMXAycGhGZDFCZklpS1NWL1hhTi9WNXp5SXhUOElQeGNPbkRBNzRUcDFX?=
 =?gb2312?B?R0E5QThkYjVaZjVQdlhhblpjZDFPZHUwRVdvNTR3K2ZFSnVDT253VUFiU3RE?=
 =?gb2312?B?ODEvTmU3MFdkWTJ1bUZwL2xlaVQybnZoSk52c0hQK3c3cmxnd1RiZ2c0M0lw?=
 =?gb2312?B?WVdNc1FWcVBOYlZTeWVMS3lqejExOHpRVHpNVmxNU09IaGZyUUpITUlBc3hQ?=
 =?gb2312?B?Mk00cGNIL0lQTDdHUmpNYTdmRVg5VDVXYitjei9oZHBoREMxTUxJYlZFU2do?=
 =?gb2312?B?SkZFM1p6K2w5SWtQTnhOOUhYaVZYWE4wT0E3NnU0THNXak4rb0hHQmUycy9t?=
 =?gb2312?B?dXNGSEplZDRPQ1oxQ1lSNUJvbDluVitFek5zMFhUS3AvQzI3OS9NNW92cUNE?=
 =?gb2312?Q?lSAyv0kiMDKyoisK2I=3D?=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB6800.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b1aec9b6-4274-4c26-c940-08d95c9efd6f
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Aug 2021 08:06:57.4851
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: b1YdfXbRQ/UieCT/WNCQwpwUL6nL6Am9J9UR6QoT9ULv2gH/QCHQiSLkmKqcEVsw40U8tnkFmilxks3vaF4Utg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5615
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IEZsb3JpYW4gRmFpbmVsbGkg
PGYuZmFpbmVsbGlAZ21haWwuY29tPg0KPiBTZW50OiAyMDIxxOo41MIxMcjVIDE6NDUNCj4gVG86
IEpvYWtpbSBaaGFuZyA8cWlhbmdxaW5nLnpoYW5nQG54cC5jb20+OyBkYXZlbUBkYXZlbWxvZnQu
bmV0Ow0KPiBrdWJhQGtlcm5lbC5vcmc7IHJvYmgrZHRAa2VybmVsLm9yZzsgc2hhd25ndW9Aa2Vy
bmVsLm9yZzsNCj4gcy5oYXVlckBwZW5ndXRyb25peC5kZTsgZmVzdGV2YW1AZ21haWwuY29tOyBh
bmRyZXdAbHVubi5jaA0KPiBDYzoga2VybmVsQHBlbmd1dHJvbml4LmRlOyBkbC1saW51eC1pbXgg
PGxpbnV4LWlteEBueHAuY29tPjsNCj4gbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsgZGV2aWNldHJl
ZUB2Z2VyLmtlcm5lbC5vcmc7DQo+IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4
LWFybS1rZXJuZWxAbGlzdHMuaW5mcmFkZWFkLm9yZw0KPiBTdWJqZWN0OiBSZTogW1BBVENIIG5l
dC1uZXh0IDEvM10gZHQtYmluZGluZ3M6IG5ldDogZnNsLCBmZWM6IGFkZCAiZnNsLA0KPiB3YWtl
dXAtaXJxIiBwcm9wZXJ0eQ0KPiANCj4gDQo+IA0KPiBPbiA4LzkvMjAyMSA3OjIxIFBNLCBKb2Fr
aW0gWmhhbmcgd3JvdGU6DQo+ID4NCj4gPiBIaSBGbG9yaWFuLA0KPiA+DQo+ID4+IC0tLS0tT3Jp
Z2luYWwgTWVzc2FnZS0tLS0tDQo+ID4+IEZyb206IEZsb3JpYW4gRmFpbmVsbGkgPGYuZmFpbmVs
bGlAZ21haWwuY29tPg0KPiA+PiBTZW50OiAyMDIxxOo41MIxMMjVIDI6NDANCj4gPj4gVG86IEpv
YWtpbSBaaGFuZyA8cWlhbmdxaW5nLnpoYW5nQG54cC5jb20+OyBkYXZlbUBkYXZlbWxvZnQubmV0
Ow0KPiA+PiBrdWJhQGtlcm5lbC5vcmc7IHJvYmgrZHRAa2VybmVsLm9yZzsgc2hhd25ndW9Aa2Vy
bmVsLm9yZzsNCj4gPj4gcy5oYXVlckBwZW5ndXRyb25peC5kZTsgZmVzdGV2YW1AZ21haWwuY29t
OyBhbmRyZXdAbHVubi5jaA0KPiA+PiBDYzoga2VybmVsQHBlbmd1dHJvbml4LmRlOyBkbC1saW51
eC1pbXggPGxpbnV4LWlteEBueHAuY29tPjsNCj4gPj4gbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsg
ZGV2aWNldHJlZUB2Z2VyLmtlcm5lbC5vcmc7DQo+ID4+IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5l
bC5vcmc7IGxpbnV4LWFybS1rZXJuZWxAbGlzdHMuaW5mcmFkZWFkLm9yZw0KPiA+PiBTdWJqZWN0
OiBSZTogW1BBVENIIG5ldC1uZXh0IDEvM10gZHQtYmluZGluZ3M6IG5ldDogZnNsLCBmZWM6IGFk
ZA0KPiA+PiAiZnNsLCB3YWtldXAtaXJxIiBwcm9wZXJ0eQ0KPiA+Pg0KPiA+Pg0KPiA+Pg0KPiA+
PiBPbiA4LzgvMjAyMSAxMDowOCBQTSwgSm9ha2ltIFpoYW5nIHdyb3RlOg0KPiA+Pj4NCj4gPj4+
IEhpIEZsb3JpYW4sDQo+ID4+Pg0KPiA+Pj4+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+
ID4+Pj4gRnJvbTogRmxvcmlhbiBGYWluZWxsaSA8Zi5mYWluZWxsaUBnbWFpbC5jb20+DQo+ID4+
Pj4gU2VudDogMjAyMcTqONTCNcjVIDE3OjE4DQo+ID4+Pj4gVG86IEpvYWtpbSBaaGFuZyA8cWlh
bmdxaW5nLnpoYW5nQG54cC5jb20+OyBkYXZlbUBkYXZlbWxvZnQubmV0Ow0KPiA+Pj4+IGt1YmFA
a2VybmVsLm9yZzsgcm9iaCtkdEBrZXJuZWwub3JnOyBzaGF3bmd1b0BrZXJuZWwub3JnOw0KPiA+
Pj4+IHMuaGF1ZXJAcGVuZ3V0cm9uaXguZGU7IGZlc3RldmFtQGdtYWlsLmNvbTsgYW5kcmV3QGx1
bm4uY2gNCj4gPj4+PiBDYzoga2VybmVsQHBlbmd1dHJvbml4LmRlOyBkbC1saW51eC1pbXggPGxp
bnV4LWlteEBueHAuY29tPjsNCj4gPj4+PiBuZXRkZXZAdmdlci5rZXJuZWwub3JnOyBkZXZpY2V0
cmVlQHZnZXIua2VybmVsLm9yZzsNCj4gPj4+PiBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3Jn
OyBsaW51eC1hcm0ta2VybmVsQGxpc3RzLmluZnJhZGVhZC5vcmcNCj4gPj4+PiBTdWJqZWN0OiBS
ZTogW1BBVENIIG5ldC1uZXh0IDEvM10gZHQtYmluZGluZ3M6IG5ldDogZnNsLCBmZWM6IGFkZA0K
PiA+Pj4+ICJmc2wsIHdha2V1cC1pcnEiIHByb3BlcnR5DQo+ID4+Pj4NCj4gPj4+Pg0KPiA+Pj4+
DQo+ID4+Pj4gT24gOC81LzIwMjEgMTI6NDYgQU0sIEpvYWtpbSBaaGFuZyB3cm90ZToNCj4gPj4+
Pj4gQWRkICJmc2wsd2FrZXVwLWlycSIgcHJvcGVydHkgZm9yIEZFQyBjb250cm9sbGVyIHRvIHNl
bGVjdCB3YWtldXANCj4gPj4+Pj4gaXJxIHNvdXJjZS4NCj4gPj4+Pj4NCj4gPj4+Pj4gU2lnbmVk
LW9mZi1ieTogRnVnYW5nIER1YW4gPGZ1Z2FuZy5kdWFuQG54cC5jb20+DQo+ID4+Pj4+IFNpZ25l
ZC1vZmYtYnk6IEpvYWtpbSBaaGFuZyA8cWlhbmdxaW5nLnpoYW5nQG54cC5jb20+DQo+ID4+Pj4N
Cj4gPj4+PiBXaHkgYXJlIG5vdCB5b3UgbWFraW5nIHVzZSBvZiB0aGUgc3RhbmRhcmQgaW50ZXJy
dXB0cy1leHRlbmRlZA0KPiA+Pj4+IHByb3BlcnR5IHdoaWNoIGFsbG93cyBkaWZmZXJlbnQgaW50
ZXJydXB0IGxpbmVzIHRvIGJlIG9yaWdpbmF0aW5nDQo+ID4+Pj4gZnJvbSBkaWZmZXJlbnQgaW50
ZXJydXB0IGNvbnRyb2xsZXJzLCBlLmcuOg0KPiA+Pj4+DQo+ID4+Pj4gaW50ZXJydXB0cy1leHRl
bmRlZCA9IDwmZ2ljIEdJQ19TUEkgMTEyIDQ+LCA8Jndha2V1cF9pbnRjIDA+Ow0KPiA+Pj4NCj4g
Pj4+IFRoYW5rcy4NCj4gPj4+DQo+ID4+PiBBRkFJSywgaW50ZXJydXB0cy1leHRlbmRlZCBzaG91
bGQgYmUgdXNlZCBpbnN0ZWFkIG9mIGludGVycnVwdHMgd2hlbg0KPiA+Pj4gYSBkZXZpY2UgaXMg
Y29ubmVjdGVkIHRvIG11bHRpcGxlIGludGVycnVwdCBjb250cm9sbGVycyBhcyBpdA0KPiA+Pj4g
ZW5jb2RlcyBhIHBhcmVudCBwaGFuZGxlIHdpdGggZWFjaCBpbnRlcnJ1cHQgc3BlY2lmaWVyLiBI
b3dldmVyLCBmb3INCj4gPj4+IEZFQyBjb250cm9sbGVyLCBhbGwNCj4gPj4gaW50ZXJydXB0IGxp
bmVzIGFyZSBvcmlnaW5hdGluZyBmcm9tIHRoZSBzYW1lIGludGVycnVwdCBjb250cm9sbGVycy4N
Cj4gPj4NCj4gPj4gT0ssIHNvIHdoeSB0aGlzIGN1c3RvbSBwcm9wZXJ0eSB0aGVuPw0KPiA+Pg0K
PiA+Pj4NCj4gPj4+IDEpIEZFQyBjb250cm9sbGVyIGhhcyB1cCB0byA0IGludGVycnVwdCBsaW5l
cyBhbmQgYWxsIG9mIHRoZXNlIGFyZQ0KPiA+Pj4gcm91dGVkIHRvIEdJQw0KPiA+PiBpbnRlcnJ1
cHQgY29udHJvbGxlci4NCj4gPj4+IDIpIEZFQyBoYXMgYSB3YWtldXAgaW50ZXJydXB0IHNpZ25h
bCBhbmQgYWx3YXlzIGFyZSBtaXhlZCB3aXRoIG90aGVyDQo+ID4+IGludGVycnVwdCBzaWduYWxz
LCBhbmQgdGhlbiBvdXRwdXQgdG8gb25lIGludGVycnVwdCBsaW5lLg0KPiA+Pj4gMykgRm9yIGxl
Z2FjeSBTb0NzLCB3YWtldXAgaW50ZXJydXB0IGFyZSBtaXhlZCB0byBpbnQwIGxpbmUsIGJ1dCBm
b3INCj4gPj4+IGkuTVg4TQ0KPiA+PiBzZXJpYWxzLCBhcmUgbWl4ZWQgdG8gaW50MiBsaW5lLg0K
PiA+Pj4gNCkgTm93IGRyaXZlciB0cmVhdCBpbnQwIGFzIHRoZSB3YWtldXAgc291cmNlIGJ5IGRl
ZmF1bHQsIGl0IGlzDQo+ID4+PiBicm9rZW4gZm9yDQo+ID4+IGkuTVg4TS4NCj4gPj4NCj4gPj4g
SSBkb24ndCByZWFsbHkga25vdyB3aGF0IHRvIG1ha2Ugb2YgeW91ciByZXNwb25zZSwgaXQgc2Vl
bXMgdG8gbWUNCj4gPj4gdGhhdCB5b3UgYXJlIGNhcnJ5aW5nIHNvbWUgbGVnYWN5IERldmljZSBU
cmVlIHByb3BlcnRpZXMgdGhhdCB3ZXJlDQo+ID4+IGludmVudGVkIHdoZW4gaW50ZXJydXB0cy1l
eHRlbmRlZCBkaWQgbm90IGV4aXN0IGFuZCB3ZSBkaWQgbm90IGtub3cgYW55DQo+IGJldHRlci4N
Cj4gPg0KPiA+IEFzIEkgZGVzY3JpYmVkIGluIGZvcm1lciBtYWlsLCBpdCBpcyBub3QgcmVsYXRl
ZCB0byBpbnRlcnJ1cHRzLWV4dGVuZGVkDQo+IHByb3BlcnR5Lg0KPiA+DQo+ID4gTGV0J3MgdGFr
ZSBhIGxvb2ssIGUuZy4NCj4gPg0KPiA+IDEpIGFyY2gvYXJtL2Jvb3QvZHRzL2lteDdkLmR0c2kN
Cj4gPiBpbnRlcnJ1cHRzID0gPEdJQ19TUEkgMTAyIElSUV9UWVBFX0xFVkVMX0hJR0g+LA0KPiA+
IAkJPEdJQ19TUEkgMTAwIElSUV9UWVBFX0xFVkVMX0hJR0g+LA0KPiA+IAkJPEdJQ19TUEkgMTAx
IElSUV9UWVBFX0xFVkVMX0hJR0g+LA0KPiA+IAkJPEdJQ19TUEkgMTAzIElSUV9UWVBFX0xFVkVM
X0hJR0g+Ow0KPiA+IGludGVycnVwdC1uYW1lcyA9ICJpbnQwIiwgImludDEiLCAiaW50MiIsICJw
cHMiOw0KPiA+DQo+ID4gRm9yIHRoZXNlIDQgaW50ZXJydXB0cyBhcmUgb3JpZ2luYXRpbmcgZnJv
bSBHSUMgaW50ZXJydXB0IGNvbnRyb2xsZXIsDQo+ID4gImludDAiIGZvciBxdWV1ZSAwIGFuZCBv
dGhlciBpbnRlcnJ1cHQgc2lnbmFscywgY29udGFpbmluZyB3YWtldXA7ICJpbnQxIiBmb3INCj4g
cXVldWUgMTsgImludDIiIGZvciBxdWV1ZSAyLg0KPiA+DQo+ID4gMikgYXJjaC9hcm02NC9ib290
L2R0cy9mcmVlc2NhbGUvaW14OG1xLmR0c2kNCj4gPiBpbnRlcnJ1cHRzID0gPEdJQ19TUEkgMTE4
IElSUV9UWVBFX0xFVkVMX0hJR0g+LA0KPiA+IAk8R0lDX1NQSSAxMTkgSVJRX1RZUEVfTEVWRUxf
SElHSD4sDQo+ID4gCTxHSUNfU1BJIDEyMCBJUlFfVFlQRV9MRVZFTF9ISUdIPiwNCj4gPiAJPEdJ
Q19TUEkgMTIxIElSUV9UWVBFX0xFVkVMX0hJR0g+Ow0KPiA+IGludGVycnVwdC1uYW1lcyA9ICJp
bnQwIiwgImludDEiLCAiaW50MiIsICJwcHMiOw0KPiA+DQo+ID4gRm9yIHRoZXNlIDQgaW50ZXJy
dXB0cyBhcmUgYWxzbyBvcmlnaW5hdGluZyBmcm9tIEdJQyBpbnRlcnJ1cHQNCj4gPiBjb250cm9s
bGVyLCAiaW50MCIgZm9yIHF1ZXVlIDA7ICJpbnQxIiBmb3IgcXVldWUgMTsgImludDIiIGZvciBx
dWV1ZSAyIGFuZCBvdGhlcg0KPiBpbnRlcnJ1cHQgc2lnbmFscywgY29udGFpbmluZyB3YWtldXAu
DQo+ID4NCj4gPiBJZiB3ZSB3YW50IHRvIHVzZSBXb0wgZmVhdHVyZSwgd2UgbmVlZCBpbnZva2Ug
ZW5hYmxlX2lycV93YWtlKCkgdG8gbGV0DQo+ID4gdGhpcyBzcGVjaWZpYyBpbnRlcnJ1cHQgbGlu
ZSBiZSBhIHdha2V1cCBzb3VyY2UuIEZvciBGRUMgZHJpdmVyIG5vdywNCj4gPiBpdCB0cmVhdHMg
ImludDAiIGFzIHdha2V1cCBpbnRlcnJ1cHQgYnkgZGVmYXVsdC4gT2J2aW91c2x5IGl0J3Mgbm90
IGZpbmUgZm9yDQo+IGkuTVg4TSBzZXJpYWxzLCBzaW5jZSBTb0MgbWl4IHdha2V1cCBpbnRlcnJ1
cHQgc2lnbmFsIGludG8gImludDIiLCBzbyBJIGFkZCB0aGlzDQo+ICJmc2wsd2FrZXVwLWlycSIg
Y3VzdG9tIHByb3BlcnR5IHRvIGluZGljYXRlIHdoaWNoIGludGVycnVwdCBsaW5lIGNvbnRhaW5z
DQo+IHdha2V1cCBzaWduYWwuDQo+ID4NCj4gPiBOb3Qgc3VyZSBpZiBJIGhhdmUgZXhwbGFpbmVk
IGl0IGNsZWFybHkgZW5vdWdoLCBmcm9tIG15IHBvaW50IG9mIHZpZXcsIEkgdGhpbmsNCj4gaW50
ZXJydXB0cy1leHRlbmRlZCBwcm9wZXJ0eSBjYW4ndCBmaXggdGhpcyBpc3N1ZSwgcmlnaHQ/DQo+
IA0KPiBUaGlzIGlzIGNsZWFyZXIsIGFuZCBpbmRlZWQgaW50ZXJydXB0cy1leHRlbmRlZCB3b24n
dCBmaXggdGhhdCwgaG93ZXZlciBpdCBzZWVtcw0KPiB0byBtZSB0aGF0IHRoaXMgaXMgYSBwcm9i
bGVtIHRoYXQgb3VnaHQgdG8gYmUgZml4ZWQgYXQgdGhlIGludGVycnVwdA0KPiBjb250cm9sbGVy
L2lycV9jaGlwIGxldmVsIHdoaWNoIHNob3VsZCBrbm93IGFuZCBiZSB0b2xkIHdoaWNoIGludGVy
cnVwdCBsaW5lcw0KPiBjYW4gYmUgbWFkZSB3YWtlLXVwIGludGVycnVwdHMgb3Igbm90LiBGcm9t
IHRoZXJlIG9uLCB0aGUgZHJpdmVyIGNhbiB0ZXN0IHdpdGgNCj4gZW5hYmxlX2lycV93YWtlKCkg
d2hldGhlciB0aGlzIGhhcyBhIGNoYW5jZSBvZiB3b3JraW5nIG9yIG5vdC4NCg0KSG93IGNhbiB3
ZSB0ZXN0IHdpdGggZW5hYmxlX2lycV93YWtlKCk/IEkgYWdyZWUgdGhhdCBpbnRlcnJ1cHQgY29u
dHJvbGxlciBjYW4gcmVjb2duaXplDQp3YWtldXAgaW50ZXJydXB0IGlzIGJldHRlci4gDQoNCj4g
SXQgc2VlbXMgdG8gbWUgdGhhdCB0aGUgJ2ZzbCx3YWtldXAtaXJxJyBwcm9wZXJ0eSBvdWdodCB0
byBiZSB3aXRoaW4gdGhlDQo+IGludGVycnVwdCBjb250cm9sbGVyIERldmljZSBUcmVlIG5vZGUg
KHdoZXJlIGl0IHdvdWxkIGJlIGVhc2llciB0byB2YWxpZGF0ZSB0aGF0DQo+IHRoZSBzcGVjaWZp
YyBpbnRlcnJ1cHQgbGluZSBpcyBjb3JyZWN0KSBhcyBvcHBvc2VkIHRvIHdpdGhpbiB0aGUgY29u
c3VtZXIgKEZFQykNCj4gRGV2aWNlIFRyZWUgbm9kZS4NCg0KTm90IHF1aXRlIHVuZGVyc3RhbmQs
IGNvdWxkIHlvdSBleHBsYWluIG1vcmU/DQoNCj4gPg0KPiA+IElmIHRoZXJlIGlzIGFueSBjb21t
b24gcHJvcGVydGllcyBjYW4gYmUgdXNlZCBmb3IgaXQsIHBsZWFzZSBsZXQgbWUga25vdy4gT3IN
Cj4gYW55IG90aGVyIGJldHRlciBzb2x1dGlvbnMgYWxzbyBiZSBhcHByZWNpYXRlZC4gVGhhbmtz
Lg0KPiANCj4gVGhlcmUgaXMgYSBzdGFuZGFyZCAnd2FrZXVwLXNvdXJjZScgYm9vbGVhbiBwcm9w
ZXJ0eSB0aGF0IGNhbiBiZSBhZGRlZA0KPiB0byBhbnkgRGV2aWNlIFRyZWUgbm9kZSB0byBpbmRp
Y2F0ZSBpdCBjYW4gYmUgYSB3YWtlLXVwIHNvdXJjZSwgYnV0IHdoYXQNCj4geW91IG5lZWQgaGVy
ZSBpcyBhIGJpdG1hc2ssIHNvIGludHJvZHVjaW5nIGEgY3VzdG9tIHByb3BlcnR5IG1heSBiZQ0K
PiBhcHByb3ByaWF0ZSBoZXJlLg0KDQpZZXMsIEkga25vdyAnd2FrZXVwLXNvdXJjZScgYm9vbGVh
biBwcm9wZXJ0eSB0aGF0IGlkZW50aWZ5IHRoaXMgREVWSUNFDQpjYW4gYmUgYSB3YWtldXAgc291
cmNlLCBpdCdzIG5vdCByZWxhdGVkIHRvIGludGVycnVwdC4NCg0KQmVzdCBSZWdhcmRzLA0KSm9h
a2ltIFpoYW5nDQo+IC0tDQo+IEZsb3JpYW4NCg==
