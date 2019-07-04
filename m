Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ADBCC5FDF0
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 22:51:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727503AbfGDUv3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 16:51:29 -0400
Received: from mail-eopbgr20072.outbound.protection.outlook.com ([40.107.2.72]:64342
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726903AbfGDUv2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Jul 2019 16:51:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PtqXWkEXdNxJu4V0nnubNudY6Cw2YJr/9mhec3rhRbQ=;
 b=eu9rToqDNRo6lZjLXM660obK8SEExl6aT0U0hYb6gSVQpDX4MbktDm/vRU6m8kboVz6H0XRQdmxOAlfctU2ok+jLxF1md/0JlL7NF3qbya2+ABEIl6A9+nmILVC2kW7L4oRshdqdKTOKY4TLIGJw9Ya4og4vS1XIRAX14JTkHVM=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2821.eurprd05.prod.outlook.com (10.172.227.10) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2032.20; Thu, 4 Jul 2019 20:51:23 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::c1b3:b3a8:bced:493c]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::c1b3:b3a8:bced:493c%4]) with mapi id 15.20.2032.019; Thu, 4 Jul 2019
 20:51:23 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@mellanox.com>,
        Shay Agroskin <shayag@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next V2 1/2] net/mlx5: Added fw version query command
Thread-Topic: [net-next V2 1/2] net/mlx5: Added fw version query command
Thread-Index: AQHVMqo99tzcnK8UYU6QxFsrdSs7+A==
Date:   Thu, 4 Jul 2019 20:51:23 +0000
Message-ID: <20190704205050.3354-2-saeedm@mellanox.com>
References: <20190704205050.3354-1-saeedm@mellanox.com>
In-Reply-To: <20190704205050.3354-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.148.53.10]
x-clientproxiedby: MN2PR07CA0025.namprd07.prod.outlook.com
 (2603:10b6:208:1a0::35) To DB6PR0501MB2759.eurprd05.prod.outlook.com
 (2603:10a6:4:84::7)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cf19b638-7b37-44d7-a302-08d700c15fc2
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2821;
x-ms-traffictypediagnostic: DB6PR0501MB2821:
x-microsoft-antispam-prvs: <DB6PR0501MB2821599BC859B934E6023429BEFA0@DB6PR0501MB2821.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 0088C92887
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(366004)(376002)(136003)(346002)(396003)(199004)(189003)(478600001)(76176011)(316002)(25786009)(6512007)(99286004)(64756008)(102836004)(6486002)(73956011)(68736007)(6506007)(386003)(6916009)(5660300002)(66556008)(52116002)(66446008)(50226002)(6436002)(54906003)(26005)(66946007)(3846002)(486006)(11346002)(2616005)(8676002)(446003)(86362001)(36756003)(2906002)(14454004)(81156014)(66066001)(8936002)(305945005)(71200400001)(14444005)(1076003)(186003)(476003)(107886003)(53936002)(66476007)(7736002)(71190400001)(4326008)(81166006)(256004)(6116002)(309714004);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2821;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: VOnaaBve7K4CUgewCjO02esoJwtwiCU69NL18g8p7k2LiB2qAwWVVHe00pczgZcePbEeajD75CEkP22BH2DJwWHTdLFDAzihOJzxGmYYPOA/KmX3qQP+hBbbrksGk9n3OUajw+YM0ty+dRaLG6LWh5gA3V1UNzMJcWi7/DTNF9tzniOKNOWb5EeqQUEwI1g7rz5mbVVEgYZGQFq0LkFZnA+nJCoAJpiN0cwRUJ86a1hfcLQdkvhwFT1tMHbasM1V5aFotHeq3Ij4FFzb5EHjV8SLXvZARcvmIEktXhWHV0D25FAcM92LxCMva5+mOirBWhGOf26xqao0GRyyGAU6X7CvRbc/Gy12e9ggrmYXICXg3UaqAAK09pVkHldIQ3MbIu2Mh3x8ywqmGuF0IxH7zEAU0gm1Nxo44NcH3Dd+Q+w=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cf19b638-7b37-44d7-a302-08d700c15fc2
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jul 2019 20:51:23.5016
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2821
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shay Agroskin <shayag@mellanox.com>

Using the MCQI and MCQS registers, we query the running and pending
fw version of the HCA.
The MCQS is queried with sequentially increasing component index, until
a component of type BOOT_IMG is found. Querying this component's version
using the MCQI register yields the running and pending fw version of the
HCA.

Querying MCQI for the pending fw version should be done only after
validating that such fw version exists. This is done my checking
'component update state' field in MCQS output.

Signed-off-by: Shay Agroskin <shayag@mellanox.com>
Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/fw.c  | 219 ++++++++++++++++--
 .../ethernet/mellanox/mlx5/core/mlx5_core.h   |   2 +
 2 files changed, 201 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fw.c b/drivers/net/eth=
ernet/mellanox/mlx5/core/fw.c
index 6452b62eff15..eb9680293b06 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fw.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fw.c
@@ -37,6 +37,37 @@
 #include "mlx5_core.h"
 #include "../../mlxfw/mlxfw.h"
=20
+enum {
+	MCQS_IDENTIFIER_BOOT_IMG	=3D 0x1,
+	MCQS_IDENTIFIER_OEM_NVCONFIG	=3D 0x4,
+	MCQS_IDENTIFIER_MLNX_NVCONFIG	=3D 0x5,
+	MCQS_IDENTIFIER_CS_TOKEN	=3D 0x6,
+	MCQS_IDENTIFIER_DBG_TOKEN	=3D 0x7,
+	MCQS_IDENTIFIER_GEARBOX		=3D 0xA,
+};
+
+enum {
+	MCQS_UPDATE_STATE_IDLE,
+	MCQS_UPDATE_STATE_IN_PROGRESS,
+	MCQS_UPDATE_STATE_APPLIED,
+	MCQS_UPDATE_STATE_ACTIVE,
+	MCQS_UPDATE_STATE_ACTIVE_PENDING_RESET,
+	MCQS_UPDATE_STATE_FAILED,
+	MCQS_UPDATE_STATE_CANCELED,
+	MCQS_UPDATE_STATE_BUSY,
+};
+
+enum {
+	MCQI_INFO_TYPE_CAPABILITIES	  =3D 0x0,
+	MCQI_INFO_TYPE_VERSION		  =3D 0x1,
+	MCQI_INFO_TYPE_ACTIVATION_METHOD  =3D 0x5,
+};
+
+enum {
+	MCQI_FW_RUNNING_VERSION =3D 0,
+	MCQI_FW_STORED_VERSION  =3D 1,
+};
+
 static int mlx5_cmd_query_adapter(struct mlx5_core_dev *dev, u32 *out,
 				  int outlen)
 {
@@ -398,33 +429,49 @@ static int mlx5_reg_mcda_set(struct mlx5_core_dev *de=
v,
 }
=20
 static int mlx5_reg_mcqi_query(struct mlx5_core_dev *dev,
-			       u16 component_index,
-			       u32 *max_component_size,
-			       u8 *log_mcda_word_size,
-			       u16 *mcda_max_write_size)
+			       u16 component_index, bool read_pending,
+			       u8 info_type, u16 data_size, void *mcqi_data)
 {
-	u32 out[MLX5_ST_SZ_DW(mcqi_reg) + MLX5_ST_SZ_DW(mcqi_cap)];
-	int offset =3D MLX5_ST_SZ_DW(mcqi_reg);
-	u32 in[MLX5_ST_SZ_DW(mcqi_reg)];
+	u32 out[MLX5_ST_SZ_DW(mcqi_reg) + MLX5_UN_SZ_DW(mcqi_reg_data)] =3D {};
+	u32 in[MLX5_ST_SZ_DW(mcqi_reg)] =3D {};
+	void *data;
 	int err;
=20
-	memset(in, 0, sizeof(in));
-	memset(out, 0, sizeof(out));
-
 	MLX5_SET(mcqi_reg, in, component_index, component_index);
-	MLX5_SET(mcqi_reg, in, data_size, MLX5_ST_SZ_BYTES(mcqi_cap));
+	MLX5_SET(mcqi_reg, in, read_pending_component, read_pending);
+	MLX5_SET(mcqi_reg, in, info_type, info_type);
+	MLX5_SET(mcqi_reg, in, data_size, data_size);
=20
 	err =3D mlx5_core_access_reg(dev, in, sizeof(in), out,
-				   sizeof(out), MLX5_REG_MCQI, 0, 0);
+				   MLX5_ST_SZ_BYTES(mcqi_reg) + data_size,
+				   MLX5_REG_MCQI, 0, 0);
 	if (err)
-		goto out;
+		return err;
=20
-	*max_component_size =3D MLX5_GET(mcqi_cap, out + offset, max_component_si=
ze);
-	*log_mcda_word_size =3D MLX5_GET(mcqi_cap, out + offset, log_mcda_word_si=
ze);
-	*mcda_max_write_size =3D MLX5_GET(mcqi_cap, out + offset, mcda_max_write_=
size);
+	data =3D MLX5_ADDR_OF(mcqi_reg, out, data);
+	memcpy(mcqi_data, data, data_size);
=20
-out:
-	return err;
+	return 0;
+}
+
+static int mlx5_reg_mcqi_caps_query(struct mlx5_core_dev *dev, u16 compone=
nt_index,
+				    u32 *max_component_size, u8 *log_mcda_word_size,
+				    u16 *mcda_max_write_size)
+{
+	u32 mcqi_reg[MLX5_ST_SZ_DW(mcqi_cap)] =3D {};
+	int err;
+
+	err =3D mlx5_reg_mcqi_query(dev, component_index, 0,
+				  MCQI_INFO_TYPE_CAPABILITIES,
+				  MLX5_ST_SZ_BYTES(mcqi_cap), mcqi_reg);
+	if (err)
+		return err;
+
+	*max_component_size =3D MLX5_GET(mcqi_cap, mcqi_reg, max_component_size);
+	*log_mcda_word_size =3D MLX5_GET(mcqi_cap, mcqi_reg, log_mcda_word_size);
+	*mcda_max_write_size =3D MLX5_GET(mcqi_cap, mcqi_reg, mcda_max_write_size=
);
+
+	return 0;
 }
=20
 struct mlx5_mlxfw_dev {
@@ -440,8 +487,13 @@ static int mlx5_component_query(struct mlxfw_dev *mlxf=
w_dev,
 		container_of(mlxfw_dev, struct mlx5_mlxfw_dev, mlxfw_dev);
 	struct mlx5_core_dev *dev =3D mlx5_mlxfw_dev->mlx5_core_dev;
=20
-	return mlx5_reg_mcqi_query(dev, component_index, p_max_size,
-				   p_align_bits, p_max_write_size);
+	if (!MLX5_CAP_GEN(dev, mcam_reg) || !MLX5_CAP_MCAM_REG(dev, mcqi)) {
+		mlx5_core_warn(dev, "caps query isn't supported by running FW\n");
+		return -EOPNOTSUPP;
+	}
+
+	return mlx5_reg_mcqi_caps_query(dev, component_index, p_max_size,
+					p_align_bits, p_max_write_size);
 }
=20
 static int mlx5_fsm_lock(struct mlxfw_dev *mlxfw_dev, u32 *fwhandle)
@@ -581,3 +633,130 @@ int mlx5_firmware_flash(struct mlx5_core_dev *dev,
 	return mlxfw_firmware_flash(&mlx5_mlxfw_dev.mlxfw_dev,
 				    firmware, extack);
 }
+
+static int mlx5_reg_mcqi_version_query(struct mlx5_core_dev *dev,
+				       u16 component_index, bool read_pending,
+				       u32 *mcqi_version_out)
+{
+	return mlx5_reg_mcqi_query(dev, component_index, read_pending,
+				   MCQI_INFO_TYPE_VERSION,
+				   MLX5_ST_SZ_BYTES(mcqi_version),
+				   mcqi_version_out);
+}
+
+static int mlx5_reg_mcqs_query(struct mlx5_core_dev *dev, u32 *out,
+			       u16 component_index)
+{
+	u8 out_sz =3D MLX5_ST_SZ_BYTES(mcqs_reg);
+	u32 in[MLX5_ST_SZ_DW(mcqs_reg)] =3D {};
+	int err;
+
+	memset(out, 0, out_sz);
+
+	MLX5_SET(mcqs_reg, in, component_index, component_index);
+
+	err =3D mlx5_core_access_reg(dev, in, sizeof(in), out,
+				   out_sz, MLX5_REG_MCQS, 0, 0);
+	return err;
+}
+
+/* scans component index sequentially, to find the boot img index */
+static int mlx5_get_boot_img_component_index(struct mlx5_core_dev *dev)
+{
+	u32 out[MLX5_ST_SZ_DW(mcqs_reg)] =3D {};
+	u16 identifier, component_idx =3D 0;
+	bool quit;
+	int err;
+
+	do {
+		err =3D mlx5_reg_mcqs_query(dev, out, component_idx);
+		if (err)
+			return err;
+
+		identifier =3D MLX5_GET(mcqs_reg, out, identifier);
+		quit =3D !!MLX5_GET(mcqs_reg, out, last_index_flag);
+		quit |=3D identifier =3D=3D MCQS_IDENTIFIER_BOOT_IMG;
+	} while (!quit && ++component_idx);
+
+	if (identifier !=3D MCQS_IDENTIFIER_BOOT_IMG) {
+		mlx5_core_warn(dev, "mcqs: can't find boot_img component ix, last scanne=
d idx %d\n",
+			       component_idx);
+		return -EOPNOTSUPP;
+	}
+
+	return component_idx;
+}
+
+static int
+mlx5_fw_image_pending(struct mlx5_core_dev *dev,
+		      int component_index,
+		      bool *pending_version_exists)
+{
+	u32 out[MLX5_ST_SZ_DW(mcqs_reg)];
+	u8 component_update_state;
+	int err;
+
+	err =3D mlx5_reg_mcqs_query(dev, out, component_index);
+	if (err)
+		return err;
+
+	component_update_state =3D MLX5_GET(mcqs_reg, out, component_update_state=
);
+
+	if (component_update_state =3D=3D MCQS_UPDATE_STATE_IDLE) {
+		*pending_version_exists =3D false;
+	} else if (component_update_state =3D=3D MCQS_UPDATE_STATE_ACTIVE_PENDING=
_RESET) {
+		*pending_version_exists =3D true;
+	} else {
+		mlx5_core_warn(dev,
+			       "mcqs: can't read pending fw version while fw state is %d\n",
+			       component_update_state);
+		return -ENODATA;
+	}
+	return 0;
+}
+
+int mlx5_fw_version_query(struct mlx5_core_dev *dev,
+			  u32 *running_ver, u32 *pending_ver)
+{
+	u32 reg_mcqi_version[MLX5_ST_SZ_DW(mcqi_version)] =3D {};
+	bool pending_version_exists;
+	int component_index;
+	int err;
+
+	if (!MLX5_CAP_GEN(dev, mcam_reg) || !MLX5_CAP_MCAM_REG(dev, mcqi) ||
+	    !MLX5_CAP_MCAM_REG(dev, mcqs)) {
+		mlx5_core_warn(dev, "fw query isn't supported by the FW\n");
+		return -EOPNOTSUPP;
+	}
+
+	component_index =3D mlx5_get_boot_img_component_index(dev);
+	if (component_index < 0)
+		return component_index;
+
+	err =3D mlx5_reg_mcqi_version_query(dev, component_index,
+					  MCQI_FW_RUNNING_VERSION,
+					  reg_mcqi_version);
+	if (err)
+		return err;
+
+	*running_ver =3D MLX5_GET(mcqi_version, reg_mcqi_version, version);
+
+	err =3D mlx5_fw_image_pending(dev, component_index, &pending_version_exis=
ts);
+	if (err)
+		return err;
+
+	if (!pending_version_exists) {
+		*pending_ver =3D 0;
+		return 0;
+	}
+
+	err =3D mlx5_reg_mcqi_version_query(dev, component_index,
+					  MCQI_FW_STORED_VERSION,
+					  reg_mcqi_version);
+	if (err)
+		return err;
+
+	*pending_ver =3D MLX5_GET(mcqi_version, reg_mcqi_version, version);
+
+	return 0;
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h b/drivers/=
net/ethernet/mellanox/mlx5/core/mlx5_core.h
index 958769702823..471bbc48bc1f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
@@ -205,6 +205,8 @@ int mlx5_set_mtppse(struct mlx5_core_dev *mdev, u8 pin,=
 u8 arm, u8 mode);
=20
 int mlx5_firmware_flash(struct mlx5_core_dev *dev, const struct firmware *=
fw,
 			struct netlink_ext_ack *extack);
+int mlx5_fw_version_query(struct mlx5_core_dev *dev,
+			  u32 *running_ver, u32 *stored_ver);
=20
 void mlx5e_init(void);
 void mlx5e_cleanup(void);
--=20
2.21.0

