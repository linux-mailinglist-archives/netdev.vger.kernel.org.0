Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 516CE4C2E41
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 15:23:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235444AbiBXOVy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 09:21:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235437AbiBXOVv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 09:21:51 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2055.outbound.protection.outlook.com [40.107.223.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EF4814FFC1;
        Thu, 24 Feb 2022 06:21:22 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EgXkssP0VP263oJBkS8VAxHLXsaIHZfbTgG0FnKoAv2izDD5qnf/Jog/Ig7INaSkfgWNnq1PqRhP8pajTblbWdf26YQW6xoCvHJ4R8MIIhAPM9wCk0z2ACJabzizwuZAC7N68kfzK51RwH+ZSyb0XOL13/R8iKZN2UK0s3YHiS0CHmkAZgLITsjv82ChB2Y2Y9oeQunMwNWGP9CASn7t6SskCn0+ouwJoiy5nK9tA+Gbe8O7s51YQ7dY5hfUs+o8awhG6ZmEolDnacsPJVT1hrWU5Fua+OSD6JDFcfjU6Awxu5q7yRAtjvvYClVNGyhjLi7eIxViV9qW+ViIpvf22g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yQit7bYsbWylJZOdIzvuZVWs2A5k9YlABjcjIbGp8Zo=;
 b=fGXJ8u2EkzSmuMpNaxi+YVSUKnyK99ZV99xsVVx4gXMn1yR0at7KVSfo01SuMPL0lrE4EEHjujgPkI0zNcespYP8u58oB4vIRru0WdiR1031aG7bTRmQKkGtLwEXIpAu2wRKx0WR1erJ+tNwYrGx6L6lQp0CZlSdSe33yofq+RMTNjAZ6B6qUA95dM9dqnT55At54cC61+MLV+fC6mTM7VpaMxvIR8VttLEr2CBQnCg/7N3tqV3uAnOwqvuuG+ZpKU8hID8NvaJj6KYe1EZWavTASnjYhLdvQXoNUf7BZnZ0YfuObzgEeXRoHJ4Oer/uKL8+mad/I8UcdbDmP91RJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yQit7bYsbWylJZOdIzvuZVWs2A5k9YlABjcjIbGp8Zo=;
 b=pV60NcMw2e7lz+2Xnfi4B4UQCuxc84ZO9u7IpZDQUhKhEM8WBAlJR9VuRuhfb5YYTLWf1QEyk0+FQGS7uz8wrPZVUtWrNAgEYZwXWURvcYE1rRxc7ioHMrSilZjE8VL5aw8Jt9f0pqLMIez8HLvDTYfcJ3k60ANBFKiSm8U6dkQdu7VzbYJFYOHcxZH9rF2VsvNOtZNG13i+uOYiXDwddhwfx85bsjdJi7ig6fxHvtRfj5aYhic8L6/SdINuA3tizPzMXrW4sTQIQZ9R9vYk2HJcg5yfxpAisng+aDyD5Au9J2kLb3yRsO3yw53XIKRwRH00lZoK4krpjo8hFKJdKg==
Received: from MWHPR1601CA0017.namprd16.prod.outlook.com
 (2603:10b6:300:da::27) by DM6PR12MB2762.namprd12.prod.outlook.com
 (2603:10b6:5:45::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.24; Thu, 24 Feb
 2022 14:21:20 +0000
Received: from CO1NAM11FT061.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:da:cafe::f3) by MWHPR1601CA0017.outlook.office365.com
 (2603:10b6:300:da::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.17 via Frontend
 Transport; Thu, 24 Feb 2022 14:21:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.234) by
 CO1NAM11FT061.mail.protection.outlook.com (10.13.175.200) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5017.22 via Frontend Transport; Thu, 24 Feb 2022 14:21:20 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 24 Feb
 2022 14:21:18 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Thu, 24 Feb 2022
 06:21:16 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.986.9 via Frontend Transport; Thu, 24 Feb
 2022 06:21:13 -0800
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <bhelgaas@google.com>,
        <jgg@nvidia.com>, <saeedm@nvidia.com>
CC:     <linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>, <leonro@nvidia.com>,
        <kwankhede@nvidia.com>, <mgurtovoy@nvidia.com>,
        <yishaih@nvidia.com>, <maorg@nvidia.com>, <cohuck@redhat.com>,
        <ashok.raj@intel.com>, <kevin.tian@intel.com>,
        <shameerali.kolothum.thodi@huawei.com>
Subject: [PATCH V9 mlx5-next 06/15] net/mlx5: Introduce migration bits and structures
Date:   Thu, 24 Feb 2022 16:20:15 +0200
Message-ID: <20220224142024.147653-7-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20220224142024.147653-1-yishaih@nvidia.com>
References: <20220224142024.147653-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b806a277-b081-4b64-ec67-08d9f7a0ed8c
X-MS-TrafficTypeDiagnostic: DM6PR12MB2762:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB2762404E02CB026C2DADBD84C33D9@DM6PR12MB2762.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: D0pDMzzqKTzh2TYSxylKUHyk1EcQI7EDokbWpVfwK/+6WpPkg6pjw+HuA1KM/xireOY0a4AqnOui4EZjQJTqqInToY0bJQ76b2/lDakGzOjscIwPTn5dgnUaqfDAd3p/gg7VQUVlWr70BrF236aqYB6aH8W5I6FpyKQUWfr+tl5s/gQnBnmiOXnBTkwX+q8xHBXz9uza7CwQqts2kP/gtgGO7WvQS6D6xxM1tdul1Nj8VlT7bWKaYL58RIanYP4K/7vkHMXtVkpI4zjSW8PiohFzgF7WMDPRQSKaq997z/HoJWNaBBrVaFH3piTd0/q3r7j9s2gwhXPmr9SWWCJUKeQOhpuwN/X/qfmfyL2fVL3sTsZsrez2QKXUH5hisn2qlKnrvgAVRV1LVWA75LkoUCwTjdt7bVnPdsqNko9BuRXZnkCO4TKGTXQCvWfqDzFy/qKvH5Mks6a/Nh/hUdmP7LQpNlWHU9aX6tdeXg7o0ufWtECSBZc8suDlnUbssr/+9yPZtJLPBQYp6R/vnXyZNNjDR7oUrxHvUoys5WjXEpGbxRt8N4gWjNMt07QHA9EO7aX7grnkFkG4Z+2xNaPhPUPs6hv6mGEQq2Os/tXrncPmELCEua2G7eH7f/KVjIAF3iZgNzrrxuk15T4EeB7ICS8gA5C0KRpH3NFnCEpEqBAe+fFCyoZpIpRuGoDLKiMT+h07SwWJ7R9HKtVUPhM3yw==
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(2616005)(70586007)(8936002)(7696005)(316002)(54906003)(6636002)(40460700003)(36756003)(47076005)(508600001)(110136005)(186003)(2906002)(86362001)(7416002)(82310400004)(26005)(81166007)(36860700001)(70206006)(8676002)(336012)(356005)(5660300002)(426003)(4326008)(83380400001)(1076003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2022 14:21:20.0805
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b806a277-b081-4b64-ec67-08d9f7a0ed8c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT061.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2762
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce migration IFC related stuff to enable migration commands.

Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 include/linux/mlx5/mlx5_ifc.h | 147 +++++++++++++++++++++++++++++++++-
 1 file changed, 146 insertions(+), 1 deletion(-)

diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 598ac3bcc901..b1c27409c997 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -127,6 +127,11 @@ enum {
 	MLX5_CMD_OP_QUERY_SF_PARTITION            = 0x111,
 	MLX5_CMD_OP_ALLOC_SF                      = 0x113,
 	MLX5_CMD_OP_DEALLOC_SF                    = 0x114,
+	MLX5_CMD_OP_SUSPEND_VHCA                  = 0x115,
+	MLX5_CMD_OP_RESUME_VHCA                   = 0x116,
+	MLX5_CMD_OP_QUERY_VHCA_MIGRATION_STATE    = 0x117,
+	MLX5_CMD_OP_SAVE_VHCA_STATE               = 0x118,
+	MLX5_CMD_OP_LOAD_VHCA_STATE               = 0x119,
 	MLX5_CMD_OP_CREATE_MKEY                   = 0x200,
 	MLX5_CMD_OP_QUERY_MKEY                    = 0x201,
 	MLX5_CMD_OP_DESTROY_MKEY                  = 0x202,
@@ -1757,7 +1762,9 @@ struct mlx5_ifc_cmd_hca_cap_bits {
 	u8         reserved_at_682[0x1];
 	u8         log_max_sf[0x5];
 	u8         apu[0x1];
-	u8         reserved_at_689[0x7];
+	u8         reserved_at_689[0x4];
+	u8         migration[0x1];
+	u8         reserved_at_68e[0x2];
 	u8         log_min_sf_size[0x8];
 	u8         max_num_sf_partitions[0x8];
 
@@ -11519,4 +11526,142 @@ enum {
 	MLX5_MTT_PERM_RW	= MLX5_MTT_PERM_READ | MLX5_MTT_PERM_WRITE,
 };
 
+enum {
+	MLX5_SUSPEND_VHCA_IN_OP_MOD_SUSPEND_INITIATOR  = 0x0,
+	MLX5_SUSPEND_VHCA_IN_OP_MOD_SUSPEND_RESPONDER  = 0x1,
+};
+
+struct mlx5_ifc_suspend_vhca_in_bits {
+	u8         opcode[0x10];
+	u8         uid[0x10];
+
+	u8         reserved_at_20[0x10];
+	u8         op_mod[0x10];
+
+	u8         reserved_at_40[0x10];
+	u8         vhca_id[0x10];
+
+	u8         reserved_at_60[0x20];
+};
+
+struct mlx5_ifc_suspend_vhca_out_bits {
+	u8         status[0x8];
+	u8         reserved_at_8[0x18];
+
+	u8         syndrome[0x20];
+
+	u8         reserved_at_40[0x40];
+};
+
+enum {
+	MLX5_RESUME_VHCA_IN_OP_MOD_RESUME_RESPONDER  = 0x0,
+	MLX5_RESUME_VHCA_IN_OP_MOD_RESUME_INITIATOR  = 0x1,
+};
+
+struct mlx5_ifc_resume_vhca_in_bits {
+	u8         opcode[0x10];
+	u8         uid[0x10];
+
+	u8         reserved_at_20[0x10];
+	u8         op_mod[0x10];
+
+	u8         reserved_at_40[0x10];
+	u8         vhca_id[0x10];
+
+	u8         reserved_at_60[0x20];
+};
+
+struct mlx5_ifc_resume_vhca_out_bits {
+	u8         status[0x8];
+	u8         reserved_at_8[0x18];
+
+	u8         syndrome[0x20];
+
+	u8         reserved_at_40[0x40];
+};
+
+struct mlx5_ifc_query_vhca_migration_state_in_bits {
+	u8         opcode[0x10];
+	u8         uid[0x10];
+
+	u8         reserved_at_20[0x10];
+	u8         op_mod[0x10];
+
+	u8         reserved_at_40[0x10];
+	u8         vhca_id[0x10];
+
+	u8         reserved_at_60[0x20];
+};
+
+struct mlx5_ifc_query_vhca_migration_state_out_bits {
+	u8         status[0x8];
+	u8         reserved_at_8[0x18];
+
+	u8         syndrome[0x20];
+
+	u8         reserved_at_40[0x40];
+
+	u8         required_umem_size[0x20];
+
+	u8         reserved_at_a0[0x160];
+};
+
+struct mlx5_ifc_save_vhca_state_in_bits {
+	u8         opcode[0x10];
+	u8         uid[0x10];
+
+	u8         reserved_at_20[0x10];
+	u8         op_mod[0x10];
+
+	u8         reserved_at_40[0x10];
+	u8         vhca_id[0x10];
+
+	u8         reserved_at_60[0x20];
+
+	u8         va[0x40];
+
+	u8         mkey[0x20];
+
+	u8         size[0x20];
+};
+
+struct mlx5_ifc_save_vhca_state_out_bits {
+	u8         status[0x8];
+	u8         reserved_at_8[0x18];
+
+	u8         syndrome[0x20];
+
+	u8         actual_image_size[0x20];
+
+	u8         reserved_at_60[0x20];
+};
+
+struct mlx5_ifc_load_vhca_state_in_bits {
+	u8         opcode[0x10];
+	u8         uid[0x10];
+
+	u8         reserved_at_20[0x10];
+	u8         op_mod[0x10];
+
+	u8         reserved_at_40[0x10];
+	u8         vhca_id[0x10];
+
+	u8         reserved_at_60[0x20];
+
+	u8         va[0x40];
+
+	u8         mkey[0x20];
+
+	u8         size[0x20];
+};
+
+struct mlx5_ifc_load_vhca_state_out_bits {
+	u8         status[0x8];
+	u8         reserved_at_8[0x18];
+
+	u8         syndrome[0x20];
+
+	u8         reserved_at_40[0x40];
+};
+
 #endif /* MLX5_IFC_H */
-- 
2.18.1

