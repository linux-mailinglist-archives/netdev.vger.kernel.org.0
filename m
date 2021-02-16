Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5583831CB9D
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 15:13:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230021AbhBPOMu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 09:12:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:60048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229924AbhBPOMt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Feb 2021 09:12:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D4A5E64DFF;
        Tue, 16 Feb 2021 14:12:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613484727;
        bh=VoIJw8IV2XhrWH31y5xWJWmLam8wK4EdSN+YNIWdN1o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TTZpZlQq6dBehVZjmUZ+w7XtEDgI4xaCIIu5EgD5p/b9YKKMcPhYZlKTX6y7CBHUS
         gusm7fgk6DK1io3RrYGEVr6kGZ08ssCLIO6zxFANjNbEQ7jO4tUrUrwXELRsU95hR9
         dmU3GBb4+2fx3BMoeEH8oi/0ZV/f4k6EnYwQUfKYjq9Hpgl7e2ba+d0p/UiN5f6HhK
         5oSYZla7F+4lGZAhzl8mSYITKH3ql0VZ+2tBe1oHqSP6L3zZS5gh+Hk7HnrFwSLU8y
         UNMADbz0Q9l7BmU0OmNLSqUpyyeSPCEdO0V5/OT6zi7Rxs2njWkZ5BniZ7N/LlKD2P
         zkM39EvSBIRdg==
Date:   Tue, 16 Feb 2021 16:12:03 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Saeed Mahameed <saeed@kernel.org>,
        Doug Ledford <dledford@redhat.com>,
        Aharon Landau <aharonl@nvidia.com>, linux-rdma@vger.kernel.org,
        Maor Gottlieb <maorg@nvidia.com>, netdev@vger.kernel.org
Subject: Re: [PATCH rdma-next 0/2] Real time/free running timestamp support
Message-ID: <YCvSs7VKA7s4d4n9@unreal>
References: <20210209131107.698833-1-leon@kernel.org>
 <20210212181056.GB1737478@nvidia.com>
 <5d4731e2394049ca66012f82e1645bdec51aca78.camel@kernel.org>
 <20210212211408.GA1860468@nvidia.com>
 <53a97eb379af167c0221408a07c9bddc6624027d.camel@kernel.org>
 <20210212212153.GX4247@nvidia.com>
 <YCjF/xxC3/easKYC@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YCjF/xxC3/easKYC@unreal>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 14, 2021 at 08:41:03AM +0200, Leon Romanovsky wrote:
> On Fri, Feb 12, 2021 at 05:21:53PM -0400, Jason Gunthorpe wrote:
> > On Fri, Feb 12, 2021 at 01:19:09PM -0800, Saeed Mahameed wrote:
> > > On Fri, 2021-02-12 at 17:14 -0400, Jason Gunthorpe wrote:
> > > > On Fri, Feb 12, 2021 at 01:09:20PM -0800, Saeed Mahameed wrote:
> > > > > On Fri, 2021-02-12 at 14:10 -0400, Jason Gunthorpe wrote:
> > > > > > On Tue, Feb 09, 2021 at 03:11:05PM +0200, Leon Romanovsky wrote:
> > > > > > > From: Leon Romanovsky <leonro@nvidia.com>
> > > > > > >
> > > > > > > Add an extra timestamp format for mlx5_ib device.
> > > > > > >
> > > > > > > Thanks
> > > > > > >
> > > > > > > Aharon Landau (2):
> > > > > > >   net/mlx5: Add new timestamp mode bits
> > > > > > >   RDMA/mlx5: Fail QP creation if the device can not support the
> > > > > > > CQE
> > > > > > > TS
> > > > > > >
> > > > > > >  drivers/infiniband/hw/mlx5/qp.c | 104
> > > > > > > +++++++++++++++++++++++++++++---
> > > > > > >  include/linux/mlx5/mlx5_ifc.h   |  54 +++++++++++++++--
> > > > > > >  2 files changed, 145 insertions(+), 13 deletions(-)
> > > > > >
> > > > > > Since this is a rdma series, and we are at the end of the cycle,
> > > > > > I
> > > > > > took the IFC file directly to the rdma tree instead of through
> > > > > > the
> > > > > > shared branch.
> > > > > >
> > > > > > Applied to for-next, thanks
> > > > > >
> > > > >
> > > > > mmm, i was planing to resubmit this patch with the netdev real time
> > > > > support series, since the uplink representor is getting delayed, I
> > > > > thought I could submit the real time stuff today. can you wait on
> > > > > the
> > > > > ifc patch, i will re-send it today if you will, but it must go
> > > > > through
> > > > > the shared branch
> > > >
> > > > Friday of rc7 is a bit late to be sending new patches for the first
> > > > time, isn't it??
> > >
> > > I know, uplink representor last minute mess !
> > >
> > > >
> > > > But sure, if you update the shared branch right now I'll fix up
> > > > rdma.git
> > > >
> > >
> > > I can't put it in the shared brach without review, i will post it to
> > > the netdev/rdma lists for two days at least for review and feedback.
> >
> > Well, I'm not going to take any different patches beyond right now
> > unless Linus does a rc8??
> >
> > Just move this one IFC patch to the shared branch, it is obviously OK
>
> OK, I'm curious to see the end result of all this last minute adventure.

Jason,

I took first patch to the shared branch.
a6a217dddcd5 net/mlx5: Add new timestamp mode bits

Thanks

>
> Thanks
>
> >
> > Jason
