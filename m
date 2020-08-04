Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D6D623C0CE
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 22:37:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727816AbgHDUhK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Aug 2020 16:37:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726807AbgHDUhJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Aug 2020 16:37:09 -0400
Received: from mail-il1-x12d.google.com (mail-il1-x12d.google.com [IPv6:2607:f8b0:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC0B7C06174A
        for <netdev@vger.kernel.org>; Tue,  4 Aug 2020 13:37:09 -0700 (PDT)
Received: by mail-il1-x12d.google.com with SMTP id e16so735754ilc.12
        for <netdev@vger.kernel.org>; Tue, 04 Aug 2020 13:37:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pPFt6BPpr5kWMiuG7QJES230P8jJOAExClolGxb6Dag=;
        b=G4onknQx6Rep7a1T9rtMXlahwN/4o8prgzbVvxSgCPZQerkeSI0TMpSlQx05whhnDt
         iuUybrSP/GtQlYxF4Tt0jChGjbRreGEWU8QAexzVKZfOsWCQ8PIOWOVoCQ//zAvg6gYi
         aVzr/18cFhj8WEdgTJQ9H8V7emQZbQ/tdfu4+5hWtcLKgd7XZRUxaV+jVQvKUk+OF8Zu
         USt1cWqv+nBmVw7TSsx15Otw70/ZjDVrvcV/NDYj+5pC87qPeokJVZtP0H0RscK8tSiS
         KfNNmH0vkPzg/HwLPkgKuJFHQ1hVOvWgYosu1XbWUBT5/ME+AmLOuCTGR8284T5tnF2m
         hv3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pPFt6BPpr5kWMiuG7QJES230P8jJOAExClolGxb6Dag=;
        b=UJRImlzx3K9fFIHQknCBJgBLV25/BWQfJndn7n+3JG9YFBPm67RCLRXcN5Nqga781i
         ZU1/edXTnRIcRZjcS9emZ4XaaDG93aSeQQpsXQqd31ym9DmkSZBlKUPOgunEUmE+nye/
         I4H6UCdhkJjxNgZavXN6/+b/AA2gCqify3OYS9z6UtlKnP7UAthf9BBXPCla4c1tgSGk
         wJ9/Wx7sH77NvOCRyX7YAiLO4hA6+fTmTSJiibpIb7SIQ0onbCe0wScvsn1zUFHfNGBh
         6/3ml4T9p7GvYY/RibDg7Hiby/99rqpdSWrmxXNnJ9o3jE/IG7Ues7Q5qqQEQewSlOBh
         c85g==
X-Gm-Message-State: AOAM5318SRnR3HGriMN7DHxDjl7FZ4EY1MCRhJr/LB3M87mqBcgobN93
        wUap+4MG20o7UbMDKh8asCqDGqP0Yr7vAFbOKtNilA==
X-Google-Smtp-Source: ABdhPJzCAo3i3zD8LKS5JGsjPQFWyYRErQInaUDFfI5zo4ngSmEgxnjxP1x750jtv460CF/7NdllCFG7PXckqAkQBeU=
X-Received: by 2002:a92:c608:: with SMTP id p8mr245857ilm.137.1596573428179;
 Tue, 04 Aug 2020 13:37:08 -0700 (PDT)
MIME-Version: 1.0
References: <ad09e947263c44c48a1d2c01bcb4d90a@BK99MAIL02.bk.local>
 <c531bf92-dd7e-0e69-8307-4c4f37cb2d02@gmail.com> <f8465c4b8db649e0bb5463482f9be96e@BK99MAIL02.bk.local>
 <b5ad26fe-e6c3-e771-fb10-77eecae219f6@gmail.com> <020a80686edc48d5810e1dbf884ae497@BK99MAIL02.bk.local>
 <20200804142708.zjos3b6jvqjj7uas@skbuf> <CANn89iKD1H9idd-TpHQ-KS7vYHnz+6VhymrgD2cuGAUHgp2Zpg@mail.gmail.com>
 <20200804192933.pe32dhfkrlspdhot@skbuf> <CANn89iKw+OGo9U9iXf61ELYRo-XzC41uz-tr34KtHcW26C-z8g@mail.gmail.com>
 <20200804194333.iszq54mhrtcy3hs6@skbuf>
In-Reply-To: <20200804194333.iszq54mhrtcy3hs6@skbuf>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 4 Aug 2020 13:36:56 -0700
Message-ID: <CANn89iKxjxdiMdmFvz6hH-XaH4wNQiweo27cqh=W-gC7UT_OLA@mail.gmail.com>
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

On Tue, Aug 4, 2020 at 12:43 PM Vladimir Oltean <olteanv@gmail.com> wrote:
>
> On Tue, Aug 04, 2020 at 12:40:24PM -0700, Eric Dumazet wrote:
> > On Tue, Aug 4, 2020 at 12:29 PM Vladimir Oltean <olteanv@gmail.com> wrote:
> > >
> > > On Tue, Aug 04, 2020 at 07:54:18AM -0700, Eric Dumazet wrote:
> > > >
> > > > My 2013 commit was a bug fix, and hinted that in the future (eg in
> > > > net-next tree) the stop-the-bleed could be refined.
> > > >
> > > > +               /* Note: we might in the future use prio bits
> > > > +                * and set skb->priority like in vlan_do_receive()
> > > > +                * For the time being, just ignore Priority Code Point
> > > > +                */
> > > > +               skb->vlan_tci = 0;
> > > >
> > > > If you believe this can be done, this is great.
> > >
> > > Do you have a reproducer for that bug? I am willing to spend some time
> > > understand what is going on. This has nothing to do with priority. You
> > > vaguely described a problem with 802.1p (VLAN 0) and used that as an
> > > excuse to clear the entire vlan hwaccel tag regardless of VLAN ID. I'm
> > > curious because we also now have commit 36b2f61a42c2 ("net: handle
> > > 802.1P vlan 0 packets properly") in that general area, and I simply want
> > > to know if your patch still serves a valid purpose or not.
> > >
> >
> > I do not have a repro, the patch seemed to help at that time,
> > according to the reporter.
>
> Do you mind if I respectfully revert then? It's clear that the patch has
> loopholes already (it clears the vlan if it's hwaccel, but leaves it
> alone if it isn't) and that the proper solution should be different
> anyway.

Clearly the situation before the patch was not good, it seems well
explained in the changelog.

If you want to revert, you will need to convince the bug has been
solved in another way.

So it seems you might have to repro the initial problem.
