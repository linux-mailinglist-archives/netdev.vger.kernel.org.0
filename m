Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 32B38107A42
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 22:52:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726937AbfKVVwH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 16:52:07 -0500
Received: from mail-eopbgr80058.outbound.protection.outlook.com ([40.107.8.58]:24062
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726869AbfKVVwH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Nov 2019 16:52:07 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QEitRIf3jlPyop64kDkWPN65QQt+oXjFyYC2sFW5m9CCx2ktULVzpnpZwugmngqx/mwW2RiaWaWDjarNZ7abq2wJhqduuKh5zHVlW12mUP7Lp5HrDGmU6yqzs1wW2WcDjCtkDG7C2ADAQfjA8m7DqiOs+zAvHVDGf6jvLF6Npv5pzBmxUcVZnDgW//BUXxR6wU1SrfcHRVjuqL/eNH39YhdIJrjUOT7U41LSYZ888ZWMrimdWPN+vWp1PnGydL4vmeYlH2fOWvSdgLenhVX9km7CUR/JXiU5FHAZu/SqlLuWMn6xccf8yTwtOnLrBxHESgXHJuT7vEW8AU3PbahjDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P73tfmOdipxtC0/SYOlwdLR9agWDYJBBq/YUT1QxvEw=;
 b=d6ICQBRjsieD1Y30wS5XlfNEHLBeFcAVqKQ8wOIE6hpqLY2eb4+YVtDuqENOqVjZXV/rqF5IDjvkBH2LcJJBY6vBcLSnvbwZKWEm0azXJNSuT90wynPtBPDDwna7i3te44EnzkoSZc6DuIjzvGBouKh+b3xwJYdxmfOQiRlWZGi3dy7y1GlUPDRoaF64Cri1YAK58k3LoWlTLTroG33c6WEB/a4HZTGPZeB5o0bbauh92AhjG2IJdqoPGzAFoqm3RzNJauEC6epIPZ521StUDid53FI+AngCehwE4aFLujfOczUS4dLUlKXMCR88MaNg6lVfe9+Rx28WQUuYB0QDDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P73tfmOdipxtC0/SYOlwdLR9agWDYJBBq/YUT1QxvEw=;
 b=ILj94RxR61xlQssluxW6GblipMzqsObJ6uMGNyqkcEIUfvKzdAKUoYK8b8hlHz0hdzIifUxoqyQ3eL2C5B9jTQxfod1NjTB0nJwYXs4YMQoJNLB7aIPpFYc0ki/9fCA+VGmhckXm0UHaMClKyj1/+syiKVEAlnL4fkJma2ktBUE=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB5341.eurprd05.prod.outlook.com (20.178.8.218) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2474.17; Fri, 22 Nov 2019 21:51:58 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e%5]) with mapi id 15.20.2474.019; Fri, 22 Nov 2019
 21:51:58 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH net-next 6/6] net/mlxfw: Macro for error reporting
Thread-Topic: [PATCH net-next 6/6] net/mlxfw: Macro for error reporting
Thread-Index: AQHVoX8QKRNFtkhANUSm2jFNIr0lbQ==
Date:   Fri, 22 Nov 2019 21:51:58 +0000
Message-ID: <20191122215111.21723-7-saeedm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: 04547026-036e-4aa9-d752-08d76f9632c8
x-ms-traffictypediagnostic: VI1PR05MB5341:|VI1PR05MB5341:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB53416BDF09DBDE975DBE4007BE490@VI1PR05MB5341.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:446;
x-forefront-prvs: 02296943FF
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(376002)(39860400002)(346002)(396003)(366004)(189003)(199004)(107886003)(8676002)(386003)(6506007)(3846002)(36756003)(6512007)(26005)(478600001)(1076003)(316002)(66476007)(2906002)(6116002)(66556008)(64756008)(66446008)(71200400001)(71190400001)(99286004)(66946007)(66066001)(25786009)(4326008)(14444005)(256004)(54906003)(50226002)(102836004)(446003)(7736002)(186003)(305945005)(6436002)(6486002)(8936002)(76176011)(11346002)(52116002)(6916009)(14454004)(81156014)(5660300002)(81166006)(2616005)(86362001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5341;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /ShJzdR7NsNQe8y+Ip/Z2E+PRtOWSUkpkrK0WTwgz9Bf2gOgTJR9aplscADcVeBpcAkShcCU+p9HmteKBVjhVx0jk3v7GfI9oTEKsA2kyicfa0sNqjLQZcfzGMlWvYYb216NqhyyQDgP4JPyE5IBPDAE0HbiCF4jRkc8j+YkaK+gqi5hOqTbUGQApd7y2zc2/CW2oacL61M4TqiQjPYAtsclEOIaw9zlaedTZqqnBHEtOMAgJaFu/ZrOemgQSceBq351jm0J5P69LfhgiZZVIukvgG/yL2xjVKQpJl3TtepNYNs85EVOqjzuPkJWnlEeF/bpYeDVwOP6yES2OMEJZM+HwfDzyMQFY1aGT6Ziar+2PtrpmOGt/K1CVWqUHORsQfuc5hY25/XEPYIrrOWL1NiaTp02ooVmgJoFe853uRIZEwsKn9ACONSEkmX7TNhW
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 04547026-036e-4aa9-d752-08d76f9632c8
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Nov 2019 21:51:58.6863
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dOlNqo0Gqs3lzHUt8XC4ElNW9eZPaPa0f8JqZV6l0We4k9TnEANQDBBTDg07TgnfdWIHvxCmfW1/P4kkzlQbLg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5341
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a macro to simplify error message reporting, instead of always
calling both mlxfw_err and NL_SET_ERR_MSG_MOD with the same message,
use a macro instead.

This is doable now since NL_SET_ERR_MSG_MOD can accept formattable
messages.

Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 .../net/ethernet/mellanox/mlxfw/mlxfw_fsm.c   | 72 ++++++++++---------
 1 file changed, 39 insertions(+), 33 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxfw/mlxfw_fsm.c b/drivers/net/=
ethernet/mellanox/mlxfw/mlxfw_fsm.c
index c29c385d1dd0..5715192d2195 100644
--- a/drivers/net/ethernet/mellanox/mlxfw/mlxfw_fsm.c
+++ b/drivers/net/ethernet/mellanox/mlxfw/mlxfw_fsm.c
@@ -95,6 +95,12 @@ static void mlxfw_status_notify(struct mlxfw_dev *mlxfw_=
dev,
 					   done_bytes, total_bytes);
 }
=20
+#define MLXFW_ERR_MSG(mlxfw_dev, extack, fmt, ...)	\
+({							\
+	mlxfw_err(mlxfw_dev, fmt "\n", ## __VA_ARGS__);	\
+	NL_SET_ERR_MSG_MOD(extack, fmt, ## __VA_ARGS__);\
+})
+
 static int mlxfw_fsm_state_wait(struct mlxfw_dev *mlxfw_dev, u32 fwhandle,
 				enum mlxfw_fsm_state fsm_state,
 				struct netlink_ext_ack *extack)
@@ -109,8 +115,8 @@ static int mlxfw_fsm_state_wait(struct mlxfw_dev *mlxfw=
_dev, u32 fwhandle,
 	err =3D mlxfw_dev->ops->fsm_query_state(mlxfw_dev, fwhandle,
 					      &curr_fsm_state, &fsm_state_err);
 	if (err) {
-		NL_SET_ERR_MSG_MOD(extack, "FSM state query failed, err (%d)",
-				   err);
+		MLXFW_ERR_MSG(mlxfw_dev, extack, "FSM state query failed, err (%d)",
+			      err);
 		return err;
 	}
=20
@@ -119,8 +125,8 @@ static int mlxfw_fsm_state_wait(struct mlxfw_dev *mlxfw=
_dev, u32 fwhandle,
=20
 	if (curr_fsm_state !=3D fsm_state) {
 		if (--times =3D=3D 0) {
-			mlxfw_err(mlxfw_dev, "Timeout reached on FSM state change\n");
-			NL_SET_ERR_MSG_MOD(extack, "Timeout reached on FSM state change");
+			MLXFW_ERR_MSG(mlxfw_dev, extack,
+				      "Timeout reached on FSM state change");
 			return -ETIMEDOUT;
 		}
 		msleep(MLXFW_FSM_STATE_WAIT_CYCLE_MS);
@@ -153,17 +159,17 @@ static int mlxfw_flash_component(struct mlxfw_dev *ml=
xfw_dev,
 					      &comp_max_size, &comp_align_bits,
 					      &comp_max_write_size);
 	if (err) {
-		NL_SET_ERR_MSG_MOD(extack,
-				   "FSM component query failed, comp_name(%s) err (%d)",
-				   comp_name, err);
+		MLXFW_ERR_MSG(mlxfw_dev, extack,
+			      "FSM component query failed, comp_name(%s) err (%d)",
+			      comp_name, err);
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
+			      "Component size is bigger than limit, Component %d size %d limit =
%d",
+			      comp->index, comp->data_size, comp_max_size);
 		return -EINVAL;
 	}
=20
@@ -176,9 +182,9 @@ static int mlxfw_flash_component(struct mlxfw_dev *mlxf=
w_dev,
 						   comp->index,
 						   comp->data_size);
 	if (err) {
-		NL_SET_ERR_MSG_MOD(extack,
-				   "FSM component update failed, comp_name(%s) err (%d)",
-				   comp_name, err);
+		MLXFW_ERR_MSG(mlxfw_dev, extack,
+			      "FSM component update failed, comp_name(%s) err (%d)",
+			      comp_name, err);
 		return err;
 	}
=20
@@ -200,9 +206,9 @@ static int mlxfw_flash_component(struct mlxfw_dev *mlxf=
w_dev,
 							 block_ptr, block_size,
 							 offset);
 		if (err) {
-			NL_SET_ERR_MSG_MOD(extack,
-					   "Component download failed, comp_name(%s) err (%d)",
-					   comp_name, err);
+			MLXFW_ERR_MSG(mlxfw_dev, extack,
+				      "Component download failed, comp_name(%s) err (%d)",
+				      comp_name, err);
 			goto err_out;
 		}
 		mlxfw_status_notify(mlxfw_dev, "Downloading component",
@@ -215,9 +221,9 @@ static int mlxfw_flash_component(struct mlxfw_dev *mlxf=
w_dev,
 	err =3D mlxfw_dev->ops->fsm_component_verify(mlxfw_dev, fwhandle,
 						   comp->index);
 	if (err) {
-		NL_SET_ERR_MSG_MOD(extack,
-				   "FSM component verify failed, comp_name(%s) err (%d)",
-				   comp_name, err);
+		MLXFW_ERR_MSG(mlxfw_dev, extack,
+			      "FSM component verify failed, comp_name(%s) err (%d)",
+			      comp_name, err);
 		goto err_out;
 	}
=20
@@ -244,8 +250,9 @@ static int mlxfw_flash_components(struct mlxfw_dev *mlx=
fw_dev, u32 fwhandle,
 					      mlxfw_dev->psid_size,
 					      &component_count);
 	if (err) {
-		mlxfw_err(mlxfw_dev, "Could not find device PSID in MFA2 file\n");
-		NL_SET_ERR_MSG_MOD(extack, "Could not find device PSID in MFA2 file");
+		MLXFW_ERR_MSG(mlxfw_dev, extack,
+			      "Could not find device PSID in MFA2 file, err (%d)",
+			      err);
 		return err;
 	}
=20
@@ -256,9 +263,9 @@ static int mlxfw_flash_components(struct mlxfw_dev *mlx=
fw_dev, u32 fwhandle,
 						     mlxfw_dev->psid_size, i);
 		if (IS_ERR(comp)) {
 			err =3D PTR_ERR(comp);
-			NL_SET_ERR_MSG_MOD(extack,
-					   "Failed to get MFA2 component, component (%d) err (%d)",
-					   i, err);
+			MLXFW_ERR_MSG(mlxfw_dev, extack,
+				      "Failed to get MFA2 component, component (%d) err (%d)",
+				      i, err);
 			return err;
 		}
=20
@@ -281,17 +288,16 @@ int mlxfw_firmware_flash(struct mlxfw_dev *mlxfw_dev,
 	int err;
=20
 	if (!mlxfw_mfa2_check(firmware)) {
-		mlxfw_err(mlxfw_dev, "Firmware file is not MFA2\n");
-		NL_SET_ERR_MSG_MOD(extack, "Firmware file is not MFA2");
+		MLXFW_ERR_MSG(mlxfw_dev, extack, "Firmware file is not MFA2");
 		return -EINVAL;
 	}
=20
 	mfa2_file =3D mlxfw_mfa2_file_init(firmware);
 	if (IS_ERR(mfa2_file)) {
 		err =3D PTR_ERR(mfa2_file);
-		NL_SET_ERR_MSG_MOD(extack,
-				   "Failed to initialize MFA2 firmware file, err (%d)",
-				   err);
+		MLXFW_ERR_MSG(mlxfw_dev, extack,
+			      "Failed to initialize MFA2 firmware file, err (%d)",
+			      err);
 		return err;
 	}
=20
@@ -301,8 +307,8 @@ int mlxfw_firmware_flash(struct mlxfw_dev *mlxfw_dev,
 			    NULL, 0, 0);
 	err =3D mlxfw_dev->ops->fsm_lock(mlxfw_dev, &fwhandle);
 	if (err) {
-		mlxfw_err(mlxfw_dev, "Could not lock the firmware FSM\n");
-		NL_SET_ERR_MSG_MOD(extack, "Could not lock the firmware FSM");
+		MLXFW_ERR_MSG(mlxfw_dev, extack,
+			      "Could not lock the firmware FSM, err (%d)", err);
 		goto err_fsm_lock;
 	}
=20
@@ -319,8 +325,8 @@ int mlxfw_firmware_flash(struct mlxfw_dev *mlxfw_dev,
 	mlxfw_status_notify(mlxfw_dev, "Activating image", NULL, 0, 0);
 	err =3D mlxfw_dev->ops->fsm_activate(mlxfw_dev, fwhandle);
 	if (err) {
-		mlxfw_err(mlxfw_dev, "Could not activate the downloaded image\n");
-		NL_SET_ERR_MSG_MOD(extack, "Could not activate the downloaded image");
+		MLXFW_ERR_MSG(mlxfw_dev, extack,
+			      "Could not activate the downloaded image, err (%d)", err);
 		goto err_fsm_activate;
 	}
=20
--=20
2.21.0

