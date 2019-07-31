Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0EF227B949
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 07:56:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726151AbfGaF4i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 01:56:38 -0400
Received: from mail-eopbgr60054.outbound.protection.outlook.com ([40.107.6.54]:4865
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725209AbfGaF4i (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 31 Jul 2019 01:56:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S5u8ZqP+j+KyRwWazRg9WRwanFim3yr5NtRSIzzcxH8G5BXgU6Z69vRjBGgVTQOtgFTAoGMithDRSKMX3lZfemZIIax50dCeO9SMLSOKbjOEvxPTcmDD7+YsxfYcMOezb/DZQHHOxcW7UF6zHjmPJprzgz3JzF7cJ1LrEN6Y2vnODS1c+/M94HxCbcByteRQm63+jytcHkWXKkR/Lq4679hg0M2vv+ZUl8X04kSSDxpG8Oz9MRpw+2kl/JvXRjf8j1ZhVDF8YAKtoi92SttwV9ENIJi8+hStVKsy5Cx6H1TSvqGCiST6n+kCIPIanSPh1OeZtJiJAKgqUgflDKORuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d1H2fNNW9PNeE5vPBjszhp0zqw/3pJVD4RLmunLrtuM=;
 b=TUEKxcRmQEfU97xX/xcx1CSIBPBo81P8VondsegETZrdcZlUTm8VQTDYA+1rSiDHZTYjDFQfLYwpmE4krWkjKYPUHdWm2/r9mUGc/CXu+Jgys9vS+DzGkuAynNcxNfFE4H1MMbkqp6q8uksdQcWfKTRyU5yw3Ez44ZrE1USUpNM31u1TlZH121/JG1Hp7//nm9lHPMUXyl+xDh1vzZq2tFAtueWpNybOsWUMro7OxnZaM4KwBmhZWtY6QhgH1IGvYFeMjeR1lLWXERdPd591AFrswFAJex9lqTZNHPjU3DuR3uF8jB+s6TPOeZmshgZIWAQPxVqCjRhQDDoGblQMkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=nxp.com;dmarc=pass action=none header.from=nxp.com;dkim=pass
 header.d=nxp.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d1H2fNNW9PNeE5vPBjszhp0zqw/3pJVD4RLmunLrtuM=;
 b=ngHJ0bW6ycubPDfAvf7idEI6Fak+M6ci1vUBpzTSkhlFDCXUkEEUCZ6J2xA1zzOQXU6/DnfGJUtaJteOOGMCXsijLYLcEC7U9PHIWFdkEmy6t3Dl+B4ZeKM4W4WPE7HKEs9N4XX/lCYgR5WzE6MckrHiYB4gSbMJZDttMXJaDTU=
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com (52.135.139.151) by
 DB7PR04MB4924.eurprd04.prod.outlook.com (20.176.234.31) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.11; Wed, 31 Jul 2019 05:56:33 +0000
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::6553:8d04:295c:774b]) by DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::6553:8d04:295c:774b%5]) with mapi id 15.20.2115.005; Wed, 31 Jul 2019
 05:56:32 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     "mkl@pengutronix.de" <mkl@pengutronix.de>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>
CC:     "wg@grandegger.com" <wg@grandegger.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>
Subject: [PATCH] can: flexcan: add LPSR mode support for i.MX7D
Thread-Topic: [PATCH] can: flexcan: add LPSR mode support for i.MX7D
Thread-Index: AQHVR2S0Rdpah0lS20a879tXPe4dwg==
Date:   Wed, 31 Jul 2019 05:56:32 +0000
Message-ID: <20190731055401.15454-1-qiangqing.zhang@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.17.1
x-clientproxiedby: SG2PR02CA0032.apcprd02.prod.outlook.com
 (2603:1096:3:18::20) To DB7PR04MB4618.eurprd04.prod.outlook.com
 (2603:10a6:5:38::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=qiangqing.zhang@nxp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3416749d-13e0-4b0f-3e30-08d7157bd677
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:DB7PR04MB4924;
x-ms-traffictypediagnostic: DB7PR04MB4924:
x-microsoft-antispam-prvs: <DB7PR04MB4924ADD6016C1F7B816F27FAE6DF0@DB7PR04MB4924.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2276;
x-forefront-prvs: 011579F31F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(346002)(366004)(136003)(396003)(39860400002)(199004)(189003)(476003)(2616005)(54906003)(486006)(99286004)(6436002)(14444005)(8676002)(256004)(68736007)(14454004)(2906002)(36756003)(5660300002)(71190400001)(2501003)(386003)(1076003)(102836004)(71200400001)(316002)(186003)(26005)(66946007)(66476007)(66556008)(64756008)(66446008)(6486002)(110136005)(25786009)(52116002)(6506007)(305945005)(4326008)(81156014)(50226002)(86362001)(81166006)(6512007)(3846002)(6116002)(53936002)(66066001)(8936002)(7736002)(478600001);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7PR04MB4924;H:DB7PR04MB4618.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 9OxzbA2QynCYKl3x/k9bU3V+NWHrAGzp+I/sokai1rxyp1dQ8tyvomMb4fF0uVkJeVxaCTfVoVRGYZ18v994f1GnZ9oOy7nOHSE+Vabv3dFyFTeibZDEMGDFosEeIG8ktL7Rjmd/IS2S5DmqleTalHPG26X1G5wIf95dQX+e+UuyfvS2tvChMtrkRvWIO1EP+rr9xDMnyEd9PfZoIEBiCSuE8HsHEbbpaN9nUmRmmyIMfa4qVJEtVtIspirhsURh+9/8RhMa+Op/R78qfjSdqy3Zv0bbqo0Tbz8+7i9UF/vP38qE+M0ICqMn0sHqFUxXSTSdi71ipXPFY171ZSR5zDIbCIYMm3/8fqPYgM9BaBUwaX7LTOrJmEnrNBIOw4LspPrHpwcNuB3jNO84IEpA0EuZgiPo+MYkNV9U+clNfF4=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3416749d-13e0-4b0f-3e30-08d7157bd677
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jul 2019 05:56:32.7629
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qiangqing.zhang@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4924
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
index c21b3507123e..228d07e84ddc 100644
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
@@ -1889,7 +1890,7 @@ static int __maybe_unused flexcan_suspend(struct devi=
ce *device)
 {
 	struct net_device *dev =3D dev_get_drvdata(device);
 	struct flexcan_priv *priv =3D netdev_priv(dev);
-	int err =3D 0;
+	int err;
=20
 	if (netif_running(dev)) {
 		/* if wakeup is enabled, enter stop mode
@@ -1899,25 +1900,27 @@ static int __maybe_unused flexcan_suspend(struct de=
vice *device)
 			enable_irq_wake(dev->irq);
 			flexcan_enter_stop_mode(priv);
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
@@ -1926,15 +1929,19 @@ static int __maybe_unused flexcan_resume(struct dev=
ice *device)
 		if (device_may_wakeup(device)) {
 			disable_irq_wake(dev->irq);
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

