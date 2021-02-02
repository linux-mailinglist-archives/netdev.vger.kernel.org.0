Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 267E930CFF5
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 00:45:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229783AbhBBXpW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 18:45:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229534AbhBBXpV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 18:45:21 -0500
Received: from mail-vs1-xe2e.google.com (mail-vs1-xe2e.google.com [IPv6:2607:f8b0:4864:20::e2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F69EC061573
        for <netdev@vger.kernel.org>; Tue,  2 Feb 2021 15:44:41 -0800 (PST)
Received: by mail-vs1-xe2e.google.com with SMTP id l192so4662307vsd.5
        for <netdev@vger.kernel.org>; Tue, 02 Feb 2021 15:44:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HV6jn1Mj+6Q0GVXqO0XZPb8NAVpZ2ZPSr94NS/JzLes=;
        b=hgl0BfteTIjSdaDHtoRThNG0Lmysvudip/dcs8yV5lA53PBUx4otbyLr6lSBZHS7+a
         DG5UJI20ccOenJmrtIDhJr2RBOEXmcgif0f83ms0H4uf1eOzRUARnZV6kpUBaGBr95WM
         jcDj/guJ8bnj5ROQAqlMB2uFzQzRHh8y4Md12s6fW8Vt4lfwnJEufIFX2a2fHTbkEVMa
         6Cz7RIne8kfb02OaEJsoqaFeko9TR/9oiIEjqss2/vS27M/IgLcBCA6KCHEHDp+E1lLS
         oMgWRiT3DYq7hPNfuK6F/qm3ViNEvr4usbtkJJI3yYUp3edp7eXl2bIe/5TWO0rMSz+0
         3Kag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HV6jn1Mj+6Q0GVXqO0XZPb8NAVpZ2ZPSr94NS/JzLes=;
        b=H/ZGKUOWsbaveTXAVuHfcCcAfgRH6v5uoyn9mHF97XKaH3Pz64/cJHt2PHrx82MiiI
         kDvcNdQL/BJ93LiQqP3kAAi7c9Z5hRpetGlMqcOF0l84A5aXb0Gyr8xGM6IPzSBtvt8b
         S0J1JX6f1eGq9v7oqQprC06pk1Gdo+66hHpgSwT0od0R+g4HinFgLjT8AewVwLAPJyJ3
         vAp0akI6b1edEq8ZfgYATR7/mfk9bBeXrgzh5i9njOBE9J5eReX8X/4qfD8ayT9tc/U2
         3GUQbOXdcTV+gO469vuO1i6SMmk5euvWhtfEUgbgrs/E72NBolKFEgTHmsynZviODF1p
         sdyg==
X-Gm-Message-State: AOAM533wT0J6IEPZ75ThEzCOcJvDCLc7b+uV9m0+cuNQiYCNrQjjmp6o
        eOumJ9n5mNwX/DYe+4+a0jlSajLPIFQ=
X-Google-Smtp-Source: ABdhPJyrmmUUpuPb5tpRGXPrLDVzjFBq7ivYMeMwPEZFtahIB+cu1YuU6v2ulRz8guNQydpFZkj5hw==
X-Received: by 2002:a67:d60f:: with SMTP id n15mr372269vsj.37.1612309478921;
        Tue, 02 Feb 2021 15:44:38 -0800 (PST)
Received: from mail-vs1-f48.google.com (mail-vs1-f48.google.com. [209.85.217.48])
        by smtp.gmail.com with ESMTPSA id n186sm39406vkn.19.2021.02.02.15.44.37
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Feb 2021 15:44:38 -0800 (PST)
Received: by mail-vs1-f48.google.com with SMTP id 186so12145575vsz.13
        for <netdev@vger.kernel.org>; Tue, 02 Feb 2021 15:44:37 -0800 (PST)
X-Received: by 2002:a67:cb1a:: with SMTP id b26mr225567vsl.22.1612309476560;
 Tue, 02 Feb 2021 15:44:36 -0800 (PST)
MIME-Version: 1.0
References: <20201228162233.2032571-1-willemdebruijn.kernel@gmail.com>
 <20201228162233.2032571-3-willemdebruijn.kernel@gmail.com>
 <20210202090724-mutt-send-email-mst@kernel.org> <CA+FuTSeEVvtmmQ2HioTUrA6nX9s6yLEvNXfg=fLKw6X+E9wWow@mail.gmail.com>
 <20210202175934-mutt-send-email-mst@kernel.org>
In-Reply-To: <20210202175934-mutt-send-email-mst@kernel.org>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 2 Feb 2021 18:43:59 -0500
X-Gmail-Original-Message-ID: <CA+FuTSfRHMDd-Q4UB4vVsdbs=YpP-WzUMtNGiKwLpEQaAR2Xdg@mail.gmail.com>
Message-ID: <CA+FuTSfRHMDd-Q4UB4vVsdbs=YpP-WzUMtNGiKwLpEQaAR2Xdg@mail.gmail.com>
Subject: Re: [PATCH rfc 2/3] virtio-net: support receive timestamp
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        virtualization@lists.linux-foundation.org,
        Network Development <netdev@vger.kernel.org>,
        Jason Wang <jasowang@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 2, 2021 at 6:06 PM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> On Tue, Feb 02, 2021 at 05:17:13PM -0500, Willem de Bruijn wrote:
> > On Tue, Feb 2, 2021 at 9:08 AM Michael S. Tsirkin <mst@redhat.com> wrote:
> > >
> > > On Mon, Dec 28, 2020 at 11:22:32AM -0500, Willem de Bruijn wrote:
> > > > From: Willem de Bruijn <willemb@google.com>
> > > >
> > > > Add optional PTP hardware timestamp offload for virtio-net.
> > > >
> > > > Accurate RTT measurement requires timestamps close to the wire.
> > > > Introduce virtio feature VIRTIO_NET_F_RX_TSTAMP. If negotiated, the
> > > > virtio-net header is expanded with room for a timestamp. A host may
> > > > pass receive timestamps for all or some packets. A timestamp is valid
> > > > if non-zero.
> > > >
> > > > The timestamp straddles (virtual) hardware domains. Like PTP, use
> > > > international atomic time (CLOCK_TAI) as global clock base. It is
> > > > guest responsibility to sync with host, e.g., through kvm-clock.
> > > >
> > > > Signed-off-by: Willem de Bruijn <willemb@google.com>
> > > > ---
> > > >  drivers/net/virtio_net.c        | 20 +++++++++++++++++++-
> > > >  include/uapi/linux/virtio_net.h | 12 ++++++++++++
> > > >  2 files changed, 31 insertions(+), 1 deletion(-)
> > > >
> > > > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > > > index b917b7333928..57744bb6a141 100644
> > > > --- a/drivers/net/virtio_net.c
> > > > +++ b/drivers/net/virtio_net.c
> > > > @@ -204,6 +204,9 @@ struct virtnet_info {
> > > >       /* Guest will pass tx path info to the host */
> > > >       bool has_tx_hash;
> > > >
> > > > +     /* Host will pass CLOCK_TAI receive time to the guest */
> > > > +     bool has_rx_tstamp;
> > > > +
> > > >       /* Has control virtqueue */
> > > >       bool has_cvq;
> > > >
> > > > @@ -292,6 +295,13 @@ static inline struct virtio_net_hdr_mrg_rxbuf *skb_vnet_hdr(struct sk_buff *skb)
> > > >       return (struct virtio_net_hdr_mrg_rxbuf *)skb->cb;
> > > >  }
> > > >
> > > > +static inline struct virtio_net_hdr_v12 *skb_vnet_hdr_12(struct sk_buff *skb)
> > > > +{
> > > > +     BUILD_BUG_ON(sizeof(struct virtio_net_hdr_v12) > sizeof(skb->cb));
> > > > +
> > > > +     return (void *)skb->cb;
> > > > +}
> > > > +
> > > >  /*
> > > >   * private is used to chain pages for big packets, put the whole
> > > >   * most recent used list in the beginning for reuse
> > > > @@ -1082,6 +1092,9 @@ static void receive_buf(struct virtnet_info *vi, struct receive_queue *rq,
> > > >               goto frame_err;
> > > >       }
> > > >
> > > > +     if (vi->has_rx_tstamp)
> > > > +             skb_hwtstamps(skb)->hwtstamp = ns_to_ktime(skb_vnet_hdr_12(skb)->tstamp);
> > > > +
> > > >       skb_record_rx_queue(skb, vq2rxq(rq->vq));
> > > >       skb->protocol = eth_type_trans(skb, dev);
> > > >       pr_debug("Receiving skb proto 0x%04x len %i type %i\n",
> > > > @@ -3071,6 +3084,11 @@ static int virtnet_probe(struct virtio_device *vdev)
> > > >               vi->hdr_len = sizeof(struct virtio_net_hdr_v1_hash);
> > > >       }
> > > >
> > > > +     if (virtio_has_feature(vdev, VIRTIO_NET_F_RX_TSTAMP)) {
> > > > +             vi->has_rx_tstamp = true;
> > > > +             vi->hdr_len = sizeof(struct virtio_net_hdr_v12);
> > > > +     }
> > > > +
> > > >       if (virtio_has_feature(vdev, VIRTIO_F_ANY_LAYOUT) ||
> > > >           virtio_has_feature(vdev, VIRTIO_F_VERSION_1))
> > > >               vi->any_header_sg = true;
> > > > @@ -3261,7 +3279,7 @@ static struct virtio_device_id id_table[] = {
> > > >       VIRTIO_NET_F_CTRL_MAC_ADDR, \
> > > >       VIRTIO_NET_F_MTU, VIRTIO_NET_F_CTRL_GUEST_OFFLOADS, \
> > > >       VIRTIO_NET_F_SPEED_DUPLEX, VIRTIO_NET_F_STANDBY, \
> > > > -     VIRTIO_NET_F_TX_HASH
> > > > +     VIRTIO_NET_F_TX_HASH, VIRTIO_NET_F_RX_TSTAMP
> > > >
> > > >  static unsigned int features[] = {
> > > >       VIRTNET_FEATURES,
> > > > diff --git a/include/uapi/linux/virtio_net.h b/include/uapi/linux/virtio_net.h
> > > > index f6881b5b77ee..0ffe2eeebd4a 100644
> > > > --- a/include/uapi/linux/virtio_net.h
> > > > +++ b/include/uapi/linux/virtio_net.h
> > > > @@ -57,6 +57,7 @@
> > > >                                        * Steering */
> > > >  #define VIRTIO_NET_F_CTRL_MAC_ADDR 23        /* Set MAC address */
> > > >
> > > > +#define VIRTIO_NET_F_RX_TSTAMP         55    /* Host sends TAI receive time */
> > > >  #define VIRTIO_NET_F_TX_HASH   56    /* Guest sends hash report */
> > > >  #define VIRTIO_NET_F_HASH_REPORT  57 /* Supports hash report */
> > > >  #define VIRTIO_NET_F_RSS       60    /* Supports RSS RX steering */
> > > > @@ -182,6 +183,17 @@ struct virtio_net_hdr_v1_hash {
> > > >       };
> > > >  };
> > > >
> > > > +struct virtio_net_hdr_v12 {
> > > > +     struct virtio_net_hdr_v1 hdr;
> > > > +     struct {
> > > > +             __le32 value;
> > > > +             __le16 report;
> > > > +             __le16 flow_state;
> > > > +     } hash;
> > > > +     __virtio32 reserved;
> > >
> > >
> > > Does endian-ness matter? If not - just u32?
> >
> > I suppose it does not matter as long as this is reserved. Should it be
> > __le32, at least?
>
> One can safely assign 0 to any value.

Ack.

>
> > > > +     __virtio64 tstamp;
> > > > +};
> > > > +
> > >
> > > Given it's only available in modern devices, I think we
> > > can make this __le64 tstamp.
> >
> > Actually, would it be possible to make new features available on
> > legacy devices? There is nothing in the features bits precluding it.
>
> I think it won't be possible: you are using feature bit 55,
> legacy devices have up to 32 feature bits. And of course the
> header looks a bit differently for legacy, you would have to add special
> code to handle that when mergeable buffers are off.

I think I can make the latter work. I did start without a dependency
on the v1 header initially.

Feature bit array length I had not considered. Good point. Need to
think about that. It would be very appealing if in particular the
tx-hash feature could work in legacy mode.

> >
> > I have a revised patchset almost ready. I suppose I should send it as
> > RFC again, and simultaneously file an OASIS ballot for each feature?
>
> that would be great.

Will do, thanks.
