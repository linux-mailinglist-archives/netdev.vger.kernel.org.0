Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71262663F86
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 12:51:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237994AbjAJLva (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 06:51:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234969AbjAJLvQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 06:51:16 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77F78544F4
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 03:51:15 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id hw16so16028672ejc.10
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 03:51:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=oIbZQnJAFxgeIrjHC0H2OUIydFF5+euWS8BmOxj9K6w=;
        b=yaD4qKIBgAiTLoy06qkRsdxkIAe5twpsxNRFy9IE57YUXS4myjzV+/pNefYu+IwdKk
         I8MFndRXiNQFNvn1dAlRF2ym7XF2Z3rXZweBL72fkGZXpH0VwSitk0mU6/GzEMsdnZpY
         B8ZZMi917+ktvrZgMO2zohbY6KVlb5iP2N+VwtQoTiE5l2dzELgad113p+h4nkf8N54X
         Wwe582FK8V6o44TfsgUzbqK0qVZUj0b3ZbfHmyXmXAwx7h2dQL6YQsqBmeymZhLjLlAQ
         mES9rSaPS43gyiA0n3Fx95OgWC2etUQM6+wsB76jI9K1ypCbOQS1CIImYzAHGSeSIHRe
         JtvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oIbZQnJAFxgeIrjHC0H2OUIydFF5+euWS8BmOxj9K6w=;
        b=iQ/+5o83rHzk1jvM94O5Wld2TYq3XRW86+IrvUEKxCehKHfhWudWaAAL1HvrPT4Ced
         ZpBHUbSGcH+SNdEMpBAW/NI4OHM2NqVhCziizwTAtv6+hUXq8mQN7Lp71P5PQyYCFwQV
         9hiXyHCj9PP0+qyBSa3kIn5Juvfm6O7heURU5jeR/tZWud/OcozNXOMDyZSD6a9lOEaQ
         +CNSGXNxURb8mDfMmPvzTv3tpql8vrFvW8sp4YX/rrFdpzUpix2/jHuxn/YTLnkF3mv1
         mkLyOQQjhFUAEzKmb9pYqwdVdbp6rEvj3J/HGPfFPwDpnNpJN7NxngI8KAnsKwyjzPTs
         XQ9A==
X-Gm-Message-State: AFqh2kqyUPKuePX48mJV2FkUUjkzS5ZKJBNxTYQSCvJfvS7XC0J8z6Cr
        3KogTyRk+Jdwe2BJNeD2+ZThlg==
X-Google-Smtp-Source: AMrXdXsF4ezkqlt7LBL8VzAt7Yz3QRazT6jfNGuMCRSIwBQbNMyk2TtYnAHi3CRqS+OglKuRz8AgTQ==
X-Received: by 2002:a17:907:6f09:b0:7c0:a877:1cf1 with SMTP id sy9-20020a1709076f0900b007c0a8771cf1mr65202881ejc.12.1673351474078;
        Tue, 10 Jan 2023 03:51:14 -0800 (PST)
Received: from hera (ppp079167090036.access.hol.gr. [79.167.90.36])
        by smtp.gmail.com with ESMTPSA id p14-20020a170906784e00b00849c1e5c00esm4850678ejm.72.2023.01.10.03.51.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Jan 2023 03:51:13 -0800 (PST)
Date:   Tue, 10 Jan 2023 13:51:11 +0200
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc:     Jesper Dangaard Brouer <hawk@kernel.org>, netdev@vger.kernel.org,
        linux-mm@kvack.org, Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH v2 20/24] mm: Remove page pool members from struct page
Message-ID: <Y71RL87wMZZYaniw@hera>
References: <20230105214631.3939268-1-willy@infradead.org>
 <20230105214631.3939268-21-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230105214631.3939268-21-willy@infradead.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 05, 2023 at 09:46:27PM +0000, Matthew Wilcox (Oracle) wrote:
> These are now split out into their own netmem struct.
>
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---
>  include/linux/mm_types.h | 22 ----------------------
>  include/net/page_pool.h  |  4 ----
>  2 files changed, 26 deletions(-)
>
> diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
> index 603b615f1bf3..90d91088a9d5 100644
> --- a/include/linux/mm_types.h
> +++ b/include/linux/mm_types.h
> @@ -116,28 +116,6 @@ struct page {
>  			 */
>  			unsigned long private;
>  		};
> -		struct {	/* page_pool used by netstack */
> -			/**
> -			 * @pp_magic: magic value to avoid recycling non
> -			 * page_pool allocated pages.
> -			 */
> -			unsigned long pp_magic;
> -			struct page_pool *pp;
> -			unsigned long _pp_mapping_pad;
> -			unsigned long dma_addr;
> -			union {
> -				/**
> -				 * dma_addr_upper: might require a 64-bit
> -				 * value on 32-bit architectures.
> -				 */
> -				unsigned long dma_addr_upper;
> -				/**
> -				 * For frag page support, not supported in
> -				 * 32-bit architectures with 64-bit DMA.
> -				 */
> -				atomic_long_t pp_frag_count;
> -			};
> -		};
>  		struct {	/* Tail pages of compound page */
>  			unsigned long compound_head;	/* Bit zero is set */
>
> diff --git a/include/net/page_pool.h b/include/net/page_pool.h
> index a9dae4b5f2f7..c607d67c96dc 100644
> --- a/include/net/page_pool.h
> +++ b/include/net/page_pool.h
> @@ -86,11 +86,7 @@ struct netmem {
>  	static_assert(offsetof(struct page, pg) == offsetof(struct netmem, nm))
>  NETMEM_MATCH(flags, flags);
>  NETMEM_MATCH(lru, pp_magic);
> -NETMEM_MATCH(pp, pp);
>  NETMEM_MATCH(mapping, _pp_mapping_pad);
> -NETMEM_MATCH(dma_addr, dma_addr);
> -NETMEM_MATCH(dma_addr_upper, dma_addr_upper);
> -NETMEM_MATCH(pp_frag_count, pp_frag_count);
>  NETMEM_MATCH(_mapcount, _mapcount);
>  NETMEM_MATCH(_refcount, _refcount);
>  #undef NETMEM_MATCH
> --
> 2.35.1
>
Reviewed-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>

