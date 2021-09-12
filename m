Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82AEC407D25
	for <lists+netdev@lfdr.de>; Sun, 12 Sep 2021 14:10:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235361AbhILMLL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Sep 2021 08:11:11 -0400
Received: from mail-db8eur05on2061.outbound.protection.outlook.com ([40.107.20.61]:24243
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235168AbhILMLE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 12 Sep 2021 08:11:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jfl+UurBpAGbc758dO5Y5klfBqT7wAwclxUcie5xbd6Z6Lzz/FZQAtUIrpzDQgDMqe9yOxzNi1AQiIEPshGe04crWsNGgWcJH69QBXLvj4oI9VjW/X10aq7N0FzLcUHDVpFllyQG2Hqlol664xcQ2Noe8G75s3qVKUG+HFtOPkw9LhLLftWXgI/XYHqABHvGiPc49yS03wCZ13WNWzhAsXLdIv9JcRIliDnTUs2hs6jLfpH+XVGenCLUNAoWsD60X/JSqtahqsPu2wj+0iio3k/wRP2nJbZO8XUfjsWgqbopQAzpbOUL+qakvyVtavLI5qHEs8UfxzfHWozF3KL84w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=koFKcRjGvX0cSv9q2ljRuQWJtgMyMg42Ynk9ZcVTeSk=;
 b=eN8u9h8jUx67bRIiA38VjIh3LasK3Owfiayzcjx4KGD9mh7e0E3s6vQiKAtH7D9zmQS3MIRnNi7G/slj11sbPKXHHkvs8Ymm4YjLvulKhK/mMg6skvrGwIxjc1RawNKqn0oDsbhxBrPVWMFQgGNSEqdH4rtyKMHEWJ3wOfROxZPjMgdfrW/7A0h40VaxNYmt4l7xdQe7a2xAswz3qEus0phSma5XoZdvt8Uju5JnrQOjO/oCIit4qBmfhHVeaGT0YT3rV20rqh3CWDweIsvti/Be4wbvhHEFO5zdUrJuOSdIu5+9Z8+CC7EYw0UEa+JwCoaYPGVDXKPVe4eF7dF6Qg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=koFKcRjGvX0cSv9q2ljRuQWJtgMyMg42Ynk9ZcVTeSk=;
 b=WCgw+uTDsV/dh7ok2LVQHySLwGIJIP84U6C66DA9K/3zbKAiWpWfM5ciM7tRxhugoUFsly4SWe/8ToKrE9HBGJ/8fRUr13XGRfPbmblr9tKH0JmTI5FXe8tzxy+UtZ5f4evrAUjWI7yqwYVlaMgt+HpN6+AnRmyTGqj0dwjKzLc=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB5854.eurprd04.prod.outlook.com (2603:10a6:803:e2::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.19; Sun, 12 Sep
 2021 12:09:47 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4500.018; Sun, 12 Sep 2021
 12:09:47 +0000
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
Subject: [RFC PATCH net 3/5] net: dsa: hellcreek: be compatible with masters which unregister on shutdown
Date:   Sun, 12 Sep 2021 15:09:30 +0300
Message-Id: <20210912120932.993440-4-vladimir.oltean@nxp.com>
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
Received: from localhost.localdomain (82.78.148.104) by VI1PR07CA0173.eurprd07.prod.outlook.com (2603:10a6:802:3e::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.9 via Frontend Transport; Sun, 12 Sep 2021 12:09:46 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 11e973ba-206a-4a92-9635-08d975e63701
X-MS-TrafficTypeDiagnostic: VI1PR04MB5854:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB5854321B306E5030BDB9E9E5E0D89@VI1PR04MB5854.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2657;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NFV2LbvPlTLCDuPLCIQ7F5rMr47Z0ewUwqgZVJnUyBuc6ZoCdFXRVm8k3m3vlApuDkXtjOO8Jqqf6wqkh4LZdVi0ugVm5OK0+pm484BPSyjZUxVAwiNCByAhcKmma54ixqp6TDd4UqgDUKVi3vjsxYRTTbP9Gc49iQFTnHZaSLwtH9xX8PFMzYYwPdMzjznKCwr7DYFz5Hhktpwgj5lYt0uuxD30IAym+2PodnGY77XIrQ0XrJ3vMegr/gKA50hwZDNuUr9mnMKYmMj3Dmy0ohhGkPMYvCfcb+CHyEacQtvzTa++ppnqclHHHaQXq0qQckCIQ1/E4eL6SfeDQuqMIsq57yaC+rPXgxCsrcYFIGpM2/SQdeajklqFNZM+EYcFcmZKyJLRJnyL1OJOyz50nyvlaMhLYjFHl1VuUggtIb+3zqkw1YafFrP6/35kBWkukAsp0g8S65ClGQYDB5IueNSMsnAmZNqK4X1Z09hsZnmIC27LsZk6BMliuHD1iDowtCtaTiHwIF0wJ1mpDwVJ7fv4+LPs7h3qCxadHb5Mi6j3YhZqoioowjT7Y4q0Pg0ZDZKD1ZrJ+Jq9Vtk3XNd98C9xLycN0yu8g/WxhY45MFqz/acQf/OitPSmBCztwr2eBpM9hLeB5j7oUVxxpk7N3+E9LIptBL6si/e4WNyG8cytqp165M7bv4v9pu/OD0AT6sRXMqNar+O+xKhQuyA3ve9c3cOsSbpr6NBW7MXe7jTCaBBk6/44HKAg8gkNxr+XptbuaJdoVhsF25fir5BmgFWMdutgFx+Bn7r0AumsHzY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(346002)(136003)(376002)(39860400002)(966005)(316002)(83380400001)(4326008)(6506007)(86362001)(6512007)(26005)(44832011)(186003)(38100700002)(8936002)(5660300002)(478600001)(54906003)(2616005)(1076003)(7416002)(36756003)(6486002)(66946007)(2906002)(38350700002)(8676002)(6666004)(66476007)(66556008)(52116002)(6916009)(956004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?smysIpeTXk6+wAxMCAe2bmb4qV6LWhxoUxb3gGaaj3/WhONIaaa6M+f7zQfz?=
 =?us-ascii?Q?2qU9oGv086GBa8t2J1QTBPgMDTxUrW9hbsoOLdsTITOHLFbR0Z7U1pcKsSi1?=
 =?us-ascii?Q?foReTrETR1zAbxGjVDMFueFLm2pZiTyJGniToHtIA9AqF1gGGY+NCXeotc4l?=
 =?us-ascii?Q?52Ci0/t5XJm1CXqKWWjO6Pe5P1XXXWpsb/2XZynBghtbO/Sg8p+0NuQG1E7x?=
 =?us-ascii?Q?stTK0b3QKQWKzEsffTrEdzfiFLbWL0mNUjvgMVoHOkqk7MQHLDRPQJKXNi9s?=
 =?us-ascii?Q?cCLjCc7V9IOZ0VYDG5fKp5xi7bJxRRf3XkpsIDcwQPI+1Enat+C7Uq2uNUIo?=
 =?us-ascii?Q?xiP8U0ysZ07JbXL48DJXqqfjFykJB9GsINMM3ZRJwaeN4lOxmgD0UhG3B/Lc?=
 =?us-ascii?Q?xy84YE9Egp6hurmR6nsSo48WDFBjumeoP6m1bHyf3sc8c4KI4ntncYiYQhIF?=
 =?us-ascii?Q?S1002H2OWnyJk0RqpnAGpdV8VtAj0AYmV15sUbrByFYm3tCw8t7/Z6XtKnTc?=
 =?us-ascii?Q?MeSt8ZlnaVlBhe5ZeYrnq5CYXgCrfYukZAB6lIpWj6IXGeFW15THF9OxBBk+?=
 =?us-ascii?Q?KbA/nzpxcp1XIfFA+/q6cu5Tn1tZV4mB+We0YJ8rnkQMwsccU+v0EUwtFm4z?=
 =?us-ascii?Q?uJptOlMiqkM5T6QiKAc1FEM4Lm5a725bjE9ISo0ta85cCJiaJUcmT5VEnBfD?=
 =?us-ascii?Q?KkdWICt7QEMAzxXw04eXJrHbRWCoxLvnpA3WT/H0aY0lBj+3OZYCp62EEVps?=
 =?us-ascii?Q?1TMRfhH83nx2WrNuwgZlHEw5Bi0ZY2vDMzbd77bYBQ3eJH5wMUn2EYajPcQs?=
 =?us-ascii?Q?rhqqAMi7hOem4XbSYo4l6HwVPJLBXJC4GlTG/rSo1wezLaBgcacQebp0jZ2P?=
 =?us-ascii?Q?6dNDk/LJF4KN/+LtEHuPRoXFN8NO4xP+5T/NI7tmaTraI0lJ1cHRrk46NATX?=
 =?us-ascii?Q?xjX5CdiXNQx0Y0KVvaC9n0RuDoSxT+bsCCJXZdPfJZ13bRRZEZB6tiosenR1?=
 =?us-ascii?Q?6ia9BuaY6803L1+oEfeesKCnkcI4yiO/2uCcnL6FtmWUgnnaDf6DKoVOJYHs?=
 =?us-ascii?Q?L3XlvkZ8CHzy7UCyTZGdyleAaCTfKAMq7nb3hOQ66LPKW1rFWvU/E7rxzosM?=
 =?us-ascii?Q?qWLPG6w1HHDvYoILziP997vy1Xl8SzC2F8J9QN6orM9PLvieVm0HUMbGQw2N?=
 =?us-ascii?Q?dTy9BzcPPRqSHiNW4mLn1v79zuY/gRx7s3sHrlgHQWAVzjafc7L46IRHFiRc?=
 =?us-ascii?Q?QutSbSQTzs50bi2bySk2C1+iyNju4TsXgLwnovbkSDcUsGG0PxeIBTNShTP8?=
 =?us-ascii?Q?CkfIv+c1Su1Vu6LhKjtboCnm?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 11e973ba-206a-4a92-9635-08d975e63701
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2021 12:09:47.7203
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IUWwvXV5L1rP4P7ktgMCy7mLwtnqSei+gbCWq3xqoCsdyg680qy9Yh6AbRRCwMdAcQjI8ff7kzyqrMAYXDPSuw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5854
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since commit 2f1e8ea726e9 ("net: dsa: link interfaces with the DSA
master to get rid of lockdep warnings"), DSA gained a requirement which
it did not fulfill, which is to unlink itself from the DSA master at
shutdown time.

Since the hellcreek driver was introduced after the bad commit, it has
never worked with DSA masters which decide to unregister their
net_device on shutdown, effectively hanging the reboot process.

Hellcreek is a platform device driver, so we probably cannot have the
oddities of ->shutdown and ->remove getting both called for the exact
same struct device. But to be in line with the pattern from the other
device drivers which are on slow buses, implement the same "if this then
not that" pattern of either running the ->shutdown or the ->remove hook.
The driver's current ->remove implementation makes that very easy
because it already zeroes out its device_drvdata on ->remove.

Fixes: e4b27ebc780f ("net: dsa: Add DSA driver for Hirschmann Hellcreek switches")
Link: https://lore.kernel.org/netdev/20210909095324.12978-1-LinoSanfilippo@gmx.de/
Reported-by: Lino Sanfilippo <LinoSanfilippo@gmx.de>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/hirschmann/hellcreek.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/net/dsa/hirschmann/hellcreek.c b/drivers/net/dsa/hirschmann/hellcreek.c
index 542cfc4ccb08..354655f9ed00 100644
--- a/drivers/net/dsa/hirschmann/hellcreek.c
+++ b/drivers/net/dsa/hirschmann/hellcreek.c
@@ -1916,6 +1916,9 @@ static int hellcreek_remove(struct platform_device *pdev)
 {
 	struct hellcreek *hellcreek = platform_get_drvdata(pdev);
 
+	if (!hellcreek)
+		return 0;
+
 	hellcreek_hwtstamp_free(hellcreek);
 	hellcreek_ptp_free(hellcreek);
 	dsa_unregister_switch(hellcreek->ds);
@@ -1924,6 +1927,18 @@ static int hellcreek_remove(struct platform_device *pdev)
 	return 0;
 }
 
+static void hellcreek_shutdown(struct platform_device *pdev)
+{
+	struct hellcreek *hellcreek = platform_get_drvdata(pdev);
+
+	if (!hellcreek)
+		return;
+
+	dsa_switch_shutdown(hellcreek->ds);
+
+	platform_set_drvdata(pdev, NULL);
+}
+
 static const struct hellcreek_platform_data de1soc_r1_pdata = {
 	.name		 = "r4c30",
 	.num_ports	 = 4,
@@ -1946,6 +1961,7 @@ MODULE_DEVICE_TABLE(of, hellcreek_of_match);
 static struct platform_driver hellcreek_driver = {
 	.probe	= hellcreek_probe,
 	.remove = hellcreek_remove,
+	.shutdown = hellcreek_shutdown,
 	.driver = {
 		.name = "hellcreek",
 		.of_match_table = hellcreek_of_match,
-- 
2.25.1

