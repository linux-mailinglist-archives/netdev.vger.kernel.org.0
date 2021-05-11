Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7C0837A1B1
	for <lists+netdev@lfdr.de>; Tue, 11 May 2021 10:24:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230478AbhEKI0A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 May 2021 04:26:00 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:48169 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230457AbhEKIZ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 May 2021 04:25:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620721493;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Q1PL+lorPPHbLKN+6gUnXZ4XWrHXUKTzm1uegMqUoa0=;
        b=FrgGOWmOZrXkGPANql7Iq+2FrnNuDKg1bgyUg+Icy2Ct3j1c9RwN6HUEW+L1i88cej30A8
        WxNBRte9thw+4om9BCMKjoQw/1QG8a50907V7fCxN0Nusi/JBGXJwKVhAnhcVkXGqWvnSa
        XXtXFw8uKvnhzn+ITeh4bdVY7A/QLSQ=
Received: from mail-yb1-f197.google.com (mail-yb1-f197.google.com
 [209.85.219.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-595-057HCP4zMuaFwggmgGNEYA-1; Tue, 11 May 2021 04:24:51 -0400
X-MC-Unique: 057HCP4zMuaFwggmgGNEYA-1
Received: by mail-yb1-f197.google.com with SMTP id r2-20020a25ac420000b02904f5a9b7d37fso22987815ybd.22
        for <netdev@vger.kernel.org>; Tue, 11 May 2021 01:24:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Q1PL+lorPPHbLKN+6gUnXZ4XWrHXUKTzm1uegMqUoa0=;
        b=m1Lxt2K021ZG6dzZZqfgMMv2uexZmY5YfiRn2UliiqxmxrTtrzedXeM9Yq4+uIiDCn
         k4i/yIHZhz51eH+YymSM8YyoArbT4eoDXGILenqg1rV/ckd0Gh6UeWRqt3DGt9Ni+alj
         0j0ItnLUYcCjoYlHZEdDTIfm96ugbQySybb6Zyd3aQP/xsiCalnG+C0DkJtnv6on25lC
         tpC5Ih0pKSvrJ9jPTaN3ENUVcTSvqBag4LbB8MQUrdKwc2sKRD8aCS0YUdPRdnC0Cr3y
         tJNc0VsLLIDHDzqZRpkgzx/N2EhPFejYJ9IOzh7UYVScUirubPT7iMcFlD5D0k2QHLYb
         Gumw==
X-Gm-Message-State: AOAM532vQQ7AZODnouE9elORdr/rayYPtYX2WeNCYmyfl63xfcQzRp2D
        eCMthrJg/6/ILFVN4+5t8YjM+sW+VLwfgpu1uubTzSnjvpTBsVpk6v5G1Yr3wioyx4mfvjVF0Ys
        GOeOTi+PxIK9scSwBD6DaFUHHkAmawATc
X-Received: by 2002:a25:c78f:: with SMTP id w137mr19008465ybe.354.1620721491069;
        Tue, 11 May 2021 01:24:51 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyP1CYB9/Ie/6JUGhJvDJy95jOm7OYpDyVxrsT8AMUzUiJq1OEabHM75gpRYqxsrqQr952qKfYXS1PrN1xJVgE=
X-Received: by 2002:a25:c78f:: with SMTP id w137mr19008450ybe.354.1620721490896;
 Tue, 11 May 2021 01:24:50 -0700 (PDT)
MIME-Version: 1.0
References: <20210511044253.469034-1-yuri.benditovich@daynix.com>
 <20210511044253.469034-2-yuri.benditovich@daynix.com> <40938c20-5851-089b-c3c0-074bbd636970@redhat.com>
 <CAOEp5OdgYtP+W1thGsTGnvEPWrJ02s1HemskQpnMTUyYbsX4jQ@mail.gmail.com>
In-Reply-To: <CAOEp5OdgYtP+W1thGsTGnvEPWrJ02s1HemskQpnMTUyYbsX4jQ@mail.gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Tue, 11 May 2021 16:24:39 +0800
Message-ID: <CACGkMEuk3-iP+AxsvhT16t+5dXXtVMGoWPovM=Msm0kvo3LR2Q@mail.gmail.com>
Subject: Re: [PATCH 1/4] virtio-net: add definitions for host USO feature
To:     Yuri Benditovich <yuri.benditovich@daynix.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>,
        Yan Vugenfirer <yan@daynix.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 11, 2021 at 4:12 PM Yuri Benditovich
<yuri.benditovich@daynix.com> wrote:
>
> On Tue, May 11, 2021 at 9:47 AM Jason Wang <jasowang@redhat.com> wrote:
> >
> >
> > =E5=9C=A8 2021/5/11 =E4=B8=8B=E5=8D=8812:42, Yuri Benditovich =E5=86=99=
=E9=81=93:
> > > Define feature bit and GSO type according to the VIRTIO
> > > specification.
> > >
> > > Signed-off-by: Yuri Benditovich <yuri.benditovich@daynix.com>
> > > ---
> > >   include/uapi/linux/virtio_net.h | 2 ++
> > >   1 file changed, 2 insertions(+)
> > >
> > > diff --git a/include/uapi/linux/virtio_net.h b/include/uapi/linux/vir=
tio_net.h
> > > index 3f55a4215f11..a556ac735d7f 100644
> > > --- a/include/uapi/linux/virtio_net.h
> > > +++ b/include/uapi/linux/virtio_net.h
> > > @@ -57,6 +57,7 @@
> > >                                        * Steering */
> > >   #define VIRTIO_NET_F_CTRL_MAC_ADDR 23       /* Set MAC address */
> > >
> > > +#define VIRTIO_NET_F_HOST_USO     56 /* Host can handle USO packets =
*/
>
> This is the virtio-net feature

Right, I miss this part.

>
> > >   #define VIRTIO_NET_F_HASH_REPORT  57        /* Supports hash report=
 */
> > >   #define VIRTIO_NET_F_RSS      60    /* Supports RSS RX steering */
> > >   #define VIRTIO_NET_F_RSC_EXT          61    /* extended coalescing =
info */
> > > @@ -130,6 +131,7 @@ struct virtio_net_hdr_v1 {
> > >   #define VIRTIO_NET_HDR_GSO_TCPV4    1       /* GSO frame, IPv4 TCP =
(TSO) */
> > >   #define VIRTIO_NET_HDR_GSO_UDP              3       /* GSO frame, I=
Pv4 UDP (UFO) */
> > >   #define VIRTIO_NET_HDR_GSO_TCPV6    4       /* GSO frame, IPv6 TCP =
*/
> > > +#define VIRTIO_NET_HDR_GSO_UDP_L4    5       /* GSO frame, IPv4 UDP =
(USO) */
>
> This is respective GSO type
>
> >
> >
> > This is the gso_type not the feature actually.
> >
> > I wonder what's the reason for not
> >
> > 1) introducing a dedicated virtio-net feature bit for this
> > (VIRTIO_NET_F_GUEST_GSO_UDP_L4.
>
> This series is not for GUEST's feature, it is only for host feature.
>
> > 2) toggle the NETIF_F_GSO_UDP_L4  feature for tuntap based on the
> > negotiated feature.
>
> The NETIF_F_GSO_UDP_L4 would be required for the guest RX path.
> The guest TX path does not require any flags to be propagated, it only
> allows the guest to transmit large UDP packets and have them
> automatically splitted.
> (This is similar to HOST_UFO but does packet segmentation instead of
> fragmentation. GUEST_UFO indeed requires a respective NETIF flag, as
> it is unclear whether the guest is capable of receiving such packets).

So I think it's better to implement TX/RX in the same series unless
there's something missed:

For Guest TX, NETIF_F_GSO_UDP_L4 needs to be enabled in the guest
virtio-net only when VIRTIO_NET_F_HOST_USO is negotiated.
For guest RX, NETIF_F_GSO_UDP_L4 needs to be enabled on the host
tuntap only when VIRTIO_NET_F_GUEST_USO is neogiated.

Thanks

>
> >
> > Thanks
> >
> >
> > >   #define VIRTIO_NET_HDR_GSO_ECN              0x80    /* TCP has ECN =
set */
> > >       __u8 gso_type;
> > >       __virtio16 hdr_len;     /* Ethernet + IP + tcp/udp hdrs */
> >
>

