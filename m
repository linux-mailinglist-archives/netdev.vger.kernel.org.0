Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A836D43F78D
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 08:55:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232116AbhJ2G6O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 02:58:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232091AbhJ2G6N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Oct 2021 02:58:13 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD15CC061570
        for <netdev@vger.kernel.org>; Thu, 28 Oct 2021 23:55:45 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id t5-20020a17090a4e4500b001a0a284fcc2so9869878pjl.2
        for <netdev@vger.kernel.org>; Thu, 28 Oct 2021 23:55:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2SJEveoL0kfj+u0wsEcSvHexsxTeBwDlfMTgwzArCvo=;
        b=HG4miO2lUIYVwQTDM+DVXgYr6DGFJLU3yN3vQpVJuDXbyUOqQc2lI0FypfScG5oBa6
         h93HgsV6IwNp+2+V22P1wKGslK1pJ/wqWjhCOP9xTGq7HRPotWXaJb+YPpYU959Jy2u0
         PlvHWstb2Jj+nasgJALhvmOzvyFjtyhglHUhNmbfn6uAPMEUhMiW3T9TnHi7uTsW9tBn
         r/ZHGp/k1TbFyW3mT77hkxGHJkR09IMklxFQsV3Ww+h7QoLJFxbJlPToJuwAZp9fXfgB
         u7woQNjL6d/7xERHA4l9NX0EjtaF/HeTIV7R+n9nRmH10WfQXWe9eR1Ist6hF5P2Uwwd
         qA1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2SJEveoL0kfj+u0wsEcSvHexsxTeBwDlfMTgwzArCvo=;
        b=LRWy94jUvdkvVP7/pSHrQttwHDsRmrBWP9paitG3/iGWYNg+nxlsuu3E/2FcRkUJxA
         wUZpl2lKdwGxjhsXOA0QgnE58RaRECVu78Pw93RHA4jwW75elY+cVW+hdXI/M+J0XTF0
         ZKA1UOwA27dJuppy7Le0uduTd2XkK1x64VI5ZrSE1rSTMejBEM2wGxqFYPlNYahQJqZH
         E6EHXMrUM3D4nqGwhCZbFzBMv0YXmBCEOzxOz/FGK8MKjzoSuJ9xJMi6Y+OT3tr0N0pu
         I9fB24EzImqyZwVVNl/bxRU9pqZy4YoB+WT3qAVRG/Zljdn0M33IYB/ZlOqgzRA51kZ9
         H8gg==
X-Gm-Message-State: AOAM533prmp7LXwGx54KcfjX9/Nm0svRG/UFUDZTDfbkbz8/QXShJqiy
        2OrRR4+d3ge8knjrdRAcNO2NDrdYYlc=
X-Google-Smtp-Source: ABdhPJyi5Ra/D5Y/954/20QzeL4tLtw/NhGA2e8a0e4YX0OX5E+C2MzekbixiVhiauLVvNHeMDZlEQ==
X-Received: by 2002:a17:902:7001:b0:13d:d5b7:d06e with SMTP id y1-20020a170902700100b0013dd5b7d06emr8192379plk.61.1635490545093;
        Thu, 28 Oct 2021 23:55:45 -0700 (PDT)
Received: from Laptop-X1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id x9sm9353360pjp.50.2021.10.28.23.55.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Oct 2021 23:55:44 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Jiri Pirko <jiri@resnulli.us>,
        Jonathan Toppins <jtoppins@redhat.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [Draft PATCH net-next] Bonding: add missed_max option
Date:   Fri, 29 Oct 2021 14:55:29 +0800
Message-Id: <20211029065529.27367-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Currently, we use hard code number to verify if we are in the
arp_interval timeslice. But some user may want to narrow/extend
the verify timeslice. With the similar team option 'missed_max'
the uers could change that number based on their own environment.

Would you like to help review and see if this is a proper place
for `missed_max` and if I missed anything?

Thanks

Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 Documentation/networking/bonding.rst | 10 ++++++++++
 drivers/net/bonding/bond_main.c      | 17 +++++++++--------
 drivers/net/bonding/bond_netlink.c   | 15 +++++++++++++++
 drivers/net/bonding/bond_options.c   | 21 +++++++++++++++++++++
 drivers/net/bonding/bond_procfs.c    |  2 ++
 drivers/net/bonding/bond_sysfs.c     | 13 +++++++++++++
 include/net/bond_options.h           |  1 +
 include/net/bonding.h                |  1 +
 include/uapi/linux/if_link.h         |  1 +
 tools/include/uapi/linux/if_link.h   |  1 +
 10 files changed, 74 insertions(+), 8 deletions(-)

diff --git a/Documentation/networking/bonding.rst b/Documentation/networking/bonding.rst
index 31cfd7d674a6..41bb5869ff5f 100644
--- a/Documentation/networking/bonding.rst
+++ b/Documentation/networking/bonding.rst
@@ -421,6 +421,16 @@ arp_all_targets
 		consider the slave up only when all of the arp_ip_targets
 		are reachable
 
+missed_max
+
+        Maximum number of arp_interval for missed ARP replies.
+        If this number is exceeded, link is reported as down.
+
+        Note a small value means a strict time. e.g. missed_max is 1 means
+        the correct arp reply must be recived during the interval.
+
+        default 3
+
 downdelay
 
 	Specifies the time, in milliseconds, to wait before disabling
diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index ff8da720a33a..3baae78a7736 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -3129,8 +3129,8 @@ static void bond_loadbalance_arp_mon(struct bonding *bond)
 			 * when the source ip is 0, so don't take the link down
 			 * if we don't know our ip yet
 			 */
-			if (!bond_time_in_interval(bond, trans_start, 2) ||
-			    !bond_time_in_interval(bond, slave->last_rx, 2)) {
+			if (!bond_time_in_interval(bond, trans_start, bond->params.missed_max) ||
+			    !bond_time_in_interval(bond, slave->last_rx, bond->params.missed_max)) {
 
 				bond_propose_link_state(slave, BOND_LINK_DOWN);
 				slave_state_changed = 1;
@@ -3224,7 +3224,7 @@ static int bond_ab_arp_inspect(struct bonding *bond)
 
 		/* Backup slave is down if:
 		 * - No current_arp_slave AND
-		 * - more than 3*delta since last receive AND
+		 * - more than missed_max*delta since last receive AND
 		 * - the bond has an IP address
 		 *
 		 * Note: a non-null current_arp_slave indicates
@@ -3236,20 +3236,20 @@ static int bond_ab_arp_inspect(struct bonding *bond)
 		 */
 		if (!bond_is_active_slave(slave) &&
 		    !rcu_access_pointer(bond->current_arp_slave) &&
-		    !bond_time_in_interval(bond, last_rx, 3)) {
+		    !bond_time_in_interval(bond, last_rx, bond->params.missed_max)) {
 			bond_propose_link_state(slave, BOND_LINK_DOWN);
 			commit++;
 		}
 
 		/* Active slave is down if:
-		 * - more than 2*delta since transmitting OR
-		 * - (more than 2*delta since receive AND
+		 * - more than missed_max*delta since transmitting OR
+		 * - (more than missed_max*delta since receive AND
 		 *    the bond has an IP address)
 		 */
 		trans_start = dev_trans_start(slave->dev);
 		if (bond_is_active_slave(slave) &&
-		    (!bond_time_in_interval(bond, trans_start, 2) ||
-		     !bond_time_in_interval(bond, last_rx, 2))) {
+		    (!bond_time_in_interval(bond, trans_start, bond->params.missed_max) ||
+		     !bond_time_in_interval(bond, last_rx, bond->params.missed_max))) {
 			bond_propose_link_state(slave, BOND_LINK_DOWN);
 			commit++;
 		}
@@ -5822,6 +5822,7 @@ static int bond_check_params(struct bond_params *params)
 	params->arp_interval = arp_interval;
 	params->arp_validate = arp_validate_value;
 	params->arp_all_targets = arp_all_targets_value;
+	params->missed_max = 3;
 	params->updelay = updelay;
 	params->downdelay = downdelay;
 	params->peer_notif_delay = 0;
diff --git a/drivers/net/bonding/bond_netlink.c b/drivers/net/bonding/bond_netlink.c
index 5d54e11d18fa..30ccea63228e 100644
--- a/drivers/net/bonding/bond_netlink.c
+++ b/drivers/net/bonding/bond_netlink.c
@@ -110,6 +110,7 @@ static const struct nla_policy bond_policy[IFLA_BOND_MAX + 1] = {
 					    .len  = ETH_ALEN },
 	[IFLA_BOND_TLB_DYNAMIC_LB]	= { .type = NLA_U8 },
 	[IFLA_BOND_PEER_NOTIF_DELAY]    = { .type = NLA_U32 },
+	[IFLA_BOND_MISSED_MAX]		= { .type = NLA_U32 },
 };
 
 static const struct nla_policy bond_slave_policy[IFLA_BOND_SLAVE_MAX + 1] = {
@@ -453,6 +454,15 @@ static int bond_changelink(struct net_device *bond_dev, struct nlattr *tb[],
 			return err;
 	}
 
+	if (data[IFLA_BOND_MISSED_MAX]) {
+		int missed_max = nla_get_u8(data[IFLA_BOND_MISSED_MAX]);
+
+		bond_opt_initval(&newval, missed_max);
+		err = __bond_opt_set(bond, BOND_OPT_MISSED_MAX, &newval);
+		if (err)
+			return err;
+	}
+
 	return 0;
 }
 
@@ -515,6 +525,7 @@ static size_t bond_get_size(const struct net_device *bond_dev)
 		nla_total_size(ETH_ALEN) + /* IFLA_BOND_AD_ACTOR_SYSTEM */
 		nla_total_size(sizeof(u8)) + /* IFLA_BOND_TLB_DYNAMIC_LB */
 		nla_total_size(sizeof(u32)) +	/* IFLA_BOND_PEER_NOTIF_DELAY */
+		nla_total_size(sizeof(u32)) +	/* IFLA_BOND_MISSED_MAX */
 		0;
 }
 
@@ -650,6 +661,10 @@ static int bond_fill_info(struct sk_buff *skb,
 		       bond->params.tlb_dynamic_lb))
 		goto nla_put_failure;
 
+	if (nla_put_u8(skb, IFLA_BOND_MISSED_MAX,
+		       bond->params.missed_max))
+		goto nla_put_failure;
+
 	if (BOND_MODE(bond) == BOND_MODE_8023AD) {
 		struct ad_info info;
 
diff --git a/drivers/net/bonding/bond_options.c b/drivers/net/bonding/bond_options.c
index a8fde3bc458f..57772a9da543 100644
--- a/drivers/net/bonding/bond_options.c
+++ b/drivers/net/bonding/bond_options.c
@@ -78,6 +78,8 @@ static int bond_option_ad_actor_system_set(struct bonding *bond,
 					   const struct bond_opt_value *newval);
 static int bond_option_ad_user_port_key_set(struct bonding *bond,
 					    const struct bond_opt_value *newval);
+static int bond_option_missed_max_set(struct bonding *bond,
+				      const struct bond_opt_value *newval);
 
 
 static const struct bond_opt_value bond_mode_tbl[] = {
@@ -270,6 +272,15 @@ static const struct bond_option bond_opts[BOND_OPT_LAST] = {
 		.values = bond_intmax_tbl,
 		.set = bond_option_arp_interval_set
 	},
+	[BOND_OPT_MISSED_MAX] = {
+		.id = BOND_OPT_MISSED_MAX,
+		.name = "missed_max",
+		.desc = "Maximum number of missed ARP interval",
+		.unsuppmodes = BIT(BOND_MODE_8023AD) | BIT(BOND_MODE_TLB) |
+			       BIT(BOND_MODE_ALB),
+		.values = bond_intmax_tbl,
+		.set = bond_option_missed_max_set
+	},
 	[BOND_OPT_ARP_TARGETS] = {
 		.id = BOND_OPT_ARP_TARGETS,
 		.name = "arp_ip_target",
@@ -1186,6 +1197,16 @@ static int bond_option_arp_all_targets_set(struct bonding *bond,
 	return 0;
 }
 
+static int bond_option_missed_max_set(struct bonding *bond,
+				      const struct bond_opt_value *newval)
+{
+	netdev_dbg(bond->dev, "Setting missed max to %s (%llu)\n",
+		   newval->string, newval->value);
+	bond->params.missed_max = newval->value;
+
+	return 0;
+}
+
 static int bond_option_primary_set(struct bonding *bond,
 				   const struct bond_opt_value *newval)
 {
diff --git a/drivers/net/bonding/bond_procfs.c b/drivers/net/bonding/bond_procfs.c
index f3e3bfd72556..2ec11af5f0cc 100644
--- a/drivers/net/bonding/bond_procfs.c
+++ b/drivers/net/bonding/bond_procfs.c
@@ -115,6 +115,8 @@ static void bond_info_show_master(struct seq_file *seq)
 
 		seq_printf(seq, "ARP Polling Interval (ms): %d\n",
 				bond->params.arp_interval);
+		seq_printf(seq, "ARP Missed Max: %u\n",
+				bond->params.missed_max);
 
 		seq_printf(seq, "ARP IP target/s (n.n.n.n form):");
 
diff --git a/drivers/net/bonding/bond_sysfs.c b/drivers/net/bonding/bond_sysfs.c
index c48b77167fab..04da21f17503 100644
--- a/drivers/net/bonding/bond_sysfs.c
+++ b/drivers/net/bonding/bond_sysfs.c
@@ -303,6 +303,18 @@ static ssize_t bonding_show_arp_targets(struct device *d,
 static DEVICE_ATTR(arp_ip_target, 0644,
 		   bonding_show_arp_targets, bonding_sysfs_store_option);
 
+/* Show the arp missed max. */
+static ssize_t bonding_show_missed_max(struct device *d,
+				       struct device_attribute *attr,
+				       char *buf)
+{
+	struct bonding *bond = to_bond(d);
+
+	return sprintf(buf, "%u\n", bond->params.missed_max);
+}
+static DEVICE_ATTR(missed_max, 0644,
+		   bonding_show_missed_max, bonding_sysfs_store_option);
+
 /* Show the up and down delays. */
 static ssize_t bonding_show_downdelay(struct device *d,
 				      struct device_attribute *attr,
@@ -779,6 +791,7 @@ static struct attribute *per_bond_attrs[] = {
 	&dev_attr_ad_actor_sys_prio.attr,
 	&dev_attr_ad_actor_system.attr,
 	&dev_attr_ad_user_port_key.attr,
+	&dev_attr_missed_max.attr,
 	NULL,
 };
 
diff --git a/include/net/bond_options.h b/include/net/bond_options.h
index e64833a674eb..dd75c071f67e 100644
--- a/include/net/bond_options.h
+++ b/include/net/bond_options.h
@@ -65,6 +65,7 @@ enum {
 	BOND_OPT_NUM_PEER_NOTIF_ALIAS,
 	BOND_OPT_PEER_NOTIF_DELAY,
 	BOND_OPT_LACP_ACTIVE,
+	BOND_OPT_MISSED_MAX,
 	BOND_OPT_LAST
 };
 
diff --git a/include/net/bonding.h b/include/net/bonding.h
index 15e083e18f75..7b0bcddf9f26 100644
--- a/include/net/bonding.h
+++ b/include/net/bonding.h
@@ -124,6 +124,7 @@ struct bond_params {
 	int arp_interval;
 	int arp_validate;
 	int arp_all_targets;
+	unsigned int missed_max;
 	int use_carrier;
 	int fail_over_mac;
 	int updelay;
diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index eebd3894fe89..4ac53b30b6dc 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -858,6 +858,7 @@ enum {
 	IFLA_BOND_TLB_DYNAMIC_LB,
 	IFLA_BOND_PEER_NOTIF_DELAY,
 	IFLA_BOND_AD_LACP_ACTIVE,
+	IFLA_BOND_MISSED_MAX,
 	__IFLA_BOND_MAX,
 };
 
diff --git a/tools/include/uapi/linux/if_link.h b/tools/include/uapi/linux/if_link.h
index b3610fdd1fee..4772a115231a 100644
--- a/tools/include/uapi/linux/if_link.h
+++ b/tools/include/uapi/linux/if_link.h
@@ -655,6 +655,7 @@ enum {
 	IFLA_BOND_TLB_DYNAMIC_LB,
 	IFLA_BOND_PEER_NOTIF_DELAY,
 	IFLA_BOND_AD_LACP_ACTIVE,
+	IFLA_BOND_MISSED_MAX,
 	__IFLA_BOND_MAX,
 };
 
-- 
2.31.1

