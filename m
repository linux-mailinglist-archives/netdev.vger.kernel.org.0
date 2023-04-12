Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4237D6DEC23
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 08:56:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229784AbjDLG4h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 02:56:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbjDLG4g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 02:56:36 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBFDE4C2C
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 23:56:34 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id s8so5891096wmo.0
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 23:56:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681282593; x=1683874593;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rGATHatjS1MK7opOlnLYubOhidDFlFms4f+qBGRKUe4=;
        b=EwadGAhT+yYsw6GmPlV79d2LLPexJ40NlKJHMmZSbqAwwFkNg4gAKpDDvZvBjDRQCQ
         SA30k//dHOJrwN6fVysRG4VhIOq27JcBh1QKP4hT3HoEwFGhMAkhXGCf/1CgmLrK8rLf
         +NIZn4La1IQgE7ujhCS9X0aUdp9KSsJHm+i89hBwYROIOJ+KxAuMKFULHtq4A9hMVVnu
         nfDlZ/+1FdhsFrxsQNxDYV0/Zvm+IjpAgbr8Xo5R7KXDSksSTl+qqWVWS3+KG/TzGNE2
         jbbkwHsSCUfU27MSF/+ZAhS3KrudZql93iQqA8jBh2e3zxH6X1RjttZ4f3bEgEiQ6zd8
         ZpwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681282593; x=1683874593;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rGATHatjS1MK7opOlnLYubOhidDFlFms4f+qBGRKUe4=;
        b=dVjSs69okWOPPYLC3PzHVvQMNSaOJh/ai5qLnIMelSpxGqxdu9I6BeLAsU6pUhrjAG
         /wReK0e1ziwIbN5pxmTC95iUJ0KvvCXyi6br0YM43Yk5A8COrz2EHGQaDY6cGYtsLlm6
         qWSUSfVP5EDAIlh3v44JmMGcaGf7LwPnrhSO/BwfDJ7sAsO6ZH53jmO9z+AjRdfqdA4T
         CKpnppfzD8yHaqYDx4Bv3c6qGalUq+9dBwgf60FHQ0Q7lZPGfxUggHs/kyb+bER3kbY9
         oyHwYsTdgJA/IGMEB9WpSSxGQYrOep7KuLIeKLVUmwBIzFTI0/lqfT5bMdgyAFRxW37g
         OwiQ==
X-Gm-Message-State: AAQBX9e8dLK65cVdKcQ2m1lVqI86xPZJZKufNKBBWUkNDpVzUrMa+hD4
        DoTsr/ZlhfUpdgcL2p6VM8M=
X-Google-Smtp-Source: AKy350br/Y3P/p+F8pReJ7KWUBY1vMRiTINXtfhGhDQWoEn4Zr9A/GCfiQ59lMNrTXhYw2tf3cQ/kA==
X-Received: by 2002:a1c:7917:0:b0:3f0:9f28:fb6c with SMTP id l23-20020a1c7917000000b003f09f28fb6cmr411978wme.12.1681282593304;
        Tue, 11 Apr 2023 23:56:33 -0700 (PDT)
Received: from [192.168.0.106] ([77.126.33.94])
        by smtp.gmail.com with ESMTPSA id h16-20020a5d5490000000b002c8476dde7asm16307863wrv.114.2023.04.11.23.56.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Apr 2023 23:56:32 -0700 (PDT)
Message-ID: <d8585228-da36-7b19-67f6-1aadb301e39a@gmail.com>
Date:   Wed, 12 Apr 2023 09:56:29 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH net-next 0/3] page_pool: allow caching from safely
 localized NAPI
Content-Language: en-US
From:   Tariq Toukan <ttoukan.linux@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        hawk@kernel.org, ilias.apalodimas@linaro.org,
        linyunsheng@huawei.com, Dragos Tatulea <dtatulea@nvidia.com>,
        Gal Pressman <gal@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>
References: <20230411201800.596103-1-kuba@kernel.org>
 <c433e59d-1262-656e-b08c-30adfc12edcc@gmail.com>
In-Reply-To: <c433e59d-1262-656e-b08c-30adfc12edcc@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/04/2023 9:41, Tariq Toukan wrote:
> Hi,
> 
> Happy holidays! I was traveling and couldn't review the RFCs.
> 
> Dragos and I had this task in our plans after our recent page pool work 
> in mlx5e. We're so glad to see this patchset! :)
> 
> On 11/04/2023 23:17, Jakub Kicinski wrote:
>> I went back to the explicit "are we in NAPI method", mostly
>> because I don't like having both around :( (even tho I maintain
>> that in_softirq() && !in_hardirq() is as safe, as softirqs do
>> not nest).
>>
>> Still returning the skbs to a CPU, tho, not to the NAPI instance.
>> I reckon we could create a small refcounted struct per NAPI instance
>> which would allow sockets and other users so hold a persisent
>> and safe reference. But that's a bigger change, and I get 90+%
>> recycling thru the cache with just these patches (for RR and
>> streaming tests with 100% CPU use it's almost 100%).
>>
>> Some numbers for streaming test with 100% CPU use (from previous version,
>> but really they perform the same):
>>
>>         HW-GRO                page=page
>>         before        after        before        after
>> recycle:
>> cached:            0    138669686        0    150197505
>> cache_full:        0       223391        0        74582
>> ring:        138551933         9997191    149299454        0
>> ring_full:         0             488         3154       127590
>> released_refcnt:    0        0        0        0
>>
> 
> Impressive.
> 
> Dragos tested your RFC v1.
> He can test this one as well, expecting the same effect.
> 
>> alloc:
>> fast:        136491361    148615710    146969587    150322859
>> slow:             1772         1799          144          105
>> slow_high_order:    0        0        0        0
>> empty:             1772         1799          144          105
>> refill:          2165245       156302      2332880         2128
>> waive:            0        0        0        0
>>
> 
> General note:
> For fragmented page-pool pages, the decision to whether go though the 
> cache or the ring depends only on the last releasing thread and its 
> context.
> 
> Our in-driver deferred release trick is in many cases beneficial even in 
> the presence of this idea. The sets of cases improved by each idea 
> intersect, but are not completely identical.
> That's why we decided to go with both solutions working together, and 
> not only one.
> 
>> v1:
>>   - rename the arg in_normal_napi -> napi_safe
>>   - also allow recycling in __kfree_skb_defer()
>> rfcv2: 
>> https://lore.kernel.org/all/20230405232100.103392-1-kuba@kernel.org/
>>
>> Jakub Kicinski (3):
>>    net: skb: plumb napi state thru skb freeing paths
>>    page_pool: allow caching from safely localized NAPI
>>    bnxt: hook NAPIs to page pools
>>
>>   Documentation/networking/page_pool.rst    |  1 +
>>   drivers/net/ethernet/broadcom/bnxt/bnxt.c |  1 +
>>   include/linux/netdevice.h                 |  3 ++
>>   include/linux/skbuff.h                    | 20 +++++++----
>>   include/net/page_pool.h                   |  3 +-
>>   net/core/dev.c                            |  3 ++
>>   net/core/page_pool.c                      | 15 ++++++--
>>   net/core/skbuff.c                         | 42 ++++++++++++-----------
>>   8 files changed, 58 insertions(+), 30 deletions(-)
>>
> 

Reviewed-by: Tariq Toukan <tariqt@nvidia.com>

We'll push a patch to enable it in mlx5e immediately once this is accepted.
