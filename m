Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E0D3354973
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 01:50:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242131AbhDEXuW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Apr 2021 19:50:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:57574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237601AbhDEXuS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Apr 2021 19:50:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 591AC613AE;
        Mon,  5 Apr 2021 23:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617666611;
        bh=O0RRvC67wyIxyVI9osywvj0pz7HWCPQTesV6bE2/GW8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XRk/SK45PHxpF77rVTHwvWbgd00Rast4vDP2RUocsZ5/he6DL7tdT33kVGjvQhKJQ
         OiYhgIwEJ5ocuWrmOwC1kFOGw1Ap3vhzMWKjK/KKJ3sYDWEZRiKHWdN+GtEuGgvvyN
         CMGh1ihb9ktQaFexK5FYBpsjMIZFH+qFjNZzltlfW+rF/fjiq5WgzECBl85E7xxVzh
         +I1CAc7Qt49v5ARp2bp5d2SkxQ1UiIIJrA59+CHw4Qxy/MSJH/l2Yxt3gQwWDBlagX
         tsUxHjhloGV95xz9ou075LzhgdFWO9PGSgnzQnabQLnXjJxUrdq5WArezA7rcQTtc8
         6XiyY4PobdZhA==
Date:   Mon, 5 Apr 2021 16:50:06 -0700
From:   Keith Busch <kbusch@kernel.org>
To:     Chuck Lever III <chuck.lever@oracle.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>, Christoph Hellwig <hch@lst.de>,
        Leon Romanovsky <leon@kernel.org>,
        Doug Ledford <dledford@redhat.com>,
        Leon Romanovsky <leonro@nvidia.com>,
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
        Lijun Ou <oulijun@huawei.com>,
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
Message-ID: <20210405235006.GA2014546@dhcp-10-100-145-180.wdc.com>
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
> > On Apr 5, 2021, at 4:07 PM, Jason Gunthorpe <jgg@nvidia.com> wrote:
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
> 
> I have an old Haswell dual-socket system in my lab, but otherwise
> I'm not sure I have a platform that would be interesting for such a
> test.

Not sure if Haswell will be useful for such testing. It looks like many
of those subscribe to 'quirk_relaxedordering_disable'.
