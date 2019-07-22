Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 237636FB79
	for <lists+netdev@lfdr.de>; Mon, 22 Jul 2019 10:40:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728532AbfGVIjx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jul 2019 04:39:53 -0400
Received: from dc2-smtprelay2.synopsys.com ([198.182.61.142]:45708 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728351AbfGVIjw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jul 2019 04:39:52 -0400
Received: from mailhost.synopsys.com (mdc-mailhost1.synopsys.com [10.225.0.209])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id EE79AC1229;
        Mon, 22 Jul 2019 08:39:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1563784792; bh=yGAQYcxlEpE1qJEzwwdp1Ab0QN/5jmO1Cs2waCXk0JQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=ZhV4Ck3PJZWZNhsDBpAKMNSCZQLjIbXp8jiLjVW1RdZG9LvwYFsCgGFB1mYa2JeoB
         jV1+MltoMmR5u689/H4+BERca4XdwjXnVZa6RlHoE3HoBVvxc1eG8i17f5dhmUqG7p
         F+cJF11Y8BL9i6GxpkKO6oR86tMGZnecNsyRtnJc+Jq3av7nka4YwkIln8xIl6Vfzc
         yHIGCOrqX84sg5bU30AanVYPisc9aROYwMRj64fyQ19OxFQBad1VyrwsA0gZooe03Y
         y/If28nd4JM5q6csZ6/+xVhZQL15qkJG7MwohR8MZ02j9nzbwKYMQxfmuzqMJaTcZ9
         Mfu8hTvQpF0cg==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id 6C8D3A0061;
        Mon, 22 Jul 2019 08:39:50 +0000 (UTC)
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     netdev@vger.kernel.org
Cc:     Joao Pinto <Joao.Pinto@synopsys.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH net 2/2] net: stmmac: Use kcalloc() instead of kmalloc_array()
Date:   Mon, 22 Jul 2019 10:39:31 +0200
Message-Id: <95ab7c8083e5cd42cf6d4c5e1531e30cab540ff2.1563784666.git.joabreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1563784666.git.joabreu@synopsys.com>
References: <cover.1563784666.git.joabreu@synopsys.com>
In-Reply-To: <cover.1563784666.git.joabreu@synopsys.com>
References: <cover.1563784666.git.joabreu@synopsys.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We need the memory to be zeroed upon allocation so use kcalloc()
instead.

Signed-off-by: Jose Abreu <joabreu@synopsys.com>

---
Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>
Cc: Alexandre Torgue <alexandre.torgue@st.com>
Cc: Jose Abreu <joabreu@synopsys.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc: netdev@vger.kernel.org
Cc: linux-stm32@st-md-mailman.stormreply.com
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 5f1294ce0216..0ac79f3e2cee 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -1555,9 +1555,8 @@ static int alloc_dma_rx_desc_resources(struct stmmac_priv *priv)
 			goto err_dma;
 		}
 
-		rx_q->buf_pool = kmalloc_array(DMA_RX_SIZE,
-					       sizeof(*rx_q->buf_pool),
-					       GFP_KERNEL);
+		rx_q->buf_pool = kcalloc(DMA_RX_SIZE, sizeof(*rx_q->buf_pool),
+					 GFP_KERNEL);
 		if (!rx_q->buf_pool)
 			goto err_dma;
 
@@ -1608,15 +1607,15 @@ static int alloc_dma_tx_desc_resources(struct stmmac_priv *priv)
 		tx_q->queue_index = queue;
 		tx_q->priv_data = priv;
 
-		tx_q->tx_skbuff_dma = kmalloc_array(DMA_TX_SIZE,
-						    sizeof(*tx_q->tx_skbuff_dma),
-						    GFP_KERNEL);
+		tx_q->tx_skbuff_dma = kcalloc(DMA_TX_SIZE,
+					      sizeof(*tx_q->tx_skbuff_dma),
+					      GFP_KERNEL);
 		if (!tx_q->tx_skbuff_dma)
 			goto err_dma;
 
-		tx_q->tx_skbuff = kmalloc_array(DMA_TX_SIZE,
-						sizeof(struct sk_buff *),
-						GFP_KERNEL);
+		tx_q->tx_skbuff = kcalloc(DMA_TX_SIZE,
+					  sizeof(struct sk_buff *),
+					  GFP_KERNEL);
 		if (!tx_q->tx_skbuff)
 			goto err_dma;
 
-- 
2.7.4

