Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7478133411B
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 16:05:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233183AbhCJPEp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 10:04:45 -0500
Received: from mail-mw2nam12on2057.outbound.protection.outlook.com ([40.107.244.57]:4608
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233080AbhCJPEc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Mar 2021 10:04:32 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bISYQxUF+BtD8u7jOU+/jfAvFw+YfoirDgN2Uld0gbPneqL42FFAkFymXSIEdHtqFlNiwEW1VtwpWGNl6WxnKa91dqpl/iAP3wrpgg3lyxNYCfELuYTkUZZVcsDY9rKO2xkafg/8KezarTwjmEY7W2huVI4/rGMWY7sTMvRAUavH7PC4uhSBgAnljTqWhT01Sqrbcz5w7578AGV+XGBhiWpvo3Ig5rN9MYQ/wTrIGX03MKw45dGoB8RgFU5sLiRmQakHOQeEmqoorV2aI7UzI8r1WfK9Rtn49GzbzMldQkTl7zE2bAbR5w/UoJDIzsDWddtsFEdbII5QocHlW9cg2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qbKMJ7dM5oiLNv3o+kBHuWIK502ne1toLXyqZxPNRFU=;
 b=iynCZ0+OsMOnsKkKBcKs9O5I1MK60bQtXnoHpCSsRHcrbXeJ0vbfk4spMDrW9T9uX1ijPjRaNs/y/QAtF6zeI5znDpJdeNQncyI206gDbk23hFMu+UB1/xWX3BTtmCkKdvT7tWaHDY9J47SlnF641FxAzL+Xsni3+0TGPQCNGA9eDhrs56MGH15eNPfhf+m+XlH7VzVUwDHdpA1Mej2zINkSlAywu3p2zEejldVqasqqgaUzeHy93R1Ezt93ytSGivNK4x9p9hK2zjlQiqwIsIyfNEYKVLIzW0wuFhWgvhAPvDQ2YU8Y8RqK/HkqeAZ9C+qM0F9RzPnUR7bCws/BkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qbKMJ7dM5oiLNv3o+kBHuWIK502ne1toLXyqZxPNRFU=;
 b=AdZcF3CC3PI7a1TTwDX5NbWpPc7PxEXuBsC+loVl1pYHP5LDT93oMg30uIxM/bBBvWHzDD5HlL1JR/4nvveJ+JZknSVtbtvlK3xprpjofv9ebIHEJKb0FPSjNVm80kUqs1h2zlt0ZXj8ncnPrbYVuJs1o4VpUtJMtDhpheatjLMjMUdu2CdPpIVRaWqKqpc7A++FHDNoDcIJghOixBNzZ+hqzah3qTYoJD2lR7lAs3pEt6gKH9tk6NRZn+MCw2C2vteP1CK1asKA434oQFXqlK3KzyuWlkPO9YpFoTzUFTNbKp3uyXOGiQm1EoBKfoqrQyd/dKqNfloEYfBDVjoD+w==
Received: from BN9PR03CA0057.namprd03.prod.outlook.com (2603:10b6:408:fb::32)
 by BL0PR12MB4963.namprd12.prod.outlook.com (2603:10b6:208:17d::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.28; Wed, 10 Mar
 2021 15:04:30 +0000
Received: from BN8NAM11FT021.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:fb:cafe::bf) by BN9PR03CA0057.outlook.office365.com
 (2603:10b6:408:fb::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.26 via Frontend
 Transport; Wed, 10 Mar 2021 15:04:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT021.mail.protection.outlook.com (10.13.177.114) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3933.31 via Frontend Transport; Wed, 10 Mar 2021 15:04:30 +0000
Received: from localhost.localdomain (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 10 Mar
 2021 15:04:24 +0000
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     Ido Schimmel <idosch@nvidia.com>, David Ahern <dsahern@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Petr Machata" <petrm@nvidia.com>
Subject: [PATCH net-next 13/14] nexthop: Notify userspace about bucket migrations
Date:   Wed, 10 Mar 2021 16:03:04 +0100
Message-ID: <b321f8db4a9f1385940f884ecad2db9b40b0b3f7.1615387786.git.petrm@nvidia.com>
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
X-MS-Office365-Filtering-Correlation-Id: e7c78ea1-adfe-49b2-5291-08d8e3d5ce88
X-MS-TrafficTypeDiagnostic: BL0PR12MB4963:
X-Microsoft-Antispam-PRVS: <BL0PR12MB49638B19BEF062D1077C6980D6919@BL0PR12MB4963.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SUl8ckBlh+VhRJ59EkujTDH4/e8UWOAesUvMxUD4qWLjTW0ZE6GgXUZvHdGg3aOXi21mT8kWM2jgR0nguCbp0NagXU7DuLxc4d5XrsnDMswaPYP15T1YsrfcCO3b/oMPDXdqEdlfBnlZ8w4f5erQ+TYpho2Oz/l2KLSWRiblhjwvWjk/36t4Cw8vfuw9y4jMndaJIOinMyGmdgfSSH0C76TUhptzlBV0TIXNiwvS/HIaVK7gp4Dwwou7bIyUn+9zA5PLczLIJB97c0maLg9VFpxW8/c0cJjGHgydfQB9hH3Z5Rh+PbJ8jLlth5pmuNwbMGOOK8vJCHltyxV59jpnjI4RU/KodC+XKax71RvJP0nEUFBhGrFNxwZURTYGLZqTX8jjLNAaTNYv/7ifCdHya/27mw7ZxACFT0V9bNO2D1YPbTl8KRlO7eroDAIn5fq6zLe24EHDqwj6DQHrPNJ6Qu9UqTXKrx7JC1Ansij/tWlsdIgO+wMqbF1UQyC1uDF4e313wB50ToyzhsHj0gXDWF8MuqlIWbEiPFBzBZ7PKsPvGS2f5HrbPUBhYmZgM4o86pl7DK5qN11EdfvQ5BTHRKmEeq+3YBnJQmbL6e2h2Zv9x7Op4mEhVixVUa0viEs0SFXkin5VEuBj/C1PITO1822G/WYTuQo1PECX/ECM4rFiqOgj9EqPqyUOz9S4vUGv
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(376002)(136003)(39860400002)(396003)(346002)(46966006)(36840700001)(86362001)(426003)(83380400001)(356005)(54906003)(7636003)(36860700001)(186003)(34020700004)(5660300002)(316002)(47076005)(8936002)(8676002)(336012)(16526019)(36906005)(26005)(2616005)(82310400003)(6666004)(36756003)(70206006)(6916009)(478600001)(70586007)(2906002)(107886003)(4326008)(82740400003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2021 15:04:30.3945
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e7c78ea1-adfe-49b2-5291-08d8e3d5ce88
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT021.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB4963
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Nexthop replacements et.al. are notified through netlink, but if a delayed
work migrates buckets on the background, userspace will stay oblivious.
Notify these as RTM_NEWNEXTHOPBUCKET events.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
---

Notes:
    v1 (changes since RFC):
    - u32 -> u16 for bucket counts / indices

 net/ipv4/nexthop.c | 45 +++++++++++++++++++++++++++++++++++++++------
 1 file changed, 39 insertions(+), 6 deletions(-)

diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
index 3d602ef6f2c1..015a47e8163a 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -957,6 +957,34 @@ static int nh_fill_res_bucket(struct sk_buff *skb, struct nexthop *nh,
 	return -EMSGSIZE;
 }
 
+static void nexthop_bucket_notify(struct nh_res_table *res_table,
+				  u16 bucket_index)
+{
+	struct nh_res_bucket *bucket = &res_table->nh_buckets[bucket_index];
+	struct nh_grp_entry *nhge = nh_res_dereference(bucket->nh_entry);
+	struct nexthop *nh = nhge->nh_parent;
+	struct sk_buff *skb;
+	int err = -ENOBUFS;
+
+	skb = alloc_skb(NLMSG_GOODSIZE, GFP_KERNEL);
+	if (!skb)
+		goto errout;
+
+	err = nh_fill_res_bucket(skb, nh, bucket, bucket_index,
+				 RTM_NEWNEXTHOPBUCKET, 0, 0, NLM_F_REPLACE,
+				 NULL);
+	if (err < 0) {
+		kfree_skb(skb);
+		goto errout;
+	}
+
+	rtnl_notify(skb, nh->net, 0, RTNLGRP_NEXTHOP, NULL, GFP_KERNEL);
+	return;
+errout:
+	if (err < 0)
+		rtnl_set_sk_err(nh->net, RTNLGRP_NEXTHOP, err);
+}
+
 static bool valid_group_nh(struct nexthop *nh, unsigned int npaths,
 			   bool *is_fdb, struct netlink_ext_ack *extack)
 {
@@ -1470,7 +1498,8 @@ static bool nh_res_bucket_should_migrate(struct nh_res_table *res_table,
 }
 
 static bool nh_res_bucket_migrate(struct nh_res_table *res_table,
-				  u16 bucket_index, bool notify, bool force)
+				  u16 bucket_index, bool notify,
+				  bool notify_nl, bool force)
 {
 	struct nh_res_bucket *bucket = &res_table->nh_buckets[bucket_index];
 	struct nh_grp_entry *new_nhge;
@@ -1513,6 +1542,9 @@ static bool nh_res_bucket_migrate(struct nh_res_table *res_table,
 	nh_res_bucket_set_nh(bucket, new_nhge);
 	nh_res_bucket_set_idle(res_table, bucket);
 
+	if (notify_nl)
+		nexthop_bucket_notify(res_table, bucket_index);
+
 	if (nh_res_nhge_is_balanced(new_nhge))
 		list_del(&new_nhge->res.uw_nh_entry);
 	return true;
@@ -1520,7 +1552,8 @@ static bool nh_res_bucket_migrate(struct nh_res_table *res_table,
 
 #define NH_RES_UPKEEP_DW_MINIMUM_INTERVAL (HZ / 2)
 
-static void nh_res_table_upkeep(struct nh_res_table *res_table, bool notify)
+static void nh_res_table_upkeep(struct nh_res_table *res_table,
+				bool notify, bool notify_nl)
 {
 	unsigned long now = jiffies;
 	unsigned long deadline;
@@ -1545,7 +1578,7 @@ static void nh_res_table_upkeep(struct nh_res_table *res_table, bool notify)
 		if (nh_res_bucket_should_migrate(res_table, bucket,
 						 &deadline, &force)) {
 			if (!nh_res_bucket_migrate(res_table, i, notify,
-						   force)) {
+						   notify_nl, force)) {
 				unsigned long idle_point;
 
 				/* A driver can override the migration
@@ -1586,7 +1619,7 @@ static void nh_res_table_upkeep_dw(struct work_struct *work)
 	struct nh_res_table *res_table;
 
 	res_table = container_of(dw, struct nh_res_table, upkeep_dw);
-	nh_res_table_upkeep(res_table, true);
+	nh_res_table_upkeep(res_table, true, true);
 }
 
 static void nh_res_table_cancel_upkeep(struct nh_res_table *res_table)
@@ -1674,7 +1707,7 @@ static void replace_nexthop_grp_res(struct nh_group *oldg,
 	nh_res_group_rebalance(newg, old_res_table);
 	if (prev_has_uw && !list_empty(&old_res_table->uw_nh_entries))
 		old_res_table->unbalanced_since = prev_unbalanced_since;
-	nh_res_table_upkeep(old_res_table, true);
+	nh_res_table_upkeep(old_res_table, true, false);
 }
 
 static void nh_mp_group_rebalance(struct nh_group *nhg)
@@ -2288,7 +2321,7 @@ static int insert_nexthop(struct net *net, struct nexthop *new_nh,
 			/* Do not send bucket notifications, we do full
 			 * notification below.
 			 */
-			nh_res_table_upkeep(res_table, false);
+			nh_res_table_upkeep(res_table, false, false);
 		}
 	}
 
-- 
2.26.2

