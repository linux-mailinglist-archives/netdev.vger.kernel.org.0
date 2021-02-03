Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6B0830D3FC
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 08:23:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231755AbhBCHVX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 02:21:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230193AbhBCHVW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Feb 2021 02:21:22 -0500
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C4C8C061573
        for <netdev@vger.kernel.org>; Tue,  2 Feb 2021 23:20:42 -0800 (PST)
Received: by mail-yb1-xb2c.google.com with SMTP id i71so9511207ybg.7
        for <netdev@vger.kernel.org>; Tue, 02 Feb 2021 23:20:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CXq8LFMeHatCCtcdd1nvuT7xP/wuhjZJ6D1nABjz8w0=;
        b=Tgkt0QeYl0uq+VeGgOYRE3Xd6LpL5VMQCxz59bFEDLnsGPEDhXV7uDC6T4U2As0EtZ
         5V6B+9Xrntil3cFW+a04Pj04rpQ8t8RooHBeUqRS9LmCPcTzb1z9pwvyERsbYXvynwIu
         PLqzOiVqzS0nIRjtmg9mRqHSpB0V9Ks9ePxgnaebdzGBHBzatZxSC8PhPN/JKWEUME5r
         8O1H6vmMwSuHZiW8lcRys7/bSdKlYqZg6WwVoIpLBz/W1HV2ToDb4aTIR8PVa2RAJmrD
         XAX2s3NxWk1ZkojNM/Sy8LDLW/amx0Ew5ycTMRuVm1CVM4Ujanmf0xNFlm2H6VvKO1FH
         bPJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CXq8LFMeHatCCtcdd1nvuT7xP/wuhjZJ6D1nABjz8w0=;
        b=twdvkpeCmBJjn3G0s8LUmFaKtWADKSY1D4sQu/0WnC4AIOGpk2vsFPoBAhEWLCnIgK
         1cfOF0Thnq//k6r14MCKSz4YOUZR0bUy1Mzc41YxJt4BvWw0/IohxOS3CNRB6aB16+cd
         3YeZoSIfQjgRGH6PoAgjijIQMQ/W715IzHiBbbU9UmkO1WelMKhn+UjqEhszp6Lh76p6
         iLFfOp/vStf1dd5Kzmp8yDFSCT8bJfCDicviYqcbEUU2IpvM7OoYj9UJupVd5NviujGa
         2fGknmiqT+bqMI9osZfTY+NqJuShBbbzfTNzv7JQnDIOa7mGr4i6QjtUNrhLqKogb8qc
         Gw8Q==
X-Gm-Message-State: AOAM532Zk7htz+MBmJ3dnB61SsPRLq1rktZ6e4n9t6KwldJPnP5ohs1K
        u0CGMUeIXCLwyVU7V6nNVtMAurgwVeKHvLNqMgPCQg==
X-Google-Smtp-Source: ABdhPJy65JjkxM57UjL3Lj6pjWKGlGkUgTZS6vIXMC5R8KIF/TerERUrRD9AJT4KFA5y2eNK84l3AdTETw4Uo5dXCA8=
X-Received: by 2002:a25:d410:: with SMTP id m16mr2509834ybf.419.1612336841129;
 Tue, 02 Feb 2021 23:20:41 -0800 (PST)
MIME-Version: 1.0
References: <1612282568-14094-1-git-send-email-loic.poulain@linaro.org> <CAF=yD-JWw9TsXrOT_83bDECrX1J9NvkesoG37pXq8zOkQpiUqg@mail.gmail.com>
In-Reply-To: <CAF=yD-JWw9TsXrOT_83bDECrX1J9NvkesoG37pXq8zOkQpiUqg@mail.gmail.com>
From:   Loic Poulain <loic.poulain@linaro.org>
Date:   Wed, 3 Feb 2021 08:27:49 +0100
Message-ID: <CAMZdPi9-_Y5unZ+4n8v_nt0g+RsTH=BxkphDJdCiJMdsMYcEvw@mail.gmail.com>
Subject: Re: [PATCH net-next v2 1/2] net: mhi-net: Add de-aggeration support
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        Sean Tranchetti <stranche@codeaurora.org>,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Willem,

On Tue, 2 Feb 2021 at 23:45, Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
>
> On Tue, Feb 2, 2021 at 11:08 AM Loic Poulain <loic.poulain@linaro.org> wrote:
> >
> > When device side MTU is larger than host side MTU, the packets
> > (typically rmnet packets) are split over multiple MHI transfers.
> > In that case, fragments must be re-aggregated to recover the packet
> > before forwarding to upper layer.
> >
> > A fragmented packet result in -EOVERFLOW MHI transaction status for
> > each of its fragments, except the final one. Such transfer was
> > previoulsy considered as error and fragments were simply dropped.
[...]
> > +static struct sk_buff *mhi_net_skb_agg(struct mhi_net_dev *mhi_netdev,
> > +                                      struct sk_buff *skb)
> > +{
> > +       struct sk_buff *head = mhi_netdev->skbagg_head;
> > +       struct sk_buff *tail = mhi_netdev->skbagg_tail;
> > +
> > +       /* This is non-paged skb chaining using frag_list */
> > +
>
> no need for empty line?
>
> > +       if (!head) {
> > +               mhi_netdev->skbagg_head = skb;
> > +               return skb;
> > +       }
> > +
> > +       if (!skb_shinfo(head)->frag_list)
> > +               skb_shinfo(head)->frag_list = skb;
> > +       else
> > +               tail->next = skb;
> > +
> > +       /* data_len is normally the size of paged data, in our case there is no
>
> data_len is defined as the data excluding the linear len (ref:
> skb_headlen). That is not just paged data, but includes frag_list.

Ok, thanks for clarifying this, I'll remove the comment since it's
then a valid usage.

[...]
> >  static void mhi_net_dl_callback(struct mhi_device *mhi_dev,
> >                                 struct mhi_result *mhi_res)
> >  {
> > @@ -142,19 +175,42 @@ static void mhi_net_dl_callback(struct mhi_device *mhi_dev,
> >         free_desc_count = mhi_get_free_desc_count(mhi_dev, DMA_FROM_DEVICE);
> >
> >         if (unlikely(mhi_res->transaction_status)) {
> > -               dev_kfree_skb_any(skb);
> > -
> > -               /* MHI layer stopping/resetting the DL channel */
> > -               if (mhi_res->transaction_status == -ENOTCONN)
> > +               switch (mhi_res->transaction_status) {
> > +               case -EOVERFLOW:
> > +                       /* Packet can not fit in one MHI buffer and has been
> > +                        * split over multiple MHI transfers, do re-aggregation.
> > +                        * That usually means the device side MTU is larger than
> > +                        * the host side MTU/MRU. Since this is not optimal,
> > +                        * print a warning (once).
> > +                        */
> > +                       netdev_warn_once(mhi_netdev->ndev,
> > +                                        "Fragmented packets received, fix MTU?\n");
> > +                       skb_put(skb, mhi_res->bytes_xferd);
> > +                       mhi_net_skb_agg(mhi_netdev, skb);
> > +                       break;
> > +               case -ENOTCONN:
> > +                       /* MHI layer stopping/resetting the DL channel */
> > +                       dev_kfree_skb_any(skb);
> >                         return;
> > -
> > -               u64_stats_update_begin(&mhi_netdev->stats.rx_syncp);
> > -               u64_stats_inc(&mhi_netdev->stats.rx_errors);
> > -               u64_stats_update_end(&mhi_netdev->stats.rx_syncp);
> > +               default:
> > +                       /* Unknown error, simply drop */
> > +                       dev_kfree_skb_any(skb);
> > +                       u64_stats_update_begin(&mhi_netdev->stats.rx_syncp);
> > +                       u64_stats_inc(&mhi_netdev->stats.rx_errors);
> > +                       u64_stats_update_end(&mhi_netdev->stats.rx_syncp);
> > +               }
> >         } else {
> > +               skb_put(skb, mhi_res->bytes_xferd);
> > +
> > +               if (mhi_netdev->skbagg_head) {
> > +                       /* Aggregate the final fragment */
> > +                       skb = mhi_net_skb_agg(mhi_netdev, skb);
> > +                       mhi_netdev->skbagg_head = NULL;
> > +               }
> > +
> >                 u64_stats_update_begin(&mhi_netdev->stats.rx_syncp);
> >                 u64_stats_inc(&mhi_netdev->stats.rx_packets);
> > -               u64_stats_add(&mhi_netdev->stats.rx_bytes, mhi_res->bytes_xferd);
> > +               u64_stats_add(&mhi_netdev->stats.rx_bytes, skb->len);
>
> might this change stats? it will if skb->len != 0 before skb_put. Even
> if so, perhaps it doesn't matter.

Don't get that point, skb is the received MHI buffer, we simply set
its size because MHI core don't (skb->len is always 0 before put).
Then if it is part of a fragmented transfer we just do the extra
'skb = skb_agg+ skb', so skb->len should always be right here,
whether it's a standalone/linear packet or a multi-frag packet.

Regards,
Loic
