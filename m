Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41CD8354676
	for <lists+netdev@lfdr.de>; Mon,  5 Apr 2021 20:01:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238038AbhDESB3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Apr 2021 14:01:29 -0400
Received: from p3plsmtpa06-10.prod.phx3.secureserver.net ([173.201.192.111]:49859
        "EHLO p3plsmtpa06-10.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230359AbhDESB1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Apr 2021 14:01:27 -0400
X-Greylist: delayed 405 seconds by postgrey-1.27 at vger.kernel.org; Mon, 05 Apr 2021 14:01:27 EDT
Received: from [192.168.0.116] ([71.184.94.153])
        by :SMTPAUTH: with ESMTPSA
        id TTXIlWXASyIwVTTXIllPn5; Mon, 05 Apr 2021 11:01:20 -0700
X-CMAE-Analysis: v=2.4 cv=NP4QR22g c=1 sm=1 tr=0 ts=606b5070
 a=vbvdVb1zh1xTTaY8rfQfKQ==:117 a=vbvdVb1zh1xTTaY8rfQfKQ==:17
 a=IkcTkHD0fZMA:10 a=Ikd4Dj_1AAAA:8 a=lVKP4JfJqfutk5idi9QA:9 a=QEXdDO2ut3YA:10
 a=pHzHmUro8NiASowvMSCR:22 a=nt3jZW36AmriUCFCBwmW:22
X-SECURESERVER-ACCT: tom@talpey.com
Subject: Re: [PATCH rdma-next 02/10] RDMA/core: Enable Relaxed Ordering in
 __ib_alloc_pd()
To:     Leon Romanovsky <leon@kernel.org>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Avihai Horon <avihaih@nvidia.com>,
        Adit Ranadive <aditr@vmware.com>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        Ariel Elior <aelior@marvell.com>,
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
References: <20210405052404.213889-1-leon@kernel.org>
 <20210405052404.213889-3-leon@kernel.org>
From:   Tom Talpey <tom@talpey.com>
Message-ID: <befc60f3-d28a-5420-b381-0f408bd7cca9@talpey.com>
Date:   Mon, 5 Apr 2021 14:01:16 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <20210405052404.213889-3-leon@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4xfKhBdA7dhIcoQbxQUsMb1TQGGZwNw2/OoguaxGUXtEIg67RPSNjPc/PUjX7344mkB7SL0PGdzrYucQPGJrfK8N90o1IdEouWWbMWsAwIRVjAIIjnchyI
 7T+qJoluUtUv+Rj2ZMPAZKLlPYpLdqV+Fds1melUW+AW9kftaWp4oRQBbUgmajDuDo1S0p/ipgsJyOo1R7Acmoa6p48dwWeCSg3E1XzeEekjOhTGbCGG79lF
 9lAiguxikhhrVWEq5ToTZdJ4VuJVFdsDOtfJvu/xTD9fEBKVLQGQsY97wH5C30UPMJ6uwY7g42dnwy0xAY1lOv6edk+2XU0xkgBIhZ4NEx4GwRlz+e6LeaJB
 zfMt8UBV/iuqNjnnIGfus8rOaF7xnBBrqexs74HClm1epAeOl+Dli6T/EVDlCswlMwauH2IuIhdusBpfWZnhiyp78jjmbQ20k0IFZedv41cF7hoBxD/qYJHw
 P0KP7K8Bl3OGE8Avdt9aMw6DYliDtB+LSvAhKnL/I8BpgkEQi793zFOYZjnzvnnabJouYEMlzX7XKKZrkEE0VhWNBlZyAHc5iJuUtbkz2feVlwUl50GXymIb
 LvEKpP0uzrKP65+zl5od7b/L7B6k6wJenr2F3Nwpe+tayRzduwrMg7aKqxAd3EH1C2PlOX3aj6Uw9ET40qudLV7WoixkyM4kZ56dKMfdiDR8awROKOc2mwa8
 TbifcwX3Vkn0vbejYfdtehxLwEMxGcYEu/ymMVzf9ksD7wO1osqATZtwh/QG59sXP2EPL+wcxM0ubGvyqWDUYGZ9bKPto8JLGpM7s0Qdcpx6VG52x9+D7+bf
 IFgyK/745XWOwlS1Awi8TJM2WHhfp0LkfitXJdq+ZUD26flT29tMQcfq49/+ptp5dcRfe5sXVj+Xh8hsv5j335umAuYJTIQ4+gwlfEltcso+++nS4q9kXOH5
 0aSBGCE+MHas9jWX+Y3ef/738l8zyC4+ueYuqNPxtndUN3yubHF+9Y/hCmXCHsNuHScRkKxQ3TEyklcPppE9XMkkfLqr7GXGN2FmlzFfA91S+iKEtRe/NeBn
 97Cix0xhpMTqk0FcgpW8M1NCzJ+730GONwuLbi8XLSSF6qhhrDrtU7O2CIsbO5NGH1AqQNhzen4m2+lZYYW06JHRGTCdZGVjg40kHDIpAtBHGLIBETS2/Bo2
 0rBzc7pQLnyXzt1I3PfO5oj7QJ2bS672QElPdP/PdVs4/tZDu3XEUfoHlOMDjrJPghPg9PPxKPiogJAvpyU1ZxhsTAfJzuNWsQqc54JYIbgYE5vNJOb99LLt
 aIf5HEd8l9ZLzHXemqtSW3kB0lIlt3LOiXIlPdXwlXtuKX3eS8QNEV3UfwwZ11SMPlFNgHgJ2RXmkYIwDZvCtVq8panGgipyaOAymBCG0mHwBuxawC9ARGG8
 apbyddXLF3HLjbJM1UWpCFcT+0uXRCGjrCyWbpEoIQy37yoIXVpZ+3N3/gdaqI+Y92wXnCWYmIZNXDHuy/M/toGg62UH0qkjhZKUdvrbqz3hiWkOjkIQrkHW
 JdtoRknxSZrCIhSHqAcoCG5ip2z+CnptXW/o9C589hUdkzH2C5ngjR5VBb2T6eTrBmDxyB7oQB5UkrLoH/AYos2s567wW1DRKH+/SZLV1RZuQ30QguEAFrGX
 8bAjEit0p3YcVvFiKaB+duXIiNeMVgHLtEaPFZaqCY7cxPBemONuCmzjoyTcu3Q61ehv3XYroDTro2DEKjgQ4LY11ZQF48W8FOKmN8/nJ5Rw5OI2/9JWFQx2
 vt7xZIDggu28ANohZnQhAVwjBVVzFTn2H/V/trxC0PyeS1otlNm05CHCfbmDTAvU4ZwpNX09+muGEPbPshNb3NCDfXezVkXEoE018AnSHS9zWAWJpghKZkql
 UqwtLg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/5/2021 1:23 AM, Leon Romanovsky wrote:
> From: Avihai Horon <avihaih@nvidia.com>
> 
> Enable Relaxed Ordering in __ib_alloc_pd() allocation of the
> local_dma_lkey.
> 
> This will take effect only for devices that don't pre-allocate the lkey
> but allocate it per PD allocation.
> 
> Signed-off-by: Avihai Horon <avihaih@nvidia.com>
> Reviewed-by: Michael Guralnik <michaelgur@nvidia.com>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> ---
>   drivers/infiniband/core/verbs.c              | 3 ++-
>   drivers/infiniband/hw/vmw_pvrdma/pvrdma_mr.c | 1 +
>   2 files changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
> index a1782f8a6ca0..9b719f7d6fd5 100644
> --- a/drivers/infiniband/core/verbs.c
> +++ b/drivers/infiniband/core/verbs.c
> @@ -287,7 +287,8 @@ struct ib_pd *__ib_alloc_pd(struct ib_device *device, unsigned int flags,
>   	if (device->attrs.device_cap_flags & IB_DEVICE_LOCAL_DMA_LKEY)
>   		pd->local_dma_lkey = device->local_dma_lkey;
>   	else
> -		mr_access_flags |= IB_ACCESS_LOCAL_WRITE;
> +		mr_access_flags |=
> +			IB_ACCESS_LOCAL_WRITE | IB_ACCESS_RELAXED_ORDERING;

So, do local_dma_lkey's get relaxed ordering unconditionally?

>   	if (flags & IB_PD_UNSAFE_GLOBAL_RKEY) {
>   		pr_warn("%s: enabling unsafe global rkey\n", caller);
> diff --git a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_mr.c b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_mr.c
> index b3fa783698a0..d74827694f92 100644
> --- a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_mr.c
> +++ b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_mr.c
> @@ -66,6 +66,7 @@ struct ib_mr *pvrdma_get_dma_mr(struct ib_pd *pd, int acc)
>   	int ret;
>   
>   	/* Support only LOCAL_WRITE flag for DMA MRs */
> +	acc &= ~IB_ACCESS_RELAXED_ORDERING;
>   	if (acc & ~IB_ACCESS_LOCAL_WRITE) {
>   		dev_warn(&dev->pdev->dev,
>   			 "unsupported dma mr access flags %#x\n", acc);

Why does the pvrdma driver require relaxed ordering to be off?

Tom.
