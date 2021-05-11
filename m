Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4D7B37A20A
	for <lists+netdev@lfdr.de>; Tue, 11 May 2021 10:31:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230399AbhEKIch (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 May 2021 04:32:37 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:30535 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229995AbhEKIcf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 May 2021 04:32:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620721888;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=L03rSJtnAgFGyBancVHdJ/m6c98PSwpvaqqILqNedlU=;
        b=RldmvnNniY/aJFqGLaEejxeAzeK19ebGP9l9ckj9HEeAicWKf4nAvcgqq0RSoRnhaD2poO
        0iHCB6o7HRCWccSSz/1xs8X3ItrorY7+SpkMrUSbSQqOYPEb4rEgfLMVxVZd2e8QlJy7Yx
        GBxcoUAgx5FCttrqboH2tw+bQHuzyNM=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-135-m5IyxhFeOUe3nYOX38dR_g-1; Tue, 11 May 2021 04:31:27 -0400
X-MC-Unique: m5IyxhFeOUe3nYOX38dR_g-1
Received: by mail-lf1-f69.google.com with SMTP id p10-20020a19f10a0000b02901d675ef8fb8so3337420lfh.16
        for <netdev@vger.kernel.org>; Tue, 11 May 2021 01:31:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=L03rSJtnAgFGyBancVHdJ/m6c98PSwpvaqqILqNedlU=;
        b=HCx5nOasSVybgYdTouO7YRoCGRfoLCEiZR9ac2mQkpwWz3illvJimwBnkIreG1hDaM
         bpGAYNoFIrWM7h9OZq6i6JTgZ5vdbLUjrS6PLX0B8nDBxCshUinCDtEkdP6H1ybzbBRs
         3623SIkin1m5czqHt1vWeXKGNEJUJ4xIyow5rnWE3Bj990rEUb42jEl2jZZaqUkrk6b+
         x2KWPZD+4KjJHxPZz2ocTQRouOyK9enf82VC1acTOvO+KdSlU/jDtWiUSkiAGM/ncEX/
         SKEtuRzUV8mKzCbyMVPYYJHh5IcI+XgE02nacEmuPf4hPD95DEsWFOg730dcJO+5pnAE
         +teA==
X-Gm-Message-State: AOAM532+5gyvhPNZhUsqit2hIfRT+xe675SPyk0ILwrOrCXESWnpbp8r
        eKDX1CsxbWTSM4OSbeNo5AjXkh4ECR88EiXAfUU8y+S7g+6SWoaTwSzTJHokaRevvkDER74BYX4
        nPr8Pbhr5xSaRPsUtfk5jb6IjDABT8C1C
X-Received: by 2002:a05:651c:3cf:: with SMTP id f15mr6277312ljp.404.1620721885569;
        Tue, 11 May 2021 01:31:25 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzHLZ1YD9/2pHaEcCCi78y5495opccD/EC/LlPQBQi+2b5oR/fD3/SoV4oxtDLQhEshzmLVnKu039vKj+S2Isw=
X-Received: by 2002:a05:651c:3cf:: with SMTP id f15mr6277299ljp.404.1620721885330;
 Tue, 11 May 2021 01:31:25 -0700 (PDT)
MIME-Version: 1.0
References: <20210511044253.469034-1-yuri.benditovich@daynix.com>
 <20210511044253.469034-3-yuri.benditovich@daynix.com> <0e31ea70-f12a-070e-c72b-6e1d337a89bc@redhat.com>
 <CAOEp5Ofi52eCV1R261afkC2Oqgn5v8V6w3QQP8tHWcEiLmsUSQ@mail.gmail.com>
In-Reply-To: <CAOEp5Ofi52eCV1R261afkC2Oqgn5v8V6w3QQP8tHWcEiLmsUSQ@mail.gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Tue, 11 May 2021 16:31:10 +0800
Message-ID: <CACGkMEsKXWN9jQ23ix26DzKv-nUfUPHPEP9Trz0saCAZkMbdRA@mail.gmail.com>
Subject: Re: [PATCH 2/4] virtio-net: add support of UDP segmentation (USO) on
 the host
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

On Tue, May 11, 2021 at 4:24 PM Yuri Benditovich
<yuri.benditovich@daynix.com> wrote:
>
> On Tue, May 11, 2021 at 9:47 AM Jason Wang <jasowang@redhat.com> wrote:
> >
> >
> > =E5=9C=A8 2021/5/11 =E4=B8=8B=E5=8D=8812:42, Yuri Benditovich =E5=86=99=
=E9=81=93:
> > > Large UDP packet provided by the guest with GSO type set to
> > > VIRTIO_NET_HDR_GSO_UDP_L4 will be divided to several UDP
> > > packets according to the gso_size field.
> > >
> > > Signed-off-by: Yuri Benditovich <yuri.benditovich@daynix.com>
> > > ---
> > >   include/linux/virtio_net.h | 5 +++++
> > >   1 file changed, 5 insertions(+)
> > >
> > > diff --git a/include/linux/virtio_net.h b/include/linux/virtio_net.h
> > > index b465f8f3e554..4ecf9a1ca912 100644
> > > --- a/include/linux/virtio_net.h
> > > +++ b/include/linux/virtio_net.h
> > > @@ -51,6 +51,11 @@ static inline int virtio_net_hdr_to_skb(struct sk_=
buff *skb,
> > >                       ip_proto =3D IPPROTO_UDP;
> > >                       thlen =3D sizeof(struct udphdr);
> > >                       break;
> > > +             case VIRTIO_NET_HDR_GSO_UDP_L4:
> > > +                     gso_type =3D SKB_GSO_UDP_L4;
> > > +                     ip_proto =3D IPPROTO_UDP;
> > > +                     thlen =3D sizeof(struct udphdr);
> > > +                     break;
> >
> >
> > This is only for rx, how about tx?
>
> In terms of the guest this is only for TX.

So virtio_net_hdr_to_skb() can be called by all the followings:

1) receive_buf() which is guest RX.
2) tun_get_user() which is guest TX
3) tap_get_user() which is guest TX
4) {t}packet_send() which is userspace TX

So it touches for both RX and TX.

> Guest RX is a different thing, this is actually coalescing of
> segmented UDP packets into a large one.

Another case, the packet could be sent from another VM (like the UFO case).

Supporting that for both TX and RX and greatly improve the performance
of VM2VM traffic.

Thanks

> This feature is not defined in the virtio spec yet and the support of
> it first of all depends on the OS.
> For example: TCP LSO (guest TX) is supported almost by all the
> versions of Windows.
> TCP RSC (coalescing of TCP segments) is supported by Win 8 / Server 2012 =
and up.
> UDP segmentation is supported by Windows kernels 1903+
> UDP coalescing is defined by Windows kernels 2004+ and not supported
> by the driver yet.
>
> >
> > Thanks
> >
> >
> >
> > >               default:
> > >                       return -EINVAL;
> > >               }
> >
>

