Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32A272B567B
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 02:58:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727312AbgKQB6H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 20:58:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:34648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725730AbgKQB6G (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Nov 2020 20:58:06 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 19E5B24695;
        Tue, 17 Nov 2020 01:58:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605578285;
        bh=oS9w7EIRwo+eNpk8S2JJDNgGdmgbWQO5hv5dfDSBn6g=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=mqG7hc5Y2wmUN8h7uPZtf072XoMuLqd/2+MMedLe9/cbhbVD9mNRjOeloIAmLG0EI
         SF4PJeUrLaBo3EuFRmyhH6uFDv/k2jp3xdauDJnAhE5/JSt5tOF4Ee094ZtqvQJeZS
         IOU/Na5jKGiY+9jEnE5Ox9vjOOOMrvQZ/pAkSGMk=
Date:   Mon, 16 Nov 2020 17:58:04 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     Parav Pandit <parav@nvidia.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, gregkh@linuxfoundation.org,
        jiri@nvidia.com, jgg@nvidia.com, dledford@redhat.com,
        leonro@nvidia.com, davem@davemloft.net
Subject: Re: [PATCH net-next 00/13] Add mlx5 subfunction support
Message-ID: <20201116175804.15db0b67@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <cdd576ebad038a3a9801e7017b7794e061e3ddcc.camel@kernel.org>
References: <20201112192424.2742-1-parav@nvidia.com>
        <20201116145226.27b30b1f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <cdd576ebad038a3a9801e7017b7794e061e3ddcc.camel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 16 Nov 2020 16:06:02 -0800 Saeed Mahameed wrote:
> On Mon, 2020-11-16 at 14:52 -0800, Jakub Kicinski wrote:
> > On Thu, 12 Nov 2020 21:24:10 +0200 Parav Pandit wrote:  
> > > This series introduces support for mlx5 subfunction (SF).
> > > A subfunction is a portion of a PCI device that supports multiple
> > > classes of devices such as netdev, RDMA and more.
> > > 
> > > This patchset is based on Leon's series [3].
> > > It is a third user of proposed auxiliary bus [4].
> > > 
> > > Subfunction support is discussed in detail in RFC [1] and [2].
> > > RFC [1] and extension [2] describes requirements, design, and
> > > proposed
> > > plumbing using devlink, auxiliary bus and sysfs for systemd/udev
> > > support.  
> > 
> > So we're going to have two ways of adding subdevs? Via devlink and
> > via the new vdpa netlink thing?
> 
> Via devlink you add the Sub-function bus device - think of it as
> spawning a new VF - but has no actual characteristics
> (netdev/vpda/rdma) "yet" until user admin decides to load an interface
> on it via aux sysfs.

By which you mean it doesn't get probed or the device type is not set
(IOW it can still become a block device or netdev depending on the vdpa
request)?

> Basically devlink adds a new eswitch port (the SF port) and loading the
> drivers and the interfaces is done via the auxbus subsystem only after
> the SF is spawned by FW.

But why?

Is this for the SmartNIC / bare metal case? The flow for spawning on
the local host gets highly convoluted.

> > Also could you please wrap your code at 80 chars?
> 
> I prefer no to do this in mlx5, in mlx5 we follow a 95 chars rule.
> But if you insist :) .. 

Oh yeah, I meant the devlink patches!
