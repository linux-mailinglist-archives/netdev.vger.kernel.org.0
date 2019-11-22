Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D01C10729B
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 14:00:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727351AbfKVNAN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 08:00:13 -0500
Received: from mail-lf1-f68.google.com ([209.85.167.68]:33451 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726813AbfKVNAN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Nov 2019 08:00:13 -0500
Received: by mail-lf1-f68.google.com with SMTP id d6so5478169lfc.0;
        Fri, 22 Nov 2019 05:00:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=lCafcaM/gkHk4VH9grCJnxiByv5QwMGh5uhAiM30Z6Y=;
        b=MV7qDV/eU0IdHHwSBXBuQdrZG+RbDxVV6keIU7EjtjvKj0wrwUafuqP9iQh/GmQho4
         zPxe13gNsWpdaM1gFG1zwkYhjm7RzLc2B29f4XVXppBRuXVApFrVk4T4aIR4K4B0e7Xr
         rlVwTj6W+YFGwocbBBjW8IhWYwZraNlyrQMKIriz8GRirSCX2apPnL9HcMfGvZo8U5Lh
         zL25nVf8GPTyJs2nWW1fzZToCMN+fhAH2d7/4JITkM0+N56cRdtjd1xBH7N8v/YakXC3
         upCkV5GLyeRIFqSRxR/Ntkd8jvbL5adBJNCLaXsp+aiWLpqE/A4mRHJS+9fOv7K/3jn+
         81bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=lCafcaM/gkHk4VH9grCJnxiByv5QwMGh5uhAiM30Z6Y=;
        b=KspyymcCLbQeTe1cCXc4ANCrWUyYmdydUL3WxaRnUf/IV5wrbeDahnmhjk9WFF5S4Y
         10jepMT8kBWZmci4rqOgNhd1wiPEjFDjl3k9ZoAM8+a0YliOsyzUBn77ow2RX3RcHI8h
         h9GEpwKnjpVrtOT5i3zd3eHzBYk5px4q9m7bV/1rrH85UFZOzppxGyfQKkL91Pt17j/D
         EKtLJeAN927Lx2tImO/JHg/PS1e4E6LGjY84UDPwV58CsfrfhtdbowQMDwQ5BgkuXHp2
         +3Cb7TToHZvxXG/nmdK7Z9sTKXrNeBAyhccXve44UEEPV+yvj3uBzNfv0JZO9rJwr3ie
         MMIw==
X-Gm-Message-State: APjAAAUm/nuZTQxfLb5J0E5ITV8bojldvgvUCjjQ7XIPwacW9cJWwnzU
        EpAWsKX5BEOaqChW88f5aLBhebQsXe3pNQ/54qY=
X-Google-Smtp-Source: APXvYqwx8lrnZ4YJ4r2I07ssF4znJ16/fX6Q4+/hm2NWLQeX3ZnLRsJ5cDVcn8EE5vicf9n8Q0EJSI3JIwqQF9HTE3w=
X-Received: by 2002:a19:6b10:: with SMTP id d16mr12107054lfa.137.1574427609649;
 Fri, 22 Nov 2019 05:00:09 -0800 (PST)
MIME-Version: 1.0
References: <20191122013636.1041-1-jcfaracco@gmail.com> <20191122052506-mutt-send-email-mst@kernel.org>
In-Reply-To: <20191122052506-mutt-send-email-mst@kernel.org>
From:   Julio Faracco <jcfaracco@gmail.com>
Date:   Fri, 22 Nov 2019 09:59:58 -0300
Message-ID: <CAENf94KX1XR4_KXz9KLZQ09Ngeaq2qzYY5OE68xJMXMu13SuEg@mail.gmail.com>
Subject: Re: [PATCH net-next v2] drivers: net: virtio_net: Implement a
 dev_watchdog handler
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     netdev@vger.kernel.org, Daiane Mendes <dnmendes76@gmail.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Michael,

Em sex., 22 de nov. de 2019 =C3=A0s 07:31, Michael S. Tsirkin
<mst@redhat.com> escreveu:
>
> On Thu, Nov 21, 2019 at 10:36:36PM -0300, Julio Faracco wrote:
> > Driver virtio_net is not handling error events for TX provided by
> > dev_watchdog. This event is reached when transmission queue is having
> > problems to transmit packets. This could happen for any reason. To
> > enable it, driver should have .ndo_tx_timeout implemented.
> >
> > This commit brings back virtnet_reset method to recover TX queues from =
a
> > error state. That function is called by schedule_work method and it put=
s
> > the reset function into work queue.
> >
> > As the error cause is unknown at this moment, it would be better to
> > reset all queues.
> >
> > Signed-off-by: Julio Faracco <jcfaracco@gmail.com>
> > Signed-off-by: Daiane Mendes <dnmendes76@gmail.com>
> > Cc: Jason Wang <jasowang@redhat.com>
> > ---
> > v1-v2: Tag `net-next` was included to indentify where patch would be
> > applied.
> > ---
> >  drivers/net/virtio_net.c | 95 +++++++++++++++++++++++++++++++++++++++-
> >  1 file changed, 94 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > index 4d7d5434cc5d..31890d77eaf2 100644
> > --- a/drivers/net/virtio_net.c
> > +++ b/drivers/net/virtio_net.c
> > @@ -75,6 +75,7 @@ struct virtnet_sq_stats {
> >       u64 xdp_tx;
> >       u64 xdp_tx_drops;
> >       u64 kicks;
> > +     u64 tx_timeouts;
> >  };
> >
> >  struct virtnet_rq_stats {
> > @@ -98,6 +99,7 @@ static const struct virtnet_stat_desc virtnet_sq_stat=
s_desc[] =3D {
> >       { "xdp_tx",             VIRTNET_SQ_STAT(xdp_tx) },
> >       { "xdp_tx_drops",       VIRTNET_SQ_STAT(xdp_tx_drops) },
> >       { "kicks",              VIRTNET_SQ_STAT(kicks) },
> > +     { "tx_timeouts",        VIRTNET_SQ_STAT(tx_timeouts) },
> >  };
> >
> >  static const struct virtnet_stat_desc virtnet_rq_stats_desc[] =3D {
> > @@ -211,6 +213,9 @@ struct virtnet_info {
> >       /* Work struct for config space updates */
> >       struct work_struct config_work;
> >
> > +     /* Work struct for resetting the virtio-net driver. */
> > +     struct work_struct reset_work;
> > +
> >       /* Does the affinity hint is set for virtqueues? */
> >       bool affinity_hint_set;
> >
> > @@ -1721,7 +1726,7 @@ static void virtnet_stats(struct net_device *dev,
> >       int i;
> >
> >       for (i =3D 0; i < vi->max_queue_pairs; i++) {
> > -             u64 tpackets, tbytes, rpackets, rbytes, rdrops;
> > +             u64 tpackets, tbytes, terrors, rpackets, rbytes, rdrops;
> >               struct receive_queue *rq =3D &vi->rq[i];
> >               struct send_queue *sq =3D &vi->sq[i];
> >
> > @@ -1729,6 +1734,7 @@ static void virtnet_stats(struct net_device *dev,
> >                       start =3D u64_stats_fetch_begin_irq(&sq->stats.sy=
ncp);
> >                       tpackets =3D sq->stats.packets;
> >                       tbytes   =3D sq->stats.bytes;
> > +                     terrors  =3D sq->stats.tx_timeouts;
> >               } while (u64_stats_fetch_retry_irq(&sq->stats.syncp, star=
t));
> >
> >               do {
> > @@ -1743,6 +1749,7 @@ static void virtnet_stats(struct net_device *dev,
> >               tot->rx_bytes   +=3D rbytes;
> >               tot->tx_bytes   +=3D tbytes;
> >               tot->rx_dropped +=3D rdrops;
> > +             tot->tx_errors  +=3D terrors;
> >       }
> >
> >       tot->tx_dropped =3D dev->stats.tx_dropped;
> > @@ -2578,6 +2585,33 @@ static int virtnet_set_features(struct net_devic=
e *dev,
> >       return 0;
> >  }
> >
> > +static void virtnet_tx_timeout(struct net_device *dev)
> > +{
> > +     struct virtnet_info *vi =3D netdev_priv(dev);
> > +     u32 i;
> > +
> > +     netdev_warn(dev, "TX timeout stats:\n");
> > +     /* find the stopped queue the same way dev_watchdog() does */
> > +     for (i =3D 0; i < vi->curr_queue_pairs; i++) {
> > +             struct send_queue *sq =3D &vi->sq[i];
> > +
> > +             if (!netif_xmit_stopped(netdev_get_tx_queue(dev, i))) {
> > +                     netdev_warn(dev, " Available send queue: %d, sq: =
%s, vq: %d, name: %s\n",
> > +                                 i, sq->name, sq->vq->index, sq->vq->n=
ame);
>
> What does this mean?
>
> > +                     continue;
> > +             }
> > +
> > +             u64_stats_update_begin(&sq->stats.syncp);
> > +             sq->stats.tx_timeouts++;
> > +             u64_stats_update_end(&sq->stats.syncp);
> > +
> > +             netdev_warn(dev, " Unavailable send queue: %d, sq: %s, vq=
: %d, name: %s\n",
> > +                         i, sq->name, sq->vq->index, sq->vq->name);
> > +     }
>
> Can we make the warning less cryptic?
> I wonder why don't we get the sq from timeout directly?
> Would seem cleaner.

I need your help with debbuging information. What kind of field shoud
it notify when a TX timeout occurs?
Or we can keep the default WARN_ONCE, but we need a minimum method implemen=
ted.
We cannot get timeout directly because it needs to be implemented to
get it directly.
Net core scheduler checks if this handler was implemented to throw a
TX timeout. See:

    void __netdev_watchdog_up(struct net_device *dev)
    {
           if (dev->netdev_ops->ndo_tx_timeout) {
                   if (dev->watchdog_timeo <=3D 0)
                        dev->watchdog_timeo =3D 5*HZ;
                   if (!mod_timer(&dev->watchdog_timer,
                                  round_jiffies(jiffies + dev->watchdog_tim=
eo)))
                           dev_hold(dev);
           }
    }

>
> > +
> > +     schedule_work(&vi->reset_work);
> > +}
> > +
> >  static const struct net_device_ops virtnet_netdev =3D {
> >       .ndo_open            =3D virtnet_open,
> >       .ndo_stop            =3D virtnet_close,
> > @@ -2593,6 +2627,7 @@ static const struct net_device_ops virtnet_netdev=
 =3D {
> >       .ndo_features_check     =3D passthru_features_check,
> >       .ndo_get_phys_port_name =3D virtnet_get_phys_port_name,
> >       .ndo_set_features       =3D virtnet_set_features,
> > +     .ndo_tx_timeout         =3D virtnet_tx_timeout,
> >  };
> >
> >  static void virtnet_config_changed_work(struct work_struct *work)
> > @@ -2982,6 +3017,62 @@ static int virtnet_validate(struct virtio_device=
 *vdev)
> >       return 0;
> >  }
> >
> > +static void _remove_vq_common(struct virtnet_info *vi)
> > +{
> > +     vi->vdev->config->reset(vi->vdev);
> > +
> > +     /* Free unused buffers in both send and recv, if any. */
> > +     free_unused_bufs(vi);
> > +
> > +     _free_receive_bufs(vi);
> > +
> > +     free_receive_page_frags(vi);
> > +
> > +     virtnet_del_vqs(vi);
> > +}
> > +
> > +static int _virtnet_reset(struct virtnet_info *vi)
> > +{
> > +     struct virtio_device *vdev =3D vi->vdev;
> > +     int ret;
> > +
> > +     virtio_config_disable(vdev);
> > +     vdev->failed =3D vdev->config->get_status(vdev) & VIRTIO_CONFIG_S=
_FAILED;
> > +
> > +     virtnet_freeze_down(vdev);
> > +     _remove_vq_common(vi);
> > +
> > +     virtio_add_status(vdev, VIRTIO_CONFIG_S_ACKNOWLEDGE);
> > +     virtio_add_status(vdev, VIRTIO_CONFIG_S_DRIVER);
> > +
> > +     ret =3D virtio_finalize_features(vdev);
> > +     if (ret)
> > +             goto err;
> > +
> > +     ret =3D virtnet_restore_up(vdev);
> > +     if (ret)
> > +             goto err;
> > +
> > +     ret =3D _virtnet_set_queues(vi, vi->curr_queue_pairs);
> > +     if (ret)
> > +             goto err;
> > +
> > +     virtio_add_status(vdev, VIRTIO_CONFIG_S_DRIVER_OK);
> > +     virtio_config_enable(vdev);
>
>
> Is this enough? E.g. all RX mode programming has been lost.

IMHO virtio net has a nice performance. You can take days to see a TX timeo=
ut.
If it is happening frequently, there is something wrong with device.
So, again, IMHO I don't think it would be too problematic.

>
>
>
> > +     return 0;
> > +err:
> > +     virtio_add_status(vdev, VIRTIO_CONFIG_S_FAILED);
> > +     return ret;
> > +}
> > +
> > +static void virtnet_reset(struct work_struct *work)
> > +{
> > +     struct virtnet_info *vi =3D
> > +             container_of(work, struct virtnet_info, reset_work);
> > +
> > +     _virtnet_reset(vi);
> > +}
> > +
> >  static int virtnet_probe(struct virtio_device *vdev)
> >  {
> >       int i, err =3D -ENOMEM;
> > @@ -3011,6 +3102,7 @@ static int virtnet_probe(struct virtio_device *vd=
ev)
> >       dev->netdev_ops =3D &virtnet_netdev;
> >       dev->features =3D NETIF_F_HIGHDMA;
> >
> > +     dev->watchdog_timeo =3D 5 * HZ;
> >       dev->ethtool_ops =3D &virtnet_ethtool_ops;
> >       SET_NETDEV_DEV(dev, &vdev->dev);
> >
>
> Is there a way to make this tuneable from ethtool?

Yes and no.
You can do that obviously, but it is not a common field to tun. If you
compare with other drivers.

>
> > @@ -3068,6 +3160,7 @@ static int virtnet_probe(struct virtio_device *vd=
ev)
> >       vdev->priv =3D vi;
> >
> >       INIT_WORK(&vi->config_work, virtnet_config_changed_work);
> > +     INIT_WORK(&vi->reset_work, virtnet_reset);
> >
> >       /* If we can receive ANY GSO packets, we must allocate large ones=
. */
> >       if (virtio_has_feature(vdev, VIRTIO_NET_F_GUEST_TSO4) ||
> > --
> > 2.17.1
>
