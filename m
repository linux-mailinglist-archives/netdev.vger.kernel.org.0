Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACBF4452AD8
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 07:29:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232372AbhKPGaY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 01:30:24 -0500
Received: from mail-dm6nam10on2120.outbound.protection.outlook.com ([40.107.93.120]:37728
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231403AbhKPG22 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Nov 2021 01:28:28 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oWbK3iaDuhz6YnmtQtg2tXy4h3V02lhdNTU8Rpa/CEw+NsFUypyItCB2LvcrF/6ZnUVU8N4pT5rTqGSL1uTspomSm/q/JouxLXzQVHG8pZCl41W1FNqkm/5IfgQV7xeuS6DEXWdfEfrM5VlvCWZh6rp/NOoFO6Zh1NPt0zrAVkfjUOZV0XEQPRICa5xY8eZyXx0czM9HFEBj2RCOP2JH0qNewqAV4VcvyzFH+9wXU72wTXv/0sRduRTo6JLfH4430ALDwNVK3NayR7j36EVUFekBqPJJH/TmDzouueAEKSIaiP+sXPmwKxn0QU7vCIovFboohodqsPxdYZsGM98uJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Mv49pXxI9NYSX9UZOP4SbUoZ3wox9TZ+Ko6Yzl+0c/g=;
 b=fnARpsXtxWTlv575MWl9HcmDvj/AaCUtjh/frwFpBdMhGQfyIWoqSw2wZJ3vrRbXZC0SBD6Y1jk76TTHbmSobchv97uCjZTOwPkhJOELHeZ+ISpUBzdARKePqdavbcDe5pJnwYcrAGEgS911Myf3zT52vRrnuObh+A53KJvfCGBydc7VZGbaAjk4iYedEt77d8Li+zOCYwHtXINtSikQ29W7L7BWC3uuSH6l2xnbtQsGuHOCJgVDn7SJEGyakfs1LipwEIV5lRP+oNpv0l4nx0spCgQpiFxtLfCzfQ8bnSvRTnnoTsojhNQpeBF618bMijmG00bsnH224M/XNsH1gQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Mv49pXxI9NYSX9UZOP4SbUoZ3wox9TZ+Ko6Yzl+0c/g=;
 b=QBsjw54bvqkwh2a5p+U3xXmyAQe/2MFTh8GwGpcjCjykePok+voTIv0Q6M6i/2aIIzD88ELdL1wTzQ8DdWBv7k9OE4TCfSJYQVyYx8hmE/6JJFZ5rMQhXcScRvtvyZ3PWjEQIbiqY8k/Wso8lYhmtWtLu+yMWf/rwjIwzofm8WA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by CO1PR10MB4722.namprd10.prod.outlook.com
 (2603:10b6:303:9e::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.27; Tue, 16 Nov
 2021 06:23:52 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::6430:b20:8805:cd9f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::6430:b20:8805:cd9f%5]) with mapi id 15.20.4690.026; Tue, 16 Nov 2021
 06:23:52 +0000
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
Subject: [RFC PATCH v4 net-next 13/23] pinctrl: ocelot: expose ocelot_pinctrl_core_probe interface
Date:   Mon, 15 Nov 2021 22:23:18 -0800
Message-Id: <20211116062328.1949151-14-colin.foster@in-advantage.com>
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
X-MS-Office365-Filtering-Correlation-Id: 3cd11db6-2f3f-4747-ece2-08d9a8c9a8cb
X-MS-TrafficTypeDiagnostic: CO1PR10MB4722:
X-Microsoft-Antispam-PRVS: <CO1PR10MB47229C35888EE7B52BB3F7ADA4999@CO1PR10MB4722.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tmXTa3wLgruJE+TTwwcjKvj9/LjVS+Abla1Jg7WCycJgXb2h9SJIOjxRZA3jIHDzlQFa//Rc47JLGEwXo8M3hSIzcvxuQu0zGDMHPf+jwZidoJMPbyImcV0R6xbzZ7T64/ReL1V+VUyHx4fu6ZvJNBfO3RGaBiikkw55krDwHgg7sHfkgIsm9oiAA4pojV+lvc9fxY9cn4UXs4vTdOttlRCWDz1bRREKrDqIMgl1Q4kOULJAQhAMlgpccAOwkhnX6S5N3IvEhaaLq5DmsvxMbf2PF7g3INcpmGoDYovx/tAbsglBtZpXRbl3fzrLhsyhO2z+nxmTIc65FF60pDjOyP9euozMDnuDty9WWyjGcu5uHIb56pdDO1hjs4lvyBEaxVuw0WSp8X87f37FI07VZSo3anjeK2qevnpC6uMCBkcLAGqg9kqpcPKKG1ud7+VtVGVqHOhjlBxixoBjQgm3ZoQs48N8XrtzIbZQosIU8Yv7dDbSsvn4+kIH4uA+iPihUvJR1MzjD8w1fcxeyXXMkvmfsmEByF/WCAsbKlqrIEVKJBLT2fv1oAVUxRyAaw+MNf8lTrVAv3L6lM8+ehVWoxqHTBcQEjI167K5FN12Pmv35gsPPkfAm1I8icU5/wOkhOwk/jUAN/HZJwoVPTz6ApGJfwaTIfr5uuWLqsV01Y2eevNMI53bUCXHIRfKBeRMEPS+mQ9wCC2EIqRXVrWnxw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(136003)(366004)(396003)(39840400004)(346002)(83380400001)(6666004)(54906003)(5660300002)(2906002)(7416002)(6486002)(44832011)(956004)(86362001)(2616005)(4326008)(316002)(508600001)(8676002)(186003)(6512007)(38100700002)(38350700002)(1076003)(8936002)(52116002)(26005)(6506007)(36756003)(30864003)(66556008)(66476007)(66946007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hsPpEXCj59Q/CZpnB3J7DtiSbHnLlVYE+pKNR4TSdfr+f4gzYar9IeRjfQUL?=
 =?us-ascii?Q?HtQc5Rh31iJsrNetRtOZRK7TR/iZWwnn+RE3IWkeSStAlP+37XZcaEH4hCpu?=
 =?us-ascii?Q?TixCMCk6iI3H6AXoT1OorNll2g1fd1AU5V2b/mL7cZcqVqrvnVmpP7SJ6UTx?=
 =?us-ascii?Q?kEjSFWYtNKZFxQqPv941kmY9mfjAIkEiyQ2SveIxfWpohF7tK1ehSCQCpe2K?=
 =?us-ascii?Q?eTNwyyXN65b1OGVjAcAldvnYAvMCI68rW9S4/x3hVEmqf8HBEyduicDM6Sg/?=
 =?us-ascii?Q?IVgaYb+D94INqmYeeiLO+1hyqPzMjxckKB9UR0XbEwtTgd5regjKxStbyaDv?=
 =?us-ascii?Q?mJUpYhc0tkyNvAf79aEhvVEGH/Ym1o0XSFVasbbl0mSef7RD1FKG+VINXCEW?=
 =?us-ascii?Q?Syl7Gk1+38VnPF1UhTNL5xsiZybzKDGq8pPzRDxvqQTQh80szJ0gHDrMqkOH?=
 =?us-ascii?Q?C1Mkmvz24dsCzkQGbFwsBIRJvcMwxiJJqr8aC7xuFYhPRgdhk8HWWbdY/dio?=
 =?us-ascii?Q?RIqpEgrQczJ73+8RrtG/nsEdPECw9UT3y2ovEDM7Con12Xxg4fEHfb9JxHiR?=
 =?us-ascii?Q?9dAklB8L47sWKUG1muO+ssWuH3CHWemh8EsDTTcPix4eP4FLDmvH0VnraiGH?=
 =?us-ascii?Q?V6NBpvxdVc/inavbp4nvB2CsYcS5ubvVdeRwZiEN1ylqxLlE//iBzxXqgbjQ?=
 =?us-ascii?Q?BB7+drOg7ednlPC7zoVXIHALgwMzE7+194mlpeOn+CPYCYvTnX3skj6pOIjg?=
 =?us-ascii?Q?cmpw8FnC1eA3rCovAS5ZXSg6cHoCOeh323yNsYGw6yv68zKOlHHEaT+l6/ha?=
 =?us-ascii?Q?Rp+Q5DcWRe2muRuD8k2N9EWuKuM2UzSnxdm3yIhplR8Vnmn/7PjkLo51+1Ef?=
 =?us-ascii?Q?7OVJBd/d97Sox3KQqySoqp8N1g3uLjk/Sc2ly0hIIxpEKTtJ0gXJPJ+o/ZB0?=
 =?us-ascii?Q?0J/bts62DiZsz2fz2Yc1aqaksYFkjWDAEz2wa6BarxhClDQ+FB7VTnSzcvoX?=
 =?us-ascii?Q?54MMtTJWEa0Uu3H5wDBbk3oftRp9U2oKzSodhEF1ehUfMiTr1D8nCqas24IO?=
 =?us-ascii?Q?Ni1vVAXXl/Ggbf4vnFYmfIp66NX5susAIpDyEot6gvnRf5kbyJNmPO4zaPlq?=
 =?us-ascii?Q?SLeNOvU7RfyFMnQK/TCloOL22cgpk7wJOm3Of5PCfKpEjOi1nWNIVGQT/qom?=
 =?us-ascii?Q?MDSX4JOSWwsdNf5sqiBJjdLQdemTqM05mGZbQTg7Gi2e3Q7amtALVnSFIz6b?=
 =?us-ascii?Q?iLdW9DotX2/QrfuUpcqaxqqRuFjvMmQHNxwFC0DTRy1XN/WAt652gbh+GQaa?=
 =?us-ascii?Q?Pe+583ayX5fCpdg9HarqzyVLDdESvWkjDCasoNilvS0agKiYNi26y7D/ThCi?=
 =?us-ascii?Q?YF4KvxSX4U4uiBm3/wjTTLhA3393XlZXWfU0w5AWFfHnMyn8V2TUdHhmiyic?=
 =?us-ascii?Q?o3SO+PpAVkuv3SQWP/LslsVSf8gkiok5DCqKuji9Vj+vz4wUDvyqraTgoAw7?=
 =?us-ascii?Q?7v/gmWYtVbsZUGkzklAE6wvJfsv2FZz2I29XqIWIfen2E9e+hrjzhsLFsREd?=
 =?us-ascii?Q?u7tu34gjMxOqtFZV32VRttN6cuQYq7Yzrw5ZToTBlMXzFjSRG92VNDSp+nH+?=
 =?us-ascii?Q?JWsd046T6Wu7ywEQdv+YEb+M0yOoBiZiISJDGz0Qm9jmjLPwelX3q6uO5BxG?=
 =?us-ascii?Q?rKXdCRTLbNjp1aM+91vGIFLRN1A=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3cd11db6-2f3f-4747-ece2-08d9a8c9a8cb
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2021 06:23:52.5654
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mhoJzDpCV46rj5nqpIC/mTpzvThj/1iA9YTu0n9QJSut6HdrBk0WTvw88ghqZfLlQFkYWjaZacVqjsCibwENkdB4MnkoI4Oat3u+vjFBdb8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4722
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is step 2 to allow a custom regmap interface into the driver. This
will allow regmaps that use other interfaces to fully utilize the pinctrl
features.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---
 drivers/pinctrl/pinctrl-ocelot.c | 150 ++++++++++++++++++++-----------
 include/soc/mscc/ocelot.h        |  18 ++++
 2 files changed, 118 insertions(+), 50 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-ocelot.c b/drivers/pinctrl/pinctrl-ocelot.c
index b9acb80d6b3f..f8d2494b335c 100644
--- a/drivers/pinctrl/pinctrl-ocelot.c
+++ b/drivers/pinctrl/pinctrl-ocelot.c
@@ -25,9 +25,6 @@
 #include "pinconf.h"
 #include "pinmux.h"
 
-#define ocelot_clrsetbits(addr, clear, set) \
-	writel((readl(addr) & ~(clear)) | (set), (addr))
-
 /* PINCONFIG bits (sparx5 only) */
 enum {
 	PINCONF_BIAS,
@@ -35,6 +32,9 @@ enum {
 	PINCONF_DRIVE_STRENGTH,
 };
 
+#define ocelot_pinctrl_determine_stride(desc) \
+	(1 + (desc->npins - 1) / 32)
+
 #define BIAS_PD_BIT BIT(4)
 #define BIAS_PU_BIT BIT(3)
 #define BIAS_BITS   (BIAS_PD_BIT|BIAS_PU_BIT)
@@ -149,10 +149,13 @@ struct ocelot_pin_caps {
 
 struct ocelot_pinctrl {
 	struct device *dev;
+	struct device_node *node;
 	struct pinctrl_dev *pctl;
 	struct gpio_chip gpio_chip;
 	struct regmap *map;
+	u32 regmap_offset;
 	struct regmap *pincfg;
+	u32 pincfg_offset;
 	struct pinctrl_desc *desc;
 	struct ocelot_pmx_func func[FUNC_MAX];
 	u8 stride;
@@ -714,7 +717,8 @@ static int ocelot_pin_function_idx(struct ocelot_pinctrl *info,
 	return -1;
 }
 
-#define REG_ALT(msb, info, p) (OCELOT_GPIO_ALT0 * (info)->stride + 4 * ((msb) + ((info)->stride * ((p) / 32))))
+#define REG_ALT(msb, info, p) (OCELOT_GPIO_ALT0 * (info)->stride + 4 * ((msb) + \
+			((info)->stride * ((p) / 32))) + (info)->regmap_offset)
 
 static int ocelot_pinmux_set_mux(struct pinctrl_dev *pctldev,
 				 unsigned int selector, unsigned int group)
@@ -744,7 +748,8 @@ static int ocelot_pinmux_set_mux(struct pinctrl_dev *pctldev,
 	return 0;
 }
 
-#define REG(r, info, p) ((r) * (info)->stride + (4 * ((p) / 32)))
+#define REG(r, info, p) (((r) * (info)->stride + (4 * ((p) / 32))) + \
+		(info)->regmap_offset)
 
 static int ocelot_gpio_set_direction(struct pinctrl_dev *pctldev,
 				     struct pinctrl_gpio_range *range,
@@ -766,10 +771,8 @@ static int ocelot_gpio_request_enable(struct pinctrl_dev *pctldev,
 	struct ocelot_pinctrl *info = pinctrl_dev_get_drvdata(pctldev);
 	unsigned int p = offset % 32;
 
-	regmap_update_bits(info->map, REG_ALT(0, info, offset),
-			   BIT(p), 0);
-	regmap_update_bits(info->map, REG_ALT(1, info, offset),
-			   BIT(p), 0);
+	regmap_update_bits(info->map, REG_ALT(0, info, offset), BIT(p), 0);
+	regmap_update_bits(info->map, REG_ALT(1, info, offset), BIT(p), 0);
 
 	return 0;
 }
@@ -821,11 +824,11 @@ static int ocelot_hw_get_value(struct ocelot_pinctrl *info,
 	if (info->pincfg) {
 		u32 regcfg;
 
-		ret = regmap_read(info->pincfg, pin, &regcfg);
+		ret = regmap_read(info->pincfg, pin + info->pincfg_offset,
+				  &regcfg);
 		if (ret)
 			return ret;
 
-		ret = 0;
 		switch (reg) {
 		case PINCONF_BIAS:
 			*val = regcfg & BIAS_BITS;
@@ -853,14 +856,14 @@ static int ocelot_pincfg_clrsetbits(struct ocelot_pinctrl *info, u32 regaddr,
 	u32 val;
 	int ret;
 
-	ret = regmap_read(info->pincfg, regaddr, &val);
+	ret = regmap_read(info->pincfg, regaddr + info->pincfg_offset, &val);
 	if (ret)
 		return ret;
 
 	val &= ~clrbits;
 	val |= setbits;
 
-	ret = regmap_write(info->pincfg, regaddr, val);
+	ret = regmap_write(info->pincfg, regaddr + info->pincfg_offset, val);
 
 	return ret;
 }
@@ -873,7 +876,6 @@ static int ocelot_hw_set_value(struct ocelot_pinctrl *info,
 	int ret = -EOPNOTSUPP;
 
 	if (info->pincfg) {
-
 		ret = 0;
 		switch (reg) {
 		case PINCONF_BIAS:
@@ -1019,15 +1021,16 @@ static int ocelot_pinconf_set(struct pinctrl_dev *pctldev, unsigned int pin,
 			if (arg)
 				regmap_write(info->map,
 					     REG(OCELOT_GPIO_OUT_SET, info,
-						 pin),
+						 pin) + info->regmap_offset,
 					     BIT(p));
 			else
 				regmap_write(info->map,
 					     REG(OCELOT_GPIO_OUT_CLR, info,
-						 pin),
+						 pin) + info->regmap_offset,
 					     BIT(p));
 			regmap_update_bits(info->map,
-					   REG(OCELOT_GPIO_OE, info, pin),
+					   REG(OCELOT_GPIO_OE, info, pin) +
+					       info->regmap_offset,
 					   BIT(p),
 					   param == PIN_CONFIG_INPUT_ENABLE ?
 					   0 : BIT(p));
@@ -1138,20 +1141,20 @@ static int ocelot_create_group_func_map(struct device *dev,
 	return 0;
 }
 
-static int ocelot_pinctrl_register(struct platform_device *pdev,
+static int ocelot_pinctrl_register(struct device *dev,
 				   struct ocelot_pinctrl *info)
 {
 	int ret;
 
-	ret = ocelot_create_group_func_map(&pdev->dev, info);
+	ret = ocelot_create_group_func_map(dev, info);
 	if (ret) {
-		dev_err(&pdev->dev, "Unable to create group func map.\n");
+		dev_err(dev, "Unable to create group func map.\n");
 		return ret;
 	}
 
-	info->pctl = devm_pinctrl_register(&pdev->dev, info->desc, info);
+	info->pctl = devm_pinctrl_register(dev, info->desc, info);
 	if (IS_ERR(info->pctl)) {
-		dev_err(&pdev->dev, "Failed to register pinctrl\n");
+		dev_err(dev, "Failed to register pinctrl\n");
 		return PTR_ERR(info->pctl);
 	}
 
@@ -1320,7 +1323,7 @@ static void ocelot_irq_handler(struct irq_desc *desc)
 	}
 }
 
-static int ocelot_gpiochip_register(struct platform_device *pdev,
+static int ocelot_gpiochip_register(struct device *dev,
 				    struct ocelot_pinctrl *info)
 {
 	struct gpio_chip *gc;
@@ -1331,7 +1334,7 @@ static int ocelot_gpiochip_register(struct platform_device *pdev,
 
 	gc = &info->gpio_chip;
 	gc->ngpio = info->desc->npins;
-	gc->parent = &pdev->dev;
+	gc->parent = dev;
 	gc->base = -1;
 	gc->of_node = info->dev->of_node;
 	gc->label = "ocelot-gpio";
@@ -1342,8 +1345,7 @@ static int ocelot_gpiochip_register(struct platform_device *pdev,
 		girq->chip = &ocelot_irqchip;
 		girq->parent_handler = ocelot_irq_handler;
 		girq->num_parents = 1;
-		girq->parents = devm_kcalloc(&pdev->dev, 1,
-					     sizeof(*girq->parents),
+		girq->parents = devm_kcalloc(dev, 1, sizeof(*girq->parents),
 					     GFP_KERNEL);
 		if (!girq->parents)
 			return -ENOMEM;
@@ -1352,7 +1354,7 @@ static int ocelot_gpiochip_register(struct platform_device *pdev,
 		girq->handler = handle_edge_irq;
 	}
 
-	return devm_gpiochip_add_data(&pdev->dev, gc, info);
+	return devm_gpiochip_add_data(dev, gc, info);
 }
 
 static const struct of_device_id ocelot_pinctrl_of_match[] = {
@@ -1384,56 +1386,104 @@ static struct regmap *ocelot_pinctrl_create_pincfg(struct platform_device *pdev)
 	return devm_regmap_init_mmio(&pdev->dev, base, &regmap_config);
 }
 
+static struct pinctrl_desc
+*ocelot_pinctrl_match_from_node(struct device_node *device_node)
+{
+	const struct of_device_id *match;
+
+	match = of_match_node(of_match_ptr(ocelot_pinctrl_of_match),
+			      device_node);
+
+	if (match)
+		return (struct pinctrl_desc *)match->data;
+
+	return NULL;
+}
+
+int ocelot_pinctrl_core_probe(struct device *dev,
+			      struct pinctrl_desc *pinctrl_desc,
+			      struct regmap *regmap_base, u32 regmap_offset,
+			      struct regmap *pincfg_base, u32 pincfg_offset,
+			      struct device_node *device_node)
+{
+	struct ocelot_pinctrl *info;
+	int ret;
+
+	info = devm_kzalloc(dev, sizeof(*info), GFP_KERNEL);
+	if (!info)
+		return -ENOMEM;
+
+	if (!pinctrl_desc)
+		pinctrl_desc = ocelot_pinctrl_match_from_node(device_node);
+	if (!pinctrl_desc) {
+		dev_err(dev, "Failed to find device match\n");
+		return -ENODEV;
+	}
+
+	info->desc = pinctrl_desc;
+	info->stride = ocelot_pinctrl_determine_stride(info->desc);
+	info->dev = dev;
+	info->node = device_node;
+	info->map = regmap_base;
+	info->pincfg = pincfg_base;
+	info->regmap_offset = regmap_offset;
+	info->pincfg_offset = pincfg_offset;
+
+	ret = ocelot_pinctrl_register(dev, info);
+	if (ret)
+		return ret;
+
+	ret = ocelot_gpiochip_register(dev, info);
+	if (ret)
+		return ret;
+
+	return 0;
+}
+EXPORT_SYMBOL(ocelot_pinctrl_core_probe);
+
 static int ocelot_pinctrl_probe(struct platform_device *pdev)
 {
+	struct pinctrl_desc *pinctrl_desc;
 	struct device *dev = &pdev->dev;
-	struct ocelot_pinctrl *info;
+	struct regmap *regmap;
 	struct regmap *pincfg;
 	void __iomem *base;
-	int ret;
+	int ret, stride;
 	struct regmap_config regmap_config = {
 		.reg_bits = 32,
 		.val_bits = 32,
 		.reg_stride = 4,
 	};
 
-	info = devm_kzalloc(dev, sizeof(*info), GFP_KERNEL);
-	if (!info)
-		return -ENOMEM;
-
-	info->desc = (struct pinctrl_desc *)device_get_match_data(dev);
+	pinctrl_desc = (struct pinctrl_desc *)device_get_match_data(dev);
 
 	base = devm_ioremap_resource(dev,
 			platform_get_resource(pdev, IORESOURCE_MEM, 0));
 	if (IS_ERR(base))
 		return PTR_ERR(base);
 
-	info->stride = 1 + (info->desc->npins - 1) / 32;
+	stride = ocelot_pinctrl_determine_stride(pinctrl_desc);
 
-	regmap_config.max_register = OCELOT_GPIO_SD_MAP * info->stride + 15 * 4;
+	regmap_config.max_register = OCELOT_GPIO_SD_MAP * stride + 15 * 4;
 
-	info->map = devm_regmap_init_mmio(dev, base, &regmap_config);
-	if (IS_ERR(info->map)) {
+	regmap = devm_regmap_init_mmio(dev, base, &regmap_config);
+	if (IS_ERR(regmap)) {
 		dev_err(dev, "Failed to create regmap\n");
-		return PTR_ERR(info->map);
+		return PTR_ERR(regmap);
 	}
-	dev_set_drvdata(dev, info->map);
-	info->dev = dev;
+	dev_set_drvdata(dev, regmap);
 
 	/* Pinconf registers */
-	if (info->desc->confops) {
+	if (pinctrl_desc->confops) {
 		pincfg = ocelot_pinctrl_create_pincfg(pdev);
-		if (IS_ERR(pincfg))
+		if (IS_ERR(pincfg)) {
 			dev_dbg(dev, "Failed to create pincfg regmap\n");
-		else
-			info->pincfg = pincfg;
+			pincfg = NULL;
+		}
 	}
 
-	ret = ocelot_pinctrl_register(pdev, info);
-	if (ret)
-		return ret;
-
-	ret = ocelot_gpiochip_register(pdev, info);
+	ret = ocelot_pinctrl_core_probe(dev, pinctrl_desc, regmap, 0, pincfg, 0,
+					dev->of_node);
 	if (ret)
 		return ret;
 
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 9a4ded4bff04..14acfe82d0a4 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -6,6 +6,7 @@
 #define _SOC_MSCC_OCELOT_H
 
 #include <linux/ptp_clock_kernel.h>
+#include <linux/pinctrl/pinctrl.h>
 #include <linux/net_tstamp.h>
 #include <linux/if_vlan.h>
 #include <linux/regmap.h>
@@ -912,4 +913,21 @@ ocelot_mrp_del_ring_role(struct ocelot *ocelot, int port,
 }
 #endif
 
+#if IS_ENABLED(CONFIG_PINCTRL_OCELOT)
+int ocelot_pinctrl_core_probe(struct device *dev,
+			      struct pinctrl_desc *pinctrl_desc,
+			      struct regmap *regmap_base, u32 regmap_offset,
+			      struct regmap *pincfg_base, u32 pincfg_offset,
+			      struct device_node *device_node);
+#else
+int ocelot_pinctrl_core_probe(struct device *dev,
+			      struct pinctrl_desc *pinctrl_desc,
+			      struct regmap *regmap_base, u32 regmap_offset,
+			      struct regmap *pincfg_base, u32 pincfg_offset,
+			      struct device_node *device_node)
+{
+	return -EOPNOTSUPP;
+}
+#endif
+
 #endif
-- 
2.25.1

