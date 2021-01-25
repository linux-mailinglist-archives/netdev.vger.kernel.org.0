Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0E53304A50
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 21:42:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731574AbhAZFIB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 00:08:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728731AbhAYNRI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 08:17:08 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CF65C061574;
        Mon, 25 Jan 2021 05:16:28 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id q131so8355902pfq.10;
        Mon, 25 Jan 2021 05:16:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=v7gUqTg77CyQJmc7oirUajg+klN0w28zTpZ0akGL9pQ=;
        b=ANJjXbjJjAqWZUgHmrfBHK+iTVb7yE5ZMy1/6UoiSx9yAj83c6d9PEQnGclx8iXm5u
         3Dj0cEAFylDej2UIvnqsIBiHcZLdAQB2wd1h3q9oa0iB4V8qwZtsHfLHk7VPQRIu2ANg
         +WJyFo2+I7R16aZy+scoLjmk27TiGchYr+iW+tL1lN5aTfWdr3JJoFzI4ZMUVC35G3ux
         oHVprOgpEDO5RDvnto75/PdixF8Qv37Kw3y3BREBMwR+g9p7WPetTKos1nfFcHrEhLDS
         hwOrCwsTW/et3KEOJBU/UdHAJz04g/hCDGsLAe+ZMs2YbYT6M/SYf8puTWWEq7YjsZvE
         OsGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=v7gUqTg77CyQJmc7oirUajg+klN0w28zTpZ0akGL9pQ=;
        b=aD6GBSxBbIF25MlU6MD9ymuvBnq1tzCetNfbI04pAhnjY9ieexCdOPSWS6M8lYKh1L
         BquzjCKwfhWpQ6TfX14t3drqkYbAvVzh8hoXdiqffaa+y5IGpoj6/6TaN+Mga3fXY4Vm
         O31mhVQNn8nuvaoe+dXcXp1AphtNRPZQcz9jCudcjGAaV01YxfFhgMtZoQO5GjjUSrAY
         RBrEtwJDeLa0U4NaKnDHOcUX8e5bG7wyUBKKcPKln2S8yUH9f6fmn/RIyAbosOWrkGDC
         wXCU0sWQtNtYAAReeenkDQqjdnAQ38vf0yGatr7kpBa/mGvqlEoV0CdGQXptoni8mG5r
         1o+w==
X-Gm-Message-State: AOAM530vVUnhKqNjkB2HbUQB8JKSIhzozYjlv17DPMqW2wtQPJAdFJAO
        MkJFJh5AnLR72Seku3+P1t+S/DlUv+HHz7aB+X8=
X-Google-Smtp-Source: ABdhPJx4oKbSxiDyNEaGROOZR+UwBmBdVfQMhSqa61xLjnhyfXuX8vPIQuu0NmJ3gR9nwQ3ucV5fuAwRJzj1zGuvhP4=
X-Received: by 2002:a65:450d:: with SMTP id n13mr597448pgq.208.1611580587558;
 Mon, 25 Jan 2021 05:16:27 -0800 (PST)
MIME-Version: 1.0
References: <CAJ8uoz0m9VCydXM_=OdwJNg67hY59N+3yrCP=cpPBwoc5f_+Jg@mail.gmail.com>
 <1611578136.5043845-1-xuanzhuo@linux.alibaba.com>
In-Reply-To: <1611578136.5043845-1-xuanzhuo@linux.alibaba.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Mon, 25 Jan 2021 14:16:16 +0100
Message-ID: <CAJ8uoz30r_-6CwZcte0R_9+6BVUFcvMEW4FG-tutBtJn2FD_bw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 3/3] xsk: build skb by page
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Bjorn Topel <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        virtualization@lists.linux-foundation.org,
        bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Alexander Lobakin <alobakin@pm.me>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 25, 2021 at 1:43 PM Xuan Zhuo <xuanzhuo@linux.alibaba.com> wrote:
>
> On Mon, 25 Jan 2021 08:44:38 +0100, Magnus Karlsson <magnus.karlsson@gmail.com> wrote:
> > On Mon, Jan 25, 2021 at 3:27 AM Xuan Zhuo <xuanzhuo@linux.alibaba.com> wrote:
> > >
> > > On Fri, 22 Jan 2021 19:37:06 +0100, Magnus Karlsson <magnus.karlsson@gmail.com> wrote:
> > > > On Fri, Jan 22, 2021 at 6:26 PM Alexander Lobakin <alobakin@pm.me> wrote:
> > > > >
> > > > > From: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> > > > > Date: Fri, 22 Jan 2021 23:39:15 +0800
> > > > >
> > > > > > On Fri, 22 Jan 2021 13:55:14 +0100, Magnus Karlsson <magnus.karlsson@gmail.com> wrote:
> > > > > > > On Fri, Jan 22, 2021 at 1:39 PM Alexander Lobakin <alobakin@pm.me> wrote:
> > > > > > > >
> > > > > > > > From: Magnus Karlsson <magnus.karlsson@gmail.com>
> > > > > > > > Date: Fri, 22 Jan 2021 13:18:47 +0100
> > > > > > > >
> > > > > > > > > On Fri, Jan 22, 2021 at 12:57 PM Alexander Lobakin <alobakin@pm.me> wrote:
> > > > > > > > > >
> > > > > > > > > > From: Alexander Lobakin <alobakin@pm.me>
> > > > > > > > > > Date: Fri, 22 Jan 2021 11:47:45 +0000
> > > > > > > > > >
> > > > > > > > > > > From: Eric Dumazet <eric.dumazet@gmail.com>
> > > > > > > > > > > Date: Thu, 21 Jan 2021 16:41:33 +0100
> > > > > > > > > > >
> > > > > > > > > > > > On 1/21/21 2:47 PM, Xuan Zhuo wrote:
> > > > > > > > > > > > > This patch is used to construct skb based on page to save memory copy
> > > > > > > > > > > > > overhead.
> > > > > > > > > > > > >
> > > > > > > > > > > > > This function is implemented based on IFF_TX_SKB_NO_LINEAR. Only the
> > > > > > > > > > > > > network card priv_flags supports IFF_TX_SKB_NO_LINEAR will use page to
> > > > > > > > > > > > > directly construct skb. If this feature is not supported, it is still
> > > > > > > > > > > > > necessary to copy data to construct skb.
> > > > > > > > > > > > >
> > > > > > > > > > > > > ---------------- Performance Testing ------------
> > > > > > > > > > > > >
> > > > > > > > > > > > > The test environment is Aliyun ECS server.
> > > > > > > > > > > > > Test cmd:
> > > > > > > > > > > > > ```
> > > > > > > > > > > > > xdpsock -i eth0 -t  -S -s <msg size>
> > > > > > > > > > > > > ```
> > > > > > > > > > > > >
> > > > > > > > > > > > > Test result data:
> > > > > > > > > > > > >
> > > > > > > > > > > > > size    64      512     1024    1500
> > > > > > > > > > > > > copy    1916747 1775988 1600203 1440054
> > > > > > > > > > > > > page    1974058 1953655 1945463 1904478
> > > > > > > > > > > > > percent 3.0%    10.0%   21.58%  32.3%
> > > > > > > > > > > > >
> > > > > > > > > > > > > Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> > > > > > > > > > > > > Reviewed-by: Dust Li <dust.li@linux.alibaba.com>
> > > > > > > > > > > > > ---
> > > > > > > > > > > > >  net/xdp/xsk.c | 104 ++++++++++++++++++++++++++++++++++++++++++++++++----------
> > > > > > > > > > > > >  1 file changed, 86 insertions(+), 18 deletions(-)
> > > > > > > > > > > > >
> > > > > > > > > > > > > diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
> > > > > > > > > > > > > index 4a83117..38af7f1 100644
> > > > > > > > > > > > > --- a/net/xdp/xsk.c
> > > > > > > > > > > > > +++ b/net/xdp/xsk.c
> > > > > > > > > > > > > @@ -430,6 +430,87 @@ static void xsk_destruct_skb(struct sk_buff *skb)
> > > > > > > > > > > > >   sock_wfree(skb);
> > > > > > > > > > > > >  }
> > > > > > > > > > > > >
> > > > > > > > > > > > > +static struct sk_buff *xsk_build_skb_zerocopy(struct xdp_sock *xs,
> > > > > > > > > > > > > +                                       struct xdp_desc *desc)
> > > > > > > > > > > > > +{
> > > > > > > > > > > > > + u32 len, offset, copy, copied;
> > > > > > > > > > > > > + struct sk_buff *skb;
> > > > > > > > > > > > > + struct page *page;
> > > > > > > > > > > > > + void *buffer;
> > > > > > > > > > > > > + int err, i;
> > > > > > > > > > > > > + u64 addr;
> > > > > > > > > > > > > +
> > > > > > > > > > > > > + skb = sock_alloc_send_skb(&xs->sk, 0, 1, &err);
> > > > > > > > > > > > > + if (unlikely(!skb))
> > > > > > > > > > > > > +         return ERR_PTR(err);
> > > > > > > > > > > > > +
> > > > > > > > > > > > > + addr = desc->addr;
> > > > > > > > > > > > > + len = desc->len;
> > > > > > > > > > > > > +
> > > > > > > > > > > > > + buffer = xsk_buff_raw_get_data(xs->pool, addr);
> > > > > > > > > > > > > + offset = offset_in_page(buffer);
> > > > > > > > > > > > > + addr = buffer - xs->pool->addrs;
> > > > > > > > > > > > > +
> > > > > > > > > > > > > + for (copied = 0, i = 0; copied < len; i++) {
> > > > > > > > > > > > > +         page = xs->pool->umem->pgs[addr >> PAGE_SHIFT];
> > > > > > > > > > > > > +
> > > > > > > > > > > > > +         get_page(page);
> > > > > > > > > > > > > +
> > > > > > > > > > > > > +         copy = min_t(u32, PAGE_SIZE - offset, len - copied);
> > > > > > > > > > > > > +
> > > > > > > > > > > > > +         skb_fill_page_desc(skb, i, page, offset, copy);
> > > > > > > > > > > > > +
> > > > > > > > > > > > > +         copied += copy;
> > > > > > > > > > > > > +         addr += copy;
> > > > > > > > > > > > > +         offset = 0;
> > > > > > > > > > > > > + }
> > > > > > > > > > > > > +
> > > > > > > > > > > > > + skb->len += len;
> > > > > > > > > > > > > + skb->data_len += len;
> > > > > > > > > > > >
> > > > > > > > > > > > > + skb->truesize += len;
> > > > > > > > > > > >
> > > > > > > > > > > > This is not the truesize, unfortunately.
> > > > > > > > > > > >
> > > > > > > > > > > > We need to account for the number of pages, not number of bytes.
> > > > > > > > > > >
> > > > > > > > > > > The easiest solution is:
> > > > > > > > > > >
> > > > > > > > > > >       skb->truesize += PAGE_SIZE * i;
> > > > > > > > > > >
> > > > > > > > > > > i would be equal to skb_shinfo(skb)->nr_frags after exiting the loop.
> > > > > > > > > >
> > > > > > > > > > Oops, pls ignore this. I forgot that XSK buffers are not
> > > > > > > > > > "one per page".
> > > > > > > > > > We need to count the number of pages manually and then do
> > > > > > > > > >
> > > > > > > > > >         skb->truesize += PAGE_SIZE * npages;
> > > > > > > > > >
> > > > > > > > > > Right.
> > > > > > > > >
> > > > > > > > > There are two possible packet buffer (chunks) sizes in a umem, 2K and
> > > > > > > > > 4K on a system with a PAGE_SIZE of 4K. If I remember correctly, and
> > > > > > > > > please correct me if wrong, truesize is used for memory accounting.
> > > > > > > > > But in this code, no kernel memory has been allocated (apart from the
> > > > > > > > > skb). The page is just a part of the umem that has been already
> > > > > > > > > allocated beforehand and by user-space in this case. So what should
> > > > > > > > > truesize be in this case? Do we add 0, chunk_size * i, or the
> > > > > > > > > complicated case of counting exactly how many 4K pages that are used
> > > > > > > > > when the chunk_size is 2K, as two chunks could occupy the same page,
> > > > > > > > > or just the upper bound of PAGE_SIZE * i that is likely a good
> > > > > > > > > approximation in most cases? Just note that there might be other uses
> > > > > > > > > of truesize that I am unaware of that could impact this choice.
> > > > > > > >
> > > > > > > > Truesize is "what amount of memory does this skb occupy with all its
> > > > > > > > fragments, linear space and struct sk_buff itself". The closest it
> > > > > > > > will be to the actual value, the better.
> > > > > > > > In this case, I think adding of chunk_size * i would be enough.
> > > > > > >
> > > > > > > Sounds like a good approximation to me.
> > > > > > >
> > > > > > > > (PAGE_SIZE * i can be overwhelming when chunk_size is 2K, especially
> > > > > > > > for setups with PAGE_SIZE > SZ_4K)
> > > > > > >
> > > > > > > You are right. That would be quite horrible on a system with a page size of 64K.
> > > > > >
> > > > > > Thank you everyone, I learned it.
> > > > > >
> > > > > > I also think it is appropriate to add a chunk size here, and there is actually
> > > > > > only one chunk here, so it's very simple
> > > > > >
> > > > > >       skb->truesize += xs->pool->chunk_size;
> > > > >
> > > > > umem chunks can't cross page boundaries. So if you're sure that
> > > > > there could be only one chunk, you don't need the loop at all,
> > > > > if I'm not missing anything.
> > > >
> > > > In the default mode, this is true. But in the unaligned_chunk mode
> > > > that can be set on the umem, the chunk may cross one page boundary, so
> > > > we need the loop and the chunk_size * i in the assignment of truesize.
> > > > So "i" can be 1 or 2, but nothing else.
> > >
> > > According to my understanding, in the unaligned mode, a desc will also refer to
> > > a chunk, although the chunk here may occupy multiple pages. And here is just a
> > > desc constructed into a skb, skb takes the largest amount from umem is a
> > > chunk, so what is the situation of i = 2 here? Did I miss something?
> >
> > A desc refers to a single packet, not a single chunk. One packet can
> > occupy either one or two chunks in the unaligned mode and when this
> > happens to be two, these two chunks might be on different pages. In
> > this case, you will go through the loop twice and produce two
> > fragments.
> >
> > In the aligned mode, every packet starts at the beginning of each
> > chunk (if there is no headroom) and can only occupy a single chunk
> > since no packet can be larger than the chunk size. In the unaligned
> > mode, the packet can start anywhere within the chunk and might even
> > continue into the next chunk, but never more than that since the max
> > packet size is still the chunk size. Why unaligned mode? This provides
> > the user-space with complete freedom on how to optimize the placement
> > of the packets in the umem and this might lead to better overall
> > performance. Note that if we just look at the kernel part, unaligned
> > mode is slower than aligned, but that might not be true on the overall
> > level.
>
> Thank you very much, very detailed explanation.
>
> I have a question: You said that in the case of unaligned mode, the packet
> pointed by desc may use two consecutive chunks at the same time. How do we
> ensure that we can apply for two consecutive chunks?

I am not sure I understand "apply for", sorry. But in unaligned mode,
we reject any desc that spans two chunks that are not physically
consecutive in memory. So users of unaligned mode usually use huge
pages to make sure that this happens rarely and that these "breaks"
are well known to the entity in user-space that places the packets in
the umem (i.e., do not create packets that cross huge page boundaries
would suffice).

> Back to this patch, is it okay to deal with it this way?
>
>         buffer = xsk_buff_raw_get_data(xs->pool, addr);
>
>         .....
>
>         if (pool->unaligned) {
>                 u64 l;
>
>                 l = (buffer - xs->pool->addrs) % xs->pool->chunk_size;
>                 if (xs->pool->chunk_size - l < desc->len)
>                         skb->truesize += xs->pool->chunk_size * 2;
>                 else
>                         skb->truesize += xs->pool->chunk_size;
>         } else {
>                 skb->truesize += xs->pool->chunk_size;
>         }

Why would not skb->truesize += xs->pool->chunk_size * i; work in both
cases? The copy = min_t(u32, PAGE_SIZE - offset, len - copied);
statement together with the loop itself should take care of the case
when the packet spans two pages as PAGE_SIZE - offset < len it will
loop again and copy the rest. In that case, i == 2 when you exit the
loop.

But it would be great if you could test that your code can deal with
this. How about extending the xsk selftests with a case for unaligned
mode? Should be quite straightforward. Just make sure you put the
packets next to each other so that some of them will cross page
boundaries.

> Thanks.
>
> >
> > > Thanks.
> > >
> > > >
> > > > > > In addition, I actually borrowed from the tcp code:
> > > > > >
> > > > > >    tcp_build_frag:
> > > > > >    --------------
> > > > > >
> > > > > >       if (can_coalesce) {
> > > > > >               skb_frag_size_add(&skb_shinfo(skb)->frags[i - 1], copy);
> > > > > >       } else {
> > > > > >               get_page(page);
> > > > > >               skb_fill_page_desc(skb, i, page, offset, copy);
> > > > > >       }
> > > > > >
> > > > > >       if (!(flags & MSG_NO_SHARED_FRAGS))
> > > > > >               skb_shinfo(skb)->flags |= SKBFL_SHARED_FRAG;
> > > > > >
> > > > > >       skb->len += copy;
> > > > > >       skb->data_len += copy;
> > > > > >       skb->truesize += copy;
> > > > > >
> > > > > > So, here is one bug?
> > > > >
> > > > > skb_frag_t is an alias to struct bvec. It doesn't contain info about
> > > > > real memory consumption, so there's no other option buf just to add
> > > > > "copy" to truesize.
> > > > > XSK is different in this term, as it operates with chunks of a known
> > > > > size.
> > > > >
> > > > > > Thanks.
> > > > > >
> > > > > > >
> > > > > > > > > > > > > +
> > > > > > > > > > > > > + refcount_add(len, &xs->sk.sk_wmem_alloc);
> > > > > > > > > > > > > +
> > > > > > > > > > > > > + return skb;
> > > > > > > > > > > > > +}
> > > > > > > > > > > > > +
> > > > > > > > > > >
> > > > > > > > > > > Al
> > > > > > > > > >
> > > > > > > > > > Thanks,
> > > > > > > > > > Al
> > > > > > > >
> > > > > > > > Al
> > > > >
