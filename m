Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E633E14620B
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 07:40:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726871AbgAWGj6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 01:39:58 -0500
Received: from mail-eopbgr80074.outbound.protection.outlook.com ([40.107.8.74]:3150
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725818AbgAWGj5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Jan 2020 01:39:57 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=do1RsLMM88AWvhJVewccDdnpHvX+FI1/cJFPh/DLGImektkthxVVZ0FWzP2hTH09bUelOZQNjfgflgIGvILq1WwFBxsjk8nbQQSYqZg7gVENagJzp6F+QmZxsgtGRrr6m42xi9VDJkhY0leKNGFhr+X5O+v/0ijWm4qSSPuEB+5ULGaV5CBYxWhhOR3tSVWv4VtGD6dTC5vNIuuy6G9eXobaHB4EjPYgq8W6p2HqIxjrlpj3iZvaDK6v03vFBlB/XePfSvjXGEjVwm8zz8HGqeFqYmUwMcwmgdk1qj3R8zpqoQ8Bc/MAHza6HPBEvFbue5sL4KjatQu546acz9AAIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TfmZRHUQfyT9aGkEgR6uFOJ8QtBPClUYCmzkP5trYe4=;
 b=QBSZN9lNhOA32TxsxXDMJF7biVcChFGcr9eltwU3Ty27PFoSY/jhLzA2KKA0uWARVI7Ipxh8EfObnXIuGNkP0L4sw8xWhupWfF9AFLj773Qh0enJhwTNIlxDahrI2s3qSA5tpwtEAWsbxDYDg0Fnez9nB7BV1WsAee3Yi/oNSLN4tAH9CKwaBYFQYVIFrUVUOczd9vwWI+s2gJOfKyaSsaM7RxZoKZo6AefBSwKaE/aI/ct7+OjXuQyu3+GixSMNfgTnLmuBa8rj5NE3Oy/o1rcitMLmqL93tt56ca3zm120yU5lnDJQZyWaLv5bZqvNZ1TP7n63U2t38/dGXZ/KoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TfmZRHUQfyT9aGkEgR6uFOJ8QtBPClUYCmzkP5trYe4=;
 b=egR2ViTkgpoioaXG45L1UqceszwIPVATwzLIpHCw2HnpxUBs+YFJuWs5jc7yCJ4aUaccfYCRLoIbsJQxPXqxvJGDJMgOzynb4tANU4E3x5CJs7oMyPxWXeJxroKylTQtj8os+Ju/zxrLIhW4URW/CRNv9zGAe6Q8lBd5Xpq8aFY=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB4941.eurprd05.prod.outlook.com (20.177.48.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.20; Thu, 23 Jan 2020 06:39:48 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096%6]) with mapi id 15.20.2644.027; Thu, 23 Jan 2020
 06:39:48 +0000
Received: from smtp.office365.com (73.15.39.150) by BYAPR21CA0027.namprd21.prod.outlook.com (2603:10b6:a03:114::37) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2686.5 via Frontend Transport; Thu, 23 Jan 2020 06:39:46 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Hamdan Igbaria <hamdani@mellanox.com>,
        Alex Vesker <valex@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 06/15] net/mlx5: DR, Modify header copy support
Thread-Topic: [net-next 06/15] net/mlx5: DR, Modify header copy support
Thread-Index: AQHV0bfoU9bkj4EolEiPLVUTVRx1Mg==
Date:   Thu, 23 Jan 2020 06:39:47 +0000
Message-ID: <20200123063827.685230-7-saeedm@mellanox.com>
References: <20200123063827.685230-1-saeedm@mellanox.com>
In-Reply-To: <20200123063827.685230-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.24.1
x-originating-ip: [73.15.39.150]
x-clientproxiedby: BYAPR21CA0027.namprd21.prod.outlook.com
 (2603:10b6:a03:114::37) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: f0fb5e57-b665-4b4f-fae4-08d79fcf0a4e
x-ms-traffictypediagnostic: VI1PR05MB4941:|VI1PR05MB4941:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB49411FD6C35697BCE5099C17BE0F0@VI1PR05MB4941.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2399;
x-forefront-prvs: 029174C036
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(396003)(39860400002)(376002)(346002)(366004)(199004)(189003)(5660300002)(107886003)(8936002)(6916009)(81166006)(81156014)(8676002)(186003)(6512007)(6486002)(4326008)(86362001)(1076003)(16526019)(71200400001)(26005)(36756003)(52116002)(6506007)(2906002)(66946007)(2616005)(66556008)(956004)(64756008)(66446008)(316002)(478600001)(54906003)(66476007)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4941;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7CW8NrD0c1/7JRlIVdL5XCzXIFLj9aOlmpvlBCL1H7Wl6JgtfII0X0+JxMNRoKbWsEstq40TIlSwYgdqlR49+wIKvyl5ORjFYlkMbZpy+e5UXhFk7iP9RHy6A6S3Mfxf4a/+jwcPxShQyo35CL4xhkxYHxRas6LCtfJFiIsG1ff/3nsAhnVANNFkyAtrOfSikqCMIACSVUfttd6Kv5Qd0oxpATQFpeJf8j2WzrUIQUo/pF7ReKznACO1z+BjwylpsD83+sFcj9xU+T0rj7Ryuevb4HLkIVyrb8xLcAG+Z9kwbUlPCvpIFvW7TAMygHifGzn5jeYX1VkeqRbkImTIDIVXbikkdBNXkgu9M3pkllptaXKWgbmoxTxwslnuR+o6nQrHdkAp15pRhECTj79l3PL1PSn49XbPGTEQaDZiCIWZ3h/QcCtYpLT1FW+JOiM/NDrW+N5zQIrqR5nb8JDNelN6tAd/jLl8wb3HwTYc2ypdTX3mEJol6MDfDYbBXZHCva6JlHVsECv6EqC5jyw/VDmi0RiMhFtfLfD2p1hnV20=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f0fb5e57-b665-4b4f-fae4-08d79fcf0a4e
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jan 2020 06:39:47.9637
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZJVdxAQ+9H/1l9mPTYACk0Sz2+GcO48NlPFuacn6gzEpvLHjy4Dhm1rly3KL8o4J5LtgX004COyj2THz+TnsTQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4941
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hamdan Igbaria <hamdani@mellanox.com>

Modify header supports ADD/SET and from this patch
also COPY. Copy allows to copy header fields and
metadata.

Signed-off-by: Hamdan Igbaria <hamdani@mellanox.com>
Signed-off-by: Alex Vesker <valex@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../mellanox/mlx5/core/steering/dr_action.c   | 150 ++++++++++++++++--
 .../mellanox/mlx5/core/steering/mlx5_ifc_dr.h |  16 ++
 2 files changed, 151 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c b=
/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
index ad32b88a83dc..286fcec5eff2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
@@ -1410,16 +1410,83 @@ dr_action_modify_sw_to_hw_set(struct mlx5dr_domain =
*dmn,
 	return 0;
 }
=20
+static int
+dr_action_modify_sw_to_hw_copy(struct mlx5dr_domain *dmn,
+			       __be64 *sw_action,
+			       __be64 *hw_action,
+			       const struct dr_action_modify_field_conv **ret_dst_hw_info,
+			       const struct dr_action_modify_field_conv **ret_src_hw_info)
+{
+	u8 src_offset, dst_offset, src_max_length, dst_max_length, length;
+	const struct dr_action_modify_field_conv *hw_dst_action_info;
+	const struct dr_action_modify_field_conv *hw_src_action_info;
+	u16 src_field, dst_field;
+
+	/* Get SW modify action data */
+	src_field =3D MLX5_GET(copy_action_in, sw_action, src_field);
+	dst_field =3D MLX5_GET(copy_action_in, sw_action, dst_field);
+	src_offset =3D MLX5_GET(copy_action_in, sw_action, src_offset);
+	dst_offset =3D MLX5_GET(copy_action_in, sw_action, dst_offset);
+	length =3D MLX5_GET(copy_action_in, sw_action, length);
+
+	/* Convert SW data to HW modify action format */
+	hw_src_action_info =3D dr_action_modify_get_hw_info(src_field);
+	hw_dst_action_info =3D dr_action_modify_get_hw_info(dst_field);
+	if (!hw_src_action_info || !hw_dst_action_info) {
+		mlx5dr_dbg(dmn, "Modify copy action invalid field given\n");
+		return -EINVAL;
+	}
+
+	/* PRM defines that length zero specific length of 32bits */
+	length =3D length ? length : 32;
+
+	src_max_length =3D hw_src_action_info->end -
+			 hw_src_action_info->start + 1;
+	dst_max_length =3D hw_dst_action_info->end -
+			 hw_dst_action_info->start + 1;
+
+	if (length + src_offset > src_max_length ||
+	    length + dst_offset > dst_max_length) {
+		mlx5dr_dbg(dmn, "Modify action length + offset exceeds limit\n");
+		return -EINVAL;
+	}
+
+	MLX5_SET(dr_action_hw_copy, hw_action,
+		 opcode, MLX5DR_ACTION_MDFY_HW_OP_COPY);
+
+	MLX5_SET(dr_action_hw_copy, hw_action, destination_field_code,
+		 hw_dst_action_info->hw_field);
+
+	MLX5_SET(dr_action_hw_copy, hw_action, destination_left_shifter,
+		 hw_dst_action_info->start + dst_offset);
+
+	MLX5_SET(dr_action_hw_copy, hw_action, destination_length,
+		 length =3D=3D 32 ? 0 : length);
+
+	MLX5_SET(dr_action_hw_copy, hw_action, source_field_code,
+		 hw_src_action_info->hw_field);
+
+	MLX5_SET(dr_action_hw_copy, hw_action, source_left_shifter,
+		 hw_src_action_info->start + dst_offset);
+
+	*ret_dst_hw_info =3D hw_dst_action_info;
+	*ret_src_hw_info =3D hw_src_action_info;
+
+	return 0;
+}
+
 static int
 dr_action_modify_sw_to_hw(struct mlx5dr_domain *dmn,
 			  __be64 *sw_action,
 			  __be64 *hw_action,
-			  const struct dr_action_modify_field_conv **ret_hw_info)
+			  const struct dr_action_modify_field_conv **ret_dst_hw_info,
+			  const struct dr_action_modify_field_conv **ret_src_hw_info)
 {
 	u8 action;
 	int ret;
=20
 	*hw_action =3D 0;
+	*ret_src_hw_info =3D NULL;
=20
 	/* Get SW modify action type */
 	action =3D MLX5_GET(set_action_in, sw_action, action_type);
@@ -1428,13 +1495,20 @@ dr_action_modify_sw_to_hw(struct mlx5dr_domain *dmn=
,
 	case MLX5_ACTION_TYPE_SET:
 		ret =3D dr_action_modify_sw_to_hw_set(dmn, sw_action,
 						    hw_action,
-						    ret_hw_info);
+						    ret_dst_hw_info);
 		break;
=20
 	case MLX5_ACTION_TYPE_ADD:
 		ret =3D dr_action_modify_sw_to_hw_add(dmn, sw_action,
 						    hw_action,
-						    ret_hw_info);
+						    ret_dst_hw_info);
+		break;
+
+	case MLX5_ACTION_TYPE_COPY:
+		ret =3D dr_action_modify_sw_to_hw_copy(dmn, sw_action,
+						     hw_action,
+						     ret_dst_hw_info,
+						     ret_src_hw_info);
 		break;
=20
 	default:
@@ -1495,6 +1569,43 @@ dr_action_modify_check_add_field_limitation(struct m=
lx5dr_action *action,
 	return 0;
 }
=20
+static int
+dr_action_modify_check_copy_field_limitation(struct mlx5dr_action *action,
+					     const __be64 *sw_action)
+{
+	struct mlx5dr_domain *dmn =3D action->rewrite.dmn;
+	u16 sw_fields[2];
+	int i;
+
+	sw_fields[0] =3D MLX5_GET(copy_action_in, sw_action, src_field);
+	sw_fields[1] =3D MLX5_GET(copy_action_in, sw_action, dst_field);
+
+	for (i =3D 0; i < 2; i++) {
+		if (sw_fields[i] =3D=3D MLX5_ACTION_IN_FIELD_METADATA_REG_A) {
+			action->rewrite.allow_rx =3D 0;
+			if (dmn->type !=3D MLX5DR_DOMAIN_TYPE_NIC_TX) {
+				mlx5dr_dbg(dmn, "Unsupported field %d for RX/FDB set action\n",
+					   sw_fields[i]);
+				return -EINVAL;
+			}
+		} else if (sw_fields[i] =3D=3D MLX5_ACTION_IN_FIELD_METADATA_REG_B) {
+			action->rewrite.allow_tx =3D 0;
+			if (dmn->type !=3D MLX5DR_DOMAIN_TYPE_NIC_RX) {
+				mlx5dr_dbg(dmn, "Unsupported field %d for TX/FDB set action\n",
+					   sw_fields[i]);
+				return -EINVAL;
+			}
+		}
+	}
+
+	if (!action->rewrite.allow_rx && !action->rewrite.allow_tx) {
+		mlx5dr_dbg(dmn, "Modify copy actions not supported on both RX and TX\n")=
;
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 static int
 dr_action_modify_check_field_limitation(struct mlx5dr_action *action,
 					const __be64 *sw_action)
@@ -1516,6 +1627,11 @@ dr_action_modify_check_field_limitation(struct mlx5d=
r_action *action,
 								  sw_action);
 		break;
=20
+	case MLX5_ACTION_TYPE_COPY:
+		ret =3D dr_action_modify_check_copy_field_limitation(action,
+								   sw_action);
+		break;
+
 	default:
 		mlx5dr_info(dmn, "Unsupported action %d modify action\n",
 			    action_type);
@@ -1541,7 +1657,8 @@ static int dr_actions_convert_modify_header(struct ml=
x5dr_action *action,
 					    u32 *num_hw_actions,
 					    bool *modify_ttl)
 {
-	const struct dr_action_modify_field_conv *hw_action_info;
+	const struct dr_action_modify_field_conv *hw_dst_action_info;
+	const struct dr_action_modify_field_conv *hw_src_action_info;
 	u16 hw_field =3D MLX5DR_ACTION_MDFY_HW_FLD_RESERVED;
 	u32 l3_type =3D MLX5DR_ACTION_MDFY_HW_HDR_L3_NONE;
 	u32 l4_type =3D MLX5DR_ACTION_MDFY_HW_HDR_L4_NONE;
@@ -1570,32 +1687,35 @@ static int dr_actions_convert_modify_header(struct =
mlx5dr_action *action,
 		ret =3D dr_action_modify_sw_to_hw(dmn,
 						sw_action,
 						&hw_action,
-						&hw_action_info);
+						&hw_dst_action_info,
+						&hw_src_action_info);
 		if (ret)
 			return ret;
=20
 		/* Due to a HW limitation we cannot modify 2 different L3 types */
-		if (l3_type && hw_action_info->l3_type &&
-		    hw_action_info->l3_type !=3D l3_type) {
+		if (l3_type && hw_dst_action_info->l3_type &&
+		    hw_dst_action_info->l3_type !=3D l3_type) {
 			mlx5dr_dbg(dmn, "Action list can't support two different L3 types\n");
 			return -EINVAL;
 		}
-		if (hw_action_info->l3_type)
-			l3_type =3D hw_action_info->l3_type;
+		if (hw_dst_action_info->l3_type)
+			l3_type =3D hw_dst_action_info->l3_type;
=20
 		/* Due to a HW limitation we cannot modify two different L4 types */
-		if (l4_type && hw_action_info->l4_type &&
-		    hw_action_info->l4_type !=3D l4_type) {
+		if (l4_type && hw_dst_action_info->l4_type &&
+		    hw_dst_action_info->l4_type !=3D l4_type) {
 			mlx5dr_dbg(dmn, "Action list can't support two different L4 types\n");
 			return -EINVAL;
 		}
-		if (hw_action_info->l4_type)
-			l4_type =3D hw_action_info->l4_type;
+		if (hw_dst_action_info->l4_type)
+			l4_type =3D hw_dst_action_info->l4_type;
=20
 		/* HW reads and executes two actions at once this means we
 		 * need to create a gap if two actions access the same field
 		 */
-		if ((hw_idx % 2) && hw_field =3D=3D hw_action_info->hw_field) {
+		if ((hw_idx % 2) && (hw_field =3D=3D hw_dst_action_info->hw_field ||
+				     (hw_src_action_info &&
+				      hw_field =3D=3D hw_src_action_info->hw_field))) {
 			/* Check if after gap insertion the total number of HW
 			 * modify actions doesn't exceeds the limit
 			 */
@@ -1605,7 +1725,7 @@ static int dr_actions_convert_modify_header(struct ml=
x5dr_action *action,
 				return -EINVAL;
 			}
 		}
-		hw_field =3D hw_action_info->hw_field;
+		hw_field =3D hw_dst_action_info->hw_field;
=20
 		hw_actions[hw_idx] =3D hw_action;
 		hw_idx++;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5_ifc_dr.h=
 b/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5_ifc_dr.h
index 1722f4668269..e01c3766c7de 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5_ifc_dr.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5_ifc_dr.h
@@ -32,6 +32,7 @@ enum {
 };
=20
 enum {
+	MLX5DR_ACTION_MDFY_HW_OP_COPY		=3D 0x1,
 	MLX5DR_ACTION_MDFY_HW_OP_SET		=3D 0x2,
 	MLX5DR_ACTION_MDFY_HW_OP_ADD		=3D 0x3,
 };
@@ -625,4 +626,19 @@ struct mlx5_ifc_dr_action_hw_set_bits {
 	u8         inline_data[0x20];
 };
=20
+struct mlx5_ifc_dr_action_hw_copy_bits {
+	u8         opcode[0x8];
+	u8         destination_field_code[0x8];
+	u8         reserved_at_10[0x2];
+	u8         destination_left_shifter[0x6];
+	u8         reserved_at_18[0x2];
+	u8         destination_length[0x6];
+
+	u8         reserved_at_20[0x8];
+	u8         source_field_code[0x8];
+	u8         reserved_at_30[0x2];
+	u8         source_left_shifter[0x6];
+	u8         reserved_at_38[0x8];
+};
+
 #endif /* MLX5_IFC_DR_H */
--=20
2.24.1

