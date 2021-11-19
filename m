Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F60745779A
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 21:07:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234628AbhKSUKC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 15:10:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234088AbhKSUKB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Nov 2021 15:10:01 -0500
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1CABC061574;
        Fri, 19 Nov 2021 12:06:59 -0800 (PST)
Received: by mail-wm1-x32b.google.com with SMTP id d72-20020a1c1d4b000000b00331140f3dc8so8370331wmd.1;
        Fri, 19 Nov 2021 12:06:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:cc
         :references:from:subject:in-reply-to:content-transfer-encoding;
        bh=QvXKTQ861ywiqjSdt02wc3OHqbWYvjpzaVqgZOfQb8k=;
        b=FshZVx0ToljYtelWaZSfn+GsCl8qLTliREbeMakk4Aq516S4nK7vj3mvKAHpvgd99u
         hO935dFVOi5tJk+TunDncLOXXQbNoQ/drpMvd786ZSQEYgpTU0NGzJlBr7l2kJ6LZUaG
         nbmXdeyn3Bl0A3OV6iCWYWesAxfz4xtZ4YeFvLdLbhgl2lD3296YtVl4yOqlUwRws9lp
         oL4kFO5ZaC3phq32qMGfOyOJDZj+DjAbvWwhWyVQ+J+VOGQTWfeFhAtyDi1KP1iQ9kgQ
         5rXPrKzj55UXWSjjztH46Ce9kwLQWsNxAG29HD7x/0eJOHKVy8Nx4NGSi0OxZVRKes3J
         Necw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:subject:in-reply-to
         :content-transfer-encoding;
        bh=QvXKTQ861ywiqjSdt02wc3OHqbWYvjpzaVqgZOfQb8k=;
        b=lzR0jF73NzoMBJe1Zq3Le3pXrNAZmPZ7t3cZwnjdtLFJDWnLNK1joNxLjVkvZUB2+x
         XYCD2nmkNNq8aqGlX/5hsu15ieDxh78hJwrIarPYd0bRvJCkxJRF/OWvAfLG+OHsorFT
         qUt9nsbLbcbXWF5meN4Tn1cwPY0JE6HZEebM6gEHXs4xSDOmaJNeVnhuFjBuYjQxODBu
         gQGbkJ06RXgEZ2W3VyAejXJqjpvmGAGzM+qSv7FgpaTXfHrLC6bnZXUJlEtzJzn0OpAm
         OmH2e/UtEyCCzAFKEv/CPS/A2K21VShT1NXeuEKBdLO8eVCOe0Q106qwsn61VasVna7b
         /Hxw==
X-Gm-Message-State: AOAM533pXPwiZXumH6JHgvca4M1KkwrP68x7ICoQpknZQyyf7oa54Ttb
        ydOsTTvz4oUKOBbtix53R78=
X-Google-Smtp-Source: ABdhPJy4WyZampDz0Lr3uyntEk8l76ZbL7z28/bb6bSYX/6J2E6VZ2+H87/VqvZJ0yGFjMEnsesIMw==
X-Received: by 2002:a05:600c:1c20:: with SMTP id j32mr2844412wms.1.1637352418151;
        Fri, 19 Nov 2021 12:06:58 -0800 (PST)
Received: from ?IPV6:2003:ea:8f1a:f00:e956:6e6f:f307:5861? (p200300ea8f1a0f00e9566e6ff3075861.dip0.t-ipconnect.de. [2003:ea:8f1a:f00:e956:6e6f:f307:5861])
        by smtp.googlemail.com with ESMTPSA id g6sm877745wmq.36.2021.11.19.12.06.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Nov 2021 12:06:57 -0800 (PST)
Message-ID: <9aedd796-50a1-0fe1-7d1e-43a59fb58b8d@gmail.com>
Date:   Fri, 19 Nov 2021 21:06:51 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Content-Language: en-US
To:     Yeqi Fu <fufuyqqqqqq@gmail.com>, nic_swsd@realtek.com,
        davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20211119184709.19209-1-fufuyqqqqqq@gmail.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH] r8169: Apply configurations to the L0s/L1 entry delay of
 RTL8105e and RTL8401
In-Reply-To: <20211119184709.19209-1-fufuyqqqqqq@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 19.11.2021 19:47, Yeqi Fu wrote:
> We properly configure the L0s/L1 entry delay in the startup functions of
> RTL8105e and RTL8401 through rtl_set_def_aspm_entry_latency(), which will
> avoid local denial of service.
> 

What do you mean with local denial of service? Are you aware of any issues
with these two chip versions?

Where do you got the info from that these calls are appropriate? At least
for RTL8401 even the r8101 vendor driver doesn't do it.

Your patch misses the net vs. net-next annotation. Is this supposed to be
a fix? Then a Fixes tag would be needed.

> Signed-off-by: Yeqi Fu <fufuyqqqqqq@gmail.com>
> ---
>  drivers/net/ethernet/realtek/r8169_main.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
> index bbe21db20417..4f533007a456 100644
> --- a/drivers/net/ethernet/realtek/r8169_main.c
> +++ b/drivers/net/ethernet/realtek/r8169_main.c
> @@ -3420,6 +3420,7 @@ static void rtl_hw_start_8401(struct rtl8169_private *tp)
>  		{ 0x07,	0xffff, 0x8e68 },
>  	};
>  
> +	rtl_set_def_aspm_entry_latency(tp);
>  	rtl_ephy_init(tp, e_info_8401);
>  	RTL_W8(tp, Config3, RTL_R8(tp, Config3) & ~Beacon_en);
>  }
> @@ -3437,6 +3438,7 @@ static void rtl_hw_start_8105e_1(struct rtl8169_private *tp)
>  		{ 0x0a,	0, 0x0020 }
>  	};
>  
> +	rtl_set_def_aspm_entry_latency(tp);
>  	/* Force LAN exit from ASPM if Rx/Tx are not idle */
>  	RTL_W32(tp, FuncEvent, RTL_R32(tp, FuncEvent) | 0x002800);
>  
> 

