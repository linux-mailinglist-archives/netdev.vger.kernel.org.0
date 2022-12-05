Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E193F642124
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 02:42:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231267AbiLEBmr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Dec 2022 20:42:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231244AbiLEBmq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Dec 2022 20:42:46 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6ABF02BC5;
        Sun,  4 Dec 2022 17:42:43 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id d20so13874623edn.0;
        Sun, 04 Dec 2022 17:42:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Zx0zh9a0T5iZl9sxln0TAiuWj203m7h4iKF2Szbvrp0=;
        b=awv0SkNFoyr16eJPD1g/QQTO0V97omRv/sGIo/J6X7kw5tJLVjtZgxT9r0BJNgk9tc
         vjP5ZOFI8z5KOB1ZiEwNvK1aCqhFYj2IHkU6NibVMYQg/mE75cv+pvEstYgrtCEo+L27
         DvdpOXEqjPV7ccvDCbGLTbm1UZwexlYkeY42dwuCdduYiD5jybI0EcCbm7QaOj1HS0Mf
         dDNVThICUpAGiSyhhN00jXUEfmk9exz96mfj6be3iLm5ufJYi/tY8xflJgmOKSct+o6d
         7fPc8cBi/gxGt7ikpQCyr7HWrWGj9bMT//JzG4oDawM/hfXMRX2ckEtSoz2QRKfXXM9+
         rAtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Zx0zh9a0T5iZl9sxln0TAiuWj203m7h4iKF2Szbvrp0=;
        b=A5o82ZLe6mjs0O9dLibj/7WKeResidaFN2Ye2vjHnqRJj07lNOOknfGKuah3m5cc1D
         1fKgv78kk3ZeV8zAKu8AdrS1Xy/mX/fu/Y7U3ieflKiS3018XlxgUvXDLODHkxSeJ8TQ
         oczlB4pnt9qDbIdOwpx4PDrWbRc/aS+zn0ZTZThKVAWRnFIiOe3QgYgF2jUcgkmaTHFh
         Is2VTnXBCLDzeLFGm7dtMxpPb9L+bwh6ngKeMXeY3yh6/6zLkqE/1GYxJl+6uV4HCm6Z
         xRMDRfiETG7eDETC6k5DCe5Ywkte8DKb2u7bhXrlE/xlVrG93KDUARvAp579byXn0eOM
         PjyQ==
X-Gm-Message-State: ANoB5pmfZDIi7cl+0h8FbSYcEsVPb/K5GK05wvLjePAP5Tye7mJ/HtKa
        LVq6yNwVcS4KhG4dtjMF0F4=
X-Google-Smtp-Source: AA0mqf6U4S1ctr+57KMeE6uhuQPlrgk2GwvkPURs2Uka6OmLr++iAM6sgKKgujFAuNRYRZCv1uDwwA==
X-Received: by 2002:a05:6402:4504:b0:463:71ef:b9ce with SMTP id ez4-20020a056402450400b0046371efb9cemr62319669edb.75.1670204561802;
        Sun, 04 Dec 2022 17:42:41 -0800 (PST)
Received: from gvm01 (net-2-45-26-236.cust.vodafonedsl.it. [2.45.26.236])
        by smtp.gmail.com with ESMTPSA id oz13-20020a170906cd0d00b007ae566edb8bsm5696074ejb.73.2022.12.04.17.42.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Dec 2022 17:42:41 -0800 (PST)
Date:   Mon, 5 Dec 2022 02:42:50 +0100
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
Subject: [PATCH v2 net-next 3/4] drivers/net/phy: add connection between
 ethtool and phylib for PLCA
Message-ID: <e03f71d6d0f6f205b99070813234087299ef1a02.1670204277.git.piergiorgio.beruto@gmail.com>
References: <fc3ac4f2d0c28d9c24b909e97791d1f784502a4a.1670204277.git.piergiorgio.beruto@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fc3ac4f2d0c28d9c24b909e97791d1f784502a4a.1670204277.git.piergiorgio.beruto@gmail.com>
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

