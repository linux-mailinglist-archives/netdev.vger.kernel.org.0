Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C84C3A1CE7
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 20:42:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229823AbhFISoQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 14:44:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229626AbhFISoP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 14:44:15 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0CEEC06175F
        for <netdev@vger.kernel.org>; Wed,  9 Jun 2021 11:42:19 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id r11so29632702edt.13
        for <netdev@vger.kernel.org>; Wed, 09 Jun 2021 11:42:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=EsvBjtbO446jl1FbDgab+9xkWiJriO/2VRzw7NQw3e0=;
        b=G9ya+xsuiYD6ddjoL62f48/sJyTtk46AxYKhXLnnfqUfs2BmyZkTAry+ykfEgQu/NU
         GJU9GyTrRTqPhLleh2aTRVZOznfbJUhfSHRCcoj5iCFcfcQuAlG3WDJMptzO1bziNzEX
         HWAHRn81Y6OVzz0nXkVYkGTPUKWg53560Q+Zoer6LCzdNzcOvXGZVCGLSK9QBmp7Qc8Z
         +umQikXmdk1hRzHWy5nv0KxZ5QlccFhm67MY6fK4m9rI2Y7AjLgz1ADFjeHudBKcMsMH
         Zvjs2SaIxt6QuOOwqKwvof80f+3TrUOLuRa+ewqGBttjkJ5Lyuf0T8txdeKtEcRLEE5W
         YiRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EsvBjtbO446jl1FbDgab+9xkWiJriO/2VRzw7NQw3e0=;
        b=deuReicJvxNnicuDNuuCfdWD3Mnz8EeE2MMiJaP+0p6fH0YaONafg3OMH2EAcqqVL7
         woC2nbeBKtIPdREtkolO7Bf8HtVCLpP2RuAF7EM9VPiZd9qDf3WojWyte3Opoq8/CG+1
         CQcFagRrQY59HCwKkrb+b9aivpEF8Wl1cv5CJhsi+vHrIRzPacHGUXicUDrUpLUKwzBE
         sm3ic/gi6jx9GUwiay1+jUNj4NK2grKN/d6xub9tSyn/1ro8Gnyc8DYHzY1vo8gT2+FR
         2szYJcNji9MHrai18tQHK5hOIt1bkZt3uZMRC0I9Up0F4k2tCHodhMs076+Kztkkda6f
         NWfQ==
X-Gm-Message-State: AOAM5328NbX5ybrpK8ALl8y7s0t1v2ROLvfyYoknVVJa3u//iwG2pv7Z
        7Wl84wEAF/ICmcTe2AxqE1o=
X-Google-Smtp-Source: ABdhPJy8TKkJpcCNfSQsf4mPYsaQrYB3KXHDio4/9EBRN/DHBNkdZ9foIT4RmHDr2Wn4YnP4i08a1w==
X-Received: by 2002:a05:6402:145a:: with SMTP id d26mr786028edx.151.1623264138486;
        Wed, 09 Jun 2021 11:42:18 -0700 (PDT)
Received: from localhost.localdomain ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id oz11sm194935ejb.16.2021.06.09.11.42.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Jun 2021 11:42:18 -0700 (PDT)
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
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next 05/13] net: pcs: xpcs: add support for sgmii with no inband AN
Date:   Wed,  9 Jun 2021 21:41:47 +0300
Message-Id: <20210609184155.921662-6-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210609184155.921662-1-olteanv@gmail.com>
References: <20210609184155.921662-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

In fixed-link use cases, the XPCS can disable the clause 37 in-band
autoneg process, disable the "Automatic Speed Mode Change after CL37 AN"
setting, and force operation in a speed dictated by management.

Add support for this operating mode.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/pcs/pcs-xpcs.c | 41 +++++++++++++++++++++++++++++++++++---
 1 file changed, 38 insertions(+), 3 deletions(-)

diff --git a/drivers/net/pcs/pcs-xpcs.c b/drivers/net/pcs/pcs-xpcs.c
index 8ca7592b02ec..743b53734eeb 100644
--- a/drivers/net/pcs/pcs-xpcs.c
+++ b/drivers/net/pcs/pcs-xpcs.c
@@ -690,7 +690,7 @@ int xpcs_config_eee(struct dw_xpcs *xpcs, int mult_fact_100ns, int enable)
 }
 EXPORT_SYMBOL_GPL(xpcs_config_eee);
 
-static int xpcs_config_aneg_c37_sgmii(struct dw_xpcs *xpcs)
+static int xpcs_config_aneg_c37_sgmii(struct dw_xpcs *xpcs, unsigned int mode)
 {
 	int ret;
 
@@ -726,7 +726,10 @@ static int xpcs_config_aneg_c37_sgmii(struct dw_xpcs *xpcs)
 	if (ret < 0)
 		return ret;
 
-	ret |= DW_VR_MII_DIG_CTRL1_MAC_AUTO_SW;
+	if (phylink_autoneg_inband(mode))
+		ret |= DW_VR_MII_DIG_CTRL1_MAC_AUTO_SW;
+	else
+		ret &= ~DW_VR_MII_DIG_CTRL1_MAC_AUTO_SW;
 
 	return xpcs_write(xpcs, MDIO_MMD_VEND2, DW_VR_MII_DIG_CTRL1, ret);
 }
@@ -772,7 +775,7 @@ static int xpcs_do_config(struct dw_xpcs *xpcs, phy_interface_t interface,
 		}
 		break;
 	case DW_AN_C37_SGMII:
-		ret = xpcs_config_aneg_c37_sgmii(xpcs);
+		ret = xpcs_config_aneg_c37_sgmii(xpcs, mode);
 		if (ret)
 			return ret;
 		break;
@@ -905,6 +908,36 @@ static void xpcs_get_state(struct phylink_pcs *pcs,
 	}
 }
 
+static void xpcs_link_up_sgmii(struct dw_xpcs *xpcs, unsigned int mode,
+			       int speed, int duplex)
+{
+	int val, ret;
+
+	if (phylink_autoneg_inband(mode))
+		return;
+
+	switch (speed) {
+	case SPEED_1000:
+		val = BMCR_SPEED1000;
+		break;
+	case SPEED_100:
+		val = BMCR_SPEED100;
+		break;
+	case SPEED_10:
+		val = BMCR_SPEED10;
+		break;
+	default:
+		return;
+	}
+
+	if (duplex == DUPLEX_FULL)
+		val |= BMCR_FULLDPLX;
+
+	ret = xpcs_write(xpcs, MDIO_MMD_VEND2, MDIO_CTRL1, val);
+	if (ret)
+		pr_err("%s: xpcs_write returned %pe\n", __func__, ERR_PTR(ret));
+}
+
 static void xpcs_link_up(struct phylink_pcs *pcs, unsigned int mode,
 			 phy_interface_t interface, int speed, int duplex)
 {
@@ -912,6 +945,8 @@ static void xpcs_link_up(struct phylink_pcs *pcs, unsigned int mode,
 
 	if (interface == PHY_INTERFACE_MODE_USXGMII)
 		return xpcs_config_usxgmii(xpcs, speed);
+	if (interface == PHY_INTERFACE_MODE_SGMII)
+		return xpcs_link_up_sgmii(xpcs, mode, speed, duplex);
 }
 
 static u32 xpcs_get_id(struct dw_xpcs *xpcs)
-- 
2.25.1

