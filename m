Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 395D7A4FB6
	for <lists+netdev@lfdr.de>; Mon,  2 Sep 2019 09:23:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729733AbfIBHXg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Sep 2019 03:23:36 -0400
Received: from mail-eopbgr10070.outbound.protection.outlook.com ([40.107.1.70]:26649
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726527AbfIBHXe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Sep 2019 03:23:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FKUE134FtUEo5FEaMoWyARPIHtbuenVRmRsz010nQ1m/dT/QdcWi+o9yK/oQJQCCiTBLvEXCctOLBLvcTzs8vg4TYcPMvKavE3YgXZo4TvLNPIy34Ifht/5i16TWE5PSNsEik547uciKOt7swBgIWLec+eOtwn0qiBAU6CrGuPgS0o7h9tjyNlkxNmDxOxZ1mmH24QIMDSQHdZJ1eNUwfTd5gHqgRvLO8nyftmdPcyXNmMMwZsZyhV5riIaxnBYur5Eqqhg52vQVo4o2J4inozSsCLPcEC6l6bH5K7NvW1a0Hn/uGyo7dm/Es+STlYSgMbc/b9cga94j0rY9BkXwcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8hG3teaNP/dDeKMqOzvIva2WHzxNKLzdFapZJIh7inE=;
 b=U1VMvA+MdPQgSvmbAExFrI7Fanh0r7x8OUUAjmfC7xM5iKKspDHThQKM22emBawG/VR3Q2P5hiRhlytq8pBnaS96GtWSG52+sUytOhDCkUghRaN9CL0LxWSG9aMvLo0V3YBzdBJV0WVV1aX/4c0fdb32Djoop/JqHlaefBss9JO3ns39sTnBli5o1KOu/M0/aPTA1IF7t7yzira/xyEnuyX/qLu6v/X+ix8WORQ6wZFEvRizWR0IwcIUa5whjAwTOSm0hlpi7biSCGS90VMOzbUv1KhxbGMzVqtEg7i/WSZlwBuE8jKUVm01/oVVPiz+h6R277nT7W+N9WZEWuEDQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8hG3teaNP/dDeKMqOzvIva2WHzxNKLzdFapZJIh7inE=;
 b=h2irFayaKcyw2cLC9/rXA7qDR++9qRBaWzw3Z1z1ltMfIibYKlPzQ8w++l7P7wJ3f/TvP/sqGbcqQ1DsoEfKA6FZZd/JnUphDOeGjGuIJjgbP3SWBteJGVc5oHyJS1Ye1YWzKPzhtriaRnaHQKd5YhJz+dJdvRNUaGz29YBpVrA=
Received: from AM4PR0501MB2756.eurprd05.prod.outlook.com (10.172.216.138) by
 AM4PR0501MB2659.eurprd05.prod.outlook.com (10.172.215.21) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2220.18; Mon, 2 Sep 2019 07:23:29 +0000
Received: from AM4PR0501MB2756.eurprd05.prod.outlook.com
 ([fe80::58d1:d1d6:dbda:3576]) by AM4PR0501MB2756.eurprd05.prod.outlook.com
 ([fe80::58d1:d1d6:dbda:3576%4]) with mapi id 15.20.2220.021; Mon, 2 Sep 2019
 07:23:29 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alex Vesker <valex@mellanox.com>,
        Erez Shitrit <erezsh@mellanox.com>,
        Maor Gottlieb <maorg@mellanox.com>,
        Mark Bloch <markb@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 17/18] net/mlx5: Add support to use SMFS in switchdev mode
Thread-Topic: [net-next 17/18] net/mlx5: Add support to use SMFS in switchdev
 mode
Thread-Index: AQHVYV9R3wI2PYmibUaj1mp1WIC3mw==
Date:   Mon, 2 Sep 2019 07:23:29 +0000
Message-ID: <20190902072213.7683-18-saeedm@mellanox.com>
References: <20190902072213.7683-1-saeedm@mellanox.com>
In-Reply-To: <20190902072213.7683-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [73.15.39.150]
x-clientproxiedby: BYAPR11CA0085.namprd11.prod.outlook.com
 (2603:10b6:a03:f4::26) To AM4PR0501MB2756.eurprd05.prod.outlook.com
 (2603:10a6:200:5c::10)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 321db71f-ec1a-412e-00d7-08d72f7673ea
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM4PR0501MB2659;
x-ms-traffictypediagnostic: AM4PR0501MB2659:|AM4PR0501MB2659:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM4PR0501MB2659AB71A01026CDEC1584F2BEBE0@AM4PR0501MB2659.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1060;
x-forefront-prvs: 01480965DA
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(366004)(346002)(39860400002)(136003)(376002)(199004)(189003)(26005)(6506007)(6486002)(2906002)(36756003)(386003)(2616005)(446003)(102836004)(52116002)(316002)(14444005)(86362001)(76176011)(6116002)(11346002)(3846002)(256004)(186003)(66066001)(476003)(7736002)(54906003)(107886003)(305945005)(25786009)(4326008)(99286004)(5660300002)(6436002)(53936002)(478600001)(6512007)(71190400001)(71200400001)(1076003)(8936002)(50226002)(486006)(14454004)(6916009)(66446008)(66476007)(66556008)(64756008)(81166006)(66946007)(81156014)(8676002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR0501MB2659;H:AM4PR0501MB2756.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: rWjWsRTSfw9wb4X7iMw67Pc0vXjoNHnMao5z5Ps3VU2jNsCfvKAY5E+2hmZNM5e/7ywao/xbrccyZuCqpqWaz5E96E9VLUnu2k7W8d1WI48vxjBDxJT/kvY6Wi08qV64PZrKQz+D4gSRdc5WyM8fiQHy6Tb82dlBCDvNKUjmB0WBWg5D9ddoctmP06Kn1iLp/65OuIcjpH2vvts70BEdmH1/L/Jjr/b9nFn+tU6UJYX9mSkID9zzZIWj1i5RktN4OGtsqhl2IYLlwPILX3NNJ9fYcCEwRr+QjNkBPonyAKFVXhnJdTiqRYxvvpoxP2jsgDXEKHEjhdCC3YxwDPtNxypfVsAI77ZfJadkvHjsBG7XonclsHiRzyy86jBjfqPyR/WoKUfHRMhFF4LDf4wZhcdg2rY95dmled1DaW1cTto=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 321db71f-ec1a-412e-00d7-08d72f7673ea
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Sep 2019 07:23:29.5365
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TL9w+rX6ihsDoIp1q70pj49+Q5Xfca99LmkgZrwepGJea5q8AkWPoIG96d0HmtbjZ1kfz0WhiTlc01Rw8NEKkw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR0501MB2659
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

