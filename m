Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A61F75806EF
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 23:50:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237131AbiGYVuF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 17:50:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236826AbiGYVtx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 17:49:53 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4FF0220D5;
        Mon, 25 Jul 2022 14:49:52 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id z1-20020a17090a170100b001f2e643b299so966471pjd.3;
        Mon, 25 Jul 2022 14:49:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=u/zGWLqFXLX5XPvENmT0BJTHNYBYQ4uAB0ozt0RhCDo=;
        b=d7LC8VLu3R6SfClNvZsawVHiITO5tWDKbrReYyf4BJbmoxf9V9uwGgiB2acX9p2MT7
         Av4TAESXSkVCv4gvCc+SH1DbJWznP4ff7h+9E5bSA5UCqluPylt/RGngGdDRZ/fGUwo7
         bVcbQH5KjSdAEBAtw/dHURCZsRBITuqkF09HNy+F51BhLVd+Zkxhsjy0dNbV2t9gcjoN
         4DqJrRlhrrBkNb0f7a6pkaL8NVYzriYOJgwNvyFRlbH0a9HaEtjkzg6YvkoFl2YUHAJS
         Fp1UoZoZWs6WFbHwzET42qokAVFXEP8z/uaO/GC3zSa2iVdWu4Fp/lRDeeVyN5EKzlws
         CxSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=u/zGWLqFXLX5XPvENmT0BJTHNYBYQ4uAB0ozt0RhCDo=;
        b=wuhlEZgNlz7oAagfwGKMgTreDnE6ul0tMTlM4WMZIV3IaKcF416eK7CGUw88YHQl2J
         GWS+pi1R0XXNdS3WascOj90v3vGc7ZpRNWv8DF3a6Z39iXqc5VvSfnvPkQ/eKJRnUpdy
         sWQjP40f/TeqMFglaViWq5lpOQSVZyqS9RxlN4nkgWxjT6gJ2zmPsOFq+VPD2MeU3S6n
         XEyM7psbE2afZxQ9yPlTxYTCoPPwv+PgrLIn+6+Flcm8JjTJHBGg7JIESARtrDF2MsLM
         4CsJ0v1+wNg1JzWdeCcuNHrBH4RHg83tzjC2ISoCsV0onHiJE8BwLlGVvwPDFwzvjNIK
         biPA==
X-Gm-Message-State: AJIora/h98b3awzVWS3chSwkTrNSGlCo/N/kR4J0zoF+0qyFsrwb5su5
        IjZg5xUgIK0dla+45us0RFGM/q70/Wg=
X-Google-Smtp-Source: AGRyM1uj3yKJR0BmZT71+bn4hEgIvzZLV6/zYdtlmyY1fzaGwy898+DVZjHmt9GBtH1XZqAKhVHMDg==
X-Received: by 2002:a17:903:2307:b0:16d:8a08:fa79 with SMTP id d7-20020a170903230700b0016d8a08fa79mr3538062plh.100.1658785792075;
        Mon, 25 Jul 2022 14:49:52 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id c5-20020a637245000000b004161b3c3388sm9086551pgn.26.2022.07.25.14.49.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jul 2022 14:49:51 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [RFC net-next 2/2] net: dsa: bcm_sf2: Have PHYLINK configure CPU/IMP port(s)
Date:   Mon, 25 Jul 2022 14:49:42 -0700
Message-Id: <20220725214942.97207-3-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220725214942.97207-1-f.fainelli@gmail.com>
References: <20220725214942.97207-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove the artificial limitations imposed upon
bcm_sf2_sw_mac_link_{up,down} and allow us to override the link
parameters for IMP port(s) as well as regular ports by accounting for
the special differences that exist there.

Remove the code that did override the link parameters in
bcm_sf2_imp_setup().

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/dsa/bcm_sf2.c | 95 ++++++++++++++++++---------------------
 1 file changed, 43 insertions(+), 52 deletions(-)

diff --git a/drivers/net/dsa/bcm_sf2.c b/drivers/net/dsa/bcm_sf2.c
index 10de0cffa047..572f7450b527 100644
--- a/drivers/net/dsa/bcm_sf2.c
+++ b/drivers/net/dsa/bcm_sf2.c
@@ -159,7 +159,7 @@ static void bcm_sf2_imp_setup(struct dsa_switch *ds, int port)
 {
 	struct bcm_sf2_priv *priv = bcm_sf2_to_priv(ds);
 	unsigned int i;
-	u32 reg, offset;
+	u32 reg;
 
 	/* Enable the port memories */
 	reg = core_readl(priv, CORE_MEM_PSM_VDD_CTRL);
@@ -185,17 +185,6 @@ static void bcm_sf2_imp_setup(struct dsa_switch *ds, int port)
 	b53_brcm_hdr_setup(ds, port);
 
 	if (port == 8) {
-		offset = bcm_sf2_port_override_offset(priv, port);
-
-		/* Force link status for IMP port */
-		reg = core_readl(priv, offset);
-		reg |= (MII_SW_OR | LINK_STS);
-		if (priv->type == BCM4908_DEVICE_ID)
-			reg |= GMII_SPEED_UP_2G;
-		else
-			reg &= ~GMII_SPEED_UP_2G;
-		core_writel(priv, reg, offset);
-
 		/* Enable Broadcast, Multicast, Unicast forwarding to IMP port */
 		reg = core_readl(priv, CORE_IMP_CTL);
 		reg |= (RX_BCST_EN | RX_MCST_EN | RX_UCST_EN);
@@ -826,12 +815,10 @@ static void bcm_sf2_sw_mac_link_down(struct dsa_switch *ds, int port,
 	if (priv->wol_ports_mask & BIT(port))
 		return;
 
-	if (port != core_readl(priv, CORE_IMP0_PRT_ID)) {
-		offset = bcm_sf2_port_override_offset(priv, port);
-		reg = core_readl(priv, offset);
-		reg &= ~LINK_STS;
-		core_writel(priv, reg, offset);
-	}
+	offset = bcm_sf2_port_override_offset(priv, port);
+	reg = core_readl(priv, offset);
+	reg &= ~LINK_STS;
+	core_writel(priv, reg, offset);
 
 	bcm_sf2_sw_mac_link_set(ds, port, interface, false);
 }
@@ -845,51 +832,55 @@ static void bcm_sf2_sw_mac_link_up(struct dsa_switch *ds, int port,
 {
 	struct bcm_sf2_priv *priv = bcm_sf2_to_priv(ds);
 	struct ethtool_eee *p = &priv->dev->ports[port].eee;
+	u32 reg_rgmii_ctrl = 0;
+	u32 reg, offset;
 
 	bcm_sf2_sw_mac_link_set(ds, port, interface, true);
 
-	if (port != core_readl(priv, CORE_IMP0_PRT_ID)) {
-		u32 reg_rgmii_ctrl = 0;
-		u32 reg, offset;
+	offset = bcm_sf2_port_override_offset(priv, port);
 
-		offset = bcm_sf2_port_override_offset(priv, port);
+	if (phy_interface_mode_is_rgmii(interface) ||
+	    interface == PHY_INTERFACE_MODE_MII ||
+	    interface == PHY_INTERFACE_MODE_REVMII) {
+		reg_rgmii_ctrl = bcm_sf2_reg_rgmii_cntrl(priv, port);
+		reg = reg_readl(priv, reg_rgmii_ctrl);
+		reg &= ~(RX_PAUSE_EN | TX_PAUSE_EN);
 
-		if (interface == PHY_INTERFACE_MODE_RGMII ||
-		    interface == PHY_INTERFACE_MODE_RGMII_TXID ||
-		    interface == PHY_INTERFACE_MODE_MII ||
-		    interface == PHY_INTERFACE_MODE_REVMII) {
-			reg_rgmii_ctrl = bcm_sf2_reg_rgmii_cntrl(priv, port);
-			reg = reg_readl(priv, reg_rgmii_ctrl);
-			reg &= ~(RX_PAUSE_EN | TX_PAUSE_EN);
+		if (tx_pause)
+			reg |= TX_PAUSE_EN;
+		if (rx_pause)
+			reg |= RX_PAUSE_EN;
 
-			if (tx_pause)
-				reg |= TX_PAUSE_EN;
-			if (rx_pause)
-				reg |= RX_PAUSE_EN;
+		reg_writel(priv, reg, reg_rgmii_ctrl);
+	}
 
-			reg_writel(priv, reg, reg_rgmii_ctrl);
-		}
+	reg = LINK_STS;
+	if (port == 8) {
+		if (priv->type == BCM4908_DEVICE_ID)
+			reg |= GMII_SPEED_UP_2G;
+		reg |= MII_SW_OR;
+	} else {
+		reg |= SW_OVERRIDE;
+	}
 
-		reg = SW_OVERRIDE | LINK_STS;
-		switch (speed) {
-		case SPEED_1000:
-			reg |= SPDSTS_1000 << SPEED_SHIFT;
-			break;
-		case SPEED_100:
-			reg |= SPDSTS_100 << SPEED_SHIFT;
-			break;
-		}
+	switch (speed) {
+	case SPEED_1000:
+		reg |= SPDSTS_1000 << SPEED_SHIFT;
+		break;
+	case SPEED_100:
+		reg |= SPDSTS_100 << SPEED_SHIFT;
+		break;
+	}
 
-		if (duplex == DUPLEX_FULL)
-			reg |= DUPLX_MODE;
+	if (duplex == DUPLEX_FULL)
+		reg |= DUPLX_MODE;
 
-		if (tx_pause)
-			reg |= TXFLOW_CNTL;
-		if (rx_pause)
-			reg |= RXFLOW_CNTL;
+	if (tx_pause)
+		reg |= TXFLOW_CNTL;
+	if (rx_pause)
+		reg |= RXFLOW_CNTL;
 
-		core_writel(priv, reg, offset);
-	}
+	core_writel(priv, reg, offset);
 
 	if (mode == MLO_AN_PHY && phydev)
 		p->eee_enabled = b53_eee_init(ds, port, phydev);
-- 
2.25.1

