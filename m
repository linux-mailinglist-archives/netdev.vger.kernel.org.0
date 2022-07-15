Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4645C5769A8
	for <lists+netdev@lfdr.de>; Sat, 16 Jul 2022 00:08:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232716AbiGOWHU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 18:07:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232333AbiGOWGK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 18:06:10 -0400
Received: from EUR02-HE1-obe.outbound.protection.outlook.com (mail-eopbgr10040.outbound.protection.outlook.com [40.107.1.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB5FB8EEF5;
        Fri, 15 Jul 2022 15:02:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FUvWCRxkQmUyZNP/uQDUbyPfGTnHGZvZyO0xiA/eVxl9BOXW2E5ih608La1QHgpWkPQDFGDf3Ku330+L9WZ3Az81Nx4KMlcmH7qw/S5z9iOJFqbckywNho3efWzUsGybPRbx4odjJm3/dmyi6Q+/sadALS3LhAVlQ8Ay5IF1km7OPPjSSxM6bslz0yjfENFuQH11jR41+nX9dk+ZX/DrnbCAuLOr6hWXo+Qi24rGXEBZl/5zCWhPF9XoXbNx+1MGQ+yx38MxYFmMAu2nAhyRozetwvrLvp+jk9dq5sZDOgLxj8HJiUVp2WommnEyqakJDMWbMA4KXbdF9vi1gn41Gw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IaWn9lToG11vKDocpndmpQBoJM6QP80GAk3BfadQNLo=;
 b=a1/7EqNRqCde1RmgPASZugYOod8tdbVa0nkXrylZuRvQlMBqmvJtMKM5lkCnylZ3lvi720tchKINiKX+e6JrYktJFsSZUY+FMvvgHS7IP5EpXwC5njmgpjEOMq0taSIyj9ZnjuQqaw+St6L0pKLdEesZM4cQvjfh/DwsSY2Qz8eTTM6F6Pd7dWreHBIOXVX4hhRZ4PFm1VtAb1LAFcmcl4CYkFI3yPEOP8OHZsdym3TfDkHu99OueJuxVulZoltVzgxXJk6Rb3KNewls3Ox+BqKMLwo10A5C2WABPg2z9CUUOsC8gWg0LkzIXiIP/2264w1Wm20DFdYxe7bQYnj+5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IaWn9lToG11vKDocpndmpQBoJM6QP80GAk3BfadQNLo=;
 b=zsuY09TXFY9WWuVeZuIiFsq3a9NRTh7y17nBo0Q8FQGA/Weph/UOGbrthcVs9XxpyFEj94vSio8WlyFQZEz2gQcjO0DYEYMC326hn4pcRkT2shLkzDtGMveton1jeMZ2H0n+0cUTpPFQydmQbecbVW/C/qzelyysC9PZMmEVoya3JOBefLxXN0rqclXyZJ+Y25zFD8QCCYWNY4Pzaf35oqHJ5KxUldd9xH4BNW3o04XpZ7ynSzIBXZCG1kOgXIBH/QA0HWJqiUH252uBz1HOyIbayYM7BUggvyNggFcOeg1pOUshtErv85TDpMKaIU0dYw99Zb3D7pIH8KjBwKHmEA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from VI1PR03MB4973.eurprd03.prod.outlook.com (2603:10a6:803:c5::12)
 by DB8PR03MB6251.eurprd03.prod.outlook.com (2603:10a6:10:137::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.14; Fri, 15 Jul
 2022 22:02:00 +0000
Received: from VI1PR03MB4973.eurprd03.prod.outlook.com
 ([fe80::5c3e:4e46:703b:8558]) by VI1PR03MB4973.eurprd03.prod.outlook.com
 ([fe80::5c3e:4e46:703b:8558%7]) with mapi id 15.20.5438.015; Fri, 15 Jul 2022
 22:02:00 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>, netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        linux-arm-kernel@lists.infradead.org,
        Russell King <linux@armlinux.org.uk>,
        linux-kernel@vger.kernel.org,
        Sean Anderson <sean.anderson@seco.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Li Yang <leoyang.li@nxp.com>, Rob Herring <robh+dt@kernel.org>,
        Shawn Guo <shawnguo@kernel.org>, Vinod Koul <vkoul@kernel.org>,
        devicetree@vger.kernel.org, linux-phy@lists.infradead.org
Subject: [PATCH net-next v3 46/47] arm64: dts: ls1046ardb: Add serdes bindings
Date:   Fri, 15 Jul 2022 17:59:53 -0400
Message-Id: <20220715215954.1449214-47-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20220715215954.1449214-1-sean.anderson@seco.com>
References: <20220715215954.1449214-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR10CA0009.namprd10.prod.outlook.com
 (2603:10b6:610:4c::19) To VI1PR03MB4973.eurprd03.prod.outlook.com
 (2603:10a6:803:c5::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5f0a7233-c57b-448a-5040-08da66ada4ad
X-MS-TrafficTypeDiagnostic: DB8PR03MB6251:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0it0lu46mBQiJ+kilkG2oaaAaoCfa6PWeREIISRX8VGn/KcFJCemMQC5TO/jiNo+Ji9v2sA5W9xs/GkZ43lJCHrY/THR8bHZR6Is4TLCYpRGrVxwDjrjE145moV7aus/dtuzvF1Fv2ZXBNwI04d6GpRtVeB9Ai4SFzdinwoIjZvSGFlVkAnS76BkvVHMx0D1hnYKHzlbitU4HdhUI3TdvVfnCik8vXHXS0euo43ZegJ99ly21Pqtr3h2xgh+RRj6cRZMQJcUvvinhKVtzRzQgApeP2F56hrK1eVcvFYPCdpqs3ZW4LeurRp4RI+wgqbuTalvIId5sK9n2cGhDj1oCD1PSRJ82sYnx9VsRH8A2p3mqXTdp83v5P9cT5BHeDPzzMxAikTUwQN8ig3qoPktCCLUiMGgue3usL7lL4cyvT1mPQUB5c35ZOZ2WynnAa/z671xbATPs78JoSQthRe2bev5lbTEG5ikp+tKxlNnjKEQTZ70DypHAru+2i0qlsgjDSB4rz2bPzzobLDE7F4DCGCu3a5Ai96ADfjW4JnxQ1B/xIRpJe447u0UYwRhZ0+Ql/Cnss+lzRM3VV2GZbGCdOQWtPppawzUaj3lqHn5l2WBoFRgCE12JGsZj8BPIWwqRszvReOLNgSFlzIOSbZIziP8HBukm1svTUc9CpWeFEoNtt8fwoG1yPmTYcnPpXDMapyyfU0OJ9TSxiO9xDaLU8BRblPNzQxWE5OkVF6j4pKYGtLkT8Z2x25heZxtoRcaEZ2PK+3s6VBIltG1kRgYXUlQXoT3EITv/UP2myPVrifnoE3lX0Bx/a+urZ3QBcVQ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR03MB4973.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39850400004)(366004)(346002)(396003)(376002)(136003)(38100700002)(4326008)(38350700002)(2616005)(54906003)(66946007)(66556008)(83380400001)(5660300002)(7416002)(1076003)(8936002)(44832011)(8676002)(66476007)(186003)(2906002)(478600001)(6666004)(41300700001)(36756003)(6512007)(316002)(6506007)(52116002)(110136005)(6486002)(86362001)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cmZOeLufuia9+gFlaFTjNEX0v77Ni5Jd5tMDyctrv1qhX3UBKR49MuZTrm+N?=
 =?us-ascii?Q?pZTDSZp6VGjt6csCpG6Q8o7FAiCKbbeOjva7GwxF46sx0AM7BJAx+HIQfxqd?=
 =?us-ascii?Q?zCijAM3J589YQUGAT1tS+vB0BseM8c5w6uWR2g1xeJC8bXWp7INK9WBPV2Jd?=
 =?us-ascii?Q?lUQnmloYk+qVfXQn2puQJW3P+l3cPrG4I8QSYtYlgiqhMm1r8gWJr4nHDGwZ?=
 =?us-ascii?Q?qnmHmjfTBIRTzYL93O8Za3I+Rb3WIyyICQGTQKgrzMRq2ywWopfJwU3MShHu?=
 =?us-ascii?Q?BeGhVRcEfayMDEOZRIg2wc/ETzSsgB2cxUOfI+CId/FH0n3cqbWCoaDv5r1k?=
 =?us-ascii?Q?jW0laNgLPzV9+KAqH5qgZhl+TFzYagA7WGeLA/V8Gt4zXiXynK1dzN+vkkrO?=
 =?us-ascii?Q?W3kZrBZRuk+aSPXWlWnRtpOPJCpUPwLofv62d3KffYtcxHi1t1NZGTw8nPd2?=
 =?us-ascii?Q?IIPo2Jl6oVx/tv5dOSxlpLHiZswdmby7didj6Ijx140PdZz/SqpqiwRdSeq8?=
 =?us-ascii?Q?1KD6WSubGirGKL5hSpZKqNDz3sLc87XG+LBmx8sj5RKcQiJb1LlpxW5Wa+UP?=
 =?us-ascii?Q?rKJuyVoqzv0og7pfCuN5PFo1OVH1MbukeVcFJM53F++pdDZIzh6a/WBWiyQT?=
 =?us-ascii?Q?zmK40jGR3ZyNcyngKid8KgVEHlWLqRfYhHGoNaFnEf0EGZTSC15xuXfWJjqY?=
 =?us-ascii?Q?WRxaJTHGpOQBHY+q6sBzkZgC7D7WD6PTFYQAeM6mIf2lI91taihDmqsi0IM5?=
 =?us-ascii?Q?xijtVa/5wWrG/u8qEvy+W3NIQYTVNOnMmsdGUeeWZo3Fn2ndT+yzSNyhJMqQ?=
 =?us-ascii?Q?4O72HEvlTdxiq+mLKDu25xLZqHcIJRkkN12jCgSKk8KQ7hZaZ60Mjg0tcm4s?=
 =?us-ascii?Q?zytKLqocIp6fU0r9cNjoLiQrj6mu8FToRyxjC+31LmKdARWHo9fUCn8QO98B?=
 =?us-ascii?Q?JLe+xMHfwxJXB38Ea95M4ilAinsZ8KNjgWB+RnoPtTI2d6rpe3qxfydoQ9Id?=
 =?us-ascii?Q?QI4N901iRzzrVgeAdWAFghSnpS4CWbEAvbvWFIy9NhlhxZqO/6ArYWFbTOQ4?=
 =?us-ascii?Q?X/bSKLNbwZSOG70TlQfqwMn5ugv8yyoMJdicDsQ8jYl7IoPMwAeysLAy1EbH?=
 =?us-ascii?Q?jE0/cH8LweBQXxfAKY9KiC9lqiwrVpFknrjFkPWgMauMBVGeJUiYgCAJMieO?=
 =?us-ascii?Q?4nlvZgXVcKsrh9w6OdTaEafBKshT5YvGt9U89spko4EOy1QiNQf/5YsgMhj5?=
 =?us-ascii?Q?i1tUdW/DBT7Mb7ZbDnfugI8VcOQurDo8l0U4FNrqWiVsknEDYJSDR+zsdSnU?=
 =?us-ascii?Q?crjvFvVtRkqFcsb4Pzoyuc06pNrkNFdVllLOuQTikGtri+jln+VHBpMgTOF9?=
 =?us-ascii?Q?Y7N2MYxW2jNwSZ6dWuK6LPzsFYg8XyxAW4el9FsECxNobYg+IC4pudAQfOMk?=
 =?us-ascii?Q?vHmcOIRr0R2bEnGngDiSWpUQEKR0ei0X6BNtvrT5jqboj2U6sq8Z3OcGbik/?=
 =?us-ascii?Q?8ijXwTAvfe1vcDFo/Moo09RA+NSSluvkaIjdT8MvcHVy8/waTB8hDoklURIa?=
 =?us-ascii?Q?htKOUcQ6+tByx4o6v5lTNeQDQLl6DXP+xwzEfUAXLDfBKKC0R28LTosVqj1y?=
 =?us-ascii?Q?mA=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f0a7233-c57b-448a-5040-08da66ada4ad
X-MS-Exchange-CrossTenant-AuthSource: VI1PR03MB4973.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2022 22:02:00.5637
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PkMtSP10LVhPLxJtdelb1HQ86dB7zf7P3c4AjeHA0MlMHybELEC2YtpubcLTBgI03pwK8tr6PZGAkiXclrReZA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR03MB6251
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds appropriate bindings for the macs which use the SerDes. The
156.25MHz fixed clock is a crystal. The 100MHz clocks (there are
actually 3) come from a Renesas 6V49205B at address 69 on i2c0. There is
no driver for this device (and as far as I know all you can do with the
100MHz clocks is gate them), so I have chosen to model it as a single
fixed clock.

Note: the SerDes1 lane numbering for the LS1046A is *reversed*.
This means that Lane A (what the driver thinks is lane 0) uses pins
SD1_TX3_P/N.

Because this will break ethernet if the serdes is not enabled, enable
the serdes driver by default on Layerscape.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---
Please let me know if there is a better/more specific config I can use
here.

(no changes since v1)

 .../boot/dts/freescale/fsl-ls1046a-rdb.dts    | 34 +++++++++++++++++++
 drivers/phy/freescale/Kconfig                 |  1 +
 2 files changed, 35 insertions(+)

diff --git a/arch/arm64/boot/dts/freescale/fsl-ls1046a-rdb.dts b/arch/arm64/boot/dts/freescale/fsl-ls1046a-rdb.dts
index 7025aad8ae89..4f4dd0ed8c53 100644
--- a/arch/arm64/boot/dts/freescale/fsl-ls1046a-rdb.dts
+++ b/arch/arm64/boot/dts/freescale/fsl-ls1046a-rdb.dts
@@ -26,6 +26,32 @@ aliases {
 	chosen {
 		stdout-path = "serial0:115200n8";
 	};
+
+	clocks {
+		clk_100mhz: clock-100mhz {
+			compatible = "fixed-clock";
+			#clock-cells = <0>;
+			clock-frequency = <100000000>;
+		};
+
+		clk_156mhz: clock-156mhz {
+			compatible = "fixed-clock";
+			#clock-cells = <0>;
+			clock-frequency = <156250000>;
+		};
+	};
+};
+
+&serdes1 {
+	clocks = <&clk_100mhz>, <&clk_156mhz>;
+	clock-names = "ref0", "ref1";
+	status = "okay";
+};
+
+&serdes2 {
+	clocks = <&clk_100mhz>, <&clk_100mhz>;
+	clock-names = "ref0", "ref1";
+	status = "okay";
 };
 
 &duart0 {
@@ -140,21 +166,29 @@ ethernet@e6000 {
 	ethernet@e8000 {
 		phy-handle = <&sgmii_phy1>;
 		phy-connection-type = "sgmii";
+		phys = <&serdes1 1>;
+		phy-names = "serdes";
 	};
 
 	ethernet@ea000 {
 		phy-handle = <&sgmii_phy2>;
 		phy-connection-type = "sgmii";
+		phys = <&serdes1 0>;
+		phy-names = "serdes";
 	};
 
 	ethernet@f0000 { /* 10GEC1 */
 		phy-handle = <&aqr106_phy>;
 		phy-connection-type = "xgmii";
+		phys = <&serdes1 3>;
+		phy-names = "serdes";
 	};
 
 	ethernet@f2000 { /* 10GEC2 */
 		fixed-link = <0 1 1000 0 0>;
 		phy-connection-type = "xgmii";
+		phys = <&serdes1 2>;
+		phy-names = "serdes";
 	};
 
 	mdio@fc000 {
diff --git a/drivers/phy/freescale/Kconfig b/drivers/phy/freescale/Kconfig
index fe2a3efe0ba4..9595666213d0 100644
--- a/drivers/phy/freescale/Kconfig
+++ b/drivers/phy/freescale/Kconfig
@@ -43,6 +43,7 @@ config PHY_FSL_LYNX_10G
 	tristate "Freescale Layerscale Lynx 10G SerDes support"
 	select GENERIC_PHY
 	select REGMAP_MMIO
+	default y if ARCH_LAYERSCAPE
 	help
 	  This adds support for the Lynx "SerDes" devices found on various QorIQ
 	  SoCs. There may be up to four SerDes devices on each SoC, and each
-- 
2.35.1.1320.gc452695387.dirty

