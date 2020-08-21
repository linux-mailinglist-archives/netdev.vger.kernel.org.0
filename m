Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E5BE24D10A
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 10:58:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728401AbgHUI6Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 04:58:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726661AbgHUI6P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Aug 2020 04:58:15 -0400
Received: from mail-oi1-x242.google.com (mail-oi1-x242.google.com [IPv6:2607:f8b0:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E5BEC061385
        for <netdev@vger.kernel.org>; Fri, 21 Aug 2020 01:58:15 -0700 (PDT)
Received: by mail-oi1-x242.google.com with SMTP id z22so968689oid.1
        for <netdev@vger.kernel.org>; Fri, 21 Aug 2020 01:58:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BIVvoIxDscazkjxDxxPv5gvsunWCC5y5O+yvu3GA8zk=;
        b=q2mTGHNbZxMuit35p7qTafE3TeI5U4AIiwPe1TCQ60Bg1PNbHBQqxARTxJFakOXvBL
         EYL6UddvN/5PCURTSIoAebx15zIp/0ZbhZoxJPaEJlBiCR6YJuDEhuTz/pVEhqzHUmV6
         Ajtl9cLGPJLFG+SWjhjUBiHV8nk168vuEKXkilrXxA37Bdi/32/TnZCX8Atkn80dhR44
         Ji7uf9nJ5vTxBXu/whaj64aGyMA6jXeq/1rdeneA1W33lpiCnqvq07WArSTYz+lhbwC9
         U67GIy4wP+RIVPN9WE3SKEUGnaGheHwgAI6PB7EtT2wHLWeW53MoGB4nth+aYtJAjIkh
         TmDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BIVvoIxDscazkjxDxxPv5gvsunWCC5y5O+yvu3GA8zk=;
        b=V4mzwsXO1GNWcPNnu+xjwkVWKeuty7E/VPn6fBBxnhglD0XbgQ48xDTHDhuFrakref
         BRjSTIP5F4vD9RUzkTlFKiKR4cgRQG6vLXHbV+9kOmn3QoBqrYZWGze3JdNzCFtSpUFy
         rork0HoM/gq9FCXUu2wMHcI7s+4rQFCIM2qtuCC/u4Hyy+myalV6ETTbwMk51x6qmhkj
         2Y6r6xOypYMPDDC5FcbcTw+jxAj/WfiK5fctTzlSGkZmxZwyEqWtuGBkaGJQ5AcCpQu9
         v0UrAPXi0Xy3szBvRJaieskoKyuJyE0VdWT9JzcbE5gOHNulL4OVmxQinW/Be9dDTWPw
         zfRg==
X-Gm-Message-State: AOAM531AJPehXl/lTWTUGmjNoKHdkBcAJhUQRO4u6Y2ftqithL9uIalF
        8CmQ34sNrcbce4jiFZjmqmUoRr5IyGkAQGZ6A3xOmg==
X-Google-Smtp-Source: ABdhPJz9iTT3XBj8WRl+ZOCH4zNT0K/w11yAgDx5v19ejdo/Cy91vQs/Hr3vXSnSxwgC/L4S0ps04S39NWudNp4fubQ=
X-Received: by 2002:aca:d4d5:: with SMTP id l204mr1175616oig.70.1598000294457;
 Fri, 21 Aug 2020 01:58:14 -0700 (PDT)
MIME-Version: 1.0
References: <20200821063043.1949509-1-elver@google.com>
In-Reply-To: <20200821063043.1949509-1-elver@google.com>
From:   Marco Elver <elver@google.com>
Date:   Fri, 21 Aug 2020 10:58:02 +0200
Message-ID: <CANpmjNP9R7Ly3YCFD4cy8C0cRuJGqhWfqpqFCJniv4v-07oCHw@mail.gmail.com>
Subject: Re: [PATCH] random32: Use rcuidle variant for tracepoint
To:     Marco Elver <elver@google.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>, kuba@kernel.org,
        Netdev <netdev@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Eric Dumazet <edumazet@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "Paul E. McKenney" <paulmck@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 21 Aug 2020 at 08:30, Marco Elver <elver@google.com> wrote:
> With KCSAN enabled, prandom_u32() may be called from any context,
> including idle CPUs.
>
> Therefore, switch to using trace_prandom_u32_rcuidle(), to avoid various
> issues due to recursion and lockdep warnings when KCSAN and tracing is
> enabled.
>
> Fixes: 94c7eb54c4b8 ("random32: add a tracepoint for prandom_u32()")
> Link: https://lkml.kernel.org/r/20200820155923.3d5c4873@oasis.local.home
> Suggested-by: Steven Rostedt <rostedt@goodmis.org>
> Signed-off-by: Marco Elver <elver@google.com>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> ---
>  lib/random32.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/lib/random32.c b/lib/random32.c
> index 932345323af0..1c5607a411d4 100644
> --- a/lib/random32.c
> +++ b/lib/random32.c
> @@ -83,7 +83,7 @@ u32 prandom_u32(void)
>         u32 res;
>
>         res = prandom_u32_state(state);
> -       trace_prandom_u32(res);
> +       trace_prandom_u32_rcuidle(res);
>         put_cpu_var(net_rand_state);
>

Note that, for KCSAN's use, there is still a small chance this will
mess things up. So, as a short-term fix, I'd appreciate if this patch
will be applied to 5.9, assuming it doesn't mess with the original
usecase.

Longer-term, I think I need to switch KCSAN to use either
prandom_u32_state() or open-code its own prandom function, as the
trace-rcuidle code calls into srcu, which might have other weird
effects if KCSAN instruments that. Still working on the longer-term
fix.

Thanks,
-- Marco
