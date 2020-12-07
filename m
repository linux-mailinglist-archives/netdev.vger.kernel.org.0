Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7853F2D1BE3
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 22:19:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726897AbgLGVRL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 16:17:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726443AbgLGVRL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Dec 2020 16:17:11 -0500
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21846C061749;
        Mon,  7 Dec 2020 13:16:31 -0800 (PST)
Received: by mail-io1-xd41.google.com with SMTP id r9so14815166ioo.7;
        Mon, 07 Dec 2020 13:16:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bGKdZMBJWrzj+VSfEEmc1CeVfxqj1kEAtlw77s5Xc4Y=;
        b=SzZNPBBnFEF2SkN/QmZ055onpw3RhTNpsMmmtE8tpznf5YMLwVLKjNeoWc8jcykRZI
         N8X6JxZznmA+hwhVvMYhLCjiu0yrkyRZEgS3+omvYCARnxZdx+WhmcALskelzJWEA4lr
         FfbWC8naF807NPOZs1gkSqxy5X7C00oDjr3BHAtXBb7m0GAMcMqK+pXpA3Dt/EsyvCxC
         uxQCP9KITUZ91vi83WKdRY5qSNOLhX496vt3FUOjDLcf3SWc6QEScbJLqXVdL2moYBMu
         9yvxBfBAUVk/GoGJ2aYkzOfNgMIc0x5r2LlH742Uogvl5s8CyOnki4QCql9FwoDEnITz
         sVIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bGKdZMBJWrzj+VSfEEmc1CeVfxqj1kEAtlw77s5Xc4Y=;
        b=YkLsXm6HvBbS8yH46BBzHR2sv3U0FwFJayak3h1MOTki8JyVkY+DKb0ieB0+OZx7kr
         0AG+kzOOO3qfDLkTQtqb1HCGR9GPERfLCGwGX6JErAmXeF2epzoEFxhfAU43pvTB7wBl
         OtR1ewxiie2cCfbp7qblI228i86I2Za/GfA+tgJWB/meyKMlOC7tW+83g3oDRwyLyt6W
         Z/qYwUW3FNby75T4W0mompkd9XNCbAfPQwBigMnq8aT4Gzr+1udDCRv7zrH6KBA37Ian
         YtIMfuMjMIuuASGOqJIt0YNC0VX4mp8gd2JnCVvOJjGP1w7PYab0BMabL9IMhzWhVzln
         VfkA==
X-Gm-Message-State: AOAM530xH+z+ogs/eeE0ZuVqe5DQy23Zm+PSjiFG/Uj37/gYKxm142q/
        nu6X5KL4+1t6O88rb5LKGJO7/9jQXWjDchigzlg=
X-Google-Smtp-Source: ABdhPJwrzlxRKAT+Ia2OV2vkOsNJNwCWMHuFSyCbt1Yu8M5huGrUCOUjfI03rlvOp0QzTsKZ5m8ya3jHRK3hw+kr/rg=
X-Received: by 2002:a5d:81c1:: with SMTP id t1mr21693189iol.88.1607375790416;
 Mon, 07 Dec 2020 13:16:30 -0800 (PST)
MIME-Version: 1.0
References: <cover.1607349924.git.lorenzo@kernel.org> <7e7dbe0c739640b053c930d3cd22ab7588d6aa3c.1607349924.git.lorenzo@kernel.org>
In-Reply-To: <7e7dbe0c739640b053c930d3cd22ab7588d6aa3c.1607349924.git.lorenzo@kernel.org>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Mon, 7 Dec 2020 13:16:19 -0800
Message-ID: <CAKgT0UdqajD_fJRnkRVM6HgSu=3EkUfXn7niqtqxceLUQbzt3w@mail.gmail.com>
Subject: Re: [PATCH v5 bpf-next 01/14] xdp: introduce mb in xdp_buff/xdp_frame
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     bpf <bpf@vger.kernel.org>, Netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, shayagr@amazon.com,
        "Jubran, Samih" <sameehj@amazon.com>,
        John Fastabend <john.fastabend@gmail.com>, dsahern@kernel.org,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>,
        lorenzo.bianconi@redhat.com, Jason Wang <jasowang@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 7, 2020 at 8:36 AM Lorenzo Bianconi <lorenzo@kernel.org> wrote:
>
> Introduce multi-buffer bit (mb) in xdp_frame/xdp_buffer data structure
> in order to specify if this is a linear buffer (mb = 0) or a multi-buffer
> frame (mb = 1). In the latter case the shared_info area at the end of the
> first buffer is been properly initialized to link together subsequent
> buffers.
>
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>  include/net/xdp.h | 8 ++++++--
>  net/core/xdp.c    | 1 +
>  2 files changed, 7 insertions(+), 2 deletions(-)
>
> diff --git a/include/net/xdp.h b/include/net/xdp.h
> index 700ad5db7f5d..70559720ff44 100644
> --- a/include/net/xdp.h
> +++ b/include/net/xdp.h
> @@ -73,7 +73,8 @@ struct xdp_buff {
>         void *data_hard_start;
>         struct xdp_rxq_info *rxq;
>         struct xdp_txq_info *txq;
> -       u32 frame_sz; /* frame size to deduce data_hard_end/reserved tailroom*/
> +       u32 frame_sz:31; /* frame size to deduce data_hard_end/reserved tailroom*/
> +       u32 mb:1; /* xdp non-linear buffer */
>  };
>

If we are really going to do something like this I say we should just
rip a swath of bits out instead of just grabbing one. We are already
cutting the size down then we should just decide on the minimum size
that is acceptable and just jump to that instead of just stealing one
bit at a time. It looks like we already have differences between the
size here and frame_size in xdp_frame.

If we have to steal a bit why not look at something like one of the
lower 2/3 bits in rxq? You could then do the same thing using dev_rx
in a similar fashion instead of stealing from a bit that is likely to
be used in multiple spots and modifying like this adds extra overhead
to?

>  /* Reserve memory area at end-of data area.
> @@ -97,7 +98,8 @@ struct xdp_frame {
>         u16 len;
>         u16 headroom;
>         u32 metasize:8;
> -       u32 frame_sz:24;
> +       u32 frame_sz:23;
> +       u32 mb:1; /* xdp non-linear frame */
>         /* Lifetime of xdp_rxq_info is limited to NAPI/enqueue time,
>          * while mem info is valid on remote CPU.
>          */

Again, if we are just going to start shrinking frame_sz we should
probably define where we are going to limit ourselves to and just go
straight to that value. Otherwise we are going to start jeopardizing
backwards compatibility at some point when we steal too many bits.

> @@ -154,6 +156,7 @@ void xdp_convert_frame_to_buff(struct xdp_frame *frame, struct xdp_buff *xdp)
>         xdp->data_end = frame->data + frame->len;
>         xdp->data_meta = frame->data - frame->metasize;
>         xdp->frame_sz = frame->frame_sz;
> +       xdp->mb = frame->mb;
>  }
>
>  static inline
> @@ -180,6 +183,7 @@ int xdp_update_frame_from_buff(struct xdp_buff *xdp,
>         xdp_frame->headroom = headroom - sizeof(*xdp_frame);
>         xdp_frame->metasize = metasize;
>         xdp_frame->frame_sz = xdp->frame_sz;
> +       xdp_frame->mb = xdp->mb;
>
>         return 0;
>  }
> diff --git a/net/core/xdp.c b/net/core/xdp.c
> index 17ffd33c6b18..79dd45234e4d 100644
> --- a/net/core/xdp.c
> +++ b/net/core/xdp.c
> @@ -509,6 +509,7 @@ struct xdp_frame *xdp_convert_zc_to_xdp_frame(struct xdp_buff *xdp)
>         xdpf->headroom = 0;
>         xdpf->metasize = metasize;
>         xdpf->frame_sz = PAGE_SIZE;
> +       xdpf->mb = xdp->mb;
>         xdpf->mem.type = MEM_TYPE_PAGE_ORDER0;
>
>         xsk_buff_free(xdp);

At this point all you are doing is moving a meaningless flag. I would
think we would want to wait on adding this code until there is some
meaning behind the bit since it doesn't make sense to convert a
multi-buffer xdp_frame to a buffer. If nothing else it really feels
like there is some exception handling missing here as I would expect
that conversion of a multi-buffer frame should fail since you cannot
convert something from multiple to a single without having to redo
allocations and/or linearizing it.
