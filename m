Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7075A63D503
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 12:53:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234839AbiK3Lxa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 06:53:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235013AbiK3Lw7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 06:52:59 -0500
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2089.outbound.protection.outlook.com [40.107.101.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BC3E4731B
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 03:52:49 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PkRdhRu+ShDNCPIhCKl+CDgR60N9fowJIUSgllmOFuEaOiuA0xZl7K5ptmOnb146rPygQeLQOOp7tNXecQ3qmgTQlhb3iQ91ofTptlo1WVaODbSU7GBYd67vsYQuJhaykvXkpbNhcci2fRoOb3MR2Y4zSkL2YalAQtIi8D9M9Msh+KG91J20njpRoi9rGcHiAatax6qRLZ7BaAfiz6uTZeXNSXFORTq0vEMNmEHs71o0wcUQaCXg7svcUwqnV946mbgBK55XL+BEbbG8flzvzHzUjRlWiZwLOJ3AyotqgNJXWkBEhk4SQ2M6WD14+ycXY0ltrKW1MDjpvTdlwIJviw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UdYWbJu/O4vexc1lw1wYV1Uu1YQuuFUiLhiW3wfBEOQ=;
 b=N4VH475MUhONYHLz3LnvpAgmqMbcupT/jxcOthL+u/tra9AY8+AfC3cghmp8ZzU8OCEfUmq53bpzTzREwj7XCk12JlXFBijzdsgzgyxGI7moEJe6fOpZSAIN13ijRPixgnCTfo0ukIxM3nIm4Vy6p5RomKiVYHWBrx0+XfK8k/SYUzNOaViZMUd+oRnXrTo2HKw7Cc88K9vc3BY+alZW90vM8yTbyhmOPMePWgt6qoeftfVNPBg/w5nKegpdT0PvJ6dR5RblQr6uOPjJbhXZ5VM2I7RFRV1Q2liZHXqVz7UPbyxutRKlYdoE+h6TYfGbS5T9QN9tBQr/ZsNF9IazNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UdYWbJu/O4vexc1lw1wYV1Uu1YQuuFUiLhiW3wfBEOQ=;
 b=LvgOVig9UCgB5bDPX4B+Aes0k4icgP326fdXJBlwDyJ6jUs9b71aN9eTkcW9JGcLoBnIajEtA1VyHjtelycohNwet05rDytckl0qb90Ezign8n2ZinNFoq0aZuocFjw40RGIT1u2TYCjrCPxGCinYz+oJIwfziZa/R6RX8r3yJ2Mq9QTDaN6abUhxcYZbtD4mPrqsCfjGgtzNd4EtQefBysqrl9okETkSB+lbUCnszZlqwUb1IiQU8+GvGPhh3F+rCTYcOOerCKhmElhBj5voJk2CGJgcCL7cjGLeRG2BAenbRkBz0MqmHq8EZkc152u+zSrIS2DC0sE2jlXZPD/+g==
Received: from BN1PR13CA0010.namprd13.prod.outlook.com (2603:10b6:408:e2::15)
 by CY5PR12MB6621.namprd12.prod.outlook.com (2603:10b6:930:43::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Wed, 30 Nov
 2022 11:52:47 +0000
Received: from BN8NAM11FT106.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e2:cafe::bb) by BN1PR13CA0010.outlook.office365.com
 (2603:10b6:408:e2::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.8 via Frontend
 Transport; Wed, 30 Nov 2022 11:52:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN8NAM11FT106.mail.protection.outlook.com (10.13.177.7) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5857.22 via Frontend Transport; Wed, 30 Nov 2022 11:52:47 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Wed, 30 Nov
 2022 03:52:36 -0800
Received: from nps-server-23.mtl.labs.mlnx (10.126.231.35) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Wed, 30 Nov 2022 03:52:31 -0800
From:   Shay Drory <shayd@nvidia.com>
To:     <netdev@vger.kernel.org>, <kuba@kernel.org>, <davem@davemloft.net>
CC:     <danielj@nvidia.com>, <yishaih@nvidia.com>, <jiri@nvidia.com>,
        <saeedm@nvidia.com>, <parav@nvidia.com>
Subject: [PATCH net-next 1/8] net/mlx5: Introduce IFC bits for migratable
Date:   Wed, 30 Nov 2022 13:52:10 +0200
Message-ID: <20221130115217.7171-2-shayd@nvidia.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130115217.7171-1-shayd@nvidia.com>
References: <20221130115217.7171-1-shayd@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT106:EE_|CY5PR12MB6621:EE_
X-MS-Office365-Filtering-Correlation-Id: 2f5718d7-1a0f-4f21-486a-08dad2c96693
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xRq/TJDl6TVV4/gJaPHJlhbtetB7YfGnMC2zx4URj9ich3lXf/vcNRm4lazZsNhv+8NopPzu3gOvQpLLfjngpagT9jEfp1AJbyUlOfwtvBsCxdY1mXLnE23f1SIUD5X0S9/S37ZXvDEecSdthlfYuGTRnKL4kqA2eDG/19Ja5KLeiLgQOhDr+7oLjR/yuDRnWBviYBW1Zz6g16mRaF/9c1XsAwOCDmaWItT2+Ea3NITLE/FHHZVF1sL0wsU54sf5cftqZ6rvyrKtR0UCxdjlnX5aGD/nnZZlnSSJkU3hR1UdaV9/7/GE83M+y58RGaV38nEBrrcOqfZRQljxqjZX8i6RuqVpzynkvo220Wu5oaJ4ktnZuTgdFbWRbb03qW5WyQim6ouq+9z8jlvZ+VNoDVO+0ZKIbeSJdR3gH4L29u2/ilJy1228f3adLWBgxNZZQ4q08omF2krAymvB/ip2gYxqimxRfTzkiJUIQB1fsoSHeRSZ8Gne7CrEKWEE3c5nEieoB6igrYRUJUkagIxLXu/OObA6uxpTgIWcFJcj/qkIFt5EuJtjbXCiph6xYbDuSv9F1CKCeIUdC+MFvpMlhg/Ly6kIcGPjYzhWAgVgu/NrlghhPG8TT77/cXmFZ2ZfR0R3AmZ8BytDLYpZKEJ1x9rOUtJI74d7Dy1+/cY2/zvWHpolR1Wb7D2amJVsWzlZbS1JavnxvUrQ/UHlDdr/yg==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(346002)(39860400002)(136003)(396003)(376002)(451199015)(40470700004)(46966006)(36840700001)(356005)(40480700001)(7636003)(82740400003)(336012)(36756003)(82310400005)(26005)(41300700001)(478600001)(6666004)(8676002)(70586007)(40460700003)(70206006)(86362001)(2616005)(4326008)(54906003)(110136005)(316002)(5660300002)(186003)(8936002)(1076003)(47076005)(426003)(16526019)(83380400001)(107886003)(2906002)(36860700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Nov 2022 11:52:47.5503
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f5718d7-1a0f-4f21-486a-08dad2c96693
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT106.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6621
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
Ack-by: Saeed Mahameed <saeedm@nvidia.com>
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

