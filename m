Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 744DAF96CB
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 18:14:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727431AbfKLROC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 12:14:02 -0500
Received: from mail-eopbgr40055.outbound.protection.outlook.com ([40.107.4.55]:25217
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726645AbfKLROC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Nov 2019 12:14:02 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lV/g21TzahU/hu+iNWKc2/MI2SacvkB737Ky2xc1FCKin9rJ6PC4KRO61ir49oIUFp86b4xYs4pQPkEjnrhx7VkP3eQdxCmh4rZt/MboxsJNx0ADISBrPeNd7zcJXy+JVCv1NjcIAkJVKiWse8fa5mMK0wkyVc75UNwDoyMc9M5wG04nmlCSdm8Ukww/3lJ5NazmvXxhRf0ACJWGxWPayeVE+OjO/jC3pr5QltT4SxFs1fLo1XnzRLZboG9UyIWahXcqRhU83NGXJHp/f241RwI6Zwu5FHCoIVHKbkMDSztwmSXIXTHQBZ89NSmtTYpfciqScO8vxr83RHITphcrRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xaeu9ux3VQH/NP7RCckrcnGEKLAM25d/Iq1XKEXUscE=;
 b=b6rJIZtw/656cLM30osNA7yTG3rMSBimyNRubBCEQTANE2pAHcNOGl2NZUSvwMq8T+wd9NvETWI0d/7/iPnt7BKriZiPc2CbJMqHHPOYFMC4+i/XFWCwGmcOzO3hpGV23j5MHYbaqBD1wtrvjDcnyIDRHzUqHFeRWqzyVfeWpe+3z4q1/X/Kwkj+3vFVcz67n29jFPl3IcaC9/zi2r0JowJdwG4E1hJtNWT6Xss/jJTwiMFFKQRcqsiU1uYhcQs6we8spXrSRn6E/VThd57TJCEUtPBPGMU8dbUOV0Ch1Hd/auLcwrCtinvlJK1JzhAAI33T7SDAC51zu8iVXlCkAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xaeu9ux3VQH/NP7RCckrcnGEKLAM25d/Iq1XKEXUscE=;
 b=QZirs/qdv9+Gc+PwElpY31TKcWMI5O9HVcRebFalQ6MU0dhQY328ROSTHRS2n7C9MU6elvzRATJuRJMJNNe8G+FN0AzMgd4uttAMcIQAchB4zO+pAYz4QGqRRew8nzuKF6lGejfVDynqjoNcwrw2PxPW9rH+u+rLc+JeIgqtOI8=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB5695.eurprd05.prod.outlook.com (20.178.120.150) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.20; Tue, 12 Nov 2019 17:13:51 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e%5]) with mapi id 15.20.2430.027; Tue, 12 Nov 2019
 17:13:51 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Ariel Levkovich <lariel@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 7/8] net/mlx5: Add eswitch ACL vlan trunk api
Thread-Topic: [net-next 7/8] net/mlx5: Add eswitch ACL vlan trunk api
Thread-Index: AQHVmXyO5xcv6OX0lUyyJ/+4tOqBPA==
Date:   Tue, 12 Nov 2019 17:13:51 +0000
Message-ID: <20191112171313.7049-8-saeedm@mellanox.com>
References: <20191112171313.7049-1-saeedm@mellanox.com>
In-Reply-To: <20191112171313.7049-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR06CA0059.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::36) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: c6a3eff0-73b6-47ae-e02e-08d76793b07d
x-ms-traffictypediagnostic: VI1PR05MB5695:|VI1PR05MB5695:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB56952A5A30344F782C7EC575BE770@VI1PR05MB5695.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 021975AE46
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(346002)(376002)(396003)(366004)(39860400002)(189003)(199004)(256004)(5024004)(14444005)(66556008)(64756008)(66446008)(2906002)(25786009)(66946007)(66476007)(81156014)(81166006)(8676002)(8936002)(50226002)(3846002)(6116002)(71200400001)(71190400001)(6436002)(36756003)(30864003)(6486002)(6512007)(54906003)(26005)(316002)(99286004)(1076003)(102836004)(186003)(2616005)(476003)(446003)(386003)(6506007)(4326008)(486006)(11346002)(5660300002)(52116002)(76176011)(107886003)(478600001)(6916009)(66066001)(305945005)(86362001)(7736002)(14454004)(569006);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5695;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: M3kHuEiMRl0mbVvztJMwPRhU+Fb6SohBlnoOTlRWy/2LCdJ2iUr+pRm9ZRJ74FRx9Gzlb/dtCkYltnR+8zgzCxcSVM+yLYqN+lUhihvTuvokB8vwjEKlS35gbM5XwRDi9G5ifX66u1zB3+rPrudhplx1X4g/c0N1asKJsn65tnOZfi4XATEzr6uBYo5tDha088qvH6hD2O6HQSnTVWbaZgzkCV7otZv4X7SgSjIlqi81itXjHQBpeRkz4T0ZApKjqLmLL+XWZOhIFMbwJaoQIniXGwm/24kFBNmWLG8tymz6xHWSVVPb5bkbzy2a2GiE6RX3cKkzzdFcILfZ9RjqdQ5Yj4XqMjYsw8ofOPYO39O8RKrOUSZ8cY513oHSkMfOMb+PlVbM1MxHviLH0CtAhq3KF2ISTnfhggLNhwvdU+GPAUpMAoy8BvbMyZ6XQSZt
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c6a3eff0-73b6-47ae-e02e-08d76793b07d
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Nov 2019 17:13:51.7166
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: l16gdoc/3G/hNoIwuAF2sELLgo9As3lnX2kALZJwPfd2x/msFbCRP8P1E9gZ7ktbRKRNFewvKGFWwkEFYuQgCg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5695
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ariel Levkovich <lariel@mellanox.com>

The patch is adding an api to add/remove vlan id
to/from the eswitch ACL tables, per vport.

With this api, the driver can add and remove vlan ids
to the vport's ACL table and control the vlan ids the
vport can receive and transmit.

By default, the eswitch configuration allows the vport
to receive and transmit all of the vlan ids.

Once the first vlan id is added to the ACL table using
this api for a specific direction (ingress/egress),
the rest of the vlan ids are blocked in that direction
and will have to be added to the table as well if required
by the vport.

Signed-off-by: Ariel Levkovich <lariel@mellanox.com>
Cc: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/eswitch.c | 498 +++++++++++++-----
 .../net/ethernet/mellanox/mlx5/core/eswitch.h |  29 +-
 .../mellanox/mlx5/core/eswitch_offloads.c     |   8 +-
 3 files changed, 400 insertions(+), 135 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/ne=
t/ethernet/mellanox/mlx5/core/eswitch.c
index f2e400a23a59..41d67ca6cce3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -58,6 +58,11 @@ struct vport_addr {
 	bool mc_promisc;
 };
=20
+struct mlx5_acl_vlan {
+	struct mlx5_flow_handle	*acl_vlan_rule;
+	struct list_head list;
+};
+
 static void esw_destroy_legacy_fdb_table(struct mlx5_eswitch *esw);
 static void esw_cleanup_vepa_rules(struct mlx5_eswitch *esw);
=20
@@ -950,6 +955,7 @@ int esw_vport_enable_egress_acl(struct mlx5_eswitch *es=
w,
 				struct mlx5_vport *vport)
 {
 	int inlen =3D MLX5_ST_SZ_BYTES(create_flow_group_in);
+	struct mlx5_flow_group *untagged_grp =3D NULL;
 	struct mlx5_flow_group *vlan_grp =3D NULL;
 	struct mlx5_flow_group *drop_grp =3D NULL;
 	struct mlx5_core_dev *dev =3D esw->dev;
@@ -957,11 +963,7 @@ int esw_vport_enable_egress_acl(struct mlx5_eswitch *e=
sw,
 	struct mlx5_flow_table *acl;
 	void *match_criteria;
 	u32 *flow_group_in;
-	/* The egress acl table contains 2 rules:
-	 * 1)Allow traffic with vlan_tag=3Dvst_vlan_id
-	 * 2)Drop all other traffic.
-	 */
-	int table_size =3D 2;
+	int table_size;
 	int err =3D 0;
=20
 	if (!MLX5_CAP_ESW_EGRESS_ACL(dev, ft_support))
@@ -984,6 +986,13 @@ int esw_vport_enable_egress_acl(struct mlx5_eswitch *e=
sw,
 	if (!flow_group_in)
 		return -ENOMEM;
=20
+	/* The egress acl table contains 3 groups:
+	 * 1)Allow tagged traffic with vlan_tag=3Dvst_vlan_id/vgt+_vlan_id
+	 * 2)Allow untagged traffic
+	 * 3)Drop all other traffic
+	 */
+	table_size =3D VLAN_N_VID + 2;
+
 	acl =3D mlx5_create_vport_flow_table(root_ns, 0, table_size, 0, vport->vp=
ort);
 	if (IS_ERR(acl)) {
 		err =3D PTR_ERR(acl);
@@ -994,11 +1003,25 @@ int esw_vport_enable_egress_acl(struct mlx5_eswitch =
*esw,
=20
 	MLX5_SET(create_flow_group_in, flow_group_in, match_criteria_enable, MLX5=
_MATCH_OUTER_HEADERS);
 	match_criteria =3D MLX5_ADDR_OF(create_flow_group_in, flow_group_in, matc=
h_criteria);
+
+	/* Create flow group for allowed untagged flow rule */
 	MLX5_SET_TO_ONES(fte_match_param, match_criteria, outer_headers.cvlan_tag=
);
-	MLX5_SET_TO_ONES(fte_match_param, match_criteria, outer_headers.first_vid=
);
 	MLX5_SET(create_flow_group_in, flow_group_in, start_flow_index, 0);
 	MLX5_SET(create_flow_group_in, flow_group_in, end_flow_index, 0);
=20
+	untagged_grp =3D mlx5_create_flow_group(acl, flow_group_in);
+	if (IS_ERR(untagged_grp)) {
+		err =3D PTR_ERR(untagged_grp);
+		esw_warn(dev, "Failed to create E-Switch vport[%d] egress untagged flow =
group, err(%d)\n",
+			 vport->vport, err);
+		goto out;
+	}
+
+	/* Create flow group for allowed tagged flow rules */
+	MLX5_SET_TO_ONES(fte_match_param, match_criteria, outer_headers.first_vid=
);
+	MLX5_SET(create_flow_group_in, flow_group_in, start_flow_index, 1);
+	MLX5_SET(create_flow_group_in, flow_group_in, end_flow_index, VLAN_N_VID)=
;
+
 	vlan_grp =3D mlx5_create_flow_group(acl, flow_group_in);
 	if (IS_ERR(vlan_grp)) {
 		err =3D PTR_ERR(vlan_grp);
@@ -1007,9 +1030,10 @@ int esw_vport_enable_egress_acl(struct mlx5_eswitch =
*esw,
 		goto out;
 	}
=20
+	/* Create flow group for drop rule */
 	memset(flow_group_in, 0, inlen);
-	MLX5_SET(create_flow_group_in, flow_group_in, start_flow_index, 1);
-	MLX5_SET(create_flow_group_in, flow_group_in, end_flow_index, 1);
+	MLX5_SET(create_flow_group_in, flow_group_in, start_flow_index, VLAN_N_VI=
D + 1);
+	MLX5_SET(create_flow_group_in, flow_group_in, end_flow_index, VLAN_N_VID =
+ 1);
 	drop_grp =3D mlx5_create_flow_group(acl, flow_group_in);
 	if (IS_ERR(drop_grp)) {
 		err =3D PTR_ERR(drop_grp);
@@ -1021,27 +1045,45 @@ int esw_vport_enable_egress_acl(struct mlx5_eswitch=
 *esw,
 	vport->egress.acl =3D acl;
 	vport->egress.drop_grp =3D drop_grp;
 	vport->egress.allowed_vlans_grp =3D vlan_grp;
+	vport->egress.allow_untagged_grp =3D untagged_grp;
+
 out:
+	if (err) {
+		if (!IS_ERR_OR_NULL(vlan_grp))
+			mlx5_destroy_flow_group(vlan_grp);
+		if (!IS_ERR_OR_NULL(untagged_grp))
+			mlx5_destroy_flow_group(untagged_grp);
+		if (!IS_ERR_OR_NULL(acl))
+			mlx5_destroy_flow_table(acl);
+	}
 	kvfree(flow_group_in);
-	if (err && !IS_ERR_OR_NULL(vlan_grp))
-		mlx5_destroy_flow_group(vlan_grp);
-	if (err && !IS_ERR_OR_NULL(acl))
-		mlx5_destroy_flow_table(acl);
 	return err;
 }
=20
 void esw_vport_cleanup_egress_rules(struct mlx5_eswitch *esw,
 				    struct mlx5_vport *vport)
 {
-	if (!IS_ERR_OR_NULL(vport->egress.allowed_vlan)) {
-		mlx5_del_flow_rules(vport->egress.allowed_vlan);
-		vport->egress.allowed_vlan =3D NULL;
+	struct mlx5_acl_vlan *trunk_vlan_rule, *tmp;
+
+	if (!IS_ERR_OR_NULL(vport->egress.allowed_vst_vlan)) {
+		mlx5_del_flow_rules(vport->egress.allowed_vst_vlan);
+		vport->egress.allowed_vst_vlan =3D NULL;
+	}
+
+	list_for_each_entry_safe(trunk_vlan_rule, tmp,
+				 &vport->egress.legacy.allowed_vlans_rules, list) {
+		mlx5_del_flow_rules(trunk_vlan_rule->acl_vlan_rule);
+		list_del(&trunk_vlan_rule->list);
+		kfree(trunk_vlan_rule);
 	}
=20
 	if (!IS_ERR_OR_NULL(vport->egress.legacy.drop_rule)) {
 		mlx5_del_flow_rules(vport->egress.legacy.drop_rule);
 		vport->egress.legacy.drop_rule =3D NULL;
 	}
+
+	if (!IS_ERR_OR_NULL(vport->egress.legacy.allow_untagged_rule))
+		mlx5_del_flow_rules(vport->egress.legacy.allow_untagged_rule);
 }
=20
 void esw_vport_disable_egress_acl(struct mlx5_eswitch *esw,
@@ -1053,9 +1095,11 @@ void esw_vport_disable_egress_acl(struct mlx5_eswitc=
h *esw,
 	esw_debug(esw->dev, "Destroy vport[%d] E-Switch egress ACL\n", vport->vpo=
rt);
=20
 	esw_vport_cleanup_egress_rules(esw, vport);
+	mlx5_destroy_flow_group(vport->egress.allow_untagged_grp);
 	mlx5_destroy_flow_group(vport->egress.allowed_vlans_grp);
 	mlx5_destroy_flow_group(vport->egress.drop_grp);
 	mlx5_destroy_flow_table(vport->egress.acl);
+	vport->egress.allow_untagged_grp =3D NULL;
 	vport->egress.allowed_vlans_grp =3D NULL;
 	vport->egress.drop_grp =3D NULL;
 	vport->egress.acl =3D NULL;
@@ -1065,12 +1109,18 @@ static int
 esw_vport_create_legacy_ingress_acl_groups(struct mlx5_eswitch *esw,
 					   struct mlx5_vport *vport)
 {
+	bool need_vlan_filter =3D !!bitmap_weight(vport->ingress.legacy.acl_vlan_=
8021q_bitmap,
+						VLAN_N_VID);
 	int inlen =3D MLX5_ST_SZ_BYTES(create_flow_group_in);
+	struct mlx5_flow_group *untagged_spoof_grp =3D NULL;
+	struct mlx5_flow_table *acl =3D vport->ingress.acl;
+	struct mlx5_flow_group *tagged_spoof_grp =3D NULL;
+	struct mlx5_flow_group *drop_grp =3D NULL;
 	struct mlx5_core_dev *dev =3D esw->dev;
-	struct mlx5_flow_group *g;
 	void *match_criteria;
+	int allow_grp_sz =3D 0;
 	u32 *flow_group_in;
-	int err;
+	int err =3D 0;
=20
 	flow_group_in =3D kvzalloc(inlen, GFP_KERNEL);
 	if (!flow_group_in)
@@ -1079,83 +1129,68 @@ esw_vport_create_legacy_ingress_acl_groups(struct m=
lx5_eswitch *esw,
 	match_criteria =3D MLX5_ADDR_OF(create_flow_group_in, flow_group_in, matc=
h_criteria);
=20
 	MLX5_SET(create_flow_group_in, flow_group_in, match_criteria_enable, MLX5=
_MATCH_OUTER_HEADERS);
-	MLX5_SET_TO_ONES(fte_match_param, match_criteria, outer_headers.cvlan_tag=
);
-	MLX5_SET_TO_ONES(fte_match_param, match_criteria, outer_headers.smac_47_1=
6);
-	MLX5_SET_TO_ONES(fte_match_param, match_criteria, outer_headers.smac_15_0=
);
+
+	if (vport->info.vlan || vport->info.qos || need_vlan_filter)
+		MLX5_SET_TO_ONES(fte_match_param, match_criteria, outer_headers.cvlan_ta=
g);
+
+	if (vport->info.spoofchk) {
+		MLX5_SET_TO_ONES(fte_match_param, match_criteria, outer_headers.smac_47_=
16);
+		MLX5_SET_TO_ONES(fte_match_param, match_criteria, outer_headers.smac_15_=
0);
+	}
+
 	MLX5_SET(create_flow_group_in, flow_group_in, start_flow_index, 0);
 	MLX5_SET(create_flow_group_in, flow_group_in, end_flow_index, 0);
=20
-	g =3D mlx5_create_flow_group(vport->ingress.acl, flow_group_in);
-	if (IS_ERR(g)) {
-		err =3D PTR_ERR(g);
+	untagged_spoof_grp =3D mlx5_create_flow_group(acl, flow_group_in);
+	if (IS_ERR(untagged_spoof_grp)) {
+		err =3D PTR_ERR(untagged_spoof_grp);
 		esw_warn(dev, "vport[%d] ingress create untagged spoofchk flow group, er=
r(%d)\n",
 			 vport->vport, err);
-		goto spoof_err;
+		goto out;
 	}
-	vport->ingress.legacy.allow_untagged_spoofchk_grp =3D g;
+	allow_grp_sz +=3D 1;
=20
-	memset(flow_group_in, 0, inlen);
-	MLX5_SET(create_flow_group_in, flow_group_in, match_criteria_enable, MLX5=
_MATCH_OUTER_HEADERS);
-	MLX5_SET_TO_ONES(fte_match_param, match_criteria, outer_headers.cvlan_tag=
);
+	if (!need_vlan_filter)
+		goto drop_grp;
+
+	MLX5_SET_TO_ONES(fte_match_param, match_criteria, outer_headers.first_vid=
);
 	MLX5_SET(create_flow_group_in, flow_group_in, start_flow_index, 1);
-	MLX5_SET(create_flow_group_in, flow_group_in, end_flow_index, 1);
+	MLX5_SET(create_flow_group_in, flow_group_in, end_flow_index, VLAN_N_VID)=
;
=20
-	g =3D mlx5_create_flow_group(vport->ingress.acl, flow_group_in);
-	if (IS_ERR(g)) {
-		err =3D PTR_ERR(g);
-		esw_warn(dev, "vport[%d] ingress create untagged flow group, err(%d)\n",
+	tagged_spoof_grp =3D mlx5_create_flow_group(acl, flow_group_in);
+	if (IS_ERR(tagged_spoof_grp)) {
+		err =3D PTR_ERR(tagged_spoof_grp);
+		esw_warn(dev, "Failed to create E-Switch vport[%d] ingress tagged spoofc=
hk flow group, err(%d)\n",
 			 vport->vport, err);
-		goto untagged_err;
+		goto out;
 	}
-	vport->ingress.legacy.allow_untagged_only_grp =3D g;
+	allow_grp_sz +=3D VLAN_N_VID;
=20
+drop_grp:
 	memset(flow_group_in, 0, inlen);
-	MLX5_SET(create_flow_group_in, flow_group_in, match_criteria_enable, MLX5=
_MATCH_OUTER_HEADERS);
-	MLX5_SET_TO_ONES(fte_match_param, match_criteria, outer_headers.smac_47_1=
6);
-	MLX5_SET_TO_ONES(fte_match_param, match_criteria, outer_headers.smac_15_0=
);
-	MLX5_SET(create_flow_group_in, flow_group_in, start_flow_index, 2);
-	MLX5_SET(create_flow_group_in, flow_group_in, end_flow_index, 2);
+	MLX5_SET(create_flow_group_in, flow_group_in, start_flow_index, allow_grp=
_sz);
+	MLX5_SET(create_flow_group_in, flow_group_in, end_flow_index, allow_grp_s=
z);
=20
-	g =3D mlx5_create_flow_group(vport->ingress.acl, flow_group_in);
-	if (IS_ERR(g)) {
-		err =3D PTR_ERR(g);
-		esw_warn(dev, "vport[%d] ingress create spoofchk flow group, err(%d)\n",
+	drop_grp =3D mlx5_create_flow_group(vport->ingress.acl, flow_group_in);
+	if (IS_ERR(drop_grp)) {
+		err =3D PTR_ERR(drop_grp);
+		esw_warn(dev, "vport[%d] ingress create drop flow group, err(%d)\n",
 			 vport->vport, err);
-		goto allow_spoof_err;
+		goto out;
 	}
-	vport->ingress.legacy.allow_spoofchk_only_grp =3D g;
=20
-	memset(flow_group_in, 0, inlen);
-	MLX5_SET(create_flow_group_in, flow_group_in, start_flow_index, 3);
-	MLX5_SET(create_flow_group_in, flow_group_in, end_flow_index, 3);
+	vport->ingress.legacy.allow_untagged_spoofchk_grp =3D untagged_spoof_grp;
+	vport->ingress.legacy.allow_tagged_spoofchk_grp =3D tagged_spoof_grp;
+	vport->ingress.legacy.drop_grp =3D drop_grp;
=20
-	g =3D mlx5_create_flow_group(vport->ingress.acl, flow_group_in);
-	if (IS_ERR(g)) {
-		err =3D PTR_ERR(g);
-		esw_warn(dev, "vport[%d] ingress create drop flow group, err(%d)\n",
-			 vport->vport, err);
-		goto drop_err;
+out:
+	if (err) {
+		if (!IS_ERR_OR_NULL(tagged_spoof_grp))
+			mlx5_destroy_flow_group(tagged_spoof_grp);
+		if (!IS_ERR_OR_NULL(untagged_spoof_grp))
+			mlx5_destroy_flow_group(untagged_spoof_grp);
 	}
-	vport->ingress.legacy.drop_grp =3D g;
-	kvfree(flow_group_in);
-	return 0;
=20
-drop_err:
-	if (!IS_ERR_OR_NULL(vport->ingress.legacy.allow_spoofchk_only_grp)) {
-		mlx5_destroy_flow_group(vport->ingress.legacy.allow_spoofchk_only_grp);
-		vport->ingress.legacy.allow_spoofchk_only_grp =3D NULL;
-	}
-allow_spoof_err:
-	if (!IS_ERR_OR_NULL(vport->ingress.legacy.allow_untagged_only_grp)) {
-		mlx5_destroy_flow_group(vport->ingress.legacy.allow_untagged_only_grp);
-		vport->ingress.legacy.allow_untagged_only_grp =3D NULL;
-	}
-untagged_err:
-	if (!IS_ERR_OR_NULL(vport->ingress.legacy.allow_untagged_spoofchk_grp)) {
-		mlx5_destroy_flow_group(vport->ingress.legacy.allow_untagged_spoofchk_gr=
p);
-		vport->ingress.legacy.allow_untagged_spoofchk_grp =3D NULL;
-	}
-spoof_err:
 	kvfree(flow_group_in);
 	return err;
 }
@@ -1207,14 +1242,23 @@ void esw_vport_destroy_ingress_acl_table(struct mlx=
5_vport *vport)
 void esw_vport_cleanup_ingress_rules(struct mlx5_eswitch *esw,
 				     struct mlx5_vport *vport)
 {
+	struct mlx5_acl_vlan *trunk_vlan_rule, *tmp;
+
 	if (vport->ingress.legacy.drop_rule) {
 		mlx5_del_flow_rules(vport->ingress.legacy.drop_rule);
 		vport->ingress.legacy.drop_rule =3D NULL;
 	}
=20
-	if (vport->ingress.allow_rule) {
-		mlx5_del_flow_rules(vport->ingress.allow_rule);
-		vport->ingress.allow_rule =3D NULL;
+	list_for_each_entry_safe(trunk_vlan_rule, tmp,
+				 &vport->ingress.legacy.allowed_vlans_rules, list) {
+		mlx5_del_flow_rules(trunk_vlan_rule->acl_vlan_rule);
+		list_del(&trunk_vlan_rule->list);
+		kfree(trunk_vlan_rule);
+	}
+
+	if (vport->ingress.allow_untagged_rule) {
+		mlx5_del_flow_rules(vport->ingress.allow_untagged_rule);
+		vport->ingress.allow_untagged_rule =3D NULL;
 	}
 }
=20
@@ -1227,18 +1271,14 @@ static void esw_vport_disable_legacy_ingress_acl(st=
ruct mlx5_eswitch *esw,
 	esw_debug(esw->dev, "Destroy vport[%d] E-Switch ingress ACL\n", vport->vp=
ort);
=20
 	esw_vport_cleanup_ingress_rules(esw, vport);
-	if (vport->ingress.legacy.allow_spoofchk_only_grp) {
-		mlx5_destroy_flow_group(vport->ingress.legacy.allow_spoofchk_only_grp);
-		vport->ingress.legacy.allow_spoofchk_only_grp =3D NULL;
-	}
-	if (vport->ingress.legacy.allow_untagged_only_grp) {
-		mlx5_destroy_flow_group(vport->ingress.legacy.allow_untagged_only_grp);
-		vport->ingress.legacy.allow_untagged_only_grp =3D NULL;
-	}
 	if (vport->ingress.legacy.allow_untagged_spoofchk_grp) {
 		mlx5_destroy_flow_group(vport->ingress.legacy.allow_untagged_spoofchk_gr=
p);
 		vport->ingress.legacy.allow_untagged_spoofchk_grp =3D NULL;
 	}
+	if (vport->ingress.legacy.allow_tagged_spoofchk_grp) {
+		mlx5_destroy_flow_group(vport->ingress.legacy.allow_tagged_spoofchk_grp)=
;
+		vport->ingress.legacy.allow_tagged_spoofchk_grp =3D NULL;
+	}
 	if (vport->ingress.legacy.drop_grp) {
 		mlx5_destroy_flow_group(vport->ingress.legacy.drop_grp);
 		vport->ingress.legacy.drop_grp =3D NULL;
@@ -1252,30 +1292,45 @@ static int esw_vport_ingress_config(struct mlx5_esw=
itch *esw,
 	struct mlx5_fc *counter =3D vport->ingress.legacy.drop_counter;
 	struct mlx5_flow_destination drop_ctr_dst =3D {0};
 	struct mlx5_flow_destination *dst =3D NULL;
+	struct mlx5_acl_vlan *trunk_vlan_rule;
 	struct mlx5_flow_act flow_act =3D {0};
 	struct mlx5_flow_spec *spec =3D NULL;
+	bool need_vlan_filter;
+	bool need_acl_table;
 	int dest_num =3D 0;
+	u16 vlan_id =3D 0;
+	int table_size;
 	int err =3D 0;
 	u8 *smac_v;
=20
-	/* The ingress acl table contains 4 groups
-	 * (2 active rules at the same time -
-	 *      1 allow rule from one of the first 3 groups.
-	 *      1 drop rule from the last group):
-	 * 1)Allow untagged traffic with smac=3Doriginal mac.
-	 * 2)Allow untagged traffic.
-	 * 3)Allow traffic with smac=3Doriginal mac.
-	 * 4)Drop all other traffic.
-	 */
-	int table_size =3D 4;
-
 	esw_vport_cleanup_ingress_rules(esw, vport);
=20
-	if (!vport->info.vlan && !vport->info.qos && !vport->info.spoofchk) {
+	need_vlan_filter =3D !!bitmap_weight(vport->ingress.legacy.acl_vlan_8021q=
_bitmap,
+					   VLAN_N_VID);
+	need_acl_table =3D vport->info.vlan || vport->info.qos ||
+			 vport->info.spoofchk || need_vlan_filter;
+
+	if (!need_acl_table) {
 		esw_vport_disable_legacy_ingress_acl(esw, vport);
 		return 0;
 	}
=20
+	if ((vport->info.vlan || vport->info.qos) && need_vlan_filter) {
+		mlx5_core_warn(esw->dev,
+			       "vport[%d] configure ingress rules failed, Cannot enable both VG=
T+ and VST\n",
+			       vport->vport);
+		return -EPERM;
+	}
+
+	/* The ingress acl table contains 3 groups
+	 * (2 active rules at the same time -
+	 *	1 allow rule from one of the first 2 groups.
+	 *	1 drop rule from the last group):
+	 * 1)Allow untagged traffic with/without smac=3Doriginal mac.
+	 * 2)Allow tagged (VLAN trunk list) traffic with/without smac=3Doriginal =
mac.
+	 * 3)Drop all other traffic.
+	 */
+	table_size =3D need_vlan_filter ? 8192 : 4;
 	if (!vport->ingress.acl) {
 		err =3D esw_vport_create_ingress_acl_table(esw, vport, table_size);
 		if (err) {
@@ -1300,7 +1355,10 @@ static int esw_vport_ingress_config(struct mlx5_eswi=
tch *esw,
 		goto out;
 	}
=20
-	if (vport->info.vlan || vport->info.qos)
+	spec->match_criteria_enable =3D MLX5_MATCH_OUTER_HEADERS;
+	flow_act.action =3D MLX5_FLOW_CONTEXT_ACTION_ALLOW;
+
+	if (vport->info.vlan || vport->info.qos || need_vlan_filter)
 		MLX5_SET_TO_ONES(fte_match_param, spec->match_criteria, outer_headers.cv=
lan_tag);
=20
 	if (vport->info.spoofchk) {
@@ -1312,20 +1370,52 @@ static int esw_vport_ingress_config(struct mlx5_esw=
itch *esw,
 		ether_addr_copy(smac_v, vport->info.mac);
 	}
=20
-	spec->match_criteria_enable =3D MLX5_MATCH_OUTER_HEADERS;
-	flow_act.action =3D MLX5_FLOW_CONTEXT_ACTION_ALLOW;
-	vport->ingress.allow_rule =3D
-		mlx5_add_flow_rules(vport->ingress.acl, spec,
-				    &flow_act, NULL, 0);
-	if (IS_ERR(vport->ingress.allow_rule)) {
-		err =3D PTR_ERR(vport->ingress.allow_rule);
-		esw_warn(esw->dev,
-			 "vport[%d] configure ingress allow rule, err(%d)\n",
-			 vport->vport, err);
-		vport->ingress.allow_rule =3D NULL;
-		goto out;
+	/* Allow untagged */
+	if (!need_vlan_filter ||
+	    (need_vlan_filter && test_bit(0, vport->ingress.legacy.acl_vlan_8021q=
_bitmap))) {
+		vport->ingress.allow_untagged_rule =3D
+			mlx5_add_flow_rules(vport->ingress.acl, spec,
+					    &flow_act, NULL, 0);
+		if (IS_ERR(vport->ingress.allow_untagged_rule)) {
+			err =3D PTR_ERR(vport->ingress.allow_untagged_rule);
+			esw_warn(esw->dev,
+				 "vport[%d] configure ingress allow rule, err(%d)\n",
+				 vport->vport, err);
+			vport->ingress.allow_untagged_rule =3D NULL;
+			goto out;
+		}
 	}
=20
+	if (!need_vlan_filter)
+		goto drop_rule;
+
+	/* Allow tagged (VLAN trunk list) */
+	MLX5_SET_TO_ONES(fte_match_param, spec->match_value, outer_headers.cvlan_=
tag);
+	MLX5_SET_TO_ONES(fte_match_param, spec->match_criteria, outer_headers.fir=
st_vid);
+
+	for_each_set_bit(vlan_id, vport->ingress.legacy.acl_vlan_8021q_bitmap, VL=
AN_N_VID) {
+		trunk_vlan_rule =3D kzalloc(sizeof(*trunk_vlan_rule), GFP_KERNEL);
+		if (!trunk_vlan_rule) {
+			err =3D -ENOMEM;
+			goto out;
+		}
+
+		MLX5_SET(fte_match_param, spec->match_value, outer_headers.first_vid,
+			 vlan_id);
+		trunk_vlan_rule->acl_vlan_rule =3D
+			mlx5_add_flow_rules(vport->ingress.acl, spec, &flow_act, NULL, 0);
+		if (IS_ERR(trunk_vlan_rule->acl_vlan_rule)) {
+			err =3D PTR_ERR(trunk_vlan_rule->acl_vlan_rule);
+			esw_warn(esw->dev,
+				 "vport[%d] configure ingress allowed vlan rule failed, err(%d)\n",
+				 vport->vport, err);
+			kfree(trunk_vlan_rule);
+			continue;
+		}
+		list_add(&trunk_vlan_rule->list, &vport->ingress.legacy.allowed_vlans_ru=
les);
+	}
+
+drop_rule:
 	memset(spec, 0, sizeof(*spec));
 	flow_act.action =3D MLX5_FLOW_CONTEXT_ACTION_DROP;
=20
@@ -1348,11 +1438,11 @@ static int esw_vport_ingress_config(struct mlx5_esw=
itch *esw,
 		vport->ingress.legacy.drop_rule =3D NULL;
 		goto out;
 	}
-	kvfree(spec);
-	return 0;
=20
 out:
-	esw_vport_disable_legacy_ingress_acl(esw, vport);
+	if (err)
+		esw_vport_disable_legacy_ingress_acl(esw, vport);
+
 	kvfree(spec);
 	return err;
 }
@@ -1365,7 +1455,7 @@ int mlx5_esw_create_vport_egress_acl_vlan(struct mlx5=
_eswitch *esw,
 	struct mlx5_flow_spec *spec;
 	int err =3D 0;
=20
-	if (vport->egress.allowed_vlan)
+	if (vport->egress.allowed_vst_vlan)
 		return -EEXIST;
=20
 	spec =3D kvzalloc(sizeof(*spec), GFP_KERNEL);
@@ -1379,15 +1469,15 @@ int mlx5_esw_create_vport_egress_acl_vlan(struct ml=
x5_eswitch *esw,
=20
 	spec->match_criteria_enable =3D MLX5_MATCH_OUTER_HEADERS;
 	flow_act.action =3D flow_action;
-	vport->egress.allowed_vlan =3D
+	vport->egress.allowed_vst_vlan =3D
 		mlx5_add_flow_rules(vport->egress.acl, spec,
 				    &flow_act, NULL, 0);
-	if (IS_ERR(vport->egress.allowed_vlan)) {
-		err =3D PTR_ERR(vport->egress.allowed_vlan);
+	if (IS_ERR(vport->egress.allowed_vst_vlan)) {
+		err =3D PTR_ERR(vport->egress.allowed_vst_vlan);
 		esw_warn(esw->dev,
 			 "vport[%d] configure egress vlan rule failed, err(%d)\n",
 			 vport->vport, err);
-		vport->egress.allowed_vlan =3D NULL;
+		vport->egress.allowed_vst_vlan =3D NULL;
 	}
=20
 	kvfree(spec);
@@ -1400,14 +1490,21 @@ static int esw_vport_egress_config(struct mlx5_eswi=
tch *esw,
 	struct mlx5_fc *counter =3D vport->egress.legacy.drop_counter;
 	struct mlx5_flow_destination drop_ctr_dst =3D {0};
 	struct mlx5_flow_destination *dst =3D NULL;
+	struct mlx5_acl_vlan *trunk_vlan_rule;
 	struct mlx5_flow_act flow_act =3D {0};
 	struct mlx5_flow_spec *spec;
+	bool need_vlan_filter;
+	bool need_acl_table;
 	int dest_num =3D 0;
+	u16 vlan_id =3D 0;
 	int err =3D 0;
=20
 	esw_vport_cleanup_egress_rules(esw, vport);
=20
-	if (!vport->info.vlan && !vport->info.qos) {
+	need_vlan_filter =3D !!bitmap_weight(vport->egress.legacy.acl_vlan_8021q_=
bitmap,
+					   VLAN_N_VID);
+	need_acl_table =3D vport->info.vlan || vport->info.qos || need_vlan_filte=
r;
+	if (!need_acl_table) {
 		esw_vport_disable_egress_acl(esw, vport);
 		return 0;
 	}
@@ -1424,17 +1521,67 @@ static int esw_vport_egress_config(struct mlx5_eswi=
tch *esw,
 		  "vport[%d] configure egress rules, vlan(%d) qos(%d)\n",
 		  vport->vport, vport->info.vlan, vport->info.qos);
=20
-	/* Allowed vlan rule */
-	err =3D mlx5_esw_create_vport_egress_acl_vlan(esw, vport, vport->info.vla=
n,
-						    MLX5_FLOW_CONTEXT_ACTION_ALLOW);
-	if (err)
-		return err;
-
-	/* Drop others rule (star rule) */
 	spec =3D kvzalloc(sizeof(*spec), GFP_KERNEL);
-	if (!spec)
+	if (!spec) {
+		err =3D -ENOMEM;
 		goto out;
+	}
+
+	MLX5_SET_TO_ONES(fte_match_param, spec->match_criteria, outer_headers.cvl=
an_tag);
+	spec->match_criteria_enable =3D MLX5_MATCH_OUTER_HEADERS;
+	flow_act.action =3D MLX5_FLOW_CONTEXT_ACTION_ALLOW;
+
+	/* Allow untagged */
+	if (need_vlan_filter && test_bit(0, vport->egress.legacy.acl_vlan_8021q_b=
itmap)) {
+		vport->egress.legacy.allow_untagged_rule =3D
+			mlx5_add_flow_rules(vport->egress.acl, spec,
+					    &flow_act, NULL, 0);
+		if (IS_ERR(vport->egress.legacy.allow_untagged_rule)) {
+			err =3D PTR_ERR(vport->egress.legacy.allow_untagged_rule);
+			esw_warn(esw->dev,
+				 "vport[%d] configure egress allow rule, err(%d)\n",
+				 vport->vport, err);
+			vport->egress.legacy.allow_untagged_rule =3D NULL;
+		}
+	}
=20
+	/* VST rule */
+	if (vport->info.vlan || vport->info.qos) {
+		err =3D mlx5_esw_create_vport_egress_acl_vlan(esw, vport, vport->info.vl=
an,
+							    MLX5_FLOW_CONTEXT_ACTION_ALLOW);
+		if (err)
+			goto out;
+	}
+
+	/* Allowed trunk vlans rules (VGT+) */
+	MLX5_SET_TO_ONES(fte_match_param, spec->match_value, outer_headers.cvlan_=
tag);
+	MLX5_SET_TO_ONES(fte_match_param, spec->match_criteria, outer_headers.fir=
st_vid);
+
+	for_each_set_bit(vlan_id, vport->egress.legacy.acl_vlan_8021q_bitmap, VLA=
N_N_VID) {
+		trunk_vlan_rule =3D kzalloc(sizeof(*trunk_vlan_rule), GFP_KERNEL);
+		if (!trunk_vlan_rule) {
+			err =3D -ENOMEM;
+			goto out;
+		}
+
+		MLX5_SET(fte_match_param, spec->match_value, outer_headers.first_vid,
+			 vlan_id);
+		trunk_vlan_rule->acl_vlan_rule =3D
+			mlx5_add_flow_rules(vport->egress.acl, spec, &flow_act, NULL, 0);
+		if (IS_ERR(trunk_vlan_rule->acl_vlan_rule)) {
+			err =3D PTR_ERR(trunk_vlan_rule->acl_vlan_rule);
+			esw_warn(esw->dev,
+				 "vport[%d] configure egress allowed vlan rule failed, err(%d)\n",
+				 vport->vport, err);
+			kfree(trunk_vlan_rule);
+			continue;
+		}
+		list_add(&trunk_vlan_rule->list, &vport->egress.legacy.allowed_vlans_rul=
es);
+	}
+
+	/* Drop others rule (star rule) */
+
+	memset(spec, 0, sizeof(*spec));
 	flow_act.action =3D MLX5_FLOW_CONTEXT_ACTION_DROP;
=20
 	/* Attach egress drop flow counter */
@@ -1455,7 +1602,11 @@ static int esw_vport_egress_config(struct mlx5_eswit=
ch *esw,
 			 vport->vport, err);
 		vport->egress.legacy.drop_rule =3D NULL;
 	}
+
 out:
+	if (err)
+		esw_vport_cleanup_egress_rules(esw, vport);
+
 	kvfree(spec);
 	return err;
 }
@@ -1787,6 +1938,11 @@ static int esw_enable_vport(struct mlx5_eswitch *esw=
, struct mlx5_vport *vport,
=20
 	esw_debug(esw->dev, "Enabling VPORT(%d)\n", vport_num);
=20
+	bitmap_zero(vport->ingress.legacy.acl_vlan_8021q_bitmap, VLAN_N_VID);
+	bitmap_zero(vport->egress.legacy.acl_vlan_8021q_bitmap, VLAN_N_VID);
+	INIT_LIST_HEAD(&vport->egress.legacy.allowed_vlans_rules);
+	INIT_LIST_HEAD(&vport->ingress.legacy.allowed_vlans_rules);
+
 	/* Restore old vport configuration */
 	esw_apply_vport_conf(esw, vport);
=20
@@ -2268,6 +2424,7 @@ int mlx5_eswitch_get_vport_config(struct mlx5_eswitch=
 *esw,
 	ivi->trusted =3D evport->info.trusted;
 	ivi->min_tx_rate =3D evport->info.min_rate;
 	ivi->max_tx_rate =3D evport->info.max_rate;
+
 	mutex_unlock(&esw->state_lock);
=20
 	return 0;
@@ -2286,6 +2443,15 @@ int __mlx5_eswitch_set_vport_vlan(struct mlx5_eswitc=
h *esw,
 	if (vlan > 4095 || qos > 7)
 		return -EINVAL;
=20
+	if (bitmap_weight(evport->ingress.legacy.acl_vlan_8021q_bitmap, VLAN_N_VI=
D) ||
+	    bitmap_weight(evport->egress.legacy.acl_vlan_8021q_bitmap, VLAN_N_VID=
)) {
+		err =3D -EPERM;
+		mlx5_core_warn(esw->dev,
+			       "VST is not allowed when operating in VGT+ mode vport(%d)\n",
+			       vport);
+		return -EPERM;
+	}
+
 	err =3D modify_esw_vport_cvlan(esw->dev, vport, vlan, qos, set_flags);
 	if (err)
 		return err;
@@ -2628,6 +2794,84 @@ static int mlx5_eswitch_query_vport_drop_stats(struc=
t mlx5_core_dev *dev,
 	return 0;
 }
=20
+int mlx5_eswitch_add_vport_trunk_vlan(struct mlx5_eswitch *esw,
+				      u16 vport, u16 vlanid,
+				      enum mlx5_acl_flow_direction dir)
+{
+	struct mlx5_vport *evport;
+	unsigned long *vlan_bm;
+	int err =3D 0;
+
+	if (!ESW_ALLOWED(esw))
+		return -EPERM;
+
+	mutex_lock(&esw->state_lock);
+
+	evport =3D mlx5_eswitch_get_vport(esw, vport);
+	if (IS_ERR(evport) || vlanid >=3D VLAN_N_VID) {
+		err =3D -EINVAL;
+		goto unlock;
+	}
+
+	if (evport->info.vlan || evport->info.qos) {
+		err =3D -EPERM;
+		mlx5_core_warn(esw->dev,
+			       "VGT+ is not allowed when operating in VST mode vport(%d)\n",
+			       vport);
+		goto unlock;
+	}
+
+	vlan_bm =3D (dir =3D=3D MLX5_ACL_EGRESS) ? evport->egress.legacy.acl_vlan=
_8021q_bitmap :
+					     evport->ingress.legacy.acl_vlan_8021q_bitmap;
+	if (!test_bit(vlanid, vlan_bm)) {
+		bitmap_set(vlan_bm, vlanid, 1);
+		err =3D (dir =3D=3D MLX5_ACL_EGRESS) ? esw_vport_egress_config(esw, evpo=
rt) :
+						 esw_vport_ingress_config(esw, evport);
+	}
+
+	if (err)
+		bitmap_clear(vlan_bm, vlanid, 1);
+
+unlock:
+	mutex_unlock(&esw->state_lock);
+
+	return err;
+}
+
+int mlx5_eswitch_del_vport_trunk_vlan(struct mlx5_eswitch *esw,
+				      u16 vport, u16 vlanid,
+				      enum mlx5_acl_flow_direction dir)
+{
+	struct mlx5_vport *evport;
+	unsigned long *vlan_bm;
+	int err =3D 0;
+
+	if (!ESW_ALLOWED(esw))
+		return -EPERM;
+
+	mutex_lock(&esw->state_lock);
+
+	evport =3D mlx5_eswitch_get_vport(esw, vport);
+
+	if (IS_ERR(evport) || vlanid >=3D VLAN_N_VID) {
+		err =3D -EINVAL;
+		goto unlock;
+	}
+
+	vlan_bm =3D (dir =3D=3D MLX5_ACL_EGRESS) ? evport->egress.legacy.acl_vlan=
_8021q_bitmap :
+					     evport->ingress.legacy.acl_vlan_8021q_bitmap;
+	if (test_bit(vlanid, vlan_bm)) {
+		bitmap_clear(vlan_bm, vlanid, 1);
+		err =3D (dir =3D=3D MLX5_ACL_EGRESS) ? esw_vport_egress_config(esw, evpo=
rt) :
+						 esw_vport_ingress_config(esw, evport);
+	}
+
+unlock:
+	mutex_unlock(&esw->state_lock);
+
+	return err;
+}
+
 int mlx5_eswitch_get_vport_stats(struct mlx5_eswitch *esw,
 				 u16 vport_num,
 				 struct ifla_vf_stats *vf_stats)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/ne=
t/ethernet/mellanox/mlx5/core/eswitch.h
index 920d8f529fb9..5c84dbdb300f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -35,6 +35,8 @@
=20
 #include <linux/if_ether.h>
 #include <linux/if_link.h>
+#include <linux/if_vlan.h>
+#include <linux/bitmap.h>
 #include <linux/atomic.h>
 #include <net/devlink.h>
 #include <linux/mlx5/device.h>
@@ -51,6 +53,9 @@
 #define MLX5_MAX_MC_PER_VPORT(dev) \
 	(1 << MLX5_CAP_GEN(dev, log_max_current_mc_list))
=20
+#define MLX5_MAX_VLAN_PER_VPORT(dev) \
+	(1 << MLX5_CAP_GEN(dev, log_max_vlan_list))
+
 #define MLX5_MIN_BW_SHARE 1
=20
 #define MLX5_RATE_TO_BW_SHARE(rate, divider, limit) \
@@ -65,14 +70,15 @@
=20
 struct vport_ingress {
 	struct mlx5_flow_table *acl;
-	struct mlx5_flow_handle *allow_rule;
+	struct mlx5_flow_handle *allow_untagged_rule;
 	struct {
-		struct mlx5_flow_group *allow_spoofchk_only_grp;
+		DECLARE_BITMAP(acl_vlan_8021q_bitmap, VLAN_N_VID);
 		struct mlx5_flow_group *allow_untagged_spoofchk_grp;
-		struct mlx5_flow_group *allow_untagged_only_grp;
+		struct mlx5_flow_group *allow_tagged_spoofchk_grp;
 		struct mlx5_flow_group *drop_grp;
 		struct mlx5_flow_handle *drop_rule;
 		struct mlx5_fc *drop_counter;
+		struct list_head allowed_vlans_rules;
 	} legacy;
 	struct {
 		struct mlx5_flow_group *metadata_grp;
@@ -83,11 +89,15 @@ struct vport_ingress {
=20
 struct vport_egress {
 	struct mlx5_flow_table *acl;
+	struct mlx5_flow_group *allow_untagged_grp;
 	struct mlx5_flow_group *allowed_vlans_grp;
 	struct mlx5_flow_group *drop_grp;
-	struct mlx5_flow_handle  *allowed_vlan;
+	struct mlx5_flow_handle  *allowed_vst_vlan;
 	struct {
+		DECLARE_BITMAP(acl_vlan_8021q_bitmap, VLAN_N_VID);
 		struct mlx5_flow_handle *drop_rule;
+		struct list_head allowed_vlans_rules;
+		struct mlx5_flow_handle *allow_untagged_rule;
 		struct mlx5_fc *drop_counter;
 	} legacy;
 };
@@ -221,6 +231,11 @@ enum {
 	MLX5_ESWITCH_VPORT_MATCH_METADATA =3D BIT(0),
 };
=20
+enum mlx5_acl_flow_direction {
+	MLX5_ACL_EGRESS,
+	MLX5_ACL_INGRESS,
+};
+
 struct mlx5_eswitch {
 	struct mlx5_core_dev    *dev;
 	struct mlx5_nb          nb;
@@ -292,6 +307,12 @@ int mlx5_eswitch_set_vepa(struct mlx5_eswitch *esw, u8=
 setting);
 int mlx5_eswitch_get_vepa(struct mlx5_eswitch *esw, u8 *setting);
 int mlx5_eswitch_get_vport_config(struct mlx5_eswitch *esw,
 				  u16 vport, struct ifla_vf_info *ivi);
+int mlx5_eswitch_add_vport_trunk_vlan(struct mlx5_eswitch *esw,
+				      u16 vport, u16 vlanid,
+				      enum mlx5_acl_flow_direction dir);
+int mlx5_eswitch_del_vport_trunk_vlan(struct mlx5_eswitch *esw,
+				      u16 vport, u16 vlanid,
+				      enum mlx5_acl_flow_direction dir);
 int mlx5_eswitch_get_vport_stats(struct mlx5_eswitch *esw,
 				 u16 vport,
 				 struct ifla_vf_stats *vf_stats);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/d=
rivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 138a9d328b91..633cda35dd1f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -1782,15 +1782,15 @@ static int esw_vport_ingress_prio_tag_config(struct=
 mlx5_eswitch *esw,
 		flow_act.modify_hdr =3D vport->ingress.offloads.modify_metadata;
 	}
=20
-	vport->ingress.allow_rule =3D
+	vport->ingress.allow_untagged_rule =3D
 		mlx5_add_flow_rules(vport->ingress.acl, spec,
 				    &flow_act, NULL, 0);
-	if (IS_ERR(vport->ingress.allow_rule)) {
-		err =3D PTR_ERR(vport->ingress.allow_rule);
+	if (IS_ERR(vport->ingress.allow_untagged_rule)) {
+		err =3D PTR_ERR(vport->ingress.allow_untagged_rule);
 		esw_warn(esw->dev,
 			 "vport[%d] configure ingress untagged allow rule, err(%d)\n",
 			 vport->vport, err);
-		vport->ingress.allow_rule =3D NULL;
+		vport->ingress.allow_untagged_rule =3D NULL;
 		goto out;
 	}
=20
--=20
2.21.0

