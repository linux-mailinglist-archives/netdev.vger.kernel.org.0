Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 887324B7365
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 17:43:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240944AbiBOPp7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 10:45:59 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241018AbiBOPpc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 10:45:32 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E86A7DD
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 07:41:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644939696;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XnjN13+xXUCLXLUyyHPqEE7jFZe8PZEC1H4VOOCMpQ0=;
        b=R+TBwLwLAxT8hF23k9RPr9Udlunr6p3t2yXwvc19U3JIea1/5NpKKUOJXuZ8H6OjB91SvM
        rvjj2OhiKYkhFbycU1Rw7oFDcrd8FNfcMq3Wg/PmbpXa0CHdP0F1Jn/p4jm+CafXwzanLG
        TxEdcLv15R2daQgujG3AcB+IAPU5WqE=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-336-K_bBeuQEMI6R1YSNQYM7RQ-1; Tue, 15 Feb 2022 10:41:35 -0500
X-MC-Unique: K_bBeuQEMI6R1YSNQYM7RQ-1
Received: by mail-lf1-f69.google.com with SMTP id o25-20020a05651205d900b0043e6c10892bso6282168lfo.14
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 07:41:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:message-id:date:mime-version:user-agent:cc
         :subject:content-language:to:references:in-reply-to
         :content-transfer-encoding;
        bh=XnjN13+xXUCLXLUyyHPqEE7jFZe8PZEC1H4VOOCMpQ0=;
        b=47qU8/eUgDJAp96DvxY48t6Vh/Y4r6/4QHUJFWkV6XmBKKQ/14NrawfhjlhBtLajgP
         5MpWlbqCjRtQwTbrEwu2la9hgtS2X8+FjZKwtQDnASVc50Gb5woXVV7xjthd5NIfsaBI
         h24vp/l56A4T8Trwt+Kv/nYX5VIa8ko9fqHCQCg5goITWSIQF7SJAhX3qDwdhP6OyRr3
         K5KCZs0mKxdUuCXfHmGjc/00kqGWkjbYIdTfH3f9/dzv4q+JNqE4xO5IWfqqIc/9Wz/l
         UujlDDgTqGpvKbCk5lWhKA6um6Ymwuip5Fth+vp0sz+wYNmlGKwjVzn6dploq49YCfe7
         ktWw==
X-Gm-Message-State: AOAM5334IcYbShXB/vUtHvcPAmAf8RfWRD5diFWo0hf2ZHGyB+jMNusV
        ZHHdVi9u0nHDsIyTySffWCAELCDlY+b6gwl/aCyS349HFDAZEw5Hhnm8hNqCcBlwPRyMhZsBafS
        8xs6hXgO5KN11RmKk
X-Received: by 2002:a05:651c:1718:: with SMTP id be24mr2622783ljb.496.1644939693787;
        Tue, 15 Feb 2022 07:41:33 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzNrIqWFLQhAszoWSInJJ1YhRD7UFCch+OAAmnQ4AFJJ/4TqJNwFa5XLhJ4EGWtLQTJqrIKKQ==
X-Received: by 2002:a05:651c:1718:: with SMTP id be24mr2622775ljb.496.1644939693558;
        Tue, 15 Feb 2022 07:41:33 -0800 (PST)
Received: from [192.168.0.50] (87-59-106-155-cable.dk.customer.tdc.net. [87.59.106.155])
        by smtp.gmail.com with ESMTPSA id f24sm4564016lfk.221.2022.02.15.07.41.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Feb 2022 07:41:32 -0800 (PST)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <ed575c4e-774a-2118-f6bf-c8725d2739e8@redhat.com>
Date:   Tue, 15 Feb 2022 16:41:31 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Cc:     brouer@redhat.com
Subject: Re: [net-next v5 1/2] page_pool: Add page_pool stat counters
Content-Language: en-US
To:     Joe Damato <jdamato@fastly.com>, netdev@vger.kernel.org,
        kuba@kernel.org, ilias.apalodimas@linaro.org, davem@davemloft.net,
        hawk@kernel.org, saeed@kernel.org, ttoukan.linux@gmail.com
References: <1644868949-24506-1-git-send-email-jdamato@fastly.com>
 <1644868949-24506-2-git-send-email-jdamato@fastly.com>
In-Reply-To: <1644868949-24506-2-git-send-email-jdamato@fastly.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 14/02/2022 21.02, Joe Damato wrote:
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
> index 97c3c19..d827ab1 100644
> --- a/include/net/page_pool.h
> +++ b/include/net/page_pool.h
> @@ -135,7 +135,25 @@ struct page_pool {
>   	refcount_t user_cnt;
>   
>   	u64 destroy_cnt;
> +#ifdef CONFIG_PAGE_POOL_STATS
> +	struct page_pool_stats __percpu *stats;
> +#endif
> +};

You still have to consider cache-line locality, as I have pointed out 
before.
This placement is wrong!

Output from pahole:

  /* --- cacheline 23 boundary (1472 bytes) --- */
  atomic_t                   pages_state_release_cnt; /*  1472     4 */
  refcount_t                 user_cnt;             /*  1476     4 */
  u64                        destroy_cnt;          /*  1480     8 */

Your *stats pointer end-up on a cache-line that "remote" CPUs will write 
into (pages_state_release_cnt).
This is why we see a slowdown to the 'bench_page_pool_cross_cpu' test.

--Jesper

