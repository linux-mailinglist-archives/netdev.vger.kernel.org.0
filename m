Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C711B792FF
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 20:26:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387705AbfG2S0W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 14:26:22 -0400
Received: from mail-eopbgr80084.outbound.protection.outlook.com ([40.107.8.84]:19333
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387662AbfG2S0V (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Jul 2019 14:26:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L+KAvjm0iU4CfiR4BXlw1z5K1TbAoSniddJ+eDHLzujthxs1FDHVMWoMib8cSkwQQiw/NenTs0SpGBmVBTp0gss9gRYtMpY9er+uAFwBddcDAg7xDINwfx+2s0kq42+Ps6Gp3N0A/ahiCHseiMm4TxC6Wk6hecjKx637aTyv4rJarjOd20I+nPYAW2+Oyc+NYJm8XihTcRku10BGlk1hC5f41DsGL5ULqJFcJx4ENU1KS2fVxOX+8D5U7ihmler3XuiD8oGEiYgGtmQ7pmWXoJHIHxuON+cUOYgedaQE3gZx25hVunv5AoVrt/UeVCX6Xz41C0k1yncneSS1mRYFAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=srsP7oTUmHf8ij593KKj2Gp8MvT3+9Fate/G9Gbl0vg=;
 b=bN0eqA62xw0yl5pFyuFCP+b/xbcY+9PwBLbec5eYn2PedWM383lD40tZ3zUrS+I9rjdI0miaCRvkiogQkKOYv39Lujc9M8eDcCudGne8vNX8F6YGzCRL8UEXQC7bJ/VH63xNF8d5bq+1crKlAVXTnVa0DY+rNUWaK/QNqHCOQRMYvq2l6w548EhycoOg1c9q3Yv06D4v5q9tcLnZ0b5WqJyP50e5PGS0FH85x+yGh6jTB1tXZpnV1lnHFiekCfXO91yQ4qhAXUV89eN+Y8wReiPaPm7ZyJL1whwBJhSDJDzybE3/yWqny2Q0yFJImFb+5s+HkLboMk1v/HuS1VVUpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=mellanox.com;dmarc=pass action=none
 header.from=mellanox.com;dkim=pass header.d=mellanox.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=srsP7oTUmHf8ij593KKj2Gp8MvT3+9Fate/G9Gbl0vg=;
 b=VjWsb+9M0fNJnPN1K4st6BY241VdOv4guwzyLX6G0wmujQna1xYF0+mN453fmt3VHEtGDB0I7QZh2XeJ9J7JaH7z3iOL9MfzrDw1cnuWaMC2rSN0hhXM1vlsdUs1pV4bq52jZ991v7RpFPTQwlCD+T7t2VwZ7QQ7zqjQrLy6BxQ=
Received: from AM6PR05MB6037.eurprd05.prod.outlook.com (20.179.2.84) by
 AM6PR05MB5112.eurprd05.prod.outlook.com (20.177.197.153) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.15; Mon, 29 Jul 2019 18:26:15 +0000
Received: from AM6PR05MB6037.eurprd05.prod.outlook.com
 ([fe80::d919:6738:87c5:9839]) by AM6PR05MB6037.eurprd05.prod.outlook.com
 ([fe80::d919:6738:87c5:9839%3]) with mapi id 15.20.2115.005; Mon, 29 Jul 2019
 18:26:15 +0000
From:   Petr Machata <petrm@mellanox.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Petr Machata <petrm@mellanox.com>, Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: [PATCH net v2] mlxsw: spectrum_ptp: Increase parsing depth when PTP
 is enabled
Thread-Topic: [PATCH net v2] mlxsw: spectrum_ptp: Increase parsing depth when
 PTP is enabled
Thread-Index: AQHVRjsb/MZn0O5pOkyChC6A8JR51w==
Date:   Mon, 29 Jul 2019 18:26:14 +0000
Message-ID: <b1584bdec4a0a36a2567a43dc0973dd8f3a05dec.1564424420.git.petrm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.20.1
x-clientproxiedby: LO2P265CA0329.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a4::29) To AM6PR05MB6037.eurprd05.prod.outlook.com
 (2603:10a6:20b:aa::20)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=petrm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [37.142.13.130]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bb430a67-11cc-4b28-cf70-08d714523d6e
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM6PR05MB5112;
x-ms-traffictypediagnostic: AM6PR05MB5112:
x-microsoft-antispam-prvs: <AM6PR05MB511223CDAB14DCE698438A8DDBDD0@AM6PR05MB5112.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 01136D2D90
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(366004)(376002)(136003)(346002)(396003)(189003)(199004)(8936002)(4326008)(1730700003)(8676002)(305945005)(6116002)(81156014)(256004)(81166006)(68736007)(3846002)(25786009)(2906002)(6436002)(2351001)(6486002)(66066001)(71190400001)(71200400001)(53936002)(14454004)(5640700003)(50226002)(6512007)(102836004)(118296001)(2616005)(86362001)(476003)(52116002)(478600001)(66574012)(6916009)(66476007)(14444005)(66946007)(66556008)(2501003)(64756008)(486006)(386003)(7736002)(6506007)(66446008)(99286004)(26005)(186003)(5660300002)(36756003)(316002)(54906003);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR05MB5112;H:AM6PR05MB6037.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 9laGlXmLD5SnZ1SD2IWk3nDoO6rocyzO/DpFERpZYp1wP7C7pvZ1Dvtm1cSXYI2cLeEtPURytmDgljyNmILfollYwUREYPATmOco+rmd5FezDNH262OFS/79QZYTSBFJyUu19ARLk9U58gH8HKRam599xQPKur0dppjuB4awTpYgdWsQ5mmT6N+/WdbPfcp+dWwArk2t5CZbnVVbiF+DgJWe8AXRc28C2YG7vPbd/dNwwKKwoSteiOEpyzASK9iQSgcbzOyOyFL2UrToT62rNZYj24vpZiZy//DjYPA5BNPfNb4yQsckdVs2Ouz2zXp1eRV0XM6YBvXjwN7cOxPsfZOSV6vnxAJK1omHHgbezidy5+dA6b1TBQNmtmno50EOlee9ie0eCDLwqzXSmpWha63aN5+SITpOoDEssjKDjsE=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bb430a67-11cc-4b28-cf70-08d714523d6e
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jul 2019 18:26:14.8779
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: petrm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB5112
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Spectrum systems have a configurable limit on how far into the packet they
parse. By default, the limit is 96 bytes.

An IPv6 PTP packet is layered as Ethernet/IPv6/UDP (14+40+8 bytes), and
sequence ID of a PTP event is only available 32 bytes into payload, for a
total of 94 bytes. When an additional 802.1q header is present as
well (such as when ptp4l is running on a VLAN port), the parsing limit is
exceeded. Such packets are not recognized as PTP, and are not timestamped.

Therefore generalize the current VXLAN-specific parsing depth setting to
allow reference-counted requests from other modules as well. Keep it in the
VXLAN module, because the MPRS register also configures UDP destination
port number used for VXLAN, and is thus closely tied to the VXLAN code
anyway.

Then invoke the new interfaces from both VXLAN (in obvious places), as well
as from PTP code, when the (global) timestamping configuration changes from
disabled to enabled or vice versa.

Fixes: 8748642751ed ("mlxsw: spectrum: PTP: Support SIOCGHWTSTAMP, SIOCSHWT=
STAMP ioctls")
Signed-off-by: Petr Machata <petrm@mellanox.com>
---

Notes:
    v2:
    - Preserve RXT in mlxsw_sp1_ptp_mtpppc_update()

 .../net/ethernet/mellanox/mlxsw/spectrum.h    |  4 +
 .../ethernet/mellanox/mlxsw/spectrum_nve.c    |  1 +
 .../ethernet/mellanox/mlxsw/spectrum_nve.h    |  1 +
 .../mellanox/mlxsw/spectrum_nve_vxlan.c       | 76 ++++++++++++++-----
 .../ethernet/mellanox/mlxsw/spectrum_ptp.c    | 17 +++++
 5 files changed, 82 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h b/drivers/net/e=
thernet/mellanox/mlxsw/spectrum.h
index 131f62ce9297..6664119fb0c8 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -951,4 +951,8 @@ void mlxsw_sp_port_nve_fini(struct mlxsw_sp_port *mlxsw=
_sp_port);
 int mlxsw_sp_nve_init(struct mlxsw_sp *mlxsw_sp);
 void mlxsw_sp_nve_fini(struct mlxsw_sp *mlxsw_sp);
=20
+/* spectrum_nve_vxlan.c */
+int mlxsw_sp_nve_inc_parsing_depth_get(struct mlxsw_sp *mlxsw_sp);
+void mlxsw_sp_nve_inc_parsing_depth_put(struct mlxsw_sp *mlxsw_sp);
+
 #endif
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_nve.c b/drivers/n=
et/ethernet/mellanox/mlxsw/spectrum_nve.c
index 1df164a4b06d..17f334b46c40 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_nve.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_nve.c
@@ -775,6 +775,7 @@ static void mlxsw_sp_nve_tunnel_fini(struct mlxsw_sp *m=
lxsw_sp)
 		ops->fini(nve);
 		mlxsw_sp_kvdl_free(mlxsw_sp, MLXSW_SP_KVDL_ENTRY_TYPE_ADJ, 1,
 				   nve->tunnel_index);
+		memset(&nve->config, 0, sizeof(nve->config));
 	}
 	nve->num_nve_tunnels--;
 }
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_nve.h b/drivers/n=
et/ethernet/mellanox/mlxsw/spectrum_nve.h
index 0035640156a1..12f664f42f21 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_nve.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_nve.h
@@ -29,6 +29,7 @@ struct mlxsw_sp_nve {
 	unsigned int num_max_mc_entries[MLXSW_SP_L3_PROTO_MAX];
 	u32 tunnel_index;
 	u16 ul_rif_index;	/* Reserved for Spectrum */
+	unsigned int inc_parsing_depth_refs;
 };
=20
 struct mlxsw_sp_nve_ops {
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_nve_vxlan.c b/dri=
vers/net/ethernet/mellanox/mlxsw/spectrum_nve_vxlan.c
index 93ccd9fc2266..05517c7feaa5 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_nve_vxlan.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_nve_vxlan.c
@@ -103,9 +103,9 @@ static void mlxsw_sp_nve_vxlan_config(const struct mlxs=
w_sp_nve *nve,
 	config->udp_dport =3D cfg->dst_port;
 }
=20
-static int mlxsw_sp_nve_parsing_set(struct mlxsw_sp *mlxsw_sp,
-				    unsigned int parsing_depth,
-				    __be16 udp_dport)
+static int __mlxsw_sp_nve_parsing_set(struct mlxsw_sp *mlxsw_sp,
+				      unsigned int parsing_depth,
+				      __be16 udp_dport)
 {
 	char mprs_pl[MLXSW_REG_MPRS_LEN];
=20
@@ -113,6 +113,56 @@ static int mlxsw_sp_nve_parsing_set(struct mlxsw_sp *m=
lxsw_sp,
 	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(mprs), mprs_pl);
 }
=20
+static int mlxsw_sp_nve_parsing_set(struct mlxsw_sp *mlxsw_sp,
+				    __be16 udp_dport)
+{
+	int parsing_depth =3D mlxsw_sp->nve->inc_parsing_depth_refs ?
+				MLXSW_SP_NVE_VXLAN_PARSING_DEPTH :
+				MLXSW_SP_NVE_DEFAULT_PARSING_DEPTH;
+
+	return __mlxsw_sp_nve_parsing_set(mlxsw_sp, parsing_depth, udp_dport);
+}
+
+static int
+__mlxsw_sp_nve_inc_parsing_depth_get(struct mlxsw_sp *mlxsw_sp,
+				     __be16 udp_dport)
+{
+	int err;
+
+	mlxsw_sp->nve->inc_parsing_depth_refs++;
+
+	err =3D mlxsw_sp_nve_parsing_set(mlxsw_sp, udp_dport);
+	if (err)
+		goto err_nve_parsing_set;
+	return 0;
+
+err_nve_parsing_set:
+	mlxsw_sp->nve->inc_parsing_depth_refs--;
+	return err;
+}
+
+static void
+__mlxsw_sp_nve_inc_parsing_depth_put(struct mlxsw_sp *mlxsw_sp,
+				     __be16 udp_dport)
+{
+	mlxsw_sp->nve->inc_parsing_depth_refs--;
+	mlxsw_sp_nve_parsing_set(mlxsw_sp, udp_dport);
+}
+
+int mlxsw_sp_nve_inc_parsing_depth_get(struct mlxsw_sp *mlxsw_sp)
+{
+	__be16 udp_dport =3D mlxsw_sp->nve->config.udp_dport;
+
+	return __mlxsw_sp_nve_inc_parsing_depth_get(mlxsw_sp, udp_dport);
+}
+
+void mlxsw_sp_nve_inc_parsing_depth_put(struct mlxsw_sp *mlxsw_sp)
+{
+	__be16 udp_dport =3D mlxsw_sp->nve->config.udp_dport;
+
+	__mlxsw_sp_nve_inc_parsing_depth_put(mlxsw_sp, udp_dport);
+}
+
 static void
 mlxsw_sp_nve_vxlan_config_prepare(char *tngcr_pl,
 				  const struct mlxsw_sp_nve_config *config)
@@ -176,9 +226,7 @@ static int mlxsw_sp1_nve_vxlan_init(struct mlxsw_sp_nve=
 *nve,
 	struct mlxsw_sp *mlxsw_sp =3D nve->mlxsw_sp;
 	int err;
=20
-	err =3D mlxsw_sp_nve_parsing_set(mlxsw_sp,
-				       MLXSW_SP_NVE_VXLAN_PARSING_DEPTH,
-				       config->udp_dport);
+	err =3D __mlxsw_sp_nve_inc_parsing_depth_get(mlxsw_sp, config->udp_dport)=
;
 	if (err)
 		return err;
=20
@@ -203,8 +251,7 @@ static int mlxsw_sp1_nve_vxlan_init(struct mlxsw_sp_nve=
 *nve,
 err_rtdp_set:
 	mlxsw_sp1_nve_vxlan_config_clear(mlxsw_sp);
 err_config_set:
-	mlxsw_sp_nve_parsing_set(mlxsw_sp, MLXSW_SP_NVE_DEFAULT_PARSING_DEPTH,
-				 config->udp_dport);
+	__mlxsw_sp_nve_inc_parsing_depth_put(mlxsw_sp, 0);
 	return err;
 }
=20
@@ -216,8 +263,7 @@ static void mlxsw_sp1_nve_vxlan_fini(struct mlxsw_sp_nv=
e *nve)
 	mlxsw_sp_router_nve_demote_decap(mlxsw_sp, config->ul_tb_id,
 					 config->ul_proto, &config->ul_sip);
 	mlxsw_sp1_nve_vxlan_config_clear(mlxsw_sp);
-	mlxsw_sp_nve_parsing_set(mlxsw_sp, MLXSW_SP_NVE_DEFAULT_PARSING_DEPTH,
-				 config->udp_dport);
+	__mlxsw_sp_nve_inc_parsing_depth_put(mlxsw_sp, 0);
 }
=20
 static int
@@ -320,9 +366,7 @@ static int mlxsw_sp2_nve_vxlan_init(struct mlxsw_sp_nve=
 *nve,
 	struct mlxsw_sp *mlxsw_sp =3D nve->mlxsw_sp;
 	int err;
=20
-	err =3D mlxsw_sp_nve_parsing_set(mlxsw_sp,
-				       MLXSW_SP_NVE_VXLAN_PARSING_DEPTH,
-				       config->udp_dport);
+	err =3D __mlxsw_sp_nve_inc_parsing_depth_get(mlxsw_sp, config->udp_dport)=
;
 	if (err)
 		return err;
=20
@@ -348,8 +392,7 @@ static int mlxsw_sp2_nve_vxlan_init(struct mlxsw_sp_nve=
 *nve,
 err_rtdp_set:
 	mlxsw_sp2_nve_vxlan_config_clear(mlxsw_sp);
 err_config_set:
-	mlxsw_sp_nve_parsing_set(mlxsw_sp, MLXSW_SP_NVE_DEFAULT_PARSING_DEPTH,
-				 config->udp_dport);
+	__mlxsw_sp_nve_inc_parsing_depth_put(mlxsw_sp, 0);
 	return err;
 }
=20
@@ -361,8 +404,7 @@ static void mlxsw_sp2_nve_vxlan_fini(struct mlxsw_sp_nv=
e *nve)
 	mlxsw_sp_router_nve_demote_decap(mlxsw_sp, config->ul_tb_id,
 					 config->ul_proto, &config->ul_sip);
 	mlxsw_sp2_nve_vxlan_config_clear(mlxsw_sp);
-	mlxsw_sp_nve_parsing_set(mlxsw_sp, MLXSW_SP_NVE_DEFAULT_PARSING_DEPTH,
-				 config->udp_dport);
+	__mlxsw_sp_nve_inc_parsing_depth_put(mlxsw_sp, 0);
 }
=20
 const struct mlxsw_sp_nve_ops mlxsw_sp2_nve_vxlan_ops =3D {
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c b/drivers/n=
et/ethernet/mellanox/mlxsw/spectrum_ptp.c
index bd9c2bc2d5d6..98c5ba3200bc 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c
@@ -979,6 +979,9 @@ static int mlxsw_sp1_ptp_mtpppc_update(struct mlxsw_sp_=
port *mlxsw_sp_port,
 {
 	struct mlxsw_sp *mlxsw_sp =3D mlxsw_sp_port->mlxsw_sp;
 	struct mlxsw_sp_port *tmp;
+	u16 orig_ing_types =3D 0;
+	u16 orig_egr_types =3D 0;
+	int err;
 	int i;
=20
 	/* MTPPPC configures timestamping globally, not per port. Find the
@@ -986,12 +989,26 @@ static int mlxsw_sp1_ptp_mtpppc_update(struct mlxsw_s=
p_port *mlxsw_sp_port,
 	 */
 	for (i =3D 1; i < mlxsw_core_max_ports(mlxsw_sp->core); i++) {
 		tmp =3D mlxsw_sp->ports[i];
+		if (tmp) {
+			orig_ing_types |=3D tmp->ptp.ing_types;
+			orig_egr_types |=3D tmp->ptp.egr_types;
+		}
 		if (tmp && tmp !=3D mlxsw_sp_port) {
 			ing_types |=3D tmp->ptp.ing_types;
 			egr_types |=3D tmp->ptp.egr_types;
 		}
 	}
=20
+	if ((ing_types || egr_types) && !(orig_egr_types || orig_egr_types)) {
+		err =3D mlxsw_sp_nve_inc_parsing_depth_get(mlxsw_sp);
+		if (err) {
+			netdev_err(mlxsw_sp_port->dev, "Failed to increase parsing depth");
+			return err;
+		}
+	}
+	if (!(ing_types || egr_types) && (orig_egr_types || orig_egr_types))
+		mlxsw_sp_nve_inc_parsing_depth_put(mlxsw_sp);
+
 	return mlxsw_sp1_ptp_mtpppc_set(mlxsw_sp_port->mlxsw_sp,
 				       ing_types, egr_types);
 }
--=20
2.20.1

