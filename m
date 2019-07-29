Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A47C279ACC
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 23:13:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388550AbfG2VNb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 17:13:31 -0400
Received: from mail-eopbgr10050.outbound.protection.outlook.com ([40.107.1.50]:5933
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388520AbfG2VN2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Jul 2019 17:13:28 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EjWvj/4iCb3X1dnn8Owvo7IxKnw5TVCjPh4n1nX8JVHyOfccqA5pY8d4xpv8p0xqm8i37d/CTEAkN9k8ek+O6yKo794yXn0bncmt+QQnwVJ1cOEwYb1V3APGoytbBYEiZLn0jXjakNwgTcNDYODy4YPSG2f9C6HbaB1fbEqKxQWF77VqeQvMuo897uM4KMTtQG0eZ9foMlVO68aXbxO+OwNRcAmLEuwXnif+pg848tUaeak0aIay3GaczWt3st6HKQ3WG9mx6ucwfW+mZcrCGT8wB+RGr78eYoBlpydzsvx+SppI8e6bZq9WBd9iGcW0kJjaq9G2FR0HU+yf3IGqww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O3XfJjMTtTWrmDCXodkJamhpKVr3/P0U0gbbV2YT8yc=;
 b=Y7NCFnerR+dvoebFzq8usKiD5Y21znhULkM8TRC8GXSCuxgBOZDL1pFNF5PTPvDqbomcaW9U++4SNybKZOVZMCIk1JILific/GA2tNtxmPbuQ99hYZWBrns1rDJ2rIccVRcI7tlOlymtgL1zUrUHUstUdvjfh8UL1QDAakp3pwLfKJseSzbwycY1X/884jYWzXpPLH8MiJlXDZzjo68gh2b1VWWM1CzxCEeiEnFLL9+FxXg7s2+r5xqSjH89hNE+8Rf7ArXJIvAlBG7u2T11zYG6bazq/zY7ZjAnkf26im/7H/TSLA7/vFrr3phEZg2Yst2Frk6JQNR3iY0csFTNKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=mellanox.com;dmarc=pass action=none
 header.from=mellanox.com;dkim=pass header.d=mellanox.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O3XfJjMTtTWrmDCXodkJamhpKVr3/P0U0gbbV2YT8yc=;
 b=aE+RRjg+wJyuXZU2k0M1sUY/QxMtPMK0DBfM+F8gJpbBjnpy6M3Qnk6MpqNn/qdah9WnhHSonpaPX9haGsWhufuEZZYXU9QN0EFEQyKS6Rhl66ws9mQpWc9xZZ0HPNlQuyySXWR3QsgWlw/u9azupzLTEWmlN4cxrPX+mAiYdto=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2375.eurprd05.prod.outlook.com (10.168.72.150) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.10; Mon, 29 Jul 2019 21:13:12 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2%5]) with mapi id 15.20.2115.005; Mon, 29 Jul 2019
 21:13:12 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
CC:     Parav Pandit <parav@mellanox.com>
Subject: [PATCH mlx5-next 11/11] net/mlx5: E-switch, Tide up eswitch config
 sequence
Thread-Topic: [PATCH mlx5-next 11/11] net/mlx5: E-switch, Tide up eswitch
 config sequence
Thread-Index: AQHVRlJtLvlb9aQ/DkWqervHwap/nw==
Date:   Mon, 29 Jul 2019 21:13:12 +0000
Message-ID: <20190729211209.14772-12-saeedm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: 4c69e7e6-2da2-4e1d-c89e-08d714699017
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2375;
x-ms-traffictypediagnostic: DB6PR0501MB2375:
x-microsoft-antispam-prvs: <DB6PR0501MB237514907508991C5B63F25CBEDD0@DB6PR0501MB2375.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4303;
x-forefront-prvs: 01136D2D90
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(376002)(346002)(39860400002)(366004)(396003)(199004)(189003)(50226002)(14444005)(5660300002)(6116002)(3846002)(486006)(446003)(86362001)(81156014)(186003)(36756003)(81166006)(8936002)(26005)(25786009)(316002)(71190400001)(71200400001)(110136005)(64756008)(76176011)(66556008)(2906002)(66946007)(66446008)(99286004)(66476007)(1076003)(386003)(6506007)(102836004)(256004)(7736002)(6486002)(14454004)(66066001)(2501003)(8676002)(305945005)(6436002)(4326008)(11346002)(68736007)(52116002)(2616005)(476003)(478600001)(6512007)(450100002)(2201001)(107886003)(53936002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2375;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: cXbbsKeX9ZoRjxdMFwanknqawjj4zuYx1wm6SGuxBcDLJiFtZ7CI7UE6bYmEzruZpwvgSfmsm3T07+bwVTbo5grFZaMDTTcQQ29pJBHOKiEbpU2O4qS4jdI8lSn5Jtk/ryp8aV4P0BWrvPagvALWSe5/ix7SxbfSBPSyJsRClEjguRAu3babFNooQ/iH1X7cGnhVNTrNHAf7MvyZsTYgyjzSkYNeSK33bVg20moFnuxN/EG4zyGsHsImnnDLiMo/hmnGoB2BBCbzAOQVLuxOjMrbOM1swxBzu792QJKrXX2ZMqAVbLqFrlBiEha+DW2hVdvsTpwflnl7rq84feTjULj4kdCpV5x182Mdudkth2Ko77PMS1vl9DR83h7/tvx4IoPbgLYCnLWVkpmCknxPj0gMmHFjWRPmuzwywnPgvVw=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c69e7e6-2da2-4e1d-c89e-08d714699017
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jul 2019 21:13:12.0712
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

Currently for PF and ECPF vports, representors are created before
their eswitch hardware ports are initialized in below flow.

mlx5_eswitch_enable()
  esw_offloads_init()
    esw_offloads_load_all_reps()
[..]
esw_enable_vport()

However for VFs, vports are initialized before creating their
respective netdev represnetors in event handling context.

Similarly while disabling eswitch, first hardware vports are disabled,
followed by destroying their representors.
Here while underlying vports gets destroyed but its respective user
facing netdevice can still exist on which user can continue to perform
more offload operations.

Instead, its more accurate to do
enable_eswitch switchdev mode:
1. perform FDB tables initialization
2. initialize hw vport
3. create and publish representor for this vport

disable_eswitch switchdev mode:
1. destroy user facing representor for the vport
2. disable hw vport
3. perform FDB tables cleanup

Signed-off-by: Parav Pandit <parav@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/eswitch.c | 54 +++++++++++--------
 .../net/ethernet/mellanox/mlx5/core/eswitch.h |  4 +-
 .../mellanox/mlx5/core/eswitch_offloads.c     |  8 ++-
 3 files changed, 41 insertions(+), 25 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/ne=
t/ethernet/mellanox/mlx5/core/eswitch.c
index 90d150be237b..d4465dd18c11 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -452,6 +452,22 @@ static int esw_create_legacy_table(struct mlx5_eswitch=
 *esw)
 	return err;
 }
=20
+#define MLX5_LEGACY_SRIOV_VPORT_EVENTS (MLX5_VPORT_UC_ADDR_CHANGE | \
+					MLX5_VPORT_MC_ADDR_CHANGE | \
+					MLX5_VPORT_PROMISC_CHANGE)
+
+static int esw_legacy_enable(struct mlx5_eswitch *esw)
+{
+	int ret;
+
+	ret =3D esw_create_legacy_table(esw);
+	if (ret)
+		return ret;
+
+	mlx5_eswitch_enable_pf_vf_vports(esw, MLX5_LEGACY_SRIOV_VPORT_EVENTS);
+	return 0;
+}
+
 static void esw_destroy_legacy_table(struct mlx5_eswitch *esw)
 {
 	esw_cleanup_vepa_rules(esw);
@@ -459,6 +475,19 @@ static void esw_destroy_legacy_table(struct mlx5_eswit=
ch *esw)
 	esw_destroy_legacy_vepa_table(esw);
 }
=20
+static void esw_legacy_disable(struct mlx5_eswitch *esw)
+{
+	struct esw_mc_addr *mc_promisc;
+
+	mlx5_eswitch_disable_pf_vf_vports(esw);
+
+	mc_promisc =3D &esw->mc_promisc;
+	if (mc_promisc->uplink_rule)
+		mlx5_del_flow_rules(mc_promisc->uplink_rule);
+
+	esw_destroy_legacy_table(esw);
+}
+
 /* E-Switch vport UC/MC lists management */
 typedef int (*vport_addr_action)(struct mlx5_eswitch *esw,
 				 struct vport_addr *vaddr);
@@ -1826,13 +1855,8 @@ void mlx5_eswitch_disable_pf_vf_vports(struct mlx5_e=
switch *esw)
 		esw_disable_vport(esw, vport);
 }
=20
-#define MLX5_LEGACY_SRIOV_VPORT_EVENTS (MLX5_VPORT_UC_ADDR_CHANGE | \
-					MLX5_VPORT_MC_ADDR_CHANGE | \
-					MLX5_VPORT_PROMISC_CHANGE)
-
 int mlx5_eswitch_enable(struct mlx5_eswitch *esw, int mode)
 {
-	int enabled_events;
 	int err;
=20
 	if (!ESW_ALLOWED(esw) ||
@@ -1854,21 +1878,16 @@ int mlx5_eswitch_enable(struct mlx5_eswitch *esw, i=
nt mode)
 	mlx5_lag_update(esw->dev);
=20
 	if (mode =3D=3D MLX5_ESWITCH_LEGACY) {
-		err =3D esw_create_legacy_table(esw);
+		err =3D esw_legacy_enable(esw);
 	} else {
 		mlx5_reload_interface(esw->dev, MLX5_INTERFACE_PROTOCOL_ETH);
 		mlx5_reload_interface(esw->dev, MLX5_INTERFACE_PROTOCOL_IB);
-		err =3D esw_offloads_init(esw);
+		err =3D esw_offloads_enable(esw);
 	}
=20
 	if (err)
 		goto abort;
=20
-	enabled_events =3D (mode =3D=3D MLX5_ESWITCH_LEGACY) ? MLX5_LEGACY_SRIOV_=
VPORT_EVENTS :
-		MLX5_VPORT_UC_ADDR_CHANGE;
-
-	mlx5_eswitch_enable_pf_vf_vports(esw, enabled_events);
-
 	mlx5_eswitch_event_handlers_register(esw);
=20
 	esw_info(esw->dev, "Enable: mode(%s), nvfs(%d), active vports(%d)\n",
@@ -1890,7 +1909,6 @@ int mlx5_eswitch_enable(struct mlx5_eswitch *esw, int=
 mode)
=20
 void mlx5_eswitch_disable(struct mlx5_eswitch *esw)
 {
-	struct esw_mc_addr *mc_promisc;
 	int old_mode;
=20
 	if (!ESW_ALLOWED(esw) || esw->mode =3D=3D MLX5_ESWITCH_NONE)
@@ -1902,16 +1920,10 @@ void mlx5_eswitch_disable(struct mlx5_eswitch *esw)
=20
 	mlx5_eswitch_event_handlers_unregister(esw);
=20
-	mlx5_eswitch_disable_pf_vf_vports(esw);
-
-	mc_promisc =3D &esw->mc_promisc;
-	if (mc_promisc->uplink_rule)
-		mlx5_del_flow_rules(mc_promisc->uplink_rule);
-
 	if (esw->mode =3D=3D MLX5_ESWITCH_LEGACY)
-		esw_destroy_legacy_table(esw);
+		esw_legacy_disable(esw);
 	else if (esw->mode =3D=3D MLX5_ESWITCH_OFFLOADS)
-		esw_offloads_cleanup(esw);
+		esw_offloads_disable(esw);
=20
 	esw_destroy_tsar(esw);
=20
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/ne=
t/ethernet/mellanox/mlx5/core/eswitch.h
index 51b6d29466f1..d447e1e44d59 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -242,8 +242,8 @@ struct mlx5_eswitch {
 	struct mlx5_esw_functions esw_funcs;
 };
=20
-void esw_offloads_cleanup(struct mlx5_eswitch *esw);
-int esw_offloads_init(struct mlx5_eswitch *esw);
+void esw_offloads_disable(struct mlx5_eswitch *esw);
+int esw_offloads_enable(struct mlx5_eswitch *esw);
 void esw_offloads_cleanup_reps(struct mlx5_eswitch *esw);
 int esw_offloads_init_reps(struct mlx5_eswitch *esw);
 void esw_vport_cleanup_ingress_rules(struct mlx5_eswitch *esw,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/d=
rivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 4be19890f725..db01b8ee9385 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -2104,7 +2104,7 @@ int mlx5_esw_funcs_changed_handler(struct notifier_bl=
ock *nb, unsigned long type
 	return NOTIFY_OK;
 }
=20
-int esw_offloads_init(struct mlx5_eswitch *esw)
+int esw_offloads_enable(struct mlx5_eswitch *esw)
 {
 	int err;
=20
@@ -2122,6 +2122,8 @@ int esw_offloads_init(struct mlx5_eswitch *esw)
 	if (err)
 		goto err_vport_metadata;
=20
+	mlx5_eswitch_enable_pf_vf_vports(esw, MLX5_VPORT_UC_ADDR_CHANGE);
+
 	err =3D esw_offloads_load_all_reps(esw);
 	if (err)
 		goto err_reps;
@@ -2134,6 +2136,7 @@ int esw_offloads_init(struct mlx5_eswitch *esw)
 	return 0;
=20
 err_reps:
+	mlx5_eswitch_disable_pf_vf_vports(esw);
 	esw_set_passing_vport_metadata(esw, false);
 err_vport_metadata:
 	esw_offloads_steering_cleanup(esw);
@@ -2159,11 +2162,12 @@ static int esw_offloads_stop(struct mlx5_eswitch *e=
sw,
 	return err;
 }
=20
-void esw_offloads_cleanup(struct mlx5_eswitch *esw)
+void esw_offloads_disable(struct mlx5_eswitch *esw)
 {
 	mlx5_rdma_disable_roce(esw->dev);
 	esw_offloads_devcom_cleanup(esw);
 	esw_offloads_unload_all_reps(esw);
+	mlx5_eswitch_disable_pf_vf_vports(esw);
 	esw_set_passing_vport_metadata(esw, false);
 	esw_offloads_steering_cleanup(esw);
 	esw->offloads.encap =3D DEVLINK_ESWITCH_ENCAP_MODE_NONE;
--=20
2.21.0

