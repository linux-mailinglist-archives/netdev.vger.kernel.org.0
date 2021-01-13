Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E7B12F43D9
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 06:30:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725902AbhAMF3Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 00:29:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725846AbhAMF3X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 00:29:23 -0500
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F220C061575
        for <netdev@vger.kernel.org>; Tue, 12 Jan 2021 21:28:43 -0800 (PST)
Received: by mail-io1-xd2b.google.com with SMTP id w18so1850699iot.0
        for <netdev@vger.kernel.org>; Tue, 12 Jan 2021 21:28:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PXarfCM/t5YYg96RuuDNf/EAN9PIk8XOCXAfykHfFiM=;
        b=MdE2NvaVmRN5127tl447X3l3S8hp245XrP3JB5TfUmUJ1n+gJbgnub0wi/9qvUH0Rb
         /nvxQU5VLhQ00ja7tf54HAQ7yCLVf4xLZ09Qs/GqATTdUWosfCiMhaVslXTN4wcGMY9N
         qk3kf+GFq1DkJ99LV/uq40bBvfk5GYZ6GQWHlKEGu0WryNVyU055hg8zmjviaV3Bbplu
         SvkQ/qL97RFxe1IqMVjpXMWas3KLvrsK3r52g5Mz019MrKPS9QhoJMZkyuUnjfdl5x+V
         Em/JQw2IQYxOhfqqJXq4a8cp0+tu5Yz2PtIMuEB+M9Qw0fFoUDuLpYs1gMX7WbpG5fag
         6G6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PXarfCM/t5YYg96RuuDNf/EAN9PIk8XOCXAfykHfFiM=;
        b=uONNgwd/RLLW5MynvQOefNIKJlB0FIXQ01jQSjIvOF7qmm30++VsEw7sjqF/ZxPQvf
         qKI4jI8M6UajCD60206KNqBJF0z1OgSynS5CCsbb+kolvhjSw+uMLDEYJSBe9IIjom/t
         MZZfFvq9W4ogjRWzDaAc4xbaygTsIw0mCmsdopTSCAenHOItNwp2c1IPlC+jmiIX24cY
         RHQx/Jf2P347sQUFfRe0GyHwR5MAItNYM1PD90H8RrQ5ZCWLxW9DZt7rXvTr38jGsFfk
         TOD5sKFHdPknfvoCCAqd/au5tMMQuQap2PdZ8e91CVED/1EJ6OTwrPKbBzb31A2kNexO
         xT9w==
X-Gm-Message-State: AOAM5320tJtSihgAgE3D6zhC9Il/zWSy09skmf0mUllF5ZcCBs9ntS7z
        fhM2Z0TyjwZdHDQSAar2NF4TI1nwLY4J4FRkaZu8AQ==
X-Google-Smtp-Source: ABdhPJyor7wnaMyyp3NN3nADifnSjlR88rIX0rwGs9uEPFbVBAOy8Py/KFiDGfQMmDRhodXM5StoW+nGvzrtnz7hoRM=
X-Received: by 2002:a92:ce09:: with SMTP id b9mr712024ilo.69.1610515722626;
 Tue, 12 Jan 2021 21:28:42 -0800 (PST)
MIME-Version: 1.0
References: <20210113051207.142711-1-eric.dumazet@gmail.com>
In-Reply-To: <20210113051207.142711-1-eric.dumazet@gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 13 Jan 2021 06:28:30 +0100
Message-ID: <CANn89iKsbEf5P+sxQbbLVxT-0N6PFKqf5trBR0s739UT4ttHrg@mail.gmail.com>
Subject: Re: [PATCH net] Revert "virtio_net: replace netdev_alloc_skb_ip_align()
 with napi_alloc_skb()"
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Greg Thelen <gthelen@google.com>,
        Alexander Duyck <alexanderduyck@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 13, 2021 at 6:12 AM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
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
>
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
> ---
>  drivers/net/virtio_net.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 508408fbe78fbd8658dc226834b5b1b334b8b011..5886504c1acacf3f6148127b5c1cc7f6a906b827 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -386,7 +386,7 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
>         p = page_address(page) + offset;
>
>         /* copy small packet so we can reuse these pages for small data */
> -       skb = napi_alloc_skb(&rq->napi, GOOD_COPY_LEN);
> +       skb = netdev_alloc_skb_ip_align(vi->dev, GOOD_COPY_LEN);
>         if (unlikely(!skb))
>                 return NULL;
>
> --
> 2.30.0.284.gd98b1dd5eaa7-goog
>

Note that __netdev_alloc_skb() will also need to be changed.

Fitting 32 skb->head in a page without SLAB/SLUB help is simply too dangerous.
