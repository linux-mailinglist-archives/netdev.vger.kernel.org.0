Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A96A661B4A
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 01:11:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233937AbjAIAK6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Jan 2023 19:10:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234125AbjAIAKq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Jan 2023 19:10:46 -0500
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E87DA45B;
        Sun,  8 Jan 2023 16:10:32 -0800 (PST)
Received: by mail-wm1-x331.google.com with SMTP id bi26-20020a05600c3d9a00b003d3404a89faso6165096wmb.1;
        Sun, 08 Jan 2023 16:10:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=G+g2oiB8hBmHKK/9VB8V5x7k3LgCXg/f7UEmyK5AYaQ=;
        b=CQKMVbS7zk4Oo7Lkq30IzyMfaCGMDB0ifQa2XWRRTaP2602Li02zNATQe/TRWQ4tXX
         mUROKzx5dJyF9h+VP6kAH0QV0uFam3++Uk3FfumHuWBoh3ADG1pRL/2gA9kOBs7AoBlx
         XDD4PTwA4Ua9Y3PyxmI0QrOSGzo6/mPX0LFdSxVmZXGUpXJsL5pdcA48aAG7Mwsy7/LB
         Gdq09H5Qc5C4xwbavsAjY/1LlAzuYhVHZsv7Nqs/tYzF6VQsMpd5ERMiSxnOTBZHAAOr
         l9F+MDXDGETj1U4Puup+qWU1dhAjoJ6XxAHhm1WyfKwUQxUstIHNRsXA/+g2M1PMCsBp
         /ISw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=G+g2oiB8hBmHKK/9VB8V5x7k3LgCXg/f7UEmyK5AYaQ=;
        b=eQHvKWA7UGrDbb7aWVoxKuRBf0J1nDJqZjdBkIkQ5dYMZrMbgvziiT+UHmCLA5DrT7
         r0qTVJTfoyCb5R0Iwu1pCeJRnb+yp0+Qe4vpUXMia0lAHaORKni4hIzeD4qlFUJu4+Bi
         m0p1IK7Kdqx2hu+VvxNG9nFculEdnme+v3MDtaj5p3Hdjc23hc21BzRpygBgi8jv2sYp
         5U1nrMhQanlTVJwU73dFVzrgaQFnQJ1zULI2Rd784hp+TlLH8B1W2eXGclIQZ0J8Cmoh
         8tb4TcAC7dp9VzPL5CZI0z2spLdymOEErR+0Gs//lKSYAvaH2/IeenJH7XSS2Q9EU/YR
         iIMA==
X-Gm-Message-State: AFqh2kpP8MmCK3T5xP7Bnc72Uz4lciK/IlDgMwbR+2lU5xYFPYIoUbN6
        ExAdHAgsZJfRDHy2y2XG59c=
X-Google-Smtp-Source: AMrXdXtKSU1vNFmbSuZxf/IMn3lCdHtn7R2H337cRz/uPmOQ34f7CbPABT2fN+PgjenTxlXuO8EPHQ==
X-Received: by 2002:a7b:cd11:0:b0:3d9:e9ad:d9bf with SMTP id f17-20020a7bcd11000000b003d9e9add9bfmr3157180wmj.6.1673223030812;
        Sun, 08 Jan 2023 16:10:30 -0800 (PST)
Received: from gvm01 (net-5-89-66-224.cust.vodafonedsl.it. [5.89.66.224])
        by smtp.gmail.com with ESMTPSA id z9-20020a7bc7c9000000b003d9ef37ec1bsm2497590wmk.5.2023.01.08.16.10.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Jan 2023 16:10:30 -0800 (PST)
Date:   Mon, 9 Jan 2023 01:10:29 +0100
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
        gal@nvidia.com, gustavoars@kernel.org, bagasdotme@gmail.com
Subject: [PATCH v3 net-next 3/5] drivers/net/phy: add connection between
 ethtool and phylib for PLCA
Message-ID: <231f9bd7697c0700af37b8a2292bc1a21dd6fef0.1673222807.git.piergiorgio.beruto@gmail.com>
References: <cover.1673222807.git.piergiorgio.beruto@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1673222807.git.piergiorgio.beruto@gmail.com>
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
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/phy/phy.c        | 192 +++++++++++++++++++++++++++++++++++
 drivers/net/phy/phy_device.c |   3 +
 include/linux/phy.h          |   7 ++
 3 files changed, 202 insertions(+)

diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index e5b6cb1a77f9..3378ca4f49b6 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -543,6 +543,198 @@ int phy_ethtool_get_stats(struct phy_device *phydev,
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
+ * plca_check_valid - Check PLCA configuration before enabling
+ * @phydev: the phy_device struct
+ * @plca_cfg: current PLCA configuration
+ * @extack: extack for reporting useful error messages
+ *
+ * Checks whether the PLCA and PHY configuration are consistent and it is safe
+ * to enable PLCA. Returns 0 on success or a negative value if the PLCA or PHY
+ * configuration is not consistent.
+ */
+static int plca_check_valid(struct phy_device *phydev,
+			    const struct phy_plca_cfg *plca_cfg,
+			    struct netlink_ext_ack *extack)
+{
+	int ret = 0;
+
+	if (!linkmode_test_bit(ETHTOOL_LINK_MODE_10baseT1S_P2MP_Half_BIT,
+			       phydev->advertising)) {
+		ret = -EOPNOTSUPP;
+		NL_SET_ERR_MSG(extack,
+			       "Point to Multi-Point mode is not enabled");
+	} else if (plca_cfg->node_id >= 255) {
+		NL_SET_ERR_MSG(extack, "PLCA node ID is not set");
+		ret = -EINVAL;
+	}
+
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
+	// if enabling PLCA, perform a few sanity checks
+	if (plca_cfg->enabled > 0) {
+		// allow setting node_id concurrently with enabled
+		if (plca_cfg->node_id >= 0)
+			curr_plca_cfg->node_id = plca_cfg->node_id;
+
+		ret = plca_check_valid(phydev, curr_plca_cfg, extack);
+		if (ret)
+			goto out_drv;
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

