Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6ABF5FDF1
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 22:51:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727510AbfGDUvb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 16:51:31 -0400
Received: from mail-eopbgr20072.outbound.protection.outlook.com ([40.107.2.72]:64342
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727491AbfGDUvb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Jul 2019 16:51:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ASygHLhPnSzrah/XRCd/VgrK5di3PB26pzf+6s3QYfM=;
 b=nROx1C+XLADxcD3yCChjgaA0cr1ztliItc1Ok51BXZYR8SqZEeLBHz1jNAbTO8qywebkZPm+QTWVUzRf39uwvkCkNp3xNP8cmzT7AxNQteQU9LWMFjhZhSWjpo4RZwq0WR+1B6Bm2hYOEGN7mChkeMZ2O+6BxO460b3t9C8foNg=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2821.eurprd05.prod.outlook.com (10.172.227.10) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2032.20; Thu, 4 Jul 2019 20:51:25 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::c1b3:b3a8:bced:493c]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::c1b3:b3a8:bced:493c%4]) with mapi id 15.20.2032.019; Thu, 4 Jul 2019
 20:51:25 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@mellanox.com>,
        Shay Agroskin <shayag@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next V2 2/2] net/mlx5: Added devlink info callback
Thread-Topic: [net-next V2 2/2] net/mlx5: Added devlink info callback
Thread-Index: AQHVMqo+KM7QrY/noEyDJXblRo5g7w==
Date:   Thu, 4 Jul 2019 20:51:25 +0000
Message-ID: <20190704205050.3354-3-saeedm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: 61924a30-caae-42c9-3d1b-08d700c160a9
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2821;
x-ms-traffictypediagnostic: DB6PR0501MB2821:
x-microsoft-antispam-prvs: <DB6PR0501MB2821FEB71B922F5D29D939BDBEFA0@DB6PR0501MB2821.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0088C92887
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(366004)(376002)(136003)(346002)(396003)(199004)(189003)(478600001)(76176011)(316002)(25786009)(6512007)(99286004)(64756008)(102836004)(6486002)(73956011)(68736007)(6506007)(386003)(6916009)(5660300002)(66556008)(52116002)(66446008)(50226002)(6436002)(54906003)(26005)(66946007)(3846002)(486006)(11346002)(2616005)(8676002)(446003)(86362001)(36756003)(2906002)(14454004)(81156014)(66066001)(8936002)(305945005)(71200400001)(14444005)(1076003)(186003)(476003)(107886003)(53936002)(66476007)(7736002)(71190400001)(4326008)(81166006)(256004)(6116002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2821;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: +zHqRfRFXrJa9a5k6KOerGd3A89ycEjv6tsHwfl2j62FtjC+mmCRAedosuSj/suEzUeCuOudRTF/5ox1lJTGAh5E+6QXnIuQ+00Jl8EiDmbqVLcNjATVkIrJl/q+sl1ZIKi/d77Qw+FW8/4QV/0rlppRg82UF6FzcdgEDOCR+i17pvuB2c8+gyTQLZIhATdhfmbMLtI6pB0Xisnw/P+dr6jyU+ZZmShFsNjcooU3q7q+CghfAGA+7fiZdR9s4AByNVFWY13HunHFA2AOEtKW+9P270ulgHE+SFU8QYsyecp6ZgvOWDkyQCYcxqWRThL1+Ycjy2xKCr86qu0JvBHqf483OikBpPCsVNbYZCuEgvRwf9SOiX3APstMY/2lDhCh+ns4D2XcWxyCwdthZmOAw2MjDS1OP7vH+SLo4nQY5D4=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 61924a30-caae-42c9-3d1b-08d700c160a9
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jul 2019 20:51:25.2321
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

The callback is invoked using 'devlink dev info <pci>' command and returns
the running and pending firmware version of the HCA and the name of the
kernel driver.

If there is a pending firmware version (a new version is burned but the
HCA still runs with the previous) it is returned as the stored
firmware version. Otherwise, the running version is returned for this
field.

Output example:
$ devlink dev info pci/0000:00:06.0
pci/0000:00:06.0:
  driver mlx5_core
  versions:
      fixed:
        fw.psid MT_0000000009
      running:
        fw.version 16.26.0100
      stored:
        fw.version 16.26.0100

Signed-off-by: Shay Agroskin <shayag@mellanox.com>
Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../device_drivers/mellanox/mlx5.rst          | 19 ++++++
 .../net/ethernet/mellanox/mlx5/core/devlink.c | 60 +++++++++++++++++++
 2 files changed, 79 insertions(+)

diff --git a/Documentation/networking/device_drivers/mellanox/mlx5.rst b/Do=
cumentation/networking/device_drivers/mellanox/mlx5.rst
index 4eeef2df912f..214325897732 100644
--- a/Documentation/networking/device_drivers/mellanox/mlx5.rst
+++ b/Documentation/networking/device_drivers/mellanox/mlx5.rst
@@ -10,6 +10,7 @@ Contents
 =3D=3D=3D=3D=3D=3D=3D=3D
=20
 - `Enabling the driver and kconfig options`_
+- `Devlink info`_
 - `Devlink health reporters`_
=20
 Enabling the driver and kconfig options
@@ -101,6 +102,24 @@ Enabling the driver and kconfig options
 - CONFIG_VXLAN: When chosen, mlx5 vxaln support will be enabled.
 - CONFIG_MLXFW: When chosen, mlx5 firmware flashing support will be enable=
d (via devlink and ethtool).
=20
+Devlink info
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+
+The devlink info reports the running and stored firmware versions on devic=
e.
+It also prints the device PSID which represents the HCA board type ID.
+
+User command example::
+
+   $ devlink dev info pci/0000:00:06.0
+      pci/0000:00:06.0:
+      driver mlx5_core
+      versions:
+         fixed:
+            fw.psid MT_0000000009
+         running:
+            fw.version 16.26.0100
+         stored:
+            fw.version 16.26.0100
=20
 Devlink health reporters
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c b/drivers/ne=
t/ethernet/mellanox/mlx5/core/devlink.c
index 1533c657220b..a400f4430c28 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
@@ -25,6 +25,65 @@ static int mlx5_devlink_flash_update(struct devlink *dev=
link,
 	return mlx5_firmware_flash(dev, fw, extack);
 }
=20
+static u8 mlx5_fw_ver_major(u32 version)
+{
+	return (version >> 24) & 0xff;
+}
+
+static u8 mlx5_fw_ver_minor(u32 version)
+{
+	return (version >> 16) & 0xff;
+}
+
+static u16 mlx5_fw_ver_subminor(u32 version)
+{
+	return version & 0xffff;
+}
+
+#define DEVLINK_FW_STRING_LEN 32
+
+static int
+mlx5_devlink_info_get(struct devlink *devlink, struct devlink_info_req *re=
q,
+		      struct netlink_ext_ack *extack)
+{
+	struct mlx5_core_dev *dev =3D devlink_priv(devlink);
+	char version_str[DEVLINK_FW_STRING_LEN];
+	u32 running_fw, stored_fw;
+	int err;
+
+	err =3D devlink_info_driver_name_put(req, DRIVER_NAME);
+	if (err)
+		return err;
+
+	err =3D devlink_info_version_fixed_put(req, "fw.psid", dev->board_id);
+	if (err)
+		return err;
+
+	err =3D mlx5_fw_version_query(dev, &running_fw, &stored_fw);
+	if (err)
+		return err;
+
+	snprintf(version_str, sizeof(version_str), "%d.%d.%04d",
+		 mlx5_fw_ver_major(running_fw), mlx5_fw_ver_minor(running_fw),
+		 mlx5_fw_ver_subminor(running_fw));
+	err =3D devlink_info_version_running_put(req, "fw.version", version_str);
+	if (err)
+		return err;
+
+	/* no pending version, return running (stored) version */
+	if (stored_fw =3D=3D 0)
+		stored_fw =3D running_fw;
+
+	snprintf(version_str, sizeof(version_str), "%d.%d.%04d",
+		 mlx5_fw_ver_major(stored_fw), mlx5_fw_ver_minor(stored_fw),
+		 mlx5_fw_ver_subminor(stored_fw));
+	err =3D devlink_info_version_stored_put(req, "fw.version", version_str);
+	if (err)
+		return err;
+
+	return 0;
+}
+
 static const struct devlink_ops mlx5_devlink_ops =3D {
 #ifdef CONFIG_MLX5_ESWITCH
 	.eswitch_mode_set =3D mlx5_devlink_eswitch_mode_set,
@@ -35,6 +94,7 @@ static const struct devlink_ops mlx5_devlink_ops =3D {
 	.eswitch_encap_mode_get =3D mlx5_devlink_eswitch_encap_mode_get,
 #endif
 	.flash_update =3D mlx5_devlink_flash_update,
+	.info_get =3D mlx5_devlink_info_get,
 };
=20
 struct devlink *mlx5_devlink_alloc(void)
--=20
2.21.0

