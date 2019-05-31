Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D150D31758
	for <lists+netdev@lfdr.de>; Sat,  1 Jun 2019 00:50:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726693AbfEaWu3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 18:50:29 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:41759 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726559AbfEaWu2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 18:50:28 -0400
Received: by mail-pf1-f196.google.com with SMTP id q17so7037994pfq.8
        for <netdev@vger.kernel.org>; Fri, 31 May 2019 15:50:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=e8qngvV6VVOHufQJ5FrppX8r6UpZqAeMVmy8EPzAb+4=;
        b=OPhky5OvMPNIHSfNQNC5upuJck8tk+9PGCQn/xvePZPt6eCdyJ1WkQsXnVU3BVbsNb
         +bEfrWKVlYNqBUPGxOtABVtYSL2yml9cQSNZQaTrIT95TEzr85BroBk7vOuN1APGrM9s
         Pe7GZEKfqo/9znysdfkoKfpf58eReQCv/PGwHEe1mOm3r/H0EFZTze6cf8zbSG7YvnQu
         IE31Rs1sciX2XMAXNGHJuQ9za7BzisdNdpCAIjAjD2pBj2f2QbCbRERBtUhmk3T7u+qS
         6CDAHv9Ti8vdf3zEmvv8gi/mdK2dhajtuneJuG+GjJz8KqhX7qd0vGBq4WosjGBA07GO
         4s6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=e8qngvV6VVOHufQJ5FrppX8r6UpZqAeMVmy8EPzAb+4=;
        b=e3Q0UbDDz+YirOt70SbFaV1m+StHqHkrKECH4Z6QlXDVWgUUCZvnu3holoqu9XkAIs
         9rjKXhdb9arbdPt1yvBshKCZOFf2Fkn4WrpXGzZXj4GCD5vXjg6jqW/BzGEvK/igCSUK
         iom7CBmb5OPv9UEKTfmuw4yXeULDG49pJoB9Le9GxbiGhhV9X+RrqPZkcVi3Y/2aI/iU
         BXmwYP62FOGGOz6nJ0dMM4T+l0XvgVcCPKcHNLAr3IpPztoN0J5ELhHzQhrg44FX//JM
         WeHtHDjP4jWfBL7GJ7L0cDuNu7QfUqo+AhtcmcLcZqUbLin7OVIxg80rtGHFUopw7zx4
         erbQ==
X-Gm-Message-State: APjAAAVX/rEbhMh4K4Lmam0siIDqTChIpR420qxq9t2QObxLEY6WYr1Z
        10TDdHIfzxt39PhIin32Qee84lPb8siJvKYCfec=
X-Google-Smtp-Source: APXvYqzSP4OMcesdlxb/jBbdcohxctTvQ65UOrKrw+8Rc1If7JBT9gR/i+VeTUJ8xtOV+SqbDb8VfiGz7dqn+7KCZRU=
X-Received: by 2002:a63:1d05:: with SMTP id d5mr11769082pgd.157.1559343028160;
 Fri, 31 May 2019 15:50:28 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1559322531.git.dcaratti@redhat.com> <a773fd1d70707d03861be674f7692a0148f6bb40.1559322531.git.dcaratti@redhat.com>
 <CAM_iQpW68XR3Y6gyb0zyd3qooCwPHBM1Fm+THcS=migSNsHMzA@mail.gmail.com> <e2e02404af5aea5663877db8f9d2e23501e818b8.camel@redhat.com>
In-Reply-To: <e2e02404af5aea5663877db8f9d2e23501e818b8.camel@redhat.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Fri, 31 May 2019 15:50:16 -0700
Message-ID: <CAM_iQpURD5Yvr1BwfbTBDbbJdATGSK5PWD7jfP4=NGdgTGnnJw@mail.gmail.com>
Subject: Re: [PATCH net v3 1/3] net/sched: act_csum: pull all VLAN headers
 before checksumming
To:     Davide Caratti <dcaratti@redhat.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        "David S . Miller" <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Shuang Li <shuali@redhat.com>,
        Eli Britstein <elibr@mellanox.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 31, 2019 at 3:01 PM Davide Caratti <dcaratti@redhat.com> wrote:
>
> Please note: this loop was here also before this patch (the 'goto again;'
> line is only patch context). It has been introduced with commit
> 2ecba2d1e45b ("net: sched: act_csum: Fix csum calc for tagged packets").
>

This is exactly why I ask...


> > Why do you still need to loop here? tc_skb_pull_vlans() already
> > contains a loop to pop all vlan tags?
>
> The reason why the loop is here is:
> 1) in case there is a stripped vlan tag, it replaces tc_skb_protocol(skb)
> with the inner ethertype (i.e. skb->protocol)
>
> 2) in case there is one or more unstripped VLAN tags, it pulls them. At
> the last iteration, when it does:

Let me ask it in another way:

The original code, without your patch, has a loop (the "goto again") to
pop all vlan tags.

The code with your patch adds yet another loop (the while loop inside your
tc_skb_pull_vlans()) to pop all vlan tags.

So, after your patch, we have both loops. So, I am confused why we need
these two nested loops to just pop all vlan tags? I think one is sufficient.


>
> >
> > >         }
> > >
> > > diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
> > > index d4699156974a..382ee69fb1a5 100644
> > > --- a/net/sched/cls_api.c
> > > +++ b/net/sched/cls_api.c
> > > @@ -3300,6 +3300,28 @@ unsigned int tcf_exts_num_actions(struct tcf_exts *exts)
> > >  }
> > >  EXPORT_SYMBOL(tcf_exts_num_actions);
> > >
> > > +int tc_skb_pull_vlans(struct sk_buff *skb, unsigned int *hdr_count,
> > > +                     __be16 *proto)
> >
> > It looks like this function fits better in net/core/skbuff.c, because
> > I don't see anything TC specific.
>
> Ok, I don't know if other parts of the kernel really need it. Its use
> should be combined with tc_skb_protocol(), which is in pkt_sched.h.
>
> But i can move it to skbuff, or elsewhwere, unless somebody disagrees.
>
> >
> > > +{
> > > +       if (skb_vlan_tag_present(skb))
> > > +               *proto = skb->protocol;
> > > +
> > > +       while (eth_type_vlan(*proto)) {
> > > +               struct vlan_hdr *vlan;
> > > +
> > > +               if (unlikely(!pskb_may_pull(skb, VLAN_HLEN)))
> > > +                       return -ENOMEM;
> > > +
> > > +               vlan = (struct vlan_hdr *)skb->data;
> > > +               *proto = vlan->h_vlan_encapsulated_proto;
> > > +               skb_pull(skb, VLAN_HLEN);
> > > +               skb_reset_network_header(skb);
>
> Again, this code was in act_csum.c also before. The only intention of this
> patch is to ensure that pskb_may_pull() is called before skb_pull(), as
> per Eric suggestion, and move this code out of act_csum to use it with
> other TC actions.

Sure, no one says the code before yours is more correct, right? :)

>
> > Any reason not to call __skb_vlan_pop() directly?
>
> I think we can't use __skb_vlan_pop(), because 'act_csum' needs to read
> the innermost ethertype in the packet to understand if it's IPv4, IPv6 or
> else (ARP, EAPOL, ...).
>
> If I well read __skb_vlan_pop(), it returns the VLAN ID, which is useless
> here.
>

I am confused, this could be checked by eth_type_vlan(skb->protocol),
right? So why it stops you from considering __skb_vlan_pop() or
skb_vlan_pop()? They both should return error or zero, not vlan ID.

Thanks.
