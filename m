Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0976CD3C38
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 11:26:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727672AbfJKJ0N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Oct 2019 05:26:13 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:38816 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726743AbfJKJ0N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Oct 2019 05:26:13 -0400
Received: by mail-io1-f67.google.com with SMTP id u8so20077409iom.5
        for <netdev@vger.kernel.org>; Fri, 11 Oct 2019 02:26:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tTtjrHibeyjoGiV6wrfY7RjQnY0J5mQG7mk4KWfvS78=;
        b=OXNBEvMLx0S3FM3bwV5+//LWkXe5tRVHo9Pcn5BgLS1aFtYJ9PL7QND2rMEcwAKNWr
         77G9oSVMfaNJ2NIJusqcV8Ojn1bL2JUWuyS8fmveamFH4U/ueAtBuaQHbwyhdzxpPjWp
         8wk4TRaNFOkyU6wnZiSf5fruVqv6A7qos3jhCsNMF0f/2uoyHKoSf7IhzyPybs2LbLTM
         CUP7XQ0QNHQ+6SrIAu8CrbV2tjhV+L3B3/qlVRGuEykd00Zpp82eKvF2AarGVFnrLfaS
         Tu2na17lqtSkRW941Li9rtnghZGtEBAUpKC4/JBRuvC/1tm69T4gQaWNciPmYh7Ldesq
         totg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tTtjrHibeyjoGiV6wrfY7RjQnY0J5mQG7mk4KWfvS78=;
        b=bdqMu706B0WykZxtcGC+ikIGYQR3C2U6a6hK0hcW3dZqnTSiXPMRKXHnlfpNeAlO8Y
         MDb0nUDOTO8Dv5KWCkybvc7Y/lkgsAConV8BF/Ko3IHeM5tdO+fsL2FFGKJwFY+LGGYz
         7Hy6l/ZIDJno6thR1ynrRQLbpd0kQNGgSVsIowQlZ54BXgNs0WV+0MrnTzAojiVXPB8s
         Fj6RWtu7hhf8oB7WSNuoHqIGCht9CESnqo/wrYM6xZSguvh8wriGLSZm2Puz3Jt1/wW8
         uMWgULrFtZ1tgUOZ23hbKZYOob5BX4B7/+xY0avPUk62lXr4NrWkdKi7xIjfE5M6M2D3
         8TpA==
X-Gm-Message-State: APjAAAX/BGmldrtJy5vw5U0kqzvtCMWTqNIB5mKRJ/Qw9kDk5fN//mSW
        fnLDXw394N0ST6mBwvyMgxRf9TgaQ2idTAyMqVLe+KFX
X-Google-Smtp-Source: APXvYqyZj7rjIwWnhYVjauxHTLImydqcigrFmi6PwYBmGwy/+e1st/LpH5THp45LhbrE+Jt9dFStOt31YOvhR7LCI+A=
X-Received: by 2002:a5d:9c4b:: with SMTP id 11mr4880794iof.240.1570785972460;
 Fri, 11 Oct 2019 02:26:12 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1570732834.git.dcaratti@redhat.com> <9343e3ce8aed5d0e109ab0805fb452e8f55f0130.1570732834.git.dcaratti@redhat.com>
 <20191011073407.vvogkh53hm6hvb6h@netronome.com>
In-Reply-To: <20191011073407.vvogkh53hm6hvb6h@netronome.com>
From:   John Hurley <john.hurley@netronome.com>
Date:   Fri, 11 Oct 2019 10:26:01 +0100
Message-ID: <CAK+XE==VWnV+d7z321o50O1BZcHpS8aBNk-E3-Doe-gy2OUCrg@mail.gmail.com>
Subject: Re: [PATCH net 1/2] net: avoid errors when trying to pop MLPS header
 on non-MPLS packets
To:     Simon Horman <simon.horman@netronome.com>
Cc:     Davide Caratti <dcaratti@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Linux Netdev List <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 11, 2019 at 8:34 AM Simon Horman <simon.horman@netronome.com> wrote:
>
> On Thu, Oct 10, 2019 at 08:43:52PM +0200, Davide Caratti wrote:
> > the following script:
> >
> >  # tc qdisc add dev eth0 clsact
> >  # tc filter add dev eth0 egress matchall action mpls pop
> >
> > implicitly makes the kernel drop all packets transmitted by eth0, if they
> > don't have a MPLS header. This behavior is uncommon: other encapsulations
> > (like VLAN) just let the packet pass unmodified. Since the result of MPLS
> > 'pop' operation would be the same regardless of the presence / absence of
> > MPLS header(s) in the original packet, we can let skb_mpls_pop() return 0
> > when dealing with non-MPLS packets.
> >
> > Fixes: 2a2ea50870ba ("net: sched: add mpls manipulation actions to TC")
> > Signed-off-by: Davide Caratti <dcaratti@redhat.com>
>

Acked-by: John Hurley <john.hurley@netronome.com>

> Hi Davide,
>
> For the TC use-case I think this is correct for the reasons you explain
> above.
>
> For the OVS use-case I also think it is fine because
> __ovs_nla_copy_actions() will ensure that MPLS POP only occurs
> for packets with an MPLS Ethernet protocol. That is, this condition
> should never occur in that use-case.
>
> And it appears that there are no other users of this function.
>
> I think it might be worth adding something about use-cases other than TC
> to the changelog, but that aside:
>
> Reviewed-by: Simon Horman <simon.horman@netronome.com>
>
> > ---
> >  net/core/skbuff.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> > index 529133611ea2..cd59ccd6da57 100644
> > --- a/net/core/skbuff.c
> > +++ b/net/core/skbuff.c
> > @@ -5536,7 +5536,7 @@ int skb_mpls_pop(struct sk_buff *skb, __be16 next_proto)
> >       int err;
> >
> >       if (unlikely(!eth_p_mpls(skb->protocol)))
> > -             return -EINVAL;
> > +             return 0;
> >
> >       err = skb_ensure_writable(skb, skb->mac_len + MPLS_HLEN);
> >       if (unlikely(err))
> > --
> > 2.21.0
> >
