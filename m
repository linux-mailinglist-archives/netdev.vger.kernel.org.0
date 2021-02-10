Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4ACC31694D
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 15:42:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230043AbhBJOmM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 09:42:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230014AbhBJOmD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 09:42:03 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A62BCC061574
        for <netdev@vger.kernel.org>; Wed, 10 Feb 2021 06:41:21 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id w2so4599552ejk.13
        for <netdev@vger.kernel.org>; Wed, 10 Feb 2021 06:41:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=lX1gJvsaJMOE2HAb4oPWo/N+8MXFPja4wdxtivXDiE4=;
        b=gWUQ0Ou+JJ8cIRNFgEVYrux2Oy3TDrho0YHS7FImAisolJ0Z1/S28JztOc4+pkui1+
         ImoTy/GFmtTdCKrqw8R/L5eqN5aerrrj1wL0bzeB6PSvj+2d7p60YNxIjwnJkwTH4LCr
         jbglhhbLOxaIIXodeK9NCxIPRfZhguxNn1pUCCChfKBH9fNmlzh4TXRXSHcLLxwrs8WC
         FjF77qdCZCrxbFTzLua4JEvafEP/rRTfbFfMsjwvrR2DlhIW7VBA1xWgx5IyT6qj+slp
         blLC36BrDBK1sa6xQdTOBrlg1Ql7Jeys088g8mUHjtHETm7vy+53GzemovL2sxi/F6z5
         X9pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=lX1gJvsaJMOE2HAb4oPWo/N+8MXFPja4wdxtivXDiE4=;
        b=C5QwbjDHuyFGd6UidIJSeLLttJ05R/RSKfcsZcwkxATaAFysEI+nL//7kyBok9unf/
         w7O7cnoZiwJpzkMCjvhu+fkYAJdL8C0XG1xEAjpqM2y/pmyTjmR7QY0ttbKC9iR1r+u4
         59CGMUwfyAM0R3yGe5KMO0Dg4t0obsk+DKaRjSbZgdaqRguHxvvZCK+wVVhCaw3xyAuK
         igQUJ6f55K6zfqPGHMw/KzbQjJxy7yeUJwzx42PSt+h8Gz4hwxFuUvQWIcCVARyudJF/
         Har8nAigBp5S6rfgCLr3q6kAzHsZXxmKhPsPhn/At0BewyGSUg5E1y+VH7NldxC1QeVO
         Jb5g==
X-Gm-Message-State: AOAM530tKoG3JIj/bJIeaMKVPQhaSruIYj0LB7mVYbjnLc/fAPnJ9XN0
        cDDV1WubSNuw3t5PxTSI1fBU1FHS419zhLbALbo=
X-Google-Smtp-Source: ABdhPJyXpW27MAdu1Z1p13czrxpyX4vFJ5nzDgxwB80JNQc9NcYuG8eufXyFt15QOni3kyaVA04ja5i9wD+Vz35J+Q0=
X-Received: by 2002:a17:906:4dc5:: with SMTP id f5mr3211802ejw.11.1612968080427;
 Wed, 10 Feb 2021 06:41:20 -0800 (PST)
MIME-Version: 1.0
References: <20210208185558.995292-1-willemdebruijn.kernel@gmail.com>
 <20210208185558.995292-4-willemdebruijn.kernel@gmail.com> <6bfdf48d-c780-bc65-b0b9-24a33f18827b@redhat.com>
 <20210209113643-mutt-send-email-mst@kernel.org> <CAF=yD-Lw7LKypTLEfQmcqR9SwcL6f9wH=_yjQdyGak4ORegRug@mail.gmail.com>
 <af5b16fb-8b22-f081-3aa0-92839b7153d6@redhat.com>
In-Reply-To: <af5b16fb-8b22-f081-3aa0-92839b7153d6@redhat.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 10 Feb 2021 09:40:44 -0500
Message-ID: <CAF=yD-JLcuaRckKGJSt9Oi-_7W2=1t9FLR6=Thdh5krh6+L9sw@mail.gmail.com>
Subject: Re: [PATCH RFC v2 3/4] virtio-net: support transmit timestamp
To:     Jason Wang <jasowang@redhat.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        virtualization@lists.linux-foundation.org,
        Network Development <netdev@vger.kernel.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Willem de Bruijn <willemb@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 9, 2021 at 11:15 PM Jason Wang <jasowang@redhat.com> wrote:
>
>
> On 2021/2/10 =E4=B8=8A=E5=8D=8810:36, Willem de Bruijn wrote:
> > On Tue, Feb 9, 2021 at 11:39 AM Michael S. Tsirkin<mst@redhat.com>  wro=
te:
> >> On Tue, Feb 09, 2021 at 01:45:11PM +0800, Jason Wang wrote:
> >>> On 2021/2/9 =E4=B8=8A=E5=8D=882:55, Willem de Bruijn wrote:
> >>>> From: Willem de Bruijn<willemb@google.com>
> >>>>
> >>>> Add optional PTP hardware tx timestamp offload for virtio-net.
> >>>>
> >>>> Accurate RTT measurement requires timestamps close to the wire.
> >>>> Introduce virtio feature VIRTIO_NET_F_TX_TSTAMP, the transmit
> >>>> equivalent to VIRTIO_NET_F_RX_TSTAMP.
> >>>>
> >>>> The driver sets VIRTIO_NET_HDR_F_TSTAMP to request a timestamp
> >>>> returned on completion. If the feature is negotiated, the device
> >>>> either places the timestamp or clears the feature bit.
> >>>>
> >>>> The timestamp straddles (virtual) hardware domains. Like PTP, use
> >>>> international atomic time (CLOCK_TAI) as global clock base. The driv=
er
> >>>> must sync with the device, e.g., through kvm-clock.
> >>>>
> >>>> Modify can_push to ensure that on tx completion the header, and thus
> >>>> timestamp, is in a predicatable location at skb_vnet_hdr.
> >>>>
> >>>> RFC: this implementation relies on the device writing to the buffer.
> >>>> That breaks DMA_TO_DEVICE semantics. For now, disable when DMA is on=
.
> >>>> The virtio changes should be a separate patch at the least.
> >>>>
> >>>> Tested: modified txtimestamp.c to with h/w timestamping:
> >>>>     -       sock_opt =3D SOF_TIMESTAMPING_SOFTWARE |
> >>>>     +       sock_opt =3D SOF_TIMESTAMPING_RAW_HARDWARE |
> >>>>     + do_test(family, SOF_TIMESTAMPING_TX_HARDWARE);
> >>>>
> >>>> Signed-off-by: Willem de Bruijn<willemb@google.com>
> >>>> ---
> >>>>    drivers/net/virtio_net.c        | 61 ++++++++++++++++++++++++++++=
-----
> >>>>    drivers/virtio/virtio_ring.c    |  3 +-
> >>>>    include/linux/virtio.h          |  1 +
> >>>>    include/uapi/linux/virtio_net.h |  1 +
> >>>>    4 files changed, 56 insertions(+), 10 deletions(-)
> >>>>
> >>>> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> >>>> index ac44c5efa0bc..fc8ecd3a333a 100644
> >>>> --- a/drivers/net/virtio_net.c
> >>>> +++ b/drivers/net/virtio_net.c
> >>>> @@ -210,6 +210,12 @@ struct virtnet_info {
> >>>>      /* Device will pass rx timestamp. Requires has_rx_tstamp */
> >>>>      bool enable_rx_tstamp;
> >>>> +   /* Device can pass CLOCK_TAI transmit time to the driver */
> >>>> +   bool has_tx_tstamp;
> >>>> +
> >>>> +   /* Device will pass tx timestamp. Requires has_tx_tstamp */
> >>>> +   bool enable_tx_tstamp;
> >>>> +
> >>>>      /* Has control virtqueue */
> >>>>      bool has_cvq;
> >>>> @@ -1401,6 +1407,20 @@ static int virtnet_receive(struct receive_que=
ue *rq, int budget,
> >>>>      return stats.packets;
> >>>>    }
> >>>> +static void virtnet_record_tx_tstamp(const struct send_queue *sq,
> >>>> +                                struct sk_buff *skb)
> >>>> +{
> >>>> +   const struct virtio_net_hdr_hash_ts *h =3D skb_vnet_hdr_ht(skb);
> >>>> +   const struct virtnet_info *vi =3D sq->vq->vdev->priv;
> >>>> +   struct skb_shared_hwtstamps ts;
> >>>> +
> >>>> +   if (h->hdr.flags & VIRTIO_NET_HDR_F_TSTAMP &&
> >>>> +       vi->enable_tx_tstamp) {
> >>>> +           ts.hwtstamp =3D ns_to_ktime(le64_to_cpu(h->tstamp));
> >>>> +           skb_tstamp_tx(skb, &ts);
> >>> This probably won't work since the buffer is read-only from the devic=
e. (See
> >>> virtqueue_add_outbuf()).
> >>>
> >>> Another issue that I vaguely remember that the virtio spec forbids ou=
t
> >>> buffer after in buffer.
> >> Both Driver Requirements: Message Framing and Driver Requirements: Sca=
tter-Gather Support
> >> have this statement:
> >>
> >>          The driver MUST place any device-writable descriptor elements=
 after any device-readable descriptor ele-
> >>          ments.
> >>
> >>
> >> similarly
> >>
> >> Device Requirements: The Virtqueue Descriptor Table
> >>          A device MUST NOT write to a device-readable buffer, and a de=
vice SHOULD NOT read a device-writable
> >>          buffer.
> > Thanks. That's clear. So the clean solution would be to add a
> > device-writable descriptor after the existing device-readable ones.
>
>
> I think so, but a question is the format for this tailer. I think it
> might be better to post a spec patch to discuss.

Okay I'll do that. I want to get something that works first, to make
sure that whatever I propose in spec is actually implementable.
