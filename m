Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A7F8FCFD1
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 21:44:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726812AbfKNUos (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 15:44:48 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:45176 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726533AbfKNUos (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 15:44:48 -0500
Received: by mail-wr1-f66.google.com with SMTP id z10so8241639wrs.12
        for <netdev@vger.kernel.org>; Thu, 14 Nov 2019 12:44:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Mr2plnEViTGuRWES/V4l4uHoOzGvUt0dtjyhRGpxvO8=;
        b=RkBBg6xDDl8VgH8P+H4/6GchviTkb3fIE6UoJqq20D4yWXbxFwF0Ht4l7valhoVuTi
         85/5hvHr3O7+alg+QThXlpmaofyip1IfLg2/PhJjeTKL3Bxrj+p8cILoLK5jbgzjgbF3
         BhwzcP0D0Gx3pg8sYLBMM25eTLf1EzW5dhV32W/wmWpRYRbv+UpYxXzQNOW1eIOp5QNy
         ngh+kpCTzksGoWcFHBJtN63nA1CV1DZmSUqdz1RziY99ySYlmH9VDSmxuNRS3/bSMEfP
         zIQ8aGzQutZjkR6L0QVSP24AL1tISwnUQvnPMhzsixMeBJEUSduZElIdeVmaBaN3hOWA
         6SDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Mr2plnEViTGuRWES/V4l4uHoOzGvUt0dtjyhRGpxvO8=;
        b=ODCu1hvDhuOlsU6mJRRdb0Ka+bN4T14Svzv6YDqwjJf1e9zdajO5/BFDgMjcdT5dbR
         BG3LuwGsgHU/MlsUwKZDN2pwyNXGjQ0JVJc0Qaf/XA2thRQE9SKEtCa08UTRHTIJS1NK
         MJJjcy3y+JqJWHwykY+XyJwKKrbY2IIujzpB4qbR2qec785DnSOswcQrsxiNnPG8mdRN
         ak/0fdi5Nm6z0oQ0TOf3MjcBCTY/+QrP0FXGxaUUa5cCoOu4ZzDtCN2OChGbVesXrG+3
         j48h9oAEG0mnNP3fyTrdxzB08KTDi22Q5hJ2Eu3i30MCouPczYA3syDoCrNDaA/CPuOX
         hj2w==
X-Gm-Message-State: APjAAAWjAI5r2QCiY86+WJQYDh37dfVU5WN7sO7PtXoqhzi0YhvQBTYN
        FuawARcTch72UfxnItHQZMMubA==
X-Google-Smtp-Source: APXvYqwDj6tAzJx4bEe2npdZc5uCL0LqyVe+ZfEpq2Y1B7gm8kgORi5KBGYpjJyB7f0a3li6LVJkig==
X-Received: by 2002:a5d:4609:: with SMTP id t9mr10890658wrq.178.1573764286162;
        Thu, 14 Nov 2019 12:44:46 -0800 (PST)
Received: from PC192.168.49.172 (athedsl-4484009.home.otenet.gr. [94.71.55.177])
        by smtp.gmail.com with ESMTPSA id j22sm9866944wrd.41.2019.11.14.12.44.44
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 14 Nov 2019 12:44:45 -0800 (PST)
Date:   Thu, 14 Nov 2019 22:42:27 +0200
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org,
        lorenzo.bianconi@redhat.com, davem@davemloft.net,
        thomas.petazzoni@bootlin.com, brouer@redhat.com,
        matteo.croce@redhat.com
Subject: Re: [PATCH net-next 2/3] net: page_pool: add the possibility to sync
 DMA memory for non-coherent devices
Message-ID: <20191114204227.GA43707@PC192.168.49.172>
References: <cover.1573383212.git.lorenzo@kernel.org>
 <68229f90060d01c1457ac945b2f6524e2aa27d05.1573383212.git.lorenzo@kernel.org>
 <6BF4C165-2AA2-49CC-B452-756CD0830129@gmail.com>
 <20191114185326.GA43048@PC192.168.49.172>
 <3648E256-C048-4F74-90FB-94D184B26499@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3648E256-C048-4F74-90FB-94D184B26499@gmail.com>
User-Agent: Mutt/1.9.5 (2018-04-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jonathan,

On Thu, Nov 14, 2019 at 12:27:40PM -0800, Jonathan Lemon wrote:
> 
> 
> On 14 Nov 2019, at 10:53, Ilias Apalodimas wrote:
> 
> > [...]
> > > > index 2cbcdbdec254..defbfd90ab46 100644
> > > > --- a/include/net/page_pool.h
> > > > +++ b/include/net/page_pool.h
> > > > @@ -65,6 +65,9 @@ struct page_pool_params {
> > > >  	int		nid;  /* Numa node id to allocate from pages from */
> > > >  	struct device	*dev; /* device, for DMA pre-mapping purposes */
> > > >  	enum dma_data_direction dma_dir; /* DMA mapping direction */
> > > > +	unsigned int	max_len; /* max DMA sync memory size */
> > > > +	unsigned int	offset;  /* DMA addr offset */
> > > > +	u8 sync;
> > > >  };
> > > 
> > > How about using PP_FLAG_DMA_SYNC instead of another flag word?
> > > (then it can also be gated on having DMA_MAP enabled)
> > 
> > You mean instead of the u8?
> > As you pointed out on your V2 comment of the mail, some cards don't sync
> > back to
> > device.
> > As the API tries to be generic a u8 was choosen instead of a flag to
> > cover these
> > use cases. So in time we'll change the semantics of this to 'always
> > sync', 'dont
> > sync if it's an skb-only queue' etc.
> > The first case Lorenzo covered is sync the required len only instead of
> > the full
> > buffer
> 
> Yes, I meant instead of:
> +		.sync = 1,
> 
> Something like:
>         .flags = PP_FLAG_DMA_MAP | PP_FLAG_DMA_SYNC
> 
> Since .sync alone doesn't make sense if the page pool isn't performing any
> DMA mapping, right?  

Correct. If the sync happens regardless of the page pool mapping capabilities,
this will affect performance negatively as well (on non-coherent architectures) 

> Then existing drivers, if they're converted, can just
> add the SYNC flag.
> 
> I did see the initial case where only the RX_BUF_SIZE (1536) is sync'd
> instead of the full page.
> 
> Could you expand on your 'skb-only queue' comment?  I'm currently running
> a variant of your patch where iommu mapped pages are attached to skb's and
> sent up the stack, then reclaimed on release.  I imagine that with this
> change, they would have the full RX_BUF_SIZE sync'd before returning to the
> driver, since the upper layers could basically do anything with the buffer
> area.

The idea was that page_pool lives per device queue. Usually some queues are
reserved for XDP only. Since eBPF progs can change the packet we have to sync
for the device, before we fill in the device descriptors. 

For the skb reserved queues, this depends on the 'anything'. If the rest of the
layers touch (or rather write) into that area, then we'll again gave to sync. 
If we know that the data has not been altered though, we can hand them back to
the device skipping that sync right?


Thanks
/Ilias
> -- 
> Jonathan
