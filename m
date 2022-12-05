Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E70BF642E83
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 18:18:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230327AbiLERSx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 12:18:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231735AbiLERSq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 12:18:46 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D634A1DA50;
        Mon,  5 Dec 2022 09:18:36 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id a16so16716997edb.9;
        Mon, 05 Dec 2022 09:18:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Zx0zh9a0T5iZl9sxln0TAiuWj203m7h4iKF2Szbvrp0=;
        b=jSRRIsLEFMBVj3qpqpW89bggaUueg/zOAPVp6qJGJ3NEMhVQodAYjRuUX9gcLIsmD6
         u/LwE1AgB1cZDVMvnWx6GUeieEGO3hVUGesq/9cQ1cMOj0zlYiYmCm65FZeJQED4n9GB
         yS5HZE2X4cdJr/bsK6Rr/nNo+oQkHCb+PtnSilECn1OZKl8Dtu4LPtQYHS7wb6sguRys
         Dj+R3aXg5fXxRrLfoueTPXplls8hwNZCPcAhjoZNbM+yMESzrE3Wa4uAuGjHY9Rnu/eT
         K/xHUkenSKHocsmMa9sfp7uWa1gfq1PUA3s+8pnzY4mdcvB+d1rt5xVDGZcHNjl9PyJd
         T+KA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Zx0zh9a0T5iZl9sxln0TAiuWj203m7h4iKF2Szbvrp0=;
        b=AXuTGkbALQDvQ3PDO+zG3fiEGcAfSwhlXuH3pNlmbUp9Gqs2VilqJhQ+7y2eTl46eu
         7oweeFB8oFIwOsPTf7vXe99iC0U0idM+E2v4ooD81YHQXN2DN28iv2Xer22JdMpBENoI
         CK9cw5kvtqCWMKdqi9m/rpSYnROPEf49qzYDBObiByP1ZYzFSxMnDDZX1MaHtw+5K2Xp
         1immyK2Q367H0nATs8n8AYRBTRIXwUwyVHtkLqZVuwJGOq97azqz0dwQbcbMR1jYYYtU
         rf4bv6LwQsU//LK2Y13jnOHygOeJEm0+Imjhp+2MpdZMoSUrA3hJLvS0l3av6ovwu7cn
         R2Ww==
X-Gm-Message-State: ANoB5pns3F/YXZDKZ6RjPszS1HER61fv6/rzpE5psaCe7e6ouxXeInlN
        jQfjBSfsagTCwwSrf21AOVU=
X-Google-Smtp-Source: AA0mqf6XbTFq8SgEqKhpDxuQLqs5VOf28Fs1eNYZKLIS0lC9P+CFvkjOCcyL+HyGdPgMngn4EJuBsw==
X-Received: by 2002:aa7:c509:0:b0:46c:42b8:b3b8 with SMTP id o9-20020aa7c509000000b0046c42b8b3b8mr12326939edq.37.1670260715424;
        Mon, 05 Dec 2022 09:18:35 -0800 (PST)
Received: from gvm01 (net-2-45-26-236.cust.vodafonedsl.it. [2.45.26.236])
        by smtp.gmail.com with ESMTPSA id t10-20020a05640203ca00b004611c230bd0sm24243edw.37.2022.12.05.09.18.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Dec 2022 09:18:35 -0800 (PST)
Date:   Mon, 5 Dec 2022 18:18:44 +0100
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
Subject: [PATCH v3 net-next 3/4] drivers/net/phy: add connection between
 ethtool and phylib for PLCA
Message-ID: <30e223d2d6d6e8aa1aaf7fbc492127164402af17.1670259123.git.piergiorgio.beruto@gmail.com>
References: <d53ffecdde8d3950a24155228a3439f2c9b10b9b.1670259123.git.piergiorgio.beruto@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d53ffecdde8d3950a24155228a3439f2c9b10b9b.1670259123.git.piergiorgio.beruto@gmail.com>
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
 drivers/net/phy/phy.c | 163 +++++++++++++++++++++++++++++++++++++++---
 include/linux/phy.h   |  17 ++++-
 2 files changed, 168 insertions(+), 12 deletions(-)

diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index 99e3497b6aa1..6bea928e405b 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -544,36 +544,181 @@ int phy_ethtool_get_stats(struct phy_device *phydev,
 EXPORT_SYMBOL(phy_ethtool_get_stats);
 
 /**
+ * phy_ethtool_get_plca_cfg - Get PLCA RS configuration
  *
+ * @phydev: the phy_device struct
+ * @plca_cfg: where to store the retrieved configuration
  */
-int phy_ethtool_get_plca_cfg(struct phy_device *dev,
+int phy_ethtool_get_plca_cfg(struct phy_device *phydev,
 			     struct phy_plca_cfg *plca_cfg)
 {
-	// TODO
-	return 0;
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
+	memset(plca_cfg, 0xFF, sizeof(*plca_cfg));
+
+	mutex_lock(&phydev->lock);
+	ret = phydev->drv->get_plca_cfg(phydev, plca_cfg);
+
+	if (ret)
+		goto out_drv;
+
+out_drv:
+	mutex_unlock(&phydev->lock);
+out:
+	return ret;
 }
 EXPORT_SYMBOL(phy_ethtool_get_plca_cfg);
 
 /**
+ * phy_ethtool_set_plca_cfg - Set PLCA RS configuration
  *
+ * @phydev: the phy_device struct
+ * @extack: extack for reporting useful error messages
+ * @plca_cfg: new PLCA configuration to apply
  */
-int phy_ethtool_set_plca_cfg(struct phy_device *dev,
+int phy_ethtool_set_plca_cfg(struct phy_device *phydev,
 			     struct netlink_ext_ack *extack,
 			     const struct phy_plca_cfg *plca_cfg)
 {
-	// TODO
-	return 0;
+	int ret;
+	struct phy_plca_cfg *curr_plca_cfg = 0;
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
+	memset(curr_plca_cfg, 0xFF, sizeof(*curr_plca_cfg));
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
+	if (ret)
+		goto out_drv;
+
+out_drv:
+	kfree(curr_plca_cfg);
+	mutex_unlock(&phydev->lock);
+out:
+	return ret;
+
 }
 EXPORT_SYMBOL(phy_ethtool_set_plca_cfg);
 
 /**
+ * phy_ethtool_get_plca_status - Get PLCA RS status information
  *
+ * @phydev: the phy_device struct
+ * @plca_st: where to store the retrieved status information
  */
-int phy_ethtool_get_plca_status(struct phy_device *dev,
+int phy_ethtool_get_plca_status(struct phy_device *phydev,
 				struct phy_plca_status *plca_st)
 {
-	// TODO
-	return 0;
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
+	if (ret)
+		goto out_drv;
+
+out_drv:
+	mutex_unlock(&phydev->lock);
+out:
+	return ret;
 }
 EXPORT_SYMBOL(phy_ethtool_get_plca_status);
 
diff --git a/include/linux/phy.h b/include/linux/phy.h
index ab2c134d0a05..49d0488bf480 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -1036,6 +1036,17 @@ struct phy_driver {
 	int (*get_sqi)(struct phy_device *dev);
 	/** @get_sqi_max: Get the maximum signal quality indication */
 	int (*get_sqi_max)(struct phy_device *dev);
+
+	/* PLCA RS interface */
+	/** @get_plca_cfg: Return the current PLCA configuration */
+	int (*get_plca_cfg)(struct phy_device *dev,
+			    struct phy_plca_cfg *plca_cfg);
+	/** @set_plca_cfg: Set the PLCA configuration */
+	int (*set_plca_cfg)(struct phy_device *dev,
+			    const struct phy_plca_cfg *plca_cfg);
+	/** @get_plca_status: Return the current PLCA status info */
+	int (*get_plca_status)(struct phy_device *dev,
+			       struct phy_plca_status *plca_st);
 };
 #define to_phy_driver(d) container_of(to_mdio_common_driver(d),		\
 				      struct phy_driver, mdiodrv)
@@ -1832,12 +1843,12 @@ int phy_ethtool_get_strings(struct phy_device *phydev, u8 *data);
 int phy_ethtool_get_sset_count(struct phy_device *phydev);
 int phy_ethtool_get_stats(struct phy_device *phydev,
 			  struct ethtool_stats *stats, u64 *data);
-int phy_ethtool_get_plca_cfg(struct phy_device *dev,
+int phy_ethtool_get_plca_cfg(struct phy_device *phydev,
 			     struct phy_plca_cfg *plca_cfg);
-int phy_ethtool_set_plca_cfg(struct phy_device *dev,
+int phy_ethtool_set_plca_cfg(struct phy_device *phydev,
 			     struct netlink_ext_ack *extack,
 			     const struct phy_plca_cfg *plca_cfg);
-int phy_ethtool_get_plca_status(struct phy_device *dev,
+int phy_ethtool_get_plca_status(struct phy_device *phydev,
 				struct phy_plca_status *plca_st);
 
 static inline int phy_package_read(struct phy_device *phydev, u32 regnum)
-- 
2.35.1

