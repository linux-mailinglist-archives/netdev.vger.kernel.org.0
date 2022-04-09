Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BADBE4FA9E1
	for <lists+netdev@lfdr.de>; Sat,  9 Apr 2022 19:20:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242860AbiDIRWm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Apr 2022 13:22:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240376AbiDIRWj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Apr 2022 13:22:39 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E5BA307E6A
        for <netdev@vger.kernel.org>; Sat,  9 Apr 2022 10:20:31 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id b15so11065965pfm.5
        for <netdev@vger.kernel.org>; Sat, 09 Apr 2022 10:20:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fastly.com; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=wz0FE5/AMETWZXavF0spIpv50OQDTinWVu6CdCMemRI=;
        b=aHWKoDgy2bXbx9tmLJugi4MxIHiqMKKyv7YWV1ML2ey03bWkRYnNiZTwxzM46ha9GR
         dWpeJ6LSjfXFOxC4I44HKqfVVrKclDFlJN6Z3a6tGSopRpdnfMd00I8DvurqWb35Qw4m
         eVj0I0Y+RzZL281JqRup/cofOeN/MXG+SMnDY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=wz0FE5/AMETWZXavF0spIpv50OQDTinWVu6CdCMemRI=;
        b=PeN7VTUUIcgsoG75CTCW8kZugiH5dFk1Yy7Q18iq//moTNm+8HzwHS+n/N5ZnSzQvz
         Fnbk/nwyM1tikFxWJuh8oRa/BaT1CAE/xkwM+vTLLjbA7iE6pVu152heOJMv6JKbO9Sl
         K/3ph5qbmEqopyqSvetxdHXc3VZZqnk9aqPtlRGPzHppyLaLDftNNsVj6RUXLfpQc+UP
         dMu99Z1NVugDF6Vf6KZWCQcIpiQTqYpJgPB1oh9IZ+8EOGIkR3E5x4XPdSn7vkSj6Vgo
         4iBMm3+ZZg5DSghf4nELG21ZHhn02wlQa/qrC6oTYnGCLWeveecquZARYElDxxm3nMh+
         9dVg==
X-Gm-Message-State: AOAM5330SIZSE+Y25SinTd20Ialnls7ysMoSBE8Vmh9wzCb3spDVuXo+
        Y5JVrpWx9KHdL7IszxNA0wX5Pg==
X-Google-Smtp-Source: ABdhPJwgHip2DkBDd+xauRyZ6jY5vf82SHi4jQErr0gmfEeyJLrrJDScWZ61OJxEfrUIF6NIyJ+c7Q==
X-Received: by 2002:a63:d456:0:b0:399:4c5a:2682 with SMTP id i22-20020a63d456000000b003994c5a2682mr19880560pgj.573.1649524830739;
        Sat, 09 Apr 2022 10:20:30 -0700 (PDT)
Received: from fastly.com (c-73-223-190-181.hsd1.ca.comcast.net. [73.223.190.181])
        by smtp.gmail.com with ESMTPSA id mw10-20020a17090b4d0a00b001c7cc82daabsm17026217pjb.1.2022.04.09.10.20.28
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 09 Apr 2022 10:20:30 -0700 (PDT)
Date:   Sat, 9 Apr 2022 10:20:27 -0700
From:   Joe Damato <jdamato@fastly.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, lorenzo.bianconi@redhat.com,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        jbrouer@redhat.com, ilias.apalodimas@linaro.org
Subject: Re: [PATCH net-next] page_pool: Add recycle stats to
 page_pool_put_page_bulk
Message-ID: <20220409172026.GA101830@fastly.com>
References: <1921137145a6a20bb3494c72b33268f5d6d86834.1649191881.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1921137145a6a20bb3494c72b33268f5d6d86834.1649191881.git.lorenzo@kernel.org>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 05, 2022 at 10:52:55PM +0200, Lorenzo Bianconi wrote:
> Add missing recycle stats to page_pool_put_page_bulk routine.
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>  net/core/page_pool.c | 15 +++++++++++++--
>  1 file changed, 13 insertions(+), 2 deletions(-)
> 
> diff --git a/net/core/page_pool.c b/net/core/page_pool.c
> index 1943c0f0307d..4af55d28ffa3 100644
> --- a/net/core/page_pool.c
> +++ b/net/core/page_pool.c
> @@ -36,6 +36,12 @@
>  		this_cpu_inc(s->__stat);						\
>  	} while (0)
>  
> +#define recycle_stat_add(pool, __stat, val)						\
> +	do {										\
> +		struct page_pool_recycle_stats __percpu *s = pool->recycle_stats;	\
> +		this_cpu_add(s->__stat, val);						\
> +	} while (0)
> +
>  bool page_pool_get_stats(struct page_pool *pool,
>  			 struct page_pool_stats *stats)
>  {
> @@ -63,6 +69,7 @@ EXPORT_SYMBOL(page_pool_get_stats);
>  #else
>  #define alloc_stat_inc(pool, __stat)
>  #define recycle_stat_inc(pool, __stat)
> +#define recycle_stat_add(pool, __stat, val)
>  #endif
>  
>  static int page_pool_init(struct page_pool *pool,
> @@ -566,9 +573,13 @@ void page_pool_put_page_bulk(struct page_pool *pool, void **data,
>  	/* Bulk producer into ptr_ring page_pool cache */
>  	page_pool_ring_lock(pool);
>  	for (i = 0; i < bulk_len; i++) {
> -		if (__ptr_ring_produce(&pool->ring, data[i]))
> -			break; /* ring full */
> +		if (__ptr_ring_produce(&pool->ring, data[i])) {
> +			/* ring full */
> +			recycle_stat_inc(pool, ring_full);
> +			break;
> +		}
>  	}
> +	recycle_stat_add(pool, ring, i);
>  	page_pool_ring_unlock(pool);
>  
>  	/* Hopefully all pages was return into ptr_ring */
> -- 
> 2.35.1
> 

Thanks for doing this!

Reviewed-by: Joe Damato <jdamato@fastly.com>
