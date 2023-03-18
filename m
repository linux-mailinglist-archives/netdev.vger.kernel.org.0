Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC7876BFCC9
	for <lists+netdev@lfdr.de>; Sat, 18 Mar 2023 21:37:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229713AbjCRUgW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Mar 2023 16:36:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229602AbjCRUgV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Mar 2023 16:36:21 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF9AA2DE7D
        for <netdev@vger.kernel.org>; Sat, 18 Mar 2023 13:36:19 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id eh3so32850198edb.11
        for <netdev@vger.kernel.org>; Sat, 18 Mar 2023 13:36:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679171778;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=aQmVT/xNc3pdCE3gs02NHjq7u+nOxIXdjSvaq4xrKxs=;
        b=UTo7LbAbMR/ypWg1AZ4tZDqJV903m7B8Fr4EMqrb0QAG0/4EaA/XK0kZJAK7YRC7g4
         mtDih4zIsqICZfvRR8dfr6bOXXARNF1hUnvllxnk5+jQHoZLL5Ikq/2U4UXp78chCTpj
         dwgoajxv1Bf1RVc+VqxS57zAZOpstj26GXNF6hNlS1g6eZjoDHw8wrqNWJKC92b1J04x
         +CJT0SreiNnCEB1aVDu7picqftVfeepenW44V6thhqjns0SdaZ5lVlLcYHUryz02dXSM
         l8ur5uOsF6KUcGgz4vP0xp4QVwLZksp0ZQh2HrBTGR6LaF8pft4g0SQXuHTVDE7TOFrh
         02Pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679171778;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aQmVT/xNc3pdCE3gs02NHjq7u+nOxIXdjSvaq4xrKxs=;
        b=HOmyI/tBbrqG3HxF4CiBpqR/JC3942+mcRVVH2brFDHN1evaT5LgNFoNDf2amaKukd
         9wJo5tS6Vn9xweNDwVqP4UBh60c982XqoNJNgfF94k3WXZdp6V9wOOVN9rWvS+62VbqD
         tgo5xyMLm2LPbgrxEO6rZ1082BNiXQzdym742oXomNTGfdFuRV69gWEI+9Tc5DQMn23r
         gC5/bKtGEedeLzXymbKlQFnAHWggDXSmsFqEK8hIlc0CZ5qosy2aoseq0LyHfSW4WnvL
         36fN9fwD0jYmZYypgtFxP80zt0+gS2y5HPBI5txR8EnxaJrgq5o99/CJidyuKVQ4CevN
         9Yrw==
X-Gm-Message-State: AO0yUKXoF0CuS0AeOhsBu9A3Hb/YfEhyqmkIuHJQyktilr3l2Q0QOzFR
        vBzuTn31MuzWGSc+hhaR2SI=
X-Google-Smtp-Source: AK7set/hxOo9R4+RbLzF6JiwQmTMIXQ98hXl0eYozZ9N1c6FauyerhrTONCY6l6lWsJO8B5amv0ouA==
X-Received: by 2002:a17:907:2158:b0:878:7cf3:a9e7 with SMTP id rk24-20020a170907215800b008787cf3a9e7mr3579264ejb.65.1679171778215;
        Sat, 18 Mar 2023 13:36:18 -0700 (PDT)
Received: from ?IPV6:2a01:c23:c073:a00:b51a:ddab:12c0:b88a? (dynamic-2a01-0c23-c073-0a00-b51a-ddab-12c0-b88a.c23.pool.telefonica.de. [2a01:c23:c073:a00:b51a:ddab:12c0:b88a])
        by smtp.googlemail.com with ESMTPSA id k22-20020a170906129600b00931508e55dasm2499501ejb.202.2023.03.18.13.36.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 18 Mar 2023 13:36:17 -0700 (PDT)
Message-ID: <192db694-5bda-513c-31c5-96ec3b2425d9@gmail.com>
Date:   Sat, 18 Mar 2023 21:32:41 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: [PATCH net-next 1/2] net: phy: smsc: export functions for use by
 meson-gxl PHY driver
Content-Language: en-US
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Russell King - ARM Linux <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Kevin Hilman <khilman@baylibre.com>,
        Jerome Brunet <jbrunet@baylibre.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "open list:ARM/Amlogic Meson..." <linux-amlogic@lists.infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        Chris Healy <cphealy@gmail.com>
References: <683422c6-c1e1-90b9-59ed-75d0f264f354@gmail.com>
In-Reply-To: <683422c6-c1e1-90b9-59ed-75d0f264f354@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Amlogic Meson internal PHY's have the same register layout as
certain SMSC PHY's (also for non-c22-standard registers). This seems
to be more than just coincidence. Apparently they also need the same
workaround for EDPD mode (energy detect power down). Therefore let's
export SMSC PHY driver functionality for use by the meson-gxl PHY
driver.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/phy/smsc.c  | 20 +++++++++++++-------
 include/linux/smscphy.h |  6 ++++++
 2 files changed, 19 insertions(+), 7 deletions(-)

diff --git a/drivers/net/phy/smsc.c b/drivers/net/phy/smsc.c
index 721871184..730964b85 100644
--- a/drivers/net/phy/smsc.c
+++ b/drivers/net/phy/smsc.c
@@ -54,7 +54,7 @@ static int smsc_phy_ack_interrupt(struct phy_device *phydev)
 	return rc < 0 ? rc : 0;
 }
 
-static int smsc_phy_config_intr(struct phy_device *phydev)
+int smsc_phy_config_intr(struct phy_device *phydev)
 {
 	int rc;
 
@@ -75,8 +75,9 @@ static int smsc_phy_config_intr(struct phy_device *phydev)
 
 	return rc < 0 ? rc : 0;
 }
+EXPORT_SYMBOL_GPL(smsc_phy_config_intr);
 
-static irqreturn_t smsc_phy_handle_interrupt(struct phy_device *phydev)
+irqreturn_t smsc_phy_handle_interrupt(struct phy_device *phydev)
 {
 	int irq_status;
 
@@ -95,18 +96,20 @@ static irqreturn_t smsc_phy_handle_interrupt(struct phy_device *phydev)
 
 	return IRQ_HANDLED;
 }
+EXPORT_SYMBOL_GPL(smsc_phy_handle_interrupt);
 
-static int smsc_phy_config_init(struct phy_device *phydev)
+int smsc_phy_config_init(struct phy_device *phydev)
 {
 	struct smsc_phy_priv *priv = phydev->priv;
 
-	if (!priv->energy_enable || phydev->irq != PHY_POLL)
+	if (!priv || !priv->energy_enable || phydev->irq != PHY_POLL)
 		return 0;
 
 	/* Enable energy detect power down mode */
 	return phy_set_bits(phydev, MII_LAN83C185_CTRL_STATUS,
 			    MII_LAN83C185_EDPWRDOWN);
 }
+EXPORT_SYMBOL_GPL(smsc_phy_config_init);
 
 static int smsc_phy_reset(struct phy_device *phydev)
 {
@@ -186,7 +189,7 @@ static int lan95xx_config_aneg_ext(struct phy_device *phydev)
  * The workaround is only applicable to poll mode. Energy Detect Power-Down may
  * not be used in interrupt mode lest link change detection becomes unreliable.
  */
-static int lan87xx_read_status(struct phy_device *phydev)
+int lan87xx_read_status(struct phy_device *phydev)
 {
 	struct smsc_phy_priv *priv = phydev->priv;
 	int err;
@@ -195,7 +198,8 @@ static int lan87xx_read_status(struct phy_device *phydev)
 	if (err)
 		return err;
 
-	if (!phydev->link && priv->energy_enable && phydev->irq == PHY_POLL) {
+	if (!phydev->link && priv && priv->energy_enable &&
+	    phydev->irq == PHY_POLL) {
 		/* Disable EDPD to wake up PHY */
 		int rc = phy_read(phydev, MII_LAN83C185_CTRL_STATUS);
 		if (rc < 0)
@@ -229,6 +233,7 @@ static int lan87xx_read_status(struct phy_device *phydev)
 
 	return err;
 }
+EXPORT_SYMBOL_GPL(lan87xx_read_status);
 
 static int smsc_get_sset_count(struct phy_device *phydev)
 {
@@ -269,7 +274,7 @@ static void smsc_get_stats(struct phy_device *phydev,
 		data[i] = smsc_get_stat(phydev, i);
 }
 
-static int smsc_phy_probe(struct phy_device *phydev)
+int smsc_phy_probe(struct phy_device *phydev)
 {
 	struct device *dev = &phydev->mdio.dev;
 	struct smsc_phy_priv *priv;
@@ -294,6 +299,7 @@ static int smsc_phy_probe(struct phy_device *phydev)
 
 	return clk_set_rate(refclk, 50 * 1000 * 1000);
 }
+EXPORT_SYMBOL_GPL(smsc_phy_probe);
 
 static struct phy_driver smsc_phy_driver[] = {
 {
diff --git a/include/linux/smscphy.h b/include/linux/smscphy.h
index 1a136271b..80f37c1db 100644
--- a/include/linux/smscphy.h
+++ b/include/linux/smscphy.h
@@ -28,4 +28,10 @@
 #define MII_LAN83C185_MODE_POWERDOWN 0xC0 /* Power Down mode */
 #define MII_LAN83C185_MODE_ALL       0xE0 /* All capable mode */
 
+int smsc_phy_config_intr(struct phy_device *phydev);
+irqreturn_t smsc_phy_handle_interrupt(struct phy_device *phydev);
+int smsc_phy_config_init(struct phy_device *phydev);
+int lan87xx_read_status(struct phy_device *phydev);
+int smsc_phy_probe(struct phy_device *phydev);
+
 #endif /* __LINUX_SMSCPHY_H__ */
-- 
2.39.2


