Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C5DB8FDA6
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 10:21:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727081AbfHPIUt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Aug 2019 04:20:49 -0400
Received: from mail-eopbgr140051.outbound.protection.outlook.com ([40.107.14.51]:64417
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726809AbfHPIUr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Aug 2019 04:20:47 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Kd0/9i4uUTI00G1Upcbn0+dXLeIEkuK+WJ7Ww3acnv95gMlLoqjaLRI5NQvsxC0QfB1i8lssKPbzvfpQk0RDmaMPKhyUQcy/0ICdr6T7QWAofcQPQ6vO/0OQSxmdAkJmMZkeaL0RaG2nbOsyKsLkgeTSXeyReH551VswQMscYX6xh3hc0HnZtUNH/jsik1SpcLVEPjvIXCIqZyfRqeb0207fuqm5+1FkRPhKARU5+yhYLXrQvi/jlFhz2JPAViTulrxHqU54q8lh3ZF7838uzQEjM5n1/W2rVMbnC9k4H2x4SA6geuh81dWFuMNSvKzhxvajgSrISkwvNQz4AWvQNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jjni1yQQHYAQq/lz2TnGBSx9Fp6htKdA7RKiGgYf9NQ=;
 b=Jq0NVnaEH60H/ZU7qbwALt91wf58FWjb50JCEuqKE/34LBP+/89lpFpo+c0As9ZI1RFAAlr7nJ4qIz+ylrnQxKZf2fT4UTX7WFK4aQgYA5wiwqqBVHqwymFwBlwd+5DzwN0ZUKO03APVK26Xq6p5fEeSh03yW/iah7BGo5CYktKDu1XCNlseXqa15sgELkfZxOkhYh3v2OvuWZ2pEmShMVlolVwg3afIkA9xxhbJszbg0STO+ThxoEx9Tk6HH8Y4/sg2T2vt7xWvneK8VnaiMAVIRpFmNqHgxdB3kEUePlJHwcV2TdHJYDK1q7M2C3LkB5bXGtpLbo+muQREwJTNQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jjni1yQQHYAQq/lz2TnGBSx9Fp6htKdA7RKiGgYf9NQ=;
 b=FOT05os02SakGaCjgytg/rR66VtyeDZp24IT3ZTYbYBmdmTfHDd2jKTM+Mw7xOMj0JS6Tv6lfA/UbohDkjtRdD8y7SbM7/OKT4clYY/qjzD7hicbSqYzwhjQTTSY6NPo4wopENv/hwCohqK5K7g59mt9wRoAS5+CIs/vGu1xFfM=
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com (52.135.139.151) by
 DB7PR04MB5419.eurprd04.prod.outlook.com (20.178.104.204) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.21; Fri, 16 Aug 2019 08:20:45 +0000
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::c8ca:1c9c:6c3:fb6f]) by DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::c8ca:1c9c:6c3:fb6f%4]) with mapi id 15.20.2157.022; Fri, 16 Aug 2019
 08:20:45 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     "mkl@pengutronix.de" <mkl@pengutronix.de>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "sean@geanix.com" <sean@geanix.com>
CC:     "wg@grandegger.com" <wg@grandegger.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>
Subject: [PATCH REPOST 2/2] can: flexcan: add LPSR mode support for i.MX7D
Thread-Topic: [PATCH REPOST 2/2] can: flexcan: add LPSR mode support for
 i.MX7D
Thread-Index: AQHVVAuAN63M2nXzF0CEcv0dlGbD9Q==
Date:   Fri, 16 Aug 2019 08:20:44 +0000
Message-ID: <20190816081749.19300-3-qiangqing.zhang@nxp.com>
References: <20190816081749.19300-1-qiangqing.zhang@nxp.com>
In-Reply-To: <20190816081749.19300-1-qiangqing.zhang@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.17.1
x-clientproxiedby: SG2PR0401CA0004.apcprd04.prod.outlook.com
 (2603:1096:3:1::14) To DB7PR04MB4618.eurprd04.prod.outlook.com
 (2603:10a6:5:38::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=qiangqing.zhang@nxp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9cc2aea1-7f99-4128-97ba-08d72222a28d
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:DB7PR04MB5419;
x-ms-traffictypediagnostic: DB7PR04MB5419:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB7PR04MB54192F458118ABCF316A3FB0E6AF0@DB7PR04MB5419.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 0131D22242
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(376002)(346002)(396003)(39840400004)(136003)(54534003)(199004)(189003)(5660300002)(478600001)(6512007)(110136005)(4326008)(25786009)(54906003)(81166006)(76176011)(2906002)(81156014)(53936002)(8676002)(316002)(1076003)(186003)(3846002)(99286004)(11346002)(66946007)(14454004)(26005)(86362001)(2501003)(52116002)(6436002)(476003)(50226002)(6486002)(2616005)(386003)(446003)(66556008)(66066001)(256004)(6506007)(14444005)(486006)(36756003)(66476007)(6116002)(71190400001)(71200400001)(305945005)(102836004)(64756008)(66446008)(8936002)(2201001)(7736002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7PR04MB5419;H:DB7PR04MB4618.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: ubvLTRJ/OLTcZzHyPCEc+Tj4J4WuFMCFZRxUCbohYjbsnVn+X5hP6ve1zHjECpBuf/h5B6qWJy3YPr9msGKwszewI2FBu5TVXPIrrsQi6wYI6K2W9cM/9quPlUXaiddA9jz+InHgNN2VgmOj29DjwK83HnAhwlq3ohF65Y0Wvb1kqQ40DfgpAyv+tCNzbcofT2Ox/Lri3vsRD2s/y5uurRR/+0UtOJRVTbrkf5pn7bCGEJ7Heck7OJ5S0PfnluU6BsETK7DsUIAqugCCEH/ZO6eAZCfv+g5ql1igIKD9ddl3nhzGwM/qWNZbD2q1f1cM6yZxgaTSRaFAvB05R+8oAJhpei2a+6JXwB0yNznt9Bh0EImPjWWyCBdWGfuSvWWVlnQBF9kg/Hh/cuqq3M75yW0vj4dYpqWmTP+jwcOK1ZE=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9cc2aea1-7f99-4128-97ba-08d72222a28d
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Aug 2019 08:20:44.9803
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vrNv4h7r2Vor36L5qlUP9ZiL8ZMZejsExCUzCaFKunSqN8Uav/oLZHwWGzqMmmLmwe1oqOtCynEQC7RYVEwZug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB5419
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
V1->V2:
	* rebase on linux-can/testing.
	* move into a patch set.
---
 drivers/net/can/flexcan.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
index de2bf71b335b..b3edaf6a5a61 100644
--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -25,6 +25,7 @@
 #include <linux/of_device.h>
 #include <linux/platform_device.h>
 #include <linux/regulator/consumer.h>
+#include <linux/pinctrl/consumer.h>
 #include <linux/regmap.h>
=20
 #define DRV_NAME			"flexcan"
@@ -1640,9 +1641,9 @@ static int __maybe_unused flexcan_suspend(struct devi=
ce *device)
=20
 			priv->in_stop_mode =3D true;
 		} else {
-			err =3D flexcan_chip_disable(priv);
-			if (err)
-				return err;
+			flexcan_chip_stop(dev);
+
+			pinctrl_pm_select_sleep_state(device);
 		}
 		netif_stop_queue(dev);
 		netif_device_detach(dev);
@@ -1674,7 +1675,9 @@ static int __maybe_unused flexcan_resume(struct devic=
e *device)
=20
 			disable_irq_wake(dev->irq);
 		} else {
-			err =3D flexcan_chip_enable(priv);
+			pinctrl_pm_select_default_state(device);
+
+			err =3D flexcan_chip_start(dev);
 			if (err)
 				return err;
 		}
--=20
2.17.1

