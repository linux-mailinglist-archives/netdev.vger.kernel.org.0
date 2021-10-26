Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E745F43AEA9
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 11:08:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234942AbhJZJKi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 05:10:38 -0400
Received: from mail-sn1anam02on2086.outbound.protection.outlook.com ([40.107.96.86]:27431
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233768AbhJZJKK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Oct 2021 05:10:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FZZwwRtB03kjOs2KlcY+4Tel/sZ3H2z77rdImSieGoplRRkwuJgjAmiv2sE5myAzRgdv4tgCSaf/tWuNYg1vDplDAZ79CHBTETc4ebquDNz5kXvJd8G5/bhSsn6evVK7Wksbq0CAMwtLppKBh9creky5tlZI6KorQfFqBmrdkdTbBREIoE1z/OyzUL2R2LbAFBAtrTZD4bevJtqJG7CgAn/2+zjORXAsg+BtVMRWFaCf7Ub6GHBIHfrrBQRhxGvxi/6AveVHDTtDQJk+QsRLon4ieJfF88yrUSukkInBvYJKlFmRsMdepsK6WuT1J2TdPq+2tOPyW08+doIJ7fOBuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8EiLFCfX1BIiCoBhJcg49k8D+4oAajiiGkB0J2YJXL4=;
 b=DsiSO03dIQzgLO1V8fTudZreLn30xKksaGrKAsf1MnJyYf2Imeri2mM10gwgcl9KYJHOJ8CVOK+e+5UsgDP+m4xyzaLAVcMyPLKBmNBGPpgfuWRl674b5c2fkz6c/wLYdwg2xDOUXHbh6yn+sCerSSseS3ATIeqUXHR4WNMIqmtP7xafRl5w+t3PAW+3TU1FvIIJmQUTGZvlYCFEKxZNQEbHr00/sEHhGdUbOiIOjnIcds76VCzho6Lz6jM1TKVAbA8IFflor3ZV0aS+a5uhJFMT8CzVHn5Qgd7KL4AnGHxFB0rq/OiF5NrDHnChw9XAET3I5cSro2RFJoIsBdRPRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8EiLFCfX1BIiCoBhJcg49k8D+4oAajiiGkB0J2YJXL4=;
 b=ZznHWPTCtqh912f5cusWH9PEtmGfCaBFUgoCnqWW63nXHW9kamqVVvk1t2lZXnpnNgru3phMLF/+O4rPehMbvEHSjToGBglCchIjprKBIIFC5keCe7TcjiSEch/pPiYrEbMNO+/lLU7M/6NZPGEGuY2SmZztOR9RC8RaAm3+IHykDebU4YyaR8xZq3SQBfk3SoyQVE7e75uojPx6gJIeVmibAAcAwbeP8m1UwAuu3XV1NJeugauuVNKCcvmP58qCKy0dmPNLgQXzAP9taAh5qStj6TsYmDSpcul71nl2/WcNrPJalqqqrG5xPWw5k/TEJaUHcjZNNW2H/mkWoBEqgg==
Received: from DM5PR2001CA0022.namprd20.prod.outlook.com (2603:10b6:4:16::32)
 by SA0PR12MB4367.namprd12.prod.outlook.com (2603:10b6:806:94::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Tue, 26 Oct
 2021 09:07:45 +0000
Received: from DM6NAM11FT062.eop-nam11.prod.protection.outlook.com
 (2603:10b6:4:16:cafe::a2) by DM5PR2001CA0022.outlook.office365.com
 (2603:10b6:4:16::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.16 via Frontend
 Transport; Tue, 26 Oct 2021 09:07:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 DM6NAM11FT062.mail.protection.outlook.com (10.13.173.40) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4628.16 via Frontend Transport; Tue, 26 Oct 2021 09:07:44 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 26 Oct
 2021 02:07:39 -0700
Received: from vdi.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Tue, 26 Oct 2021 09:07:36 +0000
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <bhelgaas@google.com>,
        <jgg@nvidia.com>, <saeedm@nvidia.com>
CC:     <linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>, <leonro@nvidia.com>,
        <kwankhede@nvidia.com>, <mgurtovoy@nvidia.com>,
        <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V4 mlx5-next 09/13] net/mlx5: Introduce migration bits and structures
Date:   Tue, 26 Oct 2021 12:06:01 +0300
Message-ID: <20211026090605.91646-10-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20211026090605.91646-1-yishaih@nvidia.com>
References: <20211026090605.91646-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 54cf3bba-2da0-4eaf-bae7-08d9986012db
X-MS-TrafficTypeDiagnostic: SA0PR12MB4367:
X-Microsoft-Antispam-PRVS: <SA0PR12MB4367936A561B4ABB6B149913C3849@SA0PR12MB4367.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gXnitndk61s4zT9fpYCJChrx2WFALyrkCmsYfpLCC5zxXwkLnFCIVq6OdZkruJrGBZvFV1HjW3mcjwJCy6P9T6qLyQ46hskfwIFPT+EXrA/2IxUOmCz59/9zfarMHXNiGzQYquhNLZNfGpBLJibDnGfpTuVUrWKgKO3wlvkxmnSWK+PJW1oyVvgo2fBoDGlbCZijkCEF1xuPvClO1ntKMLLBTIYwwQPsSetkyftRsA+7OSWpPZE6HpdNb1NLySdsg4w1LBOqQkMrrhBps7Gvi5obwzwQ6bez9uigVlDW4TamWvyiptEsQkDSfcBCUIjZF6bkRNedHxIDRlAwokcjf+GggeYKDX2s2UAPemXDo1scdLg88CLje7PAwwncqaS6INPQr+QTYUYOTxZCGrpqIVF9ONdiMDnbtKx/NFDIov7/Es4sAipd9xEt/Ga5VXp1DXfQeoVau3CZ33h61d5upbiXAdKTKXkri41bEFpQb6g7oDYfmff4f/5wG7K0DxDajqAhC1g/HeGbjAdlOLSzdBmOvtsp+VKT1KPJO1+zY4knprSXbvpoZy3ISPI2t6DJ45Wkg3eUI8u9Ez8BqDvRpMUkJbyTSFf28AraKyGlYKrvBokY2+ZuvM11GoFQJO9Qy/krtn6lZI3qFJmhb/zRVlnxX2PfvMpN613yA8IFPb2T7hZN7PKMy/RSs6o6wgujCyaUqFoGbKps+osn5p5WJA==
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(26005)(186003)(426003)(107886003)(2616005)(5660300002)(6636002)(82310400003)(36756003)(1076003)(7696005)(86362001)(83380400001)(2906002)(356005)(316002)(336012)(8676002)(8936002)(110136005)(54906003)(6666004)(508600001)(7636003)(47076005)(70586007)(70206006)(4326008)(36860700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2021 09:07:44.9228
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 54cf3bba-2da0-4eaf-bae7-08d9986012db
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT062.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4367
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

