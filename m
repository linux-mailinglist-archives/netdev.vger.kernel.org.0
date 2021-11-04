Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DA09445140
	for <lists+netdev@lfdr.de>; Thu,  4 Nov 2021 10:38:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231136AbhKDJkp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Nov 2021 05:40:45 -0400
Received: from mail-wm1-f54.google.com ([209.85.128.54]:37802 "EHLO
        mail-wm1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230335AbhKDJko (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Nov 2021 05:40:44 -0400
Received: by mail-wm1-f54.google.com with SMTP id y84-20020a1c7d57000000b00330cb84834fso6738263wmc.2;
        Thu, 04 Nov 2021 02:38:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=86YdHPoZ6y6Ru6MbsuSkcT1lnyGjcnsjFoTTRMz3JdU=;
        b=15M7upLe7zv2mneGPr0Ia9TyyBz3ebcEfC35BCEisrrFaS1vg6Zgw+H26+I1j4bvC+
         htglYbKQl9IledpYKFvybZWExLNGFqj4pdvb2TgeHiATYJSIJN/oJ2dVN62IWbs69zyj
         q6DEnEtsE1Su0UuxIXv49nul360TnZZu82yJHg8mZd2n+8leVxA10psGbFsvu68ykb92
         DiyeKZrzAsGgKSsgmcjI9wlupz5Gp315dG9PjNxzE37K8isCTmG7pqVfjOFl0sFYN+uu
         MVBEN7tpHOGp0klmwjB1LH8oaU4fGfriZR0xnZkU4yyivt9Acq4xc8WItt3k2qEFNH0h
         W5pg==
X-Gm-Message-State: AOAM5330HyOoGxfTJsp7qb+n91QpxPd/UYC4gtxGMFoFuGKGi8Rfrwuo
        Q5wHzqstrH2F61cuZ6BWAqs=
X-Google-Smtp-Source: ABdhPJyCNtPDsr+MRj6lhzkgTaIqgXRok9kcZ+7HLAcb9VUfiYOpDMbYuuMInuxhkeV3I9jNx9GV/Q==
X-Received: by 2002:a7b:cf10:: with SMTP id l16mr22354509wmg.17.1636018685473;
        Thu, 04 Nov 2021 02:38:05 -0700 (PDT)
Received: from ?IPV6:2a0b:e7c0:0:107::70f? ([2a0b:e7c0:0:107::70f])
        by smtp.gmail.com with ESMTPSA id 8sm7898790wmg.24.2021.11.04.02.38.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Nov 2021 02:38:05 -0700 (PDT)
Message-ID: <0c3acbd4-6ab2-5cc5-6293-54e30093cce2@kernel.org>
Date:   Thu, 4 Nov 2021 10:38:03 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
Subject: Re: [PATCH] ath5k: use swap() to make code cleaner
Content-Language: en-US
To:     davidcomponentone@gmail.com
Cc:     mickflemm@gmail.com, mcgrof@kernel.org, kvalo@codeaurora.org,
        davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yang Guang <yang.guang5@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
References: <20211104062317.1506183-1-yang.guang5@zte.com.cn>
From:   Jiri Slaby <jirislaby@kernel.org>
In-Reply-To: <20211104062317.1506183-1-yang.guang5@zte.com.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 04. 11. 21, 7:23, davidcomponentone@gmail.com wrote:
> From: Yang Guang <yang.guang5@zte.com.cn>
> 
> Use the macro 'swap()' defined in 'include/linux/minmax.h' to avoid
> opencoding it.

Why not just use sort() instead of the double loop?

> Reported-by: Zeal Robot <zealci@zte.com.cn>
> Signed-off-by: Yang Guang <yang.guang5@zte.com.cn>
> ---
>   drivers/net/wireless/ath/ath5k/phy.c | 5 +----
>   1 file changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath5k/phy.c b/drivers/net/wireless/ath/ath5k/phy.c
> index 00f9e347d414..08dc12611f8d 100644
> --- a/drivers/net/wireless/ath/ath5k/phy.c
> +++ b/drivers/net/wireless/ath/ath5k/phy.c
> @@ -1562,16 +1562,13 @@ static s16
>   ath5k_hw_get_median_noise_floor(struct ath5k_hw *ah)
>   {
>   	s16 sort[ATH5K_NF_CAL_HIST_MAX];
> -	s16 tmp;
>   	int i, j;
>   
>   	memcpy(sort, ah->ah_nfcal_hist.nfval, sizeof(sort));
>   	for (i = 0; i < ATH5K_NF_CAL_HIST_MAX - 1; i++) {
>   		for (j = 1; j < ATH5K_NF_CAL_HIST_MAX - i; j++) {
>   			if (sort[j] > sort[j - 1]) {
> -				tmp = sort[j];
> -				sort[j] = sort[j - 1];
> -				sort[j - 1] = tmp;
> +				swap(sort[j], sort[j - 1]);
>   			}
>   		}
>   	}
> 


-- 
js
suse labs
