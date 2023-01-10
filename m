Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DB49663E64
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 11:38:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232026AbjAJKiT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 05:38:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237994AbjAJKiL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 05:38:11 -0500
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BB5A40C28
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 02:38:10 -0800 (PST)
Received: by mail-ej1-x634.google.com with SMTP id ud5so27456726ejc.4
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 02:38:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=jxCk+INuJb5IJ/Jm7iY7t6eqb9Zqw0Ms0o9owTWQx6c=;
        b=Ozcy5qrVAdybUnBO/t4N5enJX/gO+c+PJm50JjhTZ8P+9dvH3I0k3iF6I3sHneLZK3
         xmNfWdnuMAzXZiW1h9pHrcnIziWmhywED1TBzGkQb8hxwZLc6EGkqcMLFzouc9pXg57d
         DK5SWFs/kMjxsSYLOBDk6rzWzlgVsJcjKa4NDXbqMJqRDTvgpLZICk0Nbd5xBmnz95e4
         kUfFfLQ+YU8m3KfSvilDDlrEw2sE66am1jI1i+Z9whsL//3JvJWmr2vu7K75YKz9JNiv
         vRbzUradoZP7TmIBofl9IfZv+RqCv9lvE+EQrfolw2KWItvTZqHfLNtj7mXYe4MEhx1J
         jrgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jxCk+INuJb5IJ/Jm7iY7t6eqb9Zqw0Ms0o9owTWQx6c=;
        b=wHh5oY4gzdfYfFN5iI3bfYIOPxIvvKXWwKODJWUF05oTp3XWOiweObLLiGRpq/KJfW
         ng93odL0VuO/VcbkCQ9pcj/xjo3O7CQjCRi04DGjOjVQbo7+BScJC2j3N52FEdqQi4wG
         PNTxiw15WXtUfjPZ/RStbCagUV1Sas7J+v9H4l8NvLGHh/oDQw7j5EMWFBjNl186AtzT
         Ft0lc7DryaWYfx+vH+MfPfdBxLYWoTflh5L6jtCH72yVUByPulhDjmm5mAVc+YBtuSwp
         tpWRPsXZGiqx62nzqWwVCdHHF1UP4Ah3nTgo/7fo5+tN5L/femzZs5pFbje0G4npEQoI
         tUJQ==
X-Gm-Message-State: AFqh2krZbUYMmpOVupbikEWzeyWf5n9u8IGKLkrWmzQ+1Hc8FxXChsx8
        Cpm92W6BEjBZa3OO5ea8s8XmzQ==
X-Google-Smtp-Source: AMrXdXsgCobzUc3EKdZGLCr2B4sXcO22He4oOjTtG7Gu7aYFQ91amylkt6owbhhqhVXzpT24Gl/mTg==
X-Received: by 2002:a17:907:d68b:b0:7c1:691a:6d2c with SMTP id wf11-20020a170907d68b00b007c1691a6d2cmr78467457ejc.7.1673347089210;
        Tue, 10 Jan 2023 02:38:09 -0800 (PST)
Received: from hera (ppp079167090036.access.hol.gr. [79.167.90.36])
        by smtp.gmail.com with ESMTPSA id f1-20020a17090631c100b007aea1dc1840sm4781510ejf.111.2023.01.10.02.38.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Jan 2023 02:38:08 -0800 (PST)
Date:   Tue, 10 Jan 2023 12:38:06 +0200
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc:     Jesper Dangaard Brouer <hawk@kernel.org>, netdev@vger.kernel.org,
        linux-mm@kvack.org, Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH v2 11/24] page_pool: Convert page_pool_empty_ring() to
 use netmem
Message-ID: <Y71ADsqT13215XX0@hera>
References: <20230105214631.3939268-1-willy@infradead.org>
 <20230105214631.3939268-12-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230105214631.3939268-12-willy@infradead.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 05, 2023 at 09:46:18PM +0000, Matthew Wilcox (Oracle) wrote:
> Retrieve a netmem from the ptr_ring instead of a page.
>
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---
>  net/core/page_pool.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
>
> diff --git a/net/core/page_pool.c b/net/core/page_pool.c
> index e727a74504c2..0212244e07e7 100644
> --- a/net/core/page_pool.c
> +++ b/net/core/page_pool.c
> @@ -755,16 +755,16 @@ EXPORT_SYMBOL(page_pool_alloc_frag);
>
>  static void page_pool_empty_ring(struct page_pool *pool)
>  {
> -	struct page *page;
> +	struct netmem *nmem;
>
>  	/* Empty recycle ring */
> -	while ((page = ptr_ring_consume_bh(&pool->ring))) {
> +	while ((nmem = ptr_ring_consume_bh(&pool->ring)) != NULL) {
>  		/* Verify the refcnt invariant of cached pages */
> -		if (!(page_ref_count(page) == 1))
> +		if (netmem_ref_count(nmem) != 1)
>  			pr_crit("%s() page_pool refcnt %d violation\n",
> -				__func__, page_ref_count(page));
> +				__func__, netmem_ref_count(nmem));
>
> -		page_pool_return_page(pool, page);
> +		page_pool_return_netmem(pool, nmem);
>  	}
>  }
>
> --
> 2.35.1
>

Reviewed-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>

