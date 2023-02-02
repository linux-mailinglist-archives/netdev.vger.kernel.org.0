Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65E1B6885E6
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 19:01:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232007AbjBBSBS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 13:01:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232019AbjBBSBC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 13:01:02 -0500
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2057.outbound.protection.outlook.com [40.107.102.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C570E77DC4
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 10:00:55 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=haylxYLqNR5pW4TQZuGoNOLkyk/22+hH+Tui8Z2lHCCkxL0F0c19PcDn6Gnl4iMpumBnT0M9+UCixCpT7C/8eC4EIG+6TS01s+EsyYiSycwiD44hA7MZJ54rRvb2aLMzzRwc7d5KK7XgLQCdj0XHRNmg40Gek7v7FwUw1s96nwbyy/W3XIjezVe/uOikZqWOVc1yrvX+iW/jZaI7jzoaja2QlH+K424+dFWlucL1jcTNTV9KGBC4XJsd+eaAYKIeE3mlhYqhKx0OfFY6DgUMaehJ3++7NWBZDwBH1QNymmgCdglyjS0be/cIz0FnePdR0tjPs2KacxtLCYYReyvyRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LzU5L2f1g5Pc+95aJ6yIGgoSXVJnbHv9nAHTRS/gC8U=;
 b=SL9xnp2OAHIbp6UAzGaz/hCReEJsWYqztjVu89aCJfc3ntCjRW1jJuyWB3iuV9eRELTQ9xxsQgMJPt6qRzq6rkVwLjRTCX7uaCx1Zrv7JzczSYQJLMF2LAyTjOow4ApTH4mYZiAFVdNnFAOfWS1IYPFgM9Obfw10RpO0I43631fcoH3QuiaThgFMKU4LC7TqClEW7aiGSWzCLqCsaO85soFcyeU1RGTCmeQmT7eZyzSOVxt0Kyx1EirXIioNE5UPiom58KB+L76G6SGGAe6RUxZxg8R2PNujrjnv7Xv13KDC1SgnfTNBc7UOds39ABh2fb6JN0G1wu2rm7p3p/DS5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LzU5L2f1g5Pc+95aJ6yIGgoSXVJnbHv9nAHTRS/gC8U=;
 b=XYCfaVS/w5lvT4/WR9dICrFyRFkey/xfQmcJXglDHeEsfXNDIMdrEqCJxbLwYzbNuDV4BGBfMqQ5urCVFtnRMirRCuhchNi4tu/HKT6DEqEkRzIgrJQSMn+ZF5oJYnRVyP4A7jOyd4N/1cCPXPxoVDG/oSI39cjjL6UdUfU0hJSS7vdEKHvO4oYQy6OgfKuYpa7XZXY3lQNE1GoaOHID4Op8o+3nC3CFInwvLxYCsBLV/GandmslPVGvNaDfcPl/36GWMKktDgXktsWlP6Y9qX31ZmIhsYmiTowSk+6w3BBsOUwCwkACf78zbhe/LJnmC7Bj8iyjp90cUqgf0PxqCg==
Received: from MW4PR03CA0187.namprd03.prod.outlook.com (2603:10b6:303:b8::12)
 by DM6PR12MB4188.namprd12.prod.outlook.com (2603:10b6:5:215::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.25; Thu, 2 Feb
 2023 18:00:53 +0000
Received: from CO1NAM11FT010.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:b8:cafe::20) by MW4PR03CA0187.outlook.office365.com
 (2603:10b6:303:b8::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.27 via Frontend
 Transport; Thu, 2 Feb 2023 18:00:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CO1NAM11FT010.mail.protection.outlook.com (10.13.175.88) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6064.28 via Frontend Transport; Thu, 2 Feb 2023 18:00:53 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 2 Feb 2023
 10:00:36 -0800
Received: from localhost.localdomain (10.126.230.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 2 Feb 2023
 10:00:34 -0800
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
Subject: [PATCH net-next v3 08/16] net: bridge: Add netlink knobs for number / maximum MDB entries
Date:   Thu, 2 Feb 2023 18:59:26 +0100
Message-ID: <ad5b9a4a971f7a38951cb8475ca3c9a16057b0fd.1675359453.git.petrm@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CO1NAM11FT010:EE_|DM6PR12MB4188:EE_
X-MS-Office365-Filtering-Correlation-Id: f8e5a999-3b6e-4468-73f3-08db05476d50
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: McBl2RUbvHASHZDHvxblyE/uV8c1Z3HdRa3n5y9fTgluLOz2uP0Nnfa+h/kuLe1tdPSHqbwwwweqgY3tsq1QS7+NWMWNucSRfLFKX95/dz4Iw/YU1QsLOo6AyYjb/MXLihSrNBuru3GEW5C+Gt5i7X98dFJvBjNkHHChzg4eDrSTI26JjMd6SEaaWpZX66Fk6Hkl422f5reId1CuQCDK3adeX4boMPtT807qR6MFQ1nmJKcT2V9ShBkEeXL29DvDjELm+B+fh95dPleE2kq/AIWwDW1pp0ut1U2c3Ag2rGlLcCdk5nkhZ4d8ZSBQB93klKY9gK6Zzipqtuoc9M6VxovCtwF+LAgPUcXe1XZMGLMNLA5e5NtZpgkRmbr3PuBYTDoHhqt1fhvX+7EIkkczZI4vpS0m2yDXkE9JkpNERvIOMYa4Fyvv7gIAsFdZfR0e1OgNSi6zwwvhmbk/HiqnUTJNId3jiJqz+lDqCY6+rD9Jpi9Ev75foEB5gwj7nQPPxv+Rz+qFJXDG3IyhAFfMkJykIbCFpUpmn4U4wsOY0sovKDpcvmea0bb8j/tBluq1ZIrWkXZk3F0fBJBxCWCDZlUWdrdNpwYQhCpuLcfcDzaO52Fj6q7imq52zcZp/4v7ILhDgZKKHCPERgYuAl7SoYxkk8UFo8HBVS6dYoTWQ4toQHxVWYr7fi0fVjNJqCilfk7+bklx8SrjKDu1kGhvVA==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(376002)(136003)(346002)(39860400002)(396003)(451199018)(36840700001)(46966006)(40470700004)(30864003)(8936002)(2616005)(110136005)(54906003)(5660300002)(4326008)(316002)(2906002)(8676002)(41300700001)(70206006)(70586007)(26005)(478600001)(6666004)(186003)(16526019)(83380400001)(336012)(107886003)(426003)(66574015)(82310400005)(356005)(47076005)(7636003)(40480700001)(86362001)(40460700003)(36756003)(82740400003)(36860700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2023 18:00:53.6300
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f8e5a999-3b6e-4468-73f3-08db05476d50
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT010.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4188
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The previous patch added accounting for number of MDB entries per port and
per port-VLAN, and the logic to verify that these values stay within
configured bounds. However it didn't provide means to actually configure
those bounds or read the occupancy. This patch does that.

Two new netlink attributes are added for the MDB occupancy:
IFLA_BRPORT_MCAST_N_GROUPS for the per-port occupancy and
BRIDGE_VLANDB_ENTRY_MCAST_N_GROUPS for the per-port-VLAN occupancy.
And another two for the maximum number of MDB entries:
IFLA_BRPORT_MCAST_MAX_GROUPS for the per-port maximum, and
BRIDGE_VLANDB_ENTRY_MCAST_MAX_GROUPS for the per-port-VLAN one.

Note that the two new IFLA_BRPORT_ attributes prompt bumping of
RTNL_SLAVE_MAX_TYPE to size the slave attribute tables large enough.

The new attributes are used like this:

 # ip link add name br up type bridge vlan_filtering 1 mcast_snooping 1 \
                                      mcast_vlan_snooping 1 mcast_querier 1
 # ip link set dev v1 master br
 # bridge vlan add dev v1 vid 2

 # bridge vlan set dev v1 vid 1 mcast_max_groups 1
 # bridge mdb add dev br port v1 grp 230.1.2.3 temp vid 1
 # bridge mdb add dev br port v1 grp 230.1.2.4 temp vid 1
 Error: bridge: Port-VLAN is already in 1 groups, and mcast_max_groups=1.

 # bridge link set dev v1 mcast_max_groups 1
 # bridge mdb add dev br port v1 grp 230.1.2.3 temp vid 2
 Error: bridge: Port is already in 1 groups, and mcast_max_groups=1.

 # bridge -d link show
 5: v1@v2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 master br [...]
     [...] mcast_n_groups 1 mcast_max_groups 1

 # bridge -d vlan show
 port              vlan-id
 br                1 PVID Egress Untagged
                     state forwarding mcast_router 1
 v1                1 PVID Egress Untagged
                     [...] mcast_n_groups 1 mcast_max_groups 1
                   2
                     [...] mcast_n_groups 0 mcast_max_groups 0

Signed-off-by: Petr Machata <petrm@nvidia.com>
---

Notes:
    v3:
    - Move the br_multicast_port_ctx_vlan_disabled() check
      out to the _vlan_ helpers callers. Thus these helpers
      cannot fail, which makes them very similar to the
      _port_ helpers. Have them take the MC context directly
      and unify them.
    
    v2:
    - Drop locks around accesses in
      br_multicast_{port,vlan}_ngroups_{get,set_max}(),
    - Drop bounces due to max<n in
      br_multicast_{port,vlan}_ngroups_set_max().

 include/uapi/linux/if_bridge.h |  2 ++
 include/uapi/linux/if_link.h   |  2 ++
 net/bridge/br_multicast.c      | 15 +++++++++++++++
 net/bridge/br_netlink.c        | 17 ++++++++++++++++-
 net/bridge/br_private.h        |  6 +++++-
 net/bridge/br_vlan.c           | 11 +++++++----
 net/bridge/br_vlan_options.c   | 27 ++++++++++++++++++++++++++-
 net/core/rtnetlink.c           |  2 +-
 8 files changed, 74 insertions(+), 8 deletions(-)

diff --git a/include/uapi/linux/if_bridge.h b/include/uapi/linux/if_bridge.h
index d9de241d90f9..d60c456710b3 100644
--- a/include/uapi/linux/if_bridge.h
+++ b/include/uapi/linux/if_bridge.h
@@ -523,6 +523,8 @@ enum {
 	BRIDGE_VLANDB_ENTRY_TUNNEL_INFO,
 	BRIDGE_VLANDB_ENTRY_STATS,
 	BRIDGE_VLANDB_ENTRY_MCAST_ROUTER,
+	BRIDGE_VLANDB_ENTRY_MCAST_N_GROUPS,
+	BRIDGE_VLANDB_ENTRY_MCAST_MAX_GROUPS,
 	__BRIDGE_VLANDB_ENTRY_MAX,
 };
 #define BRIDGE_VLANDB_ENTRY_MAX (__BRIDGE_VLANDB_ENTRY_MAX - 1)
diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index 1021a7e47a86..1bed3a72939c 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -564,6 +564,8 @@ enum {
 	IFLA_BRPORT_MCAST_EHT_HOSTS_CNT,
 	IFLA_BRPORT_LOCKED,
 	IFLA_BRPORT_MAB,
+	IFLA_BRPORT_MCAST_N_GROUPS,
+	IFLA_BRPORT_MCAST_MAX_GROUPS,
 	__IFLA_BRPORT_MAX
 };
 #define IFLA_BRPORT_MAX (__IFLA_BRPORT_MAX - 1)
diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index b6aa0bad5817..96d1fc78dd39 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -772,6 +772,21 @@ static void br_multicast_port_ngroups_dec(struct net_bridge_port *port, u16 vid)
 	br_multicast_port_ngroups_dec_one(&port->multicast_ctx);
 }
 
+u32 br_multicast_ngroups_get(const struct net_bridge_mcast_port *pmctx)
+{
+	return READ_ONCE(pmctx->mdb_n_entries);
+}
+
+void br_multicast_ngroups_set_max(struct net_bridge_mcast_port *pmctx, u32 max)
+{
+	WRITE_ONCE(pmctx->mdb_max_entries, max);
+}
+
+u32 br_multicast_ngroups_get_max(const struct net_bridge_mcast_port *pmctx)
+{
+	return READ_ONCE(pmctx->mdb_max_entries);
+}
+
 static void br_multicast_destroy_port_group(struct net_bridge_mcast_gc *gc)
 {
 	struct net_bridge_port_group *pg;
diff --git a/net/bridge/br_netlink.c b/net/bridge/br_netlink.c
index a6133d469885..9173e52b89e2 100644
--- a/net/bridge/br_netlink.c
+++ b/net/bridge/br_netlink.c
@@ -202,6 +202,8 @@ static inline size_t br_port_info_size(void)
 		+ nla_total_size_64bit(sizeof(u64)) /* IFLA_BRPORT_HOLD_TIMER */
 #ifdef CONFIG_BRIDGE_IGMP_SNOOPING
 		+ nla_total_size(sizeof(u8))	/* IFLA_BRPORT_MULTICAST_ROUTER */
+		+ nla_total_size(sizeof(u32))	/* IFLA_BRPORT_MCAST_N_GROUPS */
+		+ nla_total_size(sizeof(u32))	/* IFLA_BRPORT_MCAST_MAX_GROUPS */
 #endif
 		+ nla_total_size(sizeof(u16))	/* IFLA_BRPORT_GROUP_FWD_MASK */
 		+ nla_total_size(sizeof(u8))	/* IFLA_BRPORT_MRP_RING_OPEN */
@@ -298,7 +300,11 @@ static int br_port_fill_attrs(struct sk_buff *skb,
 	    nla_put_u32(skb, IFLA_BRPORT_MCAST_EHT_HOSTS_LIMIT,
 			p->multicast_eht_hosts_limit) ||
 	    nla_put_u32(skb, IFLA_BRPORT_MCAST_EHT_HOSTS_CNT,
-			p->multicast_eht_hosts_cnt))
+			p->multicast_eht_hosts_cnt) ||
+	    nla_put_u32(skb, IFLA_BRPORT_MCAST_N_GROUPS,
+			br_multicast_ngroups_get(&p->multicast_ctx)) ||
+	    nla_put_u32(skb, IFLA_BRPORT_MCAST_MAX_GROUPS,
+			br_multicast_ngroups_get_max(&p->multicast_ctx)))
 		return -EMSGSIZE;
 #endif
 
@@ -883,6 +889,8 @@ static const struct nla_policy br_port_policy[IFLA_BRPORT_MAX + 1] = {
 	[IFLA_BRPORT_MAB] = { .type = NLA_U8 },
 	[IFLA_BRPORT_BACKUP_PORT] = { .type = NLA_U32 },
 	[IFLA_BRPORT_MCAST_EHT_HOSTS_LIMIT] = { .type = NLA_U32 },
+	[IFLA_BRPORT_MCAST_N_GROUPS] = { .type = NLA_REJECT },
+	[IFLA_BRPORT_MCAST_MAX_GROUPS] = { .type = NLA_U32 },
 };
 
 /* Change the state of the port and notify spanning tree */
@@ -1017,6 +1025,13 @@ static int br_setport(struct net_bridge_port *p, struct nlattr *tb[],
 		if (err)
 			return err;
 	}
+
+	if (tb[IFLA_BRPORT_MCAST_MAX_GROUPS]) {
+		u32 max_groups;
+
+		max_groups = nla_get_u32(tb[IFLA_BRPORT_MCAST_MAX_GROUPS]);
+		br_multicast_ngroups_set_max(&p->multicast_ctx, max_groups);
+	}
 #endif
 
 	if (tb[IFLA_BRPORT_GROUP_FWD_MASK]) {
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 49f411a0a1f1..cef5f6ea850c 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -978,6 +978,9 @@ void br_multicast_uninit_stats(struct net_bridge *br);
 void br_multicast_get_stats(const struct net_bridge *br,
 			    const struct net_bridge_port *p,
 			    struct br_mcast_stats *dest);
+u32 br_multicast_ngroups_get(const struct net_bridge_mcast_port *pmctx);
+void br_multicast_ngroups_set_max(struct net_bridge_mcast_port *pmctx, u32 max);
+u32 br_multicast_ngroups_get_max(const struct net_bridge_mcast_port *pmctx);
 void br_mdb_init(void);
 void br_mdb_uninit(void);
 void br_multicast_host_join(const struct net_bridge_mcast *brmctx,
@@ -1761,7 +1764,8 @@ static inline u16 br_vlan_flags(const struct net_bridge_vlan *v, u16 pvid)
 #ifdef CONFIG_BRIDGE_VLAN_FILTERING
 bool br_vlan_opts_eq_range(const struct net_bridge_vlan *v_curr,
 			   const struct net_bridge_vlan *range_end);
-bool br_vlan_opts_fill(struct sk_buff *skb, const struct net_bridge_vlan *v);
+bool br_vlan_opts_fill(struct sk_buff *skb, const struct net_bridge_vlan *v,
+		       const struct net_bridge_port *p);
 size_t br_vlan_opts_nl_size(void);
 int br_vlan_process_options(const struct net_bridge *br,
 			    const struct net_bridge_port *p,
diff --git a/net/bridge/br_vlan.c b/net/bridge/br_vlan.c
index bc75fa1e4666..8a3dbc09ba38 100644
--- a/net/bridge/br_vlan.c
+++ b/net/bridge/br_vlan.c
@@ -1816,6 +1816,7 @@ static bool br_vlan_stats_fill(struct sk_buff *skb,
 /* v_opts is used to dump the options which must be equal in the whole range */
 static bool br_vlan_fill_vids(struct sk_buff *skb, u16 vid, u16 vid_range,
 			      const struct net_bridge_vlan *v_opts,
+			      const struct net_bridge_port *p,
 			      u16 flags,
 			      bool dump_stats)
 {
@@ -1842,7 +1843,7 @@ static bool br_vlan_fill_vids(struct sk_buff *skb, u16 vid, u16 vid_range,
 		goto out_err;
 
 	if (v_opts) {
-		if (!br_vlan_opts_fill(skb, v_opts))
+		if (!br_vlan_opts_fill(skb, v_opts, p))
 			goto out_err;
 
 		if (dump_stats && !br_vlan_stats_fill(skb, v_opts))
@@ -1925,7 +1926,7 @@ void br_vlan_notify(const struct net_bridge *br,
 		goto out_kfree;
 	}
 
-	if (!br_vlan_fill_vids(skb, vid, vid_range, v, flags, false))
+	if (!br_vlan_fill_vids(skb, vid, vid_range, v, p, flags, false))
 		goto out_err;
 
 	nlmsg_end(skb, nlh);
@@ -2030,7 +2031,7 @@ static int br_vlan_dump_dev(const struct net_device *dev,
 
 			if (!br_vlan_fill_vids(skb, range_start->vid,
 					       range_end->vid, range_start,
-					       vlan_flags, dump_stats)) {
+					       p, vlan_flags, dump_stats)) {
 				err = -EMSGSIZE;
 				break;
 			}
@@ -2056,7 +2057,7 @@ static int br_vlan_dump_dev(const struct net_device *dev,
 		else if (!dump_global &&
 			 !br_vlan_fill_vids(skb, range_start->vid,
 					    range_end->vid, range_start,
-					    br_vlan_flags(range_start, pvid),
+					    p, br_vlan_flags(range_start, pvid),
 					    dump_stats))
 			err = -EMSGSIZE;
 	}
@@ -2131,6 +2132,8 @@ static const struct nla_policy br_vlan_db_policy[BRIDGE_VLANDB_ENTRY_MAX + 1] =
 	[BRIDGE_VLANDB_ENTRY_STATE]	= { .type = NLA_U8 },
 	[BRIDGE_VLANDB_ENTRY_TUNNEL_INFO] = { .type = NLA_NESTED },
 	[BRIDGE_VLANDB_ENTRY_MCAST_ROUTER]	= { .type = NLA_U8 },
+	[BRIDGE_VLANDB_ENTRY_MCAST_N_GROUPS]	= { .type = NLA_REJECT },
+	[BRIDGE_VLANDB_ENTRY_MCAST_MAX_GROUPS]	= { .type = NLA_U32 },
 };
 
 static int br_vlan_rtm_process_one(struct net_device *dev,
diff --git a/net/bridge/br_vlan_options.c b/net/bridge/br_vlan_options.c
index a2724d03278c..e378c2f3a9e2 100644
--- a/net/bridge/br_vlan_options.c
+++ b/net/bridge/br_vlan_options.c
@@ -48,7 +48,8 @@ bool br_vlan_opts_eq_range(const struct net_bridge_vlan *v_curr,
 	       curr_mc_rtr == range_mc_rtr;
 }
 
-bool br_vlan_opts_fill(struct sk_buff *skb, const struct net_bridge_vlan *v)
+bool br_vlan_opts_fill(struct sk_buff *skb, const struct net_bridge_vlan *v,
+		       const struct net_bridge_port *p)
 {
 	if (nla_put_u8(skb, BRIDGE_VLANDB_ENTRY_STATE, br_vlan_get_state(v)) ||
 	    !__vlan_tun_put(skb, v))
@@ -58,6 +59,12 @@ bool br_vlan_opts_fill(struct sk_buff *skb, const struct net_bridge_vlan *v)
 	if (nla_put_u8(skb, BRIDGE_VLANDB_ENTRY_MCAST_ROUTER,
 		       br_vlan_multicast_router(v)))
 		return false;
+	if (p && !br_multicast_port_ctx_vlan_disabled(&v->port_mcast_ctx) &&
+	    (nla_put_u32(skb, BRIDGE_VLANDB_ENTRY_MCAST_N_GROUPS,
+			 br_multicast_ngroups_get(&v->port_mcast_ctx)) ||
+	     nla_put_u32(skb, BRIDGE_VLANDB_ENTRY_MCAST_MAX_GROUPS,
+			 br_multicast_ngroups_get_max(&v->port_mcast_ctx))))
+		return false;
 #endif
 
 	return true;
@@ -70,6 +77,8 @@ size_t br_vlan_opts_nl_size(void)
 	       + nla_total_size(sizeof(u32)) /* BRIDGE_VLANDB_TINFO_ID */
 #ifdef CONFIG_BRIDGE_IGMP_SNOOPING
 	       + nla_total_size(sizeof(u8)) /* BRIDGE_VLANDB_ENTRY_MCAST_ROUTER */
+	       + nla_total_size(sizeof(u32)) /* BRIDGE_VLANDB_ENTRY_MCAST_N_GROUPS */
+	       + nla_total_size(sizeof(u32)) /* BRIDGE_VLANDB_ENTRY_MCAST_MAX_GROUPS */
 #endif
 	       + 0;
 }
@@ -212,6 +221,22 @@ static int br_vlan_process_one_opts(const struct net_bridge *br,
 			return err;
 		*changed = true;
 	}
+	if (tb[BRIDGE_VLANDB_ENTRY_MCAST_MAX_GROUPS]) {
+		u32 val;
+
+		if (!p) {
+			NL_SET_ERR_MSG_MOD(extack, "Can't set mcast_max_groups for non-port vlans");
+			return -EINVAL;
+		}
+		if (br_multicast_port_ctx_vlan_disabled(&v->port_mcast_ctx)) {
+			NL_SET_ERR_MSG_MOD(extack, "Multicast snooping disabled on this VLAN");
+			return -EINVAL;
+		}
+
+		val = nla_get_u32(tb[BRIDGE_VLANDB_ENTRY_MCAST_MAX_GROUPS]);
+		br_multicast_ngroups_set_max(&v->port_mcast_ctx, val);
+		*changed = true;
+	}
 #endif
 
 	return 0;
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 64289bc98887..e786255a8360 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -58,7 +58,7 @@
 #include "dev.h"
 
 #define RTNL_MAX_TYPE		50
-#define RTNL_SLAVE_MAX_TYPE	40
+#define RTNL_SLAVE_MAX_TYPE	42
 
 struct rtnl_link {
 	rtnl_doit_func		doit;
-- 
2.39.0

