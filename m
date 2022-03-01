Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FA264C88CB
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 11:03:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234140AbiCAKEf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 05:04:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234029AbiCAKEc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 05:04:32 -0500
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64A638BF45
        for <netdev@vger.kernel.org>; Tue,  1 Mar 2022 02:03:50 -0800 (PST)
Received: by mail-lf1-x12a.google.com with SMTP id d23so25900083lfv.13
        for <netdev@vger.kernel.org>; Tue, 01 Mar 2022 02:03:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:organization:content-transfer-encoding;
        bh=soqNIu0iZXYKGoeg5fysgUJf/i7Fd0LPBuPDz6+ETkE=;
        b=RQFqju729+zbobiJJ66cSJ/tNlAOMqRPvrUm4m5xP0XT7amFkV33K7jbFlh2KrfHDk
         uZ7i7LpiQZ0PI00pQdUc4zUrXP8pdaCm/Pf/ROXMy4NYjaG7ZF0hS+RYZ3b0tH3eLn/6
         z53RGoSzO5S9edpVmoaeUo4nQV3IMRj4d6NDK5f6YnZ5rEboDIUaCXfZMnfMT8G+SIdg
         QPmTwE1T7KBOeOQEcg4RzPIWskFWU5AyQ7/3p7Yh4xyJxsc3I1COt1gxFbIhsUJZnrAM
         vIj+5NTY1YJZTOXkPqCBWA1kzbshSaPJiPOY5Q6VFlo8SBi+l0DE2Iaq4K6nURwVroCq
         Fc5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:organization:content-transfer-encoding;
        bh=soqNIu0iZXYKGoeg5fysgUJf/i7Fd0LPBuPDz6+ETkE=;
        b=zM8zPtGnbu1TlQXhYJgIqeW0K1TA7KpAJ2eHCW47iD9wyj5ILU3BKEBWpPEiear+lr
         aU8q5YbCWQLPrCfX1ACB8Lcb2P79t4tNcViiwpVV+RYT7ygE1Pv1+UFj8sReVNC54PF8
         +PvlfoEayoDXSXVfA8MBiVX4vska3VSVheNd9JqsYoh8qodLZWQUVclZq0s5211GudaV
         +wI69XxEdczOOGhiqLOhGnCtZF5wqh7UllBv5W6s+6ArRShqjlFB1Q39WPeos1ytu9xa
         WoXba6a0/0Zl+mz4K8oGdpUtX/y4O2ohRemvKAXQ7Xd5J1SO2K89YnFN/XK4XP37Km0j
         Qayw==
X-Gm-Message-State: AOAM531T0dDMfV1E7Nc8wJ8L8WY083HtyXt+wc2EVEAyPQdOHWPUTrdV
        R9AkfnrgN3dS7llOdXX391jT1Q==
X-Google-Smtp-Source: ABdhPJxWVmiHoQwdZpQDKjvR8Zzvq72vgxnfzolgqDV50mvlEYBQNgOoY+e0Mhzv7QpWd7l/INTNBQ==
X-Received: by 2002:a05:6512:2808:b0:43f:4baa:7e5f with SMTP id cf8-20020a056512280800b0043f4baa7e5fmr15099670lfb.498.1646129028592;
        Tue, 01 Mar 2022 02:03:48 -0800 (PST)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id s27-20020a05651c049b00b002460fd4252asm1826822ljc.100.2022.03.01.02.03.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Mar 2022 02:03:48 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Russell King <linux@armlinux.org.uk>,
        Petr Machata <petrm@nvidia.com>,
        Cooper Lees <me@cooperlees.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Matt Johnston <matt@codeconstruct.com.au>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bridge@lists.linux-foundation.org
Subject: [PATCH v2 net-next 01/10] net: bridge: mst: Multiple Spanning Tree (MST) mode
Date:   Tue,  1 Mar 2022 11:03:12 +0100
Message-Id: <20220301100321.951175-2-tobias@waldekranz.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220301100321.951175-1-tobias@waldekranz.com>
References: <20220301100321.951175-1-tobias@waldekranz.com>
MIME-Version: 1.0
Organization: Westermo
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Allow the user to switch from the current per-VLAN STP mode to an MST
mode.

Up to this point, per-VLAN STP states where always isolated from each
other. This is in contrast to the MSTP standard (802.1Q-2018, Clause
13.5), where VLANs are grouped into MST instances (MSTIs), and the
state is managed on a per-MSTI level, rather that at the per-VLAN
level.

Perhaps due to the prevalence of the standard, many switching ASICs
are built after the same model. Therefore, add a corresponding MST
mode to the bridge, which we can later add offloading support for in a
straight-forward way.

For now, all VLANs are fixed to MSTI 0, also called the Common
Spanning Tree (CST). That is, all VLANs will follow the port-global
state.

Upcoming changes will make this actually useful by allowing VLANs to
be mapped to arbitrary MSTIs and allow individual MSTI states to be
changed.

Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
---
 include/uapi/linux/if_link.h |  1 +
 net/bridge/Makefile          |  2 +-
 net/bridge/br_input.c        | 17 +++++++-
 net/bridge/br_mst.c          | 83 ++++++++++++++++++++++++++++++++++++
 net/bridge/br_netlink.c      | 14 +++++-
 net/bridge/br_private.h      | 26 +++++++++++
 net/bridge/br_stp.c          |  3 ++
 net/bridge/br_vlan.c         | 20 ++++++++-
 net/bridge/br_vlan_options.c |  5 +++
 9 files changed, 166 insertions(+), 5 deletions(-)
 create mode 100644 net/bridge/br_mst.c

diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index e315e53125f4..7e0a653aafa3 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -482,6 +482,7 @@ enum {
 	IFLA_BR_VLAN_STATS_PER_PORT,
 	IFLA_BR_MULTI_BOOLOPT,
 	IFLA_BR_MCAST_QUERIER_STATE,
+	IFLA_BR_MST_ENABLED,
 	__IFLA_BR_MAX,
 };
 
diff --git a/net/bridge/Makefile b/net/bridge/Makefile
index 7fb9a021873b..24bd1c0a9a5a 100644
--- a/net/bridge/Makefile
+++ b/net/bridge/Makefile
@@ -20,7 +20,7 @@ obj-$(CONFIG_BRIDGE_NETFILTER) += br_netfilter.o
 
 bridge-$(CONFIG_BRIDGE_IGMP_SNOOPING) += br_multicast.o br_mdb.o br_multicast_eht.o
 
-bridge-$(CONFIG_BRIDGE_VLAN_FILTERING) += br_vlan.o br_vlan_tunnel.o br_vlan_options.o
+bridge-$(CONFIG_BRIDGE_VLAN_FILTERING) += br_vlan.o br_vlan_tunnel.o br_vlan_options.o br_mst.o
 
 bridge-$(CONFIG_NET_SWITCHDEV) += br_switchdev.o
 
diff --git a/net/bridge/br_input.c b/net/bridge/br_input.c
index e0c13fcc50ed..196417859c4a 100644
--- a/net/bridge/br_input.c
+++ b/net/bridge/br_input.c
@@ -78,13 +78,22 @@ int br_handle_frame_finish(struct net *net, struct sock *sk, struct sk_buff *skb
 	u16 vid = 0;
 	u8 state;
 
-	if (!p || p->state == BR_STATE_DISABLED)
+	if (!p)
 		goto drop;
 
 	br = p->br;
+
+	if (br_mst_is_enabled(br)) {
+		state = BR_STATE_FORWARDING;
+	} else {
+		if (p->state == BR_STATE_DISABLED)
+			goto drop;
+
+		state = p->state;
+	}
+
 	brmctx = &p->br->multicast_ctx;
 	pmctx = &p->multicast_ctx;
-	state = p->state;
 	if (!br_allowed_ingress(p->br, nbp_vlan_group_rcu(p), skb, &vid,
 				&state, &vlan))
 		goto out;
@@ -370,9 +379,13 @@ static rx_handler_result_t br_handle_frame(struct sk_buff **pskb)
 		return RX_HANDLER_PASS;
 
 forward:
+	if (br_mst_is_enabled(p->br))
+		goto defer_stp_filtering;
+
 	switch (p->state) {
 	case BR_STATE_FORWARDING:
 	case BR_STATE_LEARNING:
+defer_stp_filtering:
 		if (ether_addr_equal(p->br->dev->dev_addr, dest))
 			skb->pkt_type = PACKET_HOST;
 
diff --git a/net/bridge/br_mst.c b/net/bridge/br_mst.c
new file mode 100644
index 000000000000..ad6e91670fa8
--- /dev/null
+++ b/net/bridge/br_mst.c
@@ -0,0 +1,83 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ *	Bridge Multiple Spanning Tree Support
+ *
+ *	Authors:
+ *	Tobias Waldekranz		<tobias@waldekranz.com>
+ */
+
+#include <linux/kernel.h>
+
+#include "br_private.h"
+
+DEFINE_STATIC_KEY_FALSE(br_mst_used);
+
+void br_mst_vlan_set_state(struct net_bridge_port *p, struct net_bridge_vlan *v,
+			   u8 state)
+{
+	struct net_bridge_vlan_group *vg = nbp_vlan_group(p);
+
+	if (v->state == state)
+		return;
+
+	br_vlan_set_state(v, state);
+
+	if (v->vid == vg->pvid)
+		br_vlan_set_pvid_state(vg, state);
+}
+
+void br_mst_set_state(struct net_bridge_port *p, u16 msti, u8 state)
+{
+	struct net_bridge_vlan_group *vg;
+	struct net_bridge_vlan *v;
+
+	vg = nbp_vlan_group(p);
+	if (!vg)
+		return;
+
+	list_for_each_entry(v, &vg->vlan_list, vlist) {
+		if (v->brvlan->msti != msti)
+			continue;
+
+		br_mst_vlan_set_state(p, v, state);
+	}
+}
+
+void br_mst_vlan_init_state(struct net_bridge_vlan *v)
+{
+	/* VLANs always start out in MSTI 0 (CST) */
+	v->msti = 0;
+
+	if (br_vlan_is_master(v))
+		v->state = BR_STATE_FORWARDING;
+	else
+		v->state = v->port->state;
+}
+
+int br_mst_set_enabled(struct net_bridge *br, unsigned long val)
+{
+	struct net_bridge_vlan_group *vg;
+	struct net_bridge_port *p;
+
+	/* Mode may only be changed when there are no port VLANs. */
+	list_for_each_entry(p, &br->port_list, list) {
+		vg = nbp_vlan_group(p);
+
+		if (vg->num_vlans)
+			return -EBUSY;
+	}
+
+	if (val > 1)
+		return -EINVAL;
+
+	if (!!val == br_opt_get(br, BROPT_MST_ENABLED))
+		return 0;
+
+	if (val)
+		static_branch_enable(&br_mst_used);
+	else
+		static_branch_disable(&br_mst_used);
+
+	br_opt_toggle(br, BROPT_MST_ENABLED, !!val);
+	return 0;
+}
diff --git a/net/bridge/br_netlink.c b/net/bridge/br_netlink.c
index 7d4432ca9a20..a17a0fe25a58 100644
--- a/net/bridge/br_netlink.c
+++ b/net/bridge/br_netlink.c
@@ -1163,6 +1163,7 @@ static const struct nla_policy br_policy[IFLA_BR_MAX + 1] = {
 	[IFLA_BR_MCAST_IGMP_VERSION] = { .type = NLA_U8 },
 	[IFLA_BR_MCAST_MLD_VERSION] = { .type = NLA_U8 },
 	[IFLA_BR_VLAN_STATS_PER_PORT] = { .type = NLA_U8 },
+	[IFLA_BR_MST_ENABLED] = { .type = NLA_U8 },
 	[IFLA_BR_MULTI_BOOLOPT] =
 		NLA_POLICY_EXACT_LEN(sizeof(struct br_boolopt_multi)),
 };
@@ -1255,6 +1256,14 @@ static int br_changelink(struct net_device *brdev, struct nlattr *tb[],
 		if (err)
 			return err;
 	}
+
+	if (data[IFLA_BR_MST_ENABLED]) {
+		__u8 mst = nla_get_u8(data[IFLA_BR_MST_ENABLED]);
+
+		err = br_mst_set_enabled(br, mst);
+		if (err)
+			return err;
+	}
 #endif
 
 	if (data[IFLA_BR_GROUP_FWD_MASK]) {
@@ -1475,6 +1484,7 @@ static size_t br_get_size(const struct net_device *brdev)
 	       nla_total_size(sizeof(u16)) +    /* IFLA_BR_VLAN_DEFAULT_PVID */
 	       nla_total_size(sizeof(u8)) +     /* IFLA_BR_VLAN_STATS_ENABLED */
 	       nla_total_size(sizeof(u8)) +	/* IFLA_BR_VLAN_STATS_PER_PORT */
+	       nla_total_size(sizeof(u8)) +	/* IFLA_BR_MST_ENABLED */
 #endif
 	       nla_total_size(sizeof(u16)) +    /* IFLA_BR_GROUP_FWD_MASK */
 	       nla_total_size(sizeof(struct ifla_bridge_id)) +   /* IFLA_BR_ROOT_ID */
@@ -1572,7 +1582,9 @@ static int br_fill_info(struct sk_buff *skb, const struct net_device *brdev)
 	    nla_put_u8(skb, IFLA_BR_VLAN_STATS_ENABLED,
 		       br_opt_get(br, BROPT_VLAN_STATS_ENABLED)) ||
 	    nla_put_u8(skb, IFLA_BR_VLAN_STATS_PER_PORT,
-		       br_opt_get(br, BROPT_VLAN_STATS_PER_PORT)))
+		       br_opt_get(br, BROPT_VLAN_STATS_PER_PORT)) ||
+	    nla_put_u8(skb, IFLA_BR_MST_ENABLED,
+		       br_opt_get(br, BROPT_MST_ENABLED)))
 		return -EMSGSIZE;
 #endif
 #ifdef CONFIG_BRIDGE_IGMP_SNOOPING
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 48bc61ebc211..af50ad036b06 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -178,6 +178,7 @@ enum {
  * @br_mcast_ctx: if MASTER flag set, this is the global vlan multicast context
  * @port_mcast_ctx: if MASTER flag unset, this is the per-port/vlan multicast
  *                  context
+ * @msti: if MASTER flag set, this holds the VLANs MST instance
  * @vlist: sorted list of VLAN entries
  * @rcu: used for entry destruction
  *
@@ -210,6 +211,8 @@ struct net_bridge_vlan {
 		struct net_bridge_mcast_port	port_mcast_ctx;
 	};
 
+	u16				msti;
+
 	struct list_head		vlist;
 
 	struct rcu_head			rcu;
@@ -445,6 +448,7 @@ enum net_bridge_opts {
 	BROPT_NO_LL_LEARN,
 	BROPT_VLAN_BRIDGE_BINDING,
 	BROPT_MCAST_VLAN_SNOOPING_ENABLED,
+	BROPT_MST_ENABLED,
 };
 
 struct net_bridge {
@@ -1765,6 +1769,28 @@ static inline bool br_vlan_state_allowed(u8 state, bool learn_allow)
 }
 #endif
 
+/* br_mst.c */
+#ifdef CONFIG_BRIDGE_VLAN_FILTERING
+DECLARE_STATIC_KEY_FALSE(br_mst_used);
+static inline bool br_mst_is_enabled(struct net_bridge *br)
+{
+	return static_branch_unlikely(&br_mst_used) &&
+		br_opt_get(br, BROPT_MST_ENABLED);
+}
+
+void br_mst_set_state(struct net_bridge_port *p, u16 msti, u8 state);
+void br_mst_vlan_init_state(struct net_bridge_vlan *v);
+int br_mst_set_enabled(struct net_bridge *br, unsigned long val);
+#else
+static inline bool br_mst_is_enabled(struct net_bridge *br)
+{
+	return false;
+}
+
+static inline void br_mst_set_state(struct net_bridge_port *p,
+				    u16 msti, u8 state) {}
+#endif
+
 struct nf_br_ops {
 	int (*br_dev_xmit_hook)(struct sk_buff *skb);
 };
diff --git a/net/bridge/br_stp.c b/net/bridge/br_stp.c
index 1d80f34a139c..82a97a021a57 100644
--- a/net/bridge/br_stp.c
+++ b/net/bridge/br_stp.c
@@ -43,6 +43,9 @@ void br_set_state(struct net_bridge_port *p, unsigned int state)
 		return;
 
 	p->state = state;
+	if (br_opt_get(p->br, BROPT_MST_ENABLED))
+		br_mst_set_state(p, 0, state);
+
 	err = switchdev_port_attr_set(p->dev, &attr, NULL);
 	if (err && err != -EOPNOTSUPP)
 		br_warn(p->br, "error setting offload STP state on port %u(%s)\n",
diff --git a/net/bridge/br_vlan.c b/net/bridge/br_vlan.c
index 7557e90b60e1..0f5e75ccac79 100644
--- a/net/bridge/br_vlan.c
+++ b/net/bridge/br_vlan.c
@@ -226,6 +226,24 @@ static void nbp_vlan_rcu_free(struct rcu_head *rcu)
 	kfree(v);
 }
 
+static void br_vlan_init_state(struct net_bridge_vlan *v)
+{
+	struct net_bridge *br;
+
+	if (br_vlan_is_master(v))
+		br = v->br;
+	else
+		br = v->port->br;
+
+	if (br_opt_get(br, BROPT_MST_ENABLED)) {
+		br_mst_vlan_init_state(v);
+		return;
+	}
+
+	v->state = BR_STATE_FORWARDING;
+	v->msti = 0;
+}
+
 /* This is the shared VLAN add function which works for both ports and bridge
  * devices. There are four possible calls to this function in terms of the
  * vlan entry type:
@@ -322,7 +340,7 @@ static int __vlan_add(struct net_bridge_vlan *v, u16 flags,
 	}
 
 	/* set the state before publishing */
-	v->state = BR_STATE_FORWARDING;
+	br_vlan_init_state(v);
 
 	err = rhashtable_lookup_insert_fast(&vg->vlan_hash, &v->vnode,
 					    br_vlan_rht_params);
diff --git a/net/bridge/br_vlan_options.c b/net/bridge/br_vlan_options.c
index a6382973b3e7..09112b56e79c 100644
--- a/net/bridge/br_vlan_options.c
+++ b/net/bridge/br_vlan_options.c
@@ -99,6 +99,11 @@ static int br_vlan_modify_state(struct net_bridge_vlan_group *vg,
 		return -EBUSY;
 	}
 
+	if (br_opt_get(br, BROPT_MST_ENABLED)) {
+		NL_SET_ERR_MSG_MOD(extack, "Can't modify vlan state directly when MST is enabled");
+		return -EBUSY;
+	}
+
 	if (v->state == state)
 		return 0;
 
-- 
2.25.1

