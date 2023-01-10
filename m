Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50A07663E28
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 11:27:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230199AbjAJK1c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 05:27:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230094AbjAJK1a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 05:27:30 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEB36EA1
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 02:27:28 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id vm8so27358068ejc.2
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 02:27:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=CQ9HaD5lhY305KANBx80wolIrRiJI7YBQDlDXhg3c7M=;
        b=uKFZ8zPAe7vsnaCYjq43gODxZt9AYLBuxf2eG8LEhNGHBocdPMraf5flzuLBomTbjE
         d4H4JhLEAR+FZVMwZH+CH4RlO12ERnUphYm3n8GsPwkc0Qx9eF0DOKFY8zkqDOXgXWJt
         PQ2XL03F1kZmincyoEOyO7MACWb/3E+62KasPNnjg9vQuQHMNKoRxjRw6oezXnBWHcYN
         tFGKBgU8Lzq3jrESWlvF1Nfa0pBdRXL2h6kQyE9UsBLmJNlvAPd46KvOINHoKLVbu04t
         EVNoE1UMNKHFru6HskKyJxngSLq6jB6H5RKdTFSqrRQ0QzkkiHpP1qmeA0LSk78jCNES
         11/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CQ9HaD5lhY305KANBx80wolIrRiJI7YBQDlDXhg3c7M=;
        b=G0V3d0Q1oGqFiGiHnxMkIztfLCFljHO3dMcMp3/nreOBMRUqE3LSBlQEWyh35ANH4j
         zpOOyF/zwO3OmuI7QAqoaRXbpm95s+orkg78b3bTOQVrHYUgecw8EKsXJ+tO+cBvBFMh
         KlR3bB0M3TWgRAxE5b4/Yh0uNogyYeBaSsjH9P77zu9/rNYwXRpnzfDZVo83dvwvFpc2
         LhxFoHL3bamPcYPkzrck2DbgcwfDVPH/WnJQgjBVxx7KlnTYajiT6rgz+g3S7f+f0JDX
         1EMIQ9ynWnNm7hR9wejexmEo4627uEm4GDnxezQWq0DiuqSaDEt6+l6Lj0NLRNReXP6U
         bSJA==
X-Gm-Message-State: AFqh2kpBrGTqQNPTWcPviC5aw11Hkzd35BLuCxr35IpbiqjrzDqRG2HK
        uk2fw7BdW+QfsOlsFT5o3wwNdw==
X-Google-Smtp-Source: AMrXdXsjdaz5w3UirnEdQR0g6CZWHH4x3ZGAHI565jTu5hWXOWg03B6tnTzl6zgCe8wZvEyyj8vn+A==
X-Received: by 2002:a17:907:6f18:b0:837:3ed3:9c2b with SMTP id sy24-20020a1709076f1800b008373ed39c2bmr64760224ejc.5.1673346447559;
        Tue, 10 Jan 2023 02:27:27 -0800 (PST)
Received: from hera (ppp079167090036.access.hol.gr. [79.167.90.36])
        by smtp.gmail.com with ESMTPSA id c10-20020a17090618aa00b0084d14646fd9sm4683470ejf.165.2023.01.10.02.27.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Jan 2023 02:27:27 -0800 (PST)
Date:   Tue, 10 Jan 2023 12:27:25 +0200
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc:     Jesper Dangaard Brouer <hawk@kernel.org>, netdev@vger.kernel.org,
        linux-mm@kvack.org, Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH v2 09/24] page_pool: Convert page_pool_defrag_page() to
 page_pool_defrag_netmem()
Message-ID: <Y709jZ60cGj/eQOI@hera>
References: <20230105214631.3939268-1-willy@infradead.org>
 <20230105214631.3939268-10-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230105214631.3939268-10-willy@infradead.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 05, 2023 at 09:46:16PM +0000, Matthew Wilcox (Oracle) wrote:
> Add a page_pool_defrag_page() wrapper.
>
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---
>  include/net/page_pool.h | 11 ++++++++---
>  1 file changed, 8 insertions(+), 3 deletions(-)
>
> diff --git a/include/net/page_pool.h b/include/net/page_pool.h
> index 63aa530922de..8fe494166427 100644
> --- a/include/net/page_pool.h
> +++ b/include/net/page_pool.h
> @@ -393,7 +393,7 @@ static inline void page_pool_fragment_page(struct page *page, long nr)
>  	atomic_long_set(&page->pp_frag_count, nr);
>  }
>
> -static inline long page_pool_defrag_page(struct page *page, long nr)
> +static inline long page_pool_defrag_netmem(struct netmem *nmem, long nr)
>  {
>  	long ret;
>
> @@ -406,14 +406,19 @@ static inline long page_pool_defrag_page(struct page *page, long nr)
>  	 * especially when dealing with a page that may be partitioned
>  	 * into only 2 or 3 pieces.
>  	 */
> -	if (atomic_long_read(&page->pp_frag_count) == nr)
> +	if (atomic_long_read(&nmem->pp_frag_count) == nr)
>  		return 0;
>
> -	ret = atomic_long_sub_return(nr, &page->pp_frag_count);
> +	ret = atomic_long_sub_return(nr, &nmem->pp_frag_count);
>  	WARN_ON(ret < 0);
>  	return ret;
>  }
>
> +static inline long page_pool_defrag_page(struct page *page, long nr)
> +{
> +	return page_pool_defrag_netmem(page_netmem(page), nr);
> +}
> +
>  static inline bool page_pool_is_last_frag(struct page_pool *pool,
>  					  struct page *page)
>  {
> --
> 2.35.1
>

Reviewed-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>

