Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A379964437E
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 13:53:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234530AbiLFMxb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 07:53:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234553AbiLFMxW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 07:53:22 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0E19FCF;
        Tue,  6 Dec 2022 04:53:05 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id m19so20086754edj.8;
        Tue, 06 Dec 2022 04:53:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Hp7aegHQL/VcwqFRTSdu/GwDmHSFMjOcY3IIQ3kMIu8=;
        b=ZCuvHmkHDemAl+juwzPIhP0wBrPlylUL/PHX4cO6bZqdeBuciC6Y22Qsvx7SYdV8TW
         uLUu+gCwGalnoAQg+58epv36kP/KqG+8kcwR9Y/ErIr2JHao3P0P2b48lDJSN4SNTiTi
         IFBPy6ecERyXQa35YllkQbRaJrIbMqnwwaUv1BYVT8V2bG0/OkJySGqjjEFKZl2dW4tS
         GyhQZMnyFso0L/E1GDEv++yhlLkZps1SczolutaLfdnri5YIxaLHpHxNx4ea34PqWDvC
         P+hyjpb2DDONvkPIoCmJq2GxuxvEdV+Ec/uYhwVkq8khoItwdnWMjGUKDfU3fA4AxqO3
         L05Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Hp7aegHQL/VcwqFRTSdu/GwDmHSFMjOcY3IIQ3kMIu8=;
        b=OCLBFWdz7HAcRcvvVqnz/A1WAu6r3NaVvgThBHH9p5Xzph7SLLcwOqI2GKezpO2bT7
         GRE9jXo6a5GTgYces4QkOn/eCb3kSt4gfBkb3LRxS1QWagO83Enlw9D3rZAjzKb9nW82
         X+kTiVJT8X2WA8pdL/0GylZrZTr+sGCc/bB5VaALmgZl4DrVY0gY1Z3KwJbvO8cfj8y5
         aKNp7J2r3DCwo3JUPlt6fAi6iu0u0WE40ehFNlVkmze3iS9nE6t0+DhB0L66/9KFl4lC
         4/fX6ZbIMse1SjoG2mDOMdwB+Qq9VeS0nvKdzjDQRL6O/nZVTGknA0+zZOUBIc8VE89G
         DxGg==
X-Gm-Message-State: ANoB5pmLhR3spnCJnP69rMiVJTiumRt5Rh2fA7tbY4ksSLJOmhyjBWQ9
        u6cUHd2I3KhQePeO7bXLRJ8=
X-Google-Smtp-Source: AA0mqf530HdUgqA6cbWz2YPbT4L2uoBR6Om5H6NAJPAMTAgdJbsi+hQKPajdxLSVdjzvki1ZTyfnCg==
X-Received: by 2002:a05:6402:2912:b0:46a:c132:8a25 with SMTP id ee18-20020a056402291200b0046ac1328a25mr45280969edb.205.1670331184298;
        Tue, 06 Dec 2022 04:53:04 -0800 (PST)
Received: from gvm01 (net-2-45-26-236.cust.vodafonedsl.it. [2.45.26.236])
        by smtp.gmail.com with ESMTPSA id h5-20020aa7c945000000b0044dbecdcd29sm941444edt.12.2022.12.06.04.53.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Dec 2022 04:53:03 -0800 (PST)
Date:   Tue, 6 Dec 2022 13:53:14 +0100
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
Subject: [PATCH v4 net-next 3/5] drivers/net/phy: add connection between
 ethtool and phylib for PLCA
Message-ID: <2f192989f373ff118f102ebca160aed220517031.1670329232.git.piergiorgio.beruto@gmail.com>
References: <cover.1670329232.git.piergiorgio.beruto@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1670329232.git.piergiorgio.beruto@gmail.com>
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

