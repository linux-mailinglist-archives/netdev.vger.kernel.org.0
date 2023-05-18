Return-Path: <netdev+bounces-3516-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C0AB707A84
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 09:03:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 08BC62813BE
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 07:03:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CEAB92A9CA;
	Thu, 18 May 2023 07:03:49 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4CF47E
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 07:03:49 +0000 (UTC)
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AE552D64
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 00:03:46 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id ffacd0b85a97d-3093eb8cd1fso1047742f8f.1
        for <netdev@vger.kernel.org>; Thu, 18 May 2023 00:03:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1684393425; x=1686985425;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=cmE3Hw/g7PPXrHo8vcI6AjK/ohP/P6DVA7E2EEZA5aw=;
        b=lNypA+WGF2vO1hR7ikW9cji9tuOPvcbtbUBOxHzGqO4xtpMGVB6DkS1/BXmv9xnBAj
         L4XUoIwAROLoDGxQc7FPnw+nIJnpo0e5vuiaPH3mNf8/Qm9m4WgJUXgFSHOMVqF8kQF0
         lGq98PFQ6c+vLqDalLC72hlWN0qUAALcjHXfF3pijF/1SVHSRbm3z5gN8zvLEWFu69aR
         1Gw5PfG+ns+3qIjk+4WbR6QqLMby0ilKS4tz60gv8qfooG6Py867g57LRIEukAXUBzpm
         D2thI7uvQKTaDqu89O5+AjN7X/RqPl6B4z+gsMxjNPlT9HOo3ORGOIDxnBauldOllBpk
         vwfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684393425; x=1686985425;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cmE3Hw/g7PPXrHo8vcI6AjK/ohP/P6DVA7E2EEZA5aw=;
        b=IDwBuPX5VgcOTXOLkR1w0PjzdVYFZDDp3x/mtWLLtN3dTl/pd4UitUfuBrPoexDB39
         90ctRguN3Z60675UmDyTLCTfi5qw3EntSIYmx2+6HwsxyRTgRHO3IRD065fhlSoH7dPj
         ksJOmQKf21Oho2V+HTkxhCmVfLqyA4dbAGUcR6YENp7EwCOajPg+QIX0wnO/VcqkUHKB
         A1JfgnvL0aHZuI+R7vw67pZ6NtzAFDBwqbTan4vTLGUSSP/HZ3D+60IIH0ixu+ta9Dfd
         95c+5DhXDYdDWPpR2F5dlijvpwizpdfditmqJVxIiy1bfxD88zRZLRuHmc6nu1jwtpHE
         NN3Q==
X-Gm-Message-State: AC+VfDzJZUBuudKsdqPrm9VmKQlLv1gTg81LyCCkAX8MXEx2OvTgNz1C
	OPBjZaORfIbec/mWYRiFLfZMJw==
X-Google-Smtp-Source: ACHHUZ7KA7gW++urZQKvPGWLM/0di9BvXzgoPwnUHrCMESNRXMuASR1PwcyqGPzX8tXB+3miGBskrg==
X-Received: by 2002:adf:fb08:0:b0:309:3c0c:b2c1 with SMTP id c8-20020adffb08000000b003093c0cb2c1mr572723wrr.23.1684393424852;
        Thu, 18 May 2023 00:03:44 -0700 (PDT)
Received: from hera (ppp176092130041.access.hol.gr. [176.92.130.41])
        by smtp.gmail.com with ESMTPSA id d15-20020a5d644f000000b00307a83ea722sm1110439wrw.58.2023.05.18.00.03.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 May 2023 00:03:44 -0700 (PDT)
Date: Thu, 18 May 2023 10:03:41 +0300
From: Ilias Apalodimas <ilias.apalodimas@linaro.org>
To: Jakub Kicinski <kuba@kernel.org>
Cc: Alexander Lobakin <aleksander.lobakin@intel.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	Magnus Karlsson <magnus.karlsson@intel.com>,
	Michal Kubiak <michal.kubiak@intel.com>,
	Larysa Zaremba <larysa.zaremba@intel.com>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	Christoph Hellwig <hch@lst.de>, netdev@vger.kernel.org,
	intel-wired-lan@lists.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 07/11] net: page_pool: add DMA-sync-for-CPU
 inline helpers
Message-ID: <ZGXNzX77/5cXqAhe@hera>
References: <20230516161841.37138-1-aleksander.lobakin@intel.com>
 <20230516161841.37138-8-aleksander.lobakin@intel.com>
 <20230517211211.1d1bbd0b@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230517211211.1d1bbd0b@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi all,

> On Wed, May 17, 2023 at 09:12:11PM -0700, Jakub Kicinski wrote:
> On Tue, 16 May 2023 18:18:37 +0200 Alexander Lobakin wrote:
> > Each driver is responsible for syncing buffers written by HW for CPU
> > before accessing them. Almost each PP-enabled driver uses the same
> > pattern, which could be shorthanded into a static inline to make driver
> > code a little bit more compact.
> > Introduce a couple such functions. The first one takes the actual size
> > of the data written by HW and is the main one to be used on Rx. The
> > second does the same, but only if the PP performs DMA synchronizations
> > at all. The last one picks max_len from the PP params and is designed
> > for more extreme cases when the size is unknown, but the buffer still
> > needs to be synced.
> > Also constify pointer arguments of page_pool_get_dma_dir() and
> > page_pool_get_dma_addr() to give a bit more room for optimization,
> > as both of them are read-only.
>
> Very neat.
>
> > diff --git a/include/net/page_pool.h b/include/net/page_pool.h
> > index 8435013de06e..f740c50b661f 100644
> > --- a/include/net/page_pool.h
> > +++ b/include/net/page_pool.h
> > @@ -32,7 +32,7 @@
> >
> >  #include <linux/mm.h> /* Needed by ptr_ring */
> >  #include <linux/ptr_ring.h>
> > -#include <linux/dma-direction.h>
> > +#include <linux/dma-mapping.h>
>
> highly nit picky - but isn't dma-mapping.h pretty heavy?
> And we include page_pool.h in skbuff.h. Not that it matters
> today, but maybe one day we'll succeed putting skbuff.h
> on a diet -- so perhaps it's better to put "inline helpers
> with non-trivial dependencies" into a new header?
>
> >  #define PP_FLAG_DMA_MAP		BIT(0) /* Should page_pool do the DMA
> >  					* map/unmap
>
> > +/**
> > + * page_pool_dma_sync_for_cpu - sync Rx page for CPU after it's written by HW
> > + * @pool: page_pool which this page belongs to
> > + * @page: page to sync
> > + * @dma_sync_size: size of the data written to the page
> > + *
> > + * Can be used as a shorthand to sync Rx pages before accessing them in the
> > + * driver. Caller must ensure the pool was created with %PP_FLAG_DMA_MAP.
> > + */
> > +static inline void page_pool_dma_sync_for_cpu(const struct page_pool *pool,
> > +					      const struct page *page,
> > +					      u32 dma_sync_size)
> > +{
> > +	dma_sync_single_range_for_cpu(pool->p.dev,
> > +				      page_pool_get_dma_addr(page),
> > +				      pool->p.offset, dma_sync_size,
> > +				      page_pool_get_dma_dir(pool));
>
> Likely a dumb question but why does this exist?
> Is there a case where the "maybe" version is not safe?
>

I got similar concerns here.  Syncing for the cpu is currently a
responsibility for the driver.  The reason for having an automated DMA sync
is that we know when we allocate buffers for the NIC to consume so we can
safely sync them accordingly.  I am fine having a page pool version for the
cpu sync, but do we really have to check the pp flags for that?  IOW if you
are at the point that you need to sync a buffer for the cpu *someone*
already mapped it for you.  Regardsless of who mapped it the sync is
identical

> > +}
> > +
> > +/**
> > + * page_pool_dma_maybe_sync_for_cpu - sync Rx page for CPU if needed
> > + * @pool: page_pool which this page belongs to
> > + * @page: page to sync
> > + * @dma_sync_size: size of the data written to the page
> > + *
> > + * Performs DMA sync for CPU, but only when required (swiotlb, IOMMU etc.).
> > + */
> > +static inline void
> > +page_pool_dma_maybe_sync_for_cpu(const struct page_pool *pool,
> > +				 const struct page *page, u32 dma_sync_size)
> > +{
> > +	if (pool->p.flags & PP_FLAG_DMA_SYNC_DEV)
> > +		page_pool_dma_sync_for_cpu(pool, page, dma_sync_size);
> > +}

Thanks
/Ilias

