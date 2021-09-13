Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37B1D4099FA
	for <lists+netdev@lfdr.de>; Mon, 13 Sep 2021 18:51:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240187AbhIMQww (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 12:52:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239698AbhIMQwv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Sep 2021 12:52:51 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A745CC061762;
        Mon, 13 Sep 2021 09:51:35 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id w19so5025058pfn.12;
        Mon, 13 Sep 2021 09:51:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=kuABR48uUUXNiZompaszC47KST4UqyEqD5vKZv7sGis=;
        b=ncpvpEmFtmubH+lclgjmMMEMJU6nH4pbD8aM5zHsG+FSC4yd8KGtff43Ku5nI5qJ2O
         q7Y2Z5/5SmsKAzpxcm24Yepv5gpc+AkmIX/v4/PlCxNAsMRzfcU7saJkLZRd+lB/vFgZ
         +EUIxqSQSlqAh/aRkojoCWlq4ZXgAELDDOEbhBvxwHq+dXYAtFHEbkSCX4ZlSk2BJ4QI
         P5gmeJWLQ4WxwK3SNYoWeH3slNo0jn+HxC7tvoDMrDLeNab3UBrFdLLqqwwMCzfn7SRF
         GhIkil0aZT0DdZv3YXcA1bbc4rVsPX5NZtOYhReACGHowtcXaKX4LTNoGyiYsA7OHJwJ
         +85Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=kuABR48uUUXNiZompaszC47KST4UqyEqD5vKZv7sGis=;
        b=2bZ25EMkCjA3mwviRxXSW/OXGxtaj+rEZTiM0tpQi9sCS0/hgAoH32ZyvY703kyR8M
         AhbhSmPS9qOE7sBvYUwr+Tb0f1Of1WFKBMI7jdAp5PGdxjdMksq7nVcV42aczUYmvWGx
         3hFEjY8Jate0Ipvo0nAmfoNAcbmTSOowvGxBOuRYyjUREZTLTV9JF4VEATEgCPP8g0Cm
         KJADi+8cGvfK/yItwQ0Vp++Q1qJ/wSxqvYV0y3CEOgE4MyqVjocHn8lUD29wmdYia+08
         2wNDY07u1yAu9MjxVv/073hbSBRxk+AbLYQ3vuSWVoxUcZ8Y3hopAwwv9PV12JdGS8/n
         7sOA==
X-Gm-Message-State: AOAM532tpHdOs72DjCWniRnkw0MRAo1aJZnPVC8aafWvgATJwA+3pNvL
        cF0fwg/SQzhwZrgLdeKdtGs=
X-Google-Smtp-Source: ABdhPJy/qbesBC9mVbtT6RFEVPP5MgkwZFbvpeS0mQMfbsAjKfpFnvRq2dO50NwxbLmfTJZyD26Lug==
X-Received: by 2002:a63:ed4a:: with SMTP id m10mr12108087pgk.448.1631551895199;
        Mon, 13 Sep 2021 09:51:35 -0700 (PDT)
Received: from [192.168.1.121] (99-44-17-11.lightspeed.irvnca.sbcglobal.net. [99.44.17.11])
        by smtp.gmail.com with ESMTPSA id g3sm7623652pfi.197.2021.09.13.09.51.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Sep 2021 09:51:34 -0700 (PDT)
Message-ID: <4ebab581-897e-e95b-c28f-8dc9f3bc17f5@gmail.com>
Date:   Mon, 13 Sep 2021 09:51:31 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [RFC PATCH net 5/5] net: dsa: xrs700x: be compatible with masters
 which unregister on shutdown
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        George McCollister <george.mccollister@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>
References: <20210912120932.993440-1-vladimir.oltean@nxp.com>
 <20210912120932.993440-6-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20210912120932.993440-6-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/12/2021 5:09 AM, Vladimir Oltean wrote:
> Since commit 2f1e8ea726e9 ("net: dsa: link interfaces with the DSA
> master to get rid of lockdep warnings"), DSA gained a requirement which
> it did not fulfill, which is to unlink itself from the DSA master at
> shutdown time.
> 
> Since the Arrow SpeedChips XRS700x driver was introduced after the bad
> commit, it has never worked with DSA masters which decide to unregister
> their net_device on shutdown, effectively hanging the reboot process.
> To fix that, we need to call dsa_switch_shutdown.
> 
> These devices can be connected by I2C or by MDIO, and if I search for
> I2C or MDIO bus drivers that implement their ->shutdown by redirecting
> it to ->remove I don't see any, however this does not mean it would not
> be possible. To be compatible with that pattern, it is necessary to
> implement an "if this then not that" scheme, to avoid ->remove and
> ->shutdown from being called both for the same struct device.
> 
> Fixes: ee00b24f32eb ("net: dsa: add Arrow SpeedChips XRS700x driver")
> Link: https://lore.kernel.org/netdev/20210909095324.12978-1-LinoSanfilippo@gmx.de/
> Reported-by: Lino Sanfilippo <LinoSanfilippo@gmx.de>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
