Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06A73362682
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 19:14:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238555AbhDPRPO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 13:15:14 -0400
Received: from mail-eopbgr20054.outbound.protection.outlook.com ([40.107.2.54]:37093
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235454AbhDPRPL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Apr 2021 13:15:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f4rzJYhI0+p6xf74s6tf3nrwoaFTcByu7gaHGhW5jdrwihlx43CC+3HcWBGIFI4ItdZ206uFgjWbJuyAK807I1lBaCtB5OBclCZ7wdOdp+Nu38A7HYWRngD4qPUEBEUAtzg7AmwJpQ0y6JJgq/mf4gTiwiu1qz75zsPKvMP6V8serrsqXeGbmpVn4wNMAQmtHwcVFR1j9J9alRiHUXFVO0l8lBCzAPs73QrcRkKpsf8GiX3vD6NmBO5Hy4yDLSPH6ZaB0y4ghGz0iBvTovoB0qi8t6N+d0ATk6bAGPMhVD7hvC/2vbqLnbRy6WgCdvX2TCH9smhYSvO9Dqz2cKsvfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8hndEXxodrCTq/ecORFjU0inRoVLUKM7pN5aG3ilUM8=;
 b=OEGoMv+yeF+gbrCj1sHwgMC4YAMS15kt+laHGfg4ANZPouoVkw+CEHuSlkrxz2BVRiS1oz/G0U9AKKQpa775l0APakby82SzYrVOrLfovx3ccwg5BSuK+zya7EQ3Av6cix5ByAqGd/RtfERiKX3PdtdfiZjUATyhR+7zpO9IS0IlFvjz1LnjZ/6VsQqeq79atO/LFe9MOKpQr0sIHHX70i1CDShLx4pr7x9KZp9oUFx/tW2JDUC28EQxbimCFt9HIqEHBczaKswpNeX2OHvlpZpNrSLe+36ypHF8OwQXraooOaGropMOBgUE7Pkl3i+QQQ0JgKm15uBBbU4e39EIrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8hndEXxodrCTq/ecORFjU0inRoVLUKM7pN5aG3ilUM8=;
 b=khgurf3/cgPdIBhI3xlKtcD1aHJ5xR28t81rYiFRLThBQEQIV9hv/jTT4gGRCIAdO6jY5ZD98W/6j+kZT2PmhhWC2vUwxA6HZe9++2Uztop9Ev6cr1QsxhHWZsJckCymxMm7HI4pWeADd1qMDrVK2Lcr5S6EFWq/9qa9mP5Y7EY=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6754.eurprd04.prod.outlook.com (2603:10a6:208:170::28)
 by AM0PR04MB5140.eurprd04.prod.outlook.com (2603:10a6:208:ca::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.19; Fri, 16 Apr
 2021 17:14:45 +0000
Received: from AM0PR04MB6754.eurprd04.prod.outlook.com
 ([fe80::f12c:54bd:ccfc:819a]) by AM0PR04MB6754.eurprd04.prod.outlook.com
 ([fe80::f12c:54bd:ccfc:819a%7]) with mapi id 15.20.4042.018; Fri, 16 Apr 2021
 17:14:44 +0000
From:   Claudiu Manoil <claudiu.manoil@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        devicetree@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Rob Herring <robh+dt@kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH net-next 1/2] gianfar: Drop GFAR_MQ_POLLING support
Date:   Fri, 16 Apr 2021 20:11:22 +0300
Message-Id: <20210416171123.22969-2-claudiu.manoil@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210416171123.22969-1-claudiu.manoil@nxp.com>
References: <20210416171123.22969-1-claudiu.manoil@nxp.com>
Content-Type: text/plain
X-Originating-IP: [83.217.231.2]
X-ClientProxiedBy: AM0PR05CA0088.eurprd05.prod.outlook.com
 (2603:10a6:208:136::28) To AM0PR04MB6754.eurprd04.prod.outlook.com
 (2603:10a6:208:170::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv15141.swis.ro-buh01.nxp.com (83.217.231.2) by AM0PR05CA0088.eurprd05.prod.outlook.com (2603:10a6:208:136::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.19 via Frontend Transport; Fri, 16 Apr 2021 17:14:44 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4b1c287d-fc85-4ae4-5765-08d900fb2169
X-MS-TrafficTypeDiagnostic: AM0PR04MB5140:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB5140174FA0BB006989241264964C9@AM0PR04MB5140.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1bN2kLiF0fRQ0vu8rqyEkVUikxRDfQoUAY5e8kB7nO8pgil5gCEyu0wTVvzhLr70e2AdFmjkyTmD7FOoWrxs+jIe1lWSQwTwI94Vj4OUIxGFgM0Jk3BmSEHN5uitr4bquwq2fhgmoRUAyMiUip1PetPrq07WGqRyecPk6cSSsZ2mCEpnPiHOhIThYmp7qL0YhfQM1Lv4qEjXmCQUGpGU6fEIxoUj43Io9s9/W38VKEYn95VHzGzNw1EJlvf1nTwA+Aid4tlqW0xoPWCmMC10KhQEEWV6lBV5CXzaTuhK8epWIoM6+/5YLwpM+vlAZAMhCeFHtXFwZxiJ4VXeEmRUIfk8FPJ/kqT/jYwrcTDC2bVsnGxug9Nz3HD6nir8rQaPT5Tz2xZ1+ZpAueYJvVYSU6kqFtrQ/0GHpmTe1IFNfxmcEXI3QLg3t+dQSrw26/VnVMPgOfdgUWTnq5s6Lg7yb+D2VZ+yfsMITUnrawUT5lcVYz8yiHqubsoZ0FELaGUNYebXZMO0TLDW8Uam7fX4xMtN+52z1Y5pfsp30clJphYjYVrEB+ArDvf6W9P2ILJw3aKrZrS2szuboiEXtrn8xJnxS7QOuN+wJzg5LcO7cIMSF8OKKm8FJHsJw3UOUg/39u7MeNLjVN0j5EvHxB1VuwSGXXOKi1Ian5FNpsuc0yE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6754.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(376002)(346002)(39860400002)(366004)(66556008)(8676002)(38100700002)(38350700002)(2906002)(16526019)(4326008)(8936002)(5660300002)(36756003)(52116002)(86362001)(7696005)(66946007)(66476007)(6916009)(316002)(54906003)(186003)(1076003)(26005)(6666004)(6486002)(83380400001)(478600001)(956004)(2616005)(44832011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?6U72A89bJGfP94MD6auFP+MGS5b+/JqZlpbiMCijVsKRDFUIUn8H3JZDfYHU?=
 =?us-ascii?Q?PrksIHp6CoPPJIi0Ieq5InZfYN4BzixTx9xmZuuBgZnL47C7sGp3aBf805kY?=
 =?us-ascii?Q?c4RSaXFA0ByoWx+ZFl275ipLTZ9yWxtWA/zOoE/tpcauv94xq5WmpfyhQPzt?=
 =?us-ascii?Q?cXnmHNVrG2Y+R6wTB2KpHl3q1nnkufzGmsabuU8HQcGW+sGwxmGYqMDDPuqD?=
 =?us-ascii?Q?+0Ba/bDkdNEmudhmVwhBVEC3Zjxdo7waschk2KhMfgt14PLcFacMT0mwwZrD?=
 =?us-ascii?Q?k4NwMpIicHeYbCaZ5niVgxZqpzQmxVuPCB1HMs1q7D4qKsYsiATvavat7ff3?=
 =?us-ascii?Q?7pAxer+E6dcKZbo3zDqdtFWTBZelsJFaYlOCuPj0eSznTMcrFrNmCs1I8w7y?=
 =?us-ascii?Q?EeohqKuFKr3GocqWdl2uwIILO9rpQyCGA1t9UiUGPU+/0URKyx4CUICU3MLR?=
 =?us-ascii?Q?wss4WsNV5pwrTEbuhol4+Rp7/65aeAE8QNmfsejmOVCymw0NTdFoEoNZ0tfv?=
 =?us-ascii?Q?Lvx0CcoDpBPclFzILYHVAqqLAUXDiQwKBYs8CWbNHKd7jkjmNdo9n35YDj/S?=
 =?us-ascii?Q?eXLa9deb6d85UdIWWsVowrKsYtHjBuUBdJJLnMWJmXD8fD066qHMNFHrDjF9?=
 =?us-ascii?Q?cLJrHn8EeIq9XM7hBA0ploHzw/YVfxj/llkpmaFWmjkZlY1/fQZSzKk2zcNN?=
 =?us-ascii?Q?f0zvEsa5kRpIcV7P6jcqtHesCMbRNU4A8nvBjp7lwsG/4RzVj7UE4E6Kv36q?=
 =?us-ascii?Q?VF3lkezi6xVGH+Z9Y1EW95bQshZxoAYhb1NiGDzt4PrN10weS5Cho0C0E+6T?=
 =?us-ascii?Q?eCrSdqG9zCbVhcl3vtjkFbCBJDQZZQbNjj81LF9P/mpHtfJk8LQsbVjgadqJ?=
 =?us-ascii?Q?HRhHuVWTXSOZBpkZI4shSKHmQb/R0MFY32Z38AmgymJwiKAOChuWgaLcP3eV?=
 =?us-ascii?Q?Cnkdl/yPyI72H4Wc4yD9ScAznbR4hI8pkA77blPtxYYoQsGJRiPi6nVisrEf?=
 =?us-ascii?Q?tHEMyjNtGO70CecKTOiQpULbUf5SOsXzX8LvtY2LSfi6wGNJ8rBeZf/Or2u+?=
 =?us-ascii?Q?UX83dsPDSfD9l60N/hf9Cc+wo1sCuVJUpZcYaiVkRzCoHItkMNMqzqsP0XFB?=
 =?us-ascii?Q?n8wUVBpnCfwMUBUb8wM/rUwFVOVTwRSHrUGWweBYhMTdCBnQPRKeF6jIuDG3?=
 =?us-ascii?Q?zZI4cPLBtHjqqps90d1RxH1P5lvDYvEOPnfRtwXaJ+ZnF0YrMYxzv68fo5ZU?=
 =?us-ascii?Q?GLPKYhMZ9HSdPZgT6Ye3EhPa6DczVXhwVUwn9AqjM87IYLD8fCHyR8kFs5CF?=
 =?us-ascii?Q?NiqoUMk4NdJEetQ96VS5MFDw?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b1c287d-fc85-4ae4-5765-08d900fb2169
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6754.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2021 17:14:44.8977
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jmxSdY6/lyt9L2K2L/00yQncIYAvr+Z1aKgtuOnmgHJ3YIN4YnOU/+B/3FAxzeYxd2CUYSEOgPimXRF9gYUbWA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB5140
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Gianfar used to enable all 8 Rx queues (DMA rings) per
ethernet device, even though the controller can only
support 2 interrupt lines at most.  This meant that
multiple Rx queues would have to be grouped per NAPI poll
routine, and the CPU would have to split the budget and
service them in a round robin manner.  The overhead of
this scheme proved to outweight the potential benefits.
The alternative was to introduce the "Single Queue" polling
mode, supporting one Rx queue per NAPI, which became the
default packet processing option and helped improve the
performance of the driver.
MQ_POLLING also relies on undocumeted device tree properties
to specify how to map the 8 Rx and Tx queues to a given
interrupt line (aka "interrupt group").  Using module parameters
to enable this mode wasn't an option either.  Long story short,
MQ_POLLING became obsolete, now it is just dead code, and no
one asked for it so far.
For the Tx queues, multi-queue support (more than 1 Tx queue
per CPU) could be revisited by adding tc MQPRIO support, but
again, one has to consider that there are only 2 interrupt lines.
So the NAPI poll routine would have to service multiple Tx rings.

Signed-off-by: Claudiu Manoil <claudiu.manoil@nxp.com>
---
 drivers/net/ethernet/freescale/gianfar.c | 170 ++---------------------
 drivers/net/ethernet/freescale/gianfar.h |  17 ---
 2 files changed, 11 insertions(+), 176 deletions(-)

diff --git a/drivers/net/ethernet/freescale/gianfar.c b/drivers/net/ethernet/freescale/gianfar.c
index 3ec4d9fddd52..4e4c62d4061e 100644
--- a/drivers/net/ethernet/freescale/gianfar.c
+++ b/drivers/net/ethernet/freescale/gianfar.c
@@ -175,10 +175,7 @@ static void gfar_mac_rx_config(struct gfar_private *priv)
 	if (priv->rx_filer_enable) {
 		rctrl |= RCTRL_FILREN | RCTRL_PRSDEP_INIT;
 		/* Program the RIR0 reg with the required distribution */
-		if (priv->poll_mode == GFAR_SQ_POLLING)
-			gfar_write(&regs->rir0, DEFAULT_2RXQ_RIR0);
-		else /* GFAR_MQ_POLLING */
-			gfar_write(&regs->rir0, DEFAULT_8RXQ_RIR0);
+		gfar_write(&regs->rir0, DEFAULT_2RXQ_RIR0);
 	}
 
 	/* Restore PROMISC mode */
@@ -521,29 +518,9 @@ static int gfar_parse_group(struct device_node *np,
 	grp->priv = priv;
 	spin_lock_init(&grp->grplock);
 	if (priv->mode == MQ_MG_MODE) {
-		u32 rxq_mask, txq_mask;
-		int ret;
-
+		/* One Q per interrupt group: Q0 to G0, Q1 to G1 */
 		grp->rx_bit_map = (DEFAULT_MAPPING >> priv->num_grps);
 		grp->tx_bit_map = (DEFAULT_MAPPING >> priv->num_grps);
-
-		ret = of_property_read_u32(np, "fsl,rx-bit-map", &rxq_mask);
-		if (!ret) {
-			grp->rx_bit_map = rxq_mask ?
-			rxq_mask : (DEFAULT_MAPPING >> priv->num_grps);
-		}
-
-		ret = of_property_read_u32(np, "fsl,tx-bit-map", &txq_mask);
-		if (!ret) {
-			grp->tx_bit_map = txq_mask ?
-			txq_mask : (DEFAULT_MAPPING >> priv->num_grps);
-		}
-
-		if (priv->poll_mode == GFAR_SQ_POLLING) {
-			/* One Q per interrupt group: Q0 to G0, Q1 to G1 */
-			grp->rx_bit_map = (DEFAULT_MAPPING >> priv->num_grps);
-			grp->tx_bit_map = (DEFAULT_MAPPING >> priv->num_grps);
-		}
 	} else {
 		grp->rx_bit_map = 0xFF;
 		grp->tx_bit_map = 0xFF;
@@ -650,18 +627,15 @@ static int gfar_of_init(struct platform_device *ofdev, struct net_device **pdev)
 	u32 stash_len = 0;
 	u32 stash_idx = 0;
 	unsigned int num_tx_qs, num_rx_qs;
-	unsigned short mode, poll_mode;
+	unsigned short mode;
 
 	if (!np)
 		return -ENODEV;
 
-	if (of_device_is_compatible(np, "fsl,etsec2")) {
+	if (of_device_is_compatible(np, "fsl,etsec2"))
 		mode = MQ_MG_MODE;
-		poll_mode = GFAR_SQ_POLLING;
-	} else {
+	else
 		mode = SQ_SG_MODE;
-		poll_mode = GFAR_SQ_POLLING;
-	}
 
 	if (mode == SQ_SG_MODE) {
 		num_tx_qs = 1;
@@ -677,22 +651,8 @@ static int gfar_of_init(struct platform_device *ofdev, struct net_device **pdev)
 			return -EINVAL;
 		}
 
-		if (poll_mode == GFAR_SQ_POLLING) {
-			num_tx_qs = num_grps; /* one txq per int group */
-			num_rx_qs = num_grps; /* one rxq per int group */
-		} else { /* GFAR_MQ_POLLING */
-			u32 tx_queues, rx_queues;
-			int ret;
-
-			/* parse the num of HW tx and rx queues */
-			ret = of_property_read_u32(np, "fsl,num_tx_queues",
-						   &tx_queues);
-			num_tx_qs = ret ? 1 : tx_queues;
-
-			ret = of_property_read_u32(np, "fsl,num_rx_queues",
-						   &rx_queues);
-			num_rx_qs = ret ? 1 : rx_queues;
-		}
+		num_tx_qs = num_grps; /* one txq per int group */
+		num_rx_qs = num_grps; /* one rxq per int group */
 	}
 
 	if (num_tx_qs > MAX_TX_QS) {
@@ -718,7 +678,6 @@ static int gfar_of_init(struct platform_device *ofdev, struct net_device **pdev)
 	priv->ndev = dev;
 
 	priv->mode = mode;
-	priv->poll_mode = poll_mode;
 
 	priv->num_tx_queues = num_tx_qs;
 	netif_set_real_num_rx_queues(dev, num_rx_qs);
@@ -2695,106 +2654,6 @@ static int gfar_poll_tx_sq(struct napi_struct *napi, int budget)
 	return 0;
 }
 
-static int gfar_poll_rx(struct napi_struct *napi, int budget)
-{
-	struct gfar_priv_grp *gfargrp =
-		container_of(napi, struct gfar_priv_grp, napi_rx);
-	struct gfar_private *priv = gfargrp->priv;
-	struct gfar __iomem *regs = gfargrp->regs;
-	struct gfar_priv_rx_q *rx_queue = NULL;
-	int work_done = 0, work_done_per_q = 0;
-	int i, budget_per_q = 0;
-	unsigned long rstat_rxf;
-	int num_act_queues;
-
-	/* Clear IEVENT, so interrupts aren't called again
-	 * because of the packets that have already arrived
-	 */
-	gfar_write(&regs->ievent, IEVENT_RX_MASK);
-
-	rstat_rxf = gfar_read(&regs->rstat) & RSTAT_RXF_MASK;
-
-	num_act_queues = bitmap_weight(&rstat_rxf, MAX_RX_QS);
-	if (num_act_queues)
-		budget_per_q = budget/num_act_queues;
-
-	for_each_set_bit(i, &gfargrp->rx_bit_map, priv->num_rx_queues) {
-		/* skip queue if not active */
-		if (!(rstat_rxf & (RSTAT_CLEAR_RXF0 >> i)))
-			continue;
-
-		rx_queue = priv->rx_queue[i];
-		work_done_per_q =
-			gfar_clean_rx_ring(rx_queue, budget_per_q);
-		work_done += work_done_per_q;
-
-		/* finished processing this queue */
-		if (work_done_per_q < budget_per_q) {
-			/* clear active queue hw indication */
-			gfar_write(&regs->rstat,
-				   RSTAT_CLEAR_RXF0 >> i);
-			num_act_queues--;
-
-			if (!num_act_queues)
-				break;
-		}
-	}
-
-	if (!num_act_queues) {
-		u32 imask;
-		napi_complete_done(napi, work_done);
-
-		/* Clear the halt bit in RSTAT */
-		gfar_write(&regs->rstat, gfargrp->rstat);
-
-		spin_lock_irq(&gfargrp->grplock);
-		imask = gfar_read(&regs->imask);
-		imask |= IMASK_RX_DEFAULT;
-		gfar_write(&regs->imask, imask);
-		spin_unlock_irq(&gfargrp->grplock);
-	}
-
-	return work_done;
-}
-
-static int gfar_poll_tx(struct napi_struct *napi, int budget)
-{
-	struct gfar_priv_grp *gfargrp =
-		container_of(napi, struct gfar_priv_grp, napi_tx);
-	struct gfar_private *priv = gfargrp->priv;
-	struct gfar __iomem *regs = gfargrp->regs;
-	struct gfar_priv_tx_q *tx_queue = NULL;
-	int has_tx_work = 0;
-	int i;
-
-	/* Clear IEVENT, so interrupts aren't called again
-	 * because of the packets that have already arrived
-	 */
-	gfar_write(&regs->ievent, IEVENT_TX_MASK);
-
-	for_each_set_bit(i, &gfargrp->tx_bit_map, priv->num_tx_queues) {
-		tx_queue = priv->tx_queue[i];
-		/* run Tx cleanup to completion */
-		if (tx_queue->tx_skbuff[tx_queue->skb_dirtytx]) {
-			gfar_clean_tx_ring(tx_queue);
-			has_tx_work = 1;
-		}
-	}
-
-	if (!has_tx_work) {
-		u32 imask;
-		napi_complete(napi);
-
-		spin_lock_irq(&gfargrp->grplock);
-		imask = gfar_read(&regs->imask);
-		imask |= IMASK_TX_DEFAULT;
-		gfar_write(&regs->imask, imask);
-		spin_unlock_irq(&gfargrp->grplock);
-	}
-
-	return 0;
-}
-
 /* GFAR error interrupt handler */
 static irqreturn_t gfar_error(int irq, void *grp_id)
 {
@@ -3352,17 +3211,10 @@ static int gfar_probe(struct platform_device *ofdev)
 
 	/* Register for napi ...We are registering NAPI for each grp */
 	for (i = 0; i < priv->num_grps; i++) {
-		if (priv->poll_mode == GFAR_SQ_POLLING) {
-			netif_napi_add(dev, &priv->gfargrp[i].napi_rx,
-				       gfar_poll_rx_sq, GFAR_DEV_WEIGHT);
-			netif_tx_napi_add(dev, &priv->gfargrp[i].napi_tx,
-				       gfar_poll_tx_sq, 2);
-		} else {
-			netif_napi_add(dev, &priv->gfargrp[i].napi_rx,
-				       gfar_poll_rx, GFAR_DEV_WEIGHT);
-			netif_tx_napi_add(dev, &priv->gfargrp[i].napi_tx,
-				       gfar_poll_tx, 2);
-		}
+		netif_napi_add(dev, &priv->gfargrp[i].napi_rx,
+			       gfar_poll_rx_sq, GFAR_DEV_WEIGHT);
+		netif_tx_napi_add(dev, &priv->gfargrp[i].napi_tx,
+				  gfar_poll_tx_sq, 2);
 	}
 
 	if (priv->device_flags & FSL_GIANFAR_DEV_HAS_CSUM) {
diff --git a/drivers/net/ethernet/freescale/gianfar.h b/drivers/net/ethernet/freescale/gianfar.h
index 8ced783f5302..5ea47df93e5e 100644
--- a/drivers/net/ethernet/freescale/gianfar.h
+++ b/drivers/net/ethernet/freescale/gianfar.h
@@ -909,22 +909,6 @@ enum {
 	MQ_MG_MODE
 };
 
-/* GFAR_SQ_POLLING: Single Queue NAPI polling mode
- *	The driver supports a single pair of RX/Tx queues
- *	per interrupt group (Rx/Tx int line). MQ_MG mode
- *	devices have 2 interrupt groups, so the device will
- *	have a total of 2 Tx and 2 Rx queues in this case.
- * GFAR_MQ_POLLING: Multi Queue NAPI polling mode
- *	The driver supports all the 8 Rx and Tx HW queues
- *	each queue mapped by the Device Tree to one of
- *	the 2 interrupt groups. This mode implies significant
- *	processing overhead (CPU and controller level).
- */
-enum gfar_poll_mode {
-	GFAR_SQ_POLLING = 0,
-	GFAR_MQ_POLLING
-};
-
 /*
  * Per TX queue stats
  */
@@ -1105,7 +1089,6 @@ struct gfar_private {
 	unsigned long state;
 
 	unsigned short mode;
-	unsigned short poll_mode;
 	unsigned int num_tx_queues;
 	unsigned int num_rx_queues;
 	unsigned int num_grps;
-- 
2.25.1

