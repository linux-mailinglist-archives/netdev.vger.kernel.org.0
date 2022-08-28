Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 771985A3ED1
	for <lists+netdev@lfdr.de>; Sun, 28 Aug 2022 19:27:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229729AbiH1R1F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Aug 2022 13:27:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbiH1R1E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Aug 2022 13:27:04 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44323326F1
        for <netdev@vger.kernel.org>; Sun, 28 Aug 2022 10:27:02 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id d5so3230000wms.5
        for <netdev@vger.kernel.org>; Sun, 28 Aug 2022 10:27:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:subject:content-language:cc:to:from
         :user-agent:mime-version:date:message-id:from:to:cc;
        bh=VKinsSBNpmEe6EESnAA+hwijexcfEqkNrWrg7QLbLZU=;
        b=ZXbn748PUvSDuxQSgfMgcXF9QadCIr2SYJNkmumEz24UiAXVbr1diz9IQCVH7AlthW
         5P5Is70NJi3XXdEXn9RLE0E1ULh3RAqFu0qAnt1JNpLq+emKuMF1xB2lyIJxeU+29owZ
         OxetyYYa2UUnfAQecop3oY7h7vTTPx+EKI820rdUX64qLHO/K2TU7l8zR2ZSlnELdXLb
         EVy4cfwxlzAFUTyiuYQOGzZ0yoaxgeuApy4v36bwpgOWs5HZDMtqz4Q90my8JuE8C0he
         nVO2GiLquukx/rdjbv1inCpm0VuprHLrmkrK4Hw8Ril1uoSxGpwpAGVOtUm+OH2lSLbS
         GZAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:subject:content-language:cc:to:from
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc;
        bh=VKinsSBNpmEe6EESnAA+hwijexcfEqkNrWrg7QLbLZU=;
        b=Cm8ciPBt+3BvWyrg8gXiD/picTLUfW7xNCyAAxo6mXFhUcCu0FmlVNgmf+2NusSZgv
         JBki3q2L/lflPmcO+PtojpIUyqnH3GMHF0rfXwywrXXw3lGOrkJJreQ7+Lkw64GrdX/P
         cm8nvbxnX1+J4bkStGFkF7YCvLjxBVzrRKiQm3CDNVQk69d+TpliA0KTV1KamTEIxd+d
         t2P9JHq24hWiqRe8Aylrb1n+C8DrBg5TPwI43IhZhSn1HUr5q3ngyqZ4u/yTrNFIPcq1
         Q4wZCKYbx71ru3qUk53B6nBQuXgviqEqfeRkZRIB40BjGwMMcdwVij+s6TxIJOwdcBeV
         uUZA==
X-Gm-Message-State: ACgBeo0Gcdi6HLVEWnkyJTxWGj7akkhrb0mUZkc5ouYBs0LzBas2dX/c
        TPhR4Si77x+05UIAOZS0yBw=
X-Google-Smtp-Source: AA6agR7zTZEY98WltLbYwssqPNPkI/xIwtItZhbk+zWjG2zJdOAHwDuA+x/lvbSS4iiWK7L3o7WS6w==
X-Received: by 2002:a05:600c:4e4c:b0:3a5:eb9b:b489 with SMTP id e12-20020a05600c4e4c00b003a5eb9bb489mr4698184wmq.56.1661707620684;
        Sun, 28 Aug 2022 10:27:00 -0700 (PDT)
Received: from ?IPV6:2a01:c23:c4cf:9e00:c839:3d9b:601a:ef07? (dynamic-2a01-0c23-c4cf-9e00-c839-3d9b-601a-ef07.c23.pool.telefonica.de. [2a01:c23:c4cf:9e00:c839:3d9b:601a:ef07])
        by smtp.googlemail.com with ESMTPSA id z14-20020adfd0ce000000b002253fd19a6asm5921936wrh.18.2022.08.28.10.26.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 28 Aug 2022 10:26:59 -0700 (PDT)
Message-ID: <b222be68-ba7e-999d-0a07-eca0ecedf74e@gmail.com>
Date:   Sun, 28 Aug 2022 19:26:55 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>
Content-Language: en-US
Subject: [PATCH net-next] net: phy: smsc: use device-managed clock API
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Simplify the code by using the device-managed clock API.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/phy/smsc.c | 30 +++++-------------------------
 1 file changed, 5 insertions(+), 25 deletions(-)

diff --git a/drivers/net/phy/smsc.c b/drivers/net/phy/smsc.c
index 69423b896..ac7481ce2 100644
--- a/drivers/net/phy/smsc.c
+++ b/drivers/net/phy/smsc.c
@@ -46,7 +46,6 @@ static struct smsc_hw_stat smsc_hw_stats[] = {
 struct smsc_phy_priv {
 	u16 intmask;
 	bool energy_enable;
-	struct clk *refclk;
 };
 
 static int smsc_phy_ack_interrupt(struct phy_device *phydev)
@@ -285,20 +284,12 @@ static void smsc_get_stats(struct phy_device *phydev,
 		data[i] = smsc_get_stat(phydev, i);
 }
 
-static void smsc_phy_remove(struct phy_device *phydev)
-{
-	struct smsc_phy_priv *priv = phydev->priv;
-
-	clk_disable_unprepare(priv->refclk);
-	clk_put(priv->refclk);
-}
-
 static int smsc_phy_probe(struct phy_device *phydev)
 {
 	struct device *dev = &phydev->mdio.dev;
 	struct device_node *of_node = dev->of_node;
 	struct smsc_phy_priv *priv;
-	int ret;
+	struct clk *refclk;
 
 	priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
 	if (!priv)
@@ -312,22 +303,12 @@ static int smsc_phy_probe(struct phy_device *phydev)
 	phydev->priv = priv;
 
 	/* Make clk optional to keep DTB backward compatibility. */
-	priv->refclk = clk_get_optional(dev, NULL);
-	if (IS_ERR(priv->refclk))
-		return dev_err_probe(dev, PTR_ERR(priv->refclk),
+	refclk = devm_clk_get_optional_enabled(dev, NULL);
+	if (IS_ERR(refclk))
+		return dev_err_probe(dev, PTR_ERR(refclk),
 				     "Failed to request clock\n");
 
-	ret = clk_prepare_enable(priv->refclk);
-	if (ret)
-		return ret;
-
-	ret = clk_set_rate(priv->refclk, 50 * 1000 * 1000);
-	if (ret) {
-		clk_disable_unprepare(priv->refclk);
-		return ret;
-	}
-
-	return 0;
+	return clk_set_rate(refclk, 50 * 1000 * 1000);
 }
 
 static struct phy_driver smsc_phy_driver[] = {
@@ -429,7 +410,6 @@ static struct phy_driver smsc_phy_driver[] = {
 	/* PHY_BASIC_FEATURES */
 
 	.probe		= smsc_phy_probe,
-	.remove		= smsc_phy_remove,
 
 	/* basic functions */
 	.read_status	= lan87xx_read_status,
-- 
2.37.2

