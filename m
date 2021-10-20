Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10244434A27
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 13:36:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230170AbhJTLi4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 07:38:56 -0400
Received: from mail-eopbgr130045.outbound.protection.outlook.com ([40.107.13.45]:17770
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229548AbhJTLix (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Oct 2021 07:38:53 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mPCDuEIsPTMUIpJnyyBeZwmBN6w64jTOyoYCpwjE0iVmdHQ+/iclnakQwPCSHPRBLIehbYkx0ixnkP487mgXBfyjWuHtaXddJnju5aeoCKUqmNnJJTAyl31OhHujSkygBRI5AI1TAn65ueJzsw9ryWeqynNlLUgujJqBRBmdh/k8UI1Ru08ptupV8PQsa9Tq97gHW6CgenYxSWOCvURX12TTIqliIoJdx8qyTlSB0J8i/QjQl9hmzgssodkz8bBSaRJZN8X7PwJTaNaTyo4+uWC+twKN21GcKvuEfG3uylrbpM2qxQVS3ws5cKEdtccL67Y5MdI2sN4PiUR+tv+yCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lMpGEiWOnt3Q2GFsNwvTJr1DMFfaam+U+COJnSpcIaE=;
 b=LDg0djysokMyL1otsxROcv0h5Q9AcXEvcln7N2AVmQyL7GMLc5c330iDLWDrLIOViZZWnQ3/GHmcmvKGC3RXpcz+bpnLQIzpz4UJ+457G7zRoXw07C85U2ba6kuFlwtwgpTnCic1/+I46881XH/wxYAgWBz18t9gN5B9r9zqPeBEP0szLMQ/YY1miKaHMXEwsAXiwFdgmkrQ0pCoQ8WOZpv5CjSxjaCMdGOkVCj+aHupHUrIK5iELyBd+KauRWyc7+nGdVfChHkiOmLK2UZQD2hxN7rh+WWYs0sWSlAXPv3WJcvEl8qr0TiYshUQbu9QPE1tqMyqiCckRQ9/2sucfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lMpGEiWOnt3Q2GFsNwvTJr1DMFfaam+U+COJnSpcIaE=;
 b=TB9aJKW9Mb7hEp/WFR2pxRqdPw36EjyWkDtFmG2StMpx1WE0VnEyIGejp8YopwHUKo6w1L2h8wlmvkTlWSYNHQHgZx0E876t6vAxa2jK3y6yakPsul3uuSGZkl0VZb4lHJoUv5qzFiNmOjGnlcMG97dOG2eUmJM3ZvqpkYaoOOU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB4685.eurprd04.prod.outlook.com (2603:10a6:803:70::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.16; Wed, 20 Oct
 2021 11:36:33 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4608.018; Wed, 20 Oct 2021
 11:36:33 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org
Cc:     Rob Herring <robh+dt@kernel.org>, Shawn Guo <shawnguo@kernel.org>,
        Li Yang <leoyang.li@nxp.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH devicetree 2/3] ARM: dts: ls1021a-tsn: update RGMII delays for sja1105 switch
Date:   Wed, 20 Oct 2021 14:36:12 +0300
Message-Id: <20211020113613.815210-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211020113613.815210-1-vladimir.oltean@nxp.com>
References: <20211020113613.815210-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR03CA0036.eurprd03.prod.outlook.com
 (2603:10a6:208:14::49) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.174.251) by AM0PR03CA0036.eurprd03.prod.outlook.com (2603:10a6:208:14::49) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.18 via Frontend Transport; Wed, 20 Oct 2021 11:36:32 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c4595303-817c-46d7-34ee-08d993bdde08
X-MS-TrafficTypeDiagnostic: VI1PR04MB4685:
X-Microsoft-Antispam-PRVS: <VI1PR04MB4685AC0E56263A506530BF17E0BE9@VI1PR04MB4685.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yWeV+WnVmVZn6MaK+XwlMYWa4NWYV9dpp0u+aG0pJMPBX9g0UQDDHOF0UVPpNBaaOq8gb9oqlT9wXC+6qAWnoE6XLwFUBYm3S/PcV42G35KqEcuyDClFPNc0UaSJv2x0X3QMW40iinfZGqyTAnNHHzjfSig6bWD3NN7mUSG+Mf5CRny+F+Zvc6H8TTIMKjnucAxZjMycNTtTvhqwlGx2W9NGv7GpNyPvdGC2QKCL8UjYRJk1xJmiv3BZayBur2smBr1p3ZezvNxcfpInpNPSBXXPttHwHdMbAjhR2J7aVLAocmx8WpMr3wvziPGTJ+S6+numxuJ6S++/IpgAivFvDwX1dc0j+5z/N9tUIKt/MDXmNHvQOz3EvDkc3STsBm3HvX2kPrFWjr+TD53v/tLLb05jSqc3zzGOI2XBQ/bSHhFko+fo73pCAQNl4p/IFP6ybVTtO4ARa34KfCZWTM6dhdxWrhtW7gQxBIBPTOoh0j/od3zb7J6xO39miyjVl/1qDmoHDjzECtvQovDFFNiiQoYzXXAk0unxFTHfXqtz5WxJPKRCGGaPcNNWSgA4EhCgLA+XXD2dA86DrrCaYlbE4zmxDXe2igp6+6Xu9Ovw0+KYDWn7GHGGVU8vOn5VYui6qMm9wI1lY8vWm/rBjKbY7sCqnQ/3D5zE/e+DKMDo0McMmau5Tz8cliZjlWzEVW/0mUe/PBj2KASrQF9iIVzJwA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(36756003)(8676002)(4326008)(6512007)(956004)(66946007)(2906002)(44832011)(186003)(8936002)(2616005)(86362001)(5660300002)(316002)(6506007)(52116002)(508600001)(26005)(38100700002)(38350700002)(6486002)(54906003)(1076003)(6666004)(66556008)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?aJrHUlEp9BANvHTNGVpfNgHy0dlG8TexJn52OOquZKKhQWFysGoiTuRCR4fn?=
 =?us-ascii?Q?kn4SHpW1HXEISjGrboJ4+a+2gMg32QLOkgY5FRKotFOQSG2Na6lG0TzF+Mr/?=
 =?us-ascii?Q?MwM7C8uw1BOWsYx3rogc0clHqB3Cyt2yGB56iNoOuDnjX8OC+ch2LU2DI+J/?=
 =?us-ascii?Q?czkUfxwC1xuc6QGVhz/YjvpsQ1pCXrrZCCg5V82cEpDmLKrzLNYdLRsY7g4D?=
 =?us-ascii?Q?qRxa4dDWhOcgf0KJoVlbS/ZcHluBKck8pzvXZQM2d8vJnFiE3FF6YJaE3Dwd?=
 =?us-ascii?Q?Ake4YRXB5dmLLpoOGbR4T8UKSGWELUY9yjvi+Ijzo85e3cEi2LYJ26AmNune?=
 =?us-ascii?Q?UuKsD89IUgi5PxGnU8MMaF86CP0bSJE/ftgHtE7aTEmUzXiYP7uXwWIViq3W?=
 =?us-ascii?Q?b2h5WlMucvfCGVkoEyKnd8WR2iwOU2slniDDWY49C/vB8ZlQJkd0KcoPYm1J?=
 =?us-ascii?Q?p7ztN5ePUO85QikXEhPVUcQf+pzlH5rerVItmBxgTf7jo0s7z02wI4ljLQtB?=
 =?us-ascii?Q?77ySLYJLZAB7f6k2PiyFg8hFgtBHuKjNThqKkX+e3fUG4+OBkD11VXD+mRZz?=
 =?us-ascii?Q?gB5M523i5Hr9LZzj+Gw6iiqeodvDnTuYdtGaNcCtG4hPr0aJb3r/yQHgrFxS?=
 =?us-ascii?Q?qB96eUxIEnp2gGt5ZdpV3w8YaIqFfOysj+F+oc5cgxnTawqYNrIcp7FZP5Ce?=
 =?us-ascii?Q?KTzVRuXsJcaeAFKCD06Uks4ZFahSaMIpR7j2uLXBkE4+Zehv1cq4eivyndwK?=
 =?us-ascii?Q?uvVAgBlXNBMNLowWJDhSHjkxOMcg/ocVdtmRROg6t3So6E8EQddv57R2MooW?=
 =?us-ascii?Q?bDCY+QZAb+6L17WS463TBykfWUXzpSTPANVAE49tpsdLD5z1AgwwMkOaVPLu?=
 =?us-ascii?Q?BvclCZ/+Yj58uwy/+0TfQ4NBNErfbGB2UO56hMbxt5uB0X/OkKQ2VxdmD5P9?=
 =?us-ascii?Q?ec8NY7FpJEbLmyDfWswoK7BStM1hiZhXoFNFxWOLcSJZmbM7uyqMJFoyZIf/?=
 =?us-ascii?Q?Oxd10BH+y4liwB/TD4/oqA3sjlaC7JDLMMnmIPLRyNH5TBys5V8SPSj+jUBj?=
 =?us-ascii?Q?EMTZD5eIRlHJoMhz3H2KcJdEwffgMzqCULmTY6IIh70LWjkw+HtQyehYtiTM?=
 =?us-ascii?Q?0JunWIvhexhfA7mE5U7OLzCVISBAd4lZksKarsSYDHaZ3XewyvTtchInWq/A?=
 =?us-ascii?Q?PaL9V70Cw9byJaif/6Tl9roZMqG6Ho5kmQZg7ts4GI3JGHPHFh6D7KIa4Gyc?=
 =?us-ascii?Q?nTDHBiwzTaha9Ww8qN79tq6zM32wV0ACvg8CELEbXVN3BkpOPM9EJcmYZZhB?=
 =?us-ascii?Q?OIZy82fnV0KIHzGWIw5FCt0mmnhuL9XlSwJmC2lRZ9sg32RYfKYETCtBv19J?=
 =?us-ascii?Q?kShYgL5RYuSitn/DK/MLdc4TBiyKsfBoXX6qOvUUO+5rq+8tlul9GnBrC4Vg?=
 =?us-ascii?Q?CGgY752QrS6yX9QriBk/JQ+tsCjvFMOmzPNoUoOmDPKQevfNoCZfpbaF0FL0?=
 =?us-ascii?Q?D72rxmpAE3w9mbs8e4c1HUnSwEl4yJ4vIfj0+lOr+qHSvzzpzL2FBQ8Fka9y?=
 =?us-ascii?Q?/JSBSOkG+JojiQgzXOAggYVn6q2a88gzq9S36Wf4/rru3P0qYffKdt+w+lNL?=
 =?us-ascii?Q?YAxafrHnB0fdObujG8STzWU=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c4595303-817c-46d7-34ee-08d993bdde08
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2021 11:36:33.4466
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7cGQ4+cwdMsYSexnHF4ZzbU5dwuksDzPSB5v4TpBivwe+BinvxzjKe3NJr2/yqXzkiygrtUJ4zC+MWdXltxGCQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4685
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the new behavior, the sja1105 driver expects there to be explicit
RGMII delays present on the fixed-link ports, otherwise it will complain
that it falls back to legacy behavior, which is to apply RGMII delays
incorrectly derived from the phy-mode string.

In this case, the legacy behavior of the driver is to not apply delays
in any direction (mostly because the SJA1105T can't do that, so this
board uses PCB traces). To preserve that but also silence the driver,
use explicit delays of 0 ns. The delay information from the phy-mode is
ignored by new kernels (it's still RGMII as long as it's "rgmii*"
something), and the explicit {rx,tx}-internal-delay-ps properties are
ignored by old kernels, so the change works both ways.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 arch/arm/boot/dts/ls1021a-tsn.dts | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/boot/dts/ls1021a-tsn.dts b/arch/arm/boot/dts/ls1021a-tsn.dts
index ff0ffb22768b..1ea32fff4120 100644
--- a/arch/arm/boot/dts/ls1021a-tsn.dts
+++ b/arch/arm/boot/dts/ls1021a-tsn.dts
@@ -91,6 +91,8 @@ port@4 {
 				/* Internal port connected to eth2 */
 				ethernet = <&enet2>;
 				phy-mode = "rgmii";
+				rx-internal-delay-ps = <0>;
+				tx-internal-delay-ps = <0>;
 				reg = <4>;
 
 				fixed-link {
-- 
2.25.1

