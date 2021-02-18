Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2DA131ED5E
	for <lists+netdev@lfdr.de>; Thu, 18 Feb 2021 18:37:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234375AbhBRRcx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Feb 2021 12:32:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231809AbhBRO6M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Feb 2021 09:58:12 -0500
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C346C061756
        for <netdev@vger.kernel.org>; Thu, 18 Feb 2021 06:57:32 -0800 (PST)
Received: by mail-ej1-x62d.google.com with SMTP id do6so6116061ejc.3
        for <netdev@vger.kernel.org>; Thu, 18 Feb 2021 06:57:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4AQX705D6g9t6DgI8CvI7HF5mIOe0TX32dQwyabdQng=;
        b=DwsHbKbw/+/9QQ391XOjekFPzT7JAN7PbpOatyU1tXWZ5RnmHhUb20fC0bXPF/iSVr
         fH/KyFHADHJxLgXwRo5HPmdiWQLXshyPiZNnhaW2K9Rv0+JaV3dV6rqwv0G9Sy8OS2U/
         lZFGGy/yn8pjJO9fy05rrxjD2w0e4zEicjQAZUjZFHAYDC0CHpN4vbSwfTkWxKoC5KA4
         1nJULqt7mFOh3MVggHWE3tvcfcygAL6NipmGc3fRfZAWYnRusm8Mq5Wbr2/Q/MrBOj/T
         dM0vADBKkz7v1Nk1TrPFf8j8tUu8fGG8+dMF9ySd1eLwDrkjpI7cTo+6GpoIkfcujW7c
         taxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4AQX705D6g9t6DgI8CvI7HF5mIOe0TX32dQwyabdQng=;
        b=YUbEJ2jFmZ0H0H4JeBTB4H7jD1TWx7EjNSogKKfoF1M93BD/7ioU1CdHNNtd0sNQsg
         TuJp0uW6p5f05O7SzHAXn8Fks0D63G4m+G0MyUBo2ZQPVglAAAmHlBbjXorVX1g80X6G
         DvzBtrjvNXuL1YSZpkev1IC6CDSuwXPT4BG9qHTCVnT5BvYAp6Q5zQ+HOusxnvOGXUAP
         Yyw8g4YV885r7pP091xjW/k+GXMPdHlWNyECSEPmBV9XgZE1iA15DBMkqRMXh5lZgQPh
         w4zobiqXXqJNjQ86ZHkrPZaqNMwqF5wu35BVdP2GNogP1Op0dccSw3bMy6Z0Xc3mPJWA
         xhqg==
X-Gm-Message-State: AOAM530QQuVJqLgKtNvM3PwXpJi6+BQOpV1Vj/Be5YUIJkyhRMCgCd6A
        2iW1j2KdQ7jgxMe4ew+yFKiS20XmJPuFJQ==
X-Google-Smtp-Source: ABdhPJwuA3vYUz6MmaqK5A8SapJFi52aom+jbrnT3w/CgPB3vsKBhf5bD5jB7r1gCjxlnrRyJCIPOw==
X-Received: by 2002:a17:906:c0c9:: with SMTP id bn9mr4390785ejb.318.1613660250320;
        Thu, 18 Feb 2021 06:57:30 -0800 (PST)
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com. [209.85.128.50])
        by smtp.gmail.com with ESMTPSA id t16sm3195646edi.60.2021.02.18.06.57.29
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Feb 2021 06:57:29 -0800 (PST)
Received: by mail-wm1-f50.google.com with SMTP id a207so4245280wmd.1
        for <netdev@vger.kernel.org>; Thu, 18 Feb 2021 06:57:29 -0800 (PST)
X-Received: by 2002:a7b:c5d6:: with SMTP id n22mr3899192wmk.70.1613660248545;
 Thu, 18 Feb 2021 06:57:28 -0800 (PST)
MIME-Version: 1.0
References: <20210218123053.2239986-1-Jason@zx2c4.com>
In-Reply-To: <20210218123053.2239986-1-Jason@zx2c4.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Thu, 18 Feb 2021 09:56:51 -0500
X-Gmail-Original-Message-ID: <CA+FuTSdyovtMVaQfdtpWquawpNDoUKz+qXa+8U8eBTzWVtPXHQ@mail.gmail.com>
Message-ID: <CA+FuTSdyovtMVaQfdtpWquawpNDoUKz+qXa+8U8eBTzWVtPXHQ@mail.gmail.com>
Subject: Re: [PATCH net] net: icmp: zero-out cb in icmp{,v6}_ndo_send before sending
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        SinYu <liuxyon@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 18, 2021 at 7:31 AM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> The icmp{,v6}_send functions make all sorts of use of skb->cb, assuming

Indeed that also casts skb->cb, to read IP6CB(skb)->iif, good catch.

Still, might be good to more precisely detail the relevant bug:
icmp_send casts the cb to an option struct.

        __icmp_send(skb_in, type, code, info, &IPCB(skb_in)->opt);

which is referenced to parse headers by __ip_options_echo, copying
data into stack allocated icmp_param and so overwriting the stack
frame.

> the skb to have come directly from the inet layer. But when the packet
> comes from the ndo layer, especially when forwarded, there's no telling
> what might be in skb->cb at that point. So, icmp{,v6}_ndo_send must zero
> out its skb->cb before passing the packet off to icmp{,v6}_send.
> Otherwise the icmp sending code risks reading bogus memory contents,
> which can result in nasty stack overflows such as this one reported by a
> user:
>
>     panic+0x108/0x2ea
>     __stack_chk_fail+0x14/0x20
>     __icmp_send+0x5bd/0x5c0
>     icmp_ndo_send+0x148/0x160
>
> This is easy to simulate by doing a `memset(skb->cb, 0x41,
> sizeof(skb->cb));` before calling icmp{,v6}_ndo_send, and it's only by
> good fortune and the rarity of icmp sending from that context that we've
> avoided reports like this until now. For example, in KASAN:
>
>     BUG: KASAN: stack-out-of-bounds in __ip_options_echo+0xa0e/0x12b0
>     Write of size 38 at addr ffff888006f1f80e by task ping/89
>     CPU: 2 PID: 89 Comm: ping Not tainted 5.10.0-rc7-debug+ #5
>     Call Trace:
>      dump_stack+0x9a/0xcc
>      print_address_description.constprop.0+0x1a/0x160
>      __kasan_report.cold+0x20/0x38
>      kasan_report+0x32/0x40
>      check_memory_region+0x145/0x1a0
>      memcpy+0x39/0x60
>      __ip_options_echo+0xa0e/0x12b0
>      __icmp_send+0x744/0x1700
>
> Actually, out of the 4 drivers that do this, only gtp zeroed the cb for
> the v4 case, while the rest did not. So this commit actually removes the
> gtp-specific zeroing, while putting the code where it belongs in the
> shared infrastructure of icmp{,v6}_ndo_send.
>
> Fixes: a2b78e9b2cac ("sunvnet: generate ICMP PTMUD messages for smaller port MTUs")

This is from looking at all the callers of icmp{,v6}_ndo_send.

If you look at the callers of icmp{,v6}_send there are even a couple
more. Such as ipoib_cm_skb_reap (which memsets), clip_neigh_error
(which doesn't), various tunnel devices (which live under net/ipv4,
but are called as .ndo_start_xmit downstream from, e.g., segmentation
(SKB_GSO_CB). Which are fixed (all?) in commit 5146d1f15112
("tunnel: Clear IPCB(skb)->opt before dst_link_failure called").

Might be even better to do the memset in __icmp_send/icmp6_send,
rather than in the wrapper. What do you think?

> Reported-by: SinYu <liuxyon@gmail.com>
> Cc: Willem de Bruijn <willemb@google.com>
> Link: https://lore.kernel.org/netdev/CAF=yD-LOF116aHub6RMe8vB8ZpnrrnoTdqhobEx+bvoA8AsP0w@mail.gmail.com/T/
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> ---
>  drivers/net/gtp.c      | 1 -
>  include/linux/icmpv6.h | 6 +++++-
>  include/net/icmp.h     | 6 +++++-
>  net/ipv4/icmp.c        | 2 ++
>  net/ipv6/ip6_icmp.c    | 2 ++
>  5 files changed, 14 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/net/gtp.c b/drivers/net/gtp.c
> index 4c04e271f184..fd3c2d86e48b 100644
> --- a/drivers/net/gtp.c
> +++ b/drivers/net/gtp.c
> @@ -539,7 +539,6 @@ static int gtp_build_skb_ip4(struct sk_buff *skb, struct net_device *dev,
>         if (!skb_is_gso(skb) && (iph->frag_off & htons(IP_DF)) &&
>             mtu < ntohs(iph->tot_len)) {
>                 netdev_dbg(dev, "packet too big, fragmentation needed\n");
> -               memset(IPCB(skb), 0, sizeof(*IPCB(skb)));
>                 icmp_ndo_send(skb, ICMP_DEST_UNREACH, ICMP_FRAG_NEEDED,
>                               htonl(mtu));
>                 goto err_rt;
> diff --git a/include/linux/icmpv6.h b/include/linux/icmpv6.h
> index 1b3371ae8193..87d434fc98a3 100644
> --- a/include/linux/icmpv6.h
> +++ b/include/linux/icmpv6.h
> @@ -45,7 +45,11 @@ int ip6_err_gen_icmpv6_unreach(struct sk_buff *skb, int nhs, int type,
>  #if IS_ENABLED(CONFIG_NF_NAT)
>  void icmpv6_ndo_send(struct sk_buff *skb_in, u8 type, u8 code, __u32 info);
>  #else
> -#define icmpv6_ndo_send icmpv6_send
> +static inline void icmpv6_ndo_send(struct sk_buff *skb_in, u8 type, u8 code, __u32 info)
> +{
> +       memset(skb_in->cb, 0, sizeof(skb_in->cb));
> +       icmpv6_send(skb_in, type, code, info);
> +}
>  #endif
>
>  #else
> diff --git a/include/net/icmp.h b/include/net/icmp.h
> index 9ac2d2672a93..4bb404c9abc8 100644
> --- a/include/net/icmp.h
> +++ b/include/net/icmp.h
> @@ -46,7 +46,11 @@ static inline void icmp_send(struct sk_buff *skb_in, int type, int code, __be32
>  #if IS_ENABLED(CONFIG_NF_NAT)
>  void icmp_ndo_send(struct sk_buff *skb_in, int type, int code, __be32 info);
>  #else
> -#define icmp_ndo_send icmp_send
> +static inline void icmp_ndo_send(struct sk_buff *skb_in, int type, int code, __be32 info)
> +{
> +       memset(skb_in->cb, 0, sizeof(skb_in->cb));

as in the line removed in gtp_build_skb_ip4, it would be sufficient to
memset sizeof(*IPCB(skb)). I don't know if you chose to clear the full
40B on purpose.


> +       icmp_send(skb_in, type, code, info);
> +}
>  #endif
>
>  int icmp_rcv(struct sk_buff *skb);
> diff --git a/net/ipv4/icmp.c b/net/ipv4/icmp.c
> index 396b492c804f..ecf080532291 100644
> --- a/net/ipv4/icmp.c
> +++ b/net/ipv4/icmp.c
> @@ -781,6 +781,7 @@ void icmp_ndo_send(struct sk_buff *skb_in, int type, int code, __be32 info)
>
>         ct = nf_ct_get(skb_in, &ctinfo);
>         if (!ct || !(ct->status & IPS_SRC_NAT)) {
> +               memset(skb_in->cb, 0, sizeof(skb_in->cb));
>                 icmp_send(skb_in, type, code, info);
>                 return;
>         }
> @@ -796,6 +797,7 @@ void icmp_ndo_send(struct sk_buff *skb_in, int type, int code, __be32 info)
>
>         orig_ip = ip_hdr(skb_in)->saddr;
>         ip_hdr(skb_in)->saddr = ct->tuplehash[0].tuple.src.u3.ip;
> +       memset(skb_in->cb, 0, sizeof(skb_in->cb));
>         icmp_send(skb_in, type, code, info);
>         ip_hdr(skb_in)->saddr = orig_ip;
>  out:
> diff --git a/net/ipv6/ip6_icmp.c b/net/ipv6/ip6_icmp.c
> index 70c8c2f36c98..ddc28be8a65d 100644
> --- a/net/ipv6/ip6_icmp.c
> +++ b/net/ipv6/ip6_icmp.c
> @@ -57,6 +57,7 @@ void icmpv6_ndo_send(struct sk_buff *skb_in, u8 type, u8 code, __u32 info)
>
>         ct = nf_ct_get(skb_in, &ctinfo);
>         if (!ct || !(ct->status & IPS_SRC_NAT)) {
> +               memset(skb_in->cb, 0, sizeof(skb_in->cb));
>                 icmpv6_send(skb_in, type, code, info);
>                 return;
>         }
> @@ -72,6 +73,7 @@ void icmpv6_ndo_send(struct sk_buff *skb_in, u8 type, u8 code, __u32 info)
>
>         orig_ip = ipv6_hdr(skb_in)->saddr;
>         ipv6_hdr(skb_in)->saddr = ct->tuplehash[0].tuple.src.u3.in6;
> +       memset(skb_in->cb, 0, sizeof(skb_in->cb));
>         icmpv6_send(skb_in, type, code, info);
>         ipv6_hdr(skb_in)->saddr = orig_ip;
>  out:
> --
> 2.30.1
>
