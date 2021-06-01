Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BC97396A54
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 02:34:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232578AbhFAAfo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 May 2021 20:35:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232516AbhFAAfX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 May 2021 20:35:23 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EFFAC06174A
        for <netdev@vger.kernel.org>; Mon, 31 May 2021 17:33:42 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id dg27so5472127edb.12
        for <netdev@vger.kernel.org>; Mon, 31 May 2021 17:33:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Ec+YPwZXLTJ3HaK9aFsFTWRHNpPy8rpBhHT/ln7q40k=;
        b=mE1XPgXnHl8zl4lI4JVEyNcHpXhaE8iuK1ssMBbx+tdmNWP4FlUfxRZbaQnrppltVX
         YwPzfDSeL0WsZ91+ae93I/m5QasGANmkJpMV71/A36bCR4AqPbfc1qbkYeuJfxIqNNVw
         qoCAnbQvh+JtmPeG3yHJpx2lxdlLa5FtpkU7NvlF8TA2TpcVw33NTW1z3LyOagfgievq
         kXOt+Ti+OtDCROHYH4b843pv5Tcl13ocNvuFgYWhW8v2z9dPIhexuSFq8YQ5f6Zp+5oP
         ETT4BjEbUDVLji2eqGj4lHNLazVfiMoKTkdVWGW66+dfnt4nv2PXu0VfC0nKayEjGT0T
         LuSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ec+YPwZXLTJ3HaK9aFsFTWRHNpPy8rpBhHT/ln7q40k=;
        b=Z2dD2TXifckyLzQUM4tiZlGqc9N6kxC/3TQl0bsSJZb8i4zPmYa6WlWVN6W01yJqO1
         c6bXu3t0hGET70W9N/VU5CZppB5H/9XLA9x5Ezl4TiS9X/gA7BqQnn9to1a+XAes3P+7
         kbHsHfyKj8QeNpTBz7QHHsFVF5nbU9hsrhMpklMNd3kBoBV2z6Bpjid5npA2XKs6erL/
         A55Rmt4unUHysacwm7ouCgjiY9AILMYx6YJ/lNOIRkvykYgcSY1YZqkxtt+KeZ+qBIrB
         A6QJ6/wTW3+MO+l5GJ5uuokzVWxiORN7bvXYM4a/kGBwCD1Q4kH5tcBidMkf8S3YCi9Z
         +0kQ==
X-Gm-Message-State: AOAM5303lH1T29FntIpl4wG8yeeMTFqsRdFWO1BXGiIAE9NbCeO1o2S6
        GPGdEk25xgHY3xkJTyD5VsE=
X-Google-Smtp-Source: ABdhPJyozknjUzyzOB45lO48d8dLbTpdtWoSJkzHihh46KhwMWDfZVwqXu3jtjR3dWvmPHJQ8IC+Gw==
X-Received: by 2002:aa7:cc10:: with SMTP id q16mr28990779edt.53.1622507620944;
        Mon, 31 May 2021 17:33:40 -0700 (PDT)
Received: from localhost.localdomain ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id g13sm6510521ejr.63.2021.05.31.17.33.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 May 2021 17:33:40 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Wong Vee Khee <vee.khee.wong@linux.intel.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [RFC PATCH v2 net-next 8/9] net: pcs: xpcs: convert to mdio_device
Date:   Tue,  1 Jun 2021 03:33:24 +0300
Message-Id: <20210601003325.1631980-9-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210601003325.1631980-1-olteanv@gmail.com>
References: <20210601003325.1631980-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Unify the 2 existing PCS drivers (lynx and xpcs) by doing a similar
thing on probe, which is to have a *_create function that takes a
struct mdio_device * given by the caller, and builds a private PCS
structure around that.

This changes stmmac to hold only a pointer to the xpcs, as opposed to
the full structure. This will be used in the next patch when struct
mdio_xpcs_ops is removed. Currently a pointer to struct mdio_xpcs_ops
is used as a shorthand to determine whether the port has an XPCS or not.
We can do the same now with the mdio_xpcs_args pointer.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/stmicro/stmmac/common.h  |  2 +-
 .../ethernet/stmicro/stmmac/stmmac_ethtool.c  |  2 +-
 .../net/ethernet/stmicro/stmmac/stmmac_main.c | 10 ++--
 .../net/ethernet/stmicro/stmmac/stmmac_mdio.c | 39 ++++++++------
 drivers/net/pcs/pcs-xpcs.c                    | 53 +++++++++++++++----
 include/linux/pcs/pcs-xpcs.h                  |  7 +--
 6 files changed, 76 insertions(+), 37 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/common.h b/drivers/net/ethernet/stmicro/stmmac/common.h
index 619e3c0760d6..4bcd1d340766 100644
--- a/drivers/net/ethernet/stmicro/stmmac/common.h
+++ b/drivers/net/ethernet/stmicro/stmmac/common.h
@@ -504,7 +504,7 @@ struct mac_device_info {
 	const struct stmmac_tc_ops *tc;
 	const struct stmmac_mmc_ops *mmc;
 	const struct mdio_xpcs_ops *xpcs;
-	struct mdio_xpcs_args xpcs_args;
+	struct mdio_xpcs_args *xpcs_args;
 	struct mii_regs mii;	/* MII register Addresses */
 	struct mac_link link;
 	void __iomem *pcsr;     /* vpointer to device CSRs */
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
index ba7d0f40723a..050576ee704d 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
@@ -721,7 +721,7 @@ static int stmmac_ethtool_op_set_eee(struct net_device *dev,
 			    "Setting EEE tx-lpi is not supported\n");
 
 	if (priv->hw->xpcs) {
-		ret = xpcs_config_eee(&priv->hw->xpcs_args,
+		ret = xpcs_config_eee(priv->hw->xpcs_args,
 				      priv->plat->mult_fact_100ns,
 				      edata->eee_enabled);
 		if (ret)
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 9f72e4dd1457..426c8f891f5a 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -997,7 +997,7 @@ static void stmmac_validate(struct phylink_config *config,
 
 	/* If PCS is supported, check which modes it supports. */
 	if (priv->hw->xpcs)
-		xpcs_validate(&priv->hw->xpcs_args, supported, state);
+		xpcs_validate(priv->hw->xpcs_args, supported, state);
 }
 
 static void stmmac_mac_pcs_get_state(struct phylink_config *config,
@@ -1006,7 +1006,7 @@ static void stmmac_mac_pcs_get_state(struct phylink_config *config,
 	struct stmmac_priv *priv = netdev_priv(to_net_dev(config->dev));
 
 	state->link = 0;
-	stmmac_xpcs_get_state(priv, &priv->hw->xpcs_args, state);
+	stmmac_xpcs_get_state(priv, priv->hw->xpcs_args, state);
 }
 
 static void stmmac_mac_config(struct phylink_config *config, unsigned int mode,
@@ -1014,7 +1014,7 @@ static void stmmac_mac_config(struct phylink_config *config, unsigned int mode,
 {
 	struct stmmac_priv *priv = netdev_priv(to_net_dev(config->dev));
 
-	stmmac_xpcs_config(priv, &priv->hw->xpcs_args, state);
+	stmmac_xpcs_config(priv, priv->hw->xpcs_args, state);
 }
 
 static void stmmac_mac_an_restart(struct phylink_config *config)
@@ -1061,7 +1061,7 @@ static void stmmac_mac_link_up(struct phylink_config *config,
 	struct stmmac_priv *priv = netdev_priv(to_net_dev(config->dev));
 	u32 ctrl;
 
-	stmmac_xpcs_link_up(priv, &priv->hw->xpcs_args, speed, interface);
+	stmmac_xpcs_link_up(priv, priv->hw->xpcs_args, speed, interface);
 
 	ctrl = readl(priv->ioaddr + MAC_CTRL_REG);
 	ctrl &= ~priv->hw->link.speed_mask;
@@ -3652,7 +3652,7 @@ int stmmac_open(struct net_device *dev)
 	if (priv->hw->pcs != STMMAC_PCS_TBI &&
 	    priv->hw->pcs != STMMAC_PCS_RTBI &&
 	    (!priv->hw->xpcs ||
-	     xpcs_get_an_mode(&priv->hw->xpcs_args, mode) != DW_AN_C73)) {
+	     xpcs_get_an_mode(priv->hw->xpcs_args, mode) != DW_AN_C73)) {
 		ret = stmmac_init_phy(dev);
 		if (ret) {
 			netdev_err(priv->dev,
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
index 56deb92a8430..9b4bf78d2eaa 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
@@ -510,25 +510,27 @@ int stmmac_mdio_register(struct net_device *ndev)
 	}
 
 	/* Try to probe the XPCS by scanning all addresses. */
-	if (priv->hw->xpcs) {
-		struct mdio_xpcs_args *xpcs = &priv->hw->xpcs_args;
-		int ret, mode = priv->plat->phy_interface;
-		max_addr = PHY_MAX_ADDR;
-
-		xpcs->bus = new_bus;
-
-		found = 0;
-		for (addr = 0; addr < max_addr; addr++) {
-			xpcs->addr = addr;
-
-			ret = xpcs_probe(xpcs, mode);
-			if (!ret) {
-				found = 1;
-				break;
+	if (mdio_bus_data->has_xpcs) {
+		int mode = priv->plat->phy_interface;
+		struct mdio_device *mdiodev;
+		struct mdio_xpcs_args *xpcs;
+
+		for (addr = 0; addr < PHY_MAX_ADDR; addr++) {
+			mdiodev = mdio_device_create(new_bus, addr);
+			if (IS_ERR(mdiodev))
+				continue;
+
+			xpcs = xpcs_create(mdiodev, mode);
+			if (IS_ERR_OR_NULL(xpcs)) {
+				mdio_device_free(mdiodev);
+				continue;
 			}
+
+			priv->hw->xpcs_args = xpcs;
+			break;
 		}
 
-		if (!found && !mdio_node) {
+		if (!priv->hw->xpcs_args) {
 			dev_warn(dev, "No XPCS found\n");
 			err = -ENODEV;
 			goto no_xpcs_found;
@@ -560,6 +562,11 @@ int stmmac_mdio_unregister(struct net_device *ndev)
 	if (!priv->mii)
 		return 0;
 
+	if (priv->hw->xpcs) {
+		mdio_device_free(priv->hw->xpcs_args->mdiodev);
+		xpcs_destroy(priv->hw->xpcs_args);
+	}
+
 	mdiobus_unregister(priv->mii);
 	priv->mii->priv = NULL;
 	mdiobus_free(priv->mii);
diff --git a/drivers/net/pcs/pcs-xpcs.c b/drivers/net/pcs/pcs-xpcs.c
index c3760192fe20..3e09850b8318 100644
--- a/drivers/net/pcs/pcs-xpcs.c
+++ b/drivers/net/pcs/pcs-xpcs.c
@@ -276,15 +276,19 @@ static bool __xpcs_linkmode_supported(const struct xpcs_compat *compat,
 static int xpcs_read(struct mdio_xpcs_args *xpcs, int dev, u32 reg)
 {
 	u32 reg_addr = mdiobus_c45_addr(dev, reg);
+	struct mii_bus *bus = xpcs->mdiodev->bus;
+	int addr = xpcs->mdiodev->addr;
 
-	return mdiobus_read(xpcs->bus, xpcs->addr, reg_addr);
+	return mdiobus_read(bus, addr, reg_addr);
 }
 
 static int xpcs_write(struct mdio_xpcs_args *xpcs, int dev, u32 reg, u16 val)
 {
 	u32 reg_addr = mdiobus_c45_addr(dev, reg);
+	struct mii_bus *bus = xpcs->mdiodev->bus;
+	int addr = xpcs->mdiodev->addr;
 
-	return mdiobus_write(xpcs->bus, xpcs->addr, reg_addr, val);
+	return mdiobus_write(bus, addr, reg_addr, val);
 }
 
 static int xpcs_read_vendor(struct mdio_xpcs_args *xpcs, int dev, u32 reg)
@@ -350,7 +354,7 @@ static int xpcs_soft_reset(struct mdio_xpcs_args *xpcs,
 #define xpcs_warn(__xpcs, __state, __args...) \
 ({ \
 	if ((__state)->link) \
-		dev_warn(&(__xpcs)->bus->dev, ##__args); \
+		dev_warn(&(__xpcs)->mdiodev->dev, ##__args); \
 })
 
 static int xpcs_read_fault_c73(struct mdio_xpcs_args *xpcs,
@@ -1005,10 +1009,20 @@ static u32 xpcs_get_id(struct mdio_xpcs_args *xpcs)
 	return 0xffffffff;
 }
 
-int xpcs_probe(struct mdio_xpcs_args *xpcs, phy_interface_t interface)
+struct mdio_xpcs_args *xpcs_create(struct mdio_device *mdiodev,
+				   phy_interface_t interface)
 {
-	u32 xpcs_id = xpcs_get_id(xpcs);
-	int i;
+	struct mdio_xpcs_args *xpcs;
+	u32 xpcs_id;
+	int i, ret;
+
+	xpcs = kzalloc(sizeof(*xpcs), GFP_KERNEL);
+	if (!xpcs)
+		return NULL;
+
+	xpcs->mdiodev = mdiodev;
+
+	xpcs_id = xpcs_get_id(xpcs);
 
 	for (i = 0; i < ARRAY_SIZE(xpcs_id_list); i++) {
 		const struct xpcs_id *entry = &xpcs_id_list[i];
@@ -1020,15 +1034,32 @@ int xpcs_probe(struct mdio_xpcs_args *xpcs, phy_interface_t interface)
 		xpcs->id = entry;
 
 		compat = xpcs_find_compat(entry, interface);
-		if (!compat)
-			return -ENODEV;
+		if (!compat) {
+			ret = -ENODEV;
+			goto out;
+		}
 
-		return xpcs_soft_reset(xpcs, compat);
+		ret = xpcs_soft_reset(xpcs, compat);
+		if (ret)
+			goto out;
+
+		return xpcs;
 	}
 
-	return -ENODEV;
+	ret = -ENODEV;
+
+out:
+	kfree(xpcs);
+
+	return ERR_PTR(ret);
+}
+EXPORT_SYMBOL_GPL(xpcs_create);
+
+void xpcs_destroy(struct mdio_xpcs_args *xpcs)
+{
+	kfree(xpcs);
 }
-EXPORT_SYMBOL_GPL(xpcs_probe);
+EXPORT_SYMBOL_GPL(xpcs_destroy);
 
 static struct mdio_xpcs_ops xpcs_ops = {
 	.config = xpcs_config,
diff --git a/include/linux/pcs/pcs-xpcs.h b/include/linux/pcs/pcs-xpcs.h
index 1d8581b74d81..57a199393d63 100644
--- a/include/linux/pcs/pcs-xpcs.h
+++ b/include/linux/pcs/pcs-xpcs.h
@@ -17,9 +17,8 @@
 struct xpcs_id;
 
 struct mdio_xpcs_args {
-	struct mii_bus *bus;
+	struct mdio_device *mdiodev;
 	const struct xpcs_id *id;
-	int addr;
 };
 
 struct mdio_xpcs_ops {
@@ -37,6 +36,8 @@ void xpcs_validate(struct mdio_xpcs_args *xpcs, unsigned long *supported,
 		   struct phylink_link_state *state);
 int xpcs_config_eee(struct mdio_xpcs_args *xpcs, int mult_fact_100ns,
 		    int enable);
-int xpcs_probe(struct mdio_xpcs_args *xpcs, phy_interface_t interface);
+struct mdio_xpcs_args *xpcs_create(struct mdio_device *mdiodev,
+				   phy_interface_t interface);
+void xpcs_destroy(struct mdio_xpcs_args *xpcs);
 
 #endif /* __LINUX_PCS_XPCS_H */
-- 
2.25.1

