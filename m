Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A04D73320A5
	for <lists+netdev@lfdr.de>; Tue,  9 Mar 2021 09:33:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230126AbhCIIdO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Mar 2021 03:33:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229904AbhCIIdE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Mar 2021 03:33:04 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83B14C06174A;
        Tue,  9 Mar 2021 00:33:04 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id t85so3703302pfc.13;
        Tue, 09 Mar 2021 00:33:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=4eCgVhtPT3OTg8I5ClDev8s9qKziMxVgStL87zgWczs=;
        b=QJNyiHRjMKzg1OQiE1HpoDmr4I0S4NpkSRLwNegD09wF/eWcydQGA8pGH11s/ya3K/
         sNlXfFDB//LK2zlEnPagCmiVK5GaN+yvS3CaYAeWVd96HeNy0+0x1vkycrWFK3/5bi69
         1w/Rfw/ZDJNM2UG23RgRpfLO6olytmIW+PVR2MefuBbwXdbEFZI1ImKBaQvGssKk6pJF
         +1usRGSkdgQAa/G1KO6KCaIg2zneLuQBA1Ci2S9IZr1bbmr6FRixzPLKRXyhAuxDVQrY
         6FqPqZNUMuInwCKfqCKV2A1N/QSyQFl5bLk0Q6S/IIyRC/IiMWjq0GlZ4N3/Gt6wydXH
         6ZPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=4eCgVhtPT3OTg8I5ClDev8s9qKziMxVgStL87zgWczs=;
        b=gWC0yuwhf3qodpZSYhy7bVAuGVybpeDe6eZRXJ/AoMXXyZKJgwmEk9UVBwMAdhEVEv
         xYXPjxbXpk/y06EbR4f61nc0NYHc41y0b02qSLFpLeIH/KLINT2ySYYA4mnIahOKMBsj
         bb9OjQI3JyNzgXvJu9bYfwuM/CK+9K9/1b1f8xD8Uhjsi5yq0WW6AWivbUheppaMQZCM
         vp+KAV/+XTl4571cTtbYzdxmmDf3qqfBmcyae7DDHaqpqNgIXL7P4b+A0rA4bi7AKwBA
         yijQrQBeP5UVAbnb8GIDamH0VMGKuAa1XcxOUG+HoIfUWHSugpJXY9Up/eWITvnzB5nZ
         5SFQ==
X-Gm-Message-State: AOAM530P7z8XzpcCWzW95QWqfn5LlCUeeKdx4PNwRpcTKSlSgGuHYe6n
        +anXZO0S6QwGmj5YXJpSIMMyLfw2wWlbxeeD
X-Google-Smtp-Source: ABdhPJx/YB25JWDqqxQlkVojnt3GjeTqt7EvoR0TZKu16jqvT8qsGwlXXm8JfhxItwFypAAIwbSqgw==
X-Received: by 2002:a62:2e83:0:b029:1db:8bd9:b8ad with SMTP id u125-20020a622e830000b02901db8bd9b8admr25159072pfu.74.1615278783726;
        Tue, 09 Mar 2021 00:33:03 -0800 (PST)
Received: from [10.160.0.122] ([45.135.186.124])
        by smtp.gmail.com with ESMTPSA id k10sm11673713pfk.49.2021.03.09.00.33.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Mar 2021 00:33:03 -0800 (PST)
Subject: Re: [PATCH] net: mellanox: mlx5: fix error return code of
 mlx5e_stats_flower()
To:     Roi Dayan <roid@nvidia.com>, saeedm@nvidia.com, leon@kernel.org,
        davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210306134718.17566-1-baijiaju1990@gmail.com>
 <99807217-c2a3-928f-4c8c-2195f3500594@nvidia.com>
 <1fdf71d7-7a54-0b69-3339-e792dd03b2c8@nvidia.com>
From:   Jia-Ju Bai <baijiaju1990@gmail.com>
Message-ID: <3a1a2089-a7fa-2a7c-7040-c0aa62b08960@gmail.com>
Date:   Tue, 9 Mar 2021 16:32:59 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <1fdf71d7-7a54-0b69-3339-e792dd03b2c8@nvidia.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2021/3/9 16:24, Roi Dayan wrote:
>
>
> On 2021-03-09 10:20 AM, Roi Dayan wrote:
>>
>>
>> On 2021-03-06 3:47 PM, Jia-Ju Bai wrote:
>>> When mlx5e_tc_get_counter() returns NULL to counter or
>>> mlx5_devcom_get_peer_data() returns NULL to peer_esw, no error return
>>> code of mlx5e_stats_flower() is assigned.
>>> To fix this bug, err is assigned with -EINVAL in these cases.
>>>
>>> Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
>>> Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
>>> ---
>>>   drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 12 +++++++++---
>>>   1 file changed, 9 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c 
>>> b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
>>> index 0da69b98f38f..1f2c9da7bd35 100644
>>> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
>>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
>>> @@ -4380,8 +4380,10 @@ int mlx5e_stats_flower(struct net_device 
>>> *dev, struct mlx5e_priv *priv,
>>>       if (mlx5e_is_offloaded_flow(flow) || flow_flag_test(flow, CT)) {
>>>           counter = mlx5e_tc_get_counter(flow);
>>> -        if (!counter)
>>> +        if (!counter) {
>>> +            err = -EINVAL;
>>>               goto errout;
>>> +        }
>>>           mlx5_fc_query_cached(counter, &bytes, &packets, &lastuse);
>>>       }
>>> @@ -4390,8 +4392,10 @@ int mlx5e_stats_flower(struct net_device 
>>> *dev, struct mlx5e_priv *priv,
>>>        * un-offloaded while the other rule is offloaded.
>>>        */
>>>       peer_esw = mlx5_devcom_get_peer_data(devcom, 
>>> MLX5_DEVCOM_ESW_OFFLOADS);
>>> -    if (!peer_esw)
>>> +    if (!peer_esw) {
>>> +        err = -EINVAL;
>>
>> note here it's not an error. it could be there is no peer esw
>> so just continue with the stats update.
>>
>>>           goto out;
>>> +    }
>>>       if (flow_flag_test(flow, DUP) &&
>>>           flow_flag_test(flow->peer_flow, OFFLOADED)) {
>>> @@ -4400,8 +4404,10 @@ int mlx5e_stats_flower(struct net_device 
>>> *dev, struct mlx5e_priv *priv,
>>>           u64 lastuse2;
>>>           counter = mlx5e_tc_get_counter(flow->peer_flow);
>>> -        if (!counter)
>>> +        if (!counter) {
>>> +            err = -EINVAL;
>
> this change is problematic. the current goto is to do stats update with
> the first counter stats we got but if you now want to return an error
> then you probably should not do any update at all.

Thanks for your reply :)
I am not sure whether an error code should be returned here?
If so, flow_stats_update(...) should not be called here?


Best wishes,
Jia-Ju Bai

>
>>>               goto no_peer_counter;
>>> +        }
>>>           mlx5_fc_query_cached(counter, &bytes2, &packets2, &lastuse2);
>>>           bytes += bytes2;
>>>
>>
>>

