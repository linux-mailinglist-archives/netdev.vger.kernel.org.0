Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C93A435D1ED
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 22:22:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243860AbhDLUVL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 16:21:11 -0400
Received: from p3plsmtpa06-10.prod.phx3.secureserver.net ([173.201.192.111]:56358
        "EHLO p3plsmtpa06-10.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237251AbhDLUVK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Apr 2021 16:21:10 -0400
Received: from [192.168.0.116] ([71.184.94.153])
        by :SMTPAUTH: with ESMTPSA
        id W339l3kjiyIwVW339ls9Ne; Mon, 12 Apr 2021 13:20:51 -0700
X-CMAE-Analysis: v=2.4 cv=NP4QR22g c=1 sm=1 tr=0 ts=6074aba3
 a=vbvdVb1zh1xTTaY8rfQfKQ==:117 a=vbvdVb1zh1xTTaY8rfQfKQ==:17
 a=IkcTkHD0fZMA:10 a=hlpFoNB0AAAA:8 a=SEc3moZ4AAAA:8 a=EXjNRlMbRGv2XLaMZsQA:9
 a=QEXdDO2ut3YA:10 a=kMYpNb-kQgMLPvQdVK_m:22 a=5oRCH6oROnRZc2VpWJZ3:22
X-SECURESERVER-ACCT: tom@talpey.com
Subject: Re: [PATCH rdma-next 00/10] Enable relaxed ordering for ULPs
To:     Haakon Bugge <haakon.bugge@oracle.com>,
        David Laight <David.Laight@aculab.com>
Cc:     Chuck Lever III <chuck.lever@oracle.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
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
        OFED mailing list <linux-rdma@vger.kernel.org>,
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
 <4b02d1b2-be0e-0d1d-7ac3-38d32e44e77e@talpey.com>
 <1FA38618-E245-4C53-BF49-6688CA93C660@oracle.com>
 <7b9e7d9c-13d7-0d18-23b4-0d94409c7741@talpey.com>
 <f71b24433f4540f0a13133111a59dab8@AcuMS.aculab.com>
 <880A23A2-F078-42CF-BEE2-30666BCB9B5D@oracle.com>
From:   Tom Talpey <tom@talpey.com>
Message-ID: <7deadc67-650c-ea15-722b-a1d77d38faba@talpey.com>
Date:   Mon, 12 Apr 2021 16:20:47 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <880A23A2-F078-42CF-BEE2-30666BCB9B5D@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: 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
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/12/2021 2:32 PM, Haakon Bugge wrote:
> 
> 
>> On 10 Apr 2021, at 15:30, David Laight <David.Laight@aculab.com> wrote:
>>
>> From: Tom Talpey
>>> Sent: 09 April 2021 18:49
>>> On 4/9/2021 12:27 PM, Haakon Bugge wrote:
>>>>
>>>>
>>>>> On 9 Apr 2021, at 17:32, Tom Talpey <tom@talpey.com> wrote:
>>>>>
>>>>> On 4/9/2021 10:45 AM, Chuck Lever III wrote:
>>>>>>> On Apr 9, 2021, at 10:26 AM, Tom Talpey <tom@talpey.com> wrote:
>>>>>>>
>>>>>>> On 4/6/2021 7:49 AM, Jason Gunthorpe wrote:
>>>>>>>> On Mon, Apr 05, 2021 at 11:42:31PM +0000, Chuck Lever III wrote:
>>>>>>>>
>>>>>>>>> We need to get a better idea what correctness testing has been done,
>>>>>>>>> and whether positive correctness testing results can be replicated
>>>>>>>>> on a variety of platforms.
>>>>>>>> RO has been rolling out slowly on mlx5 over a few years and storage
>>>>>>>> ULPs are the last to change. eg the mlx5 ethernet driver has had RO
>>>>>>>> turned on for a long time, userspace HPC applications have been using
>>>>>>>> it for a while now too.
>>>>>>>
>>>>>>> I'd love to see RO be used more, it was always something the RDMA
>>>>>>> specs supported and carefully architected for. My only concern is
>>>>>>> that it's difficult to get right, especially when the platforms
>>>>>>> have been running strictly-ordered for so long. The ULPs need
>>>>>>> testing, and a lot of it.
>>>>>>>
>>>>>>>> We know there are platforms with broken RO implementations (like
>>>>>>>> Haswell) but the kernel is supposed to globally turn off RO on all
>>>>>>>> those cases. I'd be a bit surprised if we discover any more from this
>>>>>>>> series.
>>>>>>>> On the other hand there are platforms that get huge speed ups from
>>>>>>>> turning this on, AMD is one example, there are a bunch in the ARM
>>>>>>>> world too.
>>>>>>>
>>>>>>> My belief is that the biggest risk is from situations where completions
>>>>>>> are batched, and therefore polling is used to detect them without
>>>>>>> interrupts (which explicitly). The RO pipeline will completely reorder
>>>>>>> DMA writes, and consumers which infer ordering from memory contents may
>>>>>>> break. This can even apply within the provider code, which may attempt
>>>>>>> to poll WR and CQ structures, and be tripped up.
>>>>>> You are referring specifically to RPC/RDMA depending on Receive
>>>>>> completions to guarantee that previous RDMA Writes have been
>>>>>> retired? Or is there a particular implementation practice in
>>>>>> the Linux RPC/RDMA code that worries you?
>>>>>
>>>>> Nothing in the RPC/RDMA code, which is IMO correct. The worry, which
>>>>> is hopefully unfounded, is that the RO pipeline might not have flushed
>>>>> when a completion is posted *after* posting an interrupt.
>>>>>
>>>>> Something like this...
>>>>>
>>>>> RDMA Write arrives
>>>>> 	PCIe RO Write for data
>>>>> 	PCIe RO Write for data
>>>>> 	...
>>>>> RDMA Write arrives
>>>>> 	PCIe RO Write for data
>>>>> 	...
>>>>> RDMA Send arrives
>>>>> 	PCIe RO Write for receive data
>>>>> 	PCIe RO Write for receive descriptor
>>>>
>>>> Do you mean the Write of the CQE? It has to be Strongly Ordered for a correct implementation. Then
>>> it will shure prior written RO date has global visibility when the CQE can be observed.
>>>
>>> I wasn't aware that a strongly-ordered PCIe Write will ensure that
>>> prior relaxed-ordered writes went first. If that's the case, I'm
>>> fine with it - as long as the providers are correctly coded!!
> 
> The PCIe spec (Table Ordering Rules Summary) is quite clear here (A Posted request is Memory Write Request in this context):
> 
> 	A Posted Request must not pass another Posted Request unless A2b applies.
> 
> 	A2b: A Posted Request with RO Set is permitted to pass another Posted Request.
> 
> 
> Thxs, Håkon

Ok, good - a non-RO write (for example, to a CQE), or an interrupt
(which would be similarly non-RO), will "get behind" all prior writes.

So the issue is only in testing all the providers and platforms,
to be sure this new behavior isn't tickling anything that went
unnoticed all along, because no RDMA provider ever issued RO.

Honestly, the Haswell sounds like a great first candidate, because
if it has a known-broken RO behavior, verifying that it works with
this change is highly important. I'd have greater confidence in newer
platforms, in other words. They *all* have to work, proveably.

Tom.

>> I remember trying to read the relevant section of the PCIe spec.
>> (Possibly in a book that was trying to make it easier to understand!)
>> It is about as clear as mud.
>>
>> I presume this is all about allowing PCIe targets (eg ethernet cards)
>> to use relaxed ordering on write requests to host memory.
>> And that such writes can be completed out of order?
>>
>> It isn't entirely clear that you aren't talking of letting the
>> cpu do 'relaxed order' writes to PCIe targets!
>>
>> For a typical ethernet driver the receive interrupt just means
>> 'go and look at the receive descriptor ring'.
>> So there is an absolute requirement that the writes for data
>> buffer complete before the write to the receive descriptor.
>> There is no requirement for the interrupt (requested after the
>> descriptor write) to have been seen by the cpu.
>>
>> Quite often the driver will find the 'receive complete'
>> descriptor when processing frames from an earlier interrupt
>> (and nothing to do in response to the interrupt itself).
>>
>> So the write to the receive descriptor would have to have RO clear
>> to ensure that all the buffer writes complete first.
>>
>> (The furthest I've got into PCIe internals was fixing the bug
>> in some vendor-supplied FPGA logic that failed to correctly
>> handle multiple data TLP responses to a single read TLP.
>> Fortunately it wasn't in the hard-IP bit.)
>>
>> 	David
>>
>> -
>> Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
>> Registration No: 1397386 (Wales)
> 
