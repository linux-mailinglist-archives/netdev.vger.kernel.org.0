Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0746438CB49
	for <lists+netdev@lfdr.de>; Fri, 21 May 2021 18:52:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237727AbhEUQxV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 May 2021 12:53:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230471AbhEUQxU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 May 2021 12:53:20 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8410AC061574;
        Fri, 21 May 2021 09:51:57 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id x18so11038338pfi.9;
        Fri, 21 May 2021 09:51:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=fvVKZIh08je3V7R57Yy3qgYSEUd5usbVkYa2j9NtTvI=;
        b=ECakFYMpqdrwjwDhbEDysTwyFEuOK4nvyYfIKeZsuiVs8l2bJc6tkJi8nHWIGmGflx
         CClQfiUpo2+cN1aSF8W/R7TAm0W9GeXSCkkky48O5JGYntoxqiTlczoUS9HN0hx23TsA
         4PA6p0YWQYap4vdXyX8XFPn0WkzFIA2NOOox+c874qL7ChxlPH8THgpMQEVv/K1ylIXM
         BcAIcU4sx5g8fStVeQncfvfBHknPd0OOP51PuUjM6KFc6eoYlRMvX+hzYh0wSc/45cdw
         aCdQJVLeh9sdFSaBPQnRQ1YjhXfX/KPt9gZN/553XKKdGHa1cebBYjffkePI36pA6qkd
         QsbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fvVKZIh08je3V7R57Yy3qgYSEUd5usbVkYa2j9NtTvI=;
        b=RV5aYLlsZBcdTrkrincPUW2KsKvW4nLkjIRNpdG2OdUprXV0oFxTkCyXOiEimjIVzl
         gSflafctA/JxtJLP4BgGH1XXjjBHBw5KragXYIR/CgzKWo/N2Sdl9GoIBOvMfC8pQX9o
         vOzrCzT0c2SHwbPD2x4whGeJG0iQvQmiq2FIbUusPajLUOlU+0i3wENIGRpPOyT9bXBO
         yLwdZ9e56pvLgSWAfq6rRB2iPkZ1BuTUH7fMwXcpeh+3MaHSma/Uj1lofNVFDbor7sBg
         orSPzU0XyU+Pop6qBXY0GZ+5OTylvuiq1CGxT5T49DkhK8yS0bU/VVCdZssCLAmBX+Sq
         qreA==
X-Gm-Message-State: AOAM532CHt3PDkK8FVmLwr5oHdIWpaAm0lxOMxpTUr2xlYAdq9lISPls
        XPFwHcfs5Saf4XOdYmZzqt4=
X-Google-Smtp-Source: ABdhPJzog69dC6PiYJE/OJf2iYLaUtAZO9F2WqIysgASxjem1UQTGQg7xPYvszEfYAuPlJRBb54fXw==
X-Received: by 2002:aa7:8010:0:b029:254:f083:66fa with SMTP id j16-20020aa780100000b0290254f08366famr11332600pfi.17.1621615917028;
        Fri, 21 May 2021 09:51:57 -0700 (PDT)
Received: from [10.230.29.202] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id u7sm3580352pjc.16.2021.05.21.09.51.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 May 2021 09:51:56 -0700 (PDT)
Subject: Re: [PATCH] net: macb: ensure the device is available before
 accessing GEMGXL control registers
To:     Zong Li <zong.li@sifive.com>, nicolas.ferre@microchip.com,
        claudiu.beznea@microchip.com, davem@davemloft.net, kuba@kernel.org,
        palmer@dabbelt.com, paul.walmsley@sifive.com,
        schwab@linux-m68k.org, sboyd@kernel.org, aou@eecs.berkeley.edu,
        mturquette@baylibre.com, geert@linux-m68k.org, yixun.lan@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-riscv@lists.infradead.org
References: <20210521124859.101012-1-zong.li@sifive.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <b4088995-605e-85ca-2f07-47d2654ac2c8@gmail.com>
Date:   Fri, 21 May 2021 09:51:46 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <20210521124859.101012-1-zong.li@sifive.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/21/2021 5:48 AM, Zong Li wrote:
> If runtime power menagement is enabled, the gigabit ethernet PLL would
> be disabled after macb_probe(). During this period of time, the system
> would hang up if we try to access GEMGXL control registers.
> 
> We can't put runtime_pm_get/runtime_pm_put/ there due to the issue of
> sleep inside atomic section (7fa2955ff70ce453 ("sh_eth: Fix sleeping
> function called from invalid context"). Add the similar flag to ensure
> the device is available before accessing GEMGXL device.
> 
> Signed-off-by: Zong Li <zong.li@sifive.com>
> ---
>  drivers/net/ethernet/cadence/macb.h      | 2 ++
>  drivers/net/ethernet/cadence/macb_main.c | 7 +++++++
>  2 files changed, 9 insertions(+)
> 
> diff --git a/drivers/net/ethernet/cadence/macb.h b/drivers/net/ethernet/cadence/macb.h
> index d8d87213697c..acf5242ce715 100644
> --- a/drivers/net/ethernet/cadence/macb.h
> +++ b/drivers/net/ethernet/cadence/macb.h
> @@ -1309,6 +1309,8 @@ struct macb {
>  
>  	u32	rx_intr_mask;
>  
> +	unsigned int is_opened;
> +
>  	struct macb_pm_data pm_data;
>  	const struct macb_usrio_config *usrio;
>  };
> diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
> index 6bc7d41d519b..e079ed10ad91 100644
> --- a/drivers/net/ethernet/cadence/macb_main.c
> +++ b/drivers/net/ethernet/cadence/macb_main.c
> @@ -2781,6 +2781,8 @@ static int macb_open(struct net_device *dev)
>  	if (bp->ptp_info)
>  		bp->ptp_info->ptp_init(dev);
>  
> +	bp->is_opened = 1;
> +
>  	return 0;
>  
>  reset_hw:
> @@ -2818,6 +2820,8 @@ static int macb_close(struct net_device *dev)
>  	if (bp->ptp_info)
>  		bp->ptp_info->ptp_remove(dev);
>  
> +	bp->is_opened = 0;
> +
>  	pm_runtime_put(&bp->pdev->dev);
>  
>  	return 0;
> @@ -2867,6 +2871,9 @@ static struct net_device_stats *gem_get_stats(struct macb *bp)
>  	struct gem_stats *hwstat = &bp->hw_stats.gem;
>  	struct net_device_stats *nstat = &bp->dev->stats;
>  
> +	if (!bp->is_opened)
> +		return nstat;

The canonical way to do this check is to use netif_running(), and not
open code a boolean tracking whether a network device is opened or not.
-- 
Florian
