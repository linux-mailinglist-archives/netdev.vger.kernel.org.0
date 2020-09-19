Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFCF0270BCD
	for <lists+netdev@lfdr.de>; Sat, 19 Sep 2020 10:20:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726290AbgISIUI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Sep 2020 04:20:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:49494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726097AbgISIUI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 19 Sep 2020 04:20:08 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CEE6F21481;
        Sat, 19 Sep 2020 08:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600503607;
        bh=2C9DbblZpeIvlNXU3EPTGvHJlm9sVGUJC+UeC6+NXak=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=F2UPYdRzG9ETJ/t17NF+XSeSyiV21ZpcmsJH/hn13UO06Bu1XDhkk1yFx68Cg2JiI
         Jpf1AnoWSqUhS0S0EeskvV+dEPbWSh5VQJy0R9PowoLJ/ZFn+SLv980sd2MxHr+6iW
         DLAe4nXVRGtCoADIc9lDn1GhYSVMdAJDxKWDtH5Q=
Date:   Sat, 19 Sep 2020 11:20:03 +0300
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
Message-ID: <20200919082003.GW869610@unreal>
References: <20200915133556.21268811@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAFCwf12XZRxLYifSfuB+RGhuiKBytzsUTOnEa6FqfJHYvcVJPQ@mail.gmail.com>
 <20200917171833.GJ8409@ziepe.ca>
 <0b21db8d-1061-6453-960b-8043951b3bad@amazon.com>
 <20200918115227.GR869610@unreal>
 <CAFCwf10C1zm91e=tqPVGOX8kZD7o=AR2EW-P9VwCF4rcvnEJnA@mail.gmail.com>
 <20200918120340.GT869610@unreal>
 <CAFCwf12VPuyGFqFJK5D19zcKFQJ=fmzjwscdPG82tfR_v_h3Kg@mail.gmail.com>
 <20200918121905.GU869610@unreal>
 <20200919064020.GC439518@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200919064020.GC439518@kroah.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Sep 19, 2020 at 08:40:20AM +0200, Greg Kroah-Hartman wrote:
> On Fri, Sep 18, 2020 at 03:19:05PM +0300, Leon Romanovsky wrote:
> > > So we do have an open-source library called hl-thunk, which uses our
> > > driver and indeed that was part of the requirement.
> > > It is similar to libdrm.
> > > Here is the link:
> > > https://github.com/HabanaAI/hl-thunk
> >
> > Are you kidding?
> >
> > This is mirror of some internal repository that looks like dumpster
> > with ChangeId, internal bug tracker numbers, not part of major OS
> > distributions.
> >
> > It is not open-source library and shows very clear why you chose
> > to upstream your driver through driver/misc/ tree.
>
> It is an open source library, as per the license and the code
> availability.  What more is expected here?

So can I fork iproute2, add bunch of new custom netlink UAPIs and expect
Dave to merge it after I throw it on github?

>
> No distro has to pick it up, that's not a requirement for kernel code,
> we have many kernel helper programs that are not in distros.  Heck, udev
> took a long time to get into distros, does that mean the kernel side of
> that interface should never have been merged?
>
> I don't understand your complaint here, it's not our place to judge the
> code quality of userspace libraries, otherwise we would never get any
> real-work done :)

My main complaint is that you can't imagine merging code into large
subsystems (netdev, RDMA, DRM? e.t.c) without being civil open-source
citizen. It means use of existing user-space libraries/tools and/or
providing new ones that will be usable for everyone.

In this case, we have some custom char device with library that is not
usable for anyone else and this is why drivers/misc/ is right place.

While we are talking about real-work, it is our benefit to push companies
to make investment into ecosystem and not letting them to find an excuse
for not doing it.

Thanks

>
> thanks,
>
> greg k-h
