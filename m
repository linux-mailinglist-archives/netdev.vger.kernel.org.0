Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1868165D507
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 15:07:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239407AbjADOHe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 09:07:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239591AbjADOHE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 09:07:04 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75F601EC76;
        Wed,  4 Jan 2023 06:06:24 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id l29so41627938edj.7;
        Wed, 04 Jan 2023 06:06:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=efB9GO8iFldottZwd6LVQFIVRzzHVvHdwa8E5iusRNw=;
        b=QKA4kaB+sL41tk6uYoVFUrr6pNsJO0C0qVA1UNVcBLrmEILrzFA0Qeuf6KAzJtTrjy
         QSAJfDaGIkAod9zL8m9UkyGLbgDW7MN7O1Izs/o1BDghwFJgYT1anyuRXyCKkLDjXqXf
         oN3zIshkkzVFKIiqPEtgvonEj7p3DTmAzLPA3Kt3bkEMcBqGS0MxdS183hFHKU+7av1B
         wPU5qN/GY614bUtWQ2eo9MEMnQsOxO+8N7LxYB8w4PyM/IrVx94vdVCFa3wU6XuBMVRu
         +700fz94u99mC2mRY3/aSbPnOTdeKJl1sMY/UN3ZHJfeuwUjtcuW6hn5fcq7JUhGGKYq
         YIIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=efB9GO8iFldottZwd6LVQFIVRzzHVvHdwa8E5iusRNw=;
        b=RyTkzhRyIiegVq5N8wwwnE6VLa2d8lFf3tI6isM+8ibTXgU+BgkUCD+Y+pjVEnewvG
         Yz+p0wgvOCMGvK3xtjPQnsgX+sCHZMLUoY6/EMWTvfBZPjKTRcy/0duu0QDliCN5XnhD
         VMKNmki0c8e89RE2d+mUkEc/MP8W0KYLEvcNNR7IQ9/XeepzoDgwSN727xrHBQt38AK+
         H1jgMT4mI2C2H4EHyfY5/Rcikf0iavxT+5wh4s2G2ymW7U1uca/aLiJ8JeQyanN3KrGi
         N82tAmu+En73K9SUBwoy2ka/dSDYXkNf3xbMWzaCohtO2yaQk0UXOstVG0+Dwuuae3i+
         chSQ==
X-Gm-Message-State: AFqh2kqZyDwl+evJjap/meyH7KTdP9jovchCZF4OI9fKEPysjYqjvDFz
        NYdzIP0B5SVJtQ7MB5gVF8c=
X-Google-Smtp-Source: AMrXdXt1kayB9Z4wbaSkcQMy1T9SNQx22C12PYTRz2dGRHRHrns+7o5dxlwqt+IKEboizs+MGD/A/Q==
X-Received: by 2002:a50:d5d7:0:b0:474:4a60:bc6b with SMTP id g23-20020a50d5d7000000b004744a60bc6bmr43211900edj.5.1672841182883;
        Wed, 04 Jan 2023 06:06:22 -0800 (PST)
Received: from gvm01 (net-5-89-66-224.cust.vodafonedsl.it. [5.89.66.224])
        by smtp.gmail.com with ESMTPSA id x15-20020aa7dacf000000b004589da5e5cesm14839967eds.41.2023.01.04.06.06.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Jan 2023 06:06:22 -0800 (PST)
Date:   Wed, 4 Jan 2023 15:06:30 +0100
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
Subject: [PATCH net-next 3/5] drivers/net/phy: add connection between ethtool
 and phylib for PLCA
Message-ID: <5d9b49cb21c97bf187502d4f6000f1084a7e4df7.1672840326.git.piergiorgio.beruto@gmail.com>
References: <cover.1672840325.git.piergiorgio.beruto@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1672840325.git.piergiorgio.beruto@gmail.com>
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

