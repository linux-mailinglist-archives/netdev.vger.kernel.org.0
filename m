Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAB27270FC5
	for <lists+netdev@lfdr.de>; Sat, 19 Sep 2020 19:27:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726672AbgISR1E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Sep 2020 13:27:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:44626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726449AbgISR1E (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 19 Sep 2020 13:27:04 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A162420878;
        Sat, 19 Sep 2020 17:27:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600536423;
        bh=c4t2DTYMe14NfdyzaFe8W5MR+G6cgGNJXtHBkCQ9T+8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=xOb5JbLkXNpkWPWXVUfWExm4Do+807QeN+OPu8opqZe4bEWjgSDLnPj9/eWNocl1J
         ZWBo2A4eA31dRMUsmbYEDbHw66lMGfJ7tb3tVFieEjTt8YLhIJe1oHFrjVOb6PUvN2
         tRM9r3J4F4nPCqTV8rzs4WRXdjQKE2zm/Kuy4/L0=
Date:   Sat, 19 Sep 2020 19:27:30 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Oded Gabbay <oded.gabbay@gmail.com>
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
Subject: Re: [PATCH v3 00/14] Adding GAUDI NIC code to habanalabs driver
Message-ID: <20200919172730.GC2733595@kroah.com>
References: <0b21db8d-1061-6453-960b-8043951b3bad@amazon.com>
 <20200918115227.GR869610@unreal>
 <CAFCwf10C1zm91e=tqPVGOX8kZD7o=AR2EW-P9VwCF4rcvnEJnA@mail.gmail.com>
 <20200918120340.GT869610@unreal>
 <CAFCwf12VPuyGFqFJK5D19zcKFQJ=fmzjwscdPG82tfR_v_h3Kg@mail.gmail.com>
 <20200918121905.GU869610@unreal>
 <20200919064020.GC439518@kroah.com>
 <20200919082003.GW869610@unreal>
 <20200919083012.GA465680@kroah.com>
 <CAFCwf122V-ep44Kqk1DgRJN+tq3ctxE9uVbqYL07apLkLe2Z7g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFCwf122V-ep44Kqk1DgRJN+tq3ctxE9uVbqYL07apLkLe2Z7g@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Sep 19, 2020 at 07:43:28PM +0300, Oded Gabbay wrote:
> On Sat, Sep 19, 2020 at 11:30 AM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > On Sat, Sep 19, 2020 at 11:20:03AM +0300, Leon Romanovsky wrote:
> > > On Sat, Sep 19, 2020 at 08:40:20AM +0200, Greg Kroah-Hartman wrote:
> > > > On Fri, Sep 18, 2020 at 03:19:05PM +0300, Leon Romanovsky wrote:
> > > > > > So we do have an open-source library called hl-thunk, which uses our
> > > > > > driver and indeed that was part of the requirement.
> > > > > > It is similar to libdrm.
> > > > > > Here is the link:
> > > > > > https://github.com/HabanaAI/hl-thunk
> > > > >
> > > > > Are you kidding?
> > > > >
> > > > > This is mirror of some internal repository that looks like dumpster
> > > > > with ChangeId, internal bug tracker numbers, not part of major OS
> > > > > distributions.
> > > > >
> > > > > It is not open-source library and shows very clear why you chose
> > > > > to upstream your driver through driver/misc/ tree.
> > > >
> > > > It is an open source library, as per the license and the code
> > > > availability.  What more is expected here?
> > >
> > > So can I fork iproute2, add bunch of new custom netlink UAPIs and expect
> > > Dave to merge it after I throw it on github?
> >
> > Don't be silly, that's not the case here at all and you know that.
> >
> > > > No distro has to pick it up, that's not a requirement for kernel code,
> > > > we have many kernel helper programs that are not in distros.  Heck, udev
> > > > took a long time to get into distros, does that mean the kernel side of
> > > > that interface should never have been merged?
> > > >
> > > > I don't understand your complaint here, it's not our place to judge the
> > > > code quality of userspace libraries, otherwise we would never get any
> > > > real-work done :)
> > >
> > > My main complaint is that you can't imagine merging code into large
> > > subsystems (netdev, RDMA, DRM? e.t.c) without being civil open-source
> > > citizen. It means use of existing user-space libraries/tools and/or
> > > providing new ones that will be usable for everyone.
> >
> > Agreed.
> >
> > > In this case, we have some custom char device with library that is not
> > > usable for anyone else and this is why drivers/misc/ is right place.
> >
> > Also agreed.
> >
> > > While we are talking about real-work, it is our benefit to push companies
> > > to make investment into ecosystem and not letting them to find an excuse
> > > for not doing it.
> >
> > So why are you complaining about a stand-alone driver that does not have
> > any shared subsystems's userspace code to control that driver?
> >
> > Yes, when integrating into other subsystems (i.e. networking and rdma),
> > they should use those common subsystems interfaces, no one is arguing
> > that at all.
> Hi Greg,
> It's probably heresy, but why do I need to integrate into the RDMA subsystem ?
> I understand your reasoning about networking (Ethernet) as the driver
> connects to the kernel networking stack (netdev), but with RDMA the
> driver doesn't use or connect to anything in that stack. If I were to
> support IBverbs and declare that I support it, then of course I would
> need to integrate to the RDMA subsystem and add my backend to
> rdma-core.

IBverbs are horrid and I would not wish them on anyone.  Seriously.

> But we don't do that so why am I being forced to support IBverbs ?

You shouldn't.

> Forcing GAUDI to use the RDMA stack and IBverbs is like swatting flies
> with a sledgehammer.
> I do hope that in future devices we will support it natively and of
> course then we will integrate as requested, but for GAUDI it is just a
> huge overkill IMHO.

I think the general rdma apis are the key here, not the userspace api.

Note, I do not know exactly what they are, but no, IBverbs are not ok.

Ick.

greg k-h
