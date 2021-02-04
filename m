Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B4AE30F1FB
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 12:24:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235718AbhBDLX3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 06:23:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235731AbhBDLXI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Feb 2021 06:23:08 -0500
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04on062c.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe0d::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10E41C061786
        for <netdev@vger.kernel.org>; Thu,  4 Feb 2021 03:22:23 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MkkTFejLQNf5c6KEqgU6HRwNvgu3ZwlqSvg1Br+bo1IfiAa/Mr7r2sKWOPdWOZrg/1kyYdGj/p3DpkpdoTWuZpqWB1KBzwvvkbaLmYltEx+PENzbUBJ0df7NGsq3sD2psDgvdSqEEZ7qpwMQ6L1CDJ4pNJxqE2xQRcOng6krV2kvP/oVAoVZWRrZmdlLwPPp204cK1Z5QYyXkyVj5jY0KBJ9JSlJFDgLmkcxisF0zfkJCBMmMcsUg3wRveYmQ2l9HKY54fuKKEfZ4ieWbj2DRUlRxsvSfP6lyA3G4vqdhRLOsFyV5MWwujyHQ9b2Db1z4Pv8+GfApXXIebDU7IsFpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8pa0QoH5JhUGs0bwqoZBnXc9kei9tkMubKUdOHk+pPk=;
 b=gomKsevch//C8ET657Bahwsp1xKyHZ5Zq2a+PQFP8ttXtpwLS6J7XGFfOlSdMNVIwaH/8Cbh368ahRw9j5nDUxeqcSTcf6VgTWABvjKfu6mee9WvwQD20eOUvA93J+vvRvXQvmmJdZYpq1sn7da7b/vlltbX1aowTHwSFhtDwDTvHNWAQxOFItJhtBfdVsVnUbNKQ5W1kmaoz3aeS9iVeQcDXxCGHCJQoXC3NFrBPr30NNJeaSDIlP3AhvXwr1RvuHyyEUhTHyDV5WWFNLBzdPRx/n14jpvYXGCI8S9dN9p2hzgB2Oe9bEC/D2eYJ31p+eUL2mLa86H3NRQqkQxwTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8pa0QoH5JhUGs0bwqoZBnXc9kei9tkMubKUdOHk+pPk=;
 b=SqAaWb4r9ZfTSvwaSvftwyd7ATcz/kVlEwLzQFCW/AUjtKMJ99t6n5Um0ipZTufLRfPSvf3MCU3gLjarvgYcd7HaeU0rt3QeFP/ezfGrXGifwn8eoH33j8koYcH8XO70/jcyEMQ+LUu4BmSbld1HEMbdOLCCVRL+VD/8Z2TVM9E=
Authentication-Results: st.com; dkim=none (message not signed)
 header.d=none;st.com; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB6800.eurprd04.prod.outlook.com (2603:10a6:803:133::16)
 by VE1PR04MB6366.eurprd04.prod.outlook.com (2603:10a6:803:12a::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.15; Thu, 4 Feb
 2021 11:21:55 +0000
Received: from VI1PR04MB6800.eurprd04.prod.outlook.com
 ([fe80::6958:79d5:16bf:5f14]) by VI1PR04MB6800.eurprd04.prod.outlook.com
 ([fe80::6958:79d5:16bf:5f14%9]) with mapi id 15.20.3825.019; Thu, 4 Feb 2021
 11:21:54 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-imx@nxp.com
Subject: [PATCH V4 net 5/5] net: stmmac: re-init rx buffers when mac resume back
Date:   Thu,  4 Feb 2021 19:21:44 +0800
Message-Id: <20210204112144.24163-6-qiangqing.zhang@nxp.com>
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
Received: from localhost.localdomain (119.31.174.71) by SG2PR03CA0128.apcprd03.prod.outlook.com (2603:1096:4:91::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.11 via Frontend Transport; Thu, 4 Feb 2021 11:21:51 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 683dd735-8a6c-40b4-c181-08d8c8ff133b
X-MS-TrafficTypeDiagnostic: VE1PR04MB6366:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VE1PR04MB63662183AB6734161DECDEC9E6B39@VE1PR04MB6366.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MErOUv/TfcQyAopRjFGlu4nI87eiArTEHLgeN7XT85516V3/Tlu89FxPPH5foAS2zxFNSo+xfnf9FLwwJVupg5gOVdDgMaZ+UV+W0fKwlGK63kQGwTe+PlH/SQERGfQ3HKG6KrbbIAIdVAxvC3hYV8XHr3ixk3/WHqr0CEK3h/3Aq6CqqXPxq6Bkqf5b0f/lA6wgUIWG9eSSU32aW4BWtwdVgy6ZKF+FnUWlUo0berxNceDZ5vP5aSH0Q0p/lOn+poHMUsgfSkZuIUk8MA4D/3wKKyOzNi39XCdVV9AKJcEPZsNpqqXwqlnUfV3asVH8LvPBoFDVuw+6kWqKUwaX0Hvv3tWjymi5QUSTaO7m3YTQUA17w5qxkKIX5hbT1PtS+kJx38hWNiXCKbbbxXdnmZCTyCWs6dDXenbUlkJxirG5b3gOgxCwSPJZFNblSAajd87qbtUqlbh6BZLxcxfX+XLFKO1Qj70P2QT2cOu9EkiuJULzX/WQpNoWLfJy1Qr+Xx4kudvqWGatY0NHZWUK3no/zAPuJkkjdXepq8IrEUz8Ff1ZZ8d4vdvm+/Frdvi++Jszm+IGv8zJ3tx6+P3suQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB6800.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(376002)(346002)(136003)(396003)(316002)(83380400001)(66476007)(478600001)(4326008)(66556008)(66946007)(2906002)(26005)(36756003)(956004)(5660300002)(8676002)(1076003)(6486002)(86362001)(8936002)(69590400011)(186003)(16526019)(52116002)(2616005)(6506007)(6666004)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?pV9Yye7EPDAgffr2Fj4oTPSNRLtZWKuoe2Iz4pQYjh77rF3jBWA2xNomvUMK?=
 =?us-ascii?Q?55VPxOdNSvBtKRoSoU27ac+walwHWAUaNqkcC5CHshe5OKTXxPnst3AbbgR6?=
 =?us-ascii?Q?v5RZlUI/yKtRmnFl6/Cdq6EX3V8FcpMTPgUr0trIhOvHvEVcy7HhWXt6G3az?=
 =?us-ascii?Q?yZWoBNHMHDKu+c1Idpv55pqebFuh/C11pgCAdt4AJOeKP2b+M/L802zK+dea?=
 =?us-ascii?Q?uRMVLaRsCNEmyF+QB8+K5z3t1eFxbiUeUttRTqIleRsAjS3Xwv7GhnzcwKsY?=
 =?us-ascii?Q?Jq7dmTh7SiTktJOdodZ4qlYnL9PA5ohw8Zmc1XOsmhRIFi1ew9qvyty5tV29?=
 =?us-ascii?Q?rSSpMO/p/3Jp736XfPtRnlW1OM+ggwXNtQBXuIidZL395G1pLRurbXe65ZSi?=
 =?us-ascii?Q?PgNZkUKMWpYzJHcQ9byaFrJR9onULlkkP650FjTNYho3BTjQpAzyS1ypfgMk?=
 =?us-ascii?Q?/oCPatMe6439vNctYj2B80TJe83rTaz1jgIxVJTawLDo+GOXXVA4B38PSzv3?=
 =?us-ascii?Q?NxfSGHxRPe4fIHYdfftyzObZH97U3ZHCj4c7x7lKUXDHJKwe6GG9TTuGKnJ6?=
 =?us-ascii?Q?1RTxodIz3egR6cPHZrUF3FbWekcRzRzxveHPTaWGbkSKXU0dBM4OZo7fMUeH?=
 =?us-ascii?Q?OyXGvmfp5RaP2zGfdRikwZzmlvwM5CIykwQCkk9E88T78tFwTBaoec6iqr4S?=
 =?us-ascii?Q?24oF3d6maoreSh+JxZdFFdnQ7fyUO+PlZWHSu27o6dDwdWp3ndYIM317s3eK?=
 =?us-ascii?Q?DijvAk1X/7WuoFVTI4nKoUiapcCY/5mpxscPMn9ZXW3rW92eXMqQ7Psx+jyU?=
 =?us-ascii?Q?n48AQUqk61GC3jXqlOQHPBfcQAfMRAWXTgLu5kqCFO0951tyE2CR4WlcaBXy?=
 =?us-ascii?Q?INqoS8kHQzvGg/ilVqpnMsSCLjEyoqtf+TWSYRx9jvcKMZzXk/J+JxZuE7OI?=
 =?us-ascii?Q?zmyDBZpTnyS0anJApIt65eUJ4A4sxd8FS4RAPRFhz26HXTG45Nm+rf6bmYbv?=
 =?us-ascii?Q?DRmb7klFPGQBIEI0L/jDO9AQ+EZtjpPtwe+wa4QyHeAslE9UrpjNpt/vSiDk?=
 =?us-ascii?Q?hYA9091i?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 683dd735-8a6c-40b4-c181-08d8c8ff133b
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB6800.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2021 11:21:54.0582
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yilp+me/NC/aULwKxn79GB9xzhR4gmQgW07pW3SuCU9t+mM36kTWIyv5FSs9+Lpd1VbXmBcs9XU9yNY9OJ+FNA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6366
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

During suspend/resume stress test, we found descriptor write back by DMA
could exhibit unusual behavior, e.g.:
	003 [0xc4310030]: 0x0 0x40 0x0 0xb5010040

We can see that desc3 write back is 0xb5010040, it is still ownd by DMA,
so application would not recycle this buffer. It will trigger fatal bus
error when DMA try to use this descriptor again. To fix this issue, we
should re-init all rx buffers when mac resume back.

Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
---
 .../net/ethernet/stmicro/stmmac/stmmac_main.c | 87 ++++++++++++++++++-
 1 file changed, 86 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 04ba77775e52..e8e9e5b8c62d 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -1379,6 +1379,91 @@ static void stmmac_free_tx_buffer(struct stmmac_priv *priv, u32 queue, int i)
 	}
 }
 
+/**
+ * stmmac_reinit_rx_buffers - reinit the RX descriptor buffer.
+ * @priv: driver private structure
+ * Description: this function is called to re-allocate a receive buffer, perform
+ * the DMA mapping and init the descriptor.
+ */
+static int stmmac_reinit_rx_buffers(struct stmmac_priv *priv)
+{
+	u32 rx_count = priv->plat->rx_queues_to_use;
+	u32 queue;
+	int i;
+
+	for (queue = 0; queue < rx_count; queue++) {
+		struct stmmac_rx_queue *rx_q = &priv->rx_queue[queue];
+
+		for (i = 0; i < priv->dma_rx_size; i++) {
+			struct stmmac_rx_buffer *buf = &rx_q->buf_pool[i];
+
+			if (buf->page) {
+				page_pool_recycle_direct(rx_q->page_pool, buf->page);
+				buf->page = NULL;
+			}
+
+			if (priv->sph && buf->sec_page) {
+				page_pool_recycle_direct(rx_q->page_pool, buf->sec_page);
+				buf->sec_page = NULL;
+			}
+		}
+	}
+
+	for (queue = 0; queue < rx_count; queue++) {
+		struct stmmac_rx_queue *rx_q = &priv->rx_queue[queue];
+
+		for (i = 0; i < priv->dma_rx_size; i++) {
+			struct stmmac_rx_buffer *buf = &rx_q->buf_pool[i];
+			struct dma_desc *p;
+
+			if (priv->extend_desc)
+				p = &((rx_q->dma_erx + i)->basic);
+			else
+				p = rx_q->dma_rx + i;
+
+			if (!buf->page) {
+				buf->page = page_pool_dev_alloc_pages(rx_q->page_pool);
+				if (!buf->page)
+					goto err_reinit_rx_buffers;
+
+				buf->addr = page_pool_get_dma_addr(buf->page);
+			}
+
+			if (priv->sph && !buf->sec_page) {
+				buf->sec_page = page_pool_dev_alloc_pages(rx_q->page_pool);
+				if (!buf->sec_page)
+					goto err_reinit_rx_buffers;
+
+				buf->sec_addr = page_pool_get_dma_addr(buf->sec_page);
+			}
+
+			stmmac_set_desc_addr(priv, p, buf->addr);
+			if (priv->sph)
+				stmmac_set_desc_sec_addr(priv, p, buf->sec_addr, true);
+			else
+				stmmac_set_desc_sec_addr(priv, p, buf->sec_addr, false);
+			if (priv->dma_buf_sz == BUF_SIZE_16KiB)
+				stmmac_init_desc3(priv, p);
+		}
+	}
+
+	return 0;
+
+err_reinit_rx_buffers:
+	while (queue >= 0) {
+		while (--i >= 0)
+			stmmac_free_rx_buffer(priv, queue, i);
+
+		if (queue == 0)
+			break;
+
+		i = priv->dma_rx_size;
+		queue--;
+	}
+
+	return -ENOMEM;
+}
+
 /**
  * init_dma_rx_desc_rings - init the RX descriptor rings
  * @dev: net device structure
@@ -5340,7 +5425,7 @@ int stmmac_resume(struct device *dev)
 	mutex_lock(&priv->lock);
 
 	stmmac_reset_queues_param(priv);
-
+	stmmac_reinit_rx_buffers(priv);
 	stmmac_free_tx_skbufs(priv);
 	stmmac_clear_descriptors(priv);
 
-- 
2.17.1

