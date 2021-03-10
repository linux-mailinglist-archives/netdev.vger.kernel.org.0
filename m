Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D66DC334111
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 16:05:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233087AbhCJPEf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 10:04:35 -0500
Received: from mail-bn7nam10on2067.outbound.protection.outlook.com ([40.107.92.67]:61665
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233038AbhCJPEB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Mar 2021 10:04:01 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ISpSfBexn79grWo3ruBJ/ldu81117cGB80ch4Nj882zzuK411oVYPtIiDFFWhNdqcu2uzq/nNtaZFXfyIUHGiPOPvmTMHoNaFXEzv1uNvhifrvHh9F0V1rKq1GIaAYjBkJ7pgTMjpnRZorOw3PeBeWZAbx0wrxQKbyHlPoVyCbnq6seL3e+mBvRbTiRM9lDvXS/QxXsf4gXTjKGbbxi9d/aGjOcySR18ToYubMhGSZegvlj3cD9AT4yhkRQ4eBUHRZ+tD5kD6Qz9ZpWRh+e5eTd4ogmaFiY2vOH7KAnvXuS+rXRt2jOxZnLZODGDpIPojbtdYUJ6VjILDLJQT5LQRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iekHjZyPPss660Vw5v2u/8HDH73P+Gz/YdOYcJWM+PQ=;
 b=KI7x4VLYggbRHcAHfEsJ1HiVZs/j+iMse6c0RIZxmh66Ruh5bkQOEdwW9jcRw047vk8St0dpcp1Wc12UwMAEDgZgA79OLStsbkm+gewjxse0HzD/8oJtXAWQvMecQ+yPGYVwLD6dCS6A4HKJp47fG5AJTSOCclb9M3xNeg61HzajO22rNgA1cHGsddrGLY59KQFz4pd7rHaSJFzkni7mg/Ok1JI1pFSQ2iSAfF6sj6ViX8/U89h3zxNbbyyetzMvzlppbAEdnhAADYyywubWkIbALPu0WWW8Map6X60ovaI5cR2D5+Luefve10d2Riz4EOsrt6eYaYOVc+Quh9PhFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iekHjZyPPss660Vw5v2u/8HDH73P+Gz/YdOYcJWM+PQ=;
 b=IzBzkrq0hE0NzCTFCLYf8afA0yyRP1QstAPs4v86i2mpk0sUE5hEYZrO+qjA5bUXqTb88Ui08nf5kkz+44Brn/tYE5OyhCCHYl07jC3moiE8DZ/f1k6UGiZjyyLgNdNxPL0xLz1Blx4Tq8wMhAiI+2R2U0H9PgmHl+DfOLda7PWILFZEcs15S75tKPSdoQS13///agiUTxhWG+YeTC4UATuw8SGhvHG6ISAQCS714/VoluHLWw8bwHsKaIKWCqZzOBdMHlnqXfGqldNtbQoBMPvBLV8rim+YWX/Xfu3m6QtPXAsMWe6LOo73DQEOQxPypcMXHQdL51or6rV5oedheA==
Received: from DM5PR15CA0062.namprd15.prod.outlook.com (2603:10b6:3:ae::24) by
 MN2PR12MB4334.namprd12.prod.outlook.com (2603:10b6:208:1d1::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17; Wed, 10 Mar
 2021 15:03:59 +0000
Received: from DM6NAM11FT047.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:ae:cafe::37) by DM5PR15CA0062.outlook.office365.com
 (2603:10b6:3:ae::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend
 Transport; Wed, 10 Mar 2021 15:03:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT047.mail.protection.outlook.com (10.13.172.139) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3912.17 via Frontend Transport; Wed, 10 Mar 2021 15:03:59 +0000
Received: from localhost.localdomain (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 10 Mar
 2021 15:03:56 +0000
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     Ido Schimmel <idosch@nvidia.com>, David Ahern <dsahern@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Petr Machata" <petrm@nvidia.com>
Subject: [PATCH net-next 03/14] nexthop: Add a dedicated flag for multipath next-hop groups
Date:   Wed, 10 Mar 2021 16:02:54 +0100
Message-ID: <99559c7574a7081b26a8ff466b8abb49e22789c7.1615387786.git.petrm@nvidia.com>
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
X-MS-Office365-Filtering-Correlation-Id: 7d405639-9bc1-4c60-4c26-08d8e3d5bc07
X-MS-TrafficTypeDiagnostic: MN2PR12MB4334:
X-Microsoft-Antispam-PRVS: <MN2PR12MB4334FF7CACDABC1BE6D65B28D6919@MN2PR12MB4334.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iIPN0QNT7oGFFmquKYmZWhVRWKfqbGNeWrj1BQNGQDeznFbopntMlqjyf9kS9B5mriuCnSo5BanuI+kxBvKh4xo90+/Z4R8MAvUdJfym4ZLF8EDDskMI5tbK1TkO/T8SEqACt9WbdVeSR8mPiBpjaM392K/hThKId5VZ/lXdqWWdxLopUVVAJxAeDS6Hbaj0zyJXshBFFFpGYDDN48/eFIPTsjHnOUhMTc4u4SM5sEzV1yEaOr/dbesk+cRmOak/XZv/e3/OQxRaiPuKGm6X/b8ouAJh+hHyplqc9Mh0bQ0BzA62V13/XyCGl/BN3OiZk6lo1INuWUHafm+KEkeBiloXw5NYXANLqlXaxrXyyV40oLtjNg4rT2Pi12B3L6BIvOaYQcXwnwq9hImND8IAGUtK1b11IcXzUSTpyjgon37bFxYPEXCwyszngbQ/eZdhu2LorCBXaeZVUEzzMS7weGRfBE1ES030HjpdqX84xZ77nK2PHpcKWcw7oCVmABzCQnCLXsbjRDi6395XIHwPQ7q5bioS4TncztkQ7gAUVYEdj+uLWajTgDAajd0hHA8Q69vg4Gj/sHaQma5vrS4GsnHLfIsr2QzVY3A5ZpXAvgrImmcENdU0gqvcXb/7GwzK6V6GGTvekrf8zpzbPh61idAVIvYVct47kzxn55Fxcp+hPWhPbTVsdrl770OaDCt2
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(346002)(136003)(376002)(396003)(39860400002)(36840700001)(46966006)(316002)(36860700001)(186003)(16526019)(70586007)(478600001)(36756003)(6916009)(54906003)(70206006)(5660300002)(86362001)(36906005)(336012)(8936002)(356005)(4326008)(26005)(34020700004)(47076005)(7636003)(107886003)(426003)(82740400003)(83380400001)(2906002)(2616005)(82310400003)(8676002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2021 15:03:59.4029
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d405639-9bc1-4c60-4c26-08d8e3d5bc07
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT047.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4334
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

