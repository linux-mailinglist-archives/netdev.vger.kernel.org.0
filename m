Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86F2E4D61D7
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 13:56:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348712AbiCKM40 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 07:56:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348692AbiCKM4W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 07:56:22 -0500
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-eopbgr150052.outbound.protection.outlook.com [40.107.15.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A17B1BFDF6;
        Fri, 11 Mar 2022 04:55:13 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dhTefzV5arQPkx0DX/xqpaXHmYP0mw0svLRkM3HFf/MnURfgktrEtX3f1rFk1TgGTCVKCYPZd0O0s2bKg7YeSfpr8V9VLaMMURy52hFnhF/+tXVmywQKi+qQthEXJDLcPwsJwe4xeaNbBMNcwg5/VFnJRSvcVTGy4tsY7sxh5/vVZ1488HVl04/8HOaWkQ/WtRkSD7Vh1FL3S4+A/DIzxMEBamMZwVDI9mCNmuHIURsPVBmN9ZQv10UYQJEViLboQdGO0YNLiwucLhGAXs3mtbw16ehVoE1YoisBxWcM/o38Z16ezsinGyXFRpIQvFHek8hYn6p+e+sCb8vqYFp9tw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ldQgwRpqKswQAt1pbdB022yDYUtlhRkM9yrlzQrJWZo=;
 b=cFZGYfj1XmxSk+83zdEjyPDatb23u72y46vBXpr+sS2DnqXPu0fnoCdTt4XOuIx5EZ20Dcp0xvYa+r/1qFBk5Ab5972yQZcNqImLOG9XgXd4YGHIfNb24FG2Q2c6askfsTefHwRUDt4w7nYTfAwNOpy0xixvsK0luUM5bnmygHlUB/Y1Wdjb0NeAYxLogQBUQRjgDULFJgv5yHDnMqQDsRCno4i8LHsq3B2A8aZu/bd0hk+hGlhDEdfVEfSdVfFVh7gpNzB4myOMmZHElm5VSeJIp5Dn8g3Nu2nNMLnu53XZYzpfIAIYKZlEWo1Y9EDyWuZ01S3McsSM/nCqXTjauA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ldQgwRpqKswQAt1pbdB022yDYUtlhRkM9yrlzQrJWZo=;
 b=Wo0HcUM/8ZYdauhd8D5xgk1N9kER4exXvlYRBnx+XWUhEtDffDP5eIHk7GRCnjyOyvO/5vgt1nTA6LluCCMH1iIxhOz63NZn0sGotjwMkL6pyGPniV4xInOgrAGnvrV9sQw2iXfIUM5hMq4byjmcxAQHMBGvSf/C8K7DtdWgmJI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM9PR04MB8555.eurprd04.prod.outlook.com (2603:10a6:20b:436::16)
 by PAXPR04MB8880.eurprd04.prod.outlook.com (2603:10a6:102:20f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.24; Fri, 11 Mar
 2022 12:55:07 +0000
Received: from AM9PR04MB8555.eurprd04.prod.outlook.com
 ([fe80::c58c:4cac:5bf9:5579]) by AM9PR04MB8555.eurprd04.prod.outlook.com
 ([fe80::c58c:4cac:5bf9:5579%7]) with mapi id 15.20.5038.027; Fri, 11 Mar 2022
 12:55:07 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     kishon@ti.com, vkoul@kernel.org, robh+dt@kernel.org,
        leoyang.li@nxp.com, linux-phy@lists.infradead.org,
        devicetree@vger.kernel.org, linux@armlinux.org.uk,
        shawnguo@kernel.org, hongxing.zhu@nxp.com,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next v4 7/8] dpaa2-mac: configure the SerDes phy on a protocol change
Date:   Fri, 11 Mar 2022 14:54:36 +0200
Message-Id: <20220311125437.3854483-8-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220311125437.3854483-1-ioana.ciornei@nxp.com>
References: <20220311125437.3854483-1-ioana.ciornei@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM5PR0402CA0014.eurprd04.prod.outlook.com
 (2603:10a6:203:90::24) To AM9PR04MB8555.eurprd04.prod.outlook.com
 (2603:10a6:20b:436::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e48c3c3b-4e15-4565-e7ef-08da035e5eac
X-MS-TrafficTypeDiagnostic: PAXPR04MB8880:EE_
X-Microsoft-Antispam-PRVS: <PAXPR04MB8880BA766FAFF02747D483C5E00C9@PAXPR04MB8880.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: orJ+6fErzFPpfazBwXc9GKdjtalKyhD1I9JTBUxMPcQCs945pT9f5LAWBAmBt3uM8xXbENrt/ikn9DTgVTei5Ozjw7+yzH9H4O2VTioDXdVVNwcGYE0oMNp+99ioiAhbPI9aSYxw51Lv5x2TnyCAeW9yjMTmWJctEgfn0+kQPq9GvIDvX8dAKnTvIh0WX2MwQ/MSTWHtnICUlSrqSABG9haRn/mQrW9MEDsycgDOSwyzKd9dffnxQbAAU3mDL/i2Orpol2U2P/CV9+pRnMPQV8KAE82hZS57F/2VkW9lw8P5oOdr8yiOzTjWir5LGdCa6cZ89kbgimTuVKMDRnQ4r24K4HTrsUYWLEiy7hqGoPQtEl3Ecvqzix8KzMwwFTRKkEEk1F/9tRdWaQTd5l/EnTeCWoAiUpmLeJc52sclfCed/du7FmUQ4GwatwiRnBXQmoIj1p9b6bOjqvAZUJG6CxCs9jtiWzE8272itutam/Tt1xNh/XzzxsAEDLXzIQOE7O5fniHWeWcag9K8tXCll/KJgPn34z9Y4srNuCL+Xv0xoiUF4nf8J8lQMBVJAFtUqusm6LwPiFGmjKgVhcfDop6jRv+Zkch2P5GInzBCc8WRSaK+Z7Pu0sToQR3IovJp6Ow/qtN9ho7/bGX/o1Ss9kfPTCtA2KFfD/4T94knUt3scYQoe2eJVXfjgNVicoxmskQU0O92b79AOMRQ1qMEMA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8555.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(44832011)(66946007)(2906002)(66476007)(4326008)(8676002)(66556008)(86362001)(6486002)(8936002)(7416002)(38100700002)(5660300002)(26005)(186003)(1076003)(2616005)(83380400001)(38350700002)(6506007)(6666004)(498600001)(6512007)(36756003)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?QlO4EiWlg1Yc54U4/uUmgg7PV7iiWTc7XzBHFw8QcNEMPSVKEiIwHN1zwPLL?=
 =?us-ascii?Q?e8LeQM8qdg/827tKhG0leQPcEgzUzkVFPx6HefeeXp91xWYypzeOtCAFkxHj?=
 =?us-ascii?Q?r4E6m460XfHkivN8lw204k3ueB3I7bmviGqtybBIz9TLvp7wZ3SH+F/xwB8F?=
 =?us-ascii?Q?KXpgpDkOqNCbEYbfNnS5n5J6ajTrRRyLzCnYQVF+zAig4PrAYBuBI1UvFx/Q?=
 =?us-ascii?Q?iOevohTi5EulHKBuUpTN/6aq+wr9JBnY3MXOGarLbiNceKNYT3Ajs4JHQzvd?=
 =?us-ascii?Q?kV2CCfBQs7jZxXLCSe8hViKadGmYUOYxoQIYN9jwifsw3bL6Es365WnIk0rq?=
 =?us-ascii?Q?syb8NoCmDEy2+dNkSvB2wWwBCcAjAWBmvJT5B0YHOymWb7/S763SoyzRpl8k?=
 =?us-ascii?Q?rEiyB4kXNwM3+5OvPMtqv7uQ6FbLnlQ8ZZRjw+PUkYmhYVhNlrHchnVLa28V?=
 =?us-ascii?Q?syAfv9sTiKBr8K4BmWUiahPuomxz6SrsxVwcMIMDL1YWqVY/WV1s1ww6cpaL?=
 =?us-ascii?Q?/R3Q+VOkTFm2VjHl8P+ktI9dPb77G5N75o/EQzZDdky23HqdBZWCCCh0iVCp?=
 =?us-ascii?Q?yvUHvpPHq7+hfS+pzWSnNbGWA+MKLmZ6+I1jGohEOLXvXZSFmSqEhU7veZkX?=
 =?us-ascii?Q?2Y37JqhS/YL16Mk0G6V/iUF2Sy462oBDr0onNVl/yEx+jekAgQ3qAp8nvriv?=
 =?us-ascii?Q?hqs67yU72JTioHDPrjunHP+TIirkCcNa3aDt7ySIfotn4dTvN+jqiLMyP7FR?=
 =?us-ascii?Q?xT2sDu3dL/ZLqMeZxa+9ku2+koLtwc9KbLypI1imfGQIWOgZLqSlWQvQCcOl?=
 =?us-ascii?Q?D4S//OClO31N8QRgb4O1wSNY0J+7f1YDnK2OKQOoYzZ7LJ6KMq3Jm5r6eh9i?=
 =?us-ascii?Q?dbb4XRU5fVi1ZfW5V43A/FuOR9gHneJbs5JcXH1MQS0UFcDhaRXgL47QogeM?=
 =?us-ascii?Q?Lu1wqlGy3FSylYuQgpvqXy2vG1RX9TVCff+9TUryQJ9aTTf44hNJVP2cbtgO?=
 =?us-ascii?Q?6CXkwZQppUthvLWegXk+YXu/pZo6m8GpaEYsNqU5DyLDB6jtKy3ViGM0X7zZ?=
 =?us-ascii?Q?I8PQm8rYUIJbJorClOuaa6+r2lmifRZvs1S7qWHEdp1ULBHp/MfkjxTYAsgb?=
 =?us-ascii?Q?sj5BuKGifg8T3meroB09zMRN044Oa9cBKESsz5paKy4Rv2N8fwoIKAd6JKEt?=
 =?us-ascii?Q?rKrD11B+FvCg62lCr/9vQ5xmQuMVxvUGI0daaapn24a9Co86UuNtWDEw/JFc?=
 =?us-ascii?Q?WL3KcPE7ggZW3+TLbrsnBPOzBBezbcdGl5kelSdVMcc5rbyI6mbXWJdpdvXB?=
 =?us-ascii?Q?ZUfQ6Zbi+VtOwVBVhIa4bE9uYw4L8UIePaoysCVeRVNYHjNdK7rGIhHzV/ZL?=
 =?us-ascii?Q?q+Kh8xyS2vpI8foTQh/jVFk1inV3bn2SLbE1GjEurDbn5M4JgD0eLYvubaRd?=
 =?us-ascii?Q?UES5y0/CLoMg9U7G/HrQDn2TMdK3i+xklFcfR3RBGXU8eiDXTw6SDA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e48c3c3b-4e15-4565-e7ef-08da035e5eac
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2022 12:55:07.8576
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SqjX/yJslkYLqven/wIrQGujIaQA+THoUGirPtiiCneYfvYltMlI8jmP2yi0UgEDd7cXG3TGrog3KDxZntd1YA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8880
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

