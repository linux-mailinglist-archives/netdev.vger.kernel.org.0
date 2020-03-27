Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03201195FF0
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 21:42:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727549AbgC0Umm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 16:42:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:45394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726959AbgC0Umm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Mar 2020 16:42:42 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 885B9206F1;
        Fri, 27 Mar 2020 20:42:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585341760;
        bh=rLqtH/0NTab9T90GNVYhHCNvi37Z0NkEaqy2vPHHLDc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Dp5T1qzMLzWlOe+WtIQdFd18yyd4RKL19eA2II1HcFkKdRS6QUaOFFE2UzXFExO1y
         RtWfwQyc26JSmslK3e+NVnLlMZ3O8/DIdcyJrtJY4+pA6X1zbo5dRQPyktn2M+oPnT
         OLWtE1BtWKoIeTt4euqet4k/6zDSxoBPCtk43Glw=
Date:   Fri, 27 Mar 2020 13:42:37 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     "sridhar.samudrala@intel.com" <sridhar.samudrala@intel.com>,
        Aya Levin <ayal@mellanox.com>,
        "andrew.gospodarek@broadcom.com" <andrew.gospodarek@broadcom.com>,
        "sburla@marvell.com" <sburla@marvell.com>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        Tariq Toukan <tariqt@mellanox.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Vlad Buslov <vladbu@mellanox.com>,
        "lihong.yang@intel.com" <lihong.yang@intel.com>,
        Ido Schimmel <idosch@mellanox.com>,
        "jgg@ziepe.ca" <jgg@ziepe.ca>,
        "fmanlunas@marvell.com" <fmanlunas@marvell.com>,
        "oss-drivers@netronome.com" <oss-drivers@netronome.com>,
        "leon@kernel.org" <leon@kernel.org>,
        Parav Pandit <parav@mellanox.com>,
        "grygorii.strashko@ti.com" <grygorii.strashko@ti.com>,
        "michael.chan@broadcom.com" <michael.chan@broadcom.com>,
        Alex Vesker <valex@mellanox.com>,
        "snelson@pensando.io" <snelson@pensando.io>,
        "linyunsheng@huawei.com" <linyunsheng@huawei.com>,
        "magnus.karlsson@intel.com" <magnus.karlsson@intel.com>,
        "dchickles@marvell.com" <dchickles@marvell.com>,
        "jacob.e.keller@intel.com" <jacob.e.keller@intel.com>,
        Moshe Shemesh <moshe@mellanox.com>,
        Mark Zhang <markz@mellanox.com>,
        "aelior@marvell.com" <aelior@marvell.com>,
        Yuval Avnery <yuvalav@mellanox.com>,
        "drivers@pensando.io" <drivers@pensando.io>,
        mlxsw <mlxsw@mellanox.com>,
        "GR-everest-linux-l2@marvell.com" <GR-everest-linux-l2@marvell.com>,
        Yevgeny Kliteynik <kliteyn@mellanox.com>,
        "vikas.gupta@broadcom.com" <vikas.gupta@broadcom.com>,
        Eran Ben Elisha <eranbe@mellanox.com>
Subject: Re: [RFC] current devlink extension plan for NICs
Message-ID: <20200327134237.00c21329@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <ea8a8434b1db2b692489edfd4abbc2274a77228c.camel@mellanox.com>
References: <20200319192719.GD11304@nanopsycho.orion>
        <20200319203253.73cca739@kicinski-fedora-PC1C0HJN>
        <20200320073555.GE11304@nanopsycho.orion>
        <20200320142508.31ff70f3@kicinski-fedora-PC1C0HJN>
        <20200321093525.GJ11304@nanopsycho.orion>
        <20200323122123.2a3ff20f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20200326144709.GW11304@nanopsycho.orion>
        <20200326145146.GX11304@nanopsycho.orion>
        <20200326133001.1b2694c9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20200327074736.GJ11304@nanopsycho.orion>
        <20200327093829.76140a98@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <a02cf0e6-98ad-65c4-0363-8fb9d67d2c9c@intel.com>
        <20200327121010.3e987488@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <ea8a8434b1db2b692489edfd4abbc2274a77228c.camel@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 27 Mar 2020 19:45:53 +0000 Saeed Mahameed wrote:
> On Fri, 2020-03-27 at 12:10 -0700, Jakub Kicinski wrote:
> > On Fri, 27 Mar 2020 11:49:10 -0700 Samudrala, Sridhar wrote:  
> > > On 3/27/2020 9:38 AM, Jakub Kicinski wrote:  
> > > > On Fri, 27 Mar 2020 08:47:36 +0100 Jiri Pirko wrote:    
> > > > > > So the queues, interrupts, and other resources are also part
> > > > > > of the slice then?    
> > > > > 
> > > > > Yep, that seems to make sense.
> > > > >    
> > > > > > How do slice parameters like rate apply to NVMe?    
> > > > > 
> > > > > Not really.
> > > > >    
> > > > > > Are ports always ethernet? and slices also cover endpoints
> > > > > > with
> > > > > > transport stack offloaded to the NIC?    
> > > > > 
> > > > > devlink_port now can be either "ethernet" or "infiniband".
> > > > > Perhaps,
> > > > > there can be port type "nve" which would contain only some of
> > > > > the
> > > > > config options and would not have a representor "netdev/ibdev"
> > > > > linked.
> > > > > I don't know.    
> > > > 
> > > > I honestly find it hard to understand what that slice abstraction
> > > > is,
> > > > and which things belong to slices and which to PCI ports (or why
> > > > we even
> > > > have them).    
> > > 
> > > Looks like slice is a new term for sub function and we can consider
> > > this
> > > as a VMDQ VSI(intel terminology) or even a Queue group of a VSI.
> > > 
> > > Today we expose VMDQ VSI via offloaded MACVLAN. This mechanism
> > > should 
> > > allow us to expose it as a separate netdev.  
> > 
> > Kinda. Looks like with the new APIs you guys will definitely be able
> > to
> > expose VMDQ as a full(er) device, and if memory serves me well that's
> > what you wanted initially.
> 
> VMDQ is just a steering based isolated set of rx tx rings pointed at by
> a dumb steering rule in the HW .. i am not sure we can just wrap them
> in their own vendor specific netdev and just call it a slice..
> 
> from what i understand, a real slice is a full isolated HW pipeline
> with its own HW resources and HW based isolation, a slice rings/hw
> resources can never be shared between different slices, just like a vf,
> but without the pcie virtual function back-end..
> 
> Why would you need a devlink slice instance for something that has only
> rx/tx rings attributes ? if we are going with such design, then i guess
> a simple rdma app with a pair of QPs can call itself a slice .. 

Ack, I'm not sure where Intel is, but I'd hope since VMDq in its
"just a bunch of queues with dumb steering" form was created in
igb/ixgbe days, 2 generations of HW later its not just that..

> We need a clear-cut definition of what a Sub-function slice is.. this
> RFC doesn't seem to address that clearly.

Definitely. I'd say we need a clear definition of (a) what a
sub-functions is, and (b) what a slice is.

> > But the sub-functions are just a subset of slices, PF and VFs also
> > have a slice associated with them.. And all those things have a port,
> > too.
> >   
> 
> PFs/VFs, might have more than one port sometimes .. 

Like I said below, right? So in that case do you think they should have
multiple slices, too, or slice per port?

> > > > With devices like NFP and Mellanox CX3 which have one PCI PF
> > > > maybe it
> > > > would have made sense to have a slice that covers multiple ports,
> > > > but
> > > > it seems the proposal is to have port to slice mapping be 1:1.
> > > > And rate
> > > > in those devices should still be per port not per slice.
> > > > 
> > > > But this keeps coming back, and since you guys are doing all the
> > > > work,
> > > > if you really really need it..    
