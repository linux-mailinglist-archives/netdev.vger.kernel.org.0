Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 874613929B8
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 10:43:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235548AbhE0IpZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 04:45:25 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:44632 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235499AbhE0IpY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 May 2021 04:45:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622105031;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Q4kOVJ8GB+3GLW+q/BipT5oGozNfefpPrW2ucSt2yL8=;
        b=d0ofvWbwb+F/Zhcxkyd5PrL6Z8KIhhsGVIx1i7G+4IQyJ2lzwF7piwtyUVKnr1yYhpexoQ
        Sw6jydP4FvGWpk6Q26qvdAjvVSfw8DXTLDsiEdDBhVl27jrL9YYsCZia/aUcR5RUxjGev/
        EErwR1WML7J+YzBrRuTbT9f+Z+RDGD4=
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com
 [209.85.215.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-511-D9WxF7BlPq29Q7dXMROT3A-1; Thu, 27 May 2021 04:43:50 -0400
X-MC-Unique: D9WxF7BlPq29Q7dXMROT3A-1
Received: by mail-pg1-f198.google.com with SMTP id m7-20020a6545c70000b029020f6af21c77so2541424pgr.6
        for <netdev@vger.kernel.org>; Thu, 27 May 2021 01:43:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=Q4kOVJ8GB+3GLW+q/BipT5oGozNfefpPrW2ucSt2yL8=;
        b=WgLBqbzoNDS1AU96WWn55NdCSD0G5ZCg8ux+QqEvn1yi3/c71AdgAVTpOpVHZoMalE
         gZcOo8QAyI37StFQ1CILibKgce714BGbY+rtAon0E2SrA4mxGsc6I6uw62mZy+dPUsOF
         h86wggZtQuExCFDGCm1UjImcfvlObmW2lqWgo1fP254mxocIihOfU90JhD8S67UybYFS
         /D58KCE2NdqZRAAVVpMrmIe8coqj3yeYXCQAdd5U71aEp8IH/P0gGq1hlCIsZC0VEBqI
         Ren3sz1zbnYq0qx5Axnv3xgJFlyGk/oNMtEmvewaP2/l6MGG91dCbwU1y64M6WLqeeQR
         2PcA==
X-Gm-Message-State: AOAM5306sGwOXu3pKixtJT4litQ4e+77NZatFbkfnvLeqpikx6QgNjmj
        LdMKrMdu4ddvpKmDs8wpipDQBS3xNomQcSz4UHSv2W8dUWN4Pgahh4l/QqZG0TaibQbJMdTKFgM
        9MIwXJFY6xZ1l7jo5
X-Received: by 2002:a17:902:aa42:b029:ee:f55a:b2c1 with SMTP id c2-20020a170902aa42b02900eef55ab2c1mr2283370plr.15.1622105028986;
        Thu, 27 May 2021 01:43:48 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxSObctLvNp4FosLHglZe975VrI39ki5xw8bXJ8rCFLiK5AHUwDmp+dxI3a8RKS9e1DfhzunA==
X-Received: by 2002:a17:902:aa42:b029:ee:f55a:b2c1 with SMTP id c2-20020a170902aa42b02900eef55ab2c1mr2283358plr.15.1622105028736;
        Thu, 27 May 2021 01:43:48 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id e29sm1364517pfm.110.2021.05.27.01.43.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 May 2021 01:43:48 -0700 (PDT)
Subject: Re: [PATCH v7 11/12] vduse: Introduce VDUSE - vDPA Device in
 Userspace
From:   Jason Wang <jasowang@redhat.com>
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
        virtualization <virtualization@lists.linux-foundation.org>,
        netdev@vger.kernel.org, kvm <kvm@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, iommu@lists.linux-foundation.org,
        linux-kernel <linux-kernel@vger.kernel.org>
References: <20210517095513.850-1-xieyongji@bytedance.com>
 <20210517095513.850-12-xieyongji@bytedance.com>
 <3740c7eb-e457-07f3-5048-917c8606275d@redhat.com>
 <CACycT3uAqa6azso_8MGreh+quj-JXO1piuGnrV8k2kTfc34N2g@mail.gmail.com>
 <5a68bb7c-fd05-ce02-cd61-8a601055c604@redhat.com>
 <CACycT3ve7YvKF+F+AnTQoJZMPua+jDvGMs_ox8GQe_=SGdeCMA@mail.gmail.com>
 <ee00efca-b26d-c1be-68d2-f9e34a735515@redhat.com>
 <CACycT3ufok97cKpk47NjUBTc0QAyfauFUyuFvhWKmuqCGJ7zZw@mail.gmail.com>
 <00ded99f-91b6-ba92-5d92-2366b163f129@redhat.com>
Message-ID: <3cc7407d-9637-227e-9afa-402b6894d8ac@redhat.com>
Date:   Thu, 27 May 2021 16:43:40 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <00ded99f-91b6-ba92-5d92-2366b163f129@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2021/5/27 下午4:41, Jason Wang 写道:
>
> 在 2021/5/27 下午3:34, Yongji Xie 写道:
>> On Thu, May 27, 2021 at 1:40 PM Jason Wang <jasowang@redhat.com> wrote:
>>>
>>> 在 2021/5/27 下午1:08, Yongji Xie 写道:
>>>> On Thu, May 27, 2021 at 1:00 PM Jason Wang <jasowang@redhat.com> 
>>>> wrote:
>>>>> 在 2021/5/27 下午12:57, Yongji Xie 写道:
>>>>>> On Thu, May 27, 2021 at 12:13 PM Jason Wang <jasowang@redhat.com> 
>>>>>> wrote:
>>>>>>> 在 2021/5/17 下午5:55, Xie Yongji 写道:
>>>>>>>> +
>>>>>>>> +static int vduse_dev_msg_sync(struct vduse_dev *dev,
>>>>>>>> +                           struct vduse_dev_msg *msg)
>>>>>>>> +{
>>>>>>>> +     init_waitqueue_head(&msg->waitq);
>>>>>>>> +     spin_lock(&dev->msg_lock);
>>>>>>>> +     vduse_enqueue_msg(&dev->send_list, msg);
>>>>>>>> +     wake_up(&dev->waitq);
>>>>>>>> +     spin_unlock(&dev->msg_lock);
>>>>>>>> +     wait_event_killable(msg->waitq, msg->completed);
>>>>>>> What happens if the userspace(malicous) doesn't give a response 
>>>>>>> forever?
>>>>>>>
>>>>>>> It looks like a DOS. If yes, we need to consider a way to fix that.
>>>>>>>
>>>>>> How about using wait_event_killable_timeout() instead?
>>>>> Probably, and then we need choose a suitable timeout and more 
>>>>> important,
>>>>> need to report the failure to virtio.
>>>>>
>>>> Makes sense to me. But it looks like some
>>>> vdpa_config_ops/virtio_config_ops such as set_status() didn't have a
>>>> return value.  Now I add a WARN_ON() for the failure. Do you mean we
>>>> need to add some change for virtio core to handle the failure?
>>>
>>> Maybe, but I'm not sure how hard we can do that.
>>>
>> We need to change all virtio device drivers in this way.
>
>
> Probably.
>
>
>>
>>> We had NEEDS_RESET but it looks we don't implement it.
>>>
>> Could it handle the failure of get_feature() and get/set_config()?
>
>
> Looks not:
>
> "
>
> The device SHOULD set DEVICE_NEEDS_RESET when it enters an error state 
> that a reset is needed. If DRIVER_OK is set, after it sets 
> DEVICE_NEEDS_RESET, the device MUST send a device configuration change 
> notification to the driver.
>
> "
>
> This looks implies that NEEDS_RESET may only work after device is 
> probed. But in the current design, even the reset() is not reliable.
>
>
>>
>>> Or a rough idea is that maybe need some relaxing to be coupled loosely
>>> with userspace. E.g the device (control path) is implemented in the
>>> kernel but the datapath is implemented in the userspace like TUN/TAP.
>>>
>> I think it can work for most cases. One problem is that the set_config
>> might change the behavior of the data path at runtime, e.g.
>> virtnet_set_mac_address() in the virtio-net driver and
>> cache_type_store() in the virtio-blk driver. Not sure if this path is
>> able to return before the datapath is aware of this change.
>
>
> Good point.
>
> But set_config() should be rare:
>
> E.g in the case of virtio-net with VERSION_1, config space is read 
> only, and it was set via control vq.
>
> For block, we can
>
> 1) start from without WCE or
> 2) we add a config change notification to userspace or
> 3) extend the spec to use vq instead of config space
>
> Thanks


Another thing if we want to go this way:

We need find a way to terminate the data path from the kernel side, to 
implement to reset semantic.

Thanks


>
>
>>
>> Thanks,
>> Yongji
>>

