Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B911251EF67
	for <lists+netdev@lfdr.de>; Sun,  8 May 2022 21:12:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238888AbiEHTGH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 May 2022 15:06:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243933AbiEHS5f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 May 2022 14:57:35 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2110.outbound.protection.outlook.com [40.107.223.110])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CBF3BC08;
        Sun,  8 May 2022 11:53:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DxNGBrE+MaeY+lPamUzvIZx04qVyUD3q/8UmOsxIxDkJJM5JQZS+DDKeLfB3m08/xk3Hg/tkNKIs78Gt9dyG4MTS7TQXbhtB0GIgEgqiJaDYSp71V/+/mow8nj67+DZkP7G/GPBW+y4iv9ezwVTenkGYVFH+Y3oT4X2eA1w8cQwPVzewffG162t/WYDO9ELHF1OznHj7NEH2IKbnKNxST9AkpM3HqqIiM872l0L6ZGjgfoaDkTbybWnNOMN4w/uZnpXwldf6/camcdbN9whnwHBJqKOXmK9DXD75P8TqSn0neIEj/iiau/rG6NlaSBXs0hK5Hh6OO/b+HvVuOpg0Tw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dpcqD3YrPb8E3bZrxcGsy544jFxVoAUX4RKcmXtCjec=;
 b=Wea5LnyDfwEl7BiIUtSW/SAwXLkWTuiX9eBK/w2iPddUEu2yVp9Dyr1LtRo1ZbtvWQq68mZUxIJDeKuSlNJYNjBcMhIkuV3pabAK9UnFOlgLn2n2aWtccSdRNkR6l+uhSkvlNYATHBd/+Qs0es4xQxykEFdhTfqLab3bRlt/kbvhmzulPf2ou+lfR9/gEFics8mVsTpEUZnSt27T51rdggrVSVWxHwpyGrzCxBmK+ypoVs8FRckush3RFCwFLSMkGSiLjcX54L8LBIKQuJSPEFXBrt6ppH0eaq1aSONkOw1xjJ1/qSCmGnwq3DxmvefY3W5lnfOPTh23Ub+RRNoXEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dpcqD3YrPb8E3bZrxcGsy544jFxVoAUX4RKcmXtCjec=;
 b=sTHVyeYJB8I2g7WB/56JbT55tjvU7YnHtEgJo1VrHgAvS+8eqmUyk05JRbnDQ+K0EGvVg1RrBKoE3RD8qQ32HCchA82Ib0nVtaW8R8Q7V1KSMXQ1Yrwmk6mhpbBpgn8GTCqVMBbdbxX4JZeMfjsGpW7QNaq36z8P34S29aL/kKc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by SJ0PR10MB5533.namprd10.prod.outlook.com
 (2603:10b6:a03:3f7::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.21; Sun, 8 May
 2022 18:53:43 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::4581:787c:1a7a:873e]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::4581:787c:1a7a:873e%3]) with mapi id 15.20.5227.020; Sun, 8 May 2022
 18:53:43 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-arm-kernel@lists.infradead.org, linux-gpio@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Terry Bowman <terry.bowman@amd.com>, Wolfram Sang <wsa@kernel.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [RFC v8 net-next 07/16] resource: add define macro for register address resources
Date:   Sun,  8 May 2022 11:53:04 -0700
Message-Id: <20220508185313.2222956-8-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220508185313.2222956-1-colin.foster@in-advantage.com>
References: <20220508185313.2222956-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0045.namprd03.prod.outlook.com
 (2603:10b6:a03:33e::20) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6dbb1fa3-8aa5-46ff-57cf-08da312412c4
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5533:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR10MB5533B4F5FB3B16AC380C39A8A4C79@SJ0PR10MB5533.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3H/Ntezqy4Bk0ebxYcJNvu3o9fvP7xoAKfc2stWksl4VYjWW6TcVfyGEjRvxyg1UPUMdCWbr5VV4n/Wex60tB4xMjjqu0Lro25J6E/PZdoQq7LFrKYWel4jMF/e9pYn3M6BO93ZdmHiu15TAfQ9mAHhdLNA0W4/7IHbq1rsXa0SWI22crOyT5Of5NYpvK+MNW6GOZDJlIUQ5N9+0rFmKsWWEgOxeOaVghKfP3T/Mru/OBPs0mH/ERGxAnu+uIFUvdfeAV8H1w2YPOFfbbhpMTDS13fzBvAPgjaq6R7gvPjVCf8f9kTTfSv2ZkvxQcHEeIx/af2KcmXJY6wnRJ4tCsTnlUgJwBGiFsjiMYg9TPB26J131/YL7mUMms75jFLA6qAZG5++uzzhqb5vd4QWGVxZfKakxEEnEnGQ4WIq//WbYjUCWwMjiZ7mnPMb7Mq6hVkbXJaRUuqqRDixBAitjFvSOdTCTniqLwEZWNt4bTlDrJ06t3XxFCfI3RorG9nNkz2QY1O/ZanG5C7wSz0b/HWvrCJSGhHxd6H4JutgUMqfjnX/a6WMYw9a9/IjB4mKtRZfho+gWkSkhRX3kY4r7dGMnpAy/EiV+M0HKTjisphkpiJyf7mFWsYzG3ndnr7lkzL1qVo8ooIF3UEREAK/xPG7D/x54h6kubhrLref+6oocd5FvACYOgSVn3kAm8VquJxZiI2utC/6AxJrVoKjYuQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(39840400004)(136003)(376002)(366004)(396003)(346002)(316002)(66946007)(6666004)(4744005)(26005)(66556008)(508600001)(44832011)(6512007)(6486002)(66476007)(52116002)(186003)(86362001)(2906002)(4326008)(54906003)(8676002)(38100700002)(2616005)(38350700002)(6506007)(8936002)(7416002)(1076003)(36756003)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?SKNidOQiSbKIg2237WiIdQSCmWPqka7VeVMCxqQS1Vta6U4vB6Gg6Co0PiYX?=
 =?us-ascii?Q?alo83CDWSk08/9V/Myu3v+B/T+UaLWKETqlInhGv4bHf0LiWaIgRulrkdbMz?=
 =?us-ascii?Q?E/GZatK7+4viCUu8srPk7u8nND7pu5XuR+qikGJlvaMPl2ocotlEWS94zE1z?=
 =?us-ascii?Q?4tepYmX4hi/B3V5S+4RISksyy+r/JZ2tyZ2XKyUOnqoJBHOP6t8MAhtHKfiG?=
 =?us-ascii?Q?QDa6Q2fCCIxzmWTBC2y3Ro4hyFA0vwnEjhtL+6mYzXOtZjz1SHvg2OfsGG7g?=
 =?us-ascii?Q?xbVvo/A6A4R0vTEnhvoQ8FzoXzcVNivkK22yDqN7zMEob46iS4y/ekWi/DWM?=
 =?us-ascii?Q?Yzns9orIovJBjMyGfqyR9I+i1ZJDhswuUifDoXl8bF5shYMSbFv4HRI4NSku?=
 =?us-ascii?Q?iI/IJcESyfvM7DPmpbAO7FJsDhKcgaH6oNxbMbU/Z9VW1VJPy/J1mnj4T49C?=
 =?us-ascii?Q?JU9OiJkmltR/VaS62DSkQW/O6956KwfTPrHTuWqq3xWE8j3wBi82qkiF270j?=
 =?us-ascii?Q?f6eIfvTXLVfuiCiSvHuqlqn+GmBi/FLVgYSbY9s4RLP0B1aOrXabNBDajYky?=
 =?us-ascii?Q?bROHWqs2W5wFp9KeZqF0x72BZ3nG96La/nhOlc4tEcL6eTa0yorbsYX3tHyD?=
 =?us-ascii?Q?TJN6B0mXGuqWdZtvKMJUARKP/Fo1ymX/rA/CTK+UwAdeZBhEK1ObE8D7nLKP?=
 =?us-ascii?Q?LknQPLENDAuT7TKeoq9p4v1nnKBP4usLh7gkhE9VIT2SQYjtW4MZ7B9sYPEm?=
 =?us-ascii?Q?81ylBQVuxPk6Ak8651tceTEqxunlHEtgvKTYsIFehDdcv5vmaBB/JaCdmQwX?=
 =?us-ascii?Q?Qot6VbW60zKQzMFiNp6YpuwOuvkQca9g+xUsUJrjBAgARAl32eRFvpnEcMhd?=
 =?us-ascii?Q?dVTfNIJEvffNU/CxkB6h04h0bgetbUMIUtX69N/dphfudze7Jkgvfj8jDvCI?=
 =?us-ascii?Q?Pb8pqDahxzy41O0YbfSOx8w8Xt28JDpALLiWyHjdYezH6AI9EophQx7JQn+C?=
 =?us-ascii?Q?g1dgP875onKFR58Ee/hBgN1xoQBoGHfHYJegKTD1sl/96Thb6sgiV1ZiMV3w?=
 =?us-ascii?Q?UdcRMwqTl+9kKgjCsdoW/8InknACQPwgmRzNb0usTUi9bRF8feVkD2N8+5sm?=
 =?us-ascii?Q?CVFt+HUnZMZ2L1AtughC5mLh/quciitmReiKROtI2TexCgSQb6be7eyw0rvk?=
 =?us-ascii?Q?dLkOVYPp+xH3e645VFDHBdCV6XRsGHZFRzOz2+js8KX8+ViIZPhdN/lpg7/x?=
 =?us-ascii?Q?stXTEcFO9rAvlJDbZkNiQ6+sn7GvuVO9RwXwOl0mW73bfDq89C3w4AAtpo98?=
 =?us-ascii?Q?oZVbNqa9UTdPR0Z2BC9EnNekSzZRB0P6eCdP2WhPdxW/ZCV03FzIupqQPNmH?=
 =?us-ascii?Q?SRjx4xCBi3vJER3pU+ftq/hZhLnJExF/BAuCVrKsulKXkwHLRc5maxLJwACx?=
 =?us-ascii?Q?AipXXFgM7lolyus2lQN9pLc8SY59hwpC5RWHLx059ERvCRLzpqcwcLWxjR9P?=
 =?us-ascii?Q?bn11cmNEtiy4PKCpQWxx4ks0QV9Db+zncDBNMl2N1KLyUrqm0qydgd9dF/g1?=
 =?us-ascii?Q?Fmw4Go37z+nrRZt27lYx2KaVQh3sKpQQRMCi0Feti9jwTosURNtFtix8YtNL?=
 =?us-ascii?Q?MwgWFtPXHVATpODxt4s8QwbjBn71y5Sx5siCeunD/0WWBuoZgkssQ0gosTlR?=
 =?us-ascii?Q?FUaoVCBusA1cYFRHdmYddp77u3lgFILK+ATowhdznvddcE5Cnu0XB5unfNLD?=
 =?us-ascii?Q?Q9acJexRlFHtJ6J2iZrv4ZO5SsgSU2yuYMbxnLM17gvanCq95smh?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6dbb1fa3-8aa5-46ff-57cf-08da312412c4
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2022 18:53:43.1974
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UWF62PmgXdw2E9x49HpuNmj/r6r59JEafMlMjhKHXUpusO/4m/Rl8hZSMETYQEJPT7sEaDq0njmECQ8mgp60Zz3lETNg9W8avKRJV3Dp5cI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5533
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DEFINE_RES_ macros have been created for the commonly used resource types,
but not IORESOURCE_REG. Add the macro so it can be used in a similar manner
to all other resource types.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---
 include/linux/ioport.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/linux/ioport.h b/include/linux/ioport.h
index ec5f71f7135b..f3b0e238c020 100644
--- a/include/linux/ioport.h
+++ b/include/linux/ioport.h
@@ -171,6 +171,11 @@ enum {
 #define DEFINE_RES_MEM(_start, _size)					\
 	DEFINE_RES_MEM_NAMED((_start), (_size), NULL)
 
+#define DEFINE_RES_REG_NAMED(_start, _size, _name)			\
+	DEFINE_RES_NAMED((_start), (_size), (_name), IORESOURCE_REG)
+#define DEFINE_RES_REG(_start, _size)					\
+	DEFINE_RES_MEM_NAMED((_start), (_size), NULL)
+
 #define DEFINE_RES_IRQ_NAMED(_irq, _name)				\
 	DEFINE_RES_NAMED((_irq), 1, (_name), IORESOURCE_IRQ)
 #define DEFINE_RES_IRQ(_irq)						\
-- 
2.25.1

