Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E574B2758
	for <lists+netdev@lfdr.de>; Fri, 13 Sep 2019 23:33:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389915AbfIMVcu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Sep 2019 17:32:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35002 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388719AbfIMVct (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Sep 2019 17:32:49 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 06AA11DA4;
        Fri, 13 Sep 2019 21:32:49 +0000 (UTC)
Received: from x1.home (ovpn-118-102.phx2.redhat.com [10.3.118.102])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 590CE5D71C;
        Fri, 13 Sep 2019 21:32:48 +0000 (UTC)
Date:   Fri, 13 Sep 2019 15:32:47 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Parav Pandit <parav@mellanox.com>
Cc:     Jiri Pirko <jiri@mellanox.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH v3 0/5] Introduce variable length mdev alias
Message-ID: <20190913153247.0309d016@x1.home>
In-Reply-To: <AM0PR05MB48667E374853D485788D8159D1B10@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20190826204119.54386-1-parav@mellanox.com>
        <20190902042436.23294-1-parav@mellanox.com>
        <AM0PR05MB4866F76F807409ED887537D7D1B70@AM0PR05MB4866.eurprd05.prod.outlook.com>
        <20190911145610.453b32ec@x1.home>
        <AM0PR05MB48668DFF8E816F0D2D3041BFD1B10@AM0PR05MB4866.eurprd05.prod.outlook.com>
        <AM0PR05MB48667E374853D485788D8159D1B10@AM0PR05MB4866.eurprd05.prod.outlook.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.71]); Fri, 13 Sep 2019 21:32:49 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 11 Sep 2019 16:38:49 +0000
Parav Pandit <parav@mellanox.com> wrote:

> > -----Original Message-----
> > From: linux-kernel-owner@vger.kernel.org <linux-kernel-  
> > owner@vger.kernel.org> On Behalf Of Parav Pandit  
> > Sent: Wednesday, September 11, 2019 10:31 AM
> > To: Alex Williamson <alex.williamson@redhat.com>
> > Cc: Jiri Pirko <jiri@mellanox.com>; kwankhede@nvidia.com;
> > cohuck@redhat.com; davem@davemloft.net; kvm@vger.kernel.org; linux-
> > kernel@vger.kernel.org; netdev@vger.kernel.org
> > Subject: RE: [PATCH v3 0/5] Introduce variable length mdev alias
> > 
> > Hi Alex,
> >   
> > > -----Original Message-----
> > > From: Alex Williamson <alex.williamson@redhat.com>
> > > Sent: Wednesday, September 11, 2019 8:56 AM
> > > To: Parav Pandit <parav@mellanox.com>
> > > Cc: Jiri Pirko <jiri@mellanox.com>; kwankhede@nvidia.com;
> > > cohuck@redhat.com; davem@davemloft.net; kvm@vger.kernel.org; linux-
> > > kernel@vger.kernel.org; netdev@vger.kernel.org
> > > Subject: Re: [PATCH v3 0/5] Introduce variable length mdev alias
> > >
> > > On Mon, 9 Sep 2019 20:42:32 +0000
> > > Parav Pandit <parav@mellanox.com> wrote:
> > >  
> > > > Hi Alex,
> > > >  
> > > > > -----Original Message-----
> > > > > From: Parav Pandit <parav@mellanox.com>
> > > > > Sent: Sunday, September 1, 2019 11:25 PM
> > > > > To: alex.williamson@redhat.com; Jiri Pirko <jiri@mellanox.com>;
> > > > > kwankhede@nvidia.com; cohuck@redhat.com; davem@davemloft.net
> > > > > Cc: kvm@vger.kernel.org; linux-kernel@vger.kernel.org;
> > > > > netdev@vger.kernel.org; Parav Pandit <parav@mellanox.com>
> > > > > Subject: [PATCH v3 0/5] Introduce variable length mdev alias
> > > > >
> > > > > To have consistent naming for the netdevice of a mdev and to have
> > > > > consistent naming of the devlink port [1] of a mdev, which is
> > > > > formed using phys_port_name of the devlink port, current UUID is
> > > > > not usable because UUID is too long.
> > > > >
> > > > > UUID in string format is 36-characters long and in binary 128-bit.
> > > > > Both formats are not able to fit within 15 characters limit of
> > > > > netdev  
> > > name.  
> > > > >
> > > > > It is desired to have mdev device naming consistent using UUID.
> > > > > So that widely used user space framework such as ovs [2] can make
> > > > > use of mdev representor in similar way as PCIe SR-IOV VF and PF  
> > > representors.  
> > > > >
> > > > > Hence,
> > > > > (a) mdev alias is created which is derived using sha1 from the
> > > > > mdev  
> > > name.  
> > > > > (b) Vendor driver describes how long an alias should be for the
> > > > > child mdev created for a given parent.
> > > > > (c) Mdev aliases are unique at system level.
> > > > > (d) alias is created optionally whenever parent requested.
> > > > > This ensures that non networking mdev parents can function without
> > > > > alias creation overhead.
> > > > >
> > > > > This design is discussed at [3].
> > > > >
> > > > > An example systemd/udev extension will have,
> > > > >
> > > > > 1. netdev name created using mdev alias available in sysfs.
> > > > >
> > > > > mdev UUID=83b8f4f2-509f-382f-3c1e-e6bfe0fa1001
> > > > > mdev 12 character alias=cd5b146a80a5
> > > > >
> > > > > netdev name of this mdev = enmcd5b146a80a5 Here en = Ethernet link
> > > > > m = mediated device
> > > > >
> > > > > 2. devlink port phys_port_name created using mdev alias.
> > > > > devlink phys_port_name=pcd5b146a80a5
> > > > >
> > > > > This patchset enables mdev core to maintain unique alias for a mdev.
> > > > >
> > > > > Patch-1 Introduces mdev alias using sha1.
> > > > > Patch-2 Ensures that mdev alias is unique in a system.
> > > > > Patch-3 Exposes mdev alias in a sysfs hirerchy, update
> > > > > Documentation
> > > > > Patch-4 Introduces mdev_alias() API.
> > > > > Patch-5 Extends mtty driver to optionally provide alias generation.
> > > > > This also enables to test UUID based sha1 collision and trigger
> > > > > error handling for duplicate sha1 results.
> > > > >
> > > > > [1] http://man7.org/linux/man-pages/man8/devlink-port.8.html
> > > > > [2] https://docs.openstack.org/os-vif/latest/user/plugins/ovs.html
> > > > > [3] https://patchwork.kernel.org/cover/11084231/
> > > > >
> > > > > ---
> > > > > Changelog:
> > > > > v2->v3:
> > > > >  - Addressed comment from Yunsheng Lin
> > > > >  - Changed strcmp() ==0 to !strcmp()
> > > > >  - Addressed comment from Cornelia Hunk
> > > > >  - Merged sysfs Documentation patch with syfs patch
> > > > >  - Added more description for alias return value  
> > > >
> > > > Did you get a chance review this updated series?
> > > > I addressed Cornelia's and yours comment.
> > > > I do not think allocating alias memory twice, once for comparison
> > > > and once for storing is good idea or moving alias generation logic
> > > > inside the mdev_list_lock(). So I didn't address that suggestion of  
> > Cornelia.  
> > >
> > > Sorry, I'm at LPC this week.  I agree, I don't think the double
> > > allocation is necessary, I thought the comment was sufficient to
> > > clarify null'ing the variable.  It's awkward, but seems correct.
> > >
> > > I'm not sure what we do with this patch series though, has the real
> > > consumer of this even been proposed?    
> 
> Jiri already acked to use mdev_alias() to generate phys_port_name several days back in the discussion we had in [1].
> After concluding in the thread [1], I proceed with mdev_alias().
> mlx5_core patches are not yet present on netdev mailing list, but we
> all agree to use it in mdev_alias() in devlink phys_port_name
> generation. So we have collective agreement on how to proceed
> forward. I wasn't probably clear enough in previous email reply about
> it, so adding link here.
> 
> [1] https://patchwork.kernel.org/cover/11084231/#22838955

Jiri may have agreed to the concept, but without patches on the list
proving an end to end solution, I think it's too early for us to commit
to this by preemptively adding it to our API.  "Acked" and "collective
agreement" seem like they overstate something that seems not to have
seen the light of day yet.  Instead I'll say, it looks reasonable, come
back when the real consumer has actually been proposed upstream and has
more buy-in from the community and we'll see if it still looks like the
right approach from an mdev perspective then.  Thanks,

Alex
