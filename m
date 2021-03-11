Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A2DA337BAD
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 19:05:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230287AbhCKSEm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 13:04:42 -0500
Received: from mail-bn7nam10on2045.outbound.protection.outlook.com ([40.107.92.45]:41849
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230016AbhCKSE2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Mar 2021 13:04:28 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=epTD1Xc5/t2p8tmvcid0PgF3UyBTzwInqYpmweXHDGCNhRvtoe8pb50VHFjzYMU5voiFMsH1iiQZWxZHBQvqfZpizYPjFZQ0x0eH4hl2IT+FFJ9+djWayCIHiK1+JvdFbGOslRqDZPxEXvnJmT7dzQueDOmAvnV6kyi3u4mkYQV4GriI1HbwqK8vq9fF/3bwM2PXMO6hA+05r0pXfvRMIlkLXczj3cqoOZ55JPAs8YIdkGehB941leEEILjzMt1q+TLZNx+at6yzySKfqdo/7efMogiU3DuSpF3rAHYlIEzgKVhJM8df/coC7zqqbYcSDvSRqAwx9gNsEoVzHKWPdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zv5W2Rbggr/UFHegX2bqSC3QOrabG5iYN8mssECGFho=;
 b=cgNryH8ja3Yr7Kuj4K+p+BQ1tAohsnzxdQR7PF1fC/Vm/GLDORlUoXKN3do3Iqpyx9s7iWTteHpGUMtlRaUPUnfz3h2XviCOTHvWxsXD/XOMfNC7tX/r6k4emF3dOSQ6oAwH5hEgPWw2wrO0llj31BkKiNhWP7dxDqw6nt5Hs/qtJfH9jtzd0MtVn5O734cU6X/Gh140IOSV29hROj1dxJo4eJMDQT6uswWAhMel2Vq8jUVBxSOU6Br/BSu+qMTRvXdKkxAEUHoUf9XB3dhGookLaHe7vI84HuoBbSLq9uXjphdLJ70UmhoO5Tz6rREb5zEdOyxpWGrrMFcqEXTcuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zv5W2Rbggr/UFHegX2bqSC3QOrabG5iYN8mssECGFho=;
 b=hDzB6CZzQDJd6H/Rune8qS8Kp9EM8FPFqOrA+z7KjXIVnSPOjQz34dCo+vq40oSiFPQGXSQQ12QKLXx/keJp74DSKdICweDMGodqGsF0KfcF4a7mmvm0CHqTFW52yQq8te2ZujcmyXRIE+QsF1fIWAHDmvh+wb2/w7xcKa8YbnlLRvC5ePlF194D0mrJEpB3nX/E+1mltQ2ISvWOFGMx9/TpYvhb2NK5BGUB0otCWEgvE4dD6TMumPQ0HsRVKh2m8YAkQldHPLbFgZeyv6esKKwgwGlIOKgjYoaLD7RuWiZExlfRBTIK7d4sgCcQHLnk6m40My0UxB4Vi6osCHO6Xg==
Received: from BN6PR13CA0028.namprd13.prod.outlook.com (2603:10b6:404:13e::14)
 by BN9PR12MB5260.namprd12.prod.outlook.com (2603:10b6:408:101::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.8; Thu, 11 Mar
 2021 18:04:24 +0000
Received: from BN8NAM11FT060.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:13e:cafe::a6) by BN6PR13CA0028.outlook.office365.com
 (2603:10b6:404:13e::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.10 via Frontend
 Transport; Thu, 11 Mar 2021 18:04:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT060.mail.protection.outlook.com (10.13.177.211) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3933.31 via Frontend Transport; Thu, 11 Mar 2021 18:04:24 +0000
Received: from localhost.localdomain (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 11 Mar
 2021 18:04:12 +0000
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     Ido Schimmel <idosch@nvidia.com>, David Ahern <dsahern@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Petr Machata" <petrm@nvidia.com>
Subject: [PATCH net-next v2 07/14] nexthop: Implement notifiers for resilient nexthop groups
Date:   Thu, 11 Mar 2021 19:03:18 +0100
Message-ID: <7908616da5260522f7baf34f373a669a3bcd0025.1615485052.git.petrm@nvidia.com>
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
X-MS-Office365-Filtering-Correlation-Id: d595fb27-3248-432d-81a9-08d8e4b81a7c
X-MS-TrafficTypeDiagnostic: BN9PR12MB5260:
X-Microsoft-Antispam-PRVS: <BN9PR12MB52604067BBB730B684C95265D6909@BN9PR12MB5260.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qyf6ZtiVh2x2uudhkVSg0ynDdICAd/uaD1cu4LjxvXoThF511FKrPhnqfdYHE0hhbdURnJx3Aov+Lpf83VQPjQgXvBaFFnPiCz0pA37iIo+HnhQ0tlfOp2MDslBn1E6OPi0/b3/JhGT51yJK/FohtLghYKjL5PFlZMYGvzRrSRwUXTgvQZvY6OC2fdAY7hasci4GYGhkhmAPJvKDUhzhfzgKwr9uHlrbIbFPqdtzpEsnBt2lfO8GNwkRnC7CdVIsit1eWLG8xeOrUW9fvQtQfLLLpIw3NB0cp6wdbDjQ+dL/GnBckYHTXYXlMj3JBNOe7xFQ2F8puIddR2E5+MG8xDl4H3qTCabHqoTpJyMobTYtu6ALU4EkjG9qRpDBz/7NfL70ppAmPcV3fIZ3IECyKSf5Kh4+XENGRl7r1VJK3dW0GYOID2aLs+yev5RXM39AbFZigx9/sW58Rj6pER08qQqC6dfIqFVmf5F2nuZEtJdLRuLvlBdgZS6gybh5eH5ocKEDzY2xzZIJ1ked/ES1lrdA6H6cGQgM5DEuY9AivxWrhw+xyQgAs748VCVsxImxgtKgz23bDYEN9pT025fH6a20XIvIXOSNuo84EfgbhbQtzJVMu/ajK+GOX6bVhwHscZk6I3yKYXk2GwRKkt25sN/pfUZn4nt0jCafldywfT82aszI4CMcFt1l+yTPB2/r
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(376002)(396003)(346002)(136003)(46966006)(36840700001)(186003)(107886003)(4326008)(16526019)(426003)(2616005)(336012)(8676002)(82310400003)(36860700001)(70586007)(70206006)(26005)(30864003)(8936002)(34020700004)(5660300002)(36756003)(6916009)(86362001)(82740400003)(83380400001)(7636003)(356005)(54906003)(2906002)(36906005)(316002)(478600001)(47076005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2021 18:04:24.0019
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d595fb27-3248-432d-81a9-08d8e4b81a7c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT060.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5260
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
Reviewed-by: David Ahern <dsahern@kernel.org>
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

