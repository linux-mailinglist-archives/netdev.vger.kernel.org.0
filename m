Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D77C92B9808
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 17:35:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728155AbgKSQdZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 11:33:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728026AbgKSQdZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 11:33:25 -0500
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A80FC0613CF
        for <netdev@vger.kernel.org>; Thu, 19 Nov 2020 08:33:25 -0800 (PST)
Received: by mail-il1-x143.google.com with SMTP id x18so5918105ilq.4
        for <netdev@vger.kernel.org>; Thu, 19 Nov 2020 08:33:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qErTPuUI4MGWEoFE9wv2I0ymBYHITngZsFbhr2s4p/0=;
        b=OkQC5/PjfBuqb4/lRgBAoYUTIsEfxc9gxJh0bwxw7ZMwzTAdok2XXjb4Epg644qVir
         IGiDUTszeu8FXufEhQ0H2ANz/opWzz+37+a6mEdg/R4B4QXQCXQvVduJMjH7Yw4qFEHZ
         fRVafJLshEnCVqqvhto5gXTj1kbDRfYdS8p1A72LcrAGsD/r6rkRBLKvG1gYIHNEnfao
         qfQJEg05Jm/bHWHy1DL1KrSoHdGSKxM4rciys0xkMQHt3vz/U2hTpdoH7I48YCH4WD4+
         fx8rSU4E0RgfODrkx0ouBrNuLHcsX9kCNJgeXS9hDQudZ/Yf4ZKzpN9QNQJWWDkAixOs
         KwDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qErTPuUI4MGWEoFE9wv2I0ymBYHITngZsFbhr2s4p/0=;
        b=jbwWfIpSIxcEPdtGPhhX83TegF0Jsx7CTFUu1hsxpH71IacWdX9RVZtFO5L0mgGZ80
         zP+0wt8ETPRqXNONt/Jq4ye2hUvRWPwRsiHHCTSGeurj71RCT+kpNS3i1Qkeju9H2ulc
         XYF2ymyadNmUcBZXpSNAwENxCxnlnU+2Ul1FnUWDbfN7v75Nt+CZTxFi3Q/r7Yiwk6DA
         2bVTD23U1g5evSBKy9BJmSXz4xA0zBfktfadP/aZrNnwyurJw2SiLS7Du/nvLsAKpGA8
         +GRxfwBEKs0nRhS+Fyr7Gm8xHtvZg+ayKWKTbUaG55Z+xV7MjiIko15j4/QfBOPQdDT8
         uKaQ==
X-Gm-Message-State: AOAM531TmrFqYEZdzdVdwgBvBq7X3TSTbOI9hAnah/L+PBg9imDgmHuV
        lO2yUFUqX+2qjGXmTrDxMPuBL8g8eqGACltkKL0=
X-Google-Smtp-Source: ABdhPJybtbXvGn3W5qsdqPTln573ovIdlbn5RlJTWQUkpmAehjauvLzix49c/eHemOGFZUMpIIMwyD2IkndgGampNn0=
X-Received: by 2002:a92:730d:: with SMTP id o13mr13719823ilc.95.1605803604467;
 Thu, 19 Nov 2020 08:33:24 -0800 (PST)
MIME-Version: 1.0
References: <20201109233659.1953461-1-awogbemila@google.com>
 <20201109233659.1953461-5-awogbemila@google.com> <CAKgT0UfMmEjC3Y7W1RUpgf1ex7w2GzSSVrcUBtBMG8TOta8dEw@mail.gmail.com>
 <CAL9ddJcau-wWVpdA=K3iLzBKoLg86vRzi8HgwB-xJh8rkovs+g@mail.gmail.com>
In-Reply-To: <CAL9ddJcau-wWVpdA=K3iLzBKoLg86vRzi8HgwB-xJh8rkovs+g@mail.gmail.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Thu, 19 Nov 2020 08:33:13 -0800
Message-ID: <CAKgT0Ufex3HveUvkWofwtA2Y3L1C12n1oNVPY14Mcp+3kRsOGA@mail.gmail.com>
Subject: Re: [PATCH net-next v6 4/4] gve: Add support for raw addressing in
 the tx path
To:     David Awogbemila <awogbemila@google.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        Catherine Sullivan <csully@google.com>,
        Yangchun Fu <yangchun@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 18, 2020 at 3:16 PM David Awogbemila <awogbemila@google.com> wrote:
>
> On Wed, Nov 11, 2020 at 9:29 AM Alexander Duyck
> <alexander.duyck@gmail.com> wrote:
> >
> > On Mon, Nov 9, 2020 at 3:39 PM David Awogbemila <awogbemila@google.com> wrote:
> > >
> > > From: Catherine Sullivan <csully@google.com>
> > >
> > > During TX, skbs' data addresses are dma_map'ed and passed to the NIC.
> > > This means that the device can perform DMA directly from these addresses
> > > and the driver does not have to copy the buffer content into
> > > pre-allocated buffers/qpls (as in qpl mode).
> > >
> > > Reviewed-by: Yangchun Fu <yangchun@google.com>
> > > Signed-off-by: Catherine Sullivan <csully@google.com>
> > > Signed-off-by: David Awogbemila <awogbemila@google.com>

<snip>

> > > @@ -472,6 +499,100 @@ static int gve_tx_add_skb(struct gve_tx_ring *tx, struct sk_buff *skb,
> > >         return 1 + payload_nfrags;
> > >  }
> > >
> > > +static int gve_tx_add_skb_no_copy(struct gve_priv *priv, struct gve_tx_ring *tx,
> > > +                                 struct sk_buff *skb)
> > > +{
> > > +       const struct skb_shared_info *shinfo = skb_shinfo(skb);
> > > +       int hlen, payload_nfrags, l4_hdr_offset, seg_idx_bias;
> > > +       union gve_tx_desc *pkt_desc, *seg_desc;
> > > +       struct gve_tx_buffer_state *info;
> > > +       bool is_gso = skb_is_gso(skb);
> > > +       u32 idx = tx->req & tx->mask;
> > > +       struct gve_tx_dma_buf *buf;
> > > +       int last_mapped = 0;
> > > +       u64 addr;
> > > +       u32 len;
> > > +       int i;
> > > +
> > > +       info = &tx->info[idx];
> > > +       pkt_desc = &tx->desc[idx];
> > > +
> > > +       l4_hdr_offset = skb_checksum_start_offset(skb);
> > > +       /* If the skb is gso, then we want only up to the tcp header in the first segment
> > > +        * to efficiently replicate on each segment otherwise we want the linear portion
> > > +        * of the skb (which will contain the checksum because skb->csum_start and
> > > +        * skb->csum_offset are given relative to skb->head) in the first segment.
> > > +        */
> > > +       hlen = is_gso ? l4_hdr_offset + tcp_hdrlen(skb) :
> > > +                       skb_headlen(skb);
> > > +       len = skb_headlen(skb);
> > > +
> > > +       info->skb =  skb;
> > > +
> > > +       addr = dma_map_single(tx->dev, skb->data, len, DMA_TO_DEVICE);
> > > +       if (unlikely(dma_mapping_error(tx->dev, addr))) {
> > > +               rtnl_lock();
> > > +               priv->dma_mapping_error++;
> > > +               rtnl_unlock();
> >
> > Do you really need an rtnl_lock for updating this statistic? That
> > seems like a glaring issue to me.
>
> I thought this would be the way to protect the stat from parallel
> access as was suggested in a comment in v3 of the patchset but I
> understand now that rtnl_lock/unlock ought only to be used for net
> device configurations and not in the data path. Also I now believe
> that since this driver is very rarely not running on a 64-bit
> platform, the stat update is atomic anyway and shouldn't need the locks.

If nothing else it might be good to look at just creating a per-ring
stat for this and then aggregating the value before you report it to
the stack. Then you don't have to worry about multiple threads trying
to update it simultaneously since it will be protected by the Tx queue
lock.
