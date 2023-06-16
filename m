Return-Path: <netdev+bounces-11462-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 131027332AD
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 15:56:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BC35B2817AD
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 13:56:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2885C19932;
	Fri, 16 Jun 2023 13:54:14 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 149A71C74A
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 13:54:14 +0000 (UTC)
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04on2065.outbound.protection.outlook.com [40.107.6.65])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 005F93A9D;
	Fri, 16 Jun 2023 06:54:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Fto04hu9QxKNymYdPMSS4EjXFuzYbkjDCS4lr4uRHSphMg4EU9hF3AAeRtyl+EhW8PLFQOnlIpbo0/K6hXoiYyo4guU0mBcbm8/DUsfawOqxXiMolyC/g65GHeyUtkETPeFnC46R14DXXuEL1aoPQJ0vIoQVzXiCK+0tZOcp/l80Xu/6DrPRzzfEEa6PjzH8Ap5Wet9eSpI60Y6NaXvAswTzwWFgFEJh+TCC/GE1W+xDdDyG/zj5JHpBziatR4yGxTZD855Snp7/A9mYtn+yZb2K3L7SGQ05jwlAcpIKTCkmg9gBvQKQcXkZyHJSQmXSMf3a8FWR7KaOncCJ57/Yrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OXYS/4aXVouZmHPwbC3/vxcfCxkGg958N5TJtGaGBPQ=;
 b=V0Bc4cvG6cb+DPSRY94dV3dcUpmcNFwewwNojPYjj3eKOvxMoiXqE7fqO2vXC87l6yMcAI7ZnzA3OVeJUbuSlz6dWeGhlSKXmf2QpnnoGw2vMJ2b5AJHSEpIUqf+wpT1UdyLJxoav9Wyd3c+RG6zlSM8hztd/c6rVXADS4htNhrhWtDyAtPEn30GRTiNbknJQ0qIsFdyNuC6UJdU7dQ0mmvV4EcjUBRn+2eq8zKEJ4tgNQ/5wrG3w+hRjQFcRNwbWjd06bI+dFCMwJSKwWFdMr1RxrOgqcrRMUFcQr0JUb8FKJrtU1bHkDqee1FoRS3OT4dProp8MvAKfRsNj4h3CQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OXYS/4aXVouZmHPwbC3/vxcfCxkGg958N5TJtGaGBPQ=;
 b=T3ke5OKtAaYrggITNvNzQFKt+87qCMtbEjppHcMzGUmdnkWTVmo1/j9dQfQz4bY9WoDgdU2NOAJcdyjjiMROteuu0aSnOlLuZw433x6zz7xO2B3OufQKda0ZCfN4j/OqLUmWVLItLasE0uTTvpyLWFMyWHDLmYuVld/ul9Jxu00=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from AM9PR04MB8954.eurprd04.prod.outlook.com (2603:10a6:20b:409::7)
 by PA4PR04MB9318.eurprd04.prod.outlook.com (2603:10a6:102:2a5::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.25; Fri, 16 Jun
 2023 13:54:02 +0000
Received: from AM9PR04MB8954.eurprd04.prod.outlook.com
 ([fe80::5356:c79f:ef9f:dc29]) by AM9PR04MB8954.eurprd04.prod.outlook.com
 ([fe80::5356:c79f:ef9f:dc29%4]) with mapi id 15.20.6500.029; Fri, 16 Jun 2023
 13:54:02 +0000
From: "Radu Pirea (NXP OSS)" <radu-nicolae.pirea@oss.nxp.com>
To: andrew@lunn.ch,
	hkallweit1@gmail.com,
	linux@armlinux.org.uk,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	richardcochran@gmail.com
Cc: netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	sebastian.tobuschat@nxp.com,
	"Radu Pirea (NXP OSS)" <radu-nicolae.pirea@oss.nxp.com>
Subject: [PATCH net-next v1 08/14] net: phy: nxp-c45-tja11xx: enable LTC sampling on both ext_ts edges
Date: Fri, 16 Jun 2023 16:53:17 +0300
Message-Id: <20230616135323.98215-9-radu-nicolae.pirea@oss.nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230616135323.98215-1-radu-nicolae.pirea@oss.nxp.com>
References: <20230616135323.98215-1-radu-nicolae.pirea@oss.nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR01CA0106.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:10e::47) To AM9PR04MB8954.eurprd04.prod.outlook.com
 (2603:10a6:20b:409::7)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM9PR04MB8954:EE_|PA4PR04MB9318:EE_
X-MS-Office365-Filtering-Correlation-Id: 4d36e20f-b062-4871-b3d8-08db6e712408
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	9DYDCF/wG9QwK136HPRLodvu5Qo8jMjPfsXfWdzcrzNEUKs04I5KrOoFHZ3HK1HUErTB9V7WcHnh1BxOk4k3PnfOZG3Bk6KTbbuOUFtmP0SgkNsCubU1JPy1OT0u77OB54SCg8ov3TZkwNCOeb68sfeltQKgzGIAlZha75pH1pJ+/Ul//HqEwW1d2sfHCg038zomDtEJJ20/Po7kSCp68GYyGg3iDKMZItwLFafVGFj9jwax6GjG/orvgXGRieyVTtyb9/mlKJyCkVJirbzYDJtCsQvoIDDRA6nZTX2EyWR0vQtsdUQFcPVcq59jslRJKdh2expWQFiVeCU2BgrV5NQj7pUHNBLs4ISoX3U6Nn4C/93trOP+kEgeklAQ+GnZep7rcmTyAJa+ncnKwuK0yg6A9ralKy6M7PMLutxGIKmuVd1Ylj3Hb9k81v7dGzV8Vl14t6HCU/T+gS0PFSR2ZaPhzCr3nlbz0Ag0O/Njqx9ndog0M4yGTy+BD+F1iP/5H9Be4AUX1UTtDUqUAZR2ew/8cJeiMADktSAZ33+V8VdaytTd95wNP9rYmSTjRUPUwCBJD/6mEBeJP8fgP1i8S1JM+SnLZu9s9uwVTCLUF+4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8954.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(396003)(366004)(346002)(136003)(376002)(451199021)(41300700001)(52116002)(86362001)(66556008)(66946007)(316002)(6486002)(8676002)(8936002)(6666004)(66476007)(4326008)(478600001)(7416002)(6512007)(5660300002)(26005)(83380400001)(6506007)(1076003)(2906002)(186003)(66574015)(38350700002)(2616005)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?irgD0be89quVjhHG1NTFXMrTnFv4iF2qSNPR7LpVX2YM007upwek/h4ZDR/O?=
 =?us-ascii?Q?Vf7IStSk/Gx6dfqo2UqU16gknWoTOye+j/XW739booStc+4glQJwbIJdLDQG?=
 =?us-ascii?Q?aPreD+XQTmWCf+3QLLyXCiozikqc0RO22juTTaFXq20A9D6iQjuaXXEeLlYD?=
 =?us-ascii?Q?HAga7R6aL5Vgu74woi5VdUq5cAJJ7OU1eiya1aWmWn3iemN5f8n1hrSK3V+D?=
 =?us-ascii?Q?9j5C07dcBQqWDUfDvCfuyjOahFTolOAsTdb0NM2zBfjko25JhsaFNOQRowvr?=
 =?us-ascii?Q?eVdhP50XK6x/tD/e7JHyIHa4lKP+wJcTlkWIk3KJ6xOap5WRVTaGWgLw12Rj?=
 =?us-ascii?Q?UHIKd0cXihZ0j7GyZPdrDc7Ov2UAg0wH0YkAWIqPfC7A/HDhfEuk9xP8cJUt?=
 =?us-ascii?Q?mOtIwSV5NxDDXfh4BYGBSAgo8jG+jTgBRPkNatPDrwU2CnFLW1sOQocupeiK?=
 =?us-ascii?Q?65/i3UdoIsDQfO9PVCq6F1DH5KNqHbMmwB1wwwFDWaREioMfLHwlq9+MkZQX?=
 =?us-ascii?Q?VoxEKUJVE5fSa1qFV2BCFmfCsXLM0LSbdXrF7DLS1JQcO0ryEWzc6mgXxizk?=
 =?us-ascii?Q?K8GkjQzNLlWFfqitFlXXUELHnzWBlQr4R6lCQDhOwPPemLClcPKmdBGh7VpU?=
 =?us-ascii?Q?lgkkN+ThN2xUgBzy7BFi6rQphWa2Aolu53rge4rn7qsxLfqplj743Arh2W0d?=
 =?us-ascii?Q?Lr9ju5yPTZkZ26fXf4Q6yl3zv0HW0gUI047Cu4zA8UIyImrdmELJ3oeUQdzI?=
 =?us-ascii?Q?78TO2wL1cFwcLcPlr89bfbw8mgpHjqdUmjGbEBmqPbv48z40ZF7+N6PnvsC/?=
 =?us-ascii?Q?8Y+qmighGt30gfGNlrSgtnP97PttPPG3/Ox8G9z2xNwR0bW0YPgBL2IJdRa4?=
 =?us-ascii?Q?Sk/VLQ4BCmEWr/nHH099BxJzdxa67m4+Z21vG9liqToLm+8JjILTTYpERXVv?=
 =?us-ascii?Q?sQq7Z6xoFkcjZozxNfhlxpetkEAW0Ax5YweztcW9yXhzWOwE2jBXUtA7FCSR?=
 =?us-ascii?Q?hA34BEiUZ2qtS6qNH58Jb9dfUV+gRep5yhfN/ptO3BbVPUSSmp5Vha3w6DJd?=
 =?us-ascii?Q?RraAKOp8bvyF4QmaKYQllRb6bdQl+C0iAdXelDGNTeqPks5Y1yQeEya5YSyW?=
 =?us-ascii?Q?bbdqaXf76VYUQ1IgLjfgXpvqP9vKxlvFmXyWYHdOqQsiyeVgFcCxK6LGBcCu?=
 =?us-ascii?Q?88DYzkaB384fzAmF/zq1JpNeGM5eCdfEIXaXujF5GT0uAOJzcECOAXsHWuTq?=
 =?us-ascii?Q?GCJK7wiNQO2r4nekugDdWrPZSoZWpX8YDP6pvKGIgFvwQvYI5K1ZoyDOBOr3?=
 =?us-ascii?Q?knra4Cd3UznmHg9Dxo+PP5Rw56uomAWUTArFVPrIuje3E6ECr1bLl6FUi0Zg?=
 =?us-ascii?Q?LNJG9z9pGPrz4TagIBS3zJv/IgB8iEPtqvm41FC80dfJQ5XNsBIJnIwJIdNH?=
 =?us-ascii?Q?rcOiOGyh2ie349iUdzQFbLufQRLeczTypj+JGAtr2/saAsEemScxeHPafRrH?=
 =?us-ascii?Q?EGJHWLlEhXQrW6ZbhBbe6INEKK2Mv+RVyHjeYhZ8ZA/9KAQmZ5l7n1h0S7JS?=
 =?us-ascii?Q?sYV3o9JCSfuUK6Em/ORHtlEvyphcw7LvE2oO/fEWThvYdwe2KqbEuDcEVn3R?=
 =?us-ascii?Q?2A=3D=3D?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d36e20f-b062-4871-b3d8-08db6e712408
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8954.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2023 13:54:01.9367
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LQ9tpus9boNLItpk4nmIrBLIa0cmH0RmKKPjuDX1rr/QjlKhWVHagleukNIGBy1vO9RSeufdn562cZVTw+rFGS0jxGsjQ6yOnsVrUkOiUUs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR04MB9318
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

The external trigger configuration for TJA1120 has changed. The PHY
supports sampling of the LTC on rising and on falling edge.

Signed-off-by: Radu Pirea (NXP OSS) <radu-nicolae.pirea@oss.nxp.com>
---
 drivers/net/phy/nxp-c45-tja11xx.c | 64 +++++++++++++++++++++++++++----
 1 file changed, 56 insertions(+), 8 deletions(-)

diff --git a/drivers/net/phy/nxp-c45-tja11xx.c b/drivers/net/phy/nxp-c45-tja11xx.c
index 2160b9f8940c..6aa738396daf 100644
--- a/drivers/net/phy/nxp-c45-tja11xx.c
+++ b/drivers/net/phy/nxp-c45-tja11xx.c
@@ -104,6 +104,10 @@
 #define VEND1_PTP_CONFIG		0x1102
 #define EXT_TRG_EDGE			BIT(1)
 
+#define TJA1120_SYNC_TRIG_FILTER	0x1010
+#define PTP_TRIG_RISE_TS		BIT(3)
+#define PTP_TRIG_FALLING_TS		BIT(2)
+
 #define CLK_RATE_ADJ_LD			BIT(15)
 #define CLK_RATE_ADJ_DIR		BIT(14)
 
@@ -240,6 +244,7 @@ struct nxp_c45_phy_data {
 	const struct nxp_c45_phy_stats *stats;
 	int n_stats;
 	u8 ptp_clk_period;
+	bool ext_ts_both_edges;
 	void (*counters_enable)(struct phy_device *phydev);
 	void (*ptp_init)(struct phy_device *phydev);
 	void (*ptp_enable)(struct phy_device *phydev, bool enable);
@@ -682,9 +687,52 @@ static int nxp_c45_perout_enable(struct nxp_c45_phy *priv,
 	return 0;
 }
 
+static void nxp_c45_set_rising_or_falling(struct phy_device *phydev,
+					  struct ptp_extts_request *extts)
+{
+	/* Some enable request has only the PTP_ENABLE_FEATURE flag set and in
+	 * this case external ts should be enabled on rising edge.
+	 */
+	if (extts->flags & PTP_RISING_EDGE ||
+	    extts->flags == PTP_ENABLE_FEATURE)
+		phy_clear_bits_mmd(phydev, MDIO_MMD_VEND1,
+				   VEND1_PTP_CONFIG, EXT_TRG_EDGE);
+
+	if (extts->flags & PTP_FALLING_EDGE)
+		phy_set_bits_mmd(phydev, MDIO_MMD_VEND1,
+				 VEND1_PTP_CONFIG, EXT_TRG_EDGE);
+}
+
+static void nxp_c45_set_rising_and_falling(struct phy_device *phydev,
+					   struct ptp_extts_request *extts)
+{
+	/* Some enable request has only the PTP_ENABLE_FEATURE flag set and in
+	 * this case external ts should be enabled on rising edge.
+	 */
+	if (extts->flags & PTP_RISING_EDGE ||
+	    extts->flags == PTP_ENABLE_FEATURE)
+		phy_set_bits_mmd(phydev, MDIO_MMD_VEND1,
+				 TJA1120_SYNC_TRIG_FILTER,
+				 PTP_TRIG_RISE_TS);
+	else
+		phy_clear_bits_mmd(phydev, MDIO_MMD_VEND1,
+				   TJA1120_SYNC_TRIG_FILTER,
+				   PTP_TRIG_RISE_TS);
+
+	if (extts->flags & PTP_FALLING_EDGE)
+		phy_set_bits_mmd(phydev, MDIO_MMD_VEND1,
+				 TJA1120_SYNC_TRIG_FILTER,
+				 PTP_TRIG_FALLING_TS);
+	else
+		phy_clear_bits_mmd(phydev, MDIO_MMD_VEND1,
+				   TJA1120_SYNC_TRIG_FILTER,
+				   PTP_TRIG_FALLING_TS);
+}
+
 static int nxp_c45_extts_enable(struct nxp_c45_phy *priv,
 				struct ptp_extts_request *extts, int on)
 {
+	const struct nxp_c45_phy_data *data = nxp_c45_get_data(priv->phydev);
 	int pin;
 
 	if (extts->flags & ~(PTP_ENABLE_FEATURE |
@@ -695,7 +743,8 @@ static int nxp_c45_extts_enable(struct nxp_c45_phy *priv,
 
 	/* Sampling on both edges is not supported */
 	if ((extts->flags & PTP_RISING_EDGE) &&
-	    (extts->flags & PTP_FALLING_EDGE))
+	    (extts->flags & PTP_FALLING_EDGE) &&
+	    !data->ext_ts_both_edges)
 		return -EOPNOTSUPP;
 
 	pin = ptp_find_pin(priv->ptp_clock, PTP_PF_EXTTS, extts->index);
@@ -709,13 +758,10 @@ static int nxp_c45_extts_enable(struct nxp_c45_phy *priv,
 		return 0;
 	}
 
-	if (extts->flags & PTP_RISING_EDGE)
-		phy_clear_bits_mmd(priv->phydev, MDIO_MMD_VEND1,
-				   VEND1_PTP_CONFIG, EXT_TRG_EDGE);
-
-	if (extts->flags & PTP_FALLING_EDGE)
-		phy_set_bits_mmd(priv->phydev, MDIO_MMD_VEND1,
-				 VEND1_PTP_CONFIG, EXT_TRG_EDGE);
+	if (data->ext_ts_both_edges)
+		nxp_c45_set_rising_and_falling(priv->phydev, extts);
+	else
+		nxp_c45_set_rising_or_falling(priv->phydev, extts);
 
 	nxp_c45_gpio_config(priv, pin, GPIO_EXTTS_OUT_CFG);
 	priv->extts = true;
@@ -1551,6 +1597,7 @@ static const struct nxp_c45_phy_data tja1103_phy_data = {
 	.stats = tja1103_hw_stats,
 	.n_stats = ARRAY_SIZE(tja1103_hw_stats),
 	.ptp_clk_period = PTP_CLK_PERIOD_100BT1,
+	.ext_ts_both_edges = false,
 	.counters_enable = tja1103_counters_enable,
 	.ptp_init = tja1103_ptp_init,
 	.ptp_enable = tja1103_ptp_enable,
@@ -1646,6 +1693,7 @@ static const struct nxp_c45_phy_data tja1120_phy_data = {
 	.stats = tja1120_hw_stats,
 	.n_stats = ARRAY_SIZE(tja1120_hw_stats),
 	.ptp_clk_period = PTP_CLK_PERIOD_1000BT1,
+	.ext_ts_both_edges = true,
 	.counters_enable = tja1120_counters_enable,
 	.ptp_init = tja1120_ptp_init,
 	.ptp_enable = tja1120_ptp_enable,
-- 
2.34.1


