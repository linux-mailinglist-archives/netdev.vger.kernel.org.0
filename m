Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97E7AA7430
	for <lists+netdev@lfdr.de>; Tue,  3 Sep 2019 22:05:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726882AbfICUFO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Sep 2019 16:05:14 -0400
Received: from mail-eopbgr140044.outbound.protection.outlook.com ([40.107.14.44]:24054
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726009AbfICUFN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Sep 2019 16:05:13 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=njSF983X1dXHF+7RD4GuK/ffRGkxv1Q1MkcrTLMfdTwLeUdsmEmfiBDUqFL8Kfh/s9k/eVf4u0I6+NNDjOmNLv3lNEXkdA03Iaxp0C8O/kS52817BFyTXQ+rXncH00u0VbB3xbvrxJiUjipg46N5oWEHQNA0x30CBYfyVxrr2r7x0lKNTtP3F/v1xs+tnvKJXoiqWk3M7d1sFbgfYvUCOkbRZdaMhbeEkGyVDeqUdnd2vq9n6Ig1Xrno3y1g2YflSukLANF296u8XSd6VA6X09pSiCENzbBypU2BeImrshFd44wCxP5f+WSXn2fA4Criuljos1x/15O114WwhXLvBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XRnuHKCfwxvS+8QpE0AFH74kT1nPgwHUHJCWGWAozEU=;
 b=P2ck4+tpym6wR8QSC3kbNpXmH8nZgXXhTbL5+nr5dTuzzPkR2YIYLoIzI+jWvmygKawtUmrVLNeA1vw2jkj7j15mUfTm4AQt51/pbtNr715mymDbdnauQlfDVwwUqfs2BrsnUMgZcWL6fqCWglNpkHoI8oSH40UmZVCHnp93+fzFv999kzb1uMfAF/t7oC7QjdrRoFwrKrvJYa+D8IquKOVB5W4hBm2chBYEQSq0ZTuV2fKc793uWI+IXEwr90PuPXHcSauZH7K4oFUJFQhrChN2MxkyuvVdyBgNWRNdZuB775kVHinCg9agetpuqqLhxhH96WedUmtBUffX3GHo3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XRnuHKCfwxvS+8QpE0AFH74kT1nPgwHUHJCWGWAozEU=;
 b=hwQEVAnsfnAVRvJ6ugip7erwpb2LWQ85bBgs9jfZpr0MRdZV1pme04OXztM19K+m4TdlSolY23uURxFbU4PB5xHqcrOOtV56cWbPf27gg/CrjQqYlEoowLDoATYkAoMbx3Fzv/756iyj0Hjpl9S702E+d9e+B4AEk7a3wgsKOdU=
Received: from AM4PR0501MB2756.eurprd05.prod.outlook.com (10.172.216.138) by
 AM4PR0501MB2706.eurprd05.prod.outlook.com (10.172.221.142) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2220.21; Tue, 3 Sep 2019 20:04:32 +0000
Received: from AM4PR0501MB2756.eurprd05.prod.outlook.com
 ([fe80::58d1:d1d6:dbda:3576]) by AM4PR0501MB2756.eurprd05.prod.outlook.com
 ([fe80::58d1:d1d6:dbda:3576%4]) with mapi id 15.20.2220.021; Tue, 3 Sep 2019
 20:04:32 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alex Vesker <valex@mellanox.com>,
        Erez Shitrit <erezsh@mellanox.com>,
        Mark Bloch <markb@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next V2 03/18] net/mlx5: DR, Add direct rule command utilities
Thread-Topic: [net-next V2 03/18] net/mlx5: DR, Add direct rule command
 utilities
Thread-Index: AQHVYpLM7OMjZBoEdk6VU+RTZZsIBw==
Date:   Tue, 3 Sep 2019 20:04:31 +0000
Message-ID: <20190903200409.14406-4-saeedm@mellanox.com>
References: <20190903200409.14406-1-saeedm@mellanox.com>
In-Reply-To: <20190903200409.14406-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR02CA0049.namprd02.prod.outlook.com
 (2603:10b6:a03:54::26) To AM4PR0501MB2756.eurprd05.prod.outlook.com
 (2603:10a6:200:5c::10)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c20f823d-a89c-406b-75c5-08d730a9ef0b
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM4PR0501MB2706;
x-ms-traffictypediagnostic: AM4PR0501MB2706:|AM4PR0501MB2706:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM4PR0501MB2706059683310E86AD571C29BEB90@AM4PR0501MB2706.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 01494FA7F7
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(979002)(4636009)(376002)(346002)(136003)(39860400002)(396003)(366004)(199004)(189003)(2906002)(102836004)(256004)(26005)(11346002)(50226002)(186003)(66446008)(386003)(6506007)(64756008)(66556008)(14444005)(66476007)(71190400001)(66946007)(2616005)(476003)(76176011)(71200400001)(5660300002)(8936002)(66066001)(446003)(81166006)(81156014)(30864003)(478600001)(54906003)(6916009)(8676002)(486006)(36756003)(3846002)(7736002)(53936002)(6436002)(305945005)(53946003)(14454004)(6116002)(52116002)(6512007)(86362001)(316002)(99286004)(1076003)(6486002)(4326008)(107886003)(25786009)(959014)(579004)(559001)(569006);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR0501MB2706;H:AM4PR0501MB2756.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 412yX0h3Q0FtOylynJAyCgj68pvAEBu89Ynh2MpUH2eWSdI+XELz3OKrFCPmCYVnmFfYyiogmVLwO36Fx6hLpKzybUtUKC9Th/iTf4gFY43E2t03k0NSacpaAMasmW3YM9UFkRQBRmG+zSoRnqoAukUbxLykq9dSKzaL+X9BMmb8l3PTNATsFcDV/LBdLzjpUvLkMrttl9Lc+izRCDRPtTVzwCZYZ5XMPufAHy1WzLE9g4J5lI5xXz6VZFw1f3Xqxi4sXHlE3dVN14+s8I35iBtBf7b8pnijx2kBZfr7F3bARErbhK3HYQwXnfy6O5TE5GgE7Mybglmg9pmbSzw959YKBQOv5jaKKpa0MWQyaOsoFvrSlwloBWax3oMF6Km8yZyPedvjt/M/gtmhcnUTdunmcimnCOGA0cwrhkIuyuw=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c20f823d-a89c-406b-75c5-08d730a9ef0b
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Sep 2019 20:04:32.4641
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: p7Poej9GP86SB27vd6gyduzfxQAEdbAG2kbQAiAZayDqLUyod6oyh4pNVjHg5b8KJu81Qwf75kNNTqfr9xVgcA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR0501MB2706
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alex Vesker <valex@mellanox.com>

Add direct rule command utilities which consists of all the FW
commands that are executed to provide the SW steering functionality.

Signed-off-by: Alex Vesker <valex@mellanox.com>
Reviewed-by: Erez Shitrit <erezsh@mellanox.com>
Reviewed-by: Mark Bloch <markb@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../mellanox/mlx5/core/steering/dr_cmd.c      | 480 ++++++++++++++
 .../mellanox/mlx5/core/steering/mlx5_ifc_dr.h | 604 ++++++++++++++++++
 2 files changed, 1084 insertions(+)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_cmd=
.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5_i=
fc_dr.h

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_cmd.c b/dr=
ivers/net/ethernet/mellanox/mlx5/core/steering/dr_cmd.c
new file mode 100644
index 000000000000..41662c4e2664
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_cmd.c
@@ -0,0 +1,480 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+/* Copyright (c) 2019 Mellanox Technologies. */
+
+#include "dr_types.h"
+
+int mlx5dr_cmd_query_esw_vport_context(struct mlx5_core_dev *mdev,
+				       bool other_vport,
+				       u16 vport_number,
+				       u64 *icm_address_rx,
+				       u64 *icm_address_tx)
+{
+	u32 out[MLX5_ST_SZ_DW(query_esw_vport_context_out)] =3D {};
+	u32 in[MLX5_ST_SZ_DW(query_esw_vport_context_in)] =3D {};
+	int err;
+
+	MLX5_SET(query_esw_vport_context_in, in, opcode,
+		 MLX5_CMD_OP_QUERY_ESW_VPORT_CONTEXT);
+	MLX5_SET(query_esw_vport_context_in, in, other_vport, other_vport);
+	MLX5_SET(query_esw_vport_context_in, in, vport_number, vport_number);
+
+	err =3D mlx5_cmd_exec(mdev, in, sizeof(in), out, sizeof(out));
+	if (err)
+		return err;
+
+	*icm_address_rx =3D
+		MLX5_GET64(query_esw_vport_context_out, out,
+			   esw_vport_context.sw_steering_vport_icm_address_rx);
+	*icm_address_tx =3D
+		MLX5_GET64(query_esw_vport_context_out, out,
+			   esw_vport_context.sw_steering_vport_icm_address_tx);
+	return 0;
+}
+
+int mlx5dr_cmd_query_gvmi(struct mlx5_core_dev *mdev, bool other_vport,
+			  u16 vport_number, u16 *gvmi)
+{
+	u32 in[MLX5_ST_SZ_DW(query_hca_cap_in)] =3D {};
+	int out_size;
+	void *out;
+	int err;
+
+	out_size =3D MLX5_ST_SZ_BYTES(query_hca_cap_out);
+	out =3D kzalloc(out_size, GFP_KERNEL);
+	if (!out)
+		return -ENOMEM;
+
+	MLX5_SET(query_hca_cap_in, in, opcode, MLX5_CMD_OP_QUERY_HCA_CAP);
+	MLX5_SET(query_hca_cap_in, in, other_function, other_vport);
+	MLX5_SET(query_hca_cap_in, in, function_id, vport_number);
+	MLX5_SET(query_hca_cap_in, in, op_mod,
+		 MLX5_SET_HCA_CAP_OP_MOD_GENERAL_DEVICE << 1 |
+		 HCA_CAP_OPMOD_GET_CUR);
+
+	err =3D mlx5_cmd_exec(mdev, in, sizeof(in), out, out_size);
+	if (err) {
+		kfree(out);
+		return err;
+	}
+
+	*gvmi =3D MLX5_GET(query_hca_cap_out, out, capability.cmd_hca_cap.vhca_id=
);
+
+	kfree(out);
+	return 0;
+}
+
+int mlx5dr_cmd_query_esw_caps(struct mlx5_core_dev *mdev,
+			      struct mlx5dr_esw_caps *caps)
+{
+	caps->drop_icm_address_rx =3D
+		MLX5_CAP64_ESW_FLOWTABLE(mdev,
+					 sw_steering_fdb_action_drop_icm_address_rx);
+	caps->drop_icm_address_tx =3D
+		MLX5_CAP64_ESW_FLOWTABLE(mdev,
+					 sw_steering_fdb_action_drop_icm_address_tx);
+	caps->uplink_icm_address_rx =3D
+		MLX5_CAP64_ESW_FLOWTABLE(mdev,
+					 sw_steering_uplink_icm_address_rx);
+	caps->uplink_icm_address_tx =3D
+		MLX5_CAP64_ESW_FLOWTABLE(mdev,
+					 sw_steering_uplink_icm_address_tx);
+	caps->sw_owner =3D
+		MLX5_CAP_ESW_FLOWTABLE_FDB(mdev,
+					   sw_owner);
+
+	return 0;
+}
+
+int mlx5dr_cmd_query_device(struct mlx5_core_dev *mdev,
+			    struct mlx5dr_cmd_caps *caps)
+{
+	caps->prio_tag_required	=3D MLX5_CAP_GEN(mdev, prio_tag_required);
+	caps->eswitch_manager	=3D MLX5_CAP_GEN(mdev, eswitch_manager);
+	caps->gvmi		=3D MLX5_CAP_GEN(mdev, vhca_id);
+	caps->flex_protocols	=3D MLX5_CAP_GEN(mdev, flex_parser_protocols);
+
+	if (mlx5dr_matcher_supp_flex_parser_icmp_v4(caps)) {
+		caps->flex_parser_id_icmp_dw0 =3D MLX5_CAP_GEN(mdev, flex_parser_id_icmp=
_dw0);
+		caps->flex_parser_id_icmp_dw1 =3D MLX5_CAP_GEN(mdev, flex_parser_id_icmp=
_dw1);
+	}
+
+	if (mlx5dr_matcher_supp_flex_parser_icmp_v6(caps)) {
+		caps->flex_parser_id_icmpv6_dw0 =3D
+			MLX5_CAP_GEN(mdev, flex_parser_id_icmpv6_dw0);
+		caps->flex_parser_id_icmpv6_dw1 =3D
+			MLX5_CAP_GEN(mdev, flex_parser_id_icmpv6_dw1);
+	}
+
+	caps->nic_rx_drop_address =3D
+		MLX5_CAP64_FLOWTABLE(mdev, sw_steering_nic_rx_action_drop_icm_address);
+	caps->nic_tx_drop_address =3D
+		MLX5_CAP64_FLOWTABLE(mdev, sw_steering_nic_tx_action_drop_icm_address);
+	caps->nic_tx_allow_address =3D
+		MLX5_CAP64_FLOWTABLE(mdev, sw_steering_nic_tx_action_allow_icm_address);
+
+	caps->rx_sw_owner =3D MLX5_CAP_FLOWTABLE_NIC_RX(mdev, sw_owner);
+	caps->max_ft_level =3D MLX5_CAP_FLOWTABLE_NIC_RX(mdev, max_ft_level);
+
+	caps->tx_sw_owner =3D MLX5_CAP_FLOWTABLE_NIC_TX(mdev, sw_owner);
+
+	caps->log_icm_size =3D MLX5_CAP_DEV_MEM(mdev, log_steering_sw_icm_size);
+	caps->hdr_modify_icm_addr =3D
+		MLX5_CAP64_DEV_MEM(mdev, header_modify_sw_icm_start_address);
+
+	caps->roce_min_src_udp =3D MLX5_CAP_ROCE(mdev, r_roce_min_src_udp_port);
+
+	return 0;
+}
+
+int mlx5dr_cmd_query_flow_table(struct mlx5_core_dev *dev,
+				enum fs_flow_table_type type,
+				u32 table_id,
+				struct mlx5dr_cmd_query_flow_table_details *output)
+{
+	u32 out[MLX5_ST_SZ_DW(query_flow_table_out)] =3D {};
+	u32 in[MLX5_ST_SZ_DW(query_flow_table_in)] =3D {};
+	int err;
+
+	MLX5_SET(query_flow_table_in, in, opcode,
+		 MLX5_CMD_OP_QUERY_FLOW_TABLE);
+
+	MLX5_SET(query_flow_table_in, in, table_type, type);
+	MLX5_SET(query_flow_table_in, in, table_id, table_id);
+
+	err =3D mlx5_cmd_exec(dev, in, sizeof(in), out, sizeof(out));
+	if (err)
+		return err;
+
+	output->status =3D MLX5_GET(query_flow_table_out, out, status);
+	output->level =3D MLX5_GET(query_flow_table_out, out, flow_table_context.=
level);
+
+	output->sw_owner_icm_root_1 =3D MLX5_GET64(query_flow_table_out, out,
+						 flow_table_context.sw_owner_icm_root_1);
+	output->sw_owner_icm_root_0 =3D MLX5_GET64(query_flow_table_out, out,
+						 flow_table_context.sw_owner_icm_root_0);
+
+	return 0;
+}
+
+int mlx5dr_cmd_sync_steering(struct mlx5_core_dev *mdev)
+{
+	u32 out[MLX5_ST_SZ_DW(sync_steering_out)] =3D {};
+	u32 in[MLX5_ST_SZ_DW(sync_steering_in)] =3D {};
+
+	MLX5_SET(sync_steering_in, in, opcode, MLX5_CMD_OP_SYNC_STEERING);
+
+	return mlx5_cmd_exec(mdev, in, sizeof(in), out, sizeof(out));
+}
+
+int mlx5dr_cmd_set_fte_modify_and_vport(struct mlx5_core_dev *mdev,
+					u32 table_type,
+					u32 table_id,
+					u32 group_id,
+					u32 modify_header_id,
+					u32 vport_id)
+{
+	u32 out[MLX5_ST_SZ_DW(set_fte_out)] =3D {};
+	void *in_flow_context;
+	unsigned int inlen;
+	void *in_dests;
+	u32 *in;
+	int err;
+
+	inlen =3D MLX5_ST_SZ_BYTES(set_fte_in) +
+		1 * MLX5_ST_SZ_BYTES(dest_format_struct); /* One destination only */
+
+	in =3D kvzalloc(inlen, GFP_KERNEL);
+	if (!in)
+		return -ENOMEM;
+
+	MLX5_SET(set_fte_in, in, opcode, MLX5_CMD_OP_SET_FLOW_TABLE_ENTRY);
+	MLX5_SET(set_fte_in, in, table_type, table_type);
+	MLX5_SET(set_fte_in, in, table_id, table_id);
+
+	in_flow_context =3D MLX5_ADDR_OF(set_fte_in, in, flow_context);
+	MLX5_SET(flow_context, in_flow_context, group_id, group_id);
+	MLX5_SET(flow_context, in_flow_context, modify_header_id, modify_header_i=
d);
+	MLX5_SET(flow_context, in_flow_context, destination_list_size, 1);
+	MLX5_SET(flow_context, in_flow_context, action,
+		 MLX5_FLOW_CONTEXT_ACTION_FWD_DEST |
+		 MLX5_FLOW_CONTEXT_ACTION_MOD_HDR);
+
+	in_dests =3D MLX5_ADDR_OF(flow_context, in_flow_context, destination);
+	MLX5_SET(dest_format_struct, in_dests, destination_type,
+		 MLX5_FLOW_DESTINATION_TYPE_VPORT);
+	MLX5_SET(dest_format_struct, in_dests, destination_id, vport_id);
+
+	err =3D mlx5_cmd_exec(mdev, in, inlen, out, sizeof(out));
+	kvfree(in);
+
+	return err;
+}
+
+int mlx5dr_cmd_del_flow_table_entry(struct mlx5_core_dev *mdev,
+				    u32 table_type,
+				    u32 table_id)
+{
+	u32 out[MLX5_ST_SZ_DW(delete_fte_out)] =3D {};
+	u32 in[MLX5_ST_SZ_DW(delete_fte_in)] =3D {};
+
+	MLX5_SET(delete_fte_in, in, opcode, MLX5_CMD_OP_DELETE_FLOW_TABLE_ENTRY);
+	MLX5_SET(delete_fte_in, in, table_type, table_type);
+	MLX5_SET(delete_fte_in, in, table_id, table_id);
+
+	return mlx5_cmd_exec(mdev, in, sizeof(in), out, sizeof(out));
+}
+
+int mlx5dr_cmd_alloc_modify_header(struct mlx5_core_dev *mdev,
+				   u32 table_type,
+				   u8 num_of_actions,
+				   u64 *actions,
+				   u32 *modify_header_id)
+{
+	u32 out[MLX5_ST_SZ_DW(alloc_modify_header_context_out)] =3D {};
+	void *p_actions;
+	u32 inlen;
+	u32 *in;
+	int err;
+
+	inlen =3D MLX5_ST_SZ_BYTES(alloc_modify_header_context_in) +
+		 num_of_actions * sizeof(u64);
+	in =3D kvzalloc(inlen, GFP_KERNEL);
+	if (!in)
+		return -ENOMEM;
+
+	MLX5_SET(alloc_modify_header_context_in, in, opcode,
+		 MLX5_CMD_OP_ALLOC_MODIFY_HEADER_CONTEXT);
+	MLX5_SET(alloc_modify_header_context_in, in, table_type, table_type);
+	MLX5_SET(alloc_modify_header_context_in, in, num_of_actions, num_of_actio=
ns);
+	p_actions =3D MLX5_ADDR_OF(alloc_modify_header_context_in, in, actions);
+	memcpy(p_actions, actions, num_of_actions * sizeof(u64));
+
+	err =3D mlx5_cmd_exec(mdev, in, inlen, out, sizeof(out));
+	if (err)
+		goto out;
+
+	*modify_header_id =3D MLX5_GET(alloc_modify_header_context_out, out,
+				     modify_header_id);
+out:
+	kvfree(in);
+	return err;
+}
+
+int mlx5dr_cmd_dealloc_modify_header(struct mlx5_core_dev *mdev,
+				     u32 modify_header_id)
+{
+	u32 out[MLX5_ST_SZ_DW(dealloc_modify_header_context_out)] =3D {};
+	u32 in[MLX5_ST_SZ_DW(dealloc_modify_header_context_in)] =3D {};
+
+	MLX5_SET(dealloc_modify_header_context_in, in, opcode,
+		 MLX5_CMD_OP_DEALLOC_MODIFY_HEADER_CONTEXT);
+	MLX5_SET(dealloc_modify_header_context_in, in, modify_header_id,
+		 modify_header_id);
+
+	return mlx5_cmd_exec(mdev, in, sizeof(in), out, sizeof(out));
+}
+
+int mlx5dr_cmd_create_empty_flow_group(struct mlx5_core_dev *mdev,
+				       u32 table_type,
+				       u32 table_id,
+				       u32 *group_id)
+{
+	u32 out[MLX5_ST_SZ_DW(create_flow_group_out)] =3D {};
+	int inlen =3D MLX5_ST_SZ_BYTES(create_flow_group_in);
+	u32 *in;
+	int err;
+
+	in =3D kzalloc(inlen, GFP_KERNEL);
+	if (!in)
+		return -ENOMEM;
+
+	MLX5_SET(create_flow_group_in, in, opcode, MLX5_CMD_OP_CREATE_FLOW_GROUP)=
;
+	MLX5_SET(create_flow_group_in, in, table_type, table_type);
+	MLX5_SET(create_flow_group_in, in, table_id, table_id);
+
+	err =3D mlx5_cmd_exec(mdev, in, inlen, out, sizeof(out));
+	if (err)
+		goto out;
+
+	*group_id =3D MLX5_GET(create_flow_group_out, out, group_id);
+
+out:
+	kfree(in);
+	return err;
+}
+
+int mlx5dr_cmd_destroy_flow_group(struct mlx5_core_dev *mdev,
+				  u32 table_type,
+				  u32 table_id,
+				  u32 group_id)
+{
+	u32 in[MLX5_ST_SZ_DW(destroy_flow_group_in)] =3D {};
+	u32 out[MLX5_ST_SZ_DW(destroy_flow_group_out)] =3D {};
+
+	MLX5_SET(create_flow_group_in, in, opcode, MLX5_CMD_OP_DESTROY_FLOW_GROUP=
);
+	MLX5_SET(destroy_flow_group_in, in, table_type, table_type);
+	MLX5_SET(destroy_flow_group_in, in, table_id, table_id);
+	MLX5_SET(destroy_flow_group_in, in, group_id, group_id);
+
+	return mlx5_cmd_exec(mdev, in, sizeof(in), out, sizeof(out));
+}
+
+int mlx5dr_cmd_create_flow_table(struct mlx5_core_dev *mdev,
+				 u32 table_type,
+				 u64 icm_addr_rx,
+				 u64 icm_addr_tx,
+				 u8 level,
+				 bool sw_owner,
+				 bool term_tbl,
+				 u64 *fdb_rx_icm_addr,
+				 u32 *table_id)
+{
+	u32 out[MLX5_ST_SZ_DW(create_flow_table_out)] =3D {};
+	u32 in[MLX5_ST_SZ_DW(create_flow_table_in)] =3D {};
+	void *ft_mdev;
+	int err;
+
+	MLX5_SET(create_flow_table_in, in, opcode, MLX5_CMD_OP_CREATE_FLOW_TABLE)=
;
+	MLX5_SET(create_flow_table_in, in, table_type, table_type);
+
+	ft_mdev =3D MLX5_ADDR_OF(create_flow_table_in, in, flow_table_context);
+	MLX5_SET(flow_table_context, ft_mdev, termination_table, term_tbl);
+	MLX5_SET(flow_table_context, ft_mdev, sw_owner, sw_owner);
+	MLX5_SET(flow_table_context, ft_mdev, level, level);
+
+	if (sw_owner) {
+		/* icm_addr_0 used for FDB RX / NIC TX / NIC_RX
+		 * icm_addr_1 used for FDB TX
+		 */
+		if (table_type =3D=3D MLX5_FLOW_TABLE_TYPE_NIC_RX) {
+			MLX5_SET64(flow_table_context, ft_mdev,
+				   sw_owner_icm_root_0, icm_addr_rx);
+		} else if (table_type =3D=3D MLX5_FLOW_TABLE_TYPE_NIC_TX) {
+			MLX5_SET64(flow_table_context, ft_mdev,
+				   sw_owner_icm_root_0, icm_addr_tx);
+		} else if (table_type =3D=3D MLX5_FLOW_TABLE_TYPE_FDB) {
+			MLX5_SET64(flow_table_context, ft_mdev,
+				   sw_owner_icm_root_0, icm_addr_rx);
+			MLX5_SET64(flow_table_context, ft_mdev,
+				   sw_owner_icm_root_1, icm_addr_tx);
+		}
+	}
+
+	err =3D mlx5_cmd_exec(mdev, in, sizeof(in), out, sizeof(out));
+	if (err)
+		return err;
+
+	*table_id =3D MLX5_GET(create_flow_table_out, out, table_id);
+	if (!sw_owner && table_type =3D=3D MLX5_FLOW_TABLE_TYPE_FDB)
+		*fdb_rx_icm_addr =3D
+		(u64)MLX5_GET(create_flow_table_out, out, icm_address_31_0) |
+		(u64)MLX5_GET(create_flow_table_out, out, icm_address_39_32) << 32 |
+		(u64)MLX5_GET(create_flow_table_out, out, icm_address_63_40) << 40;
+
+	return 0;
+}
+
+int mlx5dr_cmd_destroy_flow_table(struct mlx5_core_dev *mdev,
+				  u32 table_id,
+				  u32 table_type)
+{
+	u32 out[MLX5_ST_SZ_DW(destroy_flow_table_out)] =3D {};
+	u32 in[MLX5_ST_SZ_DW(destroy_flow_table_in)] =3D {};
+
+	MLX5_SET(destroy_flow_table_in, in, opcode,
+		 MLX5_CMD_OP_DESTROY_FLOW_TABLE);
+	MLX5_SET(destroy_flow_table_in, in, table_type, table_type);
+	MLX5_SET(destroy_flow_table_in, in, table_id, table_id);
+
+	return mlx5_cmd_exec(mdev, in, sizeof(in), out, sizeof(out));
+}
+
+int mlx5dr_cmd_create_reformat_ctx(struct mlx5_core_dev *mdev,
+				   enum mlx5_reformat_ctx_type rt,
+				   size_t reformat_size,
+				   void *reformat_data,
+				   u32 *reformat_id)
+{
+	u32 out[MLX5_ST_SZ_DW(alloc_packet_reformat_context_out)] =3D {};
+	size_t inlen, cmd_data_sz, cmd_total_sz;
+	void *prctx;
+	void *pdata;
+	void *in;
+	int err;
+
+	cmd_total_sz =3D MLX5_ST_SZ_BYTES(alloc_packet_reformat_context_in);
+	cmd_data_sz =3D MLX5_FLD_SZ_BYTES(alloc_packet_reformat_context_in,
+					packet_reformat_context.reformat_data);
+	inlen =3D ALIGN(cmd_total_sz + reformat_size - cmd_data_sz, 4);
+	in =3D kvzalloc(inlen, GFP_KERNEL);
+	if (!in)
+		return -ENOMEM;
+
+	MLX5_SET(alloc_packet_reformat_context_in, in, opcode,
+		 MLX5_CMD_OP_ALLOC_PACKET_REFORMAT_CONTEXT);
+
+	prctx =3D MLX5_ADDR_OF(alloc_packet_reformat_context_in, in, packet_refor=
mat_context);
+	pdata =3D MLX5_ADDR_OF(packet_reformat_context_in, prctx, reformat_data);
+
+	MLX5_SET(packet_reformat_context_in, prctx, reformat_type, rt);
+	MLX5_SET(packet_reformat_context_in, prctx, reformat_data_size, reformat_=
size);
+	memcpy(pdata, reformat_data, reformat_size);
+
+	err =3D mlx5_cmd_exec(mdev, in, inlen, out, sizeof(out));
+	if (err)
+		return err;
+
+	*reformat_id =3D MLX5_GET(alloc_packet_reformat_context_out, out, packet_=
reformat_id);
+	kvfree(in);
+
+	return err;
+}
+
+void mlx5dr_cmd_destroy_reformat_ctx(struct mlx5_core_dev *mdev,
+				     u32 reformat_id)
+{
+	u32 out[MLX5_ST_SZ_DW(dealloc_packet_reformat_context_out)] =3D {};
+	u32 in[MLX5_ST_SZ_DW(dealloc_packet_reformat_context_in)] =3D {};
+
+	MLX5_SET(dealloc_packet_reformat_context_in, in, opcode,
+		 MLX5_CMD_OP_DEALLOC_PACKET_REFORMAT_CONTEXT);
+	MLX5_SET(dealloc_packet_reformat_context_in, in, packet_reformat_id,
+		 reformat_id);
+
+	mlx5_cmd_exec(mdev, in, sizeof(in), out, sizeof(out));
+}
+
+int mlx5dr_cmd_query_gid(struct mlx5_core_dev *mdev, u8 vhca_port_num,
+			 u16 index, struct mlx5dr_cmd_gid_attr *attr)
+{
+	u32 out[MLX5_ST_SZ_DW(query_roce_address_out)] =3D {};
+	u32 in[MLX5_ST_SZ_DW(query_roce_address_in)] =3D {};
+	int err;
+
+	MLX5_SET(query_roce_address_in, in, opcode,
+		 MLX5_CMD_OP_QUERY_ROCE_ADDRESS);
+
+	MLX5_SET(query_roce_address_in, in, roce_address_index, index);
+	MLX5_SET(query_roce_address_in, in, vhca_port_num, vhca_port_num);
+
+	err =3D mlx5_cmd_exec(mdev, in, sizeof(in), out, sizeof(out));
+	if (err)
+		return err;
+
+	memcpy(&attr->gid,
+	       MLX5_ADDR_OF(query_roce_address_out,
+			    out, roce_address.source_l3_address),
+	       sizeof(attr->gid));
+	memcpy(attr->mac,
+	       MLX5_ADDR_OF(query_roce_address_out, out,
+			    roce_address.source_mac_47_32),
+	       sizeof(attr->mac));
+
+	if (MLX5_GET(query_roce_address_out, out,
+		     roce_address.roce_version) =3D=3D MLX5_ROCE_VERSION_2)
+		attr->roce_ver =3D MLX5_ROCE_VERSION_2;
+	else
+		attr->roce_ver =3D MLX5_ROCE_VERSION_1;
+
+	return 0;
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5_ifc_dr.h=
 b/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5_ifc_dr.h
new file mode 100644
index 000000000000..596c927220d9
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5_ifc_dr.h
@@ -0,0 +1,604 @@
+/* SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB */
+/* Copyright (c) 2019, Mellanox Technologies */
+
+#ifndef MLX5_IFC_DR_H
+#define MLX5_IFC_DR_H
+
+enum {
+	MLX5DR_ACTION_MDFY_HW_FLD_L2_0		=3D 0,
+	MLX5DR_ACTION_MDFY_HW_FLD_L2_1		=3D 1,
+	MLX5DR_ACTION_MDFY_HW_FLD_L2_2		=3D 2,
+	MLX5DR_ACTION_MDFY_HW_FLD_L3_0		=3D 3,
+	MLX5DR_ACTION_MDFY_HW_FLD_L3_1		=3D 4,
+	MLX5DR_ACTION_MDFY_HW_FLD_L3_2		=3D 5,
+	MLX5DR_ACTION_MDFY_HW_FLD_L3_3		=3D 6,
+	MLX5DR_ACTION_MDFY_HW_FLD_L3_4		=3D 7,
+	MLX5DR_ACTION_MDFY_HW_FLD_L4_0		=3D 8,
+	MLX5DR_ACTION_MDFY_HW_FLD_L4_1		=3D 9,
+	MLX5DR_ACTION_MDFY_HW_FLD_MPLS		=3D 10,
+	MLX5DR_ACTION_MDFY_HW_FLD_L2_TNL_0	=3D 11,
+	MLX5DR_ACTION_MDFY_HW_FLD_REG_0		=3D 12,
+	MLX5DR_ACTION_MDFY_HW_FLD_REG_1		=3D 13,
+	MLX5DR_ACTION_MDFY_HW_FLD_REG_2		=3D 14,
+	MLX5DR_ACTION_MDFY_HW_FLD_REG_3		=3D 15,
+	MLX5DR_ACTION_MDFY_HW_FLD_L4_2		=3D 16,
+	MLX5DR_ACTION_MDFY_HW_FLD_FLEX_0	=3D 17,
+	MLX5DR_ACTION_MDFY_HW_FLD_FLEX_1	=3D 18,
+	MLX5DR_ACTION_MDFY_HW_FLD_FLEX_2	=3D 19,
+	MLX5DR_ACTION_MDFY_HW_FLD_FLEX_3	=3D 20,
+	MLX5DR_ACTION_MDFY_HW_FLD_L2_TNL_1	=3D 21,
+	MLX5DR_ACTION_MDFY_HW_FLD_METADATA	=3D 22,
+	MLX5DR_ACTION_MDFY_HW_FLD_RESERVED	=3D 23,
+};
+
+enum {
+	MLX5DR_ACTION_MDFY_HW_OP_SET		=3D 0x2,
+	MLX5DR_ACTION_MDFY_HW_OP_ADD		=3D 0x3,
+};
+
+enum {
+	MLX5DR_ACTION_MDFY_HW_HDR_L3_NONE	=3D 0x0,
+	MLX5DR_ACTION_MDFY_HW_HDR_L3_IPV4	=3D 0x1,
+	MLX5DR_ACTION_MDFY_HW_HDR_L3_IPV6	=3D 0x2,
+};
+
+enum {
+	MLX5DR_ACTION_MDFY_HW_HDR_L4_NONE	=3D 0x0,
+	MLX5DR_ACTION_MDFY_HW_HDR_L4_TCP	=3D 0x1,
+	MLX5DR_ACTION_MDFY_HW_HDR_L4_UDP	=3D 0x2,
+};
+
+enum {
+	MLX5DR_STE_LU_TYPE_NOP				=3D 0x00,
+	MLX5DR_STE_LU_TYPE_SRC_GVMI_AND_QP		=3D 0x05,
+	MLX5DR_STE_LU_TYPE_ETHL2_TUNNELING_I		=3D 0x0a,
+	MLX5DR_STE_LU_TYPE_ETHL2_DST_O			=3D 0x06,
+	MLX5DR_STE_LU_TYPE_ETHL2_DST_I			=3D 0x07,
+	MLX5DR_STE_LU_TYPE_ETHL2_DST_D			=3D 0x1b,
+	MLX5DR_STE_LU_TYPE_ETHL2_SRC_O			=3D 0x08,
+	MLX5DR_STE_LU_TYPE_ETHL2_SRC_I			=3D 0x09,
+	MLX5DR_STE_LU_TYPE_ETHL2_SRC_D			=3D 0x1c,
+	MLX5DR_STE_LU_TYPE_ETHL2_SRC_DST_O		=3D 0x36,
+	MLX5DR_STE_LU_TYPE_ETHL2_SRC_DST_I		=3D 0x37,
+	MLX5DR_STE_LU_TYPE_ETHL2_SRC_DST_D		=3D 0x38,
+	MLX5DR_STE_LU_TYPE_ETHL3_IPV6_DST_O		=3D 0x0d,
+	MLX5DR_STE_LU_TYPE_ETHL3_IPV6_DST_I		=3D 0x0e,
+	MLX5DR_STE_LU_TYPE_ETHL3_IPV6_DST_D		=3D 0x1e,
+	MLX5DR_STE_LU_TYPE_ETHL3_IPV6_SRC_O		=3D 0x0f,
+	MLX5DR_STE_LU_TYPE_ETHL3_IPV6_SRC_I		=3D 0x10,
+	MLX5DR_STE_LU_TYPE_ETHL3_IPV6_SRC_D		=3D 0x1f,
+	MLX5DR_STE_LU_TYPE_ETHL3_IPV4_5_TUPLE_O		=3D 0x11,
+	MLX5DR_STE_LU_TYPE_ETHL3_IPV4_5_TUPLE_I		=3D 0x12,
+	MLX5DR_STE_LU_TYPE_ETHL3_IPV4_5_TUPLE_D		=3D 0x20,
+	MLX5DR_STE_LU_TYPE_ETHL3_IPV4_MISC_O		=3D 0x29,
+	MLX5DR_STE_LU_TYPE_ETHL3_IPV4_MISC_I		=3D 0x2a,
+	MLX5DR_STE_LU_TYPE_ETHL3_IPV4_MISC_D		=3D 0x2b,
+	MLX5DR_STE_LU_TYPE_ETHL4_O			=3D 0x13,
+	MLX5DR_STE_LU_TYPE_ETHL4_I			=3D 0x14,
+	MLX5DR_STE_LU_TYPE_ETHL4_D			=3D 0x21,
+	MLX5DR_STE_LU_TYPE_ETHL4_MISC_O			=3D 0x2c,
+	MLX5DR_STE_LU_TYPE_ETHL4_MISC_I			=3D 0x2d,
+	MLX5DR_STE_LU_TYPE_ETHL4_MISC_D			=3D 0x2e,
+	MLX5DR_STE_LU_TYPE_MPLS_FIRST_O			=3D 0x15,
+	MLX5DR_STE_LU_TYPE_MPLS_FIRST_I			=3D 0x24,
+	MLX5DR_STE_LU_TYPE_MPLS_FIRST_D			=3D 0x25,
+	MLX5DR_STE_LU_TYPE_GRE				=3D 0x16,
+	MLX5DR_STE_LU_TYPE_FLEX_PARSER_0		=3D 0x22,
+	MLX5DR_STE_LU_TYPE_FLEX_PARSER_1		=3D 0x23,
+	MLX5DR_STE_LU_TYPE_FLEX_PARSER_TNL_HEADER	=3D 0x19,
+	MLX5DR_STE_LU_TYPE_GENERAL_PURPOSE		=3D 0x18,
+	MLX5DR_STE_LU_TYPE_STEERING_REGISTERS_0		=3D 0x2f,
+	MLX5DR_STE_LU_TYPE_STEERING_REGISTERS_1		=3D 0x30,
+	MLX5DR_STE_LU_TYPE_DONT_CARE			=3D 0x0f,
+};
+
+enum mlx5dr_ste_entry_type {
+	MLX5DR_STE_TYPE_TX		=3D 1,
+	MLX5DR_STE_TYPE_RX		=3D 2,
+	MLX5DR_STE_TYPE_MODIFY_PKT	=3D 6,
+};
+
+struct mlx5_ifc_ste_general_bits {
+	u8         entry_type[0x4];
+	u8         reserved_at_4[0x4];
+	u8         entry_sub_type[0x8];
+	u8         byte_mask[0x10];
+
+	u8         next_table_base_63_48[0x10];
+	u8         next_lu_type[0x8];
+	u8         next_table_base_39_32_size[0x8];
+
+	u8         next_table_base_31_5_size[0x1b];
+	u8         linear_hash_enable[0x1];
+	u8         reserved_at_5c[0x2];
+	u8         next_table_rank[0x2];
+
+	u8         reserved_at_60[0xa0];
+	u8         tag_value[0x60];
+	u8         bit_mask[0x60];
+};
+
+struct mlx5_ifc_ste_sx_transmit_bits {
+	u8         entry_type[0x4];
+	u8         reserved_at_4[0x4];
+	u8         entry_sub_type[0x8];
+	u8         byte_mask[0x10];
+
+	u8         next_table_base_63_48[0x10];
+	u8         next_lu_type[0x8];
+	u8         next_table_base_39_32_size[0x8];
+
+	u8         next_table_base_31_5_size[0x1b];
+	u8         linear_hash_enable[0x1];
+	u8         reserved_at_5c[0x2];
+	u8         next_table_rank[0x2];
+
+	u8         sx_wire[0x1];
+	u8         sx_func_lb[0x1];
+	u8         sx_sniffer[0x1];
+	u8         sx_wire_enable[0x1];
+	u8         sx_func_lb_enable[0x1];
+	u8         sx_sniffer_enable[0x1];
+	u8         action_type[0x3];
+	u8         reserved_at_69[0x1];
+	u8         action_description[0x6];
+	u8         gvmi[0x10];
+
+	u8         encap_pointer_vlan_data[0x20];
+
+	u8         loopback_syndome_en[0x8];
+	u8         loopback_syndome[0x8];
+	u8         counter_trigger[0x10];
+
+	u8         miss_address_63_48[0x10];
+	u8         counter_trigger_23_16[0x8];
+	u8         miss_address_39_32[0x8];
+
+	u8         miss_address_31_6[0x1a];
+	u8         learning_point[0x1];
+	u8         go_back[0x1];
+	u8         match_polarity[0x1];
+	u8         mask_mode[0x1];
+	u8         miss_rank[0x2];
+};
+
+struct mlx5_ifc_ste_rx_steering_mult_bits {
+	u8         entry_type[0x4];
+	u8         reserved_at_4[0x4];
+	u8         entry_sub_type[0x8];
+	u8         byte_mask[0x10];
+
+	u8         next_table_base_63_48[0x10];
+	u8         next_lu_type[0x8];
+	u8         next_table_base_39_32_size[0x8];
+
+	u8         next_table_base_31_5_size[0x1b];
+	u8         linear_hash_enable[0x1];
+	u8         reserved_at_[0x2];
+	u8         next_table_rank[0x2];
+
+	u8         member_count[0x10];
+	u8         gvmi[0x10];
+
+	u8         qp_list_pointer[0x20];
+
+	u8         reserved_at_a0[0x1];
+	u8         tunneling_action[0x3];
+	u8         action_description[0x4];
+	u8         reserved_at_a8[0x8];
+	u8         counter_trigger_15_0[0x10];
+
+	u8         miss_address_63_48[0x10];
+	u8         counter_trigger_23_16[0x08];
+	u8         miss_address_39_32[0x8];
+
+	u8         miss_address_31_6[0x1a];
+	u8         learning_point[0x1];
+	u8         fail_on_error[0x1];
+	u8         match_polarity[0x1];
+	u8         mask_mode[0x1];
+	u8         miss_rank[0x2];
+};
+
+struct mlx5_ifc_ste_modify_packet_bits {
+	u8         entry_type[0x4];
+	u8         reserved_at_4[0x4];
+	u8         entry_sub_type[0x8];
+	u8         byte_mask[0x10];
+
+	u8         next_table_base_63_48[0x10];
+	u8         next_lu_type[0x8];
+	u8         next_table_base_39_32_size[0x8];
+
+	u8         next_table_base_31_5_size[0x1b];
+	u8         linear_hash_enable[0x1];
+	u8         reserved_at_[0x2];
+	u8         next_table_rank[0x2];
+
+	u8         number_of_re_write_actions[0x10];
+	u8         gvmi[0x10];
+
+	u8         header_re_write_actions_pointer[0x20];
+
+	u8         reserved_at_a0[0x1];
+	u8         tunneling_action[0x3];
+	u8         action_description[0x4];
+	u8         reserved_at_a8[0x8];
+	u8         counter_trigger_15_0[0x10];
+
+	u8         miss_address_63_48[0x10];
+	u8         counter_trigger_23_16[0x08];
+	u8         miss_address_39_32[0x8];
+
+	u8         miss_address_31_6[0x1a];
+	u8         learning_point[0x1];
+	u8         fail_on_error[0x1];
+	u8         match_polarity[0x1];
+	u8         mask_mode[0x1];
+	u8         miss_rank[0x2];
+};
+
+struct mlx5_ifc_ste_eth_l2_src_bits {
+	u8         smac_47_16[0x20];
+
+	u8         smac_15_0[0x10];
+	u8         l3_ethertype[0x10];
+
+	u8         qp_type[0x2];
+	u8         ethertype_filter[0x1];
+	u8         reserved_at_43[0x1];
+	u8         sx_sniffer[0x1];
+	u8         force_lb[0x1];
+	u8         functional_lb[0x1];
+	u8         port[0x1];
+	u8         reserved_at_48[0x4];
+	u8         first_priority[0x3];
+	u8         first_cfi[0x1];
+	u8         first_vlan_qualifier[0x2];
+	u8         reserved_at_52[0x2];
+	u8         first_vlan_id[0xc];
+
+	u8         ip_fragmented[0x1];
+	u8         tcp_syn[0x1];
+	u8         encp_type[0x2];
+	u8         l3_type[0x2];
+	u8         l4_type[0x2];
+	u8         reserved_at_68[0x4];
+	u8         second_priority[0x3];
+	u8         second_cfi[0x1];
+	u8         second_vlan_qualifier[0x2];
+	u8         reserved_at_72[0x2];
+	u8         second_vlan_id[0xc];
+};
+
+struct mlx5_ifc_ste_eth_l2_dst_bits {
+	u8         dmac_47_16[0x20];
+
+	u8         dmac_15_0[0x10];
+	u8         l3_ethertype[0x10];
+
+	u8         qp_type[0x2];
+	u8         ethertype_filter[0x1];
+	u8         reserved_at_43[0x1];
+	u8         sx_sniffer[0x1];
+	u8         force_lb[0x1];
+	u8         functional_lb[0x1];
+	u8         port[0x1];
+	u8         reserved_at_48[0x4];
+	u8         first_priority[0x3];
+	u8         first_cfi[0x1];
+	u8         first_vlan_qualifier[0x2];
+	u8         reserved_at_52[0x2];
+	u8         first_vlan_id[0xc];
+
+	u8         ip_fragmented[0x1];
+	u8         tcp_syn[0x1];
+	u8         encp_type[0x2];
+	u8         l3_type[0x2];
+	u8         l4_type[0x2];
+	u8         reserved_at_68[0x4];
+	u8         second_priority[0x3];
+	u8         second_cfi[0x1];
+	u8         second_vlan_qualifier[0x2];
+	u8         reserved_at_72[0x2];
+	u8         second_vlan_id[0xc];
+};
+
+struct mlx5_ifc_ste_eth_l2_src_dst_bits {
+	u8         dmac_47_16[0x20];
+
+	u8         dmac_15_0[0x10];
+	u8         smac_47_32[0x10];
+
+	u8         smac_31_0[0x20];
+
+	u8         sx_sniffer[0x1];
+	u8         force_lb[0x1];
+	u8         functional_lb[0x1];
+	u8         port[0x1];
+	u8         l3_type[0x2];
+	u8         reserved_at_66[0x6];
+	u8         first_priority[0x3];
+	u8         first_cfi[0x1];
+	u8         first_vlan_qualifier[0x2];
+	u8         reserved_at_72[0x2];
+	u8         first_vlan_id[0xc];
+};
+
+struct mlx5_ifc_ste_eth_l3_ipv4_5_tuple_bits {
+	u8         destination_address[0x20];
+
+	u8         source_address[0x20];
+
+	u8         source_port[0x10];
+	u8         destination_port[0x10];
+
+	u8         fragmented[0x1];
+	u8         first_fragment[0x1];
+	u8         reserved_at_62[0x2];
+	u8         reserved_at_64[0x1];
+	u8         ecn[0x2];
+	u8         tcp_ns[0x1];
+	u8         tcp_cwr[0x1];
+	u8         tcp_ece[0x1];
+	u8         tcp_urg[0x1];
+	u8         tcp_ack[0x1];
+	u8         tcp_psh[0x1];
+	u8         tcp_rst[0x1];
+	u8         tcp_syn[0x1];
+	u8         tcp_fin[0x1];
+	u8         dscp[0x6];
+	u8         reserved_at_76[0x2];
+	u8         protocol[0x8];
+};
+
+struct mlx5_ifc_ste_eth_l3_ipv6_dst_bits {
+	u8         dst_ip_127_96[0x20];
+
+	u8         dst_ip_95_64[0x20];
+
+	u8         dst_ip_63_32[0x20];
+
+	u8         dst_ip_31_0[0x20];
+};
+
+struct mlx5_ifc_ste_eth_l2_tnl_bits {
+	u8         dmac_47_16[0x20];
+
+	u8         dmac_15_0[0x10];
+	u8         l3_ethertype[0x10];
+
+	u8         l2_tunneling_network_id[0x20];
+
+	u8         ip_fragmented[0x1];
+	u8         tcp_syn[0x1];
+	u8         encp_type[0x2];
+	u8         l3_type[0x2];
+	u8         l4_type[0x2];
+	u8         first_priority[0x3];
+	u8         first_cfi[0x1];
+	u8         reserved_at_6c[0x3];
+	u8         gre_key_flag[0x1];
+	u8         first_vlan_qualifier[0x2];
+	u8         reserved_at_72[0x2];
+	u8         first_vlan_id[0xc];
+};
+
+struct mlx5_ifc_ste_eth_l3_ipv6_src_bits {
+	u8         src_ip_127_96[0x20];
+
+	u8         src_ip_95_64[0x20];
+
+	u8         src_ip_63_32[0x20];
+
+	u8         src_ip_31_0[0x20];
+};
+
+struct mlx5_ifc_ste_eth_l3_ipv4_misc_bits {
+	u8         version[0x4];
+	u8         ihl[0x4];
+	u8         reserved_at_8[0x8];
+	u8         total_length[0x10];
+
+	u8         identification[0x10];
+	u8         flags[0x3];
+	u8         fragment_offset[0xd];
+
+	u8         time_to_live[0x8];
+	u8         reserved_at_48[0x8];
+	u8         checksum[0x10];
+
+	u8         reserved_at_60[0x20];
+};
+
+struct mlx5_ifc_ste_eth_l4_bits {
+	u8         fragmented[0x1];
+	u8         first_fragment[0x1];
+	u8         reserved_at_2[0x6];
+	u8         protocol[0x8];
+	u8         dst_port[0x10];
+
+	u8         ipv6_version[0x4];
+	u8         reserved_at_24[0x1];
+	u8         ecn[0x2];
+	u8         tcp_ns[0x1];
+	u8         tcp_cwr[0x1];
+	u8         tcp_ece[0x1];
+	u8         tcp_urg[0x1];
+	u8         tcp_ack[0x1];
+	u8         tcp_psh[0x1];
+	u8         tcp_rst[0x1];
+	u8         tcp_syn[0x1];
+	u8         tcp_fin[0x1];
+	u8         src_port[0x10];
+
+	u8         ipv6_payload_length[0x10];
+	u8         ipv6_hop_limit[0x8];
+	u8         dscp[0x6];
+	u8         reserved_at_5e[0x2];
+
+	u8         tcp_data_offset[0x4];
+	u8         reserved_at_64[0x8];
+	u8         flow_label[0x14];
+};
+
+struct mlx5_ifc_ste_eth_l4_misc_bits {
+	u8         checksum[0x10];
+	u8         length[0x10];
+
+	u8         seq_num[0x20];
+
+	u8         ack_num[0x20];
+
+	u8         urgent_pointer[0x10];
+	u8         window_size[0x10];
+};
+
+struct mlx5_ifc_ste_mpls_bits {
+	u8         mpls0_label[0x14];
+	u8         mpls0_exp[0x3];
+	u8         mpls0_s_bos[0x1];
+	u8         mpls0_ttl[0x8];
+
+	u8         mpls1_label[0x20];
+
+	u8         mpls2_label[0x20];
+
+	u8         reserved_at_60[0x16];
+	u8         mpls4_s_bit[0x1];
+	u8         mpls4_qualifier[0x1];
+	u8         mpls3_s_bit[0x1];
+	u8         mpls3_qualifier[0x1];
+	u8         mpls2_s_bit[0x1];
+	u8         mpls2_qualifier[0x1];
+	u8         mpls1_s_bit[0x1];
+	u8         mpls1_qualifier[0x1];
+	u8         mpls0_s_bit[0x1];
+	u8         mpls0_qualifier[0x1];
+};
+
+struct mlx5_ifc_ste_register_0_bits {
+	u8         register_0_h[0x20];
+
+	u8         register_0_l[0x20];
+
+	u8         register_1_h[0x20];
+
+	u8         register_1_l[0x20];
+};
+
+struct mlx5_ifc_ste_register_1_bits {
+	u8         register_2_h[0x20];
+
+	u8         register_2_l[0x20];
+
+	u8         register_3_h[0x20];
+
+	u8         register_3_l[0x20];
+};
+
+struct mlx5_ifc_ste_gre_bits {
+	u8         gre_c_present[0x1];
+	u8         reserved_at_30[0x1];
+	u8         gre_k_present[0x1];
+	u8         gre_s_present[0x1];
+	u8         strict_src_route[0x1];
+	u8         recur[0x3];
+	u8         flags[0x5];
+	u8         version[0x3];
+	u8         gre_protocol[0x10];
+
+	u8         checksum[0x10];
+	u8         offset[0x10];
+
+	u8         gre_key_h[0x18];
+	u8         gre_key_l[0x8];
+
+	u8         seq_num[0x20];
+};
+
+struct mlx5_ifc_ste_flex_parser_0_bits {
+	u8         parser_3_label[0x14];
+	u8         parser_3_exp[0x3];
+	u8         parser_3_s_bos[0x1];
+	u8         parser_3_ttl[0x8];
+
+	u8         flex_parser_2[0x20];
+
+	u8         flex_parser_1[0x20];
+
+	u8         flex_parser_0[0x20];
+};
+
+struct mlx5_ifc_ste_flex_parser_1_bits {
+	u8         flex_parser_7[0x20];
+
+	u8         flex_parser_6[0x20];
+
+	u8         flex_parser_5[0x20];
+
+	u8         flex_parser_4[0x20];
+};
+
+struct mlx5_ifc_ste_flex_parser_tnl_bits {
+	u8         flex_parser_tunneling_header_63_32[0x20];
+
+	u8         flex_parser_tunneling_header_31_0[0x20];
+
+	u8         reserved_at_40[0x40];
+};
+
+struct mlx5_ifc_ste_general_purpose_bits {
+	u8         general_purpose_lookup_field[0x20];
+
+	u8         reserved_at_20[0x20];
+
+	u8         reserved_at_40[0x20];
+
+	u8         reserved_at_60[0x20];
+};
+
+struct mlx5_ifc_ste_src_gvmi_qp_bits {
+	u8         loopback_syndrome[0x8];
+	u8         reserved_at_8[0x8];
+	u8         source_gvmi[0x10];
+
+	u8         reserved_at_20[0x5];
+	u8         force_lb[0x1];
+	u8         functional_lb[0x1];
+	u8         source_is_requestor[0x1];
+	u8         source_qp[0x18];
+
+	u8         reserved_at_40[0x20];
+
+	u8         reserved_at_60[0x20];
+};
+
+struct mlx5_ifc_l2_hdr_bits {
+	u8         dmac_47_16[0x20];
+
+	u8         dmac_15_0[0x10];
+	u8         smac_47_32[0x10];
+
+	u8         smac_31_0[0x20];
+
+	u8         ethertype[0x10];
+	u8         vlan_type[0x10];
+
+	u8         vlan[0x10];
+	u8         reserved_at_90[0x10];
+};
+
+/* Both HW set and HW add share the same HW format with different opcodes =
*/
+struct mlx5_ifc_dr_action_hw_set_bits {
+	u8         opcode[0x8];
+	u8         destination_field_code[0x8];
+	u8         reserved_at_10[0x2];
+	u8         destination_left_shifter[0x6];
+	u8         reserved_at_18[0x3];
+	u8         destination_length[0x5];
+
+	u8         inline_data[0x20];
+};
+
+#endif /* MLX5_IFC_DR_H */
--=20
2.21.0

