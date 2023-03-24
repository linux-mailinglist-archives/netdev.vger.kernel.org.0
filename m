Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDBF16C859B
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 20:07:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231393AbjCXTHd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 15:07:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231215AbjCXTHb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 15:07:31 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10C0FD307
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 12:07:31 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id j13so2325100pjd.1
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 12:07:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679684850;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=JD/2K4NafHhkP/HYG8KnHi7kwJoCL+jGZM0yYdrueZc=;
        b=oU8+A1Kf4Z5g2uLXeu0KpTWJQPj3f30Y+qMuczubub+04ll4tQWCTys3pUCxsyJ/Qn
         dNG+3lv15GkIzCarmGm9XAu4YGHZGNH/zboVGAbcXZDqyjTbY9MyG+nGmtHJ5pcXzMOM
         z28g3JDqGeT0yCasYInLvEP/3N1+tJuBO1aYQEEe7ZH/fn65jlXikre19ewmCkuMX+5v
         ZSU9ROkPOgQ6lqvOh3RW0bBNO+0KuWD6ChfvAZQY+JtzVOzh+cFISUBI0MA/D41NFc+G
         A8IGOKPYSHkyxoaOMDJG/UQPHLeMmanBx3X5MKSqkBmnUt95Vl8etQvjXs3LIeEec/mR
         PK3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679684850;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JD/2K4NafHhkP/HYG8KnHi7kwJoCL+jGZM0yYdrueZc=;
        b=0j1uU9EFXfBN5U5s50a+vhVp4H/9r7UbhlWGgiCtE3fOIRY+y+ILYuqvcr90NHqhw7
         2s5axTpPtfBuN3r+Yub5U+pvWTHa+wq/i6j28bErwTVcT/rpS6SBe4F8o8YlsgZQkDX7
         0xcjQVupBeJDrjMukZkClFcOtRxpk4BQ5FZDeg6kTLC/4jPwCSHNJFx+yoOnSNRQbZzQ
         du6wktpeRsPe8f6ae1z12QnPqVgvN81j/kGLsGxUf4gi5rWdrrlKW7Td+QvYsJr4vLMc
         +qbcbN5Y7YRfmW3erSLXprsTjwXALvPjuvNzpWvUwBBNDaebHQMe02uaD8o/yDVWnoxh
         vwSg==
X-Gm-Message-State: AO0yUKWlp+k6CQSmSBguCdjkIfbUx4Afz0aYyB27M8EqWB7BbBiMZwol
        QBHYn0Gn+u37Tf5Q+wbWIvhQ7rB0yqA=
X-Google-Smtp-Source: AK7set/eHOHl8jbRn/1IVlOib5DKkmaP1IKE3gOzAQ87zpB3Zj89Lp8oPBS1HvTlZSihJMglGGoIig==
X-Received: by 2002:a05:6a20:50ca:b0:de:7184:c058 with SMTP id m10-20020a056a2050ca00b000de7184c058mr2285564pza.51.1679684850480;
        Fri, 24 Mar 2023 12:07:30 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id r18-20020a63ce52000000b00502f4c62fd3sm6241241pgi.33.2023.03.24.12.07.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Mar 2023 12:07:29 -0700 (PDT)
Message-ID: <efe84928-e4fc-aca3-d6ac-7ba08fe4a705@gmail.com>
Date:   Fri, 24 Mar 2023 12:07:22 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH net-next 2/4] net: phy: smsc: remove getting reference
 clock
Content-Language: en-US
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
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
 <00ff6ad6-4554-2ce5-32ba-de47dcfcd81b@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <00ff6ad6-4554-2ce5-32ba-de47dcfcd81b@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/24/23 11:03, Heiner Kallweit wrote:
> Now that getting the reference clock has been moved to phylib,
> we can remove it here.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> ---
>   drivers/net/phy/smsc.c | 9 +--------
>   1 file changed, 1 insertion(+), 8 deletions(-)
> 
> diff --git a/drivers/net/phy/smsc.c b/drivers/net/phy/smsc.c
> index 730964b85..48654c684 100644
> --- a/drivers/net/phy/smsc.c
> +++ b/drivers/net/phy/smsc.c
> @@ -278,7 +278,6 @@ int smsc_phy_probe(struct phy_device *phydev)
>   {
>   	struct device *dev = &phydev->mdio.dev;
>   	struct smsc_phy_priv *priv;
> -	struct clk *refclk;
>   
>   	priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
>   	if (!priv)
> @@ -291,13 +290,7 @@ int smsc_phy_probe(struct phy_device *phydev)
>   
>   	phydev->priv = priv;
>   
> -	/* Make clk optional to keep DTB backward compatibility. */
> -	refclk = devm_clk_get_optional_enabled(dev, NULL);
> -	if (IS_ERR(refclk))
> -		return dev_err_probe(dev, PTR_ERR(refclk),
> -				     "Failed to request clock\n");
> -
> -	return clk_set_rate(refclk, 50 * 1000 * 1000);
> +	return clk_set_rate(phydev->refclk, 50 * 1000 * 1000);

AFAIR one should be calling clk_prepare_enable() before clk_set_rate(), 
which neither smsc.c nor micrel.c do.

If we insist on moving this code to the PHY library which I have no 
strong objections against, we might provide a PHY_REQUIRES_REFCLK flag 
that the generic code can key off, or in the same of bcm7xx.c: 
PHY_LET_ME_MANAGED_MY_CLOCK?
-- 
Florian

