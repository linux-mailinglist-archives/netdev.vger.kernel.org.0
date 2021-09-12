Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE70A407D21
	for <lists+netdev@lfdr.de>; Sun, 12 Sep 2021 14:10:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235183AbhILMLE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Sep 2021 08:11:04 -0400
Received: from mail-db8eur05on2061.outbound.protection.outlook.com ([40.107.20.61]:24243
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234976AbhILMLB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 12 Sep 2021 08:11:01 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Sdz+Df/vaBRgtmh6WTdU2yTo00GZX/2Te9nW8dxhliHx62Y/PKBtQ7edLpQCzzCCunP63nwm+Am/GqHxi1mKYNI3Nq5LiumaxWodVYNdnjLL44pYSXFQUaByqRznu1I06CVGhvcrkeI42BxSJc/Q0j57mH9U2I/7v/CGmqBQzEnJMypphWY0rcOvBzqf6y4APfT5XHHjDsd7jGhCOpGi95voxqp9VEVXwaCCbtM6MVIkSErhKOfw0jxkA9IQQdsFfbY7DkztLm6wsFtneqnCCUI+ai/hskhtwnc4djmcx59bBljxZoVRa2X6YLPDB38cSKpiPVxw9RpfExHotDbeww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=J9ber5dIChVxmuivHBAPLqZNJn6AP/yxw/NPKphN9uI=;
 b=aN+SmYvgCeYHH2PWEIEGwt67M6SNeMlIxY2oOFYLwRlXBZ5w6G82txVor7ICxnhjbfT2NflWeOBFrxZXuwxpyche0mHuSe67x9wAuorxFxJkx1+gqnaJJK3M4mwwMqHoBBmIB7wrRVBqKMy8B9cvnoX+fRYYAnabhAkHjOeFkkWG4A8JlOmpduugJWfjR2WnqO1Ms+v2pxZkKorVODjvRzLlyrQ8q3xKQi690Q1v+QM/C44Mj00T/9pubUlu0w5WJKmJAxt0og3XuENL9R5hlNikm9qbrem2xkWY00yYnV7QNiP76g4R5SnD7MTvgvSw1F41FtIwTxzIhK9GYUSobw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J9ber5dIChVxmuivHBAPLqZNJn6AP/yxw/NPKphN9uI=;
 b=CeegYrrLTsJAeHNm+s0R1TeIdpDiNAO/uU4ul7m8k/Wg0B7cv+nbzw5TTVnCfe3zKj5CMy5N7e+uB9/zN4I1UqQNmDFjc2CxRDYKsXVqixww/L8uTI3XdlLDRRuZAA+apih/x3QMB0ldSgsaBZP+n4NJCvDFvYa1xDm5h1UKCms=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB5854.eurprd04.prod.outlook.com (2603:10a6:803:e2::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.19; Sun, 12 Sep
 2021 12:09:45 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4500.018; Sun, 12 Sep 2021
 12:09:45 +0000
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
Subject: [RFC PATCH net 1/5] net: mdio: introduce a shutdown method to mdio device drivers
Date:   Sun, 12 Sep 2021 15:09:28 +0300
Message-Id: <20210912120932.993440-2-vladimir.oltean@nxp.com>
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
Received: from localhost.localdomain (82.78.148.104) by VI1PR07CA0173.eurprd07.prod.outlook.com (2603:10a6:802:3e::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.9 via Frontend Transport; Sun, 12 Sep 2021 12:09:44 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9303c39e-643e-4cb8-403e-08d975e63585
X-MS-TrafficTypeDiagnostic: VI1PR04MB5854:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB58541EDE5161397D07A3E74FE0D89@VI1PR04MB5854.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1923;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: omcWlLe5pWmMRMbnXdusGRmIErC8aJwm4iNmpEDgLA2B5a4OqI3WcXOq//iHHmQBcjdQuZf/0BfF8kyN21tIlVUFOW6tXCC4ovxoPUYFr1edrnWOb32M7Sv2QCghyYz4O8OTAIY0mRFlJXKWdfEZRUwfggdlPBqNEswKcd8mHhDVZRwSJCjsKLfFn+y1UHZqE7NqT6Ag8E/pV/X7cUpUubKGKZGvcrGMd8RVKvROk9HZAcXlttTUsvJf/VOhwJJ1P+hHFf65t9dlVmi/3mtfn82Z0TUK8kZ07vhJPNXKzpHH43h+nYgeb9Rp0kRMs6cBsNU0XO3nplFne1MX/ek8iRbQ3icZ4tV3DsGzaZqaGhU5wFDjNNZ1MuvFsU/zwCOgfm49QAiw2V40V7BZ6GYgTPww8LvrwnzGLjtPqjEOKwJWlbwgmMcf3QjJHYtkL0by15AOKFzxcruGIqIgmoXrzwQGXsmTEsnhKyxLCwwASDP+EMuJAbbc1WYzKYWMW40QpdF2uw7TbtsOey1AnoJTgkswzvePspwaYQal/xYX5uqtpgZx+qIFIUL5mtvbWeXttL/D3UYlqHXLOk8m7TXr49pGy2DZfIZN+qqZXg0UAxE2QAMhd7Yt+PBoj6mXyApT897sG92zzsj/R1AFd6W6nSdlzrbHU7mBbWDwkbE+f8FLyiC+YL+czrrUTnl6K2yORrtkw/S7KwQ51c4ZbPxO7Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(346002)(136003)(376002)(39860400002)(316002)(83380400001)(4326008)(6506007)(86362001)(6512007)(26005)(44832011)(186003)(38100700002)(8936002)(5660300002)(478600001)(54906003)(2616005)(1076003)(7416002)(36756003)(6486002)(66946007)(2906002)(38350700002)(8676002)(6666004)(66476007)(66556008)(52116002)(6916009)(956004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8g9DSY4s0SQCpEU6gKR/WR5K+P4TqmoDHOVyUDOy9Mu7U2/Hv0FXI/5vsJn4?=
 =?us-ascii?Q?+A/ODNrR6uMNGevih16tqJVfgLwZef3gjmzTdCISNp6GPsgcrQKbV3KVVKdy?=
 =?us-ascii?Q?uZhKqn7E0taRV8qfIxfqR7VqDkmavdn1NOFnhFWV/N0YygzMxmvxFVKilEJe?=
 =?us-ascii?Q?ld1z6m6UfgxfpvbtCONNoZrzcMs6FhEOMMK670FHifmHeLr/XlIcW5O026Il?=
 =?us-ascii?Q?ZgoM2I+Ci6RGVoaKPoOx2O2fzH2JSTgZhzIF2+8Co4D2vBXljN4vYsxIMGAa?=
 =?us-ascii?Q?gGJUZYfCAN0oMRWs8SylOBhwKlGuXJkH31ZfaVxH9BqP35FVG3xlgIThGyXx?=
 =?us-ascii?Q?RSGjM0doeE/5O6NBkLq4wZXx4tSUCtqBMNs4cK1475FVwT0qyiOE5WcWA/hc?=
 =?us-ascii?Q?rAF/Fv4LcMw26kYCglrp15Sfxxv5Qc4kwnUnM0ccjHIMYBiUD9FlTiPeHdVQ?=
 =?us-ascii?Q?gVcDI+g010lD+dF1DmxNm3Bn5hNsB3PNtb310vNr3Q0i4afUVQfbTTJOTyOu?=
 =?us-ascii?Q?aCmKonPg04RzVCRrGT+o7ts9e02q4e+MigRoAM9nsDgdHXRXmRBtcKH/HLhK?=
 =?us-ascii?Q?9Bc5vRCD3UpOCkz/+/tAsmpLT++FyRwKml9U9hbgUQnfrHx+C++Q/bFHXFM6?=
 =?us-ascii?Q?py/ysYENRN35s3g1LQP5IKlrtsCS/PMnpCMewyPyhrUQIe0aZm5+/ZiYCbjl?=
 =?us-ascii?Q?4dYDL7wEy7K+eUQYSKsRABFuppfelU9103F6nVS754+nFcMIdTCGBkCJqZGt?=
 =?us-ascii?Q?U0u9BR64YcPr5/hJE2Aw6JPeP4WqcUDlPo0K7blF9sZCyGaf8FvAzKRc85JQ?=
 =?us-ascii?Q?FPqParkB2o35CEnvMIAIZVqb4KqoT6DdyrjaAjw/VkItpQrpu2G3uO9X4Z3a?=
 =?us-ascii?Q?ohfBfhknjSk+FGcJW8i1MIyKHRxP7u9qUbxqHQMGlBt5EIg1YTv05ARvaCVy?=
 =?us-ascii?Q?ILpg6GcU0hJjn1SUOXpOmeTPi6z+a5pVYOqaYgBjW8QDlbfFsQbJrnCwF3wh?=
 =?us-ascii?Q?JEJRlz/LLqELG3LqBy8E45h7qQT+1zHEE2+u5I6fkX3knGpUifkF/UTcZXz0?=
 =?us-ascii?Q?q7ioYq/4GvO1+OeO1bR6q/gF+gj7zqH7iqrjcdF+XauXiK+TNpLS3fdXRQ/P?=
 =?us-ascii?Q?2V/DplNObrhDGAGXmaI5SBY+P7elz6/0JtOlpUmVzDFeLkCpjZgi+1wD+q3v?=
 =?us-ascii?Q?HRpvpUmGlbybrlo2bChWoLhYvIfBYsoaYjLI/iqsFBwAgmlwXB5/NqzpjscP?=
 =?us-ascii?Q?kt0hbNDZvkFeDWMqQC1p793mZ/YL+I1ku31AYvUnL0yIZkxTq2uwtdtJySt/?=
 =?us-ascii?Q?LIbnRRoocA9GwQhqAiIjPeP/?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9303c39e-643e-4cb8-403e-08d975e63585
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2021 12:09:45.2407
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YW7GrZThmFvNKvugdjRZfFRqkrNHUIkxKs50SPgtEUE6y0QAOvg4NFeumPpMXkD2XLRly2qOazU4xO5wi77YuA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5854
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

