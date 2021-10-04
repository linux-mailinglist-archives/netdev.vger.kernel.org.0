Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28ABE421739
	for <lists+netdev@lfdr.de>; Mon,  4 Oct 2021 21:17:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239035AbhJDTSj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 15:18:39 -0400
Received: from mail-eopbgr50077.outbound.protection.outlook.com ([40.107.5.77]:3542
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238664AbhJDTST (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Oct 2021 15:18:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WEALprFNDm2poRYMMslh2XD7mdp2k5UzQR5TDpOhOU5tgEqJapbLMl4uHPJuHC0msYWtWFaUILaJsIX06H5omv/anWcaJYQsB+ubfVd9eMw7z6eEY/XgNDo3a2729N/Alrr0vhUb3Csxr8zk47wUztbbMTx9iQb8eOX5PzUBw2av4gOzx8pQAnRa6LKtyj6hPfXZcq2pE/66vEs6AC5D4kRzJIoOBgsvEqX02sWfp1K3cdFEO9BeyRw2Z8D11l8PI+vbprgNvC//1K23cMgDWtnMywUNGiGYZDm6GOXylGKYkcFQ2030sWHG/0qYMZjseAABp3tuJKAEazpgE39XSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lmcxz4GB/axDr592bHvxU7Pq0EtIAijWW90fWtk/waI=;
 b=PDhs7g4zpMYHzKaYz93QSYMcmQKbG8k/g1m/OnUHqnrRSCXy1nTdjPb1VYWRla2BTh06BqtprcvW+qnU8AM1eATw7UgVBn1fAI5e1qkKv+fViZdGkzn8auB5GUlM889dr23+XF199V5RIZ9U6wx69EHS0kUvGWaY4XLoyXlem5X1dKkzvvI1untayL830JgvgbNuTpPLPsXGNYwzm2pPUjUZEv6oKLPQiF+rG8yS8LwyifCyowI0xRULolnVSyLM6YTtD+s+ftUvU+gbO5D0flL4VKNu+D58IlmZg+Fx0CPT7h1SjjEjM6YRnaRVoCGtgJweaakLm+5VVYvIIFlOkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=secospa.onmicrosoft.com; s=selector2-secospa-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lmcxz4GB/axDr592bHvxU7Pq0EtIAijWW90fWtk/waI=;
 b=swNm27Hrk5VaGiWCg9Iq3yBLkWNGXDF7Zotfwfq2X86yqDo1azs51uvE4DrJ1XL0eYiI6OAgJY2qH3E9cdeJyUJvbH/pNp9Ju1YtTOlCHuSJLHUxcyZHZvqIvLqAbu3hI1CjwWWPifMlSYMadqCFUjsnrXVkaYeHWQEzmFEzYNM=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com (2603:10a6:10:19::27)
 by DB9PR03MB7434.eurprd03.prod.outlook.com (2603:10a6:10:22c::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.19; Mon, 4 Oct
 2021 19:16:03 +0000
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::a9aa:f363:66e:fadf]) by DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::a9aa:f363:66e:fadf%6]) with mapi id 15.20.4566.022; Mon, 4 Oct 2021
 19:16:03 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Sean Anderson <sean.anderson@seco.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>
Subject: [RFC net-next PATCH 10/16] net: macb: Move PCS settings to PCS callbacks
Date:   Mon,  4 Oct 2021 15:15:21 -0400
Message-Id: <20211004191527.1610759-11-sean.anderson@seco.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211004191527.1610759-1-sean.anderson@seco.com>
References: <20211004191527.1610759-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR08CA0023.namprd08.prod.outlook.com
 (2603:10b6:208:239::28) To DB7PR03MB4523.eurprd03.prod.outlook.com
 (2603:10a6:10:19::27)
MIME-Version: 1.0
Received: from plantagenet.inhand.com (50.195.82.171) by MN2PR08CA0023.namprd08.prod.outlook.com (2603:10b6:208:239::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.17 via Frontend Transport; Mon, 4 Oct 2021 19:16:01 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0a2a52f0-0529-4ede-2c18-08d9876b683e
X-MS-TrafficTypeDiagnostic: DB9PR03MB7434:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB9PR03MB74342D86C3265B3E204D514896AE9@DB9PR03MB7434.eurprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: y2+em+AGOHf9aZDGFlvWcdSOmcjAKnNrD/RKdH8RtPMgxASUynBtNNpwBJsAq/76qySZ2ov2eRyfiuVWmVgUNvKHrA8i9H/+dXvkY2rmevAFCFgLPDCJTDzx0uzIzNbF2C7AJfayCHJecuezmd8gNMu3vaNtc3amjlTz5RCyEuF2RFYkoB+nkbUVtETM+tC3NCVk9GLqH/nTB8ao+TtXAtCtiroltL38AiEUxA09iEvTnsKagVkbExZWkJHZP5MjNOcnjMHaUAONUhmKlTo0lJCMgRZp3bF0YZEvt1Xsl5JYv02yTcWxBQAdFNDWsKdQBt6ha6ztJLfLeZydpB3T4Dddl7sv19IEmRMxbkhLPPKOm5BPLle3Zvb2lRktFR7+FC1Xt9+vX/tW6eoiyzgb2Ohgf/yXeJgIsorjJyMnV15vaFeqE7unYyC+aA2pBJwN3qKTiNQZrHigjmdLgWDwnOaQO5ugzveTzcHTtLl//45VMAbrFBz1nwGdBIMaEWsKr9Pm5gRvZJey3qJmwBABnMsY5TzF9GoB02VJojcLK/C9/w6dY84/N785+lyAKVDI4DhlDp0ApOwOMWPQrP1bdkEHa1C2sl6UglwrRSkzJg1VPvESI6Xk63LV6iKmkPAhuHGksa5TOyefcIYGDTLCHByD9GJAEegVcNOzzvseuUVP8Z74VGZpPrEYLFNU3sbkESMqXmq8QJrFVE4UsVeH6A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4523.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(1076003)(86362001)(4326008)(44832011)(6486002)(5660300002)(66946007)(508600001)(38350700002)(83380400001)(52116002)(956004)(66556008)(66476007)(38100700002)(110136005)(6506007)(2906002)(186003)(8936002)(316002)(8676002)(2616005)(54906003)(26005)(6666004)(36756003)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?R1Vw3TWKBOCkImL1fNxmYe/XonikpdEjeZRY19Uw6TDxscv+AWp7EWAzV4gb?=
 =?us-ascii?Q?diV1kbeJ0qcIMqF8cSKfWKBCYFe9625cP17UDuoriKp2og59ojy1nlNmdv6U?=
 =?us-ascii?Q?1gw/nWze595y0jc1Hhp/2JK1SsOEKKZrYyPp3HrC5BNwJ5i2/BFDpPvrmYbk?=
 =?us-ascii?Q?idTO0InM9px9+D+/+xE2lsP7mBK2I94g1sn0F6Ph5LckcgI1CBAXJCE8OKDM?=
 =?us-ascii?Q?XVQU10weu66X8c92MrAEaHcmEvkCrc8ml+j2vQ014EOhRWoS79fRkbIgaKEu?=
 =?us-ascii?Q?IjhY7gNGC/+lVI9Brm9qJ5PE1q/IR9ztc8Db6u+OtI2yTHhXx9FSl8q6XhKt?=
 =?us-ascii?Q?UpBZAA1IB/6HyWyBboLGT3ao44Ej/OHypbCcGFSSYG0IsCcuhy4KWd9B1nut?=
 =?us-ascii?Q?k+9X1Wi5qgie24cayV78uG/8HhKj9aauckFP7pdSaUaARL+eel3hsLeOi+SJ?=
 =?us-ascii?Q?qkKDw/zbwkaPIzWgBsj2zwpUMKdXQZSjNXQBBj5hdNT0OjpAr2mQ8wy1zo4y?=
 =?us-ascii?Q?buMgIknInReABbSKqKxEaVCe6LCbxpmazFMZ1wyLz4vGYyIx39xHbHCfIPwk?=
 =?us-ascii?Q?NwWAJ1QJyx0bhFHwXz3xe86rs3j7Ylaim3z1N6M/wfr8U4Ct4AXhekg0cQ7t?=
 =?us-ascii?Q?Ik33hXnS/oHas5lk665FEyDR31+2VVUNLM3VuCu/cOkmKYUtpIA3Ym1Ai0Et?=
 =?us-ascii?Q?2aBXn7DjKFd9ZDyIE2Q7aRPCRM4Qz3LCQTw486cqZg9YNIA31SQR5aElX5mG?=
 =?us-ascii?Q?Fe7LE4lx4nLkSn0YAb9jjnCNvJm930/eLp+OHGts8ELPPaJ6B8JODXcOdaTe?=
 =?us-ascii?Q?1osANCS0VteWuohU9n4DcP8GxokUVZCWXMDC1VhxZLrC7XP+I2+dKnxOfyFn?=
 =?us-ascii?Q?HYtJqx+T9HX1bsUV3GvjJuNJS6oCgTAk8VlWtEBwL+MgFXeLZpmYGwXsybL7?=
 =?us-ascii?Q?ua99xVIT51+qNfFnMSIRwnAySE8eekB/I8hygmIgG1i/n+6fns5eRAdZvwQW?=
 =?us-ascii?Q?OIA25eLTy5ze4EjP4xxZfKuzZjiVa8IGkaxt29rcnfUgGhc1GIu1mbYT+T8W?=
 =?us-ascii?Q?is8Fe3VC6x5/fER7a6LX2mz8Q6cDDG7OM2sp+JmEGMbGAyqdaUF66qLipWQo?=
 =?us-ascii?Q?CqbBGSPwEtVhtJrZWuH2ZRa5hMh+j/xsntgOUeIeCRGshJYnl1lKZ4xr8Hyi?=
 =?us-ascii?Q?GyXhWBCo8XsEz0zG0g2ttclEHoxZqqscKeH5KOUBVAG62v3TaV6GKhmJW2ms?=
 =?us-ascii?Q?MdSMxN81J7Y2ise4G/O2G5rSiD5Iy8uNfTTIk2VCXVyAC7gYQWhMxyBU7W0b?=
 =?us-ascii?Q?qz19q2z1zKLMOTSYoh24xxdD?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a2a52f0-0529-4ede-2c18-08d9876b683e
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4523.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Oct 2021 19:16:03.2970
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: e5t8PtCzxD8Vkmx0NsP5pw+MqypMNeqj6k1cJhop0xjDRzZLAsIn07/inqdm9gFZWowleBqYeNRE5T03l6hK9w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR03MB7434
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This moves all PCS-related settings to the pcs callbacks. This makes it
easy to support external PCSs. In addition, support for 1000BASE-X is
added (since we need it to set the SGMII mux).

pcs_config should set all registers necessary to bring the link up. In
addition, it needs to keep track of whether it modified anything so that
phylink can restart autonegotiation. config is also the right time to
veto configuration parameters, such as using the wrong interface. This
catches someone trying to use a slower speed (which could be supported
otherwise) after using a faster speed. We can't support this because
phylink doesn't support detaching PCSs.

pcs_link_up is necessary IFF the mode is not in-band and the speed and
duplex are different from what was set in config. However, because the
PCS supports only fixed speed (SPEED_1000 or SPEED_10000) and full
duplex, there is nothing to configure. Therefore, link_up has been
removed.

Now that the autonegotiation is done in pcs_config, we no longer need to
do it in macb_mac_config.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---

 drivers/net/ethernet/cadence/macb_main.c | 214 +++++++++++++++--------
 1 file changed, 138 insertions(+), 76 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index db7acce42a27..08dcccd94f87 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -543,6 +543,7 @@ static void macb_validate(struct phylink_config *config,
 			goto none;
 		fallthrough;
 	case PHY_INTERFACE_MODE_SGMII:
+	case PHY_INTERFACE_MODE_1000BASEX:
 		if (bp->caps & MACB_CAPS_GIGABIT_MODE_AVAILABLE) {
 			phylink_set(mask, 1000baseT_Full);
 			phylink_set(mask, 1000baseX_Full);
@@ -571,25 +572,100 @@ static void macb_validate(struct phylink_config *config,
 		   __ETHTOOL_LINK_MODE_MASK_NBITS);
 }
 
-static void macb_usx_pcs_link_up(struct phylink_pcs *pcs, unsigned int mode,
-				 phy_interface_t interface, int speed,
-				 int duplex)
-{
-	struct macb *bp = container_of(pcs, struct macb, phylink_pcs);
-	u32 config;
-
-	config = gem_readl(bp, USX_CONTROL);
-	config = GEM_BFINS(SERDES_RATE, MACB_SERDES_RATE_10G, config);
-	config = GEM_BFINS(USX_CTRL_SPEED, HS_SPEED_10000M, config);
-	config &= ~(GEM_BIT(TX_SCR_BYPASS) | GEM_BIT(RX_SCR_BYPASS));
-	config |= GEM_BIT(TX_EN);
-	gem_writel(bp, USX_CONTROL, config);
+static inline struct macb *pcs_to_macb(struct phylink_pcs *pcs)
+{
+	return container_of(pcs, struct macb, phylink_pcs);
+}
+
+static void macb_pcs_get_state(struct phylink_pcs *pcs,
+			       struct phylink_link_state *state)
+{
+	struct macb *bp = pcs_to_macb(pcs);
+
+	if (gem_readl(bp, NCFGR) & GEM_BIT(SGMIIEN))
+		state->interface = PHY_INTERFACE_MODE_SGMII;
+	else
+		state->interface = PHY_INTERFACE_MODE_1000BASEX;
+
+	phylink_mii_c22_pcs_decode_state(state, gem_readl(bp, PCSSTS),
+					 gem_readl(bp, PCSANLPBASE));
+}
+
+/**
+ * macb_pcs_config_an() - Configure autonegotiation settings for PCSs
+ * @bp - The macb to operate on
+ * @mode - The autonegotiation mode
+ * @interface - The interface to use
+ * @advertising - The advertisement mask
+ *
+ * This provides common configuration for PCS autonegotiation.
+ *
+ * Context: Call with @bp->lock held.
+ * Return: 1 if any registers were changed; 0 otherwise
+ */
+static int macb_pcs_config_an(struct macb *bp, unsigned int mode,
+			      phy_interface_t interface,
+			      const unsigned long *advertising)
+{
+	bool changed = false;
+	u16 old, new;
+
+	old = gem_readl(bp, PCSANADV);
+	new = phylink_mii_c22_pcs_encode_advertisement(interface, advertising,
+						       old);
+	if (old != new) {
+		changed = true;
+		gem_writel(bp, PCSANADV, new);
+	}
+
+	old = new = gem_readl(bp, PCSCNTRL);
+	if (mode == MLO_AN_INBAND)
+		new |= BMCR_ANENABLE;
+	else
+		new &= ~BMCR_ANENABLE;
+	if (old != new) {
+		changed = true;
+		gem_writel(bp, PCSCNTRL, new);
+	}
+	return changed;
+}
+
+static int macb_pcs_config(struct phylink_pcs *pcs, unsigned int mode,
+			   phy_interface_t interface,
+			   const unsigned long *advertising,
+			   bool permit_pause_to_mac)
+{
+	bool changed = false;
+	struct macb *bp = pcs_to_macb(pcs);
+	u16 old, new;
+	unsigned long flags;
+
+	spin_lock_irqsave(&bp->lock, flags);
+	old = new = gem_readl(bp, NCFGR);
+	if (interface == PHY_INTERFACE_MODE_SGMII) {
+		new |= GEM_BIT(SGMIIEN);
+	} else if (interface == PHY_INTERFACE_MODE_1000BASEX) {
+		new &= ~GEM_BIT(SGMIIEN);
+	} else {
+		spin_lock_irqsave(&bp->lock, flags);
+		return -EOPNOTSUPP;
+	}
+	if (old != new) {
+		changed = true;
+		gem_writel(bp, NCFGR, new);
+	}
+
+	if (macb_pcs_config_an(bp, mode, interface, advertising))
+		changed = true;
+
+	spin_unlock_irqrestore(&bp->lock, flags);
+	return changed;
 }
 
 static void macb_usx_pcs_get_state(struct phylink_pcs *pcs,
 				   struct phylink_link_state *state)
 {
-	struct macb *bp = container_of(pcs, struct macb, phylink_pcs);
+	struct macb *bp = pcs_to_macb(pcs);
 	u32 val;
 
 	state->speed = SPEED_10000;
@@ -609,70 +685,60 @@ static int macb_usx_pcs_config(struct phylink_pcs *pcs,
 			       const unsigned long *advertising,
 			       bool permit_pause_to_mac)
 {
-	struct macb *bp = container_of(pcs, struct macb, phylink_pcs);
+	bool changed;
+	struct macb *bp = pcs_to_macb(pcs);
+	u16 old, new;
+	unsigned long flags;
 
-	gem_writel(bp, USX_CONTROL, gem_readl(bp, USX_CONTROL) |
-		   GEM_BIT(SIGNAL_OK));
+	if (interface != PHY_INTERFACE_MODE_10GBASER)
+		return -EOPNOTSUPP;
 
-	return 0;
-}
+	spin_lock_irqsave(&bp->lock, flags);
+	old = new = gem_readl(bp, NCR);
+	new |= GEM_BIT(ENABLE_HS_MAC);
+	if (old != new) {
+		changed = true;
+		gem_writel(bp, NCFGR, new);
+	}
 
-static void macb_pcs_get_state(struct phylink_pcs *pcs,
-			       struct phylink_link_state *state)
-{
-	state->link = 0;
-}
+	if (macb_pcs_config_an(bp, mode, interface, advertising))
+		changed = true;
 
-static void macb_pcs_an_restart(struct phylink_pcs *pcs)
-{
-	/* Not supported */
-}
+	old = new = gem_readl(bp, USX_CONTROL);
+	new |= GEM_BIT(SIGNAL_OK);
+	if (old != new) {
+		changed = true;
+		gem_writel(bp, USX_CONTROL, new);
+	}
 
-static int macb_pcs_config(struct phylink_pcs *pcs,
-			   unsigned int mode,
-			   phy_interface_t interface,
-			   const unsigned long *advertising,
-			   bool permit_pause_to_mac)
-{
-	return 0;
+	old = new = gem_readl(bp, USX_CONTROL);
+	new = GEM_BFINS(SERDES_RATE, MACB_SERDES_RATE_10G, new);
+	new = GEM_BFINS(USX_CTRL_SPEED, HS_SPEED_10000M, new);
+	new &= ~(GEM_BIT(TX_SCR_BYPASS) | GEM_BIT(RX_SCR_BYPASS));
+	new |= GEM_BIT(TX_EN);
+	if (old != new) {
+		changed = true;
+		gem_writel(bp, USX_CONTROL, new);
+	}
+
+	spin_unlock_irqrestore(&bp->lock, flags);
+	return changed;
 }
 
 static const struct phylink_pcs_ops macb_phylink_usx_pcs_ops = {
 	.pcs_get_state = macb_usx_pcs_get_state,
 	.pcs_config = macb_usx_pcs_config,
-	.pcs_link_up = macb_usx_pcs_link_up,
 };
 
 static const struct phylink_pcs_ops macb_phylink_pcs_ops = {
 	.pcs_get_state = macb_pcs_get_state,
-	.pcs_an_restart = macb_pcs_an_restart,
 	.pcs_config = macb_pcs_config,
 };
 
 static void macb_mac_config(struct phylink_config *config, unsigned int mode,
 			    const struct phylink_link_state *state)
 {
-	unsigned long flags;
-
-	spin_lock_irqsave(&bp->lock, flags);
-
-	/* Disable AN for SGMII fixed link configuration, enable otherwise.
-	 * Must be written after PCSSEL is set in NCFGR,
-	 * otherwise writes will not take effect.
-	 */
-	if (macb_is_gem(bp) && state->interface == PHY_INTERFACE_MODE_SGMII) {
-		u32 pcsctrl, old_pcsctrl;
-
-		old_pcsctrl = gem_readl(bp, PCSCNTRL);
-		if (mode == MLO_AN_FIXED)
-			pcsctrl = old_pcsctrl & ~GEM_BIT(PCSAUTONEG);
-		else
-			pcsctrl = old_pcsctrl | GEM_BIT(PCSAUTONEG);
-		if (old_pcsctrl != pcsctrl)
-			gem_writel(bp, PCSCNTRL, pcsctrl);
-	}
-
-	spin_unlock_irqrestore(&bp->lock, flags);
+	/* Nothing to do */
 }
 
 static void macb_mac_link_down(struct phylink_config *config, unsigned int mode,
@@ -763,20 +829,23 @@ static void macb_mac_link_up(struct phylink_config *config,
 static int macb_mac_prepare(struct phylink_config *config, unsigned int mode,
 			    phy_interface_t interface)
 {
+	int set_pcs = 0;
 	struct net_device *ndev = to_net_dev(config->dev);
 	struct macb *bp = netdev_priv(ndev);
 	unsigned long flags;
 	u32 old_ctrl, ctrl;
 	u32 old_ncr, ncr;
 
-	if (interface == PHY_INTERFACE_MODE_10GBASER)
+	if (interface == PHY_INTERFACE_MODE_10GBASER) {
 		bp->phylink_pcs.ops = &macb_phylink_usx_pcs_ops;
-	else if (interface == PHY_INTERFACE_MODE_SGMII)
+		set_pcs = 1;
+	} else if (interface == PHY_INTERFACE_MODE_SGMII ||
+		   interface == PHY_INTERFACE_MODE_1000BASEX) {
 		bp->phylink_pcs.ops = &macb_phylink_pcs_ops;
-	else
-		bp->phylink_pcs.ops = NULL;
+		set_pcs = 1;
+	}
 
-	if (bp->phylink_pcs.ops)
+	if (set_pcs)
 		phylink_set_pcs(bp->phylink, &bp->phylink_pcs);
 
 	spin_lock_irqsave(&bp->lock, flags);
@@ -787,21 +856,14 @@ static int macb_mac_prepare(struct phylink_config *config, unsigned int mode,
 	if (bp->caps & MACB_CAPS_MACB_IS_EMAC) {
 		if (interface == PHY_INTERFACE_MODE_RMII)
 			ctrl |= MACB_BIT(RM9200_RMII);
-	} else if (macb_is_gem(bp)) {
-		ctrl &= ~(GEM_BIT(SGMIIEN) | GEM_BIT(PCSSEL));
-		ncr &= ~GEM_BIT(ENABLE_HS_MAC);
-
-		if (state->interface == PHY_INTERFACE_MODE_SGMII) {
-			ctrl |= GEM_BIT(SGMIIEN) | GEM_BIT(PCSSEL);
-		} else if (state->interface == PHY_INTERFACE_MODE_10GBASER) {
-			ctrl |= GEM_BIT(PCSSEL);
-			ncr |= GEM_BIT(ENABLE_HS_MAC);
-		} else if (bp->caps & MACB_CAPS_MIIONRGMII &&
-			   bp->phy_interface == PHY_INTERFACE_MODE_MII) {
-			ncr |= MACB_BIT(MIIONRGMII);
-		}
+	} else if (bp->caps & MACB_CAPS_MIIONRGMII &&
+		   bp->phy_interface == PHY_INTERFACE_MODE_MII) {
+		ncr |= MACB_BIT(MIIONRGMII);
 	}
 
+	if (macb_is_gem(bp) && set_pcs)
+		ctrl |= GEM_BIT(PCSSEL);
+
 	/* Apply the new configuration, if any */
 	if (old_ctrl ^ ctrl)
 		macb_or_gem_writel(bp, NCFGR, ctrl);
-- 
2.25.1

