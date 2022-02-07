Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A14614AC75D
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 18:28:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377060AbiBGR1U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 12:27:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346180AbiBGRXg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 12:23:36 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2083.outbound.protection.outlook.com [40.107.243.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7733DC0401D5;
        Mon,  7 Feb 2022 09:23:35 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CrwvFQNYXTsz4CaCE+nT7N5p9UdHpZG7S2RW9XyStCuP3fpZFz8Ch+IqGeD1IRQDgJTJ4XLEYnhq1I2uwQtmjnmdsikEnQIV35KDmEmxDSp4NuBiNG14h5Jx3dwLJ6mEuz6xh1OQ71/haClZoUBuC1032gxYAjBU6sukHG+ltBmEACyZqxDPFVeWuzRi3WtKvu8+3ySukuDy2xP0WuLKnzpfAxToWzB8MH6ullmuY2QsnhbTSPx/eIsdNhHqzP47FU+oq8GDe2Bm/o9ptUJzs8m4ArIw8qSumFjEDftqosMsMyzNxK3j2fRukHzsP9rdNsu5fvIob56kwOrq1rkSnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sh+Wv4Rj0ROCI1moErIr+cKiO00G2TXSHsDSrJjkwxo=;
 b=SySFVdX/63wOWhBOptqzKJbBPM0V+6GA1mA5C4xb9y+VzcGmuSm9byHWx5/BXuw9XFxpIf6nPUYG92eo3AhAFLMLBpcoCaMR2EHURnqRobDZGD9qAURU+CoDg84D/XsAe/AABW1CmOcMRF5+w9JM1Tszo+s6rIWbvG6QLU9zacNruzRevQnSCtOLwKmhOOnH3P4Sszqo5SbGZrdtjTJHg9Y69AE2Kp9D1V7oNRyoyCQ0t8JvWiaSNNzT57/V20HewlHA71IubnM84vRLVJQvp+KzW0v3+9/VSlasedah5XaScuOKOqiXNL+enpv2C+FX0zdjxeuFR++DwOPRcJmxDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sh+Wv4Rj0ROCI1moErIr+cKiO00G2TXSHsDSrJjkwxo=;
 b=hzSlBFKuX/SJ6qU55ZnP5319cR0siFL5AWw2rgJzcF8ypiVM54OzX5kSSOLikM3PLimfYmzVQJ6FMa/N3amEzRmNfn/h2kxxY8+wmbxrl6tetui1aTWB9j6UCmHxcu9jxXHB3/yqptL4jpjt+qyc3BJFUhLd/JB3emku1S0MmB3RRQMrsW8BEeSPljz4NLLGjBa6+EWmXTJY3jjMJasuJH+K5yyCPp3Io7UbR+AlOOkfdbkvAHyJDhO3PK3/CiBbXX5q1jIlzxkgFOV8bUoAQ1isSKFUyKrH3XHE6PRbOfrh/Kr7+1k9wx3jTS4FBa+2UNEiAxVU+aL3vqtPXappMQ==
Received: from DM3PR12CA0105.namprd12.prod.outlook.com (2603:10b6:0:55::25) by
 DM6PR12MB3082.namprd12.prod.outlook.com (2603:10b6:5:11b::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4951.12; Mon, 7 Feb 2022 17:23:32 +0000
Received: from DM6NAM11FT063.eop-nam11.prod.protection.outlook.com
 (2603:10b6:0:55:cafe::9e) by DM3PR12CA0105.outlook.office365.com
 (2603:10b6:0:55::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12 via Frontend
 Transport; Mon, 7 Feb 2022 17:23:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 DM6NAM11FT063.mail.protection.outlook.com (10.13.172.219) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4951.12 via Frontend Transport; Mon, 7 Feb 2022 17:23:32 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 7 Feb
 2022 17:23:31 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Mon, 7 Feb 2022
 09:23:31 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.986.9 via Frontend Transport; Mon, 7 Feb
 2022 09:23:27 -0800
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <bhelgaas@google.com>,
        <jgg@nvidia.com>, <saeedm@nvidia.com>
CC:     <linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>, <leonro@nvidia.com>,
        <kwankhede@nvidia.com>, <mgurtovoy@nvidia.com>,
        <yishaih@nvidia.com>, <maorg@nvidia.com>, <ashok.raj@intel.com>,
        <kevin.tian@intel.com>, <shameerali.kolothum.thodi@huawei.com>
Subject: [PATCH V7 mlx5-next 06/15] net/mlx5: Introduce migration bits and structures
Date:   Mon, 7 Feb 2022 19:22:07 +0200
Message-ID: <20220207172216.206415-7-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20220207172216.206415-1-yishaih@nvidia.com>
References: <20220207172216.206415-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5eea132f-f0cc-448f-19a1-08d9ea5e90af
X-MS-TrafficTypeDiagnostic: DM6PR12MB3082:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB308236864EAE044B9529DA10C32C9@DM6PR12MB3082.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DQ0mo0c2mn0uIKwenyo5qkB2NUoQQHhg72YV+PcaVZNokRGmOwWZisXmD48FYhl1XUrk6fpAcP0QOdgH79tokPiHVQnVZ8o0Z82spfg/vdxIZYZXNYG/l9on+Cr8MIQguuIi67ivDkX2FuPx/qhGRp9osHcb5zERrH77a4RonnP7OEmAfCMpS+XuS/rfXf/4k1HfBNXC23Zt7KobbN731IZUu7S5Wu9eE8quW4Fj7dFw7gL77zvp19UFxiQCLF3+Iaz5lf2YaZb2mdFkrKyyJivh9rGzcVi0Oqe4JssZvduviXqXU3oxrO2DeWj2OCyLxrbIzTECc0EgN9zqhGXPeq2FDJs6LnxQG3CRNTIwBKdkmzvFyPR0A4pVEjRjJh9VDVhx4pWIVMoOp/KJhOc8/+lwehHT33LZyVaaPW7tsRDhxJ/XAHxco2fUKgnWhceqXeDbdL4dcY3k/kxRLd79uGFxnNMsz3ZIMp/T9/GVbxKjiTaXhcMr/lD4BhY0KcXbnnbK1Nfot5P2RykAJC+xXe/ot62+tlV5vvnFLhHsm7gQvIhrcknaekx5ax0v9Zozi8wWREocpVMij+VSF9jsYMye/oFyFmwylJghbvd3i44y9+hXfaZgkttOV4CH+gs0mNiqwv75Qngkzox/eFJQ7lLDj+VynV78Rd88LEUbZrg/eSiFyBaXokkgScG/17OuxriqwvEMknE3CISFNU/ouw==
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(46966006)(40470700004)(40460700003)(316002)(110136005)(6636002)(82310400004)(54906003)(7696005)(70586007)(86362001)(6666004)(8676002)(4326008)(8936002)(83380400001)(70206006)(81166007)(356005)(47076005)(36860700001)(2906002)(1076003)(186003)(2616005)(5660300002)(26005)(426003)(336012)(508600001)(36756003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Feb 2022 17:23:32.3605
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5eea132f-f0cc-448f-19a1-08d9ea5e90af
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT063.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3082
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
index 598ac3bcc901..45891a75c5ca 100644
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
+	MLX5_SUSPEND_VHCA_IN_OP_MOD_SUSPEND_MASTER  = 0x0,
+	MLX5_SUSPEND_VHCA_IN_OP_MOD_SUSPEND_SLAVE   = 0x1,
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
+	MLX5_RESUME_VHCA_IN_OP_MOD_RESUME_SLAVE   = 0x0,
+	MLX5_RESUME_VHCA_IN_OP_MOD_RESUME_MASTER  = 0x1,
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

