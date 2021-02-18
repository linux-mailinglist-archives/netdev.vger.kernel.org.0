Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E01131F212
	for <lists+netdev@lfdr.de>; Thu, 18 Feb 2021 23:08:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230121AbhBRWHW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Feb 2021 17:07:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbhBRWHU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Feb 2021 17:07:20 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE87DC061756
        for <netdev@vger.kernel.org>; Thu, 18 Feb 2021 14:06:39 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id ly28so8099444ejb.13
        for <netdev@vger.kernel.org>; Thu, 18 Feb 2021 14:06:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9nLwcukSUiyM9yanBYnq2PilmgchJztci7Qxaxjho4s=;
        b=Ncu08+RdwepKWUgqkCdxRirnSzQSBscLa75hDw0Vp1HdQIyyUJeHa0oXGuZmG2jpCV
         15VDD1emzqYAs87kKlnTXTyzFK2MzSmwnRouAG54s84qdv0746zy+93peA2yLdb5jCWY
         AYSyDqpLWZyc5jYu0Bap1trg+sVFIDlQbVaMdazJed0yUK71i+gNz9Q0ePuL3VbS5Q99
         VyPzi20AStGOIPYA1PJIDGcOHjSq7vQ/WlrCK2wKoYr9aoZ76TAAWactPzdxghq7LKFK
         qixlVOeZLGuAZoASGGQ+U63JvZCmuco6paj8bXEdxZ6Sg6UUPmZEAwlgWrUcjUz05lA+
         lE6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9nLwcukSUiyM9yanBYnq2PilmgchJztci7Qxaxjho4s=;
        b=Q5az040OTRd8UW56yyLGHr5ABpirAypMCPvsDqZUImDPFrvSu3Be5u7GlpCY4uqBtX
         HKvnKYByXcRuP91btxdjIRHA5aodPMZaoIWRdNu2quDtO+AJNhdIrdS7lQ6WNQNwZ0Oj
         7bXYo+Rlsu5WNpwgP8YerlaWPUeQEInOADawG6UE93+IPP5tQ9DAX5MbToApauqDeUTJ
         l5kOA0R8jC9sq6xsxqkucd7D8OXYSg45uw8DwkCrEtX7PquQNfOaYxobQDgHGKDstUEh
         yV5Uw8bYvaxJ8wQmYz9LGWM0GrNI5rj3a0QGKZo1pmXzeLazLdGax9yRK2yg/PaLps8/
         YS9Q==
X-Gm-Message-State: AOAM532VV3dNeZmV1Wre3VP8edRwnVct42XtxOgnZB/X9QTfbSomw4FV
        vnQc7TPLZaAeHWjy4Jo11KaUp9bJHkywctFtv6jddmpb
X-Google-Smtp-Source: ABdhPJxih1ukVBIJcsirbgWxpYC0e0O63Y6TbPFu95JWZK9Ccm03x4UPEDf8bK2/kxxNpPlm6k40wF19zoPJ9DECGMk=
X-Received: by 2002:a17:906:11d5:: with SMTP id o21mr5793749eja.504.1613685998277;
 Thu, 18 Feb 2021 14:06:38 -0800 (PST)
MIME-Version: 1.0
References: <CAHmME9oyv+nWk2r3mcVrfdXW_aiex67nSvGiiqLmPOv=RHnhfQ@mail.gmail.com>
 <20210218203404.2429186-1-Jason@zx2c4.com>
In-Reply-To: <20210218203404.2429186-1-Jason@zx2c4.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Thu, 18 Feb 2021 17:06:01 -0500
Message-ID: <CAF=yD-K-8Gacsnch-1nTh11QFaXkfCj4TTj=Or6PF+6PyhbKiQ@mail.gmail.com>
Subject: Re: [PATCH net v3] net: icmp: pass zeroed opts from
 icmp{,v6}_ndo_send before sending
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        SinYu <liuxyon@gmail.com>, Willem de Bruijn <willemb@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 18, 2021 at 3:39 PM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> The icmp{,v6}_send functions make all sorts of use of skb->cb, casting

Again, if respinning, please briefly describe the specific buggy code
path. I think it's informative and cannot be gleaned from the fix.

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
> ---

> -#define icmpv6_ndo_send icmpv6_send
> +static inline void icmpv6_ndo_send(struct sk_buff *skb_in, u8 type, u8 code, __u32 info)
> +{
> +       struct inet6_skb_parm parm = { 0 };
> +       __icmpv6_send(skb_in, type, code, info, &parm);
> +}
>  #endif

> -void icmpv6_send(struct sk_buff *skb, u8 type, u8 code, __u32 info)
> +void __icmpv6_send(struct sk_buff *skb, u8 type, u8 code, __u32 info,
> +                  const struct inet6_skb_parm *parm)
>  {
>         ip6_icmp_send_t *send;
>
>         rcu_read_lock();
>         send = rcu_dereference(ip6_icmp_send);
>         if (send)
> -               send(skb, type, code, info, NULL);
> +               send(skb, type, code, info, NULL, IP6CB(skb));

This should be parm.

>  #if IS_ENABLED(CONFIG_NF_NAT)
>  #include <net/netfilter/nf_conntrack.h>
>  void icmpv6_ndo_send(struct sk_buff *skb_in, u8 type, u8 code, __u32 info)
>  {
> +       struct inet6_skb_parm parm = { 0 };
>         struct sk_buff *cloned_skb = NULL;
>         enum ip_conntrack_info ctinfo;
>         struct in6_addr orig_ip;
> @@ -57,7 +59,7 @@ void icmpv6_ndo_send(struct sk_buff *skb_in, u8 type, u8 code, __u32 info)
>
>         ct = nf_ct_get(skb_in, &ctinfo);
>         if (!ct || !(ct->status & IPS_SRC_NAT)) {
> -               icmpv6_send(skb_in, type, code, info);
> +               __icmpv6_send(skb_in, type, code, info, &parm);
>                 return;
>         }
>
> @@ -72,7 +74,7 @@ void icmpv6_ndo_send(struct sk_buff *skb_in, u8 type, u8 code, __u32 info)
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
