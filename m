Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45256E7D08
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 00:35:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732255AbfJ1Xfm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 19:35:42 -0400
Received: from mail-eopbgr150042.outbound.protection.outlook.com ([40.107.15.42]:38254
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731587AbfJ1Xfl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Oct 2019 19:35:41 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aMnIRwnocpmx9qEB7Q8CsiCUEgWWg1cLqSI23WWpreuIsO1U5ed/V3Dyouu9SeTulTG12DZ4y1pq/X6xOWO+Lmy7fFsCKEpviURcZ6mADrDV7DiFUEU7kHfrIBd54vsfKpzcOt9ZEYrY9l67jkgBKQ4qW9FkM2K05Q1XDx10MwW3K5Uv0GWgf9T5vaEacnYQPpLTYJEI0v/iKdA0oO+pnz4qqU/VIR6R3Fn5Aip6DcM58UKnqxmr7GUghwK1T/S9ulUGtzG7IYxfoF5iE1/uMDM9hQnY0nI3PEbs2T+wt2PcKGhEHO16MBrXSxGF2IoP3mWXN6REyqZwXo6nhH8aHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q42RVoyM1+uOE0nQal/Rqkqi45KQNRxXBWzwMcn5j6E=;
 b=LASbhpo1nWM/iYLFiFnzcp39f2t3Oa2zg0g0aOWBe1BD3gXzGntIUOqHV2K3OGAsB1L+N34AP0wlFMfhzhgN2aYqgFS4W2CvhhI0nM91Sh79HUk8Ba5LhahzjCOsSTh/8HHTO8R3yusEnV64n8iq2+MpeRBY+ymednnBo8d+rPWIhXO6ATV/KHfsKDawySLcE6TXP9GFPIQ/nYQxvchf6eyzWwR3eXpWmP/UlOckH5zltva8MFVxECMi0DueN0u+rgR3QQ8iN3EF00WL9St9QaKSmzXSSW4bT+vV08QlcOg2u6vLB8VgUd6kE0GA4WpauByRrnMgyQeUJZSpoPyYvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q42RVoyM1+uOE0nQal/Rqkqi45KQNRxXBWzwMcn5j6E=;
 b=F4KF0FIrN8U+7c0My1uCxLfJILQ9/h9qL0HWoMcsa5L5AK1iEl65kURIzabAPEQm5IbOFolMGr6GELXc+8mvAD4SHDyKCK54TYlAqAHfwhsvheaz5emHiA+lBCmm73GPL9wktQCYdWvvLrdNu5//GqJ8g5awer18UQ4gRJ/J6rI=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB4768.eurprd05.prod.outlook.com (20.176.7.157) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2387.20; Mon, 28 Oct 2019 23:35:28 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e%5]) with mapi id 15.20.2387.027; Mon, 28 Oct 2019
 23:35:28 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Parav Pandit <parav@mellanox.com>
Subject: [PATCH mlx5-next 17/18] net/mlx5: E-switch, Enable metadata on own
 vport
Thread-Topic: [PATCH mlx5-next 17/18] net/mlx5: E-switch, Enable metadata on
 own vport
Thread-Index: AQHVjehh0jkvyvQY/kekC++Qyvhm0g==
Date:   Mon, 28 Oct 2019 23:35:28 +0000
Message-ID: <20191028233440.5564-18-saeedm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: 51f36cab-eb30-49d6-c8a6-08d75bff83ea
x-ms-traffictypediagnostic: VI1PR05MB4768:|VI1PR05MB4768:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB47689CD7121E2D6E176FE66DBE660@VI1PR05MB4768.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0204F0BDE2
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(346002)(366004)(136003)(376002)(396003)(189003)(199004)(186003)(2616005)(81166006)(446003)(476003)(1076003)(25786009)(14454004)(386003)(478600001)(6506007)(76176011)(52116002)(99286004)(102836004)(26005)(6636002)(11346002)(66446008)(36756003)(14444005)(256004)(305945005)(66066001)(8676002)(7736002)(107886003)(50226002)(4326008)(71200400001)(86362001)(8936002)(6486002)(71190400001)(6512007)(450100002)(6436002)(3846002)(6116002)(316002)(486006)(110136005)(54906003)(66946007)(5660300002)(66476007)(64756008)(66556008)(2906002)(81156014);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4768;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 68LmMSg2xb1czNHm5wvsdi0AUaHTafDWiDbU7h6cVf9KXpYr2y15R1FeCpGO56mLVDYkWsMHUxoefvJAU3mrUVdE/S4kYkg1IhfAsK3ADSPbSJQJjQogtlZIiIAMVsMUABvOr+XG2zJcBW/NQUJhrAqD4d7hCfOSqEMmvjimJy3iYT5WA5wVit8lUJYMjVV97jvy3/DsgrDFVO0YXC2hRdCB+6sz106Sm1wIZv2TVZSzEMdf1PUdnZaQAGOndmyf8bN0pRiXukuRbPP6rQwrgV3SYNqyGaEk/gbUBlfxM7rkC4DjzCrkbZUh5QWzK8bRzxNd2ZY9cNVZuXOxsLau0KvNYYignIGqrUpe8do9GA46/pfdIDvaYDaIApkUnlHs4gb36TaYefhvrAl6pxyITX1Rxq8VH+2MS4QhAVR1UnYa+XKMYZj9RLMqK3sOhjWJ
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 51f36cab-eb30-49d6-c8a6-08d75bff83ea
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Oct 2019 23:35:28.6533
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /OezYf/e+9SN20aeZNqr0sUZWnonjIyAQhhd9HLoU5vxSdpnqTi6tIReN+z53B6dO7/BWIYJZARliqjtABS05w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4768
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Parav Pandit <parav@mellanox.com>

Currently on ECPF, metadata is enabled on the ECPF vport =3D 0xfffe
(manager vport).
Metadata when supported, must be enabled on own vport which is
used to pass metadata to vport of NIC Rx Flow Table.

Due to this error, traffic tagged by ingress ACL is not processed
correctly at NIC rx flow table level which is supposed to work
on metadata tag.

Hence, instead of working on eswitch manager vport, always working on
eswitch own vport regardless of PF or ECPF.

Given that mlx5_eswitch_query/modify_esw_vport_context() is used to
access other vport in legacy mode and own vport settings in switchdev mode,
extend low level API to explicitly specify other_vport.

Fixes: c1286050cf47 ("net/mlx5: E-Switch, Pass metadata from FDB to eswitch=
 manager")
Signed-off-by: Parav Pandit <parav@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/eswitch.c | 29 +++++++------------
 .../net/ethernet/mellanox/mlx5/core/eswitch.h |  6 ++--
 .../mellanox/mlx5/core/eswitch_offloads.c     |  4 +--
 3 files changed, 16 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/ne=
t/ethernet/mellanox/mlx5/core/eswitch.c
index cc8d43d8c469..24c2217a4ce8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -111,42 +111,32 @@ static int arm_vport_context_events_cmd(struct mlx5_c=
ore_dev *dev, u16 vport,
 }
=20
 /* E-Switch vport context HW commands */
-static int modify_esw_vport_context_cmd(struct mlx5_core_dev *dev, u16 vpo=
rt,
-					void *in, int inlen)
+int mlx5_eswitch_modify_esw_vport_context(struct mlx5_core_dev *dev, u16 v=
port,
+					  bool other_vport,
+					  void *in, int inlen)
 {
 	u32 out[MLX5_ST_SZ_DW(modify_esw_vport_context_out)] =3D {0};
=20
 	MLX5_SET(modify_esw_vport_context_in, in, opcode,
 		 MLX5_CMD_OP_MODIFY_ESW_VPORT_CONTEXT);
 	MLX5_SET(modify_esw_vport_context_in, in, vport_number, vport);
-	MLX5_SET(modify_esw_vport_context_in, in, other_vport, 1);
+	MLX5_SET(modify_esw_vport_context_in, in, other_vport, other_vport);
 	return mlx5_cmd_exec(dev, in, inlen, out, sizeof(out));
 }
=20
-int mlx5_eswitch_modify_esw_vport_context(struct mlx5_eswitch *esw, u16 vp=
ort,
-					  void *in, int inlen)
-{
-	return modify_esw_vport_context_cmd(esw->dev, vport, in, inlen);
-}
-
-static int query_esw_vport_context_cmd(struct mlx5_core_dev *dev, u16 vpor=
t,
-				       void *out, int outlen)
+int mlx5_eswitch_query_esw_vport_context(struct mlx5_core_dev *dev, u16 vp=
ort,
+					 bool other_vport,
+					 void *out, int outlen)
 {
 	u32 in[MLX5_ST_SZ_DW(query_esw_vport_context_in)] =3D {};
=20
 	MLX5_SET(query_esw_vport_context_in, in, opcode,
 		 MLX5_CMD_OP_QUERY_ESW_VPORT_CONTEXT);
 	MLX5_SET(modify_esw_vport_context_in, in, vport_number, vport);
-	MLX5_SET(modify_esw_vport_context_in, in, other_vport, 1);
+	MLX5_SET(modify_esw_vport_context_in, in, other_vport, other_vport);
 	return mlx5_cmd_exec(dev, in, sizeof(in), out, outlen);
 }
=20
-int mlx5_eswitch_query_esw_vport_context(struct mlx5_eswitch *esw, u16 vpo=
rt,
-					 void *out, int outlen)
-{
-	return query_esw_vport_context_cmd(esw->dev, vport, out, outlen);
-}
-
 static int modify_esw_vport_cvlan(struct mlx5_core_dev *dev, u16 vport,
 				  u16 vlan, u8 qos, u8 set_flags)
 {
@@ -179,7 +169,8 @@ static int modify_esw_vport_cvlan(struct mlx5_core_dev =
*dev, u16 vport,
 	MLX5_SET(modify_esw_vport_context_in, in,
 		 field_select.vport_cvlan_insert, 1);
=20
-	return modify_esw_vport_context_cmd(dev, vport, in, sizeof(in));
+	return mlx5_eswitch_modify_esw_vport_context(dev, vport, true,
+						     in, sizeof(in));
 }
=20
 /* E-Switch FDB */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/ne=
t/ethernet/mellanox/mlx5/core/eswitch.h
index 5e91735726b7..a05b948a6287 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -297,9 +297,11 @@ int mlx5_eswitch_get_vport_stats(struct mlx5_eswitch *=
esw,
 				 struct ifla_vf_stats *vf_stats);
 void mlx5_eswitch_del_send_to_vport_rule(struct mlx5_flow_handle *rule);
=20
-int mlx5_eswitch_modify_esw_vport_context(struct mlx5_eswitch *esw, u16 vp=
ort,
+int mlx5_eswitch_modify_esw_vport_context(struct mlx5_core_dev *dev, u16 v=
port,
+					  bool other_vport,
 					  void *in, int inlen);
-int mlx5_eswitch_query_esw_vport_context(struct mlx5_eswitch *esw, u16 vpo=
rt,
+int mlx5_eswitch_query_esw_vport_context(struct mlx5_core_dev *dev, u16 vp=
ort,
+					 bool other_vport,
 					 void *out, int outlen);
=20
 struct mlx5_flow_spec;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/d=
rivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 807372a7211b..59eebcae5df6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -600,7 +600,7 @@ static int esw_set_passing_vport_metadata(struct mlx5_e=
switch *esw, bool enable)
 	if (!mlx5_eswitch_vport_match_metadata_enabled(esw))
 		return 0;
=20
-	err =3D mlx5_eswitch_query_esw_vport_context(esw, esw->manager_vport,
+	err =3D mlx5_eswitch_query_esw_vport_context(esw->dev, 0, false,
 						   out, sizeof(out));
 	if (err)
 		return err;
@@ -619,7 +619,7 @@ static int esw_set_passing_vport_metadata(struct mlx5_e=
switch *esw, bool enable)
 	MLX5_SET(modify_esw_vport_context_in, in,
 		 field_select.fdb_to_vport_reg_c_id, 1);
=20
-	return mlx5_eswitch_modify_esw_vport_context(esw, esw->manager_vport,
+	return mlx5_eswitch_modify_esw_vport_context(esw->dev, 0, false,
 						     in, sizeof(in));
 }
=20
--=20
2.21.0

