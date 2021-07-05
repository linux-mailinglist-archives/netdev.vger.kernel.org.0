Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEFDF3BB8B9
	for <lists+netdev@lfdr.de>; Mon,  5 Jul 2021 10:19:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230000AbhGEIWK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Jul 2021 04:22:10 -0400
Received: from mail-eopbgr20078.outbound.protection.outlook.com ([40.107.2.78]:52351
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230129AbhGEIWJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Jul 2021 04:22:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U8oeZbI6SOhkdWrBP1eWyjCwFa9nzOP31yRYoIZbnjg2FVPAvSvlWVwnY5JRYjMuQFKsYPuSDAbHjTY40JSwJA7IKp0v63uXjlTe3pkU6gZN/XP4sE1XMo9ZYlS9okz0FcMHUsu4BrGglOo33wlmklLYleV/PoC5SWnfd4vscOUWkOp5/dT7HYGxQoDLxvlEeU0fjcp0KlLdyX+CZuXEu2zN0LlzJMLhJcOA/vrLGnAIBajjA8bAizcvvhH8BCC2gILg40h3lCkk+xA5xXKd9++QE4JStEsLNYTP2zXP/YKqvJJjz5oA57vvDNDYvHBAZQiJDkzm/FS4+jtKDR6o0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LgKGB2vVUuMkJ7//1XIoqiVr901vHXJY22lJ2wiZGo4=;
 b=U9oUZv6v48bCeKEGc1qFUvRFDzFsyNOjgoifmcCEP3CcDd0X2wxwjWZuk2svZ8hooJIac007g2sPF3v06IqAGHVFf9wUi4Q0sfR2YUJYbo1/ZD0yW8ioXJyGPBkNqcBfWDxhp6z8uQtSSy+v9s75DY586dGY8rqGY5yIEWX7HAy/1MHasPjVWZkO6SbYzvhVn2bEiNLchlihioDspzqalhn3C1flQIzHO3nszk9yeWToh9GNLqadoMiufqqSQD29Gc3Fw63PHeVG3h+EF/i9/770L5HuQbZlBTHIE3DCKzEzoXN6+mhcw+jCEXZrCQEkvsPuXr+uiXEKJp9GwgdmDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LgKGB2vVUuMkJ7//1XIoqiVr901vHXJY22lJ2wiZGo4=;
 b=E8faMAWsg03jmUx6gEVf9KLnFTgVDh+QTQKEn057QYtIjEISJTrqaqURMlsi0Pfe6pjZ1X1bFFw1sC1Xuc7k30zOKvnzJc8bWkh8pI4V6M0NL/EEu3Bs4fyu6QBBlSNjRssRey6RsGB4R/eqPRKxwHmST9t1yUA7OdNpZuu0pww=
Received: from DB7PR04MB5017.eurprd04.prod.outlook.com (2603:10a6:10:1b::21)
 by DBBPR04MB7738.eurprd04.prod.outlook.com (2603:10a6:10:1ea::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.32; Mon, 5 Jul
 2021 08:19:30 +0000
Received: from DB7PR04MB5017.eurprd04.prod.outlook.com
 ([fe80::605f:7d36:5e2d:ebdd]) by DB7PR04MB5017.eurprd04.prod.outlook.com
 ([fe80::605f:7d36:5e2d:ebdd%7]) with mapi id 15.20.4287.033; Mon, 5 Jul 2021
 08:19:30 +0000
From:   "Y.b. Lu" <yangbo.lu@nxp.com>
To:     Richard Cochran <richardcochran@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "mptcp@lists.linux.dev" <mptcp@lists.linux.dev>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Shuah Khan <shuah@kernel.org>,
        Michal Kubecek <mkubecek@suse.cz>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, Rui Sousa <rui.sousa@nxp.com>,
        Sebastien Laveze <sebastien.laveze@nxp.com>
Subject: RE: [net-next, v5, 08/11] net: sock: extend SO_TIMESTAMPING for PHC
 binding
Thread-Topic: [net-next, v5, 08/11] net: sock: extend SO_TIMESTAMPING for PHC
 binding
Thread-Index: AQHXbYYk/ReLznMMgU+HU2CMIFi7Bqsy10+AgAEyYdA=
Date:   Mon, 5 Jul 2021 08:19:30 +0000
Message-ID: <DB7PR04MB50174906EE8CCEB4A02F4C17F81C9@DB7PR04MB5017.eurprd04.prod.outlook.com>
References: <20210630081202.4423-1-yangbo.lu@nxp.com>
 <20210630081202.4423-9-yangbo.lu@nxp.com>
 <20210704133331.GA4268@hoboy.vegasvil.org>
In-Reply-To: <20210704133331.GA4268@hoboy.vegasvil.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.73]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 112a72bd-3a75-4019-f7ce-08d93f8d9cc7
x-ms-traffictypediagnostic: DBBPR04MB7738:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DBBPR04MB77382CDD6715AA884B836507F81C9@DBBPR04MB7738.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ARLRBjRP8FWPIWTq74SlTxk8vgzIFKmyDOMy4CwDPi/Gxxj4+hr6j8t/c8n2sGJMuYX9pHpq9CVJrG/6BIE41qcUTWzQffQgsxRhceXHo1+tzlDPA+dBgdF93Kh7MVuGeFyLUrXnh5G+yvmKnAx8peCwItDiLlfIZ/ouL6T68yab2Ylj/IEDI0gQCcQ919xQSa1X8WXax2to7n850JIpkKN/qg7qsiIh5VNRBwabglSigy6U+ez4lHtNXFu7OUDYymkgezWlM/CLnWbCd4r20PSRUp/WH1DCNTjtz8AnfvlMx+B1NeYEO3QZlI9g9yDO7o9iSyLJe4pwFKKPZYrIhBwPKHwkBsswoMR2mw6pwAu9dcAoulyeQh6wk1LBxObXWAh2oItfYhZcLD5dJCXy3H+bIqvbxW1lkkSQpImRQYdgpxy9CDEeGt48zmwhpbfH+plhN7J9FOJvNdwgF1LAMB/ZpMDRMkI0o36Ku4UMI0giuzrajBrPWTMcks0dRts+w0jo5YIclK63WVAPiV7BDzT/De/QgfCzaKn3kiI2H+q0Ut/p4rgMVWln5scQQeTirtUcX4b2Giha2TWFWyaAZmF77iGgCNdG8eCq5avJwuuUl0NAN8AteWlV7kp+pHZS1/r9gPIZDfIICFxKpGHkig==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR04MB5017.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(346002)(396003)(376002)(39860400002)(33656002)(7416002)(53546011)(76116006)(6916009)(71200400001)(316002)(52536014)(7696005)(64756008)(66446008)(54906003)(38100700002)(6506007)(9686003)(186003)(5660300002)(83380400001)(2906002)(55016002)(478600001)(66476007)(8676002)(86362001)(8936002)(122000001)(66556008)(4326008)(26005)(66946007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?gb2312?B?ZHJZYjd4QjV2OHZlNjhUNzRWNmxUWjNlYk1LQkNYRUVwWVVpNXFwKzlucnFQ?=
 =?gb2312?B?TGNVUXNVZDJrRmV0YlVKaW9oSUliWjZaWDBRRHViOVYyWHZMSWFoYmo5RU5p?=
 =?gb2312?B?NUV3alFLbjhRdTNtc0ZVZ2k5bGxBdlpzYTRNMWtRR0Q2clNlayswR1o5ck1P?=
 =?gb2312?B?S0hKMjRtL3J1Q285OHhFZ1ZmZ0dROFhaRHZxTExGL0dJQk4rRy90SHRQdWV3?=
 =?gb2312?B?S3VzZzVScmNWd1FxRFJ0NHY3R0xDUSs2U1NNMzFKcWZuK2k4WFcrOURIeW5K?=
 =?gb2312?B?TGsrSFhFUzZpRVNXMmJvT1ZyVUl5RXVHSGZPUy9GRU05dVFqSWRQNUl6OXNE?=
 =?gb2312?B?Y3BaeWFUdlplbEdPd0pIUStmMkREdkdzY3F5TnV2RGgzOVBRd0c1Yno5d1Jh?=
 =?gb2312?B?WFUvOEdCbVZSZkYwMVo2ZWZ3NVJ0cnBxanh5cFZibDBpeVF5Yk1Ub1RvSWxP?=
 =?gb2312?B?dSs1SUhnZnJ3Z0REcjA3MG91cmI4ZFdiRWVIY3NJWGllcUlscFBvelVzUkg2?=
 =?gb2312?B?Z3R4YiswWGh2Q3FEOGtQSWsxQ1NLTnZmdEk4ZXA2aWdJMysxRk5YNzF1N0Yz?=
 =?gb2312?B?MitXNjl3STZ1Mm9rSmFncWg1UDZBSWQ3VWFidnNJWk10eHFWbFBpaUJ0QmFq?=
 =?gb2312?B?aVhiYVN2bEdSUVBseUJ4aXhZYUVCUlBKdlM0Q0Uvb3Jvc2xra3F4YnNNaldx?=
 =?gb2312?B?bUhrTlpmYzBXRW4wVitYaWF5SlR3ZU5Pb1JOc241enBocDc0TmZtRWxLL3Nn?=
 =?gb2312?B?TFBHNXJxMm03b2dwelJ3OXptcllXZlVodUEyWXZyRys3NVVFUmRJbkxxVzNL?=
 =?gb2312?B?QkF0RVJTRFVyZVRpSWRwUEhVbjJWNU9RVFAyWGVaaGFkVGZNc004TWxSbkdx?=
 =?gb2312?B?YUtiRm5JUWFLbzhPUmJUbHorOXZCVW5xdFpqQnMyOS9jQy85UnZUam5XV2ZT?=
 =?gb2312?B?Q2hTVUhmLzZKRGF0UUEzajFGMVBCcEZrQVpSNmtNZFhxZjZxbnBtdHMxdm9x?=
 =?gb2312?B?b054aGVsT2tFK2Njb001Sm1ESnhOSHR4T2FxSFhrdGZNUExHaTdmUTRaWGt5?=
 =?gb2312?B?NldoUHExUFlXY1Z2Q0J0am0yRUt4SnNhaFNsVy9QYUZYRzUrRnBqUmpNcDZo?=
 =?gb2312?B?aU9JbXIxTTErdGJtR3AyTURpemZVVlV6S1hKTlFsTDdxWnlSOUJ2SjFlV1FQ?=
 =?gb2312?B?UXFEdVdGemh3OFZjQWswKzg2YVNFdDRCdWNDMkdrY0NtZDF1TFUvQVZMUTgv?=
 =?gb2312?B?Y1ZVSmJmTW1KcEFZK0hIb2hnbEFOSW1SZjlZSytLcTFVVXYxVUJCNVNqblBX?=
 =?gb2312?B?VFlyRnljZE50TCtZcUlkQlQwb1FNS0FxU1Q1VU1rZklnU1Y1RTEyTUltY09s?=
 =?gb2312?B?YlAvUVJZM3hWYnpSWGlkSUd5RXBYQjh4VEwzczAxZDN4KzRlY2h6SUlwcm0z?=
 =?gb2312?B?MFdWZ1dvYkY4RnlISXBuUkoxZGt0cHkvcm4ydktSWk54cmRrVmNyOE1tQlNN?=
 =?gb2312?B?cm1kZ1FIMVR2RzZ3VklsQzMwMnlIOHE0VE41TXp0bHNLNHp2ZFV4Z0FRVFZx?=
 =?gb2312?B?c0xXR3F4cHcxajBYQU5LNk94RHdVbDRWVCtFNFJnd3Z5cXhHcTZjSmVDZm01?=
 =?gb2312?B?RDJLdkI1RFhsMEZmYllCRmFOTVNxNmxVdUZrSzdnZG5JbWVJYmI2aDl6cERD?=
 =?gb2312?B?amtENWwzbjlSYWpyZXh0dUNkaWdwMTg2aUVGaUlWRWUxdDUrSlc5TDFuTHlq?=
 =?gb2312?Q?SLfFeF01oCm545JJFxkXiEX6E1oq7ttvXSEjTw/?=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB5017.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 112a72bd-3a75-4019-f7ce-08d93f8d9cc7
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jul 2021 08:19:30.2115
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +w+afdewIL39qW80JzWaKzDp6qIiVbSk0yzWYqjghArfM1EwxvlTl/Ur3AI3/tbrxwMbD8d2iD89gHAUTBnn3Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB7738
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgUmljaGFyZCwNCg0KPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBSaWNo
YXJkIENvY2hyYW4gPHJpY2hhcmRjb2NocmFuQGdtYWlsLmNvbT4NCj4gU2VudDogMjAyMcTqN9TC
NMjVIDIxOjM0DQo+IFRvOiBZLmIuIEx1IDx5YW5nYm8ubHVAbnhwLmNvbT4NCj4gQ2M6IG5ldGRl
dkB2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmc7DQo+IGxpbnV4
LWtzZWxmdGVzdEB2Z2VyLmtlcm5lbC5vcmc7IG1wdGNwQGxpc3RzLmxpbnV4LmRldjsgRGF2aWQg
UyAuIE1pbGxlcg0KPiA8ZGF2ZW1AZGF2ZW1sb2Z0Lm5ldD47IEpha3ViIEtpY2luc2tpIDxrdWJh
QGtlcm5lbC5vcmc+OyBNYXQgTWFydGluZWF1DQo+IDxtYXRoZXcuai5tYXJ0aW5lYXVAbGludXgu
aW50ZWwuY29tPjsgTWF0dGhpZXUgQmFlcnRzDQo+IDxtYXR0aGlldS5iYWVydHNAdGVzc2FyZXMu
bmV0PjsgU2h1YWggS2hhbiA8c2h1YWhAa2VybmVsLm9yZz47IE1pY2hhbA0KPiBLdWJlY2VrIDxt
a3ViZWNla0BzdXNlLmN6PjsgRmxvcmlhbiBGYWluZWxsaSA8Zi5mYWluZWxsaUBnbWFpbC5jb20+
Ow0KPiBBbmRyZXcgTHVubiA8YW5kcmV3QGx1bm4uY2g+OyBSdWkgU291c2EgPHJ1aS5zb3VzYUBu
eHAuY29tPjsgU2ViYXN0aWVuDQo+IExhdmV6ZSA8c2ViYXN0aWVuLmxhdmV6ZUBueHAuY29tPg0K
PiBTdWJqZWN0OiBSZTogW25ldC1uZXh0LCB2NSwgMDgvMTFdIG5ldDogc29jazogZXh0ZW5kIFNP
X1RJTUVTVEFNUElORyBmb3INCj4gUEhDIGJpbmRpbmcNCj4gDQo+IE9uIFdlZCwgSnVuIDMwLCAy
MDIxIGF0IDA0OjExOjU5UE0gKzA4MDAsIFlhbmdibyBMdSB3cm90ZToNCj4gPiBTaW5jZSBQVFAg
dmlydHVhbCBjbG9jayBzdXBwb3J0IGlzIGFkZGVkLCB0aGVyZSBjYW4gYmUgc2V2ZXJhbCBQVFAN
Cj4gPiB2aXJ0dWFsIGNsb2NrcyBiYXNlZCBvbiBvbmUgUFRQIHBoeXNpY2FsIGNsb2NrIGZvciB0
aW1lc3RhbXBpbmcuDQo+ID4NCj4gPiBUaGlzIHBhdGNoIGlzIHRvIGV4dGVuZCBTT19USU1FU1RB
TVBJTkcgQVBJIHRvIHN1cHBvcnQgUEhDIChQVFANCj4gPiBIYXJkd2FyZSBDbG9jaykgYmluZGlu
ZyBieSBhZGRpbmcgYSBuZXcgZmxhZw0KPiA+IFNPRl9USU1FU1RBTVBJTkdfQklORF9QSEMuIFdo
ZW4gUFRQIHZpcnR1YWwgY2xvY2tzIGFyZSBpbiB1c2UsIHVzZXINCj4gPiBzcGFjZSBjYW4gY29u
ZmlndXJlIHRvIGJpbmQgb25lIGZvciB0aW1lc3RhbXBpbmcsIGJ1dCBQVFAgcGh5c2ljYWwNCj4g
PiBjbG9jayBpcyBub3Qgc3VwcG9ydGVkIGFuZCBub3QgbmVlZGVkIHRvIGJpbmQuDQo+IA0KPiBX
b3VsZCBpdCBub3QgYmUgYmV0dGVyIHRvIHNpbXBseSBiaW5kIGF1dG9tYXRpY2FsbHk/DQo+IA0K
PiBMaWtlIHRoaXMgcHNldWRvIGNvZGU6DQo+IA0KPiAJaWYgKGh3X3RpbWVzdGFtcGluZ19yZXF1
ZXN0ZWQoKSAmJiBpbnRlcmZhY2VfaXNfdmNsb2NrKCkpIHsNCj4gCQliaW5kX3ZjbG9jaygpOw0K
PiAJfQ0KPiANCj4gSXQgd291bGQgYmUgZ3JlYXQgdG8gYXZvaWQgZm9yY2luZyB1c2VyIHNwYWNl
IHRvIHVzZSBhIG5ldyBvcHRpb24uDQo+IA0KPiBFc3BlY2lhbGx5IGJlY2F1c2UgTk9UIHNldHRp
bmcgdGhlIG9wdGlvbiBtYWtlcyBubyBzZW5zZS4gIE9yIG1heWJlIHRoZXJlIGlzDQo+IGEgdXNl
IGNhc2UgZm9yIG9taXR0aW5nIHRoZSBvcHRpb24/DQo+IA0KPiANCj4gVGhvdWdodHM/DQoNCldo
ZW4gc2V2ZXJhbCBwdHAgdmlydHVhbCBjbG9ja3MgYXJlIGNyZWF0ZWQsIHRoZSBwdHAgcGh5c2lj
YWwgY2xvY2sgaXMgZ3VhcmFudGVlZCBmb3IgZnJlZSBydW5uaW5nLg0KDQpXaGF0IEkgdGhpbmsg
aXMsIGZvciB0aW1lc3RhbXBpbmcsIGlmIG5vIGZsYWcgU09GX1RJTUVTVEFNUElOR19CSU5EX1BI
QywgdGhlIHRpbWVzdGFtcGluZyBrZWVwcyB1c2luZyBwdHAgcGh5c2ljYWwgY2xvY2suDQpJZiBh
cHBsaWNhdGlvbiB3YW50cyB0byBiaW5kIG9uZSBwdHAgdmlydHVhbCBjbG9jayBmb3IgdGltZXN0
YW1waW5nLCB0aGUgZmxhZyBTT0ZfVElNRVNUQU1QSU5HX0JJTkRfUEhDIHNob3VsZCBiZSBzZXQg
YW5kIGNsb2NrIGluZGV4IHNob3VsZCBiZSBwcm92aWRlZC4NCkFmdGVyIGFsbCwgc2V2ZXJhbCBw
dHAgdmlydHVhbCBjbG9ja3MgY3JlYXRlZCBhcmUgbGlrZWx5IGZvciBkaWZmZXJlbnQgdGltZXNj
YWxlL3VzZSBjYXNlLiBUaGVyZSBzaG91bGQgYmUgYSBtZXRob2QgZm9yIGFueSBvZiBhcHBsaWNh
dGlvbnMgdG8gc2VsZWN0IHRoZSByaWdodCBvbmUgdG8gdXNlLg0KDQpEb2VzIGl0IG1ha2Ugc2Vu
c2U/DQpUaGFuayB5b3UuDQoNCj4gDQo+IFRoYW5rcywNCj4gUmljaGFyZA0K
