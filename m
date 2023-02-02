Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AC956885E1
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 19:01:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232203AbjBBSBI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 13:01:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232147AbjBBSBB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 13:01:01 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2088.outbound.protection.outlook.com [40.107.94.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC46C6D066
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 10:00:53 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=doWJn10cxeCHQMm3tkfXO7jsHXOItsWdeN+qJqIEBVMyIhNkQgPj2FJNRROsD/5L11CW2p/LxZcQuhYv8b2mfcmN8dIBWFXgyq34pgvpeiNj/BqNhyOQUtvhiEqOr6sQzJDI4JDlpEq+jlHRfCFiOynlyjHfbfSWl5P7ohkl2na97HxdXTU71y1pKoFIawdaZEwsTaUgY0ZBLhGkxtAZqPwhqHgU9OnqiPHiZv8aCY8kMoeZIObFUnY9h3y2qHDXE2pZl9THkI1QKIxV7ji/xvsOOjxlt8ejhvJog//Vu4WOJ/fTebevJ7S4m931rBpD2IokfSHo5uNPiyrSMh0iJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AeIm8VDbyr8KO7oICYdB7n8V03qSN2W5BVKef+oJ5OE=;
 b=EeKbnKRu3kRj1nHvaGfefbykMUwQaTHXJyEsr6cnz8g8W1TPSxZKAqMvdXnhHcn5MFjnQaHUYwl+MsxBmU1guZdwNIgwSP5KDDjMF7WDT+YI5+fwEvAQhfUMojFGjXDMu+wiXcbFh2hiYv9ajXLbstKVNGkITcuUheWCLD0WKQf069ij9+drODEoislvH5iYpTBuyA5zaC0glYAWvISTfb+Y9FpoS8LrGqlSbcEfJBZrhQwapmzTTrZ1/AHjrjuzL9npU96MhBjvVxEGJcwxY1uUMEB2f2ZfG6Us2Gyy2z+TOM0F695+cYcDDN3mftuQUHia3ZP66bLCWLOgPn/sqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AeIm8VDbyr8KO7oICYdB7n8V03qSN2W5BVKef+oJ5OE=;
 b=qrol3hucCq7ZoA1ITVzWa2+Ij65qtniNi0+6PyP/Gwxp5pUsMpE6AfRBEQHaG6XlsNw4uUsjfVfg4wXpXdj2ZWpSJB7w14zJj6MmcEcknJ1+Jk6HaMFbGOXw/UVH5cQt1MEU4b0nwH/xa8G0Pvy5D6Nvttl1mXgENKzp1Hu+VrLD+y95vc2wxs0SAi7cJXpSSFMID63T6V2Ust7frqsanKWmKMARGei9ML+tPdb+X0kqPWE2yHPQFGRsv4MOebeceTB24sD26EcDY4lkfupqQmxw7euhfUouDBiQCTXbRwVUPAsOZcgMJ8vg7ihE6x/5lA7mZ0ZrOud0EnzmoTVmdA==
Received: from MW2PR2101CA0007.namprd21.prod.outlook.com (2603:10b6:302:1::20)
 by IA0PR12MB7721.namprd12.prod.outlook.com (2603:10b6:208:433::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.38; Thu, 2 Feb
 2023 18:00:51 +0000
Received: from CO1NAM11FT003.eop-nam11.prod.protection.outlook.com
 (2603:10b6:302:1:cafe::6f) by MW2PR2101CA0007.outlook.office365.com
 (2603:10b6:302:1::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.7 via Frontend
 Transport; Thu, 2 Feb 2023 18:00:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CO1NAM11FT003.mail.protection.outlook.com (10.13.175.93) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6064.27 via Frontend Transport; Thu, 2 Feb 2023 18:00:51 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 2 Feb 2023
 10:00:33 -0800
Received: from localhost.localdomain (10.126.230.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 2 Feb 2023
 10:00:31 -0800
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
Subject: [PATCH net-next v3 07/16] net: bridge: Maintain number of MDB entries in net_bridge_mcast_port
Date:   Thu, 2 Feb 2023 18:59:25 +0100
Message-ID: <8bd6e90beed928790059134471ecbb9c3d327894.1675359453.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <cover.1675359453.git.petrm@nvidia.com>
References: <cover.1675359453.git.petrm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.230.37]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT003:EE_|IA0PR12MB7721:EE_
X-MS-Office365-Filtering-Correlation-Id: b574d99b-6d12-4508-bc57-08db05476bd0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XzGc/3MJpSOOzsY/h+sQ5VMKV7Vqejf5nag3O1dy1xT+zKBNfa/S7nDANpMUqYttHfVOh9FO4yYwlGxsXHlQKmGqF1k8f6izNLGI+9snCq/K4+36cXqiijPKBqA6RO27uOLYkUg8OWzpDjLIprlAXdpcApV4tXh2sLmMMY5GuvX8FZxjfJWA9TMw+yN41ZyctXHy3QlkfEr0FTvaqFujLd6+vhf84fYu8rdBtRNEAz2l0WhTH2fUudIY/9t/aJ5AFxQ33uHJDNCeDH42Vy33oXOnUTTk56NU3ddDUZqGg7qA9EUn1U5Cbi/lOIrpVVQ8yBxRJ/CRqo8yqQh8S7O4gE/F9WmE3Hpkh8+JA5Ifa1YKbTAPp/snjTcpCY45cnFMirBHZKM+xbd8TtfhKRkqFRPntbbWDeHbyJKUBe1ee5g6SazKOcgIn3gBCbYVImv6Z8aCzQE4JOrBj2KhO4gR+GjcGRS/bJrn2/H+jVuCv/Y1j0QRJoKy9czqFIIS5V5c6mXQ8p4vslZRVauBaoZI2yzQt4mAhjQR7PIxRvcbTyS1XfzybZMwLAbzPX49vMHbRjfnSNOwKAf9IkQC7UDGepYnqEzV5VfUYtVzirXrp2zkG2Hiod7aXEB4lA3d2+IZBI/15YdvNUUqmmQjGjWCNCjlhUCFx1N0s4tIecJ6fXtEsvdI+1nT6+3a5KdD2DG4WiKsw/jvMJUwnd/d2bthyg==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(136003)(376002)(396003)(39860400002)(346002)(451199018)(36840700001)(40470700004)(46966006)(356005)(86362001)(7636003)(36860700001)(36756003)(82740400003)(70206006)(70586007)(54906003)(110136005)(5660300002)(82310400005)(8936002)(316002)(4326008)(8676002)(47076005)(426003)(2906002)(336012)(40480700001)(83380400001)(2616005)(478600001)(40460700003)(26005)(186003)(16526019)(107886003)(41300700001)(66574015)(6666004);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2023 18:00:51.1309
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b574d99b-6d12-4508-bc57-08db05476bd0
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT003.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB7721
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

Signed-off-by: Petr Machata <petrm@nvidia.com>
---

Notes:
    v3:
    - Access mdb_max_/_n_entries through READ_/WRITE_ONCE
    - Move extack setting to br_multicast_port_ngroups_inc_one().
      Since we use NL_SET_ERR_MSG_FMT_MOD, the correct context
      (port / port-vlan) can be passed through an argument.
      This also removes the need for more READ/WRITE_ONCE's
      at the extack-setting site.
    
    v2:
    - In br_multicast_port_ngroups_inc_one(), bounce
      if n>=max, not if n==max
    - Adjust extack messages to mention ngroups, now that
      the bounces appear when n>=max, not n==max
    - In __br_multicast_enable_port_ctx(), do not reset
      max to 0. Also do not count number of entries by
      going through _inc, as that would end up incorrectly
      bouncing the entries.

 net/bridge/br_multicast.c | 136 +++++++++++++++++++++++++++++++++++++-
 net/bridge/br_private.h   |   2 +
 2 files changed, 137 insertions(+), 1 deletion(-)

diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index 51b622afdb67..b6aa0bad5817 100644
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
@@ -668,6 +692,86 @@ void br_multicast_del_group_src(struct net_bridge_group_src *src,
 	__br_multicast_del_group_src(src);
 }
 
+static int
+br_multicast_port_ngroups_inc_one(struct net_bridge_mcast_port *pmctx,
+				  struct netlink_ext_ack *extack,
+				  const char *what)
+{
+	u32 max = READ_ONCE(pmctx->mdb_max_entries);
+	u32 n = READ_ONCE(pmctx->mdb_n_entries);
+
+	if (max && n >= max) {
+		NL_SET_ERR_MSG_FMT_MOD(extack, "%s is already in %u groups, and mcast_max_groups=%u",
+				       what, n, max);
+		return -E2BIG;
+	}
+
+	WRITE_ONCE(pmctx->mdb_n_entries, n + 1);
+	return 0;
+}
+
+static void br_multicast_port_ngroups_dec_one(struct net_bridge_mcast_port *pmctx)
+{
+	u32 n = READ_ONCE(pmctx->mdb_n_entries);
+
+	WARN_ON_ONCE(n == 0);
+	WRITE_ONCE(pmctx->mdb_n_entries, n - 1);
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
+	err = br_multicast_port_ngroups_inc_one(&port->multicast_ctx, extack,
+						"Port");
+	if (err) {
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
+	err = br_multicast_port_ngroups_inc_one(pmctx, extack, "Port-VLAN");
+	if (err) {
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
@@ -702,6 +806,7 @@ void br_multicast_del_pg(struct net_bridge_mdb_entry *mp,
 	} else {
 		br_multicast_star_g_handle_mode(pg, MCAST_INCLUDE);
 	}
+	br_multicast_port_ngroups_dec(pg->key.port, pg->key.addr.vid);
 	hlist_add_head(&pg->mcast_gc.gc_node, &br->mcast_gc_list);
 	queue_work(system_long_wq, &br->mcast_gc_work);
 
@@ -1165,6 +1270,7 @@ struct net_bridge_mdb_entry *br_multicast_new_group(struct net_bridge *br,
 		return mp;
 
 	if (atomic_read(&br->mdb_hash_tbl.nelems) >= br->hash_max) {
+		trace_br_mdb_full(br->dev, group);
 		br_mc_disabled_update(br->dev, false, NULL);
 		br_opt_toggle(br, BROPT_MULTICAST_ENABLED, false);
 		return ERR_PTR(-E2BIG);
@@ -1288,11 +1394,16 @@ struct net_bridge_port_group *br_multicast_new_port_group(
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
@@ -1326,18 +1437,22 @@ struct net_bridge_port_group *br_multicast_new_port_group(
 
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
@@ -1951,6 +2066,25 @@ static void __br_multicast_enable_port_ctx(struct net_bridge_mcast_port *pmctx)
 		br_ip4_multicast_add_router(brmctx, pmctx);
 		br_ip6_multicast_add_router(brmctx, pmctx);
 	}
+
+	if (br_multicast_port_ctx_is_vlan(pmctx)) {
+		struct net_bridge_port_group *pg;
+		u32 n = 0;
+
+		/* The mcast_n_groups counter might be wrong. First,
+		 * BR_VLFLAG_MCAST_ENABLED is toggled before temporary entries
+		 * are flushed, thus mcast_n_groups after the toggle does not
+		 * reflect the true values. And second, permanent entries added
+		 * while BR_VLFLAG_MCAST_ENABLED was disabled, are not reflected
+		 * either. Thus we have to refresh the counter.
+		 */
+
+		hlist_for_each_entry(pg, &pmctx->port->mglist, mglist) {
+			if (pg->key.addr.vid == pmctx->vlan->vid)
+				n++;
+		}
+		WRITE_ONCE(pmctx->mdb_n_entries, n);
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

