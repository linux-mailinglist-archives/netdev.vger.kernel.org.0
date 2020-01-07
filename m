Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3408F132F1C
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 20:14:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728759AbgAGTOR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 14:14:17 -0500
Received: from mail-vi1eur05on2080.outbound.protection.outlook.com ([40.107.21.80]:6105
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728747AbgAGTOQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Jan 2020 14:14:16 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eZ2J4DhFHd0ZqDNw7BdwZGXSh53iPWlV3B/CblonFu2nhz0zptdYk9wfwaM6c7WBWU+2dUR8QeCo+F88XAlb8kMowDkpHZWMgPxKR/ZZ/C26dQWFgsFIm0d3+iE0KVZWWqEt08QdycfIT10LluBDrhLoQh/QtjOfS8ySUdJsHcsCY2GzxGdBXRrvyOututn/zbICD5ych2X7dadjXmMCqFmVk9/j2iuluymA4jUhlUCm++6w6KhVvRwA1NOYtOJrRBWB4oF2VR7h+YmjSOM9f/G3zYIKTsBVaT1U4HyOOSoMlJpXbCPcaRN1uSmT6XEwqE52NZMPci1GT/AdA++e2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i6RBhsOO+92UsiW7UjKt7igQ/KmD5LArQwcE7CjjF6M=;
 b=J6BvldoSZmIFEfispax1qOFpOHH9Ty5C7WFAJpjYC+ARDgqWD1tX44ryEu6ZRIk5TiH01rKuaB0PogtL/UOw1yz4aX4syk2izS9qyuEKApMplPcx3U2iFnqZWVPbx4O2bvNDd8kMqhqfPg4yy9qlTdLLufHmuWOOsMLorHytJrHIfpBqGu81+Pob320FDK33FC+JpNOgM+Gekfrt9dMXJjVTHAgNdojQ7lki5gbaZPuoik6KjTWS+gGpkBTNrUON3gmaVhYtf8og+4fw+mB/UKIqcZyUnR/3mo5jChInuikGHUySQ0TTT4SE32E0bvVUMF428jmjwiGPvtwQijU//Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i6RBhsOO+92UsiW7UjKt7igQ/KmD5LArQwcE7CjjF6M=;
 b=drg+P4j1a8V7ET60q/zDfK7gexmVsk4UuuBbVLjvZvzdmzyHnO52WM6tfc/Mc0k2Pm9FC9Wp7XF3ISkQt6FKBDGcsvWJ+7e4he3GlOV/jhiENDTMjEnz1I//gLfEpggrkfnKmMqhGTyyq9g1CtbWh1vmM3OH7vPU1ArpUaqpVgM=
Received: from AM6PR05MB5094.eurprd05.prod.outlook.com (20.177.34.93) by
 AM6PR05MB5411.eurprd05.prod.outlook.com (20.177.189.90) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2602.11; Tue, 7 Jan 2020 19:14:12 +0000
Received: from AM6PR05MB5094.eurprd05.prod.outlook.com
 ([fe80::d9f3:f3b8:86b2:a40a]) by AM6PR05MB5094.eurprd05.prod.outlook.com
 ([fe80::d9f3:f3b8:86b2:a40a%7]) with mapi id 15.20.2602.015; Tue, 7 Jan 2020
 19:14:12 +0000
Received: from smtp.office365.com (209.116.155.178) by BYAPR06CA0068.namprd06.prod.outlook.com (2603:10b6:a03:14b::45) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2581.12 via Frontend Transport; Tue, 7 Jan 2020 19:14:11 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Fan Li <fanl@mellanox.com>, Tariq Toukan <tariqt@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 04/13] net/mlx5: Increase the max number of channels to 128
Thread-Topic: [net-next 04/13] net/mlx5: Increase the max number of channels
 to 128
Thread-Index: AQHVxY6lXM8blMx3EUWLOQITbzeyow==
Date:   Tue, 7 Jan 2020 19:14:12 +0000
Message-ID: <20200107191335.12272-5-saeedm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: b823c5ca-1e79-4b0b-4449-08d793a5c7a1
x-ms-traffictypediagnostic: AM6PR05MB5411:|AM6PR05MB5411:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM6PR05MB5411444AB7A2CD64BAC13A43BE3F0@AM6PR05MB5411.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1284;
x-forefront-prvs: 027578BB13
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(366004)(136003)(346002)(39860400002)(376002)(199004)(189003)(81166006)(52116002)(6916009)(8936002)(81156014)(8676002)(26005)(86362001)(36756003)(316002)(5660300002)(107886003)(6506007)(4326008)(478600001)(1076003)(16526019)(956004)(2616005)(2906002)(66446008)(64756008)(66556008)(66476007)(71200400001)(66946007)(6486002)(6512007)(54906003)(186003)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR05MB5411;H:AM6PR05MB5094.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0MWmH4QVsJvE68Ja2GMW4FqhIYUqBckykW0O6wRFK5Vq9VW5e2yYqwinj8JVa65w/XmsjCdDAqPbFg3vJlY4f0vsru+sgyUowCgMCpYdUzwbbufbqKfY37iAX5YgaUlz9xNhx7PXEkgN09YbV19+SIxbDZg9rcs+fKehlanCQxrjMl4hMF5YFbdNETP1BgxyvaktQqz70Bl405utsowjlEE5OvOWazVjoGBNm4eIDREJMh7BBVYXmA3ZbLMP+1OBhGooEqMx0btM6A4zuxXKgS4rlUoAu58T3ywxWI6kXuPdNPy5ZZ89nA+kjlomIFX29+T8O2Vm9klx+x62eKLesGyTkY/3SZnIhgJSxeSdy+2Bcpzk3rnXHuJr559u/D+t8NILtbH/qWbbEKtQZeLY9uHuS3h2k367OT+FbWodXljpgHbBCtwpj2HocRUEaFQ21Cf7wESUaiQhpx38kkX1gsMwCkuWwPcfKBLCn5SPu4pp7JzGRJrTF2rOis8c+j3vlMVAVJoI5yk6oEX2ON4am9elbTCE7KF/B/ibLDG/c6M=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b823c5ca-1e79-4b0b-4449-08d793a5c7a1
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jan 2020 19:14:12.5785
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mO9UZq1fiAwsKfVomE6TBUUFE0IQl8HUuo3kOp9pNlWTLDsDnj58Q1ZFaHq8z0l9yicmLshhX2gHYAb51DwRGg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB5411
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Fan Li <fanl@mellanox.com>

Currently the max number of channels is limited to 64, which is half of
the indirection table size to allow some flexibility. But on servers
with more than 64 cores, users may want to utilize more queues.

This patch increases the advertised max number of channels to 128 by
changing the ratio between channels and indirection table slots to 1:1.
At the same time, the driver still enable no more than 64 channels at
loading. Users can change it by ethtool afterwards.

Signed-off-by: Fan Li <fanl@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h         |  6 +++---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c    | 12 +++++++-----
 .../net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c    |  4 ++--
 3 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/eth=
ernet/mellanox/mlx5/core/en.h
index 9c8427698238..fc80b59db9a8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -135,7 +135,7 @@ struct page_pool;
 #define MLX5E_LOG_INDIR_RQT_SIZE       0x7
 #define MLX5E_INDIR_RQT_SIZE           BIT(MLX5E_LOG_INDIR_RQT_SIZE)
 #define MLX5E_MIN_NUM_CHANNELS         0x1
-#define MLX5E_MAX_NUM_CHANNELS         (MLX5E_INDIR_RQT_SIZE >> 1)
+#define MLX5E_MAX_NUM_CHANNELS         MLX5E_INDIR_RQT_SIZE
 #define MLX5E_MAX_NUM_SQS              (MLX5E_MAX_NUM_CHANNELS * MLX5E_MAX=
_NUM_TC)
 #define MLX5E_TX_CQ_POLL_BUDGET        128
 #define MLX5E_TX_XSK_POLL_BUDGET       64
@@ -1175,11 +1175,11 @@ int mlx5e_attach_netdev(struct mlx5e_priv *priv);
 void mlx5e_detach_netdev(struct mlx5e_priv *priv);
 void mlx5e_destroy_netdev(struct mlx5e_priv *priv);
 void mlx5e_set_netdev_mtu_boundaries(struct mlx5e_priv *priv);
-void mlx5e_build_nic_params(struct mlx5_core_dev *mdev,
+void mlx5e_build_nic_params(struct mlx5e_priv *priv,
 			    struct mlx5e_xsk *xsk,
 			    struct mlx5e_rss_params *rss_params,
 			    struct mlx5e_params *params,
-			    u16 max_channels, u16 mtu);
+			    u16 mtu);
 void mlx5e_build_rq_params(struct mlx5_core_dev *mdev,
 			   struct mlx5e_params *params);
 void mlx5e_build_rss_params(struct mlx5e_rss_params *rss_params,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/ne=
t/ethernet/mellanox/mlx5/core/en_main.c
index 319b39f25592..78737fd42616 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -4739,17 +4739,19 @@ void mlx5e_build_rss_params(struct mlx5e_rss_params=
 *rss_params,
 			tirc_default_config[tt].rx_hash_fields;
 }
=20
-void mlx5e_build_nic_params(struct mlx5_core_dev *mdev,
+void mlx5e_build_nic_params(struct mlx5e_priv *priv,
 			    struct mlx5e_xsk *xsk,
 			    struct mlx5e_rss_params *rss_params,
 			    struct mlx5e_params *params,
-			    u16 max_channels, u16 mtu)
+			    u16 mtu)
 {
+	struct mlx5_core_dev *mdev =3D priv->mdev;
 	u8 rx_cq_period_mode;
=20
 	params->sw_mtu =3D mtu;
 	params->hard_mtu =3D MLX5E_ETH_HARD_MTU;
-	params->num_channels =3D max_channels;
+	params->num_channels =3D min_t(unsigned int, MLX5E_MAX_NUM_CHANNELS / 2,
+				     priv->max_nch);
 	params->num_tc       =3D 1;
=20
 	/* SQ */
@@ -4986,8 +4988,8 @@ static int mlx5e_nic_init(struct mlx5_core_dev *mdev,
 	if (err)
 		return err;
=20
-	mlx5e_build_nic_params(mdev, &priv->xsk, rss, &priv->channels.params,
-			       priv->max_nch, netdev->mtu);
+	mlx5e_build_nic_params(priv, &priv->xsk, rss, &priv->channels.params,
+			       netdev->mtu);
=20
 	mlx5e_timestamp_init(priv);
=20
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c b/driver=
s/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
index 3ed8ab2d703d..7c87f523e370 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
@@ -87,8 +87,8 @@ int mlx5i_init(struct mlx5_core_dev *mdev,
 	mlx5e_set_netdev_mtu_boundaries(priv);
 	netdev->mtu =3D netdev->max_mtu;
=20
-	mlx5e_build_nic_params(mdev, NULL, &priv->rss_params, &priv->channels.par=
ams,
-			       priv->max_nch, netdev->mtu);
+	mlx5e_build_nic_params(priv, NULL, &priv->rss_params, &priv->channels.par=
ams,
+			       netdev->mtu);
 	mlx5i_build_nic_params(mdev, &priv->channels.params);
=20
 	mlx5e_timestamp_init(priv);
--=20
2.24.1

