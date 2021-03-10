Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DDAE33410D
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 16:04:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233040AbhCJPEE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 10:04:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232284AbhCJPD7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 10:03:59 -0500
Received: from NAM04-CO1-obe.outbound.protection.outlook.com (mail-co1nam04on0628.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe4d::628])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCB41C061760
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 07:03:59 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RCBYJOGQwd2PFyGjNft+qj6AwuWEyz1HziGuIULcmrI0d6ZJ355e1vJQ9e2pCLixoMzdyInFS92xahPvFCuYizPw3zETO9v5v1pWanBete0Kg7X6SaaeS2+Ar3TIYV2NtBtmmHNQpv+8W3AwweKqbLFAV5BWtY06KwFDFZvJ/n3zrEneS0uHdWHL308qA2oWOiGnMlXutlnBt0yzkEoPYy0qj8ngmzGvwLMHwnl3gxebSnpCuEjj9i7022w5RkrNR9ILtGXnuRRI4Met4G6HbQ29FmGJQJ/mn8Udq8ZVvdSyn+OYtH6/yrOMQY58SOnhrKKDuZOo93+wCzXnXAx0ng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=clroedQ2BB8VVqNF1Y1vIBqOtlk8xVpp/T9qA9JMSeg=;
 b=jd8tQRSsyrHk6ehZDyPdEWjF0BXdiSZ34GE6/hbUX6rWiF4hA8d0lsptpTGL10VeP1dvMkenpVmoTiLiaMPWiDGvK9GXb1/aItF/lkBaQL7KL/L1ShC6N6XBwdCv7W2oLy6uXJ86QGNnhAjL5eF0ef+m0e5nlv1QCFnjHfDJdXwnLPIITbhKcGL5jC2ADdr1g+yca+tKeUYduINB9xICOEqz6Pj1dM6qR95X6ExHasaixPvBMHRchzSUoVz0Rf8IuYmZT4K5Fx28w9Bu7JZIsn1CYeZiEvMKO8056DZRfJ0QlwYIEh1X9Eef/NotkGpYJR5tqnxHOTYFf/LaMwa9kA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=clroedQ2BB8VVqNF1Y1vIBqOtlk8xVpp/T9qA9JMSeg=;
 b=WbX7gcZc4p99MmYtUVbWx9/SH/X61YXMu9aKdaB0O1aYM7qOyStmDktV4Wa4QSVh6tw5mLPRa7CGSp5sEmWlhM4wlLmZ+/VzZN8cQW1ofvthQTTg4CNP5CXN7XDm+0VLrtGqhTyLvylokZ1Bi8qheVXOpdtTujAWJr7/L8pbqpidY4KxB+ABSF7MO+vjHIM47BZqB4r5ekKqe+GYHOXUUPIHQon7r9qPTlluw47ipYcXfNepcN9S6ln8V2RdO5gohmK2dML1z5yzIuc/IDcn9A9j5zGa8I6Sfcr7vmwHbxaI/ryLMtHjOqpEdnkMiYiaDYvpPoH02+vj7GZErm5yRA==
Received: from DM3PR12CA0098.namprd12.prod.outlook.com (2603:10b6:0:55::18) by
 BYAPR12MB2822.namprd12.prod.outlook.com (2603:10b6:a03:9a::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3912.28; Wed, 10 Mar 2021 15:03:57 +0000
Received: from DM6NAM11FT039.eop-nam11.prod.protection.outlook.com
 (2603:10b6:0:55:cafe::12) by DM3PR12CA0098.outlook.office365.com
 (2603:10b6:0:55::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend
 Transport; Wed, 10 Mar 2021 15:03:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT039.mail.protection.outlook.com (10.13.172.83) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3933.31 via Frontend Transport; Wed, 10 Mar 2021 15:03:56 +0000
Received: from localhost.localdomain (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 10 Mar
 2021 15:03:53 +0000
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     Ido Schimmel <idosch@nvidia.com>, David Ahern <dsahern@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Petr Machata" <petrm@nvidia.com>
Subject: [PATCH net-next 02/14] nexthop: __nh_notifier_single_info_init(): Make nh_info an argument
Date:   Wed, 10 Mar 2021 16:02:53 +0100
Message-ID: <4e2447a8266746d01da711fa07566099b9cbc75e.1615387786.git.petrm@nvidia.com>
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
X-MS-Office365-Filtering-Correlation-Id: a80c68ab-6257-4f2e-9ee3-08d8e3d5ba5c
X-MS-TrafficTypeDiagnostic: BYAPR12MB2822:
X-Microsoft-Antispam-PRVS: <BYAPR12MB2822D4CE900D8E92D900C344D6919@BYAPR12MB2822.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tM/UAm0k/bGGrSQEMvZHAtLg2b4Rr9q/OWsWPHffA05E11KN/AO9+vMMSIVixmzkhtCPpKagw2AN6NJjoLkxEoRHwS4DKhqm1HvCAV2yVk/rbJOuG1eCmuSVUkWjMq5jkUkas4NC0l2ayVinTPmr8PZj9nt4VcLX3yKvumXrWH32oXFNwXJC+5UBoG9oTFrmQcaMESDz2hYe+fUsu0JNVH5h5zevDXap1sLjdPoqfUcdJdj/a4kloYiZOMi81iZoYkcc2LIy7Vd9dIkkUm7SZFRjNuajrLiwKByddFz+mUkVONV10yjLfjvhN0+2MNeF7INZ1DSHCMu6OSCr0yGK0XyIR/o7JU1Hgy/ytD0LvGGEb/yA/mh8qD6u10+uWFeqVQ5b6Eh4TY+dy+OPXe5BdY2NXi3gHTuVvcLPS/++MkQ7PfxX76WG60aSrJKD4Kqk50/D4ZfIJUUdxGb0zXkghbY8XxuUhoJhmzXXD+KlMd+zRVcYc+N5rgr4Cu2QE1g7o4Mqk1hGbGlZdVSYwjzrv8sXVCxIn+YIZvfmQYZUvm6DUkv1ck/LoXIa6d1ACphCplA2TkMOrTgEfEYyteBZeaTWptRPg9qhr+ySs+6cC7UR/HLC6GNsF0rR/EVSydYTBmNNqk5KXh0+Oo6JRcnRvA85JjOQeaHngrETFOSmmOkCl7o3BsyyZe7MoHA+rzDo
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(39860400002)(136003)(376002)(346002)(36840700001)(46966006)(4326008)(2906002)(8936002)(7636003)(83380400001)(478600001)(82740400003)(8676002)(186003)(26005)(36906005)(54906003)(16526019)(316002)(107886003)(6916009)(36756003)(86362001)(5660300002)(47076005)(2616005)(336012)(36860700001)(356005)(426003)(82310400003)(34020700004)(70206006)(70586007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2021 15:03:56.6107
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a80c68ab-6257-4f2e-9ee3-08d8e3d5ba5c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT039.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB2822
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The cited function currently uses rtnl_dereference() to get nh_info from a
handed-in nexthop. However, under the resilient hashing scheme, this
function will not always be called under RTNL, sometimes the mutual
exclusion will be achieved differently. Therefore move the nh_info
extraction from the function to its callers to make it possible to use a
different synchronization guarantee.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
---
 net/ipv4/nexthop.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
index f723dc97dcd3..69c8b50a936e 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -52,10 +52,8 @@ static bool nexthop_notifiers_is_empty(struct net *net)
 
 static void
 __nh_notifier_single_info_init(struct nh_notifier_single_info *nh_info,
-			       const struct nexthop *nh)
+			       const struct nh_info *nhi)
 {
-	struct nh_info *nhi = rtnl_dereference(nh->nh_info);
-
 	nh_info->dev = nhi->fib_nhc.nhc_dev;
 	nh_info->gw_family = nhi->fib_nhc.nhc_gw_family;
 	if (nh_info->gw_family == AF_INET)
@@ -71,12 +69,14 @@ __nh_notifier_single_info_init(struct nh_notifier_single_info *nh_info,
 static int nh_notifier_single_info_init(struct nh_notifier_info *info,
 					const struct nexthop *nh)
 {
+	struct nh_info *nhi = rtnl_dereference(nh->nh_info);
+
 	info->type = NH_NOTIFIER_INFO_TYPE_SINGLE;
 	info->nh = kzalloc(sizeof(*info->nh), GFP_KERNEL);
 	if (!info->nh)
 		return -ENOMEM;
 
-	__nh_notifier_single_info_init(info->nh, nh);
+	__nh_notifier_single_info_init(info->nh, nhi);
 
 	return 0;
 }
@@ -103,11 +103,13 @@ static int nh_notifier_mp_info_init(struct nh_notifier_info *info,
 
 	for (i = 0; i < num_nh; i++) {
 		struct nh_grp_entry *nhge = &nhg->nh_entries[i];
+		struct nh_info *nhi;
 
+		nhi = rtnl_dereference(nhge->nh->nh_info);
 		info->nh_grp->nh_entries[i].id = nhge->nh->id;
 		info->nh_grp->nh_entries[i].weight = nhge->weight;
 		__nh_notifier_single_info_init(&info->nh_grp->nh_entries[i].nh,
-					       nhge->nh);
+					       nhi);
 	}
 
 	return 0;
-- 
2.26.2

