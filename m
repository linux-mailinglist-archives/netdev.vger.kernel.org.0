Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F629328298
	for <lists+netdev@lfdr.de>; Mon,  1 Mar 2021 16:36:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237283AbhCAPfD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Mar 2021 10:35:03 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:45370 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237266AbhCAPet (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Mar 2021 10:34:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614612801;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VycDxHHozAmz/oN9S6Q+COAL5WKvN1P0hQASaQTZUyM=;
        b=hcvk9BxeDthBsHekRwSbT98PsGoZU7GBjAktvtvMxzs3jtKVFL1T6auX83BpFMSrB3k3BX
        asxh9xpDyMv+Pt6YH+j8+2oPA5MHRgR9CygPYPTcR9cNZLpsoE8vu4bFeTjIpaVCMQ0jR7
        2bLxMOdapeswR2FnDAdMk+wfpnV9BxI=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-248-If3UKltGMv60J52sPzHBWQ-1; Mon, 01 Mar 2021 10:33:20 -0500
X-MC-Unique: If3UKltGMv60J52sPzHBWQ-1
Received: by mail-ed1-f72.google.com with SMTP id u1so6864814edt.4
        for <netdev@vger.kernel.org>; Mon, 01 Mar 2021 07:33:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=VycDxHHozAmz/oN9S6Q+COAL5WKvN1P0hQASaQTZUyM=;
        b=dJd6/TKK4kdC3NubJmk6aCEIJ4i5I+E/Cbid6ovgDcNM62l00b713SURZ7dzw+iGdF
         2jLc3vMYhSuuDenxScxm4nfAZk/CqrK+ibXREjkGl9KQSSZG47+xWlT8sF6AAJfoZqp/
         aLVpi6uBibiKz5ZOevOS12vqv95N9bzzV39H7QiVYwmO/Iv24+M9oEFtBNH+f6VcLM9w
         t5yxi00cfCgwArygxfI37U8qwQs6Zoir1BqCY299G6MnzuXrN6nurNv2NlF+D6kdqrB2
         +96b3EICQCbZByTU6OkHk71vsxHieZSMJ6Qr0JADEuNCianm6rsx38qSYekdS/EspFxu
         m8mA==
X-Gm-Message-State: AOAM533+C7IFg+DXnkspSeygHwgBihjF/bLjyy0gLIgBhEKMy+vS5lkI
        pOoKUuTqAA9l2MgW9zlpIOcYb5K9m/ZD1/TS2ZqmbKAUZ6Uw9a2+Xm3VydF0aX8SucPn2Ekhwc6
        I0+tJDkK6xnxZJ2t2
X-Received: by 2002:a17:907:3da5:: with SMTP id he37mr16735469ejc.300.1614612798836;
        Mon, 01 Mar 2021 07:33:18 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxvuA2uuZPGE6wZF6LgEHxqlvnFOzgtkmNcH1tdkTEnC0QemOod2QRaCHxR1Jk8clxbToGX/w==
X-Received: by 2002:a17:907:3da5:: with SMTP id he37mr16735461ejc.300.1614612798727;
        Mon, 01 Mar 2021 07:33:18 -0800 (PST)
Received: from redhat.com (bzq-79-180-2-31.red.bezeqint.net. [79.180.2.31])
        by smtp.gmail.com with ESMTPSA id bx24sm731233ejc.88.2021.03.01.07.33.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Mar 2021 07:33:18 -0800 (PST)
Date:   Mon, 1 Mar 2021 10:33:14 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     Eli Cohen <elic@nvidia.com>, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: Re: [PATCH] vdpa/mlx5: Fix wrong use of bit numbers
Message-ID: <20210301103214-mutt-send-email-mst@kernel.org>
References: <20210301062817.39331-1-elic@nvidia.com>
 <959916f2-5fc9-bdb4-31ca-632fe0d98979@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <959916f2-5fc9-bdb4-31ca-632fe0d98979@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 01, 2021 at 03:52:45PM +0800, Jason Wang wrote:
> 
> On 2021/3/1 2:28 下午, Eli Cohen wrote:
> > VIRTIO_F_VERSION_1 is a bit number. Use BIT_ULL() with mask
> > conditionals.
> > 
> > Also, in mlx5_vdpa_is_little_endian() use BIT_ULL for consistency with
> > the rest of the code.
> > 
> > Fixes: 1a86b377aa21 ("vdpa/mlx5: Add VDPA driver for supported mlx5 devices")
> > Signed-off-by: Eli Cohen <elic@nvidia.com>
> 
> 
> Acked-by: Jason Wang <jasowang@redhat.com>

And CC stable I guess?

> 
> > ---
> >   drivers/vdpa/mlx5/net/mlx5_vnet.c | 4 ++--
> >   1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> > index dc7031132fff..7d21b857a94a 100644
> > --- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
> > +++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> > @@ -821,7 +821,7 @@ static int create_virtqueue(struct mlx5_vdpa_net *ndev, struct mlx5_vdpa_virtque
> >   	MLX5_SET(virtio_q, vq_ctx, event_qpn_or_msix, mvq->fwqp.mqp.qpn);
> >   	MLX5_SET(virtio_q, vq_ctx, queue_size, mvq->num_ent);
> >   	MLX5_SET(virtio_q, vq_ctx, virtio_version_1_0,
> > -		 !!(ndev->mvdev.actual_features & VIRTIO_F_VERSION_1));
> > +		 !!(ndev->mvdev.actual_features & BIT_ULL(VIRTIO_F_VERSION_1)));
> >   	MLX5_SET64(virtio_q, vq_ctx, desc_addr, mvq->desc_addr);
> >   	MLX5_SET64(virtio_q, vq_ctx, used_addr, mvq->device_addr);
> >   	MLX5_SET64(virtio_q, vq_ctx, available_addr, mvq->driver_addr);
> > @@ -1578,7 +1578,7 @@ static void teardown_virtqueues(struct mlx5_vdpa_net *ndev)
> >   static inline bool mlx5_vdpa_is_little_endian(struct mlx5_vdpa_dev *mvdev)
> >   {
> >   	return virtio_legacy_is_little_endian() ||
> > -		(mvdev->actual_features & (1ULL << VIRTIO_F_VERSION_1));
> > +		(mvdev->actual_features & BIT_ULL(VIRTIO_F_VERSION_1));
> >   }
> >   static __virtio16 cpu_to_mlx5vdpa16(struct mlx5_vdpa_dev *mvdev, u16 val)

