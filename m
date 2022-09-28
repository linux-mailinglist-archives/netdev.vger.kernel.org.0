Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BF8B5EEA07
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 01:14:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234293AbiI1XOt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 19:14:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234109AbiI1XOp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 19:14:45 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AAD226C6
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 16:14:39 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id r3-20020a05600c35c300b003b4b5f6c6bdso1793230wmq.2
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 16:14:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date;
        bh=ejGuPnbyo4ms2QIe7VBN81YCemx00ZRUVBieL39eg0M=;
        b=DOt1r3FzrtWXF5TPEVuxhMydjWLo5/LMtOzcZLMggjr/IaWYU6Prz4TIT4OwA4tGFX
         ivFXLKeEDCh0M2QtxZ2lRG/FDJboiSUl3gvHcJBLcOOKOqMPFPJBSsbzXIJ9ot4y+N5W
         Efgm7s/3DXLEDf9J54t8mpYGXT9MKB+BlQlSjMp2D5wbophjq/6OtLkjC3UQg+Jm0cd4
         ftfuK5AV3fDCxjEzNO4rQmuD7uTgjc3BUr8mfNAY/h7Lnmx/WtVhODEQJQBfhbrK2XXD
         vivDOyTqMQawpxiBtScKIKzwoF0osPj0lVKKTixCX3MR9yqTTsQdgvy27lMT0Nvycsv3
         rpGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date;
        bh=ejGuPnbyo4ms2QIe7VBN81YCemx00ZRUVBieL39eg0M=;
        b=LUwCmF6jyM3YheyZfINzLX6GrBULSOwtV3j6iG+FOsKX/vDYx2k+WPWPlBdd91HUgB
         xw0yfQ8cLBG9/AqrFyPUHDYbss8E3MY1kCTlDEF1GC2fsgKJzDN4QBND5iSIVdr/eCmZ
         VbWYEKK58n9bPMdTCSvge/lmcpYKxuIQOySW6yThaXn7FzgW940bh9cTbXa6wD1NXLv7
         ShM3dv/NRhvVXnU9HyXDOKV6fnWY/pX+9FnxQcKc+Xu7bA3+Z8E99fYJVN2xmpJdKFiD
         QGWAtyOnGvrbtVdOP+i6R7rp2NNAmkfZoypYcJiynBQfQiOtdKfBtL02TpXOgap4M0XU
         +UoQ==
X-Gm-Message-State: ACrzQf10Wf2GyDTUGLZ8ptuPFqOAf17+4PptWoM9t7KmH32AxAF2K1L+
        +6HeYT9hEJv6yF5kocHEkFTJXAm7gCCP4nV9vDFlVg==
X-Google-Smtp-Source: AMsMyM7RUQ9VuDEpAN0bVGui4vMus7mWpbhhfYCH6ruPeC2pzfR/93cY7f27OafYL2tYCJ5G94xxai+HJgzGo3k2AfI=
X-Received: by 2002:a05:600c:510b:b0:3b5:4a6:9a32 with SMTP id
 o11-20020a05600c510b00b003b504a69a32mr210048wms.81.1664406877407; Wed, 28 Sep
 2022 16:14:37 -0700 (PDT)
MIME-Version: 1.0
References: <20220928064538.667678-1-uekawa@chromium.org> <20220928082823.wyxplop5wtpuurwo@sgarzare-redhat>
 <20220928052738-mutt-send-email-mst@kernel.org> <20220928151135.pvrlsylg6j3hzh74@sgarzare-redhat>
In-Reply-To: <20220928151135.pvrlsylg6j3hzh74@sgarzare-redhat>
From:   =?UTF-8?B?SnVuaWNoaSBVZWthd2EgKOS4iuW3nee0lOS4gCk=?= 
        <uekawa@google.com>
Date:   Thu, 29 Sep 2022 08:14:24 +0900
Message-ID: <CADgJSGHxPWXJjbakEeWnqF42A03yK7Dpw6U1SKNLhk+B248Ymg@mail.gmail.com>
Subject: Re: [PATCH] vhost/vsock: Use kvmalloc/kvfree for larger packets.
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Eric Dumazet <edumazet@google.com>, davem@davemloft.net,
        netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        Bobby Eshleman <bobby.eshleman@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2022=E5=B9=B49=E6=9C=8829=E6=97=A5(=E6=9C=A8) 0:11 Stefano Garzarella <sgar=
zare@redhat.com>:
>
> On Wed, Sep 28, 2022 at 05:31:58AM -0400, Michael S. Tsirkin wrote:
> >On Wed, Sep 28, 2022 at 10:28:23AM +0200, Stefano Garzarella wrote:
> >> On Wed, Sep 28, 2022 at 03:45:38PM +0900, Junichi Uekawa wrote:
> >> > When copying a large file over sftp over vsock, data size is usually=
 32kB,
> >> > and kmalloc seems to fail to try to allocate 32 32kB regions.
> >> >
> >> > Call Trace:
> >> >  [<ffffffffb6a0df64>] dump_stack+0x97/0xdb
> >> >  [<ffffffffb68d6aed>] warn_alloc_failed+0x10f/0x138
> >> >  [<ffffffffb68d868a>] ? __alloc_pages_direct_compact+0x38/0xc8
> >> >  [<ffffffffb664619f>] __alloc_pages_nodemask+0x84c/0x90d
> >> >  [<ffffffffb6646e56>] alloc_kmem_pages+0x17/0x19
> >> >  [<ffffffffb6653a26>] kmalloc_order_trace+0x2b/0xdb
> >> >  [<ffffffffb66682f3>] __kmalloc+0x177/0x1f7
> >> >  [<ffffffffb66e0d94>] ? copy_from_iter+0x8d/0x31d
> >> >  [<ffffffffc0689ab7>] vhost_vsock_handle_tx_kick+0x1fa/0x301 [vhost_=
vsock]
> >> >  [<ffffffffc06828d9>] vhost_worker+0xf7/0x157 [vhost]
> >> >  [<ffffffffb683ddce>] kthread+0xfd/0x105
> >> >  [<ffffffffc06827e2>] ? vhost_dev_set_owner+0x22e/0x22e [vhost]
> >> >  [<ffffffffb683dcd1>] ? flush_kthread_worker+0xf3/0xf3
> >> >  [<ffffffffb6eb332e>] ret_from_fork+0x4e/0x80
> >> >  [<ffffffffb683dcd1>] ? flush_kthread_worker+0xf3/0xf3
> >> >
> >> > Work around by doing kvmalloc instead.
> >> >
> >> > Signed-off-by: Junichi Uekawa <uekawa@chromium.org>
> >
> >My worry here is that this in more of a work around.
> >It would be better to not allocate memory so aggressively:
> >if we are so short on memory we should probably process
> >packets one at a time. Is that very hard to implement?
>
> Currently the "virtio_vsock_pkt" is allocated in the "handle_kick"
> callback of TX virtqueue. Then the packet is multiplexed on the right
> socket queue, then the user space can de-queue it whenever they want.
>
> So maybe we can stop processing the virtqueue if we are short on memory,
> but when can we restart the TX virtqueue processing?
>
> I think as long as the guest used only 4K buffers we had no problem, but
> now that it can create larger buffers the host may not be able to
> allocate it contiguously. Since there is no need to have them contiguous
> here, I think this patch is okay.
>
> However, if we switch to sk_buff (as Bobby is already doing), maybe we
> don't have this problem because I think there is some kind of
> pre-allocated pool.
>

Thank you for the review! I was wondering if this is a reasonable workaroun=
d (as
we found that this patch makes a reliably crashing system into a
reliably surviving system.)


... Sounds like it is a reasonable patch to use backported to older kernels=
?

> >
> >
> >
> >> > ---
> >> >
> >> > drivers/vhost/vsock.c                   | 2 +-
> >> > net/vmw_vsock/virtio_transport_common.c | 2 +-
> >> > 2 files changed, 2 insertions(+), 2 deletions(-)
> >> >
> >> > diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
> >> > index 368330417bde..5703775af129 100644
> >> > --- a/drivers/vhost/vsock.c
> >> > +++ b/drivers/vhost/vsock.c
> >> > @@ -393,7 +393,7 @@ vhost_vsock_alloc_pkt(struct vhost_virtqueue *vq=
,
> >> >            return NULL;
> >> >    }
> >> >
> >> > -  pkt->buf =3D kmalloc(pkt->len, GFP_KERNEL);
> >> > +  pkt->buf =3D kvmalloc(pkt->len, GFP_KERNEL);
> >> >    if (!pkt->buf) {
> >> >            kfree(pkt);
> >> >            return NULL;
> >> > diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock=
/virtio_transport_common.c
> >> > index ec2c2afbf0d0..3a12aee33e92 100644
> >> > --- a/net/vmw_vsock/virtio_transport_common.c
> >> > +++ b/net/vmw_vsock/virtio_transport_common.c
> >> > @@ -1342,7 +1342,7 @@ EXPORT_SYMBOL_GPL(virtio_transport_recv_pkt);
> >> >
> >> > void virtio_transport_free_pkt(struct virtio_vsock_pkt *pkt)
> >> > {
> >> > -  kfree(pkt->buf);
> >> > +  kvfree(pkt->buf);
> >>
> >> virtio_transport_free_pkt() is used also in virtio_transport.c and
> >> vsock_loopback.c where pkt->buf is allocated with kmalloc(), but IIUC
> >> kvfree() can be used with that memory, so this should be fine.
> >>
> >> >    kfree(pkt);
> >> > }
> >> > EXPORT_SYMBOL_GPL(virtio_transport_free_pkt);
> >> > --
> >> > 2.37.3.998.g577e59143f-goog
> >> >
> >>
> >> This issue should go away with the Bobby's work about introducing sk_b=
uff
> >> [1], but we can queue this for now.
> >>
> >> I'm not sure if we should do the same also in the virtio-vsock driver
> >> (virtio_transport.c). Here in vhost-vsock the buf allocated is only us=
ed in
> >> the host, while in the virtio-vsock driver the buffer is exposed to th=
e
> >> device emulated in the host, so it should be physically contiguous (if=
 not,
> >> maybe we need to adjust virtio_vsock_rx_fill()).
> >
> >More importantly it needs to support DMA API which IIUC kvmalloc
> >memory does not.
> >
>
> Right, good point!
>
> Thanks,
> Stefano
>


--=20
Junichi Uekawa
Google
