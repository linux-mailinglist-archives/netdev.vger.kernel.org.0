Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CED5E55F150
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 00:32:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232235AbiF1WU1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 18:20:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230239AbiF1WUH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 18:20:07 -0400
Received: from EUR03-VE1-obe.outbound.protection.outlook.com (mail-eopbgr50053.outbound.protection.outlook.com [40.107.5.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A2363D49D;
        Tue, 28 Jun 2022 15:16:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XMjUJwwxabseaPhgrl3CrS4BJsmFEGlpuAZsV9X0Xzyonw+AU3NErdcjigwDb3V1l8JDM2lopjm94icvJjZmZvCh2JK3bjrbpKvpEt2ZOUij98HNz9TOUxLEqhmbCdJMhIdKm+bku80j5eF+YYQFDz3If7C4rkP1bzF3z6try5wHOArMOoJGadMmpuCnzxsZ6sNrX09aFeh6I/KnIoNraT5vmquJlT7/HuxYw0tx7iwlZmn+0uCS0PDLnnoZptuYV1PPpCOvHFPkmFd7HCFAdXkPtSWbe8ty+g4iRQVI1fTIlyqPjNGGmOjJoarGqo8KvOVlBATq8T3DS64D7DFS5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Mv/fBJyuMJHaKO9E0HqqZzxOLAFdk0n0PbulaXq1z+A=;
 b=FYKI7++UWZSmmaZGC83rH1yxiLhZgw46q/8JsFmAIeM96ItroZXngIxBSle3KEorIuEd7YCyqmvH6iGv6WgXgYZkSmdZQiTUEGlMEPL6nYpfNEMDTq3UGpLsTxpt44WKp3q78/dczTMD3yL3408OWZETtplFzdsj/FTsmmndTKtK6FEm1dUfGVVt+0UgBacNFANwE72uHVOX1J7XxdA/Seyy+LYLFi8Xbf7Vup46xMRLv8SaUT3/GAX8n2b1jGadLapsCqCD35dr8zfYsLkKFDvPVjkvug2u5BQGIubpX5tFBm/xOaV3a3pzioBPSZJRA9LW6sL7BAw8epyo5OdWug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Mv/fBJyuMJHaKO9E0HqqZzxOLAFdk0n0PbulaXq1z+A=;
 b=DVAH7d1ZbK71g6FyYqnPcSFd+KtxDF+iHPsbWlO+08TOxEIdeFUyXFbwPapLh/Fq5xRMIW1puT4DMFyQJFXrt7ZS0e4JrKBIskbndThlmeM2xqZYAPgXWpFg1RqcbBc+q2l7nqQxxcf2LXzoDqr+OpTeMF30EDUjfAGIDNS8KZ/H9GSIJJvni5BdGVniAx2/usg5qP/OXzdb3Sp/bL/U+6vXVVVOd+n9xQ9TBmTjHqiZtwV9CfMlpk1DPjNrNn/D3cg6JWGROZG9SdbrLNu9EU2Nwu8wltgbmvEVH4nCtCYszPmmcU1Q+6Lw8yyR2oJjtnVHDAGOuhknd2+Upa+e9Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by DB7PR03MB3883.eurprd03.prod.outlook.com (2603:10a6:5:34::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.18; Tue, 28 Jun
 2022 22:15:37 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1%6]) with mapi id 15.20.5373.018; Tue, 28 Jun 2022
 22:15:37 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>, netdev@vger.kernel.org
Cc:     Russell King <linux@armlinux.org.uk>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-arm-kernel@lists.infradead.org,
        Eric Dumazet <edumazet@google.com>,
        linux-kernel@vger.kernel.org,
        Sean Anderson <sean.anderson@seco.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Li Yang <leoyang.li@nxp.com>, Rob Herring <robh+dt@kernel.org>,
        Shawn Guo <shawnguo@kernel.org>, Vinod Koul <vkoul@kernel.org>,
        devicetree@vger.kernel.org, linux-phy@lists.infradead.org
Subject: [PATCH net-next v2 35/35] arm64: dts: ls1046ardb: Add serdes bindings
Date:   Tue, 28 Jun 2022 18:14:04 -0400
Message-Id: <20220628221404.1444200-36-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20220628221404.1444200-1-sean.anderson@seco.com>
References: <20220628221404.1444200-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1P222CA0011.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:208:2c7::16) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b05888fd-ea4c-4e44-7fb2-08da5953ada1
X-MS-TrafficTypeDiagnostic: DB7PR03MB3883:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zxaEsr25ORtfqPXxTrJ8IClKEYl82Sl6YhJ1XjuyQgwsnfaJ5tNjhcqvhIzQ1NJiuFhqLf+bDYkC3nvka895EmQ731pfKKBts1zG3I8OJcdz/HMtAEe9QzAGiWPw+S7ytUDcJy0osd0X4q0Mt/ciu0yDUVnjLPrMxgu99GnQgx+c/elVrQLGStDk3I/dOspAwQxQlnffUCCasXP/dlr1XBLqj9Z/J9E1XgIomhv951Hwr56/mAm+aJGNoW1eEmfXnEx5y+aNcsHI6N0wFaH1McQsC6bhLS7wdF9zKD4MTQh2jM94zDXIqgK5DAEfJnfvHm2vuqoGcJg0ggPIWH/gVGYb8g3GpKqYNk7YyCtd3q9tU7rfs8AVxiGVfh9aLUa43huG+SS5LOeb5iBRxW9aUHnYQQy2k6qkgyjODHZvC1AzkSTBtYZFqdvpPAwRUL6ETvY5aFTn4IMEDijush1J817AkAIulutRUa4yeBaeBFe38g/uU0WWXjeTrsJMVqCkgQziowxnon9EnmZpvS44LDWUFM7z5+ky77dBDhJmKazhYRVn5vLT2GrRW/WQqFGmI2jKRlo9rsvJssKd20FAIMxHtqa5tkFb69dFA8hpTlloj3PGI4VtEwKyj0U1mY6FXDhmW9Urh4pGnpQlzdVp+TzI5AzCAXk4nniQEW9AOhNUhJYtD0eYISU0KV9nS31jYtG/GPdVYCLoYJWmUxpNY/cl/WfrYuv5mh7Hvg2HquJdccfWRXgPJhQ+tzJ83kiIz2tYxmdCgiMQtgFpYtV2Nb05bjGo7KwOBcQpHppj/Hw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(396003)(366004)(39850400004)(136003)(376002)(52116002)(6512007)(6506007)(8676002)(38100700002)(36756003)(66556008)(66946007)(38350700002)(66476007)(2906002)(26005)(1076003)(7416002)(86362001)(54906003)(41300700001)(83380400001)(2616005)(6486002)(110136005)(316002)(6666004)(186003)(4326008)(44832011)(5660300002)(478600001)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?kwdPNYd2TyQoT0btfaTdgu9Q/tdYdf70Z/x6Qb4STpHFxlXK0lSl0UGxKv/B?=
 =?us-ascii?Q?6C8rS30aMmJxTdLOCuW+wjlkQZUhGlA+sJesg3uxLB/KN3BNvW8xpSSiMwiK?=
 =?us-ascii?Q?pP5PvJzxiteDQMKVSlkppmFTTAP733GIEZU+/dDNfzGGwBrCfm/Xvqc1AZnF?=
 =?us-ascii?Q?WyJ+mKTTmRE1uRsmI6HTcUGtqe4nvFu11yq5fcbiTNaZeZSj0RizGUOYgLhV?=
 =?us-ascii?Q?sL/bB9hj6tO9Ltve3PsbWQbsWGHe0DEUndlVx2L0+nigNhxBb6hwv65YSDdl?=
 =?us-ascii?Q?FGE2p+3mlqxEkHihkw6aZEDXgb7EflF2tYnZqx/EAWDbtXF4/PXMOyko3LUr?=
 =?us-ascii?Q?SmfE3BoFacrJnii4bZoiQyztzfTjgq1B/QFTCuuX63vYbObKmzD0L2ecY5JK?=
 =?us-ascii?Q?+fUgXAymYQIIWGAYoyTGuOmYJ+qnUc+mVtqYNyBK7R7ElWETseufN0N9RH53?=
 =?us-ascii?Q?gGEpyRLOw2kUcQlmNidCOsOS6JKH1Ou6EkF/DG35uOm8W1lG2swJQ22FDq3M?=
 =?us-ascii?Q?Ks8Wb4cbw09kEPSIJRwc+0mVtyf3ta51qKz4LS38JBb8x8iN7fzIICKOvelP?=
 =?us-ascii?Q?2VnCCDEiwzIfxpsSiLDKDKqvkonDzEVvqmnQwd/Grlx6zKvNgfgHs0yPIiKY?=
 =?us-ascii?Q?oXavn34s0mO7StQ6ubQC9iNr38T6G7FXdKCAyPtpKe+/oRvimZ/ajmxIdIFv?=
 =?us-ascii?Q?Dnam1v7Q0zTTLm6rm2ueJwm47LUQbTHvTNLAee/CBrvvr3Rd4xsmpMuVm71m?=
 =?us-ascii?Q?dCqcycuPhZBfGtVyncJv4aBUkmQ9/SLNdxcfv6SzHHb0cl4+M3he6doAw+0l?=
 =?us-ascii?Q?C5QzkNxNSelYt9+ALBG1hlK00sP/sUjyiJa4k8X20PzZWuPg83w+JVEz2nOs?=
 =?us-ascii?Q?Vq/fxYJe9dkkBAhT30lg4+Do5qH0IKK/vnbktDXInNWeIffXqBK59AvVQ2ZT?=
 =?us-ascii?Q?anNF79GJGfKcRHAfCQOyaHq5fuFfj25z1tTyWewMVK6Zx8K+y9eKeq/0mBEH?=
 =?us-ascii?Q?0+vjVbsx05eQcd6+bhzYiOwFumgv6DhiVelzQ3rOBD6w8yVJr5dghzROL5w+?=
 =?us-ascii?Q?04tmytqEHEVHdHPXYr8OynxcjF0Zv/rJyHmra+LvhPttbnULP0UUWkgzzbNl?=
 =?us-ascii?Q?BxtLvNkBfCFKH/crgCmTutFhs6eRsJXnAnYrIs102Go24O5wysHASIU6HzXs?=
 =?us-ascii?Q?F0bsGU03wq9LxFbj8gjFLlReiLNiYtIYnjpxoC9J3Ml+yb31WNXARVrT+dnn?=
 =?us-ascii?Q?Z5J41b4qmeGC77/14lpk9JYkonUrZj9x73l8tV7e94mcxeUkc6P+stZSKimB?=
 =?us-ascii?Q?LL72rqEhTb4o7LloZNql9k6rrTy8X7YcRGzhH5t1LFP1h6egUC1Kao/KSEj8?=
 =?us-ascii?Q?DSsDO0UGsakCyL2pMv/GIWIio0RU/928qLfENTz7osHy4sZJ9tpSPJrcGULC?=
 =?us-ascii?Q?AZUafQhVqNRela2x2Ra2qCW+9C7DwWgSNCBcgLYVNl0GDG//UwdNq5N+R9lx?=
 =?us-ascii?Q?90qitVIbgOspmO6y5U4Cen9qpxq00nGCiBE7f7UxQegY/UhStZP9TVK7ZSR/?=
 =?us-ascii?Q?X5Zbjtf89ipEX51J909sgeg/wd6OqY3iy6buLZYJWlC93mlbSS2IDr2rDFBW?=
 =?us-ascii?Q?eQ=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b05888fd-ea4c-4e44-7fb2-08da5953ada1
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jun 2022 22:15:15.7171
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hVb7q+/nZEJ02O8dpo9Hhi8JshKxEhRizjnueMDtWBwElxRml/dpUCQEn0Ly9k4m9JqC8et33IRDgUFkAoY2XQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR03MB3883
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
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
index 857b4d123515..c9f687384c13 100644
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

