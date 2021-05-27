Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9066C393747
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 22:45:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235859AbhE0UrS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 16:47:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235625AbhE0UrQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 May 2021 16:47:16 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFD2AC061574
        for <netdev@vger.kernel.org>; Thu, 27 May 2021 13:45:41 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id s6so2328493edu.10
        for <netdev@vger.kernel.org>; Thu, 27 May 2021 13:45:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=53SMu8LKhmQZUryoy0jqx48MjLxIQReIM88wTX3mV8w=;
        b=swUc2jcnP4SChGY6LffqmpBufM725eWWzmx77Qqyu9AHgvULykuwAiBPS+aVMoamPt
         mT9jkJiBubRrT5NKMQR/bnFBy/IXsmuJk1z7dIq0/HC4W8WOcQnpsXWE7D8ci68igc0H
         dkMYB9ItFyBRDEw0hvcv4RKd9KNZ6rpM8gpsPFHlN1XGI9ZHN0dl0gpobVo9HFY0xitA
         oNivt9BtMLCBKT4HerXelpAOPf2ufd+Shtc1ER8Q0fpaMgK39rMZ1pGaHcwbQiM1Bbc4
         zYTberBxjYvv37g1/gifa+Xtr8bSytasEjmSqKLh10sJMGaPwdFcS10/dedNoy2Kwh8+
         G12Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=53SMu8LKhmQZUryoy0jqx48MjLxIQReIM88wTX3mV8w=;
        b=uCkOfe2m+UEgbmri5cWHJRhj6aUZJx8g1KXfmxcqZcZrdinZ9v0oMlp+EhQ1YslHGs
         EmxC84S18Ym7zyLgABts4eOW+zCFWv1BcDRO62xoo0KlKo1RdFo3sel1kx3UWGKkit3s
         hQZ0/U6LkSiXSkGvitvGW0aR9GfEXkyN+OqN3owYSg0mD0IzRaCgxthkIZZsBZQlGuFw
         0Zdca2gMtwBZ3TmfbRE2qf78C5zuoaLTKDElyRUowacuu3bJNSPyp5aKb23Xw0AoUtSG
         7h5utehF5oJQ/t1rw2nejddNwoH1h91vJi0nmqoZum8rd7FL/uSGMeRrnYTuuf210mly
         VyuA==
X-Gm-Message-State: AOAM532BIQENU0JKbKj6HyfKPiz0iVcUoneoOraQiSg0q/zW0de/FBbJ
        Yvz7lBOc/f7rJzbUDR8qOp4=
X-Google-Smtp-Source: ABdhPJwBALV+ExtGz6uqliAjFXfKqzUxCKuQJImnmTpAt/P7fptpgcbToRDg9mfcRG/W1vj51sJnvw==
X-Received: by 2002:aa7:d598:: with SMTP id r24mr6407675edq.250.1622148340500;
        Thu, 27 May 2021 13:45:40 -0700 (PDT)
Received: from localhost.localdomain ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id g11sm1654145edt.85.2021.05.27.13.45.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 May 2021 13:45:40 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [RFC PATCH net-next 2/8] net: pcs: xpcs: check for supported PHY interface modes in phylink_validate
Date:   Thu, 27 May 2021 23:45:22 +0300
Message-Id: <20210527204528.3490126-3-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210527204528.3490126-1-olteanv@gmail.com>
References: <20210527204528.3490126-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

The supported PHY interface types are currently deduced by reading the
PHY ID registers of the PCS, to determine whether it is an USXGMII,
10G-KR, XLGMII, SGMII PCS or whatever.

Checking whether the PCS operates in a PHY interface mode compatible
with the hardware capability is done only once: in xpcs_check_features,
called from xpcs_probe - the deduced PHY interface mode is compared to
what is specified in the device tree.

But nothing prevents phylink from changing the state->interface as a
result of plugging an SFP module with a different operating PHY
interface type.

This change deletes xpcs_check_features, removes the phy_interface_t
argument from xpcs_probe, and moves the PHY interface type check inside
the validate function, similar to what other drivers do.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 .../net/ethernet/stmicro/stmmac/stmmac_mdio.c |  5 +-
 drivers/net/pcs/pcs-xpcs.c                    | 63 ++++++++++---------
 include/linux/pcs/pcs-xpcs.h                  |  5 +-
 3 files changed, 41 insertions(+), 32 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
index e293bf1ce9f3..d12dfa60b8ea 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
@@ -512,7 +512,8 @@ int stmmac_mdio_register(struct net_device *ndev)
 	/* Try to probe the XPCS by scanning all addresses. */
 	if (priv->hw->xpcs) {
 		struct mdio_xpcs_args *xpcs = &priv->hw->xpcs_args;
-		int ret, mode = priv->plat->phy_interface;
+		int ret;
+
 		max_addr = PHY_MAX_ADDR;
 
 		xpcs->bus = new_bus;
@@ -521,7 +522,7 @@ int stmmac_mdio_register(struct net_device *ndev)
 		for (addr = 0; addr < max_addr; addr++) {
 			xpcs->addr = addr;
 
-			ret = stmmac_xpcs_probe(priv, xpcs, mode);
+			ret = stmmac_xpcs_probe(priv, xpcs);
 			if (!ret) {
 				found = 1;
 				break;
diff --git a/drivers/net/pcs/pcs-xpcs.c b/drivers/net/pcs/pcs-xpcs.c
index aa985a5aae8d..71efd5ef69e5 100644
--- a/drivers/net/pcs/pcs-xpcs.c
+++ b/drivers/net/pcs/pcs-xpcs.c
@@ -662,6 +662,30 @@ static int xpcs_validate(struct mdio_xpcs_args *xpcs,
 			 unsigned long *supported,
 			 struct phylink_link_state *state)
 {
+	bool valid_interface;
+
+	if (state->interface == PHY_INTERFACE_MODE_NA) {
+		valid_interface = true;
+	} else {
+		struct xpcs_id *id = xpcs->id;
+		int i;
+
+		valid_interface = false;
+
+		for (i = 0; id->interface[i] != PHY_INTERFACE_MODE_MAX; i++) {
+			if (id->interface[i] != state->interface)
+				continue;
+
+			valid_interface = true;
+			break;
+		}
+	}
+
+	if (!valid_interface) {
+		bitmap_zero(supported, __ETHTOOL_LINK_MODE_MASK_NBITS);
+		return 0;
+	}
+
 	linkmode_and(supported, supported, xpcs->supported);
 	linkmode_and(state->advertising, state->advertising, xpcs->supported);
 	return 0;
@@ -910,43 +934,24 @@ static u32 xpcs_get_id(struct mdio_xpcs_args *xpcs)
 	return 0xffffffff;
 }
 
-static bool xpcs_check_features(struct mdio_xpcs_args *xpcs,
-				struct xpcs_id *match,
-				phy_interface_t interface)
-{
-	int i;
-
-	for (i = 0; match->interface[i] != PHY_INTERFACE_MODE_MAX; i++) {
-		if (match->interface[i] == interface)
-			break;
-	}
-
-	if (match->interface[i] == PHY_INTERFACE_MODE_MAX)
-		return false;
-
-	for (i = 0; match->supported[i] != __ETHTOOL_LINK_MODE_MASK_NBITS; i++)
-		set_bit(match->supported[i], xpcs->supported);
-
-	xpcs->an_mode = match->an_mode;
-
-	return true;
-}
-
-static int xpcs_probe(struct mdio_xpcs_args *xpcs, phy_interface_t interface)
+static int xpcs_probe(struct mdio_xpcs_args *xpcs)
 {
 	u32 xpcs_id = xpcs_get_id(xpcs);
-	struct xpcs_id *match = NULL;
 	int i;
 
 	for (i = 0; i < ARRAY_SIZE(xpcs_id_list); i++) {
 		struct xpcs_id *entry = &xpcs_id_list[i];
 
-		if ((xpcs_id & entry->mask) == entry->id) {
-			match = entry;
+		if ((xpcs_id & entry->mask) != entry->id)
+			continue;
 
-			if (xpcs_check_features(xpcs, match, interface))
-				return xpcs_soft_reset(xpcs);
-		}
+		for (i = 0; entry->supported[i] != __ETHTOOL_LINK_MODE_MASK_NBITS; i++)
+			set_bit(entry->supported[i], xpcs->supported);
+
+		xpcs->id = entry;
+		xpcs->an_mode = entry->an_mode;
+
+		return xpcs_soft_reset(xpcs);
 	}
 
 	return -ENODEV;
diff --git a/include/linux/pcs/pcs-xpcs.h b/include/linux/pcs/pcs-xpcs.h
index c4d0a2c469c7..e48636a1a078 100644
--- a/include/linux/pcs/pcs-xpcs.h
+++ b/include/linux/pcs/pcs-xpcs.h
@@ -14,9 +14,12 @@
 #define DW_AN_C73			1
 #define DW_AN_C37_SGMII			2
 
+struct xpcs_id;
+
 struct mdio_xpcs_args {
 	__ETHTOOL_DECLARE_LINK_MODE_MASK(supported);
 	struct mii_bus *bus;
+	struct xpcs_id *id;
 	int addr;
 	int an_mode;
 };
@@ -31,7 +34,7 @@ struct mdio_xpcs_ops {
 			 struct phylink_link_state *state);
 	int (*link_up)(struct mdio_xpcs_args *xpcs, int speed,
 		       phy_interface_t interface);
-	int (*probe)(struct mdio_xpcs_args *xpcs, phy_interface_t interface);
+	int (*probe)(struct mdio_xpcs_args *xpcs);
 	int (*config_eee)(struct mdio_xpcs_args *xpcs, int mult_fact_100ns,
 			  int enable);
 };
-- 
2.25.1

