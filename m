Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74A7B398FD3
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 18:20:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230025AbhFBQWj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 12:22:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229978AbhFBQWg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Jun 2021 12:22:36 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90DD9C061574
        for <netdev@vger.kernel.org>; Wed,  2 Jun 2021 09:20:39 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id g8so4762929ejx.1
        for <netdev@vger.kernel.org>; Wed, 02 Jun 2021 09:20:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2DA9HGV5gAHjmfQUTJ8KwvaU2kjt03us8kFBmkRGg04=;
        b=hGIhBjM8Huo+Pc1+tWAHnYM82N3c0RGdXEYIztPwsTLgRjTkU3IhqTL9fMVK7DJywM
         owszF4b0rTuFfUf6KoBTAuNh/9BiYiZEdY61wTlpQieuktOnWZAQP3IIwLbOOySedeqS
         hkkX/NvIEiGHtQW283a4MxcRzbALOCFFU27Fxe0CFiQxq6ffhFyHNkjyRUTATWAqBnXg
         noP0QiVTk5QCbQoN2Dv7Nn76lBBFKQTmVscfkNTO6F+FsI6tkZQpk6zfkH5q4AlJcGzR
         0ti/lTOxfnjahq3nzS4XymVt2s5+nGh+PaTNtCikNQVY4W9SZ6cr+IFaCDUXVam7r5LF
         7XVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2DA9HGV5gAHjmfQUTJ8KwvaU2kjt03us8kFBmkRGg04=;
        b=Fh87hi9TkvSKZMSbXUUKKUvVdPKayQ7gmuoMxrk3Z6H0pjv7G6ANs3BqTTpIQoiiDa
         3PTxmGOnG0Etuj/ZQ/YCeqjaHJnrqXAcxpElVsVLncx3Jbw5Gj8N8KPYkfll0ZgiNjjt
         kejesD++eGFHi+PCuKirAsaz/P76Kwxnh6RIvodpuUqIPHCl6ID8PJH06GHNOMA1osAN
         RpEG4PAtUTCXTHwZf9k/Ww5YzsBgi0hwt+zCYvcnS/tZ7+0WYCXICevM5b28L65J3aEl
         YoOjZ05wfFBDniHv3PkzLGTPZXjX9xcIV8U2KbSHumFNM0zyNwftlXZHsDn+ucYbaSjE
         +yBw==
X-Gm-Message-State: AOAM533rJ6mkYJW7FMqzR5fNjUUFsXdoE2MZ4M8p55s5SDxXd/6U69Xl
        0Zu2xQeROstaYAJTaOAHEUc=
X-Google-Smtp-Source: ABdhPJw8/VmkzjMsE9GPy3gXpff8sNigFUICRddcGJMMxe9PdtUKytIJ8j4vcZ+eqOv7qP7GC0VNbg==
X-Received: by 2002:a17:906:63d2:: with SMTP id u18mr34803214ejk.186.1622650838090;
        Wed, 02 Jun 2021 09:20:38 -0700 (PDT)
Received: from localhost.localdomain ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id m12sm228078edc.40.2021.06.02.09.20.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Jun 2021 09:20:37 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Wong Vee Khee <vee.khee.wong@linux.intel.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v3 net-next 5/9] net: pcs: xpcs: export xpcs_config_eee
Date:   Wed,  2 Jun 2021 19:20:15 +0300
Message-Id: <20210602162019.2201925-6-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210602162019.2201925-1-olteanv@gmail.com>
References: <20210602162019.2201925-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

There is no good reason why we need to go through:

stmmac_xpcs_config_eee
-> stmmac_do_callback
   -> mdio_xpcs_ops->config_eee
      -> xpcs_config_eee

when we can simply call xpcs_config_eee.

priv->hw->xpcs is of the type "const struct mdio_xpcs_ops *" and is used
as a placeholder/synonym for priv->plat->mdio_bus_data->has_xpcs. It is
done that way because the mdio_bus_data pointer might or might not be
populated in all stmmac instantiations.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2: guard against potential absence of xpcs on the port
v2->v3: none

 drivers/net/ethernet/stmicro/stmmac/hwif.h           |  2 --
 drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c | 12 +++++++-----
 drivers/net/pcs/pcs-xpcs.c                           |  6 +++---
 include/linux/pcs/pcs-xpcs.h                         |  4 ++--
 4 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/hwif.h b/drivers/net/ethernet/stmicro/stmmac/hwif.h
index a86b358feae9..2d2843edaf21 100644
--- a/drivers/net/ethernet/stmicro/stmmac/hwif.h
+++ b/drivers/net/ethernet/stmicro/stmmac/hwif.h
@@ -621,8 +621,6 @@ struct stmmac_mmc_ops {
 	stmmac_do_callback(__priv, xpcs, link_up, __args)
 #define stmmac_xpcs_probe(__priv, __args...) \
 	stmmac_do_callback(__priv, xpcs, probe, __args)
-#define stmmac_xpcs_config_eee(__priv, __args...) \
-	stmmac_do_callback(__priv, xpcs, config_eee, __args)
 
 struct stmmac_regs_off {
 	u32 ptp_off;
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
index 1f6d749fd9a3..ba7d0f40723a 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
@@ -720,11 +720,13 @@ static int stmmac_ethtool_op_set_eee(struct net_device *dev,
 		netdev_warn(priv->dev,
 			    "Setting EEE tx-lpi is not supported\n");
 
-	ret = stmmac_xpcs_config_eee(priv, &priv->hw->xpcs_args,
-				     priv->plat->mult_fact_100ns,
-				     edata->eee_enabled);
-	if (ret)
-		return ret;
+	if (priv->hw->xpcs) {
+		ret = xpcs_config_eee(&priv->hw->xpcs_args,
+				      priv->plat->mult_fact_100ns,
+				      edata->eee_enabled);
+		if (ret)
+			return ret;
+	}
 
 	if (!edata->eee_enabled)
 		stmmac_disable_eee_mode(priv);
diff --git a/drivers/net/pcs/pcs-xpcs.c b/drivers/net/pcs/pcs-xpcs.c
index 2f7791bcf07b..2f2ffab855aa 100644
--- a/drivers/net/pcs/pcs-xpcs.c
+++ b/drivers/net/pcs/pcs-xpcs.c
@@ -715,8 +715,8 @@ void xpcs_validate(struct mdio_xpcs_args *xpcs, unsigned long *supported,
 }
 EXPORT_SYMBOL_GPL(xpcs_validate);
 
-static int xpcs_config_eee(struct mdio_xpcs_args *xpcs, int mult_fact_100ns,
-			   int enable)
+int xpcs_config_eee(struct mdio_xpcs_args *xpcs, int mult_fact_100ns,
+		    int enable)
 {
 	int ret;
 
@@ -747,6 +747,7 @@ static int xpcs_config_eee(struct mdio_xpcs_args *xpcs, int mult_fact_100ns,
 	ret |= DW_VR_MII_EEE_TRN_LPI;
 	return xpcs_write(xpcs, MDIO_MMD_VEND2, DW_VR_MII_EEE_MCTRL1, ret);
 }
+EXPORT_SYMBOL_GPL(xpcs_config_eee);
 
 static int xpcs_config_aneg_c37_sgmii(struct mdio_xpcs_args *xpcs)
 {
@@ -1033,7 +1034,6 @@ static struct mdio_xpcs_ops xpcs_ops = {
 	.get_state = xpcs_get_state,
 	.link_up = xpcs_link_up,
 	.probe = xpcs_probe,
-	.config_eee = xpcs_config_eee,
 };
 
 struct mdio_xpcs_ops *mdio_xpcs_get_ops(void)
diff --git a/include/linux/pcs/pcs-xpcs.h b/include/linux/pcs/pcs-xpcs.h
index 5ec9aaca01fe..ae74a336dcb9 100644
--- a/include/linux/pcs/pcs-xpcs.h
+++ b/include/linux/pcs/pcs-xpcs.h
@@ -30,13 +30,13 @@ struct mdio_xpcs_ops {
 	int (*link_up)(struct mdio_xpcs_args *xpcs, int speed,
 		       phy_interface_t interface);
 	int (*probe)(struct mdio_xpcs_args *xpcs, phy_interface_t interface);
-	int (*config_eee)(struct mdio_xpcs_args *xpcs, int mult_fact_100ns,
-			  int enable);
 };
 
 int xpcs_get_an_mode(struct mdio_xpcs_args *xpcs, phy_interface_t interface);
 struct mdio_xpcs_ops *mdio_xpcs_get_ops(void);
 void xpcs_validate(struct mdio_xpcs_args *xpcs, unsigned long *supported,
 		   struct phylink_link_state *state);
+int xpcs_config_eee(struct mdio_xpcs_args *xpcs, int mult_fact_100ns,
+		    int enable);
 
 #endif /* __LINUX_PCS_XPCS_H */
-- 
2.25.1

