Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CD7D26AFB3
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 23:39:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728145AbgIOVin (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 17:38:43 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:37286 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728109AbgIOVhz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Sep 2020 17:37:55 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kIIdr-00EpFF-Qz; Tue, 15 Sep 2020 23:37:35 +0200
Date:   Tue, 15 Sep 2020 23:37:35 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Oded Gabbay <oded.gabbay@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, SW_Drivers <SW_Drivers@habana.ai>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-rdma@vger.kernel.org
Subject: Re: [PATCH v3 00/14] Adding GAUDI NIC code to habanalabs driver
Message-ID: <20200915213735.GG3526428@lunn.ch>
References: <20200915171022.10561-1-oded.gabbay@gmail.com>
 <20200915133556.21268811@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAFCwf12XZRxLYifSfuB+RGhuiKBytzsUTOnEa6FqfJHYvcVJPQ@mail.gmail.com>
 <20200915140418.4afbc1eb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAFCwf10+_hQOSH4Ot+keE9Tc+ybupvp5JyUhFbvfoy6HseVyZg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFCwf10+_hQOSH4Ot+keE9Tc+ybupvp5JyUhFbvfoy6HseVyZg@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> I completely understand but you didn't answer my question. How come
> there are drivers which create netdev objects, and specifically sgi-xp
> in misc (but I also saw it in usb drivers) that live outside
> drivers/net ? Why doesn't your request apply to them as well ?
> When we wrote the code, we saw those examples and therefore assumed it was fine.

commit 45d9ca492e4bd1522d1b5bd125c2908f1cee3d4a
Author: Dean Nelson <dcn@sgi.com>
Date:   Tue Apr 22 14:46:56 2008 -0500

    [IA64] move XP and XPC to drivers/misc/sgi-xp
    
    Move XPC and XPNET from arch/ia64/sn/kernel to drivers/misc/sgi-xp.
    
    Signed-off-by: Dean Nelson <dcn@sgi.com>
    Signed-off-by: Tony Luck <tony.luck@intel.com>

It has been there a long time, and no networking person was involved
in its move.

drivers/usb/gadget/function/f_ncm.c
commit 00a2430ff07d4e0e0e7e24e02fd8adede333b797
Author: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
Date:   Tue Jul 15 13:09:46 2014 +0200

    usb: gadget: Gadget directory cleanup - group usb functions
    
    The drivers/usb/gadget directory contains many files.
    Files which are related can be distributed into separate directories.
    This patch moves the USB functions implementations into a separate directory.
    
    Signed-off-by: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
    Signed-off-by: Felipe Balbi <balbi@ti.com>

Again, old.

Can you find an example of a network driver added in the last couple
of years outside of drivers/met?

> > > > Please make sure to CC linux-rdma. You clearly stated that the device
> > > > does RDMA-like transfers.
> > >
> > > We don't use the RDMA infrastructure in the kernel and we can't
> > > connect to it due to the lack of H/W support we have so I don't see
> > > why we need to CC linux-rdma.
> >
> > You have it backward. You don't get to pick and choose which parts of
> > the infrastructure you use, and therefore who reviews your drivers.
> > The device uses RDMA under the hood so Linux RDMA experts must very
> > much be okay with it getting merged. That's how we ensure Linux
> > interfaces are consistent and good quality.
> 
> I understand your point of view but If my H/W doesn't support the
> basic requirements of the RDMA infrastructure and interfaces, then
> really there is nothing I can do about it. I can't use them.

It is up to the RDMA people to say that. They might see how the RDMA
core can be made to work for your hardware.

     Andrew
