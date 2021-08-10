Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BDDD3E595B
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 13:47:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240309AbhHJLrW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 07:47:22 -0400
Received: from mail-dm6nam10on2046.outbound.protection.outlook.com ([40.107.93.46]:48736
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240257AbhHJLrH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Aug 2021 07:47:07 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TgxxeeWXTqzh8RzfGoEhQ5NLyCl7hIc2R9Z8E9r5bNUaDbhow7f0nMF0euvWp+skqNxZI4mqffRAxFfUi8VjIYwpVj+0cKD0NNyTQAH9+ohrNasjXln/1fW6TeThRJ7/swJt0mwrpIPwvxaB1A+GGdyGtd/qfAxEdeokzHl/2sGARUcdrcr8GrlYj/XyMvng5BINjAHnQknwP3ojQ+jz4+QK/k46MbwcswyiDBF+VT4Fn5I+X4k6NgBLo+zWoCZgH58v6LukAbWeUzyZZLwIszusOXKl7ruES3kM2nRy2MDxMXX/JLPFYEaYODfRT7nnmyxVsD6DK18a2oofwsxCdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AXr1xJ9xsuCjzTyvW2827Y7vv2eBERDsEbuANeR9gAM=;
 b=AKqtOcsw7wNBOz4Y+4JuKL4srhL6YJjXylvRootWB3B7feRp3bgQc/WdWLVlVYAEpZ5nNiIifi4/jufZyN1Cd25FXV83jRHxuAJ72Zx3j6N6WjB4/nY0oTCa0CUkeK1Fgd0ODXWpXuqeyE86Z3//AHYJpzBzAjLgIJVaplbY9XE/V4Wkoi/m67MWabpq6eEd6tjb8jNYU7tG+N2IMjJIh1Mxg0lcqpIvG3UXxRu1mtgq8FTSeS141/kNt1+jHJTkq7tGKDmfPEghdz96ie0kUODcXiPohP+L4aC0AJbqMHqPcvvMv1b/VcCcXIOz1SgV8zd29+ESGTAq0p1+8PwW8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AXr1xJ9xsuCjzTyvW2827Y7vv2eBERDsEbuANeR9gAM=;
 b=WHd+HQDxGnSPJjmkKnSqaJlZlXTXlhk6BBY8YoA1vgV1t7dC/g57NbrN5zsduVIW9B2V/dLB8MIH7zYe9kv1NZMjcPE3+0NXWfr1LvgZX3h4j8vUBzpw+qU4AMwF+M9E22el2Y4OszkPyWs/K1slU0ERB6Cr2akZOFFcVOU4sOwkaDzqji1f60iYx2s25i+/iNunOj+xavhoaJWLYRXT6aQGSmRazNq+cenoVJbLjdW52E02d4W+3b8Bk344Xp5PzPPprf/+KwvKalCPBemX+HJfp5hndEFK2yyoSZLWUnHk6Joyvp1TSSMT1WZBowFxKB9L+91dQGMj9Y16wP6RHg==
Received: from BN9P222CA0008.NAMP222.PROD.OUTLOOK.COM (2603:10b6:408:10c::13)
 by BL1PR12MB5254.namprd12.prod.outlook.com (2603:10b6:208:31e::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.19; Tue, 10 Aug
 2021 11:46:44 +0000
Received: from BN8NAM11FT064.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:10c:cafe::fe) by BN9P222CA0008.outlook.office365.com
 (2603:10b6:408:10c::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.17 via Frontend
 Transport; Tue, 10 Aug 2021 11:46:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT064.mail.protection.outlook.com (10.13.176.160) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4394.16 via Frontend Transport; Tue, 10 Aug 2021 11:46:44 +0000
Received: from sw-mtx-036.mtx.labs.mlnx (172.20.187.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 10 Aug
 2021 11:46:42 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     Parav Pandit <parav@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        "Leon Romanovsky" <leonro@nvidia.com>
Subject: [PATCH net-next 07/10] net/mlx5: Fix unpublish devlink parameters
Date:   Tue, 10 Aug 2021 14:46:17 +0300
Message-ID: <20210810114620.8397-8-parav@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210810114620.8397-1-parav@nvidia.com>
References: <20210810114620.8397-1-parav@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.20.187.6]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bbf06065-58ea-457c-834e-08d95bf486ed
X-MS-TrafficTypeDiagnostic: BL1PR12MB5254:
X-Microsoft-Antispam-PRVS: <BL1PR12MB525471EA37968AC5C62C0482DCF79@BL1PR12MB5254.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:854;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DuvJcqJPMekiuUPwJgU217Nh3YxHC8/79tSNfkPzQ3WBTNHYAXykbIjrbA+xOCHva3OPS7VoqIVuadQFtny9m7qpaEDTroQzBHc2prmpN2SPOgCnL9KMaXmd4biAqyTrDy6FWnqMIeK7HcUTjFI3bqgBQJbdSIyXSQo5axGzA84FIoAOfor9Np9Mub+9l1K9G1fB59p8O1joggUbCvenM82kOAdqIzJStFixE0YiZrxmwDaXLZSfzix7vVT+Zv/6kXxN/I+4GOlY+ZAWgrSgOz6bgTzUJ2XX6DtgOkRTwKYU7q0oFhs9xhjFS3C+TRVMOUrEaMuvxwFO8XAj4F5D40lOyogPPFivQH8jfNAUpe2u3nes9OgUV1BUfMJXW+mRDdg4sYn69OJTp2vybsr8S+YcAY0+q2dD0pUqQHM8h8YtFX5kyrZ9hOm6ChSXItLVeOJOZLIWYPJkdkBJ4zGU2bnP8YW/dgMc2IPMwdUlUlDICEeLJyUQoqz6dBfI8lM/EUjpVV/BI2UT46ozCzbLCPVkDUtKJuWv/sxFeM3gZGjm0TvTeAWmqQnyYMCQJ49+4I2SZQSd/q/MQe0579mFMAprvDOhyvDEnYIpRXH65HH6deipxda+rJ1O7kicOvyuxKytceFUsYkTvsJ8US+zQ+XVOu9t8BTOgyU1e5gkv1AMgYGKs9H6hQGTBT7yTD2+PyXrcEVHRl9UK+ZiZFP4SQ==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(356005)(86362001)(36756003)(336012)(6666004)(2616005)(8936002)(426003)(1076003)(8676002)(36860700001)(47076005)(82310400003)(16526019)(7636003)(70586007)(70206006)(2906002)(508600001)(26005)(186003)(4326008)(5660300002)(36906005)(316002)(110136005)(54906003)(107886003)(4744005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2021 11:46:44.1787
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bbf06065-58ea-457c-834e-08d95bf486ed
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT064.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5254
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cleanup routine missed to unpublish the parameters. Add it.

Fixes: e890acd5ff18 ("net/mlx5: Add devlink flow_steering_mode parameter")
Signed-off-by: Parav Pandit <parav@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/devlink.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
index f38553ff538b..0ec446d0fd6a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
@@ -671,6 +671,7 @@ int mlx5_devlink_register(struct devlink *devlink)
 void mlx5_devlink_unregister(struct devlink *devlink)
 {
 	mlx5_devlink_traps_unregister(devlink);
+	devlink_params_unpublish(devlink);
 	devlink_params_unregister(devlink, mlx5_devlink_params,
 				  ARRAY_SIZE(mlx5_devlink_params));
 	devlink_unregister(devlink);
-- 
2.26.2

