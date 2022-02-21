Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8A064BD5BB
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 07:00:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344796AbiBUFz7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 00:55:59 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:35714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344812AbiBUFz4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 00:55:56 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F02665133E
        for <netdev@vger.kernel.org>; Sun, 20 Feb 2022 21:55:33 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id v8-20020a17090a634800b001bb78857ccdso15629927pjs.1
        for <netdev@vger.kernel.org>; Sun, 20 Feb 2022 21:55:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SQ1jDpyQQodpjHxN//klhWBcwZlsw8zWPf5cbK/x5VU=;
        b=gm2DX2Xbf3opa/B8P03oKrB2zBPhQIK+TXxJeg+pSjs1jV9UghN2+wQE3DnkoKkNXZ
         YV3miUaX1PtiJgiLXm5IFBmQA81L9JhIvr6mkQqYfmMlKb92/IzgSwdQJIbRZQsPi9b9
         MUcJ3Fv2MDwCHI4c04WRM7CKhT2XQeKuUvlCdW+ius4+qawKoNxV/DkFrAMSdR+t9dy1
         Yd+mH5jYmrGLCw1eby2ZLI/V3LQ4dN4JGTO5DoMXy344QjKvB2JarJ2E7y98xrDKZakj
         8g1uuRaYFYjmbNEEKvtcqqF3VPW7lLiN6X24LiJy1+ZZ49btugH8/IYhXNmBMpko/qMz
         CI8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SQ1jDpyQQodpjHxN//klhWBcwZlsw8zWPf5cbK/x5VU=;
        b=wD2RBxsvJOvG0VcF0jr5JVrYkQ7N2xqjLgcWYpyj73/MbxnPyCQABAcRf/n5jQ/GXz
         l7pIZx58dN5VYqVQC7dIMMNStjB8pvD4VFuRVj7A7INLqdzkNIrZe3dwO73MksbXpYQu
         NuoRrVpJgWKH2DNw8RKMhLld9THd8JXL/8GqVzGBPLXvhujd1sZJm8S8iHKL3hLgpvR4
         uMm8NwmDSMy+WJOYES0QlhivI1w0Es3y6VANOs3sZf2vCL+KJVuDrb9lAB3Chy+LFgNj
         ZYnUtSlPUFt48dlDKiy5ksw75Hngai0xmmgXNpmbaIMe/JUMNBUIdeZ4hLM2ZN7DNWGK
         bWtg==
X-Gm-Message-State: AOAM532XsTTJq6OcGSqRsm1AeRyybIrQh4KkWxZGn6Rs4PqPNScPvk79
        M3jCrZ0wpXOjUUa3iOjC5KlsC9Vbbdg=
X-Google-Smtp-Source: ABdhPJyQh5HuHToyMIvpRGBQU7IMie9JTlRJ6SyH1B24vXZlvI8WgLjmHWWdaEnevDNB7ooYHUm6ng==
X-Received: by 2002:a17:90b:360e:b0:1b9:d9f0:b37 with SMTP id ml14-20020a17090b360e00b001b9d9f00b37mr19749832pjb.111.1645422933038;
        Sun, 20 Feb 2022 21:55:33 -0800 (PST)
Received: from Laptop-X1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id s15sm17359767pgn.30.2022.02.20.21.55.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Feb 2022 21:55:32 -0800 (PST)
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
        Eric Dumazet <eric.dumazet@gmail.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCHv2 net-next 5/5] bonding: add new option ns_ip6_target
Date:   Mon, 21 Feb 2022 13:54:57 +0800
Message-Id: <20220221055458.18790-6-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220221055458.18790-1-liuhangbin@gmail.com>
References: <20220221055458.18790-1-liuhangbin@gmail.com>
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

Note: the sysfs configuration support was removed based on
https://lore.kernel.org/netdev/8863.1645071997@famine

Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
v2: remove sysfs configuration
---
 Documentation/networking/bonding.rst | 11 +++++
 drivers/net/bonding/bond_netlink.c   | 59 +++++++++++++++++++++++
 drivers/net/bonding/bond_options.c   | 72 ++++++++++++++++++++++++++++
 include/net/bond_options.h           |  4 ++
 include/net/bonding.h                |  7 +++
 include/uapi/linux/if_link.h         |  1 +
 tools/include/uapi/linux/if_link.h   |  1 +
 7 files changed, 155 insertions(+)

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
index ab575135b626..64f7db2627ce 100644
--- a/drivers/net/bonding/bond_options.c
+++ b/drivers/net/bonding/bond_options.c
@@ -34,6 +34,10 @@ static int bond_option_arp_ip_target_add(struct bonding *bond, __be32 target);
 static int bond_option_arp_ip_target_rem(struct bonding *bond, __be32 target);
 static int bond_option_arp_ip_targets_set(struct bonding *bond,
 					  const struct bond_opt_value *newval);
+#if IS_ENABLED(CONFIG_IPV6)
+static int bond_option_ns_ip6_targets_set(struct bonding *bond,
+					  const struct bond_opt_value *newval);
+#endif
 static int bond_option_arp_validate_set(struct bonding *bond,
 					const struct bond_opt_value *newval);
 static int bond_option_arp_all_targets_set(struct bonding *bond,
@@ -295,6 +299,15 @@ static const struct bond_option bond_opts[BOND_OPT_LAST] = {
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
@@ -1184,6 +1197,65 @@ static int bond_option_arp_ip_targets_set(struct bonding *bond,
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
+static int bond_option_ns_ip6_targets_set(struct bonding *bond,
+					  const struct bond_opt_value *newval)
+{
+	struct in6_addr *target = (struct in6_addr *)newval->extra;
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
+#endif
+
 static int bond_option_arp_validate_set(struct bonding *bond,
 					const struct bond_opt_value *newval)
 {
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

