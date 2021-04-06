Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C0F9354C3C
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 07:24:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243802AbhDFFXn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 01:23:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:60280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242463AbhDFFXj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Apr 2021 01:23:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2AEBE61382;
        Tue,  6 Apr 2021 05:23:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617686611;
        bh=PSprIlDMOpq0CJmM95krK+keit7FPkiCMgEgFJ0d7/k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FjDVOtKBedvTjZCZ+coCPawPePx5n3OgmO5e+wypiqeNF0BbXbAFGnrHfxQSWRKU5
         9S9AhaOwwo3L1kUcxQd9piKYNJG7cWdtSN9o+BHE3jmS4MuQ7UgkUHJ+WsS+4UPcJP
         zJ7DS39/GTssefBfkuu6WuQ3+1CPEyFibz05Kf+Pl0XBOwC8/xzoP6p3HDZ6/cHu9l
         ijmqcD4yzuoyvJBHjDtgSeMNJ0ed16rLl8jNC3GzPvs+Nv2qVvHQL6qcAxw8SsHatX
         h4gghCozTMC81yGE6C0Rdw2kJ88OCNTMA71OZdSgaoEbmJwbtvqbo7R7f2EVyki/oe
         hpYrFOUOEdKTQ==
Date:   Tue, 6 Apr 2021 08:23:28 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Christoph Hellwig <hch@lst.de>,
        Avihai Horon <avihaih@nvidia.com>,
        Adit Ranadive <aditr@vmware.com>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        Ariel Elior <aelior@marvell.com>,
        Bernard Metzler <bmt@zurich.ibm.com>,
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
Subject: Re: [PATCH rdma-next 01/10] RDMA: Add access flags to ib_alloc_mr()
 and ib_mr_pool_init()
Message-ID: <YGvwUI022t/rJy5U@unreal>
References: <20210405052404.213889-1-leon@kernel.org>
 <20210405052404.213889-2-leon@kernel.org>
 <c21edd64-396c-4c7c-86f8-79045321a528@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c21edd64-396c-4c7c-86f8-79045321a528@acm.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 05, 2021 at 08:27:16AM -0700, Bart Van Assche wrote:
> On 4/4/21 10:23 PM, Leon Romanovsky wrote:
> > diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
> > index bed4cfe50554..59138174affa 100644
> > --- a/include/rdma/ib_verbs.h
> > +++ b/include/rdma/ib_verbs.h
> > @@ -2444,10 +2444,10 @@ struct ib_device_ops {
> >  				       struct ib_udata *udata);
> >  	int (*dereg_mr)(struct ib_mr *mr, struct ib_udata *udata);
> >  	struct ib_mr *(*alloc_mr)(struct ib_pd *pd, enum ib_mr_type mr_type,
> > -				  u32 max_num_sg);
> > +				  u32 max_num_sg, u32 access);
> >  	struct ib_mr *(*alloc_mr_integrity)(struct ib_pd *pd,
> >  					    u32 max_num_data_sg,
> > -					    u32 max_num_meta_sg);
> > +					    u32 max_num_meta_sg, u32 access);
> >  	int (*advise_mr)(struct ib_pd *pd,
> >  			 enum ib_uverbs_advise_mr_advice advice, u32 flags,
> >  			 struct ib_sge *sg_list, u32 num_sge,
> > @@ -4142,11 +4142,10 @@ static inline int ib_dereg_mr(struct ib_mr *mr)
> >  }
> >  
> >  struct ib_mr *ib_alloc_mr(struct ib_pd *pd, enum ib_mr_type mr_type,
> > -			  u32 max_num_sg);
> > +			  u32 max_num_sg, u32 access);
> >  
> > -struct ib_mr *ib_alloc_mr_integrity(struct ib_pd *pd,
> > -				    u32 max_num_data_sg,
> > -				    u32 max_num_meta_sg);
> > +struct ib_mr *ib_alloc_mr_integrity(struct ib_pd *pd, u32 max_num_data_sg,
> > +				    u32 max_num_meta_sg, u32 access);
> >  
> >  /**
> >   * ib_update_fast_reg_key - updates the key portion of the fast_reg MR
> > diff --git a/include/rdma/mr_pool.h b/include/rdma/mr_pool.h
> > index e77123bcb43b..2a0ee791037d 100644
> > --- a/include/rdma/mr_pool.h
> > +++ b/include/rdma/mr_pool.h
> > @@ -11,7 +11,8 @@ struct ib_mr *ib_mr_pool_get(struct ib_qp *qp, struct list_head *list);
> >  void ib_mr_pool_put(struct ib_qp *qp, struct list_head *list, struct ib_mr *mr);
> >  
> >  int ib_mr_pool_init(struct ib_qp *qp, struct list_head *list, int nr,
> > -		enum ib_mr_type type, u32 max_num_sg, u32 max_num_meta_sg);
> > +		    enum ib_mr_type type, u32 max_num_sg, u32 max_num_meta_sg,
> > +		    u32 access);
> >  void ib_mr_pool_destroy(struct ib_qp *qp, struct list_head *list);
> >  
> >  #endif /* _RDMA_MR_POOL_H */
> 
> Does the new 'access' argument only control whether or not PCIe relaxed
> ordering is enabled? It seems wrong to me to make enabling of PCIe
> relaxed ordering configurable. I think this mechanism should be enabled
> unconditionally if the HCA supports it.

The same proposal (enable unconditionally) was raised during
submission preparations and we decided to follow same pattern
as other verbs objects which receive flag parameter.

Thanks

> 
> Thanks,
> 
> Bart.
