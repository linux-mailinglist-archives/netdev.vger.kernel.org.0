Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A341C4BCDCE
	for <lists+netdev@lfdr.de>; Sun, 20 Feb 2022 11:21:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243609AbiBTJ7S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Feb 2022 04:59:18 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243604AbiBTJ7P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Feb 2022 04:59:15 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2053.outbound.protection.outlook.com [40.107.244.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4B9454682;
        Sun, 20 Feb 2022 01:58:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LftpU5mzF3B8Q+RLa9pVyJWBUxgXtqs8U23k2Tfa0Dmwe52B/xgQzuY3xr9rBILaCUEZqfOdbO9ymPBSH+RmMMHPcg8DNxGbXzr8I7RsBd14OWpxDFlYkhwS1JSYPuslqe5obgCxuOQAWekhzqptYo8tKx/RPU34mSjLMf3f0pNxL3ZXrQtfOMhQHm/1OwsihI3iVp/iB8fOf+ET5D+LQpoUvSjMpeozxpBukcOxS7ubhpRGmuw1DonsPStOSa90i/JbgFScY2kPjADh1Z6b2yADQns0okIki3KQbE3Fvvp4ANWJk6W+4WTQG/wIT17/SJdn4VPmDTqVYfB1pqtc9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DLqx1f3oqRyK+hyZ8APioOfIOFcA2sn3/cE+ios4fik=;
 b=DcQKZ2XR2+FOjuK7cq+oynCUxB67NkkWsiWYhs80NEWXdptIjQ4LPqPUJnB6P99gotaiURJhXCyVR5DaWyKf9xnU9lOfEx0JAc+/Xo9zdAkoT61yZ53M50/EMRGOmZmOcld7QP/STQT7Y8aMFnRNoiFridZn9dL8icdi/+rKyzb5UYwHMdx8zPTp5FmmWhL9MVg0fSnCzD/W7XON6Ei72KH8oq+RJKYou102CHjl8Tq4jNFho2n+jPQvFfWl5ileedSKs+sIw4Jwz/mhK1F3/MgqYgstF6MfreIRnoLk3ye1cvLhPivIqGfuXq3k8FpXyvk0638lfNuO5mq97Tp5mg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DLqx1f3oqRyK+hyZ8APioOfIOFcA2sn3/cE+ios4fik=;
 b=nOoVm4GNnZQjb6W4yj0RWHvxentmiSWqluxfTJG93whs6Yxmghy4tWrDhk+DGLDQy4urPqpSs1qfa8elyPfd8FcgcWTjZA2XZF2kN5pTxY3Bgj54tx/UI3aqYhsfvoMuz7o8B7VT9Cz9PySxSezX230EnOXjrtObGs+ZuQhzNxTEZnvEJmKvR62VguqFxqxN62/QJmzhHibx3qXYcku9xesoMM5c1vrViTyX3HIumL7hKVu+u4MVYoIjcuYxCggYFm7DOjK4A9I59QcaIPBktq8mHNprlKPeRvWZDKLbwSg81hjuRBoglshIb8Axynghlcq6lzwNZtp0oYO+ENNa9A==
Received: from DS7PR03CA0174.namprd03.prod.outlook.com (2603:10b6:5:3b2::29)
 by DM6PR12MB4185.namprd12.prod.outlook.com (2603:10b6:5:216::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.16; Sun, 20 Feb
 2022 09:58:53 +0000
Received: from DM6NAM11FT041.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3b2:cafe::8e) by DS7PR03CA0174.outlook.office365.com
 (2603:10b6:5:3b2::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.14 via Frontend
 Transport; Sun, 20 Feb 2022 09:58:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.235) by
 DM6NAM11FT041.mail.protection.outlook.com (10.13.172.98) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4995.15 via Frontend Transport; Sun, 20 Feb 2022 09:58:52 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Sun, 20 Feb
 2022 09:58:52 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Sun, 20 Feb 2022
 01:58:51 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.986.9 via Frontend Transport; Sun, 20 Feb
 2022 01:58:46 -0800
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <bhelgaas@google.com>,
        <jgg@nvidia.com>, <saeedm@nvidia.com>
CC:     <linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>, <leonro@nvidia.com>,
        <kwankhede@nvidia.com>, <mgurtovoy@nvidia.com>,
        <yishaih@nvidia.com>, <maorg@nvidia.com>, <cohuck@redhat.com>,
        <ashok.raj@intel.com>, <kevin.tian@intel.com>,
        <shameerali.kolothum.thodi@huawei.com>
Subject: [PATCH V8 mlx5-next 07/15] net/mlx5: Add migration commands definitions
Date:   Sun, 20 Feb 2022 11:57:08 +0200
Message-ID: <20220220095716.153757-8-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20220220095716.153757-1-yishaih@nvidia.com>
References: <20220220095716.153757-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4aa4ecad-80dc-4fcf-8ebc-08d9f45799cb
X-MS-TrafficTypeDiagnostic: DM6PR12MB4185:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB41852D4B42B77A5ADEA2C770C3399@DM6PR12MB4185.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Gmr9rATy0nRoybWGIID414WdRJ4dvoc7xbKYvD9FPfgRAjxwFmJ6a2sjvWqLdP50LT/5SXZ8+tGeDjwJ2+7oQ+CBDiu3SJHxfEYjbHWuEolNz2tLorFUwt/1nGCGIAnvBx8cEHeW6ogEtEci3sibrdyaJzbZWlY43lvoSTBO/Sy7w1R59rFu3jpQcofMZg9nUTlR5ZF/pIPrmORuUFqgV4kgMQxI1IvCYWXKHWZ/Lz1gzIImm3zOprBujUQK03dJbj9K0M3mKuSEyQD4iVVpiRuaU2Aon8V+Z+5dbZTLehG72nXHd92C4uE7ZfDXVgoAQq8VmPpbefpLV6/iOleIYMjpRHoSxNZnuVISvs4ujpc/8+V/7vLmRYmuRx6/h9/M6UqCHIyQlWuhNYcFe7n/hGxqqcMpFjZsEsu4HVCjUA2GEqSiN0YC23m3rSEIUOwgvyrr0kjs1EoPrtfJpfDsquSsbftknQ9bTgpBoQCaLLPJbm5C72Rh0x/OSkG2bHbDA1dfTVmWCYcf76vZAx5/vVE3+2JY19M92bkbqGD5erPDnl0q4YZy/Bn9FKJRKdCx9z3ReeU2WkZlodoFEzwJEHwBuunSnInoY2xDw2qh4V/jHfWkdR3SmVCvjiRRis/ePSX5/QE8jFxcTbS3NeAW9ot8RfVTqVUEj20GDoMENrNg7sfNSrmhjfVa8p3Y/LUfS+715yX5OzbRGyKkn7l34w==
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(40470700004)(36840700001)(26005)(47076005)(186003)(83380400001)(426003)(336012)(81166007)(356005)(4326008)(36860700001)(8676002)(1076003)(8936002)(7416002)(5660300002)(70206006)(2906002)(70586007)(6666004)(7696005)(2616005)(6636002)(54906003)(110136005)(316002)(508600001)(86362001)(40460700003)(36756003)(82310400004)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2022 09:58:52.7972
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4aa4ecad-80dc-4fcf-8ebc-08d9f45799cb
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT041.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4185
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update mlx5 command list and error return function to handle migration
commands.

Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
index 17fe05809653..4f45ee04b26a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
@@ -477,6 +477,11 @@ static int mlx5_internal_err_ret_value(struct mlx5_core_dev *dev, u16 op,
 	case MLX5_CMD_OP_QUERY_VHCA_STATE:
 	case MLX5_CMD_OP_MODIFY_VHCA_STATE:
 	case MLX5_CMD_OP_ALLOC_SF:
+	case MLX5_CMD_OP_SUSPEND_VHCA:
+	case MLX5_CMD_OP_RESUME_VHCA:
+	case MLX5_CMD_OP_QUERY_VHCA_MIGRATION_STATE:
+	case MLX5_CMD_OP_SAVE_VHCA_STATE:
+	case MLX5_CMD_OP_LOAD_VHCA_STATE:
 		*status = MLX5_DRIVER_STATUS_ABORTED;
 		*synd = MLX5_DRIVER_SYND;
 		return -EIO;
@@ -674,6 +679,11 @@ const char *mlx5_command_str(int command)
 	MLX5_COMMAND_STR_CASE(MODIFY_VHCA_STATE);
 	MLX5_COMMAND_STR_CASE(ALLOC_SF);
 	MLX5_COMMAND_STR_CASE(DEALLOC_SF);
+	MLX5_COMMAND_STR_CASE(SUSPEND_VHCA);
+	MLX5_COMMAND_STR_CASE(RESUME_VHCA);
+	MLX5_COMMAND_STR_CASE(QUERY_VHCA_MIGRATION_STATE);
+	MLX5_COMMAND_STR_CASE(SAVE_VHCA_STATE);
+	MLX5_COMMAND_STR_CASE(LOAD_VHCA_STATE);
 	default: return "unknown command opcode";
 	}
 }
-- 
2.18.1

