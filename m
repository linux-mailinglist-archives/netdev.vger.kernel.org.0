Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C55DF79AC4
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 23:13:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388504AbfG2VNW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 17:13:22 -0400
Received: from mail-eopbgr10050.outbound.protection.outlook.com ([40.107.1.50]:5933
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388459AbfG2VNU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Jul 2019 17:13:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l3P4qwlUIQSov6SBmdJPDJsrI0ba4AXpI/1xzSZoml9wFjWmfWB9hijaiR8MrgCcGeuaHTanV/88BT01TESyRedveqa39o27KhW+2w1+VW9o5ac49cyoCzx6ezwAtPK9cJCzADe9zerVSJqxQ9aTwz/32ZBfNJku1s4cMaVqlo7yU070w+P6f1svInv5Hc4vrTAetx/fmUlwSFelxBKzYHACrmdmviBAIeMRcumqZBSusEw9iW2bUEDYK3PNWsTNc7G3zj6p8b08VS7VtWosjFq+LO0cH9g3Phj1gjJ2LeqNiYy9vLXwXtDufU4TO510XxSSLuFVRXzBFYeEFFFf+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i3jamkuzNEYKahh/SX/5f8LamiiC4uvE+wEEMvNnFew=;
 b=hyGRz3wn6eVfgw15Vqb7x3KUzRJTwOG8CgKJIw1lo28oVH0tJvslze/LebsuN7Vcqz4dFj9yt2qANd+/1PAFwfTIfbbLmzcgHkJ+CamvFQL6bAu/FIiE6JO4LRMBOkhQA0Jz4DUnusQkBJjqQvG7yiXiiyUw6t5WGBmhoRRnw3686ccE57HU4WrNWspbFEnoz46xitl2crnxB9jxG6arYBzBEdozWDiGpZKB5U3Nn+GwlFh2/kMGSLGHynB87gjjDOurChQ7qwR3XQl8FO4xv+VwVKnChUSFW5tMnZ+3HcS9yc4cuxr8Hqgx0PhyhmOZOFX+Yj6iByCBGR4bBNEyKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=mellanox.com;dmarc=pass action=none
 header.from=mellanox.com;dkim=pass header.d=mellanox.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i3jamkuzNEYKahh/SX/5f8LamiiC4uvE+wEEMvNnFew=;
 b=FXGHdfsl+elxTAI5px0fW+adopkyPh8uloSsphH7aeg500Ph6Huikdl8adi05dU9xnhKkQPxS7rlR2/+0tZASmSvql+gzudij1EoA2yxLDcEoXep5o/mI2sMs8pKT0x8aLvUh4AWKMrJxhQLuQtCdJr384SBJ3bV0EaY6nWsLEM=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2375.eurprd05.prod.outlook.com (10.168.72.150) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.10; Mon, 29 Jul 2019 21:13:02 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2%5]) with mapi id 15.20.2115.005; Mon, 29 Jul 2019
 21:13:02 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
CC:     Parav Pandit <parav@mellanox.com>
Subject: [PATCH mlx5-next 06/11] net/mlx5: E-switch, Combine metadata
 enable/disable functionality
Thread-Topic: [PATCH mlx5-next 06/11] net/mlx5: E-switch, Combine metadata
 enable/disable functionality
Thread-Index: AQHVRlJoA7QYAf7F/0W6b2yLCTanpg==
Date:   Mon, 29 Jul 2019 21:13:02 +0000
Message-ID: <20190729211209.14772-7-saeedm@mellanox.com>
References: <20190729211209.14772-1-saeedm@mellanox.com>
In-Reply-To: <20190729211209.14772-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR05CA0081.namprd05.prod.outlook.com
 (2603:10b6:a03:e0::22) To DB6PR0501MB2759.eurprd05.prod.outlook.com
 (2603:10a6:4:84::7)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5d0ce755-71bf-4640-e663-08d714698a68
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2375;
x-ms-traffictypediagnostic: DB6PR0501MB2375:
x-microsoft-antispam-prvs: <DB6PR0501MB23753A62A4804732F2646C3CBEDD0@DB6PR0501MB2375.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 01136D2D90
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(376002)(346002)(39860400002)(366004)(396003)(199004)(189003)(50226002)(5660300002)(6116002)(3846002)(486006)(446003)(86362001)(81156014)(186003)(36756003)(81166006)(8936002)(26005)(25786009)(316002)(71190400001)(71200400001)(110136005)(64756008)(76176011)(66556008)(2906002)(66946007)(66446008)(99286004)(66476007)(1076003)(386003)(6506007)(102836004)(256004)(7736002)(6486002)(14454004)(66066001)(2501003)(8676002)(305945005)(6436002)(4326008)(11346002)(68736007)(52116002)(2616005)(476003)(478600001)(6512007)(450100002)(2201001)(107886003)(53936002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2375;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: DAia1iMLjjDi8Px+E89vk+9WqqOhnxVOwkaT994718kr1czDsqdyWbNTG3lXrzLw9E/NcNkAZGe7+IIyDyz++cdcUVhpTtrIW4fwpo7dGvjzbqgnvuIkC/DuyFoQPkagVIYDRrMlb0T1bV6sauNU84uxRqF7WQj9LDt1gBAjOdnecEFpl6clNPiBPq8S7QF7NbTUKfn99OmLsCFpLS4iDaRyhYTfLrC0yzwT4uRtjK6ckALyBIEFGCofzULcyE2IJHRXhHNKwYq21I6z6JmBBC3sq7zcSYeEL+zyXWHzgnI3Ro+ODm6p+0Q3Y7eB2GhrMzUNFBEpKAbxJ/s9r5SjjBEuat+XFA7m5LRdd2P9zn7U8sWPio+e1+QdFWtZIC27lpMbMWMYBb8RILmKSShPycQQBjfP50BKaT9mpQES/7U=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d0ce755-71bf-4640-e663-08d714698a68
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jul 2019 21:13:02.4055
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2375
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Parav Pandit <parav@mellanox.com>

Except bit toggling code, rest of the code is same to enable/disable
metadata passing functionality.
Hence, combine them to single function and control using enable flag.

Also instead of checking metadata supported at multiple places,
fold into the helper function.

Signed-off-by: Parav Pandit <parav@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../mellanox/mlx5/core/eswitch_offloads.c     | 48 +++++--------------
 1 file changed, 12 insertions(+), 36 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/d=
rivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 089ae4d48a82..4be19890f725 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -587,38 +587,15 @@ void mlx5_eswitch_del_send_to_vport_rule(struct mlx5_=
flow_handle *rule)
 	mlx5_del_flow_rules(rule);
 }
=20
-static int mlx5_eswitch_enable_passing_vport_metadata(struct mlx5_eswitch =
*esw)
+static int esw_set_passing_vport_metadata(struct mlx5_eswitch *esw, bool e=
nable)
 {
 	u32 out[MLX5_ST_SZ_DW(query_esw_vport_context_out)] =3D {};
 	u32 in[MLX5_ST_SZ_DW(modify_esw_vport_context_in)] =3D {};
 	u8 fdb_to_vport_reg_c_id;
 	int err;
=20
-	err =3D mlx5_eswitch_query_esw_vport_context(esw, esw->manager_vport,
-						   out, sizeof(out));
-	if (err)
-		return err;
-
-	fdb_to_vport_reg_c_id =3D MLX5_GET(query_esw_vport_context_out, out,
-					 esw_vport_context.fdb_to_vport_reg_c_id);
-
-	fdb_to_vport_reg_c_id |=3D MLX5_FDB_TO_VPORT_REG_C_0;
-	MLX5_SET(modify_esw_vport_context_in, in,
-		 esw_vport_context.fdb_to_vport_reg_c_id, fdb_to_vport_reg_c_id);
-
-	MLX5_SET(modify_esw_vport_context_in, in,
-		 field_select.fdb_to_vport_reg_c_id, 1);
-
-	return mlx5_eswitch_modify_esw_vport_context(esw, esw->manager_vport,
-						     in, sizeof(in));
-}
-
-static int mlx5_eswitch_disable_passing_vport_metadata(struct mlx5_eswitch=
 *esw)
-{
-	u32 out[MLX5_ST_SZ_DW(query_esw_vport_context_out)] =3D {};
-	u32 in[MLX5_ST_SZ_DW(modify_esw_vport_context_in)] =3D {};
-	u8 fdb_to_vport_reg_c_id;
-	int err;
+	if (!mlx5_eswitch_vport_match_metadata_enabled(esw))
+		return 0;
=20
 	err =3D mlx5_eswitch_query_esw_vport_context(esw, esw->manager_vport,
 						   out, sizeof(out));
@@ -628,7 +605,10 @@ static int mlx5_eswitch_disable_passing_vport_metadata=
(struct mlx5_eswitch *esw)
 	fdb_to_vport_reg_c_id =3D MLX5_GET(query_esw_vport_context_out, out,
 					 esw_vport_context.fdb_to_vport_reg_c_id);
=20
-	fdb_to_vport_reg_c_id &=3D ~MLX5_FDB_TO_VPORT_REG_C_0;
+	if (enable)
+		fdb_to_vport_reg_c_id |=3D MLX5_FDB_TO_VPORT_REG_C_0;
+	else
+		fdb_to_vport_reg_c_id &=3D ~MLX5_FDB_TO_VPORT_REG_C_0;
=20
 	MLX5_SET(modify_esw_vport_context_in, in,
 		 esw_vport_context.fdb_to_vport_reg_c_id, fdb_to_vport_reg_c_id);
@@ -2138,11 +2118,9 @@ int esw_offloads_init(struct mlx5_eswitch *esw)
 	if (err)
 		return err;
=20
-	if (mlx5_eswitch_vport_match_metadata_enabled(esw)) {
-		err =3D mlx5_eswitch_enable_passing_vport_metadata(esw);
-		if (err)
-			goto err_vport_metadata;
-	}
+	err =3D esw_set_passing_vport_metadata(esw, true);
+	if (err)
+		goto err_vport_metadata;
=20
 	err =3D esw_offloads_load_all_reps(esw);
 	if (err)
@@ -2156,8 +2134,7 @@ int esw_offloads_init(struct mlx5_eswitch *esw)
 	return 0;
=20
 err_reps:
-	if (mlx5_eswitch_vport_match_metadata_enabled(esw))
-		mlx5_eswitch_disable_passing_vport_metadata(esw);
+	esw_set_passing_vport_metadata(esw, false);
 err_vport_metadata:
 	esw_offloads_steering_cleanup(esw);
 	return err;
@@ -2187,8 +2164,7 @@ void esw_offloads_cleanup(struct mlx5_eswitch *esw)
 	mlx5_rdma_disable_roce(esw->dev);
 	esw_offloads_devcom_cleanup(esw);
 	esw_offloads_unload_all_reps(esw);
-	if (mlx5_eswitch_vport_match_metadata_enabled(esw))
-		mlx5_eswitch_disable_passing_vport_metadata(esw);
+	esw_set_passing_vport_metadata(esw, false);
 	esw_offloads_steering_cleanup(esw);
 	esw->offloads.encap =3D DEVLINK_ESWITCH_ENCAP_MODE_NONE;
 }
--=20
2.21.0

