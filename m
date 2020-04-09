Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B6471A2D88
	for <lists+netdev@lfdr.de>; Thu,  9 Apr 2020 04:07:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726582AbgDICHF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Apr 2020 22:07:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:51618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726534AbgDICHE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Apr 2020 22:07:04 -0400
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B6EE92084D;
        Thu,  9 Apr 2020 02:07:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586398024;
        bh=8bIGHGZbWdXSvgVPWx0V/qBKUyOpvBK7s1uYkmA/j0A=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=iUl90g0lg/j/YXQTrmP+E/Jckk9/zshV5ao1z0NkiKt5kV83nO2/QLkMDyx0aIjTh
         03/2xOwO47Qqb7LOLq6ekDbFNKGVM/sQS2rprPAkt8gp+Ex1dQGM7rVk/9A6bVgF0D
         ZtJJPjO7ZK5eAoJ/M+VB/35ieJ0yLmWzWW3XEPe8=
Date:   Wed, 8 Apr 2020 19:07:01 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Parav Pandit <parav@mellanox.com>,
        "magnus.karlsson@intel.com" <magnus.karlsson@intel.com>
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
        "vikas.gupta@broadcom.com" <vikas.gupta@broadcom.com>
Subject: Re: [RFC] current devlink extension plan for NICs
Message-ID: <20200408190701.27a4ca4b@kicinski-fedora-PC1C0HJN>
In-Reply-To: <AM0PR05MB4866BDC1A2CB2218E2F3D056D1C00@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20200319192719.GD11304@nanopsycho.orion>
        <20200326144709.GW11304@nanopsycho.orion>
        <20200326145146.GX11304@nanopsycho.orion>
        <20200326133001.1b2694c9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20200327074736.GJ11304@nanopsycho.orion>
        <20200327093829.76140a98@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <35e8353f-2bfc-5685-a60e-030cd2d2dd24@mellanox.com>
        <20200330123623.634739de@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <50c0f739-592e-77a4-4872-878f99cc8b93@mellanox.com>
        <20200331103255.549ea899@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <AM0PR05MB4866E76AE83EA4D09449AF05D1C90@AM0PR05MB4866.eurprd05.prod.outlook.com>
        <20200401131231.74f2a5a8@kicinski-fedora-PC1C0HJN>
        <AM0PR05MB4866B13FF6B672469BDF4A3FD1C00@AM0PR05MB4866.eurprd05.prod.outlook.com>
        <20200408095914.772dfdf3@kicinski-fedora-PC1C0HJN>
        <AM0PR05MB4866BDC1A2CB2218E2F3D056D1C00@AM0PR05MB4866.eurprd05.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 8 Apr 2020 18:13:50 +0000 Parav Pandit wrote:
> > From: netdev-owner@vger.kernel.org <netdev-owner@vger.kernel.org> On
> > Behalf Of Jakub Kicinski
> > 
> > On Wed, 8 Apr 2020 05:07:04 +0000 Parav Pandit wrote:  
> > > > > > > 3. In future at eswitch pci port, I will be adding dpipe
> > > > > > > support for the internal flow tables done by the driver.
> > > > > > > 4. There were inconsistency among vendor drivers in
> > > > > > > using/abusing phys_port_name of the eswitch ports. This is
> > > > > > > consolidated via devlink port in core. This provides
> > > > > > > consistent view among all vendor drivers.
> > > > > > >
> > > > > > > So PCI eswitch side ports are useful regardless of slice.
> > > > > > >  
> > > > > > > >> Additionally devlink port object doesn't go through the
> > > > > > > >> same state machine as that what slice has to go through.
> > > > > > > >> So its weird that some devlink port has state machine and
> > > > > > > >> some doesn't.  
> > > > > > > >
> > > > > > > > You mean for VFs? I think you can add the states to the API.
> > > > > > > >  
> > > > > > > As we agreed above that eswitch side objects (devlink port and
> > > > > > > representor netdev) should not be used for 'portion of
> > > > > > > device',  
> > > > > >
> > > > > > We haven't agreed, I just explained how we differ.  
> > > > >
> > > > > You mentioned that " Right, in my mental model representor _is_ a
> > > > > port of the eswitch, so repr would not make sense to me."
> > > > >
> > > > > With that I infer that 'any object that is directly and _always_
> > > > > linked to eswitch and represents an eswitch port is out of
> > > > > question, this includes devlink port of eswitch and netdev
> > > > > representor. Hence, the comment 'we agree conceptually' to not
> > > > > involve devlink port of eswitch and representor netdev to represent  
> > 'portion of the device'.  
> > > >
> > > > I disagree, repr is one to one with eswitch port. Just because repr
> > > > is associated with a devlink port doesn't mean devlink port must be
> > > > associated with a repr or a netdev.  
> > > Devlink port which is on eswitch side is registered with switch_id and also  
> > linked to the rep netdev.  
> > > From this port phys_port_name is derived.
> > > This eswitch port shouldn't represent 'portion of the device'.  
> > 
> > switch_id is per port, so it's perfectly fine for a devlink port not to have one, or
> > for two ports of the same device to have a different ID.
> > 
> > The phys_port_name argument I don't follow. How does that matter in the
> > "should we create another object" debate?
> >   
> Its very clear in net/core/devlink.c code that a devlink port with a
> switch_id belongs to switch side and linked to eswitch representor
> netdev.
> 
> It just cannot/should not be overloaded to drive host side attributes.
>
> > IMO introducing the slice if it's 1:1 with ports is a no-go.   
> I disagree.
> With that argument devlink port for eswitch should not have existed and netdev should have been self-describing.
> But it is not done that way for 3 reasons I described already in this thread.
> Please get rid of devlink eswitch port and put all of it in representor netdev, after that 1:1 no-go point make sense. :-)
> 
> Also we already discussed that its not 1:1. A slice might not have devlink port.
> We don't want to start with lowest denominator and narrow use case.
> 
> I also described you that slice runs through state machine which devlink port doesn't.
> We don't want to overload devlink port object.
> 
> > I also don't like how
> > creating a slice implicitly creates a devlink port in your design. If those objects
> > are so strongly linked that creating one implies the other they should just be
> > merged.  
> I disagree.
> When netdev representor is created, its multiple health reporters (strongly linked) are created implicitly.
> We didn't merge and user didn't explicitly created them for right reasons.
> 
> A slice as described represents 'portion of a device'. As described in RFC, it's the master object for which other associated sub-objects gets created.
> Like an optional devlink port, representor, health reporters, resources.
> Again, it is not 1:1.
> 
> As Jiri described and you acked that devlink slice need not have to have a devlink port.
> 
> There are enough examples in devlink subsystem today where 1:1 and non 1:1 objects can be related.
> Shared buffers, devlink ports, health reporters, representors have such mapping with each other.

I'm not going to respond to any of that. We're going in circles.

I bet you remember the history of PCI ports, and my initial patch set.

We even had a call about this. Clearly all of it was a waste of time.

> > I'm also concerned that the slice is basically a non-networking port.  
> What is the concern?

What I wrote below, but you decided to split off in your reply for
whatever reason.

> How is shared-buffer, health reporter is attributed as networking object?

By non-networking I mean non-ethernet, or host facing. Which should be
clear from what I wrote below.

> > I bet some of the things we add there will one day be useful for networking or
> > DSA ports.
> >   
> I think this is mis-interpretation of a devlink slice object.
> All things we intent to do in devlink slice is useful for networking and non-networking use.
> So saying 'devlink slice is non networking port, hence it cannot be used for networking' -> is a wrong interpretation.
> 
> I do not understand DSA port much, but what blocks users to use slice if it fits the need in future.
> 
> How is shared buffer, health reporter are 'networking' object which exists under devlink, but not strictly under devlink port?

E.g. you ad rate limiting on the slice. That's something that may be
useful for other ingress points of the device. But it's added to the
slice, not the port. So we can't reuse the API for network ports.

> > So I'd suggest to maybe step back from the SmartNIC scenario and try to figure
> > out how slices are useful on their own.  
> I already went through the requirements, scenario, examples and use model in the RFC extension that describes 
> (a) how slice fits smartnic and non smartnic both cases.
> (b) how user gets same experience and commands regardless of use cases.
> 
> A 'good' in-kernel example where one object is overloaded to do multiple things would support a thought to overload devlink port.
> For example merge macvlan and vlan driver object to do both functionalities.
> An overloaded recently introduced qdisc to multiple things as another.
