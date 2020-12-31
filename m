Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F8512E7E4F
	for <lists+netdev@lfdr.de>; Thu, 31 Dec 2020 06:52:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726548AbgLaFvr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Dec 2020 00:51:47 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:38104 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726218AbgLaFvr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Dec 2020 00:51:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1609393820;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=58HwBb3M7PAiscWQmllnEdkUdFZgFa03LEx+BxIEido=;
        b=dJNN0cFfg4uPEVhku1FBXL9KWMoD2SvHOMRx6Onb5JDAbTl+vjnvc6MBj8FTRouTF0LA0l
        XrFce/CUA7UnWChaXOUJTxFoMrElTP4hZggYnGzrE4IE81QPE/v3kYQkziE7N6hqLohth+
        ao1eHAc3BphQAWWYLbvXvgE5yuTlLCc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-238-cVm3mfXEO0u76e2pupugXw-1; Thu, 31 Dec 2020 00:50:18 -0500
X-MC-Unique: cVm3mfXEO0u76e2pupugXw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4EF05180A097;
        Thu, 31 Dec 2020 05:50:16 +0000 (UTC)
Received: from [10.72.12.236] (ovpn-12-236.pek2.redhat.com [10.72.12.236])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A0DC46F7F4;
        Thu, 31 Dec 2020 05:50:00 +0000 (UTC)
Subject: Re: [RFC v2 09/13] vduse: Add support for processing vhost iotlb
 message
To:     Yongji Xie <xieyongji@bytedance.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>, sgarzare@redhat.com,
        Parav Pandit <parav@nvidia.com>, akpm@linux-foundation.org,
        Randy Dunlap <rdunlap@infradead.org>,
        Matthew Wilcox <willy@infradead.org>, viro@zeniv.linux.org.uk,
        axboe@kernel.dk, bcrl@kvack.org, corbet@lwn.net,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
References: <20201222145221.711-1-xieyongji@bytedance.com>
 <CACycT3s=m=PQb5WFoMGhz8TNGme4+=rmbbBTtrugF9ZmNnWxEw@mail.gmail.com>
 <0e6faf9c-117a-e23c-8d6d-488d0ec37412@redhat.com>
 <CACycT3uwXBYvRbKDWdN3oCekv+o6_Lc=-KTrxejD=fr-zgibGw@mail.gmail.com>
 <2b24398c-e6d9-14ec-2c0d-c303d528e377@redhat.com>
 <CACycT3uDV43ecScrMh1QVpStuwDETHykJzzY=pkmZjP2Dd2kvg@mail.gmail.com>
 <e77c97c5-6bdc-cdd0-62c0-6ff75f6dbdff@redhat.com>
 <CACycT3soQoX5avZiFBLEGBuJpdni6-UxdhAPGpWHBWVf+dEySg@mail.gmail.com>
 <1356137727.40748805.1609233068675.JavaMail.zimbra@redhat.com>
 <CACycT3sg61yRdupnD+jQEkWKsVEvMWfhkJ=5z_bYZLxCibDiHw@mail.gmail.com>
 <b1aef426-29c7-7244-5fc9-56d52e86abb4@redhat.com>
 <CACycT3vZ7V5WWhCFLBK6FuvVNmPmMj_yc=COOB4cjjC13yHUwg@mail.gmail.com>
 <3fc6a132-9fc2-c4e2-7fb1-b5a8bfb771fa@redhat.com>
 <CACycT3tD3zyvV6Zy5NT4x=02hBgrRGq35xeTsRXXx-_wPGJXpQ@mail.gmail.com>
 <e0e693c3-1871-a410-c3d5-964518ec939a@redhat.com>
 <CACycT3vwMU5R7N8dZFBYX4-bxe2YT7EfK_M_jEkH8wzfH_GkBw@mail.gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <0885385c-ae46-158d-eabf-433ef8ecf27f@redhat.com>
Date:   Thu, 31 Dec 2020 13:49:59 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CACycT3vwMU5R7N8dZFBYX4-bxe2YT7EfK_M_jEkH8wzfH_GkBw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/12/31 下午1:15, Yongji Xie wrote:
> On Thu, Dec 31, 2020 at 10:49 AM Jason Wang <jasowang@redhat.com> wrote:
>>
>> On 2020/12/30 下午6:12, Yongji Xie wrote:
>>> On Wed, Dec 30, 2020 at 4:41 PM Jason Wang <jasowang@redhat.com> wrote:
>>>> On 2020/12/30 下午3:09, Yongji Xie wrote:
>>>>> On Wed, Dec 30, 2020 at 2:11 PM Jason Wang <jasowang@redhat.com> wrote:
>>>>>> On 2020/12/29 下午6:26, Yongji Xie wrote:
>>>>>>> On Tue, Dec 29, 2020 at 5:11 PM Jason Wang <jasowang@redhat.com> wrote:
>>>>>>>> ----- Original Message -----
>>>>>>>>> On Mon, Dec 28, 2020 at 4:43 PM Jason Wang <jasowang@redhat.com> wrote:
>>>>>>>>>> On 2020/12/28 下午4:14, Yongji Xie wrote:
>>>>>>>>>>>> I see. So all the above two questions are because VHOST_IOTLB_INVALIDATE
>>>>>>>>>>>> is expected to be synchronous. This need to be solved by tweaking the
>>>>>>>>>>>> current VDUSE API or we can re-visit to go with descriptors relaying
>>>>>>>>>>>> first.
>>>>>>>>>>>>
>>>>>>>>>>> Actually all vdpa related operations are synchronous in current
>>>>>>>>>>> implementation. The ops.set_map/dma_map/dma_unmap should not return
>>>>>>>>>>> until the VDUSE_UPDATE_IOTLB/VDUSE_INVALIDATE_IOTLB message is replied
>>>>>>>>>>> by userspace. Could it solve this problem?
>>>>>>>>>>       I was thinking whether or not we need to generate IOTLB_INVALIDATE
>>>>>>>>>> message to VDUSE during dma_unmap (vduse_dev_unmap_page).
>>>>>>>>>>
>>>>>>>>>> If we don't, we're probably fine.
>>>>>>>>>>
>>>>>>>>> It seems not feasible. This message will be also used in the
>>>>>>>>> virtio-vdpa case to notify userspace to unmap some pages during
>>>>>>>>> consistent dma unmapping. Maybe we can document it to make sure the
>>>>>>>>> users can handle the message correctly.
>>>>>>>> Just to make sure I understand your point.
>>>>>>>>
>>>>>>>> Do you mean you plan to notify the unmap of 1) streaming DMA or 2)
>>>>>>>> coherent DMA?
>>>>>>>>
>>>>>>>> For 1) you probably need a workqueue to do that since dma unmap can
>>>>>>>> be done in irq or bh context. And if usrspace does't do the unmap, it
>>>>>>>> can still access the bounce buffer (if you don't zap pte)?
>>>>>>>>
>>>>>>> I plan to do it in the coherent DMA case.
>>>>>> Any reason for treating coherent DMA differently?
>>>>>>
>>>>> Now the memory of the bounce buffer is allocated page by page in the
>>>>> page fault handler. So it can't be used in coherent DMA mapping case
>>>>> which needs some memory with contiguous virtual addresses. I can use
>>>>> vmalloc() to do allocation for the bounce buffer instead. But it might
>>>>> cause some memory waste. Any suggestion?
>>>> I may miss something. But I don't see a relationship between the
>>>> IOTLB_UNMAP and vmalloc().
>>>>
>>> In the vmalloc() case, the coherent DMA page will be taken from the
>>> memory allocated by vmalloc(). So IOTLB_UNMAP is not needed anymore
>>> during coherent DMA unmapping because those vmalloc'ed memory which
>>> has been mapped into userspace address space during initialization can
>>> be reused. And userspace should not unmap the region until we destroy
>>> the device.
>>
>> Just to make sure I understand. My understanding is that IOTLB_UNMAP is
>> only needed when there's a change the mapping from IOVA to page.
>>
> Yes, that's true.
>
>> So if we stick to the mapping, e.g during dma_unmap, we just put IOVA to
>> free list to be used by the next IOVA allocating. IOTLB_UNMAP could be
>> avoided.
>>
>> So we are not limited by how the pages are actually allocated?
>>
> In coherent DMA cases, we need to return some memory with contiguous
> kernel virtual addresses. That is the reason why we need vmalloc()
> here. If we allocate the memory page by page, the corresponding kernel
> virtual addresses in a contiguous IOVA range might not be contiguous.


Yes, but we can do that as what has been done in the series 
(alloc_pages_exact()). Or do you mean it would be a little bit hard to 
recycle IOVA/pages here?

Thanks


> And in streaming DMA cases, there is no limit. So another choice is
> using vmalloc'ed memory only for coherent DMA cases.
>
> Not sure if this is clear for you.
>
> Thanks,
> Yongji
>

