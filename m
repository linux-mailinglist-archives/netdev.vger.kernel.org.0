Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C63D546E5F
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 22:26:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350744AbiFJUZN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 16:25:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346441AbiFJUYf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 16:24:35 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1anam02on2123.outbound.protection.outlook.com [40.107.96.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17EC430BF2F;
        Fri, 10 Jun 2022 13:23:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cb05GgOWAEk9aYvEXqtzYoBM+8Pgt8SlNF0JatVG/XPW2PBVroy6TMz4FyrvxTd8ZonxJquM/e/11QqPbuV4z5jcpNJgBDkRdXuB/PHwStCxVamYfLtTmpb2Y8s9AsxxOzDqLjnsSDIiY/hNXuG1LH6xtq7bGHz/2gKhasJtMMBNvVHChLgpVJpjrqsqp8grkxFA8yeB/37LRDYLiFs4Ri8ele1vdLLYmA/nWK3s+Nu/dmZIU+jz7LeeYOUMXXoquwAq5jNhEocB5MZXZLZmOy1y/OXmy/Xa4FLGmzIHcyzKmtx3KSFPAMqmZ8zQmxURR+MeU282Di3N+RrNUpEklg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iAdLj5PQta2TPxzuQkdcF5w3vYdR8cuUjFKNyQFjmPE=;
 b=LCxKkfJQt/eYWGW/JnhJxMWtC1lN4rPCam5xYo6U2SMpFSR+b7ptdd5FLDnSrIxAF9nySU31fySVUSuJqZCGGF3U3ZPE+8kL85CZblWocpZnOac9IJ3kZRogZciCemdq2jobWpg0uJ9X/QsevRfHp777o9Hzb+7xj31G3tP3n4eZaqQNOIdaLroprFwwGW1t0+GHfABQBjyrJoxKWeqpNAXv8x0G9CYETjsD/v94hrh+//hBxpITHICEFzzKwbZePQNt1XbF2+vOkA0wZbHkRnDg6j9ALpY4cMhKozq/WO/Bti9gZaVGzbpIBfs4aVrFK51QzIAgduhqO4sHhZq70g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iAdLj5PQta2TPxzuQkdcF5w3vYdR8cuUjFKNyQFjmPE=;
 b=MT80FS7hTF5V27D67KfSSctTzJYupbHb8O5QLPJXOeNpF8LzBY9R9m2Wxqr/8DQ8qbqRGhQaD3e6z2uVbGW6HrhRdG1J/T6NPfzTr0F4VlwCND9ZOrtKwArEJbg7aWi8k14qLbAFoUJm5BoaT3Rg5voy/OEMRf9OAw8u12kBxFQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by MWHPR10MB1629.namprd10.prod.outlook.com
 (2603:10b6:301:9::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.13; Fri, 10 Jun
 2022 20:23:48 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::b8c0:76a2:4c89:d10f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::b8c0:76a2:4c89:d10f%7]) with mapi id 15.20.5332.014; Fri, 10 Jun 2022
 20:23:48 +0000
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
        Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: [PATCH v10 net-next 3/7] pinctrl: ocelot: add ability to be used in a non-mmio configuration
Date:   Fri, 10 Jun 2022 13:23:26 -0700
Message-Id: <20220610202330.799510-4-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220610202330.799510-1-colin.foster@in-advantage.com>
References: <20220610202330.799510-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0246.namprd04.prod.outlook.com
 (2603:10b6:303:88::11) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 32082673-f455-42c0-9c0e-08da4b1f1fdf
X-MS-TrafficTypeDiagnostic: MWHPR10MB1629:EE_
X-Microsoft-Antispam-PRVS: <MWHPR10MB16299EFDA5E1C791A6EDA4BEA4A69@MWHPR10MB1629.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: avW/4DYqJrIZ6mgMBnxfPwo4qywPoWvkEo6maYYJyeiIWF3XQ7Bfwdg8FtM/zYeDDvQhb4ganjnOUB1EuN9e+Ju2ftob7/6KyJlq6NpMGbvDnMJtX7waLrL4AuCKXBQvkz9iKv9JI4vYw+80ddD8mycc4VihyyXRlx5iYy6PFl5ajoDJwMPy6AtP9uIQ56EhU/M1PuOtoIqvBYDCSs5T947b/q61R9pdBaWm8B+K4NSF72CUDRTXnAPGjHnnlQ+WAoqc4dULcWTI+CgSfjCzdBOtto2oBeCBV9sP3whIK2BExlwJdwqrEabP3WpmD9Q8N8ylyETvlKCJfweGaCpSCez5BshjKUTBdegic4b7QZOkQ+w5z3aYVGZpAPBHHp1KSyzYzhf4NC7LRPwpVdb/AT4vxg9pG1c40Wp7gZr6dNZb7sx858dYNMV9KzduCIWXLPVSiqlRo8vcxtvEhWrR5frg2OcOBhnagbhxm21WLU4/gLns8Ktfo3I4n40CaTRv4ky8A0aCGxpZ9XIT1zwrFN0/dZ+YJC8kfbuC1Eb/oyRgIYOoxzmX1q0da2sHpu2P4fwSn41Ou1OAUVb0RdVSe7xOly3fgOSK/VIj+OfUiZO1TauukDo/i3uyVbZloSTZqzI94guvp8Oj57Oj/XjrZJE58O59FFgFsmj9YagGcakoRFCI8Js62lbWVPqR+UkDFa9L1VMVGC7pk8FR9JXKzQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(39830400003)(396003)(366004)(346002)(316002)(83380400001)(2616005)(2906002)(1076003)(6486002)(54906003)(8936002)(36756003)(6666004)(52116002)(6512007)(6506007)(26005)(186003)(41300700001)(86362001)(44832011)(66556008)(66476007)(38100700002)(38350700002)(5660300002)(4326008)(7416002)(8676002)(508600001)(66946007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xe+czl5JeI7HaHTBkxKh0Wnab8ojXrHGiqAwEIAjkXfG/QrMfc5/tM7Bbnih?=
 =?us-ascii?Q?5k4WYk1H70/C+w/ZQafdgEOS8JaTpVBA3E98KRJxGl4nkm6OnPMXXolmQHTv?=
 =?us-ascii?Q?4gQilY7H1h5qNUx3E806PcVUoOJZs7Hwiz+dMpl0u11d6r9H8QYpQ8oaZHQg?=
 =?us-ascii?Q?1YjUhIrfLWA4jav5YSZn1AgrXN3ic/kAHf1/nN2qH4CeH7siN6ce/plvn/V8?=
 =?us-ascii?Q?rD3k5FcrRZ/zVSONTzrb7rLkJMKzLeoUQOZnhW4ABDzLhgq+nvUPNCAwwV7h?=
 =?us-ascii?Q?1tE8qsdhgW0Z3R6TeaSm9Ky0htOH3uwwW2goBNOLxvCF8AClChj+akuNJu9k?=
 =?us-ascii?Q?Ytd3uaytAotOUty112CHrrntqGgjefRZ2PUBuVDKcw9WVO7oJ1wkDOlurppU?=
 =?us-ascii?Q?4g3CTX2CmieFdXLSWJ3TWPfHDypiRqFQsnhFHGQeppcfAVS9V0h4jXft63bn?=
 =?us-ascii?Q?FQ+X9/feMAdQ/Jl+8F2eGSimmNsSrbb99NXGChrjN08XlZJ3mGkurZNmOqf0?=
 =?us-ascii?Q?xwQsGM+VgxQ+EdBEdPkVU9695ieLj8S2VwKmLjZKiBxkvNkao0xZTdzTdoOD?=
 =?us-ascii?Q?lCFGw6LSpVjb1tLRpR2Wi9oh5QFlnf6gf2sD43dT/lZnkKfsKmbADHEqE//1?=
 =?us-ascii?Q?dNCCDQKwTCHU+D5d6ITeTxRp/PLvVDm1NHeQ7+LsY7GtR0WorfLo5xCW9LsD?=
 =?us-ascii?Q?iEu/PY1nqt8cpidV44Q8ZM+tzBL2jwMbanDyfVgypbAJPo3wn+WXej+qa3wS?=
 =?us-ascii?Q?Yhqfi7mX6LK5c8i/LwOQ4DNkstSnuhvNxQodUC08xEk8fVKrLO/3CCaQySuS?=
 =?us-ascii?Q?k48dKAb9YLAxUS6jSKWLyNDZBcClhLhECN/px6Ek0qwQ9SwDopXZObjJkzIX?=
 =?us-ascii?Q?My0sV+ofj6yAeSUYKeaWfgycwm1WkxEY1bOuCkf+uH6jguDMNSqxQk3HA8up?=
 =?us-ascii?Q?VyKYLcfycZgPhaC6gFoZwtaxfy/7MgyHILKcWNWdal2ipyY0shEDFLesRDtm?=
 =?us-ascii?Q?aEWv9fRBGm5lc3MLJpydIGqYAmWegOR4nS25Jm4t+NdC12CuSMvFfRpRnmzE?=
 =?us-ascii?Q?UR5f5LIoQ+424zKn83HBUkmFhB2KwduceVDDDyTsPLiVXQXyd8dnZV66/ovn?=
 =?us-ascii?Q?tO21lfsaA+SLNrzHmU77YOO4bPjdOMzggs54R6QPpe4LrjMITaoFwkFGWcpP?=
 =?us-ascii?Q?WfDUj2XbgMiwqpTM9KEgPofgbKr9BKszMlGDBYOx6im6ZdXO3n0UgpSrkIZR?=
 =?us-ascii?Q?OroQhKudpDrEPevwr/pH8od7E0N4GkEgBtcXfPlW5yeeY47MNcZqpuHfTx3u?=
 =?us-ascii?Q?MMJKfOrfyYOQmDz52W5Kn7/aMmaxdq5Mc/DWE9Z0/Uo57ObwmgmRGLBcvF20?=
 =?us-ascii?Q?SjauA6ilkNfSgivPG5AfVeh8FoLB4D5brY8u9OzXPiSbd4U/222s3yGCu2bP?=
 =?us-ascii?Q?ehwKRcCakWMHj45iiuiLK8rbx8Pk7+NNNwIc/cZ0B0wgxTHEQiRKnbU4SWY+?=
 =?us-ascii?Q?l8PiLK1RRJgwobMeOOGvYA2MZWBryc+SGgmlPeOKDcNSY95HQpO79vSWUP5k?=
 =?us-ascii?Q?ON/gJtBvxntKELQv3e6sJuciXKaWYJDv3tVrgocEIJVaQ7UBRUYUJAuDttWl?=
 =?us-ascii?Q?HScWXqDl2Z0U9wfzJP8JXuQYayfUVMwNaYimm9XULH8kpURv9GLQnqiX9nmk?=
 =?us-ascii?Q?9ROL5z3wUwacoRXuokLbTC0nf4aECBXFtG46h4argFzLGOqhnxC59dbVwhZj?=
 =?us-ascii?Q?1q3M3Af+Qhe0u96B2c2sJb/oHTVQbclhwIeYEu5cjJnO0u8c5VMq?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 32082673-f455-42c0-9c0e-08da4b1f1fdf
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2022 20:23:47.9351
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ESkJWWZK4S1/lkg8HZAzlzc0/Z575XBNz61K0ezuqqqqomdRzFSjARQ4JqzIXxmA9B2ESr0nQNlreU1JEQWeaJRzBVokTFX71HhZZ83u7LM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1629
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are a few Ocelot chips that contain pinctrl logic, but can be
controlled externally. Specifically the VSC7511, 7512, 7513 and 7514. In
the externally controlled configurations these registers are not
memory-mapped.

Add support for these non-memory-mapped configurations.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---
 drivers/pinctrl/pinctrl-ocelot.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-ocelot.c b/drivers/pinctrl/pinctrl-ocelot.c
index 5f4a8c5c6650..7ac12102120f 100644
--- a/drivers/pinctrl/pinctrl-ocelot.c
+++ b/drivers/pinctrl/pinctrl-ocelot.c
@@ -10,6 +10,7 @@
 #include <linux/gpio/driver.h>
 #include <linux/interrupt.h>
 #include <linux/io.h>
+#include <linux/mfd/ocelot.h>
 #include <linux/of_device.h>
 #include <linux/of_irq.h>
 #include <linux/of_platform.h>
@@ -1917,7 +1918,6 @@ static int ocelot_pinctrl_probe(struct platform_device *pdev)
 	struct ocelot_pinctrl *info;
 	struct reset_control *reset;
 	struct regmap *pincfg;
-	void __iomem *base;
 	int ret;
 	struct regmap_config regmap_config = {
 		.reg_bits = 32,
@@ -1937,16 +1937,12 @@ static int ocelot_pinctrl_probe(struct platform_device *pdev)
 				     "Failed to get reset\n");
 	reset_control_reset(reset);
 
-	base = devm_ioremap_resource(dev,
-			platform_get_resource(pdev, IORESOURCE_MEM, 0));
-	if (IS_ERR(base))
-		return PTR_ERR(base);
-
 	info->stride = 1 + (info->desc->npins - 1) / 32;
 
 	regmap_config.max_register = OCELOT_GPIO_SD_MAP * info->stride + 15 * 4;
 
-	info->map = devm_regmap_init_mmio(dev, base, &regmap_config);
+	ocelot_platform_init_regmap_from_resource(pdev, 0, &info->map, NULL,
+						  &regmap_config);
 	if (IS_ERR(info->map)) {
 		dev_err(dev, "Failed to create regmap\n");
 		return PTR_ERR(info->map);
-- 
2.25.1

