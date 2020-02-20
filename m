Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F443165501
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 03:25:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727875AbgBTCZx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 21:25:53 -0500
Received: from mail-am6eur05on2089.outbound.protection.outlook.com ([40.107.22.89]:32566
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727211AbgBTCZx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Feb 2020 21:25:53 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DiJOCxVsM72fxBq0QRyWviofz8+91EgSshzKQ6RclMnObqQX9zBNQtoczH8JLbOW6tKnl74DJw9Ny5/S1QJAZbwO6Qvq6qIGkIgQ2uSwWlCMMwShgLomTkkU4fxAuBuE17hWVqc0leB6clNyzqudliHiOtj94i99SDPIIxkrUmf07rge5r7mT+C+NXGJJGTZ/7B/m5/K6q2UYyxq+zPpAAg4Jk1nn7oeeUukdiinF9T/+Sz3UC5eCzKvHcaxhfEcnFG6/Poq0QBwXzrpKhCsszTHGjDTPOWoArXMJy5QLlRFK99RLv2NnUjSJ4bFyDRRrUqk43xi4WaUTLDBgOMVsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p+SdWQ3uPSPuHTj/7sLyoI9IE1gpWN9UCqm7e3amN1E=;
 b=EPSHcX7rz1Y54oa58JrWVFP1SvMt9kWRwH6NTc+ZKHPEHa1yk1olWWXIxyG+MQPJXC1+SCOcBgfhftpAA9nTEtHy4HSChBJkPvycPek0aTk6/kPljqiOeJRGUbV8k1Jscf62zbUJWPXO32VLfjeuaHol6nRDT9CR/Yrg6Ufl7ccqx8+EzXUhu1OHixHthJhjT+RuTl0wVBQLJwA24LRldPN/FiqcjzGMmjeQ19w+wH9VFOckssKQklJEYsquRFAmOZBTqyh9APvWDi3BlcDKzK9RANT+Etr8Ea4OJJ5eJGt+aTFevhytpq3odsB0bIPCN8/qCv807tZ+VPGXZArnmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p+SdWQ3uPSPuHTj/7sLyoI9IE1gpWN9UCqm7e3amN1E=;
 b=nMSEQ6zSMXwu/4FqZuHiobT2G25KcLhQL9kax6cjSPPXGCvzP9geDxwIEUjM6ByW7l4s2Whfwg5cENmYH2cxqM+v8pQDMlsi+uWP9J8yhg+yP9bE8aYBXYS7HJGgn8cMQ2CeCVPnkN/gVmURj+Iz4rlZgiSooDjYPIZoG1e+8NU=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB4173.eurprd05.prod.outlook.com (52.134.122.29) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2729.31; Thu, 20 Feb 2020 02:25:46 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2729.028; Thu, 20 Feb 2020
 02:25:46 +0000
Received: from smtp.office365.com (73.15.39.150) by BY5PR20CA0022.namprd20.prod.outlook.com (2603:10b6:a03:1f4::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2750.18 via Frontend Transport; Thu, 20 Feb 2020 02:25:43 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH net-next 3/7] net/mlxfw: More error messages coverage
Thread-Topic: [PATCH net-next 3/7] net/mlxfw: More error messages coverage
Thread-Index: AQHV55UPAyL0CCxs1kShJEJe/3h6tg==
Date:   Thu, 20 Feb 2020 02:25:46 +0000
Message-ID: <20200220022502.38262-4-saeedm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: a9634994-7f17-4efe-32c1-08d7b5ac307b
x-ms-traffictypediagnostic: VI1PR05MB4173:|VI1PR05MB4173:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB417339C48C5687D44829D81CBE130@VI1PR05MB4173.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:451;
x-forefront-prvs: 031996B7EF
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(366004)(39860400002)(376002)(136003)(346002)(199004)(189003)(54906003)(5660300002)(2906002)(26005)(478600001)(71200400001)(6486002)(6512007)(16526019)(110136005)(52116002)(316002)(186003)(86362001)(6506007)(4326008)(956004)(2616005)(1076003)(107886003)(64756008)(15650500001)(81156014)(81166006)(66946007)(66556008)(8936002)(66476007)(8676002)(36756003)(66446008)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4173;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 82Z9FLwfye1CS0J6Mi/KlAoEi6XACEd7DZBXpyIPHrcXMNYMh2WLhF+yn2phcEFirMdaw20PlEoXNXhO3WWm0SaCz8hCZ76xtBT+YuPbGrKD0aeqOKm3EMTCMbpsUPawvbLyKQmlrYlaf+KKpT6Nje9UGlzPkiHuY/3mFTMR/iwa/K0F1Equ2COA5MgSFj/rTTsoAWjg0yhi7/6NGwBRAveH7ZDkoQ+pIzr0kmYvN4Nm+c35fT8KSVT3d3fyz6UVwbDTPaoxrSMcPhiEsGbq6hKKaVNz65ZE4+NoEI90acrPZKFJBuom44jvIeYvjk+XpbPt1Pa0ikjXBUBZyHuDa+IpzXjy7Nv5kcyuAZsZXt4MfIlxxNyVjGHfxSI1ljMwmwo1V1eamjF449v+2mDRxW/0ja0iOoDBnS99N8h3kayHn/kMdpDdsj+8sJmYbSxhhULvUAjLf/2i03AYNU/dgYnwQhqayP4QaOQLX79XP5u8gTaWVn8v5ekxeFA+fcHn84SwhVYO7DEg0Ye7+G7elfKs3xcx6mV8Cs6JJUFCdCs=
x-ms-exchange-antispam-messagedata: 21VCywzVuPwigUYoZsq09wsqJXyB9Evx2142hCWKaHmH6IaL7pDzHnaUsPvwFbz43+DuCKQ1lsQZ1VDplKJDYCq3bVELXbv1F+jJ0WtMc+q39EIvJeuP4dOFuPj217cE8Ug2tmkHijANvO2bLWvIjg==
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a9634994-7f17-4efe-32c1-08d7b5ac307b
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Feb 2020 02:25:46.8036
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oPvqNz62plGX4Hi2YdlmOjtOAUIYv7+/yc+IgcV9nCuyIZ1BJ1SnjsgB0vduT+q9WmXfNSjgLaNcwGxyXGuLtg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4173
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
index 3701f7f0d4d9..74fc6e06f17e 100644
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

