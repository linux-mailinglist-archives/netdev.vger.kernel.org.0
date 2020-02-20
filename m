Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C5F5165503
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 03:26:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727913AbgBTC0A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 21:26:00 -0500
Received: from mail-am6eur05on2089.outbound.protection.outlook.com ([40.107.22.89]:32566
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727211AbgBTCZ7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Feb 2020 21:25:59 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C8PUOJljvcQioM8IodcG2JRYqcKV3v1A6gah6jeHbRDf1kQDIGbjeIbwV2yjLHwPaTEVvUZaM9o68U6NAGXVFZw23XuZG3BY1CqHN+WaGAI66tHCuquSG5FwBJA2hkMMcaqFdF4DF8bV8W+VV5kvuv5zppLXg8qaPqwGsOEf1RZYuamSy3vSTYM9UXFjzlZHRz4vv6VItkO78Wv1Y4HFuSGAprSfdQ8tRvBA9KNQxQJyvYeiZSNs/qtgZr2QfMKVGVi9S3U14QBnMHfpB7l5ZsHjGfDsDCw/tPRWO0/uN8gLHp4wKPoDWqJduHbB89mVF695QnZsjAviUdH7cwla9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Bjq/zxcDlrSuHbMyJHm94PWzocQPdWSPiGMFLTvXMXk=;
 b=RhUZFFq52DUUd4p7Q0tiY44R3sCLfnXEwCJtnGxLjuRbJ7LmO6lICEzA7klUdgT7tUTp+Pwq/bepTzCgCT4g+qetkgt+F/kn1iPtlHP9AKf3pP9PZU5mxg4dc6/+juFhgdKcVe+iu5F8D3IfQgAb09HXup9tO0JUl341Zlg234U+SvSaCL7Ot5bBG+QX2Rmtcm/iq3tZhS80I23T5Wyzb4ldiFpWByZlDvGRFlSd1nfu2SjF/AJuj0RXUZ+fw1juFjo3AVshFe8jF3KbxnpnYCnJ37J1FSODvvMJntWecPr8v8sPTlWd0H6QRecPLuTNP2TVKUiG0uVfFp4swMe/0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Bjq/zxcDlrSuHbMyJHm94PWzocQPdWSPiGMFLTvXMXk=;
 b=P7W+sCVYG1PNXOsUdVIBCtGFTmHsZRKpRo2OY/8bpQRIe1KnN3WWBt4jr0lDwuINtOqVdxCAMwJLwkyENyObcgdp3XLTSGW2IWE/JpE9eFlje9KF6qZPDbmkgyIsfWV8Cgwpl9B4w8wLQD/8ScZYkewgt194W8zSt8aWI7UQaMw=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB4173.eurprd05.prod.outlook.com (52.134.122.29) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2729.31; Thu, 20 Feb 2020 02:25:53 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2729.028; Thu, 20 Feb 2020
 02:25:53 +0000
Received: from smtp.office365.com (73.15.39.150) by BY5PR20CA0022.namprd20.prod.outlook.com (2603:10b6:a03:1f4::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2750.18 via Frontend Transport; Thu, 20 Feb 2020 02:25:50 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH net-next 5/7] net/mlxfw: Use MLXFW_ERR_MSG macro for error
 reporting
Thread-Topic: [PATCH net-next 5/7] net/mlxfw: Use MLXFW_ERR_MSG macro for
 error reporting
Thread-Index: AQHV55USQxzYresE4EGXg4NcejpakA==
Date:   Thu, 20 Feb 2020 02:25:53 +0000
Message-ID: <20200220022502.38262-6-saeedm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: c616c14d-b942-493b-5229-08d7b5ac3506
x-ms-traffictypediagnostic: VI1PR05MB4173:|VI1PR05MB4173:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB4173F206FE2A57B524BA7F5CBE130@VI1PR05MB4173.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3826;
x-forefront-prvs: 031996B7EF
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(366004)(39860400002)(376002)(136003)(346002)(199004)(189003)(54906003)(5660300002)(2906002)(26005)(478600001)(71200400001)(6486002)(6512007)(16526019)(110136005)(52116002)(316002)(186003)(86362001)(6506007)(4326008)(956004)(2616005)(1076003)(107886003)(64756008)(81156014)(81166006)(66946007)(66556008)(8936002)(66476007)(8676002)(36756003)(66446008)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4173;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3tUULxRm7kw5R9ZlI+DfDwAMBU4wezdP16fuRHDnh6OL1zTrbCQJMk6fwcYiWSqCkrbkCpB4YEWWO7RULA33uu9uha5pCf1n64WQbBe/SKV/22iGFdxKA0NNwq9989qWtxf1hm8qAKtAJCS4QnX86cuISQokmKpC13M7eBykc5Qfnt+miLFKKfX8UBEmnd1+hvDRIWbB9hpSH22VtHoinyCaQTKDYwP6jkMxGhxb8SeHCtREnA8PkNbcU3ZQWFc/JjzWO9MPvZsw4iIIdLOuX7/ShJlhXFcN6yKHxNJQR+AMneyOcwNXSEy1aWC0etFeEMmxK5hhB2iV3gjiCYo+kxTSM0rbS+Gz5YXSXDfHovI87P9Xq0rMSkU0oAq7NTu9oIpvxcat8hviZ33xRKWFnpKS0f1Hx1gvi17Mxl2Dyoc6SVy4R/1SuxFVNDJEdMTvEIMAno7HCMJzqTqXKUDh/cQiDddyE3NEl0J3Vhq8imDANm5r1Gb7mpXeZ6XXLsyCCYkV7yXOjKxhZMtxSsepKPUqmLxNBAZaeQ6ZjS8My/A=
x-ms-exchange-antispam-messagedata: 25vNJb8gufmo0Fk0Wc7PB/EKc9CFElSCqCaVU4BwYrTIgTiW+cu7TFw/AI8WzTokcr7FVOCVRgDJb4jVXESb0ACCa+O7PINqfFYbNSz+tGhbDR6EcJY4QMdn9gwHcGBTC5meM/Q2obiAePolGayFkw==
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c616c14d-b942-493b-5229-08d7b5ac3506
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Feb 2020 02:25:53.5277
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Tcbc/khZbWQEhUabI8R+eZaW7uDBaonDISsqpcjNxLKDZkiziLrGGjztnQh+aqudogw+Xwh7R8Jab1W2Dhkf5w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4173
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
index c4caa112216f..c186924c2cfd 100644
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

