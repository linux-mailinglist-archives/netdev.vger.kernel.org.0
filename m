Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68F9B4D35DC
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 18:42:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233374AbiCIR3b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 12:29:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237145AbiCIR30 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 12:29:26 -0500
Received: from EUR02-HE1-obe.outbound.protection.outlook.com (mail-eopbgr10078.outbound.protection.outlook.com [40.107.1.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA82F8D686;
        Wed,  9 Mar 2022 09:28:19 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LjEQ2WsYgmCgi7zVI6ocANBXNM45gbci1AiuTZ2FzhsZqXi0Kfgh7JCvzJ5WYeadyIXMC/4l6+V5O5hNY30Qf5PBQipL7no/GWaXjuxQnGEknO6Wi7HFU5/f/qoQz093suYGO8lf7HbPZCzDkEWMtlRFVYGpQNvg/FxgRpmdqoceW7ZCWcg+FUuNWevQuUraMPzeeexusFsC2fgQ8lBcB3mgoUMuo1+wfd/NQOwmr2A0MSP6cLWtxa4GmOyNl7Uf0pLyhOB8VMOzRhv5CfKJqPZ9CAaiSxmZEBVgcIbSApPdFa4mia6YCmttQ4GeknuMabJgrkFkQxVUslBfchlvBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ih2CxV3JM80cHwJ1F2PADtx8v6tK/2R7JJLjD5unI5U=;
 b=cn3DQVCo9EyHa/iakhtysy79oS7xzTiG0Zdbw5e7+fy74gFtltwnS/m36ADBq+zwnvqtJv1EbQOPNz2RhuZFvlzzsQm+qSWiAWLzrPELVJ16sbDznhSmW4EM4IhLqfuIFIZDI6jd+YJWCB25ouKBu9o9wUEcQgvWOR9MwjeClrlUHHdxFazVdwCH9VAyzEaQC+7GIQgewKpzTvVNrhhgqI0XiO7uIUnU4L6XJPXHvJ5v4YR9anAa7LbCADX5Z3jWG+BZ/G1VbJkZyuBUbsEcFUIrCT/X6jefqSPBg6fXnFWdhXgHO2PyDHDPxdjIfJFq2BLUqTgBm3ndszk0UgjG0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ih2CxV3JM80cHwJ1F2PADtx8v6tK/2R7JJLjD5unI5U=;
 b=Kg9cay4dkToBgd8g9h0aG0cjfV+zbXhIbJ6s6AJ73IP5uicn8eghyb5T/sgLu4otm7nVnAYr59V1S4jrK2AvEM1r8T552XO52prsy+Q3Y2ixD45yR/SK7bFofC/bq8VlXkrDhPFMRdnxCQbS4J5TmumJ+6bvCx+tgxwRP1iIJDg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM9PR04MB8555.eurprd04.prod.outlook.com (2603:10a6:20b:436::16)
 by PAXPR04MB9422.eurprd04.prod.outlook.com (2603:10a6:102:2b4::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.19; Wed, 9 Mar
 2022 17:28:15 +0000
Received: from AM9PR04MB8555.eurprd04.prod.outlook.com
 ([fe80::c58c:4cac:5bf9:5579]) by AM9PR04MB8555.eurprd04.prod.outlook.com
 ([fe80::c58c:4cac:5bf9:5579%7]) with mapi id 15.20.5038.027; Wed, 9 Mar 2022
 17:28:15 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     kishon@ti.com, vkoul@kernel.org, robh+dt@kernel.org,
        leoyang.li@nxp.com, linux-phy@lists.infradead.org,
        devicetree@vger.kernel.org, linux@armlinux.org.uk,
        shawnguo@kernel.org, hongxing.zhu@nxp.com,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next v2 7/8] dpaa2-mac: configure the SerDes phy on a protocol change
Date:   Wed,  9 Mar 2022 19:27:47 +0200
Message-Id: <20220309172748.3460862-8-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220309172748.3460862-1-ioana.ciornei@nxp.com>
References: <20220309172748.3460862-1-ioana.ciornei@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM4PR07CA0014.eurprd07.prod.outlook.com
 (2603:10a6:205:1::27) To AM9PR04MB8555.eurprd04.prod.outlook.com
 (2603:10a6:20b:436::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3a8b5b00-65b5-46f1-583c-08da01f2315e
X-MS-TrafficTypeDiagnostic: PAXPR04MB9422:EE_
X-Microsoft-Antispam-PRVS: <PAXPR04MB942294F33351294863300132E00A9@PAXPR04MB9422.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: U9AH86yzIN5OEhE3DayIkEUsqxrUSFX0ptKPWNq/Mqd0+juQpAy9wrXKeCO11TsFw08fbchwWQ1crpstN3DOzfqY5PDUCTOllU5dDnRbCKN2f1MoMGC42H2ljDSVronTjikpU/nbXJxlRuMmhkRU25SZi36leVFB69+AZdKjRXTWrojufanHNgreGCjf7RW/OcNiqUWje1qMbaMtCZPb1aU1IdxcEStwDkZ1Be3q7TI2TlgtC7qp7EpxUV7BHEbf2cKgtoU3B1FdbQQi/jdCOEj/HfpNSDv2U3xJFXTGascCx2Zp80pWAh7lc5mDo4OWkCbYYetB8/pWFkW0JGGPbInRsznWMykgUHv0TQymY18lx2wf5Cc3lzYmSr+53nzB6mWvf0aHTEgHYjS1zm80ctafiy97lavQL0PccFUYaBe3H9QRgXifFGdfXzfx5I6eNw2WMtBBkbIfVGmgIQsGw9ImgrOIhht2WEI6vD+ZyhYXhQnylHRUb82XD/vdKt/NFoMN4N3noCiQdUM5uo4d/pyBCRUfSvCeywV2xaFn3oqaj9yz9j1UIb6yuPaeYi3m2T9PQBfI6fy4dHMac1IYZipMbGYH/h8HA8OesLpFyXxemMlTREUMHaNTAQMf6/se8C2OgXJDgfoI1nB4WqjdJWRvBMsxOFghcvwFpZy4oJp6yLEvy/LSAhkoWAydY+uJqMFcojm0PDhU6ZJt7P9w6Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8555.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6486002)(8936002)(52116002)(2616005)(6666004)(6512007)(498600001)(6506007)(5660300002)(66946007)(7416002)(36756003)(86362001)(38350700002)(38100700002)(2906002)(1076003)(44832011)(66476007)(66556008)(4326008)(83380400001)(8676002)(186003)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ePLj+rl6ceOd/O3akbNPDHuSqTTtWKi2rIqkDvTAZy5LAqudRUW7wdLjiU4n?=
 =?us-ascii?Q?i4tyKbRhf3yzQUScHGh1aEWOYb5/EUK05nXqCDJbjA277Sx1Et44OpWD8LHH?=
 =?us-ascii?Q?UhLVUrmUzj1YMmkmgc7ILZDkcUmN7SHOEA8Lf2B3Nt8okTnlM/YbDAfydbSm?=
 =?us-ascii?Q?pP8q6fVLWk+TFvllsZWThPqoOSfrHw9Zxt0KL3ZyXR2/ws65EGj/21dIor4H?=
 =?us-ascii?Q?nPmETUDtKIsAuCyIwCfy+80G8GBP373xn46FIR3K3H66KObn+NvbcEUQmwCj?=
 =?us-ascii?Q?K3BCu0u3gkdwIELtk+qTFrNnORmsU6zCXw6L1hpST96l4UByC7CYW5HHaMEe?=
 =?us-ascii?Q?CI4VH4XBiQ00Dyi7nM8KXkCqRaAwG1X+7NWy3dKNnWCLeTlMKZ3CWPxqqXjK?=
 =?us-ascii?Q?FfH9I7vLzGD20ycq2PmcgTTQ2OpxgVVe4vxLlxSazHbPh+Bu5t7iRyTJqf8+?=
 =?us-ascii?Q?Z4jUAUlLkyQsb7Ndfg//Z+h28TaPez6+ZtUsQChwlrer4PAb5VSSeVvVvpDU?=
 =?us-ascii?Q?rFwnS3Oz8KBkRhK3e1pg6kaaYCuw2EDVRVaL1UDW6BSBgihv8wXpaEtIlW2z?=
 =?us-ascii?Q?PvINq2txZdL4A/tHJQaUPFE+p9xvzJQhJ3BlcFmYD7KnX0fUN5jtjpT+084A?=
 =?us-ascii?Q?gbh2lUGKm33DSLjYl24P53L1HzkqQPqqE/H7wbLiyfxMMnNPzT6ONw1jM1TG?=
 =?us-ascii?Q?gvvMmQMy6Z6QYiZJVjvIaZP6Ij4+/9V/gg5RYEuvRY53XS3NdpVdTg75h0BC?=
 =?us-ascii?Q?uXD7l0hIBpcHkCw2c2NT+Sx1zw/OBbH8Ma/oT2DXbCfiyTWORf9COXY//MpI?=
 =?us-ascii?Q?v8UW4d6N0E5Juq+JVKTj6HSC74RC4YjuQR/TljnImltTe6ZjI4Y0oOQ5Dsza?=
 =?us-ascii?Q?BKf9+GJyQzpmi3OoRxCHCj2PCoX7IE87xoE2Ahnc3bCubMywZIn3qKb6iPsM?=
 =?us-ascii?Q?kfBDUa+L/23aV3dE+1WSt13g/1c9YE3uYh+lYwjHvlwjay5waCTZEPCfshoI?=
 =?us-ascii?Q?A0Ogexs2T5pWcvjZYqjWg1O6QzMLKigeV0j9mTpRabJBEMcjsi0B8/stkFaZ?=
 =?us-ascii?Q?I4nx2nxOBR2e00T5e3p6/1RtTLRJHW1mbiMXiQR1/u443u47hqtIO1a4oQY5?=
 =?us-ascii?Q?zGBBZqBlpq6w1QwumWPBbAPwYrGCLMXdNwGLGD2k4rvpHZviYzs+eEcfH0Ku?=
 =?us-ascii?Q?qVKl2j5JEG2bkg6hZFKHfYtdzzA9y5sGxs5e/ekpHD99BHVE6gW3tMgoTZgf?=
 =?us-ascii?Q?1qI/I4nC1KWeTdFlWPTm2kTFnZROuhLPfaFwuzJJuM0AmDd4vTy9ykewKss9?=
 =?us-ascii?Q?B7UbIsrfX5d4U3aNDJer/f9cwMLrbMDVeAw7YS1sAUwQlusyeB8hLj7P+9HZ?=
 =?us-ascii?Q?aZ0lzS49XhJO+FXhlINwNZkL25Y8NnLPQOmvjKOBzSB3ddo1uV3oD4+z2P2E?=
 =?us-ascii?Q?DueYUP/YM9Y89z70gsXugYcVN02FtDapQ3/FJV89XFSYZRnp4DFX462Z0ycp?=
 =?us-ascii?Q?M8gj95Fb3nYD9yPG+9zfsrTjAMxD2YMilFtQxVh85LqpRCqdQBwUY/ZXePsS?=
 =?us-ascii?Q?Eg5ll8UVJHdaCXZmJEDmEDfbVSUgwuho0wvtoK5m62wUdY0szAT6DvYZODh+?=
 =?us-ascii?Q?AL2EhqorCtDSEsGea7gmFQE=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a8b5b00-65b5-46f1-583c-08da01f2315e
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2022 17:28:14.9420
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eL2Pe109YDgCxsC8RZIgptt51koZTd2EDAkJAbxczmePdidNinFsD7/x4W9vG4mN4NMLL3I3oh3jIpyZ8Ig6cQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB9422
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

 .../net/ethernet/freescale/dpaa2/dpaa2-eth.c  |  5 +-
 .../net/ethernet/freescale/dpaa2/dpaa2-mac.c  | 91 +++++++++++++++++++
 .../net/ethernet/freescale/dpaa2/dpaa2-mac.h  |  6 ++
 .../ethernet/freescale/dpaa2/dpaa2-switch.c   |  5 +-
 4 files changed, 105 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index 939fa9db6a2e..b87369f0605f 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -2077,8 +2077,10 @@ static int dpaa2_eth_open(struct net_device *net_dev)
 		goto enable_err;
 	}
 
-	if (dpaa2_eth_is_type_phy(priv))
+	if (dpaa2_eth_is_type_phy(priv)) {
 		phylink_start(priv->mac->phylink);
+		dpaa2_mac_start(priv->mac);
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
index e6e758eaafea..bd90acc49cdb 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
@@ -3,6 +3,7 @@
 
 #include <linux/acpi.h>
 #include <linux/pcs-lynx.h>
+#include <linux/phy/phy.h>
 #include <linux/property.h>
 
 #include "dpaa2-eth.h"
@@ -60,6 +61,26 @@ static int phy_mode(enum dpmac_eth_if eth_if, phy_interface_t *if_mode)
 	return 0;
 }
 
+static enum dpmac_eth_if dpmac_eth_if_mode(phy_interface_t if_mode)
+{
+	switch (if_mode) {
+	case PHY_INTERFACE_MODE_RGMII:
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
@@ -147,6 +168,19 @@ static void dpaa2_mac_config(struct phylink_config *config, unsigned int mode,
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
@@ -200,12 +234,21 @@ static void dpaa2_mac_link_down(struct phylink_config *config,
 		netdev_err(mac->net_dev, "dpmac_set_link_state() = %d\n", err);
 }
 
+static int dpaa2_mac_prepare(struct phylink_config *config, unsigned int mode,
+			     phy_interface_t interface)
+{
+	dpaa2_mac_link_down(config, mode, interface);
+
+	return 0;
+}
+
 static const struct phylink_mac_ops dpaa2_mac_phylink_ops = {
 	.validate = phylink_generic_validate,
 	.mac_select_pcs = dpaa2_mac_select_pcs,
 	.mac_config = dpaa2_mac_config,
 	.mac_link_up = dpaa2_mac_link_up,
 	.mac_link_down = dpaa2_mac_link_down,
+	.mac_prepare = dpaa2_mac_prepare,
 };
 
 static int dpaa2_pcs_create(struct dpaa2_mac *mac,
@@ -259,6 +302,8 @@ static void dpaa2_pcs_destroy(struct dpaa2_mac *mac)
 
 static void dpaa2_mac_set_supported_interfaces(struct dpaa2_mac *mac)
 {
+	int intf, err;
+
 	/* We support the current interface mode, and if we have a PCS
 	 * similar interface modes that do not require the SerDes lane to be
 	 * reconfigured.
@@ -278,12 +323,40 @@ static void dpaa2_mac_set_supported_interfaces(struct dpaa2_mac *mac)
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
 
@@ -300,6 +373,22 @@ int dpaa2_mac_connect(struct dpaa2_mac *mac)
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
@@ -363,6 +452,8 @@ void dpaa2_mac_disconnect(struct dpaa2_mac *mac)
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
index 9a561072aa4a..e4f8f927e223 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
@@ -703,8 +703,10 @@ static int dpaa2_switch_port_open(struct net_device *netdev)
 
 	dpaa2_switch_enable_ctrl_if_napi(ethsw);
 
-	if (dpaa2_switch_port_is_type_phy(port_priv))
+	if (dpaa2_switch_port_is_type_phy(port_priv)) {
 		phylink_start(port_priv->mac->phylink);
+		dpaa2_mac_start(port_priv->mac);
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

