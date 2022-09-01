Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEA7F5A936A
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 11:42:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234051AbiIAJlt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Sep 2022 05:41:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233792AbiIAJl2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 05:41:28 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2074.outbound.protection.outlook.com [40.107.243.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9641134195;
        Thu,  1 Sep 2022 02:41:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ext8XGZM3Z4RF1CoxD4A4+2qIihaQpmrVdoL4N0wtDleSKbrH4FFqRGfa2eaDwlnatp9c36Ragg7s19INqb1X4DnzvrIIklAvOxwZuz11OD8MWzfxiizVdLiH8CUtwuMDdGg8V05jMlb0wFt67x9KmTiFdj55W4x/pROlO92gBOCfU4CI27cjKWy5R6KcU8Yb8JPq6fOIrAz1MThzcp07S0ECrSu68wAz3udqtwIQCTFqwIzoBR98CuG7BsRE4R9/ZFw2aZg4UMFrhoOukbDVUyQ/KygvBAxs9SPpltwxfa6vKiGhwmEBmb02wrfP0WQPrvCeFMIZQQou80qJ4Oo/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kDhh+suTXT29RvTKUieh+grfbTBa5Z0nPJlgGEJ2ZB4=;
 b=K1t4edswe65itiYwtixoteEsngARJbXeZTtsgJi120vYKimSdQ7+nChal/85o6UIJU52CSJ3VFeAfB5d57cgEU7LqWrv/VWmtW5BabMBgx/+2274SoSXBURL7pJs+Ne0xwrgdboePyiQe9SPkjWKquF8OzUVQrD6kVv+oWSYDoCYDWR6Pb60q1D3FV56Cp5VFemkg+cdjFUV0a/2ILpNLhO8h5DCfEuFBNV1DIc3RFgqHVjTcIC7GlvHNVbbeSz1pHeQnl7sf6nb+kik8cbxE9eFMfL7+vqtqDx8jEsCwiYCBGdGiYtmnv8pZ4WTcGZ65K6h7J6jscrHUcb4/7QqKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kDhh+suTXT29RvTKUieh+grfbTBa5Z0nPJlgGEJ2ZB4=;
 b=ul2ENonDdNBUr6vDdSWwrfKP/HsDoE5e6KP1AKzalYp8g77TPxHvyl+jA0CbMaLYwlDnvjVeMheW4DLMLbRG84hPiVBOkHY48VXPPQQ8WT3hwTkyWiUqwFZyYag3bDe8O/riar8FEinVAibW2+dnmR13w4VEPQu6TY6K1VNwcQmcCO3i44ftYHltuRFI6kJxNPZCkn1HkUh2pfBREJ5eEl9703vqmRsd++z+WWTExsNgKxhN6ZLrmaaR6Pykt/m7rQnYSkCOgB5+xYsK/N/zIS9sugDuv9/gzCU8/eWMdHIlm39xRTy8dJ5JFkMjQ1wOzVKu0xJkhpHts4CyTSVbpA==
Received: from BN9PR03CA0280.namprd03.prod.outlook.com (2603:10b6:408:f5::15)
 by PH8PR12MB6867.namprd12.prod.outlook.com (2603:10b6:510:1ca::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.10; Thu, 1 Sep
 2022 09:41:23 +0000
Received: from BN8NAM11FT030.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:f5:cafe::b1) by BN9PR03CA0280.outlook.office365.com
 (2603:10b6:408:f5::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.10 via Frontend
 Transport; Thu, 1 Sep 2022 09:41:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.236) by
 BN8NAM11FT030.mail.protection.outlook.com (10.13.177.146) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5588.10 via Frontend Transport; Thu, 1 Sep 2022 09:41:22 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 DRHQMAIL109.nvidia.com (10.27.9.19) with Microsoft SMTP Server (TLS) id
 15.0.1497.38; Thu, 1 Sep 2022 09:40:32 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.29; Thu, 1 Sep 2022 02:40:31 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.986.29 via Frontend
 Transport; Thu, 1 Sep 2022 02:40:29 -0700
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC:     <saeedm@nvidia.com>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>,
        <kevin.tian@intel.com>, <joao.m.martins@oracle.com>,
        <leonro@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>,
        <cohuck@redhat.com>
Subject: [PATCH V5 vfio 01/10] net/mlx5: Introduce ifc bits for page tracker
Date:   Thu, 1 Sep 2022 12:38:44 +0300
Message-ID: <20220901093853.60194-2-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20220901093853.60194-1-yishaih@nvidia.com>
References: <20220901093853.60194-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7d055a29-7eee-422d-b44e-08da8bfe2188
X-MS-TrafficTypeDiagnostic: PH8PR12MB6867:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: umPIMzoeU7TzmaUrIUk4YPzR0bHi2c9+/4qW/+RXIkZCoXPSGiMFUs4N51hrVP4Q6WmxUgmIauzP678uKHKSMfk+1fhGGxWFurppc8SLb5ioLaf22wOdZmlExYL7QHVUtxzOlzD2owJhjiVEXtaZSIlUN/txw0RXkvmMeWuC29TH7WHa+g4PsVy4wx6gK5dfZcDEBC8ZotSet4O1INF4WIimWANSh5ZDxzS3EWOm5U4P7jgJ38pjIHXFsIwn4Vzbk3rBx9UKVM5YdYxwUEmTcX7ac8mBGBH47LHKk3RK9XTLZSt3h5sFRUyqQ+ytyFr+awwtsz10sGEshNPHfH7dQafha6WgIf1aiVGKKqTMs6l+dBDPkzfw0/WtbZlCKZ0N/4aXLV9QifeWSZxjzq28BfLIJVO8NaQRwB/ioH0QVukTKeb7EyA9bX0pzjziAUkGF0VVSJcJn8+7J8wobGmUZKYJuiL8e3vcUl7TNGbXuM5cSYctVowMnbEAuolCiMaIHsomuJlMuXVCQPVCpsCN1qhtoQq6trhLA/Kg5mwMFSELNbvCV7e1u6Sv52T7TFFJ1NcPxrUnOnz25AnKRVhMJ0Sha9zsNCSKbSCpB3ajUOLDKVhOsogFZc1u6hYZAMz6Zn+iVX+vuNOzeJw0qEESumHdnDGAkKdb+u8HAlMR+MlfFewZAVNjRs1aeDQeBOq394F4mqHmXjBkFVkDGffl7Zjz/qDfLlLln8aW0OeC+NLB1JUNci/73/KUk8IPD9RDjUiOqtIqPy1bKjHAdRVmJjIWrzZ7yHFtCHHRVbN0ublTJrDs2nL8b5/737qXm0LK
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(376002)(136003)(396003)(39860400002)(346002)(46966006)(36840700001)(40470700004)(86362001)(6636002)(47076005)(426003)(5660300002)(356005)(6666004)(7696005)(186003)(336012)(8936002)(41300700001)(81166007)(110136005)(82310400005)(316002)(36756003)(54906003)(40460700003)(40480700001)(8676002)(2616005)(36860700001)(83380400001)(1076003)(2906002)(70206006)(82740400003)(4326008)(70586007)(478600001)(26005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2022 09:41:22.5032
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d055a29-7eee-422d-b44e-08da8bfe2188
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT030.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6867
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

