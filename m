Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96F43337BAC
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 19:05:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230200AbhCKSEl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 13:04:41 -0500
Received: from mail-bn8nam11on2074.outbound.protection.outlook.com ([40.107.236.74]:9857
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229921AbhCKSEP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Mar 2021 13:04:15 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ToWQE21ao52mG1HztRFi+rk9IztVxw8/63GQKby2vBrBm5CIWQA5PQe1P22CCyE7PT65Zt0Ubg1C2xGD8DhQCBbtYqYCcObWpDo/6NBh4exhyLtIPwDaT1AtpC3jSyl8+s2ZqSdHwT8dEE+FIYnbwHnFSJ7lh2sA4Yt7ws8SjidBYAjwiCfFTTaZezXd4bY/XuxDHZy0dznEwpRfEzi+WS4+58SROL5Y8//uNTFT+nIq9DJhmnzCotPhdsTwuHRzNLIQY+7UOYuVVLpjjAuqDZC8vgkbB0U6BsMc9rbWl5RZBv4Ol8m0wPWeGZVU05/+b5Ootl/3o2ZmpBRptMjB4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5bhXiwoYOEiyOAhDhWPto7M0xjhVBq6h6OvWNhNl1hI=;
 b=CjUZ35wwbSZSbM267ggIuqCQDzXwg4qMEHBxoGlon3NrBuy9LptuGHY4A3PwaXs73v2PBh2e7L+azYB+sjOR2jheLwbnZ4O/nb+M72s9SI3pUN/iFEFKo8PiJYiuP8fo/DPq/ywgwQ0CVdgBS+jld/VCLM6Onprj4iFoHWDmRr1R1tkI/3gIZiIFL4lo4t7MQpM36LEAyC4U8g3OmDh6HCzdUNHOU3luZozRurSb5r+6gAWNOM9bbSpJGS4xUldTycOoOsa4pX3dPZltF9/lFLCZ/JiNoZ95seeQi5mk9dPu40wSHSIdfwOjJ6py/PX4XqmwEfOcICKIzhCNBF1Kdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5bhXiwoYOEiyOAhDhWPto7M0xjhVBq6h6OvWNhNl1hI=;
 b=N/ytHROM+HIbRbvCJBd/BYsguiidpPqlDuYImMVaEGlKG2I6DYYdzWXuskMLe51BT4uruk0NOUrhpS5fqWXSte466cnx8/iuGNQBDeIcrPrkia0K4RTH6cSIkKk4Xypg3zMeoUZ6nw6k0jLR5Ldb4pgjM9bEEjTwVMnw0bO8pPm58eaMLXccwtV6asevg5Q1chG/8qIjvcjZ1l3MuYpjh8hIP9URfXMCyIIWZjqqtbDbSAtxQcuks3mlCFj6uiKbgKQz6S1MO2P0i5oN2sOlqb7q/xScd48O14BQVQ921jeY/PcpgD8yUBtuS1cH6mCb4/p+HPV05qVxy7KH1R9a5Q==
Received: from BN6PR13CA0036.namprd13.prod.outlook.com (2603:10b6:404:13e::22)
 by BN6PR1201MB0195.namprd12.prod.outlook.com (2603:10b6:405:53::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.31; Thu, 11 Mar
 2021 18:04:10 +0000
Received: from BN8NAM11FT060.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:13e:cafe::85) by BN6PR13CA0036.outlook.office365.com
 (2603:10b6:404:13e::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.10 via Frontend
 Transport; Thu, 11 Mar 2021 18:04:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT060.mail.protection.outlook.com (10.13.177.211) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3933.31 via Frontend Transport; Thu, 11 Mar 2021 18:04:09 +0000
Received: from localhost.localdomain (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 11 Mar
 2021 18:04:06 +0000
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     Ido Schimmel <idosch@nvidia.com>, David Ahern <dsahern@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Petr Machata" <petrm@nvidia.com>
Subject: [PATCH net-next v2 05/14] nexthop: Add implementation of resilient next-hop groups
Date:   Thu, 11 Mar 2021 19:03:16 +0100
Message-ID: <5c825c1efed976ad3cd036256d8ca3232de9a294.1615485052.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1615485052.git.petrm@nvidia.com>
References: <cover.1615485052.git.petrm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c155ec2d-0431-4856-65ca-08d8e4b81200
X-MS-TrafficTypeDiagnostic: BN6PR1201MB0195:
X-Microsoft-Antispam-PRVS: <BN6PR1201MB0195CDD5A7EA495094E184BDD6909@BN6PR1201MB0195.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QRRcty7JP/Kry2DnKDLkkZq9fr5GcvAshKjnebF4PWSwGz+qxqFnds+2ItLwU004DRX/29jO0DxlObwtJZ9pqWaEA1es56Ju4ICsAsNrR1n/u8NzLaB7spLlMcMBmhbVKEtvK+Ot3MCPzqvdFg23391ECySQFgtgk91VsI2h8DAz9DBno6psSYNMFgaor4qpTv4fKNWTzMpi6whYjqtY60bs5MIx7N+ZA3OZ8F/40TRRN42Zp90Wtb+5P04KtIn+Oi+zTZL9dcVKe7rLX8T5iC+bvMrELbd5ocTDwtFqyceabYS+02xVt6NIFUrDH+UOyHdsJQ1Sf1MFzKWmsv2wAZkroORa7RBw1BZP6CzlK2BKam9H/mWfN9NbItgs9ncSx6AFCf/ZXhKJdI8nkoXRuaVW5IqBc/0sRtxx4/VULo3a7fX4I1UX7RNstErRMEWBdaGe+5L7O1Silr1wKYmR0bLefeJDhQIkVnO3jIYWCtLvEHRNO97ZwxWyVnVniP6l5ZpZ7WYFX4Ql2KiwDkmB1DvROopttVEA/p9SrTGFWYGt3d+qXrQK72xG8s/JlkwUIs6PRtxfy+ILDaKhYVHFxn8+pwcrWKT3eMU5PptGcXFtDAZ4KYC62gzwGjDK0qCx2VtBbN2dNkRd7mxydiA+tKddpbNfM+RL45AzUjMpGEBfiu/iBNTFFx1NdOfFSzV7
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(136003)(376002)(346002)(396003)(36840700001)(46966006)(6916009)(82740400003)(356005)(47076005)(36756003)(30864003)(8936002)(26005)(107886003)(2906002)(6666004)(36860700001)(86362001)(7636003)(186003)(83380400001)(16526019)(336012)(70586007)(36906005)(8676002)(4326008)(5660300002)(478600001)(426003)(2616005)(54906003)(34020700004)(316002)(82310400003)(70206006);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2021 18:04:09.8397
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c155ec2d-0431-4856-65ca-08d8e4b81200
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT060.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1201MB0195
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

At this moment, there is only one type of next-hop group: an mpath group,
which implements the hash-threshold algorithm.

To select a next hop, hash-threshold algorithm first assigns a range of
hashes to each next hop in the group, and then selects the next hop by
comparing the SKB hash with the individual ranges. When a next hop is
removed from the group, the ranges are recomputed, which leads to
reassignment of parts of hash space from one next hop to another. While
there will usually be some overlap between the previous and the new
distribution, some traffic flows change the next hop that they resolve to.
That causes problems e.g. as established TCP connections are reset, because
the traffic is forwarded to a server that is not familiar with the
connection.

Resilient hashing is a technique to address the above problem. Resilient
next-hop group has another layer of indirection between the group itself
and its constituent next hops: a hash table. The selection algorithm uses a
straightforward modulo operation to choose a hash bucket, and then reads
the next hop that this bucket contains, and forwards traffic there.

This indirection brings an important feature. In the hash-threshold
algorithm, the range of hashes associated with a next hop must be
continuous. With a hash table, mapping between the hash table buckets and
the individual next hops is arbitrary. Therefore when a next hop is deleted
the buckets that held it are simply reassigned to other next hops. When
weights of next hops in a group are altered, it may be possible to choose a
subset of buckets that are currently not used for forwarding traffic, and
use those to satisfy the new next-hop distribution demands, keeping the
"busy" buckets intact. This way, established flows are ideally kept being
forwarded to the same endpoints through the same paths as before the
next-hop group change.

In a nutshell, the algorithm works as follows. Each next hop has a number
of buckets that it wants to have, according to its weight and the number of
buckets in the hash table. In case of an event that might cause bucket
allocation change, the numbers for individual next hops are updated,
similarly to how ranges are updated for mpath group next hops. Following
that, a new "upkeep" algorithm runs, and for idle buckets that belong to a
next hop that is currently occupying more buckets than it wants (it is
"overweight"), it migrates the buckets to one of the next hops that has
fewer buckets than it wants (it is "underweight"). If, after this, there
are still underweight next hops, another upkeep run is scheduled to a
future time.

Chances are there are not enough "idle" buckets to satisfy the new demands.
The algorithm has knobs to select both what it means for a bucket to be
idle, and for whether and when to forcefully migrate buckets if there keeps
being an insufficient number of idle buckets.

There are three users of the resilient data structures.

- The forwarding code accesses them under RCU, and does not modify them
  except for updating the time a selected bucket was last used.

- Netlink code, running under RTNL, which may modify the data.

- The delayed upkeep code, which may modify the data. This runs unlocked,
  and mutual exclusion between the RTNL code and the delayed upkeep is
  maintained by canceling the delayed work synchronously before the RTNL
  code touches anything. Later it restarts the delayed work if necessary.

The RTNL code has to implement next-hop group replacement, next hop
removal, etc. For removal, the mpath code uses a neat trick of having a
backup next hop group structure, doing the necessary changes offline, and
then RCU-swapping them in. However, the hash tables for resilient hashing
are about an order of magnitude larger than the groups themselves (the size
might be e.g. 4K entries), and it was felt that keeping two of them is an
overkill. Both the primary next-hop group and the spare therefore use the
same resilient table, and writers are careful to keep all references valid
for the forwarding code. The hash table references next-hop group entries
from the next-hop group that is currently in the primary role (i.e. not
spare). During the transition from primary to spare, the table references a
mix of both the primary group and the spare. When a next hop is deleted,
the corresponding buckets are not set to NULL, but instead marked as empty,
so that the pointer is valid and can be used by the forwarding code. The
buckets are then migrated to a new next-hop group entry during upkeep. The
only times that the hash table is invalid is the very beginning and very
end of its lifetime. Between those points, it is always kept valid.

This patch introduces the core support code itself. It does not handle
notifications towards drivers, which are kept as if the group were an mpath
one. It does not handle netlink either. The only bit currently exposed to
user space is the new next-hop group type, and that is currently bounced.
There is therefore no way to actually access this code.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
---

Notes:
    v1 (changes since RFC):
    - u32 -> u16 for bucket counts / indices
    - set the new flag is_multipath for resilient groups

 include/net/nexthop.h |  42 ++++
 net/ipv4/nexthop.c    | 517 ++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 546 insertions(+), 13 deletions(-)

diff --git a/include/net/nexthop.h b/include/net/nexthop.h
index 5062c2c08e2b..b78505c9031e 100644
--- a/include/net/nexthop.h
+++ b/include/net/nexthop.h
@@ -40,6 +40,12 @@ struct nh_config {
 
 	struct nlattr	*nh_grp;
 	u16		nh_grp_type;
+	u16		nh_grp_res_num_buckets;
+	unsigned long	nh_grp_res_idle_timer;
+	unsigned long	nh_grp_res_unbalanced_timer;
+	bool		nh_grp_res_has_num_buckets;
+	bool		nh_grp_res_has_idle_timer;
+	bool		nh_grp_res_has_unbalanced_timer;
 
 	struct nlattr	*nh_encap;
 	u16		nh_encap_type;
@@ -63,6 +69,32 @@ struct nh_info {
 	};
 };
 
+struct nh_res_bucket {
+	struct nh_grp_entry __rcu *nh_entry;
+	atomic_long_t		used_time;
+	unsigned long		migrated_time;
+	bool			occupied;
+	u8			nh_flags;
+};
+
+struct nh_res_table {
+	struct net		*net;
+	u32			nhg_id;
+	struct delayed_work	upkeep_dw;
+
+	/* List of NHGEs that have too few buckets ("uw" for underweight).
+	 * Reclaimed buckets will be given to entries in this list.
+	 */
+	struct list_head	uw_nh_entries;
+	unsigned long		unbalanced_since;
+
+	u32			idle_timer;
+	u32			unbalanced_timer;
+
+	u16			num_nh_buckets;
+	struct nh_res_bucket	nh_buckets[];
+};
+
 struct nh_grp_entry {
 	struct nexthop	*nh;
 	u8		weight;
@@ -71,6 +103,13 @@ struct nh_grp_entry {
 		struct {
 			atomic_t	upper_bound;
 		} mpath;
+		struct {
+			/* Member on uw_nh_entries. */
+			struct list_head	uw_nh_entry;
+
+			u16			count_buckets;
+			u16			wants_buckets;
+		} res;
 	};
 
 	struct list_head nh_list;
@@ -82,8 +121,11 @@ struct nh_group {
 	u16			num_nh;
 	bool			is_multipath;
 	bool			mpath;
+	bool			resilient;
 	bool			fdb_nh;
 	bool			has_v4;
+
+	struct nh_res_table __rcu *res_table;
 	struct nh_grp_entry	nh_entries[];
 };
 
diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
index 7a94591da856..0e2ff72e10c0 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -183,6 +183,30 @@ static int call_nexthop_notifiers(struct net *net,
 	return notifier_to_errno(err);
 }
 
+/* There are three users of RES_TABLE, and NHs etc. referenced from there:
+ *
+ * 1) a collection of callbacks for NH maintenance. This operates under
+ *    RTNL,
+ * 2) the delayed work that gradually balances the resilient table,
+ * 3) and nexthop_select_path(), operating under RCU.
+ *
+ * Both the delayed work and the RTNL block are writers, and need to
+ * maintain mutual exclusion. Since there are only two and well-known
+ * writers for each table, the RTNL code can make sure it has exclusive
+ * access thus:
+ *
+ * - Have the DW operate without locking;
+ * - synchronously cancel the DW;
+ * - do the writing;
+ * - if the write was not actually a delete, call upkeep, which schedules
+ *   DW again if necessary.
+ *
+ * The functions that are always called from the RTNL context use
+ * rtnl_dereference(). The functions that can also be called from the DW do
+ * a raw dereference and rely on the above mutual exclusion scheme.
+ */
+#define nh_res_dereference(p) (rcu_dereference_raw(p))
+
 static int call_nexthop_notifier(struct notifier_block *nb, struct net *net,
 				 enum nexthop_event_type event_type,
 				 struct nexthop *nh,
@@ -241,6 +265,9 @@ static void nexthop_free_group(struct nexthop *nh)
 
 	WARN_ON(nhg->spare == nhg);
 
+	if (nhg->resilient)
+		vfree(rcu_dereference_raw(nhg->res_table));
+
 	kfree(nhg->spare);
 	kfree(nhg);
 }
@@ -299,6 +326,30 @@ static struct nh_group *nexthop_grp_alloc(u16 num_nh)
 	return nhg;
 }
 
+static void nh_res_table_upkeep_dw(struct work_struct *work);
+
+static struct nh_res_table *
+nexthop_res_table_alloc(struct net *net, u32 nhg_id, struct nh_config *cfg)
+{
+	const u16 num_nh_buckets = cfg->nh_grp_res_num_buckets;
+	struct nh_res_table *res_table;
+	unsigned long size;
+
+	size = struct_size(res_table, nh_buckets, num_nh_buckets);
+	res_table = __vmalloc(size, GFP_KERNEL | __GFP_ZERO | __GFP_NOWARN);
+	if (!res_table)
+		return NULL;
+
+	res_table->net = net;
+	res_table->nhg_id = nhg_id;
+	INIT_DELAYED_WORK(&res_table->upkeep_dw, &nh_res_table_upkeep_dw);
+	INIT_LIST_HEAD(&res_table->uw_nh_entries);
+	res_table->idle_timer = cfg->nh_grp_res_idle_timer;
+	res_table->unbalanced_timer = cfg->nh_grp_res_unbalanced_timer;
+	res_table->num_nh_buckets = num_nh_buckets;
+	return res_table;
+}
+
 static void nh_base_seq_inc(struct net *net)
 {
 	while (++net->nexthop.seq == 0)
@@ -347,6 +398,13 @@ static u32 nh_find_unused_id(struct net *net)
 	return 0;
 }
 
+static void nh_res_time_set_deadline(unsigned long next_time,
+				     unsigned long *deadline)
+{
+	if (time_before(next_time, *deadline))
+		*deadline = next_time;
+}
+
 static int nla_put_nh_group(struct sk_buff *skb, struct nh_group *nhg)
 {
 	struct nexthop_grp *p;
@@ -540,20 +598,62 @@ static void nexthop_notify(int event, struct nexthop *nh, struct nl_info *info)
 		rtnl_set_sk_err(info->nl_net, RTNLGRP_NEXTHOP, err);
 }
 
+static unsigned long nh_res_bucket_used_time(const struct nh_res_bucket *bucket)
+{
+	return (unsigned long)atomic_long_read(&bucket->used_time);
+}
+
+static unsigned long
+nh_res_bucket_idle_point(const struct nh_res_table *res_table,
+			 const struct nh_res_bucket *bucket,
+			 unsigned long now)
+{
+	unsigned long time = nh_res_bucket_used_time(bucket);
+
+	/* Bucket was not used since it was migrated. The idle time is now. */
+	if (time == bucket->migrated_time)
+		return now;
+
+	return time + res_table->idle_timer;
+}
+
+static unsigned long
+nh_res_table_unb_point(const struct nh_res_table *res_table)
+{
+	return res_table->unbalanced_since + res_table->unbalanced_timer;
+}
+
+static void nh_res_bucket_set_idle(const struct nh_res_table *res_table,
+				   struct nh_res_bucket *bucket)
+{
+	unsigned long now = jiffies;
+
+	atomic_long_set(&bucket->used_time, (long)now);
+	bucket->migrated_time = now;
+}
+
+static void nh_res_bucket_set_busy(struct nh_res_bucket *bucket)
+{
+	atomic_long_set(&bucket->used_time, (long)jiffies);
+}
+
 static bool valid_group_nh(struct nexthop *nh, unsigned int npaths,
 			   bool *is_fdb, struct netlink_ext_ack *extack)
 {
 	if (nh->is_group) {
 		struct nh_group *nhg = rtnl_dereference(nh->nh_grp);
 
-		/* nested multipath (group within a group) is not
-		 * supported
-		 */
+		/* Nesting groups within groups is not supported. */
 		if (nhg->mpath) {
 			NL_SET_ERR_MSG(extack,
 				       "Multipath group can not be a nexthop within a group");
 			return false;
 		}
+		if (nhg->resilient) {
+			NL_SET_ERR_MSG(extack,
+				       "Resilient group can not be a nexthop within a group");
+			return false;
+		}
 		*is_fdb = nhg->fdb_nh;
 	} else {
 		struct nh_info *nhi = rtnl_dereference(nh->nh_info);
@@ -734,6 +834,22 @@ static struct nexthop *nexthop_select_path_mp(struct nh_group *nhg, int hash)
 	return rc;
 }
 
+static struct nexthop *nexthop_select_path_res(struct nh_group *nhg, int hash)
+{
+	struct nh_res_table *res_table = rcu_dereference(nhg->res_table);
+	u16 bucket_index = hash % res_table->num_nh_buckets;
+	struct nh_res_bucket *bucket;
+	struct nh_grp_entry *nhge;
+
+	/* nexthop_select_path() is expected to return a non-NULL value, so
+	 * skip protocol validation and just hand out whatever there is.
+	 */
+	bucket = &res_table->nh_buckets[bucket_index];
+	nh_res_bucket_set_busy(bucket);
+	nhge = rcu_dereference(bucket->nh_entry);
+	return nhge->nh;
+}
+
 struct nexthop *nexthop_select_path(struct nexthop *nh, int hash)
 {
 	struct nh_group *nhg;
@@ -744,6 +860,8 @@ struct nexthop *nexthop_select_path(struct nexthop *nh, int hash)
 	nhg = rcu_dereference(nh->nh_grp);
 	if (nhg->mpath)
 		return nexthop_select_path_mp(nhg, hash);
+	else if (nhg->resilient)
+		return nexthop_select_path_res(nhg, hash);
 
 	/* Unreachable. */
 	return NULL;
@@ -926,7 +1044,289 @@ static int fib_check_nh_list(struct nexthop *old, struct nexthop *new,
 	return 0;
 }
 
-static void nh_group_rebalance(struct nh_group *nhg)
+static bool nh_res_nhge_is_balanced(const struct nh_grp_entry *nhge)
+{
+	return nhge->res.count_buckets == nhge->res.wants_buckets;
+}
+
+static bool nh_res_nhge_is_ow(const struct nh_grp_entry *nhge)
+{
+	return nhge->res.count_buckets > nhge->res.wants_buckets;
+}
+
+static bool nh_res_nhge_is_uw(const struct nh_grp_entry *nhge)
+{
+	return nhge->res.count_buckets < nhge->res.wants_buckets;
+}
+
+static bool nh_res_table_is_balanced(const struct nh_res_table *res_table)
+{
+	return list_empty(&res_table->uw_nh_entries);
+}
+
+static void nh_res_bucket_unset_nh(struct nh_res_bucket *bucket)
+{
+	struct nh_grp_entry *nhge;
+
+	if (bucket->occupied) {
+		nhge = nh_res_dereference(bucket->nh_entry);
+		nhge->res.count_buckets--;
+		bucket->occupied = false;
+	}
+}
+
+static void nh_res_bucket_set_nh(struct nh_res_bucket *bucket,
+				 struct nh_grp_entry *nhge)
+{
+	nh_res_bucket_unset_nh(bucket);
+
+	bucket->occupied = true;
+	rcu_assign_pointer(bucket->nh_entry, nhge);
+	nhge->res.count_buckets++;
+}
+
+static bool nh_res_bucket_should_migrate(struct nh_res_table *res_table,
+					 struct nh_res_bucket *bucket,
+					 unsigned long *deadline, bool *force)
+{
+	unsigned long now = jiffies;
+	struct nh_grp_entry *nhge;
+	unsigned long idle_point;
+
+	if (!bucket->occupied) {
+		/* The bucket is not occupied, its NHGE pointer is either
+		 * NULL or obsolete. We _have to_ migrate: set force.
+		 */
+		*force = true;
+		return true;
+	}
+
+	nhge = nh_res_dereference(bucket->nh_entry);
+
+	/* If the bucket is populated by an underweight or balanced
+	 * nexthop, do not migrate.
+	 */
+	if (!nh_res_nhge_is_ow(nhge))
+		return false;
+
+	/* At this point we know that the bucket is populated with an
+	 * overweight nexthop. It needs to be migrated to a new nexthop if
+	 * the idle timer of unbalanced timer expired.
+	 */
+
+	idle_point = nh_res_bucket_idle_point(res_table, bucket, now);
+	if (time_after_eq(now, idle_point)) {
+		/* The bucket is idle. We _can_ migrate: unset force. */
+		*force = false;
+		return true;
+	}
+
+	/* Unbalanced timer of 0 means "never force". */
+	if (res_table->unbalanced_timer) {
+		unsigned long unb_point;
+
+		unb_point = nh_res_table_unb_point(res_table);
+		if (time_after(now, unb_point)) {
+			/* The bucket is not idle, but the unbalanced timer
+			 * expired. We _can_ migrate, but set force anyway,
+			 * so that drivers know to ignore activity reports
+			 * from the HW.
+			 */
+			*force = true;
+			return true;
+		}
+
+		nh_res_time_set_deadline(unb_point, deadline);
+	}
+
+	nh_res_time_set_deadline(idle_point, deadline);
+	return false;
+}
+
+static bool nh_res_bucket_migrate(struct nh_res_table *res_table,
+				  u16 bucket_index, bool force)
+{
+	struct nh_res_bucket *bucket = &res_table->nh_buckets[bucket_index];
+	struct nh_grp_entry *new_nhge;
+
+	new_nhge = list_first_entry_or_null(&res_table->uw_nh_entries,
+					    struct nh_grp_entry,
+					    res.uw_nh_entry);
+	if (WARN_ON_ONCE(!new_nhge))
+		/* If this function is called, "bucket" is either not
+		 * occupied, or it belongs to a next hop that is
+		 * overweight. In either case, there ought to be a
+		 * corresponding underweight next hop.
+		 */
+		return false;
+
+	nh_res_bucket_set_nh(bucket, new_nhge);
+	nh_res_bucket_set_idle(res_table, bucket);
+
+	if (nh_res_nhge_is_balanced(new_nhge))
+		list_del(&new_nhge->res.uw_nh_entry);
+	return true;
+}
+
+#define NH_RES_UPKEEP_DW_MINIMUM_INTERVAL (HZ / 2)
+
+static void nh_res_table_upkeep(struct nh_res_table *res_table)
+{
+	unsigned long now = jiffies;
+	unsigned long deadline;
+	u16 i;
+
+	/* Deadline is the next time that upkeep should be run. It is the
+	 * earliest time at which one of the buckets might be migrated.
+	 * Start at the most pessimistic estimate: either unbalanced_timer
+	 * from now, or if there is none, idle_timer from now. For each
+	 * encountered time point, call nh_res_time_set_deadline() to
+	 * refine the estimate.
+	 */
+	if (res_table->unbalanced_timer)
+		deadline = now + res_table->unbalanced_timer;
+	else
+		deadline = now + res_table->idle_timer;
+
+	for (i = 0; i < res_table->num_nh_buckets; i++) {
+		struct nh_res_bucket *bucket = &res_table->nh_buckets[i];
+		bool force;
+
+		if (nh_res_bucket_should_migrate(res_table, bucket,
+						 &deadline, &force)) {
+			if (!nh_res_bucket_migrate(res_table, i, force)) {
+				unsigned long idle_point;
+
+				/* A driver can override the migration
+				 * decision if the HW reports that the
+				 * bucket is actually not idle. Therefore
+				 * remark the bucket as busy again and
+				 * update the deadline.
+				 */
+				nh_res_bucket_set_busy(bucket);
+				idle_point = nh_res_bucket_idle_point(res_table,
+								      bucket,
+								      now);
+				nh_res_time_set_deadline(idle_point, &deadline);
+			}
+		}
+	}
+
+	/* If the group is still unbalanced, schedule the next upkeep to
+	 * either the deadline computed above, or the minimum deadline,
+	 * whichever comes later.
+	 */
+	if (!nh_res_table_is_balanced(res_table)) {
+		unsigned long now = jiffies;
+		unsigned long min_deadline;
+
+		min_deadline = now + NH_RES_UPKEEP_DW_MINIMUM_INTERVAL;
+		if (time_before(deadline, min_deadline))
+			deadline = min_deadline;
+
+		queue_delayed_work(system_power_efficient_wq,
+				   &res_table->upkeep_dw, deadline - now);
+	}
+}
+
+static void nh_res_table_upkeep_dw(struct work_struct *work)
+{
+	struct delayed_work *dw = to_delayed_work(work);
+	struct nh_res_table *res_table;
+
+	res_table = container_of(dw, struct nh_res_table, upkeep_dw);
+	nh_res_table_upkeep(res_table);
+}
+
+static void nh_res_table_cancel_upkeep(struct nh_res_table *res_table)
+{
+	cancel_delayed_work_sync(&res_table->upkeep_dw);
+}
+
+static void nh_res_group_rebalance(struct nh_group *nhg,
+				   struct nh_res_table *res_table)
+{
+	int prev_upper_bound = 0;
+	int total = 0;
+	int w = 0;
+	int i;
+
+	INIT_LIST_HEAD(&res_table->uw_nh_entries);
+
+	for (i = 0; i < nhg->num_nh; ++i)
+		total += nhg->nh_entries[i].weight;
+
+	for (i = 0; i < nhg->num_nh; ++i) {
+		struct nh_grp_entry *nhge = &nhg->nh_entries[i];
+		int upper_bound;
+
+		w += nhge->weight;
+		upper_bound = DIV_ROUND_CLOSEST(res_table->num_nh_buckets * w,
+						total);
+		nhge->res.wants_buckets = upper_bound - prev_upper_bound;
+		prev_upper_bound = upper_bound;
+
+		if (nh_res_nhge_is_uw(nhge)) {
+			if (list_empty(&res_table->uw_nh_entries))
+				res_table->unbalanced_since = jiffies;
+			list_add(&nhge->res.uw_nh_entry,
+				 &res_table->uw_nh_entries);
+		}
+	}
+}
+
+/* Migrate buckets in res_table so that they reference NHGE's from NHG with
+ * the right NH ID. Set those buckets that do not have a corresponding NHGE
+ * entry in NHG as not occupied.
+ */
+static void nh_res_table_migrate_buckets(struct nh_res_table *res_table,
+					 struct nh_group *nhg)
+{
+	u16 i;
+
+	for (i = 0; i < res_table->num_nh_buckets; i++) {
+		struct nh_res_bucket *bucket = &res_table->nh_buckets[i];
+		u32 id = rtnl_dereference(bucket->nh_entry)->nh->id;
+		bool found = false;
+		int j;
+
+		for (j = 0; j < nhg->num_nh; j++) {
+			struct nh_grp_entry *nhge = &nhg->nh_entries[j];
+
+			if (nhge->nh->id == id) {
+				nh_res_bucket_set_nh(bucket, nhge);
+				found = true;
+				break;
+			}
+		}
+
+		if (!found)
+			nh_res_bucket_unset_nh(bucket);
+	}
+}
+
+static void replace_nexthop_grp_res(struct nh_group *oldg,
+				    struct nh_group *newg)
+{
+	/* For NH group replacement, the new NHG might only have a stub
+	 * hash table with 0 buckets, because the number of buckets was not
+	 * specified. For NH removal, oldg and newg both reference the same
+	 * res_table. So in any case, in the following, we want to work
+	 * with oldg->res_table.
+	 */
+	struct nh_res_table *old_res_table = rtnl_dereference(oldg->res_table);
+	unsigned long prev_unbalanced_since = old_res_table->unbalanced_since;
+	bool prev_has_uw = !list_empty(&old_res_table->uw_nh_entries);
+
+	nh_res_table_cancel_upkeep(old_res_table);
+	nh_res_table_migrate_buckets(old_res_table, newg);
+	nh_res_group_rebalance(newg, old_res_table);
+	if (prev_has_uw && !list_empty(&old_res_table->uw_nh_entries))
+		old_res_table->unbalanced_since = prev_unbalanced_since;
+	nh_res_table_upkeep(old_res_table);
+}
+
+static void nh_mp_group_rebalance(struct nh_group *nhg)
 {
 	int total = 0;
 	int w = 0;
@@ -969,6 +1369,7 @@ static void remove_nh_grp_entry(struct net *net, struct nh_grp_entry *nhge,
 	newg->has_v4 = false;
 	newg->is_multipath = nhg->is_multipath;
 	newg->mpath = nhg->mpath;
+	newg->resilient = nhg->resilient;
 	newg->fdb_nh = nhg->fdb_nh;
 	newg->num_nh = nhg->num_nh;
 
@@ -996,7 +1397,11 @@ static void remove_nh_grp_entry(struct net *net, struct nh_grp_entry *nhge,
 		j++;
 	}
 
-	nh_group_rebalance(newg);
+	if (newg->mpath)
+		nh_mp_group_rebalance(newg);
+	else if (newg->resilient)
+		replace_nexthop_grp_res(nhg, newg);
+
 	rcu_assign_pointer(nhp->nh_grp, newg);
 
 	list_del(&nhge->nh_list);
@@ -1025,6 +1430,7 @@ static void remove_nexthop_from_groups(struct net *net, struct nexthop *nh,
 static void remove_nexthop_group(struct nexthop *nh, struct nl_info *nlinfo)
 {
 	struct nh_group *nhg = rcu_dereference_rtnl(nh->nh_grp);
+	struct nh_res_table *res_table;
 	int i, num_nh = nhg->num_nh;
 
 	for (i = 0; i < num_nh; ++i) {
@@ -1035,6 +1441,11 @@ static void remove_nexthop_group(struct nexthop *nh, struct nl_info *nlinfo)
 
 		list_del_init(&nhge->nh_list);
 	}
+
+	if (nhg->resilient) {
+		res_table = rtnl_dereference(nhg->res_table);
+		nh_res_table_cancel_upkeep(res_table);
+	}
 }
 
 /* not called for nexthop replace */
@@ -1113,6 +1524,9 @@ static int replace_nexthop_grp(struct net *net, struct nexthop *old,
 			       struct nexthop *new, const struct nh_config *cfg,
 			       struct netlink_ext_ack *extack)
 {
+	struct nh_res_table *tmp_table = NULL;
+	struct nh_res_table *new_res_table;
+	struct nh_res_table *old_res_table;
 	struct nh_group *oldg, *newg;
 	int i, err;
 
@@ -1121,19 +1535,57 @@ static int replace_nexthop_grp(struct net *net, struct nexthop *old,
 		return -EINVAL;
 	}
 
-	err = call_nexthop_notifiers(net, NEXTHOP_EVENT_REPLACE, new, extack);
-	if (err)
-		return err;
-
 	oldg = rtnl_dereference(old->nh_grp);
 	newg = rtnl_dereference(new->nh_grp);
 
+	if (newg->mpath != oldg->mpath) {
+		NL_SET_ERR_MSG(extack, "Can not replace a nexthop group with one of a different type.");
+		return -EINVAL;
+	}
+
+	if (newg->mpath) {
+		err = call_nexthop_notifiers(net, NEXTHOP_EVENT_REPLACE, new,
+					     extack);
+		if (err)
+			return err;
+	} else if (newg->resilient) {
+		new_res_table = rtnl_dereference(newg->res_table);
+		old_res_table = rtnl_dereference(oldg->res_table);
+
+		/* Accept if num_nh_buckets was not given, but if it was
+		 * given, demand that the value be correct.
+		 */
+		if (cfg->nh_grp_res_has_num_buckets &&
+		    cfg->nh_grp_res_num_buckets !=
+		    old_res_table->num_nh_buckets) {
+			NL_SET_ERR_MSG(extack, "Can not change number of buckets of a resilient nexthop group.");
+			return -EINVAL;
+		}
+
+		if (cfg->nh_grp_res_has_idle_timer)
+			old_res_table->idle_timer = cfg->nh_grp_res_idle_timer;
+		if (cfg->nh_grp_res_has_unbalanced_timer)
+			old_res_table->unbalanced_timer =
+				cfg->nh_grp_res_unbalanced_timer;
+
+		replace_nexthop_grp_res(oldg, newg);
+
+		tmp_table = new_res_table;
+		rcu_assign_pointer(newg->res_table, old_res_table);
+		rcu_assign_pointer(newg->spare->res_table, old_res_table);
+	}
+
 	/* update parents - used by nexthop code for cleanup */
 	for (i = 0; i < newg->num_nh; i++)
 		newg->nh_entries[i].nh_parent = old;
 
 	rcu_assign_pointer(old->nh_grp, newg);
 
+	if (newg->resilient) {
+		rcu_assign_pointer(oldg->res_table, tmp_table);
+		rcu_assign_pointer(oldg->spare->res_table, tmp_table);
+	}
+
 	for (i = 0; i < oldg->num_nh; i++)
 		oldg->nh_entries[i].nh_parent = new;
 
@@ -1383,6 +1835,27 @@ static int insert_nexthop(struct net *net, struct nexthop *new_nh,
 		goto out;
 	}
 
+	if (new_nh->is_group) {
+		struct nh_group *nhg = rtnl_dereference(new_nh->nh_grp);
+		struct nh_res_table *res_table;
+
+		if (nhg->resilient) {
+			res_table = rtnl_dereference(nhg->res_table);
+
+			/* Not passing the number of buckets is OK when
+			 * replacing, but not when creating a new group.
+			 */
+			if (!cfg->nh_grp_res_has_num_buckets) {
+				NL_SET_ERR_MSG(extack, "Number of buckets not specified for nexthop group insertion");
+				rc = -EINVAL;
+				goto out;
+			}
+
+			nh_res_group_rebalance(nhg, res_table);
+			nh_res_table_upkeep(res_table);
+		}
+	}
+
 	rb_link_node_rcu(&new_nh->rb_node, parent, pp);
 	rb_insert_color(&new_nh->rb_node, root);
 
@@ -1445,6 +1918,7 @@ static struct nexthop *nexthop_create_group(struct net *net,
 	u16 num_nh = nla_len(grps_attr) / sizeof(*entry);
 	struct nh_group *nhg;
 	struct nexthop *nh;
+	int err;
 	int i;
 
 	if (WARN_ON(!num_nh))
@@ -1476,8 +1950,10 @@ static struct nexthop *nexthop_create_group(struct net *net,
 		struct nh_info *nhi;
 
 		nhe = nexthop_find_by_id(net, entry[i].id);
-		if (!nexthop_get(nhe))
+		if (!nexthop_get(nhe)) {
+			err = -ENOENT;
 			goto out_no_nh;
+		}
 
 		nhi = rtnl_dereference(nhe->nh_info);
 		if (nhi->family == AF_INET)
@@ -1493,13 +1969,28 @@ static struct nexthop *nexthop_create_group(struct net *net,
 		nhg->mpath = 1;
 		nhg->is_multipath = true;
 	} else if (cfg->nh_grp_type == NEXTHOP_GRP_TYPE_RES) {
+		struct nh_res_table *res_table;
+
+		/* Bounce resilient groups for now. */
+		err = -EINVAL;
 		goto out_no_nh;
+
+		res_table = nexthop_res_table_alloc(net, cfg->nh_id, cfg);
+		if (!res_table) {
+			err = -ENOMEM;
+			goto out_no_nh;
+		}
+
+		rcu_assign_pointer(nhg->spare->res_table, res_table);
+		rcu_assign_pointer(nhg->res_table, res_table);
+		nhg->resilient = true;
+		nhg->is_multipath = true;
 	}
 
-	WARN_ON_ONCE(nhg->mpath != 1);
+	WARN_ON_ONCE(nhg->mpath + nhg->resilient != 1);
 
 	if (nhg->mpath)
-		nh_group_rebalance(nhg);
+		nh_mp_group_rebalance(nhg);
 
 	if (cfg->nh_fdb)
 		nhg->fdb_nh = 1;
@@ -1518,7 +2009,7 @@ static struct nexthop *nexthop_create_group(struct net *net,
 	kfree(nhg);
 	kfree(nh);
 
-	return ERR_PTR(-ENOENT);
+	return ERR_PTR(err);
 }
 
 static int nh_create_ipv4(struct net *net, struct nexthop *nh,
-- 
2.26.2

