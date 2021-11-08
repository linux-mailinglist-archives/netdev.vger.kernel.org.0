Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6E6244808F
	for <lists+netdev@lfdr.de>; Mon,  8 Nov 2021 14:49:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238647AbhKHNwU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 08:52:20 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:52476 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240129AbhKHNwS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Nov 2021 08:52:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636379374;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Cfv5/TeagcalCju25Ixtgh7I8siLZLFXg0AEDAFqG/c=;
        b=BDB5WA3nN5Jg7Z4Lxz/skGGA+OdYhWvYeptCu/dRm0uZww8sWLtNj+N6IJ7Cnpjhgb6M2w
        8ZABMipbX/bd8BJ4kdsCSwP0pFfo7NU3z+k667vFbCZm+VZf74ZLz5dwllZefYmh/vPSGj
        m/jX0xFVaMjFO/NAhQE2YTO6/OLz29E=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-578-DIYqc_UCNRevyMAmAKVDQA-1; Mon, 08 Nov 2021 08:49:33 -0500
X-MC-Unique: DIYqc_UCNRevyMAmAKVDQA-1
Received: by mail-ed1-f70.google.com with SMTP id x13-20020a05640226cd00b003e2bf805a02so14430774edd.23
        for <netdev@vger.kernel.org>; Mon, 08 Nov 2021 05:49:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Cfv5/TeagcalCju25Ixtgh7I8siLZLFXg0AEDAFqG/c=;
        b=7jiPepPljfUcKqLzcfL0OeB5PqgZ/MQDk3Nxvnbu8STHQ/BvVAzIpaW/ioyBYKtJMa
         kNmlr1ibQMlpRqfWTbGUkOhQqsd7Hs48dULLcgSzm0pW2m6OJwdebYhUqe87nq7dU4dh
         a7IHqpZM6kPW9ekohvzTICs/dKRE+j7eyXMtwWLERbW9RfBuExdjgAR+XpCsMG9/9iX/
         mQUU9USI/XhY5+z+bLg0LS5YrOF6GwWYjS/zhMkfCUK5YFQ/PhOayW+sjCfGxUCbktsV
         t3nG8PCM/uRIwoyR70BJAqdl+sERttceS2N2MJFPQ8hx1p0sdFN5wI2qyIQG/su59vDU
         HhAA==
X-Gm-Message-State: AOAM531SLhVekPlT03rRKu6PYJ5fmvgmlsp0tD4ji0tRJRkuzednZWua
        iWlDkGuyVUgX4GLqZX/Zc+K4BoZobBJVrybHkDsIY+6UB+uRCuw/0/pm/HOqsTvkM8qNNzVdpQ+
        xEm+mckXrdskatagD
X-Received: by 2002:a17:906:640d:: with SMTP id d13mr21429ejm.444.1636379371665;
        Mon, 08 Nov 2021 05:49:31 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzifYtiqGfrMeXfkQC+E6k2QsEO7bjJ6311JjOpJjTrt5a9Y3WXeaOmHNZQre7IJs2q9baQfQ==
X-Received: by 2002:a17:906:640d:: with SMTP id d13mr21400ejm.444.1636379371459;
        Mon, 08 Nov 2021 05:49:31 -0800 (PST)
Received: from redhat.com ([2.55.155.32])
        by smtp.gmail.com with ESMTPSA id e19sm836980edu.47.2021.11.08.05.49.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Nov 2021 05:49:30 -0800 (PST)
Date:   Mon, 8 Nov 2021 08:49:27 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH v4 0/3] virtio support cache indirect desc
Message-ID: <20211108084732-mutt-send-email-mst@kernel.org>
References: <20211108114951.92862-1-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211108114951.92862-1-xuanzhuo@linux.alibaba.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 08, 2021 at 07:49:48PM +0800, Xuan Zhuo wrote:
> If the VIRTIO_RING_F_INDIRECT_DESC negotiation succeeds, and the number
> of sgs used for sending packets is greater than 1. We must constantly
> call __kmalloc/kfree to allocate/release desc.
> 
> In the case of extremely fast package delivery, the overhead cannot be
> ignored:
> 
>   27.46%  [kernel]  [k] virtqueue_add
>   16.66%  [kernel]  [k] detach_buf_split
>   16.51%  [kernel]  [k] virtnet_xsk_xmit
>   14.04%  [kernel]  [k] virtqueue_add_outbuf
>    5.18%  [kernel]  [k] __kmalloc
>    4.08%  [kernel]  [k] kfree
>    2.80%  [kernel]  [k] virtqueue_get_buf_ctx
>    2.22%  [kernel]  [k] xsk_tx_peek_desc
>    2.08%  [kernel]  [k] memset_erms
>    0.83%  [kernel]  [k] virtqueue_kick_prepare
>    0.76%  [kernel]  [k] virtnet_xsk_run
>    0.62%  [kernel]  [k] __free_old_xmit_ptr
>    0.60%  [kernel]  [k] vring_map_one_sg
>    0.53%  [kernel]  [k] native_apic_mem_write
>    0.46%  [kernel]  [k] sg_next
>    0.43%  [kernel]  [k] sg_init_table
>    0.41%  [kernel]  [k] kmalloc_slab
> 
> This patch adds a cache function to virtio to cache these allocated indirect
> desc instead of constantly allocating and releasing desc.

Hmm a bunch of comments got ignored. See e.g.
https://lore.kernel.org/r/20211027043851-mutt-send-email-mst%40kernel.org
if they aren't relevant add code comments or commit log text explaining the
design choice please.


> v4:
>     1. Only allow desc cache when VIRTIO_RING_F_INDIRECT_DESC negotiation is successful
>     2. The desc cache threshold can be set for each virtqueue
> 
> v3:
>   pre-allocate per buffer indirect descriptors array
> 
> v2:
>   use struct list_head to cache the desc
> 
> Xuan Zhuo (3):
>   virtio: cache indirect desc for split
>   virtio: cache indirect desc for packed
>   virtio-net: enable virtio desc cache
> 
>  drivers/net/virtio_net.c     |  12 ++-
>  drivers/virtio/virtio_ring.c | 152 +++++++++++++++++++++++++++++++----
>  include/linux/virtio.h       |  17 ++++
>  3 files changed, 163 insertions(+), 18 deletions(-)
> 
> --
> 2.31.0

