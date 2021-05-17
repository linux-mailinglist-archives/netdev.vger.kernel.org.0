Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 399A8386B55
	for <lists+netdev@lfdr.de>; Mon, 17 May 2021 22:24:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241509AbhEQUZM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 16:25:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237160AbhEQUZJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 May 2021 16:25:09 -0400
Received: from mail-vk1-xa2b.google.com (mail-vk1-xa2b.google.com [IPv6:2607:f8b0:4864:20::a2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FDB0C061573
        for <netdev@vger.kernel.org>; Mon, 17 May 2021 13:23:52 -0700 (PDT)
Received: by mail-vk1-xa2b.google.com with SMTP id j19so1617358vkj.0
        for <netdev@vger.kernel.org>; Mon, 17 May 2021 13:23:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=TNVxp+4uYZU44gvo81BAyFu2mBsVyk6HxBgwuTdRjGw=;
        b=Xb7tt3YStfK16ujxVVCoZcExFZ22Uh+FtP8r3MT4LMYX1A5AgkQEaEGiKG5wJH+qdP
         PeNZ4c6i8DVxyi57luCsqW5Ang2kb43bKhIFOEcYFm/B8/pxVqavwixiTK5k8mW1PvXM
         f8ipUarjrgWCa6PhRPlYtawPv/yyGxu3TENCGJfGc6r6YdP326WIN+M1FxI5Ie18ylvj
         c5ONkEc6z+UwtEdeUnoVROVztdfeshg5E4q3VJu1YsYwfEc0Gsi8mBDqlrDwOfmwYbWO
         xZd4kPYJn8JPLDxoDJ6i7VJUIWRFHKeR00WgLYTTv5UT07AcWjY2IpnpdzAO254m4FmG
         epkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=TNVxp+4uYZU44gvo81BAyFu2mBsVyk6HxBgwuTdRjGw=;
        b=ESZvXxdZc9FPU2yZwgOksNk9BQkHizHTDIiuLLJGeoqDQodu3WEcpoOzvujo28qZps
         o/rnODaohXGVIoLITRwp/GePNkjzr0rgwhajtu0hK0rPCeqL4w3Lctf7Rvk3hzzD6mt9
         wnBxNPRTHNJvoEkeUW16n9LgFTATvNkkOkRFz4r4LMJbCge9oLjrnCLIv94vL3oFUSXB
         gW3OogoK9rnHxRX5TfG2nIi9UzT99aS2aoNVSUZ647jzf4S/foSDcxkIfdlCHmuDycTe
         gGkn6dbcZTG+LkFItMDe7u+Fi+a6rmzWP/KjAzy/uT+ZCeRof50NeaQSa70nEihls+cI
         d1yA==
X-Gm-Message-State: AOAM531sIkZ8Xs4Q8BZTiREDzgUEJ7xARauEkRlFRu64T9vY9xTCG34i
        UyRr6BwPHMsdhT4QuB8YzKePfhT6bvaRUZfv
X-Google-Smtp-Source: ABdhPJzSzlFTN5E7YcUXi7HseKB1QTpJR5ZWBFn3ps9twQkH4hz55zS3xpB1IW7oiGAsALKXYeCwyQ==
X-Received: by 2002:a1f:c704:: with SMTP id x4mr1742459vkf.9.1621283030952;
        Mon, 17 May 2021 13:23:50 -0700 (PDT)
Received: from mail-vs1-f48.google.com (mail-vs1-f48.google.com. [209.85.217.48])
        by smtp.gmail.com with ESMTPSA id l8sm2437464vke.46.2021.05.17.13.23.49
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 May 2021 13:23:50 -0700 (PDT)
Received: by mail-vs1-f48.google.com with SMTP id e18so1586067vsk.5
        for <netdev@vger.kernel.org>; Mon, 17 May 2021 13:23:49 -0700 (PDT)
X-Received: by 2002:a67:fe57:: with SMTP id m23mr2025033vsr.47.1621283029295;
 Mon, 17 May 2021 13:23:49 -0700 (PDT)
MIME-Version: 1.0
References: <56270996-33a6-d71b-d935-452dad121df7@linux.alibaba.com> <CAA93jw6LUAnWZj0b5FvefpDKUyd6cajCNLoJ6OKrwbu-V_ffrA@mail.gmail.com>
In-Reply-To: <CAA93jw6LUAnWZj0b5FvefpDKUyd6cajCNLoJ6OKrwbu-V_ffrA@mail.gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Mon, 17 May 2021 16:23:10 -0400
X-Gmail-Original-Message-ID: <CA+FuTSf0Af2RXEG=rCthNNEb5mwKTG37gpEBBZU16qKkvmF=qw@mail.gmail.com>
Message-ID: <CA+FuTSf0Af2RXEG=rCthNNEb5mwKTG37gpEBBZU16qKkvmF=qw@mail.gmail.com>
Subject: Re: virtio_net: BQL?
To:     Dave Taht <dave.taht@gmail.com>
Cc:     Xianting Tian <xianting.tian@linux.alibaba.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 17, 2021 at 2:44 PM Dave Taht <dave.taht@gmail.com> wrote:
>
> Not really related to this patch, but is there some reason why virtio
> has no support for BQL?

There have been a few attempts to add it over the years.

Most recently, https://lore.kernel.org/lkml/20181205225323.12555-2-mst@redh=
at.com/

That thread has a long discussion. I think the key open issue remains

"The tricky part is the mode switching between napi and no napi."

> On Mon, May 17, 2021 at 11:41 AM Xianting Tian
> <xianting.tian@linux.alibaba.com> wrote:
> >
> > BUG_ON() uses unlikely in if(), which can be optimized at compile time.
> >
> > Signed-off-by: Xianting Tian <xianting.tian@linux.alibaba.com>
> > ---
> >   drivers/net/virtio_net.c | 5 ++---
> >   1 file changed, 2 insertions(+), 3 deletions(-)
> >
> > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > index c921ebf3ae82..212d52204884 100644
> > --- a/drivers/net/virtio_net.c
> > +++ b/drivers/net/virtio_net.c
> > @@ -1646,10 +1646,9 @@ static int xmit_skb(struct send_queue *sq, struc=
t
> > sk_buff *skb)
> >         else
> >                 hdr =3D skb_vnet_hdr(skb);
> >
> > -       if (virtio_net_hdr_from_skb(skb, &hdr->hdr,
> > +       BUG_ON(virtio_net_hdr_from_skb(skb, &hdr->hdr,
> >                                     virtio_is_little_endian(vi->vdev), =
false,
> > -                                   0))
> > -               BUG();
> > +                                   0));
> >
> >         if (vi->mergeable_rx_bufs)
> >                 hdr->num_buffers =3D 0;
> > --
> > 2.17.1
> >
>
>
> --
> Latest Podcast:
> https://www.linkedin.com/feed/update/urn:li:activity:6791014284936785920/
>
> Dave T=C3=A4ht CTO, TekLibre, LLC
