Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69F8A57D932
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 06:07:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234088AbiGVEGp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 00:06:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229783AbiGVEGe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 00:06:34 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2097.outbound.protection.outlook.com [40.107.220.97])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83F6989AA1;
        Thu, 21 Jul 2022 21:06:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O5EfXFoKP9egAmzYB9f0Kt1u8CfnW6TgfMRHkQThBdcQgqZdDh8i1TOXiqEP7PFOmfIy91tlrtHDMHZomA+H8/X0gv/1nzs1IA1Ne5yOu4QZPm1fvsgX4X97d9E3QflCwo/AcgQd57KoCTnACV5LHlAcVlJiI6w+ZlPUHjCyu6w+VLkBppvjLgd1BltnjNkB0oyT61hsoOgPN0ElvS4Iv+kGSEKTFrV8ooBdIwJ6nmqYOYkGYfcwnEwg/VnEG8bPK21ZCLss5ZzFFfDflk8m8QiVNSwAzjOBx+6jGovVN7sfsiGslA8W92g1UP11ps5GBMDKg1ViGixI5yxKF3R/+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=92iUzUXhYgf9AmwME9MmKxPd1Gl/mMhjGkiY2HAVkqA=;
 b=TrppVelV5+W0lXc5KCsvPnTXvQ7qP8rvOjviouqO/FGn0ZRkhij0xgR3tw3qXi8Gwk+zSuvuBaiA8ASoz43XkNOWbh8YCGlNRWYUQ9mPm2VWzPrndQCmx6kapV2h/9HTcUwBthqhbAkNe+OwldiQ/nOyepbzSCtRkJ3ytFpklce28GiYpDrXsww5P2/LiUXuf8+2iP7X4Ltp306k9Hnj6OHFrrgYZnCz+4YBV2AxcxdliHvl4Jtza+nQTesB21huptw5uiHtgdMxV7x3DcG0HjX9xRaEPYYro/8tBDwRU9LjIQX0WWxAMXmBRWYnUlcCl/AawY53m01EluenyM3YJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=92iUzUXhYgf9AmwME9MmKxPd1Gl/mMhjGkiY2HAVkqA=;
 b=aDSxeX/AnnIR336ObIuWdDSuFd0luOmdZ57bHGdz98+p6AffJHd3cYHr7p1jWLGc312IDW7jY+XjHU/Wr677FJQUbysn/VWtnf+hkFKn06rcI9j88LE0fHEAMDMUFVnp02b2PdzDtZVHTK0lhEgOACjtKroibmhmOfBu3y013A0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by MN2PR10MB3919.namprd10.prod.outlook.com
 (2603:10b6:208:1be::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.20; Fri, 22 Jul
 2022 04:06:27 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::7451:2903:45de:3912]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::7451:2903:45de:3912%7]) with mapi id 15.20.5438.023; Fri, 22 Jul 2022
 04:06:27 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-arm-kernel@lists.infradead.org, linux-gpio@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Cc:     Terry Bowman <terry.bowman@amd.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Wolfram Sang <wsa@kernel.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        UNGLinuxDriver@microchip.com,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Lee Jones <lee.jones@linaro.org>, katie.morris@in-advantage.com
Subject: [PATCH v14 mfd 2/9] net: mdio: mscc-miim: add ability to be used in a non-mmio configuration
Date:   Thu, 21 Jul 2022 21:06:02 -0700
Message-Id: <20220722040609.91703-3-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220722040609.91703-1-colin.foster@in-advantage.com>
References: <20220722040609.91703-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR03CA0044.namprd03.prod.outlook.com
 (2603:10b6:303:8e::19) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: eaf1dd82-b7d3-4eba-6981-08da6b978c2d
X-MS-TrafficTypeDiagnostic: MN2PR10MB3919:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MtGiLm9sJA8NPyqSDg6K2XPqZLsUAkX5aGXGWBv/yfXzpVmuAqPs36RpjodVVd7PBBRJgpq1cgMo8xiVfKvPOlgC5zADpvAUoaanKwq1kWM7W2l+IIsN57b9wiyiRy4QRM9CLHpefDKWsgVI7HBLZ7ezDlc1+FWBFzPgbKPTpbNPlycDZsiqsKrVlvtO+VYEDEG+DSywu4Ao3OiL3wzwlMKnCuH+P22NFVwt4HgRXy6Ux9MQ0OG9bdUVWrH/vkSSBJYeG9/MhyVB6LY5U+ISuSniMZlwWsml4IEEkuG4LcSw0qw8vM0Q3GK36KiHszbWn0vO39MbJotmPTR6JgPxBfD/8jzg62+e+2TMph+lY4h+sjvB5vWrtxWerPyE3ls636/JtWe+/JPPif/mlg4mTsnsCzoo+GBaFt+01yeNn05KF7co8lXeqSGINsTUGcIVrz7qsSde/VP5GXC3lwI1cLVj3gRgnYMOLb0yZemkiSbv14ylo+OetRUKC19qk7shjYE0ZMlSqw8ODlOLPSpIpzGYZgxnqSUXnKxxAqEAXUG/h3H8DzKy1xemuQ2/QuNi7UmAxsjLxjTMzfwBKT55UXQPxEcNdf6IQXcA9tBRIrtHy01PRJgFhL7BqjoQ6723IceM9MHtPgOuDG23zZOdWplxLaoyaVsgI20ZssFPzuz55/dp1cM/9dEme8tI8hewUN3G4MlRzt/bPapthq2ktjVUdI4rhjvuUO12fOInxC+ToxHfM8lPExABQG9wY3k0BONRfuByFYvoIBXPp5lfNpshh6i+T+Hhoi5fwRe4hcM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(346002)(376002)(136003)(396003)(39840400004)(36756003)(6506007)(2906002)(44832011)(41300700001)(52116002)(5660300002)(1076003)(66556008)(8676002)(8936002)(4326008)(66476007)(186003)(6486002)(478600001)(6666004)(6512007)(7416002)(83380400001)(26005)(316002)(86362001)(38100700002)(107886003)(2616005)(38350700002)(54906003)(66946007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?BfC6KzkBC78WCELIWwAPkLwaCcvl0gFjt8dlInf56/URtsuvuUMB0XX8jIUQ?=
 =?us-ascii?Q?8WoLGEOpR4aTwgqqsluvafha+wbkm61m3Mk4Pi2j8D45AKxLI/Ud+qkrc2tE?=
 =?us-ascii?Q?wTxaJ9Ch/VMRJt2LGJ0FvVKQaWIAmonaKmN4lXJKyacrcPpucOmqUfheIIHE?=
 =?us-ascii?Q?B2pvqE8H5XU/V4KdJ/GEUkvgA6s1XO5uDUP8OxWQ0V8jPigXjy+LNtezTie6?=
 =?us-ascii?Q?7lmeAJLKIISc1On7bsHxDP8m75LsEZddgh4J8+PHnggpG7WKu0AelA2V5xhh?=
 =?us-ascii?Q?sIk4n1HYZYj8srp/67OXwXPf8jWQkgUCgv+n4dmVp/pUjqBsJE50q+MVQrtX?=
 =?us-ascii?Q?Ui6vcgwrpgrXedMgQlflWOQjAN0hrJp6X5wwBuS19jVndeQ+uCgz3z28HqQr?=
 =?us-ascii?Q?tHHgL6hsXwjQuHN8OdnaODjphuOVw8axebrvfjQ7UQWNsfOPi+uVy+490dN4?=
 =?us-ascii?Q?mjZiP3f6W5cd1oNBUi/Ai3iiyWPcsY5fJ44vQij9jKmzoo8sxL1fCQzkQD/G?=
 =?us-ascii?Q?s2ouGVJ0YCdfpQ1erWxgW1ZdiIj6Gh/BPoxkOsaOoliL8Cl+fjacnvNrVDhr?=
 =?us-ascii?Q?4xkv3VE3ef7F6BDRr8Vn3zt621P7BSHjL8uMK8HsPR56pVyeSntFuenarN6b?=
 =?us-ascii?Q?OD4idKr/AEpnVAmEi9k0aqoJpHupM1orSyAfKFJoX095JT+oiWuKy+YFaP8/?=
 =?us-ascii?Q?/JAna4P/td1KIHdSL12lsm96A4cmvSw1QFiOgsOB2ZRqqqB0Hg3Comq4XOP9?=
 =?us-ascii?Q?NcEzjupqJOABcVdtrERTQyOYAIQhyaxJwSi6xDa59ltOxJ7CSFyxpfXM7eBG?=
 =?us-ascii?Q?xcTXBK/k/UxgBjl5EEs9PM7pR03TPjQOClT2lLianfqZBDlEZgjnm9JfNvN8?=
 =?us-ascii?Q?PtjprexVfhD3R3pqzr6srEScm6G+R0Md72QWZ4lk6GVPeDZfywCyiHoY5rxa?=
 =?us-ascii?Q?Flrph0xHj67Q0FZyDIHR/R3l2OZZbjhyqGOVO0xsQ4Aju1S3yoxBdTTlugfz?=
 =?us-ascii?Q?LPxLxRYmcjKy7ynjNGf7J0fAVBeGApeEMFeRl2peVgsUVSxb439z3YEvY6+2?=
 =?us-ascii?Q?rJSPhDsF4PQd96gEaFyoQdyulObDnqT+UzUwnigN4EZ6GhstSzFzoI+4ExWv?=
 =?us-ascii?Q?0Kcms6OpMEx+qJMH/dXNRqIIBYd9lr26RDitQL9jsvZb397Lv2o1RcreV8Wj?=
 =?us-ascii?Q?78gG1z6THESRoUQQjWlYr4UZn+BTBGamZLA0CzM/xJSbA1pXyxRJ8EDlK0Qb?=
 =?us-ascii?Q?UUuBQS5bn3nTt1R9jXJ9Jkg+xrQ9i0TP5LTPWw7IuBkNxOGuY4d4x3DJvJU4?=
 =?us-ascii?Q?yJJV1Geq+DXwIoPxlofXJtGZMYb9afYSSZAASlWjoAIJrwjK2if7m2r2P8WP?=
 =?us-ascii?Q?LbH2INI4IJlwQN0IA6XCDUR9GOagiha+PwePdnnelJYJBUb3M04CDwjQJhd5?=
 =?us-ascii?Q?ddRISy8tZPjueOSwus2/TnoJADbq+3JZ4IoTosN0NPjkwep2RTURBtahQzYt?=
 =?us-ascii?Q?3MHddIMuSajBG3Q95Bwgtc0e4Jo0klo3GTgnfDzlDLZpnA/qv0AZrVp1iWaX?=
 =?us-ascii?Q?9hIliSWLRl5HsPxWed5ZlfCHTJuPtLDoco2SX6n1ffiejOKcY7o+GyLvn+Xf?=
 =?us-ascii?Q?eA=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eaf1dd82-b7d3-4eba-6981-08da6b978c2d
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2022 04:06:26.4085
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Fct9NIZs4KN1z6Fi/V2HXrKYc/3lYBTbkg0Myx5lVznUmY6w/caF+h+AImjAbssISHK34GCYPmgWn0tho4BDFG0whL8ii20kVvUiJ/nFF+g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB3919
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
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
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Acked-by: Jakub Kicinski <kuba@kernel.org>
---

v14
    * Add Reviewed and Acked tags

---
 drivers/net/mdio/mdio-mscc-miim.c | 42 +++++++++----------------------
 1 file changed, 12 insertions(+), 30 deletions(-)

diff --git a/drivers/net/mdio/mdio-mscc-miim.c b/drivers/net/mdio/mdio-mscc-miim.c
index 08541007b18a..51f68daac152 100644
--- a/drivers/net/mdio/mdio-mscc-miim.c
+++ b/drivers/net/mdio/mdio-mscc-miim.c
@@ -12,6 +12,7 @@
 #include <linux/iopoll.h>
 #include <linux/kernel.h>
 #include <linux/mdio/mdio-mscc-miim.h>
+#include <linux/mfd/ocelot.h>
 #include <linux/module.h>
 #include <linux/of_mdio.h>
 #include <linux/phy.h>
@@ -270,44 +271,25 @@ static int mscc_miim_clk_set(struct mii_bus *bus)
 
 static int mscc_miim_probe(struct platform_device *pdev)
 {
-	struct regmap *mii_regmap, *phy_regmap = NULL;
 	struct device_node *np = pdev->dev.of_node;
+	struct regmap *mii_regmap, *phy_regmap;
 	struct device *dev = &pdev->dev;
-	void __iomem *regs, *phy_regs;
 	struct mscc_miim_dev *miim;
-	struct resource *res;
 	struct mii_bus *bus;
 	int ret;
 
-	regs = devm_platform_get_and_ioremap_resource(pdev, 0, NULL);
-	if (IS_ERR(regs)) {
-		dev_err(dev, "Unable to map MIIM registers\n");
-		return PTR_ERR(regs);
-	}
-
-	mii_regmap = devm_regmap_init_mmio(dev, regs, &mscc_miim_regmap_config);
-
-	if (IS_ERR(mii_regmap)) {
-		dev_err(dev, "Unable to create MIIM regmap\n");
-		return PTR_ERR(mii_regmap);
-	}
+	mii_regmap = ocelot_regmap_from_resource(pdev, 0,
+						 &mscc_miim_regmap_config);
+	if (IS_ERR(mii_regmap))
+		return dev_err_probe(dev, PTR_ERR(mii_regmap),
+				     "Unable to create MIIM regmap\n");
 
 	/* This resource is optional */
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
-	if (res) {
-		phy_regs = devm_ioremap_resource(dev, res);
-		if (IS_ERR(phy_regs)) {
-			dev_err(dev, "Unable to map internal phy registers\n");
-			return PTR_ERR(phy_regs);
-		}
-
-		phy_regmap = devm_regmap_init_mmio(dev, phy_regs,
-						   &mscc_miim_phy_regmap_config);
-		if (IS_ERR(phy_regmap)) {
-			dev_err(dev, "Unable to create phy register regmap\n");
-			return PTR_ERR(phy_regmap);
-		}
-	}
+	phy_regmap = ocelot_regmap_from_resource_optional(pdev, 1,
+						 &mscc_miim_phy_regmap_config);
+	if (IS_ERR(phy_regmap))
+		return dev_err_probe(dev, PTR_ERR(phy_regmap),
+				     "Unable to create phy register regmap\n");
 
 	ret = mscc_miim_setup(dev, &bus, "mscc_miim", mii_regmap, 0);
 	if (ret < 0) {
-- 
2.25.1

