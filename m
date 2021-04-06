Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39C15355CFC
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 22:35:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347168AbhDFUfm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 16:35:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231488AbhDFUff (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Apr 2021 16:35:35 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB6C2C06174A;
        Tue,  6 Apr 2021 13:35:26 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id i18so12112335wrm.5;
        Tue, 06 Apr 2021 13:35:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=IfVWHQROAUp8Y3SbnzHentJjYUhOt/k/kD9IkCRlVTE=;
        b=YQgBitNHBUbKbM/2k2JKStIyt3GEQYdhkyy0Gfz3N17ncZrhaHETxK+yDGhG3mjX6y
         qWPS3cltCHRLKJlEdXllvDVN/XRfe92L0xXi/Qlw5HFfdB/ygEYBsvy1+XyE/WZju6Tu
         6vfjYpnQJB5lzIuwiF7b23hIvZvyVLuTLsADL1cLs19h09sut9T7cX4ITVdPWuaYKys/
         oOLy4qj+Dx6XttmN+5pUL2dXZMFeC6XcE6aH6qeuxZRxN8/VvnwGbmja9E/mTmqBsI0g
         K+Tf4H/LLH7seHm0MuTlgYLv9CtDrtrnNnCnjM/SI/KFNCGl3Oj+KRXUKim/2ArlBXS2
         jsgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IfVWHQROAUp8Y3SbnzHentJjYUhOt/k/kD9IkCRlVTE=;
        b=myT+ISDZQVVWynSNq+QpCBm/c7HHB7rXF2Uwruz7LucCYpJ7FKzPy5XnYI+UbI9z69
         8/Vei8GuqNxtinwijuRxCsknk/DYA0UD2P8z+Vs2aY3a4kbor4k9WGmKpcqsu06ZL5mc
         QbNdYPoAHbitanv//oZZQbeO7xxqWX/D4fp0YCAYNAerrAsm7DoRXvCrDfmtscWa1cjO
         KG2W2gJlBAyY7o/izLLZ1Ag/QT5SJej+Wk/sTYo/5x6838qrJ/VHbb01Effsg2m55MaS
         SlN0r8/dRbnybDWzJ4Yd120M9zHGibeF0Wyf+bNLnJJ76eaRdGq41TyzcijXz9HALOgw
         XhHA==
X-Gm-Message-State: AOAM533Z/Wxt3TqCir4Epn+cVSWtgBgbNrd0MMYhVLuwM8G2BXnMKH9J
        OGUSa9FV2od07ykSd/NZIxg=
X-Google-Smtp-Source: ABdhPJx72Gg+T2lFgZxO+e7rdZxDHj82BUhUNdC6lOvKQG/IpFOtOPvFB8qBwrcItFIMewqTeOXHOg==
X-Received: by 2002:a5d:6d05:: with SMTP id e5mr77918wrq.324.1617741325681;
        Tue, 06 Apr 2021 13:35:25 -0700 (PDT)
Received: from localhost.localdomain (p200300f1370b4300428d5cfffeb99db8.dip0.t-ipconnect.de. [2003:f1:370b:4300:428d:5cff:feb9:9db8])
        by smtp.googlemail.com with ESMTPSA id q14sm14040564wrg.64.2021.04.06.13.35.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Apr 2021 13:35:25 -0700 (PDT)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     hauke@hauke-m.de, andrew@lunn.ch, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, olteanv@gmail.com, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux@armlinux.org.uk,
        linux-kernel@vger.kernel.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        stable@vger.kernel.org
Subject: [PATCH RFC net 2/2] net: dsa: lantiq_gswip: Configure all remaining GSWIP_MII_CFG bits
Date:   Tue,  6 Apr 2021 22:35:08 +0200
Message-Id: <20210406203508.476122-3-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210406203508.476122-1-martin.blumenstingl@googlemail.com>
References: <20210406203508.476122-1-martin.blumenstingl@googlemail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are a few more bits in the GSWIP_MII_CFG register for which we
did rely on the boot-loader (or the hardware defaults) to set them up
properly.

For some external RMII PHYs we need to select the GSWIP_MII_CFG_RMII_CLK
bit and also we should un-set it for non-RMII PHYs. The GSWIP IP also
supports in-band auto-negotiation for RGMII PHYs. Set or unset the
corresponding bit depending on the auto-negotiation mode.

Clear the xMII isolation bit when set at initialization time if it was
previously set by the bootloader. Not doing so could lead to no traffic
(neither RX nor TX) on a port with this bit set.

While here, also add the GSWIP_MII_CFG_RESET bit. We don't need to
manage it because this bit is self-clearning when set. We still add it
here to get a better overview of the GSWIP_MII_CFG register.

Fixes: 14fceff4771e51 ("net: dsa: Add Lantiq / Intel DSA driver for vrx200")
Cc: stable@vger.kernel.org
Suggested-by: Hauke Mehrtens <hauke@hauke-m.de>
Acked-by: Hauke Mehrtens <hauke@hauke-m.de>
Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
 drivers/net/dsa/lantiq_gswip.c | 22 +++++++++++++++++++---
 1 file changed, 19 insertions(+), 3 deletions(-)

diff --git a/drivers/net/dsa/lantiq_gswip.c b/drivers/net/dsa/lantiq_gswip.c
index 47ea3a8c90a4..f330035ed85b 100644
--- a/drivers/net/dsa/lantiq_gswip.c
+++ b/drivers/net/dsa/lantiq_gswip.c
@@ -93,8 +93,12 @@
 
 /* GSWIP MII Registers */
 #define GSWIP_MII_CFGp(p)		(0x2 * (p))
+#define  GSWIP_MII_CFG_RESET		BIT(15)
 #define  GSWIP_MII_CFG_EN		BIT(14)
+#define  GSWIP_MII_CFG_ISOLATE		BIT(13)
 #define  GSWIP_MII_CFG_LDCLKDIS		BIT(12)
+#define  GSWIP_MII_CFG_RGMII_IBS	BIT(8)
+#define  GSWIP_MII_CFG_RMII_CLK		BIT(7)
 #define  GSWIP_MII_CFG_MODE_MIIP	0x0
 #define  GSWIP_MII_CFG_MODE_MIIM	0x1
 #define  GSWIP_MII_CFG_MODE_RMIIP	0x2
@@ -821,9 +825,11 @@ static int gswip_setup(struct dsa_switch *ds)
 	/* Configure the MDIO Clock 2.5 MHz */
 	gswip_mdio_mask(priv, 0xff, 0x09, GSWIP_MDIO_MDC_CFG1);
 
-	/* Disable the xMII link */
+	/* Disable the xMII interface and clear it's isolation bit */
 	for (i = 0; i < priv->hw_info->max_ports; i++)
-		gswip_mii_mask_cfg(priv, GSWIP_MII_CFG_EN, 0, i);
+		gswip_mii_mask_cfg(priv,
+				   GSWIP_MII_CFG_EN | GSWIP_MII_CFG_ISOLATE,
+				   0, i);
 
 	/* enable special tag insertion on cpu port */
 	gswip_switch_mask(priv, 0, GSWIP_FDMA_PCTRL_STEN,
@@ -1597,19 +1603,29 @@ static void gswip_phylink_mac_config(struct dsa_switch *ds, int port,
 		break;
 	case PHY_INTERFACE_MODE_RMII:
 		miicfg |= GSWIP_MII_CFG_MODE_RMIIM;
+
+		/* Configure the RMII clock as output: */
+		miicfg |= GSWIP_MII_CFG_RMII_CLK;
 		break;
 	case PHY_INTERFACE_MODE_RGMII:
 	case PHY_INTERFACE_MODE_RGMII_ID:
 	case PHY_INTERFACE_MODE_RGMII_RXID:
 	case PHY_INTERFACE_MODE_RGMII_TXID:
 		miicfg |= GSWIP_MII_CFG_MODE_RGMII;
+
+		if (phylink_autoneg_inband(mode))
+			miicfg |= GSWIP_MII_CFG_RGMII_IBS;
 		break;
 	default:
 		dev_err(ds->dev,
 			"Unsupported interface: %d\n", state->interface);
 		return;
 	}
-	gswip_mii_mask_cfg(priv, GSWIP_MII_CFG_MODE_MASK, miicfg, port);
+
+	gswip_mii_mask_cfg(priv,
+			   GSWIP_MII_CFG_MODE_MASK | GSWIP_MII_CFG_RMII_CLK |
+			   GSWIP_MII_CFG_RGMII_IBS | GSWIP_MII_CFG_LDCLKDIS,
+			   miicfg, port);
 
 	gswip_port_set_link(priv, port, state->link);
 	gswip_port_set_speed(priv, port, state->speed, state->interface);
-- 
2.31.1

