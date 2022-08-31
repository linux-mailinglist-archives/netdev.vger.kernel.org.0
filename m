Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB7725A86A7
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 21:21:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230423AbiHaTVH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 15:21:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230383AbiHaTVC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 15:21:02 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E2FCC6FF6
        for <netdev@vger.kernel.org>; Wed, 31 Aug 2022 12:21:01 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id p16so27231726ejb.9
        for <netdev@vger.kernel.org>; Wed, 31 Aug 2022 12:21:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:subject:content-language:cc:to:from
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date;
        bh=CU4jlNICWwxwIKN3U1yXNEjVJVgs1zGOKYSjXQNOblA=;
        b=cllwuJHTbcg7nm6DdJSo3WuInkP0YF2uNVEOIMf5nwb5rnsqWlf5sUAfYgzgwdvH4d
         gbD4zOwDw+nJgMOwmg1CDqOga0hNf6Sx21l20f0m7hjONQ7xwmZpHVoiWNI2MSRzVnl/
         QBEts6XmAoQGDsCdK+TH46kvuqRGZl4tM1FQ3qzyAoP53okDp+l54VQJaDQXvB1DibNe
         QcQphq0ddm08hlIg3AusnUCOQDJ6O1YS4K0haWBeHTluY9dQESbgY9A7DBhW0Y7S2DEF
         fGGr25TaSE+H3D2rbHRYeM2fk/iA4o3lzzWtNPdioNkBkQFXjkNhAh5SNnRP8yZakkr6
         vnsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:subject:content-language:cc:to:from
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date;
        bh=CU4jlNICWwxwIKN3U1yXNEjVJVgs1zGOKYSjXQNOblA=;
        b=Ta/T0JFbOU/1AzCEsdRNbEeBC6PWMlQLIBnr2KsgEc2xlxmSYoiYDLHRloOwK+G2b3
         Qh48gTVsemTR2YLRviTUri3FVilRfELnhIYFOyesPVUVJFeqo7lZ68fHXSl1JhMup7Xy
         RwF2DTlcORiDf15Lx1Q5qF59Ev4O7GKFrl5sy4Ot6wbg9xv59SLEOp6Lr3X24ZUqEBoM
         FgYFnTr2F9/egBE+2c2VM09FHInuRYH7tAtPmh8N+EArqzMmjdoWri0qJMtB8qKUBx49
         qzKOmKwSu1eC8U5sdY1ZXcPahAXdpNnrwbljGxzxo8s48p+mIydcWC8YLixNW581VjYQ
         nWyQ==
X-Gm-Message-State: ACgBeo3FtTQ2gUeR7SogfMNygD1/+WnhMjlXIWRiFN2zV3D/yZ40S/lh
        wNTYMnqreLLNiZguNbf6qe0=
X-Google-Smtp-Source: AA6agR6pvm7M80kDKWhWFKW0DJgcXtlN/NsT9e6TdEGJ0gkZXK7GHSs6sEJ4GC1gJIxU6vZBEvlRHA==
X-Received: by 2002:a17:907:2cd4:b0:73c:9fa8:3ddc with SMTP id hg20-20020a1709072cd400b0073c9fa83ddcmr12394193ejc.40.1661973659892;
        Wed, 31 Aug 2022 12:20:59 -0700 (PDT)
Received: from ?IPV6:2a01:c22:774a:2d00:80dd:ea1f:ff9f:1e2d? (dynamic-2a01-0c22-774a-2d00-80dd-ea1f-ff9f-1e2d.c22.pool.telefonica.de. [2a01:c22:774a:2d00:80dd:ea1f:ff9f:1e2d])
        by smtp.googlemail.com with ESMTPSA id s22-20020a50ab16000000b00445e1489313sm20071edc.94.2022.08.31.12.20.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 31 Aug 2022 12:20:58 -0700 (PDT)
Message-ID: <8deeeddc-6b71-129b-1918-495a12dc11e3@gmail.com>
Date:   Wed, 31 Aug 2022 21:20:49 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@armlinux.org.uk>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Kevin Hilman <khilman@baylibre.com>,
        Jerome Brunet <jbrunet@baylibre.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "open list:ARM/Amlogic Meson..." <linux-amlogic@lists.infradead.org>
Content-Language: en-US
Subject: [PATCH net] Revert "net: phy: meson-gxl: improve link-up behavior"
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

This reverts commit 2c87c6f9fbddc5b84d67b2fa3f432fcac6d99d93.
Meanwhile it turned out that the following commit is the proper
workaround for the issue that 2c87c6f9fbdd tries to address.
a3a57bf07de2 ("net: stmmac: work around sporadic tx issue on link-up")
It's nor clear why the to be reverted commit helped for one user,
for others it didn't make a difference.

Fixes: 2c87c6f9fbdd ("net: phy: meson-gxl: improve link-up behavior")
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/phy/meson-gxl.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/net/phy/meson-gxl.c b/drivers/net/phy/meson-gxl.c
index 73f7962a37d3..c49062ad72c6 100644
--- a/drivers/net/phy/meson-gxl.c
+++ b/drivers/net/phy/meson-gxl.c
@@ -243,13 +243,7 @@ static irqreturn_t meson_gxl_handle_interrupt(struct phy_device *phydev)
 	    irq_status == INTSRC_ENERGY_DETECT)
 		return IRQ_HANDLED;
 
-	/* Give PHY some time before MAC starts sending data. This works
-	 * around an issue where network doesn't come up properly.
-	 */
-	if (!(irq_status & INTSRC_LINK_DOWN))
-		phy_queue_state_machine(phydev, msecs_to_jiffies(100));
-	else
-		phy_trigger_machine(phydev);
+	phy_trigger_machine(phydev);
 
 	return IRQ_HANDLED;
 }
-- 
2.37.2

