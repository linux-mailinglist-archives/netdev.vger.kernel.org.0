Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A41E1D4A47
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 12:00:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728311AbgEOJ7f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 05:59:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728040AbgEOJ7d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 May 2020 05:59:33 -0400
Received: from mail-ot1-x335.google.com (mail-ot1-x335.google.com [IPv6:2607:f8b0:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5980DC061A0C
        for <netdev@vger.kernel.org>; Fri, 15 May 2020 02:59:33 -0700 (PDT)
Received: by mail-ot1-x335.google.com with SMTP id z17so1459991oto.4
        for <netdev@vger.kernel.org>; Fri, 15 May 2020 02:59:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OiGFLUEs0j76JYxhEW+vj0/bEALcqur7PHf4I670Vf4=;
        b=OiWRyaPi9c1HERkt64fjfgluVRffnLluI4wP2DxRE2oYIA9C7SP2tSjMfzQShYPoVn
         HFX7i/cbe5bxMh6mgkXLDiKyoM4PhbzaV1uZjIjWFQVFuItHLE061me9UmIPjQ3zGNNt
         Ho4dvbTW/d3e5WcOQ6FP/EGj8BKrDd/z7A8jw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OiGFLUEs0j76JYxhEW+vj0/bEALcqur7PHf4I670Vf4=;
        b=q9Bj3MxJDp/pKLUo/PszDdzt9Ca8JXXa/Oi1M/G4YyMnaLjMukvtjO3arFufPuE0eS
         DMvoIxoajfupXrTPmseXvdLtSBT9QYLMtH5CxNnOB3atAYRN6IOr0J6yYA/wOIfOBC7S
         p+TIlUBHZ9fIdXttY353G2O+JN10QOVq7E/c9ywC6BUg8PkV+62SUNOUh5yoTrwV6tRY
         bigUKiLpjXzZJk6IYQVs5EyXOk57YlF5As6H2bWH9O1cNEFfvvaZm981+JqQ8xZqR+Nj
         BeJAPaRlc1PufTnXqJdVWgRLpADVzZANc/9ZwW6eBrdgPXK+mdW/HZa9zZ4BjXiebcOg
         YgpQ==
X-Gm-Message-State: AOAM532KaF+0Y6l5vh8Q8W+nc1cuRYwODNeGl5uq1NLe8RPOoxFlCxjt
        rDyaZ7uRyFKalT+VSfzu647eAhsPWEZhdtVv4ADEoQ==
X-Google-Smtp-Source: ABdhPJyrGF3iriQsl8vUame18ZgM7/LlOd4OscXORl1hg6Oppjk/YOmDL/6neaw+KOdOz36CR4Zus2+5dOL2JTGA8rI=
X-Received: by 2002:a9d:a4c:: with SMTP id 70mr1729765otg.334.1589536772643;
 Fri, 15 May 2020 02:59:32 -0700 (PDT)
MIME-Version: 1.0
References: <CACAyw9_4Uzh0GqAR16BfEHQ0ZWHKGUKacOQwwhwsfhdCTMtsNQ@mail.gmail.com>
 <b93b4ad2-0cf0-81e0-b2b0-664248b3630f@gmail.com> <CACAyw9-95He2yq0qoxuWFy3wqQt1kAtAQcRw2UTrqse2hUq1tA@mail.gmail.com>
 <5cca7bce-0052-d854-5ead-b09d43cb9eb9@gmail.com>
In-Reply-To: <5cca7bce-0052-d854-5ead-b09d43cb9eb9@gmail.com>
From:   Lorenz Bauer <lmb@cloudflare.com>
Date:   Fri, 15 May 2020 10:59:21 +0100
Message-ID: <CACAyw9-TEDHdcjykuQZ8P0Q6QngEZU0z7PXgqtZRQq4Jh1_ojw@mail.gmail.com>
Subject: Re: "Forwarding" from TC classifier
To:     David Ahern <dsahern@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Martynas Pumputis <m@lambda.lt>,
        kernel-team <kernel-team@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 14 May 2020 at 19:54, David Ahern <dsahern@gmail.com> wrote:
>
> On 5/14/20 9:41 AM, Lorenz Bauer wrote:
> > On Wed, 13 May 2020 at 18:48, David Ahern <dsahern@gmail.com> wrote:
> >>
> >> On 5/13/20 10:40 AM, Lorenz Bauer wrote:
> >>> We've recently open sourced a key component of our L4 load balancer:
> >>> cls_redirect [1].
> >>> In the commit description, I call out the following caveat:
> >>>
> >>>     cls_redirect relies on receiving encapsulated packets directly
> >>> from a router. This is
> >>>     because we don't have access to the neighbour tables from BPF, yet.
> >>
> >> Can you explain more about this limitation? Why does access to neighbor
> >> tables solve the problem?
> >
> > We want to forward the packet to another machine, based on an IP address
> > stored in our custom encapsulation header.
> > If we always receive packets from a router we can plug in the new IP, swap
> > the MAC and send the packet back to the router. Inefficient, but it means we
> > don't have to deal with MAC addresses ourselves.
>
> Ok, so swapping source and destination addresses in the IP header, doing
> a fib lookup and redirecting to an interface based on the lookup. That
> does require a neighbor entry for the dest address. Access to the
> neighbor table does not directly solve that problem - if it is not there
> for the fib lookup, it won't be there for the straight neigh lookup.
>
> You could let the first packet go up the stack to create and resolve the
> neighbor entry. At that point follow on packets will take the fast path.

Yes, but that doesn't play well with changing the source address to
the local machine's, since the upper part of the stack will drop the
packet due to accept_local=0.

For this to work I need to set accept_local=1, which isn't desirable,
or redirect into the output queue of the device, which currently doesn't
trigger neighbour lookup, etc.

To sum it up: fib_lookup enables the fast path, but I don't have a way
to trigger the slow path in the way I want to. Maybe I need to dig into
bpf_redirect some more.

>
> Alternatively, you can create static entries in the table for known
> forwarding addresses or have a process on the server initiate neighbor
> resolution for none forwarding addresses.
> >>
> >> Usually, 'output' is for locally generated traffic headed out. XDP
> >> programs run on ingress are from an Rx perspective and do the lookup
> >> from the perspective of 'is this forwarded or locally delivered'.
> >
> > What if the XDP encapsulates the packet? At this point I know that I
> > want to forward it elsewhere. Would that use LOOKUP_OUTPUT?
>
> Yes, if you want the lookup to respond as if it is a locally sent packet
> versus a forwarded packet.



-- 
Lorenz Bauer  |  Systems Engineer
6th Floor, County Hall/The Riverside Building, SE1 7PB, UK

www.cloudflare.com
