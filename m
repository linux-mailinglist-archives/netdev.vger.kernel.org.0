Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDDF84A8816
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 16:54:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352017AbiBCPy5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 10:54:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234764AbiBCPyz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 10:54:55 -0500
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCD1BC061714
        for <netdev@vger.kernel.org>; Thu,  3 Feb 2022 07:54:55 -0800 (PST)
Received: by mail-yb1-xb29.google.com with SMTP id k31so10314074ybj.4
        for <netdev@vger.kernel.org>; Thu, 03 Feb 2022 07:54:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1/zndhiklfKG0t/ZDXjE2ZoLaeoChLyvs7k3K28Zt40=;
        b=RJTL2MEKOa8lFfID/aTqZI428JHoOL4kZW7nAkEhPtru5mcOMrv+rXnl4rPZooDhdu
         sYnJS9N016mbB6gMQBVZyRp5znmX5wh1D4BF38rcgwZf3d32x+K7pTTjWoawGMs6DEiC
         gznPN4pyyGs0HT5hCGjXaeIfN4JgOvFVftPiKu9gWAss2fm3wjDukRE29JiG6GpA6q6a
         XMP9vCtNNIYJSpoSCKfi2FdACQEFhoh2qEaDWXswLPCouXFgHWsGiG5NdGZTsX7UbEY+
         d+GbPoT+04CKa1w0gN6LHBMd01feOnnUGC/StjMWTbgBoCKxQ7ZuvO/VRjBpVhbzwLkn
         Pvuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1/zndhiklfKG0t/ZDXjE2ZoLaeoChLyvs7k3K28Zt40=;
        b=NKp9sw4nYsRpDRzRuy8l6TxmD3wwrzPCsxkmLD/NSDrQOz2bxCn0jib0EWQqIXJnh2
         kzaN2RtXIBhTQ13/RswYUVHFxMskWJvdyN73L6SM7O0bf0i3vjLQQPgBpbKoU5bP7Ifo
         hW77x4xWxEm1Tr4pQgQZ37eTlTqvSaUOEreSMsTFHSVzakylIOazzWi52NHUzJBVI1kO
         zXfSzZChks6kZ3eYV5urxqSIlA1jwHY/rywOIPSZAh5TGa23lItRM73WPrsuEuBBxCEl
         fPdj8yDnOSDiadjYCw0EeN/a92gJmvwzRo9utORRHFl4tDCTNw0lYhH+IS5XcF761XFG
         SHHg==
X-Gm-Message-State: AOAM530U6a77nMq7aNsTZIJ14FE5oQ4wrkGuebhe2NBEw+fp+/wxBr0d
        tqQsjKQiTUGC8YeP01O/pgv78JOXWU5l795Or+q+JQ==
X-Google-Smtp-Source: ABdhPJwq7PTGRtCMjUiggLSMC9TpDCCWptep5ZIzr/uwnT9+Mp8WYAhX//iGnQtcfJ4lPr/TRRxiCZ/BmRw/045WfYU=
X-Received: by 2002:a25:4f41:: with SMTP id d62mr47733276ybb.156.1643903694511;
 Thu, 03 Feb 2022 07:54:54 -0800 (PST)
MIME-Version: 1.0
References: <20220203015140.3022854-1-eric.dumazet@gmail.com>
 <20220203015140.3022854-15-eric.dumazet@gmail.com> <00066e2f-048b-16ac-c3d0-eb480593bdfb@gmail.com>
In-Reply-To: <00066e2f-048b-16ac-c3d0-eb480593bdfb@gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 3 Feb 2022 07:54:43 -0800
Message-ID: <CANn89iLCeW48UXPX6faE=GCbU6Te2xmUYw6a-n3GrcEc4zXTxA@mail.gmail.com>
Subject: Re: [PATCH net-next 14/15] mlx4: support BIG TCP packets
To:     Tariq Toukan <ttoukan.linux@gmail.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>, Coco Li <lixiaoyan@google.com>,
        Tariq Toukan <tariqt@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

()

On Thu, Feb 3, 2022 at 5:04 AM Tariq Toukan <ttoukan.linux@gmail.com> wrote:
>
>
>
> On 2/3/2022 3:51 AM, Eric Dumazet wrote:
> > From: Eric Dumazet <edumazet@google.com>
> >
> > mlx4 supports LSOv2 just fine.
> >
> > IPv6 stack inserts a temporary Hop-by-Hop header
> > with JUMBO TLV for big packets.
> >
> > We need to ignore the HBH header when populating TX descriptor.
> >
> > Tested:
> >
> > Before: (not enabling bigger TSO/GRO packets)
> >
> > ip link set dev eth0 gso_ipv6_max_size 65536 gro_ipv6_max_size 65536
> >
> > netperf -H lpaa18 -t TCP_RR -T2,2 -l 10 -Cc -- -r 70000,70000
> > MIGRATED TCP REQUEST/RESPONSE TEST from ::0 (::) port 0 AF_INET6 to lpaa18.prod.google.com () port 0 AF_INET6 : first burst 0 : cpu bind
> > Local /Remote
> > Socket Size   Request Resp.  Elapsed Trans.   CPU    CPU    S.dem   S.dem
> > Send   Recv   Size    Size   Time    Rate     local  remote local   remote
> > bytes  bytes  bytes   bytes  secs.   per sec  % S    % S    us/Tr   us/Tr
> >
> > 262144 540000 70000   70000  10.00   6591.45  0.86   1.34   62.490  97.446
> > 262144 540000
> >
> > After: (enabling bigger TSO/GRO packets)
> >
> > ip link set dev eth0 gso_ipv6_max_size 185000 gro_ipv6_max_size 185000
> >
> > netperf -H lpaa18 -t TCP_RR -T2,2 -l 10 -Cc -- -r 70000,70000
> > MIGRATED TCP REQUEST/RESPONSE TEST from ::0 (::) port 0 AF_INET6 to lpaa18.prod.google.com () port 0 AF_INET6 : first burst 0 : cpu bind
> > Local /Remote
> > Socket Size   Request Resp.  Elapsed Trans.   CPU    CPU    S.dem   S.dem
> > Send   Recv   Size    Size   Time    Rate     local  remote local   remote
> > bytes  bytes  bytes   bytes  secs.   per sec  % S    % S    us/Tr   us/Tr
> >
> > 262144 540000 70000   70000  10.00   8383.95  0.95   1.01   54.432  57.584
> > 262144 540000
> >
> > Signed-off-by: Eric Dumazet <edumazet@google.com>
> > Cc: Tariq Toukan <tariqt@nvidia.com>
> > ---
> >   .../net/ethernet/mellanox/mlx4/en_netdev.c    |  3 ++
> >   drivers/net/ethernet/mellanox/mlx4/en_tx.c    | 47 +++++++++++++++----
> >   2 files changed, 41 insertions(+), 9 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
> > index c61dc7ae0c056a4dbcf24297549f6b1b5cc25d92..76cb93f5e5240c54f6f4c57e39739376206b4f34 100644
> > --- a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
> > +++ b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
> > @@ -3417,6 +3417,9 @@ int mlx4_en_init_netdev(struct mlx4_en_dev *mdev, int port,
> >       dev->min_mtu = ETH_MIN_MTU;
> >       dev->max_mtu = priv->max_mtu;
> >
> > +     /* supports LSOv2 packets, 512KB limit has been tested. */
> > +     netif_set_tso_ipv6_max_size(dev, 512 * 1024);
> > +
> >       mdev->pndev[port] = dev;
> >       mdev->upper[port] = NULL;
> >
> > diff --git a/drivers/net/ethernet/mellanox/mlx4/en_tx.c b/drivers/net/ethernet/mellanox/mlx4/en_tx.c
> > index 817f4154b86d599cd593876ec83529051d95fe2f..c89b3e8094e7d8cfb11aaa6cc4ad63bf3ad5934e 100644
> > --- a/drivers/net/ethernet/mellanox/mlx4/en_tx.c
> > +++ b/drivers/net/ethernet/mellanox/mlx4/en_tx.c
> > @@ -44,6 +44,7 @@
> >   #include <linux/ipv6.h>
> >   #include <linux/moduleparam.h>
> >   #include <linux/indirect_call_wrapper.h>
> > +#include <net/ipv6.h>
> >
> >   #include "mlx4_en.h"
> >
> > @@ -635,19 +636,28 @@ static int get_real_size(const struct sk_buff *skb,
> >                        struct net_device *dev,
> >                        int *lso_header_size,
> >                        bool *inline_ok,
> > -                      void **pfrag)
> > +                      void **pfrag,
> > +                      int *hopbyhop)
> >   {
> >       struct mlx4_en_priv *priv = netdev_priv(dev);
> >       int real_size;
> >
> >       if (shinfo->gso_size) {
> >               *inline_ok = false;
> > -             if (skb->encapsulation)
> > +             *hopbyhop = 0;
> > +             if (skb->encapsulation) {
> >                       *lso_header_size = (skb_inner_transport_header(skb) - skb->data) + inner_tcp_hdrlen(skb);
> > -             else
> > +             } else {
> > +                     /* Detects large IPV6 TCP packets and prepares for removal of
> > +                      * HBH header that has been pushed by ip6_xmit(),
> > +                      * mainly so that tcpdump can dissect them.
> > +                      */
> > +                     if (ipv6_has_hopopt_jumbo(skb))
> > +                             *hopbyhop = sizeof(struct hop_jumbo_hdr);
> >                       *lso_header_size = skb_transport_offset(skb) + tcp_hdrlen(skb);
> > +             }
> >               real_size = CTRL_SIZE + shinfo->nr_frags * DS_SIZE +
> > -                     ALIGN(*lso_header_size + 4, DS_SIZE);
> > +                     ALIGN(*lso_header_size - *hopbyhop + 4, DS_SIZE);
> >               if (unlikely(*lso_header_size != skb_headlen(skb))) {
> >                       /* We add a segment for the skb linear buffer only if
> >                        * it contains data */
> > @@ -874,6 +884,7 @@ netdev_tx_t mlx4_en_xmit(struct sk_buff *skb, struct net_device *dev)
> >       int desc_size;
> >       int real_size;
> >       u32 index, bf_index;
> > +     struct ipv6hdr *h6;
> >       __be32 op_own;
> >       int lso_header_size;
> >       void *fragptr = NULL;
> > @@ -882,6 +893,7 @@ netdev_tx_t mlx4_en_xmit(struct sk_buff *skb, struct net_device *dev)
> >       bool stop_queue;
> >       bool inline_ok;
> >       u8 data_offset;
> > +     int hopbyhop;
> >       bool bf_ok;
> >
> >       tx_ind = skb_get_queue_mapping(skb);
> > @@ -891,7 +903,7 @@ netdev_tx_t mlx4_en_xmit(struct sk_buff *skb, struct net_device *dev)
> >               goto tx_drop;
> >
> >       real_size = get_real_size(skb, shinfo, dev, &lso_header_size,
> > -                               &inline_ok, &fragptr);
> > +                               &inline_ok, &fragptr, &hopbyhop);
> >       if (unlikely(!real_size))
> >               goto tx_drop_count;
> >
> > @@ -944,7 +956,7 @@ netdev_tx_t mlx4_en_xmit(struct sk_buff *skb, struct net_device *dev)
> >               data = &tx_desc->data;
> >               data_offset = offsetof(struct mlx4_en_tx_desc, data);
> >       } else {
> > -             int lso_align = ALIGN(lso_header_size + 4, DS_SIZE);
> > +             int lso_align = ALIGN(lso_header_size - hopbyhop + 4, DS_SIZE);
> >
> >               data = (void *)&tx_desc->lso + lso_align;
> >               data_offset = offsetof(struct mlx4_en_tx_desc, lso) + lso_align;
> > @@ -1009,14 +1021,31 @@ netdev_tx_t mlx4_en_xmit(struct sk_buff *skb, struct net_device *dev)
> >                       ((ring->prod & ring->size) ?
> >                               cpu_to_be32(MLX4_EN_BIT_DESC_OWN) : 0);
> >
> > +             lso_header_size -= hopbyhop;
> >               /* Fill in the LSO prefix */
> >               tx_desc->lso.mss_hdr_size = cpu_to_be32(
> >                       shinfo->gso_size << 16 | lso_header_size);
> >
> > -             /* Copy headers;
> > -              * note that we already verified that it is linear */
> > -             memcpy(tx_desc->lso.header, skb->data, lso_header_size);
> >
> > +             if (unlikely(hopbyhop)) {
> > +                     /* remove the HBH header.
> > +                      * Layout: [Ethernet header][IPv6 header][HBH][TCP header]
> > +                      */
> > +                     memcpy(tx_desc->lso.header, skb->data, ETH_HLEN + sizeof(*h6));
> > +                     h6 = (struct ipv6hdr *)((char *)tx_desc->lso.header + ETH_HLEN);
> > +                     h6->nexthdr = IPPROTO_TCP;
> > +                     /* Copy the TCP header after the IPv6 one */
> > +                     memcpy(h6 + 1,
> > +                            skb->data + ETH_HLEN + sizeof(*h6) +
> > +                                     sizeof(struct hop_jumbo_hdr),
> > +                            tcp_hdrlen(skb));
> > +                     /* Leave ipv6 payload_len set to 0, as LSO v2 specs request. */
>
> Hi Eric,
> Many thanks for your patches.
> Impressive improvement indeed!
>
> I am concerned about not using lso_header_size in this flow.
> The num of bytes copied here might be out-of-sync with the value
> provided in the descriptor (tx_desc->lso.mss_hdr_size).
> Are the two values guaranteed to be equal?

I think they are equal.

get_real_size() sets :

*lso_header_size = skb_transport_offset(skb) + tcp_hdrlen(skb);

Also, BIG TCP is supporting native IPv6 + TCP only at this moment.

> I think this is an assumption that can get broken in the future by
> unaware patches to the kernel stack.

Changes are self-contained in drivers/net/ethernet/mellanox/mlx4/en_tx.c,
functions get_real_size() and mlx4_en_xmit()

>
> Thanks,
> Tariq
>
> > +             } else {
> > +                     /* Copy headers;
> > +                      * note that we already verified that it is linear
> > +                      */
> > +                     memcpy(tx_desc->lso.header, skb->data, lso_header_size);
> > +             }
> >               ring->tso_packets++;
> >
> >               i = shinfo->gso_segs;
