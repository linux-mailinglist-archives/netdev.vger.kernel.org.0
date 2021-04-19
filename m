Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41585363BB5
	for <lists+netdev@lfdr.de>; Mon, 19 Apr 2021 08:41:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237578AbhDSGla (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 02:41:30 -0400
Received: from mail-eopbgr60049.outbound.protection.outlook.com ([40.107.6.49]:9376
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229682AbhDSGlV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Apr 2021 02:41:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JqdQRR5y73p6cFWpxro4e8fna++pV6yKU3uQk5/B/5TrEB86ZVjwEqDc0lG2BiMABZ8BOb17k6QJL7rXud+J5ZjjKFs5sA3qU18wVDzUXF2Dwdvl268kwV+sWWotohn9s68Zkcu2uu5Gw5MUKsJC0bDFNL1YRDZksoa7n5nCDIEjd+dNQAHdcDiz2yC0upTfH83VGpnInOnVFLZTpvhzH37HwSpsIWJ/kQxZmCUz3TTPNFrhmvcIe83y8Fov9NS4X9kRwBdJuLpPX6EMEgv5nKH9MFHHmzDwtu9y/+aPIEAksGPRR/zQqmcctZHuHTMekR2X1oSe3ByDva6IzESuIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=75P/XOwMxXI2EKI22dLs6gQrjwLnMmJTZxD/HHnkMgI=;
 b=Q37p2T808OFkCzhKn1tn3jODwrnCsxZdf+0uq74TjJ8YP/oATXp6DMp4Kauk1ja8E2T+1up/sReccLz2xVAaCG0qN9Q4swFTdBC9/OsyYO5sUeAJk4o00DpE72GY1fkFL1X6CbeXlD9BomKqSAS68oqSIh3k/08nRqHubWAsrF2fnUDKeuYJQHi1cHCTCTKGpuuqmBwVFl/dl1+8HQDfuTNOtLXbrV3JqOqtqf9UdXatdbr07uIJ3vzAltbJ7zTIA6vlxXj15wcRHgsxJqxboC+RtCFEdRoR3RoePD87lTWWGYteCPWuZZRffwmxFdOHJszQYL4AAEo30sPMdQalbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=75P/XOwMxXI2EKI22dLs6gQrjwLnMmJTZxD/HHnkMgI=;
 b=Sz1AtAvbqYbUaJ7Bht3xiDWJdulienqc34gSmeLzBkfWj5uxwuQyU1xx6CSJKc5aj2k3tfTDBARA8RoXEH/LCr5YW/+q+DguDj6dYr030sn+8ALo0GdQ2mCprF5VowIgL0klGXFm+oDagpmKEUkBcu00xZglaEJ7mf5UNXOx34Q=
Received: from AM6PR04MB6053.eurprd04.prod.outlook.com (2603:10a6:20b:b9::10)
 by AM6PR04MB5349.eurprd04.prod.outlook.com (2603:10a6:20b:9b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16; Mon, 19 Apr
 2021 06:40:46 +0000
Received: from AM6PR04MB6053.eurprd04.prod.outlook.com
 ([fe80::b034:690:56aa:7b18]) by AM6PR04MB6053.eurprd04.prod.outlook.com
 ([fe80::b034:690:56aa:7b18%4]) with mapi id 15.20.4042.024; Mon, 19 Apr 2021
 06:40:46 +0000
From:   "Alice Guo (OSS)" <alice.guo@oss.nxp.com>
To:     Dominique MARTINET <dominique.martinet@atmark-techno.com>,
        "Alice Guo (OSS)" <alice.guo@oss.nxp.com>
CC:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "rafael@kernel.org" <rafael@kernel.org>,
        Horia Geanta <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "tony@atomide.com" <tony@atomide.com>,
        "geert+renesas@glider.be" <geert+renesas@glider.be>,
        "mturquette@baylibre.com" <mturquette@baylibre.com>,
        "sboyd@kernel.org" <sboyd@kernel.org>,
        "vkoul@kernel.org" <vkoul@kernel.org>,
        "peter.ujfalusi@gmail.com" <peter.ujfalusi@gmail.com>,
        "a.hajda@samsung.com" <a.hajda@samsung.com>,
        "narmstrong@baylibre.com" <narmstrong@baylibre.com>,
        "robert.foss@linaro.org" <robert.foss@linaro.org>,
        "airlied@linux.ie" <airlied@linux.ie>,
        "daniel@ffwll.ch" <daniel@ffwll.ch>,
        "khilman@baylibre.com" <khilman@baylibre.com>,
        "tomba@kernel.org" <tomba@kernel.org>,
        "jyri.sarha@iki.fi" <jyri.sarha@iki.fi>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "will@kernel.org" <will@kernel.org>,
        "mchehab@kernel.org" <mchehab@kernel.org>,
        "ulf.hansson@linaro.org" <ulf.hansson@linaro.org>,
        "adrian.hunter@intel.com" <adrian.hunter@intel.com>,
        "kishon@ti.com" <kishon@ti.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        Leo Li <leoyang.li@nxp.com>,
        "ssantosh@kernel.org" <ssantosh@kernel.org>,
        "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
        "edubezval@gmail.com" <edubezval@gmail.com>,
        "j-keerthy@ti.com" <j-keerthy@ti.com>,
        "balbi@kernel.org" <balbi@kernel.org>,
        "linux@prisktech.co.nz" <linux@prisktech.co.nz>,
        "stern@rowland.harvard.edu" <stern@rowland.harvard.edu>,
        "wim@linux-watchdog.org" <wim@linux-watchdog.org>,
        "linux@roeck-us.net" <linux@roeck-us.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        "linux-clk@vger.kernel.org" <linux-clk@vger.kernel.org>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-amlogic@lists.infradead.org" 
        <linux-amlogic@lists.infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-phy@lists.infradead.org" <linux-phy@lists.infradead.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-staging@lists.linux.dev" <linux-staging@lists.linux.dev>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-watchdog@vger.kernel.org" <linux-watchdog@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: RE: [RFC v1 PATCH 1/3] drivers: soc: add support for soc_device_match
 returning -EPROBE_DEFER
Thread-Topic: [RFC v1 PATCH 1/3] drivers: soc: add support for
 soc_device_match returning -EPROBE_DEFER
Thread-Index: AQHXNNRlSdW4SGiQSE2hc8EPPTkiT6q7RQCAgAAIV3A=
Date:   Mon, 19 Apr 2021 06:40:46 +0000
Message-ID: <AM6PR04MB60536416D5467486837FC673E2499@AM6PR04MB6053.eurprd04.prod.outlook.com>
References: <20210419042722.27554-1-alice.guo@oss.nxp.com>
 <20210419042722.27554-2-alice.guo@oss.nxp.com>
 <YH0Lwy2AYpXaJIex@atmark-techno.com>
In-Reply-To: <YH0Lwy2AYpXaJIex@atmark-techno.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: atmark-techno.com; dkim=none (message not signed)
 header.d=none;atmark-techno.com; dmarc=none action=none
 header.from=oss.nxp.com;
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0c961c51-56e0-48ab-bef6-08d902fe1019
x-ms-traffictypediagnostic: AM6PR04MB5349:
x-ms-exchange-sharedmailbox-routingagent-processed: True
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM6PR04MB53490C503112EACA988772E3A3499@AM6PR04MB5349.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1MRwh754yLTjaEl3An+wiGUDUDEGzec+d++7YiKxIQjrXDNwN4n9g0o5axjCbNtY1Pgv4Enoq0l0D0FCsfFQkTydcOK025i+iFzsWsILcrPwJQlb6ohP6Po4Ca336kRa341teMIZZVOC+DrW2IxUapRfqLNDZi8F8UtIjOwg8f/Q174xPz03jWBj7lIjgc2pITLziWfVYAunzvqiX/k4F4yK7RcuwLpBd7fcof7Q+CvKg5rxOgvl4z5iFMCzJj7k+pyPg3vOXbvZk/k/i3aACP08/zdZRnwnEfvsRfuXm4AYZlRLt0aVwv+QY7wSG0kc8IKd0MDw1kMEEMmgpjSpmkmbbRj9ZwLStub4RG0xgwXe+l3EP6AsZEYSLVsVSdTZxr3E1PZ41Re364NCD3kzXT2gImHt/358Jy6SC9YqIO25n2ZZ3zJahA71SQLOG01rBrcAHwjwCGZB1XzGpxJWKHEe/muiAItWaTqIVWJIHU4kyuQ9foADjucmaPj+2G8UbfMfbaBgRpTAN6vjuydBRt3OGf4C3e0R6pbCHGw4LKqesdzSxcQhAOHzVQwmhhFfYA3HNmWCYal89v7nu+R3YfmNaOyG0of13LK2ZhJ+OgA1kTfXtnke1Zkg+AxbSttp8hh7ztDCVeR1BDB3wVDLyYtzkOA/QJQDYYe4Be2KCp4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR04MB6053.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(396003)(376002)(136003)(39860400002)(9686003)(8676002)(7696005)(66556008)(64756008)(66946007)(8936002)(66476007)(66446008)(2906002)(38100700002)(33656002)(316002)(4326008)(76116006)(122000001)(71200400001)(6506007)(5660300002)(7416002)(83380400001)(54906003)(26005)(7366002)(110136005)(7406005)(186003)(478600001)(52536014)(55016002)(53546011)(966005)(86362001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?VVZvOVdLSDdPRnNxbEdUS2dqL2dyOXFjY2FHdmtrSVNCZURscUluQ0ZTWXZO?=
 =?utf-8?B?NVhaN0hFYk9PVFI1MWdIT0NoeWdpSmNDV3N6YmZBU3JPK01vVlBaUnVyVEFy?=
 =?utf-8?B?ZFBIOHNvZjNkcnQ1Q2ZraDVwMHlwMUg4R0E2WDJRNTZCaG03R28wdlczaFVV?=
 =?utf-8?B?Z092d0NaaW0vemhnOGJCdmQ4Sm1sNVJLMitFanE3L3ZYeVlxRnNxOVdVdzAz?=
 =?utf-8?B?SitlaS9ZTzA4STV4R3VsOFFWNXA2MUplSlBVc05xb3BnQjYvS0trdjJRQnpE?=
 =?utf-8?B?bHZrOUFwSGplTEJOK1RRT1RRUUJmL3BaS0lhOEM4U09SQ0hOR3FnTjZiMlZq?=
 =?utf-8?B?MEY5NnVnNEE2ZWMxUGFIVHNpV2pWUVBSWUxReVdSZk54RU1KNmpOenhLeFpS?=
 =?utf-8?B?RFpKdithMG5mbmRvL0gvOU1IN0dlRTBaUE1ZR2Q5R0RTZzJvNU92am1sZSt2?=
 =?utf-8?B?OUoyV2JXaDdmTGduYjFLYUpoekNpaFQ0c1JNdUNoMWdHUzVRQnFLNE5FSHlo?=
 =?utf-8?B?V2hQTVFycUUvbGl3cTlOdXYxalA0aVlXNGFMZUpUQXBJb2dVSFZnR1Nhdjhk?=
 =?utf-8?B?Qk56MzhHQ2s5ZzZrNDNXSUhGRFZSU1Jkam4zSTkzMmJCeDlUM3YyTFU1ZlhX?=
 =?utf-8?B?dUZkSXlzWGFNaUhZcXdSNmdlSUJzOXlvTWNGQTA4S0EvWVgyOGg3Z0xlOHVv?=
 =?utf-8?B?RDJXSVVGTnlRbEZDU3hrTU5Gd0FMcWxnVjAxWDRiK3hZRUdwS2NFZlI4U1lC?=
 =?utf-8?B?b3pieDNNR1BKYlBuZjRBS0dnSlErd1RXYUJ4UzBaVVRTVi9VL1dsU0d5dXJo?=
 =?utf-8?B?Y3g2Y2NTZzMvbHlUa055Q24rZHRnQ0tGV2NiZDV5ekJ3SDFQZU14K0ZyM0lR?=
 =?utf-8?B?dWR0R1crdEFiWE9lblpDRUVhOFZsOENua3FjUE9sUUVaTTFxSGQxempIMFc3?=
 =?utf-8?B?UU5laGpYR3QxUFRQaUNTMW9GWE1jVW9zaE02NG9PNThHRmliVGUwdjlTM2d3?=
 =?utf-8?B?d0Mzb3g1WE5jcEsrcDQyYS9xSjZnRGNVMFp2ZFVBWkl6b1JMbjJWMlJINGQz?=
 =?utf-8?B?cnFZalVIcHVmdTFkZE9FQVIxMWMwUGh2SlJQM0lFSUNtZEIyT3pkKzVCelpo?=
 =?utf-8?B?MXlnbERRUm5ndkcrTVY4eGs1b0J5UHRHTEV0RHZ1NUhoY3JwTkV2V3dLT04r?=
 =?utf-8?B?TVF2V0hHTW1BWUFoZ2VtZGdQQ21hc04vQVpYNjk0U2l5eUxQOEpTNGJQRy9z?=
 =?utf-8?B?emJWNzVIMFdnTlJyWmxDNWRRZUVtZGhBNGV0eDdCWjRHQ3VLN3QwM0lhclZZ?=
 =?utf-8?B?emtxWXFid252VVA5SXRuOVZOTUJ3WWRyZlNNdkdpZm9qdDc2NFJJRjJhdjVt?=
 =?utf-8?B?YzJuaWs3K2hzS1UvdzBFK0JUNnZSYk5vby9EMTRQb1I5SW40N1lUeks0QjR0?=
 =?utf-8?B?SnUzdXdPd2dONUpLNWdnZVRvS1AraVJWcGtIanpEWUxlQjdkMDdYSHlMSm5W?=
 =?utf-8?B?WEJPanFPU3M4eU0rRVlqRS9qRVcyNVFVMDZtbGNTT2c2R0JFNFhBL3BlZjMx?=
 =?utf-8?B?VzE0Unk5N2tJZ21ha1U4ZHo4SVBSeWFCSmhVL3NpTlp2bjNGNmdGMEdUQmlN?=
 =?utf-8?B?VmRSVVpQTVc4cUVYMWplZS8vQkd4K3AxcnhiU0U5czQvT0g3UFJoVjg2ZDEv?=
 =?utf-8?B?MFJqTGxnV3VRc1R2Tk9YbE1TVGExZ3o3ZDA0ckVWeVVpLytCWGk2cmd3L0Jz?=
 =?utf-8?Q?dQ8CEy14TcGUih0CVE/d5MecxNThNg155nvoimc?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR04MB6053.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c961c51-56e0-48ab-bef6-08d902fe1019
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Apr 2021 06:40:46.1958
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: M4ebjBKE0/buCBhvP3gdQnR4KLJ9KF+3Ig4gauTCjejsjifpkcYQRANBKZwPt0c5au3GIZ1fn+busG3J8g2LTQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB5349
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IERvbWluaXF1ZSBNQVJUSU5F
VCA8ZG9taW5pcXVlLm1hcnRpbmV0QGF0bWFyay10ZWNobm8uY29tPg0KPiBTZW50OiAyMDIx5bm0
NOaciDE55pelIDEyOjQ5DQo+IFRvOiBBbGljZSBHdW8gKE9TUykgPGFsaWNlLmd1b0Bvc3Mubnhw
LmNvbT4NCj4gQ2M6IGdyZWdraEBsaW51eGZvdW5kYXRpb24ub3JnOyByYWZhZWxAa2VybmVsLm9y
ZzsgSG9yaWEgR2VhbnRhDQo+IDxob3JpYS5nZWFudGFAbnhwLmNvbT47IEF5bWVuIFNnaGFpZXIg
PGF5bWVuLnNnaGFpZXJAbnhwLmNvbT47DQo+IGhlcmJlcnRAZ29uZG9yLmFwYW5hLm9yZy5hdTsg
ZGF2ZW1AZGF2ZW1sb2Z0Lm5ldDsgdG9ueUBhdG9taWRlLmNvbTsNCj4gZ2VlcnQrcmVuZXNhc0Bn
bGlkZXIuYmU7IG10dXJxdWV0dGVAYmF5bGlicmUuY29tOyBzYm95ZEBrZXJuZWwub3JnOw0KPiB2
a291bEBrZXJuZWwub3JnOyBwZXRlci51amZhbHVzaUBnbWFpbC5jb207IGEuaGFqZGFAc2Ftc3Vu
Zy5jb207DQo+IG5hcm1zdHJvbmdAYmF5bGlicmUuY29tOyByb2JlcnQuZm9zc0BsaW5hcm8ub3Jn
OyBhaXJsaWVkQGxpbnV4LmllOw0KPiBkYW5pZWxAZmZ3bGwuY2g7IGtoaWxtYW5AYmF5bGlicmUu
Y29tOyB0b21iYUBrZXJuZWwub3JnOyBqeXJpLnNhcmhhQGlraS5maTsNCj4gam9yb0A4Ynl0ZXMu
b3JnOyB3aWxsQGtlcm5lbC5vcmc7IG1jaGVoYWJAa2VybmVsLm9yZzsNCj4gdWxmLmhhbnNzb25A
bGluYXJvLm9yZzsgYWRyaWFuLmh1bnRlckBpbnRlbC5jb207IGtpc2hvbkB0aS5jb207DQo+IGt1
YmFAa2VybmVsLm9yZzsgbGludXMud2FsbGVpakBsaW5hcm8ub3JnOyBSb3kgUGxlZGdlIDxyb3ku
cGxlZGdlQG54cC5jb20+Ow0KPiBMZW8gTGkgPGxlb3lhbmcubGlAbnhwLmNvbT47IHNzYW50b3No
QGtlcm5lbC5vcmc7IG1hdHRoaWFzLmJnZ0BnbWFpbC5jb207DQo+IGVkdWJlenZhbEBnbWFpbC5j
b207IGota2VlcnRoeUB0aS5jb207IGJhbGJpQGtlcm5lbC5vcmc7DQo+IGxpbnV4QHByaXNrdGVj
aC5jby5uejsgc3Rlcm5Acm93bGFuZC5oYXJ2YXJkLmVkdTsgd2ltQGxpbnV4LXdhdGNoZG9nLm9y
ZzsNCj4gbGludXhAcm9lY2stdXMubmV0OyBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnOyBs
aW51eC1jcnlwdG9Admdlci5rZXJuZWwub3JnOw0KPiBsaW51eC1vbWFwQHZnZXIua2VybmVsLm9y
ZzsgbGludXgtcmVuZXNhcy1zb2NAdmdlci5rZXJuZWwub3JnOw0KPiBsaW51eC1jbGtAdmdlci5r
ZXJuZWwub3JnOyBkbWFlbmdpbmVAdmdlci5rZXJuZWwub3JnOw0KPiBkcmktZGV2ZWxAbGlzdHMu
ZnJlZWRlc2t0b3Aub3JnOyBsaW51eC1hbWxvZ2ljQGxpc3RzLmluZnJhZGVhZC5vcmc7DQo+IGxp
bnV4LWFybS1rZXJuZWxAbGlzdHMuaW5mcmFkZWFkLm9yZzsgaW9tbXVAbGlzdHMubGludXgtZm91
bmRhdGlvbi5vcmc7DQo+IGxpbnV4LW1lZGlhQHZnZXIua2VybmVsLm9yZzsgbGludXgtbW1jQHZn
ZXIua2VybmVsLm9yZzsNCj4gbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsgbGludXgtcGh5QGxpc3Rz
LmluZnJhZGVhZC5vcmc7DQo+IGxpbnV4LWdwaW9Admdlci5rZXJuZWwub3JnOyBsaW51eHBwYy1k
ZXZAbGlzdHMub3psYWJzLm9yZzsNCj4gbGludXgtc3RhZ2luZ0BsaXN0cy5saW51eC5kZXY7IGxp
bnV4LW1lZGlhdGVrQGxpc3RzLmluZnJhZGVhZC5vcmc7DQo+IGxpbnV4LXBtQHZnZXIua2VybmVs
Lm9yZzsgbGludXgtdXNiQHZnZXIua2VybmVsLm9yZzsNCj4gbGludXgtd2F0Y2hkb2dAdmdlci5r
ZXJuZWwub3JnDQo+IFN1YmplY3Q6IFJlOiBbUkZDIHYxIFBBVENIIDEvM10gZHJpdmVyczogc29j
OiBhZGQgc3VwcG9ydCBmb3Igc29jX2RldmljZV9tYXRjaA0KPiByZXR1cm5pbmcgLUVQUk9CRV9E
RUZFUg0KPiANCj4gRmlyc3QgY29tbWVudCBvdmVyYWxsIGZvciB0aGUgd2hvbGUgc2VyaWU6DQo+
IFNpbmNlIGl0IGlzIHRoZSBzb2x1dGlvbiBJIGhhZCBzdWdnZXN0ZWQgd2hlbiBJIHJlcG9ydGVk
IHRoZSBwcm9ibGVtWzFdIEkgaGF2ZSBubw0KPiBxdWFsbSBvbiB0aGUgYXBwcm9hY2gsIGNvbW1l
bnRzIGZvciBpbmRpdmlkdWFsIHBhdGNoZXMgZm9sbG93Lg0KPiANCj4gWzFdIGh0dHA6Ly9sb3Jl
Lmtlcm5lbC5vcmcvci9ZR0daSmpBeEExSU8rL1ZVQGF0bWFyay10ZWNobm8uY29tDQo+IA0KPiAN
Cj4gQWxpY2UgR3VvIChPU1MpIHdyb3RlIG9uIE1vbiwgQXByIDE5LCAyMDIxIGF0IDEyOjI3OjIw
UE0gKzA4MDA6DQo+ID4gRnJvbTogQWxpY2UgR3VvIDxhbGljZS5ndW9AbnhwLmNvbT4NCj4gPg0K
PiA+IEluIGkuTVg4TSBib2FyZHMsIHRoZSByZWdpc3RyYXRpb24gb2YgU29DIGRldmljZSBpcyBs
YXRlciB0aGFuIGNhYW0NCj4gPiBkcml2ZXIgd2hpY2ggbmVlZHMgaXQuIENhYW0gZHJpdmVyIG5l
ZWRzIHNvY19kZXZpY2VfbWF0Y2ggdG8gcHJvdmlkZQ0KPiA+IC1FUFJPQkVfREVGRVIgd2hlbiBu
byBTb0MgZGV2aWNlIGlzIHJlZ2lzdGVyZWQgYW5kIG5vDQo+ID4gZWFybHlfc29jX2Rldl9hdHRy
Lg0KPiANCj4gVGhpcyBwYXRjaCBzaG91bGQgYmUgbGFzdCBpbiB0aGUgc2V0OiB5b3UgY2FuJ3Qg
aGF2ZSBzb2NfZGV2aWNlX21hdGNoIHJldHVybiBhbg0KPiBlcnJvciBiZWZvcmUgaXRzIGNhbGxl
cnMgaGFuZGxlIGl0Lg0KPiANCj4gPiBTaWduZWQtb2ZmLWJ5OiBBbGljZSBHdW8gPGFsaWNlLmd1
b0BueHAuY29tPg0KPiANCj4gQXMgdGhlIG9uZSB3aG8gcmVwb3J0ZWQgdGhlIHByb2JsZW0gSSB3
b3VsZCBoYXZlIGJlZW4gYXBwcmVjaWF0ZWQgYmVpbmcgYXQNCj4gbGVhc3QgYWRkZWQgdG8gQ2Nz
Li4uIEkgb25seSBoYXBwZW5lZCB0byBub3RpY2UgeW91IHBvc3RlZCB0aGlzIGJ5IGNoYW5jZS4N
Cg0KU29ycnkuIEkgd2lsbCBDYyB5b3UgbmV4dCB0aW1lLg0KDQo+IFRoZXJlIGlzIGFsc28gbm90
IGEgc2luZ2xlIEZpeGVzIHRhZyAtLSBJIGJlbGlldmUgdGhpcyBjb21taXQgc2hvdWxkIGhhdmUg
Rml4ZXM6DQo+IDdkOTgxNDA1ZDBmZCAoInNvYzogaW14OG06IGNoYW5nZSB0byB1c2UgcGxhdGZv
cm0gZHJpdmVyIikgYnV0IEknbSBub3Qgc3VyZQ0KPiBob3cgc3VjaCB0YWdzIHNob3VsZCBiZSBo
YW5kbGVkIGluIGNhc2Ugb2YgbXVsdGlwbGUgcGF0Y2hlcyBmaXhpbmcgc29tZXRoaW5nLg0KDQpJ
IG9ubHkgbWVudGlvbmVkICJzb2M6IGlteDhtOiBjaGFuZ2UgdG8gdXNlIHBsYXRmb3JtIGRyaXZl
ciIgaW4gY292ZXIgbGV0dGVyLg0KSWYgaXQgaXMgYWNjZXB0YWJsZSB0byBtYWtlIHN1Y2ggYSBt
b2RpZmljYXRpb24sIEkgd2lsbCBzZW5kIG5vbi1SRkMgYW5kIGFkZCBGaXhlcyB0YWcuDQoNCkJl
c3QgUmVnYXJkcywNCkFsaWNlDQoNCj4gLS0NCj4gRG9taW5pcXVlDQo=
