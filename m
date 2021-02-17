Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E94731E03E
	for <lists+netdev@lfdr.de>; Wed, 17 Feb 2021 21:28:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235020AbhBQU0t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Feb 2021 15:26:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233645AbhBQU0m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Feb 2021 15:26:42 -0500
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E28EDC061574;
        Wed, 17 Feb 2021 12:26:01 -0800 (PST)
Received: by mail-pg1-x530.google.com with SMTP id 75so5826953pgf.13;
        Wed, 17 Feb 2021 12:26:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=oQrfzO17knb0L2S7w06JElc/0RtdSnwzho+6k4zHaN0=;
        b=u0aqlOkz+ygOgoDWu2MW9cD0xGWxxpjARMtgQFTLUiGhKbE8H3CwYteDRFgmkvrLZ0
         Sjd0zuR2k10uoGsoLtMHhDn1Q90X/v4n3U81fjPq466AglSZOCboNrUas8mSjf3OpCvv
         /g/kh1B8mIN7l3kpIh4Sy64eWfZOU7uAk+nSUSd2XeekNmBEXKbGboU4hCyHm0LonEnn
         GYzMJylmmd9ysYawLXdqkaUnQGO12cOPG2SROGDmbdqa0D6Rj+4hkFUpq7LJ4iUGdV1h
         96ShljAITpMrVsYoII2iz7aOr/mS7n3KxFdRRCmLoqdN4fOVvLMdh1DNv2vY51gaspjY
         BLRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=oQrfzO17knb0L2S7w06JElc/0RtdSnwzho+6k4zHaN0=;
        b=VE80Wjbquj89d0P+MibEhriTCXfBt06/l8LnD+9Z+TN59W24bjIWuG/uT5e685kiCr
         AeJLquzrl+TzpuqzVtAjI4BSuMdP/zhOUrU67R9mKZqhnGP5JMUP6vRaHQ9E+knY4xff
         uXjBIQI7DnZm/lOjEOmf4SBGOKQp1FTv3Mha3gZysvYYzAGvkGTWHLhVd7zuBJq+vaIZ
         ADnLFAibVMsJPyyRFGHu5zsvrgFuEt9qvEn0vKs3Fi4Ae540cSyluRmuOTwaa0kX1f7L
         FPnxYzQOfr9i1bYnUfm+/YJOA8Sd486u0l98RW6dGHxKMvmAqUGhdDF0FUcT9AxSb57r
         GxoQ==
X-Gm-Message-State: AOAM5320YrF1N74RgKVq/gj9kcz33SLq8d9GYh+2/JlrCJVbi2YqXvid
        GgX7VcIdreQuAmsgIxclpNNJE6PCSwM=
X-Google-Smtp-Source: ABdhPJw7sprEYpUjr8VOY599l4n2vzIFZHUpSg+RjAqb0AIMDTySDpu7Fvog9t6aHHctDV29dyatJA==
X-Received: by 2002:a05:6a00:787:b029:1da:643b:6d41 with SMTP id g7-20020a056a000787b02901da643b6d41mr967979pfu.31.1613593560975;
        Wed, 17 Feb 2021 12:26:00 -0800 (PST)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id n1sm3470238pgi.78.2021.02.17.12.25.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Feb 2021 12:26:00 -0800 (PST)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>,
        linux-doc@vger.kernel.org (open list:DOCUMENTATION),
        linux-kernel@vger.kernel.org (open list),
        devicetree@vger.kernel.org (open list:OPEN FIRMWARE AND FLATTENED
        DEVICE TREE)
Subject: [PATCH net-next] net: mdio: Remove of_phy_attach()
Date:   Wed, 17 Feb 2021 12:25:57 -0800
Message-Id: <20210217202558.2645876-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We have no in-tree users, also update the sfp-phylink.rst documentation
to indicate that phy_attach_direct() is used instead of of_phy_attach().

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 Documentation/networking/sfp-phylink.rst |  2 +-
 drivers/net/mdio/of_mdio.c               | 30 ------------------------
 include/linux/of_mdio.h                  | 10 --------
 3 files changed, 1 insertion(+), 41 deletions(-)

diff --git a/Documentation/networking/sfp-phylink.rst b/Documentation/networking/sfp-phylink.rst
index 5aec7c8857d0..328f8d39eeb3 100644
--- a/Documentation/networking/sfp-phylink.rst
+++ b/Documentation/networking/sfp-phylink.rst
@@ -163,7 +163,7 @@ this documentation.
 	err = phylink_of_phy_connect(priv->phylink, node, flags);
 
    For the most part, ``flags`` can be zero; these flags are passed to
-   the of_phy_attach() inside this function call if a PHY is specified
+   the phy_attach_direct() inside this function call if a PHY is specified
    in the DT node ``node``.
 
    ``node`` should be the DT node which contains the network phy property,
diff --git a/drivers/net/mdio/of_mdio.c b/drivers/net/mdio/of_mdio.c
index 4daf94bb56a5..ea9d5855fb52 100644
--- a/drivers/net/mdio/of_mdio.c
+++ b/drivers/net/mdio/of_mdio.c
@@ -462,36 +462,6 @@ struct phy_device *of_phy_get_and_connect(struct net_device *dev,
 }
 EXPORT_SYMBOL(of_phy_get_and_connect);
 
-/**
- * of_phy_attach - Attach to a PHY without starting the state machine
- * @dev: pointer to net_device claiming the phy
- * @phy_np: Node pointer for the PHY
- * @flags: flags to pass to the PHY
- * @iface: PHY data interface type
- *
- * If successful, returns a pointer to the phy_device with the embedded
- * struct device refcount incremented by one, or NULL on failure. The
- * refcount must be dropped by calling phy_disconnect() or phy_detach().
- */
-struct phy_device *of_phy_attach(struct net_device *dev,
-				 struct device_node *phy_np, u32 flags,
-				 phy_interface_t iface)
-{
-	struct phy_device *phy = of_phy_find_device(phy_np);
-	int ret;
-
-	if (!phy)
-		return NULL;
-
-	ret = phy_attach_direct(dev, phy, flags, iface);
-
-	/* refcount is held by phy_attach_direct() on success */
-	put_device(&phy->mdio.dev);
-
-	return ret ? NULL : phy;
-}
-EXPORT_SYMBOL(of_phy_attach);
-
 /*
  * of_phy_is_fixed_link() and of_phy_register_fixed_link() must
  * support two DT bindings:
diff --git a/include/linux/of_mdio.h b/include/linux/of_mdio.h
index cfe8c607a628..2b05e7f7c238 100644
--- a/include/linux/of_mdio.h
+++ b/include/linux/of_mdio.h
@@ -26,9 +26,6 @@ of_phy_connect(struct net_device *dev, struct device_node *phy_np,
 struct phy_device *
 of_phy_get_and_connect(struct net_device *dev, struct device_node *np,
 		       void (*hndlr)(struct net_device *));
-struct phy_device *
-of_phy_attach(struct net_device *dev, struct device_node *phy_np,
-	      u32 flags, phy_interface_t iface);
 
 struct mii_bus *of_mdio_find_bus(struct device_node *mdio_np);
 int of_phy_register_fixed_link(struct device_node *np);
@@ -100,13 +97,6 @@ of_phy_get_and_connect(struct net_device *dev, struct device_node *np,
 	return NULL;
 }
 
-static inline struct phy_device *of_phy_attach(struct net_device *dev,
-					       struct device_node *phy_np,
-					       u32 flags, phy_interface_t iface)
-{
-	return NULL;
-}
-
 static inline struct mii_bus *of_mdio_find_bus(struct device_node *mdio_np)
 {
 	return NULL;
-- 
2.25.1

