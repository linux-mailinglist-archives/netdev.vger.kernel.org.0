Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED8FA168980
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 22:46:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728798AbgBUVqT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Feb 2020 16:46:19 -0500
Received: from mail-eopbgr140079.outbound.protection.outlook.com ([40.107.14.79]:9220
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728722AbgBUVqS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 Feb 2020 16:46:18 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oVo8uWxCuHWmvQWxD5n1vmAGWxiIqmg2fZOkdHYVmXCDRZpiHVo7tgpfhxVZcH24DzkoCLQiv47OwJWfaPC9/Og0NvqH28IxoJzpQDywhH1BWcw9CjOSEnbhEQ5yCmYPd9y7tydQqKYyw2yWVDq41VNzn0cl7LYlU5StS4DSvijyDyOBvmS/1AsLBK0QQnazfTTSzWEOJzcn0JLW+arXgnX5j8cq9HvVSmceM4hLI8oDvllF0gvQR8DlndfL5YyE9jVxBZms8eXR0r0ZIXzowMwELiwdium4jDnjgVgSwnn5DfcG9zzm0+ZfZG2vJz7szIZk+hfFTYnYoj/pKgsmgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ej5MFwKjA+QqEFujSMjmSeVkcCgDCsGrn6X7UsTkX+k=;
 b=RNwMkKkqX/iniHjTcg7IxcqvOUBW6zNCWG2qHRLby8EGJCDS+bL1OqcnH8ZVMTeXfXS4fSAuQJo71Xc2Q+9YYQl0n7McgnrjNQcmJZTHoDVyLxV+JzueWeB9GlpqhCPBYB3MNCFxmFo+43BMFTaXcdbx17sP0mAKI8f0hk+UOLTN1XdcebzwQ57am+LM1xm6y9px/HkcxX0U4F2jL85WEwZ8lvNzA2sNMQlwEAD5lXuiSjP3XCoOtlG1EnhAxE6y1UsOWsxOs8kcvUf1sxDZjnIm9nUTRj+7wdx7tr7jJQX/XBd17WotHTdPEGdffjsvC56cShEX6IprZiHv1IdR2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ej5MFwKjA+QqEFujSMjmSeVkcCgDCsGrn6X7UsTkX+k=;
 b=XwbAlcp5Matbi4W9Vjz0fGK2AHKTNo0R7IIBPPmQ2w3EfCHWWv+yPeLpX2GRFogFuEMOa23EaPVSKT2gNNsX+onetiJVS2R6YmCmLnNB5v4dexiYu/CcFJ9FQyY7kMR3CvTGZ+QL9Ria83QiFTb7ooSmu8r8qA1gIu6L7UJw580=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB6927.eurprd05.prod.outlook.com (10.141.234.211) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2750.17; Fri, 21 Feb 2020 21:46:09 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2729.033; Fri, 21 Feb 2020
 21:46:09 +0000
Received: from smtp.office365.com (209.116.155.178) by BY5PR16CA0021.namprd16.prod.outlook.com (2603:10b6:a03:1a0::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2750.18 via Frontend Transport; Fri, 21 Feb 2020 21:46:07 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>
Subject: [PATCH net-next V2 6/7] net/mlxfw: Add reactivate flow support to FSM
 burn flow
Thread-Topic: [PATCH net-next V2 6/7] net/mlxfw: Add reactivate flow support
 to FSM burn flow
Thread-Index: AQHV6QBT4jLNe7KyI0iUys1BAqd33Q==
Date:   Fri, 21 Feb 2020 21:46:09 +0000
Message-ID: <20200221214536.20265-7-saeedm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: 0ad287d5-8905-45b9-7552-08d7b7177633
x-ms-traffictypediagnostic: VI1PR05MB6927:|VI1PR05MB6927:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB69273E76B7F3B5381A91E035BE120@VI1PR05MB6927.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0320B28BE1
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(346002)(366004)(376002)(396003)(136003)(189003)(199004)(186003)(6512007)(8936002)(54906003)(2616005)(316002)(16526019)(956004)(4326008)(478600001)(107886003)(6506007)(110136005)(52116002)(6486002)(26005)(86362001)(1076003)(66946007)(64756008)(66446008)(66476007)(81156014)(81166006)(5660300002)(8676002)(36756003)(71200400001)(2906002)(66556008)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB6927;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xfjj6KaOpSujxh4Uc/H/nrtmapp1z1l4FWTsgo5SNnkgZ6Cew8JYM4a3SIUAu5xGb2YjR2o+v7hbKImwLopOUdunmERZpk9EarnW14MisiDHE9+DMCQHY/58uf/PBbee6/7427uGhmIQHWYQbfiBF2BxtrG3Pecs4nZ0pMGzK3SLK2kldW/CBDqUDdMN1xkDitWzeTEhiDheTZXtpput1SuilBg+SUq7OtnxN6X8UpkbEXII/KV9lejcNEA2wURnVwMcGHbC0TM3vaJ32FnkhzmcVE85FzXJKzuHUW1nuL5hDc5T16idIoMq+EqZCxSkWQ+4TJGLP4O44cFfb1SMwdFvSMRiIE99Pn7EjW2ltyDQZsc4VNi0j0coACHomHKtTtR+AwX7RP+oaMHXtWkC3DR9kEI4Cj2EiMC8pn+yqJwb1jtBq8rDf7doBOjTPdwkMtHTQAapZjpdpIudYxlL16axFO7qMar1zjTqh3QVfdrDykXO1WV2bq6PjgnHxlgLsXd4cUlvxmz+5TGPx0e9uH+yquMiS38WhXctHVU+g0Y=
x-ms-exchange-antispam-messagedata: f16pBiFnOlNVDa+BGpjE0L6bjtoE7BlmffigyzuVT8jl8mhxKoCNLWrFD2TJ2TflZa9y2bA1ZAHpigL6876pvTVLOpxdIFpqYr3Q8rnabUWyUQyc1o62zUwK8PEDkqsmUXG3nVYx+GjX4YBgipS01g==
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ad287d5-8905-45b9-7552-08d7b7177633
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Feb 2020 21:46:09.5296
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eoYR/WyOTjxT+zy02/uimhUVfxcyJe7JWdptiFRowSGr8ZKe5u+IK387Gbhv6DO/v6GERadO3plMry3RASPOhA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6927
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eran Ben Elisha <eranbe@mellanox.com>

Expose fsm_reactivate callback to the mlxfw_dev_ops struct. FSM reactivate
is needed before flashing the new image in order to flush the old flashed
but not running firmware image.

In case mlxfw_dev do not support the reactivation, this step will be
skipped. But if later image flash will fail, a hint will be provided by
the extack to advise the user that the failure might be related to it.

Signed-off-by: Eran Ben Elisha <eranbe@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxfw/mlxfw.h   |  16 +++
 .../net/ethernet/mellanox/mlxfw/mlxfw_fsm.c   | 107 +++++++++++++++++-
 2 files changed, 119 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxfw/mlxfw.h b/drivers/net/ethe=
rnet/mellanox/mlxfw/mlxfw.h
index a0a63e0c5aca..7654841a05c2 100644
--- a/drivers/net/ethernet/mellanox/mlxfw/mlxfw.h
+++ b/drivers/net/ethernet/mellanox/mlxfw/mlxfw.h
@@ -55,6 +55,20 @@ enum mlxfw_fsm_state_err {
 	MLXFW_FSM_STATE_ERR_MAX,
 };
=20
+enum mlxfw_fsm_reactivate_status {
+	MLXFW_FSM_REACTIVATE_STATUS_OK,
+	MLXFW_FSM_REACTIVATE_STATUS_BUSY,
+	MLXFW_FSM_REACTIVATE_STATUS_PROHIBITED_FW_VER_ERR,
+	MLXFW_FSM_REACTIVATE_STATUS_FIRST_PAGE_COPY_FAILED,
+	MLXFW_FSM_REACTIVATE_STATUS_FIRST_PAGE_ERASE_FAILED,
+	MLXFW_FSM_REACTIVATE_STATUS_FIRST_PAGE_RESTORE_FAILED,
+	MLXFW_FSM_REACTIVATE_STATUS_CANDIDATE_FW_DEACTIVATION_FAILED,
+	MLXFW_FSM_REACTIVATE_STATUS_FW_ALREADY_ACTIVATED,
+	MLXFW_FSM_REACTIVATE_STATUS_ERR_DEVICE_RESET_REQUIRED,
+	MLXFW_FSM_REACTIVATE_STATUS_ERR_FW_PROGRAMMING_NEEDED,
+	MLXFW_FSM_REACTIVATE_STATUS_MAX,
+};
+
 struct mlxfw_dev_ops {
 	int (*component_query)(struct mlxfw_dev *mlxfw_dev, u16 component_index,
 			       u32 *p_max_size, u8 *p_align_bits,
@@ -73,6 +87,8 @@ struct mlxfw_dev_ops {
=20
 	int (*fsm_activate)(struct mlxfw_dev *mlxfw_dev, u32 fwhandle);
=20
+	int (*fsm_reactivate)(struct mlxfw_dev *mlxfw_dev, u8 *status);
+
 	int (*fsm_query_state)(struct mlxfw_dev *mlxfw_dev, u32 fwhandle,
 			       enum mlxfw_fsm_state *fsm_state,
 			       enum mlxfw_fsm_state_err *fsm_state_err);
diff --git a/drivers/net/ethernet/mellanox/mlxfw/mlxfw_fsm.c b/drivers/net/=
ethernet/mellanox/mlxfw/mlxfw_fsm.c
index 141d83b25ef3..c7e882eb8f35 100644
--- a/drivers/net/ethernet/mellanox/mlxfw/mlxfw_fsm.c
+++ b/drivers/net/ethernet/mellanox/mlxfw/mlxfw_fsm.c
@@ -114,6 +114,84 @@ static int mlxfw_fsm_state_wait(struct mlxfw_dev *mlxf=
w_dev, u32 fwhandle,
 	return 0;
 }
=20
+static int
+mlxfw_fsm_reactivate_err(struct mlxfw_dev *mlxfw_dev,
+			 struct netlink_ext_ack *extack, u8 err)
+{
+	enum mlxfw_fsm_reactivate_status status;
+
+#define MXFW_REACT_PRFX "Reactivate FSM: "
+#define MLXFW_REACT_ERR(msg, err) \
+	MLXFW_ERR_MSG(mlxfw_dev, extack, MXFW_REACT_PRFX msg, err)
+
+	status =3D min_t(enum mlxfw_fsm_reactivate_status, err,
+		       MLXFW_FSM_REACTIVATE_STATUS_MAX);
+
+	switch (status) {
+	case MLXFW_FSM_REACTIVATE_STATUS_BUSY:
+		MLXFW_REACT_ERR("busy", err);
+		break;
+	case MLXFW_FSM_REACTIVATE_STATUS_PROHIBITED_FW_VER_ERR:
+		MLXFW_REACT_ERR("prohibited fw ver", err);
+		break;
+	case MLXFW_FSM_REACTIVATE_STATUS_FIRST_PAGE_COPY_FAILED:
+		MLXFW_REACT_ERR("first page copy failed", err);
+		break;
+	case MLXFW_FSM_REACTIVATE_STATUS_FIRST_PAGE_ERASE_FAILED:
+		MLXFW_REACT_ERR("first page erase failed", err);
+		break;
+	case MLXFW_FSM_REACTIVATE_STATUS_FIRST_PAGE_RESTORE_FAILED:
+		MLXFW_REACT_ERR("first page restore failed", err);
+		break;
+	case MLXFW_FSM_REACTIVATE_STATUS_CANDIDATE_FW_DEACTIVATION_FAILED:
+		MLXFW_REACT_ERR("candidate fw deactivation failed", err);
+		break;
+	case MLXFW_FSM_REACTIVATE_STATUS_ERR_DEVICE_RESET_REQUIRED:
+		MLXFW_REACT_ERR("device reset required", err);
+		break;
+	case MLXFW_FSM_REACTIVATE_STATUS_ERR_FW_PROGRAMMING_NEEDED:
+		MLXFW_REACT_ERR("fw progamming needed", err);
+		break;
+	case MLXFW_FSM_REACTIVATE_STATUS_FW_ALREADY_ACTIVATED:
+		MLXFW_REACT_ERR("fw already activated", err);
+		break;
+	case MLXFW_FSM_REACTIVATE_STATUS_OK: /* fall through */
+	case MLXFW_FSM_REACTIVATE_STATUS_MAX:
+		MLXFW_REACT_ERR("unexpected error", err);
+		break;
+	};
+	return -EREMOTEIO;
+};
+
+static int mlxfw_fsm_reactivate(struct mlxfw_dev *mlxfw_dev,
+				struct netlink_ext_ack *extack,
+				bool *supported)
+{
+	u8 status;
+	int err;
+
+	if (!mlxfw_dev->ops->fsm_reactivate)
+		return 0;
+
+	err =3D mlxfw_dev->ops->fsm_reactivate(mlxfw_dev, &status);
+	if (err =3D=3D -EOPNOTSUPP) {
+		*supported =3D false;
+		return 0;
+	}
+
+	if (err) {
+		MLXFW_ERR_MSG(mlxfw_dev, extack,
+			      "Could not reactivate firmware flash", err);
+		return err;
+	}
+
+	if (status =3D=3D MLXFW_FSM_REACTIVATE_STATUS_OK ||
+	    status =3D=3D MLXFW_FSM_REACTIVATE_STATUS_FW_ALREADY_ACTIVATED)
+		return 0;
+
+	return mlxfw_fsm_reactivate_err(mlxfw_dev, extack, status);
+}
+
 static void mlxfw_status_notify(struct mlxfw_dev *mlxfw_dev,
 				const char *msg, const char *comp_name,
 				u32 done_bytes, u32 total_bytes)
@@ -129,6 +207,7 @@ static void mlxfw_status_notify(struct mlxfw_dev *mlxfw=
_dev,
 static int mlxfw_flash_component(struct mlxfw_dev *mlxfw_dev,
 				 u32 fwhandle,
 				 struct mlxfw_mfa2_component *comp,
+				 bool reactivate_supp,
 				 struct netlink_ext_ack *extack)
 {
 	u16 comp_max_write_size;
@@ -166,8 +245,13 @@ static int mlxfw_flash_component(struct mlxfw_dev *mlx=
fw_dev,
 						   comp->index,
 						   comp->data_size);
 	if (err) {
-		MLXFW_ERR_MSG(mlxfw_dev, extack,
-			      "FSM component update failed", err);
+		if (!reactivate_supp)
+			MLXFW_ERR_MSG(mlxfw_dev, extack,
+				      "FSM component update failed, FW reactivate is not supported",
+				      err);
+		else
+			MLXFW_ERR_MSG(mlxfw_dev, extack,
+				      "FSM component update failed", err);
 		return err;
 	}
=20
@@ -221,6 +305,7 @@ static int mlxfw_flash_component(struct mlxfw_dev *mlxf=
w_dev,
=20
 static int mlxfw_flash_components(struct mlxfw_dev *mlxfw_dev, u32 fwhandl=
e,
 				  struct mlxfw_mfa2_file *mfa2_file,
+				  bool reactivate_supp,
 				  struct netlink_ext_ack *extack)
 {
 	u32 component_count;
@@ -250,7 +335,8 @@ static int mlxfw_flash_components(struct mlxfw_dev *mlx=
fw_dev, u32 fwhandle,
=20
 		mlxfw_info(mlxfw_dev, "Flashing component type %d\n",
 			   comp->index);
-		err =3D mlxfw_flash_component(mlxfw_dev, fwhandle, comp, extack);
+		err =3D mlxfw_flash_component(mlxfw_dev, fwhandle, comp,
+					    reactivate_supp, extack);
 		mlxfw_mfa2_file_component_put(comp);
 		if (err)
 			return err;
@@ -263,6 +349,7 @@ int mlxfw_firmware_flash(struct mlxfw_dev *mlxfw_dev,
 			 struct netlink_ext_ack *extack)
 {
 	struct mlxfw_mfa2_file *mfa2_file;
+	bool reactivate_supp =3D true;
 	u32 fwhandle;
 	int err;
=20
@@ -296,7 +383,17 @@ int mlxfw_firmware_flash(struct mlxfw_dev *mlxfw_dev,
 	if (err)
 		goto err_state_wait_idle_to_locked;
=20
-	err =3D mlxfw_flash_components(mlxfw_dev, fwhandle, mfa2_file, extack);
+	err =3D mlxfw_fsm_reactivate(mlxfw_dev, extack, &reactivate_supp);
+	if (err)
+		goto err_fsm_reactivate;
+
+	err =3D mlxfw_fsm_state_wait(mlxfw_dev, fwhandle,
+				   MLXFW_FSM_STATE_LOCKED, extack);
+	if (err)
+		goto err_state_wait_reactivate_to_locked;
+
+	err =3D mlxfw_flash_components(mlxfw_dev, fwhandle, mfa2_file,
+				     reactivate_supp, extack);
 	if (err)
 		goto err_flash_components;
=20
@@ -326,6 +423,8 @@ int mlxfw_firmware_flash(struct mlxfw_dev *mlxfw_dev,
 err_state_wait_activate_to_locked:
 err_fsm_activate:
 err_flash_components:
+err_state_wait_reactivate_to_locked:
+err_fsm_reactivate:
 err_state_wait_idle_to_locked:
 	mlxfw_dev->ops->fsm_release(mlxfw_dev, fwhandle);
 err_fsm_lock:
--=20
2.24.1

