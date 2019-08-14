Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7FE238D43E
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 15:09:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727848AbfHNNJQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 09:09:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36986 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725800AbfHNNJQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Aug 2019 09:09:16 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 700243BEA7;
        Wed, 14 Aug 2019 13:09:15 +0000 (UTC)
Received: from gondolin (dhcp-192-232.str.redhat.com [10.33.192.232])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BE3278386E;
        Wed, 14 Aug 2019 13:09:13 +0000 (UTC)
Date:   Wed, 14 Aug 2019 15:09:11 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Parav Pandit <parav@mellanox.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "cjia@nvidia.com" <cjia@nvidia.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH v2 0/2] Simplify mtty driver and mdev core
Message-ID: <20190814150911.296da78c.cohuck@redhat.com>
In-Reply-To: <AM0PR05MB4866ABFDDD9DDCBC01F6CA90D1AD0@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20190802065905.45239-1-parav@mellanox.com>
        <20190808141255.45236-1-parav@mellanox.com>
        <20190808170247.1fc2c4c4@x1.home>
        <77ffb1f8-e050-fdf5-e306-0a81614f7a88@nvidia.com>
        <AM0PR05MB4866993536C0C8ACEA2F92DBD1D20@AM0PR05MB4866.eurprd05.prod.outlook.com>
        <20190813085246.1d642ae5@x1.home>
        <AM0PR05MB48663579A340E6597B3D01BCD1D20@AM0PR05MB4866.eurprd05.prod.outlook.com>
        <20190813111149.027c6a3c@x1.home>
        <AM0PR05MB4866D40F8EBB382C78193C91D1AD0@AM0PR05MB4866.eurprd05.prod.outlook.com>
        <20190814100135.1f60aa42.cohuck@redhat.com>
        <AM0PR05MB4866ABFDDD9DDCBC01F6CA90D1AD0@AM0PR05MB4866.eurprd05.prod.outlook.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.27]); Wed, 14 Aug 2019 13:09:15 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 14 Aug 2019 12:27:01 +0000
Parav Pandit <parav@mellanox.com> wrote:

> + Jiri, + netdev 
> To get perspective on the ndo->phys_port_name for the representor netdev of mdev.
> 
> Hi Cornelia,
> 
> > -----Original Message-----
> > From: Cornelia Huck <cohuck@redhat.com>
> > Sent: Wednesday, August 14, 2019 1:32 PM
> > To: Parav Pandit <parav@mellanox.com>
> > Cc: Alex Williamson <alex.williamson@redhat.com>; Kirti Wankhede
> > <kwankhede@nvidia.com>; kvm@vger.kernel.org; linux-
> > kernel@vger.kernel.org; cjia@nvidia.com
> > Subject: Re: [PATCH v2 0/2] Simplify mtty driver and mdev core
> > 
> > On Wed, 14 Aug 2019 05:54:36 +0000
> > Parav Pandit <parav@mellanox.com> wrote:
> >   
> > > > > I get that part. I prefer to remove the UUID itself from the
> > > > > structure and therefore removing this API makes lot more sense?  
> > > >
> > > > Mdev and support tools around mdev are based on UUIDs because it's  
> > defined  
> > > > in the documentation.  
> > > When we introduce newer device naming scheme, it will update the  
> > documentation also.  
> > > May be that is the time to move to .rst format too.  
> > 
> > You are aware that there are existing tools that expect a uuid naming scheme,
> > right?
> >   
> Yes, Alex mentioned too.
> The good tool that I am aware of is [1], which is 4 months old. Not sure if it is part of any distros yet.
> 
> README also says, that it is in 'early in development. So we have scope to improve it for non UUID names, but lets discuss that more below.

The up-to-date reference for mdevctl is
https://github.com/mdevctl/mdevctl. There is currently an effort to get
this packaged in Fedora.

> 
> > >  
> > > > I don't think it's as simple as saying "voila, UUID dependencies are
> > > > removed, users are free to use arbitrary strings".  We'd need to
> > > > create some kind of naming policy, what characters are allows so
> > > > that we can potentially expand the creation parameters as has been
> > > > proposed a couple times, how do we deal with collisions and races,
> > > > and why should we make such a change when a UUID is a perfectly
> > > > reasonable devices name.  Thanks,
> > > >  
> > > Sure, we should define a policy on device naming to be more relaxed.
> > > We have enough examples in-kernel.
> > > Few that I am aware of are netdev (vxlan, macvlan, ipvlan, lot more), rdma  
> > etc which has arbitrary device names and ID based device names.  
> > >
> > > Collisions and race is already taken care today in the mdev core. Same  
> > unique device names continue.
> > 
> > I'm still completely missing a rationale _why_ uuids are supposedly
> > bad/restricting/etc.  
> There is nothing bad about uuid based naming.
> Its just too long name to derive phys_port_name of a netdev.
> In details below.
> 
> For a given mdev of networking type, we would like to have 
> (a) representor netdevice [2] 
> (b) associated devlink port [3]
> 
> Currently these representor netdevice exist only for the PCIe SR-IOV VFs.
> It is further getting extended for mdev without SR-IOV.
> 
> Each of the devlink port is attached to representor netdevice [4].
> 
> This netdevice phys_port_name should be a unique derived from some property of mdev.
> Udev/systemd uses phys_port_name to derive unique representor netdev name.
> This netdev name is further use by orchestration and switching software in user space.
> One such distro supported switching software is ovs [4], which relies on the persistent device name of the representor netdevice.

Ok, let me rephrase this to check that I understand this correctly. I'm
not sure about some of the terms you use here (even after looking at
the linked doc/code), but that's probably still ok.

We want to derive an unique (and probably persistent?) netdev name so
that userspace can refer to a representor netdevice. Makes sense.
For generating that name, udev uses the phys_port_name (which
represents the devlink port, IIUC). Also makes sense.

> 
> phys_port_name has limitation to be only 15 characters long.
> UUID doesn't fit in phys_port_name.

Understood. But why do we need to derive the phys_port_name from the
mdev device name? This netdevice use case seems to be just one use case
for using mdev devices? If this is a specialized mdev type for this
setup, why not just expose a shorter identifier via an extra attribute?

> Longer UUID names are creating snow ball effect, not just in networking stack but many user space tools too.

This snowball effect mainly comes from the device name ->
phys_port_name setup, IIUC.

> (as opposed to recently introduced mdevctl, are they more mdev tools which has dependency on UUID name?)

I am aware that people have written scripts etc. to manage their mdevs.
Given that the mdev infrastructure has been around for quite some time,
I'd say the chance of some of those scripts relying on uuid names is
non-zero.

> 
> Instead of mdev subsystem creating such effect, one option we are considering is to have shorter mdev names.
> (Similar to netdev, rdma, nvme devices).
> Such as mdev1, mdev2000 etc.
> 
> Second option I was considering is to have an optional alias for UUID based mdev.
> This name alias is given at time of mdev creation.
> Devlink port's phys_port_name is derived out of this shorter mdev name alias.
> This way, mdev remains to be UUID based with optional extension.
> However, I prefer first option to relax mdev naming scheme.

Actually, I think that second option makes much more sense, as you
avoid potentially breaking existing tooling.

> 
> > We want to uniquely identify a device, across different
> > types of vendor drivers. An uuid is a unique identifier and even a well-defined
> > one. Tools (e.g. mdevctl) are relying on it for mdev devices today.
> > 
> > What is the problem you're trying to solve?  
> Unique device naming is still achieved without UUID scheme by various subsystems in kernel using alpha-numeric string.
> Having such string based continue to provide unique names.
> 
> I hope I described the problem and two solutions above.
> 
> [1] https://github.com/awilliam/mdevctl
> [2] https://elixir.bootlin.com/linux/v5.3-rc4/source/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
> [3] http://man7.org/linux/man-pages/man8/devlink-port.8.html
> [4] https://elixir.bootlin.com/linux/v5.3-rc4/source/net/core/devlink.c#L6921
> [5] https://www.openvswitch.org/
> 

