Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB1E066B321
	for <lists+netdev@lfdr.de>; Sun, 15 Jan 2023 18:24:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231503AbjAORYS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Jan 2023 12:24:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231466AbjAORYQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Jan 2023 12:24:16 -0500
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A067910AA7
        for <netdev@vger.kernel.org>; Sun, 15 Jan 2023 09:24:15 -0800 (PST)
Received: by mail-wr1-x430.google.com with SMTP id d2so5329511wrp.8
        for <netdev@vger.kernel.org>; Sun, 15 Jan 2023 09:24:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:subject:cc:to:from:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=j33kBZUIvSttDcJNiDhmhi+aOiW+Zkk3cCrvmWPxqBw=;
        b=DEorzrSGdlfxsGkxP/1rD9VSMOj64kaKI02Gxatdd+ZO61Bi+fBTIak37ZbZ0XWs4T
         LQ0z9wkWW6c5MyHlJ4yVplPIwP0wQGsT4ajFdzfBfHXfg32Uhfz6Kj+LeKkleKPGaIxX
         lomshArJqi2jIY/BHdySok6Z2K4EWE2NoVirgRXtAySekEm1xATxoakzxbaEV8JLpaI5
         HaU6FDA+hAAaMm69B6bOQFtVqX//np3gx0IF6iKrEwfZTi5J7ZNc+T7fHGr+DGDhbo+s
         zI9txitUTjjladz98Pb1aZFshWBBiKJgjgYOouQODZ9GIscjkn2WckJ66O9ZQnrb+ca/
         3r9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:subject:cc:to:from:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=j33kBZUIvSttDcJNiDhmhi+aOiW+Zkk3cCrvmWPxqBw=;
        b=1yai0xEW4QNEmJMuMQ1yFxCm5Uxm1p855RGXQg25sBjAxJzVoxLRbPCBYQlI6icAh1
         U79nkPTs4gX0ZGm9w+kkP0BV+IapunRKXolwZJttPO5QBFUFgSTAyqnaF4d6lT54Q1Zc
         Fbgt1lIq6jEIO5oFgM60dpIfCqrRVsueD3+yNTSWO9o+4PoPgMaryswFQOiJMEx/HRRu
         D5GfOB0PvLW27U2Iq4THOkrUVEUZOZ0nlnVotxkA8HQ08/Y9gZeYKjWPdfm6FHJ1zpzN
         6o1FCe67UU2qUahVk0wOcqKI/YFta1dQ0AIVDEK9Xi/L13F66Aoz4TfFBOp8Wk0OPLti
         bSkQ==
X-Gm-Message-State: AFqh2krK9f6g5ErtrAIOKlLvqdqI8iA4OnatvMFyHOW0BhZz7KMRomBv
        kZfdOuSmVQTduoRrioN6Pe4=
X-Google-Smtp-Source: AMrXdXsN2fgUMlz0VEb3fiec73uMNyAfptQzkoSuoDcSmzy/aYMEHDLW8xiUikSLqk3Q19u7El+5Og==
X-Received: by 2002:a5d:4e83:0:b0:2bd:d857:f96 with SMTP id e3-20020a5d4e83000000b002bdd8570f96mr5106360wru.60.1673803454083;
        Sun, 15 Jan 2023 09:24:14 -0800 (PST)
Received: from ?IPV6:2a01:c22:6e61:8c00:154f:326e:8d45:8ce7? (dynamic-2a01-0c22-6e61-8c00-154f-326e-8d45-8ce7.c22.pool.telefonica.de. [2a01:c22:6e61:8c00:154f:326e:8d45:8ce7])
        by smtp.googlemail.com with ESMTPSA id bt14-20020a056000080e00b0027cb20605e3sm862315wrb.105.2023.01.15.09.24.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 15 Jan 2023 09:24:13 -0800 (PST)
Message-ID: <669f9671-ecd1-a41b-2727-7b73e3003985@gmail.com>
Date:   Sun, 15 Jan 2023 18:24:08 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Content-Language: en-US
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: [PATCH net] net: stmmac: fix invalid call to mdiobus_get_phy()
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

In a number of cases the driver assigns a default value of -1 to
priv->plat->phy_addr. This may result in calling mdiobus_get_phy()
with addr parameter being -1. Therefore check for this scenario and
bail out before calling mdiobus_get_phy().

Fixes: 42e87024f727 ("net: stmmac: Fix case when PHY handle is not present")
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index c6951c976..b7e5af58a 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -1150,6 +1150,11 @@ static int stmmac_init_phy(struct net_device *dev)
 		int addr = priv->plat->phy_addr;
 		struct phy_device *phydev;
 
+		if (addr < 0) {
+			netdev_err(priv->dev, "no phy found\n");
+			return -ENODEV;
+		}
+
 		phydev = mdiobus_get_phy(priv->mii, addr);
 		if (!phydev) {
 			netdev_err(priv->dev, "no phy at addr %d\n", addr);
-- 
2.39.0

