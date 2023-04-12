Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD5226DEBFB
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 08:41:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229777AbjDLGlX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 02:41:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbjDLGlX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 02:41:23 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D49EA2683
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 23:41:21 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id v27so543176wra.13
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 23:41:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681281680; x=1683873680;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=TnmfpZzzgYOt53Mc9rr5ZalM/Mu4J5auFkHY0eFk60A=;
        b=WPErAQLFSZFdj2UwocPfQJST1aLpst4AXS9Y4kg4Kzqn2HpLsB2k1kgRRM28tFn1sF
         d03ZZdByaRotS/dS2jjheOzd4MJES1b/EedNDrvxZgxBYw++yMoBZJxSZhfuTLE4aQ3K
         uTiYFP09TrHzAG7pFpm4HV/Lm99FVvSxat+JS8x74BMzBmF1w6KHT/JbiaPIgpgl685+
         v22wh72FaVlu0qBjQVN2ms2HYz9T9GLiwHpj9F1Y8FFNThHJCISDtIIyxxcrEZlkE4hC
         h5qGOL1YM9GZQw/Di1zy/8Ws70lMUGIQ1l3CX+4swj0rgPCl8XItEepFG+hl2XF4s5Vf
         pzNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681281680; x=1683873680;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TnmfpZzzgYOt53Mc9rr5ZalM/Mu4J5auFkHY0eFk60A=;
        b=iC4CKbNzM5NAAIkEb6CUDIHQUUW5nXJNqphX0qiHNVjatXVMGj55WqTRrg66rBwe+1
         LPHF4mhP6pZoSAfIp9xGGxZYBSPQKZBuG1YVUhkcCfNPx4xVRWNFjDzWx8MDMWW3jhpv
         /hnM3Qu1Ef4Jmh0TajiAw5UXkxSDshqevY9cMFELOXjDtIJmBZRDrtRT4c0zCwLlKEU3
         z4nANGJFOgCc2uKLltDrHubaOg3/QuvFSnWzT7dWv4EKh6LGc+x8YI0/LLaHNZX5Vtia
         oCGLNQl0CXBFsLdailbN7pnmxRzqOimHMW8UoLMTzVrvMxBNseFTujAUsZp+0kSRt3hr
         QvPA==
X-Gm-Message-State: AAQBX9eev6RRynDXyHI3PdXP521/TbrKKZOmJ9RSYxnvWg6l3KzjJLjO
        lvL60a/Xdxd6yf2NmYFwdd4=
X-Google-Smtp-Source: AKy350ZE/EEI8uc/I9FGfgNrjcQKVbWBZmAARMR+72Fy0cCZ/uQuXlUOMLZxHci2YVaGh4h9X2lIYQ==
X-Received: by 2002:adf:e5cf:0:b0:2d4:d4ef:265c with SMTP id a15-20020adfe5cf000000b002d4d4ef265cmr9070295wrn.45.1681281680181;
        Tue, 11 Apr 2023 23:41:20 -0700 (PDT)
Received: from [192.168.0.106] ([77.126.33.94])
        by smtp.gmail.com with ESMTPSA id k23-20020a05600c0b5700b003eeb1d6a470sm1232487wmr.13.2023.04.11.23.41.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Apr 2023 23:41:19 -0700 (PDT)
Message-ID: <c433e59d-1262-656e-b08c-30adfc12edcc@gmail.com>
Date:   Wed, 12 Apr 2023 09:41:16 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH net-next 0/3] page_pool: allow caching from safely
 localized NAPI
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        hawk@kernel.org, ilias.apalodimas@linaro.org,
        linyunsheng@huawei.com, Dragos Tatulea <dtatulea@nvidia.com>
References: <20230411201800.596103-1-kuba@kernel.org>
From:   Tariq Toukan <ttoukan.linux@gmail.com>
In-Reply-To: <20230411201800.596103-1-kuba@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Happy holidays! I was traveling and couldn't review the RFCs.

Dragos and I had this task in our plans after our recent page pool work 
in mlx5e. We're so glad to see this patchset! :)

On 11/04/2023 23:17, Jakub Kicinski wrote:
> I went back to the explicit "are we in NAPI method", mostly
> because I don't like having both around :( (even tho I maintain
> that in_softirq() && !in_hardirq() is as safe, as softirqs do
> not nest).
> 
> Still returning the skbs to a CPU, tho, not to the NAPI instance.
> I reckon we could create a small refcounted struct per NAPI instance
> which would allow sockets and other users so hold a persisent
> and safe reference. But that's a bigger change, and I get 90+%
> recycling thru the cache with just these patches (for RR and
> streaming tests with 100% CPU use it's almost 100%).
> 
> Some numbers for streaming test with 100% CPU use (from previous version,
> but really they perform the same):
> 
> 		HW-GRO				page=page
> 		before		after		before		after
> recycle:
> cached:			0	138669686		0	150197505
> cache_full:		0	   223391		0	    74582
> ring:		138551933         9997191	149299454		0
> ring_full: 		0             488	     3154	   127590
> released_refcnt:	0		0		0		0
> 

Impressive.

Dragos tested your RFC v1.
He can test this one as well, expecting the same effect.

> alloc:
> fast:		136491361	148615710	146969587	150322859
> slow:		     1772	     1799	      144	      105
> slow_high_order:	0		0		0		0
> empty:		     1772	     1799	      144	      105
> refill:		  2165245	   156302	  2332880	     2128
> waive:			0		0		0		0
> 

General note:
For fragmented page-pool pages, the decision to whether go though the 
cache or the ring depends only on the last releasing thread and its context.

Our in-driver deferred release trick is in many cases beneficial even in 
the presence of this idea. The sets of cases improved by each idea 
intersect, but are not completely identical.
That's why we decided to go with both solutions working together, and 
not only one.

> v1:
>   - rename the arg in_normal_napi -> napi_safe
>   - also allow recycling in __kfree_skb_defer()
> rfcv2: https://lore.kernel.org/all/20230405232100.103392-1-kuba@kernel.org/
> 
> Jakub Kicinski (3):
>    net: skb: plumb napi state thru skb freeing paths
>    page_pool: allow caching from safely localized NAPI
>    bnxt: hook NAPIs to page pools
> 
>   Documentation/networking/page_pool.rst    |  1 +
>   drivers/net/ethernet/broadcom/bnxt/bnxt.c |  1 +
>   include/linux/netdevice.h                 |  3 ++
>   include/linux/skbuff.h                    | 20 +++++++----
>   include/net/page_pool.h                   |  3 +-
>   net/core/dev.c                            |  3 ++
>   net/core/page_pool.c                      | 15 ++++++--
>   net/core/skbuff.c                         | 42 ++++++++++++-----------
>   8 files changed, 58 insertions(+), 30 deletions(-)
> 

