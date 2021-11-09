Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C299D44AE53
	for <lists+netdev@lfdr.de>; Tue,  9 Nov 2021 14:03:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235774AbhKINGT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Nov 2021 08:06:19 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:40341 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229990AbhKINGS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Nov 2021 08:06:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636463011;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Cf4/5CFtCfqfKTzk28jN6LSZwSFGEQhCnZssU3UH2zk=;
        b=ZfSBQfMbsEmoeVEbx94zAUdkALq/+ofCkHYoA3eoxBZpvaHVGGV2Ep8pW0ndGVXewjwPXK
        6yIFsJ5efrXRjfprfoUvjaUdAROwFyZHkBUmQpdtd3XRLPGvTMpuOdJlSAnNfMQsDF6TZT
        tukwEDaDi4zIR8GTy34OWpnoX6mrScA=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-332-vF6RMVBMP9OHRIc58Ito0A-1; Tue, 09 Nov 2021 08:03:30 -0500
X-MC-Unique: vF6RMVBMP9OHRIc58Ito0A-1
Received: by mail-ed1-f70.google.com with SMTP id h18-20020a056402281200b003e2e9ea00edso13296578ede.16
        for <netdev@vger.kernel.org>; Tue, 09 Nov 2021 05:03:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Cf4/5CFtCfqfKTzk28jN6LSZwSFGEQhCnZssU3UH2zk=;
        b=JsbSvEbCJWS30uHnQSYJxjfHCr5TdybW+cKgfwqeuZOUhCTV7AxDZz6E4UXNT6DXHR
         ngxnTLWpcxA8OjSOFtYD0exi9c9pcRH9hQwgrVoXI8t+ynT/nFHu3SXCgtw9FTR0qG0j
         OCmXXnFkO6kfofQZG4id3xQf79vI/RjxQc21IchtJuReRCwHG62BMKru2n3WkHq9d3HT
         YqNFAMJvXCgTq0gTK168vkpwXmMoo9Ir9JLC3VNaK8e3lHuHmg/+geFNEvDp2bfus1fh
         PZYC89+pqzg1UWeXCheAe/pOPKLbsghwieAyaopNG3fBDS4N2QuEhzgINrXMoH1TY7WY
         sHdA==
X-Gm-Message-State: AOAM532S+hD2+7xLtfW4zMCX8qehpCJBDLq5ONkHofe7RaTG7Q6ArBYC
        P7NeGdHH4BHVFBm2p61EA0BE2/B+2a/KvwiGEOusR8EIBVWmGplhn/bjZUq426Oxx0J2lTCQI72
        mYjnAxlbK3ek1MHR3
X-Received: by 2002:a50:e707:: with SMTP id a7mr10237712edn.352.1636463009399;
        Tue, 09 Nov 2021 05:03:29 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwswjgU9vYPdPQiIhqFtYWaC+jd0TG7EGgxo84FE6Db2sxhysQD3zCTHscC1w7Sr0OCCaAKGw==
X-Received: by 2002:a50:e707:: with SMTP id a7mr10237660edn.352.1636463009146;
        Tue, 09 Nov 2021 05:03:29 -0800 (PST)
Received: from redhat.com ([2.55.133.41])
        by smtp.gmail.com with ESMTPSA id de15sm211006ejc.70.2021.11.09.05.03.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Nov 2021 05:03:27 -0800 (PST)
Date:   Tue, 9 Nov 2021 08:03:18 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH v4 0/3] virtio support cache indirect desc
Message-ID: <20211109080023-mutt-send-email-mst@kernel.org>
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
> 
> v4:
>     1. Only allow desc cache when VIRTIO_RING_F_INDIRECT_DESC negotiation is successful
>     2. The desc cache threshold can be set for each virtqueue
> 
> v3:
>   pre-allocate per buffer indirect descriptors array

So I'm not sure why we are doing that. Did it improve anything?


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

