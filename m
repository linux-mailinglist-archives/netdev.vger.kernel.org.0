Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EADB45B0E4D
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 22:40:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229720AbiIGUks (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 16:40:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiIGUkp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 16:40:45 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EA96BCCE1
        for <netdev@vger.kernel.org>; Wed,  7 Sep 2022 13:40:43 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id x1so11394398plv.5
        for <netdev@vger.kernel.org>; Wed, 07 Sep 2022 13:40:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=ifTJWgUBZuhYPn1CCxpPML/WHgW9WCVjXotHpDzf0Vw=;
        b=pwGxOv0hdSLtPAzib/aSrdLbUF4LzPqYnfoZQt3ylKk1/poeog58+AiO5/5AwaxY9F
         yNok49R032A3jfwl+Hq5Ruoq5ZqoljABacBtYuEmCLORlfYYdMHogrV3IjyA0dgV7iOv
         SVHJ1F8HMkrrUBcg3gLAWQU4eHJoV9bLSYp9yLZFeO6XmwjDEbuyAvnKkf3zuG4rWkxd
         w/TYU4UCeafuIrXaBxuXrX1TeIagoMyOrvWkWlXTgOI5NV6gyz6oPlZ/P3VasFEIKxlM
         nxlLzSZiDP3+JMNTeA+3LBHePAyNhE/GUtqg4pzYBOz/YhMUVARNpI+VHSDyGQ65mdD8
         cmOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=ifTJWgUBZuhYPn1CCxpPML/WHgW9WCVjXotHpDzf0Vw=;
        b=G3zI0vyrpLMbGKVzn9KJB3ZBUTmIdfs9Ipq7wVcDl7RFpUwEJQD43toRtGFUYVneJ5
         eATYlrI93IZcpW+pZkTS3O/fG0PVLz5bVgo9+Sk/4cQqebXWw0sYEi31Rn1ZnnYTRuts
         EHZ64LaK1KbFenmhhyemgC1N62FT3qx0wcvPXORY+WwYGQFtY/gRdhN3TO+3B4XnQbeR
         hhpQKSkKv8QcSMDzuBlaMr0PZA/Fkjuq0y/JjFJtGb1EiIyDekEvKicFpYSkaQB7cfeR
         l9Idvfo+fpfuJEEg7wj1zuHhcNLzPIKDToZpa+ncaBjYe6Y0mfvfJRkhsdElUZlNDYfx
         tpUQ==
X-Gm-Message-State: ACgBeo3YJ4gdd6JtTvWlHMWnG/xQMpoF2cCFD8TF2LaHsSBPjbn7xEgG
        i22P/bj35BDvsTxBqy/n0g8=
X-Google-Smtp-Source: AA6agR5NSNTx/6DprKO4z6LCre6r04VHaV1hxbW5OpUcQQ8lP6lpOq8qIRC6herTpzOIPF/CpgtR8w==
X-Received: by 2002:a17:902:d509:b0:16f:1e1:2063 with SMTP id b9-20020a170902d50900b0016f01e12063mr5274180plg.131.1662583243022;
        Wed, 07 Sep 2022 13:40:43 -0700 (PDT)
Received: from ?IPV6:2620:15c:2c1:200:ccca:4aae:967f:c6c9? ([2620:15c:2c1:200:ccca:4aae:967f:c6c9])
        by smtp.gmail.com with ESMTPSA id oa11-20020a17090b1bcb00b002007b60e288sm58211pjb.23.2022.09.07.13.40.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Sep 2022 13:40:42 -0700 (PDT)
Message-ID: <66c8b7c2-25a6-2834-b341-22b6498e3f7e@gmail.com>
Date:   Wed, 7 Sep 2022 13:40:40 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH net] net: avoid 32 x truesize under-estimation for tiny
 skbs
Content-Language: en-US
To:     Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Alexander Duyck <alexanderduyck@fb.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Greg Thelen <gthelen@google.com>
References: <20210113161819.1155526-1-eric.dumazet@gmail.com>
 <bd79ede94805326cd63f105c84f1eaa4e75c8176.camel@redhat.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
In-Reply-To: <bd79ede94805326cd63f105c84f1eaa4e75c8176.camel@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 9/7/22 13:19, Paolo Abeni wrote:
> Hello,
>
> reviving an old thread...
> On Wed, 2021-01-13 at 08:18 -0800, Eric Dumazet wrote:
>> While using page fragments instead of a kmalloc backed skb->head might give
>> a small performance improvement in some cases, there is a huge risk of
>> under estimating memory usage.
> [...]
>
>> Note that we might in the future use the sk_buff napi cache,
>> instead of going through a more expensive __alloc_skb()
>>
>> Another idea would be to use separate page sizes depending
>> on the allocated length (to never have more than 4 frags per page)
> I'm investigating a couple of performance regressions pointing to this
> change and I'd like to have a try to the 2nd suggestion above.
>
> If I read correctly, it means:
> - extend the page_frag_cache alloc API to allow forcing max order==0
> - add a 2nd page_frag_cache into napi_alloc_cache (say page_order0 or
> page_small)
> - in __napi_alloc_skb(), when len <= SKB_WITH_OVERHEAD(1024), use the
> page_small cache with order 0 allocation.
> (all the above constrained to host with 4K pages)
>
> I'm not quite sure about the "never have more than 4 frags per page"
> part.
>
> What outlined above will allow for 10 min size frags in page_order0, as
> (SKB_DATA_ALIGN(0) + SKB_DATA_ALIGN(struct skb_shared_info) == 384. I'm
> not sure that anything will allocate such small frags.
> With a more reasonable GRO_MAX_HEAD, there will be 6 frags per page.


Well, some arches have PAGE_SIZE=65536 :/


>
> The maximum truesize underestimation in both cases will be lower than
> what we can get with the current code in the worst case (almost 32x
> AFAICS).
>
> Is the above schema safe enough or should the requested size
> artificially inflatted to fit at most 4 allocations per page_order0?
> Am I miss something else? Apart from omitting a good deal of testing in
> the above list ;)
>
> Thanks!
>
> Paolo
>
