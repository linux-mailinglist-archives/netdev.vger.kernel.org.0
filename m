Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A2503B1B6C
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 15:43:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230292AbhFWNpv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 09:45:51 -0400
Received: from mail-bn8nam11on2054.outbound.protection.outlook.com ([40.107.236.54]:47264
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231187AbhFWNpn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Jun 2021 09:45:43 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y1eZjOwueNJH7OQbD1ju6Ud9zC43mPryX+ZO3RHC4asOW651sjvRxsz8fc+tDwNe6uVzxVyZmvfmYylWFEzW5ZUoZg4hNCOjffpWYzslr1K91uBatbfhKuil6cSsCHMviR23popeYHiy3+yXgtU19F94IV9isxaJbJnYXzw36m7W1P1SmpAlzx44n1wVtop321U2I57vSw5FX9zlkrmbjN8/9YfNrdzi2rtcPVdB/iqLty9TDhkTeI+SQJ559GlPgeB940AcVUw5bYx1oloPbbHpdPXFr/wT46zM6MoCH62baRQhy0JcprmWhXd3FfBlbjlYJMhAQA1dMoFYub8qLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CUGQBKDsquFl4O1AltaGrKULGkMf8ZLq2lAIcLrs6HA=;
 b=TpI3zQ+WgDRl/wLDK7tIZoR+mC23+It20g5EX/G8L2wLwx8vWPn03+u09hJW+6gLXiY4lARqSwA7j6XMjklz2XjIVk2aaB6Q7nNewH97OdzrRIHUB8nEUVNI2LhtQQkB25XWWcjBXxZhXlnKjGawkMDcearp7tmKg2T9AwL4wswwn63zxgqHwb0f0KEgXgwbmkhsdl5WMp9rxVvb46FQDbq18rTb2HpKmyI5nVMRHnPIrhRAHaKl4wFglmuQ5TVbRb0JX3zEM2uusHN9YvI2TAbV3fv+lnXHCWmeJin08ztgxXfds++KOADNTxH4zJxvsEj2U8FyLGx3GAeGrxzweA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CUGQBKDsquFl4O1AltaGrKULGkMf8ZLq2lAIcLrs6HA=;
 b=iSzI/wA3SSiiJJEaVBALB/EyEETR3ruvAyBasnMwbTo2gt3EZInLBYVlxrt/TKqQ86WG56dKLK9Qq3U7046YuCxjhJRrrb93/OperlQiWACfM21AVWeDhPLtecALb5VNk7moK/VDgHyTTFib9i8BhaqGLTdem11DNGrSb6LS7s3ojX+lCfery2AV83eBLgaUyFft0Fa8byQViCbtRFflDyxdZU5qeB/5i1q53uCq/spWLX4D4KySFSQ3o4rGkb+8yXuU4qWKmM1K5RmkR/PPGoLT+sas/USy/i3z3+xSpCfWM4DVFvMj+KVfrYbKmzr7QELVmcCgTIASSPP9oDtz2w==
Received: from MWHPR14CA0016.namprd14.prod.outlook.com (2603:10b6:300:ae::26)
 by DM6PR12MB3626.namprd12.prod.outlook.com (2603:10b6:5:11f::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.19; Wed, 23 Jun
 2021 13:43:24 +0000
Received: from CO1NAM11FT031.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:ae:cafe::36) by MWHPR14CA0016.outlook.office365.com
 (2603:10b6:300:ae::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.18 via Frontend
 Transport; Wed, 23 Jun 2021 13:43:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 CO1NAM11FT031.mail.protection.outlook.com (10.13.174.118) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4264.18 via Frontend Transport; Wed, 23 Jun 2021 13:43:24 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 23 Jun
 2021 06:43:23 -0700
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 23 Jun
 2021 13:43:23 +0000
Received: from vdi.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 23 Jun 2021 13:43:21 +0000
From:   <dlinkin@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <jiri@nvidia.com>,
        <parav@nvidia.com>, <vladbu@nvidia.com>,
        Dmytro Linkin <dlinkin@nvidia.com>
Subject: [PATCH net-next 2/3] devlink: Remove eswitch mode check for mode set call
Date:   Wed, 23 Jun 2021 16:43:14 +0300
Message-ID: <1624455795-5160-3-git-send-email-dlinkin@nvidia.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1624455795-5160-1-git-send-email-dlinkin@nvidia.com>
References: <1624455795-5160-1-git-send-email-dlinkin@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 900215d4-3fdb-40ed-75d8-08d9364cdf4b
X-MS-TrafficTypeDiagnostic: DM6PR12MB3626:
X-Microsoft-Antispam-PRVS: <DM6PR12MB36264CE3A87EE36B56C464DDCB089@DM6PR12MB3626.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JLDVGHqyimB9yuUNoUYbTz71GwtlsIStsmQO6jDnHLg4Abm6tGU6Lh3TPdRhae6AZIy5S1Ya/iQBRr4oqEi1t5sQysEYR1k/DQoSjeCVPYzXTIUCiw5doGA6HWhLoH9KuAhK14f5jdGysLLsBknyMbBEb2umOFOi8+7uK1eoWyrZEIShJmAOGnRJPrnwH6BpGjIqzPNuMffO9kq64m/liuR4jlmnuqoRBLLRO389LlHYAa6UCtrj6YcRJd1qv1OThPc3w9yGvGgjy8mjIX6XXYJOeoKR0Lym/zBQwm/EMYsdeqtAaAqRCnd06Jh09p/LiRZzMZvgU1J7+jfmGzCxuxWThqo+D1quL0DpP8jqxh7hQi1MstEB6i5R1SIekdWDojnEV7x8yXcygPbCxkO3aGPe++oTtQF93LWw6CCKS7nnWpVGSro3jX6GBGxBSaovU68mm+iXVu1pDqZ43kuQ0KLdyfpm8rOO99gyMyyMPvHple32ztSxrlZFU3mrlRedYzFZ7hnmy8KMKd2sBib3r1pdWPzphPBQixe0ENUgayR13+PexKvng+8XM0bKS375385s5a9TnVtnunE4bpZttKWhcAbGPScFn+eOl0BEg6rV61NSAAruSOKilNHrZUOnbfnZEnkcXw8PS+RtNZIvlusA2qNHE+hQkkF/zvrAygU=
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(346002)(39860400002)(376002)(136003)(46966006)(36840700001)(5660300002)(356005)(2876002)(8936002)(6666004)(8676002)(107886003)(47076005)(2906002)(70206006)(36860700001)(7636003)(83380400001)(82740400003)(426003)(478600001)(54906003)(4326008)(316002)(7696005)(82310400003)(86362001)(336012)(2616005)(6916009)(70586007)(186003)(26005)(36756003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2021 13:43:24.0225
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 900215d4-3fdb-40ed-75d8-08d9364cdf4b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT031.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3626
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dmytro Linkin <dlinkin@nvidia.com>

When eswitch is disabled, querying its current mode results in error.
Due to this when trying to set the eswitch mode for mlx5 devices, it
fails to set the eswitch switchdev mode.
Hence remove such check.

Fixes: a8ecb93ef03d ("devlink: Introduce rate nodes")
Signed-off-by: Dmytro Linkin <dlinkin@nvidia.com>
Reviewed-by: Parav Pandit <parav@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 net/core/devlink.c | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index ba27395..153d432 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -2709,17 +2709,6 @@ static int devlink_rate_nodes_check(struct devlink *devlink, u16 mode,
 				    struct netlink_ext_ack *extack)
 {
 	struct devlink_rate *devlink_rate;
-	u16 old_mode;
-	int err;
-
-	if (!devlink->ops->eswitch_mode_get)
-		return -EOPNOTSUPP;
-	err = devlink->ops->eswitch_mode_get(devlink, &old_mode);
-	if (err)
-		return err;
-
-	if (old_mode == mode)
-		return 0;
 
 	list_for_each_entry(devlink_rate, &devlink->rate_list, list)
 		if (devlink_rate_is_node(devlink_rate)) {
-- 
1.8.3.1

