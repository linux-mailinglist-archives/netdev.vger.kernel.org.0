Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A975B35A20C
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 17:32:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233332AbhDIPdH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 11:33:07 -0400
Received: from p3plsmtpa06-04.prod.phx3.secureserver.net ([173.201.192.105]:43270
        "EHLO p3plsmtpa06-04.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232615AbhDIPdG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Apr 2021 11:33:06 -0400
Received: from [192.168.0.116] ([71.184.94.153])
        by :SMTPAUTH: with ESMTPSA
        id Ut7hlRPfQe8QFUt7ilij9S; Fri, 09 Apr 2021 08:32:51 -0700
X-CMAE-Analysis: v=2.4 cv=JLz+D+Gb c=1 sm=1 tr=0 ts=607073a3
 a=vbvdVb1zh1xTTaY8rfQfKQ==:117 a=vbvdVb1zh1xTTaY8rfQfKQ==:17
 a=IkcTkHD0fZMA:10 a=SEc3moZ4AAAA:8 a=oSsZz9J6dYZdRk27ncsA:9 a=QEXdDO2ut3YA:10
 a=5oRCH6oROnRZc2VpWJZ3:22
X-SECURESERVER-ACCT: tom@talpey.com
Subject: Re: [PATCH rdma-next 00/10] Enable relaxed ordering for ULPs
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
 <8A5E83DF-5C08-49CE-8EE3-08DC63135735@oracle.com>
From:   Tom Talpey <tom@talpey.com>
Message-ID: <4b02d1b2-be0e-0d1d-7ac3-38d32e44e77e@talpey.com>
Date:   Fri, 9 Apr 2021 11:32:41 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <8A5E83DF-5C08-49CE-8EE3-08DC63135735@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: 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
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/9/2021 10:45 AM, Chuck Lever III wrote:
> 
> 
>> On Apr 9, 2021, at 10:26 AM, Tom Talpey <tom@talpey.com> wrote:
>>
>> On 4/6/2021 7:49 AM, Jason Gunthorpe wrote:
>>> On Mon, Apr 05, 2021 at 11:42:31PM +0000, Chuck Lever III wrote:
>>>   
>>>> We need to get a better idea what correctness testing has been done,
>>>> and whether positive correctness testing results can be replicated
>>>> on a variety of platforms.
>>> RO has been rolling out slowly on mlx5 over a few years and storage
>>> ULPs are the last to change. eg the mlx5 ethernet driver has had RO
>>> turned on for a long time, userspace HPC applications have been using
>>> it for a while now too.
>>
>> I'd love to see RO be used more, it was always something the RDMA
>> specs supported and carefully architected for. My only concern is
>> that it's difficult to get right, especially when the platforms
>> have been running strictly-ordered for so long. The ULPs need
>> testing, and a lot of it.
>>
>>> We know there are platforms with broken RO implementations (like
>>> Haswell) but the kernel is supposed to globally turn off RO on all
>>> those cases. I'd be a bit surprised if we discover any more from this
>>> series.
>>> On the other hand there are platforms that get huge speed ups from
>>> turning this on, AMD is one example, there are a bunch in the ARM
>>> world too.
>>
>> My belief is that the biggest risk is from situations where completions
>> are batched, and therefore polling is used to detect them without
>> interrupts (which explicitly). The RO pipeline will completely reorder
>> DMA writes, and consumers which infer ordering from memory contents may
>> break. This can even apply within the provider code, which may attempt
>> to poll WR and CQ structures, and be tripped up.
> 
> You are referring specifically to RPC/RDMA depending on Receive
> completions to guarantee that previous RDMA Writes have been
> retired? Or is there a particular implementation practice in
> the Linux RPC/RDMA code that worries you?

Nothing in the RPC/RDMA code, which is IMO correct. The worry, which
is hopefully unfounded, is that the RO pipeline might not have flushed
when a completion is posted *after* posting an interrupt.

Something like this...

RDMA Write arrives
	PCIe RO Write for data
	PCIe RO Write for data
	...
RDMA Write arrives
	PCIe RO Write for data
	...
RDMA Send arrives
	PCIe RO Write for receive data
	PCIe RO Write for receive descriptor
	PCIe interrupt (flushes RO pipeline for all three ops above)

RPC/RDMA polls CQ
	Reaps receive completion

RDMA Send arrives
	PCIe RO Write for receive data
	PCIe RO write for receive descriptor
	Does *not* interrupt, since CQ not armed

RPC/RDMA continues to poll CQ
	Reaps receive completion
	PCIe RO writes not yet flushed
	Processes incomplete in-memory data
	Bzzzt

Hopefully, the adapter performs a PCIe flushing read, or something
to avoid this when an interrupt is not generated. Alternatively, I'm
overly paranoid.

Tom.

>> The Mellanox adapter, itself, historically has strict in-order DMA
>> semantics, and while it's great to relax that, changing it by default
>> for all consumers is something to consider very cautiously.
>>
>>> Still, obviously people should test on the platforms they have.
>>
>> Yes, and "test" be taken seriously with focus on ULP data integrity.
>> Speedups will mean nothing if the data is ever damaged.
> 
> I agree that data integrity comes first.
> 
> Since I currently don't have facilities to test RO in my lab, the
> community will have to agree on a set of tests and expected results
> that specifically exercise the corner cases you are concerned about.
> 
> 
> --
> Chuck Lever
> 
> 
> 
> 
