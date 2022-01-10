Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BADD489ADA
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 14:54:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229986AbiAJNyY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 08:54:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231816AbiAJNyU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jan 2022 08:54:20 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54F6DC061756
        for <netdev@vger.kernel.org>; Mon, 10 Jan 2022 05:54:20 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id a18so52839257edj.7
        for <netdev@vger.kernel.org>; Mon, 10 Jan 2022 05:54:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=djPW+e1c8spfYeyL5AbJ32h9GSIUYbKoLv2DLHaOq+0=;
        b=bl9J2QtWDuUmQlp5N7WmOsJhVeMPiTX+NiVRwh9l87FNYClRzAhBufVdMy0MCqtNFV
         dq4421mAxg0ILI2S2MCCP1ns1H4QhlZT4aWwoBhR0cZUmunXHRx+d+HuOX/d5PKXrzPG
         TK+4Hu5xgpHlwxKj6pUbOw6pX2/G4EJ8DfXnXNMUesmDYorizgDzkPnVKpRJhctC8sUZ
         B2ri5NpHRwtPw2fRocdZhxoBuaBCKzAjfaykJZay8LbVDX930o0CDQ/LHWyda4xFV+Hc
         WugS89G4jBlr4VL2uypPxdIO8AzpqLxqh+es+3YLGWyAingktkoxMNPCyXb/hyfzuCo6
         mj1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=djPW+e1c8spfYeyL5AbJ32h9GSIUYbKoLv2DLHaOq+0=;
        b=Y6yIx+LIQqeOL9bAxRkSPjz+AR/EHdkueOGw6l1nHWEIUFmYXGFv2btLQTCCbwQrJK
         W53YO7bB2+sjF8+EkQAAzCU9YT+Wgk3gp8IlYMNZQocQOOsYqyLRKPZkMW3cvu3tGMxa
         /6C0JGbwrrk69uFFI63s3/KNrUIm+as8x72sCzPL5PnqKhdHxsBfccAfUA216krTswBq
         zNzxSISdRDfjHCzlRheqjk0s7grZXBZLgdOz/Ua/38JIdGs6q0d/4zjOSKNsqJeii6wc
         3mIuoDs79UhbpCWpnHuSIP7SDsAP950GZ03/ghRaU9lS94EYhBrNuNEC4F41tn0pBfRf
         V9Og==
X-Gm-Message-State: AOAM530pFDT+NEZK0kmwFkQtD3/DBlv7QbG8YoxSLj7XE8T8FZ6Bi3sw
        6sMvAV7ueYo5led2bl6bqRTaso4u94XLgHZDnqzM
X-Google-Smtp-Source: ABdhPJyFGnfUMGEnoNxRXvUJpCvABNYtlKdS/8DhFo1CC6qDSFOT+cL5Hg32zlVk43P8LVymiEdjB1533Wdjtj+EyFw=
X-Received: by 2002:a05:6402:cbb:: with SMTP id cn27mr5089054edb.246.1641822858820;
 Mon, 10 Jan 2022 05:54:18 -0800 (PST)
MIME-Version: 1.0
References: <20210830141737.181-1-xieyongji@bytedance.com> <20220110075546-mutt-send-email-mst@kernel.org>
In-Reply-To: <20220110075546-mutt-send-email-mst@kernel.org>
From:   Yongji Xie <xieyongji@bytedance.com>
Date:   Mon, 10 Jan 2022 21:54:08 +0800
Message-ID: <CACycT3v1aEViw7vV4x5qeGVPrSrO-BTDvQshEX35rx_X0Au2vw@mail.gmail.com>
Subject: Re: [PATCH v12 00/13] Introduce VDUSE - vDPA Device in Userspace
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Jason Wang <jasowang@redhat.com>,
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
        =?UTF-8?Q?Mika_Penttil=C3=A4?= <mika.penttila@nextfour.com>,
        Dan Carpenter <dan.carpenter@oracle.com>, joro@8bytes.org,
        Greg KH <gregkh@linuxfoundation.org>,
        He Zhe <zhe.he@windriver.com>,
        Liu Xiaodong <xiaodong.liu@intel.com>,
        Joe Perches <joe@perches.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Will Deacon <will@kernel.org>,
        John Garry <john.garry@huawei.com>, songmuchun@bytedance.com,
        virtualization <virtualization@lists.linux-foundation.org>,
        Netdev <netdev@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, iommu@lists.linux-foundation.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 10, 2022 at 8:57 PM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> On Mon, Aug 30, 2021 at 10:17:24PM +0800, Xie Yongji wrote:
> > This series introduces a framework that makes it possible to implement
> > software-emulated vDPA devices in userspace. And to make the device
> > emulation more secure, the emulated vDPA device's control path is handled
> > in the kernel and only the data path is implemented in the userspace.
> >
> > Since the emuldated vDPA device's control path is handled in the kernel,
> > a message mechnism is introduced to make userspace be aware of the data
> > path related changes. Userspace can use read()/write() to receive/reply
> > the control messages.
> >
> > In the data path, the core is mapping dma buffer into VDUSE daemon's
> > address space, which can be implemented in different ways depending on
> > the vdpa bus to which the vDPA device is attached.
> >
> > In virtio-vdpa case, we implements a MMU-based software IOTLB with
> > bounce-buffering mechanism to achieve that. And in vhost-vdpa case, the dma
> > buffer is reside in a userspace memory region which can be shared to the
> > VDUSE userspace processs via transferring the shmfd.
> >
> > The details and our user case is shown below:
> >
> > ------------------------    -------------------------   ----------------------------------------------
> > |            Container |    |              QEMU(VM) |   |                               VDUSE daemon |
> > |       ---------      |    |  -------------------  |   | ------------------------- ---------------- |
> > |       |dev/vdx|      |    |  |/dev/vhost-vdpa-x|  |   | | vDPA device emulation | | block driver | |
> > ------------+-----------     -----------+------------   -------------+----------------------+---------
> >             |                           |                            |                      |
> >             |                           |                            |                      |
> > ------------+---------------------------+----------------------------+----------------------+---------
> > |    | block device |           |  vhost device |            | vduse driver |          | TCP/IP |    |
> > |    -------+--------           --------+--------            -------+--------          -----+----    |
> > |           |                           |                           |                       |        |
> > | ----------+----------       ----------+-----------         -------+-------                |        |
> > | | virtio-blk driver |       |  vhost-vdpa driver |         | vdpa device |                |        |
> > | ----------+----------       ----------+-----------         -------+-------                |        |
> > |           |      virtio bus           |                           |                       |        |
> > |   --------+----+-----------           |                           |                       |        |
> > |                |                      |                           |                       |        |
> > |      ----------+----------            |                           |                       |        |
> > |      | virtio-blk device |            |                           |                       |        |
> > |      ----------+----------            |                           |                       |        |
> > |                |                      |                           |                       |        |
> > |     -----------+-----------           |                           |                       |        |
> > |     |  virtio-vdpa driver |           |                           |                       |        |
> > |     -----------+-----------           |                           |                       |        |
> > |                |                      |                           |    vdpa bus           |        |
> > |     -----------+----------------------+---------------------------+------------           |        |
> > |                                                                                        ---+---     |
> > -----------------------------------------------------------------------------------------| NIC |------
> >                                                                                          ---+---
> >                                                                                             |
> >                                                                                    ---------+---------
> >                                                                                    | Remote Storages |
> >                                                                                    -------------------
> >
> > We make use of it to implement a block device connecting to
> > our distributed storage, which can be used both in containers and
> > VMs. Thus, we can have an unified technology stack in this two cases.
> >
> > To test it with null-blk:
> >
> >   $ qemu-storage-daemon \
> >       --chardev socket,id=charmonitor,path=/tmp/qmp.sock,server,nowait \
> >       --monitor chardev=charmonitor \
> >       --blockdev driver=host_device,cache.direct=on,aio=native,filename=/dev/nullb0,node-name=disk0 \
> >       --export type=vduse-blk,id=test,node-name=disk0,writable=on,name=vduse-null,num-queues=16,queue-size=128
> >
> > The qemu-storage-daemon can be found at https://github.com/bytedance/qemu/tree/vduse
>
> It's been half a year - any plans to upstream this?

Yeah, this is on my to-do list this month.

Sorry for taking so long... I've been working on another project
enabling userspace RDMA with VDUSE for the past few months. So I
didn't have much time for this. Anyway, I will submit the first
version as soon as possible.

Thanks,
Yongji
