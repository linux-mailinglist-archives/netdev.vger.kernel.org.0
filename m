Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AB3931ED8B
	for <lists+netdev@lfdr.de>; Thu, 18 Feb 2021 18:47:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230386AbhBRRpT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Feb 2021 12:45:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233739AbhBRQey (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Feb 2021 11:34:54 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4914C061574
        for <netdev@vger.kernel.org>; Thu, 18 Feb 2021 08:34:04 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id v22so5069437edx.13
        for <netdev@vger.kernel.org>; Thu, 18 Feb 2021 08:34:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BVWV4dOKus+/NHpax1RAhed5wgqUvQ3kszO0RQRvFyg=;
        b=rvdI9LCBmtXsITg7C8vUyKOkaZWIIMzrql7oi9r24WfFv2DLYKRCK1QjTEtj1yT2s6
         AploRG83L+k3VbAEsrrLL+IGse6dZwRLj4cVxJb2BSbPMoprXrAZ8eM6pttjddHrL59a
         6Uj1V+cc+kPT1vJr0nRwalvfCEpWPrBVQT5JVapWFXUWpplrgaAkh2toB54LenMw3Nw0
         QymIgPDfhXVClCnhz+sAnuOPqlDf5AYNElI1CwnMloyI3UKZ416Lh1MJ4ukL5OIWOl5W
         CMXeTFw5m6/Rd5YOacpz53NTtTXBcSttUhHkr3HjHxYC86+XBQEcucGywq9bfN9fehp1
         GY6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BVWV4dOKus+/NHpax1RAhed5wgqUvQ3kszO0RQRvFyg=;
        b=K1dPftQISoUCRcZLn1lEFRWUO3zspfurYgtgV+PzXI56N1FeTo2FqJ25WF7cHnV4Z2
         2Goj4xqZE4wNYYyc3WbjvglETZD0EEL/AxkiSahniMCLUGcq6yyQ6qYTiAI6nlRs3ZAa
         fXG3wZ3ZjPsLCdK+M5oWM7mI7MF51pZfNGcGJqJT75E0MG+AlvaZ+YMTdZkMPGLx7KGh
         RwQDFiGGOPYvILVFgk7eQZXIhUF6hWykaB9pBmmr6ZFF4AhDRI3lRLsBfQxwgapbWKGR
         qyoVj3bH1rEiFZmL+ujSM3DKDBpNnC0duLthorlWp0+qyWvj7FLjS4eimfqUb46vbDmw
         cafQ==
X-Gm-Message-State: AOAM531HM6uj4WY/dYXhgOpYAiokX2hsDYDk4YJ1cPvTfjNT7RsNciPC
        ODeKe0++rHAleMmjQvPXTSFowENlD6s=
X-Google-Smtp-Source: ABdhPJzQU2ZHWB8YIuzjc1M3iLXK4vJO0BcU1ITbW1ccLOmq/bAz2KffYpSAsnQZtv+TESfW5CxDTw==
X-Received: by 2002:a05:6402:2216:: with SMTP id cq22mr4865633edb.125.1613666042725;
        Thu, 18 Feb 2021 08:34:02 -0800 (PST)
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com. [209.85.128.42])
        by smtp.gmail.com with ESMTPSA id n5sm3145497edw.7.2021.02.18.08.34.01
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Feb 2021 08:34:01 -0800 (PST)
Received: by mail-wm1-f42.google.com with SMTP id a207so4538534wmd.1
        for <netdev@vger.kernel.org>; Thu, 18 Feb 2021 08:34:01 -0800 (PST)
X-Received: by 2002:a1c:32c4:: with SMTP id y187mr4387161wmy.120.1613666040595;
 Thu, 18 Feb 2021 08:34:00 -0800 (PST)
MIME-Version: 1.0
References: <CAHmME9o-N5wamS0YbQCHUfFwo3tPD8D3UH=AZpU61oohEtvOKg@mail.gmail.com>
 <20210218160745.2343501-1-Jason@zx2c4.com>
In-Reply-To: <20210218160745.2343501-1-Jason@zx2c4.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Thu, 18 Feb 2021 11:33:22 -0500
X-Gmail-Original-Message-ID: <CA+FuTSeyYti3TMUd2EgQqTAjHjV=EXVZtmY9HUdOP0=U8WRyJA@mail.gmail.com>
Message-ID: <CA+FuTSeyYti3TMUd2EgQqTAjHjV=EXVZtmY9HUdOP0=U8WRyJA@mail.gmail.com>
Subject: Re: [PATCH net v2] net: icmp: pass zeroed opts from
 icmp{,v6}_ndo_send before sending
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        SinYu <liuxyon@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 18, 2021 at 11:08 AM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> The icmp{,v6}_send functions make all sorts of use of skb->cb, casting
> it with IPCB or IP6CB, assuming the skb to have come directly from the
> inet layer. But when the packet comes from the ndo layer, especially
> when forwarded, there's no telling what might be in skb->cb at that
> point. As a result, the icmp sending code risks reading bogus memory
> contents, which can result in nasty stack overflows such as this one
> reported by a user:
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
> This commit fixes the issue by passing an empty IPCB or IP6CB along to
> the functions that actually do the work. For the icmp_send, this was
> already trivial, thanks to __icmp_send providing the plumbing function.
> For icmpv6_send, this required a tiny bit of refactoring to make it
> behave like the v4 case, after which it was straight forward.
>
> Fixes: a2b78e9b2cac ("sunvnet: generate ICMP PTMUD messages for smaller port MTUs")
> Reported-by: SinYu <liuxyon@gmail.com>
> Cc: Willem de Bruijn <willemb@google.com>
> Link: https://lore.kernel.org/netdev/CAF=yD-LOF116aHub6RMe8vB8ZpnrrnoTdqhobEx+bvoA8AsP0w@mail.gmail.com/T/
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>

Thanks for respinning.

Making ipv4 and ipv6 more aligned is a good goal, but more for
net-next than bug fixes that need to be backported to many stable
branches.

Beyond that, I'm not sure this fixes additional cases vs the previous
patch? It uses new on-stack variables instead of skb->cb, which again
is probably good in general, but adds more change than is needed for
the stable fix.

My comment on fixing all callers of  icmp{,v6}_send was wrong, in
hindsight. In most cases IPCB is set correctly before calling those,
so we cannot just zero inside those. If we can only address the case
for icmp{,v6}_ndo_send I think the previous patch introduced less
churn, so is preferable. Unless I'm missing something.

Reminder of two main comments: sufficient to zero sizeof(IPCB..) and
if respinning, please explicitly mention the path that leads to a
stack overflow, as it is not immediately obvious (even from reading
the fix code?).

> ---
>  drivers/net/gtp.c      |  1 -
>  include/linux/icmpv6.h | 26 ++++++++++++++++++++------
>  include/linux/ipv6.h   |  1 -
>  include/net/icmp.h     |  6 +++++-
>  net/ipv4/icmp.c        |  5 +++--
>  net/ipv6/icmp.c        | 18 +++++++++---------
>  net/ipv6/ip6_icmp.c    |  7 ++++---
>  7 files changed, 41 insertions(+), 23 deletions(-)
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
> index 1b3371ae8193..0a383202dd5e 100644
> --- a/include/linux/icmpv6.h
> +++ b/include/linux/icmpv6.h
> @@ -3,6 +3,7 @@
>  #define _LINUX_ICMPV6_H
>
>  #include <linux/skbuff.h>
> +#include <linux/ipv6.h>
>  #include <uapi/linux/icmpv6.h>
>
>  static inline struct icmp6hdr *icmp6_hdr(const struct sk_buff *skb)
> @@ -15,13 +16,16 @@ static inline struct icmp6hdr *icmp6_hdr(const struct sk_buff *skb)
>  #if IS_ENABLED(CONFIG_IPV6)
>
>  typedef void ip6_icmp_send_t(struct sk_buff *skb, u8 type, u8 code, __u32 info,
> -                            const struct in6_addr *force_saddr);
> +                            const struct in6_addr *force_saddr,
> +                            const struct inet6_skb_parm *parm);
>  #if IS_BUILTIN(CONFIG_IPV6)
>  void icmp6_send(struct sk_buff *skb, u8 type, u8 code, __u32 info,
> -               const struct in6_addr *force_saddr);
> -static inline void icmpv6_send(struct sk_buff *skb, u8 type, u8 code, __u32 info)
> +               const struct in6_addr *force_saddr,
> +               const struct inet6_skb_parm *parm);
> +static inline void __icmpv6_send(struct sk_buff *skb, u8 type, u8 code, __u32 info,
> +                                const struct inet6_skb_parm *parm)
>  {
> -       icmp6_send(skb, type, code, info, NULL);
> +       icmp6_send(skb, type, code, info, NULL, parm);
>  }
>  static inline int inet6_register_icmp_sender(ip6_icmp_send_t *fn)
>  {
> @@ -34,18 +38,28 @@ static inline int inet6_unregister_icmp_sender(ip6_icmp_send_t *fn)
>         return 0;
>  }
>  #else
> -extern void icmpv6_send(struct sk_buff *skb, u8 type, u8 code, __u32 info);
> +extern void __icmpv6_send(struct sk_buff *skb, u8 type, u8 code, __u32 info,
> +                         const struct inet6_skb_parm *parm);
>  extern int inet6_register_icmp_sender(ip6_icmp_send_t *fn);
>  extern int inet6_unregister_icmp_sender(ip6_icmp_send_t *fn);
>  #endif
>
> +static inline void icmpv6_send(struct sk_buff *skb, u8 type, u8 code, __u32 info)
> +{
> +       __icmpv6_send(skb, type, code, info, IP6CB(skb));
> +}
> +
>  int ip6_err_gen_icmpv6_unreach(struct sk_buff *skb, int nhs, int type,
>                                unsigned int data_len);
>
>  #if IS_ENABLED(CONFIG_NF_NAT)
>  void icmpv6_ndo_send(struct sk_buff *skb_in, u8 type, u8 code, __u32 info);
>  #else
> -#define icmpv6_ndo_send icmpv6_send
> +static inline void icmpv6_ndo_send(struct sk_buff *skb_in, u8 type, u8 code, __u32 info)
> +{
> +       struct inet6_skb_parm parm = { 0 };
> +       __icmpv6_send(skb_in, type, code, info, &parm);
> +}
>  #endif
>
>  #else
> diff --git a/include/linux/ipv6.h b/include/linux/ipv6.h
> index dda61d150a13..f514a7dd8c9c 100644
> --- a/include/linux/ipv6.h
> +++ b/include/linux/ipv6.h
> @@ -84,7 +84,6 @@ struct ipv6_params {
>         __s32 autoconf;
>  };
>  extern struct ipv6_params ipv6_defaults;
> -#include <linux/icmpv6.h>
>  #include <linux/tcp.h>
>  #include <linux/udp.h>
>
> diff --git a/include/net/icmp.h b/include/net/icmp.h
> index 9ac2d2672a93..fd84adc47963 100644
> --- a/include/net/icmp.h
> +++ b/include/net/icmp.h
> @@ -46,7 +46,11 @@ static inline void icmp_send(struct sk_buff *skb_in, int type, int code, __be32
>  #if IS_ENABLED(CONFIG_NF_NAT)
>  void icmp_ndo_send(struct sk_buff *skb_in, int type, int code, __be32 info);
>  #else
> -#define icmp_ndo_send icmp_send
> +static inline void icmp_ndo_send(struct sk_buff *skb_in, int type, int code, __be32 info)
> +{
> +       struct ip_options opts = { 0 };
> +       __icmp_send(skb_in, type, code, info, &opts);
> +}
>  #endif
>
>  int icmp_rcv(struct sk_buff *skb);
> diff --git a/net/ipv4/icmp.c b/net/ipv4/icmp.c
> index 396b492c804f..616e2dc1c8fa 100644
> --- a/net/ipv4/icmp.c
> +++ b/net/ipv4/icmp.c
> @@ -775,13 +775,14 @@ EXPORT_SYMBOL(__icmp_send);
>  void icmp_ndo_send(struct sk_buff *skb_in, int type, int code, __be32 info)
>  {
>         struct sk_buff *cloned_skb = NULL;
> +       struct ip_options opts = { 0 };
>         enum ip_conntrack_info ctinfo;
>         struct nf_conn *ct;
>         __be32 orig_ip;
>
>         ct = nf_ct_get(skb_in, &ctinfo);
>         if (!ct || !(ct->status & IPS_SRC_NAT)) {
> -               icmp_send(skb_in, type, code, info);
> +               __icmp_send(skb_in, type, code, info, &opts);
>                 return;
>         }
>
> @@ -796,7 +797,7 @@ void icmp_ndo_send(struct sk_buff *skb_in, int type, int code, __be32 info)
>
>         orig_ip = ip_hdr(skb_in)->saddr;
>         ip_hdr(skb_in)->saddr = ct->tuplehash[0].tuple.src.u3.ip;
> -       icmp_send(skb_in, type, code, info);
> +       __icmp_send(skb_in, type, code, info, &opts);
>         ip_hdr(skb_in)->saddr = orig_ip;
>  out:
>         consume_skb(cloned_skb);
> diff --git a/net/ipv6/icmp.c b/net/ipv6/icmp.c
> index f3d05866692e..fd1f896115c1 100644
> --- a/net/ipv6/icmp.c
> +++ b/net/ipv6/icmp.c
> @@ -331,10 +331,9 @@ static int icmpv6_getfrag(void *from, char *to, int offset, int len, int odd, st
>  }
>
>  #if IS_ENABLED(CONFIG_IPV6_MIP6)
> -static void mip6_addr_swap(struct sk_buff *skb)
> +static void mip6_addr_swap(struct sk_buff *skb, const struct inet6_skb_parm *opt)
>  {
>         struct ipv6hdr *iph = ipv6_hdr(skb);
> -       struct inet6_skb_parm *opt = IP6CB(skb);
>         struct ipv6_destopt_hao *hao;
>         struct in6_addr tmp;
>         int off;
> @@ -351,7 +350,7 @@ static void mip6_addr_swap(struct sk_buff *skb)
>         }
>  }
>  #else
> -static inline void mip6_addr_swap(struct sk_buff *skb) {}
> +static inline void mip6_addr_swap(struct sk_buff *skb, const struct inet6_skb_parm *opt) {}
>  #endif
>
>  static struct dst_entry *icmpv6_route_lookup(struct net *net,
> @@ -446,7 +445,8 @@ static int icmp6_iif(const struct sk_buff *skb)
>   *     Send an ICMP message in response to a packet in error
>   */
>  void icmp6_send(struct sk_buff *skb, u8 type, u8 code, __u32 info,
> -               const struct in6_addr *force_saddr)
> +               const struct in6_addr *force_saddr,
> +               const struct inet6_skb_parm *parm)
>  {
>         struct inet6_dev *idev = NULL;
>         struct ipv6hdr *hdr = ipv6_hdr(skb);
> @@ -542,7 +542,7 @@ void icmp6_send(struct sk_buff *skb, u8 type, u8 code, __u32 info,
>         if (!(skb->dev->flags & IFF_LOOPBACK) && !icmpv6_global_allow(net, type))
>                 goto out_bh_enable;
>
> -       mip6_addr_swap(skb);
> +       mip6_addr_swap(skb, parm);
>
>         sk = icmpv6_xmit_lock(net);
>         if (!sk)
> @@ -559,7 +559,7 @@ void icmp6_send(struct sk_buff *skb, u8 type, u8 code, __u32 info,
>                 /* select a more meaningful saddr from input if */
>                 struct net_device *in_netdev;
>
> -               in_netdev = dev_get_by_index(net, IP6CB(skb)->iif);
> +               in_netdev = dev_get_by_index(net, parm->iif);
>                 if (in_netdev) {
>                         ipv6_dev_get_saddr(net, in_netdev, &fl6.daddr,
>                                            inet6_sk(sk)->srcprefs,
> @@ -640,7 +640,7 @@ EXPORT_SYMBOL(icmp6_send);
>   */
>  void icmpv6_param_prob(struct sk_buff *skb, u8 code, int pos)
>  {
> -       icmp6_send(skb, ICMPV6_PARAMPROB, code, pos, NULL);
> +       icmp6_send(skb, ICMPV6_PARAMPROB, code, pos, NULL, IP6CB(skb));
>         kfree_skb(skb);
>  }
>
> @@ -697,10 +697,10 @@ int ip6_err_gen_icmpv6_unreach(struct sk_buff *skb, int nhs, int type,
>         }
>         if (type == ICMP_TIME_EXCEEDED)
>                 icmp6_send(skb2, ICMPV6_TIME_EXCEED, ICMPV6_EXC_HOPLIMIT,
> -                          info, &temp_saddr);
> +                          info, &temp_saddr, IP6CB(skb2));
>         else
>                 icmp6_send(skb2, ICMPV6_DEST_UNREACH, ICMPV6_ADDR_UNREACH,
> -                          info, &temp_saddr);
> +                          info, &temp_saddr, IP6CB(skb2));
>         if (rt)
>                 ip6_rt_put(rt);
>
> diff --git a/net/ipv6/ip6_icmp.c b/net/ipv6/ip6_icmp.c
> index 70c8c2f36c98..5f834ebc09b0 100644
> --- a/net/ipv6/ip6_icmp.c
> +++ b/net/ipv6/ip6_icmp.c
> @@ -40,7 +40,7 @@ void icmpv6_send(struct sk_buff *skb, u8 type, u8 code, __u32 info)
>         rcu_read_lock();
>         send = rcu_dereference(ip6_icmp_send);
>         if (send)
> -               send(skb, type, code, info, NULL);
> +               send(skb, type, code, info, NULL, IP6CB(skb));
>         rcu_read_unlock();
>  }
>  EXPORT_SYMBOL(icmpv6_send);
> @@ -50,6 +50,7 @@ EXPORT_SYMBOL(icmpv6_send);
>  #include <net/netfilter/nf_conntrack.h>
>  void icmpv6_ndo_send(struct sk_buff *skb_in, u8 type, u8 code, __u32 info)
>  {
> +       struct inet6_skb_parm parm = { 0 };
>         struct sk_buff *cloned_skb = NULL;
>         enum ip_conntrack_info ctinfo;
>         struct in6_addr orig_ip;
> @@ -57,7 +58,7 @@ void icmpv6_ndo_send(struct sk_buff *skb_in, u8 type, u8 code, __u32 info)
>
>         ct = nf_ct_get(skb_in, &ctinfo);
>         if (!ct || !(ct->status & IPS_SRC_NAT)) {
> -               icmpv6_send(skb_in, type, code, info);
> +               __icmpv6_send(skb_in, type, code, info, &parm);
>                 return;
>         }
>
> @@ -72,7 +73,7 @@ void icmpv6_ndo_send(struct sk_buff *skb_in, u8 type, u8 code, __u32 info)
>
>         orig_ip = ipv6_hdr(skb_in)->saddr;
>         ipv6_hdr(skb_in)->saddr = ct->tuplehash[0].tuple.src.u3.in6;
> -       icmpv6_send(skb_in, type, code, info);
> +       __icmpv6_send(skb_in, type, code, info, &parm);
>         ipv6_hdr(skb_in)->saddr = orig_ip;
>  out:
>         consume_skb(cloned_skb);
> --
> 2.30.1
>
