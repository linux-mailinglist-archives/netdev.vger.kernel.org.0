Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8868D40F968
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 15:37:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343749AbhIQNiZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 09:38:25 -0400
Received: from mail-eopbgr40066.outbound.protection.outlook.com ([40.107.4.66]:6786
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1344445AbhIQNhj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Sep 2021 09:37:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TK4ZT7Nt780/507g//ZhDN+UDdOhxFibC48Vo/hdoRfxRBzvz+zd4f2l+1P6VQCK9q+y+YmwjXLAoUx7ip8FAmKq6ayeCq92ekR08EQJB8a2z8WoilD6xjlorDV9gWZ38FoU2aN0QMZFxTvS+51zVQ4MkjVvdmFQgN+nHNEsqlHTGzDY9iLQHyQpzA9s3CcoEeBF7QovX6+hEk6GK0A2kcAqxXuh+jNDpZ1JClicx+SRTP08wibRuCzqKFqJxauWkdXc4zsyjDAmy746yCt7RZ+0RGUw0m1/QoNIk1GTFVrA1O2Isda1I+yhC/V9oHClNyptzujdSWqlZC0SOujvdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=KUsXF4aAI4TDGevyXhOb/9ck9+IxxSImt8GLo8qzPFU=;
 b=ZRwVU51jVoxDbv9EIi9FXtiuVk3qqyzBFA3nM6MXatkOK2YjCCeG+9osx+zCJnPnHoi4rQ+m7fJ2qo9MTQJxnFoYHjo9MNIYGOB74lwj6hH5dG5zTUOICAas4XmWhOtCShkFH4WS9ZOccSEFP5+D/m7tRGIMMMKqjVJzP0eO6y4FnARZqkp5UI5nP3bdEMb9+1TxT3FI8Rr7VrfJj2zLg81pplyZQLtedGadtteML61wuH/sQYOZuvWaPSCSB9Lr0re+FTGfzRPwLVUSChRI2BY+AXn5ybwpFOZzWTGxtHk5oNvRXvkx7hHHB3Wioq+BHiQ1ritDdvlBja/rxzRa3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KUsXF4aAI4TDGevyXhOb/9ck9+IxxSImt8GLo8qzPFU=;
 b=jgfw8TvI1Tr4QoVSoRMslLVGhPFGTAgeJC4onu7t58RKksXMX2TuHSZtYtFA7Bwclzt5fav9GkDsx4G7nZt+1+FMb6OzpLM0R+Tl+6Jh0KuLI3PYAykR2WQnFTr+S/UG716XU8+tEW/hXrJo8hQH3XR9XQBF0UE2Snu/cH0oa4k=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB7341.eurprd04.prod.outlook.com (2603:10a6:800:1a6::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.16; Fri, 17 Sep
 2021 13:35:01 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4500.019; Fri, 17 Sep 2021
 13:35:01 +0000
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
Subject: [PATCH v2 net 5/5] net: dsa: xrs700x: be compatible with masters which unregister on shutdown
Date:   Fri, 17 Sep 2021 16:34:36 +0300
Message-Id: <20210917133436.553995-6-vladimir.oltean@nxp.com>
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
Received: from localhost.localdomain (82.78.148.104) by AM0PR02CA0199.eurprd02.prod.outlook.com (2603:10a6:20b:28f::6) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14 via Frontend Transport; Fri, 17 Sep 2021 13:34:59 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 30c6e4d6-6b99-4b7b-15f3-08d979dff34a
X-MS-TrafficTypeDiagnostic: VE1PR04MB7341:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VE1PR04MB73413D5651A171D96F5A4D3BE0DD9@VE1PR04MB7341.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lE/Z9/49hIbN0mx0NfXjvN0ux7DUmxSYJ0YY/FJ12u7FH/PNgSi7+M0o9dd+YjLGIwZV9MUAeIrm+UPC49/dzE9NX6LZ/cAT5BgbN8i4/+Ak3t0L/UW4HAVDD+Nz+v5gDAAk2C/96fZB9WeH/kIA+DD89pr9QyFs9Jb/4iZHQvTXE40avbQ3vkvC7GL6kzmvXJQ2v2AadVoMhQHY5Qj+58E49ZANGYa93pEgGn2g2IZKvEqLkgExXAKfVeKYA5eqraJi8Rvu2+Y1Jq9M4MFDSdIXl599aCHA4fOxsxNwx8g00UeoQ0OB9QXTGQ/0nwuHxDCNGbnbzrXrBrzxmNu4nVwoZhKhS65wBC40RLaslZ0gS3LshjxmbVT+1y/UxZQu9sa/hItmdjO4jDf3BBBa//flBam5+0OeGF0xTSAG2AorDgZpe1bjr6GF/xoqliYq5qBWkp0Kxd2CLobiiZKmmYZELy98HRWqL4mSszI8Ck07EretsoUewBUuMxR6nTNiuqNU9HNqW4pmmWXoBUZfRAlRys1EiYcayIpl63jSoozvb65ctAMRmQz5oL0xUhUfRec9N5HdZLUOynTVGBNEI1ancuUpqHtTEwvKGaoerRJtTX/s87xUrNE2mRkolcYD+eqRU1EyrCJ7BglYJ0YIAgIvaIq/QNq1YQAIaVgFHH83b1f/SDXWswyNbjCLwEg5+ijSC9xRdG59tC6GTU9Tgo3LIDvo05DsSdWgrJJwtKZUR3o1WfFIj32+F38/BtkW1GCepvMxwq8EhNyQqLmo7/s5QzvhXYYIAaPRAt2m9bs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(376002)(136003)(39860400002)(346002)(54906003)(316002)(38100700002)(38350700002)(36756003)(44832011)(2616005)(86362001)(6916009)(66556008)(478600001)(6512007)(6666004)(966005)(6486002)(8936002)(8676002)(26005)(1076003)(5660300002)(6506007)(52116002)(186003)(83380400001)(2906002)(4326008)(7416002)(66946007)(66476007)(956004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3V5Q+b3BCOAgRv2BboP3hir75wPRfp/3iwZkdUpafDtd7HtOUPaupY4a5sFI?=
 =?us-ascii?Q?vuX9uPhYSTqDjVl0mFwMFuRG5NfHlgF6FpW3z6qQjS2L0t0mVu8h4EtsVMSK?=
 =?us-ascii?Q?dok6pTmh+g4JsfX/eUlOtMjV+zqVtzsdB+TAdfH000IhZo3IkPoZENbs8c8Z?=
 =?us-ascii?Q?6Nl4+LhiUtsrtuUO92pRMqicdkhG+cgN1W/Lv5CJCJAEXBSLJ6JtRHWENCDA?=
 =?us-ascii?Q?teG2VNuFZrxB+teGLEs3IzMNeoFq4XFJyDTKAl2sW6BGnl27Waav6zOkyB6I?=
 =?us-ascii?Q?FXolC7sqmmENvbuI+JyzQedMa54NosHJLWy+JBt0lKEBBH7m/jTi/jDICedM?=
 =?us-ascii?Q?3GG0XNKV2dIt5pa145qvd0W5JmZH9GSvAizErgyduznglxNBA3gZKyggS5NI?=
 =?us-ascii?Q?Waxt+ihg2X7/v+LbXBfrPxuyNsrWGhk5oWZokJRFPonF8ieUTTErLSrbTr/b?=
 =?us-ascii?Q?yJB86i0BnZBUU8GoOWbyVFbaZLRjHsZS4mDxldFV8y2b2cJu8sw/Jow0Sai+?=
 =?us-ascii?Q?F2kv5t+Q7WvS4e4v8VqQAP9M1iMlzhUgT34dL8/6Wg54O8Uu2QmuX7vpOl4Z?=
 =?us-ascii?Q?qNMZT1Ouut+9aAXaB+Xb78BxFcFstJiU4sUzmhBfQElr9rNlTDNpYl3u1+QX?=
 =?us-ascii?Q?q2cel/UKsfND9U8vRe1lBmteQkLIfHcixIAoQaDRlGMozNOK/QuEXOklRaoa?=
 =?us-ascii?Q?EQNFMmEspavmZRGPbeBt6Jdtf/OCTNeQdJd3Bra6rrW4o8BIH4mf0eH0d0zM?=
 =?us-ascii?Q?fYnHWIBNAHptOfzmbF9tszkhfFwzTJT9nKhiRrBuVAKm1Ruy+1SLl9DCDpuo?=
 =?us-ascii?Q?ZFZkw97FTvVqqUyfmBNcxRTi0b/fiZkNsjbT1F4Le2c4wcJsjoIaNljlmqvM?=
 =?us-ascii?Q?j/Siu3/1CFVZK/q78fFDugAuxMkqECaAXoHW8wDBXbpYQk5IN0woczEFE2LH?=
 =?us-ascii?Q?DIft902WIW0xBJT4JeQTtxCU2/4b5e3oyn31b4ozpb1R/dM+qEIzDEJNLD3N?=
 =?us-ascii?Q?QwrdMfnWykz7HvdW8vRRvEAyTk3vC4KsAjvWL+LHGrMZg1uIv/xqbRheBt53?=
 =?us-ascii?Q?tiNvZdfLDusXNg6idZSoSWUF5DGjH6vjJcpoZuvlX4eRR7lE9i6eBiHmWa1g?=
 =?us-ascii?Q?EsPgSuG8HiSmdD1gaQemp4vdOQx22Z8envBHF58f7+I2A75Etc7IxuQP/bJW?=
 =?us-ascii?Q?envQ818R+3688UH+Af5QW20VAUyERcSbGRQDD1T0hk9tnB0cHWZVwS5dZQrf?=
 =?us-ascii?Q?ellrSZF3vCl/DStmd3rZIw7wqWy8ledCdzDy41ItW5Z+PIzu6jNmnDSMdPHy?=
 =?us-ascii?Q?5FPvUvX14L6PWPlrYwm4oU1d?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 30c6e4d6-6b99-4b7b-15f3-08d979dff34a
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2021 13:35:01.7961
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MlL8Oo49UjrIJ3IOd4BdtG4Vd8q2g0MVBqxadFErEtVRqsdFhMQlFYovFky5MtJ/CH+osTZ9+7V5Yh2YDJBsfg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7341
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since commit 2f1e8ea726e9 ("net: dsa: link interfaces with the DSA
master to get rid of lockdep warnings"), DSA gained a requirement which
it did not fulfill, which is to unlink itself from the DSA master at
shutdown time.

Since the Arrow SpeedChips XRS700x driver was introduced after the bad
commit, it has never worked with DSA masters which decide to unregister
their net_device on shutdown, effectively hanging the reboot process.
To fix that, we need to call dsa_switch_shutdown.

These devices can be connected by I2C or by MDIO, and if I search for
I2C or MDIO bus drivers that implement their ->shutdown by redirecting
it to ->remove I don't see any, however this does not mean it would not
be possible. To be compatible with that pattern, it is necessary to
implement an "if this then not that" scheme, to avoid ->remove and
->shutdown from being called both for the same struct device.

Fixes: ee00b24f32eb ("net: dsa: add Arrow SpeedChips XRS700x driver")
Link: https://lore.kernel.org/netdev/20210909095324.12978-1-LinoSanfilippo@gmx.de/
Reported-by: Lino Sanfilippo <LinoSanfilippo@gmx.de>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: George McCollister <george.mccollister@gmail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/dsa/xrs700x/xrs700x.c      |  6 ++++++
 drivers/net/dsa/xrs700x/xrs700x.h      |  1 +
 drivers/net/dsa/xrs700x/xrs700x_i2c.c  | 18 ++++++++++++++++++
 drivers/net/dsa/xrs700x/xrs700x_mdio.c | 18 ++++++++++++++++++
 4 files changed, 43 insertions(+)

diff --git a/drivers/net/dsa/xrs700x/xrs700x.c b/drivers/net/dsa/xrs700x/xrs700x.c
index 130abb0f1438..469420941054 100644
--- a/drivers/net/dsa/xrs700x/xrs700x.c
+++ b/drivers/net/dsa/xrs700x/xrs700x.c
@@ -822,6 +822,12 @@ void xrs700x_switch_remove(struct xrs700x *priv)
 }
 EXPORT_SYMBOL(xrs700x_switch_remove);
 
+void xrs700x_switch_shutdown(struct xrs700x *priv)
+{
+	dsa_switch_shutdown(priv->ds);
+}
+EXPORT_SYMBOL(xrs700x_switch_shutdown);
+
 MODULE_AUTHOR("George McCollister <george.mccollister@gmail.com>");
 MODULE_DESCRIPTION("Arrow SpeedChips XRS700x DSA driver");
 MODULE_LICENSE("GPL v2");
diff --git a/drivers/net/dsa/xrs700x/xrs700x.h b/drivers/net/dsa/xrs700x/xrs700x.h
index ff62cf61b091..4d58257471d2 100644
--- a/drivers/net/dsa/xrs700x/xrs700x.h
+++ b/drivers/net/dsa/xrs700x/xrs700x.h
@@ -40,3 +40,4 @@ struct xrs700x {
 struct xrs700x *xrs700x_switch_alloc(struct device *base, void *devpriv);
 int xrs700x_switch_register(struct xrs700x *priv);
 void xrs700x_switch_remove(struct xrs700x *priv);
+void xrs700x_switch_shutdown(struct xrs700x *priv);
diff --git a/drivers/net/dsa/xrs700x/xrs700x_i2c.c b/drivers/net/dsa/xrs700x/xrs700x_i2c.c
index 489d9385b4f0..6deae388a0d6 100644
--- a/drivers/net/dsa/xrs700x/xrs700x_i2c.c
+++ b/drivers/net/dsa/xrs700x/xrs700x_i2c.c
@@ -109,11 +109,28 @@ static int xrs700x_i2c_remove(struct i2c_client *i2c)
 {
 	struct xrs700x *priv = i2c_get_clientdata(i2c);
 
+	if (!priv)
+		return 0;
+
 	xrs700x_switch_remove(priv);
 
+	i2c_set_clientdata(i2c, NULL);
+
 	return 0;
 }
 
+static void xrs700x_i2c_shutdown(struct i2c_client *i2c)
+{
+	struct xrs700x *priv = i2c_get_clientdata(i2c);
+
+	if (!priv)
+		return;
+
+	xrs700x_switch_shutdown(priv);
+
+	i2c_set_clientdata(i2c, NULL);
+}
+
 static const struct i2c_device_id xrs700x_i2c_id[] = {
 	{ "xrs700x-switch", 0 },
 	{},
@@ -137,6 +154,7 @@ static struct i2c_driver xrs700x_i2c_driver = {
 	},
 	.probe	= xrs700x_i2c_probe,
 	.remove	= xrs700x_i2c_remove,
+	.shutdown = xrs700x_i2c_shutdown,
 	.id_table = xrs700x_i2c_id,
 };
 
diff --git a/drivers/net/dsa/xrs700x/xrs700x_mdio.c b/drivers/net/dsa/xrs700x/xrs700x_mdio.c
index 44f58bee04a4..d01cf1073d49 100644
--- a/drivers/net/dsa/xrs700x/xrs700x_mdio.c
+++ b/drivers/net/dsa/xrs700x/xrs700x_mdio.c
@@ -136,7 +136,24 @@ static void xrs700x_mdio_remove(struct mdio_device *mdiodev)
 {
 	struct xrs700x *priv = dev_get_drvdata(&mdiodev->dev);
 
+	if (!priv)
+		return;
+
 	xrs700x_switch_remove(priv);
+
+	dev_set_drvdata(&mdiodev->dev, NULL);
+}
+
+static void xrs700x_mdio_shutdown(struct mdio_device *mdiodev)
+{
+	struct xrs700x *priv = dev_get_drvdata(&mdiodev->dev);
+
+	if (!priv)
+		return;
+
+	xrs700x_switch_shutdown(priv);
+
+	dev_set_drvdata(&mdiodev->dev, NULL);
 }
 
 static const struct of_device_id __maybe_unused xrs700x_mdio_dt_ids[] = {
@@ -155,6 +172,7 @@ static struct mdio_driver xrs700x_mdio_driver = {
 	},
 	.probe	= xrs700x_mdio_probe,
 	.remove	= xrs700x_mdio_remove,
+	.shutdown = xrs700x_mdio_shutdown,
 };
 
 mdio_module_driver(xrs700x_mdio_driver);
-- 
2.25.1

