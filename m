Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8745C663EDC
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 12:02:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232882AbjAJLCh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 06:02:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232957AbjAJLAm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 06:00:42 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C0B61168
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 03:00:41 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id jo4so27586218ejb.7
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 03:00:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Y+o6cKqup0PQOc0VCM2FQDv0bt++VUD6yKUaB+WSLkU=;
        b=pabF5yDJIDeD61JCtwpPySIatdGRhYfV0wh3xs7Hb9yW+fCRABMyw1Bx9FoWNb3A2r
         xY4u526fCnyLS+YWlxlOX044yLjWwAJQiVzT4A8wbRPAEHIR5ioEW1P0q7GcBhzJphNI
         9Pn2W6ReIRRKhv7JdGdTHGP10R8FsHcn5IFCxgHLaPPRcy0eIy+bqPWzd44Afy58LRW1
         TkrPUEBqFeNrgop6+uv/7mW2iJGozgKOdCf9GTZt3c71PsQ2SufJ25RMPhd5TJKSK6SO
         1ur3cWtL55lNWNdbL1B3QIkh6osBVmNbidmQh4/F6bfhd/Mk5I6ImQtIaU5aTMjawbGo
         F51A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Y+o6cKqup0PQOc0VCM2FQDv0bt++VUD6yKUaB+WSLkU=;
        b=Tiv1ZW1ZFLApWCsz+thTN0JKX+NadiqnjqNhv31cOUYITH8ywcNWQHjvFwxeoDCmQI
         fM02Z62RL/bDTY8yv4dl5hBwZgUPhBfSm1tEGX71KGkFb5owIhcPjbjJULaB32HUm7ws
         O40zGSCzTvqwtfKNYyeD9mCeSAz2lNGrSZNlmaBbbNYWFoRWMcJuk1hl01UCaZgkPGND
         pwmP+iI51Sc9mhf+GY8eLPknKkIFv2fxS+1onAwywgyEbpKa8btDg7lXNvh+pk70M1nX
         cNMhRbbmin27dqBiO3ElmnevYOIovlo87iNxzFSrTt6RisgHbRubCsv0Gtfo7CAW9hOb
         7Y4w==
X-Gm-Message-State: AFqh2ko5yjNjcTMzPcIWyiFutQ+NxMSfQUUv6RyY39An55536Nk92lkS
        I8T9bOWeGrkoDkuVGBU95vhm8Q==
X-Google-Smtp-Source: AMrXdXu6/5NMFl5vbMqhgKJcSDWZg9ZOkBoBm4WVrFAzx3TfW/phaAzwT4OHhCymDBPDDJU2YxgwwQ==
X-Received: by 2002:a17:906:9d04:b0:84d:3822:2fc7 with SMTP id fn4-20020a1709069d0400b0084d38222fc7mr8539058ejc.77.1673348439719;
        Tue, 10 Jan 2023 03:00:39 -0800 (PST)
Received: from hera (ppp079167090036.access.hol.gr. [79.167.90.36])
        by smtp.gmail.com with ESMTPSA id ec20-20020a170906b6d400b007c0f5d6f754sm4849116ejb.79.2023.01.10.03.00.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Jan 2023 03:00:39 -0800 (PST)
Date:   Tue, 10 Jan 2023 13:00:37 +0200
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc:     Jesper Dangaard Brouer <hawk@kernel.org>, netdev@vger.kernel.org,
        linux-mm@kvack.org, Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH v2 16/24] page_pool: Use netmem in page_pool_drain_frag()
Message-ID: <Y71FVTsdUVrqWV0z@hera>
References: <20230105214631.3939268-1-willy@infradead.org>
 <20230105214631.3939268-17-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230105214631.3939268-17-willy@infradead.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 05, 2023 at 09:46:23PM +0000, Matthew Wilcox (Oracle) wrote:
> We're not quite ready to change the API of page_pool_drain_frag(),
> but we can remove the use of several wrappers by using the netmem
> throughout.
>
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---
>  net/core/page_pool.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/net/core/page_pool.c b/net/core/page_pool.c
> index c495e3a16e83..cd469a9970e7 100644
> --- a/net/core/page_pool.c
> +++ b/net/core/page_pool.c
> @@ -672,17 +672,17 @@ static struct page *page_pool_drain_frag(struct page_pool *pool,
>  	long drain_count = BIAS_MAX - pool->frag_users;
>
>  	/* Some user is still using the page frag */
> -	if (likely(page_pool_defrag_page(page, drain_count)))
> +	if (likely(page_pool_defrag_netmem(nmem, drain_count)))
>  		return NULL;
>
> -	if (page_ref_count(page) == 1 && !page_is_pfmemalloc(page)) {
> +	if (netmem_ref_count(nmem) == 1 && !netmem_is_pfmemalloc(nmem)) {
>  		if (pool->p.flags & PP_FLAG_DMA_SYNC_DEV)
>  			page_pool_dma_sync_for_device(pool, nmem, -1);
>
>  		return page;
>  	}
>
> -	page_pool_return_page(pool, page);
> +	page_pool_return_netmem(pool, nmem);
>  	return NULL;
>  }
>
> --
> 2.35.1
>

Reviewed-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>

