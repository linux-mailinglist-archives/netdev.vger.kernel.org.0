Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE7692FB251
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 08:04:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730650AbhASHDZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 02:03:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726732AbhASHCs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jan 2021 02:02:48 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D78C6C061573;
        Mon, 18 Jan 2021 23:02:07 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id l23so11555378pjg.1;
        Mon, 18 Jan 2021 23:02:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TIc7c5GWc8TMQgXXCQmHWxiMIwjw2V9egm0BAWi+jAI=;
        b=D8Gy7/nCaCw6Ti235QPrOnJEG3xRAkgc7XQE7emw4zbf9GLIlo1D43FtEaPnNGpYMS
         A+OmLf/Qa/4TUQ5rGzAfjwtPxMu8hjzIqcZBczAt3jtP+WMEpvvyDkyrVr/a/gDc+76x
         /9YgJ2B4C+peVJJIqUpdsvOCH987ctlYpVhqnox4qiX2i0DSPB4dm7lmQXOX7rHro7tJ
         FnUEwSIqs8SSPzsARDxcz5CWRZARzPYzDEuX3vCgpztYv5zuPdf7RtMPx2lEidJOhwmy
         783D6gzVl1craryf3Hg3TUoW3jAx3+S2n4EzGjI+We42QVsDdwi1yk5EyitkTxz7dk/B
         igDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TIc7c5GWc8TMQgXXCQmHWxiMIwjw2V9egm0BAWi+jAI=;
        b=MckhvDMuxFOOGSz1olJEiHOcwRWzKCUxGGzM+Hz2xGRQ8z8e3vPHcXdLTj6w441yYT
         guplTbLK1j+rjOgett5l0Ja46qLG98O6Xa2uPBFgZeRqLWLDkzOKiNIvz/eux9h1BUnX
         ySmEa2rbxp7MzmtPSckA4x5laV65kI/GndsjIz2Z86dS54/66LKgBXUQwBclDLc85cCm
         B8XJxH7Dd47aKck3Mi14gzuyv2W0dTJ7VbH5cRTfdy0K1R+beCMc7XCq5JNCi+ePOa7O
         jT1rxBKJxjcN1u7fNB/7zx3hDYXFwm7VOOiWim8JpqXPBIlgeosoYKtWXV/nl18Mhyy9
         mmjg==
X-Gm-Message-State: AOAM530oDAtnFnoAjicvMbLQWGAnHgZd9lkxUMfZ8ngBCok6NVqYknUA
        xJ0RcQK92jmRBVwLEXaVgC/9yGzSVgrfjJjuWeI=
X-Google-Smtp-Source: ABdhPJwaJJfd0PwNp23gb4H7fnNbI2SgSJvYZ1IG02rgvWBJNZip/HDlyVzecoLuSdgeG6lUsif8IJMGz6KpybU6qgc=
X-Received: by 2002:a17:902:7c04:b029:dc:99f2:eea4 with SMTP id
 x4-20020a1709027c04b02900dc99f2eea4mr3057875pll.43.1611039727315; Mon, 18 Jan
 2021 23:02:07 -0800 (PST)
MIME-Version: 1.0
References: <579fa463bba42ac71591540a1811dca41d725350.1610764948.git.xuanzhuo@linux.alibaba.com>
 <4a4b475b-0e79-6cf6-44f5-44d45b5d85b5@huawei.com> <20210118125937.4088-1-alobakin@pm.me>
 <20210118143948.8706-1-alobakin@pm.me> <CAJ8uoz0tZNrB+g0Mw_K4n=VhQ36b6AHyZWM3TkkLBCxo_N1iRg@mail.gmail.com>
 <20210118163742.10364-1-alobakin@pm.me>
In-Reply-To: <20210118163742.10364-1-alobakin@pm.me>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Tue, 19 Jan 2021 08:01:56 +0100
Message-ID: <CAJ8uoz1VrQBPZxt-yZSzVT12OfKE4C3MvW6E=B5gvsbmDzyOxA@mail.gmail.com>
Subject: Re: [PATCH bpf-next] xsk: build skb by page
To:     Alexander Lobakin <alobakin@pm.me>
Cc:     Yunsheng Lin <linyunsheng@huawei.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
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
        Willem de Bruijn <willemb@google.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Antoine Tenart <atenart@kernel.org>,
        Michal Kubecek <mkubecek@suse.cz>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Meir Lichtinger <meirl@mellanox.com>,
        virtualization@lists.linux-foundation.org,
        bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 18, 2021 at 5:38 PM Alexander Lobakin <alobakin@pm.me> wrote:
>
> > From: Magnus Karlsson <magnus.karlsson@gmail.com>
> > Date: Mon, 18 Jan 2021 16:10:40 +0100
> >
> > On Mon, Jan 18, 2021 at 3:47 PM Alexander Lobakin <alobakin@pm.me> wrote:
> > >
> > > From: Alexander Lobakin <alobakin@pm.me>
> > > Date: Mon, 18 Jan 2021 13:00:17 +0000
> > >
> > > > From: Yunsheng Lin <linyunsheng@huawei.com>
> > > > Date: Mon, 18 Jan 2021 20:40:52 +0800
> > > >
> > > >> On 2021/1/16 10:44, Xuan Zhuo wrote:
> > > >>> This patch is used to construct skb based on page to save memory copy
> > > >>> overhead.
> > > >>>
> > > >>> This has one problem:
> > > >>>
> > > >>> We construct the skb by fill the data page as a frag into the skb. In
> > > >>> this way, the linear space is empty, and the header information is also
> > > >>> in the frag, not in the linear space, which is not allowed for some
> > > >>> network cards. For example, Mellanox Technologies MT27710 Family
> > > >>> [ConnectX-4 Lx] will get the following error message:
> > > >>>
> > > >>>     mlx5_core 0000:3b:00.1 eth1: Error cqe on cqn 0x817, ci 0x8, qn 0x1dbb, opcode 0xd, syndrome 0x1, vendor syndrome 0x68
> > > >>>     00000000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> > > >>>     00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> > > >>>     00000020: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> > > >>>     00000030: 00 00 00 00 60 10 68 01 0a 00 1d bb 00 0f 9f d2
> > > >>>     WQE DUMP: WQ size 1024 WQ cur size 0, WQE index 0xf, len: 64
> > > >>>     00000000: 00 00 0f 0a 00 1d bb 03 00 00 00 08 00 00 00 00
> > > >>>     00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> > > >>>     00000020: 00 00 00 2b 00 08 00 00 00 00 00 05 9e e3 08 00
> > > >>>     00000030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> > > >>>     mlx5_core 0000:3b:00.1 eth1: ERR CQE on SQ: 0x1dbb
> > > >>>
> > > >>> I also tried to use build_skb to construct skb, but because of the
> > > >>> existence of skb_shinfo, it must be behind the linear space, so this
> > > >>> method is not working. We can't put skb_shinfo on desc->addr, it will be
> > > >>> exposed to users, this is not safe.
> > > >>>
> > > >>> Finally, I added a feature NETIF_F_SKB_NO_LINEAR to identify whether the
> > > >>
> > > >> Does it make sense to use ETHTOOL_TX_COPYBREAK tunable in ethtool to
> > > >> configure if the data is copied or not?
> > > >
> > > > As far as I can grep, only mlx4 supports this, and it has a different
> > > > meaning in that driver.
> > > > So I guess a new netdev_feature would be a better solution.
> > > >
> > > >>> network card supports the header information of the packet in the frag
> > > >>> and not in the linear space.
> > > >>>
> > > >>> ---------------- Performance Testing ------------
> > > >>>
> > > >>> The test environment is Aliyun ECS server.
> > > >>> Test cmd:
> > > >>> ```
> > > >>> xdpsock -i eth0 -t  -S -s <msg size>
> > > >>> ```
> > > >>>
> > > >>> Test result data:
> > > >>>
> > > >>> size    64      512     1024    1500
> > > >>> copy    1916747 1775988 1600203 1440054
> > > >>> page    1974058 1953655 1945463 1904478
> > > >>> percent 3.0%    10.0%   21.58%  32.3%
> > > >>>
> > > >>> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> > > >>> Reviewed-by: Dust Li <dust.li@linux.alibaba.com>
> > > >>> ---
> > > >>>  drivers/net/virtio_net.c        |   2 +-
> > > >>>  include/linux/netdev_features.h |   5 +-
> > > >>>  net/ethtool/common.c            |   1 +
> > > >>>  net/xdp/xsk.c                   | 108 +++++++++++++++++++++++++++++++++-------
> > > >>>  4 files changed, 97 insertions(+), 19 deletions(-)
> > > >>>
> > > >>> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > > >>> index 4ecccb8..841a331 100644
> > > >>> --- a/drivers/net/virtio_net.c
> > > >>> +++ b/drivers/net/virtio_net.c
> > > >>> @@ -2985,7 +2985,7 @@ static int virtnet_probe(struct virtio_device *vdev)
> > > >>>     /* Set up network device as normal. */
> > > >>>     dev->priv_flags |= IFF_UNICAST_FLT | IFF_LIVE_ADDR_CHANGE;
> > > >>>     dev->netdev_ops = &virtnet_netdev;
> > > >>> -   dev->features = NETIF_F_HIGHDMA;
> > > >>> +   dev->features = NETIF_F_HIGHDMA | NETIF_F_SKB_NO_LINEAR;
> > > >>>
> > > >>>     dev->ethtool_ops = &virtnet_ethtool_ops;
> > > >>>     SET_NETDEV_DEV(dev, &vdev->dev);
> > > >>> diff --git a/include/linux/netdev_features.h b/include/linux/netdev_features.h
> > > >>> index 934de56..8dd28e2 100644
> > > >>> --- a/include/linux/netdev_features.h
> > > >>> +++ b/include/linux/netdev_features.h
> > > >>> @@ -85,9 +85,11 @@ enum {
> > > >>>
> > > >>>     NETIF_F_HW_MACSEC_BIT,          /* Offload MACsec operations */
> > > >>>
> > > >>> +   NETIF_F_SKB_NO_LINEAR_BIT,      /* Allow skb linear is empty */
> > > >>> +
> > > >>>     /*
> > > >>>      * Add your fresh new feature above and remember to update
> > > >>> -    * netdev_features_strings[] in net/core/ethtool.c and maybe
> > > >>> +    * netdev_features_strings[] in net/ethtool/common.c and maybe
> > > >>>      * some feature mask #defines below. Please also describe it
> > > >>>      * in Documentation/networking/netdev-features.rst.
> > > >>>      */
> > > >>> @@ -157,6 +159,7 @@ enum {
> > > >>>  #define NETIF_F_GRO_FRAGLIST       __NETIF_F(GRO_FRAGLIST)
> > > >>>  #define NETIF_F_GSO_FRAGLIST       __NETIF_F(GSO_FRAGLIST)
> > > >>>  #define NETIF_F_HW_MACSEC  __NETIF_F(HW_MACSEC)
> > > >>> +#define NETIF_F_SKB_NO_LINEAR      __NETIF_F(SKB_NO_LINEAR)
> > > >>>
> > > >>>  /* Finds the next feature with the highest number of the range of start till 0.
> > > >>>   */
> > > >>> diff --git a/net/ethtool/common.c b/net/ethtool/common.c
> > > >>> index 24036e3..2f3d309 100644
> > > >>> --- a/net/ethtool/common.c
> > > >>> +++ b/net/ethtool/common.c
> > > >>> @@ -68,6 +68,7 @@
> > > >>>     [NETIF_F_HW_TLS_RX_BIT] =        "tls-hw-rx-offload",
> > > >>>     [NETIF_F_GRO_FRAGLIST_BIT] =     "rx-gro-list",
> > > >>>     [NETIF_F_HW_MACSEC_BIT] =        "macsec-hw-offload",
> > > >>> +   [NETIF_F_SKB_NO_LINEAR_BIT] =    "skb-no-linear",
> > > >
> > > > I completely forgot to add that you'd better to mention in both
> > > > enumeration/feature and its Ethtool string that the feature applies
> > > > to Tx path.
> > > > Smth like:
> > > >
> > > > NETIF_F_SKB_TX_NO_LINEAR{,_BIT}, "skb-tx-no-linear"
> > > > or
> > > > NETIF_F_TX_SKB_NO_LINEAR{,_BIT}, "tx-skb-no-linear"
> > > >
> > > > Otherwise, it may be confusing for users and developers.
> >
> > I prefer one of these names for the property as they clearly describe
> > a feature that the driver supports.
> >
> > > OR, I think we may tight the feature with the new approach to build
> > > skbs by page as it makes no sense for anything else.
> > > So, if we define something like:
> > >
> > > NETIF_F_XSK_TX_GENERIC_ZC{,_BIT}, "xsk-tx-generic-zerocopy",
> >
> > This one I misunderstood first. I thought: "this is not zerocopy", but
> > you are right it is. It is zero-copy implemented with skb:s. But in my
> > mind, the NO_LINEAR version that you suggested are clearer.
> >
> > > then user can toggle your new XSK Tx path on/off via Ethtool for
> > > drivers that will support it (don't forget to add it to hw_features
> > > for virtio_net then).
>
> User don't need to enable manually this, drivers usually enable most
> of their features on netdevice creation. This way we just could have
> an option to turn it off.
>
> If the feature is not about to be exposed to user at all, only to
> indicate if a particular driver supports skbs with skb_headlen == 0
> on its .ndo_start_xmit() path, then it might be better to introduce
> a private flag (netdev_priv_flags) instead of netdev_feature. Private
> flags are kernel-only and can't be toggled on/off after netdev is
> registered.
> E.g.
>
> IFF_TX_SKB_NO_LINEAR
>
> and test it like
>
> if (dev->priv_flags & IFF_TX_SKB_NO_LINEAR) {
>         /* new generic zerocopy path */
> } else {
>         /* current code */
> }
>

This sounds like a good idea. I would go with this. Thank you Alexander!

> > > >>>  };
> > > >>>
> > > >>>  const char
> > > >>> diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
> > > >>> index 8037b04..94d17dc 100644
> > > >>> --- a/net/xdp/xsk.c
> > > >>> +++ b/net/xdp/xsk.c
> > > >>> @@ -430,6 +430,95 @@ static void xsk_destruct_skb(struct sk_buff *skb)
> > > >>>     sock_wfree(skb);
> > > >>>  }
> > > >>>
> > > >>> +static struct sk_buff *xsk_build_skb_zerocopy(struct xdp_sock *xs,
> > > >>> +                                         struct xdp_desc *desc)
> > > >>> +{
> > > >>> +   u32 len, offset, copy, copied;
> > > >>> +   struct sk_buff *skb;
> > > >>> +   struct page *page;
> > > >>> +   char *buffer;
> > > >>> +   int err, i;
> > > >>> +   u64 addr;
> > > >>> +
> > > >>> +   skb = sock_alloc_send_skb(&xs->sk, 0, 1, &err);
> > > >>> +   if (unlikely(!skb))
> > > >>> +           return NULL;
> > > >>> +
> > > >>> +   addr = desc->addr;
> > > >>> +   len = desc->len;
> > > >>> +
> > > >>> +   buffer = xsk_buff_raw_get_data(xs->pool, addr);
> > > >>> +   offset = offset_in_page(buffer);
> > > >>> +   addr = buffer - (char *)xs->pool->addrs;
> > > >>> +
> > > >>> +   for (copied = 0, i = 0; copied < len; ++i) {
> > > >>> +           page = xs->pool->umem->pgs[addr >> PAGE_SHIFT];
> > > >>> +
> > > >>> +           get_page(page);
> > > >>> +
> > > >>> +           copy = min((u32)(PAGE_SIZE - offset), len - copied);
> > > >>> +
> > > >>> +           skb_fill_page_desc(skb, i, page, offset, copy);
> > > >>> +
> > > >>> +           copied += copy;
> > > >>> +           addr += copy;
> > > >>> +           offset = 0;
> > > >>> +   }
> > > >>> +
> > > >>> +   skb->len += len;
> > > >>> +   skb->data_len += len;
> > > >>> +   skb->truesize += len;
> > > >>> +
> > > >>> +   refcount_add(len, &xs->sk.sk_wmem_alloc);
> > > >>> +
> > > >>> +   return skb;
> > > >>> +}
> > > >>> +
> > > >>> +static struct sk_buff *xsk_build_skb(struct xdp_sock *xs,
> > > >>> +                                struct xdp_desc *desc, int *err)
> > > >>> +{
> > > >>> +   struct sk_buff *skb;
> > > >>> +
> > > >>> +   if (xs->dev->features & NETIF_F_SKB_NO_LINEAR) {
> > > >>> +           skb = xsk_build_skb_zerocopy(xs, desc);
> > > >>> +           if (unlikely(!skb)) {
> > > >>> +                   *err = -ENOMEM;
> > > >>> +                   return NULL;
> > > >>> +           }
> > > >>> +   } else {
> > > >>> +           char *buffer;
> > > >>> +           u64 addr;
> > > >>> +           u32 len;
> > > >>> +           int err;
> > > >>> +
> > > >>> +           len = desc->len;
> > > >>> +           skb = sock_alloc_send_skb(&xs->sk, len, 1, &err);
> > > >>> +           if (unlikely(!skb)) {
> > > >>> +                   *err = -ENOMEM;
> > > >>> +                   return NULL;
> > > >>> +           }
> > > >>> +
> > > >>> +           skb_put(skb, len);
> > > >>> +           addr = desc->addr;
> > > >>> +           buffer = xsk_buff_raw_get_data(xs->pool, desc->addr);
> > > >>> +           err = skb_store_bits(skb, 0, buffer, len);
> > > >>> +
> > > >>> +           if (unlikely(err)) {
> > > >>> +                   kfree_skb(skb);
> > > >>> +                   *err = -EINVAL;
> > > >>> +                   return NULL;
> > > >>> +           }
> > > >>> +   }
> > > >>> +
> > > >>> +   skb->dev = xs->dev;
> > > >>> +   skb->priority = xs->sk.sk_priority;
> > > >>> +   skb->mark = xs->sk.sk_mark;
> > > >>> +   skb_shinfo(skb)->destructor_arg = (void *)(long)desc->addr;
> > > >>> +   skb->destructor = xsk_destruct_skb;
> > > >>> +
> > > >>> +   return skb;
> > > >>> +}
> > > >>> +
> > > >>>  static int xsk_generic_xmit(struct sock *sk)
> > > >>>  {
> > > >>>     struct xdp_sock *xs = xdp_sk(sk);
> > > >>> @@ -446,43 +535,28 @@ static int xsk_generic_xmit(struct sock *sk)
> > > >>>             goto out;
> > > >>>
> > > >>>     while (xskq_cons_peek_desc(xs->tx, &desc, xs->pool)) {
> > > >>> -           char *buffer;
> > > >>> -           u64 addr;
> > > >>> -           u32 len;
> > > >>> -
> > > >>>             if (max_batch-- == 0) {
> > > >>>                     err = -EAGAIN;
> > > >>>                     goto out;
> > > >>>             }
> > > >>>
> > > >>> -           len = desc.len;
> > > >>> -           skb = sock_alloc_send_skb(sk, len, 1, &err);
> > > >>> +           skb = xsk_build_skb(xs, &desc, &err);
> > > >>>             if (unlikely(!skb))
> > > >>>                     goto out;
> > > >>>
> > > >>> -           skb_put(skb, len);
> > > >>> -           addr = desc.addr;
> > > >>> -           buffer = xsk_buff_raw_get_data(xs->pool, addr);
> > > >>> -           err = skb_store_bits(skb, 0, buffer, len);
> > > >>>             /* This is the backpressure mechanism for the Tx path.
> > > >>>              * Reserve space in the completion queue and only proceed
> > > >>>              * if there is space in it. This avoids having to implement
> > > >>>              * any buffering in the Tx path.
> > > >>>              */
> > > >>>             spin_lock_irqsave(&xs->pool->cq_lock, flags);
> > > >>> -           if (unlikely(err) || xskq_prod_reserve(xs->pool->cq)) {
> > > >>> +           if (xskq_prod_reserve(xs->pool->cq)) {
> > > >>>                     spin_unlock_irqrestore(&xs->pool->cq_lock, flags);
> > > >>>                     kfree_skb(skb);
> > > >>>                     goto out;
> > > >>>             }
> > > >>>             spin_unlock_irqrestore(&xs->pool->cq_lock, flags);
> > > >>>
> > > >>> -           skb->dev = xs->dev;
> > > >>> -           skb->priority = sk->sk_priority;
> > > >>> -           skb->mark = sk->sk_mark;
> > > >>> -           skb_shinfo(skb)->destructor_arg = (void *)(long)desc.addr;
> > > >>> -           skb->destructor = xsk_destruct_skb;
> > > >>> -
> > > >>>             err = __dev_direct_xmit(skb, xs->queue_id);
> > > >>>             if  (err == NETDEV_TX_BUSY) {
> > > >>>                     /* Tell user-space to retry the send */
> > > >>>
> > > >
> > > > Al
> > >
> > > Al
> >
>
> Al
>
