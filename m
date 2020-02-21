Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C16D168977
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 22:46:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728405AbgBUVqJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Feb 2020 16:46:09 -0500
Received: from mail-eopbgr140079.outbound.protection.outlook.com ([40.107.14.79]:9220
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728253AbgBUVqJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 Feb 2020 16:46:09 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BObw6JT94v0fVRN01xz80FgIxh65R72RVxdnHUhb68UvH6g4Farlpq/FdDEBOuqyEbaoz8FRMBzosfu9ICcgLO7SlP3rUR7hfg53YxjK2/dHmr9sV8ri7avCuqe0wbG8e8ZFTAkjLDO3VIdQVVo1oGyhaefVCnqLGTWc07MwvQO/Zyk+IbBzxzZmpdcQVA6VUq5ooto93gIauZxgkquOWgeheCAv+fDzBQYvYHK6Dmu/i7+vuSKh7faJSjE7Rhe2rU/L8FzHM8yB9887oHaxnY26YibFZFcejUZKYn0UOIXeLp8+VxAof4eJsYCxkIfQAjpHxdNgjxpiO5cx/al2Xg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cIcI41F7f/dYBym36fPExGwNLlIv6PJbGmB5/lTYNEc=;
 b=Ct7IRB2dvwljPjv+tJv+18IAvdhrSpdCzIGT2WBCQzjqBFSZs75VQMShL3juV8mVKTxWonIDxCSZ7Mdw9WERbSY7pDheHXzukBrFOpvRCydHmrXhjF9/Y/2oK6gsiomUwydO4dV3PeN8AbcCbbc7USsSoJqh6br69fs4zUKTAOrKOlxJ4jhg8/2dypkeCtPej937FJT96HaaUwcAGLIq9RmwyigSlDg4zghDCavvbNOEVuDyk1VhRlXEYt5ADWPG2EqrKVqbuyCAWqgA5eaTfh3PE3KcuvV7HJxVRVm+gRnCd9gsr9VcK8JoBX+kKu4pb8HheoxmVdhIuKDeAfz/7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cIcI41F7f/dYBym36fPExGwNLlIv6PJbGmB5/lTYNEc=;
 b=e8K1kjoBDNEW/TmimMz06DwtBCMjXUWWP06ISvpQMaBelDMvGKW5GyaNjoHGrIwWXxhZh7QQRZ6yqGs9/0oz2NqM/FdQgW8fR4aUB6zWWEmztjpnvi/4XbP+Y4cwhn9DlNpuoq4+MBpbU/lyVpgHVUGmC53gFtUdp2nEF6xmiDo=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB6927.eurprd05.prod.outlook.com (10.141.234.211) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2750.17; Fri, 21 Feb 2020 21:46:03 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2729.033; Fri, 21 Feb 2020
 21:46:03 +0000
Received: from smtp.office365.com (209.116.155.178) by BY5PR16CA0021.namprd16.prod.outlook.com (2603:10b6:a03:1a0::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2750.18 via Frontend Transport; Fri, 21 Feb 2020 21:46:00 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>
Subject: [PATCH net-next V2 3/7] net/mlxfw: More error messages coverage
Thread-Topic: [PATCH net-next V2 3/7] net/mlxfw: More error messages coverage
Thread-Index: AQHV6QBQF35JeTstNESGfQKVaucSrg==
Date:   Fri, 21 Feb 2020 21:46:03 +0000
Message-ID: <20200221214536.20265-4-saeedm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: da9b429f-785b-47e9-aa98-08d7b717718b
x-ms-traffictypediagnostic: VI1PR05MB6927:|VI1PR05MB6927:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB692710E2227CA7106F46C045BE120@VI1PR05MB6927.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:451;
x-forefront-prvs: 0320B28BE1
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(346002)(366004)(376002)(396003)(136003)(189003)(199004)(186003)(6512007)(8936002)(54906003)(2616005)(316002)(16526019)(956004)(4326008)(478600001)(107886003)(6506007)(110136005)(52116002)(6486002)(26005)(86362001)(1076003)(66946007)(64756008)(66446008)(66476007)(81156014)(81166006)(5660300002)(8676002)(15650500001)(36756003)(71200400001)(2906002)(66556008)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB6927;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: w8nFfguudkZmA2hIZtMYwv5xWKXq+uKSueZ1aM8W4p5p90nR3BwBQ2VkaXQYi+SBnSSl1vVn4s4LX9v3uZXJFOZI6JlKTQqyQzMNjwpUdb4txiEmshnpX/bcTIsKv8h/GAX5lgzmaQ5pSTPe2ag9/3UNsmYS992NtnVE8/oroilKdblGYbLWeTRA+p3/XUfU1WXvtZUKIjWaGWJat72atrmGVVyLcrQbJAU8oT7nzUNBrcWLMFC0QZKsd2pAffdYkicHC/YNaggQIyk3UEvoP1hph2RBWFqJw5KagprP06FzqDQPKq8wi2spOwaGCkq/R/dGw4OzJktHXNwYUygKBaME4Cm/iJGHq4zaaVD+gnxH094xi2LYbrfq7IDfnKTaW9gakcuolVwQDoy9D/lrVLssVbuAjt9JpFH4gVs8mmOJ9wpcDPNvYB4M+3uDd00ge03LbwL7ME2YAXAL3Vz/jjCd2Z9h50ZXskq88nvknYwwc8JLac+/JgNEq5jUfgLT1limuh0GSUxYT9mFcRJkRzH4yJDOaLv8wHZUveKTFUQ=
x-ms-exchange-antispam-messagedata: egIaazX5wat7Tp24cIWXhEM9SmtnahrGLXSH8xrO8okKJKM8lKv6Mi8DgbQM/Nls4BqPbXrjlWYsP5yiPcc8RQWHaUtB7GxL2hy10O3d3rMyTpomX0h4LfUDSs1dITlzDh076m4PyQukTubI4GiEhg==
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: da9b429f-785b-47e9-aa98-08d7b717718b
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Feb 2020 21:46:03.5541
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: m0Svw74naN+WRFzZ9h8uD78QLStXjx+Kiue+o/LTEY1YC8g+99i+Hxa9egdshRtYVYH1T18OePmcdZhY/MYmfA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6927
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make sure mlxfw_firmware_flash reports a detailed user readable error
message in every possible error path, basically every time
mlxfw_dev->ops->*() is called and an error is returned, or when image
initialization is failed.

Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 .../net/ethernet/mellanox/mlxfw/mlxfw_fsm.c   | 35 ++++++++++++++-----
 1 file changed, 26 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxfw/mlxfw_fsm.c b/drivers/net/=
ethernet/mellanox/mlxfw/mlxfw_fsm.c
index cc5ea5ffdbba..422619e21183 100644
--- a/drivers/net/ethernet/mellanox/mlxfw/mlxfw_fsm.c
+++ b/drivers/net/ethernet/mellanox/mlxfw/mlxfw_fsm.c
@@ -93,8 +93,10 @@ static int mlxfw_fsm_state_wait(struct mlxfw_dev *mlxfw_=
dev, u32 fwhandle,
 retry:
 	err =3D mlxfw_dev->ops->fsm_query_state(mlxfw_dev, fwhandle,
 					      &curr_fsm_state, &fsm_state_err);
-	if (err)
+	if (err) {
+		NL_SET_ERR_MSG_MOD(extack, "FSM state query failed");
 		return err;
+	}
=20
 	if (fsm_state_err !=3D MLXFW_FSM_STATE_ERR_OK)
 		return mlxfw_fsm_state_err(extack, fsm_state_err);
@@ -142,8 +144,10 @@ static int mlxfw_flash_component(struct mlxfw_dev *mlx=
fw_dev,
 	err =3D mlxfw_dev->ops->component_query(mlxfw_dev, comp->index,
 					      &comp_max_size, &comp_align_bits,
 					      &comp_max_write_size);
-	if (err)
+	if (err) {
+		NL_SET_ERR_MSG_MOD(extack, "FSM component query failed");
 		return err;
+	}
=20
 	comp_max_size =3D min_t(u32, comp_max_size, MLXFW_FSM_MAX_COMPONENT_SIZE)=
;
 	if (comp->data_size > comp_max_size) {
@@ -161,8 +165,10 @@ static int mlxfw_flash_component(struct mlxfw_dev *mlx=
fw_dev,
 	err =3D mlxfw_dev->ops->fsm_component_update(mlxfw_dev, fwhandle,
 						   comp->index,
 						   comp->data_size);
-	if (err)
+	if (err) {
+		NL_SET_ERR_MSG_MOD(extack, "FSM component update failed");
 		return err;
+	}
=20
 	err =3D mlxfw_fsm_state_wait(mlxfw_dev, fwhandle,
 				   MLXFW_FSM_STATE_DOWNLOAD, extack);
@@ -181,8 +187,10 @@ static int mlxfw_flash_component(struct mlxfw_dev *mlx=
fw_dev,
 		err =3D mlxfw_dev->ops->fsm_block_download(mlxfw_dev, fwhandle,
 							 block_ptr, block_size,
 							 offset);
-		if (err)
+		if (err) {
+			NL_SET_ERR_MSG_MOD(extack, "Component download failed");
 			goto err_out;
+		}
 		mlxfw_status_notify(mlxfw_dev, "Downloading component",
 				    comp_name, offset + block_size,
 				    comp->data_size);
@@ -192,8 +200,10 @@ static int mlxfw_flash_component(struct mlxfw_dev *mlx=
fw_dev,
 	mlxfw_status_notify(mlxfw_dev, "Verifying component", comp_name, 0, 0);
 	err =3D mlxfw_dev->ops->fsm_component_verify(mlxfw_dev, fwhandle,
 						   comp->index);
-	if (err)
+	if (err) {
+		NL_SET_ERR_MSG_MOD(extack, "FSM component verify failed");
 		goto err_out;
+	}
=20
 	err =3D mlxfw_fsm_state_wait(mlxfw_dev, fwhandle,
 				   MLXFW_FSM_STATE_LOCKED, extack);
@@ -228,8 +238,11 @@ static int mlxfw_flash_components(struct mlxfw_dev *ml=
xfw_dev, u32 fwhandle,
=20
 		comp =3D mlxfw_mfa2_file_component_get(mfa2_file, mlxfw_dev->psid,
 						     mlxfw_dev->psid_size, i);
-		if (IS_ERR(comp))
-			return PTR_ERR(comp);
+		if (IS_ERR(comp)) {
+			err =3D PTR_ERR(comp);
+			NL_SET_ERR_MSG_MOD(extack, "Failed to get MFA2 component");
+			return err;
+		}
=20
 		pr_info("Flashing component type %d\n", comp->index);
 		err =3D mlxfw_flash_component(mlxfw_dev, fwhandle, comp, extack);
@@ -255,8 +268,12 @@ int mlxfw_firmware_flash(struct mlxfw_dev *mlxfw_dev,
 	}
=20
 	mfa2_file =3D mlxfw_mfa2_file_init(firmware);
-	if (IS_ERR(mfa2_file))
-		return PTR_ERR(mfa2_file);
+	if (IS_ERR(mfa2_file)) {
+		err =3D PTR_ERR(mfa2_file);
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Failed to initialize MFA2 firmware file");
+		return err;
+	}
=20
 	pr_info("Initialize firmware flash process\n");
 	devlink_flash_update_begin_notify(mlxfw_dev->devlink);
--=20
2.24.1

