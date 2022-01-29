Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 137434A3236
	for <lists+netdev@lfdr.de>; Sat, 29 Jan 2022 23:03:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353352AbiA2WC4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Jan 2022 17:02:56 -0500
Received: from mail-dm3nam07on2115.outbound.protection.outlook.com ([40.107.95.115]:64192
        "EHLO NAM02-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229737AbiA2WCp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 29 Jan 2022 17:02:45 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YIc/sbJttnffEuRSW6WhyAA4AygztZ8Ej5nutjEl3gaIOko/R8XDGAtNnztKglkP7/ZbfpLfJAN7PSMQNcm25uR+DfP6XAw7ThmRP96K2DIe6UR/r6KgfL88vwrVRSvR0JsjBSINaPEgXz/tbQ/CoaPnplgkjzbCNL254jOAGnbPwLFQV+ybYrLX9zOl9JZF6nE/bFmIVC5I6aCQr1RD/rni98UTBRzHWadIvJo/T2pFLLVx+a8VQtGXy03IUVkDAe9RNUzQwYAhQghU8+X1+PKS5Z5sEZfRm2VwvKNFIL/QACBhQ6xI+9VNo4Y1aEnsvZ0DaGOtmxdUweM5+DK3SQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zHGdMuTV3dqLs/rKFcpU4UxHwZEpmJTp7jg0WE99L4E=;
 b=YcVwV1hBXzO5XGf8n5iEqLA9X/4VkzCNNE9bhX1lrB4zuw2nb5McrSxV9RyqdgvYpeLbW2Sjp7FF3isaqmbKKNNnDQhIs8PXNESBfuub/+s8mV3eaZgMut9GlXFG7dRFxczyfKfR1z2q1PBTr6lRHxjKYhsjBef3GnT/mTTmCx5bx3buFCnetZrkvXLhQPcQKuOBm/ifTzwr/wY2ZBFfaHjV1qLGtg/wHUgdejAvDmJqGpy4R8kZ6Cu0DpEpD7BjUCMUBr7wcerKU2zgKM6zcqNNMNsyQg7xWLMwf0hz9hCOouD58hBNHFtjCXX1UVy2MI87UTwQQhF++Q6fsgO/CQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zHGdMuTV3dqLs/rKFcpU4UxHwZEpmJTp7jg0WE99L4E=;
 b=Xi5LJrgDAdeM797lzVbmVowpurZlJ+7yDoPKnC1Tbffs6UcKoQfvgk0AtW7Si/mHvF2kdQtWG77OgNyWC2c4v5H+Lu/gLnOoM7huJ9BQQ651vxAN8oZyMftsdFe8NpMsXTlj50j7D8XM99r7Zq3DqKHskjNFvwV5s8fWzk812ww=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by BYAPR10MB2968.namprd10.prod.outlook.com
 (2603:10b6:a03:85::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.18; Sat, 29 Jan
 2022 22:02:42 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2d52:2a96:7e6c:460f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2d52:2a96:7e6c:460f%4]) with mapi id 15.20.4930.020; Sat, 29 Jan 2022
 22:02:42 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-arm-kernel@lists.infradead.org, linux-gpio@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Steen Hegelund <Steen.Hegelund@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
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
Subject: [RFC v6 net-next 4/9] net: mdio: mscc-miim: add ability to externally register phy reset control
Date:   Sat, 29 Jan 2022 14:02:16 -0800
Message-Id: <20220129220221.2823127-5-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220129220221.2823127-1-colin.foster@in-advantage.com>
References: <20220129220221.2823127-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CO1PR15CA0113.namprd15.prod.outlook.com
 (2603:10b6:101:21::33) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2374cf7e-d90c-4a2d-f634-08d9e3731295
X-MS-TrafficTypeDiagnostic: BYAPR10MB2968:EE_
X-Microsoft-Antispam-PRVS: <BYAPR10MB29684944535BD5A565B3B332A4239@BYAPR10MB2968.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:773;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4+Mj59/xnAGxd6wfEEKAXYDJOByululZXooK0QKq2pW8rH3ovFm/vsInnMWFTDsdmxNmkW8x3CFoPZQ8LDFVV1zvqEv4G17q5pYvPZo9XG7w48lTCyQkDzMlN9GYzukS+Zhu3Hd02FbTyk5720dlb/5ESnWTEgfKcIYcdkkFdRiseTtoLDcVb7/sKyx4WLsUpR7T9524S3SMnfWm9H/+axLxhJ7QFT9c4suNCY2zaIcd8ZbsG7vXD64j70Jkj8QTkH7lzfGP9n2gO+U0WUJ1X0oqd2ZPpKlqvSr2ln0thKPhVRGF9iGit0bGMlxt8mIa4wcSv2MDlI47vMo/xGIKszjtaoqjTnCUP+4Ka5vt3CICZUVjz6Hzd619BofP32D5NIWepshXWRU9Ko2mpBfqM0wX329yId3l6A0Pibtz3XUl6JX1ZrS1ziXjo5a+aHSp2PqdiGTa6rjasueguf7yfMmQCkY5mYA6N4NdK+w8NZYhiyIrzdVVdNTB9XhSylzk0TzbFNEQGgz7GyAh/r6S7WVeiclvmrF5zv0wVPSxkDxuY9yRjIv69tnKnjq0+pIyhIK2DrTBE6MpeUv/6d/XmHjeewwKoojbtPVmhYc4Pj8WlAMg6y0ikOTWlhSUgrfpI/qBC7e2Z7wKsaXOUTLbPI87A7/ekBc9ainK2oprEC6jrVRdk5ON3LRxTrSwFmhxWNAOjwqJ5YtaJkgtobUiiA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(136003)(376002)(346002)(42606007)(396003)(39830400003)(366004)(186003)(508600001)(5660300002)(6486002)(1076003)(86362001)(66946007)(8676002)(66476007)(26005)(4326008)(66556008)(8936002)(7416002)(107886003)(6506007)(38350700002)(6512007)(2906002)(44832011)(6666004)(2616005)(52116002)(38100700002)(83380400001)(316002)(36756003)(54906003)(20210929001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?942kI0hKvSbzADZWTkJvqcrtEdkDTPLQ+tdKkVE7c6zVJxw78TEYJlTiJk3r?=
 =?us-ascii?Q?JjAk9mtQyOFmvjFWo7PhzO/Cgx2Iiv5hOKyAnAlwqiLoLu3t9sXcT+ubNCi7?=
 =?us-ascii?Q?9rMtR9Wsu6vn5XwShjURgHFx/qVkMcPb8jgSa17bPM0f/Kdvc5CDzhsg/iv+?=
 =?us-ascii?Q?jdd+xkXaf8Ym4EQv7KvWnC2hNUCYtva4sZRHFZaeoGxlXP7Jt4Fx3KlP4J+F?=
 =?us-ascii?Q?YSyDra4a2xQWXbrL1hlkekGYxHaQ6HEuZyg6jW7h1Tj48WUCReC9ADnwP0lG?=
 =?us-ascii?Q?BRTL+85PLvWJh8O42QELDj6HCB2K7u/9oyruANxmRkLGaDkI4yECOpzxXs3f?=
 =?us-ascii?Q?B1iC9vxoRlkbzmhAanUZjWCEZM4Ly/ytEG735lzze9rCqVNE+0/ePlv+RVmV?=
 =?us-ascii?Q?6Q7Ybr4FtoFAjPcIUniTBoK3yyOAVYXw2oiQfNPYGw7j2FB1Iub59tIhDKZL?=
 =?us-ascii?Q?TipCYUvN95m6iGckhsVOlovVI1yT4co9qXlPEEIjZk76eOUGaCKJ7z5WiUCw?=
 =?us-ascii?Q?XDkbh2u6EtmyrEmXokOHwRq6ZIDW/RHDtTn3D/Mrh8cDawrVjVzNWkAkWm8b?=
 =?us-ascii?Q?AXAAIerNXT699m9si0BvZxqzcbDA/YwUZu+B+xWWBPI85Q3VDwOynOWgMkw1?=
 =?us-ascii?Q?+umqf8pA61HmaIRwarUkLyfe/hh3wrxSY2FVTcVLuW9JZvVYzn7/dwGhahEd?=
 =?us-ascii?Q?y6Z9v+I25SuUuy+kclTptoqzAnvoCn5fX8rR1Dl6ThTk3afMEDvPrAybiVGT?=
 =?us-ascii?Q?mhw1BukbLwpKFtjkt6xJNYFRdTjarMEIOGF7LKD5QlUBIdhnF7LzSObsaHux?=
 =?us-ascii?Q?u4t2ncl2Q+FDrUk/xrPvtfcLFmE5oE3OKhbu4Pt7XgFs0fxUscLwGSS4KVcZ?=
 =?us-ascii?Q?uNdAFcBltp/xXiYYQLmzzvojckH1pt+gPCcN+otx18xSRC3FVjWYP2yIaRWU?=
 =?us-ascii?Q?rbHXrELGYM/Amh3MdXUm7Cknz6NpcdoKjInBdqD/1nnaTDGbStXrNdFNo0/i?=
 =?us-ascii?Q?NrVY6UzmIL1Fv8TH221cgOdaBoYf9aZomA3MMfkBIwmWk9NCtHp/SJ2ar27p?=
 =?us-ascii?Q?n3DvgZ+jbwhhZrB7SXRbqv6w0nmzU9FbBCKUT86r67uml4ibCS19jHxw6mRe?=
 =?us-ascii?Q?GiRIU3k/vii1UFNv2g+MNndva4ToXOKb8TSONqTbsL5Tk+d6uK8h1PayK0SA?=
 =?us-ascii?Q?4X2biGGOMkx05iP4+FiLX2OC5t0c+tuN8BR10ZKrAxIiYFRm5BhxSiIAlSjm?=
 =?us-ascii?Q?ZStzoKrvjWHsEcCpJ8cVhG5KKrivj77jfghbii0nmyX3341VeinC9M4oiVRg?=
 =?us-ascii?Q?TIZTXM5eV9mJr49cq5pCyiEQItC1doOdoPSKsl1Ic5kbhqwnhYAbzClEpDVm?=
 =?us-ascii?Q?j8c6S7iyOL2RPyh7/3RiK5t/q5+dkwnR/1NnZdJ+iRCtMTcXh4PJqobZ8UPH?=
 =?us-ascii?Q?vsruVRYt4HSkhlCU7ZfD2ENQ+Yv44P6fHzgGaAqOBCYSHCZYcA7Nwarc9Lfr?=
 =?us-ascii?Q?/iVWKN2OCIw0/mP8aRt6GjmAiYrrKe4gUFrhEo5dKqLnODa8tEvcizNAOHuQ?=
 =?us-ascii?Q?Wj1YSIx1WM6kOrmmo6N3rFykCAQqJsgA97sOwJW437CQzMSy0XOo4/XbEdYx?=
 =?us-ascii?Q?iAf6Squ62Uow68MfvVjbcxVGZAQ0DOYCY5BV78WD6RbWwl0qN9Yrmh114EAX?=
 =?us-ascii?Q?BbHzyg=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2374cf7e-d90c-4a2d-f634-08d9e3731295
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jan 2022 22:02:42.4072
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JOU9PqrBWEU0O5aS0li0bBiwb6lAyLBi2/bJDNQ2EomBuao0rHEx6Psu5M9/lmTGtIOjsSl2QS3ze1UaszXBMGzzpUv8s5uBIjuUAhhvBFI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2968
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ocelot-ext driver requires the phys to be externally controlled by an
optional parameter. This commit exposes that variable so it can be
utilized.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---
 drivers/net/dsa/ocelot/seville_vsc9953.c |  3 ++-
 drivers/net/mdio/mdio-mscc-miim.c        | 10 ++++++----
 include/linux/mdio/mdio-mscc-miim.h      |  3 ++-
 3 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/net/dsa/ocelot/seville_vsc9953.c b/drivers/net/dsa/ocelot/seville_vsc9953.c
index 8c1c9da61602..c6264e9f4c37 100644
--- a/drivers/net/dsa/ocelot/seville_vsc9953.c
+++ b/drivers/net/dsa/ocelot/seville_vsc9953.c
@@ -1021,7 +1021,8 @@ static int vsc9953_mdio_bus_alloc(struct ocelot *ocelot)
 
 	rc = mscc_miim_setup(dev, &bus, "VSC9953 internal MDIO bus",
 			     ocelot->targets[GCB],
-			     ocelot->map[GCB][GCB_MIIM_MII_STATUS & REG_MASK]);
+			     ocelot->map[GCB][GCB_MIIM_MII_STATUS & REG_MASK],
+			     NULL, 0);
 
 	if (rc) {
 		dev_err(dev, "failed to setup MDIO bus\n");
diff --git a/drivers/net/mdio/mdio-mscc-miim.c b/drivers/net/mdio/mdio-mscc-miim.c
index 6b14f3cf3891..07baf8390744 100644
--- a/drivers/net/mdio/mdio-mscc-miim.c
+++ b/drivers/net/mdio/mdio-mscc-miim.c
@@ -188,7 +188,8 @@ static const struct regmap_config mscc_miim_regmap_config = {
 };
 
 int mscc_miim_setup(struct device *dev, struct mii_bus **pbus, const char *name,
-		    struct regmap *mii_regmap, int status_offset)
+		    struct regmap *mii_regmap, int status_offset,
+		    struct regmap *phy_regmap, int phy_offset)
 {
 	struct mscc_miim_dev *miim;
 	struct mii_bus *bus;
@@ -210,6 +211,8 @@ int mscc_miim_setup(struct device *dev, struct mii_bus **pbus, const char *name,
 
 	miim->regs = mii_regmap;
 	miim->mii_status_offset = status_offset;
+	miim->phy_regs = phy_regmap;
+	miim->phy_reset_offset = phy_offset;
 
 	*pbus = bus;
 
@@ -257,15 +260,14 @@ static int mscc_miim_probe(struct platform_device *pdev)
 		}
 	}
 
-	ret = mscc_miim_setup(dev, &bus, "mscc_miim", mii_regmap, 0);
+	ret = mscc_miim_setup(&pdev->dev, &bus, "mscc_miim", mii_regmap, 0,
+			      phy_regmap, 0);
 	if (ret < 0) {
 		dev_err(dev, "Unable to setup the MDIO bus\n");
 		return ret;
 	}
 
 	miim = bus->priv;
-	miim->phy_regs = phy_regmap;
-	miim->phy_reset_offset = 0;
 
 	ret = of_mdiobus_register(bus, dev->of_node);
 	if (ret < 0) {
diff --git a/include/linux/mdio/mdio-mscc-miim.h b/include/linux/mdio/mdio-mscc-miim.h
index 5b4ed2c3cbb9..5a95e43f73f9 100644
--- a/include/linux/mdio/mdio-mscc-miim.h
+++ b/include/linux/mdio/mdio-mscc-miim.h
@@ -14,6 +14,7 @@
 
 int mscc_miim_setup(struct device *device, struct mii_bus **bus,
 		    const char *name, struct regmap *mii_regmap,
-		    int status_offset);
+		    int status_offset, struct regmap *phy_regmap,
+		    int phy_offset);
 
 #endif
-- 
2.25.1

