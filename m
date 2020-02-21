Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 338CE16897A
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 22:46:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728588AbgBUVqM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Feb 2020 16:46:12 -0500
Received: from mail-eopbgr140079.outbound.protection.outlook.com ([40.107.14.79]:9220
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726683AbgBUVqL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 Feb 2020 16:46:11 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=haWLHMUDROb+RBA5BlG/nZ1T4FIVcxPsxxechcEhlLd++ROFOtdKZqgAaEONupGAhrXaBAVgMd4E7+MircRRmhW1823IzXg6+wyPL9/td2h2m2KJJr3LAV9W/0CwFZWxSDeYcjzq7wsZRjvkon/SMqmQYE+/6MW4Kq2mdOU5vecb0WCMezFrEQO6R3J77c9IKf7QZVYKfrP0y1z3f0ebLEOnRspnd7Ro0NNIjWU7rDWuhwoglf4g4Cr34BwT+XrlQgjM3R3zHwLSlaXn8XLa2gyVLl18eJ/oh7OvDWPNUFgn9B9411O643wWSiF+xZFodwuOUPRYrCZHy8q8MQKCXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3A3cpZgRl9M4eDLOWcWCUO1V2cgUywPu7FjTkM2mEmM=;
 b=afPFMdxrZMk45I50jTpPHcSSrocR5Ce8eZxq/XCZhrEKgIRg62y61uqPAd3nMjSC7pft6aHS+SAAR00XHBN2lpyq3TWc+jF0frah7QvVb1Nap4tZb6GTJRl8m7KNE2+7Vw6O1MD96kuobkar98DQ0PdKVHBNknPZOo0UByv0TZafXSQYbp7jxMh/HD/M/7tlykHazIyl/3CL7Xpzox4142NnmWnKDXxUa6pzNYryF3hc/DvGNKNkcQZ7ASj4vKyns14C1AHltmG5d+jIaWR7Vq5dEElM56XI6R6Zh68coXL8sGTwYmIrHTFdJmNCEe9D3E2mDyd9/Qnhr2VVnPiFVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3A3cpZgRl9M4eDLOWcWCUO1V2cgUywPu7FjTkM2mEmM=;
 b=rCkXyU9NcrptjTazNjcLJzXKj7Y8JgJIW4XAWXgxra06Y9ZXkFqzhxxXlXN2gAmjjaClKowE9kaHCTpuql+8zQ9A1tu/df4WerAP85b93TpKg2NtUNlMZVv4f2LHKuQhJEBkoNBCZd3RozujnIPT4XkRiYy2TTFpWRbTTJjYB0A=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB6927.eurprd05.prod.outlook.com (10.141.234.211) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2750.17; Fri, 21 Feb 2020 21:46:05 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2729.033; Fri, 21 Feb 2020
 21:46:05 +0000
Received: from smtp.office365.com (209.116.155.178) by BY5PR16CA0021.namprd16.prod.outlook.com (2603:10b6:a03:1a0::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2750.18 via Frontend Transport; Fri, 21 Feb 2020 21:46:03 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>
Subject: [PATCH net-next V2 4/7] net/mlxfw: Convert pr_* to dev_* in
 mlxfw_fsm.c
Thread-Topic: [PATCH net-next V2 4/7] net/mlxfw: Convert pr_* to dev_* in
 mlxfw_fsm.c
Thread-Index: AQHV6QBRaJD+wd7580G01roNFbV4Gg==
Date:   Fri, 21 Feb 2020 21:46:05 +0000
Message-ID: <20200221214536.20265-5-saeedm@mellanox.com>
References: <20200221214536.20265-1-saeedm@mellanox.com>
In-Reply-To: <20200221214536.20265-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.24.1
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BY5PR16CA0021.namprd16.prod.outlook.com
 (2603:10b6:a03:1a0::34) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: e06eae8b-812a-4d16-ad13-08d7b71773d2
x-ms-traffictypediagnostic: VI1PR05MB6927:|VI1PR05MB6927:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB6927F1CECF7D28C3EE2CEFCCBE120@VI1PR05MB6927.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:298;
x-forefront-prvs: 0320B28BE1
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(346002)(366004)(376002)(396003)(136003)(189003)(199004)(186003)(6512007)(8936002)(54906003)(2616005)(316002)(16526019)(956004)(4326008)(478600001)(107886003)(6506007)(110136005)(52116002)(6486002)(26005)(86362001)(1076003)(66946007)(64756008)(66446008)(66476007)(81156014)(81166006)(5660300002)(8676002)(36756003)(71200400001)(2906002)(66556008)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB6927;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bSPceelRFqjVwxLoqlPY8L1DBlSANtBDXYAJzEOHlDIUNH/70snwoIEfcFWWtKAuvsoAuBlKkUU8SqCcRGAAapWG2qeZ3BKnpfFT7lHIWR7DZwcOUZUrky55+yaNURSa6vabcTyQQEuWTgelOT/MM9/UhosfG2Mp2SNkXcr+3LReFyxhFmKhNLHIZDy7W9KzBYOm/t3MCK7eERmbQfJ7kD3SXMcu+QHtH/MDpCQu5rrLZrxRb9NiPlWN9V/z115m0XTQ+zsQZW8AUpix0vVC+sxmzj16eD8aJKsnZJoWiNGhiF1YXrBnZQiROlTFGb/fwPJShqjEnuoe2hYzsv/4m3W2rP3U3hAZKovLrgHSSntClII6nUppPH7Yz7bW61oY40Y0x4VjIixCQTstxO5zi0OtWB/6K4JwibAxIrTwhYdDIQmHXVRK6Lpkihq3uV0EXwzyq3gve7xK5hEvS0d+vSVpUOns/utCdxmBRVGwRqcpDobiPGIIOomOGsdiov25/7ccUshbihUYG9pK5zCH6SBFDiGlXigG1KB1DSmt+NA=
x-ms-exchange-antispam-messagedata: p36GHnGFsNbE7x+huHgP2+yDoHrYkwLGmFvLoyiwJJq/2mPQPLqgZV2MNJ89sGjtZLgeTqsXNkWe8aL3fDcGZhQ/QLb0Dj8YQZ1ZkQ5zPrXpN7CCIyVkBPAZdTVZckSr7R2d0akCKnapbDMCoMDVcg==
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e06eae8b-812a-4d16-ad13-08d7b71773d2
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Feb 2020 21:46:05.4090
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YBlcr24o7Fwls0BE1fdo8DGm9bOQDKtblmHB6FjQ+rsULnRRIvvimIisGXikWA2sHM7TSH+VyTh4XZ/v1cIesA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6927
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
 drivers/net/ethernet/mellanox/mlxfw/mlxfw.h   | 32 +++++++---
 .../net/ethernet/mellanox/mlxfw/mlxfw_fsm.c   | 60 ++++++++++---------
 2 files changed, 54 insertions(+), 38 deletions(-)

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
index 422619e21183..01d5dec6633e 100644
--- a/drivers/net/ethernet/mellanox/mlxfw/mlxfw_fsm.c
+++ b/drivers/net/ethernet/mellanox/mlxfw/mlxfw_fsm.c
@@ -30,12 +30,13 @@ static const int mlxfw_fsm_state_errno[] =3D {
 };
=20
 #define MLXFW_ERR_PRFX "Firmware flash failed: "
-#define MLXFW_ERR_MSG(extack, msg, err) do { \
-	pr_err("%s, err (%d)\n", MLXFW_ERR_PRFX msg, err); \
+#define MLXFW_ERR_MSG(fwdev, extack, msg, err) do { \
+	mlxfw_err(fwdev, "%s, err (%d)\n", MLXFW_ERR_PRFX msg, err); \
 	NL_SET_ERR_MSG_MOD(extack, MLXFW_ERR_PRFX msg); \
 } while (0)
=20
-static int mlxfw_fsm_state_err(struct netlink_ext_ack *extack,
+static int mlxfw_fsm_state_err(struct mlxfw_dev *mlxfw_dev,
+			       struct netlink_ext_ack *extack,
 			       enum mlxfw_fsm_state_err err)
 {
 	enum mlxfw_fsm_state_err fsm_state_err;
@@ -45,35 +46,35 @@ static int mlxfw_fsm_state_err(struct netlink_ext_ack *=
extack,
=20
 	switch (fsm_state_err) {
 	case MLXFW_FSM_STATE_ERR_ERROR:
-		MLXFW_ERR_MSG(extack, "general error", err);
+		MLXFW_ERR_MSG(mlxfw_dev, extack, "general error", err);
 		break;
 	case MLXFW_FSM_STATE_ERR_REJECTED_DIGEST_ERR:
-		MLXFW_ERR_MSG(extack, "component hash mismatch", err);
+		MLXFW_ERR_MSG(mlxfw_dev, extack, "component hash mismatch", err);
 		break;
 	case MLXFW_FSM_STATE_ERR_REJECTED_NOT_APPLICABLE:
-		MLXFW_ERR_MSG(extack, "component not applicable", err);
+		MLXFW_ERR_MSG(mlxfw_dev, extack, "component not applicable", err);
 		break;
 	case MLXFW_FSM_STATE_ERR_REJECTED_UNKNOWN_KEY:
-		MLXFW_ERR_MSG(extack, "unknown key", err);
+		MLXFW_ERR_MSG(mlxfw_dev, extack, "unknown key", err);
 		break;
 	case MLXFW_FSM_STATE_ERR_REJECTED_AUTH_FAILED:
-		MLXFW_ERR_MSG(extack, "authentication failed", err);
+		MLXFW_ERR_MSG(mlxfw_dev, extack, "authentication failed", err);
 		break;
 	case MLXFW_FSM_STATE_ERR_REJECTED_UNSIGNED:
-		MLXFW_ERR_MSG(extack, "component was not signed", err);
+		MLXFW_ERR_MSG(mlxfw_dev, extack, "component was not signed", err);
 		break;
 	case MLXFW_FSM_STATE_ERR_REJECTED_KEY_NOT_APPLICABLE:
-		MLXFW_ERR_MSG(extack, "key not applicable", err);
+		MLXFW_ERR_MSG(mlxfw_dev, extack, "key not applicable", err);
 		break;
 	case MLXFW_FSM_STATE_ERR_REJECTED_BAD_FORMAT:
-		MLXFW_ERR_MSG(extack, "bad format", err);
+		MLXFW_ERR_MSG(mlxfw_dev, extack, "bad format", err);
 		break;
 	case MLXFW_FSM_STATE_ERR_BLOCKED_PENDING_RESET:
-		MLXFW_ERR_MSG(extack, "pending reset", err);
+		MLXFW_ERR_MSG(mlxfw_dev, extack, "pending reset", err);
 		break;
 	case MLXFW_FSM_STATE_ERR_OK: /* fall through */
 	case MLXFW_FSM_STATE_ERR_MAX:
-		MLXFW_ERR_MSG(extack, "unknown error", err);
+		MLXFW_ERR_MSG(mlxfw_dev, extack, "unknown error", err);
 		break;
 	};
=20
@@ -99,11 +100,11 @@ static int mlxfw_fsm_state_wait(struct mlxfw_dev *mlxf=
w_dev, u32 fwhandle,
 	}
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
@@ -151,8 +152,8 @@ static int mlxfw_flash_component(struct mlxfw_dev *mlxf=
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
@@ -160,7 +161,7 @@ static int mlxfw_flash_component(struct mlxfw_dev *mlxf=
w_dev,
 	comp_max_write_size =3D MLXFW_ALIGN_DOWN(comp_max_write_size,
 					       comp_align_bits);
=20
-	pr_debug("Component update\n");
+	mlxfw_dbg(mlxfw_dev, "Component update\n");
 	mlxfw_status_notify(mlxfw_dev, "Updating component", comp_name, 0, 0);
 	err =3D mlxfw_dev->ops->fsm_component_update(mlxfw_dev, fwhandle,
 						   comp->index,
@@ -175,7 +176,7 @@ static int mlxfw_flash_component(struct mlxfw_dev *mlxf=
w_dev,
 	if (err)
 		goto err_out;
=20
-	pr_debug("Component download\n");
+	mlxfw_dbg(mlxfw_dev, "Component download\n");
 	mlxfw_status_notify(mlxfw_dev, "Downloading component",
 			    comp_name, 0, comp->data_size);
 	for (offset =3D 0;
@@ -196,7 +197,7 @@ static int mlxfw_flash_component(struct mlxfw_dev *mlxf=
w_dev,
 				    comp->data_size);
 	}
=20
-	pr_debug("Component verify\n");
+	mlxfw_dbg(mlxfw_dev, "Component verify\n");
 	mlxfw_status_notify(mlxfw_dev, "Verifying component", comp_name, 0, 0);
 	err =3D mlxfw_dev->ops->fsm_component_verify(mlxfw_dev, fwhandle,
 						   comp->index);
@@ -228,7 +229,7 @@ static int mlxfw_flash_components(struct mlxfw_dev *mlx=
fw_dev, u32 fwhandle,
 					      mlxfw_dev->psid_size,
 					      &component_count);
 	if (err) {
-		pr_err("Could not find device PSID in MFA2 file\n");
+		mlxfw_err(mlxfw_dev, "Could not find device PSID in MFA2 file\n");
 		NL_SET_ERR_MSG_MOD(extack, "Could not find device PSID in MFA2 file");
 		return err;
 	}
@@ -244,7 +245,8 @@ static int mlxfw_flash_components(struct mlxfw_dev *mlx=
fw_dev, u32 fwhandle,
 			return err;
 		}
=20
-		pr_info("Flashing component type %d\n", comp->index);
+		mlxfw_info(mlxfw_dev, "Flashing component type %d\n",
+			   comp->index);
 		err =3D mlxfw_flash_component(mlxfw_dev, fwhandle, comp, extack);
 		mlxfw_mfa2_file_component_put(comp);
 		if (err)
@@ -262,7 +264,7 @@ int mlxfw_firmware_flash(struct mlxfw_dev *mlxfw_dev,
 	int err;
=20
 	if (!mlxfw_mfa2_check(firmware)) {
-		pr_err("Firmware file is not MFA2\n");
+		mlxfw_err(mlxfw_dev, "Firmware file is not MFA2\n");
 		NL_SET_ERR_MSG_MOD(extack, "Firmware file is not MFA2");
 		return -EINVAL;
 	}
@@ -275,13 +277,13 @@ int mlxfw_firmware_flash(struct mlxfw_dev *mlxfw_dev,
 		return err;
 	}
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
@@ -295,11 +297,11 @@ int mlxfw_firmware_flash(struct mlxfw_dev *mlxfw_dev,
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
@@ -309,10 +311,10 @@ int mlxfw_firmware_flash(struct mlxfw_dev *mlxfw_dev,
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
2.24.1

