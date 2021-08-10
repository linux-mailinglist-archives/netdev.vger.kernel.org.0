Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D86623E5106
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 04:22:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233707AbhHJCWV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 22:22:21 -0400
Received: from mail-eopbgr30072.outbound.protection.outlook.com ([40.107.3.72]:10242
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230048AbhHJCWT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Aug 2021 22:22:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fU9ceS3thQQLjfqRRQmJuKj3xGR3KqUvIWFcndsfGax2FltRNYG94oekbf32bm5Mi5XZs8WTXpMD4pd/0Gpla0O0wVU0Ioh4Q4e6sn/CyDQSnSCH7S21DZMeFe3c9JctJ/j0TTwjWisahL444Pi9wQYdYLi1niOvAczojGLOJdMO4FWPYL7p8b4NL3iadPvFaCb53hGXgtMZMYkS9I2ULnaLPL8Pqv48g6+jI+8eJ+OPHaNRxVELONmXN2EzaJFDiYihFjISUR1R3m5TfZVUZ4hdV6WWgIe4cVEQD4YqrQFoj9qS6f8J70q0T0tf9s+iAgIDmVZY95DAhfhKS4BykQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KiDOoA3pwzW5qDDuNZrkHH2Ag+wI7NfitWY01sACai4=;
 b=CRBgIwtUQbK+1Zxd1hqBoM3N6mCeulpBTO8YPTMyOjL7NEaZPgI/cXlSYFsAbUS3WUBBlK2Lk9VbKju8VZmJhpc0DDEDRLBOhb6/XFpkIC3JqkMwOlwMZUikCYQpH8bZRzJU16qfntSu8zswA5IFIL0hLhkg1Z4kny3qixsdQ7u74gIqQ9KAYkAeWQkYluFK6Oek59dD9tiC3SbMwl2UlUcLGBoXiKxcO7WGSjKcjAoVRuDoCqYrQT/e/Xfq+MuR1f2d/NfxeFtthEr0VM93q9TIzSCPw7BKhmA599p6bVhYEeucAg/HT/uFZFoGoM03eRK9LPPrjiYYkbfCbDExWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KiDOoA3pwzW5qDDuNZrkHH2Ag+wI7NfitWY01sACai4=;
 b=aKyYkkjAEXZfvSeqq5YukW6/U8Q1r8412JK9+7Vk18TMxK0Ijwe1BiUNiO95FEpxZ6b2YjBy80vTOM88hDY2bBEwE5Y02jQO/7zY0oUPAz0sBnWbPnOo+K3fMTAeJSlQHcfhh0NVYqVyNpT4q9Se75NK9KzkWR6+U+oVlOjGtCQ=
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB6PR04MB3207.eurprd04.prod.outlook.com (2603:10a6:6:6::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4394.21; Tue, 10 Aug 2021 02:21:55 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::6969:eadc:6001:c0d]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::6969:eadc:6001:c0d%6]) with mapi id 15.20.4394.023; Tue, 10 Aug 2021
 02:21:55 +0000
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
Thread-Index: AQHXidrZaeAm3FGM8UWFBIfAWGHBc6tqnwvwgADpEgCAAHa+4A==
Date:   Tue, 10 Aug 2021 02:21:55 +0000
Message-ID: <DB8PR04MB6795DC35D0387637052E64A1E6F79@DB8PR04MB6795.eurprd04.prod.outlook.com>
References: <20210805074615.29096-1-qiangqing.zhang@nxp.com>
 <20210805074615.29096-2-qiangqing.zhang@nxp.com>
 <2e1a14bf-2fa8-ed39-d133-807c4e14859c@gmail.com>
 <DB8PR04MB67950F6863A8FEE6745CBC68E6F69@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <498f3cee-8f37-2ab1-93c4-5472572ecc37@gmail.com>
In-Reply-To: <498f3cee-8f37-2ab1-93c4-5472572ecc37@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1e12717b-6188-4362-91a4-08d95ba59f84
x-ms-traffictypediagnostic: DB6PR04MB3207:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB6PR04MB3207607CA3AB961795E8B866E6F79@DB6PR04MB3207.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2733;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +SCydYDZgifP4SUiovTAd4Z0cLOPGl6VKwFNPJvaz8/AaM6HZMdnIpkXUg3Cyb4ptkVxCJ4Z5+FH3jsQgcq+tSyW5WopOdW5HoMxSLHn5k5DLiz8xJk6Dtipg0cJO5Ox8B5bCB+lTmCnLVrHhdq29ZP52nMoFLlI1qswBufg977o5bW+0wjwyymNRFFoXSThy1G1i4WDnqKAcJUBCyh/S2w8czmmNbN03K11Zss336IocRhLIE6ft0C1oZx8ZIE7wAV6HdathdOgUc2awcKigMo8kmeyvk4JzEQ4eQmK55qBewBtoZd7G5dWXAgA95DT7aS5AZQ6e65hKRSBp9ZxhKqtZbwzOziuchC66BFgLWRbUCmX++d8CblUeM/hA8XLGs7kGFIZHMg5VPOZWD05mhPScN4eSfkmhrb9y1hpA0X4sEFU8uHwS5e8RUGv98zT98sRPKyHL5BxWB5KEVd7UlxTtqzh3rG+psVTsPLbVzsabNC3hskIPaLZQQrNxwbaEEiG033mSaBMCVNgIYAueiRTx9yFrgCBBUKUvVVxSy92P5tLP+O4J1s5+03eDX/i9jnivEs8pKwOxdtjW0yASWpEaw8qm8bbEh6fn7xUpgkq3JM02CTMVwKDMgA0zObDXB4gkLppNg7jsbZfe98nkdcJzafy729R0QOQ+yDmHPtNHqRKmE7QsvbAcmG+7cduv4gbzWUumUA3aMkhbOwZ/A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(110136005)(54906003)(26005)(186003)(86362001)(4326008)(83380400001)(71200400001)(6506007)(316002)(33656002)(53546011)(55016002)(7416002)(7696005)(8936002)(9686003)(76116006)(8676002)(52536014)(66946007)(64756008)(66446008)(66476007)(66556008)(38070700005)(508600001)(5660300002)(38100700002)(2906002)(122000001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cWUzYytmMkpxNVl6YkZpbTVCMTVUT1M4WHBpTmN2L3FDOHluMTExR1NjTjJ5?=
 =?utf-8?B?SFVHVE1MRndUTjNZTUcvWENIVWlQKzlaM0xLZ1ZSS0MyeDhEcUNHUlJTOTdJ?=
 =?utf-8?B?enJqV1pVMWNOc2tWWk10WjUyWWt0bXhJQ0JrQXBYOHoxT0krSFdiY0hXSkNM?=
 =?utf-8?B?aUxBcVhKZ2wraXdnNmpueW5FQ2VaK1NIREYxVUJqZnRFYjk2UGtVeHl0Mmp3?=
 =?utf-8?B?RW5JUVdybExxSVN2azdueWh1bU5NNGlRMDVMQzBlc1lCSlpuaU0xQU9vczlZ?=
 =?utf-8?B?ci9FM1pKYUVVR2VSZjJNYWZiQ1lOMzdWVEc2NDg3Si9YL0ZROU0vcm5YNlFx?=
 =?utf-8?B?Szl2RXNTTlBrbjB1c2V2RGM1Mm5reFJKaUQxaWlVbUo0L3lHVjRWWDZnU0oz?=
 =?utf-8?B?eEpKUXVIdmpmSXAxSmtEMEd6eGhWaWkrOWw5Sy93b3VQZW4yQ2VFQmZCU3FS?=
 =?utf-8?B?MHBLK2F1NiswREZwRlp2VHdYQWxDdVFiNDZJRmtuakZQbHdaVStXYzZwdld6?=
 =?utf-8?B?N2IwS3ZQSE5TbjJPbzZnNnVGcTZza0tiT0lYVFpNb0FzczVVRjQ4MDRjcnVm?=
 =?utf-8?B?WFBSMWJxQjVzMWlvT3hNalAyRStSSHY2c3ZnL0plZDEyZ1Y3bjc4SUpMcTEw?=
 =?utf-8?B?aDJWMlZudWNoemRNSmp2TGlnU3BsdzNnYTVQVDNwWEQrcmpEckg0d2ZqWk11?=
 =?utf-8?B?MWdNZEtWVGNUS2Q3Snp0aGV3a1dIMVZncHROVGVrUjJBTE1HZm4wQ2gzdnov?=
 =?utf-8?B?Q1FHbGdZVEZ0Z1F2cUk3bWlOM09maDB1cDNOd2huUFNNd2lwcmdKdUZXbjNa?=
 =?utf-8?B?U1FHTjJKNmZjTmR4dWRCNlRxY0kzcWNCcFFuSGw5M1FSNzhqcjMwVmlmUUNp?=
 =?utf-8?B?b05yOTBlU2h4eTV4SFpvNW4rbGZ3L3QzSGZITjRaMDlLOHpZaWlZbG5nOVRx?=
 =?utf-8?B?ZkRUVEtjSGJhS3pLK01QTXlJVnZjVFE1NkYrN3RQenFTTU9ldVN6QURTL1Vx?=
 =?utf-8?B?TmxJaG5QQnRYUDU5ZFJNc0FtK25GRmpPV3VONm53L0FTS3RHVU0remxQVnIx?=
 =?utf-8?B?c1pVREJKcW1TZDJYYm9FMXppWE1jbFVoeU9BZzR1R1lSN1RoUnE4WG51TUZS?=
 =?utf-8?B?L1h5MTFPa0lXRUpRVTNWRzVucHdvaHpuU3NUR1lhRnFpNXhrclp3WFcycDhv?=
 =?utf-8?B?QmNWWjR6b1o2N2x3dVZOWklGNGdDbnZQd2wyZnE4OXhaQXpKeTAvMkRQMUNa?=
 =?utf-8?B?eWpaMUdTaGZycGhNdnZYN3VrdkQwSkFoSksxTk0reXhzMHJFT1EySFhmYzJ5?=
 =?utf-8?B?aXpQbVhHeGJsSStKbWVyc1ExeVd0Q3l1L1hQSmNVNUhMUHVMRnFheTljdEJn?=
 =?utf-8?B?N1ZrcXd4QlluUFNWY09CUTlIelBSRm5vTFZ1cVpDS2liMXhmVW5aS0hlMjQ1?=
 =?utf-8?B?SHNJcTRCVko3SHJDM0lteFJhYTkvSnZxK0NJQjN4SFFXaFZ6UkR4cllibVYx?=
 =?utf-8?B?dUNXRmtFbU01em1zWjhkb1NObkp1RHhJVDdiZS9INVhnN3QrRnlLOHkzaUZY?=
 =?utf-8?B?dTdCbmc0Y0ZLMmk4cTcyRk1IbXVjdllKbDlSYUNWV1pzRmRydnBWK1lUdTc1?=
 =?utf-8?B?RFdHWnZ6RHpkSVVGOXQxZWNyTndYSjJ2Y2dBUlJFa2tKNlkwRHhNUG8vcW1X?=
 =?utf-8?B?bDlobE5wYUdXWmRoT2dtU094OGNHRXJsTHg2U3lXVjFMZHVDY0R0VmNhSjdr?=
 =?utf-8?Q?rjYGZRQwdpvWXY3N7E=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e12717b-6188-4362-91a4-08d95ba59f84
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Aug 2021 02:21:55.2905
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: X9VXbgduT1Rg8iaevUH/GkhPhyyB2WhMKx8gWdqQiRRRDUBdIBkxh95EAFSizIjNMyZkBGIesnc57b4AaRfBPQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR04MB3207
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpIaSBGbG9yaWFuLA0KDQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IEZs
b3JpYW4gRmFpbmVsbGkgPGYuZmFpbmVsbGlAZ21haWwuY29tPg0KPiBTZW50OiAyMDIx5bm0OOac
iDEw5pelIDI6NDANCj4gVG86IEpvYWtpbSBaaGFuZyA8cWlhbmdxaW5nLnpoYW5nQG54cC5jb20+
OyBkYXZlbUBkYXZlbWxvZnQubmV0Ow0KPiBrdWJhQGtlcm5lbC5vcmc7IHJvYmgrZHRAa2VybmVs
Lm9yZzsgc2hhd25ndW9Aa2VybmVsLm9yZzsNCj4gcy5oYXVlckBwZW5ndXRyb25peC5kZTsgZmVz
dGV2YW1AZ21haWwuY29tOyBhbmRyZXdAbHVubi5jaA0KPiBDYzoga2VybmVsQHBlbmd1dHJvbml4
LmRlOyBkbC1saW51eC1pbXggPGxpbnV4LWlteEBueHAuY29tPjsNCj4gbmV0ZGV2QHZnZXIua2Vy
bmVsLm9yZzsgZGV2aWNldHJlZUB2Z2VyLmtlcm5lbC5vcmc7DQo+IGxpbnV4LWtlcm5lbEB2Z2Vy
Lmtlcm5lbC5vcmc7IGxpbnV4LWFybS1rZXJuZWxAbGlzdHMuaW5mcmFkZWFkLm9yZw0KPiBTdWJq
ZWN0OiBSZTogW1BBVENIIG5ldC1uZXh0IDEvM10gZHQtYmluZGluZ3M6IG5ldDogZnNsLCBmZWM6
IGFkZCAiZnNsLA0KPiB3YWtldXAtaXJxIiBwcm9wZXJ0eQ0KPiANCj4gDQo+IA0KPiBPbiA4Lzgv
MjAyMSAxMDowOCBQTSwgSm9ha2ltIFpoYW5nIHdyb3RlOg0KPiA+DQo+ID4gSGkgRmxvcmlhbiwN
Cj4gPg0KPiA+PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiA+PiBGcm9tOiBGbG9yaWFu
IEZhaW5lbGxpIDxmLmZhaW5lbGxpQGdtYWlsLmNvbT4NCj4gPj4gU2VudDogMjAyMeW5tDjmnIg1
5pelIDE3OjE4DQo+ID4+IFRvOiBKb2FraW0gWmhhbmcgPHFpYW5ncWluZy56aGFuZ0BueHAuY29t
PjsgZGF2ZW1AZGF2ZW1sb2Z0Lm5ldDsNCj4gPj4ga3ViYUBrZXJuZWwub3JnOyByb2JoK2R0QGtl
cm5lbC5vcmc7IHNoYXduZ3VvQGtlcm5lbC5vcmc7DQo+ID4+IHMuaGF1ZXJAcGVuZ3V0cm9uaXgu
ZGU7IGZlc3RldmFtQGdtYWlsLmNvbTsgYW5kcmV3QGx1bm4uY2gNCj4gPj4gQ2M6IGtlcm5lbEBw
ZW5ndXRyb25peC5kZTsgZGwtbGludXgtaW14IDxsaW51eC1pbXhAbnhwLmNvbT47DQo+ID4+IG5l
dGRldkB2Z2VyLmtlcm5lbC5vcmc7IGRldmljZXRyZWVAdmdlci5rZXJuZWwub3JnOw0KPiA+PiBs
aW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnOyBsaW51eC1hcm0ta2VybmVsQGxpc3RzLmluZnJh
ZGVhZC5vcmcNCj4gPj4gU3ViamVjdDogUmU6IFtQQVRDSCBuZXQtbmV4dCAxLzNdIGR0LWJpbmRp
bmdzOiBuZXQ6IGZzbCwgZmVjOiBhZGQNCj4gPj4gImZzbCwgd2FrZXVwLWlycSIgcHJvcGVydHkN
Cj4gPj4NCj4gPj4NCj4gPj4NCj4gPj4gT24gOC81LzIwMjEgMTI6NDYgQU0sIEpvYWtpbSBaaGFu
ZyB3cm90ZToNCj4gPj4+IEFkZCAiZnNsLHdha2V1cC1pcnEiIHByb3BlcnR5IGZvciBGRUMgY29u
dHJvbGxlciB0byBzZWxlY3Qgd2FrZXVwDQo+ID4+PiBpcnEgc291cmNlLg0KPiA+Pj4NCj4gPj4+
IFNpZ25lZC1vZmYtYnk6IEZ1Z2FuZyBEdWFuIDxmdWdhbmcuZHVhbkBueHAuY29tPg0KPiA+Pj4g
U2lnbmVkLW9mZi1ieTogSm9ha2ltIFpoYW5nIDxxaWFuZ3FpbmcuemhhbmdAbnhwLmNvbT4NCj4g
Pj4NCj4gPj4gV2h5IGFyZSBub3QgeW91IG1ha2luZyB1c2Ugb2YgdGhlIHN0YW5kYXJkIGludGVy
cnVwdHMtZXh0ZW5kZWQNCj4gPj4gcHJvcGVydHkgd2hpY2ggYWxsb3dzIGRpZmZlcmVudCBpbnRl
cnJ1cHQgbGluZXMgdG8gYmUgb3JpZ2luYXRpbmcNCj4gPj4gZnJvbSBkaWZmZXJlbnQgaW50ZXJy
dXB0IGNvbnRyb2xsZXJzLCBlLmcuOg0KPiA+Pg0KPiA+PiBpbnRlcnJ1cHRzLWV4dGVuZGVkID0g
PCZnaWMgR0lDX1NQSSAxMTIgND4sIDwmd2FrZXVwX2ludGMgMD47DQo+ID4NCj4gPiBUaGFua3Mu
DQo+ID4NCj4gPiBBRkFJSywgaW50ZXJydXB0cy1leHRlbmRlZCBzaG91bGQgYmUgdXNlZCBpbnN0
ZWFkIG9mIGludGVycnVwdHMgd2hlbiBhDQo+ID4gZGV2aWNlIGlzIGNvbm5lY3RlZCB0byBtdWx0
aXBsZSBpbnRlcnJ1cHQgY29udHJvbGxlcnMgYXMgaXQgZW5jb2RlcyBhDQo+ID4gcGFyZW50IHBo
YW5kbGUgd2l0aCBlYWNoIGludGVycnVwdCBzcGVjaWZpZXIuIEhvd2V2ZXIsIGZvciBGRUMgY29u
dHJvbGxlciwgYWxsDQo+IGludGVycnVwdCBsaW5lcyBhcmUgb3JpZ2luYXRpbmcgZnJvbSB0aGUg
c2FtZSBpbnRlcnJ1cHQgY29udHJvbGxlcnMuDQo+IA0KPiBPSywgc28gd2h5IHRoaXMgY3VzdG9t
IHByb3BlcnR5IHRoZW4/DQo+IA0KPiA+DQo+ID4gMSkgRkVDIGNvbnRyb2xsZXIgaGFzIHVwIHRv
IDQgaW50ZXJydXB0IGxpbmVzIGFuZCBhbGwgb2YgdGhlc2UgYXJlIHJvdXRlZCB0byBHSUMNCj4g
aW50ZXJydXB0IGNvbnRyb2xsZXIuDQo+ID4gMikgRkVDIGhhcyBhIHdha2V1cCBpbnRlcnJ1cHQg
c2lnbmFsIGFuZCBhbHdheXMgYXJlIG1peGVkIHdpdGggb3RoZXINCj4gaW50ZXJydXB0IHNpZ25h
bHMsIGFuZCB0aGVuIG91dHB1dCB0byBvbmUgaW50ZXJydXB0IGxpbmUuDQo+ID4gMykgRm9yIGxl
Z2FjeSBTb0NzLCB3YWtldXAgaW50ZXJydXB0IGFyZSBtaXhlZCB0byBpbnQwIGxpbmUsIGJ1dCBm
b3IgaS5NWDhNDQo+IHNlcmlhbHMsIGFyZSBtaXhlZCB0byBpbnQyIGxpbmUuDQo+ID4gNCkgTm93
IGRyaXZlciB0cmVhdCBpbnQwIGFzIHRoZSB3YWtldXAgc291cmNlIGJ5IGRlZmF1bHQsIGl0IGlz
IGJyb2tlbiBmb3INCj4gaS5NWDhNLg0KPiANCj4gSSBkb24ndCByZWFsbHkga25vdyB3aGF0IHRv
IG1ha2Ugb2YgeW91ciByZXNwb25zZSwgaXQgc2VlbXMgdG8gbWUgdGhhdCB5b3UgYXJlDQo+IGNh
cnJ5aW5nIHNvbWUgbGVnYWN5IERldmljZSBUcmVlIHByb3BlcnRpZXMgdGhhdCB3ZXJlIGludmVu
dGVkIHdoZW4NCj4gaW50ZXJydXB0cy1leHRlbmRlZCBkaWQgbm90IGV4aXN0IGFuZCB3ZSBkaWQg
bm90IGtub3cgYW55IGJldHRlci4NCg0KQXMgSSBkZXNjcmliZWQgaW4gZm9ybWVyIG1haWwsIGl0
IGlzIG5vdCByZWxhdGVkIHRvIGludGVycnVwdHMtZXh0ZW5kZWQgcHJvcGVydHkuDQoNCkxldCdz
IHRha2UgYSBsb29rLCBlLmcuDQoNCjEpIGFyY2gvYXJtL2Jvb3QvZHRzL2lteDdkLmR0c2kNCmlu
dGVycnVwdHMgPSA8R0lDX1NQSSAxMDIgSVJRX1RZUEVfTEVWRUxfSElHSD4sDQoJCTxHSUNfU1BJ
IDEwMCBJUlFfVFlQRV9MRVZFTF9ISUdIPiwNCgkJPEdJQ19TUEkgMTAxIElSUV9UWVBFX0xFVkVM
X0hJR0g+LA0KCQk8R0lDX1NQSSAxMDMgSVJRX1RZUEVfTEVWRUxfSElHSD47DQppbnRlcnJ1cHQt
bmFtZXMgPSAiaW50MCIsICJpbnQxIiwgImludDIiLCAicHBzIjsNCg0KRm9yIHRoZXNlIDQgaW50
ZXJydXB0cyBhcmUgb3JpZ2luYXRpbmcgZnJvbSBHSUMgaW50ZXJydXB0IGNvbnRyb2xsZXIsICJp
bnQwIiBmb3IgcXVldWUgMCBhbmQgb3RoZXIgaW50ZXJydXB0IHNpZ25hbHMsIGNvbnRhaW5pbmcg
d2FrZXVwOw0KImludDEiIGZvciBxdWV1ZSAxOyAiaW50MiIgZm9yIHF1ZXVlIDIuDQoNCjIpIGFy
Y2gvYXJtNjQvYm9vdC9kdHMvZnJlZXNjYWxlL2lteDhtcS5kdHNpDQppbnRlcnJ1cHRzID0gPEdJ
Q19TUEkgMTE4IElSUV9UWVBFX0xFVkVMX0hJR0g+LA0KCTxHSUNfU1BJIDExOSBJUlFfVFlQRV9M
RVZFTF9ISUdIPiwNCgk8R0lDX1NQSSAxMjAgSVJRX1RZUEVfTEVWRUxfSElHSD4sDQoJPEdJQ19T
UEkgMTIxIElSUV9UWVBFX0xFVkVMX0hJR0g+Ow0KaW50ZXJydXB0LW5hbWVzID0gImludDAiLCAi
aW50MSIsICJpbnQyIiwgInBwcyI7DQoNCkZvciB0aGVzZSA0IGludGVycnVwdHMgYXJlIGFsc28g
b3JpZ2luYXRpbmcgZnJvbSBHSUMgaW50ZXJydXB0IGNvbnRyb2xsZXIsICJpbnQwIiBmb3IgcXVl
dWUgMDsgImludDEiIGZvciBxdWV1ZSAxOyAiaW50MiIgZm9yIHF1ZXVlIDIgYW5kIG90aGVyDQpp
bnRlcnJ1cHQgc2lnbmFscywgY29udGFpbmluZyB3YWtldXAuDQoNCklmIHdlIHdhbnQgdG8gdXNl
IFdvTCBmZWF0dXJlLCB3ZSBuZWVkIGludm9rZSBlbmFibGVfaXJxX3dha2UoKSB0byBsZXQgdGhp
cyBzcGVjaWZpYyBpbnRlcnJ1cHQgbGluZSBiZSBhIHdha2V1cCBzb3VyY2UuIEZvciBGRUMgZHJp
dmVyIG5vdywNCml0IHRyZWF0cyAiaW50MCIgYXMgd2FrZXVwIGludGVycnVwdCBieSBkZWZhdWx0
LiBPYnZpb3VzbHkgaXQncyBub3QgZmluZSBmb3IgaS5NWDhNIHNlcmlhbHMsIHNpbmNlIFNvQyBt
aXggd2FrZXVwIGludGVycnVwdCBzaWduYWwgaW50byAiaW50MiIsDQpzbyBJIGFkZCB0aGlzICJm
c2wsd2FrZXVwLWlycSIgY3VzdG9tIHByb3BlcnR5IHRvIGluZGljYXRlIHdoaWNoIGludGVycnVw
dCBsaW5lIGNvbnRhaW5zIHdha2V1cCBzaWduYWwuDQoNCk5vdCBzdXJlIGlmIEkgaGF2ZSBleHBs
YWluZWQgaXQgY2xlYXJseSBlbm91Z2gsIGZyb20gbXkgcG9pbnQgb2YgdmlldywgSSB0aGluayBp
bnRlcnJ1cHRzLWV4dGVuZGVkIHByb3BlcnR5IGNhbid0IGZpeCB0aGlzIGlzc3VlLCByaWdodD8N
Cg0KSWYgdGhlcmUgaXMgYW55IGNvbW1vbiBwcm9wZXJ0aWVzIGNhbiBiZSB1c2VkIGZvciBpdCwg
cGxlYXNlIGxldCBtZSBrbm93LiBPciBhbnkgb3RoZXIgYmV0dGVyIHNvbHV0aW9ucyBhbHNvIGJl
IGFwcHJlY2lhdGVkLiBUaGFua3MuDQogDQpCZXN0IFJlZ2FyZHMsDQpKb2FraW0gWmhhbmcNCj4g
LS0NCj4gRmxvcmlhbg0K
