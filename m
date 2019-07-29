Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B11779D0B
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 01:50:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729904AbfG2Xuf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 19:50:35 -0400
Received: from mail-eopbgr130078.outbound.protection.outlook.com ([40.107.13.78]:57824
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729105AbfG2Xue (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Jul 2019 19:50:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gpdO3k5YgBic+l5c9pKKgIJXrPWCOogJVw1hucPTaWjeGm8JXD2kpqbiwWQVf0FA/a26iqXJ08atM2BsVV/bxZ/x1T/8tKKtaZODxynEaAlbSPO4mPNyC2KN4a0Jzm/9KaQ4GMsaAKOS2gZwq8rSGv9YqgdYcOPcnmTIZpfrcG6r4HNXtR8VBNnW6moCty1ZL4z/5PXXU3yLsd+ZjbZwC4pWQLxQlGzRJZMDy55zcbSsaXZXcekddMSL42z4GZ0zag+tL2O0CUKZZQi4b3XlfOA3ugN9paGeZmmLz8Bc9iGk+l7zXCO4SZd+wK9Z0bUy/rvKhmT3zUPPkvpSwX6sUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hBXBnXvzj/hFG68L5sMLfqHEt4WimobrLSwzzliITnY=;
 b=aw4XygPUghHfDbVfgfcVCzhyH17fQybg7tWI7ZuV9eRi0avQRbQ/J/wD38NEf8aSR9uSK4VkOM/NeoK0af3HUJR8oZ9MD+MQvs/HsHUl51f6oymYuW2eTYpVlDrux7MHp+/ODApoHiwG/sJ50aieTvQ1lDfmFqnkECCJNqs9IcWsbjJ54k+qUyUE/hspJw+1uwKY3CD1oQWkcaKIbVJkcllh/rexH2JeDElALHxrVMa+8EAuC6s0u80a4Nox4mBSMzJ0tYKh/dzn4MV4h9wOhWNhj0NDxEHGB9Opg+k3ltG/aIzR3SOOTJtyPTrVwZsD/ye2Z1XFC77qMEmdltftRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=mellanox.com;dmarc=pass action=none
 header.from=mellanox.com;dkim=pass header.d=mellanox.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hBXBnXvzj/hFG68L5sMLfqHEt4WimobrLSwzzliITnY=;
 b=JMIi6xRBA0iSt1znzIY1V1DnvHnQwhTnPj1LyMDyjZeK1p9xZS+QtY5kad1NTKq9wylpGgZfhxu+5cK6rdVKHLCwT+IgcmTS79n3o99IZwLzLFmLo8tgWML16VgUDcVtRquOSXTuUmlU72zXefoCBh3paCo4NaDEv5pndAzt0g4=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2343.eurprd05.prod.outlook.com (10.168.56.136) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.15; Mon, 29 Jul 2019 23:50:19 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2%5]) with mapi id 15.20.2115.005; Mon, 29 Jul 2019
 23:50:19 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>
Subject: [net-next 03/13] net/mlx5e: Improve ethtool rxnfc callback structure
Thread-Topic: [net-next 03/13] net/mlx5e: Improve ethtool rxnfc callback
 structure
Thread-Index: AQHVRmhhhzQqHorrLE2v/i76Z0b0kQ==
Date:   Mon, 29 Jul 2019 23:50:19 +0000
Message-ID: <20190729234934.23595-4-saeedm@mellanox.com>
References: <20190729234934.23595-1-saeedm@mellanox.com>
In-Reply-To: <20190729234934.23595-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR05CA0015.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::28) To DB6PR0501MB2759.eurprd05.prod.outlook.com
 (2603:10a6:4:84::7)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 091c3226-05cc-41b5-7771-08d7147f8374
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2343;
x-ms-traffictypediagnostic: DB6PR0501MB2343:
x-microsoft-antispam-prvs: <DB6PR0501MB2343E077D7BE58655CFE1B01BEDD0@DB6PR0501MB2343.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 01136D2D90
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(366004)(346002)(39860400002)(376002)(136003)(199004)(189003)(14454004)(25786009)(71190400001)(71200400001)(386003)(6506007)(6512007)(81166006)(81156014)(76176011)(8936002)(6436002)(8676002)(6486002)(316002)(102836004)(54906003)(6916009)(7736002)(478600001)(52116002)(186003)(26005)(99286004)(256004)(476003)(5660300002)(1076003)(66446008)(66066001)(66556008)(66476007)(64756008)(36756003)(53936002)(486006)(86362001)(305945005)(107886003)(66946007)(68736007)(446003)(2616005)(11346002)(50226002)(6116002)(3846002)(4326008)(2906002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2343;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: lXqQhM48t9dwFslLD24l2UJhEcV73OinwGLRtbWLcnl6ib7z/ZZ+MYoay3sasi5oMse8oeTVJxN/8Jy16DQqeXvX2Hv9sKkLxRaVGrYSfZ0oKCs4WDGXPxkeLMOyl/ZopsL1C4OZRJShdPJTQQplDUh/9+C0gbq8wDH71FpNIjfX+ltRMu870hLbg54qdByu9r64ZNbGCoHSlB3oHs8av7e2YpfB/fXLHtOipGJgOziog4j0E7ptMDRKqpCqmUVusuj+ljghw1TYSTiza6KB+fQ8m1xs74piO7WTEoNSYoIDe9bRFDhXqMJrGicTeoh95y6SWBY9vRPNynMdsge2PRIa4r6UhZM/iysuRj+lv6eueN+UHUypAOwk89K/iFZWoQYy8LM3usSQXkUSoO2O8SbRmyMMHIwRahrjG3arjCc=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 091c3226-05cc-41b5-7771-08d7147f8374
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jul 2019 23:50:19.6863
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2343
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Don't choose who implements the rxnfc "get/set" callbacks according to
CONFIG_MLX5_EN_RXNFC, instead have the callbacks always available and
delegate to a function of a different driver module when needed
(en_fs_ethtool.c), have stubs in en/fs.h to fallback to when
en_fs_ethtool.c is compiled out, to avoid complications and ifdefs in
en_main.c.

Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/en/fs.h   | 11 ++++++--
 .../ethernet/mellanox/mlx5/core/en_ethtool.c  | 28 +++++++++++--------
 .../mellanox/mlx5/core/en_fs_ethtool.c        | 11 +++-----
 3 files changed, 28 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h b/drivers/net/=
ethernet/mellanox/mlx5/core/en/fs.h
index be5961ff24cc..eb70ada89b09 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
@@ -132,12 +132,17 @@ struct mlx5e_ethtool_steering {
=20
 void mlx5e_ethtool_init_steering(struct mlx5e_priv *priv);
 void mlx5e_ethtool_cleanup_steering(struct mlx5e_priv *priv);
-int mlx5e_set_rxnfc(struct net_device *dev, struct ethtool_rxnfc *cmd);
-int mlx5e_get_rxnfc(struct net_device *dev,
-		    struct ethtool_rxnfc *info, u32 *rule_locs);
+int mlx5e_ethtool_set_rxnfc(struct net_device *dev, struct ethtool_rxnfc *=
cmd);
+int mlx5e_ethtool_get_rxnfc(struct net_device *dev,
+			    struct ethtool_rxnfc *info, u32 *rule_locs);
 #else
 static inline void mlx5e_ethtool_init_steering(struct mlx5e_priv *priv)   =
 { }
 static inline void mlx5e_ethtool_cleanup_steering(struct mlx5e_priv *priv)=
 { }
+static inline int mlx5e_ethtool_set_rxnfc(struct net_device *dev, struct e=
thtool_rxnfc *cmd)
+{ return -EOPNOTSUPP; }
+static inline int mlx5e_ethtool_get_rxnfc(struct net_device *dev,
+					  struct ethtool_rxnfc *info, u32 *rule_locs)
+{ return -EOPNOTSUPP; }
 #endif /* CONFIG_MLX5_EN_RXNFC */
=20
 #ifdef CONFIG_MLX5_EN_ARFS
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c b/drivers=
/net/ethernet/mellanox/mlx5/core/en_ethtool.c
index 126ec4181286..a6b0eda0bd1a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
@@ -1888,21 +1888,27 @@ static u32 mlx5e_get_priv_flags(struct net_device *=
netdev)
 	return priv->channels.params.pflags;
 }
=20
-#ifndef CONFIG_MLX5_EN_RXNFC
-/* When CONFIG_MLX5_EN_RXNFC=3Dn we only support ETHTOOL_GRXRINGS
- * otherwise this function will be defined from en_fs_ethtool.c
- */
 static int mlx5e_get_rxnfc(struct net_device *dev, struct ethtool_rxnfc *i=
nfo, u32 *rule_locs)
 {
 	struct mlx5e_priv *priv =3D netdev_priv(dev);
=20
-	if (info->cmd !=3D ETHTOOL_GRXRINGS)
-		return -EOPNOTSUPP;
-	/* ring_count is needed by ethtool -x */
-	info->data =3D priv->channels.params.num_channels;
-	return 0;
+	/* ETHTOOL_GRXRINGS is needed by ethtool -x which is not part
+	 * of rxnfc. We keep this logic out of mlx5e_ethtool_get_rxnfc,
+	 * to avoid breaking "ethtool -x" when mlx5e_ethtool_get_rxnfc
+	 * is compiled out via CONFIG_MLX5_EN_RXNFC=3Dn.
+	 */
+	if (info->cmd =3D=3D ETHTOOL_GRXRINGS) {
+		info->data =3D priv->channels.params.num_channels;
+		return 0;
+	}
+
+	return mlx5e_ethtool_get_rxnfc(dev, info, rule_locs);
+}
+
+static int mlx5e_set_rxnfc(struct net_device *dev, struct ethtool_rxnfc *c=
md)
+{
+	return mlx5e_ethtool_set_rxnfc(dev, cmd);
 }
-#endif
=20
 const struct ethtool_ops mlx5e_ethtool_ops =3D {
 	.get_drvinfo       =3D mlx5e_get_drvinfo,
@@ -1923,9 +1929,7 @@ const struct ethtool_ops mlx5e_ethtool_ops =3D {
 	.get_rxfh          =3D mlx5e_get_rxfh,
 	.set_rxfh          =3D mlx5e_set_rxfh,
 	.get_rxnfc         =3D mlx5e_get_rxnfc,
-#ifdef CONFIG_MLX5_EN_RXNFC
 	.set_rxnfc         =3D mlx5e_set_rxnfc,
-#endif
 	.get_tunable       =3D mlx5e_get_tunable,
 	.set_tunable       =3D mlx5e_set_tunable,
 	.get_pauseparam    =3D mlx5e_get_pauseparam,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_fs_ethtool.c b/driv=
ers/net/ethernet/mellanox/mlx5/core/en_fs_ethtool.c
index ea3a490b569a..a66589816e21 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_fs_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_fs_ethtool.c
@@ -887,10 +887,10 @@ static int mlx5e_get_rss_hash_opt(struct mlx5e_priv *=
priv,
 	return 0;
 }
=20
-int mlx5e_set_rxnfc(struct net_device *dev, struct ethtool_rxnfc *cmd)
+int mlx5e_ethtool_set_rxnfc(struct net_device *dev, struct ethtool_rxnfc *=
cmd)
 {
-	int err =3D 0;
 	struct mlx5e_priv *priv =3D netdev_priv(dev);
+	int err =3D 0;
=20
 	switch (cmd->cmd) {
 	case ETHTOOL_SRXCLSRLINS:
@@ -910,16 +910,13 @@ int mlx5e_set_rxnfc(struct net_device *dev, struct et=
htool_rxnfc *cmd)
 	return err;
 }
=20
-int mlx5e_get_rxnfc(struct net_device *dev,
-		    struct ethtool_rxnfc *info, u32 *rule_locs)
+int mlx5e_ethtool_get_rxnfc(struct net_device *dev,
+			    struct ethtool_rxnfc *info, u32 *rule_locs)
 {
 	struct mlx5e_priv *priv =3D netdev_priv(dev);
 	int err =3D 0;
=20
 	switch (info->cmd) {
-	case ETHTOOL_GRXRINGS:
-		info->data =3D priv->channels.params.num_channels;
-		break;
 	case ETHTOOL_GRXCLSRLCNT:
 		info->rule_cnt =3D priv->fs.ethtool.tot_num_rules;
 		break;
--=20
2.21.0

