Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA5F1457DB7
	for <lists+netdev@lfdr.de>; Sat, 20 Nov 2021 12:59:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237397AbhKTMCj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Nov 2021 07:02:39 -0500
Received: from mail-eopbgr150084.outbound.protection.outlook.com ([40.107.15.84]:40930
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237419AbhKTMCg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 20 Nov 2021 07:02:36 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G7zGAm11JBUkIyIL6eNNAsU9vN2KeNXQHu3KnZMLh8hRQzuc7l8pioRoR00x4CzCmh+a3MTRLOlf7P7Be7uw3BJSXAMh2UOCWQufRK3HBuVXFGGNk/TQVdqxXfK4OrHEBxAfnD6ZvUXjyudavMou2/sNKVbXQf5cEvu0gPzgNXNUZI2vKtvDfLcG3xDm59i/oPCb+C04hJmlgDM4PgGYhmz+UBbt0/FNb3HEsJyjRbqWFBhksSeuTBI9S0BxOzeadaz4lGn4AYLyy1ly1A5VZNmvzTLIJzarSX6yF0qkNn0c90E8szxsSxswiIH1gis5918Z2ek3k4nLbU4abiSboA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ff3Qp5WunJaD7cTtf1nCWilvyBGrn1N6803XJyKCMa4=;
 b=L928vhfvfV3S7Ee34vtG7AJAC/dtUnfbQWXdKzdfCgs+x58hN2mlbeCmr+yKgeJDhshs2VG8KggBkPFugAz4SCUI/c9n+QpucQfSnEO916spTH/C9eYzmY8Kbm9DZ775e8Cs2eltJ+tQ2z4UcpZOfj6XqvJz6UogTAbMRwA4yARh/RUumFdSQ0mIoeTzDRzfy7PbObBDaUAZ2nayXI5tjJMXrP1Rl1QGCQMFlgknppB00WMFb0zs22nNKfb9v3+BIFVUihpRtwiqlXqyiezfb7MTi3dcFqrzanyrMdIHqHdJ0XwsWzj4ZhhrWlVxWNqXQoSS94E/iegyN91D2PLtRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ff3Qp5WunJaD7cTtf1nCWilvyBGrn1N6803XJyKCMa4=;
 b=bL8TeTJlgA2ps26YLlirQnVPZ59xvK4g6j2pYGfFzxc7/BeVMkFqRHUs59YdBIwCbECvXd14S2vH3+8F43aSZhuIjH97W08r6GRfiJGAP6rlDC92oCo3TolvIPmft38xmztp9WGUykzphOFZS7D+/r7Zp80rYzdUWLHY4rnQCIQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from DU0PR04MB9417.eurprd04.prod.outlook.com (2603:10a6:10:358::11)
 by DU2PR04MB9082.eurprd04.prod.outlook.com (2603:10a6:10:2f1::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.21; Sat, 20 Nov
 2021 11:59:31 +0000
Received: from DU0PR04MB9417.eurprd04.prod.outlook.com
 ([fe80::82e:6ad2:dd1d:df43]) by DU0PR04MB9417.eurprd04.prod.outlook.com
 ([fe80::82e:6ad2:dd1d:df43%9]) with mapi id 15.20.4669.016; Sat, 20 Nov 2021
 11:59:31 +0000
From:   "Peng Fan (OSS)" <peng.fan@oss.nxp.com>
To:     robh+dt@kernel.org, aisheng.dong@nxp.com, qiangqing.zhang@nxp.com,
        davem@davemloft.net, kuba@kernel.org, shawnguo@kernel.org,
        s.hauer@pengutronix.de
Cc:     kernel@pengutronix.de, festevam@gmail.com, linux-imx@nxp.com,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Peng Fan <peng.fan@nxp.com>
Subject: [PATCH 3/4] arm64: dts: imx8ulp: add fec node
Date:   Sat, 20 Nov 2021 19:58:24 +0800
Message-Id: <20211120115825.851798-4-peng.fan@oss.nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211120115825.851798-1-peng.fan@oss.nxp.com>
References: <20211120115825.851798-1-peng.fan@oss.nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR04CA0012.apcprd04.prod.outlook.com
 (2603:1096:4:197::14) To DU0PR04MB9417.eurprd04.prod.outlook.com
 (2603:10a6:10:358::11)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.66) by SI2PR04CA0012.apcprd04.prod.outlook.com (2603:1096:4:197::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19 via Frontend Transport; Sat, 20 Nov 2021 11:59:27 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 71650acd-9616-4ea9-208a-08d9ac1d3625
X-MS-TrafficTypeDiagnostic: DU2PR04MB9082:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-Microsoft-Antispam-PRVS: <DU2PR04MB9082E820C1C4122B3A102259C99D9@DU2PR04MB9082.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:296;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: C0vkD2+rZHaQ4FW2C5SM237DZtFKdN0OSmw33uinrYp/TC1JcybgfCYe4edg7AqzNx4DD2FFug1a7CZtUWvFxO1bI842UZS+XjlkytEjIzFAZRQ2NjZ1XRgJi5HauDgTNi+CFrqiS8cdy/gxg5F3i+vI6VRl4OH0FrkBXGswSEzX6l9CPX17nkUcQ8TPPsddjbVe4Tl0CPxrCTLPmvd84tgBEhsQqg9DWdN/SYbg2FCs6d8N9Ctp0vBu+N0TuFpftV0q+lyat3eIzoLu1yhLsN9x7xr4euekehMWLlA4iVJCq0weqowrhm4Ay8/HxT7gyBERXstLgmmYr6bkdSaeW/sGc1FjlDfEG/SjkeeSGewHV4hxGE85npzZJto/Vx2N1RWhezTDTAwcYx9fFjs3oI7FXTcyWOcod/R++eGndud6JvZeZcu/bcW0Ot+7xqujsq4kbdDzSGBkHsySq8HpCKBXzlXeHNvXstevLH+x+rPTRWtpy5OF66LrXcKSU8Jkl9Yz+sSzi6M1dEdN+/d+EvyPRf6ke+C3zgEicyeSWiTMGv8N1PI15iZvTRrzQrGDPSU19aehTz2uPcqo41kA6TjALlPFynwogw7jPxiUthy8fhCrEQlhpOkHIyj4oMjz8XPsKZqTxK59nLHwL3edGkflak9a3YgIbSsuF27EQa4k6CzdcUxQ5qCBZs09Qkx5DweIBaRcrBqr3+K7VbCQjvSlN4PF31uNNUdF7muLASo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR04MB9417.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66476007)(6486002)(83380400001)(4326008)(5660300002)(7416002)(66556008)(8936002)(52116002)(2906002)(86362001)(66946007)(1076003)(316002)(956004)(186003)(6666004)(6506007)(2616005)(26005)(38350700002)(6512007)(8676002)(508600001)(38100700002)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ZxJUuUn1TSP3a0KneA6v0SnDBRcM/EfjjVIeTpT8lD0gJAfYNiYgIPPuGiRm?=
 =?us-ascii?Q?gwyaWqkXTCO5BhlZgUTS4/JZ2TpUx0cWGVXs4X7Huu5Hsjwp8Vh+1hCss3EZ?=
 =?us-ascii?Q?EBdYQpwvNDvOs1KEYnZiNYI0CvqVY++bHKPgWVjOXIUPMSaTADb47TS9td+g?=
 =?us-ascii?Q?FH4t1uJZQptQt3zJnJXMiMt6NNkXn6w80+DeWszN5j6wgmcIqQ4ihGW8U4cW?=
 =?us-ascii?Q?utrGloYW56wNxgmGNPnMr2PCdz0//UjLP1pRzyaMBf6PM14jz+l6OUgyJAvI?=
 =?us-ascii?Q?YNwzWyrKlgMclXvFkBtWLruTyRaHxJhJ4z/BAz4XZR+AjSmtiLXg/65NhCpY?=
 =?us-ascii?Q?QHQmyypS5WyeDBPKaLObmpFX42oW9Z/mTJGUKgrx3Q8gf7PNKfV7F+cz96Ii?=
 =?us-ascii?Q?ntea5f9togz0uMmDTpjQQZjfFj/Z0GVa147D21AYDGdoJWZvq0xGd/Afiu3S?=
 =?us-ascii?Q?omXTKvXkBwBKre99/aC9UxIEa6rdqRy0VspR3BN9kAAJlHNMgsbSQ4Hx+jiM?=
 =?us-ascii?Q?Qq+SHJw6EY14WPCDpAf8lFjKVc0GXqNZtSZSj3CLoXWbmwaG/XJRXMDgbiAO?=
 =?us-ascii?Q?ndpIfOjDTzHr7DV7apZgu7Td3R5nm7E+F+GuBH0NY9GrQduVCeVb+dWI7NZU?=
 =?us-ascii?Q?1KARkc2EQ1oyQl9H/OqYpugV4OEO6/Jkm+gfFESFrRjBYSvux7vrn9wMdBAu?=
 =?us-ascii?Q?c+oA5S+uiyEdZF9THsSGTOYnykvNwNttQZoKV0uVHk3zk9fuLYa41Zw7/D1y?=
 =?us-ascii?Q?0ucd87ey4HNfAhmojq2ZH4qgiWm5xk0v81RqyCJMJoOd7WWS6l9sukl5/mmT?=
 =?us-ascii?Q?5InZs7CHEctzQQlRYwA+hEIiRF6ClGdTOJpUsY5fXjmEc+d8b6BWvCZl3hDC?=
 =?us-ascii?Q?Ky0aHQea7T7eGZAot6DVX4tcOT7I42DXVgAsDY57MaftgxfBilE/uMWCp3fl?=
 =?us-ascii?Q?+XXax5MuKL4U1WD6unspz6X/ni0DUvHOVvkRwakzQw/62V3g44u+ijvQhaVv?=
 =?us-ascii?Q?wAPFI2Y7LUBBPRKkOFPKOVWsNVdVjry+Rbelgj0dJixSdI9FHNGCe2mdypuG?=
 =?us-ascii?Q?wR1QYLKdM0maZyjngm7KK16bEpza+IkrvasmJ/458UNhPgeAc1QuizJgI0R2?=
 =?us-ascii?Q?Sk2V8wlr9dzAge68+IRHpW4DiEW/QLznDDM1MSPuk3yhXKvozw2PeU+9/1++?=
 =?us-ascii?Q?EHlmxpm+PuTn9GwMk2JbIX/Hx0ZVw7ZcSzP9oM9t7Nh8STET4VWohMY4uMs6?=
 =?us-ascii?Q?/DrHLKuozXfP8d/HpLo2m45zP70DKsGjDWYl8KCIHSGY2VRLhoNgJAWBkZBC?=
 =?us-ascii?Q?UtUulNvjgQ8G0vRCbR8Q01QoOpK/kX8U/dLsAmWMLFMpBqxZmFRnQvw6mAbc?=
 =?us-ascii?Q?ULwMrb7wEcBdISWGgfhV5yXTzd6KUvjJj1bC702EkUwBaGMRG2ESyyZZ7bdF?=
 =?us-ascii?Q?cYk7SZvQU30GsOKH0A1jcHtprTQI731CNjaX1X0fVMcbiNgDghuLWLoK250k?=
 =?us-ascii?Q?cj1DIEV1u3QvmGx9ESnehtcmMhO/qiwqXhCsx12Gpbo4oXJSdI7zPJNrApjO?=
 =?us-ascii?Q?NHBYHqQ0sRwyKyemLe31OW5DhQilv3X3codkk59eH818DxMO2q5a8qDWASLu?=
 =?us-ascii?Q?jLe45g6+WaWkIlvycqACAT4=3D?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 71650acd-9616-4ea9-208a-08d9ac1d3625
X-MS-Exchange-CrossTenant-AuthSource: DU0PR04MB9417.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2021 11:59:31.4905
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HXYQj8oaZVjEwBibT3bbJR5ent8pJFpr26CppN+s8EemwfkLZvlcE1FHV8GSW29jhwhHlfobi62ArgnNMXAnCg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR04MB9082
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Peng Fan <peng.fan@nxp.com>

Add ethernet node and its alias

Signed-off-by: Peng Fan <peng.fan@nxp.com>
---
 arch/arm64/boot/dts/freescale/imx8ulp.dtsi | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/arch/arm64/boot/dts/freescale/imx8ulp.dtsi b/arch/arm64/boot/dts/freescale/imx8ulp.dtsi
index edac63cf3668..e3c658b45ae6 100644
--- a/arch/arm64/boot/dts/freescale/imx8ulp.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8ulp.dtsi
@@ -16,6 +16,7 @@ / {
 	#size-cells = <2>;
 
 	aliases {
+		ethernet0 = &fec;
 		gpio0 = &gpiod;
 		gpio1 = &gpioe;
 		gpio2 = &gpiof;
@@ -365,6 +366,23 @@ usdhc2: mmc@298f0000 {
 				bus-width = <4>;
 				status = "disabled";
 			};
+
+			fec: ethernet@29950000 {
+				compatible = "fsl,imx8ulp-fec", "fsl,imx6ul-fec";
+				reg = <0x29950000 0x10000>;
+				interrupts = <GIC_SPI 107 IRQ_TYPE_LEVEL_HIGH>;
+				interrupt-names = "int0";
+				clocks = <&pcc4 IMX8ULP_CLK_ENET>,
+					 <&pcc4 IMX8ULP_CLK_ENET>,
+					 <&cgc1 IMX8ULP_CLK_ENET_TS_SEL>;
+				clock-names = "ipg", "ahb", "ptp";
+				assigned-clocks = <&cgc1 IMX8ULP_CLK_ENET_TS_SEL>;
+				assigned-clock-parents = <&sosc>;
+				assigned-clock-rates = <24000000>;
+				fsl,num-tx-queues = <1>;
+				fsl,num-rx-queues = <1>;
+				status = "disabled";
+			};
 		};
 
 		gpioe: gpio@2d000000 {
-- 
2.25.1

