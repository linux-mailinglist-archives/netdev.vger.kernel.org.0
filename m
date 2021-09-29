Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE0ED41CAFC
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 19:21:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346204AbhI2RXZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 13:23:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343753AbhI2RXT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 13:23:19 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9469C06161C;
        Wed, 29 Sep 2021 10:21:30 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id w19so2516308pfn.12;
        Wed, 29 Sep 2021 10:21:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=LDYxmYqsjSSaY5qNEcKRB1CAbNpq6pKRJ2FH76OopzQ=;
        b=SL08n0GYQgtLYfC8OeMRTPwz4kyFIBgH5vGSrXVasHm4qVTLleyDxys5Rs66XsHY4l
         SHYNvDh9nPLfvQCq35o3c637USllorz1K/qgpzlwjz5CXtay3Ot2+hq0ww/+4D1uIGRX
         Q/Ivgpr6NxxyOzouZ+NJi80Aw2qCYz1WsP6COSLgtPoAnb+Kn8n4q2GoWBcIykUXwybF
         IDSSPQBOoRc8uMEQ3/ZVG3L6gHwWbzWPjtwLALdLcn5ZTABTMC7DTLhQUU1A1BLpXf6l
         q0N94Rl4hLdZJ+gkRvhq+gjs8LNt0mWO21e1B5YtB9wjYxWPg9xfuybFUlASvK2DEIaw
         pH6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LDYxmYqsjSSaY5qNEcKRB1CAbNpq6pKRJ2FH76OopzQ=;
        b=fgTzSZJ5AX+mX3912gi5pV9qeZ/AJS9lV3YrGWXf9ncoX40kwEK9XzNaQFOerb+vc6
         NdgBUY4zza7MHEw2fNOuAhyKKgFU2iQBUjfUlpMszaGKBk63niTMDb8ERhzrLK5TwJBZ
         a7xiCjmR7LzhMTBwPY6HgObI7bLwWNELWihogdkRWRwPwNA3Hmub3WTMJZ8VY0hvypCS
         0pSW/SqKbflTfrDrAYGPqGT7qOTy4SDzpBFuy21+ImbwQHGFsNmyGQdT7W2R0YBkTYR2
         2d5jqzhl0UO7h5jmVU7z47GyNMS+mIzdkWruEXGQYe9Mb6k/QNqOD9ntL6kqmHS2IUuc
         AKfg==
X-Gm-Message-State: AOAM531aBS+/ukKBjfy/ms+zndpUNcKLkkSNfpMNdVfOsbuvQdW2/tWD
        lHBU0DGERPPQGMwuFZ3QdmHgT4AwIa4=
X-Google-Smtp-Source: ABdhPJzQ+G9aJM6HWNTbSxWaxo4SVk2CvZqbVEM2uqRjF5z+NdsvkVidWhSOGRVrANMeeNy0/PMuUA==
X-Received: by 2002:a63:2b4b:: with SMTP id r72mr931484pgr.57.1632936090207;
        Wed, 29 Sep 2021 10:21:30 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id b7sm386900pfb.20.2021.09.29.10.21.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Sep 2021 10:21:29 -0700 (PDT)
Subject: Re: [PATCH][net-next] net/mlx4: Use array_size() helper in
 copy_to_user()
To:     Tariq Toukan <ttoukan.linux@gmail.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
References: <20210928201733.GA268467@embeddedor>
 <283d239b-9af9-d3a3-72be-9138c032ef63@gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <16ae2d2d-3aba-82b2-0bd8-90f7d0367a62@gmail.com>
Date:   Wed, 29 Sep 2021 10:21:27 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <283d239b-9af9-d3a3-72be-9138c032ef63@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/29/21 3:24 AM, Tariq Toukan wrote:
> 
> 
> On 9/28/2021 11:17 PM, Gustavo A. R. Silva wrote:
>> Use array_size() helper instead of the open-coded version in
>> copy_to_user(). These sorts of multiplication factors need
>> to be wrapped in array_size().
>>
>> Link: https://github.com/KSPP/linux/issues/160
>> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
>> ---
>>   drivers/net/ethernet/mellanox/mlx4/cq.c | 3 ++-
>>   1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/ethernet/mellanox/mlx4/cq.c b/drivers/net/ethernet/mellanox/mlx4/cq.c
>> index f7053a74e6a8..4d4f9cf9facb 100644
>> --- a/drivers/net/ethernet/mellanox/mlx4/cq.c
>> +++ b/drivers/net/ethernet/mellanox/mlx4/cq.c
>> @@ -314,7 +314,8 @@ static int mlx4_init_user_cqes(void *buf, int entries, int cqe_size)
>>               buf += PAGE_SIZE;
>>           }
>>       } else {
>> -        err = copy_to_user((void __user *)buf, init_ents, entries * cqe_size) ?
>> +        err = copy_to_user((void __user *)buf, init_ents,
>> +                   array_size(entries, cqe_size)) ?
>>               -EFAULT : 0;
>>       }
>>  
> 
> Thanks for your patch.
> Reviewed-by: Tariq Toukan <tariqt@nvidia.com>

Not sure why avoiding size_t overflows would make this code safer.
init_ents contains PAGE_SIZE bytes...

BTW

Is @entries guaranteed to be a power of two ?

This function seems to either copy one chunk ( <= PAGE_SIZE),
or a number of full pages.

