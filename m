Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53CBC337BA8
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 19:05:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230051AbhCKSEf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 13:04:35 -0500
Received: from mail-dm6nam11on2075.outbound.protection.outlook.com ([40.107.223.75]:20417
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229490AbhCKSED (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Mar 2021 13:04:03 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NVAFnrSqKuK7ir8TKTq4JKDgCJmTs9nNuIMbJnTGRHVRl5MbhN0DEjfx+ZuZeB0K7EstUg7iu5hlkd59kvty3OwdzwJYJPNGQJwUGVxVKV9KgOEDGBCC5hC4BWWi10n/8t0+cKWeG/bd6qzSawTqPkb9IGqfN9Q1VWuK+1667whiZoR7n5gV5uPANrzZxQ93j3Gw5yt29VvnpBT4+83+Ch4QXe7SeT7thgTi3lE5viTq8Wx6C3PvgnjMZvUDneKgXd+nCCv5Vv9dOk+4D5mUqLkeek8pvDdSGcuH2/BOXZ5YYmUDtE6ToIFL3FRnFl94IDaE5s1bKpjcGu6IiBjRZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c4xfQ9fGVDQJILVqnGTi6RvuGSY4xfXoO8djyMwRuWY=;
 b=iOJstMfQ7WbmF7IU4x16gua+/WL1dJx1MRsXTqltevp0sjYRSlhbVbbYDIdc9aAuvD1MY/cYwJw/hnLrfltpCWpmE6zuVOdfmsl1hJ5D/zH/+Gl2JLW17r1txn9T0xoDbc67MPa9Nq5Jpk2jIOvEYZubyzkEpoBCK56dXBmFIGayuvlCnaW3iwJc0kLky1PiSS/H9cWmNFO4BNv47fDWKCE09vqcECb6Vkco7JJ6zsunpVac2ms2HrzJ85LDSM6bsjSWMnfHntaUpxkVXpwTDSET+RiYrqXwfz0K9rHKQFsZjPSZ82lbgBxcWL/1DJVteFY0ZKJR33G+eT6yKkYqHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c4xfQ9fGVDQJILVqnGTi6RvuGSY4xfXoO8djyMwRuWY=;
 b=o1v8xcuAcmPunGFsqsLnI/ez2TxYnwms543qvPxUsxKPAoF6pTCHoPBgP8JVM4/JIWgp0cvPsN9iXyc0Zqr1O3ZjI/IToVxLFP92Pw5WzbL7KEzwpCNXiTwmK8tkzcY/tDNThfoLhr+gcc6GKkv0sUxE2DKofACXDRtTqoNtF2GjigMv6fzqIiBkRT7ms3fNvZwJYaTPdE4pMMHv1jzr+l+UsTL6exrr+jqso5M9IjxWX5Bpnr0zdPbnm+Je+ylDDq7zunexjarvMs9TqcwcUscSfsf+pWBfeNkvC2NtVcMFTtyakWJln7glK93pIErUtKQfXTeXZNCT5YUmPXtiyA==
Received: from BN6PR11CA0042.namprd11.prod.outlook.com (2603:10b6:404:4b::28)
 by BY5PR12MB4835.namprd12.prod.outlook.com (2603:10b6:a03:1fd::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17; Thu, 11 Mar
 2021 18:04:01 +0000
Received: from BN8NAM11FT065.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:4b:cafe::e3) by BN6PR11CA0042.outlook.office365.com
 (2603:10b6:404:4b::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend
 Transport; Thu, 11 Mar 2021 18:04:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT065.mail.protection.outlook.com (10.13.177.63) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3933.31 via Frontend Transport; Thu, 11 Mar 2021 18:04:00 +0000
Received: from localhost.localdomain (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 11 Mar
 2021 18:03:57 +0000
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     Ido Schimmel <idosch@nvidia.com>, David Ahern <dsahern@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Petr Machata" <petrm@nvidia.com>
Subject: [PATCH net-next v2 02/14] nexthop: __nh_notifier_single_info_init(): Make nh_info an argument
Date:   Thu, 11 Mar 2021 19:03:13 +0100
Message-ID: <fb630954280912874892f379362a79946e7eb95f.1615485052.git.petrm@nvidia.com>
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
X-MS-Office365-Filtering-Correlation-Id: e3cc282b-84f1-44db-936f-08d8e4b80c9d
X-MS-TrafficTypeDiagnostic: BY5PR12MB4835:
X-Microsoft-Antispam-PRVS: <BY5PR12MB4835C8AF8D739D7191FAC829D6909@BY5PR12MB4835.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Risg9F40Dv2dFPlEQeLaQ6uDaM/P4BAcZYNeQseLEzbHtSJcMlICCZT+hrZ2P+Bi1+Jv2vRJ645sO/zAMYeA0H7G91TjJ76LPNjlLPIuDHNS9a0mGAuIvvKljbtAH17//EaBLViBCFL2fFWO4fq0methK2oeqMfuk1FZidqcHyR1NGC4xVq4xsIqLoZ4QTk1cEAQzb6P5ovnpEz4bNmDDszG92oemAawih49gJVU24SbF1jyp9Rbuc4Jf1c8uyIr3GHjgCvdLgeMbe4lmx5eL6nHlqONLvkI8iZOgwmdXMXomv9+Ff6vFskG9Bzw2wJqjyPvw+eFvTl7DAMNqfh2w1rP1XqznlsgVT6hDBkO8NMBFBP53XikxeQtCDJJKfFBcjE3zibJifJrev5fqEeBkPQbXsGtaQ58FEb9AMNppUuYv9TmyqUw7dt4VYk4HV9b4Wc7sFn4s7Hw4VLbvThv/BA6SETMFeGUVUSOD+AiaTJI6MnTPq9Q1C3jn1ipZIS5uPCcwbsP4myGkO2EGO1pJ79rDwcODe4w3XyBOZ4IVUhllT5BGtIeAHna50z6gSkmP6DzUwC6u5gpJ8p0hKYef52+rzDT3b53WXmm7FCBJlDM48JL2zhC535hsWOQEkqtyCkZsSbnaU3zHjHqj6XHxcdbHz/bzDSBST90Nc465IzrnbB6vs1ypr9jz0l7yU3A
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(346002)(376002)(136003)(396003)(39860400002)(46966006)(36840700001)(36906005)(70586007)(7636003)(186003)(356005)(54906003)(47076005)(5660300002)(36756003)(36860700001)(86362001)(6916009)(16526019)(316002)(82740400003)(4326008)(2906002)(6666004)(82310400003)(8936002)(336012)(70206006)(83380400001)(426003)(26005)(8676002)(34020700004)(107886003)(478600001)(2616005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2021 18:04:00.8144
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e3cc282b-84f1-44db-936f-08d8e4b80c9d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT065.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4835
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
Reviewed-by: David Ahern <dsahern@kernel.org>
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

