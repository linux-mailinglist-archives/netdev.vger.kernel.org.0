Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 047DE45408F
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 07:03:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233479AbhKQGEq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 01:04:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233443AbhKQGEp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Nov 2021 01:04:45 -0500
Received: from mail-oi1-x233.google.com (mail-oi1-x233.google.com [IPv6:2607:f8b0:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A6CFC061746
        for <netdev@vger.kernel.org>; Tue, 16 Nov 2021 22:01:47 -0800 (PST)
Received: by mail-oi1-x233.google.com with SMTP id u74so3977972oie.8
        for <netdev@vger.kernel.org>; Tue, 16 Nov 2021 22:01:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YULRHF2CiCtX3DY/myiv54MiA/QzOKJmXbNEGeZktA8=;
        b=f/U/k92Pxfjsh8QT1ZdQ0KVc9tXpoOooptlOa8x7KcxgwEtb9mB0lYn0OOXTIoAaZO
         uAztkKuXny1WgWfWrBArTQ3XYcjb1rMk4tNds0FRBE1ydwWvgw7z5sAWm6jvG9ZFq7TE
         ukET8il3/MU3M/+1qsKY9+tGuTO+hMNQejpYRm10aBeH933aYVWfj3vPV8qsaKGselvZ
         lbtmpsgj93SvZiXAZJFj9oeagSxJ/syv/zKbPBqZC4ctPteEIY7RgW9hlDga9Bz45xQv
         ZEtHgCgBfSJ5zojmwry+l4dNZXdGA2EYOwY87niqTBVu+v45jeW4PD27lsOHjABePZMf
         MNAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YULRHF2CiCtX3DY/myiv54MiA/QzOKJmXbNEGeZktA8=;
        b=RQ7Jv3PQR1JJbFbvaMjZV9nQpo96Em56FkTgmcFszgU/BSKfW89vhvd2voA+iXrYUb
         kb/3F/Mgld4fsP3+M0W6YRzHp9eSZuUG+ULH0NZOZSevjqvCVFenqDE1dTxsIltAt8nC
         uO+Qr/iMtdS/YmJNd0B/jUwdYtWcxq23ZVlQmtIFVGjOqpXw3tDM7yRPihLQFRXNkVwP
         xY8JW8wHTSeoI3nmPO4xq5VJ19niWzuaout6dCy6ndPo+KRgt7UKRxHrv3YnkSwOpZK5
         m/IBXaKYiB7KDFOQ6HNYRzonskVGhmIncPXS0YCYJtZtlvxEU0Xdh+z3akLj6LOZFBu1
         SXXQ==
X-Gm-Message-State: AOAM531PVGn3JDVlCXPNq4D9WHY1TT4/N78+xKYT+xnZoGdOwJMgpmlD
        mqbb2bMiIqbfKrUSirdtrGc/zzlAB/y42sbHm5xMOw==
X-Google-Smtp-Source: ABdhPJyn4jbVoTsJaL7DxG+L3WPh3uXLicbww4m05OoQBRFLb5YY7aUrOtht9xc6rvn3skNEMCJEu87rcak/ps30SSY=
X-Received: by 2002:a05:6808:168d:: with SMTP id bb13mr11739112oib.94.1637128906871;
 Tue, 16 Nov 2021 22:01:46 -0800 (PST)
MIME-Version: 1.0
References: <20211031045959.143001-1-andrew@daynix.com> <20211031045959.143001-4-andrew@daynix.com>
 <CA+FuTScq-B9tXjV8qO5oBpFGObhGGZDSXC+iRMxwH89TvEhexw@mail.gmail.com>
In-Reply-To: <CA+FuTScq-B9tXjV8qO5oBpFGObhGGZDSXC+iRMxwH89TvEhexw@mail.gmail.com>
From:   Andrew Melnichenko <andrew@daynix.com>
Date:   Wed, 17 Nov 2021 08:00:00 +0200
Message-ID: <CABcq3pFDw_-ZKkaE4CghJ11ks2tkcOhcRb_31-kfxd+msOCbKg@mail.gmail.com>
Subject: Re: [RFC PATCH 3/4] drivers/net/virtio_net: Added basic RSS support.
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>, davem@davemloft.net,
        kuba@kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yuri Benditovich <yuri.benditovich@daynix.com>,
        Yan Vugenfirer <yan@daynix.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 31, 2021 at 5:33 PM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
>
> On Sun, Oct 31, 2021 at 1:00 AM Andrew Melnychenko <andrew@daynix.com> wrote:
> >
> > Added features for RSS and RSS hash report.
> > Added initialization, RXHASH feature and ethtool ops.
> > By default RSS/RXHASH is disabled.
> > Added ethtools ops to set key and indirection table.
> >
> > Signed-off-by: Andrew Melnychenko <andrew@daynix.com>
> > ---
> >  drivers/net/virtio_net.c | 232 +++++++++++++++++++++++++++++++++++++--
> >  1 file changed, 223 insertions(+), 9 deletions(-)
> >
> > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > index abca2e93355d..cff7340f40bb 100644
> > --- a/drivers/net/virtio_net.c
> > +++ b/drivers/net/virtio_net.c
> > @@ -167,6 +167,28 @@ struct receive_queue {
> >         struct xdp_rxq_info xdp_rxq;
> >  };
> >
> > +/* This structure can contain rss message with maximum settings for indirection table and keysize
> > + * Note, that default structure that describes RSS configuration virtio_net_rss_config
> > + * contains same info but can't handle table values.
> > + * In any case, structure would be passed to virtio hw through sg_buf split by parts
> > + * because table sizes may be differ according to the device configuration.
> > + */
> > +#define VIRTIO_NET_RSS_MAX_KEY_SIZE     40
>
> Unless there is a technical reason, this probably should be no shorter
> than TOEPLITZ_KEY_LEN

Well yeah, technically if the device requests for shorter key, we
still may provide it.
I think we may check and 'disable' RSS if some configurations are inadequate.

>
> > +#define VIRTIO_NET_RSS_MAX_TABLE_LEN    128
> > +struct virtio_net_ctrl_rss {
> > +       struct {
> > +               __le32 hash_types;
> > +               __le16 indirection_table_mask;
> > +               __le16 unclassified_queue;
>
> Is this explicit variable needed?

Yes, it's a part of the message to be sent to the device.

>
> > +       } __packed table_info;
> > +       u16 indirection_table[VIRTIO_NET_RSS_MAX_TABLE_LEN];
> > +       struct {
> > +               u16 max_tx_vq; /* queues */
> > +               u8 hash_key_length;
> > +       } __packed key_info;
> > +       u8 key[VIRTIO_NET_RSS_MAX_KEY_SIZE];
> > +};
> > +
> >  /* Control VQ buffers: protected by the rtnl lock */
> >  struct control_buf {
> >         struct virtio_net_ctrl_hdr hdr;
> > @@ -176,6 +198,7 @@ struct control_buf {
> >         u8 allmulti;
> >         __virtio16 vid;
> >         __virtio64 offloads;
> > +       struct virtio_net_ctrl_rss rss;
> >  };
> >
> >  struct virtnet_info {
> > @@ -204,6 +227,12 @@ struct virtnet_info {
> >         /* Host will merge rx buffers for big packets (shake it! shake it!) */
> >         bool mergeable_rx_bufs;
> >
> > +       /* Host supports rss and/or hash report */
> > +       bool has_rss;
>
> Superfluous, can be derived form non-zero rss_key_size?

I think that the explicit 'has_rss' field is better. "non-zero
rss_key_size" should work, I'll change RSS derivation in the next
patches.

>
> > +       bool has_rss_hash_report;
> > +       u8 rss_key_size;
> > +       u16 rss_indir_table_size;
> > +
> >         /* Has control virtqueue */
> >         bool has_cvq;
> >
> > @@ -1119,6 +1148,8 @@ static void receive_buf(struct virtnet_info *vi, struct receive_queue *rq,
> >         struct net_device *dev = vi->dev;
> >         struct sk_buff *skb;
> >         struct virtio_net_hdr_mrg_rxbuf *hdr;
> > +       struct virtio_net_hdr_v1_hash *hdr_hash;
> > +       enum pkt_hash_types rss_hash_type;
> >
> >         if (unlikely(len < vi->hdr_len + ETH_HLEN)) {
> >                 pr_debug("%s: short packet %i\n", dev->name, len);
> > @@ -1145,6 +1176,29 @@ static void receive_buf(struct virtnet_info *vi, struct receive_queue *rq,
> >                 return;
> >
> >         hdr = skb_vnet_hdr(skb);
> > +       if (vi->has_rss_hash_report && (dev->features & NETIF_F_RXHASH)) {
>
> Only the second test is needed? It should be impossible to configure
> the feature unless the device advertises has_rss_hash_report

Well, you can have RSS without a hash population. So, need to check,
is the device supports hash population and rxhash is enabled(g.e.
through ethtool).

>
> > +               hdr_hash = (struct virtio_net_hdr_v1_hash *)(hdr);
> > +
> > +               switch (hdr_hash->hash_report) {
> > +               case VIRTIO_NET_HASH_REPORT_TCPv4:
> > +               case VIRTIO_NET_HASH_REPORT_UDPv4:
> > +               case VIRTIO_NET_HASH_REPORT_TCPv6:
> > +               case VIRTIO_NET_HASH_REPORT_UDPv6:
> > +               case VIRTIO_NET_HASH_REPORT_TCPv6_EX:
> > +               case VIRTIO_NET_HASH_REPORT_UDPv6_EX:
> > +                       rss_hash_type = PKT_HASH_TYPE_L4;
> > +                       break;
> > +               case VIRTIO_NET_HASH_REPORT_IPv4:
> > +               case VIRTIO_NET_HASH_REPORT_IPv6:
> > +               case VIRTIO_NET_HASH_REPORT_IPv6_EX:
> > +                       rss_hash_type = PKT_HASH_TYPE_L3;
> > +                       break;
> > +               case VIRTIO_NET_HASH_REPORT_NONE:
> > +               default:
> > +                       rss_hash_type = PKT_HASH_TYPE_NONE;
> > +               }
>
> Is this detailed protocol typing necessary? Most devices only pass a bit is_l4.

Yes, in theory, there is real hardware that may support only L3 hash
calculations.

>
> > +               skb_set_hash(skb, hdr_hash->hash_value, rss_hash_type);
> > +       }
> >
> >         if (hdr->hdr.flags & VIRTIO_NET_HDR_F_DATA_VALID)
> >                 skb->ip_summed = CHECKSUM_UNNECESSARY;
> > @@ -2167,6 +2221,57 @@ static void virtnet_get_ringparam(struct net_device *dev,
> >         ring->tx_pending = ring->tx_max_pending;
> >  }
> >
> > +static bool virtnet_commit_rss_command(struct virtnet_info *vi)
> > +{
> > +       struct net_device *dev = vi->dev;
> > +       struct scatterlist sgs[4];
> > +       unsigned int sg_buf_size;
> > +
> > +       /* prepare sgs */
> > +       sg_init_table(sgs, 4);
> > +
> > +       sg_buf_size = sizeof(vi->ctrl->rss.table_info);
> > +       sg_set_buf(&sgs[0], &vi->ctrl->rss.table_info, sg_buf_size);
> > +
> > +       sg_buf_size = sizeof(uint16_t) * vi->rss_indir_table_size;
> > +       sg_set_buf(&sgs[1], vi->ctrl->rss.indirection_table, sg_buf_size);
> > +
> > +       sg_buf_size = sizeof(vi->ctrl->rss.key_info);
> > +       sg_set_buf(&sgs[2], &vi->ctrl->rss.key_info, sg_buf_size);
> > +
> > +       sg_buf_size = vi->rss_key_size;
> > +       sg_set_buf(&sgs[3], vi->ctrl->rss.key, sg_buf_size);
> > +
> > +       if (!virtnet_send_command(vi, VIRTIO_NET_CTRL_MQ,
> > +                                 vi->has_rss ? VIRTIO_NET_CTRL_MQ_RSS_CONFIG
> > +                                 : VIRTIO_NET_CTRL_MQ_HASH_CONFIG, sgs)) {
> > +               dev_warn(&dev->dev, "VIRTIONET issue with committing RSS sgs\n");
> > +               return false;
> > +       }
> > +       return true;
> > +}
> > +
> > +static void virtnet_init_default_rss(struct virtnet_info *vi)
> > +{
> > +       u32 indir_val = 0;
> > +       int i = 0;
> > +
> > +       vi->ctrl->rss.table_info.hash_types = vi->rss_hash_types_supported;
>
> Similar to above, and related to the next patch: is this very detailed
> specification of supported hash types needed? When is this useful? It
> is not customary to specify RSS to that degree.

In theory, there are real devices that implement virtio_net with(or
without) some supported hashes.

>
> > +       vi->rss_hash_types_saved = vi->rss_hash_types_supported;
> > +       vi->ctrl->rss.table_info.indirection_table_mask = vi->rss_indir_table_size - 1;
> > +       vi->ctrl->rss.table_info.unclassified_queue = 0;
> > +
> > +       for (; i < vi->rss_indir_table_size; ++i) {
> > +               indir_val = ethtool_rxfh_indir_default(i, vi->max_queue_pairs);
> > +               vi->ctrl->rss.indirection_table[i] = indir_val;
> > +       }
> > +
> > +       vi->ctrl->rss.key_info.max_tx_vq = vi->curr_queue_pairs;
> > +       vi->ctrl->rss.key_info.hash_key_length = vi->rss_key_size;
> > +
> > +       netdev_rss_key_fill(vi->ctrl->rss.key, vi->rss_key_size);
> > +}
> > +
> >
> >  static void virtnet_get_drvinfo(struct net_device *dev,
> >                                 struct ethtool_drvinfo *info)
> > @@ -2395,6 +2500,71 @@ static void virtnet_update_settings(struct virtnet_info *vi)
> >                 vi->duplex = duplex;
> >  }
> >
> > +static u32 virtnet_get_rxfh_key_size(struct net_device *dev)
> > +{
> > +       return ((struct virtnet_info *)netdev_priv(dev))->rss_key_size;
> > +}
> > +
> > +static u32 virtnet_get_rxfh_indir_size(struct net_device *dev)
> > +{
> > +       return ((struct virtnet_info *)netdev_priv(dev))->rss_indir_table_size;
> > +}
> > +
> > +static int virtnet_get_rxfh(struct net_device *dev, u32 *indir, u8 *key, u8 *hfunc)
> > +{
> > +       struct virtnet_info *vi = netdev_priv(dev);
> > +       int i;
> > +
> > +       if (indir) {
> > +               for (i = 0; i < vi->rss_indir_table_size; ++i)
> > +                       indir[i] = vi->ctrl->rss.indirection_table[i];
> > +       }
> > +
> > +       if (key)
> > +               memcpy(key, vi->ctrl->rss.key, vi->rss_key_size);
> > +
> > +       if (hfunc)
> > +               *hfunc = ETH_RSS_HASH_TOP;
> > +
> > +       return 0;
> > +}
> > +
> > +static int virtnet_set_rxfh(struct net_device *dev, const u32 *indir, const u8 *key, const u8 hfunc)
> > +{
> > +       struct virtnet_info *vi = netdev_priv(dev);
> > +       int i;
> > +
> > +       if (hfunc != ETH_RSS_HASH_NO_CHANGE && hfunc != ETH_RSS_HASH_TOP)
> > +               return -EOPNOTSUPP;
> > +
> > +       if (indir) {
> > +               for (i = 0; i < vi->rss_indir_table_size; ++i)
> > +                       vi->ctrl->rss.indirection_table[i] = indir[i];
> > +       }
> > +       if (key)
> > +               memcpy(vi->ctrl->rss.key, key, vi->rss_key_size);
> > +
> > +       virtnet_commit_rss_command(vi);
> > +
> > +       return 0;
> > +}
> > +
> > +static int virtnet_get_rxnfc(struct net_device *dev, struct ethtool_rxnfc *info, u32 *rule_locs)
> > +{
> > +       struct virtnet_info *vi = netdev_priv(dev);
> > +       int rc = 0;
> > +
> > +       switch (info->cmd) {
> > +       case ETHTOOL_GRXRINGS:
> > +               info->data = vi->curr_queue_pairs;
> > +               break;
> > +       default:
> > +               rc = -EOPNOTSUPP;
> > +       }
> > +
> > +       return rc;
> > +}
> > +
> >  static const struct ethtool_ops virtnet_ethtool_ops = {
> >         .supported_coalesce_params = ETHTOOL_COALESCE_MAX_FRAMES,
> >         .get_drvinfo = virtnet_get_drvinfo,
> > @@ -2410,6 +2580,11 @@ static const struct ethtool_ops virtnet_ethtool_ops = {
> >         .set_link_ksettings = virtnet_set_link_ksettings,
> >         .set_coalesce = virtnet_set_coalesce,
> >         .get_coalesce = virtnet_get_coalesce,
> > +       .get_rxfh_key_size = virtnet_get_rxfh_key_size,
> > +       .get_rxfh_indir_size = virtnet_get_rxfh_indir_size,
> > +       .get_rxfh = virtnet_get_rxfh,
> > +       .set_rxfh = virtnet_set_rxfh,
> > +       .get_rxnfc = virtnet_get_rxnfc,
> >  };
> >
> >  static void virtnet_freeze_down(struct virtio_device *vdev)
> > @@ -3040,7 +3215,10 @@ static bool virtnet_validate_features(struct virtio_device *vdev)
> >                              "VIRTIO_NET_F_CTRL_VQ") ||
> >              VIRTNET_FAIL_ON(vdev, VIRTIO_NET_F_MQ, "VIRTIO_NET_F_CTRL_VQ") ||
> >              VIRTNET_FAIL_ON(vdev, VIRTIO_NET_F_CTRL_MAC_ADDR,
> > -                            "VIRTIO_NET_F_CTRL_VQ"))) {
> > +                            "VIRTIO_NET_F_CTRL_VQ") ||
> > +            VIRTNET_FAIL_ON(vdev, VIRTIO_NET_F_RSS, "VIRTIO_NET_F_RSS") ||
> > +            VIRTNET_FAIL_ON(vdev, VIRTIO_NET_F_HASH_REPORT,
> > +                            "VIRTIO_NET_F_HASH_REPORT"))) {
> >                 return false;
> >         }
> >
> > @@ -3080,13 +3258,14 @@ static int virtnet_probe(struct virtio_device *vdev)
> >         u16 max_queue_pairs;
> >         int mtu;
> >
> > -       /* Find if host supports multiqueue virtio_net device */
> > -       err = virtio_cread_feature(vdev, VIRTIO_NET_F_MQ,
> > -                                  struct virtio_net_config,
> > -                                  max_virtqueue_pairs, &max_queue_pairs);
> > +       /* Find if host supports multiqueue/rss virtio_net device */
> > +       max_queue_pairs = 0;
> > +       if (virtio_has_feature(vdev, VIRTIO_NET_F_MQ) || virtio_has_feature(vdev, VIRTIO_NET_F_RSS))
>
> Is VIRTIO_NET_F_RSS implied by VIRTIO_NET_F_MQ?

MQ and/or RSS sets multiqueue, like so:
>    virtio_net_set_multiqueue(n,
>                              virtio_has_feature(features, VIRTIO_NET_F_RSS) ||
>                              virtio_has_feature(features, VIRTIO_NET_F_MQ));

So, technically it's possible to create a virtual net only with RSS without mq.

>
> > +               max_queue_pairs =
> > +                    virtio_cread16(vdev, offsetof(struct virtio_net_config, max_virtqueue_pairs));
> >
> >         /* We need at least 2 queue's */
> > -       if (err || max_queue_pairs < VIRTIO_NET_CTRL_MQ_VQ_PAIRS_MIN ||
> > +       if (max_queue_pairs < VIRTIO_NET_CTRL_MQ_VQ_PAIRS_MIN ||
> >             max_queue_pairs > VIRTIO_NET_CTRL_MQ_VQ_PAIRS_MAX ||
> >             !virtio_has_feature(vdev, VIRTIO_NET_F_CTRL_VQ))
> >                 max_queue_pairs = 1;
> > @@ -3170,8 +3349,36 @@ static int virtnet_probe(struct virtio_device *vdev)
> >         if (virtio_has_feature(vdev, VIRTIO_NET_F_MRG_RXBUF))
> >                 vi->mergeable_rx_bufs = true;
> >
> > -       if (virtio_has_feature(vdev, VIRTIO_NET_F_MRG_RXBUF) ||
> > -           virtio_has_feature(vdev, VIRTIO_F_VERSION_1))
> > +       if (virtio_has_feature(vdev, VIRTIO_NET_F_HASH_REPORT)) {
> > +               vi->has_rss_hash_report = true;
> > +               vi->rss_indir_table_size = 1;
> > +               vi->rss_key_size = VIRTIO_NET_RSS_MAX_KEY_SIZE;
> > +       }
> > +
> > +       if (virtio_has_feature(vdev, VIRTIO_NET_F_RSS)) {
> > +               vi->has_rss = true;
> > +               vi->rss_indir_table_size =
> > +                       virtio_cread16(vdev, offsetof(struct virtio_net_config,
> > +                                                     rss_max_indirection_table_length));
> > +               vi->rss_key_size =
> > +                       virtio_cread8(vdev, offsetof(struct virtio_net_config, rss_max_key_size));
> > +       }
>
> Please split adding the two features, hash report and rss, into two
> separate patches.

It may provide dead code that will be replaced by code in 'hash
report' report patch.
