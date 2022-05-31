Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11B48539A30
	for <lists+netdev@lfdr.de>; Wed,  1 Jun 2022 01:47:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348737AbiEaXpr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 May 2022 19:45:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348856AbiEaXpi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 May 2022 19:45:38 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B6F39CF7C;
        Tue, 31 May 2022 16:45:34 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id u18so186171plb.3;
        Tue, 31 May 2022 16:45:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=Ih36/gycPe5v27oOsRC0FfKWnoaY9b8aOJdexOvR9ik=;
        b=loBw4lDu2zlmYiEiDfFp/7PSreINSjGVtMPRhUMsvq01MK7Z24fDXVITXdqBxOyjrJ
         kin08LrU2rPoO7rLQLpUURuFf1SOK9X4Wm49oXn8CRWnNtTSFljqs/Ad8whOWOiEQz/b
         PbzzTBJvBtXCIrybe8MOS7kQXLhBaN7urG2sxfP6NmVjToYcBbh1MKmnHQgiO7WEwOEa
         Dxpm65dX4sa18f+Qyy/g2v4lnUWoNs7XBPNEk06gDmT6mFOrgXh74gFZ3sSd0kfU4SEB
         +lVLvB/vx7I9vSy+5VHhFVMSdRfWuQCz7oG4px1gflWULtI0X5ptdfwGRhjKkvXIjtJd
         2+tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Ih36/gycPe5v27oOsRC0FfKWnoaY9b8aOJdexOvR9ik=;
        b=DTeNKmYC3oxors0IS5aT59hLLy3hzGZKQBtFjgwggkeRWXfdDGEjgXV2dx5qds+JhO
         fZjqdlB5rtE5rAMLEG93HUKeFJ9+PwbJ/TmVd4rLUfmKYlEm7rRgHdARztLdesANEGCF
         wIspvCbrgNN00aQyCkihezQj9ZF9nC5sRBfk0fK1SrBCUZ436aqwu1viQOVaf3yfsBhd
         i2+NYbCp8T7pmCizxlTeFyfQzPrp3OhrQ/9aDgziVRnucJG1O3qPSmbn7XYb77YTrNNh
         JEmsSnJA3xSCdF38n7jNknaUdVPWSrLeW/82N4W07sVIu5CY880HELRKkeKziSwhvxF1
         ccTg==
X-Gm-Message-State: AOAM533KfcwGbhULw51FPOGiiLRX0m5D0B3P3+pGppHTXa6HupVkBICw
        JjzRJaU63B13zKm+nmPJrWc=
X-Google-Smtp-Source: ABdhPJzt9oe3/VKz9x9Uuk/J91VP45w4e5iJc/tjCMZBe4dDyD4G9tKzZQcQ56l2zvsuBhoykGV3bg==
X-Received: by 2002:a17:902:b58b:b0:162:2e01:9442 with SMTP id a11-20020a170902b58b00b001622e019442mr42900573pls.6.1654040734054;
        Tue, 31 May 2022 16:45:34 -0700 (PDT)
Received: from ?IPV6:2620:15c:2c1:200:6be8:4de7:1334:9fa2? ([2620:15c:2c1:200:6be8:4de7:1334:9fa2])
        by smtp.gmail.com with ESMTPSA id a15-20020a62e20f000000b0051bac6d2603sm6459pfi.214.2022.05.31.16.45.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 31 May 2022 16:45:33 -0700 (PDT)
Message-ID: <b711ca5f-4180-d658-a330-89bd5dcb0acb@gmail.com>
Date:   Tue, 31 May 2022 16:45:31 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v3] mm: page_frag: Warn_on when frag_alloc size is bigger
 than PAGE_SIZE
Content-Language: en-US
To:     Chen Lin <chen45464546@163.com>, akpm@linux-foundation.org
Cc:     kuba@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        alexander.duyck@gmail.com, netdev@vger.kernel.org
References: <20220530130705.29c5fa4a5225265d3736bfa4@linux-foundation.org>
 <1654008188-3183-1-git-send-email-chen45464546@163.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
In-Reply-To: <1654008188-3183-1-git-send-email-chen45464546@163.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 5/31/22 07:43, Chen Lin wrote:
> netdev_alloc_frag->page_frag_alloc may cause memory corruption in
> the following process:
>
> 1. A netdev_alloc_frag function call need alloc 200 Bytes to build a skb.
>
> 2. Insufficient memory to alloc PAGE_FRAG_CACHE_MAX_ORDER(32K) in
> __page_frag_cache_refill to fill frag cache, then one page(eg:4K)
> is allocated, now current frag cache is 4K, alloc is success,
> nc->pagecnt_bias--.
>
> 3. Then this 200 bytes skb in step 1 is freed, page->_refcount--.
>
> 4. Another netdev_alloc_frag function call need alloc 5k, page->_refcount
> is equal to nc->pagecnt_bias, reset page count bias and offset to
> start of new frag. page_frag_alloc will return the 4K memory for a
> 5K memory request.
>
> 5. The caller write on the extra 1k memory which is not actual allocated
> will cause memory corruption.
>
> page_frag_alloc is for fragmented allocation. We should warn the caller
> to avoid memory corruption.
>
> When fragsz is larger than one page, we report the failure and return.
> I don't think it is a good idea to make efforts to support the
> allocation of more than one page in this function because the total
> frag cache size(PAGE_FRAG_CACHE_MAX_SIZE 32768) is relatively small.
> When the request is larger than one page, the caller should switch to
> use other kernel interfaces, such as kmalloc and alloc_Pages.
>
> This bug is mainly caused by the reuse of the previously allocated
> frag cache memory by the following LARGER allocations. This bug existed
> before page_frag_alloc was ported from __netdev_alloc_frag in
> net/core/skbuff.c, so most Linux versions have this problem.
>
> Signed-off-by: Chen Lin <chen45464546@163.com>
> ---
>   mm/page_alloc.c |    9 +++++++++
>   1 file changed, 9 insertions(+)
>
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index e008a3d..ffc42b5 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -5574,6 +5574,15 @@ void *page_frag_alloc_align(struct page_frag_cache *nc,
>   	struct page *page;
>   	int offset;
>   
> +	/*
> +	 * frag_alloc is not suitable for memory alloc which fragsz
> +	 * is bigger than PAGE_SIZE, use kmalloc or alloc_pages instead.
> +	 */
> +	if (WARN_ONCE(fragz > PAGE_SIZE,
> +		      "alloc fragsz(%d) > PAGE_SIZE(%ld) not supported, alloc fail\n",
> +		      fragsz, PAGE_SIZE))
> +		return NULL;
> +
>   	if (unlikely(!nc->va)) {
>   refill:
>   		page = __page_frag_cache_refill(nc, gfp_mask);


I do not think this patch is needed, nor correct. (panic_on_warn=1 will 
panic the box)

Or provide a stack trace ?

Please fix the caller (presumably a network driver ?), and provide an 
appropriate Fixes: tag.

Thanks.


