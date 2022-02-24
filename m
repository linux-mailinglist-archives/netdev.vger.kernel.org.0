Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80D554C2E30
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 15:23:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235441AbiBXOWG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 09:22:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235460AbiBXOWE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 09:22:04 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2059.outbound.protection.outlook.com [40.107.237.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C02514FFD2;
        Thu, 24 Feb 2022 06:21:29 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RchzrXBkcMhJJX4lvRUyYX4HHQ2cfsiuFt7obeKCRhiTmNboqE/Zjmt0tA3L942n5EEWSb5S87NCy9HExh71fAeVnDLW0wjmnG6lJ3iTUCL1Uh+perOz+GGOCXIuN0ERY+1aS+SKwvP4HdDdYOZ9YaetogFNlQg91l+SrNt5Uk3CO4wVIxNHDdQudJyoXYWHFylS+aVpHErj9URYDnsqgIfSI/Mzo/5/5n0euD4isjpdXim5B/D+Ur0ztNDJu25m03ripBVBZIM5aij0/Vg9rqjFGS2s1j0Abt62pZ93hvpSG0riMM/n3RdwuppVKpXLY7EJLcEoYKYlnYVxc4CLNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DLqx1f3oqRyK+hyZ8APioOfIOFcA2sn3/cE+ios4fik=;
 b=CM8Fhu2D07D5f4jNmk63xV0kYDu6VuQNiB8Cv2E2YazSIAVsIbRjuXTDGBT6IBZKJPbBsFBHBDYzqCgy8A1bP8QJYZM4itiWvEjRNYu5ZeEhK7L1OVNF4M3CjJ5Sjomfn/SGZ/fZWFz8H9l4Vlja6VeQwLI0yDoYfpTvOGLUtY4ajABu975pdfw6MWtnAo2OGa6GSFV/qU9tJeq+CYzLZ5p1cDRJdw858ALQ8uQCsLZnMXt+q1++x9V2Ip3iEF9NxalRp6NtOJx8IrDEcf7ZXz7v1ri+FWjMEgQYnfyKMfvubONacbBXIj3EiK8d8pzeOP7Xj39N6E1tMm/ca+YdDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DLqx1f3oqRyK+hyZ8APioOfIOFcA2sn3/cE+ios4fik=;
 b=AUA+Y5YX0B4ZHVEGYzObnYE8wHBGbOTzSsbN6rJxvw6VOqMRlfKOlG3dhpLk5oODgviteILIUXPPsXRIQHq9t9ZLJ4ptQgfUgV/1QMluimRrVJTn8TXtZcgjjBqxzoHS2wB+qHMoUDDxC4Ix+VMetEbKuscEAogklKNKUCcSMvIF/z/9TXkRHOEb1wv94vci7O+h0yV/oSYPVrc6L8evqqABWl8/jkRFl0licF39BZzBQTTzlLwA1DGXpYdllDmcyXjm5BwqfOYzoDqDVYyvTOkXTrqD74OLePgSv/8wMHrwhU9Y1vmhV+Mg/FSlaHDo/7Bkex6DJ1B6sCV8amPVqA==
Received: from MW4PR04CA0388.namprd04.prod.outlook.com (2603:10b6:303:81::33)
 by DM6PR12MB3627.namprd12.prod.outlook.com (2603:10b6:5:3e::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.24; Thu, 24 Feb
 2022 14:21:25 +0000
Received: from CO1NAM11FT005.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:81:cafe::17) by MW4PR04CA0388.outlook.office365.com
 (2603:10b6:303:81::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.21 via Frontend
 Transport; Thu, 24 Feb 2022 14:21:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.235) by
 CO1NAM11FT005.mail.protection.outlook.com (10.13.174.147) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5017.22 via Frontend Transport; Thu, 24 Feb 2022 14:21:24 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 24 Feb
 2022 14:21:23 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Thu, 24 Feb 2022
 06:21:21 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.986.9 via Frontend Transport; Thu, 24 Feb
 2022 06:21:17 -0800
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <bhelgaas@google.com>,
        <jgg@nvidia.com>, <saeedm@nvidia.com>
CC:     <linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>, <leonro@nvidia.com>,
        <kwankhede@nvidia.com>, <mgurtovoy@nvidia.com>,
        <yishaih@nvidia.com>, <maorg@nvidia.com>, <cohuck@redhat.com>,
        <ashok.raj@intel.com>, <kevin.tian@intel.com>,
        <shameerali.kolothum.thodi@huawei.com>
Subject: [PATCH V9 mlx5-next 07/15] net/mlx5: Add migration commands definitions
Date:   Thu, 24 Feb 2022 16:20:16 +0200
Message-ID: <20220224142024.147653-8-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20220224142024.147653-1-yishaih@nvidia.com>
References: <20220224142024.147653-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bb8a7e7b-d289-48b8-3194-08d9f7a0f077
X-MS-TrafficTypeDiagnostic: DM6PR12MB3627:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB3627F2D008C28297022CCA86C33D9@DM6PR12MB3627.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xEJiJfr+msM2Ccrs1BlnL/oYQYFlviIYplRtyp9yuLvW7q18VeQy8xW0XFuIsd5usCh84KpKdk/U6/eFlV3C0knNLI4Qp3J1CwGsrVWOqZYAYH29n7dYBC1gWuimTue4h+yBCjpvK0+GhNcxqK3MXFIwxXJlT7cNVODe+E5UAl5D+QIYXlJ62xlhLnDaaQ2JLCoai87YO3NW9aCEmAELOvpEwwgzc56q1/XIPXKk4ep2yr1jvncVN/wHupuH0IlPGdXiwAYWc3xNHzbLN2SFJ2udSRA83299I84yeutYc6Z6s6Q7e689E/aGCD/gYVLJJpUco5Ai0i1e80xygvqf85VAtTACIk6KdKTdKQh+RHbI94m6xpRyjMt0wWZV+xsrupIRvq65iwmTsO0VKyDQuTBFz1j9al8Koe+W+Lgspv+SgfdQcksqFB2rBLh6lWfwjGOm/3AX8PZ9OMHETlwjqqIATbjNe2W7GyUDqBw0JFEmwRJxlBNIPeGex57Wpf2xXDF7iKmhgEBr1kNqRZpYNt+u90K6y49BzpROi57EfjncSXkP/RZm47ses93Z6sPu4gK73ekyeddfq11vll7G9kv9mU6JmVoI1q+kQdnNyIdo7qUD2NBS+5GFauil2/3FoVff87H7WY+x259PEXpNs87gcHM7Vdvm9v0wMdzGzoiiAHDurmhNanp0mTPYkXfvddKS1/vAmuoFxOPinjpDjw==
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(36840700001)(46966006)(8936002)(110136005)(26005)(40460700003)(1076003)(2616005)(86362001)(2906002)(7416002)(426003)(336012)(6636002)(36860700001)(54906003)(5660300002)(36756003)(7696005)(508600001)(316002)(82310400004)(47076005)(186003)(81166007)(356005)(4326008)(8676002)(83380400001)(70586007)(70206006)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2022 14:21:24.9557
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bb8a7e7b-d289-48b8-3194-08d9f7a0f077
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT005.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3627
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

