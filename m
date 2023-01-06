Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3728660693
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 19:45:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235900AbjAFSpP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 13:45:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235938AbjAFSpL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 13:45:11 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7179880636;
        Fri,  6 Jan 2023 10:45:10 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id s5so3386465edc.12;
        Fri, 06 Jan 2023 10:45:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Fq/JT8mIcnfheviEzYwBfrP9wLo3ZKknZ8tWKeZ1Z8E=;
        b=PHi8Hzospc10d7C+yrJiNjRfm6eU5vFAA6OJOaneQATYCEuj2tHcZkxebl33mZOmzE
         AeLAXhI9bWSWcR/9IRz9+XVghbFBjbzZYH/ruTU1bMX2+rGD6EEK8zR9T3fAnUrHGRcf
         a01TER9VAiNKdaB0tkc8IqQvmYd3AXpW44x1yD58zw6mn/9tmqnW71lCHZ9cm6ypb5jM
         dMcsS8bC2+iDmMRCrxjp3oVrRTr2Zo1pExIAPSzaPzhR6+ZOGsx7CRp6aqsYr5WQ1u95
         mNqXqpYYZPdMX0dSQOv3JXj1EQFIkb9ncjB4C6UFjkSnmBGTtNzHuQBaUdaPohAgQPVG
         M2PA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Fq/JT8mIcnfheviEzYwBfrP9wLo3ZKknZ8tWKeZ1Z8E=;
        b=fSSp36VBbuHqbGnO2QvXjrXzopfoEmMbwi9luCnK5juv8ExT58B++rzeoi4Ooz5Fy1
         i3vO42SAyNe/i3TlEBAsw9XX3Edfb4//p/Zq9FF44rNzGiMoGZlLKCLbdD5Z3Q+TgKzF
         Fz0K/B8WNw5ozFa6FQCGyUsVTK2/lyF5F+zbHyd1RkU8Hak6olTfQGKAOtOAnrIpYJHE
         nNBLGKIJQSlcN5q0eQ9LJOEWBPxupgrJLKxpALh1zw3gwl4hezFmRRNp/gTXXCj2c9Rr
         ANX9OyyAFrLZJAsbsGoMRuCJvO6Up47RNADvshq4LOtzgdyNQmzkLRQ5Z3iSXnWrQwi/
         dYUw==
X-Gm-Message-State: AFqh2kocq1dTYuY1K+5qeuoMw4CSJ7tS+ftWGgeY7YDNrQK0cAewtnrx
        AFZyfndh0oFwvmKmwrHQzMQ=
X-Google-Smtp-Source: AMrXdXuKLFelmKdsVvATU7gpIbt64IsN0DvID4crI0mAR1/bWz/X0YF/v++hU3hQ6/xIPKJbgwV7qg==
X-Received: by 2002:a05:6402:291a:b0:48b:c8de:9d1a with SMTP id ee26-20020a056402291a00b0048bc8de9d1amr20032431edb.37.1673030709010;
        Fri, 06 Jan 2023 10:45:09 -0800 (PST)
Received: from gvm01 ([91.199.164.40])
        by smtp.gmail.com with ESMTPSA id cn23-20020a0564020cb700b004856bba2c8bsm729213edb.47.2023.01.06.10.45.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Jan 2023 10:45:08 -0800 (PST)
Date:   Fri, 6 Jan 2023 19:45:02 +0100
From:   Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        mailhol.vincent@wanadoo.fr, sudheer.mogilappagari@intel.com,
        sbhatta@marvell.com, linux-doc@vger.kernel.org,
        wangjie125@huawei.com, corbet@lwn.net, lkp@intel.com,
        gal@nvidia.com, gustavoars@kernel.org
Subject: [PATCH v2 net-next 3/5] drivers/net/phy: add connection between
 ethtool and phylib for PLCA
Message-ID: <9a25328bcf2c0d963e34d33ff0968f83755905f4.1673030528.git.piergiorgio.beruto@gmail.com>
References: <cover.1673030528.git.piergiorgio.beruto@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1673030528.git.piergiorgio.beruto@gmail.com>
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
 drivers/net/phy/phy.c        | 174 +++++++++++++++++++++++++++++++++++
 drivers/net/phy/phy_device.c |   3 +
 include/linux/phy.h          |   7 ++
 3 files changed, 184 insertions(+)

diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index e5b6cb1a77f9..4d67ca234816 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -543,6 +543,180 @@ int phy_ethtool_get_stats(struct phy_device *phydev,
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
+	if (!curr_plca_cfg) {
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
+	// if not enabling PLCA, skip a few sanity checks
+	if (plca_cfg->enabled <= 0)
+		goto apply_cfg;
+
+	if (!linkmode_test_bit(ETHTOOL_LINK_MODE_10baseT1S_P2MP_Half_BIT,
+			       phydev->advertising)) {
+		ret = -EOPNOTSUPP;
+		NL_SET_ERR_MSG(extack,
+			       "Point to Multi-Point mode is not enabled");
+	}
+
+	// allow setting node_id concurrently with enabled
+	if (plca_cfg->node_id >= 0)
+		curr_plca_cfg->node_id = plca_cfg->node_id;
+
+	if (curr_plca_cfg->node_id >= 255) {
+		NL_SET_ERR_MSG(extack, "PLCA node ID is not set");
+		ret = -EINVAL;
+		goto out_drv;
+	}
+
+apply_cfg:
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
index 1e87d3f05209..bcaf1dfd0687 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -1846,6 +1846,13 @@ int phy_ethtool_get_strings(struct phy_device *phydev, u8 *data);
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

