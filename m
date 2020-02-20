Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 830281654FF
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 03:25:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727806AbgBTCZr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 21:25:47 -0500
Received: from mail-am6eur05on2089.outbound.protection.outlook.com ([40.107.22.89]:32566
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727211AbgBTCZq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Feb 2020 21:25:46 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B3U3IBpoc5QlccU+6Z+VdaNuc1v/krd6xHBFbStPkFE0U6hHq9HbUtANXpXq78My5eKcv63cGMIGXrMDfQeYO4iDmzjidtPeDMbULvCOjR+p0IIOrjBkQA9IesfKzCaZedpqj59Nlbbccr5qJrPoD6c5U1wWiJzgCJ1WNVu1fqbERG+UMB5zJax9eozUYDI8fRSGin/YcJmmpBm7zKec6jdJ9fDKIEkHMIJATxQwN+qO1/SbcpcmGhMFPYn7CPt7CBadkbGAB+fLG3gSAuBMeC56rNtPST9XnqFIoUgq5Ud5J81EBzI3FG702/vB5YVK0Cwllheqjhc9XnBzHR1u0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9VoJwUWmcbQxyKW1lgx5LqVzYXl5sj9ofdyDNXSlaFE=;
 b=RtUtIjmMIdyhhw/tf01g1U2en54sFiApbhsa+JQRQHxKl+PTm7ew0unu7FKvsx8sSTsseeftYluIou/E2UD7L+mdsVp9vGj9stDThmW8UENYZn+LsJlU7NlrkTB+0dP6KGreSQBR4gXDPDqYQcv+qZ2m0uS72js2ki1UfgeRRzaB0jIqXBlAsJtOxEdPigEU1Ilvn+d4Lo7sHXXw4KX6/4sfsJh5mXu/tEyUj0olMfWfUBRtWS9XYhd7tuYo4CVV2KMaDwaS9AhbPg363P/57jlGiUa1FRjpClg3VpgFIpmUU+tphxLM0puCgYG0mzzCpz8MTynbtSuzfdx3E3DlNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9VoJwUWmcbQxyKW1lgx5LqVzYXl5sj9ofdyDNXSlaFE=;
 b=c6Dw+LusIxWDEzYnCHfRO2d3x96OiI5BriyMF+Lu4KMqNyEvAhbYbHPPLm3ICunwdc3ZU2FF2ZocuSc7t1xBmgT7gzHhWRvg8r2ULE4XP1xubwmRdzkRrMlhek0BibT0Nixz6W/fUtCX38y0fgJ+RwzIyomFQ8f6Q0Bt5NsH7o8=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB4173.eurprd05.prod.outlook.com (52.134.122.29) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2729.31; Thu, 20 Feb 2020 02:25:40 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2729.028; Thu, 20 Feb 2020
 02:25:40 +0000
Received: from smtp.office365.com (73.15.39.150) by BY5PR20CA0022.namprd20.prod.outlook.com (2603:10b6:a03:1f4::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2750.18 via Frontend Transport; Thu, 20 Feb 2020 02:25:37 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 1/7] net/mlxfw: Generic mlx FW flash status notify
Thread-Topic: [PATCH net-next 1/7] net/mlxfw: Generic mlx FW flash status
 notify
Thread-Index: AQHV55ULl25dOXW9vUyxj5Bhqz5rqQ==
Date:   Thu, 20 Feb 2020 02:25:39 +0000
Message-ID: <20200220022502.38262-2-saeedm@mellanox.com>
References: <20200220022502.38262-1-saeedm@mellanox.com>
In-Reply-To: <20200220022502.38262-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.24.1
x-originating-ip: [73.15.39.150]
x-clientproxiedby: BY5PR20CA0022.namprd20.prod.outlook.com
 (2603:10b6:a03:1f4::35) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 5e0b0ab4-c3a9-4ea6-5594-08d7b5ac2d15
x-ms-traffictypediagnostic: VI1PR05MB4173:|VI1PR05MB4173:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB4173BD79E831FD344BB9A76EBE130@VI1PR05MB4173.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:660;
x-forefront-prvs: 031996B7EF
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(366004)(39860400002)(376002)(136003)(346002)(199004)(189003)(54906003)(5660300002)(2906002)(26005)(478600001)(71200400001)(6486002)(6512007)(16526019)(110136005)(52116002)(316002)(186003)(86362001)(6506007)(4326008)(956004)(2616005)(1076003)(107886003)(64756008)(81156014)(81166006)(66946007)(66556008)(8936002)(66476007)(8676002)(36756003)(66446008)(54420400002)(41533002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4173;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HM0gRxwHqoCw++tErlwTYOhj6tc3scBnQb/Q9zlOXdNtiCDFDd9LOaSlTUXBUQKsg+A3VDoWnDhhnItrCsMsW+cQCl69QWCgp8PsB0USC1kB5Re1G9PlPQy0hKDnk4cthRTbZZgusqjKo1n95sB382EvAaaeaocSUxrL4L5Z/XgFEIwo4eWVVGhjKgjgLdOJKs1dpebrj+an89JPRa/3Ir6EuOFfPURX8tWPPgzoh8lBgcqV7OkCWAP4S0owO+yN3647N9Y5GGylv5Yqy+P7BvGbzvy5E0UuELo4JhiPcUxkAdd/HvFgVFYI2ZrIl94XGp3JfASgzzYFOBUsn8Mvus70GXEO7NU834+qJfo1cyxYuYsdEZlWSFjwheF+vJVgB079zaB+Fw5lL8Rtrm1/YrkkGJRjqGY2rPCN0x1K0S4/JsfAimQr0d2b0WkRHchHHHzwz7ivLo6khuhBsdeXWqh6L2O5gXa4dGEW+qatkmYZnvAya6zP8XIRdwYXPDCo+PPnYcHAn9rN/GW5OyWjuNhxp6UoYpRuXKdEn/JsHaDMVKghVQD4Z9KqAqD/f4vs
x-ms-exchange-antispam-messagedata: qxA4oSGnnNNDdmQhH8FcaszK6CQtKIUuXg0Jbq+/K/Dpsk5LNif6hKCSCF2imYHf8/h5gbIebDZO4uXuuzpkURS92mX+NP9eHjuUsi/eYE692gythRu74bfGoch+xYHGszr1h2x3qaHSwx1LOU2A9Q==
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e0b0ab4-c3a9-4ea6-5594-08d7b5ac2d15
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Feb 2020 02:25:39.9035
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2LosOOlclEOsg0MIRpRZrNKySYPDAAQVguJNd9cPcyGEOZGcYlEFqPPXWReE/TWmItdGYyB6kfcv2VAaYKA1GQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4173
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

FW flash status notify is currently implemented via a callback to the
caller mlx module, and all it is doing is to call
devlink_flash_update_status_notify with the specific module devlink
instance.

Instead of repeating the whole process for all mlx modules and
re-implement the status_notify callback again and again. Just provide the
devlink instance as part of mlxfw_dev when calling mlxfw_firmware_flash
and let mlxfw do the devlink status updates directly.

This will be very useful for adding status notify support to mlx5, as
already done in this patch, with a simple one line of just providing the
devlink instance to mlxfw_firmware_flash.

mlxfw now depends on NET_DEVLINK as all other mlx modules.

Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Reviewed-by: Ido Schimmel <idosch@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/fw.c  |  1 +
 drivers/net/ethernet/mellanox/mlxfw/Kconfig   |  1 +
 drivers/net/ethernet/mellanox/mlxfw/mlxfw.h   |  6 ++----
 .../net/ethernet/mellanox/mlxfw/mlxfw_fsm.c   | 21 ++++++++++---------
 .../net/ethernet/mellanox/mlxsw/spectrum.c    | 17 +--------------
 5 files changed, 16 insertions(+), 30 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fw.c b/drivers/net/eth=
ernet/mellanox/mlx5/core/fw.c
index 909a7f284614..4250fd6de6d7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fw.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fw.c
@@ -634,6 +634,7 @@ int mlx5_firmware_flash(struct mlx5_core_dev *dev,
 			.ops =3D &mlx5_mlxfw_dev_ops,
 			.psid =3D dev->board_id,
 			.psid_size =3D strlen(dev->board_id),
+			.devlink =3D priv_to_devlink(dev),
 		},
 		.mlx5_core_dev =3D dev
 	};
diff --git a/drivers/net/ethernet/mellanox/mlxfw/Kconfig b/drivers/net/ethe=
rnet/mellanox/mlxfw/Kconfig
index 0367f835a846..5b604501f33e 100644
--- a/drivers/net/ethernet/mellanox/mlxfw/Kconfig
+++ b/drivers/net/ethernet/mellanox/mlxfw/Kconfig
@@ -12,3 +12,4 @@ config MLXFW
 	  To compile this driver as a module, choose M here: the
 	  module will be called mlxfw.
 	select XZ_DEC
+	select NET_DEVLINK
diff --git a/drivers/net/ethernet/mellanox/mlxfw/mlxfw.h b/drivers/net/ethe=
rnet/mellanox/mlxfw/mlxfw.h
index c50e74ab02c4..cd88fd257501 100644
--- a/drivers/net/ethernet/mellanox/mlxfw/mlxfw.h
+++ b/drivers/net/ethernet/mellanox/mlxfw/mlxfw.h
@@ -6,6 +6,7 @@
=20
 #include <linux/firmware.h>
 #include <linux/netlink.h>
+#include <net/devlink.h>
=20
 enum mlxfw_fsm_state {
 	MLXFW_FSM_STATE_IDLE,
@@ -58,16 +59,13 @@ struct mlxfw_dev_ops {
 	void (*fsm_cancel)(struct mlxfw_dev *mlxfw_dev, u32 fwhandle);
=20
 	void (*fsm_release)(struct mlxfw_dev *mlxfw_dev, u32 fwhandle);
-
-	void (*status_notify)(struct mlxfw_dev *mlxfw_dev,
-			      const char *msg, const char *comp_name,
-			      u32 done_bytes, u32 total_bytes);
 };
=20
 struct mlxfw_dev {
 	const struct mlxfw_dev_ops *ops;
 	const char *psid;
 	u16 psid_size;
+	struct devlink *devlink;
 };
=20
 #if IS_REACHABLE(CONFIG_MLXFW)
diff --git a/drivers/net/ethernet/mellanox/mlxfw/mlxfw_fsm.c b/drivers/net/=
ethernet/mellanox/mlxfw/mlxfw_fsm.c
index 29e95d0a6ad1..55211ad1c39d 100644
--- a/drivers/net/ethernet/mellanox/mlxfw/mlxfw_fsm.c
+++ b/drivers/net/ethernet/mellanox/mlxfw/mlxfw_fsm.c
@@ -39,16 +39,6 @@ static const char * const mlxfw_fsm_state_err_str[] =3D =
{
 		"unknown error"
 };
=20
-static void mlxfw_status_notify(struct mlxfw_dev *mlxfw_dev,
-				const char *msg, const char *comp_name,
-				u32 done_bytes, u32 total_bytes)
-{
-	if (!mlxfw_dev->ops->status_notify)
-		return;
-	mlxfw_dev->ops->status_notify(mlxfw_dev, msg, comp_name,
-				      done_bytes, total_bytes);
-}
-
 static int mlxfw_fsm_state_wait(struct mlxfw_dev *mlxfw_dev, u32 fwhandle,
 				enum mlxfw_fsm_state fsm_state,
 				struct netlink_ext_ack *extack)
@@ -85,6 +75,14 @@ static int mlxfw_fsm_state_wait(struct mlxfw_dev *mlxfw_=
dev, u32 fwhandle,
 	return 0;
 }
=20
+static void mlxfw_status_notify(struct mlxfw_dev *mlxfw_dev,
+				const char *msg, const char *comp_name,
+				u32 done_bytes, u32 total_bytes)
+{
+	devlink_flash_update_status_notify(mlxfw_dev->devlink, msg, comp_name,
+					   done_bytes, total_bytes);
+}
+
 #define MLXFW_ALIGN_DOWN(x, align_bits) ((x) & ~((1 << (align_bits)) - 1))
 #define MLXFW_ALIGN_UP(x, align_bits) \
 		MLXFW_ALIGN_DOWN((x) + ((1 << (align_bits)) - 1), (align_bits))
@@ -225,6 +223,7 @@ int mlxfw_firmware_flash(struct mlxfw_dev *mlxfw_dev,
 		return PTR_ERR(mfa2_file);
=20
 	pr_info("Initialize firmware flash process\n");
+	devlink_flash_update_begin_notify(mlxfw_dev->devlink);
 	mlxfw_status_notify(mlxfw_dev, "Initializing firmware flash process",
 			    NULL, 0, 0);
 	err =3D mlxfw_dev->ops->fsm_lock(mlxfw_dev, &fwhandle);
@@ -263,6 +262,7 @@ int mlxfw_firmware_flash(struct mlxfw_dev *mlxfw_dev,
 	pr_info("Firmware flash done.\n");
 	mlxfw_status_notify(mlxfw_dev, "Firmware flash done", NULL, 0, 0);
 	mlxfw_mfa2_file_fini(mfa2_file);
+	devlink_flash_update_end_notify(mlxfw_dev->devlink);
 	return 0;
=20
 err_state_wait_activate_to_locked:
@@ -272,6 +272,7 @@ int mlxfw_firmware_flash(struct mlxfw_dev *mlxfw_dev,
 	mlxfw_dev->ops->fsm_release(mlxfw_dev, fwhandle);
 err_fsm_lock:
 	mlxfw_mfa2_file_fini(mfa2_file);
+	devlink_flash_update_end_notify(mlxfw_dev->devlink);
 	return err;
 }
 EXPORT_SYMBOL(mlxfw_firmware_flash);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/e=
thernet/mellanox/mlxsw/spectrum.c
index 7358b5bc7eb6..3d851b1553f3 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -347,19 +347,6 @@ static void mlxsw_sp_fsm_release(struct mlxfw_dev *mlx=
fw_dev, u32 fwhandle)
 	mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(mcc), mcc_pl);
 }
=20
-static void mlxsw_sp_status_notify(struct mlxfw_dev *mlxfw_dev,
-				   const char *msg, const char *comp_name,
-				   u32 done_bytes, u32 total_bytes)
-{
-	struct mlxsw_sp_mlxfw_dev *mlxsw_sp_mlxfw_dev =3D
-		container_of(mlxfw_dev, struct mlxsw_sp_mlxfw_dev, mlxfw_dev);
-	struct mlxsw_sp *mlxsw_sp =3D mlxsw_sp_mlxfw_dev->mlxsw_sp;
-
-	devlink_flash_update_status_notify(priv_to_devlink(mlxsw_sp->core),
-					   msg, comp_name,
-					   done_bytes, total_bytes);
-}
-
 static const struct mlxfw_dev_ops mlxsw_sp_mlxfw_dev_ops =3D {
 	.component_query	=3D mlxsw_sp_component_query,
 	.fsm_lock		=3D mlxsw_sp_fsm_lock,
@@ -370,7 +357,6 @@ static const struct mlxfw_dev_ops mlxsw_sp_mlxfw_dev_op=
s =3D {
 	.fsm_query_state	=3D mlxsw_sp_fsm_query_state,
 	.fsm_cancel		=3D mlxsw_sp_fsm_cancel,
 	.fsm_release		=3D mlxsw_sp_fsm_release,
-	.status_notify		=3D mlxsw_sp_status_notify,
 };
=20
 static int mlxsw_sp_firmware_flash(struct mlxsw_sp *mlxsw_sp,
@@ -382,16 +368,15 @@ static int mlxsw_sp_firmware_flash(struct mlxsw_sp *m=
lxsw_sp,
 			.ops =3D &mlxsw_sp_mlxfw_dev_ops,
 			.psid =3D mlxsw_sp->bus_info->psid,
 			.psid_size =3D strlen(mlxsw_sp->bus_info->psid),
+			.devlink =3D priv_to_devlink(mlxsw_sp->core),
 		},
 		.mlxsw_sp =3D mlxsw_sp
 	};
 	int err;
=20
 	mlxsw_core_fw_flash_start(mlxsw_sp->core);
-	devlink_flash_update_begin_notify(priv_to_devlink(mlxsw_sp->core));
 	err =3D mlxfw_firmware_flash(&mlxsw_sp_mlxfw_dev.mlxfw_dev,
 				   firmware, extack);
-	devlink_flash_update_end_notify(priv_to_devlink(mlxsw_sp->core));
 	mlxsw_core_fw_flash_end(mlxsw_sp->core);
=20
 	return err;
--=20
2.24.1

