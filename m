Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 955672F4F39
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 16:53:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727262AbhAMPwd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 10:52:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726531AbhAMPwc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 10:52:32 -0500
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08B70C061575
        for <netdev@vger.kernel.org>; Wed, 13 Jan 2021 07:51:52 -0800 (PST)
Received: by mail-io1-xd29.google.com with SMTP id q1so5027685ion.8
        for <netdev@vger.kernel.org>; Wed, 13 Jan 2021 07:51:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mwXr/d12JQqyKGJk7KGIoQw7IEE2l3ofKfAy56JQ9Yk=;
        b=QRDWEH2Jxt82TYpdiE28Bdsh84YNeyNKwn9CQ/8gb9RPDySVbtuKhVQ8/6h82BrcV5
         e6SxKI6UODMN7oh7nfOA2AeNlGW8bqwMni9imrwxAtUgW9rQrjbvkN19SxPwVoPUPOVu
         1JHnce7lQfZBqZlU1iTOolGx2UqM/DNYkklrnweZ885BoqIOSpG6K96Se7aZ9BcrkWwq
         VDYSUlDLuv4ITOJrx0JORF1zgCMe3mDJOAS29mhyqj2HgDn3toAzmJPc1VKZKllDU2CD
         WcF38NL5gi/n1mVBYt2ViRYtPLWVBnaizyGm+oF94M1tgVj8sZczNJoMuFOROlPNM57g
         R1eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mwXr/d12JQqyKGJk7KGIoQw7IEE2l3ofKfAy56JQ9Yk=;
        b=tn+jt/KxyMPmRxoBADK4DnoLFRdK6nrhsrAw9GSNu0E6I17jO0IdJTKDa07WjXR34t
         1PWdG4NfpTv24RVI8gFBV3A4rgpUdNGLy4ojexFWPPfxZu4DKQtCkkVtRg5pD6QoEiaO
         V0n1uiha9ORhvbk0jUOWWI0LbdlU95KjEkGdp4v+1Z6r4UVr9oBOHGdgt9sDO19Pf8oi
         bHS9MhtQQztnCaVgIDFcITBW9by3CizmPDCHHEFVKnhMvZR4jbguqe7r9b6offTYF9Uz
         Vvu2b96O41ERZAEMZtMxn41XEuM0llsrSuPP/O04n4A7Sm+9LW57xHEjMSYkE3ONvUmz
         CFzA==
X-Gm-Message-State: AOAM5322xD0XcsMlWNXNPsFvMZMKAsbMuB/F2GLl3iVTQpBjpUWhNb4F
        HU2KeXYa0Q8wZldWv/RxHDPnG51Zh4xauo0YocSTLg==
X-Google-Smtp-Source: ABdhPJyOMM/FoZ7Tc9A2pVVmWKxPhkGfJ++yLVYtMN9sQLl6cl33PzEdTjVKr72MrExNqJyv09tlUEA7bE9m0yJte/c=
X-Received: by 2002:a92:ce09:: with SMTP id b9mr2828183ilo.69.1610553111194;
 Wed, 13 Jan 2021 07:51:51 -0800 (PST)
MIME-Version: 1.0
References: <20210113051207.142711-1-eric.dumazet@gmail.com> <2135e96c89ce3dced96c77702f2539ae3ce9d8bb.camel@redhat.com>
In-Reply-To: <2135e96c89ce3dced96c77702f2539ae3ce9d8bb.camel@redhat.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 13 Jan 2021 16:51:39 +0100
Message-ID: <CANn89iKU9RbxGsMt1t1+o+bQGEE8xz=yv=gadzH3Vua33+=3cg@mail.gmail.com>
Subject: Re: [PATCH net] Revert "virtio_net: replace netdev_alloc_skb_ip_align()
 with napi_alloc_skb()"
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Greg Thelen <gthelen@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 13, 2021 at 4:44 PM Paolo Abeni <pabeni@redhat.com> wrote:
>
> On Tue, 2021-01-12 at 21:12 -0800, Eric Dumazet wrote:
> > From: Eric Dumazet <edumazet@google.com>
> >
> > This reverts commit c67f5db82027ba6d2ea4ac9176bc45996a03ae6a.
> >
> > While using page fragments instead of a kmalloc backed skb->head might give
> > a small performance improvement in some cases, there is a huge risk of
> > memory use under estimation.
> >
> > GOOD_COPY_LEN is 128 bytes. This means that we need a small amount
> > of memory to hold the headers and struct skb_shared_info
> >
> > Yet, napi_alloc_skb() might use a whole 32KB page (or 64KB on PowerPc)
> > for long lived incoming TCP packets.
> >
> > We have been tracking OOM issues on GKE hosts hitting tcp_mem limits
> > but consuming far more memory for TCP buffers than instructed in tcp_mem[2]
> >
> > Even if we force napi_alloc_skb() to only use order-0 pages, the issue
> > would still be there on arches with PAGE_SIZE >= 32768
> >
> > Using alloc_skb() and thus standard kmallloc() for skb->head allocations
> > will get the benefit of letting other objects in each page being independently
> > used by other skbs, regardless of the lifetime.
> >
> > Note that a similar problem exists for skbs allocated from napi_get_frags(),
> > this is handled in a separate patch.
> >
> > I would like to thank Greg Thelen for his precious help on this matter,
> > analysing crash dumps is always a time consuming task.
> >
> > Signed-off-by: Eric Dumazet <edumazet@google.com>
> > Cc: Paolo Abeni <pabeni@redhat.com>
> > Cc: Michael S. Tsirkin <mst@redhat.com>
> > Cc: Greg Thelen <gthelen@google.com>
> > ---
> >  drivers/net/virtio_net.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > index 508408fbe78fbd8658dc226834b5b1b334b8b011..5886504c1acacf3f6148127b5c1cc7f6a906b827 100644
> > --- a/drivers/net/virtio_net.c
> > +++ b/drivers/net/virtio_net.c
> > @@ -386,7 +386,7 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
> >       p = page_address(page) + offset;
> >
> >       /* copy small packet so we can reuse these pages for small data */
> > -     skb = napi_alloc_skb(&rq->napi, GOOD_COPY_LEN);
> > +     skb = netdev_alloc_skb_ip_align(vi->dev, GOOD_COPY_LEN);
> >       if (unlikely(!skb))
> >               return NULL;
>
> I'm ok with the revert. The gain given by the original change in my
> tests was measurable, but small.
>
> Acked-by: Paolo Abeni <pabeni@redhat.com>

To be clear, I now think the revert is not needed.

I will post instead a patch that should take care of the problem both
for virtio and napi_get_frags() tiny skbs

Something like :

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 7626a33cce590e530f36167bd096026916131897..3a8f55a43e6964344df464a27b9b1faa0eb804f3
100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -501,13 +501,17 @@ EXPORT_SYMBOL(__netdev_alloc_skb);
 struct sk_buff *__napi_alloc_skb(struct napi_struct *napi, unsigned int len,
                                 gfp_t gfp_mask)
 {
-       struct napi_alloc_cache *nc = this_cpu_ptr(&napi_alloc_cache);
+       struct napi_alloc_cache *nc;
        struct sk_buff *skb;
        void *data;

        len += NET_SKB_PAD + NET_IP_ALIGN;

-       if ((len > SKB_WITH_OVERHEAD(PAGE_SIZE)) ||
+       /* If requested length is either too small or too big,
+        * we use kmalloc() for skb->head allocation.
+        */
+       if (len <= SKB_WITH_OVERHEAD(1024) ||
+           len > SKB_WITH_OVERHEAD(PAGE_SIZE) ||
            (gfp_mask & (__GFP_DIRECT_RECLAIM | GFP_DMA))) {
                skb = __alloc_skb(len, gfp_mask, SKB_ALLOC_RX, NUMA_NO_NODE);
                if (!skb)
@@ -515,6 +519,7 @@ struct sk_buff *__napi_alloc_skb(struct
napi_struct *napi, unsigned int len,
                goto skb_success;
        }

+       nc = this_cpu_ptr(&napi_alloc_cache);
        len += SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
        len = SKB_DATA_ALIGN(len);
