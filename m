Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57EA7369254
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 14:43:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242226AbhDWMoX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 08:44:23 -0400
Received: from mail-vi1eur05on2084.outbound.protection.outlook.com ([40.107.21.84]:3841
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229479AbhDWMoW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Apr 2021 08:44:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CPSB6tPwBrWYMFLsmcMR2PhLHuWIFmFX6sCp08P/Q+uVXeld4w9QmDER6AkwU8J9aWhuyVOB03QUGvPc7yTVXheOZlhfpjcgdZ8KyBBB/WcxA07e1k5lh/RButD90EjSYJITm00KBf3WykalFUGkKN4xg6gVV7uBaWKMoqWevYYVjjY3oLozwmu0r9mITo55n5gU4I0bn0Bu+Gu7Y4eiNWvwRV7qOwj8GmOC6co0+fnx5IBh8BCfuLDQALpCArO4cy+vWH79Cr5IT2Fhq4MtY2GlJoxHHQN4GAUxEQpIrfkTztuKPulR5P9R2jMGzwk/dcRC9yteyvthjA2mGNY/nQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pnhHMNnWM/dJd4UCCmMUwa1b4CIspvURoDJAUpotEvk=;
 b=LwkEU+muj3Nj+XaSRxZi8Zq7WeLPl1GVJZQ4dO46KWrp5OPUqtMoGZA2irbEx7zCIBguwd/eBX3Cfyty6MvCM+0NFiGWEagZ+uto9tF05cDfxWNYj+t7WNjhtOqR+Hw0V4ZdqALzPIJmd43qrse74O4Mg3e6GJkLfb+WI9rTuGIbL4QIvVbrmDl109nvMnop8mtFxKiUO+SgjtinZ50fIvBpXmkhNKqbBUfs/ar2Mxt7Yu1Pq/mSIa3Hx8oRgKMaID0F7Lk1gmAqnV1hzania24oztZ1xYddF6ipT+OI6D+T72Ln93p3wEXDzd+MFV00qOYmcXHbzy6N2iFdZ1EHPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pnhHMNnWM/dJd4UCCmMUwa1b4CIspvURoDJAUpotEvk=;
 b=NcOPnNWs6LP/jEJH3jq3gGO9KNsZcWNHuJhRYTU+t8bNmJRKNTkr6exZZA8Xuf35l91KIJHSAxnjjfLjdtjDFYWYB5eub14ZI3QIZ41jqA358/twMyHhaS054DhdVpI1LG5zWg7GgxNWCRDbIf0yFlxna6sXGL91q7gJeW7KQu4=
Authentication-Results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=oss.nxp.com;
Received: from VI1PR04MB5101.eurprd04.prod.outlook.com (2603:10a6:803:5f::31)
 by VI1PR04MB4509.eurprd04.prod.outlook.com (2603:10a6:803:6e::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.21; Fri, 23 Apr
 2021 12:43:43 +0000
Received: from VI1PR04MB5101.eurprd04.prod.outlook.com
 ([fe80::1d18:6e9:995c:1945]) by VI1PR04MB5101.eurprd04.prod.outlook.com
 ([fe80::1d18:6e9:995c:1945%6]) with mapi id 15.20.4042.024; Fri, 23 Apr 2021
 12:43:43 +0000
From:   "Radu Pirea (NXP OSS)" <radu-nicolae.pirea@oss.nxp.com>
To:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Radu Pirea (NXP OSS)" <radu-nicolae.pirea@oss.nxp.com>
Subject: [PATCH] phy: nxp-c45-tja11xx: add interrupt support
Date:   Fri, 23 Apr 2021 15:43:29 +0300
Message-Id: <20210423124329.993850-1-radu-nicolae.pirea@oss.nxp.com>
X-Mailer: git-send-email 2.31.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [89.45.21.213]
X-ClientProxiedBy: AM0PR10CA0058.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:150::38) To VI1PR04MB5101.eurprd04.prod.outlook.com
 (2603:10a6:803:5f::31)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (89.45.21.213) by AM0PR10CA0058.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:150::38) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.20 via Frontend Transport; Fri, 23 Apr 2021 12:43:42 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b641c622-5f87-4406-6b48-08d906556da3
X-MS-TrafficTypeDiagnostic: VI1PR04MB4509:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB4509BB15E4F7B577EDE932D89F459@VI1PR04MB4509.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:124;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mc3N+7jliP6k39yq8NwPGVv1bySIi/YeNGzHxUPzSk3yRT4DmTR+zVTEzy3sdJu40QsWzmXbWdHh0KuMfTppkeGbhFf/k24Qre1voLvRBh/S186snFeCzADWkWFTAgyWcqJh3oANEx1j+06u4W5od6YTxTPzvCK4pdkeR6QWmHItmtZgM9g5L2aFzNmsZCLks5XO9MyAVp3eHy95fKev14Mhv7yDTG1v31RLS7KCG9XpwQ1OIhurVKRJAIVBos2fUMK9QS02ETHE8rqEYk63ikWrAGJnK9ybA9TWUAbBzpdO7Rbk0Xo0YJ2GKtU1187GvYQwRzZuMfm01pzmnSFVdXAcrPPu29934LgR4m0pdYQoob8o+sXdKK5RdzqfK5DJWs+f8k5evqoJ1p1ptFgL7msvPi3kj9GDWH1Jv17Qxz/qnx1NFVPWLtA00aCQMcOkzPxZxPZnWkoLKT3/8kqDHwIa9gGQODTT3bfAikw0HOa973cBcaNdRhXFxGnlYZi7jhP4JbzD/wsrhoY6McUVWqmvMJytLGvEmIcVbLjnzZoUY0h6NAm+iEkkj1KiWK3i1m7nK2hfUdg6Xxh3dweSg2CNeKBh2VTeXFF3FFBABuJI1XsNR6vTiajLF++GDUQKPDjwJl+JldjK7+14LSJAfEdaHVAoyo75DjIwVSFRD2fVmFGuzs2O4W0ZhyO2CAkHwo/k71R3iwnO7L3REE1fcw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5101.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(39860400002)(396003)(366004)(136003)(2616005)(186003)(6666004)(1076003)(16526019)(26005)(86362001)(38350700002)(956004)(38100700002)(5660300002)(6512007)(2906002)(66946007)(478600001)(6506007)(316002)(83380400001)(8676002)(4326008)(6486002)(8936002)(66476007)(52116002)(66556008)(69590400013)(41350200001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?Bysu/po9Hdr9F30LeNBQeIctoMqabngDpczaut8ixE4q06QNMsxJAbGouFSf?=
 =?us-ascii?Q?8qosT8x8h8WfXp67iKIZ46FzJ3kRXy6CvQswRhxc05eE1qhmdAKMxKnOhUyz?=
 =?us-ascii?Q?8IyyRF7lzvH3PqY8iU0R6Z7oxIdmNWz3LSukVwViT06lM8qnURM8mb41+yBK?=
 =?us-ascii?Q?oHyrzJZMYwTC2wzTzfjtN8ax+61Fernzp7PHqLn2Kxuur/5b3y9PcMUtMwDF?=
 =?us-ascii?Q?8co9qBbQQX8y0ZtVX0OTPSsFCD4+rFiGo/yDsvHBZS4IyFm3MIMI78hJxsUm?=
 =?us-ascii?Q?E4bqqtGrhRpTSYKsUscZ3u2CQkLnYdgHUNtd+yNWwTW8HfH/Em4UsLwIWa1w?=
 =?us-ascii?Q?wtq2uvMNKjMhMa9XxOkkkZIYbPUj3LUaT+oeC+vn0VobRVwUeU5Zowq1aYaR?=
 =?us-ascii?Q?5yX9uMggw//3/PIJnPrUmb60mXjEgNvH/jQ26ycAZcmHS8DT5nkq6tUi+dAH?=
 =?us-ascii?Q?Dw/NLQNViheLRG2ug6uN4nGi9fd4XcvNS/tn4Rd+ITiyOROMoN779n7s9NBZ?=
 =?us-ascii?Q?dHPMl4TcUpnxl/E03DE0DmJJkChwjoiOGPT/vhdY0AYQgc8bO5Fy2zfSNPJE?=
 =?us-ascii?Q?JClpxzqUDd8Ff0Ah571ehK4jYjn7sJcvf6ttKPC5G3vTBxI2nlkB7SsNFf8i?=
 =?us-ascii?Q?E2D5UVfUR6lIK+ptI8BWnwHEyJirCR8eK6M6EKPuwYHB9dCyjd+fQoDNLjzr?=
 =?us-ascii?Q?lMAQthZSNTJRZ7OVI6V6QserxeL+dBnCA0t6ncsPW8izWveS4qZ6MopJZ3PO?=
 =?us-ascii?Q?nX1HLS7yYTXLhLWDDpq7iKGYwBTz2wCTB3t2HLVsmtYDpUOjPa/pDqB9+aho?=
 =?us-ascii?Q?yBY19d71UDY08bsvgf71ZEMkanAhpynDFfxh+m1EGo4vBZI/bGbDjK/hUYuw?=
 =?us-ascii?Q?cDUucYhvrYQWl02czKxqEm51Jeu/BYmmpgcxptCA+idZwKqBIdygida+Wnh6?=
 =?us-ascii?Q?dcrcvfu7Hho54stX4kOtE2CP+cl/UhXanqm1F43OUfbPlToVknvBS6faj9Xz?=
 =?us-ascii?Q?Uya+MpTr8RfIheUnfvmiqZekozdcQ2a69tWd3w+xgfphnwqR37KbRoa6jJ9I?=
 =?us-ascii?Q?EFkbZ2JiYaxeAbw7Ashb689Avh6kW7x8fqQj5UtKHqYjFY+eL9+YHGZsm2HE?=
 =?us-ascii?Q?7lq0ePwCZWquIEHxjMDc+Ga5UOwu8mAGU9Mqg3noE2iYL16s2mRHEXREnNsV?=
 =?us-ascii?Q?kcuLFt8jXB95gC1pTCDpL4UgNjSAnB0rw7UNpDunjhLaihuu3Nbn4+vpjfY0?=
 =?us-ascii?Q?G0URlBz45WG41FyHgq7BOwIc7s4r8UsFey/ahDMJUDdG+zo0xz+Rva0dp+8z?=
 =?us-ascii?Q?78NMbuNrKZTV0ELkhS/0JUzb?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b641c622-5f87-4406-6b48-08d906556da3
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5101.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2021 12:43:43.2358
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Py4tVd6CFLVZrpOGRAvE6Pi9QV7Uz0LneJ5z+/3AZXlK5NaGievcN0RlJX+JnMCbgPAiqwDVLlmGAwjb++3JfetIIAd6hOggTNlCryVwcI8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4509
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Added .config_intr and .handle_interrupt callbacks.

Link event interrupt will trigger an interrupt every time when the link
goes up or down.

Signed-off-by: Radu Pirea (NXP OSS) <radu-nicolae.pirea@oss.nxp.com>
---
 drivers/net/phy/nxp-c45-tja11xx.c | 33 +++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/drivers/net/phy/nxp-c45-tja11xx.c b/drivers/net/phy/nxp-c45-tja11xx.c
index 95307097ebff..54eb74e46cbe 100644
--- a/drivers/net/phy/nxp-c45-tja11xx.c
+++ b/drivers/net/phy/nxp-c45-tja11xx.c
@@ -28,6 +28,11 @@
 #define DEVICE_CONTROL_CONFIG_GLOBAL_EN	BIT(14)
 #define DEVICE_CONTROL_CONFIG_ALL_EN	BIT(13)
 
+#define VEND1_PHY_IRQ_ACK		0x80A0
+#define VEND1_PHY_IRQ_EN		0x80A1
+#define VEND1_PHY_IRQ_STATUS		0x80A2
+#define PHY_IRQ_LINK_EVENT		BIT(1)
+
 #define VEND1_PHY_CONTROL		0x8100
 #define PHY_CONFIG_EN			BIT(14)
 #define PHY_START_OP			BIT(0)
@@ -188,6 +193,32 @@ static int nxp_c45_start_op(struct phy_device *phydev)
 				PHY_START_OP);
 }
 
+static int nxp_c45_config_intr(struct phy_device *phydev)
+{
+	if (phydev->interrupts == PHY_INTERRUPT_ENABLED)
+		return phy_set_bits_mmd(phydev, MDIO_MMD_VEND1,
+					VEND1_PHY_IRQ_EN, PHY_IRQ_LINK_EVENT);
+	else
+		return phy_clear_bits_mmd(phydev, MDIO_MMD_VEND1,
+					  VEND1_PHY_IRQ_EN, PHY_IRQ_LINK_EVENT);
+}
+
+static irqreturn_t nxp_c45_handle_interrupt(struct phy_device *phydev)
+{
+	irqreturn_t ret = IRQ_NONE;
+	int irq;
+
+	irq = phy_read_mmd(phydev, MDIO_MMD_VEND1, VEND1_PHY_IRQ_STATUS);
+	if (irq & PHY_IRQ_LINK_EVENT) {
+		phy_trigger_machine(phydev);
+		phy_write_mmd(phydev, MDIO_MMD_VEND1, VEND1_PHY_IRQ_ACK,
+			      PHY_IRQ_LINK_EVENT);
+		ret = IRQ_HANDLED;
+	}
+
+	return ret;
+}
+
 static int nxp_c45_soft_reset(struct phy_device *phydev)
 {
 	int ret;
@@ -560,6 +591,8 @@ static struct phy_driver nxp_c45_driver[] = {
 		.soft_reset		= nxp_c45_soft_reset,
 		.config_aneg		= nxp_c45_config_aneg,
 		.config_init		= nxp_c45_config_init,
+		.config_intr		= nxp_c45_config_intr,
+		.handle_interrupt	= nxp_c45_handle_interrupt,
 		.read_status		= nxp_c45_read_status,
 		.suspend		= genphy_c45_pma_suspend,
 		.resume			= genphy_c45_pma_resume,

base-commit: cad4162a90aeff737a16c0286987f51e927f003a
-- 
2.31.1

