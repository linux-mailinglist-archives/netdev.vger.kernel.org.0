Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF2AF132F25
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 20:14:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728808AbgAGTOj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 14:14:39 -0500
Received: from mail-vi1eur05on2055.outbound.protection.outlook.com ([40.107.21.55]:6105
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728784AbgAGTOj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Jan 2020 14:14:39 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mTxQ3winTJG290zUd78yRHyXEqFLyNoGdVw+Qwyd1hX7k/YOMfZMb1V5426QAmCsyCsEHNwSXreMYyXtN6I7+Nbic/jvEHCV+6uHKJDLTwpcqFC0tX8nVOLCkDW5iOaTOkPyTG1cG1D9ywNb+uAY5S1X3ixcC0x1sz9WHuALO6KPOe1vwNKiS2AyEQn3PI59WIjbAPp3eaaCDUr8P5faHbzSENAz+RSi7wbK6MGWBz0k1aLWZbrxUebOp6mO5tKLnFvJZZLQidcZbhZkXTpba6jmn2Tl51MxFq6fKos5tjeLrlbYlvxKFFKpNlyW/cC2DVFbiTDJ70DOrKm8ePmNLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l/6TTsaN0d8Y8pOZUlgOzAyL45UinA+L58UjzVQZ8jY=;
 b=PrVesY6g/h2awuX32TjOc+W1ErwBy/v2SqldOw/KahjEXBCtek0yQvBs4S0gvSTxFaxgeUdB8YbSvdBK9eNdoDUYJZFbJErQ0PWw0E3keMran1zU5Eza70zX1ZXf8dHQMlxlG+rGVI5uMZIoUESLRBhbzAhHuscNfIwwW/LrIgn93jGH+4caY9iXR3EX1EbLYOU0+ynY5uFcgVNDmZ6GhrNIV1m819FSlBYITPfF1A+PSYPpfRXkk4wPt7FqgUUCcTkdaRWloV/kz6/BloDGU1934co57OmYRqUIYQAmYJf2QRpu06VJDOMO+w5ATOXSAQXaLrAfdA+sKAc6f8lufg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l/6TTsaN0d8Y8pOZUlgOzAyL45UinA+L58UjzVQZ8jY=;
 b=anPPMWqbag3RCc6qwEeFDcrTWTz3jTxl4H3VT5mOZskVe//IkT/9H5nQXmH9/6RpNO06rcddRNaYgH7zzulOjm3HCbqo6JSJ61dz5opgIGrxUaJ978TXXB7hcq+Y6IBa7Ou8sgex1wx/yoGQ96fOF1MNS1YYycX4e8ZDw39LeNo=
Received: from AM6PR05MB5094.eurprd05.prod.outlook.com (20.177.34.93) by
 AM6PR05MB5411.eurprd05.prod.outlook.com (20.177.189.90) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2602.11; Tue, 7 Jan 2020 19:14:25 +0000
Received: from AM6PR05MB5094.eurprd05.prod.outlook.com
 ([fe80::d9f3:f3b8:86b2:a40a]) by AM6PR05MB5094.eurprd05.prod.outlook.com
 ([fe80::d9f3:f3b8:86b2:a40a%7]) with mapi id 15.20.2602.015; Tue, 7 Jan 2020
 19:14:25 +0000
Received: from smtp.office365.com (209.116.155.178) by BYAPR06CA0068.namprd06.prod.outlook.com (2603:10b6:a03:14b::45) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2581.12 via Frontend Transport; Tue, 7 Jan 2020 19:14:24 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alex Vesker <valex@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 12/13] net/mlx5: DR, Add support for multiple destination
 table action
Thread-Topic: [net-next 12/13] net/mlx5: DR, Add support for multiple
 destination table action
Thread-Index: AQHVxY6s5ZJIKES1Pka//Hmhn6JJWg==
Date:   Tue, 7 Jan 2020 19:14:25 +0000
Message-ID: <20200107191335.12272-13-saeedm@mellanox.com>
References: <20200107191335.12272-1-saeedm@mellanox.com>
In-Reply-To: <20200107191335.12272-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.24.1
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR06CA0068.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::45) To AM6PR05MB5094.eurprd05.prod.outlook.com
 (2603:10a6:20b:9::29)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: ff221664-7e37-4020-5da3-08d793a5cf47
x-ms-traffictypediagnostic: AM6PR05MB5411:|AM6PR05MB5411:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM6PR05MB5411E220A025204C0620D01BBE3F0@AM6PR05MB5411.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:326;
x-forefront-prvs: 027578BB13
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(366004)(136003)(346002)(39860400002)(376002)(199004)(189003)(81166006)(52116002)(6916009)(8936002)(81156014)(8676002)(26005)(86362001)(36756003)(316002)(5660300002)(107886003)(6506007)(4326008)(478600001)(1076003)(16526019)(956004)(2616005)(2906002)(66446008)(64756008)(66556008)(66476007)(71200400001)(66946007)(6486002)(6512007)(54906003)(186003)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR05MB5411;H:AM6PR05MB5094.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QXZGv43DZeB/j71BIRTbDm6/k9KIat8Q9m+HNp+fI9wv8k3OpGHtIrp4tCGPLBsnrqP6OjUGQpKzlKZM75J0rEPbObtx5AVDkrhaXvieSwi7PJpF/GKT/jDm1RJMAR4GzEONnwzmN6quK8xybxyquLmWKfGbzMdPSJ/Ne6nS9XEZY1Knwf3bhUqJ3wKmLK08wjbugKZ734rt7nJIghQiEjcFE7eWo3gW7bbKu81/o97hppFns5fmpzVk8PkIJo3Tjpf7RObG44V2MvkPt4+JmIaaX96k4HIKfAC4zI5rVxiGPSUpveIKqSXlFZplRA5QK/YHfEUW+XG5Y3fsMdZO90NJvliy/Pvhq7GJ5pVYC4TRwMHKA3c7Eqv2FvicKGvxdIEzdzc3q7Uop1ngA9DNUkdHWuziuj4bc0dD2U9DE5JDXje/dPrRbVFeCTBXsBya21C3KUElRAg8haiaqF/5wgpS2pd2SjEbML/DOB2kIv3va1hbO07fZZlTSi0CgosICXQbnjkIughMHoQM0xRKK9nMWu4HrK58l2X9FlsjWIY=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ff221664-7e37-4020-5da3-08d793a5cf47
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jan 2020 19:14:25.3861
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vMlb+Lw2djJb+lBojbySjmhssfJmjfL4tw0csrFqpHJML6ToAaPTUWjJyb/kGHOKYI+LXv41mGDG3Kcebt2koA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB5411
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alex Vesker <valex@mellanox.com>

A multiple destination table action allows HW packet duplication
to multiple destinations, this is useful for multicast or mirroring
traffic for debug. Duplicating is done using a FW flow table with
multiple destinations.

The new action creation function, mlx5dr_action_create_mult_dest_tbl
will allow creating a single table to iterate over several dr actions.

Signed-off-by: Alex Vesker <valex@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../mellanox/mlx5/core/steering/dr_action.c   | 114 ++++++++++++++++++
 .../mellanox/mlx5/core/steering/dr_types.h    |   3 +
 .../mellanox/mlx5/core/steering/mlx5dr.h      |  15 +++
 3 files changed, 132 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c b=
/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
index 3e2318761c8c..9359eed10889 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
@@ -981,6 +981,104 @@ mlx5dr_action_create_dest_table(struct mlx5dr_table *=
tbl)
 	return NULL;
 }
=20
+struct mlx5dr_action *
+mlx5dr_action_create_mult_dest_tbl(struct mlx5dr_domain *dmn,
+				   struct mlx5dr_action_dest *dests,
+				   u32 num_of_dests)
+{
+	struct mlx5dr_cmd_flow_destination_hw_info *hw_dests;
+	struct mlx5dr_action **ref_actions;
+	struct mlx5dr_action *action;
+	bool reformat_req =3D false;
+	u32 num_of_ref =3D 0;
+	int ret;
+	int i;
+
+	if (dmn->type !=3D MLX5DR_DOMAIN_TYPE_FDB) {
+		mlx5dr_err(dmn, "Multiple destination support is for FDB only\n");
+		return NULL;
+	}
+
+	hw_dests =3D kzalloc(sizeof(*hw_dests) * num_of_dests, GFP_KERNEL);
+	if (!hw_dests)
+		return NULL;
+
+	ref_actions =3D kzalloc(sizeof(*ref_actions) * num_of_dests * 2, GFP_KERN=
EL);
+	if (!ref_actions)
+		goto free_hw_dests;
+
+	for (i =3D 0; i < num_of_dests; i++) {
+		struct mlx5dr_action *reformat_action =3D dests[i].reformat;
+		struct mlx5dr_action *dest_action =3D dests[i].dest;
+
+		ref_actions[num_of_ref++] =3D dest_action;
+
+		switch (dest_action->action_type) {
+		case DR_ACTION_TYP_VPORT:
+			hw_dests[i].vport.flags =3D MLX5_FLOW_DEST_VPORT_VHCA_ID;
+			hw_dests[i].type =3D MLX5_FLOW_DESTINATION_TYPE_VPORT;
+			hw_dests[i].vport.num =3D dest_action->vport.caps->num;
+			hw_dests[i].vport.vhca_id =3D dest_action->vport.caps->vhca_gvmi;
+			if (reformat_action) {
+				reformat_req =3D true;
+				hw_dests[i].vport.reformat_id =3D
+					reformat_action->reformat.reformat_id;
+				ref_actions[num_of_ref++] =3D reformat_action;
+				hw_dests[i].vport.flags |=3D MLX5_FLOW_DEST_VPORT_REFORMAT_ID;
+			}
+			break;
+
+		case DR_ACTION_TYP_FT:
+			hw_dests[i].type =3D MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE;
+			if (dest_action->dest_tbl.is_fw_tbl)
+				hw_dests[i].ft_id =3D dest_action->dest_tbl.fw_tbl.id;
+			else
+				hw_dests[i].ft_id =3D dest_action->dest_tbl.tbl->table_id;
+			break;
+
+		default:
+			mlx5dr_dbg(dmn, "Invalid multiple destinations action\n");
+			goto free_ref_actions;
+		}
+	}
+
+	action =3D dr_action_create_generic(DR_ACTION_TYP_FT);
+	if (!action)
+		goto free_ref_actions;
+
+	ret =3D mlx5dr_fw_create_md_tbl(dmn,
+				      hw_dests,
+				      num_of_dests,
+				      reformat_req,
+				      &action->dest_tbl.fw_tbl.id,
+				      &action->dest_tbl.fw_tbl.group_id);
+	if (ret)
+		goto free_action;
+
+	refcount_inc(&dmn->refcount);
+
+	for (i =3D 0; i < num_of_ref; i++)
+		refcount_inc(&ref_actions[i]->refcount);
+
+	action->dest_tbl.is_fw_tbl =3D true;
+	action->dest_tbl.fw_tbl.dmn =3D dmn;
+	action->dest_tbl.fw_tbl.type =3D FS_FT_FDB;
+	action->dest_tbl.fw_tbl.ref_actions =3D ref_actions;
+	action->dest_tbl.fw_tbl.num_of_ref_actions =3D num_of_ref;
+
+	kfree(hw_dests);
+
+	return action;
+
+free_action:
+	kfree(action);
+free_ref_actions:
+	kfree(ref_actions);
+free_hw_dests:
+	kfree(hw_dests);
+	return NULL;
+}
+
 struct mlx5dr_action *
 mlx5dr_action_create_dest_flow_fw_table(struct mlx5dr_domain *dmn,
 					struct mlx5_flow_table *ft)
@@ -1566,6 +1664,22 @@ int mlx5dr_action_destroy(struct mlx5dr_action *acti=
on)
 			refcount_dec(&action->dest_tbl.fw_tbl.dmn->refcount);
 		else
 			refcount_dec(&action->dest_tbl.tbl->refcount);
+
+		if (action->dest_tbl.is_fw_tbl &&
+		    action->dest_tbl.fw_tbl.num_of_ref_actions) {
+			struct mlx5dr_action **ref_actions;
+			int i;
+
+			ref_actions =3D action->dest_tbl.fw_tbl.ref_actions;
+			for (i =3D 0; i < action->dest_tbl.fw_tbl.num_of_ref_actions; i++)
+				refcount_dec(&ref_actions[i]->refcount);
+
+			kfree(ref_actions);
+
+			mlx5dr_fw_destroy_md_tbl(action->dest_tbl.fw_tbl.dmn,
+						 action->dest_tbl.fw_tbl.id,
+						 action->dest_tbl.fw_tbl.group_id);
+		}
 		break;
 	case DR_ACTION_TYP_TNL_L2_TO_L2:
 		refcount_dec(&action->reformat.dmn->refcount);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h b/=
drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
index 27f1d931bf9f..0fc52d634e10 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
@@ -745,9 +745,12 @@ struct mlx5dr_action {
 				struct {
 					struct mlx5dr_domain *dmn;
 					u32 id;
+					u32 group_id;
 					enum fs_flow_table_type type;
 					u64 rx_icm_addr;
 					u64 tx_icm_addr;
+					struct mlx5dr_action **ref_actions;
+					u32 num_of_ref_actions;
 				} fw_tbl;
 			};
 		} dest_tbl;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5dr.h b/dr=
ivers/net/ethernet/mellanox/mlx5/core/steering/mlx5dr.h
index 932362d89c66..e1edc9c247b7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5dr.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5dr.h
@@ -33,6 +33,11 @@ struct mlx5dr_match_parameters {
 	u64 *match_buf; /* Device spec format */
 };
=20
+struct mlx5dr_action_dest {
+	struct mlx5dr_action *dest;
+	struct mlx5dr_action *reformat;
+};
+
 #ifdef CONFIG_MLX5_SW_STEERING
=20
 struct mlx5dr_domain *
@@ -83,6 +88,11 @@ mlx5dr_action_create_dest_vport(struct mlx5dr_domain *do=
main,
 				u32 vport, u8 vhca_id_valid,
 				u16 vhca_id);
=20
+struct mlx5dr_action *
+mlx5dr_action_create_mult_dest_tbl(struct mlx5dr_domain *dmn,
+				   struct mlx5dr_action_dest *dests,
+				   u32 num_of_dests);
+
 struct mlx5dr_action *mlx5dr_action_create_drop(void);
=20
 struct mlx5dr_action *mlx5dr_action_create_tag(u32 tag_value);
@@ -173,6 +183,11 @@ mlx5dr_action_create_dest_vport(struct mlx5dr_domain *=
domain,
 				u32 vport, u8 vhca_id_valid,
 				u16 vhca_id) { return NULL; }
=20
+static inline struct mlx5dr_action *
+mlx5dr_action_create_mult_dest_tbl(struct mlx5dr_domain *dmn,
+				   struct mlx5dr_action_dest *dests,
+				   u32 num_of_dests)  { return NULL; }
+
 static inline struct mlx5dr_action *
 mlx5dr_action_create_drop(void) { return NULL; }
=20
--=20
2.24.1

