Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 572FB10AA76
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 06:57:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726556AbfK0F46 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Nov 2019 00:56:58 -0500
Received: from mail-eopbgr150050.outbound.protection.outlook.com ([40.107.15.50]:3753
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726078AbfK0F45 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Nov 2019 00:56:57 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TCXUVJvf63uoRLGLZ1bbeJH0b1MpzxZWTiNUGTmcOidkjjeNCyuDHal5w4Iv8X4v/SwxqTnkZSaplsUXmMXXWpjg6Nt1isdLLbPJnt9rV4n+IGrpJFJMAOyuOVaMnYYI6XCkXDd1RjTM396mI69v0MusorsBgCsQYQiJRt8/yZH5IV8fbgdK7dimNUmhOFjz1rQ/FtVPdrcBYIfmUEkuUkecdpPc3EGXcM34tK9fCHUfZuWiNypJeResc4SLF9jz8uINg1VJYHQJu2B9HKA6BaMh+xux5802ITt80jB8P+5yQNXtTf7tb/AcUqJbIH5y3GkL49rBaKOpIMatRZHuJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5f84Cx8UmrPuYKl/6j6fd8H4BYxh9f/5OStr+GrMOBY=;
 b=fXd/J+M4AcXlpnk51TU7xiqUAsMyi+ZToogd7/eyYhi1EMudY6wkQqVLyoXtit6JKLRzZPImWwGoU1g29r7gOED0YvSaTDW61gBxVgaCuTGjGWHV0ROXDadlasm8hDlbJ/uDUGdCa85l11738fD8gW9pazJ2kR6t7+xib0Oit7bwMY9rGzxhjJRsBXiWfxi7PXRnmD7+IUHoTkApzeG1rIYGaC6jjai/2NBHsJ6+kFE+YKQtfLdm5Y8WZUtsQMMtIa+W50dX/f1NCnunlATXloOuR6lv/1r+8MnzVF2nEjwGzPY7j6tCqGvy/gCZ9osmZCP5U5ULTK11E7d8QGMgOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5f84Cx8UmrPuYKl/6j6fd8H4BYxh9f/5OStr+GrMOBY=;
 b=pzAJUzwaAbS5H0TwP3HiYjqMTf139/TNjqYnTNIaObI+RcPG8l2dH07F9bN+r9BzQ6GJ9uw9/OK8Zdl/AzZtf/W5rIWAdHRW/L4HewRxf3HOaBdbWl4cMUWdKSFPTgaXjk1+WixHxSXQHSil5LgaSHdnmU9CC8ucJ3oclWuBu9E=
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com (52.135.139.151) by
 DB7PR04MB4092.eurprd04.prod.outlook.com (52.135.131.11) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2474.19; Wed, 27 Nov 2019 05:56:52 +0000
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::1c96:c591:7d51:64e6]) by DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::1c96:c591:7d51:64e6%4]) with mapi id 15.20.2474.023; Wed, 27 Nov 2019
 05:56:52 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     "mkl@pengutronix.de" <mkl@pengutronix.de>,
        "sean@geanix.com" <sean@geanix.com>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>
CC:     dl-linux-imx <linux-imx@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Joakim Zhang <qiangqing.zhang@nxp.com>
Subject: [PATCH V2 4/4] can: flexcan: add LPSR mode support
Thread-Topic: [PATCH V2 4/4] can: flexcan: add LPSR mode support
Thread-Index: AQHVpOd3D9txXS3dtUSMzmH9fMhQMQ==
Date:   Wed, 27 Nov 2019 05:56:52 +0000
Message-ID: <20191127055334.1476-5-qiangqing.zhang@nxp.com>
References: <20191127055334.1476-1-qiangqing.zhang@nxp.com>
In-Reply-To: <20191127055334.1476-1-qiangqing.zhang@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.17.1
x-clientproxiedby: SG2PR03CA0089.apcprd03.prod.outlook.com
 (2603:1096:4:7c::17) To DB7PR04MB4618.eurprd04.prod.outlook.com
 (2603:10a6:5:38::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=qiangqing.zhang@nxp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 0968cb74-fd81-4155-088b-08d772fe99dd
x-ms-traffictypediagnostic: DB7PR04MB4092:|DB7PR04MB4092:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB7PR04MB409256F82E1C3BDBF23D4E4CE6440@DB7PR04MB4092.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2276;
x-forefront-prvs: 023495660C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(396003)(366004)(346002)(136003)(376002)(189003)(199004)(54534003)(81156014)(316002)(6486002)(6436002)(6512007)(76176011)(102836004)(11346002)(2501003)(6506007)(386003)(186003)(8676002)(86362001)(5660300002)(66946007)(64756008)(66556008)(66446008)(66476007)(446003)(2201001)(50226002)(26005)(1076003)(25786009)(305945005)(6116002)(7736002)(2616005)(81166006)(3846002)(2906002)(4326008)(8936002)(14454004)(52116002)(36756003)(66066001)(478600001)(71200400001)(110136005)(14444005)(99286004)(256004)(54906003)(71190400001);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7PR04MB4092;H:DB7PR04MB4618.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hKOrYiFgepA9eBQRibQ6HVtVYP7a4upPzAPvy17QtBdp1fhG9XKtrTYSTR421Hjp5AQLCU+IFouki9Eeki+yMUdhGpIkedrxb3n4NF0FfPqYD87vyXSXSFMBhSCHZn8ecG606TbiKOxHLJf+rKpzS70PiaWg5NK5mV7Gtd9x6AvD8Y5joOF98toP4zvsPq8cO75KjrfUIMR+90G+rlsoBvOCTyeIVKA5q7shETY/LTOsbe0Q4W8cBOgOc394w65TQipQazGmtQA1u1crANCLH7Ah7XLXvj3LQ79z1dDMDWCWaDSPXnv6DqfO/1+Z//3hAOIk7NqqJv/u7MWLNAbhR31HKMFDdWh6JvpLQD9vSlC36vWlqvCSY3vsnclEtzSqGSCbH/dHl4rno+2kcPj7ChvxiF9oZ8OD/CuxQySsGk5Vs4Wmr3Hve/PbWzVTOiEG
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0968cb74-fd81-4155-088b-08d772fe99dd
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Nov 2019 05:56:52.6862
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: guDkdhyvDrIIekBHxwY4RvEvH9FaxOrZYxruVYxkG2d6K4SDuo8F0v7d+k/mibAb1qgnJi68mnpcu4PdJWs0OQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4092
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
------
ChangeLog:
	V1->V2: no change.
---
 drivers/net/can/flexcan.c | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
index d178146b3da5..d1509cffdd24 100644
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
@@ -1707,7 +1708,7 @@ static int __maybe_unused flexcan_suspend(struct devi=
ce *device)
 {
 	struct net_device *dev =3D dev_get_drvdata(device);
 	struct flexcan_priv *priv =3D netdev_priv(dev);
-	int err =3D 0;
+	int err;
=20
 	if (netif_running(dev)) {
 		/* if wakeup is enabled, enter stop mode
@@ -1719,25 +1720,27 @@ static int __maybe_unused flexcan_suspend(struct de=
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
@@ -1749,15 +1752,19 @@ static int __maybe_unused flexcan_resume(struct dev=
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

