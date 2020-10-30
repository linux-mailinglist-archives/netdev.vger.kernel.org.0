Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1D4D2A10F6
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 23:37:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725929AbgJ3Wh4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 18:37:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725816AbgJ3Wh4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Oct 2020 18:37:56 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2672AC0613D5;
        Fri, 30 Oct 2020 15:37:56 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id gr24so1859348ejb.9;
        Fri, 30 Oct 2020 15:37:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=OUVs8tSdK5o6SJ/sOq9QJbY7iS/xvDNCvYPmxr6Xxhs=;
        b=dMpc4fpaefgMxiDk4U4Sf0cPXwe/wSmds5xsbgPuija0lD3uvN24ArF8AdkNfqAUu+
         w7loHhX1Y2nFVbEgLrnKErHzbj62QCkrMrZB7GHrfEoGYYMapswme4RCz0jLqOctrMfG
         l8YmyWG7sqct6HAKz4gA/j8gDXHMx1OHr4H/6Vt/y7BEVACaZUjrWZayPh0ql0C4qSPI
         uBmRPYNTIWJqQ/C7bB4KTplskLIe/PFq4EW1dbyPYCrk8ba27v1HAxQqCbbmaJz78Evz
         D7aYlddDGBryKFMMpqcDi5/ZNEIMC7PwvgR2c0VthKtSMjoS+x/ggU3vTjWfxNgYZ6+C
         7lvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=OUVs8tSdK5o6SJ/sOq9QJbY7iS/xvDNCvYPmxr6Xxhs=;
        b=Tgo61AF39cCnomWO0YeI3eRWqcMxi5LU+mUj6b9x6OhMMgTju/BFnuCawoFsGo3Igg
         25f8F2qiNjpDW+8iInMeXaebOEXxzJtxz0/X4Nz60jwRVN3FH3HACYj39rs+n+GkT2Rh
         9HV51RR3PpwJdGKcSY/p5AYvfOnrOVG3oiNk1Kbh65OB/qfmTHCUIHnpsjgow538c79k
         uHSXhKXd3eUKdSxQ1MxXTGzBAeNKVsohX21plq12YDk0urLjFhPqqw6FY9cZ3DtdXBAB
         y9bPUfEedarDfm+XvqIVig7iAtuMpFVc6zxog/jXDklrB8qz/dySSH7cNzrgWpO1pcRD
         Td+w==
X-Gm-Message-State: AOAM533MLa3b79uU+S09Im204o5858y8CJzbrAUqtXHJDWQV3gvPayRv
        MgyqjOHFbFJfxGjrqFj92bU=
X-Google-Smtp-Source: ABdhPJwIpL3m9+J/FKfJ8S23qf73ozAUtWGIiRjRugnd7ZLtzyKtFdeWKNZWdoY58K7mNizWZiSsng==
X-Received: by 2002:a17:906:370e:: with SMTP id d14mr4981038ejc.259.1604097474812;
        Fri, 30 Oct 2020 15:37:54 -0700 (PDT)
Received: from ?IPv6:2a01:110f:b59:fd00:28e3:24bf:72a1:43e4? ([2a01:110f:b59:fd00:28e3:24bf:72a1:43e4])
        by smtp.gmail.com with ESMTPSA id g14sm1367351ejr.26.2020.10.30.15.37.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 Oct 2020 15:37:54 -0700 (PDT)
Subject: Re: [PATCH RFC leds + net-next 2/7] leds: trigger: netdev: simplify
 the driver by using bit field members
To:     =?UTF-8?Q?Marek_Beh=c3=ban?= <kabel@kernel.org>,
        netdev@vger.kernel.org
Cc:     linux-leds@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
        Dan Murphy <dmurphy@ti.com>,
        Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ben Whitten <ben.whitten@gmail.com>
References: <20201030114435.20169-1-kabel@kernel.org>
 <20201030114435.20169-3-kabel@kernel.org>
From:   Jacek Anaszewski <jacek.anaszewski@gmail.com>
Message-ID: <64419e33-ffcd-4082-01bd-3370dae86b4b@gmail.com>
Date:   Fri, 30 Oct 2020 23:37:52 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201030114435.20169-3-kabel@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marek,

Bitops are guaranteed to be atomic and this was done for a reason.

On 10/30/20 12:44 PM, Marek Behún wrote:
> Use bit fields members in struct led_netdev_data instead of one mode
> member and set_bit/clear_bit/test_bit functions. These functions are
> suitable for longer or variable length bit arrays.
> 
> Signed-off-by: Marek Behún <kabel@kernel.org>
> ---
>   drivers/leds/trigger/ledtrig-netdev.c | 69 ++++++++++++---------------
>   1 file changed, 30 insertions(+), 39 deletions(-)
> 
> diff --git a/drivers/leds/trigger/ledtrig-netdev.c b/drivers/leds/trigger/ledtrig-netdev.c
> index 4f6b73e3b491..8f013b6df4fa 100644
> --- a/drivers/leds/trigger/ledtrig-netdev.c
> +++ b/drivers/leds/trigger/ledtrig-netdev.c
> @@ -49,11 +49,11 @@ struct led_netdev_data {
>   	atomic_t interval;
>   	unsigned int last_activity;
>   
> -	unsigned long mode;
> -#define NETDEV_LED_LINK	0
> -#define NETDEV_LED_TX	1
> -#define NETDEV_LED_RX	2
> -#define NETDEV_LED_MODE_LINKUP	3
> +	unsigned link:1;
> +	unsigned tx:1;
> +	unsigned rx:1;
> +
> +	unsigned linkup:1;
>   };
>   
>   enum netdev_led_attr {
> @@ -73,10 +73,10 @@ static void set_baseline_state(struct led_netdev_data *trigger_data)
>   	if (!led_cdev->blink_brightness)
>   		led_cdev->blink_brightness = led_cdev->max_brightness;
>   
> -	if (!test_bit(NETDEV_LED_MODE_LINKUP, &trigger_data->mode))
> +	if (!trigger_data->linkup)
>   		led_set_brightness(led_cdev, LED_OFF);
[...]

-- 
Best regards,
Jacek Anaszewski
