Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35833660F64
	for <lists+netdev@lfdr.de>; Sat,  7 Jan 2023 15:17:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232118AbjAGORK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Jan 2023 09:17:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229621AbjAGORJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Jan 2023 09:17:09 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FE7D4859C;
        Sat,  7 Jan 2023 06:17:04 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id v6so5973196edd.6;
        Sat, 07 Jan 2023 06:17:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=OhSst57QklQ/s1OdeaurUei9fLgv+a0PdBl46HD5IBk=;
        b=NgI1bKafS6/mLKXlcaYG5kpsVWLUkxAIjG/1A9d9Ye7uprk5Iq2Lx7FLKKCWk25LEv
         Yf9qR6vV4A7Dmmd0LaEWtfyiJHnPDzAq4m3AQfU/yMiC/Ahq3YyF55QoZ6iVZv3fL5Xa
         CP/KB9oKZGHq1JpqwkSpHqucdZcwaaGzaXBP4rbtqmHeqYuyT6qm2fvuMC+d/b+HMSf5
         5d/G5cunL4EkZX7FOSXDk9Kp65t+ZYkT1/qBIk1lzyR0+GKwrKG7fxBXKwARRz7Pg/OP
         1ixF1ITAIaS3hoEUj2gg+C0lkLXt//7qS8hlti1gFY1j88HYvhQiXD2PF8Ynf7CIRpwg
         yBXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OhSst57QklQ/s1OdeaurUei9fLgv+a0PdBl46HD5IBk=;
        b=1/r4Q/N0IkJShJ1XFkGEzlvsm61gXiOJkl9bdYcHuR+X4ToWLEVqPL+WrXHrYPc0nj
         5UgKrQT90gRrlUTaN7yJDvZEQIWwsGPuRQVRGaFnY4CyoSzrcL98E6w75FB39xh2avmt
         x3WgOWuVaAHwPgl0Phn76d6OPiNZSQ6KW8Q8aYm8xLR0N2t3RLCmAdMQoA5z22S88QJG
         JK6ur78Vs36fFdalOw1mjrc1WOA9aB4d5CgnlRhBbDm5OJiWb1GQWzlnPkbUp8qtON86
         eTac3gGCtjWAHItaQ/EVribwswwwRmwqQrHTlqWWijNnL7IJi0nwZ1kzU6I6FgrSu3dL
         oayg==
X-Gm-Message-State: AFqh2kpVZq1QxzELy4Ibdul+tsNEK6zfB15fIi2jvyTHHUCv7zxqfJaE
        CI7FZydS2sZAzNd7PJ84fZI=
X-Google-Smtp-Source: AMrXdXs2wTwrYKKqPdz2KeIfEoCQ9buukpeu3vsS4/NZi88+rUo94bsuopXCML25Q7KWqI/3992gxQ==
X-Received: by 2002:a05:6402:220b:b0:475:32d2:74a5 with SMTP id cq11-20020a056402220b00b0047532d274a5mr45692428edb.42.1673101022590;
        Sat, 07 Jan 2023 06:17:02 -0800 (PST)
Received: from [192.168.1.50] ([79.119.240.114])
        by smtp.gmail.com with ESMTPSA id v15-20020a056402184f00b0046c5baa1f58sm1490888edy.97.2023.01.07.06.17.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 07 Jan 2023 06:17:01 -0800 (PST)
Message-ID: <18907e6b-93b4-d850-8a17-95ad43501136@gmail.com>
Date:   Sat, 7 Jan 2023 16:17:00 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.3
Subject: Re: [PATCH] wifi: rtl8xxxu: fixing transmisison failure for rtl8192eu
To:     Jun ASAKA <JunASAKA@zzy040330.moe>, Jes.Sorensen@gmail.com
Cc:     kvalo@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20221217030659.12577-1-JunASAKA@zzy040330.moe>
Content-Language: en-US
From:   Bitterblue Smith <rtl8821cerfe2@gmail.com>
In-Reply-To: <20221217030659.12577-1-JunASAKA@zzy040330.moe>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 17/12/2022 05:06, Jun ASAKA wrote:
> Fixing transmission failure which results in
> "authentication with ... timed out". This can be
> fixed by disable the REG_TXPAUSE.
> 
> Signed-off-by: Jun ASAKA <JunASAKA@zzy040330.moe>
> ---
>  drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c
> index a7d76693c02d..9d0ed6760cb6 100644
> --- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c
> +++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c
> @@ -1744,6 +1744,11 @@ static void rtl8192e_enable_rf(struct rtl8xxxu_priv *priv)
>  	val8 = rtl8xxxu_read8(priv, REG_PAD_CTRL1);
>  	val8 &= ~BIT(0);
>  	rtl8xxxu_write8(priv, REG_PAD_CTRL1, val8);
> +
> +	/*
> +	 * Fix transmission failure of rtl8192e.
> +	 */
> +	rtl8xxxu_write8(priv, REG_TXPAUSE, 0x00);
>  }
>  
>  static s8 rtl8192e_cck_rssi(struct rtl8xxxu_priv *priv, u8 cck_agc_rpt)

By the way, you should get this into the stable kernels too:
https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
