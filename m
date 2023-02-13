Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F421E694688
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 14:07:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229989AbjBMNHw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 08:07:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229890AbjBMNHv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 08:07:51 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CA1DAC;
        Mon, 13 Feb 2023 05:07:48 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id k16so151604ejv.10;
        Mon, 13 Feb 2023 05:07:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=mUklBIjUvpzTygRNkjL7EBieK+kb5qbR/+b3UV7oQVo=;
        b=XljlKcCqz0r/OcQTUMRVs0VoJUumosg8mdEo00665eN0KTEonjYbJrdQrWZw0h+nlJ
         /jd+K/c8HloY5MbV+TEO5fgLNCktXIcgfPhphsTMOjgkcm0/VAbmrYIdhJ00JYATc1c8
         uI8eQb8IYeVsUiubKN6XjOhNm5eNUuwxbwDzCfYdXY6+BBR96189OIeaZ5KLZKVuyr7C
         RsMTGElefjOpu0NA2jagAGB8nhMe74sjqoLK0bFC5iDFEeUls9HXhoSiRn8MKiAD2zoL
         V4qyglqeoR3ktKnsUfUuntJ/fFAwR0lrffgpJ+aE4W7xS5E/l/5Vb1EXdGZ4Fk8L/EbB
         HItA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mUklBIjUvpzTygRNkjL7EBieK+kb5qbR/+b3UV7oQVo=;
        b=7tiPvP7XYFEbwhdu/IGggmTlN7KqMPSA2+IWka+VZVwpRmjF0h/h5cJVrys6c5BEMM
         MKAhhAhk/IcBIz/Mcla1VhboS7YVps0aUy/0VKULGxs4EHNzqMzMmXF2lVkyGsxiN2Gs
         9TOoE1v5uhU1Qcs0cBdoGCpDAMcCy17sdWZrQ74SGe50V918qbcChbx9ZGzQlMvPpzZ9
         fA58PvgKeZtN0JbZ2dhR/xqtQXkyjeiu3+M28cSCCuoGXpDuXLOPyALJqerTNX0eQFaL
         TnMxq+LPxgk+b4seh2vBPFRiXn8do94Mliq0TMM+CB9RjOfMhjeU+SbVv6JULnHP+twt
         QGVw==
X-Gm-Message-State: AO0yUKWMh7kercbj7sdgsqIfiRepxfd/CTSLG/9sj3M47IqlA5XWTdd4
        fI24dPuVcRFEqVYXx6CPJvZmAwhytY4QeHx0LqM=
X-Google-Smtp-Source: AK7set/sG4XfLLnhb1LQuVGyEMXPMr1IG2xFCXjb8JXVnU3rtRGve0tuBHuEgwIU7vokuaJYmY5uUIxl5OR73L1GSpU=
X-Received: by 2002:a17:906:241a:b0:877:a0e4:4cce with SMTP id
 z26-20020a170906241a00b00877a0e44ccemr4547305eja.4.1676293666953; Mon, 13 Feb
 2023 05:07:46 -0800 (PST)
MIME-Version: 1.0
References: <20230212031232.3007-1-xuanzhuo@linux.alibaba.com>
In-Reply-To: <20230212031232.3007-1-xuanzhuo@linux.alibaba.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Mon, 13 Feb 2023 14:07:35 +0100
Message-ID: <CAJ8uoz2yc4UNOgpqqz34ctzGHsLcO5_jxawSVpSqW4XPNC5J9g@mail.gmail.com>
Subject: Re: [PATCH net-next v2] xsk: support use vaddr as ring
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

On Sun, 12 Feb 2023 at 04:22, Xuan Zhuo <xuanzhuo@linux.alibaba.com> wrote:
>
> When we try to start AF_XDP on some machines with long running time, due
> to the machine's memory fragmentation problem, there is no sufficient
> continuous physical memory that will cause the start failure.

nit: contiguous

But perfectly understandable without fixing this.

> If the size of the queue is 8 * 1024, then the size of the desc[] is
> 8 * 1024 * 8 = 16 * PAGE, but we also add struct xdp_ring size, so it is
> 16page+. This is necessary to apply for a 4-order memory. If there are a
> lot of queues, it is difficult to these machine with long running time.
>
> Here, that we actually waste 15 pages. 4-Order memory is 32 pages, but
> we only use 17 pages.
>
> This patch replaces __get_free_pages() by vmalloc() to allocate memory
> to solve these problems.

Thanks for improving/fixing this.

Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>

> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> Reported-by: kernel test robot <lkp@intel.com>
> Link: https://lore.kernel.org/oe-kbuild-all/202302091850.0HBmsDAq-lkp@intel.com
> ---
>
> v2:
>     1. remove __get_free_pages() @Magnus Karlsson
>
>  net/xdp/xsk.c       |  9 ++-------
>  net/xdp/xsk_queue.c | 10 ++++------
>  net/xdp/xsk_queue.h |  1 +
>  3 files changed, 7 insertions(+), 13 deletions(-)
>
> diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
> index 9f0561b67c12..6a588b99b670 100644
> --- a/net/xdp/xsk.c
> +++ b/net/xdp/xsk.c
> @@ -1295,8 +1295,6 @@ static int xsk_mmap(struct file *file, struct socket *sock,
>         unsigned long size = vma->vm_end - vma->vm_start;
>         struct xdp_sock *xs = xdp_sk(sock->sk);
>         struct xsk_queue *q = NULL;
> -       unsigned long pfn;
> -       struct page *qpg;
>
>         if (READ_ONCE(xs->state) != XSK_READY)
>                 return -EBUSY;
> @@ -1319,13 +1317,10 @@ static int xsk_mmap(struct file *file, struct socket *sock,
>
>         /* Matches the smp_wmb() in xsk_init_queue */
>         smp_rmb();
> -       qpg = virt_to_head_page(q->ring);
> -       if (size > page_size(qpg))
> +       if (size > PAGE_ALIGN(q->ring_size))
>                 return -EINVAL;
>
> -       pfn = virt_to_phys(q->ring) >> PAGE_SHIFT;
> -       return remap_pfn_range(vma, vma->vm_start, pfn,
> -                              size, vma->vm_page_prot);
> +       return remap_vmalloc_range(vma, q->ring, 0);
>  }
>
>  static int xsk_notifier(struct notifier_block *this,
> diff --git a/net/xdp/xsk_queue.c b/net/xdp/xsk_queue.c
> index 6cf9586e5027..247316bdfcbe 100644
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
> @@ -23,7 +24,6 @@ static size_t xskq_get_ring_size(struct xsk_queue *q, bool umem_queue)
>  struct xsk_queue *xskq_create(u32 nentries, bool umem_queue)
>  {
>         struct xsk_queue *q;
> -       gfp_t gfp_flags;
>         size_t size;
>
>         q = kzalloc(sizeof(*q), GFP_KERNEL);
> @@ -33,12 +33,10 @@ struct xsk_queue *xskq_create(u32 nentries, bool umem_queue)
>         q->nentries = nentries;
>         q->ring_mask = nentries - 1;
>
> -       gfp_flags = GFP_KERNEL | __GFP_ZERO | __GFP_NOWARN |
> -                   __GFP_COMP  | __GFP_NORETRY;
>         size = xskq_get_ring_size(q, umem_queue);
>
> -       q->ring = (struct xdp_ring *)__get_free_pages(gfp_flags,
> -                                                     get_order(size));
> +       q->ring_size = size;
> +       q->ring = (struct xdp_ring *)vmalloc_user(size);
>         if (!q->ring) {
>                 kfree(q);
>                 return NULL;
> @@ -52,6 +50,6 @@ void xskq_destroy(struct xsk_queue *q)
>         if (!q)
>                 return;
>
> -       page_frag_free(q->ring);
> +       vfree(q->ring);
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
