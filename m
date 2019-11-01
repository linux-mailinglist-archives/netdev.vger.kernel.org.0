Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22997ECAA9
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 23:00:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727718AbfKAV7g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 17:59:36 -0400
Received: from mail-eopbgr70089.outbound.protection.outlook.com ([40.107.7.89]:20086
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726229AbfKAV7g (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 Nov 2019 17:59:36 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b+eG8jwUlsSPy5ht/pbmXvIq9LWXYkowkct0JSULfoCoql7Navxw1pg/MaYXRQaKHC/qNn5ELT11S2q0s4eNUbWEuOQ1lHOOkLx9ufW9Qr2+4n8B21M6jv1pgbNVqL0fA5rC4ixRH9yi39hogjR8XDdEwk29tZy9S5bIZwwy7KNA3EjEP5MiTrx5EvM6nLfvyERBW5P4vxt9Y6dDxsuPlGnQ5YvHNXgiWHvHCyh/hispOSTbKhB9tuc0+RC3Betk7gTzZzxqHkrN5YUBSsytlAdTtOUYj0rSxKiet0mEi9DQ1bWaMomjMe9TPAR4yCCWwqHLfDIz2OZuBkCUS6Gmpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D/2OGVDcDeEW2aUUJxCGKp611pk3QaiqSAp+tQJT230=;
 b=X4pr+Ee7MyPZEaN2QAcioWowEpienLiOqZTzIsDUbXzSFVoUmp3bA1NNM3USvpFlFIFbkrjIjQeGbiovATUPXwxet6Cm7UxQGSKX40WrMjLgxDJBwlU8cIceFD233YC8ztrcENP1WVw4IivGAH0BhGeh349IfZWMtAzGt6hzaWIINS+gRCv/kJMTSQDhjaSYmskT5Zw3wdtjnE1C+dAVhvZQvMzheOwTG10M1r/Hf1JVoNSWnx0jAfGufMlFCU2lRDkwuABui9jwZUm4qmoowzdMHeNt4frQ9iEUHwOhRdM/y/mOUqMLyDWzHGNj2LRoTVc3kD1cweJFK3M6qs4iZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D/2OGVDcDeEW2aUUJxCGKp611pk3QaiqSAp+tQJT230=;
 b=cYrrY61GHxX4mIhO+R3KgOnuepEQ1LtFjhnQa7nFoO4heUqEFwiCL5kiKcVl1hukCSYJM/HJvdxCB4GweY6wBoPaDYlo5EEJM1DdTSqowW5DI1j0NNcP674mNEbN+rYk2IKrCwe2fWphqqJ1W1L1m7Rihm7p0oQoLutf1dwkRCE=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB5679.eurprd05.prod.outlook.com (20.178.121.21) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2408.24; Fri, 1 Nov 2019 21:59:20 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e%5]) with mapi id 15.20.2408.024; Fri, 1 Nov 2019
 21:59:20 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Erez Alfasi <ereza@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 13/15] net/mlx5: LAG, Use port enumerators
Thread-Topic: [net-next 13/15] net/mlx5: LAG, Use port enumerators
Thread-Index: AQHVkP+dy9CgyBlnJ0qf1TOHdd4l6g==
Date:   Fri, 1 Nov 2019 21:59:20 +0000
Message-ID: <20191101215833.23975-14-saeedm@mellanox.com>
References: <20191101215833.23975-1-saeedm@mellanox.com>
In-Reply-To: <20191101215833.23975-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR05CA0076.namprd05.prod.outlook.com
 (2603:10b6:a03:e0::17) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: c0a4143b-7ba3-461a-0ebe-08d75f16bf71
x-ms-traffictypediagnostic: VI1PR05MB5679:|VI1PR05MB5679:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB5679F8C12DE6C8FE502F230CBE620@VI1PR05MB5679.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4303;
x-forefront-prvs: 020877E0CB
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(376002)(366004)(346002)(396003)(136003)(189003)(199004)(4326008)(99286004)(316002)(30864003)(2616005)(2906002)(6116002)(476003)(6512007)(3846002)(1076003)(36756003)(66946007)(14454004)(25786009)(54906003)(66066001)(66556008)(64756008)(486006)(11346002)(446003)(81156014)(6916009)(76176011)(305945005)(7736002)(26005)(66476007)(66446008)(86362001)(5660300002)(102836004)(386003)(6506007)(50226002)(6486002)(6436002)(81166006)(71190400001)(71200400001)(478600001)(8676002)(256004)(8936002)(14444005)(107886003)(52116002)(186003);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5679;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vTgcYAMH/axK3DcXXERLJBSvLsvadUWiIC60dVUHC0ONa88b0U/zUAf+dDR8eEyucUirLBVAO/tHEtudPlXYck7lqThPvgKxze+sxM1IjiZXuBCzlkks++z9UH99QKJy1iGlqp4sB1Tqp98o4NTEJgSSYHVPZUETKBvIY+LEzySSAce2EgyoPBrUIyqHsUvC2519V23SY8QWHLdio0VUQd/t1rP5OBa80oLyOgKEw2Txk9I/nD1yMamc1gND+eYnfnPmK8XfnQVd7QRUIJZv22BxZMbfxJXEd/mbYkFtr47nh5ZjlpK6ZaNDKCj6BDuRLTaUVs2vjgK1Y7QxO3GAS6aKmmba2xaLukUwECfrK0HMIajmLhvRw43DpNOvbuQSKma7Q/VvjYJFotR03uDEsf3zcmwYNz+BugdO7kyBJStWsWkGjUj+UUOEriBSESOu
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c0a4143b-7ba3-461a-0ebe-08d75f16bf71
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Nov 2019 21:59:20.3790
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mtZJmyuEfk8HIQaydNHpFGb4YSjt1KuXVS1yMVHJIzpsA+Zdv+lLnVTfuwnibAV2oUh9n019koh5l02FF3aTFQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5679
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Erez Alfasi <ereza@mellanox.com>

Instead of using explicit array indexes, simply use
ports enumerators to make the code more readable.

Fixes: 7907f23adc18 ("net/mlx5: Implement RoCE LAG feature")
Signed-off-by: Erez Alfasi <ereza@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/lag.c | 65 ++++++++++---------
 drivers/net/ethernet/mellanox/mlx5/core/lag.h |  5 ++
 .../net/ethernet/mellanox/mlx5/core/lag_mp.c  | 56 ++++++++--------
 3 files changed, 69 insertions(+), 57 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag.c b/drivers/net/et=
hernet/mellanox/mlx5/core/lag.c
index c5ef2ff26465..fc0d9583475d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag.c
@@ -145,34 +145,35 @@ static void mlx5_infer_tx_affinity_mapping(struct lag=
_tracker *tracker,
 {
 	*port1 =3D 1;
 	*port2 =3D 2;
-	if (!tracker->netdev_state[0].tx_enabled ||
-	    !tracker->netdev_state[0].link_up) {
+	if (!tracker->netdev_state[MLX5_LAG_P1].tx_enabled ||
+	    !tracker->netdev_state[MLX5_LAG_P1].link_up) {
 		*port1 =3D 2;
 		return;
 	}
=20
-	if (!tracker->netdev_state[1].tx_enabled ||
-	    !tracker->netdev_state[1].link_up)
+	if (!tracker->netdev_state[MLX5_LAG_P2].tx_enabled ||
+	    !tracker->netdev_state[MLX5_LAG_P2].link_up)
 		*port2 =3D 1;
 }
=20
 void mlx5_modify_lag(struct mlx5_lag *ldev,
 		     struct lag_tracker *tracker)
 {
-	struct mlx5_core_dev *dev0 =3D ldev->pf[0].dev;
+	struct mlx5_core_dev *dev0 =3D ldev->pf[MLX5_LAG_P1].dev;
 	u8 v2p_port1, v2p_port2;
 	int err;
=20
 	mlx5_infer_tx_affinity_mapping(tracker, &v2p_port1,
 				       &v2p_port2);
=20
-	if (v2p_port1 !=3D ldev->v2p_map[0] ||
-	    v2p_port2 !=3D ldev->v2p_map[1]) {
-		ldev->v2p_map[0] =3D v2p_port1;
-		ldev->v2p_map[1] =3D v2p_port2;
+	if (v2p_port1 !=3D ldev->v2p_map[MLX5_LAG_P1] ||
+	    v2p_port2 !=3D ldev->v2p_map[MLX5_LAG_P2]) {
+		ldev->v2p_map[MLX5_LAG_P1] =3D v2p_port1;
+		ldev->v2p_map[MLX5_LAG_P2] =3D v2p_port2;
=20
 		mlx5_core_info(dev0, "modify lag map port 1:%d port 2:%d",
-			       ldev->v2p_map[0], ldev->v2p_map[1]);
+			       ldev->v2p_map[MLX5_LAG_P1],
+			       ldev->v2p_map[MLX5_LAG_P2]);
=20
 		err =3D mlx5_cmd_modify_lag(dev0, v2p_port1, v2p_port2);
 		if (err)
@@ -185,16 +186,17 @@ void mlx5_modify_lag(struct mlx5_lag *ldev,
 static int mlx5_create_lag(struct mlx5_lag *ldev,
 			   struct lag_tracker *tracker)
 {
-	struct mlx5_core_dev *dev0 =3D ldev->pf[0].dev;
+	struct mlx5_core_dev *dev0 =3D ldev->pf[MLX5_LAG_P1].dev;
 	int err;
=20
-	mlx5_infer_tx_affinity_mapping(tracker, &ldev->v2p_map[0],
-				       &ldev->v2p_map[1]);
+	mlx5_infer_tx_affinity_mapping(tracker, &ldev->v2p_map[MLX5_LAG_P1],
+				       &ldev->v2p_map[MLX5_LAG_P2]);
=20
 	mlx5_core_info(dev0, "lag map port 1:%d port 2:%d",
-		       ldev->v2p_map[0], ldev->v2p_map[1]);
+		       ldev->v2p_map[MLX5_LAG_P1], ldev->v2p_map[MLX5_LAG_P2]);
=20
-	err =3D mlx5_cmd_create_lag(dev0, ldev->v2p_map[0], ldev->v2p_map[1]);
+	err =3D mlx5_cmd_create_lag(dev0, ldev->v2p_map[MLX5_LAG_P1],
+				  ldev->v2p_map[MLX5_LAG_P2]);
 	if (err)
 		mlx5_core_err(dev0,
 			      "Failed to create LAG (%d)\n",
@@ -207,7 +209,7 @@ int mlx5_activate_lag(struct mlx5_lag *ldev,
 		      u8 flags)
 {
 	bool roce_lag =3D !!(flags & MLX5_LAG_FLAG_ROCE);
-	struct mlx5_core_dev *dev0 =3D ldev->pf[0].dev;
+	struct mlx5_core_dev *dev0 =3D ldev->pf[MLX5_LAG_P1].dev;
 	int err;
=20
 	err =3D mlx5_create_lag(ldev, tracker);
@@ -229,7 +231,7 @@ int mlx5_activate_lag(struct mlx5_lag *ldev,
=20
 static int mlx5_deactivate_lag(struct mlx5_lag *ldev)
 {
-	struct mlx5_core_dev *dev0 =3D ldev->pf[0].dev;
+	struct mlx5_core_dev *dev0 =3D ldev->pf[MLX5_LAG_P1].dev;
 	bool roce_lag =3D __mlx5_lag_is_roce(ldev);
 	int err;
=20
@@ -252,14 +254,15 @@ static int mlx5_deactivate_lag(struct mlx5_lag *ldev)
=20
 static bool mlx5_lag_check_prereq(struct mlx5_lag *ldev)
 {
-	if (!ldev->pf[0].dev || !ldev->pf[1].dev)
+	if (!ldev->pf[MLX5_LAG_P1].dev || !ldev->pf[MLX5_LAG_P2].dev)
 		return false;
=20
 #ifdef CONFIG_MLX5_ESWITCH
-	return mlx5_esw_lag_prereq(ldev->pf[0].dev, ldev->pf[1].dev);
+	return mlx5_esw_lag_prereq(ldev->pf[MLX5_LAG_P1].dev,
+				   ldev->pf[MLX5_LAG_P2].dev);
 #else
-	return (!mlx5_sriov_is_enabled(ldev->pf[0].dev) &&
-		!mlx5_sriov_is_enabled(ldev->pf[1].dev));
+	return (!mlx5_sriov_is_enabled(ldev->pf[MLX5_LAG_P1].dev) &&
+		!mlx5_sriov_is_enabled(ldev->pf[MLX5_LAG_P2].dev));
 #endif
 }
=20
@@ -285,8 +288,8 @@ static void mlx5_lag_remove_ib_devices(struct mlx5_lag =
*ldev)
=20
 static void mlx5_do_bond(struct mlx5_lag *ldev)
 {
-	struct mlx5_core_dev *dev0 =3D ldev->pf[0].dev;
-	struct mlx5_core_dev *dev1 =3D ldev->pf[1].dev;
+	struct mlx5_core_dev *dev0 =3D ldev->pf[MLX5_LAG_P1].dev;
+	struct mlx5_core_dev *dev1 =3D ldev->pf[MLX5_LAG_P2].dev;
 	struct lag_tracker tracker;
 	bool do_bond, roce_lag;
 	int err;
@@ -692,10 +695,11 @@ struct net_device *mlx5_lag_get_roce_netdev(struct ml=
x5_core_dev *dev)
 		goto unlock;
=20
 	if (ldev->tracker.tx_type =3D=3D NETDEV_LAG_TX_TYPE_ACTIVEBACKUP) {
-		ndev =3D ldev->tracker.netdev_state[0].tx_enabled ?
-		       ldev->pf[0].netdev : ldev->pf[1].netdev;
+		ndev =3D ldev->tracker.netdev_state[MLX5_LAG_P1].tx_enabled ?
+		       ldev->pf[MLX5_LAG_P1].netdev :
+		       ldev->pf[MLX5_LAG_P2].netdev;
 	} else {
-		ndev =3D ldev->pf[0].netdev;
+		ndev =3D ldev->pf[MLX5_LAG_P1].netdev;
 	}
 	if (ndev)
 		dev_hold(ndev);
@@ -717,7 +721,8 @@ bool mlx5_lag_intf_add(struct mlx5_interface *intf, str=
uct mlx5_priv *priv)
 		return true;
=20
 	ldev =3D mlx5_lag_dev_get(dev);
-	if (!ldev || !__mlx5_lag_is_roce(ldev) || ldev->pf[0].dev =3D=3D dev)
+	if (!ldev || !__mlx5_lag_is_roce(ldev) ||
+	    ldev->pf[MLX5_LAG_P1].dev =3D=3D dev)
 		return true;
=20
 	/* If bonded, we do not add an IB device for PF1. */
@@ -746,11 +751,11 @@ int mlx5_lag_query_cong_counters(struct mlx5_core_dev=
 *dev,
 	ldev =3D mlx5_lag_dev_get(dev);
 	if (ldev && __mlx5_lag_is_roce(ldev)) {
 		num_ports =3D MLX5_MAX_PORTS;
-		mdev[0] =3D ldev->pf[0].dev;
-		mdev[1] =3D ldev->pf[1].dev;
+		mdev[MLX5_LAG_P1] =3D ldev->pf[MLX5_LAG_P1].dev;
+		mdev[MLX5_LAG_P2] =3D ldev->pf[MLX5_LAG_P2].dev;
 	} else {
 		num_ports =3D 1;
-		mdev[0] =3D dev;
+		mdev[MLX5_LAG_P1] =3D dev;
 	}
=20
 	for (i =3D 0; i < num_ports; ++i) {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag.h b/drivers/net/et=
hernet/mellanox/mlx5/core/lag.h
index 1dea0b1c9826..f1068aac6406 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag.h
@@ -7,6 +7,11 @@
 #include "mlx5_core.h"
 #include "lag_mp.h"
=20
+enum {
+	MLX5_LAG_P1,
+	MLX5_LAG_P2,
+};
+
 enum {
 	MLX5_LAG_FLAG_ROCE   =3D 1 << 0,
 	MLX5_LAG_FLAG_SRIOV  =3D 1 << 1,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag_mp.c b/drivers/net=
/ethernet/mellanox/mlx5/core/lag_mp.c
index 13e2944b1274..5169864dd656 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag_mp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag_mp.c
@@ -11,10 +11,11 @@
=20
 static bool mlx5_lag_multipath_check_prereq(struct mlx5_lag *ldev)
 {
-	if (!ldev->pf[0].dev || !ldev->pf[1].dev)
+	if (!ldev->pf[MLX5_LAG_P1].dev || !ldev->pf[MLX5_LAG_P2].dev)
 		return false;
=20
-	return mlx5_esw_multipath_prereq(ldev->pf[0].dev, ldev->pf[1].dev);
+	return mlx5_esw_multipath_prereq(ldev->pf[MLX5_LAG_P1].dev,
+					 ldev->pf[MLX5_LAG_P2].dev);
 }
=20
 static bool __mlx5_lag_is_multipath(struct mlx5_lag *ldev)
@@ -52,36 +53,36 @@ static void mlx5_lag_set_port_affinity(struct mlx5_lag =
*ldev, int port)
=20
 	switch (port) {
 	case 0:
-		tracker.netdev_state[0].tx_enabled =3D true;
-		tracker.netdev_state[1].tx_enabled =3D true;
-		tracker.netdev_state[0].link_up =3D true;
-		tracker.netdev_state[1].link_up =3D true;
+		tracker.netdev_state[MLX5_LAG_P1].tx_enabled =3D true;
+		tracker.netdev_state[MLX5_LAG_P2].tx_enabled =3D true;
+		tracker.netdev_state[MLX5_LAG_P1].link_up =3D true;
+		tracker.netdev_state[MLX5_LAG_P2].link_up =3D true;
 		break;
 	case 1:
-		tracker.netdev_state[0].tx_enabled =3D true;
-		tracker.netdev_state[0].link_up =3D true;
-		tracker.netdev_state[1].tx_enabled =3D false;
-		tracker.netdev_state[1].link_up =3D false;
+		tracker.netdev_state[MLX5_LAG_P1].tx_enabled =3D true;
+		tracker.netdev_state[MLX5_LAG_P1].link_up =3D true;
+		tracker.netdev_state[MLX5_LAG_P2].tx_enabled =3D false;
+		tracker.netdev_state[MLX5_LAG_P2].link_up =3D false;
 		break;
 	case 2:
-		tracker.netdev_state[0].tx_enabled =3D false;
-		tracker.netdev_state[0].link_up =3D false;
-		tracker.netdev_state[1].tx_enabled =3D true;
-		tracker.netdev_state[1].link_up =3D true;
+		tracker.netdev_state[MLX5_LAG_P1].tx_enabled =3D false;
+		tracker.netdev_state[MLX5_LAG_P1].link_up =3D false;
+		tracker.netdev_state[MLX5_LAG_P2].tx_enabled =3D true;
+		tracker.netdev_state[MLX5_LAG_P2].link_up =3D true;
 		break;
 	default:
-		mlx5_core_warn(ldev->pf[0].dev, "Invalid affinity port %d",
-			       port);
+		mlx5_core_warn(ldev->pf[MLX5_LAG_P1].dev,
+			       "Invalid affinity port %d", port);
 		return;
 	}
=20
-	if (tracker.netdev_state[0].tx_enabled)
-		mlx5_notifier_call_chain(ldev->pf[0].dev->priv.events,
+	if (tracker.netdev_state[MLX5_LAG_P1].tx_enabled)
+		mlx5_notifier_call_chain(ldev->pf[MLX5_LAG_P1].dev->priv.events,
 					 MLX5_DEV_EVENT_PORT_AFFINITY,
 					 (void *)0);
=20
-	if (tracker.netdev_state[1].tx_enabled)
-		mlx5_notifier_call_chain(ldev->pf[1].dev->priv.events,
+	if (tracker.netdev_state[MLX5_LAG_P2].tx_enabled)
+		mlx5_notifier_call_chain(ldev->pf[MLX5_LAG_P2].dev->priv.events,
 					 MLX5_DEV_EVENT_PORT_AFFINITY,
 					 (void *)0);
=20
@@ -141,11 +142,12 @@ static void mlx5_lag_fib_route_event(struct mlx5_lag =
*ldev,
 	/* Verify next hops are ports of the same hca */
 	fib_nh0 =3D fib_info_nh(fi, 0);
 	fib_nh1 =3D fib_info_nh(fi, 1);
-	if (!(fib_nh0->fib_nh_dev =3D=3D ldev->pf[0].netdev &&
-	      fib_nh1->fib_nh_dev =3D=3D ldev->pf[1].netdev) &&
-	    !(fib_nh0->fib_nh_dev =3D=3D ldev->pf[1].netdev &&
-	      fib_nh1->fib_nh_dev =3D=3D ldev->pf[0].netdev)) {
-		mlx5_core_warn(ldev->pf[0].dev, "Multipath offload require two ports of =
the same HCA\n");
+	if (!(fib_nh0->fib_nh_dev =3D=3D ldev->pf[MLX5_LAG_P1].netdev &&
+	      fib_nh1->fib_nh_dev =3D=3D ldev->pf[MLX5_LAG_P2].netdev) &&
+	    !(fib_nh0->fib_nh_dev =3D=3D ldev->pf[MLX5_LAG_P2].netdev &&
+	      fib_nh1->fib_nh_dev =3D=3D ldev->pf[MLX5_LAG_P1].netdev)) {
+		mlx5_core_warn(ldev->pf[MLX5_LAG_P1].dev,
+			       "Multipath offload require two ports of the same HCA\n");
 		return;
 	}
=20
@@ -267,8 +269,8 @@ static int mlx5_lag_fib_event(struct notifier_block *nb=
,
 			return notifier_from_errno(-EINVAL);
 		}
 		fib_dev =3D fib_info_nh(fen_info->fi, 0)->fib_nh_dev;
-		if (fib_dev !=3D ldev->pf[0].netdev &&
-		    fib_dev !=3D ldev->pf[1].netdev) {
+		if (fib_dev !=3D ldev->pf[MLX5_LAG_P1].netdev &&
+		    fib_dev !=3D ldev->pf[MLX5_LAG_P2].netdev) {
 			return NOTIFY_DONE;
 		}
 		fib_work =3D mlx5_lag_init_fib_work(ldev, event);
--=20
2.21.0

