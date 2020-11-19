Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA87F2B9CBB
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 22:11:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726293AbgKSVLb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 16:11:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726189AbgKSVLb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 16:11:31 -0500
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96382C0613CF
        for <netdev@vger.kernel.org>; Thu, 19 Nov 2020 13:11:30 -0800 (PST)
Received: by mail-ed1-x543.google.com with SMTP id e18so7348737edy.6
        for <netdev@vger.kernel.org>; Thu, 19 Nov 2020 13:11:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=G+1kXaMdyjZEBVUqAuCgu7pnG7abXrJlw+l39coJpZc=;
        b=hABRFEUoHskxVzX5D3zIsc95JBxRY5XQiEpLI3Sf0WgGzrbfL7eDLQh5mAGWxtSjT2
         okHU6NmCCUA/mOY6MHXBFLKBfsfisEpVeq39J54v/b4+ga23OcZTWXP4hurYbji5qthx
         rtc16RbmR/ARqqUJjKDdQmg+6T3GQnvsLG80R+iHV9aIlBWDECvQwDbxiT0WQndPDVHB
         Kpy47HhDO2I/VYmG6QCwRggHLAUUVFs6JAQIniOT2wk3NSjtHjhnZsSCBHFEhXqZr5Ve
         WGkhsxvdOzmglBOAHDhFiVaZXjgtPLIa8UUqpSTJxFzLVVt/A9AJmeFeV/8C7rFBbiMM
         BK0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=G+1kXaMdyjZEBVUqAuCgu7pnG7abXrJlw+l39coJpZc=;
        b=aFBL0TIAXwFEXPmbYuGzCIn1/CkUrCKinlk2hIoMMNMHX/8cwzTrPtjEfFRyrnkoh5
         gzBnNx/TmCOyFKRDrNL+gA/OM9CniMrrItp4DmebKZ//YM9ZPVSmIfGrRoxzGh28H/y6
         S6H6ywyB0gx1VLnzUXrTZ/hu/6Xt9qPWiMfyvxb4gNFfZEazrDvPL0ROze8CzA5kCB5X
         Gotwiaf62jITZEVZIeetbg8ceHpK2FcPTxA4nrUZxR9snQyxIz8cgGcXujbBEt4JZ6nZ
         9+xvmDXsFwe32TOlqsdkMvWPvRhigsSqgjilWlUptDqAtnbJMbn7TZquRJv0ku24g4iB
         ZxCw==
X-Gm-Message-State: AOAM53228asKhDfD5FqoHhb/NLmg8eVVQ9/nsITEFK4fXdFFijOaVrL7
        fEImBEZkHWLGSoEhLvvCnmlqm+mp3d3m/8/TEvJN7w==
X-Google-Smtp-Source: ABdhPJyGKKvw+JuH52XJpNj6d49WC6zv594VPlaqMG1IVSRJQgU2jYAwemd3/2G9kF5zARuykJ3HmzuEw7dKeW+gij0=
X-Received: by 2002:a50:b761:: with SMTP id g88mr32699906ede.387.1605820289047;
 Thu, 19 Nov 2020 13:11:29 -0800 (PST)
MIME-Version: 1.0
References: <20201109233659.1953461-1-awogbemila@google.com>
 <20201109233659.1953461-5-awogbemila@google.com> <CAKgT0UfMmEjC3Y7W1RUpgf1ex7w2GzSSVrcUBtBMG8TOta8dEw@mail.gmail.com>
 <CAL9ddJcau-wWVpdA=K3iLzBKoLg86vRzi8HgwB-xJh8rkovs+g@mail.gmail.com> <CAKgT0Ufex3HveUvkWofwtA2Y3L1C12n1oNVPY14Mcp+3kRsOGA@mail.gmail.com>
In-Reply-To: <CAKgT0Ufex3HveUvkWofwtA2Y3L1C12n1oNVPY14Mcp+3kRsOGA@mail.gmail.com>
From:   David Awogbemila <awogbemila@google.com>
Date:   Thu, 19 Nov 2020 13:11:18 -0800
Message-ID: <CAL9ddJfAj82C_0BiLX-jaE4WzQGfJSpYj48DefPwmWNkARkzRQ@mail.gmail.com>
Subject: Re: [PATCH net-next v6 4/4] gve: Add support for raw addressing in
 the tx path
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        Catherine Sullivan <csully@google.com>,
        Yangchun Fu <yangchun@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 19, 2020 at 8:33 AM Alexander Duyck
<alexander.duyck@gmail.com> wrote:
>
> On Wed, Nov 18, 2020 at 3:16 PM David Awogbemila <awogbemila@google.com> wrote:
> >
> > On Wed, Nov 11, 2020 at 9:29 AM Alexander Duyck
> > <alexander.duyck@gmail.com> wrote:
> > >
> > > On Mon, Nov 9, 2020 at 3:39 PM David Awogbemila <awogbemila@google.com> wrote:
> > > >
> > > > From: Catherine Sullivan <csully@google.com>
> > > >
> > > > During TX, skbs' data addresses are dma_map'ed and passed to the NIC.
> > > > This means that the device can perform DMA directly from these addresses
> > > > and the driver does not have to copy the buffer content into
> > > > pre-allocated buffers/qpls (as in qpl mode).
> > > >
> > > > Reviewed-by: Yangchun Fu <yangchun@google.com>
> > > > Signed-off-by: Catherine Sullivan <csully@google.com>
> > > > Signed-off-by: David Awogbemila <awogbemila@google.com>
>
> <snip>
>
> > > > @@ -472,6 +499,100 @@ static int gve_tx_add_skb(struct gve_tx_ring *tx, struct sk_buff *skb,
> > > >         return 1 + payload_nfrags;
> > > >  }
> > > >
> > > > +static int gve_tx_add_skb_no_copy(struct gve_priv *priv, struct gve_tx_ring *tx,
> > > > +                                 struct sk_buff *skb)
> > > > +{
> > > > +       const struct skb_shared_info *shinfo = skb_shinfo(skb);
> > > > +       int hlen, payload_nfrags, l4_hdr_offset, seg_idx_bias;
> > > > +       union gve_tx_desc *pkt_desc, *seg_desc;
> > > > +       struct gve_tx_buffer_state *info;
> > > > +       bool is_gso = skb_is_gso(skb);
> > > > +       u32 idx = tx->req & tx->mask;
> > > > +       struct gve_tx_dma_buf *buf;
> > > > +       int last_mapped = 0;
> > > > +       u64 addr;
> > > > +       u32 len;
> > > > +       int i;
> > > > +
> > > > +       info = &tx->info[idx];
> > > > +       pkt_desc = &tx->desc[idx];
> > > > +
> > > > +       l4_hdr_offset = skb_checksum_start_offset(skb);
> > > > +       /* If the skb is gso, then we want only up to the tcp header in the first segment
> > > > +        * to efficiently replicate on each segment otherwise we want the linear portion
> > > > +        * of the skb (which will contain the checksum because skb->csum_start and
> > > > +        * skb->csum_offset are given relative to skb->head) in the first segment.
> > > > +        */
> > > > +       hlen = is_gso ? l4_hdr_offset + tcp_hdrlen(skb) :
> > > > +                       skb_headlen(skb);
> > > > +       len = skb_headlen(skb);
> > > > +
> > > > +       info->skb =  skb;
> > > > +
> > > > +       addr = dma_map_single(tx->dev, skb->data, len, DMA_TO_DEVICE);
> > > > +       if (unlikely(dma_mapping_error(tx->dev, addr))) {
> > > > +               rtnl_lock();
> > > > +               priv->dma_mapping_error++;
> > > > +               rtnl_unlock();
> > >
> > > Do you really need an rtnl_lock for updating this statistic? That
> > > seems like a glaring issue to me.
> >
> > I thought this would be the way to protect the stat from parallel
> > access as was suggested in a comment in v3 of the patchset but I
> > understand now that rtnl_lock/unlock ought only to be used for net
> > device configurations and not in the data path. Also I now believe
> > that since this driver is very rarely not running on a 64-bit
> > platform, the stat update is atomic anyway and shouldn't need the locks.
>
> If nothing else it might be good to look at just creating a per-ring
> stat for this and then aggregating the value before you report it to
> the stack. Then you don't have to worry about multiple threads trying
> to update it simultaneously since it will be protected by the Tx queue
> lock.

Ok, a per-ring stat would work so I'll switch to that.
I've actually sent v7 already, so I'll make the modifications in  v8.
