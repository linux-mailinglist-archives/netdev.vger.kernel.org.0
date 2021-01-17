Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D29792F9100
	for <lists+netdev@lfdr.de>; Sun, 17 Jan 2021 06:47:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727480AbhAQFqy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Jan 2021 00:46:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:47468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726144AbhAQFoy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 17 Jan 2021 00:44:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 942F223107;
        Sun, 17 Jan 2021 05:44:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610862253;
        bh=t147Aw4VB3ANVuaNuXbIKiB3aS8IyLYJnfJNaTe2FZA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UosgCwiP68BAEk14QB82cnV0dC0YvYJ0zWPBn4nKi1rkot42iM0PL2dfTosQxg+YV
         Sv61mhLxu5se9usdtG2ZHxWYjdgJUZKwl4pX93pdcTILUyPWMXfluZKMmYAx253qGN
         fSvFGDM2N2yg6mC5qwArONcxJ2eTjIQMU7eieOsSdfyNEH4WvqevIvM9EwTTajYfO7
         Sp9swakhRnYovi7HoW3+3sXoqoN+EiHNLeFK+iEBdobNkO0h8nUDrqA+mPWMvE7xly
         8FLJJkDNsrXU+d2lOEHaVIx15XcPfDhmgiq2F4Zg25Ig6VHnX5rp4eGT4QcStEpdW9
         4H7B6Ptf2ah1w==
Date:   Sun, 17 Jan 2021 07:44:09 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Bjorn Helgaas <bhelgaas@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>, linux-pci@vger.kernel.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        Don Dutile <ddutile@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Alexander Duyck <alexander.duyck@gmail.com>
Subject: Re: [PATCH mlx5-next v2 0/5] Dynamically assign MSI-X vectors count
Message-ID: <20210117054409.GQ944463@unreal>
References: <20210114103140.866141-1-leon@kernel.org>
 <20210114095128.0f388f08@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210114095128.0f388f08@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 14, 2021 at 09:51:28AM -0800, Jakub Kicinski wrote:
> On Thu, 14 Jan 2021 12:31:35 +0200 Leon Romanovsky wrote:
> > The number of MSI-X vectors is PCI property visible through lspci, that
> > field is read-only and configured by the device.
> >
> > The static assignment of an amount of MSI-X vectors doesn't allow utilize
> > the newly created VF because it is not known to the device the future load
> > and configuration where that VF will be used.
> >
> > The VFs are created on the hypervisor and forwarded to the VMs that have
> > different properties (for example number of CPUs).
> >
> > To overcome the inefficiency in the spread of such MSI-X vectors, we
> > allow the kernel to instruct the device with the needed number of such
> > vectors, before VF is initialized and bounded to the driver.
>
>
> Hi Leon!
>
> Looks like you got some missing kdoc here, check out the test in
> patchwork so we don't need to worry about this later:
>
> https://patchwork.kernel.org/project/netdevbpf/list/?series=414497

Thanks Jakub,

I'll add kdocs to internal mlx5 functions.
IMHO, they are useless.

Thanks
