Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3994E3F7360
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 12:35:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238882AbhHYKgS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 06:36:18 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:3690 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234177AbhHYKgQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 06:36:16 -0400
Received: from fraeml739-chm.china.huawei.com (unknown [172.18.147.226])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Gvj5P2sxjz67N2l;
        Wed, 25 Aug 2021 18:34:17 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml739-chm.china.huawei.com (10.206.15.220) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 25 Aug 2021 12:35:28 +0200
Received: from [10.47.26.214] (10.47.26.214) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.8; Wed, 25 Aug
 2021 11:35:27 +0100
From:   John Garry <john.garry@huawei.com>
Subject: Re: [PATCH v11 01/12] iova: Export alloc_iova_fast() and
 free_iova_fast()
To:     Will Deacon <will@kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>
CC:     <kvm@vger.kernel.org>, <jasowang@redhat.com>,
        <virtualization@lists.linux-foundation.org>,
        <christian.brauner@canonical.com>, <corbet@lwn.net>,
        <willy@infradead.org>, <hch@infradead.org>,
        Xie Yongji <xieyongji@bytedance.com>,
        <dan.carpenter@oracle.com>, <sgarzare@redhat.com>,
        <xiaodong.liu@intel.com>, <linux-fsdevel@vger.kernel.org>,
        <viro@zeniv.linux.org.uk>, <stefanha@redhat.com>,
        <songmuchun@bytedance.com>, <axboe@kernel.dk>,
        <zhe.he@windriver.com>, <gregkh@linuxfoundation.org>,
        <rdunlap@infradead.org>, <linux-kernel@vger.kernel.org>,
        <iommu@lists.linux-foundation.org>, <bcrl@kvack.org>,
        <netdev@vger.kernel.org>, <joe@perches.com>,
        <robin.murphy@arm.com>, <mika.penttila@nextfour.com>
References: <20210818120642.165-1-xieyongji@bytedance.com>
 <20210818120642.165-2-xieyongji@bytedance.com>
 <20210824140758-mutt-send-email-mst@kernel.org>
 <20210825095540.GA24546@willie-the-truck>
Message-ID: <5f4eadda-5500-9bac-4368-48cfca6d0a4d@huawei.com>
Date:   Wed, 25 Aug 2021 11:39:22 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <20210825095540.GA24546@willie-the-truck>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.26.214]
X-ClientProxiedBy: lhreml721-chm.china.huawei.com (10.201.108.72) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 25/08/2021 10:55, Will Deacon wrote:
> On Tue, Aug 24, 2021 at 02:08:33PM -0400, Michael S. Tsirkin wrote:
>> On Wed, Aug 18, 2021 at 08:06:31PM +0800, Xie Yongji wrote:
>>> Export alloc_iova_fast() and free_iova_fast() so that
>>> some modules can make use of the per-CPU cache to get
>>> rid of rbtree spinlock in alloc_iova() and free_iova()
>>> during IOVA allocation.
>>>
>>> Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
>>
>>
>> This needs ack from iommu maintainers. Guys?
> 
> Looks fine to me:
> 
> Acked-by: Will Deacon <will@kernel.org>
> 
> Will
> _______________________________________________
> iommu mailing list
> iommu@lists.linux-foundation.org
> https://lists.linuxfoundation.org/mailman/listinfo/iommu
> .
> 

JFYI, There was a preliminary discussion to move the iova rcache code 
(which the iova fast alloc and free functions are based on) out of the 
iova code and maybe into dma-iommu (being the only user). There was 
other motivation.

https://lore.kernel.org/linux-iommu/83de3911-145d-77c8-17c1-981e4ff825d3@arm.com/

Having more users complicates that...

Thanks,
John
