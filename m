Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44F222EF5D8
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 17:35:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728413AbhAHQdo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 11:33:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728156AbhAHQdm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jan 2021 11:33:42 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D45CCC0612A8
        for <netdev@vger.kernel.org>; Fri,  8 Jan 2021 08:32:41 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id w1so15190596ejf.11
        for <netdev@vger.kernel.org>; Fri, 08 Jan 2021 08:32:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/Wtdvg0EU8CbIz7qyhphZGYCfzOo7O5XFwV++uubOBY=;
        b=MTrXXeQ9imQFEz1KFqxOeeW4Mdb7hfaTHz4rMkkEayqBu6f28DSPaDaQf9UoUY1WcG
         S5x5OzIdiO0R7NL35MO40IiVpYkvTDfuI5mlvIvkHOJWKkVQ4YNPB8CdiTo83RfLpUDY
         EIDRvNzwMkT84hynIeXngOACyQrTg6pENECgM13ZGGgMkEmc+Se6OawaXOzy1Vea0OBN
         2pz9svZLjXjbTZoBIqdotEJUfJ6IcjaYfMzQFDT1qwbOiKG7DCwyEU4sVHEYHTI5lvQ+
         tF11+pfIlJFlNtPxGjpcELJHaMbaiEL/WmSbD7MWV2oqZdg+Ocp2LZydjwmp68RkgJU1
         A5yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/Wtdvg0EU8CbIz7qyhphZGYCfzOo7O5XFwV++uubOBY=;
        b=WH5C090LPgy0UrjY/9paZ7Lq9+esQyT6A0D2KBFJx0RNJYZe9DjKgOzZHGo57F+C4K
         pi7afiukUBWvdTxyUoCG5FqMCBnxaMvboA10QX2S0yzH2NtcbMw2/NJIu6wv+u7iGiy5
         ytGY73jssL645HsTohD59jwBvW9jrbzK/jjmSHMjdG4aZf9SVPSdImWuN873tboMGGIN
         h4KpDmQX0FXK4vUoxtDQiULkFJameslHuhTN7Yf8XZ1dbsEXe8Au3ONmMPQh4CLbovOD
         ruakzzREKEqmv8TKpvXawbFWOEqDeAGV952O1GXRsQJ6BTA1wrj0FaHrZVgSSB+Chv55
         Xp8g==
X-Gm-Message-State: AOAM530dM53B0XYmv10RCHvEpBENqjj3+vLRO1HnQ7aMUeXKSNNdB3T7
        MqTyu3nEMrs/CfV5GTGos+8=
X-Google-Smtp-Source: ABdhPJzoPZoGmR61nb6T72kxXmFdBOjw50nr+7fDAjJOJR/KOlR39RRQNFsZei2EDXJbJsPm9j1PZQ==
X-Received: by 2002:a17:906:fa12:: with SMTP id lo18mr3292593ejb.354.1610123560572;
        Fri, 08 Jan 2021 08:32:40 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id x6sm3957737edl.67.2021.01.08.08.32.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Jan 2021 08:32:40 -0800 (PST)
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
Subject: [PATCH v5 net-next 14/16] net: net_failover: ensure .ndo_get_stats64 can sleep
Date:   Fri,  8 Jan 2021 18:31:57 +0200
Message-Id: <20210108163159.358043-15-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210108163159.358043-1-olteanv@gmail.com>
References: <20210108163159.358043-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

The failover framework sets up a virtio_net interface [ when it has the
VIRTIO_NET_F_STANDBY feature ] and a VF interface, having the same MAC
address, in a standby/active relationship. When the active VF is
unplugged, the standby virtio_net temporarily kicks in.

The failover framework registers a common upper for the active and the
standby interface, which is what the application layer uses. This is
similar to bonding/team. The statistics of the upper interface are the
sum of the statistics of the active and of the standby interface.

There is an effort to convert .ndo_get_stats64 to sleepable context, and
for that to work, we need to prevent callers of dev_get_stats from using
atomic locking. The failover driver needs protection via an RCU
read-side critical section to access the standby and the active
interface. This has two features:
- It is atomic: this needs to change.
- It is reentrant: this is ok, because generally speaking, dev_get_stats
  is recursive, and taking global locks is a bad thing from a recursive
  context.

The existing logic can be rehashed just a little bit such that the
recursive dev_get_stats call will not be under any lock. We can achieve
that by "cheating" a little bit and use dev_hold() to take a reference
on the active and backup interfaces, and netdev_wait_allrefs() will just
have to wait until dev_get_stats() finishes.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v5:
Use rcu_read_lock() and do not change the locking architecture of the
driver.

Changes in v4:
Now there is code to propagate errors.

Changes in v3:
None.

Changes in v2:
Switched to the new scheme of holding just a refcnt to the slave
interfaces while recursing with dev_get_stats.

 drivers/net/net_failover.c | 64 ++++++++++++++++++++++++++++----------
 1 file changed, 47 insertions(+), 17 deletions(-)

diff --git a/drivers/net/net_failover.c b/drivers/net/net_failover.c
index 7f70555e68d1..3e8a4046c748 100644
--- a/drivers/net/net_failover.c
+++ b/drivers/net/net_failover.c
@@ -183,38 +183,64 @@ static int net_failover_get_stats(struct net_device *dev,
 				  struct rtnl_link_stats64 *stats)
 {
 	struct net_failover_info *nfo_info = netdev_priv(dev);
-	struct rtnl_link_stats64 temp;
-	struct net_device *slave_dev;
+	struct rtnl_link_stats64 primary_stats;
+	struct rtnl_link_stats64 standby_stats;
+	struct net_device *primary_dev;
+	struct net_device *standby_dev;
 	int err = 0;
 
-	spin_lock(&nfo_info->stats_lock);
-	memcpy(stats, &nfo_info->failover_stats, sizeof(*stats));
-
 	rcu_read_lock();
 
-	slave_dev = rcu_dereference(nfo_info->primary_dev);
-	if (slave_dev) {
-		err = dev_get_stats(slave_dev, &temp);
+	primary_dev = rcu_dereference(nfo_info->primary_dev);
+	if (primary_dev)
+		dev_hold(primary_dev);
+
+	standby_dev = rcu_dereference(nfo_info->standby_dev);
+	if (standby_dev)
+		dev_hold(standby_dev);
+
+	rcu_read_unlock();
+
+	/* Don't hold rcu_read_lock while calling dev_get_stats, just a
+	 * reference to ensure they won't get unregistered.
+	 */
+	if (primary_dev) {
+		err = dev_get_stats(primary_dev, &primary_stats);
 		if (err)
 			goto out;
-		net_failover_fold_stats(stats, &temp, &nfo_info->primary_stats);
-		memcpy(&nfo_info->primary_stats, &temp, sizeof(temp));
 	}
 
-	slave_dev = rcu_dereference(nfo_info->standby_dev);
-	if (slave_dev) {
-		err = dev_get_stats(slave_dev, &temp);
+	if (standby_dev) {
+		err = dev_get_stats(standby_dev, &standby_stats);
 		if (err)
 			goto out;
-		net_failover_fold_stats(stats, &temp, &nfo_info->standby_stats);
-		memcpy(&nfo_info->standby_stats, &temp, sizeof(temp));
 	}
 
-out:
-	rcu_read_unlock();
+	spin_lock(&nfo_info->stats_lock);
+
+	memcpy(stats, &nfo_info->failover_stats, sizeof(*stats));
+
+	if (primary_dev) {
+		net_failover_fold_stats(stats, &primary_stats,
+					&nfo_info->primary_stats);
+		memcpy(&nfo_info->primary_stats, &primary_stats,
+		       sizeof(primary_stats));
+	}
+	if (standby_dev) {
+		net_failover_fold_stats(stats, &standby_stats,
+					&nfo_info->standby_stats);
+		memcpy(&nfo_info->standby_stats, &standby_stats,
+		       sizeof(standby_stats));
+	}
 
 	memcpy(&nfo_info->failover_stats, stats, sizeof(*stats));
+
 	spin_unlock(&nfo_info->stats_lock);
+out:
+	if (primary_dev)
+		dev_put(primary_dev);
+	if (standby_dev)
+		dev_put(standby_dev);
 
 	return err;
 }
@@ -728,6 +754,7 @@ static struct failover_ops net_failover_ops = {
 struct failover *net_failover_create(struct net_device *standby_dev)
 {
 	struct device *dev = standby_dev->dev.parent;
+	struct net_failover_info *nfo_info;
 	struct net_device *failover_dev;
 	struct failover *failover;
 	int err;
@@ -772,6 +799,9 @@ struct failover *net_failover_create(struct net_device *standby_dev)
 	failover_dev->min_mtu = standby_dev->min_mtu;
 	failover_dev->max_mtu = standby_dev->max_mtu;
 
+	nfo_info = netdev_priv(failover_dev);
+	spin_lock_init(&nfo_info->stats_lock);
+
 	err = register_netdev(failover_dev);
 	if (err) {
 		dev_err(dev, "Unable to register failover_dev!\n");
-- 
2.25.1

