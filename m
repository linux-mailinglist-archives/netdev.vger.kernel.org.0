Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B303112A4D
	for <lists+netdev@lfdr.de>; Wed,  4 Dec 2019 12:36:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727788AbfLDLgY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Dec 2019 06:36:24 -0500
Received: from mail-eopbgr140074.outbound.protection.outlook.com ([40.107.14.74]:18334
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727778AbfLDLgW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Dec 2019 06:36:22 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ItetdWtT6LS9KkHTSXvmOkpOyNdqmLvxGSnbFuNTygc/W/rhotN3BjOAPcwTDsLmbfmv6jpNtigXA8UwiBUeXuGjch60/K2MDESnYYUUT9i6EeHVUCPA1+OEb65Ds2W8AVpZRXb8VHDgGZtYkyS72NZb14HloJiPlEZp2VWuBXUX5x1xO+5foL/Nr+Yl6y+JbhnyhxKLSjjkXtSOG3BDUFJJZ1nyO9Dfez+69NIFPEf/XSozi3IA3dFOHKlSvze/mNc7Cd7DCzR6kj+NurvAAOf47SabzTxGP92mG2qze/C4OEeDfPQIYQZtXrtEMKyx+o+pEUd6Z9WO4mgrDxbu/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wnjg3sG7grDw3gRu4Q4aHi1+h7q9NPsmRiF/BgouGI8=;
 b=KW6QJas25tn8976GqJ/H4twaUBQ8LgaRkRX3OVfbmXav2xbEJ+J173CvtW2z9s+YoW9LY2UILH1GPvlUOpPmemG4VHonCra1KS5wqV3FaMspRFOHFKLiBqSD6n52ZySroqdMRlIJJhWnySEVIWX+VJ6JC0PrsrgJPXyF3L4XLcR7pSYWJgnOK1mA+YlOWkH6KYjZ1m55XgTjz1evBjlQW6w95LS0SLEDdGA4Ihzzwp+uosviM4Q3ee6k/zrWKC5QmB7tsTNW3Pig4znQVSSqq5/u/JcrQVm0hb5Q9l4JguZ2aBHFtJ1+sNGFdNS5mQUwEHCQTVVaB8Mhk+BmmpC2kQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wnjg3sG7grDw3gRu4Q4aHi1+h7q9NPsmRiF/BgouGI8=;
 b=fXjaQjpWXbazfFziwtGINopfb/20J9qQKn3XrinF5ho471+5oEjn0J2xqXcM82Juj9M6p8bB1lHCdo4KapOGCG4Xu4U8rGt1knskOUhkVhnbWIney+9TOYD5f1fr1AHc0vz5f2rlrk6K0WEkEyQdGulUSrS9obzYkcg0/w2K3cM=
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com (52.135.139.151) by
 DB7PR04MB5017.eurprd04.prod.outlook.com (20.176.234.213) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2516.13; Wed, 4 Dec 2019 11:36:19 +0000
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::1c96:c591:7d51:64e6]) by DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::1c96:c591:7d51:64e6%4]) with mapi id 15.20.2516.003; Wed, 4 Dec 2019
 11:36:19 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     "mkl@pengutronix.de" <mkl@pengutronix.de>,
        "sean@geanix.com" <sean@geanix.com>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>
CC:     dl-linux-imx <linux-imx@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Joakim Zhang <qiangqing.zhang@nxp.com>
Subject: [PATCH V3 6/6] can: flexcan: add LPSR mode support
Thread-Topic: [PATCH V3 6/6] can: flexcan: add LPSR mode support
Thread-Index: AQHVqpcMkwvUuOPKjku6wnU9NQYCfA==
Date:   Wed, 4 Dec 2019 11:36:19 +0000
Message-ID: <20191204113249.3381-7-qiangqing.zhang@nxp.com>
References: <20191204113249.3381-1-qiangqing.zhang@nxp.com>
In-Reply-To: <20191204113249.3381-1-qiangqing.zhang@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.17.1
x-clientproxiedby: SG2PR02CA0050.apcprd02.prod.outlook.com
 (2603:1096:4:54::14) To DB7PR04MB4618.eurprd04.prod.outlook.com
 (2603:10a6:5:38::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=qiangqing.zhang@nxp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 7beca644-b11f-42c5-593d-08d778ae2e6c
x-ms-traffictypediagnostic: DB7PR04MB5017:|DB7PR04MB5017:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB7PR04MB5017FFB142AE5D70921A6EC5E65D0@DB7PR04MB5017.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-forefront-prvs: 0241D5F98C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(376002)(396003)(39860400002)(136003)(346002)(199004)(189003)(54534003)(3846002)(316002)(36756003)(6512007)(305945005)(2201001)(6486002)(6436002)(2906002)(7736002)(76176011)(52116002)(14444005)(71190400001)(71200400001)(110136005)(6116002)(478600001)(14454004)(81166006)(99286004)(6506007)(102836004)(26005)(25786009)(1076003)(186003)(2501003)(81156014)(2616005)(8936002)(11346002)(5660300002)(8676002)(50226002)(64756008)(4326008)(66446008)(66946007)(66556008)(66476007)(86362001)(54906003);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7PR04MB5017;H:DB7PR04MB4618.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: uNsJw6OSbWXKktmTF3K9Qkzz4iEq54RPAghpTdy+dNEeXJaW1Z1B4tF3eXf5Z1WC5eimvkbMfWrN6j+7KBd/ghYHpSYoTS/KA0H8dCLcSi+wetlXjq8ZtG5TtY14tATnuEWaVX2J/xkOml2JyGb8sOH2b3lH6STM+cwMRgaxh8d9AK7bYxnPB/M814zSJIBSJcEONtRPILhJB4tgJtouCeptkeoZIQdKUZm6C9kJbVUIdGRfEbX8T/3yphirk5l248YP9gC6MAHPPFNa7aJMtBXEoLINMrchKsrdUH2HJOm4TsAIsySqLbl6HmpOI0vh3oK3rYkSYcx4Mcrdrx5lLwodKW6MxBecmiN/Kmzb8KXZjdCdH/bjBZ2Nh0B8vX8gi1WoyLDzMPP3keOt8UIts7e/DDHv0p1gQ5Iqm17uhMfEC6h/8aSbVtsZjMzXY2lLJ5VLREmrxXdQFvZLUaL1S2tB+lCAQFRwxPYZeR7iKJ3LU8nOqROuENfe+SXJYWap
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7beca644-b11f-42c5-593d-08d778ae2e6c
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Dec 2019 11:36:19.6678
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: N9JdnyflDgq6zBrL3BBVkuKzy0wz5sgsPyAYR6ITD5qqmUYYGhc9pDU0PNTEYYBH7KUa7Kcg75crbXlWWbOjgQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB5017
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
	V1->V2: *no change.

	V2->V3: *add error handling for pinctrl_pm_xx_xx_state()
		 function.
---
 drivers/net/can/flexcan.c | 25 +++++++++++++++++++------
 1 file changed, 19 insertions(+), 6 deletions(-)

diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
index c5e4b6928dee..3570ebe3b8f2 100644
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
@@ -1700,7 +1701,7 @@ static int __maybe_unused flexcan_suspend(struct devi=
ce *device)
 {
 	struct net_device *dev =3D dev_get_drvdata(device);
 	struct flexcan_priv *priv =3D netdev_priv(dev);
-	int err =3D 0;
+	int err;
=20
 	if (netif_running(dev)) {
 		/* if wakeup is enabled, enter stop mode
@@ -1712,25 +1713,31 @@ static int __maybe_unused flexcan_suspend(struct de=
vice *device)
 			if (err)
 				return err;
 		} else {
-			err =3D flexcan_chip_disable(priv);
+			err =3D flexcan_chip_stop(dev);
 			if (err)
 				return err;
=20
 			err =3D pm_runtime_force_suspend(device);
+			if (err)
+				return err;
+
+			err =3D pinctrl_pm_select_sleep_state(device);
+			if (err)
+				return err;
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
@@ -1742,15 +1749,21 @@ static int __maybe_unused flexcan_resume(struct dev=
ice *device)
 			if (err)
 				return err;
 		} else {
+			err =3D pinctrl_pm_select_default_state(device);
+			if (err)
+				return err;
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

