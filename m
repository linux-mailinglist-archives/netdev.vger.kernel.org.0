Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4F84694AB7
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 16:15:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231539AbjBMPPA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 10:15:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231571AbjBMPO4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 10:14:56 -0500
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A93C21E29A
        for <netdev@vger.kernel.org>; Mon, 13 Feb 2023 07:14:47 -0800 (PST)
Received: by mail-pg1-x531.google.com with SMTP id r18so8299115pgr.12
        for <netdev@vger.kernel.org>; Mon, 13 Feb 2023 07:14:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=inSrx3Fa2rvANaP4TAPTvR1GiPfuxEWbt/1rRaqTFLk=;
        b=o7c4r/cr85H7DYl763P4WYusIrCyEwLlkKAq4k5VYWp+w9tq/IdLvLP/oz1gfsjkO4
         KC2uHAl2ppCwdm4O7TuPjbRUb/Cpn0x9k3aBl6s14Ox7PXDf0uOSxA94clpUtx4kJmpj
         aVb5TViCe9vpKnY5rejFlviqllOTcN4Jdf1xbaMxngXOXrdnqEfEw2jMSAQw7ZNslypF
         4bjpPhsEeR5ESTk7pgpCi0+s87EmcOR9nLGf0bkaEFRbmV8eZBQgalQbcB03yd6FhDRd
         K/3DZqu+tZ929kaE009qc1p1ffYeQnGVzNCbeO146uFvOzzGjct7Ncq5GGvR0DZg3+Vf
         9AYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=inSrx3Fa2rvANaP4TAPTvR1GiPfuxEWbt/1rRaqTFLk=;
        b=R8UZb5CeM90U+4oQvXcCfbUUPe1Uqcxt1ZWZ9iLOjfGsarRLa+Uvd+XJr3MfpRTOIG
         AlwxbQzemBgxd4ileoo5TLXS/v+1JLI1EsQ+3uWoA+KK4GPfodppoOqg+YA+OGbYluAY
         9R4Ne0s74FBULZs07rv9tMI08DpdSkSRtxUTnMfiwzzCPyqLLSEYWaF6YZYWTm/CM+Br
         WEsBwVoxooWRuz8/+5q/9NPbTl1VMgoI+sFrHKvxmxR5ClNZuiCZBEv5P1XTJ25ZhjGw
         QYZ4qqBSmPH4JZaqUgAT+8krr4iIgGnNgZVRTNqhY6DQUySURpjECad+ZFqMGg60OmUj
         J/rw==
X-Gm-Message-State: AO0yUKUBIMhVv9KFOrfz3G3vrE6xcfNnC6DK9BRUOE23eaB1Z1oDOscy
        yBBcUoWrGei2fI2IfM1VA3II/xU0TVoK0mC2JF8=
X-Google-Smtp-Source: AK7set9JSt+ye4kT+F2I6LMRw+pEq7gDkiB4aJ1XIvVkbZgSW4tyJbydTKiC2UPt9Bs+toPuYDrXtifcRTD868mKJfw=
X-Received: by 2002:a63:6d4d:0:b0:4fb:aa57:d3ca with SMTP id
 i74-20020a636d4d000000b004fbaa57d3camr686168pgc.112.1676301286877; Mon, 13
 Feb 2023 07:14:46 -0800 (PST)
MIME-Version: 1.0
References: <cover.1675632296.git.geoff@infradead.org> <4150b1589ed367e18855c16762ff160e9d73a42f.1675632296.git.geoff@infradead.org>
 <9ddd548874378f29ce7729823a1590dac0c6eca2.camel@gmail.com> <29b83fc2-af28-e19d-b837-80778e429417@infradead.org>
In-Reply-To: <29b83fc2-af28-e19d-b837-80778e429417@infradead.org>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Mon, 13 Feb 2023 07:14:34 -0800
Message-ID: <CAKgT0UdY=7w1Pkt99mzuwc+uFmWe5qOVJWJmMRyhDW-o7Fao9A@mail.gmail.com>
Subject: Re: [PATCH net v4 1/2] net/ps3_gelic_net: Fix RX sk_buff length
To:     Geoff Levand <geoff@infradead.org>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 12, 2023 at 9:06 AM Geoff Levand <geoff@infradead.org> wrote:
>
> Hi Alexander,
>
> Thanks for the review.
>
> On 2/6/23 08:25, Alexander H Duyck wrote:
> > On Sun, 2023-02-05 at 22:10 +0000, Geoff Levand wrote:
> >> The Gelic Ethernet device needs to have the RX sk_buffs aligned to
> >> GELIC_NET_RXBUF_ALIGN and the length of the RX sk_buffs must be a multiple of
> >> GELIC_NET_RXBUF_ALIGN.
> >>
>
> >>  static int gelic_descr_prepare_rx(struct gelic_card *card,
> >>                                struct gelic_descr *descr)
> >>  {
> >> -    int offset;
> >> -    unsigned int bufsize;
> >> +    struct device *dev = ctodev(card);
> >> +    struct {
> >> +            unsigned int total_bytes;
> >> +            unsigned int offset;
> >> +    } aligned_buf;
> >> +    dma_addr_t cpu_addr;
> >>
> >>      if (gelic_descr_get_status(descr) !=  GELIC_DESCR_DMA_NOT_IN_USE)
> >>              dev_info(ctodev(card), "%s: ERROR status\n", __func__);
> >> -    /* we need to round up the buffer size to a multiple of 128 */
> >> -    bufsize = ALIGN(GELIC_NET_MAX_MTU, GELIC_NET_RXBUF_ALIGN);
> >>
> >> -    /* and we need to have it 128 byte aligned, therefore we allocate a
> >> -     * bit more */
> >> -    descr->skb = dev_alloc_skb(bufsize + GELIC_NET_RXBUF_ALIGN - 1);
> >> +    aligned_buf.total_bytes = (GELIC_NET_RXBUF_ALIGN - 1) +
> >> +            GELIC_NET_MAX_MTU + (GELIC_NET_RXBUF_ALIGN - 1);
> >> +
> >
> > This value isn't aligned to anything as there have been no steps taken
> > to align it. In fact it is guaranteed to be off by 2. Did you maybe
> > mean to use an "&" somewhere?
>
> total_bytes here means the total number of bytes to allocate that will
> allow for the desired alignment.  This value a bit too much though since
> we really just need it to end on a GELIC_NET_RXBUF_ALIGN boundary, so
> adding ALIGN(GELIC_NET_MAX_MTU, GELIC_NET_RXBUF_ALIGN) should be enough.
> I'll fix that in the next patch version.
>
> >> +    descr->skb = dev_alloc_skb(aligned_buf.total_bytes);
> >> +
> >>      if (!descr->skb) {
> >> -            descr->buf_addr = 0; /* tell DMAC don't touch memory */
> >> +            descr->buf_addr = 0;
> >>              return -ENOMEM;
> >
> > Why remove this comment?
>
> If we return -ENOMEM this descriptor shouldn't be used.

Right. But the comment is essentially saying that. The question is why
remove the documentation?

> >>      }
> >> -    descr->buf_size = cpu_to_be32(bufsize);
> >> +
> >> +    aligned_buf.offset =
> >> +            PTR_ALIGN(descr->skb->data, GELIC_NET_RXBUF_ALIGN) -
> >> +                    descr->skb->data;
> >> +
> >> +    descr->buf_size = ALIGN(GELIC_NET_MAX_MTU, GELIC_NET_RXBUF_ALIGN);
> >
> > Originally this was being written using cpu_to_be32. WIth this you are
> > writing it raw w/ the cpu endianness. Is there a byte ordering issue
> > here?
>
> No. The PS3 has a big endian CPU, so we really don't need any
> of the endian conversions.

This doesn't introduce an ordering error, but it introduces a type
error. The bufsize variable was defined as a CPU ordered variable
whereas buf_size is a __be32. If you enable sparse checking it should
return an error.

I would recommend keeping the cpu_to_be32. If your architecture is big
endian it will do nothing and add no overhead. If at some point in the
future someone were to plug this IP into another architecture it would
take care of sorting out the byte ordering for you.

> >
> >>      descr->dmac_cmd_status = 0;
> >>      descr->result_size = 0;
> >>      descr->valid_size = 0;
> >>      descr->data_error = 0;
> >>
> >> -    offset = ((unsigned long)descr->skb->data) &
> >> -            (GELIC_NET_RXBUF_ALIGN - 1);
> >> -    if (offset)
> >> -            skb_reserve(descr->skb, GELIC_NET_RXBUF_ALIGN - offset);
> >
> > Rather than messing with all this it might be easier to just drop
> > offset in favor of NET_SKB_PAD since that should be offset in all cases
> > where dev_alloc_skb is being used. With that the reserve could just be
> > a constant.
>
> GELIC_NET_RXBUF_ALIGN is a property of the gelic hardware device.  I
> would think if NET_SKB_PAD would work it would just be by coincidence.

NET_SKB_PAD is the alignment generated when you use dev_alloc_skb.
What I was getting at is that "offset" could probably be removed in
favor of just using NET_SKB_PAD.
