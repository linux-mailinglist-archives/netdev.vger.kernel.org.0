Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36E036920CE
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 15:27:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232475AbjBJO1Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 09:27:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232095AbjBJO1X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 09:27:23 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05B0671F22;
        Fri, 10 Feb 2023 06:27:22 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id qw12so16359452ejc.2;
        Fri, 10 Feb 2023 06:27:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=gqvwEiy6tjXgs0TxUyVWIpsJZntx//0YIrMnR/vNlgM=;
        b=kvwi0saH70qtxqTpaqWhTFRUBsirM9swVU5fbdwmsvEl4Y3Fb1hTWfcu3/yeaXlhMw
         PQc16k7Dt2qYESoj0D0FwFBof8TL6MxksyIpGmCCvIxF1J+UzyPArYx+CqvfupxIPXEk
         NZwP6T5fTD9QtIZloYk87cx4sg+UsY8OvIo5tnQ06wT0cqtA7iV01/wF2KL22TbgGnJc
         TlI72Rr4Dy2TgzlgLfQSNGjwWtM6gle4s0hJ6dQ4ORGUc5CYqoxMCg4pus5IOQEWJzBN
         huOpAYth+jnJjgpmRrz2PQJxbs2wXLWG3E+xwoKXIfMP1P/dzC8h0PE8N1yjgHAmD9cV
         G7iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gqvwEiy6tjXgs0TxUyVWIpsJZntx//0YIrMnR/vNlgM=;
        b=IZKHgTvCJaiFSn8CP1M16a1UDtzbgmIC2k0cggT9vFWvWM5ZeeYeLainr/SH304cbA
         QEfo9+3/9FhiDqtyO9OeOg9sFAngRCEiQe+oDW01qtluMzMRb/AhPWgKFGPsaNKX+w6A
         nolmt3jDxznsAc3BqEZuYMrpTed2wW3jiw6MYi/dnmVPicEgyvvuh45T5JEj51jB0Z07
         eXGPOpCPvvDzoACswEYn4/gIbvrtwRFKnZPOrwHa2+1hUvcy/QSmIUevaMo1QrdNtbIK
         S/Tl34mYjWFPyuaAymPIi/rqHrmT8oRkwor7f6HS3RP71UkXu/dkJ0vKik9Dur/AFHnO
         VtMA==
X-Gm-Message-State: AO0yUKVHaU7Abu4aUYiniJzXHn0l257VGj16t2XuICy3GWVmvcqOsoc2
        6Pyq081n4Od7qIhoW8dEA+WDQnwuSEbVSSny1hkiaNaB0p68K/h+
X-Google-Smtp-Source: AK7set+8HhWkAVH4MuZiTGKVHraLDHMznvLcs+IhbRMH7QE3sxljYDmWYzuGptMPsXg8O66N4Ey5j3xds4HQvTsneAo=
X-Received: by 2002:a17:906:28d5:b0:878:5f93:e797 with SMTP id
 p21-20020a17090628d500b008785f93e797mr2714283ejd.4.1676039240442; Fri, 10 Feb
 2023 06:27:20 -0800 (PST)
MIME-Version: 1.0
References: <20230210021232.108211-1-xuanzhuo@linux.alibaba.com>
 <CAJ8uoz0EqC81hJRw=3dj6vE99Y6+Y6daN3ugrSWhAUzrgYUT1Q@mail.gmail.com> <1676031148.2384832-1-xuanzhuo@linux.alibaba.com>
In-Reply-To: <1676031148.2384832-1-xuanzhuo@linux.alibaba.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Fri, 10 Feb 2023 15:27:08 +0100
Message-ID: <CAJ8uoz0Ayfbtf0ENciXoJxmzQUk4tHL58v3QWPdWmc01Y7Pz=A@mail.gmail.com>
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

On Fri, 10 Feb 2023 at 13:21, Xuan Zhuo <xuanzhuo@linux.alibaba.com> wrote:
>
> On Fri, 10 Feb 2023 10:52:20 +0100, Magnus Karlsson <magnus.karlsson@gmail.com> wrote:
> > On Fri, 10 Feb 2023 at 03:14, Xuan Zhuo <xuanzhuo@linux.alibaba.com> wrote:
> > >
> > > When we try to start AF_XDP on some machines with long running time, due
> > > to the machine's memory fragmentation problem, there is no sufficient
> > > continuous physical memory that will cause the start failure.
> > >
> > > After AF_XDP fails to apply for continuous physical memory, this patch
> > > tries to use vmalloc() to allocate memory to solve this problem.
> > >
> > > Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> > > Reported-by: kernel test robot <lkp@intel.com>
> > > Link: https://lore.kernel.org/oe-kbuild-all/202302091850.0HBmsDAq-lkp@intel.com
> > > ---
> > >  net/xdp/xsk.c       |  8 +++++---
> > >  net/xdp/xsk_queue.c | 21 +++++++++++++++------
> > >  net/xdp/xsk_queue.h |  1 +
> > >  3 files changed, 21 insertions(+), 9 deletions(-)
> > >
> > > diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
> > > index 9f0561b67c12..33db57548ee3 100644
> > > --- a/net/xdp/xsk.c
> > > +++ b/net/xdp/xsk.c
> > > @@ -1296,7 +1296,6 @@ static int xsk_mmap(struct file *file, struct socket *sock,
> > >         struct xdp_sock *xs = xdp_sk(sock->sk);
> > >         struct xsk_queue *q = NULL;
> > >         unsigned long pfn;
> > > -       struct page *qpg;
> > >
> > >         if (READ_ONCE(xs->state) != XSK_READY)
> > >                 return -EBUSY;
> > > @@ -1319,10 +1318,13 @@ static int xsk_mmap(struct file *file, struct socket *sock,
> > >
> > >         /* Matches the smp_wmb() in xsk_init_queue */
> > >         smp_rmb();
> > > -       qpg = virt_to_head_page(q->ring);
> > > -       if (size > page_size(qpg))
> > > +
> > > +       if (PAGE_ALIGN(q->ring_size) < size)
> > >                 return -EINVAL;
> > >
> > > +       if (is_vmalloc_addr(q->ring))
> > > +               return remap_vmalloc_range(vma, q->ring, 0);
> > > +
> > >         pfn = virt_to_phys(q->ring) >> PAGE_SHIFT;
> > >         return remap_pfn_range(vma, vma->vm_start, pfn,
> > >                                size, vma->vm_page_prot);
> > > diff --git a/net/xdp/xsk_queue.c b/net/xdp/xsk_queue.c
> > > index 6cf9586e5027..7b03102d1672 100644
> > > --- a/net/xdp/xsk_queue.c
> > > +++ b/net/xdp/xsk_queue.c
> > > @@ -7,6 +7,7 @@
> > >  #include <linux/slab.h>
> > >  #include <linux/overflow.h>
> > >  #include <net/xdp_sock_drv.h>
> > > +#include <linux/vmalloc.h>
> > >
> > >  #include "xsk_queue.h"
> > >
> > > @@ -37,14 +38,18 @@ struct xsk_queue *xskq_create(u32 nentries, bool umem_queue)
> > >                     __GFP_COMP  | __GFP_NORETRY;
> > >         size = xskq_get_ring_size(q, umem_queue);
> > >
> > > +       q->ring_size = size;
> > >         q->ring = (struct xdp_ring *)__get_free_pages(gfp_flags,
> > >                                                       get_order(size));
> > > -       if (!q->ring) {
> > > -               kfree(q);
> > > -               return NULL;
> > > -       }
> > > +       if (q->ring)
> > > +               return q;
> > > +
> > > +       q->ring = (struct xdp_ring *)vmalloc_user(size);
> > > +       if (q->ring)
> > > +               return q;
> >
> > Thanks for bringing this to attention. Interesting to see how hard it
> > gets after a while to find consecutive memory since this is not a
> > large area.
>
> If the size of the queue is 8 * 1024, then the size of the desc[] is
> 8 * 1024 * 8 = 16 * PAGE, but we also add  struct xdp_ring size, so it is
> 16page+. This is necessary to apply for a 4-order memory. If there are a
> lot of queues, it is difficult.
>
> Here, that we actually waste 15 pages. 4-Order memory is 32 pages, but we only
> use 17 pages.

One more good argument to stop using __get_free_pages() in this function.

> >
> > I am wondering if it would be better to remove the __get_free_pages()
> > and just go for vmalloc_user. There is no particular reason here for
> > allocating consecutive physical pages for the ring. Does anyone see
> > any problem with removing this? If not, please just remove
> > __get_free_pages(), test it, and post a v2.
>
>
> I agree.
>
> Thanks.
>
>
> >
> > > -       return q;
> > > +       kfree(q);
> > > +       return NULL;
> > >  }
> > >
> > >  void xskq_destroy(struct xsk_queue *q)
> > > @@ -52,6 +57,10 @@ void xskq_destroy(struct xsk_queue *q)
> > >         if (!q)
> > >                 return;
> > >
> > > -       page_frag_free(q->ring);
> > > +       if (is_vmalloc_addr(q->ring))
> > > +               vfree(q->ring);
> > > +       else
> > > +               page_frag_free(q->ring);
> > > +
> > >         kfree(q);
> > >  }
> > > diff --git a/net/xdp/xsk_queue.h b/net/xdp/xsk_queue.h
> > > index c6fb6b763658..35922b8b92a8 100644
> > > --- a/net/xdp/xsk_queue.h
> > > +++ b/net/xdp/xsk_queue.h
> > > @@ -45,6 +45,7 @@ struct xsk_queue {
> > >         struct xdp_ring *ring;
> > >         u64 invalid_descs;
> > >         u64 queue_empty_descs;
> > > +       size_t ring_size;
> > >  };
> > >
> > >  /* The structure of the shared state of the rings are a simple
> > > --
> > > 2.32.0.3.g01195cf9f
> > >
