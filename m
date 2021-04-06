Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C0B5354C16
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 07:23:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242733AbhDFFJz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 01:09:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:57824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230073AbhDFFJy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Apr 2021 01:09:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E04D2613B8;
        Tue,  6 Apr 2021 05:09:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617685786;
        bh=X92KQg3tXG2x2dhtuX1igH+EpubBIGXwmzFmddKebSI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YAkOjjj0GL3XRB09Ij60URoGO7NdIuDIosagpxtfZ9iVq8xjzpRqmg0/f2VeAwevd
         gCLGwz21lbIWMUVSXSoaqFi0Iru0BxK0GRYMSdNgIrMHK9Yg3XdHCPbe/mFLACsA/X
         UFvAfStd4Pc48XpaL+1vVCP+pCq8UiEBkUw/DIxk2rU7bNPyvyjyKgmWx+rw14jJw/
         p73HiTP8ZGkD/NT+l86ADeas4d0UOfVxF9OY/sGrq+KRIXmDN6hnoJfqvKvFi3f0Bw
         dXBW8ogvsD7qEJhmTiZTbVWnJi+ud6+yxx8O41YQGlllSDdvvG13vLa6u7yKwxk3MU
         mcvvXPEGKgaVQ==
Date:   Tue, 6 Apr 2021 08:09:43 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Honggang LI <honli@redhat.com>
Cc:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Adit Ranadive <aditr@vmware.com>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        Ariel Elior <aelior@marvell.com>,
        Avihai Horon <avihaih@nvidia.com>,
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
Subject: Re: [PATCH rdma-next 00/10] Enable relaxed ordering for ULPs
Message-ID: <YGvtFxv1az754/Q5@unreal>
References: <20210405052404.213889-1-leon@kernel.org>
 <20210406023738.GB80908@dhcp-128-72.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210406023738.GB80908@dhcp-128-72.nay.redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 06, 2021 at 10:37:38AM +0800, Honggang LI wrote:
> On Mon, Apr 05, 2021 at 08:23:54AM +0300, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@nvidia.com>
> > 
> > From Avihai,
> > 
> > Relaxed Ordering is a PCIe mechanism that relaxes the strict ordering
> > imposed on PCI transactions, and thus, can improve performance.
> > 
> > Until now, relaxed ordering could be set only by user space applications
> > for user MRs. The following patch series enables relaxed ordering for the
> > kernel ULPs as well. Relaxed ordering is an optional capability, and as
> > such, it is ignored by vendors that don't support it.
> > 
> > The following test results show the performance improvement achieved
> 
> Did you test this patchset with CPU does not support relaxed ordering?

I don't think so, the CPUs that don't support RO are Intel's fourth/fifth-generation
and they are not interesting from performance point of view.

> 
> We observed significantly performance degradation when run perftest with
> relaxed ordering enabled over old CPU.
> 
> https://github.com/linux-rdma/perftest/issues/116

The perftest is slightly different, but you pointed to the valid point.
We forgot to call pcie_relaxed_ordering_enabled() before setting RO bit
and arguably this was needed to be done in perftest too.

Thanks

> 
> thanks
> 
