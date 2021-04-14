Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77A7835EE86
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 09:42:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349751AbhDNHgw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 03:36:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349746AbhDNHgt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Apr 2021 03:36:49 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A8A6C061756;
        Wed, 14 Apr 2021 00:36:27 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id d10so13785232pgf.12;
        Wed, 14 Apr 2021 00:36:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JUriliXziD1JqOaFOdCh2orlCG3+O7ZJU3LFzNKQc8k=;
        b=QsRserrCnsLwCLnbiGptmxncRaKIFA81MRljOwaBiLQ4syyzQlc72S/OeUjs+Wt+aG
         +B1+kCQDpwCiJrAthdYymVqM5rhg0tro8sAuquv7OTXmpedB7Vuzyd3aWKPHSxTZUn93
         M0JWX574/rO3XGmeqxpS8XKUAL7NabBQjxyf5bu3GWv628gXv0rTP8fFjjMD9C2Nl9wU
         yvIzJSX6vlDpi1tkMUwzoCc8IFYNtc5DdAY0a2h6bLUvipq1Bu20mrgKJkpkxkQu801n
         TzhXKccI3OG1LbH2hfJKVhPvPOQ1la0lKDnLlzMf3V3KPBpEU3cJwPgSxt8e2dyjSxQ+
         Ta1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JUriliXziD1JqOaFOdCh2orlCG3+O7ZJU3LFzNKQc8k=;
        b=d2bdqj76VVWAmIvt+QlkB4rulNEZ19WvRRAyJ5ERDf0FRhiPcHmYUSsZYu3g4DAXu8
         RP+WOz4okTNfMO2SKaHTai46tDOxoTjiNx8b1WRE2pRsvBq6aPI/+4xM2l1EK0am+AwL
         22fgAk4FKnLD2GKCz39ikAIsfRAMyGhMEVRqZ3uvIzJNHVD1zvBqHHNi5PrDh7xXB4X1
         4SIZ5xEyNmRz+0Dq1l01gtkZgDRsw7ZS89A7axf40Z3bG9RtzPM5u1KYIckTXIPI5HwT
         d9MA+RMraqDnGbWr6vOCzeeeDe6/kgtywPNCBoa2UG+dezcJsBgYqP1P3BBH6jSghH5E
         fqYQ==
X-Gm-Message-State: AOAM532U3jdZ/+tJeIMaK6vZbywjUsR6k9UoV4BmQN9lZyCSRQ+pOGvb
        ESpnYDobmHewVM5n79+kNigW25Un8C2FtVuGmnYaitS4sgq+cEdRq7+cPw==
X-Google-Smtp-Source: ABdhPJwJ9ji5dDfzitPn+c1a1UrPe8R9CgldMs2QtGKnIRgRF947HhE+G28vtHosTLCn4KzUJWiE5uUl7Ralpdnx6Yk=
X-Received: by 2002:a63:6fc1:: with SMTP id k184mr37354684pgc.292.1618385786547;
 Wed, 14 Apr 2021 00:36:26 -0700 (PDT)
MIME-Version: 1.0
References: <20210413031523.73507-1-xuanzhuo@linux.alibaba.com> <20210413031523.73507-9-xuanzhuo@linux.alibaba.com>
In-Reply-To: <20210413031523.73507-9-xuanzhuo@linux.alibaba.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Wed, 14 Apr 2021 09:36:15 +0200
Message-ID: <CAJ8uoz2LzrvZUsDfFuKiFkyRwdWtEk8AF9y7Nb6RKzB7pO3YDw@mail.gmail.com>
Subject: Re: [PATCH net-next v4 08/10] virtio-net: xsk zero copy xmit setup
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
> xsk is a high-performance packet receiving and sending technology.
>
> This patch implements the binding and unbinding operations of xsk and
> the virtio-net queue for xsk zero copy xmit.
>
> The xsk zero copy xmit depends on tx napi. So if tx napi is not true,
> an error will be reported. And the entire operation is under the
> protection of rtnl_lock.
>
> If xsk is active, it will prevent ethtool from modifying tx napi.
>
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> Reviewed-by: Dust Li <dust.li@linux.alibaba.com>
> ---
>  drivers/net/virtio_net.c | 78 +++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 77 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index f52a25091322..8242a9e9f17d 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -22,6 +22,7 @@
>  #include <net/route.h>
>  #include <net/xdp.h>
>  #include <net/net_failover.h>
> +#include <net/xdp_sock_drv.h>
>
>  static int napi_weight = NAPI_POLL_WEIGHT;
>  module_param(napi_weight, int, 0444);
> @@ -133,6 +134,11 @@ struct send_queue {
>         struct virtnet_sq_stats stats;
>
>         struct napi_struct napi;
> +
> +       struct {
> +               /* xsk pool */
> +               struct xsk_buff_pool __rcu *pool;
> +       } xsk;
>  };
>
>  /* Internal representation of a receive virtqueue */
> @@ -2249,8 +2255,19 @@ static int virtnet_set_coalesce(struct net_device *dev,
>         if (napi_weight ^ vi->sq[0].napi.weight) {
>                 if (dev->flags & IFF_UP)
>                         return -EBUSY;
> -               for (i = 0; i < vi->max_queue_pairs; i++)
> +               for (i = 0; i < vi->max_queue_pairs; i++) {
> +                       /* xsk xmit depend on the tx napi. So if xsk is active,
> +                        * prevent modifications to tx napi.
> +                        */
> +                       rcu_read_lock();
> +                       if (rcu_dereference(vi->sq[i].xsk.pool)) {
> +                               rcu_read_unlock();
> +                               continue;
> +                       }
> +                       rcu_read_unlock();
> +
>                         vi->sq[i].napi.weight = napi_weight;
> +               }
>         }
>
>         return 0;
> @@ -2518,11 +2535,70 @@ static int virtnet_xdp_set(struct net_device *dev, struct bpf_prog *prog,
>         return err;
>  }
>
> +static int virtnet_xsk_pool_enable(struct net_device *dev,
> +                                  struct xsk_buff_pool *pool,
> +                                  u16 qid)
> +{
> +       struct virtnet_info *vi = netdev_priv(dev);
> +       struct send_queue *sq;
> +
> +       if (qid >= vi->curr_queue_pairs)
> +               return -EINVAL;

Your implementation is the first implementation that only supports
zerocopy for one out of Rx and Tx, and this will currently confuse the
control plane in some situations since it assumes that both Rx and Tx
are enabled by a call to this NDO. For example: user space creates an
xsk socket with both an Rx and a Tx ring, then calls bind with the
XDP_ZEROCOPY flag. In this case, the call should fail if the device is
virtio-net since it only supports zerocopy for Tx. But it should
succeed if the user only created a Tx ring since that makes it a
Tx-only socket which can be supported.

So you need to introduce a new interface in xdp_sock_drv.h that can be
used to ask if this socket has Rx enabled and if so fail the call (at
least one of them has to be enabled, otherwise the bind call would
fail before this ndo is called). Then the logic above will act on that
and try to fall back to copy mode (if allowed). Such an interface
(with an added "is_tx_enabled") might in the future be useful for
physical NIC drivers too if they would like to save on resources for
Tx-only and Rx-only sockets. Currently, they all just assume every
socket is Rx and Tx.

Thanks: Magnus

> +
> +       sq = &vi->sq[qid];
> +
> +       /* xsk zerocopy depend on the tx napi.
> +        *
> +        * xsk zerocopy xmit is driven by the tx interrupt. When the device is
> +        * not busy, napi will be called continuously to send data. When the
> +        * device is busy, wait for the notification interrupt after the
> +        * hardware has finished processing the data, and continue to send data
> +        * in napi.
> +        */
> +       if (!sq->napi.weight)
> +               return -EPERM;
> +
> +       rcu_read_lock();
> +       /* Here is already protected by rtnl_lock, so rcu_assign_pointer is
> +        * safe.
> +        */
> +       rcu_assign_pointer(sq->xsk.pool, pool);
> +       rcu_read_unlock();
> +
> +       return 0;
> +}
> +
> +static int virtnet_xsk_pool_disable(struct net_device *dev, u16 qid)
> +{
> +       struct virtnet_info *vi = netdev_priv(dev);
> +       struct send_queue *sq;
> +
> +       if (qid >= vi->curr_queue_pairs)
> +               return -EINVAL;
> +
> +       sq = &vi->sq[qid];
> +
> +       /* Here is already protected by rtnl_lock, so rcu_assign_pointer is
> +        * safe.
> +        */
> +       rcu_assign_pointer(sq->xsk.pool, NULL);
> +
> +       synchronize_net(); /* Sync with the XSK wakeup and with NAPI. */
> +
> +       return 0;
> +}
> +
>  static int virtnet_xdp(struct net_device *dev, struct netdev_bpf *xdp)
>  {
>         switch (xdp->command) {
>         case XDP_SETUP_PROG:
>                 return virtnet_xdp_set(dev, xdp->prog, xdp->extack);
> +       case XDP_SETUP_XSK_POOL:
> +               if (xdp->xsk.pool)
> +                       return virtnet_xsk_pool_enable(dev, xdp->xsk.pool,
> +                                                      xdp->xsk.queue_id);
> +               else
> +                       return virtnet_xsk_pool_disable(dev, xdp->xsk.queue_id);
>         default:
>                 return -EINVAL;
>         }
> --
> 2.31.0
>
