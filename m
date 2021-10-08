Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 547AA426AB0
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 14:26:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241447AbhJHM14 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Oct 2021 08:27:56 -0400
Received: from mail-bn8nam11on2042.outbound.protection.outlook.com ([40.107.236.42]:13408
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241478AbhJHM1x (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Oct 2021 08:27:53 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QQ8pDa6I1pDu7cCybpE6M8Ry7h+oYq7jQ8SWglshacgwFpDcUhRtRckREWZNAiewX1Wv5nbMl70YDjDkEwJ0N+X0+zKmXDsKuWewvLRwBUPmFp+eJUAbtMLOR24EN1CTurATWyu50WoGzmn12I2eqDixh4qCRMKLS6MccK1Jb0eaWvcqt75NWabyiNnx6MmDuGvyrZJizRoDH3gz2o6g2foacWxHFKcQQvRdF3j0bqP9cEhtVgAaYqV/t9OvtbIfhWIoEyE2TJs1/9MTPma91n3RBQZgTiMYanHtwkvBTeVu69U0DO2XLWmqBiBKR34QSC4NI1fYuEptdw5H4SLIew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ff6U3ShTiGEQ6LvjofAbm13twHjNdcdk7hFjjPKWnDw=;
 b=EpzO8YLgIKaJszKxvL4dj1C5PU8q7v1PpRcm/0xKto66i5DXJ2f4uDNiKsDCOU99xWfI65KpuxYMGhtgRmeaNm20saEk8ERZ8B5hAhUtXN7jBzTNd2ZvXnCUAstFMYHE7BRrWvvSAanMvUq1H1sCYYpB+2RZdgFIjbSn6r7ppQ1jiEnIh6iu+jADldJRtze2hIO6SgSXiOM9IOIzIUMhkXvoN+1mcox5nA/eW0riLOkJQ2rV5iiFUvgp8vJBR2AYQAii5WFb3sxvvRKM5XUKcNi9YTPtdacOp8WetLv58lduOz9eGwjiwmZa7JqO8nCYQdKBxa7GqGog3SutclaCrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=chelsio.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ff6U3ShTiGEQ6LvjofAbm13twHjNdcdk7hFjjPKWnDw=;
 b=OYoqu15TTLT+cK7JPgRobVbpHulZ16YwKd3ZPDXGC1zAy3UfFlHGvjkHRHz9EiI9T2FV8ZFkHdzrdNm0HJQu4wdVYYEQ7s1TwcNthE6U263xVYxzd4BwZoTs6sI5mAX3zbVYYuLiPnA9YL2EJPNy5ApN3Pq8V07R8MWrP3QujgRA6gcwJauRME16l04Uq0ucKnvxzgIs7QcknkaVV4w8ZY4XC/k9a+lmfmc5SD9XP9DcqB3WaIPFN/9A9ConL7C5TfdbDiz2KaqEiosf9uPTX/vXryWl/q3V04+5hWfx4wTlbdDwU46+kNy2Z8TC9lVJiw9Mkq/QZz1LCXjLAX7vjg==
Received: from MW4PR04CA0190.namprd04.prod.outlook.com (2603:10b6:303:86::15)
 by MN2PR12MB4605.namprd12.prod.outlook.com (2603:10b6:208:3d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.20; Fri, 8 Oct
 2021 12:25:56 +0000
Received: from CO1NAM11FT064.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:86:cafe::1b) by MW4PR04CA0190.outlook.office365.com
 (2603:10b6:303:86::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.18 via Frontend
 Transport; Fri, 8 Oct 2021 12:25:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; chelsio.com; dkim=none (message not signed)
 header.d=none;chelsio.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 CO1NAM11FT064.mail.protection.outlook.com (10.13.175.77) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4587.18 via Frontend Transport; Fri, 8 Oct 2021 12:25:55 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Fri, 8 Oct
 2021 05:25:54 -0700
Received: from vdi.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Fri, 8 Oct 2021 05:25:50 -0700
From:   Mark Zhang <markzhang@nvidia.com>
To:     <jgg@nvidia.com>, <dledford@redhat.com>, <saeedm@nvidia.com>
CC:     <linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
        <aharonl@nvidia.com>, <netao@nvidia.com>, <leonro@nvidia.com>,
        <dennis.dalessandro@cornelisnetworks.com>, <galpress@amazon.com>,
        <kuba@kernel.org>, <maorg@nvidia.com>,
        <mike.marciniszyn@cornelisnetworks.com>,
        <mustafa.ismail@intel.com>, <bharat@chelsio.com>,
        <selvin.xavier@broadcom.com>, <shiraz.saleem@intel.com>,
        <yishaih@nvidia.com>, <zyjzyj2000@gmail.com>,
        "Mark Zhang" <markzhang@nvidia.com>
Subject: [PATCH rdma-next v4 01/13] net/mlx5: Add ifc bits to support optional counters
Date:   Fri, 8 Oct 2021 15:24:27 +0300
Message-ID: <20211008122439.166063-2-markzhang@nvidia.com>
X-Mailer: git-send-email 2.8.4
In-Reply-To: <20211008122439.166063-1-markzhang@nvidia.com>
References: <20211008122439.166063-1-markzhang@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a48433c6-b8f3-4ace-3d5e-08d98a56c6f8
X-MS-TrafficTypeDiagnostic: MN2PR12MB4605:
X-Microsoft-Antispam-PRVS: <MN2PR12MB4605E2F2996E8973A2459432C7B29@MN2PR12MB4605.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wWclcCpprx1x7jk6SsIrBFB2xwEvs4PGRVdsnL1PFJ+A6HDUQp9LnhY5D6crrG3oKUjbCrOCFkGzRt6/JxIY3LrYGioYpiWTI7obpkhMC99SC9iQcVp0keJm/T3qlxRVgMbBvPYfDOrbRAqONFWJJu1yFcCiuP1Jy9ktTDRO2dZ0QywvS2nvfc92r4WE8gOIkw0d8l7xJeJYTPU8cPHLyYP3gD3fITRytlhwIaq96BMXHfopIY247806eOVPc356Wos60aKw+ioL4bwtPN1lmobFvs8meGx+JoUKJOCPgB1mNRktPj2V1GmQsPerJ/W2gfbhVvW7YNrmMYN9nVrxlEBGOehC8FDY0LVbmUb96qNw4QxIft5WgY3lfseAc1hPZhw1BuxBYjdR/1YGmffzdfNaSACmpna/c+5QXM0JcC+p+Cj2DQKKYcny1mGbxhyl4LO8otaOB4lRAVn2GUZCOPFiE7ifqj8lc+mIQPxKjNLbdC5Seni5LdUNnu8hfFio1BpqpYHRZXQFIWpgxLlgAMm4b0ZnvlkW97HsFc5Q/ibkgx399KBS+2E2JVYuW8JnDtBsJ7Civm+Z0GFsY78nyLfy2XfFUUyEupuZ56goigWY5r6Yogq/mXAYq1nkroISzZVsrOYtdMK/nzVk+LAGszc3xwXyqqAC073Gvg+QseqiCppd6DK5WQmnIqsxCjMesg6eIuVECrmu4AyZYbvwPQ==
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(7696005)(54906003)(8936002)(70586007)(4326008)(47076005)(107886003)(8676002)(6666004)(110136005)(36756003)(356005)(2616005)(426003)(336012)(316002)(1076003)(508600001)(5660300002)(186003)(36860700001)(7416002)(2906002)(7636003)(83380400001)(86362001)(82310400003)(70206006)(6636002)(26005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Oct 2021 12:25:55.8044
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a48433c6-b8f3-4ace-3d5e-08d98a56c6f8
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT064.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4605
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aharon Landau <aharonl@nvidia.com>

Adding bth_opcode field and the relevant bits. This field will be used
to capture and count congestion notification packets (CNP).

Adding source_vhca_port support bit.
This field will be used to check the capability to use the
source_vhca_port as a match criteria in cases of dual port.

Signed-off-by: Aharon Landau <aharonl@nvidia.com>
Reviewed-by: Maor Gottlieb <maorg@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Mark Zhang <markzhang@nvidia.com>
---
 include/linux/mlx5/mlx5_ifc.h | 22 +++++++++++++++++++---
 1 file changed, 19 insertions(+), 3 deletions(-)

diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 96f5fb2af811..34254dbe7117 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -342,7 +342,7 @@ struct mlx5_ifc_flow_table_fields_supported_bits {
 	u8         outer_geneve_oam[0x1];
 	u8         outer_geneve_protocol_type[0x1];
 	u8         outer_geneve_opt_len[0x1];
-	u8         reserved_at_1e[0x1];
+	u8         source_vhca_port[0x1];
 	u8         source_eswitch_port[0x1];
 
 	u8         inner_dmac[0x1];
@@ -393,6 +393,14 @@ struct mlx5_ifc_flow_table_fields_supported_bits {
 	u8         metadata_reg_c_0[0x1];
 };
 
+struct mlx5_ifc_flow_table_fields_supported_2_bits {
+	u8         reserved_at_0[0xe];
+	u8         bth_opcode[0x1];
+	u8         reserved_at_f[0x11];
+
+	u8         reserved_at_20[0x60];
+};
+
 struct mlx5_ifc_flow_table_prop_layout_bits {
 	u8         ft_support[0x1];
 	u8         reserved_at_1[0x1];
@@ -539,7 +547,7 @@ struct mlx5_ifc_fte_match_set_misc_bits {
 	union mlx5_ifc_gre_key_bits gre_key;
 
 	u8         vxlan_vni[0x18];
-	u8         reserved_at_b8[0x8];
+	u8         bth_opcode[0x8];
 
 	u8         geneve_vni[0x18];
 	u8         reserved_at_d8[0x7];
@@ -756,7 +764,15 @@ struct mlx5_ifc_flow_table_nic_cap_bits {
 
 	struct mlx5_ifc_flow_table_prop_layout_bits flow_table_properties_nic_transmit_sniffer;
 
-	u8         reserved_at_e00[0x1200];
+	u8         reserved_at_e00[0x700];
+
+	struct mlx5_ifc_flow_table_fields_supported_2_bits ft_field_support_2_nic_receive_rdma;
+
+	u8         reserved_at_1580[0x280];
+
+	struct mlx5_ifc_flow_table_fields_supported_2_bits ft_field_support_2_nic_transmit_rdma;
+
+	u8         reserved_at_1880[0x780];
 
 	u8         sw_steering_nic_rx_action_drop_icm_address[0x40];
 
-- 
2.26.2

