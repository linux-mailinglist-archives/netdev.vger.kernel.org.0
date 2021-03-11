Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AB3D337BB5
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 19:05:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229756AbhCKSFN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 13:05:13 -0500
Received: from mail-dm6nam08on2049.outbound.protection.outlook.com ([40.107.102.49]:43360
        "EHLO NAM04-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230085AbhCKSEg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Mar 2021 13:04:36 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YxG/Xy5IDonbL849Dih+/sFkjZ3wj/9G50CBhOdWSQnDc04/BvUzxASFkwfvl2zmUblyx+PsWHoMDZz4v/eMPHHbhRPEUdlzzoUr6a0eMnk/uk28UrLNiLz4ICiOhhiTS7JhDcMVCSC70QYNd41ZI2ToGvTIU9Rwx+kgRBUItmzyNIiKFBgDeo2MORJJjSCu2yIvUYcI4jIwc+b5ZxAeppOsQiXRc9Fp+cI1FeKIw+KRK/coX5LmGZoY9kH0CE1j5seJ6y/QbiYAeuLOz2lxejIyq6pPZVu42kjHISByMLonwyjABCdz/0K3rJehEJZxFIQoCe1ZB8f1ap+SnHIGLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aQwgibyOxo4QBN94odOyUEiYE4EsD2kKj2zLROEQRm4=;
 b=Kt9Eupc9ygvI148H7iCpQ8XodLyEmPU7F+Ca6r8zI+rd7t7WBqNx7rzbGNpkm64NJ6yXi/3tnmdbstvYU/81gnnyFJ3pmF8X2mbJdE1R2M5cIamL7u+vLVEY18L+twIgn+OQMsxTOHs7iy42qJPqvC1pUKnbkue+YUhP6Z51WUXiDPmz8N40AMbqJRM81NK08Jcb1U5JHUYooCyLVi23E4lbFTn4CM2ErEev/KViqcKdcEFF6A3exY3YSM5ZV+F39j4s+djugXP6FjiAgcOHcx7D4Z0n4oVwvQvkYi1uR6j6ACdlf213xUChRgr3WGLYihWw89L77ZcMCo3dYrdyvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aQwgibyOxo4QBN94odOyUEiYE4EsD2kKj2zLROEQRm4=;
 b=LkZlw62ihiZsG8lArRQc3TgpWYizdQL4lv2gjB/E04TGMTxFtUZnjpBSShNQ9R/J41YBnLj+WrUceltRhbG/ARnPszbk3VDCOCSdONU1O9dQXdcoqZUXQDXe5iouIQDlYvoQgiF1HJ4dC7aamqRi7Y6qnmLZG39u3I6RlJYZLMYNh+1Ek2EHDy3YOW9AC+10v5zLxG4QwSMlvY/A7pM4pejUSx6TtLOp0G1ydCIPFTDdKxEdyHUvttyzOsxFlG2sH9t3ExHV3KPUW47Q+tFdq52Fbo7ujUrrsQfoZw0bqBvU6BnZF8kTMPwnO1EvhlWbYq/JS5v/8XKAaLmhk32d3g==
Received: from BN6PR2001CA0022.namprd20.prod.outlook.com
 (2603:10b6:404:b4::32) by MWHPR12MB1183.namprd12.prod.outlook.com
 (2603:10b6:300:d::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.30; Thu, 11 Mar
 2021 18:04:34 +0000
Received: from BN8NAM11FT032.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:b4:cafe::5c) by BN6PR2001CA0022.outlook.office365.com
 (2603:10b6:404:b4::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend
 Transport; Thu, 11 Mar 2021 18:04:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT032.mail.protection.outlook.com (10.13.177.88) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3933.31 via Frontend Transport; Thu, 11 Mar 2021 18:04:33 +0000
Received: from localhost.localdomain (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 11 Mar
 2021 18:04:30 +0000
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     Ido Schimmel <idosch@nvidia.com>, David Ahern <dsahern@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Petr Machata" <petrm@nvidia.com>
Subject: [PATCH net-next v2 13/14] nexthop: Notify userspace about bucket migrations
Date:   Thu, 11 Mar 2021 19:03:24 +0100
Message-ID: <42f92f35d09ee78deea155ea24c7e4cc9e48a677.1615485052.git.petrm@nvidia.com>
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
X-MS-Office365-Filtering-Correlation-Id: 558f361f-07c8-46d9-256a-08d8e4b81fef
X-MS-TrafficTypeDiagnostic: MWHPR12MB1183:
X-Microsoft-Antispam-PRVS: <MWHPR12MB1183E499C099504B5ACF2045D6909@MWHPR12MB1183.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SvAD0XtRXOElip0TUpDpoFeb77PkLERbszI4MkCd7Y8umlTuiOYysThI99P8m0gJA/wqq31XI8fo9ZGfwDxt/ZLlqV2d6nFJxGBzr8ol6gq9Hmpbg1crns5xRDfxFWoPwu56U+LU3YdglWnE5uKNDdTZIcFaysoVYJPaTJyOiBHsLn3zyjVPGybkY1vSXESPSlAjcflAeOpkxGHHMhU19LV+jdHnJEEW9j3TuufWAfuzt49yPx8LUytAHpjsJj9HAWv17UYSCfTyGyF6caseq/cmKtvZ6S3Q34gkxR3TE8JTF+cqmEO94bYnxLM21D4Cyb6c54eFlk1zfGDZmPLaR7oZ1WPLVXr1ExcjC+uMwE7OQ9umDZHEzTHCA0ffYejobkt9FgjgMRjp92OHTzt2XUWhN6W6vQKa5aFlIxo+JFX6myOiW5dvX70veMOKD9v0dxcGVM73E3JFU8kydSHSe1o8wOSzz4Okdl5g/wZOUBShqtKc64VsGLXzs8oSQAwqydUNVgN5ACYCOeoQXU77DEFl7W4CnSXHZIiBtknx9xZA5HCU6+/+7K1evGhas24rnbbB+nxhDnbkRFtTqhb40sOP7/XswQlr9614BmEdxPDn1JutgGBRUvK5j4F7lgssOT+eTAd9tWAicorUX9WPG3ZB3a0TkEimGGQDPCKo3YdTfJ+gqTHUY2RmrDKbHhI5
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(136003)(346002)(376002)(396003)(46966006)(36840700001)(107886003)(316002)(186003)(336012)(86362001)(54906003)(16526019)(70586007)(34020700004)(26005)(356005)(8676002)(70206006)(82310400003)(6916009)(7636003)(6666004)(83380400001)(426003)(478600001)(2616005)(36756003)(4326008)(8936002)(2906002)(47076005)(5660300002)(36860700001)(36906005)(82740400003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2021 18:04:33.2227
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 558f361f-07c8-46d9-256a-08d8e4b81fef
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT032.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1183
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Nexthop replacements et.al. are notified through netlink, but if a delayed
work migrates buckets on the background, userspace will stay oblivious.
Notify these as RTM_NEWNEXTHOPBUCKET events.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
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

