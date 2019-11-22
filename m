Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D290107AC8
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 23:43:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727414AbfKVWmK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 17:42:10 -0500
Received: from mail-eopbgr150047.outbound.protection.outlook.com ([40.107.15.47]:57606
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727406AbfKVWmJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Nov 2019 17:42:09 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NdZqbisOpjFbj0XLpe44oDiWDIdqG+1MkuI5HnuKqdKTkX65Qcsm509SQh1G7rdTTRXIHzbuowgZQ2taMTh/BQkLB5GmzJVw21HpgZ932ldQNFHv9shJKHR0cbOU2FEas1VQ/6sa1vZhZzmMwMssLbm5VxvT/SWUPbwF46cLuDcRXrPKoiyZflcmWv7b6wWGbifPl7tm3Cz65PIvXtmAdiRLLsvUawWaj6GimDtYn5/SZqVFJ4tW9PkslEYJWGCwl+M6+rFPvfHT3JfF4AGQyXIBB4cq1Q4eIcRjUlP6QiRRluTk7SKCPfiLVVbGbrtXMjFp9UDnnOm0N+T83Jr9RA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zcEzRsr9cfvWNXVM8083tCSiuT3lcx7EjpiHjKOxIPc=;
 b=HZt6vTwkqZ7Xd6hqbIH8NFO55BzVQAT5tlbsKJ7nYep4Ns2iUTL3upY7GY4uQHpoMJqqmA/xC5H0E2MrzHSZh60fH1ElkQiKDK3i2rFxLZyMDCMz45fqdEJtHydA7rZk0Fx3LCH7rrAYyjn2lCgLUt7wT9KBtFRs8YoJqi4bhjYqKPtT5iP7QVjp6dZ4DgXV+EnxLle+cm57OoEbl3o0pKhtG0KeQozPtd6nj+laRz1lzRxG+kX/fHzrMsAZj16GCn/QkIXoYqIvjNxbAiRe4v+iD4TCWCy5rcG3BWWzs/IJB2Xp4u/Jh85eFBbl3iPb+HQy5P9KohVUrvNlCuWVKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zcEzRsr9cfvWNXVM8083tCSiuT3lcx7EjpiHjKOxIPc=;
 b=dTUP/2xDmh/zBFczwHEURfAD0OwA2L5zyKl+eMHipgU15pFC+8pXLS04hdXqsYNMZejx2NefQzIfad6s7wXvoCsYvxYGDhbkTvS4C546DbWvwfPtgLS9IzCRbB6Esdle3bap4IwrH9+YpqbaLsBDNgCOIpCI9BnA2Di2n7n6pbI=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB6718.eurprd05.prod.outlook.com (10.186.162.137) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2474.17; Fri, 22 Nov 2019 22:41:54 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e%5]) with mapi id 15.20.2474.019; Fri, 22 Nov 2019
 22:41:54 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH V2 net-next 5/6] net/mlxfw: More error messages coverage
Thread-Topic: [PATCH V2 net-next 5/6] net/mlxfw: More error messages coverage
Thread-Index: AQHVoYYJZyGYA4qj10W8U5kWjoj9Lw==
Date:   Fri, 22 Nov 2019 22:41:54 +0000
Message-ID: <20191122224126.24847-6-saeedm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: c57d3192-ac66-414f-d09f-08d76f9d2c45
x-ms-traffictypediagnostic: VI1PR05MB6718:|VI1PR05MB6718:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB6718B2A3EA9FB8C0A769D855BE490@VI1PR05MB6718.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:93;
x-forefront-prvs: 02296943FF
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(346002)(39860400002)(366004)(136003)(376002)(189003)(199004)(14454004)(66946007)(64756008)(66556008)(1076003)(66066001)(66476007)(4326008)(6486002)(66446008)(14444005)(8936002)(6512007)(6916009)(7736002)(6506007)(26005)(256004)(305945005)(386003)(186003)(3846002)(102836004)(6116002)(11346002)(2616005)(446003)(107886003)(2906002)(478600001)(99286004)(8676002)(25786009)(52116002)(81156014)(36756003)(81166006)(76176011)(316002)(6436002)(54906003)(86362001)(50226002)(5660300002)(15650500001)(71190400001)(71200400001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB6718;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VxFZX18mM2q8RSWirMnv/+zxR14CFMXWndV7Fdpm8nR5Ea3IimEP9JO3leEwaPe+hNpmSYL6WRH22mBYNSfGCsLnyB3P3esv4t04PUc8b8TYRxV79MUIzVValfOpTw7SsAf2WSsY0F8q5dF0Gg1tbzrvHwPwGGn/KDbJuX9mjDRnY4f7xTJNKTZiwrhrBronAvjPg/sc2kVJarpJJJVjChQopUAjXgwn3S1UjIHaMkFm/1gs/loYiRRTRVYb0GLknmrHLaG2sHG4BdaOJacNita/BBOpsZNwmm+PusNguIpuYnQdR3hI/qECGSWdd9PyIyxN672VRoiN0vOxuelt06ZKB9TSbxdrmSBtezBh/N9KiebFNfaJHj23Bxqk08lMxvUl78B2Ws443Zh06RNUy5pUApXB85TvD/ktg2YYWch6QlnGgCrsW616g6KL+E5W
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c57d3192-ac66-414f-d09f-08d76f9d2c45
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Nov 2019 22:41:54.0955
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AU/i3WEoEuBqE+ZoEV8Fsu02z/ja1a2OnxennUysYX2l+OB2/vEt1IgU/osFByjBfYgPqwyF03VR83xLRK68lw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6718
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
 .../net/ethernet/mellanox/mlxfw/mlxfw_fsm.c   | 47 +++++++++++++++----
 1 file changed, 38 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxfw/mlxfw_fsm.c b/drivers/net/=
ethernet/mellanox/mlxfw/mlxfw_fsm.c
index 3ac0459aeac7..2726f17a68fe 100644
--- a/drivers/net/ethernet/mellanox/mlxfw/mlxfw_fsm.c
+++ b/drivers/net/ethernet/mellanox/mlxfw/mlxfw_fsm.c
@@ -81,8 +81,11 @@ static int mlxfw_fsm_state_wait(struct mlxfw_dev *mlxfw_=
dev, u32 fwhandle,
 retry:
 	err =3D mlxfw_dev->ops->fsm_query_state(mlxfw_dev, fwhandle,
 					      &curr_fsm_state, &fsm_state_err);
-	if (err)
+	if (err) {
+		NL_SET_ERR_MSG_MOD(extack, "FSM state query failed, err (%d)",
+				   err);
 		return err;
+	}
=20
 	if (fsm_state_err !=3D MLXFW_FSM_STATE_ERR_OK)
 		return mlxfw_fsm_state_err(mlxfw_dev, extack, fsm_state_err);
@@ -130,8 +133,12 @@ static int mlxfw_flash_component(struct mlxfw_dev *mlx=
fw_dev,
 	err =3D mlxfw_dev->ops->component_query(mlxfw_dev, comp->index,
 					      &comp_max_size, &comp_align_bits,
 					      &comp_max_write_size);
-	if (err)
+	if (err) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "FSM component query failed, comp_name(%s) err (%d)",
+				   comp_name, err);
 		return err;
+	}
=20
 	comp_max_size =3D min_t(u32, comp_max_size, MLXFW_FSM_MAX_COMPONENT_SIZE)=
;
 	if (comp->data_size > comp_max_size) {
@@ -149,8 +156,12 @@ static int mlxfw_flash_component(struct mlxfw_dev *mlx=
fw_dev,
 	err =3D mlxfw_dev->ops->fsm_component_update(mlxfw_dev, fwhandle,
 						   comp->index,
 						   comp->data_size);
-	if (err)
+	if (err) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "FSM component update failed, comp_name(%s) err (%d)",
+				   comp_name, err);
 		return err;
+	}
=20
 	err =3D mlxfw_fsm_state_wait(mlxfw_dev, fwhandle,
 				   MLXFW_FSM_STATE_DOWNLOAD, extack);
@@ -169,8 +180,12 @@ static int mlxfw_flash_component(struct mlxfw_dev *mlx=
fw_dev,
 		err =3D mlxfw_dev->ops->fsm_block_download(mlxfw_dev, fwhandle,
 							 block_ptr, block_size,
 							 offset);
-		if (err)
+		if (err) {
+			NL_SET_ERR_MSG_MOD(extack,
+					   "Component download failed, comp_name(%s) err (%d)",
+					   comp_name, err);
 			goto err_out;
+		}
 		mlxfw_status_notify(mlxfw_dev, "Downloading component",
 				    comp_name, offset + block_size,
 				    comp->data_size);
@@ -180,8 +195,12 @@ static int mlxfw_flash_component(struct mlxfw_dev *mlx=
fw_dev,
 	mlxfw_status_notify(mlxfw_dev, "Verifying component", comp_name, 0, 0);
 	err =3D mlxfw_dev->ops->fsm_component_verify(mlxfw_dev, fwhandle,
 						   comp->index);
-	if (err)
+	if (err) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "FSM component verify failed, comp_name(%s) err (%d)",
+				   comp_name, err);
 		goto err_out;
+	}
=20
 	err =3D mlxfw_fsm_state_wait(mlxfw_dev, fwhandle,
 				   MLXFW_FSM_STATE_LOCKED, extack);
@@ -216,8 +235,13 @@ static int mlxfw_flash_components(struct mlxfw_dev *ml=
xfw_dev, u32 fwhandle,
=20
 		comp =3D mlxfw_mfa2_file_component_get(mfa2_file, mlxfw_dev->psid,
 						     mlxfw_dev->psid_size, i);
-		if (IS_ERR(comp))
-			return PTR_ERR(comp);
+		if (IS_ERR(comp)) {
+			err =3D PTR_ERR(comp);
+			NL_SET_ERR_MSG_MOD(extack,
+					   "Failed to get MFA2 component, component (%d) err (%d)",
+					   i, err);
+			return err;
+		}
=20
 		mlxfw_info(mlxfw_dev, "Flashing component type %d\n",
 			   comp->index);
@@ -244,8 +268,13 @@ int mlxfw_firmware_flash(struct mlxfw_dev *mlxfw_dev,
 	}
=20
 	mfa2_file =3D mlxfw_mfa2_file_init(firmware);
-	if (IS_ERR(mfa2_file))
-		return PTR_ERR(mfa2_file);
+	if (IS_ERR(mfa2_file)) {
+		err =3D PTR_ERR(mfa2_file);
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Failed to initialize MFA2 firmware file, err (%d)",
+				   err);
+		return err;
+	}
=20
 	mlxfw_info(mlxfw_dev, "Initialize firmware flash process\n");
 	devlink_flash_update_begin_notify(mlxfw_dev->devlink);
--=20
2.21.0

