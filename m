Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D94A122C30
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 13:46:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728277AbfLQMqV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 07:46:21 -0500
Received: from smtprelay-out1.synopsys.com ([149.117.87.133]:38876 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727576AbfLQMqU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 07:46:20 -0500
Received: from mailhost.synopsys.com (mdc-mailhost2.synopsys.com [10.225.0.210])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 63AFDC00D6;
        Tue, 17 Dec 2019 12:46:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1576586780; bh=llvgGrumShiuBeIdyIGzEeURrXNPj/+om1MXWeErZwE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=IBDFwlBp+P2Vu88u9KjVsJFM6WbcROqtTh6Om02X4HCxSeIwKfE5Fv/BKPM6QAl98
         Ncsj7FBWCItcyzB5SBW5MK1omI4TONvFT+pUcQnU3sv/OrO/cYduEaywg7ANGG8zBk
         wCGxgaseWiray55Hx4sEYHXGVTU66DEQDPrZMFpD2PjlDmI4aWUtDBNAgRIWL7Y4sB
         vwJ6yXJtZ0fhMc713MMKb0E9eIONlrxVJgH//TlOBxBpkDaEQA8POepP3fRN50gKrt
         eekvVzd5flKiiUskZN4z7FsAQr7kXR1ke2hmLk/j18HWtOe+iORkZJfzR1/wnuIcAw
         v7wfAiTkyE/Dg==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id B065CA0087;
        Tue, 17 Dec 2019 12:46:17 +0000 (UTC)
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     netdev@vger.kernel.org
Cc:     Joao Pinto <Joao.Pinto@synopsys.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2 1/7] net: stmmac: Print more information in DebugFS DMA Capabilities file
Date:   Tue, 17 Dec 2019 13:46:05 +0100
Message-Id: <827bd9655694b9278734f7fc33f9ec8dd837a0e0.1576586602.git.Jose.Abreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1576586602.git.Jose.Abreu@synopsys.com>
References: <cover.1576586602.git.Jose.Abreu@synopsys.com>
In-Reply-To: <cover.1576586602.git.Jose.Abreu@synopsys.com>
References: <cover.1576586602.git.Jose.Abreu@synopsys.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DMA Capabilites have grown but the DebugFS that shows this info has not
been updated. Lets add the missing information.

Signed-off-by: Jose Abreu <Jose.Abreu@synopsys.com>

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
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 31 ++++++++++++++++++++++-
 1 file changed, 30 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index da80866d0371..3299f5bb02e2 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -4238,9 +4238,38 @@ static int stmmac_dma_cap_show(struct seq_file *seq, void *v)
 		   priv->dma_cap.number_rx_channel);
 	seq_printf(seq, "\tNumber of Additional TX channel: %d\n",
 		   priv->dma_cap.number_tx_channel);
+	seq_printf(seq, "\tNumber of Additional RX queues: %d\n",
+		   priv->dma_cap.number_rx_queues);
+	seq_printf(seq, "\tNumber of Additional TX queues: %d\n",
+		   priv->dma_cap.number_tx_queues);
 	seq_printf(seq, "\tEnhanced descriptors: %s\n",
 		   (priv->dma_cap.enh_desc) ? "Y" : "N");
-
+	seq_printf(seq, "\tTX Fifo Size: %d\n", priv->dma_cap.tx_fifo_size);
+	seq_printf(seq, "\tRX Fifo Size: %d\n", priv->dma_cap.rx_fifo_size);
+	seq_printf(seq, "\tHash Table Size: %d\n", priv->dma_cap.hash_tb_sz);
+	seq_printf(seq, "\tTSO: %s\n", priv->dma_cap.tsoen ? "Y" : "N");
+	seq_printf(seq, "\tNumber of PPS Outputs: %d\n",
+		   priv->dma_cap.pps_out_num);
+	seq_printf(seq, "\tSafety Features: %s\n",
+		   priv->dma_cap.asp ? "Y" : "N");
+	seq_printf(seq, "\tFlexible RX Parser: %s\n",
+		   priv->dma_cap.frpsel ? "Y" : "N");
+	seq_printf(seq, "\tEnhanced Addressing: %d\n",
+		   priv->dma_cap.addr64);
+	seq_printf(seq, "\tReceive Side Scaling: %s\n",
+		   priv->dma_cap.rssen ? "Y" : "N");
+	seq_printf(seq, "\tVLAN Hash Filtering: %s\n",
+		   priv->dma_cap.vlhash ? "Y" : "N");
+	seq_printf(seq, "\tSplit Header: %s\n",
+		   priv->dma_cap.sphen ? "Y" : "N");
+	seq_printf(seq, "\tVLAN TX Insertion: %s\n",
+		   priv->dma_cap.vlins ? "Y" : "N");
+	seq_printf(seq, "\tDouble VLAN: %s\n",
+		   priv->dma_cap.dvlan ? "Y" : "N");
+	seq_printf(seq, "\tNumber of L3/L4 Filters: %d\n",
+		   priv->dma_cap.l3l4fnum);
+	seq_printf(seq, "\tARP Offloading: %s\n",
+		   priv->dma_cap.arpoffsel ? "Y" : "N");
 	return 0;
 }
 DEFINE_SHOW_ATTRIBUTE(stmmac_dma_cap);
-- 
2.7.4

