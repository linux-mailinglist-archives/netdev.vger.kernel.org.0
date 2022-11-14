Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07395627C90
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 12:42:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236104AbiKNLmO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 06:42:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233300AbiKNLmM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 06:42:12 -0500
Received: from APC01-PSA-obe.outbound.protection.outlook.com (mail-psaapc01on20608.outbound.protection.outlook.com [IPv6:2a01:111:f400:feae::608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FE3B193C0;
        Mon, 14 Nov 2022 03:42:10 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZaG+dgn+Df6NAKPP2Cv0Ctcyyh5l82nhQ6xPJFdZgWPhKT9q7YRSxQKsPRzNMhUVcIj6aO2QE3SSHxB7CmLKDH+xbSU3/Ra+hWhTyEGAX83W+3Jzy4cOIfDnOsZHMQ7x0SuB5brvXnH0nFDmAJ0X6xdSnwhyeKvuxRhfjAXp4N09JTOulf24VLOqLYR9umI8JJyXMT2SYqJG5BD2sWcc8TjXo+ZWbPAwDeP84NcFZ7900E8HMcQLh4ZV8zu7P0qepwahwb9QXLdpawr4VxKbP4DXOgKrTmj7NvATEg9FBm3Kii55QUVNkbAOLu2P9069gJdOa1kIX3UO+FB9PWjbeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vYHxGf8eKy/rpZFCWXJMzgKXV24tNrrk/BVMveLwphc=;
 b=L0ki5ctTNH7aXdFI7RM1CumcJjWs14RxiHxNnP9utJJL+9ccRAJ4u5NiGTpDIXkeL3RLMKufnfWPisfH8S8HDPjVBS2fIUKI065XjH2TgoSXknRRY/PzZInVUaBnXKAryem/4DrLEQJQVFne2IAHYf335SSfOWCxHD5vQjq93BfAB/gYl/SLcMDho/rHXzOqiEXuTNXlxavEfhfCKevPA/F/1nQHpt6YrRICflRqsQdjiYQg1El+6wIcap48FdvgPmIP5ZZgzbeLaQsVFhRSZ9HGXONdAK2OUK+aNccpoV5Q+hbtAVGQTGR+N3ucW+QaL74jjxPmfb3Sydz+9fOIdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=jaguarmicro.com; dmarc=pass action=none
 header.from=jaguarmicro.com; dkim=pass header.d=jaguarmicro.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=jaguarmicro.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vYHxGf8eKy/rpZFCWXJMzgKXV24tNrrk/BVMveLwphc=;
 b=QZNvV2CnG2v7xZH3kOHWPBVAsx4h1svpuAcqQ7xR0AGQ6vw4mJs2Gk6IoaQuax8RZfLFaJ15SafzZ9uLEZQgylfXqySLyS5L0HRwqa0oMTcexIKfi6hN51Ka1Db0QZPDCCczE/Gw5V2ujvZsgA/AknhrJbtUEMVnS/rKZKX6IfhOOlVF9IFqMhHHt2FH/xU6ZzsQN+WQ5on8u8aQdSYetT1EZOf3QIucRs+f+C4iQ1xplBY1oqQvSabuOFclbKRACvZ8s/GqZghJk9H4XlAT5wFBP4nMyPqiKfT0AUmAq3kVRtwdLIOjCweVM6zPrWRKWN1/qiJyxVWuZ2xMIBeiXg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=jaguarmicro.com;
Received: from PS2PR06MB3432.apcprd06.prod.outlook.com (2603:1096:300:62::16)
 by KL1PR06MB6259.apcprd06.prod.outlook.com (2603:1096:820:d9::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.17; Mon, 14 Nov
 2022 11:42:01 +0000
Received: from PS2PR06MB3432.apcprd06.prod.outlook.com
 ([fe80::3d93:4000:1302:3fea]) by PS2PR06MB3432.apcprd06.prod.outlook.com
 ([fe80::3d93:4000:1302:3fea%7]) with mapi id 15.20.5813.017; Mon, 14 Nov 2022
 11:42:01 +0000
From:   "xiaowu.ding" <xiaowu.ding@jaguarmicro.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux@armlinux.org.uk
Cc:     nicolas.ferre@microchip.com, claudiu.beznea@microchip.com,
        palmer@dabbelt.com, paul.walmsley@sifive.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-riscv@lists.infradead.org,
        Xiaowu Ding <xiaowu.ding@jaguarmicro.com>
Subject: [PATCH v2] net:macb: driver support acpi mode
Date:   Mon, 14 Nov 2022 19:41:26 +0800
Message-Id: <20221114114126.1881-1-xiaowu.ding@jaguarmicro.com>
X-Mailer: git-send-email 2.34.1.windows.1
In-Reply-To: <YxYuRaXxtyMIF/A6@lunn.ch>
References: <YxYuRaXxtyMIF/A6@lunn.ch>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR01CA0119.apcprd01.prod.exchangelabs.com
 (2603:1096:4:40::23) To PS2PR06MB3432.apcprd06.prod.outlook.com
 (2603:1096:300:62::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PS2PR06MB3432:EE_|KL1PR06MB6259:EE_
X-MS-Office365-Filtering-Correlation-Id: 72b41a55-5999-4829-d895-08dac6353ea2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2bz6bdyB5w0Gn6jp75Jt2+f5QDkH+vokHw4JLCE9Aq91/dFngRdhEnChkglgtztkzIqNvRbUcO/DCebfE09uYD7UB0P58JuVTp0S9ORVeWfLlKShF+tjVoig8oYK/xL5mGnF40xRDJFjiCX3+bT9Dj/kk/YYneUeYpxEigaI5dSCK0V6o+QORTaCR0p6jg51L3pBM2EoUFOOaFq8cPEo9EqkZjtnrE+nkgzxe8zVO0DTYR+L/rADLmJtX1R77C9hqDh5WPemjqHCZZurkTeOkqHVx+PMxr65wSMTLWlyoaMU+jallm5AUiJuSVLVdABmLGTAZIRh2x0yS207Yngir7Uo0oZNDNbnniLM4uRC0qleuD+UWv2Qvgkuy1FhdhKNWUgdOUDtABym5Alw05M4ol/lCkZGIcSiUcf3BLd15nXGLiQr2xmk5cEeT9VekMT9LIrlmYMuraWyvaEPoBT9ndvbSIuqHpNpuu7jEiSm65Edd8avIYIJkvB6tgyPe7kDuCdvv+p7emjCSzVgeZoyR0Fm4ciL3TYdT+RhU66oojNp3j2bzzlqc8HkZDxcjMdAry6PgBk2tf1772x8eaTSp4IjEgv3aW01VAziUd2rkraA99xUhO+zR8ALpDAMpTNLJhtzW3g65U/XudWh7Tc9u6HXGrgEamjkjnAK9VA1Ob6pKYRa2/Go1HUrghjqRKGpeBoIYopNjou4N6YLBUSpStjV6XaOm8TfSiQratSJr7Pb7DQjRdkh7zijq9GbRpBu
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PS2PR06MB3432.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(366004)(376002)(346002)(39840400004)(136003)(451199015)(2616005)(8936002)(478600001)(6486002)(6506007)(52116002)(107886003)(6666004)(2906002)(316002)(36756003)(41300700001)(86362001)(66476007)(66946007)(7416002)(1076003)(5660300002)(66556008)(186003)(8676002)(4326008)(26005)(6512007)(83380400001)(38100700002)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+zg+znuIAb+nX34z3+NrOmVOdClmkGBg41mVHovVuLlS/+ZkjL7sWWTgQyOQ?=
 =?us-ascii?Q?EIWPzgDzBZlBF0KROLt3AklZTy7H/fPnvaAfp+k65jePi192as6ubGvrxl8+?=
 =?us-ascii?Q?/LRRrs79il8FAOOoAm2yK2dTtWM8Mca9ERmINVcA/VFi4CivIOPBOTk4fX5c?=
 =?us-ascii?Q?/9I2LOCY2dbHoWmOGCiEr/ze2av7p3SjvA6d8VNBifw8Jf+wUImbXiKi3JsJ?=
 =?us-ascii?Q?TV5gQyuHGCzFGJUX9SpGnVei5wvdyRx9X93GD31aekJnAMcLcMAI5UvRzCKs?=
 =?us-ascii?Q?odMwdPzY6L3JzoD9WaTyE6Yy6f5EWJjxtCt5czdBgiSlN1qeahmbtxbbkjRa?=
 =?us-ascii?Q?Y3+u7TJmBNFYYGVVTYkI4HNESDUtPZzA+ZugeAmiLl+2n+Vaaat8jcvANTfi?=
 =?us-ascii?Q?u2re0+00U2/EoXILrrLFN6zU2sCMbdwklQXRw1Kw7qMmAFwQW4EbNIeIa8QV?=
 =?us-ascii?Q?RiqjCF1/1QUIc3hMVSbJEQ5ltns5MedsBxafTSqq9YV1HHN0gmBBemb0gFvn?=
 =?us-ascii?Q?0cWPz2ROWjEDFyTb+nEbIfEuoEMkJEWknL6o1mRdx/TPWhB2qlzpzmcjC4Gh?=
 =?us-ascii?Q?iykP19HDf1jpa3SCYi56kFo8H1tgaEB9KECCYsgcymPZiLQTOKHDzuRO3L+B?=
 =?us-ascii?Q?DW28bTFHmZGVG94BCOjvHMlU9UGviwzFFuZlwowIUNNEpyFnChFt5n4PFlrl?=
 =?us-ascii?Q?QAH4oCf1OiVqROhZfiJXh0VH9SaU26wWz/1BP/YhATncYd8XyLua4kbt+9JS?=
 =?us-ascii?Q?r5QzyhhA4uNFmUXmA6JFQdUqlssw19ZAXQvGuZ0riecJVyJ0EnkoBtZ93A2n?=
 =?us-ascii?Q?q02zErGx3rOaNVuPezhPrYKIutmnDj3gsRfhjgLPB4V5QyR4xv/sVrJ/bq8K?=
 =?us-ascii?Q?3Wdi6MjCuE8HgqJmS1tP9jktesK5C1jH04bmbjJ0mM9h1S1ZMTHk2I5KbWuY?=
 =?us-ascii?Q?+1f4vUzxmYDbxhuJCarsbibWZIvglhXgPFJvDj7ca+NFiq4Lz/ViisaVvfne?=
 =?us-ascii?Q?04IqSUtiGE8u3Zph54okH0GHPLYuVnwmbLQrncJAgbW67l2+OnvR/1XenYyf?=
 =?us-ascii?Q?W3BNYxSBL37sAb4HqWwc+McsiQ/8EQ7CrJ7/ZvtuMQBUcWL7IFVd72XUgqOq?=
 =?us-ascii?Q?GSygDiIozzc2OVg+b+pBI0+Ux5dv3TA2yVEvF8QraaTE/u1JGfth0C0p4zYI?=
 =?us-ascii?Q?miWWRZXBnj8nqKWblnzeFbotVIqN2o/VgC8nRaZYcF10O/zyAzpGc9ixiEll?=
 =?us-ascii?Q?iXXMgiVmXfEMdz2UvG7dBsiFqxSCCW0kg7u4b/X9HezW7TJIBBUB1vvxjihW?=
 =?us-ascii?Q?opuEJss1fo+SyzJ3vcxdX+FpBryq/aLvL/d4NDHGmahuog+fROvKvI5wmkMF?=
 =?us-ascii?Q?1aZxDpZ+Ze3XsdiDQ42TscFr0iIxFoatjQj8QmHF1YNHepai5BnYJ8NWZBDC?=
 =?us-ascii?Q?Ix8kXfHLyRU9gBs9dM5bxg525qZT6SRGSdQu2o0NxEUpA5ev3TQ2yX1FRSQB?=
 =?us-ascii?Q?2FhJ2bZuVwGm+HtI/54D4TE7M9BNoEVGzwQCYmMx/JR7fswROSRhyM3Z9Vv6?=
 =?us-ascii?Q?QnUZ9hGDBkMLFeGFVFqrhdn2YAucOvIGZe4S28mFH1u8dWJ1m3d5uejkP5Cc?=
 =?us-ascii?Q?tA=3D=3D?=
X-OriginatorOrg: jaguarmicro.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 72b41a55-5999-4829-d895-08dac6353ea2
X-MS-Exchange-CrossTenant-AuthSource: PS2PR06MB3432.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Nov 2022 11:42:01.5428
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 1e45a5c2-d3e1-46b3-a0e6-c5ebf6d8ba7b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4mqqyraXgnAl7p0L0+nDJHBx5CcSjpCiyCvK0iXRt4mxb8fb06VFw9WcuSzUoJTkURP+XLY5CF5Gy3nwkbNbNpqKlEiuTRN2p2IrvUS+eY4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KL1PR06MB6259
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xiaowu Ding <xiaowu.ding@jaguarmicro.com>

Cadence gem driver suuport acpi mode. Current the macb driver
just support device tree mode.So we add new acpi mode code with
this driver.

Signed-off-by: Xiaowu Ding <xiaowu.ding@jaguarmicro.com>
---
V1 -> V2: Add the fixed "pclk" and "hclk" clock within the acpi platform 
          device create.And delete the clock related modify code within the patch V1.
---

 drivers/net/ethernet/cadence/macb_main.c | 118 +++++++++++++++++++----
 1 file changed, 100 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index aa1b03f8bfe9..c98a8b64f9c1 100644
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
@@ -748,24 +750,26 @@ static const struct phylink_mac_ops macb_phylink_ops = {
 	.mac_link_up = macb_mac_link_up,
 };
 
-static bool macb_phy_handle_exists(struct device_node *dn)
+static bool macb_phy_handle_exists(struct fwnode_handle *fwnode)
 {
-	dn = of_parse_phandle(dn, "phy-handle", 0);
-	of_node_put(dn);
-	return dn != NULL;
+	struct fwnode_handle *phy_node;
+
+	phy_node = fwnode_find_reference(fwnode, "phy-handle", 0);
+	fwnode_handle_put(phy_node);
+	return !IS_ERR(phy_node);
 }
 
 static int macb_phylink_connect(struct macb *bp)
 {
-	struct device_node *dn = bp->pdev->dev.of_node;
+	struct fwnode_handle *fwnode = bp->pdev->dev.fwnode;
 	struct net_device *dev = bp->dev;
 	struct phy_device *phydev;
 	int ret;
 
-	if (dn)
-		ret = phylink_of_phy_connect(bp->phylink, dn, 0);
-
-	if (!dn || (ret && !macb_phy_handle_exists(dn))) {
+	if (fwnode)
+		ret = phylink_fwnode_phy_connect(bp->phylink, fwnode, 0);
+	 /* historical device tree code so keep no change */
+	if (!fwnode || (ret && !macb_phy_handle_exists(fwnode))) {
 		phydev = phy_find_first(bp->mii_bus);
 		if (!phydev) {
 			netdev_err(dev, "no PHY found\n");
@@ -852,7 +856,7 @@ static int macb_mii_probe(struct net_device *dev)
 	return 0;
 }
 
-static int macb_mdiobus_register(struct macb *bp)
+static int macb_of_mdiobus_register(struct macb *bp)
 {
 	struct device_node *child, *np = bp->pdev->dev.of_node;
 
@@ -888,6 +892,36 @@ static int macb_mdiobus_register(struct macb *bp)
 	return mdiobus_register(bp->mii_bus);
 }
 
+static int macb_acpi_mdiobus_register(struct macb *bp)
+{
+	struct platform_device *pdev = bp->pdev;
+	struct fwnode_handle *fwnode = pdev->dev.fwnode;
+	struct fwnode_handle *child;
+	u32 addr;
+	int ret;
+
+	if (!IS_ERR_OR_NULL(fwnode_find_reference(fwnode, "fixed-link", 0)))
+		return mdiobus_register(bp->mii_bus);
+	fwnode_for_each_child_node(fwnode, child) {
+		ret = acpi_get_local_address(ACPI_HANDLE_FWNODE(child), &addr);
+		if (ret)
+			continue;
+
+		ret = acpi_mdiobus_register(bp->mii_bus, fwnode);
+	}
+
+	return mdiobus_register(bp->mii_bus);
+}
+
+static int macb_mdiobus_register(struct macb *bp)
+{
+	/* macb of device tree mode register mdio bus */
+	if (likely(is_of_node(bp->pdev->dev.fwnode)))
+		return macb_of_mdiobus_register(bp);
+	/* macb acpi mode register mdio bus */
+	return macb_acpi_mdiobus_register(bp);
+}
+
 static int macb_mii_init(struct macb *bp)
 {
 	int err = -ENXIO;
@@ -4812,6 +4846,42 @@ static const struct of_device_id macb_dt_ids[] = {
 MODULE_DEVICE_TABLE(of, macb_dt_ids);
 #endif /* CONFIG_OF */
 
+#ifdef CONFIG_ACPI
+
+static const struct macb_config jmnd_gem_rgmii_config = {
+	.caps = MACB_CAPS_GIGABIT_MODE_AVAILABLE | MACB_CAPS_SG_DISABLED |
+	    MACB_CAPS_JUMBO,
+	.dma_burst_length = 16,
+	.clk_init = macb_clk_init,
+	.init = macb_init,
+	.jumbo_max_len = 10240,
+	.usrio = &macb_default_usrio
+};
+
+static const struct macb_config jmnd_gem_rmii_config = {
+	.caps = MACB_CAPS_SG_DISABLED | MACB_CAPS_JUMBO,
+	.dma_burst_length = 16,
+	.clk_init = macb_clk_init,
+	.init = macb_init,
+	.jumbo_max_len = 10240,
+	.usrio = &macb_default_usrio,
+};
+
+static const struct acpi_device_id macb_acpi_ids[] = {
+	{
+	 .id = "JAMC00B0",
+	 .driver_data = (kernel_ulong_t)&jmnd_gem_rgmii_config},
+	{
+	 .id = "JAMC00BA",
+	 .driver_data = (kernel_ulong_t)&jmnd_gem_rmii_config},
+	{
+	 },
+};
+
+MODULE_DEVICE_TABLE(acpi, macb_acpi_ids);
+
+#endif
+
 static const struct macb_config default_gem_config = {
 	.caps = MACB_CAPS_GIGABIT_MODE_AVAILABLE |
 		MACB_CAPS_JUMBO |
@@ -4855,6 +4925,17 @@ static int macb_probe(struct platform_device *pdev)
 			clk_init = macb_config->clk_init;
 			init = macb_config->init;
 		}
+	} else {   /*add gem support acpi */
+		const struct acpi_device_id *match;
+
+		match =
+		    acpi_match_device(pdev->dev.driver->acpi_match_table,
+				      &pdev->dev);
+		if (match && match->driver_data) {
+			macb_config = (struct macb_config *)match->driver_data;
+			clk_init = macb_config->clk_init;
+			init = macb_config->init;
+		}
 	}
 
 	err = clk_init(pdev, &pclk, &hclk, &tx_clk, &rx_clk, &tsu_clk);
@@ -4904,7 +4985,7 @@ static int macb_probe(struct platform_device *pdev)
 		bp->jumbo_max_len = macb_config->jumbo_max_len;
 
 	bp->wol = 0;
-	if (of_get_property(np, "magic-packet", NULL))
+	if (device_property_present(&pdev->dev, "magic-packet"))
 		bp->wol |= MACB_WOL_HAS_MAGIC_PACKET;
 	device_set_wakeup_capable(&pdev->dev, bp->wol & MACB_WOL_HAS_MAGIC_PACKET);
 
@@ -4952,15 +5033,13 @@ static int macb_probe(struct platform_device *pdev)
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
+	/*add gem support acpi */
+	interface = device_get_phy_mode(&pdev->dev);
+	if (interface < 0)
+		/* not found in DT and ACPI , MII by default */
 		bp->phy_interface = PHY_INTERFACE_MODE_MII;
 	else
 		bp->phy_interface = interface;
@@ -5255,6 +5334,9 @@ static struct platform_driver macb_driver = {
 	.driver		= {
 		.name		= "macb",
 		.of_match_table	= of_match_ptr(macb_dt_ids),
+#ifdef CONFIG_ACPI
+		.acpi_match_table = ACPI_PTR(macb_acpi_ids),
+#endif
 		.pm	= &macb_pm_ops,
 	},
 };
-- 
2.17.1

