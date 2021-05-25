Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00B7D38FB11
	for <lists+netdev@lfdr.de>; Tue, 25 May 2021 08:41:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231349AbhEYGmn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 May 2021 02:42:43 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:26716 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230465AbhEYGmk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 May 2021 02:42:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621924871;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kLSwktyFZs8E7VOwk5zUKYu4aQ38NyP9gI4c+eI8elE=;
        b=ildTRYDEVgGruupSsdPZMZ33vcNyKjAbc68c+BghAtVGmHqp9hg4D/FB6mep/w9F8/aBwL
        aST6GOcZ956OsllGE5ybvj6A/54LlfPW4LE9MprKAiRDl6CU2PyqvjZe9+UeNdbkp3lFYu
        iMoRsSu5jHvGM9TK1x87ROjiIZSPwSs=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-149-j4V1AKPkMTqrnnYg4-nw1Q-1; Tue, 25 May 2021 02:41:08 -0400
X-MC-Unique: j4V1AKPkMTqrnnYg4-nw1Q-1
Received: by mail-pj1-f71.google.com with SMTP id f15-20020a17090aa78fb029015c411f061bso15590154pjq.4
        for <netdev@vger.kernel.org>; Mon, 24 May 2021 23:41:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=kLSwktyFZs8E7VOwk5zUKYu4aQ38NyP9gI4c+eI8elE=;
        b=i+zWNn6J8+TWQAQTnskrxlewHxEWNyXgtBOAB8MGrj6Uc202Z22X+ksuuOOgsWd9SE
         9bEZ5BQAmJrxuk7QFOfK3PMLF5NJvQOPfzeIVTxYvVrgdEccOyu64i8v9n8Da2wyJ7z6
         JsNrqKWkWvImxLQcHOvHDTFV+OhawdhaWc2w0qMTcLkcgPJsJW4l9SLTO4YydULRMfh2
         oCM5NU4fcEwEa4N23DSUzV4xDCL/iqBCajz9CTRa7FqFoah2kpWvc7a9LwDiNU8tzI/e
         r1UfnLYInSWVMh+GSeYPLvRsWg81vDMAM7iOXTf9GTnJGnUGamJ6k988hP4/U5oIcJH+
         dfMg==
X-Gm-Message-State: AOAM531z8ldAKlDQ/VUU7HBEgjp4Q+Bcq6BSBgxwPa3qZsjCX8s201ED
        +oJhWUndyngeSIYYfWFyJnoiaXJeK3OXutbBoeA0YIO6e+oN0h9TheTPXCfDV8D4hDuQG++N+vB
        nLLdLWw4oF8yI0Z95
X-Received: by 2002:a62:1a0d:0:b029:2da:21a6:6838 with SMTP id a13-20020a621a0d0000b02902da21a66838mr28058938pfa.76.1621924866773;
        Mon, 24 May 2021 23:41:06 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxVyOOkl2rdMpz8JwUhVMKIvPn854Rr2/gwU3WBwB4yeNP+uBLNOYgawAwFCiB5p2EW6WnAew==
X-Received: by 2002:a62:1a0d:0:b029:2da:21a6:6838 with SMTP id a13-20020a621a0d0000b02902da21a66838mr28058912pfa.76.1621924866445;
        Mon, 24 May 2021 23:41:06 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id x29sm13141650pgl.49.2021.05.24.23.40.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 May 2021 23:41:06 -0700 (PDT)
Subject: Re: [PATCH v7 00/12] Introduce VDUSE - vDPA Device in Userspace
To:     Yongji Xie <xieyongji@bytedance.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
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
 <20210520014349-mutt-send-email-mst@kernel.org>
 <CACycT3tKY2V=dmOJjeiZxkqA3cH8_KF93NNbRnNU04e5Job2cw@mail.gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <2a79fa0f-352d-b8e9-f60a-181960d054ec@redhat.com>
Date:   Tue, 25 May 2021 14:40:57 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <CACycT3tKY2V=dmOJjeiZxkqA3cH8_KF93NNbRnNU04e5Job2cw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2021/5/20 下午5:06, Yongji Xie 写道:
> On Thu, May 20, 2021 at 2:06 PM Michael S. Tsirkin <mst@redhat.com> wrote:
>> On Mon, May 17, 2021 at 05:55:01PM +0800, Xie Yongji wrote:
>>> This series introduces a framework, which can be used to implement
>>> vDPA Devices in a userspace program. The work consist of two parts:
>>> control path forwarding and data path offloading.
>>>
>>> In the control path, the VDUSE driver will make use of message
>>> mechnism to forward the config operation from vdpa bus driver
>>> to userspace. Userspace can use read()/write() to receive/reply
>>> those control messages.
>>>
>>> In the data path, the core is mapping dma buffer into VDUSE
>>> daemon's address space, which can be implemented in different ways
>>> depending on the vdpa bus to which the vDPA device is attached.
>>>
>>> In virtio-vdpa case, we implements a MMU-based on-chip IOMMU driver with
>>> bounce-buffering mechanism to achieve that. And in vhost-vdpa case, the dma
>>> buffer is reside in a userspace memory region which can be shared to the
>>> VDUSE userspace processs via transferring the shmfd.
>>>
>>> The details and our user case is shown below:
>>>
>>> ------------------------    -------------------------   ----------------------------------------------
>>> |            Container |    |              QEMU(VM) |   |                               VDUSE daemon |
>>> |       ---------      |    |  -------------------  |   | ------------------------- ---------------- |
>>> |       |dev/vdx|      |    |  |/dev/vhost-vdpa-x|  |   | | vDPA device emulation | | block driver | |
>>> ------------+-----------     -----------+------------   -------------+----------------------+---------
>>>              |                           |                            |                      |
>>>              |                           |                            |                      |
>>> ------------+---------------------------+----------------------------+----------------------+---------
>>> |    | block device |           |  vhost device |            | vduse driver |          | TCP/IP |    |
>>> |    -------+--------           --------+--------            -------+--------          -----+----    |
>>> |           |                           |                           |                       |        |
>>> | ----------+----------       ----------+-----------         -------+-------                |        |
>>> | | virtio-blk driver |       |  vhost-vdpa driver |         | vdpa device |                |        |
>>> | ----------+----------       ----------+-----------         -------+-------                |        |
>>> |           |      virtio bus           |                           |                       |        |
>>> |   --------+----+-----------           |                           |                       |        |
>>> |                |                      |                           |                       |        |
>>> |      ----------+----------            |                           |                       |        |
>>> |      | virtio-blk device |            |                           |                       |        |
>>> |      ----------+----------            |                           |                       |        |
>>> |                |                      |                           |                       |        |
>>> |     -----------+-----------           |                           |                       |        |
>>> |     |  virtio-vdpa driver |           |                           |                       |        |
>>> |     -----------+-----------           |                           |                       |        |
>>> |                |                      |                           |    vdpa bus           |        |
>>> |     -----------+----------------------+---------------------------+------------           |        |
>>> |                                                                                        ---+---     |
>>> -----------------------------------------------------------------------------------------| NIC |------
>>>                                                                                           ---+---
>>>                                                                                              |
>>>                                                                                     ---------+---------
>>>                                                                                     | Remote Storages |
>>>                                                                                     -------------------
>>>
>>> We make use of it to implement a block device connecting to
>>> our distributed storage, which can be used both in containers and
>>> VMs. Thus, we can have an unified technology stack in this two cases.
>>>
>>> To test it with null-blk:
>>>
>>>    $ qemu-storage-daemon \
>>>        --chardev socket,id=charmonitor,path=/tmp/qmp.sock,server,nowait \
>>>        --monitor chardev=charmonitor \
>>>        --blockdev driver=host_device,cache.direct=on,aio=native,filename=/dev/nullb0,node-name=disk0 \
>>>        --export type=vduse-blk,id=test,node-name=disk0,writable=on,name=vduse-null,num-queues=16,queue-size=128
>>>
>>> The qemu-storage-daemon can be found at https://github.com/bytedance/qemu/tree/vduse
>>>
>>> To make the userspace VDUSE processes such as qemu-storage-daemon able to
>>> run unprivileged. We did some works on virtio driver to avoid trusting
>>> device, including:
>>>
>>>    - validating the device status:
>>>
>>>      * https://lore.kernel.org/lkml/20210517093428.670-1-xieyongji@bytedance.com/
>>>
>>>    - validating the used length:
>>>
>>>      * https://lore.kernel.org/lkml/20210517090836.533-1-xieyongji@bytedance.com/
>>>
>>>    - validating the device config:
>>>
>>>      * patch 4 ("virtio-blk: Add validation for block size in config space")
>>>
>>>    - validating the device response:
>>>
>>>      * patch 5 ("virtio_scsi: Add validation for residual bytes from response")
>>>
>>> Since I'm not sure if I missing something during auditing, especially on some
>>> virtio device drivers that I'm not familiar with, now we only support emualting
>>> a few vDPA devices by default, including: virtio-net device, virtio-blk device,
>>> virtio-scsi device and virtio-fs device. This limitation can help to reduce
>>> security risks.
>> I suspect there are a lot of assumptions even with these 4.
>> Just what are the security assumptions and guarantees here?


Note that VDUSE is not the only device that may suffer from this, 
here're two others:

1) Encrypted VM
2) Smart NICs


> The attack surface from a virtio device is limited with IOMMU enabled.
> It should be able to avoid security risk if we can validate all data
> such as config space and used length from device in device driver.
>
>> E.g. it seems pretty clear that exposing a malformed FS
>> to a random kernel config can cause untold mischief.
>>
>> Things like virtnet_send_command are also an easy way for
>> the device to DOS the kernel.


I think the virtnet_send_command() needs to use interrupt instead of 
polling.

Thanks


>> And before you try to add
>> an arbitrary timeout there - please don't,
>> the fix is moving things that must be guaranteed into kernel
>> and making things that are not guaranteed asynchronous.
>> Right now there are some things that happen with locks taken,
>> where if we don't wait for device we lose the ability to report failures
>> to userspace. E.g. all kind of netlink things are like this.
>> One can think of a bunch of ways to address this, this
>> needs to be discussed with the relevant subsystem maintainers.
>>
>>
>> If I were you I would start with one type of device, and as simple one
>> as possible.
>>
> Make sense to me. The virtio-blk device might be a good start. We
> already have some existing interface like NBD to do similar things.
>
>>
>>> When a sysadmin trusts the userspace process enough, it can relax
>>> the limitation with a 'allow_unsafe_device_emulation' module parameter.
>> That's not a great security interface. It's a global module specific knob
>> that just allows any userspace to emulate anything at all.
>> Coming up with a reasonable interface isn't going to be easy.
>> For now maybe just have people patch their kernels if they want to
>> move fast and break things.
>>
> OK. A reasonable interface can be added if we need it in the future.
>
> Thanks,
> Yongji

