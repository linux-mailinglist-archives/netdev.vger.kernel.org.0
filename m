Return-Path: <netdev+bounces-4273-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 07EFC70BDC3
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 14:24:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A59792808EC
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 12:24:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4CDFA154AF;
	Mon, 22 May 2023 12:17:13 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 395C015485
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 12:17:13 +0000 (UTC)
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55EA81FDC;
	Mon, 22 May 2023 05:16:56 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id a640c23a62f3a-96f99222e80so449312066b.1;
        Mon, 22 May 2023 05:16:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684757812; x=1687349812;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=s+JRNPJ5cx2jMWG0IRYy24A0cOZNPYpGwtWM1ZXhhGY=;
        b=mKFqhMSx/xXAeZmR+tLG13hzarkfEAe/1HfDp2XnKwEbTHrdpdAA1KnoFi1k6GKiBD
         vBfNntGXR7wMJJvpx+n46YDY4oNL9zY9eD1RcUWdIRA8ByzBNRb6XZttJR0kWSY+CmI4
         fmmy/SJemYC43Djzi18JisnZvepnk0lLAcCAufKoH03Eux4AIGjhR0Ctf0WBgTQbXD59
         UuMAzUQHDGRovJW3qMREcv/ibsAsCdxDIH464s638ED4NcLV5PL1Zx1nTCySARc3dZmS
         4PZga7LAVOIpTlol+svUGokQfLjpaByY5oUA4tUAH8j/Gg3ZFjNe2fr+11dev6QDitru
         veig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684757812; x=1687349812;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=s+JRNPJ5cx2jMWG0IRYy24A0cOZNPYpGwtWM1ZXhhGY=;
        b=lOyvSVzSoTNMaWdsNfUDe8CbdMLhZn0ewdVFyeiHGX9oGMN1KWFNP4na5dq/B1ui55
         i4pZAutN6va97Vt4E107FZkF4KB0LjkL5lEjlguHA473hmyxxyAC6C0dwBfXKhB1eb+Y
         PmYWJwUlSz2EtiFw7x22VpIOKL8vMNmNUbOp9XTXECHRxhRh3PnablsUkq4D0xya18DX
         hYefzcqRjq2R5FXhp2eXvtndnOMcLWiXgrG5fojKHyz+Cr3lgVhy7xK1O7An2TbdlM1/
         zKWG/IYnpPKjecHVmPobeXEmQ15d1FT7mJJOSaf7GQ/4EY0O1wUxNWak8unmRW8bx6Ne
         WAJw==
X-Gm-Message-State: AC+VfDyMqhHIdOZ7Qe0zBLG1ZKWhvDrzBSEFZr1sd/XIJ6vkWfKU0mkr
	Mz/Ny4QzN6rzcq6z5LNtwiM=
X-Google-Smtp-Source: ACHHUZ74tzGrUpDgLxpoRmjLRyrJEfA9H60gIxyMad4XSXFKvHN8dQVencPxbwxKbgaUKz1iTRgnog==
X-Received: by 2002:a17:907:3da1:b0:958:46aa:7f99 with SMTP id he33-20020a1709073da100b0095846aa7f99mr9889877ejc.7.1684757812111;
        Mon, 22 May 2023 05:16:52 -0700 (PDT)
Received: from arinc9-PC.. ([149.91.1.15])
        by smtp.gmail.com with ESMTPSA id y26-20020a17090614da00b009659fed3612sm2999950ejc.24.2023.05.22.05.16.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 May 2023 05:16:51 -0700 (PDT)
From: arinc9.unal@gmail.com
X-Google-Original-From: arinc.unal@arinc9.com
To: Sean Wang <sean.wang@mediatek.com>,
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
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Russell King <linux@armlinux.org.uk>
Cc: =?UTF-8?q?Ar=C4=B1n=C3=A7=20=C3=9CNAL?= <arinc.unal@arinc9.com>,
	Richard van Schagen <richard@routerhints.com>,
	Richard van Schagen <vschagen@cs.com>,
	Frank Wunderlich <frank-w@public-files.de>,
	Bartel Eerdekens <bartel.eerdekens@constell8.be>,
	erkin.bozoglu@xeront.com,
	mithat.guner@xeront.com,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: [PATCH net-next 22/30] net: dsa: mt7530: rename p5_intf_sel and use only for MT7530 switch
Date: Mon, 22 May 2023 15:15:24 +0300
Message-Id: <20230522121532.86610-23-arinc.unal@arinc9.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230522121532.86610-1-arinc.unal@arinc9.com>
References: <20230522121532.86610-1-arinc.unal@arinc9.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

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
index 996b8c02cb05..19afcd914109 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -868,19 +868,15 @@ mt7530_set_ageing_time(struct dsa_switch *ds, unsigned int msecs)
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
 
@@ -897,23 +893,21 @@ static void mt7530_setup_port5(struct dsa_switch *ds, phy_interface_t interface)
 	val |= MHWTRAP_P5_MAC_SEL | MHWTRAP_P5_DIS;
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
 
@@ -937,8 +931,8 @@ static void mt7530_setup_port5(struct dsa_switch *ds, phy_interface_t interface)
 
 	mt7530_write(priv, MT7530_MHWTRAP, val);
 
-	dev_dbg(ds->dev, "Setup P5, HWTRAP=0x%x, intf_sel=%s, phy-mode=%s\n",
-		val, p5_intf_modes(priv->p5_intf_sel), phy_modes(interface));
+	dev_dbg(ds->dev, "Setup P5, HWTRAP=0x%x, mode=%s, phy-mode=%s\n", val,
+		mt7530_p5_mode_str(priv->p5_mode), phy_modes(interface));
 
 	mutex_unlock(&priv->reg_mutex);
 }
@@ -2254,13 +2248,11 @@ mt7530_setup(struct dsa_switch *ds)
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
@@ -2284,17 +2276,17 @@ mt7530_setup(struct dsa_switch *ds)
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
 
@@ -2433,9 +2425,6 @@ mt7531_setup(struct dsa_switch *ds)
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
2.39.2


