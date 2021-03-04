Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 598F832DBB3
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 22:23:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234967AbhCDVVu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Mar 2021 16:21:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234752AbhCDVVo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Mar 2021 16:21:44 -0500
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF40CC061574
        for <netdev@vger.kernel.org>; Thu,  4 Mar 2021 13:21:03 -0800 (PST)
Received: by mail-yb1-xb35.google.com with SMTP id 133so30078206ybd.5
        for <netdev@vger.kernel.org>; Thu, 04 Mar 2021 13:21:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lsdghDki9hhDhRlbf23xs6TUJyCyz2x1CSRFC0tm9hA=;
        b=mzAXE7wAFI3Tv8n0oSFDxMuEJUqODolyHbYqv8PVXKKh8trVQrL/A23R6OgXCB466C
         GlNz2v2jb5hcibgK1SD7eXUTu1+HG7/BiQTVZFlUnvpuIXP3G2ZFgXiXUzf2Df9z4pZY
         n++Plb0ft3BdcSpAS6PLdtDw8mcG+0iv/3CkV8pUK6w0tMpPJlq+4F/CRMS+k1McRiQx
         qwfYBE2EwFqJN8SJ4RW41O4DWE31A5CJt8u5C9kQC/PxXhrtrFlfzvrFgF2dNhzgBmKy
         hz6A8pKGQgNNJ2PNZSm94DgITnT10eyVgwW25frFDumgf6IEqeBfDCdDFp5racywi6tL
         jl6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lsdghDki9hhDhRlbf23xs6TUJyCyz2x1CSRFC0tm9hA=;
        b=sPykhrBe4KcQjf3iJ90lvpogBKoBdTDC2yb+5z4b2zmbGWdrF8Mvgvh6YzHzsAjLxx
         oEMncN84TnMGj2C481mD+UTiwuAUHyYkevcB+gOpLZduI6ZTQ0n2pby5Hbh6iyBgIGAl
         jRSBGPEVbQvJxRrFLblwOAJM+eAFXsKmPpTHxHY9bifX3GH72DswrPwEOc3WiXGIZzEs
         KdQDJCf+yZGrkstSCQRqRxPIdimZBFbUkYkigm+4h6z6DrEnNNGBA5A6+NlrvOfxmog1
         z5RdS0KzcSfoatfiv6TsR1KbJYujwX05E47hDYbYWJurwhHEYE21oReIB9K1MPyXUVAg
         Jwag==
X-Gm-Message-State: AOAM530nj8TpfRuOVlcbrdU3ko98tE7VWP4k1zWDmsl92rl3EpYtz7Pl
        us+q799tuOEoQ0Ac9xqwIOOX7gmCLngFGKaKOIsQJg==
X-Google-Smtp-Source: ABdhPJwypZnlKfwhmzKi9M0R3nzBUCxyVO37GM8bNzdYmO+mw4wclQLp/65wySROl2geuDoXZO7AHw5ddX0CeaKElpU=
X-Received: by 2002:a25:ac52:: with SMTP id r18mr9377674ybd.303.1614892862800;
 Thu, 04 Mar 2021 13:21:02 -0800 (PST)
MIME-Version: 1.0
References: <20210302060753.953931-1-kuba@kernel.org> <CANn89iLaQuCGeWOh7Hp8X9dL09FhPP8Nwj+zV=rhYX7Cq7efpg@mail.gmail.com>
 <CAKgT0UdXiFBW9oDwvsFPe_ZoGveHLGh6RXf55jaL6kOYPEh0Hg@mail.gmail.com>
 <20210303160715.2333d0ca@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAKgT0Ue9w4WBojY94g3kcLaQrVbVk6S-HgsFgLVXoqsY20hwuw@mail.gmail.com>
 <CANn89iL9fBKDQvAM0mTnh_B5ggmsebDBYxM6WAfYgMuD8-vcBw@mail.gmail.com>
 <20210304110626.1575f7aa@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CANn89i+cXQXP-7ioizFy90Dj-1SfjA0MQfwvDChxVXQ3wbTjFA@mail.gmail.com> <20210304210836.bkpqwbvfpkd5fagg@bsd-mbp.dhcp.thefacebook.com>
In-Reply-To: <20210304210836.bkpqwbvfpkd5fagg@bsd-mbp.dhcp.thefacebook.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 4 Mar 2021 22:20:51 +0100
Message-ID: <CANn89i+Sf66QknMO7+1gxowhV6g+Bs-DMhnvsvFx8vaqPfBVug@mail.gmail.com>
Subject: Re: [PATCH net] net: tcp: don't allocate fast clones for fastopen SYN
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        kernel-team <kernel-team@fb.com>, Neil Spring <ntspring@fb.com>,
        Yuchung Cheng <ycheng@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 4, 2021 at 10:08 PM Jonathan Lemon <jonathan.lemon@gmail.com> wrote:
>
> On Thu, Mar 04, 2021 at 08:41:45PM +0100, Eric Dumazet wrote:
> > On Thu, Mar 4, 2021 at 8:06 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > >
> > > On Thu, 4 Mar 2021 13:51:15 +0100 Eric Dumazet wrote:
> > > > I think we are over thinking this really (especially if the fix needs
> > > > a change in core networking or drivers)
> > > >
> > > > We can reuse TSQ logic to have a chance to recover when the clone is
> > > > eventually freed.
> > > > This will be more generic, not only for the SYN+data of FastOpen.
> > > >
> > > > Can you please test the following patch ?
> > >
> > > #7 - Eric comes up with something much better :)
> > >
> > >
> > > But so far doesn't seem to quite do it, I'm looking but maybe you'll
> > > know right away (FWIW testing a v5.6 backport but I don't think TSQ
> > > changed?):
> > >
> > > On __tcp_retransmit_skb kretprobe:
> > >
> > > ==> Hit TFO case ret:-16 ca_state:0 skb:ffff888fdb4bac00!
> > >
> > > First hit:
> > >         __tcp_retransmit_skb+1
> > >         tcp_rcv_state_process+2488
> > >         tcp_v6_do_rcv+405
> > >         tcp_v6_rcv+2984
> > >         ip6_protocol_deliver_rcu+180
> > >         ip6_input_finish+17
> > >
> > > Successful hit:
> > >         __tcp_retransmit_skb+1
> > >         tcp_retransmit_skb+18
> > >         tcp_retransmit_timer+716
> > >         tcp_write_timer_handler+136
> > >         tcp_write_timer+141
> > >         call_timer_fn+43
> > >
> > >  skb:ffff888fdb4bac00 --- delay:51642us bytes_acked:1
> >
> >
> > Humm maybe one of the conditions used in tcp_tsq_write() does not hold...
> >
> > if (tp->lost_out > tp->retrans_out &&
> >     tp->snd_cwnd > tcp_packets_in_flight(tp)) {
> >     tcp_mstamp_refresh(tp);
> >     tcp_xmit_retransmit_queue(sk);
> > }
> >
> > Maybe FastOpen case is 'special' and tp->lost_out is wrong.
>
>
> Something like this?  (completely untested)
> --
> Jonathan
>
> diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
> index 69a545db80d2..92bc9b0f4955 100644
> --- a/net/ipv4/tcp_input.c
> +++ b/net/ipv4/tcp_input.c
> @@ -5995,8 +5995,10 @@ static bool tcp_rcv_fastopen_synack(struct sock *sk, struct sk_buff *synack,
>                 else
>                         tp->fastopen_client_fail = TFO_DATA_NOT_ACKED;
>                 skb_rbtree_walk_from(data) {
> +                       tcp_mark_skb_lost(sk, data);
>                         if (__tcp_retransmit_skb(sk, data, 1))
>                                 break;
> +                       tp->retrans_out += tcp_skb_pcount(data);
>                 }
>                 tcp_rearm_rto(sk);
>                 NET_INC_STATS(sock_net(sk),
>

Yes, but the hard part is testing this ;)

Once we properly mark the skb lost, we can call regular
tcp_xmit_retransmit_queue() to not have to care of tp->retrans_out

Not that we really need to make sure tcp_xmit_retransmit_queue() can
be called anyway from TSQ handler if TX completion is delayed.
