Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 986962DDEDD
	for <lists+netdev@lfdr.de>; Fri, 18 Dec 2020 08:13:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732886AbgLRHLf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Dec 2020 02:11:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:37352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726520AbgLRHLf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Dec 2020 02:11:35 -0500
Date:   Fri, 18 Dec 2020 08:10:51 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1608275455;
        bh=WoCbTvI1JoQUbfKVXDl1rGZDoThbBAh8ju3cl9AbMs8=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=p0eV3itq7B0JE2tPEfmKLKMQdHJX+EzH3vsTS33F1/pMV7DbYhFzntdD9GS08cocT
         Zlfyb0i3i0SLP8nMIMMP6g3JPFC2W7UG8B8zCvOStI8a5Bn++07L00/bwHAPfzAsO4
         V0+UN2s971KPNO8oivHNaM/wP3eLm4rRUNvj81Lg=
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Alexandre Belloni <alexandre.belloni@bootlin.com>
Cc:     Dan Williams <dan.j.williams@intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        alsa-devel@alsa-project.org, Kiran Patil <kiran.patil@intel.com>,
        linux-rdma <linux-rdma@vger.kernel.org>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        Martin Habets <mhabets@solarflare.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Fred Oh <fred.oh@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Dave Ertman <david.m.ertman@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Leon Romanovsky <leonro@nvidia.com>,
        David Miller <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Parav Pandit <parav@mellanox.com>
Subject: Re: [resend/standalone PATCH v4] Add auxiliary bus support
Message-ID: <X9xV+8Mujo4dhfU4@kroah.com>
References: <160695681289.505290.8978295443574440604.stgit@dwillia2-desk3.amr.corp.intel.com>
 <X8ogtmrm7tOzZo+N@kroah.com>
 <CAPcyv4iLG7V9JT34La5PYfyM9378acbLnkShx=6pOmpPK7yg3A@mail.gmail.com>
 <X8usiKhLCU3PGL9J@kroah.com>
 <20201217211937.GA3177478@piout.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201217211937.GA3177478@piout.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 17, 2020 at 10:19:37PM +0100, Alexandre Belloni wrote:
> Hello,
> 
> On 05/12/2020 16:51:36+0100, Greg KH wrote:
> > > To me, the documentation was written, and reviewed, more from the
> > > perspective of "why not open code a custom bus instead". So I can see
> > > after the fact how that is a bit too much theory and justification and
> > > not enough practical application. Before the fact though this was a
> > > bold mechanism to propose and it was not clear that everyone was
> > > grokking the "why" and the tradeoffs.
> > 
> > Understood, I guess I read this from the "of course you should do this,
> > now how do I use it?" point of view.  Which still needs to be addressed
> > I feel.
> > 
> > > I also think it was a bit early to identify consistent design patterns
> > > across the implementations and codify those. I expect this to evolve
> > > convenience macros just like other parts of the driver-core gained
> > > over time. Now that it is in though, another pass through the
> > > documentation to pull in more examples seems warranted.
> > 
> > A real, working, example would be great to have, so that people can know
> > how to use this.  Trying to dig through the sound or IB patches to view
> > how it is being used is not a trivial thing to do, which is why
> > reviewing this took so much work.  Having a simple example test module,
> > that creates a number of devices on a bus, ideally tied into the ktest
> > framework, would be great.  I'll attach below a .c file that I used for
> > some basic local testing to verify some of this working, but it does not
> > implement a aux bus driver, which needs to be also tested.
> > 
> 
> There is something I don't get from the documentation and it is what is
> this introducing that couldn't already be done using platform drivers
> and platform devices?

Because platform drivers and devices should ONLY be for actual platform
devices.  Do NOT use that interface to fake up a non-platform device
(i.e. something that is NOT connected to a cpu through a memory-mapped
or direct-firmware interface).

Do not abuse the platform code anymore than it currently is, it's bad
enough what has been done to it over time, let's not make it any worse.

thanks,

greg k-h
