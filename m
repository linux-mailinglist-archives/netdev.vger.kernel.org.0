Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F24E12F4816
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 10:55:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725988AbhAMJye (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 04:54:34 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:38534 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725873AbhAMJyd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 04:54:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610531586;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=nc9pkHa+/HKVPyMxhOUsx5NkF5NEErF1pCa4ZvcbTfk=;
        b=gma9d3d/9kp572olYZhORVqRPcixzDZsJ3fwSeyJERUpfhv20BoiF/7FgLGGSinptXg0Hx
        nSzY/sizuqG5XmkT2+kJjmRUOySlaYWfoj9TAtpEvVXP9uD6Ev2bOYvVygSLXKRQ3dEy9u
        qCpG5TQLyXLKZ0Qlg3tWgVQo4k1yiKg=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-470-6RuJT0q8MY-s7lRSgNppeg-1; Wed, 13 Jan 2021 04:53:04 -0500
X-MC-Unique: 6RuJT0q8MY-s7lRSgNppeg-1
Received: by mail-wr1-f70.google.com with SMTP id b8so684184wrv.14
        for <netdev@vger.kernel.org>; Wed, 13 Jan 2021 01:53:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=nc9pkHa+/HKVPyMxhOUsx5NkF5NEErF1pCa4ZvcbTfk=;
        b=S4yLyLHakiiwphnYfHi0rn/utqjkJHmEB9Q4xUK03j2ZtOnqGuoRQRImr2Xqwjg78+
         oBNVdWeY3ZLPHzNSS2KONASUlT3nKw3gjow64k8ipqKnrAdgeWMwzjKwcUOqdH60xv3N
         FKQMqFfphkEUoJ6QRvsbPdERxm5Lz1QusVYjKj6JzhWy1qxlPrRCw6eAr2zcHX8/Evqt
         FrWvHHyfPOk+jNTyHfd082MH2c88PWthe42xYcjdh+MR8Of8/yPxq8jLQ7xYKQ7kzVGg
         p18tIhfoTbvu3zee+fwFH13MAAYy27tb6N0E0oAjHVCVnNhDsICmjpaOdMGGowaTELZs
         p0WA==
X-Gm-Message-State: AOAM531jP67KZIY3pFMY/9NUfYFdhP/MQ+MyWqks0ViSJV0SAl/rDo5h
        OOQBFY5Lj2x18o5OjvUdbJdQ8IqAs3sxF7V4L/3+uFU0+GnIZ5LcJjqUHBcHn/y+5rykbRTRswz
        4HZyLaujFAkZ2ag4g
X-Received: by 2002:adf:8185:: with SMTP id 5mr1634713wra.44.1610531583143;
        Wed, 13 Jan 2021 01:53:03 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyqjZ9ECZnYFZiD2YIOghWl74tAF0WH6WUG8cES59RYlLFA/NtAJT7oXQrFSiDj2L6dnkdKRA==
X-Received: by 2002:adf:8185:: with SMTP id 5mr1634694wra.44.1610531582910;
        Wed, 13 Jan 2021 01:53:02 -0800 (PST)
Received: from redhat.com (bzq-79-178-32-166.red.bezeqint.net. [79.178.32.166])
        by smtp.gmail.com with ESMTPSA id b127sm2180374wmc.45.2021.01.13.01.53.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Jan 2021 01:53:02 -0800 (PST)
Date:   Wed, 13 Jan 2021 04:52:58 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Greg Thelen <gthelen@google.com>
Subject: Re: [PATCH net] Revert "virtio_net: replace
 netdev_alloc_skb_ip_align() with napi_alloc_skb()"
Message-ID: <20210113043722-mutt-send-email-mst@kernel.org>
References: <20210113051207.142711-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210113051207.142711-1-eric.dumazet@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 12, 2021 at 09:12:07PM -0800, Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> This reverts commit c67f5db82027ba6d2ea4ac9176bc45996a03ae6a.
> 
> While using page fragments instead of a kmalloc backed skb->head might give
> a small performance improvement in some cases, there is a huge risk of
> memory use under estimation.
> 
> GOOD_COPY_LEN is 128 bytes. This means that we need a small amount
> of memory to hold the headers and struct skb_shared_info
> 
> Yet, napi_alloc_skb() might use a whole 32KB page (or 64KB on PowerPc)
> for long lived incoming TCP packets.
> 
> We have been tracking OOM issues on GKE hosts hitting tcp_mem limits
> but consuming far more memory for TCP buffers than instructed in tcp_mem[2]

Are you using virtio on the host then? Is this with a hardware virtio
device? These do exist, guest is just more common, so I wanted to
make sure this is not a mistake.

> Even if we force napi_alloc_skb() to only use order-0 pages, the issue
> would still be there on arches with PAGE_SIZE >= 32768
> 
> Using alloc_skb() and thus standard kmallloc() for skb->head allocations
> will get the benefit of letting other objects in each page being independently
> used by other skbs, regardless of the lifetime.
> 
> Note that a similar problem exists for skbs allocated from napi_get_frags(),
> this is handled in a separate patch.
> 
> I would like to thank Greg Thelen for his precious help on this matter,
> analysing crash dumps is always a time consuming task.
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Paolo Abeni <pabeni@redhat.com>
> Cc: Michael S. Tsirkin <mst@redhat.com>
> Cc: Greg Thelen <gthelen@google.com>

Just curious - is the way virtio used napi_alloc_skb wrong somehow?

The idea was to benefit from better batching and less play with irq save
...

It would be helpful to improve the comments for napi_alloc_skb
to make it clearer how to use it correctly.

Are other uses of napi_alloc_skb ok?

> ---
>  drivers/net/virtio_net.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 508408fbe78fbd8658dc226834b5b1b334b8b011..5886504c1acacf3f6148127b5c1cc7f6a906b827 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -386,7 +386,7 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
>  	p = page_address(page) + offset;
>  
>  	/* copy small packet so we can reuse these pages for small data */
> -	skb = napi_alloc_skb(&rq->napi, GOOD_COPY_LEN);
> +	skb = netdev_alloc_skb_ip_align(vi->dev, GOOD_COPY_LEN);
>  	if (unlikely(!skb))
>  		return NULL;
>  
> -- 
> 2.30.0.284.gd98b1dd5eaa7-goog

