Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35A97393749
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 22:45:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235919AbhE0UrW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 16:47:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235379AbhE0UrR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 May 2021 16:47:17 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C1B1C061760
        for <netdev@vger.kernel.org>; Thu, 27 May 2021 13:45:44 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id e12so2160234ejt.3
        for <netdev@vger.kernel.org>; Thu, 27 May 2021 13:45:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ULokCP8CrAt8X07DxYMPf77UsfeHZ+VGXcJ7iXiuLUA=;
        b=a/O6ejA4x7BrxtMG+N3kMkUZsGb7DguweqVK0MLPhOLapJMfMHLi1EuT6t/i/Fgzzq
         ngQd62Lb08iu7PfB+jjkE8PJg5me+cnohc94uxwBW6YqXsxx3Sgy4GjwAFKNjrr2iG9u
         MujpTGXXgMToq1pqSiJ2J2QkgQoR6ru2HDYTYtK+qHZ5CxTMrmShOHDrUe/cGYwUV5DX
         QFU7KdtFWier3oEfyb8AVRcQ0kTx1T6R2Br2y0ggM10jhEzBecTFhm5EyDT1DViL7Mcc
         8UzhsD7qR3KRKzwI9Y5T26ZuZPzZ3pupweyF64lOdGnD0QoxCdKYAB2bDC5eO4Rxi/Sk
         gC9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ULokCP8CrAt8X07DxYMPf77UsfeHZ+VGXcJ7iXiuLUA=;
        b=THhuoUNdMfAycdEMsif4VoeoMfA+BHvddt2fGjyAt35FHPxuxovQQgov109ufXxNaa
         T1tmpWIdjyBDpBXDXPK8twnd/bOX8wJ/RipQn42n/bLJT3DKpawzkchF1uLd+VqoaU40
         2WeeTPoTVNpbSSvWvbw8MH02ut9xOI7Zfg2VTMKvlLQkV3Cl1YQHPPLXO+4jMfiXta3Y
         U5vUqI2PSDGmpbteHxu5ks6HO6cxdr9WComEycIODbKjrJMgsv10XfpNx94bxOAb6otf
         18TrULzaQf+7G9Yv8k8tebWaEHpd2uv4vz/7YT2GWDzX1p4QNMWi781442T4CwxSpIZA
         Y20g==
X-Gm-Message-State: AOAM530fagxJq0b0tQbMwbXhnLNPmp6dw2ZkPL9gbLmWm2rWDxyDuPE7
        yaj4VG7RfA4QK4i6PIIoZoM=
X-Google-Smtp-Source: ABdhPJw2XoA3cJnuY6Q90Tzm/e8RKDmjHfhXbfAUZxcMbZidWOo0yt6P1Jeb/y8UsHitd7sL4ou7Lw==
X-Received: by 2002:a17:906:308d:: with SMTP id 13mr5677884ejv.554.1622148342700;
        Thu, 27 May 2021 13:45:42 -0700 (PDT)
Received: from localhost.localdomain ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id g11sm1654145edt.85.2021.05.27.13.45.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 May 2021 13:45:42 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [RFC PATCH net-next 4/8] net: pcs: export xpcs_config_eee
Date:   Thu, 27 May 2021 23:45:24 +0300
Message-Id: <20210527204528.3490126-5-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210527204528.3490126-1-olteanv@gmail.com>
References: <20210527204528.3490126-1-olteanv@gmail.com>
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

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/stmicro/stmmac/hwif.h           | 2 --
 drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c | 6 +++---
 drivers/net/pcs/pcs-xpcs.c                           | 6 +++---
 include/linux/pcs/pcs-xpcs.h                         | 4 ++--
 4 files changed, 8 insertions(+), 10 deletions(-)

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
index 1f6d749fd9a3..72d2d575bbfe 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
@@ -720,9 +720,9 @@ static int stmmac_ethtool_op_set_eee(struct net_device *dev,
 		netdev_warn(priv->dev,
 			    "Setting EEE tx-lpi is not supported\n");
 
-	ret = stmmac_xpcs_config_eee(priv, &priv->hw->xpcs_args,
-				     priv->plat->mult_fact_100ns,
-				     edata->eee_enabled);
+	ret = xpcs_config_eee(&priv->hw->xpcs_args,
+			      priv->plat->mult_fact_100ns,
+			      edata->eee_enabled);
 	if (ret)
 		return ret;
 
diff --git a/drivers/net/pcs/pcs-xpcs.c b/drivers/net/pcs/pcs-xpcs.c
index 4c0093473470..a7851a8a219b 100644
--- a/drivers/net/pcs/pcs-xpcs.c
+++ b/drivers/net/pcs/pcs-xpcs.c
@@ -690,8 +690,8 @@ void xpcs_validate(struct mdio_xpcs_args *xpcs, unsigned long *supported,
 }
 EXPORT_SYMBOL_GPL(xpcs_validate);
 
-static int xpcs_config_eee(struct mdio_xpcs_args *xpcs, int mult_fact_100ns,
-			   int enable)
+int xpcs_config_eee(struct mdio_xpcs_args *xpcs, int mult_fact_100ns,
+		    int enable)
 {
 	int ret;
 
@@ -722,6 +722,7 @@ static int xpcs_config_eee(struct mdio_xpcs_args *xpcs, int mult_fact_100ns,
 	ret |= DW_VR_MII_EEE_TRN_LPI;
 	return xpcs_write(xpcs, MDIO_MMD_VEND2, DW_VR_MII_EEE_MCTRL1, ret);
 }
+EXPORT_SYMBOL_GPL(xpcs_config_eee);
 
 static int xpcs_config_aneg_c37_sgmii(struct mdio_xpcs_args *xpcs)
 {
@@ -961,7 +962,6 @@ static struct mdio_xpcs_ops xpcs_ops = {
 	.get_state = xpcs_get_state,
 	.link_up = xpcs_link_up,
 	.probe = xpcs_probe,
-	.config_eee = xpcs_config_eee,
 };
 
 struct mdio_xpcs_ops *mdio_xpcs_get_ops(void)
diff --git a/include/linux/pcs/pcs-xpcs.h b/include/linux/pcs/pcs-xpcs.h
index 56755b7895a0..203aafae9166 100644
--- a/include/linux/pcs/pcs-xpcs.h
+++ b/include/linux/pcs/pcs-xpcs.h
@@ -32,12 +32,12 @@ struct mdio_xpcs_ops {
 	int (*link_up)(struct mdio_xpcs_args *xpcs, int speed,
 		       phy_interface_t interface);
 	int (*probe)(struct mdio_xpcs_args *xpcs);
-	int (*config_eee)(struct mdio_xpcs_args *xpcs, int mult_fact_100ns,
-			  int enable);
 };
 
 struct mdio_xpcs_ops *mdio_xpcs_get_ops(void);
 void xpcs_validate(struct mdio_xpcs_args *xpcs, unsigned long *supported,
 		   struct phylink_link_state *state);
+int xpcs_config_eee(struct mdio_xpcs_args *xpcs, int mult_fact_100ns,
+		    int enable);
 
 #endif /* __LINUX_PCS_XPCS_H */
-- 
2.25.1

