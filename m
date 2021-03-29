Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D96FE34D019
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 14:32:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230259AbhC2McS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 08:32:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230504AbhC2McD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Mar 2021 08:32:03 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CF06C061574
        for <netdev@vger.kernel.org>; Mon, 29 Mar 2021 05:32:03 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id h13so14006706eds.5
        for <netdev@vger.kernel.org>; Mon, 29 Mar 2021 05:32:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=06mpHQQ+lJHy6xL6tpzRIMrou2GKfABoXQW5apZhfO0=;
        b=YQ08/MTYBVZN7fcw7erN74h9uazX7xzMuZVkdRZYbcLM2dDLGm8b3rtmCZS4e89XCO
         RZ5ItXtN1oy1R8VDClPJHtwl2HTq3cTVk/3yUqz4TaK7bpmZWWQKWPmjFzZBrsT6mPJI
         Gd63AdPsj/Qk71lzLje4LB0DHsi7e0tho9Yi2aVm61yA8sakYvDcb9aZ3zEe3zsDE+8q
         +YCYHXwtnqStgtzy4W+FhTG1B1PrzvtxZoanhW5mHpEG5UgUvLhUUE34+8n5An/rFA9S
         VeRuoU6AqcCMXP6XiGXtmTqWsQEtk+N8ErOX00WVB+g0WIbrIYH0GED1UnxHIpadV/Mz
         3OLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=06mpHQQ+lJHy6xL6tpzRIMrou2GKfABoXQW5apZhfO0=;
        b=HRgJt7T8jmriyi5DkYNYgXSBEFX/M3ccq8nL7IlgmDLmXMxRUGcVkAD3EF+1v8QYJO
         iEqh3ANUbc9fQ0tNvCaEgqAyEpHt8R6XitxLRaTBuc4XgVHqyusw1oIAoluAUOu05kJD
         evtbrOnB82rcr5bEpNegPjaSJhJbh6uKGAPi5bTpwUIMrPTLL4Sm3HdKJ+Zpkr3chwP3
         tHvpOa4waGZ9Ki2TVOX5CGmOC4df77X4Y+i15EOst69eepWCH+ZTXHCReP/gCivTIhYW
         J6Z8ntEN/nWNpi3HzGSWf1T9+bEGisaPzSJ1JJkNDDTmIuvchFUZaI/BV3E7c4VTQ/xm
         7/kg==
X-Gm-Message-State: AOAM532rFch5s5jhcX2NqqOqFg2dqcsJrNNH6JYJSAos4nrDm8xdm8Hz
        FYxNx+9oJOuWv7Vpdcb4IjkWcKDCJZk=
X-Google-Smtp-Source: ABdhPJxw3CdoXyq9N8aYso8hBnso4y18CmShnEHMIDuc15gGl4BIKOuaQfSNZntglr1M0dcX7GUlaw==
X-Received: by 2002:a05:6402:2076:: with SMTP id bd22mr27839066edb.378.1617021121267;
        Mon, 29 Mar 2021 05:32:01 -0700 (PDT)
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com. [209.85.221.47])
        by smtp.gmail.com with ESMTPSA id u24sm8158799ejn.5.2021.03.29.05.32.00
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Mar 2021 05:32:00 -0700 (PDT)
Received: by mail-wr1-f47.google.com with SMTP id o16so12738199wrn.0
        for <netdev@vger.kernel.org>; Mon, 29 Mar 2021 05:32:00 -0700 (PDT)
X-Received: by 2002:a05:6000:1803:: with SMTP id m3mr28898454wrh.50.1617021120129;
 Mon, 29 Mar 2021 05:32:00 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1616692794.git.pabeni@redhat.com> <7fa75957409a3f5d14198261a7eddb2bf1bff8e1.1616692794.git.pabeni@redhat.com>
 <CA+FuTScNjt0dTEHM8WprhDZ5G3H0Y4af4fg2Xqs+eCCrNtHwVA@mail.gmail.com> <846f001b9f4b3d377318ddbe4907f79ff4256019.camel@redhat.com>
In-Reply-To: <846f001b9f4b3d377318ddbe4907f79ff4256019.camel@redhat.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Mon, 29 Mar 2021 08:31:23 -0400
X-Gmail-Original-Message-ID: <CA+FuTSdxf=UM9EtKwnY3ycmv8y2mKND4reP5b74BaBxLPm-J0A@mail.gmail.com>
Message-ID: <CA+FuTSdxf=UM9EtKwnY3ycmv8y2mKND4reP5b74BaBxLPm-J0A@mail.gmail.com>
Subject: Re: [PATCH net-next v2 4/8] udp: never accept GSO_FRAGLIST packets
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Alexander Lobakin <alobakin@pm.me>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 29, 2021 at 4:14 AM Paolo Abeni <pabeni@redhat.com> wrote:
>
> On Fri, 2021-03-26 at 14:15 -0400, Willem de Bruijn wrote:
> > On Thu, Mar 25, 2021 at 1:24 PM Paolo Abeni <pabeni@redhat.com> wrote:
> > > Currently the UDP protocol delivers GSO_FRAGLIST packets to
> > > the sockets without the expected segmentation.
> > >
> > > This change addresses the issue introducing and maintaining
> > > a couple of new fields to explicitly accept SKB_GSO_UDP_L4
> > > or GSO_FRAGLIST packets. Additionally updates  udp_unexpected_gso()
> > > accordingly.
> > >
> > > UDP sockets enabling UDP_GRO stil keep accept_udp_fraglist
> > > zeroed.
> > >
> > > v1 -> v2:
> > >  - use 2 bits instead of a whole GSO bitmask (Willem)
> > >
> > > Fixes: 9fd1ff5d2ac7 ("udp: Support UDP fraglist GRO/GSO.")
> > > Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> >
> > This looks good to me in principle, thanks for the revision.
> >
> > I hadn't fully appreciated that gro_enabled implies accept_udp_l4, but
> > not necessarily vice versa.
> >
> > It is equivalent to (accept_udp_l4 && !up->gro_receive), right?
>
> In this series, yes.
>
> > Could the extra bit be avoided with
> >
> > "
> > +      /* Prefer fraglist GRO unless target is a socket with UDP_GRO,
> > +       * which requires all but last segments to be of same gso_size,
> > passed in cmsg */
> >         if (skb->dev->features & NETIF_F_GRO_FRAGLIST)
> > -                NAPI_GRO_CB(skb)->is_flist = sk ? !udp_sk(sk)->gro_enabled: 1;
> > +               NAPI_GRO_CB(skb)->is_flist = sk ?
> > (!udp_sk(sk)->gro_enabled || udp_sk(sk)->accept_udp_fraglist) : 1;
>
> This is not ovious at all to me.
>
> > +     /* Apply transport layer GRO if forwarding is enabled or the
> > flow lands at a local socket */
> >        if ((!sk && (skb->dev->features & NETIF_F_GRO_UDP_FWD)) ||
> >             (sk && udp_sk(sk)->gro_enabled && !up->encap_rcv) ||
> > NAPI_GRO_CB(skb)->is_flist) {
> >                 pp = call_gro_receive(udp_gro_receive_segment, head, skb);
> >                 return pp;
> >         }
> >
> > +      /* Continue with tunnel GRO */
> > "
> >
> > .. not that the extra bit matters a lot. And these two conditions with
> > gro_enabled are not very obvious.
> >
> > Just a thought.
>
> Overall looks more complex to me. I would keep the extra bit, unless
> you have strong opinion.

Sounds good.

> Side note: I was wondering about a follow-up to simplify the condition:
>
>         if ((!sk && (skb->dev->features & NETIF_F_GRO_UDP_FWD)) ||
>              (sk && udp_sk(sk)->gro_enabled && !up->encap_rcv) || NAPI_GRO_CB(skb)->is_flist) {
>
> Since UDP sockets could process (segmenting as needed) unexpected GSO
> packets, we could always do 'NETIF_F_GRO_UDP_FWD', when enabled on the
> device level. The above becomes:
>
>         if (skb->dev->features & NETIF_F_GRO_UDP_FWD) ||
>             (sk && udp_sk(sk)->gro_enabled && !up->encap_rcv) ||
>             NAPI_GRO_CB(skb)->is_flist) {
>
> which is hopefully more clear (and simpler). As said, non for this
> series anyhow.

UDP sockets can segment, but it is expensive. In this case I think the
simplification is not worth the possible regression.
