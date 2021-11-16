Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5803C452AD4
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 07:29:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232331AbhKPGaX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 01:30:23 -0500
Received: from mail-bn8nam12on2139.outbound.protection.outlook.com ([40.107.237.139]:7392
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231338AbhKPG2U (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Nov 2021 01:28:20 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IN6KZTnkuDELe/hBsOIcquaX9j1EjslB8fF9sNV5Lcar1ko8dJ8j/s0l5GNGb4GT3PE5Qrha9I4QQZyO+gOYR7FwemJlQ0M7EGjbzK4WoST0vvl2sU6iSTlH/7G2P0csafSzK5Lh5+atDCUj4sWuo6r522ECt7mAnl4yZ4F1NHDqBcAWc9vW3uwY9hm6unIZqTiuuqWr07WPxdmrKqiACjHkRWS87rxuzMdKlgEdDfYUwfoQrO+7Kz3HVfqvtedRyU6OUCvcCQRsO3wfvfqRGr7P5ipQncF0llth0J3hksCCSGgrmrt+/3GHJKZFwp+Ntsfk6Ku/TwOlOgngPr8Zzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aP5vNOHNYh24nisY8908T8PhKr/LVtnFiajRB5l6S98=;
 b=cQw1+3ZMDAvSTLZEyieLT23weZEAKs/OCg0PDyqfBD8r0J+cml1eRkvxQDL1c2om09NPhp9T1Yi4KUHlsimg7NHr1zAuRO3p9OFa+mpTIcXOnzGgdgM7Nl6X+Y02WL8VAWKTN6aPJk7OeXc2f9fVv/xH3TXhC4CZoLeqUTEVud4kt3p1JDVWzYNqrmZVIHNgZdpca3HXoMj/cN/ch96nFkvbTehm69IHhUr0W1m++9eaE22qUBFIsid/j1stpf+MPFQmYZVADaSPTNRrMq7zhgjNoWTbQOnv+kEUlDazf+VfzIkMls9uOSoaljArjDvN398/lnBi1KCmEN20K34rwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aP5vNOHNYh24nisY8908T8PhKr/LVtnFiajRB5l6S98=;
 b=rGhQ2/gzwtwPc+ebFF/YCe5Q5D3uMQPCiQRCHHyxTXshcHhukAjUcDnnXkSyaZW2Kpb1Vv5DcHJ5M2VaLuINsb93ZIDJhw5xX1/md1P0ETTMXGAoz3gNsksmc9aImqA7E6oLasFACtU0h4tmfNNRLgTrrljKgYz90VAVuslZx70=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by CO1PR10MB4722.namprd10.prod.outlook.com
 (2603:10b6:303:9e::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.27; Tue, 16 Nov
 2021 06:23:51 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::6430:b20:8805:cd9f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::6430:b20:8805:cd9f%5]) with mapi id 15.20.4690.026; Tue, 16 Nov 2021
 06:23:51 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-gpio@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [RFC PATCH v4 net-next 12/23] pinctrl: ocelot: convert pinctrl to regmap
Date:   Mon, 15 Nov 2021 22:23:17 -0800
Message-Id: <20211116062328.1949151-13-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211116062328.1949151-1-colin.foster@in-advantage.com>
References: <20211116062328.1949151-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MWHPR11CA0028.namprd11.prod.outlook.com
 (2603:10b6:300:115::14) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
Received: from localhost.localdomain (67.185.175.147) by MWHPR11CA0028.namprd11.prod.outlook.com (2603:10b6:300:115::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.26 via Frontend Transport; Tue, 16 Nov 2021 06:23:51 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b08fe540-fca8-41e9-a83a-08d9a8c9a844
X-MS-TrafficTypeDiagnostic: CO1PR10MB4722:
X-Microsoft-Antispam-PRVS: <CO1PR10MB4722D0F6D9C05A9B5C457D8EA4999@CO1PR10MB4722.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3631;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: T1x9bgRJBDc+JC5XsjypFNoGQYGmgIfUUIDpdp2lsZSdjRdNxLc0hfesS0f5g4cEVQw12pBl5LClNiXLzOWO3p351u0CeEFp6sEJIl4LTx0SaSL0N4yANmU4hjK78M7RxPEIZyS2laESGmZC1byojL4+j9lwBgr06bTHr8QrEwVdiXigEpAMV0dkrfL+uZiqvaxcs46LFTZC3FP/nyiOySACGARwW4B4fMTlxR6PI7xhTa/DPJAxkC652N7R5Hz9C+d+nBZyPIr0M4pG6zn9yreCDLVpcCWQJAmxc8sfokEvygDXXLPLVOYBxdE+krYaGcILijdgoAHFTFslDvcIvVTKZolYcMwiOMiiyY/l8kQqJQYibw9OGY0dT9fre+GJtEsxQIa5dra77Lux5IVIE7M4iq6XfEgyAhdloGRLV+rAXE2h74/AaNWKES3bSG5Ksl8uHxUQQ2tHmL2z0sraKWB5SbutPS26Io1VIWsTS3ERKfS2Fj7gDHwhbBjgl1XajT1edJvHHLcgYdkUvUcsb/Hg871zrgbv84+LTQF/EBhfFz78OaCv7QwoDTlypFhPIbQm+7TreUYmzKhdcXuZpNrCr/O3uX+4AYC8MlfPS4/OYHyUSlo8dqmS93LT4bHSv2IiTE0ziGPD0Ia83EquvNjt8Jthr99ZI2+DCZ/kNVMCRkNXyEYkadU06GFn0Svp7ze6hYFf893bTWgzNpvo1Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(136003)(366004)(396003)(39840400004)(346002)(83380400001)(6666004)(54906003)(5660300002)(2906002)(7416002)(6486002)(44832011)(956004)(86362001)(2616005)(4326008)(316002)(508600001)(8676002)(186003)(6512007)(38100700002)(38350700002)(1076003)(8936002)(52116002)(26005)(6506007)(36756003)(66556008)(66476007)(66946007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?k08rcOBxSFnNwexR+FZQiUGscMI5czvQ+myMSvTRcdaQ+C62uej/ONsaSP3n?=
 =?us-ascii?Q?uXGaG5H+8Ps9YZ7PKAI5PBLvRcWBfKojn0zgk2gYA83EoPTD1GY1inTRuDNT?=
 =?us-ascii?Q?rgTe9UNHkHZCKZULku3x1UvH17BB3NcDo4r2B16xt5NNGXBFW6k21sehTsjj?=
 =?us-ascii?Q?fomys4ygP+RBgrs8vUpI5gHl6c/k/WMcZFZsJ3jCfUlnRv1DFROalGuqjgp9?=
 =?us-ascii?Q?rfZVLxrk8hmJQhvGOu20T9ka5PI/bTMv20I1/tmiaCSl7Xy+W4jUq7VwKZ3g?=
 =?us-ascii?Q?kViwiAn3xBUbrpC0XYK4tmekAFdxXAS9Gg3P0fO50SwN1FXj/sM4MBf8+I2g?=
 =?us-ascii?Q?YoALRNro5y3wpTF/8jyyuTaPg66db6SoGbmvP7qvg9NfM0gxr9Hcv4pXo7is?=
 =?us-ascii?Q?1nLndd2f19FiH6J+iKmBaJG9NNdRj47tiMKymCZqpZAqr9E2qF4jFbFKfafQ?=
 =?us-ascii?Q?02VQlvZfJa7+xzpuTJw5/wD9p2dnsq7i4nriA6dBMhzXAEbJmniVlFxdAFLH?=
 =?us-ascii?Q?c+rZXjKpuNSmio2TnXx1wFDnBHqoYboaoM5IzE+ROJvAIGMCLI3wn1MW7tQ+?=
 =?us-ascii?Q?XWViDeg3ESEj+CXSPOopcDLoqxNfpmWazwTnMeinh2IWbU12ZnbEnyB1IqKO?=
 =?us-ascii?Q?fXwG2OHHaroUAPEjjch/Le16lHCKsm784/G4jPAFTRU716eGfV7KADHwnJiX?=
 =?us-ascii?Q?mNsKokLu354LdKvzrGrKU5Wnk5MyCdRvZxQqRKRVgX1JzIhXyvvcHSQXNZ7E?=
 =?us-ascii?Q?/nIETkafcXoYzQWZZ3CnNpeqXuIRgz7FEij43FNKs8etydGYTrKA7Xr7l5OW?=
 =?us-ascii?Q?IwQNojmHSa67AJuRWbAo5sp/B6MuYqz0B2aeDl30I2taTPGl1182ArFTDvt6?=
 =?us-ascii?Q?797VZ9bOYCXuZuukHEnd8a6ni8qaUdizPKZ2nNm+Aefp6H5J9Z+j4XEPXL11?=
 =?us-ascii?Q?d3Ng/pEpo7ZzukiW76yP0fnjq5cIaCbaKrqIIE5xX61BQVQlRxuCp/dB+0eB?=
 =?us-ascii?Q?XfRVpKAt+apabYAA+mcEiLidDVt6ztTynlSGy7wn2qU9glcFlh7CckUcLXs/?=
 =?us-ascii?Q?DlL6juOckq8CvXQ/Kb4oQwroRluvx4i84WYiG2IYdrRFZyka10rQxTAteMpe?=
 =?us-ascii?Q?+k7qmV0DVSrC7aK7NW8miWKfPDfgEPdrSWJp3/sw5+PC5gZ6p4IPg/OT8nf0?=
 =?us-ascii?Q?SEdwpo7ov7RTu1pogRo6FpdrbLI1S29+D+un4SNBJdk4j7o64nCwsHZV/LXJ?=
 =?us-ascii?Q?WYJdJsNVVSQduTeJYLwv40tAbOpbG020njGoKr5uz1ZoGF3eLfMzoyo3TAnY?=
 =?us-ascii?Q?PyYlTKbeNIc+WzaudtePXdlS3VFwzp6t/O4CQsGKO1M0alGp1MKiQyPbMfx6?=
 =?us-ascii?Q?lxrUfZ4EQ8o+w8fQjwp8YuSO01LgdlUIevqr3Loy3ajSnog0UHp+SKFJcbb3?=
 =?us-ascii?Q?8LY2pHzD0vADZsvqxgWGcnUp71xc3wxjY5H3xLP/nhw0AHLQxxMnvgkhgmNd?=
 =?us-ascii?Q?zMLtPy2NQghobrtvzAyxx8q54OpiXZyP0HmMqJ3U2NiePMB7n44rYeKY7yci?=
 =?us-ascii?Q?YZre4j6oC5Q5RjsJKrzKtSsjE4w0obDsbLACVDkSxQL8LMGN0zSlBnZa36AZ?=
 =?us-ascii?Q?EoKjLmKrH55Fl7SHLRHrKSSGOGzB2whrqVVMwFcUg9UZfv5WMIpeW/ZWSFDH?=
 =?us-ascii?Q?SXlzGbCpyR04OJD814JPqXU3nUw=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b08fe540-fca8-41e9-a83a-08d9a8c9a844
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2021 06:23:51.6959
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /CTEv2u1d8HF7b9g7hK6/S4jUH6w0DfT28zWBpy+lpmuLe6y35I8luHHda0WPCZWvLVqJyQ2YoucVfwMrSyBQAs++F4cXDWrLVmu9LVhyW8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4722
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In order to allow external control via SPI, memory-mapped areas must be
changed to use the generic regmap interface. This is step 1, and is
followed by an implementation that allows a custom regmap.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---
 drivers/pinctrl/pinctrl-ocelot.c | 66 ++++++++++++++++++++++++++------
 1 file changed, 55 insertions(+), 11 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-ocelot.c b/drivers/pinctrl/pinctrl-ocelot.c
index f015404c425c..b9acb80d6b3f 100644
--- a/drivers/pinctrl/pinctrl-ocelot.c
+++ b/drivers/pinctrl/pinctrl-ocelot.c
@@ -152,7 +152,7 @@ struct ocelot_pinctrl {
 	struct pinctrl_dev *pctl;
 	struct gpio_chip gpio_chip;
 	struct regmap *map;
-	void __iomem *pincfg;
+	struct regmap *pincfg;
 	struct pinctrl_desc *desc;
 	struct ocelot_pmx_func func[FUNC_MAX];
 	u8 stride;
@@ -819,7 +819,11 @@ static int ocelot_hw_get_value(struct ocelot_pinctrl *info,
 	int ret = -EOPNOTSUPP;
 
 	if (info->pincfg) {
-		u32 regcfg = readl(info->pincfg + (pin * sizeof(u32)));
+		u32 regcfg;
+
+		ret = regmap_read(info->pincfg, pin, &regcfg);
+		if (ret)
+			return ret;
 
 		ret = 0;
 		switch (reg) {
@@ -843,6 +847,24 @@ static int ocelot_hw_get_value(struct ocelot_pinctrl *info,
 	return ret;
 }
 
+static int ocelot_pincfg_clrsetbits(struct ocelot_pinctrl *info, u32 regaddr,
+				    u32 clrbits, u32 setbits)
+{
+	u32 val;
+	int ret;
+
+	ret = regmap_read(info->pincfg, regaddr, &val);
+	if (ret)
+		return ret;
+
+	val &= ~clrbits;
+	val |= setbits;
+
+	ret = regmap_write(info->pincfg, regaddr, val);
+
+	return ret;
+}
+
 static int ocelot_hw_set_value(struct ocelot_pinctrl *info,
 			       unsigned int pin,
 			       unsigned int reg,
@@ -851,21 +873,23 @@ static int ocelot_hw_set_value(struct ocelot_pinctrl *info,
 	int ret = -EOPNOTSUPP;
 
 	if (info->pincfg) {
-		void __iomem *regaddr = info->pincfg + (pin * sizeof(u32));
 
 		ret = 0;
 		switch (reg) {
 		case PINCONF_BIAS:
-			ocelot_clrsetbits(regaddr, BIAS_BITS, val);
+			ret = ocelot_pincfg_clrsetbits(info, pin, BIAS_BITS,
+						       val);
 			break;
 
 		case PINCONF_SCHMITT:
-			ocelot_clrsetbits(regaddr, SCHMITT_BIT, val);
+			ret = ocelot_pincfg_clrsetbits(info, pin, SCHMITT_BIT,
+						       val);
 			break;
 
 		case PINCONF_DRIVE_STRENGTH:
 			if (val <= 3)
-				ocelot_clrsetbits(regaddr, DRIVE_BITS, val);
+				ret = ocelot_pincfg_clrsetbits(info, pin,
+							       DRIVE_BITS, val);
 			else
 				ret = -EINVAL;
 			break;
@@ -1340,12 +1364,32 @@ static const struct of_device_id ocelot_pinctrl_of_match[] = {
 	{},
 };
 
+static struct regmap *ocelot_pinctrl_create_pincfg(struct platform_device *pdev)
+{
+	void __iomem *base;
+
+	const struct regmap_config regmap_config = {
+		.reg_bits = 32,
+		.val_bits = 32,
+		.reg_stride = 4,
+		.max_register = 32,
+	};
+
+	base = devm_platform_ioremap_resource(pdev, 0);
+	if (IS_ERR(base)) {
+		dev_dbg(&pdev->dev, "Failed to ioremap config registers (no extended pinconf)\n");
+		return NULL;
+	}
+
+	return devm_regmap_init_mmio(&pdev->dev, base, &regmap_config);
+}
+
 static int ocelot_pinctrl_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
 	struct ocelot_pinctrl *info;
+	struct regmap *pincfg;
 	void __iomem *base;
-	struct resource *res;
 	int ret;
 	struct regmap_config regmap_config = {
 		.reg_bits = 32,
@@ -1378,11 +1422,11 @@ static int ocelot_pinctrl_probe(struct platform_device *pdev)
 
 	/* Pinconf registers */
 	if (info->desc->confops) {
-		base = devm_platform_ioremap_resource(pdev, 0);
-		if (IS_ERR(base))
-			dev_dbg(dev, "Failed to ioremap config registers (no extended pinconf)\n");
+		pincfg = ocelot_pinctrl_create_pincfg(pdev);
+		if (IS_ERR(pincfg))
+			dev_dbg(dev, "Failed to create pincfg regmap\n");
 		else
-			info->pincfg = base;
+			info->pincfg = pincfg;
 	}
 
 	ret = ocelot_pinctrl_register(pdev, info);
-- 
2.25.1

