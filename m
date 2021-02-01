Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2821530ACE0
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 17:43:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230267AbhBAQmb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 11:42:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229567AbhBAQm3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 11:42:29 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24B34C061573
        for <netdev@vger.kernel.org>; Mon,  1 Feb 2021 08:41:48 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id i8so8935348ejc.7
        for <netdev@vger.kernel.org>; Mon, 01 Feb 2021 08:41:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SOWJxplIYPcjuK5i4wXyCK+ECbqtcTujm0zcEFwkiZ0=;
        b=gIIafhL/kjwTSdcxvpfUvPDccRjLL+3if5H+wWscH3ChQpwmrLYvQuom9onB8arHis
         a70uakPiMnTbHyAA4KjOyFDRjJ4RMFe779VATrSyFxkz/BnFh6fVzEpUnhTChldrbEh8
         moTdnhFC/KYHGy1Yq+5RkmDFBiah1x1H8Q3EYmhm5AuBAjxkRlnUi6NZVp5BHfSPyphB
         /M50tVqdTaRQ7tdLHApx0/NdPFdwtv+Ykz27u5Q76nxMFFpQHK8xIo074IvFmFQeUpJo
         +ZBclsKW4AQfWK+WMeSjsrq9Y7XaxzJq/JAf3r9uhQl5BXhcTmSSaIhMouOptugTVQY8
         Eprg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SOWJxplIYPcjuK5i4wXyCK+ECbqtcTujm0zcEFwkiZ0=;
        b=sTV5Vxf8LbC/JCu4jEtsEGF3VYYZUhJkQETIFAq5zeLVnTiqBo9hQfpj/zwc4Jh3cb
         d8KAXIcFOVb2brzKx1tbLgyMgLddaCPKk8gQhOTg0VGCW6uVB9pSH1zPLsw8pK1baKDA
         G6QlHv1EfhnPl4pYmnDToWGdu1+SIBt5alDpS9pPED2BLxDCo3tBkqPHNGxjWUwBRoIq
         W3aPlaNppLlsnnKaqlZhTmM8AMle7UfI3foKrpm65UyzP/9Lo7x4yv8sMBrrHf7q+BL0
         phJf4QNAMsvVQDr/XHwaMZFj3oeFvaJbRexpANYHNXsHlEjmsrsYtY+hJxHg5WDqoguH
         0pIQ==
X-Gm-Message-State: AOAM531sRYQXLH0hKGIFnyks6SglTXMZONR0NCFNnTzjQt+62VT8lO76
        QvFLrbCBZG4IrUHrsgdw4YIQd7f/EUtLHW5RR3jnlaiBAQ0=
X-Google-Smtp-Source: ABdhPJxHtE+zTsf0N7W8/1G4Vsf8KkhMJdM/MbI/gHiy+OVUSeKXdlg7aXeccT35bpne6H143EugmcfK8TrcHTs1lZw=
X-Received: by 2002:a17:906:51d0:: with SMTP id v16mr18715978ejk.510.1612197706822;
 Mon, 01 Feb 2021 08:41:46 -0800 (PST)
MIME-Version: 1.0
References: <1611589557-31012-1-git-send-email-loic.poulain@linaro.org>
 <20210129170129.0a4a682a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAMZdPi_6tBkdQn+wakUmeMC+p8N3HStEja5ZfA3K-+x4DcM68g@mail.gmail.com> <CAF=yD-+UFHO8nKsB3Z7n-xhoFtXwge2GEZj-2+-7=EETLjYXFA@mail.gmail.com>
In-Reply-To: <CAF=yD-+UFHO8nKsB3Z7n-xhoFtXwge2GEZj-2+-7=EETLjYXFA@mail.gmail.com>
From:   Loic Poulain <loic.poulain@linaro.org>
Date:   Mon, 1 Feb 2021 17:48:55 +0100
Message-ID: <CAMZdPi_dMBDafAVoHbqwR9RDbtZSJpGd48oCMmL1qAgR+PCFGQ@mail.gmail.com>
Subject: Re: [PATCH net-next] net: mhi-net: Add de-aggeration support
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 1 Feb 2021 at 15:24, Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
>
> On Mon, Feb 1, 2021 at 3:08 AM Loic Poulain <loic.poulain@linaro.org> wrote:
> >
> > Hi Jakub, Willem,
> >
> > On Sat, 30 Jan 2021 at 02:01, Jakub Kicinski <kuba@kernel.org> wrote:
> > >
> > > On Mon, 25 Jan 2021 16:45:57 +0100 Loic Poulain wrote:
> > > > When device side MTU is larger than host side MRU, the packets
> > > > (typically rmnet packets) are split over multiple MHI transfers.
> > > > In that case, fragments must be re-aggregated to recover the packet
> > > > before forwarding to upper layer.
> > > >
> > > > A fragmented packet result in -EOVERFLOW MHI transaction status for
> > > > each of its fragments, except the final one. Such transfer was
> > > > previoulsy considered as error and fragments were simply dropped.
> > > >
> > > > This patch implements the aggregation mechanism allowing to recover
> > > > the initial packet. It also prints a warning (once) since this behavior
> > > > usually comes from a misconfiguration of the device (modem).
> > > >
> > > > Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
> > >
> > > > +static struct sk_buff *mhi_net_skb_append(struct mhi_device *mhi_dev,
> > > > +                                       struct sk_buff *skb1,
> > > > +                                       struct sk_buff *skb2)
> > > > +{
> > > > +     struct sk_buff *new_skb;
> > > > +
> > > > +     /* This is the first fragment */
> > > > +     if (!skb1)
> > > > +             return skb2;
> > > > +
> > > > +     /* Expand packet */
> > > > +     new_skb = skb_copy_expand(skb1, 0, skb2->len, GFP_ATOMIC);
> > > > +     dev_kfree_skb_any(skb1);
> > > > +     if (!new_skb)
> > > > +             return skb2;
> > >
> > > I don't get it, if you failed to grow the skb you'll return the next
> > > fragment to the caller? So the frame just lost all of its data up to
> > > where skb2 started? The entire fragment "train" should probably be
> > > dropped at this point.
> >
> > Right, there is no point in keeping the partial packet in that case.
> >
> > >
> > > I think you can just hang the skbs off skb_shinfo(p)->frag_list.
> > >
> > > Willem - is it legal to feed frag_listed skbs into netif_rx()?
> >
> > In QMAP case, the packets will be forwarded to rmnet link, which works
> > with linear skb (no NETIF_F_SG), does the linearization will be
> > properly performed by the net core, in the same way as for xmit path?
>
> What is this path to rmnet, if not the usual xmit path / validate_xmit_skb?

I mean, not sure what to do exactly here, instead of using
skb_copy_expand to re-aggregate data from the different skbs, Jakub
suggests chaining the skbs instead (via 'frag_list' and 'next' pointer
I assume), and to push this chained skb to net core via netif_rx. In
that case, I assume the de-fragmentation/linearization will happen in
the net core, right? If the transported protocol is rmnet, the packet
is supposed to reach the rmnet_rx_handler at some point, but rmnet
only works with standard/linear skbs.

Regards,
Loic
