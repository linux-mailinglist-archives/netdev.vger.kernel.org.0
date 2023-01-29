Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D818567FDFE
	for <lists+netdev@lfdr.de>; Sun, 29 Jan 2023 11:04:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230370AbjA2KEo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Jan 2023 05:04:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229605AbjA2KEn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Jan 2023 05:04:43 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E1751E1D7
        for <netdev@vger.kernel.org>; Sun, 29 Jan 2023 02:04:42 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id h12so8575356wrv.10
        for <netdev@vger.kernel.org>; Sun, 29 Jan 2023 02:04:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2aDkGP7xw8kUj3UqFZR6s4T9hUrJVdUQcJ8egNg9YdE=;
        b=ocFbH5KhD2HyTAYcXuqOU7Ycu8ZWQ8w/nIcnxfv2Z0LtrrNbiACdP2r1KjdxYFdEqH
         cjE+GWsU5zRCJUFwKcNLmd1R61+yARDcPUfZ7RTKKIMfVFN3w5L210Nst5NXMvhwJjLp
         fQo19OPbCHW+HC3GYWfRZcdHk80IFVEhgxhwcGoyN4XVg92s2OPyjqbK70//bdJgOXKr
         CrWRSIVLsq5JkzYmL9dgzss+egAUrnC2I30+IJOv8uBBRqU+OJasTlkpHYH7FQhsbn7B
         N950rpcX1pK1xh5jClvoArcZecGa6W3xKLb+NwpCHF9MWse7g3EdkdO7JMVWCMskbVBi
         LV7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2aDkGP7xw8kUj3UqFZR6s4T9hUrJVdUQcJ8egNg9YdE=;
        b=2g6ZHF3lJSsqiDvgsT/oH3b9cu7eO6oWzSRVWbB8M/rz4Aw+fUqeTyaQrjywGdVjHx
         eWe3bp9FJfMCHhz6eDZBAorqTZhjVCnJ2j+35d7WCIJdpfWN3b8Yg+Whfqo4TVLWmtOR
         SvDQZ81fCNo69peNLXQ4DCdiBvSeHA6boAs9gVg2wOX47LvBkiRYCLgM+4WJPBWPI0JL
         oB4THRblsygvlfLbuTmhLyQQs3CvtrV2YAwka8OaKOisvkEbFj7E17vdGrB4T+iajEyc
         Cu45tN3vd4lRXTaItjAmxe6q+7ONhoK4V2mhFVVO6a+o2qjEU7UtU96qyyt6I2OU18Ya
         uXFw==
X-Gm-Message-State: AO0yUKVD3IIQEnH71gPJ56aaTV9rb34cetCOY61R8Y02jRTmYmOSf6AH
        Ji9Dg3DF8Ags6QhPuJ6BndA=
X-Google-Smtp-Source: AK7set8TWD4wejWI2vNWa8+b5Q9uzd2M5uQWwdncEPUb2rdNdf+bbapzQHPkdCZChw7/Re2oOU03lg==
X-Received: by 2002:adf:e645:0:b0:2bf:b8f0:f6c6 with SMTP id b5-20020adfe645000000b002bfb8f0f6c6mr14944502wrn.45.1674986680562;
        Sun, 29 Jan 2023 02:04:40 -0800 (PST)
Received: from [192.168.0.106] ([77.126.163.156])
        by smtp.gmail.com with ESMTPSA id e10-20020a5d500a000000b002be0b1e556esm8638272wrt.59.2023.01.29.02.04.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 29 Jan 2023 02:04:39 -0800 (PST)
Message-ID: <cdb2516f-098d-f671-36ac-a44a85426202@gmail.com>
Date:   Sun, 29 Jan 2023 12:04:38 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH net 1/2] net/mlx5e: XDP, Allow growing tail for XDP multi
 buffer
Content-Language: en-US
To:     Maxim Mikityanskiy <maxtram95@gmail.com>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Gal Pressman <gal@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>
References: <20230126191050.220610-1-maxtram95@gmail.com>
 <20230126191050.220610-2-maxtram95@gmail.com>
 <25a72690-6cae-bc7b-b30c-a0ece4fa0393@gmail.com>
 <Y9MB9gVwJz5mOdO/@mail.gmail.com>
From:   Tariq Toukan <ttoukan.linux@gmail.com>
In-Reply-To: <Y9MB9gVwJz5mOdO/@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 27/01/2023 0:43, Maxim Mikityanskiy wrote:
> On Thu, Jan 26, 2023 at 10:41:30PM +0200, Tariq Toukan wrote:
>>
>>
>> On 26/01/2023 21:10, Maxim Mikityanskiy wrote:
>>> The cited commits missed passing frag_size to __xdp_rxq_info_reg, which
>>> is required by bpf_xdp_adjust_tail to support growing the tail pointer
>>> in fragmented packets. Pass the missing parameter when the current RQ
>>> mode allows XDP multi buffer.
>>>
>>> Fixes: ea5d49bdae8b ("net/mlx5e: Add XDP multi buffer support to the non-linear legacy RQ")
>>> Fixes: 9cb9482ef10e ("net/mlx5e: Use fragments of the same size in non-linear legacy RQ with XDP")
>>> Signed-off-by: Maxim Mikityanskiy <maxtram95@gmail.com>
>>> Cc: Tariq Toukan <tariqt@nvidia.com>
>>> ---
>>>    drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 11 ++++++++---
>>>    1 file changed, 8 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
>>> index abcc614b6191..cdd1e47e18f9 100644
>>> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
>>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
>>> @@ -576,9 +576,10 @@ static void mlx5e_free_mpwqe_rq_drop_page(struct mlx5e_rq *rq)
>>>    }
>>>    static int mlx5e_init_rxq_rq(struct mlx5e_channel *c, struct mlx5e_params *params,
>>> -			     struct mlx5e_rq *rq)
>>> +			     struct mlx5e_rq_param *rq_params, struct mlx5e_rq *rq)
>>>    {
>>>    	struct mlx5_core_dev *mdev = c->mdev;
>>> +	u32 xdp_frag_size = 0;
>>>    	int err;
>>>    	rq->wq_type      = params->rq_wq_type;
>>> @@ -599,7 +600,11 @@ static int mlx5e_init_rxq_rq(struct mlx5e_channel *c, struct mlx5e_params *param
>>>    	if (err)
>>>    		return err;
>>> -	return xdp_rxq_info_reg(&rq->xdp_rxq, rq->netdev, rq->ix, c->napi.napi_id);
>>> +	if (rq->wq_type == MLX5_WQ_TYPE_CYCLIC && rq_params->frags_info.num_frags > 1)
>>
>> How about a more generic check? like:
>> if (params->xdp_prog && params->xdp_prog->aux->xdp_has_frags)
>>
>> So we won't have to maintain this when Stridng RQ support is added.
> 
> The check is specific, because below I use rq_params->frags_info, which
> is specific to legacy RQ. If we change the input for xdp_frag_size, the
> check can also be changed, but the condition that you suggested can't be
> used anyway, because the XDP program can be hot-swapped without
> recreating channels (i.e. without calling into mlx5e_init_rxq_rq), and
> xdp_has_frags can change after the hot-swap.
> 
> It's actually valid to pass a non-zero value unconditionally, it just
> won't be used if the driver doesn't pass any multi-buffer frames to XDP.
> I added a reasonable condition solely for extra robustness, but we can
> drop the `if` altogether if we don't agree on the condition.
> 
>>> +		xdp_frag_size = rq_params->frags_info.arr[1].frag_stride;
>>
>> Again, in order to not maintain this (frags_info.arr[1].frag_stride not
>> relevant for Striding RQ), isn't the value always PAGE_SIZE?
> 
> It's always PAGE_SIZE for the current implementation of legacy RQ, but
> the kernel doesn't fix it to PAGE_SIZE, it's possible for a driver to
> choose a different memory allocation scheme with fragments of another
> size, that's why this parameter exists.
> 
> Setting it to PAGE_SIZE to be "future-proof" may be problematic: if
> striding RQ uses a different frag_size, and the author forgets to update
> this code, it may lead to a memory corruption on adjust_tail.
> 
> There is an obvious robustness problem with this place in code: it's
> easy to forget about updating it. I forgot to set the right non-zero
> value when I added XDP multi buffer, the next developer risks forgetting
> updating this code when XDP multi buffer support is extended to striding
> RQ, or the memory allocation scheme is somehow changed. So, it's not
> possible to avoid maintaining it: either way it might need changes in
> the future. I wanted to add some WARN_ON or BUILD_BUG_ON to simplify
> such maintenance, but couldn't think of a good check...
> 
>>
>> Another idea is to introduce something like
>> #define XDP_MB_FRAG_SZ (PAGE_SIZE)
>> use it here and in mlx5e_build_rq_frags_info ::
>> if (byte_count > max_mtu || params->xdp_prog) {
>> 	frag_size_max = XDP_MB_FRAG_SZ;
>> Not sure it's worth it...
> 
> IMO, it doesn't fit to mlx5e_build_rq_frags_info, because that function
> heavily relies on its value being PAGE_SIZE, and hiding it under a
> different name may give false impression that it can be changed.
> Moreover, there is a chance that striding RQ will use a different value
> for XDP frag_size. Also, it rather doesn't make sense even in the code
> that you quoted: if byte_count > max_mtu, using XDP_MB_FRAG_SZ doesn't
> make sense.
> 
> Using this constant only here, but not in mlx5e_build_rq_frags_info
> doesn't make sense either, because it won't help remind developers to
> update this part of code.
> 

Agree.

> I think I got a better idea: move the logic to en/params.c, it knows
> everything about the memory allocation scheme, about the XDP multi
> buffer support, so let it calculate the right value and assign it to
> some field (let's say, rq_params->xdp_frag_size), which is passed to
> mlx5e_init_rxq_rq and used here as is. mlx5e_init_rxq_rq won't need to
> dig into implementation details of each mode, instead the functions that
> contain these details will calculate the value for XDP. What do you
> think?
> 

Yes, that would be best.

>> Both ways we save passing rq_params in the callstack.
> 
> I don't think the number of parameters is crucial for non-datapath,
> especially given that it's still fewer than 6.
> 
>>
>>> +
>>> +	return __xdp_rxq_info_reg(&rq->xdp_rxq, rq->netdev, rq->ix, c->napi.napi_id,
>>> +				  xdp_frag_size);
>>>    }
>>>    static int mlx5_rq_shampo_alloc(struct mlx5_core_dev *mdev,
>>> @@ -2214,7 +2219,7 @@ static int mlx5e_open_rxq_rq(struct mlx5e_channel *c, struct mlx5e_params *param
>>>    {
>>>    	int err;
>>> -	err = mlx5e_init_rxq_rq(c, params, &c->rq);
>>> +	err = mlx5e_init_rxq_rq(c, params, rq_params, &c->rq);
>>>    	if (err)
>>>    		return err;
