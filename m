Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DAB8618A3C
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 22:07:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231479AbiKCVHW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 17:07:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231415AbiKCVHP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 17:07:15 -0400
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-eopbgr140053.outbound.protection.outlook.com [40.107.14.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CDEF2181E;
        Thu,  3 Nov 2022 14:07:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JC1phC1gk2OPaxophj0WrYvZvwajf/X2JNHYDxHsBX9aBg6zVA5aoVKUCmWVEPjMjvolCiKRdClyHOtb0wcczewOTvfWjVap1NGke3qe7UibCKXDrnCqfF2T8ngED6oC9fUbus4yrQ3j1Qs2biNkmM1ms3d2cBZecCxni8i8xua2eLmAVOkQC2/GdJsoqjeevbM4sitRCORXEPBrhCM84ebeNE0v7CboSwh/F3JLOomOK0suHyPXAvEpGGi65BsonuKoW+1RyLObNDbdizyTtT+XxtktERGeRwoDK63G7dD7ia/t3SYJ89H4MCQ4aXOHXxrJzgZ8ep/Pgml4I4bcug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ub2D9zTatvWGG6IQyUZpnrTP1/6aaU5Yt4WSqDNSDf8=;
 b=KyTicMLGpU6kaF8nbGBpR5O3rmbI5MWOym7Yw43ZqXdsWRMcqoA/nB0whXI59yWh1ldBz+tvV82T6u5q+9ej1nqSFmT4Zr3tIAc8nxQu4jNnetS5BQyjSGOgBm+mMGve0yu6oWpjTiy1lNm/qpmxaH6gXfXbj8Hv7GRaabbTNTqwOgpRxqo+xpQ9YinAOw3HIoZiqYgG7jvLMYOvW0LVEcLtMbZhJiHUViiQVU9/F4xv3NT0FToymzVCErRdcnMcojwHCIGl6/TSqpcMmAQ7vrue8n1/MVTu93cOuPVNY5axvJoGILwl6xU1JcpEStvMG9PjdfLtZZkor1std1ibiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ub2D9zTatvWGG6IQyUZpnrTP1/6aaU5Yt4WSqDNSDf8=;
 b=yeKJCzJAhDQmBMqq1wzbebaPuUBNH1UljShhX7ZjagsVpmas7P8EPO/6+7GbawQ3fJwRvnP7PyVg69uF/VS831y8wtPxc/GSCwLPpF3iGV5gXpZvmeOT7Vr46VFzAgLgtxdekHsyJLCClM7YbaBrlDw6ubKcSPNaOk71Z4SrcmUWRx9sAkHsG4phK74AL2SrfBzaHJ5ob0sWfjvMNZgGjlyplvI+BmMecsIOzSXtlATU0H82E7vBs2AsRb1jyzWL3PTus0zaIddd8AIWKsaTrrcHMW8WTOPv9YfU6HdB7MWfw3CTyZw5udieSJjcHkEsFk1eoK22s1BlOnUDPy+ZVg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by PAXPR03MB7746.eurprd03.prod.outlook.com (2603:10a6:102:208::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.15; Thu, 3 Nov
 2022 21:07:11 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::e9d6:22e1:489a:c23d]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::e9d6:22e1:489a:c23d%4]) with mapi id 15.20.5791.022; Thu, 3 Nov 2022
 21:07:11 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sean Anderson <sean.anderson@seco.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        UNGLinuxDriver@microchip.com,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next v2 05/11] net: pcs: lynx: Convert to an MDIO driver
Date:   Thu,  3 Nov 2022 17:06:44 -0400
Message-Id: <20221103210650.2325784-6-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20221103210650.2325784-1-sean.anderson@seco.com>
References: <20221103210650.2325784-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BLAP220CA0002.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:208:32c::7) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB7PR03MB4972:EE_|PAXPR03MB7746:EE_
X-MS-Office365-Filtering-Correlation-Id: 9b9a037a-44b4-4e78-7565-08dabddf6046
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9CcM09626v1THI9Vr2pJvdQ7PHKECFkLNr0yQMCGHuE8l22Okjk+l9gVFDGcDk3kBC8/gi7QH8cHq9Cuukz2Fy5B3NhA4ceSGOWux0fQYCmkKNXGPs+g24CI7FGFI2VBn0YqRtkwnIox5xg80R/B6dJquqAlUcD2A3djpYZo8uWFGEo+0R3lm2Vj/2OhKqsz8U4BiKorkJ7L0tYizGu+ki3U+RfUPb8YkJ/u4FrXsJOgLqsYCu8KN/kshJEhgWO3EpKOw63d+OR/Y/MIyVg7ON50UDVbUFWjhjNAaDBLmDc3tAtTQgcFdyKDfavQZx81SWqbohK0K9xSyayvEtFZFDT4rNTt3e0NkN8hihq6rvYBZheXwkdBbtWjwnEHDRHdLLD/y5D9x4grz2JK3IzqdKANhT/ald7VYFzc8jOHAFybWMD2BcEAucEDls3qlgguqIHWehoqCbWSxxerWsYbfTQJ6WulyHLBxTSOdNf70M9n+83SWGuvF5C7M5A/hGgGI58QwcsjUJOcpn4DGgLBUm2pbBkldWpy8CCu89pVRqyVC7Vg1WaXQTEFcS+UsgHxPkbyLcBm7zcJ3VRkuSslFdmwhejNafjN6v+LeR/cfUhtnLTbiUFayNsE4fM9FNvijNolE3gd1M+majEprSc98AHwgcN052C+8vOUGeUlA4k2RGxFkPfSz5uLj/KtTqoDB2l6mZhD3PE3cDDQGn83DJWBAjDkwDR8+yE5vtqBZMUDKFgOPzFEnGCvKI7/cufOqHdwhoxeutmNP4mXZomnIQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(366004)(39850400004)(376002)(346002)(396003)(451199015)(8936002)(86362001)(36756003)(478600001)(6486002)(44832011)(5660300002)(2906002)(52116002)(26005)(6512007)(6506007)(1076003)(38350700002)(38100700002)(186003)(83380400001)(2616005)(7416002)(41300700001)(6666004)(66946007)(66556008)(4326008)(66476007)(8676002)(316002)(54906003)(110136005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?BiczTNFvWP8n6rZjP9u1uyIW35UHo421V2Qu+Bw83A7Hw6kuxskadim1GmWg?=
 =?us-ascii?Q?cFyt/LwqRjw4+0AJLZLhxxNGqN9lpVxFywznqL1vTeK1L8HfvgO6j8LYFfiV?=
 =?us-ascii?Q?+6jRu8pyZB8Mlu5HS006I+kRRE14H6XUbsT5/dTKKeW43jfnl8+g27dxafVM?=
 =?us-ascii?Q?bdPQuCF66RfkEHAshqvdA0vCgFK68a7rg/Tc8MutE7ZsKSkQPlvrR7CBLDr2?=
 =?us-ascii?Q?CLwU8qw3HKj7RU76xoAuPFM86x1DgL4voVIHLTcqhybTRrvz2b3AxQzuoQxQ?=
 =?us-ascii?Q?43Q6SP+znYkOosofneqGCCrLs6UDhdDg1X/8h8S9BajN3omFlqqmZ3SIGghF?=
 =?us-ascii?Q?avMnG2x98FtykSSwlTh0vgifSGy8iBSUbveOff1bmHTzMiTtA7qQ047Rsxoy?=
 =?us-ascii?Q?xhTbz51vIOyyL6tgL/5L2nahmmgP/T8aCfavQKxay2A4h+Y8JaCByZcUWz+l?=
 =?us-ascii?Q?72zSCwx+TQJOg5ovo2SKs0NKLAQYZrmNCx7O0R0C+TGByOEYrxy4ywnrdqvQ?=
 =?us-ascii?Q?7WAeg3FIvnzy+5hy8WP8xsZ3uu+Ug6UOj8uS20IQdY8+9CDUQswdsO0nUIGO?=
 =?us-ascii?Q?BwViagRfPeGyT1P95pJ9PNmsjiuaTawOm86Z6dzcYsXhkfYzCMGCF0wyE2EG?=
 =?us-ascii?Q?sQrelJ9zsgConjuhTw7ax1LIl2iX3bWxH6FWCsyiPcbaAtsoVcXSgw5WvCLr?=
 =?us-ascii?Q?r7RUV10PvJ2GP9fimSQliOKb/RUqS52ztuapaSEHEdsfx4e+UYtyqeU5UvMj?=
 =?us-ascii?Q?hncryUdO5RJuj7Bf2wI4V53ds0L+nW+wSgiYP2l/PoRtffLB5DE/FTA0UMwY?=
 =?us-ascii?Q?7y0f0ZAxxRepKIT1PqSpyO9J4pxiV9RW6IBJcfVbDYcPshrVVAGormPWaq1D?=
 =?us-ascii?Q?+b8fhcOaiMELLUJ92vOvLq/ajX6S5Bc645220GCl9Q8dnVvJdf8Q/2+Kv2Z6?=
 =?us-ascii?Q?7hD/liawk84XQM/3jBmOtruO77D+eV9wGRPQlkxM2K86vaOCCxNYKbMkPL73?=
 =?us-ascii?Q?pGukFWDnOVQrKauRfhV3c8nf+3rHZbiDBbY2ucG0sz9yCqwtFG52g4kTb6K6?=
 =?us-ascii?Q?GTxeFuhgp68PGL72XdrLTsk+kxAvdISoJOlbhFAi+lu+HwuaD78GNFqhi5fx?=
 =?us-ascii?Q?bj0oFuQ/YS4V3tK6IOe56c3wk7i7VdP9TUIRfPqZNXapIwOasQuLWxWVcPbC?=
 =?us-ascii?Q?ghexTK2jXzb8yVF75lqxPvQQDvhursyRbupO8jmQWfAFsPO+EUokTHY7Qaa+?=
 =?us-ascii?Q?KG+1dNWCwHXKY5qWa6izU6914uJxj2yfH1FiwlsvU5uDTZYGyfLdQG6BPnLG?=
 =?us-ascii?Q?BbYWnc1qRjAw4L4Ck0ihPN3V1cMFksy4GWnOAn/uVdqg3srPnDE+obJBbpTT?=
 =?us-ascii?Q?XjPnijRR8CA5YbpuXBsO1T++FDJlK6fHNudxQnUAIRx5bAmD59zbIYaQ8Iva?=
 =?us-ascii?Q?gnwA/dqBfK4+UkobPXXO4bfCwjgW+BhL18QPx5TdF9+C6mM+jKk6D0BYXdtz?=
 =?us-ascii?Q?4JnjzyapbMDf/Oi92PmpxqKdzKI0pJ75hkWCb2CRJKl2QUEnoTScJ8RWeMnF?=
 =?us-ascii?Q?j5CgaToBA9UGqowwbRuTr/yJwbk+TOFQ/4QW0QWAV8USzn24nZZdZGSjz5n/?=
 =?us-ascii?Q?NA=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b9a037a-44b4-4e78-7565-08dabddf6046
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2022 21:07:11.8339
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: d/OKgIhvOioNcOFqeabM+Vv7r/GFu1oRdBzhjyAyJ0cJYF3N95HUYuAcxZkQ/EO0K/xvlDu/rgvD14LMS5OVxw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR03MB7746
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This partially converts the lynx PCS driver to a proper MDIO driver.
This allows using a more conventional driver lifecycle (e.g. with a
probe and remove). For compatibility with existing drivers, we retain
the old lynx_pcs_create/destroy functions. This may result in two
"drivers" attached to the same device (one real driver, and one attached
with lynx_pcs_create). However, this should not cause problems because
consumers will only use one or the other.

To assist in conversion of existing drivers to the PCS API, we provide a
lynx_pcs_create_on_bus function which will create an MDIO device on a
bus, bind our driver, and get the PCS. This should make it easy to
convert drivers which do not use devicetree.

Because this driver may be a direct child of its consumers (especially
when created with lynx_pcs_create_on_bus), we set suppress_bind_attrs.
This prevents userspace from causing a segfault by removing the PCS
before the consumer.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---

Changes in v2:
- Call mdio_device_register
- Squash in lynx parts of "use pcs_get_by_provider to get PCS"
- Rewrite probe/remove functions to use create/destroy. This lets us
  convert existing drivers one at a time, instead of needing a flag day.

 drivers/net/pcs/Kconfig    | 11 +++--
 drivers/net/pcs/pcs-lynx.c | 83 +++++++++++++++++++++++++++++++++++---
 include/linux/pcs-lynx.h   |  7 +++-
 3 files changed, 91 insertions(+), 10 deletions(-)

diff --git a/drivers/net/pcs/Kconfig b/drivers/net/pcs/Kconfig
index 8d70fc52a803..5e169e87db74 100644
--- a/drivers/net/pcs/Kconfig
+++ b/drivers/net/pcs/Kconfig
@@ -25,10 +25,15 @@ config PCS_XPCS
 	  controllers.
 
 config PCS_LYNX
-	tristate
+	tristate "NXP Lynx PCS driver"
+	depends on PCS && MDIO_DEVICE
 	help
-	  This module provides helpers to phylink for managing the Lynx PCS
-	  which is part of the Layerscape and QorIQ Ethernet SERDES.
+	  This module provides driver support for the PCSs in Lynx 10g and 28g
+	  SerDes devices. These devices are present in NXP QorIQ SoCs,
+	  including the Layerscape series.
+
+	  If you want to use Ethernet on a QorIQ SoC, say "Y". If compiled as a
+	  module, it will be called "pcs-lynx".
 
 config PCS_RZN1_MIIC
 	tristate "Renesas RZ/N1 MII converter"
diff --git a/drivers/net/pcs/pcs-lynx.c b/drivers/net/pcs/pcs-lynx.c
index 7d5fc7f54b2f..3ea402049ef1 100644
--- a/drivers/net/pcs/pcs-lynx.c
+++ b/drivers/net/pcs/pcs-lynx.c
@@ -1,11 +1,14 @@
-// SPDX-License-Identifier: (GPL-2.0+ OR BSD-3-Clause)
-/* Copyright 2020 NXP
+// SPDX-License-Identifier: GPL-2.0+
+/* Copyright (C) 2022 Sean Anderson <seanga2@gmail.com>
+ * Copyright 2020 NXP
  * Lynx PCS MDIO helpers
  */
 
 #include <linux/mdio.h>
-#include <linux/phylink.h>
+#include <linux/of.h>
+#include <linux/pcs.h>
 #include <linux/pcs-lynx.h>
+#include <linux/phylink.h>
 
 #define SGMII_CLOCK_PERIOD_NS		8 /* PCS is clocked at 125 MHz */
 #define LINK_TIMER_VAL(ns)		((u32)((ns) / SGMII_CLOCK_PERIOD_NS))
@@ -333,7 +336,26 @@ struct phylink_pcs *lynx_pcs_create(struct mdio_device *mdio)
 
 	return lynx_to_phylink_pcs(lynx);
 }
-EXPORT_SYMBOL(lynx_pcs_create);
+EXPORT_SYMBOL_GPL(lynx_pcs_create);
+
+static int lynx_pcs_probe(struct mdio_device *mdio)
+{
+	struct device *dev = &mdio->dev;
+	struct phylink_pcs *pcs;
+	int ret;
+
+	pcs = lynx_pcs_create(mdio);
+	if (!pcs)
+		return -ENOMEM;
+
+	dev_set_drvdata(dev, pcs);
+	pcs->dev = dev;
+	ret = pcs_register(pcs);
+	if (ret)
+		return dev_err_probe(dev, ret, "could not register PCS\n");
+	dev_info(dev, "probed\n");
+	return 0;
+}
 
 void lynx_pcs_destroy(struct phylink_pcs *pcs)
 {
@@ -343,4 +365,55 @@ void lynx_pcs_destroy(struct phylink_pcs *pcs)
 }
 EXPORT_SYMBOL(lynx_pcs_destroy);
 
-MODULE_LICENSE("Dual BSD/GPL");
+static void lynx_pcs_remove(struct mdio_device *mdio)
+{
+	struct phylink_pcs *pcs = dev_get_drvdata(&mdio->dev);
+
+	pcs_unregister(pcs);
+	lynx_pcs_destroy(pcs);
+}
+
+static const struct of_device_id lynx_pcs_of_match[] = {
+	{ .compatible = "fsl,lynx-pcs" },
+	{ },
+};
+MODULE_DEVICE_TABLE(of, lynx_pcs_of_match);
+
+static struct mdio_driver lynx_pcs_driver = {
+	.probe = lynx_pcs_probe,
+	.remove = lynx_pcs_remove,
+	.mdiodrv.driver = {
+		.name = "lynx-pcs",
+		.of_match_table = of_match_ptr(lynx_pcs_of_match),
+		.suppress_bind_attrs = true,
+	},
+};
+mdio_module_driver(lynx_pcs_driver);
+
+struct phylink_pcs *lynx_pcs_create_on_bus(struct device *dev,
+					   struct mii_bus *bus, int addr)
+{
+	struct mdio_device *mdio;
+	struct phylink_pcs *pcs;
+	int err;
+
+	mdio = mdio_device_create(bus, addr);
+	if (IS_ERR(mdio))
+		return ERR_CAST(mdio);
+
+	mdio->bus_match = mdio_device_bus_match;
+	strncpy(mdio->modalias, "lynx-pcs", sizeof(mdio->modalias));
+	err = mdio_device_register(mdio);
+	if (err) {
+		mdio_device_free(mdio);
+		return ERR_PTR(err);
+	}
+
+	pcs = pcs_get_by_dev(dev, &mdio->dev);
+	mdio_device_free(mdio);
+	return pcs;
+}
+EXPORT_SYMBOL(lynx_pcs_create_on_bus);
+
+MODULE_DESCRIPTION("NXP Lynx 10G/28G PCS driver");
+MODULE_LICENSE("GPL");
diff --git a/include/linux/pcs-lynx.h b/include/linux/pcs-lynx.h
index 5712cc2ce775..ef073b28fae9 100644
--- a/include/linux/pcs-lynx.h
+++ b/include/linux/pcs-lynx.h
@@ -6,12 +6,15 @@
 #ifndef __LINUX_PCS_LYNX_H
 #define __LINUX_PCS_LYNX_H
 
-#include <linux/mdio.h>
-#include <linux/phylink.h>
+struct device;
+struct mii_bus;
+struct phylink_pcs;
 
 struct mdio_device *lynx_get_mdio_device(struct phylink_pcs *pcs);
 
 struct phylink_pcs *lynx_pcs_create(struct mdio_device *mdio);
+struct phylink_pcs *lynx_pcs_create_on_bus(struct device *dev,
+					   struct mii_bus *bus, int addr);
 
 void lynx_pcs_destroy(struct phylink_pcs *pcs);
 
-- 
2.35.1.1320.gc452695387.dirty

