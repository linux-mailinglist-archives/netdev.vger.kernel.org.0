Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA7786C847F
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 19:07:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232505AbjCXSHe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 14:07:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232271AbjCXSHT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 14:07:19 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 965F61F5F5
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 11:06:07 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id m6-20020a05600c3b0600b003ee6e324b19so1541987wms.1
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 11:06:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679681166;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Wh5z89msFtfeidRHoS+LNyTqdc6QslrKeCeDzTPeDzU=;
        b=pZL8Z3ftwwqniVCc92/YHrFDZoiYyTBeddis5yO/1T6XHVAmvUqIns6D4N+zKJnTxL
         Ur+e6yRCuQ4ru3V9Cl77qloFJny2hSdlqE2hwVRzB0TKW+tJxFUaOrh0rrGYNTNnObtV
         Y2DeG/hM47uFhdO1G6C/k3WUKSSG3Yx+zjMBb9wU8uqvVLmN9z1y3l/dwCb1uH0FAJrw
         k7prRolxVr14/bXcwNFAJvP0UwnHQKksw6ehHg2MaT0XPp+49vr4jODXANBgS0cTIypi
         0CWk4GvdF9dwipg1PsFJfsMLJYQv4iLEJw2AfJ5Ibt75OjZ4aIb+5WfXdsj0cv0+TQkg
         1kRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679681166;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Wh5z89msFtfeidRHoS+LNyTqdc6QslrKeCeDzTPeDzU=;
        b=KDQNrLEKUMA2zizcW7z09cnDrBvy6pakN4ImLdqlYbALSWSJv8j9SUR8X7KFcaYvym
         7yil1uiZz1Y2p51TDR3r5hAnbpPVP/mGG/yde59+VT2cf89FUiyLAFsApG3Ry9godnao
         PuR1HCv9muyBgoTjWg3C06pyDDeFs2j4HfsxerTkKDQCQe8Em4pca6x78KcPCyRYV365
         2cc6Lns8VOl1FTLOU4QzPNWLsypvSUWYI3RpxBpyUkc/65mQVVj5/d+d2l4TsNQ/87N8
         0mvoxorJ8Ae6WyiYmAQw28dZUJmqekHb/Rbd83p5Oxt1LHvMDed5qIv//D3rYcJNwAKP
         dX/Q==
X-Gm-Message-State: AO0yUKWtzi3jkBLeFVrwYJCKCd7By64YofBFM4LNDLJNAaxI4EjTQJ+8
        I7X2nDeU09svk/4MXnKm3fY=
X-Google-Smtp-Source: AK7set8d/DH9LXV1epGe+8e+AUQZHFrp5b972GYcFdI9gvV6nxA5KUfrINroQz2dVwWohoukMffJ1w==
X-Received: by 2002:a05:600c:3795:b0:3ed:a82d:dffb with SMTP id o21-20020a05600c379500b003eda82ddffbmr3024309wmr.40.1679681165996;
        Fri, 24 Mar 2023 11:06:05 -0700 (PDT)
Received: from ?IPV6:2a01:c23:b926:df00:a161:16e2:f237:a7d4? (dynamic-2a01-0c23-b926-df00-a161-16e2-f237-a7d4.c23.pool.telefonica.de. [2a01:c23:b926:df00:a161:16e2:f237:a7d4])
        by smtp.googlemail.com with ESMTPSA id s3-20020a05600c45c300b003ed51cdb94csm483081wmo.26.2023.03.24.11.06.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Mar 2023 11:06:05 -0700 (PDT)
Message-ID: <00ff6ad6-4554-2ce5-32ba-de47dcfcd81b@gmail.com>
Date:   Fri, 24 Mar 2023 19:03:51 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: [PATCH net-next 2/4] net: phy: smsc: remove getting reference clock
Content-Language: en-US
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Broadcom internal kernel review list 
        <bcm-kernel-feedback-list@broadcom.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <0c529488-0fd8-19e1-c5a9-9cf1fab78ed3@gmail.com>
In-Reply-To: <0c529488-0fd8-19e1-c5a9-9cf1fab78ed3@gmail.com>
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

Now that getting the reference clock has been moved to phylib,
we can remove it here.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/phy/smsc.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/drivers/net/phy/smsc.c b/drivers/net/phy/smsc.c
index 730964b85..48654c684 100644
--- a/drivers/net/phy/smsc.c
+++ b/drivers/net/phy/smsc.c
@@ -278,7 +278,6 @@ int smsc_phy_probe(struct phy_device *phydev)
 {
 	struct device *dev = &phydev->mdio.dev;
 	struct smsc_phy_priv *priv;
-	struct clk *refclk;
 
 	priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
 	if (!priv)
@@ -291,13 +290,7 @@ int smsc_phy_probe(struct phy_device *phydev)
 
 	phydev->priv = priv;
 
-	/* Make clk optional to keep DTB backward compatibility. */
-	refclk = devm_clk_get_optional_enabled(dev, NULL);
-	if (IS_ERR(refclk))
-		return dev_err_probe(dev, PTR_ERR(refclk),
-				     "Failed to request clock\n");
-
-	return clk_set_rate(refclk, 50 * 1000 * 1000);
+	return clk_set_rate(phydev->refclk, 50 * 1000 * 1000);
 }
 EXPORT_SYMBOL_GPL(smsc_phy_probe);
 
-- 
2.40.0


