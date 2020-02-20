Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D681D165502
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 03:25:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727893AbgBTCZ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 21:25:58 -0500
Received: from mail-am6eur05on2089.outbound.protection.outlook.com ([40.107.22.89]:32566
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727125AbgBTCZ5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Feb 2020 21:25:57 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ASpScUrwBif5fFIpjgrUQdlwXbfM7h/K9vtVU6r1ymQX/32nTxypACRqN+tvXh+C1/fI/Bhn0S16vlv8HhNIN9vulQGKFHkeuN6G8NdgUyVR8y+8Fv9Zs3xIyGxO7IzdDYje6dx0EXCHD6uvbqraBh3XNVi2+n0aOiViVu71/58F8zigzBfg5RDsgxjaN6G1+JaMsKYkga2QrCZaGj5twioFBtv5SF9WU7YqCtC15dAWqNHRwHcno2rjjeaHYOuiYelO35EG61WAPrHn1dqSDFH0PgGEBV99AXcKlH8kgKYC5aZmaoaGZ6PdPBFtshmN2aB4oNTIo/4ZJhnYsbAJJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kS04hJMREjVwlNbrM6KU37SHoHqxIWccBIuPuOR1fHE=;
 b=MkUxNMvAqdYPzFgkzntX4sIOkAMeBZltKnMKMSVsaC/nbwYUxs9zxAVIlRAItFsv8bE4rzsnolSh8QoHtWgp2Ks99awdJQnlC+iTcgirXtF0YRbuLGiZOjP9ZWK/iRGBQdY8YyG74mGQ1WsC2N5f2BWAbIzW9eaVP4W3wnRyTtn3Gn3hC2W09T3T/xaW0GqCQ8k9A5ZcBdPKLE898AiIi6oF1t4YwYl2IJj4ehDYi8TLPhi0PHUpvtTMbhKT8ZD3J0HsIXeCthGocrmvPUyaW1mUUxc1vHJLRROAF4t1dN70BaV8uUjolZlXh3fDxQFsP/GoLqUTMv9k873srL9ACg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kS04hJMREjVwlNbrM6KU37SHoHqxIWccBIuPuOR1fHE=;
 b=P4llVyKpbnOQtZh191ybuIXeM5woCHcSDjQBLAXwDo7CbF7dadlJIdNNF+/R4fNQVA1DsR6s9k3+h+fps2aUYnQLOmm0TiRdmVuMlJZgzHJrK1ybnejk7AJxOTNS3SkguQbm+Q1GI+gJRqhFMySSW7KbAxybDvEY8BI0sSBvz6Q=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB4173.eurprd05.prod.outlook.com (52.134.122.29) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2729.31; Thu, 20 Feb 2020 02:25:50 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2729.028; Thu, 20 Feb 2020
 02:25:50 +0000
Received: from smtp.office365.com (73.15.39.150) by BY5PR20CA0022.namprd20.prod.outlook.com (2603:10b6:a03:1f4::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2750.18 via Frontend Transport; Thu, 20 Feb 2020 02:25:47 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 4/7] net/mlxfw: Convert pr_* to dev_* in mlxfw_fsm.c
Thread-Topic: [PATCH net-next 4/7] net/mlxfw: Convert pr_* to dev_* in
 mlxfw_fsm.c
Thread-Index: AQHV55UR9SqH2xm93UiKXxPDwBLV/Q==
Date:   Thu, 20 Feb 2020 02:25:49 +0000
Message-ID: <20200220022502.38262-5-saeedm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: f1ec5f98-ee54-47bc-97ec-08d7b5ac32d3
x-ms-traffictypediagnostic: VI1PR05MB4173:|VI1PR05MB4173:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB4173ACFE799EBA51910B8EE6BE130@VI1PR05MB4173.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:298;
x-forefront-prvs: 031996B7EF
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(366004)(39860400002)(376002)(136003)(346002)(199004)(189003)(54906003)(5660300002)(2906002)(26005)(478600001)(71200400001)(6486002)(6512007)(16526019)(110136005)(52116002)(316002)(186003)(86362001)(6506007)(4326008)(956004)(2616005)(1076003)(107886003)(64756008)(81156014)(81166006)(66946007)(66556008)(8936002)(66476007)(8676002)(36756003)(66446008)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4173;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: CERVPBDdQjuHvisTaoJlP5TNKD6HeFXbHW5RhvKVrQJpwc+SbKBfP43e5OqOqSoz21KxNq1vMicKbGYQuV2utV6Yi3ITwF7vC9YGB852Es8so6EjuNcd0hEb6m4afPrXSIPNO6rv2eNq+5quzzYI083ZDaaxEgfJqWxaGhXU/Md0Q2BafA8ArR1cPcy1E9znLm5dGflR5dqidFJR5aDLQ0KucDLsBSvGC5f8Zk29adG9sdPym6M9ou4OWXx0qh/xpNFlK2JWZLLLLrPEUFDbxgUfnaBFrtXuBcXotQCaDM3z53p35ijp61g2Nd0uDM0/dDjRq8SNMiP6oq23a7TN0sRNc9PLBTxIgCNEUA7B1NCg7qWtf/Z8KHSezC+p/jZqepTGgrblZPc48/ok4olosTMIHyCFBmpIFzBYV+gR2WJkaLbar5ZqQnmVFuSdBTMtz0FXXmmgErhOrn8j6eWFx6j45gcqQI93nGg28aplOQAVjSpV02SevMEk6M/lWe1BA8T/UBeQRwiAajMFD3Yl66PAn1qjNYlheXNlDrkkJZs=
x-ms-exchange-antispam-messagedata: WbnbE5TnggrEoZL0EbakUspm+rq4kiZ5dJvz5iWkuPU7k4MHzQ80bS7wW1MhIRrHiw3dssqQi1505tky4NV/0lFqEPrOVI0YpLW+T8ICjr6levGOjM/PV1ZjLx6JmDtKwuzyjJcb0nBpj/FNA7y8/A==
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f1ec5f98-ee54-47bc-97ec-08d7b5ac32d3
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Feb 2020 02:25:49.9398
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2i71YFWDGOBi9dOHV9WabHYbK97aX0wcSRpEmU9KL1Ipdg3mJAzgkt3w3Mzr2zQVD0ra3jdgVl1dMZ/qnc8PaQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4173
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
index 74fc6e06f17e..c4caa112216f 100644
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

