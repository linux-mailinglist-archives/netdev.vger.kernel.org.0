Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03BA43B2582
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 05:35:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229934AbhFXDhW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 23:37:22 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:35068 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229774AbhFXDhU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Jun 2021 23:37:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624505701;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5QohIO9QZ56POeZsL8ywMd6mageIeyr6m/mT20FPwPo=;
        b=IvnMUpI8ARjUQ2px4raVHAzkZtw8Xe8nNM9kftL3XfBjKTJcrecktPUp7p9IcpR5MXDNGR
        DE5AgIzEme5gS3gO8raxa67tqctDueaqX9ZfAub2jdg0bSe8pbw5yfGlIiIvz+ic3rtRao
        E5g34nLDd19n6b7XaBsRfiqUYH2+tX8=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-544-e2P8yjemOZeFD7lBIMZhiw-1; Wed, 23 Jun 2021 23:34:59 -0400
X-MC-Unique: e2P8yjemOZeFD7lBIMZhiw-1
Received: by mail-pf1-f200.google.com with SMTP id b8-20020a056a000a88b02902e97a71383dso3051010pfl.13
        for <netdev@vger.kernel.org>; Wed, 23 Jun 2021 20:34:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=5QohIO9QZ56POeZsL8ywMd6mageIeyr6m/mT20FPwPo=;
        b=fLt5GF3L/URpUJduzYKx1c6uUNtS+KmnmovyV66MiT4li8H/TOZ0IGVi4ef8pRaJqL
         LZAppMncMPxJdNqPpCZ0d2LP5vayBGsbuRUskCCATpv3VinuW6eYXgDjaNAHikSe/SE7
         R4FVCggz4ljgwFX+wXGPnxV8cL/+ClBWpbV9Qg35jnOWRCkE8OT+DP3/aqf8nXl46QpI
         5q7LbN97pS6guh1H1v57446vDx1G34QfZV+9h0bkdWqyrmMD+xJSeyHibNsGaMMa2u7P
         hfiEZk9aeY8j4Geb5sRwQ/9ch7DWRWj56rEgr+sv3d/ZedYkUt2pdPPzwPawFcKnV3Rg
         bnfA==
X-Gm-Message-State: AOAM532VAPqTQUU5NeqimlMlgEjPai76oMa+csX0ekxgiZ70pJAwXNb9
        VR/TO1uioxD0ppvXXt/XGHEgomKcwnLvv0TFSYfvqcXO+L+mUuCAn2gw2vqipJ6n+Silwrc3O7g
        KXelqfw2Qs/JDaoj/
X-Received: by 2002:a17:90b:1191:: with SMTP id gk17mr2989114pjb.95.1624505698641;
        Wed, 23 Jun 2021 20:34:58 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxoEDvRxknwye7AvfyEaKP6cKcvSDe8Ou4kXVMU8NQ9OSeQD22thwiDze8XxBwVGv+OJzWxjg==
X-Received: by 2002:a17:90b:1191:: with SMTP id gk17mr2989081pjb.95.1624505698416;
        Wed, 23 Jun 2021 20:34:58 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id a15sm1101133pff.128.2021.06.23.20.34.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Jun 2021 20:34:57 -0700 (PDT)
Subject: Re: [PATCH v8 09/10] vduse: Introduce VDUSE - vDPA Device in
 Userspace
To:     Yongji Xie <xieyongji@bytedance.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
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
 <adfb2be9-9ed9-ca37-ac37-4cd00bdff349@redhat.com>
 <CACycT3tAON+-qZev+9EqyL2XbgH5HDspOqNt3ohQLQ8GqVK=EA@mail.gmail.com>
 <1bba439f-ffc8-c20e-e8a4-ac73e890c592@redhat.com>
 <CACycT3uzMJS7vw6MVMOgY4rb=SPfT2srV+8DPdwUVeELEiJgbA@mail.gmail.com>
 <0aeb7cb7-58e5-1a95-d830-68edd7e8ec2e@redhat.com>
 <CACycT3uuooKLNnpPHewGZ=q46Fap2P4XCFirdxxn=FxK+X1ECg@mail.gmail.com>
 <e4cdee72-b6b4-d055-9aac-3beae0e5e3e1@redhat.com>
 <CACycT3u8=_D3hCtJR+d5BgeUQMce6S7c_6P3CVfvWfYhCQeXFA@mail.gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <d2334f66-907c-2e9c-ea4f-f912008e9be8@redhat.com>
Date:   Thu, 24 Jun 2021 11:34:46 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <CACycT3u8=_D3hCtJR+d5BgeUQMce6S7c_6P3CVfvWfYhCQeXFA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2021/6/23 下午1:50, Yongji Xie 写道:
> On Wed, Jun 23, 2021 at 11:31 AM Jason Wang <jasowang@redhat.com> wrote:
>>
>> 在 2021/6/22 下午4:14, Yongji Xie 写道:
>>> On Tue, Jun 22, 2021 at 3:50 PM Jason Wang <jasowang@redhat.com> wrote:
>>>> 在 2021/6/22 下午3:22, Yongji Xie 写道:
>>>>>> We need fix a way to propagate the error to the userspace.
>>>>>>
>>>>>> E.g if we want to stop the deivce, we will delay the status reset until
>>>>>> we get respose from the userspace?
>>>>>>
>>>>> I didn't get how to delay the status reset. And should it be a DoS
>>>>> that we want to fix if the userspace doesn't give a response forever?
>>>> You're right. So let's make set_status() can fail first, then propagate
>>>> its failure via VHOST_VDPA_SET_STATUS.
>>>>
>>> OK. So we only need to propagate the failure in the vhost-vdpa case, right?
>>
>> I think not, we need to deal with the reset for virtio as well:
>>
>> E.g in register_virtio_devices(), we have:
>>
>>           /* We always start by resetting the device, in case a previous
>>            * driver messed it up.  This also tests that code path a
>> little. */
>>         dev->config->reset(dev);
>>
>> We probably need to make reset can fail and then fail the
>> register_virtio_device() as well.
>>
> OK, looks like virtio_add_status() and virtio_device_ready()[1] should
> be also modified if we need to propagate the failure in the
> virtio-vdpa case. Or do we only need to care about the reset case?
>
> [1] https://lore.kernel.org/lkml/20210517093428.670-1-xieyongji@bytedance.com/


My understanding is DRIVER_OK is not something that needs to be validated:

"

DRIVER_OK (4)
Indicates that the driver is set up and ready to drive the device.

"

Since the spec doesn't require to re-read the and check if DRIVER_OK is 
set in 3.1.1 Driver Requirements: Device Initialization.

It's more about "telling the device that driver is ready."

But we don have some status bit that requires the synchronization with 
the device.

1) FEATURES_OK, spec requires to re-read the status bit to check whether 
or it it was set by the device:

"

Re-read device status to ensure the FEATURES_OK bit is still set: 
otherwise, the device does not support our subset of features and the 
device is unusable.

"

This is useful for some device which can only support a subset of the 
features. E.g a device that can only work for packed virtqueue. This 
means the current design of set_features won't work, we need either:

1a) relay the set_features request to userspace

or

1b) introduce a mandated_device_features during device creation and 
validate the driver features during the set_features(), and don't set 
FEATURES_OK if they don't match.


2) Some transports (PCI) requires to re-read the status to ensure the 
synchronization.

"

After writing 0 to device_status, the driver MUST wait for a read of 
device_status to return 0 before reinitializing the device.

"

So we need to deal with both FEATURES_OK and reset, but probably not 
DRIVER_OK.

Thanks


>
> Thanks,
> Yongji
>

