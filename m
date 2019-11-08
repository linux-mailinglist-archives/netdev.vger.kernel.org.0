Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1555AF5BFF
	for <lists+netdev@lfdr.de>; Sat,  9 Nov 2019 00:45:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729973AbfKHXpi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 18:45:38 -0500
Received: from mail-eopbgr70072.outbound.protection.outlook.com ([40.107.7.72]:11398
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726640AbfKHXpi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Nov 2019 18:45:38 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ONeOfssIQPjBz8ex3Ai8MeSH9yeKeoTIIDjjpAF5VKl4jUIo1vnhzY9YK7PA9HdJGCa2V2TrUjKQB/1wNIOp3Qp+m/jpMxxHLKSMxvMs67/QDsyDVsaRMTpbDMayWbpxQhjmbSDvjUzraB75bq9Tv9xnEfOdtUva2nzuUcQLxHd3Yaw2GSHEhZzxqk4R+ZRi8pRIP6gFCg6s72Cmo/y/AwSvp3XhnJ+MuQeZJcUryQq/NXTbea3HVq/u9XmJNREsCeq83w1fixO+uK7WmHl67pUJBD5vgDNkxV+2St6ROnwV+ATWRqFpC4fj2je0TPOPT/9MOYaOHnTT9zwwxF5h0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=idJgm98GIKO+oVDEEcP93mknZAWQ36hc2cZ0gG6UTuY=;
 b=gAvmDSULyYeR3CbFB8zbWX6bSnS8/O01/sYbMVDASEuorTabRYEbLkqsEiie9fcTZvOdZU+4xOOdbWzEtOgwinYiXAliI9lILun4YeX61IT45XLqaGx+NZWdjyLLVDLJjhIF5WgaLVab8wnaYNPWWxPpVMw3/LYk7jUTB7mzyuxJ6KR74k7Slx7kBqtnvjo720PExy9ZaFOHLkWgzncfh19nXRZp+sTifPHwPyocd8R8g3+3yJ7hZI0/hVMGda8POak8NnQEH9CM5l+se9wV2n1Zmfet9W73tWEKk/08UVCb9xA5IukTrt8rxc3lhs8TDbzafW/+brBkORoPG5IgLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=idJgm98GIKO+oVDEEcP93mknZAWQ36hc2cZ0gG6UTuY=;
 b=atypCSxidba72QzGZLc38JHS3WDBO/E0Bd8J0HaTCPDH3qoMR0zbeougWj7GNV08cTZuHMqwdBM086oHr1IXAjw1dF1GAMGWg4Ep8k3dCd0nlrhQR4C7v/xnpWfZWdhHwPVLFqvOXl5vN2KcJbOpxkoQCVHLc9q4N1tWMsbMT5o=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB4334.eurprd05.prod.outlook.com (52.133.14.30) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.22; Fri, 8 Nov 2019 23:45:28 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e%5]) with mapi id 15.20.2430.023; Fri, 8 Nov 2019
 23:45:28 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>
CC:     Jiri Pirko <jiri@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Michael Guralnik <michaelgur@mellanox.com>,
        Maor Gottlieb <maorg@mellanox.com>
Subject: [PATCH mlx5-next 5/5] IB/mlx5: Load profile according to RoCE
 enablement state
Thread-Topic: [PATCH mlx5-next 5/5] IB/mlx5: Load profile according to RoCE
 enablement state
Thread-Index: AQHVlo6ZAC9IYd90fUmSMsgGmMmAbQ==
Date:   Fri, 8 Nov 2019 23:45:28 +0000
Message-ID: <20191108234451.31660-6-saeedm@mellanox.com>
References: <20191108234451.31660-1-saeedm@mellanox.com>
In-Reply-To: <20191108234451.31660-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR21CA0030.namprd21.prod.outlook.com
 (2603:10b6:a03:114::40) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 1d5619f4-f6aa-46de-e016-08d764a5bbfc
x-ms-traffictypediagnostic: VI1PR05MB4334:|VI1PR05MB4334:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB43347EB9FA740883FE49AA18BE7B0@VI1PR05MB4334.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3276;
x-forefront-prvs: 0215D7173F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(366004)(136003)(396003)(376002)(39860400002)(189003)(199004)(2616005)(102836004)(36756003)(450100002)(52116002)(486006)(71200400001)(1076003)(71190400001)(6636002)(107886003)(14454004)(4326008)(478600001)(110136005)(256004)(66946007)(25786009)(66476007)(66556008)(64756008)(66446008)(86362001)(5660300002)(316002)(6506007)(6116002)(8936002)(50226002)(3846002)(186003)(6436002)(6486002)(81156014)(446003)(8676002)(26005)(14444005)(2906002)(76176011)(305945005)(99286004)(6512007)(386003)(7736002)(66066001)(54906003)(11346002)(81166006)(476003);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4334;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: J5+qvuees15q/TwRhJnWK03+6WvwuNSdRfbD6JPvGKCub+qQPML3W+WC3cq3TlIB0mbfeAINp794/IcmJRVB9+WAMZErfHod+cojzzXayjeuISwLu2Tt+emf6q9e71RgauQ/9vJZOlFKwtLD1UDGIEAvv3uwBUijs5CsbeF8EMzkXWXHSRt8CMys35q5FFTTEbWCjbnpNi8eN3meCUCJgKzEnNFoyEgZE3Y6lq8/hRbiXTCmQ+CEgYaWOvUQLsv5OKqH9pPCrGkHgkWIV7FfMkVBOYRwzIGuDdf72ML4gldnFxK71Pwu0ojB8dlH2UGuNeim6p/8zJrUW4lPVx2RhF5eGPmGAACB5qEJ64q0JejOeP+gkTfZwIee0ekaY9uNLf+w/qacBYFIcv7FE2pVkYWdKE9oS5jZIuOtIgzwCNhXpQZj36vwGrsGdUyE+uji
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d5619f4-f6aa-46de-e016-08d764a5bbfc
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Nov 2019 23:45:28.5895
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RjwDMoGjvNWrCqVQZaFTlwzwUtQbE6nybD0RtLJ/G0rEA6XqBpTRD1gTGjjFw1TobGuOFb0WXcfOe3Hczmiblw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4334
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michael Guralnik <michaelgur@mellanox.com>

When RoCE is disabled load mlx5_ib in raw_eth profile.
Clean pf_profile roce capability checks as it will not be used without
roce capability.

Signed-off-by: Michael Guralnik <michaelgur@mellanox.com>
Reviewed-by: Maor Gottlieb <maorg@mellanox.com>
Reviewed-by: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/infiniband/hw/mlx5/main.c | 25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5=
/main.c
index d6afe33d56ac..46ea4f0b9b51 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -5145,8 +5145,7 @@ static int mlx5_port_immutable(struct ib_device *ibde=
v, u8 port_num,
 	immutable->pkey_tbl_len =3D attr.pkey_tbl_len;
 	immutable->gid_tbl_len =3D attr.gid_tbl_len;
 	immutable->core_cap_flags =3D get_core_cap_flags(ibdev, &rep);
-	if ((ll =3D=3D IB_LINK_LAYER_INFINIBAND) || MLX5_CAP_GEN(dev->mdev, roce)=
)
-		immutable->max_mad_size =3D IB_MGMT_MAD_SIZE;
+	immutable->max_mad_size =3D IB_MGMT_MAD_SIZE;
=20
 	return 0;
 }
@@ -5249,11 +5248,9 @@ static int mlx5_enable_eth(struct mlx5_ib_dev *dev)
 {
 	int err;
=20
-	if (MLX5_CAP_GEN(dev->mdev, roce)) {
-		err =3D mlx5_nic_vport_enable_roce(dev->mdev);
-		if (err)
-			return err;
-	}
+	err =3D mlx5_nic_vport_enable_roce(dev->mdev);
+	if (err)
+		return err;
=20
 	err =3D mlx5_eth_lag_init(dev);
 	if (err)
@@ -5262,8 +5259,7 @@ static int mlx5_enable_eth(struct mlx5_ib_dev *dev)
 	return 0;
=20
 err_disable_roce:
-	if (MLX5_CAP_GEN(dev->mdev, roce))
-		mlx5_nic_vport_disable_roce(dev->mdev);
+	mlx5_nic_vport_disable_roce(dev->mdev);
=20
 	return err;
 }
@@ -5271,8 +5267,7 @@ static int mlx5_enable_eth(struct mlx5_ib_dev *dev)
 static void mlx5_disable_eth(struct mlx5_ib_dev *dev)
 {
 	mlx5_eth_lag_cleanup(dev);
-	if (MLX5_CAP_GEN(dev->mdev, roce))
-		mlx5_nic_vport_disable_roce(dev->mdev);
+	mlx5_nic_vport_disable_roce(dev->mdev);
 }
=20
 struct mlx5_ib_counter {
@@ -6898,6 +6893,7 @@ static void *mlx5_ib_add_slave_port(struct mlx5_core_=
dev *mdev)
=20
 static void *mlx5_ib_add(struct mlx5_core_dev *mdev)
 {
+	const struct mlx5_ib_profile *profile;
 	enum rdma_link_layer ll;
 	struct mlx5_ib_dev *dev;
 	int port_type_cap;
@@ -6933,7 +6929,12 @@ static void *mlx5_ib_add(struct mlx5_core_dev *mdev)
 	dev->mdev =3D mdev;
 	dev->num_ports =3D num_ports;
=20
-	return __mlx5_ib_add(dev, &pf_profile);
+	if (ll =3D=3D IB_LINK_LAYER_ETHERNET && !mlx5_is_roce_enabled(mdev))
+		profile =3D &raw_eth_profile;
+	else
+		profile =3D &pf_profile;
+
+	return __mlx5_ib_add(dev, profile);
 }
=20
 static void mlx5_ib_remove(struct mlx5_core_dev *mdev, void *context)
--=20
2.21.0

