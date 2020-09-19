Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF46B270C0D
	for <lists+netdev@lfdr.de>; Sat, 19 Sep 2020 10:58:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726249AbgISI6G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Sep 2020 04:58:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:55362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726041AbgISI6G (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 19 Sep 2020 04:58:06 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C721B21582;
        Sat, 19 Sep 2020 08:58:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600505885;
        bh=++lE0cUaP7TIk6cdN49a/tPWXNii3KbrsDBs/q2JJZg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mXxJKosptnNHyuGtJY0GL4zqZ1KT7fJdVyNFptKO1EG5xo23cYTwOO21KBNxzNYoP
         NxDJZh1QhTMEXbUovPfOg/+rOevuv/vRcVG6Hdky1+6HiW6QFA/2UIW8psc2O1+yPP
         S/AO0yFWhuIRJIXxBGFNIYLLUpuHUkUKGPVpeGT4=
Date:   Sat, 19 Sep 2020 11:58:01 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Oded Gabbay <oded.gabbay@gmail.com>,
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
Message-ID: <20200919085801.GA869610@unreal>
References: <20200917171833.GJ8409@ziepe.ca>
 <0b21db8d-1061-6453-960b-8043951b3bad@amazon.com>
 <20200918115227.GR869610@unreal>
 <CAFCwf10C1zm91e=tqPVGOX8kZD7o=AR2EW-P9VwCF4rcvnEJnA@mail.gmail.com>
 <20200918120340.GT869610@unreal>
 <CAFCwf12VPuyGFqFJK5D19zcKFQJ=fmzjwscdPG82tfR_v_h3Kg@mail.gmail.com>
 <20200918121905.GU869610@unreal>
 <20200919064020.GC439518@kroah.com>
 <20200919082003.GW869610@unreal>
 <20200919083012.GA465680@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200919083012.GA465680@kroah.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Sep 19, 2020 at 10:30:12AM +0200, Greg Kroah-Hartman wrote:
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

It was far-fetched example.

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

I didn't, everything started when I explained to Gal why RDMA subsystem
requires rdma-core counterpart for any UAPI code.
https://lore.kernel.org/linux-rdma/CAFCwf12B4vCCwmfA7+VTUYUgJ9EHAtvg6F0bMYnsSCUBST+aWA@mail.gmail.com/T/#m17d52d61adadf54c12bfecf1af5db40f5d829ac3

And expressed my view on the quality of the library that was presented
as open-source example.
https://lore.kernel.org/linux-rdma/CAFCwf12B4vCCwmfA7+VTUYUgJ9EHAtvg6F0bMYnsSCUBST+aWA@mail.gmail.com/T/#m9059c5a9405ba932d9ffb731195a43b27443d265

>
> Yes, when integrating into other subsystems (i.e. networking and rdma),
> they should use those common subsystems interfaces, no one is arguing
> that at all.
>
> totally lost,

And here comes my request to do it right
https://lore.kernel.org/linux-rdma/CAFCwf12B4vCCwmfA7+VTUYUgJ9EHAtvg6F0bMYnsSCUBST+aWA@mail.gmail.com/T/#ma1fa6fe63666f630674eb668f1c00e6a672db85b

All that I asked from Oded is to do UAPI/libraries right, while all the responses
can be summarized to one sentence - "it is too hard, we don't want to do it."

Thanks

>
> greg k-h
