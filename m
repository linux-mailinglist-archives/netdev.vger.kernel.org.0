Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FADC40F961
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 15:36:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344524AbhIQNhk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 09:37:40 -0400
Received: from mail-eopbgr40079.outbound.protection.outlook.com ([40.107.4.79]:32296
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1344159AbhIQNgx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Sep 2021 09:36:53 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JgGywMe2DaJe2WnkA4b+etA5OWppX1lIWr/lGnu/yPR/8P6Vy1MvtxFjMQVVudL4px/xttHMV1vxYYPMuG6Ra4ayGcnunnE/MKtUCQbmHl06ztp+7Ap1fFqEchhZ1ZSetcdVxWaDDPW8kVFt73hziflernEa4r6AT77gRFjbgeRqd2I+V1k2RY76gqBJ3Owy6nOzsjhgUX3GdoIpJQmK2tBoa8BSBVWGYEAqWLBQN4iWotxgsNrCRUHm6zU/qfBLFL82LOxL3xmowGoHPkW6ur1YAogWmwYffj9nP8HYCOUP9jCLs0lg5e5m8o4201IaTxaepPTMqljCd8X/yt4mhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=TpwJk1VxBa92OVrPdLSIOrB9XzMTMsuCoNlrqPpc3+U=;
 b=Fyzrm40FxOmux2UmeNYzlJdwcECdMAmCzxt4Yxb8O/c7+vU1DGiys2Vi1XR+75vTqd3GAiGoiICrL9FWQ0dmhc+TpAILEw7uXJBXeX/JsrMxf6VMjCagGc5Ivwekl9yzj0TbdlHS3TgZRrsb0LnfasPeLvqLsrMRcWC7RMrifTuKoaz5M9V4xa4tzhlc8rFZZJuIrRhAn9FD5xNt04G1fpzdnKsg7vSghsexhlsKZgDkp2NAqthNatNF7DAB5KwfYNsOAeSDmj4VLai7Y79rFvpddyMGRVEsBfWxiYAhwhagSu7cxnUhIdi8198nBgUeyXk8GY/oi2Cv6IT94Y9YFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TpwJk1VxBa92OVrPdLSIOrB9XzMTMsuCoNlrqPpc3+U=;
 b=eKEyX0QR94O7xAOgY7KMAfK+aNTbBDEuDG5ASMtcGxHccs2nDJUQIhkAU6ULM5fZbvHBPRzpp4VCJVRuak1xcu4U8tnfXuB1Cmzd30VuEjkX/lXUJM1fIym0BG+S06c+6ueg6WhzsSLJM+lVT52sQrLdreKk1bxHJ7GjIFKdtaM=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB7341.eurprd04.prod.outlook.com (2603:10a6:800:1a6::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.16; Fri, 17 Sep
 2021 13:34:57 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4500.019; Fri, 17 Sep 2021
 13:34:57 +0000
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
Subject: [PATCH v2 net 3/5] net: dsa: hellcreek: be compatible with masters which unregister on shutdown
Date:   Fri, 17 Sep 2021 16:34:34 +0300
Message-Id: <20210917133436.553995-4-vladimir.oltean@nxp.com>
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
Received: from localhost.localdomain (82.78.148.104) by AM0PR02CA0199.eurprd02.prod.outlook.com (2603:10a6:20b:28f::6) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14 via Frontend Transport; Fri, 17 Sep 2021 13:34:55 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 82488cc7-b849-4a07-e1b2-08d979dff0a7
X-MS-TrafficTypeDiagnostic: VE1PR04MB7341:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VE1PR04MB7341DF56222C466FC1F02653E0DD9@VE1PR04MB7341.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2657;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aPdavtuDPMtusnLUKGehamESPhwh+jEzIoLvYiYlIooZXXIn7XUrO+mDIvk1mXEgBI+5DuejkM+iCT7Wtsz54qdq74v/jP8TLo95uTqHKd/GDUr22LJSjrn+hrD7NbiNS2ILMVUe9n+SaCTFT4bGOreZaB2Vsyza/E8a0qmhee59CrocDfidG7jwV/DqlxvI6JQdOndmBfow85oDVEthVMqelOXRkq6+8ZmLKQzM0MSegBRf2mRiJGtMAeOKNgJqvOKyZUdbpT36TfKn3hG2394OI8bxEWbAjatkwPw1aV+rDuTjUyXllbRIa5X5PL9PsvkK/erORti/7391Ejk2AtLcg+dap364s9vzrPTy/s8E9xAjenK/T+w+Y9F0CGwtfi1hiksL0sCM1IPwS37Tpq+gtEDtc2B9q2DMmeLc1Q6oaZEgnqJvsj+7FZ3Cr+plxiOvwr4Jopkb8kcSao7Za3EUPE9ityRLw0g+5enOYWKpKlAj93OGyTIRGc3NhyZViuMRpogZKNjXTru3lK/lTP2JdbbK7M9Th6mdOcEMpxf6JwRRpw+y9fcDIrhjDiwyta9Qxh+g1x4+yMjM/UqxJKBI9hewRcdyLP4ti+5R4HsOPOK/nK4gJe4k/TjAfYCkqClofGW/Xxut57onRGuPv78uVGTUe27aApyR15vgOptrqN4EYaOJutPzAHy4Xw72tB0PK0LLs7t48GvgTRkPiHq9Pt/CLMmwYYVQsrHQQVBwbRuzIPG9E9g487/U1Enz0tA+I8zwTwVncf5rC/1hRnj4mmdcQYEjsKkEda8Ra+I=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(376002)(136003)(39860400002)(346002)(54906003)(316002)(38100700002)(38350700002)(36756003)(44832011)(2616005)(86362001)(6916009)(66556008)(478600001)(6512007)(6666004)(966005)(6486002)(8936002)(8676002)(26005)(1076003)(5660300002)(6506007)(52116002)(186003)(83380400001)(2906002)(4326008)(7416002)(66946007)(66476007)(956004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?tg8g0H33Ip+xFTrD9wRLQaDXCJjvlAdQDVbvNk8fzTUF0OlxdxLcIrdpcEb+?=
 =?us-ascii?Q?21tiEoBELxwaASfDxG619VixTVdrmVspeaFmr5EPhKhV9GuPku6NDBQJDVgq?=
 =?us-ascii?Q?Hean6w62EuZacZSkYIK+k14beevjetbn0YMHwVY/ZDtpNXHSYC5OOeN1qbv4?=
 =?us-ascii?Q?8celHhCpGdFGIqXNt+IrMkmtX7X2XH4MufbVXmPfwXsJhhIdziOc6trxd42Q?=
 =?us-ascii?Q?DDpaImAZKXAnEDlz6Gd7yaOSyYenaupMLDiBQN+PnjzgQaNnnKx6e7tZ/gRG?=
 =?us-ascii?Q?yAzJptvXLtOksLVSFxecBpYv1gXlNapwXtQG5FlbSej9nkBevpyLG2fRFGsc?=
 =?us-ascii?Q?l8YRs/hyQt+XbGOmWS7rVgKELR1fYR+jYoxPW0qK7Y9Z0ZwkIDWWPw2zRKA8?=
 =?us-ascii?Q?1ednNPubKGiBqCSBDGQxgDcyvw17ypjpC4dKGTaGy3zNA/xoODRwdbQ9FN7e?=
 =?us-ascii?Q?6MyjWtmV1MQxPFoT99w8w/MP94qr2hoc/KtPWKLvCIKlqFNEObFIVHLNA+ap?=
 =?us-ascii?Q?G5c81GBKhyzfJQqeT+ZjCITfAr9qbztL0lHUTki+URL2SswI8Fk8GNg4nsnD?=
 =?us-ascii?Q?rr6KJ2lwRGHvLujX/bCC87Q7szJ8hKlhQdNYTC20jSY6CN9H6tMmptLvbwqT?=
 =?us-ascii?Q?oxK2ktBwZS/rztVbnt1Rmb3F+TzG24EzxB/GkRzvUP83uHvGzpw+8JNSn7J1?=
 =?us-ascii?Q?k/G1bJDE63jwc4H4CuCbdXLtlISwkvYqH/ECSBe3b/b7jEvRkeyro/OUHaKa?=
 =?us-ascii?Q?Kvbzg5jYPHnb9ko5QMmbqcLJFuYtQEOar2cIzZR+KbJ7m0FNMTsVdZpK4CQs?=
 =?us-ascii?Q?xuLtdaaZkAqy8rpAg94Q5UUxaUTLhpVpKdJhGOANgm/weB9s+KTKCJq33u1z?=
 =?us-ascii?Q?AKm3JjU3Kj7VQ9TFi3yxU02/R94tXFjYTAT4dOZrMYtFXRtCZbhPqIHCRGlh?=
 =?us-ascii?Q?PtlvteDV5NgFqWxw0jRvN4/iDvU2zcBeJRhUI6WHsCbX+VvkjVYSDqtjyD9w?=
 =?us-ascii?Q?SdrOrVc91ZQKGd56NdPoMTnQsF7Vfjj+kKdO0Na/IM+nyaJiGHHa0r4rbLF2?=
 =?us-ascii?Q?6MorDjLmX5brur3e2vh4a/KmG1h+oAuym8jehrSjjdKwESFIJMm7/s+e6l02?=
 =?us-ascii?Q?7obcpjSvTuZbmDRNNJU4NX60X8mtPXtSS9BQ2tJ/sUCUtutgLvY9hpfZNqv+?=
 =?us-ascii?Q?8MRWyR6hOptcvQEuU8XC+7PO/+U0NZJAPu0z6ovnbZ6WDxQQsfqq1c9zh6gH?=
 =?us-ascii?Q?sMJ0oPTjRS7rGeFiZW/G6Cv6mdFmtnIpiFWl2+m1IiSB4ZqeIb+ztqAuCy8l?=
 =?us-ascii?Q?oJuoAgQNg+Kx8/uIWn7Dgo1l?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 82488cc7-b849-4a07-e1b2-08d979dff0a7
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2021 13:34:57.3396
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BkKpbqa+l+5Ei1Gpm0D8T/BdNOWJiW7LRQeVN+5XQaX+Zwby2KFsE9gKlfeL8Nrbt459Ys4NHT/Wr3QtHwFo3g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7341
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
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Acked-by: Kurt Kanzenbach <kurt@linutronix.de>
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

