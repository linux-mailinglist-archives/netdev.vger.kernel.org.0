Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 008DF39A519
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 17:55:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230030AbhFCP51 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 11:57:27 -0400
Received: from mail-qt1-f201.google.com ([209.85.160.201]:33678 "EHLO
        mail-qt1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229892AbhFCP50 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Jun 2021 11:57:26 -0400
Received: by mail-qt1-f201.google.com with SMTP id w1-20020ac87a610000b02902433332a0easo3366096qtt.0
        for <netdev@vger.kernel.org>; Thu, 03 Jun 2021 08:55:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=BVwB9mZNB0QNsrRhIO7cJmajtoaK+6GTcUAMg7GdzSw=;
        b=uG9L3szdNf/HaQZ/NKYnGL7PL25mQWAx+aP4FVRNRZ4QesDlSWhvGwO6YS9zN79eQN
         wT9SrEcjw/v45eSND7MVgCW3CT7JJe0ZkkGlI3S+xY9Kv6RmiTpQJWKUjAZ0KQyZg6Y6
         cprqKvVGSlQWlyOL3l9w/E/lhk/Giz1+uZvxbEvHDvWqRvLiAbMQYx3bqdqCmg/NqEA6
         haO0s6qEMoVjpmoCZV6tVaLEFBGZiyVol5cd2LZeEV//jRCOheyuoTrBl4LaMo+uZmFa
         N79XLzGktM4OZLhiP8Ycdw6gOTri0lHapDUoS+ZNEt/0s/PehusDqRzpUGKvV08J5in9
         XXgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=BVwB9mZNB0QNsrRhIO7cJmajtoaK+6GTcUAMg7GdzSw=;
        b=D7jyok1nVNm+S8Xv2o21kAbT1PE5FXISHbiM6nJAXJnq3f1pJfj+7AIcLfcGDhkJh3
         EaQzlCpl+DpsaDTZzYu7QdA9w0tmxbDdRzJ1+k81jQZkneglDZUClpw+SxJjeixFbH43
         Lv2gNQcJw+hzUjS81BTYY7pf7eRPFcIXZ3qZdhVMiF6u1dVu/gcGZUQp0H1m/yhbPh20
         SjROz7MdC+u3KLIlOot4c2WWV6uTrjiBlR2qRTvvgqNiJKgoPJOD0GtPQEa7TTq2Ccki
         NkkDJEUjRFkSvcpFgaIXvnRl6KgwmcYD1SzVCn93EzvaaF2PO37zr/OaMVP+b0cDtqOU
         0vhg==
X-Gm-Message-State: AOAM53357BlUUIsKoqf/EW9qNoc6K5dkJ6WWkqeXnkX5PMeVt5xLT84P
        0UMzGXEkS814eCNmRWc/1fr7KBc=
X-Google-Smtp-Source: ABdhPJyT4jusf3kSy+u6KTE4vQt2EXmNk8QjgYx4Xk7rbmsHgQsstun42tWNfuX8sthgX3M1l5E+vcg=
X-Received: from sdf2.svl.corp.google.com ([2620:15c:2c4:1:9d0a:7a1b:c5e:c9f])
 (user=sdf job=sendgmr) by 2002:a0c:c481:: with SMTP id u1mr408432qvi.48.1622735670775;
 Thu, 03 Jun 2021 08:54:30 -0700 (PDT)
Date:   Thu, 3 Jun 2021 08:54:28 -0700
In-Reply-To: <20210601221841.1251830-3-tannerlove.kernel@gmail.com>
Message-Id: <YLj7ND1kQyBN30m7@google.com>
Mime-Version: 1.0
References: <20210601221841.1251830-1-tannerlove.kernel@gmail.com> <20210601221841.1251830-3-tannerlove.kernel@gmail.com>
Subject: Re: [PATCH net-next v3 2/3] virtio_net: add optional flow dissection
 in virtio_net_hdr_to_skb
From:   sdf@google.com
To:     Tanner Love <tannerlove.kernel@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Petar Penkov <ppenkov@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Tanner Love <tannerlove@google.com>,
        kernel test robot <lkp@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/01, Tanner Love wrote:
> From: Tanner Love <tannerlove@google.com>

> Syzkaller bugs have resulted from loose specification of
> virtio_net_hdr[1]. Enable execution of a BPF flow dissector program
> in virtio_net_hdr_to_skb to validate the vnet header and drop bad
> input.

> The existing behavior of accepting these vnet headers is part of the
> ABI. But individual admins may want to enforce restrictions. For
> example, verifying that a GSO_TCPV4 gso_type matches packet contents:
> unencapsulated TCP/IPV4 packet with payload exceeding gso_size and
> hdr_len at payload offset.

> Introduce a new sysctl net.core.flow_dissect_vnet_hdr controlling a
> static key to decide whether to perform flow dissection. When the key
> is false, virtio_net_hdr_to_skb computes as before.

> [1]  
> https://syzkaller.appspot.com/bug?id=b419a5ca95062664fe1a60b764621eb4526e2cd0

> [ um build error ]
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Tanner Love <tannerlove@google.com>
> Suggested-by: Willem de Bruijn <willemb@google.com>
> ---
>   include/linux/virtio_net.h | 25 +++++++++++++++++++++----
>   net/core/flow_dissector.c  |  3 +++
>   net/core/sysctl_net_core.c |  9 +++++++++
>   3 files changed, 33 insertions(+), 4 deletions(-)

> diff --git a/include/linux/virtio_net.h b/include/linux/virtio_net.h
> index b465f8f3e554..cdc6152b40c6 100644
> --- a/include/linux/virtio_net.h
> +++ b/include/linux/virtio_net.h
> @@ -25,10 +25,13 @@ static inline int virtio_net_hdr_set_proto(struct  
> sk_buff *skb,
>   	return 0;
>   }

> +DECLARE_STATIC_KEY_FALSE(sysctl_flow_dissect_vnet_hdr_key);
> +
>   static inline int virtio_net_hdr_to_skb(struct sk_buff *skb,
>   					const struct virtio_net_hdr *hdr,
>   					bool little_endian)
>   {
> +	struct flow_keys_basic keys;
>   	unsigned int gso_type = 0;
>   	unsigned int thlen = 0;
>   	unsigned int p_off = 0;
> @@ -78,13 +81,24 @@ static inline int virtio_net_hdr_to_skb(struct  
> sk_buff *skb,
>   		p_off = skb_transport_offset(skb) + thlen;
>   		if (!pskb_may_pull(skb, p_off))
>   			return -EINVAL;
> -	} else {
> +	}
> +
> +	/* BPF flow dissection for optional strict validation.
> +	 *
> +	 * Admins can define permitted packets more strictly, such as dropping
> +	 * deprecated UDP_UFO packets and requiring skb->protocol to be non-zero
> +	 * and matching packet headers.
> +	 */
> +	if (static_branch_unlikely(&sysctl_flow_dissect_vnet_hdr_key) &&
> +	    !__skb_flow_dissect_flow_keys_basic(NULL, skb, &keys, NULL, 0, 0, 0,
> +						0, hdr))
> +		return -EINVAL;
> +
> +	if (!(hdr->flags & VIRTIO_NET_HDR_F_NEEDS_CSUM)) {
>   		/* gso packets without NEEDS_CSUM do not set transport_offset.
>   		 * probe and drop if does not match one of the above types.
>   		 */
>   		if (gso_type && skb->network_header) {
> -			struct flow_keys_basic keys;
> -
>   			if (!skb->protocol) {
>   				__be16 protocol = dev_parse_header_protocol(skb);

> @@ -92,8 +106,11 @@ static inline int virtio_net_hdr_to_skb(struct  
> sk_buff *skb,
>   				if (protocol && protocol != skb->protocol)
>   					return -EINVAL;
>   			}
> +
>   retry:
> -			if (!skb_flow_dissect_flow_keys_basic(NULL, skb, &keys,
> +			/* only if flow dissection not already done */
> +			if (!static_branch_unlikely(&sysctl_flow_dissect_vnet_hdr_key) &&
> +			    !skb_flow_dissect_flow_keys_basic(NULL, skb, &keys,
>   							      NULL, 0, 0, 0,
>   							      0)) {
>   				/* UFO does not specify ipv4 or 6: try both */
> diff --git a/net/core/flow_dissector.c b/net/core/flow_dissector.c
> index 4b171ebec084..ae2ce382f4f4 100644
> --- a/net/core/flow_dissector.c
> +++ b/net/core/flow_dissector.c
> @@ -35,6 +35,9 @@
>   #endif
>   #include <linux/bpf-netns.h>

> +DEFINE_STATIC_KEY_FALSE(sysctl_flow_dissect_vnet_hdr_key);
> +EXPORT_SYMBOL(sysctl_flow_dissect_vnet_hdr_key);
> +
>   static void dissector_set_key(struct flow_dissector *flow_dissector,
>   			      enum flow_dissector_key_id key_id)
>   {
> diff --git a/net/core/sysctl_net_core.c b/net/core/sysctl_net_core.c
> index c8496c1142c9..c01b9366bb75 100644
> --- a/net/core/sysctl_net_core.c
> +++ b/net/core/sysctl_net_core.c
> @@ -36,6 +36,8 @@ static int net_msg_warn;	/* Unused, but still a sysctl  
> */
>   int sysctl_fb_tunnels_only_for_init_net __read_mostly = 0;
>   EXPORT_SYMBOL(sysctl_fb_tunnels_only_for_init_net);

> +DECLARE_STATIC_KEY_FALSE(sysctl_flow_dissect_vnet_hdr_key);
> +
>   /* 0 - Keep current behavior:
>    *     IPv4: inherit all current settings from init_net
>    *     IPv6: reset all settings to default
> @@ -580,6 +582,13 @@ static struct ctl_table net_core_table[] = {
>   		.extra1		= SYSCTL_ONE,
>   		.extra2		= &int_3600,
>   	},

[..]

> +	{
> +		.procname       = "flow_dissect_vnet_hdr",

This sounds generic, but iiuc, it makes sense only for bpf flow
dissection? Should it be bpf_flow_dissect_vnet_hdr instead?

Or should we drop this sysctl in favor of some per-program flag
(either attach_flags or some signal via btf)? That way,
individual bpf programs can signal their willingness to
parse vnet hdr.

> +		.data           = &sysctl_flow_dissect_vnet_hdr_key.key,
> +		.maxlen         = sizeof(sysctl_flow_dissect_vnet_hdr_key),
> +		.mode           = 0644,
> +		.proc_handler   = proc_do_static_key,
> +	},
>   	{ }
>   };

> --
> 2.32.0.rc0.204.g9fa02ecfa5-goog

