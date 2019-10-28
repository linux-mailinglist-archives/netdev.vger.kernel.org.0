Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5524BE7D0D
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 00:36:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732510AbfJ1Xf7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 19:35:59 -0400
Received: from mail-eopbgr60058.outbound.protection.outlook.com ([40.107.6.58]:42382
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730930AbfJ1Xf6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Oct 2019 19:35:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j82lkbKPH0tPNgfQAoPLMSGZN6j1uZAAZcwIOtu/yT97tWJYgy07awt/jhsvXLY/s84nDC3qFpVxB3tQxtB4EfYWS2X1bgbL/H0sw5hWoW//Z4hoTYU2Znq5BrZ3qkqp8LD0ZY4lflwQVqK5SvwLzxMNXBKZ4pLV8pFfAsU8ZCeh/gDlgf0fdt0sDXdXxniqEmIA5GeMTCa+adfdXp/qjIjnmiVT0AxJj7YGRIyCQFV2+snNTFZsQWeIi7drce9qzqAubpRqCtgC+EcRqaM+lLC+Kw9t9PaAY9TxjG4E3aM6Qnv2vYbqkRe4lR28IHrvroAHP0sz5nfJzkNI2UesLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pOeSJ5mWon/A2IL8uCyFzNrE6uZ9M2wQM6NVSLSw/os=;
 b=YnSNJ9cbQlDFrznDPaljOCL2kp9cRATUmkVSlgHz49bKdwTCiFQZNrYxJxY2P2mzlIfP36BpYBhdShTo/s1kyfb+d0lJR8x5e2NEUxIoVSQHmIlhZgYOnAC+FvOo/oEpOvXIvuF0AHU4Cp8QJi6ImUg2GcvGnOUUEMUu1J87m1hDakRqpOWwNramBfV5PklK1EDHZcdAWrSHu8O7TezQrLbmgM1Odba5RjeBEQU9R1g6gnrmaT3L1hJbFZSy38FgQfXw/RtHgyGI6KS1/ya3S81Y4kKd5UpxyIh4SPsIxC5OKANgQZoNhvl08Aejdto3ESjNQEAlOZGsDx9TUjjWow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pOeSJ5mWon/A2IL8uCyFzNrE6uZ9M2wQM6NVSLSw/os=;
 b=aQBimRUuJEaxBxUl40cUh37nB3L2CHjZ6tipEeBzxsB5eBJ/Bor6zoVTwDHiiKuG2AOEisjrLU/42DeclElAkWxNPC8jlRNV2uACs3dtPOVEslrS6osfqBSMvL4VWw27S6+SgGH1NxKbrEZI+hFKWk5LVrAn2aWWUNX0DCSntvI=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB6448.eurprd05.prod.outlook.com (20.179.28.86) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2387.22; Mon, 28 Oct 2019 23:35:15 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e%5]) with mapi id 15.20.2387.027; Mon, 28 Oct 2019
 23:35:15 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Parav Pandit <parav@mellanox.com>,
        Vu Pham <vuhuong@mellanox.com>
Subject: [PATCH mlx5-next 10/18] net/mlx5: E-switch, Prepare code to handle
 vport enable error
Thread-Topic: [PATCH mlx5-next 10/18] net/mlx5: E-switch, Prepare code to
 handle vport enable error
Thread-Index: AQHVjehZ3YM59CKYlEiD0DTDpVk/gA==
Date:   Mon, 28 Oct 2019 23:35:15 +0000
Message-ID: <20191028233440.5564-11-saeedm@mellanox.com>
References: <20191028233440.5564-1-saeedm@mellanox.com>
In-Reply-To: <20191028233440.5564-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BY5PR13CA0021.namprd13.prod.outlook.com
 (2603:10b6:a03:180::34) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: f01a18c7-df75-462b-8141-08d75bff7c22
x-ms-traffictypediagnostic: VI1PR05MB6448:|VI1PR05MB6448:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB6448DC1FD76396BE75ED7C42BE660@VI1PR05MB6448.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2089;
x-forefront-prvs: 0204F0BDE2
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(376002)(366004)(346002)(396003)(39860400002)(189003)(199004)(3846002)(305945005)(8936002)(450100002)(316002)(478600001)(50226002)(86362001)(99286004)(71200400001)(81156014)(8676002)(81166006)(107886003)(71190400001)(186003)(66446008)(386003)(102836004)(6636002)(6506007)(14444005)(66476007)(66946007)(256004)(36756003)(52116002)(476003)(2616005)(11346002)(486006)(446003)(64756008)(6512007)(76176011)(6116002)(4326008)(26005)(7736002)(5660300002)(66066001)(14454004)(2906002)(110136005)(6436002)(6486002)(54906003)(1076003)(25786009)(66556008);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB6448;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Y9YKlVVmJDE/+pBEG64tqSenSZvnWwCskeNdZu3zB3Zwo17a4cum9f6z76UwXMQk8ICSaeqPllKfa2KR8gYgPsxdcA+J3LpzxxEkk8Pl/pfjsZzJnxZsBvhxWqGCk4rFbWRnuFHEJij3yB54n9mqamDSHOENnKa39rnvlvzGC4qV13Cm9vPbH5kTc95h65lrq5jhtKwyqDt88ZBJgpHKlwPen4iTH3RKBoSKyE3s6jyI7ZQXdM3ihb4s5tIRpQHxhbA9OBIeROf4u6eO9X9MOVN1s30tKwU9UJ7u6LQwp1Kco4yqW/0MpugHr32ExsyVp99nXw88ayc/rvEHtRPWEgoBoy/igiMx2i//246b/88VU3JTQYSlf9e6SjRDkDr2ZIY8WvlBwxixqonLs+ctFSsmpmZ0ZUw6wyuGdfGezDVC+ddKX9ydw2LxG4WN9cCh
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f01a18c7-df75-462b-8141-08d75bff7c22
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Oct 2019 23:35:15.5237
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6/toJ+6jruKmy9xMvpTTa6nRg7wdMroI/2QR/Kr+GbGD+s5X1eD1/HtAJS1qSEqlKzfYCxN6YqTAF+3yKwY1Rw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6448
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Parav Pandit <parav@mellanox.com>

In subsequent patch, esw_enable_vport() could fail and return error.
Prepare code to handle such error.

Signed-off-by: Parav Pandit <parav@mellanox.com>
Reviewed-by: Vu Pham <vuhuong@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/eswitch.c | 62 ++++++++++++++-----
 .../net/ethernet/mellanox/mlx5/core/eswitch.h |  2 +-
 .../mellanox/mlx5/core/eswitch_offloads.c     |  5 +-
 3 files changed, 50 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/ne=
t/ethernet/mellanox/mlx5/core/eswitch.c
index f15ffb8f5cac..0bdaef508e74 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -452,6 +452,13 @@ static int esw_create_legacy_table(struct mlx5_eswitch=
 *esw)
 	return err;
 }
=20
+static void esw_destroy_legacy_table(struct mlx5_eswitch *esw)
+{
+	esw_cleanup_vepa_rules(esw);
+	esw_destroy_legacy_fdb_table(esw);
+	esw_destroy_legacy_vepa_table(esw);
+}
+
 #define MLX5_LEGACY_SRIOV_VPORT_EVENTS (MLX5_VPORT_UC_ADDR_CHANGE | \
 					MLX5_VPORT_MC_ADDR_CHANGE | \
 					MLX5_VPORT_PROMISC_CHANGE)
@@ -464,15 +471,10 @@ static int esw_legacy_enable(struct mlx5_eswitch *esw=
)
 	if (ret)
 		return ret;
=20
-	mlx5_eswitch_enable_pf_vf_vports(esw, MLX5_LEGACY_SRIOV_VPORT_EVENTS);
-	return 0;
-}
-
-static void esw_destroy_legacy_table(struct mlx5_eswitch *esw)
-{
-	esw_cleanup_vepa_rules(esw);
-	esw_destroy_legacy_fdb_table(esw);
-	esw_destroy_legacy_vepa_table(esw);
+	ret =3D mlx5_eswitch_enable_pf_vf_vports(esw, MLX5_LEGACY_SRIOV_VPORT_EVE=
NTS);
+	if (ret)
+		esw_destroy_legacy_table(esw);
+	return ret;
 }
=20
 static void esw_legacy_disable(struct mlx5_eswitch *esw)
@@ -1704,8 +1706,8 @@ static void esw_legacy_vport_destroy_drop_counters(st=
ruct mlx5_vport *vport)
 		mlx5_fc_destroy(dev, vport->egress.legacy.drop_counter);
 }
=20
-static void esw_enable_vport(struct mlx5_eswitch *esw, struct mlx5_vport *=
vport,
-			     enum mlx5_eswitch_vport_event enabled_events)
+static int esw_enable_vport(struct mlx5_eswitch *esw, struct mlx5_vport *v=
port,
+			    enum mlx5_eswitch_vport_event enabled_events)
 {
 	u16 vport_num =3D vport->vport;
=20
@@ -1743,6 +1745,7 @@ static void esw_enable_vport(struct mlx5_eswitch *esw=
, struct mlx5_vport *vport,
 	esw->enabled_vports++;
 	esw_debug(esw->dev, "Enabled VPORT(%d)\n", vport_num);
 	mutex_unlock(&esw->state_lock);
+	return 0;
 }
=20
 static void esw_disable_vport(struct mlx5_eswitch *esw,
@@ -1856,26 +1859,51 @@ static void mlx5_eswitch_event_handlers_unregister(=
struct mlx5_eswitch *esw)
 /* mlx5_eswitch_enable_pf_vf_vports() enables vports of PF, ECPF and VFs
  * whichever are present on the eswitch.
  */
-void
+int
 mlx5_eswitch_enable_pf_vf_vports(struct mlx5_eswitch *esw,
 				 enum mlx5_eswitch_vport_event enabled_events)
 {
 	struct mlx5_vport *vport;
+	int num_vfs;
+	int ret;
 	int i;
=20
 	/* Enable PF vport */
 	vport =3D mlx5_eswitch_get_vport(esw, MLX5_VPORT_PF);
-	esw_enable_vport(esw, vport, enabled_events);
+	ret =3D esw_enable_vport(esw, vport, enabled_events);
+	if (ret)
+		return ret;
=20
-	/* Enable ECPF vports */
+	/* Enable ECPF vport */
 	if (mlx5_ecpf_vport_exists(esw->dev)) {
 		vport =3D mlx5_eswitch_get_vport(esw, MLX5_VPORT_ECPF);
-		esw_enable_vport(esw, vport, enabled_events);
+		ret =3D esw_enable_vport(esw, vport, enabled_events);
+		if (ret)
+			goto ecpf_err;
 	}
=20
 	/* Enable VF vports */
-	mlx5_esw_for_each_vf_vport(esw, i, vport, esw->esw_funcs.num_vfs)
-		esw_enable_vport(esw, vport, enabled_events);
+	mlx5_esw_for_each_vf_vport(esw, i, vport, esw->esw_funcs.num_vfs) {
+		ret =3D esw_enable_vport(esw, vport, enabled_events);
+		if (ret)
+			goto vf_err;
+	}
+	return 0;
+
+vf_err:
+	num_vfs =3D i - 1;
+	mlx5_esw_for_each_vf_vport_reverse(esw, i, vport, num_vfs)
+		esw_disable_vport(esw, vport);
+
+	if (mlx5_ecpf_vport_exists(esw->dev)) {
+		vport =3D mlx5_eswitch_get_vport(esw, MLX5_VPORT_ECPF);
+		esw_disable_vport(esw, vport);
+	}
+
+ecpf_err:
+	vport =3D mlx5_eswitch_get_vport(esw, MLX5_VPORT_PF);
+	esw_disable_vport(esw, vport);
+	return ret;
 }
=20
 /* mlx5_eswitch_disable_pf_vf_vports() disables vports of PF, ECPF and VFs
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/ne=
t/ethernet/mellanox/mlx5/core/eswitch.h
index ec0ef7c5d539..36edee35f155 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -609,7 +609,7 @@ bool mlx5_eswitch_is_vf_vport(const struct mlx5_eswitch=
 *esw, u16 vport_num);
 void mlx5_eswitch_update_num_of_vfs(struct mlx5_eswitch *esw, const int nu=
m_vfs);
 int mlx5_esw_funcs_changed_handler(struct notifier_block *nb, unsigned lon=
g type, void *data);
=20
-void
+int
 mlx5_eswitch_enable_pf_vf_vports(struct mlx5_eswitch *esw,
 				 enum mlx5_eswitch_vport_event enabled_events);
 void mlx5_eswitch_disable_pf_vf_vports(struct mlx5_eswitch *esw);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/d=
rivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 874e70e3792a..98df1eeee873 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -2139,7 +2139,9 @@ int esw_offloads_enable(struct mlx5_eswitch *esw)
 	if (err)
 		goto err_vport_metadata;
=20
-	mlx5_eswitch_enable_pf_vf_vports(esw, MLX5_VPORT_UC_ADDR_CHANGE);
+	err =3D mlx5_eswitch_enable_pf_vf_vports(esw, MLX5_VPORT_UC_ADDR_CHANGE);
+	if (err)
+		goto err_vports;
=20
 	err =3D esw_offloads_load_all_reps(esw);
 	if (err)
@@ -2152,6 +2154,7 @@ int esw_offloads_enable(struct mlx5_eswitch *esw)
=20
 err_reps:
 	mlx5_eswitch_disable_pf_vf_vports(esw);
+err_vports:
 	esw_set_passing_vport_metadata(esw, false);
 err_vport_metadata:
 	esw_offloads_steering_cleanup(esw);
--=20
2.21.0

