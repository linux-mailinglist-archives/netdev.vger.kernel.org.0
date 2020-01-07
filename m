Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29C38132F26
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 20:14:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728784AbgAGTOm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 14:14:42 -0500
Received: from mail-vi1eur05on2055.outbound.protection.outlook.com ([40.107.21.55]:6105
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728806AbgAGTOl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Jan 2020 14:14:41 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MapqW7CyIlvRZU4e1RN7mWyM3tbb+nZcrG6PBLTwNyHKGNGQ7SwgpkAq4oXrzc06OXANjlcOp5lOrCvzMFIRvap4YDQug+NYl+LRgvm8lIboUO47rCPH5CZX7OJXgwaIkIgP6YFKGaXQt7orOOAcxezyS7MbSsukogVj7yFeJx/pdQnjQSfI+WqhRCTnH0AwVgFiullKrG8KbWwZ/1kBwqtSwn+MRDd2jlaecp04zDEuDC0whDZLhqVuX6xMKjwGYuff7/a3WFMjnt+Yx9DIduGJ97vlQtqkAMY0nQCZjpcp4em1xL/3AjAsPiDRB8dASGvmxvjYmjq3c7XzSTXq4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DolsK9eB3G6xWUF1qYvoMnTT7t3FpOq0yUuFLxxOOMA=;
 b=GhFnTh89v9ZPqoqspAEXmT4dTAo0dKAoxK0B/mDG9rG3yOQtyauek5wttAQ+AkNqnVlyCo15FjFEdhTkeD0cAgTPBGbdl3betmQEtIdVB+7n3XfLNyLWSsQSQ+I1y/PMrCwVyBFJvd+1maFGKX5kdDjEaPJlhCtmjlqQ0JpwbWZGDsmfvl0OXLe/khjWVLgAucTDe0SOsXBOtQ3moGEkPFNTZ15/e7AfgJ1UY+HUXvaz7nDWOG97xzmbLaQk/caJ5Pxrsz62FqU2JLwcJu2NTY7p+3CS7g5EcA2Y2PVTg9MRt9g6heuct/tM9RZeiuxQTbtI0Nw6r6DDM9Dh8M1fkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DolsK9eB3G6xWUF1qYvoMnTT7t3FpOq0yUuFLxxOOMA=;
 b=DVjoPEr0FYJK4G8yBObeSX8Wr0Jvf/U0rsZzVIZHeNWyfy8l+Q00sADZFPnHd3Ja3illEGiDVQla7CCj4pk/WOmAteUObRlsad4+Qvu56ttmQFO6Mfe6tf0CgRaq4q2KXSFprmG++y54wr9jvVkqQO0LSWb6KIcuyc3EgHmS0UM=
Received: from AM6PR05MB5094.eurprd05.prod.outlook.com (20.177.34.93) by
 AM6PR05MB5411.eurprd05.prod.outlook.com (20.177.189.90) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2602.11; Tue, 7 Jan 2020 19:14:27 +0000
Received: from AM6PR05MB5094.eurprd05.prod.outlook.com
 ([fe80::d9f3:f3b8:86b2:a40a]) by AM6PR05MB5094.eurprd05.prod.outlook.com
 ([fe80::d9f3:f3b8:86b2:a40a%7]) with mapi id 15.20.2602.015; Tue, 7 Jan 2020
 19:14:27 +0000
Received: from smtp.office365.com (209.116.155.178) by BYAPR06CA0068.namprd06.prod.outlook.com (2603:10b6:a03:14b::45) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2581.12 via Frontend Transport; Tue, 7 Jan 2020 19:14:25 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alex Vesker <valex@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 13/13] net/mlx5: DR, Create multiple destination action
 from dr_create_fte
Thread-Topic: [net-next 13/13] net/mlx5: DR, Create multiple destination
 action from dr_create_fte
Thread-Index: AQHVxY6t/QfdqUAmoESHd2bg67aCtA==
Date:   Tue, 7 Jan 2020 19:14:27 +0000
Message-ID: <20200107191335.12272-14-saeedm@mellanox.com>
References: <20200107191335.12272-1-saeedm@mellanox.com>
In-Reply-To: <20200107191335.12272-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.24.1
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR06CA0068.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::45) To AM6PR05MB5094.eurprd05.prod.outlook.com
 (2603:10a6:20b:9::29)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: b63c0b21-dcc5-47ca-7c4f-08d793a5d036
x-ms-traffictypediagnostic: AM6PR05MB5411:|AM6PR05MB5411:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM6PR05MB5411582A87708DDCBCD89303BE3F0@AM6PR05MB5411.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2958;
x-forefront-prvs: 027578BB13
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(366004)(136003)(346002)(39860400002)(376002)(199004)(189003)(81166006)(52116002)(6916009)(8936002)(81156014)(8676002)(26005)(86362001)(36756003)(316002)(5660300002)(107886003)(6506007)(4326008)(478600001)(1076003)(16526019)(956004)(2616005)(2906002)(66446008)(64756008)(66556008)(66476007)(71200400001)(66946007)(6486002)(6512007)(54906003)(186003)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR05MB5411;H:AM6PR05MB5094.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8yDRAJh6cq2eBsNiMZgr/8AoVMlC/oKu5d6lgEzYcNKFh2ktzlK426whiFPCfoeXzJUnXFtiNsN1126Ae1OW7U6BXEAXnW78ka5hg2qvNiLOoVXI8mNOwfyd1pwEurAMJhG/pep5Ep8CaKI3GRuLrkEYWDOQAEcOEfrKSlkW2NDn5SYndjDqiDUzJJ2CwYF6agpkDDhMOFQ3XE5mg+TLS0sZjzlNdf/d2uhzUWua1xa+beKWj7+mXigr7rCumNB3Di49WLVoqxYoKL+ytLVydmx0rUpkPMKnQRdcYTWYYHrPROtK3Vkl48AGIZupUgucH+PWzfkbaQlw35w5bLHGzA4uw5+93cfu1M9qntfqyv5ftktehfO+CdPolfsm5PrWXCVKAEQkY8PUhbGXlkYneA0wNuljlkp6xFicE2Y0ueYbRlQr1eK+A/0NwcMJ1mpbG1BldM07lMgnuEbV5+oseTBVQMIXbQ+IrpGlHA/Ylr9BtMZKOYGYOV2/U0LFEl6GyOoISeESam+b37Csi9CTsUvgHhImYJKAPEpFTNaaPYE=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b63c0b21-dcc5-47ca-7c4f-08d793a5d036
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jan 2020 19:14:27.1531
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iROgoplhEXCrHVHHviBS3iE4QoRK1uEFTT6h70f/6ghLr6qxycawpSRKgN1xEn2Y/TkIQ+Y56BXrdIGqDlcpww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB5411
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alex Vesker <valex@mellanox.com>

Until now it was possible to pass a packet to a single destination such
as vport or flow table. With the new support if multiple vports or multiple
tables are provided as destinations, fs_dr will create a multiple
destination table action, this action should replace other destination
actions provided to mlx5dr_create_rule.
Each vport destination can be provided with a reformat actions which
will be done before forwarding the packet to the vport.

Signed-off-by: Alex Vesker <valex@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../mellanox/mlx5/core/steering/fs_dr.c       | 88 +++++++++++++++----
 1 file changed, 72 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c b/dri=
vers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c
index e51262ec77bb..b43275cde8bf 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c
@@ -206,6 +206,12 @@ static struct mlx5dr_action *create_action_push_vlan(s=
truct mlx5dr_domain *domai
 	return mlx5dr_action_create_push_vlan(domain, htonl(vlan_hdr));
 }
=20
+static bool contain_vport_reformat_action(struct mlx5_flow_rule *dst)
+{
+	return dst->dest_attr.type =3D=3D MLX5_FLOW_DESTINATION_TYPE_VPORT &&
+		dst->dest_attr.vport.flags & MLX5_FLOW_DEST_VPORT_REFORMAT_ID;
+}
+
 #define MLX5_FLOW_CONTEXT_ACTION_MAX  20
 static int mlx5_cmd_dr_create_fte(struct mlx5_flow_root_namespace *ns,
 				  struct mlx5_flow_table *ft,
@@ -213,7 +219,7 @@ static int mlx5_cmd_dr_create_fte(struct mlx5_flow_root=
_namespace *ns,
 				  struct fs_fte *fte)
 {
 	struct mlx5dr_domain *domain =3D ns->fs_dr_domain.dr_domain;
-	struct mlx5dr_action *term_action =3D NULL;
+	struct mlx5dr_action_dest *term_actions;
 	struct mlx5dr_match_parameters params;
 	struct mlx5_core_dev *dev =3D ns->dev;
 	struct mlx5dr_action **fs_dr_actions;
@@ -223,6 +229,7 @@ static int mlx5_cmd_dr_create_fte(struct mlx5_flow_root=
_namespace *ns,
 	struct mlx5dr_rule *rule;
 	struct mlx5_flow_rule *dst;
 	int fs_dr_num_actions =3D 0;
+	int num_term_actions =3D 0;
 	int num_actions =3D 0;
 	size_t match_sz;
 	int err =3D 0;
@@ -233,18 +240,38 @@ static int mlx5_cmd_dr_create_fte(struct mlx5_flow_ro=
ot_namespace *ns,
=20
 	actions =3D kcalloc(MLX5_FLOW_CONTEXT_ACTION_MAX, sizeof(*actions),
 			  GFP_KERNEL);
-	if (!actions)
-		return -ENOMEM;
+	if (!actions) {
+		err =3D -ENOMEM;
+		goto out_err;
+	}
=20
 	fs_dr_actions =3D kcalloc(MLX5_FLOW_CONTEXT_ACTION_MAX,
 				sizeof(*fs_dr_actions), GFP_KERNEL);
 	if (!fs_dr_actions) {
-		kfree(actions);
-		return -ENOMEM;
+		err =3D -ENOMEM;
+		goto free_actions_alloc;
+	}
+
+	term_actions =3D kcalloc(MLX5_FLOW_CONTEXT_ACTION_MAX,
+			       sizeof(*term_actions), GFP_KERNEL);
+	if (!term_actions) {
+		err =3D -ENOMEM;
+		goto free_fs_dr_actions_alloc;
 	}
=20
 	match_sz =3D sizeof(fte->val);
=20
+	/* Drop reformat action bit if destination vport set with reformat */
+	if (fte->action.action & MLX5_FLOW_CONTEXT_ACTION_FWD_DEST) {
+		list_for_each_entry(dst, &fte->node.children, node.list) {
+			if (!contain_vport_reformat_action(dst))
+				continue;
+
+			fte->action.action &=3D ~MLX5_FLOW_CONTEXT_ACTION_PACKET_REFORMAT;
+			break;
+		}
+	}
+
 	/* The order of the actions are must to be keep, only the following
 	 * order is supported by SW steering:
 	 * TX: push vlan -> modify header -> encap
@@ -335,7 +362,7 @@ static int mlx5_cmd_dr_create_fte(struct mlx5_flow_root=
_namespace *ns,
 			goto free_actions;
 		}
 		fs_dr_actions[fs_dr_num_actions++] =3D tmp_action;
-		term_action =3D tmp_action;
+		term_actions[num_term_actions++].dest =3D tmp_action;
 	}
=20
 	if (fte->flow_context.flow_tag) {
@@ -354,7 +381,8 @@ static int mlx5_cmd_dr_create_fte(struct mlx5_flow_root=
_namespace *ns,
 			enum mlx5_flow_destination_type type =3D dst->dest_attr.type;
 			u32 id;
=20
-			if (num_actions =3D=3D MLX5_FLOW_CONTEXT_ACTION_MAX) {
+			if (num_actions =3D=3D MLX5_FLOW_CONTEXT_ACTION_MAX ||
+			    num_term_actions >=3D MLX5_FLOW_CONTEXT_ACTION_MAX) {
 				err =3D -ENOSPC;
 				goto free_actions;
 			}
@@ -379,7 +407,7 @@ static int mlx5_cmd_dr_create_fte(struct mlx5_flow_root=
_namespace *ns,
 					goto free_actions;
 				}
 				fs_dr_actions[fs_dr_num_actions++] =3D tmp_action;
-				term_action =3D tmp_action;
+				term_actions[num_term_actions++].dest =3D tmp_action;
 				break;
 			case MLX5_FLOW_DESTINATION_TYPE_VPORT:
 				tmp_action =3D create_vport_action(domain, dst);
@@ -388,7 +416,14 @@ static int mlx5_cmd_dr_create_fte(struct mlx5_flow_roo=
t_namespace *ns,
 					goto free_actions;
 				}
 				fs_dr_actions[fs_dr_num_actions++] =3D tmp_action;
-				term_action =3D tmp_action;
+				term_actions[num_term_actions].dest =3D tmp_action;
+
+				if (dst->dest_attr.vport.flags &
+				    MLX5_FLOW_DEST_VPORT_REFORMAT_ID)
+					term_actions[num_term_actions].reformat =3D
+						dst->dest_attr.vport.pkt_reformat->action.dr_action;
+
+				num_term_actions++;
 				break;
 			default:
 				err =3D -EOPNOTSUPP;
@@ -399,9 +434,22 @@ static int mlx5_cmd_dr_create_fte(struct mlx5_flow_roo=
t_namespace *ns,
=20
 	params.match_sz =3D match_sz;
 	params.match_buf =3D (u64 *)fte->val;
-
-	if (term_action)
-		actions[num_actions++] =3D term_action;
+	if (num_term_actions =3D=3D 1) {
+		if (term_actions->reformat)
+			actions[num_actions++] =3D term_actions->reformat;
+
+		actions[num_actions++] =3D term_actions->dest;
+	} else if (num_term_actions > 1) {
+		tmp_action =3D mlx5dr_action_create_mult_dest_tbl(domain,
+								term_actions,
+								num_term_actions);
+		if (!tmp_action) {
+			err =3D -EOPNOTSUPP;
+			goto free_actions;
+		}
+		fs_dr_actions[fs_dr_num_actions++] =3D tmp_action;
+		actions[num_actions++] =3D tmp_action;
+	}
=20
 	rule =3D mlx5dr_rule_create(group->fs_dr_matcher.dr_matcher,
 				  &params,
@@ -412,7 +460,9 @@ static int mlx5_cmd_dr_create_fte(struct mlx5_flow_root=
_namespace *ns,
 		goto free_actions;
 	}
=20
+	kfree(term_actions);
 	kfree(actions);
+
 	fte->fs_dr_rule.dr_rule =3D rule;
 	fte->fs_dr_rule.num_actions =3D fs_dr_num_actions;
 	fte->fs_dr_rule.dr_actions =3D fs_dr_actions;
@@ -420,13 +470,18 @@ static int mlx5_cmd_dr_create_fte(struct mlx5_flow_ro=
ot_namespace *ns,
 	return 0;
=20
 free_actions:
-	for (i =3D 0; i < fs_dr_num_actions; i++)
+	/* Free in reverse order to handle action dependencies */
+	for (i =3D fs_dr_num_actions - 1; i >=3D 0; i--)
 		if (!IS_ERR_OR_NULL(fs_dr_actions[i]))
 			mlx5dr_action_destroy(fs_dr_actions[i]);
=20
-	mlx5_core_err(dev, "Failed to create dr rule err(%d)\n", err);
-	kfree(actions);
+	kfree(term_actions);
+free_fs_dr_actions_alloc:
 	kfree(fs_dr_actions);
+free_actions_alloc:
+	kfree(actions);
+out_err:
+	mlx5_core_err(dev, "Failed to create dr rule err(%d)\n", err);
 	return err;
 }
=20
@@ -533,7 +588,8 @@ static int mlx5_cmd_dr_delete_fte(struct mlx5_flow_root=
_namespace *ns,
 	if (err)
 		return err;
=20
-	for (i =3D 0; i < rule->num_actions; i++)
+	/* Free in reverse order to handle action dependencies */
+	for (i =3D rule->num_actions - 1; i >=3D 0; i--)
 		if (!IS_ERR_OR_NULL(rule->dr_actions[i]))
 			mlx5dr_action_destroy(rule->dr_actions[i]);
=20
--=20
2.24.1

