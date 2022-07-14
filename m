Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 222B1574667
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 10:14:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231220AbiGNIOS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 04:14:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231131AbiGNIOQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 04:14:16 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2061e.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e8b::61e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6862A140B8;
        Thu, 14 Jul 2022 01:14:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ei6/9DFYCgeGpbm5F9so8AOBnGG+8A3QDErvCPBnruLuwvLtrq7FA9ta079C8Yl0cQkR0qOzxgy6sRWtOqGjliFJFdZ1DxAT+Gp+uKal45gkekduFR1GMaxmFhYJB9PDivmyjghpLaDGJA9BXkTIyck9rhbUhe+g62sVe7tdG74qKiPrswwllUDGmj0dgMz98Mj6lRJh/EqNzWc2V4t+vQbOShQ2UJthNPkXIiHlEwPtma4x93weLTfySQ2RD39R9vTXFvPw0O/i+6deMREXgiKBEfRxDCjB2Lqi6tpJqrg9GXemTCT6nhHfU6MTC/3S1No9INtWMm8lWmIHgj83Uw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1IF1CK6d5+J7F2DHDnfClHruppP4hP5qBD/+lM40s54=;
 b=Kzx2WiGDl++gQDmX016U4cPfMMmaFFRay9XtrMXJod1aO6+6hZXlx/RfglxFKsrh/5AntlnHYBtJcf75mKB0p/HzalrVrPFCdOmO/O/1wzDfQJFaYcdmuIYmZCaKcfsZE6Qri6Oqink0h73Hqm2ORg3ReYoqqCC70If6ooswZ34IvljS3FHAgk7PcgAvc62Hd9/7nDG0qJhUM/JWYFVx4fUXPd4Xu3qjGTmWKIVYrLpQrfaNNPhsP7RLhiF7y/2Z17l0Elx3KfgWMNr+WPpTtwO00XLdbvZjZEY0CFL1jOVWvP1tWq/Cke9cXbmbcpMg8y1XZtP6KeWE2llYc6DgOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1IF1CK6d5+J7F2DHDnfClHruppP4hP5qBD/+lM40s54=;
 b=GczKefV8WfBwGOtCGBGARMaJ3VMkYjSLeuYzNC+Dik9QqdjmebXpTwzEzMXxt5P7A+YeaVVf0ERZcMEQO3YPwSaHRecAohiFkUtxhoAmL6/OzV6IzDRPKUp3T6QtpSxl9wk2a/hl9WwCobD53TmYEt5RbyJoEwpCssR8h7FQKNkIUqESTTxmJGAidEBUsKaA53VjhzZ6RyXrJ2vXIYTJmidq/7/88nyS18OzfWDzxenlzdkJ7nrcZTy8RE6PscBKoliwEwBdoTSLIjShBfeNzwpNAa8byqfqOa5DvI8Z2+lbIQnElBCo2RfA6SchrbWmzVJqtD8riBIt53zEECnMJw==
Received: from MW4PR03CA0259.namprd03.prod.outlook.com (2603:10b6:303:b4::24)
 by DM5PR1201MB0140.namprd12.prod.outlook.com (2603:10b6:4:57::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.20; Thu, 14 Jul
 2022 08:14:13 +0000
Received: from CO1NAM11FT053.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:b4:cafe::d0) by MW4PR03CA0259.outlook.office365.com
 (2603:10b6:303:b4::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.21 via Frontend
 Transport; Thu, 14 Jul 2022 08:14:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.236) by
 CO1NAM11FT053.mail.protection.outlook.com (10.13.175.63) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5438.12 via Frontend Transport; Thu, 14 Jul 2022 08:14:12 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 DRHQMAIL109.nvidia.com (10.27.9.19) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Thu, 14 Jul 2022 08:14:12 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.26; Thu, 14 Jul 2022 01:14:11 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.986.26 via Frontend
 Transport; Thu, 14 Jul 2022 01:14:07 -0700
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC:     <saeedm@nvidia.com>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>,
        <kevin.tian@intel.com>, <joao.m.martins@oracle.com>,
        <leonro@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>,
        <cohuck@redhat.com>
Subject: [PATCH V2 vfio 01/11] net/mlx5: Introduce ifc bits for page tracker
Date:   Thu, 14 Jul 2022 11:12:41 +0300
Message-ID: <20220714081251.240584-2-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20220714081251.240584-1-yishaih@nvidia.com>
References: <20220714081251.240584-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 54b6ff66-2d2f-4a02-43a3-08da6570d617
X-MS-TrafficTypeDiagnostic: DM5PR1201MB0140:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hRLUHcJWx+aroMEEn6/5wdh5K+I6rYv6r4Ga81EJMI54JEj0BsbEUzQzW6nwHFxD1+TomfqsM26lNI7Q5kDu4NGC2MgabctYT38pdaBc1jQoo4vztVr+6RGl7CAFA8thHquIuumaHo113+QGFMpgWvWVR2hOn+SETe4wcGI5nzPPcMH2NNhL/RjTlNjgMrnE1Se7FhYUPDBwRZSGy7yBIg2oQmOjAGx8vS8Ne2SOOKtmUmYVKniHkc8RuwERN7Adijz0XJXrBo4VXghdtxI7KoPNX1eZyCXs9WNhuytoMdXZ3sK4FurUsZtEP66Ww5fJt/B9U7Rn7Mrn5Xhu/C+FPAyVUm3kpwmqWdZgnE3HliaOpgC6GTdcbUCrt//8BkLaZIUo8qkIRzU/qhwZrjveKYzKNmM6Pu6Lq/0BM65EJ2+/cLGKyQ7/ECd5GTRvuEGya90SH2Hha3mjFDNidEBTnq0CbD1FG3f5eq4owNMgoywy2Csr8XrTnotMSnoPD4LwVZyPTmWxO0JOQaUn2jXEPqcP3cFQ5LAZVeb5EbquTeQ5KmCBAlPzEdrSUvslr/f+nOWbUryPoLcu3CnmxnVNvisE/i2uQDre1AbVo4mGc30t9ZbMCQb51+S9Jl+6lTyxMvRYehqLNYkvQKjhqc6Ijz9dPBBXht8rbF+pnz2JPagFJetcX6HFqy/7ePdjHXAGpK31G2WIIS6NlP+bU3TFnriaET2T2acovonch1Nsv0WwoeN2/wM9t19W8dqBlc8adxNM0u+Xz6xIejnovRMk/QMYG0TmtxoVejBdNRs1iTC3UVROI0p3ZDTHG6xmBiFBhaAtGxMYQELXx6Xn7OMoKCxzl0BThEZVv+uKWdpjiVA=
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(396003)(376002)(39860400002)(346002)(136003)(46966006)(40470700004)(36840700001)(2906002)(478600001)(81166007)(1076003)(83380400001)(86362001)(54906003)(36756003)(40460700003)(6666004)(6636002)(36860700001)(5660300002)(186003)(110136005)(82310400005)(2616005)(4326008)(426003)(7696005)(40480700001)(47076005)(336012)(8936002)(70586007)(316002)(70206006)(356005)(41300700001)(8676002)(82740400003)(26005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2022 08:14:12.8000
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 54b6ff66-2d2f-4a02-43a3-08da6570d617
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT053.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1201MB0140
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
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
 include/linux/mlx5/mlx5_ifc.h | 79 ++++++++++++++++++++++++++++++++++-
 1 file changed, 78 insertions(+), 1 deletion(-)

diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index fd7d083a34d3..b2d56fea6a09 100644
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
@@ -1711,7 +1712,9 @@ struct mlx5_ifc_cmd_hca_cap_bits {
 	u8         max_geneve_tlv_options[0x8];
 	u8         reserved_at_568[0x3];
 	u8         max_geneve_tlv_option_data_len[0x5];
-	u8         reserved_at_570[0x10];
+	u8         reserved_at_570[0x9];
+	u8         adv_virtualization[0x1];
+	u8         reserved_at_57a[0x6];
 
 	u8	   reserved_at_580[0xb];
 	u8	   log_max_dci_stream_channels[0x5];
@@ -11668,4 +11671,78 @@ struct mlx5_ifc_load_vhca_state_out_bits {
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
+	u8         pg_track_log_max_msg_size[0x8];
+	u8         pg_track_log_min_page_size[0x8];
+	u8         pg_track_log_max_page_size[0x8];
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
 #endif /* MLX5_IFC_H */
-- 
2.18.1

