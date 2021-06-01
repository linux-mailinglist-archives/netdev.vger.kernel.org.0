Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B586B396A50
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 02:33:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232611AbhFAAfd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 May 2021 20:35:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232503AbhFAAfT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 May 2021 20:35:19 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 931B3C061574
        for <netdev@vger.kernel.org>; Mon, 31 May 2021 17:33:37 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id t15so5940219eju.3
        for <netdev@vger.kernel.org>; Mon, 31 May 2021 17:33:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ML/+wkCeBCS+HR0InoV9hv5+50RpDeRPCgw+SZ/iGEE=;
        b=SEuVB//gyM5Q2lvY4ieFq9GVzxujUBqByvTfQWRzXVWYK4qinUe1ZxdqI2Qo0KxfwE
         wzTkW+SpcjipzFGI43xEHKCvo6/o8C93XQcnm/qhY9YK3tohNj2DeWeae0u9g2WEwQXQ
         3ssC7c9ayrhR3IqAN2qqEh8rQ3Kxe8LNm74STx6OyeSAkqQHeTMKtEdw17SsKx2LfTT5
         6sCqYheVL6zvueQ4PuNc07kU6XOGpZoUYUsn5/cyo9PKad92c388b14X12DZAdY/bPp9
         tANUbXxNjv1Jd5kr0vOtX5RX58KijYDgrcwxFq2as7SNB/JcIdAxH6xZRP37rBB6A0PK
         dTSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ML/+wkCeBCS+HR0InoV9hv5+50RpDeRPCgw+SZ/iGEE=;
        b=O12DNihq9gnKSqXPhhUDuz18pl3Ks5uKeIUgDnjkWJlvu0IgYcpGLHmzESwhz4+URF
         TJr1BqDtNe6+5eSkBujFOnZO3ih4sI681QEYOrRtfWIqnx2zKD02W7rbD8/EMoFW4r1E
         lyckw+pR8LJmOHSV5OQ7QoCRnfa8GcWCw9Ms6gvWyhRkrDJ+cXE/6tqNCN2KjyE+8K2M
         vdfURgYyXFer/8vly+zRqHsadBEyG+LlgCzKuZqt+ku+dFvO2yVzWomrKJvjXUK4SgG5
         +9oFc3hk9Tn0DBWz8vYSENrXoCR9AhNFvd357C4y6bxGn6FQZilfWmcLFPp175o7jBhm
         oeDQ==
X-Gm-Message-State: AOAM531iHbG7NJWX+EmYV/2FQbVHuHaLZhf0KWYJrXJZi2Aol1pGvW67
        M4x3YFxI5zwuXnr4qa2XIv0=
X-Google-Smtp-Source: ABdhPJy0CrG7aXV4Oy6U1RpqEXkKAE55T88CtPk51KGJ6Lwm5i5ffntt6F/X+ELYU83K78RL4Kb2vw==
X-Received: by 2002:a17:906:edaf:: with SMTP id sa15mr25253175ejb.174.1622507616122;
        Mon, 31 May 2021 17:33:36 -0700 (PDT)
Received: from localhost.localdomain ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id g13sm6510521ejr.63.2021.05.31.17.33.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 May 2021 17:33:35 -0700 (PDT)
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
Subject: [RFC PATCH v2 net-next 4/9] net: pcs: xpcs: export xpcs_validate
Date:   Tue,  1 Jun 2021 03:33:20 +0300
Message-Id: <20210601003325.1631980-5-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210601003325.1631980-1-olteanv@gmail.com>
References: <20210601003325.1631980-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Calling a function pointer with a single implementation through
struct mdio_xpcs_ops is clunky, and the stmmac_do_callback system forces
this to return int, even though it always returns zero.

Simply remove the "validate" function pointer from struct mdio_xpcs_ops
and replace it with an exported xpcs_validate symbol which is called
directly by stmmac.

priv->hw->xpcs is of the type "const struct mdio_xpcs_ops *" and is used
as a placeholder/synonym for priv->plat->mdio_bus_data->has_xpcs. It is
done that way because the mdio_bus_data pointer might or might not be
populated in all stmmac instantiations.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/stmicro/stmmac/hwif.h        |  2 --
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c |  3 ++-
 drivers/net/pcs/pcs-xpcs.c                        | 11 ++++-------
 include/linux/pcs/pcs-xpcs.h                      |  5 ++---
 4 files changed, 8 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/hwif.h b/drivers/net/ethernet/stmicro/stmmac/hwif.h
index 75a8b90c202a..a86b358feae9 100644
--- a/drivers/net/ethernet/stmicro/stmmac/hwif.h
+++ b/drivers/net/ethernet/stmicro/stmmac/hwif.h
@@ -613,8 +613,6 @@ struct stmmac_mmc_ops {
 	stmmac_do_void_callback(__priv, mmc, read, __args)
 
 /* XPCS callbacks */
-#define stmmac_xpcs_validate(__priv, __args...) \
-	stmmac_do_callback(__priv, xpcs, validate, __args)
 #define stmmac_xpcs_config(__priv, __args...) \
 	stmmac_do_callback(__priv, xpcs, config, __args)
 #define stmmac_xpcs_get_state(__priv, __args...) \
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 129b103cd2b5..9f72e4dd1457 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -996,7 +996,8 @@ static void stmmac_validate(struct phylink_config *config,
 	linkmode_andnot(state->advertising, state->advertising, mask);
 
 	/* If PCS is supported, check which modes it supports. */
-	stmmac_xpcs_validate(priv, &priv->hw->xpcs_args, supported, state);
+	if (priv->hw->xpcs)
+		xpcs_validate(&priv->hw->xpcs_args, supported, state);
 }
 
 static void stmmac_mac_pcs_get_state(struct phylink_config *config,
diff --git a/drivers/net/pcs/pcs-xpcs.c b/drivers/net/pcs/pcs-xpcs.c
index 4bc63d7e3bda..a9bae263dcdb 100644
--- a/drivers/net/pcs/pcs-xpcs.c
+++ b/drivers/net/pcs/pcs-xpcs.c
@@ -720,9 +720,8 @@ static void xpcs_resolve_pma(struct mdio_xpcs_args *xpcs,
 	}
 }
 
-static int xpcs_validate(struct mdio_xpcs_args *xpcs,
-			 unsigned long *supported,
-			 struct phylink_link_state *state)
+void xpcs_validate(struct mdio_xpcs_args *xpcs, unsigned long *supported,
+		   struct phylink_link_state *state)
 {
 	__ETHTOOL_DECLARE_LINK_MODE_MASK(xpcs_supported);
 	const struct xpcs_compat *compat;
@@ -733,7 +732,7 @@ static int xpcs_validate(struct mdio_xpcs_args *xpcs,
 	 * advertising masks and exit.
 	 */
 	if (state->interface == PHY_INTERFACE_MODE_NA)
-		return 0;
+		return;
 
 	bitmap_zero(xpcs_supported, __ETHTOOL_LINK_MODE_MASK_NBITS);
 
@@ -748,9 +747,8 @@ static int xpcs_validate(struct mdio_xpcs_args *xpcs,
 
 	linkmode_and(supported, supported, xpcs_supported);
 	linkmode_and(state->advertising, state->advertising, xpcs_supported);
-
-	return 0;
 }
+EXPORT_SYMBOL_GPL(xpcs_validate);
 
 static int xpcs_config_eee(struct mdio_xpcs_args *xpcs, int mult_fact_100ns,
 			   int enable)
@@ -1031,7 +1029,6 @@ static int xpcs_probe(struct mdio_xpcs_args *xpcs, phy_interface_t interface)
 }
 
 static struct mdio_xpcs_ops xpcs_ops = {
-	.validate = xpcs_validate,
 	.config = xpcs_config,
 	.get_state = xpcs_get_state,
 	.link_up = xpcs_link_up,
diff --git a/include/linux/pcs/pcs-xpcs.h b/include/linux/pcs/pcs-xpcs.h
index c2ec440d2c5d..5ec9aaca01fe 100644
--- a/include/linux/pcs/pcs-xpcs.h
+++ b/include/linux/pcs/pcs-xpcs.h
@@ -23,9 +23,6 @@ struct mdio_xpcs_args {
 };
 
 struct mdio_xpcs_ops {
-	int (*validate)(struct mdio_xpcs_args *xpcs,
-			unsigned long *supported,
-			struct phylink_link_state *state);
 	int (*config)(struct mdio_xpcs_args *xpcs,
 		      const struct phylink_link_state *state);
 	int (*get_state)(struct mdio_xpcs_args *xpcs,
@@ -39,5 +36,7 @@ struct mdio_xpcs_ops {
 
 int xpcs_get_an_mode(struct mdio_xpcs_args *xpcs, phy_interface_t interface);
 struct mdio_xpcs_ops *mdio_xpcs_get_ops(void);
+void xpcs_validate(struct mdio_xpcs_args *xpcs, unsigned long *supported,
+		   struct phylink_link_state *state);
 
 #endif /* __LINUX_PCS_XPCS_H */
-- 
2.25.1

