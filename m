Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15B7227075A
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 22:48:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726476AbgIRUr7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 16:47:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726154AbgIRUr6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 16:47:58 -0400
Received: from mail-oi1-x244.google.com (mail-oi1-x244.google.com [IPv6:2607:f8b0:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86270C0613CE;
        Fri, 18 Sep 2020 13:47:58 -0700 (PDT)
Received: by mail-oi1-x244.google.com with SMTP id v20so8602285oiv.3;
        Fri, 18 Sep 2020 13:47:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=QuS7zvosncddlCOfGTkwVqUYuL8rUA4H88/9PFOsvFE=;
        b=rJICutNbgeIyEFdxYfNRNT0KZiaUoaX/jxpRIiwGcE4weCVuoiAIgrdeV4sgNNju5u
         HDDda9Jlil0eISamLoStJYFSQ0PUp5Kh8UkyDn0e/Amw9hRUgNvUP2nH62zCffPMhcCp
         NuD6sll65gFGEJcnSWEq5KooXY+UPAiBZWJk/t8YqvZXGfgM7YNWP/mAagDy8uEW12xS
         MCGO32oMx6FVuDgrwJJx6pPBcUQDFjbLLmdc/SE779lb8KWEEG8YwkYHVN4MZS0RCumY
         HkQuE5+qn8CRojGg0bq2F38fD6aV6o3/B9PdigPb9wN+5ZY5/LEJNmFj+aLeoLtUm1kH
         tydg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QuS7zvosncddlCOfGTkwVqUYuL8rUA4H88/9PFOsvFE=;
        b=sc6w3/JX+ryNbEiJSbkMEUDVHQMJ3gTELxaoE+SYgOvCgl470amQVF04C/i84B6ywY
         s4MUhQBZAHteNVJ42bHv7Pj8OkgyorPAe57k76Ku6w7DucOwYC4X0xraCfBiDaCt+UP5
         Y3J2navOOu5tZOpAEbscIZaBI/ApI3zrkxz4Pq8LoHrSaD90nEI6GDoWgBe3ya0g5FHm
         Cp/0NQ6xxZBc/trIWdHx9Vgh4g5CLLXFGtV5EiRrCU4MQa6HgZTu761M1v0xT9KrEUpp
         xhHpwJpaQyMjLqCxYp3MfQKuMqg3iBAIkre5EaD4b+HegRb8ciTzsOWuZvm7ajb9V+6R
         NTcg==
X-Gm-Message-State: AOAM530+/4d3IJ333Ce0C2mbMFHJ0Y0CHgWFA5jRvuPoKQ8+1cHq5Aco
        wTiIlNt+tBbPa9K3H8DAU6A=
X-Google-Smtp-Source: ABdhPJzPheZZ/6xsyI9/MWrfYuPNLmqCjFlfLbB41wSFfTIowStSs0z9BCyDP8/dSIBJaPbgspFrTg==
X-Received: by 2002:aca:5903:: with SMTP id n3mr10911799oib.159.1600462078020;
        Fri, 18 Sep 2020 13:47:58 -0700 (PDT)
Received: from localhost.localdomain (cpe-24-31-245-230.kc.res.rr.com. [24.31.245.230])
        by smtp.gmail.com with ESMTPSA id y7sm3470024oih.51.2020.09.18.13.47.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Sep 2020 13:47:57 -0700 (PDT)
Sender: Larry Finger <larry.finger@gmail.com>
Subject: Re: [PATCH -next 4/9] rtlwifi: rtl8821ae: fix comparison to bool
 warning in hw.c
To:     Zheng Bin <zhengbin13@huawei.com>, pkshih@realtek.com,
        kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     yi.zhang@huawei.com
References: <20200918102505.16036-1-zhengbin13@huawei.com>
 <20200918102505.16036-5-zhengbin13@huawei.com>
From:   Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <a94ceca0-1be0-41bb-30fb-855ffd0013bb@lwfinger.net>
Date:   Fri, 18 Sep 2020 15:47:56 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200918102505.16036-5-zhengbin13@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/18/20 5:25 AM, Zheng Bin wrote:
> Fixes coccicheck warning:
> 
> drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.c:1897:5-13: WARNING: Comparison to bool
> 
> Signed-off-by: Zheng Bin <zhengbin13@huawei.com>
> ---
>   drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)

Acked-by: Larry Finger <Larry.Finger@lwfinger.net>

Larry

> 
> diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.c
> index b2e5b9fda669..33ffc24d3675 100644
> --- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.c
> +++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.c
> @@ -1894,7 +1894,7 @@ int rtl8821ae_hw_init(struct ieee80211_hw *hw)
>   	}
> 
>   	rtstatus = _rtl8821ae_init_mac(hw);
> -	if (rtstatus != true) {
> +	if (!rtstatus) {
>   		pr_err("Init MAC failed\n");
>   		err = 1;
>   		return err;
> --
> 2.26.0.106.g9fadedd
> 

