Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FA91588709
	for <lists+netdev@lfdr.de>; Wed,  3 Aug 2022 07:51:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236174AbiHCFrv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Aug 2022 01:47:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235740AbiHCFrt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Aug 2022 01:47:49 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2121.outbound.protection.outlook.com [40.107.244.121])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D565275F3;
        Tue,  2 Aug 2022 22:47:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dJvDrkBhpjLBghSyb+1Nd4UJ2I5W2m2zf8VA2DN4G/0uJipoNHXlAsk+KKyZDaJ3wvSbLHv/+3mc2H5uzbSNMmNB93Sj/Mx5fnMaZRjEvqqKPiNSf3hNR4usbj20yTuBtQdrQpS1Bts2+EHSi6TuUD4oJ67XbI2idclhtvGud6+yl5SjDx6xfvdKarruDC7dCQrnBp2Rmiw8BEoqyvE7T+Pqqx1vmCwcUoF1tZy7koPcgH6X4zwNnaDJBCn+1NGKPgsbNQWcMK1Ijc79uQINWfhZnUd8xQXs12WlrmE6kO89y0WKE+XY5HzZS2e1G6JtQU1EZlTvIJKLFQJh96R6Kg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9uVEXnd1+BBfpjQ6xPn099CA0d48ZgPj2KtjTmL7xr8=;
 b=antFEKtLGcoXk+++tGrDMDFZP6tI2WWpb23xpmG2BVz5gGGuSnEEF7y6b0IJUT2HXyITnBQDS69Mdp/zFtpBEpK3/MG335ao/VssqQX+SvZqVhjBWfdEfrhbM5O/thdK4xXw/YpiVflzgxyxG8kD8JVHkda3EBLIKcOqixfLw7wzjCTveL+dfMeyeU+XC355h3f/L0RTkDJjUGfxtgw2GBF3lDbT+vW3Uo1mq3WIDeoHb6pDjv49JBESMKVvMDAEpDXI4onjMizRSqTuq9ibnDaiqksq+mcYJ/tP6vpuetGq3LqsWC7KOAPhVAp9NSnX/hSJP0s6YxKxH15hYxnECg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9uVEXnd1+BBfpjQ6xPn099CA0d48ZgPj2KtjTmL7xr8=;
 b=RJHAtXnJwNs0jSZL92iq9lLcdY7QJxrvpxgWKV8qFQYraRDSvUAir75QPhfJEPeZ86SKMPMBEtdmb5GFpfKWdGyrXWgagvtS02ltvW33FJzMf1pliSl9niOOD4urMVqv2Kbs17qczDBDaRNI7HRhm+4CRqLVZUQmrPYfqCQM/tU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by MW4PR10MB6438.namprd10.prod.outlook.com
 (2603:10b6:303:218::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.14; Wed, 3 Aug
 2022 05:47:46 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::b869:6c52:7a8d:ddee]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::b869:6c52:7a8d:ddee%4]) with mapi id 15.20.5482.014; Wed, 3 Aug 2022
 05:47:46 +0000
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
Subject: [PATCH v15 mfd 2/9] net: mdio: mscc-miim: add ability to be used in a non-mmio configuration
Date:   Tue,  2 Aug 2022 22:47:21 -0700
Message-Id: <20220803054728.1541104-3-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220803054728.1541104-1-colin.foster@in-advantage.com>
References: <20220803054728.1541104-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR01CA0026.prod.exchangelabs.com (2603:10b6:a02:80::39)
 To MWHPR1001MB2351.namprd10.prod.outlook.com (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 49ff1ac1-c566-4b02-5322-08da7513b102
X-MS-TrafficTypeDiagnostic: MW4PR10MB6438:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5Oiw9+0lTxwb8DCGcVCxxdHGBksxbQC4MnlTynwWrA/3ibTa8mK/ysYzyXnZfTum4fg6ffA418aS4izyt6CzfTm1uysPgqY7/tSPk0LGIrQJ7QfCj+/pxTHGJqsKrgRfLsNmxGLMWOM5zGFsUZwoCA0wvok00BAFyR7C4ENKDdNLbV/aVME9vL+cAeJ4soVy04P+itjazmrP5Kd3CcX5/MDMCSt8H4t32CxjAXH2SBZioD6Jl71uUY9jQ0d9iPJZ3851qV6hUiv47qyJq6NP1G0TfseIqPzmPHisG+I2SHhriIXxDFOEX9UEHEwfjD++KcDWsnR234zvOxDaFhcktZABCTuY8Rkn2xYBykrupENIEogFKAbzRwFDPdNLvd/gyP61Ol1hV4W+5ZpDKgtLhmkkc6OoKLPfYEXM5xg+Fpqq5seXV0mjV+fRUXQVZapFDJqKYhLuJFkwwbvOJR8/zIxauTUB9rZSu770ZzPFp6wwIDCQ8bKS3X12u1qbIXtaEKYLQ9wO4qIcpLOpix29RghqlcrqRIK4NlVuoSZcNnbtoAi2T7FHmW70Vy7ZTSYBLFitpoEwmClADgfpjfZ6IscYSCHZBMm4zqepUUvfu0aCeT9082KKpjAP4gHve3HPZe/MAutaxbsTLSj/rQeRy2XAKd6y9AuGRgFvZh4qL0J9ghNfuK9178WF+Vds6zMm2nWoNcCoMCE/7o9MRZiln8njcfCpapp4kqYcsOpkt/4gfDxL92RbHILndEhEC6gXFlXocXZDtPvCPh58ymyRJQRQuDC6kVJU1+4a4Vugckc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(366004)(346002)(136003)(39830400003)(396003)(186003)(41300700001)(6666004)(2906002)(6512007)(26005)(52116002)(1076003)(6506007)(107886003)(2616005)(38350700002)(38100700002)(86362001)(83380400001)(5660300002)(36756003)(7416002)(6486002)(478600001)(8676002)(4326008)(66476007)(66556008)(66946007)(8936002)(44832011)(316002)(54906003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HOYnmv8C8r32kgaYa5tlEf/nCtMrlInwhe+qJVkrsVU9dFXEiRC4mCAAtcB/?=
 =?us-ascii?Q?eBT+C/bj+v4X+rO+BKStqOHONX40mLlRy7VExV6fI/hUclMpvBa04W2BX1uz?=
 =?us-ascii?Q?8VCne3ZjuUKHMF4WRZNfi9ie6OPv7b/7pQ9HDJ5STz/ofYztNHSejcbCzSFb?=
 =?us-ascii?Q?WUwecDN+D6xcwuQ9wLupXEEX1W4LAgYm1+l3K8fL6MevLPI/wQnCGfv0X08/?=
 =?us-ascii?Q?VBwmPUur4zbdQBNBu2Q6pFRro8ePyaZRbGz7YGHw11Rs26hZnrWOlgyG5RRw?=
 =?us-ascii?Q?9QBdnRdOqrwzJttxJRqoaR6HxKlO7nI5NU3fft+VGGlyEp4CotdXw50iKxKz?=
 =?us-ascii?Q?NWAahkvtf1WdObcQGvVkrpf5u6xLg5OZB/YZ/TahtcUR7PMYqdAI3Yb9t2LN?=
 =?us-ascii?Q?XxtOIqXXZD+HkIGDNFmTW+EA9B9VFXVk2+meyVuWGQ+jWNzgFqvLgwdQN3r9?=
 =?us-ascii?Q?ouhaTrk+XMdpecIJTvO9Ly+u5lkysAjXCzBxij1GWxptxykGAktPUXwV83fR?=
 =?us-ascii?Q?w7BlLqmv3SteCwKvDxVnGBajN9rjFdXdOlxIAKeA9pq7JerBTGfoe7NG4RcO?=
 =?us-ascii?Q?3i7H8BBewbnYL8Fau/44dIZF0GQQSQ0v1pF1wl3a9dEOxFw2KgTOOsgRjRDK?=
 =?us-ascii?Q?SozUtPw8/109A4nDSeD/QbB6qup2Pu7nqgCvadDKR1EgCO6eUD30cPLfQjJY?=
 =?us-ascii?Q?/QEqX63rv/fMYKe26fN6FoOJ9aIgPHbAcmPkubpwjLVP70Nn9QGMdI9w1ckT?=
 =?us-ascii?Q?Pn6mpEgVctm+cnqXyLCpAMW5/tGtpw2zR/PwgscHrFH/+eI+oABWq2syjj25?=
 =?us-ascii?Q?9w4Ll+6eU9BVgg+Ky8PcM6vDCgkzgOHCHiy2/sL02hQq4rkiHpFwe6Hjqerx?=
 =?us-ascii?Q?cJRAD+G3oY07xMKv5mqy18Z6OoDG92moGMBEey32l5GCnlvC9LuYdXWOCnjt?=
 =?us-ascii?Q?pNrPnI8MSCD+K2QJA4xJtHC7wg88ijAVt09wKWTZnmWWK32dFl2nOiZaL8lQ?=
 =?us-ascii?Q?VC2SHYDbrzhajxfhVEIf6q/Ypi06upetp7MRlNAPm6jhmLvGEZZs853CbHEJ?=
 =?us-ascii?Q?YGbW9iTqY5R5867m4PItED1ZcGimWxR3UP6C7Fe6xcBhahN0fyjfQIZsvMfW?=
 =?us-ascii?Q?flnd1W5qY86qrm+3YemXLIG/vBVHMn2DZPQZh0A/Kr4l1t8DDkiYEygw0k5q?=
 =?us-ascii?Q?Pry0YwnlfdPz6LrRHTVyyaNkZkmQDTs0Dz/bccLGO2DXpMJ/7sKUX38KrXQg?=
 =?us-ascii?Q?sMRvvvlvG0Bj9OMULRfLbLAmUys/FyidtPPeQxpA1l9tyT73vyNVnXlE5aEl?=
 =?us-ascii?Q?9pZYxN4B++EPmdyrWlB+5DP20dAmtJFm3oAI5SLm+FvmQJWFVxdnjwiZKMiX?=
 =?us-ascii?Q?RRxBOHd2MtORE7q2iNRiL6/UpCE7snBrqPiqfFk/DFpjZCJ8KN3g2cyvGzsA?=
 =?us-ascii?Q?3Bg1Qg7DzQeWGllYT+XlYkxyJ+ZMvufcg9xWvPvOp0V4SohVUcuXZXT6O1bx?=
 =?us-ascii?Q?viwvp4QewvKKX+0LsTV057K4KWCrhRn8+cgGC5gyon8+KHpj0H/gOqIR6DT7?=
 =?us-ascii?Q?7mmjLhha5mz0D0l5p2wxnlhgtRnD7jLxfe0JZw8JSdRPBLfxgr2cDc2rJIrB?=
 =?us-ascii?Q?7A=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 49ff1ac1-c566-4b02-5322-08da7513b102
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2022 05:47:46.2300
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: o1GyD8LqqDPXS6beGL1smBkQpzUXRGnFIlWc2463Sbm7ZX6cEDmlKAqPdPtqshBftnVkCMHJDngMtk63hC7jREK9uFaj7qoYwTQwlthoYoo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB6438
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

(No changes since v14)

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

