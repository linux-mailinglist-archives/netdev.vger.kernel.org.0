Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E41214C8BA3
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 13:31:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234677AbiCAMcB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 07:32:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231437AbiCAMb7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 07:31:59 -0500
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FB576FA0A
        for <netdev@vger.kernel.org>; Tue,  1 Mar 2022 04:31:18 -0800 (PST)
Received: by mail-lf1-x12d.google.com with SMTP id y24so26607696lfg.1
        for <netdev@vger.kernel.org>; Tue, 01 Mar 2022 04:31:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DxnqJlLtpzlWasTuiQqP9yvuDNBl8IloHud9mhZtYmY=;
        b=lLFA5O8Aqvt9gV0l0JhZimNb5H5Z/DwGYPNRal9kn0p4hmQXErilDmOL7pZsMLymK+
         CNFtkkln5x0O6SJHSfVMiCO6Ush6GeI4LPmNJIDt59s4kuk1Qfdf+pTDiSahWqv5BMla
         mCYcIcRy4zUd7BZRdczfWL3AeC5nWdX38k04kfa7D8YDgrRSPvLG2h4+ikQt8v4UmpYK
         d0p0EHWmyO1YPb2/ywut7BPldG1lYPKKI7wVENhHOoFcDVM7WkiIUqyWIrTZfZDayUF5
         tYUb2iKNfBMpUMsf0zlhMqUqT3SysoVK5cNehzrCqZAxEfjfBPNGtj9KBCYjI3u57G6J
         YDvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DxnqJlLtpzlWasTuiQqP9yvuDNBl8IloHud9mhZtYmY=;
        b=6hWZrYzIKG7/EF/Tfo3NZGCkFET7QrGXNHca4nLU9ERBrtggeLETe7Y1ZOZ31Kazyy
         RKdUc50nRdAQNMlFXDr8YegBT9fn/rIIoJadRrbxCiHaKs1VafwDXJxi1CAgP72X/+9V
         TibRcDkPyo92YdQR2pU9JEkwGQ/yZEtKOqDEpX7HAwY6SZHN+ByQINvrLoQ38bA6C7qw
         IBSieiifeUCLihzL6kmMYXzZYjBYhJ8vetPFM2DS/hxNFG1Q2drpEIgnKIeegM1xFs6M
         4AE54K2FxyPsSCBnDkFOuEluiuoSVW738j8fJ0YvbgVzT2iv4afEBz8GdKFp+3ZxQUtJ
         v24w==
X-Gm-Message-State: AOAM533ZuaGB2CcJT2v7nQSohFeyWOiuUT2fz1QzXFxhy8k31VH89sqe
        o/Hi2vANYuwRQ1C6X0by6Rg0wGv6jRz8TEmZlWg=
X-Google-Smtp-Source: ABdhPJzsNbMYs699nk6/bnMr6dRwcRLdwkX7te5vrTZLafCruJqy5f0GU5AU6aT4vP5r8QaNG+gUYQ==
X-Received: by 2002:a05:6512:31d0:b0:443:aca9:ded1 with SMTP id j16-20020a05651231d000b00443aca9ded1mr12851440lfe.112.1646137876121;
        Tue, 01 Mar 2022 04:31:16 -0800 (PST)
Received: from wse-c0089.westermo.com (h-98-128-237-157.A259.priv.bahnhof.se. [98.128.237.157])
        by smtp.gmail.com with ESMTPSA id i8-20020a0565123e0800b0044312b4112dsm1470459lfv.52.2022.03.01.04.31.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Mar 2022 04:31:15 -0800 (PST)
From:   Mattias Forsblad <mattias.forsblad@gmail.com>
X-Google-Original-From: Mattias Forsblad <mattias.forsblad+netdev@gmail.com>
To:     netdev@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Mattias Forsblad <mattias.forsblad+netdev@gmail.com>
Subject: [PATCH 1/3] net: bridge: Implement bridge flag local_receive
Date:   Tue,  1 Mar 2022 13:31:02 +0100
Message-Id: <20220301123104.226731-2-mattias.forsblad+netdev@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220301123104.226731-1-mattias.forsblad+netdev@gmail.com>
References: <20220301123104.226731-1-mattias.forsblad+netdev@gmail.com>
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

This patch implements the bridge flag local_receive. When this
flag is cleared packets received on bridge ports will not be forwarded up.
This makes is possible to only forward traffic between the port members
of the bridge.

Signed-off-by: Mattias Forsblad <mattias.forsblad+netdev@gmail.com>
---
 include/linux/if_bridge.h      |  6 ++++++
 include/net/switchdev.h        |  2 ++
 include/uapi/linux/if_bridge.h |  1 +
 include/uapi/linux/if_link.h   |  1 +
 net/bridge/br.c                | 18 ++++++++++++++++++
 net/bridge/br_device.c         |  1 +
 net/bridge/br_input.c          |  3 +++
 net/bridge/br_ioctl.c          |  1 +
 net/bridge/br_netlink.c        | 14 +++++++++++++-
 net/bridge/br_private.h        |  2 ++
 net/bridge/br_sysfs_br.c       | 23 +++++++++++++++++++++++
 net/bridge/br_vlan.c           |  8 ++++++++
 12 files changed, 79 insertions(+), 1 deletion(-)

diff --git a/include/linux/if_bridge.h b/include/linux/if_bridge.h
index 3aae023a9353..e6b77d18c1d2 100644
--- a/include/linux/if_bridge.h
+++ b/include/linux/if_bridge.h
@@ -157,6 +157,7 @@ static inline int br_vlan_get_info_rcu(const struct net_device *dev, u16 vid,
 struct net_device *br_fdb_find_port(const struct net_device *br_dev,
 				    const unsigned char *addr,
 				    __u16 vid);
+bool br_local_receive_enabled(const struct net_device *dev);
 void br_fdb_clear_offload(const struct net_device *dev, u16 vid);
 bool br_port_flag_is_set(const struct net_device *dev, unsigned long flag);
 u8 br_port_get_stp_state(const struct net_device *dev);
@@ -170,6 +171,11 @@ br_fdb_find_port(const struct net_device *br_dev,
 	return NULL;
 }
 
+static inline bool br_local_receive_enabled(const struct net_device *dev)
+{
+	return true;
+}
+
 static inline void br_fdb_clear_offload(const struct net_device *dev, u16 vid)
 {
 }
diff --git a/include/net/switchdev.h b/include/net/switchdev.h
index 3e424d40fae3..aec5c1f9b5c7 100644
--- a/include/net/switchdev.h
+++ b/include/net/switchdev.h
@@ -25,6 +25,7 @@ enum switchdev_attr_id {
 	SWITCHDEV_ATTR_ID_BRIDGE_AGEING_TIME,
 	SWITCHDEV_ATTR_ID_BRIDGE_VLAN_FILTERING,
 	SWITCHDEV_ATTR_ID_BRIDGE_VLAN_PROTOCOL,
+	SWITCHDEV_ATTR_ID_BRIDGE_LOCAL_RECEIVE,
 	SWITCHDEV_ATTR_ID_BRIDGE_MC_DISABLED,
 	SWITCHDEV_ATTR_ID_BRIDGE_MROUTER,
 	SWITCHDEV_ATTR_ID_MRP_PORT_ROLE,
@@ -50,6 +51,7 @@ struct switchdev_attr {
 		u16 vlan_protocol;			/* BRIDGE_VLAN_PROTOCOL */
 		bool mc_disabled;			/* MC_DISABLED */
 		u8 mrp_port_role;			/* MRP_PORT_ROLE */
+		bool local_receive;			/* BRIDGE_LOCAL_RECEIVE */
 	} u;
 };
 
diff --git a/include/uapi/linux/if_bridge.h b/include/uapi/linux/if_bridge.h
index 2711c3522010..fc889b5ccd69 100644
--- a/include/uapi/linux/if_bridge.h
+++ b/include/uapi/linux/if_bridge.h
@@ -72,6 +72,7 @@ struct __bridge_info {
 	__u32 tcn_timer_value;
 	__u32 topology_change_timer_value;
 	__u32 gc_timer_value;
+	__u8 local_receive;
 };
 
 struct __port_info {
diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index e315e53125f4..bb7c25e1c89c 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -482,6 +482,7 @@ enum {
 	IFLA_BR_VLAN_STATS_PER_PORT,
 	IFLA_BR_MULTI_BOOLOPT,
 	IFLA_BR_MCAST_QUERIER_STATE,
+	IFLA_BR_LOCAL_RECEIVE,
 	__IFLA_BR_MAX,
 };
 
diff --git a/net/bridge/br.c b/net/bridge/br.c
index b1dea3febeea..ff7eb4f269ec 100644
--- a/net/bridge/br.c
+++ b/net/bridge/br.c
@@ -325,6 +325,24 @@ void br_boolopt_multi_get(const struct net_bridge *br,
 	bm->optmask = GENMASK((BR_BOOLOPT_MAX - 1), 0);
 }
 
+int br_local_receive_change(struct net_bridge *p,
+			    bool local_receive)
+{
+	struct switchdev_attr attr = {
+		.orig_dev = p->dev,
+		.id = SWITCHDEV_ATTR_ID_BRIDGE_LOCAL_RECEIVE,
+		.flags = SWITCHDEV_F_DEFER,
+		.u.local_receive = local_receive,
+	};
+	int ret;
+
+	ret = switchdev_port_attr_set(p->dev, &attr, NULL);
+	if (!ret)
+		br_opt_toggle(p, BROPT_LOCAL_RECEIVE, local_receive);
+
+	return ret;
+}
+
 /* private bridge options, controlled by the kernel */
 void br_opt_toggle(struct net_bridge *br, enum net_bridge_opts opt, bool on)
 {
diff --git a/net/bridge/br_device.c b/net/bridge/br_device.c
index 8d6bab244c4a..7cd9c5880d18 100644
--- a/net/bridge/br_device.c
+++ b/net/bridge/br_device.c
@@ -524,6 +524,7 @@ void br_dev_setup(struct net_device *dev)
 	br->bridge_hello_time = br->hello_time = 2 * HZ;
 	br->bridge_forward_delay = br->forward_delay = 15 * HZ;
 	br->bridge_ageing_time = br->ageing_time = BR_DEFAULT_AGEING_TIME;
+	br_opt_toggle(br, BROPT_LOCAL_RECEIVE, true);
 	dev->max_mtu = ETH_MAX_MTU;
 
 	br_netfilter_rtable_init(br);
diff --git a/net/bridge/br_input.c b/net/bridge/br_input.c
index e0c13fcc50ed..5864b61157d3 100644
--- a/net/bridge/br_input.c
+++ b/net/bridge/br_input.c
@@ -163,6 +163,9 @@ int br_handle_frame_finish(struct net *net, struct sock *sk, struct sk_buff *skb
 		break;
 	}
 
+	if (local_rcv && !br_opt_get(br, BROPT_LOCAL_RECEIVE))
+		local_rcv = false;
+
 	if (dst) {
 		unsigned long now = jiffies;
 
diff --git a/net/bridge/br_ioctl.c b/net/bridge/br_ioctl.c
index f213ed108361..abe538129290 100644
--- a/net/bridge/br_ioctl.c
+++ b/net/bridge/br_ioctl.c
@@ -177,6 +177,7 @@ int br_dev_siocdevprivate(struct net_device *dev, struct ifreq *rq,
 		b.topology_change = br->topology_change;
 		b.topology_change_detected = br->topology_change_detected;
 		b.root_port = br->root_port;
+		b.local_receive = br_opt_get(br, BROPT_LOCAL_RECEIVE) ? 1 : 0;
 
 		b.stp_enabled = (br->stp_enabled != BR_NO_STP);
 		b.ageing_time = jiffies_to_clock_t(br->ageing_time);
diff --git a/net/bridge/br_netlink.c b/net/bridge/br_netlink.c
index 7d4432ca9a20..5e7f99950195 100644
--- a/net/bridge/br_netlink.c
+++ b/net/bridge/br_netlink.c
@@ -1163,6 +1163,7 @@ static const struct nla_policy br_policy[IFLA_BR_MAX + 1] = {
 	[IFLA_BR_MCAST_IGMP_VERSION] = { .type = NLA_U8 },
 	[IFLA_BR_MCAST_MLD_VERSION] = { .type = NLA_U8 },
 	[IFLA_BR_VLAN_STATS_PER_PORT] = { .type = NLA_U8 },
+	[IFLA_BR_LOCAL_RECEIVE] = { .type = NLA_U8 },
 	[IFLA_BR_MULTI_BOOLOPT] =
 		NLA_POLICY_EXACT_LEN(sizeof(struct br_boolopt_multi)),
 };
@@ -1434,6 +1435,14 @@ static int br_changelink(struct net_device *brdev, struct nlattr *tb[],
 			return err;
 	}
 
+	if (data[IFLA_BR_LOCAL_RECEIVE]) {
+		u8 val = nla_get_u8(data[IFLA_BR_LOCAL_RECEIVE]);
+
+		err = br_local_receive_change(br, !!val);
+		if (err)
+			return err;
+	}
+
 	return 0;
 }
 
@@ -1514,6 +1523,7 @@ static size_t br_get_size(const struct net_device *brdev)
 	       nla_total_size(sizeof(u8)) +     /* IFLA_BR_NF_CALL_ARPTABLES */
 #endif
 	       nla_total_size(sizeof(struct br_boolopt_multi)) + /* IFLA_BR_MULTI_BOOLOPT */
+	       nla_total_size(sizeof(u8)) +     /* IFLA_BR_LOCAL_RECEIVE */
 	       0;
 }
 
@@ -1527,6 +1537,7 @@ static int br_fill_info(struct sk_buff *skb, const struct net_device *brdev)
 	u32 stp_enabled = br->stp_enabled;
 	u16 priority = (br->bridge_id.prio[0] << 8) | br->bridge_id.prio[1];
 	u8 vlan_enabled = br_vlan_enabled(br->dev);
+	u8 local_receive = br_opt_get(br, BROPT_LOCAL_RECEIVE) ? 1 : 0;
 	struct br_boolopt_multi bm;
 	u64 clockval;
 
@@ -1563,7 +1574,8 @@ static int br_fill_info(struct sk_buff *skb, const struct net_device *brdev)
 	    nla_put_u8(skb, IFLA_BR_TOPOLOGY_CHANGE_DETECTED,
 		       br->topology_change_detected) ||
 	    nla_put(skb, IFLA_BR_GROUP_ADDR, ETH_ALEN, br->group_addr) ||
-	    nla_put(skb, IFLA_BR_MULTI_BOOLOPT, sizeof(bm), &bm))
+	    nla_put(skb, IFLA_BR_MULTI_BOOLOPT, sizeof(bm), &bm) ||
+	    nla_put_u8(skb, IFLA_BR_LOCAL_RECEIVE, local_receive))
 		return -EMSGSIZE;
 
 #ifdef CONFIG_BRIDGE_VLAN_FILTERING
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 48bc61ebc211..01fa5426094b 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -445,6 +445,7 @@ enum net_bridge_opts {
 	BROPT_NO_LL_LEARN,
 	BROPT_VLAN_BRIDGE_BINDING,
 	BROPT_MCAST_VLAN_SNOOPING_ENABLED,
+	BROPT_LOCAL_RECEIVE,
 };
 
 struct net_bridge {
@@ -720,6 +721,7 @@ int br_boolopt_multi_toggle(struct net_bridge *br,
 void br_boolopt_multi_get(const struct net_bridge *br,
 			  struct br_boolopt_multi *bm);
 void br_opt_toggle(struct net_bridge *br, enum net_bridge_opts opt, bool on);
+int br_local_receive_change(struct net_bridge *p, bool local_receive);
 
 /* br_device.c */
 void br_dev_setup(struct net_device *dev);
diff --git a/net/bridge/br_sysfs_br.c b/net/bridge/br_sysfs_br.c
index 3f7ca88c2aa3..9af0c2ba929c 100644
--- a/net/bridge/br_sysfs_br.c
+++ b/net/bridge/br_sysfs_br.c
@@ -84,6 +84,28 @@ static ssize_t forward_delay_store(struct device *d,
 }
 static DEVICE_ATTR_RW(forward_delay);
 
+static ssize_t local_receive_show(struct device *d,
+				  struct device_attribute *attr, char *buf)
+{
+	struct net_bridge *br = to_bridge(d);
+
+	return sprintf(buf, "%u\n", br_opt_get(br, BROPT_LOCAL_RECEIVE));
+}
+
+static int set_local_receive(struct net_bridge *br, unsigned long val,
+			     struct netlink_ext_ack *extack)
+{
+	return br_local_receive_change(br, !!val);
+}
+
+static ssize_t local_receive_store(struct device *d,
+				   struct device_attribute *attr,
+				   const char *buf, size_t len)
+{
+	return store_bridge_parm(d, buf, len, set_local_receive);
+}
+static DEVICE_ATTR_RW(local_receive);
+
 static ssize_t hello_time_show(struct device *d, struct device_attribute *attr,
 			       char *buf)
 {
@@ -950,6 +972,7 @@ static struct attribute *bridge_attrs[] = {
 	&dev_attr_group_addr.attr,
 	&dev_attr_flush.attr,
 	&dev_attr_no_linklocal_learn.attr,
+	&dev_attr_local_receive.attr,
 #ifdef CONFIG_BRIDGE_IGMP_SNOOPING
 	&dev_attr_multicast_router.attr,
 	&dev_attr_multicast_snooping.attr,
diff --git a/net/bridge/br_vlan.c b/net/bridge/br_vlan.c
index 7557e90b60e1..57dd14d5e360 100644
--- a/net/bridge/br_vlan.c
+++ b/net/bridge/br_vlan.c
@@ -905,6 +905,14 @@ bool br_vlan_enabled(const struct net_device *dev)
 }
 EXPORT_SYMBOL_GPL(br_vlan_enabled);
 
+bool br_local_receive_enabled(const struct net_device *dev)
+{
+	struct net_bridge *br = netdev_priv(dev);
+
+	return br_opt_get(br, BROPT_LOCAL_RECEIVE);
+}
+EXPORT_SYMBOL_GPL(br_local_receive_enabled);
+
 int br_vlan_get_proto(const struct net_device *dev, u16 *p_proto)
 {
 	struct net_bridge *br = netdev_priv(dev);
-- 
2.25.1

