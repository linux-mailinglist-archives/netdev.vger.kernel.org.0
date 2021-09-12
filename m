Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE768407D29
	for <lists+netdev@lfdr.de>; Sun, 12 Sep 2021 14:10:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235257AbhILMLS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Sep 2021 08:11:18 -0400
Received: from mail-eopbgr40056.outbound.protection.outlook.com ([40.107.4.56]:7737
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235286AbhILMLJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 12 Sep 2021 08:11:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BK6gC/+D4KSnhO7Vs9JVDQoclYaAGo25f6NUe7QbtWRXGrTKW/BWfqXWFgUHFiGD8ngGTNbQ9i32ULdioRRzkpAKXBoc2gsMNx4jJf6LLpB0RYmx6A9pJr++oH9p1cKZBDFTUuExXQL25agT4lnkmtGk2Lk+gJDOC76V8UZnFoDLf7xFUA7ga9FzGat5aRsu1+RE/1P1aHGiRmknxpBt9h4n+f7D/Dxa5bWOR8MyiNUI+47PRQ7KAe814Q06iDgdBEa8k/9rS/rxKSgbgYzyZ339BchIVJiozejrnHelF4BNv2JrySqr+5Rj9MeaAgrcGw6x1i9MhXIYavYzpZBAYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=P9pZMiXGVwO5diOksH6Sir5aScxYFqE8gQAMhW0kJwg=;
 b=nOo6BIF+CGyk1bQgt6vK7NFh6uumWb4K72PUz5X1+3vIMmwZlHnMzwZ83t3OgpcEtUv2aBvi/jd+FdP9Yfarad0x9weHQqxbE+8GxQBzr6xe4rGWnP8cjTVepmG394M8efhWR5DJFCqWp0O+h53gtjJJ8yAQ0Q6XXYVy/9ovCrWpxgkgbU5AoOuEKC04tWh0pTR9pJ5HHLccLx/KM8UVEIMKVzb7zAxnadAIllu6VaxpkfPc5JlXh+RSK4NdAaMoKCOKegmWb7dHGTh1nvb6W39ThSSSxwbnM8ZlzTe1SHnr0lYhiaTGQBs3dphahwKAldUvLXuXdyWwHp4y8KeftA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P9pZMiXGVwO5diOksH6Sir5aScxYFqE8gQAMhW0kJwg=;
 b=HU2MX75Y/m2SipnF5InYeAamO8wfhbRi6oe/ItvIX/moBGFDlEECZ0YQPe4pjPUn8ANdYihToEyQjUhmJ1uZlKMBxzvfjdxclp0VjNnimuao5Xl2/Ts+P0bGaBpgnEHc4sxgy6pQ/V0Et/GCsEr87qCsvW+ntVYT9b5pnWWg/FQ=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB5854.eurprd04.prod.outlook.com (2603:10a6:803:e2::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.19; Sun, 12 Sep
 2021 12:09:52 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4500.018; Sun, 12 Sep 2021
 12:09:52 +0000
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
Subject: [RFC PATCH net 5/5] net: dsa: xrs700x: be compatible with masters which unregister on shutdown
Date:   Sun, 12 Sep 2021 15:09:32 +0300
Message-Id: <20210912120932.993440-6-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210912120932.993440-1-vladimir.oltean@nxp.com>
References: <20210912120932.993440-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR07CA0173.eurprd07.prod.outlook.com
 (2603:10a6:802:3e::21) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (82.78.148.104) by VI1PR07CA0173.eurprd07.prod.outlook.com (2603:10a6:802:3e::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.9 via Frontend Transport; Sun, 12 Sep 2021 12:09:49 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b6b2ecc0-6a1f-4b0d-0702-08d975e63872
X-MS-TrafficTypeDiagnostic: VI1PR04MB5854:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB5854EE518F940E86DC2CC758E0D89@VI1PR04MB5854.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2tEDzOUQ8D2AlvHId4iUbbDI8wtXg9seMJLgJADyf+aUFyWlFN4p5YUvreSVWFiUsldYJCTDYeSaCzh8Q+C5NDU3NSaw5V63KMPHlXn8LQtRRPWlCTz1LAnbYIKLEXNraHs2TlQ3xvtkp9ShF5IFtDivodetoSf1Ya+EMp1ul2O330BA/ZDRuZCuYWk79pT6aZes2Kls7wwognROmeMsd90vqeu8RN9OmMk931BXfMT1DtkdktrasXIalsl477iP5qsip8Xs0ZGhR2hCfzYaKXLs825Qg0RnzyiUWQZ6bR7JwvWfqJPupiu9cH4rYUSxYke0Gf4DdCd5O2lfiZxxTn7lkAUF0zkOFOaNDaRMkEWF0Frg2bq5WTufNwqkdu0DXXr6KRaYd1Q7o7Mc0vft27uqfmgpgwXJdVGK/4K5CJGS78retkO38IdGcxkgwcNn8jFWTEnxs+puHGDWTk1kGsT8lAdtvYqucyNKe+whWPg7VuklEhwVTPN+OJ28vwnqBNQ087tmFE59WFZhW8hp+d4Xhtqa+SiWk86Cn2SBDfpMyrkiNYfmVgAYp6j9lJ8yKtuZcNtRlkmDGWeL9LXowJXoArLnAEy+UCGS0BKo3ZZdggtw2V73MvLuW+n+pUe0lG5L6CjL/VEHPxjzmahno7CE9bw9WvkeOBZ/LHHLMZ/6SNiyZ05nBi7+gXY1oiwl7z0EhLNrfjfKkUuj1CrK96SeAoe2QwkM5wFCQq2SdO2tNtWF9DQceOmU+S5nCvsSABusByIW4am/Az4CcPrboocXoyiuYi4S8y0cL+InZ+Q=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(346002)(136003)(376002)(39860400002)(966005)(316002)(83380400001)(4326008)(6506007)(86362001)(6512007)(26005)(44832011)(186003)(38100700002)(8936002)(5660300002)(478600001)(54906003)(2616005)(1076003)(7416002)(36756003)(6486002)(66946007)(2906002)(38350700002)(8676002)(6666004)(66476007)(66556008)(52116002)(6916009)(956004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?JaqXoF1/ZGN4xofkkJp9Nrpc6tyfk+t9zgwv0tetzXXERR9QbFJI/wgVByCQ?=
 =?us-ascii?Q?lJiIWxuoMR9SGMOIL6iLtjBIft9V2pTzJxbwhQoENYthPYMTYrk+WKIb1W/V?=
 =?us-ascii?Q?bM1vs2vcKqmV9WtNK4+brmY1yc20udP4FoE4UEWfRWx9fmbr97TrD2r7DWy1?=
 =?us-ascii?Q?boY7cpwJ9PPbz1vqVS0jDmw0njQAGg3Dhwv8SJudOVzz8G8DVdJJi/4DfHg0?=
 =?us-ascii?Q?7z1QnTDHYCr1PL7BHUrxjCYWJmvm1/+3Bdms6LT1kT+sDRMxfiT8Xc1v1u6z?=
 =?us-ascii?Q?YylO8am/4yZ2xYRqLMLud+tE//T87owc0sImfh5ewp81dKTBmaYrkwFtpg/D?=
 =?us-ascii?Q?pS4p+gXqQpStfpFckZqsB1RS5I1l8YsoRUnbMw3yxhhH11aLErI32WpYLB25?=
 =?us-ascii?Q?O6uJ2CdM9tDOZfnv8iStGodIciemQ3A9Uyrh8PS98sEquthoruN+1l4tjcyZ?=
 =?us-ascii?Q?8Atmu/8qolF9v1ORvHUScfBPPllolKe8GiNsFAnRpX/xoEhMG7k/8hdWJlxP?=
 =?us-ascii?Q?qzNtrdIEGD/5X0L5L4NeDjlEO9xIc7XdqB3pmv4kRHudDhB81NJrba3UuukZ?=
 =?us-ascii?Q?BneFaSA/h77WhxAzPYkLbzMX9NpgJ8wMjg6aVYSrA8rn0stSfWvClWgMIsV9?=
 =?us-ascii?Q?cJUf0C7QHh7u6yjhG+tOwVkcj9LNscjzzCkGpy6dtlMaxda+D5JTMYW5F2OX?=
 =?us-ascii?Q?PhPGrm1YxvNhK2J3ACQO8aBgSdsZk+itROEfPaf4zf/nDNX23YWfvU99Aifh?=
 =?us-ascii?Q?HetgvRb/HjxYWSeduq/dPGlF/BhWNKqeLmcQnFk3gq8lS6g068qHqSLvUTkb?=
 =?us-ascii?Q?fFoEO3JwKHq6IU3sFHBjr8iiIOSXJgpDmrDJWOaDYdICzZKySGqXB6GBha1X?=
 =?us-ascii?Q?WRlBEuAh3lX+FsvAQXZFPK8NNDFrHNB2XYviR7IqU2GaBYVZiTi6GESqi2/a?=
 =?us-ascii?Q?uHJxIK+nFr9o1GZsTjfg3CJ1Vigzu8YigktsDHC/VnoAo+zzP9kZyet4saIu?=
 =?us-ascii?Q?TpUmbbC38ftQOJyzOzxQPjQbpdv68Pt8ygXz8QosA7MEDLAz0KbkPT+bKNjA?=
 =?us-ascii?Q?fB0Jpy2PPFpENfEo7+yQN7lAUTDbc86h4YwEjRcl6wl5ZsI+fZoWRyfK8Eds?=
 =?us-ascii?Q?7XH4VF3c+igWRpWy6sbmzCk0CjS81xnEPkPzYFZOEiGLQ81b8BOdAZbdEPS2?=
 =?us-ascii?Q?MbVNCOjo2K5tzpRVXv4tX5A3t1xhF0NHrJkZxYHN90ubZyePFkYe3zLfpY8I?=
 =?us-ascii?Q?s0vfb0c7I27Whk73o97Wpf5FKmpKZgaY9IjSNvIF+TvyQ12vVd1Sc05BaE+7?=
 =?us-ascii?Q?d27ScL6q1BI327zf0PVNc49t?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b6b2ecc0-6a1f-4b0d-0702-08d975e63872
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2021 12:09:50.1259
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +o89nBIPtxDeRwtT7XwbKAsBsAs9zQo9k4eF8e4g+7VQHMDefgaa69cxoXUmWTKgREXK4CSsvIPq2FUlcnwQvg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5854
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

