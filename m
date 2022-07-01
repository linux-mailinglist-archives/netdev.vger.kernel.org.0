Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A8A55639B7
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 21:29:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232683AbiGAT1H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 15:27:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232374AbiGAT0g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 15:26:36 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2120.outbound.protection.outlook.com [40.107.100.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B559B3CFD4;
        Fri,  1 Jul 2022 12:26:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JpSbC37SweXgQMoPTs9q9fYOY7ypEhDDsPiZJU0OLRmUNeTsBOVnCAsM0ip8k4VClJfBN6A0AB0Y+1UvGuDrAlPcAsV+0oJbCAe9J8LTXMYC9mZQQvDha2Cl+DfTv1fGKlA9cxVrDGTiW3PZUz06d32sutlPN90IUCQesyIYFRmRwafF1259zMOcQDLz/l+mMFpD/N6yzKDaHSIVHEo8T3nWtAamMrpZU7CoHgRoHTxQ5Dm8r6k6eIRd7Ww5rA1i8dJB8hwd8HYegmGStNlLFxYGgcSfEQQ1q5NpcxzgKyWv03FgSnmy9j0YocVTK94pS1jlsIyRbAFFZgBLteWEkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cfIkPfu7Ud9GCgd7Lv2zW+ZXZUK4xd6exVIbNLcmw9I=;
 b=nUnziLDtCrz+MNEK7FbfNrRxc3ITS42Y6HpXo+oI1TkntMfnQJOLiiiNzlz9g7b8l3Ai8v/MjxUHVvr5Uc847bmQgoJa3kRRmEq3lWbmka0tSrvDlmYfqg24jnV8RGk7UKDRSCjIf53dQtjmSSfdyxSYNrjsQyVvHIh3toRp433cMgp38B7rn1XNQNUve5wfOgMlSnuNLfMScU6/6k7wctypgs8VJcCAT7XDzCCqC/dsGu04o6GqgbkjxpIY1Cuw4wwad88/7rsQ8UG4pmZa3PocRmzbRmwdjRkVlQ0V91HBcwNkCSzX9Th8IOxElNVly63Nif1cEq+KevZd7uNcjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cfIkPfu7Ud9GCgd7Lv2zW+ZXZUK4xd6exVIbNLcmw9I=;
 b=OCUYINe68cfgmK6Mc1rsU/YUj6Y6Oqv7kW30H8N54uwqVeJbBrh8EaNnoCWrxavaBIWP+qQ6UgzaIWQYdJ6v675PtqGSa8TPRjxrEs1hQDtEKwGix0WnNtHhGQ+PARdtztTRfVZITucAYiPoIMh+X8dgzT4k3rnHCmokCEuvznQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by CY4PR1001MB2230.namprd10.prod.outlook.com
 (2603:10b6:910:46::36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.17; Fri, 1 Jul
 2022 19:26:23 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::712f:6916:3431:e74e]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::712f:6916:3431:e74e%6]) with mapi id 15.20.5373.018; Fri, 1 Jul 2022
 19:26:23 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-gpio@vger.kernel.org
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Lee Jones <lee.jones@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Linus Walleij <linus.walleij@linaro.org>,
        Wolfram Sang <wsa@kernel.org>,
        Terry Bowman <terry.bowman@amd.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        katie.morris@in-advantage.com
Subject: [PATCH v12 net-next 6/9] pinctrl: microchip-sgpio: add ability to be used in a non-mmio configuration
Date:   Fri,  1 Jul 2022 12:26:06 -0700
Message-Id: <20220701192609.3970317-7-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220701192609.3970317-1-colin.foster@in-advantage.com>
References: <20220701192609.3970317-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MWHPR1601CA0006.namprd16.prod.outlook.com
 (2603:10b6:300:da::16) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 52196df7-3b2e-4a2e-1225-08da5b979542
X-MS-TrafficTypeDiagnostic: CY4PR1001MB2230:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qLIPtAXlPUqGJrF5UMQLVNRbXgXA5OdTus2t1I1b2Vz+0XiPiinGYA7sM01e2YPhbgGPifX9CI6FTRqC4KoqVzMS7VrYMc8ReWlqRtccXjXdrftdPvSHNCRh1glzDLMlyRA3yaLQPax2S1u0/XRgPKGDo6gSW+E2zP/abtwpp3UWu45fFaaF9h1kCpBdZrbfzq0yU80QIBUYgaX4CuPe0ArWOzx2Palz1PobisSe4o9z5RKu8xbHlMCH749AtA1WjEyE1KoFBg1HUXS0Uah4wmOF+JzX3XbG6zRZl8taYKVLZtH/JFzsM/UmU1cARC4JM46wBLYQZoXR7RJSxrGDI6rzju11T1ANkD9LzuGF3xCvdI1cVDwm7vsEPEFJfFhi2AEOfCYCYUjevOULbi1dPmzxJZ1ug85S8r97hAm2wmc4GSFaiWzyGZHrBrcyx4Ggm7di5luL/sTteTby60Nmmg2cTRp3+gukXne2IDwDgvCfr04jgvjfevh9qejaRJwMF7c7MPyyvzJ/6jiy7I7uOauolVFs+81TQIojTgDa0mBakPeXMnVh5fnwXiYF+CswoYZDUjMb0XTyhouX7EXMrS0YbHJGBhhIEqpzA4T0YIt0x13tVl6fWVwqDWvA+VFcJLO+xIyAqlDh0gs9FzjDj7AwEAxXofOvjzn6MpMpyq1Clexkl9CSxnG3zwRu7ZWQ9N2VVEuCydGMQrdGGpCk/pSQqZM3GxQ+wTdjpTcp1dNGL+rRnlU+/bNi/FKaRxAZBTvLgqzYznooqYwm3sANSEzjstfPB0RosH0qARrn6GakzydSRDo1J0GGwJwCt+RK
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(346002)(39830400003)(376002)(136003)(396003)(66476007)(38350700002)(186003)(8676002)(8936002)(4326008)(86362001)(66946007)(1076003)(5660300002)(6666004)(38100700002)(107886003)(83380400001)(66556008)(7416002)(41300700001)(478600001)(316002)(36756003)(52116002)(44832011)(2906002)(6512007)(2616005)(6506007)(6486002)(26005)(54906003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?G8bpSlJooYYdPMY8Y1X+/kw41RIqAs/LHZWWrIcPFpZUDfPrC1qQo+OMlBAS?=
 =?us-ascii?Q?iNEfifW4Ctnvm8I6P3UjPZXiJCuO+4SqnNb/kIb2TYEW8m7sPijn8ztpNnJk?=
 =?us-ascii?Q?QpPAppQLQ7PXthAZLklSmZpmXJ1nz5rFHs8g3Q5D9318BXyAm4HgFq9LjG+s?=
 =?us-ascii?Q?Xq3xPqBz2Oq0x4FUAymlIABT6nPrzS0xOC2o2wrXu93bRVXgCFn1nuEXHdsY?=
 =?us-ascii?Q?98QmjLxdXs6OyyjrVgyUngKsOowrUcavsS0na1A4UnJFDYDDa183uYyL38S4?=
 =?us-ascii?Q?6Y6fhGNKK9wdQPnP39t+nbvyVc17SKcU4xdSAVZ91nL0cN1dE2TUv9B8hfi2?=
 =?us-ascii?Q?y4py9Z5gtxwUT9w7JxH0kGUSIvBXknBW8LY1cXJgPndrskph/JDIYSYLtnjd?=
 =?us-ascii?Q?cEFQpLp4g8MVvAjiGUAUWUambJevp9DCZeunqLFNBfbEaAoG4gdC55knePda?=
 =?us-ascii?Q?8jPJ4ejC6GQEBtysxu3Y90VfyZpkBejSVixy99eHLNUHtxFvW2Dm7dKyo5xa?=
 =?us-ascii?Q?z/eo7Cc/k3e0H8L51JJgjvk2C/2lQJnXr5AHdZIpPY3fG2iyrWWTCd3pcv9r?=
 =?us-ascii?Q?REnl/KIoMFr6EwFuI1cgUCA5SygagIkO/jHLGa3yiDjrzssXgUgADa0tague?=
 =?us-ascii?Q?AI9skBT78K+TPbsLqbZpAylGMPiaIgmTVShlBh2urLogSicOwS20bf9gnSlE?=
 =?us-ascii?Q?y/4n81y+XPhPS9ZLDu9Uub2rAMe2ao5HlqpXM1i9ZXI4Xiw/hKDL6le/jn8c?=
 =?us-ascii?Q?w5l+qQr3GRDjqbQj2yjhygZJjPRLvkFBHuS+JrddlsWgxmVdQh9QjdeUDdGO?=
 =?us-ascii?Q?ltRHVHF5DLR/kEhpBxuLvcdEmKmWpXvUao2Njl8krHtXy2vk+vFKOqdgMit4?=
 =?us-ascii?Q?1wKtGqO69nw2lFD+vem5JXjpOf+Sc2FMZHHZfKgf3n+ZF+f+tfeV9CxUhgHf?=
 =?us-ascii?Q?WNzebrEWtZI8tFybL8iDQGV3R8/NS8qL1lPkUd7qjzxTfC6vA3RB/YU5Wvoq?=
 =?us-ascii?Q?j2jSnbuW9jo0d2USIRepT2rDCvN5N155lUyQnpuZUQbq5RsxKohH4ToE7NJi?=
 =?us-ascii?Q?Qp/ztlTYcbTQUp0r9cph8WjfY4nOvKLEUh/H9YRnaQs3IqM5SyjiDbl9NSu+?=
 =?us-ascii?Q?eGwzW2GVp5vo9bDESFz4s4CIl70Gww1kqqhscxSK8GDhjQK9RoDNZ7djLZ1h?=
 =?us-ascii?Q?gPGr3McNiu0IH0YWU9E/fH+CAZwW+fjHXUY63PzXTqn/iU7ACFG3AGT/jHmB?=
 =?us-ascii?Q?QZOO/eid9Gs3Pj1TTJAqngvkfPe2h+K4mF6EQmR2K3fXMWMTR5uUG/VB6a5z?=
 =?us-ascii?Q?42KF743EBjuW5ZcmPnpWikzYYyT3Vg4PVLV0XwxZARjvEQWqMB7X/px352OI?=
 =?us-ascii?Q?sWRgVJVXn92uFXpSwT7fkHwlTWW0E8QUc5wqUSrrxTiVqkpjwB0GrcHNTRxD?=
 =?us-ascii?Q?Gr6R2qOX6oa2+T9gohAoQjZnWioEsLij+T939ibZ63ZnNPrQmfQuJoij8KXO?=
 =?us-ascii?Q?0snswtKP9W542eGx/SbHVvshMXlj+GADBgv23AeXQNQpgnPdsG4JXSbjb5Yq?=
 =?us-ascii?Q?IhkIIciZhLfEbbfC1AB+RfZ+lU6sQQwvNa73vu5CrhkQk03onkgZzivn2mts?=
 =?us-ascii?Q?9Q=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 52196df7-3b2e-4a2e-1225-08da5b979542
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jul 2022 19:26:23.0702
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: adsTqm16FwwfScg9ga9t6g/dXnQ4XjpeRe9Id3hsfeXPQ82a9gLjxSUOYXl1HOoDxBEHRsq1X8vjlvCnmPPDWaZshM9iGCnODGc97EqXbYE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1001MB2230
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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

