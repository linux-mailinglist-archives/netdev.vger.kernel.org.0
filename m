Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E791564B8D
	for <lists+netdev@lfdr.de>; Mon,  4 Jul 2022 04:17:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231784AbiGDCQM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Jul 2022 22:16:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231682AbiGDCQG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Jul 2022 22:16:06 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80077.outbound.protection.outlook.com [40.107.8.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9ED83654E;
        Sun,  3 Jul 2022 19:15:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QhqYQUFbu7szfTEYyPadgxMzG/oRDxF57QWpOWZCawvNIFeVJZ2baL9SwvBvvrQ4LvUrAdADSbBwcAY6Q8d2C6TB8XY8meZitRs5uvENVVl80XbrV+dUag3x88LwHwZJnUTfyKQKnHF2cCAgTQKghrqc2yNq3+fJBi3i+S+x0R7VSas/sAc/ixRqOOtdAP/tk7/1jV55qAM44n9HTNO/uZn6+VfHH3hCB/FNaKsVmNkDmn4a16qoLqATPpi05KMcpv/yqCZZnjRI5BAv8vUOGBB/8lEoltaW0h4M7IgVTZJ/kkG5FKGfxVvOGvdxkstvAnS7+u6OccZmUjOBK9HiAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MRjUPuQ/dp5YzD6r/+C/YeEkN7+iFBX3Lox/ssam+QA=;
 b=kiG9dUlVhrbonhQDVVRjynR3F82SdOqvziSfLQvS5BitTOduV9dG/XNozUNtdDkH8hXX0j5G2uKmSFeS4yU47+GL0uTktI4xojHU6sum9vlmgnkJ4jjJlSoMkXBOcQxADY+3TXXMF/OV5AtDXnD/7jUK2c8CwtvJVrwRuEzPLBlnAR5hDt8AqYpzOtsspQTmPRaDGDlc+tBj/bOpnBQLWkiaaE0iTRZk9nDA0llRrOejZTKVUW9yLM9yIhbqtwT29FMk0mEyTVdN02Q4cjJ393ojPLHH+g5g1Ryi8TSeRqld/rvcgLHYeGMC22P68RRj6nEJPwQoH7R836Sfv3RSdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MRjUPuQ/dp5YzD6r/+C/YeEkN7+iFBX3Lox/ssam+QA=;
 b=TrXJDvtYPuDEAqAn/C5bWWkdIjoZwh8p0vcNRUhFr/96N/nxFJn2y4Yn4mwS/BqdD+Bb/YC+by0tAm8ztH98aVUp+SyIR6SCzH7Oi3AQ8mBvAsYNvPNOt5dgEPdg95Jo8iC7vel2p1W/AlopwBBdPwUwnlzkXYwLFOZ+pgSyAiQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM9PR04MB9003.eurprd04.prod.outlook.com (2603:10a6:20b:40a::9)
 by AM0PR04MB6819.eurprd04.prod.outlook.com (2603:10a6:208:17f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.20; Mon, 4 Jul
 2022 02:15:56 +0000
Received: from AM9PR04MB9003.eurprd04.prod.outlook.com
 ([fe80::b00b:10eb:e562:4654]) by AM9PR04MB9003.eurprd04.prod.outlook.com
 ([fe80::b00b:10eb:e562:4654%8]) with mapi id 15.20.5395.020; Mon, 4 Jul 2022
 02:15:56 +0000
From:   Wei Fang <wei.fang@nxp.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, shawnguo@kernel.org,
        s.hauer@pengutronix.de
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel@pengutronix.de,
        festevam@gmail.com, linux-imx@nxp.com, peng.fan@nxp.com,
        ping.bai@nxp.com, sudeep.holla@arm.com,
        linux-arm-kernel@lists.infradead.org, aisheng.dong@nxp.com
Subject: [PATCH 3/3] arm64: dts: imx8ulp-evk: Add the fec support
Date:   Mon,  4 Jul 2022 20:10:56 +1000
Message-Id: <20220704101056.24821-4-wei.fang@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220704101056.24821-1-wei.fang@nxp.com>
References: <20220704101056.24821-1-wei.fang@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR01CA0155.apcprd01.prod.exchangelabs.com
 (2603:1096:4:8f::35) To AM9PR04MB9003.eurprd04.prod.outlook.com
 (2603:10a6:20b:40a::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a111651b-116c-41a4-5847-08da5d6320f6
X-MS-TrafficTypeDiagnostic: AM0PR04MB6819:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TX5OIeZNcC4Jl5hqHmfLkGqStalN/8c6g3fGQ66527b7kxWcGVBVhN7DbyVbUFU8MWD1k4MYyO1zn/kc8KHW2DwjrFpGF4e7FMUu03WyIsYKKOT6QNNcawQs/XSulxvA6tqP3hiE7Xk99asotHdT6TuWB15bxmxjf3K1v68LToMSqqvM/DgoF1joUJ1K5pVWIiJAZY7c9BqFK9XYpaaEgEjdBxvG4N1J25gSOim0ctB0zqVHDP+Rchyl/d1YsBvrD7yFmUGMrBQnP+EaO7khYEPzuFCec55hhIHykBKZSDaT5h/E26Rqu2/eDFVmNNB5webonGRuFDhpkCLRwRyw2EBVHbsqqY3E8ubnH+O4BXxwxKc34VA0Y13uO6P8mSQwzgDN0JVh8yTv7UvWrs2fd2iHl6atx7PcxP5HxpVqDg4+QKW/YFXu9xgUAmGXQqFMqZmbMvumv8wTztQ9tYwczFDOb0Qg+NiAcHsirKJ3NDWe/s+K/5kM2gWHThd6SPzM7f+PWDYExTz9Z9g1vkrCyFXZM7gb6GBZzUDLFrEnZrln4pY2WWgIUfqu9lRCm7Gm+KJvj6OW+Ca9JyVt8Kx2L0Tp0Zhxte/n8BdJYndx/DmBeJxMk6PR8XVd1B3HoiQ6XUXETBbTcV1RwJNpbMrVgS55cxj36qf6P7LP0GtcGj95pDjAhXsLOMzH5GsxtBXT6tzJBxbkrKVoQnS5RD184Gn3gdUuKUGzXCAjxq/DNA3w6cAGCuFFfkf3Lnjp9Pb7smrrrV84xNRS6rRPHdqK/Fb0IY6p7DxZqIM3rACPTcOj3Ben3MpqeMjHfuTVdj5YaBRZJvG+WFO8pSk7Pj9Ydw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB9003.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(39860400002)(366004)(396003)(136003)(376002)(6486002)(478600001)(6512007)(44832011)(2906002)(66476007)(52116002)(26005)(66946007)(316002)(6506007)(5660300002)(66556008)(7416002)(36756003)(86362001)(8936002)(2616005)(8676002)(4326008)(1076003)(186003)(83380400001)(38350700002)(38100700002)(41300700001)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/cqzC7euZuod34UoTilYhBHIJ/ee3viJufdKR75D95dl2p0AIMghasjZM+mu?=
 =?us-ascii?Q?vXPDRROFRiRDG+xggRmveDdhHCEn96K0BiPOlrax2cHe1052c2F3AZZmBR7c?=
 =?us-ascii?Q?vipFXOVHMvNCL7xDga08wzysrlrEblflO+iysM4XdAUSjKPXa86x3X42ZCUg?=
 =?us-ascii?Q?FF9avCItSW9iiJNJDj4FfkMsq6CwkpPQ1vSrVvVE/Tq1VrxSkrmMbheuQ2DH?=
 =?us-ascii?Q?L78ifG1c27PKkX4FVrQQcRCvg9arqwyDjcsoRz3J5puC3HXnh9zQJyXcYrAH?=
 =?us-ascii?Q?nOWbh9bQN/aZi2FZukpsPtlr8PR4eSucHoxdiGEqoooi4FacnUKMh0bN2brE?=
 =?us-ascii?Q?L4gx5U7NYg3v/mY7FDc45u5daKg0q2YTd6nydLMiZGWyuuayBuLxZnQvoOMY?=
 =?us-ascii?Q?YavSPrIZiH/3+ltXCF56Upqn8UczGnoi/z9LQUPf+XeHGTDevFkc2ZZW6FsV?=
 =?us-ascii?Q?en/vHg7g2boMN0GJyBYrdqufGb7PZQi3+bkhozOLTzPmzQwJTXKfIUQmfx7i?=
 =?us-ascii?Q?Ibbl+vLlY0fdSfwR667cc97i0+ZqL0lqSEx3bPzTu++J9tbyXABVQ2r7TmV5?=
 =?us-ascii?Q?xEdw2ENoAU39aZfNDcS6mokgBVFyqVrkMYksYb1tydwZUvVf6HkDtY8SzaXA?=
 =?us-ascii?Q?aOqpM4peE1fDmgwVKDDUc7pLdWSUVz047Sl/M8bV7Bzlk59I1G4mrRBXvUFz?=
 =?us-ascii?Q?ikWZnyjnxqLa/QTyBPN0tLWgv6K8YJ8lzJEuqMfqbrG9GaCFvpvo+UsCqGgl?=
 =?us-ascii?Q?8vSPKTsH04kUSHebwgXeByOOgRyAtTJSYp6DniBRVjnpAxD7i6FotSEDikqT?=
 =?us-ascii?Q?USnmZ7StmWAiUuyunvMvo5JvJn4gAHPp3a9kSU9Z/FNtJ+dEC+WDiABVVuNQ?=
 =?us-ascii?Q?Yu/9rc4CTQNZJ6+0zxmXHqh+IW3nm3XNHaO5H8FKnLQ2POTIPLcAfMHykdZl?=
 =?us-ascii?Q?aM0MxvKxhf3RpJSBaYAtIE4klaqzv/fAb1YawL0F+i9wnog0JYXid8ItnsFt?=
 =?us-ascii?Q?hlWwdim8EPaoWPIVSeBUoBUcxYi7c6QFiO2p1BnMyODgFnx1HE0WSH7HI725?=
 =?us-ascii?Q?z2yibZQo32rWUMTzgJH3xSJpTMSH89TDN9Idz40J6JdgKHxKwyaoXOuZ6G0F?=
 =?us-ascii?Q?A3iJd5UrUSaICm4343/NIBnb2yhgc0wJW6HE9zBttDL8W+D5YZtPkAOc+PPN?=
 =?us-ascii?Q?6dM57SqsDPLQaIctVOiHaUyQ8mq0mTJ1+B1MI6ERSNFdR2dbrAZbrurp+HOG?=
 =?us-ascii?Q?266IV0v1XiZzqkpAeaXv0i02XQ+Cf7/xfCixEO4Hq2FQNaYErYpd3SlWqD6E?=
 =?us-ascii?Q?SQV2lUfDZEDX6BNZTUO8/8rwy4Cpi/lEs46F28zSuYAl1wMwW+ZJSjrUhuA4?=
 =?us-ascii?Q?vM3rBDYZgfszi5dije1wgTjhFS21iUe+0Bm4Zx4h1uLGnqgC3a0o8Vmgo/PK?=
 =?us-ascii?Q?4CTJMCjeFijXkluNZslem/zT0Lof2OHhy8AwWt4zUM900sOm5/upgoFGW4lC?=
 =?us-ascii?Q?oY2Eum9bbcQQB7as/KKvKHQe7SlRe+7FkJLaKbArg1VXFDM1kVUco5pyX17o?=
 =?us-ascii?Q?7e5uA3moHKYXN25JIukSlm7ovfIulj6X+OWxGdEh?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a111651b-116c-41a4-5847-08da5d6320f6
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB9003.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jul 2022 02:15:56.4538
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Fu3ZxJMFLhinoajs0TOMIFJzgOKEn4CvvRlQzRRQuDC/yRUXIlDSufgpC8puCocg/u3FsspV6HZWYh4FgoGUww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6819
X-Spam-Status: No, score=-0.2 required=5.0 tests=BAYES_00,DATE_IN_FUTURE_06_12,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Enable the fec on i.MX8ULP EVK board.

Signed-off-by: Wei Fang <wei.fang@nxp.com>
---
 arch/arm64/boot/dts/freescale/imx8ulp-evk.dts | 42 +++++++++++++++++++
 1 file changed, 42 insertions(+)

diff --git a/arch/arm64/boot/dts/freescale/imx8ulp-evk.dts b/arch/arm64/boot/dts/freescale/imx8ulp-evk.dts
index 33e84c4e9ed8..ac635022ab45 100644
--- a/arch/arm64/boot/dts/freescale/imx8ulp-evk.dts
+++ b/arch/arm64/boot/dts/freescale/imx8ulp-evk.dts
@@ -38,7 +38,49 @@ &usdhc0 {
 	status = "okay";
 };
 
+&clock_ext_ts {
+	/* External ts clock is 50MHZ from PHY on EVK board. */
+	clock-frequency = <50000000>;
+};
+
+&fec {
+	pinctrl-names = "default", "sleep";
+	pinctrl-0 = <&pinctrl_enet>;
+	pinctrl-1 = <&pinctrl_enet>;
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

