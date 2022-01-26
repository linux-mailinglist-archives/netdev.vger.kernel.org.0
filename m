Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4023C49C490
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 08:36:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237921AbiAZHgD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 02:36:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237970AbiAZHf7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 02:35:59 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46037C06161C
        for <netdev@vger.kernel.org>; Tue, 25 Jan 2022 23:35:54 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id d15-20020a17090a110f00b001b4e7d27474so5383399pja.2
        for <netdev@vger.kernel.org>; Tue, 25 Jan 2022 23:35:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mWaV20DUDOVQN+IUpPDg3/HfLAFtrIAwFTs6RLw8asU=;
        b=UtmygOSpGi0px5SKnNSyiGqZN68tGMNuriURigMpc/k7/dnw1OO33GMRQMxmdw5FxV
         pSVEpH4aZkMz1YXD8tUE7edI09kLpBVtARyetWVbAUoACHkHGCkkXktcrUBGdNkcUqFQ
         Bv/xo+tRVm6hLZ75Z8VkL0sF1LyOZI3S3qP504XTXmxIS+lK/cdBijGTxOzexiZq+UTZ
         Nt0xE1RH1XoOTo+dxt0p2qEsCiezloqeXGm2Yu/94VkayIn1j5H2rKeXZmeZ95F85ObZ
         NJ4O0XjZeJZXOE5Vm1/A7SV1qj5zAwcIJtRKPtABidEERoKgoSsRAFAFGTJeauLAMsh/
         d/bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mWaV20DUDOVQN+IUpPDg3/HfLAFtrIAwFTs6RLw8asU=;
        b=u4TYyz5MOWlZpjP6TK8CXiC8xZ/qifL5bZRRK39e1tnXt+v6n5UXskq0wANL/47VmG
         N8HeBAHKq+STmd2RhLrMjOAd87/jyfpFFgaMm+dCAbmcOdv+VfOPNzhXDlMjgD0zG/JA
         007TbGVFTNrfVgFiNfFltx2uiriw7ndTw1iwrinW6qDXybcWj0E51abKGc9dsl5YOHfE
         cmGU+6tlold0Rr+rs8ibKYmSsHxE52cwpg9ZLUSFo9wVx9DzYVHoJf8SbV01tEFiG6/c
         c/ZaJ0ImxjYWalraTkjOHgJ4k5N30IKQW5umv3m7NfQDMGlZH9/gicdOqQ16Q9JguI5N
         Gzrg==
X-Gm-Message-State: AOAM531HXtA3FgIa6hXwLBN9ErMXdP3c0Jq3boVuVLbpsBK+X2yMC1WR
        xBrqmfxxvoO1jn4JrOn7tQ82a7ywWc0=
X-Google-Smtp-Source: ABdhPJyhrv7+zHpXvh8n8bpjVo+zjQ8WJOFPH0pK/y8b9/4U8AWG5nbf7BEBHRqfYNhec2jP8EzRuA==
X-Received: by 2002:a17:903:228c:b0:14a:fe2b:aeba with SMTP id b12-20020a170903228c00b0014afe2baebamr21885172plh.127.1643182553453;
        Tue, 25 Jan 2022 23:35:53 -0800 (PST)
Received: from Laptop-X1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id p12sm2240819pjj.55.2022.01.25.23.35.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Jan 2022 23:35:52 -0800 (PST)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        David Ahern <dsahern@gmail.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH RFC net-next 5/5] bonding: add new option ns_ip6_target
Date:   Wed, 26 Jan 2022 15:35:21 +0800
Message-Id: <20220126073521.1313870-6-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220126073521.1313870-1-liuhangbin@gmail.com>
References: <20220126073521.1313870-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch add a new bonding option ns_ip6_target, which correspond
to the arp_ip_target. With this we set IPv6 targets and send IPv6 NS
request to determine the health of the link.

For other related options like the validation, we still use
arp_validate, and will change to ns_validate later.

Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 Documentation/networking/bonding.rst |  11 +++
 drivers/net/bonding/bond_netlink.c   |  55 +++++++++++
 drivers/net/bonding/bond_options.c   | 137 +++++++++++++++++++++++++++
 drivers/net/bonding/bond_sysfs.c     |  22 +++++
 include/net/bond_options.h           |   2 +
 include/net/bonding.h                |   7 ++
 include/uapi/linux/if_link.h         |   1 +
 tools/include/uapi/linux/if_link.h   |   1 +
 8 files changed, 236 insertions(+)

diff --git a/Documentation/networking/bonding.rst b/Documentation/networking/bonding.rst
index ab98373535ea..525e6842dd33 100644
--- a/Documentation/networking/bonding.rst
+++ b/Documentation/networking/bonding.rst
@@ -313,6 +313,17 @@ arp_ip_target
 	maximum number of targets that can be specified is 16.  The
 	default value is no IP addresses.
 
+ns_ip6_target
+
+	Specifies the IPv6 addresses to use as IPv6 monitoring peers when
+	arp_interval is > 0.  These are the targets of the NS request
+	sent to determine the health of the link to the targets.
+	Specify these values in ffff:ffff::ffff:ffff format.  Multiple IPv6
+	addresses must be separated by a comma.  At least one IPv6
+	address must be given for NS/NA monitoring to function.  The
+	maximum number of targets that can be specified is 16.  The
+	default value is no IPv6 addresses.
+
 arp_validate
 
 	Specifies whether or not ARP probes and replies should be
diff --git a/drivers/net/bonding/bond_netlink.c b/drivers/net/bonding/bond_netlink.c
index 1007bf6d385d..f35ca197069f 100644
--- a/drivers/net/bonding/bond_netlink.c
+++ b/drivers/net/bonding/bond_netlink.c
@@ -14,6 +14,7 @@
 #include <net/netlink.h>
 #include <net/rtnetlink.h>
 #include <net/bonding.h>
+#include <net/ipv6.h>
 
 static size_t bond_get_slave_size(const struct net_device *bond_dev,
 				  const struct net_device *slave_dev)
@@ -111,6 +112,7 @@ static const struct nla_policy bond_policy[IFLA_BOND_MAX + 1] = {
 	[IFLA_BOND_TLB_DYNAMIC_LB]	= { .type = NLA_U8 },
 	[IFLA_BOND_PEER_NOTIF_DELAY]    = { .type = NLA_U32 },
 	[IFLA_BOND_MISSED_MAX]		= { .type = NLA_U8 },
+	[IFLA_BOND_NS_IP6_TARGET]	= { .type = NLA_NESTED },
 };
 
 static const struct nla_policy bond_slave_policy[IFLA_BOND_SLAVE_MAX + 1] = {
@@ -272,6 +274,38 @@ static int bond_changelink(struct net_device *bond_dev, struct nlattr *tb[],
 		if (err)
 			return err;
 	}
+	if (data[IFLA_BOND_NS_IP6_TARGET]) {
+		struct nlattr *attr;
+		int i = 0, rem;
+
+		bond_option_ns_ip6_targets_clear(bond);
+		nla_for_each_nested(attr, data[IFLA_BOND_NS_IP6_TARGET], rem) {
+			struct in6_addr target;
+
+			if (nla_len(attr) < sizeof(target)) {
+				NL_SET_ERR_MSG(extack, "Invalid IPv6 address");
+				return -EINVAL;
+			}
+
+			target = nla_get_in6_addr(attr);
+
+			if (ipv6_addr_type(&target) & IPV6_ADDR_LINKLOCAL) {
+				NL_SET_ERR_MSG(extack, "Invalid IPv6 target");
+				return -EINVAL;
+			}
+
+			bond_opt_initaddr(&newval, &target);
+			err = __bond_opt_set(bond, BOND_OPT_NS_TARGETS,
+					     &newval);
+			if (err)
+				break;
+			i++;
+		}
+		if (i == 0 && bond->params.arp_interval)
+			netdev_warn(bond->dev, "Removing last ns target with arp_interval on\n");
+		if (err)
+			return err;
+	}
 	if (data[IFLA_BOND_ARP_VALIDATE]) {
 		int arp_validate = nla_get_u32(data[IFLA_BOND_ARP_VALIDATE]);
 
@@ -526,6 +560,9 @@ static size_t bond_get_size(const struct net_device *bond_dev)
 		nla_total_size(sizeof(u8)) + /* IFLA_BOND_TLB_DYNAMIC_LB */
 		nla_total_size(sizeof(u32)) +	/* IFLA_BOND_PEER_NOTIF_DELAY */
 		nla_total_size(sizeof(u8)) +	/* IFLA_BOND_MISSED_MAX */
+						/* IFLA_BOND_NS_IP6_TARGET */
+		nla_total_size(sizeof(struct nlattr)) +
+		nla_total_size(sizeof(struct in6_addr)) * BOND_MAX_ARP_TARGETS +
 		0;
 }
 
@@ -603,6 +640,24 @@ static int bond_fill_info(struct sk_buff *skb,
 			bond->params.arp_all_targets))
 		goto nla_put_failure;
 
+	targets = nla_nest_start(skb, IFLA_BOND_NS_IP6_TARGET);
+	if (!targets)
+		goto nla_put_failure;
+
+	targets_added = 0;
+	for (i = 0; i < BOND_MAX_ARP_TARGETS; i++) {
+		if (!ipv6_addr_any(&bond->params.ns_targets[i])) {
+			if (nla_put_in6_addr(skb, i, &bond->params.ns_targets[i]))
+				goto nla_put_failure;
+			targets_added = 1;
+		}
+	}
+
+	if (targets_added)
+		nla_nest_end(skb, targets);
+	else
+		nla_nest_cancel(skb, targets);
+
 	primary = rtnl_dereference(bond->primary_slave);
 	if (primary &&
 	    nla_put_u32(skb, IFLA_BOND_PRIMARY, primary->dev->ifindex))
diff --git a/drivers/net/bonding/bond_options.c b/drivers/net/bonding/bond_options.c
index bf48aea770a7..8066f958e583 100644
--- a/drivers/net/bonding/bond_options.c
+++ b/drivers/net/bonding/bond_options.c
@@ -34,6 +34,12 @@ static int bond_option_arp_ip_target_add(struct bonding *bond, __be32 target);
 static int bond_option_arp_ip_target_rem(struct bonding *bond, __be32 target);
 static int bond_option_arp_ip_targets_set(struct bonding *bond,
 					  const struct bond_opt_value *newval);
+static int bond_option_ns_ip6_target_add(struct bonding *bond,
+					 struct in6_addr *target);
+static int bond_option_ns_ip6_target_rem(struct bonding *bond,
+					 struct in6_addr *target);
+static int bond_option_ns_ip6_targets_set(struct bonding *bond,
+					  const struct bond_opt_value *newval);
 static int bond_option_arp_validate_set(struct bonding *bond,
 					const struct bond_opt_value *newval);
 static int bond_option_arp_all_targets_set(struct bonding *bond,
@@ -295,6 +301,13 @@ static const struct bond_option bond_opts[BOND_OPT_LAST] = {
 		.flags = BOND_OPTFLAG_RAWVAL,
 		.set = bond_option_arp_ip_targets_set
 	},
+	[BOND_OPT_NS_TARGETS] = {
+		.id = BOND_OPT_NS_TARGETS,
+		.name = "ns_ip6_target",
+		.desc = "NS targets in ffff:ffff::ffff:ffff form",
+		.flags = BOND_OPTFLAG_RAWVAL,
+		.set = bond_option_ns_ip6_targets_set
+	},
 	[BOND_OPT_DOWNDELAY] = {
 		.id = BOND_OPT_DOWNDELAY,
 		.name = "downdelay",
@@ -1187,6 +1200,130 @@ static int bond_option_arp_ip_targets_set(struct bonding *bond,
 	return ret;
 }
 
+static void _bond_options_ns_ip6_target_set(struct bonding *bond, int slot,
+					    struct in6_addr *target,
+					    unsigned long last_rx)
+{
+	struct in6_addr *targets = bond->params.ns_targets;
+	struct list_head *iter;
+	struct slave *slave;
+
+	if (slot >= 0 && slot < BOND_MAX_ARP_TARGETS) {
+		bond_for_each_slave(bond, slave, iter)
+			slave->target_last_arp_rx[slot] = last_rx;
+		targets[slot] = *target;
+	}
+
+	/* Use IPv6 NS/NA monitor if NS target set */
+	if (bond_do_ns_validate(bond))
+		bond->recv_probe = bond_na_rcv;
+}
+
+void bond_option_ns_ip6_targets_clear(struct bonding *bond)
+{
+	struct in6_addr addr_any = in6addr_any;
+	int i;
+
+	for (i = 0; i < BOND_MAX_ARP_TARGETS; i++)
+		_bond_options_ns_ip6_target_set(bond, i, &addr_any, 0);
+}
+
+static int bond_option_ns_ip6_target_add(struct bonding *bond, struct in6_addr *target)
+{
+	struct in6_addr *targets = bond->params.ns_targets;
+	struct in6_addr addr_any = in6addr_any;
+	int index;
+
+	if (!bond_is_ip6_target_ok(target)) {
+		netdev_err(bond->dev, "invalid NS target %pI6 specified for addition\n",
+			   target);
+		return -EINVAL;
+	}
+
+	if (bond_get_targets_ip6(targets, target) != -1) { /* dup */
+		netdev_err(bond->dev, "NS target %pI6 is already present\n",
+			   &target);
+		return -EINVAL;
+	}
+
+	index = bond_get_targets_ip6(targets, &addr_any); /* first free slot */
+	if (index == -1) {
+		netdev_err(bond->dev, "NS target table is full!\n");
+		return -EINVAL;
+	}
+
+	netdev_dbg(bond->dev, "Adding NS target %pI6\n", &target);
+
+	_bond_options_ns_ip6_target_set(bond, index, target, jiffies);
+
+	return 0;
+}
+
+static int bond_option_ns_ip6_target_rem(struct bonding *bond, struct in6_addr *target)
+{
+	struct in6_addr *targets = bond->params.ns_targets;
+	struct list_head *iter;
+	struct slave *slave;
+	unsigned long *targets_rx;
+	int index, i;
+
+	if (!bond_is_ip6_target_ok(target)) {
+		netdev_err(bond->dev, "invalid NS target %pI6 specified for removal\n",
+			   target);
+		return -EINVAL;
+	}
+
+	index = bond_get_targets_ip6(targets, target);
+	if (index == -1) {
+		netdev_err(bond->dev, "unable to remove nonexistent NS target %pI6\n",
+			   target);
+		return -EINVAL;
+	}
+
+	if (index == 0 && ipv6_addr_any(&targets[1]) && bond->params.arp_interval)
+		netdev_warn(bond->dev, "Removing last NS target with arp_interval on\n");
+
+	netdev_dbg(bond->dev, "Removing NS target %pI6\n", target);
+
+	bond_for_each_slave(bond, slave, iter) {
+		targets_rx = slave->target_last_arp_rx;
+		for (i = index; (i < BOND_MAX_ARP_TARGETS-1) && !ipv6_addr_any(&targets[i+1]); i++)
+			targets_rx[i] = targets_rx[i+1];
+		targets_rx[i] = 0;
+	}
+	for (i = index; (i < BOND_MAX_ARP_TARGETS-1) && !ipv6_addr_any(&targets[i+1]); i++)
+		targets[i] = targets[i+1];
+	memset(&targets[i], 0, sizeof(struct in6_addr));
+
+	return 0;
+}
+
+static int bond_option_ns_ip6_targets_set(struct bonding *bond,
+					  const struct bond_opt_value *newval)
+{
+	int ret = -EPERM;
+	struct in6_addr target;
+
+	if (newval->string) {
+		if (!in6_pton(newval->string+1, -1, (u8 *)&target.s6_addr, -1, NULL)) {
+			netdev_err(bond->dev, "invalid NS target %pI6 specified\n",
+				   &target);
+			return ret;
+		}
+		if (newval->string[0] == '+')
+			ret = bond_option_ns_ip6_target_add(bond, &target);
+		else if (newval->string[0] == '-')
+			ret = bond_option_ns_ip6_target_rem(bond, &target);
+		else
+			netdev_err(bond->dev, "no command found in ns_ip6_targets file - use +<addr> or -<addr>\n");
+	} else {
+		target = newval->ip6_addr;
+		ret = bond_option_ns_ip6_target_add(bond, &target);
+	}
+
+	return ret;
+}
+
 static int bond_option_arp_validate_set(struct bonding *bond,
 					const struct bond_opt_value *newval)
 {
diff --git a/drivers/net/bonding/bond_sysfs.c b/drivers/net/bonding/bond_sysfs.c
index 9b5a5df23d21..c61d95161782 100644
--- a/drivers/net/bonding/bond_sysfs.c
+++ b/drivers/net/bonding/bond_sysfs.c
@@ -25,6 +25,7 @@
 #include <linux/nsproxy.h>
 
 #include <net/bonding.h>
+#include <net/ipv6.h>
 
 #define to_bond(cd)	((struct bonding *)(netdev_priv(to_net_dev(cd))))
 
@@ -315,6 +316,26 @@ static ssize_t bonding_show_missed_max(struct device *d,
 static DEVICE_ATTR(arp_missed_max, 0644,
 		   bonding_show_missed_max, bonding_sysfs_store_option);
 
+static ssize_t bonding_show_ns_targets(struct device *d,
+				       struct device_attribute *attr,
+				       char *buf)
+{
+	struct bonding *bond = to_bond(d);
+	int i, res = 0;
+
+	for (i = 0; i < BOND_MAX_ARP_TARGETS; i++) {
+		if (!ipv6_addr_any(&bond->params.ns_targets[i]))
+			res += sprintf(buf + res, "%pI6 ",
+				       &bond->params.ns_targets[i]);
+	}
+	if (res)
+		buf[res-1] = '\n'; /* eat the leftover space */
+
+	return res;
+}
+static DEVICE_ATTR(ns_ip6_target, 0644,
+		   bonding_show_ns_targets, bonding_sysfs_store_option);
+
 /* Show the up and down delays. */
 static ssize_t bonding_show_downdelay(struct device *d,
 				      struct device_attribute *attr,
@@ -761,6 +782,7 @@ static struct attribute *per_bond_attrs[] = {
 	&dev_attr_arp_all_targets.attr,
 	&dev_attr_arp_interval.attr,
 	&dev_attr_arp_ip_target.attr,
+	&dev_attr_ns_ip6_target.attr,
 	&dev_attr_downdelay.attr,
 	&dev_attr_updelay.attr,
 	&dev_attr_peer_notif_delay.attr,
diff --git a/include/net/bond_options.h b/include/net/bond_options.h
index a9e68e88ff73..689cea946dbf 100644
--- a/include/net/bond_options.h
+++ b/include/net/bond_options.h
@@ -66,6 +66,7 @@ enum {
 	BOND_OPT_PEER_NOTIF_DELAY,
 	BOND_OPT_LACP_ACTIVE,
 	BOND_OPT_MISSED_MAX,
+	BOND_OPT_NS_TARGETS,
 	BOND_OPT_LAST
 };
 
@@ -135,5 +136,6 @@ static inline void __bond_opt_init(struct bond_opt_value *optval,
 #define bond_opt_initaddr(optval, addr) __bond_opt_init(optval, NULL, ULLONG_MAX, addr)
 
 void bond_option_arp_ip_targets_clear(struct bonding *bond);
+void bond_option_ns_ip6_targets_clear(struct bonding *bond);
 
 #endif /* _NET_BOND_OPTIONS_H */
diff --git a/include/net/bonding.h b/include/net/bonding.h
index 15a7659bbd1c..de1a38d1c531 100644
--- a/include/net/bonding.h
+++ b/include/net/bonding.h
@@ -502,6 +502,13 @@ static inline int bond_is_ip_target_ok(__be32 addr)
 	return !ipv4_is_lbcast(addr) && !ipv4_is_zeronet(addr);
 }
 
+static inline int bond_is_ip6_target_ok(struct in6_addr *addr)
+{
+	return !ipv6_addr_any(addr) &&
+	       !ipv6_addr_loopback(addr) &&
+	       !ipv6_addr_is_multicast(addr);
+}
+
 /* Get the oldest arp which we've received on this slave for bond's
  * arp_targets.
  */
diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index 6218f93f5c1a..e1ba2d51b717 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -860,6 +860,7 @@ enum {
 	IFLA_BOND_PEER_NOTIF_DELAY,
 	IFLA_BOND_AD_LACP_ACTIVE,
 	IFLA_BOND_MISSED_MAX,
+	IFLA_BOND_NS_IP6_TARGET,
 	__IFLA_BOND_MAX,
 };
 
diff --git a/tools/include/uapi/linux/if_link.h b/tools/include/uapi/linux/if_link.h
index 6218f93f5c1a..e1ba2d51b717 100644
--- a/tools/include/uapi/linux/if_link.h
+++ b/tools/include/uapi/linux/if_link.h
@@ -860,6 +860,7 @@ enum {
 	IFLA_BOND_PEER_NOTIF_DELAY,
 	IFLA_BOND_AD_LACP_ACTIVE,
 	IFLA_BOND_MISSED_MAX,
+	IFLA_BOND_NS_IP6_TARGET,
 	__IFLA_BOND_MAX,
 };
 
-- 
2.31.1

