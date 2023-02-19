Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A14C569BF57
	for <lists+netdev@lfdr.de>; Sun, 19 Feb 2023 10:17:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229606AbjBSJRB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Feb 2023 04:17:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbjBSJRA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Feb 2023 04:17:00 -0500
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A5351164F;
        Sun, 19 Feb 2023 01:16:58 -0800 (PST)
Received: by mail-wr1-x429.google.com with SMTP id e2so247969wri.12;
        Sun, 19 Feb 2023 01:16:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=RbGxWqa6flC5Rbt0IpGtgXUsQbu+DI+pW0pZheFg8eY=;
        b=ou93PDqvWJG6/e7HJZu4RtVtXBA766bKV+wC2tfhM+IxKIs2Pc/WzSVAOTVIkNtBSZ
         2PHiV1jSCNpkkxfplV9HZqGS8jpF+i9Qoa0vI/zUSYrTRuyrask4ApOpkETNAqimfYii
         EBnosJo0vv3XzkvyuvFnrmsGeTM2iDhtFfWK9u8t0hradr4+NoxPZb1abjrxVeonvsdc
         cAUkfxYG9agu3F/C084j0OywXz0P+9JMGZ3AHN1RPlFSiTqZy1lm5hK7B5z/udukzuNT
         RmS2FcGOOpwTpIaRVTmFYYgcHTrLd01dEo8uQ/oXI/yGUcUfOMRyAz/2Qxu0IZhr4nzu
         KeoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RbGxWqa6flC5Rbt0IpGtgXUsQbu+DI+pW0pZheFg8eY=;
        b=KxszUjVe1/ybeuPbg4fmtdsvJJZD9/cNbuwpgXH+qTSCdTOQ2IOsGPHwHv6Sz6TRO0
         /Bl4s71Tea0vNmWkDMrxWXrX4Sp8UB7QTfXJt6NYXKRpZEn8z/FLHxxFfm73bAnm3oeL
         OGwEujCzFw7Qk3w/5E5klI47M7tkiNlYqmfitN38LIfalL9fMskg/REHqrmTSR/LpULT
         JjpgnCTcN0j296E51Lt9Ex1BFMBBJNmt8QIX7RSTHLqv+FkKz4A1OKnCyh3PMq+qsBxr
         Eiyju3v6pklrpHCiRo8J1uPcIhTyFaMEp4X4Ra1KkHsA2YmgEVkLKdtHA17CL2ohSxlf
         MsuQ==
X-Gm-Message-State: AO0yUKWsEUeJEYYhAP4e4D7iQJiM3964FJz/sybVIIWCiL7ordgLr3ux
        d+muzHqNy8XMWxa4E2GsidE0G591mCU=
X-Google-Smtp-Source: AK7set96xeX0cSuyxE0wzP+XIJ/aeNFVGg9A671gqFNYbX3dAhPQ8DEb3F9bRwegqCakw83/BEyhPw==
X-Received: by 2002:adf:f207:0:b0:2c5:60e2:ed5d with SMTP id p7-20020adff207000000b002c560e2ed5dmr1814218wro.2.1676798216482;
        Sun, 19 Feb 2023 01:16:56 -0800 (PST)
Received: from [192.168.0.106] ([77.126.33.94])
        by smtp.gmail.com with ESMTPSA id b13-20020a05600010cd00b002c54d970fd8sm1964923wrx.36.2023.02.19.01.16.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 19 Feb 2023 01:16:55 -0800 (PST)
Message-ID: <febbc959-4cc7-a810-8000-db37f2de53cc@gmail.com>
Date:   Sun, 19 Feb 2023 11:16:54 +0200
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
From:   Tariq Toukan <ttoukan.linux@gmail.com>
In-Reply-To: <2E9A091B-ABA3-4B99-965A-EA893F402F25@kernel.org>
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



On 18/02/2023 18:26, Kees Cook wrote:
> On February 17, 2023 1:45:41 AM PST, Josef Oskera <joskera@redhat.com> wrote:
>> This call "skb_copy_from_linear_data(skb, inl + 1, spc)" triggers FORTIFY memcpy()
>> warning on ppc64 platform.
>>
>> In function ‘fortify_memcpy_chk’,
>>     inlined from ‘skb_copy_from_linear_data’ at ./include/linux/skbuff.h:4029:2,
>>     inlined from ‘build_inline_wqe’ at drivers/net/ethernet/mellanox/mlx4/en_tx.c:722:4,
>>     inlined from ‘mlx4_en_xmit’ at drivers/net/ethernet/mellanox/mlx4/en_tx.c:1066:3:
>> ./include/linux/fortify-string.h:513:25: error: call to ‘__write_overflow_field’ declared with attribute warning: detected write beyond size of field (1st parameter); maybe use struct_group()? [-Werror=attribute-warning]
>>   513 |                         __write_overflow_field(p_size_field, size);
>>       |                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>>
>> Same behaviour on x86 you can get if you use "__always_inline" instead of
>> "inline" for skb_copy_from_linear_data() in skbuff.h
>>
>> The call here copies data into inlined tx destricptor, which has 104 bytes
>> (MAX_INLINE) space for data payload. In this case "spc" is known in compile-time
>> but the destination is used with hidden knowledge (real structure of destination
>> is different from that the compiler can see). That cause the fortify warning
>> because compiler can check bounds, but the real bounds are different.
>> "spc" can't be bigger than 64 bytes (MLX4_INLINE_ALIGN), so the data can always
>> fit into inlined tx descriptor.
>> The fact that "inl" points into inlined tx descriptor is determined earlier
>> in mlx4_en_xmit().
>>
>> Fixes: f68f2ff91512c1 fortify: Detect struct member overflows in memcpy() at compile-time
>> Signed-off-by: Josef Oskera <joskera@redhat.com>
>> ---
>> drivers/net/ethernet/mellanox/mlx4/en_tx.c | 11 ++++++++++-
>> 1 file changed, 10 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/ethernet/mellanox/mlx4/en_tx.c b/drivers/net/ethernet/mellanox/mlx4/en_tx.c
>> index c5758637b7bed6..f30ca9fe90e5b4 100644
>> --- a/drivers/net/ethernet/mellanox/mlx4/en_tx.c
>> +++ b/drivers/net/ethernet/mellanox/mlx4/en_tx.c
>> @@ -719,7 +719,16 @@ static void build_inline_wqe(struct mlx4_en_tx_desc *tx_desc,
>> 			inl = (void *) (inl + 1) + spc;
>> 			memcpy(((void *)(inl + 1)), fragptr, skb->len - spc);
> 
> Using "unsafe" isn't the right solution here. What needs fixing is the "inl + 1" pattern which lacks any sense from the compilet's perspective. The struct of inl needs to end with a flex array, and it should be used for all the accesses. i.e. replace all the "inl + 1" instances with "inl->data". This makes it more readable for humans too. :)
> 
> I can send a patch...
> 

Although expanding the mlx4_wqe_inline_seg struct with a flex array 
sounds valid, I wouldn't go that way as it requires a larger change, 
touching common and RDMA code as well, for a driver in it's end-of-life 
stage.

We already have such unsafe_memcpy usage in mlx5 driver, so I can accept 
it here as well.

Let's keep the change as contained as possible.

Reviewed-by: Tariq Toukan <tariqt@nvidia.com>

> -Kees
> 
>> 		} else {
>> -			skb_copy_from_linear_data(skb, inl + 1, spc);
>> +			unsafe_memcpy(inl + 1, skb->data, spc,
>> +					/* This copies data into inlined tx descriptor, which has
>> +					 * 104 bytes (MAX_INLINE) space for data.
>> +					 * Real structure of destination is in this case hidden for
>> +					 * the compiler
>> +					 * "spc" is compile-time known variable and can't be bigger
>> +					 * than 64 (MLX4_INLINE_ALIGN).
>> +					 * Bounds and other conditions are checked in current
>> +					 * function and earlier in mlx4_en_xmit()
>> +					 */);
>> 			inl = (void *) (inl + 1) + spc;
>> 			skb_copy_from_linear_data_offset(skb, spc, inl + 1,
>> 							 hlen - spc);
> 
> 
