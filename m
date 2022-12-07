Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61288645D60
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 16:14:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229643AbiLGPOY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 10:14:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229513AbiLGPOX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 10:14:23 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F44F5FB96
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 07:14:20 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id b2so14706670eja.7
        for <netdev@vger.kernel.org>; Wed, 07 Dec 2022 07:14:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Z7jh/q6+EKvNsrzsOVnb4GKEWGMpO0PJkaRUW/Xnbzk=;
        b=T4WP31fxnTkKAYZk1KuDzg4k8s47Eqk/EaQtgZTycKohB/8Jjrj6JWYWPGrpmho9ev
         v9/GQ8GZzLfPk//u+jRgt7V11IvD/iINNqhA7blzyWmfSY1W685D2cCUTBWgNNBMimHx
         encZmfZ7swwM3hDaRcMJjokpgl13m21iG14s3DnZ3t/enhBvMd698HjoreD4xRnexyQt
         ZtMVvKkKdMbGCYp6d89FK7lyL5bM7Qfdkq4xZyKiwaMjuDl2jMnvUKpVO8btULUgCMW1
         wuzTJmZX+BLtL4BgVWtd4rRy3IJj855/ygq8klwCecgJNZhAQPGWONOsAccUieXz9eZk
         rPRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Z7jh/q6+EKvNsrzsOVnb4GKEWGMpO0PJkaRUW/Xnbzk=;
        b=T1HmmqeFGDFEw4YYT4UR0T2CMxp15wOd5yofvKfMleVyAf8t10orenPP0afwjtp2Gn
         /Jjyh2Nby4u8FADkLVMbILcQPaFsZ5NqtA5mMEeiOTKkgROPtYKFIZXjI6mDjfy6eAsA
         ZKUlXn8VJQ3/feI1Gi1F14lS82eSg1n8MsRnITS2yN8XexwXVZCcEaSjWvhuQPcUA9//
         2zUXfPFK9IZmZcTK8QfGh/bWDV3eXE3EluiWq+xLfP0zBy7qvPKhRZZ9G1WnJ8ek8we0
         JNg67Hd/xOLWtEsuA0aDuYeqcUtmpxUMpS+z7UJJ7Ah3w+qQZ+Hi3TgthPtcqs6qjA2L
         rqaQ==
X-Gm-Message-State: ANoB5pkt2ks18titmmDf+bLjUukGhp5tJDFOueHhcedF5YqX6RWJztEs
        sLWBBHujjlCVxpOfat3WL1k=
X-Google-Smtp-Source: AA0mqf7g5254uAusxdiPyP7aAEmxWR4ZwHnLigQa3gS3Yqwgsh06yfvgwwj6tWYMgbXLWmuZfSCHyg==
X-Received: by 2002:a17:906:38f:b0:7c1:31d:8b75 with SMTP id b15-20020a170906038f00b007c1031d8b75mr8537941eja.157.1670426059019;
        Wed, 07 Dec 2022 07:14:19 -0800 (PST)
Received: from [192.168.0.105] ([77.126.19.155])
        by smtp.gmail.com with ESMTPSA id r22-20020aa7cfd6000000b0046ab2bd784csm2298055edy.64.2022.12.07.07.14.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Dec 2022 07:14:18 -0800 (PST)
Message-ID: <eb076121-479b-ca4a-c13d-8adbdfdbc893@gmail.com>
Date:   Wed, 7 Dec 2022 17:14:16 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH net-next 2/3] net/mlx4: MLX4_TX_BOUNCE_BUFFER_SIZE depends
 on MAX_SKB_FRAGS
Content-Language: en-US
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Tariq Toukan <tariqt@nvidia.com>, Wei Wang <weiwan@google.com>,
        netdev@vger.kernel.org, eric.dumazet@gmail.com
References: <20221206055059.1877471-1-edumazet@google.com>
 <20221206055059.1877471-3-edumazet@google.com>
 <40ca4e2e-8f34-545a-7063-09aee0a5dd4c@gmail.com>
 <CANn89iKUYMb_4vJ5GAE0-BUmM7JNuHo_p8oHbfJfatYKBX8ouw@mail.gmail.com>
 <CANn89iKpGwej5X_noxU+N7Y4o30dpfEFX_Ao6qZeahScvM7qGQ@mail.gmail.com>
From:   Tariq Toukan <ttoukan.linux@gmail.com>
In-Reply-To: <CANn89iKpGwej5X_noxU+N7Y4o30dpfEFX_Ao6qZeahScvM7qGQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/7/2022 3:06 PM, Eric Dumazet wrote:
> On Wed, Dec 7, 2022 at 1:53 PM Eric Dumazet <edumazet@google.com> wrote:
>>
>> On Wed, Dec 7, 2022 at 1:40 PM Tariq Toukan <ttoukan.linux@gmail.com> wrote:
>>>
>>>
>>>
>>> On 12/6/2022 7:50 AM, Eric Dumazet wrote:
>>>> Google production kernel has increased MAX_SKB_FRAGS to 45
>>>> for BIG-TCP rollout.
>>>>
>>>> Unfortunately mlx4 TX bounce buffer is not big enough whenever
>>>> an skb has up to 45 page fragments.
>>>>
>>>> This can happen often with TCP TX zero copy, as one frag usually
>>>> holds 4096 bytes of payload (order-0 page).
>>>>
>>>> Tested:
>>>>    Kernel built with MAX_SKB_FRAGS=45
>>>>    ip link set dev eth0 gso_max_size 185000
>>>>    netperf -t TCP_SENDFILE
>>>>
>>>> I made sure that "ethtool -G eth0 tx 64" was properly working,
>>>> ring->full_size being set to 16.
>>>>
>>>> Signed-off-by: Eric Dumazet <edumazet@google.com>
>>>> Reported-by: Wei Wang <weiwan@google.com>
>>>> Cc: Tariq Toukan <tariqt@nvidia.com>
>>>> ---
>>>>    drivers/net/ethernet/mellanox/mlx4/mlx4_en.h | 16 ++++++++++++----
>>>>    1 file changed, 12 insertions(+), 4 deletions(-)
>>>>
>>>> diff --git a/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h b/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h
>>>> index 7cc288db2a64f75ffe64882e3c25b90715e68855..120b8c361e91d443f83f100a1afabcabc776a92a 100644
>>>> --- a/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h
>>>> +++ b/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h
>>>> @@ -89,8 +89,18 @@
>>>>    #define MLX4_EN_FILTER_HASH_SHIFT 4
>>>>    #define MLX4_EN_FILTER_EXPIRY_QUOTA 60
>>>>
>>>> -/* Typical TSO descriptor with 16 gather entries is 352 bytes... */
>>>> -#define MLX4_TX_BOUNCE_BUFFER_SIZE 512
>>>> +#define CTRL_SIZE    sizeof(struct mlx4_wqe_ctrl_seg)
>>>> +#define DS_SIZE              sizeof(struct mlx4_wqe_data_seg)
>>>> +
>>>> +/* Maximal size of the bounce buffer:
>>>> + * 256 bytes for LSO headers.
>>>> + * CTRL_SIZE for control desc.
>>>> + * DS_SIZE if skb->head contains some payload.
>>>> + * MAX_SKB_FRAGS frags.
>>>> + */
>>>> +#define MLX4_TX_BOUNCE_BUFFER_SIZE (256 + CTRL_SIZE + DS_SIZE +              \
>>>> +                                 MAX_SKB_FRAGS * DS_SIZE)
>>>> +
>>>>    #define MLX4_MAX_DESC_TXBBS    (MLX4_TX_BOUNCE_BUFFER_SIZE / TXBB_SIZE)
>>>>
>>>
>>> Now as MLX4_TX_BOUNCE_BUFFER_SIZE might not be a multiple of TXBB_SIZE,
>>> simple integer division won't work to calculate the max num of TXBBs.
>>> Roundup is needed.
>>
>> I do not see why a roundup is needed. This seems like obfuscation to me.
>>
>> A divide by TXBB_SIZE always "works".
>>
>> A round up is already done in mlx4_en_xmit()
>>
>> /* Align descriptor to TXBB size */
>> desc_size = ALIGN(real_size, TXBB_SIZE);
>> nr_txbb = desc_size >> LOG_TXBB_SIZE;
>>
>> Then the check is :
>>
>> if (unlikely(nr_txbb > MLX4_MAX_DESC_TXBBS)) {
>>     if (netif_msg_tx_err(priv))
>>         en_warn(priv, "Oversized header or SG list\n");
>>     goto tx_drop_count;
>> }
>>
>> If we allocate X extra bytes (in case MLX4_TX_BOUNCE_BUFFER_SIZE %
>> TXBB_SIZE == X),
>> we are not going to use them anyway.

Now the MLX4_MAX_DESC_TXBBS gives a stricter limit than the allocated 
size MLX4_TX_BOUNCE_BUFFER_SIZE.

> 
> I guess you are worried about not having exactly 256 bytes for the headers ?
> 
> Currently, the amount of space for headers is  208 bytes.
> 
> If MAX_SKB_FRAGS is 17,  MLX4_TX_BOUNCE_BUFFER_SIZE would be 0x230
> after my patch,
> so the same usable space as before the patch.

So what you're saying is, if all the elements of 
MLX4_TX_BOUNCE_BUFFER_SIZE co-exist together for a TX descriptor, then 
the actual "headers" part can go only up to 208 (similar to today), not 
the whole 256 (as the new define documentation says).

This keeps the current behavior, but makes the code a bit more confusing.

IMO it is cleaner to have MLX4_TX_BOUNCE_BUFFER_SIZE explicitly defined 
as a multiple of TXBB_SIZE in the first place. This way, both the 
allocation size and the desc size limit will be in perfect sync, without 
having assumptions on the amount X lost in the division.

How about the below, to keep today's values for the defines?

#define MLX4_TX_BOUNCE_BUFFER_SIZE \
	ALIGN(208 + CTRL_SIZE + DS_SIZE + \
	      MAX_SKB_FRAGS * DS_SIZE, TXBB_SIZE)
