Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9322592738
	for <lists+netdev@lfdr.de>; Mon, 15 Aug 2022 03:00:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232319AbiHOA5E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Aug 2022 20:57:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231642AbiHOA4m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Aug 2022 20:56:42 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2126.outbound.protection.outlook.com [40.107.100.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C07BADEC3;
        Sun, 14 Aug 2022 17:56:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U1bAF4ZrVbFH8gSK2r4A+ZV7jkypW/J84BqLCyvwYEn8RI+flFA5jSak1mDofPsgVtTVOPuMD6w70J/NgreQYTlgQjVfRYqnn8z5gFDtj2XuU71eVnd3TCUW+y0Jwgs1vY/KhxMcvQU6I1gAJvROXHjPjO8IulgCfr/d/qHNgV19tLrSOl3MNtppYGa64+JYT7yYH5gev92A10wQkvC7XclRzfAPvcq+IsLML4Tnu6uT+70C0ssVgmxxSnIj7jMyXpqYDGdl4sz1Yq1bqGs8Hlx8P0tpWm2+gPGdIXowl3BiwmDyhUbExfPfRx8gsiYhkdSNFPuaU6n5ILZWYYr6nQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VeRckxEZO54EkM75hMOVmLtgg5AW5O+vUBQluRmm+bU=;
 b=QZpmvG7Gu5P7AfIGItaaLE0zXMNquvIO7DqNAZ0WP9o4pVRuilKpdhlrr9Uo7g7dy6Erw64ritCPrmDNMlUvX7yIKxCqGiyKEYFm0JIr/C1wj3s2aJd6bEszbystu6fsFtT3sELzwsSWyC20pWI/aoxFf4VfF8Mjh1W8M/IwPyQoMJVGKT61uIjfImbjTEAC/jhLCcaj8Q6+wIfZ/NWwt0w6EdjEcwo9ksPfydkw4cN7/XnRW9UV/fN9mePmW0jvZ1TQ3i+8jebe8XK7DiE3ZSI1e3jyYOz/Gy6qOdVoKPti2CTYhbvFw7S7o4K18B8kobM6w/p3HkI7j8QhX5bKww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VeRckxEZO54EkM75hMOVmLtgg5AW5O+vUBQluRmm+bU=;
 b=aqpyGBmWPt8QXJxXZ4OMK40tFnF+GDC9DtcDzkl5PIMIocoM/a+dldB3yQ7ylauzotIfGH8WvMfA5ZeZVsGMDEtC14ZVsZyHocpCZw+SR79TWEtL1K+Af7/RDcHo7D84DH3gOnK099FkzzReqWC1OiEqZkGwL3tx0p6mWKYeg3A=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by CH2PR10MB3862.namprd10.prod.outlook.com
 (2603:10b6:610:8::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.11; Mon, 15 Aug
 2022 00:56:13 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::b869:6c52:7a8d:ddee]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::b869:6c52:7a8d:ddee%4]) with mapi id 15.20.5504.027; Mon, 15 Aug 2022
 00:56:13 +0000
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
        Lee Jones <lee.jones@linaro.org>,
        katie.morris@in-advantage.com,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH v16 mfd 5/8] pinctrl: microchip-sgpio: add ability to be used in a non-mmio configuration
Date:   Sun, 14 Aug 2022 17:55:50 -0700
Message-Id: <20220815005553.1450359-6-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220815005553.1450359-1-colin.foster@in-advantage.com>
References: <20220815005553.1450359-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR08CA0034.namprd08.prod.outlook.com
 (2603:10b6:a03:100::47) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3a4f1b3a-1b0d-4d7c-71c7-08da7e58f36d
X-MS-TrafficTypeDiagnostic: CH2PR10MB3862:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: S74AKBcejZBvK1InBKTCo3H1rB8tSoZne17ZbxabYV2mZoD1iO1Kzqn0OKUioOH5ruq4j6hgtrdL6XS+9uNVzGRRxmWE5bFAsrDlSp4lO1dFgKz1iWmkkCBS7nt3Vfe0t54jE9h26rg18MwhlhfDD1M3SwDG5n/ykpt5ECACb27P68Teip8hE04LAZBhjfJzahegYuM091yxuFaTw20OyxnjkOdLE6m5chg4WGpG2jiHsziUvgAqOEc8pHoaSe/xRAEN6o+vD1x6Zi8rtt2b3+EPl3Cb6o8Lm6gqqK0yydyIrlnROuYnfCX13vGCoUS4W8rPFKqpUhAp8lWbBGLDRT+2fJEsbYxjyU58T0FCJ4rYY6HCSC9M/w5fjotyByLMoLMkQbNo8QobD0SmSSiJ5eTwbGS866UxfW5IDk9CN7StigfL5RnhRet4qYobArSrDEod7ZXJiw73tB5sVmDwBI5Bd3FbzdoDyiVX/UUQjrDDd/qEiSi6oiPLuf/JdMOn9IVdN+cyhwJ1zPi6tHxcZ57f2p2fxiE5yJVGXs1GZOe2cXY/NhiBeN/fFH0H0E4fAm1E6OMpBOegZNzYDrpqmkNVUuOcUzO/TR+qYxUkB35aXDZmOxDk0CeTiMhH+XCWgzcqMG/g5vQOCBp2VLuom2C94D9Gg60nQAWpqnzlmlbYJ2pxBKWULL1Ck2NxROiRiuxbIbiMffP8PBmAYz/3A6XY3xtZT3X9koL/cK5JaV7BzBIb+pLsiuY1edhaIbaEfAFu3Az3Guo+MC86R4tKTcpehg7BZdRmWmnNnu+Yijc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(39830400003)(396003)(136003)(346002)(376002)(1076003)(54906003)(41300700001)(52116002)(2616005)(6666004)(86362001)(186003)(6506007)(26005)(36756003)(6512007)(316002)(83380400001)(4326008)(66946007)(66556008)(66476007)(2906002)(478600001)(6486002)(5660300002)(44832011)(8676002)(7416002)(8936002)(38100700002)(38350700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?DYQ7MBHF/+j8HqvCUfy+W+5sX0tHy5IwolNY8p6YwVL0y+aq6VkES0BDAZ3U?=
 =?us-ascii?Q?UaILYMIV9K8LJsoLQPGzUzLkPlFW9OJ4R1qxAF7wM5wwfBWMVJ/cgnwQ2IRq?=
 =?us-ascii?Q?8k/G/0KL5gXfllq2hmV+7P3uOYj67www8eoe2nnA4EqCj7y+4SA7GA3OMCF6?=
 =?us-ascii?Q?oqCckLpMGsLGgDnahv45stUshaXrMnD9bRVgKetmojd8GBM3GNO5b/1In2SA?=
 =?us-ascii?Q?CiO85LC5SjVL/ROPiB5oeEIEPwx2B1qiSNW/37G5iXltDTp8KHxbxKoNxx5p?=
 =?us-ascii?Q?VsJKmRQhyssMWRdpXB43xgc1DVZfGkq2GkGNTtF8sJqocUsyLmEYzZPY7OB9?=
 =?us-ascii?Q?P38jgrF+CcQOmBoJtGHd4vC1823B5nUqW9fKf7K+5ZEkEmVNUyJ08JYEllt4?=
 =?us-ascii?Q?5BUNc6x3xfrpu2FvRmWo5qkIyxvVLaosD3bZfNekMWn8YkS8rCHr7Jo9QL6R?=
 =?us-ascii?Q?Yny8KZsc3H8p4lJ6UIe9SP6AV58OhEvzhFY5BSOLJdg2SY4bbbPpLKh6kvIg?=
 =?us-ascii?Q?FiQQ2yOF7kqrRRqv0MuoD6GAsusaZR9Mlw3WIxv+4nVRsuVg7t0xv0NY2pSk?=
 =?us-ascii?Q?fUNFcpDLG6hiYX1DsOM9zYQk/+Xo+XDWIjylURyP3Jx7DmUvi2maJ3D32XbG?=
 =?us-ascii?Q?QF8iNNghAuhLiUMWFffPpX5hcPa2rRO6Od9Bjuv8TBIFxki/xNrXALyQoqYV?=
 =?us-ascii?Q?iboX5GfkV50jcyttH5qp5L9hOWhS5NJsAdwY3EjN5im6MjKl7EKfgvqzNWhN?=
 =?us-ascii?Q?hEekwsmHcfIB9z2jYWsC5R8GNmMFfbR65unsCVYmMx8qfKkVY54KPy0fP6de?=
 =?us-ascii?Q?VONP/s5VH9nNvavbSkLmTPTw+NvELcclcJn+6yJM6AVBMx6nbSxWYCAY+zVB?=
 =?us-ascii?Q?ZjH02tVo0Yx+auTKeUU1phALW0blW4xp8iEIFzrv2VsRLmz2/L4C5mcImMwX?=
 =?us-ascii?Q?5OsQuizMY85X08MSUqyV6rvx/q1c/7vus22cYktvytRIRj2PiTR1L1f8Qik2?=
 =?us-ascii?Q?SgAXFLkj2XpAqE871SMpdFsEyofjkXzlCE78X/MXK2DvVZiiLstXpNCI5CH5?=
 =?us-ascii?Q?9oVtwvQcwHbetySv+w2eXCMG859WCA3CkjqJt5Dx7kQoTivSRr1MbFoLpi5j?=
 =?us-ascii?Q?m5h9FGcxHne2JU5kmPEnjEYkaU9XP8vVy3c2j1UEavHc+xdOFxbg084ez96z?=
 =?us-ascii?Q?jC2z81+7oPIOSo3iKL4W/mot1NJ6wahBqbU6SF5luv2Cidz3HI1/6gwwdrXc?=
 =?us-ascii?Q?SRU2RDj9F7dF4cfZCHVZvJSpUoWag3jWbugf9CHEKuIhqmbktsVwdgei1yVm?=
 =?us-ascii?Q?460EY67ZthVjOangx6dKSHJhlEN/noPthn7b/foU9jzpuHKhOy/ebb3GGOs0?=
 =?us-ascii?Q?sxfwd77QEGthyCwmYV6x82F8awxwxLUWLG1Bh+RZhL+nxXK4VoxbZHFByPd/?=
 =?us-ascii?Q?3ShCKMl5G2EhgaL6u/tL2uCgGUXyfK+aX7pgAA6YUKjOgWOCf6oTZ1wXgfPr?=
 =?us-ascii?Q?0azJK1PCfaw0z4YCJVv/TTb7WNH6ngqLa4um5tC4oXgLIw+YWuaO6ENYOd6x?=
 =?us-ascii?Q?QIfGzZuHMJLcMQpYQhsIDeWqRJ367Y8ftxGFEgm876OdySThnKJH/OTvGDOR?=
 =?us-ascii?Q?RA=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a4f1b3a-1b0d-4d7c-71c7-08da7e58f36d
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Aug 2022 00:56:13.4947
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ikigP4setFmEi9fqscGQNGUc5LXk8+XRPX5NibrDMtWOUaFw8InAymNZx/uE10BFDcytlixDw6eZo05NFE29/16cjnOmwjqli/cn/AYUVLo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB3862
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

