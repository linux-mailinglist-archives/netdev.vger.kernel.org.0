Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D398452D20
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 09:49:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232482AbhKPIwB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 03:52:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232450AbhKPIvy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Nov 2021 03:51:54 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86C60C061570
        for <netdev@vger.kernel.org>; Tue, 16 Nov 2021 00:48:57 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id x7so15122688pjn.0
        for <netdev@vger.kernel.org>; Tue, 16 Nov 2021 00:48:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Z2cbBTgCDiQBJz0Ju9WlyMdDY/ceQNpb0iehPXT5Cjw=;
        b=GHgqGtzynTydLXbFSGmxBfdxaCItdortb6VDT2ou6f8vZ9D60DppI/BXPgTlZJrfcV
         X3vLjEXE/yPWxrVMoAJF2jZ/WRSE+uM9JkqGDK4zk8Vq3EiZU72sdK6KoumiyBoljdBa
         LNz6WpLabX+nVuv8/3reKZ28+e8lpz7Tdf6ZfKeRLBGZ6ftcm9RGYbWVVtyVVecrG2MS
         oc7w++wX4gSCdXx0Kob2KBwMHDwfqbp7eThYF754ZDE0sxoUVFreL9A9czFKYhPjMAGB
         mRP9frtRJ5Cqg+nZaO0o3nAi22gS3heaX2R8GeZM/XpvrwSh7rm87pwlXxLEjhldHvdE
         L7Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Z2cbBTgCDiQBJz0Ju9WlyMdDY/ceQNpb0iehPXT5Cjw=;
        b=DY9zyMufdYvy/bSNh8EFAvJHIqG195Pf45WYKOSRqgqRUZeTNeW5SQOIBx7rFtDqmR
         s9JBryyawl6FvSJDfi6BdFyJR6TOJgckg24DNvdOcsMUlXAh7GWQHDrWp+p6bDvXIZOj
         fluBafYTxYzHJ5iLIFjF1C3lsaIeKZ3tlhpzaiJ3oER/bUovxxRY/x4WAe24T5tWmRjo
         x1vvkhvomfmkWi8ZEm8eXnaUvkS5egIB7NvbiUBaE2S+keBEb8ogbHz/u1YVWqS9RM2Z
         K0JjyhGWBQwwDX9pQftJ35Om/YJqCTQIEhzt50Jtqepe9BMbXv3FvoNOHjaSBvAYQnGJ
         w9Kg==
X-Gm-Message-State: AOAM530sjAbabaijjqJDcsz89NUAMCQ/X6eTnluAtVb0Lyf3CKlnPC6N
        CcjSDxTv/Zmv/RaxDT1kHzdv019hGyU=
X-Google-Smtp-Source: ABdhPJwtg8GNVSYUmLOL9qfP8iiJ474KvhSQ7bTZOtmFfchU7ZDFf8FVXGISYACl1nufnx5qHC+fHg==
X-Received: by 2002:a17:902:e74e:b0:142:fa5:49f1 with SMTP id p14-20020a170902e74e00b001420fa549f1mr42588771plf.84.1637052536690;
        Tue, 16 Nov 2021 00:48:56 -0800 (PST)
Received: from Laptop-X1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id r6sm1731443pjg.21.2021.11.16.00.48.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Nov 2021 00:48:56 -0800 (PST)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Jarod Wilson <jarod@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S . Miller" <davem@davemloft.net>,
        Denis Kirjanov <dkirjanov@suse.de>,
        David Ahern <dsahern@gmail.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH net-next] Bonding: add missed_max option
Date:   Tue, 16 Nov 2021 16:48:40 +0800
Message-Id: <20211116084840.978383-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, we use hard code number to verify if we are in the
arp_interval timeslice. But some user may want to reduce/extend
the verify timeslice. With the similar team option 'missed_max'
the uers could change that number based on their own environment.

The name of arp_misssed_max is not used as we may use this option for
Bonding IPv6 NS/NA monitor in future.

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
index 31cfd7d674a6..4a28b350bb02 100644
--- a/Documentation/networking/bonding.rst
+++ b/Documentation/networking/bonding.rst
@@ -421,6 +421,16 @@ arp_all_targets
 		consider the slave up only when all of the arp_ip_targets
 		are reachable
 
+missed_max
+
+        Maximum number of arp_interval monitor cycle for missed ARP replies.
+        If this number is exceeded, link is reported as down.
+
+        Normally 2 monitor cycles are needed. One cycle for missed ARP request
+        and one cycle for waiting ARP reply.
+
+        default 2
+
 downdelay
 
 	Specifies the time, in milliseconds, to wait before disabling
diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index ff8da720a33a..9a28d3de798e 100644
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
+		 * - more than (missed_max+1)*delta since last receive AND
 		 * - the bond has an IP address
 		 *
 		 * Note: a non-null current_arp_slave indicates
@@ -3236,20 +3236,20 @@ static int bond_ab_arp_inspect(struct bonding *bond)
 		 */
 		if (!bond_is_active_slave(slave) &&
 		    !rcu_access_pointer(bond->current_arp_slave) &&
-		    !bond_time_in_interval(bond, last_rx, 3)) {
+		    !bond_time_in_interval(bond, last_rx, bond->params.missed_max+1)) {
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
+	params->missed_max = 2;
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

