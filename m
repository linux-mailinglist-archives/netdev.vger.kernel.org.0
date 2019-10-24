Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CCC80E29B5
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 07:00:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408390AbfJXFAH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 01:00:07 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:45619 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725298AbfJXFAH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Oct 2019 01:00:07 -0400
Received: by mail-wr1-f68.google.com with SMTP id q13so19441112wrs.12
        for <netdev@vger.kernel.org>; Wed, 23 Oct 2019 22:00:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=3uzLzjcBW79MTqpkNQS+HAUYBtrPp9V8b6hsV7jjVR4=;
        b=v087cmrWphd+ePIfgDMZqukWiLPpozg41aRXl72QD7P1lX3MvksJE+wpEHXg+/wA8P
         b69WK/kB3bNWp97o7QreTOsU5eSGLZvqGIfOiWSmVBc9MB7CPbbUs9OFbii0+GBdbgLx
         DR/TRsun2cM9cmjBjZJROmcElHnhOeYRYPitut7su+E0/tzzi/BRgnfgb5bkqXzWVt4i
         4Mgu135w/kGuLssKzOPlh1oBBvSv6e0RZikj4B17OLWYANaYqJwThB5llpHxT6cq6oqx
         dH6s9CgcDDD1FZnDYqBl5js3S/dxcHOJv/elMTGk4+D+1zDpgQqc+cQjGzSB+yQJRJVp
         yxSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=3uzLzjcBW79MTqpkNQS+HAUYBtrPp9V8b6hsV7jjVR4=;
        b=UYBJH93d6WmF8qkhfo7l4l+yrJaLv/UEgLW8a5LCx9qdQHU1+JZmaag2WjWC7s8aur
         n2kIgSJhhEtVuki/JQCB/XXAkEzBORSfTJvfq9xkZwngZPCm1XRIvHe3djQJc5h3cPaL
         6CsKvTHc5Tkn7ZXCavJjzX0xQuih0rFe2rcjil+wGITNfRFBi1TUSfvqqYeVIAbCkDuI
         /FhAXLYXUp/KZwbhULuPMwRq+29h9XSK11C7WOwc74JYJy/BOGssgGkrnXeShkTfVUP5
         64alpAMajLwNujZwgCZTkykSvjjpkOR1DmIw7/WLJZ2gwgaR0G0qGXZ0E0rOYXM/D/uG
         1oXg==
X-Gm-Message-State: APjAAAU0vQdfLusaO2Ej9GeUUbATCEhwEobsbVIfXhkUMtXxxymJubqH
        NrssKzWvKvj+iifDWQ4Hkb9zIJIm7mA=
X-Google-Smtp-Source: APXvYqytpDcoNi+dIdIgOHqQW4MKXkzjd8iSnK512p7oTUiy/6J3Saianc2GgIwjr3suVxdONXZWjg==
X-Received: by 2002:adf:9185:: with SMTP id 5mr1957358wri.389.1571893203606;
        Wed, 23 Oct 2019 22:00:03 -0700 (PDT)
Received: from apalos.home (ppp-94-65-92-5.home.otenet.gr. [94.65.92.5])
        by smtp.gmail.com with ESMTPSA id j63sm2160828wmj.46.2019.10.23.22.00.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Oct 2019 22:00:03 -0700 (PDT)
Date:   Thu, 24 Oct 2019 08:00:00 +0300
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>
Subject: Re: [PATCH net-nex V2 2/3] page_pool: Don't recycle non-reusable
 pages
Message-ID: <20191024050000.GB537@apalos.home>
References: <20191023193632.26917-1-saeedm@mellanox.com>
 <20191023193632.26917-3-saeedm@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191023193632.26917-3-saeedm@mellanox.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 23, 2019 at 07:37:00PM +0000, Saeed Mahameed wrote:
> A page is NOT reusable when at least one of the following is true:
> 1) allocated when system was under some pressure. (page_is_pfmemalloc)
> 2) belongs to a different NUMA node than pool->p.nid.
> 
> To update pool->p.nid users should call page_pool_update_nid().
> 
> Holding on to such pages in the pool will hurt the consumer performance
> when the pool migrates to a different numa node.
> 
> Performance testing:
> XDP drop/tx rate and TCP single/multi stream, on mlx5 driver
> while migrating rx ring irq from close to far numa:
> 
> mlx5 internal page cache was locally disabled to get pure page pool
> results.
> 
> CPU: Intel(R) Xeon(R) CPU E5-2603 v4 @ 1.70GHz
> NIC: Mellanox Technologies MT27700 Family [ConnectX-4] (100G)
> 
> XDP Drop/TX single core:
> NUMA  | XDP  | Before    | After
> ---------------------------------------
> Close | Drop | 11   Mpps | 10.9 Mpps
> Far   | Drop | 4.4  Mpps | 5.8  Mpps
> 
> Close | TX   | 6.5 Mpps  | 6.5 Mpps
> Far   | TX   | 3.5 Mpps  | 4  Mpps
> 
> Improvement is about 30% drop packet rate, 15% tx packet rate for numa
> far test.
> No degradation for numa close tests.
> 
> TCP single/multi cpu/stream:
> NUMA  | #cpu | Before  | After
> --------------------------------------
> Close | 1    | 18 Gbps | 18 Gbps
> Far   | 1    | 15 Gbps | 18 Gbps
> Close | 12   | 80 Gbps | 80 Gbps
> Far   | 12   | 68 Gbps | 80 Gbps
> 
> In all test cases we see improvement for the far numa case, and no
> impact on the close numa case.
> 
> The impact of adding a check per page is very negligible, and shows no
> performance degradation whatsoever, also functionality wise it seems more
> correct and more robust for page pool to verify when pages should be
> recycled, since page pool can't guarantee where pages are coming from.
> 
> Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
> Acked-by: Jonathan Lemon <jonathan.lemon@gmail.com>
> ---
>  net/core/page_pool.c | 14 +++++++++++++-
>  1 file changed, 13 insertions(+), 1 deletion(-)
> 
> diff --git a/net/core/page_pool.c b/net/core/page_pool.c
> index 953af6d414fb..73e4173c4dce 100644
> --- a/net/core/page_pool.c
> +++ b/net/core/page_pool.c
> @@ -283,6 +283,17 @@ static bool __page_pool_recycle_direct(struct page *page,
>  	return true;
>  }
>  
> +/* page is NOT reusable when:
> + * 1) allocated when system is under some pressure. (page_is_pfmemalloc)
> + * 2) belongs to a different NUMA node than pool->p.nid.
> + *
> + * To update pool->p.nid users must call page_pool_update_nid.
> + */
> +static bool pool_page_reusable(struct page_pool *pool, struct page *page)
> +{
> +	return !page_is_pfmemalloc(page) && page_to_nid(page) == pool->p.nid;
> +}
> +
>  void __page_pool_put_page(struct page_pool *pool,
>  			  struct page *page, bool allow_direct)
>  {
> @@ -292,7 +303,8 @@ void __page_pool_put_page(struct page_pool *pool,
>  	 *
>  	 * refcnt == 1 means page_pool owns page, and can recycle it.
>  	 */
> -	if (likely(page_ref_count(page) == 1)) {
> +	if (likely(page_ref_count(page) == 1 &&
> +		   pool_page_reusable(pool, page))) {
>  		/* Read barrier done in page_ref_count / READ_ONCE */
>  
>  		if (allow_direct && in_serving_softirq())
> -- 
> 2.21.0
> 

Reviewed-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
