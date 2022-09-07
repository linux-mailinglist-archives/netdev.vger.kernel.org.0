Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E69F85B0107
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 11:58:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230257AbiIGJ5x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 05:57:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229954AbiIGJ5n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 05:57:43 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2077.outbound.protection.outlook.com [40.107.20.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E22CFB516B;
        Wed,  7 Sep 2022 02:57:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fBNUCeu9jMUoylyuBfjPFnIUYPE4J5vC/rbYYh+LUIW145ZYG3SnYhNQR1kn7qXxueKbBLIq6VNZFHoC9ft8OQ15tr+FzYgoCY/DPB+j6k/tDqms/APf32atoK3WWJTAy+SzmF5YXghBvm1LGJBl4FEs4myIN1nGunCkSdwqrimZQyjWYKMHCHVCkN1E+EefNXnPPtXN9Xpo+wu4AyiuLVX1ku7qDl4VriiWokSzpaJ8Xqvvgcrvp+kR+9HwZE77GBniCmD7LaaqN2zdzzbW2SqRh/T1VQi9QUGIYL+YuB/LDhVdPFV4Ls9q98Jfj2pYVFZQojWpjAldpDjUYunISQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GIiWDGbgcDLLURPoC7PDdQ05ES5B8Pax/V9PO3f9dAE=;
 b=N6t6EoKU3GrjCDRn9GcCFL7UzSyLkRx/rTXiCGujFDomN0YGsU6s/eqTroh3Ptg0fIt8OtB8F60iKOQ048FNTjou3TV0LSNDFeOryyZeJQyPPUhBm4r2GDLJ4k+AaPGZzYdPeVUMeSlrG/1m+De19He8xJz3z1D9HjJ6m6Z3KK7boCzlCrSoKdaEDx5gZiFsb2tY50gFCI1q/zndYXt12ZM4Xlbj7Teis2JkDJBAIgC1AUvq3LUUvjiGUugC8ii2236m6JF77mC7DUfLhlmzqXeiqp51XQfc92JoOHiCrIbZKdasQedCUamdjviWGKAvBcJ3zHI0dx50yCrF/jic5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GIiWDGbgcDLLURPoC7PDdQ05ES5B8Pax/V9PO3f9dAE=;
 b=E64MPiAVfrAhLM6ByxxyLzIwbqzqQOwjPcEW+p1Ed7vgWbOILS1FzmiWcpsAznNUZ4O1J17MWkRbdQwTdZHlSJqWkDS4czGVUVkx3Cv8IhMBSr0Z9+4Yyilv7f8HZWKqD1Wkbixf8wHj6hj0lkNvMpSYbIKqf8c3Z/ETKM9tYYE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from DB9PR04MB8106.eurprd04.prod.outlook.com (2603:10a6:10:24b::13)
 by AS8PR04MB7688.eurprd04.prod.outlook.com (2603:10a6:20b:29d::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.14; Wed, 7 Sep
 2022 09:57:26 +0000
Received: from DB9PR04MB8106.eurprd04.prod.outlook.com
 ([fe80::4ba:5b1c:4830:113d]) by DB9PR04MB8106.eurprd04.prod.outlook.com
 ([fe80::4ba:5b1c:4830:113d%6]) with mapi id 15.20.5612.012; Wed, 7 Sep 2022
 09:57:25 +0000
From:   wei.fang@nxp.com
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 2/2] net: fec: Add initial s32v234 support
Date:   Wed,  7 Sep 2022 17:56:49 +0800
Message-Id: <20220907095649.3101484-3-wei.fang@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220907095649.3101484-1-wei.fang@nxp.com>
References: <20220907095649.3101484-1-wei.fang@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2P153CA0017.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:140::10) To DB9PR04MB8106.eurprd04.prod.outlook.com
 (2603:10a6:10:24b::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB9PR04MB8106:EE_|AS8PR04MB7688:EE_
X-MS-Office365-Filtering-Correlation-Id: 2bdd9c6c-e0ba-4ce0-f68a-08da90b75de5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UgE25VpWT0zZPKp1zjKCE7v7Fg8grFhqCq2lGxwSAj8+H6NOBFy7PzyqC1fmTxSHwCSEyl95NAti5feCTyXwjzwem/mDFpSMSH1GzPHM1AD6dewVCG6FFuhhqsOMkdSrHLIt6xYXGJ8NSd/dl0Mf0DW64Ijy2K0UfJ2oBhqLofYcTFivEXGGZm2kWZrxIxyBlvaTK5iu0W86CZ8n2mPeO9pdtZFZ2Wu41wAA5v4Y6OxFDtitwfTA76KOam+OEUQod9XmZbzF27WEUS3UIoTIdBOl46OIxZHhjvvu8BbCDwtD9mzoEhimVj1He5p56eHtiAi7Wh35KjOjHpnh+DXDuAKiBEg3+aR4vIQk4HZ9pTY1/l7LuOJvYC6xLsC/vh9AXotZuufmcaxl2D9jNSbw702wDei4QkEoDX1e7JZrULeWzdBg/qSFtSTVNrb9f98mHbj8jL1ftOROyCjh4LEXSPlIISA6uorANJlyMNtt78IP1V7uv0qxOyh+zUTja7DSTA8k7tmJX257KEDL5LBezhEYkVNLwWAHcRQbrnyxgzcyrEoQ9IZJnvdMP0cOx2A0TdWJ2xefky9cLv/gAQaKo/js11OgWBeq3O0fLbrcLmrFbo9Jk5VLrHsMcX0BafJQImnRGH1+QYZlcmi1ia2BMm8rlMf7UY21kkYYGpzfayZ70EMiDzdUndjCHJAMBFpcX/HAuQ8lrF8EYTu0RPQ0+3qTwWP00UEDz1FWLZGugENTXQo+Xb5p4kfzywWNI9LTCAaMpp180+cdLzdKUULTNTUIDI0s9U2BG1lTh9+OWgM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR04MB8106.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(39860400002)(136003)(376002)(346002)(366004)(5660300002)(8936002)(2906002)(36756003)(83380400001)(38350700002)(38100700002)(66946007)(8676002)(66476007)(66556008)(52116002)(6506007)(86362001)(478600001)(1076003)(186003)(2616005)(316002)(9686003)(84970400001)(6486002)(41300700001)(6666004)(26005)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?M+9Q33yudisyzBBmkStt3eI83RMtkb1z2/O91FtjYaquMs5WwO/6uS1d6s9w?=
 =?us-ascii?Q?Hc5gpEfEUVW4OntLwLDSyFEdrWg/lLAXi2jHKVZ4p34CJAsxUKKfEUrymXM+?=
 =?us-ascii?Q?2qniSqv4PRhcOHW54Mr9ABVEvwBMMIiDQKYG0mzNtNX6MXatSm7+5aWRc5ql?=
 =?us-ascii?Q?4H1sWwsakoeYVa2AYuifwgIJOeopTR4jnuMhBXnzp4nFa8+BN9e9HWRmwjzY?=
 =?us-ascii?Q?xk5AG/UcnPS0lqdLwcEbbwbJnkRXkLn7Lr1o+YOMD5ERn7mL9PEHAYn7w+ly?=
 =?us-ascii?Q?0xk893ifcCHoWEQbN0spT6NRdY7Q2cPROH/fsLwvlvq5yOrlpoVFOueJoGQs?=
 =?us-ascii?Q?uWynPHYHtydbRqdstHOvyAhOaHYjAaO7x5bFz2VDU56jFGMVWzzElzSfvBK5?=
 =?us-ascii?Q?PCs/LVF84RDSwF5l6wNg3cVwv1Tepab0XZlw3NRFRIxfMrogdhL9gfiZXy1E?=
 =?us-ascii?Q?zPi1o019qbn/lILhk/e5JhGRaw8Xp6Fpr4A9d//Ge6a0Pm7HYSygQw6ZgtQp?=
 =?us-ascii?Q?YdbB2f9WcbT7+8xgsr4Tgsfd9m5qGLwvMYZelfxEDlElW/IOddtuCJv9Pp1u?=
 =?us-ascii?Q?T9qFf9fA9tzmB7NxhlscoRfuBYUZvl5n2JWYZO3GdHWQNdz8BewOrOr4QwRQ?=
 =?us-ascii?Q?iMdAxJjDmJN9x8UKTjhHaybaNwzqU80g5f+hPxItksrmwJCK3icm12TSN0bM?=
 =?us-ascii?Q?MSgboNDFfzpQgM8NDf2Xibu53pre0lqipVdRmFG/2YgGr/lJjJeHkaCvcrf/?=
 =?us-ascii?Q?XeRn10zzQ8Lp9X/U85XFbtzX4Y96upIa/ReCiJ38enFynVfMr2V7RA7UJeNU?=
 =?us-ascii?Q?Em51aJXljEoZbw7u7JuUxi/SlwxZZ/hyPC48h4KfGxSfv5ynakGsBeAFJfay?=
 =?us-ascii?Q?oOCjOKKiaS2qK5GjKJJvlQBc+26tuKnWUVqvLEphs7x0AoqS6bB13M9/LpGN?=
 =?us-ascii?Q?1uCSNql790qUOPIggJVLMxcPWfafDg0h0/5SsUGcc/DVRUveZqgLzH0fpLzS?=
 =?us-ascii?Q?5agnTrGMMD3pdKpStpWCn9HL9mV2+esoMpKQEnMv1rYU1WWoZDSaTmzRlFvY?=
 =?us-ascii?Q?cWzAdh/ArID4Wz9otMlNZqI7xjfu5habM6+nGK24sZ0WHQP3lKqzPuzMkXio?=
 =?us-ascii?Q?U4NY/Q5JESXdRUAKmlAyY+xuqvCL5TABCJx4gvsct0ReyevWSOq7KHZ8Ow4s?=
 =?us-ascii?Q?mqeDYOMBu987rh4ceauRRaxwEyZAMVBaDXd4h4AaUu6ar4Rx6cVFDH4dcG5W?=
 =?us-ascii?Q?24kulMXdQ+9KaV+5rKqgNk9/fNK5YG67B+///jd27UjMuM+iICW3cbjSvypk?=
 =?us-ascii?Q?vwvyQQdQv1sk202un7yaDZFjTAVb598BZPKglE9BrJbkFQKi5/Oh9ZOiQIOh?=
 =?us-ascii?Q?r+raiM4ER1rYxqof31qQbtVlumDSMG0KHC2H2FO+MC67SgbQoVWsWHT/ipsZ?=
 =?us-ascii?Q?ylzbaDfV7Qpx5Aul2/L9EgtpZLYQKPtvT9iGoj3SPEjzJgi6lHrVFufoemtL?=
 =?us-ascii?Q?CvBqDBn8thrYFK1i4ggpO5hKrbVRk6ll4qEFpTNnv6IUjA2pNKw9rXu6E/lJ?=
 =?us-ascii?Q?NvFns8eYZ6D8bN0YV+ezBtq0MuV07KM8oj2WxqER?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2bdd9c6c-e0ba-4ce0-f68a-08da90b75de5
X-MS-Exchange-CrossTenant-AuthSource: DB9PR04MB8106.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2022 09:57:25.8081
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /Rv1bFa+PwAjsHvg2Wq4CSYTVd97o+Yg8NKNvvlWjAEQb7yNXySTyd02joCr8p2oA/YiQZbXTD4a3wyra6VqOQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB7688
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wei Fang <wei.fang@nxp.com>

Update Kconfig to also check for ARCH_S32.
Add compatible string and quirks for fsl,s32v234

Signed-off-by: Wei Fang <wei.fang@nxp.com>
---
 drivers/net/ethernet/freescale/Kconfig    |  6 +++---
 drivers/net/ethernet/freescale/fec_main.c | 12 ++++++++++++
 2 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/freescale/Kconfig b/drivers/net/ethernet/freescale/Kconfig
index e04e1c5cb013..b7bf45cec29d 100644
--- a/drivers/net/ethernet/freescale/Kconfig
+++ b/drivers/net/ethernet/freescale/Kconfig
@@ -9,7 +9,7 @@ config NET_VENDOR_FREESCALE
 	depends on FSL_SOC || QUICC_ENGINE || CPM1 || CPM2 || PPC_MPC512x || \
 		   M523x || M527x || M5272 || M528x || M520x || M532x || \
 		   ARCH_MXC || ARCH_MXS || (PPC_MPC52xx && PPC_BESTCOMM) || \
-		   ARCH_LAYERSCAPE || COMPILE_TEST
+		   ARCH_LAYERSCAPE || ARCH_S32 || COMPILE_TEST
 	help
 	  If you have a network (Ethernet) card belonging to this class, say Y.
 
@@ -23,7 +23,7 @@ if NET_VENDOR_FREESCALE
 config FEC
 	tristate "FEC ethernet controller (of ColdFire and some i.MX CPUs)"
 	depends on (M523x || M527x || M5272 || M528x || M520x || M532x || \
-		   ARCH_MXC || SOC_IMX28 || COMPILE_TEST)
+		   ARCH_MXC || ARCH_S32 || SOC_IMX28 || COMPILE_TEST)
 	default ARCH_MXC || SOC_IMX28 if ARM
 	depends on PTP_1588_CLOCK_OPTIONAL
 	select CRC32
@@ -31,7 +31,7 @@ config FEC
 	imply NET_SELFTESTS
 	help
 	  Say Y here if you want to use the built-in 10/100 Fast ethernet
-	  controller on some Motorola ColdFire and Freescale i.MX processors.
+	  controller on some Motorola ColdFire and Freescale i.MX/S32 processors.
 
 config FEC_MPC52xx
 	tristate "FEC MPC52xx driver"
diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 8ba8eb340b92..705348879b0c 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -155,6 +155,13 @@ static const struct fec_devinfo fec_imx8qm_info = {
 		  FEC_QUIRK_DELAYED_CLKS_SUPPORT,
 };
 
+static const struct fec_devinfo fec_s32v234_info = {
+	.quirks = FEC_QUIRK_ENET_MAC | FEC_QUIRK_HAS_GBIT |
+		  FEC_QUIRK_HAS_BUFDESC_EX | FEC_QUIRK_HAS_CSUM |
+		  FEC_QUIRK_HAS_VLAN | FEC_QUIRK_HAS_AVB |
+		  FEC_QUIRK_ERR007885 | FEC_QUIRK_BUG_CAPTURE,
+};
+
 static struct platform_device_id fec_devtype[] = {
 	{
 		/* keep it for coldfire */
@@ -187,6 +194,9 @@ static struct platform_device_id fec_devtype[] = {
 	}, {
 		.name = "imx8qm-fec",
 		.driver_data = (kernel_ulong_t)&fec_imx8qm_info,
+	}, {
+		.name = "s32v234-fec",
+		.driver_data = (kernel_ulong_t)&fec_s32v234_info,
 	}, {
 		/* sentinel */
 	}
@@ -203,6 +213,7 @@ enum imx_fec_type {
 	IMX6UL_FEC,
 	IMX8MQ_FEC,
 	IMX8QM_FEC,
+	S32V234_FEC,
 };
 
 static const struct of_device_id fec_dt_ids[] = {
@@ -215,6 +226,7 @@ static const struct of_device_id fec_dt_ids[] = {
 	{ .compatible = "fsl,imx6ul-fec", .data = &fec_devtype[IMX6UL_FEC], },
 	{ .compatible = "fsl,imx8mq-fec", .data = &fec_devtype[IMX8MQ_FEC], },
 	{ .compatible = "fsl,imx8qm-fec", .data = &fec_devtype[IMX8QM_FEC], },
+	{ .compatible = "fsl,s32v234-fec", .data = &fec_devtype[S32V234_FEC], },
 	{ /* sentinel */ }
 };
 MODULE_DEVICE_TABLE(of, fec_dt_ids);
-- 
2.25.1

