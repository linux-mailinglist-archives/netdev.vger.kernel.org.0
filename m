Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 404DB2B5587
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 01:06:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730819AbgKQAGF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 19:06:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:58726 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730227AbgKQAGE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Nov 2020 19:06:04 -0500
Received: from lt-jalone-7480.mtl.com (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A4A3A2464E;
        Tue, 17 Nov 2020 00:06:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605571564;
        bh=/qXy6iUBieTcbNx34GG4h+99G17GpKF65fFvPR8ZISs=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=xvSP9MaVW5Qsl9+5O1UGaNDk7UqnN239ypi/TLGWN8NqKFrsXVnX/gd5mZwNn1PTH
         i3BWUvZAfpHYvH4579vX76QrJ8AyrtlJgtAJgrGhXjRZfcJ93N6jwCExUff3jPpVPK
         crppCmqvrEJHCbdzJx+GVF4V7h0ME0zvkQ+yvpHY=
Message-ID: <cdd576ebad038a3a9801e7017b7794e061e3ddcc.camel@kernel.org>
Subject: Re: [PATCH net-next 00/13] Add mlx5 subfunction support
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>, Parav Pandit <parav@nvidia.com>
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        gregkh@linuxfoundation.org, jiri@nvidia.com, jgg@nvidia.com,
        dledford@redhat.com, leonro@nvidia.com, davem@davemloft.net
Date:   Mon, 16 Nov 2020 16:06:02 -0800
In-Reply-To: <20201116145226.27b30b1f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20201112192424.2742-1-parav@nvidia.com>
         <20201116145226.27b30b1f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2020-11-16 at 14:52 -0800, Jakub Kicinski wrote:
> On Thu, 12 Nov 2020 21:24:10 +0200 Parav Pandit wrote:
> > This series introduces support for mlx5 subfunction (SF).
> > A subfunction is a portion of a PCI device that supports multiple
> > classes of devices such as netdev, RDMA and more.
> > 
> > This patchset is based on Leon's series [3].
> > It is a third user of proposed auxiliary bus [4].
> > 
> > Subfunction support is discussed in detail in RFC [1] and [2].
> > RFC [1] and extension [2] describes requirements, design, and
> > proposed
> > plumbing using devlink, auxiliary bus and sysfs for systemd/udev
> > support.
> 
> So we're going to have two ways of adding subdevs? Via devlink and
> via
> the new vdpa netlink thing?
> 

Via devlink you add the Sub-function bus device - think of it as
spawning a new VF - but has no actual characteristics
(netdev/vpda/rdma) "yet" until user admin decides to load an interface
on it via aux sysfs.

Basically devlink adds a new eswitch port (the SF port) and loading the
drivers and the interfaces is done via the auxbus subsystem only after
the SF is spawned by FW.


> Question number two - is this supposed to be ready to be applied to
> net-next? It seems there is a conflict.
> 

This series requires other mlx5 and auxbus infrastructure dependencies
that was already submitted by leon 2-3 weeks ago and pending Greg's
review, once finalized it will be merged into mlx5-next, then I will
ask you to pull mlx5-next and only after, you can apply this series
cleanly to net-next, sorry for the mess but we had to move forward and
show how auxdev subsystem is being actually used.

Leon's series:
https://patchwork.ozlabs.org/project/netdev/cover/20201101201542.2027568-1-leon@kernel.org/

> Also could you please wrap your code at 80 chars?
> 

I prefer no to do this in mlx5, in mlx5 we follow a 95 chars rule.
But if you insist :) .. 

Thanks,
Saeed.


