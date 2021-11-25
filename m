Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE6ED45D584
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 08:33:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234613AbhKYHg0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Nov 2021 02:36:26 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:47285 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235395AbhKYHe0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Nov 2021 02:34:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637825474;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Y5eJI0pmeXq/S80YZOfzijUCY3OPnAMCMR2eYYY351o=;
        b=elA0UzDo3ONd257kGBCI565NMMqxv5J2n4N9ZSBR065QKDeOi3CHwgoiwL85e5uVhMbgmd
        btLKIPzA8N1hmoS7lmeWszCHY5Sw0WAsH0Chaxwb91div5RvGAK1FgqNby8EcoxpyXHqeN
        iyd6TVCzcQVBKv8OPq3UljOouYEB764=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-72-ha8Wj1HyMsa2ltuo07M5fA-1; Thu, 25 Nov 2021 02:31:13 -0500
X-MC-Unique: ha8Wj1HyMsa2ltuo07M5fA-1
Received: by mail-ed1-f72.google.com with SMTP id t9-20020aa7d709000000b003e83403a5cbso4665566edq.19
        for <netdev@vger.kernel.org>; Wed, 24 Nov 2021 23:31:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Y5eJI0pmeXq/S80YZOfzijUCY3OPnAMCMR2eYYY351o=;
        b=gW72Ta/PizqFVp2ORftUYhoRs5YE8d8FWYQTCdMkkjdRtqDB/Bc+7hDp9KV4unViwa
         D5h1R8xkaQQ2Jwi4Lyhzz/SxubDfEYAWIonzLQWCgOgZa+AB2h2hhxThK9SkEJQ0tLXX
         xH5jv1fOl5u3v8ZhSPpKSYC+/83Zn48oI3ljppS+VMALe9juGdxs0N1/tj+L9ES4bX0z
         FIfdNoN3eLy2oFDdASX3nkzDINKxWFxTvSOHc0ckUkTOq1y/fA99OYPltSIDSdakhQU2
         +2PTbujd6G65fnlLWp+GLqvr2objrNEtBd3OdiKD6X2NXc+Er95sC/nQRHY6IcPOlOG9
         T71w==
X-Gm-Message-State: AOAM533mWV+W68DGs1JwlriRhfXYcrpeVFwwKas0XSDJBAdEXBl7Bs+T
        k89EnToYsA/y51m+6aa/5tFH20vDPk/JjhKmbx/Tj9Lxi65mXXbASG+FZhuJrPhwDxVM0KlIj9j
        HvuwzL3hgpKT0L3YZ
X-Received: by 2002:a05:6402:1768:: with SMTP id da8mr25711403edb.252.1637825472115;
        Wed, 24 Nov 2021 23:31:12 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyFdLw5OpKsVjX5SKIvWd83t+uIMlDFgJtQwFJcoac+GAXQ+szrPYXWa/3fjvXjeKAZDLCgeA==
X-Received: by 2002:a05:6402:1768:: with SMTP id da8mr25711383edb.252.1637825471883;
        Wed, 24 Nov 2021 23:31:11 -0800 (PST)
Received: from redhat.com ([45.15.18.67])
        by smtp.gmail.com with ESMTPSA id n16sm1263656edt.67.2021.11.24.23.31.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Nov 2021 23:31:11 -0800 (PST)
Date:   Thu, 25 Nov 2021 02:31:05 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     Eli Cohen <elic@nvidia.com>,
        virtualization <virtualization@lists.linux-foundation.org>,
        netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net] virtio-net: enable big mode correctly
Message-ID: <20211125022736-mutt-send-email-mst@kernel.org>
References: <20211125060547.11961-1-jasowang@redhat.com>
 <20211125070939.GC211101@mtl-vdi-166.wap.labs.mlnx>
 <CACGkMEsNsQ_XWTvdjaCEdo8sYaLew24zU1UUCJrokM-Koxj4fw@mail.gmail.com>
 <20211125072040.GA213301@mtl-vdi-166.wap.labs.mlnx>
 <CACGkMEuYWoL4x5o_OO2a27X4Ah8Y2ggBjy0XFHe3Onmj4RhFFg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACGkMEuYWoL4x5o_OO2a27X4Ah8Y2ggBjy0XFHe3Onmj4RhFFg@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 25, 2021 at 03:26:22PM +0800, Jason Wang wrote:
> On Thu, Nov 25, 2021 at 3:20 PM Eli Cohen <elic@nvidia.com> wrote:
> >
> > On Thu, Nov 25, 2021 at 03:15:33PM +0800, Jason Wang wrote:
> > > On Thu, Nov 25, 2021 at 3:09 PM Eli Cohen <elic@nvidia.com> wrote:
> > > >
> > > > On Thu, Nov 25, 2021 at 02:05:47PM +0800, Jason Wang wrote:
> > > > > When VIRTIO_NET_F_MTU feature is not negotiated, we assume a very
> > > > > large max_mtu. In this case, using small packet mode is not correct
> > > > > since it may breaks the networking when MTU is grater than
> > > > > ETH_DATA_LEN.
> > > > >
> > > > > To have a quick fix, simply enable the big packet mode when
> > > > > VIRTIO_NET_F_MTU is not negotiated. We can do optimization on top.
> > > > >
> > > > > Reported-by: Eli Cohen <elic@nvidia.com>
> > > > > Cc: Eli Cohen <elic@nvidia.com>
> > > > > Signed-off-by: Jason Wang <jasowang@redhat.com>
> > > > > ---
> > > > >  drivers/net/virtio_net.c | 7 ++++---
> > > > >  1 file changed, 4 insertions(+), 3 deletions(-)
> > > > >
> > > > > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > > > > index 7c43bfc1ce44..83ae3ef5eb11 100644
> > > > > --- a/drivers/net/virtio_net.c
> > > > > +++ b/drivers/net/virtio_net.c
> > > > > @@ -3200,11 +3200,12 @@ static int virtnet_probe(struct virtio_device *vdev)
> > > > >               dev->mtu = mtu;
> > > > >               dev->max_mtu = mtu;
> > > > >
> > > > > -             /* TODO: size buffers correctly in this case. */
> > > > > -             if (dev->mtu > ETH_DATA_LEN)
> > > > > -                     vi->big_packets = true;
> > > > >       }
> > > > >
> > > > > +     /* TODO: size buffers correctly in this case. */
> > > > > +     if (dev->max_mtu > ETH_DATA_LEN)
> > > > > +             vi->big_packets = true;
> > > > > +
> > > >
> > > > If VIRTIO_NET_F_MTU is provided, then dev->max_mtu is going to equal
> > > > ETH_DATA_LEN (will be set in ether_setup()) so I don't think it will set
> > > > big_packets to true.
> > >
> > > I may miss something, the dev->max_mtu is just assigned to the mtu
> > > value read from the config space in the code block above  (inside the
> > > feature check of VIRTIO_NET_F_MTU).
> >
> > Sorry, I meant "If VIRTIO_NET_F_MTU is ***NOT*** provided". In that case
> > dev->max_mtu eauals ETH_DATA_LEN so you won't set vi->big_packets to
> > true.
> 
> I see but in this case, the above assignment:
> 
>         /* MTU range: 68 - 65535 */
>         dev->min_mtu = MIN_MTU;
>         dev->max_mtu = MAX_MTU;
> 
> happens after alloc_etherdev_mq() which calls ether_setup(), so we are
> probably fine here.
> 
> Thanks

Actually the issue with VIRTIO_NET_F_MTU is that devices might be
tempted to expose 9k here simply because they support jumbo frames,
if they also don't support mergeable buffers this will force big
packet mode.


> >
> > >
> > > Thanks
> > >
> > > >
> > > >
> > > > >       if (vi->any_header_sg)
> > > > >               dev->needed_headroom = vi->hdr_len;
> > > > >
> > > > > --
> > > > > 2.25.1
> > > > >
> > > >
> > >
> >

