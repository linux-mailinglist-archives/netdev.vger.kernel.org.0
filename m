Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D2D1460EBC
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 07:26:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233060AbhK2G3C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 01:29:02 -0500
Received: from mail-mw2nam10on2047.outbound.protection.outlook.com ([40.107.94.47]:65344
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235062AbhK2G04 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Nov 2021 01:26:56 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J6wnAhjG93GbcIO5gkilha4LP6p9o11tr+Q164cvWdAaAJH+fZAECW3iKizG1SKoQequIvfx5dmPq78x+qYsIoautpA8mHZKnGSCJj8u73eTwXAlU95yHpxnKMTcSTJ0sMEtVxxklpOfbvL6J+EhtYxD21t/7gApOf4AFz2XCqja0JheLKvHLJtw8Z0Jtq7be7Gfo6E5lpWU4eNdUfzrt8iCGTYK5MFRW5EC5s5Mqxlv9sQ4QnP3fOO+B6Zl0U8Eqb8JF4txh+9rS+FiS9eOQnQhoXOxNu4VsUagTPYW1RruQmQ9ufFl+UOBPRQmxvEhG1Rm8zL1T/UZYiompxjKAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Pn77RW/QnJ38Fhhvst2SvUuWUOFPHL5svQV78poTR2U=;
 b=EoM1CejletG80UwGGvWXtvF8WNPJOpoPiKJ17PLOMVnu/USk+2YC1mmRjvDFWd6QHzNz1dI5h57o7nPje2QqxH3BGTInsJ43WDKa0aEdT5TDS5/yMXk6Y+aIrzayJ2WN9qthYyY5OMefYnZM1+qrZ3DgUVbZPYjQwIFOxKfEUDVmvf09U9k78IJbB5J6xCobLf188evPzntk/xQfoChXuLQlCB9FntEoCErCm/Bq89/zptGdG6nPBedvT6ZzVC04Nna3Sw1JjHk0M3wt8+0+UtLGmZK/V1ikvAcWXQBFAWBXca+wCOj8Xt359penpjrxZkzyIk6BW7bC8yUF1YPgMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=linux.alibaba.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Pn77RW/QnJ38Fhhvst2SvUuWUOFPHL5svQV78poTR2U=;
 b=cQw1Qg9nIQv9C811rZ/B2NGYcQ9vy27f3rPSy0GXVE2f8fUr7yutUrbySM2XOPxA+0yzNO/uZuhuw/FNBSNOhTv0BGll7e5hzuouuG4iUytsfDfn/Amr8WqutS98dAYL0rnb9hfccX7mMgCtZ0xFTTgZjEydULTi/bmh2VfvW/IPFXtv7Ceflg6U3oyaHqGWOz7kWzLThcGrVAj0NzZndfZHhmr2O0vYLoo6TgPxZOi8OY2BmKA/FfTmoodsigN41dD7QgK3ItWyIcVoVU9qZ4JPS1mL3eT27ZG1bdUBDToZWWhw2fnmBv4gC7YAo+qHHDRinB7bYV7pZnxSlZ+dnw==
Received: from DM3PR12CA0113.namprd12.prod.outlook.com (2603:10b6:0:55::33) by
 CH2PR12MB4905.namprd12.prod.outlook.com (2603:10b6:610:64::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4734.22; Mon, 29 Nov 2021 06:23:38 +0000
Received: from DM6NAM11FT005.eop-nam11.prod.protection.outlook.com
 (2603:10b6:0:55:cafe::22) by DM3PR12CA0113.outlook.office365.com
 (2603:10b6:0:55::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.22 via Frontend
 Transport; Mon, 29 Nov 2021 06:23:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 DM6NAM11FT005.mail.protection.outlook.com (10.13.172.238) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4734.22 via Frontend Transport; Mon, 29 Nov 2021 06:23:38 +0000
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 29 Nov
 2021 06:23:37 +0000
Received: from d3.nvidia.com (172.20.187.6) by mail.nvidia.com (172.20.187.10)
 with Microsoft SMTP Server id 15.0.1497.18 via Frontend Transport; Mon, 29
 Nov 2021 06:23:36 +0000
From:   Benjamin Poirier <bpoirier@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Kangmin Park <l4stpr0gr4m@gmail.com>,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        <netdev@vger.kernel.org>, Roopa Prabhu <roopa@nvidia.com>,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH net-next 1/2] net: mpls: Remove duplicate variable from iterator macro
Date:   Mon, 29 Nov 2021 15:23:15 +0900
Message-ID: <20211129062316.221653-2-bpoirier@nvidia.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211129062316.221653-1-bpoirier@nvidia.com>
References: <20211129062316.221653-1-bpoirier@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c443a1eb-c720-4a47-4712-08d9b300c7bc
X-MS-TrafficTypeDiagnostic: CH2PR12MB4905:
X-Microsoft-Antispam-PRVS: <CH2PR12MB49053165B3882ACBB4FBD718B0669@CH2PR12MB4905.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1186;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: F7RwlQN19fiHIkyYJdSJhQQTkEI0ZXuXbjmoS+kPQAgLRXVWyQzbhdB2oFkIbHJNwKIr5pWc6f/Z4o/u/MMFGgs5byLOJkvK88x+M9NJ9j0s0GfQCkN4FVDQvECmk7nvaJbFb8+9tKPH61zUYIeMw+rGqCKGMqTN7zIrUNSYm0eY81P3gFXWXDZXD1YioiMT41vI8lryX0lJZxjzaQlO6jYdxPkAErhueHbsQGb2THz/yBzlpjPnZtvRDral8vwywAUmXplY6H1xrFq2kDDi9PhnexpYwKsTgUyL1fqhdwzxPI10NaVRWZ+j6eZR2M9mBh21PrM448yvwkVYkVKSVjBieY8Wa9cq2VJ9jujDVkcduFY25/6/LcjP71qugyfXREcQ3OQadF/kvAxcH8CUl7HhBp8BDdP8mvmkdean57+7DnUHmoh5H8gBWFjH/7m7hXqQZebSeRV/XFRCB/aSLQnlXRQgysLM7IbWrRGDrGPi2veDXK91khFNt79B3vJCnULOMprGHubn61xtQvgZnpDYAhvGTvGv7k5T8TrYxzw/Qh6RN8bjrpAB8ZhEw2mK+i8MBCllYTXIi0UuQ7ivWzv8NqjP5lWUmo1kPTFJXNRk9/Oci6+FJJKMQdtigMLW1OBYZ50P074PeqZn14+HBky2FYeXlgJ8rgjYau3c6kNZ9W6fSpzw/W/+YuRmiCSiOnP6kyi3vLGG+CrQkwJcvg==
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid02.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(83380400001)(26005)(70206006)(70586007)(36860700001)(82310400004)(8936002)(7636003)(316002)(508600001)(36756003)(186003)(8676002)(4326008)(336012)(86362001)(356005)(5660300002)(6666004)(2906002)(54906003)(7696005)(47076005)(426003)(2616005)(1076003)(110136005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2021 06:23:38.0423
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c443a1eb-c720-4a47-4712-08d9b300c7bc
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT005.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4905
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

__nh is just a copy of nh with a different type.

Signed-off-by: Benjamin Poirier <bpoirier@nvidia.com>
---
 net/mpls/internal.h | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/net/mpls/internal.h b/net/mpls/internal.h
index 838cdfc10e47..218138f5b491 100644
--- a/net/mpls/internal.h
+++ b/net/mpls/internal.h
@@ -158,17 +158,16 @@ struct mpls_route { /* next hop label forwarding entry */
 };
 
 #define for_nexthops(rt) {						\
-	int nhsel; struct mpls_nh *nh;  u8 *__nh;			\
-	for (nhsel = 0, nh = (rt)->rt_nh, __nh = (u8 *)((rt)->rt_nh);	\
+	int nhsel; struct mpls_nh *nh;					\
+	for (nhsel = 0, nh = (rt)->rt_nh;				\
 	     nhsel < (rt)->rt_nhn;					\
-	     __nh += rt->rt_nh_size, nh = (struct mpls_nh *)__nh, nhsel++)
+	     nh = (void *)nh + (rt)->rt_nh_size, nhsel++)
 
 #define change_nexthops(rt) {						\
-	int nhsel; struct mpls_nh *nh; u8 *__nh;			\
-	for (nhsel = 0, nh = (struct mpls_nh *)((rt)->rt_nh),		\
-			__nh = (u8 *)((rt)->rt_nh);			\
+	int nhsel; struct mpls_nh *nh;					\
+	for (nhsel = 0, nh = (rt)->rt_nh;				\
 	     nhsel < (rt)->rt_nhn;					\
-	     __nh += rt->rt_nh_size, nh = (struct mpls_nh *)__nh, nhsel++)
+	     nh = (void *)nh + (rt)->rt_nh_size, nhsel++)
 
 #define endfor_nexthops(rt) }
 
-- 
2.33.1

