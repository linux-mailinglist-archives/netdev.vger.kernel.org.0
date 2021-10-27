Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36C3C43C714
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 11:59:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241296AbhJ0KBN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 06:01:13 -0400
Received: from mail-dm6nam12on2043.outbound.protection.outlook.com ([40.107.243.43]:53280
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241317AbhJ0KAs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Oct 2021 06:00:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MqXiRh7tSxf/5C9vGex8KwhoDQvwG79xJI9vUE01EO8G3y10wSLKPFU66bjcuvwYKPEtbF0fez6Pk9WguKVSKJ9ovcDEkEmtUwXbjhTb1QZPeT/osWV+nasL7D2aofZ1QECN3ct6aWPzS4d/RUiR+uFATdv3zD9jYUG513UOTMRW6m1OP8pqUbUpJzBzdYQdu6EuSlglC85cJRDtgaDYqkI8Goh/NfB1AQ5BodApprhOH7FxkdZTipVh3rV2o6g+9GQUQYrWuVa9LOPBeohPNaI/xc/bswVjcLxglNI9m+GhMwAFjYXN3dlrEwGZmlJ0A7H84osdddrvL9pPeoEDgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8EiLFCfX1BIiCoBhJcg49k8D+4oAajiiGkB0J2YJXL4=;
 b=CCF8saknzAjzUbIjNmxwUNdOSfrlMiJCcLC/ZYvCiqc4do1Ye+R70y1vzi7WXOPMdpX6oxbTE7L7tZY8jaPtiPpkbaJlqMTbpJ/N4qyC1qzOkMqv8/6GjyReAFHDQjEFfZjwvgV1xrU64GoCdnaJt5APzyAX1LMYQlIPpiygcXWscRxYNPfp18jwwusej2hrFKUfPRlRiduNvRpDfMKsIJQ5ow+TNgRl1CXkGixuZv0TOp/IkkqV+SRgB+5VPzRMgnGgDkfhENFL7Q/gNIgSXUnYKACBD0zUiXcPVpmeMkWQ8k8yET1tlUsSLWI6oJxFUnfR8EHymIK+XI5ec6g21Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8EiLFCfX1BIiCoBhJcg49k8D+4oAajiiGkB0J2YJXL4=;
 b=TKMp+hLl82C4irFBTNSdVArEo7RTx34AthtR3KdCPYaxT5YjSe//69W7/WbGYSH6N6IsDle6xrJeup+JXxbrkEIC1ckNeaUI7uKTN5Q/ZLJ+Emi/5JHP4zeTGcZ5EsH4kDq9Z+m6Es3eRuJqqz+ki3utWvhusNJeLAi6/XTaJGc5xnyjJCXYYIpzMlSeQy7TM4BZxQESKAE9/lPbBwhbOedygKNnhVvCY1l05KO8xpO1jm+msC1dObfcaje7XX1Bhb0sokgckx9wXz7qP6ClvHIzzRNQ2pDJnHdsnt+fkSAD3nliAphgAx2+OU77d6QcPCLvDQWToiTU5+ZkQjOPAQ==
Received: from DS7PR07CA0002.namprd07.prod.outlook.com (2603:10b6:5:3af::8) by
 CH0PR12MB5385.namprd12.prod.outlook.com (2603:10b6:610:d4::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4649.13; Wed, 27 Oct 2021 09:58:22 +0000
Received: from DM6NAM11FT031.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3af:cafe::d4) by DS7PR07CA0002.outlook.office365.com
 (2603:10b6:5:3af::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.14 via Frontend
 Transport; Wed, 27 Oct 2021 09:58:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 DM6NAM11FT031.mail.protection.outlook.com (10.13.172.203) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4649.14 via Frontend Transport; Wed, 27 Oct 2021 09:58:22 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 27 Oct
 2021 02:58:21 -0700
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 27 Oct
 2021 09:58:21 +0000
Received: from vdi.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Wed, 27 Oct 2021 09:58:18 +0000
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <bhelgaas@google.com>,
        <jgg@nvidia.com>, <saeedm@nvidia.com>
CC:     <linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>, <leonro@nvidia.com>,
        <kwankhede@nvidia.com>, <mgurtovoy@nvidia.com>,
        <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V5 mlx5-next 09/13] net/mlx5: Introduce migration bits and structures
Date:   Wed, 27 Oct 2021 12:56:54 +0300
Message-ID: <20211027095658.144468-10-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20211027095658.144468-1-yishaih@nvidia.com>
References: <20211027095658.144468-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 34abdd40-a6bb-49b0-4e85-08d999304fb8
X-MS-TrafficTypeDiagnostic: CH0PR12MB5385:
X-Microsoft-Antispam-PRVS: <CH0PR12MB5385AA09D92247B1A5369940C3859@CH0PR12MB5385.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QFl6UgRsEqHPy5kCqkXw7eKB/kRb8743gOivm8MbIRnFusACBwjaF+iqQWUn182/KLLT4Anz+D58/RZLrocTkZz8DAOkuZHmU7r7FS51Ox0UVKpzwbbYTBVheu4z7ybKkBcQ23ZIRaXsrjb35BJ/8FTDBBUKtSaGi2EaDsUqjuLA4wMYEWBd6oMG+BdMtuxHTFpH5Jg+q4GPPqrNQObYKwvYWnSmHF2yG4Hxu/dhSmQooPGF4K3zXESsnfHzBDCYjs807Q9KKUfORurXdaDZEZQXUASGlPxkDZ/9D9z91/lhDZQ9JRLOxmHuUxsCq+Fyb+taCkjhQMDDf9v5knlmiwT18RzyWpS7zMcdLbJozctndEmFrJETbudbjBY3ehNnfiaQRvqUdNxyDrlTK1GslGBlMavGu4mTuswOE3kITRglEFyvFSF49HmOhQhuKvmbu7oPSSh0s+kuFAi2uSws6hGpGVWbpwWCChxDHANU4+z53LnMsEphxwMjxaWvwWBcTLVsBlUyZ4mdIyTeflL9xykUX000eAzuvWiQbL94V3aGk27FvxKIxqcZlA1+EEm1ramsmA/0JW+1fuipmYmj3hQWAkOH8vvef9lLJD2guu0jLc6BemmyqArqCmg2CXsTkNwLPPOX2Xtsh1GsbpMYYDN62K++uq8wnChFljfI1G+vgRtCgH2fepD9FT1EWsTKBaaA+A7SJ/b9HiwTx9GezA==
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(83380400001)(107886003)(54906003)(7696005)(70206006)(47076005)(8676002)(2616005)(86362001)(426003)(70586007)(36860700001)(6636002)(2906002)(110136005)(508600001)(336012)(8936002)(36756003)(356005)(1076003)(7636003)(82310400003)(5660300002)(186003)(316002)(6666004)(26005)(4326008);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2021 09:58:22.3495
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 34abdd40-a6bb-49b0-4e85-08d999304fb8
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT031.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5385
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
index 864fc6b99b44..fe5566bb00b1 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -126,6 +126,11 @@ enum {
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
@@ -1719,7 +1724,9 @@ struct mlx5_ifc_cmd_hca_cap_bits {
 	u8         reserved_at_682[0x1];
 	u8         log_max_sf[0x5];
 	u8         apu[0x1];
-	u8         reserved_at_689[0x7];
+	u8         reserved_at_689[0x4];
+	u8         migration[0x1];
+	u8         reserved_at_68e[0x2];
 	u8         log_min_sf_size[0x8];
 	u8         max_num_sf_partitions[0x8];
 
@@ -11152,4 +11159,142 @@ enum {
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

