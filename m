Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7529414008B
	for <lists+netdev@lfdr.de>; Fri, 17 Jan 2020 01:07:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388231AbgAQAH0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 19:07:26 -0500
Received: from mail-eopbgr70079.outbound.protection.outlook.com ([40.107.7.79]:19560
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729047AbgAQAHV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 19:07:21 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=da1CaFk+xhnb5iHq7Xx7hV76zcdj1OXlA+FI/S4fc9dcU+rKuDXjOBTvty9ouKLcBC0E9xkov7VcCGFRpM32gcuvBlYSoTBUzpLubv023FRIZDArcGXONP33QN2CuAysScku8vEzUcOCGLgifF56pG2MUAKe0fo2BGAQ5WagDKtNalLi7aFtPXTmP/fSqH/0COBZDs/1sbQE9UMPtRpnLqOtxyo8r9dbvXnlWVoht7gRNPBErUxDcJCZ4ogM+mhHuABhRKHysnmb6YaBT+9QgH9K+GY4o+07pzl1k3a/MCOjBbgM16DuYtU0EMx3lRTzfexhdRwWmxPapqxFHTZ3zA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mDw9Nk3bazM2uzRgsKfEOE/Mq10w1E2pjFjS+/wO8Ho=;
 b=JWR2fNF+5UUU27DQm1Sl6OSHY0kat1lrnx/rUbm6Us6cNV3tFhaxQonnZjO2vtNXOrX4RasLM2epW/mG9oAcJbZsO1i6iEkdr+ZIYF4O8EPGlmfBH9KLV15zjEYZsj0unJmZSBa2tDhDLzDwxaWQaTgNW7aMXVszJY1poDXhm5J0H4BRYdxxeUYarnTatdGZxtHJSsHwJxYvROsomPEZB/eQPhV56uuwAgU6liunL2S5NchDy82c8LrEiMiTBtAjEX7r7jdAgeU3SWq6+vA+ob+rY3LcggJ0eFrXcZ7B+9zoHMpcZ9E4JJa6Jt5fZl317GVy8dcVEZ99l/QEAoPPgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mDw9Nk3bazM2uzRgsKfEOE/Mq10w1E2pjFjS+/wO8Ho=;
 b=FRrqXXdXt2oNCJmJexlkLbo+03kTVS7lJfQHBvxFtcVgJTw8rPl747B5cKCkj841f0c1bDvMmKBg2Kza7ze85c6cQ/Noo17tcDZSPbAJaT7d6uiXQF4fhFZ7X6ERJyRghEvJ7vGD+6g5uO0r1urSdnKDK3ZrkGkfIKI58IYpbw4=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB4990.eurprd05.prod.outlook.com (20.177.49.211) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2623.10; Fri, 17 Jan 2020 00:07:13 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096%6]) with mapi id 15.20.2644.015; Fri, 17 Jan 2020
 00:07:13 +0000
Received: from smtp.office365.com (209.116.155.178) by BYAPR03CA0003.namprd03.prod.outlook.com (2603:10b6:a02:a8::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.18 via Frontend Transport; Fri, 17 Jan 2020 00:07:11 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Paul Blakey <paulb@mellanox.com>,
        Roi Dayan <roid@mellanox.com>, Oz Shlomo <ozsh@mellanox.com>,
        Mark Bloch <markb@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 10/16] net/mlx5: fs_core: Introduce unmanaged flow tables
Thread-Topic: [net-next 10/16] net/mlx5: fs_core: Introduce unmanaged flow
 tables
Thread-Index: AQHVzMoSYHOMJ9DjoE6zfpLWbOACig==
Date:   Fri, 17 Jan 2020 00:07:13 +0000
Message-ID: <20200117000619.696775-11-saeedm@mellanox.com>
References: <20200117000619.696775-1-saeedm@mellanox.com>
In-Reply-To: <20200117000619.696775-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.24.1
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR03CA0003.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::16) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: b6d4fd59-05ab-4028-1e48-08d79ae1344c
x-ms-traffictypediagnostic: VI1PR05MB4990:|VI1PR05MB4990:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB499042C0A15BFACB2876024CBE310@VI1PR05MB4990.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-forefront-prvs: 0285201563
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(396003)(366004)(39860400002)(136003)(346002)(189003)(199004)(64756008)(6512007)(52116002)(66476007)(26005)(81166006)(86362001)(16526019)(316002)(81156014)(8676002)(2616005)(66556008)(186003)(6486002)(956004)(71200400001)(36756003)(508600001)(66446008)(54906003)(1076003)(5660300002)(2906002)(6506007)(4326008)(110136005)(8936002)(66946007)(107886003)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4990;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qWrch60LDq+1v/F3pX/lBNMC+YbGjxbvbRkd4zHYwBovtRxer0q0cn3DXgnEsc/FomcDf2orSxcyqjFD47NX0/qnAVP5tAeosZbdt2mTmGjeIy+rgnQ5jDhDjme0/FsNE8pqAlFMTyCDxWMStLVUjetW0fbWzG5712ruDrhDVM6EA7ySthFmQfiLYI9EAQXo+MuZrmiKwiaOD3/OYKZEMgE/W003Zh/2iiY1qAqNzU3daiBUvonEOw+KL4a5yyc2TZk9Ab4OI0a9rYrY53kLH/je9Dy2eU+YqCpVfMrFEMhU4gCnoyHj8bAkmPjh3ZuO2RQxgNr/DRAChC9iLwkAw6Azo45UpmO43LvVl5Sxk43cXmp1zqxsdk+zxQeZ2wt8Oka3gzQakvwRW1aXKTlC37v/7epCQWVvV6ZHhn+xOvhipZuNxp9xeMYLMhCmUrQdtdr18VuSl5uTTesgzOgAS4sWNi1xSiq3KMW4DXymqOebBCzQM0xvyKXTw+dUxO2SmZtAGaOz92+HZFFisT0U0lT+TjE391cV6SawZ8Ki94k=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b6d4fd59-05ab-4028-1e48-08d79ae1344c
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jan 2020 00:07:13.6474
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zM6WrVmEQS1BkiXQmw8GphjuRH/BHNIg3AdK/56o0XTkY8GfcMEj+jBfLc8nvBOzQcvwl0WHeGRHiTDPMwoSxw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4990
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paul Blakey <paulb@mellanox.com>

Currently, Most of the steering tree is statically declared ahead of time,
with steering prios instances allocated for each fdb chain to assign max
number of levels for each of them. This allows fs_core to manage the
connections and  levels of the flow tables hierarcy to prevent loops, but
restricts us with the number of supported chains and priorities.

Introduce unmananged flow tables, allowing the user to manage the flow
table connections. A unamanged table is detached from the fs_core flow
table hierarcy, and is only connected back to the hierarchy by explicit
FTEs forward actions.

This will be used together with firmware that supports ignoring the flow
table levels to increase the number of supported chains and prios.

Signed-off-by: Paul Blakey <paulb@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Reviewed-by: Oz Shlomo <ozsh@mellanox.com>
Reviewed-by: Mark Bloch <markb@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/fs_core.c | 41 +++++++++++++------
 include/linux/mlx5/fs.h                       |  2 +
 2 files changed, 31 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c b/drivers/ne=
t/ethernet/mellanox/mlx5/core/fs_core.c
index 51913e2cde5c..456d3739b166 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -1006,7 +1006,8 @@ static struct mlx5_flow_table *__mlx5_create_flow_tab=
le(struct mlx5_flow_namespa
 							u16 vport)
 {
 	struct mlx5_flow_root_namespace *root =3D find_root(&ns->node);
-	struct mlx5_flow_table *next_ft =3D NULL;
+	bool unmanaged =3D ft_attr->flags & MLX5_FLOW_TABLE_UNMANAGED;
+	struct mlx5_flow_table *next_ft;
 	struct fs_prio *fs_prio =3D NULL;
 	struct mlx5_flow_table *ft;
 	int log_table_sz;
@@ -1023,14 +1024,21 @@ static struct mlx5_flow_table *__mlx5_create_flow_t=
able(struct mlx5_flow_namespa
 		err =3D -EINVAL;
 		goto unlock_root;
 	}
-	if (ft_attr->level >=3D fs_prio->num_levels) {
-		err =3D -ENOSPC;
-		goto unlock_root;
+	if (!unmanaged) {
+		/* The level is related to the
+		 * priority level range.
+		 */
+		if (ft_attr->level >=3D fs_prio->num_levels) {
+			err =3D -ENOSPC;
+			goto unlock_root;
+		}
+
+		ft_attr->level +=3D fs_prio->start_level;
 	}
+
 	/* The level is related to the
 	 * priority level range.
 	 */
-	ft_attr->level +=3D fs_prio->start_level;
 	ft =3D alloc_flow_table(ft_attr->level,
 			      vport,
 			      ft_attr->max_fte ? roundup_pow_of_two(ft_attr->max_fte) : 0,
@@ -1043,19 +1051,27 @@ static struct mlx5_flow_table *__mlx5_create_flow_t=
able(struct mlx5_flow_namespa
=20
 	tree_init_node(&ft->node, del_hw_flow_table, del_sw_flow_table);
 	log_table_sz =3D ft->max_fte ? ilog2(ft->max_fte) : 0;
-	next_ft =3D find_next_chained_ft(fs_prio);
+	next_ft =3D unmanaged ? ft_attr->next_ft :
+			      find_next_chained_ft(fs_prio);
 	ft->def_miss_action =3D ns->def_miss_action;
 	err =3D root->cmds->create_flow_table(root, ft, log_table_sz, next_ft);
 	if (err)
 		goto free_ft;
=20
-	err =3D connect_flow_table(root->dev, ft, fs_prio);
-	if (err)
-		goto destroy_ft;
+	if (!unmanaged) {
+		err =3D connect_flow_table(root->dev, ft, fs_prio);
+		if (err)
+			goto destroy_ft;
+	}
+
 	ft->node.active =3D true;
 	down_write_ref_node(&fs_prio->node, false);
-	tree_add_node(&ft->node, &fs_prio->node);
-	list_add_flow_table(ft, fs_prio);
+	if (!unmanaged) {
+		tree_add_node(&ft->node, &fs_prio->node);
+		list_add_flow_table(ft, fs_prio);
+	} else {
+		ft->node.root =3D fs_prio->node.root;
+	}
 	fs_prio->num_ft++;
 	up_write_ref_node(&fs_prio->node, false);
 	mutex_unlock(&root->chain_lock);
@@ -2024,7 +2040,8 @@ int mlx5_destroy_flow_table(struct mlx5_flow_table *f=
t)
 	int err =3D 0;
=20
 	mutex_lock(&root->chain_lock);
-	err =3D disconnect_flow_table(ft);
+	if (!(ft->flags & MLX5_FLOW_TABLE_UNMANAGED))
+		err =3D disconnect_flow_table(ft);
 	if (err) {
 		mutex_unlock(&root->chain_lock);
 		return err;
diff --git a/include/linux/mlx5/fs.h b/include/linux/mlx5/fs.h
index a3f8b63839de..de2c838bae90 100644
--- a/include/linux/mlx5/fs.h
+++ b/include/linux/mlx5/fs.h
@@ -48,6 +48,7 @@ enum {
 	MLX5_FLOW_TABLE_TUNNEL_EN_REFORMAT =3D BIT(0),
 	MLX5_FLOW_TABLE_TUNNEL_EN_DECAP =3D BIT(1),
 	MLX5_FLOW_TABLE_TERMINATION =3D BIT(2),
+	MLX5_FLOW_TABLE_UNMANAGED =3D BIT(3),
 };
=20
 #define LEFTOVERS_RULE_NUM	 2
@@ -150,6 +151,7 @@ struct mlx5_flow_table_attr {
 	int max_fte;
 	u32 level;
 	u32 flags;
+	struct mlx5_flow_table *next_ft;
=20
 	struct {
 		int max_num_groups;
--=20
2.24.1

