Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C14043D2272
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 13:05:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231761AbhGVKYs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 06:24:48 -0400
Received: from mail-bn7nam10on2053.outbound.protection.outlook.com ([40.107.92.53]:34273
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231698AbhGVKYZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Jul 2021 06:24:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L61T+itCnm7mjNpuuAwvQvEQYJt/ulV5R7Ax3TLicmpbdDq8CtuL9Z3910YO+WuOY+tgCgNnAkhIzD5yoB/KBrGRfNrX0c9AWfH4tSqiB4NvjyLUCED3fvNAQb4JCxhdvJNTUtYR7po9cN3UQLHMmM+q4GWIemYEfecZQi5VHwfpDQtoxPIpegXpxzrjgaqiHrfJyAQh6RKrKO5S0zCRkmi1KImXj06sh4mRvRCs9jmuW2dOTEWBE7wu5vDauRq2AjPuca/9RJN1l9taYDzTdFr460AKiUw7ONhzV7a4o7kpttkU+cwNm1Y1NW4SxUla8GxZeEj6e+Pj9lmG8JrbYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2/b1P+mmdEkY/2jjay+h1NlMcdiO1zcXNI0ggrM6BnA=;
 b=D6EKjc6j3DtAjML2F6p7tKZGs/KtmOf/9saa5dqwbt0CVofRAWvy3MY6MTVCDYzvdQgn4ED74rp+97VZv5wRNfZInOT3HwBx+6/ZeQhHb5AFQsDWa5DzeNF+VcTmCnb5G2Km+f1XPUve0KDy7Fw1zr6FTUagxfwf95slYeDxL5rDQkaGfx43r8475uFZJR2z+BytdQZSii2n/R1diMBvXgmevLbBdRcNOc/rZ9yD6x5tuZmgjVC4FmcnIxw4zRxBt1eGFXh/oLcFN/+v1myoZfcodQu6LVplIcZjuxVx0YngS41VLWQAddl4wsvGayez/0dtU4h/zg3jK3ef64cA9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=marvell.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2/b1P+mmdEkY/2jjay+h1NlMcdiO1zcXNI0ggrM6BnA=;
 b=HOubwWC5RTlXZpxtXRQEcfFa/smoYgNE5oCftcAn8e/ECmKrC812Hyzz5Nsl2m/PqJw+hU9aCddmNCrDIyxIPWICIFyUu28aWMdc1Xyx397/b+e9EfN4Hz6BexIs8IwS4HwsS/1xE5oKF4wYBw8vrIVGHUFpDJSonHtcKFzguAlztJwbLB25h66oWRLGqYTbfNN7Mcqpr//jHmFB1xZbmj4k7mdybRs2RHW3hhjtBskrcuGyLDEGwoetseiwZGKHXhacqQCKJurmQD2ol0A3oVQ1ZIUd9GOfdHJE9XF9urymw/NHm3DMhecSuMWD7K1RMDrKAsSeb866QvFDMoC3Hw==
Received: from BN0PR03CA0002.namprd03.prod.outlook.com (2603:10b6:408:e6::7)
 by SN1PR12MB2477.namprd12.prod.outlook.com (2603:10b6:802:28::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.26; Thu, 22 Jul
 2021 11:04:58 +0000
Received: from BN8NAM11FT004.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e6:cafe::a0) by BN0PR03CA0002.outlook.office365.com
 (2603:10b6:408:e6::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.25 via Frontend
 Transport; Thu, 22 Jul 2021 11:04:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; marvell.com; dkim=none (message not signed)
 header.d=none;marvell.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT004.mail.protection.outlook.com (10.13.176.164) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4352.24 via Frontend Transport; Thu, 22 Jul 2021 11:04:58 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 22 Jul
 2021 11:04:57 +0000
Received: from vdi.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 22 Jul 2021 11:04:53 +0000
From:   Boris Pismenny <borisp@nvidia.com>
To:     <dsahern@gmail.com>, <kuba@kernel.org>, <davem@davemloft.net>,
        <saeedm@nvidia.com>, <hch@lst.de>, <sagi@grimberg.me>,
        <axboe@fb.com>, <kbusch@kernel.org>, <viro@zeniv.linux.org.uk>,
        <edumazet@google.com>, <smalin@marvell.com>
CC:     <boris.pismenny@gmail.com>, <linux-nvme@lists.infradead.org>,
        <netdev@vger.kernel.org>, <benishay@nvidia.com>,
        <ogerlitz@nvidia.com>, <yorayz@nvidia.com>,
        Boris Pismenny <borisp@mellanox.com>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Yoray Zack <yorayz@mellanox.com>
Subject: [PATCH v5 net-next 09/36] net/mlx5: Header file changes for nvme-tcp offload
Date:   Thu, 22 Jul 2021 14:02:58 +0300
Message-ID: <20210722110325.371-10-borisp@nvidia.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20210722110325.371-1-borisp@nvidia.com>
References: <20210722110325.371-1-borisp@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9b5a8e08-5a0a-4590-05a0-08d94d008b8f
X-MS-TrafficTypeDiagnostic: SN1PR12MB2477:
X-Microsoft-Antispam-PRVS: <SN1PR12MB2477D55657C1BA76469A2808BDE49@SN1PR12MB2477.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8TIr0Kkgv11QmEiDfcCwJWLigkBYgL93goRAYxiMIBv4R2lsW0QdBYrqHHBS5fyWYqGvGg1K2SMfXLLVhsNJy768Xp9X+vcBdhocG3WQmifg5G+Y2GUXrSTXN4xylYg1HaRtAHL42K7fDxaw4RT9g+DXJdeag/rjGGfEwf4/4zq3i59lW8cj5wyafn3PaePxxnrIp64RKX6cOVKzLA6s5gBXeskkDHjbkIiLrvSW/8/kLblI73TEDX7yDzCnLWL1yNERXCvS01bmpUYYscC1SbLj5xoPJOXoWMuJacOUdRnXThWq0mhkgvi0lMS+fI05VKIRrLYbdjKPBTQC6/M6qF9xY7RYrWyk/NX5XREqG1IW8EGhr4puapoz8rzJb2VBzVe0tdt8ZEvb7zSqZRSXexvc7XGOhpIP26WhgdL+8EpoFpRRau7OhoNE02/II/QIzbvnU4SD8WhZuAoagCGgAYJ5MD6nunFuCE5VHiZQa7qnN/j/eolP5KhxS+1lfHIRnjpZMnY+K12ZxMTMpUHcQRzowaARzXVNbViRmCGP0AOYgOUI5oMLYICIGTEFvNxG1EXsBUJ2IerpEs3AtIfkzQMLrge8CYqZSJ4IRoFalQx8BhCi5gShyjoYfl3j9tYM569Jg1HwbjE4YRpdpz/wuDDu486lse1DszBb+XfCrV6HfldvOF5+0N4zth3Pcz1/h2vjLDT2TkUFCou3FHED98gOz3pOHidff60KBcFoyBE=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(376002)(396003)(39860400002)(346002)(36840700001)(46966006)(5660300002)(36906005)(54906003)(82310400003)(426003)(86362001)(356005)(110136005)(7696005)(316002)(1076003)(36860700001)(8936002)(47076005)(336012)(2616005)(82740400003)(107886003)(70586007)(70206006)(36756003)(8676002)(7636003)(186003)(921005)(26005)(478600001)(4326008)(83380400001)(2906002)(7416002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2021 11:04:58.4691
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b5a8e08-5a0a-4590-05a0-08d94d008b8f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT004.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2477
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ben Ben-ishay <benishay@nvidia.com>

Add the necessary infrastructure for NVMEoTCP offload:

- Add nvmeocp_en + nvmeotcp_crc_en bit to the TIR for identify NVMEoTCP offload flow
  And tag_buffer_id that will be used by the connected nvmeotcp_queues
- Add new CQE field that will be used to pass scattered data information to SW
- Add new capability to HCA_CAP that represnts the NVMEoTCP offload ability

Signed-off-by: Ben Ben-ishay <benishay@nvidia.com>
Signed-off-by: Boris Pismenny <borisp@mellanox.com>
Signed-off-by: Or Gerlitz <ogerlitz@mellanox.com>
Signed-off-by: Yoray Zack <yorayz@mellanox.com>
---
 include/linux/mlx5/device.h   |   8 +++
 include/linux/mlx5/mlx5_ifc.h | 101 +++++++++++++++++++++++++++++++++-
 include/linux/mlx5/qp.h       |   1 +
 3 files changed, 107 insertions(+), 3 deletions(-)

diff --git a/include/linux/mlx5/device.h b/include/linux/mlx5/device.h
index 0025913505ab..a42e47f91327 100644
--- a/include/linux/mlx5/device.h
+++ b/include/linux/mlx5/device.h
@@ -263,6 +263,7 @@ enum {
 enum {
 	MLX5_MKEY_MASK_LEN		= 1ull << 0,
 	MLX5_MKEY_MASK_PAGE_SIZE	= 1ull << 1,
+	MLX5_MKEY_MASK_XLT_OCT_SIZE     = 1ull << 2,
 	MLX5_MKEY_MASK_START_ADDR	= 1ull << 6,
 	MLX5_MKEY_MASK_PD		= 1ull << 7,
 	MLX5_MKEY_MASK_EN_RINVAL	= 1ull << 8,
@@ -1179,6 +1180,7 @@ enum mlx5_cap_type {
 	MLX5_CAP_VDPA_EMULATION = 0x13,
 	MLX5_CAP_DEV_EVENT = 0x14,
 	MLX5_CAP_IPSEC,
+	MLX5_CAP_DEV_NVMEOTCP = 0x19,
 	MLX5_CAP_GENERAL_2 = 0x20,
 	/* NUM OF CAP Types */
 	MLX5_CAP_NUM
@@ -1409,6 +1411,12 @@ enum mlx5_qcam_feature_groups {
 #define MLX5_CAP_IPSEC(mdev, cap)\
 	MLX5_GET(ipsec_cap, (mdev)->caps.hca_cur[MLX5_CAP_IPSEC], cap)
 
+#define MLX5_CAP_DEV_NVMEOTCP(mdev, cap)\
+	MLX5_GET(nvmeotcp_cap, mdev->caps.hca_cur[MLX5_CAP_DEV_NVMEOTCP], cap)
+
+#define MLX5_CAP64_NVMEOTCP(mdev, cap)\
+	MLX5_GET64(nvmeotcp_cap, mdev->caps.hca_cur[MLX5_CAP_DEV_NVMEOTCP], cap)
+
 enum {
 	MLX5_CMD_STAT_OK			= 0x0,
 	MLX5_CMD_STAT_INT_ERR			= 0x1,
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index e32a0d61929b..f0310c24f408 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -1332,7 +1332,9 @@ struct mlx5_ifc_cmd_hca_cap_bits {
 	u8         event_cap[0x1];
 	u8         reserved_at_91[0x2];
 	u8         isolate_vl_tc_new[0x1];
-	u8         reserved_at_94[0x4];
+	u8         reserved_at_94[0x2];
+	u8         nvmeotcp[0x1];
+	u8         reserved_at_97[0x1];
 	u8         prio_tag_required[0x1];
 	u8         reserved_at_99[0x2];
 	u8         log_max_qp[0x5];
@@ -3118,6 +3120,21 @@ struct mlx5_ifc_roce_addr_layout_bits {
 	u8         reserved_at_e0[0x20];
 };
 
+struct mlx5_ifc_nvmeotcp_cap_bits {
+	u8    zerocopy[0x1];
+	u8    crc_rx[0x1];
+	u8    crc_tx[0x1];
+	u8    reserved_at_3[0x15];
+	u8    version[0x8];
+
+	u8    reserved_at_20[0x13];
+	u8    log_max_nvmeotcp_tag_buffer_table[0x5];
+	u8    reserved_at_38[0x3];
+	u8    log_max_nvmeotcp_tag_buffer_size[0x5];
+
+	u8    reserved_at_40[0x7c0];
+};
+
 union mlx5_ifc_hca_cap_union_bits {
 	struct mlx5_ifc_cmd_hca_cap_bits cmd_hca_cap;
 	struct mlx5_ifc_cmd_hca_cap_2_bits cmd_hca_cap_2;
@@ -3135,6 +3152,7 @@ union mlx5_ifc_hca_cap_union_bits {
 	struct mlx5_ifc_tls_cap_bits tls_cap;
 	struct mlx5_ifc_device_mem_cap_bits device_mem_cap;
 	struct mlx5_ifc_virtio_emulation_cap_bits virtio_emulation_cap;
+	struct mlx5_ifc_nvmeotcp_cap_bits nvmeotcp_cap;
 	u8         reserved_at_0[0x8000];
 };
 
@@ -3329,7 +3347,9 @@ struct mlx5_ifc_tirc_bits {
 
 	u8         disp_type[0x4];
 	u8         tls_en[0x1];
-	u8         reserved_at_25[0x1b];
+	u8         nvmeotcp_zero_copy_en[0x1];
+	u8         nvmeotcp_crc_en[0x1];
+	u8         reserved_at_27[0x19];
 
 	u8         reserved_at_40[0x40];
 
@@ -3360,7 +3380,8 @@ struct mlx5_ifc_tirc_bits {
 
 	struct mlx5_ifc_rx_hash_field_select_bits rx_hash_field_selector_inner;
 
-	u8         reserved_at_2c0[0x4c0];
+	u8         nvmeotcp_tag_buffer_table_id[0x20];
+	u8         reserved_at_2e0[0x4a0];
 };
 
 enum {
@@ -10976,12 +10997,14 @@ enum {
 	MLX5_HCA_CAP_GENERAL_OBJECT_TYPES_ENCRYPTION_KEY = BIT_ULL(0xc),
 	MLX5_HCA_CAP_GENERAL_OBJECT_TYPES_IPSEC = BIT_ULL(0x13),
 	MLX5_HCA_CAP_GENERAL_OBJECT_TYPES_SAMPLER = BIT_ULL(0x20),
+	MLX5_HCA_CAP_GENERAL_OBJECT_TYPES_NVMEOTCP_TAG_BUFFER_TABLE = BIT_ULL(0x21),
 };
 
 enum {
 	MLX5_GENERAL_OBJECT_TYPES_ENCRYPTION_KEY = 0xc,
 	MLX5_GENERAL_OBJECT_TYPES_IPSEC = 0x13,
 	MLX5_GENERAL_OBJECT_TYPES_SAMPLER = 0x20,
+	MLX5_GENERAL_OBJECT_TYPES_NVMEOTCP_TAG_BUFFER_TABLE = 0x21
 };
 
 enum {
@@ -11088,6 +11111,20 @@ struct mlx5_ifc_query_sampler_obj_out_bits {
 	struct mlx5_ifc_sampler_obj_bits sampler_object;
 };
 
+struct mlx5_ifc_nvmeotcp_tag_buf_table_obj_bits {
+	u8    modify_field_select[0x40];
+
+	u8    reserved_at_20[0x20];
+
+	u8    reserved_at_40[0x1b];
+	u8    log_tag_buffer_table_size[0x5];
+};
+
+struct mlx5_ifc_create_nvmeotcp_tag_buf_table_in_bits {
+	struct mlx5_ifc_general_obj_in_cmd_hdr_bits general_obj_in_cmd_hdr;
+	struct mlx5_ifc_nvmeotcp_tag_buf_table_obj_bits nvmeotcp_tag_buf_table_obj;
+};
+
 enum {
 	MLX5_GENERAL_OBJECT_TYPE_ENCRYPTION_KEY_KEY_SIZE_128 = 0x0,
 	MLX5_GENERAL_OBJECT_TYPE_ENCRYPTION_KEY_KEY_SIZE_256 = 0x1,
@@ -11098,6 +11135,18 @@ enum {
 	MLX5_GENERAL_OBJECT_TYPE_ENCRYPTION_KEY_TYPE_IPSEC = 0x2,
 };
 
+enum {
+	MLX5_TRANSPORT_STATIC_PARAMS_ACC_TYPE_XTS               = 0x0,
+	MLX5_TRANSPORT_STATIC_PARAMS_ACC_TYPE_TLS               = 0x1,
+	MLX5_TRANSPORT_STATIC_PARAMS_ACC_TYPE_NVMETCP           = 0x2,
+	MLX5_TRANSPORT_STATIC_PARAMS_ACC_TYPE_NVMETCP_WITH_TLS  = 0x3,
+};
+
+enum {
+	MLX5_TRANSPORT_STATIC_PARAMS_TI_INITIATOR  = 0x0,
+	MLX5_TRANSPORT_STATIC_PARAMS_TI_TARGET     = 0x1,
+};
+
 struct mlx5_ifc_tls_static_params_bits {
 	u8         const_2[0x2];
 	u8         tls_version[0x4];
@@ -11138,4 +11187,50 @@ enum {
 	MLX5_MTT_PERM_RW	= MLX5_MTT_PERM_READ | MLX5_MTT_PERM_WRITE,
 };
 
+struct mlx5_ifc_nvmeotcp_progress_params_bits {
+	u8    next_pdu_tcp_sn[0x20];
+
+	u8    hw_resync_tcp_sn[0x20];
+
+	u8    pdu_tracker_state[0x2];
+	u8    offloading_state[0x2];
+	u8    reserved_at_64[0xc];
+	u8    cccid_ttag[0x10];
+};
+
+struct mlx5_ifc_transport_static_params_bits {
+	u8    const_2[0x2];
+	u8    tls_version[0x4];
+	u8    const_1[0x2];
+	u8    reserved_at_8[0x14];
+	u8    acc_type[0x4];
+
+	u8    reserved_at_20[0x20];
+
+	u8    initial_record_number[0x40];
+
+	u8    resync_tcp_sn[0x20];
+
+	u8    gcm_iv[0x20];
+
+	u8    implicit_iv[0x40];
+
+	u8    reserved_at_100[0x8];
+	u8    dek_index[0x18];
+
+	u8    reserved_at_120[0x14];
+	u8    const1[0x1];
+	u8    ti[0x1];
+	u8    zero_copy_en[0x1];
+	u8    ddgst_offload_en[0x1];
+	u8    hdgst_offload_en[0x1];
+	u8    ddgst_en[0x1];
+	u8    hddgst_en[0x1];
+	u8    pda[0x5];
+
+	u8    nvme_resync_tcp_sn[0x20];
+
+	u8    reserved_at_160[0xa0];
+};
+
 #endif /* MLX5_IFC_H */
diff --git a/include/linux/mlx5/qp.h b/include/linux/mlx5/qp.h
index b7deb790f257..dfd744a564d5 100644
--- a/include/linux/mlx5/qp.h
+++ b/include/linux/mlx5/qp.h
@@ -220,6 +220,7 @@ struct mlx5_wqe_ctrl_seg {
 #define MLX5_WQE_CTRL_OPCODE_MASK 0xff
 #define MLX5_WQE_CTRL_WQE_INDEX_MASK 0x00ffff00
 #define MLX5_WQE_CTRL_WQE_INDEX_SHIFT 8
+#define MLX5_WQE_CTRL_TIR_TIS_INDEX_SHIFT 8
 
 enum {
 	MLX5_ETH_WQE_L3_INNER_CSUM      = 1 << 4,
-- 
2.24.1

