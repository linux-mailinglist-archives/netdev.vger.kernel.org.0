Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F054441CB2D
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 19:45:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345171AbhI2RrD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 13:47:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344502AbhI2RrC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 13:47:02 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AFCFC06161C;
        Wed, 29 Sep 2021 10:45:21 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id v10so11844324edj.10;
        Wed, 29 Sep 2021 10:45:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=FIySyrXxkEKwm26jEVGIMsY7wJRMxgw98emBJrp8y6k=;
        b=TPaJQTAmcDitxf8sdYRG0suoD9OHN+sqJSpRUZK8MeJi++z5D1ptjyVQYeiOQb0xRz
         q/12yatXna9nstDHjtX91d0WHkcHgEAmqP9KMZqwMfGcdSq7xnaER0/LWjNOXtpP9FKn
         F3+D2FaUshkIzokd6Ze1bOk/b9cs9UH1g7G0Ksb88yXanQlTAXv2ypXxRprYdArK4k0G
         Xn+kJjK5+UFvUyGSF2oJM/6kx8z9D3NMPMQN/uBU+/8OO7orSgyv8a58AwQYVQpBjb3A
         18cLyXbIvuY44Xrh/FnXl+PelNAiW3VaJSNiucUy2QkJmmJ3Hh60DV5sVavSCgo0lUb8
         A+Ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FIySyrXxkEKwm26jEVGIMsY7wJRMxgw98emBJrp8y6k=;
        b=bwTpLIRvO8V7/spP36xvwJ4PbNUS7gG2Vsrf2zLJ4FLJpmD7AZGqmA8C/jyg09A2au
         vXt4p8KAAX7K02XDtWsUqICafmz+KBJqK860EsJP7SqXnbeA01VPyZkKJn9G2gWOHo7d
         nZEfhKxFfkBN27/FoJltM1wRqMgWtMPfRGDjp0Xp5udoimmKBnMZSWkF6VMANqoHJ+Re
         r4PTWmZ63nBcgpECIENwKmhCkntap83iQ3xQ4lgCXqbnvmdIN+qnqKaaN4SWl3zlBO5L
         3VkCdGHR+C1TPjJb7+WuFXjHanPEGjJ/6GIj/P4/mvILBlgrZF5Y11WY3ACdd+z38pR9
         3NBw==
X-Gm-Message-State: AOAM531MHijAAd/9isynwPi8J8V5whxOlJaWBTZDOA7yLwONWtl2vMPn
        Jh+GZlt+Dpjt55r8luaHeFpMX4m6bZ0=
X-Google-Smtp-Source: ABdhPJyv6MYqHGEXqX5DmaZbUP++IQh7gQRcGMZL91Fz4wXLE2Arze2Mh7vp5GGyw/Lnk8fL/qPVcw==
X-Received: by 2002:a50:fa89:: with SMTP id w9mr1411930edr.113.1632937519918;
        Wed, 29 Sep 2021 10:45:19 -0700 (PDT)
Received: from [192.168.0.108] ([176.228.98.2])
        by smtp.gmail.com with ESMTPSA id dt4sm350760ejb.27.2021.09.29.10.45.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Sep 2021 10:45:19 -0700 (PDT)
Subject: Re: [PATCH][net-next] net/mlx4: Use array_size() helper in
 copy_to_user()
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
References: <20210928201733.GA268467@embeddedor>
 <283d239b-9af9-d3a3-72be-9138c032ef63@gmail.com>
 <16ae2d2d-3aba-82b2-0bd8-90f7d0367a62@gmail.com>
From:   Tariq Toukan <ttoukan.linux@gmail.com>
Message-ID: <e2f72429-91c5-7140-c13d-35d4623092de@gmail.com>
Date:   Wed, 29 Sep 2021 20:45:17 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <16ae2d2d-3aba-82b2-0bd8-90f7d0367a62@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/29/2021 8:21 PM, Eric Dumazet wrote:
> 
> 
> On 9/29/21 3:24 AM, Tariq Toukan wrote:
>>
>>
>> On 9/28/2021 11:17 PM, Gustavo A. R. Silva wrote:
>>> Use array_size() helper instead of the open-coded version in
>>> copy_to_user(). These sorts of multiplication factors need
>>> to be wrapped in array_size().
>>>
>>> Link: https://github.com/KSPP/linux/issues/160
>>> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
>>> ---
>>>    drivers/net/ethernet/mellanox/mlx4/cq.c | 3 ++-
>>>    1 file changed, 2 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/net/ethernet/mellanox/mlx4/cq.c b/drivers/net/ethernet/mellanox/mlx4/cq.c
>>> index f7053a74e6a8..4d4f9cf9facb 100644
>>> --- a/drivers/net/ethernet/mellanox/mlx4/cq.c
>>> +++ b/drivers/net/ethernet/mellanox/mlx4/cq.c
>>> @@ -314,7 +314,8 @@ static int mlx4_init_user_cqes(void *buf, int entries, int cqe_size)
>>>                buf += PAGE_SIZE;
>>>            }
>>>        } else {
>>> -        err = copy_to_user((void __user *)buf, init_ents, entries * cqe_size) ?
>>> +        err = copy_to_user((void __user *)buf, init_ents,
>>> +                   array_size(entries, cqe_size)) ?
>>>                -EFAULT : 0;
>>>        }
>>>   
>>
>> Thanks for your patch.
>> Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
> 
> Not sure why avoiding size_t overflows would make this code safer.
> init_ents contains PAGE_SIZE bytes...
> 
> BTW
> 
> Is @entries guaranteed to be a power of two ?

Yes.

> 
> This function seems to either copy one chunk ( <= PAGE_SIZE),
> or a number of full pages.
> 

Exactly. No remainder handling is needed, for the reason you mentioned 
above.
