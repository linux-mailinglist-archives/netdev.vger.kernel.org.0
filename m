Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BAB63CB0F2
	for <lists+netdev@lfdr.de>; Fri, 16 Jul 2021 05:05:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233494AbhGPDIa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Jul 2021 23:08:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231230AbhGPDI1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Jul 2021 23:08:27 -0400
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5594C06175F;
        Thu, 15 Jul 2021 20:05:32 -0700 (PDT)
Received: by mail-il1-x135.google.com with SMTP id p3so6969004ilg.8;
        Thu, 15 Jul 2021 20:05:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=PJ+hw8PNlTC++kFX4h3HnS0saGGkW8SyWcDurX2bA2I=;
        b=Z/nijpNtzsXrHv2DieRSSyJnis7h+yuY5QAY8HbdY4r7S/lIi+Fp9HyQ589oJFIYZa
         hb32LpQZJvyxnyzaPnodowB1bS6SaJ8lquDyPPxH8lLf1Brs7qyJFORZl9DecDm0KDS4
         MPGXBDI6ULM8pYtw0NyJb5AwaveDwYKbzpE4LOP0NelSZWHp0sWZJPk53HfxmxSWzy0O
         8YvOcf+x4MwcZboBa8L79KH2KQi4wo4R4XaAVtSSYXxePtyuSWTFjzW7ga9fO0CU7dco
         nc7zhd4jGA7g5+bEOpi7jtJmp1fz1JcLARe05liItS0hor76ytQKaQqH9L1BBDc0pZAw
         1B3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=PJ+hw8PNlTC++kFX4h3HnS0saGGkW8SyWcDurX2bA2I=;
        b=sNQWBXQz0QqR0lLBwYrt/0OekSSNCXhvQkcEHbF9oXiMK2NCBYYswBIJxnKeSvVWUN
         6VZWnFk2zbQbo9A3S1PWCVfR+2EHouWmNHrPcpO7xfkdie1u7Ve4OIc+UeHedvPAoMNu
         eDa8sffWGjevPFFg6NhJUrxPneJrRAl84qjeuEKza/WUtHFiEtZjLFPOTAEGSoDgqVa+
         8iYwxkvSWV1hdj7miyASZy8usbRD4xxUxmZs8rQg4IG3x+jDBTpkBJago5q7TnxhWZ9U
         9BN5BxcU9pKYH+FHADeMUuYhm1Q9HPSrP9eEejAR1E5u5Upc6Undih24x9J/TmQ7vusH
         biVQ==
X-Gm-Message-State: AOAM5338dyssGr7rxviCmItTnV3sZZ0zptlSm5jJAV+qMGZNKlHzt0vo
        72s9EyXBE76QiEa1tt0x0eU=
X-Google-Smtp-Source: ABdhPJzI59q+bcNrSUqquKWTrD8sgXKjaOW4Spla1keUh6SKvBGH6+zLO27U9AxqmUvIQoumpoPFDQ==
X-Received: by 2002:a92:509:: with SMTP id q9mr4715951ile.239.1626404732169;
        Thu, 15 Jul 2021 20:05:32 -0700 (PDT)
Received: from localhost ([172.243.157.240])
        by smtp.gmail.com with ESMTPSA id m26sm4316479ioo.23.2021.07.15.20.05.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jul 2021 20:05:31 -0700 (PDT)
Date:   Thu, 15 Jul 2021 20:05:24 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, alexander.duyck@gmail.com,
        brouer@redhat.com, echaudro@redhat.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com
Message-ID: <60f0f774378fe_2a57208e5@john-XPS-13-9370.notmuch>
In-Reply-To: <YPDERccoAaRRlydI@lore-desk>
References: <cover.1625828537.git.lorenzo@kernel.org>
 <16f4244f5a506143f5becde501f1ecb120255b42.1625828537.git.lorenzo@kernel.org>
 <60ec8dfeb42aa_50e1d20857@john-XPS-13-9370.notmuch>
 <YOykin2acwjMjfRj@lore-desk>
 <60ef76e5d2379_5a0c12081c@john-XPS-13-9370.notmuch>
 <YPDERccoAaRRlydI@lore-desk>
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
> > > > Lorenzo Bianconi wrote:
> > > > > Introduce xdp_update_skb_shared_info routine to update frags array
> > > > > metadata from a given xdp_buffer/xdp_frame. We do not need to reset
> > > > > frags array since it is already initialized by the driver.
> > > > > Rely on xdp_update_skb_shared_info in mvneta driver.
> > > > 
> > > > Some more context here would really help. I had to jump into the mvneta
> > > > driver to see what is happening.
> > > 
> > > Hi John,
> > > 
> > > ack, you are right. I will add more context next time. Sorry for the noise.
> > > 
> > > > 
> > > > So as I read this we have a loop processing the descriptor in
> > > > mvneta_rx_swbm()
> > > > 
> > > >  mvneta_rx_swbm()
> > > >    while (rx_proc < budget && rx_proc < rx_todo) {
> > > >      if (rx_status & MVNETA_RXD_FIRST_DESC) ...
> > > >      else {
> > > >        mvneta_swbm_add_rx_fragment()
> > > >      }
> > > >      ..
> > > >      if (!rx_status & MVNETA_RXD_LAST_DESC)
> > > >          continue;
> > > >      ..
> > > >      if (xdp_prog)
> > > >        mvneta_run_xdp(...)
> > > >    }
> > > > 
> > > > roughly looking like above. First question, do you ever hit
> > > > !MVNETA_RXD_LAST_DESC today? I assume this is avoided by hardware
> > > > setup when XDP is enabled, otherwise _run_xdp() would be
> > > > broken correct? Next question, given last descriptor bit
> > > > logic whats the condition to hit the code added in this patch?
> > > > wouldn't we need more than 1 descriptor and then we would
> > > > skip the xdp_run... sorry lost me and its probably easier
> > > > to let you give the flow vs spending an hour trying to
> > > > track it down.
> > > 
> > > I will point it out in the new commit log, but this is a preliminary patch for
> > > xdp multi-buff support. In the current codebase xdp_update_skb_shared_info()
> > > is run just when the NIC is not running in XDP mode (please note
> > > mvneta_swbm_add_rx_fragment() is run even if xdp_prog is NULL).
> > > When we add xdp multi-buff support, xdp_update_skb_shared_info() will run even
> > > in XDP mode since we will remove the MTU constraint.
> > > 
> > > In the current codebsae the following condition can occur in non-XDP mode if
> > > the packet is split on 3 or more descriptors (e.g. MTU 9000):
> > > 
> > > if (!(rx_status & MVNETA_RXD_LAST_DESC))
> > >    continue;
> > 
> > But, as is there is no caller of xdp_update_skb_shared_info() so
> > I think we should move the these two patches into the series with
> > the multibuf support.
> 
> mvneta is currently using it building the skb in mvneta_swbm_build_skb()
> running in non-xdp mode but I am fine merging this series in the
> multi-buff one.

My preference is to add it where it will be used. So in the multi-buf
series.

> 
> > 
> > > 
> > > > 
> > > > But, in theory as you handle a hardware discriptor you can build
> > > > up a set of pages using them to create a single skb rather than a
> > > > skb per descriptor. But don't we know if pfmemalloc should be
> > > > done while we are building the frag list? Can't se just set it
> > > > vs this for loop in xdp_update_skb_shared_info(),
> > > 
> > > I added pfmemalloc code in xdp_update_skb_shared_info() in order to reuse it
> > > for the xdp_redirect use-case (e.g. whenever we redirect a xdp multi-buff
> > > in a veth or in a cpumap). I have a pending patch where I am using
> > > xdp_update_skb_shared_info in __xdp_build_skb_from_frame().
> > 
> > OK, but it adds an extra for loop and the related overhead. Can
> > we avoid this overhead and just set it from where we first
> > know we have a compound page. Or carry some bit through and
> > do a simpler check,
> > 
> >  if (pfmemalloc_needed) skb->pfmemalloc = true;
> > 
> > I guess in the case here its building the skb so performance is maybe
> > not as critical, but if it gets used in the redirect case then we
> > shouldn't be doing unnecessary for loops.
> 
> doing so every driver will need to take care of it building the xdp_buff.
> Does it work to do it since probably multi-buff is not critical for
> performance?

OK, but I think we need to improve performance in some of the 100Gbps
drivers. Work is in progress so any thing that has potential to slow
things down again I want to call out. I agree this might be OK and
only matters for nr_frags case.

> In order to support xdp_redirect we need to save this info in
> xdp_buff/xdp_frame, maybe in the flag field added in xdp multi-buff series.

Yeah I think that would work better if possible.

> 
> > 
> > > 
> > > > 
> > > > > +	for (i = 0; i < nr_frags; i++) {
> > > > > +		struct page *page = skb_frag_page(&sinfo->frags[i]);
> > > > > +
> > > > > +		page = compound_head(page);
> > > > > +		if (page_is_pfmemalloc(page)) {
> > > > > +			skb->pfmemalloc = true;
> > > > > +			break;
> > > > > +		}
> > > > > +	}
> > > > > +}
> > > > 
> > > > ...
> > > > 
> > > > > diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
> > > > > index 361bc4fbe20b..abf2e50880e0 100644
> > > > > --- a/drivers/net/ethernet/marvell/mvneta.c
> > > > > +++ b/drivers/net/ethernet/marvell/mvneta.c
> > > > > @@ -2294,18 +2294,29 @@ mvneta_swbm_add_rx_fragment(struct mvneta_port *pp,
> > > > >  	rx_desc->buf_phys_addr = 0;
> > > > >  
> > > > >  	if (data_len > 0 && xdp_sinfo->nr_frags < MAX_SKB_FRAGS) {
> > > > > -		skb_frag_t *frag = &xdp_sinfo->frags[xdp_sinfo->nr_frags++];
> > > > > +		skb_frag_t *frag = &xdp_sinfo->frags[xdp_sinfo->nr_frags];
> > > > >  
> > > > >  		skb_frag_off_set(frag, pp->rx_offset_correction);
> > > > >  		skb_frag_size_set(frag, data_len);
> > > > >  		__skb_frag_set_page(frag, page);
> > > > > +		/* We don't need to reset pp_recycle here. It's already set, so
> > > > > +		 * just mark fragments for recycling.
> > > > > +		 */
> > > > > +		page_pool_store_mem_info(page, rxq->page_pool);
> > > > > +
> > > > > +		/* first fragment */
> > > > > +		if (!xdp_sinfo->nr_frags)
> > > > > +			xdp_sinfo->gso_type = *size;
> > > > 
> > > > Would be nice to also change 'int size' -> 'unsigned int size' so the
> > > > types matched. Presumably you really can't have a negative size.
> > > > 
> > > 
> > > ack
> > > 
> > > > Also how about giving gso_type a better name. xdp_sinfo->size maybe?
> > > 
> > > I did it in this way in order to avoid adding a union in skb_shared_info.
> > > What about adding an inline helper to set/get it? e.g.
> > 
> > What was wrong with the union?
> 
> Alex requested to use gso_* fields already there (the union was in the previous
> version I sent).

@Alex, I think you were just saying union the gso_size field not the
tskey field.  Anyways its a fairly small nit on my side I don't care
much either way.

> 
> Regards,
> Lorenzo
