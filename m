Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C3FF3BF489
	for <lists+netdev@lfdr.de>; Thu,  8 Jul 2021 06:23:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229594AbhGHE0Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Jul 2021 00:26:25 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:55718 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229482AbhGHE0Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Jul 2021 00:26:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625718223;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DNu1zHrcXhgpVSSnQcgsiGwDGO6YEQsjo75QjE9guwc=;
        b=H90+l8d3YqJRV2dBwAN4++YESgbW3rxIRAII/mRwOjx7cIxyalTsh3qL5kIP5Ej/KTuYfh
        Rnf6zwzWUS6n7HuIPivoaVhVZhGGvCEkI+QKJWTH3GUZ+6OIHLWcic+iMRbw0awLUUo/II
        RrklpVKYGzBr2akJ5PXLWz+YgaG1U0c=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-310-p5yn0SlpNXq9JSjN1qpzQQ-1; Thu, 08 Jul 2021 00:23:42 -0400
X-MC-Unique: p5yn0SlpNXq9JSjN1qpzQQ-1
Received: by mail-pj1-f70.google.com with SMTP id w13-20020a17090aea0db029017328cfc2ffso1742571pjy.5
        for <netdev@vger.kernel.org>; Wed, 07 Jul 2021 21:23:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=DNu1zHrcXhgpVSSnQcgsiGwDGO6YEQsjo75QjE9guwc=;
        b=RKuidf1my2/xEUL20W3Mykd4PrVBfRWsTfh5dTTDcHE/sI6AmkgrEwAus3PO/qWFzv
         KPPlx7sPEmGkbS6zyTwBJOHoyBdDNYKxTEP5n2iO2lt1SaIVKZrmB0DC8niMqTCKsL+5
         uMvCMzMk3r3aBKm5Ab1/fXtd08kNmZzX42InGwchMpydAPjEtjDURiarxMVSntSbM9yh
         h9RLOC3AVrxcYss0jejz74/iO16cJYNB6KK4kMV4JnTWxUQTcAPtu1UlymH99+QedLQi
         xcn7tLzgupRoTt1SdVAi3I/vj5XMSgOIG1WcOibQtc7Nbjy+PjF5YUo6WClYGPBPYE5k
         FUqg==
X-Gm-Message-State: AOAM530zkuyF0zwlPo7jc68cAXei/Wv5AUG2P9ShwTIVmhUrFyD8lSc9
        3RnRher4x6u9EGWYOf8NfP4rLvv5fpmFzdTDgtYPu9kN7Dn7i86nEXyk3DmsAqiQkuAVY0fgr96
        ABlh5yEte2zqQz+11
X-Received: by 2002:a17:902:aa86:b029:116:3e3a:2051 with SMTP id d6-20020a170902aa86b02901163e3a2051mr24239002plr.38.1625717888578;
        Wed, 07 Jul 2021 21:18:08 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzgPpvaVl8Rg4KqU5dAGuQXgjQhnKK5qnVXzUgmrqEO0suxCn8aS1zG54MnxoNvIGvMzyvnlw==
X-Received: by 2002:a17:902:aa86:b029:116:3e3a:2051 with SMTP id d6-20020a170902aa86b02901163e3a2051mr24238978plr.38.1625717888336;
        Wed, 07 Jul 2021 21:18:08 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id c64sm792630pfb.166.2021.07.07.21.18.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Jul 2021 21:18:07 -0700 (PDT)
Subject: Re: [PATCH v8 10/10] Documentation: Add documentation for VDUSE
To:     Stefan Hajnoczi <stefanha@redhat.com>
Cc:     Xie Yongji <xieyongji@bytedance.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Parav Pandit <parav@nvidia.com>,
        Christoph Hellwig <hch@infradead.org>,
        Christian Brauner <christian.brauner@canonical.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Matthew Wilcox <willy@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Jens Axboe <axboe@kernel.dk>,
        "bcrl@kvack.org" <bcrl@kvack.org>,
        Jonathan Corbet <corbet@lwn.net>,
        =?UTF-8?Q?Mika_Penttil=c3=a4?= <mika.penttila@nextfour.com>,
        Dan Carpenter <dan.carpenter@oracle.com>, joro@8bytes.org,
        gregkh@linuxfoundation.org,
        "songmuchun@bytedance.com" <songmuchun@bytedance.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
References: <CACycT3vo-diHgTSLw_FS2E+5ia5VjihE3qw7JmZR7JT55P-wQA@mail.gmail.com>
 <8320d26d-6637-85c6-8773-49553dfa502d@redhat.com>
 <YOL/9mxkJaokKDHc@stefanha-x1.localdomain>
 <5b5107fa-3b32-8a3b-720d-eee6b2a84ace@redhat.com>
 <YOQtG3gDOhHDO5CQ@stefanha-x1.localdomain>
 <CACGkMEs2HHbUfarum8uQ6wuXoDwLQUSXTsa-huJFiqr__4cwRg@mail.gmail.com>
 <YOSOsrQWySr0andk@stefanha-x1.localdomain>
 <100e6788-7fdf-1505-d69c-bc28a8bc7a78@redhat.com>
 <YOVr801d01YOPzLL@stefanha-x1.localdomain>
 <a03c8627-7dac-2255-a2d9-603fc623b618@redhat.com>
 <YOXOMiPl7mKd7FoM@stefanha-x1.localdomain>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <d5aef112-0828-6b79-4bce-753d3cd496c1@redhat.com>
Date:   Thu, 8 Jul 2021 12:17:56 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <YOXOMiPl7mKd7FoM@stefanha-x1.localdomain>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2021/7/7 下午11:54, Stefan Hajnoczi 写道:
> On Wed, Jul 07, 2021 at 05:24:08PM +0800, Jason Wang wrote:
>> 在 2021/7/7 下午4:55, Stefan Hajnoczi 写道:
>>> On Wed, Jul 07, 2021 at 11:43:28AM +0800, Jason Wang wrote:
>>>> 在 2021/7/7 上午1:11, Stefan Hajnoczi 写道:
>>>>> On Tue, Jul 06, 2021 at 09:08:26PM +0800, Jason Wang wrote:
>>>>>> On Tue, Jul 6, 2021 at 6:15 PM Stefan Hajnoczi <stefanha@redhat.com> wrote:
>>>>>>> On Tue, Jul 06, 2021 at 10:34:33AM +0800, Jason Wang wrote:
>>>>>>>> 在 2021/7/5 下午8:49, Stefan Hajnoczi 写道:
>>>>>>>>> On Mon, Jul 05, 2021 at 11:36:15AM +0800, Jason Wang wrote:
>>>>>>>>>> 在 2021/7/4 下午5:49, Yongji Xie 写道:
>>>>>>>>>>>>> OK, I get you now. Since the VIRTIO specification says "Device
>>>>>>>>>>>>> configuration space is generally used for rarely-changing or
>>>>>>>>>>>>> initialization-time parameters". I assume the VDUSE_DEV_SET_CONFIG
>>>>>>>>>>>>> ioctl should not be called frequently.
>>>>>>>>>>>> The spec uses MUST and other terms to define the precise requirements.
>>>>>>>>>>>> Here the language (especially the word "generally") is weaker and means
>>>>>>>>>>>> there may be exceptions.
>>>>>>>>>>>>
>>>>>>>>>>>> Another type of access that doesn't work with the VDUSE_DEV_SET_CONFIG
>>>>>>>>>>>> approach is reads that have side-effects. For example, imagine a field
>>>>>>>>>>>> containing an error code if the device encounters a problem unrelated to
>>>>>>>>>>>> a specific virtqueue request. Reading from this field resets the error
>>>>>>>>>>>> code to 0, saving the driver an extra configuration space write access
>>>>>>>>>>>> and possibly race conditions. It isn't possible to implement those
>>>>>>>>>>>> semantics suing VDUSE_DEV_SET_CONFIG. It's another corner case, but it
>>>>>>>>>>>> makes me think that the interface does not allow full VIRTIO semantics.
>>>>>>>>>> Note that though you're correct, my understanding is that config space is
>>>>>>>>>> not suitable for this kind of error propagating. And it would be very hard
>>>>>>>>>> to implement such kind of semantic in some transports.  Virtqueue should be
>>>>>>>>>> much better. As Yong Ji quoted, the config space is used for
>>>>>>>>>> "rarely-changing or intialization-time parameters".
>>>>>>>>>>
>>>>>>>>>>
>>>>>>>>>>> Agreed. I will use VDUSE_DEV_GET_CONFIG in the next version. And to
>>>>>>>>>>> handle the message failure, I'm going to add a return value to
>>>>>>>>>>> virtio_config_ops.get() and virtio_cread_* API so that the error can
>>>>>>>>>>> be propagated to the virtio device driver. Then the virtio-blk device
>>>>>>>>>>> driver can be modified to handle that.
>>>>>>>>>>>
>>>>>>>>>>> Jason and Stefan, what do you think of this way?
>>>>>>>>> Why does VDUSE_DEV_GET_CONFIG need to support an error return value?
>>>>>>>>>
>>>>>>>>> The VIRTIO spec provides no way for the device to report errors from
>>>>>>>>> config space accesses.
>>>>>>>>>
>>>>>>>>> The QEMU virtio-pci implementation returns -1 from invalid
>>>>>>>>> virtio_config_read*() and silently discards virtio_config_write*()
>>>>>>>>> accesses.
>>>>>>>>>
>>>>>>>>> VDUSE can take the same approach with
>>>>>>>>> VDUSE_DEV_GET_CONFIG/VDUSE_DEV_SET_CONFIG.
>>>>>>>>>
>>>>>>>>>> I'd like to stick to the current assumption thich get_config won't fail.
>>>>>>>>>> That is to say,
>>>>>>>>>>
>>>>>>>>>> 1) maintain a config in the kernel, make sure the config space read can
>>>>>>>>>> always succeed
>>>>>>>>>> 2) introduce an ioctl for the vduse usersapce to update the config space.
>>>>>>>>>> 3) we can synchronize with the vduse userspace during set_config
>>>>>>>>>>
>>>>>>>>>> Does this work?
>>>>>>>>> I noticed that caching is also allowed by the vhost-user protocol
>>>>>>>>> messages (QEMU's docs/interop/vhost-user.rst), but the device doesn't
>>>>>>>>> know whether or not caching is in effect. The interface you outlined
>>>>>>>>> above requires caching.
>>>>>>>>>
>>>>>>>>> Is there a reason why the host kernel vDPA code needs to cache the
>>>>>>>>> configuration space?
>>>>>>>> Because:
>>>>>>>>
>>>>>>>> 1) Kernel can not wait forever in get_config(), this is the major difference
>>>>>>>> with vhost-user.
>>>>>>> virtio_cread() can sleep:
>>>>>>>
>>>>>>>      #define virtio_cread(vdev, structname, member, ptr)                     \
>>>>>>>              do {                                                            \
>>>>>>>                      typeof(((structname*)0)->member) virtio_cread_v;        \
>>>>>>>                                                                              \
>>>>>>>                      might_sleep();                                          \
>>>>>>>                      ^^^^^^^^^^^^^^
>>>>>>>
>>>>>>> Which code path cannot sleep?
>>>>>> Well, it can sleep but it can't sleep forever. For VDUSE, a
>>>>>> buggy/malicious userspace may refuse to respond to the get_config.
>>>>>>
>>>>>> It looks to me the ideal case, with the current virtio spec, for VDUSE is to
>>>>>>
>>>>>> 1) maintain the device and its state in the kernel, userspace may sync
>>>>>> with the kernel device via ioctls
>>>>>> 2) offload the datapath (virtqueue) to the userspace
>>>>>>
>>>>>> This seems more robust and safe than simply relaying everything to
>>>>>> userspace and waiting for its response.
>>>>>>
>>>>>> And we know for sure this model can work, an example is TUN/TAP:
>>>>>> netdevice is abstracted in the kernel and datapath is done via
>>>>>> sendmsg()/recvmsg().
>>>>>>
>>>>>> Maintaining the config in the kernel follows this model and it can
>>>>>> simplify the device generation implementation.
>>>>>>
>>>>>> For config space write, it requires more thought but fortunately it's
>>>>>> not commonly used. So VDUSE can choose to filter out the
>>>>>> device/features that depends on the config write.
>>>>> This is the problem. There are other messages like SET_FEATURES where I
>>>>> guess we'll face the same challenge.
>>>> Probably not, userspace device can tell the kernel about the device_features
>>>> and mandated_features during creation, and the feature negotiation could be
>>>> done purely in the kernel without bothering the userspace.
>>
>> (For some reason I drop the list accidentally, adding them back, sorry)
>>
>>
>>> Sorry, I confused the messages. I meant SET_STATUS. It's a synchronous
>>> interface where the driver waits for the device.
>>
>> It depends on how we define "synchronous" here. If I understand correctly,
>> the spec doesn't expect there will be any kind of failure for the operation
>> of set_status itself.
>>
>> Instead, anytime it want any synchronization, it should be done via
>> get_status():
>>
>> 1) re-read device status to make sure FEATURES_OK is set during feature
>> negotiation
>> 2) re-read device status to be 0 to make sure the device has finish the
>> reset
>>
>>
>>> VDUSE currently doesn't wait for the device emulation process to handle
>>> this message (no reply is needed) but I think this is a mistake because
>>> VDUSE is not following the VIRTIO device model.
>>
>> With the trick that is done for FEATURES_OK above, I think we don't need to
>> wait for the reply.
>>
>> If userspace takes too long to respond, it can be detected since
>> get_status() doesn't return the expected value for long time.
>>
>> And for the case that needs a timeout, we probably can use NEEDS_RESET.
> I think you're right. get_status is the synchronization point, not
> set_status.
>
> Currently there is no VDUSE GET_STATUS message. The
> VDUSE_START/STOP_DATAPLANE messages could be changed to SET_STATUS so
> that the device emulation program can participate in emulating the
> Device Status field.


I'm not sure I get this, but it is what has been done?

+static void vduse_vdpa_set_status(struct vdpa_device *vdpa, u8 status)
+{
+    struct vduse_dev *dev = vdpa_to_vduse(vdpa);
+    bool started = !!(status & VIRTIO_CONFIG_S_DRIVER_OK);
+
+    dev->status = status;
+
+    if (dev->started == started)
+        return;
+
+    dev->started = started;
+    if (dev->started) {
+        vduse_dev_start_dataplane(dev);
+    } else {
+        vduse_dev_reset(dev);
+        vduse_dev_stop_dataplane(dev);
+    }
+}


But the looks not correct:

1) !DRIVER_OK doesn't means a reset?
2) Need to deal with FEATURES_OK

Thanks


>   This change could affect VDUSE's VIRTIO feature
> interface since the device emulation program can reject features by not
> setting FEATURES_OK.
>
> Stefan

