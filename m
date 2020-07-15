Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AC19220401
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 06:29:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728314AbgGOE3M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 00:29:12 -0400
Received: from mail-eopbgr80085.outbound.protection.outlook.com ([40.107.8.85]:25072
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728209AbgGOE3L (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jul 2020 00:29:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DfrZ5tRY9fq/Lp9Yy2vNHzfWHYyC8EHKVZjXbCqwTKU5yM+bQI7sRiFLtVbXFVoGgUonesPBG02I+9/0pO1ml9ITETkSzlb6CujNWM/nUtVxJWuKIdRCpgcIyVFxw+556jTabTeZ0vzMGkHfDpVCKDkZA/0tIb8IC4IWLu+/jQK12jQqANHi7Ke8H+it+NmjJJZV2t1aI+rlTZEtC3XT5riMGchUUZrpiJj+B8tc0U83FrYoDC2WO2+CH99CpBRxfAvhlbDb2G3ax8rduZRPOk4tY/ELE7t9u3Onl9CP3wNAQlaJLGIPO3SvPeHzvIo9nECrN73CKlQFLDiVBgYCRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LP3ltwnCwgIJCV24AkmlrmdEDIxRVwx4elYif4AJmxI=;
 b=aBkJyvv4ZWsEpJydAtf+9s+baRPwjSrqd6nlQN5JlBNESPt72/zwlAyR8dSR0zKJy/UB8GWfG4wfqtZvBw/3Sjr4Qn23fhdqRjYo18SJuJbkKZ7pJCIirjxi81L3+wM1XXRrrj9t3cvEpLTPZcL9XSHkBSzAt+OaKQGge37wmlgE6AyZOH3AxXQ7PP7e9E1mS4ls2r7NPs1V8OeFeDufZVBFUsHEEGyXAxGLXUD+77y0nDzBBhy57xrHU3BiHusNk+44ZxpLl0ZFzVpb3KkEWq8gXYofe9YC8VjAZTt1xx2e42Z7BL4rUQRkcdM4+MwtXlWj71XacihQwfr5yBv3Ag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LP3ltwnCwgIJCV24AkmlrmdEDIxRVwx4elYif4AJmxI=;
 b=BB3KMfhNkeIO0F/zy1mijOpXfp1lru2SrwgxJHISt8Xpawv6h1UXjqeWcvxof8L3aydCv20u42LYR+Z0zGgnbMHDs1PcioTGUtgcA/umePkZHwD3tAniZJe4Nrg1NYmDjLu9pY9+bp5n5TQw1atFoftGvh664B1aBm4mzuIhcag=
Authentication-Results: mellanox.com; dkim=none (message not signed)
 header.d=none;mellanox.com; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB6655.eurprd05.prod.outlook.com (2603:10a6:800:131::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.22; Wed, 15 Jul
 2020 04:29:03 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3174.026; Wed, 15 Jul 2020
 04:29:03 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        Eli Cohen <eli@mellanox.com>, Parav Pandit <parav@mellanox.com>
Subject: [PATCH mlx5-next 3/4] net/mlx5: Add interface changes required for VDPA
Date:   Tue, 14 Jul 2020 21:28:34 -0700
Message-Id: <20200715042835.32851-4-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200715042835.32851-1-saeedm@mellanox.com>
References: <20200715042835.32851-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR07CA0096.namprd07.prod.outlook.com
 (2603:10b6:a03:12b::37) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR07CA0096.namprd07.prod.outlook.com (2603:10b6:a03:12b::37) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.22 via Frontend Transport; Wed, 15 Jul 2020 04:29:01 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: c775b9f7-894d-42a4-7e38-08d828779a71
X-MS-TrafficTypeDiagnostic: VI1PR05MB6655:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB66554ED2E7808E51E19BCB3DBE7E0@VI1PR05MB6655.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:972;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Q8/eFjylcxlaJ3Nbsy4224a6pjrS69MnBhZDt3Unl/uDp1u6qTDwo4m+Y2n4MyrwaVjpx/UdNxttCEC2rkWIgUOhUyXmUNsxGZAsz9BzCPKv9X9inPmynhovRUlBERIrAPwKIkIzcIJYoQW1B2XyajM4kkVJJlGnRQyjDRG2b2qXKZdQOHTLOEM3vDXzYE//s7B68KnmWyh18XJEio/IUcoZ8Ev/1uc71NR/F3qBMDXZANR9GoskeEuaO7k2NGsJ+GIVrb3UeXNLcDd2gNv1PghOFRKVfvVF6dRvoUBTzqD01iLZoXgc/5qm+TE61uXJiH3vBp3KvbaUJVAv0b1SwfD7lQg8ZBnXyISeMSIh/luFteY1jmZUj8z10gzX6i2j
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(39860400002)(366004)(396003)(376002)(346002)(83380400001)(6636002)(6512007)(2906002)(107886003)(1076003)(6506007)(8936002)(6486002)(478600001)(52116002)(86362001)(110136005)(8676002)(5660300002)(6666004)(16526019)(956004)(66946007)(66476007)(316002)(36756003)(26005)(66556008)(450100002)(4326008)(54906003)(186003)(2616005)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: ddqTXHVU+kHtBg7VOYv4IOlr1RSqhWXhVtGyIm/Lp9lRj8sgHlhW5LKk/ZLyihTelgbxmeRXg8UXa5sO2V6R4ES6arJapujsDLPZ5BhKFsy9vacrACzWg+V22Nqz90/YzrWhKdPVBKjF970CiBVR4q4EWsakBl5Y6htX3o28OPJ6ZbXNU2LC38Gv1S97pbzPV5Q4d7DotiiAv2ZZqXb0hrId8ghYD0IEVvjEWsKwj3+7JfwrLiAYn1YKsG5Gs1V83HALtpkGEyLTc4nJsKGN6FA3Pndp4CTFsNjlV0NpnnRAGgzga6j0E9JGh8PCMj75t8WUvA1EL49ZPgBAU+ZmMssQYvKB0r1Box5U7xk9CN+wj+sAwaDdEu9WfQhFdIdT7CtkqOzQ9m8o0XGTfyfM+lVGmBSnUg295QGU9kB5p91y2/vRB18+/8cUq9juW48BQ48YPwpQdrOVtJWuNkCx66vtArz7hjhI6Qnc9aSTiZ0=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c775b9f7-894d-42a4-7e38-08d828779a71
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB5102.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2020 04:29:03.2802
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MizLPnETXx9u42g/RqhD7LY+iwTNsqybTYP+bLvIgtTXAZpGf/YHjgoGF4nk5kAiJ//e9BR8hp6s30rF3C7iAw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6655
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eli Cohen <eli@mellanox.com>

Rename mlx5_ifc_device_virtio_emulation_cap_bits to
mlx5_ifc_virtio_emulation_cap_bits to match names produced by the
tools producing these auto generated files.

In addition missing capabilities that will be required by VDPA
implementation.

Signed-off-by: Eli Cohen <eli@mellanox.com>
Reviewed-by: Parav Pandit <parav@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 include/linux/mlx5/device.h   |   4 +-
 include/linux/mlx5/mlx5_ifc.h | 112 +++++++++++++++++++++++++++++-----
 2 files changed, 100 insertions(+), 16 deletions(-)

diff --git a/include/linux/mlx5/device.h b/include/linux/mlx5/device.h
index 57db125e58021..2aacf9a8ee4df 100644
--- a/include/linux/mlx5/device.h
+++ b/include/linux/mlx5/device.h
@@ -1361,11 +1361,11 @@ enum mlx5_qcam_feature_groups {
 	MLX5_ADDR_OF(device_event_cap, (mdev)->caps.hca_cur[MLX5_CAP_DEV_EVENT], cap)
 
 #define MLX5_CAP_DEV_VDPA_EMULATION(mdev, cap)\
-	MLX5_GET(device_virtio_emulation_cap, \
+	MLX5_GET(virtio_emulation_cap, \
 		(mdev)->caps.hca_cur[MLX5_CAP_VDPA_EMULATION], cap)
 
 #define MLX5_CAP64_DEV_VDPA_EMULATION(mdev, cap)\
-	MLX5_GET64(device_virtio_emulation_cap, \
+	MLX5_GET64(virtio_emulation_cap, \
 		(mdev)->caps.hca_cur[MLX5_CAP_VDPA_EMULATION], cap)
 
 #define MLX5_CAP_IPSEC(mdev, cap)\
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 5890e5c9da779..435ab47d53620 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -93,6 +93,7 @@ enum {
 
 enum {
 	MLX5_OBJ_TYPE_GENEVE_TLV_OPT = 0x000b,
+	MLX5_OBJ_TYPE_VIRTIO_NET_Q = 0x000d,
 	MLX5_OBJ_TYPE_MKEY = 0xff01,
 	MLX5_OBJ_TYPE_QP = 0xff02,
 	MLX5_OBJ_TYPE_PSV = 0xff03,
@@ -981,17 +982,40 @@ struct mlx5_ifc_device_event_cap_bits {
 	u8         user_unaffiliated_events[4][0x40];
 };
 
-struct mlx5_ifc_device_virtio_emulation_cap_bits {
-	u8         reserved_at_0[0x20];
+struct mlx5_ifc_virtio_emulation_cap_bits {
+	u8         desc_tunnel_offload_type[0x1];
+	u8         eth_frame_offload_type[0x1];
+	u8         virtio_version_1_0[0x1];
+	u8         device_features_bits_mask[0xd];
+	u8         event_mode[0x8];
+	u8         virtio_queue_type[0x8];
 
-	u8         reserved_at_20[0x13];
+	u8         max_tunnel_desc[0x10];
+	u8         reserved_at_30[0x3];
 	u8         log_doorbell_stride[0x5];
 	u8         reserved_at_38[0x3];
 	u8         log_doorbell_bar_size[0x5];
 
 	u8         doorbell_bar_offset[0x40];
 
-	u8         reserved_at_80[0x780];
+	u8         max_emulated_devices[0x8];
+	u8         max_num_virtio_queues[0x18];
+
+	u8         reserved_at_a0[0x60];
+
+	u8         umem_1_buffer_param_a[0x20];
+
+	u8         umem_1_buffer_param_b[0x20];
+
+	u8         umem_2_buffer_param_a[0x20];
+
+	u8         umem_2_buffer_param_b[0x20];
+
+	u8         umem_3_buffer_param_a[0x20];
+
+	u8         umem_3_buffer_param_b[0x20];
+
+	u8         reserved_at_1c0[0x640];
 };
 
 enum {
@@ -1216,7 +1240,9 @@ struct mlx5_ifc_cmd_hca_cap_bits {
 
 	u8         max_sgl_for_optimized_performance[0x8];
 	u8         log_max_cq_sz[0x8];
-	u8         reserved_at_d0[0xb];
+	u8         reserved_at_d0[0x9];
+	u8         virtio_net_device_emualtion_manager[0x1];
+	u8         virtio_blk_device_emualtion_manager[0x1];
 	u8         log_max_cq[0x5];
 
 	u8         log_max_eq_sz[0x8];
@@ -2952,7 +2978,7 @@ union mlx5_ifc_hca_cap_union_bits {
 	struct mlx5_ifc_fpga_cap_bits fpga_cap;
 	struct mlx5_ifc_tls_cap_bits tls_cap;
 	struct mlx5_ifc_device_mem_cap_bits device_mem_cap;
-	struct mlx5_ifc_device_virtio_emulation_cap_bits virtio_emulation_cap;
+	struct mlx5_ifc_virtio_emulation_cap_bits virtio_emulation_cap;
 	u8         reserved_at_0[0x8000];
 };
 
@@ -3298,15 +3324,18 @@ struct mlx5_ifc_scheduling_context_bits {
 };
 
 struct mlx5_ifc_rqtc_bits {
-	u8         reserved_at_0[0xa0];
+	u8    reserved_at_0[0xa0];
 
-	u8         reserved_at_a0[0x10];
-	u8         rqt_max_size[0x10];
+	u8    reserved_at_a0[0x5];
+	u8    list_q_type[0x3];
+	u8    reserved_at_a8[0x8];
+	u8    rqt_max_size[0x10];
 
-	u8         reserved_at_c0[0x10];
-	u8         rqt_actual_size[0x10];
+	u8    rq_vhca_id_format[0x1];
+	u8    reserved_at_c1[0xf];
+	u8    rqt_actual_size[0x10];
 
-	u8         reserved_at_e0[0x6a0];
+	u8    reserved_at_e0[0x6a0];
 
 	struct mlx5_ifc_rq_num_bits rq_num[];
 };
@@ -7084,7 +7113,7 @@ struct mlx5_ifc_destroy_mkey_out_bits {
 
 struct mlx5_ifc_destroy_mkey_in_bits {
 	u8         opcode[0x10];
-	u8         reserved_at_10[0x10];
+	u8         uid[0x10];
 
 	u8         reserved_at_20[0x10];
 	u8         op_mod[0x10];
@@ -7782,7 +7811,7 @@ struct mlx5_ifc_create_mkey_out_bits {
 
 struct mlx5_ifc_create_mkey_in_bits {
 	u8         opcode[0x10];
-	u8         reserved_at_10[0x10];
+	u8         uid[0x10];
 
 	u8         reserved_at_20[0x10];
 	u8         op_mod[0x10];
@@ -10312,6 +10341,40 @@ struct mlx5_ifc_create_umem_in_bits {
 	struct mlx5_ifc_umem_bits  umem;
 };
 
+struct mlx5_ifc_create_umem_out_bits {
+	u8         status[0x8];
+	u8         reserved_at_8[0x18];
+
+	u8         syndrome[0x20];
+
+	u8         reserved_at_40[0x8];
+	u8         umem_id[0x18];
+
+	u8         reserved_at_60[0x20];
+};
+
+struct mlx5_ifc_destroy_umem_in_bits {
+	u8        opcode[0x10];
+	u8        uid[0x10];
+
+	u8        reserved_at_20[0x10];
+	u8        op_mod[0x10];
+
+	u8        reserved_at_40[0x8];
+	u8        umem_id[0x18];
+
+	u8        reserved_at_60[0x20];
+};
+
+struct mlx5_ifc_destroy_umem_out_bits {
+	u8        status[0x8];
+	u8        reserved_at_8[0x18];
+
+	u8        syndrome[0x20];
+
+	u8        reserved_at_40[0x40];
+};
+
 struct mlx5_ifc_create_uctx_in_bits {
 	u8         opcode[0x10];
 	u8         reserved_at_10[0x10];
@@ -10324,6 +10387,18 @@ struct mlx5_ifc_create_uctx_in_bits {
 	struct mlx5_ifc_uctx_bits  uctx;
 };
 
+struct mlx5_ifc_create_uctx_out_bits {
+	u8         status[0x8];
+	u8         reserved_at_8[0x18];
+
+	u8         syndrome[0x20];
+
+	u8         reserved_at_40[0x10];
+	u8         uid[0x10];
+
+	u8         reserved_at_60[0x20];
+};
+
 struct mlx5_ifc_destroy_uctx_in_bits {
 	u8         opcode[0x10];
 	u8         reserved_at_10[0x10];
@@ -10337,6 +10412,15 @@ struct mlx5_ifc_destroy_uctx_in_bits {
 	u8         reserved_at_60[0x20];
 };
 
+struct mlx5_ifc_destroy_uctx_out_bits {
+	u8         status[0x8];
+	u8         reserved_at_8[0x18];
+
+	u8         syndrome[0x20];
+
+	u8          reserved_at_40[0x40];
+};
+
 struct mlx5_ifc_create_sw_icm_in_bits {
 	struct mlx5_ifc_general_obj_in_cmd_hdr_bits   hdr;
 	struct mlx5_ifc_sw_icm_bits		      sw_icm;
-- 
2.26.2

