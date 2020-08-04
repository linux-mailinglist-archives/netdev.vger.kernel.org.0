Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CD5123C1EB
	for <lists+netdev@lfdr.de>; Wed,  5 Aug 2020 00:29:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726916AbgHDW3T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Aug 2020 18:29:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726396AbgHDW3S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Aug 2020 18:29:18 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31B9CC06174A
        for <netdev@vger.kernel.org>; Tue,  4 Aug 2020 15:29:18 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id t4so35653373iln.1
        for <netdev@vger.kernel.org>; Tue, 04 Aug 2020 15:29:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/LRcbuJhDiA5i4sIrwMa9LvYsza0WpLG76uNKKVSKIw=;
        b=Q0CmRc1UavsZ8zeiQjUW78myNZy0yOP5QL+pZ9FpUoi1114QAsWU3tPGxfch8UdVGB
         I2AEYp+n70wlzf42HBZimrsHjcKO18dmtmau/fpaZKoy4wWl9v4IXPH6HGH19G/04Qut
         aoNO0CsvrxEQEvu+kWfYP3Nxba4MMsD9jDlL2+EVCajlnsi6BxrfFPl8TReO5v3LRFwA
         7gXkVXMfcEzxNFvfalUfZgvOKwAXWXn1ntekL6qQ6XpMVKbhDgy91KeADuECSgiCa3+K
         ZcZmMDJRpavtJMm8LvWKY+s00SsS5s1/kdCV5w4XZmaT5HpW/iYhAFkX9huJJHSlxDqR
         tIbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/LRcbuJhDiA5i4sIrwMa9LvYsza0WpLG76uNKKVSKIw=;
        b=C/weX5mGRznRRMbxATYAW5KgT0jBJs6wpn7WttHIbbEGIADBCZPTZEakb1b1W9l09G
         h8lGEhZlz5aT2DMHzddjuIQMDaNKCrmwCqMTI0Gj7PbWqpb80vm4Tdq5spr7F75Twl32
         ZMNFn68HGBhYOTkwNMQrR1ytscaXZ0Yk5uom0eg0lqPO7yIVtBCY3uBUGI/poT9lpJ+l
         gjzsh+KiPWEmMKB8yYdb5HDW3qJDqXVhCZ5OOpcBSU7pFKg3Pi3GH4LtZaa5/JOsebS6
         jPhhu1suJr0cNPtf7/7jAyuHiXyR1tOSQToZYDHS9iJTibeA/BHv4Z3CqT8zD0fSxtpv
         4SuQ==
X-Gm-Message-State: AOAM532i334/6XB1C7Hzz2A4ASwZ5ewfWtc0dEKVvOCGqrfzeSCrzw1g
        2MKppjG5wIc2iU4ZHcpI/0/RBQwSCo1Vm6QatY/mjQ==
X-Google-Smtp-Source: ABdhPJzg47fwLl1M5lmK5kGpewfiWMg7u0Crk5MPYpmDBr5InX3y+VKnVJc4Hzjfn96mEJ7R8VD97wGlKJ3w2Ah4tRA=
X-Received: by 2002:a05:6e02:88:: with SMTP id l8mr715361ilm.69.1596580157198;
 Tue, 04 Aug 2020 15:29:17 -0700 (PDT)
MIME-Version: 1.0
References: <c531bf92-dd7e-0e69-8307-4c4f37cb2d02@gmail.com>
 <f8465c4b8db649e0bb5463482f9be96e@BK99MAIL02.bk.local> <b5ad26fe-e6c3-e771-fb10-77eecae219f6@gmail.com>
 <020a80686edc48d5810e1dbf884ae497@BK99MAIL02.bk.local> <20200804142708.zjos3b6jvqjj7uas@skbuf>
 <CANn89iKD1H9idd-TpHQ-KS7vYHnz+6VhymrgD2cuGAUHgp2Zpg@mail.gmail.com>
 <20200804192933.pe32dhfkrlspdhot@skbuf> <CANn89iKw+OGo9U9iXf61ELYRo-XzC41uz-tr34KtHcW26C-z8g@mail.gmail.com>
 <20200804194333.iszq54mhrtcy3hs6@skbuf> <CANn89iKxjxdiMdmFvz6hH-XaH4wNQiweo27cqh=W-gC7UT_OLA@mail.gmail.com>
 <20200804212421.e2lztrrg4evuk6zd@skbuf>
In-Reply-To: <20200804212421.e2lztrrg4evuk6zd@skbuf>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 4 Aug 2020 15:29:05 -0700
Message-ID: <CANn89iKuVa8-piOf424HyiFZqTHEjFEGa7C5KV4TMWNZyhJzvQ@mail.gmail.com>
Subject: Re: PROBLEM: (DSA/Microchip): 802.1Q-Header lost on KSZ9477-DSA
 ingress without bridge
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     "Gaube, Marvin (THSE-TL1)" <Marvin.Gaube@tesat.de>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 4, 2020 at 2:24 PM Vladimir Oltean <olteanv@gmail.com> wrote:
>
> On Tue, Aug 04, 2020 at 01:36:56PM -0700, Eric Dumazet wrote:
> > On Tue, Aug 4, 2020 at 12:43 PM Vladimir Oltean <olteanv@gmail.com> wrote:
> > >
> > > On Tue, Aug 04, 2020 at 12:40:24PM -0700, Eric Dumazet wrote:
> > > > On Tue, Aug 4, 2020 at 12:29 PM Vladimir Oltean <olteanv@gmail.com> wrote:
> > > > >
> > > > > On Tue, Aug 04, 2020 at 07:54:18AM -0700, Eric Dumazet wrote:
> > > > > >
> > > > > > My 2013 commit was a bug fix, and hinted that in the future (eg in
> > > > > > net-next tree) the stop-the-bleed could be refined.
> > > > > >
> > > > > > +               /* Note: we might in the future use prio bits
> > > > > > +                * and set skb->priority like in vlan_do_receive()
> > > > > > +                * For the time being, just ignore Priority Code Point
> > > > > > +                */
> > > > > > +               skb->vlan_tci = 0;
> > > > > >
> > > > > > If you believe this can be done, this is great.
> > > > >
> > > > > Do you have a reproducer for that bug? I am willing to spend some time
> > > > > understand what is going on. This has nothing to do with priority. You
> > > > > vaguely described a problem with 802.1p (VLAN 0) and used that as an
> > > > > excuse to clear the entire vlan hwaccel tag regardless of VLAN ID. I'm
> > > > > curious because we also now have commit 36b2f61a42c2 ("net: handle
> > > > > 802.1P vlan 0 packets properly") in that general area, and I simply want
> > > > > to know if your patch still serves a valid purpose or not.
> > > > >
> > > >
> > > > I do not have a repro, the patch seemed to help at that time,
> > > > according to the reporter.
> > >
> > > Do you mind if I respectfully revert then? It's clear that the patch has
> > > loopholes already (it clears the vlan if it's hwaccel, but leaves it
> > > alone if it isn't) and that the proper solution should be different
> > > anyway.
> >
> > Clearly the situation before the patch was not good, it seems well
> > explained in the changelog.
> >
> > If you want to revert, you will need to convince the bug has been
> > solved in another way.
> >
> > So it seems you might have to repro the initial problem.
>
> What bug? What repro? You just said you don't have any.

Ask Steinar ?


>
> Maybe I'm dumb, but the changelog is vague to me. It isn't clear what
> kind of routing it is, what type of traffic was the router being
> subjected to, from what direction was the VLAN traffic coming, was it
> just VLAN 0 that was problematic, what drivers those were, what kernel
> was used, what has any of that have to do with the referenced commit
> 48cc32d38a52 ("vlan: don't deliver frames for unknown vlans to
> protocols") which is about macvlan returning RX_HANDLER_PASS instead of
> RX_HANDLER_ANOTHER, were there other sub-interfaces as well?

The kernel was the very kernel right before the change. git will tell
you that easily.

> And there are also obvious mistakes in the commit description: "if the
> vlan id is set and we could find a vlan device for this particular id."
> -> "couldn't" should be instead of "could".
>

Complaining about a change log seven years after the commit is rather useless.

> This is ridiculous.

Ok
