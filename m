Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2AF80A2B18
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 01:42:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727176AbfH2Xmj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 19:42:39 -0400
Received: from mail-eopbgr150089.outbound.protection.outlook.com ([40.107.15.89]:7907
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725826AbfH2Xmi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Aug 2019 19:42:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OiA3hJvx/BcHcylBuT9vElZ6HkPPJZgjzkuxS8xLtEM1sdct00GfH/Y/oAiu5U2SAog5RNxBjQNqZoBtgOBdE0xojYjl0VfbwbEgnvwOTklkxcQR39tuuVc7Faxh1vXQkErQIjesFXXPwG7TsnPk1PVxLUBFd7jNSfq9+U6TzbGXQoHeN5oBUll7t0ETZzzI9rrQA8z0FEebL9pDqk0sx2NvOCgXqhTb0oykpAVYjp0GK6tVql3kRGGdLJ6lrXXcW4Bq3XexwwxfIw8w/Oz5xlF7/IQJxkQpsi21G19r9IWBj6noS1KlFyv5sktpc0FCLUqjI5tKpwL/MvRYEljuHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xOe7f6UuUnQk9NrLtg7+of+WFxXIZzxQbtaZXdZe1cg=;
 b=kX49he8kLGpt94080LW15ss002+LBceSHm78QcuudH8+lQWFITrEe5imMDpIAhea/aZ97bMYp2FIiAP6gbwjKr5kgRxVZ5s3ClzrlfzuUIlH2fP3w+xtwJM1/qp79OjdhPPScMHcAcTTFue+NaOrZMZKxUjmVcPkU51Tde7IAGa4aLCmrGRiJLHh0mI2S/hZfNSJfDfZh0lxITe8UKwW4fcjewnvekgFwiLmvoBa4fbvInm4wB1/s0aA8YANCvgfruimLhIhc9Be5FEDTBx+rjyXD4ou0IHi5qcPJ0HNwbKyvuv6iYBIFCHOFe4J/lu8HHKLLzKG+RSrFsdWBf5y+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xOe7f6UuUnQk9NrLtg7+of+WFxXIZzxQbtaZXdZe1cg=;
 b=XtjfkCdiy9YNABLi+gJWZEGnMmUJtVycGZ0N9OxONg2rnTinJnsyrBslqDk+lq9SZRbC7ySwFE7qUZYuIdffkQWrJENkJlPtWDdMYNQkmZaOQMDlI3r0V4AMw007pso8Koj8boP/PArrP+uW9RAb6K7+R38h9VvnXFu8Tmdqm58=
Received: from VI1PR0501MB2765.eurprd05.prod.outlook.com (10.172.11.140) by
 VI1PR0501MB2333.eurprd05.prod.outlook.com (10.169.135.147) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2199.21; Thu, 29 Aug 2019 23:42:33 +0000
Received: from VI1PR0501MB2765.eurprd05.prod.outlook.com
 ([fe80::5cab:4f5c:d7ed:5e27]) by VI1PR0501MB2765.eurprd05.prod.outlook.com
 ([fe80::5cab:4f5c:d7ed:5e27%6]) with mapi id 15.20.2199.021; Thu, 29 Aug 2019
 23:42:32 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Alex Vesker <valex@mellanox.com>,
        Yevgeny Klitenik <kliten@mellanox.com>,
        Mark Bloch <markb@mellanox.com>
Subject: [PATCH mlx5-next 2/5] net/mlx5: Add HW bits and definitions required
 for SW steering
Thread-Topic: [PATCH mlx5-next 2/5] net/mlx5: Add HW bits and definitions
 required for SW steering
Thread-Index: AQHVXsNt3p63TycggUKhehn6n8yYCQ==
Date:   Thu, 29 Aug 2019 23:42:32 +0000
Message-ID: <20190829234151.9958-3-saeedm@mellanox.com>
References: <20190829234151.9958-1-saeedm@mellanox.com>
In-Reply-To: <20190829234151.9958-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BY5PR04CA0018.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::28) To VI1PR0501MB2765.eurprd05.prod.outlook.com
 (2603:10a6:800:9a::12)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6202441f-e683-40b7-7ab1-08d72cda8fe3
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR0501MB2333;
x-ms-traffictypediagnostic: VI1PR0501MB2333:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0501MB23333CF276C6D9C932ACE139BEA20@VI1PR0501MB2333.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 0144B30E41
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(346002)(396003)(136003)(39860400002)(376002)(199004)(189003)(476003)(486006)(450100002)(4326008)(478600001)(2906002)(81156014)(6636002)(110136005)(71200400001)(36756003)(54906003)(71190400001)(305945005)(11346002)(446003)(8676002)(81166006)(7736002)(14444005)(8936002)(5660300002)(50226002)(256004)(2616005)(64756008)(66446008)(186003)(66946007)(14454004)(6116002)(3846002)(316002)(1076003)(6512007)(6486002)(53936002)(6506007)(76176011)(107886003)(102836004)(6436002)(386003)(25786009)(99286004)(52116002)(86362001)(26005)(66066001)(66556008)(66476007);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0501MB2333;H:VI1PR0501MB2765.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: LAYdPzDautmeHz05xIjRkEwfDEsp12Q2PdkKm4Z9VuHlS8OqKgktUPShAXze+6a8E7DjfleFS1SaLkPDmU3oJOKqvZBgl2qVsBuOeLnxRKaf1nSfeRTfL6CbEI6mjf93yyLwyKrqHWlcLtch9d1vwfQtvD4mHmlfzOSPCFq1Wf6dCZaQIQWJcXMLSGlMEs/vqhaqYKG/Sw4CidEWPUBUn7A8rZvRYlT95hnaFQrUkU9J58/3NTcgsNRQyCeG7pp3ShaVHaHc4dx/08VCcc81VM6PEpQp6Nq2cbf3M6xxsyRey61Ckzpo17aN6J1kMHm+/RZrR3c8s1uLZr/TKC82pgMim5HZB2Mx0+aIKuP7LyNHia9DbBN+dVID92/0spW+QWW/gJgNLFtFt5qBwCt+74jG0ZrfeRx/PgKPArb0PsE=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6202441f-e683-40b7-7ab1-08d72cda8fe3
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Aug 2019 23:42:32.8785
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XEK20hS2dSuVee9/uZ85zJ0MQPrC6jiOHpFkRcPZlG1E8OeF0Ip6Y7+WDgWgxK4F8Jbab9KlyL/SW0PUZLm59A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0501MB2333
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alex Vesker <valex@mellanox.com>

Add the required Software Steering hardware definitions and
bits to mlx5_ifc.

Signed-off-by: Alex Vesker <valex@mellanox.com>
Signed-off-by: Yevgeny Klitenik <kliten@mellanox.com>
Reviewed-by: Mark Bloch <markb@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 include/linux/mlx5/device.h   |   7 +
 include/linux/mlx5/mlx5_ifc.h | 235 ++++++++++++++++++++++++++++------
 2 files changed, 205 insertions(+), 37 deletions(-)

diff --git a/include/linux/mlx5/device.h b/include/linux/mlx5/device.h
index ce9839c8bc1a..5767d7fab5f3 100644
--- a/include/linux/mlx5/device.h
+++ b/include/linux/mlx5/device.h
@@ -1162,6 +1162,9 @@ enum mlx5_qcam_feature_groups {
 #define MLX5_CAP_FLOWTABLE(mdev, cap) \
 	MLX5_GET(flow_table_nic_cap, mdev->caps.hca_cur[MLX5_CAP_FLOW_TABLE], cap=
)
=20
+#define MLX5_CAP64_FLOWTABLE(mdev, cap) \
+	MLX5_GET64(flow_table_nic_cap, (mdev)->caps.hca_cur[MLX5_CAP_FLOW_TABLE],=
 cap)
+
 #define MLX5_CAP_FLOWTABLE_MAX(mdev, cap) \
 	MLX5_GET(flow_table_nic_cap, mdev->caps.hca_max[MLX5_CAP_FLOW_TABLE], cap=
)
=20
@@ -1225,6 +1228,10 @@ enum mlx5_qcam_feature_groups {
 	MLX5_GET(e_switch_cap, \
 		 mdev->caps.hca_cur[MLX5_CAP_ESWITCH], cap)
=20
+#define MLX5_CAP64_ESW_FLOWTABLE(mdev, cap) \
+	MLX5_GET64(flow_table_eswitch_cap, \
+		(mdev)->caps.hca_cur[MLX5_CAP_ESWITCH_FLOW_TABLE], cap)
+
 #define MLX5_CAP_ESW_MAX(mdev, cap) \
 	MLX5_GET(e_switch_cap, \
 		 mdev->caps.hca_max[MLX5_CAP_ESWITCH], cap)
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 4e278114d8b3..76e945dbc7ed 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -282,6 +282,7 @@ enum {
 	MLX5_CMD_OP_ALLOC_MODIFY_HEADER_CONTEXT   =3D 0x940,
 	MLX5_CMD_OP_DEALLOC_MODIFY_HEADER_CONTEXT =3D 0x941,
 	MLX5_CMD_OP_QUERY_MODIFY_HEADER_CONTEXT   =3D 0x942,
+	MLX5_CMD_OP_SYNC_STEERING                 =3D 0xb00,
 	MLX5_CMD_OP_FPGA_CREATE_QP                =3D 0x960,
 	MLX5_CMD_OP_FPGA_MODIFY_QP                =3D 0x961,
 	MLX5_CMD_OP_FPGA_QUERY_QP                 =3D 0x962,
@@ -485,7 +486,11 @@ union mlx5_ifc_gre_key_bits {
 };
=20
 struct mlx5_ifc_fte_match_set_misc_bits {
-	u8         reserved_at_0[0x8];
+	u8         gre_c_present[0x1];
+	u8         reserved_auto1[0x1];
+	u8         gre_k_present[0x1];
+	u8         gre_s_present[0x1];
+	u8         source_vhca_port[0x4];
 	u8         source_sqn[0x18];
=20
 	u8         source_eswitch_owner_vhca_id[0x10];
@@ -565,12 +570,38 @@ struct mlx5_ifc_fte_match_set_misc2_bits {
=20
 	u8         metadata_reg_a[0x20];
=20
-	u8         reserved_at_1a0[0x60];
+	u8         metadata_reg_b[0x20];
+
+	u8         reserved_at_1c0[0x40];
 };
=20
 struct mlx5_ifc_fte_match_set_misc3_bits {
-	u8         reserved_at_0[0x120];
+	u8         inner_tcp_seq_num[0x20];
+
+	u8         outer_tcp_seq_num[0x20];
+
+	u8         inner_tcp_ack_num[0x20];
+
+	u8         outer_tcp_ack_num[0x20];
+
+	u8	   reserved_at_80[0x8];
+	u8         outer_vxlan_gpe_vni[0x18];
+
+	u8         outer_vxlan_gpe_next_protocol[0x8];
+	u8         outer_vxlan_gpe_flags[0x8];
+	u8	   reserved_at_b0[0x10];
+
+	u8	   icmp_header_data[0x20];
+
+	u8	   icmpv6_header_data[0x20];
+
+	u8	   icmp_type[0x8];
+	u8	   icmp_code[0x8];
+	u8	   icmpv6_type[0x8];
+	u8	   icmpv6_code[0x8];
+
 	u8         geneve_tlv_option_0_data[0x20];
+
 	u8         reserved_at_140[0xc0];
 };
=20
@@ -666,7 +697,15 @@ struct mlx5_ifc_flow_table_nic_cap_bits {
=20
 	struct mlx5_ifc_flow_table_prop_layout_bits flow_table_properties_nic_tra=
nsmit_sniffer;
=20
-	u8         reserved_at_e00[0x7200];
+	u8         reserved_at_e00[0x1200];
+
+	u8         sw_steering_nic_rx_action_drop_icm_address[0x40];
+
+	u8         sw_steering_nic_tx_action_drop_icm_address[0x40];
+
+	u8         sw_steering_nic_tx_action_allow_icm_address[0x40];
+
+	u8         reserved_at_20c0[0x5f40];
 };
=20
 enum {
@@ -698,7 +737,17 @@ struct mlx5_ifc_flow_table_eswitch_cap_bits {
=20
 	struct mlx5_ifc_flow_table_prop_layout_bits flow_table_properties_esw_acl=
_egress;
=20
-	u8      reserved_at_800[0x7800];
+	u8      reserved_at_800[0x1000];
+
+	u8      sw_steering_fdb_action_drop_icm_address_rx[0x40];
+
+	u8      sw_steering_fdb_action_drop_icm_address_tx[0x40];
+
+	u8      sw_steering_uplink_icm_address_rx[0x40];
+
+	u8      sw_steering_uplink_icm_address_tx[0x40];
+
+	u8      reserved_at_1900[0x6700];
 };
=20
 enum {
@@ -849,6 +898,25 @@ struct mlx5_ifc_roce_cap_bits {
 	u8         reserved_at_100[0x700];
 };
=20
+struct mlx5_ifc_sync_steering_in_bits {
+	u8         opcode[0x10];
+	u8         uid[0x10];
+
+	u8         reserved_at_20[0x10];
+	u8         op_mod[0x10];
+
+	u8         reserved_at_40[0xc0];
+};
+
+struct mlx5_ifc_sync_steering_out_bits {
+	u8         status[0x8];
+	u8         reserved_at_8[0x18];
+
+	u8         syndrome[0x20];
+
+	u8         reserved_at_40[0x40];
+};
+
 struct mlx5_ifc_device_mem_cap_bits {
 	u8         memic[0x1];
 	u8         reserved_at_1[0x1f];
@@ -1041,6 +1109,12 @@ enum {
 	MLX5_CAP_UMR_FENCE_NONE		=3D 0x2,
 };
=20
+enum {
+	MLX5_FLEX_PARSER_VXLAN_GPE_ENABLED	=3D 1 << 7,
+	MLX5_FLEX_PARSER_ICMP_V4_ENABLED	=3D 1 << 8,
+	MLX5_FLEX_PARSER_ICMP_V6_ENABLED	=3D 1 << 9,
+};
+
 enum {
 	MLX5_UCTX_CAP_RAW_TX =3D 1UL << 0,
 	MLX5_UCTX_CAP_INTERNAL_DEV_RES =3D 1UL << 1,
@@ -1414,7 +1488,14 @@ struct mlx5_ifc_cmd_hca_cap_bits {
=20
 	u8         reserved_at_6c0[0x4];
 	u8         flex_parser_id_geneve_tlv_option_0[0x4];
-	u8	   reserved_at_6c8[0x28];
+	u8         flex_parser_id_icmp_dw1[0x4];
+	u8         flex_parser_id_icmp_dw0[0x4];
+	u8         flex_parser_id_icmpv6_dw1[0x4];
+	u8         flex_parser_id_icmpv6_dw0[0x4];
+	u8         flex_parser_id_outer_first_mpls_over_gre[0x4];
+	u8         flex_parser_id_outer_first_mpls_over_udp_label[0x4];
+
+	u8	   reserved_at_6e0[0x10];
 	u8	   sf_base_id[0x10];
=20
 	u8	   reserved_at_700[0x80];
@@ -2652,6 +2733,7 @@ union mlx5_ifc_hca_cap_union_bits {
 	struct mlx5_ifc_debug_cap_bits debug_cap;
 	struct mlx5_ifc_fpga_cap_bits fpga_cap;
 	struct mlx5_ifc_tls_cap_bits tls_cap;
+	struct mlx5_ifc_device_mem_cap_bits device_mem_cap;
 	u8         reserved_at_0[0x8000];
 };
=20
@@ -3255,7 +3337,11 @@ struct mlx5_ifc_esw_vport_context_bits {
 	u8         cvlan_pcp[0x3];
 	u8         cvlan_id[0xc];
=20
-	u8         reserved_at_60[0x7a0];
+	u8         reserved_at_60[0x720];
+
+	u8         sw_steering_vport_icm_address_rx[0x40];
+
+	u8         sw_steering_vport_icm_address_tx[0x40];
 };
=20
 enum {
@@ -4941,23 +5027,98 @@ struct mlx5_ifc_query_hca_cap_in_bits {
 	u8         reserved_at_20[0x10];
 	u8         op_mod[0x10];
=20
-	u8         reserved_at_40[0x40];
+	u8         other_function[0x1];
+	u8         reserved_at_41[0xf];
+	u8         function_id[0x10];
+
+	u8         reserved_at_60[0x20];
 };
=20
-struct mlx5_ifc_query_flow_table_out_bits {
+struct mlx5_ifc_other_hca_cap_bits {
+	u8         roce[0x1];
+	u8         reserved_0[0x27f];
+};
+
+struct mlx5_ifc_query_other_hca_cap_out_bits {
 	u8         status[0x8];
-	u8         reserved_at_8[0x18];
+	u8         reserved_0[0x18];
=20
 	u8         syndrome[0x20];
=20
-	u8         reserved_at_40[0x80];
+	u8         reserved_1[0x40];
=20
-	u8         reserved_at_c0[0x8];
+	struct     mlx5_ifc_other_hca_cap_bits other_capability;
+};
+
+struct mlx5_ifc_query_other_hca_cap_in_bits {
+	u8         opcode[0x10];
+	u8         reserved_0[0x10];
+
+	u8         reserved_1[0x10];
+	u8         op_mod[0x10];
+
+	u8         reserved_2[0x10];
+	u8         function_id[0x10];
+
+	u8         reserved_3[0x20];
+};
+
+struct mlx5_ifc_modify_other_hca_cap_out_bits {
+	u8         status[0x8];
+	u8         reserved_0[0x18];
+
+	u8         syndrome[0x20];
+
+	u8         reserved_1[0x40];
+};
+
+struct mlx5_ifc_modify_other_hca_cap_in_bits {
+	u8         opcode[0x10];
+	u8         reserved_0[0x10];
+
+	u8         reserved_1[0x10];
+	u8         op_mod[0x10];
+
+	u8         reserved_2[0x10];
+	u8         function_id[0x10];
+	u8         field_select[0x20];
+
+	struct     mlx5_ifc_other_hca_cap_bits other_capability;
+};
+
+struct mlx5_ifc_flow_table_context_bits {
+	u8         reformat_en[0x1];
+	u8         decap_en[0x1];
+	u8         sw_owner[0x1];
+	u8         termination_table[0x1];
+	u8         table_miss_action[0x4];
 	u8         level[0x8];
-	u8         reserved_at_d0[0x8];
+	u8         reserved_at_10[0x8];
 	u8         log_size[0x8];
=20
-	u8         reserved_at_e0[0x120];
+	u8         reserved_at_20[0x8];
+	u8         table_miss_id[0x18];
+
+	u8         reserved_at_40[0x8];
+	u8         lag_master_next_table_id[0x18];
+
+	u8         reserved_at_60[0x60];
+
+	u8         sw_owner_icm_root_1[0x40];
+
+	u8         sw_owner_icm_root_0[0x40];
+
+};
+
+struct mlx5_ifc_query_flow_table_out_bits {
+	u8         status[0x8];
+	u8         reserved_at_8[0x18];
+
+	u8         syndrome[0x20];
+
+	u8         reserved_at_40[0x80];
+
+	struct mlx5_ifc_flow_table_context_bits flow_table_context;
 };
=20
 struct mlx5_ifc_query_flow_table_in_bits {
@@ -5227,7 +5388,7 @@ struct mlx5_ifc_alloc_packet_reformat_context_out_bit=
s {
 	u8         reserved_at_60[0x20];
 };
=20
-enum {
+enum mlx5_reformat_ctx_type {
 	MLX5_REFORMAT_TYPE_L2_TO_VXLAN =3D 0x0,
 	MLX5_REFORMAT_TYPE_L2_TO_NVGRE =3D 0x1,
 	MLX5_REFORMAT_TYPE_L2_TO_L2_TUNNEL =3D 0x2,
@@ -5323,7 +5484,16 @@ enum {
 	MLX5_ACTION_IN_FIELD_OUT_DIPV4         =3D 0x16,
 	MLX5_ACTION_IN_FIELD_OUT_FIRST_VID     =3D 0x17,
 	MLX5_ACTION_IN_FIELD_OUT_IPV6_HOPLIMIT =3D 0x47,
+	MLX5_ACTION_IN_FIELD_METADATA_REG_A    =3D 0x49,
+	MLX5_ACTION_IN_FIELD_METADATA_REG_B    =3D 0x50,
 	MLX5_ACTION_IN_FIELD_METADATA_REG_C_0  =3D 0x51,
+	MLX5_ACTION_IN_FIELD_METADATA_REG_C_1  =3D 0x52,
+	MLX5_ACTION_IN_FIELD_METADATA_REG_C_2  =3D 0x53,
+	MLX5_ACTION_IN_FIELD_METADATA_REG_C_3  =3D 0x54,
+	MLX5_ACTION_IN_FIELD_METADATA_REG_C_4  =3D 0x55,
+	MLX5_ACTION_IN_FIELD_METADATA_REG_C_5  =3D 0x56,
+	MLX5_ACTION_IN_FIELD_OUT_TCP_SEQ_NUM   =3D 0x59,
+	MLX5_ACTION_IN_FIELD_OUT_TCP_ACK_NUM   =3D 0x5B,
 };
=20
 struct mlx5_ifc_alloc_modify_header_context_out_bits {
@@ -7369,35 +7539,26 @@ struct mlx5_ifc_create_mkey_in_bits {
 	u8         klm_pas_mtt[0][0x20];
 };
=20
+enum {
+	MLX5_FLOW_TABLE_TYPE_NIC_RX		=3D 0x0,
+	MLX5_FLOW_TABLE_TYPE_NIC_TX		=3D 0x1,
+	MLX5_FLOW_TABLE_TYPE_ESW_EGRESS_ACL	=3D 0x2,
+	MLX5_FLOW_TABLE_TYPE_ESW_INGRESS_ACL	=3D 0x3,
+	MLX5_FLOW_TABLE_TYPE_FDB		=3D 0X4,
+	MLX5_FLOW_TABLE_TYPE_SNIFFER_RX		=3D 0X5,
+	MLX5_FLOW_TABLE_TYPE_SNIFFER_TX		=3D 0X6,
+};
+
 struct mlx5_ifc_create_flow_table_out_bits {
 	u8         status[0x8];
-	u8         reserved_at_8[0x18];
+	u8         icm_address_63_40[0x18];
=20
 	u8         syndrome[0x20];
=20
-	u8         reserved_at_40[0x8];
+	u8         icm_address_39_32[0x8];
 	u8         table_id[0x18];
=20
-	u8         reserved_at_60[0x20];
-};
-
-struct mlx5_ifc_flow_table_context_bits {
-	u8         reformat_en[0x1];
-	u8         decap_en[0x1];
-	u8         reserved_at_2[0x1];
-	u8         termination_table[0x1];
-	u8         table_miss_action[0x4];
-	u8         level[0x8];
-	u8         reserved_at_10[0x8];
-	u8         log_size[0x8];
-
-	u8         reserved_at_20[0x8];
-	u8         table_miss_id[0x18];
-
-	u8         reserved_at_40[0x8];
-	u8         lag_master_next_table_id[0x18];
-
-	u8         reserved_at_60[0xe0];
+	u8         icm_address_31_0[0x20];
 };
=20
 struct mlx5_ifc_create_flow_table_in_bits {
--=20
2.21.0

