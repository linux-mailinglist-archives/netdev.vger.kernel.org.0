Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52452146214
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 07:40:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725989AbgAWGkS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 01:40:18 -0500
Received: from mail-eopbgr80041.outbound.protection.outlook.com ([40.107.8.41]:42992
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726968AbgAWGkQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Jan 2020 01:40:16 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bea8ZD+W5hlauzelOFpO0eCAjkS6NWFINf18q6SJqIsBeCGUeyyAOeKRWGlhYAl2fyftDoFYEiR1XlIFYITQ1J6B52e5MCCvelaUMWzw7wtPkWFeAJ6SipHxc7GBmpq78KPVcPYU0T6ISz15YZOSj8NOeexE55FuCSWxtJilYmEHP3SnOIW0OByur8MwJz3qqdPZbf/Qr83jp1qbqJlVR4ZFQj3r1h/GTyEiFAJ5Ul3XEcoFBkoIo0fOs14zixedszSXZKH8aRBIOPj0BxZteESDXY01WG2C/eyiO7wyhmZN7mRGstQ3ErZDpsodnSsFEObqtrCLITRu7wlGm88Nyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5L1yaOjjogGbhI3b+fikrqaBKDQ0ioKFYDDRmdBfsxc=;
 b=g3ZrZtppgdhOVBQ7qA+thhbKXjd6NcbzLABJKFUcV2ccVYLgV92dp+OVS2dWTdQmjwt5L0eJgMvASQjTrLx/2ZAL/8bU/AVoh9OxkhavisRTiDNLBG8Aoy1ssl1F2dRLlxVnpvad+6ZaU5F9nq0jm/+NEK+aOTVlzPZYj9eIj4/tiNZQY93yn1lsfU/M+zDk5S5bjVTQZg6YqhSDVs2IYdMfXQJz6OWFSHQ2zcjYqT7Sh1KwWLc3A99Ej+uzMsfNs6kUKNnDB1OzuDR6R73GoWKhdZTyOZ73EZmirpuK3NtzCGrUUX6SfXjKQfFo/eIiDp3nd+6FVt6fMA6V7IBQuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5L1yaOjjogGbhI3b+fikrqaBKDQ0ioKFYDDRmdBfsxc=;
 b=bMgI58CTGaeZwZy1nYvo1HfNlaMZw/ONMpq6O0tvGvkFtExhEktc5UJEppojsjlxTXr+br6T+efC01RczcGn/zHOpdJk9l4gIMT4rOwHZoAXwt3kh2WqlrI/hO3DcnUghvJheG6K5k5K83PNT7Ar/qYI43QkC3A/ZTCxJUfAP/Q=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB4941.eurprd05.prod.outlook.com (20.177.48.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.20; Thu, 23 Jan 2020 06:40:04 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096%6]) with mapi id 15.20.2644.027; Thu, 23 Jan 2020
 06:40:04 +0000
Received: from smtp.office365.com (73.15.39.150) by BYAPR21CA0027.namprd21.prod.outlook.com (2603:10b6:a03:114::37) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2686.5 via Frontend Transport; Thu, 23 Jan 2020 06:40:03 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Vlad Buslov <vladbu@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 15/15] net/mlx5e: Enable all available stats for uplink
 reps
Thread-Topic: [net-next 15/15] net/mlx5e: Enable all available stats for
 uplink reps
Thread-Index: AQHV0bfxbJoXrWDfO0OggaUMVclmWA==
Date:   Thu, 23 Jan 2020 06:40:04 +0000
Message-ID: <20200123063827.685230-16-saeedm@mellanox.com>
References: <20200123063827.685230-1-saeedm@mellanox.com>
In-Reply-To: <20200123063827.685230-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.24.1
x-originating-ip: [73.15.39.150]
x-clientproxiedby: BYAPR21CA0027.namprd21.prod.outlook.com
 (2603:10b6:a03:114::37) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 0ca440c0-717c-40e4-3ac5-08d79fcf1459
x-ms-traffictypediagnostic: VI1PR05MB4941:|VI1PR05MB4941:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB4941A7C023B3EEAA3A5CDC38BE0F0@VI1PR05MB4941.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1002;
x-forefront-prvs: 029174C036
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(396003)(39860400002)(376002)(346002)(366004)(199004)(189003)(5660300002)(107886003)(8936002)(6916009)(81166006)(81156014)(8676002)(186003)(6512007)(6486002)(4326008)(86362001)(1076003)(16526019)(71200400001)(26005)(36756003)(52116002)(6506007)(2906002)(66946007)(2616005)(66556008)(956004)(64756008)(66446008)(316002)(478600001)(54906003)(66476007)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4941;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: MqfJs1PHS5WHGP+LHJybfMbh6qgT2UiGTq9FO8tjirR4BSd3lXEGzGD6oRq66y+TQh1F0zGdqX3YL8/QQix2/CTSeVT7kP12Czswzhw1rzoVEkoV4c0JjvRaBkT9YjyZHnSFCi7eUu/hfTSLzoHG1NvLWraQmGLU18hLvn3+fZofisTiyK8309aFY7Yvs82OgY34rM64TPSOMcxwfWX+gjT9DEHydMfu/EDK6SIsdcPrev8/bPFBGcXlTW4GLXlOKmpNxwD0LLorBrbio71OcxKksyXFkbvdb7Vg3yNrevS5wCP//N/C79sM0KiN2k2axPjraI155A4onDqaOx8szUkBsDqlV3z76rgYi+JfO8MEkQFKQtkITeG1YFaW2biU8vQZ+MpL1IeDvQUTusRfYfeKX7USBQsE8hDQmBp8NNVNS2khiw30CzjedcN5CslEK0NhKp11GD8kaj84/7lQd1X8ZE/w17KkFpKv+hkZL8nPBDHggAE51mu1WAnjKo213d50BxS/Av4b5jOpqTCSo4oZvAay0uiZ5Ibe7DOJmMc=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ca440c0-717c-40e4-3ac5-08d79fcf1459
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jan 2020 06:40:04.5902
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RRkiKJV0095w8FhLbJZ4ielW0Lei+1PKhTy+JzFMf2jNaAniICZXtH60GC00MQD8V/0L6PQ826UwRqiiqQRKTg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4941
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vlad Buslov <vladbu@mellanox.com>

Extend stats group array of uplink representor with all stats that are
available for PF in legacy mode, besides ipsec and TLS which are not
supported.

Don't output vport stats for uplink representor because they are already
handled by 802_3 group (with different names: {tx|rx}_{bytes|packets}_phy).

Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_rep.c  | 44 +++++++------------
 .../ethernet/mellanox/mlx5/core/en_stats.c    |  4 +-
 .../ethernet/mellanox/mlx5/core/en_stats.h    |  3 +-
 3 files changed, 18 insertions(+), 33 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net=
/ethernet/mellanox/mlx5/core/en_rep.c
index f11c86d1b9b7..09061b4c43af 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -181,7 +181,7 @@ static MLX5E_DECLARE_STATS_GRP_OP_FILL_STATS(vport_rep)
 	return idx;
 }
=20
-static void mlx5e_vf_rep_update_hw_counters(struct mlx5e_priv *priv)
+static MLX5E_DECLARE_STATS_GRP_OP_UPDATE_STATS(vport_rep)
 {
 	struct mlx5_eswitch *esw =3D priv->mdev->priv.eswitch;
 	struct mlx5e_rep_priv *rpriv =3D priv->ppriv;
@@ -204,32 +204,6 @@ static void mlx5e_vf_rep_update_hw_counters(struct mlx=
5e_priv *priv)
 	vport_stats->tx_bytes   =3D vf_stats.rx_bytes;
 }
=20
-static void mlx5e_uplink_rep_update_hw_counters(struct mlx5e_priv *priv)
-{
-	struct mlx5e_pport_stats *pstats =3D &priv->stats.pport;
-	struct rtnl_link_stats64 *vport_stats;
-
-	MLX5E_STATS_GRP_OP(802_3, update_stats)(priv);
-
-	vport_stats =3D &priv->stats.vf_vport;
-
-	vport_stats->rx_packets =3D PPORT_802_3_GET(pstats, a_frames_received_ok)=
;
-	vport_stats->rx_bytes   =3D PPORT_802_3_GET(pstats, a_octets_received_ok)=
;
-	vport_stats->tx_packets =3D PPORT_802_3_GET(pstats, a_frames_transmitted_=
ok);
-	vport_stats->tx_bytes   =3D PPORT_802_3_GET(pstats, a_octets_transmitted_=
ok);
-}
-
-static MLX5E_DECLARE_STATS_GRP_OP_UPDATE_STATS(vport_rep)
-{
-	struct mlx5e_rep_priv *rpriv =3D priv->ppriv;
-	struct mlx5_eswitch_rep *rep =3D rpriv->rep;
-
-	if (rep->vport =3D=3D MLX5_VPORT_UPLINK)
-		mlx5e_uplink_rep_update_hw_counters(priv);
-	else
-		mlx5e_vf_rep_update_hw_counters(priv);
-}
-
 static void mlx5e_rep_get_strings(struct net_device *dev,
 				  u32 stringset, uint8_t *data)
 {
@@ -1908,8 +1882,20 @@ static unsigned int mlx5e_rep_stats_grps_num(struct =
mlx5e_priv *priv)
=20
 /* The stats groups order is opposite to the update_stats() order calls */
 static mlx5e_stats_grp_t mlx5e_ul_rep_stats_grps[] =3D {
-	&MLX5E_STATS_GRP(sw_rep),
-	&MLX5E_STATS_GRP(vport_rep),
+	&MLX5E_STATS_GRP(sw),
+	&MLX5E_STATS_GRP(qcnt),
+	&MLX5E_STATS_GRP(vnic_env),
+	&MLX5E_STATS_GRP(vport),
+	&MLX5E_STATS_GRP(802_3),
+	&MLX5E_STATS_GRP(2863),
+	&MLX5E_STATS_GRP(2819),
+	&MLX5E_STATS_GRP(phy),
+	&MLX5E_STATS_GRP(eth_ext),
+	&MLX5E_STATS_GRP(pcie),
+	&MLX5E_STATS_GRP(per_prio),
+	&MLX5E_STATS_GRP(pme),
+	&MLX5E_STATS_GRP(channels),
+	&MLX5E_STATS_GRP(per_port_buff_congest),
 };
=20
 static unsigned int mlx5e_ul_rep_stats_grps_num(struct mlx5e_priv *priv)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c b/drivers/n=
et/ethernet/mellanox/mlx5/core/en_stats.c
index ee5041747575..30b216d9284c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
@@ -630,7 +630,7 @@ static MLX5E_DECLARE_STATS_GRP_OP_FILL_STATS(802_3)
 #define MLX5_BASIC_PPCNT_SUPPORTED(mdev) \
 	(MLX5_CAP_GEN(mdev, pcam_reg) ? MLX5_CAP_PCAM_REG(mdev, ppcnt) : 1)
=20
-MLX5E_DECLARE_STATS_GRP_OP_UPDATE_STATS(802_3)
+static MLX5E_DECLARE_STATS_GRP_OP_UPDATE_STATS(802_3)
 {
 	struct mlx5e_pport_stats *pstats =3D &priv->stats.pport;
 	struct mlx5_core_dev *mdev =3D priv->mdev;
@@ -1713,7 +1713,7 @@ MLX5E_DEFINE_STATS_GRP(per_prio, 0);
 MLX5E_DEFINE_STATS_GRP(pme, 0);
 MLX5E_DEFINE_STATS_GRP(channels, 0);
 MLX5E_DEFINE_STATS_GRP(per_port_buff_congest, 0);
-static MLX5E_DEFINE_STATS_GRP(eth_ext, 0);
+MLX5E_DEFINE_STATS_GRP(eth_ext, 0);
 static MLX5E_DEFINE_STATS_GRP(ipsec, 0);
 static MLX5E_DEFINE_STATS_GRP(tls, 0);
=20
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h b/drivers/n=
et/ethernet/mellanox/mlx5/core/en_stats.h
index 4dc0b6e083f8..092b39ffa32a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
@@ -376,8 +376,6 @@ struct mlx5e_stats {
 extern mlx5e_stats_grp_t mlx5e_nic_stats_grps[];
 unsigned int mlx5e_nic_stats_grps_num(struct mlx5e_priv *priv);
=20
-MLX5E_DECLARE_STATS_GRP_OP_UPDATE_STATS(802_3);
-
 extern MLX5E_DECLARE_STATS_GRP(sw);
 extern MLX5E_DECLARE_STATS_GRP(qcnt);
 extern MLX5E_DECLARE_STATS_GRP(vnic_env);
@@ -386,6 +384,7 @@ extern MLX5E_DECLARE_STATS_GRP(802_3);
 extern MLX5E_DECLARE_STATS_GRP(2863);
 extern MLX5E_DECLARE_STATS_GRP(2819);
 extern MLX5E_DECLARE_STATS_GRP(phy);
+extern MLX5E_DECLARE_STATS_GRP(eth_ext);
 extern MLX5E_DECLARE_STATS_GRP(pcie);
 extern MLX5E_DECLARE_STATS_GRP(per_prio);
 extern MLX5E_DECLARE_STATS_GRP(pme);
--=20
2.24.1

