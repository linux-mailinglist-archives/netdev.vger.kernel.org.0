Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 615344D6A5C
	for <lists+netdev@lfdr.de>; Sat, 12 Mar 2022 00:26:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229723AbiCKWsy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 17:48:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229663AbiCKWsN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 17:48:13 -0500
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2085.outbound.protection.outlook.com [40.107.20.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4881C2B8530;
        Fri, 11 Mar 2022 14:23:03 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NSG+bYBHWNnx+yer8p90jQiD2J6F4uQ9sYt5KWLVgbkaLBzGuteuS+TETUA1ITPlVYW+cQeOZuMUqjdny7QKQWzFUp0QiWaZBctEAyIn5yZ+6IP8v/tRzdvgvzWDCB/jw7ihZI+4s2T5kHFwVKbglH+xupzSqAPzB4HT/45G2BZo9Zr3Edj/e6+9sOzawvvwn4A942EPKy8N72+94j4AsHMZdiKEFMhTm5WUpIADxQQFZbfTMBrBGS82t2xxLqq9MS87/Ib0G/mTb/ootknwxh+IQuL7XvXozdynhkDRV40nmo7B15adk9VZWUh1l+InC5ORHmTxceS92m1lw3P6PA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wd04sagb7npPiXkkl/QAeFxKefUOhrERoJm24LyJzbY=;
 b=df+xUbpUALv9kwYyVztrf6wBddsdcKRyWky/hzKhvTBuNdzOckPvYgHJy+JZAlo2WviiSH3NiGMPc6rwAePAtnkTuOMjNViq6zJ3bkn+zB94oKoc/qT1RGmKWqvoDZ7xaJcWzBx2yq02gzw57/9CJ5i0qh5RpPnARf09DBDKazhtDyTCwi8bCgdX6X7V8U17hTu7So30ydk5YDATSrNLZu+j+H1S2O+W8JyqOSOU7YJAWwK2dEbxh7efvfwDZHf4TzCeG3/jqui+3iSxx51zSIOhidiMSfJENs6lU/gHt+3pS1NKa3oQiSjApKCvUJsHYBV1PiMRRRGv7FWTzy9PPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wd04sagb7npPiXkkl/QAeFxKefUOhrERoJm24LyJzbY=;
 b=mhosMS1kRhUi8b+2l+pZ9ME/Mxn/FEEp3ov6KbTY2wB072WvY9d+9yNbhizEZ1fO+7in2z7cFxswnmJafn8JQvNP4UkeAag01e1JfnxhjOsLwU8KhaxDj4GSEAcaxYOT77eWzF5rUYqkdHdlWACUk8Yk263SRdenx6k/l4XbQoE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM9PR04MB8555.eurprd04.prod.outlook.com (2603:10a6:20b:436::16)
 by DB7PR04MB4713.eurprd04.prod.outlook.com (2603:10a6:10:17::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.17; Fri, 11 Mar
 2022 21:23:38 +0000
Received: from AM9PR04MB8555.eurprd04.prod.outlook.com
 ([fe80::c58c:4cac:5bf9:5579]) by AM9PR04MB8555.eurprd04.prod.outlook.com
 ([fe80::c58c:4cac:5bf9:5579%8]) with mapi id 15.20.5061.025; Fri, 11 Mar 2022
 21:23:37 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     kishon@ti.com, vkoul@kernel.org, robh+dt@kernel.org,
        leoyang.li@nxp.com, linux-phy@lists.infradead.org,
        devicetree@vger.kernel.org, linux@armlinux.org.uk,
        shawnguo@kernel.org, hongxing.zhu@nxp.com,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next v5 7/8] dpaa2-mac: configure the SerDes phy on a protocol change
Date:   Fri, 11 Mar 2022 23:22:27 +0200
Message-Id: <20220311212228.3918494-8-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220311212228.3918494-1-ioana.ciornei@nxp.com>
References: <20220311212228.3918494-1-ioana.ciornei@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM6P194CA0057.EURP194.PROD.OUTLOOK.COM
 (2603:10a6:209:84::34) To AM9PR04MB8555.eurprd04.prod.outlook.com
 (2603:10a6:20b:436::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f620be31-4047-4938-e8fc-08da03a567f7
X-MS-TrafficTypeDiagnostic: DB7PR04MB4713:EE_
X-Microsoft-Antispam-PRVS: <DB7PR04MB4713232BD8F0E9D1FCA7290AE00C9@DB7PR04MB4713.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1UYFQlRGapyjeuxI+ud4OVS1btbQbT5Gk5tguYoHNRvFkNlLEa+LwKujMVXqaMO2fraIAQ59pvCS2yvtkEyuxBQvkH2QgtlOb6EjTmfLcnqJUQ2NZ8ZmyduRjzQA+X4rQ994pO7GsSOLiPOdFYKdkpd+lC+gV7LNBkxf8uZ32Tr2JJslpEpNBodGjEBIQqmnGQS3DBlgalDv4XeFsbmmQDtmz+nlc13fH0bOuAS18g3w80q+fRJRZrZ1vtySlZMYTgP05PWeNSM3rOpmE/kebBI9hwZJadoP9Pq7NjsZD+xmXdvh4qR5ZQ6ctXyUvZRMGzE6bKvTl7mgp/0MWBJT/p3usWIbMnWaZ1G0luil+/uFLkbM3oYnji8CSa2D88T4rUKUx8CpBKOseKeNEik0ZWzayXdCd8lWj54nhP5OblHP2CHUbuCsO2fHVO7oFs8siOV2SiYHOIlLY9P3Ouj3xMVMKiAn1r3uqHuYRvc8dzWsM1VNnf28sL7zNr6P2ZgR4pz/2z1biAGO0yTwAVB9ND+XBIAfKNqi05flk64WK8pR4rJ7UnASAYeujfK8GzJwt6HqLT6wh+lTLX+rs9qLuZRcsZ29nkYvDFav5z72pW+auRgA37ZiYO6c3Jq5H/wGE0RkE/dR4l5ZUWZ/pSLtHAugDdkqvXt+LnyODxVYctEvvsVe7zxI7RHAR6EGCm1Ts5QvhZ42rKedp++p7UM8hQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8555.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(66476007)(8936002)(7416002)(38350700002)(44832011)(8676002)(6666004)(66556008)(38100700002)(5660300002)(4326008)(66946007)(36756003)(6512007)(6506007)(52116002)(186003)(2906002)(2616005)(26005)(6486002)(86362001)(498600001)(83380400001)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?atYgfkCW0clTxm7dgOd9c8sP4ATD7n9JBKK5nTZNYGebRVdiO7/a5Oa53YSb?=
 =?us-ascii?Q?fQyj1dmtE50tT6XEyhKt7liAU/QWZgdGtmUeKEdZHiWCTFYv5WaG7pDOII4q?=
 =?us-ascii?Q?d54sNru05GrSQBXA5b4jBhajtY6+yCl6W3K89J+CRlKhAB7opatw47f0au1Y?=
 =?us-ascii?Q?OjcltcFAasr6CjXLg4/yJH4+o4tSbeyN3uSH3HLced91NXyCO3YlThgxZk/M?=
 =?us-ascii?Q?CkptAiwnUJHVvwfzD029BceyWxxfZgo2dwJcJsjddFoYKQupF2evlChOv+cY?=
 =?us-ascii?Q?Ky666xAZ+UgfEl3v7CT3YBvQrPcKAJtBAIk2OeKrZ97CrFNXOCyxtuPsdjfs?=
 =?us-ascii?Q?FFduz+Gpq78xtzkxN6tkoLN/acUXDpfGznmp7op/NGUIrY2iXIMkobm7I0Rn?=
 =?us-ascii?Q?LekHDtLVI3yoTrEwLp65mY4kuCZ74Lhd/UCk2UxSU9A2UnJn3QPASl06wbtU?=
 =?us-ascii?Q?lKsoNWJg6I2JD5/HBmIMXzN8arJRFtJGa0EFE35ev685fa6uweGKbPhgyNta?=
 =?us-ascii?Q?Lu5wimUTT6X/Sf5nWYLdX2zc3qGhMg9LZNwnX4gbmU9mBpqZD6fp3Kfx/EMe?=
 =?us-ascii?Q?0iM4RUmTV9f12REjgE6NCxLarzVqWjRvMuhv1zcE/CRwWFCE9yQNo0qCbgzw?=
 =?us-ascii?Q?Mpsod5THRmUhWLbKx4270lWa/cRLvypn9m5WCoxGO9pTJp9AhbmNSBW4Iqqg?=
 =?us-ascii?Q?e3TvrlvasB0VbffIA13X3uiEsi8gQCsjcipb1bFjo4WJm8Efcpy1Q+OI3VwU?=
 =?us-ascii?Q?5mTGQcVaHUuu5fGCjqUj2FlvZ72X5YETMpDu7faHEOfRH2/3404cHx1Ln8Dd?=
 =?us-ascii?Q?xLO5ELVVNx2aGdHxGBedNLUwmAOLo58ktIfKdbUXVNcZEbMcOoCjxQNhNSjB?=
 =?us-ascii?Q?BuqQF7MOIS94Ucz512O8ABzBkbfX6q/JZTYHNkYQvUhOmKCZtAiMTpP7eD4q?=
 =?us-ascii?Q?3+8IhCHNUah8g5H901v6cXgHkQDVUsNc5nMLfABu5iFOa+pI1cLfmfeNesVK?=
 =?us-ascii?Q?pxUDiD8eFJ9qqE/WSjziX8kYiqiy/0cRbmQWYY3f9iUU6rE/ulORMPEJpYI3?=
 =?us-ascii?Q?mEq7In8nI1IToW8eJnw9DMzMmkjc050BGKroBM1okxpKK1eKDXeDx2gL11bj?=
 =?us-ascii?Q?9zrxqKT3lutbcbNVSl7SciGPsZFC8Z6M6DDebLynU547gRI4Gi22LJsPC6DA?=
 =?us-ascii?Q?K4hwBXv4IWu7zY/egcYTR9qXNql/rNhuFFXEec+NYRQnY4NZi4rOAiOSv+XE?=
 =?us-ascii?Q?oEWYy0c5ePcehUENqUA8PfyvYo35G83L3jonbhdvlFDZ2PJFz/fX9Etl/vwR?=
 =?us-ascii?Q?YkVUyataNFTPqKP4E9GTEzDYz3O76+NPSexUk76p7zan2w5vR4B7yJbUFUtf?=
 =?us-ascii?Q?5cnHR+EG1snk7bS0ITIJm61CwuFbE7fOB3dQWSOYiiKBTVQIoOU+3QkNl/90?=
 =?us-ascii?Q?q6ItVyb82B8lmODKSFI6I7X/HA4aWpwwIo7L/p0+W25R4jzuIO1otggj0+of?=
 =?us-ascii?Q?Gm8LBOocscqGBw+e0XPm7Lsc852Yee3B9XdLpq3llnJ/ZqC112mIh2j3fppL?=
 =?us-ascii?Q?4+Erb3NDJJd5JlIhhShhItT2Nr8Yh3mtMw/BN9CWvGJeVbbdiYNpwfCpeJp5?=
 =?us-ascii?Q?NLR6UIOEcXox/BA1g/VsFD0=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f620be31-4047-4938-e8fc-08da03a567f7
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2022 21:23:37.6383
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: R+NX8hzcHaTTvkJQDNqKi8rFy3WAixKx6GLQ9BkRfcac+tqlRIiBNX+J+gBGOrk+C1czZVZhSEnAazoImbNYbw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4713
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch integrates the dpaa2-eth driver with the generic PHY
infrastructure in order to search, find and reconfigure the SerDes lanes
in case of a protocol change.

On the .mac_config() callback, the phy_set_mode_ext() API is called so
that the Lynx 28G SerDes PHY driver can change the lane's configuration.
In the same phylink callback the MC firmware is called so that it
reconfigures the MAC side to run using the new protocol.

The consumer drivers - dpaa2-eth and dpaa2-switch - are updated to call
the dpaa2_mac_start/stop functions newly added which will
power_on/power_off the associated SerDes lane.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
Changes in v2:
	- none
Changes in v3:
	- 7/8: reverse order of dpaa2_mac_start() and phylink_start()
	- 7/8: treat all RGMII variants in dpmac_eth_if_mode
	- 7/8: remove the .mac_prepare callback
	- 7/8: ignore PHY_INTERFACE_MODE_NA in validate
Changes in v4:
	- 7/8: rework the of_phy_get if statement
Changes in v5:
	- none

 .../net/ethernet/freescale/dpaa2/dpaa2-eth.c  |  5 +-
 .../net/ethernet/freescale/dpaa2/dpaa2-mac.c  | 86 +++++++++++++++++++
 .../net/ethernet/freescale/dpaa2/dpaa2-mac.h  |  6 ++
 .../ethernet/freescale/dpaa2/dpaa2-switch.c   |  5 +-
 4 files changed, 100 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index 939fa9db6a2e..4b047255d928 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -2077,8 +2077,10 @@ static int dpaa2_eth_open(struct net_device *net_dev)
 		goto enable_err;
 	}
 
-	if (dpaa2_eth_is_type_phy(priv))
+	if (dpaa2_eth_is_type_phy(priv)) {
+		dpaa2_mac_start(priv->mac);
 		phylink_start(priv->mac->phylink);
+	}
 
 	return 0;
 
@@ -2153,6 +2155,7 @@ static int dpaa2_eth_stop(struct net_device *net_dev)
 
 	if (dpaa2_eth_is_type_phy(priv)) {
 		phylink_stop(priv->mac->phylink);
+		dpaa2_mac_stop(priv->mac);
 	} else {
 		netif_tx_stop_all_queues(net_dev);
 		netif_carrier_off(net_dev);
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
index e6e758eaafea..c48811d3bcd5 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
@@ -3,6 +3,7 @@
 
 #include <linux/acpi.h>
 #include <linux/pcs-lynx.h>
+#include <linux/phy/phy.h>
 #include <linux/property.h>
 
 #include "dpaa2-eth.h"
@@ -60,6 +61,29 @@ static int phy_mode(enum dpmac_eth_if eth_if, phy_interface_t *if_mode)
 	return 0;
 }
 
+static enum dpmac_eth_if dpmac_eth_if_mode(phy_interface_t if_mode)
+{
+	switch (if_mode) {
+	case PHY_INTERFACE_MODE_RGMII:
+	case PHY_INTERFACE_MODE_RGMII_ID:
+	case PHY_INTERFACE_MODE_RGMII_RXID:
+	case PHY_INTERFACE_MODE_RGMII_TXID:
+		return DPMAC_ETH_IF_RGMII;
+	case PHY_INTERFACE_MODE_USXGMII:
+		return DPMAC_ETH_IF_USXGMII;
+	case PHY_INTERFACE_MODE_QSGMII:
+		return DPMAC_ETH_IF_QSGMII;
+	case PHY_INTERFACE_MODE_SGMII:
+		return DPMAC_ETH_IF_SGMII;
+	case PHY_INTERFACE_MODE_10GBASER:
+		return DPMAC_ETH_IF_XFI;
+	case PHY_INTERFACE_MODE_1000BASEX:
+		return DPMAC_ETH_IF_1000BASEX;
+	default:
+		return DPMAC_ETH_IF_MII;
+	}
+}
+
 static struct fwnode_handle *dpaa2_mac_get_node(struct device *dev,
 						u16 dpmac_id)
 {
@@ -147,6 +171,19 @@ static void dpaa2_mac_config(struct phylink_config *config, unsigned int mode,
 	if (err)
 		netdev_err(mac->net_dev, "%s: dpmac_set_link_state() = %d\n",
 			   __func__, err);
+
+	if (!mac->serdes_phy)
+		return;
+
+	/* This happens only if we support changing of protocol at runtime */
+	err = dpmac_set_protocol(mac->mc_io, 0, mac->mc_dev->mc_handle,
+				 dpmac_eth_if_mode(state->interface));
+	if (err)
+		netdev_err(mac->net_dev,  "dpmac_set_protocol() = %d\n", err);
+
+	err = phy_set_mode_ext(mac->serdes_phy, PHY_MODE_ETHERNET, state->interface);
+	if (err)
+		netdev_err(mac->net_dev, "phy_set_mode_ext() = %d\n", err);
 }
 
 static void dpaa2_mac_link_up(struct phylink_config *config,
@@ -259,6 +296,8 @@ static void dpaa2_pcs_destroy(struct dpaa2_mac *mac)
 
 static void dpaa2_mac_set_supported_interfaces(struct dpaa2_mac *mac)
 {
+	int intf, err;
+
 	/* We support the current interface mode, and if we have a PCS
 	 * similar interface modes that do not require the SerDes lane to be
 	 * reconfigured.
@@ -278,12 +317,43 @@ static void dpaa2_mac_set_supported_interfaces(struct dpaa2_mac *mac)
 			break;
 		}
 	}
+
+	if (!mac->serdes_phy)
+		return;
+
+	/* In case we have access to the SerDes phy/lane, then ask the SerDes
+	 * driver what interfaces are supported based on the current PLL
+	 * configuration.
+	 */
+	for (intf = 0; intf < PHY_INTERFACE_MODE_MAX; intf++) {
+		if (intf == PHY_INTERFACE_MODE_NA)
+			continue;
+
+		err = phy_validate(mac->serdes_phy, PHY_MODE_ETHERNET, intf, NULL);
+		if (err)
+			continue;
+
+		__set_bit(intf, mac->phylink_config.supported_interfaces);
+	}
+}
+
+void dpaa2_mac_start(struct dpaa2_mac *mac)
+{
+	if (mac->serdes_phy)
+		phy_power_on(mac->serdes_phy);
+}
+
+void dpaa2_mac_stop(struct dpaa2_mac *mac)
+{
+	if (mac->serdes_phy)
+		phy_power_off(mac->serdes_phy);
 }
 
 int dpaa2_mac_connect(struct dpaa2_mac *mac)
 {
 	struct net_device *net_dev = mac->net_dev;
 	struct fwnode_handle *dpmac_node;
+	struct phy *serdes_phy = NULL;
 	struct phylink *phylink;
 	int err;
 
@@ -300,6 +370,20 @@ int dpaa2_mac_connect(struct dpaa2_mac *mac)
 		return -EINVAL;
 	mac->if_mode = err;
 
+	if (mac->features & DPAA2_MAC_FEATURE_PROTOCOL_CHANGE &&
+	    !phy_interface_mode_is_rgmii(mac->if_mode) &&
+	    is_of_node(dpmac_node)) {
+		serdes_phy = of_phy_get(to_of_node(dpmac_node), NULL);
+
+		if (serdes_phy == ERR_PTR(-ENODEV))
+			serdes_phy = NULL;
+		else if (IS_ERR(serdes_phy))
+			return PTR_ERR(serdes_phy);
+		else
+			phy_init(serdes_phy);
+	}
+	mac->serdes_phy = serdes_phy;
+
 	/* The MAC does not have the capability to add RGMII delays so
 	 * error out if the interface mode requests them and there is no PHY
 	 * to act upon them
@@ -363,6 +447,8 @@ void dpaa2_mac_disconnect(struct dpaa2_mac *mac)
 	phylink_disconnect_phy(mac->phylink);
 	phylink_destroy(mac->phylink);
 	dpaa2_pcs_destroy(mac);
+	of_phy_put(mac->serdes_phy);
+	mac->serdes_phy = NULL;
 }
 
 int dpaa2_mac_open(struct dpaa2_mac *mac)
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.h b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.h
index d2e51d21c80c..a58cab188a99 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.h
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.h
@@ -26,6 +26,8 @@ struct dpaa2_mac {
 	enum dpmac_link_type if_link_type;
 	struct phylink_pcs *pcs;
 	struct fwnode_handle *fw_node;
+
+	struct phy *serdes_phy;
 };
 
 bool dpaa2_mac_is_type_fixed(struct fsl_mc_device *dpmac_dev,
@@ -45,4 +47,8 @@ void dpaa2_mac_get_strings(u8 *data);
 
 void dpaa2_mac_get_ethtool_stats(struct dpaa2_mac *mac, u64 *data);
 
+void dpaa2_mac_start(struct dpaa2_mac *mac);
+
+void dpaa2_mac_stop(struct dpaa2_mac *mac);
+
 #endif /* DPAA2_MAC_H */
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
index 9a561072aa4a..e507e9065214 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
@@ -703,8 +703,10 @@ static int dpaa2_switch_port_open(struct net_device *netdev)
 
 	dpaa2_switch_enable_ctrl_if_napi(ethsw);
 
-	if (dpaa2_switch_port_is_type_phy(port_priv))
+	if (dpaa2_switch_port_is_type_phy(port_priv)) {
+		dpaa2_mac_start(port_priv->mac);
 		phylink_start(port_priv->mac->phylink);
+	}
 
 	return 0;
 }
@@ -717,6 +719,7 @@ static int dpaa2_switch_port_stop(struct net_device *netdev)
 
 	if (dpaa2_switch_port_is_type_phy(port_priv)) {
 		phylink_stop(port_priv->mac->phylink);
+		dpaa2_mac_stop(port_priv->mac);
 	} else {
 		netif_tx_stop_all_queues(netdev);
 		netif_carrier_off(netdev);
-- 
2.33.1

