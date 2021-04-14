Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DE5335EE1E
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 09:27:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243980AbhDNHBD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 03:01:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231126AbhDNHAv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Apr 2021 03:00:51 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 195F3C061574;
        Wed, 14 Apr 2021 00:00:30 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id g35so13699842pgg.9;
        Wed, 14 Apr 2021 00:00:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MtSmmrilcqvRKvf6VQzJGqVexY/UKeAdblzP/tGRRfg=;
        b=gw0mJlVvsGTJXyx02xtl5gNEYnRzzOyCB0sQilzKPvZtvT7EWMvqmTyW/19OB6UbOg
         wo4xL6Pn4NlbI+KaZfImNFYHzy0Unkk/yJt8Z/BEhjvl0Fq9yipJwihD28sbrN7kNo18
         J6rNEJf96pdLQYycuppIZeES8qrQ3fiDKxL810BEpCh9NhxnN8oi5N2NxpFvQVvODk9t
         DdpSaUHjIH5U4SD57Nj65hMPlE7AUE+2wMMHSUiLIDF0rnhFcmPfhImXU2s6gRXTcKSz
         +1FC3GVhsK0wcQ5cpRKwgXPCqCiRdZX/uj/mlIKsrWspxW4+umsdcPkjm2Uj6c3eVe+5
         plUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MtSmmrilcqvRKvf6VQzJGqVexY/UKeAdblzP/tGRRfg=;
        b=QU6ErcyWZGdahmCgFUA1NcJv27l5lNygWD6yDM2exIfzgjza8tt2fwK/tRrWndOAMR
         jCaqe5tSjRC81VAOiW0tUClA6NWUscqVjUYMCs0U09WP8V8Hub58tY6F1Hz91Tnb2Paq
         F77TZn08eKTsfsdoM72TZXpKmpcmVBOFWb0zp3hXKswmeei+7wfhx+8BLMBDIFSqyLS7
         gswCD/xtvAYPRrV+PlUkzU6hQCu0YaHqKoITehyQKgQuHxfxjNbF2vtZqbJYoO9jKXVJ
         J2sjS8tJlttBLvEc7PZKl+b4QghiXGD+ufOwBim6eKT6HoAnV28fB6Osy56JOZrIKlFU
         a7hQ==
X-Gm-Message-State: AOAM533Kme1VruGEP1d1Zoftd0OzbnmpRkzOYXUg8higZrwZk8K6wsc5
        95CMrmOUuSCmBHdKX38znIqBTbqchr3R+U+t5E8=
X-Google-Smtp-Source: ABdhPJzm2xzZY58bobVQV52cA0pOQwdX6+VomKTl5PB5lu70W6l553YZ5r/PTjXHSXBEVXArZQBBVcDq9MlEaCA6QMg=
X-Received: by 2002:a65:6483:: with SMTP id e3mr36635882pgv.208.1618383629697;
 Wed, 14 Apr 2021 00:00:29 -0700 (PDT)
MIME-Version: 1.0
References: <20210413031523.73507-1-xuanzhuo@linux.alibaba.com> <20210413031523.73507-6-xuanzhuo@linux.alibaba.com>
In-Reply-To: <20210413031523.73507-6-xuanzhuo@linux.alibaba.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Wed, 14 Apr 2021 09:00:18 +0200
Message-ID: <CAJ8uoz1_hjUCK5zXheCaxmU6bTSu-saaamcZVeMRJpx2McJx4w@mail.gmail.com>
Subject: Re: [PATCH net-next v4 05/10] xsk: XDP_SETUP_XSK_POOL support option IFF_NOT_USE_DMA_ADDR
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        virtualization@lists.linux-foundation.org,
        bpf <bpf@vger.kernel.org>,
        "dust . li" <dust.li@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 13, 2021 at 9:58 AM Xuan Zhuo <xuanzhuo@linux.alibaba.com> wrote:
>
> Some devices, such as virtio-net, do not directly use dma addr. These
> devices do not initialize dma after completing the xsk setup, so the dma
> check is skipped here.
>
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> Reviewed-by: Dust Li <dust.li@linux.alibaba.com>

Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>

> ---
>  net/xdp/xsk_buff_pool.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/net/xdp/xsk_buff_pool.c b/net/xdp/xsk_buff_pool.c
> index 8de01aaac4a0..a7e434de0308 100644
> --- a/net/xdp/xsk_buff_pool.c
> +++ b/net/xdp/xsk_buff_pool.c
> @@ -171,7 +171,7 @@ int xp_assign_dev(struct xsk_buff_pool *pool,
>         if (err)
>                 goto err_unreg_pool;
>
> -       if (!pool->dma_pages) {
> +       if (!(netdev->priv_flags & IFF_NOT_USE_DMA_ADDR) && !pool->dma_pages) {
>                 WARN(1, "Driver did not DMA map zero-copy buffers");
>                 err = -EINVAL;
>                 goto err_unreg_xsk;
> --
> 2.31.0
>
