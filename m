Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C14043342E
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 13:00:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235454AbhJSLCT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 07:02:19 -0400
Received: from mail-dm6nam11on2083.outbound.protection.outlook.com ([40.107.223.83]:46529
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235413AbhJSLCD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Oct 2021 07:02:03 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Oa9w8xGyD5V7PncRZfVO+buOL7gdNGFpTn0P1fN4sDkAP+b3qlLvp4jH6B2xDz1WaG7qvSLlCKOa1e70nD3zcbjc4YHuPl4a+ULUeAjT16on7E3XrrBMKWLz8Rka1Er9jvFuE4LLGOyO2lToBIHL5wy0QFNWyWHPtS3X121/4HZzB4X1sh7dQeL9tLCldG4SiBUuCLZBJlZrE9mw+m3GmUVVnGp8Q+IQNJ9tpKiCm539hRLhUt5ckT2IRSS9kRBWH2nYfFana7k5piX7hnjBFd0k0eB2ct8iYcFJkkR+8Wcx68Oo+BpFtVikXG2t1BWwKXTPLRkBp6cVE5uDm7tAVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=R7DbtBQIcZF4LUA2VaUaiDzMK1m8SVbr7xND56mts4w=;
 b=KCk1DWrsP10xbdhwM0DXnh4sYZLtqVoCU9PC4ruuN/npGDJmXADo8idIjZUy90pjvvmGlu4BECACU7O0DbKQJABrbhKPR06UrvVbTcVn0SwBM3WW/Zxy4x/ZyjSwZR874hySi1/Sgu0kOwjRNyF8pIY4pEyB34QAeg3pk5MAgz6hdN5zbGA06T0CwHhDs7euBRu7KrOBLPG2euf7AtNZ4Q6FiVSO4xWuP4oTt1q8Tv3fn0y+JuX6GNmX8PnxDrpGPnTVRAQ21/s310zn2z+kZtBTapvvaZ4qMn4AZ37+R+MklWgEDp3WyoTnBgxCCjrYJnOOvofzHFa5/qE4K62MAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R7DbtBQIcZF4LUA2VaUaiDzMK1m8SVbr7xND56mts4w=;
 b=fIB/RfTj62nwRMInn3T3upxC4Dr9MJpTdbpPdcoj54/vrrRakOxCegEX5j437Coy0qMiegQ/+py7v53MSg+x4LgafG8z0XCas5ErlHUPszeS8us0Wfq9WcHjXMNOfoC8RGXtYUy8k8Vy2h6XbIav0TzEHPtIaZcOa/zAyCPv/JnCll0SzqRniYarEnVCqm4lIsr0a/PUVaZEECwS2rDBkY2qsW8x4AtsimvKXPtOPMzCRMm2rPOMDg4cxYFHrqUkpS67Oi7v96N0NOZVPktfEY+MhI4RgVrSY47bjp3TD8cDBX4nb78eOV5ZqP/hMSAKCB6dk8oDedo1cFw2PA18SA==
Received: from BN8PR04CA0016.namprd04.prod.outlook.com (2603:10b6:408:70::29)
 by DM6PR12MB4577.namprd12.prod.outlook.com (2603:10b6:5:2aa::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.17; Tue, 19 Oct
 2021 10:59:46 +0000
Received: from BN8NAM11FT051.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:70:cafe::b1) by BN8PR04CA0016.outlook.office365.com
 (2603:10b6:408:70::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.17 via Frontend
 Transport; Tue, 19 Oct 2021 10:59:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 BN8NAM11FT051.mail.protection.outlook.com (10.13.177.66) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4608.15 via Frontend Transport; Tue, 19 Oct 2021 10:59:45 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 19 Oct
 2021 10:59:44 +0000
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 19 Oct
 2021 10:59:43 +0000
Received: from vdi.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Tue, 19 Oct 2021 10:59:40 +0000
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <bhelgaas@google.com>,
        <jgg@nvidia.com>, <saeedm@nvidia.com>
CC:     <linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>, <leonro@nvidia.com>,
        <kwankhede@nvidia.com>, <mgurtovoy@nvidia.com>,
        <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V2 mlx5-next 10/14] net/mlx5: Introduce migration bits and structures
Date:   Tue, 19 Oct 2021 13:58:34 +0300
Message-ID: <20211019105838.227569-11-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20211019105838.227569-1-yishaih@nvidia.com>
References: <20211019105838.227569-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cb2ac369-4f0a-4c91-25c6-08d992ef9045
X-MS-TrafficTypeDiagnostic: DM6PR12MB4577:
X-Microsoft-Antispam-PRVS: <DM6PR12MB4577138B71C97B26B530E747C3BD9@DM6PR12MB4577.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nl8iu8j93R+x4kInlvE5DSFsbtpZaIofFenWxmgJk1CsobDS49Fu26hAqmgEbC3iW+R7l9EEwyIWEshiODfmlx9KBg79tVQToARIIt7YRTfP24rVQSwdVyGTmVCcO2QGZ7pp5ecT+KdPrBpSnJLgeRbxjEC2Yq3XAhX6qkAINnBULfz0TodH1YKGVYNaE+bX4V9zOymLUnh/SYkT7HfucC/qAautYe+wglOV66JDzR/VLmDoSz8IAWTYe6TysvUlDj+tqHbJGRIU46UU/mmL5gZa1+UyTxoj5CsIFt0W2Ub6DgLzQL3HL6tvStSYJ3pOLM24818xb8x/ckWCo+//+Pxos4J2cPwObB6glS4G9Rb4MrJYmLmiGWFvCKG4vod3GVhJhQNZtaTy1mbY8dFtZz038eeVQmODoPnVfPKQEPcmk+RNFYE+PY4oGr5YIQB8BfJ+U9fkx/cxEx1G7f72ZlZY6ITtI9j3TtEjzEEHvo7pMd16cupWqhy7JA0UZ+wLgf6FfNy4DUIRRkeVKZSxwfaNk6WKAI5rw7RKjVRy5R3Fj+Ne8jw+P2iYpWRL+1oH8rGTIWEib2KSEZl7iYbfLHQo5Mi2h2vdqVXyr0IgktmvAYy7qMKnF/P7OlFx+a9T3yJv4fOIVNLnAR/+fHCP0j2h48GYtpN4VrsbogxgG1BHy2r2HeFpScd8KqESCx4rHKLim8WqjNZcyNoEuRvpTQ==
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(26005)(356005)(186003)(82310400003)(426003)(2616005)(107886003)(5660300002)(6636002)(508600001)(83380400001)(54906003)(86362001)(316002)(4326008)(336012)(1076003)(110136005)(2906002)(7696005)(70206006)(70586007)(47076005)(36756003)(7636003)(8676002)(36860700001)(8936002)(6666004);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2021 10:59:45.9498
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cb2ac369-4f0a-4c91-25c6-08d992ef9045
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT051.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4577
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce migration IFC related stuff to enable migration commands.

Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 include/linux/mlx5/mlx5_ifc.h | 145 +++++++++++++++++++++++++++++++++-
 1 file changed, 144 insertions(+), 1 deletion(-)

diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 399ea52171fe..f7bad4ccc24f 100644
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
 
@@ -11146,4 +11153,140 @@ enum {
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
+	u8         reserved_at_40[0x40];
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

