Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAD295AD744
	for <lists+netdev@lfdr.de>; Mon,  5 Sep 2022 18:22:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236224AbiIEQWE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Sep 2022 12:22:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232053AbiIEQV6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Sep 2022 12:21:58 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2116.outbound.protection.outlook.com [40.107.102.116])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C5E65B071;
        Mon,  5 Sep 2022 09:21:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YW+kREuEJLnEUzq6x1bRd26Q0/LB8O25LLKtgnlDq8S3QcpqmMihAg9/mrfSM/90naNMWxFdBiDOfx3RlDEv3RhGizV4F/IU4uAjxyNuatGMY6HEWOQQCnvCf47YyNMgks5hw8Ot9PBuP+j9VLTimAhHbo9IMC9S2uWWirlv7X05ymuUq4Qow1BP24b3eThQuLZd04qVBHOdLfPo2pt274+R19DwF7jVjQsOxILxVgKudEzQz3c4kVHLg9Ght4oXCFJ/XxiCNxeqbYvXwhvKOAfjKeaJ5Ym2cPNayzJttKsQyy5QwQ58Ux2aVFSNAd9iOn3UoG4eQDUfJhZl4oz59w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z39i6OC/sPmsXF/Eki5x4NJ6S/zHYKHFcrA55K5fD8s=;
 b=g/mat44GDu2g+PbMYlEJQPA6aGhk9kHcPBrvW+WBKxc+8RzRwfSjz5o27ERpy8F8CogYqoQs1+VnYd3N79lZo2WsldGao7YogjpnV7NNGKgGt+hKpsHVFmQW6dt3yWySy6vsWY1xV9A7hm85kWz3iH/Ib6tqPP5rKeZbrov9sUPL1ziygaR9nsOyze1iPbs7gZWmsqgvK+9MNU15wFzjOEoZjQckhnAMOaI7y25s3LdsDttwDA4ujs5BYdHkPdF2c/FkC+NPhmxZM5wBbQV1QIEhKrcsJf9I8/8PjXUChi+5Adq/hAyZKkObwV+RBXQ92hqxhYKPF9W5W9V/xhtRIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z39i6OC/sPmsXF/Eki5x4NJ6S/zHYKHFcrA55K5fD8s=;
 b=rZHfCnX27tnAFg63jHEHeEZps0qYYnnvLF0K98vGv+yqeRiLeELQ6+ci+YGO9YFZP5aJ9TakFLAQx9MxcNOaSC380XymQvD7MOxV0x44mmR5652RnznhZx2xhVJviBD2Z7fFByqWwQmNn7KuQqb9dPW+gJEV+Afji1okR4xYy/Q=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by PH0PR10MB5848.namprd10.prod.outlook.com
 (2603:10b6:510:149::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.14; Mon, 5 Sep
 2022 16:21:51 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::38ee:4bfb:c7b8:72e1]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::38ee:4bfb:c7b8:72e1%7]) with mapi id 15.20.5588.012; Mon, 5 Sep 2022
 16:21:51 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-arm-kernel@lists.infradead.org, linux-gpio@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Cc:     Terry Bowman <terry.bowman@amd.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
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
        Rob Herring <robh+dt@kernel.org>, Lee Jones <lee@kernel.org>,
        katie.morris@in-advantage.com
Subject: [RESEND PATCH v16 mfd 2/8] net: mdio: mscc-miim: add ability to be used in a non-mmio configuration
Date:   Mon,  5 Sep 2022 09:21:26 -0700
Message-Id: <20220905162132.2943088-3-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220905162132.2943088-1-colin.foster@in-advantage.com>
References: <20220905162132.2943088-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0263.namprd04.prod.outlook.com
 (2603:10b6:303:88::28) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c8cdc550-1c4a-47f5-1803-08da8f5abd7a
X-MS-TrafficTypeDiagnostic: PH0PR10MB5848:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7B40ZIY7Xiv6RfSaL6JID76/pAtXhre3XQZBzDHq0yfXZXT5OM9Pyl6JO63G/ccElTuJDR/oJiZj+Q4pRRzJgsdjuEujlhdDCnN/gczE1WZ7EJYnAo0EU9eoGDvwkwavKvr0hrXfe3Q6CXM4HTWEaTGjTRFZjsyPs/oBO2GMeJwbWYVggXsRVHtDZwHqKJjSAuNLww7wk3fNY0mCbuHcCMLJiswWOnZ7sXHR3wj8RGhvnMAvqA65lyOaiyzqJV0Ufqbc6UtTcPd9RS3DE/MXXojIkJNy/XNWVXKkPIeXHalOjmtgFW7ACGfAMnM1oucYbSH7dzm23D9TdJFJ56ufJ9e7LK33avUx6njoVqase+2yfjThTyHtZj3oCUBd2KlXcOpCKPwabofoNNBbaEfJOW5ByPtuVq6AoOzrwOj+DG8tic3gGsGp3JLS79Hxj9HmcKGz/BoaL/35Ppadt7q2IpmCjI2F2nr6ONOFyOXk0O9k/OR8/lHEs/FIlcqltCVFlErifbqmWvMNsqXCqnlIrz27Qh8Uig5PqEy29uwVrzKvCmhi7hbaJ2byY/ClX0/QGT/FH8slvlRIrWtvv8piCOiZM822kcYY8qtCWktCfGI1/wp3/Sayd/5bGRP44yBc3AygbPI5c1KkKuilEciVT9d63Hw0ssUbzwpYqUCcrVw6HbDnk0FYfc7EzeiEFi19Ly9Ow8fdPRmPmFe68t84b6kmrZScyiUvTnLXCPxMo7GgNuXlnuThUVIBGE6l8GwO3yV3eVV1tIayT7ATGvxcEg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(346002)(376002)(39830400003)(136003)(366004)(66946007)(5660300002)(8936002)(66556008)(54906003)(6486002)(41300700001)(6666004)(107886003)(52116002)(186003)(2906002)(1076003)(7416002)(2616005)(44832011)(6512007)(36756003)(6506007)(316002)(83380400001)(26005)(38350700002)(38100700002)(4326008)(86362001)(66476007)(8676002)(478600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vleuX1umPgXxqDxyE9g2OImdwCnwY0eqscMbo/q/mOLnpLACFhDH1OeWlCfe?=
 =?us-ascii?Q?1KD1dWTKw50kXvGJnzG3PL0NRMOUE8aqKpvKL4KhRElcfSvQWSiXgSc7CB8h?=
 =?us-ascii?Q?x9fY3+Pu7W0nGmRmnjCs7MSuT85qet2AIG7JuGxkB6eDcCZiXtg0Gpyn+xAL?=
 =?us-ascii?Q?iyNcwnClubryV3MosxdAncgDoN1cJLX4wgnhWpTJIcKX1KbeKe/DIgjVlmtj?=
 =?us-ascii?Q?EGSzjfPLwUPij/SIHanlgNx3KUacwNUxNPcQ4yoOvzYgbTPCyFMj/xd4SSNe?=
 =?us-ascii?Q?w/heKTTi5ucQwZdheDrvasolpVD8Op8LOdqTzvHRLLHumIWBMBK8A85NV4/H?=
 =?us-ascii?Q?xyKIMrm5k1ZlX1omal3O/CAJ2kPqfU2F2wW4OjczXoFTOZ0O8xSSpqDUPKyO?=
 =?us-ascii?Q?6gverC5zCFRKj7dzbusqpamxd0jZmP9UfI2o8ukRG1gp1T3wULO/pghcC8tf?=
 =?us-ascii?Q?cuMoVPAmxGog788JAdcN15NfXA/dlUiW5xSYglDwNKN8OtG4p6l/pndlUMee?=
 =?us-ascii?Q?W8tlaHih9svFROj137v+LZMKHJdqq5f4+vMZR1L5qkmdghxrVrJ1SNX5c6hS?=
 =?us-ascii?Q?P11VYPL8IRljH1c6+IvT2nTCppuwg7oUzDssaG9GDS6+bggFsWAaY+mEw9mS?=
 =?us-ascii?Q?iENfkHzKh9SUz4xx4u4qmsNIb6uLQ/cqqfv2pLGW9mD+wFMan3RdXcPGsMZJ?=
 =?us-ascii?Q?BDXqrxTYjAbUFsiiPjJPNt84emxhh1HpVBGqsdgIE1rXDGQ0YJuA5i+lxAXD?=
 =?us-ascii?Q?PHLs0RnjFSZJ+eS6yi84BrbT+aLiOhGObTqZmaOEi607+AtPGPzzOn4aNLw6?=
 =?us-ascii?Q?maAfEB66I/eSdKXgAZwrSmjcT5tlsPN1//imDLabY0xDvDkPQrh+XF0bNeyA?=
 =?us-ascii?Q?fS9o9e2qw8zf8Ug3W4h6mg4vz1FQdrkdvNsKwFqO0EboZMxHe30ta3SkNzA9?=
 =?us-ascii?Q?I7AyFWzxTfKIdVYTCqZ1C4fbLyAbjDPML42zrjv0Cs3QSaNSL4+25aAWmeoa?=
 =?us-ascii?Q?kH75L2/9u7APOwf+MkO6p2QrJTkjOttRUJmIcxWB0cmmT+1fhiOM90MIknFA?=
 =?us-ascii?Q?qycMOPhTth6DWsuXNSxNN+ajEbC5jPPcHYoGzj/SBqm8g6XW/0kQ6mYRCuh9?=
 =?us-ascii?Q?UCm9zXfYuhw1Dgj6H3Bf48rGj72sRLaDheLcwdFro2HjuWXITtK5bi1GoJJ+?=
 =?us-ascii?Q?I9pAjm7GwAAGhyr4X15uLJhR7JAuUhgJy50D2KQCm9Ga69Uc+vPdnVhLkcBG?=
 =?us-ascii?Q?Wd95BD10o/xM8D8pIC2OvYxGamwr/zzPQwYJ8/BRGW1OmtlTLOxezu8Bnpph?=
 =?us-ascii?Q?cl2Qfa9SkcQc/Y39eIwtZd3gQ7xaptCsl883Q17UQNVg5lbcpl7urYo6E2ZG?=
 =?us-ascii?Q?4Hl+Ygwi4EgnOTtgIpFGlozuZN9gUTTc3wfJobCgHnuKhMlcFpSdSZIkjYyR?=
 =?us-ascii?Q?tL4ikbcTeeo7vz1FX0J/0VB0bV5dDMcFCYKCfN+bYtOIh7xrcfBs0h2Z77xl?=
 =?us-ascii?Q?7zqz6FWEsNHAH4ia979eXu+9rrxeMa1jnxqjGZShKiz/9FRATew/FuB5MjVQ?=
 =?us-ascii?Q?+pu26nFQwEESQfDd2X7goHWlB4eTWWTH6+iACp5cdPwtlONE0uExHEJ+mw9V?=
 =?us-ascii?Q?rg=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c8cdc550-1c4a-47f5-1803-08da8f5abd7a
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2022 16:21:51.6632
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7ui0KkZmApi1i4wZwohk0i0POxt0WUU1wKIk+kEVZceukn/whu2Vt4oN0byfvn2TXdz3M8Yu4Bz3uCRr+IcqWKq5EWW6iU1K+OfDPl0VQI0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5848
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
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Acked-by: Jakub Kicinski <kuba@kernel.org>
---

v16
    * Add Andy Reviewed-by tag

v15
    * No changes

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

