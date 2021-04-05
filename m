Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E534735467C
	for <lists+netdev@lfdr.de>; Mon,  5 Apr 2021 20:01:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232753AbhDESCB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Apr 2021 14:02:01 -0400
Received: from p3plsmtpa06-03.prod.phx3.secureserver.net ([173.201.192.104]:36751
        "EHLO p3plsmtpa06-03.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232562AbhDESCB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Apr 2021 14:02:01 -0400
Received: from [192.168.0.116] ([71.184.94.153])
        by :SMTPAUTH: with ESMTPSA
        id TTQklDwIKlaXaTTQklPVrj; Mon, 05 Apr 2021 10:54:34 -0700
X-CMAE-Analysis: v=2.4 cv=eKjWMFl1 c=1 sm=1 tr=0 ts=606b4eda
 a=vbvdVb1zh1xTTaY8rfQfKQ==:117 a=vbvdVb1zh1xTTaY8rfQfKQ==:17
 a=IkcTkHD0fZMA:10 a=Ikd4Dj_1AAAA:8 a=Yaz6U4fXJU-nSkCjVyEA:9 a=QEXdDO2ut3YA:10
X-SECURESERVER-ACCT: tom@talpey.com
Subject: Re: [PATCH rdma-next 00/10] Enable relaxed ordering for ULPs
To:     Leon Romanovsky <leon@kernel.org>, Christoph Hellwig <hch@lst.de>
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
References: <20210405052404.213889-1-leon@kernel.org>
 <20210405134115.GA22346@lst.de> <YGsZ4Te1+DQODj34@unreal>
From:   Tom Talpey <tom@talpey.com>
Message-ID: <0aa2dfc1-58e4-ac54-4ac7-3229039d9c7d@talpey.com>
Date:   Mon, 5 Apr 2021 13:54:30 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <YGsZ4Te1+DQODj34@unreal>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4xfHeFvch9CXwEtdZ0IkSfSvDfJ61kGmHt9NGJgHNYQrySGqVVDuJ9ps49cslZGA73vKwNzEnCWV3k2oacgtBjOJFQVLAEGLod/GadB5w/PafttQ7Fq1jG
 hE+lbXhi2AOywYITjKNx1X1H/Wi9V5phrjJT9rYrPKyn8tmtMiOsfCwXSRUf4ZiRBPXg2e3M1oDqs3m37DE92cVI9vaW/dpSZGTLmHJmfNtQb3+k4QF8RcLP
 iyUJ6lm9LN8mw+S1HPCYMpzmfVhpHKz1RAqhhnvGjGOao7c185NfLdhZddyhpw0Eh2/u48pXLrcBZ7TwhhKOQ4HlaiAIwm+1RIQlNLh5QaOf/iB8Wa5XO/EG
 YUNFhC1yWzA4E1pTzHAgP4iuZ2rd0o76G21I94f7pqpmU9OPz/B0z3oCnEXCFq5wBymHvp1KFz4IKsIN8I0IXxIdbI+l/6hvf6H6D8vqKv5QRJ2VvddsIFiL
 xYi3HMgnqoZA2s5KLM2i5eyO7G6Lo8lKBmThRslCYvAhLmwo0ttovL/s7JgaGqVJDJmbxQRYu8ovMQvUwJIRFaBQjchUFP/+AL/LUwHaP1w9lc1l4eSqbHJb
 sdN24cKKGV3bepJejz6tOqNzAsHeV1Ms2ouGAiHn7hMSrEjNI0i8Df6sm4TkDtHhBC+jKLq0G/foFQjVw9Sg0ugmGS6G18r0rq+1HPWN2WOYhNyIN4OiEkn8
 GaxhrVXqVlcpfokuvTF+s4sxiRpY8tQPtd8F159lNAYJit7eUWkHOxb9/BzxTtwGAg2pLS0GoqhvEfZlwaNC2cFG4reJuFIT02yOVFUmexISspL7SPBEgCTl
 gCryGfJ1n0ahmuuBXJGWP5AeNzInDj4hZ+NJciO6RPnJOWcxKkJHD4FbeWbzU5jUkwiKddcQNdy2ynGxHHL/zJvgugay00T3LuHv+Igao3F7oE1V9dyaEaBA
 Fmpb+zhCA7ZvEyti5vfVkT6H11m8+mhMFTUZEFrDvnRE8MOs29gQZ+JHRR1kaDfgQmZhAvVddE4nEU913yHt12OpQygldpqzReP54Z75Z/M0iTsxhK4fiEnU
 9JT9HzLT9lorwe7hCR/2owzoYe8l+sGjAUPRnCCvMda1Co9y1jfFeInBZC4o4oJrshDEWrR4FASyJ8P9f67T2oDp6kYiMXZo752VeeZMUEIgG/ZCW/50rXUd
 p1z6WWRt7HkdSHSIyR6854MYMQwWLCXTR/mXoV29uzHE1rKKB0ZV9hfBxM7OEq2ESAPIWzKflxfnkgi0hLHPX/pcs8qt1RabedqaElEMZG4tpUQT5x+1RYJy
 QLSG/eUxiYtJwWzhSSGGnPxp6tpPXwhHRCR2fS3hPunOc/BB4XDYAoRNbRQ8S9geX74vBfjR+7Mo/kEO+Ff1j/N/Pw/dPaSqM+s75erYzNEXE4uNr2yPjuFe
 RxZ54qOcm0eN4Kz/3MkrXc1qXWQIgqa8rMSPNIzcFXnHPXarf4r3mpzRtKaHqFVFd9+Ppmq8pTawFgx22hfqH6+2PrdpujOg9rLE1PSz4utM9m1qJ3ah/GrF
 dS3+E8jo80U5VFYoGJkRiSV7nEssBN/EHCDhggTQ8ObvhQpVhar3n28oCi5V4opOGfwPWz7BSvpdt/3wO6pKkM+X3oG5V4UjNkVXQ71Hxa9Mvjd4Q+1Ss96U
 yrrp3sVVys39o+RqZfQzme+urxFYVMYtau+xDORmNQy8ens2+eIIizgbX4qf8PnTbYwMX5GJWnF4VvFtqsrPU+co2qKDliR0AH4h73z5MIRf/29FBdxwZcnJ
 2RY7d4Chv6V4B8lPxXoM8mypwKNqsD98EHFTJFfHQz3IHKpl8Ot6wKjTnOV1YELuQXDFm9K3JLqPHY7ARmRiIponvY2zNyT40SrjkJ/UZEtgkuYSO6Wp/RjQ
 JE39Fg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/5/2021 10:08 AM, Leon Romanovsky wrote:
> On Mon, Apr 05, 2021 at 03:41:15PM +0200, Christoph Hellwig wrote:
>> On Mon, Apr 05, 2021 at 08:23:54AM +0300, Leon Romanovsky wrote:
>>> From: Leon Romanovsky <leonro@nvidia.com>
>>>
>>> >From Avihai,
>>>
>>> Relaxed Ordering is a PCIe mechanism that relaxes the strict ordering
>>> imposed on PCI transactions, and thus, can improve performance.
>>>
>>> Until now, relaxed ordering could be set only by user space applications
>>> for user MRs. The following patch series enables relaxed ordering for the
>>> kernel ULPs as well. Relaxed ordering is an optional capability, and as
>>> such, it is ignored by vendors that don't support it.
>>>
>>> The following test results show the performance improvement achieved
>>> with relaxed ordering. The test was performed on a NVIDIA A100 in order
>>> to check performance of storage infrastructure over xprtrdma:
>>
>> Isn't the Nvidia A100 a GPU not actually supported by Linux at all?
>> What does that have to do with storage protocols?
> 
> This system is in use by our storage oriented customer who performed the
> test. He runs drivers/infiniband/* stack from the upstream, simply backported
> to specific kernel version.
> 
> The performance boost is seen in other systems too.

We need to see more information about this test, and platform.

What correctness testing was done, and how was it verified? What
PCI bus type(s) were tested, and with what adapters? What storage
workload was generated, and were all possible RDMA exchanges by
each ULP exercised?

>> Also if you enable this for basically all kernel ULPs, why not have
>> an opt-out into strict ordering for the cases that need it (if there are
>> any).
> 
> The RO property is optional, it can only improve. In addition, all in-kernel ULPs
> don't need strict ordering. I can be mistaken here and Jason will correct me, it
> is because of two things: ULP doesn't touch data before CQE and DMA API prohibits it.

+1 on Christoph's comment.

I woud hope most well-architected ULPs will support relaxed ordering,
but storage workloads, in my experience, can find ways to cause failure
in adapters. I would not suggest making this the default behavior
without extensive testing.

Tom.
