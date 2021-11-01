Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCC8A441559
	for <lists+netdev@lfdr.de>; Mon,  1 Nov 2021 09:33:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231430AbhKAIgT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 04:36:19 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:25806 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231223AbhKAIgS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Nov 2021 04:36:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635755625;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=toeYDSFWiKXkiei9uCOEdhzQx66P/uM7vnGVHpw8ifo=;
        b=TL0yGT/1ZWm2cho6AtaqRQtQIi+CJXjPSQMcdvrM4444vXndlnIS5keCTL7xvoYWvqZLYS
        3bZyw+aeDS0nfLr9baj0y8rxej3FyyAQ7Fp4wltWwkD2E1pEwZF/qZBof5NMuDx4GsGOPf
        qfQ4nmd4tuRoiJUbQBylMHYM4YLmMII=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-291-CvvQXXEtNSm66IjF2RBlaw-1; Mon, 01 Nov 2021 04:33:44 -0400
X-MC-Unique: CvvQXXEtNSm66IjF2RBlaw-1
Received: by mail-ed1-f70.google.com with SMTP id m16-20020a056402431000b003dd2005af01so14874998edc.5
        for <netdev@vger.kernel.org>; Mon, 01 Nov 2021 01:33:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=toeYDSFWiKXkiei9uCOEdhzQx66P/uM7vnGVHpw8ifo=;
        b=rFM9edIsSSAlpRtgm9NeZtXeuNpxjYBhWUbIBxfi+uyHq8+pchnYD0Xn9q9sA3Y15f
         DAUVgYtXoiLHz1b7OXHxgh5DEQnnOD0MGX7aFxrJje6mqMRZRsePgUaYOYfb3PusllEF
         EA4YWJkG5X3BkkfmBZg4i1saF/DE4nF/VaFux9ApGdNxA4aTOM6YubVGOctGqvZ7qWm4
         ijXUwZtwd7ovHDOEqHtCsjstEfafVNGuqQ+EgrkKT4NMA4guzuNP1NqiSYYikyVodK1S
         tsXl5K0wOZWeYiSU3fGZJRMkIZk02fB1PPPyX4divQ4wrRUA8eUt0LRQnGGgcaFtAO6z
         F6ww==
X-Gm-Message-State: AOAM531ojJxZ2CfYz3eJVWllK7BvnKYJ/BNXYKJrDocze24KZkQaLlmS
        e2vfJoA48HGeSoEWyA2HkgN4SERH41HVitN8Sr6/kYlN3bFme/IqM29x/++5xdoOwKcP50bvE/e
        34pm2JG48nhLZEsr9
X-Received: by 2002:a17:906:942:: with SMTP id j2mr35634473ejd.303.1635755622876;
        Mon, 01 Nov 2021 01:33:42 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyTzkPQ+eacz/RI1GFZa6zc/IcN7MCLHqRfQeuySwwKpwlSILo0x1E9/oEmkz4/+6j0efB3oA==
X-Received: by 2002:a17:906:942:: with SMTP id j2mr35634458ejd.303.1635755622703;
        Mon, 01 Nov 2021 01:33:42 -0700 (PDT)
Received: from redhat.com ([176.12.204.186])
        by smtp.gmail.com with ESMTPSA id f20sm8849809edf.17.2021.11.01.01.33.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Nov 2021 01:33:42 -0700 (PDT)
Date:   Mon, 1 Nov 2021 04:33:38 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH v2 3/3] virtio-net: enable virtio indirect cache
Message-ID: <20211101043229-mutt-send-email-mst@kernel.org>
References: <20211028104919.3393-1-xuanzhuo@linux.alibaba.com>
 <20211028104919.3393-4-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211028104919.3393-4-xuanzhuo@linux.alibaba.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 28, 2021 at 06:49:19PM +0800, Xuan Zhuo wrote:
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
> Compared to not using virtio indirect cache, virtio-net can get a 16%
> performance improvement when using indirect desc cache.
> 
> In the test case, the CPU where the package is sent has reached 100%.
> The following are the PPS in two cases:
> 
>     indirect desc cache  | no cache
>     3074658              | 2685132
>     3111866              | 2666118
>     3152527              | 2653632
>     3125867              | 2669820
>     3027147              | 2644464
>     3069211              | 2669777
>     3038522              | 2675645
>     3034507              | 2671302
>     3102257              | 2685504
>     3083712              | 2692800
>     3051771              | 2676928
>     3080684              | 2695040
>     3147816              | 2720876
>     3123887              | 2705492
>     3180963              | 2699520
>     3191579              | 2676480
>     3161670              | 2686272
>     3189768              | 2692588
>     3174272              | 2686692
>     3143434              | 2682416
> 
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> ---
>  drivers/net/virtio_net.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 4ad25a8b0870..e1ade176ab46 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -31,6 +31,13 @@ module_param(csum, bool, 0444);
>  module_param(gso, bool, 0444);
>  module_param(napi_tx, bool, 0644);
>  
> +/**
> + * Because virtio desc cache will increase memory overhead, users can turn it
> + * off or select an acceptable value. The maximum value is 2 + MAX_SKB_FRAGS.
> + */

Maybe add code to validate it and cap it at acceptable values then.

> +static u32 virtio_desc_cache_thr = 4;

Wouldn't something like CACHE_LINE_SIZE make more sense here?

> +module_param(virtio_desc_cache_thr, uint, 0644);
> +
>  /* FIXME: MTU in config. */
>  #define GOOD_PACKET_LEN (ETH_HLEN + VLAN_HLEN + ETH_DATA_LEN)
>  #define GOOD_COPY_LEN	128


> @@ -3214,6 +3221,11 @@ static int virtnet_probe(struct virtio_device *vdev)
>  		vi->curr_queue_pairs = num_online_cpus();
>  	vi->max_queue_pairs = max_queue_pairs;
>  
> +	if (virtio_desc_cache_thr > 2 + MAX_SKB_FRAGS)
> +		virtio_set_desc_cache(vdev, 2 + MAX_SKB_FRAGS);
> +	else
> +		virtio_set_desc_cache(vdev, virtio_desc_cache_thr);
> +
>  	/* Allocate/initialize the rx/tx queues, and invoke find_vqs */
>  	err = init_vqs(vi);
>  	if (err)
> -- 
> 2.31.0

