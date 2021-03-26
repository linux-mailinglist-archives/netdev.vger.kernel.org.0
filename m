Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A15B34A7FD
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 14:21:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229779AbhCZNVO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 09:21:14 -0400
Received: from mail-dm6nam08on2059.outbound.protection.outlook.com ([40.107.102.59]:38113
        "EHLO NAM04-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230104AbhCZNUq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Mar 2021 09:20:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EDRKpF+3uL0NueKQH0gBFWtx4H2F0MeThlQ7zvW78e/3gofBMhkLP1+gcD/h6prCc2rBNs7LPqmmIvET2JW99UE9jU8HJltr93xT47iAcl9qpnbQdIyUzKHqw0AZmhuO3A8uMYlB3SXMpLghcQFHIxFsxvGea1yopddjIw2VRFNTIU+xtbaQQhgvA69LQdFw9r61IZxsQDYyz63c7d7YNxy9wdjkyNFYDRDrQ5P5bWtJ5k2LyNo9pANMHaBC9ogMMfpconlod2xk3q4rAkAI45yf1DPUCQIqY4mIvWHU6TY0vm9tQdFCvW6o4wlQWZdIAC92uYwnwGh972CaGvgpWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WL0ShfkFyEyhias3bk/Xqv6gkbgnEswoWgPOsfdSNgE=;
 b=KEqCWMggjVwJH6x4kuACW7S/UuwH8GOB58wC2yoymYi+/HUyNHXKftvZlwgovw4zgEHRHnzPIwWQJmKGlnF3t9bDtFyss6mm3NHDgpAN52oDOUg2bVQTA0Szb8Iu/vlZmOkU2RmZ9of1Uu4eoU99eRcgxmqQ5nqgAdt52wFxOOzrML4yw21k+n7829LwnGg7X8X8ywY33SdK5oHq2y9nXPIdcrX/0G/qmIaTyO6a0Ujs9Ocqq18h2N85Px7aCD2INpXB7aZRvayQn886Ol+nJy/FAlayVbkuKRbTQAnFIB80MmdSNn5YcH5zV0V33iu+Y3KqI998ICdceo9isAad4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WL0ShfkFyEyhias3bk/Xqv6gkbgnEswoWgPOsfdSNgE=;
 b=q8ocPPDSZ98FcqKHje8b2Bt1py2cknXDroNBEBgxwHf2CpQMHjCHpXLHjeytHrOjPrUtc3Kiesq+KbJq7BRHB7NeoWpVFGNgOwj02RyZ+v6vLZBkFs/lplI5xzRNuZAlMwU2rCTpdLwPUMSUj4tL6UTLp99L82LnxZSLpXHFOr8zXFWZGmAeuUbALX/OacqHl1go9WbZ/bB9XEFJlMNli4AMIl3ywG9adSurthp5vZvEn5qESP8GN2NfiIjpdlp9CWEZKdpZ7CRh9lSdBRuHfn1xULzPSnZ/5sGFPNKeFfuvJfID0BCQ6na4ouB1MVeoQs6NxyXo13hEH9J9tf3OLA==
Received: from BN6PR1401CA0022.namprd14.prod.outlook.com
 (2603:10b6:405:4b::32) by CH2PR12MB4118.namprd12.prod.outlook.com
 (2603:10b6:610:a4::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24; Fri, 26 Mar
 2021 13:20:45 +0000
Received: from BN8NAM11FT057.eop-nam11.prod.protection.outlook.com
 (2603:10b6:405:4b:cafe::58) by BN6PR1401CA0022.outlook.office365.com
 (2603:10b6:405:4b::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.26 via Frontend
 Transport; Fri, 26 Mar 2021 13:20:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT057.mail.protection.outlook.com (10.13.177.49) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3955.18 via Frontend Transport; Fri, 26 Mar 2021 13:20:45 +0000
Received: from localhost.localdomain (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 26 Mar
 2021 13:20:42 +0000
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     Petr Machata <petrm@nvidia.com>, David Ahern <dsahern@gmail.com>
Subject: [PATCH net-next] nexthop: Rename artifacts related to legacy multipath nexthop groups
Date:   Fri, 26 Mar 2021 14:20:22 +0100
Message-ID: <2e29627ba3c4e6edf5ee2c053da52dab22f3d514.1616764400.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.26.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e305359e-c877-4d49-5beb-08d8f059f691
X-MS-TrafficTypeDiagnostic: CH2PR12MB4118:
X-Microsoft-Antispam-PRVS: <CH2PR12MB411875FA89AD6A7C04F4CC24D6619@CH2PR12MB4118.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Khp0FMVXjbINpV8qQyuCfcjnVwII+DXjWuc1FP9Z1CBMnGi39cpE0tE9BZcbjhFH96Nkb8bz4oHWBB4AVG/lpIZEEIkSo4mN0c8uUCQhpfy9c7mKOaPCms4sY252U4dwOykc8HGQLRnfNwqdwIxzERdut4CXmIub8ITNr7YD697+fTxu38bl5Gz26UliojIVfXhOFm56O0djyK8b4V1cy/MGK2OJsmjLlAqsgKlmHTWaIhcH1BEtSKLvm6XdSUuvkoSS/F27z3hxOvQLWykPV6UVZT3Cow3b+OwtfBYUtXcexVV3XnHZVNM8Tev4K0DSeVnddYCJ1dq+oyKu342HsWpP8WiHgi9lk49odrxj6YXPjzBUJHR+RRY+29i8YWC854e+oRrl6FwT9eFKc184DAJ8UkqtZlhWCSz9Xs7VK0QlDhXXboExQv3ruIxSUU/yb1ptB1EPpxc3NWRQpS1ZaPoA8TJBval43eP/A8DVXMEBEsOppgZV6rLlPb6L9VOoZoCGGvkNLpqdVu3PzuOseMjbvuzPopdTT+mnW+mevO9jQ2XYZXIUuWG9/ephtreQKQWZkUaDJf1NFVGjp6DwKNnVDSxsH+kSFR26EbdLGwFGU+b+tI0mFbCJLvHDlstUvFHps1DFTj+D9ZeAf4OsPOPlRZ3F0dR9nEAfDMorlFg=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(39860400002)(346002)(136003)(376002)(46966006)(36840700001)(83380400001)(4326008)(54906003)(2906002)(36756003)(86362001)(47076005)(82740400003)(5660300002)(186003)(7636003)(6666004)(26005)(36860700001)(16526019)(316002)(36906005)(336012)(8676002)(82310400003)(426003)(2616005)(8936002)(70206006)(6916009)(70586007)(478600001)(356005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2021 13:20:45.0293
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e305359e-c877-4d49-5beb-08d8f059f691
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT057.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4118
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After resilient next-hop groups have been added recently, there are two
types of multipath next-hop groups: the legacy "mpath", and the new
"resilient". Calling the legacy next-hop group type "mpath" is unfortunate,
because that describes the fact that a packet could be forwarded in one of
several paths, which is also true for the resilient next-hop groups.

Therefore, to make the naming clearer, rename various artifacts to reflect
the assumptions made. Therefore as of this patch:

- The flag for multipath groups is nh_grp_entry::is_multipath. This
  includes the legacy and resilient groups, as well as any future group
  types that behave as multipath groups.
  Functions that assume this have "mpath" in the name.

- The flag for legacy multipath groups is nh_grp_entry::hash_threshold.
  Functions that assume this have "hthr" in the name.

- The flag for resilient groups is nh_grp_entry::resilient.
  Functions that assume this have "res" in the name.

Besides the above, struct nh_grp_entry::mpath was renamed to ::hthr as
well.

UAPI artifacts were obviously left intact.

Suggested-by: David Ahern <dsahern@gmail.com>
Signed-off-by: Petr Machata <petrm@nvidia.com>
---
 include/net/nexthop.h |  4 ++--
 net/ipv4/nexthop.c    | 56 +++++++++++++++++++++----------------------
 2 files changed, 30 insertions(+), 30 deletions(-)

diff --git a/include/net/nexthop.h b/include/net/nexthop.h
index ba94868a21d5..ace54bf90b2c 100644
--- a/include/net/nexthop.h
+++ b/include/net/nexthop.h
@@ -102,7 +102,7 @@ struct nh_grp_entry {
 	union {
 		struct {
 			atomic_t	upper_bound;
-		} mpath;
+		} hthr;
 		struct {
 			/* Member on uw_nh_entries. */
 			struct list_head	uw_nh_entry;
@@ -120,7 +120,7 @@ struct nh_group {
 	struct nh_group		*spare; /* spare group for removals */
 	u16			num_nh;
 	bool			is_multipath;
-	bool			mpath;
+	bool			hash_threshold;
 	bool			resilient;
 	bool			fdb_nh;
 	bool			has_v4;
diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
index f09fe3a5608f..5a2fc8798d20 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -116,8 +116,8 @@ static void nh_notifier_single_info_fini(struct nh_notifier_info *info)
 	kfree(info->nh);
 }
 
-static int nh_notifier_mp_info_init(struct nh_notifier_info *info,
-				    struct nh_group *nhg)
+static int nh_notifier_mpath_info_init(struct nh_notifier_info *info,
+				       struct nh_group *nhg)
 {
 	u16 num_nh = nhg->num_nh;
 	int i;
@@ -181,8 +181,8 @@ static int nh_notifier_grp_info_init(struct nh_notifier_info *info,
 {
 	struct nh_group *nhg = rtnl_dereference(nh->nh_grp);
 
-	if (nhg->mpath)
-		return nh_notifier_mp_info_init(info, nhg);
+	if (nhg->hash_threshold)
+		return nh_notifier_mpath_info_init(info, nhg);
 	else if (nhg->resilient)
 		return nh_notifier_res_table_info_init(info, nhg);
 	return -EINVAL;
@@ -193,7 +193,7 @@ static void nh_notifier_grp_info_fini(struct nh_notifier_info *info,
 {
 	struct nh_group *nhg = rtnl_dereference(nh->nh_grp);
 
-	if (nhg->mpath)
+	if (nhg->hash_threshold)
 		kfree(info->nh_grp);
 	else if (nhg->resilient)
 		vfree(info->nh_res_table);
@@ -406,7 +406,7 @@ static int call_nexthop_res_table_notifiers(struct net *net, struct nexthop *nh,
 	 * could potentially veto it in case of unsupported configuration.
 	 */
 	nhg = rtnl_dereference(nh->nh_grp);
-	err = nh_notifier_mp_info_init(&info, nhg);
+	err = nh_notifier_mpath_info_init(&info, nhg);
 	if (err) {
 		NL_SET_ERR_MSG(extack, "Failed to initialize nexthop notifier info");
 		return err;
@@ -661,7 +661,7 @@ static int nla_put_nh_group(struct sk_buff *skb, struct nh_group *nhg)
 	u16 group_type = 0;
 	int i;
 
-	if (nhg->mpath)
+	if (nhg->hash_threshold)
 		group_type = NEXTHOP_GRP_TYPE_MPATH;
 	else if (nhg->resilient)
 		group_type = NEXTHOP_GRP_TYPE_RES;
@@ -992,9 +992,9 @@ static bool valid_group_nh(struct nexthop *nh, unsigned int npaths,
 		struct nh_group *nhg = rtnl_dereference(nh->nh_grp);
 
 		/* Nesting groups within groups is not supported. */
-		if (nhg->mpath) {
+		if (nhg->hash_threshold) {
 			NL_SET_ERR_MSG(extack,
-				       "Multipath group can not be a nexthop within a group");
+				       "Hash-threshold group can not be a nexthop within a group");
 			return false;
 		}
 		if (nhg->resilient) {
@@ -1151,7 +1151,7 @@ static bool ipv4_good_nh(const struct fib_nh *nh)
 	return !!(state & NUD_VALID);
 }
 
-static struct nexthop *nexthop_select_path_mp(struct nh_group *nhg, int hash)
+static struct nexthop *nexthop_select_path_hthr(struct nh_group *nhg, int hash)
 {
 	struct nexthop *rc = NULL;
 	int i;
@@ -1160,7 +1160,7 @@ static struct nexthop *nexthop_select_path_mp(struct nh_group *nhg, int hash)
 		struct nh_grp_entry *nhge = &nhg->nh_entries[i];
 		struct nh_info *nhi;
 
-		if (hash > atomic_read(&nhge->mpath.upper_bound))
+		if (hash > atomic_read(&nhge->hthr.upper_bound))
 			continue;
 
 		nhi = rcu_dereference(nhge->nh->nh_info);
@@ -1212,8 +1212,8 @@ struct nexthop *nexthop_select_path(struct nexthop *nh, int hash)
 		return nh;
 
 	nhg = rcu_dereference(nh->nh_grp);
-	if (nhg->mpath)
-		return nexthop_select_path_mp(nhg, hash);
+	if (nhg->hash_threshold)
+		return nexthop_select_path_hthr(nhg, hash);
 	else if (nhg->resilient)
 		return nexthop_select_path_res(nhg, hash);
 
@@ -1710,7 +1710,7 @@ static void replace_nexthop_grp_res(struct nh_group *oldg,
 	nh_res_table_upkeep(old_res_table, true, false);
 }
 
-static void nh_mp_group_rebalance(struct nh_group *nhg)
+static void nh_hthr_group_rebalance(struct nh_group *nhg)
 {
 	int total = 0;
 	int w = 0;
@@ -1725,7 +1725,7 @@ static void nh_mp_group_rebalance(struct nh_group *nhg)
 
 		w += nhge->weight;
 		upper_bound = DIV_ROUND_CLOSEST_ULL((u64)w << 31, total) - 1;
-		atomic_set(&nhge->mpath.upper_bound, upper_bound);
+		atomic_set(&nhge->hthr.upper_bound, upper_bound);
 	}
 }
 
@@ -1752,7 +1752,7 @@ static void remove_nh_grp_entry(struct net *net, struct nh_grp_entry *nhge,
 
 	newg->has_v4 = false;
 	newg->is_multipath = nhg->is_multipath;
-	newg->mpath = nhg->mpath;
+	newg->hash_threshold = nhg->hash_threshold;
 	newg->resilient = nhg->resilient;
 	newg->fdb_nh = nhg->fdb_nh;
 	newg->num_nh = nhg->num_nh;
@@ -1781,8 +1781,8 @@ static void remove_nh_grp_entry(struct net *net, struct nh_grp_entry *nhge,
 		j++;
 	}
 
-	if (newg->mpath)
-		nh_mp_group_rebalance(newg);
+	if (newg->hash_threshold)
+		nh_hthr_group_rebalance(newg);
 	else if (newg->resilient)
 		replace_nexthop_grp_res(nhg, newg);
 
@@ -1794,7 +1794,7 @@ static void remove_nh_grp_entry(struct net *net, struct nh_grp_entry *nhge,
 	/* Removal of a NH from a resilient group is notified through
 	 * bucket notifications.
 	 */
-	if (newg->mpath) {
+	if (newg->hash_threshold) {
 		err = call_nexthop_notifiers(net, NEXTHOP_EVENT_REPLACE, nhp,
 					     &extack);
 		if (err)
@@ -1928,12 +1928,12 @@ static int replace_nexthop_grp(struct net *net, struct nexthop *old,
 	oldg = rtnl_dereference(old->nh_grp);
 	newg = rtnl_dereference(new->nh_grp);
 
-	if (newg->mpath != oldg->mpath) {
+	if (newg->hash_threshold != oldg->hash_threshold) {
 		NL_SET_ERR_MSG(extack, "Can not replace a nexthop group with one of a different type.");
 		return -EINVAL;
 	}
 
-	if (newg->mpath) {
+	if (newg->hash_threshold) {
 		err = call_nexthop_notifiers(net, NEXTHOP_EVENT_REPLACE, new,
 					     extack);
 		if (err)
@@ -2063,7 +2063,7 @@ static int replace_nexthop_single_notify(struct net *net,
 	struct nh_group *nhg = rtnl_dereference(group_nh->nh_grp);
 	struct nh_res_table *res_table;
 
-	if (nhg->mpath) {
+	if (nhg->hash_threshold) {
 		return call_nexthop_notifiers(net, NEXTHOP_EVENT_REPLACE,
 					      group_nh, extack);
 	} else if (nhg->resilient) {
@@ -2328,8 +2328,8 @@ static int insert_nexthop(struct net *net, struct nexthop *new_nh,
 	rb_link_node_rcu(&new_nh->rb_node, parent, pp);
 	rb_insert_color(&new_nh->rb_node, root);
 
-	/* The initial insertion is a full notification for mpath as well
-	 * as resilient groups.
+	/* The initial insertion is a full notification for hash-threshold as
+	 * well as resilient groups.
 	 */
 	rc = call_nexthop_notifiers(net, NEXTHOP_EVENT_REPLACE, new_nh, extack);
 	if (rc)
@@ -2438,7 +2438,7 @@ static struct nexthop *nexthop_create_group(struct net *net,
 	}
 
 	if (cfg->nh_grp_type == NEXTHOP_GRP_TYPE_MPATH) {
-		nhg->mpath = 1;
+		nhg->hash_threshold = 1;
 		nhg->is_multipath = true;
 	} else if (cfg->nh_grp_type == NEXTHOP_GRP_TYPE_RES) {
 		struct nh_res_table *res_table;
@@ -2455,10 +2455,10 @@ static struct nexthop *nexthop_create_group(struct net *net,
 		nhg->is_multipath = true;
 	}
 
-	WARN_ON_ONCE(nhg->mpath + nhg->resilient != 1);
+	WARN_ON_ONCE(nhg->hash_threshold + nhg->resilient != 1);
 
-	if (nhg->mpath)
-		nh_mp_group_rebalance(nhg);
+	if (nhg->hash_threshold)
+		nh_hthr_group_rebalance(nhg);
 
 	if (cfg->nh_fdb)
 		nhg->fdb_nh = 1;
-- 
2.26.2

