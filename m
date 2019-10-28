Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9419FE7CFA
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 00:35:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731850AbfJ1XfX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 19:35:23 -0400
Received: from mail-eopbgr60074.outbound.protection.outlook.com ([40.107.6.74]:40107
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731784AbfJ1XfX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Oct 2019 19:35:23 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KnyMi5WJ9IUrWDMGKlF86MLi2NzCW0FN/UvtY1l/loGNML1yvEIJc0wKVRiDYH9uvKdOvEZs0xcMAO6rvSFHpjjtHuDZ4nrc14R7K0DH7Zw42FEHtKq2sFCqt6UwQv0LxNMR5/EQVxiuYhcj9Tza19vbGZw7DoLuVW9bAraFGXV/M9yF4KZAFe79dUuEeY/m4siJAJFtqZwGlAcH3H542OpQBsYFtlXgH8Z/30HBHvxYTH6VPG6Inuq1rYZdOhIzZ3fLtB7WcbXtVdk1CiN6nKnW7iVywPJzbL1G6uKwQ/qgruQ0anyv3hK35a3CJRNy0EKye05ZVFxTW3mSYabI7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6Hlk1MNT5myx3tCO9ozh7nWan0feJa1lztbR0M8M0+U=;
 b=FqV5GUp6dyx8loKFUgfIjFWi8/E+7Ag2ZjTjH0xD74IN3dD9jcduzsuqmfQTWcocOdTc+0AFqNUw2TVJ4FAYPD/CetUwpq1ViE3RIUvSM2a19y+/jOMC7MWjf8N0XlQlTZRpeErBOvi3OdXkYVDMvjOqSxDj9FeBhFdGXIpomgfxCyu2peZ+eq41Rki/PycW5baO7y/8oISLtThVtMIGICVkD2mhQW3Iaed6ovTloRE5SXqvvKKxhRE5TflEE49L0+M7AajlDH2498lK4Y0U6Xb4MUaV6e7dXUv8Wb6/DoXIENgEls4kZfNVh0nPsMWcdlSx9Ji/cEVi0Z5OOGewyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6Hlk1MNT5myx3tCO9ozh7nWan0feJa1lztbR0M8M0+U=;
 b=LPQaAv5yYkcPAfi/eB4JxOlEgqefpt14Yzrjj3sO2haLsOYB7uzgWoSbRb/JgLrV0TpMNBUItH/NR3pnETaRQOE0wGY3rPRo8uOI+sY3fmuJMICFWkLA6cSq9x+NMrBeNifLtrkifHF9famSsFkn4wOm2t4BfY0hRK81Y3fmz9w=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB6448.eurprd05.prod.outlook.com (20.179.28.86) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2387.22; Mon, 28 Oct 2019 23:35:11 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e%5]) with mapi id 15.20.2387.027; Mon, 28 Oct 2019
 23:35:11 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Parav Pandit <parav@mellanox.com>
Subject: [PATCH mlx5-next 08/18] net/mlx5: Move legacy drop counter and rule
 under legacy structure
Thread-Topic: [PATCH mlx5-next 08/18] net/mlx5: Move legacy drop counter and
 rule under legacy structure
Thread-Index: AQHVjehXLVTEJAfaB02FGRL5qyn+XQ==
Date:   Mon, 28 Oct 2019 23:35:11 +0000
Message-ID: <20191028233440.5564-9-saeedm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: 60db05e5-71cd-4a52-cb5d-08d75bff79e4
x-ms-traffictypediagnostic: VI1PR05MB6448:|VI1PR05MB6448:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB644894B2A1ABBC77777FFD77BE660@VI1PR05MB6448.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:37;
x-forefront-prvs: 0204F0BDE2
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(376002)(366004)(346002)(396003)(39860400002)(189003)(199004)(3846002)(305945005)(8936002)(450100002)(316002)(478600001)(50226002)(86362001)(99286004)(71200400001)(81156014)(8676002)(81166006)(107886003)(71190400001)(186003)(66446008)(386003)(102836004)(6636002)(6506007)(14444005)(66476007)(66946007)(256004)(36756003)(52116002)(476003)(2616005)(11346002)(486006)(446003)(64756008)(6512007)(76176011)(6116002)(4326008)(26005)(7736002)(5660300002)(66066001)(14454004)(2906002)(110136005)(6436002)(6486002)(54906003)(1076003)(25786009)(66556008);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB6448;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YIYw5yt7tdZCXZXOkoBq1HdCfahBYIxU1YpUo6/xxV1+0pzhwnMJ8xBZaJjeHslHEL37EQqC2BMcD5Scc0YbfSMFG87DAwSCt/68sROg7oXHqIfSfd2KmV+tk1DhdtC3kjmTPUay8PRhBSb6oCfItiMH/EoeG9AH5scjFCxdjqfwp1FApv6qLxBuIgalbzBnsXC6clcDoxsfJ1UYajIw0cOsqBGKnwkoXGLTkDvvc8lAP2s2u3QagQG+1bmROshj0MvQ82TWLaUkVEu9Ou7/7r9CxOY+seAXkuQREynXOvRJ3fRFMR5n+4Dv/px5Asy7nGuhbStmdMvgeowYxpgPw800NZS8U/U6FdR1fl+MPhyn7+YMknVKvfJVFGdXzXiT/wab6wICHvWbMlvmvWXG+x08yA+qsQbgUGqH2KrndUc/rJLAPbDr1wsnExPuA2Tf
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 60db05e5-71cd-4a52-cb5d-08d75bff79e4
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Oct 2019 23:35:11.7649
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pe5JoIpFjls6wSqOaUsHWqRKHD3uytwJqX9mOou57VG9ukvvdvjYvHWLNGoQG6QUpst9t8rU+vMcfxZDNK67OQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6448
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Parav Pandit <parav@mellanox.com>

To improve code readability, move legacy drop counters and droup rule
under legacy structure.

While at it,
(a) prefix drop flow counters helper with legacy_.
(b) nullify the rule pointers only if they were valid.

Signed-off-by: Parav Pandit <parav@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/eswitch.c | 82 ++++++++++---------
 .../net/ethernet/mellanox/mlx5/core/eswitch.h | 12 ++-
 2 files changed, 50 insertions(+), 44 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/ne=
t/ethernet/mellanox/mlx5/core/eswitch.c
index fa1228a8005f..0dd5e5d5ea35 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -1040,14 +1040,15 @@ int esw_vport_enable_egress_acl(struct mlx5_eswitch=
 *esw,
 void esw_vport_cleanup_egress_rules(struct mlx5_eswitch *esw,
 				    struct mlx5_vport *vport)
 {
-	if (!IS_ERR_OR_NULL(vport->egress.allowed_vlan))
+	if (!IS_ERR_OR_NULL(vport->egress.allowed_vlan)) {
 		mlx5_del_flow_rules(vport->egress.allowed_vlan);
+		vport->egress.allowed_vlan =3D NULL;
+	}
=20
-	if (!IS_ERR_OR_NULL(vport->egress.drop_rule))
-		mlx5_del_flow_rules(vport->egress.drop_rule);
-
-	vport->egress.allowed_vlan =3D NULL;
-	vport->egress.drop_rule =3D NULL;
+	if (!IS_ERR_OR_NULL(vport->egress.legacy.drop_rule)) {
+		mlx5_del_flow_rules(vport->egress.legacy.drop_rule);
+		vport->egress.legacy.drop_rule =3D NULL;
+	}
 }
=20
 void esw_vport_disable_egress_acl(struct mlx5_eswitch *esw,
@@ -1202,14 +1203,15 @@ int esw_vport_enable_ingress_acl(struct mlx5_eswitc=
h *esw,
 void esw_vport_cleanup_ingress_rules(struct mlx5_eswitch *esw,
 				     struct mlx5_vport *vport)
 {
-	if (!IS_ERR_OR_NULL(vport->ingress.drop_rule))
-		mlx5_del_flow_rules(vport->ingress.drop_rule);
+	if (!IS_ERR_OR_NULL(vport->ingress.legacy.drop_rule)) {
+		mlx5_del_flow_rules(vport->ingress.legacy.drop_rule);
+		vport->ingress.legacy.drop_rule =3D NULL;
+	}
=20
-	if (!IS_ERR_OR_NULL(vport->ingress.allow_rule))
+	if (!IS_ERR_OR_NULL(vport->ingress.allow_rule)) {
 		mlx5_del_flow_rules(vport->ingress.allow_rule);
-
-	vport->ingress.drop_rule =3D NULL;
-	vport->ingress.allow_rule =3D NULL;
+		vport->ingress.allow_rule =3D NULL;
+	}
=20
 	esw_vport_del_ingress_acl_modify_metadata(esw, vport);
 }
@@ -1238,7 +1240,7 @@ void esw_vport_disable_ingress_acl(struct mlx5_eswitc=
h *esw,
 static int esw_vport_ingress_config(struct mlx5_eswitch *esw,
 				    struct mlx5_vport *vport)
 {
-	struct mlx5_fc *counter =3D vport->ingress.drop_counter;
+	struct mlx5_fc *counter =3D vport->ingress.legacy.drop_counter;
 	struct mlx5_flow_destination drop_ctr_dst =3D {0};
 	struct mlx5_flow_destination *dst =3D NULL;
 	struct mlx5_flow_act flow_act =3D {0};
@@ -1309,15 +1311,15 @@ static int esw_vport_ingress_config(struct mlx5_esw=
itch *esw,
 		dst =3D &drop_ctr_dst;
 		dest_num++;
 	}
-	vport->ingress.drop_rule =3D
+	vport->ingress.legacy.drop_rule =3D
 		mlx5_add_flow_rules(vport->ingress.acl, spec,
 				    &flow_act, dst, dest_num);
-	if (IS_ERR(vport->ingress.drop_rule)) {
-		err =3D PTR_ERR(vport->ingress.drop_rule);
+	if (IS_ERR(vport->ingress.legacy.drop_rule)) {
+		err =3D PTR_ERR(vport->ingress.legacy.drop_rule);
 		esw_warn(esw->dev,
 			 "vport[%d] configure ingress drop rule, err(%d)\n",
 			 vport->vport, err);
-		vport->ingress.drop_rule =3D NULL;
+		vport->ingress.legacy.drop_rule =3D NULL;
 		goto out;
 	}
=20
@@ -1368,7 +1370,7 @@ int mlx5_esw_create_vport_egress_acl_vlan(struct mlx5=
_eswitch *esw,
 static int esw_vport_egress_config(struct mlx5_eswitch *esw,
 				   struct mlx5_vport *vport)
 {
-	struct mlx5_fc *counter =3D vport->egress.drop_counter;
+	struct mlx5_fc *counter =3D vport->egress.legacy.drop_counter;
 	struct mlx5_flow_destination drop_ctr_dst =3D {0};
 	struct mlx5_flow_destination *dst =3D NULL;
 	struct mlx5_flow_act flow_act =3D {0};
@@ -1416,15 +1418,15 @@ static int esw_vport_egress_config(struct mlx5_eswi=
tch *esw,
 		dst =3D &drop_ctr_dst;
 		dest_num++;
 	}
-	vport->egress.drop_rule =3D
+	vport->egress.legacy.drop_rule =3D
 		mlx5_add_flow_rules(vport->egress.acl, spec,
 				    &flow_act, dst, dest_num);
-	if (IS_ERR(vport->egress.drop_rule)) {
-		err =3D PTR_ERR(vport->egress.drop_rule);
+	if (IS_ERR(vport->egress.legacy.drop_rule)) {
+		err =3D PTR_ERR(vport->egress.legacy.drop_rule);
 		esw_warn(esw->dev,
 			 "vport[%d] configure egress drop rule failed, err(%d)\n",
 			 vport->vport, err);
-		vport->egress.drop_rule =3D NULL;
+		vport->egress.legacy.drop_rule =3D NULL;
 	}
 out:
 	kvfree(spec);
@@ -1667,39 +1669,39 @@ static void esw_apply_vport_conf(struct mlx5_eswitc=
h *esw,
 	}
 }
=20
-static void esw_vport_create_drop_counters(struct mlx5_vport *vport)
+static void esw_legacy_vport_create_drop_counters(struct mlx5_vport *vport=
)
 {
 	struct mlx5_core_dev *dev =3D vport->dev;
=20
 	if (MLX5_CAP_ESW_INGRESS_ACL(dev, flow_counter)) {
-		vport->ingress.drop_counter =3D mlx5_fc_create(dev, false);
-		if (IS_ERR(vport->ingress.drop_counter)) {
+		vport->ingress.legacy.drop_counter =3D mlx5_fc_create(dev, false);
+		if (IS_ERR(vport->ingress.legacy.drop_counter)) {
 			esw_warn(dev,
 				 "vport[%d] configure ingress drop rule counter failed\n",
 				 vport->vport);
-			vport->ingress.drop_counter =3D NULL;
+			vport->ingress.legacy.drop_counter =3D NULL;
 		}
 	}
=20
 	if (MLX5_CAP_ESW_EGRESS_ACL(dev, flow_counter)) {
-		vport->egress.drop_counter =3D mlx5_fc_create(dev, false);
-		if (IS_ERR(vport->egress.drop_counter)) {
+		vport->egress.legacy.drop_counter =3D mlx5_fc_create(dev, false);
+		if (IS_ERR(vport->egress.legacy.drop_counter)) {
 			esw_warn(dev,
 				 "vport[%d] configure egress drop rule counter failed\n",
 				 vport->vport);
-			vport->egress.drop_counter =3D NULL;
+			vport->egress.legacy.drop_counter =3D NULL;
 		}
 	}
 }
=20
-static void esw_vport_destroy_drop_counters(struct mlx5_vport *vport)
+static void esw_legacy_vport_destroy_drop_counters(struct mlx5_vport *vpor=
t)
 {
 	struct mlx5_core_dev *dev =3D vport->dev;
=20
-	if (vport->ingress.drop_counter)
-		mlx5_fc_destroy(dev, vport->ingress.drop_counter);
-	if (vport->egress.drop_counter)
-		mlx5_fc_destroy(dev, vport->egress.drop_counter);
+	if (vport->ingress.legacy.drop_counter)
+		mlx5_fc_destroy(dev, vport->ingress.legacy.drop_counter);
+	if (vport->egress.legacy.drop_counter)
+		mlx5_fc_destroy(dev, vport->egress.legacy.drop_counter);
 }
=20
 static void esw_enable_vport(struct mlx5_eswitch *esw, struct mlx5_vport *=
vport,
@@ -1715,7 +1717,7 @@ static void esw_enable_vport(struct mlx5_eswitch *esw=
, struct mlx5_vport *vport,
 	/* Create steering drop counters for ingress and egress ACLs */
 	if (!mlx5_esw_is_manager_vport(esw, vport_num) &&
 	    esw->mode =3D=3D MLX5_ESWITCH_LEGACY)
-		esw_vport_create_drop_counters(vport);
+		esw_legacy_vport_create_drop_counters(vport);
=20
 	/* Restore old vport configuration */
 	esw_apply_vport_conf(esw, vport);
@@ -1775,7 +1777,7 @@ static void esw_disable_vport(struct mlx5_eswitch *es=
w,
 					      MLX5_VPORT_ADMIN_STATE_DOWN);
 		esw_vport_disable_egress_acl(esw, vport);
 		esw_vport_disable_ingress_acl(esw, vport);
-		esw_vport_destroy_drop_counters(vport);
+		esw_legacy_vport_destroy_drop_counters(vport);
 	}
 	esw->enabled_vports--;
 	mutex_unlock(&esw->state_lock);
@@ -2495,12 +2497,12 @@ static int mlx5_eswitch_query_vport_drop_stats(stru=
ct mlx5_core_dev *dev,
 	if (!vport->enabled || esw->mode !=3D MLX5_ESWITCH_LEGACY)
 		return 0;
=20
-	if (vport->egress.drop_counter)
-		mlx5_fc_query(dev, vport->egress.drop_counter,
+	if (vport->egress.legacy.drop_counter)
+		mlx5_fc_query(dev, vport->egress.legacy.drop_counter,
 			      &stats->rx_dropped, &bytes);
=20
-	if (vport->ingress.drop_counter)
-		mlx5_fc_query(dev, vport->ingress.drop_counter,
+	if (vport->ingress.legacy.drop_counter)
+		mlx5_fc_query(dev, vport->ingress.legacy.drop_counter,
 			      &stats->tx_dropped, &bytes);
=20
 	if (!MLX5_CAP_GEN(dev, receive_discard_vport_down) &&
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/ne=
t/ethernet/mellanox/mlx5/core/eswitch.h
index 5f862992b9c8..ec0ef7c5d539 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -70,8 +70,10 @@ struct vport_ingress {
 	struct mlx5_flow_group *allow_untagged_only_grp;
 	struct mlx5_flow_group *drop_grp;
 	struct mlx5_flow_handle  *allow_rule;
-	struct mlx5_flow_handle  *drop_rule;
-	struct mlx5_fc           *drop_counter;
+	struct {
+		struct mlx5_flow_handle *drop_rule;
+		struct mlx5_fc *drop_counter;
+	} legacy;
 	struct {
 		struct mlx5_modify_hdr *modify_metadata;
 		struct mlx5_flow_handle *modify_metadata_rule;
@@ -83,8 +85,10 @@ struct vport_egress {
 	struct mlx5_flow_group *allowed_vlans_grp;
 	struct mlx5_flow_group *drop_grp;
 	struct mlx5_flow_handle  *allowed_vlan;
-	struct mlx5_flow_handle  *drop_rule;
-	struct mlx5_fc           *drop_counter;
+	struct {
+		struct mlx5_flow_handle *drop_rule;
+		struct mlx5_fc *drop_counter;
+	} legacy;
 };
=20
 struct mlx5_vport_drop_stats {
--=20
2.21.0

