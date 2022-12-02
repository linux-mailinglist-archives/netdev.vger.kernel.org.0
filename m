Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A69C640252
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 09:37:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232584AbiLBIhj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 03:37:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232607AbiLBIhO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 03:37:14 -0500
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31D27BC5BF
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 00:35:49 -0800 (PST)
Received: by mail-lf1-x12f.google.com with SMTP id j4so6406115lfk.0
        for <netdev@vger.kernel.org>; Fri, 02 Dec 2022 00:35:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:organization:mime-version:message-id:date
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=H9OQZa8rRfzIKwLc+PuyHkHeJbeXPMigkw6Tzwmg3uA=;
        b=gKg6ZFo6TiyXx7Zovx5yZtGQxIridObZOvUu7G+sc+NejWLDTF3jMnG2cCvtje+qts
         4X7A97vGOi04RQDJcQI09R1KbCfvpynWLo2vrKLhpE8+vdLGOA25qg+gL/xLa+F3amKX
         KMYnu2RX5eHnebYuHFHpdvtdw4G/THUjCiyybUFw/TWVa8KDWble0xGlKmKDyf/8dHKT
         V08ODN8eeTrLP6M7ENxL2HR43aXReVmwRWJtwZXs1TXZHnRXXUM42oHLiSla8b2R2jZy
         UkOdJHYYnuNv7rjAKTBh+3EtW7udl3h7uVWR9CNXM5iefM+msfQec927vBN4RizfflMY
         xKNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:organization:mime-version:message-id:date
         :subject:cc:to:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=H9OQZa8rRfzIKwLc+PuyHkHeJbeXPMigkw6Tzwmg3uA=;
        b=FczVWztkgO55hduDWV1ckEX301cvtBZ1yniBKfM+wtlHLtoTPU/+dlCiXuQxLVLWdn
         gRlb0OruYFu4WTSmGkcUVkYAT/tFiCJ1iFwuuHyCckzKIQEiRlqO6Rojz8bIwf9DJcKc
         qpBVJJBlyWnoX90xYcEOtAJMknLRB31XrXFNx6QQZG0t3naFCtQal+dD1mjfJdqnomSz
         JBSdfBcVEStFvVd+HqPYBeU1gEPWMLfQW15oegQfyzVxXvKrhNVFgoNJbNtBR1m4ycAk
         U3YQza+Vw60FijZ0gd8s+6Ua01VSw6XGup4bLvZcf7OaUyIvMk+T15WSCS80Bmx0zpVJ
         lyLA==
X-Gm-Message-State: ANoB5plnVS/wmOQPAgxxk7dqbMhhR1nevCWKBI20PE/LwfhcWsjHFNLv
        cPoMwTBIgmHP+EBZlxwoFSU=
X-Google-Smtp-Source: AA0mqf76QsAHEEskAhsuOA7rbMk9uL8DS4SufvqHelYpVCyHLIow5CigRrmnSs+Hrg1TfOYXw7OiOg==
X-Received: by 2002:ac2:4e82:0:b0:4ac:9f25:21c2 with SMTP id o2-20020ac24e82000000b004ac9f2521c2mr20716558lfr.519.1669970147368;
        Fri, 02 Dec 2022 00:35:47 -0800 (PST)
Received: from wse-c0155.. (static-193-12-47-69.cust.tele2.se. [193.12.47.69])
        by smtp.gmail.com with ESMTPSA id l5-20020ac24305000000b0049936272173sm943194lfh.204.2022.12.02.00.35.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Dec 2022 00:35:46 -0800 (PST)
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
Subject: [PATCH v3 net] net: microchip: sparx5: correctly free skb in xmit
Date:   Fri,  2 Dec 2022 09:35:44 +0100
Message-Id: <20221202083544.2905207-1-casper.casan@gmail.com>
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

consume_skb on transmitted, kfree_skb on dropped, do not free on
TX_BUSY.

Previously the xmit function could return -EBUSY without freeing, which
supposedly is interpreted as a drop. And was using kfree on successfully
transmitted packets.

sparx5_fdma_xmit and sparx5_inject returns error code, where -EBUSY
indicates TX_BUSY and any other error code indicates dropped.

Fixes: f3cad2611a77 ("net: sparx5: add hostmode with phylink support")
Signed-off-by: Casper Andersson <casper.casan@gmail.com>
Reviewed-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
v2->v3:
  Removed empty line between Fixes and Signed-off-by

 .../ethernet/microchip/sparx5/sparx5_fdma.c   |  2 +-
 .../ethernet/microchip/sparx5/sparx5_packet.c | 41 +++++++++++--------
 2 files changed, 25 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_fdma.c b/drivers/net/ethernet/microchip/sparx5/sparx5_fdma.c
index 66360c8c5a38..141897dfe388 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_fdma.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_fdma.c
@@ -317,7 +317,7 @@ int sparx5_fdma_xmit(struct sparx5 *sparx5, u32 *ifh, struct sk_buff *skb)
 	next_dcb_hw = sparx5_fdma_next_dcb(tx, tx->curr_entry);
 	db_hw = &next_dcb_hw->db[0];
 	if (!(db_hw->status & FDMA_DCB_STATUS_DONE))
-		tx->dropped++;
+		return -EINVAL;
 	db = list_first_entry(&tx->db_list, struct sparx5_db, list);
 	list_move_tail(&db->list, &tx->db_list);
 	next_dcb_hw->nextptr = FDMA_DCB_INVALID_DATA;
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_packet.c b/drivers/net/ethernet/microchip/sparx5/sparx5_packet.c
index 83c16ca5b30f..6db6ac6a3bbc 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_packet.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_packet.c
@@ -234,9 +234,8 @@ netdev_tx_t sparx5_port_xmit_impl(struct sk_buff *skb, struct net_device *dev)
 	sparx5_set_port_ifh(ifh, port->portno);
 
 	if (sparx5->ptp && skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP) {
-		ret = sparx5_ptp_txtstamp_request(port, skb);
-		if (ret)
-			return ret;
+		if (sparx5_ptp_txtstamp_request(port, skb) < 0)
+			return NETDEV_TX_BUSY;
 
 		sparx5_set_port_ifh_rew_op(ifh, SPARX5_SKB_CB(skb)->rew_op);
 		sparx5_set_port_ifh_pdu_type(ifh, SPARX5_SKB_CB(skb)->pdu_type);
@@ -250,23 +249,31 @@ netdev_tx_t sparx5_port_xmit_impl(struct sk_buff *skb, struct net_device *dev)
 	else
 		ret = sparx5_inject(sparx5, ifh, skb, dev);
 
-	if (ret == NETDEV_TX_OK) {
-		stats->tx_bytes += skb->len;
-		stats->tx_packets++;
+	if (ret == -EBUSY)
+		goto busy;
+	if (ret < 0)
+		goto drop;
 
-		if (skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP &&
-		    SPARX5_SKB_CB(skb)->rew_op == IFH_REW_OP_TWO_STEP_PTP)
-			return ret;
+	stats->tx_bytes += skb->len;
+	stats->tx_packets++;
+	sparx5->tx.packets++;
 
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
+	sparx5->tx.dropped++;
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

