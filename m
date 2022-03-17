Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 749F64DBFA3
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 07:50:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229996AbiCQGwD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 02:52:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229637AbiCQGwB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 02:52:01 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93970DFD45
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 23:50:43 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id g17so7454588lfh.2
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 23:50:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CBpOpgR5F1RukWk4rMFCOYveSEljF2XAMrExoOZw//0=;
        b=LrDQ3zNcP0OhmgMXrmyv3pwlyHnEYXH+NxS7dVwkIaLF9ZuGTSd95aWyy9G+KYLaTk
         ItdNFVDWFsSNHaTaBdvSd5pLVWxwxsPuZhJGIiTOf6mPHX/JBs6CxtsQpZjTbYQ6nKLK
         ntfdyM/aoSxes7+iGYvPjWdtvddSqsyi0ZqLfH70lCfoNcX6iYqoe3aiGG6RcmwXuKZx
         bgN52Plo3qTRaEk0czc+oz1JxU6G5878O5Sohay0PkbcNtJ7ORGcx8Q2LaxU/KXKcvqo
         ljWkO4DnNYOiKhYo0J4AOuuoNUxhoMuNTHWmJ5uy9U9rURfqItOPp+m/35lACyg7u56J
         EVag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CBpOpgR5F1RukWk4rMFCOYveSEljF2XAMrExoOZw//0=;
        b=wHDFUNsQDYaiwQ14vcpnYfZopNVGn96OJN1nS13lcCUMsZyD648K3W1X0RnFMG9VYH
         1ZRN9hq0JgZGX7QT1Hce1alJ7HG39Fq+fvOF+GGW5s+1HSYYdnTXw8iX4fG3OSP7zug+
         sjuYT7zhdfP/0X9ICcXuY/DAwpgpWv0UnzNEumtL9QyTu4Ru6xnTEy1JVMSlxuevlxjo
         5JS3L8/S2MP80VtcxHzlTUq21CBtpBqcIa9S0yAVYmgJELnqArFBueML8Bk2CceW8z4X
         HHcH/gQFuPaA+AXUnH3N+1WLRQypO/0k7p4JbHBgWst2JKa5E+b9IKDixEOyWBxltwaJ
         FQ7w==
X-Gm-Message-State: AOAM532WKy2Sm//ckc7+ekAihRPvfXoKA8/re3lSfkMzk8h+bfSP682K
        ODXzfwiM1U+l5i29mOq9JR7G40DqH214f9Od
X-Google-Smtp-Source: ABdhPJyRLpTiaIoqv9HTdhIBdiJze2WTcO1mMRNzgq1lH/huyC2NqGCpYBb9im15psPK903ExvLJaQ==
X-Received: by 2002:ac2:5933:0:b0:448:3821:571f with SMTP id v19-20020ac25933000000b004483821571fmr1966053lfi.375.1647499841437;
        Wed, 16 Mar 2022 23:50:41 -0700 (PDT)
Received: from wse-c0089.raspi.local (h-98-128-237-157.A259.priv.bahnhof.se. [98.128.237.157])
        by smtp.gmail.com with ESMTPSA id l25-20020ac25559000000b0044825a2539csm362215lfk.59.2022.03.16.23.50.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Mar 2022 23:50:40 -0700 (PDT)
From:   Mattias Forsblad <mattias.forsblad@gmail.com>
To:     netdev@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Mattias Forsblad <mattias.forsblad@gmail.com>
Subject: [PATCH 2/5] net: bridge: Implement bridge flood flag
Date:   Thu, 17 Mar 2022 07:50:28 +0100
Message-Id: <20220317065031.3830481-3-mattias.forsblad@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220317065031.3830481-1-mattias.forsblad@gmail.com>
References: <20220317065031.3830481-1-mattias.forsblad@gmail.com>
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

This patch implements the bridge flood flags. There are three different
flags matching unicast, multicast and broadcast. When the corresponding
flag is cleared packets received on bridge ports will not be flooded
towards the bridge.
This makes is possible to only forward selected traffic between the
port members of the bridge.

Signed-off-by: Mattias Forsblad <mattias.forsblad@gmail.com>
---
 include/linux/if_bridge.h      |  6 +++++
 include/uapi/linux/if_bridge.h |  9 ++++++-
 net/bridge/br.c                | 45 ++++++++++++++++++++++++++++++++++
 net/bridge/br_device.c         |  3 +++
 net/bridge/br_input.c          | 23 ++++++++++++++---
 net/bridge/br_private.h        |  4 +++
 6 files changed, 85 insertions(+), 5 deletions(-)

diff --git a/include/linux/if_bridge.h b/include/linux/if_bridge.h
index 3aae023a9353..fa8e000a6fb9 100644
--- a/include/linux/if_bridge.h
+++ b/include/linux/if_bridge.h
@@ -157,6 +157,7 @@ static inline int br_vlan_get_info_rcu(const struct net_device *dev, u16 vid,
 struct net_device *br_fdb_find_port(const struct net_device *br_dev,
 				    const unsigned char *addr,
 				    __u16 vid);
+bool br_flood_enabled(const struct net_device *dev);
 void br_fdb_clear_offload(const struct net_device *dev, u16 vid);
 bool br_port_flag_is_set(const struct net_device *dev, unsigned long flag);
 u8 br_port_get_stp_state(const struct net_device *dev);
@@ -170,6 +171,11 @@ br_fdb_find_port(const struct net_device *br_dev,
 	return NULL;
 }
 
+static inline bool br_flood_enabled(const struct net_device *dev)
+{
+	return true;
+}
+
 static inline void br_fdb_clear_offload(const struct net_device *dev, u16 vid)
 {
 }
diff --git a/include/uapi/linux/if_bridge.h b/include/uapi/linux/if_bridge.h
index 2711c3522010..765ed70c9b28 100644
--- a/include/uapi/linux/if_bridge.h
+++ b/include/uapi/linux/if_bridge.h
@@ -72,6 +72,7 @@ struct __bridge_info {
 	__u32 tcn_timer_value;
 	__u32 topology_change_timer_value;
 	__u32 gc_timer_value;
+	__u8 flood;
 };
 
 struct __port_info {
@@ -752,13 +753,19 @@ struct br_mcast_stats {
 /* bridge boolean options
  * BR_BOOLOPT_NO_LL_LEARN - disable learning from link-local packets
  * BR_BOOLOPT_MCAST_VLAN_SNOOPING - control vlan multicast snooping
+ * BR_BOOLOPT_FLOOD - control bridge flood flag
+ * BR_BOOLOPT_MCAST_FLOOD - control bridge multicast flood flag
+ * BR_BOOLOPT_BCAST_FLOOD - control bridge broadcast flood flag
  *
  * IMPORTANT: if adding a new option do not forget to handle
- *            it in br_boolopt_toggle/get and bridge sysfs
+ *            it in br_boolopt_toggle/get
  */
 enum br_boolopt_id {
 	BR_BOOLOPT_NO_LL_LEARN,
 	BR_BOOLOPT_MCAST_VLAN_SNOOPING,
+	BR_BOOLOPT_FLOOD,
+	BR_BOOLOPT_MCAST_FLOOD,
+	BR_BOOLOPT_BCAST_FLOOD,
 	BR_BOOLOPT_MAX
 };
 
diff --git a/net/bridge/br.c b/net/bridge/br.c
index b1dea3febeea..63a17bed6c63 100644
--- a/net/bridge/br.c
+++ b/net/bridge/br.c
@@ -265,6 +265,11 @@ int br_boolopt_toggle(struct net_bridge *br, enum br_boolopt_id opt, bool on,
 	case BR_BOOLOPT_MCAST_VLAN_SNOOPING:
 		err = br_multicast_toggle_vlan_snooping(br, on, extack);
 		break;
+	case BR_BOOLOPT_FLOOD:
+	case BR_BOOLOPT_MCAST_FLOOD:
+	case BR_BOOLOPT_BCAST_FLOOD:
+		err = br_flood_toggle(br, opt, on);
+		break;
 	default:
 		/* shouldn't be called with unsupported options */
 		WARN_ON(1);
@@ -281,6 +286,12 @@ int br_boolopt_get(const struct net_bridge *br, enum br_boolopt_id opt)
 		return br_opt_get(br, BROPT_NO_LL_LEARN);
 	case BR_BOOLOPT_MCAST_VLAN_SNOOPING:
 		return br_opt_get(br, BROPT_MCAST_VLAN_SNOOPING_ENABLED);
+	case BR_BOOLOPT_FLOOD:
+		return br_opt_get(br, BROPT_FLOOD);
+	case BR_BOOLOPT_MCAST_FLOOD:
+		return br_opt_get(br, BROPT_MCAST_FLOOD);
+	case BR_BOOLOPT_BCAST_FLOOD:
+		return br_opt_get(br, BROPT_BCAST_FLOOD);
 	default:
 		/* shouldn't be called with unsupported options */
 		WARN_ON(1);
@@ -325,6 +336,40 @@ void br_boolopt_multi_get(const struct net_bridge *br,
 	bm->optmask = GENMASK((BR_BOOLOPT_MAX - 1), 0);
 }
 
+int br_flood_toggle(struct net_bridge *br, enum br_boolopt_id opt,
+		    bool on)
+{
+	struct switchdev_attr attr = {
+		.orig_dev = br->dev,
+		.id = SWITCHDEV_ATTR_ID_BRIDGE_FLOOD,
+		.flags = SWITCHDEV_F_DEFER,
+	};
+	enum net_bridge_opts bropt;
+	int ret;
+
+	switch (opt) {
+	case BR_BOOLOPT_FLOOD:
+		bropt = BROPT_FLOOD;
+		break;
+	case BR_BOOLOPT_MCAST_FLOOD:
+		bropt = BROPT_MCAST_FLOOD;
+		break;
+	case BR_BOOLOPT_BCAST_FLOOD:
+		bropt = BROPT_BCAST_FLOOD;
+		break;
+	default:
+		WARN_ON(1);
+		return -EINVAL;
+	}
+	br_opt_toggle(br, bropt, on);
+
+	attr.u.brport_flags.mask = BIT(bropt);
+	attr.u.brport_flags.val = on << bropt;
+	ret = switchdev_port_attr_set(br->dev, &attr, NULL);
+
+	return ret;
+}
+
 /* private bridge options, controlled by the kernel */
 void br_opt_toggle(struct net_bridge *br, enum net_bridge_opts opt, bool on)
 {
diff --git a/net/bridge/br_device.c b/net/bridge/br_device.c
index 8d6bab244c4a..fafaef9d4b3a 100644
--- a/net/bridge/br_device.c
+++ b/net/bridge/br_device.c
@@ -524,6 +524,9 @@ void br_dev_setup(struct net_device *dev)
 	br->bridge_hello_time = br->hello_time = 2 * HZ;
 	br->bridge_forward_delay = br->forward_delay = 15 * HZ;
 	br->bridge_ageing_time = br->ageing_time = BR_DEFAULT_AGEING_TIME;
+	br_opt_toggle(br, BROPT_FLOOD, true);
+	br_opt_toggle(br, BROPT_MCAST_FLOOD, true);
+	br_opt_toggle(br, BROPT_BCAST_FLOOD, true);
 	dev->max_mtu = ETH_MAX_MTU;
 
 	br_netfilter_rtable_init(br);
diff --git a/net/bridge/br_input.c b/net/bridge/br_input.c
index e0c13fcc50ed..fcb0757bfdcc 100644
--- a/net/bridge/br_input.c
+++ b/net/bridge/br_input.c
@@ -109,11 +109,12 @@ int br_handle_frame_finish(struct net *net, struct sock *sk, struct sk_buff *skb
 		/* by definition the broadcast is also a multicast address */
 		if (is_broadcast_ether_addr(eth_hdr(skb)->h_dest)) {
 			pkt_type = BR_PKT_BROADCAST;
-			local_rcv = true;
+			local_rcv = true && br_opt_get(br, BROPT_BCAST_FLOOD);
 		} else {
 			pkt_type = BR_PKT_MULTICAST;
-			if (br_multicast_rcv(&brmctx, &pmctx, vlan, skb, vid))
-				goto drop;
+			if (br_opt_get(br, BROPT_MCAST_FLOOD))
+				if (br_multicast_rcv(&brmctx, &pmctx, vlan, skb, vid))
+					goto drop;
 		}
 	}
 
@@ -155,9 +156,13 @@ int br_handle_frame_finish(struct net *net, struct sock *sk, struct sk_buff *skb
 			local_rcv = true;
 			br->dev->stats.multicast++;
 		}
+		if (!br_opt_get(br, BROPT_MCAST_FLOOD))
+			local_rcv = false;
 		break;
 	case BR_PKT_UNICAST:
 		dst = br_fdb_find_rcu(br, eth_hdr(skb)->h_dest, vid);
+		if (!br_opt_get(br, BROPT_FLOOD))
+			local_rcv = false;
 		break;
 	default:
 		break;
@@ -166,7 +171,7 @@ int br_handle_frame_finish(struct net *net, struct sock *sk, struct sk_buff *skb
 	if (dst) {
 		unsigned long now = jiffies;
 
-		if (test_bit(BR_FDB_LOCAL, &dst->flags))
+		if (test_bit(BR_FDB_LOCAL, &dst->flags) && local_rcv)
 			return br_pass_frame_up(skb);
 
 		if (now != dst->used)
@@ -190,6 +195,16 @@ int br_handle_frame_finish(struct net *net, struct sock *sk, struct sk_buff *skb
 }
 EXPORT_SYMBOL_GPL(br_handle_frame_finish);
 
+bool br_flood_enabled(const struct net_device *dev)
+{
+	struct net_bridge *br = netdev_priv(dev);
+
+	return !!(br_opt_get(br, BROPT_FLOOD) ||
+		   br_opt_get(br, BROPT_MCAST_FLOOD) ||
+		   br_opt_get(br, BROPT_BCAST_FLOOD));
+}
+EXPORT_SYMBOL_GPL(br_flood_enabled);
+
 static void __br_handle_local_finish(struct sk_buff *skb)
 {
 	struct net_bridge_port *p = br_port_get_rcu(skb->dev);
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 48bc61ebc211..cf88dce0b92b 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -445,6 +445,9 @@ enum net_bridge_opts {
 	BROPT_NO_LL_LEARN,
 	BROPT_VLAN_BRIDGE_BINDING,
 	BROPT_MCAST_VLAN_SNOOPING_ENABLED,
+	BROPT_FLOOD,
+	BROPT_MCAST_FLOOD,
+	BROPT_BCAST_FLOOD,
 };
 
 struct net_bridge {
@@ -720,6 +723,7 @@ int br_boolopt_multi_toggle(struct net_bridge *br,
 void br_boolopt_multi_get(const struct net_bridge *br,
 			  struct br_boolopt_multi *bm);
 void br_opt_toggle(struct net_bridge *br, enum net_bridge_opts opt, bool on);
+int br_flood_toggle(struct net_bridge *br, enum br_boolopt_id opt, bool on);
 
 /* br_device.c */
 void br_dev_setup(struct net_device *dev);
-- 
2.25.1

