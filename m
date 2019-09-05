Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 553EBAAE14
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 23:51:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391060AbfIEVvd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Sep 2019 17:51:33 -0400
Received: from mail-eopbgr150045.outbound.protection.outlook.com ([40.107.15.45]:23041
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2391046AbfIEVvc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Sep 2019 17:51:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=id9C7GbVzBEPtekdA4TZ4cxqUR4KX8W6I5dRQmOJ6B4X00E9sCaSL/rUM02iiuRJDa62ykeNAqXm3NZg01YNQxOLC9BhR8vP0dqFDU8/d1ienwtG6DNaJZrgOsFl7gtw6uR8i6+OF67/PQaaU6rDV3VPqlG5qaRMKtMvOFRavDdzCecsSAlYcDCjd7OTcfO45urv8CF+fcLP95L8l7otJcfDjBWoyKCwpB8wd35cTD59GFPGgjG7blK4ZcsM4xQA7/tYAesY7plpWOCeFZdJrJbJfH+i5C5Mb5IhfqR9zI/nwBSIdYEe4W/u25F35ru8jA9ZzW5Mz4JT7cdv83oC9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=18Xhdq0mDNg/5XPLg9Fj7zJth8LOgMg8fIZyQ4bJknM=;
 b=gFFou8bHEqfImZsrMGmnXC7FCMGFXOWtceUhA8Gv1EoD5L5qBm3u1pikvwsZKe1G+NAuKNe64k8EJI9KQVAQYGbwpSOlsrdO0IrREXeiEMXe2AQDznTXoLOGZQcDA+TNoYII5rjSjTkMgBOEc+8Tvd8ziXuAZEljArsoVzyjl1liyUCRuHEouXGLvcgaW3QGXOF3Hl8X2aXlO2xuwaffxGcLHNww5cYMCytG4n5Qn43d/EcP/96ff1ZueBWbRSMhdCpxLDXjMc6NiZTH5PimMkGUDZwiizz4bVVAT3gZv20l1fFdjZMfBIOqveu6thkTO1YC4JQQz6Le3UrfxDXpZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=18Xhdq0mDNg/5XPLg9Fj7zJth8LOgMg8fIZyQ4bJknM=;
 b=JgfxooOe3Bqmci6SY+WWxgZZjLlWs/8S3/9miWGmvkXxyCTfJEFlFa5+arEZomPDzdYcJUHX/e8GOLVuSUbb3aGZkMUy7fO5URaIcfkK0yDVNYFbdP3j3Ki1aduZKD+x5MEooYhnZCrFIuOvz4aNPEFmMacwn6Ld3Cz3YSIB2zw=
Received: from VI1PR0501MB2765.eurprd05.prod.outlook.com (10.172.11.140) by
 VI1PR0501MB2768.eurprd05.prod.outlook.com (10.172.81.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2220.20; Thu, 5 Sep 2019 21:51:20 +0000
Received: from VI1PR0501MB2765.eurprd05.prod.outlook.com
 ([fe80::c4f0:4270:5311:f4b9]) by VI1PR0501MB2765.eurprd05.prod.outlook.com
 ([fe80::c4f0:4270:5311:f4b9%5]) with mapi id 15.20.2220.022; Thu, 5 Sep 2019
 21:51:20 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Aya Levin <ayal@mellanox.com>,
        Moshe Shemesh <moshe@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 14/14] net/mlx5e: Add port buffer's congestion counters
Thread-Topic: [net-next 14/14] net/mlx5e: Add port buffer's congestion
 counters
Thread-Index: AQHVZDQNJffO+StMg0WxHjGyGl+yvQ==
Date:   Thu, 5 Sep 2019 21:51:20 +0000
Message-ID: <20190905215034.22713-15-saeedm@mellanox.com>
References: <20190905215034.22713-1-saeedm@mellanox.com>
In-Reply-To: <20190905215034.22713-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR06CA0023.namprd06.prod.outlook.com
 (2603:10b6:a03:d4::36) To VI1PR0501MB2765.eurprd05.prod.outlook.com
 (2603:10a6:800:9a::12)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 313a376d-e9c8-431c-84a4-08d7324b2fa2
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600166)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:VI1PR0501MB2768;
x-ms-traffictypediagnostic: VI1PR0501MB2768:|VI1PR0501MB2768:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0501MB27680C7BFE080D25F504DAF3BEBB0@VI1PR0501MB2768.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:608;
x-forefront-prvs: 015114592F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(376002)(39860400002)(396003)(136003)(366004)(199004)(189003)(478600001)(86362001)(14454004)(446003)(486006)(2616005)(11346002)(7736002)(256004)(6916009)(305945005)(71190400001)(71200400001)(102836004)(476003)(6506007)(14444005)(66066001)(6512007)(386003)(2906002)(81156014)(52116002)(66476007)(66446008)(3846002)(36756003)(316002)(6436002)(53936002)(54906003)(107886003)(66946007)(8936002)(4326008)(64756008)(99286004)(81166006)(26005)(8676002)(186003)(5660300002)(50226002)(25786009)(6116002)(1076003)(6486002)(66556008)(76176011);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0501MB2768;H:VI1PR0501MB2765.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: FAJQ2/qa66eS+pTosR/KUBQaAjrcmUEoO9u8Y6AUeSEkmqAq+4P86wZ/vdTQbjRfe9pKuVq0g2JX6qfLkK/QcMH3tZq6TIea3p4gnTGYsxR2p5l+V9K2sb6Jf9mtU12uy8+aD/ZKoiDYBpPdugXoKFMmARAcKK/rHY1IOnmgTrM/jx+/VdZBvL8mC7LslwjvtHHcsg7ZXTdmN1xMl6MBLBulBoIKChHpfDKfiKawFNIsOvigtFzWPY0L96J1dW98J9c6ckm4kv6Lr+SQGvYDnWnuOCVwIvoQNC3StLYsSkFgrhOGFe0tTGZCoVn/pefSWwT8NRhHf+hyeiLze12pvgttvzRgSQsm1YObSqjt9Ai2zl+5XlkYwSIiLfX2TPQ9phTa1QRTAE3Me1SsVlyiZ+UCEgk22bPozM7huGRQbrQ=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 313a376d-e9c8-431c-84a4-08d7324b2fa2
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Sep 2019 21:51:20.1164
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mg4Nw9gXs8oUp+iN8bF26SClmHRr1BeK3EWn9FXyee/T9JYALWVnCdpNQw7EXkGUJz2/D0/HR/aCX5HfSwwVgg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0501MB2768
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@mellanox.com>

Add 3 counters per priority to ethtool using PPCNT:
1) rx_prio[p]_buf_discard - the number of packets discarded by device
   due to lack of per host receive buffers
2) rx_prio[p]_cong_discard - the number of packets discarded by device
   due to per host congestion
3) rx_prio[p]_marked - the number of packets ECN marked by device due
   to per host congestion

Signed-off-by: Aya Levin <ayal@mellanox.com>
Reviewed-by: Moshe Shemesh <moshe@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../ethernet/mellanox/mlx5/core/en_stats.c    | 149 +++++++++++++++++-
 .../ethernet/mellanox/mlx5/core/en_stats.h    |   2 +
 2 files changed, 150 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c b/drivers/n=
et/ethernet/mellanox/mlx5/core/en_stats.c
index f1065e78086a..ac6fdcda7019 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
@@ -981,6 +981,147 @@ static void mlx5e_grp_pcie_update_stats(struct mlx5e_=
priv *priv)
 	mlx5_core_access_reg(mdev, in, sz, out, sz, MLX5_REG_MPCNT, 0, 0);
 }
=20
+#define PPORT_PER_TC_PRIO_OFF(c) \
+	MLX5_BYTE_OFF(ppcnt_reg, \
+		      counter_set.eth_per_tc_prio_grp_data_layout.c##_high)
+
+static const struct counter_desc pport_per_tc_prio_stats_desc[] =3D {
+	{ "rx_prio%d_buf_discard", PPORT_PER_TC_PRIO_OFF(no_buffer_discard_uc) },
+};
+
+#define NUM_PPORT_PER_TC_PRIO_COUNTERS	ARRAY_SIZE(pport_per_tc_prio_stats_=
desc)
+
+#define PPORT_PER_TC_CONGEST_PRIO_OFF(c) \
+	MLX5_BYTE_OFF(ppcnt_reg, \
+		      counter_set.eth_per_tc_congest_prio_grp_data_layout.c##_high)
+
+static const struct counter_desc pport_per_tc_congest_prio_stats_desc[] =
=3D {
+	{ "rx_prio%d_cong_discard", PPORT_PER_TC_CONGEST_PRIO_OFF(wred_discard) }=
,
+	{ "rx_prio%d_marked", PPORT_PER_TC_CONGEST_PRIO_OFF(ecn_marked_tc) },
+};
+
+#define NUM_PPORT_PER_TC_CONGEST_PRIO_COUNTERS \
+	ARRAY_SIZE(pport_per_tc_congest_prio_stats_desc)
+
+static int mlx5e_grp_per_tc_prio_get_num_stats(struct mlx5e_priv *priv)
+{
+	struct mlx5_core_dev *mdev =3D priv->mdev;
+
+	if (!MLX5_CAP_GEN(mdev, sbcam_reg))
+		return 0;
+
+	return NUM_PPORT_PER_TC_PRIO_COUNTERS * NUM_PPORT_PRIO;
+}
+
+static int mlx5e_grp_per_port_buffer_congest_fill_strings(struct mlx5e_pri=
v *priv,
+							  u8 *data, int idx)
+{
+	struct mlx5_core_dev *mdev =3D priv->mdev;
+	int i, prio;
+
+	if (!MLX5_CAP_GEN(mdev, sbcam_reg))
+		return idx;
+
+	for (prio =3D 0; prio < NUM_PPORT_PRIO; prio++) {
+		for (i =3D 0; i < NUM_PPORT_PER_TC_PRIO_COUNTERS; i++)
+			sprintf(data + (idx++) * ETH_GSTRING_LEN,
+				pport_per_tc_prio_stats_desc[i].format, prio);
+		for (i =3D 0; i < NUM_PPORT_PER_TC_CONGEST_PRIO_COUNTERS; i++)
+			sprintf(data + (idx++) * ETH_GSTRING_LEN,
+				pport_per_tc_congest_prio_stats_desc[i].format, prio);
+	}
+
+	return idx;
+}
+
+static int mlx5e_grp_per_port_buffer_congest_fill_stats(struct mlx5e_priv =
*priv,
+							u64 *data, int idx)
+{
+	struct mlx5e_pport_stats *pport =3D &priv->stats.pport;
+	struct mlx5_core_dev *mdev =3D priv->mdev;
+	int i, prio;
+
+	if (!MLX5_CAP_GEN(mdev, sbcam_reg))
+		return idx;
+
+	for (prio =3D 0; prio < NUM_PPORT_PRIO; prio++) {
+		for (i =3D 0; i < NUM_PPORT_PER_TC_PRIO_COUNTERS; i++)
+			data[idx++] =3D
+				MLX5E_READ_CTR64_BE(&pport->per_tc_prio_counters[prio],
+						    pport_per_tc_prio_stats_desc, i);
+		for (i =3D 0; i < NUM_PPORT_PER_TC_CONGEST_PRIO_COUNTERS ; i++)
+			data[idx++] =3D
+				MLX5E_READ_CTR64_BE(&pport->per_tc_congest_prio_counters[prio],
+						    pport_per_tc_congest_prio_stats_desc, i);
+	}
+
+	return idx;
+}
+
+static void mlx5e_grp_per_tc_prio_update_stats(struct mlx5e_priv *priv)
+{
+	struct mlx5e_pport_stats *pstats =3D &priv->stats.pport;
+	struct mlx5_core_dev *mdev =3D priv->mdev;
+	u32 in[MLX5_ST_SZ_DW(ppcnt_reg)] =3D {};
+	int sz =3D MLX5_ST_SZ_BYTES(ppcnt_reg);
+	void *out;
+	int prio;
+
+	if (!MLX5_CAP_GEN(mdev, sbcam_reg))
+		return;
+
+	MLX5_SET(ppcnt_reg, in, pnat, 2);
+	MLX5_SET(ppcnt_reg, in, grp, MLX5_PER_TRAFFIC_CLASS_COUNTERS_GROUP);
+	for (prio =3D 0; prio < NUM_PPORT_PRIO; prio++) {
+		out =3D pstats->per_tc_prio_counters[prio];
+		MLX5_SET(ppcnt_reg, in, prio_tc, prio);
+		mlx5_core_access_reg(mdev, in, sz, out, sz, MLX5_REG_PPCNT, 0, 0);
+	}
+}
+
+static int mlx5e_grp_per_tc_congest_prio_get_num_stats(struct mlx5e_priv *=
priv)
+{
+	struct mlx5_core_dev *mdev =3D priv->mdev;
+
+	if (!MLX5_CAP_GEN(mdev, sbcam_reg))
+		return 0;
+
+	return NUM_PPORT_PER_TC_CONGEST_PRIO_COUNTERS * NUM_PPORT_PRIO;
+}
+
+static void mlx5e_grp_per_tc_congest_prio_update_stats(struct mlx5e_priv *=
priv)
+{
+	struct mlx5e_pport_stats *pstats =3D &priv->stats.pport;
+	struct mlx5_core_dev *mdev =3D priv->mdev;
+	u32 in[MLX5_ST_SZ_DW(ppcnt_reg)] =3D {};
+	int sz =3D MLX5_ST_SZ_BYTES(ppcnt_reg);
+	void *out;
+	int prio;
+
+	if (!MLX5_CAP_GEN(mdev, sbcam_reg))
+		return;
+
+	MLX5_SET(ppcnt_reg, in, pnat, 2);
+	MLX5_SET(ppcnt_reg, in, grp, MLX5_PER_TRAFFIC_CLASS_CONGESTION_GROUP);
+	for (prio =3D 0; prio < NUM_PPORT_PRIO; prio++) {
+		out =3D pstats->per_tc_congest_prio_counters[prio];
+		MLX5_SET(ppcnt_reg, in, prio_tc, prio);
+		mlx5_core_access_reg(mdev, in, sz, out, sz, MLX5_REG_PPCNT, 0, 0);
+	}
+}
+
+static int mlx5e_grp_per_port_buffer_congest_get_num_stats(struct mlx5e_pr=
iv *priv)
+{
+	return mlx5e_grp_per_tc_prio_get_num_stats(priv) +
+		mlx5e_grp_per_tc_congest_prio_get_num_stats(priv);
+}
+
+static void mlx5e_grp_per_port_buffer_congest_update_stats(struct mlx5e_pr=
iv *priv)
+{
+	mlx5e_grp_per_tc_prio_update_stats(priv);
+	mlx5e_grp_per_tc_congest_prio_update_stats(priv);
+}
+
 #define PPORT_PER_PRIO_OFF(c) \
 	MLX5_BYTE_OFF(ppcnt_reg, \
 		      counter_set.eth_per_prio_grp_data_layout.c##_high)
@@ -1610,7 +1751,13 @@ const struct mlx5e_stats_grp mlx5e_stats_grps[] =3D =
{
 		.get_num_stats =3D mlx5e_grp_channels_get_num_stats,
 		.fill_strings =3D mlx5e_grp_channels_fill_strings,
 		.fill_stats =3D mlx5e_grp_channels_fill_stats,
-	}
+	},
+	{
+		.get_num_stats =3D mlx5e_grp_per_port_buffer_congest_get_num_stats,
+		.fill_strings =3D mlx5e_grp_per_port_buffer_congest_fill_strings,
+		.fill_stats =3D mlx5e_grp_per_port_buffer_congest_fill_stats,
+		.update_stats =3D mlx5e_grp_per_port_buffer_congest_update_stats,
+	},
 };
=20
 const int mlx5e_num_stats_grps =3D ARRAY_SIZE(mlx5e_stats_grps);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h b/drivers/n=
et/ethernet/mellanox/mlx5/core/en_stats.h
index c281e567711d..79f261bf86ac 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
@@ -207,6 +207,8 @@ struct mlx5e_pport_stats {
 	__be64 phy_counters[MLX5_ST_SZ_QW(ppcnt_reg)];
 	__be64 phy_statistical_counters[MLX5_ST_SZ_QW(ppcnt_reg)];
 	__be64 eth_ext_counters[MLX5_ST_SZ_QW(ppcnt_reg)];
+	__be64 per_tc_prio_counters[NUM_PPORT_PRIO][MLX5_ST_SZ_QW(ppcnt_reg)];
+	__be64 per_tc_congest_prio_counters[NUM_PPORT_PRIO][MLX5_ST_SZ_QW(ppcnt_r=
eg)];
 };
=20
 #define PCIE_PERF_GET(pcie_stats, c) \
--=20
2.21.0

