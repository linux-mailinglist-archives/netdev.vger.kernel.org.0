Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A61615886F7
	for <lists+netdev@lfdr.de>; Wed,  3 Aug 2022 07:51:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237046AbiHCFtD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Aug 2022 01:49:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236730AbiHCFsJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Aug 2022 01:48:09 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2121.outbound.protection.outlook.com [40.107.244.121])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95B8257267;
        Tue,  2 Aug 2022 22:47:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NkVRBa1so/uU4lhXTuPnlKaXq65MQQovr4NSsmAiyFTrJzR2ClVlI2oWw//sMnfiN2zI5v3VwpirVEl19Iw+Fl1UVSc85CL9sFrrp4HjrDk7SdRLsZPDI88+1WYnh93us94XHa1jPLH6VI5RS8xiJRdir8YwG90ec82YZfjhdH3DiTXqYr/SmoiSG/CHhDWZBdcl6mluuk6vSc38nlpXvtTiuOAs50m5rnCVWJf2ZHtLK8lYstz5bXFQpdsxtPH1bJQYpJAnpdvwrtB8jbhFwSs4V9tU766oCG6Zh63RzXvi+5ewjG+adRTu7DQSlcc43Fk0XXlQvc4JfHEwqTe8aA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RB2Ko3JvokEA1QTdWmgqle7W+LlLneKUy/WEwyOhBeg=;
 b=ehS2sTUG9WcqBhSJpKWV+oMyjF0r/UWVYMFhULTx+aVy3Fw7rnqQQaTGPudv5vdcw1ZKu1uXOLqq00Q5GJ10oPvQ6qmynTqfqtUY3hlg8vNvOp3h/C60ms1WJKlMV/JJ3M4ILRaOR5Ii9Vt8jVsWo7ZGMAYeqS2qHbttNK2MIJxlR7UInvRBu3p2lgvPmuBWoDVWDe7hq+utAmojL7y6DS2ivENhnI+ytO6ssGmCfwqaMkCp+NFEB7OZrnkaM8RPOu/b7FJ6my4tZiTR1h0fG4Q9WahCuohOHEFj+AASgt32WXYyoDhZ4w45BitjJTCN3yoQOLqCKhLgoS50AS4/Dg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RB2Ko3JvokEA1QTdWmgqle7W+LlLneKUy/WEwyOhBeg=;
 b=jxMMisEYLm/jSzLAMj5Fd5zKl0MKS/eicwseyaExS5+u36/fE4XAz912r3zPCKrK0l4CvHQWsmzX2zkK8Qh/hNm/LYDyBFSBYyOAxQ9aH2L7swFV9AZal/mDYoc2wPD5ioVJliwyoyTbpqu6kNdZIfo1KOXtHhiZ2bauDzp+nHY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by MW4PR10MB6438.namprd10.prod.outlook.com
 (2603:10b6:303:218::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.14; Wed, 3 Aug
 2022 05:47:52 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::b869:6c52:7a8d:ddee]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::b869:6c52:7a8d:ddee%4]) with mapi id 15.20.5482.014; Wed, 3 Aug 2022
 05:47:52 +0000
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
Subject: [PATCH v15 mfd 6/9] pinctrl: microchip-sgpio: add ability to be used in a non-mmio configuration
Date:   Tue,  2 Aug 2022 22:47:25 -0700
Message-Id: <20220803054728.1541104-7-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220803054728.1541104-1-colin.foster@in-advantage.com>
References: <20220803054728.1541104-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR01CA0026.prod.exchangelabs.com (2603:10b6:a02:80::39)
 To MWHPR1001MB2351.namprd10.prod.outlook.com (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 580a5303-405f-46b5-d954-08da7513b4c7
X-MS-TrafficTypeDiagnostic: MW4PR10MB6438:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XzlRd7kVOxqw9uL+9jQWrwxAryqoeO7RlFhzEUMprSo4iGgaC8fv1tSCW9byUOAYEbP/KtRMSW72aqqxcKX4JzjeGurqwba3/zY5RUcq0CjTz9O2Bcd8XavMY7PC9jWGWJ7fh4FfSZbLwlbMagTsTCfsOoF7JBXQ5Uh2R0b86Sm+xDJs+BklW4+/lBNQFD8+Xe0Gx2p6XSUn7mMp1591PWPkzQNP3WW0wqq0n7SCRkncxQxypKRgjU6PyhIbzqYoihv4R8+wbaI4kBA48ecg8SRlkNGYnqiwdLeMSHfEdERBoweq8UyJIpEkNVhfDyRKtDNPw3IEu8VXaxKTSB+qyQLqSixBwbW7ojkedpneqouyU+rMPRYxbGGVqu76zOWrZGkItC+zJhWpyKsfhc4QeAMulGGHn+mdbIS6BLrHptjk8oTFM8EPRPNW17G1/N8EW0MXaUpiJ4awQ0JhjhehAGG+ZVwrbtX/t5YpFKf5j9YPcCWcoY/8E+JCaoIrZZjCL9giOmrmB4rkr5+xLCZuVI2W4pVu8Kk/rwMcpC1sQ+yj1okYkl+3GPEqheV2Y5hbrluu0MGcNJ9iTDY3mCj9RzpgBQqotzJ+Cad6bk1NzoRta5ZL/D2lr6fi+TgICMn8/KBgJKTE7TPie317TCpOhq7ADMDHj8/M8AfjIDN1lVhX0T7vJFXL5SdJ9p6+0wnpTNv/WPrdKjlOsfx8Gm8ArTiFd9rL/0keac6G/3Kqja9iKDxzB3X4ZOm41p+lk0swixtZOF0Bl5HhkB+IpJH8ntpQLQQPpwY5m5DJusTnrZs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(366004)(346002)(136003)(39830400003)(396003)(186003)(41300700001)(6666004)(2906002)(6512007)(26005)(52116002)(1076003)(6506007)(107886003)(2616005)(38350700002)(38100700002)(86362001)(83380400001)(5660300002)(36756003)(7416002)(6486002)(478600001)(8676002)(4326008)(66476007)(66556008)(66946007)(8936002)(44832011)(316002)(54906003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Mcd1RkYp0D5DBhTt4qDzmJc4tUJ9pf1asYjdUJ2TJnotrUzNA06gw78ghN/t?=
 =?us-ascii?Q?jvaCyfrrOBYhcRc1x91D6SYxXzj/4xw+OxE5jHlsU4j4zU0KGoPdh6BZdnzq?=
 =?us-ascii?Q?IZE5dMh+5vM0K76ctOW8pVs4jieL5p6oqiPMTaJCDCx5xOm/Wbn0p7BO47nf?=
 =?us-ascii?Q?BPcgJ3NL67GedOre0jpMkl/RZ3jCx//PWogLhBJ3jdONbPiC+gTO7jbzF4xe?=
 =?us-ascii?Q?Vq95posJElbT28TGt1HcnCpyxmWym7QN3bZuSGYTtdofUTDHcQT1yD1ojCRD?=
 =?us-ascii?Q?5Yb+noRxbvW4OWOJels3IKYxE7lDt694d20LLVEyR0+sU8F3p0WzXvGIwiXb?=
 =?us-ascii?Q?feXgcl1M05J+tn/hxtY6Se3dt+tSzbFKMz8MzosYB/0fk5dmMXKIXALW27GF?=
 =?us-ascii?Q?ISYvTGUi/849sVQHzZUabNy3PjTNtI+HLoR0Lsw0qEktBuweUy/Eb0tYE3aT?=
 =?us-ascii?Q?8yxry/cqJ36c210is3NoZHK6elG2UTxX0esBMqlgwnzztg7EYk4F3IYtQqXd?=
 =?us-ascii?Q?dlsBqTlnxiW1EXJvuBvf+iliWE97Y6DBuNOL2SzxTyJf82MN9D0ddC56041L?=
 =?us-ascii?Q?PpkKfym0uy9hsDZEsxQ0VgztBhM8h20z0WHtILGV9VEI9c07XDfSjOQV7FTd?=
 =?us-ascii?Q?IHgbKPcxt4d591qVhSrCkM0peKHGlSU1C8j9lwgPKsNxvno6AhMq0nWmbVgd?=
 =?us-ascii?Q?8tdwfbm6INxzZiJmmHG0zXzNtEu59MDHOf8IJ8rIuFa/QrGRPvzDwrYGTVQp?=
 =?us-ascii?Q?PGms1EeHbkYgCeMVj6gYmgedQl00bLAXSLsjCFR+NyWb5ucTsA0gAxZaR+vi?=
 =?us-ascii?Q?y9whJ505Xcn/9elQJ33M1TjupbDHul+Gb8B5YFK4pIWks+DH1IWF4lyO4F6x?=
 =?us-ascii?Q?5KD+DcDA1mJO+WI5uAnmn/85qW5BW4ixKIsjCUKxR9Wg239wo7+pUrDLGSN3?=
 =?us-ascii?Q?jXPgdEE41+oNA3zW0Tj6fYoX5ot45SjA97d7P/s7BoxyfhnxMoRUu6Z5qokm?=
 =?us-ascii?Q?nRSEg6cCRQiDVk7/nHkVmUjgoF8KNI1l9dbTwcdL4I+NUHFL2+cc+5QZwyu4?=
 =?us-ascii?Q?fOlcJzKmPOkrd6B/YGPE43nKjRjA6Co7kR7fkhliSD5oUE6eRhgany7OnGiR?=
 =?us-ascii?Q?ekHb9DeZfXZbtkFnyEFZuz04kbknLFNS52ZpFFuPDURPgjnjCxTOxvxHL+xG?=
 =?us-ascii?Q?91tRM4YNxIYQ/Q7eKlEiN8+TsWm1ppy/lo0r9oyX3TyPHntQSmU/2Snp3e31?=
 =?us-ascii?Q?CWb5xRlq5Jcp34+cFAEu18a0ibw8oFJFfxQlz4qhHdMcV6GhbjO/vW2Oluwi?=
 =?us-ascii?Q?NtSj6QlKv3HQRVqc1nt86neHU0KJOEQYwFQ+zhglSpQkeeMjYqAWmqmI96LA?=
 =?us-ascii?Q?1rGlZr+RecGVZluJM/zL0x4y+YDMYA+QbpMdt5FVZHivpJyOhPERdPl/rftd?=
 =?us-ascii?Q?CZZOgTQvCyCDTZJsnAGG50dyZ5dmzNCD7hajiV/L/rhuFNg5S6a/kg9/vODr?=
 =?us-ascii?Q?lR7EcNH9k8rpx1zmjmeHJ8E5/06Ho7Bp8lwoXC808AfjacM7ixNzulvc9Bpb?=
 =?us-ascii?Q?QPYThcZu1FnyzAoI9ghuIHXlytUAhzYwe275Pk8+lQwiFXOzVA46LreIXv2z?=
 =?us-ascii?Q?NQ=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 580a5303-405f-46b5-d954-08da7513b4c7
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2022 05:47:52.6202
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Jwy2PVJA+ADCUnnQv004FCojy4jD2uRM25yEcfpp+5gS81ifQtGusg/PLxRYwpBlRIZd4tmKPWwrEb7hy2wH7F1OK65sliqiFPnJHCGdN7k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB6438
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are a few Ocelot chips that can contain SGPIO logic, but can be
controlled externally. Specifically the VSC7511, 7512, 7513, and 7514. In
the externally controlled configurations these registers are not
memory-mapped.

Add support for these non-memory-mapped configurations.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
---

(No changes since v14)

v14
    * Add Reviewed and Acked tags

---
 drivers/pinctrl/pinctrl-microchip-sgpio.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-microchip-sgpio.c b/drivers/pinctrl/pinctrl-microchip-sgpio.c
index e56074b7e659..2b4167a09b3b 100644
--- a/drivers/pinctrl/pinctrl-microchip-sgpio.c
+++ b/drivers/pinctrl/pinctrl-microchip-sgpio.c
@@ -12,6 +12,7 @@
 #include <linux/clk.h>
 #include <linux/gpio/driver.h>
 #include <linux/io.h>
+#include <linux/mfd/ocelot.h>
 #include <linux/mod_devicetable.h>
 #include <linux/module.h>
 #include <linux/pinctrl/pinmux.h>
@@ -904,7 +905,6 @@ static int microchip_sgpio_probe(struct platform_device *pdev)
 	struct reset_control *reset;
 	struct sgpio_priv *priv;
 	struct clk *clk;
-	u32 __iomem *regs;
 	u32 val;
 	struct regmap_config regmap_config = {
 		.reg_bits = 32,
@@ -937,11 +937,7 @@ static int microchip_sgpio_probe(struct platform_device *pdev)
 		return -EINVAL;
 	}
 
-	regs = devm_platform_ioremap_resource(pdev, 0);
-	if (IS_ERR(regs))
-		return PTR_ERR(regs);
-
-	priv->regs = devm_regmap_init_mmio(dev, regs, &regmap_config);
+	priv->regs = ocelot_regmap_from_resource(pdev, 0, &regmap_config);
 	if (IS_ERR(priv->regs))
 		return PTR_ERR(priv->regs);
 
-- 
2.25.1

