Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E363354C43
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 07:24:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243815AbhDFFYb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 01:24:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:60640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233036AbhDFFY3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Apr 2021 01:24:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C791061246;
        Tue,  6 Apr 2021 05:24:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617686662;
        bh=8JS7ICrS7uuaOPO5yu1JQVUjSFQhPCTd44gGpGT7I58=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WP6roTKoemOABplgHbwEmALlcxPzQzk1VbK173QYlDO+W72Tqsl3QybZGH7mcYNPA
         sIqDKBp3YOpMkHNnk/3JPYBD7mhhDoyIOwkSzz9U7Ybbo39TsDKDHXYcvhB1mk3sTs
         EgFzyjGi6Bkf64w27QYc6W0VfNGWgAFhwkpES0d/uM5z9UuYVrxYbcZUHaFHoDjeNh
         Tir4/ma0P28qer+50bxnn0mTHUSGy0Q9vNs7nA2JhgcI4/RzZhpmMHoiGnDb/s5PM1
         XUvQLrP2qGOcaVDaSUONUlsCyMSYQHwX9xPpKcrNSnLiwCkC3VX6avNGwAUs1G12bh
         8m1JEEsTKunpw==
Date:   Tue, 6 Apr 2021 08:24:18 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Avihai Horon <avihaih@nvidia.com>,
        Adit Ranadive <aditr@vmware.com>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        Ariel Elior <aelior@marvell.com>,
        Bart Van Assche <bvanassche@acm.org>,
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
Message-ID: <YGvwgrIR70oqNKUk@unreal>
References: <20210405052404.213889-1-leon@kernel.org>
 <20210405052404.213889-2-leon@kernel.org>
 <20210405134618.GA22895@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210405134618.GA22895@lst.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 05, 2021 at 03:46:18PM +0200, Christoph Hellwig wrote:
> On Mon, Apr 05, 2021 at 08:23:55AM +0300, Leon Romanovsky wrote:
> > From: Avihai Horon <avihaih@nvidia.com>
> > 
> > Add access flags parameter to ib_alloc_mr() and to ib_mr_pool_init(),
> > and refactor relevant code. This parameter is used to pass MR access
> > flags during MR allocation.
> > 
> > In the following patches, the new access flags parameter will be used
> > to enable Relaxed Ordering for ib_alloc_mr() and ib_mr_pool_init() users.
> 
> So this weirds up a new RELAXED_ORDERING flag without ever mentioning
> that flag in the commit log, never mind what it actually does.

We will improve commit messages.

Thanks
