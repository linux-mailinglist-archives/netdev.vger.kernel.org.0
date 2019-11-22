Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E963106A10
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 11:31:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727289AbfKVKb3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 05:31:29 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:56678 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727263AbfKVKb2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Nov 2019 05:31:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574418686;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FlOZ5zqkxPswmHPOY4akzRfmqrkgFo/O2Djc8eOm0Q8=;
        b=Au7OZzg95qfKtqheCwo/zJZNNZ5xyi9mnwRdqFkO1USGwpzsFxWWMa52DopGZPt3bKO89m
        DKsJ5JaODzEr4HOqgwvy4Q4niJjr7A9BhbRdBJxH8kWnNTbC3kgJ6WBaNnMuJkBgAwExXm
        Y+WrIVIOzaGallbikuVAxbvSvNUOdcY=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-4-jbauWr4SM4eL09VwA8ukMQ-1; Fri, 22 Nov 2019 05:31:25 -0500
Received: by mail-qk1-f200.google.com with SMTP id s144so4009954qke.20
        for <netdev@vger.kernel.org>; Fri, 22 Nov 2019 02:31:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=jUNfNcFYrnFo3vyliVS23hPPWffkd+zA0rWCMO8GM2A=;
        b=sotYGZu0MltR8afX58vbjAtgiq3DB0Ew6kqh7b1nLr/o5RQH8W0Bu/YaRDBxpnJN+v
         DJ+zL45Ms+dZs5ZbiN2CGdx96A3SMpldfSPm4QU4qQ7FHEei9dNQe0GZXq85MgGNvLz6
         idon6AhzhvK0L0itNNLcuevnpzSdvbSlHeZAENMfdUipE2d49MEbOwa7BK3870MIKi9Y
         xCadfBza7DQY2exzFvjmM3BIuRggN4CMX9+zoHoJ6A0gY/Ryl/U9Q+v+sEkTSWomUbNz
         d/2V5LtH+t2lRTVzLjl/aAYs+ghcovAfDO/wpnI+dGOkgvkPqIrivEBZ701QSVFV3NIC
         IZWg==
X-Gm-Message-State: APjAAAXIToHq1lvh6e2C+OHGyNuuw7m6HvnvKySKkEWsP2m87pKn9/oq
        cu9Hpyz5o+iaIJSkY1alC7QQXK5mkLe/aLKDKb4grGEJ204dYw+Zm7cvRS6R9kEbgQHwl3c4MMw
        bfEcTOQK66FTSwq1f
X-Received: by 2002:ac8:ccf:: with SMTP id o15mr13578825qti.380.1574418684933;
        Fri, 22 Nov 2019 02:31:24 -0800 (PST)
X-Google-Smtp-Source: APXvYqzqWjQYE0JViMErwUJLyP31KaReAxhSG7SzcnEEeUUZg6KiYptY1y7iF0uI6KQLrQqeTSBM5A==
X-Received: by 2002:ac8:ccf:: with SMTP id o15mr13578801qti.380.1574418684642;
        Fri, 22 Nov 2019 02:31:24 -0800 (PST)
Received: from redhat.com (bzq-79-176-6-42.red.bezeqint.net. [79.176.6.42])
        by smtp.gmail.com with ESMTPSA id g7sm2775765qkl.20.2019.11.22.02.31.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Nov 2019 02:31:23 -0800 (PST)
Date:   Fri, 22 Nov 2019 05:31:19 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Julio Faracco <jcfaracco@gmail.com>
Cc:     netdev@vger.kernel.org, dnmendes76@gmail.com,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2] drivers: net: virtio_net: Implement a
 dev_watchdog handler
Message-ID: <20191122052506-mutt-send-email-mst@kernel.org>
References: <20191122013636.1041-1-jcfaracco@gmail.com>
MIME-Version: 1.0
In-Reply-To: <20191122013636.1041-1-jcfaracco@gmail.com>
X-MC-Unique: jbauWr4SM4eL09VwA8ukMQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 21, 2019 at 10:36:36PM -0300, Julio Faracco wrote:
> Driver virtio_net is not handling error events for TX provided by
> dev_watchdog. This event is reached when transmission queue is having
> problems to transmit packets. This could happen for any reason. To
> enable it, driver should have .ndo_tx_timeout implemented.
>=20
> This commit brings back virtnet_reset method to recover TX queues from a
> error state. That function is called by schedule_work method and it puts
> the reset function into work queue.
>=20
> As the error cause is unknown at this moment, it would be better to
> reset all queues.
>=20
> Signed-off-by: Julio Faracco <jcfaracco@gmail.com>
> Signed-off-by: Daiane Mendes <dnmendes76@gmail.com>
> Cc: Jason Wang <jasowang@redhat.com>
> ---
> v1-v2: Tag `net-next` was included to indentify where patch would be
> applied.
> ---
>  drivers/net/virtio_net.c | 95 +++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 94 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 4d7d5434cc5d..31890d77eaf2 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -75,6 +75,7 @@ struct virtnet_sq_stats {
>  =09u64 xdp_tx;
>  =09u64 xdp_tx_drops;
>  =09u64 kicks;
> +=09u64 tx_timeouts;
>  };
> =20
>  struct virtnet_rq_stats {
> @@ -98,6 +99,7 @@ static const struct virtnet_stat_desc virtnet_sq_stats_=
desc[] =3D {
>  =09{ "xdp_tx",=09=09VIRTNET_SQ_STAT(xdp_tx) },
>  =09{ "xdp_tx_drops",=09VIRTNET_SQ_STAT(xdp_tx_drops) },
>  =09{ "kicks",=09=09VIRTNET_SQ_STAT(kicks) },
> +=09{ "tx_timeouts",=09VIRTNET_SQ_STAT(tx_timeouts) },
>  };
> =20
>  static const struct virtnet_stat_desc virtnet_rq_stats_desc[] =3D {
> @@ -211,6 +213,9 @@ struct virtnet_info {
>  =09/* Work struct for config space updates */
>  =09struct work_struct config_work;
> =20
> +=09/* Work struct for resetting the virtio-net driver. */
> +=09struct work_struct reset_work;
> +
>  =09/* Does the affinity hint is set for virtqueues? */
>  =09bool affinity_hint_set;
> =20
> @@ -1721,7 +1726,7 @@ static void virtnet_stats(struct net_device *dev,
>  =09int i;
> =20
>  =09for (i =3D 0; i < vi->max_queue_pairs; i++) {
> -=09=09u64 tpackets, tbytes, rpackets, rbytes, rdrops;
> +=09=09u64 tpackets, tbytes, terrors, rpackets, rbytes, rdrops;
>  =09=09struct receive_queue *rq =3D &vi->rq[i];
>  =09=09struct send_queue *sq =3D &vi->sq[i];
> =20
> @@ -1729,6 +1734,7 @@ static void virtnet_stats(struct net_device *dev,
>  =09=09=09start =3D u64_stats_fetch_begin_irq(&sq->stats.syncp);
>  =09=09=09tpackets =3D sq->stats.packets;
>  =09=09=09tbytes   =3D sq->stats.bytes;
> +=09=09=09terrors  =3D sq->stats.tx_timeouts;
>  =09=09} while (u64_stats_fetch_retry_irq(&sq->stats.syncp, start));
> =20
>  =09=09do {
> @@ -1743,6 +1749,7 @@ static void virtnet_stats(struct net_device *dev,
>  =09=09tot->rx_bytes   +=3D rbytes;
>  =09=09tot->tx_bytes   +=3D tbytes;
>  =09=09tot->rx_dropped +=3D rdrops;
> +=09=09tot->tx_errors  +=3D terrors;
>  =09}
> =20
>  =09tot->tx_dropped =3D dev->stats.tx_dropped;
> @@ -2578,6 +2585,33 @@ static int virtnet_set_features(struct net_device =
*dev,
>  =09return 0;
>  }
> =20
> +static void virtnet_tx_timeout(struct net_device *dev)
> +{
> +=09struct virtnet_info *vi =3D netdev_priv(dev);
> +=09u32 i;
> +
> +=09netdev_warn(dev, "TX timeout stats:\n");
> +=09/* find the stopped queue the same way dev_watchdog() does */
> +=09for (i =3D 0; i < vi->curr_queue_pairs; i++) {
> +=09=09struct send_queue *sq =3D &vi->sq[i];
> +
> +=09=09if (!netif_xmit_stopped(netdev_get_tx_queue(dev, i))) {
> +=09=09=09netdev_warn(dev, " Available send queue: %d, sq: %s, vq: %d, na=
me: %s\n",
> +=09=09=09=09    i, sq->name, sq->vq->index, sq->vq->name);

What does this mean?

> +=09=09=09continue;
> +=09=09}
> +
> +=09=09u64_stats_update_begin(&sq->stats.syncp);
> +=09=09sq->stats.tx_timeouts++;
> +=09=09u64_stats_update_end(&sq->stats.syncp);
> +
> +=09=09netdev_warn(dev, " Unavailable send queue: %d, sq: %s, vq: %d, nam=
e: %s\n",
> +=09=09=09    i, sq->name, sq->vq->index, sq->vq->name);
> +=09}

Can we make the warning less cryptic?
I wonder why don't we get the sq from timeout directly?
Would seem cleaner.

> +
> +=09schedule_work(&vi->reset_work);
> +}
> +
>  static const struct net_device_ops virtnet_netdev =3D {
>  =09.ndo_open            =3D virtnet_open,
>  =09.ndo_stop   =09     =3D virtnet_close,
> @@ -2593,6 +2627,7 @@ static const struct net_device_ops virtnet_netdev =
=3D {
>  =09.ndo_features_check=09=3D passthru_features_check,
>  =09.ndo_get_phys_port_name=09=3D virtnet_get_phys_port_name,
>  =09.ndo_set_features=09=3D virtnet_set_features,
> +=09.ndo_tx_timeout=09=09=3D virtnet_tx_timeout,
>  };
> =20
>  static void virtnet_config_changed_work(struct work_struct *work)
> @@ -2982,6 +3017,62 @@ static int virtnet_validate(struct virtio_device *=
vdev)
>  =09return 0;
>  }
> =20
> +static void _remove_vq_common(struct virtnet_info *vi)
> +{
> +=09vi->vdev->config->reset(vi->vdev);
> +
> +=09/* Free unused buffers in both send and recv, if any. */
> +=09free_unused_bufs(vi);
> +
> +=09_free_receive_bufs(vi);
> +
> +=09free_receive_page_frags(vi);
> +
> +=09virtnet_del_vqs(vi);
> +}
> +
> +static int _virtnet_reset(struct virtnet_info *vi)
> +{
> +=09struct virtio_device *vdev =3D vi->vdev;
> +=09int ret;
> +
> +=09virtio_config_disable(vdev);
> +=09vdev->failed =3D vdev->config->get_status(vdev) & VIRTIO_CONFIG_S_FAI=
LED;
> +
> +=09virtnet_freeze_down(vdev);
> +=09_remove_vq_common(vi);
> +
> +=09virtio_add_status(vdev, VIRTIO_CONFIG_S_ACKNOWLEDGE);
> +=09virtio_add_status(vdev, VIRTIO_CONFIG_S_DRIVER);
> +
> +=09ret =3D virtio_finalize_features(vdev);
> +=09if (ret)
> +=09=09goto err;
> +
> +=09ret =3D virtnet_restore_up(vdev);
> +=09if (ret)
> +=09=09goto err;
> +
> +=09ret =3D _virtnet_set_queues(vi, vi->curr_queue_pairs);
> +=09if (ret)
> +=09=09goto err;
> +
> +=09virtio_add_status(vdev, VIRTIO_CONFIG_S_DRIVER_OK);
> +=09virtio_config_enable(vdev);


Is this enough? E.g. all RX mode programming has been lost.



> +=09return 0;
> +err:
> +=09virtio_add_status(vdev, VIRTIO_CONFIG_S_FAILED);
> +=09return ret;
> +}
> +
> +static void virtnet_reset(struct work_struct *work)
> +{
> +=09struct virtnet_info *vi =3D
> +=09=09container_of(work, struct virtnet_info, reset_work);
> +
> +=09_virtnet_reset(vi);
> +}
> +
>  static int virtnet_probe(struct virtio_device *vdev)
>  {
>  =09int i, err =3D -ENOMEM;
> @@ -3011,6 +3102,7 @@ static int virtnet_probe(struct virtio_device *vdev=
)
>  =09dev->netdev_ops =3D &virtnet_netdev;
>  =09dev->features =3D NETIF_F_HIGHDMA;
> =20
> +=09dev->watchdog_timeo =3D 5 * HZ;
>  =09dev->ethtool_ops =3D &virtnet_ethtool_ops;
>  =09SET_NETDEV_DEV(dev, &vdev->dev);
>

Is there a way to make this tuneable from ethtool?
 =20
> @@ -3068,6 +3160,7 @@ static int virtnet_probe(struct virtio_device *vdev=
)
>  =09vdev->priv =3D vi;
> =20
>  =09INIT_WORK(&vi->config_work, virtnet_config_changed_work);
> +=09INIT_WORK(&vi->reset_work, virtnet_reset);
> =20
>  =09/* If we can receive ANY GSO packets, we must allocate large ones. */
>  =09if (virtio_has_feature(vdev, VIRTIO_NET_F_GUEST_TSO4) ||
> --=20
> 2.17.1

