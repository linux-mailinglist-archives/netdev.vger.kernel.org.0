Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 643C88F3E2
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 20:47:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732219AbfHOSrP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 14:47:15 -0400
Received: from mail-eopbgr00074.outbound.protection.outlook.com ([40.107.0.74]:55213
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728579AbfHOSrO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Aug 2019 14:47:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OEhvcbi5okC2+cR18qTHsVTmQEw9mEUDZ9EbCHJYH/xhtTJK30prQ5Y9bMHm9q29Mw8Vb4eZQzqwGspB7qfwoW6ymf2j0CdBncquQDh99aRgsSSBuOASNiF0ub8LCz7TiZ3RlTChFK5902TXtpr1F0jL59MHZEumg2hoCUOvzpS8MS/TXdQ1IonkuipCYJQVuHY8hWY+MIzUKhUdcqpS6YMVrsHApduu59+FogPkb4M0OHPbCIPGJcVm7tS9aMtk2/84Kk6M3v15fTDgF9zLp+ltGRXBLf93PVDX26hoUlrvZ1BhwP5Op8mvDp44i7IFvGBXhizjLBzJad/T01e4Pw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0/tUQsRHmkVr231V6AbJxeGs3DKZ9JXnZ8j8qEnSLqA=;
 b=fPFteAG2jvF+cwvQcNukRHgZBg2Een3AzDku/HUwvek9yCs6sYPIimhjKI5tcZ+vAeyb072IhB2c1oks9OfGuAG5nd92I37LziclSfc8NGL2iZ4uzrDXpgb/Od850fedZ9A9JuZ7sKi56N+Qgdfy83sSAmatOk+dpRehlu6VvAtEaPLeOz1wkUm/Z0g0LYkir4P1/nOyQvbiQhI/Zegdvxr6zIUWMTt86ipEIk8+sMAbOHF7z8UU5mVlCvqMfvIL8/OtB+mVC9skhrElJ/VygtSsyYmNZUDt3jQfdWDYMOKAJjbcCxzWpYxuJx0kejdO/j12ZK2znNsAVE+waC23rA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0/tUQsRHmkVr231V6AbJxeGs3DKZ9JXnZ8j8qEnSLqA=;
 b=LnhY/h0VU0mlXWqfb4BoutThtDz45CenymuVXEKUWXUj2I8ac80cOPwqdKhvHSCXtSY1GhtYc7uurummKAwuJMgL8qe6xaiAqld74hwW/QuF2bSg1lxrp7j+ON8/OSHM8sX9O8wKPScGc/vNKzt2QEYGCFVVIAJwWRkoRC/MXWI=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2663.eurprd05.prod.outlook.com (10.172.225.148) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.18; Thu, 15 Aug 2019 18:47:08 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2%5]) with mapi id 15.20.2178.016; Thu, 15 Aug 2019
 18:47:08 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 2/2] net/mlx5e: Fix compatibility issue with ethtool flash
 device
Thread-Topic: [net 2/2] net/mlx5e: Fix compatibility issue with ethtool flash
 device
Thread-Index: AQHVU5nXZ8ip6HhX6kqxdRGKd3dfTA==
Date:   Thu, 15 Aug 2019 18:47:08 +0000
Message-ID: <20190815184639.8206-3-saeedm@mellanox.com>
References: <20190815184639.8206-1-saeedm@mellanox.com>
In-Reply-To: <20190815184639.8206-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR04CA0032.namprd04.prod.outlook.com
 (2603:10b6:a03:40::45) To DB6PR0501MB2759.eurprd05.prod.outlook.com
 (2603:10a6:4:84::7)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2491482b-79cf-40b6-9eef-08d721b0f9c1
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2663;
x-ms-traffictypediagnostic: DB6PR0501MB2663:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB6PR0501MB2663F6596D62DCF35A74DA18BEAC0@DB6PR0501MB2663.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3968;
x-forefront-prvs: 01304918F3
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(136003)(346002)(39860400002)(366004)(376002)(189003)(199004)(53936002)(11346002)(446003)(52116002)(26005)(107886003)(6916009)(386003)(76176011)(102836004)(476003)(36756003)(478600001)(8676002)(14454004)(66066001)(81156014)(2616005)(81166006)(6506007)(486006)(50226002)(4326008)(1076003)(6486002)(6436002)(5660300002)(71190400001)(64756008)(6116002)(66946007)(2906002)(3846002)(71200400001)(14444005)(305945005)(54906003)(66556008)(316002)(186003)(256004)(25786009)(7736002)(66446008)(66476007)(86362001)(99286004)(8936002)(6512007);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2663;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: epzeW8sLT4nNy6RN2ihiZ37XJFCE8Q9X7T3d8CCt7UZIZ1UOpcCalDd7Ufv6lXghUzlRnCTY9fARmeUqnOqeccIDqq/eDod87lvlnXsYQuJ2WmAK/kQRERoAvWfevWnod9gSBEW4QMVCcPM65yHwRj+/AJEHVBfkMJbraew8IidPZiBftCT9mtzyn8u9l89TbSAqV5x+9TsTtBI9D+vms11rdvce4+MFpEMv2IEh5u90Em1Ld9m3Hor6wZ2odIBfyAug+OeTmS3m5xG9Wix2MxPnNmPH5rorDH0EEJPwXxyVOUKnxFiUs7f8vs9yLJySr4pHUuK7soSxzS1vvRJu2B1Pp0adcXXsJA++n48p5W2Uh0QmoWcImniDfC0K9bso10rA8qQvYPsPmRS4uUSeoYlhFVlgXRK+JTdWmAj7Myc=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2491482b-79cf-40b6-9eef-08d721b0f9c1
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Aug 2019 18:47:08.7699
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MvtlpsnbavCv7Gjg0TcToebSMWIumFokoud/jNzbg/xbJkJVUUXasIJJpSXT9uCcpRdvdayuXJHVlHYq4qItwQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2663
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eran Ben Elisha <eranbe@mellanox.com>

Cited patch deleted ethtool flash device support, as ethtool core can
fallback into devlink flash callback. However, this is supported only if
there is a devlink port registered over the corresponding netdevice.

As mlx5e do not have devlink port support over native netdevice, it broke
the ability to flash device via ethtool.

This patch re-add the ethtool callback to avoid user functionality breakage
when trying to flash device via ethtool.

Fixes: 9c8bca2637b8 ("mlx5: Move firmware flash implementation to devlink")
Signed-off-by: Eran Ben Elisha <eranbe@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |  2 ++
 .../ethernet/mellanox/mlx5/core/en_ethtool.c  | 35 +++++++++++++++++++
 .../mellanox/mlx5/core/ipoib/ethtool.c        |  9 +++++
 3 files changed, 46 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/eth=
ernet/mellanox/mlx5/core/en.h
index f6b64a03cd06..65bec19a438f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -1105,6 +1105,8 @@ u32 mlx5e_ethtool_get_rxfh_key_size(struct mlx5e_priv=
 *priv);
 u32 mlx5e_ethtool_get_rxfh_indir_size(struct mlx5e_priv *priv);
 int mlx5e_ethtool_get_ts_info(struct mlx5e_priv *priv,
 			      struct ethtool_ts_info *info);
+int mlx5e_ethtool_flash_device(struct mlx5e_priv *priv,
+			       struct ethtool_flash *flash);
 void mlx5e_ethtool_get_pauseparam(struct mlx5e_priv *priv,
 				  struct ethtool_pauseparam *pauseparam);
 int mlx5e_ethtool_set_pauseparam(struct mlx5e_priv *priv,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c b/drivers=
/net/ethernet/mellanox/mlx5/core/en_ethtool.c
index e89dba790a2d..20e628c907e5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
@@ -1690,6 +1690,40 @@ static int mlx5e_get_module_eeprom(struct net_device=
 *netdev,
 	return 0;
 }
=20
+int mlx5e_ethtool_flash_device(struct mlx5e_priv *priv,
+			       struct ethtool_flash *flash)
+{
+	struct mlx5_core_dev *mdev =3D priv->mdev;
+	struct net_device *dev =3D priv->netdev;
+	const struct firmware *fw;
+	int err;
+
+	if (flash->region !=3D ETHTOOL_FLASH_ALL_REGIONS)
+		return -EOPNOTSUPP;
+
+	err =3D request_firmware_direct(&fw, flash->data, &dev->dev);
+	if (err)
+		return err;
+
+	dev_hold(dev);
+	rtnl_unlock();
+
+	err =3D mlx5_firmware_flash(mdev, fw, NULL);
+	release_firmware(fw);
+
+	rtnl_lock();
+	dev_put(dev);
+	return err;
+}
+
+static int mlx5e_flash_device(struct net_device *dev,
+			      struct ethtool_flash *flash)
+{
+	struct mlx5e_priv *priv =3D netdev_priv(dev);
+
+	return mlx5e_ethtool_flash_device(priv, flash);
+}
+
 static int set_pflag_cqe_based_moder(struct net_device *netdev, bool enabl=
e,
 				     bool is_rx_cq)
 {
@@ -1972,6 +2006,7 @@ const struct ethtool_ops mlx5e_ethtool_ops =3D {
 	.set_wol	   =3D mlx5e_set_wol,
 	.get_module_info   =3D mlx5e_get_module_info,
 	.get_module_eeprom =3D mlx5e_get_module_eeprom,
+	.flash_device      =3D mlx5e_flash_device,
 	.get_priv_flags    =3D mlx5e_get_priv_flags,
 	.set_priv_flags    =3D mlx5e_set_priv_flags,
 	.self_test         =3D mlx5e_self_test,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ethtool.c b/driv=
ers/net/ethernet/mellanox/mlx5/core/ipoib/ethtool.c
index ebd81f6b556e..90cb50fe17fd 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ethtool.c
@@ -122,6 +122,14 @@ static int mlx5i_get_ts_info(struct net_device *netdev=
,
 	return mlx5e_ethtool_get_ts_info(priv, info);
 }
=20
+static int mlx5i_flash_device(struct net_device *netdev,
+			      struct ethtool_flash *flash)
+{
+	struct mlx5e_priv *priv =3D mlx5i_epriv(netdev);
+
+	return mlx5e_ethtool_flash_device(priv, flash);
+}
+
 enum mlx5_ptys_width {
 	MLX5_PTYS_WIDTH_1X	=3D 1 << 0,
 	MLX5_PTYS_WIDTH_2X	=3D 1 << 1,
@@ -233,6 +241,7 @@ const struct ethtool_ops mlx5i_ethtool_ops =3D {
 	.get_ethtool_stats  =3D mlx5i_get_ethtool_stats,
 	.get_ringparam      =3D mlx5i_get_ringparam,
 	.set_ringparam      =3D mlx5i_set_ringparam,
+	.flash_device       =3D mlx5i_flash_device,
 	.get_channels       =3D mlx5i_get_channels,
 	.set_channels       =3D mlx5i_set_channels,
 	.get_coalesce       =3D mlx5i_get_coalesce,
--=20
2.21.0

