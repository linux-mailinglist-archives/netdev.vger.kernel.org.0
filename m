Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0611355DCF7
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:26:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230457AbiF1ITm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 04:19:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243951AbiF1IS6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 04:18:58 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1anam02on2095.outbound.protection.outlook.com [40.107.96.95])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70FA42CDE4;
        Tue, 28 Jun 2022 01:17:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Dp/IBCVsqrBh2FJBfjz96AZoHaxzv3YpTNeCk9B/CLn5F9OryK2yMH/YsI6Fdhf24Lk5jwi0e4GKLtBn6KBidiJOjiu4vP/7mSbYccDVfHAQ2KE3vaS+i+K6t3UHCH8dKe1p2SszWm6xg/eeA+sr6e1ViRVFb79htcN/AOHkq3q2E93NZA1QnJwZb/9Qt/1i5OLml9YE9XC5wZQCHrATPcS1wdh2FHPOwFXGK4pttUOt1YqnAMqhMUM6XeaGpTvOk0Ui/kSFlzhmrCGVjfdcTPUpSetMKY02Dy9OAYjZRB7f88u5Ppa0wZKCSFzcYGMvv2coScVg/5I2k3KVpFz2fw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PwzfY+GguhcR7KO932G+UWCTveIJV9JpkJSHEghuGiY=;
 b=YSG2uxENF6Zj+XM7Jnt8vODS8saFiTDnpdzqz0/9HWUYhwimMwU7cEGSjlF7DPnQmBRwnpvaAShFlQKLi5hBq//xmb4Wyr0ZxlmASkZXwo5KdO7u0PEErpaNlNu98ii/VOXn/kSHepfTLZflFZhn0WEMvOIz7kZJGPuQWPgRJiK/r+7Ng/D8SWYQPys7A3ECsyl+X/A6GEAAzZCpkoV5V9jYsXqhphi8yCvlbCIJka1gm5d8s9qz2Z6ti7l6hhiankhJFfx4fSN8HgmLEsjbeDcg4XH0FcM46eikegmZM/tSaVGGiRzhMeXbF/IG6VuamuDBERAJL0dkoAmSUoJ5NQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PwzfY+GguhcR7KO932G+UWCTveIJV9JpkJSHEghuGiY=;
 b=aks+TJaXTF9+F1ISvJfUOBLyl0Cmf5BOMlU1ZUEkO1xY3Tu480BcxsD8dghrJpXcK2A4E6bGRWwv6HMGv7qeMhsgn/sTT2nrlDa1sS6gKmAau/PX/gG7d6k5fvVv8SjGEtT/3z7+imF1swFyG+GZwWTvIDEZeELBfRqt1q37Kik=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by SJ0PR10MB5891.namprd10.prod.outlook.com
 (2603:10b6:a03:425::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.17; Tue, 28 Jun
 2022 08:17:28 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::712f:6916:3431:e74e]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::712f:6916:3431:e74e%6]) with mapi id 15.20.5373.018; Tue, 28 Jun 2022
 08:17:28 +0000
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
        Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH v11 net-next 5/9] pinctrl: microchip-sgpio: allow sgpio driver to be used as a module
Date:   Tue, 28 Jun 2022 01:17:05 -0700
Message-Id: <20220628081709.829811-6-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220628081709.829811-1-colin.foster@in-advantage.com>
References: <20220628081709.829811-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0259.namprd04.prod.outlook.com
 (2603:10b6:303:88::24) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 64852609-427b-4a23-4875-08da58dea403
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5891:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eEPaVXuw1vcIYu+ilMwNT2G005dmJgURDrBFm1478H6i1GikYEIAhzoomnwQe3VOzXrCVohP+K0J10w+HxeHcpUqS3UDhDV5MLb0tBUiQ4Nyuz+S05iGe086HTQUpWY7CV6h1HjfLqHjfcjFpfwozqvhDXHE8mupWhFIMUrCGB8CJMmyI5gF/kh1+jK/7HqQ6NhChIGahvdC0VlcXJiKhmx0k+H0xy7UlbhiXSb8iqJ53/8qTOkwOuHBuw4s0neEdNmXiCU6T9Ep99OLOb7+eyap/gj8rVv8jGwndZh3gaUtkzKXsSvx1WO6fcFJutAwYXr7TORJCbrdbwZp9jh6J6cDrQA25PjmlDvmDhpVnTVxemuNLQ1RdbAINueJ6Ga6ty/2EWaPs4AFVYqYH8IcDnua5iAn5x1zh6BAOIcnTIiF/P1RX5qHiWOSCE/2VToRLZxzj8YlzCSBUfjag3UP6CMk4jl7zqRR5mPs7rfTB0ne3lSAC8/gY4s47ISSfGWoCr7x+NN6pZ7gH3Se4vQ2vy8UWMJ9/WY6o6JStnuuXOkO6NNb+inDTsx6DB+pADI+XejR77AJuvL3GbwcsQEughCn1qKulb2FDptsatif00NObt30eWVFT1QxVpWSFtHrhfAc87C17K0gbw27TwRBnhrFq9y/fERqoOubjy1/ISArV8A9whQJMNE7qIjGLZ1vB7kBiicXRzyuxSouVbmsiDmypmhAPbfOBXc6KChcAskk7/Se0MVOFhb5YPeBeDSfySK5vJueyiYvrnKATdjJsQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(366004)(396003)(39840400004)(376002)(136003)(36756003)(38100700002)(6512007)(6666004)(41300700001)(38350700002)(44832011)(478600001)(8676002)(4326008)(2616005)(66946007)(66556008)(66476007)(6506007)(2906002)(54906003)(86362001)(1076003)(6486002)(8936002)(186003)(5660300002)(7416002)(316002)(83380400001)(26005)(52116002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FuI2eLLZePhR3/R2Gr+ShNrIV5rIyZ1qBDtzYzkjUjI3UcPYViDNSTMqRZrr?=
 =?us-ascii?Q?BPq/pv3SwdNkx6gjTn3MRvOPqbwJyhoIIL+zd9yviQ+dGscAxi6QzQIZNV1y?=
 =?us-ascii?Q?BEdIu+PkQyAmo73xM4wRPLPCRN8/BB97aHNLborcWF1oB6b40Wnp+lFovzr9?=
 =?us-ascii?Q?W+QDrjznRM42s1E/PhnUXV98ZM/568aTdlZneRxP4XgPhS0gsWbQxadnK6Vx?=
 =?us-ascii?Q?b0aN9Yka94l3JtnfWaa9J+nTgy4kW252lpdM/nKVGsTEKknqQNOB8E5Xb9a2?=
 =?us-ascii?Q?6wLeHG8wF8Q6RR2KwdS12y0JkO+lu7E8BYzjOA4c3Ff+pzfhEEe8miu+chsE?=
 =?us-ascii?Q?iFoUyPV9ikCxSqTWgBGwlHqid4K2B47S4buVYkK0o8ADi8rps2vlyzl9P3yT?=
 =?us-ascii?Q?r9BmfhVHYf4TBldMM44M8gbm05UEP4l54owe6pH+wJSfAYWaSBgKEZKsZJ1o?=
 =?us-ascii?Q?zx7EZhSGSXPSRAWF7vhPkkQYhlrsTxSjymaXO5j22w4f7ocnpzc4DVOGuLUy?=
 =?us-ascii?Q?pExbb7CbFD/MZrWZPp+76Xev4Oc1Q4FdLdyBxFvdiNAScWPxCIhfD4DZh/wW?=
 =?us-ascii?Q?soanIePDJxMI4nngL0zHwd1t/idb68z/G4sKHC/oPwh8WrosPO1o6zHstCtq?=
 =?us-ascii?Q?s11hQYzpO5WualjVT11KZHYAvD0l8Zmv9HmVMXqrp8YZqi+woGao1hS1pS64?=
 =?us-ascii?Q?liL/8NnVs6qZKWlcX2/J3u4E5MmMhV1IC/FGhs7lFRwcTMDkGM6RUMoa6Nzj?=
 =?us-ascii?Q?CudWH+Xv+2uulZaQaMJp2bdO1AI6xA+Nal4EetoPKDwqkUKgORQNCkqJV7ym?=
 =?us-ascii?Q?elSLbAe8DtiL1lYzvCz7NTLMC/LPMHpzr8Bm18UBBssIjBP3/ZDdrZcNL9Oh?=
 =?us-ascii?Q?u9FjZMwFF1CoNd9S/gYtFWEYyqMvP4Lx1J/eztSfJ0MdD294lYBUA3FJiPlT?=
 =?us-ascii?Q?ByUygYNv0sVUuDp/QU33ZrHPMx1Ucmz26xCl2cAIMh9e0YQzkXUTeCaE+Rmr?=
 =?us-ascii?Q?sVm6t0JEpjkSQAElG+yrVoJsQ2L6WckW7r9cnQm7QE4/HJizZsFftHGTJ2Yi?=
 =?us-ascii?Q?9okpnIkXoPZtFJcZL7k2rJKvTwZUvVouTklstF8crTncxSoU6pM/1mxA6SQ5?=
 =?us-ascii?Q?D8KGCg2eDM8tOUI7kcIlmoTWuh2JAXfDgRK3kMyLfdNZd8zqSl61zGZPu0Ms?=
 =?us-ascii?Q?mvaqWF48Yc9PTgdgBc2v7wTV/06XeURD1fcf03N5L8lt0X1cTRMZSNnKdBCy?=
 =?us-ascii?Q?19JHtk062FVCcHq1hWY8+Id2dCuvCBjYGAXw+K84kCo7t/umGyfDG3BUK8pI?=
 =?us-ascii?Q?6FcMBxH06YBuuMp3qnys61UQwnF6zGQmZHFWTA4OucyGtsW5xB1lmREkuvHv?=
 =?us-ascii?Q?23mM3ybkeyAOtTm5HmRMHwf6fHRecFeBHuuDa4tmth5ABJsmSBHAEXXsXp1F?=
 =?us-ascii?Q?iOwxgAp6dSUD5SeYtTdV8ZvOw91yekEEz6m0zBjwoq70J3kdN4nhDlDbL8Jn?=
 =?us-ascii?Q?/6x1ORUL7jA2ukCYzpv6PiQpveFgjz7KtV1WLQ/i3Jyn62kjnfbsxshlkm0y?=
 =?us-ascii?Q?FXns5q14x60fwqP9tdyZ3O3h0T5BPYMr3ZDr2uRKdJqZ5ssyk07Aw3MPNbSS?=
 =?us-ascii?Q?LQ=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 64852609-427b-4a23-4875-08da58dea403
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jun 2022 08:17:28.5883
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tkuRVM+Zw0N5b0j5eJvER5+7nXkPVcoqoKHsK3rd69W6UUW6sMhaa2hE/NiOo3iB5yLtHS3LPNAFD+3B4+xaez9g5SbXc/DuvAxRfmak5N4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5891
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As the commit message suggests, this simply adds the ability to select
SGPIO pinctrl as a module. This becomes more practical when the SGPIO
hardware exists on an external chip, controlled indirectly by I2C or SPI.
This commit enables that level of control.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/pinctrl/Kconfig                   | 2 +-
 drivers/pinctrl/pinctrl-microchip-sgpio.c | 4 ++++
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/pinctrl/Kconfig b/drivers/pinctrl/Kconfig
index 257b06752747..40d243bc91f8 100644
--- a/drivers/pinctrl/Kconfig
+++ b/drivers/pinctrl/Kconfig
@@ -292,7 +292,7 @@ config PINCTRL_MCP23S08
 	  corresponding interrupt-controller.
 
 config PINCTRL_MICROCHIP_SGPIO
-	bool "Pinctrl driver for Microsemi/Microchip Serial GPIO"
+	tristate "Pinctrl driver for Microsemi/Microchip Serial GPIO"
 	depends on OF
 	depends on HAS_IOMEM
 	select GPIOLIB
diff --git a/drivers/pinctrl/pinctrl-microchip-sgpio.c b/drivers/pinctrl/pinctrl-microchip-sgpio.c
index 6f55bf7d5e05..47b479c1fb7c 100644
--- a/drivers/pinctrl/pinctrl-microchip-sgpio.c
+++ b/drivers/pinctrl/pinctrl-microchip-sgpio.c
@@ -999,6 +999,7 @@ static const struct of_device_id microchip_sgpio_gpio_of_match[] = {
 		/* sentinel */
 	}
 };
+MODULE_DEVICE_TABLE(of, microchip_sgpio_gpio_of_match);
 
 static struct platform_driver microchip_sgpio_pinctrl_driver = {
 	.driver = {
@@ -1009,3 +1010,6 @@ static struct platform_driver microchip_sgpio_pinctrl_driver = {
 	.probe = microchip_sgpio_probe,
 };
 builtin_platform_driver(microchip_sgpio_pinctrl_driver);
+
+MODULE_DESCRIPTION("Microchip SGPIO Pinctrl Driver");
+MODULE_LICENSE("GPL");
-- 
2.25.1

