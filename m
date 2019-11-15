Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22AD9FD3E1
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 06:03:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727020AbfKOFDg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Nov 2019 00:03:36 -0500
Received: from mail-eopbgr80057.outbound.protection.outlook.com ([40.107.8.57]:27421
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726308AbfKOFDf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 Nov 2019 00:03:35 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZC1KaqnJosKIjBnoruyPTPalOJdMmJ5Ud8aNkpAFZDQHZAHwzFjzXUdg2gpiiHdJQk64uaBFDAtwJGPsq2kfM8YLCE5BZS0L6Z+BONgQUExWMM/8OIXyzw6whykwiYBkVdk/n4SS5ra/qCbVU53u7bw7wqCQvcKSLBLYZL3/fujW+evcSvGnzp9FSv9tFCM0+4PiLUpS+GLY17tx5tidcGiHlXfcnb/6/PSgI4KOXn3mp/z+xvMmDQymtqLOgaVycOFGXoTJ1uDT/ogW/7F4hJx5KLs1nOeN9kaavV8/oy0KuWkRYo4EiLs+tY9OML6GPmdFNgTXf94OkU2IOcE8Mg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BDX1aCtLY4UV6JFmFVWzkoNeYefhQNGCStdXnL9nFDA=;
 b=LyXhh8/Fp8gRRPNn8e+8T3xZzCbKCrn5cJo/ztTLmFNCCgl91dphoSlldBdKpu/0dDPLKljKFhxfZtLfXOWbYIcwN/v8JkRNbeYDrb3y2bD8eg9E+A39BNacTjDsnMs2nEo2FNQZ2/tcUT7KahY8eguaFEqiR8n5W0hgGlhJawe8nMqBkAbk5wu+EwBQ1vdIB3V1xDjOyi0mc+zkM4wmAT1q1h2mWIgC6ucMpqL3SxPaaNDJpH9ps7pootxIwpwUTIDoI9ye4ez24+MMxN0XtX6RVw5DWmW6nWVTF2jo4VZ2v0CpCG1UwmbUvA+m6vaED153jj0tFyUYHcPJnFHIZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BDX1aCtLY4UV6JFmFVWzkoNeYefhQNGCStdXnL9nFDA=;
 b=rHrSWlFtPmXyRHQBw+6OQLq1dXgDgZR7AjgTg1B3XK9VqTdiOXYvuJxxFIwebZqaHOhDNdDKPnxp+sLH2dRCo+7/HRqJ3+8mu6oBDoGSp3TH/5aPatpzW8CE/bhkIsh5RlUP94PAeSz/G/8cXBTesZz7qT1cO24Mg62fpQzRLCw=
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com (52.135.139.151) by
 DB7PR04MB4620.eurprd04.prod.outlook.com (52.135.140.28) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.28; Fri, 15 Nov 2019 05:03:31 +0000
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::1c96:c591:7d51:64e6]) by DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::1c96:c591:7d51:64e6%4]) with mapi id 15.20.2451.029; Fri, 15 Nov 2019
 05:03:31 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     "mkl@pengutronix.de" <mkl@pengutronix.de>,
        "sean@geanix.com" <sean@geanix.com>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>
CC:     dl-linux-imx <linux-imx@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Joakim Zhang <qiangqing.zhang@nxp.com>
Subject: [PATCH 3/3] can: flexcan: add LPSR mode support
Thread-Topic: [PATCH 3/3] can: flexcan: add LPSR mode support
Thread-Index: AQHVm3IG7HG4bRi6skCt+Z1pOjBKzg==
Date:   Fri, 15 Nov 2019 05:03:31 +0000
Message-ID: <20191115050032.25928-3-qiangqing.zhang@nxp.com>
References: <20191115050032.25928-1-qiangqing.zhang@nxp.com>
In-Reply-To: <20191115050032.25928-1-qiangqing.zhang@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.17.1
x-clientproxiedby: SG2PR06CA0143.apcprd06.prod.outlook.com
 (2603:1096:1:1f::21) To DB7PR04MB4618.eurprd04.prod.outlook.com
 (2603:10a6:5:38::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=qiangqing.zhang@nxp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 28c95dd3-24b2-4845-b407-08d7698928b8
x-ms-traffictypediagnostic: DB7PR04MB4620:|DB7PR04MB4620:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB7PR04MB462057AECA3E829730CC9843E6700@DB7PR04MB4620.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2276;
x-forefront-prvs: 02229A4115
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(979002)(4636009)(396003)(136003)(39860400002)(346002)(366004)(376002)(199004)(189003)(52116002)(316002)(76176011)(305945005)(110136005)(8936002)(66066001)(478600001)(64756008)(66556008)(71190400001)(66946007)(66476007)(50226002)(256004)(66446008)(8676002)(6506007)(36756003)(3846002)(6116002)(14454004)(102836004)(54906003)(26005)(14444005)(71200400001)(2906002)(81156014)(81166006)(386003)(25786009)(99286004)(7736002)(186003)(2501003)(5660300002)(486006)(1076003)(2201001)(6486002)(86362001)(476003)(2616005)(6512007)(6436002)(11346002)(4326008)(446003)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7PR04MB4620;H:DB7PR04MB4618.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: UzUvqmKbMnXYoV/1NttfKXUOQQN7judX+KQThDFGpMTVPuHYEgaNWZJrtcKD2+NtD9ax+m3bi029ontU83Wo0FeUw7yIco2qHICr0cpOIWYQrQ9GpL+25NICWlndoKPksB8ScGOPCM7vNsn7PRK7duWpO9BgmJyD1YzrhbIzGCxfSfhp9WhU8wb9c/N/ciIYhseJ2WwheqDriZlXAX7Zhuz6fFMZvVtxtsZVsQMz2UsbkEQtCTWv2MttzUxdMO0msJ9Z5nMTgltr8PfVx9nNuqV2UQEQI5VVIL7Rt4P2t74N5tTIEpg8k8UYcOdSzUT2GltiyCMIcxTq4lQaqbmaM+uuYym3ihcilTJIaKQt+banfKsO5pzezUTIdr+/rwJon8UFqVOjvjr6GUCSvPd4L6CbIR4tCTUsqoB1s3CPjPT1Gz/l3ln/KHLqVkVcDjRS
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 28c95dd3-24b2-4845-b407-08d7698928b8
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Nov 2019 05:03:31.2842
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gtF9WY7V9wrfAsz+2rv2ZdcI8zc5tO4fmNGYCOWQxKuMIm340+mzdC1pHAUaRDa2j6c+5UIcekqQ+4cvWPFeCQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4620
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For i.MX7D LPSR mode, the controller will lost power and got the
configuration state lost after system resume back. (coming i.MX8QM/QXP
will also completely power off the domain, the controller state will be
lost and needs restore).
So we need to set pinctrl state again and re-start chip to do
re-configuration after resume.

For wakeup case, it should not set pinctrl to sleep state by
pinctrl_pm_select_sleep_state.
For interface is not up before suspend case, we don't need
re-configure as it will be configured by user later by interface up.

Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
---
 drivers/net/can/flexcan.c | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
index dd91d8d6b5a6..f75d8099a035 100644
--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -26,6 +26,7 @@
 #include <linux/platform_device.h>
 #include <linux/pm_runtime.h>
 #include <linux/regulator/consumer.h>
+#include <linux/pinctrl/consumer.h>
 #include <linux/regmap.h>
=20
 #define DRV_NAME			"flexcan"
@@ -1691,7 +1692,7 @@ static int __maybe_unused flexcan_suspend(struct devi=
ce *device)
 {
 	struct net_device *dev =3D dev_get_drvdata(device);
 	struct flexcan_priv *priv =3D netdev_priv(dev);
-	int err =3D 0;
+	int err;
=20
 	if (netif_running(dev)) {
 		/* if wakeup is enabled, enter stop mode
@@ -1703,25 +1704,27 @@ static int __maybe_unused flexcan_suspend(struct de=
vice *device)
 			if (err)
 				return err;
 		} else {
-			err =3D flexcan_chip_disable(priv);
+			flexcan_chip_stop(dev);
+
+			err =3D pm_runtime_force_suspend(device);
 			if (err)
 				return err;
=20
-			err =3D pm_runtime_force_suspend(device);
+			pinctrl_pm_select_sleep_state(device);
 		}
 		netif_stop_queue(dev);
 		netif_device_detach(dev);
 	}
 	priv->can.state =3D CAN_STATE_SLEEPING;
=20
-	return err;
+	return 0;
 }
=20
 static int __maybe_unused flexcan_resume(struct device *device)
 {
 	struct net_device *dev =3D dev_get_drvdata(device);
 	struct flexcan_priv *priv =3D netdev_priv(dev);
-	int err =3D 0;
+	int err;
=20
 	priv->can.state =3D CAN_STATE_ERROR_ACTIVE;
 	if (netif_running(dev)) {
@@ -1733,15 +1736,19 @@ static int __maybe_unused flexcan_resume(struct dev=
ice *device)
 			if (err)
 				return err;
 		} else {
+			pinctrl_pm_select_default_state(device);
+
 			err =3D pm_runtime_force_resume(device);
 			if (err)
 				return err;
=20
-			err =3D flexcan_chip_enable(priv);
+			err =3D flexcan_chip_start(dev);
+			if (err)
+				return err;
 		}
 	}
=20
-	return err;
+	return 0;
 }
=20
 static int __maybe_unused flexcan_runtime_suspend(struct device *device)
--=20
2.17.1

