Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BC9D35429E
	for <lists+netdev@lfdr.de>; Mon,  5 Apr 2021 16:10:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241279AbhDEOIo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Apr 2021 10:08:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:55574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237431AbhDEOIn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Apr 2021 10:08:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8D99C613B1;
        Mon,  5 Apr 2021 14:08:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617631717;
        bh=LF0+zRsEi7jGYk/Bg8vQa1eqOiMQAgaqbYGUkXrouMw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=I6k7K+GugdLkntOIS/XDUjVAG89FAmzBko1fER7cc3uE9NDtxEXpfu2Xnwtq/0NxL
         ckDn8FJGtmNFigRJklJ7KJ88kfm6kTIfkzu3K1al8GZ7hrG/NbQzaebZPrLuRPMKeV
         AptGe6e5kFiM39xIw5oZeLhyTwrYwxKuFNMZKvbh6T+PyVEguwKyGNPBgMTiuZrCtk
         1J4xCIyRWGlQcLyexllVaPJpVxprEGXSRehfPLV3q2bRKrFBLmzp+wrTu00d0Soctr
         YYj1Q6Vs4W+Ds4QlJ6sIRBcayMiU899q/lysRyhZ5ut6I4xryD2Pm4kvUfyk5iXnMH
         E6a7i+TLCgJHQ==
Date:   Mon, 5 Apr 2021 17:08:33 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Adit Ranadive <aditr@vmware.com>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        Ariel Elior <aelior@marvell.com>,
        Avihai Horon <avihaih@nvidia.com>,
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
Subject: Re: [PATCH rdma-next 00/10] Enable relaxed ordering for ULPs
Message-ID: <YGsZ4Te1+DQODj34@unreal>
References: <20210405052404.213889-1-leon@kernel.org>
 <20210405134115.GA22346@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210405134115.GA22346@lst.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 05, 2021 at 03:41:15PM +0200, Christoph Hellwig wrote:
> On Mon, Apr 05, 2021 at 08:23:54AM +0300, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@nvidia.com>
> > 
> > >From Avihai,
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
> > with relaxed ordering. The test was performed on a NVIDIA A100 in order
> > to check performance of storage infrastructure over xprtrdma:
> 
> Isn't the Nvidia A100 a GPU not actually supported by Linux at all?
> What does that have to do with storage protocols?

This system is in use by our storage oriented customer who performed the
test. He runs drivers/infiniband/* stack from the upstream, simply backported
to specific kernel version.

The performance boost is seen in other systems too.

> 
> Also if you enable this for basically all kernel ULPs, why not have
> an opt-out into strict ordering for the cases that need it (if there are
> any).

The RO property is optional, it can only improve. In addition, all in-kernel ULPs
don't need strict ordering. I can be mistaken here and Jason will correct me, it
is because of two things: ULP doesn't touch data before CQE and DMA API prohibits it.

Thanks
