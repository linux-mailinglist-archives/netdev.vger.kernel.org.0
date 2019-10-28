Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8472EE7CF1
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 00:35:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731694AbfJ1XfN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 19:35:13 -0400
Received: from mail-eopbgr60074.outbound.protection.outlook.com ([40.107.6.74]:40107
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731638AbfJ1XfM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Oct 2019 19:35:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aOXonHJq+OSY/DVm08PXJ7kFqlZgVf7Meko9D8qOiY0Uy0OZeqCHEgJG+IxBjeTl2hmWvooND3ZmJN7YFpm5YwkjfQ8Vh+98aBiGYN5R7FNFep1E44OOUCQzKnvebn1J4gYeeRRJzcE9R7t+SJ+jFSpvzeMTHW2yEa0jSRVRypyepY8a0tKLF/5Flg7CAMfaUcvKS9N+ss/IHNDuPViiiKc3Istx3aQ7pMGdljudMlLI+EBelI0jtzuGUjbWLEplHj7kcJUkppeYYPj83Q0+0CykIk25RIOQ+kAtR3OYhrq1vh2xqsyMn0OJoG1l5+GT3/CBv6UPxFLGbe2H5U3VXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RE9wnTWK8HB3zpJlzCGkOmQl3nai1xyjxMvWZsirQ7c=;
 b=gisUFHXWOkAISz0Xxbx8VzRLhQInzFMUbfDmdFdJ+zuNoYTJLrH5JhLKuIcvFQ3/ggVu0No/YpVCQXI6+nxy/NsVZoWxWvXs/NrTxudqDW2Er5QIfT4msNefxPNLxX8bb6B4NLYMJP/DiVLhpfg+YzEaqxOMrNaHRQQtRL4xCsLK4SPMT0ShN6bplV8/fZIJNLW8TCjoisO9ovwL0Ubt7vP6vbQGciipmLSACRJVob1d5YdHDPQ8HFnKpjxNE55lwVaAaPxJqICPniBYBlBFfc/T26hWHiQxlN2uHlLsgbwPqsby1r0MDbUcUNANFvIz6xZTIMWjLb2kOg3uZ6q96w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RE9wnTWK8HB3zpJlzCGkOmQl3nai1xyjxMvWZsirQ7c=;
 b=HhnuhOsAgL19fj8SvBXMLyP9mnbzVAXnUj6wdp5dOFqHHZhgX97j+/2QVoaGzC9U6MLrvCSIsrejbKijbVj9fYd8rLr7luxY7HH1IY8EQ/vtZ93MCDGfa2OsfurJc6gfdtjQiJjwweeRJ1YNY9dGlREtYjUqSH/AMILJX9y4yeM=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB6448.eurprd05.prod.outlook.com (20.179.28.86) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2387.22; Mon, 28 Oct 2019 23:35:03 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e%5]) with mapi id 15.20.2387.027; Mon, 28 Oct 2019
 23:35:03 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Parav Pandit <parav@mellanox.com>,
        Vu Pham <vuhuong@mellanox.com>
Subject: [PATCH mlx5-next 04/18] net/mlx5: E-switch, Introduce and use vlan
 rule config helper
Thread-Topic: [PATCH mlx5-next 04/18] net/mlx5: E-switch, Introduce and use
 vlan rule config helper
Thread-Index: AQHVjehSQ7HZevXSM0uz1W2EcIjkRQ==
Date:   Mon, 28 Oct 2019 23:35:03 +0000
Message-ID: <20191028233440.5564-5-saeedm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: 233d24e1-2dcb-4878-3752-08d75bff74bb
x-ms-traffictypediagnostic: VI1PR05MB6448:|VI1PR05MB6448:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB6448989380CC2BADF4146531BE660@VI1PR05MB6448.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4125;
x-forefront-prvs: 0204F0BDE2
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(376002)(366004)(346002)(396003)(39860400002)(189003)(199004)(3846002)(305945005)(8936002)(450100002)(316002)(478600001)(50226002)(86362001)(99286004)(71200400001)(81156014)(8676002)(81166006)(107886003)(71190400001)(186003)(66446008)(386003)(102836004)(6636002)(6506007)(66476007)(66946007)(256004)(36756003)(52116002)(476003)(2616005)(11346002)(486006)(446003)(5024004)(64756008)(6512007)(76176011)(6116002)(4326008)(26005)(7736002)(5660300002)(66066001)(14454004)(2906002)(110136005)(6436002)(6486002)(54906003)(1076003)(25786009)(66556008);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB6448;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: MgszVSfwHjZWwVVdV5gS2NM7jThbPEiD7/hdpzkl8Qus6A0Z2mrkGYGuOcQlnFJc9aa4mKzvepf58GvxuQ+OBu2K6Tgt+AFpF7O52rQ/za6QMkfAKqG24HV+vLk1Ave0kfXy+DU/ymeG+kYXIbPAjaV95CgETeM6h1vLCm3KyMkC5tcbpsSC5QINYFQP/Urd9JVDNeKkQXXaD7XoMNKSLcLP98Df+xjinfqWtX3UPg3jtSEFuvd9rv4+qefWtfyXOw8Mk43cFcr0c1vWY3dObnQZ/KFsOfcy3CD1YKVg31hORgZVosILZ0DA38ipX5V/C62ZHzwryacfBa34n3fNME/MV6lPucr2Ig9O0Mnjd8YNZ5tY0X90ICQ6556tn/zL1oksGD/TPi8jtYZI5MzgBDk909roNGm+pFyadF67bJ8eS8hQO0sJMOWiNswY9oga
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 233d24e1-2dcb-4878-3752-08d75bff74bb
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Oct 2019 23:35:03.2487
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NkH34nTgXafQm/ntAQCYaUegMg2HoCaSYb3lsg/7RJN9J2NXGsJbRl+ZtzXnyPFHszyCOW0ZnZ4h9x5+SvFAkg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6448
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Parav Pandit <parav@mellanox.com>

Between legacy mode and switchdev mode, only two fields are changed,
vlan_tag and flow action.
Hence to avoid duplicte code between two modes, introduce and and use
helper function to configure allowed VLAN rule.

While at it, get rid of duplicate debug message.

Signed-off-by: Parav Pandit <parav@mellanox.com>
Reviewed-by: Vu Pham <vuhuong@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/eswitch.c | 68 ++++++++++++-------
 .../net/ethernet/mellanox/mlx5/core/eswitch.h |  4 ++
 .../mellanox/mlx5/core/eswitch_offloads.c     | 54 +++------------
 3 files changed, 58 insertions(+), 68 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/ne=
t/ethernet/mellanox/mlx5/core/eswitch.c
index 4c18ac1299ae..ef7d84a1dbc2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -1328,6 +1328,43 @@ static int esw_vport_ingress_config(struct mlx5_eswi=
tch *esw,
 	return err;
 }
=20
+int mlx5_esw_create_vport_egress_acl_vlan(struct mlx5_eswitch *esw,
+					  struct mlx5_vport *vport,
+					  u16 vlan_id, u32 flow_action)
+{
+	struct mlx5_flow_act flow_act =3D {};
+	struct mlx5_flow_spec *spec;
+	int err =3D 0;
+
+	if (vport->egress.allowed_vlan)
+		return -EEXIST;
+
+	spec =3D kvzalloc(sizeof(*spec), GFP_KERNEL);
+	if (!spec)
+		return -ENOMEM;
+
+	MLX5_SET_TO_ONES(fte_match_param, spec->match_criteria, outer_headers.cvl=
an_tag);
+	MLX5_SET_TO_ONES(fte_match_param, spec->match_value, outer_headers.cvlan_=
tag);
+	MLX5_SET_TO_ONES(fte_match_param, spec->match_criteria, outer_headers.fir=
st_vid);
+	MLX5_SET(fte_match_param, spec->match_value, outer_headers.first_vid, vla=
n_id);
+
+	spec->match_criteria_enable =3D MLX5_MATCH_OUTER_HEADERS;
+	flow_act.action =3D flow_action;
+	vport->egress.allowed_vlan =3D
+		mlx5_add_flow_rules(vport->egress.acl, spec,
+				    &flow_act, NULL, 0);
+	if (IS_ERR(vport->egress.allowed_vlan)) {
+		err =3D PTR_ERR(vport->egress.allowed_vlan);
+		esw_warn(esw->dev,
+			 "vport[%d] configure egress vlan rule failed, err(%d)\n",
+			 vport->vport, err);
+		vport->egress.allowed_vlan =3D NULL;
+	}
+
+	kvfree(spec);
+	return err;
+}
+
 static int esw_vport_egress_config(struct mlx5_eswitch *esw,
 				   struct mlx5_vport *vport)
 {
@@ -1358,34 +1395,17 @@ static int esw_vport_egress_config(struct mlx5_eswi=
tch *esw,
 		  "vport[%d] configure egress rules, vlan(%d) qos(%d)\n",
 		  vport->vport, vport->info.vlan, vport->info.qos);
=20
-	spec =3D kvzalloc(sizeof(*spec), GFP_KERNEL);
-	if (!spec) {
-		err =3D -ENOMEM;
-		goto out;
-	}
-
 	/* Allowed vlan rule */
-	MLX5_SET_TO_ONES(fte_match_param, spec->match_criteria, outer_headers.cvl=
an_tag);
-	MLX5_SET_TO_ONES(fte_match_param, spec->match_value, outer_headers.cvlan_=
tag);
-	MLX5_SET_TO_ONES(fte_match_param, spec->match_criteria, outer_headers.fir=
st_vid);
-	MLX5_SET(fte_match_param, spec->match_value, outer_headers.first_vid, vpo=
rt->info.vlan);
+	err =3D mlx5_esw_create_vport_egress_acl_vlan(esw, vport, vport->info.vla=
n,
+						    MLX5_FLOW_CONTEXT_ACTION_ALLOW);
+	if (err)
+		return err;
=20
-	spec->match_criteria_enable =3D MLX5_MATCH_OUTER_HEADERS;
-	flow_act.action =3D MLX5_FLOW_CONTEXT_ACTION_ALLOW;
-	vport->egress.allowed_vlan =3D
-		mlx5_add_flow_rules(vport->egress.acl, spec,
-				    &flow_act, NULL, 0);
-	if (IS_ERR(vport->egress.allowed_vlan)) {
-		err =3D PTR_ERR(vport->egress.allowed_vlan);
-		esw_warn(esw->dev,
-			 "vport[%d] configure egress allowed vlan rule failed, err(%d)\n",
-			 vport->vport, err);
-		vport->egress.allowed_vlan =3D NULL;
+	/* Drop others rule (star rule) */
+	spec =3D kvzalloc(sizeof(*spec), GFP_KERNEL);
+	if (!spec)
 		goto out;
-	}
=20
-	/* Drop others rule (star rule) */
-	memset(spec, 0, sizeof(*spec));
 	flow_act.action =3D MLX5_FLOW_CONTEXT_ACTION_DROP;
=20
 	/* Attach egress drop flow counter */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/ne=
t/ethernet/mellanox/mlx5/core/eswitch.h
index 6bd6f5895244..1824b0ad7c9f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -421,6 +421,10 @@ int mlx5_eswitch_del_vlan_action(struct mlx5_eswitch *=
esw,
 int __mlx5_eswitch_set_vport_vlan(struct mlx5_eswitch *esw,
 				  u16 vport, u16 vlan, u8 qos, u8 set_flags);
=20
+int mlx5_esw_create_vport_egress_acl_vlan(struct mlx5_eswitch *esw,
+					  struct mlx5_vport *vport,
+					  u16 vlan_id, u32 flow_action);
+
 static inline bool mlx5_eswitch_vlan_actions_supported(struct mlx5_core_de=
v *dev,
 						       u8 vlan_depth)
 {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/d=
rivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 48adec168a7c..f0c7abd09120 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -1857,48 +1857,6 @@ void esw_vport_del_ingress_acl_modify_metadata(struc=
t mlx5_eswitch *esw,
 	}
 }
=20
-static int esw_vport_egress_prio_tag_config(struct mlx5_eswitch *esw,
-					    struct mlx5_vport *vport)
-{
-	struct mlx5_flow_act flow_act =3D {0};
-	struct mlx5_flow_spec *spec;
-	int err =3D 0;
-
-	/* For prio tag mode, there is only 1 FTEs:
-	 * 1) prio tag packets - pop the prio tag VLAN, allow
-	 * Unmatched traffic is allowed by default
-	 */
-	esw_debug(esw->dev,
-		  "vport[%d] configure prio tag egress rules\n", vport->vport);
-
-	spec =3D kvzalloc(sizeof(*spec), GFP_KERNEL);
-	if (!spec)
-		return -ENOMEM;
-
-	/* prio tag vlan rule - pop it so VF receives untagged packets */
-	MLX5_SET_TO_ONES(fte_match_param, spec->match_criteria, outer_headers.cvl=
an_tag);
-	MLX5_SET_TO_ONES(fte_match_param, spec->match_value, outer_headers.cvlan_=
tag);
-	MLX5_SET_TO_ONES(fte_match_param, spec->match_criteria, outer_headers.fir=
st_vid);
-	MLX5_SET(fte_match_param, spec->match_value, outer_headers.first_vid, 0);
-
-	spec->match_criteria_enable =3D MLX5_MATCH_OUTER_HEADERS;
-	flow_act.action =3D MLX5_FLOW_CONTEXT_ACTION_VLAN_POP |
-			  MLX5_FLOW_CONTEXT_ACTION_ALLOW;
-	vport->egress.allowed_vlan =3D
-		mlx5_add_flow_rules(vport->egress.acl, spec,
-				    &flow_act, NULL, 0);
-	if (IS_ERR(vport->egress.allowed_vlan)) {
-		err =3D PTR_ERR(vport->egress.allowed_vlan);
-		esw_warn(esw->dev,
-			 "vport[%d] configure egress pop prio tag vlan rule failed, err(%d)\n",
-			 vport->vport, err);
-		vport->egress.allowed_vlan =3D NULL;
-	}
-
-	kvfree(spec);
-	return err;
-}
-
 static int esw_vport_ingress_config(struct mlx5_eswitch *esw,
 				    struct mlx5_vport *vport)
 {
@@ -1954,9 +1912,17 @@ static int esw_vport_egress_config(struct mlx5_eswit=
ch *esw,
 	if (err)
 		return err;
=20
-	esw_debug(esw->dev, "vport(%d) configure egress rules\n", vport->vport);
+	/* For prio tag mode, there is only 1 FTEs:
+	 * 1) prio tag packets - pop the prio tag VLAN, allow
+	 * Unmatched traffic is allowed by default
+	 */
+	esw_debug(esw->dev,
+		  "vport[%d] configure prio tag egress rules\n", vport->vport);
=20
-	err =3D esw_vport_egress_prio_tag_config(esw, vport);
+	/* prio tag vlan rule - pop it so VF receives untagged packets */
+	err =3D mlx5_esw_create_vport_egress_acl_vlan(esw, vport, 0,
+						    MLX5_FLOW_CONTEXT_ACTION_VLAN_POP |
+						    MLX5_FLOW_CONTEXT_ACTION_ALLOW);
 	if (err)
 		esw_vport_disable_egress_acl(esw, vport);
=20
--=20
2.21.0

