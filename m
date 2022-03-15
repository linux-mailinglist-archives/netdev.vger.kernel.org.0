Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1FC54D9155
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 01:26:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343816AbiCOA1k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 20:27:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242791AbiCOA1f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 20:27:35 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 135273D1CC
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 17:26:24 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id s25so30147221lfs.10
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 17:26:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:organization:content-transfer-encoding;
        bh=ifE/90L+JCsTSi4RUhywC6bB94IKAbWKaW5qXHdRgig=;
        b=OPv2xKS59wIOChxbJlIFZqrMgWrJr7dPZfJMUvPECBLkWNhfBgsjlRMwZPxkpIvMGB
         WYOZbGJM9ajrPz8bv+QOdh+4Vn+Q0GDmLAS1Bp7kGuYlfF4ayJrgQi39cdTG7iIlul1I
         jhOCch0BGa7QoVkcoy4PKmxtc65SeCq3nQaBbwgh09d+ZUEAnrYD5YYKBWhqjLrMd/4z
         fsj5VDQnlpW7ryzNL1lcdZETlVp7DMW50QmUTLEIbgtMOTN+ZQhkyPptW8sP1W0euuj0
         4Ujc2HZXkDMmOPBmPcKkS41HPyhgN+ryEDwr+zSmDyMDm6XuuUwRW0/5GEoQdVo3hDwn
         gK6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:organization:content-transfer-encoding;
        bh=ifE/90L+JCsTSi4RUhywC6bB94IKAbWKaW5qXHdRgig=;
        b=kVqg6NctY+8iZVzoY0xGdtCd42yrRi86/YGShtVsvs2Eo4CDS76H0Mibmkcosc/s49
         5++FuE6PH+zCoXTQSdANjFmHICjwwld6HJyk4FRPl4fU2cAuQn2HBocRi9iFENiGXjUJ
         q57Xhmp00JIuQG2uS10YEOdHWlWPvEGGFAqD97KSQKrkztGFxlxbwox7pbsAzMXH3vTW
         YHx5Ej15KW4sHL8n4vXgJlKK98cnTMGQoV9oKlpI30TrWHpJKIEYiLtS0RIggHPBu9hM
         Dtq8fxYZmmTOEGUqPh+XLEA+jiymyDVhFC23McZmie7KQG30CcSkrVhLK1U+Fut6jGfJ
         6gAA==
X-Gm-Message-State: AOAM530uOtP4Nbdalh9TmGXK9IKnweokmuLTqk92IvvQWQzISn7b/YfW
        Jf8+LKuEmpCoGGboast+kjldpw==
X-Google-Smtp-Source: ABdhPJz5eK6mfrK8im9mQ5lWqtmPDxS7qT8a0d5q+sUmXUs0illLY7AwX2loMy1QqpWxvZWMc1wzMw==
X-Received: by 2002:a05:6512:b13:b0:448:90c6:dc49 with SMTP id w19-20020a0565120b1300b0044890c6dc49mr5598524lfu.542.1647303982306;
        Mon, 14 Mar 2022 17:26:22 -0700 (PDT)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id y14-20020a2e544e000000b0024800f8286bsm4219923ljd.78.2022.03.14.17.26.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Mar 2022 17:26:21 -0700 (PDT)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Nikolay Aleksandrov <razor@blackwall.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Russell King <linux@armlinux.org.uk>,
        Petr Machata <petrm@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Matt Johnston <matt@codeconstruct.com.au>,
        Cooper Lees <me@cooperlees.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bridge@lists.linux-foundation.org
Subject: [PATCH v4 net-next 02/15] net: bridge: mst: Allow changing a VLAN's MSTI
Date:   Tue, 15 Mar 2022 01:25:30 +0100
Message-Id: <20220315002543.190587-3-tobias@waldekranz.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220315002543.190587-1-tobias@waldekranz.com>
References: <20220315002543.190587-1-tobias@waldekranz.com>
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

Allow a VLAN to move out of the CST (MSTI 0), to an independent tree.

The user manages the VID to MSTI mappings via a global VLAN
setting. The proposed iproute2 interface would be:

    bridge vlan global set dev br0 vid <VID> msti <MSTI>

Changing the state in non-zero MSTIs is still not supported, but will
be addressed in upcoming changes.

Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
Acked-by: Nikolay Aleksandrov <razor@blackwall.org>
---
 include/uapi/linux/if_bridge.h |  1 +
 net/bridge/br_mst.c            | 42 ++++++++++++++++++++++++++++++++++
 net/bridge/br_private.h        |  1 +
 net/bridge/br_vlan_options.c   | 15 ++++++++++++
 4 files changed, 59 insertions(+)

diff --git a/include/uapi/linux/if_bridge.h b/include/uapi/linux/if_bridge.h
index 30a242195ced..f60244b747ae 100644
--- a/include/uapi/linux/if_bridge.h
+++ b/include/uapi/linux/if_bridge.h
@@ -564,6 +564,7 @@ enum {
 	BRIDGE_VLANDB_GOPTS_MCAST_QUERIER,
 	BRIDGE_VLANDB_GOPTS_MCAST_ROUTER_PORTS,
 	BRIDGE_VLANDB_GOPTS_MCAST_QUERIER_STATE,
+	BRIDGE_VLANDB_GOPTS_MSTI,
 	__BRIDGE_VLANDB_GOPTS_MAX
 };
 #define BRIDGE_VLANDB_GOPTS_MAX (__BRIDGE_VLANDB_GOPTS_MAX - 1)
diff --git a/net/bridge/br_mst.c b/net/bridge/br_mst.c
index e1ec9d39c660..78ef5fea4d2b 100644
--- a/net/bridge/br_mst.c
+++ b/net/bridge/br_mst.c
@@ -43,6 +43,48 @@ void br_mst_set_state(struct net_bridge_port *p, u16 msti, u8 state)
 	}
 }
 
+static void br_mst_vlan_sync_state(struct net_bridge_vlan *pv, u16 msti)
+{
+	struct net_bridge_vlan_group *vg = nbp_vlan_group(pv->port);
+	struct net_bridge_vlan *v;
+
+	list_for_each_entry(v, &vg->vlan_list, vlist) {
+		/* If this port already has a defined state in this
+		 * MSTI (through some other VLAN membership), inherit
+		 * it.
+		 */
+		if (v != pv && v->brvlan->msti == msti) {
+			br_mst_vlan_set_state(pv->port, pv, v->state);
+			return;
+		}
+	}
+
+	/* Otherwise, start out in a new MSTI with all ports disabled. */
+	return br_mst_vlan_set_state(pv->port, pv, BR_STATE_DISABLED);
+}
+
+int br_mst_vlan_set_msti(struct net_bridge_vlan *mv, u16 msti)
+{
+	struct net_bridge_vlan_group *vg;
+	struct net_bridge_vlan *pv;
+	struct net_bridge_port *p;
+
+	if (mv->msti == msti)
+		return 0;
+
+	mv->msti = msti;
+
+	list_for_each_entry(p, &mv->br->port_list, list) {
+		vg = nbp_vlan_group(p);
+
+		pv = br_vlan_find(vg, mv->vid);
+		if (pv)
+			br_mst_vlan_sync_state(pv, msti);
+	}
+
+	return 0;
+}
+
 void br_mst_vlan_init_state(struct net_bridge_vlan *v)
 {
 	/* VLANs always start out in MSTI 0 (CST) */
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 934c3dc4a927..d8c641c70589 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -1779,6 +1779,7 @@ static inline bool br_mst_is_enabled(struct net_bridge *br)
 }
 
 void br_mst_set_state(struct net_bridge_port *p, u16 msti, u8 state);
+int br_mst_vlan_set_msti(struct net_bridge_vlan *v, u16 msti);
 void br_mst_vlan_init_state(struct net_bridge_vlan *v);
 int br_mst_set_enabled(struct net_bridge *br, bool on,
 		       struct netlink_ext_ack *extack);
diff --git a/net/bridge/br_vlan_options.c b/net/bridge/br_vlan_options.c
index 09112b56e79c..a2724d03278c 100644
--- a/net/bridge/br_vlan_options.c
+++ b/net/bridge/br_vlan_options.c
@@ -296,6 +296,7 @@ bool br_vlan_global_opts_can_enter_range(const struct net_bridge_vlan *v_curr,
 					 const struct net_bridge_vlan *r_end)
 {
 	return v_curr->vid - r_end->vid == 1 &&
+		v_curr->msti == r_end->msti &&
 	       ((v_curr->priv_flags ^ r_end->priv_flags) &
 		BR_VLFLAG_GLOBAL_MCAST_ENABLED) == 0 &&
 		br_multicast_ctx_options_equal(&v_curr->br_mcast_ctx,
@@ -384,6 +385,9 @@ bool br_vlan_global_opts_fill(struct sk_buff *skb, u16 vid, u16 vid_range,
 #endif
 #endif
 
+	if (nla_put_u16(skb, BRIDGE_VLANDB_GOPTS_MSTI, v_opts->msti))
+		goto out_err;
+
 	nla_nest_end(skb, nest);
 
 	return true;
@@ -415,6 +419,7 @@ static size_t rtnl_vlan_global_opts_nlmsg_size(const struct net_bridge_vlan *v)
 		+ nla_total_size(0) /* BRIDGE_VLANDB_GOPTS_MCAST_ROUTER_PORTS */
 		+ br_rports_size(&v->br_mcast_ctx) /* BRIDGE_VLANDB_GOPTS_MCAST_ROUTER_PORTS */
 #endif
+		+ nla_total_size(sizeof(u16)) /* BRIDGE_VLANDB_GOPTS_MSTI */
 		+ nla_total_size(sizeof(u16)); /* BRIDGE_VLANDB_GOPTS_RANGE */
 }
 
@@ -564,6 +569,15 @@ static int br_vlan_process_global_one_opts(const struct net_bridge *br,
 	}
 #endif
 #endif
+	if (tb[BRIDGE_VLANDB_GOPTS_MSTI]) {
+		u16 msti;
+
+		msti = nla_get_u16(tb[BRIDGE_VLANDB_GOPTS_MSTI]);
+		err = br_mst_vlan_set_msti(v, msti);
+		if (err)
+			return err;
+		*changed = true;
+	}
 
 	return 0;
 }
@@ -583,6 +597,7 @@ static const struct nla_policy br_vlan_db_gpol[BRIDGE_VLANDB_GOPTS_MAX + 1] = {
 	[BRIDGE_VLANDB_GOPTS_MCAST_QUERIER_INTVL]	= { .type = NLA_U64 },
 	[BRIDGE_VLANDB_GOPTS_MCAST_STARTUP_QUERY_INTVL]	= { .type = NLA_U64 },
 	[BRIDGE_VLANDB_GOPTS_MCAST_QUERY_RESPONSE_INTVL] = { .type = NLA_U64 },
+	[BRIDGE_VLANDB_GOPTS_MSTI] = NLA_POLICY_MAX(NLA_U16, VLAN_N_VID - 1),
 };
 
 int br_vlan_rtm_process_global_options(struct net_device *dev,
-- 
2.25.1

