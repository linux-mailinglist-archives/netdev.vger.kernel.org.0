Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5CB54A3792
	for <lists+netdev@lfdr.de>; Sun, 30 Jan 2022 17:15:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355621AbiA3QPR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Jan 2022 11:15:17 -0500
Received: from mail-co1nam11on2067.outbound.protection.outlook.com ([40.107.220.67]:51040
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1355560AbiA3QPM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 30 Jan 2022 11:15:12 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PADFvQncbGRUMtFPKnpjfW24OzEtolJgPUrXBNbem0o/aXGAIKDpiCjh7WRssEcViqVqShcACdbDRivbT0B2Bes375+lk5ju57eSufblxFcshuNk5sEWpNSU08P8fNdWOh5vNGZE9i+DxCe2gkkG+2PC19WOIYdMVAfsmlIvZ65IxMHn+rIhV4sokcZc4E367wqZ9z8cBNSZMg1qNDU6nQeBOxgZu8wp6IRxlUYC8luEB+2K8+qE6WVW+MQdAxHWx7ccgHm7WhDZfiYZKSVQkVotQYpyjkrnHaNKBnys+4IhtyYwvno6cIZ9lt7/Eg0TKx9kHjcNZ93ohZ+7XvxM2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sh+Wv4Rj0ROCI1moErIr+cKiO00G2TXSHsDSrJjkwxo=;
 b=KEHA9PfNK0htGrf2mQ5B5orYz0p51AmbnB5wPuOuAMYm80Te9Hj588yYMBDzguK0lbQ385iCrVjFsFD0m3ojbu4opyzTIFzfB7/XRs/ZwoiaBEbJesZ74cQhBM4NJzd/U42KOB7pZh7ylNRFJPW7HL4c/+GAxT2LHkUr0jn0X31EPGMXMiwSJq5F/4SBQwknOKI5nqFd+93xt8eJXF7opO7l4nVmV9s4KoteJunqrdrglcSfVlDgqfC3mn5OvQXiuSO1n019iweihVDcm2+xyVbsxTGCrppjLa85+nDCU7vyzKyeRPcQ/H7ahD2paeFH+NiPjYnm6YzlDRpUPZVDTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sh+Wv4Rj0ROCI1moErIr+cKiO00G2TXSHsDSrJjkwxo=;
 b=TkoZyPAtlG/CfruoxDZYL9O+VgoiKhUTx2m6FqqutrcrNqz219c4So2uck0af8jQb0C9L1sjnEkvKcqhMqaHE+rfj1U8J6rcqHOE161ehI9Lbp5VW9SDfF2uRUudNJk8wGUbWeOfBTqxd7SkJ/ZnbyGKnw3zqNmqE3qGVJD4YQgxynMJLcSiFlTorxKYas6R4X2w2VR2rDLjB2GfcEosClU9TYlzq4iTb0IEa3cQPFPMMUxO9rQRiSRHrqBu9rMuDzzdvVCaFOimHrjD7NdpaiZ0ZikWpjjWA4GpVf3j1aasVVHW7YmqLF/NTmzgSSDwr9fS+WQmkhAAQF1PTl+Lhg==
Received: from DM5PR16CA0023.namprd16.prod.outlook.com (2603:10b6:3:c0::33) by
 DM8PR12MB5413.namprd12.prod.outlook.com (2603:10b6:8:3b::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4930.15; Sun, 30 Jan 2022 16:15:09 +0000
Received: from DM6NAM11FT045.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:c0:cafe::21) by DM5PR16CA0023.outlook.office365.com
 (2603:10b6:3:c0::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.21 via Frontend
 Transport; Sun, 30 Jan 2022 16:15:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.234) by
 DM6NAM11FT045.mail.protection.outlook.com (10.13.173.123) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4930.15 via Frontend Transport; Sun, 30 Jan 2022 16:15:09 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 DRHQMAIL101.nvidia.com (10.27.9.10) with Microsoft SMTP Server (TLS) id
 15.0.1497.18; Sun, 30 Jan 2022 16:15:06 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9;
 Sun, 30 Jan 2022 08:15:06 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.986.9 via Frontend
 Transport; Sun, 30 Jan 2022 08:15:03 -0800
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <bhelgaas@google.com>,
        <jgg@nvidia.com>, <saeedm@nvidia.com>
CC:     <linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>, <leonro@nvidia.com>,
        <kwankhede@nvidia.com>, <mgurtovoy@nvidia.com>,
        <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V6 mlx5-next 06/15] net/mlx5: Introduce migration bits and structures
Date:   Sun, 30 Jan 2022 18:08:17 +0200
Message-ID: <20220130160826.32449-7-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20220130160826.32449-1-yishaih@nvidia.com>
References: <20220130160826.32449-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4749057a-173b-41bd-13ef-08d9e40bafa7
X-MS-TrafficTypeDiagnostic: DM8PR12MB5413:EE_
X-Microsoft-Antispam-PRVS: <DM8PR12MB541328D2FC7292B4170FF6CBC3249@DM8PR12MB5413.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 98orxLYqv16K3QNToPPzp07CLuVMME6vDoHkR/MQLxY/rXzaBUuSWdmb7OQ0bMLgPZ+gKTPK3uDKFiRonCWaw7vpDnvKjSCfhlU1d6CSk9P6ANCRRaO22yTr9VZQejfjRpELKmyC603GtfnKWPo4UEGnla68ELA0ICym0buVdnJ8N5fP+uEL70vWvRUTBNmNUP+OslkrDEheAi3YXSV1erzx5MOxdsqz7P8yKLKTKn2kZd1nyqqzBtDQ9brDhTyb+BMbyfzAW+KHUS1pOFSdnB+oZxCe1NL3Z653A/lM74YrrIGw06L9bbo8JwCrlQBQ0d6Jzr9L+pD/lBhnHt2rf9o0VGkjHaAjYO7j1m0o3xH3LZOMaHigj4UgX2fe1/nSioCmlh5WqOyf8qED0UgoQLZA4owPx3MoPQ25Fmz7D0S9C4a3zK7mSDiCLv2P+d9PA+fWko7O8tiWwa6TwdBQ2dTV5CEZLFOHSGAjpxGc5K1K9YDDP+KyqykzbmY1pTO/a8mjUkBlkIufjI2yCANZW1syF1KVtjBBArf4Mmnj/E4xgAaol+TwbzWnhnJ/+ZwIo4jAxB+let/o0hNVeXYqGkbtv3JWBg/zD8yYuKoCu68wNK33H4qehoYZvut3zvgkJViWEKje7DOkHOondzGGj6xGXnt1zcQUUsK5Qbd38ko+qXvl0qSNp4PJ+sttJygsUBWBW+v1lc2WLj2dzrNxTQ==
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(4326008)(2906002)(36756003)(47076005)(70586007)(70206006)(8676002)(508600001)(8936002)(316002)(82310400004)(36860700001)(83380400001)(107886003)(54906003)(6636002)(5660300002)(110136005)(356005)(86362001)(81166007)(40460700003)(6666004)(26005)(2616005)(1076003)(426003)(336012)(186003)(7696005)(36900700001)(20210929001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2022 16:15:09.0965
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4749057a-173b-41bd-13ef-08d9e40bafa7
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT045.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR12MB5413
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

