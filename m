Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4DA53D9BCB
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 04:30:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233443AbhG2CaZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 22:30:25 -0400
Received: from mail-eopbgr10078.outbound.protection.outlook.com ([40.107.1.78]:38117
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233256AbhG2CaY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Jul 2021 22:30:24 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N4Mn7Yq8HdM6sGHLB5GZyY9LfabJ/MtZ6a8GtMSJVF1RVeAe+4KnnZ8DncyRuUKvWt9vPlwIK5yLrfmiXnqu+erF4Fd2/JWlUDuTytWPVkCfkpSnTe0q/GnISr2ov8bjDhb8NOYBlLSvwLkwgfHdIBopQ7vvt5O0mPYWXngiijLyQR0RMNvfs92qd3220rEE49kgFy5k8FZvINbXTyodPWgiS2OWvTX+4REZ65/5RBi06t3JPm/lvWlimQaGaIaC5H2ypB62hxW7xdlN4F1GNVnkCJOT6yegKDbcigckwmTSDmpkntRbaztSsUZ4yFvFH3yD6xe56x5N/a5cvjb8jw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ezlQJCm1ZrdE5+Nh6/6zSbdFepDWRMdsePEfxLIu8Wg=;
 b=AdAWGp/FgqRj32P/mrZjnWj38+SiJWyK2/y+gilrs9DeWwmsYIKDMFUHUAgAg/i5+vzu9pX8/7bi5vzZ4YskDV3Jqd1OtAL9rOMh3Un/Jo1tpnkrw3SkiD2/g57H5amNgL19n0WriiGL34Ttq5PXMy9DH6Xkc/TlNJhseVf/8By/vQj/2jZynmPf7zyeksJhMFz9Cx0bTzloGvu6hcwUwA6F+cFQhKXthvUWPGE2bhJ/U/vqMmjdzWWCFosLDESpPXAQT8olu9Fni9EPBeWlKtWKqOvnQpOFEDaoDL9r8zWaho4yMLCypHu5jDgGhd0XPiI8HEjz8agIDoxQxcLszw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ezlQJCm1ZrdE5+Nh6/6zSbdFepDWRMdsePEfxLIu8Wg=;
 b=JXjrqipuT/Vrr9cF+yWWKWaHIgu9EjwQIahoNH32JwcEkZZ1GSAbXfgFNnqnpeAxVt6t/tuzk0Fd7puuM5MaiVhc2J3QarQxty81kdOw3SJ5WE+ltJTmNS35fbbYwlS3aioqH01A62i9tafcN4uKkecVZC76iHOWOd9lLZbVdcw=
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB8PR04MB5787.eurprd04.prod.outlook.com (2603:10a6:10:ac::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18; Thu, 29 Jul
 2021 02:30:18 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9c70:fd2f:f676:4802]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9c70:fd2f:f676:4802%9]) with mapi id 15.20.4373.021; Thu, 29 Jul 2021
 02:30:18 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "shawnguo@kernel.org" <shawnguo@kernel.org>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "festevam@gmail.com" <festevam@gmail.com>,
        dl-linux-imx <linux-imx@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH V2 net-next 2/7] dt-bindings: net: fsl,fec: add RGMII
 internal clock delay
Thread-Topic: [PATCH V2 net-next 2/7] dt-bindings: net: fsl,fec: add RGMII
 internal clock delay
Thread-Index: AQHXg6b6L2Gti3JTzkCHXY+oXOfS1qtYbK8AgADH0lA=
Date:   Thu, 29 Jul 2021 02:30:18 +0000
Message-ID: <DB8PR04MB6795819E4ED7FD43D740FC00E6EB9@DB8PR04MB6795.eurprd04.prod.outlook.com>
References: <20210728115203.16263-1-qiangqing.zhang@nxp.com>
 <20210728115203.16263-3-qiangqing.zhang@nxp.com> <YQFkysjHFEN1w6Yz@lunn.ch>
In-Reply-To: <YQFkysjHFEN1w6Yz@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bbfb9156-3a3e-446c-0b6a-08d95238ce8b
x-ms-traffictypediagnostic: DB8PR04MB5787:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB8PR04MB5787866C0EC9FBA83B74811DE6EB9@DB8PR04MB5787.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 76pVUnr1gUj5EI/QueFc0PzhB3/UVZui+yp73pKzjo/lRhQEnfj4meXi0PHvM1DrbPtt9BDSE6geZ3LjQw+DQyqzpmuocnm6JuUSGrQjBIMZPd3Cr/wCyuerIm+KvkBLVEbXl+w8zsbY52pMGg7v4qXQrO8XWMOghhDw0LL+HAYas65afnyXACTvMwwq1fPTFXP/Ua/wwjtVvEJ68weQRKFGCTt92sZfD2M3pJ5U4ovtdXrk7iBRnFswlz/l3sFcKhxx5Yh/3/eAoBJwTPrMKspicgPInZmYD7Ck/sBXjHAB5OF2TFbZK84CRUo0h3bb6Z+ELJIqkI4Wy0tekdhf14Q2447u6TRoBHzwImAhlkl81U8TrUJI9vcNF6KlPEE7I1pc0Npi2SU5nalcg5ufiXBkJ7t66NRtsaMf11J+8+NOZLC8nCG6sDNGtK4xtEGRJYlCib09ukS1Dycf6b8HXaT8p+/GO3uv5pL3vVYUwWpoU/dLJDMA6hYvCcu5PjCKy5PJ5+x56TMtA68uhhyr5P2KfBPK8UZSmeCgwjowUStw8rMOFXnE+W/xb/XpsO98Oy1lRMZfisc7rDfTx4R9OZyRPgZISUrkdQBxKb/QWVxSGzNA55hZQYhyBEfLeSsvx7DndjSYAVByUAKFBPqFeD5n3L0VpocRxTXrpYXmKOOz+pEhjb7B4ct4mGqLrqE4CvsMXaHbfTqmwRRAGmHYrg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(346002)(366004)(136003)(39860400002)(478600001)(9686003)(2906002)(33656002)(71200400001)(26005)(7696005)(55016002)(86362001)(6506007)(38070700005)(5660300002)(186003)(53546011)(52536014)(76116006)(8936002)(83380400001)(66556008)(66946007)(64756008)(54906003)(66476007)(316002)(66446008)(7416002)(4326008)(122000001)(8676002)(38100700002)(6916009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?gb2312?B?K0VnRExZUXlTQkVzRk54ZHZNWG5UckFNelBTTHpTSWJ3cVFTY1BJbmJvVjRP?=
 =?gb2312?B?TUVyV0xRU1RNV2wwVGl0SHZObGRlOElycjNGcm0yZXJMeitlcElvVzhWdkxL?=
 =?gb2312?B?aVFFeGhYVHdXZkNycjdDU3doYmFsYXRHMkpJT0YySncxV0J4TVpZVG1Nb2pj?=
 =?gb2312?B?WXNCZE5xMzhQeWxrRS9mSU9rSFB1VkxVMDZ4dEtDeWR1a3k2Yk9ndmhhOGVy?=
 =?gb2312?B?NHlLVUNmbjA3RnM1bERIUDdmcy92eXh5ZnZXRVg2ZzdQR1JsZUkwdmVqTHVL?=
 =?gb2312?B?OWdkMXhTcnBrSHRINXp5eEZEK0h1L0JCSXlxcW90aE5XYlJ6YVREdDdqcnow?=
 =?gb2312?B?OUV5enhJVFhPbEhjR1BtbEM5OGJBeUFOUlp2OVZ2VjloWDBFMkJha3FJTEhs?=
 =?gb2312?B?b085by9DSEVUSVpNWU5Db0pMNm4zM1BXWWF0WUM4Q0dNVTVReEdnMFJQOUxx?=
 =?gb2312?B?N1F4TWZLK2J0RytmUUFnZW8vcHJ1M0srSGFRZkJWNjlob0JHUGkwdFFNVDZT?=
 =?gb2312?B?UzZlY2hIZm9KTW02bkljLzB4amFkM1dsYjFOdVZHbUtBSXU0T3M1dXBmMWFk?=
 =?gb2312?B?ekpjOXUrTkVSQ01WTStYNlpTN2hWWmcxSzF5b0FaNzlvWkZKWUJPK2MxUGV0?=
 =?gb2312?B?ck9FbmZxdlJQK1BNYytSeVhETW9xWHZXRWRWMXAyTGlsQWY0RkNhaWFnOXFO?=
 =?gb2312?B?N3pwVUlQUFFYM0F6VlR5bndDSTRUWTJKNVpQVU0wVWJ1NW1RcFczek9OeW1X?=
 =?gb2312?B?NXpmWXlJaHNia21xb2RsQjJuNDdHdlUrdUJEb2hMWWhNYlJXdGpvdDRRcUha?=
 =?gb2312?B?aGdSaXY5T1oycXJKSUNpNUZUb0ZSZm9XU1FqZjNqUC9iUWhXWW53QlRyNmFz?=
 =?gb2312?B?NTcyT0pWL0JPNWRnS2pzTHhyb3dqMzB0ZTBaS3lYWnRPMnBJei9kZFRtN1da?=
 =?gb2312?B?ZEtwNE9PSFJHTW9UWmk0akhMLzZrUWtTelcrSWFsUE9qbjVidUg1dm5zSVhE?=
 =?gb2312?B?ZmNuYW00L3BhUThFWlhwU05zdDJHclVhZDgyRW9FQ0djZG0vZzNVMzVlaXAr?=
 =?gb2312?B?MlVLeWNENnpBMzZWeVROQldRSzlOdzd3VFp5Tys2ektmbUJGbDhpWnR4TlJ1?=
 =?gb2312?B?bEc4cGpvWkZNYWxSZTFPRzFBV3ltR2NQZzJpdDZvNUVTUnFWNHVXTHpwakpP?=
 =?gb2312?B?UjVUcmJMazlCSVhnUWw3THVzQjFNZTFOUWdudEhuVVFvcjhOV2xwcmdzUFZ0?=
 =?gb2312?B?YUpJeGgvWVcyUCt0VTZsNXkzT0JMNHh6VDE2T3lncithSTFDOXZIMUtXRWZv?=
 =?gb2312?B?VmZJQjhkdDFEZHk5WmcwQTdhTVZ5QVMzNkVLUFRNc0RKZzZZblk1ZWd4QndP?=
 =?gb2312?B?dzE3ekJXR2svNGV6dFNybUhXSUg0SjdkM2h1WUxjK2FtdmFHTlZlUTJWUzVL?=
 =?gb2312?B?dXVaMVB4dHN4dTJlME5TeGxWNzlNRHdEc0NWQUNBbFVHNm04a282MHh6L0FU?=
 =?gb2312?B?SlhSUFNWR2tNTDBjS2d0ZnRjeDJ5ZHN3bkJobWJ0MGVaM2V5cFhmcTFqLzZQ?=
 =?gb2312?B?QzMvVUFNNEZuZDBhZkpYNjd2ai83TTBndURONzRUb3FzSUR2L3RzTkd3MFhT?=
 =?gb2312?B?UnFqNG54M1oxYjlKM29KZ1Z0UXJmTWhiNUw3N3g3T0hmemRNSHdxbnNRYnF3?=
 =?gb2312?B?ZGhsdzNJQVRKaG9NZmoxZitFRzB5VlY3NEl3SVlPZExHR0tyRy9TaUc2VmYr?=
 =?gb2312?Q?dgO3YYFEufbo24BYOqm4tpIA4VVuokFiC7D2w/b?=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bbfb9156-3a3e-446c-0b6a-08d95238ce8b
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jul 2021 02:30:18.5365
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FESJwGI/QkaFB7v8mXFbmJ3xOECTAipYpehT83JVvH+gbrFAi+gEwFppyP8cJbSTOuPmAfMYcsMT6j+lIIv3Lw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB5787
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IEFuZHJldyBMdW5uIDxhbmRy
ZXdAbHVubi5jaD4NCj4gU2VudDogMjAyMcTqN9TCMjjI1SAyMjowOA0KPiBUbzogSm9ha2ltIFpo
YW5nIDxxaWFuZ3FpbmcuemhhbmdAbnhwLmNvbT4NCj4gQ2M6IGRhdmVtQGRhdmVtbG9mdC5uZXQ7
IGt1YmFAa2VybmVsLm9yZzsgcm9iaCtkdEBrZXJuZWwub3JnOw0KPiBzaGF3bmd1b0BrZXJuZWwu
b3JnOyBzLmhhdWVyQHBlbmd1dHJvbml4LmRlOyBrZXJuZWxAcGVuZ3V0cm9uaXguZGU7DQo+IGZl
c3RldmFtQGdtYWlsLmNvbTsgZGwtbGludXgtaW14IDxsaW51eC1pbXhAbnhwLmNvbT47DQo+IG5l
dGRldkB2Z2VyLmtlcm5lbC5vcmc7IGRldmljZXRyZWVAdmdlci5rZXJuZWwub3JnOw0KPiBsaW51
eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnDQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggVjIgbmV0LW5l
eHQgMi83XSBkdC1iaW5kaW5nczogbmV0OiBmc2wsZmVjOiBhZGQgUkdNSUkNCj4gaW50ZXJuYWwg
Y2xvY2sgZGVsYXkNCj4gDQo+IE9uIFdlZCwgSnVsIDI4LCAyMDIxIGF0IDA3OjUxOjU4UE0gKzA4
MDAsIEpvYWtpbSBaaGFuZyB3cm90ZToNCj4gDQo+ID4gKyAgICAgIFRoZSAiZW5ldF8yeF90eGNs
ayIob3B0aW9uKSwgZm9yIFJHTUlJIHNhbXBsaW5nIGNsb2NrIHdoaWNoIGZpeGVkIGF0DQo+IDI1
ME1oei4NCj4gPiArICAgICAgVGhlIGNsb2NrIGlzIHJlcXVpcmVkIGlmIFNvQyBSR01JSSBlbmFi
bGUgY2xvY2sgZGVsYXkuDQo+IA0KPiBIaSBKb2FraW0NCj4gDQo+IFNvIHlvdSBvbmx5IG5lZWQg
dGhlIGNsb2NrIGlmIHlvdSBhcmUgdXNpbmcgUkdNSUkgZGVsYXlzPyBGb3IgUkdNSUkgd2l0aG91
dA0KPiBkZWxheXMsIHRoZSBjbG9jayBpcyBub3QgbmVlZGVkPw0KPiANCj4gWW91IG1pZ2h0IHdh
bnQgdG8gYWRkIGEgY2hlY2sgaW4gdGhlIEMgY29kZSB0aGF0IHRoZSBjbG9jayBpcyBwcm92aWRl
ZCB3aGVuDQo+IG5lZWRlZC4NCg0KSGkgQW5kcmV3LA0KDQpZZXMsIHdlIG9ubHkgbmVlZCB0aGlz
IGNsb2NrIGZvciBSR01JSSBkZWxheXMsIHRoZSBjbG9jayBpcyBub3QgbmVlZGVkIGZvciBSR01J
SSB3aXRob3V0IGRlbGF5cy4NCg0KSGFkIGJldHRlciBhZGQgYmVsb3cgY2hlY2sgdG8gYXZvaWQg
ZW5hYmxpbmcgbmVlZGxlc3MgY2xvY2suIA0KCWlmIChmZXAtPnJnbWlpX3R4Y19kbHkgfHwgZmVw
LT5yZ21paV9yeGNfZGx5KQ0KDQpCZXN0IFJlZ2FyZHMsDQpKb2FraW0gWmhhbmcNCj4gICAgICBB
bmRyZXcNCg==
