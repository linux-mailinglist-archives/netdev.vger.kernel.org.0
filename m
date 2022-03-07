Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C84B24CEF65
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 03:13:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234777AbiCGCNq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Mar 2022 21:13:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234707AbiCGCNm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Mar 2022 21:13:42 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2104.outbound.protection.outlook.com [40.107.93.104])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48DD213FA3;
        Sun,  6 Mar 2022 18:12:32 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C1HgIWM5h0U7YmxosaJ1G3PUXBpUW6+ywSHAhBE1NYxiFQ8PtQW2QxtJzl7T+ch7kf+yLdfrIcWjQ8OKNXCQ7UH0BCxE6fWW+YB9XO6tEmfXp+kD1j5ODucjXK7HVlXb2Y1DK/dQXAajxUJNFHW9PQ3Bc/0oyT1+vh/Xvf3UMdTlsc96K/p1J+fatJSG6+IqOVHslNhyy1YCi1tJ8YIGosSRvMdE8jQNxu9TMTjhqICantak18xRnp6gjE/R0atFtshtRhKKphOGIhHArttVZdnxmxUb3JUp9RX/6wUtB10bObIIufWv9Y5ONanyCoYskHPO3RVlTtNgCtl4l+jc3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Jx+bEg3/V86ll2U6awGJJji855slUvKisl7sgZqnl90=;
 b=hjkrG+Cr3ib3rI3Wlf0Fd8VqFTb54dLuNFKu2LnHnKeCvyA80XJHkt0VYDgxQjiZfyL8efcwHLUdbIkzCzRfkv36tseRccHicxj0/qigHBhvhsH3dWUgrhpW/2N9PLhMSe9YYUt7AmEWJNNG6e22nbj/T5pv0XrOLVWD0Yfowa+CbYUdyRITgHEkMilNhVVgh60vPLqRnubRkf85PvgpvcxNCalTJTDPx/zMzJqOdTkqbP/bC6pAU5vkkWEffQc7qYZ2SRTtlgx7ThpRxMvxqA1Za0KonT5L8FxzKXIsKpis46fmo0nDxoan6mt/kbmPqEC/fajZimsvAu0zFG7vaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Jx+bEg3/V86ll2U6awGJJji855slUvKisl7sgZqnl90=;
 b=OwFyJY11psDVvkv7vrV7gKpBuxjct9xbT0Up5vG4skjm4Nm8/df4Wupo14rZ27/63R8jgozE4JNY9DThcWqfo2OSqokUWaW859DNzCvHmaTkLvKd2uxFj5zn8hFkhi3qLBxbwRnui98ILsV08nW0i3votF8J9dYbOBOOzvGcyAg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by SA2PR10MB4553.namprd10.prod.outlook.com
 (2603:10b6:806:11a::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Mon, 7 Mar
 2022 02:12:28 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::7c:dc80:7f24:67c5]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::7c:dc80:7f24:67c5%6]) with mapi id 15.20.5038.026; Mon, 7 Mar 2022
 02:12:28 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-arm-kernel@lists.infradead.org, linux-gpio@vger.kernel.org,
        linux-phy@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Marc Zyngier <maz@kernel.org>,
        Hector Martin <marcan@marcan.st>,
        Angela Czubak <acz@semihalf.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Vinod Koul <vkoul@kernel.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Lee Jones <lee.jones@linaro.org>, katie.morris@in-advantage.com
Subject: [RFC v7 net-next 05/13] net: mdio: mscc-miim: add ability to be used in a non-mmio configuration
Date:   Sun,  6 Mar 2022 18:12:00 -0800
Message-Id: <20220307021208.2406741-6-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220307021208.2406741-1-colin.foster@in-advantage.com>
References: <20220307021208.2406741-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0174.namprd04.prod.outlook.com
 (2603:10b6:303:85::29) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5551d089-c2a7-4682-b961-08d9ffdfedc4
X-MS-TrafficTypeDiagnostic: SA2PR10MB4553:EE_
X-Microsoft-Antispam-PRVS: <SA2PR10MB455313103434B6B4BFE53982A4089@SA2PR10MB4553.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uL9lvdTHmBUEmfmZhytsN7DBNNdPmpu0kDMoLSUgNesz/iDz5SoyQpXLfMdHvm1wR1EadoLbarCmiBOLiez5Ezvul7H4dMsjzXviHHVZ1z55Bljxbh2M3Pb+uT8WakidODsdXesHj5NXBQLTGZIUarzxLewW3gQYZfDvyRI95EUtUIK7gcta/RsQvj9Jx56ooEb05Kl8hRtX/b5ltKIHAMmHl4owJaZTigwRYOEjcrmIYXiFS3DWSK1jcH5eSzoSrSoT09aefMbdMgEm9lVQKK80C3T6A6HM1ljf2vSZ8GsyOegcVsflsonSTWirFdON76g0t4PaQ6EVlcimsd89NoLMq3tcwJyUjPaldxAtpmZZRjW+ml8dJpYoKE3PSeaAV8AgSfVg/hHsYwq83Ez5iin4fP+tHM4RDY0gLwUffjiaaUcUY422vHnhOPoofcibsQ58RKLax9XP0CHhazAWkSnlnEO7GjvWqEhHNEgxg8GY4SrwichaHJ0HoZ8c4zQaqm9plcPOkD1xW8htO/U079jXHXZ2sUL4ZToqu4Jk7YAalT7TadED5814RHT6evzB8/E0vnbuZDrUicRwe/+dK0u3xIv+bvi8yQ4Kq7peI/1ywLgHa/u9YRfJ0nqPJ5E2GrXtOx54Dx34n/YIZHp1fe1s0V0OUo9WU3+XDLdgn/r/9QPw50V0mtgqh8xFYsF93roiKnbVnR5MzR9oR6HhTA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(376002)(42606007)(396003)(136003)(39840400004)(346002)(38350700002)(86362001)(508600001)(107886003)(38100700002)(6486002)(54906003)(36756003)(44832011)(6666004)(6506007)(66556008)(66946007)(4326008)(316002)(66476007)(8676002)(6512007)(26005)(186003)(8936002)(83380400001)(52116002)(1076003)(5660300002)(7416002)(2616005)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?J0vFyTHF2ESUj+wSwdPf3+gBKpNmjY2SyZHVE3u5wx8NVbqKEkkaHJtiaKJC?=
 =?us-ascii?Q?VGjnWQC0LgbglJFdOB33CVJ4T7UrIB1nDRnXVFb8qtSZizP8tOK7VFshvm7q?=
 =?us-ascii?Q?aLn+s6XRDuHDZ8TUodIUyQQoKTRUBceNha3aVup7gAnyQVKhsLQL+FXtRB47?=
 =?us-ascii?Q?jEnR7sKT9AzZfR36kmOjXjoF0kTv9ZOz+Jmqjk+6nUX/DZ/7zKnhAPWcOIv+?=
 =?us-ascii?Q?4PCrqJPusXmYRCi622qV8XL7ExD4ZUCOTZGMNrggyzUAumDg50vPghEqBZ40?=
 =?us-ascii?Q?QTIa+HpFr488qTpE87SGxYIXtZcfMjuNdIi2KsXHPkHbvWBZ/SH/gz8vk2E8?=
 =?us-ascii?Q?7Flg/y67YWp5XAsdI9G2NsQ06YrDlH4ROD4UxqPD5yOqH1GCc9kdp5GVJkVn?=
 =?us-ascii?Q?Tud0kL5/AY0rgZheTDpsgXEsZAUXiP9MYu09ak2hTTWM/6G8/gH86DjxWvbL?=
 =?us-ascii?Q?JrRNVDgDLWZFNnXU5XaiRxqWTJW/yJmVLIsA5n3eDmW3yP7ITzO5H4+fyyyq?=
 =?us-ascii?Q?yd6Hw6hRMVj10lFesD9kl0sdtW6MKN71yoPSPpKF/8rb9lq92kqZgfIUlxKH?=
 =?us-ascii?Q?ddoVt2mWhlLfadw5iX8bfFm0b6/gowLKla2y6YO6i2Amj9L3xYNBeEeLHdnr?=
 =?us-ascii?Q?ktOkxVbvddeehjIlbPr7roAiS+P2ARr9cHfq5ECSS8B+J/9el9p5N2vKXTIa?=
 =?us-ascii?Q?IzWKHap5wcOQLHoCOyCfh7/i388fmkKoUUwAuNgLjisQ4XQfllMi5sZZts+z?=
 =?us-ascii?Q?+lqVWaVWZ7MrLzlmYhMPfnT9dk9Tjv07eVRnDNdnburFh72YpA1LxckiVoiA?=
 =?us-ascii?Q?KvZVstUZHvmS/hiIz1uQ79Qm2QUUrvR/SwZhtMBPfddYkqWnGjwMCfag40Na?=
 =?us-ascii?Q?/uemdF0x1zHJUKqItXBA+Ns/WkZQqNM5obE0hMsScFr0CKYjyywjjB4wpZUv?=
 =?us-ascii?Q?gv7urwNMG/8hMkYGATzBfWsdnFMDKoi9w+V8BpJ7MZd2LNeyWM8WvHhN1oWR?=
 =?us-ascii?Q?9NFdvzgucTvsBsH5BrlBzB7pxSTsucTsubqEbyEJlSq221O5vAVxmwU02YYN?=
 =?us-ascii?Q?Vfgesa5FZfpqkqGJuiw6Tujhet29Mq84lCgu0GKVPOIwtY2x6Zk5OHpn2ynV?=
 =?us-ascii?Q?vVloB2p+J85akuDwg4oCJWZ05zqo+CLTZ1SiwbiNxiGkzqVz6oxEVBx6tlEQ?=
 =?us-ascii?Q?Dw33MBVTtBXxm8udEXYwlOUlsPdTpVGcVgrnHjkCk6fwSYZ/3iu2ksGwamlZ?=
 =?us-ascii?Q?x7AOtUkQucTr8cqthxtbyn509sMRqaHNCiL+rnVtjM0yNF3tuJCuZ6SDiTYa?=
 =?us-ascii?Q?aQLX1glx0DGdd7uZRymeQhp8bLxTkcAdHn1TqKt/CY1zvsozmv9FcvXnJsNr?=
 =?us-ascii?Q?JStD0Ur6mzzW6jOX6C6F2mZRAXQpJKoG5Xk5Hg46tDYW8mdNUUf80BFjTuI6?=
 =?us-ascii?Q?Zif7JGzaV9Rg61twMjqreJKaRhiAOAw1xmvr0FahaenHsPFNYk854DKn+X8c?=
 =?us-ascii?Q?s4IEDb/ZiItqbtNj7cAzJ/NrTX3Hy0eiHJcIAVRB8gTnlZa7e1Z8oWxVvQbj?=
 =?us-ascii?Q?DUrldKrHD0vJnjlRP8nxJmZOmevQn9bNrZ4SDK0bWKLKH7QMgfGX2W0m8rWB?=
 =?us-ascii?Q?8Yz7T/FupePfKnUl9rZ/VMJQWDcnkksH3esBB+d05k6fQAgYIBsLn+iVLIv9?=
 =?us-ascii?Q?4qTftA=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5551d089-c2a7-4682-b961-08d9ffdfedc4
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Mar 2022 02:12:28.4330
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: o9tJVCLGsROdW/dic4OjF+Cz2S3UJ+FlxIG4KeHzf1xgcNJF3yuAYoXa9D20d1keHvkHbKK5G0ScSTRkNhK4SX6SJDX64sTJ93i1rMeqGy0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4553
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are a few Ocelot chips that contain the logic for this bus, but are
controlled externally. Specifically the VSC7511, 7512, 7513, and 7514. In
the externally controlled configurations these registers are not
memory-mapped.

Add support for these non-memory-mapped configurations.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---
 drivers/net/mdio/mdio-mscc-miim.c | 31 +++++++++++++++++++++++--------
 1 file changed, 23 insertions(+), 8 deletions(-)

diff --git a/drivers/net/mdio/mdio-mscc-miim.c b/drivers/net/mdio/mdio-mscc-miim.c
index 6b14f3cf3891..3153bac874fd 100644
--- a/drivers/net/mdio/mdio-mscc-miim.c
+++ b/drivers/net/mdio/mdio-mscc-miim.c
@@ -16,6 +16,7 @@
 #include <linux/phy.h>
 #include <linux/platform_device.h>
 #include <linux/regmap.h>
+#include <soc/mscc/ocelot.h>
 
 #define MSCC_MIIM_REG_STATUS		0x0
 #define		MSCC_MIIM_STATUS_STAT_PENDING	BIT(2)
@@ -229,11 +230,20 @@ static int mscc_miim_probe(struct platform_device *pdev)
 
 	regs = devm_platform_get_and_ioremap_resource(pdev, 0, NULL);
 	if (IS_ERR(regs)) {
-		dev_err(dev, "Unable to map MIIM registers\n");
-		return PTR_ERR(regs);
-	}
+		/* Fall back to using IORESOURCE_REG, which is possible in an
+		 * MFD configuration
+		 */
+		res = platform_get_resource(pdev, IORESOURCE_REG, 0);
+		if (!res) {
+			dev_err(dev, "Unable to get MIIM resource\n");
+			return -ENODEV;
+		}
 
-	mii_regmap = devm_regmap_init_mmio(dev, regs, &mscc_miim_regmap_config);
+		mii_regmap = ocelot_get_regmap_from_resource(dev, res);
+	} else {
+		mii_regmap = devm_regmap_init_mmio(dev, regs,
+						   &mscc_miim_regmap_config);
+	}
 
 	if (IS_ERR(mii_regmap)) {
 		dev_err(dev, "Unable to create MIIM regmap\n");
@@ -251,10 +261,15 @@ static int mscc_miim_probe(struct platform_device *pdev)
 
 		phy_regmap = devm_regmap_init_mmio(dev, phy_regs,
 						   &mscc_miim_regmap_config);
-		if (IS_ERR(phy_regmap)) {
-			dev_err(dev, "Unable to create phy register regmap\n");
-			return PTR_ERR(phy_regmap);
-		}
+	} else {
+		res = platform_get_resource(pdev, IORESOURCE_REG, 1);
+		if (res)
+			phy_regmap = ocelot_get_regmap_from_resource(dev, res);
+	}
+
+	if (IS_ERR(phy_regmap)) {
+		dev_err(dev, "Unable to create phy register regmap\n");
+		return PTR_ERR(phy_regmap);
 	}
 
 	ret = mscc_miim_setup(dev, &bus, "mscc_miim", mii_regmap, 0);
-- 
2.25.1

