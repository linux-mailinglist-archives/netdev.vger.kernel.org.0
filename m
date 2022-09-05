Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 702035AD75D
	for <lists+netdev@lfdr.de>; Mon,  5 Sep 2022 18:22:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236946AbiIEQWP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Sep 2022 12:22:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231964AbiIEQV7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Sep 2022 12:21:59 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2116.outbound.protection.outlook.com [40.107.102.116])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB9005AC7E;
        Mon,  5 Sep 2022 09:21:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HoerRC1G/kRSYbntfQimrt/Fy7DhzMRRKDY5qZA84GLhpXJo1jIgPkC2d5t7PpAhGzo4m5f4Ba4VXNSN3u2lD8PPnJvxWLfgGAp4lGWntULusH2+OI6i6Zbgj2lCQIfCQOwIZPBjTsrRT7fuOdcoSPaEwUjXN6VUtM0R2tnqF4uWzfE9gJspsc4gUY8HZVa3l1IekUemLzJ0Yd6lPc0TeeykCqY4flp5h0V9Za2YCu5l/XNTCOq6kjOLMYfkpKsYpi9Q83kZ6pbm1VkQmwaaYy6CZLxxmiXjUtca4sfmCqyuNXgnETQsaU0eDqLox6ZjjiRqYjKsKiFzMZpahX8b+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VeRckxEZO54EkM75hMOVmLtgg5AW5O+vUBQluRmm+bU=;
 b=L0NDtdWqSvavwDciXMqD1BaCStM+cMTs7gOEswM0yvP0r+L5ouGcK8J/p1hdLR7QgXurctGPsG+8WPSB4cYOKTZyXo3IsfmBgAA2NL/ZRqYFYiUASMWvpQGo6AmF6X4tZgDyu58taCh4HimJZqD1GhQi1aFVYfsoDIA3vKYPWienOLgA6IdhuXtfawZIozmY1UDgn+UrdVEyzdrUpy0SMyHNd6+/efjb6lGsksY6EeUecnqelCsYL0RfH7ITw+w2+mnvs0bwfpGnyLdvFBtfrYzvXvcGknUG0h5MZXUszJ0W5CTRcvXrwNHQ/2wceO7bTm4Bq5B6DaO+sfzEDRQ19g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VeRckxEZO54EkM75hMOVmLtgg5AW5O+vUBQluRmm+bU=;
 b=dE1tEgwk0dQLfEhLyOFSdjPlXOwQpZ0gjztQ7xrpjPEZXWHOGyoAH03aMZKBrbdDAAMMSCaltBT57WzMpIISa5VKV4awMSwEUm+3KTavZnZaqOXdyM0Sa6yit/ujn7SRHZNvd48KeMq8tWvvrCrk1NrSbvl9H0J6O+o2S7D76x4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by PH0PR10MB5848.namprd10.prod.outlook.com
 (2603:10b6:510:149::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.14; Mon, 5 Sep
 2022 16:21:54 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::38ee:4bfb:c7b8:72e1]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::38ee:4bfb:c7b8:72e1%7]) with mapi id 15.20.5588.012; Mon, 5 Sep 2022
 16:21:53 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-arm-kernel@lists.infradead.org, linux-gpio@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Cc:     Terry Bowman <terry.bowman@amd.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
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
        Rob Herring <robh+dt@kernel.org>, Lee Jones <lee@kernel.org>,
        katie.morris@in-advantage.com
Subject: [RESEND PATCH v16 mfd 5/8] pinctrl: microchip-sgpio: add ability to be used in a non-mmio configuration
Date:   Mon,  5 Sep 2022 09:21:29 -0700
Message-Id: <20220905162132.2943088-6-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220905162132.2943088-1-colin.foster@in-advantage.com>
References: <20220905162132.2943088-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0263.namprd04.prod.outlook.com
 (2603:10b6:303:88::28) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e4fccb98-e301-425b-9fee-08da8f5abecc
X-MS-TrafficTypeDiagnostic: PH0PR10MB5848:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tLwqw3QX5/ON/Hk2Hvw+buRuKpEtz8JitKr9dAJV7h3+RevJ7k/UahOOoYaAag0cQFUrvz2GRvw6vXfmka4g0U8MbMLNjdi/nPnD/IdL211zhTR2huEmaJR0i2hruzmRFxvdUOsuP25wVX2b3v4Mg12VSSATVvsczzMErKtT1lWxjgK48xHUE186RHfVlyzCLqtuGGtE/na7gpFo+LW07p2PFcTZfMr7F3NCIn0R7gF9d4GfGiyqljFrn/kdPdJ2GtXmmhZQNt7hNlAweSJM/ENrm+etLjTAiELbwM5ouVZ2YCTn7XYhXQk22/PbbEGwjDMH6cmIuHVmK0BEotrx/DbLreVXF2flWoV71yVhQr+bhB6SBYXKsTWGOkAJ5c272TUN1buo+3xAYBfG4BZ+S0CrTNhjkBGQhKw7Ty3hoTZEfJ9yh3sYrhGJPzVoFBMiswUygLZOxZiIPhq0u8JKP4DqHNhnPG8jR3atrVEZzUtaXzVPK0fB5u3AhHYXy+7Ya+tNda2MQraFm/PVTaedRbd7uU0e3qNLMCo5SeivBhl9g2Z456oXdfeCU4sLoGqAhSwDebnGXR7N115FuiNNnWIRM10vCICCo6NqRZa7Yl7eKB6l3d0MF2REcDOUq+diotdzg2JM+gRi1HMlAH8S9mO5nlAmYMgP+bGA1t7Wl8x2TfmwspzqtPGjO9PKWh9YrqrKhJQARcp07eFN04yKvZo0Gu4oToxCk55FiRi6uS7Bd5Q3tYaojk5gSbYwelEi
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(346002)(376002)(39830400003)(136003)(366004)(66946007)(5660300002)(8936002)(66556008)(54906003)(6486002)(41300700001)(6666004)(107886003)(52116002)(186003)(2906002)(1076003)(7416002)(2616005)(44832011)(6512007)(36756003)(6506007)(316002)(83380400001)(26005)(38350700002)(38100700002)(4326008)(86362001)(66476007)(8676002)(478600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?i0kiCfMX6e3R/myWK/D6+nxYjtbifKiXWq5Pv6oBPZRuqUC00iIJInolA1aV?=
 =?us-ascii?Q?VR/quxfqTme/sRhLLR44LgRtG046Rbb5iNhs5wrIh82nNvZwq+MvHlLoIrgc?=
 =?us-ascii?Q?9GZ8KoNjXYz/piaqUiZJsfm0wVk/XS41S7AH7hOAisVNOMH94R1DpklUeYNR?=
 =?us-ascii?Q?LUYt9ntF7J4poZnHp9gMJS9apZcxOWa6m3jrJZM+UnFcFdZIy3WPJfftPZoi?=
 =?us-ascii?Q?d8UwfPAPAT4IljMFeYLrYD/xl00By/59xNK9+A0WVBjqdBBWyAwQYcBzaV12?=
 =?us-ascii?Q?tSWvjP9Xzu7Adq4YPmF4AIglbJ/bSZdDJ+ZNsWEvP4HQfbTFKTV9nwMK4bzQ?=
 =?us-ascii?Q?h2LdcXByZGkMEu8ppss/plpO+QhqzbjOYCHrve/U3EaXtAc3voJrRmMLkzjJ?=
 =?us-ascii?Q?DCKkWKW6my7vUb7CeofITK6UJo6x9ND60FlqULqe0YRapk54Bs6jt+LvEkn6?=
 =?us-ascii?Q?3nEHUuGj9dqbDRFC/4NaXmNDGzhBiyBX85ypBCk68ZRVXgo2xjWzfgwq/ogq?=
 =?us-ascii?Q?K+ZJbi95ctmKqOmDsx50cY/WVGYIqhnzpqpCc2wnuQoq+JYXWhE+GNUGec3H?=
 =?us-ascii?Q?f4jwL7vX7WimtUVPWWEU4cfdCQFQaiBURTfTWfO3s9Ban9tiTcl09kV79Evl?=
 =?us-ascii?Q?gK+SAbGR0KJmoRte7vf6GNeiHpw8ko99QuwZXag/k+MTbu3G2R/sorft+n/j?=
 =?us-ascii?Q?+3iymxQX6OhKqQXtcRKd8akjIngu4Yx4vw3VUKIvMnsBDgLeC1E0Zl2LVRFW?=
 =?us-ascii?Q?DAQRPsiJ/hSzEPtDEGlO7Rqw6Uae8Ix6+HjkBDXwo0D0G05c1oy8vsghOUS8?=
 =?us-ascii?Q?Fmk40dSs8u74QDhQPktu3Cx0WlY7490VoImRNFuaLf2otdhFd5J/uAOiWM53?=
 =?us-ascii?Q?1NODl5WPqgfjgVuZzhGvhWfh7+dAogLXcJJ1Cprae+UZVwtSttml15v9OSgm?=
 =?us-ascii?Q?/LWFl2KoSkL9Jb87Ow8ehEujR73WigeJ/NufUHTTOz8a/xdW89yMdOE+ZScP?=
 =?us-ascii?Q?L2OR8LmY8JQ0NGjtEPZNkWPcUF51z9YyzW+A01p4pHi4K3TO33zPp3lu6YNd?=
 =?us-ascii?Q?/vB/hYRsfP6o2T3PxxXV8VQw/jJ09g7F4YYkeS0jq5spCIwzcX69zX4ohEkt?=
 =?us-ascii?Q?xk/AQJB+K7TcpuzcwW9JvRl3JwxH1iv4j0G2+Nqq6RCoTmx0m0Z0mzvgLury?=
 =?us-ascii?Q?AhxryxUTc+PwAzd2BAILigIBMGTc50PaVXkq7uosmviIJ2J0b2XRrdDvfFIc?=
 =?us-ascii?Q?leOrDiduYINVReS/WLXmkF7I7eSSazKlzlwbhBdVptm+Lq7BZczHg5KJ4PjI?=
 =?us-ascii?Q?6Zszpp4zokWQWlKCaJrOfIRq0vRo+05GpRRSsoiXXnFCN29g0F2xrVsxZdp0?=
 =?us-ascii?Q?AS/aeOftx6cImGBNyRAC4gtT5fxvDSLYZIkuQF2ue+YWw1VaqQwTiHUP+IbI?=
 =?us-ascii?Q?rSjHdWTO5uvAhuG9prgOk7T5LyKz/cihSbs8SjPyvZ+jLelXZM6NkK1pQGDe?=
 =?us-ascii?Q?mdHTKqF0JGJbtah+daQOhiikzrnxKBqpBjGVW8/B1AcctUYRPd11dTHNFlLt?=
 =?us-ascii?Q?q0CJ27GF5/lo59uX31gcgswxZLnMIPR+GZQdoKbdHwz+OI8dr45rMO9vtkBF?=
 =?us-ascii?Q?bw=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e4fccb98-e301-425b-9fee-08da8f5abecc
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2022 16:21:53.8662
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: o/vxkNHRafvmxTcrhql6SMRlWMTbVuNXDd28pbzsLkXJrQLZLHPpUv4BVIpJpeZcRtstuCS5ewkrKbukKVjkav4IoCWrMrAEXaUMxN61Rv8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5848
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
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
---

v16
    * Add Andy Reviewed-by tag

v15
    * No changes

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

