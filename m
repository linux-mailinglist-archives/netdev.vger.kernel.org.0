Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CABF7607288
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 10:38:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230214AbiJUIid (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 04:38:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230178AbiJUIib (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 04:38:31 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1493A24CC0D;
        Fri, 21 Oct 2022 01:38:18 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id j7so3757702wrr.3;
        Fri, 21 Oct 2022 01:38:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pQoyO2PFxHa5qEp4t8CYSXnoBOHzNPGs0igvTXL17bA=;
        b=HJsKXBPZaZwsUkqrFMccGOAObyH9NClc1Y83F47t4k878dykcq8QKUb79/tKPBo6Xd
         cK7jfmx8Y7DdM7GPTfNTiffd4yFIv1APrfzUTKdcXkUabQceCk2g9aqNJ6Bl5eh/a9xk
         Pi1Xq16NjVIoEkSkhwl3hbGcH9/JkURyGsNXPE/LePW3QpPDF/NCei+hlvApeqxOzcHQ
         o5E3UUTFEj2W6BbMzaYoNnFZ+cTHEI96KQzc6y6Y/VLZ6paWAk0qQpM9Ij23a04TG8Xw
         lGViJZ5tbx4Ka790L/bnzpQg3PooO+NmHxo69ZRW8bYFZUNuBmjTdrJm1IMKLxI4nnNU
         4wjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pQoyO2PFxHa5qEp4t8CYSXnoBOHzNPGs0igvTXL17bA=;
        b=u0KN6kki1kl+yysVENtwlStyN2AqVofmTWH2gB6uic9voi/k/urHEMzT0kedXl7s7N
         tj3DndWavXg2FRDayMIedjiXW9ps0AMkM80T+A3U5b0hkIMtn/iIFqi5JKBCzvxS2VzW
         i9ZofBjX2Byr1Xz+B9moBmHaAmbn01DSVFyG8NQBOnBqZ7MjZ34HQO9l/51DpxaumLhW
         k1CcAuGwaywmHAPajFs50+17YP4Z+qGqdt6rIG2R0WzspmDM/zkBYeXiVWQBwC9pj3qO
         vVgc1tMchHjqf3GpDtj/4uA2IvmM6/3I8D/SXC0FzwA7VK4ERVPx7If0tbfTXrXFbhXj
         i7Cg==
X-Gm-Message-State: ACrzQf3SMLfXhkHP2Dav8N8JlkZBeTZub1Utvj4MPlG4HSYyi0d6oSn7
        ESHRMhd52OmBn1ZH/6MKeAE=
X-Google-Smtp-Source: AMsMyM7hljAgIepnxvCoe6QFHmtj65zDg7L7ySS/uaSdCxGGKL5ZcVAkZhPWXdsAZBmB/Bru5apSRQ==
X-Received: by 2002:a5d:4711:0:b0:236:48b6:cb89 with SMTP id y17-20020a5d4711000000b0023648b6cb89mr3977827wrq.246.1666341496934;
        Fri, 21 Oct 2022 01:38:16 -0700 (PDT)
Received: from ?IPV6:2a01:c22:7b40:ea00:201b:7350:d064:5891? (dynamic-2a01-0c22-7b40-ea00-201b-7350-d064-5891.c22.pool.telefonica.de. [2a01:c22:7b40:ea00:201b:7350:d064:5891])
        by smtp.googlemail.com with ESMTPSA id iv19-20020a05600c549300b003c71358a42dsm2679800wmb.18.2022.10.21.01.38.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Oct 2022 01:38:16 -0700 (PDT)
Message-ID: <4d2d6349-6910-3e73-e6c5-db9041bcfdb8@gmail.com>
Date:   Fri, 21 Oct 2022 10:38:10 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Content-Language: en-US
To:     Kunihiko Hayashi <hayashi.kunihiko@socionext.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20221021074154.25906-1-hayashi.kunihiko@socionext.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH net] net: phy: Avoid WARN_ON for PHY_NOLINK during
 resuming
In-Reply-To: <20221021074154.25906-1-hayashi.kunihiko@socionext.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 21.10.2022 09:41, Kunihiko Hayashi wrote:
> When resuming from sleep, if there is a time lag from link-down to link-up
> due to auto-negotiation, the phy status has been still PHY_NOLINK, so
> WARN_ON dump occurs in mdio_bus_phy_resume(). For example, UniPhier AVE
> ethernet takes about a few seconds to link up after resuming.
> 
That autoneg takes some time is normal. If this would actually the root
cause then basically every driver should be affected. But it's not.

> To avoid this issue, should remove PHY_NOLINK the WARN_ON conditions.
> 
> Signed-off-by: Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
> ---
>  drivers/net/phy/phy_device.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
> index 57849ac0384e..c647d027bb5d 100644
> --- a/drivers/net/phy/phy_device.c
> +++ b/drivers/net/phy/phy_device.c
> @@ -318,12 +318,12 @@ static __maybe_unused int mdio_bus_phy_resume(struct device *dev)
>  	phydev->suspended_by_mdio_bus = 0;
>  
>  	/* If we managed to get here with the PHY state machine in a state
> -	 * neither PHY_HALTED, PHY_READY nor PHY_UP, this is an indication
> -	 * that something went wrong and we should most likely be using
> -	 * MAC managed PM, but we are not.
> +	 * neither PHY_HALTED, PHY_READY, PHY_UP nor PHY_NOLINK, this is an
> +	 * indication that something went wrong and we should most likely
> +	 * be using MAC managed PM, but we are not.
>  	 */

Did you read the comment you're changing? ave_resume() calls phy_resume(),
so you should follow the advice in the comment.

>  	WARN_ON(phydev->state != PHY_HALTED && phydev->state != PHY_READY &&
> -		phydev->state != PHY_UP);
> +		phydev->state != PHY_UP && phydev->state != PHY_NOLINK);
>  
>  	ret = phy_init_hw(phydev);
>  	if (ret < 0)

