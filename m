Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BEFB4FF4C7
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 12:35:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234928AbiDMKhU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 06:37:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232004AbiDMKhQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 06:37:16 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60087.outbound.protection.outlook.com [40.107.6.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 508FE120A3;
        Wed, 13 Apr 2022 03:34:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kenrutECBCCdtwdtu/L4BVeIINDfOv5YA3yQHpTZBg3IZzHUjnfgOmsKSZLozdpeI9ggW8l0h+D/bwZINpGh6M/nTsBJCbArBlXugHcQalUbzDGad5yslK0xFT4Izd2e/2o9UGY9ILtqy1Z58qDS6L8tgbLIkzoNYeCEOTACE8xTeVswYjjYRmV2C5v5Hc7b2+0PRmetEZq+j49AN80Am0lz/sfi+b39HSD2V8uC7SvMoaL/gnQ60Ay+BdXpxs6pqFnofg7+qDWrCUa6Nr0mSpF/IP+wTdj82cPNkdQUloybeR4CQGES95N4QirNzKJX155wCvANU7kQeXW5XYxjgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=29MwMLyVa6BQohSVPla6TZEn2KKYstzoJyjXeV/Xr1U=;
 b=RsjQVNqKK3XHF2Vw5VzLXBcOym8uHjKBUr/AitAL0uat+j35MQeEazdijIF4RxtmpkX/I4/NPe7WwLSK2up1cwXDGOpUWEiKJqj0/8PfgTE5vICi95jr6MgDVXqYB82AsFlghwcBVf+MkKJC/T1SxXrc55/v1R2q5XCdzaSXzDyMCrvDS+Txhxjl+pQOtBBkxGdBCeX1kRZc1UHeRmBGavh6eAqLPKX0ybLzfORPKemZ0p36nIhatRSfCm0rwVZotSHf2j/Bx33Xhlj2NTIxzbVYAAqzvY9EEzOgQzGWVTTBy/S0/pubuvYXdmty5E4eTroMKImKJBFtieFOucT9zA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=29MwMLyVa6BQohSVPla6TZEn2KKYstzoJyjXeV/Xr1U=;
 b=m9vvccmHap1THhgE06v18REtHddDPBslrVneNqoMFg0FWEjnSrMLGNaFxtryHB468B1aaabfBH4poreOEzuhlY/SAMEnEV3BXaectNW9+1knTisi7xc5hK7ieGdEcBe68/GwiFhdzJIgTNST+NmhR6cvYEv/K3huMztmL5Yv4eU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB4688.eurprd04.prod.outlook.com (2603:10a6:803:6a::30)
 by AS8PR04MB8691.eurprd04.prod.outlook.com (2603:10a6:20b:42a::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Wed, 13 Apr
 2022 10:34:42 +0000
Received: from VI1PR04MB4688.eurprd04.prod.outlook.com
 ([fe80::a9d1:199:574b:502f]) by VI1PR04MB4688.eurprd04.prod.outlook.com
 ([fe80::a9d1:199:574b:502f%6]) with mapi id 15.20.5144.029; Wed, 13 Apr 2022
 10:34:42 +0000
From:   Abel Vesa <abel.vesa@nxp.com>
To:     Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>
Cc:     Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <fabio.estevam@nxp.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        devicetree@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-mmc@vger.kernel.org, <netdev@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, Jacky Bai <ping.bai@nxp.com>
Subject: [PATCH v6 04/13] arm64: dts: freescale: Add ddr subsys dtsi for imx8dxl
Date:   Wed, 13 Apr 2022 13:33:47 +0300
Message-Id: <20220413103356.3433637-5-abel.vesa@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220413103356.3433637-1-abel.vesa@nxp.com>
References: <20220413103356.3433637-1-abel.vesa@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM6PR04CA0047.eurprd04.prod.outlook.com
 (2603:10a6:20b:f0::24) To VI1PR04MB4688.eurprd04.prod.outlook.com
 (2603:10a6:803:6a::30)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e30dc370-c8da-40ea-e1f2-08da1d393867
X-MS-TrafficTypeDiagnostic: AS8PR04MB8691:EE_
X-Microsoft-Antispam-PRVS: <AS8PR04MB8691C85FD1A025B575867680F6EC9@AS8PR04MB8691.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: U3fWWCmJI+r3OklT43ptRx7yLkYNWP8EIo5jL69L4sqS2o0OjfUEGj6NYPi1k+lOuf0vo2wNmJfzwM8Zt60NPeUZfTphQK+iz+fcdoWr16rV90+ZVQkaJhbME5gf6QX4FtfMIAXuUnXOKTYRUI4A8PyP8dOtMz2XKUjR35+DSgr0959skHMKXCpiM4XAD0AyvZO4izUEb9HtvJLt5QthrEzTttDrmXVHJuyFdPA6n/bPys4HSxpTYKyCiT5f1/XUyuaP1Vux3vZDRfcvJJ9SejX87ER3oWWCa8WPfyt3AFU1OAx+DzU+gXpsCTm0/4J9ZiABGZohv2BzECyYUpqgksr73X7LE7nEzX9rXAH844IJ9gSs82BBEF/FQnq2wGRI3knv3AfNjygEbkC0BaZa0tY+C/mfZcpwOg9081U6DsmTKggrHpUxnR4KMgm5H7OWieReQtIGjWzIBvn5ssFQacIVJv+a9P4rc5KVHlIVm+ZOOYhjCfrEWVYFLLxwN4uko1abeApk+ORAjP7VZbPcgax26J1shCVwmcXE+DsuYkqr2nX5tSJQ2j4XsHviWKo5+DE9GxwPugEwpwjwvfPlzq0ugvGfwo/JLQyZU8hKnjosM9jGChkVfiKI45ZSkPerpHJgKAewvLS0D8X3dsA3byoqHYxcWVeBpP/PldfpE7j2jW97l7NHis3ROr9ZCky7ayOywtjmq4R7eLLekng2AdU5ZQ8oKFooNt+/jKo5uUA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB4688.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6486002)(38350700002)(38100700002)(4326008)(66476007)(66946007)(66556008)(316002)(54906003)(110136005)(508600001)(1076003)(8676002)(26005)(186003)(2616005)(52116002)(6512007)(6506007)(86362001)(2906002)(44832011)(7416002)(5660300002)(36756003)(8936002)(83380400001)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?KQuF4sdjhjfHUk07B6GlkWx7qD4UAdqYulNT5/34GC9rpgg2nMzGpJNHxoQR?=
 =?us-ascii?Q?bG3jU6FQO31CvThX67W/0Fk7Soccs0VqVYeZu1wIgeZD5eJogmaZT0z2io3l?=
 =?us-ascii?Q?ohmz9Jlt1D9BjLY9FgTDxTipDINubG0Ig+JdbAXdJ8s8c9Fwbntw9Ubz8DVj?=
 =?us-ascii?Q?Y6918cH/Wso0vUN3pNdvMrQSjDQLg/V11XRSRHqOITDMC/OP6LqjFXSE2W5o?=
 =?us-ascii?Q?zRj50pqV6p/RFryq02/In9k6cfD259bAmRNwpcLeooRK6hY9jtd5JtWnKg4J?=
 =?us-ascii?Q?QgfjGtRy2uD8cvq5Ov0JIHpmuGGMXsaWQ0RxzmtQaTVAUrKW1pKBXeYUJtXR?=
 =?us-ascii?Q?LXLrNISMSJU6tD6kxlckMb6GKmnjm1fQTD4IOqUPlVvjElrupGesEVmwF9CU?=
 =?us-ascii?Q?+HjDgGdE3oSkXqED2nOrmUZt7jMxOxjEdKmv5IoIBmGzn8puajFUG0fSuS+z?=
 =?us-ascii?Q?UMrfFTcIZiv6z8TpqYZaciP/YntEYBl6+9L1tCvHzGYPxrH0ECqg9VkPdvl3?=
 =?us-ascii?Q?5LgoFzK3DphdytYaQ+Rn91dF/jJF/i+PCTms1Jq5PTSU40RK6+9p3uXHnJax?=
 =?us-ascii?Q?38rYPWmR0VIFPSS4c6VBUIZa0ETuQQopnp2X3K934M4J6zOg71lWEn1p4Khm?=
 =?us-ascii?Q?Ixx4oQPl1daHEOGN7l2+IWh9tVFEqWtWct2SX/nUQq/qic8ti8yIPHZIQZZ8?=
 =?us-ascii?Q?M/p76jWHsFvMedpjNvohU/YS/t5cSvEMEjPk6kiI178mL3BaSdJwH1ZLwHw9?=
 =?us-ascii?Q?GPR7z+C+E+xzpLXeaBFi9CjgO1xtf0OkYx8wUHWBdxfJ/465l9Lo3S5IfT3J?=
 =?us-ascii?Q?DoicUYKaPWmEkp/eOBD4DZTcWKwwRQaKdhpLay+15XlnuR+NAX7QitIwbDxJ?=
 =?us-ascii?Q?WfQmvW4KphGt0pAEikk/nRpHU58G2lF0zopgHGXl8TwrULBp0yvncgcCaH7r?=
 =?us-ascii?Q?8iojGeZdNDq5zYiK2SN/LL7GGKzSWOhc4TsOgw9uTMs5TFsJKYvbDNfg+J4O?=
 =?us-ascii?Q?ZsOqc/zZDU02YQsQqwjdLcHAHINXJ9cY9BHpd4uaBFdjm5B8P2l0mXwbCWLp?=
 =?us-ascii?Q?CXO/Ze/FDwkHTlhm84OecflCMRVbFtCqVgWPvAJ7Lf7FAFi5z0x0Bo9Ewe8P?=
 =?us-ascii?Q?g+O0tp3q1IhFVz97w/DcurJCMA/k+Sc3g2tJKOiT+OBz/VNmjcOR7yDI+tdO?=
 =?us-ascii?Q?aXhTmhBAx00Umb79FQjNyaIKZaiK6UcgRFTZ5saY76WBF/lrcfKaBr4qKA4e?=
 =?us-ascii?Q?aY53UdPqUuL+inxu1tm2e/oWAzHFZX9+rR/uJz5DhVwaPjfD8sai0Cjl+kMz?=
 =?us-ascii?Q?q3hVhxrH64A41AMJQ2un/mt3IILKX9dDUMaduOwVjumXLczRftRI4x3olE+U?=
 =?us-ascii?Q?0QVjWlVuLDWEESCcljVMz9r3Yt4upJDQvNTGefkZdN0Q0bp1vyNxTIrsqfk9?=
 =?us-ascii?Q?t1cIYglwi+4sN8HroXYAFXqltXUCPO8THwQqxZTK+MGULGnWw8Pa8skpc+vQ?=
 =?us-ascii?Q?qcB74sxDz2JattkozvGVJGhWicAcxlLi0/V/jMoYGxZx4HZz4UyUaRU2ZiVs?=
 =?us-ascii?Q?cbSDQDjLuXADveuwoLzTi3PD0pQZeHRDBjJObLzvcAgrEtP8zmh6kesqXUe/?=
 =?us-ascii?Q?HQ2mln65QOKQJFSFPGHfzl0SJrK2K3qphW8XE1o3BUz38xByCCFPzYDRotR9?=
 =?us-ascii?Q?PN4W74jGmsQG5BrdppXjFrelUNY7XvKvOJ407NZ1rzxdxxqGqgBGV8c/2l3m?=
 =?us-ascii?Q?LFE8Uw7yJA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e30dc370-c8da-40ea-e1f2-08da1d393867
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB4688.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2022 10:34:42.4269
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AmGENMXbtm6zXANJhLf2gcs6Yygv8jHFcbWp7HP3hyXQqonjg0hAWaGXtisZ7A7sjyNUyeg1BrA5wDORjiREDg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8691
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jacky Bai <ping.bai@nxp.com>

Add the ddr subsys dtsi for i.MX8DXL. Additional db pmu is added
compared to i.MX8QXP.

Signed-off-by: Jacky Bai <ping.bai@nxp.com>
Signed-off-by: Abel Vesa <abel.vesa@nxp.com>
---
 .../boot/dts/freescale/imx8dxl-ss-ddr.dtsi    | 36 +++++++++++++++++++
 1 file changed, 36 insertions(+)
 create mode 100644 arch/arm64/boot/dts/freescale/imx8dxl-ss-ddr.dtsi

diff --git a/arch/arm64/boot/dts/freescale/imx8dxl-ss-ddr.dtsi b/arch/arm64/boot/dts/freescale/imx8dxl-ss-ddr.dtsi
new file mode 100644
index 000000000000..75b482966d94
--- /dev/null
+++ b/arch/arm64/boot/dts/freescale/imx8dxl-ss-ddr.dtsi
@@ -0,0 +1,36 @@
+// SPDX-License-Identifier: GPL-2.0+
+/*
+ * Copyright 2021 NXP
+ */
+
+&ddr_subsys {
+	db_ipg_clk: clock-db-ipg {
+		compatible = "fixed-clock";
+		#clock-cells = <0>;
+		clock-frequency = <456000000>;
+		clock-output-names = "db_ipg_clk";
+	};
+
+	db_pmu0: db-pmu@5ca40000 {
+		compatible = "fsl,imx8dxl-db-pmu";
+		reg = <0x5ca40000 0x10000>;
+		interrupt-parent = <&gic>;
+		interrupts = <GIC_SPI 338 IRQ_TYPE_LEVEL_HIGH>;
+		clocks = <&db_pmu0_lpcg IMX_LPCG_CLK_0>,
+			 <&db_pmu0_lpcg IMX_LPCG_CLK_1>;
+		clock-names = "ipg", "cnt";
+		power-domains = <&pd IMX_SC_R_PERF>;
+	};
+
+	db_pmu0_lpcg: clock-controller@5cae0000 {
+		compatible = "fsl,imx8qxp-lpcg";
+		reg = <0x5cae0000 0x10000>;
+		#clock-cells = <1>;
+		clocks = <&db_ipg_clk>, <&db_ipg_clk>;
+		clock-indices = <IMX_LPCG_CLK_0>,
+				<IMX_LPCG_CLK_1>;
+		clock-output-names = "perf_lpcg_cnt_clk",
+				     "perf_lpcg_ipg_clk";
+		power-domains = <&pd IMX_SC_R_PERF>;
+	};
+};
-- 
2.34.1

