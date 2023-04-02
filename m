Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F37176D38BE
	for <lists+netdev@lfdr.de>; Sun,  2 Apr 2023 17:18:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231284AbjDBPS3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Apr 2023 11:18:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231260AbjDBPSW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Apr 2023 11:18:22 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 807F9CDFA
        for <netdev@vger.kernel.org>; Sun,  2 Apr 2023 08:18:21 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id er13so66935280edb.9
        for <netdev@vger.kernel.org>; Sun, 02 Apr 2023 08:18:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680448700;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=US5AITysJi0DvrH7I1yBYRlOPW+w1/VIILTUo1G3dZQ=;
        b=Efig/gI4on3UQzWSGCdpERXfd/ZNNb/Nxi7j3KfIP4H/NVcuwGQZC/+ff67bTFZ9iq
         g7KN/VX41tl/B+lTwCZ/pAoLPmZtOEt9UNqgQuCsPT6wevirnFtKJvwXesg5og8Iw4XQ
         Z+L6vIo+oGGZeTJFq+iLD4VRjBnqqNrztb8JGD9uPqlJ+XsH25QxLbGYgE7onOrEXqRK
         AWEJHTbY6aAxFQj8BH5WZwyPZO36ftTamNqsD8Vjcz5b3qi5cnTNpoKCNCKl+mic97UN
         2N5pldURhWN0xFDMZ2At0xZbs+vl5q1tk4hisN4lWHEQr0f7exlVOWE09XaO34/RScsh
         WPLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680448700;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=US5AITysJi0DvrH7I1yBYRlOPW+w1/VIILTUo1G3dZQ=;
        b=t6hFhCPcsGh9oKNrQNj/OGaFx+vEDnUfgiN+WYN8uHlCuq7/dfb6c5K2orXQfxqxpD
         12e2r4CRZMAfs7anWzl+cD1Obnp1D8eB83InnXZFn56MB7y3kPd5eGcHc1OgMXxbEziq
         oz4vb/UowL2Qq+dxKEpTBez9Hrj7QBFUMgfjBVwJal/PnH5XE3wD9TnEmOb0iP77fy2I
         IJrYrBuqEJbFD4TJOns/kIu6oSPM4pccqOuSXDC1l/Iq3JMbuVsoB4+cmljRwzyqU0zc
         9jux9XR2YnmRaRE+/S5jf+DqkX+sPihSCWb9BcUdR6MmyZ7PLmHKSzGzxg5J0hTEq3HY
         6d1A==
X-Gm-Message-State: AAQBX9fufqqY0IvM+1eQ1FcOklJxcqfsQ4jVkrqesYqD4Z+1gZ+dojpC
        5F9FaEnk2E1gjY63pY2ozrQ=
X-Google-Smtp-Source: AKy350Yvxdf6GGYSzfi4ng5t/5/44uYo1gIBTgAZmzYffLuIw40XJQwviUm0O+m8bc1/LbqlpQziXQ==
X-Received: by 2002:aa7:c6d8:0:b0:4a2:5652:d8ba with SMTP id b24-20020aa7c6d8000000b004a25652d8bamr14946611eds.18.1680448699905;
        Sun, 02 Apr 2023 08:18:19 -0700 (PDT)
Received: from ?IPV6:2a01:c22:7b85:6800:129:5577:2076:7bf8? (dynamic-2a01-0c22-7b85-6800-0129-5577-2076-7bf8.c22.pool.telefonica.de. [2a01:c22:7b85:6800:129:5577:2076:7bf8])
        by smtp.googlemail.com with ESMTPSA id t20-20020a50d714000000b005021d17d896sm3375662edi.21.2023.04.02.08.18.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 02 Apr 2023 08:18:19 -0700 (PDT)
Message-ID: <61a0a91a-2743-52f0-e034-e256415c082f@gmail.com>
Date:   Sun, 2 Apr 2023 17:13:35 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: [PATCH net-next v2 4/7] net: phy: smsc: add flag
 edpd_mode_set_by_user
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


