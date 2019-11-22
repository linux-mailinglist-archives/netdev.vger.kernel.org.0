Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3956107AC5
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 23:43:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727404AbfKVWmC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 17:42:02 -0500
Received: from mail-eopbgr150047.outbound.protection.outlook.com ([40.107.15.47]:57606
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727279AbfKVWmB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Nov 2019 17:42:01 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dhYLEYtMDmbkxUI1RKYlOUnPQlDhPj8YCLKABXg450ULsymOFkzbsxmRriOzAiF1DpSRswRpsNmAV7JNz4ATiEjpODPN99/qVhB3S+LO5xnIZtkcZVfF/U48ZDwfhAR5kMX6eMRiRdvjjo/Txy/y4G3JErqIEfl08cmUfIvAHsOiMPLWm4ZFFuIbvfPWocf0QADNsgxoitTG5rQ9Z7BbsWXyIqexADNDgxepcchYriZy6cxl/C+BNxuxfRxBnA4PRaiWO79xmwCGMULs4cCsxnXgjuufFBG04QGt7WxvXSvqRf+3enMU5sX75POv2JIg24CBmBikLDuuXpMhTthb/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MGO5zVj+755GSfHstLeR1PQ3CmB1uopnBrZcbCqBp14=;
 b=itpgubcAelNxnOE5ZXiXud4pU41B8JFCtonAMseMM1fOImbjvMogykQqllddMJNsE/yMZXu5+uyeo0UY5ounl0J3CAQvNlwcKkancVYZI+Fxfq40DTFtmppA+LORzTUSA8q9RX1AGxZQ0cpb0ykrs1vluH6YoUrHVpKXAUp075blyr0gkhiqHBfyVs6q9ZUxzQnFGZCKGOCR4UZzvw6yTG7uipGtdleGDoqYdkBrR6dDFdQSbtNvrz/swmpaLIC/CbaljZ302awtSlofZY9F2z3UL/GsgugwhwJeR7YDXm9z7cO89ZcGy3qs0SBGruKTqQ+guMPY+Ba09rUaojSVrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MGO5zVj+755GSfHstLeR1PQ3CmB1uopnBrZcbCqBp14=;
 b=mB1ld0X8SaEGigvUfRVXP9IZEORAA3H9WKNwKMhKx6avdpjO6f0s39M3xCu8ZGBu3Cuva6pm33ajHfQUmXPKj37yTCfg138VF3w621E1FkI6ZXHyQBPpmTbqkvExurtBcrrrG8NpZQ1ZCKdjfMYTmVflepMszyZdIo4TxAFt5sE=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB6718.eurprd05.prod.outlook.com (10.186.162.137) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2474.17; Fri, 22 Nov 2019 22:41:49 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e%5]) with mapi id 15.20.2474.019; Fri, 22 Nov 2019
 22:41:49 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH V2 net-next 2/6] net/mlxfw: Generic mlx FW flash status notify
Thread-Topic: [PATCH V2 net-next 2/6] net/mlxfw: Generic mlx FW flash status
 notify
Thread-Index: AQHVoYYGlge6P9+W+UqyhB6hSutJqw==
Date:   Fri, 22 Nov 2019 22:41:49 +0000
Message-ID: <20191122224126.24847-3-saeedm@mellanox.com>
References: <20191122224126.24847-1-saeedm@mellanox.com>
In-Reply-To: <20191122224126.24847-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BY5PR16CA0008.namprd16.prod.outlook.com
 (2603:10b6:a03:1a0::21) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 4d5aa24f-443d-474c-c6d2-08d76f9d2930
x-ms-traffictypediagnostic: VI1PR05MB6718:|VI1PR05MB6718:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB67188C678A43F6FA13778F40BE490@VI1PR05MB6718.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:660;
x-forefront-prvs: 02296943FF
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(346002)(39860400002)(366004)(136003)(376002)(189003)(199004)(14454004)(66946007)(64756008)(66556008)(1076003)(66066001)(66476007)(4326008)(6486002)(66446008)(14444005)(8936002)(6512007)(6916009)(7736002)(6506007)(26005)(256004)(305945005)(386003)(186003)(3846002)(102836004)(6116002)(11346002)(2616005)(446003)(107886003)(2906002)(478600001)(99286004)(8676002)(25786009)(52116002)(81156014)(36756003)(81166006)(76176011)(316002)(6436002)(54906003)(86362001)(50226002)(5660300002)(71190400001)(71200400001)(41533002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB6718;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: gNOgb8UXUUohgjSLdc/fy0I6D/8V42HzUnMoTq0naANKZu5QKT1VqysWJ3yWEnrmx+tB2DmlJRqgJ9rbIJz9TDZTU1NU4lDdQG+i8LNB22BLl3OAAG0R/EcaZVrXNFfXZq/qK1cVH+99+mF2jSSjAXWSpW9GZ8KBS87f34teRPfmicgjrgzML6E3GpcORkXfKwQDZzkYiHLXNnm7N9KsdBnKocecICUZLLVenYT6/ngrsE8zIA88ZSgLKhD72vQ0yyN9nRT8MwHK/P9f7UIIActlKnScjR6wkTHRBnIm23w8/MeiJkbxdsb2Yc0k0vm2gvs0tGbcVvK9Dl19rvzb2UpUikCaUl8SzlEZVXFH/BXueKB6UZLETUbmAhsFin+VN6R7z6Z2VoxNdAfJMQQGYBRX/HYLmkKtYvi0dyMyTWdQMuKWIoUwQww9hDv1Hq51
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d5aa24f-443d-474c-c6d2-08d76f9d2930
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Nov 2019 22:41:49.1093
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AsjrmUUGGi6i4g+qvC9mhmelRYCw8l3Y7FZT7iywPcwKurbIf4t91ZJzi8RObBJK3mraSxAZjOMMf0UDoDyEpw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6718
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
index a19790dee7b2..9c8956c51169 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fw.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fw.c
@@ -624,6 +624,7 @@ int mlx5_firmware_flash(struct mlx5_core_dev *dev,
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
index 67990406cba2..663eac994a5c 100644
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
@@ -83,6 +73,14 @@ static int mlxfw_fsm_state_wait(struct mlxfw_dev *mlxfw_=
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
@@ -223,6 +221,7 @@ int mlxfw_firmware_flash(struct mlxfw_dev *mlxfw_dev,
 		return PTR_ERR(mfa2_file);
=20
 	pr_info("Initialize firmware flash process\n");
+	devlink_flash_update_begin_notify(mlxfw_dev->devlink);
 	mlxfw_status_notify(mlxfw_dev, "Initializing firmware flash process",
 			    NULL, 0, 0);
 	err =3D mlxfw_dev->ops->fsm_lock(mlxfw_dev, &fwhandle);
@@ -261,6 +260,7 @@ int mlxfw_firmware_flash(struct mlxfw_dev *mlxfw_dev,
 	pr_info("Firmware flash done.\n");
 	mlxfw_status_notify(mlxfw_dev, "Firmware flash done", NULL, 0, 0);
 	mlxfw_mfa2_file_fini(mfa2_file);
+	devlink_flash_update_end_notify(mlxfw_dev->devlink);
 	return 0;
=20
 err_state_wait_activate_to_locked:
@@ -270,6 +270,7 @@ int mlxfw_firmware_flash(struct mlxfw_dev *mlxfw_dev,
 	mlxfw_dev->ops->fsm_release(mlxfw_dev, fwhandle);
 err_fsm_lock:
 	mlxfw_mfa2_file_fini(mfa2_file);
+	devlink_flash_update_end_notify(mlxfw_dev->devlink);
 	return err;
 }
 EXPORT_SYMBOL(mlxfw_firmware_flash);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/e=
thernet/mellanox/mlxsw/spectrum.c
index 556dca328bb5..4df6f01fe5ca 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -345,19 +345,6 @@ static void mlxsw_sp_fsm_release(struct mlxfw_dev *mlx=
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
@@ -368,7 +355,6 @@ static const struct mlxfw_dev_ops mlxsw_sp_mlxfw_dev_op=
s =3D {
 	.fsm_query_state	=3D mlxsw_sp_fsm_query_state,
 	.fsm_cancel		=3D mlxsw_sp_fsm_cancel,
 	.fsm_release		=3D mlxsw_sp_fsm_release,
-	.status_notify		=3D mlxsw_sp_status_notify,
 };
=20
 static int mlxsw_sp_firmware_flash(struct mlxsw_sp *mlxsw_sp,
@@ -380,16 +366,15 @@ static int mlxsw_sp_firmware_flash(struct mlxsw_sp *m=
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
2.21.0

