Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2FD4315D74
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 03:41:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235338AbhBJCkD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 21:40:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235184AbhBJCiQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 21:38:16 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC976C061574
        for <netdev@vger.kernel.org>; Tue,  9 Feb 2021 18:37:35 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id w1so1220762ejf.11
        for <netdev@vger.kernel.org>; Tue, 09 Feb 2021 18:37:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=X3d0m+efZXIn0whUV4akrtWMQvxr38fSqzQd0PRb69g=;
        b=vN8ErVKh6rcmv52Mxc2Z6dNyclkNbP6a7G/2SAvZec+h+gFHyUx5Her3+algJyUFMa
         ReZAwcN9vFcjTD+36++0XF26paz8093o2mk0X3Af9q16xx7hpMum8NzoFPznhVqkEc42
         JYaVPJYXv8nx3BJQ/k7garHZJrtstZtTFHIkDvwwcl3b4SCdMgYsolzOp6jpd2R7pdoj
         ea3IwhgX9HAfosn8ryZJtFLo6hc1BUq4aHdxfnbzn4Xun3wlu/CXpGiNMEFhoVw4GGkV
         BinkNr+ThJWNXbgyywFiD2onUoI5o6BLlReGL0wcPoUPZhFMB10HEDm8kerOEB5cHLIA
         bX/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=X3d0m+efZXIn0whUV4akrtWMQvxr38fSqzQd0PRb69g=;
        b=bZG6pGoA/YwqchdyRG1HpToqjHk5tcIMjAn6ZnmWwySYZtsoX+EUIZ0GKmEP5csUgK
         WjCtiY2d4s4NsU7OX2hesgjZvQRe6MXOeH/7utzTqXjuKZ5qqk/hXDn7SKHukn7vgn8B
         MVndcucuZ+3X4fVUbE+Pj5+PEVLb+E0rSfbd48CZL1fKB04sPpQ1TmQPiD+pRJ8EsoNx
         QFe3l4KhZiBc9FmkDuLqM/YEJBI7dXr6LxYfmin43/6yPV2cLwusR5FZP+ZkSXln2tRB
         ivLVshBEubRzoqzy+vyQpwtpp2djMeLJ5s/HzUGOzf6EdPHKGmD5+d0bt8dPt9HY760G
         PDwQ==
X-Gm-Message-State: AOAM531tbZhsouGDSht9NWGalnBGZPGL3gpdp9jB5z+R9NNtxzYGdDM0
        dKdMMJHyTfdIfGNXFzFvO6S3C9nHDghO7CPtJy8=
X-Google-Smtp-Source: ABdhPJw+o+kLvC8cfCTnc7cqIx3d4z2fdh8QVgJPjSOULc6+oCFuOxTmqDuO7tgYJSvQPoCI2H/DoY6mM95RrdurARg=
X-Received: by 2002:a17:906:158c:: with SMTP id k12mr733211ejd.119.1612924654561;
 Tue, 09 Feb 2021 18:37:34 -0800 (PST)
MIME-Version: 1.0
References: <20210208185558.995292-1-willemdebruijn.kernel@gmail.com>
 <20210208185558.995292-4-willemdebruijn.kernel@gmail.com> <6bfdf48d-c780-bc65-b0b9-24a33f18827b@redhat.com>
 <20210209113643-mutt-send-email-mst@kernel.org>
In-Reply-To: <20210209113643-mutt-send-email-mst@kernel.org>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 9 Feb 2021 21:36:58 -0500
Message-ID: <CAF=yD-Lw7LKypTLEfQmcqR9SwcL6f9wH=_yjQdyGak4ORegRug@mail.gmail.com>
Subject: Re: [PATCH RFC v2 3/4] virtio-net: support transmit timestamp
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Jason Wang <jasowang@redhat.com>,
        virtualization@lists.linux-foundation.org,
        Network Development <netdev@vger.kernel.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Willem de Bruijn <willemb@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 9, 2021 at 11:39 AM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> On Tue, Feb 09, 2021 at 01:45:11PM +0800, Jason Wang wrote:
> >
> > On 2021/2/9 =E4=B8=8A=E5=8D=882:55, Willem de Bruijn wrote:
> > > From: Willem de Bruijn <willemb@google.com>
> > >
> > > Add optional PTP hardware tx timestamp offload for virtio-net.
> > >
> > > Accurate RTT measurement requires timestamps close to the wire.
> > > Introduce virtio feature VIRTIO_NET_F_TX_TSTAMP, the transmit
> > > equivalent to VIRTIO_NET_F_RX_TSTAMP.
> > >
> > > The driver sets VIRTIO_NET_HDR_F_TSTAMP to request a timestamp
> > > returned on completion. If the feature is negotiated, the device
> > > either places the timestamp or clears the feature bit.
> > >
> > > The timestamp straddles (virtual) hardware domains. Like PTP, use
> > > international atomic time (CLOCK_TAI) as global clock base. The drive=
r
> > > must sync with the device, e.g., through kvm-clock.
> > >
> > > Modify can_push to ensure that on tx completion the header, and thus
> > > timestamp, is in a predicatable location at skb_vnet_hdr.
> > >
> > > RFC: this implementation relies on the device writing to the buffer.
> > > That breaks DMA_TO_DEVICE semantics. For now, disable when DMA is on.
> > > The virtio changes should be a separate patch at the least.
> > >
> > > Tested: modified txtimestamp.c to with h/w timestamping:
> > >    -       sock_opt =3D SOF_TIMESTAMPING_SOFTWARE |
> > >    +       sock_opt =3D SOF_TIMESTAMPING_RAW_HARDWARE |
> > >    + do_test(family, SOF_TIMESTAMPING_TX_HARDWARE);
> > >
> > > Signed-off-by: Willem de Bruijn <willemb@google.com>
> > > ---
> > >   drivers/net/virtio_net.c        | 61 ++++++++++++++++++++++++++++--=
---
> > >   drivers/virtio/virtio_ring.c    |  3 +-
> > >   include/linux/virtio.h          |  1 +
> > >   include/uapi/linux/virtio_net.h |  1 +
> > >   4 files changed, 56 insertions(+), 10 deletions(-)
> > >
> > > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > > index ac44c5efa0bc..fc8ecd3a333a 100644
> > > --- a/drivers/net/virtio_net.c
> > > +++ b/drivers/net/virtio_net.c
> > > @@ -210,6 +210,12 @@ struct virtnet_info {
> > >     /* Device will pass rx timestamp. Requires has_rx_tstamp */
> > >     bool enable_rx_tstamp;
> > > +   /* Device can pass CLOCK_TAI transmit time to the driver */
> > > +   bool has_tx_tstamp;
> > > +
> > > +   /* Device will pass tx timestamp. Requires has_tx_tstamp */
> > > +   bool enable_tx_tstamp;
> > > +
> > >     /* Has control virtqueue */
> > >     bool has_cvq;
> > > @@ -1401,6 +1407,20 @@ static int virtnet_receive(struct receive_queu=
e *rq, int budget,
> > >     return stats.packets;
> > >   }
> > > +static void virtnet_record_tx_tstamp(const struct send_queue *sq,
> > > +                                struct sk_buff *skb)
> > > +{
> > > +   const struct virtio_net_hdr_hash_ts *h =3D skb_vnet_hdr_ht(skb);
> > > +   const struct virtnet_info *vi =3D sq->vq->vdev->priv;
> > > +   struct skb_shared_hwtstamps ts;
> > > +
> > > +   if (h->hdr.flags & VIRTIO_NET_HDR_F_TSTAMP &&
> > > +       vi->enable_tx_tstamp) {
> > > +           ts.hwtstamp =3D ns_to_ktime(le64_to_cpu(h->tstamp));
> > > +           skb_tstamp_tx(skb, &ts);
> >
> >
> > This probably won't work since the buffer is read-only from the device.=
 (See
> > virtqueue_add_outbuf()).
> >
> > Another issue that I vaguely remember that the virtio spec forbids out
> > buffer after in buffer.
>
> Both Driver Requirements: Message Framing and Driver Requirements: Scatte=
r-Gather Support
> have this statement:
>
>         The driver MUST place any device-writable descriptor elements aft=
er any device-readable descriptor ele-
>         ments.
>
>
> similarly
>
> Device Requirements: The Virtqueue Descriptor Table
>         A device MUST NOT write to a device-readable buffer, and a device=
 SHOULD NOT read a device-writable
>         buffer.

Thanks. That's clear. So the clean solution would be to add a
device-writable descriptor after the existing device-readable ones.

And the device must be aware that this is to return the tstamp only.
In the example implementation of vhost, it has to exclude this last
descriptor from the msg->msg_iter iovec array with packet data
initialized at get_tx_bufs/init_iov_iter.
