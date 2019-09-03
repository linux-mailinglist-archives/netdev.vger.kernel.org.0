Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8437AA743F
	for <lists+netdev@lfdr.de>; Tue,  3 Sep 2019 22:06:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727168AbfICUFt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Sep 2019 16:05:49 -0400
Received: from mail-eopbgr130049.outbound.protection.outlook.com ([40.107.13.49]:2855
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726956AbfICUFr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Sep 2019 16:05:47 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jhWoye6V56srQMdEQJTgXFXrI9CS1ys3QmRhVN/MZ0Hqpg6M9URmMbTi8O9jIHjjNts6rZsY5uNvprK0n0nbd0jKs2QnyIyTvGtDx47iM3RvSOjUndbPenysI8D0uBhU1/SU13h6jG6Uvq9OfxhL7ALYwifgm7mNkI6Yg4Vt0HL9Iz4yE5zK7syDS+KYaTy4RwPzVEv6gkTsDiJy2iBbDq4AxhuJ3fEks1A4Mw1OuZkyG+dB+RdNOW1SIxpszmsD6hhSR1reGEAAGNzExf4ht55+qFIhXmZzYIGiNVBnXcfv/nPl4d3MVK7BSjaPhs6yBGJQO8xDB+Hrj6li6xNKeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dvPYCqdpT9sWMSD9JymKUZU9VejZ2T1tvo/pr7igYSE=;
 b=R2OHXhurMm9ZgrLtQCxhHVh8DGZGrRzi1H9r9Hg1PSVk/soVn0GTZ78nu4mPua3/dRT1Dc8NtYepCJ2UkiPA2BLoa8S2tef/kGX5x46yTdZFd/PfIaWxzT6P1qDhV3vhjWOEI+rBFTZ+VSxeGUpW8FBt8vfIHFnoWBgPoDKmyj+Sz7DVKN3B43Ko02Ur/4lIm9O7zu8iZkE6FjyZFvT2CRn815iKLZYen5QVHyO4F3ASOPjP2zJjmogWadR7jzyVnBdaRsX6mtVz1odIFS/A8L4jt5UKsQ7scUzRVTH4eWpyAb5q3xDv5VwkwL6W3YzLpMRcGl1FtutXlHguJc6Rgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dvPYCqdpT9sWMSD9JymKUZU9VejZ2T1tvo/pr7igYSE=;
 b=BaepZK4zILsJrXWwvSFUTqeVyd0DschOw+eLj+c6TplDWBnoh76ncg44JP7k4+aevw1TlktKqJ+2IxZ2Z1Tw2KqocVcr2mIIVCbSsIz1CN5QRCeS/7cAl4o34oXtnWKLZFQ9EWUzERyTvUZC4hQjdLkmOgX+Mb0URU21wPVCyGo=
Received: from AM4PR0501MB2756.eurprd05.prod.outlook.com (10.172.216.138) by
 AM4PR0501MB2706.eurprd05.prod.outlook.com (10.172.221.142) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2220.21; Tue, 3 Sep 2019 20:05:06 +0000
Received: from AM4PR0501MB2756.eurprd05.prod.outlook.com
 ([fe80::58d1:d1d6:dbda:3576]) by AM4PR0501MB2756.eurprd05.prod.outlook.com
 ([fe80::58d1:d1d6:dbda:3576%4]) with mapi id 15.20.2220.021; Tue, 3 Sep 2019
 20:05:06 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alex Vesker <valex@mellanox.com>,
        Erez Shitrit <erezsh@mellanox.com>,
        Maor Gottlieb <maorg@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next V2 18/18] net/mlx5: Add devlink flow_steering_mode
 parameter
Thread-Topic: [net-next V2 18/18] net/mlx5: Add devlink flow_steering_mode
 parameter
Thread-Index: AQHVYpLhZ6DGMCAcTUK7fV8+vCK6vw==
Date:   Tue, 3 Sep 2019 20:05:06 +0000
Message-ID: <20190903200409.14406-19-saeedm@mellanox.com>
References: <20190903200409.14406-1-saeedm@mellanox.com>
In-Reply-To: <20190903200409.14406-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR02CA0049.namprd02.prod.outlook.com
 (2603:10b6:a03:54::26) To AM4PR0501MB2756.eurprd05.prod.outlook.com
 (2603:10a6:200:5c::10)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c2e07447-3154-44a1-c8a3-08d730aa03a6
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM4PR0501MB2706;
x-ms-traffictypediagnostic: AM4PR0501MB2706:|AM4PR0501MB2706:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM4PR0501MB270635184BA01D6FCE1DBA6EBEB90@AM4PR0501MB2706.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 01494FA7F7
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(1496009)(4636009)(376002)(346002)(136003)(39860400002)(396003)(366004)(199004)(189003)(2906002)(102836004)(256004)(26005)(11346002)(50226002)(186003)(66446008)(386003)(6506007)(64756008)(66556008)(14444005)(66476007)(71190400001)(66946007)(2616005)(476003)(76176011)(71200400001)(5660300002)(8936002)(66066001)(446003)(81166006)(81156014)(478600001)(54906003)(6916009)(8676002)(486006)(36756003)(3846002)(7736002)(53936002)(6436002)(305945005)(14454004)(6116002)(52116002)(6512007)(86362001)(316002)(99286004)(1076003)(6486002)(4326008)(107886003)(25786009);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR0501MB2706;H:AM4PR0501MB2756.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: DSGAIpApaJru+GLHcqmc1JwLecMolsdMBxKi1vcn4E1pv/LbrDwsk414899m6RnBDw5zuIT24cv5rqoJNbHnbv++hCK+/eTIgme2fUFxmvj/TZkhX/I/jvIRz0/DieFnVC+alWVYYfduS20YSy+BvM13b1DxvLNDMZsadxggkyeWc38QIRUz/fvTaUSj+59J4qMTCxQnCu+EKD3H0gm72ep+TrxC9By5TVh8Z5JSWvQ8F7P+kPx4RAAJDzbjELYunZnB3S10lA2kOATiAo/+zY6liLVDmEKOG/BNrYot1zC8slQT+CwhI8pZ74XB3Ph8FTo7cZtP0qI/WMgYiJWdLByCw1t789jN1dB0EvG6TE4lmI1VTyQJzA6io3RFh6LCH0w6ef2bHsKlCFjQ4cPpfCHcH+bpVlHaPJsIzdNxBpo=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c2e07447-3154-44a1-c8a3-08d730aa03a6
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Sep 2019 20:05:06.5087
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZuKO/PucxvgMNzZyDqd9WkZo5b9MDf5KxuzkCwCbA/WbcpktqxrQqACMGolEzZhqTTNPAr2vgm3VSYx0ihNIGQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR0501MB2706
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maor Gottlieb <maorg@mellanox.com>

Add new parameter (flow_steering_mode) to control the flow steering
mode of the driver.
Two modes are supported:
1. DMFS - Device managed flow steering
2. SMFS - Software/Driver managed flow steering.

In the DMFS mode, the HW steering entities are created through the
FW. In the SMFS mode this entities are created though the driver
directly.

The driver will use the devlink steering mode only if the steering
domain supports it, for now SMFS will manages only the switchdev eswitch
steering domain.

User command examples:
- Set SMFS flow steering mode::

    $ devlink dev param set pci/0000:06:00.0 name flow_steering_mode value =
"smfs" cmode runtime

- Read device flow steering mode::

    $ devlink dev param show pci/0000:06:00.0 name flow_steering_mode
      pci/0000:06:00.0:
      name flow_steering_mode type driver-specific
      values:
         cmode runtime value smfs

Signed-off-by: Maor Gottlieb <maorg@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../device_drivers/mellanox/mlx5.rst          |  33 ++++++
 .../net/ethernet/mellanox/mlx5/core/devlink.c | 112 +++++++++++++++++-
 2 files changed, 144 insertions(+), 1 deletion(-)

diff --git a/Documentation/networking/device_drivers/mellanox/mlx5.rst b/Do=
cumentation/networking/device_drivers/mellanox/mlx5.rst
index b30a63dbf4b7..d071c6b49e1f 100644
--- a/Documentation/networking/device_drivers/mellanox/mlx5.rst
+++ b/Documentation/networking/device_drivers/mellanox/mlx5.rst
@@ -11,6 +11,7 @@ Contents
=20
 - `Enabling the driver and kconfig options`_
 - `Devlink info`_
+- `Devlink parameters`_
 - `Devlink health reporters`_
 - `mlx5 tracepoints`_
=20
@@ -122,6 +123,38 @@ User command example::
          stored:
             fw.version 16.26.0100
=20
+Devlink parameters
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+
+flow_steering_mode: Device flow steering mode
+---------------------------------------------
+The flow steering mode parameter controls the flow steering mode of the dr=
iver.
+Two modes are supported:
+1. 'dmfs' - Device managed flow steering.
+2. 'smfs  - Software/Driver managed flow steering.
+
+In DMFS mode, the HW steering entities are created and managed through the
+Firmware.
+In SMFS mode, the HW steering entities are created and managed though by
+the driver directly into Hardware without firmware intervention.
+
+SMFS mode is faster and provides better rule inserstion rate compared to d=
efault DMFS mode.
+
+User command examples:
+
+- Set SMFS flow steering mode::
+
+    $ devlink dev param set pci/0000:06:00.0 name flow_steering_mode value=
 "smfs" cmode runtime
+
+- Read device flow steering mode::
+
+    $ devlink dev param show pci/0000:06:00.0 name flow_steering_mode
+      pci/0000:06:00.0:
+      name flow_steering_mode type driver-specific
+      values:
+         cmode runtime value smfs
+
+
 Devlink health reporters
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
=20
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c b/drivers/ne=
t/ethernet/mellanox/mlx5/core/devlink.c
index a400f4430c28..7bf7b6fbc776 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
@@ -4,6 +4,7 @@
 #include <devlink.h>
=20
 #include "mlx5_core.h"
+#include "fs_core.h"
 #include "eswitch.h"
=20
 static int mlx5_devlink_flash_update(struct devlink *devlink,
@@ -107,12 +108,121 @@ void mlx5_devlink_free(struct devlink *devlink)
 	devlink_free(devlink);
 }
=20
+static int mlx5_devlink_fs_mode_validate(struct devlink *devlink, u32 id,
+					 union devlink_param_value val,
+					 struct netlink_ext_ack *extack)
+{
+	struct mlx5_core_dev *dev =3D devlink_priv(devlink);
+	char *value =3D val.vstr;
+	int err =3D 0;
+
+	if (!strcmp(value, "dmfs")) {
+		return 0;
+	} else if (!strcmp(value, "smfs")) {
+		u8 eswitch_mode;
+		bool smfs_cap;
+
+		eswitch_mode =3D mlx5_eswitch_mode(dev->priv.eswitch);
+		smfs_cap =3D mlx5_fs_dr_is_supported(dev);
+
+		if (!smfs_cap) {
+			err =3D -EOPNOTSUPP;
+			NL_SET_ERR_MSG_MOD(extack,
+					   "Software managed steering is not supported by current device");
+		}
+
+		else if (eswitch_mode =3D=3D MLX5_ESWITCH_OFFLOADS) {
+			NL_SET_ERR_MSG_MOD(extack,
+					   "Software managed steering is not supported when eswitch offlaods =
enabled.");
+			err =3D -EOPNOTSUPP;
+		}
+	} else {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Bad parameter: supported values are [\"dmfs\", \"smfs\"]");
+		err =3D -EINVAL;
+	}
+
+	return err;
+}
+
+static int mlx5_devlink_fs_mode_set(struct devlink *devlink, u32 id,
+				    struct devlink_param_gset_ctx *ctx)
+{
+	struct mlx5_core_dev *dev =3D devlink_priv(devlink);
+	enum mlx5_flow_steering_mode mode;
+
+	if (!strcmp(ctx->val.vstr, "smfs"))
+		mode =3D MLX5_FLOW_STEERING_MODE_SMFS;
+	else
+		mode =3D MLX5_FLOW_STEERING_MODE_DMFS;
+	dev->priv.steering->mode =3D mode;
+
+	return 0;
+}
+
+static int mlx5_devlink_fs_mode_get(struct devlink *devlink, u32 id,
+				    struct devlink_param_gset_ctx *ctx)
+{
+	struct mlx5_core_dev *dev =3D devlink_priv(devlink);
+
+	if (dev->priv.steering->mode =3D=3D MLX5_FLOW_STEERING_MODE_SMFS)
+		strcpy(ctx->val.vstr, "smfs");
+	else
+		strcpy(ctx->val.vstr, "dmfs");
+	return 0;
+}
+
+enum mlx5_devlink_param_id {
+	MLX5_DEVLINK_PARAM_ID_BASE =3D DEVLINK_PARAM_GENERIC_ID_MAX,
+	MLX5_DEVLINK_PARAM_FLOW_STEERING_MODE,
+};
+
+static const struct devlink_param mlx5_devlink_params[] =3D {
+	DEVLINK_PARAM_DRIVER(MLX5_DEVLINK_PARAM_FLOW_STEERING_MODE,
+			     "flow_steering_mode", DEVLINK_PARAM_TYPE_STRING,
+			     BIT(DEVLINK_PARAM_CMODE_RUNTIME),
+			     mlx5_devlink_fs_mode_get, mlx5_devlink_fs_mode_set,
+			     mlx5_devlink_fs_mode_validate),
+};
+
+static void mlx5_devlink_set_params_init_values(struct devlink *devlink)
+{
+	struct mlx5_core_dev *dev =3D devlink_priv(devlink);
+	union devlink_param_value value;
+
+	if (dev->priv.steering->mode =3D=3D MLX5_FLOW_STEERING_MODE_DMFS)
+		strcpy(value.vstr, "dmfs");
+	else
+		strcpy(value.vstr, "smfs");
+	devlink_param_driverinit_value_set(devlink,
+					   MLX5_DEVLINK_PARAM_FLOW_STEERING_MODE,
+					   value);
+}
+
 int mlx5_devlink_register(struct devlink *devlink, struct device *dev)
 {
-	return devlink_register(devlink, dev);
+	int err;
+
+	err =3D devlink_register(devlink, dev);
+	if (err)
+		return err;
+
+	err =3D devlink_params_register(devlink, mlx5_devlink_params,
+				      ARRAY_SIZE(mlx5_devlink_params));
+	if (err)
+		goto params_reg_err;
+	mlx5_devlink_set_params_init_values(devlink);
+	devlink_params_publish(devlink);
+	return 0;
+
+params_reg_err:
+	devlink_unregister(devlink);
+	return err;
 }
=20
 void mlx5_devlink_unregister(struct devlink *devlink)
 {
+	devlink_params_unregister(devlink, mlx5_devlink_params,
+				  ARRAY_SIZE(mlx5_devlink_params));
 	devlink_unregister(devlink);
 }
--=20
2.21.0

