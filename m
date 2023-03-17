Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92AB26BEF26
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 18:06:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229590AbjCQRGD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 13:06:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230015AbjCQRFp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 13:05:45 -0400
Received: from mail-qt1-x82d.google.com (mail-qt1-x82d.google.com [IPv6:2607:f8b0:4864:20::82d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66ABD3BC4A
        for <netdev@vger.kernel.org>; Fri, 17 Mar 2023 10:05:23 -0700 (PDT)
Received: by mail-qt1-x82d.google.com with SMTP id fy17so3736131qtb.2
        for <netdev@vger.kernel.org>; Fri, 17 Mar 2023 10:05:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679072722;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Ou1R36eX7BF+ROXUMXejBOAQ8ixZVHxgeBHVkoCC9W4=;
        b=og3kT2uhpfbnPK9iqyrbbd0AWJqNAUhmr83qndDd1wH7oms2nxlla+7/Lc7Ci0y5/W
         JSN87ewU7M8H3Q9dTgsl5ng01WOJfNlVLrsMZPiGyllahMRtApazS/q4FKuEH7cHd+om
         pYEwvmiv/uBhWC6hGk+w2rXhIsS/fWeLCA37d0TIhAiKfE9fuDMiseX2lvnKRom0H+tN
         t1jY1BjDXTY7Vsst38aHIePXzDm1bUqN4K6HUgZO8I0mlD4wR9DwScGUPsSQ87cln//d
         jDMUDxrmQWAZ2Gd//fgNwg3Gz7EisrzAz0DEmpU9SmRGtyAAFoU+F4eQZBvdkS3iPmG5
         W6kQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679072722;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ou1R36eX7BF+ROXUMXejBOAQ8ixZVHxgeBHVkoCC9W4=;
        b=3w+rMNDvGCeK3W7xCE3vF3RtqPH+nWPJE18z7uOlHNosjc1/SDQPLeXuBmESM83lsm
         EDh+p3VVOKj3P8db+YStRwEVBN1reiiHiAe+tt2+NXDqIbOZK2wobsWYcI5jA8d4pZko
         vY0xmSAMMTFM5JDd6+IbYnV/amB0ymJzbbSwBgHYwXUN8PfTjYaeWeLSEn9KkSeiFRpN
         TPBliDsnXKyqb4IvEdRWdvQBeql8OWe0dAS1LPT4oa9U1TB2ypAV1Jcqsq9pI1aqNZ7+
         MYpg4wJsAK+/OtGIabowjHk5OtuYsUHh05KYkNqvewqWOxd5V9BYGwtDDAL+i2maU0ZT
         lJig==
X-Gm-Message-State: AO0yUKV5CciFtZATeSV1/1tNLN/JlZGMRUrRbxm7ozr6qXbVjEP2durp
        eQWjSr3qwmq5SQ2O/V8h5W8=
X-Google-Smtp-Source: AK7set9oxppV74ngcy7QcfsWnnDosQvbOENxPc3mIslqBtP2cmqDZXMiWw8JT6l1N8Jbt4zwzcylTA==
X-Received: by 2002:ac8:5e0c:0:b0:3d2:a192:3d93 with SMTP id h12-20020ac85e0c000000b003d2a1923d93mr14180909qtx.8.1679072722531;
        Fri, 17 Mar 2023 10:05:22 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id 188-20020a3704c5000000b00745ca1c0eb6sm2041828qke.2.2023.03.17.10.05.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Mar 2023 10:05:21 -0700 (PDT)
Message-ID: <a1dc47d6-fe07-2b13-ae53-ec6ea949333a@gmail.com>
Date:   Fri, 17 Mar 2023 10:05:14 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH] net: phy: return EPROBE_DEFER if PHY is not accessible
Content-Language: en-US
To:     arturo.buzarra@digi.com, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>
References: <20230317121646.19616-1-arturo.buzarra@digi.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230317121646.19616-1-arturo.buzarra@digi.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

+Andrew, Heiner, Vladimir and Russell,

(please always copy the maintainers of the piece of code you are modifying).

On 3/17/23 05:16, arturo.buzarra@digi.com wrote:
> From: Arturo Buzarra <arturo.buzarra@digi.com>
> 
> A PHY driver can dynamically determine the devices features, but in some
> circunstances, the PHY is not yet ready and the read capabilities does not fail
> but returns an undefined value, so incorrect capabilities are assumed and the
> initialization process fails. This commit postpones the PHY probe to ensure the
> PHY is accessible.

We need more specifics here, what type of PHY device are you seeing this 
with? Keying off all 0s or all 1s is problematic because while it could 
signal that the PHY is not ready in your particular case, it could also 
mean that you have an electrical issue whereby the MDIO data line is 
pulled down, respectively high too hard. In that case, we would rather 
error out earlier than later, because no amount of probe deferral will 
solve that.

If your PHY requires "some time" before it can be ready you have a 
number of ways to achieve that:

- implement phy_driver::probe which may load firmware, initialize 
internal state, etc.

- implement a phy_driver::get_features

Using deferred reads until MII_BMSR contains what you want is unlikely 
to be the recommended way by your vendor to ensure the PHY is ready. 
There has got to be some sort of vendor specific register that can be 
polled to indicate readiness.


> 
> Signed-off-by: Arturo Buzarra <arturo.buzarra@digi.com>
> ---
>   drivers/net/phy/phy_device.c | 4 ++++
>   1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
> index 1785f1cead97..f8c31e741936 100644
> --- a/drivers/net/phy/phy_device.c
> +++ b/drivers/net/phy/phy_device.c
> @@ -2628,10 +2628,14 @@ int genphy_read_abilities(struct phy_device *phydev)
>   			       phydev->supported);
>   
>   	val = phy_read(phydev, MII_BMSR);
>   	if (val < 0)
>   		return val;
> +	if (val == 0x0000 || val == 0xffff) {
> +		phydev_err(phydev, "PHY is not accessible\n");
> +		return -EPROBE_DEFER;
> +	}



>   
>   	linkmode_mod_bit(ETHTOOL_LINK_MODE_Autoneg_BIT, phydev->supported,
>   			 val & BMSR_ANEGCAPABLE);
>   
>   	linkmode_mod_bit(ETHTOOL_LINK_MODE_100baseT_Full_BIT, phydev->supported,

-- 
Florian

