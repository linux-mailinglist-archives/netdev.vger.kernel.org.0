Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3F8330C0E5
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 15:10:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233994AbhBBOKD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 09:10:03 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:28652 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233926AbhBBOHw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 09:07:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612274784;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HoV6WmzOM8JYFHRnbfZo8tVfL3dwzU/hINcFi1knTHc=;
        b=XdOENgkvd8cmfnUccX7rF6hlKCiuqTtBIxsmDjpZ2YR26jORetIwvgAU7qJnzJ3V2B+arW
        Gnad8E++TJ1An6rtvQIyGM+6Ms32KHnZYeGicV6u07zYVv7zRD3wLBYNJanERucDxmiafM
        hWPZrp+pK2ruN4EzDJEIAyMcdL870Po=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-311-C7YumxPCOh2Qpi0okMiF0A-1; Tue, 02 Feb 2021 09:06:22 -0500
X-MC-Unique: C7YumxPCOh2Qpi0okMiF0A-1
Received: by mail-wm1-f71.google.com with SMTP id j204so1490404wmj.4
        for <netdev@vger.kernel.org>; Tue, 02 Feb 2021 06:06:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=HoV6WmzOM8JYFHRnbfZo8tVfL3dwzU/hINcFi1knTHc=;
        b=NsHSQGm54jQrZCtekMT/GkSI8zkt4xvxfv3yr1XSZAqjomA+DX/wGK+qdAr47T7ARG
         LBWUV6IXwCbPAUEFsdU4GXIJkT30mzsaynr0lrJcHmlKRnXZ5qjLIYH/zumK0BvE9PEz
         wn4ZFrvYcJ9hkwCoVJzuYlYj2nzfWbz8WIS/A/mVjnWb+pzePbIU6pdNS/DaL4QHfAof
         S2pbyGG27NqC2JUhOyaQodlVI6pbu41FdaAybcWyjiZlKxKFeo8aJ0lpOmoxQXgmQjzN
         ZLwagZ2QWc9FvpPsKNHnktKCR1C4Ycpd60mdXZqgqAp4D5yjqtrlu7JpQB61i/oJfZSy
         wMTg==
X-Gm-Message-State: AOAM531RbJy92bZyOBRCan1kO+yoWsG+w1q+gtDfa3UBtMI0guARizIg
        UyPn5r+5vR4SC1znxTh1YPGpRa/5zLojxwoTLDz/8Xc5WmO5ViPlDSUH980uOg7jABd/7sSI+c+
        nMDjQQ4Vbl3cZn8fB
X-Received: by 2002:a1c:2d0b:: with SMTP id t11mr3742612wmt.109.1612274781424;
        Tue, 02 Feb 2021 06:06:21 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwLuu9HSbHaNq2JSTJGYoIuanz10/6LwyOztA42Q7LIGokzZlY2asGRgWOD0wv1yz3mEZn6wA==
X-Received: by 2002:a1c:2d0b:: with SMTP id t11mr3742583wmt.109.1612274781204;
        Tue, 02 Feb 2021 06:06:21 -0800 (PST)
Received: from redhat.com (bzq-79-177-39-148.red.bezeqint.net. [79.177.39.148])
        by smtp.gmail.com with ESMTPSA id o124sm3431503wmb.5.2021.02.02.06.06.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Feb 2021 06:06:20 -0800 (PST)
Date:   Tue, 2 Feb 2021 09:06:17 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Eli Cohen <elic@nvidia.com>
Cc:     Si-Wei Liu <siwliu.kernel@gmail.com>,
        Jason Wang <jasowang@redhat.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lulu@redhat.com,
        Si-Wei Liu <si-wei.liu@oracle.com>
Subject: Re: [PATCH 1/2] vdpa/mlx5: Avoid unnecessary query virtqueue
Message-ID: <20210202090558-mutt-send-email-mst@kernel.org>
References: <20210128134130.3051-1-elic@nvidia.com>
 <20210128134130.3051-2-elic@nvidia.com>
 <CAPWQSg0XtEQ1U5N3a767Ak_naoyPdVF1CeE4r3hmN11a-aoBxg@mail.gmail.com>
 <CAPWQSg3U9DCSK_01Kzuea5B1X+Ef9JB23wBY82A3ss-UXGek_Q@mail.gmail.com>
 <9d6058d6-5ce1-0442-8fd9-5a6fe6a0bc6b@redhat.com>
 <CAPWQSg3KOAypcrs9krW8cGE7EDLTehCUCYFZMUYYNaYPH1oBZQ@mail.gmail.com>
 <20210202070055.GB232587@mtl-vdi-166.wap.labs.mlnx>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210202070055.GB232587@mtl-vdi-166.wap.labs.mlnx>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 02, 2021 at 09:00:55AM +0200, Eli Cohen wrote:
> On Mon, Feb 01, 2021 at 08:15:29PM -0800, Si-Wei Liu wrote:
> > On Mon, Feb 1, 2021 at 7:13 PM Jason Wang <jasowang@redhat.com> wrote:
> > >
> > >
> > > On 2021/2/2 上午3:17, Si-Wei Liu wrote:
> > > > On Mon, Feb 1, 2021 at 10:51 AM Si-Wei Liu <siwliu.kernel@gmail.com> wrote:
> > > >> On Thu, Jan 28, 2021 at 5:46 AM Eli Cohen <elic@nvidia.com> wrote:
> > > >>> suspend_vq should only suspend the VQ on not save the current available
> > > >>> index. This is done when a change of map occurs when the driver calls
> > > >>> save_channel_info().
> > > >> Hmmm, suspend_vq() is also called by teardown_vq(), the latter of
> > > >> which doesn't save the available index as save_channel_info() doesn't
> > > >> get called in that path at all. How does it handle the case that
> > > >> aget_vq_state() is called from userspace (e.g. QEMU) while the
> > > >> hardware VQ object was torn down, but userspace still wants to access
> > > >> the queue index?
> > > >>
> > > >> Refer to https://lore.kernel.org/netdev/1601583511-15138-1-git-send-email-si-wei.liu@oracle.com/
> > > >>
> > > >> vhost VQ 0 ring restore failed: -1: Resource temporarily unavailable (11)
> > > >> vhost VQ 1 ring restore failed: -1: Resource temporarily unavailable (11)
> > > >>
> > > >> QEMU will complain with the above warning while VM is being rebooted
> > > >> or shut down.
> > > >>
> > > >> Looks to me either the kernel driver should cover this requirement, or
> > > >> the userspace has to bear the burden in saving the index and not call
> > > >> into kernel if VQ is destroyed.
> > > > Actually, the userspace doesn't have the insights whether virt queue
> > > > will be destroyed if just changing the device status via set_status().
> > > > Looking at other vdpa driver in tree i.e. ifcvf it doesn't behave like
> > > > so. Hence this still looks to me to be Mellanox specifics and
> > > > mlx5_vdpa implementation detail that shouldn't expose to userspace.
> > >
> > >
> > > So I think we can simply drop this patch?
> > 
> > Yep, I think so. To be honest I don't know why it has anything to do
> > with the memory hotplug issue.
> 
> No relation. That's why I put them in two different patches. Only the
> second one is the fix as I stated in the cover letter.
> 
> Anyway, let's just take the second patch.
> 
> Michael, do you need me to send PATCH 2 again as a single patch or can
> you just take it?

Pls post fixes separately. Thanks!

> 
> > 
> > -Siwei
> > 
> > >
> > > Thanks
> > >
> > >
> > > >> -Siwei
> > > >>
> > > >>
> > > >>> Signed-off-by: Eli Cohen <elic@nvidia.com>
> > > >>> ---
> > > >>>   drivers/vdpa/mlx5/net/mlx5_vnet.c | 8 --------
> > > >>>   1 file changed, 8 deletions(-)
> > > >>>
> > > >>> diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> > > >>> index 88dde3455bfd..549ded074ff3 100644
> > > >>> --- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
> > > >>> +++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> > > >>> @@ -1148,8 +1148,6 @@ static int setup_vq(struct mlx5_vdpa_net *ndev, struct mlx5_vdpa_virtqueue *mvq)
> > > >>>
> > > >>>   static void suspend_vq(struct mlx5_vdpa_net *ndev, struct mlx5_vdpa_virtqueue *mvq)
> > > >>>   {
> > > >>> -       struct mlx5_virtq_attr attr;
> > > >>> -
> > > >>>          if (!mvq->initialized)
> > > >>>                  return;
> > > >>>
> > > >>> @@ -1158,12 +1156,6 @@ static void suspend_vq(struct mlx5_vdpa_net *ndev, struct mlx5_vdpa_virtqueue *m
> > > >>>
> > > >>>          if (modify_virtqueue(ndev, mvq, MLX5_VIRTIO_NET_Q_OBJECT_STATE_SUSPEND))
> > > >>>                  mlx5_vdpa_warn(&ndev->mvdev, "modify to suspend failed\n");
> > > >>> -
> > > >>> -       if (query_virtqueue(ndev, mvq, &attr)) {
> > > >>> -               mlx5_vdpa_warn(&ndev->mvdev, "failed to query virtqueue\n");
> > > >>> -               return;
> > > >>> -       }
> > > >>> -       mvq->avail_idx = attr.available_index;
> > > >>>   }
> > > >>>
> > > >>>   static void suspend_vqs(struct mlx5_vdpa_net *ndev)
> > > >>> --
> > > >>> 2.29.2
> > > >>>
> > >

