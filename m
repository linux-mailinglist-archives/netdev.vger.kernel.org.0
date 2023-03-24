Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 465B86C859A
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 20:07:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231320AbjCXTHc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 15:07:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230133AbjCXTHb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 15:07:31 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF48F9773
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 12:07:30 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id k2so2709788pll.8
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 12:07:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679684850;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=JD/2K4NafHhkP/HYG8KnHi7kwJoCL+jGZM0yYdrueZc=;
        b=aTNBtxPC0+5iIjadIOzUqIki/rRJq4xaxi7Zvs/Bhe/pk7zUbd89h4xNWTqBtmIl5T
         R0E+CP1oGikEBoZF5rFgV3g9zxG9bp0XQHCx4XVOO5tNaTGnLND8EntZAOppxQqzaEkx
         jNR5Nf5px9Rx5PhvdLVfaXbL8+MfDPW7Ci1G9tWMRCIwooBLtfMqUVbimN6IYln0pZI6
         wKEhrCU4+ACchRKDvL/lWe4v1tVIWbbIXFFesD7ST/SukvQIpOKRj/k2UwEpB5eMJGwh
         hpN2JzzBC0XqQ/SSZcaOc80amfFCQ6Z6uCgoeCZX0VKz2Oy5g8T4hPzuRl1hSLuSRRxp
         jq1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679684850;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JD/2K4NafHhkP/HYG8KnHi7kwJoCL+jGZM0yYdrueZc=;
        b=W7f/ynEXL6kfsxvrvoIryU86emSbQyuHN/nq2LnHOCJYfcbCDP4lQ2F7lq/4iUQ1G6
         ug/IQwEu2XAwfbrLjLq4THazEUVR/zPc95Fucdz/yBcQHkBRBm4uBjTuNSwrfIAOBw8/
         pXmQ16+98nDt5k7KLrSYDU96yHMhG1H/7JAaTuzcvMpIDBBJnT+0nDCOTQffIFA6uIHj
         n4IuGsbsGuI01Pq+dJuOdTo4sgRqGDynct/EWHxo6tB09XIoXD8awnyC249paXoVTABh
         3YDJnSfY0w7WwwdH66DQ90qob0fUIH66cT/CbwS9l0fQ//QTCgHZOhCA3OuieU8RNU/6
         IsCw==
X-Gm-Message-State: AO0yUKXwote41CCJ8F2r2TnzxG6/Vg/cIDs4V3ibLjQ3FiZzZP2ELRnf
        e8JhYUBbzDdDk+cSftD+0/Y=
X-Google-Smtp-Source: AK7set/+6cKyL6YU7PhZ+07iA/p2KjHMcEvw4QT+zRs9Liv1akwm76oBYZNQCkz8CJc6yAoc4Q5xLQ==
X-Received: by 2002:a05:6a20:12d5:b0:da:f9f0:ec90 with SMTP id v21-20020a056a2012d500b000daf9f0ec90mr8970439pzg.12.1679684850045;
        Fri, 24 Mar 2023 12:07:30 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id d10-20020a634f0a000000b0050f56964426sm11743834pgb.54.2023.03.24.12.07.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Mar 2023 12:07:29 -0700 (PDT)
Message-ID: <3d00d8de-b47e-c44a-fffa-542a0d9d5796@gmail.com>
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

