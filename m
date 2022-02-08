Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C02F4AE348
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 23:21:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386780AbiBHWVn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 17:21:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386470AbiBHUhl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 15:37:41 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AC80C0612C0
        for <netdev@vger.kernel.org>; Tue,  8 Feb 2022 12:37:39 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id w14so782286edd.10
        for <netdev@vger.kernel.org>; Tue, 08 Feb 2022 12:37:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OW+l8k2do19la/JXNnlav8oVlWK2sJt3MhQuSFM7S30=;
        b=lL5ReZjQMsAdWfcRmbvR6elnSObq1RPbWc2qqG2arpyoakVIWBoz46ZkAQqDvqgDln
         lb3IS8jO1tP+fwjufsQN7XBhANMoPZBOJOyakGICEeUtHEvMyEju8McygMYjPcU9gfDI
         bi1NHJ6O21q/h8T0FXAOcdZfsUxasKroKReNHkpQvDI65dBaHF+/gTvq1zjnbCK0ImjK
         As5ji22vw52fb8/u2DicrZYlrz3EJjrvZSOfNa4QJeOwp1E58eVoUVorgd8z2fzIqTWB
         zLQL5NfXKWU3H6KBFavLTYMSgOB2L8NGisU9R9OF8CWvDTBTwNbsJe73vSXM3c8ydFKs
         qwYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OW+l8k2do19la/JXNnlav8oVlWK2sJt3MhQuSFM7S30=;
        b=ViBMUiq4K5Hc2tE/PBDYTIzdUXFX5SLN6XNtA5I+VDJb8sO5fo0KqlUs5zz0wXbGUU
         7Ei8Bdc+Tpe+J7Mp7qUrvCSKqIYPpNhkS5m2r5qgB6zRradjJx5e3Pqnh3ntZVQNyPv0
         8apPgNuA1bB4Cp/xbHfoz15nvFE2HNE57xli/tgqteVK5d9qUFtHEno1Lqs/7sqXIafV
         TsCWwaMc2UptCtLwRFW8v+Xs/021qRwth9FTM68Fy0AG26u74MPcHNToD6Hp8BoXoHKn
         C7GW6zf+jzVrwDHHryz37nYQBWV+4Y1Q+odCJgUjfPofH4l9DekNucFrtYpyEuj9+1ew
         E0ng==
X-Gm-Message-State: AOAM531O81F3Gs//9YMdqN1Asu12Y+ctmNqVkrOZ+Xjjmd9+KW3DByA6
        Fv4vd0QT4Ft9V+p/0a8A5rh5gmHZUF/6OQ==
X-Google-Smtp-Source: ABdhPJyjsQulNbd1T1OuVyZkl8NPusarMRgGlB2SPPIFeX/2kOtFx/743ySSpOFSN8O7utyZdMuvtg==
X-Received: by 2002:aa7:d88c:: with SMTP id u12mr188192edq.177.1644352657995;
        Tue, 08 Feb 2022 12:37:37 -0800 (PST)
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com. [209.85.221.42])
        by smtp.gmail.com with ESMTPSA id eg11sm5870815edb.17.2022.02.08.12.37.36
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Feb 2022 12:37:37 -0800 (PST)
Received: by mail-wr1-f42.google.com with SMTP id w11so481891wra.4
        for <netdev@vger.kernel.org>; Tue, 08 Feb 2022 12:37:36 -0800 (PST)
X-Received: by 2002:adf:f905:: with SMTP id b5mr4910731wrr.173.1644352656172;
 Tue, 08 Feb 2022 12:37:36 -0800 (PST)
MIME-Version: 1.0
References: <20220208181510.787069-1-andrew@daynix.com> <20220208181510.787069-3-andrew@daynix.com>
In-Reply-To: <20220208181510.787069-3-andrew@daynix.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 8 Feb 2022 15:36:59 -0500
X-Gmail-Original-Message-ID: <CA+FuTSfPq-052=D3GzibMjUNXEcHTz=p87vW_3qU0OH9dDHSPQ@mail.gmail.com>
Message-ID: <CA+FuTSfPq-052=D3GzibMjUNXEcHTz=p87vW_3qU0OH9dDHSPQ@mail.gmail.com>
Subject: Re: [PATCH v3 2/4] drivers/net/virtio_net: Added basic RSS support.
To:     Andrew Melnychenko <andrew@daynix.com>
Cc:     netdev@vger.kernel.org, virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        jasowang@redhat.com, mst@redhat.com, yan@daynix.com,
        yuri.benditovich@daynix.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 8, 2022 at 1:19 PM Andrew Melnychenko <andrew@daynix.com> wrote:
>
> Added features for RSS.
> Added initialization, RXHASH feature and ethtool ops.
> By default RSS/RXHASH is disabled.
> Virtio RSS "IPv6 extensions" hashes disabled.
> Added ethtools ops to set key and indirection table.
>
> Signed-off-by: Andrew Melnychenko <andrew@daynix.com>
> ---
>  drivers/net/virtio_net.c | 191 +++++++++++++++++++++++++++++++++++++--
>  1 file changed, 185 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 1404e683a2fd..495aed524e33 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -169,6 +169,24 @@ struct receive_queue {
>         struct xdp_rxq_info xdp_rxq;
>  };
>
> +/* This structure can contain rss message with maximum settings for indirection table and keysize
> + * Note, that default structure that describes RSS configuration virtio_net_rss_config
> + * contains same info but can't handle table values.
> + * In any case, structure would be passed to virtio hw through sg_buf split by parts
> + * because table sizes may be differ according to the device configuration.
> + */
> +#define VIRTIO_NET_RSS_MAX_KEY_SIZE     40

Future proof, may want to support larger sizes.

netdevice.h defines NETDEV_RSS_KEY_LEN at 52.

tools/testing/selftests/net/toeplitz.c supports up to 60

> +#define VIRTIO_NET_RSS_MAX_TABLE_LEN    128
> +struct virtio_net_ctrl_rss {
> +       u32 hash_types;

conversely, u32 is a bit extreme?

> +       u16 indirection_table_mask;
> +       u16 unclassified_queue;
> +       u16 indirection_table[VIRTIO_NET_RSS_MAX_TABLE_LEN];
> +       u16 max_tx_vq;
> +       u8 hash_key_length;
> +       u8 key[VIRTIO_NET_RSS_MAX_KEY_SIZE];
> +};
> +
>  /* Control VQ buffers: protected by the rtnl lock */
>  struct control_buf {
>         struct virtio_net_ctrl_hdr hdr;
> @@ -178,6 +196,7 @@ struct control_buf {
>         u8 allmulti;
>         __virtio16 vid;
>         __virtio64 offloads;
> +       struct virtio_net_ctrl_rss rss;
>  };
>
>  struct virtnet_info {
> @@ -206,6 +225,12 @@ struct virtnet_info {
>         /* Host will merge rx buffers for big packets (shake it! shake it!) */
>         bool mergeable_rx_bufs;
>
> +       /* Host supports rss and/or hash report */
> +       bool has_rss;
> +       u8 rss_key_size;
> +       u16 rss_indir_table_size;
> +       u32 rss_hash_types_supported;
> +
>         /* Has control virtqueue */
>         bool has_cvq;
>
> @@ -2184,6 +2209,56 @@ static void virtnet_get_ringparam(struct net_device *dev,
>         ring->tx_pending = ring->tx_max_pending;
>  }
>
> +static bool virtnet_commit_rss_command(struct virtnet_info *vi)
> +{
> +       struct net_device *dev = vi->dev;
> +       struct scatterlist sgs[4];
> +       unsigned int sg_buf_size;
> +
> +       /* prepare sgs */
> +       sg_init_table(sgs, 4);
> +
> +       sg_buf_size = offsetof(struct virtio_net_ctrl_rss, indirection_table);
> +       sg_set_buf(&sgs[0], &vi->ctrl->rss, sg_buf_size);
> +
> +       sg_buf_size = sizeof(uint16_t) * vi->rss_indir_table_size;
> +       sg_set_buf(&sgs[1], vi->ctrl->rss.indirection_table, sg_buf_size);
> +
> +       sg_buf_size = offsetof(struct virtio_net_ctrl_rss, key)
> +                       - offsetof(struct virtio_net_ctrl_rss, max_tx_vq);
> +       sg_set_buf(&sgs[2], &vi->ctrl->rss.max_tx_vq, sg_buf_size);
> +
> +       sg_buf_size = vi->rss_key_size;
> +       sg_set_buf(&sgs[3], vi->ctrl->rss.key, sg_buf_size);
> +
> +       if (!virtnet_send_command(vi, VIRTIO_NET_CTRL_MQ,
> +                                 VIRTIO_NET_CTRL_MQ_RSS_CONFIG, sgs)) {
> +               dev_warn(&dev->dev, "VIRTIONET issue with committing RSS sgs\n");
> +               return false;
> +       }
> +       return true;
> +}
> +
> +static void virtnet_init_default_rss(struct virtnet_info *vi)
> +{
> +       u32 indir_val = 0;
> +       int i = 0;
> +
> +       vi->ctrl->rss.hash_types = vi->rss_hash_types_supported;
> +       vi->ctrl->rss.indirection_table_mask = vi->rss_indir_table_size - 1;

Is table size always a power of two?

> +       vi->ctrl->rss.unclassified_queue = 0;
> +
> +       for (; i < vi->rss_indir_table_size; ++i) {
> +               indir_val = ethtool_rxfh_indir_default(i, vi->curr_queue_pairs);
> +               vi->ctrl->rss.indirection_table[i] = indir_val;
> +       }
> +
> +       vi->ctrl->rss.max_tx_vq = vi->curr_queue_pairs;
> +       vi->ctrl->rss.hash_key_length = vi->rss_key_size;
> +
> +       netdev_rss_key_fill(vi->ctrl->rss.key, vi->rss_key_size);
> +}
> +
>
>  static void virtnet_get_drvinfo(struct net_device *dev,
>                                 struct ethtool_drvinfo *info)
> @@ -2412,6 +2487,71 @@ static void virtnet_update_settings(struct virtnet_info *vi)
>                 vi->duplex = duplex;
>  }
>
> +static u32 virtnet_get_rxfh_key_size(struct net_device *dev)
> +{
> +       return ((struct virtnet_info *)netdev_priv(dev))->rss_key_size;
> +}
> +
> +static u32 virtnet_get_rxfh_indir_size(struct net_device *dev)
> +{
> +       return ((struct virtnet_info *)netdev_priv(dev))->rss_indir_table_size;
> +}
> +
> +static int virtnet_get_rxfh(struct net_device *dev, u32 *indir, u8 *key, u8 *hfunc)
> +{
> +       struct virtnet_info *vi = netdev_priv(dev);
> +       int i;
> +
> +       if (indir) {
> +               for (i = 0; i < vi->rss_indir_table_size; ++i)
> +                       indir[i] = vi->ctrl->rss.indirection_table[i];
> +       }
> +
> +       if (key)
> +               memcpy(key, vi->ctrl->rss.key, vi->rss_key_size);
> +
> +       if (hfunc)
> +               *hfunc = ETH_RSS_HASH_TOP;
> +
> +       return 0;
> +}
> +
> +static int virtnet_set_rxfh(struct net_device *dev, const u32 *indir, const u8 *key, const u8 hfunc)
> +{
> +       struct virtnet_info *vi = netdev_priv(dev);
> +       int i;
> +
> +       if (hfunc != ETH_RSS_HASH_NO_CHANGE && hfunc != ETH_RSS_HASH_TOP)
> +               return -EOPNOTSUPP;
> +
> +       if (indir) {
> +               for (i = 0; i < vi->rss_indir_table_size; ++i)
> +                       vi->ctrl->rss.indirection_table[i] = indir[i];
> +       }
> +       if (key)
> +               memcpy(vi->ctrl->rss.key, key, vi->rss_key_size);
> +
> +       virtnet_commit_rss_command(vi);
> +
> +       return 0;
> +}
> +
> +static int virtnet_get_rxnfc(struct net_device *dev, struct ethtool_rxnfc *info, u32 *rule_locs)
> +{
> +       struct virtnet_info *vi = netdev_priv(dev);
> +       int rc = 0;
> +
> +       switch (info->cmd) {
> +       case ETHTOOL_GRXRINGS:
> +               info->data = vi->curr_queue_pairs;
> +               break;
> +       default:
> +               rc = -EOPNOTSUPP;
> +       }
> +
> +       return rc;
> +}
> +
>  static const struct ethtool_ops virtnet_ethtool_ops = {
>         .supported_coalesce_params = ETHTOOL_COALESCE_MAX_FRAMES,
>         .get_drvinfo = virtnet_get_drvinfo,
> @@ -2427,6 +2567,11 @@ static const struct ethtool_ops virtnet_ethtool_ops = {
>         .set_link_ksettings = virtnet_set_link_ksettings,
>         .set_coalesce = virtnet_set_coalesce,
>         .get_coalesce = virtnet_get_coalesce,
> +       .get_rxfh_key_size = virtnet_get_rxfh_key_size,
> +       .get_rxfh_indir_size = virtnet_get_rxfh_indir_size,
> +       .get_rxfh = virtnet_get_rxfh,
> +       .set_rxfh = virtnet_set_rxfh,
> +       .get_rxnfc = virtnet_get_rxnfc,
>  };
>
>  static void virtnet_freeze_down(struct virtio_device *vdev)
> @@ -2679,6 +2824,16 @@ static int virtnet_set_features(struct net_device *dev,
>                 vi->guest_offloads = offloads;
>         }
>
> +       if ((dev->features ^ features) & NETIF_F_RXHASH) {
> +               if (features & NETIF_F_RXHASH)
> +                       vi->ctrl->rss.hash_types = vi->rss_hash_types_supported;
> +               else
> +                       vi->ctrl->rss.hash_types = VIRTIO_NET_HASH_REPORT_NONE;
> +
> +               if (!virtnet_commit_rss_command(vi))
> +                       return -EINVAL;
> +       }
> +
>         return 0;
>  }
>
> @@ -3073,6 +3228,8 @@ static bool virtnet_validate_features(struct virtio_device *vdev)
>                              "VIRTIO_NET_F_CTRL_VQ") ||
>              VIRTNET_FAIL_ON(vdev, VIRTIO_NET_F_MQ, "VIRTIO_NET_F_CTRL_VQ") ||
>              VIRTNET_FAIL_ON(vdev, VIRTIO_NET_F_CTRL_MAC_ADDR,
> +                            "VIRTIO_NET_F_CTRL_VQ") ||
> +            VIRTNET_FAIL_ON(vdev, VIRTIO_NET_F_RSS,
>                              "VIRTIO_NET_F_CTRL_VQ"))) {
>                 return false;
>         }
> @@ -3113,13 +3270,14 @@ static int virtnet_probe(struct virtio_device *vdev)
>         u16 max_queue_pairs;
>         int mtu;
>
> -       /* Find if host supports multiqueue virtio_net device */
> -       err = virtio_cread_feature(vdev, VIRTIO_NET_F_MQ,
> -                                  struct virtio_net_config,
> -                                  max_virtqueue_pairs, &max_queue_pairs);
> +       /* Find if host supports multiqueue/rss virtio_net device */
> +       max_queue_pairs = 1;
> +       if (virtio_has_feature(vdev, VIRTIO_NET_F_MQ) || virtio_has_feature(vdev, VIRTIO_NET_F_RSS))
> +               max_queue_pairs =
> +                    virtio_cread16(vdev, offsetof(struct virtio_net_config, max_virtqueue_pairs));

Instead of testing either feature and treating them as somewhat equal,
shouldn't RSS be dependent on MQ?

>
>         /* We need at least 2 queue's */
> -       if (err || max_queue_pairs < VIRTIO_NET_CTRL_MQ_VQ_PAIRS_MIN ||
> +       if (max_queue_pairs < VIRTIO_NET_CTRL_MQ_VQ_PAIRS_MIN ||
>             max_queue_pairs > VIRTIO_NET_CTRL_MQ_VQ_PAIRS_MAX ||
>             !virtio_has_feature(vdev, VIRTIO_NET_F_CTRL_VQ))
>                 max_queue_pairs = 1;
> @@ -3207,6 +3365,23 @@ static int virtnet_probe(struct virtio_device *vdev)
>         if (virtio_has_feature(vdev, VIRTIO_NET_F_MRG_RXBUF))
>                 vi->mergeable_rx_bufs = true;
>
> +       if (virtio_has_feature(vdev, VIRTIO_NET_F_RSS)) {
> +               vi->has_rss = true;
> +               vi->rss_indir_table_size =
> +                       virtio_cread16(vdev, offsetof(struct virtio_net_config,
> +                               rss_max_indirection_table_length));
> +               vi->rss_key_size =
> +                       virtio_cread8(vdev, offsetof(struct virtio_net_config, rss_max_key_size));
> +
> +               vi->rss_hash_types_supported =
> +                   virtio_cread32(vdev, offsetof(struct virtio_net_config, supported_hash_types));
> +               vi->rss_hash_types_supported &=
> +                               ~(VIRTIO_NET_RSS_HASH_TYPE_IP_EX |
> +                                 VIRTIO_NET_RSS_HASH_TYPE_TCP_EX |
> +                                 VIRTIO_NET_RSS_HASH_TYPE_UDP_EX);
> +
> +               dev->hw_features |= NETIF_F_RXHASH;

Only make the feature visible when the hash is actually reported in
the skb, patch 3.

Also, clearly separate the feature patches (2) rss, (3) rxhash, (4)
rxhash config.
