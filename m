Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 300422F023F
	for <lists+netdev@lfdr.de>; Sat,  9 Jan 2021 18:29:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726449AbhAIR2x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Jan 2021 12:28:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726364AbhAIR2t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Jan 2021 12:28:49 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51329C0617B9
        for <netdev@vger.kernel.org>; Sat,  9 Jan 2021 09:27:43 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id b2so14497350edm.3
        for <netdev@vger.kernel.org>; Sat, 09 Jan 2021 09:27:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qELohY8xdTwjVtkkFqS+BhQWIgNycVEsz2+Yrh+djOs=;
        b=lATd2P56io+FTLKSvvGxLfXaW8q5/G0KjiA8Jlp7pzATPAoQjbY6/eC3hT76CnSDkT
         5Ix2iOcMLBMs11OKaE3TNlTikEZso6GZJ07Hh7McyOd57/m8qfPfL47sDqMIGdig22cV
         PXr0AJ3+a5XQtPjlILNYRae4ddR7Kt4dKn9kcugNxev/rz78O/nA0XrMBbwaEb0C3zpm
         yi7tXiseO21VoPHDMKSgJU2QkXuHiqprf+ousmVs35/iwsUSUGIVJ0gOGzOWd0J/nD5a
         IqHnCAyEpjEKVT6JAcq4rkEyau6e/avT/3w6K3Z8LPl/l47SY66Vm5mBIrb/Nw8pCS7L
         dyOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qELohY8xdTwjVtkkFqS+BhQWIgNycVEsz2+Yrh+djOs=;
        b=qhk9jjUeLIMD+0/8+WpLpMNtuh2qz8Yh88ZXUv7tDMyV+Mo1O5u+Iph2I5vebXmAzC
         NMN8Hp/ol6a1hbfeAdLCjeSCABSTPmql9C77Tme0kV7kRiktKh7wQK24iYoutVTD2CSU
         /9KzTCpDPOeo0nu9R8FgD4FFL6OAYXWixWn+ol4z9MRDhMJAq1f4oJsVWpQ8W0b8ABai
         5WhCBig6tGhhHHPm1OX4lPuIcxoq2lTYtK4EqCAB3QrFxBQSu05CB42rZkIP0orPmwJG
         SbnpQhCh0VHbeclUuHuPTsSeUJKUq3MrOmA1y+zsdDYd33wePfE51c3+js/GV27QiTkZ
         j9WA==
X-Gm-Message-State: AOAM530Y8xOapDIYFVtvYPKDjRt+AUWiLp+fON8q4Kp8LQDWQ4SoPQ9N
        iSOI9t9JeRawKIAUpPwrTb8=
X-Google-Smtp-Source: ABdhPJwOFPD0YQ0aDSA8zjKg0mlC8b1m7ew7djA2gP9peFhkG0y2DghlfkcyOhtxikxowNKY3ktFmw==
X-Received: by 2002:a50:f404:: with SMTP id r4mr9011723edm.62.1610213261995;
        Sat, 09 Jan 2021 09:27:41 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id h16sm4776714eji.110.2021.01.09.09.27.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Jan 2021 09:27:41 -0800 (PST)
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
Subject: [PATCH v6 net-next 13/15] net: net_failover: ensure .ndo_get_stats64 can sleep
Date:   Sat,  9 Jan 2021 19:26:22 +0200
Message-Id: <20210109172624.2028156-14-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210109172624.2028156-1-olteanv@gmail.com>
References: <20210109172624.2028156-1-olteanv@gmail.com>
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
interface. This is ok because it is reentrant, and generally speaking,
dev_get_stats is recursive. But it is also not ok, because holding
rcu_read_lock() while calling dev_get_stats will incur atomic context
upon it, and that needs to change.

The existing logic can be rehashed just a little bit such that the
recursive dev_get_stats call will not be under any lock. We can achieve
that by "cheating" a little bit and use dev_hold() to take a reference
on the active and backup interfaces, and netdev_wait_allrefs() will just
have to wait until dev_get_stats() finishes.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v6:
Slightly touch up the commit message.

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
index 2815228a34d5..8b7a6d1eab30 100644
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

