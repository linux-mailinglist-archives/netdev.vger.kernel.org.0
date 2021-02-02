Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F9AC30CF95
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 00:04:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236028AbhBBXER (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 18:04:17 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:32896 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233464AbhBBXEJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 18:04:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612306962;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LDg4iKymZ53hNxtNIr/W8exxkDX1y1fBofy+s8scyQM=;
        b=Iy/yIy0C5jC7Aa87QUL1rbg0jR5Kf3jTXS3Z8DBVWIH1w7ZW+hK2tu9Ys1Ja9/DAXtJrcL
        npbDJ1PoL7ZNdIK1wMI0Ih8b2UrK1+NbeMnuqDOpF04uaGknfNntif5TMJAEVn5nAu+B9P
        jMkU7HmWiC8a8ek1D2Kj/OrbBvAPPqY=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-494-nMHFUV9hNRmme8ON7ZQAIw-1; Tue, 02 Feb 2021 18:02:40 -0500
X-MC-Unique: nMHFUV9hNRmme8ON7ZQAIw-1
Received: by mail-wr1-f70.google.com with SMTP id l13so13317593wrq.7
        for <netdev@vger.kernel.org>; Tue, 02 Feb 2021 15:02:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=LDg4iKymZ53hNxtNIr/W8exxkDX1y1fBofy+s8scyQM=;
        b=bMqz+Jk3TTbSudhEWtkr7vI+1l8xgHkwjKc2NcQArXgt4vbE+M/L6A7DeVDkZaMIiy
         u/fmTIXjOvX6I20prEvZi0M3zbZLyBypWTSYhy+Y49rys73eU+JazDx6T0fUE9VTy7BA
         lVUQxwEJ2wTL+GFTJK8Dyz+AqIiLOWQxGAxQN6HQNvjxefKpNkLl+8K7Wse9/GD1tIGA
         cUlnQuydEZCQHkWlN0cM+ww99up1bUId+YgQJMhAn5HOmiQGoWwVx+15c1S3MFySpYAA
         O16Pic7Cw9SEKB57UPHdg11OK5U5Inqa9qymgsfvM5dhXlj3yRq0ATt0vlhAqcnI7/QC
         +vJQ==
X-Gm-Message-State: AOAM532Yub+piLnR08ajQc8PnZf8OmN6iScK5pLYFJLI+84E0G1n8cyQ
        4Rp8b4mDYjQIMCKlwmaBNVoFcn0/W/fIP9REksT8HVBDt9XNkf1Ul11oFCFr6tuBrF/5cQL0A0o
        TvtcpxgnTqWY7/E6d
X-Received: by 2002:adf:cd83:: with SMTP id q3mr317042wrj.225.1612306958847;
        Tue, 02 Feb 2021 15:02:38 -0800 (PST)
X-Google-Smtp-Source: ABdhPJy7ozq2UgBjdAGg7+Fmg2ziWMUdJw6kuyXQQMlyA3fQ392T9ZIlR5Tv21sW6hC+KMtJGHELFg==
X-Received: by 2002:adf:cd83:: with SMTP id q3mr317029wrj.225.1612306958663;
        Tue, 02 Feb 2021 15:02:38 -0800 (PST)
Received: from redhat.com (bzq-79-177-39-148.red.bezeqint.net. [79.177.39.148])
        by smtp.gmail.com with ESMTPSA id s4sm89994wrt.85.2021.02.02.15.02.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Feb 2021 15:02:37 -0800 (PST)
Date:   Tue, 2 Feb 2021 18:02:35 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     virtualization@lists.linux-foundation.org,
        Network Development <netdev@vger.kernel.org>,
        Jason Wang <jasowang@redhat.com>
Subject: Re: [PATCH rfc 2/3] virtio-net: support receive timestamp
Message-ID: <20210202175934-mutt-send-email-mst@kernel.org>
References: <20201228162233.2032571-1-willemdebruijn.kernel@gmail.com>
 <20201228162233.2032571-3-willemdebruijn.kernel@gmail.com>
 <20210202090724-mutt-send-email-mst@kernel.org>
 <CA+FuTSeEVvtmmQ2HioTUrA6nX9s6yLEvNXfg=fLKw6X+E9wWow@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+FuTSeEVvtmmQ2HioTUrA6nX9s6yLEvNXfg=fLKw6X+E9wWow@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 02, 2021 at 05:17:13PM -0500, Willem de Bruijn wrote:
> On Tue, Feb 2, 2021 at 9:08 AM Michael S. Tsirkin <mst@redhat.com> wrote:
> >
> > On Mon, Dec 28, 2020 at 11:22:32AM -0500, Willem de Bruijn wrote:
> > > From: Willem de Bruijn <willemb@google.com>
> > >
> > > Add optional PTP hardware timestamp offload for virtio-net.
> > >
> > > Accurate RTT measurement requires timestamps close to the wire.
> > > Introduce virtio feature VIRTIO_NET_F_RX_TSTAMP. If negotiated, the
> > > virtio-net header is expanded with room for a timestamp. A host may
> > > pass receive timestamps for all or some packets. A timestamp is valid
> > > if non-zero.
> > >
> > > The timestamp straddles (virtual) hardware domains. Like PTP, use
> > > international atomic time (CLOCK_TAI) as global clock base. It is
> > > guest responsibility to sync with host, e.g., through kvm-clock.
> > >
> > > Signed-off-by: Willem de Bruijn <willemb@google.com>
> > > ---
> > >  drivers/net/virtio_net.c        | 20 +++++++++++++++++++-
> > >  include/uapi/linux/virtio_net.h | 12 ++++++++++++
> > >  2 files changed, 31 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > > index b917b7333928..57744bb6a141 100644
> > > --- a/drivers/net/virtio_net.c
> > > +++ b/drivers/net/virtio_net.c
> > > @@ -204,6 +204,9 @@ struct virtnet_info {
> > >       /* Guest will pass tx path info to the host */
> > >       bool has_tx_hash;
> > >
> > > +     /* Host will pass CLOCK_TAI receive time to the guest */
> > > +     bool has_rx_tstamp;
> > > +
> > >       /* Has control virtqueue */
> > >       bool has_cvq;
> > >
> > > @@ -292,6 +295,13 @@ static inline struct virtio_net_hdr_mrg_rxbuf *skb_vnet_hdr(struct sk_buff *skb)
> > >       return (struct virtio_net_hdr_mrg_rxbuf *)skb->cb;
> > >  }
> > >
> > > +static inline struct virtio_net_hdr_v12 *skb_vnet_hdr_12(struct sk_buff *skb)
> > > +{
> > > +     BUILD_BUG_ON(sizeof(struct virtio_net_hdr_v12) > sizeof(skb->cb));
> > > +
> > > +     return (void *)skb->cb;
> > > +}
> > > +
> > >  /*
> > >   * private is used to chain pages for big packets, put the whole
> > >   * most recent used list in the beginning for reuse
> > > @@ -1082,6 +1092,9 @@ static void receive_buf(struct virtnet_info *vi, struct receive_queue *rq,
> > >               goto frame_err;
> > >       }
> > >
> > > +     if (vi->has_rx_tstamp)
> > > +             skb_hwtstamps(skb)->hwtstamp = ns_to_ktime(skb_vnet_hdr_12(skb)->tstamp);
> > > +
> > >       skb_record_rx_queue(skb, vq2rxq(rq->vq));
> > >       skb->protocol = eth_type_trans(skb, dev);
> > >       pr_debug("Receiving skb proto 0x%04x len %i type %i\n",
> > > @@ -3071,6 +3084,11 @@ static int virtnet_probe(struct virtio_device *vdev)
> > >               vi->hdr_len = sizeof(struct virtio_net_hdr_v1_hash);
> > >       }
> > >
> > > +     if (virtio_has_feature(vdev, VIRTIO_NET_F_RX_TSTAMP)) {
> > > +             vi->has_rx_tstamp = true;
> > > +             vi->hdr_len = sizeof(struct virtio_net_hdr_v12);
> > > +     }
> > > +
> > >       if (virtio_has_feature(vdev, VIRTIO_F_ANY_LAYOUT) ||
> > >           virtio_has_feature(vdev, VIRTIO_F_VERSION_1))
> > >               vi->any_header_sg = true;
> > > @@ -3261,7 +3279,7 @@ static struct virtio_device_id id_table[] = {
> > >       VIRTIO_NET_F_CTRL_MAC_ADDR, \
> > >       VIRTIO_NET_F_MTU, VIRTIO_NET_F_CTRL_GUEST_OFFLOADS, \
> > >       VIRTIO_NET_F_SPEED_DUPLEX, VIRTIO_NET_F_STANDBY, \
> > > -     VIRTIO_NET_F_TX_HASH
> > > +     VIRTIO_NET_F_TX_HASH, VIRTIO_NET_F_RX_TSTAMP
> > >
> > >  static unsigned int features[] = {
> > >       VIRTNET_FEATURES,
> > > diff --git a/include/uapi/linux/virtio_net.h b/include/uapi/linux/virtio_net.h
> > > index f6881b5b77ee..0ffe2eeebd4a 100644
> > > --- a/include/uapi/linux/virtio_net.h
> > > +++ b/include/uapi/linux/virtio_net.h
> > > @@ -57,6 +57,7 @@
> > >                                        * Steering */
> > >  #define VIRTIO_NET_F_CTRL_MAC_ADDR 23        /* Set MAC address */
> > >
> > > +#define VIRTIO_NET_F_RX_TSTAMP         55    /* Host sends TAI receive time */
> > >  #define VIRTIO_NET_F_TX_HASH   56    /* Guest sends hash report */
> > >  #define VIRTIO_NET_F_HASH_REPORT  57 /* Supports hash report */
> > >  #define VIRTIO_NET_F_RSS       60    /* Supports RSS RX steering */
> > > @@ -182,6 +183,17 @@ struct virtio_net_hdr_v1_hash {
> > >       };
> > >  };
> > >
> > > +struct virtio_net_hdr_v12 {
> > > +     struct virtio_net_hdr_v1 hdr;
> > > +     struct {
> > > +             __le32 value;
> > > +             __le16 report;
> > > +             __le16 flow_state;
> > > +     } hash;
> > > +     __virtio32 reserved;
> >
> >
> > Does endian-ness matter? If not - just u32?
> 
> I suppose it does not matter as long as this is reserved. Should it be
> __le32, at least?

One can safely assign 0 to any value.


> > > +     __virtio64 tstamp;
> > > +};
> > > +
> >
> > Given it's only available in modern devices, I think we
> > can make this __le64 tstamp.
> 
> Actually, would it be possible to make new features available on
> legacy devices? There is nothing in the features bits precluding it.

I think it won't be possible: you are using feature bit 55,
legacy devices have up to 32 feature bits. And of course the
header looks a bit differently for legacy, you would have to add special
code to handle that when mergeable buffers are off.

> 
> I have a revised patchset almost ready. I suppose I should send it as
> RFC again, and simultaneously file an OASIS ballot for each feature?

that would be great.

-- 
MST

