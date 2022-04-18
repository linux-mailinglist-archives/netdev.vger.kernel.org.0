Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D32D505BF8
	for <lists+netdev@lfdr.de>; Mon, 18 Apr 2022 17:51:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345947AbiDRPxw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Apr 2022 11:53:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345953AbiDRPx3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Apr 2022 11:53:29 -0400
Received: from mail-qk1-x72f.google.com (mail-qk1-x72f.google.com [IPv6:2607:f8b0:4864:20::72f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC441BF43
        for <netdev@vger.kernel.org>; Mon, 18 Apr 2022 08:38:52 -0700 (PDT)
Received: by mail-qk1-x72f.google.com with SMTP id a186so8707941qkc.10
        for <netdev@vger.kernel.org>; Mon, 18 Apr 2022 08:38:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pggPuZdJ0sh0DRZQ6dxN1mTrIZCiKodH9ePXo1UN6eE=;
        b=D85011SQWwV83FLxK51Peevvwd4ygZVvdHSSDq2iGCAnmuVu4r/QmheA0MxMwgmMKy
         jKtH66gyQ40X5rSCIC0pIsxnnVTO9w6eOD/QQljIwubCF43VGrGUdOTddMfHOYM0aY76
         p4k71idrzpokpYOY/K/iA6KNsQcz/75pbFcGvKxDurgjL26JSEcFxvSXU0Zmc9iXKDWG
         r10Rl1GDm6832/dHtfVS8JHg92I9Rf5zWOJf4abgfl3kLEihzSWSKBK4GW1oeHVZps5e
         OK7x5IYnLR0jKmTBgYQk1C6uYGB2RCx+6dkjS/G2JOJhpDmYjy0w/4eS7vw/9SgJib46
         4rYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pggPuZdJ0sh0DRZQ6dxN1mTrIZCiKodH9ePXo1UN6eE=;
        b=pQptgC5cibP8OGUv9h3WepzOf6p43pOM3GfbImvnnjUhGki4hvs/E/vRqprBz2QhR2
         dplkP50+q+0H+1aZkwtf12ycDY/sWxK7sGvt66CXKc8Le4dpKWg+k7SUQwkXYVmPZvx9
         4Rkzr4r8XSTghbywtOlKAXMi9HmmbiXuMIwuLBCC/kztiDyTCYUWtxl3BxKJuIKjmkb9
         eAsfkvzThyudHHG1xoYBvhuoAvnoOdkS31+CuBYXMorSgogaXjmc2GPZGXeaNvJcXA3A
         bFRRMdT9ohqeoU11TYAKHvsNUttbRXy3CtiLfayQznQ27UKEPSiDlMHEcs5z66iFtdwi
         T7mQ==
X-Gm-Message-State: AOAM533rdApX0DeLNcSc+jiYy6Iqa8LVkpbnGspjw2wutzWSZUrv0fv4
        a65lPAghWAbjUUNdhWueMRXy2hhqKys=
X-Google-Smtp-Source: ABdhPJwDAhvGUJqv80TIz+BmGBDAnCOALLy7YpwR8AKc0I26kL8zIJ7gRJoUs3xKmBHG5Nto5avWnQ==
X-Received: by 2002:a05:620a:24c4:b0:69e:a0ad:ff5d with SMTP id m4-20020a05620a24c400b0069ea0adff5dmr2908643qkn.11.1650296331902;
        Mon, 18 Apr 2022 08:38:51 -0700 (PDT)
Received: from mail-yw1-f180.google.com (mail-yw1-f180.google.com. [209.85.128.180])
        by smtp.gmail.com with ESMTPSA id g21-20020ac85815000000b002e06e2623a7sm7917924qtg.0.2022.04.18.08.38.51
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Apr 2022 08:38:51 -0700 (PDT)
Received: by mail-yw1-f180.google.com with SMTP id 00721157ae682-2edbd522c21so142748597b3.13
        for <netdev@vger.kernel.org>; Mon, 18 Apr 2022 08:38:51 -0700 (PDT)
X-Received: by 2002:a81:1345:0:b0:2ec:31ea:dfdb with SMTP id
 66-20020a811345000000b002ec31eadfdbmr10771840ywt.351.1650296330562; Mon, 18
 Apr 2022 08:38:50 -0700 (PDT)
MIME-Version: 1.0
References: <20220418044339.127545-1-liuhangbin@gmail.com> <20220418044339.127545-2-liuhangbin@gmail.com>
In-Reply-To: <20220418044339.127545-2-liuhangbin@gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Mon, 18 Apr 2022 11:38:14 -0400
X-Gmail-Original-Message-ID: <CA+FuTScQ=tP=cr5f2S97Z7ex1HMX5R-C0W6JE2Bx5UWgiGknZA@mail.gmail.com>
Message-ID: <CA+FuTScQ=tP=cr5f2S97Z7ex1HMX5R-C0W6JE2Bx5UWgiGknZA@mail.gmail.com>
Subject: Re: [PATCH net 1/2] net/af_packet: adjust network header position for
 VLAN tagged packets
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        virtualization@lists.linux-foundation.org,
        Balazs Nemeth <bnemeth@redhat.com>,
        Mike Pattrick <mailmpattric@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Flavio Leitner <fbl@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 18, 2022 at 12:44 AM Hangbin Liu <liuhangbin@gmail.com> wrote:
>
> Flavio reported that the kernel drops GSO VLAN tagged packet if it's
> created with socket(AF_PACKET, SOCK_RAW, 0) plus virtio_net_hdr.
>
> The reason is AF_PACKET doesn't adjust the skb network header if there is
> a VLAN tag. Then after virtio_net_hdr_set_proto() called, the skb->protocol
> will be set to ETH_P_IP/IPv6. And in later inet/ipv6_gso_segment() the skb
> is dropped as network header position is invalid.
>
> Fix it by adjusting network header position in packet_parse_headers()
> and move the function before calling virtio_net_hdr_* functions.
>
> I also moved skb->no_fcs setting upper to make all skb setting together
> and keep consistence of function packet_sendmsg_spkt().
>
> No need to update tpacket_snd() as it calls packet_parse_headers() in
> tpacket_fill_skb() before calling virtio_net_hdr_* functions.
>
> Fixes: 75c65772c3d1 ("net/packet: Ask driver for protocol if not provided by user")
> Reported-by: Flavio Leitner <fbl@redhat.com>
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>

Strictly speaking VLAN tagged GSO packets have never been supported.
The only defined types are TCP and UDP over IPv4 and IPv6:

  define VIRTIO_NET_HDR_GSO_TCPV4        1       /* GSO frame, IPv4 TCP (TSO) */
  define VIRTIO_NET_HDR_GSO_UDP          3       /* GSO frame, IPv4 UDP (UFO) */
  define VIRTIO_NET_HDR_GSO_TCPV6        4       /* GSO frame, IPv6 TCP */

I don't think this is a bug, more a stretching of the definition of those flags.

> ---
>  net/packet/af_packet.c | 18 +++++++++++++-----
>  1 file changed, 13 insertions(+), 5 deletions(-)
>
> diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
> index 002d2b9c69dd..cfdbda28ef82 100644
> --- a/net/packet/af_packet.c
> +++ b/net/packet/af_packet.c
> @@ -1924,12 +1924,20 @@ static int packet_rcv_spkt(struct sk_buff *skb, struct net_device *dev,
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
> +       /* Move network header to the right position for VLAN tagged packets */
> +       if (likely(skb->dev->type == ARPHRD_ETHER) &&
> +           eth_type_vlan(skb->protocol) &&
> +           __vlan_get_protocol(skb, skb->protocol, &depth) != 0)
> +               skb_set_network_header(skb, depth);
> +
>         skb_probe_transport_header(skb);
>  }
>
> @@ -3047,6 +3055,11 @@ static int packet_snd(struct socket *sock, struct msghdr *msg, size_t len)

>         skb->mark = sockc.mark;
>         skb->tstamp = sockc.transmit_time;
>
> +       if (unlikely(extra_len == 4))
> +               skb->no_fcs = 1;
> +
> +       packet_parse_headers(skb, sock);
> +
>         if (has_vnet_hdr) {
>                 err = virtio_net_hdr_to_skb(skb, &vnet_hdr, vio_le());
>                 if (err)
> @@ -3055,11 +3068,6 @@ static int packet_snd(struct socket *sock, struct msghdr *msg, size_t len)
>                 virtio_net_hdr_set_proto(skb, &vnet_hdr);
>         }
>
> -       packet_parse_headers(skb, sock);
> -
> -       if (unlikely(extra_len == 4))
> -               skb->no_fcs = 1;
> -

Moving packet_parse_headers before or after virtio_net_hdr_to_skb may
have additional subtle effects on protocol detection.

I think it's probably okay, as tpacket_snd also calls in the inverse
order. But there have been many issues in this codepath.

We should also maintain feature consistency between packet_snd,
tpacket_snd and to the limitations of its feature set to
packet_sendmsg_spkt. The no_fcs is already lacking in tpacket_snd as
far as I can tell. But packet_sendmsg_spkt also sets it and calls
packet_parse_headers.

Because this patch touches many other packets besides the ones
intended, I am a bit concerned about unintended consequences. Perhaps
stretching the definition of the flags to include VLAN is acceptable
(unlike outright tunnels), but even then I would suggest for net-next.

>         err = po->xmit(skb);
>         if (unlikely(err != 0)) {
>                 if (err > 0)
