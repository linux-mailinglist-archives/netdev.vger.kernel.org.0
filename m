Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAEF54FBBB6
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 14:06:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344572AbiDKMI4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 08:08:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245477AbiDKMIz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 08:08:55 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C02363E5ED
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 05:06:40 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id t25so26198968lfg.7
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 05:06:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rXcyNj7Vd3u+8OdOq0xJsOP6YBIrQv/PZ4MI0oLOntI=;
        b=ExeCFleEWPoVEWR806xv1ZzfSpbYn7QBn32PlYOICQTS4hJa5Vhaw0cH1PwZhzRwnj
         GOADjJB7nL5K6/vEVrD13CuYGBX2cqvgRu9taoU1gCaMgvaGQNkUpPOlXtGPTNu2NZga
         MuZk8C2fGNcZ49PSSd07Wt/Y3kuXR8+cfcB6U6cEXMJF/uVnCfpxRdnI3sqYdiqigaZN
         /ACW9kd/pR3i48EsXACSQJRwowK1Af7aoVpVsxLcUUbBjPJTh2/p0HPRVy21C2DbCVuI
         DYBAdYiayFKZl4XQwNOjqnwFGefAODVrPj0CF+q4iDh4pIwmm7O0J/9ahD7XhuP/fpiM
         5whQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rXcyNj7Vd3u+8OdOq0xJsOP6YBIrQv/PZ4MI0oLOntI=;
        b=bMS4npLbD5c9aWWwrPl4/5BYf+u1xl4UgzpU0IegdE+qe4Irk4QERctsqpBHpxbg1a
         zAPaM2sDbUcqnQqEOHqybl3ysF5ZoGFhguAmFfMYTfRqs0DC1hePv6kiG30bbwnXkLZB
         uiCEijPQ1lwACKEj8pbBYkG/fEGmWAYQiLzjn/5GWwfekxrriRgvLerY7j+6dqmfzlT1
         kix1xbDPoWoRke3seAiDiOEOpD29hurLSaYsthyKtoJTxo8yYUN+sLlkAv9n6Ab87WNO
         rupRkNdi9JFi+Im3BQ+UbJQMdsQ+DKWxmRCgtDSR7gHfs4Bozl1RuXk3Y9NsW8J+Z6oW
         HRZQ==
X-Gm-Message-State: AOAM533Fm+KMA5BiL35OXpBCw9KDDY+XUTB8hZjNYwahKySotmR+mzRC
        AHQSj8L1MDFzVjxlRIAtH7ECsaxBZt/DXA==
X-Google-Smtp-Source: ABdhPJwJfkWPNJzmqi7pR1bAhHCSNr80vryanb0eV710Lh/0sIYMtRwba+pvOS0M2R/sOf7ojoiWvQ==
X-Received: by 2002:ac2:43c3:0:b0:46b:81f8:ac21 with SMTP id u3-20020ac243c3000000b0046b81f8ac21mr12285422lfl.554.1649678798547;
        Mon, 11 Apr 2022 05:06:38 -0700 (PDT)
Received: from wse-c0089.raspi.local (h-98-128-237-157.A259.priv.bahnhof.se. [98.128.237.157])
        by smtp.gmail.com with ESMTPSA id s10-20020a19ad4a000000b0044826a25a2esm3297627lfd.292.2022.04.11.05.06.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Apr 2022 05:06:37 -0700 (PDT)
From:   Mattias Forsblad <mattias.forsblad@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Mattias Forsblad <mattias.forsblad@gmail.com>
Subject: [PATCH v4 net-next 1/3] net: dsa: track whetever bridges have foreign interfaces in them
Date:   Mon, 11 Apr 2022 14:06:31 +0200
Message-Id: <20220411120633.40054-2-mattias.forsblad@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220411120633.40054-1-mattias.forsblad@gmail.com>
References: <20220411120633.40054-1-mattias.forsblad@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Track if a bridge stack has any foreign interfaces in them.

This patch is based on work done by Vlodimir Oltean.

Signed-off-by: Mattias Forsblad <mattias.forsblad@gmail.com>
---
 include/net/dsa.h  |  1 +
 net/dsa/dsa_priv.h |  1 +
 net/dsa/slave.c    | 88 +++++++++++++++++++++++++++++++++++++++++-----
 3 files changed, 81 insertions(+), 9 deletions(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 934958fda962..52b6da7d45b3 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -242,6 +242,7 @@ struct dsa_bridge {
 	unsigned int num;
 	bool tx_fwd_offload;
 	refcount_t refcount;
+	u8 have_foreign:1;
 };
 
 struct dsa_port {
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index 5d3f4a67dce1..d610776ecd76 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -320,6 +320,7 @@ void dsa_slave_setup_tagger(struct net_device *slave);
 int dsa_slave_change_mtu(struct net_device *dev, int new_mtu);
 int dsa_slave_manage_vlan_filtering(struct net_device *dev,
 				    bool vlan_filtering);
+int dsa_bridge_foreign_dev_update(struct net_device *bridge_dev);
 
 static inline struct dsa_port *dsa_slave_to_port(const struct net_device *dev)
 {
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 41c69a6e7854..feaf64564c6e 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -2485,6 +2485,9 @@ static int dsa_slave_changeupper(struct net_device *dev,
 	struct netlink_ext_ack *extack;
 	int err = NOTIFY_DONE;
 
+	if (!dsa_slave_dev_check(dev))
+		return err;
+
 	extack = netdev_notifier_info_to_extack(&info->info);
 
 	if (netif_is_bridge_master(info->upper_dev)) {
@@ -2539,6 +2542,9 @@ static int dsa_slave_prechangeupper(struct net_device *dev,
 {
 	struct dsa_port *dp = dsa_slave_to_port(dev);
 
+	if (!dsa_slave_dev_check(dev))
+		return NOTIFY_DONE;
+
 	if (netif_is_bridge_master(info->upper_dev) && !info->linking)
 		dsa_port_pre_bridge_leave(dp, info->upper_dev);
 	else if (netif_is_lag_master(info->upper_dev) && !info->linking)
@@ -2559,6 +2565,9 @@ dsa_slave_lag_changeupper(struct net_device *dev,
 	int err = NOTIFY_DONE;
 	struct dsa_port *dp;
 
+	if (!netif_is_lag_master(dev))
+		return err;
+
 	netdev_for_each_lower_dev(dev, lower, iter) {
 		if (!dsa_slave_dev_check(lower))
 			continue;
@@ -2588,6 +2597,9 @@ dsa_slave_lag_prechangeupper(struct net_device *dev,
 	int err = NOTIFY_DONE;
 	struct dsa_port *dp;
 
+	if (!netif_is_lag_master(dev))
+		return err;
+
 	netdev_for_each_lower_dev(dev, lower, iter) {
 		if (!dsa_slave_dev_check(lower))
 			continue;
@@ -2605,6 +2617,18 @@ dsa_slave_lag_prechangeupper(struct net_device *dev,
 	return err;
 }
 
+static int dsa_bridge_changelower(struct net_device *dev,
+				  struct netdev_notifier_changeupper_info *info)
+{
+	int err;
+
+	if (!netif_is_bridge_master(info->upper_dev))
+		return NOTIFY_DONE;
+
+	err = dsa_bridge_foreign_dev_update(info->upper_dev);
+	return notifier_from_errno(err);
+}
+
 static int
 dsa_prevent_bridging_8021q_upper(struct net_device *dev,
 				 struct netdev_notifier_changeupper_info *info)
@@ -2709,22 +2733,33 @@ static int dsa_slave_netdevice_event(struct notifier_block *nb,
 		if (err != NOTIFY_DONE)
 			return err;
 
-		if (dsa_slave_dev_check(dev))
-			return dsa_slave_prechangeupper(dev, ptr);
+		err = dsa_slave_prechangeupper(dev, ptr);
+		if (notifier_to_errno(err))
+			return err;
 
-		if (netif_is_lag_master(dev))
-			return dsa_slave_lag_prechangeupper(dev, ptr);
+		err = dsa_slave_lag_prechangeupper(dev, ptr);
+		if (notifier_to_errno(err))
+			return err;
 
 		break;
 	}
-	case NETDEV_CHANGEUPPER:
-		if (dsa_slave_dev_check(dev))
-			return dsa_slave_changeupper(dev, ptr);
+	case NETDEV_CHANGEUPPER: {
+		int err;
 
-		if (netif_is_lag_master(dev))
-			return dsa_slave_lag_changeupper(dev, ptr);
+		err = dsa_slave_changeupper(dev, ptr);
+		if (notifier_to_errno(err))
+			return err;
+
+		err = dsa_slave_lag_changeupper(dev, ptr);
+		if (notifier_to_errno(err))
+			return err;
+
+		err = dsa_bridge_changelower(dev, ptr);
+		if (notifier_to_errno(err))
+			return err;
 
 		break;
+	}
 	case NETDEV_CHANGELOWERSTATE: {
 		struct netdev_notifier_changelowerstate_info *info = ptr;
 		struct dsa_port *dp;
@@ -2877,6 +2912,41 @@ static bool dsa_foreign_dev_check(const struct net_device *dev,
 	return true;
 }
 
+int dsa_bridge_foreign_dev_update(struct net_device *bridge_dev)
+{
+	struct net_device *first_slave, *lower;
+	struct dsa_bridge *bridge = NULL;
+	struct dsa_switch_tree *dst;
+	bool have_foreign = false;
+	struct list_head *iter;
+	struct dsa_port *dp;
+
+	list_for_each_entry(dst, &dsa_tree_list, list) {
+		dsa_tree_for_each_user_port(dp, dst) {
+			if (dsa_port_offloads_bridge_dev(dp, bridge_dev)) {
+				bridge = dp->bridge;
+				first_slave = dp->slave;
+				break;
+			}
+		}
+	}
+
+	/* Bridge with no DSA interface in it */
+	if (!bridge)
+		return 0;
+
+	netdev_for_each_lower_dev(bridge_dev, lower, iter) {
+		if (dsa_foreign_dev_check(first_slave, lower)) {
+			have_foreign = true;
+			break;
+		}
+	}
+
+	bridge->have_foreign = have_foreign;
+
+	return 0;
+}
+
 static int dsa_slave_fdb_event(struct net_device *dev,
 			       struct net_device *orig_dev,
 			       unsigned long event, const void *ctx,
-- 
2.25.1

