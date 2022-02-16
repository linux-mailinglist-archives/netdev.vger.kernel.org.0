Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 850974B82A3
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 09:12:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231408AbiBPIJZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 03:09:25 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:47800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231434AbiBPIJY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 03:09:24 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5173245675
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 00:09:10 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id q11-20020a17090a304b00b001b94d25eaecso1679816pjl.4
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 00:09:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=EMz5mP6s5hFk3iBp46LnmcdfuTfdMSI2m6f0Bue2wMs=;
        b=a+nZGJ526O0NVrAkzSmMZ/EE4XVrt2RajTV0pxQOYodDCaZuYsa02jkYHp6Vb1UfBH
         H7GaTZU6B20G8dQiKpQgcHvned7Sym/IM0/IDVo5agq427XSwGsqkKOu7AKiakv3d+V9
         nJ6uObz6oqfps2x0RlIAzedPT2wjgpgDvt0OOsieQyXZksjCJI5l8bxQ0dFzmTCn2+4s
         jQ4ChiN4gzxiRuNSLIEu09d1YSkY6LnyHNBDO8I5KXLtKWLzotMEpiWs+PVudhJO6+L+
         6n69PCXzMuH2KLfmEZvIA0cxwRZs85pnPCINmMlzq/nplTDQQUMGGnfir1tlaqpWn3fc
         0taw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EMz5mP6s5hFk3iBp46LnmcdfuTfdMSI2m6f0Bue2wMs=;
        b=Wrhtuda/tOYxzd3NA1+I02bJ0/jECh8IGhztduvnXgMNYBVhNndM3FPBcLjwHdnz7d
         iGah+3LxSF9iYAZFoItlWKLlFnx8ZwKMtf4kdtHlRMx4CMdOCBk9NqQ/uUPVTSv5pYrN
         eT2YMNvlYZdxo+WYj2W+HTOpfVDl3UWgrV+sd0I9mjjgXMkfTBZ+FA5bYliE1HQ9g/ch
         cxaWAsvkugqamnY9J8FI4Sg6FScH/m3pJUBBahWCqBFqG0lcfKFlp7GNS+iq1qQx7nlQ
         /5WFe3NrgoBHTEO4O4w0/DZvlIpFM3ZeS922tSLYkHrNnO74M0tmZbfcgjIdOHmjRf9F
         WVIg==
X-Gm-Message-State: AOAM532z6CFJlAz+mtdX0+S1gDPJCMs2elAZMU+MDd2/DzkPTTyoItF5
        T8xSI1tGgrYJQeM1bYxd64rfqUua66s=
X-Google-Smtp-Source: ABdhPJygUPd9x250R2HY5+KRGNdUsEBvEnMYphBH+ErWQYNFXOIn4Eadm2l3y8IFVHIckY8kXGSkQQ==
X-Received: by 2002:a17:90a:a087:b0:1b9:157f:4cc1 with SMTP id r7-20020a17090aa08700b001b9157f4cc1mr409899pjp.117.1644998949735;
        Wed, 16 Feb 2022 00:09:09 -0800 (PST)
Received: from Laptop-X1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id s15sm4635662pgn.30.2022.02.16.00.09.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Feb 2022 00:09:09 -0800 (PST)
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
Subject: [PATCH net-next 4/5] bonding: add new parameter ns_targets
Date:   Wed, 16 Feb 2022 16:08:37 +0800
Message-Id: <20220216080838.158054-5-liuhangbin@gmail.com>
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

Add a new bonding parameter ns_targets to store IPv6 address.
Add required bond_ns_send/rcv functions first before adding
IPv6 address option setting.

Add two functions bond_send/rcv_validate so we can send/recv
ARP and NS at the same time.

Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 drivers/net/bonding/bond_main.c    | 237 ++++++++++++++++++++++++++---
 drivers/net/bonding/bond_options.c |   2 +-
 include/net/bonding.h              |  19 ++-
 3 files changed, 237 insertions(+), 21 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 00621c523276..a395b8dc2673 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -88,6 +88,7 @@
 #if IS_ENABLED(CONFIG_TLS_DEVICE)
 #include <net/tls.h>
 #endif
+#include <net/ip6_route.h>
 
 #include "bonding_priv.h"
 
@@ -2976,30 +2977,17 @@ static void bond_validate_arp(struct bonding *bond, struct slave *slave, __be32
 	slave->target_last_arp_rx[i] = jiffies;
 }
 
-int bond_arp_rcv(const struct sk_buff *skb, struct bonding *bond,
-		 struct slave *slave)
+static int bond_arp_rcv(const struct sk_buff *skb, struct bonding *bond,
+			struct slave *slave)
 {
 	struct arphdr *arp = (struct arphdr *)skb->data;
 	struct slave *curr_active_slave, *curr_arp_slave;
 	unsigned char *arp_ptr;
 	__be32 sip, tip;
-	int is_arp = skb->protocol == __cpu_to_be16(ETH_P_ARP);
 	unsigned int alen;
 
-	if (!slave_do_arp_validate(bond, slave)) {
-		if ((slave_do_arp_validate_only(bond) && is_arp) ||
-		    !slave_do_arp_validate_only(bond))
-			slave->last_rx = jiffies;
-		return RX_HANDLER_ANOTHER;
-	} else if (!is_arp) {
-		return RX_HANDLER_ANOTHER;
-	}
-
 	alen = arp_hdr_len(bond->dev);
 
-	slave_dbg(bond->dev, slave->dev, "%s: skb->dev %s\n",
-		   __func__, skb->dev->name);
-
 	if (alen > skb_headlen(skb)) {
 		arp = kmalloc(alen, GFP_ATOMIC);
 		if (!arp)
@@ -3070,6 +3058,216 @@ int bond_arp_rcv(const struct sk_buff *skb, struct bonding *bond,
 	return RX_HANDLER_ANOTHER;
 }
 
+#if IS_ENABLED(CONFIG_IPV6)
+static void bond_ns_send(struct slave *slave, const struct in6_addr *daddr,
+			 const struct in6_addr *saddr, struct bond_vlan_tag *tags)
+{
+	struct net_device *bond_dev = slave->bond->dev;
+	struct net_device *slave_dev = slave->dev;
+	struct in6_addr mcaddr;
+	struct sk_buff *skb;
+
+	slave_dbg(bond_dev, slave_dev, "NS on slave: dst %pI6c src %pI6c\n",
+		  daddr, saddr);
+
+	skb = ndisc_ns_create(slave_dev, daddr, saddr, 0);
+	if (!skb) {
+		net_err_ratelimited("NS packet allocation failed\n");
+		return;
+	}
+
+	addrconf_addr_solict_mult(daddr, &mcaddr);
+	if (bond_handle_vlan(slave, tags, skb))
+		ndisc_send_skb(skb, &mcaddr, saddr);
+}
+
+static void bond_ns_send_all(struct bonding *bond, struct slave *slave)
+{
+	struct in6_addr *targets = bond->params.ns_targets;
+	struct bond_vlan_tag *tags;
+	struct dst_entry *dst;
+	struct in6_addr saddr;
+	struct flowi6 fl6;
+	int i;
+
+	for (i = 0; i < BOND_MAX_NS_TARGETS && !ipv6_addr_any(&targets[i]); i++) {
+		slave_dbg(bond->dev, slave->dev, "%s: target %pI6c\n",
+			  __func__, &targets[i]);
+		tags = NULL;
+
+		/* Find out through which dev should the packet go */
+		memset(&fl6, 0, sizeof(struct flowi6));
+		fl6.daddr = targets[i];
+		fl6.flowi6_oif = bond->dev->ifindex;
+
+		dst = ip6_route_output(dev_net(bond->dev), NULL, &fl6);
+		if (dst->error) {
+			dst_release(dst);
+			/* there's no route to target - try to send arp
+			 * probe to generate any traffic (arp_validate=0)
+			 */
+			if (bond->params.arp_validate)
+				pr_warn_once("%s: no route to ns_ip6_target %pI6c and arp_validate is set\n",
+					     bond->dev->name,
+					     &targets[i]);
+			bond_ns_send(slave, &targets[i], &in6addr_any, tags);
+			continue;
+		}
+
+		/* bond device itself */
+		if (dst->dev == bond->dev)
+			goto found;
+
+		rcu_read_lock();
+		tags = bond_verify_device_path(bond->dev, dst->dev, 0);
+		rcu_read_unlock();
+
+		if (!IS_ERR_OR_NULL(tags))
+			goto found;
+
+		/* Not our device - skip */
+		slave_dbg(bond->dev, slave->dev, "no path to ns_ip6_target %pI6c via dst->dev %s\n",
+			  &targets[i], dst->dev ? dst->dev->name : "NULL");
+
+		dst_release(dst);
+		continue;
+
+found:
+		if (!ipv6_dev_get_saddr(dev_net(dst->dev), dst->dev, &targets[i], 0, &saddr))
+			bond_ns_send(slave, &targets[i], &saddr, tags);
+		dst_release(dst);
+		kfree(tags);
+	}
+}
+
+static int bond_confirm_addr6(struct net_device *dev,
+			      struct netdev_nested_priv *priv)
+{
+	struct in6_addr *addr = (struct in6_addr *)priv->data;
+
+	return ipv6_chk_addr(dev_net(dev), addr, dev, 0);
+}
+
+static bool bond_has_this_ip6(struct bonding *bond, struct in6_addr *addr)
+{
+	struct netdev_nested_priv priv = {
+		.data = addr,
+	};
+	int ret = false;
+
+	if (bond_confirm_addr6(bond->dev, &priv))
+		return true;
+
+	rcu_read_lock();
+	if (netdev_walk_all_upper_dev_rcu(bond->dev, bond_confirm_addr6, &priv))
+		ret = true;
+	rcu_read_unlock();
+
+	return ret;
+}
+
+static void bond_validate_ns(struct bonding *bond, struct slave *slave,
+			     struct in6_addr *saddr, struct in6_addr *daddr)
+{
+	int i;
+
+	if (ipv6_addr_any(saddr) || !bond_has_this_ip6(bond, daddr)) {
+		slave_dbg(bond->dev, slave->dev, "%s: sip %pI6c tip %pI6c not found\n",
+			  __func__, saddr, daddr);
+		return;
+	}
+
+	i = bond_get_targets_ip6(bond->params.ns_targets, saddr);
+	if (i == -1) {
+		slave_dbg(bond->dev, slave->dev, "%s: sip %pI6c not found in targets\n",
+			  __func__, saddr);
+		return;
+	}
+	slave->last_rx = jiffies;
+	slave->target_last_arp_rx[i] = jiffies;
+}
+
+static int bond_na_rcv(const struct sk_buff *skb, struct bonding *bond,
+		       struct slave *slave)
+{
+	struct slave *curr_active_slave, *curr_arp_slave;
+	struct icmp6hdr *hdr = icmp6_hdr(skb);
+	struct in6_addr *saddr, *daddr;
+
+	if (skb->pkt_type == PACKET_OTHERHOST ||
+	    skb->pkt_type == PACKET_LOOPBACK ||
+	    hdr->icmp6_type != NDISC_NEIGHBOUR_ADVERTISEMENT)
+		goto out;
+
+	saddr = &ipv6_hdr(skb)->saddr;
+	daddr = &ipv6_hdr(skb)->daddr;
+
+	slave_dbg(bond->dev, slave->dev, "%s: %s/%d av %d sv %d sip %pI6c tip %pI6c\n",
+		  __func__, slave->dev->name, bond_slave_state(slave),
+		  bond->params.arp_validate, slave_do_arp_validate(bond, slave),
+		  saddr, daddr);
+
+	curr_active_slave = rcu_dereference(bond->curr_active_slave);
+	curr_arp_slave = rcu_dereference(bond->current_arp_slave);
+
+	/* We 'trust' the received ARP enough to validate it if:
+	 * see bond_arp_rcv().
+	 */
+	if (bond_is_active_slave(slave))
+		bond_validate_ns(bond, slave, saddr, daddr);
+	else if (curr_active_slave &&
+		 time_after(slave_last_rx(bond, curr_active_slave),
+			    curr_active_slave->last_link_up))
+		bond_validate_ns(bond, slave, saddr, daddr);
+	else if (curr_arp_slave &&
+		 bond_time_in_interval(bond,
+				       dev_trans_start(curr_arp_slave->dev), 1))
+		bond_validate_ns(bond, slave, saddr, daddr);
+
+out:
+	return RX_HANDLER_ANOTHER;
+}
+#endif
+
+int bond_rcv_validate(const struct sk_buff *skb, struct bonding *bond,
+		      struct slave *slave)
+{
+#if IS_ENABLED(CONFIG_IPV6)
+	bool is_ipv6 = skb->protocol == __cpu_to_be16(ETH_P_IPV6);
+#endif
+	bool is_arp = skb->protocol == __cpu_to_be16(ETH_P_ARP);
+
+	slave_dbg(bond->dev, slave->dev, "%s: skb->dev %s\n",
+		  __func__, skb->dev->name);
+
+	/* Use arp validate logic for both ARP and NS */
+	if (!slave_do_arp_validate(bond, slave)) {
+		if ((slave_do_arp_validate_only(bond) && is_arp) ||
+#if IS_ENABLED(CONFIG_IPV6)
+		    (slave_do_arp_validate_only(bond) && is_ipv6) ||
+#endif
+		    !slave_do_arp_validate_only(bond))
+			slave->last_rx = jiffies;
+		return RX_HANDLER_ANOTHER;
+	} else if (is_arp) {
+		return bond_arp_rcv(skb, bond, slave);
+#if IS_ENABLED(CONFIG_IPV6)
+	} else if (is_ipv6) {
+		return bond_na_rcv(skb, bond, slave);
+#endif
+	} else {
+		return RX_HANDLER_ANOTHER;
+	}
+}
+
+static void bond_send_validate(struct bonding *bond, struct slave *slave)
+{
+	bond_arp_send_all(bond, slave);
+#if IS_ENABLED(CONFIG_IPV6)
+	bond_ns_send_all(bond, slave);
+#endif
+}
+
 /* function to verify if we're in the arp_interval timeslice, returns true if
  * (last_act - arp_interval) <= jiffies <= (last_act + mod * arp_interval +
  * arp_interval/2) . the arp_interval/2 is needed for really fast networks.
@@ -3165,7 +3363,7 @@ static void bond_loadbalance_arp_mon(struct bonding *bond)
 		 * to be unstable during low/no traffic periods
 		 */
 		if (bond_slave_is_up(slave))
-			bond_arp_send_all(bond, slave);
+			bond_send_validate(bond, slave);
 	}
 
 	rcu_read_unlock();
@@ -3379,7 +3577,7 @@ static bool bond_ab_arp_probe(struct bonding *bond)
 			    curr_active_slave->dev->name);
 
 	if (curr_active_slave) {
-		bond_arp_send_all(bond, curr_active_slave);
+		bond_send_validate(bond, curr_active_slave);
 		return should_notify_rtnl;
 	}
 
@@ -3431,7 +3629,7 @@ static bool bond_ab_arp_probe(struct bonding *bond)
 	bond_set_slave_link_state(new_slave, BOND_LINK_BACK,
 				  BOND_SLAVE_NOTIFY_LATER);
 	bond_set_slave_active_flags(new_slave, BOND_SLAVE_NOTIFY_LATER);
-	bond_arp_send_all(bond, new_slave);
+	bond_send_validate(bond, new_slave);
 	new_slave->last_link_up = jiffies;
 	rcu_assign_pointer(bond->current_arp_slave, new_slave);
 
@@ -3967,7 +4165,7 @@ static int bond_open(struct net_device *bond_dev)
 
 	if (bond->params.arp_interval) {  /* arp interval, in milliseconds. */
 		queue_delayed_work(bond->wq, &bond->arp_work, 0);
-		bond->recv_probe = bond_arp_rcv;
+		bond->recv_probe = bond_rcv_validate;
 	}
 
 	if (BOND_MODE(bond) == BOND_MODE_8023AD) {
@@ -5948,6 +6146,7 @@ static int bond_check_params(struct bond_params *params)
 		strscpy_pad(params->primary, primary, sizeof(params->primary));
 
 	memcpy(params->arp_targets, arp_target, sizeof(arp_target));
+	memset(params->ns_targets, 0, sizeof(struct in6_addr) * BOND_MAX_NS_TARGETS);
 
 	return 0;
 }
diff --git a/drivers/net/bonding/bond_options.c b/drivers/net/bonding/bond_options.c
index 2e8484a91a0e..ab575135b626 100644
--- a/drivers/net/bonding/bond_options.c
+++ b/drivers/net/bonding/bond_options.c
@@ -1052,7 +1052,7 @@ static int bond_option_arp_interval_set(struct bonding *bond,
 			cancel_delayed_work_sync(&bond->arp_work);
 		} else {
 			/* arp_validate can be set only in active-backup mode */
-			bond->recv_probe = bond_arp_rcv;
+			bond->recv_probe = bond_rcv_validate;
 			cancel_delayed_work_sync(&bond->mii_work);
 			queue_delayed_work(bond->wq, &bond->arp_work, 0);
 		}
diff --git a/include/net/bonding.h b/include/net/bonding.h
index 7dead855a72d..f3b986f6b6e4 100644
--- a/include/net/bonding.h
+++ b/include/net/bonding.h
@@ -29,8 +29,11 @@
 #include <net/bond_3ad.h>
 #include <net/bond_alb.h>
 #include <net/bond_options.h>
+#include <net/ipv6.h>
+#include <net/addrconf.h>
 
 #define BOND_MAX_ARP_TARGETS	16
+#define BOND_MAX_NS_TARGETS	BOND_MAX_ARP_TARGETS
 
 #define BOND_DEFAULT_MIIMON	100
 
@@ -146,6 +149,7 @@ struct bond_params {
 	struct reciprocal_value reciprocal_packets_per_slave;
 	u16 ad_actor_sys_prio;
 	u16 ad_user_port_key;
+	struct in6_addr ns_targets[BOND_MAX_NS_TARGETS];
 
 	/* 2 bytes of padding : see ether_addr_equal_64bits() */
 	u8 ad_actor_system[ETH_ALEN + 2];
@@ -628,7 +632,7 @@ struct bond_net {
 	struct class_attribute	class_attr_bonding_masters;
 };
 
-int bond_arp_rcv(const struct sk_buff *skb, struct bonding *bond, struct slave *slave);
+int bond_rcv_validate(const struct sk_buff *skb, struct bonding *bond, struct slave *slave);
 netdev_tx_t bond_dev_queue_xmit(struct bonding *bond, struct sk_buff *skb, struct net_device *slave_dev);
 int bond_create(struct net *net, const char *name);
 int bond_create_sysfs(struct bond_net *net);
@@ -735,6 +739,19 @@ static inline int bond_get_targets_ip(__be32 *targets, __be32 ip)
 	return -1;
 }
 
+static inline int bond_get_targets_ip6(struct in6_addr *targets, struct in6_addr *ip)
+{
+	int i;
+
+	for (i = 0; i < BOND_MAX_NS_TARGETS; i++)
+		if (ipv6_addr_equal(&targets[i], ip))
+			return i;
+		else if (ipv6_addr_any(&targets[i]))
+			break;
+
+	return -1;
+}
+
 /* exported from bond_main.c */
 extern unsigned int bond_net_id;
 
-- 
2.31.1

