Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DF86593424
	for <lists+netdev@lfdr.de>; Mon, 15 Aug 2022 19:44:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231681AbiHORoF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Aug 2022 13:44:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbiHORoE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Aug 2022 13:44:04 -0400
Received: from mail-qk1-x733.google.com (mail-qk1-x733.google.com [IPv6:2607:f8b0:4864:20::733])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C733527FE8;
        Mon, 15 Aug 2022 10:44:03 -0700 (PDT)
Received: by mail-qk1-x733.google.com with SMTP id a15so5625863qko.4;
        Mon, 15 Aug 2022 10:44:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=ot6aA0JLE7mQSLlUAhIRMLAI2J9tpo0G0V3a4tkd6yQ=;
        b=QEHsxSEks8nskCPi3QT8dXwVeYw+NXJtGneY2gB1dFE78L/sYrCbhkVKvAOP+02USY
         n5rpbFdIk40U0FqQknIK76WfiLkdoBAfHs782859v0kcP+Xjkzw7ValsKzXY2i4bY12Q
         u2PcnDTZO8hoW/HN0c7cCDfhdlxVeOKuNeXFo4MRBSrnXjhQEFXZ7tAOojQNEUkyZBft
         KTB0Z52qgtnKmnu7U+lKxia0mt3hwZw1ART96pQRhIGfj1T23LC82cE1e2LXArlqPIDw
         vKzc1JhkmQOJYTpHxDWwVUOYwEucO6RA93R/Ru6a9zaYCPUSDvgBbb/YLZ6RZBwMzRKE
         6YUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=ot6aA0JLE7mQSLlUAhIRMLAI2J9tpo0G0V3a4tkd6yQ=;
        b=SzirA1oix7DDCmvveiwNtH5sMgv+7JrzFzrflnunLLnr6nwKGBIW0iCY4IXkkuUmtQ
         EiqhR51F7BwyZETQI2JLPCy3HyvMQsrOGceioytvvn0MEUsQOjkRrfMsOJWXR6mtjSLr
         2VawjYi5/j6n4rmlxsnf/P6u6WBUs+VL/l0bQS8fA97WhZ+8vdC78aRC0k3P5tnwnrVP
         LUpDsWLcU/0VwWbOom8tvdYdmqje/GkJgOHRyrF8Ebmm2onVjxcaU8/yJoczY7LhcO47
         wEgG6ThhV3Mlej7hknF3JiiweoORBmeIqvurvR2+t/tp2J7CoDWhPObz3zVuBm44gnHw
         nTuA==
X-Gm-Message-State: ACgBeo1Pt6vb1oowSbiFMemVJDBEtKrbWWavHkpnBN5s6Oq8zvJHxwuS
        HNPrTMJ6EqkxkBvuy9OGVMl0EkEIwp0=
X-Google-Smtp-Source: AA6agR7pPLILrI55qLDydNnToKZ7T6NxfGh/2ZhZps1vHGaQ92U0dAZ8sNbckFPlygGM7ehpgYxd8A==
X-Received: by 2002:a05:620a:1513:b0:6ba:e66b:726d with SMTP id i19-20020a05620a151300b006bae66b726dmr9393061qkk.692.1660585442217;
        Mon, 15 Aug 2022 10:44:02 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id y6-20020ae9f406000000b006b8cff25187sm9497465qkl.42.2022.08.15.10.44.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Aug 2022 10:44:01 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Broadcom internal kernel review list 
        <bcm-kernel-feedback-list@broadcom.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net-next] net: phy: broadcom: Implement suspend/resume for AC131 and BCM5241
Date:   Mon, 15 Aug 2022 10:43:56 -0700
Message-Id: <20220815174356.2681127-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement the suspend/resume procedure for the Broadcom AC131 and BCM5241 type
of PHYs (10/100 only) by entering the standard power down followed by the
proprietary standby mode in the auxiliary mode 4 shadow register. On resume,
the PHY software reset is enough to make it come out of standby mode so we can
utilize brcm_fet_config_init() as the resume hook.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/phy/broadcom.c | 48 ++++++++++++++++++++++++++++++++++++++
 include/linux/brcmphy.h    |  1 +
 2 files changed, 49 insertions(+)

diff --git a/drivers/net/phy/broadcom.c b/drivers/net/phy/broadcom.c
index 31fbcdddc9ad..739348b3f135 100644
--- a/drivers/net/phy/broadcom.c
+++ b/drivers/net/phy/broadcom.c
@@ -766,6 +766,50 @@ static irqreturn_t brcm_fet_handle_interrupt(struct phy_device *phydev)
 	return IRQ_HANDLED;
 }
 
+static int brcm_fet_suspend(struct phy_device *phydev)
+{
+	int reg, err, err2, brcmtest;
+
+	/* We cannot use a read/modify/write here otherwise the PHY continues
+	 * to drive LEDs which defeats the purpose of low power mode.
+	 */
+	err = phy_write(phydev, MII_BMCR, BMCR_PDOWN);
+	if (err < 0)
+		return err;
+
+	/* Enable shadow register access */
+	brcmtest = phy_read(phydev, MII_BRCM_FET_BRCMTEST);
+	if (brcmtest < 0)
+		return brcmtest;
+
+	reg = brcmtest | MII_BRCM_FET_BT_SRE;
+
+	err = phy_write(phydev, MII_BRCM_FET_BRCMTEST, reg);
+	if (err < 0)
+		return err;
+
+	/* Set standby mode */
+	reg = phy_read(phydev, MII_BRCM_FET_SHDW_AUXMODE4);
+	if (reg < 0) {
+		err = reg;
+		goto done;
+	}
+
+	reg |= MII_BRCM_FET_SHDW_AM4_STANDBY;
+
+	err = phy_write(phydev, MII_BRCM_FET_SHDW_AUXMODE4, reg);
+	if (err < 0)
+		goto done;
+
+done:
+	/* Disable shadow register access */
+	err2 = phy_write(phydev, MII_BRCM_FET_BRCMTEST, brcmtest);
+	if (!err)
+		err = err2;
+
+	return err;
+}
+
 static int bcm54xx_phy_probe(struct phy_device *phydev)
 {
 	struct bcm54xx_phy_priv *priv;
@@ -1033,6 +1077,8 @@ static struct phy_driver broadcom_drivers[] = {
 	.config_init	= brcm_fet_config_init,
 	.config_intr	= brcm_fet_config_intr,
 	.handle_interrupt = brcm_fet_handle_interrupt,
+	.suspend	= brcm_fet_suspend,
+	.resume		= brcm_fet_config_init,
 }, {
 	.phy_id		= PHY_ID_BCM5241,
 	.phy_id_mask	= 0xfffffff0,
@@ -1041,6 +1087,8 @@ static struct phy_driver broadcom_drivers[] = {
 	.config_init	= brcm_fet_config_init,
 	.config_intr	= brcm_fet_config_intr,
 	.handle_interrupt = brcm_fet_handle_interrupt,
+	.suspend	= brcm_fet_suspend,
+	.resume		= brcm_fet_config_init,
 }, {
 	.phy_id		= PHY_ID_BCM5395,
 	.phy_id_mask	= 0xfffffff0,
diff --git a/include/linux/brcmphy.h b/include/linux/brcmphy.h
index 6ff567ece34a..9e77165f3ef6 100644
--- a/include/linux/brcmphy.h
+++ b/include/linux/brcmphy.h
@@ -293,6 +293,7 @@
 #define MII_BRCM_FET_SHDW_MC_FAME	0x4000	/* Force Auto MDIX enable */
 
 #define MII_BRCM_FET_SHDW_AUXMODE4	0x1a	/* Auxiliary mode 4 */
+#define MII_BRCM_FET_SHDW_AM4_STANDBY	0x0008	/* Standby enable */
 #define MII_BRCM_FET_SHDW_AM4_LED_MASK	0x0003
 #define MII_BRCM_FET_SHDW_AM4_LED_MODE1 0x0001
 
-- 
2.25.1

