Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA4904C1819
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 17:06:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238750AbiBWQGc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 11:06:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235779AbiBWQGb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 11:06:31 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DFB3EC428C
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 08:06:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645632363;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xVbzqd1NeCGIqpgUYvhrKzUgw453gwC56Dfjy7i3kXE=;
        b=G7uQjfH65eKkG2jeDtBWjFFgbSRnHnNDX67TrRtABl/WkwCsdnfmMIigesfDoW3HlvqYI9
        BE6zbz8D5JZvlFjoWERasOSx7Sajurj5IWpjucr3B/oED5sOlBaFrA40Id7Z4pkvpUTvbX
        XefVOTRAMf1fKufu6DTyyUvIo3+ZmBc=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-657-RYK2r97NOSm5Sx5weQm24Q-1; Wed, 23 Feb 2022 11:06:01 -0500
X-MC-Unique: RYK2r97NOSm5Sx5weQm24Q-1
Received: by mail-lj1-f200.google.com with SMTP id k33-20020a05651c062100b002460b0e948dso7547309lje.13
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 08:06:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:message-id:date:mime-version:user-agent:cc
         :subject:content-language:to:references:in-reply-to
         :content-transfer-encoding;
        bh=xVbzqd1NeCGIqpgUYvhrKzUgw453gwC56Dfjy7i3kXE=;
        b=ZYNEkK0WYHXVrfyVW9aDXiDhL82FnnVtWqKQyn762211eYvzAgK7A4LukFf37UoC9I
         9shnRGXnqp/xohmLbS9TRRZ7Wy1c7LLkGjAwChiLow6r0OlQHj3KVxGhR0nJO92KZ9IL
         90bQu3Z7NrWW9aYJXWu3l3ZqAVBJdNXJVr3zF8DGukXjqEjtrnnzfdH8JqQrpLpcSfOI
         T18jsufTCJ3RjrulLoAoZZFgHP2rd3/cFHv85L/hJVE73/9K2UoE/cbnyTmWpuivAG+u
         E9d2AE5kx4Ebcqq/x386fK+zFAlcHrafvtwx7oWWC8KoQwBprCzFIeWQUKEWQRzSU2qe
         cCGQ==
X-Gm-Message-State: AOAM530HH812pX8hyenUcPa+tGizrZPly9WmP/AO+ZQFe9GLDuSDrjaJ
        FpFvPkSsBFQa0URZm+7SJvX1yAjfZ1oW5I5wRslTW4+k3lrxp+psuLZW4ITulNROwv1CaVxgXZg
        0GFSvbzdLXz3m/gn/
X-Received: by 2002:ac2:4c93:0:b0:439:74fc:a5bd with SMTP id d19-20020ac24c93000000b0043974fca5bdmr246554lfl.219.1645632359830;
        Wed, 23 Feb 2022 08:05:59 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzclO5+2i4H9GEVfGiZ6n0tZL6uLS6aJfel/j2Qsw7PCmRtAybNmXNmXMvQExzkKFypWUcPsw==
X-Received: by 2002:ac2:4c93:0:b0:439:74fc:a5bd with SMTP id d19-20020ac24c93000000b0043974fca5bdmr246517lfl.219.1645632359114;
        Wed, 23 Feb 2022 08:05:59 -0800 (PST)
Received: from [192.168.0.50] (87-59-106-155-cable.dk.customer.tdc.net. [87.59.106.155])
        by smtp.gmail.com with ESMTPSA id d10sm1687522lfs.204.2022.02.23.08.05.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Feb 2022 08:05:53 -0800 (PST)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <21c87173-667f-55c1-2eab-a1f684c75352@redhat.com>
Date:   Wed, 23 Feb 2022 17:05:51 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Cc:     brouer@redhat.com
Subject: Re: [net-next v6 1/2] page_pool: Add page_pool stats
Content-Language: en-US
To:     Joe Damato <jdamato@fastly.com>, netdev@vger.kernel.org,
        kuba@kernel.org, ilias.apalodimas@linaro.org, davem@davemloft.net,
        hawk@kernel.org, saeed@kernel.org, ttoukan.linux@gmail.com
References: <1645574424-60857-1-git-send-email-jdamato@fastly.com>
 <1645574424-60857-2-git-send-email-jdamato@fastly.com>
In-Reply-To: <1645574424-60857-2-git-send-email-jdamato@fastly.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 23/02/2022 01.00, Joe Damato wrote:
> Add per-cpu per-pool statistics counters for the allocation path of a page
> pool.
> 
> This code is disabled by default and a kernel config option is provided for
> users who wish to enable them.
> 
> The statistics added are:
> 	- fast: successful fast path allocations
> 	- slow: slow path order-0 allocations
> 	- slow_high_order: slow path high order allocations
> 	- empty: ptr ring is empty, so a slow path allocation was forced.
> 	- refill: an allocation which triggered a refill of the cache
> 	- waive: pages obtained from the ptr ring that cannot be added to
> 	  the cache due to a NUMA mismatch.
> 
> Signed-off-by: Joe Damato <jdamato@fastly.com>
> ---
>   include/net/page_pool.h | 18 ++++++++++++++++++
>   net/Kconfig             | 13 +++++++++++++
>   net/core/page_pool.c    | 37 +++++++++++++++++++++++++++++++++----
>   3 files changed, 64 insertions(+), 4 deletions(-)
> 
> diff --git a/include/net/page_pool.h b/include/net/page_pool.h
> index 97c3c19..bedc82f 100644
> --- a/include/net/page_pool.h
> +++ b/include/net/page_pool.h
> @@ -135,7 +135,25 @@ struct page_pool {
>   	refcount_t user_cnt;
>   
>   	u64 destroy_cnt;
> +#ifdef CONFIG_PAGE_POOL_STATS
> +	struct page_pool_stats __percpu *stats ____cacheline_aligned_in_smp;
> +#endif
> +};

Adding this to the end of the struct and using attribute 
____cacheline_aligned_in_smp cause the structure have a lot of wasted 
padding in the end.

I recommend using the tool pahole to see the struct layout.


> +
> +#ifdef CONFIG_PAGE_POOL_STATS
> +struct page_pool_stats {
> +	struct {
> +		u64 fast; /* fast path allocations */
> +		u64 slow; /* slow-path order 0 allocations */
> +		u64 slow_high_order; /* slow-path high order allocations */
> +		u64 empty; /* failed refills due to empty ptr ring, forcing
> +			    * slow path allocation
> +			    */
> +		u64 refill; /* allocations via successful refill */
> +		u64 waive;  /* failed refills due to numa zone mismatch */
> +	} alloc;
>   };
> +#endif

All of these stats are for page_pool allocation "RX" side, which is 
protected by softirq/NAPI.
Thus, I find it unnecessary to do __percpu stats.


As Ilias have pointed out-before, the __percpu stats (first) becomes 
relevant once we want stats for the free/"return" path ... which is not 
part of this patchset.

--Jesper

