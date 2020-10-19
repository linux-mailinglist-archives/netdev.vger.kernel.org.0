Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D66BB292183
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 05:55:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731706AbgJSDz1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Oct 2020 23:55:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731306AbgJSDz1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Oct 2020 23:55:27 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC75FC061755;
        Sun, 18 Oct 2020 20:55:26 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id i2so10390615ljg.4;
        Sun, 18 Oct 2020 20:55:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JGRhD4PEJkPED9SetcvHdpE4f5nhMr/c5YW65Q6YUlE=;
        b=bZKO7VCR4I4+1wjrFBmZMGZJByH62WFATFg4GFd9UJ3PoVJc61jcpktT837bgYflPH
         pPbcHo/EoNXIcaELhtfthGYs14cwBs5X7iWwQqfn4yTz9kT75biUXGTa+V491Jso3uOk
         AzounLT1cQiKiacmbmCeeQnjWVKEw5uehZnaumjcRWC7wPERdZ5G1RmwBnU4Z1MBBMjR
         2ZydHN7DYREUresYmd7CFGxSwrVswiBYIo60LsaJqBW6MolZvXx0gEAnISn5ChulmMWD
         D2HSB6kazz42AFlYeKiy5n9gSFh0JC7jJgRrU+opKX9e/soEbGOQdsGJnpuR0XWbBg8E
         tTqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JGRhD4PEJkPED9SetcvHdpE4f5nhMr/c5YW65Q6YUlE=;
        b=o4l25ftcfRf+7Ac4+HOYlxcMTpnXo8zBi7XsK7O+I8JCPs9Ss0B8jKkpSjdYn9Zq7f
         rWdPFwkg9vCwhN0O1KXgcSbppBjgkLSjl4GgSSkOGwJBFsExbtKjuUhAVxRy8FX0FE1F
         rKuXNDeDcylGKEmtxHCxBUtz1RFa5Q7AozJpc1nr7lARFtv0gvZdzSlbAPsW1GZIq5Zz
         OXNMLLF7nJbAn0On9BcV8EqgpXG87Vm8UZYgE7pTs273xe0g0W2R3ShOuU62RX0LpJXE
         qRlDHsTV78nzg5ECWtlOcWKC8HWp7VQ4ENGXHFW4GMzIKREYYTNHHZmRTA76/DNmj8cH
         zSYg==
X-Gm-Message-State: AOAM530xanLmumm7nPiSs1XCmN7GzDN0E1X3ltsLHXIu8QHPjZTKt8y3
        aSH03Bmsr2cx8bzIxZzAGZG2I2lghn94k9EN20PFJmx/cUo6
X-Google-Smtp-Source: ABdhPJyHm+0O32JklLtr5FJF0K/1T/HeWFTvyT0kyXME7dMRKYtreYmTbSuK6mwqOj05evXptiwtcym6EZ9dCEU7hsE=
X-Received: by 2002:a2e:8e72:: with SMTP id t18mr4948814ljk.445.1603079725084;
 Sun, 18 Oct 2020 20:55:25 -0700 (PDT)
MIME-Version: 1.0
References: <20201015082119.68287-1-rejithomas@juniper.net> <20201018160147.6b3c940a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201018160147.6b3c940a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Reji Thomas <rejithomas.d@gmail.com>
Date:   Mon, 19 Oct 2020 09:25:12 +0530
Message-ID: <CAA8Zg7Gcua1=6CgSkJ-z8uKJneDjedB4z6zm2a+DcYt-_YcmSQ@mail.gmail.com>
Subject: Re: [PATCH v2] IPv6: sr: Fix End.X nexthop to use oif.
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Reji Thomas <rejithomas@juniper.net>, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel test robot <lkp@intel.com>,
        Mathieu Xhonneux <m.xhonneux@gmail.com>,
        David Lebrun <david.lebrun@uclouvain.be>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Please find my replies inline below.

Regards
Reji

On Mon, Oct 19, 2020 at 4:31 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Thu, 15 Oct 2020 13:51:19 +0530 Reji Thomas wrote:
> > Currently End.X action doesn't consider the outgoing interface
> > while looking up the nexthop.This breaks packet path functionality
> > specifically while using link local address as the End.X nexthop.
> > The patch fixes this by enforcing End.X action to have both nh6 and
> > oif and using oif in lookup.It seems this is a day one issue.
> >
> > Fixes: 140f04c33bbc ("ipv6: sr: implement several seg6local actions")
> > Signed-off-by: Reji Thomas <rejithomas@juniper.net>
>
> David, Mathiey - any comments?
>
> > @@ -239,6 +250,8 @@ static int input_action_end(struct sk_buff *skb, struct seg6_local_lwt *slwt)
> >  static int input_action_end_x(struct sk_buff *skb, struct seg6_local_lwt *slwt)
> >  {
> >       struct ipv6_sr_hdr *srh;
> > +     struct net_device *odev;
> > +     struct net *net = dev_net(skb->dev);
>
> Order longest to shortest.
Sorry. Will fix it.

>
>
> >
> >       srh = get_and_validate_srh(skb);
> >       if (!srh)
> > @@ -246,7 +259,11 @@ static int input_action_end_x(struct sk_buff *skb, struct seg6_local_lwt *slwt)
> >
> >       advance_nextseg(srh, &ipv6_hdr(skb)->daddr);
> >
> > -     seg6_lookup_nexthop(skb, &slwt->nh6, 0);
> > +     odev = dev_get_by_index_rcu(net, slwt->oif);
> > +     if (!odev)
> > +             goto drop;
>
> Are you doing this lookup just to make sure that oif exists?
> Looks a little wasteful for fast path, but more importantly
> it won't be backward compatible, right? See below..
>
Please see reply below.

> > +
> > +     seg6_strict_lookup_nexthop(skb, &slwt->nh6, odev->ifindex, 0);
> >
> >       return dst_input(skb);
> >
>
> > @@ -566,7 +583,8 @@ static struct seg6_action_desc seg6_action_table[] = {
> >       },
> >       {
> >               .action         = SEG6_LOCAL_ACTION_END_X,
> > -             .attrs          = (1 << SEG6_LOCAL_NH6),
> > +             .attrs          = ((1 << SEG6_LOCAL_NH6) |
> > +                                (1 << SEG6_LOCAL_OIF)),
> >               .input          = input_action_end_x,
> >       },
> >       {
>
> If you set this parse_nla_action() will reject all
> SEG6_LOCAL_ACTION_END_X without OIF.
>
> As you say the OIF is only required for using link local addresses,
> so this change breaks perfectly legitimate configurations.
>
> Can we instead only warn about the missing OIF, and only do that when
> nh is link local?
>
End.X is defined as an adjacency-sid and is used to select a specific link to a
neighbor for both global and link-local addresses. The intention was
to drop the
packet even for global addresses if the route via the specific
interface is not found.
Alternatively(believe semantically correct for End.X definition) I
could do a neighbor lookup
for nexthop address over specific interface and send the packet out.

> Also doesn't SEG6_LOCAL_ACTION_END_DX6 need a similar treatment?

Yes. I will update the patch for End.DX6 based on the patch finalized for End.X.
