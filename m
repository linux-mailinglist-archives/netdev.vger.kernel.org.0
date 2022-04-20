Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7CDC508995
	for <lists+netdev@lfdr.de>; Wed, 20 Apr 2022 15:46:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352181AbiDTNsm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Apr 2022 09:48:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359640AbiDTNsl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Apr 2022 09:48:41 -0400
Received: from mail-qv1-xf2e.google.com (mail-qv1-xf2e.google.com [IPv6:2607:f8b0:4864:20::f2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D2131EAC3
        for <netdev@vger.kernel.org>; Wed, 20 Apr 2022 06:45:55 -0700 (PDT)
Received: by mail-qv1-xf2e.google.com with SMTP id e17so1317772qvj.11
        for <netdev@vger.kernel.org>; Wed, 20 Apr 2022 06:45:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sJ9RcLP/tVKLGGcddgv1aP+nCZRY90/FrE1CfkE17Wo=;
        b=ObJYAxxv+0Jbrw5A391F9sRv3RmmwNNY6duAzbboDeK+PvuCA7ShcdBbK+IpgsXFSe
         mEOmWlho+qpTLXkljWGHJCPbmjHCF6E7S4IRistEHPITE3if+OkzwQhW1bz6EEOeKMPb
         nEEvKwjaHRcLIDTAr98URp+Aokcn34iIWr/iyRuhawJ8ywiCHKj9VhUEza8wX6Hqo8HI
         ax4CBKPQpIOy+0h9c1p4BGvEwDzLlVIH8IlLzhTijTKpULznHYxX29RIraw+/x/weZ1C
         t+NXPcb1F79rpYE5BDD3qtoUldMnlLqKF1SJfo3ROOELQtH89sBh9HMzJGkYHJsA2s6c
         ZjQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sJ9RcLP/tVKLGGcddgv1aP+nCZRY90/FrE1CfkE17Wo=;
        b=km1m2Vs8Sx1cH6e3XzsmADzHY7WzncamiZx3bPZlfv9w0lHR7Bk6KNlDaXkugd3fO0
         qLI1XJQn9oJUnFVMxU3mPUtMa86/e/K0pTOYCJ2EzKiFx4OHhb6/8PYBPzGUuSL4AxLj
         EC1/xQWkxmo5X4MaBy63FTZ2iZfhdOeTnWc9N6dBr/+J851XnSo4FtycNziNmzhMmHtu
         fOsFCu7z/qKE4OazPttA+u/PR8MuX7oHaGvEV+ut9nqfpAVMweoZ5vL1ANaotEOY1UlI
         LhSAKOst9OM+D+H+uxS8mkd5wP9WFjlru+pGpHtSiVKkDND4gMhNxMRImfFCLjcZhh2u
         hmdg==
X-Gm-Message-State: AOAM533hwbdr/sBuuPWTXlOgRkvg7JCvyssQFU5nVcodWTHFg8laYxDM
        y0iv+hHVnGRnO/qnlZZ0wIKiqTaBZ78=
X-Google-Smtp-Source: ABdhPJzM96IcyOXRN3zudvkrro9aEKFWCU1nf61XwlBeEaLiZufJ6p8S+/EUnzHFA8hjLUw5otnIGA==
X-Received: by 2002:a05:6214:2304:b0:438:458e:eafc with SMTP id gc4-20020a056214230400b00438458eeafcmr15395443qvb.118.1650462354284;
        Wed, 20 Apr 2022 06:45:54 -0700 (PDT)
Received: from mail-yw1-f176.google.com (mail-yw1-f176.google.com. [209.85.128.176])
        by smtp.gmail.com with ESMTPSA id 15-20020ac8594f000000b002f200ea2518sm1851798qtz.59.2022.04.20.06.45.53
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Apr 2022 06:45:53 -0700 (PDT)
Received: by mail-yw1-f176.google.com with SMTP id 00721157ae682-2f16645872fso18571597b3.4
        for <netdev@vger.kernel.org>; Wed, 20 Apr 2022 06:45:53 -0700 (PDT)
X-Received: by 2002:a81:3902:0:b0:2eb:f9f0:4b0c with SMTP id
 g2-20020a813902000000b002ebf9f04b0cmr20527581ywa.419.1650462352755; Wed, 20
 Apr 2022 06:45:52 -0700 (PDT)
MIME-Version: 1.0
References: <20220420082758.581245-1-liuhangbin@gmail.com>
In-Reply-To: <20220420082758.581245-1-liuhangbin@gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 20 Apr 2022 09:45:15 -0400
X-Gmail-Original-Message-ID: <CA+FuTScyF4BKEcNSCYOv8SBA_EmB806YtKA17jb3F+fymVF-Pg@mail.gmail.com>
Message-ID: <CA+FuTScyF4BKEcNSCYOv8SBA_EmB806YtKA17jb3F+fymVF-Pg@mail.gmail.com>
Subject: Re: [PATCH net-next] net/af_packet: add VLAN support for AF_PACKET
 SOCK_RAW GSO
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, "Michael S . Tsirkin" <mst@redhat.com>,
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

On Wed, Apr 20, 2022 at 4:28 AM Hangbin Liu <liuhangbin@gmail.com> wrote:
>
> Currently, the kernel drops GSO VLAN tagged packet if it's created with
> socket(AF_PACKET, SOCK_RAW, 0) plus virtio_net_hdr.
>
> The reason is AF_PACKET doesn't adjust the skb network header if there is
> a VLAN tag. Then after virtio_net_hdr_set_proto() called, the skb->protocol
> will be set to ETH_P_IP/IPv6. And in later inet/ipv6_gso_segment() the skb
> is dropped as network header position is invalid.
>
> Let's handle VLAN packets by adjusting network header position in
> packet_parse_headers(), and move the function in packet_snd() before
> calling virtio_net_hdr_set_proto().

The network header is set in

        skb_reset_network_header(skb);

        err = -EINVAL;
        if (sock->type == SOCK_DGRAM) {
                offset = dev_hard_header(skb, dev, ntohs(proto), addr,
NULL, len);
                if (unlikely(offset < 0))
                        goto out_free;
        } else if (reserve) {
                skb_reserve(skb, -reserve);
                if (len < reserve + sizeof(struct ipv6hdr) &&
                    dev->min_header_len != dev->hard_header_len)
                        skb_reset_network_header(skb);
        }

If all that is needed is to move the network header beyond an optional
VLAN tag in the case of SOCK_RAW, then this can be done in the else
for Ethernet packets.

It is not safe to increase reserve, as that would eat into the
reserved hlen LL_RESERVED_SPACE(dev), which does not account for
optional VLAN headers.

Instead of setting here first, then patching up again later in
packet_parse_headers.

This change affects all packets with VLAN headers, not just those with
GSO. I imagine that moving the network header is safe for all, but
don't know that code well enough to verify that it does not have
unintended side effects. Does dev_queue_xmit expect the network header
to point to the start of the VLAN headers or after, for instance?

> No need to update tpacket_snd() as it calls packet_parse_headers() in
> tpacket_fill_skb(), which is already before calling virtio_net_hdr_*
> functions.
>
> skb->no_fcs setting is also moved upper to make all skb settings together
> and keep consistence with function packet_sendmsg_spkt().
>
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
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
>         err = po->xmit(skb);
>         if (unlikely(err != 0)) {
>                 if (err > 0)
> --
> 2.35.1
>
