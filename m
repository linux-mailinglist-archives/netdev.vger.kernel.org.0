Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 702C369C6B0
	for <lists+netdev@lfdr.de>; Mon, 20 Feb 2023 09:30:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231178AbjBTIag (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 03:30:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229663AbjBTIac (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 03:30:32 -0500
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75A0013D46;
        Mon, 20 Feb 2023 00:30:19 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id t15so308685wrz.7;
        Mon, 20 Feb 2023 00:30:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VgPzqSQESn15Hy9eYP0tvbIKK9Eg8jsN9T7ptRq/d64=;
        b=lesBfLDhuZMdjd7WwVl9vGUJ8u9y8h9h408IcwB5VqaIf+ZJfPmpaULMS9grpSzRFe
         YqCHj0FSOHol5kDESczrYElfo5GtBRxDJcLQOXBWpfzpt9zKGepavo0CEAsFoJns5dAq
         bpFbXqu5dc+VtqgwGGTZUmBaD1pMekfNhY6keQ/UFPKs+yTy8AW06Y9MXGqfjnJ4IBMG
         W5CmTyyHQ/oK2C+Tx3szP+VwLNVK2kTENie49LFD9CVSLW3Rt48PZvGIxUBlK3AQuyIh
         6ZJ0pyMOlEnHtVvOhfyPE/G46MFCu1FbnQUOxQN8UNkY46v4Dr24i8nAM2NLRanBb+gD
         4ccw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VgPzqSQESn15Hy9eYP0tvbIKK9Eg8jsN9T7ptRq/d64=;
        b=hZdxBq1OgLJqWhVQEio9cAmtF22PDzKmcK5xE92puNgBuCvF0yToBea+rbo3HU5M56
         m+cnEdDQxnyR5UqxnvbDJVJB60IBTBGVsA+a1Ndl/nefWHnGA5/PhCEO4c3RjTLNpYpX
         vtlSyMsw2KnlLLo3DYunZdjxnC9QwM3l+RpbD4vRJyXeLMUL8cXCxdox4y3SRFoBgVdZ
         s9CgSx7//A9UKOBSLJ0FKyH+5sMAHfItrVXgsKTFb4MCSVzwwfnrNk1RQFCNl/OzrKVe
         C794HxvDYqMb8WDhra1zc+U98TtUgUfJgqdXe/h5/XuY+xrI2a5h3M9NVK8EQDyelMii
         +Uqw==
X-Gm-Message-State: AO0yUKVyYT7ktmefWSPf4ZM7MTTWaay+oX8MQuxln6NBjc1djRMGvrtC
        hdtRPJ6yiWHkt+gBPhl0IXbWO3DyHng=
X-Google-Smtp-Source: AK7set9Ea53Z2FgK27fMofUSVbW+R32Gx3MvdczNOshe2uNIXBxf3i0O/XEWa00S2LjGuIZfZ7oaHw==
X-Received: by 2002:a5d:4046:0:b0:2c5:5ff8:6aff with SMTP id w6-20020a5d4046000000b002c55ff86affmr1236772wrp.3.1676881817750;
        Mon, 20 Feb 2023 00:30:17 -0800 (PST)
Received: from [192.168.1.115] ([77.124.87.109])
        by smtp.gmail.com with ESMTPSA id s14-20020a5d510e000000b002c569acab1esm1102877wrt.73.2023.02.20.00.30.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Feb 2023 00:30:17 -0800 (PST)
Message-ID: <e8551085-30b8-dce3-28b7-233b47a7ddc1@gmail.com>
Date:   Mon, 20 Feb 2023 10:30:15 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.2
Subject: Re: [PATCH net] mlx4: supress fortify for inlined xmit
Content-Language: en-US
To:     Kees Cook <kees@kernel.org>, Josef Oskera <joskera@redhat.com>,
        netdev@vger.kernel.org
Cc:     Tariq Toukan <tariqt@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Kees Cook <keescook@chromium.org>, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20230217094541.2362873-1-joskera@redhat.com>
 <2E9A091B-ABA3-4B99-965A-EA893F402F25@kernel.org>
 <febbc959-4cc7-a810-8000-db37f2de53cc@gmail.com>
From:   Tariq Toukan <ttoukan.linux@gmail.com>
In-Reply-To: <febbc959-4cc7-a810-8000-db37f2de53cc@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 19/02/2023 11:16, Tariq Toukan wrote:
> 
> 
> On 18/02/2023 18:26, Kees Cook wrote:
>> On February 17, 2023 1:45:41 AM PST, Josef Oskera <joskera@redhat.com> 
>> wrote:
>>> This call "skb_copy_from_linear_data(skb, inl + 1, spc)" triggers 
>>> FORTIFY memcpy()
>>> warning on ppc64 platform.
>>>
>>> In function ‘fortify_memcpy_chk’,
>>>     inlined from ‘skb_copy_from_linear_data’ at 
>>> ./include/linux/skbuff.h:4029:2,
>>>     inlined from ‘build_inline_wqe’ at 
>>> drivers/net/ethernet/mellanox/mlx4/en_tx.c:722:4,
>>>     inlined from ‘mlx4_en_xmit’ at 
>>> drivers/net/ethernet/mellanox/mlx4/en_tx.c:1066:3:
>>> ./include/linux/fortify-string.h:513:25: error: call to 
>>> ‘__write_overflow_field’ declared with attribute warning: detected 
>>> write beyond size of field (1st parameter); maybe use struct_group()? 
>>> [-Werror=attribute-warning]
>>>   513 |                         __write_overflow_field(p_size_field, 
>>> size);
>>>       |                         
>>> ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>>>
>>> Same behaviour on x86 you can get if you use "__always_inline" 
>>> instead of
>>> "inline" for skb_copy_from_linear_data() in skbuff.h
>>>
>>> The call here copies data into inlined tx destricptor, which has 104 
>>> bytes
>>> (MAX_INLINE) space for data payload. In this case "spc" is known in 
>>> compile-time
>>> but the destination is used with hidden knowledge (real structure of 
>>> destination
>>> is different from that the compiler can see). That cause the fortify 
>>> warning
>>> because compiler can check bounds, but the real bounds are different.
>>> "spc" can't be bigger than 64 bytes (MLX4_INLINE_ALIGN), so the data 
>>> can always
>>> fit into inlined tx descriptor.
>>> The fact that "inl" points into inlined tx descriptor is determined 
>>> earlier
>>> in mlx4_en_xmit().
>>>
>>> Fixes: f68f2ff91512c1 fortify: Detect struct member overflows in 
>>> memcpy() at compile-time
>>> Signed-off-by: Josef Oskera <joskera@redhat.com>
>>> ---
>>> drivers/net/ethernet/mellanox/mlx4/en_tx.c | 11 ++++++++++-
>>> 1 file changed, 10 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/net/ethernet/mellanox/mlx4/en_tx.c 
>>> b/drivers/net/ethernet/mellanox/mlx4/en_tx.c
>>> index c5758637b7bed6..f30ca9fe90e5b4 100644
>>> --- a/drivers/net/ethernet/mellanox/mlx4/en_tx.c
>>> +++ b/drivers/net/ethernet/mellanox/mlx4/en_tx.c
>>> @@ -719,7 +719,16 @@ static void build_inline_wqe(struct 
>>> mlx4_en_tx_desc *tx_desc,
>>>             inl = (void *) (inl + 1) + spc;
>>>             memcpy(((void *)(inl + 1)), fragptr, skb->len - spc);
>>
>> Using "unsafe" isn't the right solution here. What needs fixing is the 
>> "inl + 1" pattern which lacks any sense from the compilet's 
>> perspective. The struct of inl needs to end with a flex array, and it 
>> should be used for all the accesses. i.e. replace all the "inl + 1" 
>> instances with "inl->data". This makes it more readable for humans 
>> too. :)
>>
>> I can send a patch...
>>
> 
> Although expanding the mlx4_wqe_inline_seg struct with a flex array 
> sounds valid, I wouldn't go that way as it requires a larger change, 
> touching common and RDMA code as well, for a driver in it's end-of-life 
> stage.
> 
> We already have such unsafe_memcpy usage in mlx5 driver, so I can accept 
> it here as well.
> 
> Let's keep the change as contained as possible.
> 
> Reviewed-by: Tariq Toukan <tariqt@nvidia.com>

Kees posted a contained alternative solution.
Let's go with that one. Thanks.
