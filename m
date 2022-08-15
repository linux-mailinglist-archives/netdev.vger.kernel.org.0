Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1940593E69
	for <lists+netdev@lfdr.de>; Mon, 15 Aug 2022 22:45:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344819AbiHOUnZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Aug 2022 16:43:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347315AbiHOUmn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Aug 2022 16:42:43 -0400
Received: from mail-qk1-x72a.google.com (mail-qk1-x72a.google.com [IPv6:2607:f8b0:4864:20::72a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EBEAB2841;
        Mon, 15 Aug 2022 12:07:53 -0700 (PDT)
Received: by mail-qk1-x72a.google.com with SMTP id t11so6220934qkt.6;
        Mon, 15 Aug 2022 12:07:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=hL/YxJ/IFnb2Rr2eHTccmTXhM5o8jIQ8tJcvbV9r0+w=;
        b=E5hSn4x/FyOrhwErFKwCPEo40cc9WtEGsbeeVaV9nMZJ1+j4BRemuUo9CBUdGhIPhz
         53tLn/eI5vhAlajZV6LQbEOKfwhMDTadvCV4hSjF4z2kxFWRXhuqeOoVRNie4vpSPyG6
         XYwcVUFDtwR1jH9Wdt+/eCMAut1YIqaWbo27CbsOXfTPG+/NoXX5nAVuY7gypUvWslVp
         tooKDWR16OxzPkwhEHOPL7r51bz8YiynKxC+Ya7chnGb+jHmWrHA5sleEGDaY0JVUAp/
         c4pr/TiRqcgqMdNJOxisU2+R7Alg1zdjSYxQJrzXzPT4MVl3CYz/7Dn7UiBD7taQg4Lj
         jKHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=hL/YxJ/IFnb2Rr2eHTccmTXhM5o8jIQ8tJcvbV9r0+w=;
        b=PoewzGwLZMZRNgUUAnWhni7TvuKPVmkDdwdvMu3BS+CEyflPpTz/RXruqHabhCrFeE
         MQm8VBqdTqCU2nklsXob1DeI23XTfBAtZIhffReH/Z0Osj+BVHRMOmsJRlkDo7Lfnk11
         BfpVYchjE1rXgxbT4MeTi/lYcKqrm4p4uzSiGHEfpgoYrSHblWYMbTS2CmsZx54b0MBT
         7dW+QHQvK/dr7qOAc1q6IYt87F3cdgsLHXpApJNVDffmNkRl0m2pF33hpb++6W83NXFa
         jvti2VkiGeUUZqGJYokWSIOItfl4UIgLTL0gk3OaUWYZVjNBDmKnGrGev2m3hzgDkVRT
         /1fw==
X-Gm-Message-State: ACgBeo1BgNvAtZn48EhH9JWHqE2x5VvyZRJMfoTIoCzsteoKi6qxNqSx
        xEIqROhNTXa5de8TEyttY0UlwbwZDK8=
X-Google-Smtp-Source: AA6agR5VoTu90ugZfLvHTUVoLW6a4nmf0qFxn/LPwfQGNz4x7026GRFC01AKDh44STznzxOxOhyJIQ==
X-Received: by 2002:a05:620a:c55:b0:6a7:9e01:95c9 with SMTP id u21-20020a05620a0c5500b006a79e0195c9mr12404238qki.63.1660590471623;
        Mon, 15 Aug 2022 12:07:51 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id n5-20020a05620a294500b006b93fcc9604sm10226889qkp.108.2022.08.15.12.07.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Aug 2022 12:07:50 -0700 (PDT)
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
Subject: [PATCH net-next v2] net: phy: broadcom: Implement suspend/resume for AC131 and BCM5241
Date:   Mon, 15 Aug 2022 12:07:47 -0700
Message-Id: <20220815190747.2749477-1-f.fainelli@gmail.com>
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

