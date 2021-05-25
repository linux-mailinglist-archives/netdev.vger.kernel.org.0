Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1ACC38FB27
	for <lists+netdev@lfdr.de>; Tue, 25 May 2021 08:48:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231395AbhEYGuL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 May 2021 02:50:11 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:26549 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231364AbhEYGuJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 May 2021 02:50:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621925320;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ul3miHPA+1C0mVf5IsSNMuGBmo+BqIM3N/sQ86Z+ItM=;
        b=MH3+bMFzvyVKEJIrrqwy0liIA1OeDGOZ6p13LDotaHU67k49XxGwAjuwCzjIGkUvyB/NqF
        ByHhfqR9PmhqpTyqSx83ll59tRKRxLkCqlF7y8WyeuG7wmK2dqMyX7uHQIQpTrJug5eEND
        SXnCFoewWC3IN+RwURN9QB6O6rDaxS4=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-348-U2ZC4gcxPYGjex15_Tm1zA-1; Tue, 25 May 2021 02:48:38 -0400
X-MC-Unique: U2ZC4gcxPYGjex15_Tm1zA-1
Received: by mail-wr1-f72.google.com with SMTP id f19-20020adfb6130000b02901121afc9a31so7448656wre.10
        for <netdev@vger.kernel.org>; Mon, 24 May 2021 23:48:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=ul3miHPA+1C0mVf5IsSNMuGBmo+BqIM3N/sQ86Z+ItM=;
        b=dk8VJZyYS3VZG1YNF6fdMfzh1TXDtpQMrIcXEYOlNZVk3StdefnaWcu6x7KajlXIAB
         0/Wzzw85Isq8OLNhlLhow3SmNvxSxmnyQBWFpbLJZJtOOO81XYUjliOEkx6qoaATnnpk
         WCEXtK77pJGe3n6i1QglHIelHlgGpiiWOVwMBEVSMTfJd+Io1sGyazfk2u0PmlYQRnoL
         a+PvzUPgYvHBMu473/T8R04WY47UMxKU5LmBsk+oB7Hln+aDtlte+6zlakUkq2vb7xcY
         RzDkHlWBrNlBUsB5ZY+2ggycxZ0NOUd9fdanRpLUdZMFCdKuiAcchFYGXkaXYHxjhPfg
         mLMw==
X-Gm-Message-State: AOAM530JyM3NLbi6LpkC/FKXFZFB791cUOprNAEnnNV6fLvGZsXe/Hgh
        3qFOCQyHB3YpSRt0bK7O4ab9cq9YcGvcTvzrxYtCGcMzX5gnayfAB+87HaFa6z+mtsOMllDnWAz
        rsybLLsrX2OTzdbdy
X-Received: by 2002:a5d:58d0:: with SMTP id o16mr25535521wrf.420.1621925317003;
        Mon, 24 May 2021 23:48:37 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwHrJfvA/haiL2kDkU2Sc824s/VhxDUz9WKfrjZUVALV+rMusOmrmXdB7xQ8MMFAx4z9xMC5w==
X-Received: by 2002:a5d:58d0:: with SMTP id o16mr25535496wrf.420.1621925316796;
        Mon, 24 May 2021 23:48:36 -0700 (PDT)
Received: from redhat.com ([2a10:8006:fcda:0:90d:c7e7:9e26:b297])
        by smtp.gmail.com with ESMTPSA id g78sm1839253wme.27.2021.05.24.23.48.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 May 2021 23:48:34 -0700 (PDT)
Date:   Tue, 25 May 2021 02:48:30 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     Yongji Xie <xieyongji@bytedance.com>,
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
        Mika =?iso-8859-1?Q?Penttil=E4?= <mika.penttila@nextfour.com>,
        Dan Carpenter <dan.carpenter@oracle.com>, joro@8bytes.org,
        virtualization <virtualization@lists.linux-foundation.org>,
        netdev@vger.kernel.org, kvm <kvm@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, iommu@lists.linux-foundation.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v7 00/12] Introduce VDUSE - vDPA Device in Userspace
Message-ID: <20210525024500-mutt-send-email-mst@kernel.org>
References: <20210517095513.850-1-xieyongji@bytedance.com>
 <20210520014349-mutt-send-email-mst@kernel.org>
 <CACycT3tKY2V=dmOJjeiZxkqA3cH8_KF93NNbRnNU04e5Job2cw@mail.gmail.com>
 <2a79fa0f-352d-b8e9-f60a-181960d054ec@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2a79fa0f-352d-b8e9-f60a-181960d054ec@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 25, 2021 at 02:40:57PM +0800, Jason Wang wrote:
> 
> 在 2021/5/20 下午5:06, Yongji Xie 写道:
> > On Thu, May 20, 2021 at 2:06 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> > > On Mon, May 17, 2021 at 05:55:01PM +0800, Xie Yongji wrote:
> > > > This series introduces a framework, which can be used to implement
> > > > vDPA Devices in a userspace program. The work consist of two parts:
> > > > control path forwarding and data path offloading.
> > > > 
> > > > In the control path, the VDUSE driver will make use of message
> > > > mechnism to forward the config operation from vdpa bus driver
> > > > to userspace. Userspace can use read()/write() to receive/reply
> > > > those control messages.
> > > > 
> > > > In the data path, the core is mapping dma buffer into VDUSE
> > > > daemon's address space, which can be implemented in different ways
> > > > depending on the vdpa bus to which the vDPA device is attached.
> > > > 
> > > > In virtio-vdpa case, we implements a MMU-based on-chip IOMMU driver with
> > > > bounce-buffering mechanism to achieve that. And in vhost-vdpa case, the dma
> > > > buffer is reside in a userspace memory region which can be shared to the
> > > > VDUSE userspace processs via transferring the shmfd.
> > > > 
> > > > The details and our user case is shown below:
> > > > 
> > > > ------------------------    -------------------------   ----------------------------------------------
> > > > |            Container |    |              QEMU(VM) |   |                               VDUSE daemon |
> > > > |       ---------      |    |  -------------------  |   | ------------------------- ---------------- |
> > > > |       |dev/vdx|      |    |  |/dev/vhost-vdpa-x|  |   | | vDPA device emulation | | block driver | |
> > > > ------------+-----------     -----------+------------   -------------+----------------------+---------
> > > >              |                           |                            |                      |
> > > >              |                           |                            |                      |
> > > > ------------+---------------------------+----------------------------+----------------------+---------
> > > > |    | block device |           |  vhost device |            | vduse driver |          | TCP/IP |    |
> > > > |    -------+--------           --------+--------            -------+--------          -----+----    |
> > > > |           |                           |                           |                       |        |
> > > > | ----------+----------       ----------+-----------         -------+-------                |        |
> > > > | | virtio-blk driver |       |  vhost-vdpa driver |         | vdpa device |                |        |
> > > > | ----------+----------       ----------+-----------         -------+-------                |        |
> > > > |           |      virtio bus           |                           |                       |        |
> > > > |   --------+----+-----------           |                           |                       |        |
> > > > |                |                      |                           |                       |        |
> > > > |      ----------+----------            |                           |                       |        |
> > > > |      | virtio-blk device |            |                           |                       |        |
> > > > |      ----------+----------            |                           |                       |        |
> > > > |                |                      |                           |                       |        |
> > > > |     -----------+-----------           |                           |                       |        |
> > > > |     |  virtio-vdpa driver |           |                           |                       |        |
> > > > |     -----------+-----------           |                           |                       |        |
> > > > |                |                      |                           |    vdpa bus           |        |
> > > > |     -----------+----------------------+---------------------------+------------           |        |
> > > > |                                                                                        ---+---     |
> > > > -----------------------------------------------------------------------------------------| NIC |------
> > > >                                                                                           ---+---
> > > >                                                                                              |
> > > >                                                                                     ---------+---------
> > > >                                                                                     | Remote Storages |
> > > >                                                                                     -------------------
> > > > 
> > > > We make use of it to implement a block device connecting to
> > > > our distributed storage, which can be used both in containers and
> > > > VMs. Thus, we can have an unified technology stack in this two cases.
> > > > 
> > > > To test it with null-blk:
> > > > 
> > > >    $ qemu-storage-daemon \
> > > >        --chardev socket,id=charmonitor,path=/tmp/qmp.sock,server,nowait \
> > > >        --monitor chardev=charmonitor \
> > > >        --blockdev driver=host_device,cache.direct=on,aio=native,filename=/dev/nullb0,node-name=disk0 \
> > > >        --export type=vduse-blk,id=test,node-name=disk0,writable=on,name=vduse-null,num-queues=16,queue-size=128
> > > > 
> > > > The qemu-storage-daemon can be found at https://github.com/bytedance/qemu/tree/vduse
> > > > 
> > > > To make the userspace VDUSE processes such as qemu-storage-daemon able to
> > > > run unprivileged. We did some works on virtio driver to avoid trusting
> > > > device, including:
> > > > 
> > > >    - validating the device status:
> > > > 
> > > >      * https://lore.kernel.org/lkml/20210517093428.670-1-xieyongji@bytedance.com/
> > > > 
> > > >    - validating the used length:
> > > > 
> > > >      * https://lore.kernel.org/lkml/20210517090836.533-1-xieyongji@bytedance.com/
> > > > 
> > > >    - validating the device config:
> > > > 
> > > >      * patch 4 ("virtio-blk: Add validation for block size in config space")
> > > > 
> > > >    - validating the device response:
> > > > 
> > > >      * patch 5 ("virtio_scsi: Add validation for residual bytes from response")
> > > > 
> > > > Since I'm not sure if I missing something during auditing, especially on some
> > > > virtio device drivers that I'm not familiar with, now we only support emualting
> > > > a few vDPA devices by default, including: virtio-net device, virtio-blk device,
> > > > virtio-scsi device and virtio-fs device. This limitation can help to reduce
> > > > security risks.
> > > I suspect there are a lot of assumptions even with these 4.
> > > Just what are the security assumptions and guarantees here?
> 
> 
> Note that VDUSE is not the only device that may suffer from this, here're
> two others:
> 
> 1) Encrypted VM

Encrypted VMs are generally understood not to be fully
protected from attacks by a malicious hypervisor. For example
a DoS by a hypervisor is currently trivial.

> 2) Smart NICs

More or less the same thing.


> 
> > The attack surface from a virtio device is limited with IOMMU enabled.
> > It should be able to avoid security risk if we can validate all data
> > such as config space and used length from device in device driver.
> > 
> > > E.g. it seems pretty clear that exposing a malformed FS
> > > to a random kernel config can cause untold mischief.
> > > 
> > > Things like virtnet_send_command are also an easy way for
> > > the device to DOS the kernel.
> 
> 
> I think the virtnet_send_command() needs to use interrupt instead of
> polling.
> 
> Thanks
> 
> 
> > > And before you try to add
> > > an arbitrary timeout there - please don't,
> > > the fix is moving things that must be guaranteed into kernel
> > > and making things that are not guaranteed asynchronous.
> > > Right now there are some things that happen with locks taken,
> > > where if we don't wait for device we lose the ability to report failures
> > > to userspace. E.g. all kind of netlink things are like this.
> > > One can think of a bunch of ways to address this, this
> > > needs to be discussed with the relevant subsystem maintainers.
> > > 
> > > 
> > > If I were you I would start with one type of device, and as simple one
> > > as possible.
> > > 
> > Make sense to me. The virtio-blk device might be a good start. We
> > already have some existing interface like NBD to do similar things.
> > 
> > > 
> > > > When a sysadmin trusts the userspace process enough, it can relax
> > > > the limitation with a 'allow_unsafe_device_emulation' module parameter.
> > > That's not a great security interface. It's a global module specific knob
> > > that just allows any userspace to emulate anything at all.
> > > Coming up with a reasonable interface isn't going to be easy.
> > > For now maybe just have people patch their kernels if they want to
> > > move fast and break things.
> > > 
> > OK. A reasonable interface can be added if we need it in the future.
> > 
> > Thanks,
> > Yongji

