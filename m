Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0440F58B5DA
	for <lists+netdev@lfdr.de>; Sat,  6 Aug 2022 16:11:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231660AbiHFOLX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Aug 2022 10:11:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230407AbiHFOLU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Aug 2022 10:11:20 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70041.outbound.protection.outlook.com [40.107.7.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B1D4101FF;
        Sat,  6 Aug 2022 07:11:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ij/l8hsLIoFlxrHPJkqJAIJIreKm0BaqWmfFH+EEcfD48L9OR2Aqv6oBBRbxosZmrLfYyhO9BiXg8MNpAYVEALM8FyLAmNIlNuqy7cgWw/uW46JT30d5yeoblu5fgAzk4a+4vi7no4lGvXPesS6o1EpuwNM/QF0bhb15O2X51u1IzGLQxQEEnqOR5DWCs1BdJcIY4lIC4Ye+/sPM2eGWvcEc+napbhDeIgywpwehsChgX+vdtr1nUII5Vo3GaxP/rofdubgFs7oenXJoQjHVy13s0UsPP0KS2zg8+ccB0UzYUmQnEoY2YZQQWWPg3FLBBV+aEW8dLktQ/jHW+P8zXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BeyiDr+ONMlxayP+m1Q2qXUokQqLGwFXv3V21JU2yNI=;
 b=fXTwHkvIie4YMA/AEILvmHMXTXvl3sCx1Zbnt1EiYyJ2axFaOe16M71u23Jwx6Ckpz1xieKlCsEqsvfKObpe3TVn5+lCyW/x4txaFrPHqI+efTuw9AFGxXN4wadyQb9hvjKc8qjrZsTPp28PXvOBpCo+SIZANIn5qTfPv2ssCRMYr+whtdipWPCEA2LuEywe+S/UD6SnS4vYpemsOR/+21yAQOSc6cjMp0tA735+iN9rt5MzcG+s4M+ekGOLKuu+2cR9DuH4rrcMCANvJFQtmHvCD2eUYmi4yplyEQrrf7UcaugjWyLNBiz59bEttN5RR2MGEQ8WFAg9Pu4QF/Pxhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BeyiDr+ONMlxayP+m1Q2qXUokQqLGwFXv3V21JU2yNI=;
 b=oHSn+02vfCvbd3zGvbKkAc20oJH6vZr5DkzmlTntNRnDeFcr2L8ZwDqdp5ccUQGA5cYblu2IZxbt2u1+lYDV/OtBn4wy6SCDw5kHV9Sya/dpebodAh+9HlUPZRMf71LtgbJsO9kYU6/iYe6oApDwTGdlV04dAmazMU2w9eMf1dg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DB8PR04MB6988.eurprd04.prod.outlook.com (2603:10a6:10:117::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.17; Sat, 6 Aug
 2022 14:11:14 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5504.017; Sat, 6 Aug 2022
 14:11:14 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     devicetree@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Christian Marangi <ansuelsmth@gmail.com>,
        John Crispin <john@phrozen.org>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Mans Rullgard <mans@mansr.com>,
        Arun Ramadoss <arun.ramadoss@microchip.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        George McCollister <george.mccollister@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Aleksander Jan Bajkowski <olek2@wp.pl>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Pawel Dembicki <paweldembicki@gmail.com>,
        =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Marcin Wojtas <mw@semihalf.com>, Marek Vasut <marex@denx.de>,
        linux-renesas-soc@vger.kernel.org,
        Frank Rowand <frowand.list@gmail.com>
Subject: [RFC PATCH v3 net-next 00/10] Validate OF nodes for DSA shared ports
Date:   Sat,  6 Aug 2022 17:10:49 +0300
Message-Id: <20220806141059.2498226-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: VI1PR0802CA0016.eurprd08.prod.outlook.com
 (2603:10a6:800:aa::26) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3cdba6d1-e7e2-4a25-903b-08da77b5858a
X-MS-TrafficTypeDiagnostic: DB8PR04MB6988:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tGk7bix4SdkgHp501jEttQoE5ML9+xnXGF9qEzznstmgzFRIsg2w/m/nWAkMqx30cf057NdRpeR2Xnfpi2Op0pnfJ4lNbJL9DKg7CpOxbrQKttSNlvkMRris73NX8ceUDDnEMhc/iQzR5gsA6kLpijnsU4U3CIuaDvaidCD0X/9sg/nzspcTB6y8mVx1qQg5mAhrwvy2oTiK48yodN4ZbAIUlpn3n2grpSlQbCkq+AYFqjI52UQ63LTQrqfjfvKEvLQLhjrIgLV69HvxEHCptezS6Wc3FimKjdIXDea/ryvXNgJhSal1gNvPFEA6MPwRPtD4feHGIp+fdKft5TB4VmXENrtG8wHbpAIdkRArkoUu6a9fQuB+zjkACYLaZy1b3QlGpPzwIbDXKJXkrARUE+gIcTxo3EaWxNU+wHBmeFazVV9gy2DbUeK7GmQnEBpZ2lwYsVyiYXipHVGR+97yZBBx22msSACFITcWiD670RBG/sSLSNxb7/epIpNTnlZD01P6g2c/TIvHbCiHkb6L3LaYEeh1MSKAUPKXh+HoZjhEa+XL/VDt/lnjyYOaJcBKh+ZinnK0DmVNUxYORNQpmdaQXWaI/s6xx475QzJPmcWOPIwHplyFqQNz6b6aFeF7FaKhwgmF3ToKC4LFL4SEc8PMYp6VnsmycSjrKMlHqadL+a1fXTjNCepoxN+Y9cspcu508OYJZJWrYr0H6lI8gVqJ8H1/f39ozE1OTRvWVgSZadwPUM3fLbZX6Gp0PVGRmEVU69PI2L2DcpZvMfibeAb47SCrvvU0XHUWxau4fBqCYBCieXU+W57dUW6JaMZ4qu5HUprPe7vx7GfpMVr1jVz6Xu7YlMSeO9oo3LHb1L4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(396003)(346002)(39860400002)(136003)(366004)(5660300002)(44832011)(7416002)(7406005)(186003)(1076003)(2616005)(38100700002)(38350700002)(83380400001)(6666004)(52116002)(966005)(6486002)(41300700001)(316002)(36756003)(6916009)(54906003)(6506007)(26005)(6512007)(66946007)(66556008)(66476007)(4326008)(8676002)(8936002)(478600001)(86362001)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SlY3M3MvN0hzck96UmVJOURPM2FqSVpPTndNR2lMcW5OMjY0NDRxZEN0QnhR?=
 =?utf-8?B?d1VsTFB0bHZidFQwclZTNVdSVnFsRnVSenZqYW5NT1JuSXhBNVR3NWJ3TFdT?=
 =?utf-8?B?UHp1YmlYOUI1NGFuOS9wdWdtNVZmenhIZnUzN2JRTzJFSmdyQ3J2cUkrSjFu?=
 =?utf-8?B?Wktrc3lNcUxvNzBhUDYwOUt3QXh6cWw4SW1WSkJtVnIvc1RJMlRwYW82cHFs?=
 =?utf-8?B?NGtRTHBYOUFwdkd6RVhGTDhKS1lZQVBCZDBURS9oem4rekxBdk5JMGFYMm9L?=
 =?utf-8?B?V2o3eU9YdUtRamhwRGpTcVJSSUpld2F1dkhBVUhCcXNFQXhXYTlEUDcwbm45?=
 =?utf-8?B?VmdoeDdOTzZrSXNrSjlWQTNKUlZiT3NST2F2SGxKL0RzeFl4TmFNZXdpeXgy?=
 =?utf-8?B?QVROWnBOR1hDOHpXSlY3NmJEdnBrWnJkZWRBWDVKZVdPaU1iNC9TYUx2Tjcr?=
 =?utf-8?B?dXZjVU10alk2eHFrQXJ2OFJOcHNzbFVvNUdDc3cwMWdqcVZFcEZmV2s3dTYr?=
 =?utf-8?B?c2doWGdWMlByY3ZGd2xGM1JZQld0d2xIbDIwUzJDOGtQazBRZU9rSTkxOTV4?=
 =?utf-8?B?NmhJTFE0VUxIWktVRHpVQWZuVVAxNERKYTQwbkxMbHFwTEh2RXlhL0R1aUNX?=
 =?utf-8?B?eWZlcUlTNGRJSURjRUUyK1gzS2pLNmdCaFkrTWRoNCtrRlpLMWtHbS9venJ6?=
 =?utf-8?B?TXY2MGZ2MktOMXlNQThrNGRtdkhBNit4dHFwTis3eDkrZ3V2QUY0eHpHcnVl?=
 =?utf-8?B?ZzZRSGZZRjZLdkZQS1AyL2R1OFdiOEI3OVh4cVkyU015dXg5NGQ0eG1wS2Ix?=
 =?utf-8?B?L09qczhhTXptb2gxQk5VSmZ0U1VrdDRnMWppTzRINzV5cUd6UE5yS3FGZm1J?=
 =?utf-8?B?TlU3N2RKOE03ZWJxMXRGNGltTWZNdm9FWTA0ZCtCdnI5cFdkY3g4RXZoRVRC?=
 =?utf-8?B?VnN6L242cW1qTmlyb1ZZTVd5OXoyM0xoZCtYRkQrTGdKNStkYUJ0cDBJTGcz?=
 =?utf-8?B?NHYwK3graERHSDVZNndHTlp0TW1KZ2sxd09uNnJqakY2U0dpQWdMY2toenI1?=
 =?utf-8?B?R29heUtyUHFOdWpWMy9zSVV6d3o4NFl3U1RsN1lqM1B1RkpmRTBUSEk3dFZC?=
 =?utf-8?B?Q21mbzg4L1JpZi9jUFhuZDV1T0NFamI0T2tWckplbjltVUo3U0IxUEVTdjg2?=
 =?utf-8?B?bVdrWHBGdVRGUHJ4RkVreVhCZHBrL3pLU04zbEgxa3lDT2lYT0hpTDRQamx0?=
 =?utf-8?B?dVFXRGV5WDJRWEJ0aUhUaGFXMWdMNUg3aHRuTGRqSHpIOGdSLzdCWjFlWWpH?=
 =?utf-8?B?Sk1qMXUyYXlOb0hpUkRpczZTeVFWVG9IZUw4Y1ROSDJUS2twWUpzOGtQUVFW?=
 =?utf-8?B?NStxd21kUE9RMThWeDJ0bWI5dE9ySU1pREVkSmw1cmk4RkFBMWRQeDBCdmFr?=
 =?utf-8?B?Uit4aG1zY0Q2UWVVY2dPN2plcGZ5MVkxMG1mUk1JUUdXcElkbEVKK1J3UFBk?=
 =?utf-8?B?RGVzYWNqd0ROSHdiZmNMa0dSUDdCSUovY0x2OHhkUXhYVTRLbFk0bFBBdVRy?=
 =?utf-8?B?anc3cGlzVC9aemhFc0FIQmU0NllLelg4RFRza0JFVUxuYzQyc1haK1VqQzBa?=
 =?utf-8?B?eEVpMWI3emZQMGVSREZjOXZtZDgvMG9xQ2RrYXZxN3ZMcmx3djYwbUNFV0Nv?=
 =?utf-8?B?bkJPM1RLcE5ocXNiL3ozb1ZCVUI2UXZvK0w3a0lqYTJWclpsazR4em1pSXU2?=
 =?utf-8?B?L2dlVkhnT0tJYzdNa0h2V0Zkc0ZWaWlmYlRyUkQ2NFUwQ24yaTdBc0pBTks3?=
 =?utf-8?B?T2FlMXB3aGM0Vzc2bWxYSGY3VnM2RExwbnc2ODV1QkUwK1R2eGZYZDVaZ0Vj?=
 =?utf-8?B?RVFBajRhWW9XR1BaN3hOMm5XQ2d6Nk53TEJ5Z2pFTmVPeCtxKzB0VGdDeXQr?=
 =?utf-8?B?T0hQYkp0NnpCcmFkNm9pK3V2SzhTK1dUWGhjNWo2YTFJbXpUc1lRSmRwNFlZ?=
 =?utf-8?B?TUZUZGhaa29tMHlGRFlicTV2OU1NWkU4YkxNRHFCcVZDS2Z2MFpOUXJUSTRS?=
 =?utf-8?B?RlRrSWxWVzhPSlFEdEEvN0VPNzY5aVlUa29ISTYyZlB6MFVmcVJPS3ZwdVVI?=
 =?utf-8?B?RVgxOS9PdThXOFpGek9JSHowNkRpaGRpWXhjYXoxZEdnL25qUTliakQzcXpp?=
 =?utf-8?B?dmc9PQ==?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3cdba6d1-e7e2-4a25-903b-08da77b5858a
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2022 14:11:14.4270
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rUqq9IkDZ/L38jbXcjWjg7Z1GWMESvuZI7TJwFIralfgH8kiAseniADDfCbreJj3sVY+yzv0fc+Y75XrxL9u8g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6988
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is the first set of measures taken so that more drivers can be
transitioned towards phylink on shared (CPU and DSA) ports some time in
the future. It consists of:

- expanding the DT schema for DSA and related drivers to clarify the new
  requirements.

- introducing warnings for drivers that currently skip phylink due to
  incomplete DT descriptions.

- introducing warning for drivers that currently skip phylink due to
  using platform data (search for struct dsa_chip_data).

- closing the possibility for new(ish) drivers to skip phylink, by
  validating their DT descriptions.

- making the code paths used by shared ports more evident.

- preparing the code paths used by shared ports for further work to fake
  a link description where that is possible.

More details in patch 10/10.

DT binding (patches 1-6) and kernel (7-10) are in principle separable,
but are submitted together since they're part of the same story.

Patches 8 and 9 are DSA cleanups, and patch 7 is a dependency for patch
10.

Submitting as RFC because it's RFC season, but I'd like to resend this
for proper inclusion as soon as possible once the merge window closes,
so ACKs/NACKs are welcome.

Change log in patches.

v1 at
https://patchwork.kernel.org/project/netdevbpf/patch/20220723164635.1621911-1-vladimir.oltean@nxp.com/

v2 at
https://patchwork.kernel.org/project/netdevbpf/patch/20220729132119.1191227-5-vladimir.oltean@nxp.com/

Cc: Rob Herring <robh+dt@kernel.org>
Cc: Frank Rowand <frowand.list@gmail.com>

Vladimir Oltean (10):
  dt-bindings: net: dsa: xrs700x: add missing CPU port phy-mode to
    example
  dt-bindings: net: dsa: hellcreek: add missing CPU port
    phy-mode/fixed-link to example
  dt-bindings: net: dsa: b53: add missing CPU port phy-mode to example
  dt-bindings: net: dsa: microchip: add missing CPU port phy-mode to
    example
  dt-bindings: net: dsa: rzn1-a5psw: add missing CPU port phy-mode to
    example
  dt-bindings: net: dsa: make phylink bindings required for CPU/DSA
    ports
  of: base: export of_device_compatible_match() for use in modules
  net: dsa: avoid dsa_port_link_{,un}register_of() calls with platform
    data
  net: dsa: rename dsa_port_link_{,un}register_of
  net: dsa: make phylink-related OF properties mandatory on DSA and CPU
    ports

 .../bindings/net/dsa/arrow,xrs700x.yaml       |   2 +
 .../devicetree/bindings/net/dsa/brcm,b53.yaml |   2 +
 .../devicetree/bindings/net/dsa/dsa-port.yaml |  17 ++
 .../net/dsa/hirschmann,hellcreek.yaml         |   6 +
 .../bindings/net/dsa/microchip,ksz.yaml       |   4 +
 .../bindings/net/dsa/renesas,rzn1-a5psw.yaml  |   2 +
 drivers/of/base.c                             |   1 +
 net/dsa/dsa2.c                                |  36 +++-
 net/dsa/dsa_priv.h                            |   4 +-
 net/dsa/port.c                                | 193 ++++++++++++++++--
 10 files changed, 240 insertions(+), 27 deletions(-)

-- 
2.34.1

