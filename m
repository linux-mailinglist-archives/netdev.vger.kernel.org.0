Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1EAD13D6A6
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 10:20:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729138AbgAPJUS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 04:20:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:45708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726684AbgAPJUR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 04:20:17 -0500
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A75A520748;
        Thu, 16 Jan 2020 09:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579166417;
        bh=K+yVyVnPlO7hd4U7qSo55sqeMNoALJ9OWNERlyDia4k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=W1GNQ78CKpj33R/OW4Wvm4DAUFoGxmSHjuJpvMDa5TpdOR+p7gHVWC9sE8WtFx3n1
         AN9F7hcAu6J6t0A59mgM2OTmHOEMJ1ukYKq/BPfTdUeixFKdsZXK9FcpDbI5HyuQcG
         SKQBpS+zO3LkRs8d/BmyDAdBuRrBlLK2nIGCIUks=
Date:   Thu, 16 Jan 2020 11:20:08 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Yishai Hadas <yishaih@mellanox.com>, linux-rdma@vger.kernel.org,
        dledford@redhat.com, saeedm@mellanox.com, maorg@mellanox.com,
        michaelgur@mellanox.com, netdev@vger.kernel.org
Subject: Re: [PATCH rdma-next 00/10] Relaxed ordering memory regions
Message-ID: <20200116092008.GB6853@unreal>
References: <1578506740-22188-1-git-send-email-yishaih@mellanox.com>
 <20200115180848.GA13397@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200115180848.GA13397@ziepe.ca>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 15, 2020 at 02:08:48PM -0400, Jason Gunthorpe wrote:
> On Wed, Jan 08, 2020 at 08:05:30PM +0200, Yishai Hadas wrote:
> > This series adds an ioctl command to allocate an async event file followed by a
> > new ioctl command to get a device context.
> >
> > The get device context command enables reading some core generic capabilities
> > such as supporting an optional MR access flags by IB core and its related
> > drivers.
> >
> > Once the above is enabled, a new optional MR access flag named
> > IB_UVERBS_ACCESS_RELAXED_ORDERING is added and is used by mlx5 driver.
> >
> > This optional flag allows creation of relaxed ordering memory regions.  Access
> > through such MRs can improve performance by allowing the system to reorder
> > certain accesses.
> >
> > As relaxed ordering is an optimization, drivers that do not support it can
> > simply ignore it.
> >
> > Note: This series relies on the 'Refactoring FD usage' series [1] that was sent
> > to rdma-next.
> > [1] https://patchwork.kernel.org/project/linux-rdma/list/?series=225541
> >
> > Yishai
> >
> > Jason Gunthorpe (3):
> >   RDMA/core: Add UVERBS_METHOD_ASYNC_EVENT_ALLOC
> >   RDMA/core: Remove ucontext_lock from the uverbs_destry_ufile_hw() path
> >   RDMA/uverbs: Add ioctl command to get a device context
> >
> > Michael Guralnik (7):
> >   net/mlx5: Expose relaxed ordering bits
> >   RDMA/uverbs: Verify MR access flags
> >   RDMA/core: Add optional access flags range
> >   RDMA/efa: Allow passing of optional access flags for MR registration
> >   RDMA/uverbs: Add new relaxed ordering memory region access flag
> >   RDMA/core: Add the core support field to METHOD_GET_CONTEXT
> >   RDMA/mlx5: Set relaxed ordering when requested
>
> This looks OK, can you update the shared branch please

Thanks, applied
f4db8e8b0dc3 net/mlx5: Expose relaxed ordering bits

>
> Thanks,
> Jason
