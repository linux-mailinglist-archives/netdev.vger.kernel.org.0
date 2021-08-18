Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34F0E3F0291
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 13:25:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235253AbhHRLZx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 07:25:53 -0400
Received: from mail-dm6nam11on2067.outbound.protection.outlook.com ([40.107.223.67]:37601
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233798AbhHRLZv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Aug 2021 07:25:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KZkv0itsagOowUC3WhgYZq3dH2h2LA6sSYDKxjHSZyencYk3t6GoCp66DPPe89gPdAjHy5QEMb1vNxbKoUtDfMt+qrsXtdkNecEXbJOvW8/NlJf+TUsbsb+yOw9S/eVUbQAK+SnGP3NjXY7efvtduxgfeK9SASYbQ1c/OoYxy8tkLlpd1KqL6aR9FexJ0ryzn96SBwlzq9S+tIs5haDbdp13mpz1JBM9Gv2uyhA64MJelgVhSQWhgtGaObdB2zzHD6uMly82PVnKn42hzuhfwkd1JZ3a9DdOBNCuLNRI5PiGUey3tf2H4jHJ1an6eIkkjbUllHzMB5Z1tMs2U0S1iw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e74FAF7fqkKU1C9trgTp0sQeN76jQeqQSB3Yh0bE1cg=;
 b=ThoyU+k0WoZ6WgWVxE2spf69PCitjtCYB1WdvLs/ILryH+xLneLINxT8m7ZSn9L8VrjeN+Ydkwg7MOJkteDg4msp7I4SYNgwVbKtsn/kO0wU9kgfi1A+EC0SxgXL6Pk2o9fFH0esSlc500BEcAhgiLW9FXXOGIanVNq0yua2hfczkYiU2sTvGZPW5qYh0zO+7VZvPrh011mqU1EMdIFxlWTyLqxHWD7wGr8fV4heWnaqHby+ihLdmzvQLNa7cZboV43eI/CKFPquPeG3yNh6M45NfvsaC5aF9U6JD1zGaW6NVuuOH4wjBdkmv6guyBg6obf+oWwrKwO9iwWKECcOaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e74FAF7fqkKU1C9trgTp0sQeN76jQeqQSB3Yh0bE1cg=;
 b=LlMEZznitbzqT+YXxDlg5YcTq+HszD5Kw2247izxMHwqOqGVlu8OwpK6uBm5NNWlB/bMhUlfCNqJco0gyMfIonn9HMZ9V+2kYmN7XNo8aXjiFZjH55QPxjdmGq+oFHX83LqitY2U6Y2n+ddSoA6xH0IODs/eaRA6+5wgHKPNnx6gc7NuG4d0OmKmFiOahdHNoyennhtw3UYYjQljhNrSErpJpbkGgrSo/MbDAhxQ8n+gvcVbmmUmzavgz1zqWnl5MWZEWpPdu+WpTyg26ejLM6i6u9IWojLSk0ed9XXlpJSc6rIIGgKQgnLi5SGjGB7QmsLXoTHLngRXywp37A+aPQ==
Received: from BN6PR14CA0016.namprd14.prod.outlook.com (2603:10b6:404:79::26)
 by DM6PR12MB3372.namprd12.prod.outlook.com (2603:10b6:5:11b::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.17; Wed, 18 Aug
 2021 11:25:15 +0000
Received: from BN8NAM11FT031.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:79:cafe::82) by BN6PR14CA0016.outlook.office365.com
 (2603:10b6:404:79::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend
 Transport; Wed, 18 Aug 2021 11:25:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT031.mail.protection.outlook.com (10.13.177.25) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4415.16 via Frontend Transport; Wed, 18 Aug 2021 11:25:15 +0000
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 18 Aug
 2021 11:25:14 +0000
Received: from vdi.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 18 Aug 2021 11:25:13 +0000
From:   Mark Zhang <markzhang@nvidia.com>
To:     <jgg@nvidia.com>, <dledford@redhat.com>, <saeedm@nvidia.com>
CC:     <linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
        <aharonl@nvidia.com>, <netao@nvidia.com>, <leonro@nvidia.com>,
        Mark Zhang <markzhang@nvidia.com>
Subject: [PATCH rdma-next 01/10] net/mlx5: Add support in bth_opcode as a match criteria
Date:   Wed, 18 Aug 2021 14:24:19 +0300
Message-ID: <20210818112428.209111-2-markzhang@nvidia.com>
X-Mailer: git-send-email 2.8.4
In-Reply-To: <20210818112428.209111-1-markzhang@nvidia.com>
References: <20210818112428.209111-1-markzhang@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 325b8b56-c4fb-43e9-0c06-08d9623ada07
X-MS-TrafficTypeDiagnostic: DM6PR12MB3372:
X-Microsoft-Antispam-PRVS: <DM6PR12MB33725ADC1F6DF1186F74B194C7FF9@DM6PR12MB3372.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1T6ThK9KdpMkNykYmQv6UM7z8VFzeV5UtjuU7EnljYMxj6nuTrdhc72uO/q1O3kGeF1f98KMyVsu95i29gUOqfoK1DTAlYKhOm6ygzyqjxre1VUZfGDGSY3WWS/UnSHKJU+WDLUfT2EwdkRd8zPeeOh9HD6g1vTchwPL384XoCYJ1/u8cNXIs/JhMd5N0/7UFD5AdXYZ1BEumSQ8+opeHyxObkjVlpMyTWDXAIYT0QF+94glt+G3+EeAS1lhiCyT73mBtd/wXGWJLUhf5FTkZgLiDsXKbLLvrKDOGHQyXWKgsTRaI/Ovc0Nf99A+Ueo0Tpx1muYFmKnAjzfQIlWj91qsGPwclEQZwN63aH+4dHtpE64r3EXal3nHRwk3TLSvw0f5AEERH5L3QZkhK8XcokfpOj94VZomB3G6dZ2awEJZSBfnLBH/NL5dEeyXpWadFQL8NxVk/9lgsu46lY+EjuZPQ89RbGzrK23V8UaqVYdkmZkb6ZqPAVdgw2JnQaBHgvZp8gD70cABq7YgEt2m2pxEZwqxRzgY12sQZNyNhOSMTqzenTymQhAI8ZlO5huMPEQgUjuLzocgTG+t8tIZhxvQHxKGv73y+FLuHwlwToKxPZx2cfvpxaUqDNKHhsnRzcB3ZTSlk7XZsZc5pJEPVQmgDoSBL1kQNInEljle75gI0IWLHm91wXyoBEbsRZhJWfg6W/uxck7Ft3/7/ChX9g==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(346002)(396003)(376002)(136003)(36840700001)(46966006)(47076005)(2906002)(336012)(86362001)(8936002)(36756003)(107886003)(478600001)(36860700001)(316002)(8676002)(110136005)(1076003)(54906003)(5660300002)(7696005)(6636002)(2616005)(82740400003)(356005)(7636003)(82310400003)(83380400001)(186003)(26005)(426003)(4326008)(70206006)(70586007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2021 11:25:15.3486
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 325b8b56-c4fb-43e9-0c06-08d9623ada07
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT031.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3372
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aharon Landau <aharonl@nvidia.com>

Adding bth_opcode field and the relevant bits.
This field will be used to capture and count cnp packets.

Signed-off-by: Aharon Landau <aharonl@nvidia.com>
Reviewed-by: Maor Gottlieb <maorg@nvidia.com>
Signed-off-by: Mark Zhang <markzhang@nvidia.com>
---
 include/linux/mlx5/mlx5_ifc.h | 20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 3dd6641e942c..2828d596af49 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
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

