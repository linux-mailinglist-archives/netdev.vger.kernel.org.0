Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1818132CA87
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 03:47:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231430AbhCDCqV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Mar 2021 21:46:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231527AbhCDCp6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Mar 2021 21:45:58 -0500
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C695C06175F
        for <netdev@vger.kernel.org>; Wed,  3 Mar 2021 18:45:18 -0800 (PST)
Received: by mail-io1-xd29.google.com with SMTP id i8so28113353iog.7
        for <netdev@vger.kernel.org>; Wed, 03 Mar 2021 18:45:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+hbhL12oEyPCPyPQY2+0F72fe5ikxn/towg0no71uRc=;
        b=NM2XWSOPTnMZ7PjX7wGJTdYLOBkftPAUA4cJXAcgBypmpQcLBuRyJrnm+qZ8LUASoY
         8grSZNnrFz2Tvzchlu00KNcNnHzotNUx+8qSwZaI1X2ua71oYKvjzlipIESXnRPLjGlu
         UEGDVfLdhkHKOT+O4Zlc2RP8dPHbA5s+E/Si72I1U5OGl39sgGOBGlrr1a/rv7700JIl
         tcNj2CNaaANKR2497cIlUj2YXv/ZjN5qXDDi/ORZRxCnF6TGkn0Vd+x9+LGYQRCcEVAU
         12dNxZjXS66dZ+4MLFGFGxk8gb+t1/fwDcV2bioXlMTN4dhffdLjzLnGeKbCylZFT+EA
         KhbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+hbhL12oEyPCPyPQY2+0F72fe5ikxn/towg0no71uRc=;
        b=WP6DdffnCPS01EdXDtJ18jIzp8sAs1pOd4/i+jTkqM5hjY7XkmBHWKcEWMSwbS2Ebx
         QMEjL+2bbsSUwMReO1n0JEZ+rHQwDuSeLGT7HchsHgcLSGMrECN7qnhQOU2mZykGmGcF
         BHKao5/Ny3f8VEJv/DLJiSH+t8pBiaUEhXHiROHezNv9NRDxZe3JWpV/ItxEq6ySyjEW
         W0g6vHSALfYZ0efphJ7u97WKbmhadLKqzdKHJN5lKfISn+gbzPyu99tP48IKWEJCNrFk
         XB5U0sWw4FMcV48P/xIDCg6Te5hQJBmhFQwRXmtYfMdAJvWQ0FT39Km+aVsnC1Dw8Pv4
         /x7g==
X-Gm-Message-State: AOAM533/l393t0oUsE9EWU0zHJ62eAr8Uv96ExCYSWg40HijBIKX1ogj
        nM9mlZNi7/0odQLQgAtk0kPnWKTaBn6PmB5DNKI=
X-Google-Smtp-Source: ABdhPJz4WqHVJz0hUJ63EJziYn/6nZC9UN7HOp7mk5H1nLkt8pGRseX27r4GgUbbaUx3ckzxUmdMz9Yk5ptdZzOPGn4=
X-Received: by 2002:a05:6638:1390:: with SMTP id w16mr2017505jad.83.1614825917731;
 Wed, 03 Mar 2021 18:45:17 -0800 (PST)
MIME-Version: 1.0
References: <20210302060753.953931-1-kuba@kernel.org> <CANn89iLaQuCGeWOh7Hp8X9dL09FhPP8Nwj+zV=rhYX7Cq7efpg@mail.gmail.com>
 <CAKgT0UdXiFBW9oDwvsFPe_ZoGveHLGh6RXf55jaL6kOYPEh0Hg@mail.gmail.com> <20210303160715.2333d0ca@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210303160715.2333d0ca@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Wed, 3 Mar 2021 18:45:06 -0800
Message-ID: <CAKgT0Ue9w4WBojY94g3kcLaQrVbVk6S-HgsFgLVXoqsY20hwuw@mail.gmail.com>
Subject: Re: [PATCH net] net: tcp: don't allocate fast clones for fastopen SYN
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>,
        David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        kernel-team <kernel-team@fb.com>, Neil Spring <ntspring@fb.com>,
        Yuchung Cheng <ycheng@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 3, 2021 at 4:07 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Wed, 3 Mar 2021 13:35:53 -0800 Alexander Duyck wrote:
> > On Tue, Mar 2, 2021 at 1:37 PM Eric Dumazet <edumazet@google.com> wrote:
> > > On Tue, Mar 2, 2021 at 7:08 AM Jakub Kicinski <kuba@kernel.org> wrote:
> > > > When receiver does not accept TCP Fast Open it will only ack
> > > > the SYN, and not the data. We detect this and immediately queue
> > > > the data for (re)transmission in tcp_rcv_fastopen_synack().
> > > >
> > > > In DC networks with very low RTT and without RFS the SYN-ACK
> > > > may arrive before NIC driver reported Tx completion on
> > > > the original SYN. In which case skb_still_in_host_queue()
> > > > returns true and sender will need to wait for the retransmission
> > > > timer to fire milliseconds later.
> > > >
> > > > Revert back to non-fast clone skbs, this way
> > > > skb_still_in_host_queue() won't prevent the recovery flow
> > > > from completing.
> > > >
> > > > Suggested-by: Eric Dumazet <edumazet@google.com>
> > > > Fixes: 355a901e6cf1 ("tcp: make connect() mem charging friendly")
> > >
> > > Hmmm, not sure if this Fixes: tag makes sense.
> > >
> > > Really, if we delay TX completions by say 10 ms, other parts of the
> > > stack will misbehave anyway.
> > >
> > > Also, backporting this patch up to linux-3.19 is going to be tricky.
> > >
> > > The real issue here is that skb_still_in_host_queue() can give a false positive.
> > >
> > > I have mixed feelings here, as you can read my answer :/
> > >
> > > Maybe skb_still_in_host_queue() signal should not be used when a part
> > > of the SKB has been received/acknowledged by the remote peer
> > > (in this case the SYN part).
> > >
> > > Alternative is that drivers unable to TX complete their skbs in a
> > > reasonable time should call skb_orphan()
> > >  to avoid skb_unclone() penalties (and this skb_still_in_host_queue() issue)
> > >
> > > If you really want to play and delay TX completions, maybe provide a
> > > way to disable skb_still_in_host_queue() globally,
> > > using a static key ?
> >
> > The problem as I see it is that the original fclone isn't what we sent
> > out on the wire and that is confusing things. What we sent was a SYN
> > with data, but what we have now is just a data frame that hasn't been
> > put out on the wire yet.
>
> Not sure I understand why it's the key distinction here. Is it
> re-transmitting part of the frame or having different flags?
> Is re-transmit of half of a GSO skb also considered not the same?

The difference in my mind is the flags. So specifically the clone of
the syn_data frame in the case of the TCP fast open isn't actually a
clone of the sent frame. Instead we end up modifying the flags so that
it becomes the first data frame. We already have the SYN sitting in
the retransmit queue before we send the SYN w/ data frame. In addition
the SYN packet in the retransmit queue has a reference count of 1 so
it is not encumbered by the fclone reference count check so it could
theoretically be retransmitted immediately, it is just the data packet
that is being held.

If we replay a GSO frame we will get the same frames all over again.
In the case of a TCP fast open syn_data packet that isn't the case.
The first time out it is one packet, the second time it is two.

> To me the distinction is that the receiver has implicitly asked
> us for the re-transmission. If it was requested by SACK we should
> ignore "in_queue" for the first transmission as well, even if the
> skb state is identical.

In my mind the distinction is the fact that what we have in the
retransmit queue is 2 frames, a SYN and a data. Whereas what we have
put on the wire is SYN w/ data.

> > I wonder if we couldn't get away with doing something like adding a
> > fourth option of SKB_FCLONE_MODIFIED that we could apply to fastopen
> > skbs? That would keep the skb_still_in_host queue from triggering as
> > we would be changing the state from SKB_FCLONE_ORIG to
> > SKB_FCLONE_MODIFIED for the skb we store in the retransmit queue. In
> > addition if we have to clone it again and the fclone reference count
> > is 1 we could reset it back to SKB_FCLONE_ORIG.
>
> The unused value of fclone was tempting me as well :)
>
> AFAICT we have at least these options:
>
> 1 - don't use a fclone skb [v1]
>
> 2 - mark the fclone as "special" at Tx to escape the "in queue" check

This is what I had in mind. Basically just add a function to
transition from SKB_FCLONE_ORIG to SKB_FCLONE_MODIFIED/DIRTY when the
clone no longer represents what is actually on the wire.

The added benefit is that we can potentially restore it to
SKB_FCLONE_ORIG if we clone it again assuming the reference count fell
back to 1.

> 3 - indicate to retansmit that we're sure initial tx is out [v2]
>
> 4 - same as above but with a bool / flag instead of negative seg
>
> 5 - use the fclone bits but mark them at Rx when we see a rtx request
>
> 6 - check the skb state in retransmit to match the TFO case (IIUC
>     Yuchung's suggestion)
>
> #5 is my favorite but I didn't know how to extend it to fast
> re-transmits so I just stuck to the suggestion from the ML :)
>
> WDYT? Eric, Yuchung?
