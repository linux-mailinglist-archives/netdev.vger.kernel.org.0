Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA93529EDE3
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 15:08:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726238AbgJ2OIn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 10:08:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725300AbgJ2OIn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 10:08:43 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3929C0613D3
        for <netdev@vger.kernel.org>; Thu, 29 Oct 2020 07:08:42 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id t9so2890272wrq.11
        for <netdev@vger.kernel.org>; Thu, 29 Oct 2020 07:08:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=pacpunGvitI/VJhyOX0bJnSJLDkujjO41NLKC5ChE0M=;
        b=QPqbeKQF2q7f09LV0KQ0OlMf3pHSMPSEaOM+0fVp7hw42OlDcxrjU9fegfD4ql1HIB
         ryBfhF5lnLpJxR+USIwsdDhHoYDkUwqFN1cQ0axYTlyCrhlcUP0gmE7gjYs0c3O1IW91
         ALQUdsE2yn45kiG05RFvM+Zqw1c4ikYv58vxwlVBdvPHOTI+kObb57mV+9f3uI8BFEF+
         ujb0ZR/oPA8NWyR3Y+OWSpRoaPne8mATWKXmAAm7X6UeY1CnqN6RU45X6lbbTJy/rImG
         i7S1dmOh9nHDBd+UcriT0gljdZJ8wd75IxQFKY5wwa474zzocCWlNOB+XRz3EnQjMNkM
         XfLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=pacpunGvitI/VJhyOX0bJnSJLDkujjO41NLKC5ChE0M=;
        b=st7y5w+bzH1LtdOZwae8R2MMpRvrNc767Mj1HgH3JbTHYdFfT3Flru7IDUbKJg4HuU
         FLszIUI8IA+dKLyeJ2AjgppIsN3YVyfe3M9mARcFu/wahcAQydL+cP2tTVoERG6Wc7KH
         GLQ74YX0XHNrND1AOInP+XLYlG1uc0WHAMQvU3zlUoWaQz9eXrayIsaUwKWLrnUuGDz3
         VaS4XjjBQMNsQIcQC9RyksF0j68kMV2GDGijmHvfWLmFnAfH0JC5nqaquScGz7wlOsXU
         dD0JI6MHgCsf1cw5MXs1w8UyNGWoPmfwKSOZ/VHgVaXv6/jN5FVrQftEtg0ZIEsLtQIS
         fqag==
X-Gm-Message-State: AOAM531w4/Fu97aPo1AzOWbPZ3bt/RFQYxP3LAad2gRYl91AnvpANBb1
        JkXq7xKZx8F9uS9dZPpgoFMFUQ==
X-Google-Smtp-Source: ABdhPJxqTYOZv5vdTLGtePWSSg6MPyuKCqun2mPtVFqYJe81oXd88wkGlIl/yys9LFK5he7RlMt64Q==
X-Received: by 2002:adf:f511:: with SMTP id q17mr5718423wro.192.1603980521440;
        Thu, 29 Oct 2020 07:08:41 -0700 (PDT)
Received: from apalos.home (athedsl-246545.home.otenet.gr. [85.73.10.175])
        by smtp.gmail.com with ESMTPSA id p13sm5228508wrt.73.2020.10.29.07.08.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2020 07:08:40 -0700 (PDT)
Date:   Thu, 29 Oct 2020 16:08:38 +0200
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Subject: Re: [PATCH net-next 1/4] net: xdp: introduce bulking for xdp tx
 return path
Message-ID: <20201029140838.GA69963@apalos.home>
References: <cover.1603824486.git.lorenzo@kernel.org>
 <7495b5ac96b0fd2bf5ab79b12e01bf0ee0fff803.1603824486.git.lorenzo@kernel.org>
 <20201029145239.6f6d1713@carbon>
 <20201029140216.GE15697@lore-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201029140216.GE15697@lore-desk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 29, 2020 at 03:02:16PM +0100, Lorenzo Bianconi wrote:
> > On Tue, 27 Oct 2020 20:04:07 +0100
> > Lorenzo Bianconi <lorenzo@kernel.org> wrote:
> > 
> > > diff --git a/net/core/xdp.c b/net/core/xdp.c
> > > index 48aba933a5a8..93eabd789246 100644
> > > --- a/net/core/xdp.c
> > > +++ b/net/core/xdp.c
> > > @@ -380,6 +380,57 @@ void xdp_return_frame_rx_napi(struct xdp_frame *xdpf)
> > >  }
> > >  EXPORT_SYMBOL_GPL(xdp_return_frame_rx_napi);
> > >  
> > > +void xdp_flush_frame_bulk(struct xdp_frame_bulk *bq)
> > > +{
> > > +	struct xdp_mem_allocator *xa = bq->xa;
> > > +	int i;
> > > +
> > > +	if (unlikely(!xa))
> > > +		return;
> > > +
> > > +	for (i = 0; i < bq->count; i++) {
> > > +		struct page *page = virt_to_head_page(bq->q[i]);
> > > +
> > > +		page_pool_put_full_page(xa->page_pool, page, false);
> > > +	}
> > > +	bq->count = 0;
> > > +}
> > > +EXPORT_SYMBOL_GPL(xdp_flush_frame_bulk);
> > > +
> > > +void xdp_return_frame_bulk(struct xdp_frame *xdpf,
> > > +			   struct xdp_frame_bulk *bq)
> > > +{
> > > +	struct xdp_mem_info *mem = &xdpf->mem;
> > > +	struct xdp_mem_allocator *xa, *nxa;
> > > +
> > > +	if (mem->type != MEM_TYPE_PAGE_POOL) {
> > > +		__xdp_return(xdpf->data, &xdpf->mem, false);
> > > +		return;
> > > +	}
> > > +
> > > +	rcu_read_lock();
> > > +
> > > +	xa = bq->xa;
> > > +	if (unlikely(!xa || mem->id != xa->mem.id)) {
> > > +		nxa = rhashtable_lookup(mem_id_ht, &mem->id, mem_id_rht_params);
> > > +		if (unlikely(!xa)) {
> > > +			bq->count = 0;
> > > +			bq->xa = nxa;
> > > +			xa = nxa;
> > > +		}
> > > +	}
> > > +
> > > +	if (mem->id != xa->mem.id || bq->count == XDP_BULK_QUEUE_SIZE)
> > > +		xdp_flush_frame_bulk(bq);
> > > +
> > > +	bq->q[bq->count++] = xdpf->data;
> > > +	if (mem->id != xa->mem.id)
> > > +		bq->xa = nxa;
> > > +
> > > +	rcu_read_unlock();
> > > +}
> > > +EXPORT_SYMBOL_GPL(xdp_return_frame_bulk);
> > 
> > We (Ilias my co-maintainer and I) think above code is hard to read and
> > understand (as a reader you need to keep too many cases in your head).
> > 
> > I think we both have proposals to improve this, here is mine:
> > 
> > /* Defers return when frame belongs to same mem.id as previous frame */
> > void xdp_return_frame_bulk(struct xdp_frame *xdpf,
> >                            struct xdp_frame_bulk *bq)
> > {
> >         struct xdp_mem_info *mem = &xdpf->mem;
> >         struct xdp_mem_allocator *xa;
> > 
> >         if (mem->type != MEM_TYPE_PAGE_POOL) {
> >                 __xdp_return(xdpf->data, &xdpf->mem, false);
> >                 return;
> >         }
> > 
> >         rcu_read_lock();
> > 
> >         xa = bq->xa;
> >         if (unlikely(!xa)) {
> > 		xa = rhashtable_lookup(mem_id_ht, &mem->id, mem_id_rht_params);
> >                 bq->count = 0;
> >                 bq->xa = xa;
> >         }
> > 
> >         if (bq->count == XDP_BULK_QUEUE_SIZE)
> >                 xdp_flush_frame_bulk(bq);
> > 
> >         if (mem->id != xa->mem.id) {
> > 		xdp_flush_frame_bulk(bq);
> > 		bq->xa = rhashtable_lookup(mem_id_ht, &mem->id, mem_id_rht_params);
> >         }
> > 
> > 	bq->q[bq->count++] = xdpf->data;
> > 
> >         rcu_read_unlock();
> > }
> > 
> > Please review for correctness, and also for readability.
> 
> the code seems fine to me (and even easier to read :)).
> I will update v2 using this approach. Thx.
+1 this is close to what we discussed this morning and it detangles 1 more 'weird' 
if case 


Thanks
/Ilias
> 
> Regards,
> Lorenzo
> 
> > 
> > -- 
> > Best regards,
> >   Jesper Dangaard Brouer
> >   MSc.CS, Principal Kernel Engineer at Red Hat
> >   LinkedIn: http://www.linkedin.com/in/brouer
> > 


