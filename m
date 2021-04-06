Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82D13354CEC
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 08:29:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244007AbhDFG3A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 02:29:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:44028 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237859AbhDFG26 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Apr 2021 02:28:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BE35D61165;
        Tue,  6 Apr 2021 06:28:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617690530;
        bh=6qxictHF+/YqQWcR0awtfiLtRYlib8mn/Dx9axjfKg4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=i+8SC5R9QYYvQwgkzuDT4QnqR/LHddWxuZum0T0C3kxd6raLjcbfF1cvFl2Cec8Xm
         KhScYX6h4r8XG5j8aUB+B2/jprzuuPXY9FqnyK2nKPB+vdLVfp9goj46Wy4uHK+0Ra
         PZddOiDso6XZJeBYLq1uIw9rM48AGuy05sSGnzMZFNrnyCjZMGJCv51xn7hMBg++CF
         +dca19jOJJKcipn2OWRYvnKC9ngkedpdr+ZBuojGR6Bu10dtubDRP/koLNLtLoA/lF
         akfcfAruTov/1lG+Q+agKfPbZvwxlR1hCjO5x/uMyewyKscMUk4082lcCbzP0vJ/16
         lfXW6Ibhc0a6A==
Date:   Tue, 6 Apr 2021 09:28:46 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Tom Talpey <tom@talpey.com>
Cc:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Avihai Horon <avihaih@nvidia.com>,
        Adit Ranadive <aditr@vmware.com>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        Ariel Elior <aelior@marvell.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Bernard Metzler <bmt@zurich.ibm.com>,
        Christoph Hellwig <hch@lst.de>,
        Chuck Lever <chuck.lever@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Devesh Sharma <devesh.sharma@broadcom.com>,
        Faisal Latif <faisal.latif@intel.com>,
        Jack Wang <jinpu.wang@ionos.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Jens Axboe <axboe@fb.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Keith Busch <kbusch@kernel.org>, Lijun Ou <oulijun@huawei.com>,
        linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-nfs@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-rdma@vger.kernel.org, linux-s390@vger.kernel.org,
        Max Gurtovoy <maxg@mellanox.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        "Md. Haris Iqbal" <haris.iqbal@ionos.com>,
        Michael Guralnik <michaelgur@nvidia.com>,
        Michal Kalderon <mkalderon@marvell.com>,
        Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>,
        Naresh Kumar PBS <nareshkumar.pbs@broadcom.com>,
        netdev@vger.kernel.org, Potnuri Bharat Teja <bharat@chelsio.com>,
        rds-devel@oss.oracle.com, Sagi Grimberg <sagi@grimberg.me>,
        samba-technical@lists.samba.org,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        Selvin Xavier <selvin.xavier@broadcom.com>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        Somnath Kotur <somnath.kotur@broadcom.com>,
        Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>,
        Steve French <sfrench@samba.org>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        VMware PV-Drivers <pv-drivers@vmware.com>,
        Weihang Li <liweihang@huawei.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Zhu Yanjun <zyjzyj2000@gmail.com>
Subject: Re: [PATCH rdma-next 02/10] RDMA/core: Enable Relaxed Ordering in
 __ib_alloc_pd()
Message-ID: <YGv/nne+E5xXHsME@unreal>
References: <20210405052404.213889-1-leon@kernel.org>
 <20210405052404.213889-3-leon@kernel.org>
 <befc60f3-d28a-5420-b381-0f408bd7cca9@talpey.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <befc60f3-d28a-5420-b381-0f408bd7cca9@talpey.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 05, 2021 at 02:01:16PM -0400, Tom Talpey wrote:
> On 4/5/2021 1:23 AM, Leon Romanovsky wrote:
> > From: Avihai Horon <avihaih@nvidia.com>
> > 
> > Enable Relaxed Ordering in __ib_alloc_pd() allocation of the
> > local_dma_lkey.
> > 
> > This will take effect only for devices that don't pre-allocate the lkey
> > but allocate it per PD allocation.
> > 
> > Signed-off-by: Avihai Horon <avihaih@nvidia.com>
> > Reviewed-by: Michael Guralnik <michaelgur@nvidia.com>
> > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> > ---
> >   drivers/infiniband/core/verbs.c              | 3 ++-
> >   drivers/infiniband/hw/vmw_pvrdma/pvrdma_mr.c | 1 +
> >   2 files changed, 3 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
> > index a1782f8a6ca0..9b719f7d6fd5 100644
> > --- a/drivers/infiniband/core/verbs.c
> > +++ b/drivers/infiniband/core/verbs.c
> > @@ -287,7 +287,8 @@ struct ib_pd *__ib_alloc_pd(struct ib_device *device, unsigned int flags,
> >   	if (device->attrs.device_cap_flags & IB_DEVICE_LOCAL_DMA_LKEY)
> >   		pd->local_dma_lkey = device->local_dma_lkey;
> >   	else
> > -		mr_access_flags |= IB_ACCESS_LOCAL_WRITE;
> > +		mr_access_flags |=
> > +			IB_ACCESS_LOCAL_WRITE | IB_ACCESS_RELAXED_ORDERING;
> 
> So, do local_dma_lkey's get relaxed ordering unconditionally?

Yes, in mlx5, this lkey is created on the fly.

Thanks
