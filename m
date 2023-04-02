Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58E456D38BC
	for <lists+netdev@lfdr.de>; Sun,  2 Apr 2023 17:18:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231263AbjDBPSX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Apr 2023 11:18:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231254AbjDBPSV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Apr 2023 11:18:21 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AAA0CDFA
        for <netdev@vger.kernel.org>; Sun,  2 Apr 2023 08:18:20 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id t10so107762704edd.12
        for <netdev@vger.kernel.org>; Sun, 02 Apr 2023 08:18:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680448699;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bpfHGW2yJcvgbBDsBVm5Q8M8aPAgMf3N33Xltk/h07w=;
        b=W0cOs6TnfvSJBwlHJT0fXxvxv6do+Br483bDSo47Wp6KMXa1gbqiiiK42tAd4y/Cg/
         J6/5oJ2xqPHxUbm6twDOnyxo4RpZ9VjmuXnE/9hYDlZ+tWndsca9L8iy4XCppSZo8Y7n
         WhaNT1qmJxyDQv9+tR7SkaulZqeivEBHolD7FLEjVBPaXmed7Qu6L+wcf0s5yp3h1nql
         HVRCj4FUEdQfXXr2CNIRz0ZRXTux2a9aRUBG1R/BP9FsqukXkJzxtrcVR5H1+YVX5fjf
         qLtk7fNFxjDSEOqL7+dCbzwUXZ6HbGoD60H9FR7As6zCzNDc/haSVn2OMYsnaE6Dc9Vk
         9ZYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680448699;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bpfHGW2yJcvgbBDsBVm5Q8M8aPAgMf3N33Xltk/h07w=;
        b=ZoS3+hdMv0LUvrhAM4BUlLl01X/uRbgKfhGjOmAlo7yhpniYQ2uZyo0CY/WQYhPsTM
         g/o3PWsBGWghnacHKrVLbsJSjwhWrA6ZQ1An3OAMueH83TiH5EA59Rkj+hboe8Cr1E5N
         6uhsB8foUFxmx0a7RQcvAHqSfedd3LIhnsUdCt+Ffq9U43U4POZNh9SIvmUldWtNRqqB
         WyMjwAHONSstPnHRg/s2Y8Szs1w8Ej+P/Xs0Y6Bfmsd1YSTs+NH9l48sRPafD7N22BFs
         fNW0JUfmRE2xzBjABPBtw1xlqQfK7SCCIBdfBan0NVBxtHcgDTPbiovKQXrmeBXEzHej
         Uqsw==
X-Gm-Message-State: AAQBX9eHifejQ/EGpz++vZzIiYIonGE5QeJCqCNyVwuFa/JcD05MP+Qb
        UjnzvPsTI0YMGsP4aQmFhDg=
X-Google-Smtp-Source: AKy350ZBmWgMgkpiQ4kvAD1ysRnb8ODJaYe6YtTltH5mdam5lAk2RkduqP10WGn1fqPqdZDeZfrwAg==
X-Received: by 2002:a17:906:738a:b0:933:4ca3:9678 with SMTP id f10-20020a170906738a00b009334ca39678mr32509912ejl.24.1680448698623;
        Sun, 02 Apr 2023 08:18:18 -0700 (PDT)
Received: from ?IPV6:2a01:c22:7b85:6800:129:5577:2076:7bf8? (dynamic-2a01-0c22-7b85-6800-0129-5577-2076-7bf8.c22.pool.telefonica.de. [2a01:c22:7b85:6800:129:5577:2076:7bf8])
        by smtp.googlemail.com with ESMTPSA id l20-20020a17090612d400b00947740a4373sm3301741ejb.81.2023.04.02.08.18.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 02 Apr 2023 08:18:18 -0700 (PDT)
Message-ID: <31386c3d-098b-6731-7431-baa761bfd16a@gmail.com>
Date:   Sun, 2 Apr 2023 17:13:05 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: [PATCH net-next v2 3/7] net: phy: smsc: clear edpd_enable if
 interrupt mode is used
Content-Language: en-US
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Chris Healy <cphealy@gmail.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <d0e999eb-d148-a5c1-df03-9b4522b9f2fd@gmail.com>
In-Reply-To: <d0e999eb-d148-a5c1-df03-9b4522b9f2fd@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Clear edpd_enable if interupt mode is used, this avoids
having to check for PHY_POLL multiple times.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/phy/smsc.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/phy/smsc.c b/drivers/net/phy/smsc.c
index 1b588366e..f5ecd8bea 100644
--- a/drivers/net/phy/smsc.c
+++ b/drivers/net/phy/smsc.c
@@ -114,9 +114,12 @@ int smsc_phy_config_init(struct phy_device *phydev)
 {
 	struct smsc_phy_priv *priv = phydev->priv;
 
-	if (!priv || !priv->edpd_enable || phydev->irq != PHY_POLL)
+	if (!priv)
 		return 0;
 
+	if (phydev->irq != PHY_POLL)
+		priv->edpd_enable = false;
+
 	return smsc_phy_config_edpd(phydev);
 }
 EXPORT_SYMBOL_GPL(smsc_phy_config_init);
@@ -208,8 +211,7 @@ int lan87xx_read_status(struct phy_device *phydev)
 	if (err)
 		return err;
 
-	if (!phydev->link && priv && priv->edpd_enable &&
-	    phydev->irq == PHY_POLL) {
+	if (!phydev->link && priv && priv->edpd_enable) {
 		/* Disable EDPD to wake up PHY */
 		int rc = phy_read(phydev, MII_LAN83C185_CTRL_STATUS);
 		if (rc < 0)
-- 
2.40.0


