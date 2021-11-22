Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A10454594D1
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 19:38:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240376AbhKVSmB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 13:42:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235182AbhKVSl4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Nov 2021 13:41:56 -0500
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com [IPv6:2607:f8b0:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8F65C061574;
        Mon, 22 Nov 2021 10:38:49 -0800 (PST)
Received: by mail-ot1-x333.google.com with SMTP id h16-20020a9d7990000000b0055c7ae44dd2so30098740otm.10;
        Mon, 22 Nov 2021 10:38:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=UHFB4okDolhXrN2KtXNKGXY4xx9A6ENlJZJpcpYJSa4=;
        b=iF32sjGrzSvaDDiDrzm4Jn8+gNbGxPrbBxZFxi4uCknK7CkuUHGcqoOD65h4RyWxyF
         y+wOmbGDPKkCG8jIqPGxKaFK0D3GvGCi7E7vj/rSSTElZKQ4I+sO6sAsXlhvWm4LJdnp
         2KvDVCusXICAOU/8p8E70quXduhRoLziMS5wtCLJdF0xE54KuxD1Hx/LXZJoPAM3DNL1
         BkvRF4pmS6od3lYRUbwlZMx97PcjFnI9HdmkEczPsl3ta8bzsAye+LybTN6gfUn7gNW8
         MLS92ARh+GguAjdL9uq+LetI8B96GaD9Vc3Ip4BN7Uy3BSXQIu3jgX7O1p5U0Obaav48
         V51g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=UHFB4okDolhXrN2KtXNKGXY4xx9A6ENlJZJpcpYJSa4=;
        b=wI6BKtLTjV71b36AuQa7eqeNpGoXyn1KTwsO+7skapVw+pmDbPKZmEh5H0sXecgQnt
         yzJKt3KdhxBEAKbKcI8rSlhhEm/A4oZHuvvRZaObwtKQzlgvzMPHfGguy9imT/JcpjPs
         I6XIlPCY8ETNjuOdWot9trq43v/2ZY4ki8uYzXC+qzEIgRO0AFRzV9hHjtkPA78ksFXK
         futpmcQkacgTtsGbQt1gOephKyFO0eOGBW2j8cC8cild9soZ8YMcmBNn4Zk3rn1SOaxP
         uPb25fsRYJ9hB3FsWqlRBxnxq6tUXiZRFaIAozbkbuoe0thxa6DODfQT+PD3xGAzWfQp
         V3fw==
X-Gm-Message-State: AOAM532lDdsUO3aNW37ss9kreDysmNYReVetgXnabQmUDkyYTfjx1cCb
        yq2KAvvSNAzYtPgE/p1uNDk=
X-Google-Smtp-Source: ABdhPJwfr5gWpFAYZtUOP0l+WeTUOCLuMHjoxvBl19lgRYsYRNjGQbRkBWj0P0bUDebnG/bzTCmu0Q==
X-Received: by 2002:a9d:5190:: with SMTP id y16mr27309322otg.364.1637606329228;
        Mon, 22 Nov 2021 10:38:49 -0800 (PST)
Received: from [10.62.118.101] (cpe-24-31-246-181.kc.res.rr.com. [24.31.246.181])
        by smtp.gmail.com with ESMTPSA id f18sm1729016otl.28.2021.11.22.10.38.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Nov 2021 10:38:48 -0800 (PST)
Sender: Larry Finger <larry.finger@gmail.com>
Message-ID: <a18f44bf-e590-0ebe-00c0-5658f3a51d86@lwfinger.net>
Date:   Mon, 22 Nov 2021 12:38:41 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH/RFC 17/17] rtw89: Use bitfield helpers
Content-Language: en-US
To:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@armlinux.org.uk>,
        Rajendra Nayak <rnayak@codeaurora.org>,
        Paul Walmsley <paul@pwsan.com>,
        Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Ludovic Desroches <ludovic.desroches@microchip.com>,
        Tero Kristo <kristo@kernel.org>,
        Jonathan Cameron <jic23@kernel.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>,
        Benoit Parrot <bparrot@ti.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Andrew Jeffery <andrew@aj.id.au>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Joel Stanley <joel@jms.id.au>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        Eduardo Valentin <edubezval@gmail.com>,
        Keerthy <j-keerthy@ti.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Amit Kucheria <amitk@kernel.org>,
        Zhang Rui <rui.zhang@intel.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>
Cc:     linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-clk@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-media@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-aspeed@lists.ozlabs.org, openbmc@lists.ozlabs.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-gpio@vger.kernel.org, linux-pm@vger.kernel.org,
        alsa-devel@alsa-project.org
References: <cover.1637592133.git.geert+renesas@glider.be>
 <f7b81122f7596fa004188bfae68f25a68c2d2392.1637592133.git.geert+renesas@glider.be>
From:   Larry Finger <Larry.Finger@lwfinger.net>
In-Reply-To: <f7b81122f7596fa004188bfae68f25a68c2d2392.1637592133.git.geert+renesas@glider.be>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/22/21 09:54, Geert Uytterhoeven wrote:
> Use the field_{get,prep}() helpers, instead of open-coding the same
> operations.
> 
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> ---
> Compile-tested only.
> Marked RFC, as this depends on [PATCH 01/17], but follows a different
> path to upstream.
> ---
>   drivers/net/wireless/realtek/rtw89/core.h | 38 ++++-------------------
>   1 file changed, 6 insertions(+), 32 deletions(-)

Tested-by: Larry Finger <Larry,Finger@lwfinger.net>

Larry

> 
> diff --git a/drivers/net/wireless/realtek/rtw89/core.h b/drivers/net/wireless/realtek/rtw89/core.h
> index c2885e4dd882f045..f9c0300ec373aaf2 100644
> --- a/drivers/net/wireless/realtek/rtw89/core.h
> +++ b/drivers/net/wireless/realtek/rtw89/core.h
> @@ -2994,81 +2994,55 @@ rtw89_write32_clr(struct rtw89_dev *rtwdev, u32 addr, u32 bit)
>   static inline u32
>   rtw89_read32_mask(struct rtw89_dev *rtwdev, u32 addr, u32 mask)
>   {
> -	u32 shift = __ffs(mask);
> -	u32 orig;
> -	u32 ret;
> -
> -	orig = rtw89_read32(rtwdev, addr);
> -	ret = (orig & mask) >> shift;
> -
> -	return ret;
> +	return field_get(mask, rtw89_read32(rtwdev, addr));
>   }
>   
>   static inline u16
>   rtw89_read16_mask(struct rtw89_dev *rtwdev, u32 addr, u32 mask)
>   {
> -	u32 shift = __ffs(mask);
> -	u32 orig;
> -	u32 ret;
> -
> -	orig = rtw89_read16(rtwdev, addr);
> -	ret = (orig & mask) >> shift;
> -
> -	return ret;
> +	return field_get(mask, rtw89_read16(rtwdev, addr));
>   }
>   
>   static inline u8
>   rtw89_read8_mask(struct rtw89_dev *rtwdev, u32 addr, u32 mask)
>   {
> -	u32 shift = __ffs(mask);
> -	u32 orig;
> -	u32 ret;
> -
> -	orig = rtw89_read8(rtwdev, addr);
> -	ret = (orig & mask) >> shift;
> -
> -	return ret;
> +	return field_get(mask, rtw89_read8(rtwdev, addr));
>   }
>   
>   static inline void
>   rtw89_write32_mask(struct rtw89_dev *rtwdev, u32 addr, u32 mask, u32 data)
>   {
> -	u32 shift = __ffs(mask);
>   	u32 orig;
>   	u32 set;
>   
>   	WARN(addr & 0x3, "should be 4-byte aligned, addr = 0x%08x\n", addr);
>   
>   	orig = rtw89_read32(rtwdev, addr);
> -	set = (orig & ~mask) | ((data << shift) & mask);
> +	set = (orig & ~mask) | field_prep(mask, data);
>   	rtw89_write32(rtwdev, addr, set);
>   }
>   
>   static inline void
>   rtw89_write16_mask(struct rtw89_dev *rtwdev, u32 addr, u32 mask, u16 data)
>   {
> -	u32 shift;
>   	u16 orig, set;
>   
>   	mask &= 0xffff;
> -	shift = __ffs(mask);
>   
>   	orig = rtw89_read16(rtwdev, addr);
> -	set = (orig & ~mask) | ((data << shift) & mask);
> +	set = (orig & ~mask) | field_prep(mask, data);
>   	rtw89_write16(rtwdev, addr, set);
>   }
>   
>   static inline void
>   rtw89_write8_mask(struct rtw89_dev *rtwdev, u32 addr, u32 mask, u8 data)
>   {
> -	u32 shift;
>   	u8 orig, set;
>   
>   	mask &= 0xff;
> -	shift = __ffs(mask);
>   
>   	orig = rtw89_read8(rtwdev, addr);
> -	set = (orig & ~mask) | ((data << shift) & mask);
> +	set = (orig & ~mask) | field_prep(mask, data);
>   	rtw89_write8(rtwdev, addr, set);
>   }
>   
> 

