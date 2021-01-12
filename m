Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FCAB2F36A4
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 18:08:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392471AbhALRGc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 12:06:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733040AbhALRG3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 12:06:29 -0500
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34362C061795
        for <netdev@vger.kernel.org>; Tue, 12 Jan 2021 09:05:49 -0800 (PST)
Received: by mail-io1-xd29.google.com with SMTP id z5so5508299iob.11
        for <netdev@vger.kernel.org>; Tue, 12 Jan 2021 09:05:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=L2GaB22kREpojoruP/N4qIAzR+3+2LidI8P5vZ4S198=;
        b=Iare/dtc59oqGcjAwEbYH+SXla8ofDkY9Ztg+hPt28bpixDxf8UTmWTR3IPNf89ZUN
         DJd/oOfeiITcIhDMPhm9mQyDz3r6BflFzAn4QvWlow3VA/nPx2Mia3VucNEQRDSkf7a3
         Ra1saI4a94LNBi6FLzBheNMKJl4Rk/TeTW85iI9xs9A3P1/zXpyO9+T7X86mcMR1dagB
         kh5OqXH5EyXlbyeFh6vYdTl+GF08Op+jfuaKKIkPybYJYbmHAI8r1AkBZcfPLtl29j1j
         LobkhUK99gkxO1Pho7tCIJCt1N9NucODcJcZySRA0A/Tnd1MXrTNkThDVcuOScW1L9gG
         kpCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=L2GaB22kREpojoruP/N4qIAzR+3+2LidI8P5vZ4S198=;
        b=Szh4qcDtrTGmlcfHe/JqyZhDtGISZ1wjygiMX/SRELgLhuLvpqNJAoyPq6FogjQIXn
         XY1y4pFYGria0GBkIUL2eJuAAsxLM9pSlUqmT32RZj9sg1YCTg0sTC6pk/c4x5NRlWu3
         AclKCxOaabktXcs+VTDC0vXQRS015j3COhS4wEruilYHSSYnOgjVVpq1xy0QDZGpjHut
         LyqLd7rpSGtLdXf3EUB+rVH9YXeJ8qjS4iaejjTviFupDltIDz5DJl5UY9F4Bwzcb5NW
         j949NDdbX3Kst16d/7g9FX5iC5g+kK+mcDhz0fyEt5bS9m8n3DGpsu7y85KXF5NpygbB
         R2oA==
X-Gm-Message-State: AOAM533+FTRK8fXrrXLcrIrJ1SF+QZ8tP8tlppb7gA10wLURzc553Ndp
        VJFs7lTjc+0BK0VuEHBDrU+dUkAFtHeAdr6FLlOaG16N37XBUw==
X-Google-Smtp-Source: ABdhPJzCVacEi8wqaDolamQMMsaMRKT+0itcin/UiRxqzkGOC9Ifyfz7nFLVCAOzHKBi5pm8gV4FfUEmCuwoHYQHnKQ=
X-Received: by 2002:a92:da82:: with SMTP id u2mr4882695iln.137.1610471148363;
 Tue, 12 Jan 2021 09:05:48 -0800 (PST)
MIME-Version: 1.0
References: <20210111222411.232916-1-hcaldwel@akamai.com> <20210111222411.232916-5-hcaldwel@akamai.com>
 <CANn89iLheJ+a0AZ_JZyitsZK5RCVsadzgsBK=DeHs-7ko5OMuQ@mail.gmail.com> <24573.51244.563087.333291@gargle.gargle.HOWL>
In-Reply-To: <24573.51244.563087.333291@gargle.gargle.HOWL>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 12 Jan 2021 18:05:36 +0100
Message-ID: <CANn89i+1qN6A0vw=unv60VBfxb1SMMErAyfB9jzzHbx49HzE+A@mail.gmail.com>
Subject: Re: [PATCH net-next 4/4] tcp: remove limit on initial receive window
To:     Heath Caldwell <hcaldwel@akamai.com>
Cc:     netdev <netdev@vger.kernel.org>, Yuchung Cheng <ycheng@google.com>,
        Josh Hunt <johunt@akamai.com>, Ji Li <jli@akamai.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 12, 2021 at 5:02 PM Heath Caldwell <hcaldwel@akamai.com> wrote:
>
> On 2021-01-12 09:30 (+0100), Eric Dumazet <edumazet@google.com> wrote:
> > I think the whole patch series is an attempt to badly break TCP stack.
>
> Can you explain the concern that you have about how these changes might
> break the TCP stack?
>
> Patches 1 and 3 fix clear bugs.

Not clear to me at least.

If they were bug fixes, a FIxes: tag would be provided.

You are a first time contributor to linux TCP stack, so better make
sure your claims are solid.

>
> Patches 2 and 4 might be arguable, though.

So we have to pick up whatever pleases us ?

>
> Is you objection primarily about the limit removed by patch 4?
>
> > Hint : 64K is really the max allowed by TCP standards. Yes, this is
> > sad, but this is it.
>
> Do you mean the limit imposed by the size of the "Window Size" header
> field?  This limitation is directly addressed by the check in
> __tcp_transmit_skb():
>
>         if (likely(!(tcb->tcp_flags & TCPHDR_SYN))) {
>                 th->window      = htons(tcp_select_window(sk));
>                 tcp_ecn_send(sk, skb, th, tcp_header_size);
>         } else {
>                 /* RFC1323: The window in SYN & SYN/ACK segments
>                  * is never scaled.
>                  */
>                 th->window      = htons(min(tp->rcv_wnd, 65535U));
>         }
>
> and checking (and capping it there) allows for the field to not overflow
> while also not artificially restricting the size of the window which
> will later be advertised (once window scaling is negotiated).
>
> > I will not spend hours of work running  packetdrill tests over your
> > changes, but I am sure they are now quite broken.
> >
> > If you believe auto tuning is broken, fix it properly, without trying
> > to change all the code so that you can understand it.
>
> The removal of the limit specifically addresses the situation where auto
> tuning cannot work: on the initial burst.

Which standard allows for a very big initial burst ?
AFAIK, IW10 got a lot of pushback, and that was only for a burst of ~14600 bytes
Allowing arbitrarily large windows needs IETF approval.


>  There is no way to know
> whether an installation desires to receive a larger first burst unless
> it is specifically configured - and this limit prevents such
> configuration.
>
> > I strongly advise you read RFC 7323 before doing any changes in TCP
> > stack, and asking us to spend time reviewing your patches.
>
> Can you point out the part of the RFC which would be violated by
> initially (that is, the first packet after the SYN) advertising a window
> larger than 64KB?

We handle gradual increase of rwin based on the behavior of
applications and senders (skb len/truesize ratio)

Again if you believe autotuning is broken please fix it, instead of
throwing it away.

Changing initial RWIN can have subtle differences on how fast DRS algo
can kick in.

This kind of change would need to be heavily tested, with millions of
TCP flows in the wild.
(ie not in a lab environment)

Have you done this ? What happens if flows are malicious and sent 100
bytes per segment ?
