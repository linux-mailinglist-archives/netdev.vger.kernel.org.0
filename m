Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E3F648645D
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 13:28:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238801AbiAFM2j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 07:28:39 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:30209 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238780AbiAFM2i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 07:28:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641472117;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZoahO67h+dDkx8ghrnZtJZ57iC/SipETOINKMx5g1Rk=;
        b=i01l46FXWm7hjIUqM7UAZ6ks1icelS32VW+WeCzaZ8tRtFJ85HzgUQ2vuR6cM2dlkYmM3L
        DKk6BOJHlgKlNwjO2QyDtVxJUVHg5bpQCVghw1XK4hf+ats/vNVmy4ZAmrQ5V/RUsw/UmY
        WVPR0t904peT4PUKfqZUCpe0PznYy80=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-471-gbsx_2zkMTG0Uak9TajgTw-1; Thu, 06 Jan 2022 07:28:36 -0500
X-MC-Unique: gbsx_2zkMTG0Uak9TajgTw-1
Received: by mail-wr1-f71.google.com with SMTP id v1-20020adfc5c1000000b001a37fd2fa2dso1184763wrg.22
        for <netdev@vger.kernel.org>; Thu, 06 Jan 2022 04:28:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ZoahO67h+dDkx8ghrnZtJZ57iC/SipETOINKMx5g1Rk=;
        b=NKRcki13u+pDP8REDKejBWbahJ+6PZCHgDBzCJLKA2CYLmHgZ3QumqVb1Hc5QDRvJT
         K4RdLRdib7k+pKHJBxq4dwVO99qHT2K4gbUwMc3c548G5ECru7epWAPAFR4OGVBGwOZB
         nkJaWuBnzxh+tf98jyxnwVQCsGpx1nuqNYOI/NtLuOYsW6+X/4FDJY5k4S1pUV52lHgq
         LaJlTqALxQF0SaKoqbdEpTmfBKj6Zp3Ae3sASzjbqJqlC3YNWtAGz0oYgyEXS+1htcJP
         ifKSItQQUeAFK6+7dhwf6vwYH1ElF74m3rqLKQREcmNIsq3nEOC7GBXDFbcQWY7joL0X
         u6lw==
X-Gm-Message-State: AOAM533/poUtAHbPOp2aiFFuQitsV+AIqBx0JmBBBJuuTxvHFoR+rpej
        PVaz+Kh45003xHuJucqbnLu/1Rpo8hfYCuKDogytQjwrHZHgXbIjNTRYDJITgFhSew6YtCOWaL7
        79u4KVeQ7Kjys/kPj
X-Received: by 2002:a05:600c:4998:: with SMTP id h24mr6839367wmp.188.1641472115476;
        Thu, 06 Jan 2022 04:28:35 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxpM0L9YsF3jt+1ZREIQYnIBILYbA0VW3VR0LswXVJPRlFKmniMU7svrLUGNuKg8GJxP/n6/Q==
X-Received: by 2002:a05:600c:4998:: with SMTP id h24mr6839351wmp.188.1641472115243;
        Thu, 06 Jan 2022 04:28:35 -0800 (PST)
Received: from redhat.com ([2a03:c5c0:207e:991b:6857:5652:b903:a63b])
        by smtp.gmail.com with ESMTPSA id y11sm1890725wrp.86.2022.01.06.04.28.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Jan 2022 04:28:34 -0800 (PST)
Date:   Thu, 6 Jan 2022 07:28:31 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH v3 0/3] virtio support cache indirect desc
Message-ID: <20220106072615-mutt-send-email-mst@kernel.org>
References: <20211029062814.76594-1-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211029062814.76594-1-xuanzhuo@linux.alibaba.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 29, 2021 at 02:28:11PM +0800, Xuan Zhuo wrote:
> If the VIRTIO_RING_F_INDIRECT_DESC negotiation succeeds, and the number
> of sgs used for sending packets is greater than 1. We must constantly
> call __kmalloc/kfree to allocate/release desc.


So where is this going? I really like the performance boost. My concern
is that if guest spans NUMA nodes and when handler switches from
node to another this will keep reusing the cache from
the old node. A bunch of ways were suggested to address this, but
even just making the cache per numa node would help.


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
> 
> v3:
>   pre-allocate per buffer indirect descriptors array
> 
> v2:
>   use struct list_head to cache the desc
> 
> *** BLURB HERE ***
> 
> Xuan Zhuo (3):
>   virtio: cache indirect desc for split
>   virtio: cache indirect desc for packed
>   virtio-net: enable virtio desc cache
> 
>  drivers/net/virtio_net.c     |  11 +++
>  drivers/virtio/virtio.c      |   6 ++
>  drivers/virtio/virtio_ring.c | 131 ++++++++++++++++++++++++++++++-----
>  include/linux/virtio.h       |  14 ++++
>  4 files changed, 145 insertions(+), 17 deletions(-)
> 
> --
> 2.31.0

