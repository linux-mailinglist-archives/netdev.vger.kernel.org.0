Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7048E32C49E
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 01:54:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1447325AbhCDAPe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Mar 2021 19:15:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350701AbhCCTHC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Mar 2021 14:07:02 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6730BC061762
        for <netdev@vger.kernel.org>; Wed,  3 Mar 2021 10:54:17 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id g3so31381685edb.11
        for <netdev@vger.kernel.org>; Wed, 03 Mar 2021 10:54:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YKFQH6E0yNZuowlitL0N34JlWPD6X2Se55p2GC5RTco=;
        b=D2z0Gn99jifSpH4aD3vxwF1HsZhUEo7ZHIWKKwlftOgsXvzJy4CR9j1e7VGpMTpkzk
         DZjltsb8hsZ6COVcSSf54oRduRqNS7HwYj0d3+nYyJet5DRWaUAokYRbA21zGi0HMGw6
         icJDbi7zzceq1odFUJaaCO+0k8xJW974siTZFpSLH4a30gCdEjVxdBC7UBRiZvF53oWD
         8qHDkxX4aWd3FCScLKj6sniICzf7CXnKV+HP/9mehA0vUP+/NNIIAUGyKm8G/Mp+ESOG
         LV/4SOlxOCrrop84PalOIbCYRgU4bZ36CRmNPa6wlNOfx8eVLEDpBdPyFo0z+3BRF3kY
         y46A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YKFQH6E0yNZuowlitL0N34JlWPD6X2Se55p2GC5RTco=;
        b=ZwVmWv2UtGUA23C7FdOc8niiBPaD5PClRSkd5qUEFKyVyM0ldIvgvRGMj60guUewUu
         eXwBWkYXIxZkJ4IlMBsrD9pn1T16OShhQRxwGbrV7WogaPIKqtVh8R/fMmt4MqeJ3baT
         nnGaDryFlWiWTwlBBPvr36jaFDeLkJ+F8hfoRkK72S6qLdIITaBVsatqV0dKGWFVnNQT
         W+HLILelg9iVbaj5IL5aaHcZ5cjiyqdjWzX4UaIzdv1R4r2lraHQ879220fypSGVl3+z
         0PQc7zogF4JOH+eLIGlgEPtjUwfRU6sNQsonmElRuWFasbk5NK1OaqkqxC2kVlCvUc17
         mB4Q==
X-Gm-Message-State: AOAM533vYhNMsFthp8SsgLCKXSzV1ePVk3kV4EIpAHeCRbRaMXMtLZvB
        j9zTCuNLaMn3lwJxkrL5Szq28UlGOgk=
X-Google-Smtp-Source: ABdhPJy7YQZUqGbt9w4tzCHV2+dPEKnDYwp7u2nFcKT8ScD4kNMkRwMugtWW6rq/q0/bwThyWcGsBA==
X-Received: by 2002:a50:8b66:: with SMTP id l93mr706906edl.384.1614797655868;
        Wed, 03 Mar 2021 10:54:15 -0800 (PST)
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com. [209.85.128.52])
        by smtp.gmail.com with ESMTPSA id cb1sm20566288ejb.69.2021.03.03.10.54.12
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Mar 2021 10:54:12 -0800 (PST)
Received: by mail-wm1-f52.google.com with SMTP id l22so6034737wme.1
        for <netdev@vger.kernel.org>; Wed, 03 Mar 2021 10:54:12 -0800 (PST)
X-Received: by 2002:a05:600c:198c:: with SMTP id t12mr330047wmq.183.1614797651850;
 Wed, 03 Mar 2021 10:54:11 -0800 (PST)
MIME-Version: 1.0
References: <20210303123338.99089-1-hxseverything@gmail.com>
In-Reply-To: <20210303123338.99089-1-hxseverything@gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 3 Mar 2021 13:53:34 -0500
X-Gmail-Original-Message-ID: <CA+FuTSfY0y7Y2XSKO-rqPY5mX83NWgAWbQeVukFA94eJVu2B2g@mail.gmail.com>
Message-ID: <CA+FuTSfY0y7Y2XSKO-rqPY5mX83NWgAWbQeVukFA94eJVu2B2g@mail.gmail.com>
Subject: Re: [PATCH/v4] bpf: add bpf_skb_adjust_room flag BPF_F_ADJ_ROOM_ENCAP_L2_ETH
To:     Xuesen Huang <hxseverything@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>, bpf <bpf@vger.kernel.org>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Xuesen Huang <huangxuesen@kuaishou.com>,
        Zhiyong Cheng <chengzhiyong@kuaishou.com>,
        Li Wang <wangli09@kuaishou.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 3, 2021 at 7:33 AM Xuesen Huang <hxseverything@gmail.com> wrote:
>
> From: Xuesen Huang <huangxuesen@kuaishou.com>
>
> bpf_skb_adjust_room sets the inner_protocol as skb->protocol for packets
> encapsulation. But that is not appropriate when pushing Ethernet header.
>
> Add an option to further specify encap L2 type and set the inner_protocol
> as ETH_P_TEB.
>
> Update test_tc_tunnel to verify adding vxlan encapsulation works with
> this flag.
>
> Suggested-by: Willem de Bruijn <willemb@google.com>
> Signed-off-by: Xuesen Huang <huangxuesen@kuaishou.com>
> Signed-off-by: Zhiyong Cheng <chengzhiyong@kuaishou.com>
> Signed-off-by: Li Wang <wangli09@kuaishou.com>

Thanks for adding the test. Perhaps that is better in a separate patch?

Overall looks great to me.

The patch has not (yet?) arrived on patchwork.

>  enum {
> diff --git a/tools/testing/selftests/bpf/progs/test_tc_tunnel.c b/tools/testing/selftests/bpf/progs/test_tc_tunnel.c
> index 37bce7a..6e144db 100644
> --- a/tools/testing/selftests/bpf/progs/test_tc_tunnel.c
> +++ b/tools/testing/selftests/bpf/progs/test_tc_tunnel.c
> @@ -20,6 +20,14 @@
>  #include <bpf/bpf_endian.h>
>  #include <bpf/bpf_helpers.h>
>
> +#define encap_ipv4(...) __encap_ipv4(__VA_ARGS__, 0)
> +
> +#define encap_ipv4_with_ext_proto(...) __encap_ipv4(__VA_ARGS__)
> +
> +#define encap_ipv6(...) __encap_ipv6(__VA_ARGS__, 0)
> +
> +#define encap_ipv6_with_ext_proto(...) __encap_ipv6(__VA_ARGS__)
> +

Instead of untyped macros, I'd define encap_ipv4 as a function that
calls __encap_ipv4.

And no need for encap_ipv4_with_ext_proto equivalent to __encap_ipv4.

>  static const int cfg_port = 8000;
>
>  static const int cfg_udp_src = 20000;
> @@ -27,11 +35,24 @@
>  #define        UDP_PORT                5555
>  #define        MPLS_OVER_UDP_PORT      6635
>  #define        ETH_OVER_UDP_PORT       7777
> +#define        VXLAN_UDP_PORT          8472
> +
> +#define        EXTPROTO_VXLAN  0x1
> +
> +#define        VXLAN_N_VID     (1u << 24)
> +#define        VXLAN_VNI_MASK  bpf_htonl((VXLAN_N_VID - 1) << 8)
> +#define        VXLAN_FLAGS     0x8
> +#define        VXLAN_VNI       1
>
>  /* MPLS label 1000 with S bit (last label) set and ttl of 255. */
>  static const __u32 mpls_label = __bpf_constant_htonl(1000 << 12 |
>                                                      MPLS_LS_S_MASK | 0xff);
>
> +struct vxlanhdr {
> +       __be32 vx_flags;
> +       __be32 vx_vni;
> +} __attribute__((packed));
> +
>  struct gre_hdr {
>         __be16 flags;
>         __be16 protocol;
> @@ -45,13 +66,13 @@ struct gre_hdr {
>  struct v4hdr {
>         struct iphdr ip;
>         union l4hdr l4hdr;
> -       __u8 pad[16];                   /* enough space for L2 header */
> +       __u8 pad[24];                   /* space for L2 header / vxlan header ... */

could we use something like sizeof(..) instead of a constant?

> @@ -171,14 +197,26 @@ static __always_inline int encap_ipv4(struct __sk_buff *skb, __u8 encap_proto,
>         }
>
>         /* add L2 encap (if specified) */
> +       l2_hdr = (__u8 *)&h_outer + olen;
>         switch (l2_proto) {
>         case ETH_P_MPLS_UC:
> -               *((__u32 *)((__u8 *)&h_outer + olen)) = mpls_label;
> +               *(__u32 *)l2_hdr = mpls_label;
>                 break;
>         case ETH_P_TEB:
> -               if (bpf_skb_load_bytes(skb, 0, (__u8 *)&h_outer + olen,
> -                                      ETH_HLEN))

This is non-standard indentation? Here and elsewhere.

> @@ -249,7 +288,11 @@ static __always_inline int encap_ipv6(struct __sk_buff *skb, __u8 encap_proto,
>                 break;
>         case ETH_P_TEB:
>                 l2_len = ETH_HLEN;
> -               udp_dst = ETH_OVER_UDP_PORT;
> +               if (ext_proto & EXTPROTO_VXLAN) {
> +                       udp_dst = VXLAN_UDP_PORT;
> +                       l2_len += sizeof(struct vxlanhdr);
> +               } else
> +                       udp_dst = ETH_OVER_UDP_PORT;
>                 break;
>         }
>         flags |= BPF_F_ADJ_ROOM_ENCAP_L2(l2_len);
> @@ -267,7 +310,7 @@ static __always_inline int encap_ipv6(struct __sk_buff *skb, __u8 encap_proto,
>                 h_outer.l4hdr.udp.source = __bpf_constant_htons(cfg_udp_src);
>                 h_outer.l4hdr.udp.dest = bpf_htons(udp_dst);
>                 tot_len = bpf_ntohs(iph_inner.payload_len) + sizeof(iph_inner) +
> -                         sizeof(h_outer.l4hdr.udp);
> +                         sizeof(h_outer.l4hdr.udp) + l2_len;

Was this a bug previously?

>                 h_outer.l4hdr.udp.check = 0;
>                 h_outer.l4hdr.udp.len = bpf_htons(tot_len);
>                 break;
> @@ -278,13 +321,24 @@ static __always_inline int encap_ipv6(struct __sk_buff *skb, __u8 encap_proto,
>         }
>
>         /* add L2 encap (if specified) */
> +       l2_hdr = (__u8 *)&h_outer + olen;
>         switch (l2_proto) {
>         case ETH_P_MPLS_UC:
> -               *((__u32 *)((__u8 *)&h_outer + olen)) = mpls_label;
> +               *(__u32 *)l2_hdr = mpls_label;
>                 break;
>         case ETH_P_TEB:
> -               if (bpf_skb_load_bytes(skb, 0, (__u8 *)&h_outer + olen,
> -                                      ETH_HLEN))
> +               flags |= BPF_F_ADJ_ROOM_ENCAP_L2_ETH;

This is a change also for the existing case. Correctly so, I imagine.
But the test used to pass with the wrong protocol?
