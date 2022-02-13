Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D6B94B3C58
	for <lists+netdev@lfdr.de>; Sun, 13 Feb 2022 18:02:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237170AbiBMRCA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Feb 2022 12:02:00 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236091AbiBMRB7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Feb 2022 12:01:59 -0500
Received: from mail-oo1-xc34.google.com (mail-oo1-xc34.google.com [IPv6:2607:f8b0:4864:20::c34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CDC85C378
        for <netdev@vger.kernel.org>; Sun, 13 Feb 2022 09:01:53 -0800 (PST)
Received: by mail-oo1-xc34.google.com with SMTP id u47-20020a4a9732000000b00316d0257de0so16721420ooi.7
        for <netdev@vger.kernel.org>; Sun, 13 Feb 2022 09:01:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=C6XQmRPKZcpraoEuIziq1MNmXWVtnuKiUX2NaQjSZtk=;
        b=KiqSnrtr+OrGFo53DUiWmFdVVdxk67G8laJZRA4EEawrat6KefCyDF31eedpcC40uZ
         8kpPx5h8ueSEPK6bQg3wCr62voLXt1jZhtIzwrUMNX+C04bXFo90AKx6D/46GmU6XP7I
         ROiThHoyBp5xJanAuHbhg7izKZ6Q/wJjdjPp/pAoR3B78fqUjZKXzGiYKYN3fTjY52GY
         vAmwg8dF/Bp9dL9aqiUD9N3Thok1EB3EfrvdP+qyt3iGQhKYwAMo7YT53T2KmH9zsn0o
         W5/2GF0HTA7B05cVOSgyzQOzaqV4H5tY1BRndl6ZHfPV7fYcWEbOv2zLZQ0fxsvbym16
         +G8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=C6XQmRPKZcpraoEuIziq1MNmXWVtnuKiUX2NaQjSZtk=;
        b=fon3aIV8JcfMhGsjAVqLJRjSCsvn+HJBtahBR/C8bJYNlSQtqFJenNkZ48UgMltC1v
         GSLfTigcb3CfQPZXvoqQrrIniFV/m5t3cY+jsqTWMhdrQDVkry3CPMD1fVmuiC77gyKj
         6J2ruldOc69DQ1vdOtDQDbKYVKMZ4ojglF/9qdB6/sDJI7o0w+fLgevcPSTR3K3Cp2pZ
         2yzH5v7gQYcQY7tOsmVpbTwiHtmJ5QxCnsDcim68UMtQgvSd44qvDFsQUT/2l+RCl9kO
         Nk3vzPUTkIUuRRfdy8WzWuNYJS6brrNyMov/CdzK3uGOC2Yo/OxxbkMqgzfs7LxsG0Bh
         Hl/w==
X-Gm-Message-State: AOAM533T821M7i4BRiQdcdLw6YdDrZvlOpID37SGMQ7uGTAZm/HefgFr
        4cL1/c+Bv9fMb2hUuBbFep6Rx+DX5p/X6A3M8pqxhg==
X-Google-Smtp-Source: ABdhPJz9q7PUbqOJXinKPBNylNCiutxqQBV6rAfpz1/BKQxB7vgPMYG+8RPxbopnuucanHDqYbe9rJcUhvFlEsjNmNA=
X-Received: by 2002:a05:6870:4727:: with SMTP id b39mr456604oaq.29.1644771712299;
 Sun, 13 Feb 2022 09:01:52 -0800 (PST)
MIME-Version: 1.0
References: <20220208181510.787069-1-andrew@daynix.com> <20220208181510.787069-3-andrew@daynix.com>
 <CA+FuTSfPq-052=D3GzibMjUNXEcHTz=p87vW_3qU0OH9dDHSPQ@mail.gmail.com>
In-Reply-To: <CA+FuTSfPq-052=D3GzibMjUNXEcHTz=p87vW_3qU0OH9dDHSPQ@mail.gmail.com>
From:   Andrew Melnichenko <andrew@daynix.com>
Date:   Sun, 13 Feb 2022 19:01:39 +0200
Message-ID: <CABcq3pFLXUMi3ctr6WyJMaXbPjKregTzQ2fG1fwDU7tvk2uRFg@mail.gmail.com>
Subject: Re: [PATCH v3 2/4] drivers/net/virtio_net: Added basic RSS support.
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Yan Vugenfirer <yan@daynix.com>,
        Yuri Benditovich <yuri.benditovich@daynix.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

On Tue, Feb 8, 2022 at 10:37 PM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
>
> On Tue, Feb 8, 2022 at 1:19 PM Andrew Melnychenko <andrew@daynix.com> wrote:
> >
> > Added features for RSS.
> > Added initialization, RXHASH feature and ethtool ops.
> > By default RSS/RXHASH is disabled.
> > Virtio RSS "IPv6 extensions" hashes disabled.
> > Added ethtools ops to set key and indirection table.
> >
> > Signed-off-by: Andrew Melnychenko <andrew@daynix.com>
> > ---
> >  drivers/net/virtio_net.c | 191 +++++++++++++++++++++++++++++++++++++--
> >  1 file changed, 185 insertions(+), 6 deletions(-)
> >
> > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > index 1404e683a2fd..495aed524e33 100644
> > --- a/drivers/net/virtio_net.c
> > +++ b/drivers/net/virtio_net.c
> > @@ -169,6 +169,24 @@ struct receive_queue {
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
> Future proof, may want to support larger sizes.
>
> netdevice.h defines NETDEV_RSS_KEY_LEN at 52.
>
> tools/testing/selftests/net/toeplitz.c supports up to 60

According to virtio specification, the length of the key is
40bytes(and an indirection table is 128 entries max).
So for now, we support a maximum of the spec regardless of what the
kernel is capable of.

>
> > +#define VIRTIO_NET_RSS_MAX_TABLE_LEN    128
> > +struct virtio_net_ctrl_rss {
> > +       u32 hash_types;
>
> conversely, u32 is a bit extreme?

No, the structure virtio_net_ctrl_rss is specified by the specification.

>
> > +       u16 indirection_table_mask;
> > +       u16 unclassified_queue;
> > +       u16 indirection_table[VIRTIO_NET_RSS_MAX_TABLE_LEN];
> > +       u16 max_tx_vq;
> > +       u8 hash_key_length;
> > +       u8 key[VIRTIO_NET_RSS_MAX_KEY_SIZE];
> > +};
> > +
> >  /* Control VQ buffers: protected by the rtnl lock */
> >  struct control_buf {
> >         struct virtio_net_ctrl_hdr hdr;
> > @@ -178,6 +196,7 @@ struct control_buf {
> >         u8 allmulti;
> >         __virtio16 vid;
> >         __virtio64 offloads;
> > +       struct virtio_net_ctrl_rss rss;
> >  };
> >
> >  struct virtnet_info {
> > @@ -206,6 +225,12 @@ struct virtnet_info {
> >         /* Host will merge rx buffers for big packets (shake it! shake it!) */
> >         bool mergeable_rx_bufs;
> >
> > +       /* Host supports rss and/or hash report */
> > +       bool has_rss;
> > +       u8 rss_key_size;
> > +       u16 rss_indir_table_size;
> > +       u32 rss_hash_types_supported;
> > +
> >         /* Has control virtqueue */
> >         bool has_cvq;
> >
> > @@ -2184,6 +2209,56 @@ static void virtnet_get_ringparam(struct net_device *dev,
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
> > +       sg_buf_size = offsetof(struct virtio_net_ctrl_rss, indirection_table);
> > +       sg_set_buf(&sgs[0], &vi->ctrl->rss, sg_buf_size);
> > +
> > +       sg_buf_size = sizeof(uint16_t) * vi->rss_indir_table_size;
> > +       sg_set_buf(&sgs[1], vi->ctrl->rss.indirection_table, sg_buf_size);
> > +
> > +       sg_buf_size = offsetof(struct virtio_net_ctrl_rss, key)
> > +                       - offsetof(struct virtio_net_ctrl_rss, max_tx_vq);
> > +       sg_set_buf(&sgs[2], &vi->ctrl->rss.max_tx_vq, sg_buf_size);
> > +
> > +       sg_buf_size = vi->rss_key_size;
> > +       sg_set_buf(&sgs[3], vi->ctrl->rss.key, sg_buf_size);
> > +
> > +       if (!virtnet_send_command(vi, VIRTIO_NET_CTRL_MQ,
> > +                                 VIRTIO_NET_CTRL_MQ_RSS_CONFIG, sgs)) {
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
> > +       vi->ctrl->rss.hash_types = vi->rss_hash_types_supported;
> > +       vi->ctrl->rss.indirection_table_mask = vi->rss_indir_table_size - 1;
>
> Is table size always a power of two?

Yes, it should be.

>
> > +       vi->ctrl->rss.unclassified_queue = 0;
> > +
> > +       for (; i < vi->rss_indir_table_size; ++i) {
> > +               indir_val = ethtool_rxfh_indir_default(i, vi->curr_queue_pairs);
> > +               vi->ctrl->rss.indirection_table[i] = indir_val;
> > +       }
> > +
> > +       vi->ctrl->rss.max_tx_vq = vi->curr_queue_pairs;
> > +       vi->ctrl->rss.hash_key_length = vi->rss_key_size;
> > +
> > +       netdev_rss_key_fill(vi->ctrl->rss.key, vi->rss_key_size);
> > +}
> > +
> >
> >  static void virtnet_get_drvinfo(struct net_device *dev,
> >                                 struct ethtool_drvinfo *info)
> > @@ -2412,6 +2487,71 @@ static void virtnet_update_settings(struct virtnet_info *vi)
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
> > @@ -2427,6 +2567,11 @@ static const struct ethtool_ops virtnet_ethtool_ops = {
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
> > @@ -2679,6 +2824,16 @@ static int virtnet_set_features(struct net_device *dev,
> >                 vi->guest_offloads = offloads;
> >         }
> >
> > +       if ((dev->features ^ features) & NETIF_F_RXHASH) {
> > +               if (features & NETIF_F_RXHASH)
> > +                       vi->ctrl->rss.hash_types = vi->rss_hash_types_supported;
> > +               else
> > +                       vi->ctrl->rss.hash_types = VIRTIO_NET_HASH_REPORT_NONE;
> > +
> > +               if (!virtnet_commit_rss_command(vi))
> > +                       return -EINVAL;
> > +       }
> > +
> >         return 0;
> >  }
> >
> > @@ -3073,6 +3228,8 @@ static bool virtnet_validate_features(struct virtio_device *vdev)
> >                              "VIRTIO_NET_F_CTRL_VQ") ||
> >              VIRTNET_FAIL_ON(vdev, VIRTIO_NET_F_MQ, "VIRTIO_NET_F_CTRL_VQ") ||
> >              VIRTNET_FAIL_ON(vdev, VIRTIO_NET_F_CTRL_MAC_ADDR,
> > +                            "VIRTIO_NET_F_CTRL_VQ") ||
> > +            VIRTNET_FAIL_ON(vdev, VIRTIO_NET_F_RSS,
> >                              "VIRTIO_NET_F_CTRL_VQ"))) {
> >                 return false;
> >         }
> > @@ -3113,13 +3270,14 @@ static int virtnet_probe(struct virtio_device *vdev)
> >         u16 max_queue_pairs;
> >         int mtu;
> >
> > -       /* Find if host supports multiqueue virtio_net device */
> > -       err = virtio_cread_feature(vdev, VIRTIO_NET_F_MQ,
> > -                                  struct virtio_net_config,
> > -                                  max_virtqueue_pairs, &max_queue_pairs);
> > +       /* Find if host supports multiqueue/rss virtio_net device */
> > +       max_queue_pairs = 1;
> > +       if (virtio_has_feature(vdev, VIRTIO_NET_F_MQ) || virtio_has_feature(vdev, VIRTIO_NET_F_RSS))
> > +               max_queue_pairs =
> > +                    virtio_cread16(vdev, offsetof(struct virtio_net_config, max_virtqueue_pairs));
>
> Instead of testing either feature and treating them as somewhat equal,
> shouldn't RSS be dependent on MQ?

No, RSS is dependent on CTRL_VQ. Technically RSS and MQ are similar features.

>
> >
> >         /* We need at least 2 queue's */
> > -       if (err || max_queue_pairs < VIRTIO_NET_CTRL_MQ_VQ_PAIRS_MIN ||
> > +       if (max_queue_pairs < VIRTIO_NET_CTRL_MQ_VQ_PAIRS_MIN ||
> >             max_queue_pairs > VIRTIO_NET_CTRL_MQ_VQ_PAIRS_MAX ||
> >             !virtio_has_feature(vdev, VIRTIO_NET_F_CTRL_VQ))
> >                 max_queue_pairs = 1;
> > @@ -3207,6 +3365,23 @@ static int virtnet_probe(struct virtio_device *vdev)
> >         if (virtio_has_feature(vdev, VIRTIO_NET_F_MRG_RXBUF))
> >                 vi->mergeable_rx_bufs = true;
> >
> > +       if (virtio_has_feature(vdev, VIRTIO_NET_F_RSS)) {
> > +               vi->has_rss = true;
> > +               vi->rss_indir_table_size =
> > +                       virtio_cread16(vdev, offsetof(struct virtio_net_config,
> > +                               rss_max_indirection_table_length));
> > +               vi->rss_key_size =
> > +                       virtio_cread8(vdev, offsetof(struct virtio_net_config, rss_max_key_size));
> > +
> > +               vi->rss_hash_types_supported =
> > +                   virtio_cread32(vdev, offsetof(struct virtio_net_config, supported_hash_types));
> > +               vi->rss_hash_types_supported &=
> > +                               ~(VIRTIO_NET_RSS_HASH_TYPE_IP_EX |
> > +                                 VIRTIO_NET_RSS_HASH_TYPE_TCP_EX |
> > +                                 VIRTIO_NET_RSS_HASH_TYPE_UDP_EX);
> > +
> > +               dev->hw_features |= NETIF_F_RXHASH;
>
> Only make the feature visible when the hash is actually reported in
> the skb, patch 3.

VirtioNET has two features: RSS(steering only) and hash(hash report in
vnet header)
Both features may be enabled/disabled separately:
1. rss on and hash off - packets steered to the corresponding vqs
2. rss off and hash on - packets steered by tap(like mq) but headers
have properly calculated hash.
3. rss on and hash on - packets steered to corresponding vqs and hash
is present in the header.

RXHASH feature allows the user to enable/disable the rss/hash(any combination).
I think it's a good idea to leave RXHASH in patch 2/4 to give the user
ability to manipulate the rss only feature.
But, if you think that it requires to move it to the 3/4, I'll do it.

>
> Also, clearly separate the feature patches (2) rss, (3) rxhash, (4)
> rxhash config.

Currently:
Patch 2/4 - adds VirtioNet rss feature.
Patch 3/4 - adds VirtioNet hash report feature.
Patch 4/4 - adds the ability to manipulate supported hash types.

Can you provide more detailed suggestions on how to move hunks?
