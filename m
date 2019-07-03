Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B0DC5DF0B
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 09:39:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727315AbfGCHjl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 03:39:41 -0400
Received: from mail-eopbgr00088.outbound.protection.outlook.com ([40.107.0.88]:30325
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726764AbfGCHjk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Jul 2019 03:39:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z7fx276J1NDELLaOTz6AWG+YtcvhFnlNYBB3UxUk6tA=;
 b=B5fg5Sv4V0Sd2te3XLmhh0YOmrPfKIfesckZYBrfo7KoAzuBtPaKNdR6v6URa3V4eWOnjV1C9kgBvDOA0qv737qP0ninYdrhoHKdt5x//y87ko/4ec3Cl6CXq3E1EC2yCWQp4WMJQjg80ZaHLAvGLln7SoulsjWLnCRJMD4Ju9M=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2309.eurprd05.prod.outlook.com (10.168.55.138) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2032.20; Wed, 3 Jul 2019 07:39:32 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::c1b3:b3a8:bced:493c]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::c1b3:b3a8:bced:493c%4]) with mapi id 15.20.2032.019; Wed, 3 Jul 2019
 07:39:32 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>
Subject: [PATCH mlx5-next 4/5] net/mlx5: Introduce TLS TX offload hardware
 bits and structures
Thread-Topic: [PATCH mlx5-next 4/5] net/mlx5: Introduce TLS TX offload
 hardware bits and structures
Thread-Index: AQHVMXJ0R4Qy/8TrKUie2vzu8va3aQ==
Date:   Wed, 3 Jul 2019 07:39:32 +0000
Message-ID: <20190703073909.14965-5-saeedm@mellanox.com>
References: <20190703073909.14965-1-saeedm@mellanox.com>
In-Reply-To: <20190703073909.14965-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [73.15.39.150]
x-clientproxiedby: BYAPR02CA0046.namprd02.prod.outlook.com
 (2603:10b6:a03:54::23) To DB6PR0501MB2759.eurprd05.prod.outlook.com
 (2603:10a6:4:84::7)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8444a832-8fa4-4f8c-f88a-08d6ff899666
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2309;
x-ms-traffictypediagnostic: DB6PR0501MB2309:
x-microsoft-antispam-prvs: <DB6PR0501MB23095AED581E84A6F20392AEBEFB0@DB6PR0501MB2309.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:741;
x-forefront-prvs: 00872B689F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(366004)(376002)(39860400002)(396003)(346002)(199004)(189003)(66556008)(66946007)(66446008)(6512007)(64756008)(73956011)(66476007)(107886003)(5660300002)(1076003)(52116002)(54906003)(71200400001)(2906002)(66066001)(256004)(99286004)(76176011)(3846002)(7736002)(6116002)(53936002)(6436002)(71190400001)(4326008)(6486002)(68736007)(81156014)(110136005)(305945005)(26005)(36756003)(316002)(2616005)(50226002)(8676002)(478600001)(476003)(8936002)(25786009)(86362001)(486006)(450100002)(386003)(6506007)(81166006)(186003)(11346002)(446003)(14454004)(6636002)(102836004);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2309;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: G2zmvYahFd00sGA/qHqJG8xfQ6nops8/ZVXi3KX+lhnBvILrK3fePTYejsPeSqbfwvs9dx4vNB6hDzt7VMLV1ep0+w12Htt0QfQUH5vJV4lb3kcTZxM49I8M6Q6rwgiuvEoBaJDyRI4ouG2j4X/e0D5gHOTYIMbilqmBmHSRZBVrD547cTI/VIffTVUJlZaGzkVl/KvridRj7gqj+aeFwW6OwqYMfVeiIgRFPPyfrp6HEB7dfxaJJaR8FkpShbIKUIKq0PYaCAaCor0Lrvs8STyWHnzByLtURp8fPK6foeW9BHyO4yfPMGL+9hKs2mi85HD/RYkaOaUxA6U8AUHJI9x47hrZCchCPgIlr9SGEBGdCRsUcmHfD5Qi2NBy/mfCirkkuFMFxffpY/14Gp+3JIfOupT1JBxoQ+J0gjksies=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8444a832-8fa4-4f8c-f88a-08d6ff899666
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jul 2019 07:39:32.2480
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2309
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eran Ben Elisha <eranbe@mellanox.com>

Add TLS offload related IFC structs, layouts and enumerations.

Signed-off-by: Eran Ben Elisha <eranbe@mellanox.com>
Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 include/linux/mlx5/device.h   |  14 +++++
 include/linux/mlx5/mlx5_ifc.h | 104 ++++++++++++++++++++++++++++++++--
 2 files changed, 114 insertions(+), 4 deletions(-)

diff --git a/include/linux/mlx5/device.h b/include/linux/mlx5/device.h
index 5e760067ac41..5f7d1671ad5a 100644
--- a/include/linux/mlx5/device.h
+++ b/include/linux/mlx5/device.h
@@ -437,6 +437,7 @@ enum {
 	MLX5_OPCODE_SET_PSV		=3D 0x20,
 	MLX5_OPCODE_GET_PSV		=3D 0x21,
 	MLX5_OPCODE_CHECK_PSV		=3D 0x22,
+	MLX5_OPCODE_DUMP		=3D 0x23,
 	MLX5_OPCODE_RGET_PSV		=3D 0x26,
 	MLX5_OPCODE_RCHECK_PSV		=3D 0x27,
=20
@@ -444,6 +445,14 @@ enum {
=20
 };
=20
+enum {
+	MLX5_OPC_MOD_TLS_TIS_STATIC_PARAMS =3D 0x20,
+};
+
+enum {
+	MLX5_OPC_MOD_TLS_TIS_PROGRESS_PARAMS =3D 0x20,
+};
+
 enum {
 	MLX5_SET_PORT_RESET_QKEY	=3D 0,
 	MLX5_SET_PORT_GUID0		=3D 16,
@@ -1077,6 +1086,8 @@ enum mlx5_cap_type {
 	MLX5_CAP_DEBUG,
 	MLX5_CAP_RESERVED_14,
 	MLX5_CAP_DEV_MEM,
+	MLX5_CAP_RESERVED_16,
+	MLX5_CAP_TLS,
 	/* NUM OF CAP Types */
 	MLX5_CAP_NUM
 };
@@ -1255,6 +1266,9 @@ enum mlx5_qcam_feature_groups {
 #define MLX5_CAP64_DEV_MEM(mdev, cap)\
 	MLX5_GET64(device_mem_cap, mdev->caps.hca_cur[MLX5_CAP_DEV_MEM], cap)
=20
+#define MLX5_CAP_TLS(mdev, cap) \
+	MLX5_GET(tls_cap, (mdev)->caps.hca_cur[MLX5_CAP_TLS], cap)
+
 enum {
 	MLX5_CMD_STAT_OK			=3D 0x0,
 	MLX5_CMD_STAT_INT_ERR			=3D 0x1,
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 031db53e94ce..1f77ae1ed250 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -953,6 +953,16 @@ struct mlx5_ifc_vector_calc_cap_bits {
 	u8         reserved_at_c0[0x720];
 };
=20
+struct mlx5_ifc_tls_cap_bits {
+	u8         tls_1_2_aes_gcm_128[0x1];
+	u8         tls_1_3_aes_gcm_128[0x1];
+	u8         tls_1_2_aes_gcm_256[0x1];
+	u8         tls_1_3_aes_gcm_256[0x1];
+	u8         reserved_at_4[0x1c];
+
+	u8         reserved_at_20[0x7e0];
+};
+
 enum {
 	MLX5_WQ_TYPE_LINKED_LIST  =3D 0x0,
 	MLX5_WQ_TYPE_CYCLIC       =3D 0x1,
@@ -1282,7 +1292,8 @@ struct mlx5_ifc_cmd_hca_cap_bits {
=20
 	u8         reserved_at_440[0x20];
=20
-	u8         reserved_at_460[0x3];
+	u8         tls[0x1];
+	u8         reserved_at_461[0x2];
 	u8         log_max_uctx[0x5];
 	u8         reserved_at_468[0x3];
 	u8         log_max_umem[0x5];
@@ -1307,7 +1318,9 @@ struct mlx5_ifc_cmd_hca_cap_bits {
 	u8         max_geneve_tlv_option_data_len[0x5];
 	u8         reserved_at_570[0x10];
=20
-	u8         reserved_at_580[0x3c];
+	u8         reserved_at_580[0x33];
+	u8         log_max_dek[0x5];
+	u8         reserved_at_5b8[0x4];
 	u8         mini_cqe_resp_stride_index[0x1];
 	u8         cqe_128_always[0x1];
 	u8         cqe_compression_128[0x1];
@@ -2586,6 +2599,7 @@ union mlx5_ifc_hca_cap_union_bits {
 	struct mlx5_ifc_qos_cap_bits qos_cap;
 	struct mlx5_ifc_debug_cap_bits debug_cap;
 	struct mlx5_ifc_fpga_cap_bits fpga_cap;
+	struct mlx5_ifc_tls_cap_bits tls_cap;
 	u8         reserved_at_0[0x8000];
 };
=20
@@ -2725,7 +2739,8 @@ struct mlx5_ifc_traffic_counter_bits {
=20
 struct mlx5_ifc_tisc_bits {
 	u8         strict_lag_tx_port_affinity[0x1];
-	u8         reserved_at_1[0x3];
+	u8         tls_en[0x1];
+	u8         reserved_at_1[0x2];
 	u8         lag_tx_port_affinity[0x04];
=20
 	u8         reserved_at_8[0x4];
@@ -2739,7 +2754,11 @@ struct mlx5_ifc_tisc_bits {
=20
 	u8         reserved_at_140[0x8];
 	u8         underlay_qpn[0x18];
-	u8         reserved_at_160[0x3a0];
+
+	u8         reserved_at_160[0x8];
+	u8         pd[0x18];
+
+	u8         reserved_at_180[0x380];
 };
=20
 enum {
@@ -9937,4 +9956,81 @@ struct mlx5_ifc_alloc_sf_in_bits {
 	u8         reserved_at_60[0x20];
 };
=20
+enum {
+	MLX5_HCA_CAP_GENERAL_OBJECT_TYPES_ENCRYPTION_KEY =3D BIT(0xc),
+};
+
+enum {
+	MLX5_GENERAL_OBJECT_TYPES_ENCRYPTION_KEY =3D 0xc,
+};
+
+struct mlx5_ifc_encryption_key_obj_bits {
+	u8         modify_field_select[0x40];
+
+	u8         reserved_at_40[0x14];
+	u8         key_size[0x4];
+	u8         reserved_at_58[0x4];
+	u8         key_type[0x4];
+
+	u8         reserved_at_60[0x8];
+	u8         pd[0x18];
+
+	u8         reserved_at_80[0x180];
+	u8         key[8][0x20];
+
+	u8         reserved_at_300[0x500];
+};
+
+struct mlx5_ifc_create_encryption_key_in_bits {
+	struct mlx5_ifc_general_obj_in_cmd_hdr_bits general_obj_in_cmd_hdr;
+	struct mlx5_ifc_encryption_key_obj_bits encryption_key_object;
+};
+
+enum {
+	MLX5_GENERAL_OBJECT_TYPE_ENCRYPTION_KEY_KEY_SIZE_128 =3D 0x0,
+	MLX5_GENERAL_OBJECT_TYPE_ENCRYPTION_KEY_KEY_SIZE_256 =3D 0x1,
+};
+
+enum {
+	MLX5_GENERAL_OBJECT_TYPE_ENCRYPTION_KEY_TYPE_DEK =3D 0x1,
+};
+
+struct mlx5_ifc_tls_static_params_bits {
+	u8         const_2[0x2];
+	u8         tls_version[0x4];
+	u8         const_1[0x2];
+	u8         reserved_at_8[0x14];
+	u8         encryption_standard[0x4];
+
+	u8         reserved_at_20[0x20];
+
+	u8         initial_record_number[0x40];
+
+	u8         resync_tcp_sn[0x20];
+
+	u8         gcm_iv[0x20];
+
+	u8         implicit_iv[0x40];
+
+	u8         reserved_at_100[0x8];
+	u8         dek_index[0x18];
+
+	u8         reserved_at_120[0xe0];
+};
+
+struct mlx5_ifc_tls_progress_params_bits {
+	u8         valid[0x1];
+	u8         reserved_at_1[0x7];
+	u8         pd[0x18];
+
+	u8         next_record_tcp_sn[0x20];
+
+	u8         hw_resync_tcp_sn[0x20];
+
+	u8         record_tracker_state[0x2];
+	u8         auth_state[0x2];
+	u8         reserved_at_64[0x4];
+	u8         hw_offset_record_number[0x18];
+};
+
 #endif /* MLX5_IFC_H */
--=20
2.21.0

