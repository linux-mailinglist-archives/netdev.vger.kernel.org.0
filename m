Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CEDA59272F
	for <lists+netdev@lfdr.de>; Mon, 15 Aug 2022 02:56:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230134AbiHOA4P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Aug 2022 20:56:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229889AbiHOA4K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Aug 2022 20:56:10 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2104.outbound.protection.outlook.com [40.107.94.104])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E42B8A46D;
        Sun, 14 Aug 2022 17:56:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OSY6txrkPbDtFzocmXzk6NVmV+I37F2djLmyr9XW4ejDeVq2bC1L60MdAIru66vsBOTgmB7mPEgN+nzPEfkRByWsLYliABou6d3tIt/30V2Nf08pwm26GTpu2RZukakCVVqCP9sVk17WJc9QZ9s+C6AFyOA14p6kDvKYtLTkTS7wdWXTaMyohAYyrAhbvyI4UdYE/8de5rnwjfT7g0iEWEocsJHxDue3dhJTtVoUmCbJEI3wyNcSKg9PfZ7FKrOM2uLPwKceS0uWG6dKnQXxLWx0ujSjX/8jfd7Oc0q92I9BpWmZShBxzz4EwVT99SOCLD8xyht3PKwmw5EGBJuu9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z39i6OC/sPmsXF/Eki5x4NJ6S/zHYKHFcrA55K5fD8s=;
 b=j03hwXRRiI2633nOeuIBo4zRjbEH1cmFnG2XjnqFj+J3hHsPEBbo4OcWZzwdjfnsRSS8/FRleKRNZB2i+Ph/wf6ydsYjdck+Xoo4hQ1n92mToD0ukMv5SuG6sdFMAVx5Vhjg+Zp61QgcAPjaulfDZpx2RDymhYnECltMo7DS+GfLRjSANmQc2HDeNqn2/uSls2kxg5y/Ym8DKB3aeaZmK8kDmD1ykGm39Vf4/8zR5DuBnKu/iNkk9hk4Aec5TqV4U/F6RZoTVTrVH5pvJFQGKnnJiGdaOyrrH+nJc2+Eh2bu6Qef4pD9UT7BT5Ufz6kXwlua5UX3+hfPZX13/cdY+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z39i6OC/sPmsXF/Eki5x4NJ6S/zHYKHFcrA55K5fD8s=;
 b=RinNivs5WSTJUX+snVhwLYvSaST75WdpfhL3NxvDQHhaN8NTkS+YFJyALRcUKamGWDmcdq/o0wo+mfxzkzJTNtGSfXlw7kyyDGFThzTzSHQ4k0nR79haZ31zBTAwaZ0dqYvDYbVtOTFtGe2O97NIzjN/G9Vm4hGuBEPA0wZSobQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by SN7PR10MB6286.namprd10.prod.outlook.com
 (2603:10b6:806:26e::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.16; Mon, 15 Aug
 2022 00:56:08 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::b869:6c52:7a8d:ddee]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::b869:6c52:7a8d:ddee%4]) with mapi id 15.20.5504.027; Mon, 15 Aug 2022
 00:56:08 +0000
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
        Lee Jones <lee.jones@linaro.org>,
        katie.morris@in-advantage.com,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH v16 mfd 2/8] net: mdio: mscc-miim: add ability to be used in a non-mmio configuration
Date:   Sun, 14 Aug 2022 17:55:47 -0700
Message-Id: <20220815005553.1450359-3-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220815005553.1450359-1-colin.foster@in-advantage.com>
References: <20220815005553.1450359-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR08CA0034.namprd08.prod.outlook.com
 (2603:10b6:a03:100::47) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d6bd55ab-f756-44a4-554d-08da7e58f058
X-MS-TrafficTypeDiagnostic: SN7PR10MB6286:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Fced/WnZ7B80X49AnITRVcGNNFfu5S/SVFsMTUtlZXG7sx1wdtkDxZYm3xhhZo48R3PhEPfuOSYjMVv0I7vJh72HiVge28pBbWY79nzAHfZcLRx++cPdqwHJhfPQEHkM5Xy66rGepxkgJSiuoxR77IaO4dH6EdXHEapLIVIbRxxXCbNJb5RG0dckoMaFyavWIYDZSG0ro+xGa9X25DY9sh/J/t6snxtsoD5wvRzd14eenlh+ZqM6Oat5k68t2c2fXJZfAACwwCC+UCxfsEvJrRauUZA3cPvGoTznyohByRATPiY7ZZ8/6tWk4D/I7li3aXc4z0JVJiOb52isDj3ashuvRM+u6XHzbt9eG9sI6WwyNe2K8Yc/nS2UZbkz4fCWbIAevehSBTYga59qFq3U1GN2PVe3GNcshgdTI8I4tu4I/SmO/1bdrRKGl2jXv+NfSfSQ0hJMfQQxvv6hwxC5VKz8PqEx3bU3Qc1/9GCSIUnrJX3m6abGu95K3Kia9Fu7l5hIVRDWVGwUn8vzs0t7i7Sc6mKVNCThsRQbOonQIMjq+7N8hE/hX19lnc7eS/NlDZKp7Nla9bqJi2QduKDVEn0wGE3crHY0KBT0kMmc+TYnOWuL6irzKTcHjHAZAneQax1ENR0/9nkKdsQyMPAqBpCISsU8heQo/yd8x1j8Ci9gzKSw7LElVNTRtmOsNyJakP7XJvjM12U6DpegbI8pWy2Ut8MO9rjNtsy8yr4OGHrkQbhjKQM3JP66cICEJbkoyXSb0epR/LarqZqKO1dr1VtrFn8fGPxT5QUlBYfNQUg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39830400003)(366004)(136003)(396003)(346002)(376002)(38350700002)(5660300002)(7416002)(2906002)(44832011)(86362001)(38100700002)(52116002)(6666004)(41300700001)(6506007)(478600001)(2616005)(6486002)(186003)(316002)(1076003)(6512007)(26005)(83380400001)(8676002)(66556008)(66946007)(66476007)(4326008)(8936002)(54906003)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?tsa/xYQg2UV/otIrjozk5DUAoHA7/q2b0plhy4P8XDKj867m0YnWIOh8jrWM?=
 =?us-ascii?Q?DzMOJQOhDWh1KVuF6xxS19yVnDW6fY6SaM66FtvoTv2pYwdQwibU61kZlf1L?=
 =?us-ascii?Q?L9AlDMN95e7uD1KLw+hGRJG9OWT7xSHx2qejwDJEkazsi9+4lTB/8eKp9dY5?=
 =?us-ascii?Q?nXfELhRjENbzm7rxzqlHt6SOwd4icNhgyvh97+Ej8Iqj9eN+W8JC3fUSYPg/?=
 =?us-ascii?Q?LpIkUToHRBe6HiS0ekT7fqG95xVzFDVBdZ0RP8nnXvZFvCbuvynx0cc+1qEb?=
 =?us-ascii?Q?AL96ulA6PzL02aUnQj5KE4mEO0lH72CS6JbdoSvBzUjIiCbvRB8ItXI/w+fy?=
 =?us-ascii?Q?U71xaESk0Ecjz/jnLviDjFBrhWlkn/XXMR3WosiCYq/U9IgkZvhrRBjgRzGw?=
 =?us-ascii?Q?czKYMALTZh52VK8i36S1v7cPn0pvozdv/YDIKLA/fL3viChb+OMFW0ijfFbH?=
 =?us-ascii?Q?kd4uRQE0NnTHu0GOeweO3Upqwy3WgOc8NadD0JdnF2+g2UN6Q3lTLqbgQ9eR?=
 =?us-ascii?Q?e8vX8oucZNeDxxCeS+Qm7vpfde3b0+KmZpzpviPxHxOisL6p2BMUH51oI2sF?=
 =?us-ascii?Q?ML35dgyzTuoJDWYwWCsTBIw6HnrWAmWnBDrH6EVrm/TPR9/hUROp3vBGlAoq?=
 =?us-ascii?Q?ZIP6M1aYUpdUTOzmogWAh5XBmx3ZSEAUxLz1JHMTRFnpYbv5Qqp1HgBMr1P+?=
 =?us-ascii?Q?wFKggI8ui9cC7UoLysw+3hDg0Q6+nz21fFSzRYs001MtMJrlPvfldDlhjJG6?=
 =?us-ascii?Q?PkNaBbxA6INMYHp378U3WLC98pQs7D/OrOQ5t5j8eRh0sMzZvNqAGjcf70w9?=
 =?us-ascii?Q?ItS/dEbqZ9dpjcJOvg9g5DT7/108Q5sYMGxltel969Jv67un64foD5PsHyga?=
 =?us-ascii?Q?G+YEt8xP9I6L25rJxPzzaDkr/bV2o7D6syuJWvjGqmwXBCcKVClFO89iUeKJ?=
 =?us-ascii?Q?mMYjFdksZ/DEoQGUlNgXQ2/ShYC/caxqoI6uX2eLvn3B4VqVgs2p2d0kLxWk?=
 =?us-ascii?Q?IbS5hVqrkjNfSUacI0zF/YtIk7XM2iZ+w++BPxdXP0V41p73kb79R+DhgYxo?=
 =?us-ascii?Q?QyWlPF/biY8MP8o5VlHEtL4Jd72EV1fIYLwlOp9oTKeTY077Kqr01k9J184Z?=
 =?us-ascii?Q?GBaDsOqoiR6CLTNIOroGYG94mWeYTFWYrIgA98Mkm9JI0uiWJEsk24eQXrGU?=
 =?us-ascii?Q?BuZdSmK4t77OPOg0H61hAX87oh7DXCQ8Mx9a9hWujF7EK9yaz1RieomYMm8Z?=
 =?us-ascii?Q?8jjV5Glpam0SxCJX7mzS7nKU0vWiy/PgRcms3b08BmiPgPe5BzTrqlcvdxNP?=
 =?us-ascii?Q?fc8Lp+TX85wD6WfE0Pqkw3ZaF5a+9Mpa+MLW1Nz1TA66xJugLK95xjp+uB53?=
 =?us-ascii?Q?gnfMKuHXa1wdYuTexxhcNOL/ez16fNXOSfs6Xceq0UAMAbKeSL7fOB24G7dP?=
 =?us-ascii?Q?nKsEyV2/KPpHvhl6MFh7XVx5GBRbK1aH7VTCwr2wu0phXzBfF3JXBEoHdPGs?=
 =?us-ascii?Q?rQkX9SNWpr2izbFXJTkbltYABuH4jPHrPMInnrz69y2JyGFgg602xcufBXPF?=
 =?us-ascii?Q?wX521IyX1EraFGUjYxgbbnYGha8bRAktq3Ci4T5Ob1NA6jtWUoStEg849rpQ?=
 =?us-ascii?Q?dA=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d6bd55ab-f756-44a4-554d-08da7e58f058
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Aug 2022 00:56:08.2920
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: v9uTwCym4L7FIpgx46WuNbzzTK515KlI7EiGCydfpeJ/oXDhDGWxpS93q+b1HY+1+rvf+no1LTyIITXBdVHJ15i6QlUivaXtl95er3Gk0KI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB6286
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

