Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DFF6663D3A
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 10:47:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237748AbjAJJri (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 04:47:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238073AbjAJJrX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 04:47:23 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 213611A23B
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 01:47:22 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id v30so16656286edb.9
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 01:47:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Svn7bvHFoLndO2FfnOsdQMf0i30cN4zQSQA2fnUT58E=;
        b=GDrGWizA7R6nONYrYEQDSp3pBdISlYVJbUpRynyYT5PGfql6kNFl8dm0AyOBOmQ3F2
         cquwxsyMbWOZSJIR9++q43nvqNP0PriInPqr9hIrS7SAJ7k18QeKGzinZFmiqW2B3/+W
         VuWCFRvSH7pRjEBMZzi3kp59kbPTfvL22YWz0ZDqQe/h2+cxu3pMYx4bOx0pNuq7Uq8P
         vI2aKyo37HJ6nRXYsDy7e2z8q3Q8RJGvzhRXjvbK5AFOBuQxeXIoBGFBDQMFSJh8tZCi
         LMun6Kn2eqeNLZbC40RtxG50m+nEa+NYAxOM5AKln8Rn75ZGdlG7pL8s3HgsJFr3FHcc
         m7OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Svn7bvHFoLndO2FfnOsdQMf0i30cN4zQSQA2fnUT58E=;
        b=jDbWshw3+3IWDUno/8IToBOfHeQoM+utEQcLed0LO6EOVln4tVSbJ7HR4SpazkO7gH
         T2+7g4WueP7EKsLWZFmIC3VwFHRtCCcERzkia5i8lCeJ9lTZSieVWmE7JDx4GLEmowRa
         BbivZLsFNIXHVjNnLgBk4ulYPPYnzU/Op7aETFDvhAKy1kuLH0ZntA00ZsLfTlDS/2IH
         KAc8SwzxwwHVlzUEsqqwp+jOd3JrdaDRteBgyR3z2Ob8OymC6qObVyo0UPyf3AA/vxrY
         Dh809ntT5H2YvBBWE2qFQCczrT+0F9DVQVPktjcKaX0rS4GrzO1vJCUjh8facNFhjkgl
         c79A==
X-Gm-Message-State: AFqh2kqu/pgodf16hI+b63IRIam/I28uwpbtS5xMaRvSi9Lr7X1BIH4n
        JcG2pn3negHAFq2sn6JzC+5aMA==
X-Google-Smtp-Source: AMrXdXv0X2XHKBPGMi3SXqy2Zsy4Wwy58BDBqup4x2wJkLYDG2LMYiImTA82fFK1mWhPOCsGgITumg==
X-Received: by 2002:a05:6402:6c7:b0:492:609a:f144 with SMTP id n7-20020a05640206c700b00492609af144mr15918187edy.6.1673344040630;
        Tue, 10 Jan 2023 01:47:20 -0800 (PST)
Received: from hera (ppp079167090036.access.hol.gr. [79.167.90.36])
        by smtp.gmail.com with ESMTPSA id f9-20020a056402068900b0048999d127e0sm4667740edy.86.2023.01.10.01.47.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Jan 2023 01:47:20 -0800 (PST)
Date:   Tue, 10 Jan 2023 11:47:18 +0200
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc:     Jesper Dangaard Brouer <hawk@kernel.org>, netdev@vger.kernel.org,
        linux-mm@kvack.org, Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH v2 15/24] page_pool: Remove page_pool_defrag_page()
Message-ID: <Y700Jp6rWBzNYRdf@hera>
References: <20230105214631.3939268-1-willy@infradead.org>
 <20230105214631.3939268-16-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230105214631.3939268-16-willy@infradead.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 05, 2023 at 09:46:22PM +0000, Matthew Wilcox (Oracle) wrote:
> This wrapper is no longer used.
>
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---
>  net/core/page_pool.c | 8 --------
>  1 file changed, 8 deletions(-)
>
> diff --git a/net/core/page_pool.c b/net/core/page_pool.c
> index b925a4dcb09b..c495e3a16e83 100644
> --- a/net/core/page_pool.c
> +++ b/net/core/page_pool.c
> @@ -607,14 +607,6 @@ __page_pool_put_netmem(struct page_pool *pool, struct netmem *nmem,
>  	return NULL;
>  }
>
> -static __always_inline struct page *
> -__page_pool_put_page(struct page_pool *pool, struct page *page,
> -		     unsigned int dma_sync_size, bool allow_direct)
> -{
> -	return netmem_page(__page_pool_put_netmem(pool, page_netmem(page),
> -						dma_sync_size, allow_direct));
> -}
> -
>  void page_pool_put_defragged_netmem(struct page_pool *pool, struct netmem *nmem,
>  				  unsigned int dma_sync_size, bool allow_direct)
>  {
> --
> 2.35.1
>
Reviewed-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>

