Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AF6335A4DC
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 19:44:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233038AbhDIRos (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 13:44:48 -0400
Received: from p3plsmtpa06-09.prod.phx3.secureserver.net ([173.201.192.110]:43824
        "EHLO p3plsmtpa06-09.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234049AbhDIRoq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Apr 2021 13:44:46 -0400
Received: from [192.168.0.116] ([71.184.94.153])
        by :SMTPAUTH: with ESMTPSA
        id UvB9l8sywJpwyUvB9lb2JW; Fri, 09 Apr 2021 10:44:32 -0700
X-CMAE-Analysis: v=2.4 cv=O+T8ADxW c=1 sm=1 tr=0 ts=60709280
 a=vbvdVb1zh1xTTaY8rfQfKQ==:117 a=vbvdVb1zh1xTTaY8rfQfKQ==:17
 a=IkcTkHD0fZMA:10 a=V14C-qhuNTb9CArrVYEA:9 a=QEXdDO2ut3YA:10
X-SECURESERVER-ACCT: tom@talpey.com
Subject: Re: [PATCH rdma-next 00/10] Enable relaxed ordering for ULPs
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Chuck Lever III <chuck.lever@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
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
 <aeb7334b-edc0-78c2-4adb-92d4a994210d@talpey.com>
 <20210409164046.GY7405@nvidia.com>
From:   Tom Talpey <tom@talpey.com>
Message-ID: <70909c83-5e3a-6cb5-a8c0-6bd2a6688fb4@talpey.com>
Date:   Fri, 9 Apr 2021 13:44:23 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <20210409164046.GY7405@nvidia.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: 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
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/9/2021 12:40 PM, Jason Gunthorpe wrote:
> On Fri, Apr 09, 2021 at 10:26:21AM -0400, Tom Talpey wrote:
> 
>> My belief is that the biggest risk is from situations where completions
>> are batched, and therefore polling is used to detect them without
>> interrupts (which explicitly).
> 
> We don't do this in the kernel.
> 
> All kernel ULPs only read data after they observe the CQE. We do not
> have "last data polling" and our interrupt model does not support some
> hacky "interrupt means go and use the data" approach.
> 
> ULPs have to be designed this way to use the DMA API properly.

Yep. Totally agree.

My concern was about the data being written as relaxed, and the CQE
racing it. I'll reply in the other fork.


> Fencing a DMA before it is completed by the HW will cause IOMMU
> errors.
> 
> Userspace is a different story, but that will remain as-is with
> optional relaxed ordering.
> 
> Jason
> 
