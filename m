Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B983132F24
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 20:14:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728801AbgAGTOg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 14:14:36 -0500
Received: from mail-vi1eur05on2055.outbound.protection.outlook.com ([40.107.21.55]:6105
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728778AbgAGTOf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Jan 2020 14:14:35 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z48cSOqmwn6/gjiC/YMmq85ktM1kI5I4GuH1JgxeTq8Kf22jx+4BgZiPmQ6Faq9AatERIOTzifVM0kbZ3G2rBBzEF9MCz1uHMVVDRwzpkkIVa6ajMKBph4MrQRFvjj1RLGMLNhVS+eYmuzfUzdvkGMzNA7sQAR7tLL6HZLJd3fAL73NxpDuKNCLtAc/gPjFNQvUXsvIaCqOzV3qay89TzJQiU7IswN+obaaFGSjItJ5KMbDqDH7fJnNgQOu2ck5JSqWDd3AeZvMHi4g/7p8wZaMm1YwQeJYbNUiVHWXTcoSPy1nrBhektyIx3Ru7hJLpQXvGpftO9hpYxIuix+NY0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fk7d2QecBLz9gkkcS6/gyrmj3Zygo36Rn65jTJJWOQM=;
 b=kMisXiw/xYSeqeCMiLRzJk47upSVtE0flRYIAVUqwcUjWTLX3loSL0rsuVsVBYZA9gsc0PHn+cxhRHCXa0rqSbBmIWHyPtlepfvS4HfV4Bc9Iw2ztyXrYo5ua3jgfWBY7qiqDEQMViSrceizIapE9Cd8MJtpxZt6okLA4ps/9QGNK+bjbtiOksb/bZXiE6rNWvlFxLExek334IzqW/LcpcmVTr0CaaQvzlers6AQ7+Zf2QhLJnJ+PBXzXcgAtMinBayc9A+vkaFO0qU75tCO0DqLsm55l82gx6rT4dpdh881LJivpYP9/JBs8Z0/Dqfv6Zs+Zx5q7GSmy3kmZkxPIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fk7d2QecBLz9gkkcS6/gyrmj3Zygo36Rn65jTJJWOQM=;
 b=azqJWyKWTHvJ6S8ofqUApan0/idx4l8wIeFCYmtxCkBEWZCskmqHbLwxgR2+bnuKHU7/RXVtNzd+KKhwWEwISnn6EIQjpqig0GwqAykRLpfBt6RN47tQnF5QIC+hEQe+N7s4VXfxLr74sESadM7IQV1YtD7tIaxgbwPxkPi/3nA=
Received: from AM6PR05MB5094.eurprd05.prod.outlook.com (20.177.34.93) by
 AM6PR05MB5411.eurprd05.prod.outlook.com (20.177.189.90) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2602.11; Tue, 7 Jan 2020 19:14:24 +0000
Received: from AM6PR05MB5094.eurprd05.prod.outlook.com
 ([fe80::d9f3:f3b8:86b2:a40a]) by AM6PR05MB5094.eurprd05.prod.outlook.com
 ([fe80::d9f3:f3b8:86b2:a40a%7]) with mapi id 15.20.2602.015; Tue, 7 Jan 2020
 19:14:24 +0000
Received: from smtp.office365.com (209.116.155.178) by BYAPR06CA0068.namprd06.prod.outlook.com (2603:10b6:a03:14b::45) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2581.12 via Frontend Transport; Tue, 7 Jan 2020 19:14:22 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alex Vesker <valex@mellanox.com>,
        Erez Shitrit <erezsh@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 11/13] net/mlx5: DR, Align dest FT action creation to API
Thread-Topic: [net-next 11/13] net/mlx5: DR, Align dest FT action creation to
 API
Thread-Index: AQHVxY6rM0ZjAnlIQUSPvyM+tBeCLg==
Date:   Tue, 7 Jan 2020 19:14:23 +0000
Message-ID: <20200107191335.12272-12-saeedm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: 0be070db-6d48-414b-8888-08d793a5ce5a
x-ms-traffictypediagnostic: AM6PR05MB5411:|AM6PR05MB5411:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM6PR05MB5411380698BCF41EF694CF3CBE3F0@AM6PR05MB5411.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:773;
x-forefront-prvs: 027578BB13
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(366004)(136003)(346002)(39860400002)(376002)(199004)(189003)(81166006)(52116002)(6916009)(8936002)(81156014)(8676002)(26005)(86362001)(36756003)(316002)(5660300002)(107886003)(6506007)(4326008)(478600001)(1076003)(16526019)(956004)(2616005)(2906002)(66446008)(64756008)(66556008)(66476007)(71200400001)(66946007)(6486002)(6512007)(54906003)(186003)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR05MB5411;H:AM6PR05MB5094.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: E68PN72ENXCM/ygiKWj3ngGaQFPMo0BdiO8FXAY8IVYUMFTGihlU/UZ4f4PN9sdafh6LfClfMcDjl58MeSnyH45GDECYFUwRe4CwA3RNOaGNVT3PXtE85lZUyd98zRvm4EdLDJdkE3XyoDRmhSA2K32apQ0ObfZX9n9Idncbf/DgG2tZTiDbnRGVxlyzKE9UWqKU654sr6nN7RAUr58+lH5X7vN22gCZoY0BEBi/AiwhGwTDODmT0IJWI+0CNoEInTux2hTqIFIYoG0AwsEBsX7Vd++xdyPigWX3rlXImcqE2dNeV74TltuwtTCT5wTE+hbASdY9lp1kI83yRq/7/6/pyZ9Pog59QSNwuLbgtfyXhHsfROvXVtmLoXBgBDOeCKYiQ6SfDvFrPs6YjLeEZ9vf2cKzd3/hEJ2WCZHjvNplkg6uCMr3sa3X9xvQfVfgloJjZuoOmumiGSDw5bSrBcyOxT7rgEJlkwWyW6KcGolz7Xi13nQIDDaeZKXx6PfnAtUMiZ/YT3Cw4q5F+gBxN678gMjTDfDlE1tjtOkgg6I=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0be070db-6d48-414b-8888-08d793a5ce5a
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jan 2020 19:14:23.8490
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dPiwf+Cb88ylWZO9ccMrs82qKtFCn3zNhMapC80o9TMAgFCkG/0xkeIvJvIRO88m/D5xt+d2qzXDfBiERM/70A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB5411
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alex Vesker <valex@mellanox.com>

Function prefix was changed to be similar to other action APIs.
In order to support other FW tables the mlx5_flow_table struct was
replaced with table id and type.

Signed-off-by: Alex Vesker <valex@mellanox.com>
Reviewed-by: Erez Shitrit <erezsh@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../mellanox/mlx5/core/steering/dr_action.c   | 21 ++++++++++++-------
 .../mellanox/mlx5/core/steering/dr_types.h    |  5 +++--
 .../mellanox/mlx5/core/steering/fs_dr.c       |  6 +++---
 .../mellanox/mlx5/core/steering/mlx5dr.h      |  8 +++----
 4 files changed, 23 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c b=
/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
index 004c56c2fc0c..3e2318761c8c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
@@ -690,9 +690,9 @@ int mlx5dr_actions_build_ste_arr(struct mlx5dr_matcher =
*matcher,
=20
 				/* get the relevant addresses */
 				if (!action->dest_tbl.fw_tbl.rx_icm_addr) {
-					ret =3D mlx5dr_cmd_query_flow_table(action->dest_tbl.fw_tbl.mdev,
-									  action->dest_tbl.fw_tbl.ft->type,
-									  action->dest_tbl.fw_tbl.ft->id,
+					ret =3D mlx5dr_cmd_query_flow_table(dmn->mdev,
+									  action->dest_tbl.fw_tbl.type,
+									  action->dest_tbl.fw_tbl.id,
 									  &output);
 					if (!ret) {
 						action->dest_tbl.fw_tbl.tx_icm_addr =3D
@@ -982,8 +982,8 @@ mlx5dr_action_create_dest_table(struct mlx5dr_table *tb=
l)
 }
=20
 struct mlx5dr_action *
-mlx5dr_create_action_dest_flow_fw_table(struct mlx5_flow_table *ft,
-					struct mlx5_core_dev *mdev)
+mlx5dr_action_create_dest_flow_fw_table(struct mlx5dr_domain *dmn,
+					struct mlx5_flow_table *ft)
 {
 	struct mlx5dr_action *action;
=20
@@ -992,8 +992,11 @@ mlx5dr_create_action_dest_flow_fw_table(struct mlx5_fl=
ow_table *ft,
 		return NULL;
=20
 	action->dest_tbl.is_fw_tbl =3D 1;
-	action->dest_tbl.fw_tbl.ft =3D ft;
-	action->dest_tbl.fw_tbl.mdev =3D mdev;
+	action->dest_tbl.fw_tbl.type =3D ft->type;
+	action->dest_tbl.fw_tbl.id =3D ft->id;
+	action->dest_tbl.fw_tbl.dmn =3D dmn;
+
+	refcount_inc(&dmn->refcount);
=20
 	return action;
 }
@@ -1559,7 +1562,9 @@ int mlx5dr_action_destroy(struct mlx5dr_action *actio=
n)
=20
 	switch (action->action_type) {
 	case DR_ACTION_TYP_FT:
-		if (!action->dest_tbl.is_fw_tbl)
+		if (action->dest_tbl.is_fw_tbl)
+			refcount_dec(&action->dest_tbl.fw_tbl.dmn->refcount);
+		else
 			refcount_dec(&action->dest_tbl.tbl->refcount);
 		break;
 	case DR_ACTION_TYP_TNL_L2_TO_L2:
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h b/=
drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
index de6bfa655326..27f1d931bf9f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
@@ -743,10 +743,11 @@ struct mlx5dr_action {
 			union {
 				struct mlx5dr_table *tbl;
 				struct {
-					struct mlx5_flow_table *ft;
+					struct mlx5dr_domain *dmn;
+					u32 id;
+					enum fs_flow_table_type type;
 					u64 rx_icm_addr;
 					u64 tx_icm_addr;
-					struct mlx5_core_dev *mdev;
 				} fw_tbl;
 			};
 		} dest_tbl;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c b/dri=
vers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c
index 8ed0f087b1e0..e51262ec77bb 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c
@@ -184,13 +184,13 @@ static struct mlx5dr_action *create_vport_action(stru=
ct mlx5dr_domain *domain,
 					       dest_attr->vport.vhca_id);
 }
=20
-static struct mlx5dr_action *create_ft_action(struct mlx5_core_dev *dev,
+static struct mlx5dr_action *create_ft_action(struct mlx5dr_domain *domain=
,
 					      struct mlx5_flow_rule *dst)
 {
 	struct mlx5_flow_table *dest_ft =3D dst->dest_attr.ft;
=20
 	if (mlx5_dr_is_fw_table(dest_ft->flags))
-		return mlx5dr_create_action_dest_flow_fw_table(dest_ft, dev);
+		return mlx5dr_action_create_dest_flow_fw_table(domain, dest_ft);
 	return mlx5dr_action_create_dest_table(dest_ft->fs_dr_table.dr_table);
 }
=20
@@ -373,7 +373,7 @@ static int mlx5_cmd_dr_create_fte(struct mlx5_flow_root=
_namespace *ns,
 				actions[num_actions++] =3D tmp_action;
 				break;
 			case MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE:
-				tmp_action =3D create_ft_action(dev, dst);
+				tmp_action =3D create_ft_action(domain, dst);
 				if (!tmp_action) {
 					err =3D -ENOMEM;
 					goto free_actions;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5dr.h b/dr=
ivers/net/ethernet/mellanox/mlx5/core/steering/mlx5dr.h
index fb3ac697df1b..932362d89c66 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5dr.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5dr.h
@@ -75,8 +75,8 @@ struct mlx5dr_action *
 mlx5dr_action_create_dest_table(struct mlx5dr_table *table);
=20
 struct mlx5dr_action *
-mlx5dr_create_action_dest_flow_fw_table(struct mlx5_flow_table *ft,
-					struct mlx5_core_dev *mdev);
+mlx5dr_action_create_dest_flow_fw_table(struct mlx5dr_domain *domain,
+					struct mlx5_flow_table *ft);
=20
 struct mlx5dr_action *
 mlx5dr_action_create_dest_vport(struct mlx5dr_domain *domain,
@@ -165,8 +165,8 @@ static inline struct mlx5dr_action *
 mlx5dr_action_create_dest_table(struct mlx5dr_table *table) { return NULL;=
 }
=20
 static inline struct mlx5dr_action *
-mlx5dr_create_action_dest_flow_fw_table(struct mlx5_flow_table *ft,
-					struct mlx5_core_dev *mdev) { return NULL; }
+mlx5dr_action_create_dest_flow_fw_table(struct mlx5dr_domain *domain,
+					struct mlx5_flow_table *ft) { return NULL; }
=20
 static inline struct mlx5dr_action *
 mlx5dr_action_create_dest_vport(struct mlx5dr_domain *domain,
--=20
2.24.1

