Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5063859F928
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 14:14:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236300AbiHXMOS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 08:14:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235966AbiHXMOR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 08:14:17 -0400
Received: from APC01-TYZ-obe.outbound.protection.outlook.com (mail-tyzapc01on2043.outbound.protection.outlook.com [40.107.117.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FBA16F27C;
        Wed, 24 Aug 2022 05:14:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=In/EuXvXDcFHopwTARDLlFIwlyOutkkRzTAZFaWlfxxim7tMXnPXkfGAA10mmWz52DSSL3ZnGtIBh09+hmippJTuEo5gwSxwIYM0qT0UYAC/vqjW7qCfvMX1im6VTwXztzO75aADezULv2CngFd7F7g9RYCRomHm0v2QddVRzrRrrdjQYwcHY+cGS353DBQbiCYDzTP4AsGW/TxrqytlcM80U6rPlqNS2kl7uYunjlcX64xKKtYF03nfpBrZbAyZMkxM7ZX++kJFdqKa4jFdYre8ihGbALvuj2zzB8VAcZskCb2uu+zsXzzGTrpsotrG4g/ZR+hOYPokn8VscXNLKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aju0awfXcTeBuz+MdfCAZn9eKbGSehM4b2ZVl5JflrE=;
 b=Dr6aKuqg/66I0xUrVx0DUmLknW9TUbhJVtpZoLS8d4FyLaBBCYVffcP+/TdhVT82+MwzVr5mAILg3lCCTwchyQdtGbgyX5LtppykPNxZZOsuBgY+zhpt6wWAIZTdhNMpzHI5b5RZtDO6wuMz91oatg+K7glV56IwbcPrVD77Cg+pU72XtY9YIAVozHUB76UhkdEiNgLXkceCbI2+MHHVsh/D4zAC25aPzylQGVmkI17aul8W6hl8L/82Ga11QdNcE64tkWWNCOZ/dbI259MJy7siiron8V5itzOtIy+R9BWUz1IZ5/jrZYEDciPxwI/HqmNa1l0mWSa4K4qg2+yPYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=jaguarmicro.com; dmarc=pass action=none
 header.from=jaguarmicro.com; dkim=pass header.d=jaguarmicro.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=jaguarmicro.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aju0awfXcTeBuz+MdfCAZn9eKbGSehM4b2ZVl5JflrE=;
 b=i3urzpVZIGUi5FkufQ0Em7nGz5IPv9oYcmVlYRNnwlIj54/NhVkJWCIK4xc3tVZA7UpJ1dmq4ITPzPF19FdCv6OgSzXYx9HYmnVSimGgKg3Zewe9ddVN5nx9Hv2GVoBa59bt9WCHTN9+4DD40EDSOJ/fl8BR13RB++awqiawUWBXYs4dNIZSJEm+MNcvTvXRNFP5pRXPFhqnvq6E72MBB64f983rprJ0i3R9VAAxV6WFvRGpNFmGiDyV3+2NnyeqSHfXGcLg+VbA0sSJpqbUUBQ3s0XrvIWkvPfQeec7j01yI0nVZMjKLdglFd4ytKwgaNu9mfI61G+nvJKDiFyeZw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=jaguarmicro.com;
Received: from PS2PR06MB3432.apcprd06.prod.outlook.com (2603:1096:300:62::16)
 by PUZPR06MB5620.apcprd06.prod.outlook.com (2603:1096:301:e8::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.19; Wed, 24 Aug
 2022 12:14:11 +0000
Received: from PS2PR06MB3432.apcprd06.prod.outlook.com
 ([fe80::af:24bd:d4a:da52]) by PS2PR06MB3432.apcprd06.prod.outlook.com
 ([fe80::af:24bd:d4a:da52%7]) with mapi id 15.20.5566.015; Wed, 24 Aug 2022
 12:14:11 +0000
From:   "xiaowu.ding" <xiaowu.ding@jaguarmicro.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux@armlinux.org.uk
Cc:     nicolas.ferre@microchip.com, claudiu.beznea@microchip.com,
        palmer@dabbelt.com, paul.walmsley@sifive.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-riscv@lists.infradead.org,
        "xiaowu.ding" <xiaowu.ding@jaguarmicro.com>
Subject: [PATCH net-next] driver: cadence macb driver support acpi mode
Date:   Wed, 24 Aug 2022 20:13:51 +0800
Message-Id: <20220824121351.578-1-xiaowu.ding@jaguarmicro.com>
X-Mailer: git-send-email 2.34.1.windows.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR04CA0011.apcprd04.prod.outlook.com
 (2603:1096:4:197::10) To PS2PR06MB3432.apcprd06.prod.outlook.com
 (2603:1096:300:62::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 24d809eb-91fc-4863-4d84-08da85ca26f8
X-MS-TrafficTypeDiagnostic: PUZPR06MB5620:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: soFtZ6Uld9++llnZO5gDgLehZD7OyOFziIn+9C1vAE8m+GB/8L4C1Hv9cPI/K49RxdpAwpRuBmAn0y/JXuy7uVh2aJm910gOhtmnajrUXk7S6mAuGV8Oe+hDoihTxtdtw0HEDgY9DFdZduNsykA4Y/+CGXDqxZH1F7FJGpDNZXJjB0pHyKWHpLo/1jkH/JGZ6GfkcCG2VCQMxJz5AWjHyuu/8VyQeNosvjiJFkgPcSHJlH1imar0oK39apSnIq9emksBYPb1O+YFmWC32VScfhjRk2QCXtmG56FTu5HujJge3v7m8sJvBLuEyOSwC/vb1aqi4LmquPMezRxARTEbVb199oI82gOfKUjqPLgo+gwmeCVFXoX8epBg/F1hXyY4+G9F4Op0Nut+6YcOIp7cPFHuMroWsf6CrWcwVX71WX5ej0kzXCsjnbyfkud7M9r3hSXsbmfbAnLXkRgqOZBOyxbvH2uQnbX3oueorD4tbwfsLtGvi+bFPDOmctk18w9Oar93ar3Ww7NytKuilZG1wGba1BmPktvz+tlVZqjCXWJorkwsGWUzIwt2nUGNVD84+Lyi4JAASXtEaSCvIn9LROBb86tZZ90OkI/2Hvwz+kDbT6VjFbxphlSqKPJAvxboZOCDm/QX3ZsnFBd3mPMzGAIxwCjQqYxgn071Zu9vpPx69Ux0wpQGoHi+aGm5+T5AtoXO29EXEOScMcrKE8j0bIYDjnGTyuD06HhBVfW8ImT3NNzArZ/1D5LAJSqkzdXO
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PS2PR06MB3432.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39840400004)(396003)(346002)(136003)(366004)(376002)(86362001)(6666004)(107886003)(6512007)(41300700001)(26005)(38350700002)(38100700002)(2906002)(316002)(52116002)(6506007)(186003)(4326008)(478600001)(6486002)(1076003)(2616005)(8676002)(30864003)(7416002)(5660300002)(83380400001)(66476007)(66556008)(66946007)(36756003)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hUXSQ7fUXAfymNK9OaLgDj0Hi4ZfXb9+DZzf/jWP/X/ddLNgOgmtWBkQQMUI?=
 =?us-ascii?Q?bp33RyyZCs9JZbJPHAWEX2G3oh5XN6rQs184Er+kMp8sJ1+4stTBKRz2COYp?=
 =?us-ascii?Q?p7Y51RRz7O6KC+Jt29e/mjuXZ3JezVWxC3QpSadIWx152tb/eVJt7FQJeIJc?=
 =?us-ascii?Q?zrWT66ffZmm6ieC1r7FcILCdIL6yshn8irdakJGbFB+3uoPa9AAE7Y5nzMvE?=
 =?us-ascii?Q?DfCmk0p0HdKJ1tmG6auLtRmWIbO5s0z646R1F9/+as5hzkr8tFStv83tiN9S?=
 =?us-ascii?Q?G3ktadYm/NSoPSjvH0sYuyXSw6BFUVqAKe/by4270HAV7cJw7A2NWVjYH1ci?=
 =?us-ascii?Q?vsW+/7rRVO7+F5ybuwNP51fQofXtdHn+6ZwbnnmJQAs7lgD/sVwcMVPwfbI/?=
 =?us-ascii?Q?6HrpI8xkxbbhylbGFfbhbi4lMDzNheyf6zAlICifmjDr5B/MDXJmbagRcYBN?=
 =?us-ascii?Q?EoNJpYuIfnqxcck33p9rixDj+jw+2sd0diRsJFXXBgrp5DYNCchsJ9dJqOwQ?=
 =?us-ascii?Q?YN+lM4DCZxlnQ2xPFLua0sw12QeUgOJws3S0Vwpf6dBa/UL4S4dkAHhZz04v?=
 =?us-ascii?Q?ktlVyyQt2kzf/l/5Mz8QfOaC1039uiPNWx1+Myp1vzNzbN0W2gbSrhsYeE7F?=
 =?us-ascii?Q?6ngpt4n8pL8syXPKm5nRaukEafI/nRn57YP/+wUQD80sxuKxV1rb/B/U+lwy?=
 =?us-ascii?Q?B1j/XAY/BJaAh7SFnmGG7EekNf6L8d5JkF0mk9Q7CDkCcrwMIYpye9G3kfW+?=
 =?us-ascii?Q?DjCwnF65eD4UcsfnH/QIxj22h5EELqx5DJ6sdseK6UDW1+r4oWUexbc0vJaG?=
 =?us-ascii?Q?iGDg3vSP/6qJ0kuyqFio8b6AnzGIcJpvASNM4CaH5xBG47ypQdrIr5DkAwgW?=
 =?us-ascii?Q?r2F/EpXwqaGh2OVz7P3glBHnk6ulXrsePX5zVyshO8M5eMShLp+CJS0AJ+0C?=
 =?us-ascii?Q?xtE34qADfHqtZZDUFMtqbibTroY67QUeoQf4DMVk16Hdx9yENPLKk5SRhxoy?=
 =?us-ascii?Q?rhn+vWS7IH1G/9ZMQd3F07I2j9UQ66vUoVV/xmC9M0DkpPBVK+iUuC2Zo4qF?=
 =?us-ascii?Q?/9B2iXSkKukXy1cA1phnKB6AgeZrSCTX8Kmg1W1MxOA2jHaRG35pWhKKd8g8?=
 =?us-ascii?Q?kbN4ALDYL/0iJaZJCqYU23FSWb3Dxz5Ivttg0sN4JSHauAHdx2eQSpImfRvi?=
 =?us-ascii?Q?be8csbNXg55dksm/iqo3zl2+roJj4u7iYbLdVw++a1+IvT5/tabUaoaNaZIk?=
 =?us-ascii?Q?bilWkf3U9ex9zj6T485CJKA8U7sFq/19z724cpX5t2NyXoIB4SNv0GMOFAaj?=
 =?us-ascii?Q?pWbQxKjTyRTGXfyQA00NZwH/5+G8Ggrzco4FW+EZg61voYIctcUMkuHZFBhW?=
 =?us-ascii?Q?VAzq4RPDthozx31/26vn6YaRPn8qXbVNgtpLzyE0IzOzbv4nxlCMtKLznthy?=
 =?us-ascii?Q?XKwEovA5jGvtp/uwAS1f04b1fNgfPgRwlG2vTwsEgiQHdv1jIeeCYFkn06w8?=
 =?us-ascii?Q?edVQPFbGjs8roHmc+mVx2QbAx4tzOq3iCSUue56xeT1EMV+RfJxEiAR0BDuN?=
 =?us-ascii?Q?GojYzQTpMpH3COH8YiXdkfclypk2rgbPcnxjmZoMvmj11vzjw4XwHZQvmKp2?=
 =?us-ascii?Q?2g=3D=3D?=
X-OriginatorOrg: jaguarmicro.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 24d809eb-91fc-4863-4d84-08da85ca26f8
X-MS-Exchange-CrossTenant-AuthSource: PS2PR06MB3432.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Aug 2022 12:14:11.3478
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 1e45a5c2-d3e1-46b3-a0e6-c5ebf6d8ba7b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vIJ7XQbhe/fzjUXHFki1Huq1L4pAe0sTARxleg+0UDTmqGgcnZan2OtWJHrzksc7cfOV25Asg/Y5IWSqHext7mPA2ep3sypHiHqTZ1hEYOw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PUZPR06MB5620
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Uefi report the device info with acpi mode.But the macb driver
just support dts mode , So we need to add acpi mode with this driver.

We add the macb_acpi_support interface to get the clock rating from
the acpi.Because in the acpi mode ,the clock is controlled by the uefi,
and the driver will not modify the clock anymore.So we need get the
clock rating from the acpi

And we add macb_mdiobus_register interface ,and distinction the dts mode
and the acpi mode.Within the function, we add macb_acpi_mdiobus_register
function to realize the acpi mdio device register function.

And we also add macb_phylink_connect interface,and to distinction the dts
and acpi mode with the phy connection function.We add the
macb_acpi_phylink_connect function to realize the acpi phylink function.

Signed-off-by: xiaowu.ding <xiaowu.ding@jaguarmicro.com>
---
 drivers/net/ethernet/cadence/macb.h      |  46 ++++
 drivers/net/ethernet/cadence/macb_main.c | 330 +++++++++++++++++++++--
 2 files changed, 357 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb.h b/drivers/net/ethernet/cadence/macb.h
index 9c410f93a..a92299434 100644
--- a/drivers/net/ethernet/cadence/macb.h
+++ b/drivers/net/ethernet/cadence/macb.h
@@ -731,6 +731,33 @@
 #define MACB_LSO_UFO_ENABLE			0x01
 #define MACB_LSO_TSO_ENABLE			0x02
 
+/*Clk name define used for acpi mode*/
+#define MACB_SYSPCLOCK             "pclk"
+#define MACB_SYSHCLOCK             "hclk"
+#define MACB_TXCLOCK               "tx_clk"
+#define MACB_RXCLOCK               "rx_clk"
+#define MACB_TSCLOCK               "tsu_clk"
+
+/*Get the pclk clock rate used for acpi*/
+#define MACB_GET_GET_PCLOCKRATE(MACB)	\
+		((MACB)->acpicfg.pclk_rate)
+
+/*Get the hclk clock rate used for acpi*/
+#define MACB_GET_GET_HCLOCKRATE(MACB)	\
+		((MACB)->acpicfg.hclk_rate)
+
+/*Get the tsuclk clock rate used for acpi*/
+#define MACB_GET_GET_TSUCLOCKRATE(MACB)	\
+		((MACB)->acpicfg.tsuclk_rate)
+
+/*Get the tsuclk clock rate used for acpi*/
+#define MACB_GET_GET_TXCLOCKRATE(MACB)	\
+		((MACB)->acpicfg.txclk_rate)
+
+/*Get the tsuclk clock rate used for acpi*/
+#define MACB_GET_GET_RXCLOCKRATE(MACB)	\
+		((MACB)->acpicfg.rxclk_rate)
+
 /* Bit manipulation macros */
 #define MACB_BIT(name)					\
 	(1 << MACB_##name##_OFFSET)
@@ -1242,6 +1269,18 @@ struct ethtool_rx_fs_list {
 	unsigned int count;
 };
 
+/* On ACPI platforms, clocks are controlled by firmware and/or
+ * ACPI, not by drivers.Need to store the clock value.
+ */
+struct macb_acpi_config {
+	u32 hclk_rate;          /* amba clock rate*/
+	u32 pclk_rate;          /* amba apb clock rate*/
+	u32 txclk_rate;         /* tx clock rate*/
+	u32 rxclk_rate;         /* rx clock rate*/
+	u32 tsuclk_rate;        /* tx clock rate*/
+	bool acpi_enable;       /* is acpi or not */
+};
+
 struct macb {
 	void __iomem		*regs;
 	bool			native_io;
@@ -1324,6 +1363,7 @@ struct macb {
 
 	struct macb_pm_data pm_data;
 	const struct macb_usrio_config *usrio;
+	struct macb_acpi_config acpicfg;
 };
 
 #ifdef CONFIG_MACB_USE_HWSTAMP
@@ -1381,6 +1421,12 @@ static inline bool gem_has_ptp(struct macb *bp)
 	return !!(bp->caps & MACB_CAPS_GEM_HAS_PTP);
 }
 
+/* macb is support acpi or not */
+static inline bool macb_has_acpi(struct macb *bp)
+{
+	return bp->acpicfg.acpi_enable;
+}
+
 /**
  * struct macb_platform_data - platform data for MACB Ethernet used for PCI registration
  * @pclk:		platform clock
diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 66c7d08d3..41116d4ee 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -38,6 +38,8 @@
 #include <linux/pm_runtime.h>
 #include <linux/ptp_classify.h>
 #include <linux/reset.h>
+#include <linux/acpi.h>
+#include <linux/acpi_mdio.h>
 #include "macb.h"
 
 /* This structure is only used for MACB on SiFive FU540 devices */
@@ -748,14 +750,14 @@ static const struct phylink_mac_ops macb_phylink_ops = {
 	.mac_link_up = macb_mac_link_up,
 };
 
-static bool macb_phy_handle_exists(struct device_node *dn)
+static bool macb_of_phy_handle_exists(struct device_node *dn)
 {
 	dn = of_parse_phandle(dn, "phy-handle", 0);
 	of_node_put(dn);
 	return dn != NULL;
 }
 
-static int macb_phylink_connect(struct macb *bp)
+static int macb_of_phylink_connect(struct macb *bp)
 {
 	struct device_node *dn = bp->pdev->dev.of_node;
 	struct net_device *dev = bp->dev;
@@ -765,7 +767,7 @@ static int macb_phylink_connect(struct macb *bp)
 	if (dn)
 		ret = phylink_of_phy_connect(bp->phylink, dn, 0);
 
-	if (!dn || (ret && !macb_phy_handle_exists(dn))) {
+	if (!dn || (ret && !macb_of_phy_handle_exists(dn))) {
 		phydev = phy_find_first(bp->mii_bus);
 		if (!phydev) {
 			netdev_err(dev, "no PHY found\n");
@@ -786,6 +788,166 @@ static int macb_phylink_connect(struct macb *bp)
 	return 0;
 }
 
+#ifdef CONFIG_ACPI
+
+static bool macb_acpi_phy_handle_exists(struct fwnode_handle *fwnd)
+{
+	struct fwnode_handle *phy_node;
+	bool flag = false;
+	/* Only phy-handle is used for ACPI */
+	phy_node = fwnode_find_reference(fwnd, "phy-handle", 0);
+	flag = !IS_ERR_OR_NULL(phy_node);
+
+	if (flag)
+		fwnode_handle_put(phy_node);
+
+	return flag;
+}
+
+static int macb_acpi_phylink_connect(struct macb *bp)
+{
+	struct fwnode_handle *fwnd = bp->pdev->dev.fwnode;
+	struct net_device *dev = bp->dev;
+	struct phy_device *phydev;
+	int ret;
+
+	if (fwnd)
+		ret = phylink_fwnode_phy_connect(bp->phylink, fwnd, 0);
+
+	if (!fwnd || (ret && !macb_acpi_phy_handle_exists(fwnd))) {
+		phydev = phy_find_first(bp->mii_bus);
+		if (!phydev) {
+			netdev_err(dev, "no PHY found\n");
+			return -ENXIO;
+		}
+
+		/* attach the mac to the phy */
+		ret = phylink_connect_phy(bp->phylink, phydev);
+	}
+
+	if (ret) {
+		netdev_err(dev, "Could not attach PHY (%d)\n", ret);
+		return ret;
+	}
+
+	phylink_start(bp->phylink);
+
+	return 0;
+}
+
+static int macb_acpi_support(struct macb *bp)
+{
+	struct device *dev = &bp->pdev->dev;
+	struct macb_acpi_config *config = &bp->acpicfg;
+	int ret;
+	u32 property;
+
+	/*acpi must be report the pclk*/
+	property = 0;
+	ret = device_property_read_u32(dev, MACB_SYSPCLOCK, &property);
+	if (ret) {
+		dev_err(dev, "unable to obtain %s property\n", MACB_SYSPCLOCK);
+		return ret;
+	}
+
+	config->pclk_rate = property;
+
+	/*acpi must be report the hclk*/
+	property = 0;
+	ret = device_property_read_u32(dev, MACB_SYSHCLOCK, &property);
+	if (ret) {
+		dev_err(dev, "unable to obtain %s property\n", MACB_SYSHCLOCK);
+		return ret;
+	}
+
+	config->hclk_rate = property;
+
+	/*acpi optional report txclk */
+	property = 0;
+	ret = device_property_read_u32(dev, MACB_TXCLOCK, &property);
+	if (ret) {
+		dev_info(dev, "unable to obtain %s property\n", MACB_TXCLOCK);
+		property = 0;
+	}
+
+	config->txclk_rate = property;
+
+	/*acpi optional report rxclk */
+	property = 0;
+	ret = device_property_read_u32(dev, MACB_RXCLOCK, &property);
+	if (ret) {
+		dev_info(dev, "unable to obtain %s property\n", MACB_RXCLOCK);
+		property = 0;
+	}
+
+	config->rxclk_rate = property;
+
+	/*acpi optional report tsuclk */
+	property = 0;
+	ret = device_property_read_u32(dev, MACB_TSCLOCK, &property);
+	if (ret) {
+		dev_info(dev, "unable to obtain %s property\n", MACB_TSCLOCK);
+		property = 0;
+	}
+
+	config->tsuclk_rate = property;
+
+	return 0;
+}
+
+static int macb_acpi_mdiobus_register(struct macb *bp)
+{
+	struct platform_device *pdev =	bp->pdev;
+	struct fwnode_handle *fwnode = pdev->dev.fwnode;
+	struct fwnode_handle *child;
+	u32 addr;
+	int ret;
+
+	if (!IS_ERR_OR_NULL(fwnode_find_reference(pdev->dev.fwnode, "fixed-link", 0)))
+		return mdiobus_register(bp->mii_bus);
+
+	fwnode_for_each_child_node(fwnode, child) {
+		ret = acpi_get_local_address(ACPI_HANDLE_FWNODE(child), &addr);
+		if (ret || addr >= PHY_MAX_ADDR)
+			continue;
+		ret = acpi_mdiobus_register(bp->mii_bus, fwnode);
+		if (!ret)
+			return ret;
+		break;
+	}
+
+	return mdiobus_register(bp->mii_bus);
+}
+
+#else
+
+static int macb_acpi_phylink_connect(struct macb *bp)
+{
+	return -EINVAL;
+}
+
+static int macb_acpi_support(struct macb *bp)
+{
+	return -EINVAL;
+}
+
+static int macb_acpi_mdiobus_register(struct macb *bp)
+{
+	return -EINVAL;
+}
+
+#endif
+
+static int macb_phylink_connect(struct macb *bp)
+{
+	if (likely(!macb_has_acpi(bp))) {
+		/* macb of device tree mode register mdiobus */
+		return macb_of_phylink_connect(bp);
+	}
+		/* macb acpi mode register mdiobus */
+	return macb_acpi_phylink_connect(bp);
+}
+
 static void macb_get_pcs_fixed_state(struct phylink_config *config,
 				     struct phylink_link_state *state)
 {
@@ -851,7 +1013,7 @@ static int macb_mii_probe(struct net_device *dev)
 	return 0;
 }
 
-static int macb_mdiobus_register(struct macb *bp)
+static int macb_of_mdiobus_register(struct macb *bp)
 {
 	struct device_node *child, *np = bp->pdev->dev.of_node;
 
@@ -887,6 +1049,16 @@ static int macb_mdiobus_register(struct macb *bp)
 	return mdiobus_register(bp->mii_bus);
 }
 
+static int macb_mdiobus_register(struct macb *bp)
+{
+	if (likely(!macb_has_acpi(bp))) {
+		/* macb of device tree mode register mdio bus */
+		return macb_of_mdiobus_register(bp);
+	}
+	/* macb acpi mode register mdio bus */
+	return macb_acpi_mdiobus_register(bp);
+}
+
 static int macb_mii_init(struct macb *bp)
 {
 	int err = -ENXIO;
@@ -2578,7 +2750,12 @@ static void macb_reset_hw(struct macb *bp)
 static u32 gem_mdc_clk_div(struct macb *bp)
 {
 	u32 config;
-	unsigned long pclk_hz = clk_get_rate(bp->pclk);
+	unsigned long pclk_hz;
+
+	if (unlikely(macb_has_acpi(bp)))
+		pclk_hz = MACB_GET_GET_PCLOCKRATE(bp);
+	else
+		pclk_hz = clk_get_rate(bp->pclk);
 
 	if (pclk_hz <= 20000000)
 		config = GEM_BF(CLK, GEM_CLK_DIV8);
@@ -3263,6 +3440,8 @@ static unsigned int gem_get_tsu_rate(struct macb *bp)
 {
 	struct clk *tsu_clk;
 	unsigned int tsu_rate;
+	if (unlikely(macb_has_acpi(bp)))
+		return MACB_GET_GET_TSUCLOCKRATE(bp);
 
 	tsu_clk = devm_clk_get(&bp->pdev->dev, "tsu_clk");
 	if (!IS_ERR(tsu_clk))
@@ -3865,7 +4044,6 @@ static void macb_clks_disable(struct clk *pclk, struct clk *hclk, struct clk *tx
 		{ .clk = hclk, },
 		{ .clk = tx_clk },
 	};
-
 	clk_bulk_disable_unprepare(ARRAY_SIZE(clks), clks);
 }
 
@@ -4811,6 +4989,94 @@ static const struct of_device_id macb_dt_ids[] = {
 MODULE_DEVICE_TABLE(of, macb_dt_ids);
 #endif /* CONFIG_OF */
 
+#ifdef CONFIG_ACPI
+
+static int jmnd_mac_clk_init(struct platform_device *pdev, struct clk **pclk,
+			     struct clk **hclk, struct clk **tx_clk,
+			     struct clk **rx_clk, struct clk **tsu_clk)
+{
+	/*On ACPI platforms, clocks are controlled by firmware and/or
+	 * ACPI, not configure by drivers.So here need to dummy here.
+	 */
+	*pclk = NULL;
+	*hclk = NULL;
+	*tx_clk = NULL;
+	*rx_clk = NULL;
+	*tsu_clk = NULL;
+	dev_info(&pdev->dev, "Jmnd Mac clock dummpy init.\n");
+	return 0;
+}
+
+static const struct macb_config jmnd_gem_rgmii_config = {
+	.caps = MACB_CAPS_GIGABIT_MODE_AVAILABLE | MACB_CAPS_SG_DISABLED |
+			MACB_CAPS_JUMBO,
+	.dma_burst_length = 16,
+	.clk_init = jmnd_mac_clk_init,
+	.init = macb_init,
+	.jumbo_max_len = 10240,
+	.usrio = &macb_default_usrio
+};
+
+static const struct macb_config jmnd_gem_rmii_config = {
+	.caps = MACB_CAPS_SG_DISABLED | MACB_CAPS_JUMBO,
+	.dma_burst_length = 16,
+	.clk_init = jmnd_mac_clk_init,
+	.init = macb_init,
+	.jumbo_max_len = 10240,
+	.usrio = &macb_default_usrio,
+};
+
+static const struct acpi_device_id macb_acpi_ids[] = {
+	{
+		.id = "JAMC00B0",
+		.driver_data = (kernel_ulong_t)&jmnd_gem_rgmii_config
+	},
+	{
+		.id = "JAMC00BA",
+		.driver_data = (kernel_ulong_t)&jmnd_gem_rmii_config
+	},
+	{
+	},
+};
+
+MODULE_DEVICE_TABLE(acpi, macb_acpi_ids);
+
+static void macb_acpi_gdata(struct platform_device *pdev, int (**init)(struct platform_device *),
+			    int (**clk_init)(struct platform_device *, struct clk **, struct clk **,
+					     struct clk **,  struct clk **, struct clk **),
+			    const struct macb_config **macb_config)
+{
+	const struct acpi_device_id *match;
+
+	match = acpi_match_device(macb_acpi_ids, &pdev->dev);
+	if (match && match->driver_data) {
+		*macb_config = (struct macb_config *)match->driver_data;
+		*clk_init = (*macb_config)->clk_init;
+		*init = (*macb_config)->init;
+	}
+}
+
+#else
+
+static void macb_acpi_gdata(struct platform_device *pdev, int (**init)(struct platform_device *),
+			    int (**clk_init)(struct platform_device *, struct clk **, struct clk **,
+					     struct clk **,  struct clk **, struct clk **),
+			    const struct macb_config **macb_config)
+{
+}
+
+#endif
+
+/* config acpi mode ,dts priority high*/
+static inline void macb_set_acpi_mode(struct macb *bp)
+{
+	struct device *dev = &bp->pdev->dev;
+
+	bp->acpicfg.acpi_enable = dev_of_node(dev) ? false :
+		(is_acpi_node(dev->fwnode) ? true : false);
+	wmb();/* drain writebuffer */
+}
+
 static const struct macb_config default_gem_config = {
 	.caps = MACB_CAPS_GIGABIT_MODE_AVAILABLE |
 		MACB_CAPS_JUMBO |
@@ -4830,6 +5096,7 @@ static int macb_probe(struct platform_device *pdev)
 			struct clk **) = macb_config->clk_init;
 	int (*init)(struct platform_device *) = macb_config->init;
 	struct device_node *np = pdev->dev.of_node;
+	struct fwnode_handle *fwnodep = pdev->dev.fwnode;
 	struct clk *pclk, *hclk = NULL, *tx_clk = NULL, *rx_clk = NULL;
 	struct clk *tsu_clk = NULL;
 	unsigned int queue_mask, num_queues;
@@ -4845,7 +5112,7 @@ static int macb_probe(struct platform_device *pdev)
 	if (IS_ERR(mem))
 		return PTR_ERR(mem);
 
-	if (np) {
+	if (likely(np)) {
 		const struct of_device_id *match;
 
 		match = of_match_node(macb_dt_ids, np);
@@ -4855,10 +5122,15 @@ static int macb_probe(struct platform_device *pdev)
 			init = macb_config->init;
 		}
 	}
+	/*add gem support acpi*/
+	else if (is_acpi_node(fwnodep))
+		macb_acpi_gdata(pdev, &init, &clk_init, &macb_config);
 
-	err = clk_init(pdev, &pclk, &hclk, &tx_clk, &rx_clk, &tsu_clk);
-	if (err)
-		return err;
+	if (clk_init) {
+		err = clk_init(pdev, &pclk, &hclk, &tx_clk, &rx_clk, &tsu_clk);
+		if (err)
+			return err;
+	}
 
 	pm_runtime_set_autosuspend_delay(&pdev->dev, MACB_PM_TIMEOUT);
 	pm_runtime_use_autosuspend(&pdev->dev);
@@ -4902,9 +5174,16 @@ static int macb_probe(struct platform_device *pdev)
 	if (macb_config)
 		bp->jumbo_max_len = macb_config->jumbo_max_len;
 
+	/* macb set acpi mode is enabled */
+	macb_set_acpi_mode(bp);
+
+	if (macb_has_acpi(bp))
+		macb_acpi_support(bp);
+
 	bp->wol = 0;
-	if (of_get_property(np, "magic-packet", NULL))
+	if (device_property_present(&pdev->dev, "magic-packet"))
 		bp->wol |= MACB_WOL_HAS_MAGIC_PACKET;
+
 	device_set_wakeup_capable(&pdev->dev, bp->wol & MACB_WOL_HAS_MAGIC_PACKET);
 
 	bp->usrio = macb_config->usrio;
@@ -4951,15 +5230,13 @@ static int macb_probe(struct platform_device *pdev)
 	if (bp->caps & MACB_CAPS_NEEDS_RSTONUBR)
 		bp->rx_intr_mask |= MACB_BIT(RXUBR);
 
-	err = of_get_ethdev_address(np, bp->dev);
-	if (err == -EPROBE_DEFER)
-		goto err_out_free_netdev;
-	else if (err)
+	if (device_get_ethdev_address(&pdev->dev, dev))
 		macb_get_hwaddr(bp);
 
-	err = of_get_phy_mode(np, &interface);
-	if (err)
-		/* not found in DT, MII by default */
+	/*add gem support acpi*/
+	interface = device_get_phy_mode(&pdev->dev);
+	if (interface < 0)
+		/* not found in DT and ACPI , MII by default */
 		bp->phy_interface = PHY_INTERFACE_MODE_MII;
 	else
 		bp->phy_interface = interface;
@@ -5213,6 +5490,12 @@ static int __maybe_unused macb_runtime_suspend(struct device *dev)
 	struct net_device *netdev = dev_get_drvdata(dev);
 	struct macb *bp = netdev_priv(netdev);
 
+	/*On ACPI platforms, clocks are controlled by firmware and/or
+	 * ACPI, not by drivers.
+	 */
+	if (unlikely(macb_has_acpi(bp)))
+		return 0;
+
 	if (!(device_may_wakeup(dev)))
 		macb_clks_disable(bp->pclk, bp->hclk, bp->tx_clk, bp->rx_clk, bp->tsu_clk);
 	else if (!(bp->caps & MACB_CAPS_NEED_TSUCLK))
@@ -5226,6 +5509,12 @@ static int __maybe_unused macb_runtime_resume(struct device *dev)
 	struct net_device *netdev = dev_get_drvdata(dev);
 	struct macb *bp = netdev_priv(netdev);
 
+	/*On ACPI platforms, clocks are controlled by firmware and/or
+	 * ACPI, not by drivers.
+	 */
+	if (unlikely(macb_has_acpi(bp)))
+		return 0;
+
 	if (!(device_may_wakeup(dev))) {
 		clk_prepare_enable(bp->pclk);
 		clk_prepare_enable(bp->hclk);
@@ -5250,7 +5539,10 @@ static struct platform_driver macb_driver = {
 	.driver		= {
 		.name		= "macb",
 		.of_match_table	= of_match_ptr(macb_dt_ids),
-		.pm	= &macb_pm_ops,
+#ifdef CONFIG_ACPI
+		.acpi_match_table = ACPI_PTR(macb_acpi_ids),
+#endif
+		.pm = &macb_pm_ops,
 	},
 };
 
-- 
2.17.1

