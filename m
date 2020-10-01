Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFB8227FA97
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 09:48:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731045AbgJAHs2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 03:48:28 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:37384 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725883AbgJAHs2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 03:48:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601538506;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hjO1FA5tim+xqcMl/3Zhd7GVB4ZmNwSB1yl8rDSRlYA=;
        b=A/3BZxq3ul9j+l22KQLmFtMoSqaZ4GPo8WlTz4cTWP33w8Q79TR6tNxKK2aAX3eZcAgnNT
        Y80LKhILQY/j+XHDxqpZk7ohQoiudaxQZJNG9rg7c8YuiNwLtGClMDfkc8d6VaBMH9s8K9
        tAti6qziftwJpDkpzWcEZ1wT8NytKmU=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-139-sfSau9v8O76v5dIaI326Cw-1; Thu, 01 Oct 2020 03:48:24 -0400
X-MC-Unique: sfSau9v8O76v5dIaI326Cw-1
Received: by mail-ej1-f70.google.com with SMTP id rs9so1870321ejb.17
        for <netdev@vger.kernel.org>; Thu, 01 Oct 2020 00:48:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hjO1FA5tim+xqcMl/3Zhd7GVB4ZmNwSB1yl8rDSRlYA=;
        b=P3fG+/qnCWK9H/SdvpJEPUuAybttwP/K0Zw6QXUKRCMLyKFv736TObNA2iInrRL5BX
         kTzLucxsTw2aWR3KBi8L95gFeLVNycV9wRV5Axyl0qgtdy2bU7cbBQ7qu+k5SM1Zgbxx
         LMR9TiTwkeUcATUxzWWAuAv8X43LfAqw7iVTyZ3nCwTiaZ9Ple50bhrxtEM07btiCtwd
         81FnXrvN+l1pN7L3/AaziifML73DyAag6fRr9Lh+QBVtCQRAns2Ejx7B2Gc5eAEw7s7C
         KfdW4WMobWTg5J65AEZpd7eiWpa43fzYk6kFk72J/XHJHn/l4FybkbyX7tbjoRJDFedq
         WFSQ==
X-Gm-Message-State: AOAM5311jj61Inzgpdd3XONF0xR5s8NOD7u+LibxQXZoFLCaEL60k4KT
        mLb6h7FwutGHQkuRcYXcfhnt+pdxAnROm4KSoJjoW9VQRqwbpk9W+inF24imhrVSARMKzR+Cbp3
        lhPYKvYAAezgYpkiN
X-Received: by 2002:a17:906:3913:: with SMTP id f19mr7091255eje.83.1601538503413;
        Thu, 01 Oct 2020 00:48:23 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyp6JE0NkHjz5PUx4BaV+VY5blI34UoWw135nRmAOqyYMSqopgMvdYIRIVKN6zjDe6sn90A6w==
X-Received: by 2002:a17:906:3913:: with SMTP id f19mr7091245eje.83.1601538503214;
        Thu, 01 Oct 2020 00:48:23 -0700 (PDT)
Received: from x1.localdomain (2001-1c00-0c0c-fe00-d2ea-f29d-118b-24dc.cable.dynamic.v6.ziggo.nl. [2001:1c00:c0c:fe00:d2ea:f29d:118b:24dc])
        by smtp.gmail.com with ESMTPSA id u26sm3483307edt.39.2020.10.01.00.48.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Oct 2020 00:48:22 -0700 (PDT)
Subject: Re: [PATCH net] r8169: fix handling ether_clk
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Petr Tesarik <ptesarik@suse.cz>
References: <9893d089-9668-258e-d2de-21a93b0486aa@gmail.com>
From:   Hans de Goede <hdegoede@redhat.com>
Message-ID: <835d1207-0b97-f241-f332-fe49ac70d920@redhat.com>
Date:   Thu, 1 Oct 2020 09:48:20 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <9893d089-9668-258e-d2de-21a93b0486aa@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 10/1/20 8:44 AM, Heiner Kallweit wrote:
> Petr reported that system freezes on r8169 driver load on a system
> using ether_clk. The original change was done under the assumption
> that the clock isn't needed for basic operations like chip register
> access. But obviously that was wrong.
> Therefore effectively revert the original change, and in addition
> leave the clock active when suspending and WoL is enabled. Chip may
> not be able to process incoming packets otherwise.
> 
> Fixes: 9f0b54cd1672 ("r8169: move switching optional clock on/off to pll power functions")
> Reported-by: Petr Tesarik <ptesarik@suse.cz>
> Tested-by: Petr Tesarik <ptesarik@suse.cz>
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Thank you.

Patch looks good to me:

Reviewed-by: Hans de Goede <hdegoede@redhat.com>

Regards,

Hans



> ---
>   drivers/net/ethernet/realtek/r8169_main.c | 32 ++++++++++++++---------
>   1 file changed, 19 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
> index 6c7c004c2..72351c5b0 100644
> --- a/drivers/net/ethernet/realtek/r8169_main.c
> +++ b/drivers/net/ethernet/realtek/r8169_main.c
> @@ -2236,14 +2236,10 @@ static void rtl_pll_power_down(struct rtl8169_private *tp)
>   	default:
>   		break;
>   	}
> -
> -	clk_disable_unprepare(tp->clk);
>   }
>   
>   static void rtl_pll_power_up(struct rtl8169_private *tp)
>   {
> -	clk_prepare_enable(tp->clk);
> -
>   	switch (tp->mac_version) {
>   	case RTL_GIGA_MAC_VER_25 ... RTL_GIGA_MAC_VER_33:
>   	case RTL_GIGA_MAC_VER_37:
> @@ -4820,29 +4816,39 @@ static void rtl8169_net_suspend(struct rtl8169_private *tp)
>   
>   #ifdef CONFIG_PM
>   
> +static int rtl8169_net_resume(struct rtl8169_private *tp)
> +{
> +	rtl_rar_set(tp, tp->dev->dev_addr);
> +
> +	if (tp->TxDescArray)
> +		rtl8169_up(tp);
> +
> +	netif_device_attach(tp->dev);
> +
> +	return 0;
> +}
> +
>   static int __maybe_unused rtl8169_suspend(struct device *device)
>   {
>   	struct rtl8169_private *tp = dev_get_drvdata(device);
>   
>   	rtnl_lock();
>   	rtl8169_net_suspend(tp);
> +	if (!device_may_wakeup(tp_to_dev(tp)))
> +		clk_disable_unprepare(tp->clk);
>   	rtnl_unlock();
>   
>   	return 0;
>   }
>   
> -static int rtl8169_resume(struct device *device)
> +static int __maybe_unused rtl8169_resume(struct device *device)
>   {
>   	struct rtl8169_private *tp = dev_get_drvdata(device);
>   
> -	rtl_rar_set(tp, tp->dev->dev_addr);
> -
> -	if (tp->TxDescArray)
> -		rtl8169_up(tp);
> +	if (!device_may_wakeup(tp_to_dev(tp)))
> +		clk_prepare_enable(tp->clk);
>   
> -	netif_device_attach(tp->dev);
> -
> -	return 0;
> +	return rtl8169_net_resume(tp);
>   }
>   
>   static int rtl8169_runtime_suspend(struct device *device)
> @@ -4868,7 +4874,7 @@ static int rtl8169_runtime_resume(struct device *device)
>   
>   	__rtl8169_set_wol(tp, tp->saved_wolopts);
>   
> -	return rtl8169_resume(device);
> +	return rtl8169_net_resume(tp);
>   }
>   
>   static int rtl8169_runtime_idle(struct device *device)
> 

