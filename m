Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7F456EDE2F
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 10:33:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233885AbjDYIdR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Apr 2023 04:33:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233737AbjDYIb4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Apr 2023 04:31:56 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30BF37AB1;
        Tue, 25 Apr 2023 01:30:53 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id a640c23a62f3a-95316faa3a8so1013966266b.2;
        Tue, 25 Apr 2023 01:30:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682411449; x=1685003449;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=10hUTTcmahp2tBIAMfzRAM9yRC1rZ81w/tMjXfO7ST8=;
        b=QGt84At4UtkgPRyfFddq0R3HzJTTtj5uqWtMQytu7+91AuSi+6sS7yVqpwzBQhsRhS
         3xei0GRafWRqyZ9J2c61dxdB1Z+VG2MBDRzZ/hcNMK/ddKr80dmEbl0MdJAx457TRIOp
         wFhxwoFvpKnQbBQv3pjKwKvwl+oU4dcZjqYJD7nbzI87+zWm8CVOnr4u6mrJwOF05w+7
         UclyNwYNBUsT0Vt72dwr+/+ClUvxSe71Ur2Yl1r8U7JYMib0hzViyBI8OAYGSHoAEUwU
         S9QC07P69ZK+O84NymxK4wdJBAm+XlUGI2D16i4SSXea9l1SVmS0dFDnT2baWkgX7BBT
         rSFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682411449; x=1685003449;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=10hUTTcmahp2tBIAMfzRAM9yRC1rZ81w/tMjXfO7ST8=;
        b=VEdCeVCZYNNWWy6f0U70vcFX1uPd099aA1ALu8dvhOtFVX5AfWvXwb6OGBiwKOiWdx
         N+AnOwWj4vNWmnC1DMOnkBgUcfAzkdCQ/NQDdf1B2wPAXdzsuiRV/IHfrAyd4OG/ktAG
         3B5TBFRvQmiLV8CZO9BQAIcRsBAK/ioeeGzdlcKUCQVrgMyBl2kyy8/6txiGOJw9fzOG
         co3iUMZy1LnMDATnFjW0WEUeIo/CjTyUXqA36BNftjB//P2KCVqAK8AjlE6PBQJ6u8/f
         bYvl8cDl+TraAOzOZCkh4xcxYdKihhXoDzHaYTNzmvPfKyq+9UL43viUJ90F9XrgtMAW
         tzTA==
X-Gm-Message-State: AAQBX9cW9MRIR2534QYUkPhbkVHQA0JrDAQev1kEcQhslgfV+lbnct3S
        zH4MET8gNvk3mTXXfyUTQqc=
X-Google-Smtp-Source: AKy350bqHbid3BlYYyF4dEkTe1wn5KqUPyqhqYQ28j7uhRvjflQ9DizrxcGcSmDZ7Z3uQO0amkXthQ==
X-Received: by 2002:a17:907:1b89:b0:94f:7a8:a902 with SMTP id mz9-20020a1709071b8900b0094f07a8a902mr9893507ejc.14.1682411448956;
        Tue, 25 Apr 2023 01:30:48 -0700 (PDT)
Received: from arinc9-PC.lan ([149.91.1.15])
        by smtp.gmail.com with ESMTPSA id mc2-20020a170906eb4200b0094ca077c985sm6439028ejb.213.2023.04.25.01.30.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Apr 2023 01:30:48 -0700 (PDT)
From:   arinc9.unal@gmail.com
X-Google-Original-From: arinc.unal@arinc9.com
To:     Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Daniel Golle <daniel@makrotopia.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     =?UTF-8?q?Ar=C4=B1n=C3=A7=20=C3=9CNAL?= <arinc.unal@arinc9.com>,
        Richard van Schagen <richard@routerhints.com>,
        Richard van Schagen <vschagen@cs.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        Bartel Eerdekens <bartel.eerdekens@constell8.be>,
        erkin.bozoglu@xeront.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH net-next 23/24] net: dsa: mt7530: rename p5_intf_sel and use only for MT7530 switch
Date:   Tue, 25 Apr 2023 11:29:32 +0300
Message-Id: <20230425082933.84654-24-arinc.unal@arinc9.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20230425082933.84654-1-arinc.unal@arinc9.com>
References: <20230425082933.84654-1-arinc.unal@arinc9.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arınç ÜNAL <arinc.unal@arinc9.com>

The p5_intf_sel pointer is used to store the information of whether PHY
muxing is used or not. PHY muxing is a feature specific to port 5 of the
MT7530 switch. Do not use it for other switch models.

Rename the pointer to p5_mode to store the mode the port is being used in.
Rename the p5_interface_select enum to mt7530_p5_mode, the string
representation to mt7530_p5_mode_str, and the enum elements.

If PHY muxing is not detected, the default mode, GMAC5, will be used.

Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
---
 drivers/net/dsa/mt7530.c | 61 ++++++++++++++++------------------------
 drivers/net/dsa/mt7530.h | 15 +++++-----
 2 files changed, 32 insertions(+), 44 deletions(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 02e6ba5a4403..62e55df273cc 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -873,19 +873,15 @@ mt7530_set_ageing_time(struct dsa_switch *ds, unsigned int msecs)
 	return 0;
 }
 
-static const char *p5_intf_modes(unsigned int p5_interface)
-{
-	switch (p5_interface) {
-	case P5_DISABLED:
-		return "DISABLED";
-	case P5_INTF_SEL_PHY_P0:
-		return "PHY P0";
-	case P5_INTF_SEL_PHY_P4:
-		return "PHY P4";
-	case P5_INTF_SEL_GMAC5:
-		return "GMAC5";
+static const char *mt7530_p5_mode_str(unsigned int mode)
+{
+	switch (mode) {
+	case MUX_PHY_P0:
+		return "MUX PHY P0";
+	case MUX_PHY_P4:
+		return "MUX PHY P4";
 	default:
-		return "unknown";
+		return "GMAC5";
 	}
 }
 
@@ -902,23 +898,21 @@ static void mt7530_setup_port5(struct dsa_switch *ds, phy_interface_t interface)
 	val |= MHWTRAP_MANUAL | MHWTRAP_P5_MAC_SEL | MHWTRAP_P5_DIS;
 	val &= ~MHWTRAP_P5_RGMII_MODE & ~MHWTRAP_PHY0_SEL;
 
-	switch (priv->p5_intf_sel) {
-	case P5_INTF_SEL_PHY_P0:
-		/* MT7530_P5_MODE_GPHY_P0: 2nd GMAC -> P5 -> P0 */
+	switch (priv->p5_mode) {
+	case MUX_PHY_P0:
+		/* MUX_PHY_P0: P0 -> P5 -> SoC MAC */
 		val |= MHWTRAP_PHY0_SEL;
 		fallthrough;
-	case P5_INTF_SEL_PHY_P4:
-		/* MT7530_P5_MODE_GPHY_P4: 2nd GMAC -> P5 -> P4 */
+	case MUX_PHY_P4:
+		/* MUX_PHY_P4: P4 -> P5 -> SoC MAC */
 		val &= ~MHWTRAP_P5_MAC_SEL & ~MHWTRAP_P5_DIS;
 
 		/* Setup the MAC by default for the cpu port */
 		mt7530_write(priv, MT7530_PMCR_P(5), 0x56300);
 		break;
-	case P5_INTF_SEL_GMAC5:
-		/* MT7530_P5_MODE_GMAC: P5 -> External phy or 2nd GMAC */
-		val &= ~MHWTRAP_P5_DIS;
-		break;
 	default:
+		/* GMAC5: P5 -> SoC MAC or external PHY */
+		val &= ~MHWTRAP_P5_DIS;
 		break;
 	}
 
@@ -942,8 +936,8 @@ static void mt7530_setup_port5(struct dsa_switch *ds, phy_interface_t interface)
 
 	mt7530_write(priv, MT7530_MHWTRAP, val);
 
-	dev_dbg(ds->dev, "Setup P5, HWTRAP=0x%x, intf_sel=%s, phy-mode=%s\n",
-		val, p5_intf_modes(priv->p5_intf_sel), phy_modes(interface));
+	dev_dbg(ds->dev, "Setup P5, HWTRAP=0x%x, mode=%s, phy-mode=%s\n", val,
+		mt7530_p5_mode_str(priv->p5_mode), phy_modes(interface));
 
 	mutex_unlock(&priv->reg_mutex);
 }
@@ -2261,13 +2255,11 @@ mt7530_setup(struct dsa_switch *ds)
 	if (ret)
 		return ret;
 
-	/* Setup port 5 */
-	if (!dsa_is_unused_port(ds, 5)) {
-		priv->p5_intf_sel = P5_INTF_SEL_GMAC5;
-	} else {
+	/* Check for PHY muxing on port 5 */
+	if (dsa_is_unused_port(ds, 5)) {
 		/* Scan the ethernet nodes. Look for GMAC1, lookup the used PHY.
-		 * Set priv->p5_intf_sel to the appropriate value if PHY muxing
-		 * is detected.
+		 * Set priv->p5_mode to the appropriate value if PHY muxing is
+		 * detected.
 		 */
 		for_each_child_of_node(dn, mac_np) {
 			if (!of_device_is_compatible(mac_np,
@@ -2291,17 +2283,17 @@ mt7530_setup(struct dsa_switch *ds)
 				}
 				id = of_mdio_parse_addr(ds->dev, phy_node);
 				if (id == 0)
-					priv->p5_intf_sel = P5_INTF_SEL_PHY_P0;
+					priv->p5_mode = MUX_PHY_P0;
 				if (id == 4)
-					priv->p5_intf_sel = P5_INTF_SEL_PHY_P4;
+					priv->p5_mode = MUX_PHY_P4;
 			}
 			of_node_put(mac_np);
 			of_node_put(phy_node);
 			break;
 		}
 
-		if (priv->p5_intf_sel == P5_INTF_SEL_PHY_P0 ||
-		    priv->p5_intf_sel == P5_INTF_SEL_PHY_P4)
+		if (priv->p5_mode == MUX_PHY_P0 ||
+		    priv->p5_mode == MUX_PHY_P4)
 			mt7530_setup_port5(ds, interface);
 	}
 
@@ -2438,9 +2430,6 @@ mt7531_setup(struct dsa_switch *ds)
 			   MT7531_EXT_P_MDIO_12);
 	}
 
-	if (!dsa_is_unused_port(ds, 5))
-		priv->p5_intf_sel = P5_INTF_SEL_GMAC5;
-
 	mt7530_rmw(priv, MT7531_GPIO_MODE0, MT7531_GPIO0_MASK,
 		   MT7531_GPIO0_INTERRUPT);
 
diff --git a/drivers/net/dsa/mt7530.h b/drivers/net/dsa/mt7530.h
index b7f80a487073..216081fb1c12 100644
--- a/drivers/net/dsa/mt7530.h
+++ b/drivers/net/dsa/mt7530.h
@@ -673,12 +673,11 @@ struct mt7530_port {
 	struct phylink_pcs *sgmii_pcs;
 };
 
-/* Port 5 interface select definitions */
-enum p5_interface_select {
-	P5_DISABLED,
-	P5_INTF_SEL_PHY_P0,
-	P5_INTF_SEL_PHY_P4,
-	P5_INTF_SEL_GMAC5,
+/* Port 5 mode definitions of the MT7530 switch */
+enum mt7530_p5_mode {
+	GMAC5,
+	MUX_PHY_P0,
+	MUX_PHY_P4,
 };
 
 struct mt7530_priv;
@@ -746,7 +745,7 @@ struct mt753x_info {
  *			is already configured
  * @p5_configured:	Flag for distinguishing if port 5 of the MT7531 switch
  *			is already configured
- * @p5_intf_sel:	Holding the current port 5 interface select
+ * @p5_mode:		Holding the current mode of port 5 of the MT7530 switch
  * @p5_sgmii:		Flag for distinguishing if port 5 of the MT7531 switch
  *			has got SGMII
  * @irq:		IRQ number of the switch
@@ -768,7 +767,7 @@ struct mt7530_priv {
 	bool			mcm;
 	bool			p6_configured;
 	bool			p5_configured;
-	enum p5_interface_select p5_intf_sel;
+	enum mt7530_p5_mode	p5_mode;
 	bool			p5_sgmii;
 	u8			mirror_rx;
 	u8			mirror_tx;
-- 
2.37.2

