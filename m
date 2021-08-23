Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26E983F5100
	for <lists+netdev@lfdr.de>; Mon, 23 Aug 2021 21:07:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231276AbhHWTHy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Aug 2021 15:07:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230192AbhHWTHy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Aug 2021 15:07:54 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62FB3C061575;
        Mon, 23 Aug 2021 12:07:11 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id x15so1310458plg.10;
        Mon, 23 Aug 2021 12:07:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OK5raMfr4HWbmDE1X5alE45vtZr48DaZU6LTzAH7JtU=;
        b=iqIWOR6BDMZuOi0JHMrPDX6DiluhbvEKUasTEz90yLmPQp5J1CBmPFVtC9S9KGH2mi
         dNarP1bkbZ9E+pbT5dlX/tp3N61HX8etofXbNKJ+Ce3SC4OQXH8pkhTr6j/KhGxclmeW
         EM2Xyv3iEUFu0Wy/UOxaqzjxaWr8GUdAvBdyBbvOUyrhnPQK3DOJ3LPBab9+tTdH+Drd
         gygQ1DyxQPYo5hoHAOsaPF8L8esf65ffbPtLuHL/JT67IS3GID12tEZcaGG1eE4ahbpH
         7nYp7L3pjKd5PPY3ojlTwI6K6eN8VZas6H0UjbKIt4fRKCLpHbKxrkNokuFlikpbVvQI
         5S8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OK5raMfr4HWbmDE1X5alE45vtZr48DaZU6LTzAH7JtU=;
        b=PQhUgSZyr+Kbkj+hgtFds+QlGPCkBheP3Jy/jIL9x4glLtunq+8Vm0Z5/OsZmuNE4Y
         uC7IdAZB5KjxattrhIE5AkVk8SB4ldPJW/bGM42TbjpC9NxfYlW9S0KI4Bz8RPiSztph
         CTETPC2URK/LF5kso12L2irgQwGnhraPlczNNDOvLzes/jWVH+FCoJYu/FZVMTctW2r+
         wv9OQEEluWegSxnzt566ODBlorr2qMEfsHAb5Q1eyhNa1EKngHc80v4ejZ2oh+eLuThI
         ydzB6BEOIsXn3IfxgbmdHI4d/MfbwenmL/7Fg9om66xeirpRxJW+JdA5g9xRsMP7U/xT
         dNjg==
X-Gm-Message-State: AOAM530Tm1yH53YgIZvIAn/EnDXWI6ml46sZer7yUXzAe10lqv7dzICe
        RP+5jDy+wDxNNNKOqIGw1EnnxMRoI4zCvxHlEQE=
X-Google-Smtp-Source: ABdhPJwwQ/HoA3IM6FT42yI/WViqKbg1vmBItmTwg5Gl0gFYgS+8wjH2+AGaVCI38S8Ed4WwBGodx9xD5qno9FocDvg=
X-Received: by 2002:a17:90a:a091:: with SMTP id r17mr85122pjp.56.1629745630840;
 Mon, 23 Aug 2021 12:07:10 -0700 (PDT)
MIME-Version: 1.0
References: <20210821155327.251284-1-yan2228598786@gmail.com>
In-Reply-To: <20210821155327.251284-1-yan2228598786@gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 23 Aug 2021 12:06:59 -0700
Message-ID: <CAM_iQpWY4Mmf2EUPQDp0v5dj2Ch2KVRirgJXRwLea3pRnkSJVg@mail.gmail.com>
Subject: Re: [PATCH] net/mlx4: tcp_drop replace of tcp_drop_new
To:     jony-one <yan2228598786@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        David Miller <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        dsahern@kernel.org,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, hengqi.chen@gmail.com,
        Yonghong Song <yhs@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Aug 21, 2021 at 8:55 AM jony-one <yan2228598786@gmail.com> wrote:
> @@ -4676,7 +4683,7 @@ static void tcp_ofo_queue(struct sock *sk)
>                 rb_erase(&skb->rbnode, &tp->out_of_order_queue);
>
>                 if (unlikely(!after(TCP_SKB_CB(skb)->end_seq, tp->rcv_nxt))) {
> -                       tcp_drop(sk, skb);
> +                       tcp_drop_new(sk, skb, __func__);

This is very similar to race_kfree_skb():

void kfree_skb(struct sk_buff *skb)
{
        if (!skb_unref(skb))
                return;

        trace_kfree_skb(skb, __builtin_return_address(0));
        __kfree_skb(skb);
}

So... why not something like this?

iff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 3f7bd7ae7d7a..cc840e4552c9 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -4678,6 +4678,7 @@ static bool tcp_ooo_try_coalesce(struct sock *sk,
 static void tcp_drop(struct sock *sk, struct sk_buff *skb)
 {
        sk_drops_add(sk, skb);
+       trace_kfree_skb(skb, __builtin_return_address(0));
        __kfree_skb(skb);
 }

Thanks.
