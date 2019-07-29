Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4991079AC8
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 23:13:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388526AbfG2VN0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 17:13:26 -0400
Received: from mail-eopbgr10050.outbound.protection.outlook.com ([40.107.1.50]:5933
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387803AbfG2VNX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Jul 2019 17:13:23 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZEeIvkCwotGVTY46i6nnk+Oua9DbMGuzVelzbJ3OS5Lzh+TAFgC52ICv+oPYhy7sf/WNxa+5/r1AW9My8KgxfWC/XiAvtZWKPOVbQryT1GKPhki2uvWYEc59RADYQ+6u3CtFHYCa6amhAJbOvb47rIYLvhdySaC4Ek2VXsjN4Jze32sG3mJ5oGPAsa0iWkKBGhnL31YHFcYHU2pYXFL1t+Xceqtg5A13lpx/61Tf+FC0yXQd6ndGLAsN6fuCpkaZKXWAveotwdBZS+9TUl3BHPU6V6Lh4VY77wGYHlbqC+AGLkWdUWRLZh0zNxQqLBrOBamW7NaMws7/xpzUeB84qg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NinPoY+SXXEqP9gQPOBYP+CDho9tnXtTrNYR/ULuqgk=;
 b=hkUNgOoO6tjDeAz0lR9FqTGxAVsDTH6pxRp3JwvKirlNRt20OjR6J/NvSW9nbEM/yDwQun3FH8mU0BFWenvnqepcryGurk3qfRZLwmdVT7p1vU4B7I2dv+F0rhXRmbj86F5voDnceLs4oeUuGz+frFeKvu/SzDZJTB/FK2Z/iSHcdH20O2mn5m0Nd4Q+OtO9UUoSzlhXsFP4XxYtbPjl2AbhbQyayo3LeVqEAe/v8ue8l//LCiIK60ppMTXlcm1dBepH3Un+yJLDhP7behZB/uWgqkLpVmT0Sl5fyl+Nzo/X0xefwmo5ECvZuSYM20/vbte5YQVDBZn1XnvHE7ILxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=mellanox.com;dmarc=pass action=none
 header.from=mellanox.com;dkim=pass header.d=mellanox.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NinPoY+SXXEqP9gQPOBYP+CDho9tnXtTrNYR/ULuqgk=;
 b=LUAbrF5e7aVRPbiUNJ8jsSHGBamIKgl9Fit69kyg2UumyZtF6BNbmVL7PlbskeRkc16G/033QOkcI90m/vuyv68GdM7rHBSENzdHf1jPjuVhV93rtIxuTji2VWl5uleCYyTjlhtAhcYUgw1TOOjJikfeXbqrmpPJKfmYHWATw0E=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2375.eurprd05.prod.outlook.com (10.168.72.150) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.10; Mon, 29 Jul 2019 21:13:06 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2%5]) with mapi id 15.20.2115.005; Mon, 29 Jul 2019
 21:13:06 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
CC:     Parav Pandit <parav@mellanox.com>
Subject: [PATCH mlx5-next 08/11] net/mlx5: E-switch, Introduce helper function
 to enable/disable vports
Thread-Topic: [PATCH mlx5-next 08/11] net/mlx5: E-switch, Introduce helper
 function to enable/disable vports
Thread-Index: AQHVRlJqdF5X4qzm0EmW0Bkkm5dRvw==
Date:   Mon, 29 Jul 2019 21:13:06 +0000
Message-ID: <20190729211209.14772-9-saeedm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: b99e3700-1629-4d6f-08fd-08d714698ca1
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2375;
x-ms-traffictypediagnostic: DB6PR0501MB2375:
x-microsoft-antispam-prvs: <DB6PR0501MB2375AEC53F8B0D1D02471B52BEDD0@DB6PR0501MB2375.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3631;
x-forefront-prvs: 01136D2D90
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(376002)(346002)(39860400002)(366004)(396003)(199004)(189003)(50226002)(14444005)(5660300002)(6116002)(3846002)(486006)(446003)(86362001)(81156014)(186003)(36756003)(81166006)(8936002)(26005)(25786009)(316002)(71190400001)(71200400001)(110136005)(64756008)(76176011)(66556008)(2906002)(66946007)(66446008)(99286004)(66476007)(1076003)(386003)(6506007)(102836004)(256004)(5024004)(7736002)(6486002)(14454004)(66066001)(2501003)(8676002)(305945005)(6436002)(4326008)(11346002)(68736007)(52116002)(2616005)(476003)(478600001)(6512007)(450100002)(2201001)(107886003)(53936002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2375;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 9q5tHYMT96DgTVZXXfSwfaOsMf696OWKgQ9onaYMHMtzEDnKgWydIGya5sKDtqwlfiuG6aqQsktyGKO0ruSApDqVp8cNzWXd6gARG0S/2m6x874D+Z6BWfjr+vqJXVtasl9+RpFz/NvXq0CdDKWvlnJBBcGW4+kg54Hr68iz2pRMkIcCa3rciQZ49cIuuC4N3ZaQUKXYKowU+uTHhmYdEGcCdVXerWQP67aa3QR/gz25+Mb6Cw/iAaavU5Sd3zO4+hGWUj839E5Ezn7uQ7rirOJZKBrZwxv5rkPLS9Ainz6QjJNYq8FvrTNRI5sQy/DZGdSQ0gNoJw7CUGJPGt/NU9h9lZz4EI8yv4dcy6PwJtdDq9Fd/l2H9sJkzwfmMSq7B+DULvmwpHpwXxpdm7/ePPCdtM/uuZdA770TmqDTcLs=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b99e3700-1629-4d6f-08fd-08d714698ca1
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jul 2019 21:13:06.1849
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

vports needs to be enabled in switchdev and legacy mode.

In switchdev mode, vports should be enabled after initializing
the FDB tables and before creating their represntors so that
representor works on an initialized vport object.

Prepare a helper function which can be called when enabling either of
the eswitch modes.

Similarly, have disable vports helper function.

Signed-off-by: Parav Pandit <parav@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/eswitch.c | 96 +++++++++++--------
 .../net/ethernet/mellanox/mlx5/core/eswitch.h | 19 +++-
 2 files changed, 73 insertions(+), 42 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/ne=
t/ethernet/mellanox/mlx5/core/eswitch.c
index 820970911f8b..6d82aefae6e1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -58,20 +58,9 @@ struct vport_addr {
 	bool mc_promisc;
 };
=20
-enum {
-	UC_ADDR_CHANGE =3D BIT(0),
-	MC_ADDR_CHANGE =3D BIT(1),
-	PROMISC_CHANGE =3D BIT(3),
-};
-
 static void esw_destroy_legacy_fdb_table(struct mlx5_eswitch *esw);
 static void esw_cleanup_vepa_rules(struct mlx5_eswitch *esw);
=20
-/* Vport context events */
-#define SRIOV_VPORT_EVENTS (UC_ADDR_CHANGE | \
-			    MC_ADDR_CHANGE | \
-			    PROMISC_CHANGE)
-
 struct mlx5_vport *__must_check
 mlx5_eswitch_get_vport(struct mlx5_eswitch *esw, u16 vport_num)
 {
@@ -108,13 +97,13 @@ static int arm_vport_context_events_cmd(struct mlx5_co=
re_dev *dev, u16 vport,
=20
 	MLX5_SET(nic_vport_context, nic_vport_ctx, arm_change_event, 1);
=20
-	if (events_mask & UC_ADDR_CHANGE)
+	if (events_mask & MLX5_VPORT_UC_ADDR_CHANGE)
 		MLX5_SET(nic_vport_context, nic_vport_ctx,
 			 event_on_uc_address_change, 1);
-	if (events_mask & MC_ADDR_CHANGE)
+	if (events_mask & MLX5_VPORT_MC_ADDR_CHANGE)
 		MLX5_SET(nic_vport_context, nic_vport_ctx,
 			 event_on_mc_address_change, 1);
-	if (events_mask & PROMISC_CHANGE)
+	if (events_mask & MLX5_VPORT_PROMISC_CHANGE)
 		MLX5_SET(nic_vport_context, nic_vport_ctx,
 			 event_on_promisc_change, 1);
=20
@@ -901,21 +890,21 @@ static void esw_vport_change_handle_locked(struct mlx=
5_vport *vport)
 	esw_debug(dev, "vport[%d] Context Changed: perm mac: %pM\n",
 		  vport->vport, mac);
=20
-	if (vport->enabled_events & UC_ADDR_CHANGE) {
+	if (vport->enabled_events & MLX5_VPORT_UC_ADDR_CHANGE) {
 		esw_update_vport_addr_list(esw, vport, MLX5_NVPRT_LIST_TYPE_UC);
 		esw_apply_vport_addr_list(esw, vport, MLX5_NVPRT_LIST_TYPE_UC);
 	}
=20
-	if (vport->enabled_events & MC_ADDR_CHANGE)
+	if (vport->enabled_events & MLX5_VPORT_MC_ADDR_CHANGE)
 		esw_update_vport_addr_list(esw, vport, MLX5_NVPRT_LIST_TYPE_MC);
=20
-	if (vport->enabled_events & PROMISC_CHANGE) {
+	if (vport->enabled_events & MLX5_VPORT_PROMISC_CHANGE) {
 		esw_update_vport_rx_mode(esw, vport);
 		if (!IS_ERR_OR_NULL(vport->allmulti_rule))
 			esw_update_vport_mc_promisc(esw, vport);
 	}
=20
-	if (vport->enabled_events & (PROMISC_CHANGE | MC_ADDR_CHANGE))
+	if (vport->enabled_events & (MLX5_VPORT_PROMISC_CHANGE | MLX5_VPORT_MC_AD=
DR_CHANGE))
 		esw_apply_vport_addr_list(esw, vport, MLX5_NVPRT_LIST_TYPE_MC);
=20
 	esw_debug(esw->dev, "vport[%d] Context Changed: Done\n", vport->vport);
@@ -1649,7 +1638,7 @@ static void esw_vport_destroy_drop_counters(struct ml=
x5_vport *vport)
 }
=20
 static void esw_enable_vport(struct mlx5_eswitch *esw, struct mlx5_vport *=
vport,
-			     int enable_events)
+			     enum mlx5_eswitch_vport_event enabled_events)
 {
 	u16 vport_num =3D vport->vport;
=20
@@ -1671,7 +1660,7 @@ static void esw_enable_vport(struct mlx5_eswitch *esw=
, struct mlx5_vport *vport,
 		esw_warn(esw->dev, "Failed to attach vport %d to eswitch rate limiter", =
vport_num);
=20
 	/* Sync with current vport context */
-	vport->enabled_events =3D enable_events;
+	vport->enabled_events =3D enabled_events;
 	vport->enabled =3D true;
=20
 	/* Esw manager is trusted by default. Host PF (vport 0) is trusted as wel=
l
@@ -1800,11 +1789,51 @@ static void mlx5_eswitch_event_handlers_unregister(=
struct mlx5_eswitch *esw)
 /* Public E-Switch API */
 #define ESW_ALLOWED(esw) ((esw) && MLX5_ESWITCH_MANAGER((esw)->dev))
=20
-int mlx5_eswitch_enable(struct mlx5_eswitch *esw, int mode)
+/* mlx5_eswitch_enable_pf_vf_vports() enables vports of PF, ECPF and VFs
+ * whichever are present on the eswitch.
+ */
+void
+mlx5_eswitch_enable_pf_vf_vports(struct mlx5_eswitch *esw,
+				 enum mlx5_eswitch_vport_event enabled_events)
+{
+	struct mlx5_vport *vport;
+	int i;
+
+	/* Enable PF vport */
+	vport =3D mlx5_eswitch_get_vport(esw, MLX5_VPORT_PF);
+	esw_enable_vport(esw, vport, enabled_events);
+
+	/* Enable ECPF vports */
+	if (mlx5_ecpf_vport_exists(esw->dev)) {
+		vport =3D mlx5_eswitch_get_vport(esw, MLX5_VPORT_ECPF);
+		esw_enable_vport(esw, vport, enabled_events);
+	}
+
+	/* Enable VF vports */
+	mlx5_esw_for_each_vf_vport(esw, i, vport, esw->esw_funcs.num_vfs)
+		esw_enable_vport(esw, vport, enabled_events);
+}
+
+/* mlx5_eswitch_disable_pf_vf_vports() disables vports of PF, ECPF and VFs
+ * whichever are previously enabled on the eswitch.
+ */
+void mlx5_eswitch_disable_pf_vf_vports(struct mlx5_eswitch *esw)
 {
 	struct mlx5_vport *vport;
+	int i;
+
+	mlx5_esw_for_all_vports_reverse(esw, i, vport)
+		esw_disable_vport(esw, vport);
+}
+
+#define MLX5_LEGACY_SRIOV_VPORT_EVENTS (MLX5_VPORT_UC_ADDR_CHANGE | \
+					MLX5_VPORT_MC_ADDR_CHANGE | \
+					MLX5_VPORT_PROMISC_CHANGE)
+
+int mlx5_eswitch_enable(struct mlx5_eswitch *esw, int mode)
+{
+	int enabled_events;
 	int err;
-	int i, enabled_events;
=20
 	if (!ESW_ALLOWED(esw) ||
 	    !MLX5_CAP_ESW_FLOWTABLE_FDB(esw->dev, ft_support)) {
@@ -1837,22 +1866,10 @@ int mlx5_eswitch_enable(struct mlx5_eswitch *esw, i=
nt mode)
 	if (err)
 		goto abort;
=20
-	enabled_events =3D (mode =3D=3D MLX5_ESWITCH_LEGACY) ? SRIOV_VPORT_EVENTS=
 :
-		UC_ADDR_CHANGE;
+	enabled_events =3D (mode =3D=3D MLX5_ESWITCH_LEGACY) ? MLX5_LEGACY_SRIOV_=
VPORT_EVENTS :
+		MLX5_VPORT_UC_ADDR_CHANGE;
=20
-	/* Enable PF vport */
-	vport =3D mlx5_eswitch_get_vport(esw, MLX5_VPORT_PF);
-	esw_enable_vport(esw, vport, enabled_events);
-
-	/* Enable ECPF vports */
-	if (mlx5_ecpf_vport_exists(esw->dev)) {
-		vport =3D mlx5_eswitch_get_vport(esw, MLX5_VPORT_ECPF);
-		esw_enable_vport(esw, vport, enabled_events);
-	}
-
-	/* Enable VF vports */
-	mlx5_esw_for_each_vf_vport(esw, i, vport, esw->esw_funcs.num_vfs)
-		esw_enable_vport(esw, vport, enabled_events);
+	mlx5_eswitch_enable_pf_vf_vports(esw, enabled_events);
=20
 	mlx5_eswitch_event_handlers_register(esw);
=20
@@ -1876,9 +1893,7 @@ int mlx5_eswitch_enable(struct mlx5_eswitch *esw, int=
 mode)
 void mlx5_eswitch_disable(struct mlx5_eswitch *esw)
 {
 	struct esw_mc_addr *mc_promisc;
-	struct mlx5_vport *vport;
 	int old_mode;
-	int i;
=20
 	if (!ESW_ALLOWED(esw) || esw->mode =3D=3D MLX5_ESWITCH_NONE)
 		return;
@@ -1890,8 +1905,7 @@ void mlx5_eswitch_disable(struct mlx5_eswitch *esw)
 	mc_promisc =3D &esw->mc_promisc;
 	mlx5_eswitch_event_handlers_unregister(esw);
=20
-	mlx5_esw_for_all_vports(esw, i, vport)
-		esw_disable_vport(esw, vport);
+	mlx5_eswitch_disable_pf_vf_vports(esw);
=20
 	if (mc_promisc && mc_promisc->uplink_rule)
 		mlx5_del_flow_rules(mc_promisc->uplink_rule);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/ne=
t/ethernet/mellanox/mlx5/core/eswitch.h
index a38e8a3c7c9a..3103a34c619c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -101,6 +101,13 @@ struct mlx5_vport_info {
 	bool                    trusted;
 };
=20
+/* Vport context events */
+enum mlx5_eswitch_vport_event {
+	MLX5_VPORT_UC_ADDR_CHANGE =3D BIT(0),
+	MLX5_VPORT_MC_ADDR_CHANGE =3D BIT(1),
+	MLX5_VPORT_PROMISC_CHANGE =3D BIT(3),
+};
+
 struct mlx5_vport {
 	struct mlx5_core_dev    *dev;
 	int                     vport;
@@ -122,7 +129,7 @@ struct mlx5_vport {
 	} qos;
=20
 	bool                    enabled;
-	u16                     enabled_events;
+	enum mlx5_eswitch_vport_event enabled_events;
 };
=20
 enum offloads_fdb_flags {
@@ -513,6 +520,11 @@ void mlx5e_tc_clean_fdb_peer_flows(struct mlx5_eswitch=
 *esw);
 	     (vport) =3D &(esw)->vports[i],		\
 	     (i) < (esw)->total_vports; (i)++)
=20
+#define mlx5_esw_for_all_vports_reverse(esw, i, vport)	\
+	for ((i) =3D (esw)->total_vports - 1;		\
+	     (vport) =3D &(esw)->vports[i],		\
+	     (i) >=3D MLX5_VPORT_PF; (i)--)
+
 #define mlx5_esw_for_each_vf_vport(esw, i, vport, nvfs)	\
 	for ((i) =3D MLX5_VPORT_FIRST_VF;			\
 	     (vport) =3D &(esw)->vports[(i)],		\
@@ -574,6 +586,11 @@ bool mlx5_eswitch_is_vf_vport(const struct mlx5_eswitc=
h *esw, u16 vport_num);
 void mlx5_eswitch_update_num_of_vfs(struct mlx5_eswitch *esw, const int nu=
m_vfs);
 int mlx5_esw_funcs_changed_handler(struct notifier_block *nb, unsigned lon=
g type, void *data);
=20
+void
+mlx5_eswitch_enable_pf_vf_vports(struct mlx5_eswitch *esw,
+				 enum mlx5_eswitch_vport_event enabled_events);
+void mlx5_eswitch_disable_pf_vf_vports(struct mlx5_eswitch *esw);
+
 #else  /* CONFIG_MLX5_ESWITCH */
 /* eswitch API stubs */
 static inline int  mlx5_eswitch_init(struct mlx5_core_dev *dev) { return 0=
; }
--=20
2.21.0

