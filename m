Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA465593165
	for <lists+netdev@lfdr.de>; Mon, 15 Aug 2022 17:12:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241804AbiHOPMG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Aug 2022 11:12:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241938AbiHOPL7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Aug 2022 11:11:59 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07on2060.outbound.protection.outlook.com [40.107.212.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99B83248DC;
        Mon, 15 Aug 2022 08:11:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kZ0CPqNG9MZU/SDdXuz7jaQ6sB+0MkvRvYhpX6BZJ/yi6+fDaQtjfLoS//qSU195yvBmls9pnst+GzpRETWWT89xe6lL8dDSFLgycv6LliqXcEw1ix25DE3PI/hAjpNGsupQdNsLN9jMLosGs2X1ADgPVNyh8Mh8YkOq+hN5nG9UuPqfscp+TMoc4SV8Ld/nuc7zKuEOfaAn2Q2D0cMTOUJYbeyO7hv4/ILCsNOasD1hN3YfqyzOELCu88tSFY2bbpF0vOeSzK3uc7a2SrNZWjFFnaKHK1nEjeVdXQE0FCu8pc57oVYh3zwbH+d3sREfGml9lojbB+zqxJYpr3zwpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kDhh+suTXT29RvTKUieh+grfbTBa5Z0nPJlgGEJ2ZB4=;
 b=eTMcBuN2OICRBOTewawRn/WlSRy/8GciQ1rFEKHDb/UFl6x8MuBJyhVIaof5SQkOJN5wdHGtcJ8oW2068iwuByggZsIlh/aC6f3hvU9iY5AHhoihqTox+4/hC87Lx2SX9XIEE9ybbVc9jWG6vm02RSYBwiXpemoDPBc1JviNNPZUND+VtWHZ1xtc2H5O7XAepH8RMzP1NN8EGmScXdY9DhvGYjBpomM0xONEbeKQhxkeuzPlt5BjmS2PEbUZrEWahdtLKs86ju7VTjoinVp5kJnT0xz0bD69XhN1HbynfYyLj1HzLRBOdz425onnupvp0hBalgZ1dv8pJnK2BNEKdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kDhh+suTXT29RvTKUieh+grfbTBa5Z0nPJlgGEJ2ZB4=;
 b=J9Av8yxnzhP8sLiNrpqJWnA8O9nmC3kMbHGbcnBmrtSindxlZ31p9IiPPdcDNTsCa5nEZHmTG6FKe6ocdxHwmqqVgzpIOvNaEzVc0z9t34gec2FRE0YsshGuHvvBCXGs5rXyUuo03/LeQ5HsiRYLvhn1TtsOYYw7M4n7dRRh3klD7kIxcIYCKevPMVCV64iH82MIYBOj1+o0UY/j5iaSzWpxDNuYRdaXZjjutF8FFFiXHGw9CWacdXFQMvuRsWiONu0ELi6k9Q3PfnADlgq1LCGqqYaiuU6vtuJpcS7WvnHPDYRMOV1BJWxUZ86IHpTv/t3jTvINTAGT+JVU8I8TqQ==
Received: from MW4PR03CA0065.namprd03.prod.outlook.com (2603:10b6:303:b6::10)
 by DM5PR12MB2583.namprd12.prod.outlook.com (2603:10b6:4:b3::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.11; Mon, 15 Aug
 2022 15:11:45 +0000
Received: from CO1NAM11FT058.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:b6:cafe::df) by MW4PR03CA0065.outlook.office365.com
 (2603:10b6:303:b6::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.16 via Frontend
 Transport; Mon, 15 Aug 2022 15:11:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.234) by
 CO1NAM11FT058.mail.protection.outlook.com (10.13.174.164) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5525.11 via Frontend Transport; Mon, 15 Aug 2022 15:11:45 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 DRHQMAIL101.nvidia.com (10.27.9.10) with Microsoft SMTP Server (TLS) id
 15.0.1497.38; Mon, 15 Aug 2022 15:11:44 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.29; Mon, 15 Aug 2022 08:11:44 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.986.29 via Frontend
 Transport; Mon, 15 Aug 2022 08:11:41 -0700
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC:     <saeedm@nvidia.com>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>,
        <kevin.tian@intel.com>, <joao.m.martins@oracle.com>,
        <leonro@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>,
        <cohuck@redhat.com>
Subject: [PATCH V4 vfio 01/10] net/mlx5: Introduce ifc bits for page tracker
Date:   Mon, 15 Aug 2022 18:11:00 +0300
Message-ID: <20220815151109.180403-2-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20220815151109.180403-1-yishaih@nvidia.com>
References: <20220815151109.180403-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d79746a3-8f90-4b99-f024-08da7ed077a4
X-MS-TrafficTypeDiagnostic: DM5PR12MB2583:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ANzidlKheYCG3jTVTo9N3DKaebelEJLcAgx0KRjFn1rrY5jtPKj6At5F4usVfi2iN9MtNfX6DPk36kMhvdl7FLotwZqXcOwyKuHozg+e3Bf32NCTv9aMlOtLMYGAa4c7plLMiDUGNzDhhF4czwx4wN3WrZZmkdtNLE2GM0O+T7oD19qDD1jzxoij4CXAg6xTgzX9oyu6mSxOv7QhB4O2VbP7MZrS6D8YuxnhV2hnYuLdm0ISojFEqIu4THSCxDqdaWtgzsmOh9tnhb6g2VPQ5LtQDa5NgjugMtfWzjyA4QGgbDSrOL0FO7nBJ42y2jQI5dbX9pAWERWSoC7r8U6cqi9yT1URQxkjRXcZMOdCeoMHSLnpbaAmMkwXMt9R/jwBOKrddlz4OczabYX1b1YBrwUnUaj7ED02+Oh8lJN7qkSmvyGc5XyvndFKDlKHE6yzDysp0rrb0Ty9YRYFnukynIYfoBxkt4JNZR+WeEx52IZUIRhbijIwMGn6DnPo1fqKkqmDQ/koDUnJ5WGQEPPy64d2504SPeQGysc64jIqDelaVU/Spv7GO/BUXZQiMTtdCOzUFQQSgZP9VVbpnjXQY7KM43MueWLPm19jiZVssMbS+s9nyG4hB2324b+dLtVbtfC/CvsXdRVsiEOCEj4X+Q/H5MT4qChEDRe+yFejywrvvQ7UyyXAPpKpiYe+iMidRboXZqUyhZzWlwSHE5lryYG3YWkJA10D466Ti0Z3sL7Y8o4T8JXhWVmtE73PvPQH5G6EJyRzL42JOmo+43i4UxMf7yCoyi9Psu7FR+VaxjukPYeAWmDNLghDgt/YAFt715dAH9hyPBQ9XylgQ++SVg==
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(346002)(376002)(136003)(396003)(39860400002)(36840700001)(46966006)(40470700004)(41300700001)(6636002)(316002)(54906003)(478600001)(26005)(40460700003)(70206006)(40480700001)(70586007)(82310400005)(4326008)(110136005)(8676002)(8936002)(5660300002)(2906002)(36860700001)(36756003)(82740400003)(186003)(86362001)(356005)(1076003)(6666004)(336012)(81166007)(426003)(2616005)(47076005)(83380400001)(7696005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Aug 2022 15:11:45.0692
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d79746a3-8f90-4b99-f024-08da7ed077a4
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT058.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB2583
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce ifc related stuff to enable using page tracker.

A page tracker is a dirty page tracking object used by the device to
report the tracking log.

Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 include/linux/mlx5/mlx5_ifc.h | 83 ++++++++++++++++++++++++++++++++++-
 1 file changed, 82 insertions(+), 1 deletion(-)

diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 4acd5610e96b..06eab92b9fb3 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -89,6 +89,7 @@ enum {
 	MLX5_OBJ_TYPE_VIRTIO_NET_Q = 0x000d,
 	MLX5_OBJ_TYPE_VIRTIO_Q_COUNTERS = 0x001c,
 	MLX5_OBJ_TYPE_MATCH_DEFINER = 0x0018,
+	MLX5_OBJ_TYPE_PAGE_TRACK = 0x46,
 	MLX5_OBJ_TYPE_MKEY = 0xff01,
 	MLX5_OBJ_TYPE_QP = 0xff02,
 	MLX5_OBJ_TYPE_PSV = 0xff03,
@@ -1733,7 +1734,9 @@ struct mlx5_ifc_cmd_hca_cap_bits {
 	u8         max_geneve_tlv_options[0x8];
 	u8         reserved_at_568[0x3];
 	u8         max_geneve_tlv_option_data_len[0x5];
-	u8         reserved_at_570[0x10];
+	u8         reserved_at_570[0x9];
+	u8         adv_virtualization[0x1];
+	u8         reserved_at_57a[0x6];
 
 	u8	   reserved_at_580[0xb];
 	u8	   log_max_dci_stream_channels[0x5];
@@ -11818,4 +11821,82 @@ struct mlx5_ifc_load_vhca_state_out_bits {
 	u8         reserved_at_40[0x40];
 };
 
+struct mlx5_ifc_adv_virtualization_cap_bits {
+	u8         reserved_at_0[0x3];
+	u8         pg_track_log_max_num[0x5];
+	u8         pg_track_max_num_range[0x8];
+	u8         pg_track_log_min_addr_space[0x8];
+	u8         pg_track_log_max_addr_space[0x8];
+
+	u8         reserved_at_20[0x3];
+	u8         pg_track_log_min_msg_size[0x5];
+	u8         reserved_at_28[0x3];
+	u8         pg_track_log_max_msg_size[0x5];
+	u8         reserved_at_30[0x3];
+	u8         pg_track_log_min_page_size[0x5];
+	u8         reserved_at_38[0x3];
+	u8         pg_track_log_max_page_size[0x5];
+
+	u8         reserved_at_40[0x7c0];
+};
+
+struct mlx5_ifc_page_track_report_entry_bits {
+	u8         dirty_address_high[0x20];
+
+	u8         dirty_address_low[0x20];
+};
+
+enum {
+	MLX5_PAGE_TRACK_STATE_TRACKING,
+	MLX5_PAGE_TRACK_STATE_REPORTING,
+	MLX5_PAGE_TRACK_STATE_ERROR,
+};
+
+struct mlx5_ifc_page_track_range_bits {
+	u8         start_address[0x40];
+
+	u8         length[0x40];
+};
+
+struct mlx5_ifc_page_track_bits {
+	u8         modify_field_select[0x40];
+
+	u8         reserved_at_40[0x10];
+	u8         vhca_id[0x10];
+
+	u8         reserved_at_60[0x20];
+
+	u8         state[0x4];
+	u8         track_type[0x4];
+	u8         log_addr_space_size[0x8];
+	u8         reserved_at_90[0x3];
+	u8         log_page_size[0x5];
+	u8         reserved_at_98[0x3];
+	u8         log_msg_size[0x5];
+
+	u8         reserved_at_a0[0x8];
+	u8         reporting_qpn[0x18];
+
+	u8         reserved_at_c0[0x18];
+	u8         num_ranges[0x8];
+
+	u8         reserved_at_e0[0x20];
+
+	u8         range_start_address[0x40];
+
+	u8         length[0x40];
+
+	struct     mlx5_ifc_page_track_range_bits track_range[0];
+};
+
+struct mlx5_ifc_create_page_track_obj_in_bits {
+	struct mlx5_ifc_general_obj_in_cmd_hdr_bits general_obj_in_cmd_hdr;
+	struct mlx5_ifc_page_track_bits obj_context;
+};
+
+struct mlx5_ifc_modify_page_track_obj_in_bits {
+	struct mlx5_ifc_general_obj_in_cmd_hdr_bits general_obj_in_cmd_hdr;
+	struct mlx5_ifc_page_track_bits obj_context;
+};
+
 #endif /* MLX5_IFC_H */
-- 
2.18.1

