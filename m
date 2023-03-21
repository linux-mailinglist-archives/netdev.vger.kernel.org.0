Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 797DD6C2B1F
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 08:14:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230283AbjCUHOL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 03:14:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229872AbjCUHOG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 03:14:06 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1382359FF
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 00:14:04 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id cn12so10255460edb.4
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 00:14:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679382842;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=EXhKSrhNX1mLLaGjNGkuT0dWzXtu6CNdyLBRaVkrkuI=;
        b=f+NT8rDWIAI+1eFt3ZpnTJe12xGarSwQk13gOofbNUoW+aVwZu4Was4XupvnZqHJ8C
         yGq0ErQeuMnE7o588EW6pbiCQQbILe1zzPpCwBXIQnyk59or1KQk3xu4mjqNa1RZ4q4X
         w2WDCE1owlsHHt27qmdK2Q5+e3q+j16PJ41y0sUUZnXVSQd5v+tzZUToLucr8WMKPioG
         F5O1oNk1wUY9mPnG7mNfy4l52xCQysiqWqY+BAvYvFGSq+dURMwVsPGpcwxYJWnQRa/M
         nYDH9oJqxe8TILQW0rJaLhmMXyKq47jkvwUJf2mktK4VCrQ8bmyGp2jKlsz4g1591HmS
         4vrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679382842;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EXhKSrhNX1mLLaGjNGkuT0dWzXtu6CNdyLBRaVkrkuI=;
        b=B33bwkArxF5bO4CwRA/LVMEL6tE8Tx2BiYOLz+KQcJjSuW9CyD5cpvd9cgSvzeUPw5
         CvTXTPK4M59Pc2yj0vnZCUtEF1YwCWbhsQ4RpZR6RhJsoxNLZkt0E5fQ1pDN//daEMYP
         IyS2noxIAUnkh4lHYgvTP/9hDht0VoYvUlxzzmsJ6VYqZBs/lyOwUiSzbQyPAcLrifRu
         uS7+Vd5ebXu6j9vC2OKGS4sx6QDhEiku5cXxCmYUkIQU6kNJdgZkm0lVTclJipvhYFEo
         5rh1GXF3clXEtL/xBqvvnEKkBCdd5kzkeBx12u7TEKP1jEuu4FDWQeKiaQAn19LVE1Au
         6BHg==
X-Gm-Message-State: AO0yUKWvUmH3e+kRHd7+jPVvPFUW+kEtVGBARK0IdOJ4tZtMegAeI+ne
        77YkdpF8yfz6NXW9TcvR7kE=
X-Google-Smtp-Source: AK7set8navjQsC+q4z6GxbGVm2IZNwfO61XqwiImO9+hxTjFp9dj/pqt7pMxPilf+GomyhMj7HPFoQ==
X-Received: by 2002:a05:6402:c:b0:4fc:73dc:5def with SMTP id d12-20020a056402000c00b004fc73dc5defmr1844933edu.41.1679382842287;
        Tue, 21 Mar 2023 00:14:02 -0700 (PDT)
Received: from [192.168.1.115] ([77.124.35.101])
        by smtp.gmail.com with ESMTPSA id v15-20020a50c40f000000b004d8d2735251sm5875148edf.43.2023.03.21.00.14.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Mar 2023 00:14:01 -0700 (PDT)
Message-ID: <5cb9703b-7a6c-7f75-b8d8-38095537e8dc@gmail.com>
Date:   Tue, 21 Mar 2023 09:13:59 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH net-next] net: introduce a config option to tweak
 MAX_SKB_FRAGS
Content-Language: en-US
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Tariq Toukan <tariqt@nvidia.com>
References: <20230321033704.936685-1-eric.dumazet@gmail.com>
From:   Tariq Toukan <ttoukan.linux@gmail.com>
In-Reply-To: <20230321033704.936685-1-eric.dumazet@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 21/03/2023 5:37, Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> Currently, MAX_SKB_FRAGS value is 17.
> 
> For standard tcp sendmsg() traffic, no big deal because tcp_sendmsg()
> attempts order-3 allocations, stuffing 32768 bytes per frag.
> 
> But with zero copy, we use order-0 pages.
> 
> For BIG TCP to show its full potential, we add a config option
> to be able to fit up to 45 segments per skb.
> 
> This is also needed for BIG TCP rx zerocopy, as zerocopy currently
> does not support skbs with frag list.
> 
> We have used MAX_SKB_FRAGS=45 value for years [1] at Google before
> we deployed 4K MTU, with no adverse effect, other than
> a recent issue in mlx4, fixed in commit 26782aad00cc
> ("net/mlx4: MLX4_TX_BOUNCE_BUFFER_SIZE depends on MAX_SKB_FRAGS")
> 
> [1] Back then, goal was to be able to receive full size (64KB) GRO
> packets without the frag_list overhead.
> 
> By default we keep the old/legacy value of 17 until we get
> more coverage for the updated values.
> 
> Sizes of struct skb_shared_info on 64bit arches:
> 
> MAX_SKB_FRAGS | sizeof(struct skb_shared_info)
> ==============================================
>           17     320
>           21     320+64  = 384
>           25     320+128 = 448
>           29     320+192 = 512
>           33     320+256 = 576
>           37     320+320 = 640
>           41     320+384 = 704
>           45     320+448 = 768
> 
> This inflation might cause problems for drivers assuming they could pack
> both the incoming packet and skb_shared_info in half a page, using build_skb().
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> ---
>   include/linux/skbuff.h | 14 ++------------
>   net/Kconfig            | 12 ++++++++++++
>   2 files changed, 14 insertions(+), 12 deletions(-)
> 
> diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> index fe661011644b8f468ff5e92075a6624f0557584c..43726ca7d20f232461a4d2e5b984032806e9c13e 100644
> --- a/include/linux/skbuff.h
> +++ b/include/linux/skbuff.h
> @@ -345,18 +345,8 @@ struct sk_buff_head {
>   
>   struct sk_buff;
>   
> -/* To allow 64K frame to be packed as single skb without frag_list we
> - * require 64K/PAGE_SIZE pages plus 1 additional page to allow for
> - * buffers which do not start on a page boundary.
> - *
> - * Since GRO uses frags we allocate at least 16 regardless of page
> - * size.
> - */
> -#if (65536/PAGE_SIZE + 1) < 16
> -#define MAX_SKB_FRAGS 16UL

Default value now changes for this case.
Shouldn't we preserve it?

> -#else
> -#define MAX_SKB_FRAGS (65536/PAGE_SIZE + 1)
> -#endif
> +#define MAX_SKB_FRAGS CONFIG_MAX_SKB_FRAGS
> +
>   extern int sysctl_max_skb_frags;
>   
>   /* Set skb_shinfo(skb)->gso_size to this in case you want skb_segment to
> diff --git a/net/Kconfig b/net/Kconfig
> index 48c33c2221999e575c83a409ab773b9cc3656eab..f806722bccf450c62e07bfdb245e5195ac4a156d 100644
> --- a/net/Kconfig
> +++ b/net/Kconfig
> @@ -251,6 +251,18 @@ config PCPU_DEV_REFCNT
>   	  network device refcount are using per cpu variables if this option is set.
>   	  This can be forced to N to detect underflows (with a performance drop).
>   
> +config MAX_SKB_FRAGS
> +	int "Maximum number of fragments per skb_shared_info"
> +	range 17 45
> +	default 17
> +	help
> +	  Having more fragments per skb_shared_info can help GRO efficiency.
> +	  This helps BIG TCP workloads, but might expose bugs in some
> +	  legacy drivers.
> +	  This also increases memory overhead of small packets,
> +	  and in drivers using build_skb().
> +	  If unsure, say 17.
> +
>   config RPS
>   	bool
>   	depends on SMP && SYSFS
