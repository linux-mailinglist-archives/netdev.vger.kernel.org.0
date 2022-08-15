Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5161593E6C
	for <lists+netdev@lfdr.de>; Mon, 15 Aug 2022 22:45:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345003AbiHOUn0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Aug 2022 16:43:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346775AbiHOUmC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Aug 2022 16:42:02 -0400
Received: from mail-qt1-x836.google.com (mail-qt1-x836.google.com [IPv6:2607:f8b0:4864:20::836])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EF23AFAE6;
        Mon, 15 Aug 2022 12:07:33 -0700 (PDT)
Received: by mail-qt1-x836.google.com with SMTP id l5so6171945qtv.4;
        Mon, 15 Aug 2022 12:07:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=hL/YxJ/IFnb2Rr2eHTccmTXhM5o8jIQ8tJcvbV9r0+w=;
        b=DK3nNKcN+CtoEBzlgdLdBN2TUQD+X5Y/YRF3pn24jlTxsfiUIhkMwQpx0EWKqw/YE/
         8FR8sUcyQ3sSRcv4ujH3K7Y6kz9h/HUS+3PyrbnU3wUA50pGx9J3EaWsRg4+hxxhhJZA
         K0o/lMlVtBOqTxQrj723c87EoJ67m7TtncuZV3yA8pCL6aGqdqOPRuzs7xaKTkOWkGWa
         6LE2SL8OzPGBr8IhDjgnv+JjOyW22g/UfPfwsez1+AKtGMb1/6yaHpp3JP8pe9OA5lUq
         9NbWGTqPyAyoibnY8yCEQLuqh2m/GAoqVb6u6OV0UxZWHKqHAdOfwZxZm6zLtILXD/KT
         Oqkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=hL/YxJ/IFnb2Rr2eHTccmTXhM5o8jIQ8tJcvbV9r0+w=;
        b=l7HW+qutbnMkTE0p6STwDsjp/R2ixtc01Miee7cVz9mgpPdMFDb2iM02r5j7Q1gWba
         MwPZ/JLfd4iqYu5IRdysTOq0fVjx2uAet0LlJLgbEdCJhHUMIOcDXn7V4H6kkPHL7lW7
         va0JyeoqyaBi68fCy2TJiVExn5WXRA9XZejjoCgIGrHE+DHwRQs98iL+2UYWqzCo+/Gn
         Ft05H3sKetrlIQJQdb29MlWvqIFkmxYX8CA/hJeM4xbquZgyJ2j6fINaiIirvQw48ozH
         h2ZL3zmGQEMK3Gvo2xn0Nbppm9u9R2XVLGIqAP14BlrRfBT3uDpaEWq/Mg4TMBbHQ0qu
         bKEg==
X-Gm-Message-State: ACgBeo0gM+jpBycVN8Kk1tyysftjAt4GG+15Koz3a5IEd3MfvcJswBCb
        MpouUir1Vh1f8wOBUBtCpb4=
X-Google-Smtp-Source: AA6agR6n2NpzccTQTJOldUQ6j77kq3l0o/9m4P1loc2vEY7MUBD26j0MxtrwU5vEGi+YfSiqRxzUpg==
X-Received: by 2002:a05:622a:13c6:b0:342:f6c7:5305 with SMTP id p6-20020a05622a13c600b00342f6c75305mr15504215qtk.348.1660590452277;
        Mon, 15 Aug 2022 12:07:32 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id i17-20020a05620a405100b006b9c6d590fasm10336208qko.61.2022.08.15.12.07.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Aug 2022 12:07:31 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernelorg
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
        netdev@vger.kernel.org (open list:BROADCOM ETHERNET PHY DRIVERS),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net-next v2] net: phy: broadcom: Implement suspend/resume for AC131 and BCM5241
Date:   Mon, 15 Aug 2022 12:07:25 -0700
Message-Id: <20220815190725.2749403-1-f.fainelli@gmail.com>
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
Changes in v2:

- utilize phy_modify() to write to MII_BRCM_FET_SHDW_AUXMODE4 (Russell)

 drivers/net/phy/broadcom.c | 39 ++++++++++++++++++++++++++++++++++++++
 include/linux/brcmphy.h    |  1 +
 2 files changed, 40 insertions(+)

diff --git a/drivers/net/phy/broadcom.c b/drivers/net/phy/broadcom.c
index 31fbcdddc9ad..ad71c88c87e7 100644
--- a/drivers/net/phy/broadcom.c
+++ b/drivers/net/phy/broadcom.c
@@ -766,6 +766,41 @@ static irqreturn_t brcm_fet_handle_interrupt(struct phy_device *phydev)
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
+	err = phy_modify(phydev, MII_BRCM_FET_SHDW_AUXMODE4,
+			 MII_BRCM_FET_SHDW_AM4_STANDBY,
+			 MII_BRCM_FET_SHDW_AM4_STANDBY);
+
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
@@ -1033,6 +1068,8 @@ static struct phy_driver broadcom_drivers[] = {
 	.config_init	= brcm_fet_config_init,
 	.config_intr	= brcm_fet_config_intr,
 	.handle_interrupt = brcm_fet_handle_interrupt,
+	.suspend	= brcm_fet_suspend,
+	.resume		= brcm_fet_config_init,
 }, {
 	.phy_id		= PHY_ID_BCM5241,
 	.phy_id_mask	= 0xfffffff0,
@@ -1041,6 +1078,8 @@ static struct phy_driver broadcom_drivers[] = {
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

