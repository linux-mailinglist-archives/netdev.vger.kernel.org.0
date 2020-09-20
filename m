Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 142392712F7
	for <lists+netdev@lfdr.de>; Sun, 20 Sep 2020 10:47:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726299AbgITIrH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Sep 2020 04:47:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:49212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726247AbgITIrH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 20 Sep 2020 04:47:07 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3322A20897;
        Sun, 20 Sep 2020 08:47:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600591626;
        bh=eVe8YinMtI2dMDa4O8XZdud/EOS2AHiSaBq4i3l/pXs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=l5mpg2LA4Q9ZBmfrhUxMWUlwfkd3S3KMiyqm4UWBAF7WVSFIk1msArDvr2idO300A
         VrV4V+AxUXRqkEj6dsdgII5+WR1ij7nK28FQew9TvNqH2IN6FpnmYBRi7lRYXZkKuc
         FsSbbPTHzERTbXB/fkgtCVX2WMDi3e1ElSgWn58A=
Date:   Sun, 20 Sep 2020 10:47:02 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Oded Gabbay <oded.gabbay@gmail.com>,
        Leon Romanovsky <leon@kernel.org>,
        Gal Pressman <galpress@amazon.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, SW_Drivers <SW_Drivers@habana.ai>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-rdma@vger.kernel.org
Subject: Re: [PATCH v3 00/14] Adding GAUDI NIC code to habanalabs driver
Message-ID: <20200920084702.GA533114@kroah.com>
References: <CAFCwf10C1zm91e=tqPVGOX8kZD7o=AR2EW-P9VwCF4rcvnEJnA@mail.gmail.com>
 <20200918120340.GT869610@unreal>
 <CAFCwf12VPuyGFqFJK5D19zcKFQJ=fmzjwscdPG82tfR_v_h3Kg@mail.gmail.com>
 <20200918121905.GU869610@unreal>
 <20200919064020.GC439518@kroah.com>
 <20200919082003.GW869610@unreal>
 <20200919083012.GA465680@kroah.com>
 <CAFCwf122V-ep44Kqk1DgRJN+tq3ctxE9uVbqYL07apLkLe2Z7g@mail.gmail.com>
 <20200919172730.GC2733595@kroah.com>
 <20200919192235.GB8409@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200919192235.GB8409@ziepe.ca>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Sep 19, 2020 at 04:22:35PM -0300, Jason Gunthorpe wrote:
> On Sat, Sep 19, 2020 at 07:27:30PM +0200, Greg Kroah-Hartman wrote:
> > > It's probably heresy, but why do I need to integrate into the RDMA subsystem ?
> > > I understand your reasoning about networking (Ethernet) as the driver
> > > connects to the kernel networking stack (netdev), but with RDMA the
> > > driver doesn't use or connect to anything in that stack. If I were to
> > > support IBverbs and declare that I support it, then of course I would
> > > need to integrate to the RDMA subsystem and add my backend to
> > > rdma-core.
> > 
> > IBverbs are horrid and I would not wish them on anyone.  Seriously.
> 
> I'm curious what drives this opinion? Did you have it since you
> reviewed the initial submission all those years ago?

As I learned more about that interface, yes, I like it less and less :)

But that's the userspace api you all are stuck with, for various
reasons, my opinion doesn't matter here.

> > I think the general rdma apis are the key here, not the userspace api.
> 
> Are you proposing that habana should have uAPI in drivers/misc and
> present a standard rdma-core userspace for it? This is the only
> userspace programming interface for RoCE HW. I think that would be
> much more work.
> 
> If not, what open source userspace are you going to ask them to
> present to merge the kernel side into misc?

I don't think that they have a userspace api to their rdma feature from
what I understand, but I could be totally wrong as I do not know their
hardware at all, so I'll let them answer this question.

> > Note, I do not know exactly what they are, but no, IBverbs are not ok.
> 
> Should we stop merging new drivers and abandon the RDMA subsystem? Is
> there something you'd like to see fixed?
> 
> Don't really understand your position, sorry.

For anything that _has_ to have a userspace RMDA interface, sure ibverbs
are the one we are stuck with, but I didn't think that was the issue
here at all, which is why I wrote the above comments.

thanks,

greg k-h
