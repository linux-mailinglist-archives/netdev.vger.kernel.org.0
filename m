Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2317F640218
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 09:30:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232829AbiLBIaA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 03:30:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231468AbiLBI3P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 03:29:15 -0500
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2056.outbound.protection.outlook.com [40.107.100.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A368ABA1F
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 00:26:49 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KSzqRnl8negW/FGKCHxeReGycRpZuB6XsBrUjgWnqHMpuxDi6Qy4zrv57uXAEzO67uvUCmrkbLb4KfL/mqE5Th15nT7ugLMl4AmwPlTGa9qelnaOZs6kOPvUHuVWDKrvhF0p2ntWM2IKQQ1KnqK769Wmz7nrcmiiSClyg2owS8lle+CvV0EKE9Ml2Fig/13niiHpC5WCCaLq8lbo+zdGMXbZbebw56iS1z8w+uf3K2HFqIHvIGuY91AA8kEZ6wTFfT6S8IYEPV2RV4qF2TjctU+tXXGVS/ZTWCmObkde1DsJcHAp6Otntt1jzfUZ9OABFRai0Qk3q9pyScKV9CWqKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LTny/6TSqOFfO8nfwISfiiAAkcHEXJpf2tH80vHe5Fw=;
 b=ONGy8oKcPoZ8EW0yO9WaTBcbklWLuo7gAAG5cS6ob0ZmSMmZjiDlRWwDTpyKFZ1NtlpCwV0KqZ0B8qOe29yQLVWk++yHVx/bDBblNmJ2QLNdrJ/Y+lF01qbLI3cB/2lyE/fYJGxfYRyNHgqcCbuJChjpF/G3/abPRqWnV1gxC45IwMPOlhcOQvhrmuRucvjSWuUoTvKI0I5oQPfE5+Hp7bNdhKLpnhYHeKkPXV/vC8UqTf7yxDoI1TADBkAQqAwPdLJDfvOTe9FtMTwbp1zUwJoq0/yBIOSizoDc7PqY5TexJPIULOhAyPni56szM33nY6FLtVeIkfLM01wteVR7Bw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LTny/6TSqOFfO8nfwISfiiAAkcHEXJpf2tH80vHe5Fw=;
 b=JVQPoJQN/dSpwJCN79IAIplY58qbrxU7/knFJo8j4qYNqtkb8d2LL88lBxIQBjnhqTInqv7K66ACWbYB76RRRbWaO3pcuIIoUHc0EiHcj4Nf2DxwUgyeZXb7nQ7Cq+J1tQQiYhDSQdsjUY6t0j72yQHBdAzvdDyJML6E/o562Ls3jdvBrUEGkGM++Vw7szzIWphc92RSiV/suSzYGUYDHS91bZLwPIjt66/1WejjMZrcnU5dHO+Xy8pGh/v9LuyLOuXflrBCQJC0dW5Fg4pyLIYg3onKH/JK03ZvPxyx9F2Pv1mahwA6y/uwTMn1UWo2qZS8R1vCXIG8O1dRrGIJoQ==
Received: from MW4PR03CA0212.namprd03.prod.outlook.com (2603:10b6:303:b9::7)
 by SA0PR12MB4445.namprd12.prod.outlook.com (2603:10b6:806:95::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.8; Fri, 2 Dec
 2022 08:26:47 +0000
Received: from CO1NAM11FT099.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:b9:cafe::61) by MW4PR03CA0212.outlook.office365.com
 (2603:10b6:303:b9::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.10 via Frontend
 Transport; Fri, 2 Dec 2022 08:26:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CO1NAM11FT099.mail.protection.outlook.com (10.13.175.171) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5857.17 via Frontend Transport; Fri, 2 Dec 2022 08:26:47 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Fri, 2 Dec 2022
 00:26:36 -0800
Received: from nps-server-23.mtl.labs.mlnx (10.126.231.35) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Fri, 2 Dec 2022 00:26:33 -0800
From:   Shay Drory <shayd@nvidia.com>
To:     <netdev@vger.kernel.org>, <kuba@kernel.org>, <davem@davemloft.net>
CC:     <danielj@nvidia.com>, <yishaih@nvidia.com>, <jiri@nvidia.com>,
        <saeedm@nvidia.com>, <parav@nvidia.com>
Subject: [PATCH net-next V2 1/8] net/mlx5: Introduce IFC bits for migratable
Date:   Fri, 2 Dec 2022 10:26:15 +0200
Message-ID: <20221202082622.57765-2-shayd@nvidia.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221202082622.57765-1-shayd@nvidia.com>
References: <20221202082622.57765-1-shayd@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT099:EE_|SA0PR12MB4445:EE_
X-MS-Office365-Filtering-Correlation-Id: 54c94dbe-321e-4c23-abe0-08dad43ef44d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZMJWQr123F7G95pi5/R3YK5Hy1zYwELly4HyyGI4lGJ3kMMw2S4oORFT3vZ9zyPgA+blUCKQW+pxcDpuVfF/8/WRLqZjyRbq8ZJgIIuXbUleP+L4L059tKPLkZyOMWr7uvU9v73PvkK9j9/ZoDQdGVD4c1TO90jY4L4/10e9AjATNQOA82XsRrccv2hnCruRe9KojFlJPuIFC9/VDYe22cAoOGW0/k9FnMEi4fVts2eRkXg2QGLuXcTrV2yDmm1BSUlbwVEJBFeJPArfBWtUM3sOMOD9i4PDFRltYfieCyLxKUlTWBycWuZkk6bLwyRZ8PUaEU39nCgIHLNOeIPyCwziS7raDkYts5oOf3IhUrdryB0qXljzR9WNptX7P3Oj/0jfzjnQA/8mu2tfBomlb+EntBBQtP4tFGupx0JDrZ214DMWF3YTpSEwLrC8YiqFOcOp63ML7R2WsDVtbDeFmDmlQA3Pu/TWMZtmT5gAauQM2sSYDs4vOUEGlRNCkurOW4EWN7lznQz/lt3ipfxIRO9CvIl/fswF1f3FPjyCctugG7T7DLRd5upu8f3fV5eqDigEjXdiAyCZt5VkU5Mr0COf7cZTtBnz4XDEWjAtXr3dxdyyH38zl7xVKLN/uIxQm9v+U1TAZxQIBZTwct5IUAh1xOKHqFKnvmb4kNoftcYBHfR71/Nkpu9uSe9RnS/yzmnUU8fNewBZVi2VEXJ6Og==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(346002)(396003)(136003)(39860400002)(376002)(451199015)(36840700001)(46966006)(40470700004)(82310400005)(478600001)(6666004)(107886003)(7636003)(356005)(86362001)(82740400003)(70206006)(2906002)(40460700003)(54906003)(8936002)(110136005)(316002)(26005)(16526019)(186003)(336012)(1076003)(36756003)(41300700001)(70586007)(4326008)(8676002)(2616005)(40480700001)(83380400001)(426003)(47076005)(36860700001)(5660300002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2022 08:26:47.6575
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 54c94dbe-321e-4c23-abe0-08dad43ef44d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT099.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4445
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yishai Hadas <yishaih@nvidia.com>

Introduce IFC related capabilities to enable setting VF to be able to
perform live migration. e.g.: to be migratable.

Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Acked-by: Saeed Mahameed <saeedm@nvidia.com>
---
 include/linux/mlx5/mlx5_ifc.h | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 5a4e914e2a6f..2093131483c7 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -68,6 +68,7 @@ enum {
 	MLX5_SET_HCA_CAP_OP_MOD_ODP                   = 0x2,
 	MLX5_SET_HCA_CAP_OP_MOD_ATOMIC                = 0x3,
 	MLX5_SET_HCA_CAP_OP_MOD_ROCE                  = 0x4,
+	MLX5_SET_HCA_CAP_OP_MOD_GENERAL_DEVICE2       = 0x20,
 	MLX5_SET_HCA_CAP_OP_MODE_PORT_SELECTION       = 0x25,
 };
 
@@ -1875,7 +1876,10 @@ struct mlx5_ifc_cmd_hca_cap_bits {
 };
 
 struct mlx5_ifc_cmd_hca_cap_2_bits {
-	u8	   reserved_at_0[0xa0];
+	u8	   reserved_at_0[0x80];
+
+	u8         migratable[0x1];
+	u8         reserved_at_81[0x1f];
 
 	u8	   max_reformat_insert_size[0x8];
 	u8	   max_reformat_insert_offset[0x8];
-- 
2.38.1

