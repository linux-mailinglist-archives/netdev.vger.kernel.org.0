Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5503239723D
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 13:23:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233397AbhFALYh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 07:24:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230308AbhFALYf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Jun 2021 07:24:35 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A270C061574;
        Tue,  1 Jun 2021 04:22:53 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id g204so4699882wmf.5;
        Tue, 01 Jun 2021 04:22:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=rVrLh+BnhfDpoEGB+4L9ayZQJ1wLZDvIL7BKTg+V8yY=;
        b=kOm6p0KZkuXKLYwtWiOtqBrBUDUNhj2g/+vA2A2KjSDgEowaSINtGYQlwL6En8Hj5D
         /hSNrBZCd934qh1zr97wy1954jLUmj3hvSvMutGCjQPabwlGT9lbUC9n6LIHPXuGN5PE
         8/jf16cgNtN6P62uUsbceAJ/uzpvfosNvMRZMCo2g2QZU8LNVfo9Debccdu1ARuruc7L
         P5aa41K3/49enqnZZyNojPmvRN+CVldQ0oDgJD7l9cfsgcSmQ7km2XzTMVrQw/cgymt0
         8jMFIJ+/rUyTQFMVVLpdAtCbNhedAzWHkwCst45csjAyGbDCGznFDrNDJQyAAGCKtr3q
         /psQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rVrLh+BnhfDpoEGB+4L9ayZQJ1wLZDvIL7BKTg+V8yY=;
        b=OW9iL7Je83wvKkVnrzrjkCSxip7TmcY3rxIzmuqfbBFINsHUcN6bSigH7j1R9hv1/K
         Fggx50CS0IwvnhhPNrbPQFMuBKCgUxX9pvX11C1kYZWD8zIdxgfBa8ThkO/ORIrE6JYt
         Mu/04Go+PXvI6lNEOEf/JqGdPPIa5UvC2SVWwRy2CdUqqc0bcpCU4X6o4g1Nq0UAWna/
         YCg7ieFNrdn40Vz+ZRDa8yDKuYE3MeYb9elzhOH4kC8PcKzJRs/kzSf/YWrguP0uVhf4
         ly6JGiZWixGABGoVCOLPAw1iO0MQNWyFw/N1RYP1tB7JX4k2fAVYTGaacoHEJjsLCshk
         3f6w==
X-Gm-Message-State: AOAM530s37Jo51Yabyu/T6EZ3EhhdCqQ0STGriXanEkJ+mBZFA9j8ihv
        azg6/Vvwm83Q69LY0a8WNT/RwDjxf243Iw==
X-Google-Smtp-Source: ABdhPJwfvNa8USFgUViuIRIQKpnat3yAxEGXpenkCdrAvehdmYYVQQ0G0uZPm2PMpGfV8aUgXaz+wQ==
X-Received: by 2002:a1c:f303:: with SMTP id q3mr4190518wmq.9.1622546571720;
        Tue, 01 Jun 2021 04:22:51 -0700 (PDT)
Received: from [192.168.1.122] (cpc159425-cmbg20-2-0-cust403.5-4.cable.virginm.net. [86.7.189.148])
        by smtp.gmail.com with ESMTPSA id n8sm5715215wmi.16.2021.06.01.04.22.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Jun 2021 04:22:51 -0700 (PDT)
Subject: Re: [PATCH] sfc-falcon: Fix missing error code in ef4_reset_up()
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc:     habetsm.xilinx@gmail.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1622545602-19483-1-git-send-email-jiapeng.chong@linux.alibaba.com>
From:   Edward Cree <ecree.xilinx@gmail.com>
Message-ID: <a0cfa46c-9545-2c6d-fd03-a97f0a3c4869@gmail.com>
Date:   Tue, 1 Jun 2021 12:22:50 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <1622545602-19483-1-git-send-email-jiapeng.chong@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 01/06/2021 12:06, Jiapeng Chong wrote:
> The error code is missing in this code scenario, add the error code
> '-EINVAL' to the return value 'rc'.
> 
> Eliminate the follow smatch warning:
> 
> drivers/net/ethernet/sfc/falcon/efx.c:2389 ef4_reset_up() warn: missing
> error code 'rc'.
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
> ---
>  drivers/net/ethernet/sfc/falcon/efx.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/sfc/falcon/efx.c b/drivers/net/ethernet/sfc/falcon/efx.c
> index 5e7a57b..d336c24 100644
> --- a/drivers/net/ethernet/sfc/falcon/efx.c
> +++ b/drivers/net/ethernet/sfc/falcon/efx.c
> @@ -2385,8 +2385,10 @@ int ef4_reset_up(struct ef4_nic *efx, enum reset_type method, bool ok)
>  		goto fail;
>  	}
>  
> -	if (!ok)
> +	if (!ok) {
> +		rc = -EINVAL;
>  		goto fail;
> +	}
Not sure this is correct.  Without the patch, we return with rc == 0
 (set by the efx->type->init() call just above), which seems reasonable
 as we successfully finished a RESET_TYPE_DISABLE.
The label name 'fail:' might be misleading; it does seem like this is
 intended behaviour.
Have you tested this at all?

Note that the sfc driver (efx_common.c) does much the same thing as the
 code here before your patch.

-ed

>  
>  	if (efx->port_initialized && method != RESET_TYPE_INVISIBLE &&
>  	    method != RESET_TYPE_DATAPATH) {
> 

