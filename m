Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50FF83A49DF
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 22:06:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231157AbhFKUIx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 16:08:53 -0400
Received: from mail-ej1-f46.google.com ([209.85.218.46]:43609 "EHLO
        mail-ej1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230303AbhFKUIw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 16:08:52 -0400
Received: by mail-ej1-f46.google.com with SMTP id ci15so6224038ejc.10
        for <netdev@vger.kernel.org>; Fri, 11 Jun 2021 13:06:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cCwEJUHeAoTnvtQiOv8/qIkgEHZZI2eLgqihKWStCTA=;
        b=UladNP+iMMAw277jet/G1MBHS6R4dHEwZtSNVjceKmd1O5TDqUgXSiAy8ihf1M5HBk
         0K/QLGV8+B0o3dOaOCs4IRR4ylQVVIY3+Wj2LzfIPLMeHZPpyrcJDiksYXyfGH3hBAI+
         X8rx4haL+lsNOOxYW+kVP73UqWe+CXqFqKuPzPMa4MiyTgMTl1vYTbWVYZ41+RjTW8mc
         8r1MxBJGW3zAxOMu4l48u1NxyjWx0NyQ2uJI2Kx/jy+TtST6UsDh5AqM/PnQh+9JX1hj
         obkOw52ngn57PvHUVmlj2MpVLGDHLukmaBLhL1GC0XSnf09fgrqyvzgABEFUpOcSxEVz
         97iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cCwEJUHeAoTnvtQiOv8/qIkgEHZZI2eLgqihKWStCTA=;
        b=bOjyVDd0M5QPLW0++JiN3sM3M7YwOMCfQpmt17MIM6LS2GHBjvIQlmvUjDchkrdqO7
         D8sHCiX/9pIYUuWgwmp/vENebchucxGfUwCUj1l4s+h6yN+DkWjBQ7nCyOucizInwT9M
         +knEwaa7JzABeDfy2nn33uWYXR6RxFLcL303Qxl3reb709cnyuTwa1seLvj6pxle0O4t
         XTJoIy9Bt1v3auGMfOVAxEUf40WVi683nuw3V8KML6zDRoF2jB+xttQWyX7PKdN52nB2
         Svq4rQJJHG3jc+blEBbWqoKdPVBfZcbVymTbKGogY9UJURBnPORSdslZqhmRli/Er3Cp
         cBDw==
X-Gm-Message-State: AOAM533blTz4z64Mee6B5EUZx8volC+dLna1mt1g/TCVbw228EHsWTQR
        zZVFtuDmoIzteHsA5vS4vVw=
X-Google-Smtp-Source: ABdhPJy9gtLuOD1wJaJl7UX1fgXHvNi8IgK7khyGFgXFBf/7UKrvioUjhswjSXXNFZhaWTKS8giy/g==
X-Received: by 2002:a17:906:4c91:: with SMTP id q17mr5221433eju.512.1623441953473;
        Fri, 11 Jun 2021 13:05:53 -0700 (PDT)
Received: from localhost.localdomain ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id w2sm2392084ejn.118.2021.06.11.13.05.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Jun 2021 13:05:53 -0700 (PDT)
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
        linux-arm-kernel@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v3 net-next 05/13] net: pcs: xpcs: add support for sgmii with no inband AN
Date:   Fri, 11 Jun 2021 23:05:23 +0300
Message-Id: <20210611200531.2384819-6-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210611200531.2384819-1-olteanv@gmail.com>
References: <20210611200531.2384819-1-olteanv@gmail.com>
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
v2->v3: none
v1->v2: none

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

