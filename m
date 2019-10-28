Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E48B1E7D11
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 00:36:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732572AbfJ1XgG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 19:36:06 -0400
Received: from mail-eopbgr60058.outbound.protection.outlook.com ([40.107.6.58]:42382
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731587AbfJ1XgE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Oct 2019 19:36:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m9IGY7RXn50k6C0tl6vmO2tDlzhsIUk1+zQnU4oa9hxR3mnRE6FAkwF9QpQxlbNNewGlEytdKZfJTA+WvCWzoOTNRkunYQYb484VhTA/eMYxLNqAnDnytgdwDPei5PwfE194SQckpXy8COcjfZS8WkdgNjvDgx5UxOLrCbmY0mWHbp+3wllji8lNzpqtVs6xD8InNWzBK8fxg13LVslAoL3bAGD4Lua2+zi1iW78PabxfKa/fviVCCjmXmoFF8JyxjWMaELImc40q98f1nGLeX2pp6fync1F9a4S+povfznE/xlkH3f8Zq5nmKq1opnBOqv1zKhrv4GBxg4bEM5JUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BoeW0R1vIBlOtUSGBbvO0iOb/5XB1wowhxSQRe4fZNY=;
 b=FJMBvPjESiL/HkAsO8K8NL3Kg7mIFAfB6TfwlleuTShPV+zLXiP6peCOtrqQbk86j0FcsfGv6mibO8ynad5ls8Yz/ZEWzzC03khRCm5ahcXqZxWdxloT9etUJp9V/mR+j9v+38iSVZV1tSANV7Vdo9WKZZ3PsIglhQFRcVz8X/2sC75WkoR2CzMJAx9E/uVsSUd8Bc3aiEEK8VkYeloL2t0j+vxPMXArvLyIX9fFiRizbuen7kXWiM+ZY49bzirNEEOFNU4d9rRTEDAH5jCbrsY0wn1AnTNpJgdRtzvyDTvM7Pv6yxaQXtZOYwiz4HesTZ2MX7AgDFtnXEgpbd6VWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BoeW0R1vIBlOtUSGBbvO0iOb/5XB1wowhxSQRe4fZNY=;
 b=IwA7nYunYugjn2fWQ07lOxAO7iiKL5rq5Q6X2seWG/qpU7BlSwWOAoQoV2xhYDc7szQMEwPlPvAYk6PR4LIuVYzswWKyRqDGMPqct8eRww3utIEBgA2DvlbK/rF7GwdArWWafleRIEsjyD3+Pm+KriQexbUN2Mzw7VFMS+5Xs4c=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB6448.eurprd05.prod.outlook.com (20.179.28.86) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2387.22; Mon, 28 Oct 2019 23:35:17 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e%5]) with mapi id 15.20.2387.027; Mon, 28 Oct 2019
 23:35:17 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Parav Pandit <parav@mellanox.com>
Subject: [PATCH mlx5-next 11/18] net/mlx5: E-switch, Legacy introduce and use
 per vport acl tables APIs
Thread-Topic: [PATCH mlx5-next 11/18] net/mlx5: E-switch, Legacy introduce and
 use per vport acl tables APIs
Thread-Index: AQHVjehaEW9UkNN8E0C0ClYSzizBxw==
Date:   Mon, 28 Oct 2019 23:35:17 +0000
Message-ID: <20191028233440.5564-12-saeedm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: fb67bfbe-fc52-41ab-0701-08d75bff7d2a
x-ms-traffictypediagnostic: VI1PR05MB6448:|VI1PR05MB6448:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB644814F3FEDCD8030242BEBCBE660@VI1PR05MB6448.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:663;
x-forefront-prvs: 0204F0BDE2
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(376002)(366004)(346002)(396003)(39860400002)(189003)(199004)(3846002)(305945005)(8936002)(450100002)(316002)(478600001)(50226002)(86362001)(99286004)(71200400001)(81156014)(8676002)(81166006)(107886003)(71190400001)(186003)(66446008)(386003)(102836004)(6636002)(6506007)(14444005)(66476007)(66946007)(256004)(36756003)(52116002)(476003)(2616005)(11346002)(486006)(446003)(5024004)(64756008)(6512007)(76176011)(6116002)(4326008)(26005)(7736002)(5660300002)(66066001)(14454004)(2906002)(110136005)(6436002)(6486002)(54906003)(1076003)(25786009)(66556008);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB6448;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: G1YoTXp8HK/G8R3qAdtxzo2bXpZxEnxM2XxbrAYruugioQGtFLpIdS1WbUbKCWUlVihB+iexqSDz0/GHOef0EkFNjuxR27Gfl+u1QYDbA0C/TEqQMl5pUmIDhQIpiIidvObYKj30Qrhq8Wl1Idff2++sn4quSNBJ/s2CzptHexDdQt1QTtkllzJzcr3juvAxJoXGTagnCO577mZyvB4gQ/FmCBGATCZOAnHbPfhkzDFnOBVZ6u4wx1daHK78McRnIBZLt6m2eV7ocM9jDFD3ZECa0oKSM0nVZxFEoH+CR+NzxbSIueLT85dDpx3TdjVEdG5EWFAgH2uoSjHY3jyDtrzSnYRpfK3Qln9O3GmVRqMuhm5AiSf/641yxVlv8aLTNLtOT65znucSdCYXSoBvO5ctdBZ6R3Ob0hNoKQnSqi16nto+RhirDqbf5SdaiSAZ
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fb67bfbe-fc52-41ab-0701-08d75bff7d2a
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Oct 2019 23:35:17.2627
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dhWjo7JQS7ioQiz0Vw4QfUE7JsiG8nJGGv5T5OWwhyH4/66xWq4kHt+sQnUGS4gPTCIsw4dveyD2CedXltHqrQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6448
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Parav Pandit <parav@mellanox.com>

Introduce and use per vport ACL tables creation and destroy APIs, so that
subsequently patch can use them during enabling/disabling a vport in
unified way for legacy vs offloads mode.

Signed-off-by: Parav Pandit <parav@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/eswitch.c | 73 +++++++++++++++----
 1 file changed, 60 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/ne=
t/ethernet/mellanox/mlx5/core/eswitch.c
index 0bdaef508e74..47555e272dda 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -1663,12 +1663,6 @@ static void esw_apply_vport_conf(struct mlx5_eswitch=
 *esw,
 		SET_VLAN_STRIP | SET_VLAN_INSERT : 0;
 	modify_esw_vport_cvlan(esw->dev, vport_num, vport->info.vlan, vport->info=
.qos,
 			       flags);
-
-	/* Only legacy mode needs ACLs */
-	if (esw->mode =3D=3D MLX5_ESWITCH_LEGACY) {
-		esw_vport_ingress_config(esw, vport);
-		esw_vport_egress_config(esw, vport);
-	}
 }
=20
 static void esw_legacy_vport_create_drop_counters(struct mlx5_vport *vport=
)
@@ -1706,10 +1700,59 @@ static void esw_legacy_vport_destroy_drop_counters(=
struct mlx5_vport *vport)
 		mlx5_fc_destroy(dev, vport->egress.legacy.drop_counter);
 }
=20
+static int esw_vport_create_legacy_acl_tables(struct mlx5_eswitch *esw,
+					      struct mlx5_vport *vport)
+{
+	int ret;
+
+	/* Only non manager vports need ACL in legacy mode */
+	if (mlx5_esw_is_manager_vport(esw, vport->vport))
+		return 0;
+
+	ret =3D esw_vport_ingress_config(esw, vport);
+	if (ret)
+		return ret;
+
+	ret =3D esw_vport_egress_config(esw, vport);
+	if (ret)
+		esw_vport_disable_ingress_acl(esw, vport);
+
+	return ret;
+}
+
+static int esw_vport_setup_acl(struct mlx5_eswitch *esw,
+			       struct mlx5_vport *vport)
+{
+	if (esw->mode =3D=3D MLX5_ESWITCH_LEGACY)
+		return esw_vport_create_legacy_acl_tables(esw, vport);
+
+	return 0;
+}
+
+static void esw_vport_destroy_legacy_acl_tables(struct mlx5_eswitch *esw,
+						struct mlx5_vport *vport)
+
+{
+	if (mlx5_esw_is_manager_vport(esw, vport->vport))
+		return;
+
+	esw_vport_disable_egress_acl(esw, vport);
+	esw_vport_disable_ingress_acl(esw, vport);
+	esw_legacy_vport_destroy_drop_counters(vport);
+}
+
+static void esw_vport_cleanup_acl(struct mlx5_eswitch *esw,
+				  struct mlx5_vport *vport)
+{
+	if (esw->mode =3D=3D MLX5_ESWITCH_LEGACY)
+		esw_vport_destroy_legacy_acl_tables(esw, vport);
+}
+
 static int esw_enable_vport(struct mlx5_eswitch *esw, struct mlx5_vport *v=
port,
 			    enum mlx5_eswitch_vport_event enabled_events)
 {
 	u16 vport_num =3D vport->vport;
+	int ret;
=20
 	mutex_lock(&esw->state_lock);
 	WARN_ON(vport->enabled);
@@ -1724,6 +1767,10 @@ static int esw_enable_vport(struct mlx5_eswitch *esw=
, struct mlx5_vport *vport,
 	/* Restore old vport configuration */
 	esw_apply_vport_conf(esw, vport);
=20
+	ret =3D esw_vport_setup_acl(esw, vport);
+	if (ret)
+		goto done;
+
 	/* Attach vport to the eswitch rate limiter */
 	if (esw_vport_enable_qos(esw, vport, vport->info.max_rate,
 				 vport->qos.bw_share))
@@ -1744,8 +1791,9 @@ static int esw_enable_vport(struct mlx5_eswitch *esw,=
 struct mlx5_vport *vport,
=20
 	esw->enabled_vports++;
 	esw_debug(esw->dev, "Enabled VPORT(%d)\n", vport_num);
+done:
 	mutex_unlock(&esw->state_lock);
-	return 0;
+	return ret;
 }
=20
 static void esw_disable_vport(struct mlx5_eswitch *esw,
@@ -1770,16 +1818,15 @@ static void esw_disable_vport(struct mlx5_eswitch *=
esw,
 	esw_vport_change_handle_locked(vport);
 	vport->enabled_events =3D 0;
 	esw_vport_disable_qos(esw, vport);
-	if (!mlx5_esw_is_manager_vport(esw, vport_num) &&
-	    esw->mode =3D=3D MLX5_ESWITCH_LEGACY) {
+
+	if (!mlx5_esw_is_manager_vport(esw, vport->vport) &&
+	    esw->mode =3D=3D MLX5_ESWITCH_LEGACY)
 		mlx5_modify_vport_admin_state(esw->dev,
 					      MLX5_VPORT_STATE_OP_MOD_ESW_VPORT,
 					      vport_num, 1,
 					      MLX5_VPORT_ADMIN_STATE_DOWN);
-		esw_vport_disable_egress_acl(esw, vport);
-		esw_vport_disable_ingress_acl(esw, vport);
-		esw_legacy_vport_destroy_drop_counters(vport);
-	}
+
+	esw_vport_cleanup_acl(esw, vport);
 	esw->enabled_vports--;
=20
 done:
--=20
2.21.0

