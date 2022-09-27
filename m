Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5ADC5ECAB7
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 19:23:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231425AbiI0RXd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 13:23:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230504AbiI0RXb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 13:23:31 -0400
Received: from mail-qk1-x731.google.com (mail-qk1-x731.google.com [IPv6:2607:f8b0:4864:20::731])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 736BF1CFB84;
        Tue, 27 Sep 2022 10:23:30 -0700 (PDT)
Received: by mail-qk1-x731.google.com with SMTP id o7so6444081qkj.10;
        Tue, 27 Sep 2022 10:23:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=OvfwnftG1GbhRE0XCNvKdR8uwWFkmyM0UsIY8UjwcUY=;
        b=mtStXT0jOZjZIZIadOR23xiEnQnI97Fp0KVJrdEHMrqcdFsaKyA2t5GQCER0Kw9NGh
         UX5NA+ksc8NkRXILu08bWQiwrX3O1IZmFrzSb+Q1ja8swRCXZO2SgG73acXDrRxXLjbd
         7bhaqlCu6PvKL8q6cW0eaTVu5yfVBslKGKhevE1GR+0Yox5p973DB5EVgMAH37Rvrsne
         txv3vWVW5seWvDkN/ikKcLtNjbqCsQA0jfo/PKnxpvOdfOf5y2ltQsU3MILE7Or//17Y
         GTPbC85wrrbXrPu+cEC5i8oUoFAXcD40w3c/QptxHDewjz/V/ha4G8F+jOFTevSEuc+n
         bsfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=OvfwnftG1GbhRE0XCNvKdR8uwWFkmyM0UsIY8UjwcUY=;
        b=Ilt7ITVcGpl0AQUu4wPUpDzT+npVjF0wpavnqbbMZkz+idnT7bCNl7A80s0HLx7DnN
         ZT+YY68TFndYY29IW4YjSKeT/OpyzGwxzuraES6zUwSxLAsOKckjJPxN3FlhhnNe/Xak
         7dVjhAsoJTaBwj/67R33Tlv3mVAYHEqwqqPXP4dgnd+LIz+36BRswp+L4SEIUzr8UatC
         h7hlpKmmv3kaHA/Hm78gEJn9EdhaJV1g3OXh/Xp9+Xe/cFhKyLYhi11YYM0fYPjiIwEN
         Yl1nGMB6w1mEMaFFpmY5zykeiw754rRfTp7QA3cy/sZuE39kVgbsjzJIvuhhDq0u1wm6
         G08g==
X-Gm-Message-State: ACrzQf23m+IR+kGAKRrvsOwHpUw7IYM1F8d/nmiKmdlBI/hiD8wlV7AO
        ihL5EzC29pKCv7CZuDuhKF8=
X-Google-Smtp-Source: AMsMyM7NvUfubRv2tZvMpO3HLc1LthQzmkpt9CemUU/xdXAanAkZjAb3ctP5wyTm6ZcDfMnDgG5rUQ==
X-Received: by 2002:a05:620a:987:b0:6cb:cdf2:ee34 with SMTP id x7-20020a05620a098700b006cbcdf2ee34mr18616446qkx.429.1664299409395;
        Tue, 27 Sep 2022 10:23:29 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id t11-20020a05622a148b00b0034305a91aaesm1271721qtx.83.2022.09.27.10.23.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Sep 2022 10:23:28 -0700 (PDT)
Message-ID: <1b50703c-9de0-3331-0517-2691b7005489@gmail.com>
Date:   Tue, 27 Sep 2022 10:23:23 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH net-next v4 RESEND] stmmac: tegra: Add MGBE support
Content-Language: en-US
To:     Thierry Reding <thierry.reding@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     Jon Hunter <jonathanh@nvidia.com>,
        Bhadram Varka <vbhadram@nvidia.com>,
        linux-tegra@vger.kernel.org, netdev@vger.kernel.org
References: <20220923114922.864552-1-thierry.reding@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220923114922.864552-1-thierry.reding@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

+Russell, Andrew, Vladimir,

On 9/23/22 04:49, Thierry Reding wrote:
> From: Bhadram Varka <vbhadram@nvidia.com>
> 
> Add support for the Multi-Gigabit Ethernet (MGBE/XPCS) IP found on
> NVIDIA Tegra234 SoCs.
> 
> Signed-off-by: Bhadram Varka <vbhadram@nvidia.com>
> Signed-off-by: Thierry Reding <treding@nvidia.com>
> ---
>   drivers/net/ethernet/stmicro/stmmac/Kconfig   |   6 +
>   drivers/net/ethernet/stmicro/stmmac/Makefile  |   1 +
>   .../net/ethernet/stmicro/stmmac/dwmac-tegra.c | 290 ++++++++++++++++++

You should be modeling this as a proper PCS driver and have a 
'pcs-handle' property pointing to it in your Device Tree.

The configuration you are doing here is probably working the first time 
you bring-up the network device but I doubt it works across system 
suspend/resume states where power to the GMAC and PCS is lost, it also 
begs the question of which mediums this was tested with and whether 
dynamic switching of speeds and so on is working?
--
Florian
