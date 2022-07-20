Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 385B957B343
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 10:53:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231460AbiGTIxo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 04:53:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232701AbiGTIx3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 04:53:29 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D893F45F4B
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 01:53:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658307206;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=yw9+hYBLyb7zrnv6oE4y0ghHyyt5//MfaBbKnM6/8sA=;
        b=hwsFKlsdQunGSsKnJjuHGQZzWACKYDirNsckRgSDmlK3KWaHU3KNbjEnqZ4Iubp9UMBLb7
        aPgO7xO1g4Oi4aF7aTTTS8qUuLd7ZOlKzN8FjjjFrPQ7C8vHesI8BtKK/weuIRB3lojEmc
        Vgj03NzA95uRjImQ20GCJaDjpsAOiPI=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-650-wOd4dtotPEyacywxQR-dZQ-1; Wed, 20 Jul 2022 04:53:19 -0400
X-MC-Unique: wOd4dtotPEyacywxQR-dZQ-1
Received: by mail-lf1-f69.google.com with SMTP id b7-20020a0565120b8700b004890b28f7c8so6478278lfv.7
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 01:53:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yw9+hYBLyb7zrnv6oE4y0ghHyyt5//MfaBbKnM6/8sA=;
        b=QhpZuKFHotf9zQapCPkUsZVfoXSTMCiHX1QVxIrsFNjnAlnbIgj74uzLjtTVD12Hzw
         wVVLvYfJmsGvS9RSiNv91A+zLFylyx2H/cabwTpQ8yYdTL7/MM6Qo5k2sdYwy0sstiiS
         p4g09YW6qaJL0B66JXQS8fuz9+8nc3bmeP3S0biJvcNNexvt6g2R8DWCxrMNkX7jI/yz
         4b/WzfRTr63SRZ+li5UEZ8OMVH2d6+ZsjUROJe0MuXWlr+WEjgxXS3iCgYLQl2267FdG
         7dghXuFk9UMlrYQOwFbvycZ88qmPUU63hEYiXZugooL/xVUdLIxhLFp3VXL6edtvCqGv
         NhZA==
X-Gm-Message-State: AJIora91wbm6JPT3hAs1ajt/FnwmjGepjGlZDMp6cE1LRzhqeRekfuC2
        bAVukOXaLyx2bDhci5RHH+arzVMtDu/DLE8KXFV+f5UM0OE32PSnbs8LuHD0zp8rQsKlNqQWjZh
        VaC8/a8l3XpCGVoYQkvW1u9LWEVSE7hEl
X-Received: by 2002:ac2:50d1:0:b0:489:fb36:cde1 with SMTP id h17-20020ac250d1000000b00489fb36cde1mr18329135lfm.411.1658307197785;
        Wed, 20 Jul 2022 01:53:17 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1s90jdQOS8ZoEkOOo8ZBSPZOEFJF7eOI+wuWQqC+bZO9sdfVY0flMhESunrmBtDumWRlzbJ7OQfoleY3RpH5Kc=
X-Received: by 2002:ac2:50d1:0:b0:489:fb36:cde1 with SMTP id
 h17-20020ac250d1000000b00489fb36cde1mr18329123lfm.411.1658307197509; Wed, 20
 Jul 2022 01:53:17 -0700 (PDT)
MIME-Version: 1.0
References: <20220718091102.498774-1-alvaro.karsz@solid-run.com> <20220720020744-mutt-send-email-mst@kernel.org>
In-Reply-To: <20220720020744-mutt-send-email-mst@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Date:   Wed, 20 Jul 2022 16:52:54 +0800
Message-ID: <CACGkMEvHbYET7zFnn32k8kvENdRRJ-czEZKWKSEJs3oCGO6BZA@mail.gmail.com>
Subject: Re: [PATCH net-next v4] net: virtio_net: notifications coalescing support
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Alvaro Karsz <alvaro.karsz@solid-run.com>,
        netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 20, 2022 at 2:28 PM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> On Mon, Jul 18, 2022 at 12:11:02PM +0300, Alvaro Karsz wrote:
> > New VirtIO network feature: VIRTIO_NET_F_NOTF_COAL.
> >
> > Control a Virtio network device notifications coalescing parameters
> > using the control virtqueue.
> >
> > A device that supports this fetature can receive
> > VIRTIO_NET_CTRL_NOTF_COAL control commands.
> >
> > - VIRTIO_NET_CTRL_NOTF_COAL_TX_SET:
> >   Ask the network device to change the following parameters:
> >   - tx_usecs: Maximum number of usecs to delay a TX notification.
> >   - tx_max_packets: Maximum number of packets to send before a
> >     TX notification.
> >
> > - VIRTIO_NET_CTRL_NOTF_COAL_RX_SET:
> >   Ask the network device to change the following parameters:
> >   - rx_usecs: Maximum number of usecs to delay a RX notification.
> >   - rx_max_packets: Maximum number of packets to receive before a
> >     RX notification.
> >
> > VirtIO spec. patch:
> > https://lists.oasis-open.org/archives/virtio-comment/202206/msg00100.html
> >
> > Signed-off-by: Alvaro Karsz <alvaro.karsz@solid-run.com>
> > ---
> > v2:
> >       - Fix type assignments warnings found with sparse.
> >       - Fix a few typos.
> >
> > v3:
> >   - Change the coalescing parameters in a dedicated function.
> >   - Return -EBUSY from the set coalescing function when the device's
> >     link is up, even if the notifications coalescing feature is negotiated.
> >
> > v4:
> >   - If link is up and we need to update NAPI weight, return -EBUSY before
> >     sending the coalescing commands to the device
>
> Thanks! some comments below
>
> > ---
> >  drivers/net/virtio_net.c        | 111 +++++++++++++++++++++++++++-----
> >  include/uapi/linux/virtio_net.h |  34 +++++++++-
> >  2 files changed, 129 insertions(+), 16 deletions(-)
> >
> > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > index 356cf8dd416..4fde66bd511 100644
> > --- a/drivers/net/virtio_net.c
> > +++ b/drivers/net/virtio_net.c
> > @@ -261,6 +261,12 @@ struct virtnet_info {
> >       u8 duplex;
> >       u32 speed;
> >
> > +     /* Interrupt coalescing settings */
> > +     u32 tx_usecs;
> > +     u32 rx_usecs;
> > +     u32 tx_max_packets;
> > +     u32 rx_max_packets;
> > +
> >       unsigned long guest_offloads;
> >       unsigned long guest_offloads_capable;
> >
> > @@ -2587,27 +2593,89 @@ static int virtnet_get_link_ksettings(struct net_device *dev,
> >       return 0;
> >  }
> >
> > +static int virtnet_send_notf_coal_cmds(struct virtnet_info *vi,
> > +                                    struct ethtool_coalesce *ec)
> > +{
> > +     struct scatterlist sgs_tx, sgs_rx;
> > +     struct virtio_net_ctrl_coal_tx coal_tx;
> > +     struct virtio_net_ctrl_coal_rx coal_rx;
> > +
> > +     coal_tx.tx_usecs = cpu_to_le32(ec->tx_coalesce_usecs);
> > +     coal_tx.tx_max_packets = cpu_to_le32(ec->tx_max_coalesced_frames);
> > +     sg_init_one(&sgs_tx, &coal_tx, sizeof(coal_tx));
> > +
> > +     if (!virtnet_send_command(vi, VIRTIO_NET_CTRL_NOTF_COAL,
> > +                               VIRTIO_NET_CTRL_NOTF_COAL_TX_SET,
> > +                               &sgs_tx))
> > +             return -EINVAL;
> > +
> > +     /* Save parameters */
> > +     vi->tx_usecs = ec->tx_coalesce_usecs;
> > +     vi->tx_max_packets = ec->tx_max_coalesced_frames;
> > +
> > +     coal_rx.rx_usecs = cpu_to_le32(ec->rx_coalesce_usecs);
> > +     coal_rx.rx_max_packets = cpu_to_le32(ec->rx_max_coalesced_frames);
> > +     sg_init_one(&sgs_rx, &coal_rx, sizeof(coal_rx));
> > +
> > +     if (!virtnet_send_command(vi, VIRTIO_NET_CTRL_NOTF_COAL,
> > +                               VIRTIO_NET_CTRL_NOTF_COAL_RX_SET,
> > +                               &sgs_rx))
> > +             return -EINVAL;
> > +
> > +     /* Save parameters */
> > +     vi->rx_usecs = ec->rx_coalesce_usecs;
> > +     vi->rx_max_packets = ec->rx_max_coalesced_frames;
> > +
> > +     return 0;
> > +}
> > +
> > +static int virtnet_coal_params_supported(struct ethtool_coalesce *ec)
> > +{
> > +     /* usecs coalescing is supported only if VIRTIO_NET_F_NOTF_COAL
> > +      * feature is negotiated.
> > +      */
> > +     if (ec->rx_coalesce_usecs || ec->tx_coalesce_usecs)
> > +             return -EOPNOTSUPP;
> > +
> > +     if (ec->tx_max_coalesced_frames > 1 ||
> > +         ec->rx_max_coalesced_frames != 1)
> > +             return -EINVAL;
> > +
> > +     return 0;
> > +}
> > +
> >  static int virtnet_set_coalesce(struct net_device *dev,
> >                               struct ethtool_coalesce *ec,
> >                               struct kernel_ethtool_coalesce *kernel_coal,
> >                               struct netlink_ext_ack *extack)
> >  {
> >       struct virtnet_info *vi = netdev_priv(dev);
> > -     int i, napi_weight;
> > -
> > -     if (ec->tx_max_coalesced_frames > 1 ||
> > -         ec->rx_max_coalesced_frames != 1)
> > -             return -EINVAL;
> > +     int ret, i, napi_weight;
> > +     bool update_napi = false;
> >
> > +     /* Can't change NAPI weight if the link is up */
> >       napi_weight = ec->tx_max_coalesced_frames ? NAPI_POLL_WEIGHT : 0;
>
> Hmm. we currently (ab)use tx_max_coalesced_frames values 0 and 1 to mean tx napi on/off.
> However I am not sure we should treat any value != 1 as napi on.
>
> I don't really have good ideas - I think abusing coalescing might
> have been a mistake. But now that we are there, I feel we need
> a way for userspace to at least be able to figure out whether
> setting coalescing to 0 will have nasty side effects.
>
> For example, here's a problem:
>
> - according to spec, all values are reset to 0
> - userspace reads coalescing values and gets 0
>
> Does this mean napi is off?
>
> And now that we support colescing, I wonder how is user going to control napi.

I think we probably don't want to let users know about NAPI. And
actually, tx NAPI is a byproduct of the tx notification.

Historically, we don't use tx interrupts but skb_orphan() unless the
queue is about to be full. But it tends to cause a lot of side
effects. Then we try to enable tx interrupt with tx NAPI, but in order
to not have performance regression, we enable it via ethtool
(tx-max-coalesce-frames).  Setting 1 means the driver wants to be
notified for each sent packet, tx NAPI is a must in this case.

Note that the tx notification (NAPI) has been enabled by default for
years. If you have concern, I wonder if it's the time to drop
skb_orphan() completely from virtio-net driver. Then we will be fine?

Thanks

>
> It's also a bit of a spec defect that it does not document corner cases
> like what do 0 values do, are they different from 1? or what are max values.
> Not too late to fix?
>
>
> >       if (napi_weight ^ vi->sq[0].napi.weight) {
> >               if (dev->flags & IFF_UP)
> >                       return -EBUSY;
> > +             else
> > +                     update_napi = true;
> > +     }
> > +
> > +     if (virtio_has_feature(vi->vdev, VIRTIO_NET_F_NOTF_COAL))
> > +             ret = virtnet_send_notf_coal_cmds(vi, ec);
> > +     else
> > +             ret = virtnet_coal_params_supported(ec);
> > +
> > +     if (ret)
> > +             return ret;
> > +
> > +     if (update_napi) {
> >               for (i = 0; i < vi->max_queue_pairs; i++)
> >                       vi->sq[i].napi.weight = napi_weight;
> >       }
> >
> > -     return 0;
> > +     return ret;
>
>
> >  }
> >
> >  static int virtnet_get_coalesce(struct net_device *dev,
> > @@ -2615,16 +2683,19 @@ static int virtnet_get_coalesce(struct net_device *dev,
> >                               struct kernel_ethtool_coalesce *kernel_coal,
> >                               struct netlink_ext_ack *extack)
> >  {
> > -     struct ethtool_coalesce ec_default = {
> > -             .cmd = ETHTOOL_GCOALESCE,
> > -             .rx_max_coalesced_frames = 1,
> > -     };
> >       struct virtnet_info *vi = netdev_priv(dev);
> >
> > -     memcpy(ec, &ec_default, sizeof(ec_default));
> > +     if (virtio_has_feature(vi->vdev, VIRTIO_NET_F_NOTF_COAL)) {
> > +             ec->rx_coalesce_usecs = vi->rx_usecs;
> > +             ec->tx_coalesce_usecs = vi->tx_usecs;
> > +             ec->tx_max_coalesced_frames = vi->tx_max_packets;
> > +             ec->rx_max_coalesced_frames = vi->rx_max_packets;
> > +     } else {
> > +             ec->rx_max_coalesced_frames = 1;
> >
> > -     if (vi->sq[0].napi.weight)
> > -             ec->tx_max_coalesced_frames = 1;
> > +             if (vi->sq[0].napi.weight)
> > +                     ec->tx_max_coalesced_frames = 1;
> > +     }
> >
> >       return 0;
> >  }
> > @@ -2743,7 +2814,8 @@ static int virtnet_set_rxnfc(struct net_device *dev, struct ethtool_rxnfc *info)
> >  }
> >
> >  static const struct ethtool_ops virtnet_ethtool_ops = {
> > -     .supported_coalesce_params = ETHTOOL_COALESCE_MAX_FRAMES,
> > +     .supported_coalesce_params = ETHTOOL_COALESCE_MAX_FRAMES |
> > +             ETHTOOL_COALESCE_USECS,
> >       .get_drvinfo = virtnet_get_drvinfo,
> >       .get_link = ethtool_op_get_link,
> >       .get_ringparam = virtnet_get_ringparam,
> > @@ -3411,6 +3483,8 @@ static bool virtnet_validate_features(struct virtio_device *vdev)
> >            VIRTNET_FAIL_ON(vdev, VIRTIO_NET_F_RSS,
> >                            "VIRTIO_NET_F_CTRL_VQ") ||
> >            VIRTNET_FAIL_ON(vdev, VIRTIO_NET_F_HASH_REPORT,
> > +                          "VIRTIO_NET_F_CTRL_VQ") ||
> > +          VIRTNET_FAIL_ON(vdev, VIRTIO_NET_F_NOTF_COAL,
> >                            "VIRTIO_NET_F_CTRL_VQ"))) {
> >               return false;
> >       }
> > @@ -3546,6 +3620,13 @@ static int virtnet_probe(struct virtio_device *vdev)
> >       if (virtio_has_feature(vdev, VIRTIO_NET_F_MRG_RXBUF))
> >               vi->mergeable_rx_bufs = true;
> >
> > +     if (virtio_has_feature(vi->vdev, VIRTIO_NET_F_NOTF_COAL)) {
> > +             vi->rx_usecs = 0;
> > +             vi->tx_usecs = 0;
> > +             vi->tx_max_packets = 0;
> > +             vi->rx_max_packets = 0;
> > +     }
> > +
> >       if (virtio_has_feature(vdev, VIRTIO_NET_F_HASH_REPORT))
> >               vi->has_rss_hash_report = true;
> >
> > @@ -3780,7 +3861,7 @@ static struct virtio_device_id id_table[] = {
> >       VIRTIO_NET_F_CTRL_MAC_ADDR, \
> >       VIRTIO_NET_F_MTU, VIRTIO_NET_F_CTRL_GUEST_OFFLOADS, \
> >       VIRTIO_NET_F_SPEED_DUPLEX, VIRTIO_NET_F_STANDBY, \
> > -     VIRTIO_NET_F_RSS, VIRTIO_NET_F_HASH_REPORT
> > +     VIRTIO_NET_F_RSS, VIRTIO_NET_F_HASH_REPORT, VIRTIO_NET_F_NOTF_COAL
> >
> >  static unsigned int features[] = {
> >       VIRTNET_FEATURES,
> > diff --git a/include/uapi/linux/virtio_net.h b/include/uapi/linux/virtio_net.h
> > index 3f55a4215f1..29ced55514d 100644
> > --- a/include/uapi/linux/virtio_net.h
> > +++ b/include/uapi/linux/virtio_net.h
> > @@ -56,7 +56,7 @@
> >  #define VIRTIO_NET_F_MQ      22      /* Device supports Receive Flow
> >                                        * Steering */
> >  #define VIRTIO_NET_F_CTRL_MAC_ADDR 23        /* Set MAC address */
> > -
> > +#define VIRTIO_NET_F_NOTF_COAL       53      /* Guest can handle notifications coalescing */
>
> So the spec says
>         Device supports notifications coalescing.
>
> which makes more sense - there's not a lot guest needs to do here.
>
>
> >  #define VIRTIO_NET_F_HASH_REPORT  57 /* Supports hash report */
> >  #define VIRTIO_NET_F_RSS       60    /* Supports RSS RX steering */
> >  #define VIRTIO_NET_F_RSC_EXT   61    /* extended coalescing info */
> > @@ -355,4 +355,36 @@ struct virtio_net_hash_config {
> >  #define VIRTIO_NET_CTRL_GUEST_OFFLOADS   5
> >  #define VIRTIO_NET_CTRL_GUEST_OFFLOADS_SET        0
> >
> > +/*
> > + * Control notifications coalescing.
> > + *
> > + * Request the device to change the notifications coalescing parameters.
> > + *
> > + * Available with the VIRTIO_NET_F_NOTF_COAL feature bit.
> > + */
> > +#define VIRTIO_NET_CTRL_NOTF_COAL            6
> > +/*
> > + * Set the tx-usecs/tx-max-packets patameters.
>
> parameters?
>
> > + * tx-usecs - Maximum number of usecs to delay a TX notification.
> > + * tx-max-packets - Maximum number of packets to send before a TX notification.
>
> why with dash here? And why not just put the comments near the fields
> themselves?
>
> > + */
> > +struct virtio_net_ctrl_coal_tx {
> > +     __le32 tx_max_packets;
> > +     __le32 tx_usecs;
> > +};
> > +
> > +#define VIRTIO_NET_CTRL_NOTF_COAL_TX_SET             0
> > +
> > +/*
> > + * Set the rx-usecs/rx-max-packets patameters.
> > + * rx-usecs - Maximum number of usecs to delay a RX notification.
> > + * rx-max-frames - Maximum number of packets to receive before a RX notification.
> > + */
> > +struct virtio_net_ctrl_coal_rx {
> > +     __le32 rx_max_packets;
> > +     __le32 rx_usecs;
> > +};
>
> same comments
>
> > +
> > +#define VIRTIO_NET_CTRL_NOTF_COAL_RX_SET             1
> > +
> >  #endif /* _UAPI_LINUX_VIRTIO_NET_H */
> > --
> > 2.32.0
>

