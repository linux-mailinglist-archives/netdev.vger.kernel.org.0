Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3BAA6A4FB8
	for <lists+netdev@lfdr.de>; Mon,  2 Sep 2019 09:23:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729742AbfIBHXl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Sep 2019 03:23:41 -0400
Received: from mail-eopbgr10070.outbound.protection.outlook.com ([40.107.1.70]:26649
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726230AbfIBHXi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Sep 2019 03:23:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lNBSsnxvMVagCyL35WFyOkLr9PVVVXwMc9BXs+XNSksNoDriR3b2bFuqQzYm34Z+G2xurUGhtC48Zm/Yvj29hNeNwbJCuzCBz+BMxcE9MpTbHOqoo6VAphlIEya44+8KMW2gHisoYTKg3VI8IuFL8G1k03V+kEOxgv24+/cfbeKqbL5obkwwRyzInzfiXYoNepaTIIZMJ2U4IgPyGLjhWMMfiq/I6I6+EOt5vZPTulse6VknJMZBOavUVm2Eha+Q2mr7oHBClcwPryyGT6Iz8PZDKUvSnIdXxTItP3jdwFY9NTBL7Oh5zmtvo3yDoCkSUQRbiRzKKzhRgR0k5XNu4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dvPYCqdpT9sWMSD9JymKUZU9VejZ2T1tvo/pr7igYSE=;
 b=mL3x5grWCGq1tOMx58s59uYoMnXgMHKCPVOhrNI+MG43tt4tXaKr2QzDr/ZZUFN5u7J3O2VRuJYuk+gueyOoXLSn932CNJrkrTtix1+7+70hQofiw/TDwGZMG91gYviAQmkBgeSuBkusXvYXelvkFddaS0SW1ljj1pA7cBW2E0NBeFEoMBYMftBPx1/591Ra356OSEtCDLvce4gFuLZ2LvmnY/WtWaD5skEN4lqA7ovH3/6nBdLn1JeFmQ/A1iQAvYUoi1npYaRDHf3LzZvq70rawljiPpUsZamDIsMRBT/K3qM958hmndXFiZxyQPAx7Z5MQyat1ly0au/UhlR67w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dvPYCqdpT9sWMSD9JymKUZU9VejZ2T1tvo/pr7igYSE=;
 b=WixBCpgoa+QN+HT5UzZHGgKGbeQKZqh2fOWF2V0h6meFUuKlDfGC2I/R/yTeuFooFErRvqSinaGfwvoqNYIFMfYaEolyr7UY+plLIfHRFFH5pctcCRW7kh33S+z1b5NRhgdXepgSadxfilXXJKO80hqI7vVAtUwICDVFUmDnCvo=
Received: from AM4PR0501MB2756.eurprd05.prod.outlook.com (10.172.216.138) by
 AM4PR0501MB2659.eurprd05.prod.outlook.com (10.172.215.21) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2220.18; Mon, 2 Sep 2019 07:23:31 +0000
Received: from AM4PR0501MB2756.eurprd05.prod.outlook.com
 ([fe80::58d1:d1d6:dbda:3576]) by AM4PR0501MB2756.eurprd05.prod.outlook.com
 ([fe80::58d1:d1d6:dbda:3576%4]) with mapi id 15.20.2220.021; Mon, 2 Sep 2019
 07:23:31 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alex Vesker <valex@mellanox.com>,
        Erez Shitrit <erezsh@mellanox.com>,
        Maor Gottlieb <maorg@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 18/18] net/mlx5: Add devlink flow_steering_mode parameter
Thread-Topic: [net-next 18/18] net/mlx5: Add devlink flow_steering_mode
 parameter
Thread-Index: AQHVYV9SS/U1CzBP90iaOZEczN+g3g==
Date:   Mon, 2 Sep 2019 07:23:31 +0000
Message-ID: <20190902072213.7683-19-saeedm@mellanox.com>
References: <20190902072213.7683-1-saeedm@mellanox.com>
In-Reply-To: <20190902072213.7683-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [73.15.39.150]
x-clientproxiedby: BYAPR11CA0085.namprd11.prod.outlook.com
 (2603:10b6:a03:f4::26) To AM4PR0501MB2756.eurprd05.prod.outlook.com
 (2603:10a6:200:5c::10)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 11e14bc4-034a-4982-0140-08d72f767543
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM4PR0501MB2659;
x-ms-traffictypediagnostic: AM4PR0501MB2659:|AM4PR0501MB2659:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM4PR0501MB2659BA1F34DD606CDE9BAA17BEBE0@AM4PR0501MB2659.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 01480965DA
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(979002)(4636009)(396003)(366004)(346002)(39860400002)(136003)(376002)(199004)(189003)(26005)(6506007)(6486002)(2906002)(36756003)(386003)(2616005)(446003)(102836004)(52116002)(316002)(14444005)(86362001)(76176011)(6116002)(11346002)(3846002)(256004)(186003)(66066001)(476003)(7736002)(54906003)(107886003)(305945005)(25786009)(4326008)(99286004)(5660300002)(6436002)(53936002)(478600001)(6512007)(71190400001)(71200400001)(1076003)(8936002)(50226002)(486006)(14454004)(6916009)(66446008)(66476007)(66556008)(64756008)(81166006)(66946007)(81156014)(8676002)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR0501MB2659;H:AM4PR0501MB2756.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: LPBPuxlLdUUUDESaZazbP+8VxinLwOQ3TbNo3wbL371p952F535/t6blF5wyFhxJXzLqpTb1TUYgDYl5YF6y41BXoYPmZb1kmmRW4DPE2AbHYxnoNwshe9Ta2my4jTDhIlaaLHtKimY0l63boVmEZz2MgZq5LrZpaw66w578TMULMX1z1S65ARk5I8veO5M0CPGINwI4hP7pwZ4Ln3Cr8vcnepSLaX1KfPm2+dfrOVl2T4IzsPPtP9YUDJ0vdtoKhx3uHo1BQQ/Hdj+eQk4RccWeETAyK590zM/07FLRFtnBdP+vc9OMn/IgjAuiQ9Pao64k0zdlhCnWRctw9WdFF+ywXIZ6uNZs/zXJIqoJbMA9iw3qEXn01rZD3/WI/ppf7nFKS8bkXrg1Wb8mHRog/Ro1/jFBri8bMlWKwkeI8yU=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 11e14bc4-034a-4982-0140-08d72f767543
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Sep 2019 07:23:31.7775
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: R9/S/BpNSBPIzWbKdfzwKsjSb7Ft2z27x4I4wTBpxllgc9VI6rs/UZwkFVHuV+wRXJV0zzVZgYfR26M82FvqTQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR0501MB2659
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

