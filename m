Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BE9335B31B
	for <lists+netdev@lfdr.de>; Sun, 11 Apr 2021 12:24:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235464AbhDKKY1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Apr 2021 06:24:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235440AbhDKKYX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Apr 2021 06:24:23 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4346DC06138B;
        Sun, 11 Apr 2021 03:24:06 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id t5-20020a1c77050000b029010e62cea9deso5228379wmi.0;
        Sun, 11 Apr 2021 03:24:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=sVo1O3aeajTBTSQFeXmQQ/CF/oYGWpcHJo6yyliVcRM=;
        b=aAMvAIHnFlTKHJd/130lwaT6hDXheb4HTwa6ezut5ifMbVSmAXtA3M34R6TWe7RtNF
         FcV+kYliX85utvfGRL2pMpkmk9mrQiq7jjUOc0fzmo9OMtxDz3DOCa2o3uUtkjP/3wKX
         ctKc9Yn9wtdZIyMudnEvxd0+i37awUGbHuWz8aY2cOtHV8IiBws1uDJKq8HiqZXR2wDX
         vySVCJPJP21TCur2taJaBFF744xgCMZ2fn17ThH31VI30PEubQaRCD20W4ykgMnWzSKZ
         4ZdCcbw+YOLJjtCtGMS6qSlp1+CIzlEmnwtvd1iKxWZVPS33s/zbFqe5DcIr+JgPrqy0
         u3zQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sVo1O3aeajTBTSQFeXmQQ/CF/oYGWpcHJo6yyliVcRM=;
        b=Tffk2Nrz+5pJ7LMK05tIWwpjd2aYwwOyifQ/Ws3pbZZmywl1TDOqLizR9Zd3Pvw+EL
         Fs03/pc+RCHCvLmxGLqPlck4/xDA1s00sp8bNZXa14J0CpAgF0cUS1r4nX9J6XQwhHUv
         gFwTHxKTnrh3ZmTcDVtbLyaVhY2Yz0AEM5OLKPmxwhnWXNDwUBDUw31DU8OnT+PWTVkP
         Oo38vufFq+PJie4GbhA86xkGKnmceSzxfAxXmgDJoIWoel1nKTqnozUcJ0VFGhTeaINj
         u82aMhbAcYOhhvroJbFswa9oV3i+1m0QV6kyYFaq258ds1ON+68OWB6d34uK//Jocsjp
         Z9pw==
X-Gm-Message-State: AOAM532xLy2mLcATbdUzKdiiOQcPD6rhajIE/bIhHDG/loSeVdvTwc4H
        hku/gDIm7B50EO/0UWP7T6v6Vycu54g=
X-Google-Smtp-Source: ABdhPJx3jdL7yATT6ro/SYwCXOf8P4GUCtsEQTuO4TuG9Wr8Gj5HJHsuZMMkIusJYMRymDGSMBjZUA==
X-Received: by 2002:a1c:1f92:: with SMTP id f140mr21343968wmf.108.1618136644771;
        Sun, 11 Apr 2021 03:24:04 -0700 (PDT)
Received: from localhost.localdomain (p200300f137277800428d5cfffeb99db8.dip0.t-ipconnect.de. [2003:f1:3727:7800:428d:5cff:feb9:9db8])
        by smtp.googlemail.com with ESMTPSA id o25sm12553309wmh.1.2021.04.11.03.24.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Apr 2021 03:24:04 -0700 (PDT)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     stable@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        hauke@hauke-m.de, f.fainelli@gmail.com, davem@davemloft.net,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH stable-5.4 2/2] net: dsa: lantiq_gswip: Configure all remaining GSWIP_MII_CFG bits
Date:   Sun, 11 Apr 2021 12:23:44 +0200
Message-Id: <20210411102344.2834328-3-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210411102344.2834328-1-martin.blumenstingl@googlemail.com>
References: <20210411102344.2834328-1-martin.blumenstingl@googlemail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

commit 4b5923249b8fa427943b50b8f35265176472be38 upstream.

There are a few more bits in the GSWIP_MII_CFG register for which we
did rely on the boot-loader (or the hardware defaults) to set them up
properly.

For some external RMII PHYs we need to select the GSWIP_MII_CFG_RMII_CLK
bit and also we should un-set it for non-RMII PHYs. The
GSWIP_MII_CFG_RMII_CLK bit is ignored for other PHY connection modes.

The GSWIP IP also supports in-band auto-negotiation for RGMII PHYs when
the GSWIP_MII_CFG_RGMII_IBS bit is set. Clear this bit always as there's
no known hardware which uses this (so it is not tested yet).

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
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[ Updated after the upstream commit 3e9005be87777 required some changes
  for Linux 5.4 ]
Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
 drivers/net/dsa/lantiq_gswip.c | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/drivers/net/dsa/lantiq_gswip.c b/drivers/net/dsa/lantiq_gswip.c
index e0f5d406e6c0..dc75e798dbff 100644
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
@@ -817,9 +821,11 @@ static int gswip_setup(struct dsa_switch *ds)
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
@@ -1594,6 +1600,9 @@ static void gswip_phylink_mac_config(struct dsa_switch *ds, int port,
 		break;
 	case PHY_INTERFACE_MODE_RMII:
 		miicfg |= GSWIP_MII_CFG_MODE_RMIIM;
+
+		/* Configure the RMII clock as output: */
+		miicfg |= GSWIP_MII_CFG_RMII_CLK;
 		break;
 	case PHY_INTERFACE_MODE_RGMII:
 	case PHY_INTERFACE_MODE_RGMII_ID:
@@ -1606,7 +1615,11 @@ static void gswip_phylink_mac_config(struct dsa_switch *ds, int port,
 			"Unsupported interface: %d\n", state->interface);
 		return;
 	}
-	gswip_mii_mask_cfg(priv, GSWIP_MII_CFG_MODE_MASK, miicfg, port);
+
+	gswip_mii_mask_cfg(priv,
+			   GSWIP_MII_CFG_MODE_MASK | GSWIP_MII_CFG_RMII_CLK |
+			   GSWIP_MII_CFG_RGMII_IBS | GSWIP_MII_CFG_LDCLKDIS,
+			   miicfg, port);
 
 	gswip_port_set_speed(priv, port, state->speed, state->interface);
 	gswip_port_set_duplex(priv, port, state->duplex);
-- 
2.31.1

