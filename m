Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2D7AD0958
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 10:13:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729592AbfJIINL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 04:13:11 -0400
Received: from mail-eopbgr80042.outbound.protection.outlook.com ([40.107.8.42]:33604
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725962AbfJIINL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Oct 2019 04:13:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mOaXS6Jwb9D7sTAL1w+FmD8zngAjJov05p/SgzVJIs52CJ47f8bJSpsNXuipwLLEHRfBQVrnMGbbzYDIn3XmItlNvHL3ewNAJKFcG9EvJ6w3gVEHYuQWMc7fxnUXkNGZMl48YPWcbf4q1Qovcv/A+LLmcWtwyhv1Y15y1GjgTY42PIFfSvw6ZCbmrEU7Enx5EA4VMtf2aIfK/rnEU3mf+ux5Uzjf8Qg2w5wZRaCJije0Zaoz0FIinqd9YNMOgod1QIc8mxEl8ieeKluWxZgfN3ifaRIIL2lLHFPH0XkyLuAD7HbDfjgVGD/xtBRX+QBhisbAz920qq0o+nJ7oTPoDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vlyiha8cKiVunuLhL74uKPRSpxMhOhGgaWs+ZckFb2o=;
 b=QnTEhQ9cWLsl9j0ltUPpY6lMlWXkx+BnquMUpdx/PDoZDkeMIP+p0eXH886X0QGQBAPOppMgTTFoioN3b2ZuWeiSuvuilnfW+qaODoWzsfbp6y/QSZ6wQsK5BDmxFbVpyabxxoxqJH0wra2HR9xz5NR0N3LN8OuJ+FWkjIJqueCFUg2WesDDAEwOWI0mdC/Juk2RL3Va3wljUD3YRicWmFke0xchp0KmF0TeIt9iANvpWWUeNcHKq94h/OEVIF84IHZLg6BVrCMFqjmQkZdvx+EC43T9HT0JspNgrOVr7aWq9GJqJH+OM9x5yr6zytgwESFVzt5GIjULULri8cMf2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vlyiha8cKiVunuLhL74uKPRSpxMhOhGgaWs+ZckFb2o=;
 b=eiHgGSOeT9Jdn72TQ4bremFE28H2CtKKbU/pZh7ApR0NlK5wrbMbElpYYXJ3+kRN8Oc3Te8UIBTQEmcVWBJ0beOKae8TEZKLrlxmBLJ9QgnrN2weniJBHsm8L47S6KGML+JmPotznJZa9wdSCaUqXVeQ+rX8aYQgYKLP4y9n9ZM=
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com (52.135.139.151) by
 DB7PR04MB5081.eurprd04.prod.outlook.com (20.176.236.212) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.16; Wed, 9 Oct 2019 08:13:07 +0000
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::79f1:61a7:4076:8679]) by DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::79f1:61a7:4076:8679%3]) with mapi id 15.20.2327.026; Wed, 9 Oct 2019
 08:13:07 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     "mkl@pengutronix.de" <mkl@pengutronix.de>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>
CC:     "wg@grandegger.com" <wg@grandegger.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "sean@geanix.com" <sean@geanix.com>,
        dl-linux-imx <linux-imx@nxp.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>
Subject: [PATCH V4 2/2] can: flexcan: add LPSR mode support for i.MX7D
Thread-Topic: [PATCH V4 2/2] can: flexcan: add LPSR mode support for i.MX7D
Thread-Index: AQHVfnliD0Y3+X9f0kS5lPg5k0t1nw==
Date:   Wed, 9 Oct 2019 08:13:07 +0000
Message-ID: <20191009080956.29128-2-qiangqing.zhang@nxp.com>
References: <20191009080956.29128-1-qiangqing.zhang@nxp.com>
In-Reply-To: <20191009080956.29128-1-qiangqing.zhang@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.17.1
x-clientproxiedby: SG2PR06CA0108.apcprd06.prod.outlook.com
 (2603:1096:3:14::34) To DB7PR04MB4618.eurprd04.prod.outlook.com
 (2603:10a6:5:38::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=qiangqing.zhang@nxp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f1ee0919-e00b-4c84-b284-08d74c90845f
x-ms-office365-filtering-ht: Tenant
x-ms-traffictypediagnostic: DB7PR04MB5081:|DB7PR04MB5081:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB7PR04MB508145CB0B24CE6779514756E6950@DB7PR04MB5081.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-forefront-prvs: 018577E36E
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(396003)(376002)(136003)(366004)(39860400002)(199004)(189003)(54534003)(54906003)(36756003)(6512007)(6116002)(66476007)(6486002)(26005)(7736002)(2906002)(66556008)(64756008)(66446008)(3846002)(186003)(81156014)(81166006)(99286004)(14444005)(50226002)(2501003)(256004)(110136005)(11346002)(2616005)(476003)(478600001)(446003)(486006)(8676002)(66946007)(6436002)(25786009)(305945005)(71200400001)(71190400001)(1076003)(316002)(102836004)(386003)(66066001)(5660300002)(6506007)(4326008)(14454004)(8936002)(76176011)(86362001)(52116002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7PR04MB5081;H:DB7PR04MB4618.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7ENrYHFUzRc52xR0vAnojNaywZVMcNJqWwe5+yUODuO+7GWT2r88xrzcFwHEA7dqtf/Sc6l5MD3vHYrUvOJfF06NStNkBG7OFFFdSuVV2pWuEJpb46970BhsKsiXaQaPqoZf0+D+sieRSyDOoENyXZqjGTjyd+a2x8ZZKkm/UR646D0tSxGwXZKd85UguXcvKHlPHVhSOdPxNStAjYA+sjZ1myGDnYvdcPqH2mK02ZCxAFKzLPPY14U1gztZRowRmZJ8g4T7dKSmypMV6mAUtyUH+1j2fSFXTPBjq4IS4VpF/WwjqsZ+vdPKkjCzhmLr7efPGDYSsfcN68gFdKOqcWFonDizpa/aFFZh2bFC4w4tK+XoeEF+z5Mb0+581wqXojy5WgNjnMmLns9D784BtOrKrR460rBRLHLFxsGUU3U=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f1ee0919-e00b-4c84-b284-08d74c90845f
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Oct 2019 08:13:07.8718
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Oaq30QcpT4IEkD4fBPh+fcohZ8aagbFoyuucVx35z7JtiiqkMVka6PoktFhNGzv2h57SmHV9WC9zKMapA+DZNQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB5081
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

ChangeLog:
V2->V3:
	* rebase on linux-can/testing.
	* change into patch set.
V3->V4:
	* rebase on linux-can/testing.
---
 drivers/net/can/flexcan.c | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
index 24cc386c4bce..e2bc5078615f 100644
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
@@ -1660,7 +1661,7 @@ static int __maybe_unused flexcan_suspend(struct devi=
ce *device)
 {
 	struct net_device *dev =3D dev_get_drvdata(device);
 	struct flexcan_priv *priv =3D netdev_priv(dev);
-	int err =3D 0;
+	int err;
=20
 	if (netif_running(dev)) {
 		/* if wakeup is enabled, enter stop mode
@@ -1674,25 +1675,27 @@ static int __maybe_unused flexcan_suspend(struct de=
vice *device)
=20
 			priv->in_stop_mode =3D true;
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
@@ -1710,15 +1713,19 @@ static int __maybe_unused flexcan_resume(struct dev=
ice *device)
=20
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

