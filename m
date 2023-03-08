Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 396076B12D8
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 21:20:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230181AbjCHUUJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 15:20:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229936AbjCHUUF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 15:20:05 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8F8637705
        for <netdev@vger.kernel.org>; Wed,  8 Mar 2023 12:20:03 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id da10so70665020edb.3
        for <netdev@vger.kernel.org>; Wed, 08 Mar 2023 12:20:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678306802;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TLmDbZOlGV/ZuYwC/GzgMQtbGsrWQkcDdLWESCG8Kys=;
        b=UmGcNNCfMAMrPRquQ851JzB7/iuVI8llt+IrbVjLB9Pk+BFzSl71SZ+DDy0rbIV4sN
         cE5rNcJUmKzfdxRb9hUe38ukvokTUQpWvpv/yG+hXVocuaeYc9U5d66E+0Cl3V/gadXt
         7xRTFNqRFg3FI60i92PHLo+h63YxVogGdHxazz69EyUKWpWx2MVq+BEbar25SK8ZHsOx
         5eZlUDvX/SUwndnaRNPa2aZFN75SNpNHZGkHkLfpvZpDl1ZiwnBMgyPqh714f4FpTDeQ
         dgOOQv9460l3TMVaRDVLRJ9KgGaiowO+8L8ow4sFFYAUy0pjrF0lraaH0bAAzsomWAtL
         AFaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678306802;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=TLmDbZOlGV/ZuYwC/GzgMQtbGsrWQkcDdLWESCG8Kys=;
        b=wa/K+zyeqoUkfWKR4oVj7ArwrIHv7KWXjgJBccWdjgXt6nsZs0mydBCHB7qG5cZb5L
         Hxz4NgyuDnISOs3EdWRxfOt//WoBZg+Vwz/R7YvqiFik3/u6pm5BuvDmXqPrObyC4GqB
         gZXT9w4jg632B4GabuZMzuplNoIFL6kPYeQUksKEhzaRkfhwBiZoQGow8XZAjEdLM+TX
         +UidWsXGmkpYx3d8F+SSCAbQEEAWOO2a/froveDWRB5zWtPoRUfsatiq1nshe+RWIxr3
         1/R86k32EMLt2C9Kq1/AKmoTuzP28prUXrkquVWWlLnl/3ZeZjmz47NGmtlar35ouDDF
         vZQA==
X-Gm-Message-State: AO0yUKWXUC6Amh7nfS4/b/yUGcQovagTGcRXBjFwb64aahUXpI1goSMq
        1NJmxLnmzlafF4vEQ065l7Q=
X-Google-Smtp-Source: AK7set+mlNZ6ffrXtYsu1oHw3jwwUUGQ0R/rLZ8fzJGIFtLfrTCkNgRx0yiM/+VIIiADlYvp3+ivEA==
X-Received: by 2002:a17:906:b307:b0:8b1:7eb1:590e with SMTP id n7-20020a170906b30700b008b17eb1590emr18224076ejz.20.1678306802097;
        Wed, 08 Mar 2023 12:20:02 -0800 (PST)
Received: from ?IPV6:2a01:c22:6ed9:d400:9df:5c71:99fe:44f3? (dynamic-2a01-0c22-6ed9-d400-09df-5c71-99fe-44f3.c22.pool.telefonica.de. [2a01:c22:6ed9:d400:9df:5c71:99fe:44f3])
        by smtp.googlemail.com with ESMTPSA id j12-20020a1709062a0c00b008f14cb68ddbsm7940902eje.91.2023.03.08.12.20.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Mar 2023 12:20:01 -0800 (PST)
Message-ID: <b64d9f86-d029-b911-bbe9-6ca6889399d7@gmail.com>
Date:   Wed, 8 Mar 2023 21:19:55 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Content-Language: en-US
To:     Russell King - ARM Linux <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next] net: phy: smsc: use phy_set_bits in
 smsc_phy_config_init
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

Simplify the code by using phy_set_bits().

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/phy/smsc.c | 13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

diff --git a/drivers/net/phy/smsc.c b/drivers/net/phy/smsc.c
index 5965a8afa..630104c16 100644
--- a/drivers/net/phy/smsc.c
+++ b/drivers/net/phy/smsc.c
@@ -107,20 +107,13 @@ static irqreturn_t smsc_phy_handle_interrupt(struct phy_device *phydev)
 static int smsc_phy_config_init(struct phy_device *phydev)
 {
 	struct smsc_phy_priv *priv = phydev->priv;
-	int rc;
 
 	if (!priv->energy_enable || phydev->irq != PHY_POLL)
 		return 0;
 
-	rc = phy_read(phydev, MII_LAN83C185_CTRL_STATUS);
-
-	if (rc < 0)
-		return rc;
-
-	/* Enable energy detect mode for this SMSC Transceivers */
-	rc = phy_write(phydev, MII_LAN83C185_CTRL_STATUS,
-		       rc | MII_LAN83C185_EDPWRDOWN);
-	return rc;
+	/* Enable energy detect power down mode */
+	return phy_set_bits(phydev, MII_LAN83C185_CTRL_STATUS,
+			    MII_LAN83C185_EDPWRDOWN);
 }
 
 static int smsc_phy_reset(struct phy_device *phydev)
-- 
2.39.2

