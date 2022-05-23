Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B791F530F39
	for <lists+netdev@lfdr.de>; Mon, 23 May 2022 15:18:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234225AbiEWKnw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 06:43:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234194AbiEWKn2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 06:43:28 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7450EFC7
        for <netdev@vger.kernel.org>; Mon, 23 May 2022 03:43:25 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id j28so18493736eda.13
        for <netdev@vger.kernel.org>; Mon, 23 May 2022 03:43:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0jjXvtFnIPMsxjxWeaswnMn6d7926FBVTg55lXT6y/g=;
        b=aBugpW7Hy6GBO5GDSknc3cBRs41W4h2UMXwaQYlArsKYzffRj5llZ+sp7l8YyuBw8F
         0WF8J2nfQOlQkUPVBMB0rHxAYwSOuvpcRQoyEhKh/9HW4sCyqlXIH7hJHp2hPDX53xzA
         j/8JDUBFgbqXgYPl/vpJDAqvR9wHvDoMtcq/D1qXGCxIg5BT2ZZ++/1KSzP9q46+v4yh
         x05GsLI3Afj9PoHRYtSHVrtzYfJus4Ccm7y+zFJH1CQGt1R5MXoAla1HflVpcOuLjHrM
         2paDjvfY2Dsl6GW6ego/EkiGNuIY8qBcAFOtO+WBnrnleKUHT/EzGVty/0dq+OtIviW2
         pFtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0jjXvtFnIPMsxjxWeaswnMn6d7926FBVTg55lXT6y/g=;
        b=USfWVfFGAEkRxJg0JM4ePGTgJAYqqhHEcIJPtm+QlPWaTZpEjJjijMNT12fqshhvc/
         YqRckr+pGWpxWcJ7FnXph8j//7Ew/wiAEaz67H7Wy2DMN1seINNIVkxN0IQBiCmTs/xP
         WReIdGA317bIh6YvYqZGkZ93DIADGhPdOR++8+ev7ekqMSauomkKPOWbLUQE4sDLL2/M
         Ljk1YFfmOk21QlLQdmIClVlQmENmmixHlQUy9DiC7a8JWBZ6jfsKrC87o+hKATm1OcYk
         EZJQJVKgrXG1OydXAe5DwUOe3LhqxvFUjpr4XOiyezvq2xGeb+78LZXe0PUhrDASci6B
         XiPA==
X-Gm-Message-State: AOAM531GwK+SSxx+PBpbhA9uqwy1mqwWNnv/A8nb5TyZZgofYKupnMzl
        ode404iWwTttgxaAhEOQvtRLMk01rII=
X-Google-Smtp-Source: ABdhPJzeqIVMRR2keN65m0UiqIefdZTAEz75Fq1qEiYd3sg3n3k+4YIge8sdasxEFko/GaQZLXwiIg==
X-Received: by 2002:a05:6402:3289:b0:42b:4d05:ac85 with SMTP id f9-20020a056402328900b0042b4d05ac85mr9257705eda.106.1653302603437;
        Mon, 23 May 2022 03:43:23 -0700 (PDT)
Received: from localhost.localdomain ([188.25.255.186])
        by smtp.gmail.com with ESMTPSA id j18-20020a1709066dd200b006feb875503fsm2584822ejt.78.2022.05.23.03.43.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 May 2022 03:43:22 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Colin Foster <colin.foster@in-advantage.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Frank Wunderlich <frank-w@public-files.de>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [RFC PATCH net-next 11/12] net: dsa: allow masters to join a LAG
Date:   Mon, 23 May 2022 13:42:55 +0300
Message-Id: <20220523104256.3556016-12-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220523104256.3556016-1-olteanv@gmail.com>
References: <20220523104256.3556016-1-olteanv@gmail.com>
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

From: Vladimir Oltean <vladimir.oltean@nxp.com>

There are 2 ways in which a DSA user port may become handled by 2 CPU
ports in a LAG:

(1) its current DSA master joins a LAG

 ip link del bond0 && ip link add bond0 type bond mode 802.3ad
 ip link set eno2 master bond0

When this happens, all user ports with "eno2" as DSA master get
automatically migrated to "bond0" as DSA master.

(2) it is explicitly configured as such by the user

 # Before, the DSA master was eno3
 ip link set swp0 type dsa master bond0

The design of this configuration is that the LAG device dynamically
becomes a DSA master through dsa_master_setup() when the first physical
DSA master becomes a LAG slave, and stops being so through
dsa_master_teardown() when the last physical DSA master leaves.

A LAG interface is considered as a valid DSA master only if it contains
existing DSA masters, and no other lower interfaces. Therefore, we
mainly rely on method (1) to enter this configuration.

Each physical DSA master (LAG slave) retains its dev->dsa_ptr for when
it becomes a standalone DSA master again. But the LAG master also has a
dev->dsa_ptr, and this is actually duplicated from one of the physical
LAG slaves, and therefore needs to be balanced when LAG slaves come and
go.

To the switch driver, putting DSA masters in a LAG is seen as putting
their associated CPU ports in a LAG.

We need to prepare cross-chip host FDB notifiers for CPU ports in a LAG,
by calling the driver's ->lag_fdb_add method rather than ->port_fdb_add.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 include/net/dsa.h  |   6 ++
 net/dsa/dsa_priv.h |   5 ++
 net/dsa/master.c   |  59 +++++++++++++++++
 net/dsa/port.c     |   1 +
 net/dsa/slave.c    | 157 +++++++++++++++++++++++++++++++++++++++++++--
 net/dsa/switch.c   |  22 +++++--
 6 files changed, 242 insertions(+), 8 deletions(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 0958ad3289c9..158efd3e2ab3 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -296,6 +296,9 @@ struct dsa_port {
 	u8			master_admin_up:1;
 	u8			master_oper_up:1;
 
+	/* Valid only on user ports */
+	u8			cpu_port_in_lag:1;
+
 	u8			setup:1;
 
 	struct device_node	*dn;
@@ -720,6 +723,9 @@ static inline bool dsa_port_offloads_lag(struct dsa_port *dp,
 
 static inline struct net_device *dsa_port_to_master(const struct dsa_port *dp)
 {
+	if (dp->cpu_port_in_lag)
+		return dsa_port_lag_dev_get(dp->cpu_dp);
+
 	return dp->cpu_dp->master;
 }
 
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index 1ce0e48d5a92..236fb1fb7b6c 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -184,6 +184,11 @@ static inline int dsa_tag_protocol_overhead(const struct dsa_device_ops *ops)
 /* master.c */
 int dsa_master_setup(struct net_device *dev, struct dsa_port *cpu_dp);
 void dsa_master_teardown(struct net_device *dev);
+int dsa_master_lag_setup(struct net_device *lag_dev, struct dsa_port *cpu_dp,
+			 struct netdev_lag_upper_info *uinfo,
+			 struct netlink_ext_ack *extack);
+void dsa_master_lag_teardown(struct net_device *lag_dev,
+			     struct dsa_port *cpu_dp);
 
 static inline struct net_device *dsa_master_find_slave(struct net_device *dev,
 						       int device, int port)
diff --git a/net/dsa/master.c b/net/dsa/master.c
index a7420bad0a0a..66fb972da2dd 100644
--- a/net/dsa/master.c
+++ b/net/dsa/master.c
@@ -418,3 +418,62 @@ void dsa_master_teardown(struct net_device *dev)
 	 */
 	wmb();
 }
+
+int dsa_master_lag_setup(struct net_device *lag_dev, struct dsa_port *cpu_dp,
+			 struct netdev_lag_upper_info *uinfo,
+			 struct netlink_ext_ack *extack)
+{
+	bool master_setup = false;
+	struct net_device *lower;
+	struct list_head *iter;
+	int err;
+
+	/* To be eligible as a DSA master, a LAG must have all lower
+	 * interfaces be eligible DSA masters.
+	 */
+	netdev_for_each_lower_dev(lag_dev, lower, iter) {
+		if (!netdev_uses_dsa(lower)) {
+			NL_SET_ERR_MSG_MOD(extack,
+					   "All LAG ports must be eligible as DSA masters");
+			return -EINVAL;
+		}
+	}
+
+	if (!netdev_uses_dsa(lag_dev)) {
+		err = dsa_master_setup(lag_dev, cpu_dp);
+		if (err)
+			return err;
+	}
+
+	err = dsa_port_lag_join(cpu_dp, lag_dev, uinfo, extack);
+	if (err) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "CPU port failed to join LAG");
+		goto out_master_teardown;
+	}
+
+	return 0;
+
+out_master_teardown:
+	if (master_setup)
+		dsa_master_teardown(lag_dev);
+	return err;
+}
+
+/* Tear down a master if there isn't any other user port on it,
+ * optionally also destroying LAG information.
+ */
+void dsa_master_lag_teardown(struct net_device *lag_dev,
+			     struct dsa_port *cpu_dp)
+{
+	struct net_device *upper;
+	struct list_head *iter;
+
+	dsa_port_lag_leave(cpu_dp, lag_dev);
+
+	netdev_for_each_upper_dev_rcu(lag_dev, upper, iter)
+		if (dsa_slave_dev_check(upper))
+			return;
+
+	dsa_master_teardown(lag_dev);
+}
diff --git a/net/dsa/port.c b/net/dsa/port.c
index ced7f8d8ec62..a90c03d15061 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -1388,6 +1388,7 @@ static int dsa_port_assign_master(struct dsa_port *dp,
 		return err;
 
 	dp->cpu_dp = master->dsa_ptr;
+	dp->cpu_port_in_lag = netif_is_lag_master(master);
 
 	return 0;
 }
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 95bfce49d57d..f21524c0fbd5 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -2812,6 +2812,10 @@ dsa_master_prechangeupper_sanity_check(struct net_device *master,
 	if (netif_is_bridge_master(info->upper_dev))
 		return NOTIFY_DONE;
 
+	/* Allow LAG uppers */
+	if (netif_is_lag_master(info->upper_dev))
+		return NOTIFY_DONE;
+
 	extack = netdev_notifier_info_to_extack(&info->info);
 
 	NL_SET_ERR_MSG_MOD(extack,
@@ -2859,6 +2863,138 @@ dsa_bridge_prechangelower_sanity_check(struct net_device *new_lower,
 	return NOTIFY_DONE;
 }
 
+static void dsa_tree_migrate_ports_from_lag_master(struct dsa_switch_tree *dst,
+						   struct net_device *lag_dev)
+{
+	struct net_device *new_master;
+	struct dsa_port *dp;
+	int err;
+
+	new_master = dsa_tree_find_first_master(dst);
+
+	dsa_tree_for_each_user_port(dp, dst) {
+		if (dsa_port_to_master(dp) != lag_dev)
+			continue;
+
+		err = dsa_port_change_master(dp, new_master, NULL);
+		if (err) {
+			netdev_err(dp->slave,
+				   "failed to restore master to %s: %pe\n",
+				   new_master->name, ERR_PTR(err));
+		}
+	}
+}
+
+static int dsa_master_lag_join(struct net_device *master,
+			       struct net_device *lag_dev,
+			       struct netdev_lag_upper_info *uinfo,
+			       struct netlink_ext_ack *extack)
+{
+	struct dsa_port *cpu_dp = master->dsa_ptr;
+	struct dsa_switch_tree *dst = cpu_dp->dst;
+	struct dsa_port *dp;
+	int err;
+
+	err = dsa_master_lag_setup(lag_dev, cpu_dp, uinfo, extack);
+	if (err)
+		return err;
+
+	dsa_tree_for_each_user_port(dp, dst) {
+		if (dsa_port_to_master(dp) != master)
+			continue;
+
+		err = dsa_port_change_master(dp, lag_dev, extack);
+		if (err)
+			goto restore;
+	}
+
+	return 0;
+
+restore:
+	dsa_tree_for_each_user_port_continue_reverse(dp, dst) {
+		if (dsa_port_to_master(dp) != lag_dev)
+			continue;
+
+		err = dsa_port_change_master(dp, master, NULL);
+		if (err) {
+			netdev_err(dp->slave,
+				   "failed to restore master to %s: %pe\n",
+				   master->name, ERR_PTR(err));
+		}
+	}
+
+	dsa_master_lag_teardown(lag_dev, master->dsa_ptr);
+
+	return err;
+}
+
+static void dsa_master_lag_leave(struct net_device *master,
+				 struct net_device *lag_dev)
+{
+	struct dsa_port *dp, *cpu_dp = lag_dev->dsa_ptr;
+	struct dsa_switch_tree *dst = cpu_dp->dst;
+	struct dsa_port *new_cpu_dp = NULL;
+	struct net_device *lower;
+	struct list_head *iter;
+
+	netdev_for_each_lower_dev(lag_dev, lower, iter) {
+		if (netdev_uses_dsa(lower)) {
+			new_cpu_dp = lower->dsa_ptr;
+			break;
+		}
+	}
+
+	if (new_cpu_dp) {
+		/* Update the CPU port of the user ports still under the LAG
+		 * so that dsa_port_to_master() continues to work properly
+		 */
+		dsa_tree_for_each_user_port(dp, dst)
+			if (dsa_port_to_master(dp) == lag_dev)
+				dp->cpu_dp = new_cpu_dp;
+
+		/* Update the index of the virtual CPU port to match the lowest
+		 * physical CPU port
+		 */
+		lag_dev->dsa_ptr = new_cpu_dp;
+		wmb();
+	} else {
+		/* If the LAG DSA master has no ports left, migrate back all
+		 * user ports to the first physical CPU port
+		 */
+		dsa_tree_migrate_ports_from_lag_master(dst, lag_dev);
+	}
+
+	/* This DSA master has left its LAG in any case, so let
+	 * the CPU port leave the hardware LAG as well
+	 */
+	dsa_master_lag_teardown(lag_dev, master->dsa_ptr);
+}
+
+static int dsa_master_changeupper(struct net_device *dev,
+				  struct netdev_notifier_changeupper_info *info)
+{
+	struct netlink_ext_ack *extack;
+	int err = NOTIFY_DONE;
+
+	if (!netdev_uses_dsa(dev))
+		return err;
+
+	extack = netdev_notifier_info_to_extack(&info->info);
+
+	if (netif_is_lag_master(info->upper_dev)) {
+		if (info->linking) {
+			err = dsa_master_lag_join(dev, info->upper_dev,
+						  info->upper_info, extack);
+			err = notifier_from_errno(err);
+		} else {
+			dsa_master_lag_leave(dev, info->upper_dev);
+			err = NOTIFY_OK;
+		}
+	}
+
+	return err;
+}
+
 static int dsa_slave_netdevice_event(struct notifier_block *nb,
 				     unsigned long event, void *ptr)
 {
@@ -2902,6 +3038,10 @@ static int dsa_slave_netdevice_event(struct notifier_block *nb,
 		if (notifier_to_errno(err))
 			return err;
 
+		err = dsa_master_changeupper(dev, ptr);
+		if (notifier_to_errno(err))
+			return err;
+
 		break;
 	}
 	case NETDEV_CHANGELOWERSTATE: {
@@ -2909,12 +3049,21 @@ static int dsa_slave_netdevice_event(struct notifier_block *nb,
 		struct dsa_port *dp;
 		int err;
 
-		if (!dsa_slave_dev_check(dev))
-			break;
+		if (dsa_slave_dev_check(dev)) {
+			dp = dsa_slave_to_port(dev);
+
+			err = dsa_port_lag_change(dp, info->lower_state_info);
+		}
 
-		dp = dsa_slave_to_port(dev);
+		/* Mirror LAG port events on DSA masters that are in
+		 * a LAG towards their respective switch CPU ports
+		 */
+		if (netdev_uses_dsa(dev)) {
+			dp = dev->dsa_ptr;
+
+			err = dsa_port_lag_change(dp, info->lower_state_info);
+		}
 
-		err = dsa_port_lag_change(dp, info->lower_state_info);
 		return notifier_from_errno(err);
 	}
 	case NETDEV_CHANGE:
diff --git a/net/dsa/switch.c b/net/dsa/switch.c
index 2b56218fc57c..f443916d2571 100644
--- a/net/dsa/switch.c
+++ b/net/dsa/switch.c
@@ -397,8 +397,15 @@ static int dsa_switch_host_fdb_add(struct dsa_switch *ds,
 
 	dsa_switch_for_each_port(dp, ds) {
 		if (dsa_port_host_address_match(dp, info->dp)) {
-			err = dsa_port_do_fdb_add(dp, info->addr, info->vid,
-						  info->db);
+			if (dsa_port_is_cpu(dp) && info->dp->cpu_port_in_lag) {
+				err = dsa_switch_do_lag_fdb_add(ds, dp->lag,
+								info->addr,
+								info->vid,
+								info->db);
+			} else {
+				err = dsa_port_do_fdb_add(dp, info->addr,
+							  info->vid, info->db);
+			}
 			if (err)
 				break;
 		}
@@ -418,8 +425,15 @@ static int dsa_switch_host_fdb_del(struct dsa_switch *ds,
 
 	dsa_switch_for_each_port(dp, ds) {
 		if (dsa_port_host_address_match(dp, info->dp)) {
-			err = dsa_port_do_fdb_del(dp, info->addr, info->vid,
-						  info->db);
+			if (dsa_port_is_cpu(dp) && info->dp->cpu_port_in_lag) {
+				err = dsa_switch_do_lag_fdb_del(ds, dp->lag,
+								info->addr,
+								info->vid,
+								info->db);
+			} else {
+				err = dsa_port_do_fdb_del(dp, info->addr,
+							  info->vid, info->db);
+			}
 			if (err)
 				break;
 		}
-- 
2.25.1

