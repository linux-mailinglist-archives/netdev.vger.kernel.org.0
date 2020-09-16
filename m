Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5D3A26BF13
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 10:22:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726532AbgIPIV4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 04:21:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:56476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726068AbgIPIVx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Sep 2020 04:21:53 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CBF642083B;
        Wed, 16 Sep 2020 08:21:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600244512;
        bh=xvNuiguLoALCQNOj0pxCTsjPZcdVb4n1+r7PPV4LjIY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mfpzGTxzw8SBYHiJahTjs3M5wMRgXhvi68qJZrwNt0QX+AT+DvC0DsrZH8IzC7WiG
         Gy2KBL5BWVQ5d/n4Qs0/m2hHS+nOjjfAV/LTiMdQE7EnPomR7+Fk60sMqxW+3dPrQg
         3tbBrFDWkuA7Kg/OzciQQ7QJDdzzSYARU6/l70X8=
Date:   Wed, 16 Sep 2020 10:22:26 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Oded Gabbay <oded.gabbay@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, SW_Drivers <SW_Drivers@habana.ai>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH v3 00/14] Adding GAUDI NIC code to habanalabs driver
Message-ID: <20200916082226.GA509119@kroah.com>
References: <20200915171022.10561-1-oded.gabbay@gmail.com>
 <20200915.134252.1280841239760138359.davem@davemloft.net>
 <CAFCwf131Vbo3im1BjOi_XXfRUu+nfrJY54sEZv8Z5LKut3QE6w@mail.gmail.com>
 <20200916062614.GF142621@kroah.com>
 <CAFCwf126PVDtjeAD8wCc_TiDfer04iydrW1AjUicH4oVHbs12Q@mail.gmail.com>
 <20200916074217.GB189144@kroah.com>
 <CAFCwf10zLR9v65sgGGdkcf+JzZaw_WORAbQvEw-hbbfj=dy2Xg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFCwf10zLR9v65sgGGdkcf+JzZaw_WORAbQvEw-hbbfj=dy2Xg@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 16, 2020 at 11:02:39AM +0300, Oded Gabbay wrote:
> On Wed, Sep 16, 2020 at 10:41 AM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > On Wed, Sep 16, 2020 at 09:36:23AM +0300, Oded Gabbay wrote:
> > > On Wed, Sep 16, 2020 at 9:25 AM Greg Kroah-Hartman
> > > <gregkh@linuxfoundation.org> wrote:
> > > >
> > > > On Tue, Sep 15, 2020 at 11:49:12PM +0300, Oded Gabbay wrote:
> > > > > On Tue, Sep 15, 2020 at 11:42 PM David Miller <davem@davemloft.net> wrote:
> > > > > >
> > > > > > From: Oded Gabbay <oded.gabbay@gmail.com>
> > > > > > Date: Tue, 15 Sep 2020 20:10:08 +0300
> > > > > >
> > > > > > > This is the second version of the patch-set to upstream the GAUDI NIC code
> > > > > > > into the habanalabs driver.
> > > > > > >
> > > > > > > The only modification from v2 is in the ethtool patch (patch 12). Details
> > > > > > > are in that patch's commit message.
> > > > > > >
> > > > > > > Link to v2 cover letter:
> > > > > > > https://lkml.org/lkml/2020/9/12/201
> > > > > >
> > > > > > I agree with Jakub, this driver definitely can't go-in as it is currently
> > > > > > structured and designed.
> > > > > Why is that ?
> > > > > Can you please point to the things that bother you or not working correctly?
> > > > > I can't really fix the driver if I don't know what's wrong.
> > > > >
> > > > > In addition, please read my reply to Jakub with the explanation of why
> > > > > we designed this driver as is.
> > > > >
> > > > > And because of the RDMA'ness of it, the RDMA
> > > > > > folks have to be CC:'d and have a chance to review this.
> > > > > As I said to Jakub, the driver doesn't use the RDMA infrastructure in
> > > > > the kernel and we can't connect to it due to the lack of H/W support
> > > > > we have
> > > > > Therefore, I don't see why we need to CC linux-rdma.
> > > > > I understood why Greg asked me to CC you because we do connect to the
> > > > > netdev and standard eth infrastructure, but regarding the RDMA, it's
> > > > > not really the same.
> > > >
> > > > Ok, to do this "right" it needs to be split up into separate drivers,
> > > > hopefully using the "virtual bus" code that some day Intel will resubmit
> > > > again that will solve this issue.
> > > Hi Greg,
> > > Can I suggest an alternative for the short/medium term ?
> > >
> > > In an earlier email, Jakub said:
> > > "Is it not possible to move the files and still build them into a single
> > > module?"
> > >
> > > I thought maybe that's a good way to progress here ?
> >
> > Cross-directory builds of a single module are crazy.  Yes, they work,
> > but really, that's a mess, and would never suggest doing that.
> >
> > > First, split the content to Ethernet and RDMA.
> > > Then move the Ethernet part to drivers/net but build it as part of
> > > habanalabs.ko.
> > > Regarding the RDMA code, upstream/review it in a different patch-set
> > > (maybe they will want me to put the files elsewhere).
> > >
> > > What do you think ?
> >
> > I think you are asking for more work there than just splitting out into
> > separate modules :)
> >
> > thanks,
> >
> > greg k-h
> Hi Greg,
> 
> If cross-directory building is out of the question, what about
> splitting into separate modules ? And use cross-module notifiers/calls
> ? I did that with amdkfd and amdgpu/radeon a couple of years back. It
> worked (that's the best thing I can say about it).

That's fine with me.

> The main problem with this "virtual bus" thing is that I'm not
> familiar with it at all and from my experience I imagine it would take
> a considerable time and effort to upstream this infrastructure work.

It shouldn't be taking that long, but for some unknown reason, the
original author of that code is sitting on it and not resending it.  Go
poke them through internal Intel channels to find out what the problem
is, as I have no clue why a 200-300 line bus module is taking so long to
get "right" :(

I'm _ALMOST_ at the point where I would just do that work myself, but
due to my current status with Intel, I'll let them do it as I have
enough other things on my plate...

> This could delay the NIC code for a couple of years, which by then
> this won't be relevant at all.

Why wouldn't this code be relevant in a year?  It's going to be 2+ years
before any of this shows up in an "enterprise distro" based on their
release cycles anyway :)

thanks,

greg k-h
