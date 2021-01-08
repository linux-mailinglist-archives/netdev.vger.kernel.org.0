Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 428862EF5DA
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 17:35:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728427AbhAHQdp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 11:33:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727524AbhAHQdl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jan 2021 11:33:41 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEAC1C0612A6
        for <netdev@vger.kernel.org>; Fri,  8 Jan 2021 08:32:38 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id g24so11746245edw.9
        for <netdev@vger.kernel.org>; Fri, 08 Jan 2021 08:32:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3vapg5N7Fc/ixtYN48myajBDkQucglPi1gl4RMw/uOI=;
        b=GuBNmA9bsECl9WIjoYWvjSe6H6Vifm0+m5J4NiJKSVDwS76ERpMfqj/8oLNCiLAgp3
         ZQKv+uL9fRKk7U5k+ZIYVo398Ie53sF7DrH830sHDDSBr6NkwgSzf5cNdZ0yXXAm+8Sd
         EK4wTXjs7yS5P9O+WlNQXBBbH8I9V26e4SMyTlyHx53fgkDaYMW3xlRH7i1Xg31RHupD
         dOUKapjm0kg6dHz4JU0M+L9oHIbC4+ujdLB/oXKAx1mMgc1AQbM6uKNG1c417tJTNN5V
         zir+qMFwyOK84I4KDhIsfWURWfkOuqqofaufzklIzAsMwO7HpOG175fnBQUACbv+uhdO
         3urQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3vapg5N7Fc/ixtYN48myajBDkQucglPi1gl4RMw/uOI=;
        b=PHjPWXAaMaUoazF1r4Z49djQvFVUA0vRLMi1Py/wT0LlYRdQzCs0HJLlyhHf8u5P5i
         4YpXe2UXpMEWInuyEzvSEoTWnpcynQ9OM5XMW+RCJ2pzbsnaR6Rwc8sZAf3qtK0o+Pr3
         pLE6k0xtaHUTLm2fflvA8gXUIDy/kgYoIjNyJ2GMvchLaJ9cUTtzDBETppCfhF8OP4Dx
         2E+SlH6FbYJJs+bbGvacInNkxc76OufyYRbt5J8Qar0k3FwZEYTJZnbE1DzOo72PqObr
         9olYRWcsULch9NSf7/xtpUXReIrV3Ocs70Q2Y7Q+C5rvYo/NrS4S8rPYye7Oa59N1R5f
         f1hQ==
X-Gm-Message-State: AOAM530GiX/P7xLqUdMqoG6Mb2nllmRMXocDSlvtiXDHE+QOchYBO90N
        /8A1+gA0uvgAd1FoseZkC6A=
X-Google-Smtp-Source: ABdhPJydIEi8VyA1ddPJRarHxZevlzNr5EHnE5Sa0r9q+S3RVhSEJrvouJ51s32YKoQAa6Af3k2cyQ==
X-Received: by 2002:a05:6402:1d18:: with SMTP id dg24mr5686580edb.221.1610123557521;
        Fri, 08 Jan 2021 08:32:37 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id x6sm3957737edl.67.2021.01.08.08.32.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Jan 2021 08:32:37 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Eric Dumazet <edumazet@google.com>,
        George McCollister <george.mccollister@gmail.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Arnd Bergmann <arnd@arndb.de>, Taehee Yoo <ap420073@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>, Florian Westphal <fw@strlen.de>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Pravin B Shelar <pshelar@ovn.org>,
        Sridhar Samudrala <sridhar.samudrala@intel.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH v5 net-next 12/16] net: terminate errors from dev_get_stats
Date:   Fri,  8 Jan 2021 18:31:55 +0200
Message-Id: <20210108163159.358043-13-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210108163159.358043-1-olteanv@gmail.com>
References: <20210108163159.358043-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

dev_get_stats can now return errors. Some call sites are coming from a
context that returns void (ethtool stats, workqueue context). So since
we can't report to the upper layer, do the next best thing: shout.

This patch wraps up the conversion of existing dev_get_stats callers, so
we can add the __must_check attribute now to ensure that future callers
keep doing this too.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v5:
Added the __must_check to dev_get_stats.

Changes in v4:
Patch is new (Eric's suggestion).

 arch/s390/appldata/appldata_net_sum.c               | 10 ++++++++--
 drivers/leds/trigger/ledtrig-netdev.c               |  9 ++++++++-
 drivers/net/ethernet/apm/xgene/xgene_enet_ethtool.c |  9 +++++++--
 drivers/net/ethernet/hisilicon/hns/hns_ethtool.c    |  7 ++++++-
 drivers/net/ethernet/intel/e1000e/ethtool.c         |  9 +++++++--
 drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c    |  9 +++++++--
 drivers/net/ethernet/intel/ixgbevf/ethtool.c        |  9 +++++++--
 include/linux/netdevice.h                           |  3 ++-
 net/core/dev.c                                      |  3 ++-
 9 files changed, 54 insertions(+), 14 deletions(-)

diff --git a/arch/s390/appldata/appldata_net_sum.c b/arch/s390/appldata/appldata_net_sum.c
index 6146606ac9a3..72cb5344e488 100644
--- a/arch/s390/appldata/appldata_net_sum.c
+++ b/arch/s390/appldata/appldata_net_sum.c
@@ -58,11 +58,11 @@ struct appldata_net_sum_data {
  */
 static void appldata_get_net_sum_data(void *data)
 {
-	int i;
 	struct appldata_net_sum_data *net_data;
 	struct net_device *dev;
 	unsigned long rx_packets, tx_packets, rx_bytes, tx_bytes, rx_errors,
 			tx_errors, rx_dropped, tx_dropped, collisions;
+	int ret, i;
 
 	net_data = data;
 	net_data->sync_count_1++;
@@ -83,7 +83,13 @@ static void appldata_get_net_sum_data(void *data)
 	for_each_netdev(&init_net, dev) {
 		struct rtnl_link_stats64 stats;
 
-		dev_get_stats(dev, &stats);
+		ret = dev_get_stats(dev, &stats);
+		if (ret) {
+			netif_lists_unlock(&init_net);
+			netdev_err(dev, "dev_get_stats returned %d\n", ret);
+			return;
+		}
+
 		rx_packets += stats.rx_packets;
 		tx_packets += stats.tx_packets;
 		rx_bytes   += stats.rx_bytes;
diff --git a/drivers/leds/trigger/ledtrig-netdev.c b/drivers/leds/trigger/ledtrig-netdev.c
index 4382ee278309..c717b7e7dd81 100644
--- a/drivers/leds/trigger/ledtrig-netdev.c
+++ b/drivers/leds/trigger/ledtrig-netdev.c
@@ -351,6 +351,7 @@ static void netdev_trig_work(struct work_struct *work)
 	unsigned int new_activity;
 	unsigned long interval;
 	int invert;
+	int err;
 
 	/* If we dont have a device, insure we are off */
 	if (!trigger_data->net_dev) {
@@ -363,7 +364,13 @@ static void netdev_trig_work(struct work_struct *work)
 	    !test_bit(NETDEV_LED_RX, &trigger_data->mode))
 		return;
 
-	dev_get_stats(trigger_data->net_dev, &dev_stats);
+	err = dev_get_stats(trigger_data->net_dev, &dev_stats);
+	if (err) {
+		netdev_err(trigger_data->net_dev,
+			   "dev_get_stats returned %d\n", err);
+		return;
+	}
+
 	new_activity =
 	    (test_bit(NETDEV_LED_TX, &trigger_data->mode) ?
 		dev_stats.tx_packets : 0) +
diff --git a/drivers/net/ethernet/apm/xgene/xgene_enet_ethtool.c b/drivers/net/ethernet/apm/xgene/xgene_enet_ethtool.c
index ada70425b48c..aab6a81f0438 100644
--- a/drivers/net/ethernet/apm/xgene/xgene_enet_ethtool.c
+++ b/drivers/net/ethernet/apm/xgene/xgene_enet_ethtool.c
@@ -266,9 +266,14 @@ static void xgene_get_ethtool_stats(struct net_device *ndev,
 {
 	struct xgene_enet_pdata *pdata = netdev_priv(ndev);
 	struct rtnl_link_stats64 stats;
-	int i;
+	int err, i;
+
+	err = dev_get_stats(ndev, &stats);
+	if (err) {
+		netdev_err(ndev, "dev_get_stats returned %d\n", err);
+		return;
+	}
 
-	dev_get_stats(ndev, &stats);
 	for (i = 0; i < XGENE_STATS_LEN; i++)
 		data[i] = *(u64 *)((char *)&stats + gstrings_stats[i].offset);
 
diff --git a/drivers/net/ethernet/hisilicon/hns/hns_ethtool.c b/drivers/net/ethernet/hisilicon/hns/hns_ethtool.c
index ee2172011051..d05fa7b3f6e0 100644
--- a/drivers/net/ethernet/hisilicon/hns/hns_ethtool.c
+++ b/drivers/net/ethernet/hisilicon/hns/hns_ethtool.c
@@ -840,6 +840,7 @@ static void hns_get_ethtool_stats(struct net_device *netdev,
 	struct hns_nic_priv *priv = netdev_priv(netdev);
 	struct hnae_handle *h = priv->ae_handle;
 	struct rtnl_link_stats64 net_stats;
+	int err;
 
 	if (!h->dev->ops->get_stats || !h->dev->ops->update_stats) {
 		netdev_err(netdev, "get_stats or update_stats is null!\n");
@@ -848,7 +849,11 @@ static void hns_get_ethtool_stats(struct net_device *netdev,
 
 	h->dev->ops->update_stats(h, &netdev->stats);
 
-	dev_get_stats(netdev, &net_stats);
+	err = dev_get_stats(netdev, &net_stats);
+	if (err) {
+		netdev_err(netdev, "dev_get_stats returned %d\n", err);
+		return;
+	}
 
 	/* get netdev statistics */
 	p[0] = net_stats.rx_packets;
diff --git a/drivers/net/ethernet/intel/e1000e/ethtool.c b/drivers/net/ethernet/intel/e1000e/ethtool.c
index 06442e6bef73..41bd3e0598ce 100644
--- a/drivers/net/ethernet/intel/e1000e/ethtool.c
+++ b/drivers/net/ethernet/intel/e1000e/ethtool.c
@@ -2060,15 +2060,20 @@ static void e1000_get_ethtool_stats(struct net_device *netdev,
 {
 	struct e1000_adapter *adapter = netdev_priv(netdev);
 	struct rtnl_link_stats64 net_stats;
-	int i;
 	char *p = NULL;
+	int err, i;
 
 	pm_runtime_get_sync(netdev->dev.parent);
 
-	dev_get_stats(netdev, &net_stats);
+	err = dev_get_stats(netdev, &net_stats);
 
 	pm_runtime_put_sync(netdev->dev.parent);
 
+	if (err) {
+		netdev_err(netdev, "dev_get_stats returned %d\n", err);
+		return;
+	}
+
 	for (i = 0; i < E1000_GLOBAL_STATS_LEN; i++) {
 		switch (e1000_gstrings_stats[i].type) {
 		case NETDEV_STATS:
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c
index 2b8084664403..a647e2774f76 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c
@@ -1298,11 +1298,16 @@ static void ixgbe_get_ethtool_stats(struct net_device *netdev,
 	struct rtnl_link_stats64 net_stats;
 	unsigned int start;
 	struct ixgbe_ring *ring;
-	int i, j;
 	char *p = NULL;
+	int err, i, j;
 
 	ixgbe_update_stats(adapter);
-	dev_get_stats(netdev, &net_stats);
+	err = dev_get_stats(netdev, &net_stats);
+	if (err) {
+		netdev_err(netdev, "dev_get_stats returned %d\n", err);
+		return;
+	}
+
 	for (i = 0; i < IXGBE_GLOBAL_STATS_LEN; i++) {
 		switch (ixgbe_gstrings_stats[i].type) {
 		case NETDEV_STATS:
diff --git a/drivers/net/ethernet/intel/ixgbevf/ethtool.c b/drivers/net/ethernet/intel/ixgbevf/ethtool.c
index 3b9b7e5c2998..665e39301092 100644
--- a/drivers/net/ethernet/intel/ixgbevf/ethtool.c
+++ b/drivers/net/ethernet/intel/ixgbevf/ethtool.c
@@ -423,11 +423,16 @@ static void ixgbevf_get_ethtool_stats(struct net_device *netdev,
 	struct rtnl_link_stats64 net_stats;
 	unsigned int start;
 	struct ixgbevf_ring *ring;
-	int i, j;
+	int err, i, j;
 	char *p;
 
 	ixgbevf_update_stats(adapter);
-	dev_get_stats(netdev, &net_stats);
+	err = dev_get_stats(netdev, &net_stats);
+	if (err) {
+		netdev_err(netdev, "dev_get_stats returned %d\n", err);
+		return;
+	}
+
 	for (i = 0; i < IXGBEVF_GLOBAL_STATS_LEN; i++) {
 		switch (ixgbevf_gstrings_stats[i].type) {
 		case NETDEV_STATS:
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index bd471f1e1fa3..b1aebab916a8 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -4545,7 +4545,8 @@ void netdev_notify_peers(struct net_device *dev);
 void netdev_features_change(struct net_device *dev);
 /* Load a device via the kmod */
 void dev_load(struct net *net, const char *name);
-int dev_get_stats(struct net_device *dev, struct rtnl_link_stats64 *storage);
+int __must_check dev_get_stats(struct net_device *dev,
+			       struct rtnl_link_stats64 *storage);
 void netdev_stats_to_stats64(struct rtnl_link_stats64 *stats64,
 			     const struct net_device_stats *netdev_stats);
 void dev_fetch_sw_netstats(struct rtnl_link_stats64 *s,
diff --git a/net/core/dev.c b/net/core/dev.c
index dfbd66ba3cad..30facac95d5e 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -10403,7 +10403,8 @@ EXPORT_SYMBOL(netdev_stats_to_stats64);
  *	dev->netdev_ops->get_stats64 or dev->netdev_ops->get_stats;
  *	otherwise the internal statistics structure is used.
  */
-int dev_get_stats(struct net_device *dev, struct rtnl_link_stats64 *storage)
+int __must_check dev_get_stats(struct net_device *dev,
+			       struct rtnl_link_stats64 *storage)
 {
 	const struct net_device_ops *ops = dev->netdev_ops;
 	int err = 0;
-- 
2.25.1

