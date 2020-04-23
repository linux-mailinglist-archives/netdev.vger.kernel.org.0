Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2A1D1B64D6
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 21:51:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728141AbgDWTvo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 15:51:44 -0400
Received: from mail-eopbgr80082.outbound.protection.outlook.com ([40.107.8.82]:37845
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726121AbgDWTvo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Apr 2020 15:51:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=exEE6HThFtcn6SpjvO9hpr6+BkVoouLJhZrqxWNzDrZSqQDBYCTHuzLffI4rBl7CWCn3veoqVUKLt4+Nj6vFtgTyRaxc/6m7ZwKlEFSnh76RRkjYwjyZuH7vaoBeFakYaJlx6MC2M7rZel/+MWWqpgyPBeHf2v2tBHdF5fMoF6r3aMBIrLE3/HFkf8JafIQlR/xMNizHEfXeJiikzBwnp0TZW+reB8JKWWU2x9Vw2p+9GAAi0/fLQYY4GkejP0zNTFYV2wrY6iQp9lDSuFLnAuaUhDTLHGBWDZiX3G24/vRKtf+tVjBY41Dq11BsS4WFhYm3TE76XG/HqUZGV5ZrJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ikcFfpWR0Cnl1J8z9/2uVDY0P4LqPtmEWsCgZFKkENU=;
 b=I7JxM29VSHLTSIjHayJ7gNka3ddZ6euMnyq9zFZ4Q0dhXSsrzHgAK/4y+vDVxKhRSm7uktH5iXNEuoVxKaVK600pNT+jpViz0yXO0JD8PtX3LEqePfzCgsV2mKXSalPefaPqPRiTaixWF0Rxt6a2cp4tc9mNZzyRTohHPU3Exvt3Na6QUF43IK6LPeCqdZA4Qeu3gUetcw2EIqltmgk1aTy7qejUWYvZA4F50jD7Rn12IpwcpjibnXSg5zro3t2Aw6AtSaOMJ9L8YNL7CDKfXOKTrCX0PucoIxiZ+KTucgDt1RefiMSH76nlEVIDMmQUZ+rNBp1m/8Uy/8Lj04FPuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ikcFfpWR0Cnl1J8z9/2uVDY0P4LqPtmEWsCgZFKkENU=;
 b=jDAqA0dhEiEIMcRTHNoQ7k5JlZYOMQevm3hSqUITJHvj31pHNB+BIhSWDTKEem9srSwP+EqUFaVWVTD3LMzrwoUn6m7GkZTYRSxnZnCeLGMf5UL8k+1UkCdzyrKjXte3UbuRKDZNDdcLaH1pjMKaqzm4VWdY9eAM4vn2i2LgZEk=
Received: from DB8PR04MB6828.eurprd04.prod.outlook.com (2603:10a6:10:113::21)
 by DB8PR04MB6458.eurprd04.prod.outlook.com (2603:10a6:10:10a::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.29; Thu, 23 Apr
 2020 19:51:41 +0000
Received: from DB8PR04MB6828.eurprd04.prod.outlook.com
 ([fe80::58e6:c037:d476:da0d]) by DB8PR04MB6828.eurprd04.prod.outlook.com
 ([fe80::58e6:c037:d476:da0d%8]) with mapi id 15.20.2921.035; Thu, 23 Apr 2020
 19:51:41 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        =?utf-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Ioana Ciocoi Radulescu <ruxandra.radulescu@nxp.com>,
        Nipun Gupta <nipun.gupta@nxp.com>,
        "shawnguo@kernel.org" <shawnguo@kernel.org>
Subject: RE: [PATCH net-next 1/2] net: sched: report ndo_setup_tc failures via
 extack
Thread-Topic: [PATCH net-next 1/2] net: sched: report ndo_setup_tc failures
 via extack
Thread-Index: AQHWGX+V0nAgRAhJDUa4L0E4fkyFpaiHHedA
Date:   Thu, 23 Apr 2020 19:51:41 +0000
Message-ID: <DB8PR04MB68286A3D37A732C33457DA71E0D30@DB8PR04MB6828.eurprd04.prod.outlook.com>
References: <158765382862.1613879.11444486146802159959.stgit@firesoul>
 <158765386575.1613879.14529998894393984755.stgit@firesoul>
In-Reply-To: <158765386575.1613879.14529998894393984755.stgit@firesoul>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=ioana.ciornei@nxp.com; 
x-originating-ip: [188.25.102.96]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: b4e5eb47-bf33-4156-a6e0-08d7e7bfbe74
x-ms-traffictypediagnostic: DB8PR04MB6458:|DB8PR04MB6458:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB8PR04MB64583F09535D296A1041FBD2E0D30@DB8PR04MB6458.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3044;
x-forefront-prvs: 03827AF76E
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6828.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(376002)(39860400002)(366004)(136003)(346002)(396003)(186003)(5660300002)(26005)(52536014)(54906003)(316002)(4326008)(71200400001)(6506007)(2906002)(966005)(33656002)(478600001)(8936002)(8676002)(81156014)(76116006)(9686003)(44832011)(55016002)(66946007)(86362001)(7696005)(6916009)(66446008)(64756008)(66556008)(66476007);DIR:OUT;SFP:1101;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +mD07MWvJc+EQXVeLEbXAVTaeKQ65honmxOg30W9qb4pFNCGpd+gvHQ4nBsn9vDIKesrhvMXXpFaZ5wTx/yr53KDASvOyFvcl/SJ39ySnbl7nGRp3HJlu3WcMUsfaiqOS23/2ZynJG1YMl4k3c3MljRsKqvOJY2A0POzYAfzVgPVw5OpOt43SnaCWocNX+9/7dtCAAGiVAG04ROimcrzXUkSJ+C/2GdISH1Mwv2R2EAGahcaSii2z7uKYOouJKfjSmXk3NRAxEHzXJe9flKypq3o2yJzxCV1CbftOFCAvFRMqaiC/W7KBc668q2per3ErbLhUyyLQ4Eg7G6D0B2Tg2sxa9YqHcAwMLv9ylr84W71ieWI9xx9AIuTHsuK/eKWO79kplAg1SSIteFVWEG2qCipcWXHakMkVmSYjyZhGUZ7czB1FaWvxO4QT6ufjaaTl+XmxzFh/jpEWwpdgrIcG3pufYARFcFnvxI7pggCZUpsnbBzUieR/kznkB9S0nstwKCBxKdo28MXgX3imyhfEA==
x-ms-exchange-antispam-messagedata: pZL2UXHdiUWMa/erMjK5N4zo//ht1/yy0X8rXrVsf2LknfsUmmtxQb7xPcoFpSvMx4xkCvpMBgdkdADKt2jE1DE0/nqZAXLxGrwnce6oj89MtVF7LML2SI/JpnQgYVbXO7anFeBPjmf3ukgWpll8ow==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b4e5eb47-bf33-4156-a6e0-08d7e7bfbe74
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Apr 2020 19:51:41.5404
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: laUmPV16Xi7k41Lo8z6tvJXDT3zrPJMGZUhwdj2kMqOrfWr1+TKKz7W5K8ApTfZ0xtIygMndK1wdBy4Hg09Sog==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6458
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiBTdWJqZWN0OiBbUEFUQ0ggbmV0LW5leHQgMS8yXSBuZXQ6IHNjaGVkOiByZXBvcnQgbmRvX3Nl
dHVwX3RjIGZhaWx1cmVzIHZpYQ0KPiBleHRhY2sNCj4gDQo+IEhlbHAgZW5kLXVzZXJzIG9mIHRo
ZSAndGMnIGNvbW1hbmQgdG8gc2VlIGlmIHRoZSBkcml2ZXJzIG5kb19zZXR1cF90YyBmdW5jdGlv
bg0KPiBjYWxsIGZhaWxzLiBUcm91Ymxlc2hvb3Rpbmcgd2hlbiB0aGlzIGhhcHBlbnMgaXMgbm9u
LXRyaXZpYWwgKHNlZSBmdWxsIHByb2Nlc3MNCj4gaGVyZVsxXSksIGFuZCByZXN1bHRzIGluIG5l
dF9kZXZpY2UgZ2V0dGluZyBhc3NpZ25lZCB0aGUgJ3FkaXNjIG5vb3AnLCB3aGljaCB3aWxsDQo+
IGRyb3AgYWxsIFRYIHBhY2tldHMgb24gdGhlIGludGVyZmFjZS4NCj4gDQo+IFsxXToNCj4gaHR0
cHM6Ly9naXRodWIuY29tL3hkcC1wcm9qZWN0L3hkcC1wcm9qZWN0L2Jsb2IvbWFzdGVyL2FyZWFz
L2FybTY0L2JvYXJkX254cF9sczEwODgvbnhwLWJvYXJkMDQtdHJvdWJsZXNob290LXFkaXNjLm9y
Zw0KPiANCj4gU2lnbmVkLW9mZi1ieTogSmVzcGVyIERhbmdhYXJkIEJyb3VlciA8YnJvdWVyQHJl
ZGhhdC5jb20+DQo+IC0tLQ0KDQpUZXN0ZWQtYnk6IElvYW5hIENpb3JuZWkgPGlvYW5hLmNpb3Ju
ZWlAbnhwLmNvbT4NCg0KPiAgbmV0L3NjaGVkL2Nsc19hcGkuYyB8ICAgIDUgKysrKy0NCj4gIDEg
ZmlsZSBjaGFuZ2VkLCA0IGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkNCj4gDQo+IGRpZmYg
LS1naXQgYS9uZXQvc2NoZWQvY2xzX2FwaS5jIGIvbmV0L3NjaGVkL2Nsc19hcGkuYyBpbmRleA0K
PiA1NWJkMTQyOTY3OGYuLjExYjY4M2M0NWMyOCAxMDA2NDQNCj4gLS0tIGEvbmV0L3NjaGVkL2Ns
c19hcGkuYw0KPiArKysgYi9uZXQvc2NoZWQvY2xzX2FwaS5jDQo+IEBAIC03MzUsOCArNzM1LDEx
IEBAIHN0YXRpYyBpbnQgdGNmX2Jsb2NrX29mZmxvYWRfY21kKHN0cnVjdCB0Y2ZfYmxvY2sNCj4g
KmJsb2NrLA0KPiAgCUlOSVRfTElTVF9IRUFEKCZiby5jYl9saXN0KTsNCj4gDQo+ICAJZXJyID0g
ZGV2LT5uZXRkZXZfb3BzLT5uZG9fc2V0dXBfdGMoZGV2LCBUQ19TRVRVUF9CTE9DSywgJmJvKTsN
Cj4gLQlpZiAoZXJyIDwgMCkNCj4gKwlpZiAoZXJyIDwgMCkgew0KPiArCQlpZiAoZXJyICE9IC1F
T1BOT1RTVVBQKQ0KPiArCQkJTkxfU0VUX0VSUl9NU0coZXh0YWNrLCAiRHJpdmVyIG5kb19zZXR1
cF90Yw0KPiBmYWlsZWQiKTsNCj4gIAkJcmV0dXJuIGVycjsNCj4gKwl9DQo+IA0KPiAgCXJldHVy
biB0Y2ZfYmxvY2tfc2V0dXAoYmxvY2ssICZibyk7DQo+ICB9DQo+IA0KDQo=
