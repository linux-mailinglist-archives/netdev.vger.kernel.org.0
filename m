Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7100A4D4C8A
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 16:03:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244824AbiCJPBo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 10:01:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344423AbiCJPAS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 10:00:18 -0500
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2047.outbound.protection.outlook.com [40.107.20.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7523318CC21;
        Thu, 10 Mar 2022 06:53:03 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hIMqhczNNNZEhZ3e0WArjCd5zNDSmQZ8Oj04mXTSRe1Ot3SLmsoC9Y7KWYs6t1IZajJzEGaM08vkw9ZHVBvynEa85TrRvxk9ySLZB9l0ccTd+czE1gJKxovoS3xhnit6qKFsdiMgEDGyh+smAwfaeUoOugWeQGpm9DBQkXTxkktK448ex38QM5TjCGK/ddMq73ZQFcJCC+ro3kBbepgWtzVbUpPiGsCKNtvAHewiunrsRHZjzM42Ea8uvq11ZmDr8zHAgauL1nFRVKuGuKimIQ6uErD/vJ46X1u6vMvwgm8oRFfHoGsbPc+8891wgxF3PWDYWC5J3SFToUnrKD5RsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CF0t4DQv5a+nnrW3MteMGCewrDv32SSZJApR379xOCI=;
 b=Dp0jyutOHHNCybjpaS3v3QLVkfnFNuMtP6v9GsomxdB/YH8TMPxB0rkS6NCUgq+819T35Gy8zAeo3vybXuTheMcO/u4YIdYn8tq+BQessH2/uO7nGS+yX36etR+qLhZp4y2nod+IuUzzR3BCcSQncJeuTDuvaejVEGp0vgVE85EF7ILLbPkUxGdmVuAre6oFYPnx8QRDVPPpPMQQhzLLm9lWo/iY5OAjqjeL/kDBaPltu2JrhBrS7QvAYtuOXJU6h2zRlV/aV+IKp1Mya73PNhMbK4+uFJLjl8UtW7seH9kwSFhY76aF+IrmYoCRmkljpbwf1tKoBU7BtaupJzZevA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CF0t4DQv5a+nnrW3MteMGCewrDv32SSZJApR379xOCI=;
 b=Nko7+11wb1mATY53Ggyl+XUjo8E1QkhA9nRTSaljS5/4ojFUmnhMxjHj42t/AzPBIKd4kvvPgQfeP0CGRK6HtPpf5MyCPOdRWw7mRHjuLx416ajulDwhdEp/WAFWZMnhR3WR8irb+i+9qlH1WxzzRCAKpfwLJmgpoY/4BB7pdQk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM9PR04MB8555.eurprd04.prod.outlook.com (2603:10a6:20b:436::16)
 by AM8PR04MB7281.eurprd04.prod.outlook.com (2603:10a6:20b:1d4::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.29; Thu, 10 Mar
 2022 14:52:30 +0000
Received: from AM9PR04MB8555.eurprd04.prod.outlook.com
 ([fe80::c58c:4cac:5bf9:5579]) by AM9PR04MB8555.eurprd04.prod.outlook.com
 ([fe80::c58c:4cac:5bf9:5579%7]) with mapi id 15.20.5038.027; Thu, 10 Mar 2022
 14:52:30 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     kishon@ti.com, vkoul@kernel.org, robh+dt@kernel.org,
        leoyang.li@nxp.com, linux-phy@lists.infradead.org,
        devicetree@vger.kernel.org, linux@armlinux.org.uk,
        shawnguo@kernel.org, hongxing.zhu@nxp.com,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next v3 7/8] dpaa2-mac: configure the SerDes phy on a protocol change
Date:   Thu, 10 Mar 2022 16:51:59 +0200
Message-Id: <20220310145200.3645763-8-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220310145200.3645763-1-ioana.ciornei@nxp.com>
References: <20220310145200.3645763-1-ioana.ciornei@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS9PR06CA0288.eurprd06.prod.outlook.com
 (2603:10a6:20b:45a::19) To AM9PR04MB8555.eurprd04.prod.outlook.com
 (2603:10a6:20b:436::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 141c0e8f-58fd-4337-6708-08da02a59a05
X-MS-TrafficTypeDiagnostic: AM8PR04MB7281:EE_
X-Microsoft-Antispam-PRVS: <AM8PR04MB7281B3957DB803E4F88188ABE00B9@AM8PR04MB7281.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tGFbitAO5OmupBU78qnwuQI14Zh0vJUCp2nbb3WwWGHYpPalgw7VZI4vcvP3/Iwf0DliJUBTeb8MF+rXiUOwV67Cv9s5+QluLWfwstmG3R6QDRZIQIVsBQAmzeFmdTBEsLriQWrVHyTMBlSOfgkdGrAy1eT03UklNtRu25sTDf7AqMWDdq5bsFVnUS59yiIsw+hCHoEqWLEnuKaZlIzfeU+iE2FpnGDEddNrnMO0cGBPTKWcAaI8PzBFhRoJJjxjSy2F9gxnmxawcqO9RQksW7nnzWgvpvvPy/a6FpbiIU/OZ71CuBcsT0YpC3bbM6tdmrtAF0L4kt4Km/LAs05n4+lqjlNSL9HkShzth7zhDABLKtE1ApGRLY+puxwn8sMizHBMa8nCdO1WoGIXctsgvTDIH8MEvAO7ybo1Ra7iykkQ9J1cz5hg0N3YGSLUSBCqmb7Gn8JPqEEh+doWUJ4IBdwA3OSjndBU7IY7xUlQfY8Z/pHEDNABeLVFw9Y+vQLcmzWNjSTSLaiXCG+f73qG0OrbMgG4h0IE4tG/zmcomJlDGIX6Qtr+2h09AOxA+uLbxNFknjVyKVKKAgxxi17plbWf2mTx00Qjb0ElZD7ssFCHto3HA51Ptp3zP91PNxELOFZQJ9JmNgf6D5cH0mZe1weYLitRySNC93aZNTQbAM170uxjnNUBLC/p4aRZypVSbYm10/iwN1lnpID0Sxk1ug==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8555.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(1076003)(316002)(66556008)(6486002)(52116002)(66476007)(8676002)(5660300002)(6506007)(66946007)(4326008)(2616005)(2906002)(8936002)(86362001)(186003)(44832011)(38350700002)(38100700002)(6666004)(508600001)(36756003)(26005)(83380400001)(7416002)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?JOd/rHRxrQ0H5DRxce+OxqR853H2DgOjS2BR/nNQaGPW+slFDYylSIqAJ3Fc?=
 =?us-ascii?Q?NQDEqLyYA97zWLyR/6UhMEVX0I4YTabLOvc00cTeiABmJuWMl03Vj+0QRAmV?=
 =?us-ascii?Q?Dg6tiiKzh+CdmCEhKRRzVdk3S4LSkD7wkaM/p84GRJ1bGa5lQhT1qVSDhRiw?=
 =?us-ascii?Q?xyybAHunOi4MDGfMyX4THUmVAwj98UgpcZUZSJ+xujNHKaqRFLmh+XwVA0Xt?=
 =?us-ascii?Q?5sK0TmJ1sj8aqYEkzdMNf+VdBFlQ5b/yn4/LJmfbA2b/bqf0LUN59A2LIhBt?=
 =?us-ascii?Q?Pl8VikKOVVipcOh6vPMvdM9Qk2Sa/sUcdU6kQC/TlZZvMe2YQ3LokE4UOrLQ?=
 =?us-ascii?Q?gngC4lnKZ4G7QJQB5NkBXrlYlIwZ8v43iCej9K7nFOmeyBW0ApGSJjJ0VloH?=
 =?us-ascii?Q?WzNa9Jkl+EK1E24EM10boGsJr8ST3gfRzp1q6j8nhRUEOGH+QNsP82GL2/Oe?=
 =?us-ascii?Q?wjRnBGaAoFE1/gi3srGj1scJdl4HNkaaNhqrvXOhjhgf6VKVf9j8u9liHO4T?=
 =?us-ascii?Q?saFyLqg4t5EKbBAylyQZpeMUGGyCbkOmD8+v7GnQEGXSwPgJZo6nB++Jw5Zj?=
 =?us-ascii?Q?Y+cNKuup6rlnCTnJOKg9Lo7t13Z+ALo7cknQsE7XIe9cY478teQF3o1dlf6C?=
 =?us-ascii?Q?WyANbgQm4xrEzUaPPF3M64f/XjeCO2xqJFkYJblBhCFVAhu/3kjdB5CcLzbl?=
 =?us-ascii?Q?/AEthuDBK8/qacq3FTgnT12OKTkh79SYMr0UzsOW4873xtuHNCnN1JgzGr3R?=
 =?us-ascii?Q?kmeqgoNSvKx8QuCQ0ubh0Ys9lHTMzcvPnUtpkewxW6gXX2euIBMOj9fyjLZf?=
 =?us-ascii?Q?e1qjy4CD2ZNKae1yeuMFttYJ82oVgbMjEHgVu4UwFZCu/OP9D4l8MtBo1hPY?=
 =?us-ascii?Q?nQHa8eyK6iid+XCmfStZwdtTNZsI4l+J7nY+wxnkqN4cF3NvpKe7RkUygL9o?=
 =?us-ascii?Q?Tv8VZ8Z8zG2upSxP7wrMOh8qp8LHPE4W1KSi7IufkxPcZHo/bAQdedczhuYV?=
 =?us-ascii?Q?AOt0FRR/4mwDoFKamHMp5mh66ZgEZpF8dn2YS+yOmxSxO2LPzf+D3Q5MtNg9?=
 =?us-ascii?Q?/MObngzM/of74w38B6NLPankAmNQS1czc4o6tF457iUdz+k62MHi/PzVGp/j?=
 =?us-ascii?Q?DbCXlqhOBdZXMBXQJwwPD8MIh2Dmbi/j7zBRXQj6aPVUClpz5wpo22vMJmxp?=
 =?us-ascii?Q?jMs0JU1zVVfsQBOvoapaipVYOu/0lakd2BHYNBS2AzAm81avJGC2fB0ifMEl?=
 =?us-ascii?Q?8HuA7EJvOjqBSMo4xPFpVPD1Kc/I6fHmBVNhMfLb1dIyxESQeKEN3volRj9E?=
 =?us-ascii?Q?MYF7s7/PF9xsr/ipK6vO+Z/S9jmZmg8yC+f3IxRc7nIKqIJK7caKoteOp7o+?=
 =?us-ascii?Q?1KEahFKb/eNKTMhGb748LCNLj8MhGYX1RUHT8TMxgY76qtil0J8oxkLTmSWW?=
 =?us-ascii?Q?TVJSlQpZvnj3N0eSlOLJvcJU3Ka4KdKyomlvtNnSXWn8WwVvy8zkf8K4PtzG?=
 =?us-ascii?Q?NHdec/zZEYFligzyecWjDwXanG/WxCI5YQFE362hD+5zDHM4PrOqOL195a/4?=
 =?us-ascii?Q?g/OMTjePKkJ2yC07/XppL4+j5+ajv5ts9v8e0MPJZkLWAdaBgAGB0Nv9TnsT?=
 =?us-ascii?Q?hD1lTldr04AE49CTVMTFIrg=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 141c0e8f-58fd-4337-6708-08da02a59a05
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2022 14:52:30.4344
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SwCr0yp8AALE9b4QKj+/S6XF9aNPehtyCVM+Le8I4f426WYzhVOOJDwDaT0dRbtpj1jhRNl8v9rl3mPpMP3rdA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR04MB7281
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

 .../net/ethernet/freescale/dpaa2/dpaa2-eth.c  |  5 +-
 .../net/ethernet/freescale/dpaa2/dpaa2-mac.c  | 88 +++++++++++++++++++
 .../net/ethernet/freescale/dpaa2/dpaa2-mac.h  |  6 ++
 .../ethernet/freescale/dpaa2/dpaa2-switch.c   |  5 +-
 4 files changed, 102 insertions(+), 2 deletions(-)

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
index e6e758eaafea..0a5430bae3fb 100644
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
 
@@ -300,6 +370,22 @@ int dpaa2_mac_connect(struct dpaa2_mac *mac)
 		return -EINVAL;
 	mac->if_mode = err;
 
+	if (mac->features & DPAA2_MAC_FEATURE_PROTOCOL_CHANGE &&
+	    !phy_interface_mode_is_rgmii(mac->if_mode) &&
+	    is_of_node(dpmac_node)) {
+		serdes_phy = of_phy_get(to_of_node(dpmac_node), NULL);
+
+		if (IS_ERR(serdes_phy)) {
+			if (PTR_ERR(serdes_phy) == -ENODEV)
+				serdes_phy = NULL;
+			else
+				return PTR_ERR(serdes_phy);
+		} else {
+			phy_init(serdes_phy);
+		}
+	}
+	mac->serdes_phy = serdes_phy;
+
 	/* The MAC does not have the capability to add RGMII delays so
 	 * error out if the interface mode requests them and there is no PHY
 	 * to act upon them
@@ -363,6 +449,8 @@ void dpaa2_mac_disconnect(struct dpaa2_mac *mac)
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

