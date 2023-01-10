Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9480663E5B
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 11:36:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237273AbjAJKgR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 05:36:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238034AbjAJKgI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 05:36:08 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1AFC3D1D8
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 02:36:07 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id i9so16882780edj.4
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 02:36:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=fsWLPCgWAXbyJUmxP1P4A2zhpjbxNYdawZ7e7VhzWL8=;
        b=m2Wl07b3n5eNjHDrCuw1EigL8SKkLvaYtca48Y7NVFwWTMXC0JS6af2iFpfTaj3Hc2
         yAb7EV21GoFf+euVyVdc8WoRAp7/WovPM7XawQwx+OvScXQTXc+TBG4mPh8yrZoAXt9m
         I2BQDvQ0hJi+C7sO/gszSfNWieMBhna7EzVfvqiYDfCjZWZJ7IzlRmbNBGFrxLjQT4dj
         e0XU0POJt8amvccfaaV7yWW5IWbmoUicKcvdtBIvHVUdsCmH0732tVJ58QZu9G4PBlFn
         DwK0sJHZBILZqk9kN6H2d7kQhzNkWXYvvxz9Wbl9Uj1/ME+tuyBMenm1xwpwVtsFglUu
         ZcCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fsWLPCgWAXbyJUmxP1P4A2zhpjbxNYdawZ7e7VhzWL8=;
        b=ELpyJs5FUSHyBJ9ORtgE6sDRoqhPDBd7mZLrXK7p6UywaDVmcgq8SMBAQmRZPzgVtY
         bMcOIBQoXiV8/w9xLCkmu6+r5esZxOSHkp3nlBftw5ergst8gHfXjkcAyHLlwTQczJDw
         xjInFTj+ewBfjYrfVos2Mpfh9Ccjok7uHI1g1JKsRRdlAEEmh/TbshNLp/O++8R/sqc5
         rHvEctoScyCJ/HXCBpeU57JhAahVbhgsq7kRChQHag+Jaglur7UMAMM86VcIoAP1xqzA
         4an3D8BF5Xz6QsqRKRN4YoJESfNowZG+Fj9Jg2EEBEvbgzqeNcTMM1md0jAgZ58UA1pK
         vqHg==
X-Gm-Message-State: AFqh2kq2cLVgkdrqrwnBm/Ynt60bSP9vjP8kHWQge/i9GMeaouOJjNgR
        Cr8htfuUxBDeHfVjPpIyiMPEsGp4rhme1r4u
X-Google-Smtp-Source: AMrXdXvX/pTChGKviC4PW+njVsgAzjNhYouj65M0XK0C1G7FvApqo+tr9glOrN9Fljci+JnS2pumNQ==
X-Received: by 2002:a05:6402:414:b0:495:77a9:f108 with SMTP id q20-20020a056402041400b0049577a9f108mr17719404edv.39.1673346965835;
        Tue, 10 Jan 2023 02:36:05 -0800 (PST)
Received: from hera (ppp079167090036.access.hol.gr. [79.167.90.36])
        by smtp.gmail.com with ESMTPSA id l4-20020a056402344400b004822681a671sm4748712edc.37.2023.01.10.02.36.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Jan 2023 02:36:05 -0800 (PST)
Date:   Tue, 10 Jan 2023 12:36:03 +0200
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc:     Jesper Dangaard Brouer <hawk@kernel.org>, netdev@vger.kernel.org,
        linux-mm@kvack.org, Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH v2 10/24] page_pool: Convert
 page_pool_put_defragged_page() to netmem
Message-ID: <Y70/k75sqWxVL3hB@hera>
References: <20230105214631.3939268-1-willy@infradead.org>
 <20230105214631.3939268-11-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230105214631.3939268-11-willy@infradead.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 05, 2023 at 09:46:17PM +0000, Matthew Wilcox (Oracle) wrote:
> Also convert page_pool_is_last_frag(), page_pool_put_page(),
> page_pool_recycle_in_ring() and use netmem in page_pool_put_page_bulk().
>

[...]

> -	if (!page_pool_is_last_frag(pool, page))
> +	if (!page_pool_is_last_frag(pool, nmem))
>  		return;
>
> -	page_pool_put_defragged_page(pool, page, dma_sync_size, allow_direct);
> +	page_pool_put_defragged_netmem(pool, nmem, dma_sync_size, allow_direct);
>  #endif
>  }
>

nit again, but can we add a comment that this is planned for removal once
we convert teh remaining drivers?

> +static inline void page_pool_put_page(struct page_pool *pool,
> +				      struct page *page,
> +				      unsigned int dma_sync_size,
> +				      bool allow_direct)
> +{
> +	page_pool_put_netmem(pool, page_netmem(page), dma_sync_size,
> +				allow_direct);
> +}
> +
[...]

Regards
/Ilias
