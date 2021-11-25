Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA49C45D551
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 08:18:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231869AbhKYHVJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Nov 2021 02:21:09 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:25237 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1353405AbhKYHTB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Nov 2021 02:19:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637824550;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=szt1FOtN/yKjgweBlM0Od5s5VcOUOXKDzr7rDCCMpLA=;
        b=YB+GNjCQQpQmJSXOg1bgJ3x5Q6Y7s+GpDYgmkmMutbYFewepru8arW1KoPATeRz2IUOVox
        MnTvxA/3trKNp979EQqKq/kHndAaH0jzBW8fvKIOf+bOQ1tB+ZR9FsYndN5OjaONUNmC8l
        wt21phG/bPFoAgAUuh10dn8PVuwShkQ=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-602-E39HOidAP7qdEQv-0tRNDA-1; Thu, 25 Nov 2021 02:15:46 -0500
X-MC-Unique: E39HOidAP7qdEQv-0tRNDA-1
Received: by mail-lj1-f197.google.com with SMTP id p1-20020a2e7401000000b00218d0d11e91so1560797ljc.15
        for <netdev@vger.kernel.org>; Wed, 24 Nov 2021 23:15:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=szt1FOtN/yKjgweBlM0Od5s5VcOUOXKDzr7rDCCMpLA=;
        b=Qw2dxvi1q32ZD3RcZKacXd4IENeLtHpHIGfmrIO99AbBXV30CJjOf3IJQL9ilKvD/+
         CrivI76AxxGQxc14Pv+4FvThgPg5Y3UIOrn4gVFh+lWu8gRPvlgOznaIxwz6cu6LC+FW
         LZrBXxoK4BwWjHRLLwu9uwSGgcgAmmpA3T96i9KngcCBnck8TFye/MIr7BqVD5f3d4PI
         rZmWuM71R97/ToBHHNE20/T14KyBDuxlVsdpiSfyWDqANxk9sgvFMR7kJJ75JvzBU5ez
         An+9fXXwJ4CnUEdNtTOmCy+pnc9NQWu9LGas2GCTkU9RQE7j1TpedRrZGrawQAa/oXLO
         /VxQ==
X-Gm-Message-State: AOAM530OgKeBcc/h9w+IBaRg5U/O79Gccc5Nlng74CAIW3P7nWelxwrc
        kohSPxoY5OE2X9R9ynVYKiAz5tmjxcO6xdgfblLnPv+nRNqOZ2CqM0zrVo5LzFqR12VsWQJHFGv
        Krp5N5xBhSZua/FS0hg8JmoWevMxxebW4
X-Received: by 2002:a05:6512:3b2b:: with SMTP id f43mr22280536lfv.629.1637824544769;
        Wed, 24 Nov 2021 23:15:44 -0800 (PST)
X-Google-Smtp-Source: ABdhPJydNnhWXm+uH7A9B5KzQZ/aiL2nu5QtNv1eSqbQCKNF0zM5qAS0rfIEcPJw8SEUOYhZe5llo1IdPIBthw2VxrE=
X-Received: by 2002:a05:6512:3b2b:: with SMTP id f43mr22280511lfv.629.1637824544520;
 Wed, 24 Nov 2021 23:15:44 -0800 (PST)
MIME-Version: 1.0
References: <20211125060547.11961-1-jasowang@redhat.com> <20211125070939.GC211101@mtl-vdi-166.wap.labs.mlnx>
In-Reply-To: <20211125070939.GC211101@mtl-vdi-166.wap.labs.mlnx>
From:   Jason Wang <jasowang@redhat.com>
Date:   Thu, 25 Nov 2021 15:15:33 +0800
Message-ID: <CACGkMEsNsQ_XWTvdjaCEdo8sYaLew24zU1UUCJrokM-Koxj4fw@mail.gmail.com>
Subject: Re: [PATCH net] virtio-net: enable big mode correctly
To:     Eli Cohen <elic@nvidia.com>
Cc:     mst <mst@redhat.com>,
        virtualization <virtualization@lists.linux-foundation.org>,
        netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 25, 2021 at 3:09 PM Eli Cohen <elic@nvidia.com> wrote:
>
> On Thu, Nov 25, 2021 at 02:05:47PM +0800, Jason Wang wrote:
> > When VIRTIO_NET_F_MTU feature is not negotiated, we assume a very
> > large max_mtu. In this case, using small packet mode is not correct
> > since it may breaks the networking when MTU is grater than
> > ETH_DATA_LEN.
> >
> > To have a quick fix, simply enable the big packet mode when
> > VIRTIO_NET_F_MTU is not negotiated. We can do optimization on top.
> >
> > Reported-by: Eli Cohen <elic@nvidia.com>
> > Cc: Eli Cohen <elic@nvidia.com>
> > Signed-off-by: Jason Wang <jasowang@redhat.com>
> > ---
> >  drivers/net/virtio_net.c | 7 ++++---
> >  1 file changed, 4 insertions(+), 3 deletions(-)
> >
> > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > index 7c43bfc1ce44..83ae3ef5eb11 100644
> > --- a/drivers/net/virtio_net.c
> > +++ b/drivers/net/virtio_net.c
> > @@ -3200,11 +3200,12 @@ static int virtnet_probe(struct virtio_device *vdev)
> >               dev->mtu = mtu;
> >               dev->max_mtu = mtu;
> >
> > -             /* TODO: size buffers correctly in this case. */
> > -             if (dev->mtu > ETH_DATA_LEN)
> > -                     vi->big_packets = true;
> >       }
> >
> > +     /* TODO: size buffers correctly in this case. */
> > +     if (dev->max_mtu > ETH_DATA_LEN)
> > +             vi->big_packets = true;
> > +
>
> If VIRTIO_NET_F_MTU is provided, then dev->max_mtu is going to equal
> ETH_DATA_LEN (will be set in ether_setup()) so I don't think it will set
> big_packets to true.

I may miss something, the dev->max_mtu is just assigned to the mtu
value read from the config space in the code block above  (inside the
feature check of VIRTIO_NET_F_MTU).

Thanks

>
>
> >       if (vi->any_header_sg)
> >               dev->needed_headroom = vi->hdr_len;
> >
> > --
> > 2.25.1
> >
>

