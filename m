Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A52022FF6E
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 04:18:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726909AbgG1CSD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 22:18:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726362AbgG1CSD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 22:18:03 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 554DBC061794
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 19:18:03 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id a5so3940416ioa.13
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 19:18:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LXLuAvROzFr72Oah3dkKL7h7BJ/YbFSR/ChXsb47yek=;
        b=UXWjq0AhxXTNOsMaW5q0DAUtWFkJiYkNXRJ2yR+TVusqvBLaPEw9OZ0HB4WQDZ1vjs
         O8M/uzUSSqgnjHOKX8Ohv/mjd6xb7vAkPH8HO7aqoplTCfc+EK/axuBEN1NjtsPQEv/g
         CkR/AzAOUCuWKr9ZXSjkQrC6WlsR9fixIQmGpTrARAZICCj4Nr+56gUWnLr8xPUFAfBv
         xb5o52xbMT3mKZKKKY7s8Q1fQUyauEGtHQpyVMPs8S+P7t5akdgJJqIyPkZ/+lietEvp
         +LKKeh1J4dVDsOiWYAbvNdf5DCKp5RAN6ErAFAD3rNwpY836gSD5gxUO6ILm0MIHLJVw
         mfzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LXLuAvROzFr72Oah3dkKL7h7BJ/YbFSR/ChXsb47yek=;
        b=HiZOsSipmAGTsMvsPjvh7ZX2THZQ42koojVqhuXGDSFnip/XAN0H2vE0dIcm3K0Qp3
         ylPzH/9ZY+oLYXn3XpxgNQryHg0WdyYDR3NnTjvHhHDSyG3Fqwfiaz0grercogtxRLZD
         2BfKu3KwV9pFE/XUa0WMhg8uhUweGtRUUHpTW/e+w+ANt6SsBlRYhF6BJa5pKmrcEBnp
         JykzrFx61tzuVPoanL366BPXut7hGggly8yB75Kazx9RbxVHukCLWdsOR0qm9mkkQz4d
         046W5oNd9sptd+E8ijZmbTxHsRhF6w8qXzZwPfTUjYbLsP29CGFljgRQJRguL1YM6QWz
         Kdkg==
X-Gm-Message-State: AOAM533Vn1ZplwhSB5rVem+Gc9pAGTxdIuwFAFXmWoA0mJIBsNcELOwN
        vVCM7FJp/SZqwSHvorg+3vheWz+vqsBBpXQ8noVkvw==
X-Google-Smtp-Source: ABdhPJw/j31euiGlZmvYTuqwPhxJaAs0OyO6vKUdy/6NyAtdJYAMyzNAgeR19Kx8FbFBzKuPq6ATpREzZ0Fo6YUlC08=
X-Received: by 2002:a02:95e6:: with SMTP id b93mr7482106jai.99.1595902682442;
 Mon, 27 Jul 2020 19:18:02 -0700 (PDT)
MIME-Version: 1.0
References: <20200727052846.4070247-1-jonathan.lemon@gmail.com>
 <20200727052846.4070247-16-jonathan.lemon@gmail.com> <CANn89iJ5vyx0WqdKTB3uHaWJrG-3jNXqXs6r7PacSqg0jRsRKA@mail.gmail.com>
 <20200727155549.gbwosugbugknsneo@bsd-mbp.dhcp.thefacebook.com>
 <CANn89iKY27R=ryQLohFPWa9dr6R9dMgB-hj+9eJO6H4NqfVKVw@mail.gmail.com>
 <20200727173528.tfsrweswpyjxlqv6@bsd-mbp.dhcp.thefacebook.com>
 <CANn89iKStB8=Exyopi1sufuYhA-rZvYVMOEm9LDgKTLBYiqSmA@mail.gmail.com> <20200728021130.bjrlcj7tzebfxsz3@bsd-mbp.dhcp.thefacebook.com>
In-Reply-To: <20200728021130.bjrlcj7tzebfxsz3@bsd-mbp.dhcp.thefacebook.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 27 Jul 2020 19:17:51 -0700
Message-ID: <CANn89iL=p3pgDpPeWz5rZqGeCdHg=X=hkEPe=mk9TDa=bk7ZRQ@mail.gmail.com>
Subject: Re: [RFC PATCH v2 15/21] net/tcp: add MSG_NETDMA flag for sendmsg()
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>, kernel-team <kernel-team@fb.com>,
        Christoph Hellwig <hch@lst.de>,
        Robin Murphy <robin.murphy@arm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        bjorn.topel@intel.com, magnus.karlsson@intel.com,
        borisp@mellanox.com, david@redhat.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 27, 2020 at 7:11 PM Jonathan Lemon <jonathan.lemon@gmail.com> wrote:
>
> On Mon, Jul 27, 2020 at 10:44:59AM -0700, Eric Dumazet wrote:
> > On Mon, Jul 27, 2020 at 10:35 AM Jonathan Lemon
> > <jonathan.lemon@gmail.com> wrote:
> > >
> > > On Mon, Jul 27, 2020 at 09:09:48AM -0700, Eric Dumazet wrote:
> > > > On Mon, Jul 27, 2020 at 8:56 AM Jonathan Lemon <jonathan.lemon@gmail.com> wrote:
> > > > >
> > > > > On Mon, Jul 27, 2020 at 08:19:43AM -0700, Eric Dumazet wrote:
> > > > > > On Mon, Jul 27, 2020 at 12:51 AM Jonathan Lemon
> > > > > > <jonathan.lemon@gmail.com> wrote:
> > > > > > >
> > > > > > > This flag indicates that the attached data is a zero-copy send,
> > > > > > > and the pages should be retrieved from the netgpu module.  The
> > > > > > > socket should should already have been attached to a netgpu queue.
> > > > > > >
> > > > > > > Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
> > > > > > > ---
> > > > > > >  include/linux/socket.h | 1 +
> > > > > > >  net/ipv4/tcp.c         | 8 ++++++++
> > > > > > >  2 files changed, 9 insertions(+)
> > > > > > >
> > > > > > > diff --git a/include/linux/socket.h b/include/linux/socket.h
> > > > > > > index 04d2bc97f497..63816cc25dee 100644
> > > > > > > --- a/include/linux/socket.h
> > > > > > > +++ b/include/linux/socket.h
> > > > > > > @@ -310,6 +310,7 @@ struct ucred {
> > > > > > >                                           */
> > > > > > >
> > > > > > >  #define MSG_ZEROCOPY   0x4000000       /* Use user data in kernel path */
> > > > > > > +#define MSG_NETDMA     0x8000000
> > > > > > >  #define MSG_FASTOPEN   0x20000000      /* Send data in TCP SYN */
> > > > > > >  #define MSG_CMSG_CLOEXEC 0x40000000    /* Set close_on_exec for file
> > > > > > >                                            descriptor received through
> > > > > > > diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> > > > > > > index 261c28ccc8f6..340ce319edc9 100644
> > > > > > > --- a/net/ipv4/tcp.c
> > > > > > > +++ b/net/ipv4/tcp.c
> > > > > > > @@ -1214,6 +1214,14 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
> > > > > > >                         uarg->zerocopy = 0;
> > > > > > >         }
> > > > > > >
> > > > > > > +       if (flags & MSG_NETDMA && size && sock_flag(sk, SOCK_ZEROCOPY)) {
> > > > > > > +               zc = sk->sk_route_caps & NETIF_F_SG;
> > > > > > > +               if (!zc) {
> > > > > > > +                       err = -EFAULT;
> > > > > > > +                       goto out_err;
> > > > > > > +               }
> > > > > > > +       }
> > > > > > >
> > > > > >
> > > > > > Sorry, no, we can not allow adding yet another branch into TCP fast
> > > > > > path for yet another variant of zero copy.
> > > > >
> > > > > I'm not in disagreement with that statement, but the existing zerocopy
> > > > > work makes some assumptions that aren't suitable.  I take it that you'd
> > > > > rather have things folded together so the old/new code works together?
> > > >
> > > > Exact.  Forcing users to use MSG_NETDMA, yet reusing SOCK_ZEROCOPY is silly.
> > > >
> > > > SOCK_ZEROCOPY has been added to that user space and kernel would agree
> > > > on MSG_ZEROCOPY being not a nop (as it was on old kernels)
> > > >
> > > > >
> > > > > Allocating an extra structure for every skbuff isn't ideal in my book.
> > > > >
> > > >
> > > > We do not allocate a structure for every skbuff. Please look again.
> > >
> > > I'm looking here:
> > >
> > >     uarg = sock_zerocopy_realloc(sk, size, skb_zcopy(skb));
> > >
> > > Doesn't sock_zerocopy_realloc() allocate a new structure if the skb
> > > doesn't have one already?
> > >
> > >
> > > > > > Overall, I think your patch series desperately tries to add changes in
> > > > > > TCP stack, while there is yet no proof
> > > > > > that you have to use TCP transport between the peers.
> > > > >
> > > > > The goal is having a reliable transport without resorting to RDMA.
> > > >
> > > > And why should it be TCP ?
> > > >
> > > > Are you dealing with lost packets, retransmits, timers, and al  ?
> > >
> > > Yes?  If there was a true lossless medium, RDMA would have taken over by
> > > now.  Or are you suggesting that the transport protocol reliability
> > > should be performed in userspace?  (not all the world is QUIC yet)
> > >
> >
> > The thing is : this patch series is a monster thing adding stuff that
> > is going to impact 100% % of TCP flows,
> > even if not used in this NETDMA context.
> >
> > So you need to convince us you are really desperate to get this in
> > upstream linux.
> >
> > I have implemented TCP RX zero copy without adding a single line in
> > standard TCP code.
>
> That's a bit of an exaggeration, as I see skb_zcopy_*() calls scattered
> around the normal TCP code path.  I also haven't changed the normal TCP
> path either, other than doing some of the same things as skb_zcopy_*().
> (ignoring the ugly moron about padding out the TCP header, which I'll
> put under a static_branch_unlikely).


You are mixing TX zerocopy and RX zero copy.  Quite different things.

My claim was about TCP RX zero copy (aka tcp_zerocopy_receive())


>
> The thing is, the existing zero copy code is zero-copy to /host/ memory,
> which is not the same thing as zero-copy to other memory areas.

You have to really explain what difference it makes, and why current
stuff can not be extended.
