Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 879744B8A08
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 14:31:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234366AbiBPNan (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 08:30:43 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233419AbiBPNaj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 08:30:39 -0500
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D0341712B4
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 05:30:27 -0800 (PST)
Received: by mail-lj1-x230.google.com with SMTP id o9so3329377ljq.4
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 05:30:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:organization:content-transfer-encoding;
        bh=1CB4EUxFKWWI52Kz17aW6jZZJSTVpsgoKc4ur1YzcMA=;
        b=w73/uLp75Ob6mZY/GoZBQ3VdlKKx9uIt18VnJKjs81yvPTh9ma3bhetUB54GlatmyX
         SsBkqnp6YpcF+bQDQCGABlyboYCJ2NNE23QK3WZ4Dg+EdT7lhcnY5ZKWCV3gubXke/Ci
         atzgu+eHBNDOisygn9mYk3qhkfPA5BZZJ0nwLif5cBY5VeBqb6cb9CafTtvrh5fFWRf/
         NO9CR3HZxwLQoSEoU3nQuzsKLggOxHkCYbZZVaTtiXUrcv3htFUu3LsbeOS692zNkVKd
         v95/7aOAMP1QIebU/pjCLxqmQgFazCSSSjuE3z20kknQSOdfM4QrVIJLJwgk7at2FJK1
         EE/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:organization:content-transfer-encoding;
        bh=1CB4EUxFKWWI52Kz17aW6jZZJSTVpsgoKc4ur1YzcMA=;
        b=ZhaNKy03gQw+gp2DufvtQQ4ioiX+QCmYUK0CnRSVcbn9rU9wpEtP3Iy2eCGE1gklab
         ze95vzih+eZ5tMhkiBBwyjahMB959wLEOhqHLt4/Hngv728i0wSt5BWsHuKS2GhFvsUc
         rC84K8bB068NrowHeT+KKrMawxRtc4c7uY0cU2a8fT46gsTLzbdtMvwjTEg/1AkeSi2G
         ONoYAnKX4XR47+b7F4rGzKi4ygrf0rbmDI3JxJVOU4KRgdZzv4WS7XaPqcOBQxArHFBs
         E44HzHYvyJD4RMvfMeLK0GYPncIDLv2WHSiT4QAY+6llYTIeJTblHZWn5FSHk8xgVx80
         g0Xg==
X-Gm-Message-State: AOAM532K6YOmdod13OKeGDrRRMEZQ3N1p8e3BuQnzYn1XM0wNjGLDy0e
        2nPhcwYrpsHeF08yeUuvTcxE1Q==
X-Google-Smtp-Source: ABdhPJxIr0Fq0qdce4wqKBLB00c24HZ3fofKRdwkEGoZFNoIN46TqTgp7iHVd4dCVfJ/wiMClW2beg==
X-Received: by 2002:a2e:8e7b:0:b0:246:355:fbc0 with SMTP id t27-20020a2e8e7b000000b002460355fbc0mr2069502ljk.356.1645018225644;
        Wed, 16 Feb 2022 05:30:25 -0800 (PST)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id v6sm234780ljd.86.2022.02.16.05.30.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Feb 2022 05:30:24 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bridge@lists.linux-foundation.org
Subject: [RFC net-next 2/9] net: bridge: vlan: Allow multiple VLANs to be mapped to a single MST
Date:   Wed, 16 Feb 2022 14:29:27 +0100
Message-Id: <20220216132934.1775649-3-tobias@waldekranz.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220216132934.1775649-1-tobias@waldekranz.com>
References: <20220216132934.1775649-1-tobias@waldekranz.com>
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

Allow a VLAN to change its MSTID. In particular, allow multiple VLANs
to use the same MSTID. This is a global VLAN setting, i.e. any VLANs
bound to the same MSTID will share their per-VLAN STP states on all
bridge ports.

Example:

By default, each VLAN is placed in a separate MSTID:

root@coronet:~# ip link add dev br0 type bridge vlan_filtering 1
root@coronet:~# ip link set dev eth1 master br0
root@coronet:~# bridge vlan add dev eth1 vid 2 pvid untagged
root@coronet:~# bridge vlan add dev eth1 vid 3
root@coronet:~# bridge vlan global
port              vlan-id
br0               1
                    mcast_snooping 1 mca<redacted>_interval 1000 mstid 1
                  2
                    mcast_snooping 1 mca<redacted>_interval 1000 mstid 2
                  3
                    mcast_snooping 1 mca<redacted>_interval 1000 mstid 3

Once two or more VLANs are bound to the same MSTID, their states move
in lockstep, independent of which VID is used to access the state:

root@coronet:~# bridge vlan global set dev br0 vid 2 mstid 10
root@coronet:~# bridge vlan global set dev br0 vid 3 mstid 10
root@coronet:~# bridge -d vlan global
port              vlan-id
br0               1
                    mcast_snooping 1 mca<redacted>_interval 1000 mstid 1
                  2-3
                    mcast_snooping 1 mca<redacted>_interval 1000 mstid 10

root@coronet:~# bridge vlan set dev eth1 vid 2 state blocking
root@coronet:~# bridge -d vlan
port              vlan-id
eth1              1 Egress Untagged
                    state forwarding mcast_router 1
                  2 PVID Egress Untagged
                    state blocking mcast_router 1
                  3
                    state blocking mcast_router 1
br0               1 PVID Egress Untagged
                    state forwarding mcast_router 1
root@coronet:~# bridge vlan set dev eth1 vid 3 state forwarding
root@coronet:~# bridge -d vlan
port              vlan-id
eth1              1 Egress Untagged
                    state forwarding mcast_router 1
                  2 PVID Egress Untagged
                    state forwarding mcast_router 1
                  3
                    state forwarding mcast_router 1
br0               1 PVID Egress Untagged
                    state forwarding mcast_router 1

Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
---
 include/uapi/linux/if_bridge.h |  1 +
 net/bridge/br_private.h        |  3 ++
 net/bridge/br_vlan.c           | 53 ++++++++++++++++++++++++++--------
 net/bridge/br_vlan_options.c   | 17 ++++++++++-
 4 files changed, 61 insertions(+), 13 deletions(-)

diff --git a/include/uapi/linux/if_bridge.h b/include/uapi/linux/if_bridge.h
index 2711c3522010..4a971b419d9f 100644
--- a/include/uapi/linux/if_bridge.h
+++ b/include/uapi/linux/if_bridge.h
@@ -564,6 +564,7 @@ enum {
 	BRIDGE_VLANDB_GOPTS_MCAST_QUERIER,
 	BRIDGE_VLANDB_GOPTS_MCAST_ROUTER_PORTS,
 	BRIDGE_VLANDB_GOPTS_MCAST_QUERIER_STATE,
+	BRIDGE_VLANDB_GOPTS_MSTID,
 	__BRIDGE_VLANDB_GOPTS_MAX
 };
 #define BRIDGE_VLANDB_GOPTS_MAX (__BRIDGE_VLANDB_GOPTS_MAX - 1)
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 7781e7a4449b..5b121cf7aabe 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -1759,6 +1759,9 @@ static inline void br_vlan_set_state(struct net_bridge_vlan *v, u8 state)
 	mst->state = state;
 }
 
+u16 br_vlan_mstid_get(const struct net_bridge_vlan *v);
+int br_vlan_mstid_set(struct net_bridge_vlan *v, u16 mstid);
+
 static inline u8 br_vlan_get_pvid_state(const struct net_bridge_vlan_group *vg)
 {
 	return READ_ONCE(vg->pvid_state);
diff --git a/net/bridge/br_vlan.c b/net/bridge/br_vlan.c
index b0383ec6cc91..459e84a7354d 100644
--- a/net/bridge/br_vlan.c
+++ b/net/bridge/br_vlan.c
@@ -41,10 +41,8 @@ static void br_vlan_mst_rcu_free(struct rcu_head *rcu)
 	kfree(mst);
 }
 
-static void br_vlan_mst_put(struct net_bridge_vlan *v)
+static void br_vlan_mst_put(struct br_vlan_mst *mst)
 {
-	struct br_vlan_mst *mst = rtnl_dereference(v->mst);
-
 	if (refcount_dec_and_test(&mst->refcnt))
 		call_rcu(&mst->rcu, br_vlan_mst_rcu_free);
 }
@@ -153,13 +151,17 @@ static struct br_vlan_mst *br_vlan_group_mst_get(struct net_bridge_vlan_group *v
 
 static int br_vlan_mst_migrate(struct net_bridge_vlan *v, u16 mstid)
 {
+	struct br_vlan_mst *mst, *old_mst;
 	struct net_bridge_vlan_group *vg;
-	struct br_vlan_mst *mst;
+	struct net_bridge *br;
 
-	if (br_vlan_is_master(v))
-		vg = br_vlan_group(v->br);
-	else
+	if (br_vlan_is_master(v)) {
+		br = v->br;
+		vg = br_vlan_group(br);
+	} else {
+		br = v->port->br;
 		vg = nbp_vlan_group(v->port);
+	}
 
 	mst = br_vlan_group_mst_get(vg, mstid);
 	if (!mst) {
@@ -168,10 +170,37 @@ static int br_vlan_mst_migrate(struct net_bridge_vlan *v, u16 mstid)
 			return -ENOMEM;
 	}
 
-	if (rtnl_dereference(v->mst))
-		br_vlan_mst_put(v);
-
+	old_mst = rtnl_dereference(v->mst);
 	rcu_assign_pointer(v->mst, mst);
+
+	if (old_mst)
+		br_vlan_mst_put(old_mst);
+
+	return 0;
+}
+
+int br_vlan_mstid_set(struct net_bridge_vlan *v, u16 mstid)
+{
+	struct net_bridge *br = v->br;
+	struct net_bridge_port *p;
+	int err;
+
+	err = br_vlan_mst_migrate(v, mstid);
+	if (err)
+		return err;
+
+	list_for_each_entry(p, &br->port_list, list) {
+		struct net_bridge_vlan_group *vg = nbp_vlan_group(p);
+		struct net_bridge_vlan *portv;
+
+		portv = br_vlan_lookup(&vg->vlan_hash, v->vid);
+		if (!portv)
+			continue;
+
+		err = br_vlan_mst_migrate(portv, mstid);
+		if (err)
+			return err;
+	}
 	return 0;
 }
 
@@ -501,7 +530,7 @@ static int __vlan_add(struct net_bridge_vlan *v, u16 flags,
 	return err;
 
 out_mst_init:
-	br_vlan_mst_put(v);
+	br_vlan_mst_put(rtnl_dereference(v->mst));
 
 out_fdb_insert:
 	if (br_vlan_should_use(v)) {
@@ -570,7 +599,7 @@ static int __vlan_del(struct net_bridge_vlan *v)
 		call_rcu(&v->rcu, nbp_vlan_rcu_free);
 	}
 
-	br_vlan_mst_put(v);
+	br_vlan_mst_put(rtnl_dereference(v->mst));
 	br_vlan_put_master(masterv);
 out:
 	return err;
diff --git a/net/bridge/br_vlan_options.c b/net/bridge/br_vlan_options.c
index 0b1099709d4b..1c0fd55fe6c9 100644
--- a/net/bridge/br_vlan_options.c
+++ b/net/bridge/br_vlan_options.c
@@ -380,6 +380,9 @@ bool br_vlan_global_opts_fill(struct sk_buff *skb, u16 vid, u16 vid_range,
 #endif
 #endif
 
+	if (nla_put_u16(skb, BRIDGE_VLANDB_GOPTS_MSTID, br_vlan_mstid_get(v_opts)))
+		goto out_err;
+
 	nla_nest_end(skb, nest);
 
 	return true;
@@ -411,7 +414,9 @@ static size_t rtnl_vlan_global_opts_nlmsg_size(const struct net_bridge_vlan *v)
 		+ nla_total_size(0) /* BRIDGE_VLANDB_GOPTS_MCAST_ROUTER_PORTS */
 		+ br_rports_size(&v->br_mcast_ctx) /* BRIDGE_VLANDB_GOPTS_MCAST_ROUTER_PORTS */
 #endif
-		+ nla_total_size(sizeof(u16)); /* BRIDGE_VLANDB_GOPTS_RANGE */
+		+ nla_total_size(sizeof(u16)) /* BRIDGE_VLANDB_GOPTS_RANGE */
+		+ nla_total_size(sizeof(u16)) /* BRIDGE_VLANDB_GOPTS_MSTID */
+		+ 0;
 }
 
 static void br_vlan_global_opts_notify(const struct net_bridge *br,
@@ -560,6 +565,15 @@ static int br_vlan_process_global_one_opts(const struct net_bridge *br,
 	}
 #endif
 #endif
+	if (tb[BRIDGE_VLANDB_GOPTS_MSTID]) {
+		u16 mstid;
+
+		mstid = nla_get_u16(tb[BRIDGE_VLANDB_GOPTS_MSTID]);
+		err = br_vlan_mstid_set(v, mstid);
+		if (err)
+			return err;
+		*changed = true;
+	}
 
 	return 0;
 }
@@ -579,6 +593,7 @@ static const struct nla_policy br_vlan_db_gpol[BRIDGE_VLANDB_GOPTS_MAX + 1] = {
 	[BRIDGE_VLANDB_GOPTS_MCAST_QUERIER_INTVL]	= { .type = NLA_U64 },
 	[BRIDGE_VLANDB_GOPTS_MCAST_STARTUP_QUERY_INTVL]	= { .type = NLA_U64 },
 	[BRIDGE_VLANDB_GOPTS_MCAST_QUERY_RESPONSE_INTVL] = { .type = NLA_U64 },
+	[BRIDGE_VLANDB_GOPTS_MSTID] = NLA_POLICY_RANGE(NLA_U16, 1, 4094),
 };
 
 int br_vlan_rtm_process_global_options(struct net_device *dev,
-- 
2.25.1

