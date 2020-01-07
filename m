Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9EA65132F1F
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 20:14:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728774AbgAGTO0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 14:14:26 -0500
Received: from mail-vi1eur05on2055.outbound.protection.outlook.com ([40.107.21.55]:6105
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728726AbgAGTOZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Jan 2020 14:14:25 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=acC+J75srTfZFz5+tfA/uwm24y4PnhhSYrkm4nMF8WNyE6kwYwWWl/qIsRMYKOXedsG7yqQNhrDssN7WmKQGY/gkDiqZywn705AXpVjeOlJYRBmfCPEdupCVkZhuHYZZABg4Y5mozL3vMoCv0HAobCLGrVSNsIod/xCBPTO+HIPxt63LKs0EIc5sQp5LA8zOHU7quIfaE3h3wav4qJPuA3MzscF1T9qHVm+AHtVH7t8EEefeUEZB1zVArbL4Ux8w6+xvbn/RWBu1m5iM58ykULsP8Lglg7C6/DElqe3aLGf8CQQ6x0xrR/1BYlWetqOSTkOWwrnbleDAGadUBGoA1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gwK7dahji+bDP98ysDbcn/fphtzKRNnjFRAKQd7d7fc=;
 b=CTUzTurX7LBdrsmNqOUEh796+yo6WvKxJFxMMq0d5JxqfoySMBh5NEYydUXQ8vA3sAWVZxqdnb/3boSuLKVR8nF9mgMcoAlvwS3V2sRu46OoPBFcfZpOlMbuZ0B4ie67ARyz7/0rlNuxesMW6Q2kC2EoNejKzL8Nw1/O7L3QQIdETLlNqEegDbkBgYkwMvqdlXl+tLjZaPCUDw+LF46ZPx/etorlJp469NSqXzjo+tXVwt75C5o6DltcNjUIZXM/azd21VdhlQAMSeXVmInslU/rhrTOBiXbArrqMIx6+Saf7BSgpFyTY7eLkcEYiTjZP4vmZgN6rIal442C5eucrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gwK7dahji+bDP98ysDbcn/fphtzKRNnjFRAKQd7d7fc=;
 b=QjfY9+6LUbpG3ZOehpO6IygWc7VYP38gIFue/gV19q3s7vm6WmVNw/RkQXqZaFqABmV9BQWoKaBGzfysrhEjEn87WJF6+VI0mKh5gFzxSiz81KGTMtBbWBaryAJSK/v9bTKUUgLxCDF9YfY0iOiUKrhCfGK9MmPA7ttd8ml29h0=
Received: from AM6PR05MB5094.eurprd05.prod.outlook.com (20.177.34.93) by
 AM6PR05MB5411.eurprd05.prod.outlook.com (20.177.189.90) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2602.11; Tue, 7 Jan 2020 19:14:17 +0000
Received: from AM6PR05MB5094.eurprd05.prod.outlook.com
 ([fe80::d9f3:f3b8:86b2:a40a]) by AM6PR05MB5094.eurprd05.prod.outlook.com
 ([fe80::d9f3:f3b8:86b2:a40a%7]) with mapi id 15.20.2602.015; Tue, 7 Jan 2020
 19:14:17 +0000
Received: from smtp.office365.com (209.116.155.178) by BYAPR06CA0068.namprd06.prod.outlook.com (2603:10b6:a03:14b::45) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2581.12 via Frontend Transport; Tue, 7 Jan 2020 19:14:15 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alex Vesker <valex@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 07/13] net/mlx5: DR, Use attributes struct for FW flow
 table creation
Thread-Topic: [net-next 07/13] net/mlx5: DR, Use attributes struct for FW flow
 table creation
Thread-Index: AQHVxY6nj2sItiY4JUGu4GBXhSs2CA==
Date:   Tue, 7 Jan 2020 19:14:16 +0000
Message-ID: <20200107191335.12272-8-saeedm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: 1d5a0437-853f-44f7-0109-08d793a5ca21
x-ms-traffictypediagnostic: AM6PR05MB5411:|AM6PR05MB5411:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM6PR05MB54114BC6ABA617AB4BB3D228BE3F0@AM6PR05MB5411.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:46;
x-forefront-prvs: 027578BB13
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(366004)(136003)(346002)(39860400002)(376002)(199004)(189003)(81166006)(52116002)(6916009)(8936002)(81156014)(8676002)(26005)(86362001)(36756003)(316002)(5660300002)(107886003)(6506007)(4326008)(478600001)(1076003)(16526019)(956004)(2616005)(2906002)(66446008)(64756008)(66556008)(66476007)(71200400001)(66946007)(6486002)(6512007)(54906003)(186003)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR05MB5411;H:AM6PR05MB5094.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 88QlCeGQOflBjuelNMAOXswzd2CVDWafp0eR/bo/8/irVb7ZiqlmxIlTuF0xTgrsodnPLHwFvR9mChWJtzHwTG+CYeCqOdEVgH6g/i20ZDQ+IOi3xpLCMCC7vg58meTvpXal8Roj4v+RgNTT0x4V+4Gmig44yLGgir/9/7STewLVb4gK6Gy5zxD8iX5cCSaRaQInqKFtKJixVn+zFUmzFI7MxXMqz0tBos4eEOUyv74F1v4W6/YV2FPwT+DTsBwrHrKOpwM25uxUluqyiN9SprrhZMsCMa2x4cqePwAglhlF9tSbXCu/JYSvda1AJ+Nm/X09NTVac4eJz5f+4YmqUvHoY26dPD+XHaGO6XD6TwC14WZpPgY4jzbElvIXzSm+pRdZIhpvBRmPpECVnSLVWZeSOEKqhgXQRNMkLv+g/ihWt/TZSQGcGGCXdazFWAKjT7dB/8LMxpO/ydiFyicOAQQttXrtjQvubJtNmMp+mumUKzzU35YKlZPiA20l3xtixKwf7mOfM49vuUKUVnk5K00bgNc2SrziAtXJLVYBFTQ=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d5a0437-853f-44f7-0109-08d793a5ca21
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jan 2020 19:14:16.7981
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: p+0Stx34W+aQ5hzyYVmSO0fjxEmyKjYFD53BpBRFGgSi8JXVfRKrl2VqZrf4+m7QjN1ro33YBp7QGn+i6FuzAQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB5411
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alex Vesker <valex@mellanox.com>

Instead of using multiple variables use a simple struct. The
number of passed argument was too high after adding the encap
decap support bits arguments used for multiple destination reformat.

Signed-off-by: Alex Vesker <valex@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../mellanox/mlx5/core/steering/dr_cmd.c      | 39 ++++++++++---------
 .../mellanox/mlx5/core/steering/dr_fw.c       | 12 ++++--
 .../mellanox/mlx5/core/steering/dr_table.c    | 16 ++++----
 .../mellanox/mlx5/core/steering/dr_types.h    | 18 ++++++---
 4 files changed, 50 insertions(+), 35 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_cmd.c b/dr=
ivers/net/ethernet/mellanox/mlx5/core/steering/dr_cmd.c
index 41662c4e2664..ec35b297dcab 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_cmd.c
@@ -320,12 +320,7 @@ int mlx5dr_cmd_destroy_flow_group(struct mlx5_core_dev=
 *mdev,
 }
=20
 int mlx5dr_cmd_create_flow_table(struct mlx5_core_dev *mdev,
-				 u32 table_type,
-				 u64 icm_addr_rx,
-				 u64 icm_addr_tx,
-				 u8 level,
-				 bool sw_owner,
-				 bool term_tbl,
+				 struct mlx5dr_cmd_create_flow_table_attr *attr,
 				 u64 *fdb_rx_icm_addr,
 				 u32 *table_id)
 {
@@ -335,37 +330,43 @@ int mlx5dr_cmd_create_flow_table(struct mlx5_core_dev=
 *mdev,
 	int err;
=20
 	MLX5_SET(create_flow_table_in, in, opcode, MLX5_CMD_OP_CREATE_FLOW_TABLE)=
;
-	MLX5_SET(create_flow_table_in, in, table_type, table_type);
+	MLX5_SET(create_flow_table_in, in, table_type, attr->table_type);
=20
 	ft_mdev =3D MLX5_ADDR_OF(create_flow_table_in, in, flow_table_context);
-	MLX5_SET(flow_table_context, ft_mdev, termination_table, term_tbl);
-	MLX5_SET(flow_table_context, ft_mdev, sw_owner, sw_owner);
-	MLX5_SET(flow_table_context, ft_mdev, level, level);
+	MLX5_SET(flow_table_context, ft_mdev, termination_table, attr->term_tbl);
+	MLX5_SET(flow_table_context, ft_mdev, sw_owner, attr->sw_owner);
+	MLX5_SET(flow_table_context, ft_mdev, level, attr->level);
=20
-	if (sw_owner) {
+	if (attr->sw_owner) {
 		/* icm_addr_0 used for FDB RX / NIC TX / NIC_RX
 		 * icm_addr_1 used for FDB TX
 		 */
-		if (table_type =3D=3D MLX5_FLOW_TABLE_TYPE_NIC_RX) {
+		if (attr->table_type =3D=3D MLX5_FLOW_TABLE_TYPE_NIC_RX) {
 			MLX5_SET64(flow_table_context, ft_mdev,
-				   sw_owner_icm_root_0, icm_addr_rx);
-		} else if (table_type =3D=3D MLX5_FLOW_TABLE_TYPE_NIC_TX) {
+				   sw_owner_icm_root_0, attr->icm_addr_rx);
+		} else if (attr->table_type =3D=3D MLX5_FLOW_TABLE_TYPE_NIC_TX) {
 			MLX5_SET64(flow_table_context, ft_mdev,
-				   sw_owner_icm_root_0, icm_addr_tx);
-		} else if (table_type =3D=3D MLX5_FLOW_TABLE_TYPE_FDB) {
+				   sw_owner_icm_root_0, attr->icm_addr_tx);
+		} else if (attr->table_type =3D=3D MLX5_FLOW_TABLE_TYPE_FDB) {
 			MLX5_SET64(flow_table_context, ft_mdev,
-				   sw_owner_icm_root_0, icm_addr_rx);
+				   sw_owner_icm_root_0, attr->icm_addr_rx);
 			MLX5_SET64(flow_table_context, ft_mdev,
-				   sw_owner_icm_root_1, icm_addr_tx);
+				   sw_owner_icm_root_1, attr->icm_addr_tx);
 		}
 	}
=20
+	MLX5_SET(create_flow_table_in, in, flow_table_context.decap_en,
+		 attr->decap_en);
+	MLX5_SET(create_flow_table_in, in, flow_table_context.reformat_en,
+		 attr->reformat_en);
+
 	err =3D mlx5_cmd_exec(mdev, in, sizeof(in), out, sizeof(out));
 	if (err)
 		return err;
=20
 	*table_id =3D MLX5_GET(create_flow_table_out, out, table_id);
-	if (!sw_owner && table_type =3D=3D MLX5_FLOW_TABLE_TYPE_FDB)
+	if (!attr->sw_owner && attr->table_type =3D=3D MLX5_FLOW_TABLE_TYPE_FDB &=
&
+	    fdb_rx_icm_addr)
 		*fdb_rx_icm_addr =3D
 		(u64)MLX5_GET(create_flow_table_out, out, icm_address_31_0) |
 		(u64)MLX5_GET(create_flow_table_out, out, icm_address_39_32) << 32 |
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_fw.c b/dri=
vers/net/ethernet/mellanox/mlx5/core/steering/dr_fw.c
index 60ef6e6171e3..9d2180cb095f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_fw.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_fw.c
@@ -7,6 +7,7 @@
 struct mlx5dr_fw_recalc_cs_ft *
 mlx5dr_fw_create_recalc_cs_ft(struct mlx5dr_domain *dmn, u32 vport_num)
 {
+	struct mlx5dr_cmd_create_flow_table_attr ft_attr =3D {};
 	struct mlx5dr_fw_recalc_cs_ft *recalc_cs_ft;
 	u32 table_id, group_id, modify_hdr_id;
 	u64 rx_icm_addr, modify_ttl_action;
@@ -16,9 +17,14 @@ mlx5dr_fw_create_recalc_cs_ft(struct mlx5dr_domain *dmn,=
 u32 vport_num)
 	if (!recalc_cs_ft)
 		return NULL;
=20
-	ret =3D mlx5dr_cmd_create_flow_table(dmn->mdev, MLX5_FLOW_TABLE_TYPE_FDB,
-					   0, 0, dmn->info.caps.max_ft_level - 1,
-					   false, true, &rx_icm_addr, &table_id);
+	ft_attr.table_type =3D MLX5_FLOW_TABLE_TYPE_FDB;
+	ft_attr.level =3D dmn->info.caps.max_ft_level - 1;
+	ft_attr.term_tbl =3D true;
+
+	ret =3D mlx5dr_cmd_create_flow_table(dmn->mdev,
+					   &ft_attr,
+					   &rx_icm_addr,
+					   &table_id);
 	if (ret) {
 		mlx5dr_err(dmn, "Failed creating TTL W/A FW flow table %d\n", ret);
 		goto free_ttl_tbl;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_table.c b/=
drivers/net/ethernet/mellanox/mlx5/core/steering/dr_table.c
index e178d8d3dbc9..7a4e6a43bdea 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_table.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_table.c
@@ -211,6 +211,7 @@ static int dr_table_destroy_sw_owned_tbl(struct mlx5dr_=
table *tbl)
=20
 static int dr_table_create_sw_owned_tbl(struct mlx5dr_table *tbl)
 {
+	struct mlx5dr_cmd_create_flow_table_attr ft_attr =3D {};
 	u64 icm_addr_rx =3D 0;
 	u64 icm_addr_tx =3D 0;
 	int ret;
@@ -221,13 +222,14 @@ static int dr_table_create_sw_owned_tbl(struct mlx5dr=
_table *tbl)
 	if (tbl->tx.s_anchor)
 		icm_addr_tx =3D tbl->tx.s_anchor->chunk->icm_addr;
=20
-	ret =3D mlx5dr_cmd_create_flow_table(tbl->dmn->mdev,
-					   tbl->table_type,
-					   icm_addr_rx,
-					   icm_addr_tx,
-					   tbl->dmn->info.caps.max_ft_level - 1,
-					   true, false, NULL,
-					   &tbl->table_id);
+	ft_attr.table_type =3D tbl->table_type;
+	ft_attr.icm_addr_rx =3D icm_addr_rx;
+	ft_attr.icm_addr_tx =3D icm_addr_tx;
+	ft_attr.level =3D tbl->dmn->info.caps.max_ft_level - 1;
+	ft_attr.sw_owner =3D true;
+
+	ret =3D mlx5dr_cmd_create_flow_table(tbl->dmn->mdev, &ft_attr,
+					   NULL, &tbl->table_id);
=20
 	return ret;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h b/=
drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
index 290fe61c33d0..bc82b76cf04e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
@@ -867,6 +867,17 @@ struct mlx5dr_cmd_query_flow_table_details {
 	u64 sw_owner_icm_root_0;
 };
=20
+struct mlx5dr_cmd_create_flow_table_attr {
+	u32 table_type;
+	u64 icm_addr_rx;
+	u64 icm_addr_tx;
+	u8 level;
+	bool sw_owner;
+	bool term_tbl;
+	bool decap_en;
+	bool reformat_en;
+};
+
 /* internal API functions */
 int mlx5dr_cmd_query_device(struct mlx5_core_dev *mdev,
 			    struct mlx5dr_cmd_caps *caps);
@@ -904,12 +915,7 @@ int mlx5dr_cmd_destroy_flow_group(struct mlx5_core_dev=
 *mdev,
 				  u32 table_id,
 				  u32 group_id);
 int mlx5dr_cmd_create_flow_table(struct mlx5_core_dev *mdev,
-				 u32 table_type,
-				 u64 icm_addr_rx,
-				 u64 icm_addr_tx,
-				 u8 level,
-				 bool sw_owner,
-				 bool term_tbl,
+				 struct mlx5dr_cmd_create_flow_table_attr *attr,
 				 u64 *fdb_rx_icm_addr,
 				 u32 *table_id);
 int mlx5dr_cmd_destroy_flow_table(struct mlx5_core_dev *mdev,
--=20
2.24.1

