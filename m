Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C569D6D36AA
	for <lists+netdev@lfdr.de>; Sun,  2 Apr 2023 11:48:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230297AbjDBJsr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Apr 2023 05:48:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230243AbjDBJse (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Apr 2023 05:48:34 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A3ED5FDE
        for <netdev@vger.kernel.org>; Sun,  2 Apr 2023 02:48:33 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id t4so21206399wra.7
        for <netdev@vger.kernel.org>; Sun, 02 Apr 2023 02:48:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680428912;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=US5AITysJi0DvrH7I1yBYRlOPW+w1/VIILTUo1G3dZQ=;
        b=VqUuc1jeFxOE8B56aOQjff51BS/bwt8MPVAYGou1fXtPX+/x35WOayOtkKE7EIVIiQ
         EdOFURMxO2LwMtvDQFclZtjWM8Ir6gaBkyNRbX6dbZwNX6xBpMxEn0E82mcHL0xXWQqB
         HPWV4Rbwwf7I3tJxKJuNLVpt3bVXkhAheZD8EFd0flLfAa1VehS1X2d7d37I4GfDjSuc
         fSZIwl7+cR1jCmv0kx1Y4O5woT497X95vxrSl85Cv+KBBXyuUZt7SRvt7xAOK8jlaGVM
         fJHzzj8FJ/i878INBFsi4cAZuhs3Q+/sfLEj18AfvrqqeyvpcIzSsQLCxszNB+hY/8HF
         kbOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680428912;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=US5AITysJi0DvrH7I1yBYRlOPW+w1/VIILTUo1G3dZQ=;
        b=pU4cbqoSzVZnL2Ahck3gUlpaZTneF5Ok6G821GNHmOH66XhZklE/mBI9SDnz7rnINv
         TMTaCa30HTdQ35WXmCGXaZaGNDmjvT6u9rAQnk4VZcjOJ2Ll/nw0TBjGJr+GvE9DczJ5
         R+xwtbvnSrOqYd7AxGviMyHdH82Lee+rk8DZNlqoTV7HE0uBt1K6qw6k2bAwKi3q6YI9
         8TG/tX8y16qpJgyC0nc1iG/coxeSJ1veIxCjAuN6qwtOTzZHfDjp066TBvWwS3tP3LIR
         h0wwRfRxNnAJ4dw4NhWNP4rNkmZ/PwvVh0NSqIU+7WBcAP+K6FJ4gWNQ+H/0zv3DLbjw
         qH4g==
X-Gm-Message-State: AAQBX9eFoDUV2wIGUS9fLM+P2snhRIKRzdFMxhxRGlB7Pmc0w/6ndnKk
        WjeOu5tUyWRZKKEN4c81eKw=
X-Google-Smtp-Source: AKy350Zcz8vO7fTXi9lrhFYPijzW8y35py5tSvuFF29SLePG1/VoA5d4rm6k7blpygFI4Sa/+Uun4g==
X-Received: by 2002:a5d:6692:0:b0:2e4:cc81:8a80 with SMTP id l18-20020a5d6692000000b002e4cc818a80mr8799756wru.26.1680428911830;
        Sun, 02 Apr 2023 02:48:31 -0700 (PDT)
Received: from ?IPV6:2a01:c22:7b85:6800:129:5577:2076:7bf8? (dynamic-2a01-0c22-7b85-6800-0129-5577-2076-7bf8.c22.pool.telefonica.de. [2a01:c22:7b85:6800:129:5577:2076:7bf8])
        by smtp.googlemail.com with ESMTPSA id e7-20020adffd07000000b002ca864b807csm7008480wrr.0.2023.04.02.02.48.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 02 Apr 2023 02:48:31 -0700 (PDT)
Message-ID: <4a498ad1-5d2f-e861-1550-f67eda55c01c@gmail.com>
Date:   Sun, 2 Apr 2023 11:46:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: [PATCH net-next 4/7] net: phy: smsc: add flag edpd_mode_set_by_user
Content-Language: en-US
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <17fcccf5-8d81-298e-0671-d543340da105@gmail.com>
In-Reply-To: <17fcccf5-8d81-298e-0671-d543340da105@gmail.com>
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

Add flag edpd_mode_set_by_user in preparation of adding edpd phy tunable
support. This flag will allow users to override the default behavior
of edpd being disabled if interrupt mode is used.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/phy/smsc.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/smsc.c b/drivers/net/phy/smsc.c
index f5ecd8bea..25b9cd474 100644
--- a/drivers/net/phy/smsc.c
+++ b/drivers/net/phy/smsc.c
@@ -45,6 +45,7 @@ static struct smsc_hw_stat smsc_hw_stats[] = {
 
 struct smsc_phy_priv {
 	unsigned int edpd_enable:1;
+	unsigned int edpd_mode_set_by_user:1;
 };
 
 static int smsc_phy_ack_interrupt(struct phy_device *phydev)
@@ -117,7 +118,8 @@ int smsc_phy_config_init(struct phy_device *phydev)
 	if (!priv)
 		return 0;
 
-	if (phydev->irq != PHY_POLL)
+	/* don't use EDPD in irq mode except overridden by user */
+	if (!priv->edpd_mode_set_by_user && phydev->irq != PHY_POLL)
 		priv->edpd_enable = false;
 
 	return smsc_phy_config_edpd(phydev);
-- 
2.40.0


