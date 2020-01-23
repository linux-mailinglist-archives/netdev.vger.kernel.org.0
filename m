Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F98514620A
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 07:39:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726772AbgAWGjy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 01:39:54 -0500
Received: from mail-eopbgr80074.outbound.protection.outlook.com ([40.107.8.74]:3150
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726376AbgAWGjy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Jan 2020 01:39:54 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NVSAcEHWPLSWRT7uzZeNOCySEyErLMyJMdBtqpJFilSNCxyzqNicPwJf5qkWZvoVjXBF78/ws4bVFG/s5PJCuYv8Q9W81RQ8aQkGociyc0p9to+N95qa+H6imRNX1cpq+bCqzJU1x04EiIowwvZcmO9c3G5ROmpj6RJs8+TW/s0tDDRZ5Y/wmISJsWJ9ACwwEnXXADRyg+pQ+672SijmHOQs9WNMqOYAOLvbi8NYwUXynUFK2Ht1PWWz9W9N1DlweoNXvvNhpfHeQyx4erooXB9BJEF1o5e4e9H33rZD4E34Hh7tDh+OEBiFYfUFb5dAY6ESNUn7UFSYzMjIdd8fog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P31ROFjMN0P6ODKvCwSOpK9odaIckw+VVYzQSIkYPWc=;
 b=D8USA9VP+F1C6AiSufkVuaDwwfc3W1vBKmbe6zcBtqHUa8g+mIMccd8yfRYrx6QH8sojpajPcOyPCETRCMrRZ1Q3D03tEe64dX/9jqasRo6kSN9ps37RgN8jwZrPxalusIFLtIP9++VpAQ3ygVjGY1P5Ft/1h6SmHn/5cSRi9T9EXgJBnn9XpnKLe5PmoYi6GmrlBRUiWM+rBPyCcctxh0vIjBFpk4EUPSj2mVZozkpDUKWlSIIhahzE+LdoQEnUjvaDLW7fNT1+ft3XQGGQChkaiaoyXavGJsetzLkndyJhmORkt8zm7EciAxZ6r7aOtlN6/lbm1CSc9bDrey2WzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P31ROFjMN0P6ODKvCwSOpK9odaIckw+VVYzQSIkYPWc=;
 b=GYxWqvdj1/7/kipyu7jxuBLLfFxzHVY/8WnOazdN3mYGekesGW3/Hd/YSuzlxDMbPCEScZ+iDrneTuVXlSgXs9Izvtpk5qRqOkm8jmepLAlEu9U4euYm+itcLg06uO/It09yPD9olcioNPet4xD0JsA88Ga2C/doahCajSnCNJY=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB4941.eurprd05.prod.outlook.com (20.177.48.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.20; Thu, 23 Jan 2020 06:39:46 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096%6]) with mapi id 15.20.2644.027; Thu, 23 Jan 2020
 06:39:46 +0000
Received: from smtp.office365.com (73.15.39.150) by BYAPR21CA0027.namprd21.prod.outlook.com (2603:10b6:a03:114::37) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2686.5 via Frontend Transport; Thu, 23 Jan 2020 06:39:43 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Hamdan Igbaria <hamdani@mellanox.com>,
        Alex Vesker <valex@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 05/15] net/mlx5: DR, Modify set action limitation extension
Thread-Topic: [net-next 05/15] net/mlx5: DR, Modify set action limitation
 extension
Thread-Index: AQHV0bfmwCBVG8I/lUasEdUP6HGs1Q==
Date:   Thu, 23 Jan 2020 06:39:45 +0000
Message-ID: <20200123063827.685230-6-saeedm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: 78359c68-4881-4b77-9e20-08d79fcf08b2
x-ms-traffictypediagnostic: VI1PR05MB4941:|VI1PR05MB4941:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB494161CEFB1296160E8E4656BE0F0@VI1PR05MB4941.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2000;
x-forefront-prvs: 029174C036
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(396003)(39860400002)(376002)(346002)(366004)(199004)(189003)(5660300002)(107886003)(8936002)(6916009)(81166006)(81156014)(8676002)(186003)(6512007)(6486002)(4326008)(86362001)(1076003)(16526019)(71200400001)(26005)(36756003)(52116002)(6506007)(2906002)(66946007)(2616005)(66556008)(956004)(64756008)(66446008)(316002)(478600001)(54906003)(66476007)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4941;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: cRMTx9BuyDht1UsN2TNQ4pbJrzl4dECkuH2TRbu8QstOFrdxdAVCAbIGSsVMoS6NWLoqK8ZwU4K6h9C1LeeUrcWpXprfnZXGOalucrTm2swtgVUGNZbkoFT6LXVMpZ8caGERfkdkGvJPlopQWFZeZTHOocE9Od3Cx7xuyL9cPGALojlfP5TSIOpDYyhIgZKxic+iM1EvN8SdoiJGEclm0w2p9cc/vbzb6weO/7SetdhOqvptU5r0pbKYNlAESh0Hl4e4wZ8XIZb03FO7WwdNkwJLtWz1DXAIMfUQGGnVxe9+V+eHuW2ZH0YnxJXYqoZiS9p0ARn+gjhKFXdHqWVopnZnkWn9u4AXDKS+OuH2TQH7KjRSfzGhCPfQo90M0KlZLS6KIQp3ei9oG/OTpj2CFOb4MvSqLHyiPHcpzwCpuBGeHEORflsWs+LZ357ZLUKsoffgRbVGNx22KhuUuj8g/+b+/2l6jr8Zhube97V7o0Sy/TNSma3Fqb52NY0X/a+G7NQb91CvLXwDtIz9pqi0DbmUwG75qcabRn/bEezgQmo=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 78359c68-4881-4b77-9e20-08d79fcf08b2
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jan 2020 06:39:45.6340
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iCRUVsjE4ek1xzLACQ49Xge/4Z9+vqdlhBLZ8gWI7iIr2o7UZz67SsZnnMkjnPVH6xQ6uPab1daHsIc3AkVdcw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4941
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hamdan Igbaria <hamdani@mellanox.com>

Modify set actions are not supported on both tx
and rx, added a check for that.
Also refactored the code in a way that every modify
action has his own functions, this needed so in the
future we could add copy action more smoothly.

Signed-off-by: Hamdan Igbaria <hamdani@mellanox.com>
Signed-off-by: Alex Vesker <valex@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../mellanox/mlx5/core/steering/dr_action.c   | 226 +++++++++++++-----
 1 file changed, 165 insertions(+), 61 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c b=
/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
index 9359eed10889..ad32b88a83dc 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
@@ -1314,58 +1314,85 @@ dr_action_modify_get_hw_info(u16 sw_field)
 }
=20
 static int
-dr_action_modify_sw_to_hw(struct mlx5dr_domain *dmn,
-			  __be64 *sw_action,
-			  __be64 *hw_action,
-			  const struct dr_action_modify_field_conv **ret_hw_info)
+dr_action_modify_sw_to_hw_add(struct mlx5dr_domain *dmn,
+			      __be64 *sw_action,
+			      __be64 *hw_action,
+			      const struct dr_action_modify_field_conv **ret_hw_info)
 {
 	const struct dr_action_modify_field_conv *hw_action_info;
-	u8 offset, length, max_length, action;
+	u8 max_length;
 	u16 sw_field;
-	u8 hw_opcode;
 	u32 data;
=20
 	/* Get SW modify action data */
-	action =3D MLX5_GET(set_action_in, sw_action, action_type);
-	length =3D MLX5_GET(set_action_in, sw_action, length);
-	offset =3D MLX5_GET(set_action_in, sw_action, offset);
 	sw_field =3D MLX5_GET(set_action_in, sw_action, field);
 	data =3D MLX5_GET(set_action_in, sw_action, data);
=20
 	/* Convert SW data to HW modify action format */
 	hw_action_info =3D dr_action_modify_get_hw_info(sw_field);
 	if (!hw_action_info) {
-		mlx5dr_dbg(dmn, "Modify action invalid field given\n");
+		mlx5dr_dbg(dmn, "Modify add action invalid field given\n");
 		return -EINVAL;
 	}
=20
 	max_length =3D hw_action_info->end - hw_action_info->start + 1;
=20
-	switch (action) {
-	case MLX5_ACTION_TYPE_SET:
-		hw_opcode =3D MLX5DR_ACTION_MDFY_HW_OP_SET;
-		/* PRM defines that length zero specific length of 32bits */
-		if (!length)
-			length =3D 32;
+	MLX5_SET(dr_action_hw_set, hw_action,
+		 opcode, MLX5DR_ACTION_MDFY_HW_OP_ADD);
=20
-		if (length + offset > max_length) {
-			mlx5dr_dbg(dmn, "Modify action length + offset exceeds limit\n");
-			return -EINVAL;
-		}
-		break;
+	MLX5_SET(dr_action_hw_set, hw_action, destination_field_code,
+		 hw_action_info->hw_field);
=20
-	case MLX5_ACTION_TYPE_ADD:
-		hw_opcode =3D MLX5DR_ACTION_MDFY_HW_OP_ADD;
-		offset =3D 0;
-		length =3D max_length;
-		break;
+	MLX5_SET(dr_action_hw_set, hw_action, destination_left_shifter,
+		 hw_action_info->start);
=20
-	default:
-		mlx5dr_info(dmn, "Unsupported action_type for modify action\n");
-		return -EOPNOTSUPP;
+	/* PRM defines that length zero specific length of 32bits */
+	MLX5_SET(dr_action_hw_set, hw_action, destination_length,
+		 max_length =3D=3D 32 ? 0 : max_length);
+
+	MLX5_SET(dr_action_hw_set, hw_action, inline_data, data);
+
+	*ret_hw_info =3D hw_action_info;
+
+	return 0;
+}
+
+static int
+dr_action_modify_sw_to_hw_set(struct mlx5dr_domain *dmn,
+			      __be64 *sw_action,
+			      __be64 *hw_action,
+			      const struct dr_action_modify_field_conv **ret_hw_info)
+{
+	const struct dr_action_modify_field_conv *hw_action_info;
+	u8 offset, length, max_length;
+	u16 sw_field;
+	u32 data;
+
+	/* Get SW modify action data */
+	length =3D MLX5_GET(set_action_in, sw_action, length);
+	offset =3D MLX5_GET(set_action_in, sw_action, offset);
+	sw_field =3D MLX5_GET(set_action_in, sw_action, field);
+	data =3D MLX5_GET(set_action_in, sw_action, data);
+
+	/* Convert SW data to HW modify action format */
+	hw_action_info =3D dr_action_modify_get_hw_info(sw_field);
+	if (!hw_action_info) {
+		mlx5dr_dbg(dmn, "Modify set action invalid field given\n");
+		return -EINVAL;
 	}
=20
-	MLX5_SET(dr_action_hw_set, hw_action, opcode, hw_opcode);
+	/* PRM defines that length zero specific length of 32bits */
+	length =3D length ? length : 32;
+
+	max_length =3D hw_action_info->end - hw_action_info->start + 1;
+
+	if (length + offset > max_length) {
+		mlx5dr_dbg(dmn, "Modify action length + offset exceeds limit\n");
+		return -EINVAL;
+	}
+
+	MLX5_SET(dr_action_hw_set, hw_action,
+		 opcode, MLX5DR_ACTION_MDFY_HW_OP_SET);
=20
 	MLX5_SET(dr_action_hw_set, hw_action, destination_field_code,
 		 hw_action_info->hw_field);
@@ -1384,48 +1411,120 @@ dr_action_modify_sw_to_hw(struct mlx5dr_domain *dm=
n,
 }
=20
 static int
-dr_action_modify_check_field_limitation(struct mlx5dr_domain *dmn,
-					const __be64 *sw_action)
+dr_action_modify_sw_to_hw(struct mlx5dr_domain *dmn,
+			  __be64 *sw_action,
+			  __be64 *hw_action,
+			  const struct dr_action_modify_field_conv **ret_hw_info)
 {
-	u16 sw_field;
 	u8 action;
+	int ret;
=20
-	sw_field =3D MLX5_GET(set_action_in, sw_action, field);
+	*hw_action =3D 0;
+
+	/* Get SW modify action type */
 	action =3D MLX5_GET(set_action_in, sw_action, action_type);
=20
-	/* Check if SW field is supported in current domain (RX/TX) */
-	if (action =3D=3D MLX5_ACTION_TYPE_SET) {
-		if (sw_field =3D=3D MLX5_ACTION_IN_FIELD_METADATA_REG_A) {
-			if (dmn->type !=3D MLX5DR_DOMAIN_TYPE_NIC_TX) {
-				mlx5dr_dbg(dmn, "Unsupported field %d for RX/FDB set action\n",
-					   sw_field);
-				return -EINVAL;
-			}
-		}
+	switch (action) {
+	case MLX5_ACTION_TYPE_SET:
+		ret =3D dr_action_modify_sw_to_hw_set(dmn, sw_action,
+						    hw_action,
+						    ret_hw_info);
+		break;
=20
-		if (sw_field =3D=3D MLX5_ACTION_IN_FIELD_METADATA_REG_B) {
-			if (dmn->type !=3D MLX5DR_DOMAIN_TYPE_NIC_RX) {
-				mlx5dr_dbg(dmn, "Unsupported field %d for TX/FDB set action\n",
-					   sw_field);
-				return -EINVAL;
-			}
+	case MLX5_ACTION_TYPE_ADD:
+		ret =3D dr_action_modify_sw_to_hw_add(dmn, sw_action,
+						    hw_action,
+						    ret_hw_info);
+		break;
+
+	default:
+		mlx5dr_info(dmn, "Unsupported action_type for modify action\n");
+		ret =3D -EOPNOTSUPP;
+	}
+
+	return ret;
+}
+
+static int
+dr_action_modify_check_set_field_limitation(struct mlx5dr_action *action,
+					    const __be64 *sw_action)
+{
+	u16 sw_field =3D MLX5_GET(set_action_in, sw_action, field);
+	struct mlx5dr_domain *dmn =3D action->rewrite.dmn;
+
+	if (sw_field =3D=3D MLX5_ACTION_IN_FIELD_METADATA_REG_A) {
+		action->rewrite.allow_rx =3D 0;
+		if (dmn->type !=3D MLX5DR_DOMAIN_TYPE_NIC_TX) {
+			mlx5dr_dbg(dmn, "Unsupported field %d for RX/FDB set action\n",
+				   sw_field);
+			return -EINVAL;
 		}
-	} else if (action =3D=3D MLX5_ACTION_TYPE_ADD) {
-		if (sw_field !=3D MLX5_ACTION_IN_FIELD_OUT_IP_TTL &&
-		    sw_field !=3D MLX5_ACTION_IN_FIELD_OUT_IPV6_HOPLIMIT &&
-		    sw_field !=3D MLX5_ACTION_IN_FIELD_OUT_TCP_SEQ_NUM &&
-		    sw_field !=3D MLX5_ACTION_IN_FIELD_OUT_TCP_ACK_NUM) {
-			mlx5dr_dbg(dmn, "Unsupported field %d for add action\n", sw_field);
+	} else if (sw_field =3D=3D MLX5_ACTION_IN_FIELD_METADATA_REG_B) {
+		action->rewrite.allow_tx =3D 0;
+		if (dmn->type !=3D MLX5DR_DOMAIN_TYPE_NIC_RX) {
+			mlx5dr_dbg(dmn, "Unsupported field %d for TX/FDB set action\n",
+				   sw_field);
 			return -EINVAL;
 		}
-	} else {
-		mlx5dr_info(dmn, "Unsupported action %d modify action\n", action);
-		return -EOPNOTSUPP;
+	}
+
+	if (!action->rewrite.allow_rx && !action->rewrite.allow_tx) {
+		mlx5dr_dbg(dmn, "Modify SET actions not supported on both RX and TX\n");
+		return -EINVAL;
 	}
=20
 	return 0;
 }
=20
+static int
+dr_action_modify_check_add_field_limitation(struct mlx5dr_action *action,
+					    const __be64 *sw_action)
+{
+	u16 sw_field =3D MLX5_GET(set_action_in, sw_action, field);
+	struct mlx5dr_domain *dmn =3D action->rewrite.dmn;
+
+	if (sw_field !=3D MLX5_ACTION_IN_FIELD_OUT_IP_TTL &&
+	    sw_field !=3D MLX5_ACTION_IN_FIELD_OUT_IPV6_HOPLIMIT &&
+	    sw_field !=3D MLX5_ACTION_IN_FIELD_OUT_TCP_SEQ_NUM &&
+	    sw_field !=3D MLX5_ACTION_IN_FIELD_OUT_TCP_ACK_NUM) {
+		mlx5dr_dbg(dmn, "Unsupported field %d for add action\n",
+			   sw_field);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int
+dr_action_modify_check_field_limitation(struct mlx5dr_action *action,
+					const __be64 *sw_action)
+{
+	struct mlx5dr_domain *dmn =3D action->rewrite.dmn;
+	u8 action_type;
+	int ret;
+
+	action_type =3D MLX5_GET(set_action_in, sw_action, action_type);
+
+	switch (action_type) {
+	case MLX5_ACTION_TYPE_SET:
+		ret =3D dr_action_modify_check_set_field_limitation(action,
+								  sw_action);
+		break;
+
+	case MLX5_ACTION_TYPE_ADD:
+		ret =3D dr_action_modify_check_add_field_limitation(action,
+								  sw_action);
+		break;
+
+	default:
+		mlx5dr_info(dmn, "Unsupported action %d modify action\n",
+			    action_type);
+		ret =3D -EOPNOTSUPP;
+	}
+
+	return ret;
+}
+
 static bool
 dr_action_modify_check_is_ttl_modify(const u64 *sw_action)
 {
@@ -1434,7 +1533,7 @@ dr_action_modify_check_is_ttl_modify(const u64 *sw_ac=
tion)
 	return sw_field =3D=3D MLX5_ACTION_IN_FIELD_OUT_IP_TTL;
 }
=20
-static int dr_actions_convert_modify_header(struct mlx5dr_domain *dmn,
+static int dr_actions_convert_modify_header(struct mlx5dr_action *action,
 					    u32 max_hw_actions,
 					    u32 num_sw_actions,
 					    __be64 sw_actions[],
@@ -1446,16 +1545,21 @@ static int dr_actions_convert_modify_header(struct =
mlx5dr_domain *dmn,
 	u16 hw_field =3D MLX5DR_ACTION_MDFY_HW_FLD_RESERVED;
 	u32 l3_type =3D MLX5DR_ACTION_MDFY_HW_HDR_L3_NONE;
 	u32 l4_type =3D MLX5DR_ACTION_MDFY_HW_HDR_L4_NONE;
+	struct mlx5dr_domain *dmn =3D action->rewrite.dmn;
 	int ret, i, hw_idx =3D 0;
 	__be64 *sw_action;
 	__be64 hw_action;
=20
 	*modify_ttl =3D false;
=20
+	action->rewrite.allow_rx =3D 1;
+	action->rewrite.allow_tx =3D 1;
+
 	for (i =3D 0; i < num_sw_actions; i++) {
 		sw_action =3D &sw_actions[i];
=20
-		ret =3D dr_action_modify_check_field_limitation(dmn, sw_action);
+		ret =3D dr_action_modify_check_field_limitation(action,
+							      sw_action);
 		if (ret)
 			return ret;
=20
@@ -1544,7 +1648,7 @@ static int dr_action_create_modify_action(struct mlx5=
dr_domain *dmn,
 		goto free_chunk;
 	}
=20
-	ret =3D dr_actions_convert_modify_header(dmn,
+	ret =3D dr_actions_convert_modify_header(action,
 					       max_hw_actions,
 					       num_sw_actions,
 					       actions,
--=20
2.24.1

