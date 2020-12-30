Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 744C22E766F
	for <lists+netdev@lfdr.de>; Wed, 30 Dec 2020 07:19:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726196AbgL3GMm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Dec 2020 01:12:42 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:36104 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726190AbgL3GMm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Dec 2020 01:12:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1609308675;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HR5VQjVbyjmspTne1yUEQIA+lboTKLXwct9mHhTRH6o=;
        b=GbIlDHIOZsPw7ENatgJ06qoUupdnUnggAqbaDNlpLV1ChqOhMQmreiqyFCR+7WzxYe6iUZ
        qgh/79R1nYRzEJwCugAuhSiEvHMMr8c56B1H7Zb03hMycbsNDySQwByWcLGY8AwPzqzUNk
        97tWap/nZ8M29YFWiFrd2Aj5t604OsU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-279-7O4wQ_a9MSKDf-vq6j4Bxw-1; Wed, 30 Dec 2020 01:11:13 -0500
X-MC-Unique: 7O4wQ_a9MSKDf-vq6j4Bxw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F07BFE760;
        Wed, 30 Dec 2020 06:11:10 +0000 (UTC)
Received: from [10.72.13.30] (ovpn-13-30.pek2.redhat.com [10.72.13.30])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D2DA31007617;
        Wed, 30 Dec 2020 06:10:58 +0000 (UTC)
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
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <b1aef426-29c7-7244-5fc9-56d52e86abb4@redhat.com>
Date:   Wed, 30 Dec 2020 14:10:57 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CACycT3sg61yRdupnD+jQEkWKsVEvMWfhkJ=5z_bYZLxCibDiHw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/12/29 下午6:26, Yongji Xie wrote:
> On Tue, Dec 29, 2020 at 5:11 PM Jason Wang <jasowang@redhat.com> wrote:
>>
>>
>> ----- Original Message -----
>>> On Mon, Dec 28, 2020 at 4:43 PM Jason Wang <jasowang@redhat.com> wrote:
>>>>
>>>> On 2020/12/28 下午4:14, Yongji Xie wrote:
>>>>>> I see. So all the above two questions are because VHOST_IOTLB_INVALIDATE
>>>>>> is expected to be synchronous. This need to be solved by tweaking the
>>>>>> current VDUSE API or we can re-visit to go with descriptors relaying
>>>>>> first.
>>>>>>
>>>>> Actually all vdpa related operations are synchronous in current
>>>>> implementation. The ops.set_map/dma_map/dma_unmap should not return
>>>>> until the VDUSE_UPDATE_IOTLB/VDUSE_INVALIDATE_IOTLB message is replied
>>>>> by userspace. Could it solve this problem?
>>>>
>>>>    I was thinking whether or not we need to generate IOTLB_INVALIDATE
>>>> message to VDUSE during dma_unmap (vduse_dev_unmap_page).
>>>>
>>>> If we don't, we're probably fine.
>>>>
>>> It seems not feasible. This message will be also used in the
>>> virtio-vdpa case to notify userspace to unmap some pages during
>>> consistent dma unmapping. Maybe we can document it to make sure the
>>> users can handle the message correctly.
>> Just to make sure I understand your point.
>>
>> Do you mean you plan to notify the unmap of 1) streaming DMA or 2)
>> coherent DMA?
>>
>> For 1) you probably need a workqueue to do that since dma unmap can
>> be done in irq or bh context. And if usrspace does't do the unmap, it
>> can still access the bounce buffer (if you don't zap pte)?
>>
> I plan to do it in the coherent DMA case.


Any reason for treating coherent DMA differently?


> It's true that userspace can
> access the dma buffer if userspace doesn't do the unmap. But the dma
> pages would not be freed and reused unless user space called munmap()
> for them.


I wonder whether or not we could recycle IOVA in this case to avoid the 
IOTLB_UMAP message.

Thanks


>
> Thanks,
> Yongji
>

