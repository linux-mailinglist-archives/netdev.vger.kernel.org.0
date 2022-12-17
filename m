Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7BEA64F686
	for <lists+netdev@lfdr.de>; Sat, 17 Dec 2022 01:49:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230076AbiLQAtb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Dec 2022 19:49:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230114AbiLQAtI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Dec 2022 19:49:08 -0500
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADB8566C2D;
        Fri, 16 Dec 2022 16:48:52 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id fc4so9783307ejc.12;
        Fri, 16 Dec 2022 16:48:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=1Gir7fTwyrXZY1qzReD9ZZdX03MxmdudoyUkcMJX08o=;
        b=iFYqNK4M6sOryAbkedN3YSEz7nw1/UKE+H7huhbiIaYAF81+Sb1wORVHVf07Nl5xgE
         kNswJ1w21Dy1tDxJKbO6iJbkIJYFkK+5pueArq8VQEPyt1TZFyFIXS5TI3m827zes3tq
         f5BtRPgae4NiP28yJSxccgCBLK14hLcHg6J3w9jV3c+iv6YGbQP+MsqopeY2BwKDu4bX
         qFg+mLJDlAmDcr9gidvEQK86QmLUltvlUuqqFv8XTC1+evnF0dds8c46ODvVp8syL1TB
         jAhBR/akEBzAOEZ8ic9zmQfagD7GIbLisuOMQZkIY/K0lJA+3dnRQUwkSdUiT0Io1GCk
         DEIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1Gir7fTwyrXZY1qzReD9ZZdX03MxmdudoyUkcMJX08o=;
        b=t5Tmk/ZIGZf/FYhxcZg15Opk12DXtfNE14tiB3uMBHPG81+F9gQcm3dOws5h79l6fk
         1h7SO77ymWB84qUcBfNRV7iPsyn/Q1gcutcFifdHB5q6z6riR1Zo6rx9bqHQqbnvO6LT
         AF3uc1dhcB2U5YbGul51vChL8vWAYHHNpFldbBzSwxj6kGzxoAL2bqGxgSmzdU0EpY18
         z9r4pE+tw3vE9ZpH8jq+0gKAl4KgDRu7zEjPU1HeAI42U+ePifL0RzR5NaXYrx2crxWt
         RXlqR3DTmkbRlXLvkWd9XpAyWV3UJzFe0XvxbFj+6bPJsN9eYpTwLlqGm0U5JQx+yoCk
         tSWg==
X-Gm-Message-State: ANoB5pmjdldtISUz3stgwECbTiHnzVJAlon+QEexrQ9kAXdbKrC68Udd
        Bix3OHtnJ2DIYyHijNyIePc=
X-Google-Smtp-Source: AA0mqf6pfwe1mjSpgdnp/3llbtrl2Te9EYZG0OgCJe5MgMz/dMSDgj5FRakJQfdVDFHnvqyp25R4Zw==
X-Received: by 2002:a17:906:c20c:b0:7ac:a2f5:cd0a with SMTP id d12-20020a170906c20c00b007aca2f5cd0amr30024893ejz.44.1671238131155;
        Fri, 16 Dec 2022 16:48:51 -0800 (PST)
Received: from gvm01 (net-2-45-26-236.cust.vodafonedsl.it. [2.45.26.236])
        by smtp.gmail.com with ESMTPSA id tk4-20020a170907c28400b007c16fdc93ddsm1393164ejc.81.2022.12.16.16.48.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Dec 2022 16:48:50 -0800 (PST)
Date:   Sat, 17 Dec 2022 01:48:48 +0100
From:   Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Oleksij Rempel <o.rempel@pengutronix.de>
Subject: [PATCH v7 net-next 3/5] drivers/net/phy: add connection between
 ethtool and phylib for PLCA
Message-ID: <cbb3d786e807170d5b7e3d6dfdba93c7ccc6c31a.1671234284.git.piergiorgio.beruto@gmail.com>
References: <cover.1671234284.git.piergiorgio.beruto@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1671234284.git.piergiorgio.beruto@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds the required connection between netlink ethtool and
phylib to resolve PLCA get/set config and get status messages.

Signed-off-by: Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
---
 drivers/net/phy/phy.c        | 172 +++++++++++++++++++++++++++++++++++
 drivers/net/phy/phy_device.c |   3 +
 include/linux/phy.h          |   7 ++
 3 files changed, 182 insertions(+)

diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index e5b6cb1a77f9..7631351b0a44 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -543,6 +543,178 @@ int phy_ethtool_get_stats(struct phy_device *phydev,
 }
 EXPORT_SYMBOL(phy_ethtool_get_stats);
 
+/**
+ * phy_ethtool_get_plca_cfg - Get PLCA RS configuration
+ * @phydev: the phy_device struct
+ * @plca_cfg: where to store the retrieved configuration
+ *
+ * Retrieve the PLCA configuration from the PHY. Return 0 on success or a
+ * negative value if an error occurred.
+ */
+int phy_ethtool_get_plca_cfg(struct phy_device *phydev,
+			     struct phy_plca_cfg *plca_cfg)
+{
+	int ret;
+
+	if (!phydev->drv) {
+		ret = -EIO;
+		goto out;
+	}
+
+	if (!phydev->drv->get_plca_cfg) {
+		ret = -EOPNOTSUPP;
+		goto out;
+	}
+
+	mutex_lock(&phydev->lock);
+	ret = phydev->drv->get_plca_cfg(phydev, plca_cfg);
+
+	mutex_unlock(&phydev->lock);
+out:
+	return ret;
+}
+
+/**
+ * phy_ethtool_set_plca_cfg - Set PLCA RS configuration
+ * @phydev: the phy_device struct
+ * @plca_cfg: new PLCA configuration to apply
+ * @extack: extack for reporting useful error messages
+ *
+ * Sets the PLCA configuration in the PHY. Return 0 on success or a
+ * negative value if an error occurred.
+ */
+int phy_ethtool_set_plca_cfg(struct phy_device *phydev,
+			     const struct phy_plca_cfg *plca_cfg,
+			     struct netlink_ext_ack *extack)
+{
+	struct phy_plca_cfg *curr_plca_cfg;
+	int ret;
+
+	if (!phydev->drv) {
+		ret = -EIO;
+		goto out;
+	}
+
+	if (!phydev->drv->set_plca_cfg ||
+	    !phydev->drv->get_plca_cfg) {
+		ret = -EOPNOTSUPP;
+		goto out;
+	}
+
+	curr_plca_cfg = kmalloc(sizeof(*curr_plca_cfg), GFP_KERNEL);
+	if (unlikely(!curr_plca_cfg)) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	mutex_lock(&phydev->lock);
+
+	ret = phydev->drv->get_plca_cfg(phydev, curr_plca_cfg);
+	if (ret)
+		goto out_drv;
+
+	if (curr_plca_cfg->enabled < 0 && plca_cfg->enabled >= 0) {
+		NL_SET_ERR_MSG(extack,
+			       "PHY does not support changing the PLCA 'enable' attribute");
+		ret = -EINVAL;
+		goto out_drv;
+	}
+
+	if (curr_plca_cfg->node_id < 0 && plca_cfg->node_id >= 0) {
+		NL_SET_ERR_MSG(extack,
+			       "PHY does not support changing the PLCA 'local node ID' attribute");
+		ret = -EINVAL;
+		goto out_drv;
+	}
+
+	if (curr_plca_cfg->node_cnt < 0 && plca_cfg->node_cnt >= 0) {
+		NL_SET_ERR_MSG(extack,
+			       "PHY does not support changing the PLCA 'node count' attribute");
+		ret = -EINVAL;
+		goto out_drv;
+	}
+
+	if (curr_plca_cfg->to_tmr < 0 && plca_cfg->to_tmr >= 0) {
+		NL_SET_ERR_MSG(extack,
+			       "PHY does not support changing the PLCA 'TO timer' attribute");
+		ret = -EINVAL;
+		goto out_drv;
+	}
+
+	if (curr_plca_cfg->burst_cnt < 0 && plca_cfg->burst_cnt >= 0) {
+		NL_SET_ERR_MSG(extack,
+			       "PHY does not support changing the PLCA 'burst count' attribute");
+		ret = -EINVAL;
+		goto out_drv;
+	}
+
+	if (curr_plca_cfg->burst_tmr < 0 && plca_cfg->burst_tmr >= 0) {
+		NL_SET_ERR_MSG(extack,
+			       "PHY does not support changing the PLCA 'burst timer' attribute");
+		ret = -EINVAL;
+		goto out_drv;
+	}
+
+	// if enabling PLCA, perform additional sanity checks
+	if (plca_cfg->enabled > 0) {
+		if (!linkmode_test_bit(ETHTOOL_LINK_MODE_10baseT1S_P2MP_Half_BIT,
+				       phydev->advertising)) {
+			ret = -EOPNOTSUPP;
+			NL_SET_ERR_MSG(extack,
+				       "Point to Multi-Point mode is not enabled");
+		}
+
+		// allow setting node_id concurrently with enabled
+		if (plca_cfg->node_id >= 0)
+			curr_plca_cfg->node_id = plca_cfg->node_id;
+
+		if (curr_plca_cfg->node_id >= 255) {
+			NL_SET_ERR_MSG(extack, "PLCA node ID is not set");
+			ret = -EINVAL;
+			goto out_drv;
+		}
+	}
+
+	ret = phydev->drv->set_plca_cfg(phydev, plca_cfg);
+
+out_drv:
+	kfree(curr_plca_cfg);
+	mutex_unlock(&phydev->lock);
+out:
+	return ret;
+}
+
+/**
+ * phy_ethtool_get_plca_status - Get PLCA RS status information
+ * @phydev: the phy_device struct
+ * @plca_st: where to store the retrieved status information
+ *
+ * Retrieve the PLCA status information from the PHY. Return 0 on success or a
+ * negative value if an error occurred.
+ */
+int phy_ethtool_get_plca_status(struct phy_device *phydev,
+				struct phy_plca_status *plca_st)
+{
+	int ret;
+
+	if (!phydev->drv) {
+		ret = -EIO;
+		goto out;
+	}
+
+	if (!phydev->drv->get_plca_status) {
+		ret = -EOPNOTSUPP;
+		goto out;
+	}
+
+	mutex_lock(&phydev->lock);
+	ret = phydev->drv->get_plca_status(phydev, plca_st);
+
+	mutex_unlock(&phydev->lock);
+out:
+	return ret;
+}
+
 /**
  * phy_start_cable_test - Start a cable test
  *
diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 8e48b3cec5e7..44bd06be9691 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -3276,6 +3276,9 @@ static const struct ethtool_phy_ops phy_ethtool_phy_ops = {
 	.get_sset_count		= phy_ethtool_get_sset_count,
 	.get_strings		= phy_ethtool_get_strings,
 	.get_stats		= phy_ethtool_get_stats,
+	.get_plca_cfg		= phy_ethtool_get_plca_cfg,
+	.set_plca_cfg		= phy_ethtool_set_plca_cfg,
+	.get_plca_status	= phy_ethtool_get_plca_status,
 	.start_cable_test	= phy_start_cable_test,
 	.start_cable_test_tdr	= phy_start_cable_test_tdr,
 };
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 2a5c2d3a5da5..e0dcd534fe6f 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -1845,6 +1845,13 @@ int phy_ethtool_get_strings(struct phy_device *phydev, u8 *data);
 int phy_ethtool_get_sset_count(struct phy_device *phydev);
 int phy_ethtool_get_stats(struct phy_device *phydev,
 			  struct ethtool_stats *stats, u64 *data);
+int phy_ethtool_get_plca_cfg(struct phy_device *phydev,
+			     struct phy_plca_cfg *plca_cfg);
+int phy_ethtool_set_plca_cfg(struct phy_device *phydev,
+			     const struct phy_plca_cfg *plca_cfg,
+			     struct netlink_ext_ack *extack);
+int phy_ethtool_get_plca_status(struct phy_device *phydev,
+				struct phy_plca_status *plca_st);
 
 static inline int phy_package_read(struct phy_device *phydev, u32 regnum)
 {
-- 
2.37.4

