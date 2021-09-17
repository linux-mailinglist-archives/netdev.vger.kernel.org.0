Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0ABE40F95A
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 15:35:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344473AbhIQNgx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 09:36:53 -0400
Received: from mail-eopbgr40079.outbound.protection.outlook.com ([40.107.4.79]:32296
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1343564AbhIQNg1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Sep 2021 09:36:27 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IvQaDYDgX/rVNK2HEtc8d1kmL8RHkN9HlEYAdHT0H1YVq58r7CkG3SRe8XBBFJ1kxWdtC+Q58Ll1js50yntp67fBt6mpZmKO6FbzygWDCEK3gCRLcZMFTiU3+XWRM8QwQ91GcvbZOs+7qeaLOoa7sZjMhJqMzLEx0HvU7MlyklSHEkHtxM22dNUdNq2WZ9ElOOZ48N/qfVInj+vsAcDubaNlTuB/1FQPQZwYEimNlgD46ZzjezIFvAVkSCRmZLZ/HBGaUWfG7huXzZ96Ev9GzOaG365UUayi7FDcLHcdQGadz+wcbjTr9cNd+c6QkPLnwpJc8Uy//eHjC0YlUcSULQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=pjd39OuiyfPLTnwLybfGezRem2rn9KKpaPy2kqVnG6Y=;
 b=GRcNKummeMBW1hxBbGha2VmRRAj94HaLqRwgRZk6OmW9z3MW37MIRWYPIWjzswx6aZ/zDCxpKnoLTGwX/6T9kztZyZTf5t28gs0Bxrs4StYNoliOcC/FLcaFs3O7pZCZJxTrOTaVe4vKULwAVdl8TY0NyRxXFIy7ri98+9NPjYWIhZgOC204VqLYtMVannW1fvwJL3x1A5znygEzvRdWhLjie7yHZQnbS1psaWkZcO2Y2lfVG3SMK+toHB/OlGBNtqvaeTNWTf1jI1FhSR2iMAveRe9si1pWde7ggwTwaQRAnzyejfN0MopkSsc8Rym3+WKi/X72h5yj+XWtEjacFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pjd39OuiyfPLTnwLybfGezRem2rn9KKpaPy2kqVnG6Y=;
 b=W4BrBG6lAOScpdveFdOmPmDh8G/IuuX5IEQz1c8p6uJOh02tnGRXVMP51s5GUJmb9yi2wLJJ7cSg3w0X32oX06K7A25GpUM03irruYr4bIOgFehM4SaIzWL/xjG3C9vPJHVxbUP+VjtUu6/4kd71qV+IoWJB4+0zo/MOSTNEpHs=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB7341.eurprd04.prod.outlook.com (2603:10a6:800:1a6::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.16; Fri, 17 Sep
 2021 13:34:52 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4500.019; Fri, 17 Sep 2021
 13:34:52 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        George McCollister <george.mccollister@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>
Subject: [PATCH v2 net 1/5] net: mdio: introduce a shutdown method to mdio device drivers
Date:   Fri, 17 Sep 2021 16:34:32 +0300
Message-Id: <20210917133436.553995-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210917133436.553995-1-vladimir.oltean@nxp.com>
References: <20210917133436.553995-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR02CA0199.eurprd02.prod.outlook.com
 (2603:10a6:20b:28f::6) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (82.78.148.104) by AM0PR02CA0199.eurprd02.prod.outlook.com (2603:10a6:20b:28f::6) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14 via Frontend Transport; Fri, 17 Sep 2021 13:34:50 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0abbda9d-8b6e-4e9e-f278-08d979dfed8f
X-MS-TrafficTypeDiagnostic: VE1PR04MB7341:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VE1PR04MB73417430C16F3FEADF448984E0DD9@VE1PR04MB7341.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1923;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pDMY4zuRWVVn9kAvXuQE+NMiaqB+YLPIUY3Y6fylArOg/0gUCut7PFA9TmgnYNig5NawxwCEAE2SL3pbneoIw/lJjfjyCPviFRyQt5YxdV2gYBluGY0+PCy7diUuCGqTBSOLVyixT2VixdHpbR6AMLE88NzdrNWeO1Q4QM56jFFgH2FcLylfgj/aZsdpSEUDTaR27VsKdxKGp7DZ9NIhJ+7+QxnqvkSRitK9SbJjwU7LFBoJS+J1wI6W04hsZfrIt7GCS4tLgiep4BwSQZU7FVIWEmKZfEEKhBs47m+IuOnyw5oHYTHZOQnN/UP5kkMiCNmOp7rTH5xiPIdEn8PLFI7dw8uyrX9BoN+6VrO9A5nbAa/uvykdiZw7ysjwJJSx0Fl/pCBxF2CDqaBjRmIJ7RzKjYNO7U955XUgpk345IoyVFUo0JphYYM+VDzMlTbJgbMDKOstPfwV1ZZLGpsIYcfsL2bKgQsQ+YpbrUmI6cdoIuFtC2zxkWPJOiZpBNHySe82OW6+z4FsumDY/Stbcs+wfJ9x2uWQ6dD+IP4LxxNM2nP9bTqe+D3D1Fgc+MjWMJARkihkvFJjtduF7uuLB7QC6wHApcT6aQ7IjyBec7vymnRz+/vUJT7tQvPKTB8edkzu0rDxamwHXyo4J0xvgSlY7kcFUVuZGFH2XPFP9M8x+osIw8KEliOQATT/qpsxvReCoimfNuO8tyoF3oQcWw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(376002)(136003)(39860400002)(346002)(54906003)(316002)(38100700002)(38350700002)(36756003)(44832011)(2616005)(86362001)(6916009)(66556008)(478600001)(6512007)(6666004)(6486002)(8936002)(8676002)(26005)(1076003)(5660300002)(6506007)(52116002)(186003)(83380400001)(2906002)(4326008)(7416002)(66946007)(66476007)(956004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?KS1nV9WOsEYU5h7nsgegyAmNV4t2yYDN0DQSUf8PiKUeiPhnKyLtaZ8+Qbdz?=
 =?us-ascii?Q?S3pCDZaIdq1wpEBxYThx08vgfMz2N3MLXV7g77iJOHlTQtp3XoWCFN5r29+4?=
 =?us-ascii?Q?zKISE78ZbopB5jcz2TXLvZWqfQFCgtXvUbPNReKx62WKMzByVczq8JyAwLXq?=
 =?us-ascii?Q?Xz7nIGDBoUx4mchKm0TqJxylrtloyClfizYrD6GdkCorUcCDs0fgvtq91w6l?=
 =?us-ascii?Q?sy/wy4MFmAR1wwtYqUgEJ3FcOpA3guIVxEF3QH6UcEcLDJGQ8pJnv987EYG7?=
 =?us-ascii?Q?y8eMHqBlhE28cRexeQxlLsTA7E35V4Gn85KTMgjUohSUXgSpcfpxdgcrM76P?=
 =?us-ascii?Q?cZcqSk52nrsGPNWKoLTU+r9krO/wMWS2fxYx6xbXSkJMzdbK/2uP0mY26nNF?=
 =?us-ascii?Q?lEbJvp/BY/lJA5htWGINq8AMXJ6dUYphevfuNQcankyeszfxfkgx/ha6pnJG?=
 =?us-ascii?Q?ZGX79ORt0sCta2RtpO4s7vtV5QwpfMaHTEvtSFmggj9XjrWlcsD1WWeDdoAQ?=
 =?us-ascii?Q?RopgerVh55s3W93l75NQpaPZ84AgAKH86WCU2zT03SamIQT5XMb+c28vGrTw?=
 =?us-ascii?Q?v+IZI2Z9N8sraUgdpJXrKYXL0/noP0Af/25q5MvaAfQ0aqoxwzMVgvK3gDtt?=
 =?us-ascii?Q?dv3qyOq9ginIxkTrV+hdigZyLHfMwrYS2oSKdAYmIqE+ZzMXcbNjsMh0Ytj2?=
 =?us-ascii?Q?v6A7Ktc4mcBMYZs3qln1/sl/Bvj3kQ4RsbnTQa9L6c+ukRrBzm/QxYV/VyX2?=
 =?us-ascii?Q?Th20OETyxNKN9lAXwsXYJ5a5IRiIjQFnrPJjC4X+QTbAUctK52U3FQ7r4tz6?=
 =?us-ascii?Q?EsINb2dlOmurB3RAYa6g/luCE3n6wYUx4kogJUD7zdBteZbmD8yQm7oSG9HX?=
 =?us-ascii?Q?w4+nXTzhIHswzxHCuSiFpwdi1QKSs+WC/CQsZ0kiZg2iVzux0bmajJ0Hzi0A?=
 =?us-ascii?Q?xkyvt11Ilx/7WIm/dlChrQt7NbQIltnLclYR/4nE3doinlz5XV6tjjjq52+c?=
 =?us-ascii?Q?/F07CFXtrXxNSjBNKfQ4KK0Avw6h0KhlZspub3pbRuxF9pqlxog3mMePQ5w5?=
 =?us-ascii?Q?f/ZnLbtgQRkleTpyhwKfsisPBCsj2FgPpyt9TPoHukzLY9360Ri73bGfo+Mq?=
 =?us-ascii?Q?r4xW/4k6AptV8ENXzlReSBbuBlyMBj6tK4KNDbv3AxzRLxmwEd8HR0DdOtLT?=
 =?us-ascii?Q?NhYjQ7B8WRAwXQ6SXt2jKfN1COnwBqsVBJAMF3M4w10X+8qOcznbrj88/pfn?=
 =?us-ascii?Q?Ce8i/pIryAwvbkLzwCtM9k4fWrHQauC2rDFk99wQPBti3XuP6BNKnyciL9TW?=
 =?us-ascii?Q?YlMqjPZhJlDfe1i7LSucVJAz?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0abbda9d-8b6e-4e9e-f278-08d979dfed8f
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2021 13:34:52.2036
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xY0Qaj7Fpl00e4Vku2jwdOtpNN0mfaVYX6XJw/5hy6V//PtCqe1Wtzmo1q1X/5ve6GvdptufgyQN2+tzDGiV7w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7341
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

MDIO-attached devices might have interrupts and other things that might
need quiesced when we kexec into a new kernel. Things are even more
creepy when those interrupt lines are shared, and in that case it is
absolutely mandatory to disable all interrupt sources.

Moreover, MDIO devices might be DSA switches, and DSA needs its own
shutdown method to unlink from the DSA master, which is a new
requirement that appeared after commit 2f1e8ea726e9 ("net: dsa: link
interfaces with the DSA master to get rid of lockdep warnings").

So introduce a ->shutdown method in the MDIO device driver structure.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/phy/mdio_device.c | 11 +++++++++++
 include/linux/mdio.h          |  3 +++
 2 files changed, 14 insertions(+)

diff --git a/drivers/net/phy/mdio_device.c b/drivers/net/phy/mdio_device.c
index c94cb5382dc9..250742ffdfd9 100644
--- a/drivers/net/phy/mdio_device.c
+++ b/drivers/net/phy/mdio_device.c
@@ -179,6 +179,16 @@ static int mdio_remove(struct device *dev)
 	return 0;
 }
 
+static void mdio_shutdown(struct device *dev)
+{
+	struct mdio_device *mdiodev = to_mdio_device(dev);
+	struct device_driver *drv = mdiodev->dev.driver;
+	struct mdio_driver *mdiodrv = to_mdio_driver(drv);
+
+	if (mdiodrv->shutdown)
+		mdiodrv->shutdown(mdiodev);
+}
+
 /**
  * mdio_driver_register - register an mdio_driver with the MDIO layer
  * @drv: new mdio_driver to register
@@ -193,6 +203,7 @@ int mdio_driver_register(struct mdio_driver *drv)
 	mdiodrv->driver.bus = &mdio_bus_type;
 	mdiodrv->driver.probe = mdio_probe;
 	mdiodrv->driver.remove = mdio_remove;
+	mdiodrv->driver.shutdown = mdio_shutdown;
 
 	retval = driver_register(&mdiodrv->driver);
 	if (retval) {
diff --git a/include/linux/mdio.h b/include/linux/mdio.h
index ffb787d5ebde..5e6dc38f418e 100644
--- a/include/linux/mdio.h
+++ b/include/linux/mdio.h
@@ -80,6 +80,9 @@ struct mdio_driver {
 
 	/* Clears up any memory if needed */
 	void (*remove)(struct mdio_device *mdiodev);
+
+	/* Quiesces the device on system shutdown, turns off interrupts etc */
+	void (*shutdown)(struct mdio_device *mdiodev);
 };
 
 static inline struct mdio_driver *
-- 
2.25.1

