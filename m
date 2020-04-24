Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 477C81B7F3F
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 21:46:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729320AbgDXTp5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 15:45:57 -0400
Received: from mail-eopbgr70047.outbound.protection.outlook.com ([40.107.7.47]:44128
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729280AbgDXTp5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Apr 2020 15:45:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NIxBew0zoh6enU9CjQPQQ1pWUfz4FyZBLK3l2OBFLNQ9iZjESKwIJ3eRnmhPqK7zU/iDzTrmPPCOPRHUtDIHx9oIzoXyV0KpKUDzOGbPBnUiBtkEvFiPW0qgua2gPSuV3Rq1HEwZXXwMnKnEutRvNJglS4FH2eSsI+tqP3rtgfcgm0B3wTjhEdhu7Doz+F12fWAxsM7QL/FgcIeQcrdm9SX9ZS13XQt045sIma/qOMAG558T8R30b/bwSF3uehDCONPgSCxt1OY2+Z+oRSXhEYirzn43jh2hgtEKrPLAZfXbYNRRNPSidMlw+q4XjlO+aANgTL7XbYnkKXd5bSwqoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m0cH4XQk4iwRnZUkS/ep2nOAZmRlqtcPjC9Bk9ZJKxA=;
 b=Qv4fqw34SbNyEp1/sONiBiY40VqAjTXyUjIRGBQcx5/FiHy/q9r0yCy7H+YYWJLegI8HUUd484TW14He/XQxoYGTiqP8yU94KCwRZfKmt2I0ULpVuOqWgtPHWw/RHNycrzANqj3i/LIwJeqiwXp4GO/C74oWeVerD6XOQe2UY7kybYz80xbO4W3UZiNu6BKe8Dh7OLXI3lBuZgsA1kDAKPlLDTFwe/gXAWROmOfxnLsqOvkCJShDsVpr8PX1Zy0Phkuihtw9BxaiDWyL3QqV4kixxfo8u0kZ634HJOclH+I5djN4f++TomWA9wfJXFVosTemp0D27b9cnjM1atu51w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m0cH4XQk4iwRnZUkS/ep2nOAZmRlqtcPjC9Bk9ZJKxA=;
 b=F2lzBWqECqMokv6VoCnFnpZo4xRyCZmKLODaiTy8M9cej5arxn2WUFJjRZYojOeWRIFZCZBF63VPVdcAhHycwNqLaXPDHF7yyUNAfYi27iop5e/xikznWiSQ+G7oyX/YSRomWrSGOwqFzL2zwUTmDHphT2Kfqq+dLZb8TyruvGk=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB5072.eurprd05.prod.outlook.com (2603:10a6:803:61::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.29; Fri, 24 Apr
 2020 19:45:46 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19%7]) with mapi id 15.20.2937.020; Fri, 24 Apr 2020
 19:45:46 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        Raed Salem <raeds@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>
Subject: [PATCH mlx5-next 2/9] net/mlx5: Introduce IPsec Connect-X offload hardware bits and structures
Date:   Fri, 24 Apr 2020 12:45:03 -0700
Message-Id: <20200424194510.11221-3-saeedm@mellanox.com>
X-Mailer: git-send-email 2.25.3
In-Reply-To: <20200424194510.11221-1-saeedm@mellanox.com>
References: <20200424194510.11221-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR06CA0016.namprd06.prod.outlook.com
 (2603:10b6:a03:d4::29) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR06CA0016.namprd06.prod.outlook.com (2603:10b6:a03:d4::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13 via Frontend Transport; Fri, 24 Apr 2020 19:45:35 +0000
X-Mailer: git-send-email 2.25.3
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: c86110e8-b952-41fe-823d-08d7e8880fa4
X-MS-TrafficTypeDiagnostic: VI1PR05MB5072:|VI1PR05MB5072:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB5072A8D744BD6F65789B82E8BED00@VI1PR05MB5072.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:741;
X-Forefront-PRVS: 03838E948C
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(39860400002)(136003)(396003)(376002)(366004)(346002)(6506007)(26005)(2616005)(8936002)(8676002)(316002)(6636002)(36756003)(6666004)(66946007)(66556008)(52116002)(81156014)(478600001)(107886003)(66476007)(6512007)(956004)(5660300002)(110136005)(4326008)(1076003)(54906003)(16526019)(186003)(2906002)(6486002)(86362001)(450100002)(54420400002);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Xf92jTQ4oFyfM/RtLIjJPiH875IuW6wpvsMeRyQwecgvB+DYKIN6+tVNIxZeRSVVGNoHSdl1Xjoo80TfvP4f4gRfitko/VzRJ/lFa4lB8Ls8nbmCFE8f41Zwwffj1TsgmP0AeuNFG9hYv2c8SfbPjfai6URWUrzwRslXKczefay5binDStOIJO2JP9SCiG/vzx3Pbp1ZefIWv6yxcBUrDKZSenItRts+o9GyA81NUpcfrwwgR3rDBh0zsdmI4StpC4qpUNxrgdsTYyTVCgIHHM3ZNaYmfNsOUj+H7Ys62tkV+2FnyL0esQ4RRKlW9mr9ZIO6w+mQrvDjg5mkJQVtiVLS8tiOn3CLHMn5vlZybkaDhyY6+TesA8/NwwOUn5XtLAVwCqnKzOL5jxBhgUx3tPgnednkqRJUR6SDbsAHKD62RxCwuoedI8W9GKIWji6q0WrsepP9Ex1XE5cpUtVjMhA03pGEoojhRHNOCQN6TY6nNc60sOqUBkuPcJn2eZnp
X-MS-Exchange-AntiSpam-MessageData: wmRDm3hsRgEvmFp8kq6nR0FIBXdwObKG7bjNTrDn9rsnr6VWkLVIvq7YjxERzjyRXU1otU3NhPIRl82IO+CKFBnlUHQ0kuvk3odiYSrbaPNE9WJpzzIFl4ktBDVO8xzQWUi98BwcHpaIeQBBYE45ag==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c86110e8-b952-41fe-823d-08d7e8880fa4
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2020 19:45:37.3559
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iy72ctykHj5sysmsEtMResGHGNUHuYfTskjS3/+qwe7tjLrVNaYMvT472pByxGdI9nZ+QZFSVD0Cqn2XL5t09g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5072
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Raed Salem <raeds@mellanox.com>

Add IPsec offload related IFC structs, layouts and enumerations.

Signed-off-by: Raed Salem <raeds@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 include/linux/mlx5/device.h   |  4 ++
 include/linux/mlx5/mlx5_ifc.h | 78 +++++++++++++++++++++++++++++++++--
 2 files changed, 79 insertions(+), 3 deletions(-)

diff --git a/include/linux/mlx5/device.h b/include/linux/mlx5/device.h
index 2b90097a6cf9..7b57877e501e 100644
--- a/include/linux/mlx5/device.h
+++ b/include/linux/mlx5/device.h
@@ -1107,6 +1107,7 @@ enum mlx5_cap_type {
 	MLX5_CAP_TLS,
 	MLX5_CAP_VDPA_EMULATION = 0x13,
 	MLX5_CAP_DEV_EVENT = 0x14,
+	MLX5_CAP_IPSEC,
 	/* NUM OF CAP Types */
 	MLX5_CAP_NUM
 };
@@ -1324,6 +1325,9 @@ enum mlx5_qcam_feature_groups {
 	MLX5_GET64(device_virtio_emulation_cap, \
 		(mdev)->caps.hca_cur[MLX5_CAP_VDPA_EMULATION], cap)
 
+#define MLX5_CAP_IPSEC(mdev, cap)\
+	MLX5_GET(ipsec_cap, (mdev)->caps.hca_cur[MLX5_CAP_IPSEC], cap)
+
 enum {
 	MLX5_CMD_STAT_OK			= 0x0,
 	MLX5_CMD_STAT_INT_ERR			= 0x1,
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 3ad2c51ccde9..cf971d341189 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -886,7 +886,8 @@ struct mlx5_ifc_per_protocol_networking_offload_caps_bits {
 	u8         tunnel_stateless_vxlan_gpe[0x1];
 	u8         tunnel_stateless_ipv4_over_vxlan[0x1];
 	u8         tunnel_stateless_ip_over_ip[0x1];
-	u8         reserved_at_2a[0x6];
+	u8         insert_trailer[0x1];
+	u8         reserved_at_2b[0x5];
 	u8         max_vxlan_udp_ports[0x8];
 	u8         reserved_at_38[0x6];
 	u8         max_geneve_opt_len[0x1];
@@ -1100,6 +1101,23 @@ struct mlx5_ifc_tls_cap_bits {
 	u8         reserved_at_20[0x7e0];
 };
 
+struct mlx5_ifc_ipsec_cap_bits {
+	u8         ipsec_full_offload[0x1];
+	u8         ipsec_crypto_offload[0x1];
+	u8         ipsec_esn[0x1];
+	u8         ipsec_crypto_esp_aes_gcm_256_encrypt[0x1];
+	u8         ipsec_crypto_esp_aes_gcm_128_encrypt[0x1];
+	u8         ipsec_crypto_esp_aes_gcm_256_decrypt[0x1];
+	u8         ipsec_crypto_esp_aes_gcm_128_decrypt[0x1];
+	u8         reserved_at_7[0x4];
+	u8         log_max_ipsec_offload[0x5];
+	u8         reserved_at_10[0x10];
+
+	u8         min_log_ipsec_full_replay_window[0x8];
+	u8         max_log_ipsec_full_replay_window[0x8];
+	u8         reserved_at_30[0x7d0];
+};
+
 enum {
 	MLX5_WQ_TYPE_LINKED_LIST  = 0x0,
 	MLX5_WQ_TYPE_CYCLIC       = 0x1,
@@ -1464,7 +1482,8 @@ struct mlx5_ifc_cmd_hca_cap_bits {
 
 	u8         reserved_at_460[0x3];
 	u8         log_max_uctx[0x5];
-	u8         reserved_at_468[0x3];
+	u8         reserved_at_468[0x2];
+	u8         ipsec_offload[0x1];
 	u8         log_max_umem[0x5];
 	u8         max_num_eqs[0x10];
 
@@ -4143,7 +4162,8 @@ enum {
 	MLX5_SET_FTE_MODIFY_ENABLE_MASK_ACTION    = 0x0,
 	MLX5_SET_FTE_MODIFY_ENABLE_MASK_FLOW_TAG  = 0x1,
 	MLX5_SET_FTE_MODIFY_ENABLE_MASK_DESTINATION_LIST    = 0x2,
-	MLX5_SET_FTE_MODIFY_ENABLE_MASK_FLOW_COUNTERS    = 0x3
+	MLX5_SET_FTE_MODIFY_ENABLE_MASK_FLOW_COUNTERS    = 0x3,
+	MLX5_SET_FTE_MODIFY_ENABLE_MASK_IPSEC_OBJ_ID    = 0x4
 };
 
 struct mlx5_ifc_set_fte_out_bits {
@@ -10468,10 +10488,62 @@ struct mlx5_ifc_affiliated_event_header_bits {
 
 enum {
 	MLX5_HCA_CAP_GENERAL_OBJECT_TYPES_ENCRYPTION_KEY = BIT(0xc),
+	MLX5_HCA_CAP_GENERAL_OBJECT_TYPES_IPSEC = BIT(0x13),
 };
 
 enum {
 	MLX5_GENERAL_OBJECT_TYPES_ENCRYPTION_KEY = 0xc,
+	MLX5_GENERAL_OBJECT_TYPES_IPSEC = 0x13,
+};
+
+enum {
+	MLX5_IPSEC_OBJECT_ICV_LEN_16B,
+	MLX5_IPSEC_OBJECT_ICV_LEN_12B,
+	MLX5_IPSEC_OBJECT_ICV_LEN_8B,
+};
+
+struct mlx5_ifc_ipsec_obj_bits {
+	u8         modify_field_select[0x40];
+	u8         full_offload[0x1];
+	u8         reserved_at_41[0x1];
+	u8         esn_en[0x1];
+	u8         esn_overlap[0x1];
+	u8         reserved_at_44[0x2];
+	u8         icv_length[0x2];
+	u8         reserved_at_48[0x4];
+	u8         aso_return_reg[0x4];
+	u8         reserved_at_50[0x10];
+
+	u8         esn_msb[0x20];
+
+	u8         reserved_at_80[0x8];
+	u8         dekn[0x18];
+
+	u8         salt[0x20];
+
+	u8         implicit_iv[0x40];
+
+	u8         reserved_at_100[0x700];
+};
+
+struct mlx5_ifc_create_ipsec_obj_in_bits {
+	struct mlx5_ifc_general_obj_in_cmd_hdr_bits general_obj_in_cmd_hdr;
+	struct mlx5_ifc_ipsec_obj_bits ipsec_object;
+};
+
+enum {
+	MLX5_MODIFY_IPSEC_BITMASK_ESN_OVERLAP = BIT(0),
+	MLX5_MODIFY_IPSEC_BITMASK_ESN_MSB = BIT(1),
+};
+
+struct mlx5_ifc_query_ipsec_obj_out_bits {
+	struct mlx5_ifc_general_obj_out_cmd_hdr_bits general_obj_out_cmd_hdr;
+	struct mlx5_ifc_ipsec_obj_bits ipsec_object;
+};
+
+struct mlx5_ifc_modify_ipsec_obj_in_bits {
+	struct mlx5_ifc_general_obj_in_cmd_hdr_bits general_obj_in_cmd_hdr;
+	struct mlx5_ifc_ipsec_obj_bits ipsec_object;
 };
 
 struct mlx5_ifc_encryption_key_obj_bits {
-- 
2.25.3

