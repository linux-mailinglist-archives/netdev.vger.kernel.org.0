Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E3D74D311F
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 15:39:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233581AbiCIOjb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 09:39:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233558AbiCIOj2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 09:39:28 -0500
Received: from EUR01-HE1-obe.outbound.protection.outlook.com (mail-eopbgr130073.outbound.protection.outlook.com [40.107.13.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05AF0124C25;
        Wed,  9 Mar 2022 06:38:26 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FeAIqb0X3tQKkC3Ihn5RPfYDWkgANvYBt08XZv1mIEs3ZSPbVFtu0cVBioUh8axuRdvKrN8HEdxMh9VKeHgz14j5vH++3V3VXpICWIdkBN3Od9FGbwdFsnc/hjBPA8GwxLLdFYtJrZuk4J0G08QPxxO9MvfSmWHAIxJzmbNtTN0MVW010/gnYqA4twmpkE/dH7Vyia0SD3on9oy4hMcLtaiO3zpl0CqK7daqIYd6D5FmkvWxyOWeIi1jXntORbQZoWuV4GaGt6lh3cdP0IXazCD5husuusLB2OdJH5R8AwMQiJRXfZQnIea2yGMGRHtOl1whMw0GU50LY1qWCxffxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OaIj3Nvs+tMytCMTxP31Imv1T9KQJ2bRgQIF24FLP+s=;
 b=NAcvgiHlvYZrq3N65SKCf/ZWVPUU10x3CbGXEaTwJJrIzUm6sZbb++fsnnqL+dbV/0V0PjeSQ015KwpRccs43bFyb1B0VqB+ydlQbJbiugEsBjYlPFCrvMPr2OsOIWoubC2FGhMwdCuG7JxrDMKS0VWaBQJJwP6x7dHG+TMJSrHXt0LIdT723HaZ2WlrhaqU4Pwnp7eKvykJuSpZTmkcbw4hpNHCbxwNOJ8Gc4poAoQAx6ygHYtSpi3f1TazEt6OIJoYoiIPjcrDPkIUY965UzKtk8u/yGCulFRhaxyRJftHp13UUuzM5MQP6BnEFZGAu2FMbO/UIAtciKFUPEf/lQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OaIj3Nvs+tMytCMTxP31Imv1T9KQJ2bRgQIF24FLP+s=;
 b=MERQgEYJelTEqhOQPxF6OhiGDUE1D53tlDyDxhN7R3+Y+lDUOCejxJjP+y6rv/Efuc+xWg5ZoYuADWFAtpFZCJUTT4ukpYz9BfI/aDjNDoBYJjFwOoymCEWMLJjSJPWmxtvDF/dfHx9K5BUUyr+tIODMQ+zA3JYNqigvqr1Jk7k=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM9PR04MB8555.eurprd04.prod.outlook.com (2603:10a6:20b:436::16)
 by VI1PR04MB6223.eurprd04.prod.outlook.com (2603:10a6:803:fa::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Wed, 9 Mar
 2022 14:38:23 +0000
Received: from AM9PR04MB8555.eurprd04.prod.outlook.com
 ([fe80::c58c:4cac:5bf9:5579]) by AM9PR04MB8555.eurprd04.prod.outlook.com
 ([fe80::c58c:4cac:5bf9:5579%7]) with mapi id 15.20.5038.027; Wed, 9 Mar 2022
 14:38:23 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     kishon@ti.com, vkoul@kernel.org, robh+dt@kernel.org,
        leoyang.li@nxp.com, linux-phy@lists.infradead.org,
        devicetree@vger.kernel.org, Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next 7/8] dpaa2-mac: configure the SerDes phy on a protocol change
Date:   Wed,  9 Mar 2022 16:37:50 +0200
Message-Id: <20220309143751.3362678-8-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220309143751.3362678-1-ioana.ciornei@nxp.com>
References: <20220309143751.3362678-1-ioana.ciornei@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR02CA0187.eurprd02.prod.outlook.com
 (2603:10a6:20b:28e::24) To AM9PR04MB8555.eurprd04.prod.outlook.com
 (2603:10a6:20b:436::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8526a322-1c8b-4336-b54b-08da01da76fc
X-MS-TrafficTypeDiagnostic: VI1PR04MB6223:EE_
X-Microsoft-Antispam-PRVS: <VI1PR04MB622312A4BF1E7A893B0404A4E00A9@VI1PR04MB6223.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fnisBZxHBnvnHKWcs6EmI7K2gXkfxOUufGIysgS9VsjmI5zeIFocuAukxtdYl6yDSYTkAB+WDpJuZArBoGpfti9DDnV9xwEGTkBnpT4TMZnK561380NoRbhyNDVEtYfS0cvPKfhbyfJby12E4pNkohuyErUFjlJfjXHI35iDwrY9x3+GFOtvN6fdJH0wZ35suR27mdsIhgBNgg8mCzdjnjslHVmA7dLJXueQSw/VV65Psu2ou0+h+j6+wsNsSuRYfikpEL9mCkAnst97C1HgasRcVIF9yvaehYPv3Z5zdeUHRpzHfELgI5CMqYF807CNTgeKihrkM4bjg1aIqncL7bvV9stAH8lNBNx0RuFX92sBTLG+2gOLbx8mMZLD8y5UfU4oMjLrIvIWfdd9SaHjaDQ576f6qXb4khShPaxOEKFsuNAgACiZaauOBm/LpiSN6iXWe3lTz7gcGECQaA5d3l3ZQQ2YC0T3PjYAoqPFK0GhOKOKVDo4B1fgd0sY4pI2RSZaXebMC4IT0m+LVZo7G5BRNtVQL0Ne81he+ye9D1pAozXvwa9H/Y+Kc2lzY1twNUd8K7WSfPo9l0ANJ9gwL7n3N/LP6HsLyzW8YjmIVR/4TaIW8tA7Mpp4Ll8fs/tAEC1AfwzldzwkRdRmG8+JyBcttSpg6c34HgOLBztzhbO21crKZZskC5xaPH/gGb3tzlu9b9DYZJm5D6+edThPeA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8555.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6506007)(6512007)(86362001)(44832011)(52116002)(36756003)(66476007)(66556008)(8936002)(66946007)(8676002)(26005)(5660300002)(498600001)(2906002)(4326008)(6666004)(83380400001)(38350700002)(38100700002)(6486002)(2616005)(1076003)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?kiKhgcvibUHPnMeGOcXAumv9pKGTDkBhFhRFmuUgf4Mri1gHdc8goXCa6GDb?=
 =?us-ascii?Q?Ch0fWD5MyD1T6k+ZEwC3xh5F5ay9RGs2K0da4hp1dbcnf0PfZg58qrnvme9c?=
 =?us-ascii?Q?uJYREc4PT0hviTaWell0Kb5FZ36IBhfQOm9oPqqSHDsZBGiP5ogsFihzTi97?=
 =?us-ascii?Q?kHcntGBLx839Q1gf5e9yd0z0dIhJq988hxE3SztSmemT2U8Wi2ElW6oSXcw0?=
 =?us-ascii?Q?QA+43e3kPAqh/vP+xfnQpqUFQJsWIsTdl3bttEC4y+mQK/8u/SKduMqwn12w?=
 =?us-ascii?Q?FuKV0AcVTvPyYfCxUnFZFaDEQAL1bNRl3Bpa/TnaSK1NrxZgktB4vpdlkKCx?=
 =?us-ascii?Q?0z3olqhkGPLR/B/6NUvQRlYl6nrKlmhldLF8lEz4eHOHDzw1pxUK7qnJQkYt?=
 =?us-ascii?Q?DLxol+WJR8+SOtbh0iWPJLfr8Fa7JhDe50k7pgREacb1Vf/qsUpVApntWid2?=
 =?us-ascii?Q?eOT86zYYBX6iPhZ6q6AQkG/GPT4Qud5L43FVAYlJQpn6WjjGiknmZ9QSatmN?=
 =?us-ascii?Q?4H7hzMtTmTUxaKiPz4/UUzWwirpqjQrsKtX4JACSKZd7rHS1nk1+9twhBGmi?=
 =?us-ascii?Q?ZatJeNOmG5ELJKkm/O9nnuSWhsuLIxkRi67fZv+i9Kv1d3mqxCWQnuk3xI9M?=
 =?us-ascii?Q?YuEjf4sZK8fHmXs5a8LFHeCIDGJaoKx/Xre7Ys6SieAqAJFOhKNH/2WEaeTC?=
 =?us-ascii?Q?w2IR9AbhxxRW9Y9F4kfLi1S0AqB9agrLOJYphpRN4xkkGOC/uioEr0aHmNPD?=
 =?us-ascii?Q?1adu9cJh8Wn6RpzOMcNonnRfaa4pmKp/6wVpBSJWh1P8yGd5dtaKJ+r7zvJW?=
 =?us-ascii?Q?YOr8G2DM8QAu9IEsMmCVAdjYde5UZy7tJKoc46ZJ3oVRr+sy7wtzo6aExn5S?=
 =?us-ascii?Q?rmRvsl5H/eeFM/jHfpbsIWdx4/aqgSdyuNQ7sch4U/f1rGriOi2MRYgmeKQz?=
 =?us-ascii?Q?Cd2Q7Q6BpytwH+j53EnXi3+crgQh1UFnfR/4PDUipEUhdAFrbLN51355i85i?=
 =?us-ascii?Q?YT7I8YLG22hyUoqfftce3qcTwclNeT4kWfqz06m42wmluxcMaWVHmLneZkd3?=
 =?us-ascii?Q?lVsLSrpFdm2TnZHjHsMeuPoX12wMQ2WLbYT+x0RP42FXLMaQdADvIZFjamTH?=
 =?us-ascii?Q?Xyywdgl3QSwF8H8PVL5uNugj3ELCGr4TMNYxkI6S94ZccR6xjA26Z8lJsYAV?=
 =?us-ascii?Q?i06H6XdCOdkxYKkVIvEaJw/3QcOOqaEnFN9vNhGEpla6n/uUMcd5fQ0rYMgS?=
 =?us-ascii?Q?L/1g2CT5fRAEAOUDLjrrWuuBaWDpde3PmAI3SsiPey9O7IXWyQ5iHACuj8TL?=
 =?us-ascii?Q?1uREgxY/VZW9ITjaVs9uwESnJ43wglOfc6Mu2bJFOMtg0xpDHyWDCHr5bbOE?=
 =?us-ascii?Q?QpcNEhpkyXL3WbniOLCZq6vB+j69XDo6CrFNp9HpxfJSmrw0z5FElmhfV2Va?=
 =?us-ascii?Q?s/K8XNla1qhMUBzQBRWbZbwq5T5iavMxafpnU+87SA/fbsU7SSJvwBYh5zzc?=
 =?us-ascii?Q?lR0mo51iA/yQGuHTo+4Sjtp720IN4bd0hKGweukn0WbxLQ1g0EhA7+5sCCWp?=
 =?us-ascii?Q?Zz1oM3HrbzN2cNJMBUXTCFdhCX31Tp89llTGMJoQ3WYFgqapl5sst9peDr75?=
 =?us-ascii?Q?FuZHzxdJDyh6immgIWZw+6U=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8526a322-1c8b-4336-b54b-08da01da76fc
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2022 14:38:23.8255
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CgKGLylOQbOAWj34YXO/FJEjTC1WMsTzwWM4M+WWAsARR+6Q44/7ocYOi9K2aT2dKZb0Cr8w8UHmcj8/U1WBAw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6223
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

