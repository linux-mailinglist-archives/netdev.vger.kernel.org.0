Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D24231FBD7
	for <lists+netdev@lfdr.de>; Fri, 19 Feb 2021 16:19:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229802AbhBSPSB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Feb 2021 10:18:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229599AbhBSPSB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Feb 2021 10:18:01 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 735E7C061756
        for <netdev@vger.kernel.org>; Fri, 19 Feb 2021 07:17:19 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id c6so10653994ede.0
        for <netdev@vger.kernel.org>; Fri, 19 Feb 2021 07:17:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jHd0rN1FLnz/czIrhd9IMfnvOfHCdPxO8YyeONdFEKU=;
        b=BVU1Ta3V3j6Gwqc+t+z9cxFHtwHU844ZAW4u0yoY3w6uiMMUVg+xPq4gbyOaw0lsG/
         7yEU9LT7ppmKnzW8MC93hUsOtxt3vEfYLe/2mepmiFZEG25qnC+xKzsw7+NcbiSNerfN
         xAfNAvRQeuaTRVf4glw5IgJruZxaEAZmlbnE/HoDtRpvZ0qOa4gIFszf5lQsmTTVRzmq
         ibdMGuFGpRG2rxMEtGIjA925njO1TlN6Z8sm3gvjOSv+xiEeC+3C6iBRmlw6OF1ukE59
         nBYK7vyyg9nzE1bMDA6rgkRw59RiURzqsmJMGjyBR4ou9hqi6SY5277rgWp6FcRJuPZ5
         LVEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jHd0rN1FLnz/czIrhd9IMfnvOfHCdPxO8YyeONdFEKU=;
        b=DRUWng74UnqZ4Gd8v8AxJ6yhaRkh9aypit1Q7U5RY/l/AwWhp7rf0RQhfI6MzsruM9
         Qe84a1jbiCYHzNzdJ9yE+sHq0t5OxpLRke6B/HsUZoXx/ozAD2JRX+nBrdsh4+hylWGI
         bzPVDavOm+hjwU9umiGlixudcVbLbWywbubWm+uAcIXpW/saw38tuqrfoa7cQdq3dDOe
         134IXpLIQpCf+mypu4KE+zuKnQrZNsZKiYN3KtLKcb/yMZMMU/V0wQWNqiWNtHjIlePY
         4z3bITiNHDJWJ2nx/zL6757O5lCCYqJ7ZBWcRpifR/eUAKy+FO97rH22OY06MdvJm5PP
         WytA==
X-Gm-Message-State: AOAM531T9nhVFkoyVj+F3UqtOZ1DccVgz8P6S/fTlAziC7bFVpR1GofZ
        Ttvngf/TOuJ95jRQRaD649SXzRFKIlU=
X-Google-Smtp-Source: ABdhPJzY9WpGH9BPf/811al2lBf1unKwIiC8uw3a9mE9xjTYsgsZr30mAKHMJ1RAxK6zmRbmUgnXPQ==
X-Received: by 2002:a05:6402:229a:: with SMTP id cw26mr9539367edb.224.1613747837479;
        Fri, 19 Feb 2021 07:17:17 -0800 (PST)
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com. [209.85.221.46])
        by smtp.gmail.com with ESMTPSA id z16sm4631210ejd.102.2021.02.19.07.17.16
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Feb 2021 07:17:16 -0800 (PST)
Received: by mail-wr1-f46.google.com with SMTP id l12so9059586wry.2
        for <netdev@vger.kernel.org>; Fri, 19 Feb 2021 07:17:16 -0800 (PST)
X-Received: by 2002:a5d:4488:: with SMTP id j8mr8417824wrq.12.1613747835864;
 Fri, 19 Feb 2021 07:17:15 -0800 (PST)
MIME-Version: 1.0
References: <20210219022532.2446968-1-Jason@zx2c4.com>
In-Reply-To: <20210219022532.2446968-1-Jason@zx2c4.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Fri, 19 Feb 2021 10:16:38 -0500
X-Gmail-Original-Message-ID: <CA+FuTSfGNLQXfbXcmfXgei3cxWUANk7ooQjJEnDrpdubpzwWPg@mail.gmail.com>
Message-ID: <CA+FuTSfGNLQXfbXcmfXgei3cxWUANk7ooQjJEnDrpdubpzwWPg@mail.gmail.com>
Subject: Re: [PATCH net v4] net: icmp: pass zeroed opts from
 icmp{,v6}_ndo_send before sending
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        SinYu <liuxyon@gmail.com>,
        David L Stevens <david.stevens@oracle.com>,
        "David S . Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 18, 2021 at 9:25 PM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
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
> In icmp_send, skb->cb is cast with IPCB and an ip_options struct is read
> from it. The optlen parameter there is of particular note, as it can
> induce writes beyond bounds. There are quite a few ways that can happen
> in __ip_options_echo. For example:
>
>     // sptr/skb are attacker-controlled skb bytes
>     sptr = skb_network_header(skb);
>     // dptr/dopt points to stack memory allocated by __icmp_send
>     dptr = dopt->__data;
>     // sopt is the corrupt skb->cb in question
>     if (sopt->rr) {
>         optlen  = sptr[sopt->rr+1]; // corrupt skb->cb + skb->data
>         soffset = sptr[sopt->rr+2]; // corrupt skb->cb + skb->data
>         // this now writes potentially attacker-controlled data, over
>         // flowing the stack:
>         memcpy(dptr, sptr+sopt->rr, optlen);
>     }
>
> In the icmpv6_send case, the story is similar, but not as dire, as only
> IP6CB(skb)->iif and IP6CB(skb)->dsthao are used. The dsthao case is
> worse than the iif case, but it is passed to ipv6_find_tlv, which does
> a bit of bounds checking on the value.
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
> Cc: David L Stevens <david.stevens@oracle.com>
> Cc: David S. Miller <davem@davemloft.net>
> Link: https://lore.kernel.org/netdev/CAF=yD-LOF116aHub6RMe8vB8ZpnrrnoTdqhobEx+bvoA8AsP0w@mail.gmail.com/T/
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>

Reviewed-by: Willem de Bruijn <willemb@google.com>

Thanks adding more context, Jason.
