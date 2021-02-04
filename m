Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B63530F1F9
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 12:24:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235747AbhBDLXL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 06:23:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235653AbhBDLXH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Feb 2021 06:23:07 -0500
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04on062c.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe0d::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF4FAC0613D6
        for <netdev@vger.kernel.org>; Thu,  4 Feb 2021 03:22:21 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aPOb5i1BSNxzko2/7RDt60kD9LuFCQk2LoDAopsQ7MqqIRhR2qVqNfLI8rvpw7CV1HeN7ZJ/x2X/nZ+IMQZyVP9nF6uDVzF5imKMpPZkyQMg9Cgg/qE1hb7YRYpobQwm0eJR2o1y0LcYvUjdnSF1NGXrWvc1cv4vhI7NgykA8vqZyhL+CM8Q5ThFuRYInuFClkWU3Q/mzgySb9Z/ZiDbXFzDAApHHt+HHEfTRQAIE/Bze4W0LZSapQD7itg9zGlNlMvghzn8WpoxldJvIXIpJZeAu8H5S4AIlxNSEj/3BJv8iZwUv2ltj2z6akBYyN70pBqflbud1j4EBqGJ74/hxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XZVEYlSirYC/BxAuAH+v/SlAmkW390URv6Vj0seH1/c=;
 b=WaxYB9DoZJTXRLHadIsrBLrwegtcIKJZNdiWqgcOG2BYBlJOOmh5EEwBznlS/XCKGtc0EgR9yzlMt8nBO9hBKLlZPHcQZeOG4xqQ+q82YRpBJV4iw//veME/R+g1y4e/qHzXCERyUQeyI2D08lWzvPY29wES2suRYR7qv4A4VkyQuTHL0SSywO5mpxIHkbRMAUvEJFvHQVEi/WglVj2IRLFYik2UitNFrgMT2GYUvfwKTUrQQktrQZi8t9Qpqu8b1x8Gfogo/kEMgyvqLLPLvwLSLlRnfDvZhwr+JQW35RoVCLjkGXhBmaqmUkQdcy4NkMTN4LHbOhgf2S+btsjLPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XZVEYlSirYC/BxAuAH+v/SlAmkW390URv6Vj0seH1/c=;
 b=a8h8c7qVSGEr6tDOtx2Fy0UFIDK0mmkG4c9uIF6qejLKPI6NgwR3xoLKUX+RKXXfRJc7+r5bVOv+b2jEob/4AXPrJ7HKo/k6QfLXAWlvDF5fJL+YzUg56YeVRmJYqp2TqyQIUNRhBdCYnEEJZYTaBe4TrpG0UN6m6EUATo3ljyM=
Authentication-Results: st.com; dkim=none (message not signed)
 header.d=none;st.com; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB6800.eurprd04.prod.outlook.com (2603:10a6:803:133::16)
 by VE1PR04MB6366.eurprd04.prod.outlook.com (2603:10a6:803:12a::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.15; Thu, 4 Feb
 2021 11:21:48 +0000
Received: from VI1PR04MB6800.eurprd04.prod.outlook.com
 ([fe80::6958:79d5:16bf:5f14]) by VI1PR04MB6800.eurprd04.prod.outlook.com
 ([fe80::6958:79d5:16bf:5f14%9]) with mapi id 15.20.3825.019; Thu, 4 Feb 2021
 11:21:48 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-imx@nxp.com
Subject: [PATCH V4 net 3/5] net: stmmac: fix dma physical address of descriptor when display ring
Date:   Thu,  4 Feb 2021 19:21:42 +0800
Message-Id: <20210204112144.24163-4-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210204112144.24163-1-qiangqing.zhang@nxp.com>
References: <20210204112144.24163-1-qiangqing.zhang@nxp.com>
Content-Type: text/plain
X-Originating-IP: [119.31.174.71]
X-ClientProxiedBy: SG2PR03CA0128.apcprd03.prod.outlook.com
 (2603:1096:4:91::32) To VI1PR04MB6800.eurprd04.prod.outlook.com
 (2603:10a6:803:133::16)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SG2PR03CA0128.apcprd03.prod.outlook.com (2603:1096:4:91::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.11 via Frontend Transport; Thu, 4 Feb 2021 11:21:45 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 1d5428b6-5fc3-46b9-277b-08d8c8ff0fa6
X-MS-TrafficTypeDiagnostic: VE1PR04MB6366:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VE1PR04MB63662261678DDC06460E5D12E6B39@VE1PR04MB6366.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:151;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1sRgVDE7Gw0Sy/YfkhSJGoiCcAS8lzFmUDjdVcLIkjVpS5IA9BtSGUS57skiOlzxGqXo6UAdEgYxc9fdLGIb0b7niOsBdGV8iAFGL39hmIq8Zs2jkJApXOXOxFSVrEaFa0ziXyANktQY8sD33UgnJtsafPlESwIfgmqLeKxtzNWx1Ej7nDFSEwYS8ZRPD8dBWsH7mOWxXBcfzzPwIvlxJQpLJDN+UinJneTuU8aHwRBlRKsBb1VOKkBCP1naTEzrYGHhQJIeu2+Nzu9Bj6skJ7tTDJ3wwbKlGdmgUF+cLRwrV+TEUNUCTrxy7lZJtxLohsD/B8ETfv0otqDknNJWnKRqpMgfxky0YI7FQGf77Lq8mpYEqVTkytDVAJjY6uZPaCktu6NbPgoInWX11cGzqFfZT5YovLkZY/4cJwXftR8EptklyQMb771cqm/QxIUZwajKLIQDVyjP/HMQjU3idbVgwW5Dxo/2BNe9twC6qlQP9NRaelFjJ+UgWuRFXBZYmrKnDYcP6aECZ/QpJY5112yMAr/IYzWFYJvBB8RrrLXMDiyrxxIJVv4Kcki26mFzTjj7btrzpfGI1jmdau4hEA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB6800.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(376002)(346002)(136003)(396003)(316002)(83380400001)(66476007)(478600001)(4326008)(66556008)(66946007)(2906002)(26005)(36756003)(956004)(5660300002)(8676002)(1076003)(6486002)(86362001)(8936002)(69590400011)(186003)(16526019)(52116002)(2616005)(6506007)(6666004)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?95/i68ddcWHwMltPJkDQjOLHPKbm0QDsT82xJQwweOGUYengeEHCc1eVK14N?=
 =?us-ascii?Q?DoRmr/iAwl8YT2x4WM8BFmrAjzOJuhI6HxA7aqJ21Dg2gc7XoUijhhfkcb3N?=
 =?us-ascii?Q?N9gPnXCETq+UHi+GjzEBDkjHYmlMlgR3ZFezOIHsjhRcYodaJTSjwfgdHdQH?=
 =?us-ascii?Q?hKvmtxuqJiHCW5MlbJrffBLFsa+y8QUCUbio1GmAoXic9HwsApeL9lJez8QM?=
 =?us-ascii?Q?jIIl3SGMaff8BFPaMOqs6LyhN+PDtxZEKmtLi6Fp9qH3DkNwow0qday8dpr2?=
 =?us-ascii?Q?glg19nvRxUeN+Oay1BpVJ8nTonh4eq/6/21oXjIa3kxpAzOcDkyy9yZBhQ+3?=
 =?us-ascii?Q?gaYd/EV6zugv35md7qoOlTADxo7Q+FQmgGZgHGaJICQ+OLcpRHbHZI/vPNji?=
 =?us-ascii?Q?VxADZwH9eUZaZx9FBtuKniklKADNA4sNjaYGvyqrVBeQkzzJ+QE6Ax7KOic9?=
 =?us-ascii?Q?AQHBig5xhSOVCwm0I+krdUjDPDBsTRATGmKugDrBkLI5hx55LbCuLq4aCwxv?=
 =?us-ascii?Q?YFGmEWMXoo0FZmrNpyV8bAc3kBEyGbUkDE14Io3bPAhkbmr+D0RY8toEpYbn?=
 =?us-ascii?Q?hEVMQ98qzPJg5NjMfF6v1qjiRiEMJqBBZSx23xjCOx6hBz2bcuDfUxud+qzR?=
 =?us-ascii?Q?QwJdy+I8OjsPqhE9yLREkFPwEBq8v7j2+JdtPeVkA6U7/l9j+qywIcSGQfDn?=
 =?us-ascii?Q?pRO3PMkHIlQJudlVPVLXs8bDX0pXOLaj85bIhyYM6VYhqh7jwSR2U6ie0GtF?=
 =?us-ascii?Q?uwsBAlbyY4VfsP8rUY6UBtnBhXnwZ5Q9IvR/jgEEBh1p69m+e5bcQJ6b6GiN?=
 =?us-ascii?Q?6NCe7ZTHio5fafNNUrVHM+JpAJfE2szEGtv4FJ3Y5o3rUOxBDIYhbegSInrI?=
 =?us-ascii?Q?4TfT0UvAHTwIXoJF/nIoDM+5zCzQ4JGMnwV6grjv7EoI6JoNUc1Htsdkb5p8?=
 =?us-ascii?Q?Gmt+7cGFEvAwJ4qIZ+N/VpBIxTWYjM7xGgSbQ5t2bzhVLm1P2jmIAynW4xi3?=
 =?us-ascii?Q?ygYSIV7J7FiHhBLAey/sv8ztyTBxVH4ams1j6Y8WTBJ9BQo+dMmiRdDGXsB6?=
 =?us-ascii?Q?MddB9cGK?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d5428b6-5fc3-46b9-277b-08d8c8ff0fa6
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB6800.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2021 11:21:48.1421
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: N9dof9RAoFL40OUUYh00HaLwSIoNbqPgVBo6QQqlUW5OkjaIWolN/gQDwoKYxUrEff3W7wT0pZZgOW9pDTFnZg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6366
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Driver uses dma_alloc_coherent to allocate dma memory for descriptors,
dma_alloc_coherent will return both the virtual address and physical
address. AFAIK, virt_to_phys could not convert virtual address to
physical address, for which memory is allocated by dma_alloc_coherent.

Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
---
 .../ethernet/stmicro/stmmac/dwmac4_descs.c    |  7 +--
 .../net/ethernet/stmicro/stmmac/enh_desc.c    |  7 +--
 drivers/net/ethernet/stmicro/stmmac/hwif.h    |  3 +-
 .../net/ethernet/stmicro/stmmac/norm_desc.c   |  7 +--
 .../net/ethernet/stmicro/stmmac/stmmac_main.c | 54 ++++++++++++-------
 5 files changed, 49 insertions(+), 29 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4_descs.c b/drivers/net/ethernet/stmicro/stmmac/dwmac4_descs.c
index c6540b003b43..6f951adc5f90 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_descs.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_descs.c
@@ -402,7 +402,8 @@ static void dwmac4_rd_set_tx_ic(struct dma_desc *p)
 	p->des2 |= cpu_to_le32(TDES2_INTERRUPT_ON_COMPLETION);
 }
 
-static void dwmac4_display_ring(void *head, unsigned int size, bool rx)
+static void dwmac4_display_ring(void *head, unsigned int size, bool rx,
+				dma_addr_t dma_rx_phy, unsigned int desc_size)
 {
 	struct dma_desc *p = (struct dma_desc *)head;
 	int i;
@@ -410,8 +411,8 @@ static void dwmac4_display_ring(void *head, unsigned int size, bool rx)
 	pr_info("%s descriptor ring:\n", rx ? "RX" : "TX");
 
 	for (i = 0; i < size; i++) {
-		pr_info("%03d [0x%x]: 0x%x 0x%x 0x%x 0x%x\n",
-			i, (unsigned int)virt_to_phys(p),
+		pr_info("%03d [0x%llx]: 0x%x 0x%x 0x%x 0x%x\n",
+			i, (unsigned long long)(dma_rx_phy + i * desc_size),
 			le32_to_cpu(p->des0), le32_to_cpu(p->des1),
 			le32_to_cpu(p->des2), le32_to_cpu(p->des3));
 		p++;
diff --git a/drivers/net/ethernet/stmicro/stmmac/enh_desc.c b/drivers/net/ethernet/stmicro/stmmac/enh_desc.c
index d02cec296f51..eaea4cf02386 100644
--- a/drivers/net/ethernet/stmicro/stmmac/enh_desc.c
+++ b/drivers/net/ethernet/stmicro/stmmac/enh_desc.c
@@ -417,7 +417,8 @@ static int enh_desc_get_rx_timestamp_status(void *desc, void *next_desc,
 	}
 }
 
-static void enh_desc_display_ring(void *head, unsigned int size, bool rx)
+static void enh_desc_display_ring(void *head, unsigned int size, bool rx,
+				  dma_addr_t dma_rx_phy, unsigned int desc_size)
 {
 	struct dma_extended_desc *ep = (struct dma_extended_desc *)head;
 	int i;
@@ -428,8 +429,8 @@ static void enh_desc_display_ring(void *head, unsigned int size, bool rx)
 		u64 x;
 
 		x = *(u64 *)ep;
-		pr_info("%03d [0x%x]: 0x%x 0x%x 0x%x 0x%x\n",
-			i, (unsigned int)virt_to_phys(ep),
+		pr_info("%03d [0x%llx]: 0x%x 0x%x 0x%x 0x%x\n",
+			i, (unsigned long long)(dma_rx_phy + i * desc_size),
 			(unsigned int)x, (unsigned int)(x >> 32),
 			ep->basic.des2, ep->basic.des3);
 		ep++;
diff --git a/drivers/net/ethernet/stmicro/stmmac/hwif.h b/drivers/net/ethernet/stmicro/stmmac/hwif.h
index b40b2e0667bb..7417db31402f 100644
--- a/drivers/net/ethernet/stmicro/stmmac/hwif.h
+++ b/drivers/net/ethernet/stmicro/stmmac/hwif.h
@@ -78,7 +78,8 @@ struct stmmac_desc_ops {
 	/* get rx timestamp status */
 	int (*get_rx_timestamp_status)(void *desc, void *next_desc, u32 ats);
 	/* Display ring */
-	void (*display_ring)(void *head, unsigned int size, bool rx);
+	void (*display_ring)(void *head, unsigned int size, bool rx,
+			     dma_addr_t dma_rx_phy, unsigned int desc_size);
 	/* set MSS via context descriptor */
 	void (*set_mss)(struct dma_desc *p, unsigned int mss);
 	/* get descriptor skbuff address */
diff --git a/drivers/net/ethernet/stmicro/stmmac/norm_desc.c b/drivers/net/ethernet/stmicro/stmmac/norm_desc.c
index f083360e4ba6..36e769d2e312 100644
--- a/drivers/net/ethernet/stmicro/stmmac/norm_desc.c
+++ b/drivers/net/ethernet/stmicro/stmmac/norm_desc.c
@@ -269,7 +269,8 @@ static int ndesc_get_rx_timestamp_status(void *desc, void *next_desc, u32 ats)
 		return 1;
 }
 
-static void ndesc_display_ring(void *head, unsigned int size, bool rx)
+static void ndesc_display_ring(void *head, unsigned int size, bool rx,
+			       dma_addr_t dma_rx_phy, unsigned int desc_size)
 {
 	struct dma_desc *p = (struct dma_desc *)head;
 	int i;
@@ -280,8 +281,8 @@ static void ndesc_display_ring(void *head, unsigned int size, bool rx)
 		u64 x;
 
 		x = *(u64 *)p;
-		pr_info("%03d [0x%x]: 0x%x 0x%x 0x%x 0x%x",
-			i, (unsigned int)virt_to_phys(p),
+		pr_info("%03d [0x%llx]: 0x%x 0x%x 0x%x 0x%x",
+			i, (unsigned long long)(dma_rx_phy + i * desc_size),
 			(unsigned int)x, (unsigned int)(x >> 32),
 			p->des2, p->des3);
 		p++;
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 12ed337a239b..b1950fd4eb80 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -1133,6 +1133,7 @@ static int stmmac_phy_setup(struct stmmac_priv *priv)
 static void stmmac_display_rx_rings(struct stmmac_priv *priv)
 {
 	u32 rx_cnt = priv->plat->rx_queues_to_use;
+	unsigned int desc_size;
 	void *head_rx;
 	u32 queue;
 
@@ -1142,19 +1143,24 @@ static void stmmac_display_rx_rings(struct stmmac_priv *priv)
 
 		pr_info("\tRX Queue %u rings\n", queue);
 
-		if (priv->extend_desc)
+		if (priv->extend_desc) {
 			head_rx = (void *)rx_q->dma_erx;
-		else
+			desc_size = sizeof(struct dma_extended_desc);
+		} else {
 			head_rx = (void *)rx_q->dma_rx;
+			desc_size = sizeof(struct dma_desc);
+		}
 
 		/* Display RX ring */
-		stmmac_display_ring(priv, head_rx, priv->dma_rx_size, true);
+		stmmac_display_ring(priv, head_rx, priv->dma_rx_size, true,
+				    rx_q->dma_rx_phy, desc_size);
 	}
 }
 
 static void stmmac_display_tx_rings(struct stmmac_priv *priv)
 {
 	u32 tx_cnt = priv->plat->tx_queues_to_use;
+	unsigned int desc_size;
 	void *head_tx;
 	u32 queue;
 
@@ -1164,14 +1170,19 @@ static void stmmac_display_tx_rings(struct stmmac_priv *priv)
 
 		pr_info("\tTX Queue %d rings\n", queue);
 
-		if (priv->extend_desc)
+		if (priv->extend_desc) {
 			head_tx = (void *)tx_q->dma_etx;
-		else if (tx_q->tbs & STMMAC_TBS_AVAIL)
+			desc_size = sizeof(struct dma_extended_desc);
+		} else if (tx_q->tbs & STMMAC_TBS_AVAIL) {
 			head_tx = (void *)tx_q->dma_entx;
-		else
+			desc_size = sizeof(struct dma_edesc);
+		} else {
 			head_tx = (void *)tx_q->dma_tx;
+			desc_size = sizeof(struct dma_desc);
+		}
 
-		stmmac_display_ring(priv, head_tx, priv->dma_tx_size, false);
+		stmmac_display_ring(priv, head_tx, priv->dma_tx_size, false,
+				    tx_q->dma_tx_phy, desc_size);
 	}
 }
 
@@ -3736,18 +3747,23 @@ static int stmmac_rx(struct stmmac_priv *priv, int limit, u32 queue)
 	unsigned int count = 0, error = 0, len = 0;
 	int status = 0, coe = priv->hw->rx_csum;
 	unsigned int next_entry = rx_q->cur_rx;
+	unsigned int desc_size;
 	struct sk_buff *skb = NULL;
 
 	if (netif_msg_rx_status(priv)) {
 		void *rx_head;
 
 		netdev_dbg(priv->dev, "%s: descriptor ring:\n", __func__);
-		if (priv->extend_desc)
+		if (priv->extend_desc) {
 			rx_head = (void *)rx_q->dma_erx;
-		else
+			desc_size = sizeof(struct dma_extended_desc);
+		} else {
 			rx_head = (void *)rx_q->dma_rx;
+			desc_size = sizeof(struct dma_desc);
+		}
 
-		stmmac_display_ring(priv, rx_head, priv->dma_rx_size, true);
+		stmmac_display_ring(priv, rx_head, priv->dma_rx_size, true,
+				    rx_q->dma_rx_phy, desc_size);
 	}
 	while (count < limit) {
 		unsigned int buf1_len = 0, buf2_len = 0;
@@ -4315,7 +4331,7 @@ static int stmmac_set_mac_address(struct net_device *ndev, void *addr)
 static struct dentry *stmmac_fs_dir;
 
 static void sysfs_display_ring(void *head, int size, int extend_desc,
-			       struct seq_file *seq)
+			       struct seq_file *seq, dma_addr_t dma_phy_addr)
 {
 	int i;
 	struct dma_extended_desc *ep = (struct dma_extended_desc *)head;
@@ -4323,16 +4339,16 @@ static void sysfs_display_ring(void *head, int size, int extend_desc,
 
 	for (i = 0; i < size; i++) {
 		if (extend_desc) {
-			seq_printf(seq, "%d [0x%x]: 0x%x 0x%x 0x%x 0x%x\n",
-				   i, (unsigned int)virt_to_phys(ep),
+			seq_printf(seq, "%d [0x%llx]: 0x%x 0x%x 0x%x 0x%x\n",
+				   i, (unsigned long long)(dma_phy_addr + i * sizeof(ep)),
 				   le32_to_cpu(ep->basic.des0),
 				   le32_to_cpu(ep->basic.des1),
 				   le32_to_cpu(ep->basic.des2),
 				   le32_to_cpu(ep->basic.des3));
 			ep++;
 		} else {
-			seq_printf(seq, "%d [0x%x]: 0x%x 0x%x 0x%x 0x%x\n",
-				   i, (unsigned int)virt_to_phys(p),
+			seq_printf(seq, "%d [0x%llx]: 0x%x 0x%x 0x%x 0x%x\n",
+				   i, (unsigned long long)(dma_phy_addr + i * sizeof(p)),
 				   le32_to_cpu(p->des0), le32_to_cpu(p->des1),
 				   le32_to_cpu(p->des2), le32_to_cpu(p->des3));
 			p++;
@@ -4360,11 +4376,11 @@ static int stmmac_rings_status_show(struct seq_file *seq, void *v)
 		if (priv->extend_desc) {
 			seq_printf(seq, "Extended descriptor ring:\n");
 			sysfs_display_ring((void *)rx_q->dma_erx,
-					   priv->dma_rx_size, 1, seq);
+					   priv->dma_rx_size, 1, seq, rx_q->dma_rx_phy);
 		} else {
 			seq_printf(seq, "Descriptor ring:\n");
 			sysfs_display_ring((void *)rx_q->dma_rx,
-					   priv->dma_rx_size, 0, seq);
+					   priv->dma_rx_size, 0, seq, rx_q->dma_rx_phy);
 		}
 	}
 
@@ -4376,11 +4392,11 @@ static int stmmac_rings_status_show(struct seq_file *seq, void *v)
 		if (priv->extend_desc) {
 			seq_printf(seq, "Extended descriptor ring:\n");
 			sysfs_display_ring((void *)tx_q->dma_etx,
-					   priv->dma_tx_size, 1, seq);
+					   priv->dma_tx_size, 1, seq, tx_q->dma_tx_phy);
 		} else if (!(tx_q->tbs & STMMAC_TBS_AVAIL)) {
 			seq_printf(seq, "Descriptor ring:\n");
 			sysfs_display_ring((void *)tx_q->dma_tx,
-					   priv->dma_tx_size, 0, seq);
+					   priv->dma_tx_size, 0, seq, tx_q->dma_tx_phy);
 		}
 	}
 
-- 
2.17.1

