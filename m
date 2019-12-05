Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 742CF114883
	for <lists+netdev@lfdr.de>; Thu,  5 Dec 2019 22:12:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730356AbfLEVMi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Dec 2019 16:12:38 -0500
Received: from mail-eopbgr00063.outbound.protection.outlook.com ([40.107.0.63]:34533
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730353AbfLEVMh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Dec 2019 16:12:37 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UXLvbSlV+6bGrig5J2JiEMGPJab9KLGncD2KqT3gyd4SP41T/3CmWomeOSqHel+wYrYGTu9TAcSumuqHZNSorSfQvsWzPgyUK0sTbkjWbGUrMIDVbOttPIALBZ84jq0FznOMkXOZjuFI62moVzPnWK2mdzcyBptQoQaiEqhtx9d4sGqyb87vArFHyWb/JJJkl8/Zpu3ocqrXAXjRHVcjrFlgw37pABUfQ3AHLYeQeYvmkIxmFZraqPIsbeGHRwkiFPt+cXgP8OCgG3c6tB4g2+i855e0wUJE+HPCVTU9Wmm5lxi58hpTdbAgeWPVd8i73kv583tiFs9tM4YLCmhJNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y5jN62HwJVYzyJq1j/HCoANYA8llNohZbZaV7E3oy/4=;
 b=I3E7rppUcwaOOLXFYIITBz9CPnRatngmCick1GBKqrV+kn5yg6SWC80mEuaMw3tzqju7ajE9vKNwXsBOGyCuM7J60LOcHbbaSYe3HKSeguNcB51y9mxCB6pXj5J3h4Cifx/GTiwDgdvTqwMPfiKeIyQwAaW+MczajFjnzi2Dl2bBkbWrsomoAUmiG2KUS//9esrHCzAhlYlHqP5E4lW9rwV7Kgcg9OFzJoP6c9wxWGUTrTCFgvSgijCkvvy2RZdUFPIrQeB5Dg/mWKHF6ZahO7+Te7SRzlG5uANiBq/m9L19U/J9nUivSHdnQT3GzYw1sDtroEqmR18eJ6lLJvR4eA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y5jN62HwJVYzyJq1j/HCoANYA8llNohZbZaV7E3oy/4=;
 b=ldyDXS6x+NByBX2RmCAQCSdqcpIedyRaOID2r4phkDydxjZ7u1AsPiQpgrunWS0x2iPzmbbaUob4vcxHHfbj4hMI1ZafxChQWBEbjJgn+9s2Mi6BaQ0m5OB0azzWHO96Mz5Jhz1HvDmwJ85UUg6RuFWxlinuKgbhPF5gtfJtwoc=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB3326.eurprd05.prod.outlook.com (10.175.244.14) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2516.13; Thu, 5 Dec 2019 21:12:20 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::c872:cf66:4a5c:c881]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::c872:cf66:4a5c:c881%5]) with mapi id 15.20.2495.014; Thu, 5 Dec 2019
 21:12:20 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Parav Pandit <parav@mellanox.com>,
        Eli Britstein <elibr@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 8/8] net/mlx5e: E-switch, Fix Ingress ACL groups in switchdev
 mode for prio tag
Thread-Topic: [net 8/8] net/mlx5e: E-switch, Fix Ingress ACL groups in
 switchdev mode for prio tag
Thread-Index: AQHVq7CuxsKhJYfi4EmGaXvMaBGJmQ==
Date:   Thu, 5 Dec 2019 21:12:19 +0000
Message-ID: <20191205211052.14584-9-saeedm@mellanox.com>
References: <20191205211052.14584-1-saeedm@mellanox.com>
In-Reply-To: <20191205211052.14584-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR08CA0018.namprd08.prod.outlook.com
 (2603:10b6:a03:100::31) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 32bfe9c1-6308-4ff1-7316-08d779c7d061
x-ms-traffictypediagnostic: VI1PR05MB3326:|VI1PR05MB3326:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB332630821FD7BDE61AF4BC8ABE5C0@VI1PR05MB3326.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:227;
x-forefront-prvs: 02426D11FE
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(376002)(366004)(136003)(346002)(396003)(199004)(189003)(107886003)(478600001)(25786009)(102836004)(6512007)(86362001)(6486002)(14454004)(6506007)(54906003)(2616005)(316002)(64756008)(11346002)(26005)(186003)(5660300002)(14444005)(76176011)(8676002)(4326008)(50226002)(305945005)(99286004)(66446008)(81166006)(52116002)(81156014)(1076003)(71190400001)(71200400001)(6916009)(8936002)(2906002)(66476007)(66946007)(66556008)(36756003);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB3326;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: e7FUqH+hma5VEdEXWM3AX/Ynq8Zsa4M9Y+E3aQUv6zjg/AZ06z1QzFxQqKmKQhHut4dsmk0aegbAW5kTBf15bwT35zqEfDpyzXFbCvGaqb3VG53UWlR6yAPn0QiBFC61oN8bAwJBP4lHvbKkVNShO27W7gQNRSs32B9Q8nVugmTBwOvf2oBx/TfjYl5bQZRBVd7zQeMVjadQYS5uMeOSL4B5ljU5HBqMTCeYQoFNmXdC6jsFueJvpIolMszn9HHcjuafUdg0DoyNoad2KfgLle166J8cIPKQwiigeUaqNdjGq4UVcPbu2+0CxgY5i48ajOosRI1Yhn8rabGjiDveLhnGHRHC6WpjeJPuhzwOzh+Rm43FGnroiSNJi4bMvY17k6I8+2sl+IlL6q6ucQpuUEI/P67safm8nLu23aSBAv4Cme2fQprYTybQHR7HLjlh
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 32bfe9c1-6308-4ff1-7316-08d779c7d061
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Dec 2019 21:12:19.9913
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: indHNld7kKyXPaP9rMkFkuTu8hTpBAu3W2tBewwK/DBmmu7jVVmDOqVrGGWexHXCytA4FaDx0aYET8x50DlZpw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB3326
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Parav Pandit <parav@mellanox.com>

In cited commit, when prio tag mode is enabled, FTE creation fails
due to missing group with valid match criteria.

Hence,
(a) create prio tag group metadata_prio_tag_grp when prio tag is
enabled with match criteria for vlan push FTE.
(b) Rename metadata_grp to metadata_allmatch_grp to reflect its purpose.

Also when priority tag is enabled, delete metadata settings after
deleting ingress rules, which are using it.

Tide up rest of the ingress config code for unnecessary labels.

Fixes: 10652f39943e ("net/mlx5: Refactor ingress acl configuration")
Signed-off-by: Parav Pandit <parav@mellanox.com>
Reviewed-by: Eli Britstein <elibr@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/eswitch.h |   9 +-
 .../mellanox/mlx5/core/eswitch_offloads.c     | 122 ++++++++++++------
 2 files changed, 93 insertions(+), 38 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/ne=
t/ethernet/mellanox/mlx5/core/eswitch.h
index 962888a7c3c9..ffcff3ba3701 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -81,7 +81,14 @@ struct vport_ingress {
 		struct mlx5_fc *drop_counter;
 	} legacy;
 	struct {
-		struct mlx5_flow_group *metadata_grp;
+		/* Optional group to add an FTE to do internal priority
+		 * tagging on ingress packets.
+		 */
+		struct mlx5_flow_group *metadata_prio_tag_grp;
+		/* Group to add default match-all FTE entry to tag ingress
+		 * packet with metadata.
+		 */
+		struct mlx5_flow_group *metadata_allmatch_grp;
 		struct mlx5_modify_hdr *modify_metadata;
 		struct mlx5_flow_handle *modify_metadata_rule;
 	} offloads;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/d=
rivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 8ba59a21a163..243a5440867e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -88,6 +88,14 @@ u16 mlx5_eswitch_get_prio_range(struct mlx5_eswitch *esw=
)
 	return 1;
 }
=20
+static bool
+esw_check_ingress_prio_tag_enabled(const struct mlx5_eswitch *esw,
+				   const struct mlx5_vport *vport)
+{
+	return (MLX5_CAP_GEN(esw->dev, prio_tag_required) &&
+		mlx5_eswitch_is_vf_vport(esw, vport->vport));
+}
+
 static void
 mlx5_eswitch_set_rule_source_port(struct mlx5_eswitch *esw,
 				  struct mlx5_flow_spec *spec,
@@ -1760,12 +1768,9 @@ static int esw_vport_ingress_prio_tag_config(struct =
mlx5_eswitch *esw,
 	 * required, allow
 	 * Unmatched traffic is allowed by default
 	 */
-
 	spec =3D kvzalloc(sizeof(*spec), GFP_KERNEL);
-	if (!spec) {
-		err =3D -ENOMEM;
-		goto out_no_mem;
-	}
+	if (!spec)
+		return -ENOMEM;
=20
 	/* Untagged packets - push prio tag VLAN, allow */
 	MLX5_SET_TO_ONES(fte_match_param, spec->match_criteria, outer_headers.cvl=
an_tag);
@@ -1791,14 +1796,9 @@ static int esw_vport_ingress_prio_tag_config(struct =
mlx5_eswitch *esw,
 			 "vport[%d] configure ingress untagged allow rule, err(%d)\n",
 			 vport->vport, err);
 		vport->ingress.allow_rule =3D NULL;
-		goto out;
 	}
=20
-out:
 	kvfree(spec);
-out_no_mem:
-	if (err)
-		esw_vport_cleanup_ingress_rules(esw, vport);
 	return err;
 }
=20
@@ -1836,13 +1836,9 @@ static int esw_vport_add_ingress_acl_modify_metadata=
(struct mlx5_eswitch *esw,
 		esw_warn(esw->dev,
 			 "failed to add setting metadata rule for vport %d ingress acl, err(%d)=
\n",
 			 vport->vport, err);
+		mlx5_modify_header_dealloc(esw->dev, vport->ingress.offloads.modify_meta=
data);
 		vport->ingress.offloads.modify_metadata_rule =3D NULL;
-		goto out;
 	}
-
-out:
-	if (err)
-		mlx5_modify_header_dealloc(esw->dev, vport->ingress.offloads.modify_meta=
data);
 	return err;
 }
=20
@@ -1862,50 +1858,103 @@ static int esw_vport_create_ingress_acl_group(stru=
ct mlx5_eswitch *esw,
 {
 	int inlen =3D MLX5_ST_SZ_BYTES(create_flow_group_in);
 	struct mlx5_flow_group *g;
+	void *match_criteria;
 	u32 *flow_group_in;
+	u32 flow_index =3D 0;
 	int ret =3D 0;
=20
 	flow_group_in =3D kvzalloc(inlen, GFP_KERNEL);
 	if (!flow_group_in)
 		return -ENOMEM;
=20
-	memset(flow_group_in, 0, inlen);
-	MLX5_SET(create_flow_group_in, flow_group_in, start_flow_index, 0);
-	MLX5_SET(create_flow_group_in, flow_group_in, end_flow_index, 0);
+	if (esw_check_ingress_prio_tag_enabled(esw, vport)) {
+		/* This group is to hold FTE to match untagged packets when prio_tag
+		 * is enabled.
+		 */
+		memset(flow_group_in, 0, inlen);
=20
-	g =3D mlx5_create_flow_group(vport->ingress.acl, flow_group_in);
-	if (IS_ERR(g)) {
-		ret =3D PTR_ERR(g);
-		esw_warn(esw->dev,
-			 "Failed to create vport[%d] ingress metadata group, err(%d)\n",
-			 vport->vport, ret);
-		goto grp_err;
+		match_criteria =3D MLX5_ADDR_OF(create_flow_group_in,
+					      flow_group_in, match_criteria);
+		MLX5_SET(create_flow_group_in, flow_group_in,
+			 match_criteria_enable, MLX5_MATCH_OUTER_HEADERS);
+		MLX5_SET_TO_ONES(fte_match_param, match_criteria, outer_headers.cvlan_ta=
g);
+		MLX5_SET(create_flow_group_in, flow_group_in, start_flow_index, flow_ind=
ex);
+		MLX5_SET(create_flow_group_in, flow_group_in, end_flow_index, flow_index=
);
+
+		g =3D mlx5_create_flow_group(vport->ingress.acl, flow_group_in);
+		if (IS_ERR(g)) {
+			ret =3D PTR_ERR(g);
+			esw_warn(esw->dev, "vport[%d] ingress create untagged flow group, err(%=
d)\n",
+				 vport->vport, ret);
+			goto prio_tag_err;
+		}
+		vport->ingress.offloads.metadata_prio_tag_grp =3D g;
+		flow_index++;
+	}
+
+	if (mlx5_eswitch_vport_match_metadata_enabled(esw)) {
+		/* This group holds an FTE with no matches for add metadata for
+		 * tagged packets, if prio-tag is enabled (as a fallthrough),
+		 * or all traffic in case prio-tag is disabled.
+		 */
+		memset(flow_group_in, 0, inlen);
+		MLX5_SET(create_flow_group_in, flow_group_in, start_flow_index, flow_ind=
ex);
+		MLX5_SET(create_flow_group_in, flow_group_in, end_flow_index, flow_index=
);
+
+		g =3D mlx5_create_flow_group(vport->ingress.acl, flow_group_in);
+		if (IS_ERR(g)) {
+			ret =3D PTR_ERR(g);
+			esw_warn(esw->dev, "vport[%d] ingress create drop flow group, err(%d)\n=
",
+				 vport->vport, ret);
+			goto metadata_err;
+		}
+		vport->ingress.offloads.metadata_allmatch_grp =3D g;
+	}
+
+	kvfree(flow_group_in);
+	return 0;
+
+metadata_err:
+	if (!IS_ERR_OR_NULL(vport->ingress.offloads.metadata_prio_tag_grp)) {
+		mlx5_destroy_flow_group(vport->ingress.offloads.metadata_prio_tag_grp);
+		vport->ingress.offloads.metadata_prio_tag_grp =3D NULL;
 	}
-	vport->ingress.offloads.metadata_grp =3D g;
-grp_err:
+prio_tag_err:
 	kvfree(flow_group_in);
 	return ret;
 }
=20
 static void esw_vport_destroy_ingress_acl_group(struct mlx5_vport *vport)
 {
-	if (vport->ingress.offloads.metadata_grp) {
-		mlx5_destroy_flow_group(vport->ingress.offloads.metadata_grp);
-		vport->ingress.offloads.metadata_grp =3D NULL;
+	if (vport->ingress.offloads.metadata_allmatch_grp) {
+		mlx5_destroy_flow_group(vport->ingress.offloads.metadata_allmatch_grp);
+		vport->ingress.offloads.metadata_allmatch_grp =3D NULL;
+	}
+
+	if (vport->ingress.offloads.metadata_prio_tag_grp) {
+		mlx5_destroy_flow_group(vport->ingress.offloads.metadata_prio_tag_grp);
+		vport->ingress.offloads.metadata_prio_tag_grp =3D NULL;
 	}
 }
=20
 static int esw_vport_ingress_config(struct mlx5_eswitch *esw,
 				    struct mlx5_vport *vport)
 {
+	int num_ftes =3D 0;
 	int err;
=20
 	if (!mlx5_eswitch_vport_match_metadata_enabled(esw) &&
-	    !MLX5_CAP_GEN(esw->dev, prio_tag_required))
+	    !esw_check_ingress_prio_tag_enabled(esw, vport))
 		return 0;
=20
 	esw_vport_cleanup_ingress_rules(esw, vport);
-	err =3D esw_vport_create_ingress_acl_table(esw, vport, 1);
+
+	if (mlx5_eswitch_vport_match_metadata_enabled(esw))
+		num_ftes++;
+	if (esw_check_ingress_prio_tag_enabled(esw, vport))
+		num_ftes++;
+
+	err =3D esw_vport_create_ingress_acl_table(esw, vport, num_ftes);
 	if (err) {
 		esw_warn(esw->dev,
 			 "failed to enable ingress acl (%d) on vport[%d]\n",
@@ -1926,8 +1975,7 @@ static int esw_vport_ingress_config(struct mlx5_eswit=
ch *esw,
 			goto metadata_err;
 	}
=20
-	if (MLX5_CAP_GEN(esw->dev, prio_tag_required) &&
-	    mlx5_eswitch_is_vf_vport(esw, vport->vport)) {
+	if (esw_check_ingress_prio_tag_enabled(esw, vport)) {
 		err =3D esw_vport_ingress_prio_tag_config(esw, vport);
 		if (err)
 			goto prio_tag_err;
@@ -1937,7 +1985,6 @@ static int esw_vport_ingress_config(struct mlx5_eswit=
ch *esw,
 prio_tag_err:
 	esw_vport_del_ingress_acl_modify_metadata(esw, vport);
 metadata_err:
-	esw_vport_cleanup_ingress_rules(esw, vport);
 	esw_vport_destroy_ingress_acl_group(vport);
 group_err:
 	esw_vport_destroy_ingress_acl_table(vport);
@@ -2008,8 +2055,9 @@ esw_vport_create_offloads_acl_tables(struct mlx5_eswi=
tch *esw,
 	if (mlx5_eswitch_is_vf_vport(esw, vport->vport)) {
 		err =3D esw_vport_egress_config(esw, vport);
 		if (err) {
-			esw_vport_del_ingress_acl_modify_metadata(esw, vport);
 			esw_vport_cleanup_ingress_rules(esw, vport);
+			esw_vport_del_ingress_acl_modify_metadata(esw, vport);
+			esw_vport_destroy_ingress_acl_group(vport);
 			esw_vport_destroy_ingress_acl_table(vport);
 		}
 	}
@@ -2021,8 +2069,8 @@ esw_vport_destroy_offloads_acl_tables(struct mlx5_esw=
itch *esw,
 				      struct mlx5_vport *vport)
 {
 	esw_vport_disable_egress_acl(esw, vport);
-	esw_vport_del_ingress_acl_modify_metadata(esw, vport);
 	esw_vport_cleanup_ingress_rules(esw, vport);
+	esw_vport_del_ingress_acl_modify_metadata(esw, vport);
 	esw_vport_destroy_ingress_acl_group(vport);
 	esw_vport_destroy_ingress_acl_table(vport);
 }
--=20
2.21.0

