Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59C4416897C
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 22:46:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728745AbgBUVqP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Feb 2020 16:46:15 -0500
Received: from mail-eopbgr140079.outbound.protection.outlook.com ([40.107.14.79]:9220
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728433AbgBUVqO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 Feb 2020 16:46:14 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gnVJh4GIyEv/rhmL3hd8JusCCFBJXN9FQ0QDVRFfeiNy78GEOWNDwEGeP5jrd5cDSeIjezDXARvMAA8YV3zXP8sRt5SbRdj22Yb2XFUwgdrNICF/o5U9CY8NxlTZuVWDbZ9n5xpee7OxaeTxYZSbGD9oWzXct9tbjxY/olPAJXzJnDjkBzFFGlWPQ93eIdxQl9hl2TrQxNQokrxlevrnN5i7jN7qQwr4j7QG2/RsCNo5nWal0pCS8lmcz3u9V57iJQcrFNyEWotPhaDorCmDun09r6Pmm0fZdIoPI6QVQVJ8gXPLy1mqrukHOPBxqeUI5Yrl/0ugq9jXr36/LXBFnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/daPFMIqlJlEk9udL988Cthv1UgMEEzyBE2ZHz4QpPQ=;
 b=mDrGAdrGnrG33vEKag/cmfhvtiKUtEj/ZAgttTlre11mGD4es9XiehPOL4usZ+jiyAfy7oUibKzLHvEDarvzHr0hT/+1jdDirBppRJSe/ZqjeEWkS1AX0oLboksk0GZSmAmBSrKG5wSEriKdA+1qp9c/9CSM1B6JE0xZXHbA9ZdmrCdyr2ZCcbiCIC7Y7pID8cznbxXszwhHnnjRj+m8PfWR89KL/XFiJ2qcfIlGEgsvcgKGK5wyVqu7q12sWD3m8/4u+EgSnWJSyCqChYrkhSgzBtqfS2qyl4OskfjFYgKr8mexzuKDzOVo/+ilat4h9skXCyc7jD1sxwj8fJwtLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/daPFMIqlJlEk9udL988Cthv1UgMEEzyBE2ZHz4QpPQ=;
 b=FH2UyFAP0C0JLyui8MAabTS83SkurYkMRwPwu4kmkdWGw93jidacuL+NCEDMpKTDJuUdRYQas11UIeyhR7gXFKaHIlZrsqtK+5Cp4wVxhqVm68eaLuEO6cHA59t2eKcBvOitv2e6RXQv68Kwhftp6Ph7Je6uBVqv6Pt8fkJhTa0=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB6927.eurprd05.prod.outlook.com (10.141.234.211) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2750.17; Fri, 21 Feb 2020 21:46:07 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2729.033; Fri, 21 Feb 2020
 21:46:07 +0000
Received: from smtp.office365.com (209.116.155.178) by BY5PR16CA0021.namprd16.prod.outlook.com (2603:10b6:a03:1a0::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2750.18 via Frontend Transport; Fri, 21 Feb 2020 21:46:05 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>
Subject: [PATCH net-next V2 5/7] net/mlxfw: Use MLXFW_ERR_MSG macro for error
 reporting
Thread-Topic: [PATCH net-next V2 5/7] net/mlxfw: Use MLXFW_ERR_MSG macro for
 error reporting
Thread-Index: AQHV6QBSuw4VerUHbESVVUah4kO0xQ==
Date:   Fri, 21 Feb 2020 21:46:07 +0000
Message-ID: <20200221214536.20265-6-saeedm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: 7506db96-d292-49fc-2e9a-08d7b71774d3
x-ms-traffictypediagnostic: VI1PR05MB6927:|VI1PR05MB6927:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB692722C405CFC43C8C4E9F52BE120@VI1PR05MB6927.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3826;
x-forefront-prvs: 0320B28BE1
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(346002)(366004)(376002)(396003)(136003)(189003)(199004)(186003)(6512007)(8936002)(54906003)(2616005)(316002)(16526019)(956004)(4326008)(478600001)(107886003)(6506007)(110136005)(52116002)(6486002)(26005)(86362001)(1076003)(66946007)(64756008)(66446008)(66476007)(81156014)(81166006)(5660300002)(8676002)(36756003)(71200400001)(2906002)(66556008)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB6927;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: j7yeEr6DgF05ryrVOK/AY7cc30FBYFttBfFHI9QR266L634ITHgbXn/XG4Qfq1dn9O8J3OZSGmRcvmCyy8gzqXL1SFUWiVyYBeg2YRWQTHruj+6WvgbdeGA66nINL7wpkHzDBcZ8G2ooCsjzmQGkhpoaM8GJHI1GyLxMZe1b4dC17hNEla1rG4ee9mJOfVnnj32tPXzeNwVbIXcg+be6GQ2fEbAXi9zL1h7ETydcMhxGulz+vjlXpGAMlaCPCoLLMe53GA050wDuW9ouVwwhmGZTW9WaOF6uTI7nBm0iKvBd3x/xfRuPFeM36avyN+vA+3OUz/mPwoeXjE147EFja05DwnJo7qfWWoqTXQgov6USyx9ajAtSMTkV3NAooB2ltCZKkrygqHO/T/qhh9Ypt2idec0LAHlma3DCHOZXVEANIO4uDBI50Ec4npKhcK6g6Arud1EV9HA7SQohva1uRa0q3SxMIbgVSKowtfpiwkzuBlaO5daxf4j9EEwPHRWY3dW9/MDL+MTVIRB7ZIv4lsZwbhJIpV7bymrKPiQC5ps=
x-ms-exchange-antispam-messagedata: 3nMolh9HxgW7MaRKkc8turIj9HIm5N7+PI4Hn26Rbxcdhx8a7RVguW6YDLHd8JWyIbeaCnjyvvhEF+0bWy+24OGakPDxMdD41Urkr/IHgC3DivhN9DhFcjL0KcEAuu2jE09HwPxlWuZbu8IK8l3USQ==
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7506db96-d292-49fc-2e9a-08d7b71774d3
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Feb 2020 21:46:07.5298
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 51msH54YpCaNVUT5QK5YsW7PxRuvV/cFZFm6GcdM0744HKX2oiTFM+CfO1RE1pGP2E6Xe+abGpWOpVUmwZDSjw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6927
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Instead of always calling both mlxfw_err and NL_SET_ERR_MSG_MOD with the
same message, use the dedicated macro instead.

Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 .../net/ethernet/mellanox/mlxfw/mlxfw_fsm.c   | 45 ++++++++++---------
 1 file changed, 24 insertions(+), 21 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxfw/mlxfw_fsm.c b/drivers/net/=
ethernet/mellanox/mlxfw/mlxfw_fsm.c
index 01d5dec6633e..141d83b25ef3 100644
--- a/drivers/net/ethernet/mellanox/mlxfw/mlxfw_fsm.c
+++ b/drivers/net/ethernet/mellanox/mlxfw/mlxfw_fsm.c
@@ -95,7 +95,7 @@ static int mlxfw_fsm_state_wait(struct mlxfw_dev *mlxfw_d=
ev, u32 fwhandle,
 	err =3D mlxfw_dev->ops->fsm_query_state(mlxfw_dev, fwhandle,
 					      &curr_fsm_state, &fsm_state_err);
 	if (err) {
-		NL_SET_ERR_MSG_MOD(extack, "FSM state query failed");
+		MLXFW_ERR_MSG(mlxfw_dev, extack, "FSM state query failed", err);
 		return err;
 	}
=20
@@ -104,8 +104,8 @@ static int mlxfw_fsm_state_wait(struct mlxfw_dev *mlxfw=
_dev, u32 fwhandle,
=20
 	if (curr_fsm_state !=3D fsm_state) {
 		if (--times =3D=3D 0) {
-			mlxfw_err(mlxfw_dev, "Timeout reached on FSM state change\n");
-			NL_SET_ERR_MSG_MOD(extack, "Timeout reached on FSM state change");
+			MLXFW_ERR_MSG(mlxfw_dev, extack,
+				      "Timeout reached on FSM state change", -ETIMEDOUT);
 			return -ETIMEDOUT;
 		}
 		msleep(MLXFW_FSM_STATE_WAIT_CYCLE_MS);
@@ -146,15 +146,14 @@ static int mlxfw_flash_component(struct mlxfw_dev *ml=
xfw_dev,
 					      &comp_max_size, &comp_align_bits,
 					      &comp_max_write_size);
 	if (err) {
-		NL_SET_ERR_MSG_MOD(extack, "FSM component query failed");
+		MLXFW_ERR_MSG(mlxfw_dev, extack, "FSM component query failed", err);
 		return err;
 	}
=20
 	comp_max_size =3D min_t(u32, comp_max_size, MLXFW_FSM_MAX_COMPONENT_SIZE)=
;
 	if (comp->data_size > comp_max_size) {
-		mlxfw_err(mlxfw_dev, "Component %d is of size %d which is bigger than li=
mit %d\n",
-			  comp->index, comp->data_size, comp_max_size);
-		NL_SET_ERR_MSG_MOD(extack, "Component is bigger than limit");
+		MLXFW_ERR_MSG(mlxfw_dev, extack,
+			      "Component size is bigger than limit", -EINVAL);
 		return -EINVAL;
 	}
=20
@@ -167,7 +166,8 @@ static int mlxfw_flash_component(struct mlxfw_dev *mlxf=
w_dev,
 						   comp->index,
 						   comp->data_size);
 	if (err) {
-		NL_SET_ERR_MSG_MOD(extack, "FSM component update failed");
+		MLXFW_ERR_MSG(mlxfw_dev, extack,
+			      "FSM component update failed", err);
 		return err;
 	}
=20
@@ -189,7 +189,8 @@ static int mlxfw_flash_component(struct mlxfw_dev *mlxf=
w_dev,
 							 block_ptr, block_size,
 							 offset);
 		if (err) {
-			NL_SET_ERR_MSG_MOD(extack, "Component download failed");
+			MLXFW_ERR_MSG(mlxfw_dev, extack,
+				      "Component download failed", err);
 			goto err_out;
 		}
 		mlxfw_status_notify(mlxfw_dev, "Downloading component",
@@ -202,7 +203,8 @@ static int mlxfw_flash_component(struct mlxfw_dev *mlxf=
w_dev,
 	err =3D mlxfw_dev->ops->fsm_component_verify(mlxfw_dev, fwhandle,
 						   comp->index);
 	if (err) {
-		NL_SET_ERR_MSG_MOD(extack, "FSM component verify failed");
+		MLXFW_ERR_MSG(mlxfw_dev, extack,
+			      "FSM component verify failed", err);
 		goto err_out;
 	}
=20
@@ -229,8 +231,8 @@ static int mlxfw_flash_components(struct mlxfw_dev *mlx=
fw_dev, u32 fwhandle,
 					      mlxfw_dev->psid_size,
 					      &component_count);
 	if (err) {
-		mlxfw_err(mlxfw_dev, "Could not find device PSID in MFA2 file\n");
-		NL_SET_ERR_MSG_MOD(extack, "Could not find device PSID in MFA2 file");
+		MLXFW_ERR_MSG(mlxfw_dev, extack,
+			      "Could not find device PSID in MFA2 file", err);
 		return err;
 	}
=20
@@ -241,7 +243,8 @@ static int mlxfw_flash_components(struct mlxfw_dev *mlx=
fw_dev, u32 fwhandle,
 						     mlxfw_dev->psid_size, i);
 		if (IS_ERR(comp)) {
 			err =3D PTR_ERR(comp);
-			NL_SET_ERR_MSG_MOD(extack, "Failed to get MFA2 component");
+			MLXFW_ERR_MSG(mlxfw_dev, extack,
+				      "Failed to get MFA2 component", err);
 			return err;
 		}
=20
@@ -264,16 +267,16 @@ int mlxfw_firmware_flash(struct mlxfw_dev *mlxfw_dev,
 	int err;
=20
 	if (!mlxfw_mfa2_check(firmware)) {
-		mlxfw_err(mlxfw_dev, "Firmware file is not MFA2\n");
-		NL_SET_ERR_MSG_MOD(extack, "Firmware file is not MFA2");
+		MLXFW_ERR_MSG(mlxfw_dev, extack,
+			      "Firmware file is not MFA2", -EINVAL);
 		return -EINVAL;
 	}
=20
 	mfa2_file =3D mlxfw_mfa2_file_init(firmware);
 	if (IS_ERR(mfa2_file)) {
 		err =3D PTR_ERR(mfa2_file);
-		NL_SET_ERR_MSG_MOD(extack,
-				   "Failed to initialize MFA2 firmware file");
+		MLXFW_ERR_MSG(mlxfw_dev, extack,
+			      "Failed to initialize MFA2 firmware file", err);
 		return err;
 	}
=20
@@ -283,8 +286,8 @@ int mlxfw_firmware_flash(struct mlxfw_dev *mlxfw_dev,
 			    NULL, 0, 0);
 	err =3D mlxfw_dev->ops->fsm_lock(mlxfw_dev, &fwhandle);
 	if (err) {
-		mlxfw_err(mlxfw_dev, "Could not lock the firmware FSM\n");
-		NL_SET_ERR_MSG_MOD(extack, "Could not lock the firmware FSM");
+		MLXFW_ERR_MSG(mlxfw_dev, extack,
+			      "Could not lock the firmware FSM", err);
 		goto err_fsm_lock;
 	}
=20
@@ -301,8 +304,8 @@ int mlxfw_firmware_flash(struct mlxfw_dev *mlxfw_dev,
 	mlxfw_status_notify(mlxfw_dev, "Activating image", NULL, 0, 0);
 	err =3D mlxfw_dev->ops->fsm_activate(mlxfw_dev, fwhandle);
 	if (err) {
-		mlxfw_err(mlxfw_dev, "Could not activate the downloaded image\n");
-		NL_SET_ERR_MSG_MOD(extack, "Could not activate the downloaded image");
+		MLXFW_ERR_MSG(mlxfw_dev, extack,
+			      "Could not activate the downloaded image", err);
 		goto err_fsm_activate;
 	}
=20
--=20
2.24.1

