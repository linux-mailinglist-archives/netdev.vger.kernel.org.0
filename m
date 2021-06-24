Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 002373B3423
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 18:46:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231621AbhFXQsS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 12:48:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229573AbhFXQsR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Jun 2021 12:48:17 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97197C061574
        for <netdev@vger.kernel.org>; Thu, 24 Jun 2021 09:45:57 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id h2so9508884edt.3
        for <netdev@vger.kernel.org>; Thu, 24 Jun 2021 09:45:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Vcn4MD2pRAA0lgAFSEfLlj1uV+tCcMgRXd/77kPT+1w=;
        b=pvsghrYvoYasa5ZHFS2+hh0jfbKoNIKZ92We4E7+LRnOzMDZRJiPvwlYGZerQ6PWr0
         mZHk8qZiwpBrncrdahVGigCNpRrcgGm4K7yT3xww5BhIILTtFWOou/n9V+PcXP3euA15
         7DFb5+qZRjI2L9iy6tMLq8OQSYN9cX3dRzu4OmrGNR7GE9tPjCm0j+BMytke+x7hbVMA
         NLoY/bZqPK6J+DE6Hjnc0rc343UtJ2bCeMRtJ1EIqtRkPMvNBNiQCAxzDXtSIbyFyJfn
         +LQOnPgpdbVN0lsLf9KmcYo1ZBbS8LyMQft/JN4gnkN6nn5gfWxL5tCEO4HwwloOwktS
         EU1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Vcn4MD2pRAA0lgAFSEfLlj1uV+tCcMgRXd/77kPT+1w=;
        b=Bf9wkdt0eRcSN2w6RAl3fDZsh84iiJSIK8qUispbHGi/NZNuyiT6YCwXsz+x/GnuOb
         0AhDlK246Rl6u8Nor53JgdEJRvMAcl/mytZZPeOwG7uafnxx6qcPVShUB7VDPI4dkV4D
         Lt6J3bkh0vwlonc27I2yCYGE8Y+u9bH+uuL1bIDnT9pYqWez4nJNOn88QlJE68gbj/ji
         xQ2f/Q5HLp4fILTkRkEiI86cKs7RUKnL1dqKVLYJS+EMfRA7NaqCS6c2c1jcCGoHjrsb
         LLx8ld5Wu8+HyNd2P/qVYq5qZPhky60R3Z6rEuu2lCMfXkvkRXU1DCHYmEMnsJiVRa6f
         2T1Q==
X-Gm-Message-State: AOAM5307J2SH7yhGqXkaa/Hlc0CNpCsnlzvrRn/2IIH47VJw9zAH2G3B
        GVlSw26ltxTGVWb9Myl3OsBeIPZo+BfFXA==
X-Google-Smtp-Source: ABdhPJyS66GnqonUp567PRnBpHyaQIO7MtuYdxkOgJEojtPtisaNbksb6wIOkhPAwmBZGS/rIOIFPA==
X-Received: by 2002:a05:6402:3581:: with SMTP id y1mr8466448edc.31.1624553156168;
        Thu, 24 Jun 2021 09:45:56 -0700 (PDT)
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com. [209.85.128.45])
        by smtp.gmail.com with ESMTPSA id p5sm1445205ejm.115.2021.06.24.09.45.55
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Jun 2021 09:45:55 -0700 (PDT)
Received: by mail-wm1-f45.google.com with SMTP id l21-20020a05600c1d15b02901e7513b02dbso1305269wms.2
        for <netdev@vger.kernel.org>; Thu, 24 Jun 2021 09:45:55 -0700 (PDT)
X-Received: by 2002:a7b:c104:: with SMTP id w4mr5387457wmi.87.1624553154909;
 Thu, 24 Jun 2021 09:45:54 -0700 (PDT)
MIME-Version: 1.0
References: <20210623214438.2276538-1-kuba@kernel.org> <CA+FuTSergCOgmYCGzT4vrYfoBB_vk-SwF45z2_XEBXNbyHvGUQ@mail.gmail.com>
 <20210624092824.7d7103a1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210624092824.7d7103a1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Thu, 24 Jun 2021 12:45:18 -0400
X-Gmail-Original-Message-ID: <CA+FuTSdoP37qsk0mCvhmiVOGwXtXEktKfcR2PMSEcTQtRBrv7A@mail.gmail.com>
Message-ID: <CA+FuTSdoP37qsk0mCvhmiVOGwXtXEktKfcR2PMSEcTQtRBrv7A@mail.gmail.com>
Subject: Re: [PATCH net-next v4] net: ip: avoid OOM kills with large UDP sends
 over loopback
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        davem@davemloft.net, netdev@vger.kernel.org,
        eric.dumazet@gmail.com, dsahern@gmail.com, yoshfuji@linux-ipv6.org,
        brouer@redhat.com, Dave Jones <dsj@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 24, 2021 at 12:28 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Wed, 23 Jun 2021 22:21:11 -0400 Willem de Bruijn wrote:
> > On Wed, Jun 23, 2021 at 5:44 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > >
> > > Dave observed number of machines hitting OOM on the UDP send
> > > path. The workload seems to be sending large UDP packets over
> > > loopback. Since loopback has MTU of 64k kernel will try to
> > > allocate an skb with up to 64k of head space. This has a good
> > > chance of failing under memory pressure. What's worse if
> > > the message length is <32k the allocation may trigger an
> > > OOM killer.
> > >
> > > This is entirely avoidable, we can use an skb with page frags.
> > >
> > > af_unix solves a similar problem by limiting the head
> > > length to SKB_MAX_ALLOC. This seems like a good and simple
> > > approach. It means that UDP messages > 16kB will now
> > > use fragments if underlying device supports SG, if extra
> > > allocator pressure causes regressions in real workloads
> > > we can switch to trying the large allocation first and
> > > falling back.
> > >
> > > v4: pre-calculate all the additions to alloclen so
> > >     we can be sure it won't go over order-2
> > >
> > > Reported-by: Dave Jones <dsj@fb.com>
> > > Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> > > ---
> > >  net/ipv4/ip_output.c  | 32 ++++++++++++++++++--------------
> > >  net/ipv6/ip6_output.c | 32 +++++++++++++++++---------------
> > >  2 files changed, 35 insertions(+), 29 deletions(-)
> > >
> > > diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
> > > index c3efc7d658f6..8d8a8da3ae7e 100644
> > > --- a/net/ipv4/ip_output.c
> > > +++ b/net/ipv4/ip_output.c
> > > @@ -1054,7 +1054,7 @@ static int __ip_append_data(struct sock *sk,
> > >                         unsigned int datalen;
> > >                         unsigned int fraglen;
> > >                         unsigned int fraggap;
> > > -                       unsigned int alloclen;
> > > +                       unsigned int alloclen, alloc_extra;
> >
> > Separate line?
>
> But why? What makes it preferable to have logically connected variables
> declared on separate lines? The function is already 300 LoC. I've been
> meaning to ask someone about this preference for a while :)

Reverse christmas tree is the norm in netdev. Pointing out for
consistency only. I have no particular opinion on the rule.

Agreed that in this function, multiple entries per line would be preferable.


> > >                         unsigned int pagedlen;
> > >                         struct sk_buff *skb_prev;
> > >  alloc_new_skb:
> > > @@ -1074,35 +1074,39 @@ static int __ip_append_data(struct sock *sk,
> > >                         fraglen = datalen + fragheaderlen;
> > >                         pagedlen = 0;
> > >
> > > +                       alloc_extra = hh_len + 15;
> > > +                       alloc_extra += exthdrlen;
> > > +
> > > +                       /* The last fragment gets additional space at tail.
> > > +                        * Note, with MSG_MORE we overallocate on fragments,
> > > +                        * because we have no idea what fragment will be
> > > +                        * the last.
> > > +                        */
> > > +                       if (datalen == length + fraggap)
> > > +                               alloc_extra += rt->dst.trailer_len;
> > > +
> > >                         if ((flags & MSG_MORE) &&
> > >                             !(rt->dst.dev->features&NETIF_F_SG))
> > >                                 alloclen = mtu;
> > > -                       else if (!paged)
> > > +                       else if (!paged &&
> > > +                                (fraglen + alloc_extra < SKB_MAX_ALLOC ||
> > > +                                 !(rt->dst.dev->features & NETIF_F_SG)))
> >
> > This perhaps deserves a comment. Something like this?
> >
> >   /* avoid order-3 allocations where possible: replace with frags if
> > allowed (sg) */
>
> Here I thought comparing skb alloc size to SKB_MAX_ALLOC is explanatory
> enough ;)

Yeah, I guess you're right. The comment only rewords *what* the code
does, so not super informative. Never mind that suggestion.

> In the middle of the test, like this, right?
>
>                  else if (!paged &&
>                           /* avoid order-3 allocations if device
>                            * can handle skb frags (sg)
>                            */
>                           (fraglen + alloc_extra < SKB_MAX_ALLOC ||
>                           !(rt->dst.dev->features & NETIF_F_SG)))
>
> I should make it less-equal while at it.
>
> > >                                 alloclen = fraglen;
> > >                         else {
> > >                                 alloclen = min_t(int, fraglen, MAX_HEADER);
> > >                                 pagedlen = fraglen - alloclen;
> > >                         }
> > >
> > > -                       alloclen += exthdrlen;
> > > -
> > > -                       /* The last fragment gets additional space at tail.
> > > -                        * Note, with MSG_MORE we overallocate on fragments,
> > > -                        * because we have no idea what fragment will be
> > > -                        * the last.
> > > -                        */
> > > -                       if (datalen == length + fraggap)
> > > -                               alloclen += rt->dst.trailer_len;
> > > +                       alloclen += alloc_extra;
> > >
> > >                         if (transhdrlen) {
> > > -                               skb = sock_alloc_send_skb(sk,
> > > -                                               alloclen + hh_len + 15,
> > > +                               skb = sock_alloc_send_skb(sk, alloclen,
> > >                                                 (flags & MSG_DONTWAIT), &err);
> > >                         } else {
> > >                                 skb = NULL;
> > >                                 if (refcount_read(&sk->sk_wmem_alloc) + wmem_alloc_delta <=
> > >                                     2 * sk->sk_sndbuf)
> > > -                                       skb = alloc_skb(alloclen + hh_len + 15,
> > > +                                       skb = alloc_skb(alloclen,
> > >                                                         sk->sk_allocation);
> > >                                 if (unlikely(!skb))
> > >                                         err = -ENOBUFS;
> >
> > Is there any risk of regressions? If so, would it be preferable to try
> > regular alloc and only on failure, just below here, do the size and SG
> > test and if permitted jump back to the last of the three alloc_len
> > options?
>
> There is, that's what I tried in v1, Eric pointed out that we can't
> modify sk->sk_allocation here because UDP fast path doesn't take the
> lock, and pointed out that UNIX code has to handle similar problem.
> So I decided to just copy what AF_UNIX does. In practical terms
> MTU > 16k is highly unlikely on physical devices (AFAIK) and with
> messages that large hopefully the trip thru the memory allocator won't
> be all that noticeable? If we were capping at one page that'd be a
> problem, but my gut feeling was that order-2 cap is unlikely to hurt.
>
> But I can go back, I'd have to refactor sock_alloc_send_pskb() to pass
> gfp_t explicitly. Probably by creating another layer of helpers
> (__sock_alloc_send_pskb()?). sock_alloc_send_pskb() already takes 6
> params so I was also thinking of converting it to ERR_PTR() return
> (instead of passing the error pointer) (6 is max for register passing).
>
> Should I go back to retry?

For __GFP_NOWARN? Sorry, I missed that.

Okay, then I understand why this approach is preferable. And LGTM. Thanks!
