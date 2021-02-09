Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83D8E3150FE
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 14:56:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231873AbhBIN4G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 08:56:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232072AbhBINy6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 08:54:58 -0500
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09CA2C061786
        for <netdev@vger.kernel.org>; Tue,  9 Feb 2021 05:54:18 -0800 (PST)
Received: by mail-ej1-x629.google.com with SMTP id w2so31524997ejk.13
        for <netdev@vger.kernel.org>; Tue, 09 Feb 2021 05:54:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=LHXxRnsLKoOvgd0yvx6F4xuhgUe7ABigB+ckGTWSYwg=;
        b=Ft2JbOoNS11xYnG4jPafmaaqHhG1EEGHT7MA8DfFZxSLfyvH3n0DGPDVzkntupT43E
         +bjzWtJmfui/DGFuFDIoqmHBcQZeiCglr4ynd28Z3pqgJleOYcpaKvfC0RoiW+szcGKa
         CLmMJhbwaCXUD/O4NzezKg9O0NXgTBy3oFVNKuI6IL+6a/O1Ho5LGoOG858DdW7kMgOi
         40jW6XqilwMS4/eBnplOvOIVqEd0WwXB8wOCQppbKmxfNwBZVPLeU1hutD8TRyLvnWgT
         5SXPw9Se3AUZ9+xUxyr03aesF9vnfSWiq0jpjO5EKWJ19yWAwOvMb20BpcQ/cBFN7wfR
         LtYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=LHXxRnsLKoOvgd0yvx6F4xuhgUe7ABigB+ckGTWSYwg=;
        b=KK0URSc5OQZ6Vw5UiOIlTocJmum4yrRzhdsHRx9AAeniRVOxrQGWZWqITP5VKdI2iQ
         Z0Jzi8ojp22uvgXnWliscAATAXis9q3fEwxv3wjH5/a7dodTOa+ER3ph6ow3vf4wUJen
         ElExLty2JZuqF6//21vKDFDCUiwx2GDO2imYun1BcxzykNqBI1OoLP0uinJMqtOFRz07
         GQJvwwJa455Vq5Qylt60SiAB7aAdp1ZAHMk3wfWgHGdS7shAJADsBCf4NpXXyjJWLVH8
         TsfGfBqLOb4EMJpNf4O25M3AEahUDdl2T7ldBm6XF3ZflOk8/IgdIn/S48+AT0ss6KFM
         JjcA==
X-Gm-Message-State: AOAM531LNqJvb9XuYAY6eGceYJqWABTkD4aTZtsajAxSfaZaMrAI5g4B
        oSbcK5+NOi5pAadtlCcnuFJ+UdA27EdaAmYVTGQ=
X-Google-Smtp-Source: ABdhPJwxdUAn9WHjqsT4NJBsFmkI4fLufcraU6RK4VvOJrza9m3CIZ7ManUXZ4AXC4z/SfN0G3UI3LDwT9GWibA5Vdk=
X-Received: by 2002:a17:906:4dc5:: with SMTP id f5mr22171118ejw.11.1612878856672;
 Tue, 09 Feb 2021 05:54:16 -0800 (PST)
MIME-Version: 1.0
References: <20210208185558.995292-1-willemdebruijn.kernel@gmail.com>
 <20210208185558.995292-3-willemdebruijn.kernel@gmail.com> <c089cb3e-96cb-b42a-5ce1-d54d298987c4@redhat.com>
In-Reply-To: <c089cb3e-96cb-b42a-5ce1-d54d298987c4@redhat.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 9 Feb 2021 08:53:40 -0500
Message-ID: <CAF=yD-Jkm-Cfs2tHKhC17KfPp+=18y=9_XSuY-LNgkC-2_NfLA@mail.gmail.com>
Subject: Re: [PATCH RFC v2 2/4] virtio-net: support receive timestamp
To:     Jason Wang <jasowang@redhat.com>
Cc:     virtualization@lists.linux-foundation.org,
        Network Development <netdev@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Willem de Bruijn <willemb@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 8, 2021 at 11:13 PM Jason Wang <jasowang@redhat.com> wrote:
>
>
> On 2021/2/9 =E4=B8=8A=E5=8D=882:55, Willem de Bruijn wrote:
> > From: Willem de Bruijn <willemb@google.com>
> >
> > Add optional PTP hardware rx timestamp offload for virtio-net.
> >
> > Accurate RTT measurement requires timestamps close to the wire.
> > Introduce virtio feature VIRTIO_NET_F_RX_TSTAMP. If negotiated, the
> > virtio-net header is expanded with room for a timestamp.
> >
> > A device may pass receive timestamps for all or some packets. Flag
> > VIRTIO_NET_HDR_F_TSTAMP signals whether a timestamp is recorded.
> >
> > A driver that supports hardware timestamping must also support
> > ioctl SIOCSHWTSTAMP. Implement that, as well as information getters
> > ioctl SIOCGHWTSTAMP and ethtool get_ts_info (`ethtool -T $DEV`).
> >
> > The timestamp straddles (virtual) hardware domains. Like PTP, use
> > international atomic time (CLOCK_TAI) as global clock base. The driver
> > must sync with the device, e.g., through kvm-clock.
> >
> > Tested:
> >    guest: ./timestamping eth0 \
> >            SOF_TIMESTAMPING_RAW_HARDWARE \
> >            SOF_TIMESTAMPING_RX_HARDWARE
> >    host: nc -4 -u 192.168.1.1 319
> >
> > Changes RFC -> RFCv2
> >    - rename virtio_net_hdr_v12 to virtio_net_hdr_hash_ts
> >    - add ethtool .get_ts_info to query capabilities
> >    - add ioctl SIOC[GS]HWTSTAMP to configure feature
> >    - add vi->enable_rx_tstamp to store configuration
> >    - convert virtioXX_to_cpu to leXX_to_cpu
> >    - convert reserved to __u32
> >
> > Signed-off-by: Willem de Bruijn <willemb@google.com>

> >   static const struct net_device_ops virtnet_netdev =3D {
> >       .ndo_open            =3D virtnet_open,
> >       .ndo_stop            =3D virtnet_close,
> > @@ -2573,6 +2676,7 @@ static const struct net_device_ops virtnet_netdev=
 =3D {
> >       .ndo_features_check     =3D passthru_features_check,
> >       .ndo_get_phys_port_name =3D virtnet_get_phys_port_name,
> >       .ndo_set_features       =3D virtnet_set_features,
> > +     .ndo_do_ioctl           =3D virtnet_ioctl,
> >   };
> >
> >   static void virtnet_config_changed_work(struct work_struct *work)
> > @@ -3069,6 +3173,11 @@ static int virtnet_probe(struct virtio_device *v=
dev)
> >               vi->hdr_len =3D sizeof(struct virtio_net_hdr_v1_hash);
> >       }
> >
> > +     if (virtio_has_feature(vdev, VIRTIO_NET_F_RX_TSTAMP)) {
> > +             vi->has_rx_tstamp =3D true;
> > +             vi->hdr_len =3D sizeof(struct virtio_net_hdr_hash_ts);
>
>
> Does this mean even if the device doesn't pass timestamp, the header
> still contains the timestamp fields.

Yes. As implemented, the size of the header is constant across
packets. If both sides negotiate the feature, then all headers reserve
space, whether or not the specific packet has a timestamp.

So far headers are fixed size. I suppose we could investigate variable
size headers. This goes back to our discussion in the previous
patchset, that we can always add a packed-header feature later, if the
number of optional features reaches a size that makes the complexity
worthwhile.

> > +     }
> > +
> >       if (virtio_has_feature(vdev, VIRTIO_F_ANY_LAYOUT) ||
> >           virtio_has_feature(vdev, VIRTIO_F_VERSION_1))
> >               vi->any_header_sg =3D true;
> > @@ -3260,7 +3369,7 @@ static struct virtio_device_id id_table[] =3D {
> >       VIRTIO_NET_F_CTRL_MAC_ADDR, \
> >       VIRTIO_NET_F_MTU, VIRTIO_NET_F_CTRL_GUEST_OFFLOADS, \
> >       VIRTIO_NET_F_SPEED_DUPLEX, VIRTIO_NET_F_STANDBY, \
> > -     VIRTIO_NET_F_TX_HASH
> > +     VIRTIO_NET_F_TX_HASH, VIRTIO_NET_F_RX_TSTAMP
> >
> >   static unsigned int features[] =3D {
> >       VIRTNET_FEATURES,
> > diff --git a/include/uapi/linux/virtio_net.h b/include/uapi/linux/virti=
o_net.h
> > index 273d43c35f59..a5c84410cf92 100644
> > --- a/include/uapi/linux/virtio_net.h
> > +++ b/include/uapi/linux/virtio_net.h
> > @@ -57,6 +57,7 @@
> >                                        * Steering */
> >   #define VIRTIO_NET_F_CTRL_MAC_ADDR 23       /* Set MAC address */
> >
> > +#define VIRTIO_NET_F_RX_TSTAMP         55    /* Device sends TAI recei=
ve time */
> >   #define VIRTIO_NET_F_TX_HASH          56    /* Driver sends hash repo=
rt */
> >   #define VIRTIO_NET_F_HASH_REPORT  57        /* Supports hash report *=
/
> >   #define VIRTIO_NET_F_RSS      60    /* Supports RSS RX steering */
> > @@ -126,6 +127,7 @@ struct virtio_net_hdr_v1 {
> >   #define VIRTIO_NET_HDR_F_NEEDS_CSUM 1       /* Use csum_start, csum_o=
ffset */
> >   #define VIRTIO_NET_HDR_F_DATA_VALID 2       /* Csum is valid */
> >   #define VIRTIO_NET_HDR_F_RSC_INFO   4       /* rsc info in csum_ fiel=
ds */
> > +#define VIRTIO_NET_HDR_F_TSTAMP              8       /* timestamp is r=
ecorded */
> >       __u8 flags;
> >   #define VIRTIO_NET_HDR_GSO_NONE             0       /* Not a GSO fram=
e */
> >   #define VIRTIO_NET_HDR_GSO_TCPV4    1       /* GSO frame, IPv4 TCP (T=
SO) */
> > @@ -181,6 +183,17 @@ struct virtio_net_hdr_v1_hash {
> >       };
> >   };
> >
> > +struct virtio_net_hdr_hash_ts {
> > +     struct virtio_net_hdr_v1 hdr;
> > +     struct {
> > +             __le32 value;
> > +             __le16 report;
> > +             __le16 flow_state;
> > +     } hash;
>
>
> Any reason for not embedding structure virtio_net_hdr_v1_hash?

Just that it becomes an onion of struct inside structs. I can change
if you prefer.

> Thanks

As always, thanks for reviewing, Jason.
