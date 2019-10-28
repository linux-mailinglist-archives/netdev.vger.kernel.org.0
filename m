Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB002E7D04
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 00:35:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732114AbfJ1Xfe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 19:35:34 -0400
Received: from mail-eopbgr140045.outbound.protection.outlook.com ([40.107.14.45]:60804
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731587AbfJ1Xfd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Oct 2019 19:35:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T8sWOyVfPZYUyXnKjXrINO/AsjKBT8F2G+IPAECC1Dwm3ac011uegmTCNhh0vwrNVgvrPGP/wSZUBd/Sq1SARGjlb57lNsK8ndisoILsdAm/xcI2GHjttQPL0iWzDrTTbqWCDzbF1qO/1vsw0IiuvrmkmWhnpMV6hS6+dBR/RP33OTS+cLL2h2poA7AvsIGeP5YrMXRUREGcMdjLOnri3KH+hrXjICZ+vMBqsEkVmUvSKLM8/wsf9hmCvntjy/z97XGnSXSrHrepFcVaIK1zKPVICaYVOL7wDLMChJu8uJGYFPlXycahDmlvrGSKZN29s32cPJmoQq/YD9r0MR3m1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QeJjmzKhEywJSU93qyKmjFtwwNhqu6857JTjscfMJH8=;
 b=K2U6LxkLphEd3igxEL7sQch3u+8q3oPu1Yofv8R6r0DKbc+hr0dY+JuylA/LWIXN/OuEBfMeycSpr79rwzPyh18fnh3kMj86cDkV1dhv0W/fBCesNRM2W1CkZhwFcGFLXcoNMEskrwTJBxMhwQRhCQxG0HjmujLv2lKlhfVojm9Zhv4YeWVQJLHK5ziV450u5j7yJqfvcE9CdYXbNnpvsE/wZSVYR+9lBY7c/oEhk+1Y4tDkS9l6ofRtNCUhmHMXJ4T5VLE/Ci/eLtdKMv571Phs8eJB9fUtUjWQmQa+1DYB/u65YESeHpcXxE+VTCgzY2vjnCxJeW99cJpubmOuzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QeJjmzKhEywJSU93qyKmjFtwwNhqu6857JTjscfMJH8=;
 b=C5t5vwSTC6nz5Py42o/Ec9EbqurY2Gpbj9sAbQIgJQnVLeoPwQCxp4Uqj4VIptf+PK3M16HMOgpa43yvnBY08lef812nXNdBweCrF9Gga1hAwIpRZh3QHiQUck8n/OCSbjVrY5+vxYwOOwGNSDttOv9lusYohGP5Mbb4TwH4M6o=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB6413.eurprd05.prod.outlook.com (20.179.27.87) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2387.22; Mon, 28 Oct 2019 23:35:30 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e%5]) with mapi id 15.20.2387.027; Mon, 28 Oct 2019
 23:35:30 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Parav Pandit <parav@mellanox.com>,
        Vu Pham <vuhuong@mellanox.com>
Subject: [PATCH mlx5-next 18/18] IB/mlx5: Introduce and use mlx5_core_is_vf()
Thread-Topic: [PATCH mlx5-next 18/18] IB/mlx5: Introduce and use
 mlx5_core_is_vf()
Thread-Index: AQHVjehij0L0yaLA+kOfepHA9RmoEg==
Date:   Mon, 28 Oct 2019 23:35:30 +0000
Message-ID: <20191028233440.5564-19-saeedm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: 5eee1152-871d-4ffa-7fc2-08d75bff8519
x-ms-traffictypediagnostic: VI1PR05MB6413:|VI1PR05MB6413:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB64133482326EEDF3F9E7E708BE660@VI1PR05MB6413.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1091;
x-forefront-prvs: 0204F0BDE2
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(39860400002)(396003)(366004)(376002)(346002)(199004)(189003)(71200400001)(256004)(316002)(6636002)(14444005)(2906002)(6436002)(446003)(8936002)(50226002)(11346002)(6486002)(8676002)(486006)(14454004)(110136005)(36756003)(81166006)(6116002)(81156014)(54906003)(3846002)(86362001)(7736002)(66066001)(99286004)(450100002)(102836004)(6512007)(1076003)(5660300002)(6506007)(4326008)(478600001)(386003)(476003)(186003)(26005)(66476007)(66556008)(64756008)(66946007)(66446008)(305945005)(76176011)(71190400001)(52116002)(107886003)(25786009)(2616005);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB6413;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2fwfibhL8+LH0g0jf2N3AhXHNhuL/PlE1j50stCqPFb/Jkvwk6JYiXqLmTlgclZN/fggThfPsryXrtH8X+Uu/3dAe9vsGgpNqThm302qdCXp2XoDjn/Kgps4gQUqOBpBAWl4tbiv2oEvahDkYPXFY/JL+OCbOesejnGuf4EAsLfs4BOE0YrJRAinjiNSVi/13n4LUbYXxUvcfs/K3XLU87YLdQCdq/lLk7Sjp22QhBxDZAM9ubsO6o3v0Y7v03Y5oL4XEDB5qru8AyXYjvtiGdo+sLY8AasqdDyEafDbXLqGSbyeEPYd5mg/vFDRmTN1Gb8IAYbvHeLnFpNGS2WSxhf26+6Qzejpn/iJJP6QHxEhttrLMDVCjVFdMSsQVyugJ8gZviX5JO8oNWgfOWop6NVQr72Yr5I+IO7VOQ6m/ltQl4oHU6LyrTVbzQRY1ksS
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5eee1152-871d-4ffa-7fc2-08d75bff8519
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Oct 2019 23:35:30.5692
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bdjCicoM0LB7RTUocS8cQu3YpFSy/cWRUrdCKeBK46s5TrxCv17HfMYA9HUR/FEeN4pee557V0i5wgVvilVpDg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6413
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Parav Pandit <parav@mellanox.com>

Instead of deciding a given device is virtual function or
not based on a device is PF or not, use already defined
MLX5_COREDEV_VF by introducing an helper API mlx5_core_is_vf().

This enables to clearly identify PF, VF and non virtual functions.

Signed-off-by: Parav Pandit <parav@mellanox.com>
Reviewed-by: Vu Pham <vuhuong@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/infiniband/hw/mlx5/main.c | 2 +-
 include/linux/mlx5/driver.h       | 5 +++++
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5=
/main.c
index 831539419c30..8343a740c91e 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -1031,7 +1031,7 @@ static int mlx5_ib_query_device(struct ib_device *ibd=
ev,
 	if (MLX5_CAP_GEN(mdev, cd))
 		props->device_cap_flags |=3D IB_DEVICE_CROSS_CHANNEL;
=20
-	if (!mlx5_core_is_pf(mdev))
+	if (mlx5_core_is_vf(mdev))
 		props->device_cap_flags |=3D IB_DEVICE_VIRTUAL_FUNCTION;
=20
 	if (mlx5_ib_port_link_layer(ibdev, 1) =3D=3D
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 3e80f03a387f..7b4801e96feb 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -1121,6 +1121,11 @@ static inline bool mlx5_core_is_pf(const struct mlx5=
_core_dev *dev)
 	return dev->coredev_type =3D=3D MLX5_COREDEV_PF;
 }
=20
+static inline bool mlx5_core_is_vf(const struct mlx5_core_dev *dev)
+{
+	return dev->coredev_type =3D=3D MLX5_COREDEV_VF;
+}
+
 static inline bool mlx5_core_is_ecpf(struct mlx5_core_dev *dev)
 {
 	return dev->caps.embedded_cpu;
--=20
2.21.0

