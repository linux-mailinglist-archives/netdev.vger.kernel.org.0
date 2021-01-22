Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6799130038C
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 13:57:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727354AbhAVM4I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 07:56:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726900AbhAVM4G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jan 2021 07:56:06 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDCE0C0613D6;
        Fri, 22 Jan 2021 04:55:25 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id u11so3103377plg.13;
        Fri, 22 Jan 2021 04:55:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+hdkdzhBLRYgvWLyAgaaAF1+dexomSUfv4h9wGuekbc=;
        b=tMV/YSv1dbJYrEpAOaynp5dVr1c8ueO2IIrqtQcGDG9BWEx4DG5STuNJWMatx7zHi5
         L9bilSa+SvFBsYb4wp9oZL6Zqq67IX3HCeXwB1NtZAdzF4SeZZzmKKlx2TeYuFXH869s
         NRZfa6DX/ywvSxXEZHOLqh5QDEQe3YO6rgRXHqJIUf+8h3LhPuv6tAl4Qbj+BQ5Xftwa
         PYc/1Qczo5z6+b4NCvnFcXoj5IcCPCiakSTJVTRzjry26TZASmlZ0aaH6tTiuAyqhe3n
         2wV6DVJwEhd1zQzqmy8iqw1N6BPgXzhYDCsTdV7qMiXKNQ7ougUvYjFzbs6SaZyN77h/
         hqaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+hdkdzhBLRYgvWLyAgaaAF1+dexomSUfv4h9wGuekbc=;
        b=Mr/dPJHM/z5ukssj6cVU6eXp4OLxt/9V8M+aXgUsrPm1ywxWOkSMB26e0c4/zwiCzZ
         CRFnGm6Tv4DitJ3f/YC3rgm3AKO0luSbCyTFjgf9iTkAC1D0HcqUT+BGKZKy5iVwi6wL
         95AusTWRMLVc8IYv83szo4bzT2brwzlGR9MtAdIb9rbtd6dpkbcvEXdKiuGRWR0S7iCv
         e4g4gYUebDLdgzM9iH2EB033VzMqqJbdHfaBmw4c/iEsOq5OCdEbR6SqZcNjqCPvZHMv
         4pV7aR12d+tijUwbQgh6vQZ4aTKyPfFp/YnyfmDTJgEZY9Yfm2B61UZkl5oKaFWzO+wI
         0SDA==
X-Gm-Message-State: AOAM530P1IGCNX3abI8PC/82iB6V62EoOYcUvLICRb/qiKmgSMRSe1Vb
        297xXIlJUYXW4uVmrmrKJ6zOATG62y0sYbdq4/Q=
X-Google-Smtp-Source: ABdhPJyOekGA0LTNcRJjA2yeAIY9CqxHGGM13WOOAvnMcVkaKCdDGsGKzeBmxKPyWKCdJpUJfseyHlMFXlYcwvO8gRE=
X-Received: by 2002:a17:90a:14e2:: with SMTP id k89mr5085872pja.168.1611320125462;
 Fri, 22 Jan 2021 04:55:25 -0800 (PST)
MIME-Version: 1.0
References: <cover.1611236588.git.xuanzhuo@linux.alibaba.com>
 <340f1dfa40416dd966a56e08507daba82d633088.1611236588.git.xuanzhuo@linux.alibaba.com>
 <dcee4592-9fa9-adbb-55ca-58a962076e7a@gmail.com> <20210122114729.1758-1-alobakin@pm.me>
 <20210122115519.2183-1-alobakin@pm.me> <CAJ8uoz0ve9iRmz6zkCTaBMMjckFrD0df43-uVreXVf_wM3mZ1A@mail.gmail.com>
 <20210122123909.3603-1-alobakin@pm.me>
In-Reply-To: <20210122123909.3603-1-alobakin@pm.me>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Fri, 22 Jan 2021 13:55:14 +0100
Message-ID: <CAJ8uoz0uW6DbXrKLNYAQf3UU1foCD6tyHf0tgEyJko0mk14bqw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 3/3] xsk: build skb by page
To:     Alexander Lobakin <alobakin@pm.me>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
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
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 22, 2021 at 1:39 PM Alexander Lobakin <alobakin@pm.me> wrote:
>
> From: Magnus Karlsson <magnus.karlsson@gmail.com>
> Date: Fri, 22 Jan 2021 13:18:47 +0100
>
> > On Fri, Jan 22, 2021 at 12:57 PM Alexander Lobakin <alobakin@pm.me> wrote:
> > >
> > > From: Alexander Lobakin <alobakin@pm.me>
> > > Date: Fri, 22 Jan 2021 11:47:45 +0000
> > >
> > > > From: Eric Dumazet <eric.dumazet@gmail.com>
> > > > Date: Thu, 21 Jan 2021 16:41:33 +0100
> > > >
> > > > > On 1/21/21 2:47 PM, Xuan Zhuo wrote:
> > > > > > This patch is used to construct skb based on page to save memory copy
> > > > > > overhead.
> > > > > >
> > > > > > This function is implemented based on IFF_TX_SKB_NO_LINEAR. Only the
> > > > > > network card priv_flags supports IFF_TX_SKB_NO_LINEAR will use page to
> > > > > > directly construct skb. If this feature is not supported, it is still
> > > > > > necessary to copy data to construct skb.
> > > > > >
> > > > > > ---------------- Performance Testing ------------
> > > > > >
> > > > > > The test environment is Aliyun ECS server.
> > > > > > Test cmd:
> > > > > > ```
> > > > > > xdpsock -i eth0 -t  -S -s <msg size>
> > > > > > ```
> > > > > >
> > > > > > Test result data:
> > > > > >
> > > > > > size    64      512     1024    1500
> > > > > > copy    1916747 1775988 1600203 1440054
> > > > > > page    1974058 1953655 1945463 1904478
> > > > > > percent 3.0%    10.0%   21.58%  32.3%
> > > > > >
> > > > > > Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> > > > > > Reviewed-by: Dust Li <dust.li@linux.alibaba.com>
> > > > > > ---
> > > > > >  net/xdp/xsk.c | 104 ++++++++++++++++++++++++++++++++++++++++++++++++----------
> > > > > >  1 file changed, 86 insertions(+), 18 deletions(-)
> > > > > >
> > > > > > diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
> > > > > > index 4a83117..38af7f1 100644
> > > > > > --- a/net/xdp/xsk.c
> > > > > > +++ b/net/xdp/xsk.c
> > > > > > @@ -430,6 +430,87 @@ static void xsk_destruct_skb(struct sk_buff *skb)
> > > > > >   sock_wfree(skb);
> > > > > >  }
> > > > > >
> > > > > > +static struct sk_buff *xsk_build_skb_zerocopy(struct xdp_sock *xs,
> > > > > > +                                       struct xdp_desc *desc)
> > > > > > +{
> > > > > > + u32 len, offset, copy, copied;
> > > > > > + struct sk_buff *skb;
> > > > > > + struct page *page;
> > > > > > + void *buffer;
> > > > > > + int err, i;
> > > > > > + u64 addr;
> > > > > > +
> > > > > > + skb = sock_alloc_send_skb(&xs->sk, 0, 1, &err);
> > > > > > + if (unlikely(!skb))
> > > > > > +         return ERR_PTR(err);
> > > > > > +
> > > > > > + addr = desc->addr;
> > > > > > + len = desc->len;
> > > > > > +
> > > > > > + buffer = xsk_buff_raw_get_data(xs->pool, addr);
> > > > > > + offset = offset_in_page(buffer);
> > > > > > + addr = buffer - xs->pool->addrs;
> > > > > > +
> > > > > > + for (copied = 0, i = 0; copied < len; i++) {
> > > > > > +         page = xs->pool->umem->pgs[addr >> PAGE_SHIFT];
> > > > > > +
> > > > > > +         get_page(page);
> > > > > > +
> > > > > > +         copy = min_t(u32, PAGE_SIZE - offset, len - copied);
> > > > > > +
> > > > > > +         skb_fill_page_desc(skb, i, page, offset, copy);
> > > > > > +
> > > > > > +         copied += copy;
> > > > > > +         addr += copy;
> > > > > > +         offset = 0;
> > > > > > + }
> > > > > > +
> > > > > > + skb->len += len;
> > > > > > + skb->data_len += len;
> > > > >
> > > > > > + skb->truesize += len;
> > > > >
> > > > > This is not the truesize, unfortunately.
> > > > >
> > > > > We need to account for the number of pages, not number of bytes.
> > > >
> > > > The easiest solution is:
> > > >
> > > >       skb->truesize += PAGE_SIZE * i;
> > > >
> > > > i would be equal to skb_shinfo(skb)->nr_frags after exiting the loop.
> > >
> > > Oops, pls ignore this. I forgot that XSK buffers are not
> > > "one per page".
> > > We need to count the number of pages manually and then do
> > >
> > >         skb->truesize += PAGE_SIZE * npages;
> > >
> > > Right.
> >
> > There are two possible packet buffer (chunks) sizes in a umem, 2K and
> > 4K on a system with a PAGE_SIZE of 4K. If I remember correctly, and
> > please correct me if wrong, truesize is used for memory accounting.
> > But in this code, no kernel memory has been allocated (apart from the
> > skb). The page is just a part of the umem that has been already
> > allocated beforehand and by user-space in this case. So what should
> > truesize be in this case? Do we add 0, chunk_size * i, or the
> > complicated case of counting exactly how many 4K pages that are used
> > when the chunk_size is 2K, as two chunks could occupy the same page,
> > or just the upper bound of PAGE_SIZE * i that is likely a good
> > approximation in most cases? Just note that there might be other uses
> > of truesize that I am unaware of that could impact this choice.
>
> Truesize is "what amount of memory does this skb occupy with all its
> fragments, linear space and struct sk_buff itself". The closest it
> will be to the actual value, the better.
> In this case, I think adding of chunk_size * i would be enough.

Sounds like a good approximation to me.

> (PAGE_SIZE * i can be overwhelming when chunk_size is 2K, especially
> for setups with PAGE_SIZE > SZ_4K)

You are right. That would be quite horrible on a system with a page size of 64K.

> > > > > > +
> > > > > > + refcount_add(len, &xs->sk.sk_wmem_alloc);
> > > > > > +
> > > > > > + return skb;
> > > > > > +}
> > > > > > +
> > > >
> > > > Al
> > >
> > > Thanks,
> > > Al
>
> Al
>
