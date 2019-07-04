Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 538F25FCC7
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 20:16:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727311AbfGDSQN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 14:16:13 -0400
Received: from mail-eopbgr60046.outbound.protection.outlook.com ([40.107.6.46]:28482
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726794AbfGDSQM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Jul 2019 14:16:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d2ADcqbnv/Z/Nauo0AhK9dJFH7KwCSq8uQE6ABtCBb4=;
 b=HSVRruQzbP+PtOvk4cUnNDbmvVUP4+YdUZIG7eRiFkdyJpRTc2XXPSsgtEAzMr4FG4FW2FmF5yq9qt/rpoScO5XSLeklt5HHHAMG3CH6JQ9S1r4F5p7qPdBbrFrpoPWCXeSvioG59Hz4ZWq9ZfjPID50d+CGl3hSHJmSf+Dt3mY=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2584.eurprd05.prod.outlook.com (10.168.74.135) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2032.20; Thu, 4 Jul 2019 18:15:57 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::c1b3:b3a8:bced:493c]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::c1b3:b3a8:bced:493c%4]) with mapi id 15.20.2032.019; Thu, 4 Jul 2019
 18:15:57 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@mellanox.com>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 06/14] net/mlx5: Accel, Add core TLS support for the
 Connect-X family
Thread-Topic: [net-next 06/14] net/mlx5: Accel, Add core TLS support for the
 Connect-X family
Thread-Index: AQHVMpSGuZr6aG/3xUqlbGMzJAYvlA==
Date:   Thu, 4 Jul 2019 18:15:57 +0000
Message-ID: <20190704181235.8966-7-saeedm@mellanox.com>
References: <20190704181235.8966-1-saeedm@mellanox.com>
In-Reply-To: <20190704181235.8966-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.148.53.10]
x-clientproxiedby: BYAPR06CA0061.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::38) To DB6PR0501MB2759.eurprd05.prod.outlook.com
 (2603:10a6:4:84::7)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 09a2bd7a-fb59-45b0-610f-08d700aba8e6
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2584;
x-ms-traffictypediagnostic: DB6PR0501MB2584:
x-microsoft-antispam-prvs: <DB6PR0501MB2584134EFD68F5B01228C848BEFA0@DB6PR0501MB2584.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:167;
x-forefront-prvs: 0088C92887
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(346002)(136003)(39860400002)(366004)(396003)(199004)(189003)(486006)(14454004)(186003)(305945005)(26005)(6916009)(71200400001)(6486002)(7736002)(86362001)(256004)(8936002)(81156014)(386003)(76176011)(8676002)(81166006)(6116002)(52116002)(2906002)(6436002)(3846002)(102836004)(71190400001)(2616005)(476003)(446003)(11346002)(6506007)(99286004)(73956011)(25786009)(1076003)(107886003)(66946007)(66556008)(66476007)(68736007)(66446008)(64756008)(5660300002)(478600001)(4326008)(50226002)(6512007)(54906003)(66066001)(316002)(36756003)(53936002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2584;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 6fAwn0BjeYafZsfj4RHmrf7pOrJvMXHEh2hFAuG2aoFa6RFzzd14+bS1eKHgMKePjExApYkkQ3aGuMwA8kN6y3gPbPh5Qm6y3Jj0WGGyqydjpr79hoRMXhv9pcFzVHR5bGDXsCY081kGKvjXITIVOAfemE0uVl91WUAt4pMyqKN85aM4ayRV7UJ3uHGl7ZP1gaHL3gQ+6VfUmll9a11w5ZRloZv2gEePlQjulCtp2GVk3LOsyQEXZBIEE0433ldVQ74XhXlWI4tzutzOFCJcGMKym/Lqxs5a+ZFn6/PL8Lw7Q0ugE4d1tg+6fg5Bt4Ghyi+kMRjaqc5pUcDmxVIMbkYAkX2LUjvgOmtgTQvw3WsrZCBWaPOq086motBbMZQk6vT1fnV3Hr9BgTNfFdpANa+z1hiXKKlnlB8pNdiqXdk=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 09a2bd7a-fb59-45b0-610f-08d700aba8e6
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jul 2019 18:15:57.3105
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2584
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@mellanox.com>

Add support for the new TLS implementation of the Connect-X family.
Introduce a new compilation flag MLX5_TLS for it.

Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: Eran Ben Elisha <eranbe@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/Kconfig   | 13 ++++-
 .../ethernet/mellanox/mlx5/core/accel/tls.c   | 42 +++++++++++++++-
 .../ethernet/mellanox/mlx5/core/accel/tls.h   | 49 ++++++++++++++++++-
 3 files changed, 101 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Kconfig b/drivers/net/=
ethernet/mellanox/mlx5/core/Kconfig
index 6556490d809c..37fef8cd25e3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
@@ -134,10 +134,21 @@ config MLX5_FPGA_TLS
 	mlx5_core driver will include the Innova FPGA core and allow building
 	sandbox-specific client drivers.
=20
+config MLX5_TLS
+	bool "Mellanox Technologies TLS Connect-X support"
+	depends on MLX5_CORE_EN
+	depends on TLS_DEVICE
+	depends on TLS=3Dy || MLX5_CORE=3Dm
+	select MLX5_ACCEL
+	default n
+	help
+	Build TLS support for the Connect-X family of network cards by Mellanox
+	Technologies.
+
 config MLX5_EN_TLS
 	bool "TLS cryptography-offload accelaration"
 	depends on MLX5_CORE_EN
-	depends on MLX5_FPGA_TLS
+	depends on MLX5_FPGA_TLS || MLX5_TLS
 	default y
 	help
 	Build support for TLS cryptography-offload accelaration in the NIC.
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/accel/tls.c b/drivers/=
net/ethernet/mellanox/mlx5/core/accel/tls.c
index a2c9eda1ebf5..cab708af3422 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/accel/tls.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/accel/tls.c
@@ -35,6 +35,7 @@
=20
 #include "accel/tls.h"
 #include "mlx5_core.h"
+#include "lib/mlx5.h"
=20
 #ifdef CONFIG_MLX5_FPGA_TLS
 #include "fpga/tls.h"
@@ -63,7 +64,8 @@ int mlx5_accel_tls_resync_rx(struct mlx5_core_dev *mdev, =
u32 handle, u32 seq,
=20
 bool mlx5_accel_is_tls_device(struct mlx5_core_dev *mdev)
 {
-	return mlx5_fpga_is_tls_device(mdev);
+	return mlx5_fpga_is_tls_device(mdev) ||
+		mlx5_accel_is_ktls_device(mdev);
 }
=20
 u32 mlx5_accel_tls_device_caps(struct mlx5_core_dev *mdev)
@@ -81,3 +83,41 @@ void mlx5_accel_tls_cleanup(struct mlx5_core_dev *mdev)
 	mlx5_fpga_tls_cleanup(mdev);
 }
 #endif
+
+#ifdef CONFIG_MLX5_TLS
+int mlx5_ktls_create_key(struct mlx5_core_dev *mdev,
+			 struct tls_crypto_info *crypto_info,
+			 u32 *p_key_id)
+{
+	u32 sz_bytes;
+	void *key;
+
+	switch (crypto_info->cipher_type) {
+	case TLS_CIPHER_AES_GCM_128: {
+		struct tls12_crypto_info_aes_gcm_128 *info =3D
+			(struct tls12_crypto_info_aes_gcm_128 *)crypto_info;
+
+		key      =3D info->key;
+		sz_bytes =3D sizeof(info->key);
+		break;
+	}
+	case TLS_CIPHER_AES_GCM_256: {
+		struct tls12_crypto_info_aes_gcm_256 *info =3D
+			(struct tls12_crypto_info_aes_gcm_256 *)crypto_info;
+
+		key      =3D info->key;
+		sz_bytes =3D sizeof(info->key);
+		break;
+	}
+	default:
+		return -EINVAL;
+	}
+
+	return mlx5_create_encryption_key(mdev, key, sz_bytes, p_key_id);
+}
+
+void mlx5_ktls_destroy_key(struct mlx5_core_dev *mdev, u32 key_id)
+{
+	mlx5_destroy_encryption_key(mdev, key_id);
+}
+#endif
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/accel/tls.h b/drivers/=
net/ethernet/mellanox/mlx5/core/accel/tls.h
index e5d306ad7f91..879321b21616 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/accel/tls.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/accel/tls.h
@@ -37,6 +37,50 @@
 #include <linux/mlx5/driver.h>
 #include <linux/tls.h>
=20
+#ifdef CONFIG_MLX5_TLS
+int mlx5_ktls_create_key(struct mlx5_core_dev *mdev,
+			 struct tls_crypto_info *crypto_info,
+			 u32 *p_key_id);
+void mlx5_ktls_destroy_key(struct mlx5_core_dev *mdev, u32 key_id);
+
+static inline bool mlx5_accel_is_ktls_device(struct mlx5_core_dev *mdev)
+{
+	if (!MLX5_CAP_GEN(mdev, tls))
+		return false;
+
+	if (!MLX5_CAP_GEN(mdev, log_max_dek))
+		return false;
+
+	return MLX5_CAP_TLS(mdev, tls_1_2_aes_gcm_128);
+}
+
+static inline bool mlx5e_ktls_type_check(struct mlx5_core_dev *mdev,
+					 struct tls_crypto_info *crypto_info)
+{
+	switch (crypto_info->cipher_type) {
+	case TLS_CIPHER_AES_GCM_128:
+		if (crypto_info->version =3D=3D TLS_1_2_VERSION)
+			return MLX5_CAP_TLS(mdev,  tls_1_2_aes_gcm_128);
+		break;
+	}
+
+	return false;
+}
+#else
+static inline int
+mlx5_ktls_create_key(struct mlx5_core_dev *mdev,
+		     struct tls_crypto_info *crypto_info,
+		     u32 *p_key_id) { return -ENOTSUPP; }
+static inline void
+mlx5_ktls_destroy_key(struct mlx5_core_dev *mdev, u32 key_id) {}
+
+static inline bool
+mlx5_accel_is_ktls_device(struct mlx5_core_dev *mdev) { return false; }
+static inline bool
+mlx5e_ktls_type_check(struct mlx5_core_dev *mdev,
+		      struct tls_crypto_info *crypto_info) { return false; }
+#endif
+
 #ifdef CONFIG_MLX5_FPGA_TLS
 enum {
 	MLX5_ACCEL_TLS_TX =3D BIT(0),
@@ -83,7 +127,10 @@ static inline void mlx5_accel_tls_del_flow(struct mlx5_=
core_dev *mdev, u32 swid,
 					   bool direction_sx) { }
 static inline int mlx5_accel_tls_resync_rx(struct mlx5_core_dev *mdev, u32=
 handle,
 					   u32 seq, u64 rcd_sn) { return 0; }
-static inline bool mlx5_accel_is_tls_device(struct mlx5_core_dev *mdev) { =
return false; }
+static inline bool mlx5_accel_is_tls_device(struct mlx5_core_dev *mdev)
+{
+	return mlx5_accel_is_ktls_device(mdev);
+}
 static inline u32 mlx5_accel_tls_device_caps(struct mlx5_core_dev *mdev) {=
 return 0; }
 static inline int mlx5_accel_tls_init(struct mlx5_core_dev *mdev) { return=
 0; }
 static inline void mlx5_accel_tls_cleanup(struct mlx5_core_dev *mdev) { }
--=20
2.21.0

