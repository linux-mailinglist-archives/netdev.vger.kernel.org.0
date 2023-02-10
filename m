Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F9A4691BF4
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 10:52:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231598AbjBJJwg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 04:52:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231405AbjBJJwf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 04:52:35 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA06E8A5D;
        Fri, 10 Feb 2023 01:52:33 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id jg8so14304150ejc.6;
        Fri, 10 Feb 2023 01:52:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=kU2UMSdVf6ATg2sdzEwIyGZLq0FY+uJF2CLbcEvZ/Gg=;
        b=MCBeOKGH9aSNHAdUJpAsDjpVN0CkK+o96HXDfN68uXXdXNs4X9LJe1l4iud926JjD0
         llaww1wsoZNX+aMgljfw0Y98kfEwzFcIdNQJehoRkP80uGDi9dN+0ovOh3SdfOqxxb23
         wmnPfDHIDQ2fUVTH98TeO4uEOGPNzyNoQfzDUuUTxfQApJa02OAK02hYZOgFedWj8XKB
         +YjIcnNUNuSAYtLa+lLQaQs/oRJ88TgGR8f47X5bi9bi7bTz6/Rfzb2e0WIj7Yqp/KZV
         Z3Z/RSxhOKWxdXwD0o0Idruxu5s1JP+SCCzm2P/URUMzcHUHxvkcZcijcDWV7i74hRmX
         Oq1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kU2UMSdVf6ATg2sdzEwIyGZLq0FY+uJF2CLbcEvZ/Gg=;
        b=wXXZxf+4sZ0EjFGsHcTXHG+hz1o7lZG22fNQkY9wZKgmQISAA6rkrN2I3E2JraccO4
         CkNQssJegm7Edr76H7s/da9XNb2Fi8KI8XmrHsYypdkEPoMO7FtcClLf0gZeLszJ9BrQ
         1nzRk9dxMbV/gvHrMmLfyw1GZMHya0bUcRz3gAHrBlenT0leFukv9DquZ3/8n1cAwMfZ
         MhjykGzPIDie/rj12mIpvlXVFWF34FRlTtjB3QmYXhAkcrSvFRWlA4B2MfB0FFahhdG9
         RUtc8SmV0+qB6NMuvkoLy8c2isMn23tY1Zn4YSlvEb+0uOhOsEjt7Q3Ak1yug9AGqDMc
         p9wQ==
X-Gm-Message-State: AO0yUKXynwqFZckuePMskmRCJGgrr29DhJ+7zexoBWVBovDBtnJfgoHZ
        Vw7aomE0ExglFuMYpm7dXHC+IGeAWuKJCVPE1kY=
X-Google-Smtp-Source: AK7set9OBqhHTYvltqTQkSQcNeaU3sDaS3zqSnOalhCYu1ZVdEmhXWNE0bb1PLTNY8YrM3ZCFgvgiyQ648nFXN3mM3o=
X-Received: by 2002:a17:906:2cc4:b0:887:2895:d26e with SMTP id
 r4-20020a1709062cc400b008872895d26emr1149540ejr.4.1676022752346; Fri, 10 Feb
 2023 01:52:32 -0800 (PST)
MIME-Version: 1.0
References: <20230210021232.108211-1-xuanzhuo@linux.alibaba.com>
In-Reply-To: <20230210021232.108211-1-xuanzhuo@linux.alibaba.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Fri, 10 Feb 2023 10:52:20 +0100
Message-ID: <CAJ8uoz0EqC81hJRw=3dj6vE99Y6+Y6daN3ugrSWhAUzrgYUT1Q@mail.gmail.com>
Subject: Re: [PATCH net-next v1] xsk: support use vaddr as ring
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     netdev@vger.kernel.org,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>, bpf@vger.kernel.org,
        kernel test robot <lkp@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 10 Feb 2023 at 03:14, Xuan Zhuo <xuanzhuo@linux.alibaba.com> wrote:
>
> When we try to start AF_XDP on some machines with long running time, due
> to the machine's memory fragmentation problem, there is no sufficient
> continuous physical memory that will cause the start failure.
>
> After AF_XDP fails to apply for continuous physical memory, this patch
> tries to use vmalloc() to allocate memory to solve this problem.
>
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> Reported-by: kernel test robot <lkp@intel.com>
> Link: https://lore.kernel.org/oe-kbuild-all/202302091850.0HBmsDAq-lkp@intel.com
> ---
>  net/xdp/xsk.c       |  8 +++++---
>  net/xdp/xsk_queue.c | 21 +++++++++++++++------
>  net/xdp/xsk_queue.h |  1 +
>  3 files changed, 21 insertions(+), 9 deletions(-)
>
> diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
> index 9f0561b67c12..33db57548ee3 100644
> --- a/net/xdp/xsk.c
> +++ b/net/xdp/xsk.c
> @@ -1296,7 +1296,6 @@ static int xsk_mmap(struct file *file, struct socket *sock,
>         struct xdp_sock *xs = xdp_sk(sock->sk);
>         struct xsk_queue *q = NULL;
>         unsigned long pfn;
> -       struct page *qpg;
>
>         if (READ_ONCE(xs->state) != XSK_READY)
>                 return -EBUSY;
> @@ -1319,10 +1318,13 @@ static int xsk_mmap(struct file *file, struct socket *sock,
>
>         /* Matches the smp_wmb() in xsk_init_queue */
>         smp_rmb();
> -       qpg = virt_to_head_page(q->ring);
> -       if (size > page_size(qpg))
> +
> +       if (PAGE_ALIGN(q->ring_size) < size)
>                 return -EINVAL;
>
> +       if (is_vmalloc_addr(q->ring))
> +               return remap_vmalloc_range(vma, q->ring, 0);
> +
>         pfn = virt_to_phys(q->ring) >> PAGE_SHIFT;
>         return remap_pfn_range(vma, vma->vm_start, pfn,
>                                size, vma->vm_page_prot);
> diff --git a/net/xdp/xsk_queue.c b/net/xdp/xsk_queue.c
> index 6cf9586e5027..7b03102d1672 100644
> --- a/net/xdp/xsk_queue.c
> +++ b/net/xdp/xsk_queue.c
> @@ -7,6 +7,7 @@
>  #include <linux/slab.h>
>  #include <linux/overflow.h>
>  #include <net/xdp_sock_drv.h>
> +#include <linux/vmalloc.h>
>
>  #include "xsk_queue.h"
>
> @@ -37,14 +38,18 @@ struct xsk_queue *xskq_create(u32 nentries, bool umem_queue)
>                     __GFP_COMP  | __GFP_NORETRY;
>         size = xskq_get_ring_size(q, umem_queue);
>
> +       q->ring_size = size;
>         q->ring = (struct xdp_ring *)__get_free_pages(gfp_flags,
>                                                       get_order(size));
> -       if (!q->ring) {
> -               kfree(q);
> -               return NULL;
> -       }
> +       if (q->ring)
> +               return q;
> +
> +       q->ring = (struct xdp_ring *)vmalloc_user(size);
> +       if (q->ring)
> +               return q;

Thanks for bringing this to attention. Interesting to see how hard it
gets after a while to find consecutive memory since this is not a
large area.

I am wondering if it would be better to remove the __get_free_pages()
and just go for vmalloc_user. There is no particular reason here for
allocating consecutive physical pages for the ring. Does anyone see
any problem with removing this? If not, please just remove
__get_free_pages(), test it, and post a v2.

> -       return q;
> +       kfree(q);
> +       return NULL;
>  }
>
>  void xskq_destroy(struct xsk_queue *q)
> @@ -52,6 +57,10 @@ void xskq_destroy(struct xsk_queue *q)
>         if (!q)
>                 return;
>
> -       page_frag_free(q->ring);
> +       if (is_vmalloc_addr(q->ring))
> +               vfree(q->ring);
> +       else
> +               page_frag_free(q->ring);
> +
>         kfree(q);
>  }
> diff --git a/net/xdp/xsk_queue.h b/net/xdp/xsk_queue.h
> index c6fb6b763658..35922b8b92a8 100644
> --- a/net/xdp/xsk_queue.h
> +++ b/net/xdp/xsk_queue.h
> @@ -45,6 +45,7 @@ struct xsk_queue {
>         struct xdp_ring *ring;
>         u64 invalid_descs;
>         u64 queue_empty_descs;
> +       size_t ring_size;
>  };
>
>  /* The structure of the shared state of the rings are a simple
> --
> 2.32.0.3.g01195cf9f
>
