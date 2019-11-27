Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E73510AED4
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 12:41:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726593AbfK0Llh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Nov 2019 06:41:37 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:59227 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726204AbfK0Llh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Nov 2019 06:41:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574854895;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nejIEfbAtCMgHuhLkvTXhMe+eNdHihPZTW9qlGkrNow=;
        b=IsXY9n7jqsVGJeho7Lw0WbsETKGyNK/I5hPxQqiUEsObMRweAvq8mDdPtsnAk02WCBu6y1
        ZxPW5u7SJWrzxymQ08mOMm7sbr3Kt8+haFPUU+N/8modwszry2arvwZw1fZk+wSNpKeKcC
        wQrsY/+F5XsxSXQRPtzbV8b/DnJ1ghM=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-225-NWs__KJWPTGDE5zeRVS-tA-1; Wed, 27 Nov 2019 06:41:34 -0500
Received: by mail-wm1-f69.google.com with SMTP id 7so170253wmf.9
        for <netdev@vger.kernel.org>; Wed, 27 Nov 2019 03:41:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=P1cJjKji0So6B4thGa/LNar9QXxaswq3VKsI91/tugQ=;
        b=WOBzTklLtoKLW3fqSBY95txbQUVjIJxI5mKTRRJoCp1S4TiOX/5e7Quqn3pGTw4ljZ
         5ZDybZj9XewzO7jxwWlXG16ZFR7o81pPk/gfne5sRaDKfEO5W2FJcPDa6R3Zr90PX6OS
         H7QbN+iAvFhK8yvY3tErUo4vbPdG3mmW0C5w5Ksdj4K6NKnetpzIh/eWTXSBHoZ5XJKP
         cfIbzO3wjPh5zp0m1S1fwtiaVxyEG29Z/cq/acjiUe0coXdY7DH/c10l7ABta5bNn6EW
         rWhuVDTG6DOzZdE9vMYV/+C6mXRltULEm7PT2uhZpchs4VryPtR2BNQyrCm9Qi68oUif
         uZ4A==
X-Gm-Message-State: APjAAAVoIiKDNmDsoFQ8rEr9Pkf9KAGeugTLTLYkv65Hres73kjnaEGW
        +GWtnsg2Zz5iBHmgLOm+vsMJCEVOgvldsuGviDCuNzbnDoXIsaZkf5GPuzIGpQ9SRn61S6/IhMF
        dXpE7pU1EMYSSH2U7
X-Received: by 2002:adf:ef51:: with SMTP id c17mr45551491wrp.266.1574854893272;
        Wed, 27 Nov 2019 03:41:33 -0800 (PST)
X-Google-Smtp-Source: APXvYqxCq1WvaUvbIvb7/I9iTJLdg/VE1Ls2kgut0WZHM3mD7pgrXN73I2d4jZpdtQWwh9IqoT6Czg==
X-Received: by 2002:adf:ef51:: with SMTP id c17mr45551466wrp.266.1574854892956;
        Wed, 27 Nov 2019 03:41:32 -0800 (PST)
Received: from redhat.com (bzq-79-181-48-215.red.bezeqint.net. [79.181.48.215])
        by smtp.gmail.com with ESMTPSA id l204sm5143703wmf.2.2019.11.27.03.41.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Nov 2019 03:41:32 -0800 (PST)
Date:   Wed, 27 Nov 2019 06:41:29 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Julio Faracco <jcfaracco@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, jasowang@redhat.com,
        virtualization@lists.linux-foundation.org, dnmendes76@gmail.com
Subject: Re: [net-next V3 2/2] drivers: net: virtio_net: Implement a
 dev_watchdog handler
Message-ID: <20191127063939-mutt-send-email-mst@kernel.org>
References: <20191126200628.22251-1-jcfaracco@gmail.com>
 <20191126200628.22251-3-jcfaracco@gmail.com>
MIME-Version: 1.0
In-Reply-To: <20191126200628.22251-3-jcfaracco@gmail.com>
X-MC-Unique: NWs__KJWPTGDE5zeRVS-tA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 26, 2019 at 05:06:28PM -0300, Julio Faracco wrote:
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
> reset all queues, including RX (because we don't have control of this).
>=20
> Signed-off-by: Julio Faracco <jcfaracco@gmail.com>
> Signed-off-by: Daiane Mendes <dnmendes76@gmail.com>
> Cc: Jason Wang <jasowang@redhat.com>
> ---
>  drivers/net/virtio_net.c | 83 +++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 82 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 4d7d5434cc5d..fbe1dfde3a4b 100644
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
> +=09{ "tx_timeouts",        VIRTNET_SQ_STAT(tx_timeouts) },
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
> @@ -2578,6 +2585,21 @@ static int virtnet_set_features(struct net_device =
*dev,
>  =09return 0;
>  }
> =20
> +static void virtnet_tx_timeout(struct net_device *dev, unsigned int txqu=
eue)
> +{
> +=09struct virtnet_info *vi =3D netdev_priv(dev);
> +=09struct send_queue *sq =3D &vi->sq[txqueue];
> +
> +=09netdev_warn(dev, "TX timeout on queue: %d, sq: %s, vq: %d, name: %s\n=
",
> +=09=09    txqueue, sq->name, sq->vq->index, sq->vq->name);
> +
> +=09u64_stats_update_begin(&sq->stats.syncp);
> +=09sq->stats.tx_timeouts++;
> +=09u64_stats_update_end(&sq->stats.syncp);
> +
> +=09schedule_work(&vi->reset_work);
> +}
> +
>  static const struct net_device_ops virtnet_netdev =3D {
>  =09.ndo_open            =3D virtnet_open,
>  =09.ndo_stop   =09     =3D virtnet_close,
> @@ -2593,6 +2615,7 @@ static const struct net_device_ops virtnet_netdev =
=3D {
>  =09.ndo_features_check=09=3D passthru_features_check,
>  =09.ndo_get_phys_port_name=09=3D virtnet_get_phys_port_name,
>  =09.ndo_set_features=09=3D virtnet_set_features,
> +=09.ndo_tx_timeout         =3D virtnet_tx_timeout,
>  };
> =20
>  static void virtnet_config_changed_work(struct work_struct *work)
> @@ -2982,6 +3005,62 @@ static int virtnet_validate(struct virtio_device *=
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
> +=09return 0;
> +err:
> +=09virtio_add_status(vdev, VIRTIO_CONFIG_S_FAILED);
> +=09return ret;


So here, what restores the rest of the device state,
including offloads, RX mode, mac/vlan filters etc?

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
> @@ -3011,6 +3090,7 @@ static int virtnet_probe(struct virtio_device *vdev=
)
>  =09dev->netdev_ops =3D &virtnet_netdev;
>  =09dev->features =3D NETIF_F_HIGHDMA;
> =20
> +=09dev->watchdog_timeo =3D 5 * HZ;
>  =09dev->ethtool_ops =3D &virtnet_ethtool_ops;
>  =09SET_NETDEV_DEV(dev, &vdev->dev);
> =20
> @@ -3068,6 +3148,7 @@ static int virtnet_probe(struct virtio_device *vdev=
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

