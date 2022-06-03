Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDE3953CC57
	for <lists+netdev@lfdr.de>; Fri,  3 Jun 2022 17:33:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245541AbiFCPdl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jun 2022 11:33:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230520AbiFCPdk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jun 2022 11:33:40 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BE2744A14;
        Fri,  3 Jun 2022 08:33:39 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id fd25so10652128edb.3;
        Fri, 03 Jun 2022 08:33:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oq/7Nt8hH+8An2BVROqJRuKS0FRepvvGNwqF4LhpwJ4=;
        b=DzV8Du2HCN9eSAgLq3MmS7PYFIDS1VRh6mUcBFhEV21yX/IAgSreSh/t0mxzUtlImT
         rfOo2ZsgUXTal15h7gqJ3yfC67EuvjyOCTFfTAcVFPBROXrLgimo9pbQA2jauTKqdiHv
         8rYPBk3HZh2QD+PnAMm9CTzNQeC5kO98ipf8eDi4YcO3RoVLWo/3YXOTCHmj0RWgcqGV
         p2isfYtVh+mgHQ+vs/Y7M792D41OHL9f2VzELxLiQe6NQ8qI8ZrlyU+QZtDPjUQKZowp
         h7ivIuhuz8cQZi3TiKh9mmfcCwiZR1BLqwfiiwt7n4xMegJPJiL3JMgE2+XaZ9FfJl8o
         1xMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oq/7Nt8hH+8An2BVROqJRuKS0FRepvvGNwqF4LhpwJ4=;
        b=p6bJLr3//zxGLT86rkDCdFcBgy+5YDqDsQEKUtr5hROZQ+vNEKMY5lN0l6ORJhcTj0
         OgJEZlbmOpbMOZMYsCmxOCSIdsmdTaWgmAip3eLPIZA0O7AcdVh7Q/VfJPssGxHJDAk3
         faxhQZMjlvkknxNNnJ2uDITCmeC037clNCftBprAB7jPjPzwF9+PasvlDeQd0aKOIFMS
         ryGk+o+xWHycJVCpIuDnxWu2cX2jI4hdtJFmGGRbc6H1jh07k330CQfSZS5cYGITSSsd
         DxVnxjxfLLos9nq1YjSUvdW/oh1gCFynl1RVZwzbw2kPoRrh7BJCTsf8lO6r/SCjlwlK
         NaMg==
X-Gm-Message-State: AOAM530ENG2Y39qOn+BH+qOWNEzFooLVhCx7uumlFsFir5a12VU9vvKW
        8L/RKCbPo1AphIR0aYz1ZcO1C4pqovu0F6ecKjk=
X-Google-Smtp-Source: ABdhPJx9Um0Wr5FdUvDXEQcoa+psDOXWhyl3zgwebxsBe9AFwJLM9ZB77SuRP2YlibAkeQyKiO2cU5TxiNb6TkEepiU=
X-Received: by 2002:a05:6402:1399:b0:410:9fa2:60d6 with SMTP id
 b25-20020a056402139900b004109fa260d6mr11253369edv.35.1654270416705; Fri, 03
 Jun 2022 08:33:36 -0700 (PDT)
MIME-Version: 1.0
References: <2997c5b0-3611-5e00-466c-b2966f09f067@nbd.name>
 <1654245968-8067-1-git-send-email-chen45464546@163.com> <CAKgT0Uc9vSEJxrev10Uc3P==+tTip7+7W=AF2uE+VB3GVyOTxg@mail.gmail.com>
In-Reply-To: <CAKgT0Uc9vSEJxrev10Uc3P==+tTip7+7W=AF2uE+VB3GVyOTxg@mail.gmail.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Fri, 3 Jun 2022 08:33:25 -0700
Message-ID: <CAKgT0UdR-bdiZXsV_=8yJUS8zjoO6jeBS5bKNWAyxwLCiOP8ZQ@mail.gmail.com>
Subject: Re: [PATCH v2] net: ethernet: mtk_eth_soc: fix misuse of mem alloc
 interface netdev[napi]_alloc_frag
To:     Chen Lin <chen45464546@163.com>
Cc:     Felix Fietkau <nbd@nbd.name>, Jakub Kicinski <kuba@kernel.org>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>, Mark-MC.Lee@mediatek.com,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, matthias.bgg@gmail.com,
        Netdev <netdev@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 3, 2022 at 8:25 AM Alexander Duyck
<alexander.duyck@gmail.com> wrote:
>
> On Fri, Jun 3, 2022 at 2:03 AM Chen Lin <chen45464546@163.com> wrote:
> >
> > When rx_flag == MTK_RX_FLAGS_HWLRO,
> > rx_data_len = MTK_MAX_LRO_RX_LENGTH(4096 * 3) > PAGE_SIZE.
> > netdev_alloc_frag is for alloction of page fragment only.
> > Reference to other drivers and Documentation/vm/page_frags.rst
> >
> > Branch to use alloc_pages when ring->frag_size > PAGE_SIZE.
> >
> > Signed-off-by: Chen Lin <chen45464546@163.com>
> > ---
> >  drivers/net/ethernet/mediatek/mtk_eth_soc.c |   22 ++++++++++++++++++++--
> >  1 file changed, 20 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
> > index b3b3c07..772d903 100644
> > --- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
> > +++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
> > @@ -1467,7 +1467,16 @@ static int mtk_poll_rx(struct napi_struct *napi, int budget,
> >                         goto release_desc;
> >
> >                 /* alloc new buffer */
> > -               new_data = napi_alloc_frag(ring->frag_size);
> > +               if (ring->frag_size <= PAGE_SIZE) {
> > +                       new_data = napi_alloc_frag(ring->frag_size);
> > +               } else {
> > +                       struct page *page;
> > +                       unsigned int order = get_order(ring->frag_size);
> > +
> > +                       page = alloc_pages(GFP_ATOMIC | __GFP_COMP |
> > +                                           __GFP_NOWARN, order);
> > +                       new_data = page ? page_address(page) : NULL;
> > +               }
> >                 if (unlikely(!new_data)) {
> >                         netdev->stats.rx_dropped++;
> >                         goto release_desc;
> > @@ -1914,7 +1923,16 @@ static int mtk_rx_alloc(struct mtk_eth *eth, int ring_no, int rx_flag)
> >                 return -ENOMEM;
> >
> >         for (i = 0; i < rx_dma_size; i++) {
> > -               ring->data[i] = netdev_alloc_frag(ring->frag_size);
> > +               if (ring->frag_size <= PAGE_SIZE) {
> > +                       ring->data[i] = netdev_alloc_frag(ring->frag_size);
> > +               } else {
> > +                       struct page *page;
> > +                       unsigned int order = get_order(ring->frag_size);
> > +
> > +                       page = alloc_pages(GFP_KERNEL | __GFP_COMP |
> > +                                           __GFP_NOWARN, order);
> > +                       ring->data[i] = page ? page_address(page) : NULL;
> > +               }
> >                 if (!ring->data[i])
> >                         return -ENOMEM;
> >         }
>
> Actually I looked closer at this driver. Is it able to receive frames
> larger than 2K? If not there isn't any point in this change.
>
> Based on commit 4fd59792097a ("net: ethernet: mediatek: support
> setting MTU") it looks like it doesn't, so odds are this patch is not
> necessary.

I spoke too soon. I had overlooked the LRO part. With that being the
case you can probably optimize this code to do away with the get_order
piece entirely, at least during runtime. My main concern is that doing
that in the fast-path will be expensive so you would be much better
off doing something like
get_order(mtk_max_frag_size(MTK_RX_FLAGS_HWLRO)) which would be
converted into a constant at compile time since everything else would
be less than 1 page in size.

Also you could then replace alloc_pages with __get_free_pages which
would take care of the page_address call for you.
