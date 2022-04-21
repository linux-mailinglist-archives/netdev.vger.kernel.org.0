Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 822EA50A1ED
	for <lists+netdev@lfdr.de>; Thu, 21 Apr 2022 16:16:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387806AbiDUOSt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Apr 2022 10:18:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1389075AbiDUOSr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Apr 2022 10:18:47 -0400
Received: from mail-qk1-x734.google.com (mail-qk1-x734.google.com [IPv6:2607:f8b0:4864:20::734])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3514D2180B
        for <netdev@vger.kernel.org>; Thu, 21 Apr 2022 07:15:57 -0700 (PDT)
Received: by mail-qk1-x734.google.com with SMTP id j9so3629762qkg.1
        for <netdev@vger.kernel.org>; Thu, 21 Apr 2022 07:15:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sgRgJQIriKo+0gldCYXcf1J9czouFNPq/lzf0Sf3+Go=;
        b=GkRi3mklj8SbZaBA+Pk73wqiwBIMA0328RZifBNc1s6tbEqsEzxmbM3O929vxzl7pO
         yup1LjVjvGvGPMsBlm7DRidlmyTp7smf4rulaATMIReQncfDofyFL6E8rorYBjAgiKgZ
         QXyz2nz736aMN5BCzw5ip2EQiMcoZIlkoE7RgHpbQELz2jBEKmcYEjFuRe1B5TKb5ENJ
         +BABjcGltgOjImVJ89DT9NghIWFV7x+vX7ZPhjlvJ7ndU7SQepmftq/S2wYCV1ay6Khy
         45OVKxPVHGpuqG3p0hQz0pQrrQhwkfYyrw+GtHKDA4owuyNarTjFiaq63hxaoY4FhNNY
         LIuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sgRgJQIriKo+0gldCYXcf1J9czouFNPq/lzf0Sf3+Go=;
        b=FmdANBaNGzUwvJiojTj47mewr0mucJZ3f6IvTZFxryA67F5BL2XykOJpFLCVo20R4b
         Z5+OMNKVGKdHTrHk95uflPUPCPVYUcY3ol4wxhh4PlvrjrFTawSZsWfbOBYuyWItRON0
         hQCnlxkSJmBPhUWBVjkza0a9g6UDaTt8+zux4elIKMEpbN1UHNRSaqmQGB9H4OVaHExV
         sc/n01KHTC2dXXt9FmX6MFxZYwFv42pHjfO9GvY+3KiIRPk6YIYcRAU2UNYX/uWcVrFc
         vKm/2rYG5/gcP3KetuF8h2oyg7zl/AZE0eqiSAieX7LdQQqCBsr2VtTw+/HbI3SwT/iO
         /46w==
X-Gm-Message-State: AOAM531bxOaH+sQJUuj6STBWYp3O6Mn8ALTmXibmKCW5C7A1Ett2npkT
        xPVeIkdgKKik8pejwCf8LdmgShHhX0M=
X-Google-Smtp-Source: ABdhPJynUDUj98VrOxGWNNKZpx455anA+Gak29GFseIFOso86WE3XXTnLnMzMs4e8kkA8uRtcJWvsw==
X-Received: by 2002:a05:620a:d50:b0:67e:e2b:a552 with SMTP id o16-20020a05620a0d5000b0067e0e2ba552mr15092674qkl.401.1650550556286;
        Thu, 21 Apr 2022 07:15:56 -0700 (PDT)
Received: from mail-yw1-f175.google.com (mail-yw1-f175.google.com. [209.85.128.175])
        by smtp.gmail.com with ESMTPSA id m63-20020a37a342000000b0069eb2145b00sm2932531qke.58.2022.04.21.07.15.55
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Apr 2022 07:15:55 -0700 (PDT)
Received: by mail-yw1-f175.google.com with SMTP id 00721157ae682-2edbd522c21so53229777b3.13
        for <netdev@vger.kernel.org>; Thu, 21 Apr 2022 07:15:55 -0700 (PDT)
X-Received: by 2002:a81:3902:0:b0:2eb:f9f0:4b0c with SMTP id
 g2-20020a813902000000b002ebf9f04b0cmr25723280ywa.419.1650550554896; Thu, 21
 Apr 2022 07:15:54 -0700 (PDT)
MIME-Version: 1.0
References: <20220420082758.581245-1-liuhangbin@gmail.com> <CA+FuTScyF4BKEcNSCYOv8SBA_EmB806YtKA17jb3F+fymVF-Pg@mail.gmail.com>
 <YmDCHI330AUfcYKa@Laptop-X1>
In-Reply-To: <YmDCHI330AUfcYKa@Laptop-X1>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Thu, 21 Apr 2022 10:15:16 -0400
X-Gmail-Original-Message-ID: <CA+FuTSckEJVUH1Q2vBxGbfPgVteyDVmTfjJC6hBj=qRP+JcAxA@mail.gmail.com>
Message-ID: <CA+FuTSckEJVUH1Q2vBxGbfPgVteyDVmTfjJC6hBj=qRP+JcAxA@mail.gmail.com>
Subject: Re: [PATCH net-next] net/af_packet: add VLAN support for AF_PACKET
 SOCK_RAW GSO
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        netdev@vger.kernel.org, "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        virtualization@lists.linux-foundation.org,
        Balazs Nemeth <bnemeth@redhat.com>,
        Mike Pattrick <mpattric@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 20, 2022 at 10:32 PM Hangbin Liu <liuhangbin@gmail.com> wrote:
>
> On Wed, Apr 20, 2022 at 09:45:15AM -0400, Willem de Bruijn wrote:
> > On Wed, Apr 20, 2022 at 4:28 AM Hangbin Liu <liuhangbin@gmail.com> wrote:
> > >
> > > Currently, the kernel drops GSO VLAN tagged packet if it's created with
> > > socket(AF_PACKET, SOCK_RAW, 0) plus virtio_net_hdr.
> > >
> > > The reason is AF_PACKET doesn't adjust the skb network header if there is
> > > a VLAN tag. Then after virtio_net_hdr_set_proto() called, the skb->protocol
> > > will be set to ETH_P_IP/IPv6. And in later inet/ipv6_gso_segment() the skb
> > > is dropped as network header position is invalid.
> > >
> > > Let's handle VLAN packets by adjusting network header position in
> > > packet_parse_headers(), and move the function in packet_snd() before
> > > calling virtio_net_hdr_set_proto().
> >
> > The network header is set in
> >
> >         skb_reset_network_header(skb);
> >
> >         err = -EINVAL;
> >         if (sock->type == SOCK_DGRAM) {
> >                 offset = dev_hard_header(skb, dev, ntohs(proto), addr,
> > NULL, len);
> >                 if (unlikely(offset < 0))
> >                         goto out_free;
> >         } else if (reserve) {
> >                 skb_reserve(skb, -reserve);
> >                 if (len < reserve + sizeof(struct ipv6hdr) &&
> >                     dev->min_header_len != dev->hard_header_len)
> >                         skb_reset_network_header(skb);
> >         }
> >
> > If all that is needed is to move the network header beyond an optional
> > VLAN tag in the case of SOCK_RAW, then this can be done in the else
> > for Ethernet packets.
>
> Before we set network position, we need to check the skb->protocol to make
> sure it's a VLAN packet.
>
> If we set skb->protocol and adjust network header here, like
> packet_parse_headers() does. How should we do with later
>
>         skb->protocol = proto;
>         skb->dev = dev;
>
> settings?
>
> If you are afraid that skb_probe_transport_header(skb) would affect the
> virtio_net_hdr operation. How about split the skb_probe_transport_header()
> from packet_parse_headers()? Something like
>
> --- a/net/packet/af_packet.c
> +++ b/net/packet/af_packet.c
> @@ -1924,13 +1924,19 @@ static int packet_rcv_spkt(struct sk_buff *skb, struct net_device *dev,
>
>  static void packet_parse_headers(struct sk_buff *skb, struct socket *sock)
>  {
> +       int depth;
> +
>         if ((!skb->protocol || skb->protocol == htons(ETH_P_ALL)) &&
>             sock->type == SOCK_RAW) {
>                 skb_reset_mac_header(skb);
>                 skb->protocol = dev_parse_header_protocol(skb);
>         }
>
> -       skb_probe_transport_header(skb);
> +       /* Move network header to the right position for VLAN tagged packets */
> +       if (likely(skb->dev->type == ARPHRD_ETHER) &&
> +           eth_type_vlan(skb->protocol) &&
> +           __vlan_get_protocol(skb, skb->protocol, &depth) != 0)
> +               skb_set_network_header(skb, depth);
>  }
>
>  /*
> @@ -3047,6 +3055,8 @@ static int packet_snd(struct socket *sock, struct msghdr *msg, size_t len)
>         skb->mark = sockc.mark;
>         skb->tstamp = sockc.transmit_time;
>
> +       packet_parse_headers(skb, sock);
> +
>         if (has_vnet_hdr) {
>                 err = virtio_net_hdr_to_skb(skb, &vnet_hdr, vio_le());
>                 if (err)
> @@ -3055,7 +3065,7 @@ static int packet_snd(struct socket *sock, struct msghdr *msg, size_t len)
>                 virtio_net_hdr_set_proto(skb, &vnet_hdr);
>         }
>
> -       packet_parse_headers(skb, sock);
> +       skb_probe_transport_header(skb);
>
>         if (unlikely(extra_len == 4))
>                 skb->no_fcs = 1;
>
>
> >
> > It is not safe to increase reserve, as that would eat into the
> > reserved hlen LL_RESERVED_SPACE(dev), which does not account for
> > optional VLAN headers.
> >
> > Instead of setting here first, then patching up again later in
> > packet_parse_headers.
> >
> > This change affects all packets with VLAN headers, not just those with
> > GSO. I imagine that moving the network header is safe for all, but
> > don't know that code well enough to verify that it does not have
> > unintended side effects. Does dev_queue_xmit expect the network header
> > to point to the start of the VLAN headers or after, for instance?
>
> I think adjust the network position should be safe, as tap device also did that.

Oh, it's great to be able to point to such prior art. Can you mention
that in the commit message?

Your approach does sound simpler than the above. Thanks for looking
into that alternative, though.

>
> Thanks
> Hangbin
