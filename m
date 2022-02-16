Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3973D4B82A2
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 09:12:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231434AbiBPIJd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 03:09:33 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:48394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231431AbiBPIJb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 03:09:31 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19DD724466A
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 00:09:15 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id x4so1426966plb.4
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 00:09:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=D1u9wSuvQNo+KcKCVmOem/HdE9mNaPTo/yK5XGQ7ntw=;
        b=BzA/9AS2Noho3AnO3fubeizcJLQlXOMgQxcpnz8617xMyZ5NS/ZMeB3Gv8LKMiGuOY
         6yf9wpqE1jvcvnMLSNxWWFelGFW5mH0VJNz85XaVBJUxMPM7m0DxeQwKFhPGW+t56ZjC
         Ekc+eLeLXinPEEz4jQi2oHfgo7QhAy44MQDozyWQnTC5th6SJumue55yr2LUyHT936E2
         ab27Pvbemj/ajz4XnQgZtRl5X4fms/2qYAaKgtI2h/7hgh8lPcrw/ESl7poh4mcUwH67
         2dVeGneZfdAXED8Rqy3gLUYkx6eXXn4ooDyIsM8HVdhURmmMoUVmTCmjbufCZK8lMcnd
         N0Gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=D1u9wSuvQNo+KcKCVmOem/HdE9mNaPTo/yK5XGQ7ntw=;
        b=eV6fi7+7TnkS4cZEswydnbUA1qVJa7g31IHotHBg+4JZeWfal6+loCh+Lp0yw3CSb1
         Dls783ETLZrK3QGVlQsc0aljtrSEr1bRjokbEVQeADuBp7widUpOYluom5xvrkzbetVo
         RQPoprVvFpiCn4YLk4ekH5tbkRaWh4oewCew+RtMhOHZyGHqj6aE3jBEQCkrrwpcZm4Q
         dwQ8hU1TDS8arXe8wTw22D2TtYcA3pfjSOcV/lMNdLmvqbouWPc7QECy0Qp7OZjcXBoF
         gq7LvcnUGM9KGaw2I6HtlW6a++03OzwgiFzGHLPkr+Xw99A0jK5PFIPPeyRH4kvQRBBx
         KSWg==
X-Gm-Message-State: AOAM531oOrU4uaKifiQLENSKVm7+zfpn1hK+mOeHBQpadDrxNlv7b0Q+
        Cc7LNEvAQYqmmyuGehTyGbAmfzxlxt8=
X-Google-Smtp-Source: ABdhPJwcJRtuPHc7iqf6nYM/74ZuAvYdfNiCA5twshcA0wwt1Y233AtcICQqE1obT+qNWDiCqxmDxw==
X-Received: by 2002:a17:902:f785:b0:14d:d2b6:b7c with SMTP id q5-20020a170902f78500b0014dd2b60b7cmr1452157pln.68.1644998954909;
        Wed, 16 Feb 2022 00:09:14 -0800 (PST)
Received: from Laptop-X1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id s15sm4635662pgn.30.2022.02.16.00.09.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Feb 2022 00:09:14 -0800 (PST)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        David Ahern <dsahern@gmail.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jonathan Toppins <jtoppins@redhat.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH net-next 5/5] bonding: add new option ns_ip6_target
Date:   Wed, 16 Feb 2022 16:08:38 +0800
Message-Id: <20220216080838.158054-6-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220216080838.158054-1-liuhangbin@gmail.com>
References: <20220216080838.158054-1-liuhangbin@gmail.com>
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

This patch add a new bonding option ns_ip6_target, which correspond
to the arp_ip_target. With this we set IPv6 targets and send IPv6 NS
request to determine the health of the link.

For other related options like the validation, we still use
arp_validate, and will change to ns_validate later.

Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 Documentation/networking/bonding.rst |  11 +++
 drivers/net/bonding/bond_netlink.c   |  59 ++++++++++++
 drivers/net/bonding/bond_options.c   | 138 +++++++++++++++++++++++++++
 drivers/net/bonding/bond_sysfs.c     |  26 +++++
 include/net/bond_options.h           |   4 +
 include/net/bonding.h                |   7 ++
 include/uapi/linux/if_link.h         |   1 +
 tools/include/uapi/linux/if_link.h   |   1 +
 8 files changed, 247 insertions(+)

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
index 1007bf6d385d..f427fa1737c7 100644
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
@@ -272,6 +274,40 @@ static int bond_changelink(struct net_device *bond_dev, struct nlattr *tb[],
 		if (err)
 			return err;
 	}
+#if IS_ENABLED(CONFIG_IPV6)
+	if (data[IFLA_BOND_NS_IP6_TARGET]) {
+		struct nlattr *attr;
+		int i = 0, rem;
+
+		bond_option_ns_ip6_targets_clear(bond);
+		nla_for_each_nested(attr, data[IFLA_BOND_NS_IP6_TARGET], rem) {
+			struct in6_addr addr6;
+
+			if (nla_len(attr) < sizeof(addr6)) {
+				NL_SET_ERR_MSG(extack, "Invalid IPv6 address");
+				return -EINVAL;
+			}
+
+			addr6 = nla_get_in6_addr(attr);
+
+			if (ipv6_addr_type(&addr6) & IPV6_ADDR_LINKLOCAL) {
+				NL_SET_ERR_MSG(extack, "Invalid IPv6 addr6");
+				return -EINVAL;
+			}
+
+			bond_opt_initextra(&newval, &addr6, sizeof(addr6));
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
+#endif
 	if (data[IFLA_BOND_ARP_VALIDATE]) {
 		int arp_validate = nla_get_u32(data[IFLA_BOND_ARP_VALIDATE]);
 
@@ -526,6 +562,9 @@ static size_t bond_get_size(const struct net_device *bond_dev)
 		nla_total_size(sizeof(u8)) + /* IFLA_BOND_TLB_DYNAMIC_LB */
 		nla_total_size(sizeof(u32)) +	/* IFLA_BOND_PEER_NOTIF_DELAY */
 		nla_total_size(sizeof(u8)) +	/* IFLA_BOND_MISSED_MAX */
+						/* IFLA_BOND_NS_IP6_TARGET */
+		nla_total_size(sizeof(struct nlattr)) +
+		nla_total_size(sizeof(struct in6_addr)) * BOND_MAX_NS_TARGETS +
 		0;
 }
 
@@ -603,6 +642,26 @@ static int bond_fill_info(struct sk_buff *skb,
 			bond->params.arp_all_targets))
 		goto nla_put_failure;
 
+#if IS_ENABLED(CONFIG_IPV6)
+	targets = nla_nest_start(skb, IFLA_BOND_NS_IP6_TARGET);
+	if (!targets)
+		goto nla_put_failure;
+
+	targets_added = 0;
+	for (i = 0; i < BOND_MAX_NS_TARGETS; i++) {
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
+#endif
+
 	primary = rtnl_dereference(bond->primary_slave);
 	if (primary &&
 	    nla_put_u32(skb, IFLA_BOND_PRIMARY, primary->dev->ifindex))
diff --git a/drivers/net/bonding/bond_options.c b/drivers/net/bonding/bond_options.c
index ab575135b626..366ed0e2a2c6 100644
--- a/drivers/net/bonding/bond_options.c
+++ b/drivers/net/bonding/bond_options.c
@@ -34,6 +34,14 @@ static int bond_option_arp_ip_target_add(struct bonding *bond, __be32 target);
 static int bond_option_arp_ip_target_rem(struct bonding *bond, __be32 target);
 static int bond_option_arp_ip_targets_set(struct bonding *bond,
 					  const struct bond_opt_value *newval);
+#if IS_ENABLED(CONFIG_IPV6)
+static int bond_option_ns_ip6_target_add(struct bonding *bond,
+					 struct in6_addr *target);
+static int bond_option_ns_ip6_target_rem(struct bonding *bond,
+					 struct in6_addr *target);
+static int bond_option_ns_ip6_targets_set(struct bonding *bond,
+					  const struct bond_opt_value *newval);
+#endif
 static int bond_option_arp_validate_set(struct bonding *bond,
 					const struct bond_opt_value *newval);
 static int bond_option_arp_all_targets_set(struct bonding *bond,
@@ -295,6 +303,15 @@ static const struct bond_option bond_opts[BOND_OPT_LAST] = {
 		.flags = BOND_OPTFLAG_RAWVAL,
 		.set = bond_option_arp_ip_targets_set
 	},
+#if IS_ENABLED(CONFIG_IPV6)
+	[BOND_OPT_NS_TARGETS] = {
+		.id = BOND_OPT_NS_TARGETS,
+		.name = "ns_ip6_target",
+		.desc = "NS targets in ffff:ffff::ffff:ffff form",
+		.flags = BOND_OPTFLAG_RAWVAL,
+		.set = bond_option_ns_ip6_targets_set
+	},
+#endif
 	[BOND_OPT_DOWNDELAY] = {
 		.id = BOND_OPT_DOWNDELAY,
 		.name = "downdelay",
@@ -1184,6 +1201,127 @@ static int bond_option_arp_ip_targets_set(struct bonding *bond,
 	return ret;
 }
 
+#if IS_ENABLED(CONFIG_IPV6)
+static void _bond_options_ns_ip6_target_set(struct bonding *bond, int slot,
+					    struct in6_addr *target,
+					    unsigned long last_rx)
+{
+	struct in6_addr *targets = bond->params.ns_targets;
+	struct list_head *iter;
+	struct slave *slave;
+
+	if (slot >= 0 && slot < BOND_MAX_NS_TARGETS) {
+		bond_for_each_slave(bond, slave, iter)
+			slave->target_last_arp_rx[slot] = last_rx;
+		targets[slot] = *target;
+	}
+}
+
+void bond_option_ns_ip6_targets_clear(struct bonding *bond)
+{
+	struct in6_addr addr_any = in6addr_any;
+	int i;
+
+	for (i = 0; i < BOND_MAX_NS_TARGETS; i++)
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
+		netdev_err(bond->dev, "invalid NS target %pI6c specified for addition\n",
+			   target);
+		return -EINVAL;
+	}
+
+	if (bond_get_targets_ip6(targets, target) != -1) { /* dup */
+		netdev_err(bond->dev, "NS target %pI6c is already present\n",
+			   target);
+		return -EINVAL;
+	}
+
+	index = bond_get_targets_ip6(targets, &addr_any); /* first free slot */
+	if (index == -1) {
+		netdev_err(bond->dev, "NS target table is full!\n");
+		return -EINVAL;
+	}
+
+	netdev_dbg(bond->dev, "Adding NS target %pI6c\n", target);
+
+	_bond_options_ns_ip6_target_set(bond, index, target, jiffies);
+
+	return 0;
+}
+
+static int bond_option_ns_ip6_target_rem(struct bonding *bond, struct in6_addr *target)
+{
+	struct in6_addr *targets = bond->params.ns_targets;
+	unsigned long *targets_rx;
+	struct list_head *iter;
+	struct slave *slave;
+	int index, i;
+
+	if (!bond_is_ip6_target_ok(target)) {
+		netdev_err(bond->dev, "invalid NS target %pI6c specified for removal\n",
+			   target);
+		return -EINVAL;
+	}
+
+	index = bond_get_targets_ip6(targets, target);
+	if (index == -1) {
+		netdev_err(bond->dev, "unable to remove nonexistent NS target %pI6c\n",
+			   target);
+		return -EINVAL;
+	}
+
+	if (index == 0 && ipv6_addr_any(&targets[1]) && bond->params.arp_interval)
+		netdev_warn(bond->dev, "Removing last NS target with arp_interval on\n");
+
+	netdev_dbg(bond->dev, "Removing NS target %pI6c\n", target);
+
+	bond_for_each_slave(bond, slave, iter) {
+		targets_rx = slave->target_last_arp_rx;
+		for (i = index; (i < BOND_MAX_NS_TARGETS-1) && !ipv6_addr_any(&targets[i+1]); i++)
+			targets_rx[i] = targets_rx[i+1];
+		targets_rx[i] = 0;
+	}
+	for (i = index; (i < BOND_MAX_NS_TARGETS-1) && !ipv6_addr_any(&targets[i+1]); i++)
+		targets[i] = targets[i+1];
+	memset(&targets[i], 0, sizeof(struct in6_addr));
+
+	return 0;
+}
+
+static int bond_option_ns_ip6_targets_set(struct bonding *bond,
+					  const struct bond_opt_value *newval)
+{
+	struct in6_addr target;
+	int ret = -EPERM;
+
+	if (newval->string) {
+		if (!in6_pton(newval->string+1, -1, (u8 *)&target.s6_addr, -1, NULL)) {
+			netdev_err(bond->dev, "invalid NS target %pI6c specified\n",
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
+		ret = bond_option_ns_ip6_target_add(bond, (struct in6_addr *)newval->extra);
+	}
+
+	return ret;
+}
+#endif
+
 static int bond_option_arp_validate_set(struct bonding *bond,
 					const struct bond_opt_value *newval)
 {
diff --git a/drivers/net/bonding/bond_sysfs.c b/drivers/net/bonding/bond_sysfs.c
index 9b5a5df23d21..e243b02024a5 100644
--- a/drivers/net/bonding/bond_sysfs.c
+++ b/drivers/net/bonding/bond_sysfs.c
@@ -25,6 +25,7 @@
 #include <linux/nsproxy.h>
 
 #include <net/bonding.h>
+#include <net/ipv6.h>
 
 #define to_bond(cd)	((struct bonding *)(netdev_priv(to_net_dev(cd))))
 
@@ -315,6 +316,28 @@ static ssize_t bonding_show_missed_max(struct device *d,
 static DEVICE_ATTR(arp_missed_max, 0644,
 		   bonding_show_missed_max, bonding_sysfs_store_option);
 
+#if IS_ENABLED(CONFIG_IPV6)
+static ssize_t bonding_show_ns_targets(struct device *d,
+				       struct device_attribute *attr,
+				       char *buf)
+{
+	struct bonding *bond = to_bond(d);
+	int i, res = 0;
+
+	for (i = 0; i < BOND_MAX_NS_TARGETS; i++) {
+		if (!ipv6_addr_any(&bond->params.ns_targets[i]))
+			res += sprintf(buf + res, "%pI6c ",
+				       &bond->params.ns_targets[i]);
+	}
+	if (res)
+		buf[res-1] = '\n'; /* eat the leftover space */
+
+	return res;
+}
+static DEVICE_ATTR(ns_ip6_target, 0644,
+		   bonding_show_ns_targets, bonding_sysfs_store_option);
+#endif
+
 /* Show the up and down delays. */
 static ssize_t bonding_show_downdelay(struct device *d,
 				      struct device_attribute *attr,
@@ -761,6 +784,9 @@ static struct attribute *per_bond_attrs[] = {
 	&dev_attr_arp_all_targets.attr,
 	&dev_attr_arp_interval.attr,
 	&dev_attr_arp_ip_target.attr,
+#if IS_ENABLED(CONFIG_IPV6)
+	&dev_attr_ns_ip6_target.attr,
+#endif
 	&dev_attr_downdelay.attr,
 	&dev_attr_updelay.attr,
 	&dev_attr_peer_notif_delay.attr,
diff --git a/include/net/bond_options.h b/include/net/bond_options.h
index 286b29c6c451..61b49063791c 100644
--- a/include/net/bond_options.h
+++ b/include/net/bond_options.h
@@ -66,6 +66,7 @@ enum {
 	BOND_OPT_PEER_NOTIF_DELAY,
 	BOND_OPT_LACP_ACTIVE,
 	BOND_OPT_MISSED_MAX,
+	BOND_OPT_NS_TARGETS,
 	BOND_OPT_LAST
 };
 
@@ -140,5 +141,8 @@ static inline void __bond_opt_init(struct bond_opt_value *optval,
 	__bond_opt_init(optval, NULL, ULLONG_MAX, extra, extra_len)
 
 void bond_option_arp_ip_targets_clear(struct bonding *bond);
+#if IS_ENABLED(CONFIG_IPV6)
+void bond_option_ns_ip6_targets_clear(struct bonding *bond);
+#endif
 
 #endif /* _NET_BOND_OPTIONS_H */
diff --git a/include/net/bonding.h b/include/net/bonding.h
index f3b986f6b6e4..d0dfe727e0b1 100644
--- a/include/net/bonding.h
+++ b/include/net/bonding.h
@@ -503,6 +503,13 @@ static inline int bond_is_ip_target_ok(__be32 addr)
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

