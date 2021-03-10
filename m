Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C43D334117
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 16:05:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233150AbhCJPEk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 10:04:40 -0500
Received: from mail-dm6nam11on2059.outbound.protection.outlook.com ([40.107.223.59]:14049
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233055AbhCJPER (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Mar 2021 10:04:17 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SCR852xvB2r7KVvmgYg2Yyu8MQdp3/vGF4W5j6WUQAVC8K4IuN6SUjT1Ewg2lbzyiSQeJY7kDrfWvs+D0PQjVCs2g5pjs+3ya7GGXQHo03FG+mvQsQvjts3nRvR4i0ZOgAgaMjNUnA6h2HbFcLtyn9iVETqPfDlEBJ9OSQSprOR/b6P1lYrh5c4zS9kSJmAC6jFP0z4Dj2/HmDhieYoAghzpSh25dVdt5LTWEqmZCFWMi9a75ieiTLEYzCkEhwjIJAGIHxcE/AjaVzvzsT85Oy/3+0rno9QR9naegoek7Rizz1IoTai4DLOmM+WY2n9T9SMi6i7Q3Kg6mdq1qspfDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0GWGNNeIr8xjfCqM17gy1jMIi24NQpdctcDXAW2goOQ=;
 b=LOYlrGL58wwvxEAFCKLFJmi1XL8A8oSajX+SegxACEMUGzwSPCBt6V/NtCTFsbwKRtBHUA2wtRu2xRKGLXIkRGNhMhcAxZVrsgRUoxnvIJDLXjSlnYFNbFLR3fp/ZNTCwqXw5FtimhgSDCMNGzzXuQk3ewm2uwa+Z4chS7me6AMIL64gTZGYqRvUsfcgkDHXb1BnvufvDlK8aI8uqM22G3UZByX4fYlhsgJvjhCjj5pyWzWmFqDFXw+YKaKa6KHM+ezGOWczE+05lonhjgVpMKT2czXnJqbt07zGWZZqu9XzfLmLGt9Vqp50lZawyRL2oQC0yyvveNcpPudLRDznOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0GWGNNeIr8xjfCqM17gy1jMIi24NQpdctcDXAW2goOQ=;
 b=WV8Ql7oKL//TlAgMEaynt6Wl1luhLnYIDS20QArGdXocP4MDQ/ciyVcnvXoGTVuOjfw4JjFNT+qiTXCnij2iDe4K/6PQkQN4nZ5+cxtZh3mcedr7ugrn9E1jWU8V3lrcPgFYlzL/9VSJwt1RGZaaETyeLy1QdQF0ClbsF3WZ5PN60J1MbIkQdBEXgqxnhqkhBH2dBPik+rJ7czUxoO8ek8O3jIHrQ6fXw95hc+PptUskVQuuIhGmast23usGmbdj86U8f/m5JXn6WNbgjqlqYX6eAr485DRTPckrMyUgdAWXzFyaqxmBjNVaJZzhNbQoAtkvNeMGrR3e3B/Q/R/Z8w==
Received: from BN9PR03CA0915.namprd03.prod.outlook.com (2603:10b6:408:107::20)
 by BN6PR12MB1777.namprd12.prod.outlook.com (2603:10b6:404:104::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.27; Wed, 10 Mar
 2021 15:04:11 +0000
Received: from BN8NAM11FT029.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:107:cafe::72) by BN9PR03CA0915.outlook.office365.com
 (2603:10b6:408:107::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend
 Transport; Wed, 10 Mar 2021 15:04:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT029.mail.protection.outlook.com (10.13.177.68) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3933.31 via Frontend Transport; Wed, 10 Mar 2021 15:04:11 +0000
Received: from localhost.localdomain (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 10 Mar
 2021 15:04:08 +0000
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     Ido Schimmel <idosch@nvidia.com>, David Ahern <dsahern@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Petr Machata" <petrm@nvidia.com>
Subject: [PATCH net-next 07/14] nexthop: Implement notifiers for resilient nexthop groups
Date:   Wed, 10 Mar 2021 16:02:58 +0100
Message-ID: <df2dacdf19a854e15b57349e654d3f9820d0bcd1.1615387786.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1615387786.git.petrm@nvidia.com>
References: <cover.1615387786.git.petrm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 56dfa05f-d337-4c29-db45-08d8e3d5c30b
X-MS-TrafficTypeDiagnostic: BN6PR12MB1777:
X-Microsoft-Antispam-PRVS: <BN6PR12MB1777838B2F8614ACEABD6A90D6919@BN6PR12MB1777.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1uO/dERetehCmctnEjiPcO/2FvxHECd1AgJtUvAG7Utw16wxu7qEOQtdslxlShREatgicYCmcWc0qNadpMTJzu3Ab7ZY+3K/sZOVWP/sJV2vhYgDQeqVY8fMChWyVZHADmFd0P5dQdHJpMf7vBf/RMcTXm3QQh9WKiQbPtxFvWcVYZJ6OtJxci7WNhSz4IdYA4OJdgUOf1pd8zCm0vTqVzJL8ApoonNGzbIEXpLVsz4Df40lVGZcD7CWZQxs6ppIaGIpHSNvmR9o0KzFB29s2LCbG3GQqVB+JkXMjzvBs1tzOx8QGnuPH13R5VbfQuZPpeycSNUNN1xxLwmvIZ8jwMoOfG8r4S2OzpLX1RqkWDzEIiDE1LFHLuahNa1Vulz8zw85dXEfuvN4BNgaRBdhTvVaN2rF0+5xZfY9p8Gu/XW4pSxjzqjw5LRYO+c8YqUyadFnS+Dw51+IvyI25eDh8GtUtqsLDD1g2tnmJXkd+kegw7K8kQYjDx2OVXTZ7vFX81uYts4v80ek2HUg4z1xqhrk+9ktawHHwnwBFkDwCOhxWl0XaZT2aI9B0Ha05AWZWAQ+Dm6BtdVDfl59Tgpo+Fs8VHyR9EutwNBNi4KmHOUWWwHUXbX3FwBsBGwB6+HPsi+ybnd81rKw7KLe/v0dGR9KXBi5txvr42dwoZqlnklIKpLtySPJMoQ2JTyhwRdn
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(136003)(39860400002)(376002)(346002)(36840700001)(46966006)(36860700001)(6666004)(478600001)(4326008)(107886003)(2906002)(47076005)(36906005)(34020700004)(82310400003)(86362001)(426003)(6916009)(316002)(8676002)(8936002)(7636003)(356005)(82740400003)(83380400001)(36756003)(70586007)(186003)(70206006)(16526019)(30864003)(26005)(5660300002)(2616005)(54906003)(336012);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2021 15:04:11.0629
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 56dfa05f-d337-4c29-db45-08d8e3d5c30b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT029.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1777
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement the following notifications towards drivers:

- NEXTHOP_EVENT_REPLACE, when a resilient nexthop group is created.

- NEXTHOP_EVENT_BUCKET_REPLACE any time there is a change in assignment of
  next hops to hash table buckets. That includes replacements, deletions,
  and delayed upkeep cycles. Some bucket notifications can be vetoed by the
  driver, to make it possible to propagate bucket busy-ness flags from the
  HW back to the algorithm. Some are however forced, e.g. if a next hop is
  deleted, all buckets that use this next hop simply must be migrated,
  whether the HW wishes so or not.

- NEXTHOP_EVENT_RES_TABLE_PRE_REPLACE, before a resilient nexthop group is
  replaced. Usually the driver will get the bucket notifications as well,
  and could veto those. But in some cases, a bucket may not be migrated
  immediately, but during delayed upkeep, and that is too late to roll the
  transaction back. This notification allows the driver to take a look and
  veto the new proposed group up front, before anything is committed.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
---

Notes:
    v1 (changes since RFC):
    - u32 -> u16 for bucket counts / indices

 net/ipv4/nexthop.c | 320 +++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 308 insertions(+), 12 deletions(-)

diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
index 0e2ff72e10c0..8b06aafc2e9e 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -115,6 +115,37 @@ static int nh_notifier_mp_info_init(struct nh_notifier_info *info,
 	return 0;
 }
 
+static int nh_notifier_res_table_info_init(struct nh_notifier_info *info,
+					   struct nh_group *nhg)
+{
+	struct nh_res_table *res_table = rtnl_dereference(nhg->res_table);
+	u16 num_nh_buckets = res_table->num_nh_buckets;
+	unsigned long size;
+	u16 i;
+
+	info->type = NH_NOTIFIER_INFO_TYPE_RES_TABLE;
+	size = struct_size(info->nh_res_table, nhs, num_nh_buckets);
+	info->nh_res_table = __vmalloc(size, GFP_KERNEL | __GFP_ZERO |
+				       __GFP_NOWARN);
+	if (!info->nh_res_table)
+		return -ENOMEM;
+
+	info->nh_res_table->num_nh_buckets = num_nh_buckets;
+
+	for (i = 0; i < num_nh_buckets; i++) {
+		struct nh_res_bucket *bucket = &res_table->nh_buckets[i];
+		struct nh_grp_entry *nhge;
+		struct nh_info *nhi;
+
+		nhge = rtnl_dereference(bucket->nh_entry);
+		nhi = rtnl_dereference(nhge->nh->nh_info);
+		__nh_notifier_single_info_init(&info->nh_res_table->nhs[i],
+					       nhi);
+	}
+
+	return 0;
+}
+
 static int nh_notifier_grp_info_init(struct nh_notifier_info *info,
 				     const struct nexthop *nh)
 {
@@ -122,6 +153,8 @@ static int nh_notifier_grp_info_init(struct nh_notifier_info *info,
 
 	if (nhg->mpath)
 		return nh_notifier_mp_info_init(info, nhg);
+	else if (nhg->resilient)
+		return nh_notifier_res_table_info_init(info, nhg);
 	return -EINVAL;
 }
 
@@ -132,6 +165,8 @@ static void nh_notifier_grp_info_fini(struct nh_notifier_info *info,
 
 	if (nhg->mpath)
 		kfree(info->nh_grp);
+	else if (nhg->resilient)
+		vfree(info->nh_res_table);
 }
 
 static int nh_notifier_info_init(struct nh_notifier_info *info,
@@ -183,6 +218,107 @@ static int call_nexthop_notifiers(struct net *net,
 	return notifier_to_errno(err);
 }
 
+static int
+nh_notifier_res_bucket_idle_timer_get(const struct nh_notifier_info *info,
+				      bool force, unsigned int *p_idle_timer_ms)
+{
+	struct nh_res_table *res_table;
+	struct nh_group *nhg;
+	struct nexthop *nh;
+	int err = 0;
+
+	/* When 'force' is false, nexthop bucket replacement is performed
+	 * because the bucket was deemed to be idle. In this case, capable
+	 * listeners can choose to perform an atomic replacement: The bucket is
+	 * only replaced if it is inactive. However, if the idle timer interval
+	 * is smaller than the interval in which a listener is querying
+	 * buckets' activity from the device, then atomic replacement should
+	 * not be tried. Pass the idle timer value to listeners, so that they
+	 * could determine which type of replacement to perform.
+	 */
+	if (force) {
+		*p_idle_timer_ms = 0;
+		return 0;
+	}
+
+	rcu_read_lock();
+
+	nh = nexthop_find_by_id(info->net, info->id);
+	if (!nh) {
+		err = -EINVAL;
+		goto out;
+	}
+
+	nhg = rcu_dereference(nh->nh_grp);
+	res_table = rcu_dereference(nhg->res_table);
+	*p_idle_timer_ms = jiffies_to_msecs(res_table->idle_timer);
+
+out:
+	rcu_read_unlock();
+
+	return err;
+}
+
+static int nh_notifier_res_bucket_info_init(struct nh_notifier_info *info,
+					    u16 bucket_index, bool force,
+					    struct nh_info *oldi,
+					    struct nh_info *newi)
+{
+	unsigned int idle_timer_ms;
+	int err;
+
+	err = nh_notifier_res_bucket_idle_timer_get(info, force,
+						    &idle_timer_ms);
+	if (err)
+		return err;
+
+	info->type = NH_NOTIFIER_INFO_TYPE_RES_BUCKET;
+	info->nh_res_bucket = kzalloc(sizeof(*info->nh_res_bucket),
+				      GFP_KERNEL);
+	if (!info->nh_res_bucket)
+		return -ENOMEM;
+
+	info->nh_res_bucket->bucket_index = bucket_index;
+	info->nh_res_bucket->idle_timer_ms = idle_timer_ms;
+	info->nh_res_bucket->force = force;
+	__nh_notifier_single_info_init(&info->nh_res_bucket->old_nh, oldi);
+	__nh_notifier_single_info_init(&info->nh_res_bucket->new_nh, newi);
+	return 0;
+}
+
+static void nh_notifier_res_bucket_info_fini(struct nh_notifier_info *info)
+{
+	kfree(info->nh_res_bucket);
+}
+
+static int __call_nexthop_res_bucket_notifiers(struct net *net, u32 nhg_id,
+					       u16 bucket_index, bool force,
+					       struct nh_info *oldi,
+					       struct nh_info *newi,
+					       struct netlink_ext_ack *extack)
+{
+	struct nh_notifier_info info = {
+		.net = net,
+		.extack = extack,
+		.id = nhg_id,
+	};
+	int err;
+
+	if (nexthop_notifiers_is_empty(net))
+		return 0;
+
+	err = nh_notifier_res_bucket_info_init(&info, bucket_index, force,
+					       oldi, newi);
+	if (err)
+		return err;
+
+	err = blocking_notifier_call_chain(&net->nexthop.notifier_chain,
+					   NEXTHOP_EVENT_BUCKET_REPLACE, &info);
+	nh_notifier_res_bucket_info_fini(&info);
+
+	return notifier_to_errno(err);
+}
+
 /* There are three users of RES_TABLE, and NHs etc. referenced from there:
  *
  * 1) a collection of callbacks for NH maintenance. This operates under
@@ -207,6 +343,53 @@ static int call_nexthop_notifiers(struct net *net,
  */
 #define nh_res_dereference(p) (rcu_dereference_raw(p))
 
+static int call_nexthop_res_bucket_notifiers(struct net *net, u32 nhg_id,
+					     u16 bucket_index, bool force,
+					     struct nexthop *old_nh,
+					     struct nexthop *new_nh,
+					     struct netlink_ext_ack *extack)
+{
+	struct nh_info *oldi = nh_res_dereference(old_nh->nh_info);
+	struct nh_info *newi = nh_res_dereference(new_nh->nh_info);
+
+	return __call_nexthop_res_bucket_notifiers(net, nhg_id, bucket_index,
+						   force, oldi, newi, extack);
+}
+
+static int call_nexthop_res_table_notifiers(struct net *net, struct nexthop *nh,
+					    struct netlink_ext_ack *extack)
+{
+	struct nh_notifier_info info = {
+		.net = net,
+		.extack = extack,
+	};
+	struct nh_group *nhg;
+	int err;
+
+	ASSERT_RTNL();
+
+	if (nexthop_notifiers_is_empty(net))
+		return 0;
+
+	/* At this point, the nexthop buckets are still not populated. Only
+	 * emit a notification with the logical nexthops, so that a listener
+	 * could potentially veto it in case of unsupported configuration.
+	 */
+	nhg = rtnl_dereference(nh->nh_grp);
+	err = nh_notifier_mp_info_init(&info, nhg);
+	if (err) {
+		NL_SET_ERR_MSG(extack, "Failed to initialize nexthop notifier info");
+		return err;
+	}
+
+	err = blocking_notifier_call_chain(&net->nexthop.notifier_chain,
+					   NEXTHOP_EVENT_RES_TABLE_PRE_REPLACE,
+					   &info);
+	kfree(info.nh_grp);
+
+	return notifier_to_errno(err);
+}
+
 static int call_nexthop_notifier(struct notifier_block *nb, struct net *net,
 				 enum nexthop_event_type event_type,
 				 struct nexthop *nh,
@@ -1144,10 +1327,12 @@ static bool nh_res_bucket_should_migrate(struct nh_res_table *res_table,
 }
 
 static bool nh_res_bucket_migrate(struct nh_res_table *res_table,
-				  u16 bucket_index, bool force)
+				  u16 bucket_index, bool notify, bool force)
 {
 	struct nh_res_bucket *bucket = &res_table->nh_buckets[bucket_index];
 	struct nh_grp_entry *new_nhge;
+	struct netlink_ext_ack extack;
+	int err;
 
 	new_nhge = list_first_entry_or_null(&res_table->uw_nh_entries,
 					    struct nh_grp_entry,
@@ -1160,6 +1345,28 @@ static bool nh_res_bucket_migrate(struct nh_res_table *res_table,
 		 */
 		return false;
 
+	if (notify) {
+		struct nh_grp_entry *old_nhge;
+
+		old_nhge = nh_res_dereference(bucket->nh_entry);
+		err = call_nexthop_res_bucket_notifiers(res_table->net,
+							res_table->nhg_id,
+							bucket_index, force,
+							old_nhge->nh,
+							new_nhge->nh, &extack);
+		if (err) {
+			pr_err_ratelimited("%s\n", extack._msg);
+			if (!force)
+				return false;
+			/* It is not possible to veto a forced replacement, so
+			 * just clear the hardware flags from the nexthop
+			 * bucket to indicate to user space that this bucket is
+			 * not correctly populated in hardware.
+			 */
+			bucket->nh_flags &= ~(RTNH_F_OFFLOAD | RTNH_F_TRAP);
+		}
+	}
+
 	nh_res_bucket_set_nh(bucket, new_nhge);
 	nh_res_bucket_set_idle(res_table, bucket);
 
@@ -1170,7 +1377,7 @@ static bool nh_res_bucket_migrate(struct nh_res_table *res_table,
 
 #define NH_RES_UPKEEP_DW_MINIMUM_INTERVAL (HZ / 2)
 
-static void nh_res_table_upkeep(struct nh_res_table *res_table)
+static void nh_res_table_upkeep(struct nh_res_table *res_table, bool notify)
 {
 	unsigned long now = jiffies;
 	unsigned long deadline;
@@ -1194,7 +1401,8 @@ static void nh_res_table_upkeep(struct nh_res_table *res_table)
 
 		if (nh_res_bucket_should_migrate(res_table, bucket,
 						 &deadline, &force)) {
-			if (!nh_res_bucket_migrate(res_table, i, force)) {
+			if (!nh_res_bucket_migrate(res_table, i, notify,
+						   force)) {
 				unsigned long idle_point;
 
 				/* A driver can override the migration
@@ -1235,7 +1443,7 @@ static void nh_res_table_upkeep_dw(struct work_struct *work)
 	struct nh_res_table *res_table;
 
 	res_table = container_of(dw, struct nh_res_table, upkeep_dw);
-	nh_res_table_upkeep(res_table);
+	nh_res_table_upkeep(res_table, true);
 }
 
 static void nh_res_table_cancel_upkeep(struct nh_res_table *res_table)
@@ -1323,7 +1531,7 @@ static void replace_nexthop_grp_res(struct nh_group *oldg,
 	nh_res_group_rebalance(newg, old_res_table);
 	if (prev_has_uw && !list_empty(&old_res_table->uw_nh_entries))
 		old_res_table->unbalanced_since = prev_unbalanced_since;
-	nh_res_table_upkeep(old_res_table);
+	nh_res_table_upkeep(old_res_table, true);
 }
 
 static void nh_mp_group_rebalance(struct nh_group *nhg)
@@ -1407,9 +1615,15 @@ static void remove_nh_grp_entry(struct net *net, struct nh_grp_entry *nhge,
 	list_del(&nhge->nh_list);
 	nexthop_put(nhge->nh);
 
-	err = call_nexthop_notifiers(net, NEXTHOP_EVENT_REPLACE, nhp, &extack);
-	if (err)
-		pr_err("%s\n", extack._msg);
+	/* Removal of a NH from a resilient group is notified through
+	 * bucket notifications.
+	 */
+	if (newg->mpath) {
+		err = call_nexthop_notifiers(net, NEXTHOP_EVENT_REPLACE, nhp,
+					     &extack);
+		if (err)
+			pr_err("%s\n", extack._msg);
+	}
 
 	if (nlinfo)
 		nexthop_notify(RTM_NEWNEXTHOP, nhp, nlinfo);
@@ -1562,6 +1776,16 @@ static int replace_nexthop_grp(struct net *net, struct nexthop *old,
 			return -EINVAL;
 		}
 
+		/* Emit a pre-replace notification so that listeners could veto
+		 * a potentially unsupported configuration. Otherwise,
+		 * individual bucket replacement notifications would need to be
+		 * vetoed, which is something that should only happen if the
+		 * bucket is currently active.
+		 */
+		err = call_nexthop_res_table_notifiers(net, new, extack);
+		if (err)
+			return err;
+
 		if (cfg->nh_grp_res_has_idle_timer)
 			old_res_table->idle_timer = cfg->nh_grp_res_idle_timer;
 		if (cfg->nh_grp_res_has_unbalanced_timer)
@@ -1611,6 +1835,71 @@ static void nh_group_v4_update(struct nh_group *nhg)
 	nhg->has_v4 = has_v4;
 }
 
+static int replace_nexthop_single_notify_res(struct net *net,
+					     struct nh_res_table *res_table,
+					     struct nexthop *old,
+					     struct nh_info *oldi,
+					     struct nh_info *newi,
+					     struct netlink_ext_ack *extack)
+{
+	u32 nhg_id = res_table->nhg_id;
+	int err;
+	u16 i;
+
+	for (i = 0; i < res_table->num_nh_buckets; i++) {
+		struct nh_res_bucket *bucket = &res_table->nh_buckets[i];
+		struct nh_grp_entry *nhge;
+
+		nhge = rtnl_dereference(bucket->nh_entry);
+		if (nhge->nh == old) {
+			err = __call_nexthop_res_bucket_notifiers(net, nhg_id,
+								  i, true,
+								  oldi, newi,
+								  extack);
+			if (err)
+				goto err_notify;
+		}
+	}
+
+	return 0;
+
+err_notify:
+	while (i-- > 0) {
+		struct nh_res_bucket *bucket = &res_table->nh_buckets[i];
+		struct nh_grp_entry *nhge;
+
+		nhge = rtnl_dereference(bucket->nh_entry);
+		if (nhge->nh == old)
+			__call_nexthop_res_bucket_notifiers(net, nhg_id, i,
+							    true, newi, oldi,
+							    extack);
+	}
+	return err;
+}
+
+static int replace_nexthop_single_notify(struct net *net,
+					 struct nexthop *group_nh,
+					 struct nexthop *old,
+					 struct nh_info *oldi,
+					 struct nh_info *newi,
+					 struct netlink_ext_ack *extack)
+{
+	struct nh_group *nhg = rtnl_dereference(group_nh->nh_grp);
+	struct nh_res_table *res_table;
+
+	if (nhg->mpath) {
+		return call_nexthop_notifiers(net, NEXTHOP_EVENT_REPLACE,
+					      group_nh, extack);
+	} else if (nhg->resilient) {
+		res_table = rtnl_dereference(nhg->res_table);
+		return replace_nexthop_single_notify_res(net, res_table,
+							 old, oldi, newi,
+							 extack);
+	}
+
+	return -EINVAL;
+}
+
 static int replace_nexthop_single(struct net *net, struct nexthop *old,
 				  struct nexthop *new,
 				  struct netlink_ext_ack *extack)
@@ -1653,8 +1942,8 @@ static int replace_nexthop_single(struct net *net, struct nexthop *old,
 	list_for_each_entry(nhge, &old->grp_list, nh_list) {
 		struct nexthop *nhp = nhge->nh_parent;
 
-		err = call_nexthop_notifiers(net, NEXTHOP_EVENT_REPLACE, nhp,
-					     extack);
+		err = replace_nexthop_single_notify(net, nhp, old, oldi, newi,
+						    extack);
 		if (err)
 			goto err_notify;
 	}
@@ -1684,7 +1973,7 @@ static int replace_nexthop_single(struct net *net, struct nexthop *old,
 	list_for_each_entry_continue_reverse(nhge, &old->grp_list, nh_list) {
 		struct nexthop *nhp = nhge->nh_parent;
 
-		call_nexthop_notifiers(net, NEXTHOP_EVENT_REPLACE, nhp, extack);
+		replace_nexthop_single_notify(net, nhp, old, newi, oldi, NULL);
 	}
 	call_nexthop_notifiers(net, NEXTHOP_EVENT_REPLACE, old, extack);
 	return err;
@@ -1852,13 +2141,20 @@ static int insert_nexthop(struct net *net, struct nexthop *new_nh,
 			}
 
 			nh_res_group_rebalance(nhg, res_table);
-			nh_res_table_upkeep(res_table);
+
+			/* Do not send bucket notifications, we do full
+			 * notification below.
+			 */
+			nh_res_table_upkeep(res_table, false);
 		}
 	}
 
 	rb_link_node_rcu(&new_nh->rb_node, parent, pp);
 	rb_insert_color(&new_nh->rb_node, root);
 
+	/* The initial insertion is a full notification for mpath as well
+	 * as resilient groups.
+	 */
 	rc = call_nexthop_notifiers(net, NEXTHOP_EVENT_REPLACE, new_nh, extack);
 	if (rc)
 		rb_erase(&new_nh->rb_node, &net->nexthop.rb_root);
-- 
2.26.2

