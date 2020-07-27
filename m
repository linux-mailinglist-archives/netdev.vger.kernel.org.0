Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8DAC22F6F0
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 19:45:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728544AbgG0RpM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 13:45:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728109AbgG0RpL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 13:45:11 -0400
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 976E4C061794
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 10:45:11 -0700 (PDT)
Received: by mail-yb1-xb42.google.com with SMTP id q16so6980193ybk.6
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 10:45:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Yq9rBReWG8QgEUMHNkCsJGNwDUvv1J/8qy0dNygLwoA=;
        b=BvfMStzrafWvrjeSoN74/VvcEpwBHS0kVOyuQUq3pdvMQlDYmU0TqW5WCb7kxs9Q4Q
         t3iing9gnC3jRdlSTTAHD0N4P2HQcJsBg2prrfAohVUgjjqHnl9qVGoLBNZbsKhMOEYG
         p18+wVFmw+edkPFH/esJKb5hZudkt5hmgfK8wv7XflsseK8V13iI2j5J3wER7K4ZHU9a
         P5eHEx1CKF3LYJkC6o8YJbX9wkGTTPZhvTTYBh5yzHuTJKwBetBCNQSTs3zwjyM2uf3U
         lBffwa9C1YpyCP3Gfc4nH3UrONto+vv1Uu3DUJfsKZ7/+OWcE+Ch4NWEQzwMAycnAowL
         0d6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Yq9rBReWG8QgEUMHNkCsJGNwDUvv1J/8qy0dNygLwoA=;
        b=qc9EmY8IwjOkNy6f7F646ggPzZA++T8vaPwzJtgPkL/EHTkg3CITrlzVdCBuzX0jzr
         TTw230kvogDdJvnQuRPUG93Fn9IKxDROaFFEa0fOz+SnXejI4DNBBikc0TqXd2AWkzVu
         ql1xTRAScLpyCLDNRZ48y8MRpZoSltZxzFGC92l6Jr6AaQieqjTZKJrvNRzOBs6M3vwC
         Lt4BQtfGI+QGSj94t/lXjnT8B2ifO3a14YWeqp0FgD92GpzL1pJwakk+0JMnPAiyyHkz
         LzYTnnMFUUOJ/JfsmycOEP5oJ4JUGwogUQJ/Mr8gOlqOytvRmxr+Qvg1DOkukBU09KFu
         NEkg==
X-Gm-Message-State: AOAM530QUfy/Ccjs7X/2u6VYAfprRKcJBCfrve8DAsCLweK7v4oE/P+p
        3B1OCMD+YSeLEReKN+rKKkZS+7nBjcCbyRni07vz2BIo
X-Google-Smtp-Source: ABdhPJwArcp8R3o5u+2HIr7wgCEJK94H8+a1qVZFiUmk2TW5MH2GIqJhWg85x3cWyx0mUzRDHXaA7D7G7TMmmueHI6E=
X-Received: by 2002:a25:4b01:: with SMTP id y1mr32785517yba.395.1595871910384;
 Mon, 27 Jul 2020 10:45:10 -0700 (PDT)
MIME-Version: 1.0
References: <20200727052846.4070247-1-jonathan.lemon@gmail.com>
 <20200727052846.4070247-16-jonathan.lemon@gmail.com> <CANn89iJ5vyx0WqdKTB3uHaWJrG-3jNXqXs6r7PacSqg0jRsRKA@mail.gmail.com>
 <20200727155549.gbwosugbugknsneo@bsd-mbp.dhcp.thefacebook.com>
 <CANn89iKY27R=ryQLohFPWa9dr6R9dMgB-hj+9eJO6H4NqfVKVw@mail.gmail.com> <20200727173528.tfsrweswpyjxlqv6@bsd-mbp.dhcp.thefacebook.com>
In-Reply-To: <20200727173528.tfsrweswpyjxlqv6@bsd-mbp.dhcp.thefacebook.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 27 Jul 2020 10:44:59 -0700
Message-ID: <CANn89iKStB8=Exyopi1sufuYhA-rZvYVMOEm9LDgKTLBYiqSmA@mail.gmail.com>
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

On Mon, Jul 27, 2020 at 10:35 AM Jonathan Lemon
<jonathan.lemon@gmail.com> wrote:
>
> On Mon, Jul 27, 2020 at 09:09:48AM -0700, Eric Dumazet wrote:
> > On Mon, Jul 27, 2020 at 8:56 AM Jonathan Lemon <jonathan.lemon@gmail.com> wrote:
> > >
> > > On Mon, Jul 27, 2020 at 08:19:43AM -0700, Eric Dumazet wrote:
> > > > On Mon, Jul 27, 2020 at 12:51 AM Jonathan Lemon
> > > > <jonathan.lemon@gmail.com> wrote:
> > > > >
> > > > > This flag indicates that the attached data is a zero-copy send,
> > > > > and the pages should be retrieved from the netgpu module.  The
> > > > > socket should should already have been attached to a netgpu queue.
> > > > >
> > > > > Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
> > > > > ---
> > > > >  include/linux/socket.h | 1 +
> > > > >  net/ipv4/tcp.c         | 8 ++++++++
> > > > >  2 files changed, 9 insertions(+)
> > > > >
> > > > > diff --git a/include/linux/socket.h b/include/linux/socket.h
> > > > > index 04d2bc97f497..63816cc25dee 100644
> > > > > --- a/include/linux/socket.h
> > > > > +++ b/include/linux/socket.h
> > > > > @@ -310,6 +310,7 @@ struct ucred {
> > > > >                                           */
> > > > >
> > > > >  #define MSG_ZEROCOPY   0x4000000       /* Use user data in kernel path */
> > > > > +#define MSG_NETDMA     0x8000000
> > > > >  #define MSG_FASTOPEN   0x20000000      /* Send data in TCP SYN */
> > > > >  #define MSG_CMSG_CLOEXEC 0x40000000    /* Set close_on_exec for file
> > > > >                                            descriptor received through
> > > > > diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> > > > > index 261c28ccc8f6..340ce319edc9 100644
> > > > > --- a/net/ipv4/tcp.c
> > > > > +++ b/net/ipv4/tcp.c
> > > > > @@ -1214,6 +1214,14 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
> > > > >                         uarg->zerocopy = 0;
> > > > >         }
> > > > >
> > > > > +       if (flags & MSG_NETDMA && size && sock_flag(sk, SOCK_ZEROCOPY)) {
> > > > > +               zc = sk->sk_route_caps & NETIF_F_SG;
> > > > > +               if (!zc) {
> > > > > +                       err = -EFAULT;
> > > > > +                       goto out_err;
> > > > > +               }
> > > > > +       }
> > > > >
> > > >
> > > > Sorry, no, we can not allow adding yet another branch into TCP fast
> > > > path for yet another variant of zero copy.
> > >
> > > I'm not in disagreement with that statement, but the existing zerocopy
> > > work makes some assumptions that aren't suitable.  I take it that you'd
> > > rather have things folded together so the old/new code works together?
> >
> > Exact.  Forcing users to use MSG_NETDMA, yet reusing SOCK_ZEROCOPY is silly.
> >
> > SOCK_ZEROCOPY has been added to that user space and kernel would agree
> > on MSG_ZEROCOPY being not a nop (as it was on old kernels)
> >
> > >
> > > Allocating an extra structure for every skbuff isn't ideal in my book.
> > >
> >
> > We do not allocate a structure for every skbuff. Please look again.
>
> I'm looking here:
>
>     uarg = sock_zerocopy_realloc(sk, size, skb_zcopy(skb));
>
> Doesn't sock_zerocopy_realloc() allocate a new structure if the skb
> doesn't have one already?
>
>
> > > > Overall, I think your patch series desperately tries to add changes in
> > > > TCP stack, while there is yet no proof
> > > > that you have to use TCP transport between the peers.
> > >
> > > The goal is having a reliable transport without resorting to RDMA.
> >
> > And why should it be TCP ?
> >
> > Are you dealing with lost packets, retransmits, timers, and al  ?
>
> Yes?  If there was a true lossless medium, RDMA would have taken over by
> now.  Or are you suggesting that the transport protocol reliability
> should be performed in userspace?  (not all the world is QUIC yet)
>

The thing is : this patch series is a monster thing adding stuff that
is going to impact 100% % of TCP flows,
even if not used in this NETDMA context.

So you need to convince us you are really desperate to get this in
upstream linux.

I have implemented TCP RX zero copy without adding a single line in
standard TCP code.
