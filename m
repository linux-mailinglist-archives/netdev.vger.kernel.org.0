Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8339967D26C
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 18:02:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231260AbjAZRCo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 12:02:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231599AbjAZRCm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 12:02:42 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2046.outbound.protection.outlook.com [40.107.244.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 112306B9A4
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 09:02:25 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ayjcbHnQeEUxP6J3rQgTQNCoVaGDC2yrd9WEceR0+ZJJ4LM/WgTGgEEzM1mOvXpTcuMLVlpcA+IogmMjj/iPqmC2myWzqqza4azPWsariD4yXg5oTamHNhAdCEO1fOcuT5xyePy4SKCX3eA95/YBj87s+8YMdlv90Xl+M0vVE8mXOQM5li1VvQ96dXw8w0ymOT3fWuSX0v3JvdSTkjbuZ5fjLfPO1Q+8YABIwRdMVgy1gQcGM7MXS54nt7yWAheHUsYImw9t2W8fdHAOpLAh/CPD4ubhk/zq5uPyaAK8oXJqlhaXV1VoX/Nk/BVljuReH6o771F/sbUmKewXhno9Zw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cw14YMkqXTBlyLd0EqhPujuCIcZzy7LvXikSk3Ihu0E=;
 b=X7Bp6clIpBQIxB1M5CXqBUkdEq7F9tumFVSl5gRoGSc9FYmQt1AbS+ClBWOTU87lgRaTyE6R0DM2QNLAUfiu5LEwnZA6mcRWn8bv0RRKX3JuKgkNkI3ntCeIPBamZ3ADGhafQShE8kt7zHZs8iu+oN6Dh24nCbHgy3K7d+8nakp+xQkFnDEl0jOoZ9jjMiVOqjDbAojGpSPH6YFFMu0vg34LE9913lgo9rLuCrx59bxG8qQjI2lWg7vRxVhG6BF56cHDzyL1lE4vQ92O4Sbi+5sc/JqOYEOsrjxR4/ek8EYxnRStLm+dRikSgzbkHv94w62MtlU25qBkRLXY4PpnHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cw14YMkqXTBlyLd0EqhPujuCIcZzy7LvXikSk3Ihu0E=;
 b=ed3FvgqP8HVotZK1ZccWJXrVB1KVT9LZqWss5apffmxflIdXdp7L1IYQa93npHWx3IxnhQB8uzSbZw3SWkaEmqVeYRCL4OWuyglii1MRirBjHL1feWV0Niz4AhULxbC8nIP37ECAwwQudA6iKD7NDempX0d8451bbxm4F5NiKzNhPrmJd4rfoqlM+b2spE8C9XuMug3z1J1YGPe4dExaxSdKoRpgX1oJPL1Z+DsW66cZa0cREEbdalQdMviE5j00solW8gVh8VmZg92L00LaGtkKUQBhnc7KCMr3n7IFTy4dZI8Ji6+BLLsA7Ecg0CW2lWB98iWysZpw8Np0eSCnBw==
Received: from MW4PR03CA0326.namprd03.prod.outlook.com (2603:10b6:303:dd::31)
 by LV2PR12MB5871.namprd12.prod.outlook.com (2603:10b6:408:174::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.21; Thu, 26 Jan
 2023 17:02:22 +0000
Received: from CO1NAM11FT071.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:dd:cafe::1c) by MW4PR03CA0326.outlook.office365.com
 (2603:10b6:303:dd::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.22 via Frontend
 Transport; Thu, 26 Jan 2023 17:02:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CO1NAM11FT071.mail.protection.outlook.com (10.13.175.56) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6043.17 via Frontend Transport; Thu, 26 Jan 2023 17:02:22 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 26 Jan
 2023 09:02:10 -0800
Received: from localhost.localdomain (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 26 Jan
 2023 09:02:07 -0800
From:   Petr Machata <petrm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        <netdev@vger.kernel.org>
CC:     <bridge@lists.linux-foundation.org>,
        Petr Machata <petrm@nvidia.com>,
        "Ido Schimmel" <idosch@nvidia.com>
Subject: [PATCH net-next 07/16] net: bridge: Maintain number of MDB entries in net_bridge_mcast_port
Date:   Thu, 26 Jan 2023 18:01:15 +0100
Message-ID: <1dcd4638d78c469eaa2f528de1f69b098222876f.1674752051.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <cover.1674752051.git.petrm@nvidia.com>
References: <cover.1674752051.git.petrm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.231.37]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT071:EE_|LV2PR12MB5871:EE_
X-MS-Office365-Filtering-Correlation-Id: 1459bff3-b3a8-4b27-89fd-08daffbf176a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NZdlYS3Qcma44ocBadlQKQKRs0xj12YbnP81iRK/GMmZDRtlr2LtQbjuHY6o9bu12etSV1HqA3vKo00+7jYQcCF9KifogC4twWLSy36BZ6wlHLU9dZqJL5qB6kWoh34CJNextopAMRVZIn6nZyehG6uuVcE8Jsoxv+o7mOx/PwZJDPq0KVhQ1EXpG0bcV5Kk47JP4pf4WaseEPwndbQ5PHe5O6YAFYo2OXkPqFyStS1XJyTdVGLtoE9ttiLgQZZ4eziiMyVCIPYNziE/CNr6gpue1zbe9ysJRY8rPewjCgBrJTvMpVhzyG+ZcnyyBWUYYj6ILd0IATzJBIW8tnkoFvQk6pzxrRdh6I9q5LarlbfGT3ehFZh7xy7lP8tGIpUQ31k+JqEUTkYU7ObMEZI1e5CRVIDiMMZoLymEIHbPkPFvofZTSU9o7m2hgxb77SfnN0VRjYu8hdG1RQhlgmm6sZhG1RpkObRDzEBh7mJkym+k3o9t7bdKJypEWW4/AdS8CAgZsRysrTcGbgyIx2jT8qCPM6OhHYWlEkyHCIjorLxjMJyGILgldYKu06tI/dqylce9/F9QvriCm2n9bNJ7zny8NizLXGUq5w1wB24Ul0h/IjR80rfmPmeYOujT3DSLPwG/mAvV9G9iv4jZ3WhLuRk3kUaH71mkgk5kilsjluIgUj9cwjkSfhDQTLZ3tZHtbGKtFwW81GwzxWV2Q+TMJg==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(346002)(39860400002)(136003)(376002)(396003)(451199018)(46966006)(40470700004)(36840700001)(36756003)(40460700003)(86362001)(54906003)(107886003)(110136005)(6666004)(316002)(82310400005)(70206006)(70586007)(478600001)(2906002)(83380400001)(40480700001)(8936002)(8676002)(4326008)(82740400003)(36860700001)(7636003)(5660300002)(2616005)(356005)(186003)(26005)(336012)(41300700001)(16526019)(426003)(66574015)(47076005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2023 17:02:22.2103
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1459bff3-b3a8-4b27-89fd-08daffbf176a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT071.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5871
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The MDB maintained by the bridge is limited. When the bridge is configured
for IGMP / MLD snooping, a buggy or malicious client can easily exhaust its
capacity. In SW datapath, the capacity is configurable through the
IFLA_BR_MCAST_HASH_MAX parameter, but ultimately is finite. Obviously a
similar limit exists in the HW datapath for purposes of offloading.

In order to prevent the issue of unilateral exhaustion of MDB resources,
introduce two parameters in each of two contexts:

- Per-port and per-port-VLAN number of MDB entries that the port
  is member in.

- Per-port and (when BROPT_MCAST_VLAN_SNOOPING_ENABLED is enabled)
  per-port-VLAN maximum permitted number of MDB entries, or 0 for
  no limit.

The per-port multicast context is used for tracking of MDB entries for the
port as a whole. This is available for all bridges.

The per-port-VLAN multicast context is then only available on
VLAN-filtering bridges on VLANs that have multicast snooping on.

With these changes in place, it will be possible to configure MDB limit for
bridge as a whole, or any one port as a whole, or any single port-VLAN.

Note that unlike the global limit, exhaustion of the per-port and
per-port-VLAN maximums does not cause disablement of multicast snooping.
It is also permitted to configure the local limit larger than hash_max,
even though that is not useful.

In this patch, introduce only the accounting for number of entries, and the
max field itself, but not the means to toggle the max. The next patch
introduces the netlink APIs to toggle and read the values.

Note that the per-port-VLAN mcast_max_groups value gets reset when VLAN
snooping is enabled. The reason for this is that while VLAN snooping is
disabled, permanent entries can be added above the limit imposed by the
configured maximum. Under those circumstances, whatever caused the VLAN
context enablement, would need to be rolled back, adding a fair amount of
code that would be rarely hit and tricky to maintain. At the same time,
the feature that this would enable is IMHO not interesting: I posit that
the usefulness of keeping mcast_max_groups intact across
mcast_vlan_snooping toggles is marginal at best.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
---
 net/bridge/br_multicast.c | 131 +++++++++++++++++++++++++++++++++++++-
 net/bridge/br_private.h   |   2 +
 2 files changed, 132 insertions(+), 1 deletion(-)

diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index 51b622afdb67..de531109b947 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -31,6 +31,7 @@
 #include <net/ip6_checksum.h>
 #include <net/addrconf.h>
 #endif
+#include <trace/events/bridge.h>
 
 #include "br_private.h"
 #include "br_private_mcast_eht.h"
@@ -234,6 +235,29 @@ br_multicast_pg_to_port_ctx(const struct net_bridge_port_group *pg)
 	return pmctx;
 }
 
+static struct net_bridge_mcast_port *
+br_multicast_port_vid_to_port_ctx(struct net_bridge_port *port, u16 vid)
+{
+	struct net_bridge_mcast_port *pmctx = NULL;
+	struct net_bridge_vlan *vlan;
+
+	lockdep_assert_held_once(&port->br->multicast_lock);
+
+	if (!br_opt_get(port->br, BROPT_MCAST_VLAN_SNOOPING_ENABLED))
+		return NULL;
+
+	/* Take RCU to access the vlan. */
+	rcu_read_lock();
+
+	vlan = br_vlan_find(nbp_vlan_group_rcu(port), vid);
+	if (vlan && !br_multicast_port_ctx_vlan_disabled(&vlan->port_mcast_ctx))
+		pmctx = &vlan->port_mcast_ctx;
+
+	rcu_read_unlock();
+
+	return pmctx;
+}
+
 /* when snooping we need to check if the contexts should be used
  * in the following order:
  * - if pmctx is non-NULL (port), check if it should be used
@@ -668,6 +692,80 @@ void br_multicast_del_group_src(struct net_bridge_group_src *src,
 	__br_multicast_del_group_src(src);
 }
 
+static int
+br_multicast_port_ngroups_inc_one(struct net_bridge_mcast_port *pmctx,
+				  struct netlink_ext_ack *extack)
+{
+	if (pmctx->mdb_max_entries &&
+	    pmctx->mdb_n_entries == pmctx->mdb_max_entries)
+		return -E2BIG;
+
+	pmctx->mdb_n_entries++;
+	return 0;
+}
+
+static void br_multicast_port_ngroups_dec_one(struct net_bridge_mcast_port *pmctx)
+{
+	WARN_ON_ONCE(pmctx->mdb_n_entries-- == 0);
+}
+
+static int br_multicast_port_ngroups_inc(struct net_bridge_port *port,
+					 const struct br_ip *group,
+					 struct netlink_ext_ack *extack)
+{
+	struct net_bridge_mcast_port *pmctx;
+	int err;
+
+	lockdep_assert_held_once(&port->br->multicast_lock);
+
+	/* Always count on the port context. */
+	err = br_multicast_port_ngroups_inc_one(&port->multicast_ctx, extack);
+	if (err) {
+		NL_SET_ERR_MSG_FMT_MOD(extack, "Port is already a member in mcast_max_groups (%u) groups",
+				       port->multicast_ctx.mdb_max_entries);
+		trace_br_mdb_full(port->dev, group);
+		return err;
+	}
+
+	/* Only count on the VLAN context if VID is given, and if snooping on
+	 * that VLAN is enabled.
+	 */
+	if (!group->vid)
+		return 0;
+
+	pmctx = br_multicast_port_vid_to_port_ctx(port, group->vid);
+	if (!pmctx)
+		return 0;
+
+	err = br_multicast_port_ngroups_inc_one(pmctx, extack);
+	if (err) {
+		NL_SET_ERR_MSG_FMT_MOD(extack, "Port-VLAN is already a member in mcast_max_groups (%u) groups",
+				       pmctx->mdb_max_entries);
+		trace_br_mdb_full(port->dev, group);
+		goto dec_one_out;
+	}
+
+	return 0;
+
+dec_one_out:
+	br_multicast_port_ngroups_dec_one(&port->multicast_ctx);
+	return err;
+}
+
+static void br_multicast_port_ngroups_dec(struct net_bridge_port *port, u16 vid)
+{
+	struct net_bridge_mcast_port *pmctx;
+
+	lockdep_assert_held_once(&port->br->multicast_lock);
+
+	if (vid) {
+		pmctx = br_multicast_port_vid_to_port_ctx(port, vid);
+		if (pmctx)
+			br_multicast_port_ngroups_dec_one(pmctx);
+	}
+	br_multicast_port_ngroups_dec_one(&port->multicast_ctx);
+}
+
 static void br_multicast_destroy_port_group(struct net_bridge_mcast_gc *gc)
 {
 	struct net_bridge_port_group *pg;
@@ -702,6 +800,7 @@ void br_multicast_del_pg(struct net_bridge_mdb_entry *mp,
 	} else {
 		br_multicast_star_g_handle_mode(pg, MCAST_INCLUDE);
 	}
+	br_multicast_port_ngroups_dec(pg->key.port, pg->key.addr.vid);
 	hlist_add_head(&pg->mcast_gc.gc_node, &br->mcast_gc_list);
 	queue_work(system_long_wq, &br->mcast_gc_work);
 
@@ -1165,6 +1264,7 @@ struct net_bridge_mdb_entry *br_multicast_new_group(struct net_bridge *br,
 		return mp;
 
 	if (atomic_read(&br->mdb_hash_tbl.nelems) >= br->hash_max) {
+		trace_br_mdb_full(br->dev, group);
 		br_mc_disabled_update(br->dev, false, NULL);
 		br_opt_toggle(br, BROPT_MULTICAST_ENABLED, false);
 		return ERR_PTR(-E2BIG);
@@ -1288,11 +1388,16 @@ struct net_bridge_port_group *br_multicast_new_port_group(
 			struct netlink_ext_ack *extack)
 {
 	struct net_bridge_port_group *p;
+	int err;
+
+	err = br_multicast_port_ngroups_inc(port, group, extack);
+	if (err)
+		return NULL;
 
 	p = kzalloc(sizeof(*p), GFP_ATOMIC);
 	if (unlikely(!p)) {
 		NL_SET_ERR_MSG_MOD(extack, "Couldn't allocate new port group");
-		return NULL;
+		goto dec_out;
 	}
 
 	p->key.addr = *group;
@@ -1326,18 +1431,22 @@ struct net_bridge_port_group *br_multicast_new_port_group(
 
 free_out:
 	kfree(p);
+dec_out:
+	br_multicast_port_ngroups_dec(port, group->vid);
 	return NULL;
 }
 
 void br_multicast_del_port_group(struct net_bridge_port_group *p)
 {
 	struct net_bridge_port *port = p->key.port;
+	__u16 vid = p->key.addr.vid;
 
 	hlist_del_init(&p->mglist);
 	if (!br_multicast_is_star_g(&p->key.addr))
 		rhashtable_remove_fast(&port->br->sg_port_tbl, &p->rhnode,
 				       br_sg_port_rht_params);
 	kfree(p);
+	br_multicast_port_ngroups_dec(port, vid);
 }
 
 void br_multicast_host_join(const struct net_bridge_mcast *brmctx,
@@ -1951,6 +2060,26 @@ static void __br_multicast_enable_port_ctx(struct net_bridge_mcast_port *pmctx)
 		br_ip4_multicast_add_router(brmctx, pmctx);
 		br_ip6_multicast_add_router(brmctx, pmctx);
 	}
+
+	if (br_multicast_port_ctx_is_vlan(pmctx)) {
+		struct net_bridge_port_group *pg;
+
+		/* If BR_VLFLAG_MCAST_ENABLED was enabled in the past, but then
+		 * disabled, the mcast_n_groups counter is now wrong. First,
+		 * BR_VLFLAG_MCAST_ENABLED is toggled before temporary entries
+		 * are flushed, thus mcast_n_groups after the toggle does not
+		 * reflect the true values. And second, permanent entries added
+		 * while BR_VLFLAG_MCAST_ENABLED was disabled, are not reflected
+		 * either. Thus we have to refresh the counter.
+		 */
+
+		pmctx->mdb_max_entries = 0;
+		pmctx->mdb_n_entries = 0;
+		hlist_for_each_entry(pg, &pmctx->port->mglist, mglist) {
+			if (pg->key.addr.vid == pmctx->vlan->vid)
+				br_multicast_port_ngroups_inc_one(pmctx, NULL);
+		}
+	}
 }
 
 void br_multicast_enable_port(struct net_bridge_port *port)
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index e4069e27b5c6..49f411a0a1f1 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -126,6 +126,8 @@ struct net_bridge_mcast_port {
 	struct hlist_node		ip6_rlist;
 #endif /* IS_ENABLED(CONFIG_IPV6) */
 	unsigned char			multicast_router;
+	u32				mdb_n_entries;
+	u32				mdb_max_entries;
 #endif /* CONFIG_BRIDGE_IGMP_SNOOPING */
 };
 
-- 
2.39.0

