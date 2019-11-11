Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0D99F6D6E
	for <lists+netdev@lfdr.de>; Mon, 11 Nov 2019 04:57:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726951AbfKKD5T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Nov 2019 22:57:19 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:34737 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726765AbfKKD5T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Nov 2019 22:57:19 -0500
Received: by mail-pg1-f193.google.com with SMTP id z188so2651475pgb.1
        for <netdev@vger.kernel.org>; Sun, 10 Nov 2019 19:57:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=YfVuYLgFsEpOGQu1iZTYuor2PUz6WFlFBUTHRR4RFJc=;
        b=tY6Ijl+10E8NFBSUq4NC/e+tVpwHxHp2wAIO1EaR1ll/30Q7sQWqPL8Kq/YaNvRQWI
         te7LKUAkkoXlPSkKUaUUj+FUj309hiozjm4ozWAIHBrLQm0RApwb7377lycP/xEcgyRV
         O7qXArYDpns/P1zo16U36ifxA1rlTf/jw6F/NG/xAPlri1c0xpNGVmEfWBH4TqIEYPfG
         3auQKxYiWmr9VKheTpUGuNqFNJuAkhSUpXwiG42sauUCSmnJ0pEcXSgXzcvcgN9x7IGg
         sjv8IUrtdU0Eo92qu6Q3ODm/+J1yAYor+673i/pbPDNTEQJtq0j5fITVm/rCIWIJKpdW
         2Ntg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=YfVuYLgFsEpOGQu1iZTYuor2PUz6WFlFBUTHRR4RFJc=;
        b=b1p1vn1i5lchp/fd8gth7UEIZwShlxvxOo/AyTb4nQ3WJ82JcnkQJM+DExymTQNpqv
         sUz4AWCF2UBscS5YV2Fc5nzV1nPKYBCE+6cMrCT1uxYq8flOsKwcdnF7c/xvzvIOJnEL
         1IQJ/jm1fmgxVMUgMpc1KxEFxORkM6Xxs2nltCYQ1i6hq6j7Un66X4RrvIO6xQw9kpa8
         1b/Nb6yB0TkkDsO9Sm71461dlwIZ2nWiKqbI33W7S0vW3JxpU/AFxXEeAomEpIFAPlIR
         1bPNMWNeUPdlDO9Z5p2DXbJWjGXWhCjmI+dkLCQ/EpBUpdFEs6VBCFeS40Cl6cd5A9jb
         vhog==
X-Gm-Message-State: APjAAAWaXbRBFjHRuNjl6x1i88vLBwairGE2lvyf5eyUUvG7LeIAWZU6
        pCWTRiKTZ1MMJcq9L4CaTF6x5w==
X-Google-Smtp-Source: APXvYqymJTQdz+0DhInHQ6YlXFk7bO6AC+TYf7u51PP59HFRwi4q8qAsu6FIpFAQzXxrgx7gj5IfLg==
X-Received: by 2002:a17:90a:2064:: with SMTP id n91mr31812895pjc.41.1573444638273;
        Sun, 10 Nov 2019 19:57:18 -0800 (PST)
Received: from cakuba (c-73-202-202-92.hsd1.ca.comcast.net. [73.202.202.92])
        by smtp.gmail.com with ESMTPSA id w7sm14911956pfb.101.2019.11.10.19.57.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Nov 2019 19:57:18 -0800 (PST)
Date:   Sun, 10 Nov 2019 19:57:14 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Parav Pandit <parav@mellanox.com>, Jiri Pirko <jiri@resnulli.us>,
        David M <david.m.ertman@intel.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Or Gerlitz <gerlitz.or@gmail.com>
Subject: Re: [PATCH net-next 00/19] Mellanox, mlx5 sub function support
Message-ID: <20191110195714.6c42ad77@cakuba>
In-Reply-To: <20191110193759.GE31761@ziepe.ca>
References: <20191107160448.20962-1-parav@mellanox.com>
        <20191107153234.0d735c1f@cakuba.netronome.com>
        <20191108121233.GJ6990@nanopsycho>
        <20191108144054.GC10956@ziepe.ca>
        <AM0PR05MB486658D1D2A4F3999ED95D45D17B0@AM0PR05MB4866.eurprd05.prod.outlook.com>
        <20191108111238.578f44f1@cakuba>
        <20191108201253.GE10956@ziepe.ca>
        <20191108134559.42fbceff@cakuba>
        <20191109004426.GB31761@ziepe.ca>
        <20191109092747.26a1a37e@cakuba>
        <20191110193759.GE31761@ziepe.ca>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 10 Nov 2019 15:37:59 -0400, Jason Gunthorpe wrote:
> On Sat, Nov 09, 2019 at 09:27:47AM -0800, Jakub Kicinski wrote:
> > On Fri, 8 Nov 2019 20:44:26 -0400, Jason Gunthorpe wrote:  
> > > On Fri, Nov 08, 2019 at 01:45:59PM -0800, Jakub Kicinski wrote:  
> > > > Yes, my suggestion to use mdev was entirely based on the premise that
> > > > the purpose of this work is to get vfio working.. otherwise I'm unclear
> > > > as to why we'd need a bus in the first place. If this is just for
> > > > containers - we have macvlan offload for years now, with no need for a
> > > > separate device.    
> > > 
> > > This SF thing is a full fledged VF function, it is not at all like
> > > macvlan. This is perhaps less important for the netdev part of the
> > > world, but the difference is very big for the RDMA side, and should
> > > enable VFIO too..  
> > 
> > Well, macvlan used VMDq so it was pretty much a "legacy SR-IOV" VF.
> > I'd perhaps need to learn more about RDMA to appreciate the difference.  
> 
> It has a lot to do with the how the RDMA functionality works in the
> HW.. At least for mlx the RDMA is 'below' all the netdev stuff, so
> even though netdev has some offloaded vlan RDMA sees, essentially, the
> union of all the vlan's on the system.
> 
> Which at least breaks the security model of a macvlan device for
> net-namespaces.
> 
> Maybe with new HW something could be done, but today, the HW is
> limited.

Oh, I think we sort of talked past each other there.

I was just pointing to the fact that Intel's macvlan offload did well
without any fake bus or devices. I'm not saying anything about the
particulars of the virtualization from the networking perspective.

> > > > On the RDMA/Intel front, would you mind explaining what the main
> > > > motivation for the special buses is? I'm a little confurious.    
> > > 
> > > Well, the issue is driver binding. For years we have had these
> > > multi-function netdev drivers that have a single PCI device which must
> > > bind into multiple subsystems, ie mlx5 does netdev and RDMA, the cxgb
> > > drivers do netdev, RDMA, SCSI initiator, SCSI target, etc. [And I
> > > expect when NVMe over TCP rolls out we will have drivers like cxgb4
> > > binding to 6 subsytems in total!]  
> > 
> > What I'm missing is why is it so bad to have a driver register to
> > multiple subsystems.  
> 
> Well, for example, if you proposed to have a RDMA driver in
> drivers/net/ethernet/foo/, I would NAK it, and I hope Dave would
> too. Same for SCSI and nvme.
> 
> This Linux process is that driver code for a subsystem lives in the
> subsystem and should be in a subsystem specific module. While it is
> technically possible to have a giant driver, it distorts our process
> in a way I don't think is good.
> 
> So, we have software layers between the large Linux subsystems just to
> make the development side manageable and practical.
> 
> .. once the code lives in another subsystem, it is in a new module. A
> new module requires some way to connect them all together, the driver
> core is the logical way to do this connection.
> 
> I don't think a driver should be split beyond that. Even my suggestion
> of a 'core' may in practice just be the netdev driver as most of the
> other modules can't function without netdev. ie you can't do iSCSI
> without an IP stack.

Okay, yes, that's what I was expecting you'd say. I'm not 100%
convinced a bus is necessary, we lived long enough with drivers 
split across the tree...

> > > What is a generation? Mellanox has had a stable RDMA driver across
> > > many sillicon generations. Intel looks like their new driver will
> > > support at least the last two or more sillicon generations..
> > > 
> > > RDMA drivers are monstrous complex things, there is a big incentive to
> > > not respin them every time a new chip comes out.  
> > 
> > Ack, but then again none of the drivers gets rewritten from scratch,
> > right? It's not that some "sub-drivers" get reused and some not, no?  
> 
> Remarkably Intel is saying their new RDMA 'sub-driver' will be compatible
> with their ICE and pre-ICE (sorry, forget the names) netdev core
> drivers. 
> 
> netdev will get a different driver for each, but RDMA will use the
> same driver.

I see :)
