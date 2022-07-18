Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87099577AF6
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 08:28:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233538AbiGRG25 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 02:28:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233410AbiGRG2w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 02:28:52 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80040.outbound.protection.outlook.com [40.107.8.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54AA41F3;
        Sun, 17 Jul 2022 23:28:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VLLJ45XzjC7xKrLUVLZEt7laxxgqOM0e1GlWHQH9yEmyJwTfVMkn5kbuhq23SAMkkwgnfcTEUpjEoVp9SADc4DEyk8fd+2o1HoSy+eeu+feYdSeHn6BQZ/PrpKwQiSpTNTQhE+iATtOEL1qz1JU+aRgwHVV0t3V67keJ0VePxlkVSTsqX8IivfYM0tEyOY1JcKZSDOe8mRK2Ruhw2enO8SP/366WQypE39/zEjwyrVOeoDS/2myDZsJ1XusGooxC8OqaoEnj1tnwzGdhmfqQGb5rn23K8ZgWPSbZED0NEXV5umcWhmjzuMhSIZD3my9rJ9mclfm3cqPjJXJDYyYjKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e4IXncNovrLGakf3be5yaE1SpheHnzX2L/AXMbVJIcQ=;
 b=d62Nklle80AD4n/AFQAAVAEYtDOr+1dfmkGbUnhjkyTKHpYM8CuT0lR/2679XSxAisb9GvdStXmccpCa9Hr7UAE2lLtoGP/TwLkNj8qI9dk3q0GnjOUNSv0QS8x/F76wEuHkeEvYgcP9xkWHwwt+oKPhUTPgWt8v59zjsf4n6L0VkYZYlK+nbFPg9SmPgz+zOjBMPq6MMolqBJ1fxhyXSyuRqvy7L8i1wQLddSQL1KBdj0nPNTN0UOEHifZi98E57P8396Ye9reHesEA6HOp1Xf1gnswqA9TsnnJw4SN/W/LlnW8sCqCnZeCs1HMrSo+w5NhMQznzARyyJKQR/vXbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e4IXncNovrLGakf3be5yaE1SpheHnzX2L/AXMbVJIcQ=;
 b=eOO1bCOO/pExLeC9Zlo9ZGm9P+RwTddXjYjLURXAcjjKBRNL7AK0NuX43n4Wl24XaYL7qWA5l1XhwfvlGeHh6gSGopkLTj5gzvSbQRAfeeCCzsOi23wAfx9dSUmgpB1tyhedU7gCKq6NfS4bE5Wp6xW1pmear/7WJSHFs6t/BcA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM9PR04MB9003.eurprd04.prod.outlook.com (2603:10a6:20b:40a::9)
 by AS8PR04MB7704.eurprd04.prod.outlook.com (2603:10a6:20b:296::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.23; Mon, 18 Jul
 2022 06:28:45 +0000
Received: from AM9PR04MB9003.eurprd04.prod.outlook.com
 ([fe80::3848:9db:ca98:e5c1]) by AM9PR04MB9003.eurprd04.prod.outlook.com
 ([fe80::3848:9db:ca98:e5c1%7]) with mapi id 15.20.5438.023; Mon, 18 Jul 2022
 06:28:45 +0000
From:   wei.fang@nxp.com
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, shawnguo@kernel.org,
        s.hauer@pengutronix.de
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel@pengutronix.de,
        festevam@gmail.com, linux-imx@nxp.com, peng.fan@nxp.com,
        ping.bai@nxp.com, sudeep.holla@arm.com,
        linux-arm-kernel@lists.infradead.org, aisheng.dong@nxp.com
Subject: [PATCH V3 3/3] arm64: dts: imx8ulp-evk: Add the fec support
Date:   Tue, 19 Jul 2022 00:22:57 +1000
Message-Id: <20220718142257.556248-4-wei.fang@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220718142257.556248-1-wei.fang@nxp.com>
References: <20220718142257.556248-1-wei.fang@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: KL1PR01CA0118.apcprd01.prod.exchangelabs.com
 (2603:1096:820:3::34) To AM9PR04MB9003.eurprd04.prod.outlook.com
 (2603:10a6:20b:40a::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 91549467-a2bc-4b49-cb50-08da6886c3e2
X-MS-TrafficTypeDiagnostic: AS8PR04MB7704:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uoIShGPo442fHHRQeTkxNzSjjdfoDhvlLJuXYxpEjAFV8MyYIkj1PSRSNEttN60yCWIvgib4qrSliHo/VUpdR/4R25y5dCtQQm/nlwCdnOrlLYXIhfTShtYCGO+AjpufkxmZaO/qsXqrzwsxjIRVHi2SfMUrmQcrEzJJCOkGHyuN10i/Ga8xs4Q5Zwxe8T3EJtkKdbXkVUlo5iPB+XR349N24tMNKiHzebR77A4woStjn6i1Ba8CMlgi3RwyqItwjXsQaavdglCrKd4BeSNBzSRmRtEcaJHi46/wnoLMt4EHCGtvfdAkUsLBTu8hTcuOxz25bDk2H+2BbiE/fhGUkr/oJrO2jmfg5RFXVGZ/aBxLnsk6y2u2EJ95D5UuYzGbWa4hMTQ2sF5p+CjhB8EEoy+7wyTn1S5rbXPA3+zJc9vz+PqalqXpDE3WSKXyhKhtEQsU6nT1HEHPvvHfWlpLJ5Iup6joI2pxm1ryqGefrsiJI/YPTsKetxTi0Q7R0+0SqQBNWjxni8jTLK/0bsvNV7kor/VyOcRewPt95l1WZjuAlzb1vNauYRjfQT2E6EQZIGIPsdWKZnXlBplKs0DcWpSfwpqiG7QEapVmLWBhc6iSuYSBSOpVCEDL+aNntzFLA4l8EEU1Yq+9QemMwtQbGfKF8fVrKfNxQTaDycg9+V/ALyXMwaf449Xp8RgTFWdrj5S2SXHc9bWznDM1HCOLvjvHu1BUnWMbI/XMubV41Ae56inb5UN90yJRTisuf6trd04U8aFNlG+dgJgCGF6VzOVjx8Dx3VC1nEahaVZIgYkj5FWGBd940uGAZ94wy72RJZ9+UCaQXDo613CIK8ot6w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB9003.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(396003)(366004)(39860400002)(376002)(346002)(83380400001)(6512007)(9686003)(186003)(26005)(41300700001)(6666004)(2906002)(86362001)(52116002)(6506007)(478600001)(1076003)(6486002)(7416002)(2616005)(5660300002)(8936002)(38100700002)(38350700002)(316002)(36756003)(66476007)(66556008)(66946007)(4326008)(8676002)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?DhOJc8lIMr10ZstRd/x6Xa1D1jbEn4msJObxeNkWbhM300ALL0x6LWlIRWh6?=
 =?us-ascii?Q?+2r7wyDZu5VTJ2prwFOnc+Fqp0obzdpESUrTzWU7Q4Rt9LMaBETyxy3y5X6Z?=
 =?us-ascii?Q?GHKNfI55z88yx2zS8nQ2HWqtVXodJBHSXh2FI1JgLJBVHti2y7vDj8kGMFa/?=
 =?us-ascii?Q?/dQeY93orBSKK6EIQDxcYK2ECiKAJKWuyjcFToBXo+MhjOPgiub1dOpfB8kg?=
 =?us-ascii?Q?0o2WkrmLRTBB5RM5p9dK3BH8DEEvTtOeVgjnvDbb/ENLII5jGW5K63gWWLlj?=
 =?us-ascii?Q?VBGZTJS2iauopYx5nTLlo3p08eMPPk1hsR2vofr4lKjdb2l+o3BuIN5H5uwe?=
 =?us-ascii?Q?eZt4SA8n2ne+4lvYk2Tjz0gWRnJPa54X014DGz+48wU61lfqmTl7r1z95PJN?=
 =?us-ascii?Q?/g63OmNzQ6G/c+eH/cKnogtkmafRfX5dM0EF63pN+ByztBCPmeQ4mXrY1zPs?=
 =?us-ascii?Q?dfziHg7QfBiFUvkYlJH0fRJK3hV7N9BfKxB3bf3cmE4V7PNlYLQVV7LnkOgw?=
 =?us-ascii?Q?Z1C8jS4PQkBOYEZO/qLk6/TqAoK6kvD6OdVCJRjD9XmwCiLehMf/HY9oEgw0?=
 =?us-ascii?Q?ND/j8UcvsFPKXX+ZJLODXsS7VaGRhV/ofYURGDnoDxVWK1wWMyGNjCpZTXaZ?=
 =?us-ascii?Q?1b6/2i92MvkQmJZh1i321viB3FznuO9jgZDd3V07B/kytCpXwNjFxFC3rwo4?=
 =?us-ascii?Q?FR3rUYJh5yR/HQdenhaQWk1MlmGRNj55kFK18OFC4UK7z6A9kDyUhvd2ofZx?=
 =?us-ascii?Q?nfiYNcHogjM4mbGpnicrdYl6jDIzjM9a5aNrxwGqFlG0YvqwfqwV6r8U+qRC?=
 =?us-ascii?Q?hEkoWrmiSfYePcxdFhYKS5/NPvRDSXOvQg+xPIMEW7hPVafTSireGqfbNiGh?=
 =?us-ascii?Q?5G1WRf/wHyO+B3MVDLN4mvW7TaWjVO2wl6CY+nznKfH2Z3XFvIQPtQ3JG0XY?=
 =?us-ascii?Q?HmHK5QBoSkU4CgW3jq9SdQD9uMqKXgqV5blqO3OWP4ialEFlTNmm7CO6Jiyc?=
 =?us-ascii?Q?phu4Z0Se1fxPTvkdDQA+tT/Mxf/dmpCrfQjllzhBCEwh4DGTMlou8BBWq/RU?=
 =?us-ascii?Q?0yebmZnxwTyVKWRwb9OGILbE0UWUPzvGOd8zIphXH4+19Q1gx5sDqCFLohzU?=
 =?us-ascii?Q?vKsY2s/oQXtjsqMOzdbJv+Ci5Cmi37HMyr4AiFDPlYy1nVkLaxxhHqYiucik?=
 =?us-ascii?Q?F1n19rKLjzWHoC0usNBTH0HQ6qhAxM+ys7M3bflc2Uelz4jT1EAF/Xf0i9Gs?=
 =?us-ascii?Q?JkkoLXKxI6Y/BpLjZSGlKHgakFmTD1XygkJ9tMcYyzj3CNuezk4t9tssiPmW?=
 =?us-ascii?Q?W2XmdptxfCpg8AtBsjVqVMjiFNgop4LfUewR7UCX4ccjn6w1I38FCQZmw1XR?=
 =?us-ascii?Q?EjOU8blklMXp3yOlzghzSDYaUchllLBwtMNLXyOdqTjovA05+2TTNJQIiiVe?=
 =?us-ascii?Q?YpnqrglVySZv5kQyfADsMbDsWk756enGUVStiUz8fD6FE2MTDaiWoACIic98?=
 =?us-ascii?Q?PLal8Vem6gyjfT1D+h5ynQWJPebZKogbIIPnvB9HmxOaztwrHCkJDo3AuRhK?=
 =?us-ascii?Q?nigUHDDPnPjbZIYpwyzeCnBPHHvI4zoWjibFbEzo?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 91549467-a2bc-4b49-cb50-08da6886c3e2
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB9003.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jul 2022 06:28:44.9391
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vMEen6m+jVDMmMdURzxeQ8FYnyBZMEOsHxJxtmCMb3E67YwZB3yDJLovVsaiKnU7FxXSlm1TNvSiByXkcK81yw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB7704
X-Spam-Status: No, score=-0.2 required=5.0 tests=BAYES_00,DATE_IN_FUTURE_06_12,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wei Fang <wei.fang@nxp.com>

Enable the fec on i.MX8ULP EVK board.

Signed-off-by: Wei Fang <wei.fang@nxp.com>
---
V2 change:
Add clock_ext_rmii and clock_ext_ts. They are both related to EVK board.
V3 change:
No change.
---
 arch/arm64/boot/dts/freescale/imx8ulp-evk.dts | 57 +++++++++++++++++++
 1 file changed, 57 insertions(+)

diff --git a/arch/arm64/boot/dts/freescale/imx8ulp-evk.dts b/arch/arm64/boot/dts/freescale/imx8ulp-evk.dts
index 33e84c4e9ed8..ebce716b10e6 100644
--- a/arch/arm64/boot/dts/freescale/imx8ulp-evk.dts
+++ b/arch/arm64/boot/dts/freescale/imx8ulp-evk.dts
@@ -19,6 +19,21 @@ memory@80000000 {
 		device_type = "memory";
 		reg = <0x0 0x80000000 0 0x80000000>;
 	};
+
+	clock_ext_rmii: clock-ext-rmii {
+		compatible = "fixed-clock";
+		clock-frequency = <50000000>;
+		clock-output-names = "ext_rmii_clk";
+		#clock-cells = <0>;
+	};
+
+	clock_ext_ts: clock-ext-ts {
+		compatible = "fixed-clock";
+		/* External ts clock is 50MHZ from PHY on EVK board. */
+		clock-frequency = <50000000>;
+		clock-output-names = "ext_ts_clk";
+		#clock-cells = <0>;
+	};
 };
 
 &lpuart5 {
@@ -38,7 +53,49 @@ &usdhc0 {
 	status = "okay";
 };
 
+&fec {
+	pinctrl-names = "default", "sleep";
+	pinctrl-0 = <&pinctrl_enet>;
+	pinctrl-1 = <&pinctrl_enet>;
+	clocks = <&cgc1 IMX8ULP_CLK_XBAR_DIVBUS>,
+		 <&pcc4 IMX8ULP_CLK_ENET>,
+		 <&cgc1 IMX8ULP_CLK_ENET_TS_SEL>,
+		 <&clock_ext_rmii>;
+	clock-names = "ipg", "ahb", "ptp", "enet_clk_ref";
+	assigned-clocks = <&cgc1 IMX8ULP_CLK_ENET_TS_SEL>;
+	assigned-clock-parents = <&clock_ext_ts>;
+	phy-mode = "rmii";
+	phy-handle = <&ethphy>;
+	status = "okay";
+
+	mdio {
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		ethphy: ethernet-phy {
+			reg = <1>;
+			micrel,led-mode = <1>;
+		};
+	};
+};
+
 &iomuxc1 {
+	pinctrl_enet: enetgrp {
+		fsl,pins = <
+			MX8ULP_PAD_PTE15__ENET0_MDC     0x43
+			MX8ULP_PAD_PTE14__ENET0_MDIO    0x43
+			MX8ULP_PAD_PTE17__ENET0_RXER    0x43
+			MX8ULP_PAD_PTE18__ENET0_CRS_DV  0x43
+			MX8ULP_PAD_PTF1__ENET0_RXD0     0x43
+			MX8ULP_PAD_PTE20__ENET0_RXD1    0x43
+			MX8ULP_PAD_PTE16__ENET0_TXEN    0x43
+			MX8ULP_PAD_PTE23__ENET0_TXD0    0x43
+			MX8ULP_PAD_PTE22__ENET0_TXD1    0x43
+			MX8ULP_PAD_PTE19__ENET0_REFCLK  0x43
+			MX8ULP_PAD_PTF10__ENET0_1588_CLKIN 0x43
+		>;
+	};
+
 	pinctrl_lpuart5: lpuart5grp {
 		fsl,pins = <
 			MX8ULP_PAD_PTF14__LPUART5_TX	0x3
-- 
2.25.1

