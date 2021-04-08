Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F6D0358CCE
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 20:39:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232929AbhDHSjP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 14:39:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232862AbhDHSjF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Apr 2021 14:39:05 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0ABEEC061760;
        Thu,  8 Apr 2021 11:38:54 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id m3so3625556edv.5;
        Thu, 08 Apr 2021 11:38:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=czCdUgUKYE195RMgtc10Qp0uf7frLXf3Xd3lvhOg2uw=;
        b=KwEKBSAKM6HHd76b94vG7Pg/JzJpmOum0Kfl+EnEoRKAf9TqBTQTfinSbSUtOuzLqD
         ZTsTJObuQnucCSiSawb5dE31KIQdWlTmkVSUmI6ZKopfRtghd5r8csk35X3Z23iS0eFR
         7JPIP8doUDS2ox+ilfYQng9hK/bS0w1Ss9s7uNIowNzQgTW5M9vGIiJm0mSHekJzTIpb
         QamCt7RXv8yNwhcHj8ZnfdJDv9dW8v3pGvu+Q0/wS33+weoFWcMDA3HERJ6GEGO+L2DT
         CmJxKzveb5qoJvbKNpVA3mZZD0v7ygPR7zt6W7c9RldsU0Zbfwlmw55hDB7QGyYz7SuV
         kqpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=czCdUgUKYE195RMgtc10Qp0uf7frLXf3Xd3lvhOg2uw=;
        b=WJDBBesVFWyluvj3CNwj3jNh2MZIeDTf5B6OOXWe5IvY6pT7V6s2OSnEJNzvheg9x0
         9o7SpY7D4j5E2qFoEqtwvCaYTzo+AtAm0aYudHfg4NGFfsG2U+0bXJXoXved8Y8coA8b
         5HN9K6zgvjok4IXWWy1Z4GepZ6Yg9JCVoZE10zBppPqxfjuH9RrHMqG6fsCN+pZTyB3u
         ojG463zwtVofDGBopXQ3lyBmz9TYyEVqtRHxBqXxFZQLgKgVuRqN2a9Qiq/OUVSCOUB7
         XMB8BVPQNFMuN8/Oq/+AWogaFyJTzbSZN63Uf0fUMoE+IysgEcWkRYHU9vP05cwaAFO4
         PnqA==
X-Gm-Message-State: AOAM531QK+bShpDUNhBSRBCEyRgQoru4DnETyGhNyVKppTSwVQQSHCdM
        0irfrvyQRTODA25OZYyU+ca2KzfBzEU=
X-Google-Smtp-Source: ABdhPJxuOj4EnYJs8L3ScOS8DLZbtsR14mAVrT8Uz3NN1XObVjpiUYlbtv0ec6xsFUF81VWl97ugKQ==
X-Received: by 2002:a05:6402:1bdc:: with SMTP id ch28mr13203322edb.202.1617907132765;
        Thu, 08 Apr 2021 11:38:52 -0700 (PDT)
Received: from localhost.localdomain (p200300f1370e7400428d5cfffeb99db8.dip0.t-ipconnect.de. [2003:f1:370e:7400:428d:5cff:feb9:9db8])
        by smtp.googlemail.com with ESMTPSA id yh6sm92125ejb.37.2021.04.08.11.38.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Apr 2021 11:38:52 -0700 (PDT)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     hauke@hauke-m.de, andrew@lunn.ch, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, olteanv@gmail.com, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux@armlinux.org.uk,
        linux-kernel@vger.kernel.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        stable@vger.kernel.org
Subject: [PATCH net v2 2/2] net: dsa: lantiq_gswip: Configure all remaining GSWIP_MII_CFG bits
Date:   Thu,  8 Apr 2021 20:38:28 +0200
Message-Id: <20210408183828.1907807-3-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210408183828.1907807-1-martin.blumenstingl@googlemail.com>
References: <20210408183828.1907807-1-martin.blumenstingl@googlemail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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
---
 drivers/net/dsa/lantiq_gswip.c | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/drivers/net/dsa/lantiq_gswip.c b/drivers/net/dsa/lantiq_gswip.c
index 126d4ea868ba..bf5c62e5c0b0 100644
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
@@ -1597,6 +1603,9 @@ static void gswip_phylink_mac_config(struct dsa_switch *ds, int port,
 		break;
 	case PHY_INTERFACE_MODE_RMII:
 		miicfg |= GSWIP_MII_CFG_MODE_RMIIM;
+
+		/* Configure the RMII clock as output: */
+		miicfg |= GSWIP_MII_CFG_RMII_CLK;
 		break;
 	case PHY_INTERFACE_MODE_RGMII:
 	case PHY_INTERFACE_MODE_RGMII_ID:
@@ -1609,7 +1618,11 @@ static void gswip_phylink_mac_config(struct dsa_switch *ds, int port,
 			"Unsupported interface: %d\n", state->interface);
 		return;
 	}
-	gswip_mii_mask_cfg(priv, GSWIP_MII_CFG_MODE_MASK, miicfg, port);
+
+	gswip_mii_mask_cfg(priv,
+			   GSWIP_MII_CFG_MODE_MASK | GSWIP_MII_CFG_RMII_CLK |
+			   GSWIP_MII_CFG_RGMII_IBS | GSWIP_MII_CFG_LDCLKDIS,
+			   miicfg, port);
 
 	switch (state->interface) {
 	case PHY_INTERFACE_MODE_RGMII_ID:
-- 
2.31.1

