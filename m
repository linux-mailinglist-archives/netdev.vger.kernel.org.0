Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78C184D3BAE
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 22:05:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236876AbiCIVF7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 16:05:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234458AbiCIVF6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 16:05:58 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5246F543D
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 13:04:58 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id y22so4493022eds.2
        for <netdev@vger.kernel.org>; Wed, 09 Mar 2022 13:04:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:cc:from
         :subject:content-transfer-encoding;
        bh=WF5uaCx5pmP5JX00+D6eM3lqNw9uHLykZUlLYCW0P94=;
        b=pBssSHtqJ3GHfnXCagspkMeb1FLvSrigdCSjwEUL/I6u0bWka05gHXuYYNxMI9rphQ
         7PPvmnlrS7MTUHgpp60ha8HMFxGloV4Mf6eMQW/226fX3BI++EJibG1egtYlCYKkF8fm
         9ExlgOtqchacYMVfei10qogWH6kyVNHMzKH+1kxsja3W96S0YW3vDDyWDXw+V0iciHgh
         BD4aATLWrKxjZK7nzoMTmw5CWLxjSeeo6Ia/nVR+AZe9TBh7b/5/TkAvcHl/PGaFKarL
         l3oRsoFCKhfsoWzfAHy21C6DJ1zOrl1FLUqDv+QNKZk9gwVXd7iXxVDdyGX2K+tHPp99
         yO3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:from:subject:content-transfer-encoding;
        bh=WF5uaCx5pmP5JX00+D6eM3lqNw9uHLykZUlLYCW0P94=;
        b=vWFnUe6jiAICikoIPuevl3AZjEbAecmvNlGOAlIg+s0HGjn6v0x0+2mcFidtIqU3FM
         uQKnaydUbaWHGu/3gCQPtQj0gvU7JOi8hc5EhhPEQYLXk/C9x631h7Y5yVKBbwNC3nDc
         FvLT71+7cN2e3+uZMX4KMDM22BuAFzKkj78dYA76Eo9wGW4kYao3S8zh4LX8Y9mPOFoq
         KRAb51k0t1YIqAcwUK1QYXGn/vFm9HX5tjezd4j54Sx+W2WosqCkt288w4i/HjnY4xpx
         eoBGYs/DM1MUke1FtKfIGPXmSDUzjQ/n1ufsF/GNIfWJeqWlZRSAPnnin6S45PNk6veU
         CHgw==
X-Gm-Message-State: AOAM530UB9C2J5xe2bzuAfMTJUpLrq5k660xS+7fbOg4MO1TDHxzN8dj
        ctX41bWeHxYxWjdfiutS53E=
X-Google-Smtp-Source: ABdhPJyp5mxviqtMbA4kMNRShBPCiGJmb4vHPX46WP1NIXbPD3e4/lbbcT3rIHTP/GFzv39ZS0UPYw==
X-Received: by 2002:a50:d592:0:b0:415:e599:4166 with SMTP id v18-20020a50d592000000b00415e5994166mr1291406edi.195.1646859897467;
        Wed, 09 Mar 2022 13:04:57 -0800 (PST)
Received: from ?IPV6:2a01:c22:7793:600:9d6a:7788:3389:da6c? (dynamic-2a01-0c22-7793-0600-9d6a-7788-3389-da6c.c22.pool.telefonica.de. [2a01:c22:7793:600:9d6a:7788:3389:da6c])
        by smtp.googlemail.com with ESMTPSA id x18-20020a05640226d200b00416a502c147sm606601edd.10.2022.03.09.13.04.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Mar 2022 13:04:54 -0800 (PST)
Message-ID: <e3473452-a1f9-efcf-5fdd-02b6f44c3fcd@gmail.com>
Date:   Wed, 9 Mar 2022 22:04:47 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.2
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Kevin Hilman <khilman@baylibre.com>,
        Jerome Brunet <jbrunet@baylibre.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "open list:ARM/Amlogic Meson..." <linux-amlogic@lists.infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net] net: phy: meson-gxl: improve link-up behavior
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

Sometimes the link comes up but no data flows. This patch fixes
this behavior. It's not clear what's the root cause of the issue.

According to the tests one other link-up issue remains.
In very rare cases the link isn't even reported as up.

Fixes: 84c8f773d2dc ("net: phy: meson-gxl: remove the use of .ack_callback()")
Tested-by: Erico Nunes <nunes.erico@gmail.com>
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/phy/meson-gxl.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/meson-gxl.c b/drivers/net/phy/meson-gxl.c
index c49062ad7..73f7962a3 100644
--- a/drivers/net/phy/meson-gxl.c
+++ b/drivers/net/phy/meson-gxl.c
@@ -243,7 +243,13 @@ static irqreturn_t meson_gxl_handle_interrupt(struct phy_device *phydev)
 	    irq_status == INTSRC_ENERGY_DETECT)
 		return IRQ_HANDLED;
 
-	phy_trigger_machine(phydev);
+	/* Give PHY some time before MAC starts sending data. This works
+	 * around an issue where network doesn't come up properly.
+	 */
+	if (!(irq_status & INTSRC_LINK_DOWN))
+		phy_queue_state_machine(phydev, msecs_to_jiffies(100));
+	else
+		phy_trigger_machine(phydev);
 
 	return IRQ_HANDLED;
 }
-- 
2.35.1

