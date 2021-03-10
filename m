Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C8FA33411D
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 16:05:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232978AbhCJPFH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 10:05:07 -0500
Received: from mail-bn8nam11on2086.outbound.protection.outlook.com ([40.107.236.86]:32001
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233043AbhCJPEf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Mar 2021 10:04:35 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eWlDFx8otgXe0XlVYdSwIlKJ4hnxJAmJoohECM8NfxcTHFyQIHH5FCWC0Cuk28tmW1ZrF1WHFpIa8xmCAFe2JJqkjOOVpQWcTNR3gYZZkDEp+eRijCBr0V4y89imXQ/IHHZ66rA/azC1dGsKbzrPV+rekBlX9neDBE6/GRfRR36QzXlHlsuSZuGdzv/QRY+ZEsLmhToWqWkR6Ms8Yd+/tBRq9fcfE10l/lQUjDLYoS22CaXwEHULgvBXp3lVrgAwpLex+Qv43ZPoydD1SGbn8iP+o2hpkPrjuJS+7r2YQEzCOAIJSdU3s2fsCmiKS71JNC1zZDB3RjDAD4Ehyzixhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a6aMp1q282t2rG4ikbzfJoDMxnYV3STK0tE3l7GAyig=;
 b=M96IkJQX4vErRtWR0Dc8LbxFuxj/wSPqER+kkr8Chj9SGU6wHGeVcnxIZESW6mkWF9LIE3UUFvLX3WnpPx8nluhkHGn4j5Yc+P9mG8/947GyKxOGtHs3Rk3+sKsVrFoAIs7UkSgR0tJY0Utr6LYPBkQkZMDlBJF+mNFyooer7s/g1v1QbmpnpW2GmutRZmOd6ebbUw5mwsxjvTQNc2Vv462WZhPNuXvWOJWXzs9AL7lEFTOBaMEOaPE7nO/EYPX6eWtSKNAJ7Hvb9PB757kyhbPcdGaaVr2iBgFyZevW75oRhj5tLbPgSxYupG9qfQEjw8schveBkn+R1mcDGfhoQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a6aMp1q282t2rG4ikbzfJoDMxnYV3STK0tE3l7GAyig=;
 b=h/xyvFktDw61jgkgP1fX/HHVdtqhO7VAhV0LhMkF8kdwEJPrMMpGRXguKe4NkcjuBA5kkPtYcYK+yf4vVbagn6Y/dchxWgwLu6cm2H1ncawNA4A4XvWgtG4TsGLkNd8O+7nH4DHIHnkX9Hb2G7XcPrZ1Vs1clH7WQMVljW7Sf07x1KcW2E6Fy6vA6eUmP6Y/rLKWYmG2qrcjYbdyUOXueK4T+U4jtzlqSDCuRf3sAZ2LIyKeFu7xQpwMrYPnBVc4JdxOl3LhOfGdZwshWNw7f2YPJJTiOGZMHiSZg1VPDqg6smvVtyuNQiOUUuHVOR0yBK3/e86cwKSFc1cBt3ydww==
Received: from BN9PR03CA0046.namprd03.prod.outlook.com (2603:10b6:408:fb::21)
 by MN2PR12MB4174.namprd12.prod.outlook.com (2603:10b6:208:15f::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.28; Wed, 10 Mar
 2021 15:04:33 +0000
Received: from BN8NAM11FT021.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:fb:cafe::74) by BN9PR03CA0046.outlook.office365.com
 (2603:10b6:408:fb::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend
 Transport; Wed, 10 Mar 2021 15:04:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT021.mail.protection.outlook.com (10.13.177.114) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3933.31 via Frontend Transport; Wed, 10 Mar 2021 15:04:33 +0000
Received: from localhost.localdomain (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 10 Mar
 2021 15:04:27 +0000
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     Ido Schimmel <idosch@nvidia.com>, David Ahern <dsahern@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Petr Machata" <petrm@nvidia.com>
Subject: [PATCH net-next 14/14] nexthop: Enable resilient next-hop groups
Date:   Wed, 10 Mar 2021 16:03:05 +0100
Message-ID: <b3ca94c2e8fee0d5c9a6f4f717893ceda7091af3.1615387786.git.petrm@nvidia.com>
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
X-MS-Office365-Filtering-Correlation-Id: 9865ebe7-5908-44e9-d5d6-08d8e3d5d024
X-MS-TrafficTypeDiagnostic: MN2PR12MB4174:
X-Microsoft-Antispam-PRVS: <MN2PR12MB4174794CDBFD56BB70D09193D6919@MN2PR12MB4174.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3044;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SyUyC7NS06GHHIcxCKwJ7h+0+2pif5OYnnKtIMjsCkxgV8hy3II2nSADiOVy/gosMODA7veREsjnVxHe6mtrXmpnxmSgWnnIfVhwXrN3n8PETLM0i+CM+M2Kerg1pCVgEost+jZIbXrx887Ae9CQKXCq/VPgkWKFOYd+p86rYXEV1lbC54fWX7j9xTgvIjYWhoSjiSliNUNjdIedPJN2FGH/fzFJDgVYFy+hs8AamolGj0APx9CddLPpjV5L5jzSD4g64Ljwv/TyoF07HBbvdRMzZY6lOmW/VBGc3QOSWAQfJygSWLQ8690sl4H4mHxYLqCLUJX4BKrTonUZygJbUcJzRLKsQo5A9/AhGbx8eh+B+SBdhk2Jx7DFew0oE6uTvb753Gapyue16H/65RH6CzczeN/gZBsFdEHIRBlurWAAqJLTLwyNvh3v9mGTCQA26QjQft86UXX5CnN5xnbJALTOrDQmEjDJXDim1Ix5+27iH0pgwmQ+O+WHKOXQdcH7RoiW94W7oVDjx2mc/AD5+DglIYWDXKZx/pYUQKSc7iVMx1Fg+z5hfbAl0Z2LkaooUnUomYMLjaaldxztyLMUm8n0YZH6G0f36Gct8dhqX301e7nYv37CRBmMZppxmohv980MakUV/AzfFll9kFxFYxnLlEm7PwBLxEx/T49Y6yarn0jS4rllpTvs/TwA5LOF
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(376002)(346002)(396003)(39860400002)(46966006)(36840700001)(6916009)(336012)(6666004)(26005)(316002)(82310400003)(34020700004)(356005)(426003)(4744005)(8676002)(82740400003)(2616005)(5660300002)(4326008)(36906005)(83380400001)(36860700001)(186003)(2906002)(7636003)(47076005)(478600001)(54906003)(16526019)(8936002)(70206006)(86362001)(36756003)(70586007)(107886003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2021 15:04:33.1000
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9865ebe7-5908-44e9-d5d6-08d8e3d5d024
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT021.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4174
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that all the code is in place, stop rejecting requests to create
resilient next-hop groups.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
---
 net/ipv4/nexthop.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
index 015a47e8163a..f09fe3a5608f 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -2443,10 +2443,6 @@ static struct nexthop *nexthop_create_group(struct net *net,
 	} else if (cfg->nh_grp_type == NEXTHOP_GRP_TYPE_RES) {
 		struct nh_res_table *res_table;
 
-		/* Bounce resilient groups for now. */
-		err = -EINVAL;
-		goto out_no_nh;
-
 		res_table = nexthop_res_table_alloc(net, cfg->nh_id, cfg);
 		if (!res_table) {
 			err = -ENOMEM;
-- 
2.26.2

