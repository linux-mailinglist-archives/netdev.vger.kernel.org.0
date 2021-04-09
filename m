Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DD1135A0FD
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 16:26:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233071AbhDIO0s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 10:26:48 -0400
Received: from p3plsmtpa06-08.prod.phx3.secureserver.net ([173.201.192.109]:44530
        "EHLO p3plsmtpa06-08.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232990AbhDIO0p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Apr 2021 10:26:45 -0400
Received: from [192.168.0.116] ([71.184.94.153])
        by :SMTPAUTH: with ESMTPSA
        id Us5VlwAa2dm6ZUs5Wl5bWv; Fri, 09 Apr 2021 07:26:30 -0700
X-CMAE-Analysis: v=2.4 cv=U/hXscnu c=1 sm=1 tr=0 ts=60706416
 a=vbvdVb1zh1xTTaY8rfQfKQ==:117 a=vbvdVb1zh1xTTaY8rfQfKQ==:17
 a=IkcTkHD0fZMA:10 a=RpEpbWADTCFOjAt6Sx0A:9 a=QEXdDO2ut3YA:10
X-SECURESERVER-ACCT: tom@talpey.com
Subject: Re: [PATCH rdma-next 00/10] Enable relaxed ordering for ULPs
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Chuck Lever III <chuck.lever@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, Leon Romanovsky <leon@kernel.org>,
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
References: <20210405052404.213889-1-leon@kernel.org>
 <20210405134115.GA22346@lst.de> <20210405200739.GB7405@nvidia.com>
 <C2924F03-11C5-4839-A4F3-36872194EEA8@oracle.com>
 <20210406114952.GH7405@nvidia.com>
From:   Tom Talpey <tom@talpey.com>
Message-ID: <aeb7334b-edc0-78c2-4adb-92d4a994210d@talpey.com>
Date:   Fri, 9 Apr 2021 10:26:21 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <20210406114952.GH7405@nvidia.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: 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
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/6/2021 7:49 AM, Jason Gunthorpe wrote:
> On Mon, Apr 05, 2021 at 11:42:31PM +0000, Chuck Lever III wrote:
>   
>> We need to get a better idea what correctness testing has been done,
>> and whether positive correctness testing results can be replicated
>> on a variety of platforms.
> 
> RO has been rolling out slowly on mlx5 over a few years and storage
> ULPs are the last to change. eg the mlx5 ethernet driver has had RO
> turned on for a long time, userspace HPC applications have been using
> it for a while now too.

I'd love to see RO be used more, it was always something the RDMA
specs supported and carefully architected for. My only concern is
that it's difficult to get right, especially when the platforms
have been running strictly-ordered for so long. The ULPs need
testing, and a lot of it.

> We know there are platforms with broken RO implementations (like
> Haswell) but the kernel is supposed to globally turn off RO on all
> those cases. I'd be a bit surprised if we discover any more from this
> series.
> 
> On the other hand there are platforms that get huge speed ups from
> turning this on, AMD is one example, there are a bunch in the ARM
> world too.

My belief is that the biggest risk is from situations where completions
are batched, and therefore polling is used to detect them without
interrupts (which explicitly). The RO pipeline will completely reorder
DMA writes, and consumers which infer ordering from memory contents may
break. This can even apply within the provider code, which may attempt
to poll WR and CQ structures, and be tripped up.

The Mellanox adapter, itself, historically has strict in-order DMA
semantics, and while it's great to relax that, changing it by default
for all consumers is something to consider very cautiously.

> Still, obviously people should test on the platforms they have.

Yes, and "test" be taken seriously with focus on ULP data integrity.
Speedups will mean nothing if the data is ever damaged.

Tom.
