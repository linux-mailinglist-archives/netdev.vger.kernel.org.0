Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FD593755BB
	for <lists+netdev@lfdr.de>; Thu,  6 May 2021 16:33:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234899AbhEFOef (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 May 2021 10:34:35 -0400
Received: from mail-db8eur05on2072.outbound.protection.outlook.com ([40.107.20.72]:27841
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234833AbhEFOed (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 May 2021 10:34:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BXzXcVQkwnlRtBMg+A3ko814f9UUw2BDb1VTg+yG9+cPJ2nPeTi4A7B7FgQvvc7or0tJ44sg+Lgzin0G4csTpTFKl4WNKNsFNAMCoLa09UCsI+Yjn5aYVs3T/lQbdbWn8kQR9Jw8jPFdLNgE8To/JjgmAdXsdFEEksWhvkhQVD+vq5ubXjBxJEcLDWa9fIMg4vqwDqM2rbrRmKZyRPK3YEPATtrrYRaqxESrxN3tAfH7QAT7wEF/x3wCiBh9pBXSss7LljOKHGoMJRyNthF0zpgeH/BzF7SXmJYIM1U2LlyBHFXu1LEQcgDSuNM4UTKJdr5Q3O9H6XozLVsiiJi13g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4XzgVQer9uVnrbUHP4VoDdzAuFEc21XWYKWWYB8EJDY=;
 b=Of/skyfRFJQ/NqhQx2zDXV4XjOe48LVEaxE2reBOXhXR8TBKYz18c8lRh3Wi1bCzC5df/4VEt8ZNX96snSNew+8ClZ6chyICGnXZKZSMX95RAZW6rJCOKX9IN6rkToOWivUky35EFCGPyQix56c3SROgEfdMsLwuyH6I/gT7fOUoY638mwxePE1yIg3GDJ4tbkNxAJUTbW/Xy55n/R1CwwlYeOt0+T0CkfGClVzG4zjZc2WavZRSiybjUygXwetSjaM8hecUjemewjLJcb6LtCUYbCXXtEOff0FoZ03jS++j8qtajbdaMdZ5MvtZ0PbXWlPP4rY9o3jVd4qvdnm1rw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4XzgVQer9uVnrbUHP4VoDdzAuFEc21XWYKWWYB8EJDY=;
 b=gpxQUUtT4HeKwnHnMg60DnlytzaCX6s2DbtlV0p/mAp5JNaowC8HVNwVqj7jB3hOjqqh5ZBbs7yvGYTNoz74b+atgvJ/31IrOxvCn1aYj3grlxHagWw41ojDLQJfWJ5KsV5Aq3Xo0nXhf0is6XKAVevq6AUCjBDZ9ErafDP2tZM=
Authentication-Results: st.com; dkim=none (message not signed)
 header.d=none;st.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from DU2PR04MB8807.eurprd04.prod.outlook.com (2603:10a6:10:2e2::23)
 by DU2PR04MB8998.eurprd04.prod.outlook.com (2603:10a6:10:2e1::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25; Thu, 6 May
 2021 14:33:33 +0000
Received: from DU2PR04MB8807.eurprd04.prod.outlook.com
 ([fe80::88ab:35ac:f0f5:2387]) by DU2PR04MB8807.eurprd04.prod.outlook.com
 ([fe80::88ab:35ac:f0f5:2387%6]) with mapi id 15.20.4108.027; Thu, 6 May 2021
 14:33:33 +0000
From:   Yannick Vignon <yannick.vignon@oss.nxp.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        sebastien.laveze@oss.nxp.com
Cc:     Yannick Vignon <yannick.vignon@nxp.com>
Subject: [PATCH net v1] net: stmmac: Do not enable RX FIFO overflow interrupts
Date:   Thu,  6 May 2021 16:33:12 +0200
Message-Id: <20210506143312.20784-1-yannick.vignon@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [81.1.10.98]
X-ClientProxiedBy: AM0PR04CA0124.eurprd04.prod.outlook.com
 (2603:10a6:208:55::29) To DU2PR04MB8807.eurprd04.prod.outlook.com
 (2603:10a6:10:2e2::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sopdpuats09.ea.freescale.net (81.1.10.98) by AM0PR04CA0124.eurprd04.prod.outlook.com (2603:10a6:208:55::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25 via Frontend Transport; Thu, 6 May 2021 14:33:32 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 95fa544b-b3b1-4ab7-95fb-08d9109bed15
X-MS-TrafficTypeDiagnostic: DU2PR04MB8998:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DU2PR04MB8998FBAC56DD8AF9C912F0B6D2589@DU2PR04MB8998.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1LSfNwL7ZsxI8w2EOWCsFUYjIgMBy2lFwa4vyG8okntgVzVGt+ZHY9KW3+xpc1nfZ9GwFSlCEeJN+rCtQ7oj6jYTAiE29UGD/IfaIAFASXLAMeZxrQBsg/oNuuOXJKnCxsJvQbzhyRJucmlNZ2IZwzIfVIdoBbAsDOU8jFGL3ToGJ4DjM9I6lAtdtDkGm2pHZAUlQRmlMZBzz+cXb0Z8jHJtKJdtWbv0jqTnQF6e7qCv4WY6IbtPagzXfpf6Rt4VDh/IgainLuD7bi5LKoEz4TUnfkikaFP1ls2wEly4NzvbX5tZgGX3NzUi1ihF/R88v2G9Y7CtL6YDQd5/5muaarMg4TcFd2R90bfBNiFwei6oaKpMUOgU3mNL0XYgqbujEplcrOyMdq2vQTvqfMc5c+vlQ+iu53U5UPtHN8ehrBcGYU/M+mjBakTUZD1Ea+e05LX7xqJjisS5RbR4RUMUoiAXNYfWiwMxZ2UMvDcTvfeWzvNWSKMKfxSx27eXtib2MVOOIwkvEmnIgny5Lh24zfEHjY7DTqto1lv8W21gaI0sezhEait2F3D9fAjdAO9aHMQlEbXoz7pDdTNrWZ459dvjCa0o9fdWUPfVxc/3RUsNBbyY9hBTTGJ8HfU61Xol6V7m+W3WQAFT1rKD+TJ315Ijt3DK5vi5sKI4pjufyqc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU2PR04MB8807.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(396003)(39850400004)(136003)(346002)(86362001)(5660300002)(52116002)(6512007)(66946007)(4326008)(8676002)(316002)(956004)(2906002)(6666004)(6636002)(8936002)(478600001)(6486002)(83380400001)(44832011)(186003)(16526019)(6506007)(38350700002)(66556008)(26005)(2616005)(38100700002)(66476007)(1076003)(110136005)(3714002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?aTWz0n2Ax4HNNI7wyyX1oMdwB9hm74D27pc97GE562ftfKLnEzx9gNhzQ4K/?=
 =?us-ascii?Q?wgJhjsu8kO1BgxCNA2LlIzHqotEBnj5XkM/azu2w+/K18CeExnIH+Q67LaiZ?=
 =?us-ascii?Q?2QF6MncxFz5Vlj6LknK0v7BzR/eb0M61+PV8OucH4NBPSihBiBERgbVm7o8v?=
 =?us-ascii?Q?ntzpSW8n28cafKfQTh49SgzgJApzkWG7TC1yl1rjzQrA3LTaFofO0BsvXeuf?=
 =?us-ascii?Q?jsbn3UH5P0Z26i/XUQ8UbMqJefCBwKlTRcvHp94fox8MO9C6j4cVuXsqCTD5?=
 =?us-ascii?Q?bDWtlm1KrMYHwGQcwTj6CUsoTVAn9rS/UkZth5jn0+So3+tDlTBPcGOjyg8j?=
 =?us-ascii?Q?dp+jjyMpcwYBykSXQjh+QkcIrGPYU73XVapADDYfVR4VI1FaRbNB9RWNQRFp?=
 =?us-ascii?Q?yN0BrsehXRvW8cKyOCrQa3N/p3sH5Pu2jFateQXWl0O8lP5xXvkSPBILLMFJ?=
 =?us-ascii?Q?mAzmIFsVBerrBiCBUTzlGtj14745fprzKEzy0scgVjeTF69v+3fu+vjSBaIA?=
 =?us-ascii?Q?LlDPnsemoJNG/yrkmh3f9jyG6fm47Kaf199VUiMaLmV7nAXWxWqEeEhGrr2M?=
 =?us-ascii?Q?cvKsnGEy7RuifLQox91fWIQYBYTqxDMQvQDPNYLNIpLpAszVhweWoWS5htDV?=
 =?us-ascii?Q?zUOa/RGj6+2ve7O0zmK9F7YhwqxXJygdxanbwm7c43trFK6Hr1MPgykdll/4?=
 =?us-ascii?Q?uJyZystsPctfqIB/HF/Q0fNPNPMk+AL0y9D+NptR0Uz+4t26sZwNcytqeDJ0?=
 =?us-ascii?Q?qTsiJvwmKiPNfG8roRPnQdUYKqVSC73LZRZIQ0Q5pg4/au+noLjOCgqV2Fq6?=
 =?us-ascii?Q?nIM9lizg0KJlMxFwFYGKUUfuo4r9i3gzJ+TZu9gYin1rBZGFwbfP9+Sfeggo?=
 =?us-ascii?Q?/KRKogvLy3Eh3PdkooCsJPAlJ2ktHi2l27jca5SjwnalkviZsGGoZ3S46eeq?=
 =?us-ascii?Q?HSsVm5XCd/dTXLS/h2kOYWCbNZEaghCC685uebXJ6RS3T+2qIWOjYgIERfwR?=
 =?us-ascii?Q?kimKcqMNnnqbpi1mtvjQ+n1z86Tx+7UCP97L5BHEyWqNGtJkthPj/gFqMIo/?=
 =?us-ascii?Q?y48DwLSLE2wm2+IA/esNU4RqBBZWJYBjpwSJAzSNjpaiAii/pEbfwOMdwieX?=
 =?us-ascii?Q?90gD5gaJyeG0XDcCiB1/0deg3PNgWQL8Clet8MaOw87NSgbu/CdTZF3eVdHr?=
 =?us-ascii?Q?HGnX31k3BO/cfiXSJiSo4To5HmkHcYWRD//D1Io0YqbgajqvI5Z/6buHeVPi?=
 =?us-ascii?Q?Dkj00RUKE2IY7ckIAYAEC8FnBFhsqLr3X65gmalUDoCVTzulXtLZgeytxgKB?=
 =?us-ascii?Q?pSuIW/gns5EZB8Y2lvfVxLMx?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 95fa544b-b3b1-4ab7-95fb-08d9109bed15
X-MS-Exchange-CrossTenant-AuthSource: DU2PR04MB8807.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2021 14:33:33.5486
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /25zQLtvOAGvDAQEOzWR/TqMueAxouVUvIT+oTiUpcyBCt1FWBRoLNunVbJlmle8yR927Q5FwSKqlnYNmTUQUQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR04MB8998
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yannick Vignon <yannick.vignon@nxp.com>

The RX FIFO overflows when the system is not able to process all received
packets and they start accumulating (first in the DMA queue in memory,
then in the FIFO). An interrupt is then raised for each overflowing packet
and handled in stmmac_interrupt(). This is counter-productive, since it
brings the system (or more likely, one CPU core) to its knees to process
the FIFO overflow interrupts.

stmmac_interrupt() handles overflow interrupts by writing the rx tail ptr
into the corresponding hardware register (according to the MAC spec, this
has the effect of restarting the MAC DMA). However, without freeing any rx
descriptors, the DMA stops right away, and another overflow interrupt is
raised as the FIFO overflows again. Since the DMA is already restarted at
the end of stmmac_rx_refill() after freeing descriptors, disabling FIFO
overflow interrupts and the corresponding handling code has no side effect,
and eliminates the interrupt storm when the RX FIFO overflows.

Signed-off-by: Yannick Vignon <yannick.vignon@nxp.com>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.c  |  7 +------
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 14 ++------------
 2 files changed, 3 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.c b/drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.c
index a602d16b9e53..5be8e6a631d9 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.c
@@ -232,7 +232,7 @@ static void dwmac4_dma_rx_chan_op_mode(void __iomem *ioaddr, int mode,
 				       u32 channel, int fifosz, u8 qmode)
 {
 	unsigned int rqs = fifosz / 256 - 1;
-	u32 mtl_rx_op, mtl_rx_int;
+	u32 mtl_rx_op;
 
 	mtl_rx_op = readl(ioaddr + MTL_CHAN_RX_OP_MODE(channel));
 
@@ -293,11 +293,6 @@ static void dwmac4_dma_rx_chan_op_mode(void __iomem *ioaddr, int mode,
 	}
 
 	writel(mtl_rx_op, ioaddr + MTL_CHAN_RX_OP_MODE(channel));
-
-	/* Enable MTL RX overflow */
-	mtl_rx_int = readl(ioaddr + MTL_CHAN_INT_CTRL(channel));
-	writel(mtl_rx_int | MTL_RX_OVERFLOW_INT_EN,
-	       ioaddr + MTL_CHAN_INT_CTRL(channel));
 }
 
 static void dwmac4_dma_tx_chan_op_mode(void __iomem *ioaddr, int mode,
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index e0b7eebcb512..345b4c6d1fd4 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -5587,7 +5587,6 @@ static void stmmac_common_interrupt(struct stmmac_priv *priv)
 	/* To handle GMAC own interrupts */
 	if ((priv->plat->has_gmac) || xmac) {
 		int status = stmmac_host_irq_status(priv, priv->hw, &priv->xstats);
-		int mtl_status;
 
 		if (unlikely(status)) {
 			/* For LPI we need to save the tx status */
@@ -5598,17 +5597,8 @@ static void stmmac_common_interrupt(struct stmmac_priv *priv)
 		}
 
 		for (queue = 0; queue < queues_count; queue++) {
-			struct stmmac_rx_queue *rx_q = &priv->rx_queue[queue];
-
-			mtl_status = stmmac_host_mtl_irq_status(priv, priv->hw,
-								queue);
-			if (mtl_status != -EINVAL)
-				status |= mtl_status;
-
-			if (status & CORE_IRQ_MTL_RX_OVERFLOW)
-				stmmac_set_rx_tail_ptr(priv, priv->ioaddr,
-						       rx_q->rx_tail_addr,
-						       queue);
+			status = stmmac_host_mtl_irq_status(priv, priv->hw,
+							    queue);
 		}
 
 		/* PCS link status */
-- 
2.17.1

