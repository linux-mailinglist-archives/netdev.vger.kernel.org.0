Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20C3D4AE973
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 06:49:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230197AbiBIFpm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 00:45:42 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:60014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238690AbiBIFkX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 00:40:23 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5E3BCC02B757
        for <netdev@vger.kernel.org>; Tue,  8 Feb 2022 21:40:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644385189;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KdjkngOKMA7bg2oJfUtSkQw+6lC1kyEXHsbHAdltn3U=;
        b=Zrd4BeC3p7uCF7cRFnyXm0aZBpI7N+b8x+7xkcXa5eZXEtOUXeVlkCKRLV0qpHU6QbA5HC
        BoENYUI777fuUBdfWSkEA0UHAlgbB2gfYT0nNiHPaH8IGrYW9KIY+OdKYTzL9lg5wWBAhb
        PAz4qgZI6FUrT2ZuE4D6XKZkPR5+paY=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-524-xzCQ0vVNOGWMjLMjg19iXg-1; Wed, 09 Feb 2022 00:39:48 -0500
X-MC-Unique: xzCQ0vVNOGWMjLMjg19iXg-1
Received: by mail-lf1-f71.google.com with SMTP id o25-20020a05651205d900b0043e6c10892bso208478lfo.14
        for <netdev@vger.kernel.org>; Tue, 08 Feb 2022 21:39:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=KdjkngOKMA7bg2oJfUtSkQw+6lC1kyEXHsbHAdltn3U=;
        b=GJJEFrHbyenEX2PshaSdvyXe6XtTF1x0OFq1BPKQM+RUGj26JE7cBTmym6hNGTL6Bm
         DEKHQxpfAqB6MVXBiH0HfTbijkKkfKPh2fDdgADuJAtXpWRvUr6JjXGavihoa6+dtjFN
         nfxm9wEft/evTBgmKJuOOKkkZKj1XXONuFABuTeWM9Bl7JcYLfpzkYQ7tmxax3A8ebhy
         oB4myFuFo3Kg1JhlXfhopRZE7EALHIG6/6YuX1ll2PLxx14x/lsG//XN96atvyF9Nrnb
         BJnsT6bEPtEafxQ6jHynyI+oRGEV/ObBisiNKvbO9Nx5phMMXCS7MGkhaXbRfccPj8/O
         qLXQ==
X-Gm-Message-State: AOAM530nw4kMH8EN4v7jf/poXK3gOl6wFPaDh2rDOyi+Krn/jrpPBZs+
        OfUFSpn2M/MFAkqkgfdz6XYT3axWG4X+L/IwPlSDpUKdv9iOHAIz5yjAUBiNkpNsW4rZOz7HN14
        lh9DhxYy5YAr7RUvMcC53eaWU1QGYYtrl
X-Received: by 2002:a05:6512:3986:: with SMTP id j6mr507298lfu.84.1644385186764;
        Tue, 08 Feb 2022 21:39:46 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzZ9V3a+WzslPsO4MNBWqkV/COHINFv3Uj3aM34m0bEvE0naK1G1+iv8ZX11UDJsX92pxLP529TE7r9laOD8mw=
X-Received: by 2002:a05:6512:3986:: with SMTP id j6mr507283lfu.84.1644385186483;
 Tue, 08 Feb 2022 21:39:46 -0800 (PST)
MIME-Version: 1.0
References: <20220126073533.44994-1-xuanzhuo@linux.alibaba.com>
 <CACGkMEspyHTmcSaq9fgpU88VCZGzu21Khp9H+fqL-pb5GLdEpA@mail.gmail.com>
 <1644213739.5846965-1-xuanzhuo@linux.alibaba.com> <7d1e2d5b-a9a1-cbb7-4d80-89df1cb7bf15@redhat.com>
 <1644290085.868939-2-xuanzhuo@linux.alibaba.com> <1644306673.8360631-1-xuanzhuo@linux.alibaba.com>
In-Reply-To: <1644306673.8360631-1-xuanzhuo@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Wed, 9 Feb 2022 13:39:34 +0800
Message-ID: <CACGkMEsnupEVKukgdom85gUwbGoLcHT8bM9OqR_U11DzGdz1rw@mail.gmail.com>
Subject: Re: [PATCH v3 00/17] virtio pci support VIRTIO_F_RING_RESET
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     Jesper Dangaard Brouer <hawk@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>,
        Jakub Kicinski <kuba@kernel.org>, bpf@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 8, 2022 at 3:56 PM Xuan Zhuo <xuanzhuo@linux.alibaba.com> wrote=
:
>
> On Tue, 08 Feb 2022 11:14:45 +0800, Xuan Zhuo <xuanzhuo@linux.alibaba.com=
> wrote:
> > On Tue, 8 Feb 2022 10:59:48 +0800, Jason Wang <jasowang@redhat.com> wro=
te:
> > >
> > > =E5=9C=A8 2022/2/7 =E4=B8=8B=E5=8D=882:02, Xuan Zhuo =E5=86=99=E9=81=
=93:
> > > > On Mon, 7 Feb 2022 11:39:36 +0800, Jason Wang <jasowang@redhat.com>=
 wrote:
> > > >> On Wed, Jan 26, 2022 at 3:35 PM Xuan Zhuo <xuanzhuo@linux.alibaba.=
com> wrote:
> > > >>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > > >>> The virtio spec already supports the virtio queue reset function.=
 This patch set
> > > >>> is to add this function to the kernel. The relevant virtio spec i=
nformation is
> > > >>> here:
> > > >>>
> > > >>>      https://github.com/oasis-tcs/virtio-spec/issues/124
> > > >>>
> > > >>> Also regarding MMIO support for queue reset, I plan to support it=
 after this
> > > >>> patch is passed.
> > > >>>
> > > >>> #14-#17 is the disable/enable function of rx/tx pair implemented =
by virtio-net
> > > >>> using the new helper.
> > > >> One thing that came to mind is the steering. E.g if we disable an =
RX,
> > > >> should we stop steering packets to that queue?
>
> Regarding this spec, if there are multiple queues disabled at the same ti=
me, it
> will be a troublesome problem for the backend to select the queue,

I don't understand this, for such a kind of backend or device it can
simply claim not to support this feature.

> so I want to
> directly define that only one queue is allowed to reset at the same time,=
 do you
> think this is appropriate?

This sounds very complicated. E.g how can we define an API that can
reset more than one queues? (currently PCI only support MMIO access).

>
> In terms of the implementation of backend queue reselection, it would be =
more
> convenient to implement if we drop packets directly. Do you think we must
> implement this reselection function?

Rethink of this. It should be fine and much simpler.

Thanks

>
> Thanks.
>
> > > > Yes, we should reselect a queue.
> > > >
> > > > Thanks.
> > >
> > >
> > > Maybe a spec patch for that?
> >
> > Yes, I also realized this. Although virtio-net's disable/enable is impl=
emented
> > based on queue reset, virtio-net still has to define its own flag and d=
efine
> > some more detailed implementations.
> >
> > I'll think about it and post a spec patch.
> >
> > Thanks.
> >
> > >
> > > Thanks
> > >
> > >
> > > >
> > > >> Thanks
> > > >>
> > > >>> This function is not currently referenced by other
> > > >>> functions. It is more to show the usage of the new helper, I not =
sure if they
> > > >>> are going to be merged together.
> > > >>>
> > > >>> Please review. Thanks.
> > > >>>
> > > >>> v3:
> > > >>>    1. keep vq, irq unreleased
> > > >>>
> > > >>> Xuan Zhuo (17):
> > > >>>    virtio_pci: struct virtio_pci_common_cfg add queue_notify_data
> > > >>>    virtio: queue_reset: add VIRTIO_F_RING_RESET
> > > >>>    virtio: queue_reset: struct virtio_config_ops add callbacks fo=
r
> > > >>>      queue_reset
> > > >>>    virtio: queue_reset: add helper
> > > >>>    vritio_ring: queue_reset: extract the release function of the =
vq ring
> > > >>>    virtio_ring: queue_reset: split: add __vring_init_virtqueue()
> > > >>>    virtio_ring: queue_reset: split: support enable reset queue
> > > >>>    virtio_ring: queue_reset: packed: support enable reset queue
> > > >>>    virtio_ring: queue_reset: add vring_reset_virtqueue()
> > > >>>    virtio_pci: queue_reset: update struct virtio_pci_common_cfg a=
nd
> > > >>>      option functions
> > > >>>    virtio_pci: queue_reset: release vq by vp_dev->vqs
> > > >>>    virtio_pci: queue_reset: setup_vq use vring_setup_virtqueue()
> > > >>>    virtio_pci: queue_reset: support VIRTIO_F_RING_RESET
> > > >>>    virtio_net: virtnet_tx_timeout() fix style
> > > >>>    virtio_net: virtnet_tx_timeout() stop ref sq->vq
> > > >>>    virtio_net: split free_unused_bufs()
> > > >>>    virtio_net: support pair disable/enable
> > > >>>
> > > >>>   drivers/net/virtio_net.c               | 220 ++++++++++++++++++=
++++---
> > > >>>   drivers/virtio/virtio_pci_common.c     |  62 ++++---
> > > >>>   drivers/virtio/virtio_pci_common.h     |  11 +-
> > > >>>   drivers/virtio/virtio_pci_legacy.c     |   5 +-
> > > >>>   drivers/virtio/virtio_pci_modern.c     | 120 +++++++++++++-
> > > >>>   drivers/virtio/virtio_pci_modern_dev.c |  28 ++++
> > > >>>   drivers/virtio/virtio_ring.c           | 144 +++++++++++-----
> > > >>>   include/linux/virtio.h                 |   1 +
> > > >>>   include/linux/virtio_config.h          |  75 ++++++++-
> > > >>>   include/linux/virtio_pci_modern.h      |   2 +
> > > >>>   include/linux/virtio_ring.h            |  42 +++--
> > > >>>   include/uapi/linux/virtio_config.h     |   7 +-
> > > >>>   include/uapi/linux/virtio_pci.h        |   2 +
> > > >>>   13 files changed, 618 insertions(+), 101 deletions(-)
> > > >>>
> > > >>> --
> > > >>> 2.31.0
> > > >>>
> > >
> > _______________________________________________
> > Virtualization mailing list
> > Virtualization@lists.linux-foundation.org
> > https://lists.linuxfoundation.org/mailman/listinfo/virtualization
>

