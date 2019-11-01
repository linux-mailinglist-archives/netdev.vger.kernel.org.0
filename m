Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 370AAECAAB
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 23:00:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727752AbfKAV7k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 17:59:40 -0400
Received: from mail-eopbgr140048.outbound.protection.outlook.com ([40.107.14.48]:32389
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727387AbfKAV7i (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 Nov 2019 17:59:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U4h9QB7L5IMPHWUktk9Q+SlNfA3GC7QH57I+HoE6vjd1mvNhRMV+TlU80b/1zqfWzPjsoZjGp9MD6QDuHhSfoSaZwhnK70qjBWmiKIOoXL1/l15sHDbkNiQ5vm8Ge9pJrmA5mz8J+u07UEsGhIbsqLY58KlmLthuDlbqFm5TClx1elQMd9OT6+VcNM5qxeeIq0eshXuenrUwj6dFo7mvj+DvS+FZ2Ir4sJVk1u8/0q+Ofb1tv0QwI6xCXZjvgYsVWjlHEXB+mqzvCAJTWWY3tNg+FvUSHSjUtqyLj0zoPry3sdy6ZlP3SBb9EVUw67sUE+qRD3qWgPAfJrj6sJu1Vw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=St3dVWlM0snSLmODrlu10WRlDk6zIBAJ+gKTpinPKL4=;
 b=TFrfG1YB2Slp74bV31o+Fk1170gikfjXpQPWjCN+ThUGYaG9s8tt8mAxiyynACoAgG89JjSWqZIhAhgWeOwRgUOmFCdgEzx06KDYMPVBRH7iiAzF49nimcpKFoJ2jq5qmfkxMRhyTZ+1FnKaMQYf218Q5QZp4x7dydjxFxQJjtq5czXHxmuPjtAlrH+chAYHflOlH7oNBdndGs5aYBd+3F73oxHGd1UYp0QVVDp6JLRFhu5rQ+tZyJ4IzO6TL6RJGbtBtTkaXKB/qh2nc6PCLuiLVY9rQbsvJfgMRE/9ntemsddR+AIaPO1vWZm1GuVy0DBkxdKz7hvhc1/hY+SSRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=St3dVWlM0snSLmODrlu10WRlDk6zIBAJ+gKTpinPKL4=;
 b=hMG0Bf4EcZgpbsS2E7i3XimEJmCMhu3JaKc9nsC1R01erxr4gQPSpqPXQhFM5gnribn5RRAnQqo7o1/zbwYAK1FPIdYzGTCh/fW1ndE9MMTh6jqKOQOzwHhLQRArWxUrQhN+TwsQddg94s7ocnH6NHbdgGBffPi5L0xxTtV8Muw=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB3293.eurprd05.prod.outlook.com (10.175.244.18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2387.25; Fri, 1 Nov 2019 21:58:59 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e%5]) with mapi id 15.20.2408.024; Fri, 1 Nov 2019
 21:58:59 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Igor Leshchenko <igorle@mellanox.com>,
        Meir Lichtinger <meirl@mellanox.com>,
        Boris Pismenny <borisp@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 02/15] net/mlx5: FPGA, support network cards with
 standalone FPGA
Thread-Topic: [net-next 02/15] net/mlx5: FPGA, support network cards with
 standalone FPGA
Thread-Index: AQHVkP+Qr3Q9fhr2yE+RO6b3Cx0Rkw==
Date:   Fri, 1 Nov 2019 21:58:59 +0000
Message-ID: <20191101215833.23975-3-saeedm@mellanox.com>
References: <20191101215833.23975-1-saeedm@mellanox.com>
In-Reply-To: <20191101215833.23975-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR05CA0076.namprd05.prod.outlook.com
 (2603:10b6:a03:e0::17) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 9c90bf6c-3435-49d2-49c1-08d75f16b2c6
x-ms-traffictypediagnostic: VI1PR05MB3293:|VI1PR05MB3293:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB3293B0540C8FDDCF231D1DD4BE620@VI1PR05MB3293.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:109;
x-forefront-prvs: 020877E0CB
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(39860400002)(136003)(376002)(346002)(396003)(199004)(189003)(4326008)(66066001)(6116002)(3846002)(71190400001)(256004)(99286004)(107886003)(54906003)(14454004)(76176011)(6512007)(478600001)(14444005)(316002)(71200400001)(6506007)(1076003)(52116002)(36756003)(386003)(2906002)(66946007)(66556008)(6436002)(50226002)(7736002)(6486002)(66476007)(6916009)(305945005)(186003)(64756008)(81156014)(81166006)(486006)(8676002)(25786009)(476003)(11346002)(446003)(2616005)(5660300002)(26005)(86362001)(102836004)(66446008)(8936002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB3293;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8+e3kpQlVCnqbUJ33LgTT+yS1iNMN1DZuKMUB+L+K3kbF5ov/yTXz1Lvhv9dvKLUN5gn49jkdjzC20Jsj0P0mMngDohA0Ru8Aqn6QZzLt9pp8HsOPhGTYD2V1co9COvNDAqUFPKo1s6yY7A9IYdUFM/+RQjF19649HaaMCPDxmVDiW0DSqzpbLxaC+aDvW4oK52nthshzkn6Jau8wBPNk+hSJalVtHCLr+gRUnlaoHqxpwzy5uKdTRRnj0wnbWRFD0+Lg+mrjVNQ99t+rB0g3EiCP86Fh9KirpD+gzgjyyj4rX9gqC20nZfk+7GJvAcq+RJI0CfwdSdMmk2EOEMTUkuwCmGCHNQvcSNjrAh5WFqbk180cR5uvqHM9ZlLFeT6aioPiaucAxWDLVdY5AtyOHkAYW7qv9N7y7YvOcM4pNOjRBS6On3+oqXB1ZluPE0J
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c90bf6c-3435-49d2-49c1-08d75f16b2c6
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Nov 2019 21:58:59.1112
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WVgLRQM/hr1d/OHnr1XG6TjuzK1FLxhzk+tjuj4nbG9PeCKBi8nUKJd9I0gKEqRcFUZz8JZhYiZnnpLkisLhIg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB3293
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Igor Leshenko <igorle@mellanox.com>

Not all mlx5 cards with FPGA device use it for network processing.

mlx5_core driver configures network connection to FPGA device
for all mlx5 cards with installed FPGA. If FPGA is not a part of
network path, driver crashes in this case

Check FPGA name in function mlx5_fpga_device_start() and continue
integrate FPGA into packets flow only for dedicated cards.
Currently there are Newton and Edison cards.

Signed-off-by: Igor Leshenko <igorle@mellanox.com>
Reviewed-by: Meir Lichtinger <meirl@mellanox.com>
Reviewed-by: Boris Pismenny <borisp@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../ethernet/mellanox/mlx5/core/fpga/cmd.h    | 10 +--
 .../ethernet/mellanox/mlx5/core/fpga/core.c   | 61 +++++++++++++------
 2 files changed, 46 insertions(+), 25 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fpga/cmd.h b/drivers/n=
et/ethernet/mellanox/mlx5/core/fpga/cmd.h
index eb8b0fe0b4e1..11621d265d7e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fpga/cmd.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fpga/cmd.h
@@ -35,11 +35,11 @@
=20
 #include <linux/mlx5/driver.h>
=20
-enum mlx5_fpga_device_id {
-	MLX5_FPGA_DEVICE_UNKNOWN =3D 0,
-	MLX5_FPGA_DEVICE_KU040 =3D 1,
-	MLX5_FPGA_DEVICE_KU060 =3D 2,
-	MLX5_FPGA_DEVICE_KU060_2 =3D 3,
+enum mlx5_fpga_id {
+	MLX5_FPGA_NEWTON =3D 0,
+	MLX5_FPGA_EDISON =3D 1,
+	MLX5_FPGA_MORSE =3D 2,
+	MLX5_FPGA_MORSEQ =3D 3,
 };
=20
 enum mlx5_fpga_image {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fpga/core.c b/drivers/=
net/ethernet/mellanox/mlx5/core/fpga/core.c
index d046d1ec2a86..2ce4241459ce 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fpga/core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fpga/core.c
@@ -81,19 +81,28 @@ static const char *mlx5_fpga_image_name(enum mlx5_fpga_=
image image)
 	}
 }
=20
-static const char *mlx5_fpga_device_name(u32 device)
+static const char *mlx5_fpga_name(u32 fpga_id)
 {
-	switch (device) {
-	case MLX5_FPGA_DEVICE_KU040:
-		return "ku040";
-	case MLX5_FPGA_DEVICE_KU060:
-		return "ku060";
-	case MLX5_FPGA_DEVICE_KU060_2:
-		return "ku060_2";
-	case MLX5_FPGA_DEVICE_UNKNOWN:
-	default:
-		return "unknown";
+	static char ret[32];
+
+	switch (fpga_id) {
+	case MLX5_FPGA_NEWTON:
+		return "Newton";
+	case MLX5_FPGA_EDISON:
+		return "Edison";
+	case MLX5_FPGA_MORSE:
+		return "Morse";
+	case MLX5_FPGA_MORSEQ:
+		return "MorseQ";
 	}
+
+	snprintf(ret, sizeof(ret), "Unknown %d", fpga_id);
+	return ret;
+}
+
+static int mlx5_is_fpga_lookaside(u32 fpga_id)
+{
+	return fpga_id !=3D MLX5_FPGA_NEWTON && fpga_id !=3D MLX5_FPGA_EDISON;
 }
=20
 static int mlx5_fpga_device_load_check(struct mlx5_fpga_device *fdev)
@@ -110,8 +119,12 @@ static int mlx5_fpga_device_load_check(struct mlx5_fpg=
a_device *fdev)
 	fdev->last_admin_image =3D query.admin_image;
 	fdev->last_oper_image =3D query.oper_image;
=20
-	mlx5_fpga_dbg(fdev, "Status %u; Admin image %u; Oper image %u\n",
-		      query.status, query.admin_image, query.oper_image);
+	mlx5_fpga_info(fdev, "Status %u; Admin image %u; Oper image %u\n",
+		       query.status, query.admin_image, query.oper_image);
+
+	/* for FPGA lookaside projects FPGA load status is not important */
+	if (mlx5_is_fpga_lookaside(MLX5_CAP_FPGA(fdev->mdev, fpga_id)))
+		return 0;
=20
 	if (query.status !=3D MLX5_FPGA_STATUS_SUCCESS) {
 		mlx5_fpga_err(fdev, "%s image failed to load; status %u\n",
@@ -167,25 +180,30 @@ int mlx5_fpga_device_start(struct mlx5_core_dev *mdev=
)
 	struct mlx5_fpga_device *fdev =3D mdev->fpga;
 	unsigned int max_num_qps;
 	unsigned long flags;
-	u32 fpga_device_id;
+	u32 fpga_id;
 	int err;
=20
 	if (!fdev)
 		return 0;
=20
-	err =3D mlx5_fpga_device_load_check(fdev);
+	err =3D mlx5_fpga_caps(fdev->mdev);
 	if (err)
 		goto out;
=20
-	err =3D mlx5_fpga_caps(fdev->mdev);
+	err =3D mlx5_fpga_device_load_check(fdev);
 	if (err)
 		goto out;
=20
-	fpga_device_id =3D MLX5_CAP_FPGA(fdev->mdev, fpga_device);
-	mlx5_fpga_info(fdev, "%s:%u; %s image, version %u; SBU %06x:%04x version =
%d\n",
-		       mlx5_fpga_device_name(fpga_device_id),
-		       fpga_device_id,
+	fpga_id =3D MLX5_CAP_FPGA(fdev->mdev, fpga_id);
+	mlx5_fpga_info(fdev, "FPGA card %s:%u\n", mlx5_fpga_name(fpga_id), fpga_i=
d);
+
+	/* No QPs if FPGA does not participate in net processing */
+	if (mlx5_is_fpga_lookaside(fpga_id))
+		goto out;
+
+	mlx5_fpga_info(fdev, "%s(%d): image, version %u; SBU %06x:%04x version %d=
\n",
 		       mlx5_fpga_image_name(fdev->last_oper_image),
+		       fdev->last_oper_image,
 		       MLX5_CAP_FPGA(fdev->mdev, image_version),
 		       MLX5_CAP_FPGA(fdev->mdev, ieee_vendor_id),
 		       MLX5_CAP_FPGA(fdev->mdev, sandbox_product_id),
@@ -264,6 +282,9 @@ void mlx5_fpga_device_stop(struct mlx5_core_dev *mdev)
 	if (!fdev)
 		return;
=20
+	if (mlx5_is_fpga_lookaside(MLX5_CAP_FPGA(fdev->mdev, fpga_id)))
+		return;
+
 	spin_lock_irqsave(&fdev->state_lock, flags);
 	if (fdev->state !=3D MLX5_FPGA_STATUS_SUCCESS) {
 		spin_unlock_irqrestore(&fdev->state_lock, flags);
--=20
2.21.0

