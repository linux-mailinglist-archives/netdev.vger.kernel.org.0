Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D42637C037
	for <lists+netdev@lfdr.de>; Wed, 12 May 2021 16:33:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230396AbhELOe3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 May 2021 10:34:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230202AbhELOe2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 May 2021 10:34:28 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AF13C061574
        for <netdev@vger.kernel.org>; Wed, 12 May 2021 07:33:20 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id b17so27357751ede.0
        for <netdev@vger.kernel.org>; Wed, 12 May 2021 07:33:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=v8nnd2ujlB60GPiA1lPsUn5BttskeOt6aee1p1TS5NI=;
        b=Wpp5b+dJz7p84pYFu61NJPWS4c2Iy94l38MMIIrcvuSyboDZb8mrAauO3NExSxNvxO
         gxIiCahmDKdGGZLEachs9sYewc/p5Ffh5QD8PfCExLjZ9o4ms/CuLM7muZKbmq6kgAmz
         DoReFAC9jIdpFjCoLD9tthT3L7CPfVDbJoDVUq2838G0Gl0SWXxLGu/Q7nMpaNyPR1dX
         1WWj5jqBeK0ZE76jprusRBgJ7gBIiGpZR8ajL4z4CQwT65uNBW2DDzDoEBCWOkLiTKpl
         uGDnqh2B7/aQwFYH5XPtPD83rkFQSovCQU+TH3bz/2A1RT2m5FZvOUqeeKwShBXTC5kg
         wGgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=v8nnd2ujlB60GPiA1lPsUn5BttskeOt6aee1p1TS5NI=;
        b=tXBHaO6aLsAs6OneOzQqMKSxP+svEwbq+XnJKU7JnQkeY72X2vEaIljhfRPnJWe7nx
         0cM/2WHh4zW8GooOBjT1s9PBy+wqrFYOt/djnPMI2+0mycEUm9dQ2pnyaQS5zEdShw1M
         gsJ9+dgHaz/fMu+Zg045Aw0IV281e0eMQn67hcbLFAg/7frdf01SJUDF+guV+fEUHHi1
         Js/LLpq/QIKeq1oBjc+m3GJL+VvVoCQvx619uUpl67EdOHUOObc7s+tDxI6MIFf+XXfG
         jke0JqTAtGJVoGflZ9DbBlvevGXgK6j2nobuu+nSAGKnMUV3V9KCvjRrP3aBv3kq6W69
         rhpQ==
X-Gm-Message-State: AOAM5321MaqjzvE2OVqqyBbcKERS7la+WCrEA09JrkqoQzeQADEXQCew
        6+f4HRKZ6BR4JAwSvEPD0A3au/+V74o7ew==
X-Google-Smtp-Source: ABdhPJzh2gPBdo0r7rfambmiu1H03C9QapAuIboKLq8kSXDryzYgDGyk8g9fQzOYQOHDGCE1rdDuEA==
X-Received: by 2002:a05:6402:1109:: with SMTP id u9mr45018428edv.174.1620829998464;
        Wed, 12 May 2021 07:33:18 -0700 (PDT)
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com. [209.85.221.46])
        by smtp.gmail.com with ESMTPSA id b9sm17413307edt.2.2021.05.12.07.33.17
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 May 2021 07:33:17 -0700 (PDT)
Received: by mail-wr1-f46.google.com with SMTP id x5so23854664wrv.13
        for <netdev@vger.kernel.org>; Wed, 12 May 2021 07:33:17 -0700 (PDT)
X-Received: by 2002:a05:6000:1787:: with SMTP id e7mr45453515wrg.12.1620829996861;
 Wed, 12 May 2021 07:33:16 -0700 (PDT)
MIME-Version: 1.0
References: <20210511044253.469034-1-yuri.benditovich@daynix.com>
 <20210511044253.469034-3-yuri.benditovich@daynix.com> <CA+FuTSdfA6sT68AJNpa=VPBdwRFHvEY+=C-B_mS=y=WMpTyc=Q@mail.gmail.com>
 <CAOEp5OcV-YmPFoewuCHg=ADFQ4BmVL5ioMgh3qVjUGk9mauejg@mail.gmail.com>
In-Reply-To: <CAOEp5OcV-YmPFoewuCHg=ADFQ4BmVL5ioMgh3qVjUGk9mauejg@mail.gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 12 May 2021 10:32:39 -0400
X-Gmail-Original-Message-ID: <CA+FuTSes20+KKhnNFHyOa_E0dp-RgUNFRj-YLHvjpqqL75zDXQ@mail.gmail.com>
Message-ID: <CA+FuTSes20+KKhnNFHyOa_E0dp-RgUNFRj-YLHvjpqqL75zDXQ@mail.gmail.com>
Subject: Re: [PATCH 2/4] virtio-net: add support of UDP segmentation (USO) on
 the host
To:     Yuri Benditovich <yuri.benditovich@daynix.com>
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

On Wed, May 12, 2021 at 2:10 AM Yuri Benditovich
<yuri.benditovich@daynix.com> wrote:
>
> On Tue, May 11, 2021 at 8:48 PM Willem de Bruijn
> <willemdebruijn.kernel@gmail.com> wrote:
> >
> > On Tue, May 11, 2021 at 12:43 AM Yuri Benditovich
> > <yuri.benditovich@daynix.com> wrote:
> > >
> > > Large UDP packet provided by the guest with GSO type set to
> > > VIRTIO_NET_HDR_GSO_UDP_L4 will be divided to several UDP
> > > packets according to the gso_size field.
> > >
> > > Signed-off-by: Yuri Benditovich <yuri.benditovich@daynix.com>
> > > ---
> > >  include/linux/virtio_net.h | 5 +++++
> > >  1 file changed, 5 insertions(+)
> > >
> > > diff --git a/include/linux/virtio_net.h b/include/linux/virtio_net.h
> > > index b465f8f3e554..4ecf9a1ca912 100644
> > > --- a/include/linux/virtio_net.h
> > > +++ b/include/linux/virtio_net.h
> > > @@ -51,6 +51,11 @@ static inline int virtio_net_hdr_to_skb(struct sk_buff *skb,
> > >                         ip_proto = IPPROTO_UDP;
> > >                         thlen = sizeof(struct udphdr);
> > >                         break;
> > > +               case VIRTIO_NET_HDR_GSO_UDP_L4:
> > > +                       gso_type = SKB_GSO_UDP_L4;
> > > +                       ip_proto = IPPROTO_UDP;
> > > +                       thlen = sizeof(struct udphdr);
> > > +                       break;
> >
> > If adding a new VIRTIO_NET_HDR type I suggest adding separate IPv4 and
> > IPv6 variants, analogous to VIRTIO_NET_HDR_GSO_TCPV[46]. To avoid
> > having to infer protocol again, as for UDP fragmentation offload (the
> > retry case below this code).
>
> Thank you for denoting this important point of distinguishing between v4 and v6.
> Let's try to take a deeper look to see what is the correct thing to do
> and please correct me if I'm wrong:
> 1. For USO we do not need to guess the protocol as it is used with
> VIRTIO_NET_HDR_F_NEEDS_CSUM (unlike UFO)

Enforcing that is a good start. We should also enforce that
skb->protocol is initialized to one of htons(ETH_P_IP) or
htons(ETH_P_IPV6), so that it does not have to be inferred by parsing.

These requirements were not enforced for previous values, and cannot
be introduced afterwards, which has led to have to add that extra code
to handle these obscure edge cases.

I agree that with well behaved configurations, the need for separate
_V4 and _V6 variants is not needed.

> and the USO packets
> transmitted by the guest are under the same clause as both
> VIRTIO_NET_HDR_GSO_TCP, i.e. under if (hdr->flags &
> VIRTIO_NET_HDR_F_NEEDS_CSUM) {
> 2. If we even define VIRTIO_NET_HDR_GSO_UDPv4_L4 and
> VIRTIO_NET_HDR_GSO_UDPv6_L4 - both will be translated to
> SKB_GSO_UDP_L4, so this information is immediately lost (the code will
> look like:
> case VIRTIO_NET_HDR_GSO_UDP4_L4: case VIRTIO_NET_HDR_GSO_UDP6_L4
>     gso_type = SKB_GSO_UDP;
>
> 3. When we will define the respective guest features (like
> VIRTIO_NET_F_HOST_USO4 VIRTIO_NET_F_HOST_USO6) we will need to
> recreate the virtio_net header from the skb when both v4 and v6 have
> the same SKB_GSO_UDP_L4, (see virtio_net_hdr_from_skb) and I'm not
> sure whether somebody needs the exact v4 or v6 information on guest RX
> path.

FWIW, it is good to keep in mind that virtio_net_hdr is also used
outside virtio, in both ingress and egress paths.

> 4. What is completely correct is that when we will start working with
> the guest RX path we will need to define something like NETIF_F_USO4
> and NETIF_F_USO6 and configure them according to exact guest offload
> capabilities.
> Do you agree?

I don't immediately see the need for advertising this device feature
on a per-protocol basis. Can you elaborate?
