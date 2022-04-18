Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C981505BFE
	for <lists+netdev@lfdr.de>; Mon, 18 Apr 2022 17:52:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345500AbiDRPys (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Apr 2022 11:54:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345804AbiDRPyb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Apr 2022 11:54:31 -0400
Received: from mail-qk1-x72a.google.com (mail-qk1-x72a.google.com [IPv6:2607:f8b0:4864:20::72a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC8BD2E9E7
        for <netdev@vger.kernel.org>; Mon, 18 Apr 2022 08:41:22 -0700 (PDT)
Received: by mail-qk1-x72a.google.com with SMTP id s4so11486012qkh.0
        for <netdev@vger.kernel.org>; Mon, 18 Apr 2022 08:41:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NIlNiSkkSkgTapGfecwZRIqvyhekuiNyDyxM96ZsPI4=;
        b=POT7koJZVyf0j8gHL1RT150kUn1gZh12BE6+ykwhi2ekMHb9lLcuhssdNkfU9EKQbP
         KTVQyXsUAxGT3DnmFoWpXcZNl9zALhEWEu7dIuhij8G9o/x8U0dUhSFq1GkW8M+/s+9y
         gAWfNf4fYr8wqMpwKIho3ACE3aWTuTZeeLcyDfvTQYAbcRom7YBgM+5Wo5o+N3RE/31y
         Zjn1jyQibJg/33NOqMSuBOzXusme3ILdVzopHP2QB6giyeEAk1uQx08Tg5ViIv5bOta6
         M/CJwER9qKu6iV2k4lQzf6mBn/o5/EJSuvtzGoNwln8UBranoqu0EnOnWLN30jDsjfW5
         1F1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NIlNiSkkSkgTapGfecwZRIqvyhekuiNyDyxM96ZsPI4=;
        b=kYCdig/bPloXaj+9pisuqskmWmuA5rLX+JKZrA1Ie051AESRN4OIeTWgUW1YYIPdzB
         PUWgdQqdSk3EOjTqWVOdHJiF4OVDSpLcsS04rq+nItEyMXsZNpOXw0D/vFqwoa+DL64e
         EUXnVFV8fx85ejCcQ/BlzO1ehvm+uR4xnBiZwzuIzQbedAMgBcDLevat5hzNpatuPWHr
         h31XiGtResa2Loq3eRf6eInCGyGfvIRlNo/QVtvpGI4p/DeoJqGZC4qkI6W1hTGt9SQ6
         EBOGsWPngj9SBJgilgShK1NyW57LMigr+UqI/ekeYxhgpgQL3221/kYm6p6ChAYDpr4g
         454w==
X-Gm-Message-State: AOAM530T0OAiD80YCl2B1el3Kh74Sv+ttKSGhOL7Ifi2t5bk8GImz8VM
        +5IjM2BgHolA6MqTQe6kGGU8QlMWtA8=
X-Google-Smtp-Source: ABdhPJwGZ7Ba83JeGCLZUvj5yO95zB5yryD52mIu0TS+4TpQdgFS7v8MbaPbV1wkYhHbC0thTOxYTg==
X-Received: by 2002:a05:620a:2a14:b0:69e:9996:4d2b with SMTP id o20-20020a05620a2a1400b0069e99964d2bmr3376103qkp.280.1650296481810;
        Mon, 18 Apr 2022 08:41:21 -0700 (PDT)
Received: from mail-yb1-f180.google.com (mail-yb1-f180.google.com. [209.85.219.180])
        by smtp.gmail.com with ESMTPSA id y66-20020a37af45000000b0067dc0fc539fsm6846887qke.86.2022.04.18.08.41.21
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Apr 2022 08:41:21 -0700 (PDT)
Received: by mail-yb1-f180.google.com with SMTP id f38so26211239ybi.3
        for <netdev@vger.kernel.org>; Mon, 18 Apr 2022 08:41:21 -0700 (PDT)
X-Received: by 2002:a25:b94a:0:b0:644:db14:ff10 with SMTP id
 s10-20020a25b94a000000b00644db14ff10mr7288155ybm.648.1650296480886; Mon, 18
 Apr 2022 08:41:20 -0700 (PDT)
MIME-Version: 1.0
References: <20220418044339.127545-1-liuhangbin@gmail.com> <20220418044339.127545-3-liuhangbin@gmail.com>
In-Reply-To: <20220418044339.127545-3-liuhangbin@gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Mon, 18 Apr 2022 11:40:44 -0400
X-Gmail-Original-Message-ID: <CA+FuTSdTbpYGJo6ec2Ti+djXCj=gBAQpv9ZVaTtaJA-QUNNgYQ@mail.gmail.com>
Message-ID: <CA+FuTSdTbpYGJo6ec2Ti+djXCj=gBAQpv9ZVaTtaJA-QUNNgYQ@mail.gmail.com>
Subject: Re: [PATCH net 2/2] virtio_net: check L3 protocol for VLAN packets
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
        Eric Dumazet <edumazet@google.com>
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
> For gso packets, virtio_net_hdr_to_skb() will check the protocol via
> virtio_net_hdr_match_proto(). But a packet may come from a raw socket
> with a VLAN tag. Checking the VLAN protocol for virtio net_hdr makes no
> sense. Let's check the L3 protocol if it's a VLAN packet.
>
> Make the virtio_net_hdr_match_proto() checking for all skbs instead of
> only skb without protocol setting.
>
> Also update the data, protocol parameter for
> skb_flow_dissect_flow_keys_basic() as the skb->protocol may not IP or IPv6.
>
> Fixes: 7e5cced9ca84 ("net: accept UFOv6 packages in virtio_net_hdr_to_skb")
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> ---
>  include/linux/virtio_net.h | 26 +++++++++++++++++++-------
>  1 file changed, 19 insertions(+), 7 deletions(-)
>
> diff --git a/include/linux/virtio_net.h b/include/linux/virtio_net.h
> index a960de68ac69..97b4f9680786 100644
> --- a/include/linux/virtio_net.h
> +++ b/include/linux/virtio_net.h
> @@ -3,6 +3,7 @@
>  #define _LINUX_VIRTIO_NET_H
>
>  #include <linux/if_vlan.h>
> +#include <uapi/linux/if_arp.h>
>  #include <uapi/linux/tcp.h>
>  #include <uapi/linux/udp.h>
>  #include <uapi/linux/virtio_net.h>
> @@ -102,25 +103,36 @@ static inline int virtio_net_hdr_to_skb(struct sk_buff *skb,
>                  */
>                 if (gso_type && skb->network_header) {

This whole branch should not be taken by well formed packets. It is
inside the else clause of

       if (hdr->flags & VIRTIO_NET_HDR_F_NEEDS_CSUM) {
          ..
       } else {

GSO packets should always request checksum offload. The fact that we
try to patch up some incomplete packets should not have to be expanded
if we expand support to include VLAN.

>                         struct flow_keys_basic keys;
> +                       __be16 protocol;
>
>                         if (!skb->protocol) {
> -                               __be16 protocol = dev_parse_header_protocol(skb);
> +                               protocol = dev_parse_header_protocol(skb);
>
>                                 if (!protocol)
>                                         virtio_net_hdr_set_proto(skb, hdr);
> -                               else if (!virtio_net_hdr_match_proto(protocol, hdr->gso_type))
> -                                       return -EINVAL;
>                                 else
>                                         skb->protocol = protocol;
> +                       } else {
> +                               protocol = skb->protocol;
>                         }
> +
> +                       /* Get L3 protocol if current protocol is VLAN */
> +                       if (likely(skb->dev->type == ARPHRD_ETHER) &&
> +                           eth_type_vlan(protocol))
> +                               protocol = vlan_get_protocol(skb);
> +
> +                       if (!virtio_net_hdr_match_proto(protocol, hdr->gso_type))
> +                               return -EINVAL;
> +
>  retry:
>                         if (!skb_flow_dissect_flow_keys_basic(NULL, skb, &keys,
> -                                                             NULL, 0, 0, 0,
> -                                                             0)) {
> +                                                             skb->data, protocol,
> +                                                             skb_network_offset(skb),
> +                                                             skb_headlen(skb), 0)) {
>                                 /* UFO does not specify ipv4 or 6: try both */
>                                 if (gso_type & SKB_GSO_UDP &&
> -                                   skb->protocol == htons(ETH_P_IP)) {
> -                                       skb->protocol = htons(ETH_P_IPV6);
> +                                   protocol == htons(ETH_P_IP)) {
> +                                       protocol = htons(ETH_P_IPV6);
>                                         goto retry;
>                                 }
>                                 return -EINVAL;
> --
> 2.35.1
>
