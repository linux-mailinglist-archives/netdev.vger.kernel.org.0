Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A5C6644FEB
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 01:02:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229692AbiLGACP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 19:02:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229798AbiLGAB5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 19:01:57 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13DAC49083;
        Tue,  6 Dec 2022 16:01:55 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id x22so10157928ejs.11;
        Tue, 06 Dec 2022 16:01:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Hp7aegHQL/VcwqFRTSdu/GwDmHSFMjOcY3IIQ3kMIu8=;
        b=UJhwcvQ+n8+9IMB0kLRfudqjlvimCczsjSAJrv1GITLNr5YLPF+PMxizkZzMiB2RXH
         rBa++Dk8hL/9Q8voetmnRIIdpfUF+dpp1g87kJ5I3OC14F48w7xJuXyTVAMRhXQ1/Hyx
         8lVYTkRvQdGVHtpevYNphfwNqirUS+e49ckj739Z4p4g5eNKoNaEtd2OknTcL0Kgw1Nu
         3koEu7SdUEM2ugUTnjH0cclTvRt07BGTDmlI45vkdgRpDYAmNcFabHEtWFMynePi+jbQ
         sRxTKslkSNhDU2V7Lyx66LE1OTBLgDfJAuNQZw2dzBUnp1hIqHKd8rcmF5UwJlOerWJt
         eSKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Hp7aegHQL/VcwqFRTSdu/GwDmHSFMjOcY3IIQ3kMIu8=;
        b=hEFs9nHH4sA0Akm0tQ0gyUq35ssFUhUiXZnlIreQdX32hbWQKPXCE3ufHlG+ofaN+s
         SeLunc9GR4o+lN2sKO3agOtbzVtUAoS2M92Wo89L2qoae0wIffeqyTuo4LBHm77CEmKT
         61teoCosRRNNbpl7WTQOBWVOfSda28HHuMdLdOC6bMThPnPKJauK2i99JpJRyi+V+7q7
         teLSi93e8s72AcpX/4Bc22nrLgP0Y1/cNDdekVCSSDNvisFi89z4G/q8VNlvuuzj6nBP
         tT64GLIemZYSBo2dAiaILfXL/boEXKC5wB5VlpgOTcIOByliouLXxv0BSQWSehxGUzKB
         GFxw==
X-Gm-Message-State: ANoB5pnyLG4zG8CXg1eLGcIB0uX/KdhxhSeYko0/Mwfr+DlC/mxIe2g2
        dxuGRFs+psFwzc9erbj3XVQ=
X-Google-Smtp-Source: AA0mqf5d0RCz32YPznfSo5jFSzVVF1CGLU8LgBMU3SoFPl+m8tnvavPv9J3j6Cv0CbfjSG5ft+6TRA==
X-Received: by 2002:a17:906:404:b0:781:f54c:1947 with SMTP id d4-20020a170906040400b00781f54c1947mr63563316eja.69.1670371314410;
        Tue, 06 Dec 2022 16:01:54 -0800 (PST)
Received: from gvm01 (net-2-45-26-236.cust.vodafonedsl.it. [2.45.26.236])
        by smtp.gmail.com with ESMTPSA id p10-20020a170906838a00b007c0dacbe00bsm4279034ejx.115.2022.12.06.16.01.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Dec 2022 16:01:54 -0800 (PST)
Date:   Wed, 7 Dec 2022 01:02:05 +0100
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
Subject: [PATCH v5 net-next 3/5] drivers/net/phy: add connection between
 ethtool and phylib for PLCA
Message-ID: <cbca831071bfe60a34a84b45b945efd4ce3b4449.1670371013.git.piergiorgio.beruto@gmail.com>
References: <cover.1670371013.git.piergiorgio.beruto@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1670371013.git.piergiorgio.beruto@gmail.com>
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
 drivers/net/phy/phy.c        | 175 +++++++++++++++++++++++++++++++++++
 drivers/net/phy/phy_device.c |   3 +
 2 files changed, 178 insertions(+)

diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index e5b6cb1a77f9..3fc251f5de26 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -543,6 +543,181 @@ int phy_ethtool_get_stats(struct phy_device *phydev,
 }
 EXPORT_SYMBOL(phy_ethtool_get_stats);
 
+/**
+ * phy_ethtool_get_plca_cfg - Get PLCA RS configuration
+ *
+ * @phydev: the phy_device struct
+ * @plca_cfg: where to store the retrieved configuration
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
+}
+
+/**
+ * phy_ethtool_set_plca_cfg - Set PLCA RS configuration
+ *
+ * @phydev: the phy_device struct
+ * @extack: extack for reporting useful error messages
+ * @plca_cfg: new PLCA configuration to apply
+ */
+int phy_ethtool_set_plca_cfg(struct phy_device *phydev,
+			     struct netlink_ext_ack *extack,
+			     const struct phy_plca_cfg *plca_cfg)
+{
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
+}
+
+/**
+ * phy_ethtool_get_plca_status - Get PLCA RS status information
+ *
+ * @phydev: the phy_device struct
+ * @plca_st: where to store the retrieved status information
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
+	if (ret)
+		goto out_drv;
+
+out_drv:
+	mutex_unlock(&phydev->lock);
+out:
+	return ret;
+}
+
 /**
  * phy_start_cable_test - Start a cable test
  *
diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 716870a4499c..f248010c403d 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -3262,6 +3262,9 @@ static const struct ethtool_phy_ops phy_ethtool_phy_ops = {
 	.get_sset_count		= phy_ethtool_get_sset_count,
 	.get_strings		= phy_ethtool_get_strings,
 	.get_stats		= phy_ethtool_get_stats,
+	.get_plca_cfg		= phy_ethtool_get_plca_cfg,
+	.set_plca_cfg		= phy_ethtool_set_plca_cfg,
+	.get_plca_status	= phy_ethtool_get_plca_status,
 	.start_cable_test	= phy_start_cable_test,
 	.start_cable_test_tdr	= phy_start_cable_test_tdr,
 };
-- 
2.35.1

