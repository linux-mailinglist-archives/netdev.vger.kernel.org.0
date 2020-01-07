Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71F41132F23
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 20:14:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728797AbgAGTOe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 14:14:34 -0500
Received: from mail-vi1eur05on2055.outbound.protection.outlook.com ([40.107.21.55]:6105
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728784AbgAGTOd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Jan 2020 14:14:33 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iWTSoXTqvzpmX94xzJNJjmgZC4HBj/pgsV4ONVoK/zqq2aYa44+xQENMOnhRBCYSWkq0DTGi/P4mY+jGWVDs/2HsBuuQ+7MVLUahbRxs+0eRT9Hz3oobQSq1nqZKQK197LXu5H/L/wJpyDgoD2pY0+Y5e4s6MH7AyGCu0UgrwvqXBgzrldiT1/FWmv7VLevLlthPCPTMyDrSvJKwz4iahxFkkIp0qR00MHCOYDGlHe0LPPfdMDtemlFnDtlaVz947LlkZm3z+Z7NNd8PRjx2EsTc5re7Cl50hpgnnIJE+m1iqLAlWB7O4b+DcK7Gl2904Slid/JdBelZUKSgjv5Bgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aVj+jo3tEd+1OQ6Wnb/y+X5nKHWnFOL9rCzbgl6fIi8=;
 b=hxh0jX4udoUvyQvOcqGb3/iZ0s5hMnk0eRq1xucfXeu+7Gv4zOt/4aYx5QNH1EZMgNFCFdlatcNvfoWO7THgI2hpKclC5Y7Pa0pJZsgJhLuLM7DCxHTOEBK/6Dk3RevueZdd/q6gSlRdEETU2TI4UIlpXL/Mm5yhrZoOj03WF+0+BpMXa81GSC6k7QSZQoj2ERbsE/mH5fvTkX0h7YBVN7QhVM+OBIBMO8TwX7teVqJq6HTUbfuvtvcRrXojsKrprYybYCE1eefLozUaDTMb6Yu2qO23G8LZuiG8UcET8h3ouHQs2mzb6w5+fua9GGDKbkvVJyCcaOP8V/OAuXEuhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aVj+jo3tEd+1OQ6Wnb/y+X5nKHWnFOL9rCzbgl6fIi8=;
 b=SZPH5U3p53TxlJbVvYFXIqLIgs396m8t+yGG5abPOZB7SOAgNH1agHF7iXE9HH3jqlUT/YrHTvIfC/0xoTYzmRkbdxqob00OZtURq6YhWA5Psgp9MpfeMibgNv/r9LXVo8A/YRmxigJDwurdG6hD9xxwlLd/Q8wcDMnQHuXdFAA=
Received: from AM6PR05MB5094.eurprd05.prod.outlook.com (20.177.34.93) by
 AM6PR05MB5411.eurprd05.prod.outlook.com (20.177.189.90) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2602.11; Tue, 7 Jan 2020 19:14:22 +0000
Received: from AM6PR05MB5094.eurprd05.prod.outlook.com
 ([fe80::d9f3:f3b8:86b2:a40a]) by AM6PR05MB5094.eurprd05.prod.outlook.com
 ([fe80::d9f3:f3b8:86b2:a40a%7]) with mapi id 15.20.2602.015; Tue, 7 Jan 2020
 19:14:22 +0000
Received: from smtp.office365.com (209.116.155.178) by BYAPR06CA0068.namprd06.prod.outlook.com (2603:10b6:a03:14b::45) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2581.12 via Frontend Transport; Tue, 7 Jan 2020 19:14:20 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Erez Shitrit <erezsh@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 10/13] net/mlx5: DR, Pass table flags at creation to lower
 layer
Thread-Topic: [net-next 10/13] net/mlx5: DR, Pass table flags at creation to
 lower layer
Thread-Index: AQHVxY6qOpifm9At6EOGhPvh0/V00Q==
Date:   Tue, 7 Jan 2020 19:14:21 +0000
Message-ID: <20200107191335.12272-11-saeedm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: f43b6baf-a8b4-4428-a567-08d793a5cd02
x-ms-traffictypediagnostic: AM6PR05MB5411:|AM6PR05MB5411:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM6PR05MB5411576B9892F0F1410565B6BE3F0@AM6PR05MB5411.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:949;
x-forefront-prvs: 027578BB13
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(366004)(136003)(346002)(39860400002)(376002)(199004)(189003)(81166006)(52116002)(6916009)(8936002)(81156014)(8676002)(26005)(86362001)(36756003)(316002)(5660300002)(107886003)(6506007)(4326008)(478600001)(1076003)(16526019)(956004)(2616005)(2906002)(66446008)(64756008)(66556008)(66476007)(71200400001)(66946007)(6486002)(6512007)(54906003)(186003)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR05MB5411;H:AM6PR05MB5094.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: m4HgCJbMmn+9mIyI1gukQX0Uyp9lmU0Hbb4BPV7vTZ0oQ/d1fryGasTLl4Un3LZbg7zQtiMuBMlMGEDAvIEMPQ8GARzGE+gXQtbTc3wKCvo8JUSMQedCIUqLOrtzeDyZhfDU2ycyb+8mIuSeLfOA4+4bv0hgD3seYCloMcG1PoqiGhthmP8vSAhREi4tFbBT9I6jZKbT8NUKCV+6dWudt5sJfD8SdvunwlqKKSWTsf5KlY0F6Ry/pJnw2/JGSzauxUP7PPS/O1c4vIfhklYD8gOdGeELQfKgqxOeHawUs6oC6KNZJtJ4/5LKr16UNHmy8oG3mVHO625olNxk8XJuc9+SsOcBgYob4c2kOYQoyo2e1vX7LhA9EoUnOdjprdlSEqDhF/XwsZWXz9uvRWElOQ6S4MJrjswaDvSpu5T0+ecwZznuvbuSC3//l/3tVTyatcZZXo3n1x8DhFEWpfmdhVcYg/6vlzrQ5w2WaBqxF29eUUeRLEr8IYT54mLhUPZw/pao0OI0DPEF0VVZ+y2VizVwsvJDa3y6or2e4T587/k=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f43b6baf-a8b4-4428-a567-08d793a5cd02
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jan 2020 19:14:21.5843
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dqw3W/eAjPZqBxn16mn9nbBeE4SkMCdyp9Zjb0KISkcY46++YXwiq3lrnJ3zDGATPwGDi52TgyNtTt0+zJJp/A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB5411
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Erez Shitrit <erezsh@mellanox.com>

We need to have the flow-table flags when creation sw-steering tables,
this parameter exists in the layer between fs_core to sw_steering, this
patch gives it to the creation function.

Signed-off-by: Erez Shitrit <erezsh@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/steering/dr_table.c    | 7 ++++++-
 .../net/ethernet/mellanox/mlx5/core/steering/dr_types.h    | 1 +
 drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c   | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5dr.h  | 4 ++--
 4 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_table.c b/=
drivers/net/ethernet/mellanox/mlx5/core/steering/dr_table.c
index 7a4e6a43bdea..14ce2d7dbb66 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_table.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_table.c
@@ -211,6 +211,8 @@ static int dr_table_destroy_sw_owned_tbl(struct mlx5dr_=
table *tbl)
=20
 static int dr_table_create_sw_owned_tbl(struct mlx5dr_table *tbl)
 {
+	bool en_encap =3D !!(tbl->flags & MLX5_FLOW_TABLE_TUNNEL_EN_REFORMAT);
+	bool en_decap =3D !!(tbl->flags & MLX5_FLOW_TABLE_TUNNEL_EN_DECAP);
 	struct mlx5dr_cmd_create_flow_table_attr ft_attr =3D {};
 	u64 icm_addr_rx =3D 0;
 	u64 icm_addr_tx =3D 0;
@@ -227,6 +229,8 @@ static int dr_table_create_sw_owned_tbl(struct mlx5dr_t=
able *tbl)
 	ft_attr.icm_addr_tx =3D icm_addr_tx;
 	ft_attr.level =3D tbl->dmn->info.caps.max_ft_level - 1;
 	ft_attr.sw_owner =3D true;
+	ft_attr.decap_en =3D en_decap;
+	ft_attr.reformat_en =3D en_encap;
=20
 	ret =3D mlx5dr_cmd_create_flow_table(tbl->dmn->mdev, &ft_attr,
 					   NULL, &tbl->table_id);
@@ -234,7 +238,7 @@ static int dr_table_create_sw_owned_tbl(struct mlx5dr_t=
able *tbl)
 	return ret;
 }
=20
-struct mlx5dr_table *mlx5dr_table_create(struct mlx5dr_domain *dmn, u32 le=
vel)
+struct mlx5dr_table *mlx5dr_table_create(struct mlx5dr_domain *dmn, u32 le=
vel, u32 flags)
 {
 	struct mlx5dr_table *tbl;
 	int ret;
@@ -247,6 +251,7 @@ struct mlx5dr_table *mlx5dr_table_create(struct mlx5dr_=
domain *dmn, u32 level)
=20
 	tbl->dmn =3D dmn;
 	tbl->level =3D level;
+	tbl->flags =3D flags;
 	refcount_set(&tbl->refcount, 1);
=20
 	ret =3D dr_table_init(tbl);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h b/=
drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
index c37226a14311..de6bfa655326 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
@@ -679,6 +679,7 @@ struct mlx5dr_table {
 	u32 level;
 	u32 table_type;
 	u32 table_id;
+	u32 flags;
 	struct list_head matcher_list;
 	struct mlx5dr_action *miss_action;
 	refcount_t refcount;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c b/dri=
vers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c
index 3d587d0bdbbe..8ed0f087b1e0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c
@@ -74,7 +74,7 @@ static int mlx5_cmd_dr_create_flow_table(struct mlx5_flow=
_root_namespace *ns,
 								    next_ft);
=20
 	tbl =3D mlx5dr_table_create(ns->fs_dr_domain.dr_domain,
-				  ft->level);
+				  ft->level, ft->flags);
 	if (!tbl) {
 		mlx5_core_err(ns->dev, "Failed creating dr flow_table\n");
 		return -EINVAL;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5dr.h b/dr=
ivers/net/ethernet/mellanox/mlx5/core/steering/mlx5dr.h
index adda9cbfba45..fb3ac697df1b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5dr.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5dr.h
@@ -46,7 +46,7 @@ void mlx5dr_domain_set_peer(struct mlx5dr_domain *dmn,
 			    struct mlx5dr_domain *peer_dmn);
=20
 struct mlx5dr_table *
-mlx5dr_table_create(struct mlx5dr_domain *domain, u32 level);
+mlx5dr_table_create(struct mlx5dr_domain *domain, u32 level, u32 flags);
=20
 int mlx5dr_table_destroy(struct mlx5dr_table *table);
=20
@@ -131,7 +131,7 @@ mlx5dr_domain_set_peer(struct mlx5dr_domain *dmn,
 		       struct mlx5dr_domain *peer_dmn) { }
=20
 static inline struct mlx5dr_table *
-mlx5dr_table_create(struct mlx5dr_domain *domain, u32 level) { return NULL=
; }
+mlx5dr_table_create(struct mlx5dr_domain *domain, u32 level, u32 flags) { =
return NULL; }
=20
 static inline int
 mlx5dr_table_destroy(struct mlx5dr_table *table) { return 0; }
--=20
2.24.1

