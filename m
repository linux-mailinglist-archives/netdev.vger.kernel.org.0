Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24C1112A261
	for <lists+netdev@lfdr.de>; Tue, 24 Dec 2019 15:38:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726201AbfLXOia (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Dec 2019 09:38:30 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:24791 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726128AbfLXOia (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Dec 2019 09:38:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1577198307;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XhTSxydB787Fx7W9BGgbDNxwN40hZslUJG+z59R7n0E=;
        b=BeaE67WaapKET6OOCjeLlHP9Im4XGywSJxm8epcnRV0e1rc3IA37THhhRG/3opkoZEWCZR
        1NqZraHsu7Q6GvW/K+hnjCVFaJHn+euJCRDFqEId1W75nU6oe1MYalakCRt6yoV4wgU+wT
        P3U4m37yLCvsnqgcI8MBYjAt+Q3wmIM=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-378-UF75jLD4OVmNnmVBRVCQWQ-1; Tue, 24 Dec 2019 09:38:26 -0500
X-MC-Unique: UF75jLD4OVmNnmVBRVCQWQ-1
Received: by mail-lj1-f198.google.com with SMTP id 126so3088482ljj.10
        for <netdev@vger.kernel.org>; Tue, 24 Dec 2019 06:38:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XhTSxydB787Fx7W9BGgbDNxwN40hZslUJG+z59R7n0E=;
        b=tCghGLsmMWp8quFgWiFIx3BTCCbls7qwCwhpKWXdC/0ew5cmdm4D3XjUp60hexw3Kt
         HiprBVs8YLRKvLfiYFJfs8vEkWkIcMPxwSVffHxfwQe6hY+Udz3vHw5qXPUBu/QmoYG2
         V2de8a/ixUsHT99IVFR/mEctv8HbMwyS7KIZfjEB1e6EN6bKWS7fvhGJxwl8GjwyfVzB
         NoCsdzINIkMt+3KTUP6J5XtHkhK03tpZ1/ZZtGgfxQiqVEkA5Zadl85kLRfKpyDH+mtx
         Auj2dluCHiDskFG1+GiNPflyoP3bCaKC37ZG8utW5Vio0aBwPPI1zSp6lEAXVixOzXXz
         f3Yw==
X-Gm-Message-State: APjAAAWzywbthjE/lRHeOTxt2ztvlipTzFt7A9PanOmIAneClJUZyuWQ
        gbQEN6dYOWAEfyHvPihpGL/BCV7jsYIzRhmsfeKWUGaaFW335+KzT26hI7rm0kjWmn6Xbbl9hwa
        qsLaxKtEs27hS3o2IsJeHcal26wX2C/aH
X-Received: by 2002:a19:8456:: with SMTP id g83mr20275491lfd.0.1577198304965;
        Tue, 24 Dec 2019 06:38:24 -0800 (PST)
X-Google-Smtp-Source: APXvYqwFw9Zd5Ca/3FACYA3fL7tMqVTaYlHAdjxV9dGZw75keJELu67CLpVePZwmd49Rk96cz5eQO0KvH8Ik3APQQjY=
X-Received: by 2002:a19:8456:: with SMTP id g83mr20275481lfd.0.1577198304733;
 Tue, 24 Dec 2019 06:38:24 -0800 (PST)
MIME-Version: 1.0
References: <20191224010103.56407-1-mcroce@redhat.com> <20191224095229.GA24310@apalos.home>
 <20191224150058.4400ffab@carbon>
In-Reply-To: <20191224150058.4400ffab@carbon>
From:   Matteo Croce <mcroce@redhat.com>
Date:   Tue, 24 Dec 2019 15:37:49 +0100
Message-ID: <CAGnkfhzYdqBPvRM8j98HVMzeHSbJ8RyVH+nLpoKBuz2iqErPog@mail.gmail.com>
Subject: Re: [RFC net-next 0/2] mvpp2: page_pool support
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Luka Perkov <luka.perkov@sartura.hr>,
        Tomislav Tomasic <tomislav.tomasic@sartura.hr>,
        Marcin Wojtas <mw@semihalf.com>,
        Stefan Chulski <stefanc@marvell.com>,
        Nadav Haklai <nadavh@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 24, 2019 at 3:01 PM Jesper Dangaard Brouer
<brouer@redhat.com> wrote:
>
> On Tue, 24 Dec 2019 11:52:29 +0200
> Ilias Apalodimas <ilias.apalodimas@linaro.org> wrote:
>
> > On Tue, Dec 24, 2019 at 02:01:01AM +0100, Matteo Croce wrote:
> > > This patches change the memory allocator of mvpp2 from the frag allocator to
> > > the page_pool API. This change is needed to add later XDP support to mvpp2.
> > >
> > > The reason I send it as RFC is that with this changeset, mvpp2 performs much
> > > more slower. This is the tc drop rate measured with a single flow:
> > >
> > > stock net-next with frag allocator:
> > > rx: 900.7 Mbps 1877 Kpps
> > >
> > > this patchset with page_pool:
> > > rx: 423.5 Mbps 882.3 Kpps
> > >
> > > This is the perf top when receiving traffic:
> > >
> > >   27.68%  [kernel]            [k] __page_pool_clean_page
> >
> > This seems extremly high on the list.
>
> This looks related to the cost of dma unmap, as page_pool have
> PP_FLAG_DMA_MAP. (It is a little strange, as page_pool have flag
> DMA_ATTR_SKIP_CPU_SYNC, which should make it less expensive).
>
>
> > >    9.79%  [kernel]            [k] get_page_from_freelist
>
> You are clearly hitting page-allocator every time, because you are not
> using page_pool recycle facility.
>
>
> > >    7.18%  [kernel]            [k] free_unref_page
> > >    4.64%  [kernel]            [k] build_skb
> > >    4.63%  [kernel]            [k] __netif_receive_skb_core
> > >    3.83%  [mvpp2]             [k] mvpp2_poll
> > >    3.64%  [kernel]            [k] eth_type_trans
> > >    3.61%  [kernel]            [k] kmem_cache_free
> > >    3.03%  [kernel]            [k] kmem_cache_alloc
> > >    2.76%  [kernel]            [k] dev_gro_receive
> > >    2.69%  [mvpp2]             [k] mvpp2_bm_pool_put
> > >    2.68%  [kernel]            [k] page_frag_free
> > >    1.83%  [kernel]            [k] inet_gro_receive
> > >    1.74%  [kernel]            [k] page_pool_alloc_pages
> > >    1.70%  [kernel]            [k] __build_skb
> > >    1.47%  [kernel]            [k] __alloc_pages_nodemask
> > >    1.36%  [mvpp2]             [k] mvpp2_buf_alloc.isra.0
> > >    1.29%  [kernel]            [k] tcf_action_exec
> > >
> > > I tried Ilias patches for page_pool recycling, I get an improvement
> > > to ~1100, but I'm still far than the original allocator.
> --
> Best regards,
>   Jesper Dangaard Brouer
>   MSc.CS, Principal Kernel Engineer at Red Hat
>   LinkedIn: http://www.linkedin.com/in/brouer
>

The change I did to use the recycling is the following:

--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -3071,7 +3071,7 @@ static int mvpp2_rx(struct mvpp2_port *port,
struct napi_struct *napi,
    if (pp)
-       page_pool_release_page(pp, virt_to_page(data));
+      skb_mark_for_recycle(skb, virt_to_page(data), &rxq->xdp_rxq.mem);
    else
         dma_unmap_single_attrs(dev->dev.parent, dma_addr,




--
Matteo Croce
per aspera ad upstream

