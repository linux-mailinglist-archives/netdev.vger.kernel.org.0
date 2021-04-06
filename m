Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 208EE354C26
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 07:23:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242542AbhDFFMo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 01:12:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:58382 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229808AbhDFFMn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Apr 2021 01:12:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 23138613B8;
        Tue,  6 Apr 2021 05:12:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617685956;
        bh=K2VXUKEpqJiAecRK7nuM6Ef1vGTf004NIHw7LA9Q4Xw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VBYe8nAhcQ2gETbrZBaxITiulHS0SsxOuZB1nNAi0p5WY3rfrHLnaPjo9tL4+RatD
         OvfjqH3Povn5OCMTGa5RlQF230tFVVzb9HydS2zHU/BaIwf+KvMdYr32GN/VwJ25lZ
         dsH93XLOHPu2URUPt9RBiTbVY7N/Y4wAJjBYAyqNIJ4GDgORdUjoFJY+r6Xs8g41uZ
         4jIsVc7rfnYGLju9XB1n4Nq+dsoRUWnYUZWddt9/CZ7cajg1idzkiXvRRAIvS4sPp/
         Kr6vAgYC12rpER13ZxiNVcQcpTQ3wJHz0xG14EeFWCDKjzO9gYBWR6BNYBQA3n7iO9
         WILNU27QNSjSw==
Date:   Tue, 6 Apr 2021 08:12:32 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Chuck Lever III <chuck.lever@oracle.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>, Christoph Hellwig <hch@lst.de>,
        Doug Ledford <dledford@redhat.com>,
        Adit Ranadive <aditr@vmware.com>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        Ariel Elior <aelior@marvell.com>,
        Avihai Horon <avihaih@nvidia.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Bernard Metzler <bmt@zurich.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Devesh Sharma <devesh.sharma@broadcom.com>,
        Faisal Latif <faisal.latif@intel.com>,
        Jack Wang <jinpu.wang@ionos.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Bruce Fields <bfields@fieldses.org>, Jens Axboe <axboe@fb.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Keith Busch <kbusch@kernel.org>, Lijun Ou <oulijun@huawei.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        linux-rdma <linux-rdma@vger.kernel.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        Max Gurtovoy <maxg@mellanox.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        "Md. Haris Iqbal" <haris.iqbal@ionos.com>,
        Michael Guralnik <michaelgur@nvidia.com>,
        Michal Kalderon <mkalderon@marvell.com>,
        Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>,
        Naresh Kumar PBS <nareshkumar.pbs@broadcom.com>,
        Linux-Net <netdev@vger.kernel.org>,
        Potnuri Bharat Teja <bharat@chelsio.com>,
        "rds-devel@oss.oracle.com" <rds-devel@oss.oracle.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        "samba-technical@lists.samba.org" <samba-technical@lists.samba.org>,
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
Message-ID: <YGvtwJclBRYORQqV@unreal>
References: <20210405052404.213889-1-leon@kernel.org>
 <20210405134115.GA22346@lst.de>
 <20210405200739.GB7405@nvidia.com>
 <C2924F03-11C5-4839-A4F3-36872194EEA8@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C2924F03-11C5-4839-A4F3-36872194EEA8@oracle.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 05, 2021 at 11:42:31PM +0000, Chuck Lever III wrote:
> 
> 
> > On Apr 5, 2021, at 4:07 PM, Jason Gunthorpe <jgg@nvidia.com> wrote:
> > 
> > On Mon, Apr 05, 2021 at 03:41:15PM +0200, Christoph Hellwig wrote:
> >> On Mon, Apr 05, 2021 at 08:23:54AM +0300, Leon Romanovsky wrote:
> >>> From: Leon Romanovsky <leonro@nvidia.com>
> >>> 
> >>>> From Avihai,
> >>> 
> >>> Relaxed Ordering is a PCIe mechanism that relaxes the strict ordering
> >>> imposed on PCI transactions, and thus, can improve performance.
> >>> 
> >>> Until now, relaxed ordering could be set only by user space applications
> >>> for user MRs. The following patch series enables relaxed ordering for the
> >>> kernel ULPs as well. Relaxed ordering is an optional capability, and as
> >>> such, it is ignored by vendors that don't support it.
> >>> 
> >>> The following test results show the performance improvement achieved
> >>> with relaxed ordering. The test was performed on a NVIDIA A100 in order
> >>> to check performance of storage infrastructure over xprtrdma:
> >> 
> >> Isn't the Nvidia A100 a GPU not actually supported by Linux at all?
> >> What does that have to do with storage protocols?
> > 
> > I think it is a typo (or at least mit makes no sense to be talking
> > about NFS with a GPU chip) Probably it should be a DGX A100 which is a
> > dual socket AMD server with alot of PCIe, and xptrtrdma is a NFS-RDMA
> > workload.
> 
> We need to get a better idea what correctness testing has been done,
> and whether positive correctness testing results can be replicated
> on a variety of platforms.

I will ask to provide more details.

> 
> I have an old Haswell dual-socket system in my lab, but otherwise
> I'm not sure I have a platform that would be interesting for such a
> test.

We don't have such old systems too.

> 
> 
> > AMD dual socket systems are well known to benefit from relaxed
> > ordering, people have been doing this in userspace for a while now
> > with the opt in.
> 
> 
> --
> Chuck Lever
> 
> 
> 
