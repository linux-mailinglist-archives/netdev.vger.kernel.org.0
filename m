Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E6F61266B4
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 17:21:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726907AbfLSQVh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 11:21:37 -0500
Received: from mail-oi1-f193.google.com ([209.85.167.193]:42467 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726778AbfLSQVh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Dec 2019 11:21:37 -0500
Received: by mail-oi1-f193.google.com with SMTP id 18so2415858oin.9;
        Thu, 19 Dec 2019 08:21:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BXuj5nGL4W4cfkGd6XoswVWbi3yfwQkBdh+9AlpBizs=;
        b=k60/wwzLp6jOBTw6mekzyP62xkBrG/t/4xKP6LAR31XKI2CWCYkcXwBLuYmxjF+rTz
         Rs2I0sMatJ+/qXXZQa1An0R+akBEwmgGJmmePS5vQrAJakOFfDx4wZ5NyGV4RPrbL67j
         BJra9EidzLyESe/4zDC/OWsswSQrceRh+/6fO+7pi+2nEZIuMYxedQWZSkEj47+b++yF
         YkDJ/fATmdQWPAC0kDA0BFjS+hyN9tQL5pEv/Z6R55UNGsEi5o2xRQKMKeOzrs6oVny+
         IPqGcprixajHDEprZWQ3ygos+hr2IHB6f8jM1SrZoPg+KQKj1X+/r6e5Vu4gwoYLqHux
         15vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BXuj5nGL4W4cfkGd6XoswVWbi3yfwQkBdh+9AlpBizs=;
        b=IX7a3aaSsgmIeGM1vWF2zI28OApU2o9p/4AL2HNekibcyVXjFeAcfHfilxCHOQFFf7
         x3YEinX63m2iVV6k6Ix40S6PPRT+oXq/hBTCmXb8fjpe8uhlXGVvST4YvHqGgXX7HOT2
         La6dcYII5OwOCM1qGfCMPo8Efl1dtHJXUmKZatyuCjdcqVKCqVSTf9BKhSXy71wY2ijP
         WH4DSY7RRVRu/XuIWZeK6ECXv1eldnZsIjwbxB/nDR/lMPtVvii5qJVq09dztBqNtV4y
         KVnC459GmDE0Zdk9UCRlGp7oXsqiyst4VcmwoLd0YVQ/m//B9kQcNDkMIlrAAiYi//bE
         ix/g==
X-Gm-Message-State: APjAAAVvExx0rW+wPlF+vSfNi25gHZi8JLUX/rsVydMKYmFIwFj2VqM0
        KsKJdi95ZcsTr6f6h3qFtG84s/OvXc7ucxFzelK4cZ91j9M=
X-Google-Smtp-Source: APXvYqyz5TThLMYgpAd+yUaWeW1PHwcpQge32ETVDRinik+Krz08JRt2HwTjWoXje6PLUCkH5g6YHymux80mS1VxXpc=
X-Received: by 2002:aca:2207:: with SMTP id b7mr2693450oic.109.1576772496015;
 Thu, 19 Dec 2019 08:21:36 -0800 (PST)
MIME-Version: 1.0
References: <1575878189-31860-1-git-send-email-magnus.karlsson@intel.com>
 <1575878189-31860-3-git-send-email-magnus.karlsson@intel.com>
 <63329cd7-4d3a-9497-e5ed-6995f05cd81f@mellanox.com> <CAJ8uoz1k6PwnfVgaa47Yt3K40NciHLf=_5ixsGs0MESrnoo0RA@mail.gmail.com>
 <CAKErNvoK5eVD974=+bs=k+OMeyG=TeRU0TeWPGDwe7dNQN3i5g@mail.gmail.com>
In-Reply-To: <CAKErNvoK5eVD974=+bs=k+OMeyG=TeRU0TeWPGDwe7dNQN3i5g@mail.gmail.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Thu, 19 Dec 2019 17:21:24 +0100
Message-ID: <CAJ8uoz3LDyzTrEovB0q_Pv60ZVNA25Ru5VCCiAb=uzEsGeZjjg@mail.gmail.com>
Subject: Re: [PATCH bpf-next 02/12] xsk: consolidate to one single cached
 producer pointer
To:     Maxim Mikityanskiy <maxtram95@gmail.com>
Cc:     Maxim Mikityanskiy <maximmi@mellanox.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        "bjorn.topel@intel.com" <bjorn.topel@intel.com>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "jonathan.lemon@gmail.com" <jonathan.lemon@gmail.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "jeffrey.t.kirsher@intel.com" <jeffrey.t.kirsher@intel.com>,
        "maciej.fijalkowski@intel.com" <maciej.fijalkowski@intel.com>,
        "maciejromanfijalkowski@gmail.com" <maciejromanfijalkowski@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 19, 2019 at 3:35 PM Maxim Mikityanskiy <maxtram95@gmail.com> wrote:
>
> On Mon, Dec 16, 2019 at 10:46 AM Magnus Karlsson
> <magnus.karlsson@gmail.com> wrote:
> >
> > On Fri, Dec 13, 2019 at 7:04 PM Maxim Mikityanskiy <maximmi@mellanox.com> wrote:
> > >
> > > On 2019-12-09 09:56, Magnus Karlsson wrote:
> > > > Currently, the xsk ring code has two cached producer pointers:
> > > > prod_head and prod_tail. This patch consolidates these two into a
> > > > single one called cached_prod to make the code simpler and easier to
> > > > maintain. This will be in line with the user space part of the the
> > > > code found in libbpf, that only uses a single cached pointer.
> > > >
> > > > The Rx path only uses the two top level functions
> > > > xskq_produce_batch_desc and xskq_produce_flush_desc and they both use
> > > > prod_head and never prod_tail. So just move them over to
> > > > cached_prod.
> > > >
> > > > The Tx XDP_DRV path uses xskq_produce_addr_lazy and
> > > > xskq_produce_flush_addr_n and unnecessarily operates on both prod_tail
> > > > and prod_cons, so move them over to just use cached_prod by skipping
> > > > the intermediate step of updating prod_tail.
> > > >
> > > > The Tx path in XDP_SKB mode uses xskq_reserve_addr and
> > > > xskq_produce_addr. They currently use both cached pointers, but we can
> > > > operate on the global producer pointer in xskq_produce_addr since it
> > > > has to be updated anyway, thus eliminating the use of both cached
> > > > pointers. We can also remove the xskq_nb_free in xskq_produce_addr
> > > > since it is already called in xskq_reserve_addr. No need to do it
> > > > twice.
> > > >
> > > > When there is only one cached producer pointer, we can also simplify
> > > > xskq_nb_free by removing one argument.
> > > >
> > > > Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
> > > > ---
> > > >   net/xdp/xsk_queue.h | 49 ++++++++++++++++++++++---------------------------
> > > >   1 file changed, 22 insertions(+), 27 deletions(-)
> > > >
> > > > diff --git a/net/xdp/xsk_queue.h b/net/xdp/xsk_queue.h
> > > > index a2f0ba6..d88e1a0 100644
> > > > --- a/net/xdp/xsk_queue.h
> > > > +++ b/net/xdp/xsk_queue.h
> > > > @@ -35,8 +35,7 @@ struct xsk_queue {
> > > >       u64 size;
> > > >       u32 ring_mask;
> > > >       u32 nentries;
> > > > -     u32 prod_head;
> > > > -     u32 prod_tail;
> > > > +     u32 cached_prod;
> > > >       u32 cons_head;
> > > >       u32 cons_tail;
> > > >       struct xdp_ring *ring;
> > > > @@ -94,39 +93,39 @@ static inline u64 xskq_nb_invalid_descs(struct xsk_queue *q)
> > > >
> > > >   static inline u32 xskq_nb_avail(struct xsk_queue *q, u32 dcnt)
> > > >   {
> > > > -     u32 entries = q->prod_tail - q->cons_tail;
> > > > +     u32 entries = q->cached_prod - q->cons_tail;
> > > >
> > > >       if (entries == 0) {
> > > >               /* Refresh the local pointer */
> > > > -             q->prod_tail = READ_ONCE(q->ring->producer);
> > > > -             entries = q->prod_tail - q->cons_tail;
> > > > +             q->cached_prod = READ_ONCE(q->ring->producer);
> > > > +             entries = q->cached_prod - q->cons_tail;
> > > >       }
> > > >
> > > >       return (entries > dcnt) ? dcnt : entries;
> > > >   }
> > > >
> > > > -static inline u32 xskq_nb_free(struct xsk_queue *q, u32 producer, u32 dcnt)
> > > > +static inline u32 xskq_nb_free(struct xsk_queue *q, u32 dcnt)
> > > >   {
> > > > -     u32 free_entries = q->nentries - (producer - q->cons_tail);
> > > > +     u32 free_entries = q->nentries - (q->cached_prod - q->cons_tail);
> > > >
> > > >       if (free_entries >= dcnt)
> > > >               return free_entries;
> > > >
> > > >       /* Refresh the local tail pointer */
> > > >       q->cons_tail = READ_ONCE(q->ring->consumer);
> > > > -     return q->nentries - (producer - q->cons_tail);
> > > > +     return q->nentries - (q->cached_prod - q->cons_tail);
> > > >   }
> > > >
> > > >   static inline bool xskq_has_addrs(struct xsk_queue *q, u32 cnt)
> > > >   {
> > > > -     u32 entries = q->prod_tail - q->cons_tail;
> > > > +     u32 entries = q->cached_prod - q->cons_tail;
> > > >
> > > >       if (entries >= cnt)
> > > >               return true;
> > > >
> > > >       /* Refresh the local pointer. */
> > > > -     q->prod_tail = READ_ONCE(q->ring->producer);
> > > > -     entries = q->prod_tail - q->cons_tail;
> > > > +     q->cached_prod = READ_ONCE(q->ring->producer);
> > > > +     entries = q->cached_prod - q->cons_tail;
> > > >
> > > >       return entries >= cnt;
> > > >   }
> > > > @@ -220,17 +219,15 @@ static inline void xskq_discard_addr(struct xsk_queue *q)
> > > >   static inline int xskq_produce_addr(struct xsk_queue *q, u64 addr)
> > > >   {
> > > >       struct xdp_umem_ring *ring = (struct xdp_umem_ring *)q->ring;
> > > > -
> > > > -     if (xskq_nb_free(q, q->prod_tail, 1) == 0)
> > > > -             return -ENOSPC;
> > > > +     unsigned int idx = q->ring->producer;
> > > >
> > > >       /* A, matches D */
> > > > -     ring->desc[q->prod_tail++ & q->ring_mask] = addr;
> > > > +     ring->desc[idx++ & q->ring_mask] = addr;
> > > >
> > > >       /* Order producer and data */
> > > >       smp_wmb(); /* B, matches C */
> > > >
> > > > -     WRITE_ONCE(q->ring->producer, q->prod_tail);
> > > > +     WRITE_ONCE(q->ring->producer, idx);
> > > >       return 0;
> > > >   }
> > > >
> > > > @@ -238,11 +235,11 @@ static inline int xskq_produce_addr_lazy(struct xsk_queue *q, u64 addr)
> > > >   {
> > > >       struct xdp_umem_ring *ring = (struct xdp_umem_ring *)q->ring;
> > > >
> > > > -     if (xskq_nb_free(q, q->prod_head, 1) == 0)
> > > > +     if (xskq_nb_free(q, 1) == 0)
> > > >               return -ENOSPC;
> > > >
> > > >       /* A, matches D */
> > > > -     ring->desc[q->prod_head++ & q->ring_mask] = addr;
> > > > +     ring->desc[q->cached_prod++ & q->ring_mask] = addr;
> > > >       return 0;
> > > >   }
> > > >
> > > > @@ -252,17 +249,16 @@ static inline void xskq_produce_flush_addr_n(struct xsk_queue *q,
> > > >       /* Order producer and data */
> > > >       smp_wmb(); /* B, matches C */
> > > >
> > > > -     q->prod_tail += nb_entries;
> > > > -     WRITE_ONCE(q->ring->producer, q->prod_tail);
> > > > +     WRITE_ONCE(q->ring->producer, q->ring->producer + nb_entries);
> > > >   }
> > > >
> > > >   static inline int xskq_reserve_addr(struct xsk_queue *q)
> > > >   {
> > > > -     if (xskq_nb_free(q, q->prod_head, 1) == 0)
> > > > +     if (xskq_nb_free(q, 1) == 0)
> > > >               return -ENOSPC;
> > > >
> > > >       /* A, matches D */
> > > > -     q->prod_head++;
> > > > +     q->cached_prod++;
> > > >       return 0;
> > > >   }
> > > >
> > > > @@ -340,11 +336,11 @@ static inline int xskq_produce_batch_desc(struct xsk_queue *q,
> > > >       struct xdp_rxtx_ring *ring = (struct xdp_rxtx_ring *)q->ring;
> > > >       unsigned int idx;
> > > >
> > > > -     if (xskq_nb_free(q, q->prod_head, 1) == 0)
> > > > +     if (xskq_nb_free(q, 1) == 0)
> > > >               return -ENOSPC;
> > > >
> > > >       /* A, matches D */
> > > > -     idx = (q->prod_head++) & q->ring_mask;
> > > > +     idx = q->cached_prod++ & q->ring_mask;
> > > >       ring->desc[idx].addr = addr;
> > > >       ring->desc[idx].len = len;
> > > >
> > > > @@ -356,8 +352,7 @@ static inline void xskq_produce_flush_desc(struct xsk_queue *q)
> > > >       /* Order producer and data */
> > > >       smp_wmb(); /* B, matches C */
> > > >
> > > > -     q->prod_tail = q->prod_head;
> > > > -     WRITE_ONCE(q->ring->producer, q->prod_tail);
> > > > +     WRITE_ONCE(q->ring->producer, q->cached_prod);
> > > >   }
> > > >
> > > >   static inline bool xskq_full_desc(struct xsk_queue *q)
> > > > @@ -367,7 +362,7 @@ static inline bool xskq_full_desc(struct xsk_queue *q)
> > > >
> > > >   static inline bool xskq_empty_desc(struct xsk_queue *q)
> > > >   {
> > > > -     return xskq_nb_free(q, q->prod_tail, q->nentries) == q->nentries;
> > > > +     return xskq_nb_free(q, q->nentries) == q->nentries;
> > >
> > > I don't think this change is correct. The old code checked the number of
> > > free items against prod_tail (== producer). The new code changes it to
> > > prod_head (which is now cached_prod). xskq_nb_free is used in xsk_poll
> > > to set EPOLLIN. After this change EPOLLIN will be set right after
> > > xskq_produce_batch_desc, but it should only be set after
> > > xskq_produce_flush_desc, just as before, otherwise the application will
> > > wake up before the data is available, and it will just waste CPU cycles.
> >
> > That is correct. It will be inefficient during patch 2 and 3 as this
> > gets fixed in patch 4.
>
> Looking at patch 4, I see it still uses cached_prod, not producer.
> However, I see you changed it in the v2, so it should be fine now.
>
> > I chose this as I thought the patch progression
> > and simplification process would be clearer this way. So what to do
> > about it? Some options:
> >
> > * Document this in patch 2 and keep the current order
> >
> > *  Put patch 4 before patch 2 so that the code is always efficient.
> > This is doable, but I have the feeling it will be somewhat less clear
> > from a simplification perspective. The advantage, on the other hand,
> > is that the poll code is always efficient during the whole patch set.
>
> I'm sorry that it takes long for me to answer, I'm on vacation now.
> Anyway, either option looks good to me, as long as xskq_prod_is_empty
> has the correct check (as in v2 patch 2).

Thanks for taking a look at the patch during your vacation Maxim. But
now, please go and enjoy the holidays :-)!

/Magnus

> > /Magnus
> >
> > > >   }
> > > >
> > > >   void xskq_set_umem(struct xsk_queue *q, u64 size, u64 chunk_mask);
> > > >
> > >
