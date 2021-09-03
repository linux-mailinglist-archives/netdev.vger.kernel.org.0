Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD47040082A
	for <lists+netdev@lfdr.de>; Sat,  4 Sep 2021 01:21:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237375AbhICXPI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Sep 2021 19:15:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349275AbhICXPH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Sep 2021 19:15:07 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4937BC061575
        for <netdev@vger.kernel.org>; Fri,  3 Sep 2021 16:14:07 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id n27so1090243eja.5
        for <netdev@vger.kernel.org>; Fri, 03 Sep 2021 16:14:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ybOsD04X8hba6t8ymQy6f5xPdVGx4IHmfG3PnU+GCEw=;
        b=Jmf6/tbPTllrw9KXFAN6SsX2gTU9N3CT71R3ORkqueiXBYXQMspyjuzDuU+to0oiE6
         QArq7xXdB/yLYs7to7qAHiXiwyNqltNZfJsQ0o6dXXo9ST6ilZki2VRDGReBSkrgVJIq
         gXSzMbzeNKnLGU1xEZSQN5XwWIOxTAdQzzfxP84pOxAmniqai0aOVWIE7XBQqc8pr9HM
         iFYsTN7tf/6JajEIMY47jqFGl7q41DaoAW4rj/rHczCEnsRiO0Ledr5f9d4rQb6vYU22
         8z6cauqjwaRfDw+3R3B5/kS6U5U4YyTtokGTH3xUcm/IGXHVIGtZj1mBzJWQpTrRLLbc
         5pqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ybOsD04X8hba6t8ymQy6f5xPdVGx4IHmfG3PnU+GCEw=;
        b=s0dpn6nGWqV0bAVUYvFRG+SWLhvo0J38+jHvPsXiICxwWKws/RDAwVUM8xc2pnq8+T
         oUN32vfVFQJVFL5l15Inxs22WlB4F0hU33j6zp4hBhUWv+r9ZFuAoFRqOtFU1sTFDBsU
         zYK+Bs0+ZGFyrqs/JjMWy0V5F0lOVai8G4qS62Q5ZkpzDM41JXVGvoW/rlcUw8c0B8Li
         QfqFj7fGmfDpaJrtDDw4DxAMblc/r41f9gRj10jo77UkC/N+m3P7qDhHFnJnIjNT+QLz
         sc72ddnpy7GDddRui+wfANytG2d89oDdoknXwvZ4DFM1y3qElNE0zYt6p2vYHdTpLFdE
         IX1w==
X-Gm-Message-State: AOAM533LVCiflHje6PxPmH0Hdm5iBz4jZEqz/1DmMDbtdv6Wb4od9nf1
        /4CFoJIzJMJsAocQ8LqbGC2qdR0GMUPyWU30XM8fqTOk
X-Google-Smtp-Source: ABdhPJxrb3F8hnXTz7WYw2ANjNvAJaYkt0M6RDBO40DIWysbLX4F9FTFyuC6Ns+4CJX3fiqjce2Wq+WWndDWuLyQz7o=
X-Received: by 2002:a17:906:144e:: with SMTP id q14mr1339417ejc.19.1630710845804;
 Fri, 03 Sep 2021 16:14:05 -0700 (PDT)
MIME-Version: 1.0
References: <20210902193447.94039-1-willemdebruijn.kernel@gmail.com>
 <20210902193447.94039-2-willemdebruijn.kernel@gmail.com> <CAKgT0UdhaUp0jcNZSzMu=_OezwqKNHP47u0n_XUkpO_SbSV8hA@mail.gmail.com>
 <CA+FuTSfaN-wLzVq1UQhwiPgH=PKdcW+kz1PDxgfrLAnjWf8CKA@mail.gmail.com>
 <CAKgT0UdtqJ+ECyDs1dv7ha4Bq12XaGiOQ6uvja5cy06dDR5ziw@mail.gmail.com>
 <CA+FuTSfpmGHC76GAVVS2qazfLykVZ=mM+33pRHpj-yyM3nqhXA@mail.gmail.com>
 <CAKgT0UdiYRHrSUGb9qDJ-GGMBj53P1L4KHSV7tv+omA5FjRZNQ@mail.gmail.com>
 <CA+FuTSf-83bDVzmB757ha99DS=O-KjSFVSn15Y6Vq5Yh9yx2wA@mail.gmail.com>
 <CAKgT0Uf6YrDtvEfL02-P7A3Q_V32MWZ-tV7B=xtkY0ZzxEo9yg@mail.gmail.com> <CA+FuTSeHAd4ouwYd9tL2FHa1YdB3aLznOTnAJt+PShnr+Zd7yw@mail.gmail.com>
In-Reply-To: <CA+FuTSeHAd4ouwYd9tL2FHa1YdB3aLznOTnAJt+PShnr+Zd7yw@mail.gmail.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Fri, 3 Sep 2021 16:13:54 -0700
Message-ID: <CAKgT0Ucx+i6prW5n95dYRF=+7hz2pzNDpQfwwUY607MyQh1gGg@mail.gmail.com>
Subject: Re: [PATCH net] ip_gre: validate csum_start only if CHECKSUM_PARTIAL
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ido Schimmel <idosch@idosch.org>,
        chouhan.shreyansh630@gmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 3, 2021 at 12:38 PM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
>

<snip>

> > whereas if the offset is stored somewhere in the unstripped data we
> > could then drop the packet and count it as a drop without having to
> > modify the frame via the skb_pull.
>
> This is a broader issue that userspace can pass any csum_start as long
> as it is within packet bounds. We could address it here specifically
> for the GRE header. But that still leaves many potentially bad offsets
> further in the packet in this case, and all the other cases. Checking
> that specific header seems a bit arbitrary to me, and might actually
> give false confidence.
>
> We could certainly move the validation from gre_handle_offloads to
> before skb_pull, to make it more obvious *why* the check exists.

Agreed. My main concern is that the csum_start is able to be located
somewhere where the userspace didn't write. For the most part the
csum_start and csum_offset just needs to be restricted to the regions
that the userspace actually wrote to.

> > > The negative underflow and kernel crash is very specific to
> > > lco_csum, which calculates the offset between csum_offset
> > > and transport_offset. Standard checksum offset doesn't.
> > >
> > > One alternative fix, then, would be to add a negative overflow
> > > check in lco_csum itself.
> > > That only has three callers and unfortunately by the time we hit
> > > that for GRE in gre_build_header, there no longer is a path to
> > > cleanly dropping the packet and returning an error.
> >
> > Right. We could find the problem there but it doesn't solve the issue.
> > The problem is the expectation that the offset exists in the area
> > after the checksum for the tunnel header, not before.
> >
> > > I don't find this bad input whack-a-mole elegant either. But I
> > > thought it was the least bad option..
> >
> > The part that has been confusing me is how the virtio_net_hdr could
> > have been pointing as the IP or GRE headers since they shouldn't have
> > been present on the frame provided by the userspace. I think I am
> > starting to see now.
> >
> > So in the case of af_packet it looks like it is calling
> > dev_hard_header which calls header_ops->create before doing the
> > virtio_net_hdr_to_skb call. Do I have that right?
>
> Mostly yes. That is the case for SOCK_DGRAM. For SOCK_RAW, the caller
> is expected to have prepared these headers.
>
> Note that for the ip_gre device to have header_ops, this will be
> ipgre_header_ops, which .create member function comment starts with
> "/* Nice toy. Unfortunately, useless in real life :-)". We recently
> had a small series of fixes related to this special case and packet
> sockets, such as commit fdafed459998 ("ip_gre: set
> dev->hard_header_len and dev->needed_headroom properly"). This case of
> a GRE device that receives packets with outer IP + GRE headers is out
> of the ordinary.

I'm not sure the comment is about the functionality of the function as
much as the addressing. Seems to be about setting up a multicast GRE
configuration.

> > Maybe for those
> > cases we need to look at adding an unsigned int argument to
> > virtio_net_hdr_to_skb in which we could pass 0 for the unused case or
> > dev->hard_header_len in the cases where we have something like
> > af_packet that is transmitting over an ipgre tunnel. The general idea
> > is to prevent these virtio_net_hdr_to_skb calls from pointing the
> > csum_start into headers that userspace was not responsible for
> > populating.
>
> One issue with that is that dev->hard_header_len itself is imprecise
> for protocols with variable length link layer headers. There, too, we
> have had a variety of bug fixes in the past.
>
> It also adds cost to every user of virtio_net_hdr, while we only know
> one issue in a rare case of the IP_GRE device.

Quick question, the assumption is that the checksum should always be
performed starting no earlier than the transport header right? Looking
over virtio_net_hdr_to_skb it looks like it is already verifying the
transport header is in the linear portion of the skb. I'm wondering if
we couldn't just look at adding a check to verify the transport offset
is <= csum start? We might also be able to get rid of one of the two
calls to pskb_may_pull by doing that.
