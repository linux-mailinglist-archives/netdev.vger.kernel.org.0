Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B30345E6C8
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 05:18:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358139AbhKZEVk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Nov 2021 23:21:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358118AbhKZETd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Nov 2021 23:19:33 -0500
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4843C061372
        for <netdev@vger.kernel.org>; Thu, 25 Nov 2021 19:23:12 -0800 (PST)
Received: by mail-pg1-x52d.google.com with SMTP id 200so6926571pga.1
        for <netdev@vger.kernel.org>; Thu, 25 Nov 2021 19:23:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mUZRzZlMrI0hBX2nVxXz4zq3Wbhq5rMgMSdoPz4tI7s=;
        b=UWdnMDgEzxemJRWl1rYztuLAUZ2zqY9Y65lxSvTZdSupjVUJh6tajfa//RjcEs3qSY
         hnEDZrKleZXmFZBK/BVBN07rxne2ITqtmNjG8Rv+344quPrwbICnE+NOuQ91vSrtH/sk
         YY8bOlhw9A98Hm+FiQ8IphwEoBniIEe7cMiXRsfvUzHEwiOUCcXw5UV6DUb1ffj2sSWU
         CyDRajhSUdChO7te94ZAs+8hR//XE4Vwz8qt1Mu4abOsX9FZZRGKUuRy7TtgqpkijPk9
         GweglRdIzHKdwrVHjv6dPLObH9GiJ0Ra1hDuIR1nX3UgGxoxuCiFcs2Tf4li6bTvD8al
         gtnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mUZRzZlMrI0hBX2nVxXz4zq3Wbhq5rMgMSdoPz4tI7s=;
        b=VSJEdTBjI+cvhqYl9c4O60aNKyUcvogX2eEKvHQ0soS5OYvwCiLVMgxnxsyoyNdLw/
         WRe3FSOr6xIaIgO+ZY4w1PUtfpWuZ0M6ki1n1otfdqtukiBzRt3NUtnuCq6LRQHmhPGr
         JKu77X7l/peuq5VurmT7LOmpCVzSHol+CjVXGBgrIWViqGBDsr2CXXmi2GFrO4Rhh1Tq
         nt2RLRpmFIhjOBHp5dlRXkTKKtwW1IZ5ENUjYS8L8fFWfMFCEzsFGeQzdIAeatRineiz
         eI+xwam6f5UW0vW5QFFCpqCfM3/rm5dwww2y/Jll3llPw3/38LsLIehj62+8Tq5bqw7s
         TkRg==
X-Gm-Message-State: AOAM5300oAdx80ShRKMJkMUzY5RXf9nkw+zR/wjSgQOkToU4pg+NeQVb
        TruIM/OfqqUySM3yZcM0GZ3g1bzzKEGbcQ==
X-Google-Smtp-Source: ABdhPJxp0Tz57V4lnNSp7sriuZe0ue2xbcJsTBZy1X+QgL27EhRlqCDKGLUCJtcgQxkS6XGMLlBhKA==
X-Received: by 2002:a63:5b66:: with SMTP id l38mr19290778pgm.62.1637896992064;
        Thu, 25 Nov 2021 19:23:12 -0800 (PST)
Received: from localhost.localdomain ([111.204.182.106])
        by smtp.gmail.com with ESMTPSA id d17sm4585017pfo.40.2021.11.25.19.23.10
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 25 Nov 2021 19:23:11 -0800 (PST)
From:   xiangxia.m.yue@gmail.com
To:     netdev@vger.kernel.org
Cc:     Tonghao Zhang <xiangxia.m.yue@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [net-next v2] net: ifb: support ethtools stats
Date:   Fri, 26 Nov 2021 11:23:05 +0800
Message-Id: <20211126032305.13571-1-xiangxia.m.yue@gmail.com>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tonghao Zhang <xiangxia.m.yue@gmail.com>

With this feature, we can use the ethtools to get tx/rx
queues stats. This patch, introduce the ifb_update_q_stats
helper to update the queues stats, and ifb_q_stats to simplify
the codes. In future, we can add more metrics in ifb_q_stats.

Cc: Jakub Kicinski <kuba@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
---
v2: rebased https://patchwork.kernel.org/project/netdevbpf/patch/20211125020155.6488-2-xiangxia.m.yue@gmail.com/
---
 drivers/net/ifb.c | 146 ++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 121 insertions(+), 25 deletions(-)

diff --git a/drivers/net/ifb.c b/drivers/net/ifb.c
index 31f522b8e54e..3d88db708dc5 100644
--- a/drivers/net/ifb.c
+++ b/drivers/net/ifb.c
@@ -27,6 +27,7 @@
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/netdevice.h>
+#include <linux/ethtool.h>
 #include <linux/etherdevice.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
@@ -36,30 +37,55 @@
 #include <net/net_namespace.h>
 
 #define TX_Q_LIMIT    32
+
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
 
+/* For ethtools stats. */
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
@@ -83,10 +109,7 @@ static void ifb_ri_tasklet(struct tasklet_struct *t)
 #endif
 		nf_skip_egress(skb, true);
 
-		u64_stats_update_begin(&txp->tsync);
-		txp->tx_packets++;
-		txp->tx_bytes += skb->len;
-		u64_stats_update_end(&txp->tsync);
+		ifb_update_q_stats(&txp->tx_stats, skb->len);
 
 		rcu_read_lock();
 		skb->dev = dev_get_by_index_rcu(dev_net(txp->dev), skb->skb_iif);
@@ -139,18 +162,18 @@ static void ifb_stats64(struct net_device *dev,
 
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
@@ -173,14 +196,83 @@ static int ifb_dev_init(struct net_device *dev)
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
 	return 0;
 }
 
+static void ifb_get_strings(struct net_device *dev, u32 stringset, u8 *buf)
+{
+	u8 *p = buf;
+	int i, j;
+
+	switch(stringset) {
+	case ETH_SS_STATS:
+		for (i = 0; i < dev->real_num_rx_queues; i++)
+			for (j = 0; j < IFB_Q_STATS_LEN; j++)
+				ethtool_sprintf(&p, "rx_queue_%u_%.18s",
+						i, ifb_q_stats_desc[j].desc);
+
+		for (i = 0; i < dev->real_num_tx_queues; i++)
+			for (j = 0; j < IFB_Q_STATS_LEN; j++)
+				ethtool_sprintf(&p, "tx_queue_%u_%.18s",
+						i, ifb_q_stats_desc[j].desc);
+
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
+static inline void ifb_fill_stats_data(u64 **data,
+				       struct ifb_q_stats *q_stats)
+{
+	void *stats_base = (void *)q_stats;
+	unsigned int start;
+	size_t offset;
+	int j;
+
+	do {
+		start = u64_stats_fetch_begin_irq(&q_stats->sync);
+		for (j = 0; j < IFB_Q_STATS_LEN; j++) {
+			offset = ifb_q_stats_desc[j].offset;
+			(*data)[j] = *(u64 *)(stats_base + offset);
+		}
+	} while (u64_stats_fetch_retry_irq(&q_stats->sync, start));
+
+	*data += IFB_Q_STATS_LEN;
+}
+
+static void ifb_get_ethtool_stats(struct net_device *dev,
+				  struct ethtool_stats *stats, u64 *data)
+{
+	struct ifb_dev_private *dp = netdev_priv(dev);
+	struct ifb_q_private *txp;
+	int i;
+
+	for (i = 0; i < dev->real_num_rx_queues; i++) {
+		txp = dp->tx_private + i;
+		ifb_fill_stats_data(&data, &txp->rx_stats);
+	}
+
+	for (i = 0; i < dev->real_num_tx_queues; i++) {
+		txp = dp->tx_private + i;
+		ifb_fill_stats_data(&data, &txp->tx_stats);
+	}
+}
+
 static const struct net_device_ops ifb_netdev_ops = {
 	.ndo_open	= ifb_open,
 	.ndo_stop	= ifb_close,
@@ -190,6 +282,12 @@ static const struct net_device_ops ifb_netdev_ops = {
 	.ndo_init	= ifb_dev_init,
 };
 
+static const struct ethtool_ops ifb_ethtool_ops = {
+	.get_strings		= ifb_get_strings,
+	.get_sset_count		= ifb_get_sset_count,
+	.get_ethtool_stats	= ifb_get_ethtool_stats,
+};
+
 #define IFB_FEATURES (NETIF_F_HW_CSUM | NETIF_F_SG  | NETIF_F_FRAGLIST	| \
 		      NETIF_F_GSO_SOFTWARE | NETIF_F_GSO_ENCAP_ALL	| \
 		      NETIF_F_HIGHDMA | NETIF_F_HW_VLAN_CTAG_TX		| \
@@ -213,6 +311,7 @@ static void ifb_setup(struct net_device *dev)
 {
 	/* Initialize the device structure. */
 	dev->netdev_ops = &ifb_netdev_ops;
+	dev->ethtool_ops = &ifb_ethtool_ops;
 
 	/* Fill in device structure with ethernet-generic values. */
 	ether_setup(dev);
@@ -241,10 +340,7 @@ static netdev_tx_t ifb_xmit(struct sk_buff *skb, struct net_device *dev)
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

