Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFC9E30CEAC
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 23:20:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233080AbhBBWTf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 17:19:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234940AbhBBWSf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 17:18:35 -0500
Received: from mail-vk1-xa33.google.com (mail-vk1-xa33.google.com [IPv6:2607:f8b0:4864:20::a33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C4D2C0613D6
        for <netdev@vger.kernel.org>; Tue,  2 Feb 2021 14:17:55 -0800 (PST)
Received: by mail-vk1-xa33.google.com with SMTP id y8so5193734vky.4
        for <netdev@vger.kernel.org>; Tue, 02 Feb 2021 14:17:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jbC7PmBYgdAuGgYTXt6Zw9L1EeyMUlWYHxLbasyCNgs=;
        b=qcesaYRS68OyYdo+W3wEGycGFAmjYyWxuF9xX5KVwIFjRlw4jcHomPSgm5a0F9E1hE
         nt9XxJdOf5FUrlG3yy+O96iDMZmtm/izUapfPvp8wenSZBCYg0TD63jaA0DGjemW4f9/
         Ees8LtrkGF9QUNWZ+1kiUq2GgX3nBESRZQFH5ezZO1XjvFFcO8avDW1z/VWLVEHeg3lH
         TvPFKe8AzdCUy9Skq/j67mbn/C9Xa47ilDDY8gXgHWkd5JnoLpR6ZaDNGsDu7BEkiU1S
         HQ13ZWg4ml9i1hW3doQevc1eu7ocJpjXeED/Gi9j64QDTu8CXA1lMvmH89Fx0iIPxala
         xnEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jbC7PmBYgdAuGgYTXt6Zw9L1EeyMUlWYHxLbasyCNgs=;
        b=mahkK6/R7vrA2RZH15J+9zK9M0+5x+ALp3x05n/0JUEZQxh5+MAvRPITC00KZdwlY6
         V5ctP1+qKKtwEur0HFLCrY9ZBVt89EGGymtOnDa+VXO5RohqmU7/vsElW/oFR1EIpc2g
         dYlBqYKHtV4dH2tuVpVFLtAejEfEyHxvdcd1s9QJd4P7RG9IIs3yOlOV5s9OCP+VuTVX
         0yv+fMpATw06B8r9YdEFah1LS0jIeetc1RG5pCUVBF/fn3y2AZ7BYYNDxlvVUsvtLa4N
         /XqzOTLHKHl5UiLOWcVGvZiqlT8QZsUGuFl+GHTGHnzwO3UAgOIUUAQWojhNy1ulGVVc
         HvTg==
X-Gm-Message-State: AOAM531M2avg2fli56s1zJA0yf17NWbLeIvEF4pJH+doqGhBxfTPtpUr
        qiUw8HQeYylyNAqkIXGhhIjiD+ubeJg=
X-Google-Smtp-Source: ABdhPJyGoW1q9BpMapZSs8PcvXzWrKjgfRYPmC0Tz1ptjr770mkgyeXaGkQFvQbzIjteOSAdh58X9w==
X-Received: by 2002:a1f:1bcc:: with SMTP id b195mr211498vkb.5.1612304273586;
        Tue, 02 Feb 2021 14:17:53 -0800 (PST)
Received: from mail-ua1-f43.google.com (mail-ua1-f43.google.com. [209.85.222.43])
        by smtp.gmail.com with ESMTPSA id p24sm2858798vsg.0.2021.02.02.14.17.51
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Feb 2021 14:17:51 -0800 (PST)
Received: by mail-ua1-f43.google.com with SMTP id t15so7638134ual.6
        for <netdev@vger.kernel.org>; Tue, 02 Feb 2021 14:17:51 -0800 (PST)
X-Received: by 2002:ab0:7a6b:: with SMTP id c11mr220348uat.37.1612304270812;
 Tue, 02 Feb 2021 14:17:50 -0800 (PST)
MIME-Version: 1.0
References: <20201228162233.2032571-1-willemdebruijn.kernel@gmail.com>
 <20201228162233.2032571-3-willemdebruijn.kernel@gmail.com> <20210202090724-mutt-send-email-mst@kernel.org>
In-Reply-To: <20210202090724-mutt-send-email-mst@kernel.org>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 2 Feb 2021 17:17:13 -0500
X-Gmail-Original-Message-ID: <CA+FuTSeEVvtmmQ2HioTUrA6nX9s6yLEvNXfg=fLKw6X+E9wWow@mail.gmail.com>
Message-ID: <CA+FuTSeEVvtmmQ2HioTUrA6nX9s6yLEvNXfg=fLKw6X+E9wWow@mail.gmail.com>
Subject: Re: [PATCH rfc 2/3] virtio-net: support receive timestamp
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     virtualization@lists.linux-foundation.org,
        Network Development <netdev@vger.kernel.org>,
        Jason Wang <jasowang@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 2, 2021 at 9:08 AM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> On Mon, Dec 28, 2020 at 11:22:32AM -0500, Willem de Bruijn wrote:
> > From: Willem de Bruijn <willemb@google.com>
> >
> > Add optional PTP hardware timestamp offload for virtio-net.
> >
> > Accurate RTT measurement requires timestamps close to the wire.
> > Introduce virtio feature VIRTIO_NET_F_RX_TSTAMP. If negotiated, the
> > virtio-net header is expanded with room for a timestamp. A host may
> > pass receive timestamps for all or some packets. A timestamp is valid
> > if non-zero.
> >
> > The timestamp straddles (virtual) hardware domains. Like PTP, use
> > international atomic time (CLOCK_TAI) as global clock base. It is
> > guest responsibility to sync with host, e.g., through kvm-clock.
> >
> > Signed-off-by: Willem de Bruijn <willemb@google.com>
> > ---
> >  drivers/net/virtio_net.c        | 20 +++++++++++++++++++-
> >  include/uapi/linux/virtio_net.h | 12 ++++++++++++
> >  2 files changed, 31 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > index b917b7333928..57744bb6a141 100644
> > --- a/drivers/net/virtio_net.c
> > +++ b/drivers/net/virtio_net.c
> > @@ -204,6 +204,9 @@ struct virtnet_info {
> >       /* Guest will pass tx path info to the host */
> >       bool has_tx_hash;
> >
> > +     /* Host will pass CLOCK_TAI receive time to the guest */
> > +     bool has_rx_tstamp;
> > +
> >       /* Has control virtqueue */
> >       bool has_cvq;
> >
> > @@ -292,6 +295,13 @@ static inline struct virtio_net_hdr_mrg_rxbuf *skb_vnet_hdr(struct sk_buff *skb)
> >       return (struct virtio_net_hdr_mrg_rxbuf *)skb->cb;
> >  }
> >
> > +static inline struct virtio_net_hdr_v12 *skb_vnet_hdr_12(struct sk_buff *skb)
> > +{
> > +     BUILD_BUG_ON(sizeof(struct virtio_net_hdr_v12) > sizeof(skb->cb));
> > +
> > +     return (void *)skb->cb;
> > +}
> > +
> >  /*
> >   * private is used to chain pages for big packets, put the whole
> >   * most recent used list in the beginning for reuse
> > @@ -1082,6 +1092,9 @@ static void receive_buf(struct virtnet_info *vi, struct receive_queue *rq,
> >               goto frame_err;
> >       }
> >
> > +     if (vi->has_rx_tstamp)
> > +             skb_hwtstamps(skb)->hwtstamp = ns_to_ktime(skb_vnet_hdr_12(skb)->tstamp);
> > +
> >       skb_record_rx_queue(skb, vq2rxq(rq->vq));
> >       skb->protocol = eth_type_trans(skb, dev);
> >       pr_debug("Receiving skb proto 0x%04x len %i type %i\n",
> > @@ -3071,6 +3084,11 @@ static int virtnet_probe(struct virtio_device *vdev)
> >               vi->hdr_len = sizeof(struct virtio_net_hdr_v1_hash);
> >       }
> >
> > +     if (virtio_has_feature(vdev, VIRTIO_NET_F_RX_TSTAMP)) {
> > +             vi->has_rx_tstamp = true;
> > +             vi->hdr_len = sizeof(struct virtio_net_hdr_v12);
> > +     }
> > +
> >       if (virtio_has_feature(vdev, VIRTIO_F_ANY_LAYOUT) ||
> >           virtio_has_feature(vdev, VIRTIO_F_VERSION_1))
> >               vi->any_header_sg = true;
> > @@ -3261,7 +3279,7 @@ static struct virtio_device_id id_table[] = {
> >       VIRTIO_NET_F_CTRL_MAC_ADDR, \
> >       VIRTIO_NET_F_MTU, VIRTIO_NET_F_CTRL_GUEST_OFFLOADS, \
> >       VIRTIO_NET_F_SPEED_DUPLEX, VIRTIO_NET_F_STANDBY, \
> > -     VIRTIO_NET_F_TX_HASH
> > +     VIRTIO_NET_F_TX_HASH, VIRTIO_NET_F_RX_TSTAMP
> >
> >  static unsigned int features[] = {
> >       VIRTNET_FEATURES,
> > diff --git a/include/uapi/linux/virtio_net.h b/include/uapi/linux/virtio_net.h
> > index f6881b5b77ee..0ffe2eeebd4a 100644
> > --- a/include/uapi/linux/virtio_net.h
> > +++ b/include/uapi/linux/virtio_net.h
> > @@ -57,6 +57,7 @@
> >                                        * Steering */
> >  #define VIRTIO_NET_F_CTRL_MAC_ADDR 23        /* Set MAC address */
> >
> > +#define VIRTIO_NET_F_RX_TSTAMP         55    /* Host sends TAI receive time */
> >  #define VIRTIO_NET_F_TX_HASH   56    /* Guest sends hash report */
> >  #define VIRTIO_NET_F_HASH_REPORT  57 /* Supports hash report */
> >  #define VIRTIO_NET_F_RSS       60    /* Supports RSS RX steering */
> > @@ -182,6 +183,17 @@ struct virtio_net_hdr_v1_hash {
> >       };
> >  };
> >
> > +struct virtio_net_hdr_v12 {
> > +     struct virtio_net_hdr_v1 hdr;
> > +     struct {
> > +             __le32 value;
> > +             __le16 report;
> > +             __le16 flow_state;
> > +     } hash;
> > +     __virtio32 reserved;
>
>
> Does endian-ness matter? If not - just u32?

I suppose it does not matter as long as this is reserved. Should it be
__le32, at least?

> > +     __virtio64 tstamp;
> > +};
> > +
>
> Given it's only available in modern devices, I think we
> can make this __le64 tstamp.

Actually, would it be possible to make new features available on
legacy devices? There is nothing in the features bits precluding it.

I have a revised patchset almost ready. I suppose I should send it as
RFC again, and simultaneously file an OASIS ballot for each feature?
