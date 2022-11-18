Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 492DE62E9F6
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 01:02:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234992AbiKRACI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 19:02:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbiKRACG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 19:02:06 -0500
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2046.outbound.protection.outlook.com [40.107.21.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0461170A3D
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 16:02:06 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vet931L4Ma/ToYkH+OFeqzaHYojHGyNtd8FtnYdwZV9XHxCIBW08cA8lkFJYbYDzLW1sjCb23Ld3bcdv/cCDh1B12ctYsOGPF8kHZhK4qHI97oMPKZjTXYx/DEfXiGik6E/zwsZXAbS4c8QjxJ/KFGCynpVi1PecqkAZvLVUDuy32TfdApKtl6gzWYmGRCq+hf4/FMr2mlcd4DM+eKw0Y7qq8Wh/2hGK8PqxeQ8PUQLN3Wpf8sx5tjzCIKtYzHpBuHlnu9l9LzpHzzC32yfuy6oUt3FNIubST0LvI6QrRQu2gvL9YK8YmXHhRKOOxl5fXO5XWe7/YIbBg2DCGk+Brg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2cBipMJyYxBcqsePrv461rVjzPpBbO+BXezzzn80OJQ=;
 b=nBebdc0K7hZr77DZ7OH3LMK8o/t5GxsVugJk5vgjjNzMGNwcdNB5LfavjvIkBDzH5qNDvSj8DOUcfqGCxIN2ve4BuPi5mu36c68FBCC+OyhBvixnSMft3J9rzcuGfXRwM7fID+xpV8n81USsgKQILvEfJc8BpezTnu+Q8qxPhVx3fCEgTWC2tdvKCfM+liQRaHOXGTSn+QEvmuHVy43X6wiEqGMK4nGibJ298WH67nU5QSrAHiZgbp03FoHMXFpwaswm4C7ClTxOZHleqVWy2qt32MaUk8CMjNOD8OSgaxx6aG9p8LTRNl4xUo/AyJolW+ityTeUYvtcBGEhEjbJwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2cBipMJyYxBcqsePrv461rVjzPpBbO+BXezzzn80OJQ=;
 b=UrX6NP9DxG8JdC6ohRxcAY+AEkM0KRxckWe6zEpz2lIZR6uEIqouK5dx91CaiFwQzkb9ils9AGswfrNmSZC6wFRJdKs+tlJzgdDvIVMYx4j40sPJPY71gUTW862X5hw0HgUbEbaEPPJKKnb570wes/Itu0POUBaHaSFuM2L+F7s=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PAXPR04MB8542.eurprd04.prod.outlook.com (2603:10a6:102:215::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.13; Fri, 18 Nov
 2022 00:02:04 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b%7]) with mapi id 15.20.5813.018; Fri, 18 Nov 2022
 00:02:04 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        UNGLinuxDriver@microchip.com,
        bcm-kernel-feedback-list@broadcom.com,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Camelia Groza <camelia.groza@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Sean Anderson <sean.anderson@seco.com>,
        Antoine Tenart <atenart@kernel.org>,
        Michael Walle <michael@walle.cc>,
        Raag Jadav <raagjadav@gmail.com>,
        Siddharth Vadapalli <s-vadapalli@ti.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Colin Foster <colin.foster@in-advantage.com>,
        Marek Behun <marek.behun@nic.cz>
Subject: [PATCH v4 net-next 1/8] net: phylink: let phylink_sfp_config_phy() determine the MLO_AN_* mode to use
Date:   Fri, 18 Nov 2022 02:01:17 +0200
Message-Id: <20221118000124.2754581-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221118000124.2754581-1-vladimir.oltean@nxp.com>
References: <20221118000124.2754581-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BEXP281CA0006.DEUP281.PROD.OUTLOOK.COM (2603:10a6:b10::16)
 To VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|PAXPR04MB8542:EE_
X-MS-Office365-Filtering-Correlation-Id: 24f54b68-7d32-4b90-bfed-08dac8f81fe7
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QWu11a390RxihxSQkAmmMYcFpbq1TRAp/DXsEO+FjDWUk9VS24s7t0wnCawU6ADuDrJTv4YpZqu+Ro7jIYQKGLHNOCQ2A7NZkU4fgbPIPuwzLBSE2jq8aVqPyJsn82T9STvXNRmi+otTXRXLFvB2Y3ZR8qcpqF/YYucpiy6iJ//XYPYnd2sjqpqDGt3ptFkUuwzMA8oO+Lz8RF/7X2MBP7vkimEvmfodfWBGz6gkIb0E8pZPiqTim9d8VUBHWr8J727bNp7OFBM2eGaTxqmFHsRp0XQm/mYGxwdMzdwU0Y7YvMSUhJB055XjZGGvOaqu8mSJK6t/CTIdubuQ2SKJC8yS24ZfXvNkqkHS/iM3p7gr/Om/SFdCSpzeJIddpzkPvuFN4ImIIW8NtXlUhmFObc+zR13Yw/s1l+jFbbumSWDsxfWnjUeBpHdZxcpK9zG7MlDHHgUy96DV/0BI7rjTLF6u9pflFQ/mSRPQYA+uWRzUuFNxy2ePXAno41D+j7MmK0UV2/8QNdq8gCFjdg+a3th4VLZfxjCeI6MLKvkj4jGnTkapB9eLy+uI1ITIBTwvF3jewLnjijm9VvrDVq04snAP0KjB1tBSX10vYeXYhhruY/XGOwaws9jR8iWrlECrUtfpCHeOs7rKEUSbESdLoQLBkVaBejmJVNR+qGBhwRRGgq/5e5uhAKGdZiaXnM8j
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(346002)(396003)(366004)(39860400002)(376002)(451199015)(478600001)(26005)(41300700001)(6506007)(6666004)(36756003)(8676002)(52116002)(6486002)(4326008)(38100700002)(44832011)(7416002)(8936002)(2616005)(66946007)(66556008)(38350700002)(6512007)(66476007)(186003)(316002)(1076003)(2906002)(54906003)(6916009)(86362001)(5660300002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FRxZ9zVXsl+WRpYID7fXEarYKlsERZMOM/oLBZSx58wqbBqrkA5zZMlM9WHe?=
 =?us-ascii?Q?rJe+54a3vak0paqSgHnyJQp4sfCNb8uqZ2QuiYodtY5XbhUhxd5cfmcVcOlk?=
 =?us-ascii?Q?VSS4GmKFu8lRnC8ZhNLO9pdQoWx0YDIutaxkbGYv+9HlbilmWQsQ3FXKZebK?=
 =?us-ascii?Q?PNFIWtaXrloA8KTdsl3I6b2nUaWFamEC272kB82VB0Jy2GVKRMfBFFCGNOmE?=
 =?us-ascii?Q?6zwyx9rOHB8uxZ2M8bvAXKxHTqf3hJ6LWN10aPLVfZhZ9I3mcqhQ4Dmj+YQz?=
 =?us-ascii?Q?cJyqv0iB2HbK9Kcip8uc3K03YI2gj4NEEzfjxgyry9kPtgh0JhisZs8vpCfh?=
 =?us-ascii?Q?SlzdFVd3akCyj067XOPhcYBLLcTFp005qySbwN/5s73Uqf1Q9I3RsG6jKZme?=
 =?us-ascii?Q?x6yl9aDmdsaoX0X+DwOGu99oDY4VT0qwFsaKIa/swg45RL3XY2Yu3m1QDc2P?=
 =?us-ascii?Q?jEHG2X4B8LHlSZ8lDpUYDk9++JEaz0unt+gakhkgoRhc9Z5dJU0bq3H+Tt4O?=
 =?us-ascii?Q?TwA6+odQLttOt00CZ7Vmz4ZdNVzMRY2agTdz1b9UOZPnLdXD4oT/3xjb3+Xc?=
 =?us-ascii?Q?ErUoDroobY74oxYi/b4bxgfpZKAP1dMaUb8AIMd4fRLnCoVoIMTspSalMWzD?=
 =?us-ascii?Q?na59OqhkcKYfd+Ch6VRTPYHCO7FMMU2grugvq4GZhK1OFrI9dPwbMD8JaLYD?=
 =?us-ascii?Q?lHcTnR0qeX6hT7Zxq4YRtpnROniBt50s2iuCKJnSBaEHS5mimRtrvoreHl1e?=
 =?us-ascii?Q?dfI5kHtI9xsO2xeq26czWSZqtLN+VE38+Ada2X4ehFpbOP1WGNED79Lc6JyW?=
 =?us-ascii?Q?ULOivYa5D0UWI+FMfvLuoK+i1KckIVNjqp28aeZU8bJAbkWLGIxjKfE/CZdn?=
 =?us-ascii?Q?Ni/iVpDCz4BkusomjwRNhEqyj/WMjMI2oVJPskk7Tj4MLZ9s9HNiXhh45j8H?=
 =?us-ascii?Q?cs5XlPilFQzH4rJXz0SXnaocVwG7dzAxLtRl/CxRIAhiqekNVp6AkxHy/Agx?=
 =?us-ascii?Q?aY5X9SAzX04j/0dwuc8PKc0CYbEwJah4hcFg/5zbCVrZp490RPe+N3xlpalf?=
 =?us-ascii?Q?bcPQNKBVtZno06iAO954HuXLs+iwueYb55RNYNjefzHpuIqhzHnkKvYXJWJF?=
 =?us-ascii?Q?BKIXe6h8CzboDSM/d5UUAB29OmTkFhY1lmvO5fonGTaVa5mlIfhmIQi9Wf3/?=
 =?us-ascii?Q?Dz9LL9PqF7j6P1lluVJeFwqVrgxgpYCbXyIDrIYVUBpaTElxq7LgKWfl/ZKx?=
 =?us-ascii?Q?n9xJZSHVkGm1FxEYAFTGMVK+w5EpcuEsF9IeDz0zAalbpckUGFRbZgZJWHpo?=
 =?us-ascii?Q?Idc3IleqXA9P3ypt1ENUTkfL8WoI9PbWGWF/T2ezwwag1z1dlagz7VIrMp4Y?=
 =?us-ascii?Q?FKTqc+BWXvKNVdR/7UpglbPvy/CPADGjPj+BolXt7CUfv4Q1d5GF33EwTMYT?=
 =?us-ascii?Q?01uhJIhrS2EdPufVVEloW6LiQ2ZPvFhxRJRQYYxVScen1aOAhgylxGvm3BzZ?=
 =?us-ascii?Q?C4PId42a86fkk/oLHLqMf66uoBMYmRlk394VB2abzzObubI2XZEKJiE30OKL?=
 =?us-ascii?Q?qy0HNsdaLVv8AlqAqo4Om9DvCy8FB6GkPFhWieJ3oCdj5YKlTE8Ty9UTLhhy?=
 =?us-ascii?Q?cA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 24f54b68-7d32-4b90-bfed-08dac8f81fe7
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2022 00:02:04.1416
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2Ca8m3ydrhKBpLCZQtzew9byjxmAnXvfa9kLHCitRvpO6PnG7LUfzInglwJIKYkjK+MUpzM2j9K6vpj3B4WQFQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8542
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For now, the "mode" is assumed to be MLO_AN_INBAND unless there is a PHY,
and that PHY has broken inband capabilities. So, since phylink_sfp_config()
already has the PHY pointer, we can drop the "mode" argument and deduce
it locally.

We'll want to make the in-band capability determination also based on
the interface mode in use. Move the phy_no_inband() check inside
phylink_sfp_config(), right after the PHY mode was determined by
sfp_select_interface().

To avoid a forward-declaration, this change also moves
phylink_phy_no_inband() above phylink_sfp_config_phy().

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v3->v4:
phylink_sfp_config() got split into phylink_sfp_config_phy() and
phylink_sfp_config_optical(), we now move the code to _phy()

 drivers/net/phy/phylink.c | 35 +++++++++++++++++------------------
 1 file changed, 17 insertions(+), 18 deletions(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 25feab1802ee..9e4b2dfc98d8 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -2811,6 +2811,15 @@ int phylink_speed_up(struct phylink *pl)
 }
 EXPORT_SYMBOL_GPL(phylink_speed_up);
 
+/* The Broadcom BCM84881 in the Methode DM7052 is unable to provide a SGMII
+ * or 802.3z control word, so inband will not work.
+ */
+static bool phylink_phy_no_inband(struct phy_device *phy)
+{
+	return phy->is_c45 &&
+		(phy->c45_ids.device_ids[1] & 0xfffffff0) == 0xae025150;
+}
+
 static void phylink_sfp_attach(void *upstream, struct sfp_bus *bus)
 {
 	struct phylink *pl = upstream;
@@ -2891,13 +2900,13 @@ static void phylink_sfp_set_config(struct phylink *pl, u8 mode,
 		phylink_mac_initial_config(pl, false);
 }
 
-static int phylink_sfp_config_phy(struct phylink *pl, u8 mode,
-				  struct phy_device *phy)
+static int phylink_sfp_config_phy(struct phylink *pl, struct phy_device *phy)
 {
 	__ETHTOOL_DECLARE_LINK_MODE_MASK(support1);
 	__ETHTOOL_DECLARE_LINK_MODE_MASK(support);
 	struct phylink_link_state config;
 	phy_interface_t iface;
+	u8 mode;
 	int ret;
 
 	linkmode_copy(support, phy->supported);
@@ -2927,6 +2936,11 @@ static int phylink_sfp_config_phy(struct phylink *pl, u8 mode,
 		return -EINVAL;
 	}
 
+	if (phylink_phy_no_inband(phy))
+		mode = MLO_AN_PHY;
+	else
+		mode = MLO_AN_INBAND;
+
 	config.interface = iface;
 	linkmode_copy(support1, support);
 	ret = phylink_validate(pl, support1, &config);
@@ -3082,20 +3096,10 @@ static void phylink_sfp_link_up(void *upstream)
 	phylink_enable_and_run_resolve(pl, PHYLINK_DISABLE_LINK);
 }
 
-/* The Broadcom BCM84881 in the Methode DM7052 is unable to provide a SGMII
- * or 802.3z control word, so inband will not work.
- */
-static bool phylink_phy_no_inband(struct phy_device *phy)
-{
-	return phy->is_c45 &&
-		(phy->c45_ids.device_ids[1] & 0xfffffff0) == 0xae025150;
-}
-
 static int phylink_sfp_connect_phy(void *upstream, struct phy_device *phy)
 {
 	struct phylink *pl = upstream;
 	phy_interface_t interface;
-	u8 mode;
 	int ret;
 
 	/*
@@ -3107,17 +3111,12 @@ static int phylink_sfp_connect_phy(void *upstream, struct phy_device *phy)
 	 */
 	phy_support_asym_pause(phy);
 
-	if (phylink_phy_no_inband(phy))
-		mode = MLO_AN_PHY;
-	else
-		mode = MLO_AN_INBAND;
-
 	/* Set the PHY's host supported interfaces */
 	phy_interface_and(phy->host_interfaces, phylink_sfp_interfaces,
 			  pl->config->supported_interfaces);
 
 	/* Do the initial configuration */
-	ret = phylink_sfp_config_phy(pl, mode, phy);
+	ret = phylink_sfp_config_phy(pl, phy);
 	if (ret < 0)
 		return ret;
 
-- 
2.34.1

