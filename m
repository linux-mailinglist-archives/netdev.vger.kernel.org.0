Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4507F55CECF
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:05:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243722AbiF1ITS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 04:19:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243910AbiF1IS5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 04:18:57 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07on2136.outbound.protection.outlook.com [40.107.212.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3D582BB0B;
        Tue, 28 Jun 2022 01:17:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HjeQmyHRwxQ7QIgJ0Zh0WnNOKesjIycwfvX/Ad8Lh4hDN0IuXX4ckpPP9AZUi+K/mlQwkC0VctBRW0Ao47Dvi02mLOON+1DEszXCZh3nJLpI+y8n2QTz+SpRuq2Vce9ts5QcoV8VB5Gwgq7/ZlDL08jxa+bZu3gLof3Ao47Y1Kl04TiVpN9IEKgGJe7OY2ATBnA4KbF1qTqgM3+a5h4ojNx9sgnlZxkGidUGRRnxw1tOgGjktqpiU3snZobW03gqU+acm1tsu2Yf29K82wbq+bR1IROuj0z4yOiNFy48XEBHKQlFLg2a4zyY2+pXFOJzyxQcFOEZr+D7z/3Hy3TUjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8G088u5+cp8kN7ctmVBiVFtcatjgF7vsa+tb9IZ9h/Y=;
 b=f1gJe+g044xam4FnyxZ9mdo2r92zmdoPUp4GAgktyKftxDtwYijbf3sH4pR+AWGSd161JwIpsu5HzljADzdb7G9P0BR5+a7kcf+0fn6LAijTRLCYzF8Aq0UN3HiwTg6vQ0XCIf/9nlBJsXW6Gr5J1GbMgmtj/HkF1jVqOBjygMKU5wUiS85FROWs+Z/a3JqLU7faBYUzHXmiY0CkXbLnmojgan9VhXK2DA5m5uVvBUmVIBFQuwcX59jmKjR5DDSXpV7fsr0dt/BnyLPeck+fJ1A0YnVgm03PQna2gJvvt3BhmQXKPYfjdYxtx9Fur4+zQ2u52a+dCG8CDN16ySTFGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8G088u5+cp8kN7ctmVBiVFtcatjgF7vsa+tb9IZ9h/Y=;
 b=oNDPYYoZZvOXbPahTdVlJLXOV2H9+CE4zqpUulIt6b5sqNK6SJE8Bb450MAPjKnKHfAUQYrRd4iVACjx2XN2xrMcfYyzflbJI6PgTJxuVFHlt1iDTqRNw6vnTjuztPLmfjgDPPxDxMYqGYVNYvBwO58bJc2Vd8iYHMtg1x8Ad00=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by SJ0PR10MB5891.namprd10.prod.outlook.com
 (2603:10b6:a03:425::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.17; Tue, 28 Jun
 2022 08:17:27 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::712f:6916:3431:e74e]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::712f:6916:3431:e74e%6]) with mapi id 15.20.5373.018; Tue, 28 Jun 2022
 08:17:27 +0000
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
Subject: [PATCH v11 net-next 3/9] pinctrl: ocelot: allow pinctrl-ocelot to be loaded as a module
Date:   Tue, 28 Jun 2022 01:17:03 -0700
Message-Id: <20220628081709.829811-4-colin.foster@in-advantage.com>
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
X-MS-Office365-Filtering-Correlation-Id: ec780eab-7c18-4620-8fa3-08da58dea344
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5891:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DO2lU4bv8iBQJEeaeks8dReJOqdyqYQu9s7rLBnVWn982D9N8ajVYB82WbwQUS90tuWangwm6wxQaHoU0RUVx9tzcJurzefJ4Ur+Q0iG2kg7tWRndjLOsu8xh3VclPYxlCZypbr91AcGijphe0/CJj2Xfakd2dVH7abRY1n13pVOJwFNwZqS8vb5/fLQZLOTTyE7G9Sd/s0P2UVtPFBxoKN9AZ3RDSsJnXjFuS2OdhOiC2iCTyBftzbTG78IPIgywqkeOp8kGBgaT+CAvYf0GDSgSsRWW9R9lDf3uJ1QGlAUPfalryqMCsw/sKuZIsdTI0/oe7+OJr3kvB+mpHxioc/VhLiz5NsMMYQ0zRkF/dY7SlxKbSJC63vYIOTWoz6L8n1PBPXNfAniGH7F5R2Uf14Mk4qBMk+hYQzIQnZefWuvugQK/b7AQ+D1odRHmNf8Syxs7qoXxkpPylxX9Pjxu8Nto81qkm93g/CBrDONnnnzYNT3lmPmY1ua9u/Cc+igwFcrUaIgYHB+XWnXb3jgzyqWy1HgEsOA2QeNQRqViP+IAQx0PRcFk5t2M92kBna0o3u1Xd3We4m3S+snKbsEtlQ4U0yKxYj5hVC+aw/QE+co2g7k7gRdGbtVoz0uW9pnvrnBmABo7b1Ze3cwi+Q+N5tsfWVnaCKk/8afQlS6WeUSel3v92Od0C4FfX9iRrTPYIeOAbT6qsfQ5lZ5HDF5K3PQdI3i2vny0ZqOLBzKOOozDG5dCR0+1P7C1dDl0oaPC+uunNpzN8v/2+yqjFH0shdbC8hhxzB3Q5qytQUfHsc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(366004)(396003)(39840400004)(376002)(136003)(36756003)(38100700002)(6512007)(6666004)(41300700001)(38350700002)(44832011)(478600001)(8676002)(4326008)(2616005)(66946007)(66556008)(66476007)(6506007)(2906002)(54906003)(86362001)(1076003)(6486002)(8936002)(186003)(5660300002)(7416002)(316002)(83380400001)(26005)(52116002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YBenDUTiHjDqa4HdcaMFalebkuNGODVBJcd3vQ9nYa0g8O9R8lXNQEWrKzaf?=
 =?us-ascii?Q?9NLlAi83E8ve4ahtwW68Jpa0bb4a/ibyeG6Qh1FOkYfUDbBhRRqH5DrJOfIG?=
 =?us-ascii?Q?g1UUkmF6wVLbUyaDmgfr+cykOQ6CQpn/hOyLIL9aH67F/hQxmJbrae9prBae?=
 =?us-ascii?Q?ABNsRBNX+HKpDEtzwSogMpNrssusdth55xNaKOiSoL89h8JpvzO1+jaqqCUr?=
 =?us-ascii?Q?QLjcWS8okSPn2fGsAmcDw/8FnTrqyHPCyVGXtDaEMixkgsjbU6HucNKF71+o?=
 =?us-ascii?Q?hPEzZVtMJiZv1HKzmWXyN1eQgE92myVAHSs6eOeSXz/gGzxoIDC4sPf2zCPf?=
 =?us-ascii?Q?qyqzlj0nZIWkPgxUIO0LhfEiofUT32y4OZ6Wmvq1xa13uAgup/gU8B80QDNl?=
 =?us-ascii?Q?rH0ihzjhP1ufgZnKbLqGRPRMS1WRq+wzI56tmdjd/GicFAlsgkita/uB3uCG?=
 =?us-ascii?Q?ntQ4TgkrVCJ9+zT8TttVUuSCyp9ZxQuVmCFBoXc2qzhNDB9GiRNJLPyTRPVZ?=
 =?us-ascii?Q?RzFR2gDYbZcA9QizzPviNFnYlhZhHoZJ2ddsgEAg0nOvKO7P3kB+fmlZEeX6?=
 =?us-ascii?Q?IQGh7mg+HWlK/va8o0RkGHtVinotkcRpfSYLeiOhaPLE4s09DtM7Ld3wQ4Ac?=
 =?us-ascii?Q?M/ol6tXy20G2aj+8bwbuKCKsQ4ocGXj9OpcRpUjiwkGIUQYE18CWzFcN3EUO?=
 =?us-ascii?Q?5FR0IaI6fGNqhIwhNsyknhNOqo5XpNbWSG1N8pnTzUhQYoqETxRrLgQ3SJc1?=
 =?us-ascii?Q?3u2W375KTRSIjy1nRwFt7Yp/I1gTHtWNmvvYdqMF1UCfXWGwRoTXSoHV7nux?=
 =?us-ascii?Q?r09OGCuRxWW6MaojhVGUxtv+gxciDp1IwfS9q7JKTIrqsgRPqEKSJm1/23Z3?=
 =?us-ascii?Q?OVYlcxYxCKxejEXKa8MM/UyvMsh+7TIPbjUZx9sOk8lSROLfZYICjYkTFRd/?=
 =?us-ascii?Q?Zet21l+J6DGZXnuA95GG9110LpUX57FjhbbcVGhZYlRiyjqpwT5LBsdQj0zQ?=
 =?us-ascii?Q?4YZA3ib5oeJqxZseGQqSAXvi0EaTDCw+p/vlkdeowKvUF9FcnwkpGgVEuYce?=
 =?us-ascii?Q?fFouPBY1ip7gZNYc6I43xp1wwuUsSElvusMWwXYrRsKkEzSRTtb7GJZGg6ce?=
 =?us-ascii?Q?Sl8lh+DEIDaW0dOM38BfZBIOxh5z+RAXPleMCROXjVgmezq423kRm6585sjK?=
 =?us-ascii?Q?dHkFcd/WKzXuEW9b8jKUcxEgwpaqByhqrhI4atwUTiHLuPduPkkTo9scNDZ4?=
 =?us-ascii?Q?0TIg8Ji4JXtJh2nG7yC3DcswkDadF3YPflSeIHxmCbzZCvDS2FX7ToI72SHs?=
 =?us-ascii?Q?QMn5uOeNTGr2siV21RVX+yIITVy5cWuUWYLT0l7Pks1omPtR6w3OFSdDFZXQ?=
 =?us-ascii?Q?ZPGNLLp6Oc2i9dyMF1QgHol210ybw3T5NbeGHlLl00GMFcCEh0yrGzAWz2wh?=
 =?us-ascii?Q?x5fcO/zErb1/cF0dSIuDqfAh5jF/Z7z7Vy3qLhyTwPKHmRqI8c6kBeH7B+Mf?=
 =?us-ascii?Q?f4FSB1aXmTgfiYiuVqLz08ihOXyXnO/cNmIqIxy3i6SnC5Earg9IChGQOP2i?=
 =?us-ascii?Q?ZtL2hlxeGlb23U/1gWWvMCFnPzz75kMZF4QIrJymuq13Ybnh22x0iOBffavx?=
 =?us-ascii?Q?cw=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ec780eab-7c18-4620-8fa3-08da58dea344
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jun 2022 08:17:27.3384
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: w/IileGREFi//JGX6+l9K34a+NrLZPCt1QOuFwxTbtgBBubVtTBJhJ+w1MbeFBBN5W/69N3rV9wcceZpuZ7IM4oOlVXgZ1gs2AlEmQL2VLI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5891
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Work is being done to allow external control of Ocelot chips. When pinctrl
drivers are used internally, it wouldn't make much sense to allow them to
be loaded as modules. In the case where the Ocelot chip is controlled
externally, this scenario becomes practical.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/pinctrl/Kconfig          | 2 +-
 drivers/pinctrl/pinctrl-ocelot.c | 4 ++++
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/pinctrl/Kconfig b/drivers/pinctrl/Kconfig
index f52960d2dfbe..257b06752747 100644
--- a/drivers/pinctrl/Kconfig
+++ b/drivers/pinctrl/Kconfig
@@ -311,7 +311,7 @@ config PINCTRL_MICROCHIP_SGPIO
 	  LED controller.
 
 config PINCTRL_OCELOT
-	bool "Pinctrl driver for the Microsemi Ocelot and Jaguar2 SoCs"
+	tristate "Pinctrl driver for the Microsemi Ocelot and Jaguar2 SoCs"
 	depends on OF
 	depends on HAS_IOMEM
 	select GPIOLIB
diff --git a/drivers/pinctrl/pinctrl-ocelot.c b/drivers/pinctrl/pinctrl-ocelot.c
index 5f4a8c5c6650..5554c3014448 100644
--- a/drivers/pinctrl/pinctrl-ocelot.c
+++ b/drivers/pinctrl/pinctrl-ocelot.c
@@ -1889,6 +1889,7 @@ static const struct of_device_id ocelot_pinctrl_of_match[] = {
 	{ .compatible = "microchip,lan966x-pinctrl", .data = &lan966x_desc },
 	{},
 };
+MODULE_DEVICE_TABLE(of, ocelot_pinctrl_of_match);
 
 static struct regmap *ocelot_pinctrl_create_pincfg(struct platform_device *pdev)
 {
@@ -1985,3 +1986,6 @@ static struct platform_driver ocelot_pinctrl_driver = {
 	.probe = ocelot_pinctrl_probe,
 };
 builtin_platform_driver(ocelot_pinctrl_driver);
+
+MODULE_DESCRIPTION("Ocelot Chip Pinctrl Driver");
+MODULE_LICENSE("Dual MIT/GPL");
-- 
2.25.1

