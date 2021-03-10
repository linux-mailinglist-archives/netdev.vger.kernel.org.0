Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89BCA333C2E
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 13:06:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232643AbhCJMFb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 07:05:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232880AbhCJMEw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 07:04:52 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD62BC061760
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 04:04:51 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id ci14so38087681ejc.7
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 04:04:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ayYyAvBxr1TrABfTdFV1fUEE39SFpOOX8S3ioR21sGE=;
        b=vZLCYzaESyqy1EEiqnE/mArAZyHU1S6oVLkLu1Bbng8ofBSJLtpYAV1fB0pAbXqBN9
         4jYWCtuBa/aXGPpcCG5vM1qGtD8V9nrnfPf1YFj7s3cdRQqdX5ZHhMGc5hHbWtIaerGa
         pk7xZvkWxH0Y5YQTzhgUpqtaU7e8CtrM91m0xrhVKtZGYNr3dJecVWIPD9rXtGL1KCh6
         1qqfsoDqR9ND3179NsEoCKGnR4nj9+D+tnMM0JWca3kab48mGUHMUQQX8cZpbVOb2DWT
         UE2oEfJY0OrDUquSnEVmGG1DSJZUvcPQMHyD8N6k3xlcXh3q7IYl4SQn1BG2vjfOD29+
         BE9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ayYyAvBxr1TrABfTdFV1fUEE39SFpOOX8S3ioR21sGE=;
        b=L7RpbOKdmX9/Z/1NcR0ZvFIfi2SkV1r6whlh/l38uRZmC4Vr38kaV/E9WSLQ83L64U
         oA/uvvM+Tu5GJy42f1JwuNwO9JLNcPF1lbejoci3tNO65DU9XEaQotgZeNmJAL+CtOmd
         o7HufZBXYLQW1mbz5h3D0JQRO9HV75mwZX5MKhyBLDWaswAalb7HrcxU670fow3AJu7+
         cMzGC6NzeIW0WuYObBd0PdT+l8GeN38eSUqghYXtBqlzWJE6x4/O1GtpeCEPF17+VrNj
         2iJpDKZZDW5BKIHnMagxhj/Lsk0rB3jKmiCF7dqVqha03+pqvTgXqR0OkXx7DNoAQhjh
         +LVA==
X-Gm-Message-State: AOAM532xoz3ERggpGOutKnhRLaappd/3zdaLIceU0HgPoGBGvraRAZeq
        /ymuPlk7ivdmdF8fwu3I4JA=
X-Google-Smtp-Source: ABdhPJy+D+OG6Y8ietSvkPEa6nYMWuCwSF9SkW27q2LGwW93B5eB7QUQwff9I7m8rZoC5ugYAmclsw==
X-Received: by 2002:a17:907:3e21:: with SMTP id hp33mr3276230ejc.313.1615377890629;
        Wed, 10 Mar 2021 04:04:50 -0800 (PST)
Received: from localhost.localdomain ([188.25.219.167])
        by smtp.gmail.com with ESMTPSA id q20sm9913239ejs.41.2021.03.10.04.04.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Mar 2021 04:04:50 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
X-Google-Original-From: Vladimir Oltean <vladimir.oltean@nxp.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Alex Marginean <alexandru.marginean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: [PATCH net-next 11/12] net: enetc: remove forward declaration for enetc_map_tx_buffs
Date:   Wed, 10 Mar 2021 14:03:50 +0200
Message-Id: <20210310120351.542292-12-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210310120351.542292-1-vladimir.oltean@nxp.com>
References: <20210310120351.542292-1-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is no other reason why this forward declaration exists rather than
poor ordering of the functions.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/freescale/enetc/enetc.c | 73 ++++++++++----------
 1 file changed, 35 insertions(+), 38 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index ddda16f60df9..c8b0b03f5ee7 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -12,44 +12,6 @@
 #define ENETC_MAX_SKB_FRAGS	13
 #define ENETC_TXBDS_MAX_NEEDED	ENETC_TXBDS_NEEDED(ENETC_MAX_SKB_FRAGS + 1)
 
-static int enetc_map_tx_buffs(struct enetc_bdr *tx_ring, struct sk_buff *skb,
-			      int active_offloads);
-
-netdev_tx_t enetc_xmit(struct sk_buff *skb, struct net_device *ndev)
-{
-	struct enetc_ndev_priv *priv = netdev_priv(ndev);
-	struct enetc_bdr *tx_ring;
-	int count;
-
-	tx_ring = priv->tx_ring[skb->queue_mapping];
-
-	if (unlikely(skb_shinfo(skb)->nr_frags > ENETC_MAX_SKB_FRAGS))
-		if (unlikely(skb_linearize(skb)))
-			goto drop_packet_err;
-
-	count = skb_shinfo(skb)->nr_frags + 1; /* fragments + head */
-	if (enetc_bd_unused(tx_ring) < ENETC_TXBDS_NEEDED(count)) {
-		netif_stop_subqueue(ndev, tx_ring->index);
-		return NETDEV_TX_BUSY;
-	}
-
-	enetc_lock_mdio();
-	count = enetc_map_tx_buffs(tx_ring, skb, priv->active_offloads);
-	enetc_unlock_mdio();
-
-	if (unlikely(!count))
-		goto drop_packet_err;
-
-	if (enetc_bd_unused(tx_ring) < ENETC_TXBDS_MAX_NEEDED)
-		netif_stop_subqueue(ndev, tx_ring->index);
-
-	return NETDEV_TX_OK;
-
-drop_packet_err:
-	dev_kfree_skb_any(skb);
-	return NETDEV_TX_OK;
-}
-
 static void enetc_unmap_tx_buff(struct enetc_bdr *tx_ring,
 				struct enetc_tx_swbd *tx_swbd)
 {
@@ -220,6 +182,41 @@ static int enetc_map_tx_buffs(struct enetc_bdr *tx_ring, struct sk_buff *skb,
 	return 0;
 }
 
+netdev_tx_t enetc_xmit(struct sk_buff *skb, struct net_device *ndev)
+{
+	struct enetc_ndev_priv *priv = netdev_priv(ndev);
+	struct enetc_bdr *tx_ring;
+	int count;
+
+	tx_ring = priv->tx_ring[skb->queue_mapping];
+
+	if (unlikely(skb_shinfo(skb)->nr_frags > ENETC_MAX_SKB_FRAGS))
+		if (unlikely(skb_linearize(skb)))
+			goto drop_packet_err;
+
+	count = skb_shinfo(skb)->nr_frags + 1; /* fragments + head */
+	if (enetc_bd_unused(tx_ring) < ENETC_TXBDS_NEEDED(count)) {
+		netif_stop_subqueue(ndev, tx_ring->index);
+		return NETDEV_TX_BUSY;
+	}
+
+	enetc_lock_mdio();
+	count = enetc_map_tx_buffs(tx_ring, skb, priv->active_offloads);
+	enetc_unlock_mdio();
+
+	if (unlikely(!count))
+		goto drop_packet_err;
+
+	if (enetc_bd_unused(tx_ring) < ENETC_TXBDS_MAX_NEEDED)
+		netif_stop_subqueue(ndev, tx_ring->index);
+
+	return NETDEV_TX_OK;
+
+drop_packet_err:
+	dev_kfree_skb_any(skb);
+	return NETDEV_TX_OK;
+}
+
 static irqreturn_t enetc_msix(int irq, void *data)
 {
 	struct enetc_int_vector	*v = data;
-- 
2.25.1

