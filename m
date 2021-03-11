Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A12FE337BA9
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 19:05:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229844AbhCKSEj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 13:04:39 -0500
Received: from mail-dm6nam11on2084.outbound.protection.outlook.com ([40.107.223.84]:18400
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229674AbhCKSEF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Mar 2021 13:04:05 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KlMR1unKlrbqD3/R45NgRN8vqfqpKE//y0OIBt9zdyGyDqsX7QkXiEvKR5wXJeHlboj4gPM1svKJLLBSqZYfpdDkIuBtlS6cd9WA1xNoXGapyzFuMaQ1iKOap9vcRWDXE4kI5bzgB6CgwuxacoWIKFqxjBY1dXod5fzZATSkcWQJj1du760aGQYsn1d1KyuY17ZJwmPL0zFDpwsr3FRRiI9WDhfubgiF/7caRiVcGEsyxMk6WA4Ilf+eIzqtppsVXSopz0gKu0T6fWMOWmRhWBMwj7blhdabCdeGlza+5yweFYq0UqrGUw85MeHQmrnAkEq/QHuUbDWPPFBLYGEQMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oBjImWLXDDIRY8y3EUszXdNwrl8TSJkH7Tu+9IKud+E=;
 b=fJNzjXK1fHXyZrwkQCRajMZK4qSa4xvVexRLoiy/WSe+wf/0igEYR3mDdBshNY+5j/fV7x7yF+YCoswZKuB/7bRwtZhH8UgheegqhBvBcRpHugPQaH2vE7eeRm3PYdGqpgAyFkTlOTLVrbUt/gZEI/Skc2rlVKeMp624P0WaDFen/OwGwLmK4RZhuwF/NY4HWtnlJaC/irMkY/+QayMNhlCKPU0SYcC3cKv7o0NKQfBTwpj4PfmhFTwIZtLjWn380i2x+/hk5j5bYfTh8kK0mBL09/hQ0BQ5EUukMTljSwZrwrjr1RtFQ1EmNf6gEiaySCIc1Lob0kRKrmgOsTu/MQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oBjImWLXDDIRY8y3EUszXdNwrl8TSJkH7Tu+9IKud+E=;
 b=EBj3DoPcgrkqUVbh60FskKv1bNaMQMy+QVemF48jdxO5c4iJpqmTH+iqbfSrvl0KXvTHumCDa6UBPMZs0n7mBc0gglvghmgLLsg8IH/ntnqsBZNFRM+ZJUkCy+z4bcQYl9HbkfBvJiIc1+NeDZvRz2UpKIoytx5dAOtTN82g8un6OgUwhcVTRsFtQwGcYD7AU0hJY4cMkY6GhXA6CTStJKJ8rWSohl44QkbQq6XnC+QijkSpt7SA1QxTwcVf8Iy8yoPeBej9dT9yISlq4RmVFRbbrrxYdWnUiEe6iMo+sFsa/gtwSqpwV5o+p8/iSTQvMw0CLYOj5oR5pphsFguFlQ==
Received: from BN8PR03CA0019.namprd03.prod.outlook.com (2603:10b6:408:94::32)
 by BN6PR1201MB0131.namprd12.prod.outlook.com (2603:10b6:405:5b::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.28; Thu, 11 Mar
 2021 18:04:04 +0000
Received: from BN8NAM11FT034.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:94:cafe::7b) by BN8PR03CA0019.outlook.office365.com
 (2603:10b6:408:94::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend
 Transport; Thu, 11 Mar 2021 18:04:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT034.mail.protection.outlook.com (10.13.176.139) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3933.31 via Frontend Transport; Thu, 11 Mar 2021 18:04:03 +0000
Received: from localhost.localdomain (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 11 Mar
 2021 18:04:00 +0000
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     Ido Schimmel <idosch@nvidia.com>, David Ahern <dsahern@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Petr Machata" <petrm@nvidia.com>
Subject: [PATCH net-next v2 03/14] nexthop: Add a dedicated flag for multipath next-hop groups
Date:   Thu, 11 Mar 2021 19:03:14 +0100
Message-ID: <e2da87eaee6a3a4f2cbe76e2a76fe81222284af5.1615485052.git.petrm@nvidia.com>
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
X-MS-Office365-Filtering-Correlation-Id: 09495602-ba87-4c32-ac9a-08d8e4b80e65
X-MS-TrafficTypeDiagnostic: BN6PR1201MB0131:
X-Microsoft-Antispam-PRVS: <BN6PR1201MB0131A7ABE9EE950BDAC8BEDFD6909@BN6PR1201MB0131.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JQl6teavCiGSVVi8eRIXUFiJcNkvESHQX0P9vwTewPm5Vwo9xwSaWGtBhtV787554UdXxU6nkPtPiRGZlQVWGVLQKyNdf3d3tEHeTMc9pAGkc/vUZ5OCB65pJxXm/LrJT7XLOVtClbeuC8hUqKEyt/d1kLoPwTo0fmu1yx3xyjj5tbalp87sm4xilapPAiF0y7IzlCY6wLMieXWC5GTmUKVBK7cty87qu5Sj+bMDa2YahGoUchqRfXroC4TENdfaE/fM1n6atqYwanelrahCulk/WUgLKw3/HGpBH5tGH7cr9kTPXwWhSC7dc7C2vU5GR2VkZwbb0nzBsmLarVGVBXPMueiXg0AxmJ+oKKoIBSKwxDgPPAr8ui5if2Dhtyji5SwrHqI/2Rnf0ND2OSGkTrC5s6lVWmg7lvNHAaUw/6vJhf8PFRewfrsBLIeKV7AZVRWHbh8qKr7iG4piBYSibgfeyXQhTlKeu+z644vXmNrUkVt6A4KG/id/C1MZrC7YjipDMNCKpDdPNMWZCcZwAXEJtPg040VO62EZsPqE4j8vwiiXFQ/yWeX1Atg89HJyy6j/5tL42oYBiLqtyhviYMNLxmI5kKo5cImctXsMNc8mExaxbZGV6h9+yn/nQi6xoWEOqh+aG0ItpwBAGwsWDxWwLOk6A6zV9tZw5aN9XamskDIAXICuarQdiSP0ixvE
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(39860400002)(346002)(376002)(396003)(46966006)(36840700001)(47076005)(478600001)(36756003)(36860700001)(26005)(107886003)(8936002)(316002)(8676002)(6666004)(5660300002)(54906003)(36906005)(4326008)(16526019)(186003)(82310400003)(6916009)(7636003)(2616005)(86362001)(356005)(34020700004)(2906002)(426003)(70586007)(70206006)(336012)(83380400001)(82740400003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2021 18:04:03.8075
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 09495602-ba87-4c32-ac9a-08d8e4b80e65
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT034.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1201MB0131
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With the introduction of resilient nexthop groups, there will be two types
of multipath groups: the current hash-threshold "mpath" ones, and resilient
groups. Both are multipath, but to determine the fact, the system needs to
consider two flags. This might prove costly in the datapath. Therefore,
introduce a new flag, that should be set for next-hop groups that have more
than one nexthop, and should be considered multipath.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
---

Notes:
    v1 (changes since RFC):
    - This patch is new

 include/net/nexthop.h | 7 ++++---
 net/ipv4/nexthop.c    | 5 ++++-
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/include/net/nexthop.h b/include/net/nexthop.h
index 7bc057aee40b..5062c2c08e2b 100644
--- a/include/net/nexthop.h
+++ b/include/net/nexthop.h
@@ -80,6 +80,7 @@ struct nh_grp_entry {
 struct nh_group {
 	struct nh_group		*spare; /* spare group for removals */
 	u16			num_nh;
+	bool			is_multipath;
 	bool			mpath;
 	bool			fdb_nh;
 	bool			has_v4;
@@ -212,7 +213,7 @@ static inline bool nexthop_is_multipath(const struct nexthop *nh)
 		struct nh_group *nh_grp;
 
 		nh_grp = rcu_dereference_rtnl(nh->nh_grp);
-		return nh_grp->mpath;
+		return nh_grp->is_multipath;
 	}
 	return false;
 }
@@ -227,7 +228,7 @@ static inline unsigned int nexthop_num_path(const struct nexthop *nh)
 		struct nh_group *nh_grp;
 
 		nh_grp = rcu_dereference_rtnl(nh->nh_grp);
-		if (nh_grp->mpath)
+		if (nh_grp->is_multipath)
 			rc = nh_grp->num_nh;
 	}
 
@@ -308,7 +309,7 @@ struct fib_nh_common *nexthop_fib_nhc(struct nexthop *nh, int nhsel)
 		struct nh_group *nh_grp;
 
 		nh_grp = rcu_dereference_rtnl(nh->nh_grp);
-		if (nh_grp->mpath) {
+		if (nh_grp->is_multipath) {
 			nh = nexthop_mpath_select(nh_grp, nhsel);
 			if (!nh)
 				return NULL;
diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
index 69c8b50a936e..56c54d0fbacc 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -967,6 +967,7 @@ static void remove_nh_grp_entry(struct net *net, struct nh_grp_entry *nhge,
 	}
 
 	newg->has_v4 = false;
+	newg->is_multipath = nhg->is_multipath;
 	newg->mpath = nhg->mpath;
 	newg->fdb_nh = nhg->fdb_nh;
 	newg->num_nh = nhg->num_nh;
@@ -1488,8 +1489,10 @@ static struct nexthop *nexthop_create_group(struct net *net,
 		nhg->nh_entries[i].nh_parent = nh;
 	}
 
-	if (cfg->nh_grp_type == NEXTHOP_GRP_TYPE_MPATH)
+	if (cfg->nh_grp_type == NEXTHOP_GRP_TYPE_MPATH) {
 		nhg->mpath = 1;
+		nhg->is_multipath = true;
+	}
 
 	WARN_ON_ONCE(nhg->mpath != 1);
 
-- 
2.26.2

