Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEA01270F9A
	for <lists+netdev@lfdr.de>; Sat, 19 Sep 2020 18:44:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726623AbgISQoC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Sep 2020 12:44:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726463AbgISQoB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Sep 2020 12:44:01 -0400
Received: from mail-oi1-x244.google.com (mail-oi1-x244.google.com [IPv6:2607:f8b0:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3521C0613CE;
        Sat, 19 Sep 2020 09:44:01 -0700 (PDT)
Received: by mail-oi1-x244.google.com with SMTP id a3so11310351oib.4;
        Sat, 19 Sep 2020 09:44:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Cfduvuo2qaLqbrqkySQg+itnGIveDrg6Cvu0oEAcq/k=;
        b=pU9HBPbUXcukfQfrJjasbEIUXNL/ChjPxwRvkTvdzlQgmVSa10YyaEIw7ZCOTf+H13
         /NW1BQrmCMQLifiBnW0BTazPYzpTWmIFpH8KXJ4txuYts1G5o2iQa5wJdnb3I77WfKUE
         cTWLqAbnz1m8HqqpJt5UfqDFB1OYtMX6Ixw0SXIzbg8yQQh0UfgIQeDY/CEaj9d5xM4V
         GVmjVOw+jLpTqhoAbEqcn5gUO916XtAX7I5jFfZYm37l+W5yVFeeQH0mU4pO1b5MrjZW
         8xIQ9WInrK/ZhDgPOJMpm5d3rMNNj59KA6nPNoIWY8DXioBAHND0dx9+AGGCqN5jQOE7
         kyEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Cfduvuo2qaLqbrqkySQg+itnGIveDrg6Cvu0oEAcq/k=;
        b=jSbadOkvJTD5Pzx/G2yUH9/D4bnnya7tuoRsdSnAQ0H4A3ew0SxAETX5JMUoPpnblF
         youWFMcbwPooZKIr/w1pfqIG3lozsETKq3wDECgSfteiWh2064H9IwkNObK0plU7Z/W8
         lVmmwnwzG6+7VoqUNTjctBwsN4vWrBQqWMKgEZ/iNxkvygeWTO7qWgVRZWSa0lgT9Szx
         U3+EQcG6IF1o68B4i0Q6X/7jYpxUhYu4OV+F89zLIWcBuS46BPgwrrWo/oWDUM+d7rCz
         Myr+WHRItGKUTqNW0hm7hGSVmWF/A4saQ4IyqfXi4CwaaSN8z3OHs+IbNevSpcGpVyAk
         iLRQ==
X-Gm-Message-State: AOAM530F+nv9GBXaf8cKvzCLS8sV+XJelLHB93e0CAdcx16D6n4AGNhn
        nf1gYPBtC9UF413t18clYG3KfXqEbhhLQrV5ZdE=
X-Google-Smtp-Source: ABdhPJwJqb/AKIJliKN7dAiHbWX51Djs2BGiO2F9MjnRLdzLcAZrD77jiGwWi8q2T31NGa25n//D/HTIw2eycuiNJNA=
X-Received: by 2002:a05:6808:a05:: with SMTP id n5mr13138730oij.154.1600533839763;
 Sat, 19 Sep 2020 09:43:59 -0700 (PDT)
MIME-Version: 1.0
References: <CAFCwf12XZRxLYifSfuB+RGhuiKBytzsUTOnEa6FqfJHYvcVJPQ@mail.gmail.com>
 <20200917171833.GJ8409@ziepe.ca> <0b21db8d-1061-6453-960b-8043951b3bad@amazon.com>
 <20200918115227.GR869610@unreal> <CAFCwf10C1zm91e=tqPVGOX8kZD7o=AR2EW-P9VwCF4rcvnEJnA@mail.gmail.com>
 <20200918120340.GT869610@unreal> <CAFCwf12VPuyGFqFJK5D19zcKFQJ=fmzjwscdPG82tfR_v_h3Kg@mail.gmail.com>
 <20200918121905.GU869610@unreal> <20200919064020.GC439518@kroah.com>
 <20200919082003.GW869610@unreal> <20200919083012.GA465680@kroah.com>
In-Reply-To: <20200919083012.GA465680@kroah.com>
From:   Oded Gabbay <oded.gabbay@gmail.com>
Date:   Sat, 19 Sep 2020 19:43:28 +0300
Message-ID: <CAFCwf122V-ep44Kqk1DgRJN+tq3ctxE9uVbqYL07apLkLe2Z7g@mail.gmail.com>
Subject: Re: [PATCH v3 00/14] Adding GAUDI NIC code to habanalabs driver
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Leon Romanovsky <leon@kernel.org>,
        Gal Pressman <galpress@amazon.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Jakub Kicinski <kuba@kernel.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, SW_Drivers <SW_Drivers@habana.ai>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-rdma@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Sep 19, 2020 at 11:30 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Sat, Sep 19, 2020 at 11:20:03AM +0300, Leon Romanovsky wrote:
> > On Sat, Sep 19, 2020 at 08:40:20AM +0200, Greg Kroah-Hartman wrote:
> > > On Fri, Sep 18, 2020 at 03:19:05PM +0300, Leon Romanovsky wrote:
> > > > > So we do have an open-source library called hl-thunk, which uses our
> > > > > driver and indeed that was part of the requirement.
> > > > > It is similar to libdrm.
> > > > > Here is the link:
> > > > > https://github.com/HabanaAI/hl-thunk
> > > >
> > > > Are you kidding?
> > > >
> > > > This is mirror of some internal repository that looks like dumpster
> > > > with ChangeId, internal bug tracker numbers, not part of major OS
> > > > distributions.
> > > >
> > > > It is not open-source library and shows very clear why you chose
> > > > to upstream your driver through driver/misc/ tree.
> > >
> > > It is an open source library, as per the license and the code
> > > availability.  What more is expected here?
> >
> > So can I fork iproute2, add bunch of new custom netlink UAPIs and expect
> > Dave to merge it after I throw it on github?
>
> Don't be silly, that's not the case here at all and you know that.
>
> > > No distro has to pick it up, that's not a requirement for kernel code,
> > > we have many kernel helper programs that are not in distros.  Heck, udev
> > > took a long time to get into distros, does that mean the kernel side of
> > > that interface should never have been merged?
> > >
> > > I don't understand your complaint here, it's not our place to judge the
> > > code quality of userspace libraries, otherwise we would never get any
> > > real-work done :)
> >
> > My main complaint is that you can't imagine merging code into large
> > subsystems (netdev, RDMA, DRM? e.t.c) without being civil open-source
> > citizen. It means use of existing user-space libraries/tools and/or
> > providing new ones that will be usable for everyone.
>
> Agreed.
>
> > In this case, we have some custom char device with library that is not
> > usable for anyone else and this is why drivers/misc/ is right place.
>
> Also agreed.
>
> > While we are talking about real-work, it is our benefit to push companies
> > to make investment into ecosystem and not letting them to find an excuse
> > for not doing it.
>
> So why are you complaining about a stand-alone driver that does not have
> any shared subsystems's userspace code to control that driver?
>
> Yes, when integrating into other subsystems (i.e. networking and rdma),
> they should use those common subsystems interfaces, no one is arguing
> that at all.
Hi Greg,
It's probably heresy, but why do I need to integrate into the RDMA subsystem ?
I understand your reasoning about networking (Ethernet) as the driver
connects to the kernel networking stack (netdev), but with RDMA the
driver doesn't use or connect to anything in that stack. If I were to
support IBverbs and declare that I support it, then of course I would
need to integrate to the RDMA subsystem and add my backend to
rdma-core.
But we don't do that so why am I being forced to support IBverbs ?
Forcing GAUDI to use the RDMA stack and IBverbs is like swatting flies
with a sledgehammer.
I do hope that in future devices we will support it natively and of
course then we will integrate as requested, but for GAUDI it is just a
huge overkill IMHO.

Thanks,
Oded
>
> totally lost,
>
> greg k-h
