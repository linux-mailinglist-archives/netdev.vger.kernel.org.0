Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81F8F62B709
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 10:57:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231189AbiKPJ5q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 04:57:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230113AbiKPJ5p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 04:57:45 -0500
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96CE41581B
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 01:57:44 -0800 (PST)
Received: by mail-ej1-x629.google.com with SMTP id bj12so42699330ejb.13
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 01:57:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:organization:mime-version:message-id:date
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=0M3+yAItVcEldWHZJ8yrtq0ThUthpYirdN6lmQF1dMc=;
        b=gSdUK3SSKCcxqJdf+/Td5BI86rlpclk8Kk4gKhYzIZxNcr67E/JJ7Km9ouynbtw34X
         fRin+w2qyNiNprXAOwZsDGKJLgnw8+chlhSkUY1k5tijF5rYuj6E24yS+9wQY+wDdslJ
         3nIf8K0/dbkUgsIEMz0VJWT278OGx4+uuz9v4edjSnI6t9lhjl3raLeSmruYf5DJ3UQd
         N5d2icO4u42Rh3ckYY20avn/p7EbnqFF8AGwr/qf34kKDy9daKqBHEufTH3ZJdmw9WTT
         QwbA9MyeP0gvU585M4f7d7bIKizPTtNfwAiiHR5I2pHmaXNV6/VCMVGb5RKdDsT4h44D
         GEPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:organization:mime-version:message-id:date
         :subject:cc:to:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0M3+yAItVcEldWHZJ8yrtq0ThUthpYirdN6lmQF1dMc=;
        b=iVRLtK1DXFWuFzkuSwMQQ7USaLZTzj7SNqVoK/rm/hWMq3fp+Nwd5j3zRK7RFBsomS
         xt36BW1inDV414Z8okRluUTKzBwv91H2Bcck0p/8m+7l39huzLMz9eFWjmHHBgmSKg7z
         5FRTumHG+UoOCjcI20a838O+zOyOakoOsj8izZJkgNHHHzcHAAyBccTb/va6YsmtxQLU
         eAcyghWcynPAIUPR3V3rkfrNcC8cIcMJzFFDaWEmk9wPIG+XAEQTnJ8vGNczkx6G5c6f
         Z3FV8JQxcnVCKKQkxNlwRdFlmIYNiUmLspfqHnndhdw99V/v9QcVT5Z/rl9sjOgBF+8C
         aRDg==
X-Gm-Message-State: ANoB5pmjDWr0iLpkDJuO/mL3PalFF1tfuqjYbB2uDEiuxOOPOKnGYMvR
        C3hVagrBx/747AT2h3ydSps=
X-Google-Smtp-Source: AA0mqf7lb+ic65FOLSWZdMb5BOtWmBroCKo11B0EfxSRaOQk+gutKG803FQpcFDnVvd1pQSBTNof9g==
X-Received: by 2002:a17:906:a194:b0:78d:3e6b:d402 with SMTP id s20-20020a170906a19400b0078d3e6bd402mr16732648ejy.563.1668592663088;
        Wed, 16 Nov 2022 01:57:43 -0800 (PST)
Received: from wse-c0155.labs.westermo.se (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id x16-20020a170906135000b0073d84a321c8sm6600572ejb.166.2022.11.16.01.57.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Nov 2022 01:57:42 -0800 (PST)
From:   Casper Andersson <casper.casan@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Daniel Machon <daniel.machon@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Richard Cochran <richardcochran@gmail.com>,
        netdev@vger.kernel.org,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net] net: microchip: sparx5: correctly free skb in xmit
Date:   Wed, 16 Nov 2022 10:57:40 +0100
Message-Id: <20221116095740.176286-1-casper.casan@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Organization: Westermo Network Technologies AB
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

consume_skb on transmitted, kfree_skb on dropped, do not free on TX_BUSY.

Previously the xmit function could return -EBUSY without freeing, which
supposedly is interpreted as a drop. And was using kfree on successfully
transmitted packets.
https://lore.kernel.org/netdev/20220920072948.33c25dd2@kernel.org/t/#mdb821eb507a207dd5e27683239ffa7ec7199421a

Fixes: 10615907e9b5 ("net: sparx5: switchdev: adding frame DMA functionality")
Signed-off-by: Casper Andersson <casper.casan@gmail.com>
---
I am not entirely sure about the following construct which is present in
both sparx5 and lan966x drivers and returns before consuming the skb. Is
there any reason it does not free the skb?

if (skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP &&
    SPARX5_SKB_CB(skb)->rew_op == IFH_REW_OP_TWO_STEP_PTP)
	return NETDEV_TX_OK;




 .../ethernet/microchip/sparx5/sparx5_fdma.c   |  2 +-
 .../ethernet/microchip/sparx5/sparx5_main.h   |  2 +-
 .../ethernet/microchip/sparx5/sparx5_packet.c | 47 ++++++++++---------
 3 files changed, 27 insertions(+), 24 deletions(-)

diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_fdma.c b/drivers/net/ethernet/microchip/sparx5/sparx5_fdma.c
index 66360c8c5a38..302e7ff55585 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_fdma.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_fdma.c
@@ -306,7 +306,7 @@ static struct sparx5_tx_dcb_hw *sparx5_fdma_next_dcb(struct sparx5_tx *tx,
 	return next_dcb;
 }
 
-int sparx5_fdma_xmit(struct sparx5 *sparx5, u32 *ifh, struct sk_buff *skb)
+netdev_tx_t sparx5_fdma_xmit(struct sparx5 *sparx5, u32 *ifh, struct sk_buff *skb)
 {
 	struct sparx5_tx_dcb_hw *next_dcb_hw;
 	struct sparx5_tx *tx = &sparx5->tx;
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_main.h b/drivers/net/ethernet/microchip/sparx5/sparx5_main.h
index 7a83222caa73..34b8d11f76df 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_main.h
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_main.h
@@ -312,7 +312,7 @@ void sparx5_port_inj_timer_setup(struct sparx5_port *port);
 /* sparx5_fdma.c */
 int sparx5_fdma_start(struct sparx5 *sparx5);
 int sparx5_fdma_stop(struct sparx5 *sparx5);
-int sparx5_fdma_xmit(struct sparx5 *sparx5, u32 *ifh, struct sk_buff *skb);
+netdev_tx_t sparx5_fdma_xmit(struct sparx5 *sparx5, u32 *ifh, struct sk_buff *skb);
 irqreturn_t sparx5_fdma_handler(int irq, void *args);
 
 /* sparx5_mactable.c */
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_packet.c b/drivers/net/ethernet/microchip/sparx5/sparx5_packet.c
index 83c16ca5b30f..6fc1c1e410f6 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_packet.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_packet.c
@@ -159,10 +159,10 @@ static void sparx5_xtr_grp(struct sparx5 *sparx5, u8 grp, bool byte_swap)
 	netif_rx(skb);
 }
 
-static int sparx5_inject(struct sparx5 *sparx5,
-			 u32 *ifh,
-			 struct sk_buff *skb,
-			 struct net_device *ndev)
+static netdev_tx_t sparx5_inject(struct sparx5 *sparx5,
+				 u32 *ifh,
+				 struct sk_buff *skb,
+				 struct net_device *ndev)
 {
 	int grp = INJ_QUEUE;
 	u32 val, w, count;
@@ -172,7 +172,7 @@ static int sparx5_inject(struct sparx5 *sparx5,
 	if (!(QS_INJ_STATUS_FIFO_RDY_GET(val) & BIT(grp))) {
 		pr_err_ratelimited("Injection: Queue not ready: 0x%lx\n",
 				   QS_INJ_STATUS_FIFO_RDY_GET(val));
-		return -EBUSY;
+		return NETDEV_TX_BUSY;
 	}
 
 	/* Indicate SOF */
@@ -234,9 +234,8 @@ netdev_tx_t sparx5_port_xmit_impl(struct sk_buff *skb, struct net_device *dev)
 	sparx5_set_port_ifh(ifh, port->portno);
 
 	if (sparx5->ptp && skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP) {
-		ret = sparx5_ptp_txtstamp_request(port, skb);
-		if (ret)
-			return ret;
+		if (sparx5_ptp_txtstamp_request(port, skb))
+			goto drop;
 
 		sparx5_set_port_ifh_rew_op(ifh, SPARX5_SKB_CB(skb)->rew_op);
 		sparx5_set_port_ifh_pdu_type(ifh, SPARX5_SKB_CB(skb)->pdu_type);
@@ -250,23 +249,27 @@ netdev_tx_t sparx5_port_xmit_impl(struct sk_buff *skb, struct net_device *dev)
 	else
 		ret = sparx5_inject(sparx5, ifh, skb, dev);
 
-	if (ret == NETDEV_TX_OK) {
-		stats->tx_bytes += skb->len;
-		stats->tx_packets++;
+	if (ret == NETDEV_TX_BUSY)
+		goto busy;
 
-		if (skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP &&
-		    SPARX5_SKB_CB(skb)->rew_op == IFH_REW_OP_TWO_STEP_PTP)
-			return ret;
+	stats->tx_bytes += skb->len;
+	stats->tx_packets++;
 
-		dev_kfree_skb_any(skb);
-	} else {
-		stats->tx_dropped++;
+	if (skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP &&
+	    SPARX5_SKB_CB(skb)->rew_op == IFH_REW_OP_TWO_STEP_PTP)
+		return NETDEV_TX_OK;
 
-		if (skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP &&
-		    SPARX5_SKB_CB(skb)->rew_op == IFH_REW_OP_TWO_STEP_PTP)
-			sparx5_ptp_txtstamp_release(port, skb);
-	}
-	return ret;
+	dev_consume_skb_any(skb);
+	return NETDEV_TX_OK;
+drop:
+	stats->tx_dropped++;
+	dev_kfree_skb_any(skb);
+	return NETDEV_TX_OK;
+busy:
+	if (skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP &&
+	    SPARX5_SKB_CB(skb)->rew_op == IFH_REW_OP_TWO_STEP_PTP)
+		sparx5_ptp_txtstamp_release(port, skb);
+	return NETDEV_TX_BUSY;
 }
 
 static enum hrtimer_restart sparx5_injection_timeout(struct hrtimer *tmr)
-- 
2.34.1

