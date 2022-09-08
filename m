Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9D825B25D9
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 20:35:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231886AbiIHSfV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 14:35:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231796AbiIHSfS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 14:35:18 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2057.outbound.protection.outlook.com [40.107.223.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62A308C02C;
        Thu,  8 Sep 2022 11:35:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fuEKgd/sszeq2TXmeW3wup2KnoRqCCmSZyBxGP0CzN5ll/IrsaEAPUEfGDMVC9yyh+qRmbFMYFzs5/oJp6reVdDLvElCaHiB/rOdrdhwpczPIF52tN3SjC8xmXctv+imqZt6UnzrvIbLqSkwUMyXVuO4HSd7SGuMWVYB3XEXMCWlHSjGqybraSmIVI/eWqdG13UbvCgzjh26JvBlTcf3jL0J6UAX6xXuxXcmvfVLQYC+AxEMCelp9A3dxSeSxbIWSZA4x45xjCfUsfJzIsqNPQEXrmFEhxcpAKTGST2XXYcy74xnuDImINR5lfVUKw7FqMwq5ty9CEQIXtDea2qUrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NuXxwb15BHfeLGDsQmceuAOdscazyKp0UP93KYQCPiE=;
 b=fb0jrAV/Rjt/wBddyBZ233Nka+Nws06p2W9j+ApooQEf4iF0ef0Dl3/n+BryU5DCfb58oWdrEqiFQhnanJxWTZrNluRH154Sjt/JDgaZWZX/7fuVyk6hhIJE6c2rlnb/Hw9JcBlCVb3ZnRIhwmG2I9vVterhieZcmetBmFBk0pu/BWL3FAwt2k0VE8xOsSpYgnKjuPhXD/nXQePv3ELjHG0RpxU4EfwDJp1YAJAxpTMPgPV+CSXm/vEAgxRgRA9vSHt9WPIWAVVlbm1ooAMYYNYpYAlNTaRS8Z1mV33bqhlFIqiHD3/b4Nh2l8miRvxBb0sAO1Q/BbP4Swlx+YIRtg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=oracle.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NuXxwb15BHfeLGDsQmceuAOdscazyKp0UP93KYQCPiE=;
 b=VhxkHYCwA8sxOGnEWraozpHi18g2RbaKZenJg25VUrXF1CqUFmYtPILcYuHQA/pMHnU65MCK2qXDYBsBv5FdWZCo/xCCOYynk4N4H/jVBy0woicQSyVLDn/AjPqQU2YyGjefY2M4/NMN6P1hUSgbaUQNOCHrEiWDp27JFO6dTpq5JwFzxJ67k4igDC6/+OYtVBjzR4kQ4ijeHHpKdsEhl54F2yHUnNZb0B4Sv7ejiG/SfGy1hEf0q4ijrjyKmOj+PaTmUWrxsFV/6MPUFsRwHLHGeYlZyh+m+724KfZelzbZngxYTi2OpNHh7mZmrWHJILqtS5wR+knpACBOXH8ZZQ==
Received: from BN0PR10CA0013.namprd10.prod.outlook.com (2603:10b6:408:143::17)
 by CY5PR12MB6225.namprd12.prod.outlook.com (2603:10b6:930:23::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.12; Thu, 8 Sep
 2022 18:35:14 +0000
Received: from BN8NAM11FT085.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:143:cafe::55) by BN0PR10CA0013.outlook.office365.com
 (2603:10b6:408:143::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.15 via Frontend
 Transport; Thu, 8 Sep 2022 18:35:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.234) by
 BN8NAM11FT085.mail.protection.outlook.com (10.13.176.100) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5612.13 via Frontend Transport; Thu, 8 Sep 2022 18:35:14 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.38; Thu, 8 Sep
 2022 18:35:13 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Thu, 8 Sep 2022
 11:35:12 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.9)
 with Microsoft SMTP Server id 15.2.986.29 via Frontend Transport; Thu, 8 Sep
 2022 11:35:09 -0700
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC:     <saeedm@nvidia.com>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>,
        <kevin.tian@intel.com>, <joao.m.martins@oracle.com>,
        <leonro@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>,
        <cohuck@redhat.com>, Leon Romanovsky <leon@kernel.org>
Subject: [PATCH V7 vfio 01/10] net/mlx5: Introduce ifc bits for page tracker
Date:   Thu, 8 Sep 2022 21:34:39 +0300
Message-ID: <20220908183448.195262-2-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20220908183448.195262-1-yishaih@nvidia.com>
References: <20220908183448.195262-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT085:EE_|CY5PR12MB6225:EE_
X-MS-Office365-Filtering-Correlation-Id: 883ea77a-6ee4-4a6e-6964-08da91c8df0a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: u5JrlsLgMwIxcoyfC6FaqcmWCGIYgfEdgNAU/LvDowKdlxG67AzJkCp4uCZq3040vIsModHW6VGP6zj4RquI+AnDJY2zD6uUUX8Y2fjpcNZlInDlpZUP4aeWT/o+q4O7rbI9T9zu4HoVI2F//6IuwywHZtkLJzGsVYAijTePMwnmR2hsrQ/3gzKwBz6/MrHkryt/nnb/5JttlSPqyLOJJteVI7NfU362CQcimVnWb1cA3k41bHmz1o1rAwejbjIE+G62PFv5+qthscb3bwJuMIUfJotGHmgCAnio8gyTPafIjb0wiYaqiu3SNhIETOuh+ZYie+FGw3kubBC5K0tu1ImaWj04BHKUzM6i8f4ZixF5DbIsgXJpWiVmvhD5BIknJ2rQQEJ4AXbLJVFgMa9Szz9etuCVeKuCNhF0BqBpTdwDsiI6GwMpzKkMANK5sqluj0vnj9gIX/YM0KaJP+MpWi4aPADw+4bbpn+fADW5JjNlfwbayRtuHbTnjGZufcOD1dKAeoaBgGQ9IGpIEDvFsSViagWR7GebQ+UHDgNMr8TvJUcsXIUYMc9n0DPhQsLbQswgelf9WsHbJfoB/vcHADzGp+wwJWvy0hyrVzo2NlsxFB20XXEFNaMnZp2fORI3n+weazkAQ8A2xf7DOzybwnh6UJbGGSzwSBon3DwsjeAwOkP44IC5qFHF3zcfqJd6fuGfDj0983uYYADMtS//sZnVN3bTDW/f4Nt2zQPPmj99QOZWzgCK0ktXwB8tjOUYoBcwP1PSqC+ApU0AOt3n3BJZl1gNMAAnm1sgifP+gmIzICRuH6SZO7t8Kv/O42zZhz1hni22zrL879R58JdJDOUNWz06YMHpH5bgR/oNK3NZ/cf1HFn1yDz/y4FuD1J7
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(376002)(136003)(396003)(346002)(39860400002)(36840700001)(40470700004)(46966006)(5660300002)(47076005)(70586007)(8676002)(83380400001)(966005)(70206006)(478600001)(7696005)(1076003)(26005)(6666004)(40460700003)(2906002)(426003)(186003)(86362001)(8936002)(336012)(4326008)(2616005)(6636002)(41300700001)(36756003)(81166007)(82310400005)(40480700001)(316002)(110136005)(36860700001)(54906003)(82740400003)(356005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2022 18:35:14.5959
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 883ea77a-6ee4-4a6e-6964-08da91c8df0a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT085.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6225
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
Link: https://lore.kernel.org/r/20220905105852.26398-2-yishaih@nvidia.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
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

