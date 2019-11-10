Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EFB86F6B21
	for <lists+netdev@lfdr.de>; Sun, 10 Nov 2019 20:38:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727032AbfKJTiE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Nov 2019 14:38:04 -0500
Received: from mail-qk1-f193.google.com ([209.85.222.193]:39356 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726778AbfKJTiE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Nov 2019 14:38:04 -0500
Received: by mail-qk1-f193.google.com with SMTP id 15so9479782qkh.6
        for <netdev@vger.kernel.org>; Sun, 10 Nov 2019 11:38:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=0vZwFYOuDdSX+7LqpPDPzgdJy0sWXL92EwHEmSxoTbk=;
        b=ilk0ThIpMHJ2/wyFwEppEi+xbC659+fRET4PBQYY3RV4LEEyhC/3rEtDrGtvK6zZ+6
         Q0xkcdu/NecJcrkyfRok20OQlTWoPXdj1zmHkPwOWf4tECFfPE1Bi18HegedyAg7YPMN
         zgpqcegLO4AQNWDqpTUyqexFpdBNYHJXHehs+beL2E9NToCqoW/WZ5E3Cc7mLeIKzhV5
         uD2YEsunwEMaNxQTxhdG3Fu78UqAqPq+q4jTieUvxL6gNKM4Y23ps7vUcAEXoQqO3djG
         RUH5Hek0RKbOhMHTgAl7K5fup0nraKbMxTUGcqmuU6x82YFbZJg7xGgrecs44eMfdLsQ
         T/uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=0vZwFYOuDdSX+7LqpPDPzgdJy0sWXL92EwHEmSxoTbk=;
        b=c1syrtb1ozctBD5japC+9LVoNjAARAyps7DWA/KXPq/ZPzGK6ZLVk7b9VVMvROa0Oy
         VRjE+WVYpU2AelwN1+D8KEIY2fs3w6SFKP7L9rRv1Hz5at5MEgulS0Xsz25tB/FR370D
         2+fHlf2kb3/Hc30P5q8wea5YBgXgrydQwjWGWa3la5kqo718Bl8YNNO5LNqAVDpDlSxE
         HPyS1/iLk+gU+6NZ3HlhVjePv4bBaBUoSSX5c+DfQsMHM8enKfK2R1bbs+5L+PYa7ptS
         4a4JOlSnqz0QR6VI25XiL7G/CeKhRtn+MjLkrraHHAoavO5NFvwoIeCrSGwaMJ1jzgdN
         s9fA==
X-Gm-Message-State: APjAAAVP7Cg48rY+gfjZg+OID3WiWDMaPYIIHMSFjfmR8qEYRth6+Mzl
        7w1B6S3nnELzlCgePqRgxn2ZkQ==
X-Google-Smtp-Source: APXvYqwKmNJyGpWeMlAXSChz0a9yOQh5O0eCYSigMHS7jzPwZyfdvLoYTZdk5uoPdhtJBWKmhgyKaQ==
X-Received: by 2002:a05:620a:16bb:: with SMTP id s27mr2516614qkj.501.1573414681721;
        Sun, 10 Nov 2019 11:38:01 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-162-113-180.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.113.180])
        by smtp.gmail.com with ESMTPSA id i10sm5712127qtj.19.2019.11.10.11.38.00
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 10 Nov 2019 11:38:00 -0800 (PST)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1iTt27-0004PL-NN; Sun, 10 Nov 2019 15:37:59 -0400
Date:   Sun, 10 Nov 2019 15:37:59 -0400
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
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
Message-ID: <20191110193759.GE31761@ziepe.ca>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191109092747.26a1a37e@cakuba>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 09, 2019 at 09:27:47AM -0800, Jakub Kicinski wrote:
> On Fri, 8 Nov 2019 20:44:26 -0400, Jason Gunthorpe wrote:
> > On Fri, Nov 08, 2019 at 01:45:59PM -0800, Jakub Kicinski wrote:
> > > Yes, my suggestion to use mdev was entirely based on the premise that
> > > the purpose of this work is to get vfio working.. otherwise I'm unclear
> > > as to why we'd need a bus in the first place. If this is just for
> > > containers - we have macvlan offload for years now, with no need for a
> > > separate device.  
> > 
> > This SF thing is a full fledged VF function, it is not at all like
> > macvlan. This is perhaps less important for the netdev part of the
> > world, but the difference is very big for the RDMA side, and should
> > enable VFIO too..
> 
> Well, macvlan used VMDq so it was pretty much a "legacy SR-IOV" VF.
> I'd perhaps need to learn more about RDMA to appreciate the difference.

It has a lot to do with the how the RDMA functionality works in the
HW.. At least for mlx the RDMA is 'below' all the netdev stuff, so
even though netdev has some offloaded vlan RDMA sees, essentially, the
union of all the vlan's on the system.

Which at least breaks the security model of a macvlan device for
net-namespaces.

Maybe with new HW something could be done, but today, the HW is
limited.

> > > On the RDMA/Intel front, would you mind explaining what the main
> > > motivation for the special buses is? I'm a little confurious.  
> > 
> > Well, the issue is driver binding. For years we have had these
> > multi-function netdev drivers that have a single PCI device which must
> > bind into multiple subsystems, ie mlx5 does netdev and RDMA, the cxgb
> > drivers do netdev, RDMA, SCSI initiator, SCSI target, etc. [And I
> > expect when NVMe over TCP rolls out we will have drivers like cxgb4
> > binding to 6 subsytems in total!]
> 
> What I'm missing is why is it so bad to have a driver register to
> multiple subsystems.

Well, for example, if you proposed to have a RDMA driver in
drivers/net/ethernet/foo/, I would NAK it, and I hope Dave would
too. Same for SCSI and nvme.

This Linux process is that driver code for a subsystem lives in the
subsystem and should be in a subsystem specific module. While it is
technically possible to have a giant driver, it distorts our process
in a way I don't think is good.

So, we have software layers between the large Linux subsystems just to
make the development side manageable and practical.

.. once the code lives in another subsystem, it is in a new module. A
new module requires some way to connect them all together, the driver
core is the logical way to do this connection.

I don't think a driver should be split beyond that. Even my suggestion
of a 'core' may in practice just be the netdev driver as most of the
other modules can't function without netdev. ie you can't do iSCSI
without an IP stack.

> > What is a generation? Mellanox has had a stable RDMA driver across
> > many sillicon generations. Intel looks like their new driver will
> > support at least the last two or more sillicon generations..
> > 
> > RDMA drivers are monstrous complex things, there is a big incentive to
> > not respin them every time a new chip comes out.
> 
> Ack, but then again none of the drivers gets rewritten from scratch,
> right? It's not that some "sub-drivers" get reused and some not, no?

Remarkably Intel is saying their new RDMA 'sub-driver' will be compatible
with their ICE and pre-ICE (sorry, forget the names) netdev core
drivers. 

netdev will get a different driver for each, but RDMA will use the
same driver.

Jason
