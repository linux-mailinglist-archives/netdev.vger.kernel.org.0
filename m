Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 830923C94A0
	for <lists+netdev@lfdr.de>; Thu, 15 Jul 2021 01:44:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237842AbhGNXrk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Jul 2021 19:47:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbhGNXri (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Jul 2021 19:47:38 -0400
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43316C06175F;
        Wed, 14 Jul 2021 16:44:46 -0700 (PDT)
Received: by mail-io1-xd31.google.com with SMTP id z9so4225654iob.8;
        Wed, 14 Jul 2021 16:44:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=wLJVHyN0zuqaH8pm9fVENNAMgnX0yWSPVosc8+lEcLA=;
        b=sIkGnQ2cJTWswbElZXqSU8ihIKHQzfymboi7bjmMjl2kpE8+1M16mSdRP0XpYSkbxB
         5L5qOfyOKzXj6/IcJ/xyipsvwaGydcJauMedJ0G0lsm8fNQ9rn0xD3z5QXtghSgdQomq
         NBc+ML7Y2ouneRjRF/n/VXSqGJb4S/X6Xll/hhvb+lbb4UPFnD1vtT6Y8lD5PjIRcTSS
         smH/unBtioLd+nbK1cfB3pUvcw4/4TRSwsZaJ0cKKxErmrB80ZZgY7NB/EMgbN71b4UR
         mFLB4rEIvr41w/C2Wn0Hd5sQzYd1NaOx7JhFtGgU3XuykGopEgEhznLo4UgrEWgur7j1
         u51w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=wLJVHyN0zuqaH8pm9fVENNAMgnX0yWSPVosc8+lEcLA=;
        b=d0l5S9NCJzsig8P9zACaULL1eFLw91DqAUkHymezXSZt6Bz6m39RdvTZAdUl/oPfP7
         xGqzAmws8dTjexMMMJTQGfwUCGDToUyUsGHb+trvBhpB+NmGCOnzDqfxUZBOZfAPpzAr
         Y8WGkUC9h3C5ubQ9FZjAaNplFObKC3N7EUzAC8X8NTHXsL3/hweUe5eKGw76403w1rLq
         V/E/PhotfvFcfOovd31ibepFvOHG3Ooh5yWBeXZXt+S0A9IndEszNmo/+TIJbPzx4JOK
         +5qN+oFo/KSeor7Pmp+LUY1lNbUmT5UFMlo9ASJzy7CXzvRZLlOEXiANAgG7fSc7nUem
         F+IQ==
X-Gm-Message-State: AOAM531Hfk+4cto2twboY0/4RGXSwlDVa+Li/c1BpgFbkHtYIuJGcbEs
        8ktQ3VJJ7VvZHelgA88Bpto=
X-Google-Smtp-Source: ABdhPJyWXtnz52Ga2cp0mUqmPtKQ8hZnZNeQ4W3n/zqVhdUQhYmMrCxoEAH0jS5VCdP8rEqO0OhUsg==
X-Received: by 2002:a05:6638:1350:: with SMTP id u16mr624712jad.19.1626306285686;
        Wed, 14 Jul 2021 16:44:45 -0700 (PDT)
Received: from localhost ([172.243.157.240])
        by smtp.gmail.com with ESMTPSA id x9sm1886431iov.45.2021.07.14.16.44.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jul 2021 16:44:45 -0700 (PDT)
Date:   Wed, 14 Jul 2021 16:44:37 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, alexander.duyck@gmail.com,
        brouer@redhat.com, echaudro@redhat.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com
Message-ID: <60ef76e5d2379_5a0c12081c@john-XPS-13-9370.notmuch>
In-Reply-To: <YOykin2acwjMjfRj@lore-desk>
References: <cover.1625828537.git.lorenzo@kernel.org>
 <16f4244f5a506143f5becde501f1ecb120255b42.1625828537.git.lorenzo@kernel.org>
 <60ec8dfeb42aa_50e1d20857@john-XPS-13-9370.notmuch>
 <YOykin2acwjMjfRj@lore-desk>
Subject: Re: [PATCH bpf-next 2/2] net: xdp: add xdp_update_skb_shared_info
 utility routine
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lorenzo Bianconi wrote:
> > Lorenzo Bianconi wrote:
> > > Introduce xdp_update_skb_shared_info routine to update frags array
> > > metadata from a given xdp_buffer/xdp_frame. We do not need to reset
> > > frags array since it is already initialized by the driver.
> > > Rely on xdp_update_skb_shared_info in mvneta driver.
> > 
> > Some more context here would really help. I had to jump into the mvneta
> > driver to see what is happening.
> 
> Hi John,
> 
> ack, you are right. I will add more context next time. Sorry for the noise.
> 
> > 
> > So as I read this we have a loop processing the descriptor in
> > mvneta_rx_swbm()
> > 
> >  mvneta_rx_swbm()
> >    while (rx_proc < budget && rx_proc < rx_todo) {
> >      if (rx_status & MVNETA_RXD_FIRST_DESC) ...
> >      else {
> >        mvneta_swbm_add_rx_fragment()
> >      }
> >      ..
> >      if (!rx_status & MVNETA_RXD_LAST_DESC)
> >          continue;
> >      ..
> >      if (xdp_prog)
> >        mvneta_run_xdp(...)
> >    }
> > 
> > roughly looking like above. First question, do you ever hit
> > !MVNETA_RXD_LAST_DESC today? I assume this is avoided by hardware
> > setup when XDP is enabled, otherwise _run_xdp() would be
> > broken correct? Next question, given last descriptor bit
> > logic whats the condition to hit the code added in this patch?
> > wouldn't we need more than 1 descriptor and then we would
> > skip the xdp_run... sorry lost me and its probably easier
> > to let you give the flow vs spending an hour trying to
> > track it down.
> 
> I will point it out in the new commit log, but this is a preliminary patch for
> xdp multi-buff support. In the current codebase xdp_update_skb_shared_info()
> is run just when the NIC is not running in XDP mode (please note
> mvneta_swbm_add_rx_fragment() is run even if xdp_prog is NULL).
> When we add xdp multi-buff support, xdp_update_skb_shared_info() will run even
> in XDP mode since we will remove the MTU constraint.
> 
> In the current codebsae the following condition can occur in non-XDP mode if
> the packet is split on 3 or more descriptors (e.g. MTU 9000):
> 
> if (!(rx_status & MVNETA_RXD_LAST_DESC))
>    continue;

But, as is there is no caller of xdp_update_skb_shared_info() so
I think we should move the these two patches into the series with
the multibuf support.

> 
> > 
> > But, in theory as you handle a hardware discriptor you can build
> > up a set of pages using them to create a single skb rather than a
> > skb per descriptor. But don't we know if pfmemalloc should be
> > done while we are building the frag list? Can't se just set it
> > vs this for loop in xdp_update_skb_shared_info(),
> 
> I added pfmemalloc code in xdp_update_skb_shared_info() in order to reuse it
> for the xdp_redirect use-case (e.g. whenever we redirect a xdp multi-buff
> in a veth or in a cpumap). I have a pending patch where I am using
> xdp_update_skb_shared_info in __xdp_build_skb_from_frame().

OK, but it adds an extra for loop and the related overhead. Can
we avoid this overhead and just set it from where we first
know we have a compound page. Or carry some bit through and
do a simpler check,

 if (pfmemalloc_needed) skb->pfmemalloc = true;

I guess in the case here its building the skb so performance is maybe
not as critical, but if it gets used in the redirect case then we
shouldn't be doing unnecessary for loops.

> 
> > 
> > > +	for (i = 0; i < nr_frags; i++) {
> > > +		struct page *page = skb_frag_page(&sinfo->frags[i]);
> > > +
> > > +		page = compound_head(page);
> > > +		if (page_is_pfmemalloc(page)) {
> > > +			skb->pfmemalloc = true;
> > > +			break;
> > > +		}
> > > +	}
> > > +}
> > 
> > ...
> > 
> > > diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
> > > index 361bc4fbe20b..abf2e50880e0 100644
> > > --- a/drivers/net/ethernet/marvell/mvneta.c
> > > +++ b/drivers/net/ethernet/marvell/mvneta.c
> > > @@ -2294,18 +2294,29 @@ mvneta_swbm_add_rx_fragment(struct mvneta_port *pp,
> > >  	rx_desc->buf_phys_addr = 0;
> > >  
> > >  	if (data_len > 0 && xdp_sinfo->nr_frags < MAX_SKB_FRAGS) {
> > > -		skb_frag_t *frag = &xdp_sinfo->frags[xdp_sinfo->nr_frags++];
> > > +		skb_frag_t *frag = &xdp_sinfo->frags[xdp_sinfo->nr_frags];
> > >  
> > >  		skb_frag_off_set(frag, pp->rx_offset_correction);
> > >  		skb_frag_size_set(frag, data_len);
> > >  		__skb_frag_set_page(frag, page);
> > > +		/* We don't need to reset pp_recycle here. It's already set, so
> > > +		 * just mark fragments for recycling.
> > > +		 */
> > > +		page_pool_store_mem_info(page, rxq->page_pool);
> > > +
> > > +		/* first fragment */
> > > +		if (!xdp_sinfo->nr_frags)
> > > +			xdp_sinfo->gso_type = *size;
> > 
> > Would be nice to also change 'int size' -> 'unsigned int size' so the
> > types matched. Presumably you really can't have a negative size.
> > 
> 
> ack
> 
> > Also how about giving gso_type a better name. xdp_sinfo->size maybe?
> 
> I did it in this way in order to avoid adding a union in skb_shared_info.
> What about adding an inline helper to set/get it? e.g.

What was wrong with the union?

> 
> static inline u32 xdp_get_data_len(struct skb_shared_info *sinfo)
> {
>     return sinfo->gso_type;
> }
> 
> static inline void xdp_set_data_len(struct skb_shared_info *sinfo, u32 datalen)
> {
>     sinfo->gso_type = datalen;
> }
> 
> Regards,
> Lorenzo
