Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B75E845D32E
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 03:34:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238435AbhKYCh2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 21:37:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237805AbhKYCf2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Nov 2021 21:35:28 -0500
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4C28C0619F0
        for <netdev@vger.kernel.org>; Wed, 24 Nov 2021 18:02:04 -0800 (PST)
Received: by mail-pg1-x529.google.com with SMTP id 71so3751021pgb.4
        for <netdev@vger.kernel.org>; Wed, 24 Nov 2021 18:02:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bBMLCNk/Gr+UaqRaPSGb7Mhkg1TNOBsUyPfjDcv6V2s=;
        b=BHymu+nVV2XnlySRKwAxD83lH4j/k9YYwHmY2kXN4eJBlt7wcpqEy4oPhvjB73TQbb
         BAE1ae3hzcD+GjI0KVZcy2VpllXTzgwlzHVBNv416cA3uoRpRCGSEkN5MLQNhooy95Go
         /4qk8nUQcApf4PJO2Cf8BId0BSL8AmhrPeBagviQ19yGrM8aKwaSWhmATEwTWOboqO9U
         NWXFrr34uWJaBSNWFgVzjgzZ/V8ZUjT1rqh0JPy+nm7wYKM/2FQaNoHxuXnrtefRZEQv
         uZq8Qvtw1Y9kTdyPmFYEuBlsMBT1cOt/hfN9EgEYJoFUi3u2auxCvKzT8wbUinZyVxV5
         b20A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bBMLCNk/Gr+UaqRaPSGb7Mhkg1TNOBsUyPfjDcv6V2s=;
        b=4xSt6VdLDgrVIrEpr3YiCiS1p3StOkcXdt1bDm4qwMEnyH6RgXv792Y1ZALawUaelx
         ufnOC28S2MLpc1QRQqAKShL6tY5s3OGtNLMtKMKGpB99P7QAJsh8KC36raYJybxLy0pv
         FCBSabrqnke0QbOx+YbBTK6huxD8RKWy8yeBs3E3h83SJ0eu2dltDDMKYuhsL3pqC+Ul
         Tvc7F5EB+0w6dqAyrDfxnU6XXK3GXE9m7d06WVk85wX5S2vijOiiLZ3zKg3HwiKbWPh1
         7sDLA18eRzIpiLW3Kih7Fh7Q/f+x6xvNSJdx3E2VCL7UslJDxbIsFQ5dDPWTXxwRoQ4x
         u4bg==
X-Gm-Message-State: AOAM532ulyUB6Zdi/X8VF9wrOIVDRHAyAxZEnbGia8iAaig8ciR+GGnr
        5eHhry3c5CEGijB8whJVpjEQpUcvNnn8Vg==
X-Google-Smtp-Source: ABdhPJzpeMtvKzOoOfZQOJ04ifjvdfEeVfuPmac9u38LwJ+V+lu7NocmQVjw6QzI7144Fa9FcBJnSg==
X-Received: by 2002:a63:2b83:: with SMTP id r125mr13924713pgr.92.1637805723936;
        Wed, 24 Nov 2021 18:02:03 -0800 (PST)
Received: from localhost.localdomain ([111.204.182.106])
        by smtp.gmail.com with ESMTPSA id 63sm1023494pfz.119.2021.11.24.18.02.02
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 24 Nov 2021 18:02:03 -0800 (PST)
From:   xiangxia.m.yue@gmail.com
To:     netdev@vger.kernel.org
Cc:     Tonghao Zhang <xiangxia.m.yue@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH net-next 2/2] ifb: support ethtools stats
Date:   Thu, 25 Nov 2021 10:01:55 +0800
Message-Id: <20211125020155.6488-2-xiangxia.m.yue@gmail.com>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
In-Reply-To: <20211125020155.6488-1-xiangxia.m.yue@gmail.com>
References: <20211125020155.6488-1-xiangxia.m.yue@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tonghao Zhang <xiangxia.m.yue@gmail.com>

With this feature, we can use the ethtools to get tx/rx
queues stats. This patch, introduce the ifb_update_q_stats
helper to update the queues stats, and ifb_q_stats to simplify
the codes.

Cc: Jakub Kicinski <kuba@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
---
 drivers/net/ifb.c | 146 +++++++++++++++++++++++++++++++++++++---------
 1 file changed, 120 insertions(+), 26 deletions(-)

diff --git a/drivers/net/ifb.c b/drivers/net/ifb.c
index d9078ce041c4..e5b0eeadca20 100644
--- a/drivers/net/ifb.c
+++ b/drivers/net/ifb.c
@@ -40,30 +40,54 @@
 #define DRV_VERSION	"1.0"
 #define TX_Q_LIMIT	32
 
+struct ifb_q_stats {
+	u64 packets;
+	u64 bytes;
+	struct u64_stats_sync	sync;
+};
+
 struct ifb_q_private {
 	struct net_device	*dev;
 	struct tasklet_struct   ifb_tasklet;
 	int			tasklet_pending;
 	int			txqnum;
 	struct sk_buff_head     rq;
-	u64			rx_packets;
-	u64			rx_bytes;
-	struct u64_stats_sync	rsync;
-
-	struct u64_stats_sync	tsync;
-	u64			tx_packets;
-	u64			tx_bytes;
 	struct sk_buff_head     tq;
+	struct ifb_q_stats	rx_stats;
+	struct ifb_q_stats	tx_stats;
 } ____cacheline_aligned_in_smp;
 
 struct ifb_dev_private {
 	struct ifb_q_private *tx_private;
 };
 
+/* For ethtools. */
+struct ifb_q_stats_desc {
+	char	desc[ETH_GSTRING_LEN];
+	size_t	offset;
+};
+
+#define IFB_Q_STAT(m)	offsetof(struct ifb_q_stats, m)
+
+static const struct ifb_q_stats_desc ifb_q_stats_desc[] = {
+	{ "packets",	IFB_Q_STAT(packets) },
+	{ "bytes",	IFB_Q_STAT(bytes) },
+};
+
+#define IFB_Q_STATS_LEN	ARRAY_SIZE(ifb_q_stats_desc)
+
 static netdev_tx_t ifb_xmit(struct sk_buff *skb, struct net_device *dev);
 static int ifb_open(struct net_device *dev);
 static int ifb_close(struct net_device *dev);
 
+static inline void ifb_update_q_stats(struct ifb_q_stats *stats, int len)
+{
+	u64_stats_update_begin(&stats->sync);
+	stats->packets++;
+	stats->bytes += len;
+	u64_stats_update_end(&stats->sync);
+}
+
 static void ifb_ri_tasklet(struct tasklet_struct *t)
 {
 	struct ifb_q_private *txp = from_tasklet(txp, t, ifb_tasklet);
@@ -87,10 +111,7 @@ static void ifb_ri_tasklet(struct tasklet_struct *t)
 #endif
 		nf_skip_egress(skb, true);
 
-		u64_stats_update_begin(&txp->tsync);
-		txp->tx_packets++;
-		txp->tx_bytes += skb->len;
-		u64_stats_update_end(&txp->tsync);
+		ifb_update_q_stats(&txp->tx_stats, skb->len);
 
 		rcu_read_lock();
 		skb->dev = dev_get_by_index_rcu(dev_net(txp->dev), skb->skb_iif);
@@ -143,18 +164,18 @@ static void ifb_stats64(struct net_device *dev,
 
 	for (i = 0; i < dev->num_tx_queues; i++,txp++) {
 		do {
-			start = u64_stats_fetch_begin_irq(&txp->rsync);
-			packets = txp->rx_packets;
-			bytes = txp->rx_bytes;
-		} while (u64_stats_fetch_retry_irq(&txp->rsync, start));
+			start = u64_stats_fetch_begin_irq(&txp->rx_stats.sync);
+			packets = txp->rx_stats.packets;
+			bytes = txp->rx_stats.bytes;
+		} while (u64_stats_fetch_retry_irq(&txp->rx_stats.sync, start));
 		stats->rx_packets += packets;
 		stats->rx_bytes += bytes;
 
 		do {
-			start = u64_stats_fetch_begin_irq(&txp->tsync);
-			packets = txp->tx_packets;
-			bytes = txp->tx_bytes;
-		} while (u64_stats_fetch_retry_irq(&txp->tsync, start));
+			start = u64_stats_fetch_begin_irq(&txp->tx_stats.sync);
+			packets = txp->tx_stats.packets;
+			bytes = txp->tx_stats.bytes;
+		} while (u64_stats_fetch_retry_irq(&txp->tx_stats.sync, start));
 		stats->tx_packets += packets;
 		stats->tx_bytes += bytes;
 	}
@@ -177,8 +198,8 @@ static int ifb_dev_init(struct net_device *dev)
 		txp->dev = dev;
 		__skb_queue_head_init(&txp->rq);
 		__skb_queue_head_init(&txp->tq);
-		u64_stats_init(&txp->rsync);
-		u64_stats_init(&txp->tsync);
+		u64_stats_init(&txp->rx_stats.sync);
+		u64_stats_init(&txp->tx_stats.sync);
 		tasklet_setup(&txp->ifb_tasklet, ifb_ri_tasklet);
 		netif_tx_start_queue(netdev_get_tx_queue(dev, i));
 	}
@@ -191,6 +212,79 @@ static void ifb_get_drvinfo(struct net_device *dev, struct ethtool_drvinfo *info
 	strlcpy(info->version, DRV_VERSION, sizeof(info->version));
 }
 
+static void ifb_get_strings(struct net_device *dev, u32 stringset, u8 *buf)
+{
+	u8 *p = buf;
+	int i, j;
+
+	switch(stringset) {
+	case ETH_SS_STATS:
+		for (i = 0; i < dev->real_num_rx_queues; i++) {
+			for (j = 0; j < IFB_Q_STATS_LEN; j++)
+				ethtool_sprintf(&p, "rx_queue_%u_%.18s",
+						i, ifb_q_stats_desc[j].desc);
+		}
+
+		for (i = 0; i < dev->real_num_tx_queues; i++) {
+			for (j = 0; j < IFB_Q_STATS_LEN; j++)
+				ethtool_sprintf(&p, "tx_queue_%u_%.18s",
+						i, ifb_q_stats_desc[j].desc);
+		}
+		break;
+	}
+}
+
+static int ifb_get_sset_count(struct net_device *dev, int sset)
+{
+	switch (sset) {
+	case ETH_SS_STATS:
+		return IFB_Q_STATS_LEN * (dev->real_num_rx_queues +
+		       dev->real_num_tx_queues);
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
+static void ifb_get_ethtool_stats(struct net_device *dev,
+				  struct ethtool_stats *stats, u64 *data)
+{
+	struct ifb_dev_private *dp = netdev_priv(dev);
+	unsigned int start;
+	size_t offset;
+	int idx = 0;
+	int i, j;
+
+	for (i = 0; i < dev->real_num_rx_queues; i++) {
+		struct ifb_q_private *txp = dp->tx_private + i;
+		struct ifb_q_stats *rq_stats = &txp->rx_stats;
+		void *stats_base = (void *)&txp->rx_stats;;
+
+		do {
+			start = u64_stats_fetch_begin_irq(&rq_stats->sync);
+			for (j = 0; j < IFB_Q_STATS_LEN; j++) {
+				offset = ifb_q_stats_desc[j].offset;
+				data[idx + j] = *(u64 *)(stats_base + offset);
+			}
+		} while (u64_stats_fetch_retry_irq(&rq_stats->sync, start));
+		idx += IFB_Q_STATS_LEN;
+	}
+
+	for (i = 0; i < dev->real_num_tx_queues; i++) {
+		struct ifb_q_private *txp = dp->tx_private + i;
+		struct ifb_q_stats *tq_stats = &txp->tx_stats;
+		void *stats_base = (void *)&txp->tx_stats;;
+
+		do {
+			start = u64_stats_fetch_begin_irq(&tq_stats->sync);
+			for (j = 0; j < IFB_Q_STATS_LEN; j++) {
+				offset = ifb_q_stats_desc[j].offset;
+				data[idx + j] = *(u64 *)(stats_base + offset);
+			}
+		} while (u64_stats_fetch_retry_irq(&tq_stats->sync, start));
+		idx += IFB_Q_STATS_LEN;
+	}
+}
+
 static const struct net_device_ops ifb_netdev_ops = {
 	.ndo_open	= ifb_open,
 	.ndo_stop	= ifb_close,
@@ -201,7 +295,10 @@ static const struct net_device_ops ifb_netdev_ops = {
 };
 
 static const struct ethtool_ops ifb_ethtool_ops = {
-	.get_drvinfo = ifb_get_drvinfo,
+	.get_drvinfo		= ifb_get_drvinfo,
+	.get_strings		= ifb_get_strings,
+	.get_sset_count		= ifb_get_sset_count,
+	.get_ethtool_stats	= ifb_get_ethtool_stats,
 };
 
 #define IFB_FEATURES (NETIF_F_HW_CSUM | NETIF_F_SG  | NETIF_F_FRAGLIST	| \
@@ -257,10 +354,7 @@ static netdev_tx_t ifb_xmit(struct sk_buff *skb, struct net_device *dev)
 	struct ifb_dev_private *dp = netdev_priv(dev);
 	struct ifb_q_private *txp = dp->tx_private + skb_get_queue_mapping(skb);
 
-	u64_stats_update_begin(&txp->rsync);
-	txp->rx_packets++;
-	txp->rx_bytes += skb->len;
-	u64_stats_update_end(&txp->rsync);
+	ifb_update_q_stats(&txp->rx_stats, skb->len);
 
 	if (!skb->redirected || !skb->skb_iif) {
 		dev_kfree_skb(skb);
-- 
2.27.0

