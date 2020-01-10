Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 830E81370E7
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 16:15:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728343AbgAJPPO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 10:15:14 -0500
Received: from mail-qv1-f65.google.com ([209.85.219.65]:44210 "EHLO
        mail-qv1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726402AbgAJPPN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jan 2020 10:15:13 -0500
Received: by mail-qv1-f65.google.com with SMTP id n8so861956qvg.11;
        Fri, 10 Jan 2020 07:15:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=jOZqElplWg5Xt7BMCm/+tKu7EEFSohj+Fj77++BAo4Y=;
        b=VE7tXjS0SuVr66EZ/rROcxWrHZkiLem74dFk+f0bzB6HA3v6XRNZVCMC5V3grO4biT
         +QX9iLdIBzxlvl2ZTdsbfr4mdZ2djEyQ0huWV/H/sK2t8oUJOFOTyBBiUaXpPo4ThgeZ
         HllybE/Ek95VMSVIxMlvW7MCpKa+wN3kbVhQ/6ibji6WKzrmo4aFS3yI8k3oOgtOywOC
         bG53nOr03SCFD8huomc1DErSYzzgblUh9MU77zsO2MgZ0cnAMNm6aJoYmoGrGzTCQhtn
         UrLjYnUTuwaFWnyf0+Sk73vnakXlyCII71FGFmqofwufVqytoI5s1X7as5+1XFLgfHUi
         qY/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=jOZqElplWg5Xt7BMCm/+tKu7EEFSohj+Fj77++BAo4Y=;
        b=FkBmY/b5DQjlyfQJKXdCBGVCtibhkp/HdGL5Vq7eWFnQo+NPmhA+U2iKmTGiNYxCXG
         ZroosizwRELW9sBzowZs/9dnHXOME0w8+gDKPhe33aQBGd2TmRZiI3P0h2qNeKbxWhQb
         dk5w17G6M5s1BaWwEybGHSoVVreI7vH+B+4/CMAHbXu4uCFSQ0h53YcTI9gg8LUb8J3G
         Ty3devmUY+74AbfPePaM+tmx0hl0eg2Quh7B0AWjVeg4ciGMMY2IYNkD2FmaH3nGXlGo
         3T12sxeqiXroNuktfDPEpKzKG3qg4rA88056oa169vC9YIutQ8xDL3Q1UDQvZP8rTZfA
         Y1kg==
X-Gm-Message-State: APjAAAXAlEV9PrPQAxO07+Jn9wpW1GtlVSSRiZ4AvunHaYiFv2cMqHDf
        K/pzrXBePDk0Xp3gw/sAO5RSVlVlQmk6BOGE5jVq3D2c6gM=
X-Google-Smtp-Source: APXvYqwb1GSxy8qwMNHV8Ivxdjv3vZZvLsiItQvXvSJQEVa2CqaGeFjAPi84Thf+q0CAlc7ScrpZOovUvATSLPJNYZc=
X-Received: by 2002:a0c:ed47:: with SMTP id v7mr3210049qvq.10.1578669312175;
 Fri, 10 Jan 2020 07:15:12 -0800 (PST)
MIME-Version: 1.0
References: <157866612174.432695.5077671447287539053.stgit@toke.dk> <157866612392.432695.249078779633883278.stgit@toke.dk>
In-Reply-To: <157866612392.432695.249078779633883278.stgit@toke.dk>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Fri, 10 Jan 2020 16:15:00 +0100
Message-ID: <CAJ+HfNhM8SQK6dem9vhvAh68AqaxouSDhhWjXiidB3=LBRmsUA@mail.gmail.com>
Subject: Re: [PATCH bpf-next 2/2] xdp: Use bulking for non-map XDP_REDIRECT
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 10 Jan 2020 at 15:22, Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat=
.com> wrote:
>
> From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>
> Since the bulk queue used by XDP_REDIRECT now lives in struct net_device,
> we can re-use the bulking for the non-map version of the bpf_redirect()
> helper. This is a simple matter of having xdp_do_redirect_slow() queue th=
e
> frame on the bulk queue instead of sending it out with __bpf_tx_xdp().
>
> Unfortunately we can't make the bpf_redirect() helper return an error if
> the ifindex doesn't exit (as bpf_redirect_map() does), because we don't
> have a reference to the network namespace of the ingress device at the ti=
me
> the helper is called. So we have to leave it as-is and keep the device
> lookup in xdp_do_redirect_slow().
>
> With this change, the performance of the xdp_redirect sample program goes
> from 5Mpps to 8.4Mpps (a 68% increase).
>

After these changes, does the noinline (commit 47b123ed9e99 ("xdp:
split code for map vs non-map redirect")) still make sense?

> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> ---
>  include/linux/bpf.h |   13 +++++++++++--
>  kernel/bpf/devmap.c |   31 ++++++++++++++++++++++---------
>  net/core/filter.c   |   30 ++----------------------------
>  3 files changed, 35 insertions(+), 39 deletions(-)
>
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index b14e51d56a82..25c050202536 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -962,7 +962,9 @@ struct sk_buff;
>
>  struct bpf_dtab_netdev *__dev_map_lookup_elem(struct bpf_map *map, u32 k=
ey);
>  struct bpf_dtab_netdev *__dev_map_hash_lookup_elem(struct bpf_map *map, =
u32 key);
> -void __dev_map_flush(void);
> +void __dev_flush(void);
> +int dev_xdp_enqueue(struct net_device *dev, struct xdp_buff *xdp,
> +                   struct net_device *dev_rx);
>  int dev_map_enqueue(struct bpf_dtab_netdev *dst, struct xdp_buff *xdp,
>                     struct net_device *dev_rx);
>  int dev_map_generic_redirect(struct bpf_dtab_netdev *dst, struct sk_buff=
 *skb,
> @@ -1071,13 +1073,20 @@ static inline struct net_device  *__dev_map_hash_=
lookup_elem(struct bpf_map *map
>         return NULL;
>  }
>
> -static inline void __dev_map_flush(void)
> +static inline void __dev_flush(void)
>  {
>  }
>
>  struct xdp_buff;
>  struct bpf_dtab_netdev;
>
> +static inline
> +int dev_xdp_enqueue(struct net_device *dev, struct xdp_buff *xdp,
> +                   struct net_device *dev_rx)
> +{
> +       return 0;
> +}
> +
>  static inline
>  int dev_map_enqueue(struct bpf_dtab_netdev *dst, struct xdp_buff *xdp,
>                     struct net_device *dev_rx)
> diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
> index bcb05cb6b728..adbb82770d02 100644
> --- a/kernel/bpf/devmap.c
> +++ b/kernel/bpf/devmap.c
> @@ -81,7 +81,7 @@ struct bpf_dtab {
>         u32 n_buckets;
>  };
>
> -static DEFINE_PER_CPU(struct list_head, dev_map_flush_list);
> +static DEFINE_PER_CPU(struct list_head, dev_flush_list);
>  static DEFINE_SPINLOCK(dev_map_lock);
>  static LIST_HEAD(dev_map_list);
>
> @@ -357,16 +357,16 @@ static int bq_xmit_all(struct xdp_dev_bulk_queue *b=
q, u32 flags)
>         goto out;
>  }
>
> -/* __dev_map_flush is called from xdp_do_flush_map() which _must_ be sig=
naled
> +/* __dev_flush is called from xdp_do_flush_map() which _must_ be signale=
d
>   * from the driver before returning from its napi->poll() routine. The p=
oll()
>   * routine is called either from busy_poll context or net_rx_action sign=
aled
>   * from NET_RX_SOFTIRQ. Either way the poll routine must complete before=
 the
>   * net device can be torn down. On devmap tear down we ensure the flush =
list
>   * is empty before completing to ensure all flush operations have comple=
ted.
>   */
> -void __dev_map_flush(void)
> +void __dev_flush(void)
>  {
> -       struct list_head *flush_list =3D this_cpu_ptr(&dev_map_flush_list=
);
> +       struct list_head *flush_list =3D this_cpu_ptr(&dev_flush_list);
>         struct xdp_dev_bulk_queue *bq, *tmp;
>
>         rcu_read_lock();
> @@ -398,7 +398,7 @@ static int bq_enqueue(struct net_device *dev, struct =
xdp_frame *xdpf,
>                       struct net_device *dev_rx)
>
>  {
> -       struct list_head *flush_list =3D this_cpu_ptr(&dev_map_flush_list=
);
> +       struct list_head *flush_list =3D this_cpu_ptr(&dev_flush_list);
>         struct xdp_dev_bulk_queue *bq =3D this_cpu_ptr(dev->xdp_bulkq);
>
>         if (unlikely(bq->count =3D=3D DEV_MAP_BULK_SIZE))
> @@ -419,10 +419,9 @@ static int bq_enqueue(struct net_device *dev, struct=
 xdp_frame *xdpf,
>         return 0;
>  }
>
> -int dev_map_enqueue(struct bpf_dtab_netdev *dst, struct xdp_buff *xdp,
> -                   struct net_device *dev_rx)
> +static inline int _xdp_enqueue(struct net_device *dev, struct xdp_buff *=
xdp,
> +                              struct net_device *dev_rx)
>  {
> -       struct net_device *dev =3D dst->dev;
>         struct xdp_frame *xdpf;
>         int err;
>
> @@ -440,6 +439,20 @@ int dev_map_enqueue(struct bpf_dtab_netdev *dst, str=
uct xdp_buff *xdp,
>         return bq_enqueue(dev, xdpf, dev_rx);
>  }
>
> +int dev_xdp_enqueue(struct net_device *dev, struct xdp_buff *xdp,
> +                   struct net_device *dev_rx)
> +{
> +       return _xdp_enqueue(dev, xdp, dev_rx);
> +}
> +

dev_xdp_enqueue, and dev_map_enqueue are *very* similar. Can these be
combined, and maybe fold the xdp_do_redirect_slow() into
xdp_do_direct_map? OTOH the TP are different, so maybe combining the
two functions will be messy... It's only that with your changes the
map/ifindex redirect are very similar. Just an idea, might be messy.
:-P

> +int dev_map_enqueue(struct bpf_dtab_netdev *dst, struct xdp_buff *xdp,
> +                   struct net_device *dev_rx)
> +{
> +       struct net_device *dev =3D dst->dev;
> +
> +       return _xdp_enqueue(dev, xdp, dev_rx);
> +}
> +
>  int dev_map_generic_redirect(struct bpf_dtab_netdev *dst, struct sk_buff=
 *skb,
>                              struct bpf_prog *xdp_prog)
>  {
> @@ -760,7 +773,7 @@ static int __init dev_map_init(void)
>         register_netdevice_notifier(&dev_map_notifier);
>
>         for_each_possible_cpu(cpu)
> -               INIT_LIST_HEAD(&per_cpu(dev_map_flush_list, cpu));
> +               INIT_LIST_HEAD(&per_cpu(dev_flush_list, cpu));
>         return 0;
>  }
>
> diff --git a/net/core/filter.c b/net/core/filter.c
> index 42fd17c48c5f..550488162fe1 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -3458,32 +3458,6 @@ static const struct bpf_func_proto bpf_xdp_adjust_=
meta_proto =3D {
>         .arg2_type      =3D ARG_ANYTHING,
>  };
>
> -static int __bpf_tx_xdp(struct net_device *dev,
> -                       struct bpf_map *map,
> -                       struct xdp_buff *xdp,
> -                       u32 index)
> -{
> -       struct xdp_frame *xdpf;
> -       int err, sent;
> -
> -       if (!dev->netdev_ops->ndo_xdp_xmit) {
> -               return -EOPNOTSUPP;
> -       }
> -
> -       err =3D xdp_ok_fwd_dev(dev, xdp->data_end - xdp->data);
> -       if (unlikely(err))
> -               return err;
> -
> -       xdpf =3D convert_to_xdp_frame(xdp);
> -       if (unlikely(!xdpf))
> -               return -EOVERFLOW;
> -
> -       sent =3D dev->netdev_ops->ndo_xdp_xmit(dev, 1, &xdpf, XDP_XMIT_FL=
USH);
> -       if (sent <=3D 0)
> -               return sent;
> -       return 0;
> -}
> -
>  static noinline int
>  xdp_do_redirect_slow(struct net_device *dev, struct xdp_buff *xdp,
>                      struct bpf_prog *xdp_prog, struct bpf_redirect_info =
*ri)
> @@ -3499,7 +3473,7 @@ xdp_do_redirect_slow(struct net_device *dev, struct=
 xdp_buff *xdp,
>                 goto err;
>         }
>
> -       err =3D __bpf_tx_xdp(fwd, NULL, xdp, 0);
> +       err =3D dev_xdp_enqueue(fwd, xdp, dev);
>         if (unlikely(err))
>                 goto err;
>
> @@ -3529,7 +3503,7 @@ static int __bpf_tx_xdp_map(struct net_device *dev_=
rx, void *fwd,
>
>  void xdp_do_flush_map(void)
>  {
> -       __dev_map_flush();
> +       __dev_flush();
>         __cpu_map_flush();
>         __xsk_map_flush();
>  }
>
