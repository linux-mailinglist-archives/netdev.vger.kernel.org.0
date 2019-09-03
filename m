Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15153A743E
	for <lists+netdev@lfdr.de>; Tue,  3 Sep 2019 22:06:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727138AbfICUFs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Sep 2019 16:05:48 -0400
Received: from mail-eopbgr140044.outbound.protection.outlook.com ([40.107.14.44]:24054
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727106AbfICUFp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Sep 2019 16:05:45 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lB/Plevhfl87rMs2bnre9AosW2Yr1mm4JunzH1038070j5PAWM73zFmUV+lY36SbzzakV/wzNROGUK7lMEBFFWydoIsF82ThsPkvKDF6KaSc/lIukh/V8hfTJXNnzx/pR7AAEL31emCsNuUXplHjzMN8aKo0EwtIbcaRnKrCm6UO9FYEKOXD91bIc1p8JOL3opEF2bO6MFG/Pz02t5LaAk2qt9AXoEacSyZDSbVJS+oqRm68IGyKGnDHJJ0wpVNiesjaWJDg6SbItZGxKT81tpHMnTYhEUur2zgSOgCKUyOyx0rWyXDBIZXROqNQOm94u39oKz2RbHq5tIZZ12g9Kg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8hG3teaNP/dDeKMqOzvIva2WHzxNKLzdFapZJIh7inE=;
 b=Gm6IAUe3Bascf8fUb4hzJPzG53K4UYvJgQ02GcTJDe1ADeNeIS24vCyQtEYLMhzds0hUs6MA6o/KoqD7ks0GwalmsivbE/oCBi1OXPdRd/FtzDlifZkVjQ4H0AXxNtV8b3Ws8BdHUtx6kDzaU5He4QZsbmO4S5OfWamdK9YEiVRlrBn2nBkGsN5zrxLyOZUrGFBz1nkzW/hGYdxfLKBvlUoecyhNRB1QfKaVfQnmTEz9AvsMhiVj2vyWvzZ2H8/F6FPTRoc3rKDP6/MWYLGhtOEhX2gdxgjBS8c9Gl7NN+T9KnzOQgu/Ie/MiDVbTUHPrMhiG0FeyEICMQwTbjwfdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8hG3teaNP/dDeKMqOzvIva2WHzxNKLzdFapZJIh7inE=;
 b=dz7arPi6JSnAmKlIJPfftuB5GVxiV+tvro/+uKNPfeCpwvApZp1zrlfy0bk7oBEb0qkUtmth3kACo3uT/JZcvZMEn7/mdqvW2VfiO4Jd3+bKQCv7tXvv9BcEqI4Eq3YsjIa/TOQ+dgCHxKpDWRPJGkeQ2bUoJeKefTWaQmcdrBs=
Received: from AM4PR0501MB2756.eurprd05.prod.outlook.com (10.172.216.138) by
 AM4PR0501MB2706.eurprd05.prod.outlook.com (10.172.221.142) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2220.21; Tue, 3 Sep 2019 20:05:04 +0000
Received: from AM4PR0501MB2756.eurprd05.prod.outlook.com
 ([fe80::58d1:d1d6:dbda:3576]) by AM4PR0501MB2756.eurprd05.prod.outlook.com
 ([fe80::58d1:d1d6:dbda:3576%4]) with mapi id 15.20.2220.021; Tue, 3 Sep 2019
 20:05:04 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alex Vesker <valex@mellanox.com>,
        Erez Shitrit <erezsh@mellanox.com>,
        Maor Gottlieb <maorg@mellanox.com>,
        Mark Bloch <markb@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next V2 17/18] net/mlx5: Add support to use SMFS in switchdev
 mode
Thread-Topic: [net-next V2 17/18] net/mlx5: Add support to use SMFS in
 switchdev mode
Thread-Index: AQHVYpLfGt76ieLr50e30J952BubOw==
Date:   Tue, 3 Sep 2019 20:05:03 +0000
Message-ID: <20190903200409.14406-18-saeedm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: f2ad0708-2dfd-4e9b-20dd-08d730aa0238
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM4PR0501MB2706;
x-ms-traffictypediagnostic: AM4PR0501MB2706:|AM4PR0501MB2706:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM4PR0501MB2706D5442F76389514561D28BEB90@AM4PR0501MB2706.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1060;
x-forefront-prvs: 01494FA7F7
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(1496009)(4636009)(376002)(346002)(136003)(39860400002)(396003)(366004)(199004)(189003)(2906002)(102836004)(256004)(26005)(11346002)(50226002)(186003)(66446008)(386003)(6506007)(64756008)(66556008)(14444005)(66476007)(71190400001)(66946007)(2616005)(476003)(76176011)(71200400001)(5660300002)(8936002)(66066001)(446003)(81166006)(81156014)(478600001)(54906003)(6916009)(8676002)(486006)(36756003)(3846002)(7736002)(53936002)(6436002)(305945005)(14454004)(6116002)(52116002)(6512007)(86362001)(316002)(99286004)(1076003)(6486002)(4326008)(107886003)(25786009);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR0501MB2706;H:AM4PR0501MB2756.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 9M3N0DDhiGM8gyvRkLg84g9AqPB0VMTMc/HHsMDvflX+kcJ133FUNHQ67x2klNR4kIYGH1MvieFTVa9VzDaRXQK+Ih/hpDunV99CZWnxetvodJYjxVz8ydz1BAz8EuSclcqKiEldrtl9ONpIMvLzXOzZXWX/v2MMQdLYm4CPDSQSsYA2XAuii80sS/IxPQidyA0ML0awrJJ+gIwQQYUu4sA2xTIa35z04H3YpfXsGfDjZFteeZLHlfst/mbPCt6+CR6F50YCj0PJ4t/JFKlcl498T1aGiFbCIcF8GUQauIiEprLJMxNPheM8SjF20d1sksgccIcN7vCLlFZKOKfNLgjIWMrgAiyjOvXe2gvwc05ZEstQVHH7K3zqtj/N8ARn4AQzHTVqj63B9T1PENc01yWx6NcseZ/wyAoNN5cSd+w=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f2ad0708-2dfd-4e9b-20dd-08d730aa0238
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Sep 2019 20:05:03.9499
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Kl/CFWw85ZfO4KYSh3XZhHxpK1ZQlxca1itfPf/OpGi4Wj4bKfJKL5p4BHSaD3KAJurPKej8Xcjn1ILVG8Y+Ow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR0501MB2706
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maor Gottlieb <maorg@mellanox.com>

In case that flow steering mode of the driver is SMFS (Software Managed
Flow Steering), then use the DR (SW steering) API to create the steering
objects.

In addition, add a call to the set peer namespace when switchdev gets
devcom pair event. It is required to support VF LAG in SMFS.

Signed-off-by: Maor Gottlieb <maorg@mellanox.com>
Reviewed-by: Mark Bloch <markb@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/eswitch.h |  1 +
 .../mellanox/mlx5/core/eswitch_offloads.c     | 61 ++++++++++++++++---
 2 files changed, 55 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/ne=
t/ethernet/mellanox/mlx5/core/eswitch.h
index 4f70202db6af..6bd6f5895244 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -153,6 +153,7 @@ struct mlx5_eswitch_fdb {
 		} legacy;
=20
 		struct offloads_fdb {
+			struct mlx5_flow_namespace *ns;
 			struct mlx5_flow_table *slow_fdb;
 			struct mlx5_flow_group *send_to_vport_grp;
 			struct mlx5_flow_group *peer_miss_grp;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/d=
rivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index bee67ff58137..afa623b15a38 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -1068,6 +1068,13 @@ static int esw_create_offloads_fdb_tables(struct mlx=
5_eswitch *esw, int nvports)
 		err =3D -EOPNOTSUPP;
 		goto ns_err;
 	}
+	esw->fdb_table.offloads.ns =3D root_ns;
+	err =3D mlx5_flow_namespace_set_mode(root_ns,
+					   esw->dev->priv.steering->mode);
+	if (err) {
+		esw_warn(dev, "Failed to set FDB namespace steering mode\n");
+		goto ns_err;
+	}
=20
 	max_flow_counter =3D (MLX5_CAP_GEN(dev, max_flow_counter_31_16) << 16) |
 			    MLX5_CAP_GEN(dev, max_flow_counter_15_0);
@@ -1207,6 +1214,8 @@ static int esw_create_offloads_fdb_tables(struct mlx5=
_eswitch *esw, int nvports)
 	esw_destroy_offloads_fast_fdb_tables(esw);
 	mlx5_destroy_flow_table(esw->fdb_table.offloads.slow_fdb);
 slow_fdb_err:
+	/* Holds true only as long as DMFS is the default */
+	mlx5_flow_namespace_set_mode(root_ns, MLX5_FLOW_STEERING_MODE_DMFS);
 ns_err:
 	kvfree(flow_group_in);
 	return err;
@@ -1226,6 +1235,9 @@ static void esw_destroy_offloads_fdb_tables(struct ml=
x5_eswitch *esw)
=20
 	mlx5_destroy_flow_table(esw->fdb_table.offloads.slow_fdb);
 	esw_destroy_offloads_fast_fdb_tables(esw);
+	/* Holds true only as long as DMFS is the default */
+	mlx5_flow_namespace_set_mode(esw->fdb_table.offloads.ns,
+				     MLX5_FLOW_STEERING_MODE_DMFS);
 }
=20
 static int esw_create_offloads_table(struct mlx5_eswitch *esw, int nvports=
)
@@ -1623,13 +1635,42 @@ static void mlx5_esw_offloads_unpair(struct mlx5_es=
witch *esw)
 	esw_del_fdb_peer_miss_rules(esw);
 }
=20
+static int mlx5_esw_offloads_set_ns_peer(struct mlx5_eswitch *esw,
+					 struct mlx5_eswitch *peer_esw,
+					 bool pair)
+{
+	struct mlx5_flow_root_namespace *peer_ns;
+	struct mlx5_flow_root_namespace *ns;
+	int err;
+
+	peer_ns =3D peer_esw->dev->priv.steering->fdb_root_ns;
+	ns =3D esw->dev->priv.steering->fdb_root_ns;
+
+	if (pair) {
+		err =3D mlx5_flow_namespace_set_peer(ns, peer_ns);
+		if (err)
+			return err;
+
+		mlx5_flow_namespace_set_peer(peer_ns, ns);
+		if (err) {
+			mlx5_flow_namespace_set_peer(ns, NULL);
+			return err;
+		}
+	} else {
+		mlx5_flow_namespace_set_peer(ns, NULL);
+		mlx5_flow_namespace_set_peer(peer_ns, NULL);
+	}
+
+	return 0;
+}
+
 static int mlx5_esw_offloads_devcom_event(int event,
 					  void *my_data,
 					  void *event_data)
 {
 	struct mlx5_eswitch *esw =3D my_data;
-	struct mlx5_eswitch *peer_esw =3D event_data;
 	struct mlx5_devcom *devcom =3D esw->dev->priv.devcom;
+	struct mlx5_eswitch *peer_esw =3D event_data;
 	int err;
=20
 	switch (event) {
@@ -1638,9 +1679,12 @@ static int mlx5_esw_offloads_devcom_event(int event,
 		    mlx5_eswitch_vport_match_metadata_enabled(peer_esw))
 			break;
=20
-		err =3D mlx5_esw_offloads_pair(esw, peer_esw);
+		err =3D mlx5_esw_offloads_set_ns_peer(esw, peer_esw, true);
 		if (err)
 			goto err_out;
+		err =3D mlx5_esw_offloads_pair(esw, peer_esw);
+		if (err)
+			goto err_peer;
=20
 		err =3D mlx5_esw_offloads_pair(peer_esw, esw);
 		if (err)
@@ -1656,6 +1700,7 @@ static int mlx5_esw_offloads_devcom_event(int event,
 		mlx5_devcom_set_paired(devcom, MLX5_DEVCOM_ESW_OFFLOADS, false);
 		mlx5_esw_offloads_unpair(peer_esw);
 		mlx5_esw_offloads_unpair(esw);
+		mlx5_esw_offloads_set_ns_peer(esw, peer_esw, false);
 		break;
 	}
=20
@@ -1663,7 +1708,8 @@ static int mlx5_esw_offloads_devcom_event(int event,
=20
 err_pair:
 	mlx5_esw_offloads_unpair(esw);
-
+err_peer:
+	mlx5_esw_offloads_set_ns_peer(esw, peer_esw, false);
 err_out:
 	mlx5_core_err(esw->dev, "esw offloads devcom event failure, event %u err =
%d",
 		      event, err);
@@ -2115,9 +2161,10 @@ int esw_offloads_enable(struct mlx5_eswitch *esw)
 	else
 		esw->offloads.encap =3D DEVLINK_ESWITCH_ENCAP_MODE_NONE;
=20
+	mlx5_rdma_enable_roce(esw->dev);
 	err =3D esw_offloads_steering_init(esw);
 	if (err)
-		return err;
+		goto err_steering_init;
=20
 	err =3D esw_set_passing_vport_metadata(esw, true);
 	if (err)
@@ -2132,8 +2179,6 @@ int esw_offloads_enable(struct mlx5_eswitch *esw)
 	esw_offloads_devcom_init(esw);
 	mutex_init(&esw->offloads.termtbl_mutex);
=20
-	mlx5_rdma_enable_roce(esw->dev);
-
 	return 0;
=20
 err_reps:
@@ -2141,6 +2186,8 @@ int esw_offloads_enable(struct mlx5_eswitch *esw)
 	esw_set_passing_vport_metadata(esw, false);
 err_vport_metadata:
 	esw_offloads_steering_cleanup(esw);
+err_steering_init:
+	mlx5_rdma_disable_roce(esw->dev);
 	return err;
 }
=20
@@ -2165,12 +2212,12 @@ static int esw_offloads_stop(struct mlx5_eswitch *e=
sw,
=20
 void esw_offloads_disable(struct mlx5_eswitch *esw)
 {
-	mlx5_rdma_disable_roce(esw->dev);
 	esw_offloads_devcom_cleanup(esw);
 	esw_offloads_unload_all_reps(esw);
 	mlx5_eswitch_disable_pf_vf_vports(esw);
 	esw_set_passing_vport_metadata(esw, false);
 	esw_offloads_steering_cleanup(esw);
+	mlx5_rdma_disable_roce(esw->dev);
 	esw->offloads.encap =3D DEVLINK_ESWITCH_ENCAP_MODE_NONE;
 }
=20
--=20
2.21.0

