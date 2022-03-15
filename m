Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C7DF4D9157
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 01:26:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235679AbiCOA1o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 20:27:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237473AbiCOA1g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 20:27:36 -0400
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 107AC3D1C1
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 17:26:25 -0700 (PDT)
Received: by mail-lj1-x236.google.com with SMTP id 17so22218284lji.1
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 17:26:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:organization:content-transfer-encoding;
        bh=11G3nDNS7ci6Div/hFHoedM4vPL/g/2KW7w8caexl2A=;
        b=5fCrfxGmF55RlA5825oN9fDAee1Z/GqcQzDc4MH9N3PKZ87S4DiGgTWKF+GaRH9DMq
         IIXktoLvRkNkiJ1RoLg1zjcbX1uGDups9YT8/QG/WUylkZ2/AzljPk/yH3v+BmP1Lkzf
         rj0PiB0YzRExOg+UBkXqFr3FAwPlPdTA+RYfdNw/7+XX99qkSzXr+O4/2CYTyWrw/fCE
         eZ0rAexwCd4qS8jyVydM+TRI+5dbco94c6OsIK3XcJOJ9UWCAG78uoi4ywM5brnv3ruO
         uUi5IBRtA5uMWzY7QLlpanSSLb3aDvSoUXEV9SZvVQ+ZNY641qUli432SnUoxljXs22u
         8n7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:organization:content-transfer-encoding;
        bh=11G3nDNS7ci6Div/hFHoedM4vPL/g/2KW7w8caexl2A=;
        b=Zxj+kf/hjnOpaqdsbPtOW9FDMvgV7Gz8sxi+yGXxr8egxqMBjIk2PrzugRP+I3uTtV
         yWKs4PeBQhwHz8aRXIjJIGMRDvhUQJOSPcS/I5NrNobay/AmWW9ajBPNYyCv4fTBXp3V
         SzStKCFqmomXJjZv/LP5gJ/NWib8ivefxEDxrXIDny/RCnCuPFQoeMvVTuMLXcUZGph2
         17+q72DqAjgNWiNyV+CJhIXlUr3sR9By6ceZ6cV5tE/UcGQ+NDZygSEFN5TGBuZY25BX
         Lc3vtO67sxVDBg+cWDJN2tbh47zDT5SvKkZyPw9rxlonjX8X7i+qa8gGDGAbbkBv0ryd
         IgUA==
X-Gm-Message-State: AOAM532gZvwcxwb5pgW6uhte2qPzYIVD+nKu9wQBMiL1ytYw0NDjHrMZ
        uqvZkXvaqDe3S00lBA9ZThCBOw==
X-Google-Smtp-Source: ABdhPJyzUWTyTr8nxLL4jeOhAFuKfPQQ0Het46xRAbtcxnB6FWiHC0Li1j3sFoz4zP06oEsI0vr4Ng==
X-Received: by 2002:a2e:740e:0:b0:244:c716:159b with SMTP id p14-20020a2e740e000000b00244c716159bmr15414474ljc.95.1647303983207;
        Mon, 14 Mar 2022 17:26:23 -0700 (PDT)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id y14-20020a2e544e000000b0024800f8286bsm4219923ljd.78.2022.03.14.17.26.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Mar 2022 17:26:22 -0700 (PDT)
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
Subject: [PATCH v4 net-next 03/15] net: bridge: mst: Support setting and reporting MST port states
Date:   Tue, 15 Mar 2022 01:25:31 +0100
Message-Id: <20220315002543.190587-4-tobias@waldekranz.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220315002543.190587-1-tobias@waldekranz.com>
References: <20220315002543.190587-1-tobias@waldekranz.com>
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
 net/bridge/br_mst.c            | 127 +++++++++++++++++++++++++++++++++
 net/bridge/br_netlink.c        |  44 +++++++++++-
 net/bridge/br_private.h        |  23 ++++++
 5 files changed, 210 insertions(+), 1 deletion(-)

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
index 78ef5fea4d2b..355ad102d6b1 100644
--- a/net/bridge/br_mst.c
+++ b/net/bridge/br_mst.c
@@ -124,3 +124,130 @@ int br_mst_set_enabled(struct net_bridge *br, bool on,
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
+	list_for_each_entry(v, &vg->vlan_list, vlist) {
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
+	br_mst_set_state(p, msti, state);
+	return 0;
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
index d8c641c70589..75652dbe44ba 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -1783,6 +1783,11 @@ int br_mst_vlan_set_msti(struct net_bridge_vlan *v, u16 msti);
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
@@ -1796,6 +1801,24 @@ static inline int br_mst_set_enabled(struct net_bridge *br, bool on,
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

