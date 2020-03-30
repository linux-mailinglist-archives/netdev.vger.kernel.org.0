Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF44C198489
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 21:36:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728465AbgC3Tg1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 15:36:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:34516 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726981AbgC3Tg1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Mar 2020 15:36:27 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B7C9D20714;
        Mon, 30 Mar 2020 19:36:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585596985;
        bh=LZ5q7SHOhG/rtHYkbrNjLmyajlEHbW9RQvUH67ItjTs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=k+K9tLnen7+Sk+/zW7F7hWKYXgztxgTNXYYhURYoWiVFcvk9h2MDXJPqoS//PGnpo
         ygJbwqnOFKb6Vbmq/u+nPQYTPIP4N3rzPllJtMIclBK1P62qMQj98nGN8JW/mMq8b3
         GU1zyAEKgKmEl60nqqzGYT6dD89KOlfiUzfhDVjo=
Date:   Mon, 30 Mar 2020 12:36:23 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Parav Pandit <parav@mellanox.com>
Cc:     Jiri Pirko <jiri@resnulli.us>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Yuval Avnery <yuvalav@mellanox.com>,
        "jgg@ziepe.ca" <jgg@ziepe.ca>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "andrew.gospodarek@broadcom.com" <andrew.gospodarek@broadcom.com>,
        "michael.chan@broadcom.com" <michael.chan@broadcom.com>,
        Moshe Shemesh <moshe@mellanox.com>,
        Aya Levin <ayal@mellanox.com>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        Yevgeny Kliteynik <kliteyn@mellanox.com>,
        "dchickles@marvell.com" <dchickles@marvell.com>,
        "sburla@marvell.com" <sburla@marvell.com>,
        "fmanlunas@marvell.com" <fmanlunas@marvell.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        "oss-drivers@netronome.com" <oss-drivers@netronome.com>,
        "snelson@pensando.io" <snelson@pensando.io>,
        "drivers@pensando.io" <drivers@pensando.io>,
        "aelior@marvell.com" <aelior@marvell.com>,
        "GR-everest-linux-l2@marvell.com" <GR-everest-linux-l2@marvell.com>,
        "grygorii.strashko@ti.com" <grygorii.strashko@ti.com>,
        mlxsw <mlxsw@mellanox.com>, Ido Schimmel <idosch@mellanox.com>,
        Mark Zhang <markz@mellanox.com>,
        "jacob.e.keller@intel.com" <jacob.e.keller@intel.com>,
        Alex Vesker <valex@mellanox.com>,
        "linyunsheng@huawei.com" <linyunsheng@huawei.com>,
        "lihong.yang@intel.com" <lihong.yang@intel.com>,
        "vikas.gupta@broadcom.com" <vikas.gupta@broadcom.com>,
        "magnus.karlsson@intel.com" <magnus.karlsson@intel.com>
Subject: Re: [RFC] current devlink extension plan for NICs
Message-ID: <20200330123623.634739de@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <35e8353f-2bfc-5685-a60e-030cd2d2dd24@mellanox.com>
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
        <35e8353f-2bfc-5685-a60e-030cd2d2dd24@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 30 Mar 2020 07:48:39 +0000 Parav Pandit wrote:
> On 3/27/2020 10:08 PM, Jakub Kicinski wrote:
> > On Fri, 27 Mar 2020 08:47:36 +0100 Jiri Pirko wrote:  
> >>> So the queues, interrupts, and other resources are also part 
> >>> of the slice then?    
> >>
> >> Yep, that seems to make sense.
> >>  
> >>> How do slice parameters like rate apply to NVMe?    
> >>
> >> Not really.
> >>  
> >>> Are ports always ethernet? and slices also cover endpoints with
> >>> transport stack offloaded to the NIC?    
> >>
> >> devlink_port now can be either "ethernet" or "infiniband". Perhaps,
> >> there can be port type "nve" which would contain only some of the
> >> config options and would not have a representor "netdev/ibdev" linked.
> >> I don't know.  
> > 
> > I honestly find it hard to understand what that slice abstraction is,
> > and which things belong to slices and which to PCI ports (or why we even
> > have them).
> >   
> In an alternative, devlink port can be overloaded/retrofit to do all
> things that slice desires to do.

I wouldn't say retrofitted, in my mind port has always been a port of 
a device.

Jiri explained to me that to Mellanox port is port of a eswitch, not
port of a device. While to me (/Netronome) it was any way to send or
receive data to/from the device.

Now I understand why to you nvme doesn't fit the port abstraction.

> For that matter representor netdev can be overloaded/extended to do what
> slice desire to do (instead of devlink port).

Right, in my mental model representor _is_ a port of the eswitch, so
repr would not make sense to me.

> Can you please explain why you think devlink port should be overloaded
> instead of netdev or any other kernel object?
> Do you have an example of such overloaded functionality of a kernel object?
> Like why macvlan and vlan drivers are not combined to in single driver
> object? Why teaming and bonding driver are combined in single driver
> object?...

I think it's not overloading, but the fact that we started with
different definitions. We (me and you) tried adding the PCIe ports
around the same time, I guess we should have dug into the details
right away.

> User should be able to create, configure, deploy, delete a 'portion of
> the device' with/without eswitch.

Right, to me ports are of the device, not eswitch.

> We shouldn't be starting with restrictive/narrow view of devlink port.
> 
> Internally with Jiri and others, we also explored the possibility to
> have 'mgmtvf', 'mgmtpf',  'mgmtsf' port flavours by overloading port to
> do all things as that of slice.
> It wasn't elegant enough. Why not create right object?

We just need clear definitions of what goes where. We already have
params etc. hanging off the ports, including irq/sriov stuff. But in
slice model those don't belong there :S

In fact very little belongs to the port in that model. So why have
PCI ports in the first place?

> Additionally devlink port object doesn't go through the same state
> machine as that what slice has to go through.
> So its weird that some devlink port has state machine and some doesn't.

You mean for VFs? I think you can add the states to the API.

> > With devices like NFP and Mellanox CX3 which have one PCI PF maybe it
> > would have made sense to have a slice that covers multiple ports, but
> > it seems the proposal is to have port to slice mapping be 1:1. And rate
> > in those devices should still be per port not per slice.
> >   
> Slice can have multiple ports. slice object doesn't restrict it. User
> can always split the port for a device, if device support it.

Okay, so slices are not 1:1 with ports, then?  Is it any:any?

> > But this keeps coming back, and since you guys are doing all the work,
> > if you really really need it..
