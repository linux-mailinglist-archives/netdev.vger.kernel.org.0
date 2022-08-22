Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 361E259B764
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 04:02:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232276AbiHVCAG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Aug 2022 22:00:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232272AbiHVCAA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Aug 2022 22:00:00 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2059.outbound.protection.outlook.com [40.107.22.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1656F21824;
        Sun, 21 Aug 2022 18:59:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=APhkRYxaBZOwTxgFMNbolr4n3DVX6EraxkjMQ7X7gAOjfBhBStpiUIdDsAdnKl2trMG4pwmQrOIZR3Nd10i+1CaqGPy1vAmNjuP7EDQk4nbvJduj8oGCw5TOly+0KIRluCG3yPT99uNsPLqggRaqJ+M5vLZovlPfdzm/8KiDTXqxNUj/Shjsa6fZxtRAOAlJLGYcGTgFqPo1uPy7ET45/7oSZhmiqgAKGFMB0MzypRsut7JHetOVbkCt4GgL0KSI8vSuY4gsFHJ5uk8TuQ3WakfGCNRs/wwOMcwfxOoaEz9sX89xBC1706+5Ww4jtO1SXhDY4mo3fJGmQX3a7qsyig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ESz4/42WVzu7Q5x0Wg2X89Wf44zaf8ndVEbb8/saNxM=;
 b=A0XpPMrkEpnvsDJ9bsaEAsw7DPIgkcvPTqk+0DRBY1cqbRqF7xYyYvQHiD1nAnYYdyX7PZk/USgJGXgi4G0TPlWZAEFhY9PbdweAKeBDyhPIEzk0qJCVoaJ/FScrF7SupKRCgnPhAfWcXnEvLV4d8FoKKNjw7GMCTCGvGi657WPomrRfLJQBPTWzAQR1Rx9otS20MFgU5UH0VYuoTjsHmtK8TImEpAP8oICpkDnK42ciCMbTkrQrHK6XZVHZEJcgZH9rKh08vNPL0kTHveQVogKmJiUfp4T/2Yy2x5g9ja80Tjdk9TCzuQa8Jejhl37ZSJbrZ8Fw3rRTxo2aOYqRvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ESz4/42WVzu7Q5x0Wg2X89Wf44zaf8ndVEbb8/saNxM=;
 b=WgOWX8hVHCETL4AQ3JGFNNZlU83npPcpfijHzQsHEo97P7uhYG/GKI1+GWX7Ra1RWcRxK73VtVOT6QrtG8Bcy8t7FSuetR3LaPzPI9D/9hVRVri7vQrDGEE25xzECyPP2azutj/nLWwMIg0Jb04SeGt3gpmzWmd4J5NMiJLisNA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from DB9PR04MB8106.eurprd04.prod.outlook.com (2603:10a6:10:24b::13)
 by AM6PR0402MB3335.eurprd04.prod.outlook.com (2603:10a6:209:a::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.11; Mon, 22 Aug
 2022 01:59:55 +0000
Received: from DB9PR04MB8106.eurprd04.prod.outlook.com
 ([fe80::a569:c84a:d972:38ce]) by DB9PR04MB8106.eurprd04.prod.outlook.com
 ([fe80::a569:c84a:d972:38ce%9]) with mapi id 15.20.5546.022; Mon, 22 Aug 2022
 01:59:55 +0000
From:   wei.fang@nxp.com
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, andrew@lunn.ch,
        f.fainelli@gmail.com, hkallweit1@gmail.com, linux@armlinux.org.uk
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH V2 net-next 2/2] net: phy: tja11xx: add interface mode and RMII REF_CLK support
Date:   Mon, 22 Aug 2022 09:59:49 +0800
Message-Id: <20220822015949.1569969-3-wei.fang@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220822015949.1569969-1-wei.fang@nxp.com>
References: <20220822015949.1569969-1-wei.fang@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2P153CA0029.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c7::16)
 To DB9PR04MB8106.eurprd04.prod.outlook.com (2603:10a6:10:24b::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ad1e471c-5bad-4923-542d-08da83e2029d
X-MS-TrafficTypeDiagnostic: AM6PR0402MB3335:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NAFGjsaac72NI51FCHiSLITXu2/hj8thJtoMp4W9WzXE7oPpqDqigDuFKU4UwrH5iWx0gQurtakzNgt7oFuIReJuwDpqB++Z0LwwfJpRhk6AFunYBwwG8Xw2VBp1a5bjVQHtXt4SN/3Sw3kRGLlieaHZTRN51eqWZoaHtVkstzvEKUeYtuIFJ9secRZLq90FDifnCsFTaWbEXpbU6MIHVyfH5f4AnId/t1aouRuOpTb2IAU5a8c9hrGtnjBA/NzoRxmTeCI4mnrN5TnqM8qVoCSXitkyLo0suY4YLHfCM+QHTwHsMxJ1/fcJ7/GwRls61SuNf2Rd7vUaaydjTd5yeLS9mhZrOq6Lb/lSy5vHtkbUdIMUifumbquv1tLyTlc2C6T8jwJvw0EZUyL4zYJ/XJYZZNc1sE9OHig+1xX8HHT5xRzR+2sSgJPNRZfj28fSf5cyx/teL7zJdHYyx2XsmO4ZD5HLLeFEKy0tt42fhc3jaA1K0HBhNsY2RO8e4UDhzpeIC9VGQ3xtnecYxMStPtiBEQjMCYu1bUKCvBufBLMoMnFFMP8pCUFn9XbNhmz9/CRgRAnCsoFi8SF0DpBCoc9V1Nq7e7Bvh/AZaTWZWoMIT8XazR2Efy7Jq8By4ngzOBh5YyzNlu224jIWOjrqyP74Ul/twsF3HMADQio7jawzxQtJS1W7NQN2A81hBJTTQH50mlesIFja6xqYg36y0YaNstnNIlb7kX/y8LiS/bC5lPjSBemI8qyou53WvHh+hUWo2XNApi4pvm05d42tu6eaOxhdTMPBuiOaUnGHlyE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR04MB8106.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(39860400002)(346002)(396003)(366004)(136003)(66476007)(66946007)(38350700002)(4326008)(86362001)(8676002)(66556008)(921005)(8936002)(36756003)(38100700002)(6512007)(6506007)(6486002)(1076003)(52116002)(316002)(478600001)(2616005)(2906002)(83380400001)(41300700001)(5660300002)(9686003)(6666004)(26005)(7416002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vq6juoeDQaAdsNnBQLwV+e+ilbuZORlXbXunEOvvfxCL8Gou8se3zTksYmPp?=
 =?us-ascii?Q?77ITMZ1ri7AemZ/waNgZDRLNMdaylPytzjB5l5Q2TM4msU630/1xzVOgig9o?=
 =?us-ascii?Q?EwGKhgiolyOcwclag6QA31SHQ5bQZe/pykM7feb3Gi8gMzhPUMF284ECyqEp?=
 =?us-ascii?Q?u9RSgvDm4pKss72BwnIcBuVQ27wo7VWBk6nTSL5jn866uL/ZE3TwWz+gMEAx?=
 =?us-ascii?Q?XxFl6oce///cOngUFW5TwVm6on1ta3J7rzlWpnarv1AZdss2c4SQOOsnV/iF?=
 =?us-ascii?Q?KftJqaYAtq9oBv8UUWhktwtw7LkAGvSnB33+Z+Q2Aber3N0B7JVsPdxO3VGl?=
 =?us-ascii?Q?/IBBxTz55iAdCoXnDI7b4+zK2NJkGt/kYbMhze8fxwgxplehAfXV6dm/GZ7S?=
 =?us-ascii?Q?jvyTy6jc2x/2k4XWEqaHZxJQMpeD0KVDCJDhOSpc6JVi0x6/r7hr71B2slKt?=
 =?us-ascii?Q?JEwkNZpm8cr5rRbRIMoNkWlu03mzfFRkKxWVNd4tOswXz55UVLwSdzCTH6QO?=
 =?us-ascii?Q?XoIyV77Od0beyYuNiOwp/M/w9J6uQyBSlu1yytj83qjH7JFRrAhR4/25ix9K?=
 =?us-ascii?Q?i/Vn5rc+JtRE2yqKl2Rz+oSn3Yid737QB7Kkuom85r0/A+SHtCDMqHpjVsPd?=
 =?us-ascii?Q?Ka+nJhxHGTJmy1yQ3vZY5AqWTINRNf2EbHHqFoOCpR84Yzige9Fvuj/P3toB?=
 =?us-ascii?Q?vo3KvqS8ObM36PArdNnvp1907pYNeRMQP22EeRMCtefbE520iI5nsLGEgMIf?=
 =?us-ascii?Q?UUf/mbbbBm+DqtDkVjg/BU/LqYYlI7st1Oh7Jinx/UlBWLN+q3NKDjWDi/HM?=
 =?us-ascii?Q?Z5+CNWf8ASEdjyMiWsAEIt/UevBD8puG5EZuQ0pP5RaMwgkBCIQog8tED/CY?=
 =?us-ascii?Q?Bf0vCr20AXAbTbcquLVq6OODz2edw/ptVWGmUWobcae5LeMbpYHAG/2+UZCi?=
 =?us-ascii?Q?o0DnySKfb14p1BQDAm6pkSo9kRmdZsQAdGZQmxVLoC1jJK1oULLKIhGQU2ow?=
 =?us-ascii?Q?c+QnORt3IBLePuuJxxdgGqwiBcFhwXmhqjSCttMl7zhhmSR+0ZPt5QAvWN8F?=
 =?us-ascii?Q?ORTtycOywYQ88arJqo+1ZfsyQgh1p5US/eDPXENE70qHMbRwQ7bUxAxkh9VJ?=
 =?us-ascii?Q?+1U9WxkTl57F3bSBt6L1wNu7EWZnCPnE4Ko6uvFlllIZce+4K7BgWdApG3r5?=
 =?us-ascii?Q?4+lkffOjmatmCjg4j1GQugHx+Xn1hs7uFAUzdjUfP+cYHRLuO64gaOmWUo8v?=
 =?us-ascii?Q?V4eBqnM82bgTzSYCM/vE1q6BIY9Fv/uRlIjMyOnROnM84p8HWcxjioTPj2B6?=
 =?us-ascii?Q?AwM50BqeTGt148FSTfYOOsFpbc/JBN0BcR6jQPXWdXzw1CdEv72DbI+n/+dU?=
 =?us-ascii?Q?dminhSD/hE6viXF0a02Wrr0QrLdb1tU6W4wjoyslDhIvP5Htlk9EBpoSdWnn?=
 =?us-ascii?Q?2muJro24vWNNvPMMiH5KnaPGY0OpZQ5D/bMjKpUuxCc9Z7vExas7++3ugIzM?=
 =?us-ascii?Q?rBizMX3AcpgF41hZMkOOhfgirkybPzmAYpjhEp6rjOnwPVeZtaQaRv9t4Z32?=
 =?us-ascii?Q?0oj9a1Sz57ypRHCgwH0z/mkQ/t+mRCV6c3q8rMea?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ad1e471c-5bad-4923-542d-08da83e2029d
X-MS-Exchange-CrossTenant-AuthSource: DB9PR04MB8106.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Aug 2022 01:59:55.8402
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: g/4ctXldwafMtTQG0/splk9TVhecOpbMUnHWNrwERAdXGpw/m9sl2nV/6zvuO10Iiy6h53qTRlIOY/krZ98gdw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR0402MB3335
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wei Fang <wei.fang@nxp.com>

Add below features support for both TJA1100 and TJA1101 cards:
- Add MII and RMII mode support.
- Add REF_CLK input/output support for RMII mode.

Signed-off-by: Wei Fang <wei.fang@nxp.com>
---
V2 change:
1. Correct the property name to "nxp,rmii-refclk-in".
2. Modify the "quirks" of struct tja11xx_priv to "flags".
---
 drivers/net/phy/nxp-tja11xx.c | 83 ++++++++++++++++++++++++++++++++---
 1 file changed, 78 insertions(+), 5 deletions(-)

diff --git a/drivers/net/phy/nxp-tja11xx.c b/drivers/net/phy/nxp-tja11xx.c
index 2a8195c50d14..ec91e671f8aa 100644
--- a/drivers/net/phy/nxp-tja11xx.c
+++ b/drivers/net/phy/nxp-tja11xx.c
@@ -10,6 +10,7 @@
 #include <linux/mdio.h>
 #include <linux/mii.h>
 #include <linux/module.h>
+#include <linux/of.h>
 #include <linux/phy.h>
 #include <linux/hwmon.h>
 #include <linux/bitfield.h>
@@ -34,6 +35,11 @@
 #define MII_CFG1			18
 #define MII_CFG1_MASTER_SLAVE		BIT(15)
 #define MII_CFG1_AUTO_OP		BIT(14)
+#define MII_CFG1_INTERFACE_MODE_MASK	GENMASK(9, 8)
+#define MII_CFG1_MII_MODE				(0x0 << 8)
+#define MII_CFG1_RMII_MODE_REFCLK_IN	BIT(8)
+#define MII_CFG1_RMII_MODE_REFCLK_OUT	BIT(9)
+#define MII_CFG1_REVMII_MODE			GENMASK(9, 8)
 #define MII_CFG1_SLEEP_CONFIRM		BIT(6)
 #define MII_CFG1_LED_MODE_MASK		GENMASK(5, 4)
 #define MII_CFG1_LED_MODE_LINKUP	0
@@ -72,11 +78,15 @@
 #define MII_COMMCFG			27
 #define MII_COMMCFG_AUTO_OP		BIT(15)
 
+/* Configure REF_CLK as input in RMII mode */
+#define TJA110X_RMII_MODE_REFCLK_IN       BIT(0)
+
 struct tja11xx_priv {
 	char		*hwmon_name;
 	struct device	*hwmon_dev;
 	struct phy_device *phydev;
 	struct work_struct phy_register_work;
+	u32 flags;
 };
 
 struct tja11xx_phy_stats {
@@ -251,8 +261,34 @@ static int tja11xx_config_aneg(struct phy_device *phydev)
 	return __genphy_config_aneg(phydev, changed);
 }
 
+static int tja11xx_get_interface_mode(struct phy_device *phydev)
+{
+	struct tja11xx_priv *priv = phydev->priv;
+	int mii_mode;
+
+	switch (phydev->interface) {
+	case PHY_INTERFACE_MODE_MII:
+		mii_mode = MII_CFG1_MII_MODE;
+		break;
+	case PHY_INTERFACE_MODE_REVMII:
+		mii_mode = MII_CFG1_REVMII_MODE;
+		break;
+	case PHY_INTERFACE_MODE_RMII:
+		if (priv->flags & TJA110X_RMII_MODE_REFCLK_IN)
+			mii_mode = MII_CFG1_RMII_MODE_REFCLK_IN;
+		else
+			mii_mode = MII_CFG1_RMII_MODE_REFCLK_OUT;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return mii_mode;
+}
+
 static int tja11xx_config_init(struct phy_device *phydev)
 {
+	u16 reg_mask, reg_val;
 	int ret;
 
 	ret = tja11xx_enable_reg_write(phydev);
@@ -265,15 +301,32 @@ static int tja11xx_config_init(struct phy_device *phydev)
 
 	switch (phydev->phy_id & PHY_ID_MASK) {
 	case PHY_ID_TJA1100:
-		ret = phy_modify(phydev, MII_CFG1,
-				 MII_CFG1_AUTO_OP | MII_CFG1_LED_MODE_MASK |
-				 MII_CFG1_LED_ENABLE,
-				 MII_CFG1_AUTO_OP | MII_CFG1_LED_MODE_LINKUP |
-				 MII_CFG1_LED_ENABLE);
+		reg_mask = MII_CFG1_AUTO_OP | MII_CFG1_LED_MODE_MASK |
+			   MII_CFG1_LED_ENABLE;
+		reg_val = MII_CFG1_AUTO_OP | MII_CFG1_LED_MODE_LINKUP |
+			  MII_CFG1_LED_ENABLE;
+
+		reg_mask |= MII_CFG1_INTERFACE_MODE_MASK;
+		ret = tja11xx_get_interface_mode(phydev);
+		if (ret < 0)
+			return ret;
+
+		reg_val |= (ret & 0xffff);
+		ret = phy_modify(phydev, MII_CFG1, reg_mask, reg_val);
 		if (ret)
 			return ret;
 		break;
 	case PHY_ID_TJA1101:
+		reg_mask = MII_CFG1_INTERFACE_MODE_MASK;
+		ret = tja11xx_get_interface_mode(phydev);
+		if (ret < 0)
+			return ret;
+
+		reg_val = ret & 0xffff;
+		ret = phy_modify(phydev, MII_CFG1, reg_mask, reg_val);
+		if (ret)
+			return ret;
+		fallthrough;
 	case PHY_ID_TJA1102:
 		ret = phy_set_bits(phydev, MII_COMMCFG, MII_COMMCFG_AUTO_OP);
 		if (ret)
@@ -458,16 +511,36 @@ static int tja11xx_hwmon_register(struct phy_device *phydev,
 	return PTR_ERR_OR_ZERO(priv->hwmon_dev);
 }
 
+static int tja11xx_parse_dt(struct phy_device *phydev)
+{
+	struct device_node *node = phydev->mdio.dev.of_node;
+	struct tja11xx_priv *priv = phydev->priv;
+
+	if (!IS_ENABLED(CONFIG_OF_MDIO))
+		return 0;
+
+	if (of_property_read_bool(node, "nxp,rmii-refclk-in"))
+		priv->flags |= TJA110X_RMII_MODE_REFCLK_IN;
+
+	return 0;
+}
+
 static int tja11xx_probe(struct phy_device *phydev)
 {
 	struct device *dev = &phydev->mdio.dev;
 	struct tja11xx_priv *priv;
+	int ret;
 
 	priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
 	if (!priv)
 		return -ENOMEM;
 
 	priv->phydev = phydev;
+	phydev->priv = priv;
+
+	ret = tja11xx_parse_dt(phydev);
+	if (ret)
+		return ret;
 
 	return tja11xx_hwmon_register(phydev, priv);
 }
-- 
2.25.1

