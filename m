Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5549037ED0F
	for <lists+netdev@lfdr.de>; Thu, 13 May 2021 00:37:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385096AbhELUGc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 May 2021 16:06:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352250AbhELTAx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 May 2021 15:00:53 -0400
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FE12C06138A
        for <netdev@vger.kernel.org>; Wed, 12 May 2021 11:56:58 -0700 (PDT)
Received: by mail-ot1-x32a.google.com with SMTP id t10-20020a05683022eab0290304ed8bc759so349445otc.12
        for <netdev@vger.kernel.org>; Wed, 12 May 2021 11:56:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mpQjVx+/QfqR0pn4o8Ju928QdaYbFB0kBBz4UV+mn+0=;
        b=SO9+8FKxgXRbGu3ebKZVHcMv2fHMN11i9e2GIHiUUEWuipjAgmqzD0xjct7DE0mWko
         UiElZx9az7Cf9zBMIYrjXkI26jKpsqe+muetUiU9TT4ubLiJ7Ux2XKpdTlN+v8M/IGMj
         REQo3H1HQaxfYmHZYriH/Csa5rloabyfBbvMXQlorWjEd6fuCPMq0MtzBgM9VaHjYCk4
         eRy0HntmJkNnOaq9EhaNJc8QIDYR8GfumoBQ46ASk7vsI4lOqiiA2jVmcl7oMyj0iDGh
         VR8VGIQmPldE6YuSyLDLIzOQKUmrW7Aa3YwKXsZQvH5cvoW2pQRnVFGl+Q/dpOQ+xXk1
         UKqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mpQjVx+/QfqR0pn4o8Ju928QdaYbFB0kBBz4UV+mn+0=;
        b=IMfR4R9qX+XsbYVUjs0LFSFTBIBZU+fc0wE4bvxh5j6aktMWSsc4LF3YuUmhnX5lHO
         DhFYbOJOG4vgkJtPpK+QaxkOqlo+H+HrtqpI0r4FPPmRilo7CI+hpl5WXUyTapj/Be0b
         dci/GF+coPGWBkbVtO3BLX+86UJ9MXz5fz91nmZ9rqA7/h1NZJvpjuQV4EN0TM7K6KdX
         5gcKNMDszrU/oDc0hLPSajw7KYqa0+Rl7kyljnJUqioOO/3NP/N5Gi8QbDIZ3tz5i3h9
         7/XDfmYBmxcE4fC+i3x/OXZku8qhENqnnkgno4U1suviOWZlbnH1jIDzNKsf+MpQzrtj
         GLnw==
X-Gm-Message-State: AOAM531elZTE4J40xlhClfhTRHmbrLT15u+k1AI54je2EPy999kr84dz
        sBUF4XRPQMAclog9pEo+coo5Jd1qPub9kTvFPeAfOA==
X-Google-Smtp-Source: ABdhPJwoj7rGQhAWz07iMzr5AvnqbEBRfn+tnercciMQG8rZChJyhzYEf595qy8/+DcEpmjtdLdZvMOxhvdTwTmumG4=
X-Received: by 2002:a9d:8ce:: with SMTP id 72mr33114920otf.220.1620845817949;
 Wed, 12 May 2021 11:56:57 -0700 (PDT)
MIME-Version: 1.0
References: <20210511044253.469034-1-yuri.benditovich@daynix.com>
 <20210511044253.469034-3-yuri.benditovich@daynix.com> <CA+FuTSdfA6sT68AJNpa=VPBdwRFHvEY+=C-B_mS=y=WMpTyc=Q@mail.gmail.com>
 <CAOEp5OcV-YmPFoewuCHg=ADFQ4BmVL5ioMgh3qVjUGk9mauejg@mail.gmail.com> <CA+FuTSes20+KKhnNFHyOa_E0dp-RgUNFRj-YLHvjpqqL75zDXQ@mail.gmail.com>
In-Reply-To: <CA+FuTSes20+KKhnNFHyOa_E0dp-RgUNFRj-YLHvjpqqL75zDXQ@mail.gmail.com>
From:   Yuri Benditovich <yuri.benditovich@daynix.com>
Date:   Wed, 12 May 2021 21:56:46 +0300
Message-ID: <CAOEp5OcYL8E__wpHgbFkkJJ98FG_zjhKMBLnCJym8CjkHby3eA@mail.gmail.com>
Subject: Re: [PATCH 2/4] virtio-net: add support of UDP segmentation (USO) on
 the host
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>,
        Yan Vugenfirer <yan@daynix.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 12, 2021 at 5:33 PM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
>
> On Wed, May 12, 2021 at 2:10 AM Yuri Benditovich
> <yuri.benditovich@daynix.com> wrote:
> >
> > On Tue, May 11, 2021 at 8:48 PM Willem de Bruijn
> > <willemdebruijn.kernel@gmail.com> wrote:
> > >
> > > On Tue, May 11, 2021 at 12:43 AM Yuri Benditovich
> > > <yuri.benditovich@daynix.com> wrote:
> > > >
> > > > Large UDP packet provided by the guest with GSO type set to
> > > > VIRTIO_NET_HDR_GSO_UDP_L4 will be divided to several UDP
> > > > packets according to the gso_size field.
> > > >
> > > > Signed-off-by: Yuri Benditovich <yuri.benditovich@daynix.com>
> > > > ---
> > > >  include/linux/virtio_net.h | 5 +++++
> > > >  1 file changed, 5 insertions(+)
> > > >
> > > > diff --git a/include/linux/virtio_net.h b/include/linux/virtio_net.h
> > > > index b465f8f3e554..4ecf9a1ca912 100644
> > > > --- a/include/linux/virtio_net.h
> > > > +++ b/include/linux/virtio_net.h
> > > > @@ -51,6 +51,11 @@ static inline int virtio_net_hdr_to_skb(struct sk_buff *skb,
> > > >                         ip_proto = IPPROTO_UDP;
> > > >                         thlen = sizeof(struct udphdr);
> > > >                         break;
> > > > +               case VIRTIO_NET_HDR_GSO_UDP_L4:
> > > > +                       gso_type = SKB_GSO_UDP_L4;
> > > > +                       ip_proto = IPPROTO_UDP;
> > > > +                       thlen = sizeof(struct udphdr);
> > > > +                       break;
> > >
> > > If adding a new VIRTIO_NET_HDR type I suggest adding separate IPv4 and
> > > IPv6 variants, analogous to VIRTIO_NET_HDR_GSO_TCPV[46]. To avoid
> > > having to infer protocol again, as for UDP fragmentation offload (the
> > > retry case below this code).
> >
> > Thank you for denoting this important point of distinguishing between v4 and v6.
> > Let's try to take a deeper look to see what is the correct thing to do
> > and please correct me if I'm wrong:
> > 1. For USO we do not need to guess the protocol as it is used with
> > VIRTIO_NET_HDR_F_NEEDS_CSUM (unlike UFO)
>
> Enforcing that is a good start. We should also enforce that
> skb->protocol is initialized to one of htons(ETH_P_IP) or
> htons(ETH_P_IPV6), so that it does not have to be inferred by parsing.

As this feature is new and is not used in any public release of any
misbehaving driver, probably it is enough to state in the spec that
VIRTIO_NET_HDR_F_NEEDS_CSUM is required for USO packets.
The spec states that the USO feature requires checksumming feature.

>
> These requirements were not enforced for previous values, and cannot
> be introduced afterwards, which has led to have to add that extra code
> to handle these obscure edge cases.
>
> I agree that with well behaved configurations, the need for separate
> _V4 and _V6 variants is not needed.
>
> > and the USO packets
> > transmitted by the guest are under the same clause as both
> > VIRTIO_NET_HDR_GSO_TCP, i.e. under if (hdr->flags &
> > VIRTIO_NET_HDR_F_NEEDS_CSUM) {
> > 2. If we even define VIRTIO_NET_HDR_GSO_UDPv4_L4 and
> > VIRTIO_NET_HDR_GSO_UDPv6_L4 - both will be translated to
> > SKB_GSO_UDP_L4, so this information is immediately lost (the code will
> > look like:
> > case VIRTIO_NET_HDR_GSO_UDP4_L4: case VIRTIO_NET_HDR_GSO_UDP6_L4
> >     gso_type = SKB_GSO_UDP;
> >
> > 3. When we will define the respective guest features (like
> > VIRTIO_NET_F_HOST_USO4 VIRTIO_NET_F_HOST_USO6) we will need to
This is my typo: VIRTIO_NET_F_GUEST_USO4...
> > recreate the virtio_net header from the skb when both v4 and v6 have
> > the same SKB_GSO_UDP_L4, (see virtio_net_hdr_from_skb) and I'm not
> > sure whether somebody needs the exact v4 or v6 information on guest RX
> > path.
>
> FWIW, it is good to keep in mind that virtio_net_hdr is also used
> outside virtio, in both ingress and egress paths.

Can you please elaborate in which scenarios we do not have any virtio
device in path but need virtio_net_hdr?

>
> > 4. What is completely correct is that when we will start working with
> > the guest RX path we will need to define something like NETIF_F_USO4
> > and NETIF_F_USO6 and configure them according to exact guest offload
> > capabilities.
> > Do you agree?
>
> I don't immediately see the need for advertising this device feature
> on a per-protocol basis. Can you elaborate?

Separate offload setting (controlled by the guest) for v4 and v6 in
guest RX path is mandatory, at least Windows always requires this for
any offload.
In this case it seems easy to have also virtio-net device features to
be indicated separately (the TAP/TUN should report its capabilities).
