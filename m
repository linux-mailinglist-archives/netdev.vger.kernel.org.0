Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6A73107AC9
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 23:43:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727416AbfKVWmM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 17:42:12 -0500
Received: from mail-eopbgr150047.outbound.protection.outlook.com ([40.107.15.47]:57606
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726089AbfKVWmL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Nov 2019 17:42:11 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AZbxvuaPydFr4U/4RvP00HqruG9k0/h8Wpc4hMshf4+DylHNZeD0Mfcxq99D3BQ+PqCCwtTVOmWLTugS55i6pbq3fO87WNN588LfLIiIearQLM+csQT5woHyXVbyCsxwksYSR5hpxkbfeOLIqtDpKl5ZMDdMWHVFU2+Rq2Gc+Ac6gSZoRh5vF2TESE+w8u7r8cmDhR8MeAuQbWx2i+e8GPyI0U6CA4xDcCJ2By8BJRyt4fHxCDfk3YoTUgzy5oFlh3lHTTrCqaktXXtajIFSHh44xnLUuUg7op34CgwYKQwhbr0NVzvLWB0lH4XRrkyE7mqw281YiqLWM5oZeeDE5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zszS6NfgUXreTcZUg4wjR/AaziRsAoWEJ0nuULN5PiM=;
 b=C2hnvi6nKdyO5oan/GKxcbR6f5a122hRV81tBLjF/T5BQoWS5BDUdli/Gd4AduDNmT+zL4WGBlia1HxuMXt7uRtli6uLVlcq0wXnf1lToCZkzV6YQ9uk8Uv5V9vGKvaBTp48y78ONGmpe57BoRUMrFIAXU+1gCJjdov7jCt+wp6zXeYhaMgNmhD+/hd68nFq8f70nzLsmomqnPdtdwIGLDKHxTlFDV5+mYm958yVjtaaASVhGqPEE5CysobGcFsuyVI53WSHOxacuDJhLxcEUTWpCrr6itJhVheU3qjJ/E89fesjSgC1kOag4cZBC955RDZSN24SbHfYSSgyD79+Xg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zszS6NfgUXreTcZUg4wjR/AaziRsAoWEJ0nuULN5PiM=;
 b=FT8LXiAPjEN44IDqK3g2S0rZRPqHlRbW0TIt/XrQwaYmxoI6tiGMsc1+DypzYYWufXRV8HH2lvTDGRxL1d/nXWm41TVH5tNL93WfQWVWCw8cnuCi+jTkjFnK0ZY82kPQpznGjUu2DlUQPAzGuiyYxJSQsuJ9JeMtHZZObmLetEw=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB6718.eurprd05.prod.outlook.com (10.186.162.137) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2474.17; Fri, 22 Nov 2019 22:41:55 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e%5]) with mapi id 15.20.2474.019; Fri, 22 Nov 2019
 22:41:55 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH V2 net-next 6/6] net/mlxfw: Macro for error reporting
Thread-Topic: [PATCH V2 net-next 6/6] net/mlxfw: Macro for error reporting
Thread-Index: AQHVoYYKfoALax14pUmlJeMpUA2+Hg==
Date:   Fri, 22 Nov 2019 22:41:55 +0000
Message-ID: <20191122224126.24847-7-saeedm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: 028cc921-577c-4cad-1a79-08d76f9d2d3c
x-ms-traffictypediagnostic: VI1PR05MB6718:|VI1PR05MB6718:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB671810A56C370C12B05E37AFBE490@VI1PR05MB6718.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:446;
x-forefront-prvs: 02296943FF
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(346002)(39860400002)(366004)(136003)(376002)(189003)(199004)(14454004)(66946007)(64756008)(66556008)(1076003)(66066001)(66476007)(4326008)(6486002)(66446008)(14444005)(8936002)(6512007)(6916009)(7736002)(6506007)(26005)(256004)(305945005)(386003)(186003)(3846002)(102836004)(6116002)(11346002)(2616005)(446003)(107886003)(2906002)(478600001)(99286004)(8676002)(25786009)(52116002)(81156014)(36756003)(81166006)(76176011)(316002)(6436002)(54906003)(86362001)(50226002)(5660300002)(71190400001)(71200400001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB6718;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: iRu3yGjaK+9UguepLLSFujVYk9rPHxil30pePpfOKP3tr39YS5Iswlx6dAHEvFHsUX4QQzTBGg6o+QfBsuXrOeuJMllQJ5WTykHiGqTJrq26jzCgyrJiQoHJeyQ2KQ6P3mlaWsLMilgts1s1SA1BWMBZ+ytpw1Zaoswq1OasT7SBUF08EN5z2Rd6zabz5vdz6s4KlvTd2WohML4S9pSqNwucIyncwwsiH9LhdJZuz7rXywbRbPXquRX7lGYgKBZOrcFNAmi4Fc6XcjM5Wzoa0qn62KzK404N7drFGE0us3gKlvVUT8GBFRiCVdvVo4v0iPOQm1TCHHEfR4IkONbcmbOmqa+JkwkDLJOjPWSvDkUHEUss+1i9ADD4Zii+iLWyUg0ftpiBn5wSzWbq0FtSROq4mZ02nMuSO1+gBD9vrpZDb3FNah3UpPSg+ZBE1tJm
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 028cc921-577c-4cad-1a79-08d76f9d2d3c
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Nov 2019 22:41:55.7155
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 62uInSkfp8XgQAL6ABeVebMzB7emKL/Qx8ByqYH7bBqPmdMC2X2oO5HqH/nKum5JrXWu4BK5PSCWqk8B4LGpmg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6718
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
 .../net/ethernet/mellanox/mlxfw/mlxfw_fsm.c   | 78 ++++++++++---------
 1 file changed, 41 insertions(+), 37 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxfw/mlxfw_fsm.c b/drivers/net/=
ethernet/mellanox/mlxfw/mlxfw_fsm.c
index 2726f17a68fe..cc333368a367 100644
--- a/drivers/net/ethernet/mellanox/mlxfw/mlxfw_fsm.c
+++ b/drivers/net/ethernet/mellanox/mlxfw/mlxfw_fsm.c
@@ -52,6 +52,12 @@ static const int mlxfw_fsm_state_errno[] =3D {
 	[MLXFW_FSM_STATE_ERR_MAX] =3D -EINVAL
 };
=20
+#define MLXFW_ERR_MSG(mlxfw_dev, extack, fmt, ...)	\
+({							\
+	mlxfw_err(mlxfw_dev, fmt "\n", ## __VA_ARGS__);	\
+	NL_SET_ERR_MSG_MOD(extack, fmt, ## __VA_ARGS__);\
+})
+
 static int mlxfw_fsm_state_err(struct mlxfw_dev *mlxfw_dev,
 			       struct netlink_ext_ack *extack,
 			       enum mlxfw_fsm_state_err fsm_state_err)
@@ -61,10 +67,8 @@ static int mlxfw_fsm_state_err(struct mlxfw_dev *mlxfw_d=
ev,
 	fsm_state_err =3D min_t(enum mlxfw_fsm_state_err, fsm_state_err,
 			      MLXFW_FSM_STATE_ERR_MAX);
=20
-	mlxfw_err(mlxfw_dev, MLXFW_ERR_PRFX "%s\n",
-		  mlxfw_fsm_state_err_str[fsm_state_err]);
-	NL_SET_ERR_MSG_MOD(extack, MLXFW_ERR_PRFX "%s",
-			   mlxfw_fsm_state_err_str[fsm_state_err]);
+	MLXFW_ERR_MSG(mlxfw_dev, extack, MLXFW_ERR_PRFX "%s",
+		      mlxfw_fsm_state_err_str[fsm_state_err]);
 	return mlxfw_fsm_state_errno[fsm_state_err];
 };
=20
@@ -82,8 +86,8 @@ static int mlxfw_fsm_state_wait(struct mlxfw_dev *mlxfw_d=
ev, u32 fwhandle,
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
@@ -92,8 +96,8 @@ static int mlxfw_fsm_state_wait(struct mlxfw_dev *mlxfw_d=
ev, u32 fwhandle,
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
@@ -134,17 +138,17 @@ static int mlxfw_flash_component(struct mlxfw_dev *ml=
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
@@ -157,9 +161,9 @@ static int mlxfw_flash_component(struct mlxfw_dev *mlxf=
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
@@ -181,9 +185,9 @@ static int mlxfw_flash_component(struct mlxfw_dev *mlxf=
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
@@ -196,9 +200,9 @@ static int mlxfw_flash_component(struct mlxfw_dev *mlxf=
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
@@ -225,8 +229,9 @@ static int mlxfw_flash_components(struct mlxfw_dev *mlx=
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
@@ -237,9 +242,9 @@ static int mlxfw_flash_components(struct mlxfw_dev *mlx=
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
@@ -262,17 +267,16 @@ int mlxfw_firmware_flash(struct mlxfw_dev *mlxfw_dev,
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
@@ -282,8 +286,8 @@ int mlxfw_firmware_flash(struct mlxfw_dev *mlxfw_dev,
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
@@ -300,8 +304,8 @@ int mlxfw_firmware_flash(struct mlxfw_dev *mlxfw_dev,
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

