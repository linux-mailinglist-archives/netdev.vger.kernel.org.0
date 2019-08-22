Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8FFB49A3E2
	for <lists+netdev@lfdr.de>; Fri, 23 Aug 2019 01:37:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726832AbfHVXgl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 19:36:41 -0400
Received: from mail-eopbgr50056.outbound.protection.outlook.com ([40.107.5.56]:39558
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726560AbfHVXgl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Aug 2019 19:36:41 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Fq2EdpSTWET0ojyYC+3voPLRDJIAl6KmwWdyhZVF82zsyP7iH045/9X6ZImkEJuwal/mEGKGEjoyqDDRpki9RnKoPLLAdFCzXVR/6KjjCtzS+Z4NANN9vVqMVL92sBbv52LCAXP9eobio1zZlvkEcD2LJJ7GUKM4FkLi7/f1O88sR0KgzpOfQdwC3CnA8nKFbVSwj51DcK7e7prZHCyYAjbhKp8shZ2HEVdm9kDcMyX8S0omMIlbFGybxcstiFdg/AMirPKwsvEKEj66V/lumdRwU3UhHo0hYq1R+rirRUew1M5KJBSLeDH0MYfACAzyfTv625e+8BFC+tDCEKnKIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Sebw+yNWN5prR11L6Q/XxeAR0OgnsdCZ/81o8knf14A=;
 b=X0kqfpHrgmc8h+TfTx9pmyFF/JwPl2xG8DJaBUh6T04AuHu+ije4KclTNxsCdDPo47R26Z14mgV50cIBpreZtTvtWVEVzpqyVxHVHpVdhV4qfgiTheGRY5muLhh78SxDOt6yIpfJfgU7sWwU0Ca+gY1SGiakbiFld1Acjks0v5OCfx8X3yA9v3tWEBaWAHY0zmBlUFQGyU7pBPsBOU2wy0OKI9J5Lw0bB/mvi6hthfqgTBpF1KLinoCsHSMERppaJoG9bQPrrebl18pXXi/otf7t1ZQuBzDMbj60vrdF1rKWd/meZfFnyuqiRjHvr5Zj2NEaFIvaH0J4HYeSB6HjDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Sebw+yNWN5prR11L6Q/XxeAR0OgnsdCZ/81o8knf14A=;
 b=V7dYwBGsDlp3m+3qmT6q139CJsLWYfFAcX2WqtTUHiiTVX8X9t+XFh6d53H6hNY8HFEnvUC0muYkXJwDz+aojhKxC22NN6wRZdSsPHMMLnqr7QD3BMxzzKTo0w6p42qWtjDlDR/XurLwu4n77CFlOnjHUE133rkeyqKB+NODlB0=
Received: from AM4PR0501MB2756.eurprd05.prod.outlook.com (10.172.216.138) by
 AM4PR0501MB2817.eurprd05.prod.outlook.com (10.172.215.144) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.18; Thu, 22 Aug 2019 23:35:52 +0000
Received: from AM4PR0501MB2756.eurprd05.prod.outlook.com
 ([fe80::e414:3306:9996:bb7a]) by AM4PR0501MB2756.eurprd05.prod.outlook.com
 ([fe80::e414:3306:9996:bb7a%4]) with mapi id 15.20.2178.020; Thu, 22 Aug 2019
 23:35:52 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Moshe Shemesh <moshe@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 4/8] net/mlx5e: Add device out of buffer counter
Thread-Topic: [net-next 4/8] net/mlx5e: Add device out of buffer counter
Thread-Index: AQHVWUJWlLdQtLGJp0+FOnAm6Qwlfg==
Date:   Thu, 22 Aug 2019 23:35:52 +0000
Message-ID: <20190822233514.31252-5-saeedm@mellanox.com>
References: <20190822233514.31252-1-saeedm@mellanox.com>
In-Reply-To: <20190822233514.31252-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR06CA0036.namprd06.prod.outlook.com
 (2603:10b6:a03:d4::49) To AM4PR0501MB2756.eurprd05.prod.outlook.com
 (2603:10a6:200:5c::10)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d76aa01a-a867-413c-cc2f-08d727597856
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600166)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:AM4PR0501MB2817;
x-ms-traffictypediagnostic: AM4PR0501MB2817:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM4PR0501MB2817BFADC23D930D75D61F29BEA50@AM4PR0501MB2817.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2150;
x-forefront-prvs: 01371B902F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(376002)(346002)(39860400002)(396003)(136003)(189003)(199004)(256004)(14444005)(53936002)(14454004)(107886003)(6436002)(4326008)(8676002)(8936002)(81166006)(99286004)(81156014)(50226002)(25786009)(76176011)(316002)(54906003)(52116002)(5660300002)(71190400001)(71200400001)(186003)(386003)(66066001)(6506007)(476003)(102836004)(305945005)(1076003)(486006)(446003)(11346002)(66446008)(64756008)(66556008)(66476007)(66946007)(36756003)(6916009)(6512007)(2906002)(2616005)(26005)(3846002)(86362001)(7736002)(478600001)(6486002)(6116002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR0501MB2817;H:AM4PR0501MB2756.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: D2jSyUWZd8yHPeaX7yQS2j31IegChPhlTP3tjYsVovvj2jywazxZFNO2xygYzwcR8LKbuRJd0pfPPF35k3Zra5KBqZYbQuGrMjkgqt9GotFKpmJzfxNJdMIK4tkmXyx7sFiO0j/RY0A6ltL2jNK9Y9ZO0ti5mQu547MUdxZyt/D7EONw63BW3Hv6vm3xYTMCqcmxXd3w5EpkFFg6hbmSinEt6ZqPc0xpaQHDygMB+ke9iIeSYFIHzFCTreeQsTBNvu1/45PwK2g01zLUaMcwLvRd/pT2C8AgQ+9loPe6ioRQWrdcjImzojG0qgi1NvPsQaXJXYOTbVxhvZsUxXSVcRJ6dIbw1lhnG5DBCpEqtglV84BDm3NgZwKt+DKmLiqDW9VF+CK/mmQZb/lImjs9FuBLbQazTLmSA6g4fnvgTAI=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d76aa01a-a867-413c-cc2f-08d727597856
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Aug 2019 23:35:52.3860
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fLuM4fAOSLvti7xuV9TAPq7sqmU1x3t3ab4fnpdQphw7QeW+C7jVFbG3TMx2K7mC9iwQu5Yac7STM6FPCXNr5A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR0501MB2817
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Moshe Shemesh <moshe@mellanox.com>

Added the following packets drop counter:
Device out of buffer - counts packets which were dropped due to full
device internal receive queue.
This counter will be shown on ethtool as a new counter called
dev_out_of_buffer.
The counter is read from FW by command QUERY_VNIC_ENV.

Signed-off-by: Moshe Shemesh <moshe@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../ethernet/mellanox/mlx5/core/en_stats.c    | 38 ++++++++++++-------
 1 file changed, 25 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c b/drivers/n=
et/ethernet/mellanox/mlx5/core/en_stats.c
index 18e4c162256a..fbf7fe2f2657 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
@@ -369,17 +369,27 @@ static void mlx5e_grp_q_update_stats(struct mlx5e_pri=
v *priv)
 }
=20
 #define VNIC_ENV_OFF(c) MLX5_BYTE_OFF(query_vnic_env_out, c)
-static const struct counter_desc vnic_env_stats_desc[] =3D {
+static const struct counter_desc vnic_env_stats_steer_desc[] =3D {
 	{ "rx_steer_missed_packets",
 		VNIC_ENV_OFF(vport_env.nic_receive_steering_discard) },
 };
=20
-#define NUM_VNIC_ENV_COUNTERS		ARRAY_SIZE(vnic_env_stats_desc)
+static const struct counter_desc vnic_env_stats_dev_oob_desc[] =3D {
+	{ "dev_out_of_buffer",
+		VNIC_ENV_OFF(vport_env.internal_rq_out_of_buffer) },
+};
+
+#define NUM_VNIC_ENV_STEER_COUNTERS(dev) \
+	(MLX5_CAP_GEN(dev, nic_receive_steering_discard) ? \
+	 ARRAY_SIZE(vnic_env_stats_steer_desc) : 0)
+#define NUM_VNIC_ENV_DEV_OOB_COUNTERS(dev) \
+	(MLX5_CAP_GEN(dev, vnic_env_int_rq_oob) ? \
+	 ARRAY_SIZE(vnic_env_stats_dev_oob_desc) : 0)
=20
 static int mlx5e_grp_vnic_env_get_num_stats(struct mlx5e_priv *priv)
 {
-	return MLX5_CAP_GEN(priv->mdev, nic_receive_steering_discard) ?
-		NUM_VNIC_ENV_COUNTERS : 0;
+	return NUM_VNIC_ENV_STEER_COUNTERS(priv->mdev) +
+		NUM_VNIC_ENV_DEV_OOB_COUNTERS(priv->mdev);
 }
=20
 static int mlx5e_grp_vnic_env_fill_strings(struct mlx5e_priv *priv, u8 *da=
ta,
@@ -387,12 +397,13 @@ static int mlx5e_grp_vnic_env_fill_strings(struct mlx=
5e_priv *priv, u8 *data,
 {
 	int i;
=20
-	if (!MLX5_CAP_GEN(priv->mdev, nic_receive_steering_discard))
-		return idx;
+	for (i =3D 0; i < NUM_VNIC_ENV_STEER_COUNTERS(priv->mdev); i++)
+		strcpy(data + (idx++) * ETH_GSTRING_LEN,
+		       vnic_env_stats_steer_desc[i].format);
=20
-	for (i =3D 0; i < NUM_VNIC_ENV_COUNTERS; i++)
+	for (i =3D 0; i < NUM_VNIC_ENV_DEV_OOB_COUNTERS(priv->mdev); i++)
 		strcpy(data + (idx++) * ETH_GSTRING_LEN,
-		       vnic_env_stats_desc[i].format);
+		       vnic_env_stats_dev_oob_desc[i].format);
 	return idx;
 }
=20
@@ -401,12 +412,13 @@ static int mlx5e_grp_vnic_env_fill_stats(struct mlx5e=
_priv *priv, u64 *data,
 {
 	int i;
=20
-	if (!MLX5_CAP_GEN(priv->mdev, nic_receive_steering_discard))
-		return idx;
-
-	for (i =3D 0; i < NUM_VNIC_ENV_COUNTERS; i++)
+	for (i =3D 0; i < NUM_VNIC_ENV_STEER_COUNTERS(priv->mdev); i++)
 		data[idx++] =3D MLX5E_READ_CTR64_BE(priv->stats.vnic.query_vnic_env_out,
-						  vnic_env_stats_desc, i);
+						  vnic_env_stats_steer_desc, i);
+
+	for (i =3D 0; i < NUM_VNIC_ENV_DEV_OOB_COUNTERS(priv->mdev); i++)
+		data[idx++] =3D MLX5E_READ_CTR32_BE(priv->stats.vnic.query_vnic_env_out,
+						  vnic_env_stats_dev_oob_desc, i);
 	return idx;
 }
=20
--=20
2.21.0

