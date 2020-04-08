Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B63F21A279E
	for <lists+netdev@lfdr.de>; Wed,  8 Apr 2020 18:59:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729436AbgDHQ7T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Apr 2020 12:59:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:47904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728966AbgDHQ7T (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Apr 2020 12:59:19 -0400
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6B58F20757;
        Wed,  8 Apr 2020 16:59:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586365158;
        bh=K2RdMZ6ZhSGxxEAjYA1jEozwMp9Q32OYBGd5JyJ1hxI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=HGvuFv44IUDaTVa01Kwo+lBCAwCr35nBto8tpIh5PdBETAkbU0+d+BogNU5pNuzLp
         VeXiQiNkuTVQCzqPM9YM6bt+R+XqFntVWfPCQpaNm/CiqDmH2/zDkfVEZJfiIbO2+k
         eEBjQ/hOUpdvGI44oqCeG0I7Svi6mbrT7Q6DWQo8=
Date:   Wed, 8 Apr 2020 09:59:14 -0700
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
Message-ID: <20200408095914.772dfdf3@kicinski-fedora-PC1C0HJN>
In-Reply-To: <AM0PR05MB4866B13FF6B672469BDF4A3FD1C00@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20200319192719.GD11304@nanopsycho.orion>
        <20200320142508.31ff70f3@kicinski-fedora-PC1C0HJN>
        <20200321093525.GJ11304@nanopsycho.orion>
        <20200323122123.2a3ff20f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 8 Apr 2020 05:07:04 +0000 Parav Pandit wrote:
> > > > > 3. In future at eswitch pci port, I will be adding dpipe support
> > > > > for the internal flow tables done by the driver.
> > > > > 4. There were inconsistency among vendor drivers in using/abusing
> > > > > phys_port_name of the eswitch ports. This is consolidated via
> > > > > devlink port in core. This provides consistent view among all
> > > > > vendor drivers.
> > > > >
> > > > > So PCI eswitch side ports are useful regardless of slice.
> > > > >  
> > > > > >> Additionally devlink port object doesn't go through the same
> > > > > >> state machine as that what slice has to go through.
> > > > > >> So its weird that some devlink port has state machine and some
> > > > > >> doesn't.  
> > > > > >
> > > > > > You mean for VFs? I think you can add the states to the API.
> > > > > >  
> > > > > As we agreed above that eswitch side objects (devlink port and
> > > > > representor netdev) should not be used for 'portion of device',  
> > > >
> > > > We haven't agreed, I just explained how we differ.  
> > >
> > > You mentioned that " Right, in my mental model representor _is_ a port
> > > of the eswitch, so repr would not make sense to me."
> > >
> > > With that I infer that 'any object that is directly and _always_
> > > linked to eswitch and represents an eswitch port is out of question,
> > > this includes devlink port of eswitch and netdev representor. Hence,
> > > the comment 'we agree conceptually' to not involve devlink port of
> > > eswitch and representor netdev to represent 'portion of the device'.  
> > 
> > I disagree, repr is one to one with eswitch port. Just because repr is
> > associated with a devlink port doesn't mean devlink port must be associated
> > with a repr or a netdev.  
> Devlink port which is on eswitch side is registered with switch_id and also linked to the rep netdev.
> From this port phys_port_name is derived.
> This eswitch port shouldn't represent 'portion of the device'.

switch_id is per port, so it's perfectly fine for a devlink port not to
have one, or for two ports of the same device to have a different ID.

The phys_port_name argument I don't follow. How does that matter in the
"should we create another object" debate?

IMO introducing the slice if it's 1:1 with ports is a no-go. I also
don't like how creating a slice implicitly creates a devlink port in
your design. If those objects are so strongly linked that creating one
implies the other they should just be merged.

I'm also concerned that the slice is basically a non-networking port.
I bet some of the things we add there will one day be useful for
networking or DSA ports.

So I'd suggest to maybe step back from the SmartNIC scenario and try to
figure out how slices are useful on their own.
