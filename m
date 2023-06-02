Return-Path: <netdev+bounces-7522-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C9947208B5
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 20:00:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3705D281A3F
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 18:00:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6439519536;
	Fri,  2 Jun 2023 18:00:46 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C8E4332EE
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 18:00:46 +0000 (UTC)
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BB9A123;
	Fri,  2 Jun 2023 11:00:44 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id 98e67ed59e1d1-256e1d87a46so1154304a91.0;
        Fri, 02 Jun 2023 11:00:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685728844; x=1688320844;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=przK18vRT0zCHgc2Ms43sB7BY+Y+MRlKaT+sSKUYQsQ=;
        b=Mj/Y1Tfg9CZxODZpoMOuAnXyJ4VhAtOZZGFtAX+LvE9mbVPXA0PkHvSbrijeuMeQ9Q
         7GiI5Zkl8D49H97hX3Z5lZfxX83kQA1DTpcEGSbgDWVbi6AN0ySdJZSko9kIGUId4BpU
         kLSXu46ldxN5SCTqzbVqcacDKSmcvx2mr6d6YDtj0CyiENntTYlBLAOxJeJheWqjx2on
         eXpFxLltZN+wGmfs1KMWH9ESZejYhtMzy4GRbg5IAbTe1rlznN6yuqfRd9fd7jmJPW3z
         ZEbbwYTbU1zHVkVbx8G/vw2WZ0pbNYhKQ3NkuAytOb583DvFHnJskFWSMl5yO67MQMvr
         MFhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685728844; x=1688320844;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=przK18vRT0zCHgc2Ms43sB7BY+Y+MRlKaT+sSKUYQsQ=;
        b=Gz93kt45Gs6plPRPZC2EvuOm6RZwetJGpIV1ATXS19Phmx75k4VlVw7hAjNE4rbGBp
         8IrxQOrNEduDatieGJA9VxM5vN1ZCsNB1YlUSMk+yAbulTvXWyZA1B/ZmV2oqwfMnLco
         y/PUcpo7yf9YC0p4OXQUbgiijxPr0u6poyPrhbhQ2l3PAxHgZnm/fQTrDDAJDcSuZjqa
         au9vtvmku1y78lQ9cWJRh3xk07WE3Kqx2eeMuzK+zqrPuXvD6rkZOHZPpP4wOhZCwzAf
         9An7sJZZVkmObV6Hyy//z8hsYEmIE4335jl/TXGFUyUqtXaZErHvBxP97hDS9t3xIzmE
         gCIg==
X-Gm-Message-State: AC+VfDwcQFlWVSOGaFdPZ4OhS5BnfowZ+uHe+CqqOIeOPdfvOUjrcbKL
	11hWc/WumQz8pngh6mf16URo/CvJN6/gnzfnc14=
X-Google-Smtp-Source: ACHHUZ72UIMKwVCWqtcz2aAXhMbLxbQwkCTiu6JUWlIeuEo95vb2MDtYIVmCLhICRk8Uvv7sApPWNeKNJdWyFNc2p9Q=
X-Received: by 2002:a17:90a:2f04:b0:258:fe26:9721 with SMTP id
 s4-20020a17090a2f0400b00258fe269721mr396310pjd.17.1685728843506; Fri, 02 Jun
 2023 11:00:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230530150035.1943669-1-aleksander.lobakin@intel.com>
 <20230530150035.1943669-10-aleksander.lobakin@intel.com> <0962a8a8493f0c892775cda8affb93c20f8b78f7.camel@gmail.com>
 <51f558e3-7ccd-45cd-d944-73997765fd12@intel.com>
In-Reply-To: <51f558e3-7ccd-45cd-d944-73997765fd12@intel.com>
From: Alexander Duyck <alexander.duyck@gmail.com>
Date: Fri, 2 Jun 2023 11:00:07 -0700
Message-ID: <CAKgT0Ue7US2wwZXXU6HcGPBZWg+pSZ=PE_HWxJHgF8bmLymkfg@mail.gmail.com>
Subject: Re: [PATCH net-next v3 09/12] iavf: switch to Page Pool
To: Alexander Lobakin <aleksander.lobakin@intel.com>
Cc: Jakub Kicinski <kuba@kernel.org>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, 
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>, Magnus Karlsson <magnus.karlsson@intel.com>, 
	Michal Kubiak <michal.kubiak@intel.com>, Larysa Zaremba <larysa.zaremba@intel.com>, 
	Jesper Dangaard Brouer <hawk@kernel.org>, Ilias Apalodimas <ilias.apalodimas@linaro.org>, 
	Christoph Hellwig <hch@lst.de>, Paul Menzel <pmenzel@molgen.mpg.de>, netdev@vger.kernel.org, 
	intel-wired-lan@lists.osuosl.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, Jun 2, 2023 at 9:31=E2=80=AFAM Alexander Lobakin
<aleksander.lobakin@intel.com> wrote:
>
> From: Alexander H Duyck <alexander.duyck@gmail.com>
> Date: Wed, 31 May 2023 09:19:06 -0700
>
> > On Tue, 2023-05-30 at 17:00 +0200, Alexander Lobakin wrote:
> >> Now that the IAVF driver simply uses dev_alloc_page() + free_page() wi=
th
> >> no custom recycling logics and one whole page per frame, it can easily
> >> be switched to using Page Pool API instead.
>
> [...]
>
> >> @@ -691,8 +690,6 @@ int iavf_setup_tx_descriptors(struct iavf_ring *tx=
_ring)
> >>   **/
> >>  void iavf_clean_rx_ring(struct iavf_ring *rx_ring)
> >>  {
> >> -    u16 i;
> >> -
> >>      /* ring already cleared, nothing to do */
> >>      if (!rx_ring->rx_pages)
> >>              return;
> >> @@ -703,28 +700,17 @@ void iavf_clean_rx_ring(struct iavf_ring *rx_rin=
g)
> >>      }
> >>
> >>      /* Free all the Rx ring sk_buffs */
> >> -    for (i =3D 0; i < rx_ring->count; i++) {
> >> +    for (u32 i =3D 0; i < rx_ring->count; i++) {
> >
> > Did we make a change to our coding style to allow declaration of
> > variables inside of for statements? Just wondering if this is a change
> > since the recent updates to the ISO C standard, or if this doesn't
> > match up with what we would expect per the coding standard.
>
> It's optional right now, nobody would object declaring it either way.
> Doing it inside is allowed since we switched to C11, right.
> Here I did that because my heart was breaking to see this little u16
> alone (and yeah, u16 on the stack).

Yeah, that was back when I was declaring stack variables the exact
same size as the ring parameters. So u16 should match the size of
rx_ring->count not that it matters. It was just a quirk I had at the
time.

> >
> >>              struct page *page =3D rx_ring->rx_pages[i];
> >> -            dma_addr_t dma;
> >>
> >>              if (!page)
> >>                      continue;
> >>
> >> -            dma =3D page_pool_get_dma_addr(page);
> >> -
> >>              /* Invalidate cache lines that may have been written to b=
y
> >>               * device so that we avoid corrupting memory.
> >>               */
> >> -            dma_sync_single_range_for_cpu(rx_ring->dev, dma,
> >> -                                          LIBIE_SKB_HEADROOM,
> >> -                                          LIBIE_RX_BUF_LEN,
> >> -                                          DMA_FROM_DEVICE);
> >> -
> >> -            /* free resources associated with mapping */
> >> -            dma_unmap_page_attrs(rx_ring->dev, dma, LIBIE_RX_TRUESIZE=
,
> >> -                                 DMA_FROM_DEVICE, IAVF_RX_DMA_ATTR);
> >> -
> >> -            __free_page(page);
> >> +            page_pool_dma_sync_full_for_cpu(rx_ring->pool, page);
> >> +            page_pool_put_full_page(rx_ring->pool, page, false);
> >>      }
> >>
> >>      rx_ring->next_to_clean =3D 0;
> >> @@ -739,10 +725,15 @@ void iavf_clean_rx_ring(struct iavf_ring *rx_rin=
g)
> >>   **/
> >>  void iavf_free_rx_resources(struct iavf_ring *rx_ring)
> >>  {
> >> +    struct device *dev =3D rx_ring->pool->p.dev;
> >> +
> >>      iavf_clean_rx_ring(rx_ring);
> >>      kfree(rx_ring->rx_pages);
> >>      rx_ring->rx_pages =3D NULL;
> >>
> >> +    page_pool_destroy(rx_ring->pool);
> >> +    rx_ring->dev =3D dev;
> >> +
> >>      if (rx_ring->desc) {
> >>              dma_free_coherent(rx_ring->dev, rx_ring->size,
> >>                                rx_ring->desc, rx_ring->dma);
> >
> > Not a fan of this switching back and forth between being a page pool
> > pointer and a dev pointer. Seems problematic as it is easily
> > misinterpreted. I would say that at a minimum stick to either it is
> > page_pool(Rx) or dev(Tx) on a ring type basis.
>
> The problem is that page_pool has lifetime from ifup to ifdown, while
> its ring lives longer. So I had to do something with this, but also I
> didn't want to have 2 pointers at the same time since it's redundant and
> +8 bytes to the ring for nothing.

It might be better to just go with NULL rather than populating it w/
two different possible values. Then at least you know if it is an
rx_ring it is a page_pool and if it is a tx_ring it is dev. You can
reset to the page pool when you repopulate the rest of the ring.

> > This setup works for iavf, however for i40e/ice you may run into issues
> > since the setup_rx_descriptors call is also used to setup the ethtool
> > loopback test w/o a napi struct as I recall so there may not be a
> > q_vector.
>
> I'll handle that. Somehow :D Thanks for noticing, I'll take a look
> whether I should do something right now or it can be done later when
> switching the actual mentioned drivers.
>
> [...]
>
> >> @@ -240,7 +237,10 @@ struct iavf_rx_queue_stats {
> >>  struct iavf_ring {
> >>      struct iavf_ring *next;         /* pointer to next ring in q_vect=
or */
> >>      void *desc;                     /* Descriptor ring memory */
> >> -    struct device *dev;             /* Used for DMA mapping */
> >> +    union {
> >> +            struct page_pool *pool; /* Used for Rx page management */
> >> +            struct device *dev;     /* Used for DMA mapping on Tx */
> >> +    };
> >>      struct net_device *netdev;      /* netdev ring maps to */
> >>      union {
> >>              struct iavf_tx_buffer *tx_bi;
> >
> > Would it make more sense to have the page pool in the q_vector rather
> > than the ring? Essentially the page pool is associated per napi
> > instance so it seems like it would make more sense to store it with the
> > napi struct rather than potentially have multiple instances per napi.
>
> As per Page Pool design, you should have it per ring. Plus you have
> rxq_info (XDP-related structure), which is also per-ring and
> participates in recycling in some cases. So I wouldn't complicate.
> I went down the chain and haven't found any place where having more than
> 1 PP per NAPI would break anything. If I got it correctly, Jakub's
> optimization discourages having 1 PP per several NAPIs (or scheduling
> one NAPI on different CPUs), but not the other way around. The goal was
> to exclude concurrent access to one PP from different threads, and here
> it's impossible.

The xdp_rxq can be mapped many:1 to the page pool if I am not mistaken.

The only reason why I am a fan of trying to keep the page_pool tightly
associated with the napi instance is because the napi instance is what
essentially is guaranteeing the page_pool is consistent as it is only
accessed by that one napi instance.

> Lemme know. I can always disable NAPI optimization for cases when one
> vector is shared by several queues -- and it's not a usual case for
> these NICs anyway -- but I haven't found a reason for that.

I suppose we should be fine if we have a many to one mapping though I
suppose. As you said the issue would be if multiple NAPI were
accessing the same page pool.

