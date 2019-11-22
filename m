Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F07A107A40
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 22:52:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726910AbfKVVwD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 16:52:03 -0500
Received: from mail-eopbgr80058.outbound.protection.outlook.com ([40.107.8.58]:24062
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726869AbfKVVwC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Nov 2019 16:52:02 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=faanLN6l7xFVX+YC3eR1odeJyPTkz9II7ah7gSPRXtYi9rcnvsZXj72PI8yspfZ4N+FgN0vTzq44/mwI7ElPAgcdgJ/MD0C0BpF7ahCVGVuTMtmW47Mrp/XBxsWdGlz8ttAQDx7rON5G0CEiXTtr8JUgmcLruw7i3CbiwHPV9WQQpNLSljt71wpY2/0T4oOQ56mxHEU+Oh6Cf3KQrWepsQVJJvtfAYCsYpMZ+TFcIR7oGACMIj43IZXa0xBODgqWAnkL5gzSDtYe6qPKbtduVOlt9oH8xXMnluCuumfyZuT7JSDI9HxTvsXQjVYD401rZ/y2VT98PFAycsJRUD9I4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kbsmyoV0DeUbNqhnBtVprlZZSl1rtQ7UUwQKO6bi7oo=;
 b=D2eskftQo1CeK2L+tVSPaWXJLDOkG+BJA50rpObkvCLnmgHfg3HI3/oebnIFXDGm5TLdnwIMy+9uoxnlHfoUQTT0fPfzzT1f1F8S6D+tA7JnHRA4J1upRQpNe3/tMc5ngx/i5+BGKtHZJLghM916LXH4A6fbMTwXjjMZi4mm3js2fRdpMWRS3aD/uZFZnjLI8vUayz/2EpqtGiOuaRYvgXDrjfKUH2AOoL1CLQuBMmIw1YMnBypUiuFMkZAELEkLU6xpikrKMZhwTp1KHjlpHiuGcZcmG7pHgHtNxslqpzTM5ArY8MRWdSQ8XDHaUNKpXnLAgMGUz+Km5FG0JkwjoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kbsmyoV0DeUbNqhnBtVprlZZSl1rtQ7UUwQKO6bi7oo=;
 b=cTy7D6f4Wmg1yXpTmMbMnq6V8y+X/tyMynSeIxFa60Se+T+tqxAiMgyWT0GL9nqTzY7afIw3AjLsOiywRP9LT7LxSdbtRFi0yw3bG6+SNGsBAY5rPqwD6pYkCKByziIvf9XzJmRqKlUUZC1mAdOXsnC2Z6Bqi8PM++RKaBz4FTg=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB5341.eurprd05.prod.outlook.com (20.178.8.218) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2474.17; Fri, 22 Nov 2019 21:51:55 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e%5]) with mapi id 15.20.2474.019; Fri, 22 Nov 2019
 21:51:55 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 4/6] net/mlxfw: Convert pr_* to dev_* in mlxfw_fsm.c
Thread-Topic: [PATCH net-next 4/6] net/mlxfw: Convert pr_* to dev_* in
 mlxfw_fsm.c
Thread-Index: AQHVoX8O/BShEClDOEOIJ7gFwB2xGw==
Date:   Fri, 22 Nov 2019 21:51:55 +0000
Message-ID: <20191122215111.21723-5-saeedm@mellanox.com>
References: <20191122215111.21723-1-saeedm@mellanox.com>
In-Reply-To: <20191122215111.21723-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR21CA0027.namprd21.prod.outlook.com
 (2603:10b6:a03:114::37) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: f40f2a8e-f896-4e04-e133-08d76f9630ca
x-ms-traffictypediagnostic: VI1PR05MB5341:|VI1PR05MB5341:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB5341922B7F170CD2D554F1EDBE490@VI1PR05MB5341.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:262;
x-forefront-prvs: 02296943FF
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(376002)(39860400002)(346002)(396003)(366004)(189003)(199004)(107886003)(8676002)(386003)(6506007)(3846002)(36756003)(6512007)(26005)(478600001)(1076003)(316002)(66476007)(2906002)(6116002)(66556008)(64756008)(66446008)(71200400001)(71190400001)(99286004)(66946007)(66066001)(25786009)(4326008)(14444005)(256004)(54906003)(50226002)(102836004)(446003)(7736002)(186003)(305945005)(6436002)(6486002)(8936002)(76176011)(11346002)(52116002)(6916009)(14454004)(81156014)(5660300002)(81166006)(2616005)(86362001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5341;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: OmBDVMB3WKFD5rns07QI1SLMQ3SdaWBBlsTq5hYJdFaGcc8IJ/AL1rajB5Iljbk3K7jZuQQ4pmPUfqGPefqT0joGYumJAmXtmV6MtkiPYigJvsxhUbudlFr/wKFtfTkoiEzWpYt7hQ68Olm4X2YZCAGktTaAJz+QymOY5NXuO/nt4co/3IICF667uaq06F/qnnAXmAynmmLKr/yUBT7Ai14OLlUk0hsNspSv95rbNwHWXWjF/eJJSFWGbz9EPtiSuHv9ONtsZdrpyEYGR8mxCT3ZqSG24454V/nKjaWJcXHAx2TR2ID0YzMqPHHqzTT5I36lUARg1NK5ytY/kdtJxXzjuEV6TON2if/4pe/2gJ8DJAmDPD2R2qZAho4O0Lw8Ba27piEdksL0e/3b60qnDKkHFPjNp5q3dV9zmEXlrAMKKtC/R+/g8PgTB7jeSCq1
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f40f2a8e-f896-4e04-e133-08d76f9630ca
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Nov 2019 21:51:55.2063
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BrUG09AWjI8W6uXL5ASPKHYgWeey4jI/Olj6PnxLgiNxxcesqnfK3vb7WiHbHWzjsfIksbmH/+0J2Hi9wIMXNA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5341
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce mlxfw_{info, err, dbg} macros and make them call corresponding
dev_* macros, then convert all instances of pr_* to mlxfw_*.

This will allow printing the device name mlxfw is operating on.

Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Reviewed-by: Ido Schimmel <idosch@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxfw/mlxfw.h   | 32 ++++++++++-----
 .../net/ethernet/mellanox/mlxfw/mlxfw_fsm.c   | 39 ++++++++++---------
 2 files changed, 44 insertions(+), 27 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxfw/mlxfw.h b/drivers/net/ethe=
rnet/mellanox/mlxfw/mlxfw.h
index cd88fd257501..a0a63e0c5aca 100644
--- a/drivers/net/ethernet/mellanox/mlxfw/mlxfw.h
+++ b/drivers/net/ethernet/mellanox/mlxfw/mlxfw.h
@@ -6,8 +6,31 @@
=20
 #include <linux/firmware.h>
 #include <linux/netlink.h>
+#include <linux/device.h>
 #include <net/devlink.h>
=20
+struct mlxfw_dev {
+	const struct mlxfw_dev_ops *ops;
+	const char *psid;
+	u16 psid_size;
+	struct devlink *devlink;
+};
+
+static inline
+struct device *mlxfw_dev_dev(struct mlxfw_dev *mlxfw_dev)
+{
+	return mlxfw_dev->devlink->dev;
+}
+
+#define MLXFW_PRFX "mlxfw: "
+
+#define mlxfw_info(mlxfw_dev, fmt, ...) \
+	dev_info(mlxfw_dev_dev(mlxfw_dev), MLXFW_PRFX fmt, ## __VA_ARGS__)
+#define mlxfw_err(mlxfw_dev, fmt, ...) \
+	dev_err(mlxfw_dev_dev(mlxfw_dev), MLXFW_PRFX fmt, ## __VA_ARGS__)
+#define mlxfw_dbg(mlxfw_dev, fmt, ...) \
+	dev_dbg(mlxfw_dev_dev(mlxfw_dev), MLXFW_PRFX fmt, ## __VA_ARGS__)
+
 enum mlxfw_fsm_state {
 	MLXFW_FSM_STATE_IDLE,
 	MLXFW_FSM_STATE_LOCKED,
@@ -32,8 +55,6 @@ enum mlxfw_fsm_state_err {
 	MLXFW_FSM_STATE_ERR_MAX,
 };
=20
-struct mlxfw_dev;
-
 struct mlxfw_dev_ops {
 	int (*component_query)(struct mlxfw_dev *mlxfw_dev, u16 component_index,
 			       u32 *p_max_size, u8 *p_align_bits,
@@ -61,13 +82,6 @@ struct mlxfw_dev_ops {
 	void (*fsm_release)(struct mlxfw_dev *mlxfw_dev, u32 fwhandle);
 };
=20
-struct mlxfw_dev {
-	const struct mlxfw_dev_ops *ops;
-	const char *psid;
-	u16 psid_size;
-	struct devlink *devlink;
-};
-
 #if IS_REACHABLE(CONFIG_MLXFW)
 int mlxfw_firmware_flash(struct mlxfw_dev *mlxfw_dev,
 			 const struct firmware *firmware,
diff --git a/drivers/net/ethernet/mellanox/mlxfw/mlxfw_fsm.c b/drivers/net/=
ethernet/mellanox/mlxfw/mlxfw_fsm.c
index ba1e5b276c54..204ef6ed7651 100644
--- a/drivers/net/ethernet/mellanox/mlxfw/mlxfw_fsm.c
+++ b/drivers/net/ethernet/mellanox/mlxfw/mlxfw_fsm.c
@@ -39,7 +39,8 @@ static const char * const mlxfw_fsm_state_err_str[] =3D {
 		"unknown error"
 };
=20
-static int mlxfw_fsm_state_err(struct netlink_ext_ack *extack,
+static int mlxfw_fsm_state_err(struct mlxfw_dev *mlxfw_dev,
+			       struct netlink_ext_ack *extack,
 			       enum mlxfw_fsm_state_err fsm_state_err)
 {
 #define MLXFW_ERR_PRFX "Firmware flash failed: "
@@ -48,7 +49,8 @@ static int mlxfw_fsm_state_err(struct netlink_ext_ack *ex=
tack,
=20
 	fsm_state_err =3D min_t(enum mlxfw_fsm_state_err, fsm_state_err,
 			      MLXFW_FSM_STATE_ERR_MAX);
-	pr_err(MLXFW_ERR_PRFX "%s\n", mlxfw_fsm_state_err_str[fsm_state_err]);
+	mlxfw_err(mlxfw_dev, MLXFW_ERR_PRFX "%s\n",
+		  mlxfw_fsm_state_err_str[fsm_state_err]);
 	switch (fsm_state_err) {
 	case MLXFW_FSM_STATE_ERR_ERROR:
 		MLXFW_FSM_STATE_ERR_NL(extack, "general error");
@@ -110,11 +112,11 @@ static int mlxfw_fsm_state_wait(struct mlxfw_dev *mlx=
fw_dev, u32 fwhandle,
 		return err;
=20
 	if (fsm_state_err !=3D MLXFW_FSM_STATE_ERR_OK)
-		return mlxfw_fsm_state_err(extack, fsm_state_err);
+		return mlxfw_fsm_state_err(mlxfw_dev, extack, fsm_state_err);
=20
 	if (curr_fsm_state !=3D fsm_state) {
 		if (--times =3D=3D 0) {
-			pr_err("Timeout reached on FSM state change");
+			mlxfw_err(mlxfw_dev, "Timeout reached on FSM state change\n");
 			NL_SET_ERR_MSG_MOD(extack, "Timeout reached on FSM state change");
 			return -ETIMEDOUT;
 		}
@@ -152,8 +154,8 @@ static int mlxfw_flash_component(struct mlxfw_dev *mlxf=
w_dev,
=20
 	comp_max_size =3D min_t(u32, comp_max_size, MLXFW_FSM_MAX_COMPONENT_SIZE)=
;
 	if (comp->data_size > comp_max_size) {
-		pr_err("Component %d is of size %d which is bigger than limit %d\n",
-		       comp->index, comp->data_size, comp_max_size);
+		mlxfw_err(mlxfw_dev, "Component %d is of size %d which is bigger than li=
mit %d\n",
+			  comp->index, comp->data_size, comp_max_size);
 		NL_SET_ERR_MSG_MOD(extack, "Component is bigger than limit");
 		return -EINVAL;
 	}
@@ -161,7 +163,7 @@ static int mlxfw_flash_component(struct mlxfw_dev *mlxf=
w_dev,
 	comp_max_write_size =3D MLXFW_ALIGN_DOWN(comp_max_write_size,
 					       comp_align_bits);
=20
-	pr_debug("Component update\n");
+	mlxfw_dbg(mlxfw_dev, "Component update\n");
 	mlxfw_status_notify(mlxfw_dev, "Updating component", comp_name, 0, 0);
 	err =3D mlxfw_dev->ops->fsm_component_update(mlxfw_dev, fwhandle,
 						   comp->index,
@@ -174,7 +176,7 @@ static int mlxfw_flash_component(struct mlxfw_dev *mlxf=
w_dev,
 	if (err)
 		goto err_out;
=20
-	pr_debug("Component download\n");
+	mlxfw_dbg(mlxfw_dev, "Component download\n");
 	mlxfw_status_notify(mlxfw_dev, "Downloading component",
 			    comp_name, 0, comp->data_size);
 	for (offset =3D 0;
@@ -193,7 +195,7 @@ static int mlxfw_flash_component(struct mlxfw_dev *mlxf=
w_dev,
 				    comp->data_size);
 	}
=20
-	pr_debug("Component verify\n");
+	mlxfw_dbg(mlxfw_dev, "Component verify\n");
 	mlxfw_status_notify(mlxfw_dev, "Verifying component", comp_name, 0, 0);
 	err =3D mlxfw_dev->ops->fsm_component_verify(mlxfw_dev, fwhandle,
 						   comp->index);
@@ -223,7 +225,7 @@ static int mlxfw_flash_components(struct mlxfw_dev *mlx=
fw_dev, u32 fwhandle,
 					      mlxfw_dev->psid_size,
 					      &component_count);
 	if (err) {
-		pr_err("Could not find device PSID in MFA2 file\n");
+		mlxfw_err(mlxfw_dev, "Could not find device PSID in MFA2 file\n");
 		NL_SET_ERR_MSG_MOD(extack, "Could not find device PSID in MFA2 file");
 		return err;
 	}
@@ -236,7 +238,8 @@ static int mlxfw_flash_components(struct mlxfw_dev *mlx=
fw_dev, u32 fwhandle,
 		if (IS_ERR(comp))
 			return PTR_ERR(comp);
=20
-		pr_info("Flashing component type %d\n", comp->index);
+		mlxfw_info(mlxfw_dev, "Flashing component type %d\n",
+			   comp->index);
 		err =3D mlxfw_flash_component(mlxfw_dev, fwhandle, comp, extack);
 		mlxfw_mfa2_file_component_put(comp);
 		if (err)
@@ -254,7 +257,7 @@ int mlxfw_firmware_flash(struct mlxfw_dev *mlxfw_dev,
 	int err;
=20
 	if (!mlxfw_mfa2_check(firmware)) {
-		pr_err("Firmware file is not MFA2\n");
+		mlxfw_err(mlxfw_dev, "Firmware file is not MFA2\n");
 		NL_SET_ERR_MSG_MOD(extack, "Firmware file is not MFA2");
 		return -EINVAL;
 	}
@@ -263,13 +266,13 @@ int mlxfw_firmware_flash(struct mlxfw_dev *mlxfw_dev,
 	if (IS_ERR(mfa2_file))
 		return PTR_ERR(mfa2_file);
=20
-	pr_info("Initialize firmware flash process\n");
+	mlxfw_info(mlxfw_dev, "Initialize firmware flash process\n");
 	devlink_flash_update_begin_notify(mlxfw_dev->devlink);
 	mlxfw_status_notify(mlxfw_dev, "Initializing firmware flash process",
 			    NULL, 0, 0);
 	err =3D mlxfw_dev->ops->fsm_lock(mlxfw_dev, &fwhandle);
 	if (err) {
-		pr_err("Could not lock the firmware FSM\n");
+		mlxfw_err(mlxfw_dev, "Could not lock the firmware FSM\n");
 		NL_SET_ERR_MSG_MOD(extack, "Could not lock the firmware FSM");
 		goto err_fsm_lock;
 	}
@@ -283,11 +286,11 @@ int mlxfw_firmware_flash(struct mlxfw_dev *mlxfw_dev,
 	if (err)
 		goto err_flash_components;
=20
-	pr_debug("Activate image\n");
+	mlxfw_dbg(mlxfw_dev, "Activate image\n");
 	mlxfw_status_notify(mlxfw_dev, "Activating image", NULL, 0, 0);
 	err =3D mlxfw_dev->ops->fsm_activate(mlxfw_dev, fwhandle);
 	if (err) {
-		pr_err("Could not activate the downloaded image\n");
+		mlxfw_err(mlxfw_dev, "Could not activate the downloaded image\n");
 		NL_SET_ERR_MSG_MOD(extack, "Could not activate the downloaded image");
 		goto err_fsm_activate;
 	}
@@ -297,10 +300,10 @@ int mlxfw_firmware_flash(struct mlxfw_dev *mlxfw_dev,
 	if (err)
 		goto err_state_wait_activate_to_locked;
=20
-	pr_debug("Handle release\n");
+	mlxfw_dbg(mlxfw_dev, "Handle release\n");
 	mlxfw_dev->ops->fsm_release(mlxfw_dev, fwhandle);
=20
-	pr_info("Firmware flash done.\n");
+	mlxfw_info(mlxfw_dev, "Firmware flash done\n");
 	mlxfw_status_notify(mlxfw_dev, "Firmware flash done", NULL, 0, 0);
 	mlxfw_mfa2_file_fini(mfa2_file);
 	devlink_flash_update_end_notify(mlxfw_dev->devlink);
--=20
2.21.0

