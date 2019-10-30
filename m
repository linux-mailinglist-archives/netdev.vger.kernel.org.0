Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6ED8EA3E4
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 20:15:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726701AbfJ3TPD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 15:15:03 -0400
Received: from mail-eopbgr20060.outbound.protection.outlook.com ([40.107.2.60]:50339
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726646AbfJ3TPC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Oct 2019 15:15:02 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=akI44gZR678tO/dLPuCX9esH6p9ECxBi6t+FoHWbMsayw3kgMx4qYTzgob6I/pM68NF14Oy/7DAXaRsAKHWUsAtAvneprxEnSA7lv5o5OVNJ1GtKLA7pL62K4El1xJp5H5/dMuuYDuWJ+AM4RLF2pGLTRqw2VAkUtMrie7FkqRoCa/gXWE55pAOJp9c4tWq7O6lIQRfQvLAQnl5OUgvds35ZxD1ejMI4ZDLvHpvpwt7Q+EGjd9tQMCx7+bK2ImRMZ6kI0gIPecx7CBnW70KczBIHDiZjiYkJSC5PWItHU4rt31nVmCvN4dcHdxSWj5nMWR+cFP/ZnFFUo+ilqu/x5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9OE59+jV6DaMSqfEteXgeN6J7ElIcJdjaf8jxtiNFPw=;
 b=EZk511PN5ukfj/qZB3fMrStES74P0bBLBD9AdbtBow1ZET91c3ucClbw++EzI3Mf3Sf/vLFRiEIvjUXVka0wxtsFhKKmpm2NXZUPL5ehiCJLVVPqFPb+fS9TYYDYn4PvIsfv8PZi+AFkLEEahLLnROt5FzgE5/xpnUoqbUvmjLI9DqTiDn56ROnwdhHUFFnofbci+LVpOxDztHliRTGSIN/ytOXyb93mZTNZK+kA3aH3mjuPXXvJ2d94uA6xXkg4YOFqyhKcR/3PordrKGtcUuvoVf78uB9/H3ZFcGyNqdJjJ249it6k1770dnSSzpnetgwDJhlOLXL3CyhBVm32mw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9OE59+jV6DaMSqfEteXgeN6J7ElIcJdjaf8jxtiNFPw=;
 b=iKCIjAwV6Rap49eonU7Tp3fI/YTO+NccV4jZ7Hw2SKs5QdhPL22TJb2bpy6RbGuH1NLJ52XALh6l2b+Ez2pPyYeTPPRkKlupKPHup+oh/Rckn0JdwLMIOsbeFElTq/6flYgiuFlE4IHVOuGuzuAqPRAdw2iDNjEA1CKYmS4aCv4=
Received: from AM4PR05MB3313.eurprd05.prod.outlook.com (10.171.189.29) by
 AM4PR05MB3412.eurprd05.prod.outlook.com (10.171.188.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2408.17; Wed, 30 Oct 2019 19:14:49 +0000
Received: from AM4PR05MB3313.eurprd05.prod.outlook.com
 ([fe80::59bd:e9d7:eaab:b2cc]) by AM4PR05MB3313.eurprd05.prod.outlook.com
 ([fe80::59bd:e9d7:eaab:b2cc%4]) with mapi id 15.20.2408.016; Wed, 30 Oct 2019
 19:14:49 +0000
From:   Ariel Levkovich <lariel@mellanox.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Saeed Mahameed <saeedm@mellanox.com>,
        Ariel Levkovich <lariel@mellanox.com>
Subject: [PATCH 3/3] net/mlx5: Add SRIOV VGT+ support
Thread-Topic: [PATCH 3/3] net/mlx5: Add SRIOV VGT+ support
Thread-Index: AQHVj1ZMrtZVQSWsTkmJYaynNMmpoQ==
Date:   Wed, 30 Oct 2019 19:14:49 +0000
Message-ID: <1572462854-26188-4-git-send-email-lariel@mellanox.com>
References: <1572462854-26188-1-git-send-email-lariel@mellanox.com>
In-Reply-To: <1572462854-26188-1-git-send-email-lariel@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [94.188.199.18]
x-mailer: git-send-email 1.8.3.1
x-clientproxiedby: AM0PR04CA0016.eurprd04.prod.outlook.com
 (2603:10a6:208:122::29) To AM4PR05MB3313.eurprd05.prod.outlook.com
 (2603:10a6:205:9::29)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=lariel@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 98d9889f-6504-44c2-3d31-08d75d6d6ede
x-ms-traffictypediagnostic: AM4PR05MB3412:|AM4PR05MB3412:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM4PR05MB34123F8F737A5029D6242164BA600@AM4PR05MB3412.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 02065A9E77
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(346002)(136003)(396003)(376002)(39860400002)(189003)(199004)(476003)(486006)(66946007)(66446008)(14444005)(5024004)(66476007)(2616005)(6116002)(11346002)(3846002)(2906002)(71190400001)(66556008)(71200400001)(446003)(5660300002)(30864003)(4720700003)(64756008)(256004)(8676002)(66066001)(86362001)(2501003)(81156014)(8936002)(478600001)(76176011)(102836004)(6486002)(26005)(50226002)(6506007)(386003)(6436002)(52116002)(7736002)(5640700003)(186003)(1730700003)(81166006)(305945005)(25786009)(54906003)(6916009)(316002)(14454004)(4326008)(107886003)(99286004)(2351001)(6512007)(36756003)(579004)(569006);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR05MB3412;H:AM4PR05MB3313.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: eqOYrXnN4YfSLODKLMgHFSKB2zrK+puakmivtvdTX1PDbOlk/U0hB+L3WpyM0atBI8w+PUwYq7qe8vJuDk4M6ILogCq9iC7B4eDC0nvSoP7ELNCPZJc6zTH6G+RdL/Oz6ROl1dKil0+jWBiMPjvVhww3WeY3MO6I+IBCOWoGSVYgOT5VjGWvYj9q7k7tTsx3OXEWCLFsr2igptW4Tfwt/ZuZJW//H1r/zQZI66diBo+UPd0ztGih1VgLdrpTKrTPvaxLKUj2GA3E0F03+hG94GzAgkjxonLxN0ucYKnY7Bw7qM+CcayRvbh7p7iJHBocuy7Zy545o7hztSzlZl8yUyv3GM2t43DyWabPRNqs5JIXFCYnXXCfMr3eokm8LOPtGphr0ZgzqY0FhXQevbp2zRJ85Dc5nveTqljtk54y1W8BlXhqG0Rtn4NOnrd4/Bm6
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 98d9889f-6504-44c2-3d31-08d75d6d6ede
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Oct 2019 19:14:49.1370
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uAsPgR5T6sXwXcF5+0Yfgok74rNyi4PrNM2s7TCIIxaGKi1HdGdp8dqrFYJvecUpQ5iFluH8Y2YrQTRwjBvqjQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR05MB3412
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implementing the VGT+ feature via acl tables.
The acl tables will hold the actual needed rules which is only the
intersection of the requested vlan-ids list and the allowed vlan-ids
list from the administrator.

Issue: 989268
Signed-off-by: Ariel Levkovich <lariel@mellanox.com>

Change-Id: I5cfe9441db2e09f5150e420eb6cedbc78ce3cfd7
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |  30 ++
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c  | 600 ++++++++++++++++-=
----
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h  |  27 +-
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c |   8 +-
 4 files changed, 533 insertions(+), 132 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/ne=
t/ethernet/mellanox/mlx5/core/en_main.c
index 7569287..9253bfd 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -4061,6 +4061,34 @@ static int mlx5e_set_vf_vlan(struct net_device *dev,=
 int vf, u16 vlan, u8 qos,
 					   vlan, qos);
 }
=20
+static int mlx5e_add_vf_vlan_trunk_range(struct net_device *dev, int vf,
+					 u16 start_vid, u16 end_vid,
+					 __be16 vlan_proto)
+{
+	struct mlx5e_priv *priv =3D netdev_priv(dev);
+	struct mlx5_core_dev *mdev =3D priv->mdev;
+
+	if (vlan_proto !=3D htons(ETH_P_8021Q))
+		return -EPROTONOSUPPORT;
+
+	return mlx5_eswitch_add_vport_trunk_range(mdev->priv.eswitch, vf + 1,
+						  start_vid, end_vid);
+}
+
+static int mlx5e_del_vf_vlan_trunk_range(struct net_device *dev, int vf,
+					 u16 start_vid, u16 end_vid,
+					 __be16 vlan_proto)
+{
+	struct mlx5e_priv *priv =3D netdev_priv(dev);
+	struct mlx5_core_dev *mdev =3D priv->mdev;
+
+	if (vlan_proto !=3D htons(ETH_P_8021Q))
+		return -EPROTONOSUPPORT;
+
+	return mlx5_eswitch_del_vport_trunk_range(mdev->priv.eswitch, vf + 1,
+						  start_vid, end_vid);
+}
+
 static int mlx5e_set_vf_spoofchk(struct net_device *dev, int vf, bool sett=
ing)
 {
 	struct mlx5e_priv *priv =3D netdev_priv(dev);
@@ -4589,6 +4617,8 @@ static int mlx5e_bridge_setlink(struct net_device *de=
v, struct nlmsghdr *nlh,
 	/* SRIOV E-Switch NDOs */
 	.ndo_set_vf_mac          =3D mlx5e_set_vf_mac,
 	.ndo_set_vf_vlan         =3D mlx5e_set_vf_vlan,
+	.ndo_add_vf_vlan_trunk_range =3D mlx5e_add_vf_vlan_trunk_range,
+	.ndo_del_vf_vlan_trunk_range =3D mlx5e_del_vf_vlan_trunk_range,
 	.ndo_set_vf_spoofchk     =3D mlx5e_set_vf_spoofchk,
 	.ndo_set_vf_trust        =3D mlx5e_set_vf_trust,
 	.ndo_set_vf_rate         =3D mlx5e_set_vf_rate,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/ne=
t/ethernet/mellanox/mlx5/core/eswitch.c
index 7baade9..911421e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -58,6 +58,11 @@ struct vport_addr {
 	bool mc_promisc;
 };
=20
+struct mlx5_acl_vlan {
+	struct mlx5_flow_handle	*acl_vlan_rule;
+	struct list_head	list;
+};
+
 static void esw_destroy_legacy_fdb_table(struct mlx5_eswitch *esw);
 static void esw_cleanup_vepa_rules(struct mlx5_eswitch *esw);
=20
@@ -452,6 +457,7 @@ static void esw_destroy_legacy_table(struct mlx5_eswitc=
h *esw)
=20
 #define MLX5_LEGACY_SRIOV_VPORT_EVENTS (MLX5_VPORT_UC_ADDR_CHANGE | \
 					MLX5_VPORT_MC_ADDR_CHANGE | \
+					MLX5_VPORT_VLAN_CHANGE | \
 					MLX5_VPORT_PROMISC_CHANGE)
=20
 static int esw_legacy_enable(struct mlx5_eswitch *esw)
@@ -793,6 +799,94 @@ static void esw_update_vport_addr_list(struct mlx5_esw=
itch *esw,
 	kfree(mac_list);
 }
=20
+static void esw_update_acl_trunk_bitmap(struct mlx5_eswitch *esw, u32 vpor=
t_num)
+{
+	struct mlx5_vport *vport =3D &esw->vports[vport_num];
+
+	bitmap_and(vport->acl_vlan_8021q_bitmap, vport->req_vlan_bitmap,
+		   vport->info.vlan_trunk_8021q_bitmap, VLAN_N_VID);
+}
+
+static int mlx5_query_nic_vport_vlans(struct mlx5_core_dev *dev, u32 vport=
,
+				      unsigned long *vlans)
+{
+	u32 in[MLX5_ST_SZ_DW(query_nic_vport_context_in)];
+	void *nic_vport_ctx;
+	int req_list_size;
+	int out_sz;
+	void *out;
+	int err;
+	int i;
+
+	req_list_size =3D 1 << MLX5_CAP_GEN(dev, log_max_vlan_list);
+	out_sz =3D MLX5_ST_SZ_BYTES(modify_nic_vport_context_in) +
+		req_list_size * MLX5_ST_SZ_BYTES(vlan_layout);
+
+	memset(in, 0, sizeof(in));
+	out =3D kzalloc(out_sz, GFP_KERNEL);
+	if (!out)
+		return -ENOMEM;
+
+	MLX5_SET(query_nic_vport_context_in, in, opcode,
+		 MLX5_CMD_OP_QUERY_NIC_VPORT_CONTEXT);
+	MLX5_SET(query_nic_vport_context_in, in, allowed_list_type,
+		 MLX5_NVPRT_LIST_TYPE_VLAN);
+	MLX5_SET(query_nic_vport_context_in, in, vport_number, vport);
+
+	if (vport)
+		MLX5_SET(query_nic_vport_context_in, in, other_vport, 1);
+
+	err =3D mlx5_cmd_exec(dev, in, sizeof(in), out, out_sz);
+	if (err)
+		goto out;
+
+	nic_vport_ctx =3D MLX5_ADDR_OF(query_nic_vport_context_out, out,
+				     nic_vport_context);
+	req_list_size =3D MLX5_GET(nic_vport_context, nic_vport_ctx,
+				 allowed_list_size);
+
+	for (i =3D 0; i < req_list_size; i++) {
+		void *vlan_addr =3D MLX5_ADDR_OF(nic_vport_context,
+					       nic_vport_ctx,
+					       current_uc_mac_address[i]);
+		bitmap_set(vlans, MLX5_GET(vlan_layout, vlan_addr, vlan), 1);
+	}
+out:
+	kfree(out);
+	return err;
+}
+
+static int esw_vport_egress_config(struct mlx5_eswitch *esw,
+				   struct mlx5_vport *vport);
+static int esw_vport_ingress_config(struct mlx5_eswitch *esw,
+				    struct mlx5_vport *vport);
+
+/* Sync vport vlan list from vport context */
+static void esw_update_vport_vlan_list(struct mlx5_eswitch *esw, u32 vport=
_num)
+{
+	struct mlx5_vport *vport =3D &esw->vports[vport_num];
+	DECLARE_BITMAP(prev_vlans_bitmap, VLAN_N_VID);
+	int err;
+
+	bitmap_copy(prev_vlans_bitmap, vport->req_vlan_bitmap, VLAN_N_VID);
+	bitmap_zero(vport->req_vlan_bitmap, VLAN_N_VID);
+
+	if (!vport->enabled)
+		return;
+
+	err =3D mlx5_query_nic_vport_vlans(esw->dev, vport_num, vport->req_vlan_b=
itmap);
+	if (err)
+		return;
+
+	bitmap_xor(prev_vlans_bitmap, prev_vlans_bitmap, vport->req_vlan_bitmap, =
VLAN_N_VID);
+	if (!bitmap_weight(prev_vlans_bitmap, VLAN_N_VID))
+		return;
+
+	esw_update_acl_trunk_bitmap(esw, vport_num);
+	esw_vport_egress_config(esw, vport);
+	esw_vport_ingress_config(esw, vport);
+}
+
 /* Sync vport UC/MC list from vport context
  * Must be called after esw_update_vport_addr_list
  */
@@ -920,6 +1014,9 @@ static void esw_vport_change_handle_locked(struct mlx5=
_vport *vport)
 	if (vport->enabled_events & MLX5_VPORT_MC_ADDR_CHANGE)
 		esw_update_vport_addr_list(esw, vport, MLX5_NVPRT_LIST_TYPE_MC);
=20
+	if (vport->enabled_events & MLX5_VPORT_VLAN_CHANGE)
+		esw_update_vport_vlan_list(esw, vport->vport);
+
 	if (vport->enabled_events & MLX5_VPORT_PROMISC_CHANGE) {
 		esw_update_vport_rx_mode(esw, vport);
 		if (!IS_ERR_OR_NULL(vport->allmulti_rule))
@@ -950,18 +1047,20 @@ int esw_vport_enable_egress_acl(struct mlx5_eswitch =
*esw,
 				struct mlx5_vport *vport)
 {
 	int inlen =3D MLX5_ST_SZ_BYTES(create_flow_group_in);
+	struct mlx5_flow_group *untagged_grp =3D NULL;
 	struct mlx5_flow_group *vlan_grp =3D NULL;
 	struct mlx5_flow_group *drop_grp =3D NULL;
 	struct mlx5_core_dev *dev =3D esw->dev;
 	struct mlx5_flow_namespace *root_ns;
 	struct mlx5_flow_table *acl;
+	/* The egress acl table contains 3 groups:
+	 * 1)Allow tagged traffic with vlan_tag=3Dvst_vlan_id/vgt+_vlan_id
+	 * 2)Allow untagged traffic
+	 * 3)Drop all other traffic
+	 */
+	int table_size =3D VLAN_N_VID + 2;
 	void *match_criteria;
 	u32 *flow_group_in;
-	/* The egress acl table contains 2 rules:
-	 * 1)Allow traffic with vlan_tag=3Dvst_vlan_id
-	 * 2)Drop all other traffic.
-	 */
-	int table_size =3D 2;
 	int err =3D 0;
=20
 	if (!MLX5_CAP_ESW_EGRESS_ACL(dev, ft_support))
@@ -994,11 +1093,25 @@ int esw_vport_enable_egress_acl(struct mlx5_eswitch =
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
@@ -1007,9 +1120,10 @@ int esw_vport_enable_egress_acl(struct mlx5_eswitch =
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
@@ -1021,27 +1135,45 @@ int esw_vport_enable_egress_acl(struct mlx5_eswitch=
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
@@ -1053,9 +1185,11 @@ void esw_vport_disable_egress_acl(struct mlx5_eswitc=
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
@@ -1065,12 +1199,21 @@ void esw_vport_disable_egress_acl(struct mlx5_eswit=
ch *esw,
 esw_vport_create_legacy_ingress_acl_groups(struct mlx5_eswitch *esw,
 					   struct mlx5_vport *vport)
 {
+	bool need_vlan_filter =3D !!bitmap_weight(vport->info.vlan_trunk_8021q_bi=
tmap,
+						VLAN_N_VID);
 	int inlen =3D MLX5_ST_SZ_BYTES(create_flow_group_in);
+	struct mlx5_flow_group *untagged_spoof_grp =3D NULL;
+	struct mlx5_flow_table *acl =3D vport->ingress.acl;
+	struct mlx5_flow_group *tagged_spoof_grp =3D NULL;
+	struct mlx5_flow_group *drop_grp =3D NULL;
 	struct mlx5_core_dev *dev =3D esw->dev;
-	struct mlx5_flow_group *g;
 	void *match_criteria;
 	u32 *flow_group_in;
-	int err;
+	int allow_grp_sz =3D 0;
+	int err =3D 0;
+
+	if (!acl)
+		return -EINVAL;
=20
 	flow_group_in =3D kvzalloc(inlen, GFP_KERNEL);
 	if (!flow_group_in)
@@ -1079,83 +1222,68 @@ void esw_vport_disable_egress_acl(struct mlx5_eswit=
ch *esw,
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
@@ -1207,14 +1335,23 @@ void esw_vport_destroy_ingress_acl_table(struct mlx=
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
@@ -1227,18 +1364,14 @@ static void esw_vport_disable_legacy_ingress_acl(st=
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
@@ -1249,33 +1382,47 @@ static void esw_vport_disable_legacy_ingress_acl(st=
ruct mlx5_eswitch *esw,
 static int esw_vport_ingress_config(struct mlx5_eswitch *esw,
 				    struct mlx5_vport *vport)
 {
+	bool need_vlan_filter =3D !!bitmap_weight(vport->info.vlan_trunk_8021q_bi=
tmap,
+						VLAN_N_VID);
 	struct mlx5_fc *counter =3D vport->ingress.legacy.drop_counter;
 	struct mlx5_flow_destination drop_ctr_dst =3D {0};
 	struct mlx5_flow_destination *dst =3D NULL;
+	struct mlx5_acl_vlan *trunk_vlan_rule;
 	struct mlx5_flow_act flow_act =3D {0};
 	struct mlx5_flow_spec *spec;
+	bool need_acl_table;
 	int dest_num =3D 0;
+	u16 vlan_id =3D 0;
 	int err =3D 0;
 	u8 *smac_v;
=20
-	/* The ingress acl table contains 4 groups
+	/* The ingress acl table contains 3 groups
 	 * (2 active rules at the same time -
-	 *      1 allow rule from one of the first 3 groups.
-	 *      1 drop rule from the last group):
-	 * 1)Allow untagged traffic with smac=3Doriginal mac.
-	 * 2)Allow untagged traffic.
-	 * 3)Allow traffic with smac=3Doriginal mac.
-	 * 4)Drop all other traffic.
+	 *	1 allow rule from one of the first 2 groups.
+	 *	1 drop rule from the last group):
+	 * 1)Allow untagged traffic with/without smac=3Doriginal mac.
+	 * 2)Allow tagged (VLAN trunk list) traffic with/without smac=3Doriginal =
mac.
+	 * 3)Drop all other traffic.
 	 */
-	int table_size =3D 4;
+	int table_size =3D need_vlan_filter ? 8192 : 4;
=20
 	esw_vport_cleanup_ingress_rules(esw, vport);
=20
-	if (!vport->info.vlan && !vport->info.qos && !vport->info.spoofchk) {
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
 	if (!vport->ingress.acl) {
 		err =3D esw_vport_create_ingress_acl_table(esw, vport, table_size);
 		if (err) {
@@ -1300,7 +1447,10 @@ static int esw_vport_ingress_config(struct mlx5_eswi=
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
@@ -1312,20 +1462,52 @@ static int esw_vport_ingress_config(struct mlx5_esw=
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
+	    (need_vlan_filter && test_bit(0, vport->info.vlan_trunk_8021q_bitmap)=
)) {
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
+	for_each_set_bit(vlan_id, vport->acl_vlan_8021q_bitmap, VLAN_N_VID) {
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
@@ -1348,11 +1530,11 @@ static int esw_vport_ingress_config(struct mlx5_esw=
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
@@ -1365,7 +1547,7 @@ int mlx5_esw_create_vport_egress_acl_vlan(struct mlx5=
_eswitch *esw,
 	struct mlx5_flow_spec *spec;
 	int err =3D 0;
=20
-	if (vport->egress.allowed_vlan)
+	if (vport->egress.allowed_vst_vlan)
 		return -EEXIST;
=20
 	spec =3D kvzalloc(sizeof(*spec), GFP_KERNEL);
@@ -1379,15 +1561,15 @@ int mlx5_esw_create_vport_egress_acl_vlan(struct ml=
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
@@ -1397,17 +1579,22 @@ int mlx5_esw_create_vport_egress_acl_vlan(struct ml=
x5_eswitch *esw,
 static int esw_vport_egress_config(struct mlx5_eswitch *esw,
 				   struct mlx5_vport *vport)
 {
+	bool need_vlan_filter =3D !!bitmap_weight(vport->info.vlan_trunk_8021q_bi=
tmap,
+						VLAN_N_VID);
+	bool need_acl_table =3D vport->info.vlan || vport->info.qos || need_vlan_=
filter;
+	struct mlx5_acl_vlan *trunk_vlan_rule;
 	struct mlx5_fc *counter =3D vport->egress.legacy.drop_counter;
 	struct mlx5_flow_destination drop_ctr_dst =3D {0};
 	struct mlx5_flow_destination *dst =3D NULL;
 	struct mlx5_flow_act flow_act =3D {0};
 	struct mlx5_flow_spec *spec;
 	int dest_num =3D 0;
+	u16 vlan_id =3D 0;
 	int err =3D 0;
=20
 	esw_vport_cleanup_egress_rules(esw, vport);
=20
-	if (!vport->info.vlan && !vport->info.qos) {
+	if (!need_acl_table) {
 		esw_vport_disable_egress_acl(esw, vport);
 		return 0;
 	}
@@ -1424,17 +1611,67 @@ static int esw_vport_egress_config(struct mlx5_eswi=
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
+	if (need_vlan_filter && test_bit(0, vport->info.vlan_trunk_8021q_bitmap))=
 {
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
+
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
=20
+	for_each_set_bit(vlan_id, vport->acl_vlan_8021q_bitmap, VLAN_N_VID) {
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
@@ -1455,7 +1692,11 @@ static int esw_vport_egress_config(struct mlx5_eswit=
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
@@ -1787,6 +2028,12 @@ static int esw_enable_vport(struct mlx5_eswitch *esw=
, struct mlx5_vport *vport,
=20
 	esw_debug(esw->dev, "Enabling VPORT(%d)\n", vport_num);
=20
+	bitmap_zero(vport->req_vlan_bitmap, VLAN_N_VID);
+	bitmap_zero(vport->acl_vlan_8021q_bitmap, VLAN_N_VID);
+	bitmap_zero(vport->info.vlan_trunk_8021q_bitmap, VLAN_N_VID);
+	INIT_LIST_HEAD(&vport->egress.legacy.allowed_vlans_rules);
+	INIT_LIST_HEAD(&vport->ingress.legacy.allowed_vlans_rules);
+
 	/* Restore old vport configuration */
 	esw_apply_vport_conf(esw, vport);
=20
@@ -2268,6 +2515,17 @@ int mlx5_eswitch_get_vport_config(struct mlx5_eswitc=
h *esw,
 	ivi->trusted =3D evport->info.trusted;
 	ivi->min_tx_rate =3D evport->info.min_rate;
 	ivi->max_tx_rate =3D evport->info.max_rate;
+
+	if (bitmap_weight(evport->info.vlan_trunk_8021q_bitmap, VLAN_N_VID)) {
+		bitmap_copy((unsigned long *)ivi->trunk_8021q,
+			    evport->info.vlan_trunk_8021q_bitmap, VLAN_N_VID);
+		ivi->vlan_mode =3D IFLA_VF_VLAN_MODE_TRUNK;
+	} else if (ivi->vlan) {
+		ivi->vlan_mode =3D IFLA_VF_VLAN_MODE_VST;
+	} else {
+		ivi->vlan_mode =3D IFLA_VF_VLAN_MODE_VGT;
+	};
+
 	mutex_unlock(&esw->state_lock);
=20
 	return 0;
@@ -2286,6 +2544,14 @@ int __mlx5_eswitch_set_vport_vlan(struct mlx5_eswitc=
h *esw,
 	if (vlan > 4095 || qos > 7)
 		return -EINVAL;
=20
+	if (bitmap_weight(evport->info.vlan_trunk_8021q_bitmap, VLAN_N_VID)) {
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
@@ -2628,6 +2894,92 @@ static int mlx5_eswitch_query_vport_drop_stats(struc=
t mlx5_core_dev *dev,
 	return 0;
 }
=20
+static int mlx5_eswitch_update_vport_trunk(struct mlx5_eswitch *esw,
+					   struct mlx5_vport *evport,
+					   unsigned long *old_trunk)
+{
+	DECLARE_BITMAP(diff_vlan_bm, VLAN_N_VID);
+	int err =3D 0;
+
+	bitmap_xor(diff_vlan_bm, old_trunk,
+		   evport->info.vlan_trunk_8021q_bitmap, VLAN_N_VID);
+	if (!bitmap_weight(diff_vlan_bm, VLAN_N_VID))
+		return err;
+
+	esw_update_acl_trunk_bitmap(esw, evport->vport);
+	if (evport->enabled && esw->mode =3D=3D MLX5_ESWITCH_LEGACY) {
+		err =3D esw_vport_egress_config(esw, evport);
+		if (!err)
+			err =3D esw_vport_ingress_config(esw, evport);
+	}
+
+	if (err) {
+		bitmap_copy(evport->info.vlan_trunk_8021q_bitmap, old_trunk, VLAN_N_VID)=
;
+		esw_update_acl_trunk_bitmap(esw, evport->vport);
+		esw_vport_egress_config(esw, evport);
+		esw_vport_ingress_config(esw, evport);
+	}
+
+	return err;
+}
+
+int mlx5_eswitch_add_vport_trunk_range(struct mlx5_eswitch *esw,
+				       u16 vport, u16 start_vlan, u16 end_vlan)
+{
+	struct mlx5_vport *evport =3D mlx5_eswitch_get_vport(esw, vport);
+	DECLARE_BITMAP(prev_vport_bitmap, VLAN_N_VID);
+	int err =3D 0;
+
+	if (!ESW_ALLOWED(esw))
+		return -EPERM;
+
+	if (IS_ERR(evport) || end_vlan > VLAN_N_VID || start_vlan > end_vlan)
+		return -EINVAL;
+
+	mutex_lock(&esw->state_lock);
+
+	if (evport->info.vlan || evport->info.qos) {
+		err =3D -EPERM;
+		mlx5_core_warn(esw->dev,
+			       "VGT+ is not allowed when operating in VST mode vport(%d)\n",
+			       vport);
+		goto unlock;
+	}
+
+	bitmap_copy(prev_vport_bitmap, evport->info.vlan_trunk_8021q_bitmap, VLAN=
_N_VID);
+	bitmap_set(evport->info.vlan_trunk_8021q_bitmap, start_vlan,
+		   end_vlan - start_vlan + 1);
+	err =3D mlx5_eswitch_update_vport_trunk(esw, evport, prev_vport_bitmap);
+
+unlock:
+	mutex_unlock(&esw->state_lock);
+
+	return err;
+}
+
+int mlx5_eswitch_del_vport_trunk_range(struct mlx5_eswitch *esw,
+				       u16 vport, u16 start_vlan, u16 end_vlan)
+{
+	struct mlx5_vport *evport =3D mlx5_eswitch_get_vport(esw, vport);
+	DECLARE_BITMAP(prev_vport_bitmap, VLAN_N_VID);
+	int err =3D 0;
+
+	if (!ESW_ALLOWED(esw))
+		return -EPERM;
+
+	if (IS_ERR(evport) || end_vlan > VLAN_N_VID || start_vlan > end_vlan)
+		return -EINVAL;
+
+	mutex_lock(&esw->state_lock);
+	bitmap_copy(prev_vport_bitmap, evport->info.vlan_trunk_8021q_bitmap, VLAN=
_N_VID);
+	bitmap_clear(evport->info.vlan_trunk_8021q_bitmap, start_vlan,
+		     end_vlan - start_vlan + 1);
+	err =3D mlx5_eswitch_update_vport_trunk(esw, evport, prev_vport_bitmap);
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
index 920d8f5..1ba7aa3 100644
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
@@ -65,14 +70,14 @@
=20
 struct vport_ingress {
 	struct mlx5_flow_table *acl;
-	struct mlx5_flow_handle *allow_rule;
+	struct mlx5_flow_handle *allow_untagged_rule;
 	struct {
-		struct mlx5_flow_group *allow_spoofchk_only_grp;
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
@@ -83,11 +88,14 @@ struct vport_ingress {
=20
 struct vport_egress {
 	struct mlx5_flow_table *acl;
+	struct mlx5_flow_group *allow_untagged_grp;
 	struct mlx5_flow_group *allowed_vlans_grp;
 	struct mlx5_flow_group *drop_grp;
-	struct mlx5_flow_handle  *allowed_vlan;
+	struct mlx5_flow_handle  *allowed_vst_vlan;
 	struct {
 		struct mlx5_flow_handle *drop_rule;
+		struct list_head allowed_vlans_rules;
+		struct mlx5_flow_handle *allow_untagged_rule;
 		struct mlx5_fc *drop_counter;
 	} legacy;
 };
@@ -107,12 +115,15 @@ struct mlx5_vport_info {
 	u32                     max_rate;
 	bool                    spoofchk;
 	bool                    trusted;
+	/* the admin approved vlan list */
+	DECLARE_BITMAP(vlan_trunk_8021q_bitmap, VLAN_N_VID);
 };
=20
 /* Vport context events */
 enum mlx5_eswitch_vport_event {
 	MLX5_VPORT_UC_ADDR_CHANGE =3D BIT(0),
 	MLX5_VPORT_MC_ADDR_CHANGE =3D BIT(1),
+	MLX5_VPORT_VLAN_CHANGE =3D BIT(2),
 	MLX5_VPORT_PROMISC_CHANGE =3D BIT(3),
 };
=20
@@ -121,6 +132,10 @@ struct mlx5_vport {
 	int                     vport;
 	struct hlist_head       uc_list[MLX5_L2_ADDR_HASH_SIZE];
 	struct hlist_head       mc_list[MLX5_L2_ADDR_HASH_SIZE];
+	/* The requested vlan list from the vport side */
+	DECLARE_BITMAP(req_vlan_bitmap, VLAN_N_VID);
+	/* Actual accepted vlans on the acl tables */
+	DECLARE_BITMAP(acl_vlan_8021q_bitmap, VLAN_N_VID);
 	struct mlx5_flow_handle *promisc_rule;
 	struct mlx5_flow_handle *allmulti_rule;
 	struct work_struct      vport_change_handler;
@@ -292,6 +307,10 @@ int mlx5_eswitch_set_vport_rate(struct mlx5_eswitch *e=
sw, u16 vport,
 int mlx5_eswitch_get_vepa(struct mlx5_eswitch *esw, u8 *setting);
 int mlx5_eswitch_get_vport_config(struct mlx5_eswitch *esw,
 				  u16 vport, struct ifla_vf_info *ivi);
+int mlx5_eswitch_add_vport_trunk_range(struct mlx5_eswitch *esw,
+				       u16 vport, u16 start_vlan, u16 end_vlan);
+int mlx5_eswitch_del_vport_trunk_range(struct mlx5_eswitch *esw,
+				       u16 vport, u16 start_vlan, u16 end_vlan);
 int mlx5_eswitch_get_vport_stats(struct mlx5_eswitch *esw,
 				 u16 vport,
 				 struct ifla_vf_stats *vf_stats);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/d=
rivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 9924f06..2db872a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -1783,15 +1783,15 @@ static int esw_vport_ingress_prio_tag_config(struct=
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
1.8.3.1

