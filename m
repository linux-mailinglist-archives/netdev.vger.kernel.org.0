Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D51BD2D1851
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 19:19:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726294AbgLGSQj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 13:16:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725823AbgLGSQj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Dec 2020 13:16:39 -0500
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD4E8C061749
        for <netdev@vger.kernel.org>; Mon,  7 Dec 2020 10:15:58 -0800 (PST)
Received: by mail-ej1-x643.google.com with SMTP id f23so20873965ejk.2
        for <netdev@vger.kernel.org>; Mon, 07 Dec 2020 10:15:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3w4KBe0/Ya5q/TvCl0IhamMXx0Ovy+SeWS3pOWvhX/4=;
        b=iAaT/Sse4F+di2ishWUu5q11Ecvm5yHHkdaOeahQc1KUEXVXA2UClhT1pMI3LoShHy
         4pPecKXpVG2RTbfjzN9ha3T7e2CMvw/Cp0KABsMOU8btGH4JwpEhGb2ktHRaAKyGRpKa
         HgfRz1IYVbSqqSCoYikFAtE1bA2gqZXmFvUImsjRsqxo6SiHXJ4JFqlOrl2V0RpqL9XS
         2bHCzAyl/YanMs5TpWFROXfUT8ZtDCWkbrt05B67wG0DBHRpKsLBP+wBG48faGKzldWr
         Uff1a1pPyn+z+K4WUFPQmGMj1lhKhKcDCyXI+tgzHXxxnRvLaknPzseOMElGUW0wmt4s
         S/3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3w4KBe0/Ya5q/TvCl0IhamMXx0Ovy+SeWS3pOWvhX/4=;
        b=hCZoDmYeRhpJ/3EYdBsIr2LKruWUIItSHHjYHspVK+5xD/mDn8egg8qPB/vGBmQqkZ
         NZvzEkqC9LC+PXIe5blqnqLbC15Z7AHvXra3lDZjSVPL8bbHBabXApLPXnsjRDBc+OWQ
         EMjcshoY1NtKzFT3ZHwo2AwUzcDWiZvGdyAhlcmxNLuXaW+ZwUSWcGjYGgFaz187jtdK
         rFKDfVODoTkmZkpVVb9OPTBEn39/zwgLE4U2uy1T4fEMNk2qiAXJKdVtUShTKccnSVaR
         NdHxwf9zqPYdMO9pmnZ4n+fBvfZEK0sYM9wbKRofjd3beJRVfP2sWiBJFj9OnfB1n0AU
         Bv0w==
X-Gm-Message-State: AOAM530T42bHBMAiJTzT6FGGQQx+Dl3ESHYfFLr7EPg5gu+BWJg/QcmA
        jBnAt0F0ULJHiweCP652cx70SR9ELEt2ptgj9cy+fg==
X-Google-Smtp-Source: ABdhPJzWsWdUwZ7KiSYc6NrOnhIZMzyOk3aMpzjhW7CzFX46N7II02WwR7AGKrVsHNMqboazlmJu2NxezdpwNlrMEbQ=
X-Received: by 2002:a17:906:f8d4:: with SMTP id lh20mr20312473ejb.442.1607364957301;
 Mon, 07 Dec 2020 10:15:57 -0800 (PST)
MIME-Version: 1.0
References: <20201202182413.232510-1-awogbemila@google.com>
 <20201202182413.232510-5-awogbemila@google.com> <CAKgT0Uc66PS67HvrT8jzW0tCnzjRqaD1Hnm9-1YZ0XncTh_3BA@mail.gmail.com>
In-Reply-To: <CAKgT0Uc66PS67HvrT8jzW0tCnzjRqaD1Hnm9-1YZ0XncTh_3BA@mail.gmail.com>
From:   David Awogbemila <awogbemila@google.com>
Date:   Mon, 7 Dec 2020 10:15:46 -0800
Message-ID: <CAL9ddJc9OeVQWU6rMT4QV=vg4Brhwai69pbkvng3ALFE3wvdUg@mail.gmail.com>
Subject: Re: [PATCH net-next v9 4/4] gve: Add support for raw addressing in
 the tx path
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     Netdev <netdev@vger.kernel.org>, Saeed Mahameed <saeed@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Catherine Sullivan <csully@google.com>,
        Yangchun Fu <yangchun@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 3, 2020 at 10:16 AM Alexander Duyck
<alexander.duyck@gmail.com> wrote:
>
> On Wed, Dec 2, 2020 at 10:24 AM David Awogbemila <awogbemila@google.com> wrote:
> >
> > From: Catherine Sullivan <csully@google.com>
> >
> > During TX, skbs' data addresses are dma_map'ed and passed to the NIC.
> > This means that the device can perform DMA directly from these addresses
> > and the driver does not have to copy the buffer content into
> > pre-allocated buffers/qpls (as in qpl mode).
> >
> > Reviewed-by: Yangchun Fu <yangchun@google.com>
> > Signed-off-by: Catherine Sullivan <csully@google.com>
> > Signed-off-by: David Awogbemila <awogbemila@google.com>
> > ---
> >  drivers/net/ethernet/google/gve/gve.h         |  16 +-
> >  drivers/net/ethernet/google/gve/gve_adminq.c  |   4 +-
> >  drivers/net/ethernet/google/gve/gve_desc.h    |   8 +-
> >  drivers/net/ethernet/google/gve/gve_ethtool.c |   2 +
> >  drivers/net/ethernet/google/gve/gve_tx.c      | 197 ++++++++++++++----
> >  5 files changed, 185 insertions(+), 42 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/google/gve/gve.h b/drivers/net/ethernet/google/gve/gve.h
> > index 8aad4af2aa2b..9888fa92be86 100644
> > --- a/drivers/net/ethernet/google/gve/gve.h
> > +++ b/drivers/net/ethernet/google/gve/gve.h
> > @@ -112,12 +112,20 @@ struct gve_tx_iovec {
> >         u32 iov_padding; /* padding associated with this segment */
> >  };
> >
> > +struct gve_tx_dma_buf {
> > +       DEFINE_DMA_UNMAP_ADDR(dma);
> > +       DEFINE_DMA_UNMAP_LEN(len);
> > +};
> > +
> >  /* Tracks the memory in the fifo occupied by the skb. Mapped 1:1 to a desc
> >   * ring entry but only used for a pkt_desc not a seg_desc
> >   */
> >  struct gve_tx_buffer_state {
> >         struct sk_buff *skb; /* skb for this pkt */
> > -       struct gve_tx_iovec iov[GVE_TX_MAX_IOVEC]; /* segments of this pkt */
> > +       union {
> > +               struct gve_tx_iovec iov[GVE_TX_MAX_IOVEC]; /* segments of this pkt */
> > +               struct gve_tx_dma_buf buf;
> > +       };
> >  };
> >
> >  /* A TX buffer - each queue has one */
> > @@ -140,19 +148,23 @@ struct gve_tx_ring {
> >         __be32 last_nic_done ____cacheline_aligned; /* NIC tail pointer */
> >         u64 pkt_done; /* free-running - total packets completed */
> >         u64 bytes_done; /* free-running - total bytes completed */
> > +       u32 dropped_pkt; /* free-running - total packets dropped */
>
> Generally I would probably use a u64 for any count values. I'm not
> sure what rate you will be moving packets at but if something goes
> wrong you are better off with the counter not rolling over every few
> minutes.

Ok, using a u64 here would be better - I'll do that, thanks.

>
> >         /* Cacheline 2 -- Read-mostly fields */
> >         union gve_tx_desc *desc ____cacheline_aligned;
> >         struct gve_tx_buffer_state *info; /* Maps 1:1 to a desc */
> >         struct netdev_queue *netdev_txq;
> >         struct gve_queue_resources *q_resources; /* head and tail pointer idx */
> > +       struct device *dev;
> >         u32 mask; /* masks req and done down to queue size */
> > +       u8 raw_addressing; /* use raw_addressing? */
> >
> >         /* Slow-path fields */
> >         u32 q_num ____cacheline_aligned; /* queue idx */
> >         u32 stop_queue; /* count of queue stops */
> >         u32 wake_queue; /* count of queue wakes */
> >         u32 ntfy_id; /* notification block index */
> > +       u32 dma_mapping_error; /* count of dma mapping errors */
>
> Since this is a counter wouldn't it make more sense to place it up
> with the other counters?
>
> Looking over the rest of the patch it seems fine to me. The counters
> were the only thing that had me a bit concerned.

Ok, I'll use a u64 here and place it with the counter above.
