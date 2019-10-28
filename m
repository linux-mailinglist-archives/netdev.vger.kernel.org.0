Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43E08E7CF7
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 00:35:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731816AbfJ1XfU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 19:35:20 -0400
Received: from mail-eopbgr60074.outbound.protection.outlook.com ([40.107.6.74]:40107
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729755AbfJ1XfT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Oct 2019 19:35:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UTKrf3GxbQp3hB0EauryI9AH8ElBKYJpJxStnfYtXJrVD9le67naDRKKk+MpGA+FAZ7/xjyxsqFJxHJW3UJrGZQBFggb6InJs37f+nIqVe3seEhIJUugastuZlYT1Hm5e3uGQDbBil5iju4ytIO+xNtCIR5mBIl6AxfTkHzi4aP3pG+sOBAqmz3tTpWkWqgu9jNLoKtTSDwvFKUXDW3ZDJha4XARfBdfOC2QVEe8UxSVpCsK151Jbq5vKs6eCO7zKp0K3kyvsrYqQj33J5vxx+e+5rNY/NLityzkvTS7HSNxGGLyd2Exq3aW9Lc1dhOesTS8jNGxmktb4BHfHSYqoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/NBcckuBezbKF1rTN7bapOgt2gWPEDfnA7B6XZNB01w=;
 b=QgTSJ/3bIRFfduoxa5Oxozba0AG4rzEu74BHgfMAx3/A9R5Vjo53xngcdZEovwtDNNzroybs8clD6YVTMDHwCgnJj/p1ewK3qB8JbM6ZyoMccbO5B92J5AAME4QPTdqcy9T9qaX18d7mnzlS9klUGAYrjU904sHSE/Mi27+8C4tHKgunU4ZhE5d7o1IUkKkVSMcHGbeVJ28+pHnf6jUi3+YjwOvUn8agBVjuOam2FK9KDjBksEUTb5acWV8rsYi7QP432/uJlCfGYmEAMgXSXBLd8Hr1X05F3u+79ImXMf6T9u3Vs9GMgrlyB4LzteNK4/BmNz836o/sk9KPWSyMIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/NBcckuBezbKF1rTN7bapOgt2gWPEDfnA7B6XZNB01w=;
 b=IOeKms+/xtHl0TfhvCwYmXdVoLeVQQsWtptcmZW/P9i3Kmck1UaIWcahLU+z41WHfUc08qYBmmn575mZDggd7gcra21HYYh+BVNuf3/AuqNylPYw6F+vYhJtn9tUOgm4y12kIkHyubftCiCyqb0XWSmUp9FbhxOCmx6iT2Mt32Q=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB6448.eurprd05.prod.outlook.com (20.179.28.86) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2387.22; Mon, 28 Oct 2019 23:35:10 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e%5]) with mapi id 15.20.2387.027; Mon, 28 Oct 2019
 23:35:10 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Parav Pandit <parav@mellanox.com>,
        Vu Pham <vuhuong@mellanox.com>
Subject: [PATCH mlx5-next 07/18] net/mlx5: Move metdata fields under offloads
 structure
Thread-Topic: [PATCH mlx5-next 07/18] net/mlx5: Move metdata fields under
 offloads structure
Thread-Index: AQHVjehWD2B5QtBz+kSz02RwW3xFKA==
Date:   Mon, 28 Oct 2019 23:35:10 +0000
Message-ID: <20191028233440.5564-8-saeedm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: f25c1a22-5410-4bf5-e1b9-08d75bff78dd
x-ms-traffictypediagnostic: VI1PR05MB6448:|VI1PR05MB6448:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB6448ABC67049B11BE8855DCDBE660@VI1PR05MB6448.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:820;
x-forefront-prvs: 0204F0BDE2
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(376002)(366004)(346002)(396003)(39860400002)(189003)(199004)(3846002)(305945005)(8936002)(450100002)(316002)(478600001)(50226002)(86362001)(99286004)(71200400001)(81156014)(8676002)(81166006)(107886003)(71190400001)(186003)(66446008)(386003)(102836004)(6636002)(6506007)(66476007)(66946007)(256004)(36756003)(52116002)(476003)(2616005)(11346002)(486006)(446003)(64756008)(6512007)(76176011)(6116002)(4326008)(26005)(7736002)(5660300002)(66066001)(14454004)(2906002)(110136005)(6436002)(6486002)(54906003)(1076003)(25786009)(66556008);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB6448;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: uMyTYOGvq/xW8r/bkOeNP8Gp+UWyc1QlbA737MrWL44r6jgt0pRyTKKKSY8HJvZeykUsgl+BfU1hI53DHwyH79PsRGK9VU/LLIdR1cZvPINhKSIAg2B3WkX8GNvbU+rVnwkuTradnpMmGLEAkmkDK6a5zSnTfpNYq2K03XRZOCYj2lVuzH1GJhRUxqQqPCtD0j3kb3pju/ngNri0N92os00+clrEXmfyd8kGIpOx1jnjznWnLvGIr4npUwSzOwgbTcrsKSHw4qvk2RraJ3bL8/HNGScqZdSUqTfuBwF5l/wVa8CUEcxmQHe7Yylzb39GZVIebzET5/J1QWuRaPj1tZCN2/muFGyqtR8lT/scgno6wRagI7zMmp032EAntNPd1I01yaTN7WIovPyduasaIUn6uOPD6BYGLz6teBlcGQgwS5ahHtoQElGgIiNxOWyO
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f25c1a22-5410-4bf5-e1b9-08d75bff78dd
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Oct 2019 23:35:10.0388
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LTKsYYdDi3it5AieiJjyZIcdqvqGlqOhT78uW3gzPAdF9Wep1EAQRA62kl30aO7ld4ozAERk9Ws0xeBuwwFSPQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6448
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Parav Pandit <parav@mellanox.com>

Metadata fields are offload mode specific.
To improve code readability, move metadata under offloads structure.

Signed-off-by: Parav Pandit <parav@mellanox.com>
Reviewed-by: Vu Pham <vuhuong@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/eswitch.h |  6 ++--
 .../mellanox/mlx5/core/eswitch_offloads.c     | 33 ++++++++++---------
 2 files changed, 21 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/ne=
t/ethernet/mellanox/mlx5/core/eswitch.h
index a41d4aad9d28..5f862992b9c8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -69,11 +69,13 @@ struct vport_ingress {
 	struct mlx5_flow_group *allow_spoofchk_only_grp;
 	struct mlx5_flow_group *allow_untagged_only_grp;
 	struct mlx5_flow_group *drop_grp;
-	struct mlx5_modify_hdr   *modify_metadata;
-	struct mlx5_flow_handle  *modify_metadata_rule;
 	struct mlx5_flow_handle  *allow_rule;
 	struct mlx5_flow_handle  *drop_rule;
 	struct mlx5_fc           *drop_counter;
+	struct {
+		struct mlx5_modify_hdr *modify_metadata;
+		struct mlx5_flow_handle *modify_metadata_rule;
+	} offloads;
 };
=20
 struct vport_egress {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/d=
rivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index f0c7abd09120..874e70e3792a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -1778,9 +1778,9 @@ static int esw_vport_ingress_prio_tag_config(struct m=
lx5_eswitch *esw,
 	flow_act.vlan[0].vid =3D 0;
 	flow_act.vlan[0].prio =3D 0;
=20
-	if (vport->ingress.modify_metadata_rule) {
+	if (vport->ingress.offloads.modify_metadata_rule) {
 		flow_act.action |=3D MLX5_FLOW_CONTEXT_ACTION_MOD_HDR;
-		flow_act.modify_hdr =3D vport->ingress.modify_metadata;
+		flow_act.modify_hdr =3D vport->ingress.offloads.modify_metadata;
 	}
=20
 	vport->ingress.allow_rule =3D
@@ -1816,11 +1816,11 @@ static int esw_vport_add_ingress_acl_modify_metadat=
a(struct mlx5_eswitch *esw,
 	MLX5_SET(set_action_in, action, data,
 		 mlx5_eswitch_get_vport_metadata_for_match(esw, vport->vport));
=20
-	vport->ingress.modify_metadata =3D
+	vport->ingress.offloads.modify_metadata =3D
 		mlx5_modify_header_alloc(esw->dev, MLX5_FLOW_NAMESPACE_ESW_INGRESS,
 					 1, action);
-	if (IS_ERR(vport->ingress.modify_metadata)) {
-		err =3D PTR_ERR(vport->ingress.modify_metadata);
+	if (IS_ERR(vport->ingress.offloads.modify_metadata)) {
+		err =3D PTR_ERR(vport->ingress.offloads.modify_metadata);
 		esw_warn(esw->dev,
 			 "failed to alloc modify header for vport %d ingress acl (%d)\n",
 			 vport->vport, err);
@@ -1828,32 +1828,33 @@ static int esw_vport_add_ingress_acl_modify_metadat=
a(struct mlx5_eswitch *esw,
 	}
=20
 	flow_act.action =3D MLX5_FLOW_CONTEXT_ACTION_MOD_HDR | MLX5_FLOW_CONTEXT_=
ACTION_ALLOW;
-	flow_act.modify_hdr =3D vport->ingress.modify_metadata;
-	vport->ingress.modify_metadata_rule =3D mlx5_add_flow_rules(vport->ingres=
s.acl,
-								  &spec, &flow_act, NULL, 0);
-	if (IS_ERR(vport->ingress.modify_metadata_rule)) {
-		err =3D PTR_ERR(vport->ingress.modify_metadata_rule);
+	flow_act.modify_hdr =3D vport->ingress.offloads.modify_metadata;
+	vport->ingress.offloads.modify_metadata_rule =3D
+				mlx5_add_flow_rules(vport->ingress.acl,
+						    &spec, &flow_act, NULL, 0);
+	if (IS_ERR(vport->ingress.offloads.modify_metadata_rule)) {
+		err =3D PTR_ERR(vport->ingress.offloads.modify_metadata_rule);
 		esw_warn(esw->dev,
 			 "failed to add setting metadata rule for vport %d ingress acl, err(%d)=
\n",
 			 vport->vport, err);
-		vport->ingress.modify_metadata_rule =3D NULL;
+		vport->ingress.offloads.modify_metadata_rule =3D NULL;
 		goto out;
 	}
=20
 out:
 	if (err)
-		mlx5_modify_header_dealloc(esw->dev, vport->ingress.modify_metadata);
+		mlx5_modify_header_dealloc(esw->dev, vport->ingress.offloads.modify_meta=
data);
 	return err;
 }
=20
 void esw_vport_del_ingress_acl_modify_metadata(struct mlx5_eswitch *esw,
 					       struct mlx5_vport *vport)
 {
-	if (vport->ingress.modify_metadata_rule) {
-		mlx5_del_flow_rules(vport->ingress.modify_metadata_rule);
-		mlx5_modify_header_dealloc(esw->dev, vport->ingress.modify_metadata);
+	if (vport->ingress.offloads.modify_metadata_rule) {
+		mlx5_del_flow_rules(vport->ingress.offloads.modify_metadata_rule);
+		mlx5_modify_header_dealloc(esw->dev, vport->ingress.offloads.modify_meta=
data);
=20
-		vport->ingress.modify_metadata_rule =3D NULL;
+		vport->ingress.offloads.modify_metadata_rule =3D NULL;
 	}
 }
=20
--=20
2.21.0

