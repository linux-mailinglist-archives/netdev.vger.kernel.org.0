Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8C2B4DB478
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 16:10:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236416AbiCPPKl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 11:10:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357010AbiCPPK1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 11:10:27 -0400
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7CF9D52
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 08:09:11 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id h14so4220645lfk.11
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 08:09:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:organization:content-transfer-encoding;
        bh=t40PWFqgAo5RS94mEN7WbYWPCe/kxbSlHoXRNDvVz+I=;
        b=UFnJRqo/xyujO1wbOYo3Svuv/X/jWaVIa7AuoM8Cz6zfl7C00i4q1UgIn3UHoUSRgH
         LdMJFXMah/4L+f1VFSnuOl58zKxX0+hcAo52xjYkXp4Wm6XI0Y8pcHUflwO9+mKFxHq6
         NaqsrE66QK3x9gFwka80nwKgIwHcqWxMIDvlkydYSWYVVcwc/Hf2wAUC9I1ovIT46VhK
         RNNOMvh5uwFLyKgDes8sQ93zuk3fjgT2Q1+XzmGKwIAa1yig+sjkkgFnMhIzQ5hAmjXq
         rmcdtxvz4unf3URe3UWRG9ovfWOkKmDLec5njnJG24GUpRj8w7zRMU4GHfMc5/K9ykSR
         56Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:organization:content-transfer-encoding;
        bh=t40PWFqgAo5RS94mEN7WbYWPCe/kxbSlHoXRNDvVz+I=;
        b=Db5Q9gQLUhpLZz8CROuUnJUygxmuHC73DTOHyPMqi0xqSxGzpUgEHUoBKCM4o5g3LW
         N5/D70Uak34b0kMLoEN0uG+qe/2QKwP7idyZCQoCg+2s9VPRKC6zZ1m/dcPye/Aluo8O
         OZ48naxM//uuoHXfX6lChT3I3DZD9DEejb+J9UD3FsdK7Od9BZC3qjyWVNkeQtNKWNLa
         6zgyyAqn26nkk+tAt+Fych2TZp6AjPPM9GzO1zJEEtqC53QDoRWBls1ObzfSK+Ys3R5O
         YqBqZLLZ7FwA60NyKzreN46nKT0D8lq2ol1wHibXWYDO/prSWwl6owfEXgwCoh4Ta8nu
         e/ow==
X-Gm-Message-State: AOAM5315JHavpTICh+8Jfu+ok6O5H6wQvD5kEUAV1f/ZbJTaKADkVTjQ
        NZjReUKdhKYTARIY2rZUfvvc+Q==
X-Google-Smtp-Source: ABdhPJxX08RUarSGHOAi8lHi6cOj4jpK7p++yP0RGj39eIhChWIW+Ofk89Gxn+8V3qUNUsVkBg3TUw==
X-Received: by 2002:a05:6512:1084:b0:448:4fb8:e59a with SMTP id j4-20020a056512108400b004484fb8e59amr89617lfg.408.1647443349912;
        Wed, 16 Mar 2022 08:09:09 -0700 (PDT)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id d2-20020a194f02000000b00448b915e2d3sm176048lfb.99.2022.03.16.08.09.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Mar 2022 08:09:09 -0700 (PDT)
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
        Ido Schimmel <idosch@nvidia.com>,
        Matt Johnston <matt@codeconstruct.com.au>,
        Cooper Lees <me@cooperlees.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bridge@lists.linux-foundation.org
Subject: [PATCH v5 net-next 03/15] net: bridge: mst: Support setting and reporting MST port states
Date:   Wed, 16 Mar 2022 16:08:45 +0100
Message-Id: <20220316150857.2442916-4-tobias@waldekranz.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220316150857.2442916-1-tobias@waldekranz.com>
References: <20220316150857.2442916-1-tobias@waldekranz.com>
MIME-Version: 1.0
Organization: Westermo
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make it possible to change the port state in a given MSTI by extending
the bridge port netlink interface (RTM_SETLINK on PF_BRIDGE).The
proposed iproute2 interface would be:

    bridge mst set dev <PORT> msti <MSTI> state <STATE>

Current states in all applicable MSTIs can also be dumped via a
corresponding RTM_GETLINK. The proposed iproute interface looks like
this:

$ bridge mst
port              msti
vb1               0
		    state forwarding
		  100
		    state disabled
vb2               0
		    state forwarding
		  100
		    state forwarding

The preexisting per-VLAN states are still valid in the MST
mode (although they are read-only), and can be queried as usual if one
is interested in knowing a particular VLAN's state without having to
care about the VID to MSTI mapping (in this example VLAN 20 and 30 are
bound to MSTI 100):

$ bridge -d vlan
port              vlan-id
vb1               10
		    state forwarding mcast_router 1
		  20
		    state disabled mcast_router 1
		  30
		    state disabled mcast_router 1
		  40
		    state forwarding mcast_router 1
vb2               10
		    state forwarding mcast_router 1
		  20
		    state forwarding mcast_router 1
		  30
		    state forwarding mcast_router 1
		  40
		    state forwarding mcast_router 1

Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
---
 include/uapi/linux/if_bridge.h |  16 +++++
 include/uapi/linux/rtnetlink.h |   1 +
 net/bridge/br_mst.c            | 126 +++++++++++++++++++++++++++++++++
 net/bridge/br_netlink.c        |  44 +++++++++++-
 net/bridge/br_private.h        |  23 ++++++
 5 files changed, 209 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/if_bridge.h b/include/uapi/linux/if_bridge.h
index f60244b747ae..a86a7e7b811f 100644
--- a/include/uapi/linux/if_bridge.h
+++ b/include/uapi/linux/if_bridge.h
@@ -122,6 +122,7 @@ enum {
 	IFLA_BRIDGE_VLAN_TUNNEL_INFO,
 	IFLA_BRIDGE_MRP,
 	IFLA_BRIDGE_CFM,
+	IFLA_BRIDGE_MST,
 	__IFLA_BRIDGE_MAX,
 };
 #define IFLA_BRIDGE_MAX (__IFLA_BRIDGE_MAX - 1)
@@ -453,6 +454,21 @@ enum {
 
 #define IFLA_BRIDGE_CFM_CC_PEER_STATUS_MAX (__IFLA_BRIDGE_CFM_CC_PEER_STATUS_MAX - 1)
 
+enum {
+	IFLA_BRIDGE_MST_UNSPEC,
+	IFLA_BRIDGE_MST_ENTRY,
+	__IFLA_BRIDGE_MST_MAX,
+};
+#define IFLA_BRIDGE_MST_MAX (__IFLA_BRIDGE_MST_MAX - 1)
+
+enum {
+	IFLA_BRIDGE_MST_ENTRY_UNSPEC,
+	IFLA_BRIDGE_MST_ENTRY_MSTI,
+	IFLA_BRIDGE_MST_ENTRY_STATE,
+	__IFLA_BRIDGE_MST_ENTRY_MAX,
+};
+#define IFLA_BRIDGE_MST_ENTRY_MAX (__IFLA_BRIDGE_MST_ENTRY_MAX - 1)
+
 struct bridge_stp_xstats {
 	__u64 transition_blk;
 	__u64 transition_fwd;
diff --git a/include/uapi/linux/rtnetlink.h b/include/uapi/linux/rtnetlink.h
index 51530aade46e..83849a37db5b 100644
--- a/include/uapi/linux/rtnetlink.h
+++ b/include/uapi/linux/rtnetlink.h
@@ -817,6 +817,7 @@ enum {
 #define RTEXT_FILTER_MRP	(1 << 4)
 #define RTEXT_FILTER_CFM_CONFIG	(1 << 5)
 #define RTEXT_FILTER_CFM_STATUS	(1 << 6)
+#define RTEXT_FILTER_MST	(1 << 7)
 
 /* End of information exported to user level */
 
diff --git a/net/bridge/br_mst.c b/net/bridge/br_mst.c
index d7a7b5d7ddb3..5c1831c73fc2 100644
--- a/net/bridge/br_mst.c
+++ b/net/bridge/br_mst.c
@@ -127,3 +127,129 @@ int br_mst_set_enabled(struct net_bridge *br, bool on,
 	br_opt_toggle(br, BROPT_MST_ENABLED, on);
 	return 0;
 }
+
+size_t br_mst_info_size(const struct net_bridge_vlan_group *vg)
+{
+	DECLARE_BITMAP(seen, VLAN_N_VID) = { 0 };
+	const struct net_bridge_vlan *v;
+	size_t sz;
+
+	/* IFLA_BRIDGE_MST */
+	sz = nla_total_size(0);
+
+	list_for_each_entry_rcu(v, &vg->vlan_list, vlist) {
+		if (test_bit(v->brvlan->msti, seen))
+			continue;
+
+		/* IFLA_BRIDGE_MST_ENTRY */
+		sz += nla_total_size(0) +
+			/* IFLA_BRIDGE_MST_ENTRY_MSTI */
+			nla_total_size(sizeof(u16)) +
+			/* IFLA_BRIDGE_MST_ENTRY_STATE */
+			nla_total_size(sizeof(u8));
+
+		__set_bit(v->brvlan->msti, seen);
+	}
+
+	return sz;
+}
+
+int br_mst_fill_info(struct sk_buff *skb,
+		     const struct net_bridge_vlan_group *vg)
+{
+	DECLARE_BITMAP(seen, VLAN_N_VID) = { 0 };
+	const struct net_bridge_vlan *v;
+	struct nlattr *nest;
+	int err = 0;
+
+	list_for_each_entry(v, &vg->vlan_list, vlist) {
+		if (test_bit(v->brvlan->msti, seen))
+			continue;
+
+		nest = nla_nest_start_noflag(skb, IFLA_BRIDGE_MST_ENTRY);
+		if (!nest ||
+		    nla_put_u16(skb, IFLA_BRIDGE_MST_ENTRY_MSTI, v->brvlan->msti) ||
+		    nla_put_u8(skb, IFLA_BRIDGE_MST_ENTRY_STATE, v->state)) {
+			err = -EMSGSIZE;
+			break;
+		}
+		nla_nest_end(skb, nest);
+
+		__set_bit(v->brvlan->msti, seen);
+	}
+
+	return err;
+}
+
+static const struct nla_policy br_mst_nl_policy[IFLA_BRIDGE_MST_ENTRY_MAX + 1] = {
+	[IFLA_BRIDGE_MST_ENTRY_MSTI] = NLA_POLICY_RANGE(NLA_U16,
+						   1, /* 0 reserved for CST */
+						   VLAN_N_VID - 1),
+	[IFLA_BRIDGE_MST_ENTRY_STATE] = NLA_POLICY_RANGE(NLA_U8,
+						    BR_STATE_DISABLED,
+						    BR_STATE_BLOCKING),
+};
+
+static int br_mst_process_one(struct net_bridge_port *p,
+			      const struct nlattr *attr,
+			      struct netlink_ext_ack *extack)
+{
+	struct nlattr *tb[IFLA_BRIDGE_MST_ENTRY_MAX + 1];
+	u16 msti;
+	u8 state;
+	int err;
+
+	err = nla_parse_nested(tb, IFLA_BRIDGE_MST_ENTRY_MAX, attr,
+			       br_mst_nl_policy, extack);
+	if (err)
+		return err;
+
+	if (!tb[IFLA_BRIDGE_MST_ENTRY_MSTI]) {
+		NL_SET_ERR_MSG_MOD(extack, "MSTI not specified");
+		return -EINVAL;
+	}
+
+	if (!tb[IFLA_BRIDGE_MST_ENTRY_STATE]) {
+		NL_SET_ERR_MSG_MOD(extack, "State not specified");
+		return -EINVAL;
+	}
+
+	msti = nla_get_u16(tb[IFLA_BRIDGE_MST_ENTRY_MSTI]);
+	state = nla_get_u8(tb[IFLA_BRIDGE_MST_ENTRY_STATE]);
+
+	return br_mst_set_state(p, msti, state, extack);
+}
+
+int br_mst_process(struct net_bridge_port *p, const struct nlattr *mst_attr,
+		   struct netlink_ext_ack *extack)
+{
+	struct nlattr *attr;
+	int err, msts = 0;
+	int rem;
+
+	if (!br_opt_get(p->br, BROPT_MST_ENABLED)) {
+		NL_SET_ERR_MSG_MOD(extack, "Can't modify MST state when MST is disabled");
+		return -EBUSY;
+	}
+
+	nla_for_each_nested(attr, mst_attr, rem) {
+		switch (nla_type(attr)) {
+		case IFLA_BRIDGE_MST_ENTRY:
+			err = br_mst_process_one(p, attr, extack);
+			break;
+		default:
+			continue;
+		}
+
+		msts++;
+		if (err)
+			break;
+	}
+
+	if (!msts) {
+		NL_SET_ERR_MSG_MOD(extack, "Found no MST entries to process");
+		err = -EINVAL;
+	}
+
+	return err;
+}
diff --git a/net/bridge/br_netlink.c b/net/bridge/br_netlink.c
index 7d4432ca9a20..a8d90fa8621e 100644
--- a/net/bridge/br_netlink.c
+++ b/net/bridge/br_netlink.c
@@ -119,6 +119,9 @@ static size_t br_get_link_af_size_filtered(const struct net_device *dev,
 	/* Each VLAN is returned in bridge_vlan_info along with flags */
 	vinfo_sz += num_vlan_infos * nla_total_size(sizeof(struct bridge_vlan_info));
 
+	if (filter_mask & RTEXT_FILTER_MST)
+		vinfo_sz += br_mst_info_size(vg);
+
 	if (!(filter_mask & RTEXT_FILTER_CFM_STATUS))
 		return vinfo_sz;
 
@@ -485,7 +488,8 @@ static int br_fill_ifinfo(struct sk_buff *skb,
 			   RTEXT_FILTER_BRVLAN_COMPRESSED |
 			   RTEXT_FILTER_MRP |
 			   RTEXT_FILTER_CFM_CONFIG |
-			   RTEXT_FILTER_CFM_STATUS)) {
+			   RTEXT_FILTER_CFM_STATUS |
+			   RTEXT_FILTER_MST)) {
 		af = nla_nest_start_noflag(skb, IFLA_AF_SPEC);
 		if (!af)
 			goto nla_put_failure;
@@ -564,7 +568,28 @@ static int br_fill_ifinfo(struct sk_buff *skb,
 		nla_nest_end(skb, cfm_nest);
 	}
 
+	if ((filter_mask & RTEXT_FILTER_MST) &&
+	    br_opt_get(br, BROPT_MST_ENABLED) && port) {
+		const struct net_bridge_vlan_group *vg = nbp_vlan_group(port);
+		struct nlattr *mst_nest;
+		int err;
+
+		if (!vg || !vg->num_vlans)
+			goto done;
+
+		mst_nest = nla_nest_start(skb, IFLA_BRIDGE_MST);
+		if (!mst_nest)
+			goto nla_put_failure;
+
+		err = br_mst_fill_info(skb, vg);
+		if (err)
+			goto nla_put_failure;
+
+		nla_nest_end(skb, mst_nest);
+	}
+
 done:
+
 	if (af)
 		nla_nest_end(skb, af);
 	nlmsg_end(skb, nlh);
@@ -803,6 +828,23 @@ static int br_afspec(struct net_bridge *br,
 			if (err)
 				return err;
 			break;
+		case IFLA_BRIDGE_MST:
+			if (!p) {
+				NL_SET_ERR_MSG(extack,
+					       "MST states can only be set on bridge ports");
+				return -EINVAL;
+			}
+
+			if (cmd != RTM_SETLINK) {
+				NL_SET_ERR_MSG(extack,
+					       "MST states can only be set through RTM_SETLINK");
+				return -EINVAL;
+			}
+
+			err = br_mst_process(p, attr, extack);
+			if (err)
+				return err;
+			break;
 		}
 	}
 
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 3978e1d9ffb5..18ccc3d5d296 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -1784,6 +1784,11 @@ int br_mst_vlan_set_msti(struct net_bridge_vlan *v, u16 msti);
 void br_mst_vlan_init_state(struct net_bridge_vlan *v);
 int br_mst_set_enabled(struct net_bridge *br, bool on,
 		       struct netlink_ext_ack *extack);
+size_t br_mst_info_size(const struct net_bridge_vlan_group *vg);
+int br_mst_fill_info(struct sk_buff *skb,
+		     const struct net_bridge_vlan_group *vg);
+int br_mst_process(struct net_bridge_port *p, const struct nlattr *mst_attr,
+		   struct netlink_ext_ack *extack);
 #else
 static inline bool br_mst_is_enabled(struct net_bridge *br)
 {
@@ -1801,6 +1806,24 @@ static inline int br_mst_set_enabled(struct net_bridge *br, bool on,
 {
 	return -EOPNOTSUPP;
 }
+
+static inline size_t br_mst_info_size(const struct net_bridge_vlan_group *vg)
+{
+	return 0;
+}
+
+static inline int br_mst_fill_info(struct sk_buff *skb,
+				   const struct net_bridge_vlan_group *vg)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline int br_mst_process(struct net_bridge_port *p,
+				 const struct nlattr *mst_attr,
+				 struct netlink_ext_ack *extack)
+{
+	return -EOPNOTSUPP;
+}
 #endif
 
 struct nf_br_ops {
-- 
2.25.1

