Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13075107AC7
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 23:43:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727409AbfKVWmI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 17:42:08 -0500
Received: from mail-eopbgr150047.outbound.protection.outlook.com ([40.107.15.47]:57606
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727046AbfKVWmF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Nov 2019 17:42:05 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IikqW6z34O3JLN/G0dQDD2WTkJs7IJBnLdBKEaiIfnfOWI7FpiN4PVbQmeW8AMvdxakQN5P1LNqjjO18y00DL7M7zit0k+ticURj27mQYR9EVZ4nwGwMxgK62J5o5boa9o+7nL0OYZ//F6zVfbhOnjnU+4Q8BRQVcAQ1los/KvVreKfZHnkHrDduc2EznAgGSrid20Hx2afaqvl0jexWGDfonLUKQk5gRo2pI9+FftMomRP05slsxI4UA26iaTmY8RnFqz/2EJ4LB6LZjhYJ42NUoY6TLllLNttb9pKo1bATkaX/z/ecqfvU+PBtPDqp6TlHZuEoYi9gEd7rVW8B+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kmJ8l0EZEIRMiDQgnyyHeiXesmqEAITfy7BSNSMUcAQ=;
 b=nbVfrj+GviUIAGkhiVw5R/O6ZjigaocMSVg6FURRu1FhthBlWb+8oDSKUxeWLrEWTgI/JqcT1HKHKCIbO6i30y711/9yS20rsXnYuBKgnkTr4zD05BVum02QIYSN7KvxuUErkrkI2EHKiPXWqQGp4d4pxsSI4H0vJHiNHb1GS6SAPhflCrgSKCmzOT2214Mhp36B5sVuoh3Hac2cQk7hcqYG1TyWxpoi4RjQ4xq/tdKUWjIhm9QmqZxjTXYb+lBKhZ0ynqoNm7f8kV1MNNAvX1pU8cIcjm2YsToyxcxkpoKugI1BjAwfragBjVNPURLEgo3DCG+bKmspyVsAcRVNxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kmJ8l0EZEIRMiDQgnyyHeiXesmqEAITfy7BSNSMUcAQ=;
 b=iQxYz+pYY1sCgP89H07IHHoF0VUmte005CunDCPlA0elo0CZVHnbshswZRrf1jQd22AiuzRzXkZw7d9bLbePS+BQ0rehjMHs9NlpqmluSO5lTYTzV1LhndPPF5fo3YQCBiYmqs6mghNLvbvZs8nkCFtGa9d4L2zNq5mZuv9/9qM=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB6718.eurprd05.prod.outlook.com (10.186.162.137) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2474.17; Fri, 22 Nov 2019 22:41:52 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e%5]) with mapi id 15.20.2474.019; Fri, 22 Nov 2019
 22:41:52 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH V2 net-next 4/6] net/mlxfw: Convert pr_* to dev_* in
 mlxfw_fsm.c
Thread-Topic: [PATCH V2 net-next 4/6] net/mlxfw: Convert pr_* to dev_* in
 mlxfw_fsm.c
Thread-Index: AQHVoYYI7iiIrK/75kSBKY42khKw1A==
Date:   Fri, 22 Nov 2019 22:41:52 +0000
Message-ID: <20191122224126.24847-5-saeedm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: 70825903-7c03-4c0d-dc8b-08d76f9d2b5d
x-ms-traffictypediagnostic: VI1PR05MB6718:|VI1PR05MB6718:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB67189A038A0BD83E6AB345E4BE490@VI1PR05MB6718.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:262;
x-forefront-prvs: 02296943FF
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(346002)(39860400002)(366004)(136003)(376002)(189003)(199004)(14454004)(66946007)(64756008)(66556008)(1076003)(66066001)(66476007)(4326008)(6486002)(66446008)(14444005)(8936002)(6512007)(6916009)(7736002)(6506007)(26005)(256004)(305945005)(386003)(186003)(3846002)(102836004)(6116002)(11346002)(2616005)(446003)(107886003)(2906002)(478600001)(99286004)(8676002)(25786009)(52116002)(81156014)(36756003)(81166006)(76176011)(316002)(6436002)(54906003)(86362001)(50226002)(5660300002)(71190400001)(71200400001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB6718;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: e6WAMWsJ1xijjDZ220kfgnVB/6Y1B54eae3xgdxDEWOsyQqWlsGvsqzHRP4vUlF1632VL+p8wSV764Q7D+8MDIDytSbgN/awMW5c7tjv0jBdsQ1w1/KQ2Clw5xB6iJgSMffiDLc8oV5mjPhR1HYy/CzS2snmfCtYqmAt+M/nEOYkJ/HdHZBkTckth03ydriIDgr3OU/aN9tvgc7trYVmQN++H02N5A32BgYBbhL1ne2thAoq+VS2JlZB0Os2ueac/8VrW0RPiEMpR3ma3C9cb//UbHkyVvHxaUolxAbDErfQfsfj6k9NaN/ojuxF5IijsYYGOSzC4/3TRK/vZMeC2fF2bcexYjTVCvrqJGCTjhdI0w+y3KJWAMIMp0B972pLIqKTGZvkq695YxEBwFsMW/4scVp1z3ou9OtodQCRxV96i6QLFzxeHyUhDsWdKDCk
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 70825903-7c03-4c0d-dc8b-08d76f9d2b5d
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Nov 2019 22:41:52.5873
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XcZ7pLqvxYQJkRzfegOLiMeeuWdIC0o16I1b2I02jpW2oWF4JDy+RyrjMT6m47OG9NwvnshkUJACIxwjXN1L/A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6718
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
 .../net/ethernet/mellanox/mlxfw/mlxfw_fsm.c   | 40 ++++++++++---------
 2 files changed, 45 insertions(+), 27 deletions(-)

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
index 803152ab6914..3ac0459aeac7 100644
--- a/drivers/net/ethernet/mellanox/mlxfw/mlxfw_fsm.c
+++ b/drivers/net/ethernet/mellanox/mlxfw/mlxfw_fsm.c
@@ -52,14 +52,17 @@ static const int mlxfw_fsm_state_errno[] =3D {
 	[MLXFW_FSM_STATE_ERR_MAX] =3D -EINVAL
 };
=20
-static int mlxfw_fsm_state_err(struct netlink_ext_ack *extack,
+static int mlxfw_fsm_state_err(struct mlxfw_dev *mlxfw_dev,
+			       struct netlink_ext_ack *extack,
 			       enum mlxfw_fsm_state_err fsm_state_err)
 {
 #define MLXFW_ERR_PRFX "Firmware flash failed: "
=20
 	fsm_state_err =3D min_t(enum mlxfw_fsm_state_err, fsm_state_err,
 			      MLXFW_FSM_STATE_ERR_MAX);
-	pr_err(MLXFW_ERR_PRFX "%s\n", mlxfw_fsm_state_err_str[fsm_state_err]);
+
+	mlxfw_err(mlxfw_dev, MLXFW_ERR_PRFX "%s\n",
+		  mlxfw_fsm_state_err_str[fsm_state_err]);
 	NL_SET_ERR_MSG_MOD(extack, MLXFW_ERR_PRFX "%s",
 			   mlxfw_fsm_state_err_str[fsm_state_err]);
 	return mlxfw_fsm_state_errno[fsm_state_err];
@@ -82,11 +85,11 @@ static int mlxfw_fsm_state_wait(struct mlxfw_dev *mlxfw=
_dev, u32 fwhandle,
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
@@ -132,8 +135,8 @@ static int mlxfw_flash_component(struct mlxfw_dev *mlxf=
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
@@ -141,7 +144,7 @@ static int mlxfw_flash_component(struct mlxfw_dev *mlxf=
w_dev,
 	comp_max_write_size =3D MLXFW_ALIGN_DOWN(comp_max_write_size,
 					       comp_align_bits);
=20
-	pr_debug("Component update\n");
+	mlxfw_dbg(mlxfw_dev, "Component update\n");
 	mlxfw_status_notify(mlxfw_dev, "Updating component", comp_name, 0, 0);
 	err =3D mlxfw_dev->ops->fsm_component_update(mlxfw_dev, fwhandle,
 						   comp->index,
@@ -154,7 +157,7 @@ static int mlxfw_flash_component(struct mlxfw_dev *mlxf=
w_dev,
 	if (err)
 		goto err_out;
=20
-	pr_debug("Component download\n");
+	mlxfw_dbg(mlxfw_dev, "Component download\n");
 	mlxfw_status_notify(mlxfw_dev, "Downloading component",
 			    comp_name, 0, comp->data_size);
 	for (offset =3D 0;
@@ -173,7 +176,7 @@ static int mlxfw_flash_component(struct mlxfw_dev *mlxf=
w_dev,
 				    comp->data_size);
 	}
=20
-	pr_debug("Component verify\n");
+	mlxfw_dbg(mlxfw_dev, "Component verify\n");
 	mlxfw_status_notify(mlxfw_dev, "Verifying component", comp_name, 0, 0);
 	err =3D mlxfw_dev->ops->fsm_component_verify(mlxfw_dev, fwhandle,
 						   comp->index);
@@ -203,7 +206,7 @@ static int mlxfw_flash_components(struct mlxfw_dev *mlx=
fw_dev, u32 fwhandle,
 					      mlxfw_dev->psid_size,
 					      &component_count);
 	if (err) {
-		pr_err("Could not find device PSID in MFA2 file\n");
+		mlxfw_err(mlxfw_dev, "Could not find device PSID in MFA2 file\n");
 		NL_SET_ERR_MSG_MOD(extack, "Could not find device PSID in MFA2 file");
 		return err;
 	}
@@ -216,7 +219,8 @@ static int mlxfw_flash_components(struct mlxfw_dev *mlx=
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
@@ -234,7 +238,7 @@ int mlxfw_firmware_flash(struct mlxfw_dev *mlxfw_dev,
 	int err;
=20
 	if (!mlxfw_mfa2_check(firmware)) {
-		pr_err("Firmware file is not MFA2\n");
+		mlxfw_err(mlxfw_dev, "Firmware file is not MFA2\n");
 		NL_SET_ERR_MSG_MOD(extack, "Firmware file is not MFA2");
 		return -EINVAL;
 	}
@@ -243,13 +247,13 @@ int mlxfw_firmware_flash(struct mlxfw_dev *mlxfw_dev,
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
@@ -263,11 +267,11 @@ int mlxfw_firmware_flash(struct mlxfw_dev *mlxfw_dev,
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
@@ -277,10 +281,10 @@ int mlxfw_firmware_flash(struct mlxfw_dev *mlxfw_dev,
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

