Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 505C33AA56B
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 22:38:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233595AbhFPUk6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 16:40:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233587AbhFPUk5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Jun 2021 16:40:57 -0400
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CCA8C061574
        for <netdev@vger.kernel.org>; Wed, 16 Jun 2021 13:38:50 -0700 (PDT)
Received: by mail-yb1-xb2e.google.com with SMTP id m9so4916411ybo.5
        for <netdev@vger.kernel.org>; Wed, 16 Jun 2021 13:38:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YsjDt3ZVo6mJ29PxtGRcx/BwGAyIy9F8zE8F+8ekj/o=;
        b=JBirYD/PFBBHvUy8dIEGPueccS8sBsW97svGxFsN2QckgNp95cyN0SYBaYH47RC6gn
         ZBOvu7gPBkOhWuYX2kn4dJR3PdGusM9+O1HIe4EeuyGtstSuxO+E475uWF8NO4RzTK3+
         VQl+xWkOlIBSchHeVkSRWyFUUoyF24wMh3zmnxqKWhIWWHmmv35cujyu997CuL2CcR9I
         3ajylUFd8MTM3XoBc6YT/R6kAJOrLq2DH/s+KK7w8GQHyyrwr9qNUrmF1kjLd5DyTwDb
         indOVLpo8DbEbzLHZvRMCmbbupBwpXF8s5uKobDsN3WwdvoLjTIpkgjg+BWO1H9ch3AX
         iyqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YsjDt3ZVo6mJ29PxtGRcx/BwGAyIy9F8zE8F+8ekj/o=;
        b=jay9/z06CxyDO34cOenZAZELD5jjmEJwRqpp+oizyGzIEIkLDQQ3UWzbg7G8QrX2d7
         CxY+sxydSIwHJjkTs0cfR25rzeeOExRQ71Ash4sgfP0ySUryiNBxPkKll+wcjfA9vlQ2
         6VSY/Dy8E+bF/KOWuDZ1UJQyJlUGC/DXnQYUgoPLeFQUKxhGBQh0rx5MAK4yHeNN10sB
         WIQ2TuZt4uhjQ7c1XnFbqvuCK+EINSOanlHhgvDLmEeMM0GWOBgGVHU+DKMQiX2SjJMP
         Yj+QyRElzR0H2yKAOzpdIYY/gr2QkXo0GiO+w801cxITfy6p9EGdvbI5IfUg7SAMvYK2
         Z8KQ==
X-Gm-Message-State: AOAM5324soJOJ8tC6Nq6SuVh5W9l8yf+/lKkVRMdsDAAOZdqd5oCXrnw
        2XHQWOgZ+oKrmqmRaROV4I2x41toPjERxMLU18UGQ/Swz6I=
X-Google-Smtp-Source: ABdhPJwjC6Taq/tT2O5W5HA4Xisvzz+wwAFdz6tsU4sQmpejghYahA3hE6Z3+iuFJH5gqFY4p7MVSDaAp+ZWurZ0yCU=
X-Received: by 2002:a05:6902:1028:: with SMTP id x8mr1412567ybt.140.1623875929418;
 Wed, 16 Jun 2021 13:38:49 -0700 (PDT)
MIME-Version: 1.0
References: <20210616203448.995314-1-tannerlove.kernel@gmail.com> <20210616203448.995314-3-tannerlove.kernel@gmail.com>
In-Reply-To: <20210616203448.995314-3-tannerlove.kernel@gmail.com>
From:   Tanner Love <tannerlove.kernel@gmail.com>
Date:   Wed, 16 Jun 2021 13:38:38 -0700
Message-ID: <CAHrNZNi-3u2r1z=nCyQyiCLVb6JWFfD3WP26q_Rg83zNzK3Png@mail.gmail.com>
Subject: Re: [PATCH net-next v7 2/3] virtio_net: add optional flow dissection
 in virtio_net_hdr_to_skb
To:     Network Development <netdev@vger.kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Petar Penkov <ppenkov@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Tanner Love <tannerlove@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We are still working on resolving the larger design comment
discussion in v4. These updates address specific implementation
feedback from v6. Thanks

On Wed, Jun 16, 2021 at 1:34 PM Tanner Love <tannerlove.kernel@gmail.com> wrote:
>
> From: Tanner Love <tannerlove@google.com>
>
> Syzkaller bugs have resulted from loose specification of
> virtio_net_hdr[1]. Enable execution of a BPF flow dissector program
> in virtio_net_hdr_to_skb to validate the vnet header and drop bad
> input.
>
> Introduce a new sysctl net.core.flow_dissect_vnet_hdr controlling a
> static key to decide whether to perform flow dissection. When the key
> is false, virtio_net_hdr_to_skb computes as before.
>
> A permissive specification of vnet headers is part of the ABI. Some
> applications now depend on it. Still, many of these packets are bogus.
> Give admins the option to interpret behavior more strictly. For
> instance, verifying that a VIRTIO_NET_HDR_GSO_TCPV6 header matches a
> packet with unencapsulated IPv6/TCP without extension headers, with
> payload length exceeding gso_size and hdr_len exactly at TCP payload
> offset.
>
> BPF flow dissection implements protocol parsing in an safe way. And is
> configurable, so can be as pedantic as the workload allows (e.g.,
> dropping UFO altogether).
>
> Vnet_header flow dissection is *not* a substitute for fixing bugs when
> reported. But even if not enabled continuously, offers a quick path to
> mitigating vulnerabilities.
>
> [1] https://syzkaller.appspot.com/bug?id=b419a5ca95062664fe1a60b764621eb4526e2cd0
>
> Changes
> v4:
>   - Expand commit message with rationale for bpf flow dissector based
>     implementation
> v3:
>   - Move sysctl_flow_dissect_vnet_hdr_key definition to
>     flow_dissector.c to fix CONFIG_SYSCTL warning when building UML
>
> Suggested-by: Willem de Bruijn <willemb@google.com>
> Signed-off-by: Tanner Love <tannerlove@google.com>
> Reviewed-by: Willem de Bruijn <willemb@google.com>
> ---
>  include/linux/virtio_net.h | 25 +++++++++++++++++++++----
>  net/core/flow_dissector.c  |  3 +++
>  net/core/sysctl_net_core.c |  9 +++++++++
>  3 files changed, 33 insertions(+), 4 deletions(-)
>
> diff --git a/include/linux/virtio_net.h b/include/linux/virtio_net.h
> index b465f8f3e554..b67b5413f2ce 100644
> --- a/include/linux/virtio_net.h
> +++ b/include/linux/virtio_net.h
> @@ -25,10 +25,13 @@ static inline int virtio_net_hdr_set_proto(struct sk_buff *skb,
>         return 0;
>  }
>
> +DECLARE_STATIC_KEY_FALSE(sysctl_flow_dissect_vnet_hdr_key);
> +
>  static inline int virtio_net_hdr_to_skb(struct sk_buff *skb,
>                                         const struct virtio_net_hdr *hdr,
>                                         bool little_endian)
>  {
> +       struct flow_keys_basic keys;
>         unsigned int gso_type = 0;
>         unsigned int thlen = 0;
>         unsigned int p_off = 0;
> @@ -78,13 +81,24 @@ static inline int virtio_net_hdr_to_skb(struct sk_buff *skb,
>                 p_off = skb_transport_offset(skb) + thlen;
>                 if (!pskb_may_pull(skb, p_off))
>                         return -EINVAL;
> -       } else {
> +       }
> +
> +       /* BPF flow dissection for optional strict validation.
> +        *
> +        * Admins can define permitted packets more strictly, such as dropping
> +        * deprecated UDP_UFO packets and requiring skb->protocol to be non-zero
> +        * and matching packet headers.
> +        */
> +       if (static_branch_unlikely(&sysctl_flow_dissect_vnet_hdr_key) &&
> +           !__skb_flow_dissect_flow_keys_basic(NULL, skb, &keys, NULL, 0, 0, 0,
> +                                               0, hdr, little_endian))
> +               return -EINVAL;
> +
> +       if (!(hdr->flags & VIRTIO_NET_HDR_F_NEEDS_CSUM)) {
>                 /* gso packets without NEEDS_CSUM do not set transport_offset.
>                  * probe and drop if does not match one of the above types.
>                  */
>                 if (gso_type && skb->network_header) {
> -                       struct flow_keys_basic keys;
> -
>                         if (!skb->protocol) {
>                                 __be16 protocol = dev_parse_header_protocol(skb);
>
> @@ -92,8 +106,11 @@ static inline int virtio_net_hdr_to_skb(struct sk_buff *skb,
>                                 if (protocol && protocol != skb->protocol)
>                                         return -EINVAL;
>                         }
> +
>  retry:
> -                       if (!skb_flow_dissect_flow_keys_basic(NULL, skb, &keys,
> +                       /* only if flow dissection not already done */
> +                       if (!static_branch_unlikely(&sysctl_flow_dissect_vnet_hdr_key) &&
> +                           !skb_flow_dissect_flow_keys_basic(NULL, skb, &keys,
>                                                               NULL, 0, 0, 0,
>                                                               0)) {
>                                 /* UFO does not specify ipv4 or 6: try both */
> diff --git a/net/core/flow_dissector.c b/net/core/flow_dissector.c
> index 609e24ba98ea..046aa2a8c39d 100644
> --- a/net/core/flow_dissector.c
> +++ b/net/core/flow_dissector.c
> @@ -35,6 +35,9 @@
>  #endif
>  #include <linux/bpf-netns.h>
>
> +DEFINE_STATIC_KEY_FALSE(sysctl_flow_dissect_vnet_hdr_key);
> +EXPORT_SYMBOL(sysctl_flow_dissect_vnet_hdr_key);
> +
>  static void dissector_set_key(struct flow_dissector *flow_dissector,
>                               enum flow_dissector_key_id key_id)
>  {
> diff --git a/net/core/sysctl_net_core.c b/net/core/sysctl_net_core.c
> index c8496c1142c9..c01b9366bb75 100644
> --- a/net/core/sysctl_net_core.c
> +++ b/net/core/sysctl_net_core.c
> @@ -36,6 +36,8 @@ static int net_msg_warn;      /* Unused, but still a sysctl */
>  int sysctl_fb_tunnels_only_for_init_net __read_mostly = 0;
>  EXPORT_SYMBOL(sysctl_fb_tunnels_only_for_init_net);
>
> +DECLARE_STATIC_KEY_FALSE(sysctl_flow_dissect_vnet_hdr_key);
> +
>  /* 0 - Keep current behavior:
>   *     IPv4: inherit all current settings from init_net
>   *     IPv6: reset all settings to default
> @@ -580,6 +582,13 @@ static struct ctl_table net_core_table[] = {
>                 .extra1         = SYSCTL_ONE,
>                 .extra2         = &int_3600,
>         },
> +       {
> +               .procname       = "flow_dissect_vnet_hdr",
> +               .data           = &sysctl_flow_dissect_vnet_hdr_key.key,
> +               .maxlen         = sizeof(sysctl_flow_dissect_vnet_hdr_key),
> +               .mode           = 0644,
> +               .proc_handler   = proc_do_static_key,
> +       },
>         { }
>  };
>
> --
> 2.32.0.272.g935e593368-goog
>
