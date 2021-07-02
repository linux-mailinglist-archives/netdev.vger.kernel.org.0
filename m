Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 318B63B9B05
	for <lists+netdev@lfdr.de>; Fri,  2 Jul 2021 05:25:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234899AbhGBD2B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Jul 2021 23:28:01 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:45143 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234859AbhGBD16 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Jul 2021 23:27:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625196327;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KnDTUBO/qel2LJGKzNIBMBJoNluIIwfxXdRX1zb5ugw=;
        b=BwKbchlaUmuikYl4oojjCU4TUBykBYIj94wm8Id2MfOokQ1awVY7JBjvziP5icaTabCvMT
        CgrBAzf5Si9GkWvfOm5RgaEvrc1mH7pZnNipIyX+XnrrIAFUkVaKIepqxKuNnDmMBzZ6IF
        S5Cw+ulDyFrUAQGMoCgH6A7Yt8YIRe8=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-441-K6hK_VFHOBWEniVB9tqMNw-1; Thu, 01 Jul 2021 23:25:26 -0400
X-MC-Unique: K6hK_VFHOBWEniVB9tqMNw-1
Received: by mail-pg1-f200.google.com with SMTP id b125-20020a6367830000b0290227fc6e43a5so5620251pgc.18
        for <netdev@vger.kernel.org>; Thu, 01 Jul 2021 20:25:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=KnDTUBO/qel2LJGKzNIBMBJoNluIIwfxXdRX1zb5ugw=;
        b=XYuj05KwoSnxXi56tHjmh+zEBuqiZdFN8jOdX/ClwJJ3viuBny4i4NAeAAo5YLQykL
         LJW+ACwRyAkJZ6n7MMbeuLX9GMaooP3qwmzzNgCt2EObOG9nn3hqeQXEblOZdAqZPLzt
         B310yQVoCS8SD7HaGtSo4Raeq3mVlu43LehDnnb05Sb7wPeuJs39s/qIHlujothuzt6L
         yOowKRgtrShRzzlmlu7ycTl6gSfA0GxLNz2JAlFHGigXWGnBmUkNVn/d41NYHbxBLVJC
         fqINaoBfZsOSWJjGLvxWh6f8tGBQBe7B+zeKstkL0tVxPybp0OHKXKI/WjKfEUQecG25
         HdVw==
X-Gm-Message-State: AOAM532D+Gr5KRki2fiOGykBMLXgAsv239PeHmiaogLrZEQzvwLXSZS8
        G3KrUpIxai3XLiIdtTBz+DIFe7LGH+iI14e1dFUdSxM7XDoOft9OB+UXSDxjJi+6TnQkQjVxWxP
        dIwjEK1tHxdD+5EoK
X-Received: by 2002:a05:6a00:174e:b029:308:35eb:4593 with SMTP id j14-20020a056a00174eb029030835eb4593mr3353622pfc.8.1625196324986;
        Thu, 01 Jul 2021 20:25:24 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyKMQl/tw5Kx6FHOmk54WvFeYF610dbfRRBBaUlCrS6TkxAlUSkb5jlHy46VzHh0+l9ZFtiag==
X-Received: by 2002:a05:6a00:174e:b029:308:35eb:4593 with SMTP id j14-20020a056a00174eb029030835eb4593mr3353600pfc.8.1625196324718;
        Thu, 01 Jul 2021 20:25:24 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id p17sm11147627pjg.54.2021.07.01.20.25.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Jul 2021 20:25:23 -0700 (PDT)
Subject: Re: [PATCH v8 09/10] vduse: Introduce VDUSE - vDPA Device in
 Userspace
To:     Yongji Xie <xieyongji@bytedance.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
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
 <7264cb0b-7072-098e-3d22-2b7e89216545@redhat.com>
 <CACycT3v7pYXAFtijPgWCMZ2WXxjT2Y-DUwS3hN_T7dhfE5o_6g@mail.gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <c7d3473c-f855-166b-f4da-47be5a329859@redhat.com>
Date:   Fri, 2 Jul 2021 11:25:15 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <CACycT3v7pYXAFtijPgWCMZ2WXxjT2Y-DUwS3hN_T7dhfE5o_6g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2021/7/1 下午6:26, Yongji Xie 写道:
> On Thu, Jul 1, 2021 at 3:55 PM Jason Wang <jasowang@redhat.com> wrote:
>>
>> 在 2021/7/1 下午2:50, Yongji Xie 写道:
>>> On Wed, Jun 30, 2021 at 5:51 PM Stefan Hajnoczi <stefanha@redhat.com> wrote:
>>>> On Tue, Jun 29, 2021 at 10:59:51AM +0800, Yongji Xie wrote:
>>>>> On Mon, Jun 28, 2021 at 9:02 PM Stefan Hajnoczi <stefanha@redhat.com> wrote:
>>>>>> On Tue, Jun 15, 2021 at 10:13:30PM +0800, Xie Yongji wrote:
>>>>>>> +/* ioctls */
>>>>>>> +
>>>>>>> +struct vduse_dev_config {
>>>>>>> +     char name[VDUSE_NAME_MAX]; /* vduse device name */
>>>>>>> +     __u32 vendor_id; /* virtio vendor id */
>>>>>>> +     __u32 device_id; /* virtio device id */
>>>>>>> +     __u64 features; /* device features */
>>>>>>> +     __u64 bounce_size; /* bounce buffer size for iommu */
>>>>>>> +     __u16 vq_size_max; /* the max size of virtqueue */
>>>>>> The VIRTIO specification allows per-virtqueue sizes. A device can have
>>>>>> two virtqueues, where the first one allows up to 1024 descriptors and
>>>>>> the second one allows only 128 descriptors, for example.
>>>>>>
>>>>> Good point! But it looks like virtio-vdpa/virtio-pci doesn't support
>>>>> that now. All virtqueues have the same maximum size.
>>>> I see struct vpda_config_ops only supports a per-device max vq size:
>>>> u16 (*get_vq_num_max)(struct vdpa_device *vdev);
>>>>
>>>> virtio-pci supports per-virtqueue sizes because the struct
>>>> virtio_pci_common_cfg->queue_size register is per-queue (controlled by
>>>> queue_select).
>>>>
>>> Oh, yes. I miss queue_select.
>>>
>>>> I guess this is a question for Jason: will vdpa will keep this limitation?
>>>> If yes, then VDUSE can stick to it too without running into problems in
>>>> the future.
>>
>> I think it's better to extend the get_vq_num_max() per virtqueue.
>>
>> Currently, vDPA assumes the parent to have a global max size. This seems
>> to work on most of the parents but not vp-vDPA (which could be backed by
>> QEMU, in that case cvq's size is smaller).
>>
>> Fortunately, we haven't enabled had cvq support in the userspace now.
>>
>> I can post the fixes.
>>
> OK. If so, it looks like we need to support the per-vq configuration.
> I wonder if it's better to use something like: VDUSE_CREATE_DEVICE ->
> VDUSE_SETUP_VQ -> VDUSE_SETUP_VQ -> ... -> VDUSE_ENABLE_DEVICE to do
> initialization rather than only use VDUSE_CREATE_DEVICE.


This should be fine.

Thanks


>
> Thanks,
> Yongji
>

