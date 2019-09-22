Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C311BA38D
	for <lists+netdev@lfdr.de>; Sun, 22 Sep 2019 19:58:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388344AbfIVR65 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Sep 2019 13:58:57 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:37476 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387966AbfIVR65 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Sep 2019 13:58:57 -0400
Received: by mail-pg1-f196.google.com with SMTP id c17so6570925pgg.4
        for <netdev@vger.kernel.org>; Sun, 22 Sep 2019 10:58:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=gbu3DPEx0NeFVSv+o+6DUU3JENbLRblMvCqw6eTsDoM=;
        b=btB+5wX0dptljA9fGVULahy1pEXxt2laFomGZ0tvgIjti8a+lEXzlF3IjgDhESh8ge
         oQvhgSBg1I1Nqcjo5BA1hlZWxaBkq0x5JTuKAIHs0QL5J+RVJbyCzEgSEipiy7uPTxez
         IOx/AVM6aZsdxQPIwJpdLkjZn9OXG0FGbgtBj3C++fHwDIC94NUvCOrlojw/kcQ18qC+
         +RNAdfvOpV4HB32usHxPmiaS/kIvS6ZrdR7OuIrFMSlbAdnlPsNDqaoYqiIu3wljOLcD
         uyQBaRCymxtMjgapqWru+u85DdVX7wgJeRQgVrt+4hvj7rpNk502yeJIh4xWrahksFlo
         ocjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gbu3DPEx0NeFVSv+o+6DUU3JENbLRblMvCqw6eTsDoM=;
        b=C0XAITwrp2TkFZcrcwcrm2mTpfHhlgj/3h7bjLe/5KHaNwZvfrGPIhvHZDJ20YtOq9
         ZDdKvZ07E7XnbqLjrC2myvDe6xiLeXUbUSxeYpkWTSzQ4iOevQTQGpzZ5jwmX7uGrRWM
         Z0cKNUCrrr95+0Z6gEIWj6xY/u4c24Zp5cFBdRGgWkTY3VD0p2kw4XuJFtUYsSA4QMnX
         V9mGnQAZsThRIidzYsyq8Vm3lno2rTPjnpM1k5ocG93cIf3p5mkILZ++7JaOa7sKYKh7
         WiYp90VBZZQF5m9Lnhunl62Nlmm8YTzfCXo3ZJSEEgEnvuzs8n0m9FRsIxPEeCofince
         tmPQ==
X-Gm-Message-State: APjAAAVhDuhKrlClxKMUlOa7mSPNA7zjf3zQdzQrJbloWgaCpjmAtN9J
        bCZQPXrtGVHB3gYBuCHBbKY=
X-Google-Smtp-Source: APXvYqwFNu/Gl0qYXZZnjtAWkfEomUHCJQI0si2eE9EOWJ/zfu1pmoSpgBfUeHVDnH3013AGE6YL3A==
X-Received: by 2002:aa7:8c07:: with SMTP id c7mr29930650pfd.158.1569175136815;
        Sun, 22 Sep 2019 10:58:56 -0700 (PDT)
Received: from [10.230.28.130] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id k127sm20165488pga.54.2019.09.22.10.58.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 22 Sep 2019 10:58:56 -0700 (PDT)
Subject: Re: [PATCH] net: dsa: microchip: Always set regmap stride to 1
To:     Marek Vasut <marex@denx.de>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        George McCollister <george.mccollister@gmail.com>,
        Tristram Ha <Tristram.Ha@microchip.com>,
        Vivien Didelot <vivien.didelot@savoirfairelinux.com>,
        Woojung Huh <woojung.huh@microchip.com>
References: <20190921175309.2195-1-marex@denx.de>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <0250f01c-f536-8d15-8da0-0318ac8aecc9@gmail.com>
Date:   Sun, 22 Sep 2019 10:58:54 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.0
MIME-Version: 1.0
In-Reply-To: <20190921175309.2195-1-marex@denx.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/21/2019 10:53 AM, Marek Vasut wrote:
> The regmap stride is set to 1 for regmap describing 8bit registers already.
> However, for 16/32/64bit registers, the stride is 2/4/8 respectively. This
> is not correct, as the switch protocol supports unaligned register reads
> and writes and the KSZ87xx even uses such unaligned register accesses to
> read e.g. MIB counter.
> 
> This patch fixes MIB counter access on KSZ87xx.

Should that be having the following Fixes tag(s):

Fixes: 46558d601cb6 ("net: dsa: microchip: Initial SPI regmap support")

and where relevant:

Fixes: 255b59ad0db2 ("net: dsa: microchip: Factor out regmap config
generation into common header")


> 
> Signed-off-by: Marek Vasut <marex@denx.de>
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Florian Fainelli <f.fainelli@gmail.com>
> Cc: George McCollister <george.mccollister@gmail.com>
> Cc: Tristram Ha <Tristram.Ha@microchip.com>
> Cc: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
> Cc: Woojung Huh <woojung.huh@microchip.com>
> ---
>  drivers/net/dsa/microchip/ksz_common.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
> index a24d8e61fbe7..dd60d0837fc6 100644
> --- a/drivers/net/dsa/microchip/ksz_common.h
> +++ b/drivers/net/dsa/microchip/ksz_common.h
> @@ -303,7 +303,7 @@ static inline void ksz_pwrite32(struct ksz_device *dev, int port, int offset,
>  	{								\
>  		.name = #width,						\
>  		.val_bits = (width),					\
> -		.reg_stride = (width) / 8,				\
> +		.reg_stride = 1,					\
>  		.reg_bits = (regbits) + (regalign),			\
>  		.pad_bits = (regpad),					\
>  		.max_register = BIT(regbits) - 1,			\
> 

-- 
Florian
