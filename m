Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AE5237A16F
	for <lists+netdev@lfdr.de>; Tue, 11 May 2021 10:12:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230422AbhEKINh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 May 2021 04:13:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230338AbhEKINg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 May 2021 04:13:36 -0400
Received: from mail-ot1-x32b.google.com (mail-ot1-x32b.google.com [IPv6:2607:f8b0:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB475C061574
        for <netdev@vger.kernel.org>; Tue, 11 May 2021 01:12:29 -0700 (PDT)
Received: by mail-ot1-x32b.google.com with SMTP id f75-20020a9d03d10000b0290280def9ab76so16791011otf.12
        for <netdev@vger.kernel.org>; Tue, 11 May 2021 01:12:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=V4OvBsGlOboDMJilacIfX93BeArUzpCix7At3EOUarw=;
        b=lmkuZ7aDqLoygz/VlHzMEKZGrl/9XcMQTxU2tuT9mZhq0XTw/tD6YTyLFhazQMDYt9
         8zsBDzeJyVE1UpLyZiCRDTZVlbriSASCZMNryZutMDr0D8mzpX2ADN4ZeBdz4X3bHN0N
         WCNkGFc4CTnoBVv5uGBz3kfd6ybzBH+9lmTS8pokT0di2GHzk6YjGFIJcDXc5CcxCW7T
         nFKPhaBXRKMSlkC2NpFgBMsLmdcDWCyKtqzIWxh5lf2Epzpng2D79dYA/7zAsvWaHbge
         wNiOLhXNwKKOrSBYWgY0RzM/2pjxJqJJDxNHPuCWLsllM2LRf3Fzoi/svD1xstkjNrYg
         Q3Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=V4OvBsGlOboDMJilacIfX93BeArUzpCix7At3EOUarw=;
        b=Ri/rJbaefiFEP6QLbEgmfcaJidRNSgtZ6w5ENsH6ONjoCj3A3kJJsigufw2FmPnnOg
         q4RciUTd+iI1OQns/EalO8ZL55WbjMK8kP4Vl++9Who91lq+PgTDJj1S7u+Ce16XTFeO
         TTpFbl4u8QvCTfElzlvoyX7IA2m5fZdCgcXy4ApjRmNI/LEVchv0ley+BxDnOfK3FN/Q
         LMmwDcwAXsjDmXxYwJcA0CSi3jT3Dx6ojQQUdUTI4cuo2ko7LEvcv/TIxbr+EOhbI7d0
         NT8YtBEGhNIClz2tBJh1xXy9vrkRMFagDfnWZnxY3g0lBqqZuAG56k6xWIqAJkZQHDhD
         lMUw==
X-Gm-Message-State: AOAM532IvvaVsgCv2jpxttqhP3FspOeDXGAHL8axft/DYeTOp5Db/ytF
        I/sB2oOoBf78mh+qXOTjKQr6hdxrCajKUxW+08vfRQ==
X-Google-Smtp-Source: ABdhPJzjpKpzE2uIaT3SST5gktTqbv6RbiB2hBKWt6nVkBt9S62hZ5H6ZT0FqybWOJb5zIq+d0MrfyMVMdMmpOGfEjI=
X-Received: by 2002:a05:6830:4103:: with SMTP id w3mr20651835ott.27.1620720749398;
 Tue, 11 May 2021 01:12:29 -0700 (PDT)
MIME-Version: 1.0
References: <20210511044253.469034-1-yuri.benditovich@daynix.com>
 <20210511044253.469034-2-yuri.benditovich@daynix.com> <40938c20-5851-089b-c3c0-074bbd636970@redhat.com>
In-Reply-To: <40938c20-5851-089b-c3c0-074bbd636970@redhat.com>
From:   Yuri Benditovich <yuri.benditovich@daynix.com>
Date:   Tue, 11 May 2021 11:12:16 +0300
Message-ID: <CAOEp5OdgYtP+W1thGsTGnvEPWrJ02s1HemskQpnMTUyYbsX4jQ@mail.gmail.com>
Subject: Re: [PATCH 1/4] virtio-net: add definitions for host USO feature
To:     Jason Wang <jasowang@redhat.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        virtualization@lists.linux-foundation.org,
        Yan Vugenfirer <yan@daynix.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 11, 2021 at 9:47 AM Jason Wang <jasowang@redhat.com> wrote:
>
>
> =E5=9C=A8 2021/5/11 =E4=B8=8B=E5=8D=8812:42, Yuri Benditovich =E5=86=99=
=E9=81=93:
> > Define feature bit and GSO type according to the VIRTIO
> > specification.
> >
> > Signed-off-by: Yuri Benditovich <yuri.benditovich@daynix.com>
> > ---
> >   include/uapi/linux/virtio_net.h | 2 ++
> >   1 file changed, 2 insertions(+)
> >
> > diff --git a/include/uapi/linux/virtio_net.h b/include/uapi/linux/virti=
o_net.h
> > index 3f55a4215f11..a556ac735d7f 100644
> > --- a/include/uapi/linux/virtio_net.h
> > +++ b/include/uapi/linux/virtio_net.h
> > @@ -57,6 +57,7 @@
> >                                        * Steering */
> >   #define VIRTIO_NET_F_CTRL_MAC_ADDR 23       /* Set MAC address */
> >
> > +#define VIRTIO_NET_F_HOST_USO     56 /* Host can handle USO packets */

This is the virtio-net feature

> >   #define VIRTIO_NET_F_HASH_REPORT  57        /* Supports hash report *=
/
> >   #define VIRTIO_NET_F_RSS      60    /* Supports RSS RX steering */
> >   #define VIRTIO_NET_F_RSC_EXT          61    /* extended coalescing in=
fo */
> > @@ -130,6 +131,7 @@ struct virtio_net_hdr_v1 {
> >   #define VIRTIO_NET_HDR_GSO_TCPV4    1       /* GSO frame, IPv4 TCP (T=
SO) */
> >   #define VIRTIO_NET_HDR_GSO_UDP              3       /* GSO frame, IPv=
4 UDP (UFO) */
> >   #define VIRTIO_NET_HDR_GSO_TCPV6    4       /* GSO frame, IPv6 TCP */
> > +#define VIRTIO_NET_HDR_GSO_UDP_L4    5       /* GSO frame, IPv4 UDP (U=
SO) */

This is respective GSO type

>
>
> This is the gso_type not the feature actually.
>
> I wonder what's the reason for not
>
> 1) introducing a dedicated virtio-net feature bit for this
> (VIRTIO_NET_F_GUEST_GSO_UDP_L4.

This series is not for GUEST's feature, it is only for host feature.

> 2) toggle the NETIF_F_GSO_UDP_L4  feature for tuntap based on the
> negotiated feature.

The NETIF_F_GSO_UDP_L4 would be required for the guest RX path.
The guest TX path does not require any flags to be propagated, it only
allows the guest to transmit large UDP packets and have them
automatically splitted.
(This is similar to HOST_UFO but does packet segmentation instead of
fragmentation. GUEST_UFO indeed requires a respective NETIF flag, as
it is unclear whether the guest is capable of receiving such packets).

>
> Thanks
>
>
> >   #define VIRTIO_NET_HDR_GSO_ECN              0x80    /* TCP has ECN se=
t */
> >       __u8 gso_type;
> >       __virtio16 hdr_len;     /* Ethernet + IP + tcp/udp hdrs */
>
