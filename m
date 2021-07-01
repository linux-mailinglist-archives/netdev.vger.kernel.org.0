Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1032F3B8E6A
	for <lists+netdev@lfdr.de>; Thu,  1 Jul 2021 09:56:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234925AbhGAH6Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Jul 2021 03:58:24 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:32737 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234576AbhGAH6X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Jul 2021 03:58:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625126153;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3kkO+UX+kTqcYTfctkZezZWjIyhRJe4+TF27ND409mQ=;
        b=jHLWW9mKaiIBq4ooDnWmNq2ZVMEIEwm193hJjk11OAmBtTv4vXADaVQEV8gNwru1vonUks
        vHjmivUcl79+Ze+lVQEMLS4KjDu7wqaI/qwO3zm7WKcIjH5saMeDYZqNY9yYGXW3c2LatM
        g3FpI80j/kdOcpf2ib0XbYLfptxd1lc=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-534-_OEaNLC2PLO8bAQhPcsqyw-1; Thu, 01 Jul 2021 03:55:52 -0400
X-MC-Unique: _OEaNLC2PLO8bAQhPcsqyw-1
Received: by mail-pf1-f200.google.com with SMTP id m14-20020aa78a0e0000b029030531e994a3so3525208pfa.12
        for <netdev@vger.kernel.org>; Thu, 01 Jul 2021 00:55:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=3kkO+UX+kTqcYTfctkZezZWjIyhRJe4+TF27ND409mQ=;
        b=I8nYIj92RhPLQuvhk9uw5CH/TXojVLr4BDn8cF447mS+5+jspLZbHWioMQUFIKlw6n
         MISfapozle4cmCrof6hhnTqmK0JVJCQ+LtyYDGCFjfajQiol9YkixYeyqyozG9QW8Qsj
         iPULPfTHWuHEBTRsKDUSTNtZ5sHl7P9YA0w1qX8PQypHWuLgX2O2RDJOt3uSqgvp9nvG
         Hp6j77NqiNhgu9UVQ8kNxpTPrC7qvrRBqJoOt5zz/PFERomPr3R0dFTRvEj4VNtjHjKG
         dI9bywkeNRe/0rFpnOBbwaHII0w3B7JcR6d3AMaGPZ5dZ2idC4Wj9/qNDM4ecyvEM5Mm
         AjtQ==
X-Gm-Message-State: AOAM533gAv71VcNKYlx01SWSQyVLVcUDAIYExSg5rKgsqMlXZk4F98PG
        TTJfYrm7QJ9ww/gtyhNh1jADsALrFco7T5Kh6MJ+AXibdl6j0kBQCw3otf895LRBG+vNwagSfrf
        yymrhYlIlLCmn2G5f
X-Received: by 2002:a63:794:: with SMTP id 142mr6983310pgh.198.1625126151673;
        Thu, 01 Jul 2021 00:55:51 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx+FJQkpNj2SGJqmkRE0B+JqnTbGGKE300PtWwx2ZJ5+wT2j2YuZ2VlEIodQZCrR0j2AFzwoQ==
X-Received: by 2002:a63:794:: with SMTP id 142mr6983291pgh.198.1625126151412;
        Thu, 01 Jul 2021 00:55:51 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id a6sm23966070pfo.212.2021.07.01.00.55.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Jul 2021 00:55:50 -0700 (PDT)
Subject: Re: [PATCH v8 09/10] vduse: Introduce VDUSE - vDPA Device in
 Userspace
To:     Yongji Xie <xieyongji@bytedance.com>,
        Stefan Hajnoczi <stefanha@redhat.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Parav Pandit <parav@nvidia.com>,
        Christoph Hellwig <hch@infradead.org>,
        Christian Brauner <christian.brauner@canonical.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Matthew Wilcox <willy@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Jens Axboe <axboe@kernel.dk>, bcrl@kvack.org,
        Jonathan Corbet <corbet@lwn.net>,
        =?UTF-8?Q?Mika_Penttil=c3=a4?= <mika.penttila@nextfour.com>,
        Dan Carpenter <dan.carpenter@oracle.com>, joro@8bytes.org,
        Greg KH <gregkh@linuxfoundation.org>, songmuchun@bytedance.com,
        virtualization <virtualization@lists.linux-foundation.org>,
        netdev@vger.kernel.org, kvm <kvm@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, iommu@lists.linux-foundation.org,
        linux-kernel <linux-kernel@vger.kernel.org>
References: <20210615141331.407-1-xieyongji@bytedance.com>
 <20210615141331.407-10-xieyongji@bytedance.com>
 <YNSatrDFsg+4VvH4@stefanha-x1.localdomain>
 <CACycT3vaXQ4dxC9QUzXXJs7og6TVqqVGa8uHZnTStacsYAiFwQ@mail.gmail.com>
 <YNw+q/ADMPviZi6S@stefanha-x1.localdomain>
 <CACycT3t6M5i0gznABm52v=rdmeeLZu8smXAOLg+WsM3WY1fgTw@mail.gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <7264cb0b-7072-098e-3d22-2b7e89216545@redhat.com>
Date:   Thu, 1 Jul 2021 15:55:36 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <CACycT3t6M5i0gznABm52v=rdmeeLZu8smXAOLg+WsM3WY1fgTw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2021/7/1 下午2:50, Yongji Xie 写道:
> On Wed, Jun 30, 2021 at 5:51 PM Stefan Hajnoczi <stefanha@redhat.com> wrote:
>> On Tue, Jun 29, 2021 at 10:59:51AM +0800, Yongji Xie wrote:
>>> On Mon, Jun 28, 2021 at 9:02 PM Stefan Hajnoczi <stefanha@redhat.com> wrote:
>>>> On Tue, Jun 15, 2021 at 10:13:30PM +0800, Xie Yongji wrote:
>>>>> +/* ioctls */
>>>>> +
>>>>> +struct vduse_dev_config {
>>>>> +     char name[VDUSE_NAME_MAX]; /* vduse device name */
>>>>> +     __u32 vendor_id; /* virtio vendor id */
>>>>> +     __u32 device_id; /* virtio device id */
>>>>> +     __u64 features; /* device features */
>>>>> +     __u64 bounce_size; /* bounce buffer size for iommu */
>>>>> +     __u16 vq_size_max; /* the max size of virtqueue */
>>>> The VIRTIO specification allows per-virtqueue sizes. A device can have
>>>> two virtqueues, where the first one allows up to 1024 descriptors and
>>>> the second one allows only 128 descriptors, for example.
>>>>
>>> Good point! But it looks like virtio-vdpa/virtio-pci doesn't support
>>> that now. All virtqueues have the same maximum size.
>> I see struct vpda_config_ops only supports a per-device max vq size:
>> u16 (*get_vq_num_max)(struct vdpa_device *vdev);
>>
>> virtio-pci supports per-virtqueue sizes because the struct
>> virtio_pci_common_cfg->queue_size register is per-queue (controlled by
>> queue_select).
>>
> Oh, yes. I miss queue_select.
>
>> I guess this is a question for Jason: will vdpa will keep this limitation?
>> If yes, then VDUSE can stick to it too without running into problems in
>> the future.


I think it's better to extend the get_vq_num_max() per virtqueue.

Currently, vDPA assumes the parent to have a global max size. This seems 
to work on most of the parents but not vp-vDPA (which could be backed by 
QEMU, in that case cvq's size is smaller).

Fortunately, we haven't enabled had cvq support in the userspace now.

I can post the fixes.


>>
>>>>> +     __u16 padding; /* padding */
>>>>> +     __u32 vq_num; /* the number of virtqueues */
>>>>> +     __u32 vq_align; /* the allocation alignment of virtqueue's metadata */
>>>> I'm not sure what this is?
>>>>
>>>   This will be used by vring_create_virtqueue() too.
>> If there is no official definition for the meaning of this value then
>> "/* same as vring_create_virtqueue()'s vring_align parameter */" would
>> be clearer. That way the reader knows what to research in order to
>> understand how this field works.
>>
> OK.
>
>> I don't remember but maybe it was used to support vrings when the
>> host/guest have non-4KB page sizes. I wonder if anyone has an official
>> definition for this value?
> Not sure. Maybe we might need some alignment which is less than
> PAGE_SIZE sometimes.


So I see CCW always use 4096, but I'm not sure whether or not it's 
smaller than PAGE_SIZE.

Thanks


>
> Thanks,
> Yongji
>

