Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 387496EAD3F
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 16:40:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232618AbjDUOkB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 10:40:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232932AbjDUOj3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 10:39:29 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17C9C15467;
        Fri, 21 Apr 2023 07:38:00 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id a640c23a62f3a-94f6c285d22so288950666b.2;
        Fri, 21 Apr 2023 07:38:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682087863; x=1684679863;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZmJp66E7f+Y6znObj42iK8swVGPa549Lcio15ZPSnxQ=;
        b=XHY8SQ0nVRKoZTcLzj4l+LM5LQOi8vlGiwQ8QoZI9l9DoGKtf1oaT+Pvrqs5SYtQNC
         E1Cbp25l2IAMrunqWeAVFKQ58dOvSlKEhVWTr86vD8ThF+pbDbeKQa3/9YtGxVg/hgb6
         CtPBuW6XBrT0g2RvqCY8NSwKoto8XFK3yjRMJBXK6vDpIHYlXXbbfjjXXsWJJMgyZpbg
         /6XqE566YLIzLZu50HHjScG+6S3nzGnJgL6pWYhGjhQPslMG0EkraTr+rdXUpcVyOFZA
         mT1AWFhTnNtL0OJ7meUXco+omY1i9zKP9MklOigmu2QjhojyT35rHQX9jMxdWOF2FoUM
         kuFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682087863; x=1684679863;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZmJp66E7f+Y6znObj42iK8swVGPa549Lcio15ZPSnxQ=;
        b=XyObPe2I1nN9wPvX6+IAle8L0mfucqRixr6iXnlru4OzWzdzFBgm9f1/a3Uu/OHTdx
         n0NgMfCOTPBYFvgq9rV4Y28GkP79paxpP028PhujKPIxt0/c+HhjDM/4BT3bIpUQ6SwD
         dx/22bCq+iq/gGWVOZH7Icsehzd3FSLTMJCps57GSTwXiNhua9lvyc3fCHlpaKrS9rs5
         NgZiZwsKJbMrIpIAxOKcTfgk8rq8tkv7Ls1M7tJUfW2fGR2HOv9jvrt1uYlAyMH+VJ8r
         ESAT/Oe5nFOy1XkVszaWTZrhBSxgDzdA0o59ED3rijTubsOK8GIZBXy9WieGV/TLVyut
         7joQ==
X-Gm-Message-State: AAQBX9dOMnkzc4kFDeKczJ9KE2bz3jidn36+OqQ2f4aRzIbiTrUMJvK7
        hZTx1zFGrbR4YGsuqDi1S9Y=
X-Google-Smtp-Source: AKy350awrJxVPyo3L53jJ5gYw7X144Hv7XTVmv+bBVZdnRD1U32Up7K/6/LnxfMVoGT02rrdv/xbVg==
X-Received: by 2002:a17:906:63d1:b0:94f:cee:56f2 with SMTP id u17-20020a17090663d100b0094f0cee56f2mr2546057ejk.4.1682087863051;
        Fri, 21 Apr 2023 07:37:43 -0700 (PDT)
Received: from arinc9-PC.lan ([149.91.1.15])
        by smtp.gmail.com with ESMTPSA id q27-20020a170906361b00b0094e1026bc66sm2168244ejb.140.2023.04.21.07.37.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Apr 2023 07:37:42 -0700 (PDT)
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
        erkin.bozoglu@xeront.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [RFC PATCH net-next 22/22] net: dsa: mt7530: rename p5_intf_sel and use only for MT7530 switch
Date:   Fri, 21 Apr 2023 17:36:48 +0300
Message-Id: <20230421143648.87889-23-arinc.unal@arinc9.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20230421143648.87889-1-arinc.unal@arinc9.com>
References: <20230421143648.87889-1-arinc.unal@arinc9.com>
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
index 3d19e06061cb..63b108ef5e0e 100644
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
 
@@ -2444,9 +2436,6 @@ mt7531_setup(struct dsa_switch *ds)
 			   MT7531_EXT_P_MDIO_12);
 	}
 
-	if (!dsa_is_unused_port(ds, 5))
-		priv->p5_intf_sel = P5_INTF_SEL_GMAC5;
-
 	mt7530_rmw(priv, MT7531_GPIO_MODE0, MT7531_GPIO0_MASK,
 		   MT7531_GPIO0_INTERRUPT);
 
diff --git a/drivers/net/dsa/mt7530.h b/drivers/net/dsa/mt7530.h
index ee2b3d2d6258..8187d77603f8 100644
--- a/drivers/net/dsa/mt7530.h
+++ b/drivers/net/dsa/mt7530.h
@@ -673,13 +673,12 @@ struct mt7530_port {
 	struct phylink_pcs *sgmii_pcs;
 };
 
-/* Port 5 interface select definitions */
+/* Port 5 mode definitions of the MT7530 switch */
 typedef enum {
-	P5_DISABLED,
-	P5_INTF_SEL_PHY_P0,
-	P5_INTF_SEL_PHY_P4,
-	P5_INTF_SEL_GMAC5,
-} p5_interface_select;
+	GMAC5,
+	MUX_PHY_P0,
+	MUX_PHY_P4,
+} mt7530_p5_mode;
 
 struct mt7530_priv;
 
@@ -746,7 +745,7 @@ struct mt753x_info {
  *			is already configured
  * @p5_configured:	Flag for distinguishing if port 5 of the MT7531 switch
  *			is already configured
- * @p5_intf_sel:	Holding the current port 5 interface select
+ * @p5_mode:		Holding the current port 5 mode of the MT7530 switch
  * @p5_sgmii:		Flag for distinguishing if port 5 of the MT7531 switch
  *			has got SGMII
  * @irq:		IRQ number of the switch
@@ -768,7 +767,7 @@ struct mt7530_priv {
 	bool			mcm;
 	bool			p6_configured;
 	bool			p5_configured;
-	p5_interface_select	p5_intf_sel;
+	mt7530_p5_mode		p5_mode;
 	bool			p5_sgmii;
 	u8			mirror_rx;
 	u8			mirror_tx;
-- 
2.37.2

