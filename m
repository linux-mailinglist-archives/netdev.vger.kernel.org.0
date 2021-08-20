Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDBE73F2CC3
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 15:06:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240688AbhHTNHY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 09:07:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:43508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238220AbhHTNHX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Aug 2021 09:07:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F0D3460E9B;
        Fri, 20 Aug 2021 13:06:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629464805;
        bh=MJCKak8iu2aRCur+cdjp5giWug9nUW1JObsOHl8vAEY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jmw/qIdKwngMp+B9XaaobJVAWRsCAdk3fvxp7b01ZtwaFX5YJDgwtO99vk++8Ucph
         o3XYQN3dUXg4064KbVPgP064D7ROf2ipoB4t20fHf/66Nv88PtPep2FufmAEtYKP0z
         DPOVbF+kCWLQMMl40ig/EB2ioPljRocDXWppzKTay9D4i2zx1euZE0MtI+PY4xrMjr
         UV31w5hrvAOzf3BYk2mpKTHEjyVN5nwTQobBpz62uXQ4eydwgBRQLxE0+OCdryb2r6
         QZLHNU4Vf4DRmXTF2L8z1uoUyxkqzwLOz8T80C3njYJpkojZAZ2TNFRw7D48ggzHhi
         KJc/E0spPlx7Q==
Date:   Fri, 20 Aug 2021 16:06:41 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     "Keller, Jacob E" <jacob.e.keller@intel.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Jiri Pirko <jiri@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Salil Mehta <salil.mehta@huawei.com>,
        Shannon Nelson <snelson@pensando.io>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Yufeng Mo <moyufeng@huawei.com>
Subject: Re: [PATCH net-next 3/6] devlink: Count struct devlink consumers
Message-ID: <YR+o4cNFfg1JqDvJ@unreal>
References: <cover.1628933864.git.leonro@nvidia.com>
 <d4d59d801f4521e562c9ecf2d8767077aaefb456.1628933864.git.leonro@nvidia.com>
 <20210816084741.1dd1c415@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YRqKCVbjTZaSrSy+@unreal>
 <20210816090700.313a54ba@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CO1PR11MB50895F0BA3FE20CD92D79CB6D6FD9@CO1PR11MB5089.namprd11.prod.outlook.com>
 <YRzA3zCKCgAtprwc@unreal>
 <CO1PR11MB5089A7B1E36B763F075E09FFD6FF9@CO1PR11MB5089.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CO1PR11MB5089A7B1E36B763F075E09FFD6FF9@CO1PR11MB5089.namprd11.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 18, 2021 at 05:50:11PM +0000, Keller, Jacob E wrote:
> 
> 
> > -----Original Message-----
> > From: Leon Romanovsky <leon@kernel.org>
> > Sent: Wednesday, August 18, 2021 1:12 AM
> > To: Keller, Jacob E <jacob.e.keller@intel.com>
> > Cc: Jakub Kicinski <kuba@kernel.org>; David S . Miller <davem@davemloft.net>;
> > Guangbin Huang <huangguangbin2@huawei.com>; Jiri Pirko <jiri@nvidia.com>;
> > linux-kernel@vger.kernel.org; netdev@vger.kernel.org; Salil Mehta
> > <salil.mehta@huawei.com>; Shannon Nelson <snelson@pensando.io>; Yisen
> > Zhuang <yisen.zhuang@huawei.com>; Yufeng Mo <moyufeng@huawei.com>
> > Subject: Re: [PATCH net-next 3/6] devlink: Count struct devlink consumers
> > 
> > On Mon, Aug 16, 2021 at 09:32:17PM +0000, Keller, Jacob E wrote:
> > >
> > >
> > > > -----Original Message-----
> > > > From: Jakub Kicinski <kuba@kernel.org>
> > > > Sent: Monday, August 16, 2021 9:07 AM
> > > > To: Leon Romanovsky <leon@kernel.org>
> > > > Cc: David S . Miller <davem@davemloft.net>; Guangbin Huang
> > > > <huangguangbin2@huawei.com>; Keller, Jacob E <jacob.e.keller@intel.com>;
> > Jiri
> > > > Pirko <jiri@nvidia.com>; linux-kernel@vger.kernel.org;
> > netdev@vger.kernel.org;
> > > > Salil Mehta <salil.mehta@huawei.com>; Shannon Nelson
> > > > <snelson@pensando.io>; Yisen Zhuang <yisen.zhuang@huawei.com>; Yufeng
> > > > Mo <moyufeng@huawei.com>
> > > > Subject: Re: [PATCH net-next 3/6] devlink: Count struct devlink consumers
> > > >
> > > > On Mon, 16 Aug 2021 18:53:45 +0300 Leon Romanovsky wrote:
> > > > > On Mon, Aug 16, 2021 at 08:47:41AM -0700, Jakub Kicinski wrote:
> > > > > > On Sat, 14 Aug 2021 12:57:28 +0300 Leon Romanovsky wrote:
> > > > > > > From: Leon Romanovsky <leonro@nvidia.com>
> > > > > > >
> > > > > > > The struct devlink itself is protected by internal lock and doesn't
> > > > > > > need global lock during operation. That global lock is used to protect
> > > > > > > addition/removal new devlink instances from the global list in use by
> > > > > > > all devlink consumers in the system.
> > > > > > >
> > > > > > > The future conversion of linked list to be xarray will allow us to
> > > > > > > actually delete that lock, but first we need to count all struct devlink
> > > > > > > users.
> > > > > >
> > > > > > Not a problem with this set but to state the obvious the global devlink
> > > > > > lock also protects from concurrent execution of all the ops which don't
> > > > > > take the instance lock (DEVLINK_NL_FLAG_NO_LOCK). You most likely
> > know
> > > > > > this but I thought I'd comment on an off chance it helps.
> > > > >
> > > > > The end goal will be something like that:
> > > > > 1. Delete devlink lock
> > > > > 2. Rely on xa_lock() while grabbing devlink instance (past devlink_try_get)
> > > > > 3. Convert devlink->lock to be read/write lock to make sure that we can run
> > > > > get query in parallel.
> > > > > 4. Open devlink netlink to parallel ops, ".parallel_ops = true".
> > > >
> > > > IIUC that'd mean setting eswitch mode would hold write lock on
> > > > the dl instance. What locks does e.g. registering a dl port take
> > > > then?
> > >
> > > Also that I think we have some cases where we want to allow the driver to
> > allocate new devlink objects in response to adding a port, but still want to block
> > other global operations from running?
> > 
> > I don't see the flow where operations on devlink_A should block devlink_B.
> > Only in such flows we will need global lock like we have now - devlink->lock.
> > In all other flows, write lock of devlink instance will protect from
> > parallel execution.
> > 
> > Thanks
> 
> 
> But how do we handle what is essentially recursion?

Let's wait till implementation, I promise it will be covered :).

> 
> If we add a port on the devlink A:
> 
> userspace sends PORT_ADD for devlink A
> driver responds by creating a port
> adding a port causes driver to add a region, or other devlink object
> 
> In the current design, if I understand correctly, we hold the global lock but *not* the instance lock. We can't hold the instance lock while adding port without breaking a bunch of drivers that add many devlink objects in response to port creation.. because they'll deadlock when going to add the sub objects.
> 
> But if we don't hold the global lock, then in theory another userspace program could attempt to do something inbetween PORT_ADD starting and finishing which might not be desirable.  (Remember, we had to drop the instance lock otherwise drivers get stuck when trying to add many subobjects)

You just surfaced my main issue with the current devlink
implementation - the purpose of devlink_lock. Over the years devlink
code lost clear separation between user space flows and kernel flows.

Thanks

> 
> Thanks,
> Jake
